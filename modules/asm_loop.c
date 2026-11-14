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
  Pos at, end, n; // start and length can pass 64 KiB
  if (!OpenFile()) return;
  at = file_at;
  end = file_end;
  if (Comma()) {
    n = (Pos)Constant();
    if (n > file_size) { Fail(ASM_ERR_RANGE); return; }
    at += n;
    if (Comma()) {
      n = (Pos)Constant();
      if (n > end - at) { Fail(ASM_ERR_RANGE); return; }
      end = at + n;
    }
  }
  for (; at < end && !error; ++at) {
    Window(BLOCK(at));
    Emit(WINDOW[(unsigned int)at & 511]);
  }
}

Pos file_at, file_size, file_end;
unsigned int file_top;
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
    file_top += BLOCK(load.size + 511);
  }
  file_at = ADDRESS(sym_value);
  file_size = sym_extra | (Pos)sym_bank << 16;
  file_end = file_at + file_size;
  return found;
}
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
