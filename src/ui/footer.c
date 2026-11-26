// One cached calendar clock shared by every footer; no RTC work in interrupts.
#include "footer.h"
#include "screen.h"
#include "render.h"
#include "text.h"
#include "../rtc/rtc.h"

char footer_time[8];
unsigned char footer_x;
unsigned char footer_ready;
static unsigned char frames;

// Called once per frame by either the editor UI or the suspended-game menu.
unsigned char footer_Poll(void) {
  ClockDate date;
  char text[8], *end;
  unsigned char hour, i, changed = !footer_ready;
  if (footer_ready && ++frames < 60) return 0;
  frames = 0;
  if (ClockRead(&date)) CopyName(text, "--:--");
  else {
    hour = date.hour;
    if (hour >= 12) hour -= 12;
    if (!hour) hour = 12;
    end = PutNumber(text, hour);
    *end++ = ':';
    end = PutNumber2(end, date.minute);
    *end++ = date.hour < 12 ? 'a' : 'p';
    *end++ = 'm';
    *end = 0;
  }
  for (i = 0; text[i] || footer_time[i]; ++i) {
    if (text[i] != footer_time[i]) { changed = 1; break; }
  }
  CopyName(footer_time, text);
  footer_x = screen_width - 4 - RenderTextWidth(text);
  footer_ready = 1;
  return changed;
}

// Reserve the rightmost 48 pixels; a private marker positions the time exactly
// in the VWF renderer, independent of the width of the preceding message.
void FooterDraw(unsigned char row, unsigned char col, const char* text) {
  DrawRow(row, col, text);
  FooterCompose(RowAddress(row));
}

void footer_Tick(void) {
  unsigned char row, line, visible = 0;
  // the clock's text first (a change at most once a minute): the rows are looked at only then. In SGB
  // fullscreen each RowAddress stages a row from PSRAM, written back later: scanning every row each
  // frame cost most of a browser key's frames (2026-11-25)
  if (!footer_Poll()) return;
  for (row = 0; row < screen_rows; ++row) {
    line = render_row_lines[row];
    if (line == STATUS_LINE || (!render_text && RowAddress(line)[screen_stride - 8] == FOOTER_MARKER)) {
      FooterCompose(RowAddress(line));
      visible = 1;
    }
  }
  if (visible) EditorDraw();
}
