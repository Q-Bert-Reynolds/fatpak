// ASM.MOD, third page: lines, directives, conditionals, repeats, macros, includes and
// sections (see asm_shared.h). asm.c reads characters and expressions for it.
#include "asm_shared.h"


// --- sections and their placement. Pass 1 records each section; a section without an
// address starts at its region's base for the pass (labels are relocated after). Link then
// places them the way rgblink does, and pass 2 assembles each at its final place.
unsigned char max_bank;
Sect sects[ASM_SECTIONS];
unsigned char nsects, cur; // sections seen this pass, the current one

// region (type) base, size, bank count, first bank
static const unsigned int region_base[8] = {0, 0x4000, 0x8000, 0xA000, 0xC000, 0xD000, 0xFE00, 0xFF80};
static const unsigned int region_size[8] = {0x4000, 0x4000, 0x2000, 0x2000, 0x1000, 0x1000, 0xA0, 0x7F};
static const unsigned char region_banks[8] = {1, ROM_BANKS, 2, 4, 1, 8, 1, 1};

static void CloseSection(void) {
  if (!in_section) return;
  if (pass == 1) sects[cur].size = pc - sects[cur].start;
  in_section = 0;
}

// rgblink's order: address and bank given, then bank (one-bank regions count), then address,
// then neither; within those aligned first, then bigger, then later in the source
static unsigned char Rank(const Sect* s) {
  unsigned char bank = (s->flags & SECT_BANK) || region_banks[s->type] == 1;
  if (s->flags & SECT_ADDRESS) return bank ? 0 : 2;
  return bank ? 1 : 3;
}
static unsigned char Before(const Sect* a, unsigned char ia, const Sect* b, unsigned char ib) {
  unsigned char ra = Rank(a), rb = Rank(b);
  if (ra != rb) return ra < rb;
  if (!a->align != !b->align) return a->align != 0;
  if (a->size != b->size) return a->size > b->size;
  return ia > ib;
}
// the lowest address at or after at, aligned by mask, where s fits in bank among those placed
static unsigned char Fits(unsigned char index, unsigned int at) {
  Sect* s = &sects[index];
  Sect* t;
  unsigned char i;
  unsigned long end = (unsigned long)at + s->size;
  if (at < region_base[s->type] || end > (unsigned long)region_base[s->type] + region_size[s->type]) return 0;
  for (i = 0, t = sects; i < nsects; ++i, ++t)
    if ((t->flags & SECT_PLACED) && t->size && t->type == s->type && t->bank == s->bank &&
        at < t->base + t->size && t->base < end) return 0;
  return 1;
}
// places every section like rgblink; 0xFF, or the index of one that can't be placed
unsigned char Link(void) {
  unsigned char n, i, best, bank, last, found;
  unsigned int mask, at, try;
  Sect *s, *t;
  max_bank = 0;
  for (n = 0; n < nsects; ++n) {
    best = 0xFF;
    for (i = 0; i < nsects; ++i)
      if (!(sects[i].flags & SECT_PLACED) && (best == 0xFF || Before(&sects[i], i, &sects[best], best))) best = i;
    s = &sects[best];
    mask = (1 << s->align) - 1;
    bank = (s->flags & SECT_BANK) ? s->bank : s->type == 1 || s->type == 5;
    last = (s->flags & SECT_BANK) ? bank : region_banks[s->type] - 1;
    found = 0;
    if (!s->size) { // empty: its address, or the region's start; it takes no room
      s->bank = bank;
      s->base = (s->flags & SECT_ADDRESS) ? s->start : (region_base[s->type] + mask) & ~mask;
      found = 1;
    }
    for (; !found && bank <= last; ++bank) {
      s->bank = bank;
      if (s->flags & SECT_ADDRESS) { found = Fits(best, s->base = s->start); continue; }
      at = 0xFFFF; // the lowest candidate: the region's start or a placed section's end
      try = (region_base[s->type] + mask) & ~mask;
      if (Fits(best, try)) at = try;
      for (i = 0, t = sects; i < nsects; ++i, ++t)
        if ((t->flags & SECT_PLACED) && t->size && t->type == s->type && t->bank == bank) {
          try = (t->base + t->size + mask) & ~mask;
          if (try >= t->base + t->size && try < at && Fits(best, try)) at = try;
        }
      if (at != 0xFFFF) { s->base = at; found = 1; }
    }
    if (!found) return best;
    s->flags |= SECT_PLACED;
    if (s->type < 2 && s->bank > max_bank) max_bank = s->bank; // empty ones too, like rgblink
  }
  return 0xFF;
}


