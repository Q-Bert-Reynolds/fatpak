// Calendar setting dialog.
#include "menu.h"
#include "../app/dialogs.h"
#include "rtc.h"
#include "../editor/state.h"
#include "../input.h"
#include "../ui/dialogs.h"
#include "../ui/render.h"
#include "../ui/screen.h"
#include "../ui/text.h"

static const char clock_fields[][8] = {"Year", "Month", "Day", "Hour", "Minute", "Second"};

void ClockSetup(void) {
  ClockDate date;
  unsigned char selected = 0, i, key, *value = (unsigned char*)&date;
  char *line, *end;
  if (ClockRead(&date)) { date.year = 26; date.month = date.day = 1; date.hour = date.minute = date.second = 0; }
  DrawRow(STATUS_LINE, 1, "Left/right: adjust  A: set  B: cancel");
  while (1) {
    line = RowAddress(BOX_LINE);
    for (i = 0; i < 6; ++i, line += BOX_STRIDE) {
      end = PutText(line, " ");
      end = PutText(end, clock_fields[i]); *end++ = ' ';
      if (!i) end = PutNumber(end, 2000 + value[i]); else end = PutNumber2(end, value[i]);
      *end = 0;
    }
    OpenBox(6); render_box_sel = selected + 1; EditorDraw();
    while (!(key = MenuKey()));
    if (key == KEY_ESCAPE || key == KEY_MENU) break;
    if (key == KEY_UP) selected = selected ? selected - 1 : 5;
    else if (key == KEY_DOWN) selected = selected == 5 ? 0 : selected + 1;
    else if (key == KEY_LEFT || key == KEY_RIGHT) {
      unsigned char low = selected == 1 || selected == 2 ? 1 : 0;
      unsigned char high = !selected ? 99 : selected == 1 ? 12 : selected == 2 ? 31 : selected == 3 ? 23 : 59;
      if (key == KEY_LEFT) value[selected] = value[selected] == low ? high : value[selected] - 1;
      else value[selected] = value[selected] == high ? low : value[selected] + 1;
    }
    else if (key == KEY_ENTER) {
      if (!ClockWrite(&date)) break;
      ShowMessage("Invalid date or clock unavailable");
    }
  }
  HideBox(); bars_changed = 1; dirty = 1;
}
