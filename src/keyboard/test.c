// Browser settings entry; diagnostics are independently linked in KEYTEST.MOD.
#include "test.h"
#include "../modules/runtime.h"
#include "../editor/view.h"
#include "../ui/render.h"
#include "../ui/screen.h"
#include "../ui/dialogs.h"
#include "../app/dialogs.h"
#include "../ui/text.h"

void KeyboardTest(void) {
  unsigned char old_font = font, result;
  font = FONT_VWF;
  SetFont(font);
  render_text = 0;
  BeginFullScreen();
  ClearScreen();
  ShowBusy(Str(S_LOADING));
  result = RUN_MODULE(KEYTEST);
  HideBox();
  if (result) ShowModuleError(result);
  font = old_font;
  SetFont(font);
  render_text = 1;
  EndFullScreen();
}
