// FILE > BUILD and RUN: ASM.MOD assembles the open document into PSRAM, the image goes to
// <name>.gb beside the source, and RUN launches that like any game (notes/ASSEMBLER.md).
// Under a project.gbp (in the document's folder or above) the module builds the project
// instead, from any file: its main, to its output, with its rgbasm and rgbfix options.
#include <stddef.h>
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
#include "../ui/render.h"
#include "../../modules/assembler/asm.h"
#include "../../modules/cc/cc_ctx.h"

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
  if (c->kind & ASM_TEXT) return; // a .c file's assembly: not the document's lines
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
  unsigned int seconds = Seconds(frames), minutes = 0;
  unsigned char tens = 0;
  for (; seconds >= 60; seconds -= 60) ++minutes; // no SDCC helpers in the OS either
  for (; seconds >= 10; seconds -= 10) ++tens;
  end = PutNumber(end, minutes);
  *end++ = ':';
  *end++ = '0' + tens;
  *end++ = '0' + (unsigned char)seconds;
  *end = 0;
  return end;
}
// build.log beside the project or the document, and build.cache and build.obj beside project.gbp
// after a build that worked; their own failures aren't reported
static void WriteOutputs(const AsmContext* c, char* path) {
  if (c->log_bytes) {
    FolderPath(path, c->kind & ASM_PROJECT ? file_level : 0xFF, "build.log");
    FileWriteImage(path, c->log_bytes);
  }
  if (c->cache_blocks) {
    FolderPath(path, file_level, "build.cache");
    FileWriteImage(path, c->cache_blocks);
  }
  if (c->obj_blocks) { // each unit's object, for the next build (LINK.MOD put it together)
    FolderPath(path, file_level, "build.obj");
    FileWriteImage(path, c->obj_blocks);
  }
}

// ASM.MOD's ModProgress(0) text: the pass and how far it is (a project's: how much of its units),
// the file and line it's on (or the file being read from the card), and the time since BUILD;
// LINK.MOD's: what it's doing; CC's passes (pass 6 to 8, cc_core.c's cc_progress): which of the
// three, and the line in progress (pass and progress are clear of the CcContext's fields). The time (both modules') moves at every redraw, every 5 s while the build is
// working: if it stops, so has the build. (FIXED, and only calling what's outside the module's pages.)
static void BuildProgress(char* text) {
  const AsmContext* c = module_context;
  unsigned char cc = c->pass >= 6;
  unsigned int pass = cc ? S_CC_PASS : c->pass == 1 ? S_BUILD_PASS1 : c->pass == 5 ? S_BUILD_UNIT : S_BUILD_PASS2;
  char* end;
  if (c->pass == 3 || c->pass == 4) end = PutStr(text, c->pass == 3 ? S_BUILD_LINKING : S_BUILD_FINISHING);
  else {
    end = PutStr(PutNumber(PutStr(text, S_PART(pass, 0)), cc ? c->pass - 5 : c->progress), S_PART(pass, 1));
    *end++ = '\n';
    end = ToLatin1(end, module_loading ? module_loading : !cc && c->file ? c->name + c->base : file_name, 19);
    *end++ = '\n';
    if (module_loading) end = PutStr(end, S_BUILD_LOADING);
    else end = PutStr(PutNumber(PutStr(end, S_PART(S_BUILD_AT_LINE, 0)), cc ? c->progress : c->line), S_PART(S_BUILD_AT_LINE, 1));
  }
  *end++ = '\n';
  PutTime(end, module_frames);
}

// The AsmContext for PREP.MOD and ASM.MOD; returns nonzero after showing an error. A .c document
// is compiled first (notes/COMPILER.md): CCA.MOD (at path), CCB.MOD and CCC.MOD, into PSRAM,
// each naming the next in the CcContext that shares c's storage (CCERR.MOD after an error: it
// writes the box's text at text, and c's pos and kind for ErrorCursor); CCC.MOD leaves c ready
// for ASM.MOD (ASM_TEXT: the unit, its runtime INCLUDEd from /GBCSYS/CC). In assembly: SDCC's
// version didn't fit the pages. (The OS's constants are the assembler's too: LANG_*, S_*.)
typedef char cc_context_fits[sizeof(CcContext) <= sizeof(AsmContext) ? 1 : -1];
typedef char cc_offsets[offsetof(CcContext, name) == 34 && offsetof(CcContext, text) == 36 && MODULE_CCA == 13 &&
                        offsetof(AsmContext, kind) == 78 && offsetof(AsmContext, log_bytes) == 79 &&
                        offsetof(AsmContext, pass) == 83 && offsetof(AsmContext, progress) == 84 && // cc_progress
                        sizeof(CcContext) <= 83 &&
                        offsetof(AsmContext, cache_blocks) == 81 && offsetof(AsmContext, obj_blocks) == 86 && ASM_DOC == 1 ? 1 : -1];
