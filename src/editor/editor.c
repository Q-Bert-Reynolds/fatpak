// src/editor/editor.c
// NOTE: no static initializers (_GSINIT doesn't run) and no int multiply/divide (no SDCC libs)
#include "editor.h"

#define PADF_DOWN   0x80
#define PADF_UP     0x40
#define PADF_LEFT   0x20
#define PADF_RIGHT  0x10
#define PADF_START  0x08
#define PADF_SELECT 0x04
#define PADF_B      0x02
#define PADF_A      0x01
#define PADF_DPAD   0xF0

#define MARKER         13 // ▶
#define FILE_NAME_SIZE 13 // 8.3 + 0
#define BASE_NAME_SIZE 8
#define FILE_LIST_MAX  (TB_ROWS - 2)
#define CANCEL         0xFF

// FRESULT codes (src/fatfs/lib/ff.h)
#define FR_NOT_READY     3
#define FR_DENIED        7
#define FR_NO_FILESYSTEM 13

#define PAD_REPEAT_DELAY 20
#define PAD_REPEAT_RATE  4
#define CURSOR_BLINK     30

unsigned int cursor;
unsigned int top;
unsigned char want_col;
unsigned char pad_timer;
unsigned char blink_timer;
unsigned char dirty;
unsigned char osk_shown;
unsigned char osk_layer;
unsigned char osk_x;
unsigned char osk_y;
unsigned char modified;
unsigned char font;
char file_name[FILE_NAME_SIZE]; // current file, empty for new text
char file_list[FILE_LIST_MAX][FILE_NAME_SIZE];

static const char menu_items[][FILE_NAME_SIZE] = {"OPEN", "SAVE", "SAVE AS", "NEW", "FONT"};
static const char discard_items[][FILE_NAME_SIZE] = {"NO", "YES"};

static void Render(void);

// is row the last visual row, given its next row start
static unsigned char IsLastRow(unsigned int row, unsigned int next) {
  return next == tb_Length() && (next == row || tb_GetChar(next - 1) != ASCII_LF);
}

// position in row closest to col
static unsigned int PosAtCol(unsigned int row, unsigned char col) {
  unsigned int next = tb_NextRow(row);
  unsigned int pos = row;
  while (col && pos != next) {
    if (tb_GetChar(pos) == ASCII_LF) return pos;
    ++pos;
    --col;
  }
  if (pos == next && !IsLastRow(row, next)) --pos; // stay on wrapped row
  return pos;
}

static void MoveUp(void) {
  unsigned int row = tb_RowStart(cursor);
  if (row == 0) cursor = 0;
  else cursor = PosAtCol(tb_RowStart(row - 1), want_col);
}

static void MoveDown(void) {
  unsigned int row = tb_RowStart(cursor);
  unsigned int next = tb_NextRow(row);
  if (IsLastRow(row, next)) cursor = tb_Length();
  else cursor = PosAtCol(next, want_col);
}

// before the space or line feed that ends the row, otherwise after the last char
static void MoveEnd(void) {
  unsigned int row = tb_RowStart(cursor);
  unsigned int next = tb_NextRow(row);
  unsigned char c;
  cursor = next;
  if (IsLastRow(row, next)) return;
  c = tb_GetChar(next - 1);
  if (c == ' ' || c == ASCII_LF) --cursor;
}

static void HandleKey(unsigned char key, unsigned char mods) {
  unsigned char i;
  if (mods & (KB_MOD_CTRL | KB_MOD_ALT | KB_MOD_SUPER)) return; // TODO: shortcuts

  switch (key) {
    case KEY_UP: MoveUp(); return;
    case KEY_DOWN: MoveDown(); return;
    case KEY_PAGE_UP: for (i = tb_rows - 1; i; --i) MoveUp(); return;
    case KEY_PAGE_DOWN: for (i = tb_rows - 1; i; --i) MoveDown(); return;
    case KEY_LEFT: if (cursor) --cursor; break;
    case KEY_RIGHT: if (cursor != tb_Length()) ++cursor; break;
    case KEY_HOME: cursor = tb_RowStart(cursor); break;
    case KEY_END: MoveEnd(); break;
    case KEY_BACKSPACE:
      if (cursor && tb_Delete(--cursor)) modified = 1;
      break;
    case KEY_DELETE:
      if (tb_Delete(cursor)) modified = 1;
      break;
    case KEY_ESCAPE:
    case KEY_INSERT: return;
    default:
      if (key < ' ' && key != ASCII_TAB && key != ASCII_LF) return;
      if (key >= KEY_LEFT && key < 0xA0) return; // unprintable in Latin-1
      if (tb_Insert(cursor, key)) {
        ++cursor;
        modified = 1;
      }
  }
  want_col = (unsigned char)(cursor - tb_RowStart(cursor));
}

