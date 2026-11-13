// SETTINGS > THEME: a menu of theme options, applied as they change. Only dark
// mode so far. Returns 1 if the theme changed, so the host can save it.
#include "../build/modules/sdk.h"
#include "../src/ui/icons.h"
#include "lib/text.h"


unsigned char ModuleMain(void) {
  unsigned char key, dark = ModTheme(0xFF), changed = 0;
  char lines[BOX_STRIDE], *end;
  ModText(STATUS_LINE, 1, Str(S_THEME_HINT));
  while (1) {
    end = ModString(PutText(lines, " "), S_PART(S_THEME_DARK, 0));
    ModString(ModString(end, dark ? S_ON : S_OFF), S_PART(S_THEME_DARK, 1));
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
