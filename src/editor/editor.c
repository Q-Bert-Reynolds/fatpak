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
#define BG_MAP_ROWS      32
#define LCDC_TILES_8000  0x10 // LCDCF_BG8000

// FRESULT codes (src/fatfs/lib/ff.h)
#define FR_NOT_READY     3
#define FR_DENIED        7
#define FR_NO_FILESYSTEM 13

#define PAD_REPEAT_DELAY 20
#define PAD_REPEAT_RATE  4
#define CURSOR_BLINK     30
#define NORMALIZE_DELAY  30 // frames without input before closing the gap

unsigned int cursor;
unsigned int top;
unsigned int anchor; // other end of the selection
unsigned char selecting;
unsigned int sel_start; // set by GetSelection
unsigned int sel_end;
unsigned char want_x; // pixel x up and down try to keep
unsigned char keep_x;
unsigned char moved; // cursor moved, text didn't change
unsigned char redraw; // rendered rows changed, text didn't
unsigned char ring_top; // BG map row of screen row 0
unsigned char edited; // one edit at edit_pos, rows from edit_row need rendering
unsigned char edit_row;
unsigned int edit_pos;
signed char edit_delta;
unsigned char pad_timer;
unsigned char blink_timer;
unsigned char dirty;
unsigned char osk_shown;
unsigned char osk_layer;
unsigned char osk_x;
unsigned char osk_y;
unsigned char modified;
unsigned char font;
unsigned char everdrive; // text is saved to SD, otherwise SRAM is the only copy so the gap is closed when idle
unsigned char idle_frames;
unsigned char normalized;
char file_name[FILE_NAME_SIZE]; // current file, empty for new text
char file_list[FILE_LIST_MAX][FILE_NAME_SIZE];

static const char menu_items[][FILE_NAME_SIZE] = {"OPEN", "SAVE", "SAVE AS", "NEW", "FONT"};
static const char discard_items[][FILE_NAME_SIZE] = {"NO", "YES"};

static void Render(void);

static char* RowAddress(unsigned char row);
static void ShowMessage(const char* text);

// rendered row pos is on, 0xFF if it isn't on screen
static unsigned char FindRow(unsigned int pos) {
  unsigned char row;
  for (row = 0; row < tb_rows; ++row) {
    if (pos < tb_row_starts[row]) return 0xFF;
    if (pos < tb_row_starts[row + 1]) return row;
  }
  return pos == tb_Length() ? tb_end_row : 0xFF;
}

static unsigned char GetSelection(void);

// moves the cursor sprite to the cursor, returns 0 if it isn't on screen
static unsigned char PlaceCursor(void) {
  unsigned char row = FindRow(cursor);
  unsigned int col;
  if (row == 0xFF) return 0;
  col = cursor - tb_row_starts[row];
  if (col > tb_row_counts[row]) col = tb_row_counts[row]; // hanging spaces
  tb_found_row = row;
  tb_found_col = (unsigned char)col;
  if (!keep_x) want_x = RenderCursorX(tb_found_col);
  keep_x = 0;
  blink_timer = 0;
  EditorInvertCursor(GetSelection() && cursor == sel_start); // the selection starts at the cursor's x
  EditorShowCursor(1);
  return 1;
}

// position in a rendered row closest to x
static unsigned int PosAtX(unsigned char row, unsigned char x) {
  char* chars = RowAddress(row);
  unsigned char count = tb_row_counts[row], col = 0, width;
  unsigned int pos;
  while (col < count) {
    width = font_widths[(unsigned char)chars[col]];
    if (x < ((width + 1) >> 1)) break;
    x = x < width ? 0 : x - width;
    ++col;
  }
  pos = tb_row_starts[row] + col;
  if (col == count && pos == tb_row_starts[row + 1] && tb_end_row != row) --pos; // stay on wrapped row
  return pos;
}

// stages the tile data mode switches for render_block_top (see src/editor/render.asm): blocks 0-5
// need $8000 mode, 9-14 $8800, the rest work in either so switches go in the middle of them
static void StageSplits(void) {
  unsigned char row, block, mode, current = 0xFF, shared = 0xFF, count = 0;
  for (row = 0; row < TB_ROWS; ++row) {
    block = render_block_top + row;
    if (block >= TB_ROWS) block -= TB_ROWS;
    if ((block >= 6 && block < 9) || block >= 15) {
      if (shared == 0xFF) shared = row;
      continue;
    }
    mode = block < 6 ? LCDC_TILES_8000 : 0;
    if (current == 0xFF) render_pending_top_mode = mode;
    else if (mode != current) {
      render_pending_splits[count++] = ((shared + row - 1) >> 1) << 3;
      render_pending_splits[count++] = mode;
    }
    current = mode;
    shared = 0xFF;
  }
  render_pending_split_count = count >> 1;
}

