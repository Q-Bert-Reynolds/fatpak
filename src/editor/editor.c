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
    case KEY_BACKSPACE: if (cursor) tb_Delete(--cursor); break;
    case KEY_DELETE: tb_Delete(cursor); break;
    case KEY_ESCAPE:
    case KEY_INSERT: return;
    default:
      if (key < ' ' && key != ASCII_TAB && key != ASCII_LF) return;
      if (key >= KEY_LEFT && key < 0xA0) return; // unprintable in Latin-1
      if (tb_Insert(cursor, key)) ++cursor;
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
}

static unsigned char PressOSKKey(void) {
  unsigned char key;
  if (osk_y == OSK_ROWS - 1) {
    if (osk_x == 0) SetOSKLayer(OSK_SHIFT);
    else if (osk_x == 1) SetOSKLayer(OSK_SYMBOLS);
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
  EditorDraw();
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
  osk_shown = 0;
  osk_layer = OSK_LOWER;
  osk_x = 0;
  osk_y = 0;
  tb_rows = TB_ROWS;
  Refresh();

  while (1) {
    WaitFrame();
    while ((key = (unsigned char)(event = KBPopEvent()))) {
      HandleKey(key, (unsigned char)(event >> 8));
      dirty = 1;
    }
    if ((key = PadKey())) {
      HandleKey(key, 0);
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
