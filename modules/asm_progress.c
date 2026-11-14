// ASM.MOD: progress for the host's box (build.c's BuildProgress writes the text)
#include "asm_shared.h"

// --- progress (ModProgress) every 64 lines and as each pass starts: the pass, its count (pass
// 1: thousands of lines, pass 2: percent of pass 1's lines) and where it is go in the context,
// and the host writes the text
unsigned int progress_units, pass1_units; // 64-line steps this pass, and pass 1's
void Progress(void) {
  unsigned int part = ++progress_units;
  Frame* f = &frames[depth];
  while (f > frames && (f->kind == F_MACRO || f->kind == F_ARG || f->file == FILE_EXPANSION)) --f; // like the error report
  Report(f->file, f->line, 0);
  if (pass == 1) part = Div((UVal)part << 3, 125); // x 64 / 1000
  else {
    part = Div(((UVal)part << 6) + ((UVal)part << 5) + ((UVal)part << 2), pass1_units); // x 100
    if (part > 99) part = 99;
  }
  context->pass = pass;
  context->progress = part;
  ModProgress(0);
  run_n = 0; // the window moved
}
// a step between or after the passes: the box says which, between its own steps
void Phase(unsigned char p) {
  context->pass = p;
  ModProgress(0);
  run_n = 0; // the window may have moved
}
