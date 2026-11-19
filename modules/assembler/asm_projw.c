// ASM.MOD: project.gbp's helpers (asm_proj.c), on the page with room. See asm_shared.h.
#include "asm_shared.h"

static const char proj_gb[] = ".gb";
// output: path, as .gb
void Output(void) {
  unsigned char i, k;
  for (i = 0, k = 0xFF; path[i] && i < sizeof(output) - 4; ++i) {
    if ((output[i] = path[i]) == '.') k = i;
    else if (path[i] == '/') k = 0xFF;
  }
  if (k == 0xFF) k = i;
  for (i = 0; (output[k + i] = proj_gb[i]) != 0; ++i);
}
