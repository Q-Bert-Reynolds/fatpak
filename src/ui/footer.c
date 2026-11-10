// One cached calendar clock shared by every footer; no RTC work in interrupts.
#include "footer.h"
#include "screen.h"
#include "render.h"
#include "text.h"
#include "../rtc/rtc.h"

char footer_time[8];
unsigned char footer_x;
static unsigned char ready, frames;

// Called once per frame by either the editor UI or the suspended-game menu.
unsigned char footer_Poll(void) {
  ClockDate date;
  char text[8], *end;
  unsigned char hour, i, changed = !ready;
  if (ready && ++frames < 60) return 0;
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
  footer_x = TB_WIDTH - 4 - RenderTextWidth(text);
  ready = 1;
  return changed;
}

// Reserve the rightmost 48 pixels; a private marker positions the time exactly
// in the VWF renderer, independent of the width of the preceding message.
void FooterCompose(char* line) {
  unsigned char i, x = 1, width;
  char letter[2];
  if (!ready) footer_Poll();
  letter[1] = 0;
  for (i = 0; i < 32; ++i) {
    if (line[i] == FOOTER_MARKER) break;
    letter[0] = line[i];
    width = RenderTextWidth(letter);
    if (x + width > TB_WIDTH - 48) break;
    x += width;
  }
  for (; i < 32; ++i) line[i] = FOOTER_MARKER;
  line[32] = FOOTER_MARKER;
  for (i = 0; i < 7; ++i) line[33 + i] = ' ';
  for (i = 0; footer_time[i]; ++i) line[33 + i] = footer_time[i];
}

void FooterDraw(unsigned char row, unsigned char col, const char* text) {
  DrawRow(row, col, text);
  FooterCompose(RowAddress(row));
}

void footer_Tick(void) {
  unsigned char row, line, visible = 0;
  for (row = 0; row < TB_ROWS; ++row) {
    line = render_row_lines[row];
    if (line == STATUS_LINE || (!render_text && RowAddress(line)[32] == FOOTER_MARKER)) visible = 1;
  }
  if (!visible || !footer_Poll()) return;
  for (row = 0; row < TB_ROWS; ++row) {
    line = render_row_lines[row];
    if (line == STATUS_LINE || (!render_text && RowAddress(line)[32] == FOOTER_MARKER))
      FooterCompose(RowAddress(line));
  }
  EditorDraw();
}
