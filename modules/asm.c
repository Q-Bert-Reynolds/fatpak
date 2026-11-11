// ASM.MOD: a two-pass assembler for an RGBDS subset (notes/ASSEMBLER.md). The host
// (src/editor/build.c) runs it on the open document: the source streams in through
// ModSource, labels and constants go in a hashed table in PSRAM, and the ROM image is
// built in PSRAM from ASM_IMAGE_BLOCK with its logo and checksums fixed like rgbfix -v.
// This page reads characters: the stream, words, expressions, operands, directives and
// the line parser. asm_emit.c has the symbol table, instruction encoders and the image.
#include "asm_shared.h"

#define CHUNK MODULE_SOURCE_CHUNK
#define ROM_BANKS 64 // ASM_IMAGE_BLOCKS / 32

// --- word tables: each word is its length then its lowercase letters, a 0 length ends
// the table (Keyword only compares words of ident's length)
static const char mnemonics[] = // Instruction's order
  "\003nop\004halt\004stop\002di\002ei\004rlca\004rrca\003rla\003rra\003daa\003cpl\003scf\003ccf\004reti"
  "\002ld\003ldh\003ldi\003ldd\003add\003adc\003sub\003sbc\003and\003xor\002or\002cp\003inc\003dec\002jp\002jr\004call\003ret\003rst\004push\003pop\003rlc\003rrc\002rl\002rr\003sla\003sra\004swap\003srl\003bit\003res\003set";
static const char directives[] = // the supported ones first
  "\007section\002db\002dw\002ds\003def\005redef\006export\006global"
  "\007include\006incbin\005macro\004endm\004rept\003for\004endr\002if\004elif\004else\004endc\004load\004endl\005union\005nextu\004endu\007charmap\005print\007println\006assert\005purge\003opt\005pushs\004pops\005pusho\004popo\005align\005rsset\007rsreset\002rb\002rw\002rl\004equs";
#define DIRECTIVES 8 // the supported ones
static const char registers[] = "\001b\001c\001d\001e\001h\001l\001a\002bc\002de\002hl\002sp\002af\002nz\001z\002nc";
static const char brackets[] = "\002hl\003hli\003hld\002bc\002de\001c";
static const char functions[] = "\004high\003low\004bank";
static const char types[] = "\004rom0\004romx\004vram\004sram\005wram0\005wramx\003oam\004hram";
static const char attributes[] = "\004bank\005align";
static const char equ[] = "\003equ";
static const char* const tables[8] = {mnemonics, directives, registers, brackets, functions, types, attributes, equ};
#define T_MNEMONICS 0
#define T_DIRECTIVES 1
#define T_REGISTERS 2
#define T_BRACKETS 3
#define T_FUNCTIONS 4
#define T_TYPES 5
#define T_ATTRIBUTES 6
#define T_EQU 7

// the index of ident in one of the tables, 0xFF if absent
static unsigned char Keyword(unsigned char which) {
  const char* table = tables[which];
  unsigned char index = 0, i, length;
  while ((length = *table++) != 0) {
    if (length == ident_len) {
      for (i = 0; i < length && (ident[i] | 0x20) == table[i]; ++i);
      if (i == length) return index;
    }
    table += length;
    ++index;
  }
  return 0xFF;
}
static unsigned char IsStart(unsigned char c) {
  c |= 0x20;
  return (c >= 'a' && c <= 'z') || c == '_' || c == '.';
}


#define CHUNK MODULE_SOURCE_CHUNK

// --- source stream
AsmContext* context;
static char buf[CHUNK];
unsigned char at, count; // buf[at] is the next character, count are valid
unsigned int pos; // source position of buf[0]
unsigned char ch;
unsigned char error, pass;
unsigned int line, line_pos;
void Advance(void) {
  if (error) { ch = 0; return; }
  if (at >= count) {
    pos += count;
    count = ModSource(pos, buf);
    at = 0;
    if (!count) { ch = 0; return; }
  }
  ch = buf[at++];
}
// the first error ends the statement and the pass: everything after looks like the end
void Fail(unsigned char code) {
  if (!error) error = code;
  ch = 0;
}
void Space(void) { while (ch == ' ' || ch == '\t' || ch == '\r') Advance(); }
unsigned char AtEnd(void) { return ch == 0 || ch == 10 || ch == ';'; }
void Expect(unsigned char c) {
  Space();
  if (ch != c) Fail(ASM_ERR_SYNTAX);
  else Advance();
}


