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
  Val a = 0, b, step = 1;
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
  if (step < 0) { if (a > b) n = Div((UVal)a - b - step - 1, 0 - (UVal)step); }
  else if (a < b) n = Div((UVal)b - a + step - 1, step);
  DefineValue(SYM_VAR, a);
  if (!error) Repeat(n, found, step);
}

// INCBIN "file"[, start[, length]]: its bytes, from the file read whole into PSRAM
void Incbin(void) {
  Pos at, end;
  unsigned int n;
  if (!OpenFile()) return;
  at = file_at;
  end = at + file_size;
  if (Comma()) {
    n = Constant();
    if (n > file_size) { Fail(ASM_ERR_RANGE); return; }
    at += n;
    if (Comma()) {
      n = Constant();
      if (n > end - at) { Fail(ASM_ERR_RANGE); return; }
      end = at + n;
    }
  }
  for (; at < end && !error; ++at) {
    Window(BLOCK(at));
    Emit(WINDOW[(unsigned int)at & 511]);
  }
}

Pos file_at, file_size;
unsigned int file_top;
unsigned int OpenFile(void) {
  unsigned char i;
  ModuleLoad load;
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
  // the path (its last NAME_MAX characters) is its symbol: its first block and size. Each
  // file is read once, in pass 1.
  i = i > NAME_MAX ? i - NAME_MAX : 0;
  for (ident_len = 0; (ident[ident_len] = path[i++]) != 0; ++ident_len);
  if (!Find()) {
    load.block = file_top;
    load.blocks = ASM_FILE_END - file_top;
    i = ModLoad(path, &load);
    if (i) { Fail(i == 1 ? ASM_ERR_FILE : ASM_ERR_FULL); return 0; }
    sym_value = file_top;
    sym_bank = (unsigned char)(load.size >> 16);
    sym_extra = (unsigned int)load.size;
    Add(SYM_INCLUDE, sym_value, sym_bank);
    if (error) return 0;
    file_top += BLOCK(load.size + 511);
  }
  file_at = ADDRESS(sym_value);
  file_size = sym_extra | (Pos)sym_bank << 16;
  return found;
}
void Include(void) {
  unsigned int file = OpenFile();
  if (!file) return;
  ToEnd();
  Push(F_TEXT, SRC_TEXT, file_at, file_at + file_size)->file = file;
}
