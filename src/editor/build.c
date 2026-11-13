// FILE > BUILD and RUN: ASM.MOD assembles the open document into PSRAM, the image goes to
// <name>.gb beside the source, and RUN launches that like any game (notes/ASSEMBLER.md).
#include "build.h"
#include "document.h"
#include "state.h"
#include "text_buffer.h"
#include "../app/dialogs.h"
#include "../browser/paths.h"
#include "../fatfs/file_api.h"
#include "../game/loader.h"
#include "../modules/runtime.h"
#include "../ui/dialogs.h"
#include "../ui/text.h"
#include "../../modules/asm.h"

// ASM_ERR_*'s names are the strings from S_ERR_SYNTAX, shown on their own line in the result box
typedef char error_names_match[S_ERR_OVERLAP - S_ERR_SYNTAX + 1 == ASM_ERR_COUNT ? 1 : -1];

// the document's path with its extension replaced by .gb
static void OutputPath(char* path) {
  char *dot = 0, *p;
  JoinPath(path, file_dir, file_name, (unsigned char)(PATH_SIZE + FS_NAME_SIZE - 3));
  for (p = path; *p; ++p) {
    if (*p == '.') dot = p;
    else if (*p == '/') dot = 0;
  }
  *PutText(dot ? dot : p, ".gb") = 0;
}

// ASM.MOD's ModProgress(0) text: the pass and how far it is, then the file and line it's on
// (in ROM0, and only calling what's outside the module's pages)
static void BuildProgress(char* text) {
  const AsmContext* c = module_context;
  unsigned int pass = c->pass == 1 ? S_BUILD_PASS1 : S_BUILD_PASS2;
  char* end = PutStr(PutNumber(PutStr(text, S_PART(pass, 0)), c->progress), S_PART(pass, 1));
  *end++ = '\n';
  end = ToLatin1(end, c->file ? c->name : file_name, 19);
  *end++ = '\n';
  PutStr(PutNumber(PutStr(end, S_PART(S_BUILD_AT_LINE, 0)), c->line), S_PART(S_BUILD_AT_LINE, 1));
}

void BuildFile(unsigned char run) {
  AsmContext context;
  char path[PATH_SIZE + FS_NAME_SIZE], text[FS_NAME_SIZE + 3 * LANG_MAX], *end;
  unsigned char result;
  if (tb_lang != LANG_ASM) { ShowMessage(Str(S_NOT_ASM_FILE)); return; }
  if (doc_large) { ShowMessage(Str(S_FILE_TOO_BIG)); return; }
  if (modified || !file_name[0]) SaveFile(0); // the ROM matches the file on the card
  if (modified || !file_name[0]) return; // declined or failed, with its own message
  ShowBusy(Str(S_ASSEMBLING));
  context.length = tb_Length();
  module_context = &context;
  module_progress = BuildProgress;
  result = RUN_MODULE(ASM);
  HideBox();
  if (result) { ShowModuleError(result); return; }
  if (module_status) { // the file, line and error in a box; the cursor goes to the line, or to the INCLUDE of the file
    end = ToLatin1(text, context.file ? context.name : file_name, FS_NAME_SIZE - 1);
    *end++ = '\n';
    end = PutStr(PutNumber(PutStr(end, S_PART(S_BUILD_LINE, 0)), context.line), S_PART(S_BUILD_LINE, 1));
    *end++ = '\n';
    PutStr(end, S_ERR_SYNTAX + module_status - 1);
    cursor = anchor = context.pos;
    selecting = 0;
    dirty = 1;
    ShowBox(text);
    return;
  }
  OutputPath(path);
  ShowBusy(Str(S_WRITING));
  result = FileWriteImage(path, context.blocks);
  HideBox();
  if (result) { ShowError(result, S_DISK_FULL); return; }
  if (run) { LaunchGame(path); return; } // back only if it didn't launch
  for (end = path; *end; ++end); // the image's name
  while (end != path && end[-1] != '/') --end;
  end = ToLatin1(text, end, FS_NAME_SIZE - 1);
  *end++ = '\n';
  PutStr(PutNumber(PutStr(end, S_PART(S_BUILD_DONE, 0)), context.blocks >> 1), S_PART(S_BUILD_DONE, 1));
  ShowBox(text);
}