// scrolls the screen one row with SCY (dir 1 = down), the block leaving the screen draws the new row
static void ScrollRing(unsigned char down) {
  unsigned char block;
  render_pending = 0;
  if (down) {
    block = render_block_top;
    render_block_top = block == TB_ROWS - 1 ? 0 : block + 1;
    ring_top = (ring_top + 1) & (BG_MAP_ROWS - 1);
    RenderSetMapRow((ring_top + TB_ROWS - 1) & (BG_MAP_ROWS - 1), block);
  } else {
    render_block_top = render_block_top ? render_block_top - 1 : TB_ROWS - 1;
    ring_top = (ring_top - 1) & (BG_MAP_ROWS - 1);
    RenderSetMapRow(ring_top, render_block_top);
  }
  StageSplits();
  render_pending_scy = ring_top << 3;
  render_pending = 1;
}

// scrolls one row down, only the new bottom row is scanned and drawn
static void ScrollDown(void) {
  ScrollRing(1);
  tb_ScrollRows(1);
  tb_RenderRows(tb_rows - 1, tb_rows);
  top = tb_row_starts[0];
  redraw = 1;
}

// scrolls one row up to the row starting at new_top
static void ScrollUp(unsigned int new_top) {
  ScrollRing(0);
  tb_ScrollRows(0);
  tb_row_starts[0] = new_top;
  tb_RenderRows(0, 1);
  top = new_top;
  redraw = 1;
}

// re-renders rows after an edit, stopping once a row starts where it used to (moved by the edit)
// NOTE: SDCC 4.2 clobbered hl when edit_delta was read inside these expressions, so it's copied first
static void RenderAfterEdit(void) {
  unsigned char row = edit_row, end_row = tb_end_row, i;
  unsigned int old_next, expected, delta = (unsigned int)(int)edit_delta;
  if (row) --row; // the previous row's wrapping can change too
  if (end_row != 0xFF && end_row >= row) tb_end_row = 0xFF; // found again while scanning
  for (; row < tb_rows; ++row) {
    old_next = tb_row_starts[row + 1];
    expected = old_next + delta;
    tb_RenderRows(row, row + 1);
    if (old_next > edit_pos && tb_row_starts[row + 1] == expected) {
      for (i = row + 2; i <= tb_rows; ++i) tb_row_starts[i] += delta; // rows below just moved
      if (end_row != 0xFF && end_row > row) tb_end_row = end_row;
      break;
    }
  }
  redraw = 1;
}

// remembers an edit so only the rows it changed are rendered, more than one edit renders everything
static void Edited(unsigned int pos, signed char delta) {
  modified = 1;
  if (edited) dirty = 1;
  edited = 1;
  edit_row = tb_found_row;
  edit_pos = pos;
  edit_delta = delta;
}

// sets sel_start and sel_end, returns 0 if nothing is selected
static unsigned char GetSelection(void) {
  if (!selecting || anchor == cursor) return 0;
  if (anchor < cursor) {
    sel_start = anchor;
    sel_end = cursor;
  }
  else {
    sel_start = cursor;
    sel_end = anchor;
  }
  return 1;
}

static void ClearSelection(void) {
  if (selecting) redraw = 1;
  selecting = 0;
}

static void NoHighlight(void) {
  unsigned char i;
  for (i = 0; i < TB_ROWS * 2; ++i) render_sel[i] = 0;
}

// sets the selected columns of each rendered row for EditorDraw
static void SetHighlight(void) {
  unsigned char row, first, end, count;
  unsigned int row_start, next;
  NoHighlight();
  if (!GetSelection()) return;
  for (row = 0; row < tb_rows; ++row) {
    row_start = tb_row_starts[row];
    next = tb_row_starts[row + 1];
    if (sel_end <= row_start) break;
    if (sel_start >= next) continue;
    count = tb_row_counts[row];
    first = 0;
    if (sel_start > row_start) first = sel_start - row_start > count ? count : (unsigned char)(sel_start - row_start);
    if (sel_end < next || row == tb_end_row) { // ends in this row
      end = sel_end - row_start > count ? count : (unsigned char)(sel_end - row_start);
      if (end <= first) continue;
    }
    else end = 0xFF; // continues, so the line feed or wrap is selected too
    render_sel[row << 1] = first;
    render_sel[(row << 1) + 1] = end;
  }
}

