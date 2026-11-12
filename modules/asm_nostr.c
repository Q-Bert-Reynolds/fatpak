// ASM.MOD without string support (EQUS, string functions, {}, PURGE): stands in for
// asm_str.c in a three-page build, so the module doesn't borrow page 4. Each entry
// fails as NOT SUPPORTED. See notes/ASSEMBLER.md.
#include "asm_shared.h"

char str[STR_SIZE]; // DB's "..." literals, which don't need the string module
unsigned int str_top, heap_top;
char fmt_text[1];
unsigned char redef;

// a plain "..." for DB; anything else (string functions, string symbols) isn't supported
unsigned int StrExpr(void) {
  unsigned int start = str_top;
  unsigned char c;
  Space();
  if (pending || ch != '"') { pending = 0; Fail(ASM_ERR_UNSUPPORTED); return start; }
  Advance();
  while (ch != '"' && !error) {
    c = Char();
    if (str_top == STR_SIZE) Fail(ASM_ERR_STRING);
    else str[str_top++] = c;
  }
  Advance();
  return start;
}
unsigned int StrNumber(unsigned char k) { k; Fail(ASM_ERR_UNSUPPORTED); return 0; }
void DefineString(unsigned int start) { start; Fail(ASM_ERR_UNSUPPORTED); }
void Interpolate(void) { Fail(ASM_ERR_UNSUPPORTED); }
void Purge(void) { Fail(ASM_ERR_UNSUPPORTED); }
