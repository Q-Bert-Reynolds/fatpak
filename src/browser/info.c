// File properties: reads the file here, then FILEINFO.MOD (modules/info.c)
// fills the page between the shared header and footer.
#include "info.h"
#include "../editor/document.h"
#include "../editor/view.h"
#include "../game/loader.h"
#include "../browser/paths.h"
#include "../modules/runtime.h"
#include "../ui/dialogs.h"
#include "../ui/render.h"
#include "../ui/screen.h"
#include "../ui/text.h"
#include "../../modules/info.h"
#include "../../modules/view.h"
#include "viewer.h"
#include "../input.h"

static char line[FS_NAME_SIZE];
static FileDetails details;

// Start on the page: BrowserMenu (MENU_INFO), then the page again; returns 0 or ACTION_OPEN + a mode
// (A: VIEW_AUTO, or the menu's OPEN AS)
unsigned char ShowFileInfo(char* path, const FileEntry* entry, char* clipboard) {
  InfoContext context;
  unsigned char result, i;
  char* slash = path;
  for (i = 0; path[i]; ++i) if (path[i] == '/') slash = path + i;
  ModuleAPIBackground(0, 0); // (from a map's menu)
  context.entry = entry;
  context.details = &details;
  context.language = FileLanguage(entry->name);
  context.result = context.open = 0;
  details.game = !entry->dir && IsGame(entry->name);
  details.status = 0;
  ShowBusy(Str(S_READING_INFO)); // stays up until the module draws its page
  if (!entry->dir) context.result = FileInspect(path, &details);
  while (1) {
    BeginView(1);
    *ToLatin1(line, entry->name, FS_NAME_SIZE - 1) = 0;
    DrawRow(HEADER_LINE, 1, line);
    DrawRow(STATUS_LINE, 1, Str(S_INFO_HINT));
    module_context = &context;
    if ((result = RUN_MODULE(FILEINFO))) {
      ShowModuleError(result);
      return 0;
    }
    if (module_status != VIEW_MENU) return context.open ? ACTION_OPEN : 0;
    *slash = 0;
    result = BrowserMenu(path, clipboard, MENU_INFO);
    *slash = '/';
    PadPressed(); // (Escape latched a Start too: not the page's)
    if (result) return result == ACTION_CLOSE ? 0 : result;
  }
}
