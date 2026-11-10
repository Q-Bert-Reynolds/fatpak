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

void AppMain(void) {
  FileBackupSave(); // the last game's save RAM, before anything else
  if (!FileLoadData("/GBCSYS/EDITOR.DAT")) {
    data_loaded = 1;
    SGBSetDefaultBorder();
  }
  FileLoadSwap(); // before EditorSetup's tb_Load
  EditorSetup();
  EditorInit();
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
  if (session_open) Refresh();
  else { // the EverDrive's OS starts in the file browser (on a blank screen), the text is drawn if it's closed
    ClearScreen();
    EditorDraw();
    dirty = 1;
    OpenFile();
  }

  Editor();
}
