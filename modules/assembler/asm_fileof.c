// ASM.MOD: a file's place in PSRAM from its symbol (asm_loop.c reads the files; this is on
// another page for room)
#include "asm_shared.h"

// file_at, file_size and file_end of a file's symbol: its first block (bytes 4-5), its size (8, 9, 7)
#ifdef HOST_TEST
void FileOf(unsigned int file) {
  unsigned char* e = Entry(file);
  file_at = ADDRESS(e[4] | (e[5] << 8));
  file_size = (e[8] | (e[9] << 8)) | (Pos)e[7] << 16;
  file_end = file_at + file_size;
}
#else
void FileOf(unsigned int file) __naked {
  file; // de
  __asm
	call	_Entry
	ld	hl, 4
	add	hl, bc
	ld	a, [hl+]
	ld	e, a
	ld	d, [hl]
	ld	hl, _file_at
	xor	a, a
	ld	[hl+], a
	ld	a, e
	add	a, a
	ld	[hl+], a
	ld	a, d
	adc	a, a
	ld	[hl+], a
	ld	a, 0
	adc	a, a
	ld	[hl], a
	ld	hl, 7
	add	hl, bc
	ld	a, [hl+]
	ld	d, a
	ld	a, [hl+]
	ld	e, a
	ld	a, [hl]
	ld	hl, _file_size
	ld	[hl], e
	inc	hl
	ld	[hl+], a
	ld	a, d
	ld	[hl+], a
	ld	[hl], 0
	ld	bc, _file_end
	ld	de, _file_at
	ld	hl, _file_size
	ld	a, [de]
	add	a, [hl]
	ld	[bc], a
	inc	bc
	inc	de
	inc	hl
	ld	a, [de]
	adc	a, [hl]
	ld	[bc], a
	inc	bc
	inc	de
	inc	hl
	ld	a, [de]
	adc	a, [hl]
	ld	[bc], a
	inc	bc
	inc	de
	inc	hl
	ld	a, [de]
	adc	a, [hl]
	ld	[bc], a
	ret
  __endasm;
}
#endif