// --- words
char ident[NAME_MAX + 1], name[NAME_MAX + 1]; // the word read; a name kept while its value is read
unsigned char ident_len;

static unsigned char IsDigit(unsigned char c) { return c >= '0' && c <= '9'; }
static unsigned char IsIdentStart(unsigned char c) {
  c |= 0x20;
  return (c >= 'a' && c <= 'z') || c == '_' || c == '.';
}
static unsigned char IsIdentChar(unsigned char c) { return IsIdentStart(c) || IsDigit(c); }
void ReadIdent(void) {
  ident_len = 0;
  while (IsIdentChar(ch)) {
    if (ident_len == NAME_MAX) { Fail(ASM_ERR_NAME); return; }
    ident[ident_len++] = ch;
    Advance();
  }
  ident[ident_len] = 0;
}
void SaveName(void) {
  unsigned char i;
  for (i = 0; i <= ident_len; ++i) name[i] = ident[i];
}
void LoadName(void) {
  for (ident_len = 0; (ident[ident_len] = name[ident_len]) != 0; ++ident_len);
}


// --- sections
static unsigned char max_bank;
static unsigned int rom_cursor[ROM_BANKS], ram_cursor[16]; // where the next unplaced section goes
static unsigned char cursor; // the current section's index into those

// region (type) base, size, bank count and the ram_cursor index of its first bank
static const unsigned int region_base[8] = {0, 0x4000, 0x8000, 0xA000, 0xC000, 0xD000, 0xFE00, 0xFF80};
static const unsigned int region_size[8] = {0x4000, 0x4000, 0x2000, 0x2000, 0x1000, 0x1000, 0xA0, 0x7F};
static const unsigned char region_banks[8] = {1, ROM_BANKS, 2, 4, 1, 8, 1, 1};
static const unsigned char region_first[8] = {0, 0, 0, 2, 6, 7, 14, 15};
static const unsigned char cursor_type[16] = {2, 2, 3, 3, 3, 3, 4, 5, 5, 5, 5, 5, 5, 5, 6, 7};

static void CloseSection(void) {
  if (!in_section) return;
  if (sec_rom) { if (pc > rom_cursor[cursor]) rom_cursor[cursor] = pc; }
  else if (pc > ram_cursor[cursor]) ram_cursor[cursor] = pc;
  in_section = 0;
}


// --- expressions
unsigned char undefined; // a symbol wasn't defined yet (pass 1 only)
unsigned char pending; // ident holds the expression's first word already
unsigned char bracket, mem_c; // inside [ ]: "c" means the register
static unsigned char op, op_level; // the binary operator read ahead

static unsigned int Binary(unsigned char min);

