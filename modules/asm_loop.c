// ASM.MOD: FOR and INCBIN (see asm_shared.h), in whichever page has room.
#include "asm_shared.h"

unsigned char Comma(void) {
  Space();
  if (ch != ',') return 0;
  Advance();
  return 1;
}

// FOR name, [start,] stop[, step]: REPT with name = start, start + step, ... while short of stop
void For(void) {
  unsigned int a = 0, b, step = 1, n = 0;
  Space();
  ReadIdent();
  if (!ident_len) { Fail(ASM_ERR_SYNTAX); return; }
  SaveName();
  Expect(',');
  b = Constant();
  if (Comma()) {
    a = b;
    b = Constant();
    if (Comma()) step = Constant();
  }
  if (!step) { Fail(ASM_ERR_DIVIDE); return; }
  if (step & 0x8000) { if ((int)a > (int)b) n = Apply('/', a - b - step - 1, -step); }
  else if ((int)a < (int)b) n = Apply('/', b - a + step - 1, step);
  DefineValue(SYM_VAR, a);
  if (!error) Repeat(n, found, step);
}

// INCBIN "file"[, start[, length]]: its bytes, read whole into PSRAM like an included file
void Incbin(void) {
  unsigned char source = OpenFile();
  unsigned int from = 0, n, block;
  if (!source) return;
  n = inc_len[source - 1];
  if (Comma()) {
    from = Constant();
    if (from > n) { Fail(ASM_ERR_RANGE); return; }
    n -= from;
    if (Comma()) {
      block = Constant();
      if (block > n) { Fail(ASM_ERR_RANGE); return; }
      n = block;
    }
  }
  block = ASM_INCLUDE_BLOCK + ((unsigned int)(source - 1) << 7);
  for (n += from; from < n && !error; ++from) {
    Window(block + (from >> 9));
    Emit(WINDOW[from & 511]);
  }
}
