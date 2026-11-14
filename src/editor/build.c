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

// path: name in the folder of file_dir's first n characters (project.gbp's: file_level), or with
// n 0xFF, in file_dir
static void FolderPath(char* path, unsigned char n, const char* name) {
  char cut = 0;
  if (n != 0xFF) {
    cut = file_dir[n];
    file_dir[n] = 0;
  }
  JoinPath(path, file_dir, name, (unsigned char)(PATH_SIZE + FS_NAME_SIZE));
  if (n != 0xFF) file_dir[n] = cut;
}
// the ROM's path: a project's output from project.gbp's folder, or the document's path with
// its extension replaced by .gb
static void OutputPath(char* path, const AsmContext* c) {
  char *dot = 0, *p;
  if (c->kind & ASM_PROJECT) {
    FolderPath(path, file_level, c->name);
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

// minutes:seconds of frames (60 a second; the Game Boy's 59.7 makes it 0.5% slow)
static char* PutTime(char* end, unsigned long frames) {
  unsigned int minutes = 0;
  unsigned char tens = 0;
  for (; frames >= 3600; frames -= 3600) ++minutes;
  for (; (unsigned int)frames >= 600; frames -= 600) ++tens; // no SDCC helpers in the OS either
  end = PutNumber(end, minutes);
  *end++ = ':';
  *end++ = '0' + tens;
  *end++ = '0' + (unsigned char)((unsigned int)frames / 60);
  *end = 0;
  return end;
}
// build.log beside the project or the document, and build.cache beside project.gbp after a build
// that worked; their own failures aren't reported
static void WriteOutputs(const AsmContext* c, char* path) {
  if (c->log_bytes) {
    FolderPath(path, c->kind & ASM_PROJECT ? file_level : 0xFF, "build.log");
    FileWriteImage(path, c->log_bytes);
  }
  if (c->cache_blocks) {
    FolderPath(path, file_level, "build.cache");
    FileWriteImage(path, c->cache_blocks);
  }
}

// ASM.MOD's ModProgress(0) text: the pass and how far it is, the file and line it's on (or the
// file being read from the card), and the time since BUILD; after pass 1 and 2, what it's doing.
// The time moves at every redraw, every 5 s while the build is working: if it stops, so has the
// build. (FIXED, and only calling what's outside the module's pages.)
static void BuildProgress(char* text) {
  const AsmContext* c = module_context;
  unsigned int pass = c->pass == 1 ? S_BUILD_PASS1 : S_BUILD_PASS2;
  char* end;
  if (c->pass > 2) end = PutStr(text, c->pass == 3 ? S_BUILD_LINKING : S_BUILD_FINISHING);
  else {
    end = PutStr(PutNumber(PutStr(text, S_PART(pass, 0)), c->progress), S_PART(pass, 1));
    *end++ = '\n';
    end = ToLatin1(end, module_loading ? module_loading : c->file ? c->name + c->base : file_name, 19);
    *end++ = '\n';
    if (module_loading) end = PutStr(end, S_BUILD_LOADING);
    else end = PutStr(PutNumber(PutStr(end, S_PART(S_BUILD_AT_LINE, 0)), c->line), S_PART(S_BUILD_AT_LINE, 1));
  }
  *end++ = '\n';
  PutTime(end, module_frames);
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
  context.log_bytes = context.cache_blocks = 0;
  module_context = &context;
  module_progress = BuildProgress;
  result = RUN_MODULE(ASM);
  HideBox();
  if (result) { ShowModuleError(result); return; }
  if (module_status == ASM_NOT_ASM) { ShowMessage(Str(S_NOT_ASM_FILE)); return; }
  WriteOutputs(&context, path);
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
