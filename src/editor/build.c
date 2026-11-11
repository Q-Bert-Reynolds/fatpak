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

// ASM_ERR_* - 1; with "L1234 " these must fit the status bar's 112 pixels (FooterCompose)
static const char errors[ASM_ERR_COUNT][17] = {
  "SYNTAX ERROR", "UNKNOWN SYMBOL", "ALREADY DEFINED", "VALUE TOO BIG", "JR TOO FAR", "BAD OPERAND",
  "NO SECTION", "SECTION FULL", "NOT YET DEFINED", "NOT SUPPORTED", "NAME TOO LONG", "DIVIDE BY ZERO",
  "BAD INSTRUCTION", "PHASE ERROR", "BAD STRING", "NO GLOBAL LABEL", "TOO MANY SYMBOLS", "NO CODE", "BAD BANK"};

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
  char path[PATH_SIZE + FS_NAME_SIZE], text[TB_STRIDE], *end;
  unsigned char result;
  if (tb_lang != LANG_ASM) { ShowMessage("NOT AN ASM FILE"); return; }
  if (doc_large) { ShowMessage("FILE TOO BIG"); return; }
  if (modified || !file_name[0]) SaveFile(0); // the ROM matches the file on the card
  if (modified || !file_name[0]) return; // declined or failed, with its own message
  ShowBusy("Assembling...");
  module_context = &context;
  result = RUN_MODULE(ASM);
  HideBox();
  if (result) { ShowModuleError(result); return; }
  if (module_status) { // the cursor goes to the line
    end = PutText(text, "L");
    end = PutNumber(end, context.line);
    *end++ = ' ';
    *PutText(end, errors[module_status - 1]) = 0;
    cursor = anchor = context.pos;
    selecting = 0;
    dirty = 1;
    ShowMessage(text);
    return;
  }
  OutputPath(path);
  ShowBusy("Writing...");
  result = FileWriteImage(path, context.blocks);
  HideBox();
  if (result) { ShowError(result, "DISK FULL"); return; }
  if (run) { LaunchGame(path); return; } // back only if it didn't launch
  end = PutText(text, "BUILT ");
  end = PutNumber(end, context.blocks >> 1);
  *PutText(end, " KB") = 0;
  ShowMessage(text);
}
