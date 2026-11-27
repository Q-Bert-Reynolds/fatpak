// Browser settings entry; diagnostics are independently linked in KEYTEST.MOD.
#include "test.h"
#include "../modules/runtime.h"
#include "../editor/view.h"
#include "../ui/render.h"
#include "../ui/screen.h"
#include "../ui/dialogs.h"
#include "../app/dialogs.h"
#include "../ui/text.h"

static const char keyboard_module[] = MODULE_KEYTEST_PATH;

void KeyboardTest(void) {
  unsigned char old_font = font, result;
  font = FONT_VWF;
  SetFont(font);
  render_text = 0;
  BeginFullScreen();
  ClearScreen();
  ShowBusy(Str(S_LOADING));
  result = RunModule(keyboard_module, MODULE_KEYTEST);
  HideBox();
  if (result) ShowModuleError(result);
  font = old_font;
  SetFont(font);
  render_text = 1;
  EndFullScreen();
}

// menu: 1 SETTINGS > KEYBOARD, 0 the saved choice (boot, EXIT), 2 that quietly (an SGB's boot: its driver
// in place of the built-in PS/2 one, which stays without KEYTEST.MOD)
void KeyboardSetup(unsigned char menu) {
  unsigned char result;
  module_context = (void*)(unsigned int)((menu & 1) + 1);
  result = RunModule(keyboard_module, MODULE_KEYTEST);
  if (result && !(menu & 2)) ShowModuleError(result);
}