// returns held d-pad buttons when pressed and while repeating
static unsigned char DpadRepeat(unsigned char pressed) {
  unsigned char held = (button_state | pressed) & PADF_DPAD;
  if (!held) return 0;
  if (pressed & PADF_DPAD) pad_timer = PAD_REPEAT_DELAY;
  else if (--pad_timer) return 0;
  else pad_timer = PAD_REPEAT_RATE;
  return held;
}

static void ToggleOSK(void) {
  osk_shown = !osk_shown;
  tb_rows = osk_shown ? TB_ROWS - OSK_ROWS : TB_ROWS;
  if (osk_shown) {
    OSKDraw(osk_layer);
    OSKSelect(osk_x, osk_y);
  }
  OSKShow(osk_shown);
  dirty = 1;
}

static void SetOSKLayer(unsigned char layer) {
  osk_layer = osk_layer == layer ? OSK_LOWER : layer;
  OSKDraw(osk_layer);
  dirty = 1;
}

static unsigned char PressOSKKey(void) {
  unsigned char key;
  if (osk_y == OSK_ROWS - 1) {
    if (osk_x == 0) SetOSKLayer(OSK_SHIFT);
    else if (osk_x == 1) SetOSKLayer(OSK_SYMBOLS);
    else if (osk_x == OSK_COLS - 3) return KEY_MENU;
    else if (osk_x == OSK_COLS - 2) return KEY_LEFT;
    else if (osk_x == OSK_COLS - 1) return KEY_RIGHT;
    else return ' ';
    return KEY_NONE;
  }
  key = OSKGetKey(osk_layer, (osk_y << 3) + (osk_y << 1) + osk_x);
  if (osk_layer == OSK_SHIFT) SetOSKLayer(OSK_SHIFT); // shift is one shot
  return key;
}

static void MoveOSKSelection(unsigned char held) {
  if (held & PADF_UP) osk_y = osk_y ? osk_y - 1 : OSK_ROWS - 1;
  else if (held & PADF_DOWN) osk_y = osk_y == OSK_ROWS - 1 ? 0 : osk_y + 1;
  if (held & PADF_LEFT) osk_x = osk_x ? osk_x - 1 : OSK_COLS - 1;
  else if (held & PADF_RIGHT) osk_x = osk_x == OSK_COLS - 1 ? 0 : osk_x + 1;
  OSKSelect(osk_x, osk_y);
}

// SELECT = on screen keyboard, B = backspace, START = enter
// d-pad moves the cursor, or the keyboard selection when it's shown (A = type)
static unsigned char PadKey(void) {
  unsigned char pressed = PadPressed();
  unsigned char held;
  if (pressed & PADF_SELECT) ToggleOSK();
  if (pressed & PADF_B) return KEY_BACKSPACE;
  if (pressed & PADF_START) return KEY_ENTER;
  if (osk_shown && (pressed & PADF_A)) return PressOSKKey();
  held = DpadRepeat(pressed);
  if (!held) return KEY_NONE;
  if (osk_shown) {
    MoveOSKSelection(held);
    return KEY_NONE;
  }
  if (held & PADF_UP) return KEY_UP;
  if (held & PADF_DOWN) return KEY_DOWN;
  if (held & PADF_LEFT) return KEY_LEFT;
  return KEY_RIGHT;
}

// waits a frame, returns a key from the keyboard or d-pad (A, START = enter, B = escape)
static unsigned char MenuKey(void) {
  unsigned char key, pressed, held;
  WaitFrame();
  if ((key = (unsigned char)KBPopEvent())) return key;
  pressed = PadPressed();
  if (pressed & (PADF_A | PADF_START)) return KEY_ENTER;
  if (pressed & PADF_B) return KEY_ESCAPE;
  held = DpadRepeat(pressed);
  if (held & PADF_UP) return KEY_UP;
  if (held & PADF_DOWN) return KEY_DOWN;
  return KEY_NONE;
}

static char* RowAddress(unsigned char row) {
  unsigned int offset = row;
  return (char*)tile_buffer + (offset << 5) + (offset << 3); // row * TB_STRIDE
}

