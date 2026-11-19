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

// ASM_TEXT (asm_line.c's Unit): the document is text_length bytes of PSRAM from text_block
// (MAPVIEW.MOD writes it there), read like an included file's text, in a frame over the empty
// frame 0 (length is 0). Its errors still name the document (file 0). Here because asm_line.c's
// page has no room; ADDRESS() a byte at a time, which SDCC's 32-bit shift isn't.
void DocText(void) {
  unsigned char* at = (unsigned char*)&file_at;
  unsigned int block = context->text_block;
  if (!(context->kind & ASM_TEXT)) return; // the text buffer's document
  at[0] = at[3] = 0;
  at[1] = (unsigned char)block << 1;
  at[2] = (unsigned char)(block >> 7);
  file_end = file_at + context->text_length;
  Push(F_TEXT, SRC_TEXT, file_at, file_end);
}
