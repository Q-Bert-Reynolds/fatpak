// LINK.MOD and PREP.MOD: reading PSRAM a block's run at a time (in_block, in_ofs), and Copy:
// copy_n bytes (0: 256) from from to to, in assembly
#include "link.h"

unsigned char copy_n;
#ifdef HOST_TEST
void Copy(unsigned char* to, const unsigned char* from) { unsigned char n = copy_n; do *to++ = *from++; while (--n); }
#else
void Copy(unsigned char* to, const unsigned char* from) __naked {
  to; from; // de, bc: the odd bytes one at a time, then four at a time (the image's 1 MB through buf)
  __asm
	ld	h, b
	ld	l, c
	ld	a, [_copy_n]
	ld	b, a
	and	a, 3
	jr	z, .fours
	ld	c, a
.one:
	ld	a, [hl+]
	ld	[de], a
	inc	de
	dec	c
	jr	nz, .one
.fours:
	ld	a, b
	srl	a
	srl	a
	jr	nz, .four_n
	or	a, b
	ret	nz ; fewer than 4
	ld	a, 64 ; copy_n 0: 256
.four_n:
	ld	c, a
.four:
	ld	a, [hl+]
	ld	[de], a
	inc	de
	ld	a, [hl+]
	ld	[de], a
	inc	de
	ld	a, [hl+]
	ld	[de], a
	inc	de
	ld	a, [hl+]
	ld	[de], a
	inc	de
	dec	c
	jr	nz, .four
	ret
  __endasm;
}
#endif

// --- the object stream: records read a block's run at a time, and what a step doesn't need skipped
unsigned int in_block, in_ofs;
#ifndef HOST_TEST
// in assembly: Walk reads ~1.7 MB of beisbol's objects in records of a few bytes
void Read(unsigned char* p, unsigned char n) __naked {
  p; n; // de, a
  __asm
	or	a, a
	ret	z
	ld	c, a ; bytes left
.run:
	ld	a, [_in_block + 1]
	ld	[$BD03], a
	ld	a, [_in_block]
	ld	[$BD02], a
	ld	a, [_in_ofs]
	ld	l, a
	ld	a, [_in_ofs + 1]
	ld	b, c ; this run: all of it, unless the block ends first
	or	a, a
	jr	z, .low ; in_ofs < 256: 256 or more left
	ld	a, l
	or	a, a
	jr	z, .high ; 256 left
	cpl
	inc	a ; 512 - in_ofs
	cp	a, c
	jr	nc, .high
	ld	b, a
.high:
	ld	h, $BF
	jr	.counted
.low:
	ld	h, $BE
.counted:
	ld	a, c
	sub	a, b
	ld	c, a
	ld	a, [_in_ofs]
	add	a, b
	ld	[_in_ofs], a
	ld	a, [_in_ofs + 1]
	adc	a, 0
	cp	a, 2
	jr	nz, .same
	ld	a, [_in_block] ; the block's end: the next one from its start
	add	a, 1
	ld	[_in_block], a
	ld	a, [_in_block + 1]
	adc	a, 0
	ld	[_in_block + 1], a
	xor	a, a
.same:
	ld	[_in_ofs + 1], a
.byte:
	ld	a, [hl+]
	ld	[de], a
	inc	de
	dec	b
	jr	nz, .byte
	ld	a, c
	or	a, a
	jr	nz, .run
	ret
  __endasm;
}
#else
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
#endif
void Skip(unsigned char n) {
  in_ofs += n;
  in_block += in_ofs >> 9;
  in_ofs &= 511;
}