// the box while CC's passes run: "Compiling..." and the file (a project compiles several), in the
// CcContext's text (CCERR.MOD's box replaces it after an error)
static void CompilingBox(const CcContext* c) {
  char* end = PutStr(c->text, S_COMPILING);
  *end++ = '\n';
  *ToLatin1(end, c->name, FS_NAME_SIZE - 1) = 0;
  OpenBox(BoxText(0, c->text)); // (ShowBusy's box has one line)
  EditorDraw();
}
static unsigned char BuildStart(AsmContext* c, char* text, const char* path) __naked {
  c; text; path;
  __asm
    xor a, a                ;// module_frames = 0: the build's time, through every run
    ld hl, _module_frames
    ld [hl+], a
    ld [hl+], a
    ld [hl+], a
    ld [hl], a
    ld a, [_build_c]
    or a, a
    jr nz, .compile
    ld a, [_tb_lang]
    push de                 ;// c: any other document, assembled
    ld hl, 78               ;// kind: ASM_DOC for assembly; anything builds under a project.gbp
    add hl, de
    cp a, LANG_ASM
    ld a, 1
    jr z, .doc
    xor a, a
.doc:
    ld [hl+], a
    xor a, a                ;// log_bytes, cache_blocks: none yet
    ld [hl+], a
    ld [hl+], a
    ld [hl+], a
    ld [hl+], a
    ld bc, 3                ;// obj_blocks
    add hl, bc
    ld [hl+], a
    ld [hl], a
    call _tb_Length
    pop hl                  ;// length
    ld [hl], c
    inc hl
    ld [hl], b
    jr .assemble
.compile:
    ld hl, 36               ;// the CcContext's text (the caller sets its name and source)
    add hl, de
    ld a, c
    ld [hl+], a
    ld [hl], b
    pop hl                  ;// the return; then path, the stack argument
    pop bc
    push hl
    push de                 ;// c, for the whole run
    push bc
    call _CompilingBox      ;// de = c
    pop de                  ;// CCA.MOD's path
    ld a, 13                ;// MODULE_CCA
.run:                       ;// de = the path, a = the ID
    ld hl, _module_progress ;// the box: the pass and line (RunModule clears it after each)
    ld [hl], LOW(_BuildProgress)
    inc hl
    ld [hl], HIGH(_BuildProgress)
    pop hl
    push hl
    ld b, a
    ld a, l
    ld [_module_context], a
    ld a, h
    ld [_module_context + 1], a
    ld a, b
    call _RunModule
    pop de
    push de
    or a, a
    jr nz, .done            ;// it didn't load: a = the FRESULT
    ld a, [de]              ;// next
    or a, a
    jr z, .done
    inc de
    inc de                  ;// its path
    jr .run
.done:
    push af
    call _HideBox
    pop af
    or a, a
    jr z, .compiled
    call _ShowModuleError
    jr .stop
.compiled:
    ld a, [_module_status]
    or a, a
    jr z, .compiled_ok
    pop de                  ;// c
    push de
    ld hl, 36               ;// text: CCERR.MOD's box
    add hl, de
    ld a, [hl+]
    ld b, [hl]
    ld c, a
    push bc
    call _ErrorCursor
    pop de
    call _ShowBox
.stop:
    pop de
    ld a, 1
    ret
.compiled_ok:
    pop de
    ld de, S_ASSEMBLING
    call _Str
    ld d, b
    ld e, c
    call _ShowBusy
    xor a, a
    ret
.assemble:
    ld de, S_ASSEMBLING
    call _Str
    ld d, b
    ld e, c
    call _ShowBusy
    pop hl                  ;// the return; drop path, the stack argument
    pop bc
    xor a, a
    jp hl
  __endasm;
}

