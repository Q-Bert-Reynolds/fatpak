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
#include "../ui/icons.h"
#include "../../modules/info.h"

static char line[FS_NAME_SIZE];
static FileDetails details;

void ShowFileInfo(const char* path, const FileEntry* entry) {
  InfoContext context;
  unsigned char result;
  context.entry = entry;
  context.details = &details;
  context.language = FileLanguage(entry->name);
  context.result = 0;
  details.game = !entry->dir && IsGame(entry->name);
  details.status = 0;
  ShowBusy("Reading info..."); // stays up until the module draws its page
  if (!entry->dir) context.result = FileInspect(path, &details);
  BeginView(1);
  *ToLatin1(line, entry->name, FS_NAME_SIZE - 1) = 0;
  DrawRow(HEADER_LINE, 1, line);
  DrawRow(STATUS_LINE, 1, ICON_B "Exit");
  module_context = &context;
  if ((result = RUN_MODULE(FILEINFO))) ShowModuleError(result);
}
