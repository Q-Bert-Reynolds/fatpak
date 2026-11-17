// Modal boxes, selection lists and status messages.
#include "dialogs.h"
#include "../input.h"
#include "../keyboard/keyboard.h"
#include "render.h"
#include "screen.h"
#include "text.h"
#include "../sgb/client.h"

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
  char* line;
  unsigned char i, width, widest = 0;
  if (lines > 19) lines = 19;
  for (i = 0; i < lines; ++i) {
    line = BoxLine(i);
    width = RenderTextWidth(line);
    if (width > widest) widest = width;
  }
  render_box_text = BoxLine(0);
  render_box_w = widest + BOX_PADDING;
  render_box_x = (screen_width - render_box_w) >> 1;
  render_box_rows = lines + 2; // half rows above and below
  render_box_top = (screen_rows - render_box_rows) >> 1;
  render_box_first = 1;
  render_box_sel = 0xFF;
  ++render_box_gen;
}

// copies text into the box's lines from line on, starting a line at each '\n' and after every
// BOX_STRIDE - 1 characters, returns the line after its last
unsigned char BoxText(unsigned char line, const char* text) {
  char* dest = BoxLine(line);
  unsigned char n = 0;
  for (;; ++text) {
    if (!*text || *text == '\n' || n == BOX_STRIDE - 1) {
      dest[n] = 0;
      BoxCommit(line);
      ++line;
      n = 0;
      if (!*text || line == 19) return line;
      dest = BoxLine(line);
      if (*text == '\n') continue;
    }
    dest[n++] = *text;
  }
}

// a box with text (Loading..., Saving...), drawn right away, before the work it's waiting for
void ShowBusy(const char* text) {
  BoxText(0, text);
  OpenBox(1);
  EditorDraw();
}

void HideBox(void) {
  SGBProgress(0, 0);
  render_box_top = 0xFF;
}