// v * base for 2, 8, 10 and 16, without the general multiply (asm_emit.c)
static unsigned int Scale(unsigned int v, unsigned char base) {
  if (base == 10) return (v << 3) + (v << 1);
  while (base > 1) { v <<= 1; base >>= 1; }
  return v;
}
static unsigned int Number(unsigned char base) {
  unsigned int v = 0;
  unsigned char d, any = 0;
  while (1) {
    d = ch;
    if (d == '_') { Advance(); continue; }
    if (IsDigit(d)) d -= '0';
    else if ((d | 0x20) >= 'a' && (d | 0x20) <= 'f') d = (d | 0x20) - 'a' + 10;
    else break;
    if (d >= base) break;
    v = Scale(v, base) + d;
    any = 1;
    Advance();
  }
  if (!any) Fail(ASM_ERR_SYNTAX);
  return v;
}
unsigned char Char(void) { // a character of a string or literal, quotes end it
  unsigned char c = ch;
  if (c == 0 || c == 10) { Fail(ASM_ERR_STRING); return 0; }
  Advance();
  if (c != '\\') return c;
  c = ch;
  Advance();
  if (c == 'n') return 10;
  if (c == 't') return 9;
  if (c == 'r') return 13;
  if (c == '0') return 0;
  if (c == '\\' || c == '"' || c == '\'') return c;
  Fail(ASM_ERR_STRING);
  return 0;
}
static char local[NAME_MAX + 1];
static unsigned int Lookup(void) { // ident's value (Global.local too), 0 and undefined when it has none yet
  unsigned char i, dot = 0, ok;
  unsigned int outer = scope;
  for (i = 1; i < ident_len; ++i) if (ident[i] == '.') dot = i;
  if (dot) {
    for (i = dot; i <= ident_len; ++i) local[i - dot] = ident[i];
    ident_len = dot;
    ident[dot] = 0;
    ok = Find();
    scope = found;
    for (i = 0; (ident[i] = local[i]) != 0; ++i);
    ident_len = i;
    if (ok) ok = Find();
    scope = outer;
  }
  else ok = Find();
  if (ok) return sym_value;
  if (pass == 2) Fail(ASM_ERR_SYMBOL);
  undefined = 1;
  return 0;
}
static unsigned int Symbol(void) { // ident is a name, a function or the register c
  unsigned int v;
  unsigned char k = Keyword(T_FUNCTIONS);
  if (k != 0xFF) {
    Space();
    if (ch == '(') {
      Advance();
      Space();
      if (k == 2) {
        if (ch == '@') { Advance(); v = sec_bank; }
        else {
          ReadIdent();
          if (!ident_len) Fail(ASM_ERR_SYNTAX);
          Lookup();
          v = sym_bank;
        }
      }
      else {
        v = Binary(1);
        if (k) v &= 0xFF; else v >>= 8;
      }
      Expect(')');
      return v;
    }
  }
  if (bracket && ident_len == 1 && (ident[0] | 0x20) == 'c') { mem_c = 1; return 0; }
  return Lookup();
}
static unsigned int Primary(void) {
  unsigned int v;
  unsigned char c;
  if (pending) { pending = 0; return Symbol(); }
  Space();
  c = ch;
  if (c == '(') {
    Advance();
    v = Binary(1);
    Expect(')');
    return v;
  }
  if (c == '-') { Advance(); return -Primary(); }
  if (c == '+') { Advance(); return Primary(); }
  if (c == '~') { Advance(); return ~Primary(); }
  if (c == '!') { Advance(); return !Primary(); }
  if (c == '$') { Advance(); return Number(16); }
  if (c == '%') { Advance(); return Number(2); }
  if (c == '&') { Advance(); return Number(8); }
  if (IsDigit(c)) return Number(10);
  if (c == '\'') {
    Advance();
    v = Char();
    if (ch != '\'') Fail(ASM_ERR_STRING);
    else Advance();
    return v;
  }
  if (c == '@') { Advance(); return pc; }
  if (IsIdentStart(c)) { ReadIdent(); return Symbol(); }
  Fail(ASM_ERR_SYNTAX);
  return 0;
}
// the binary operator at ch into op (0 if none): || && == != < > <= >= + - & | ^ << >> * / %
static void ReadOp(void) {
  unsigned char c, n;
  Space();
  c = ch;
  op = 0;
  if (c == '|' || c == '&' || c == '=' || c == '!' || c == '<' || c == '>') {
    Advance();
    n = ch;
    if (n == c && c != '!') {
      Advance();
      op = c == '|' ? 'L' : c == '&' ? 'A' : c == '=' ? 'E' : c == '<' ? 's' : 'r';
    }
    else if (n == '=' && (c == '!' || c == '<' || c == '>')) {
      Advance();
      op = c == '!' ? 'N' : c == '<' ? 'l' : 'g';
    }
    else if (c == '=' || c == '!') { Fail(ASM_ERR_SYNTAX); return; }
    else op = c;
  }
  else if (c == '+' || c == '-' || c == '*' || c == '/' || c == '%' || c == '^') { Advance(); op = c; }
  else return;
  switch (op) {
    case 'L': op_level = 1; break;
    case 'A': op_level = 2; break;
    case 'E': case 'N': case '<': case '>': case 'l': case 'g': op_level = 3; break;
    case '+': case '-': op_level = 4; break;
    case '&': case '|': case '^': op_level = 5; break;
    case 's': case 'r': op_level = 6; break;
    default: op_level = 7;
  }
}
static unsigned int Binary(unsigned char min) {
  unsigned int left = Primary(), right;
  unsigned char o, level;
  while (1) {
    if (!op) ReadOp();
    if (!op || op_level < min) return left;
    o = op;
    level = op_level;
    op = 0;
    right = Binary(level + 1);
    left = Apply(o, left, right);
  }
}
unsigned int Eval(void) {
  op = 0;
  return Binary(1);
}
unsigned int Constant(void) { // an expression that must be known in pass 1: sizes, addresses
  unsigned int v = Eval();
  if (undefined) Fail(ASM_ERR_FORWARD);
  return v;
}


// --- operands
unsigned char okind[2], oreg[2], nops;
unsigned int oval[2];

