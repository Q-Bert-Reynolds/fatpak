// Startup services and initial screen selection.
#include "main.h"
#include "dialogs.h"
#include "../editor/document.h"
#include "../editor/editor.h"
#include "../editor/state.h"
#include "../editor/view.h"
#include "../editor/text_buffer.h"
#include "../editor/undo.h"
#include "../fatfs/file_api.h"
#include "../ui/dialogs.h"
#include "../ui/render.h"
#include "../ui/screen.h"
#include "../ui/theme.h"

extern const char loading_text[]; // shared with the game loader
static const char startup_name[] = "FatPak";

void AppMain(void) {
  // The VWF font is resident: show the normal bars before any card IO.
  EditorSetup();
  EditorInit();
  ThemeApply(); // PSRAM settings survive a reset; a cold start learns the theme from the swap below
  render_text = 0;
  BeginView(1);
  ClearScreen();
  DrawRow(HEADER_LINE, 1, startup_name);
  DrawRow(STATUS_LINE, 1, "");
  ShowBusy(loading_text);
  FileBackupSave(); // back up game RAM before loading recovery or font data
  if (!FileLoadData("/GBCSYS/EDITOR.DAT")) {
    data_loaded = 1;
    SGBSetDefaultBorder();
  }
  FileLoadSwap(); // before recovering the gap layout
  tb_Load();
  EditorInit();
  ThemeApply();
  if (backup_skipped) ShowMessage("SAVE NOT BACKED UP");
  session_open = modified; // legacy swap without a session: keep recoverable edits
  FileSession(0, 255);
  if (!session_open) {
    tb_Clear();
    file_name[0] = 0;
    modified = 0;
  }
  SetLang();
  UndoClear(modified);
  HideBox();
  if (session_open) Refresh();
  else { // replace the loading view with the browser
    ClearScreen();
    EditorDraw();
    dirty = 1;
    OpenFile();
  }

  Editor();
}
