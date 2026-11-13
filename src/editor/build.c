// FILE > BUILD and RUN: ASM.MOD assembles the open document into PSRAM, the image goes to
// <name>.gb beside the source, and RUN launches that like any game (notes/ASSEMBLER.md).
// Under a project.gbp (in the document's folder or above) the module builds the project
// instead, from any file: its main, to its output, with its rgbasm and rgbfix options.
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

// the ROM's path: a project's output from project.gbp's folder (file_level characters of
// file_dir), or the document's path with its extension replaced by .gb
static void OutputPath(char* path, const AsmContext* c) {
  char *dot = 0, *p, cut;
  if (c->kind & ASM_PROJECT) {
    cut = file_dir[file_level];
    file_dir[file_level] = 0;
    JoinPath(path, file_dir, c->name, (unsigned char)(PATH_SIZE + FS_NAME_SIZE));
    file_dir[file_level] = cut;
    return;
  }
  JoinPath(path, file_dir, file_name, (unsigned char)(PATH_SIZE + FS_NAME_SIZE - 3));
  for (p = path; *p; ++p) {
    if (*p == '.') dot = p;
    else if (*p == '/') dot = 0;
  }
  *PutText(dot ? dot : p, ".gb") = 0;
}

// the cursor goes to the error: its line in the document, or the INCLUDE line of the file it's
// in. A project's goes to its line if it's in the open document (the same path from project.gbp's
// folder), and stays otherwise. doc: scratch for that path.
static void ErrorCursor(const AsmContext* c, char* doc) {
  unsigned int pos = c->pos, line = c->line;
  const char *d = file_dir + file_level, *n = c->name;
  unsigned char ch;
  if (c->kind & ASM_PROJECT) {
    if (*d) ++d;
    JoinPath(doc, d, file_name, (unsigned char)(PATH_SIZE + FS_NAME_SIZE));
    if (!*d) ++doc; // no folder: no "/"
    while (*doc == *n++) if (!*doc++) goto in;
    return;
  in:
    for (pos = 0; --line; ) while ((ch = tb_GetChar(pos++)) && ch != '\n');
  }
  cursor = anchor = pos;
  selecting = 0;
  dirty = 1;
}

// ASM.MOD's ModProgress(0) text: the pass and how far it is, then the file and line it's on
// (in ROM0, and only calling what's outside the module's pages)
static void BuildProgress(char* text) {
  const AsmContext* c = module_context;
  unsigned int pass = c->pass == 1 ? S_BUILD_PASS1 : S_BUILD_PASS2;
  char* end = PutStr(PutNumber(PutStr(text, S_PART(pass, 0)), c->progress), S_PART(pass, 1));
  *end++ = '\n';
  end = ToLatin1(end, c->file ? c->name + c->base : file_name, 19);
  *end++ = '\n';
  PutStr(PutNumber(PutStr(end, S_PART(S_BUILD_AT_LINE, 0)), c->line), S_PART(S_BUILD_AT_LINE, 1));
}

void BuildFile(unsigned char run) {
  AsmContext context;
  char path[PATH_SIZE + FS_NAME_SIZE], text[FS_NAME_SIZE + 3 * LANG_MAX], *end;
  unsigned char result;
  if (doc_large) { ShowMessage(Str(S_FILE_TOO_BIG)); return; }
  if (!file_name[0] && tb_lang != LANG_ASM) { ShowMessage(Str(S_NOT_ASM_FILE)); return; } // no folder, no project
  if (modified || !file_name[0]) SaveFile(0); // the ROM matches the file on the card
  if (modified || !file_name[0]) return; // declined or failed, with its own message
  ShowBusy(Str(S_ASSEMBLING));
  context.length = tb_Length();
  context.kind = tb_lang == LANG_ASM ? ASM_DOC : 0; // anything builds under a project.gbp
  module_context = &context;
  module_progress = BuildProgress;
  result = RUN_MODULE(ASM);
  HideBox();
  if (result) { ShowModuleError(result); return; }
  if (module_status == ASM_NOT_ASM) { ShowMessage(Str(S_NOT_ASM_FILE)); return; }
  if (module_status) { // the file, line and error in a box; the cursor goes to the line, or to the INCLUDE of the file
    end = ToLatin1(text, context.file ? context.name + context.base : file_name, FS_NAME_SIZE - 1);
    *end++ = '\n';
    end = PutStr(PutNumber(PutStr(end, S_PART(S_BUILD_LINE, 0)), context.line), S_PART(S_BUILD_LINE, 1));
    *end++ = '\n';
    PutStr(end, S_ERR_SYNTAX + module_status - 1);
    ErrorCursor(&context, path);
    ShowBox(text);
    return;
  }
  OutputPath(path, &context);
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