// draws text at col on row, clearing the rest of the row
static void DrawRow(unsigned char row, unsigned char col, const char* text) {
  char* dest = RowAddress(row);
  unsigned char i;
  for (i = 0; i < TB_STRIDE; ++i) dest[i] = ' ';
  for (dest += col; *text && col < TB_STRIDE; ++col) *dest++ = *text++;
}

static void ClearScreen(void) {
  unsigned char row;
  for (row = 0; row < TB_ROWS; ++row) DrawRow(row, 0, "");
}

// hides the on screen keyboard and cursor for full screen UI, redraws the text afterwards
static void BeginFullScreen(void) {
  EditorShowCursor(0);
  if (osk_shown) OSKShow(0);
  tb_rows = TB_ROWS;
  dirty = 1;
}

static void EndFullScreen(void) {
  if (osk_shown) {
    tb_rows = TB_ROWS - OSK_ROWS;
    OSKDraw(osk_layer);
    OSKSelect(osk_x, osk_y);
    OSKShow(1);
  }
}

// shows a list of FILE_NAME_SIZE strings, returns the chosen index or CANCEL
static unsigned char Choose(const char* title, const char* items, unsigned char count) {
  unsigned char i, key, selected = 0;
  BeginFullScreen();
  while (1) {
    ClearScreen();
    DrawRow(0, 0, title);
    for (i = 0; i < count; ++i) {
      DrawRow(i + 2, 2, items + (i << 3) + (i << 2) + i); // i * FILE_NAME_SIZE
      if (i == selected) RowAddress(i + 2)[1] = MARKER;
    }
    EditorDraw(tb_rows);
    while (!(key = MenuKey()));
    if (key == KEY_UP) selected = selected ? selected - 1 : count - 1;
    else if (key == KEY_DOWN) selected = selected == count - 1 ? 0 : selected + 1;
    else if (key == KEY_ENTER) break;
    else if (key == KEY_ESCAPE) {
      selected = CANCEL;
      break;
    }
  }
  EndFullScreen();
  return selected;
}

// shows text on the last visible row until a key is pressed
static void ShowMessage(const char* text) {
  Render();
  EditorShowCursor(0);
  DrawRow(tb_rows - 1, 0, text);
  EditorDraw(tb_rows);
  while (!MenuKey());
  dirty = 1;
}

static void ShowError(unsigned char result, const char* denied) {
  char text[12] = "SD ERROR ";
  if (result == FR_NOT_READY) ShowMessage("NO SD CARD");
  else if (result == FR_NO_FILESYSTEM) ShowMessage("NO FAT VOLUME");
  else if (result == FR_DENIED) ShowMessage(denied);
  else {
    text[9] = '0';
    while (result >= 10) {
      ++text[9];
      result -= 10;
    }
    text[10] = '0' + result;
    text[11] = 0;
    ShowMessage(text);
  }
}

static void CopyName(char* dest, const char* src) {
  while ((*dest++ = *src++));
}

// returns 1 if there are no unsaved changes or the user wants to lose them
static unsigned char CanDiscard(void) {
  return !modified || Choose("DISCARD CHANGES?", discard_items[0], 2) == 1;
}

static void ResetCursor(void) {
  cursor = 0;
  top = 0;
  want_col = 0;
  modified = 0;
  dirty = 1;
}

static void NewFile(void) {
  if (!CanDiscard()) return;
  tb_Clear();
  file_name[0] = 0;
  fs_crlf = 0;
  ResetCursor();
}

static void OpenFile(void) {
  unsigned char count = 0, selected, result;
  if (!CanDiscard()) return;
  if ((result = FileMount()) || (result = FileOpenDir())) {
    ShowError(result, "");
    return;
  }
  while (count < FILE_LIST_MAX && FileNext(file_list[count])) ++count;
  if (!count) {
    ShowMessage("NO .TXT FILES");
    return;
  }
  selected = Choose("OPEN", file_list[0], count);
  if (selected == CANCEL) return;
  result = FileLoad(file_list[selected]);
  CopyName(file_name, file_list[selected]);
  ResetCursor();
  if (result) ShowError(result, "FILE TOO BIG");
}