// --- operands (the variables are in asm.c)
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
void Operands(void) {
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
static unsigned int if_active, if_taken; // bit per open IF level
static unsigned char if_depth;
static unsigned int rs; // RSSET/RB counter

void DefineValue(unsigned char kind, unsigned int v) { // name gets v
  LoadName();
  if (error) return;
  if (Find()) {
    if (kind == SYM_VAR || pass == 2) SetValue(v);
    else Fail(ASM_ERR_DUPLICATE);
    if (pass == 2) Mark();
  }
  else Add(pass == 2 ? kind | SYM_SEEN : kind, v, 0); // pass 2 too: it may have been PURGEd
}
static void Define(unsigned char kind) { DefineValue(kind, Constant()); }
void Label(void) { // ident
  unsigned char local = ident[0] == '.';
  if (!in_section) { Fail(ASM_ERR_SECTION); return; }
  if (local && !scope) { Fail(ASM_ERR_SCOPE); return; }
  if (Find()) {
    if (pass == 1 || sym_value != pc) Fail(pass == 1 ? ASM_ERR_DUPLICATE : ASM_ERR_PHASE);
    else Mark();
  }
  else if (pass == 1) { sym_extra = cur; Add(SYM_LABEL, pc, sec_bank); }
  else Fail(ASM_ERR_PHASE);
  if (!local) scope = found;
}
static void Section(void) {
  unsigned char type, bank, align = 0, placed = 0, fixed = 0;
  unsigned int address = 0, size;
  Sect* s;
  Frame* f;
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
    if (type < 0x10) { bank = (unsigned char)size; fixed = SECT_BANK; }
    else if (type < 0x20) align = (unsigned char)size;
    else Fail(ASM_ERR_UNSUPPORTED);
    type &= 15;
  }
  if (error) return;
  if (bank >= region_banks[type] || ((type == 1 || type == 5) && !bank) || align > 13) { Fail(ASM_ERR_BANK); return; }
  if (placed && (address < region_base[type] || address - region_base[type] >= region_size[type])) { Fail(ASM_ERR_FULL); return; }
  if (pass == 1) {
    if (nsects == ASM_SECTIONS) { Fail(ASM_ERR_NESTING); return; }
    s = &sects[cur = nsects++];
    s->type = type;
    s->bank = bank;
    s->align = align;
    s->flags = fixed | (placed ? SECT_ADDRESS : 0);
    size = (1 << align) - 1;
    s->start = placed ? address : (region_base[type] + size) & ~size; // for this pass
    f = TextFrame();
    s->file = f->source;
    s->line = f->line;
    s->pos = frames[0].line_pos;
  }
  else s = &sects[cur = nsects++];
  sec_rom = type < 2;
  sec_bank = s->bank;
  sec_last = region_base[type] + region_size[type] - 1;
  pc = pass == 1 ? s->start : s->base;
  in_section = 1;
}
static void Data(unsigned char word) { // db, dw
  unsigned int v;
  Space();
  if (AtEnd()) { Reserve(word + 1, 0); return; }
  while (!error) {
    Space();
    if (IsStart(ch)) { // a string function, or the start of an expression
      ReadIdent();
      pending = 1;
    }
    if (!word && (ch == '"' && !pending || pending && Keyword(T_STRFUNCS) != 0xFF)) {
      v = StrExpr();
      while (v < str_top) Emit(str[v++]);
      str_top = 0; // used up
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
// IF/ELIF/ELSE/ENDC: when the open level isn't running, skip to the branch that is
static void IfSkip(void) {
  unsigned int bit = 1 << if_depth;
  unsigned char d;
  while (!error && !(if_active & bit)) {
    d = Scan(SKIP_IF);
    if (d == D_ENDC) { --if_depth; return; }
    if (d == D_ELSE) { if (!(if_taken & bit)) if_active |= bit; }
    else if (d == D_ELIF && !(if_taken & bit) && Eval()) if_active |= bit;
    if (if_active & bit) if_taken |= bit;
    ToEnd();
  }
}
static void If(void) {
  unsigned int bit;
  if (if_depth == 15) { Fail(ASM_ERR_NESTING); return; }
  bit = 1 << ++if_depth;
  if_active &= ~bit;
  if_taken &= ~bit;
  if (Eval()) if_active |= if_taken |= bit;
  else { ToEnd(); IfSkip(); }
}
void Repeat(unsigned int n, unsigned int unit, unsigned int step) {
  unsigned int start, start_line;
  Frame* f;
  ToEnd();
  f = TextFrame();
  start = f->pos;
  start_line = f->line + 1; // the body starts on the line after REPT, whose line feed is still in ch
  Scan(SKIP_REPT);
  ToEnd(); // ENDR's line, so the body takes over at its line feed
  if (error || !n) return;
  f = Push(F_REPT, f->source, start, scan_begin);
  f->count = n;
  f->line = f->first_line = start_line;
  f->id = ++unique;
  f->for_unit = unit;
  f->for_step = step;
}
static void Rept(void) {
  unsigned int n = Constant();
  if (!error) Repeat(n, 0, 0);
}
static void Macro(void) {
  unsigned int start;
  Frame* f;
  Space();
  ReadIdent();
  if (!ident_len) { Fail(ASM_ERR_SYNTAX); return; }
  SaveName();
  ToEnd();
  f = TextFrame();
  start = f->pos;
  Scan(SKIP_MACRO);
  if (error) return;
  sym_extra = scan_begin;
  LoadName();
  if (Find()) { if (pass == 2) Mark(); else Fail(ASM_ERR_DUPLICATE); }
  else Add(pass == 2 ? SYM_MACRO | SYM_SEEN : SYM_MACRO, start, f->source); // pass 2: after a PURGE
}
// ident is a macro: its arguments (top-level commas separate them) go to args[], its body
// becomes a frame. The line feed stays for Line.
static void Invoke(void) {
  unsigned char first = arg_top, n = 0, nest = 0, quoted = 0;
  unsigned int start = sym_value, end = sym_extra;
  unsigned char source = sym_bank;
  Frame* f;
  Space();
  while (!AtEnd() || quoted) {
    if (ch == 0 || ch == 10) { Fail(ASM_ERR_STRING); return; }
    if (ch == ',' && !nest && !quoted) {
      while (arg_top > first && args[arg_top - 1] == ' ') --arg_top; // trailing spaces
      args[arg_top++] = 0;
      ++n;
      Advance();
      Space();
      continue;
    }
    if (ch == '"') quoted ^= 1;
    else if (!quoted && (ch == '(' || ch == '[')) ++nest;
    else if (!quoted && (ch == ')' || ch == ']') && nest) --nest;
    if (arg_top == sizeof(args) - 1) { Fail(ASM_ERR_NESTING); return; }
    args[arg_top++] = ch;
    Advance();
  }
  if (arg_top > first) {
    while (args[arg_top - 1] == ' ') --arg_top;
    args[arg_top++] = 0;
    ++n;
  }
  ToEnd(); // a comment or CR: the body takes over at the line feed
  f = Push(F_MACRO, source, start, end);
  f->args = first;
  f->nargs = n;
  f->id = ++unique;
}
unsigned char OpenFile(void) {
  unsigned char i;
  unsigned int length;
  Space();
  if (ch != '"') { Fail(ASM_ERR_SYNTAX); return 0; }
  Advance();
  for (i = 0; ch != '"'; ++i) {
    if (ch == 0 || ch == 10 || i == sizeof(path) - 1) { Fail(ASM_ERR_STRING); return 0; }
    path[i] = ch;
    Advance();
  }
  path[i] = 0;
  Advance();
  // the path is its symbol (hashed on up to NAME_MAX characters), its source number the value
  for (ident_len = 0; ident_len < NAME_MAX && path[ident_len]; ++ident_len) ident[ident_len] = path[ident_len];
  ident[ident_len] = 0;
  if (Find()) i = (unsigned char)sym_value;
  else {
    if (includes == ASM_INCLUDES) { Fail(ASM_ERR_NESTING); return 0; }
    length = ModFile(path, ASM_INCLUDE_BLOCK + ((unsigned int)includes << 7));
    if (!length || length == 0xFFFF) { Fail(length ? ASM_ERR_FULL : ASM_ERR_FILE); return 0; }
    inc_len[includes++] = length;
    i = includes;
    Add(SYM_INCLUDE, i, 0);
  }
  return i;
}
static void Include(void) {
  unsigned char i = OpenFile();
  if (!i) return;
  ToEnd();
  Push(F_TEXT, i, 0, inc_len[i - 1]);
}
static void Shift(void) { // the enclosing macro drops its first argument
  Frame* m = &frames[depth];
  while (m > frames && m->kind != F_MACRO) --m;
  if (m->kind != F_MACRO || !m->nargs) { Fail(ASM_ERR_SYNTAX); return; }
  while (args[m->args++]);
  --m->nargs;
}
// the word in ident starts a statement
void Statement(void) {
  unsigned char m = Keyword(T_MNEMONICS), d, k;
  unsigned int v;
  if (m != 0xFF) { Operands(); Instruction(m); return; }
  d = Keyword(T_DIRECTIVES);
  switch (d) {
    case D_SECTION: Section(); break;
    case D_DB: case D_DB + 1: Data(d - D_DB); break;
    case D_DS: Ds(); break;
    case D_DEF: case D_REDEF: // def name equ|=|rb|rw|rl ..., redef name = expr
      Space();
      ReadIdent();
      if (!ident_len) { Fail(ASM_ERR_SYNTAX); return; }
      SaveName();
      Space();
      if (ch == '=') { Advance(); Define(SYM_VAR); break; }
      ReadIdent();
      k = Keyword(T_DEFINERS);
      if (k == 4) { // EQUS
        redef = d == D_REDEF;
        DefineString(StrExpr());
        break;
      }
      if (d == D_REDEF || k == 0xFF) { Fail(ASM_ERR_SYNTAX); return; }
      if (k == 0) { Define(SYM_EQU); break; }
      Space();
      v = AtEnd() ? 1 : Constant();
      DefineValue(SYM_EQU, rs);
      rs += v << (k - 1);
      break;
    case D_INCLUDE: Include(); break;
    case D_IF: If(); break;
    case D_ELIF: case D_ELSE: // the running branch is done: skip to ENDC
      if (!if_depth) { Fail(ASM_ERR_SYNTAX); return; }
      if_active &= ~(1 << if_depth);
      ToEnd();
      IfSkip();
      break;
    case D_ENDC:
      if (!if_depth) Fail(ASM_ERR_SYNTAX);
      else --if_depth;
      break;
    case D_MACRO: Macro(); break;
    case D_REPT: Rept(); break;
    case D_RSRESET: rs = 0; break;
    case D_RSSET: rs = Constant(); break;
    case D_FAIL: Fail(ASM_ERR_ASSERT); break;
    case D_ASSERT:
      v = Eval();
      if (pass == 2 && !v) Fail(ASM_ERR_ASSERT);
      ToEnd();
      break;
    case D_SHIFT: Shift(); break;
    case D_FOR: For(); break;
    case D_INCBIN: Incbin(); break;
    case D_ENDM: case D_ENDR: Fail(ASM_ERR_SYNTAX); break;
    case D_PURGE:
      do {
        Space();
        ReadIdent();
        if (FindDotted()) Purge();
      } while (Comma());
      break;
    case 0xFF:
      if (!Find()) Fail(ASM_ERR_MNEMONIC);
      else if (sym_kind == SYM_MACRO) Invoke();
      else if (sym_kind == SYM_STRING) { // its text is the statement
        Expand();
        Space();
        ReadIdent();
        if (ident_len) Statement();
      }
      else Fail(ASM_ERR_MNEMONIC);
      break;
    default:
      if (d < DIRECTIVES) ToEnd(); // export, global, warn, print, println, purge
      else Fail(ASM_ERR_UNSUPPORTED);
  }
}
void Pass(unsigned char p) {
  pass = p;
  depth = 0;
  frames[0].kind = F_TEXT;
  frames[0].source = 0;
  frames[0].pos = 0;
  frames[0].end = context->length;
  frames[0].line = 1;
  chunk_n = 0;
  arg_top = if_depth = 0;
  unique = rs = 0;
  scope = 0;
  in_section = 0;
  nsects = 0;
  run_n = 0;
  str_top = literal = bs_literal = 0;
  Advance();
  while (ch && !error) Line();
  if (!error && (if_depth || depth)) Fail(ASM_ERR_SYNTAX);
  CloseSection();
}