static void ParseOp(unsigned char i) {
  unsigned char kind = K_IMM, reg = 0;
  unsigned int v = 0;
  Space();
  if (ch == '[') {
    Advance();
    Space();
    bracket = 1;
    mem_c = 0;
    if (IsStart(ch)) {
      ReadIdent();
      reg = Keyword(T_BRACKETS);
      if (reg == 0) {
        Space();
        if (ch == '+') { Advance(); reg = 1; }
        else if (ch == '-') { Advance(); reg = 2; }
      }
      if (reg == 0) { kind = K_R8; reg = 6; }
      else if (reg <= 2) { kind = K_MEMR; reg += 1; }
      else if (reg <= 4) { kind = K_MEMR; reg -= 3; }
      else if (reg == 5) kind = K_MEMC;
      else { pending = 1; kind = K_MEM; v = Eval(); }
    }
    else { kind = K_MEM; v = Eval(); }
    if (mem_c) kind = K_MEMC;
    bracket = 0;
    Expect(']');
  }
  else if (IsStart(ch)) {
    ReadIdent();
    reg = Keyword(T_REGISTERS);
    if (reg <= 6) { kind = K_R8; if (reg == 6) reg = 7; }
    else if (reg <= 10) {
      kind = K_R16;
      reg -= 7;
      if (reg == 3) {
        Space();
        if (ch == '+' || ch == '-') {
          kind = K_SPREL;
          if (ch == '-') { Advance(); v = -Eval(); }
          else { Advance(); v = Eval(); }
        }
      }
    }
    else if (reg == 11) kind = K_AF;
    else if (reg <= 14) { kind = K_COND; reg -= 12; }
    else { pending = 1; v = Eval(); }
  }
  else v = Eval();
  okind[i] = kind;
  oreg[i] = reg;
  oval[i] = v;
}
static void Operands(void) {
  nops = 0;
  Space();
  if (AtEnd()) return;
  ParseOp(0);
  nops = 1;
  Space();
  if (ch == ',') {
    Advance();
    ParseOp(1);
    nops = 2;
  }
}

