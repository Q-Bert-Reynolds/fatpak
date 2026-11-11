// On-screen keyboard state, selection and joypad editing.
#include "osk.h"
#include "editor.h"
#include "state.h"
#include "text_buffer.h"
#include "view.h"
#include "../input.h"
#include "../ui/render.h"
#include "../ui/screen.h"

#define OSK_BLOCK        9 // the on screen keyboard's blocks if it can't have the rows' it covers (PickOSKBlocks), 9 to 13

unsigned char osk_blocks[OSK_ROWS]; // blocks the on screen keyboard's rows use
unsigned char osk_shown;
unsigned char osk_layer;
unsigned char osk_x;
unsigned char osk_y;
unsigned char pad_mods; // modifiers synthesized by PadKey

// the keyboard takes the blocks of the text rows it hides, the rows that stay keep theirs. If it would
// cover the cursor the text scrolls up (the ring rotates, so those rows keep their blocks too). The
// bars' blocks can't be taken, they'd clash when shown (then the keyboard uses 9-13 and Refresh scrolls)
static void PickOSKBlocks(void) {
  unsigned char i, j, row, length = tb_rows + render_gbc, rows = tb_rows - OSK_ROWS, shift = 0;
  if (render_text && tb_found_row != 0xFF && tb_found_row >= rows) shift = tb_found_row - rows + 1;
  row = rows + shift; // hidden: the rows below the ones that stay, then the ones scrolled off the top
  for (j = 0; j < OSK_ROWS; ++j) {
    if (row == tb_rows) row = 0;
    i = ring_pos + row;
    if (i >= length) i -= length;
    osk_blocks[j] = ring_blocks[i];
    if (osk_blocks[j] == HEADER_BLOCK || osk_blocks[j] == STATUS_BLOCK) {
      for (j = 0; j < OSK_ROWS; ++j) osk_blocks[j] = OSK_BLOCK + j;
      return;
    }
    ++row;
  }
  if (!shift) return;
  ring_pos += shift;
  if (ring_pos >= length) ring_pos -= length;
  ring_top = (ring_top + shift) & (BG_MAP_ROWS - 1);
  top = tb_row_starts[shift];
}

static void ToggleOSK(void) {
  osk_shown = !osk_shown;
  if (osk_shown) PickOSKBlocks();
  SetRows();
}

void OpenKeyboard(void) {
  if (!osk_shown) ToggleOSK();
}

#define SHIFT_DOUBLE_TAP 30 // frames: a second shift tap this soon locks capitals

static unsigned char shift_timer; // frames left for a double tap, counted down by PadKey

// Only the keyboard rows change, so draw them now: the editor doesn't need a
// Refresh, and modal prompts (AskName) don't draw until a key is typed.
static void SetOSKLayer(unsigned char layer) {
  osk_layer = layer;
  OSKDraw(osk_layer, tb_rows);
  EditorDraw();
}

// Like phone keyboards: tap for one capital, double tap for caps lock, tap again to release.
static void PressShift(void) {
  if (osk_layer == OSK_SHIFT && shift_timer) SetOSKLayer(OSK_CAPS);
  else if (osk_layer == OSK_SHIFT || osk_layer == OSK_CAPS) SetOSKLayer(OSK_LOWER);
  else {
    SetOSKLayer(OSK_SHIFT);
    shift_timer = SHIFT_DOUBLE_TAP;
  }
}

static unsigned char PressOSKKey(void) {
  unsigned char key;
  if (osk_y == OSK_ROWS - 1) {
    if (osk_x == 0) PressShift();
    else if (osk_x == 1) SetOSKLayer(osk_layer == OSK_SYMBOLS ? OSK_LOWER : OSK_SYMBOLS);
    else if (osk_x == 2) return KEY_MENU;
    else if (osk_x == OSK_COLS - 3) return KEY_UNDO;
    else if (osk_x == OSK_COLS - 2) return KEY_REDO;
    else if (osk_x == OSK_COLS - 1) return KEY_ENTER;
    else return ' ';
    return KEY_NONE;
  }
  key = OSKGetKey(osk_layer, (osk_y << 3) + (osk_y << 1) + osk_x);
  if (osk_layer == OSK_SHIFT) SetOSKLayer(OSK_LOWER); // shift is one shot, caps lock stays
  return key;
}

static void MoveOSKSelection(unsigned char held) {
  if (held & PADF_UP) osk_y = osk_y ? osk_y - 1 : OSK_ROWS - 1;
  else if (held & PADF_DOWN) osk_y = osk_y == OSK_ROWS - 1 ? 0 : osk_y + 1;
  if (held & PADF_LEFT) osk_x = osk_x ? osk_x - 1 : OSK_COLS - 1;
  else if (held & PADF_RIGHT) osk_x = osk_x == OSK_COLS - 1 ? 0 : osk_x + 1;
  OSKSelect(osk_x, osk_y);
}

unsigned char PadKey(void) {
  unsigned char pressed = PadPressed();
  unsigned char held;
  pad_mods = 0;
  if (shift_timer) --shift_timer; // once per frame: the editor and AskName call this every frame
  if (pressed & PADF_SELECT) ToggleOSK();
  if (pressed & PADF_B) return KEY_BACKSPACE;
  if (pressed & PADF_START) return KEY_MENU;
  if (osk_shown && (pressed & PADF_A)) return PressOSKKey();
  held = DpadRepeat(pressed);
  if (!held) return KEY_NONE;
  if (!osk_shown && (button_state & PADF_A)) pad_mods = KB_MOD_SHIFT;
  if (osk_shown) {
    MoveOSKSelection(held);
    return KEY_NONE;
  }
  if (held & PADF_UP) return KEY_UP;
  if (held & PADF_DOWN) return KEY_DOWN;
  if (held & PADF_LEFT) return KEY_LEFT;
  return KEY_RIGHT;
}
