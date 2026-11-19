// ASM.MOD: progress for the host's box (build.c's BuildProgress writes the text)
#include "asm_shared.h"

// --- progress (ModProgress) every 64 lines and as each file starts: where it is, and how far:
// a project's units' passes done in percent (pass 5), or the document's pass 1 in thousands of
// lines and pass 2 in percent of pass 1's
unsigned int progress_units, pass1_units, lines_read; // 64-line steps of this unit's pass, its pass 1's, all
unsigned char unit_n;
void Progress(void) {
  unsigned int part = ++progress_units, all = pass1_units;
  unsigned char percent = 0;
  ReportWhere(); // the file and line, like an error's
  context->pass = pass;
  if (nunits) { // the units' passes so far, in percent: by subtraction (no helpers)
    context->pass = 5;
    for (part = ((unit_n - 1) * 2 + pass - 1) * 50; part >= nunits; part -= nunits) ++percent;
    part = percent;
  }
  else if (pass == 1) part >>= 4; // thousands of lines: x 64 / 1024, 2% short (no helpers for / 1000)
  else { // percent of pass 1's, by subtraction: both scaled down until part * 100 fits
    while (all > 655) {
      all >>= 1;
      part >>= 1;
    }
    for (part *= 100; part >= all && percent < 99; part -= all) ++percent;
    part = percent;
  }
  context->progress = part;
  ModProgress(0);
  run_n = 0; // the window moved
}
