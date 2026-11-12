// ASM.MOD: a two-pass assembler for an RGBDS subset (notes/ASSEMBLER.md). The host
// (src/editor/build.c) runs it on the open document: the source streams in through
// ModSource (includes through ModFile into PSRAM), labels and constants go in a hashed
// table in PSRAM, and the ROM image is built in PSRAM from ASM_IMAGE_BLOCK with its logo
// and checksums fixed like rgbfix -v.
// This page reads characters: the stream and its frames, words, expressions, operands,
// directives and the line parser. asm_emit.c has the symbol table, instruction encoders
// and the image.
#include "asm_shared.h"
#include "lib/psram.h"

#define CHUNK MODULE_SOURCE_CHUNK

// --- word tables: each word is its length then its lowercase letters, a 0 length ends
// the table (Keyword only compares words of ident's length)
static const char mnemonics[] = // Instruction's order
  "\003nop\004halt\004stop\002di\002ei\004rlca\004rrca\003rla\003rra\003daa\003cpl\003scf\003ccf\004reti"
  "\002ld\003ldh\003ldi\003ldd\003add\003adc\003sub\003sbc\003and\003xor\002or\002cp\003inc\003dec\002jp\002jr\004call\003ret\003rst\004push\003pop\003rlc\003rrc\002rl\002rr\003sla\003sra\004swap\003srl\003bit\003res\003set";
static const char directives[] = // the supported ones first, in D_* order
  "\007section\002db\002dw\002ds\003def\005redef\006export\006global\007include\002if\004elif\004else\004endc"
  "\005macro\004endm\004rept\004endr\007rsreset\005rsset\004warn\005print\007println\004fail\006assert\005purge\005shift"
  "\006incbin\003for\004load\004endl\005union\005nextu\004endu\007charmap\003opt\005pushs\004pops\005pusho\004popo\005align\004equs";
static const char registers[] = "\001b\001c\001d\001e\001h\001l\001a\002bc\002de\002hl\002sp\002af\002nz\001z\002nc";
static const char brackets[] = "\002hl\003hli\003hld\002bc\002de\001c";
static const char functions[] = "\004high\003low\004bank\003def\005_narg\006strlen\006strcmp\007strfind\010strrfind";
static const char types[] = "\004rom0\004romx\004vram\004sram\005wram0\005wramx\003oam\004hram";
static const char attributes[] = "\004bank\005align";
static const char definers[] = "\003equ\002rb\002rw\002rl\004equs";
static const char strfuncs[] = "\006strcat\006strupr\006strlwr\010strslice\006strsub\006strrpl";
static const char* const tables[9] = {mnemonics, directives, registers, brackets, functions, types, attributes, definers, strfuncs};

// the index of ident in one of the tables, 0xFF if absent. Every statement looks its first
// word up here, so it's assembly on the device (the C is the PC harness's).
#ifdef HOST_TEST
unsigned char Keyword(unsigned char which) {
  const char* table = tables[which];
  unsigned char index = 0, i, length, c;
  while ((length = *table++) != 0) {
    if (length == ident_len) {
      for (i = 0; i < length; ++i) {
        c = ident[i];
        if (c >= 'A' && c <= 'Z') c |= 0x20;
        if (c != table[i]) break;
      }
      if (i == length) return index;
    }
    table += length;
    ++index;
  }
  return 0xFF;
}
#else
unsigned char Keyword(unsigned char which) __naked {
  which;
  __asm
	add	a, a
	ld	hl, _tables
	add	a, l
	ld	l, a
	adc	a, h
	sub	a, l
	ld	h, a
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	ld	a, [_ident]
	cp	a, 65
	jr	c, .first
	cp	a, 91
	jr	nc, .first
	or	a, 32
.first:
	ld	b, a
	ld	c, 0
	ld	a, [_ident_len]
	ld	d, a
.next:
	ld	a, [hl+]
	or	a, a
	jr	z, .none
	ld	e, a
	cp	a, d
	jr	nz, .skip
	ld	a, [hl]
	cp	a, b
	jr	nz, .skip
	push	bc
	push	de
	push	hl
	ld	bc, _ident
.char:
	ld	a, [bc]
	cp	a, 65
	jr	c, .lower
	cp	a, 91
	jr	nc, .lower
	or	a, 32
.lower:
	cp	a, [hl]
	jr	nz, .differ
	inc	bc
	inc	hl
	dec	e
	jr	nz, .char
	pop	hl
	pop	de
	pop	bc
	ld	a, c
	ret
.differ:
	pop	hl
	pop	de
	pop	bc
.skip:
	ld	a, e
	add	a, l
	ld	l, a
	adc	a, h
	sub	a, l
	ld	h, a
	inc	c
	jr	.next
.none:
	ld	a, 255
	ret
  __endasm;
}
#endif
static unsigned char IsDigit(unsigned char c) { return c >= '0' && c <= '9'; }
unsigned char IsStart(unsigned char c) {
  return ((c | 0x20) >= 'a' && (c | 0x20) <= 'z') || c == '_' || c == '.';
}
unsigned char IsIdentChar(unsigned char c) { return IsStart(c) || IsDigit(c); }