// asks for an 8 character name, sets file_name to NAME.TXT, returns 0 if cancelled
static unsigned char AskFileName(void) {
  char name[BASE_NAME_SIZE + 1];
  char text[TB_COLS + 1];
  unsigned char length = 0, key, i;
  for (; file_name[length] && file_name[length] != '.'; ++length) name[length] = file_name[length];
  Render();
  EditorShowCursor(0);
  while (1) {
    CopyName(text, "SAVE AS ");
    for (i = 0; i < length; ++i) text[8 + i] = name[i];
    CopyName(text + 8 + length, "_.TXT");
    DrawRow(0, 0, text);
    EditorDraw(tb_rows);
    do {
      WaitFrame();
      key = (unsigned char)KBPopEvent();
      if (!key) key = PadKey();
    } while (!key);
    if (key == KEY_ENTER && length) break;
    if (key == KEY_ESCAPE || (key == KEY_BACKSPACE && !length)) {
      dirty = 1;
      return 0;
    }
    if (key == KEY_BACKSPACE) --length;
    if (key >= 'a' && key <= 'z') key -= 'a' - 'A';
    if (length < BASE_NAME_SIZE && ((key >= 'A' && key <= 'Z') || (key >= '0' && key <= '9') || key == '_' || key == '-')) {
      name[length++] = key;
    }
  }
  for (i = 0; i < length; ++i) file_name[i] = name[i];
  CopyName(file_name + length, ".TXT");
  dirty = 1;
  return 1;
}

static void SaveFile(unsigned char ask) {
  unsigned char result;
  if ((ask || !file_name[0]) && !AskFileName()) return;
  if ((result = FileMount()) || (result = FileSave(file_name))) {
    ShowError(result, "DISK FULL");
    return;
  }
  modified = 0;
  ShowMessage("SAVED");
}

// switches between the fixed and variable width fonts
static void ToggleFont(void) {
  font = font == FONT_VWF ? FONT_MONO : FONT_VWF;
  SetFont(font);
  dirty = 1;
}

static void FileMenu(void) {
  switch (Choose("MENU", menu_items[0], 5)) {
    case 0: OpenFile(); break;
    case 1: SaveFile(0); break;
    case 2: SaveFile(1); break;
    case 3: NewFile(); break;
    case 4: ToggleFont(); break;
  }
}

// shortcuts: escape or the keyboard's menu key, ctrl + O, S, N, F
static unsigned char HandleFileKey(unsigned char key, unsigned char mods) {
  if (key == KEY_MENU || key == KEY_ESCAPE) FileMenu();
  else if (!(mods & KB_MOD_CTRL)) return 0;
  else if (key == 'o' || key == 'O') OpenFile();
  else if (key == 's' || key == 'S') SaveFile(0);
  else if (key == 'n' || key == 'N') NewFile();
  else if (key == 'f' || key == 'F') ToggleFont();
  dirty = 1;
  return 1;
}

static void Render(void) {
  tb_find = cursor;
  tb_Render(top);
}

// renders, scrolling to keep the cursor visible
static void Refresh(void) {
  unsigned int row, bottom;
  unsigned char i;
  if (top > tb_Length()) top = tb_Length();
  top = tb_RowStart(top); // wrapping may have changed
  Render();
  if (tb_found_row == 0xFF) {
    row = tb_RowStart(cursor);
    if (cursor < top) top = row;
    else { // scroll until the cursor is on the last row, jump if it's more than a screen away
      bottom = tb_bottom;
      for (i = tb_rows; i; --i) {
        top = tb_NextRow(top);
        if (bottom == row) break;
        bottom = tb_NextRow(bottom);
      }
      if (!i) top = row;
    }
    Render();
  }
  EditorDraw(tb_rows);
  blink_timer = 0;
  EditorShowCursor(1);
}

void Editor(void) {
  unsigned int event;
  unsigned char key;

  EditorSetup();
  cursor = 0;
  top = 0;
  want_col = 0;
  pad_timer = 0;
  modified = 0;
  font = FONT_VWF;
  file_name[0] = 0;
  fs_crlf = 0;
  osk_shown = 0;
  osk_layer = OSK_LOWER;
  osk_x = 0;
  osk_y = 0;
  tb_rows = TB_ROWS;
  Refresh();

  while (1) {
    WaitFrame();
    while ((key = (unsigned char)(event = KBPopEvent()))) {
      if (!HandleFileKey(key, (unsigned char)(event >> 8))) HandleKey(key, (unsigned char)(event >> 8));
      dirty = 1;
    }
    if ((key = PadKey())) {
      if (!HandleFileKey(key, 0)) HandleKey(key, 0);
      dirty = 1;
    }
    if (dirty) {
      Refresh();
      dirty = 0;
    }
    else if (++blink_timer == CURSOR_BLINK) EditorShowCursor(0);
    else if (blink_timer == CURSOR_BLINK + CURSOR_BLINK) {
      EditorShowCursor(1);
      blink_timer = 0;
    }
  }
}