// --- directives
static void Define(unsigned char kind) { // name gets the value at ch
  unsigned int v = Constant();
  LoadName();
  if (error) return;
  if (Find()) {
    if (kind == SYM_VAR || pass == 2) SetValue(v);
    else Fail(ASM_ERR_DUPLICATE);
  }
  else if (pass == 1) Add(kind, v, 0);
  else Fail(ASM_ERR_PHASE);
}
static void Label(void) { // ident
  unsigned char local = ident[0] == '.';
  if (!in_section) { Fail(ASM_ERR_SECTION); return; }
  if (local && !scope) { Fail(ASM_ERR_SCOPE); return; }
  if (Find()) {
    if (pass == 1 || sym_value != pc) Fail(pass == 1 ? ASM_ERR_DUPLICATE : ASM_ERR_PHASE);
  }
  else if (pass == 1) Add(SYM_LABEL, pc, sec_bank);
  else Fail(ASM_ERR_PHASE);
  if (!local) scope = found;
}
static void Section(void) {
  unsigned char type, bank, align = 0, placed = 0;
  unsigned int address = 0, size;
  CloseSection();
  Space();
  if (ch != '"') { Fail(ch ? ASM_ERR_UNSUPPORTED : ASM_ERR_SYNTAX); return; }
  Advance();
  while (ch != '"') { if (!ch || ch == 10) { Fail(ASM_ERR_SYNTAX); return; } Advance(); }
  Advance();
  Expect(',');
  Space();
  ReadIdent();
  type = Keyword(T_TYPES);
  if (type == 0xFF) { Fail(ASM_ERR_SYNTAX); return; }
  bank = type == 1 || type == 5;
  Space();
  if (ch == '[') { Advance(); address = Constant(); Expect(']'); placed = 1; }
  while (!error) {
    Space();
    if (ch != ',') break;
    Advance();
    Space();
    ReadIdent();
    type |= Keyword(T_ATTRIBUTES) << 4; // 0 bank, 1 align, else 0xF: unsupported
    Expect('[');
    size = Constant();
    Expect(']');
    if (type < 0x10) bank = (unsigned char)size;
    else if (type < 0x20) align = (unsigned char)size;
    else Fail(ASM_ERR_UNSUPPORTED);
    type &= 15;
  }
  if (error) return;
  if (bank >= region_banks[type] || ((type == 1 || type == 5) && !bank)) { Fail(ASM_ERR_BANK); return; }
  sec_rom = type < 2;
  sec_bank = bank;
  cursor = sec_rom ? bank : region_first[type] + bank - (type == 5);
  sec_last = region_base[type] + region_size[type] - 1;
  pc = placed ? address : sec_rom ? rom_cursor[cursor] : ram_cursor[cursor];
  if (align) {
    size = (1 << align) - 1;
    pc = (pc + size) & ~size;
  }
  if (pc < region_base[type] || pc > sec_last) { Fail(ASM_ERR_FULL); return; }
  if (sec_rom && bank > max_bank) max_bank = bank;
  in_section = 1;
}
static void Data(unsigned char word) { // db, dw
  unsigned int v;
  Space();
  if (AtEnd()) { Reserve(word + 1, 0); return; }
  while (!error) {
    Space();
    if (ch == '"' && !word) {
      Advance();
      while (ch != '"' && !error) Emit(Char());
      Advance();
    }
    else {
      v = Eval();
      if (word) Emit16(v); else Emit8(v);
    }
    Space();
    if (ch != ',') break;
    Advance();
  }
}
static void Ds(void) { // ds count[, fill]
  unsigned int n = Constant();
  unsigned char fill = 0;
  Space();
  if (ch == ',') {
    Advance();
    fill = (unsigned char)Eval();
    if (!sec_rom) { Fail(ASM_ERR_SECTION); return; }
  }
  Reserve(n, fill);
}
// the word in ident starts a statement
static void Statement(void) {
  unsigned char m = Keyword(T_MNEMONICS), d;
  if (m != 0xFF) { Operands(); Instruction(m); return; }
  d = Keyword(T_DIRECTIVES);
  if (d == 0) Section();
  else if (d <= 2) Data(d - 1);
  else if (d == 3) Ds();
  else if (d <= 5) { // def name equ|= expr, redef name = expr
    Space();
    ReadIdent();
    if (!ident_len) { Fail(ASM_ERR_SYNTAX); return; }
    SaveName();
    Space();
    if (ch == '=') { Advance(); Define(SYM_VAR); }
    else {
      ReadIdent();
      if (d == 5 || Keyword(T_EQU) != 0) Fail(ASM_ERR_SYNTAX);
      else Define(SYM_EQU);
    }
  }
  else if (d <= 7) { while (ch && ch != 10) Advance(); } // export, global: labels are visible anyway
  else if (d == 0xFF) Fail(ASM_ERR_MNEMONIC);
  else Fail(ASM_ERR_UNSUPPORTED);
}
static void Line(void) {
  unsigned char statement = 0;
  undefined = 0;
  line_pos = pos + at - 1;
  if (IsStart(ch)) { // a label, a definition or a statement at column 0
    ReadIdent();
    if (ch == ':') {
      Advance();
      if (ch == ':') Advance();
      Label();
    }
    else if (ident[0] == '.') Label();
    else {
      statement = 1;
      Space();
      Statement();
    }
  }
  Space();
  if (!statement && !AtEnd()) {
    ReadIdent();
    if (!ident_len) { Fail(ASM_ERR_SYNTAX); return; }
    Statement();
    Space();
  }
  if (ch == ';') while (ch && ch != 10) Advance();
  if (ch == 10) { Advance(); ++line; }
  else if (ch) Fail(ASM_ERR_SYNTAX);
}


static void Pass(unsigned char p) {
  unsigned char i;
  pass = p;
  pos = count = at = 0;
  line = 1;
  scope = 0;
  in_section = 0;
  for (i = 0; i < ROM_BANKS; ++i) rom_cursor[i] = i ? 0x4000 : 0;
  for (i = 0; i < 16; ++i) ram_cursor[i] = region_base[cursor_type[i]];
  Advance();
  while (ch && !error) Line();
  CloseSection();
}


unsigned char ModuleMain(AsmContext* c) {
  unsigned int blocks, i;
  context = c;
  c->symbols = 0;
  next_unit = 1; // unit 0 means "none"
  for (i = 0; i < 256; ++i) heads[i] = 0;
  Pass(1);
  if (!error && !rom_used) Fail(ASM_ERR_EMPTY);
  if (!error) {
    for (blocks = 64; blocks < (unsigned int)(max_bank + 1) << 5; blocks <<= 1);
    c->blocks = blocks;
    Fill();
    Pass(2);
  }
  if (!error) Header();
  c->line = line;
  c->pos = line_pos;
  return error;
}