static void Draw(void) {
  SetHighlight();
  EditorDraw(tb_rows);
}

// sets the first rendered row and renders
static void ScrollTo(unsigned int new_top) {
  top = new_top;
  Render();
  redraw = 1;
}

static void MoveUp(void) {
  unsigned char row = tb_found_row;
  keep_x = 1;
  if (row) cursor = PosAtX(row - 1, want_x);
  else if (!top) cursor = 0;
  else {
    ScrollUp(tb_RowStart(top - 1));
    cursor = PosAtX(0, want_x);
  }
}

static void MoveDown(void) {
  unsigned char row = tb_found_row;
  keep_x = 1;
  if (tb_end_row == row) cursor = tb_Length(); // last row
  else if (row + 1 < tb_rows) cursor = PosAtX(row + 1, want_x);
  else {
    ScrollDown();
    cursor = PosAtX(row, want_x);
  }
}

static void PageUp(void) {
  unsigned char row = tb_found_row, i;
  keep_x = 1;
  if (!top) {
    cursor = 0;
    return;
  }
  for (i = tb_rows - 1; i && top; --i) top = tb_RowStart(top - 1);
  ScrollTo(top);
  cursor = PosAtX(row, want_x);
}

static void PageDown(void) {
  unsigned char row = tb_found_row;
  keep_x = 1;
  if (tb_end_row != 0xFF) {
    cursor = tb_Length();
    return;
  }
  ScrollTo(tb_row_starts[tb_rows - 1]);
  if (tb_end_row != 0xFF && row > tb_end_row) row = tb_end_row;
  cursor = PosAtX(row, want_x);
}

// before the space that ends a wrapped row, otherwise after the last char
static void MoveEnd(void) {
  unsigned char row = tb_found_row, count = tb_row_counts[row];
  cursor = tb_row_starts[row] + count;
  if (count && cursor == tb_row_starts[row + 1] && tb_end_row != row && RowAddress(row)[count - 1] == ' ') --cursor;
}

static void DeleteSelection(void) {
  tb_DeleteRange(sel_start, sel_end - sel_start);
  cursor = sel_start;
  selecting = 0;
  modified = 1;
  dirty = 1;
}

static unsigned char Copy(void) {
  if (!GetSelection()) return 0;
  if (tb_Copy(sel_start, sel_end - sel_start)) return 1;
  ShowMessage("TOO BIG TO COPY");
  return 0;
}

static void Paste(void) {
  unsigned int length = tb_ClipLength(), room = TB_SIZE - tb_Length();
  if (!length) return;
  if (GetSelection()) room += sel_end - sel_start;
  if (length > room) {
    ShowMessage("TEXT FULL");
    return;
  }
  if (GetSelection()) DeleteSelection();
  tb_Paste(cursor);
  cursor += length;
  modified = 1;
  dirty = 1;
}

// ctrl + A, X, C, V
static void HandleCtrlKey(unsigned char key) {
  if (key >= 'A' && key <= 'Z') key += 'a' - 'A';
  if (key == 'a') {
    anchor = 0;
    cursor = tb_Length();
    selecting = 1;
    moved = 1;
    redraw = 1;
  }
  else if (key == 'c') Copy();
  else if (key == 'x' && Copy()) DeleteSelection();
  else if (key == 'v') Paste();
}

