// LINK.MOD and PREP.MOD: reading PSRAM a block's run at a time (in_block, in_ofs), and Copy:
// copy_n bytes (0: 256) from from to to, in assembly
#include "link.h"

unsigned char copy_n;
#ifdef HOST_TEST
void Copy(unsigned char* to, const unsigned char* from) { unsigned char n = copy_n; do *to++ = *from++; while (--n); }
#else
void Copy(unsigned char* to, const unsigned char* from) __naked {
  to; from; // de, bc
  __asm
	ld	a, [_copy_n]
	ld	l, a
.copy:
	ld	a, [bc]
	inc	bc
	ld	[de], a
	inc	de
	dec	l
	jr	nz, .copy
	ret
  __endasm;
}
#endif

// --- the object stream: records read a block's run at a time, and what a step doesn't need skipped
unsigned int in_block, in_ofs;
void Read(unsigned char* p, unsigned char n) {
  unsigned int left;
  while (n) {
    left = 512 - in_ofs;
    copy_n = n < left ? n : (unsigned char)left;
    Window(in_block);
    Copy(p, WINDOW + in_ofs);
    p += copy_n;
    n -= copy_n;
    in_ofs += copy_n; // apart: SDCC 4.2 dropped the store of (in_ofs += copy_n) == 512 when it wasn't
    if (in_ofs == 512) {
      in_ofs = 0;
      ++in_block;
    }
  }
}
void Skip(unsigned char n) {
  in_ofs += n;
  in_block += in_ofs >> 9;
  in_ofs &= 511;
}
