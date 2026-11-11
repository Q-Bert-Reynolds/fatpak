// SETTINGS > THEME: a menu of theme options, applied as they change. Only dark
// mode so far. Returns 1 if the theme changed, so the host can save it.
#include "../build/modules/sdk.h"
#include "../src/ui/icons.h"
#include "lib/text.h"

static const char hint[] = ICON_A "Toggle " ICON_B "Back";

unsigned char ModuleMain(void) {
  unsigned char key, dark = ModTheme(0xFF), changed = 0;
  char lines[BOX_STRIDE], *end;
  ModText(STATUS_LINE, 1, hint);
  while (1) {
    end = PutText(lines, " Dark mode  ");
    end = PutText(end, dark ? "On " : "Off");
    *end = 0;
    ModMenu(lines, 1, 0);
    while (!(key = ModKey()));
    if (key == KEY_ESCAPE || key == KEY_MENU || key == KEY_BACKSPACE) break;
    if (key == KEY_ENTER || key == KEY_LEFT || key == KEY_RIGHT) {
      dark = ModTheme(!dark);
      changed = 1;
    }
  }
  return changed;
}
