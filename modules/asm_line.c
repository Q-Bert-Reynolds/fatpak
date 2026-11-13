// ASM.MOD, third page: lines, directives, conditionals, repeats, macros, includes and
// sections (see asm_shared.h). asm.c reads characters and expressions for it.
#include "asm_shared.h"


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
      MapEmit(StrExpr());
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
static void Ds(void) { // ds count[, fill], ds align[a[, offset]][, fill]
  unsigned int n, ofs = 0;
  unsigned char fill = 0, a = 0xFF;
  Space();
  if (IsStart(ch)) {
    ReadIdent();
    if (Keyword(T_ATTRIBUTES) == 1) { // align
      Expect('[');
      a = (unsigned char)Constant();
      Space();
      if (ch == ',') { Advance(); ofs = Constant(); }
      Expect(']');
      if (a > 13) { Fail(ASM_ERR_UNSUPPORTED); return; }
    }
    else pending = 1;
  }
  n = a == 0xFF ? Constant() : AlignPad(a, ofs);
  Space();
  if (ch == ',') {
    Advance();
    fill = (unsigned char)Eval();
    if (!sec_rom) { Fail(ASM_ERR_SECTION); return; }
  }
  Reserve(n, fill);
  if (a != 0xFF && !error) AlignTo(a, ofs);
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
  unsigned int start_line;
  Pos start;
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
  Pos start;
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
  if (f->source != SRC_TEXT) { Fail(ASM_ERR_UNSUPPORTED); return; } // inside a {} expansion
  sym_extra = (unsigned int)(scan_begin - start);
  LoadName();
  if (Find()) { if (pass == 2) Mark(); else Fail(ASM_ERR_DUPLICATE); }
  else Add(pass == 2 ? SYM_MACRO | SYM_SEEN : SYM_MACRO, (unsigned int)start, (unsigned char)(start >> 16)); // pass 2: after a PURGE
}
// ident is a macro: its arguments (top-level commas separate them) go to args[], its body
// becomes a frame. The line feed stays for Line.
static void Invoke(void) {
  unsigned char first = arg_top, n = 0, nest = 0, quoted = 0;
  Pos start = sym_value | (Pos)sym_bank << 16, end = start + sym_extra;
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
  f = Push(F_MACRO, SRC_TEXT, start, end);
  f->args = first;
  f->nargs = n;
  f->id = ++unique;
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
    case D_PUSHS: PushS(); break;
    case D_POPS: PopS(); break;
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
    case D_CHARMAP: case D_CHARMAP + 1: case D_CHARMAP + 2: case D_CHARMAP + 3: case D_POPC: Charmap(d - D_CHARMAP); break;
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
  frames[0].source = SRC_TEXT;
  frames[0].file = 0;
  frames[0].pos = 0;
  frames[0].end = context->length;
  frames[0].line = 1;
  chunk_n = 0;
  arg_top = if_depth = 0;
  unique = rs = 0;
  scope = 0;
  in_section = sect_depth = 0;
  run_n = 0;
  str_top = literal = bs_literal = 0;
  CharmapReset();
  Advance();
  while (ch && !error) Line();
  if (!error && (if_depth || depth)) Fail(ASM_ERR_SYNTAX);
  CloseSection();
}
// where the error is: its file's symbol and name, line and the document position
void Report(unsigned int file, unsigned int line, Pos at) {
  AsmContext* c = context;
  unsigned char *e, n, i, from = 0;
  c->file = file;
  c->line = line;
  c->pos = (unsigned int)at;
  if (!file) return;
  e = Entry(file);
  n = e[10];
  for (i = 0; i < n; ++i) if (e[11 + i] == '/') from = i + 1;
  for (i = 0; from < n && i < sizeof(c->name) - 1; ++i) c->name[i] = e[11 + from++];
  c->name[i] = 0;
}
