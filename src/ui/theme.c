// SETTINGS > THEME: THEME.MOD applies and saves the setting; this keeps it over a power cut.
#include "theme.h"
#include "../app/dialogs.h"
#include "../editor/state.h"
#include "../fatfs/file_api.h"
#include "../modules/runtime.h"
#include "dialogs.h"
#include "../ui/text.h"

void ThemeSetup(void) {
  unsigned char result;
  ShowBusy(Str(S_LOADING)); // the module's menu box replaces it
  result = RUN_MODULE(THEME);
  HideBox();
  if (result) ShowModuleError(result);
  else if (module_status && !doc_large) { // settings live in PSRAM; the swap file is their copy on SD
    swap_dirty = 0;
    FileSaveSwap();
  }
  bars_changed = 1;
  dirty = 1;
}
