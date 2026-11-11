// Browser settings entry; diagnostics are independently linked in KEYTEST.MOD.
#include "test.h"
#include "../modules/runtime.h"
#include "../editor/view.h"
#include "../ui/render.h"
#include "../ui/screen.h"
#include "../ui/dialogs.h"
#include "../app/dialogs.h"

void KeyboardTest(void) {
  unsigned char old_font = font, result;
  font = FONT_VWF;
  SetFont(font);
  render_text = 0;
  BeginFullScreen();
  ClearScreen();
  ShowBusy("Loading");
  result = RunModule("/GBCSYS/MODULES/KEYTEST.MOD", 1);
  HideBox();
  if (result) ShowError(result, "Module unavailable");
  font = old_font;
  SetFont(font);
  render_text = 1;
  EndFullScreen();
}
