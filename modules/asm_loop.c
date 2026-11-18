// ASM.MOD: FOR, INCLUDE and INCBIN's files (see asm_shared.h), in whichever page
// has room.
#include "asm_shared.h"

unsigned char Comma(void) {
  Space();
  if (ch != ',') return 0;
  Advance();
  return 1;
}

// FOR name, [start,] stop[, step]: REPT with name = start, start + step, ... while short of stop
void For(void) {
  Val a = 0, b, step = 1, size;
  unsigned int n = 0;
  Space();
  ReadIdent();
  if (!ident_len) { Fail(ASM_ERR_SYNTAX); return; }
  SaveName();
  Expect(',');
  b = Constant();
  if (Comma()) {
    a = b;
    b = Constant();
    if (Comma()) step = Constant();
  }
  if (!step) { Fail(ASM_ERR_DIVIDE); return; }
  // n = ceil(distance / |step|), with the arithmetic in Apply (assembly; SDCC's longs are big)
  size = step;
  if (step < 0) {
    b = Apply('-', a, b);
    size = Apply('-', 0, step);
  }
  else b = Apply('-', b, a);
  if (Apply('>', b, 0)) n = (unsigned int)Apply('/', Apply('+', b, Apply('-', size, 1)), size);
  DefineValue(SYM_VAR, a);
  if (!error) Repeat(n, found, step);
}

// INCBIN "file"[, start[, length]]: its bytes, from the file read whole into PSRAM
void Incbin(void) {
  Pos n; // start and length can pass 64 KiB
  if (!OpenFile()) return;
  if (Comma()) {
    n = (Pos)Constant();
    if (n > file_size) { Fail(ASM_ERR_RANGE); return; }
    file_at += n;
    if (Comma()) {
      n = (Pos)Constant();
      if (n > file_end - file_at) { Fail(ASM_ERR_RANGE); return; }
      file_end = file_at + n;
    }
  }
  EmitFile();
}

Pos file_at, file_size, file_end;
unsigned int file_top;
// Round the size up to sectors. SDCC's spilled BLOCK(size + 511) duplicated
// byte 1 into byte 2 while narrowing >>8, inflating allocations into OS backups.
static unsigned int FileBlocks(Pos size)
#ifndef HOST_TEST
__naked
#endif
{
#ifdef HOST_TEST
  return (unsigned int)((size + 511) >> 9);
#else
  size; // DEBC in, BC out; files and the rounded size are below 16 MiB
  __asm
	ld	a, c
	add	a, $FF
	ld	a, b
	adc	a, 1
	ld	c, a
	ld	a, e
	adc	a, 0
	ld	b, a
	srl	b
	rr	c
	ret
  __endasm;
#endif
}
unsigned char file_error;
// path[], read whole into PSRAM once (in pass 1): its symbol (the path's last NAME_MAX
// characters; its first block and size), and file_at, file_size. 0 if it can't be, with
// file_error ASM_ERR_FILE or ASM_ERR_FULL.
unsigned int LoadPath(void) {
  unsigned char i = 0, cached;
  ModuleLoad load;
  while (path[i]) ++i;
  i = i > NAME_MAX ? i - NAME_MAX : 0;
  for (ident_len = 0; (ident[ident_len] = path[i++]) != 0; ++ident_len);
  cached = Find() ? sym_kind == SYM_CACHED : 2; // 1: build.cache knows where it is, 2: not read yet
  if (cached) {
    load.block = file_top;
    load.blocks = ASM_FILE_END - file_top;
    i = CacheLoad(&load, cached == 1 ? sym_value : 0);
    if (i) { file_error = i == 1 ? ASM_ERR_FILE : ASM_ERR_FULL; return 0; }
    sym_value = file_top;
    sym_bank = (unsigned char)(load.size >> 16);
    sym_extra = (unsigned int)load.size;
    if (cached == 1) { // its cache record's symbol becomes the file's
      SetValue(sym_value, sym_extra);
      Entry(found)[6] = SYM_INCLUDE;
      Entry(found)[7] = sym_bank;
    }
    else Add(SYM_INCLUDE, sym_value, sym_bank);
    if (error) return 0;
    file_top += FileBlocks(load.size);
  }
  FileOf(found);
  return found;
}
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
// INCLUDE and INCBIN's "path"
unsigned int OpenFile(void) {
  unsigned char i;
  unsigned int file;
  Space();
  if (ch != '"') { Fail(ASM_ERR_SYNTAX); return 0; }
  Advance();
  for (i = 0; ch != '"'; Advance()) {
    if (ch == 0 || ch == 10 || i == sizeof(path) - 1) { Fail(ASM_ERR_STRING); return 0; }
    if (ch == '/' && i == 1 && path[0] == '.') { i = 0; continue; } // a leading "./": FatFs has no relative names
    path[i++] = ch;
  }
  path[i] = 0;
  Advance();
  if (!(file = LoadPath()) && !error) Fail(file_error);
  return file;
}
void Include(void) {
  unsigned int file = OpenFile();
  if (!file) return;
  ToEnd();
  Push(F_TEXT, SRC_TEXT, file_at, file_end)->file = file;
}