// A project's C unit (PREP.MOD's ASM_COMPILE: its path from project.gbp's folder in c->name) is
// compiled like a .c document, from the card, and its assembly written beside it as _name.asm
// (notes/COMPILER.md); then c is set up for PREP.MOD again, from the next unit. Nonzero after
// showing an error.
extern unsigned char build_c; // src/modules/runtime.asm: BuildStart compiles (a .c document outside a project, or a project's C unit)
extern unsigned char FileSearch(const char* path, void* load); // src/modules/runtime.c: 1 if it isn't there
extern unsigned char fs_WriteText(const char* path, unsigned int block, unsigned int bytes); // src/fatfs/fatfs.c
static unsigned char InProject(void) { // a project.gbp in the document's folder or above
  struct { unsigned int block, blocks; unsigned long size; } load; // ModuleLoad: its entry only
  load.blocks = 0;
  file_level = 0xFF;
  return FileSearch(ASM_PROJECT_FILE, &load) != 1;
}
static unsigned char CompileUnit(AsmContext* c, char* text, char* path, unsigned char level) {
  char unit[FS_NAME_SIZE + 4];
  unsigned int next = c->symbols + 1;
  unsigned char n, base = 0, result;
  CcContext* cc = (CcContext*)c;
  for (n = 0; (unit[n] = c->name[n]) != 0; ++n) if (unit[n] == '/') base = n + 1;
  cc->name = unit + base;
  cc->source = unit;
  build_c = 1;
  result = BuildStart(c, text, MODULE_CCA_PATH);
  build_c = 0;
  if (result) return 1;
  for (; n > base; --n) unit[n] = unit[n - 1]; // dir/name.c -> dir/_name.asm
  unit[base] = '_';
  for (n = base; unit[n] != '.'; ++n);
  unit[n + 1] = 'a'; unit[n + 2] = 's'; unit[n + 3] = 'm'; unit[n + 4] = 0;
  FolderPath(path, level, unit);
  if ((result = fs_WriteText(path, CC_OUT_BLOCK, c->text_length))) { HideBox(); ShowError(result, S_DISK_FULL); return 1; }
  BuildStart(c, text, MODULE_CCA_PATH); // assembly again, for PREP.MOD
  c->symbols = next;
  return 0;
}

// PREP.MOD (which 2), ASM.MOD (1) or LINK.MOD (0) with the context, the box's progress BuildProgress's
unsigned char BuildModule(AsmContext* c, unsigned char which) {
  module_context = c;
  module_progress = BuildProgress;
  return which == 2 ? RUN_MODULE(PREP) : which ? RUN_MODULE(ASM) : RUN_MODULE(LINK);
}
void BuildFile(unsigned char run) {
  AsmContext context;
  char path[PATH_SIZE + FS_NAME_SIZE], text[FS_NAME_SIZE + 3 * LANG_MAX], *end;
  unsigned char result, level;
  if (doc_large) { ShowMessage(Str(S_FILE_TOO_BIG)); return; }
  if (!file_name[0] && tb_lang != LANG_ASM) { ShowMessage(Str(S_NOT_ASM_FILE)); return; } // no folder, no project
  if (modified || !file_name[0]) SaveFile(0); // the ROM matches the file on the card
  if (modified || !file_name[0]) return; // declined or failed, with its own message
  build_c = tb_lang == LANG_C && !InProject(); // in a project, a .c document builds the project
  ((CcContext*)&context)->name = file_name;
  ((CcContext*)&context)->source = 0;
  if (BuildStart(&context, text, MODULE_CCA_PATH)) return;
  build_c = 0;
  context.symbols = 0; // PREP.MOD: C units from the first
  result = BuildModule(&context, 2); // PREP.MOD first: which units build.obj has unchanged
  level = file_level; // project.gbp's folder (RunModule forgets it)
  while (!result && (context.kind & ASM_COMPILE)) { // a project's C unit first, then PREP.MOD again
    if (CompileUnit(&context, text, path, level)) return;
    file_level = level;
    result = BuildModule(&context, 2);
    level = file_level;
  }
  if (!(context.kind & ASM_CURRENT)) { // else nothing changed since the ROM was built
    if (!result) result = BuildModule(&context, 1);
    level = file_level;
    if (!result && module_status != ASM_NOT_ASM) result = BuildModule(&context, 0); // then LINK.MOD: the image, or after an error build.log
    if (!result && module_status && module_status != ASM_NOT_ASM) { // stopped: PREP.MOD compares the files read with the card
      unsigned char status = module_status;
      context.kind |= ASM_CHECK;
      file_level = level;
      result = BuildModule(&context, 2);
      module_status = status;
    }
  }
  file_level = level;
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
  if (!(context.kind & ASM_CURRENT)) {
    ShowBusy(Str(S_WRITING));
    result = FileWriteImage(path, context.blocks);
    HideBox();
    if (result) { ShowError(result, S_DISK_FULL); return; }
  }
  if (run) { LaunchGame(path); return; } // back only if it didn't launch
  for (end = path; *end; ++end); // the image's name
  while (end != path && end[-1] != '/') --end;
  end = ToLatin1(text, end, FS_NAME_SIZE - 1);
  *end++ = '\n';
  PutStr(PutNumber(PutStr(end, S_PART(S_BUILD_DONE, 0)), context.blocks >> 1), S_PART(S_BUILD_DONE, 1));
  ShowBox(text);
}
