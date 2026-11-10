// Modal boxes, selection lists and status messages.
#include "dialogs.h"
#include "../input.h"
#include "../keyboard/keyboard.h"
#include "render.h"
#include "screen.h"
#include "text.h"

// waits for a key or button to dismiss a message, a typed key (not escape or enter) stays queued
// so it still does what it does
void WaitDismiss(void) {
  unsigned char key;
  while (1) {
    WaitFrame();
    if ((key = KBPeekKey())) {
      if (key == KEY_ESCAPE || key == KEY_ENTER) KBPopEvent();
      return;
    }
    if (PadPressed()) return;
  }
}

// centers a box over the screen for the lines in the BOX_LINE rows, nothing highlighted
void OpenBox(unsigned char lines) {
  char* line = RowAddress(BOX_LINE);
  unsigned char i, width, widest = 0;
  for (i = 0; i < lines; ++i, line += BOX_STRIDE) {
    width = RenderTextWidth(line);
    if (width > widest) widest = width;
  }
  render_box_text = RowAddress(BOX_LINE);
  render_box_w = widest + BOX_PADDING;
  render_box_x = (TB_WIDTH - render_box_w) >> 1;
  render_box_rows = lines + 2; // half rows above and below
  render_box_top = (TB_ROWS - render_box_rows) >> 1;
  render_box_sel = 0xFF;
  ++render_box_gen;
}

// a box with text (Loading..., Saving...), drawn right away, before the work it's waiting for
void ShowBusy(const char* text) {
  CopyName(RowAddress(BOX_LINE), text);
  OpenBox(1);
  EditorDraw();
}

void HideBox(void) {
  render_box_top = 0xFF;
}
