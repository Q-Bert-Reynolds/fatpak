// Context-specific help: HELP.MOD draws and scrolls it in the editor's padded rows.
#include "help.h"
#include "osk.h"
#include "view.h"
#include "../modules/runtime.h"
#include "../ui/dialogs.h"
#include "../ui/render.h"
#include "../ui/screen.h"
#include "../ui/text.h"

static void HelpView(unsigned char browser) {
  unsigned char result, old_font = font, styled = render_text, old_osk = osk_shown;
  font = FONT_VWF;
  SetFont(font);
  render_text = 0;
  BeginView(1);
  osk_shown = 0;
  ShowBusy(Str(S_LOADING)); // the module hides it when it draws
  module_context = &browser;
  if ((result = RUN_MODULE(HELP))) ShowModuleError(result);
  font = old_font;
  SetFont(font);
  render_text = styled;
  osk_shown = old_osk;
  EndFullScreen();
}

void ShowHelp(void) { HelpView(0); }
void ShowBrowserHelp(void) { HelpView(1); }