// --- the stream: characters come from a stack of frames. The document (source 0) and
// included files (sources 1.., copied to PSRAM) are text; macro and repeat bodies are
// ranges of a text source that expand \1-\9 and \@; argument frames replay text from
// args. A frame ends at its end position: a repeat rewinds, anything else pops.
AsmContext* context;
Frame frames[FRAMES];
unsigned char depth; // frames[depth] is being read
static char buf[CHUNK]; // the document's current chunk
static unsigned int chunk_pos;
unsigned char chunk_n;
char args[256];
unsigned char arg_top;
static char idtext[8];
unsigned int unique; // the last \@
unsigned int inc_len[ASM_INCLUDES];
unsigned char includes;
char path[48];
static unsigned int* lf_line; // the line count of the frame a line feed in ch came from
unsigned char ch;
unsigned char error, pass;

// a byte of a source
static unsigned char Raw(unsigned char source, unsigned int p) {
  if (source == 0) {
    if (p < chunk_pos || p >= chunk_pos + chunk_n) {
      chunk_pos = p;
      chunk_n = ModSource(p, buf);
      if (!chunk_n) return 0;
    }
    return buf[p - chunk_pos];
  }
  if (source == SRC_ARGS) return args[p];
  if (source == SRC_ID) return idtext[p];
  if (source == SRC_FMT) return fmt_text[p];
  Window(ASM_INCLUDE_BLOCK + ((unsigned int)(source - 1) << 7) + (p >> 9));
  return WINDOW[p & 511];
}
Frame* TextFrame(void) { // the innermost frame that is real text
  Frame* f = &frames[depth];
  while (f->kind == F_ARG) --f;
  return f;
}
Frame* Push(unsigned char kind, unsigned char source, unsigned int pos, unsigned int end) {
  Frame* f;
  if (depth == FRAMES - 1) { Fail(ASM_ERR_NESTING); return &frames[depth]; }
  run_n = 0;
  f = &frames[++depth];
  f->kind = kind;
  f->source = source;
  f->pos = f->start = pos;
  f->end = end;
  f->count = 0;
  f->line = 1;
  f->line_pos = pos;
  f->id = 0;
  f->nargs = 0;
  return f;
}
// \1-\9: the enclosing macro's argument as a frame (empty if it has none)
static void PushArg(unsigned char n) {
  Frame* m = &frames[depth];
  unsigned char at, i;
  while (m > frames && m->kind != F_MACRO) --m;
  if (m->kind != F_MACRO || n >= m->nargs) { Push(F_ARG, SRC_ARGS, 0, 0); return; }
  for (at = m->args, i = 0; i < n; ++i) while (args[at++]);
  for (i = at; args[i]; ++i);
  Push(F_ARG, SRC_ARGS, at, i);
}
static void PushId(void) { // \@: _ and the innermost macro or repeat's number
  Frame* m = &frames[depth];
  unsigned int id;
  unsigned char i = 7;
  while (m > frames && m->kind != F_MACRO && m->kind != F_REPT) --m;
  id = m->id;
  idtext[i] = 0;
  do { idtext[--i] = '0' + Apply('%', id, 10); id = Apply('/', id, 10); } while (id); // no SDCC helpers
  idtext[--i] = '_';
  Push(F_ARG, SRC_ID, i, 7);
}
unsigned char run_n;
static const unsigned char* run_p;
static unsigned int* run_pos; // the frame's pos
static unsigned int* run_line; // and its line count
static unsigned char run_expand; // a macro or repeat body: a backslash goes the slow way
// the next character into ch. Most come from the current run: on the device that's the
// assembly below, and everything else (line feeds, run ends, backslashes) is AdvanceSlow.
#ifdef HOST_TEST
#define AdvanceSlow Advance
#else
void AdvanceSlow(void);
void Advance(void) __naked {
  __asm
	ld	a, [_error]
	or	a, a
	jr	nz, .slow
	ld	a, [_ch]
	cp	a, 10
	jr	nz, .run
	ld	hl, _lf_line
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	inc	[hl]
	jr	nz, .left
	inc	hl
	inc	[hl]
.left:
	xor	a, a
	ld	[_ch], a
.run:
	ld	a, [_run_n]
	or	a, a
	jr	z, .slow
	ld	hl, _run_p
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	ld	a, [hl]
	cp	a, 123
	jr	z, .slow
	ld	a, [_run_expand]
	or	a, a
	jr	z, .take
	ld	a, [hl]
	cp	a, 92
	jr	z, .slow
.take:
	ld	a, [hl+]
	ld	[_ch], a
	ld	a, l
	ld	[_run_p], a
	ld	a, h
	ld	[_run_p + 1], a
	ld	hl, _run_n
	dec	[hl]
	ld	hl, _run_pos
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	inc	[hl]
	jr	nz, .counted
	inc	hl
	inc	[hl]
.counted:
	ld	a, [_ch]
	cp	a, 10
	ret	nz
	ld	hl, _run_line
	ld	a, [hl+]
	ld	[_lf_line], a
	ld	a, [hl]
	ld	[_lf_line + 1], a
	ret
.slow:
	jp	_AdvanceSlow
  __endasm;
}
#endif
unsigned char literal, bs_literal;
void AdvanceSlow(void) {
  Frame* f;
  unsigned char c, n;
  unsigned int p, left;
  if (error) { ch = 0; return; }
  if (ch == 10) ++*lf_line; // counted as it's left, so an error at a line's end stays on it
  ch = 0; // so Interpolate's own reads don't count it again
  if (run_n && !(run_expand && *run_p == '\\') && *run_p != '{') {
    --run_n;
    ++*run_pos;
    ch = *run_p++;
    if (ch == 10) lf_line = run_line;
    return;
  }
  while (1) {
    f = &frames[depth];
    if (f->pos >= f->end) {
      run_n = 0;
      if (f->kind == F_REPT) {
        if (f->for_unit) StepVar(f->for_unit, f->for_step); // after every pass, as RGBDS leaves it
        if (--f->count) { f->pos = f->start; f->line = f->first_line; f->id = ++unique; continue; }
      }
      if (!depth) { ch = 0; return; }
      if (f->kind == F_MACRO) arg_top = f->args;
      --depth;
      continue;
    }
    p = f->pos;
    left = f->end - p;
    if (f->source <= SRC_HEAP) { // text: set up the run that follows this byte
      c = Raw(f->source, p);
      run_p = f->source ? WINDOW + (p & 511) : (const unsigned char*)buf + (p - chunk_pos);
      n = f->source ? 512 - (p & 511) > 255 ? 255 : 512 - (p & 511) : chunk_pos + chunk_n - p;
      if (n > left) n = (unsigned char)left;
      run_n = n ? n - 1 : 0; // after this one (none if the document's text ran out)
      ++run_p;
      run_pos = &f->pos;
      run_line = &f->line;
      run_expand = f->kind == F_MACRO || f->kind == F_REPT;
      ++f->pos;
    }
    else c = Raw(f->source, f->pos++);
    if (c == '\\' && (f->kind == F_MACRO || f->kind == F_REPT)) {
      run_n = 0;
      if (bs_literal) bs_literal = 0; // the second of \\: kept for the string that reads it
      else {
        n = Raw(f->source, f->pos);
        if (n == '@') { ++f->pos; PushId(); continue; }
        if (n >= '1' && n <= '9') { ++f->pos; PushArg(n - '1'); continue; }
        if (n == '\\') bs_literal = 1;
      }
    }
    if (c == '{' && !literal) { run_n = 0; Interpolate(); continue; }
    if (c == 10) lf_line = &f->line;
    ch = c;
    return;
  }
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
void ToEnd(void) { ++literal; while (ch && ch != 10) Advance(); --literal; } // the comment or the rest of a line

// --- words
char ident[NAME_MAX + 1], name[NAME_MAX + 1]; // the word read; a name kept while its value is read
unsigned char ident_len;

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
static unsigned int Digits(unsigned char base) {
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
// decimal, or a fixed-point literal like 1.25 as 8.8 (RGBDS: 16.16; the values compare alike)
static unsigned int Number(void) {
  unsigned int v = Digits(10), f, scale = 1;
  if (ch != '.') return v;
  Advance();
  if (!IsDigit(ch)) { Fail(ASM_ERR_SYNTAX); return 0; }
  for (f = 0; IsDigit(ch) && scale < 1000; Advance()) { f = Scale(f, 10) + ch - '0'; scale = Scale(scale, 10); }
  while (IsDigit(ch)) Advance();
  return (v << 8) | Apply('/', (f << 8) + (scale >> 1), scale);
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
static unsigned int Lookup(void) { // ident's value, 0 and undefined when it has none yet
  if (FindDotted()) return sym_value;
  sym_kind = 0xFF;
  if (pass == 2) Fail(ASM_ERR_SYMBOL);
  undefined = 1;
  return 0;
}
static unsigned int Primary(void);
// a string symbol's text replaces the name just read: the character after the name (in ch)
// goes back to be read again after the text
void Expand(void) {
  unsigned int start = sym_value;
  if (ch) --frames[depth].pos;
  ch = 0;
  Push(F_TEXT, SRC_HEAP, start, start + sym_extra);
  Advance();
}
static unsigned int Symbol(void) { // ident is a name, a function or the register c
  unsigned int v;
  unsigned char k = Keyword(T_FUNCTIONS);
  if (k >= 5 && k != 0xFF) return StrNumber(k); // STRLEN, STRCMP, STRFIND, STRRFIND
  if (k == 4) { // _NARG: the enclosing macro's argument count
    Frame* m = &frames[depth];
    while (m > frames && m->kind != F_MACRO) --m;
    return m->kind == F_MACRO ? m->nargs : 0;
  }
  if (k != 0xFF) {
    Space();
    if (ch == '(') {
      Advance();
      Space();
      if (k >= 2) { // bank(label or @), def(name)
        if (k == 2 && ch == '@') { Advance(); v = sec_bank; }
        else {
          ReadIdent();
          if (!ident_len) Fail(ASM_ERR_SYNTAX);
          if (k == 3) v = FindDotted() && (pass == 1 || sym_seen); // defined above, in this pass
          else { Lookup(); v = sym_bank; }
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
  v = Lookup();
  if (sym_kind != SYM_STRING) return v;
  Expand(); // its text takes the name's place
  return Primary();
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
  if (c == '$') { Advance(); return Digits(16); }
  if (c == '%') { Advance(); return Digits(2); }
  if (c == '&') { Advance(); return Digits(8); }
  if (IsDigit(c)) return Number();
  if (c == '\'') {
    Advance();
    v = Char();
    if (ch != '\'') Fail(ASM_ERR_STRING);
    else Advance();
    return v;
  }
  if (c == '@') { Advance(); return pc; }
  if (IsStart(c)) { ReadIdent(); return Symbol(); }
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

// --- skipping: lines of a false IF branch or of a macro or repeat body being recorded.
// Starts on the line feed before them; stops after the directive word that ends them,
// with scan_begin = the position of that line's start. Nested IF/ENDC and REPT/ENDR pairs
// are passed over, so are """ block strings.
unsigned int scan_begin;
static unsigned char ScanLines(unsigned char mode) {
  unsigned char nest = 0, block = 0, quotes, d;
  Frame* f;
  while (1) {
    ToEnd();
    if (!ch) { Fail(ASM_ERR_SYNTAX); return 0xFF; }
    Advance();
    f = TextFrame();
    scan_begin = f->pos - 1;
    if (!block) {
      Space();
      if (IsStart(ch)) {
        ident_len = 0; // like ReadIdent, but long words are just cut
        while (IsIdentChar(ch)) {
          if (ident_len < NAME_MAX) ident[ident_len++] = ch;
          Advance();
        }
        ident[ident_len] = 0;
        d = Keyword(T_DIRECTIVES);
        if (mode == SKIP_IF) {
          if (d == D_IF) ++nest;
          else if (d == D_ENDC && nest) --nest;
          else if (d == D_ENDC || (!nest && (d == D_ELIF || d == D_ELSE))) return d;
        }
        else if (mode == SKIP_REPT) {
          if (d == D_REPT || d == D_FOR) ++nest;
          else if (d == D_ENDR && nest) --nest;
          else if (d == D_ENDR) return d;
        }
        else if (d == D_ENDM) return d;
      }
    }
    for (quotes = 0; ch && ch != 10; Advance()) { // """ toggles a block string
      if (ch == '"') { if (++quotes == 3) { block ^= 1; quotes = 0; } }
      else quotes = 0;
    }
  }
}

// [label[:[:]]] [statement] [; comment]: a global label needs its colon, a local one doesn't
void Line(void) {
  Frame* f = TextFrame();
  undefined = 0;
  f->line_pos = f->pos - 1;
  Space();
  if (IsStart(ch)) {
    ReadIdent();
    if (ch == ':') {
      Advance();
      if (ch == ':') Advance();
      Label();
    }
    else if (ident[0] == '.') Label();
    else goto statement;
    Space();
    if (!AtEnd()) {
      ReadIdent();
      if (!ident_len) { Fail(ASM_ERR_SYNTAX); return; }
    statement:
      Statement();
    }
  }
  Space();
  if (ch == ';') ToEnd();
  if (ch == 10) Advance();
  else if (ch) Fail(ASM_ERR_SYNTAX);
}


unsigned char Scan(unsigned char mode) { // skipped lines aren't interpolated
  unsigned char d;
  ++literal;
  d = ScanLines(mode);
  --literal;
  return d;
}

// --- operands
unsigned char okind[2], oreg[2], nops;
unsigned int oval[2];


// rgbasm's version symbols: this assembles what RGBDS 1.0 does, where it does
static void Builtin(const char* word, unsigned int value) {
  for (ident_len = 0; (ident[ident_len] = word[ident_len]) != 0; ++ident_len);
  Add(SYM_EQU | SYM_SEEN, value, 0); // defined before both passes
}

unsigned char ModuleMain(AsmContext* c) {
  unsigned int blocks, i;
  Frame* f;
  context = c;
  c->symbols = 0;
  next_unit = 1; // unit 0 means "none"
  for (i = 0; i < 256; ++i) heads[i] = 0;
  heap_top = 0;
  Builtin("__RGBDS_MAJOR__", 1);
  Builtin("__RGBDS_MINOR__", 0);
  Builtin("__RGBDS_PATCH__", 1);
  Pass(1);
  if (!error && !rom_used) Fail(ASM_ERR_EMPTY);
  if (!error && (i = Link()) != 0xFF) { // reported at the section that doesn't fit
    error = sects[i].flags & SECT_ADDRESS ? ASM_ERR_OVERLAP : ASM_ERR_FULL;
    c->file = sects[i].file;
    c->line = sects[i].line;
    c->pos = sects[i].pos;
    return error;
  }
  if (!error) {
    Relocate();
    for (blocks = 64; blocks < (unsigned int)(max_bank + 1) << 5; blocks <<= 1);
    c->blocks = blocks;
    Fill();
    Pass(2);
  }
  if (!error) Header();
  // an error in a macro body is reported at its invocation (whose line feed was already
  // counted); one in a repeat at the body line
  // (expansions of string symbols and {} report the line they're on)
  for (f = &frames[depth], i = 0; f > frames && (f->kind == F_MACRO || f->kind == F_ARG || f->source >= SRC_HEAP); --f)
    if (f->kind == F_MACRO) i = 1;
  c->file = f->source;
  c->line = f->line - i;
  c->pos = f->source ? frames[0].line_pos : f->line_pos;
  return error;
}