static void HandleKey(unsigned char key, unsigned char mods) {
  if (mods & KB_MOD_CTRL) {
    HandleCtrlKey(key);
    return;
  }
  if (mods & (KB_MOD_ALT | KB_MOD_SUPER)) return;

  if (key >= KEY_LEFT && key <= KEY_PAGE_DOWN) { // shift + movement selects
    if (mods & KB_MOD_SHIFT) {
      if (!selecting) anchor = cursor;
      selecting = 1;
      redraw = 1;
    }
    else if (GetSelection() && (key == KEY_LEFT || key == KEY_RIGHT)) { // to that end of the selection
      cursor = key == KEY_LEFT ? sel_start : sel_end;
      ClearSelection();
      moved = 1;
      return;
    }
    else ClearSelection();
  }
  moved = 1;
  switch (key) {
    case KEY_UP: MoveUp(); return;
    case KEY_DOWN: MoveDown(); return;
    case KEY_PAGE_UP: PageUp(); return;
    case KEY_PAGE_DOWN: PageDown(); return;
    case KEY_LEFT: if (cursor) --cursor; return;
    case KEY_RIGHT: if (cursor != tb_Length()) ++cursor; return;
    case KEY_HOME: cursor = tb_row_starts[tb_found_row]; return;
    case KEY_END: MoveEnd(); return;
  }
  moved = 0;
  if (key == KEY_ESCAPE || key == KEY_INSERT) return;
  if (GetSelection()) { // typing replaces the selection
    DeleteSelection();
    if (key == KEY_BACKSPACE || key == KEY_DELETE) return;
  }
  selecting = 0;
  switch (key) {
    case KEY_BACKSPACE:
      if (cursor && tb_Delete(cursor - 1)) Edited(--cursor, -1);
      break;
    case KEY_DELETE:
      if (tb_Delete(cursor)) Edited(cursor, -1);
      break;
    default:
      if (key < ' ' && key != ASCII_TAB && key != ASCII_LF) return;
      if (key >= KEY_LEFT && key < 0xA0) return; // unprintable in Latin-1
      if (tb_Insert(cursor, key)) Edited(cursor++, 1);
  }
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
  NoHighlight();
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
  NoHighlight();
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
  selecting = 0;
  top = 0;
  want_x = 0;
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
  NoHighlight();
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
  else return 0;
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
    if (cursor < top) {
      if (top && row == tb_RowStart(top - 1)) ScrollRing(0); // one row up
      top = row;
    }
    else { // scroll until the cursor is on the last row, jump if it's more than a screen away
      bottom = tb_row_starts[tb_rows];
      for (i = tb_rows; i; --i) {
        top = tb_NextRow(top);
        if (bottom == row) break;
        bottom = tb_NextRow(bottom);
      }
      if (!i) top = row;
      else if (i == tb_rows) ScrollRing(1); // one row down
    }
    Render();
  }
  Draw();
  redraw = 0;
  moved = 0;
  PlaceCursor();
}

void Editor(void) {
  unsigned int event;
  unsigned char key;

  EditorSetup();
  everdrive = sd_Detect();
  idle_frames = 0;
  normalized = 0;
  cursor = 0;
  top = 0;
  selecting = 0;
  want_x = 0;
  keep_x = 0;
  moved = 0;
  redraw = 0;
  ring_top = 0;
  edited = 0;
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
      if (dirty || edited) break; // text changed, rows need rendering before more keys
      if (moved) { // keeps tb_found_row current for the next key
        if (!PlaceCursor()) dirty = 1;
        moved = 0;
      }
    }
    if ((key = PadKey())) {
      if (!HandleFileKey(key, 0)) HandleKey(key, 0);
    }
    if (dirty || edited || redraw || moved) idle_frames = 0;
    if (dirty) {
      Refresh();
      dirty = 0;
      edited = 0;
      normalized = 0;
      continue;
    }
    if (edited) {
      edited = 0;
      normalized = 0;
      RenderAfterEdit();
      if (!PlaceCursor()) {
        if (cursor >= tb_row_starts[tb_rows] && tb_RowStart(cursor) == tb_row_starts[tb_rows]) ScrollDown();
        else if (top && cursor < top && tb_RowStart(cursor) == tb_RowStart(top - 1)) ScrollUp(tb_RowStart(cursor));
        else {
          Refresh();
          continue;
        }
        PlaceCursor();
      }
    }
    if (redraw) {
      Draw();
      redraw = 0;
    }
    if (moved) {
      moved = 0;
      if (!PlaceCursor()) Refresh();
      continue;
    }
    if (idle_frames < NORMALIZE_DELAY) ++idle_frames;
    else if (!everdrive && !normalized) normalized = tb_NormalizeStep(); // keeps the .sav readable as text
    if (++blink_timer == CURSOR_BLINK) EditorShowCursor(0);
    else if (blink_timer == CURSOR_BLINK + CURSOR_BLINK) {
      EditorShowCursor(1);
      blink_timer = 0;
    }
  }
}
