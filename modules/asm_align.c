// ASM.MOD: DS ALIGN's arithmetic (asm_sect.c has the sections; this is on another page for room)
#include "asm_shared.h"

// DS ALIGN[a, ofs], like rgbasm: the padding to the next address that's ofs past a multiple of
// 1 << a, as far as the section's own alignment (or address) says where that is
static unsigned int Offset(void) { return pc - (pass == 1 ? sec.start : sec.base); }
unsigned int AlignPad(unsigned char a, unsigned int ofs) {
  unsigned char fixed = sec.flags & SECT_ADDRESS;
  if (!in_section || (!fixed && !sec.align)) return 0;
  if (!fixed && sec.align < a) a = sec.align;
  return (ofs - Offset() - (fixed ? sec.start : sec.ofs)) & ((1 << a) - 1);
}
// after the padding: a floating section's alignment tightens so the address is aligned
// (the padding already agrees with the alignment it had, so rgbasm never refuses this)
void AlignTo(unsigned char a, unsigned int ofs) {
  if (!(sec.flags & SECT_ADDRESS) && a > sec.align) {
    sec.align = a;
    sec.ofs = (ofs - Offset()) & ((1 << a) - 1);
  }
}
