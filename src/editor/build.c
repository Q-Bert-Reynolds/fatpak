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

// ASM_ERR_* - 1, shown on their own line in the result box (BOX_STRIDE - 1 characters)
static const char errors[ASM_ERR_COUNT][17] = {
  "SYNTAX ERROR", "UNKNOWN SYMBOL", "ALREADY DEFINED", "VALUE TOO BIG", "JR TOO FAR", "BAD OPERAND",
  "NO SECTION", "SECTION FULL", "NOT YET DEFINED", "NOT SUPPORTED", "NAME TOO LONG", "DIVIDE BY ZERO",
  "BAD INSTRUCTION", "PHASE ERROR", "BAD STRING", "NO GLOBAL LABEL", "TOO MANY SYMBOLS", "NO CODE", "BAD BANK",
  "ASSERT FAILED", "NO SUCH FILE", "TOO DEEP", "SECTIONS OVERLAP"};

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

void BuildFile(unsigned char run) {
  AsmContext context;
  char path[PATH_SIZE + FS_NAME_SIZE], text[FS_NAME_SIZE + 32], *end;
  unsigned char result;
  if (tb_lang != LANG_ASM) { ShowMessage("NOT AN ASM FILE"); return; }
  if (doc_large) { ShowMessage("FILE TOO BIG"); return; }
  if (modified || !file_name[0]) SaveFile(0); // the ROM matches the file on the card
  if (modified || !file_name[0]) return; // declined or failed, with its own message
  ShowBusy("Assembling...");
  context.length = tb_Length();
  module_context = &context;
  result = RUN_MODULE(ASM);
  HideBox();
  if (result) { ShowModuleError(result); return; }
  if (module_status) { // the file, line and error in a box; the cursor goes to the line, or to the INCLUDE of the file
    end = ToLatin1(text, context.file ? context.name : file_name, FS_NAME_SIZE - 1);
    end = PutNumber(PutText(end, "\nLine "), context.line);
    *end++ = '\n';
    *PutText(end, errors[module_status - 1]) = 0;
    cursor = anchor = context.pos;
    selecting = 0;
    dirty = 1;
    ShowBox(text);
    return;
  }
  OutputPath(path);
  ShowBusy("Writing...");
  result = FileWriteImage(path, context.blocks);
  HideBox();
  if (result) { ShowError(result, "DISK FULL"); return; }
  if (run) { LaunchGame(path); return; } // back only if it didn't launch
  for (end = path; *end; ++end); // the image's name
  while (end != path && end[-1] != '/') --end;
  end = PutNumber(PutText(ToLatin1(text, end, FS_NAME_SIZE - 1), "\nBuilt "), context.blocks >> 1);
  *PutText(end, " KB") = 0;
  ShowBox(text);
}
