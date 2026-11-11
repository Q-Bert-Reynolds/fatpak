// SETTINGS > CLOCK: edits the calendar in a menu box. The host draws nothing
// but the browser behind it and hides the box after.
#include "../build/modules/sdk.h"
#include "../src/ui/icons.h"
#include "lib/text.h"

static const char fields[][8] = {"Year", "Month", "Day", "Hour", "Minute", "Second"};
static const unsigned char lows[] = {0, 1, 1, 0, 0, 0};
static const unsigned char highs[] = {99, 12, 31, 23, 59, 59};
static const char hint[] = ICON_LR " Edit " ICON_A "Set " ICON_B "Back";

unsigned char ModuleMain(void) {
  ModuleClock date;
  unsigned char selected = 0, i, key, error = 0, *value = (unsigned char*)&date;
  char lines[6 * BOX_STRIDE], *end;
  if (ModClock(&date)) { date.year = 26; date.month = date.day = 1; date.hour = date.minute = date.second = 0; }
  ModText(STATUS_LINE, 1, hint);
  while (1) {
    for (i = 0; i < 6; ++i) {
      end = PutText(lines + i * BOX_STRIDE, " ");
      end = PutText(end, fields[i]); *end++ = ' ';
      if (!i) end = PutText(end, "20");
      end = PutNumber2(end, value[i]);
      *end = 0;
    }
    ModMenu(lines, 6, selected);
    while (!(key = ModKey()));
    if (error) { ModText(STATUS_LINE, 1, hint); error = 0; }
    if (key == KEY_ESCAPE || key == KEY_MENU || key == KEY_BACKSPACE) break;
    if (key == KEY_UP) selected = selected ? selected - 1 : 5;
    else if (key == KEY_DOWN) selected = selected == 5 ? 0 : selected + 1;
    else if (key == KEY_LEFT) value[selected] = value[selected] == lows[selected] ? highs[selected] : value[selected] - 1;
    else if (key == KEY_RIGHT) value[selected] = value[selected] == highs[selected] ? lows[selected] : value[selected] + 1;
    else if (key == KEY_ENTER) {
      if (!ModClockSet(&date)) break;
      ModText(STATUS_LINE, 1, "Invalid date or no clock");
      error = 1;
    }
  }
  return 0;
}
