// ASM.MOD: the two passes and the result (ModuleMain in asm.c calls Main), in whichever
// page has room. See asm_shared.h.
#include "asm_shared.h"

// rgbasm's version symbols: this assembles what RGBDS 1.0 does, where it does
// (named arrays, not literals: SDCC's ___str_n names would clash with asm_str.c's on this page)
static const char version_major[] = "__RGBDS_MAJOR__", version_minor[] = "__RGBDS_MINOR__", version_patch[] = "__RGBDS_PATCH__";
static void Builtin(const char* word, unsigned int value) {
  for (ident_len = 0; (ident[ident_len] = word[ident_len]) != 0; ++ident_len);
  Add(SYM_EQU | SYM_SEEN, value, 0); // defined before both passes
}
unsigned char Main(void) {
  unsigned int blocks, i;
  unsigned char *h;
  Frame* f;
  context->symbols = 0;
  Window(ASM_SYMBOL_BLOCK); // its first block is the hash heads
  for (h = WINDOW, i = 0; i < 512; ++i) *h++ = 0;
  next_unit = 64; // after them (unit 0 means "none")
  heap_top = 0;
  file_top = ASM_FILE_BLOCK;
  Builtin(version_major, 1);
  Builtin(version_minor, 0);
  Builtin(version_patch, 1);
  Pass(1);
  if (!error && !rom_used) Fail(ASM_ERR_EMPTY);
  if (!error && (i = Link()) != 0xFF) { // reported at the section that doesn't fit
    error = sects[i].flags & SECT_ADDRESS ? ASM_ERR_OVERLAP : ASM_ERR_FULL;
    Report(sects[i].file, sects[i].line, sects[i].pos);
    return error;
  }
  if (!error) {
    Relocate();
    for (blocks = 64; blocks < (unsigned int)(max_bank + 1) << 5; blocks <<= 1);
    context->blocks = blocks;
    Fill();
    Pass(2);
  }
  if (!error) Header();
  // an error in a macro body is reported at its invocation (whose line feed was already
  // counted); one in a repeat at the body line
  // (expansions of string symbols and {} report the line they're on)
  for (f = &frames[depth], i = 0; f > frames && (f->kind == F_MACRO || f->kind == F_ARG || f->file == FILE_EXPANSION); --f)
    if (f->kind == F_MACRO) i = 1;
  Report(f->file, f->line - i, f->file ? frames[0].line_pos : f->line_pos);
  return error;
}
