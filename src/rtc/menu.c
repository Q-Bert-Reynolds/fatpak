// SETTINGS > CLOCK: the dialog is CLOCK.MOD (modules/clock.c).
#include "menu.h"
#include "../app/dialogs.h"
#include "../editor/state.h"
#include "../modules/runtime.h"
#include "../ui/dialogs.h"

void ClockSetup(void) {
  unsigned char result;
  ShowBusy("Loading..."); // the module's menu box replaces it
  result = RUN_MODULE(CLOCK);
  HideBox();
  if (result) ShowModuleError(result);
  bars_changed = 1;
  dirty = 1;
}
