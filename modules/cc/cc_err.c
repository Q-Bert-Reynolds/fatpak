// CCERR.MOD: after a CC pass stops on an error (cc_core.c names this module next), the error
// box's text for the host (BuildC, src/editor/build.c): the file, its line, C ERROR and the
// code (cc_msg.h, listed in notes/COMPILER.md), and the name it's about; and where the line
// starts in the document, for the cursor.
#include "../../build/modules/sdk.h"
#include "../lib/text.h"
#include "cc_ctx.h"
#include "../assembler/asm.h"
#include <stddef.h>

#define WINDOW ((const unsigned char*)0xBE00)
static void Select(unsigned int block) { *(volatile unsigned char*)0xBD03 = (unsigned char)(block >> 8); *(volatile unsigned char*)0xBD02 = (unsigned char)block; }
#define STATE(field) (WINDOW[offsetof(CcState, field)])

unsigned char ModuleMain(CcContext* c) {
  char extra[20], buf[128];
  char* end = c->text;
  const char* s;
  unsigned char status, file, i, n;
  unsigned int line, pos = 0, at;
  Select(CC_STATE_BLOCK);
  status = STATE(status);
  file = STATE(err_file);
  line = STATE(err_line) | (unsigned int)WINDOW[offsetof(CcState, err_line) + 1] << 8;
  for (i = 0; i < sizeof(extra) - 1 && WINDOW[offsetof(CcState, err_extra) + i]; ++i) extra[i] = WINDOW[offsetof(CcState, err_extra) + i];
  extra[i] = 0;
  if (file) { // an #included file: its path, as the source wrote it
    Select(CC_FILENAME_BLOCK + (file >> 3));
    s = (const char*)WINDOW + ((file & 7) << 6);
  } else s = c->name;
  for (i = 0; i < 64 && s[i]; ++i) *end++ = s[i];
  *end++ = '\n';
  end = ModString(end, S_PART(S_BUILD_LINE, 0)); end = PutNumber(end, line); end = ModString(end, S_PART(S_BUILD_LINE, 1));
  *end++ = '\n';
  end = ModString(end, S_PART(S_C_ERROR, 0)); end = PutNumber(end, status); end = ModString(end, S_PART(S_C_ERROR, 1));
  if (extra[0]) { *end++ = '\n'; end = PutText(end, extra); }
  *end = 0;
  if (!file && !c->source) // the line's start: past line - 1 line feeds of the document
    for (at = 1; at < line; ) {
      n = ModSource(pos, buf);
      if (!n) break;
      for (i = 0; i < n && at < line; ++i) if (buf[i] == '\n') { ++at; if (at == line) { pos += i + 1; break; } }
      if (at < line) pos += n;
    }
  c->next = 0;
  ((AsmContext*)c)->pos = pos; // where ErrorCursor moves the cursor (kind 0: the document, no project)
  ((AsmContext*)c)->kind = c->source ? ASM_TEXT : 0; // a project's C unit: the cursor stays
  return status ? status : 1;
}
