// ASM.MOD: a two-pass assembler for an RGBDS subset (notes/ASSEMBLER.md). The host
// (src/editor/build.c) runs it on the open document: the source streams in through
// ModSource (files through ModLoad into PSRAM), labels and constants go in a hashed
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
  "\006incbin\003for\007charmap\012newcharmap\012setcharmap\005pushc\004popc\005pushs\004pops\002dl"
  "\004load\004endl\005union\005nextu\004endu\003opt\005pusho\004popo\005align\004equs";
static const char registers[] = "\001b\001c\001d\001e\001h\001l\001a\002bc\002de\002hl\002sp\002af\002nz\001z\002nc";
static const char brackets[] = "\002hl\003hli\003hld\002bc\002de\001c";
static const char functions[] = "\004high\003low\004bank\003def\005_narg\006strlen\006strcmp\007strfind\010strrfind";
static const char types[] = "\004rom0\004romx\004vram\004sram\005wram0\005wramx\003oam\004hram";
static const char attributes[] = "\004bank\005align\010fragment";
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
char path[128];
static unsigned int* lf_line; // the line count of the frame a line feed in ch came from
unsigned char ch;
unsigned char error, pass;

// a byte of a source
static unsigned char Raw(unsigned char source, Pos at) {
  unsigned int p = (unsigned int)at;
  if (source == SRC_TEXT) {
    if (at >> 16) {
      Window(BLOCK(at));
      return WINDOW[p & 511];
    }
    if (p < chunk_pos || p >= chunk_pos + chunk_n) {
      chunk_pos = p;
      chunk_n = ModSource(p, buf);
      if (!chunk_n) return 0;
    }
    return buf[p - chunk_pos];
  }
  if (source == SRC_ARGS) return args[(unsigned char)p];
  if (source == SRC_ID) return idtext[(unsigned char)p];
  return fmt_text[(unsigned char)p];
}
Frame* TextFrame(void) { // the innermost frame that is real text
  Frame* f = &frames[depth];
  while (f->kind == F_ARG) --f;
  return f;
}
Frame* Push(unsigned char kind, unsigned char source, Pos pos, Pos end) {
  Frame* f;
  if (depth == FRAMES - 1) { Fail(ASM_ERR_NESTING); return &frames[depth]; }
  run_n = 0;
  f = &frames[++depth];
  f->file = f[-1].file;
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
  do { id = (unsigned int)Div(id, 10); idtext[--i] = '0' + (unsigned char)div_rem; } while (id); // no SDCC helpers
  idtext[--i] = '_';
  Push(F_ARG, SRC_ID, i, 7);
}
unsigned char run_n;
static const unsigned char* run_p;
static Pos* run_pos; // the frame's pos
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
  unsigned char c, n, prev;
  unsigned int o;
  Pos p;
  if (error) { ch = 0; return; }
  if (ch == 10) ++*lf_line; // counted as it's left, so an error at a line's end stays on it
  prev = ch; // \{ is a brace, not interpolation
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
      if (f->kind == F_TEXT && f->file && f->file != FILE_EXPANSION) { // a file's end ends its last line
        lf_line = &f->line; // (counted in the finished frame, not the one that included it)
        ch = 10;
        return;
      }
      continue;
    }
    p = f->pos;
    if (f->source == SRC_TEXT) { // text: set up the run that follows this byte
      c = Raw(SRC_TEXT, p);
      o = (unsigned int)p;
      if (p >> 16) { run_p = WINDOW + (o & 511); o = 512 - (o & 511); n = o > 255 ? 255 : (unsigned char)o; }
      else { run_p = (const unsigned char*)buf + (o - chunk_pos); n = chunk_pos + chunk_n - o; }
      if (f->end - p < n) n = (unsigned char)(f->end - p);
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
    if (c == '{' && !literal && prev != '\\') { run_n = 0; Interpolate(); continue; }
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

static Val Binary(unsigned char min);

// a number being read: num = num * base + d (base 2, 8, 10 or 16), assembly on the device
// like Keyword; and the 32-bit value Lookup returns
Num num;
#ifdef HOST_TEST
void Digit(unsigned char base, unsigned char d) { num.u = num.u * base + d; }
#else
void Digit(unsigned char base, unsigned char d) __naked {
  base; d;
  __asm
	ld	b, a
	ld	c, e
	cp	a, 10
	jr	nz, .power
	call	.double
	ld	hl, _num
	ld	a, [hl+]
	ld	e, a
	ld	a, [hl+]
	ld	d, a
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	push	hl
	push	de
	call	.double
	call	.double
	pop	de
	pop	hl
	ld	a, [_num]
	add	a, e
	ld	[_num], a
	ld	a, [_num+1]
	adc	a, d
	ld	[_num+1], a
	ld	a, [_num+2]
	adc	a, l
	ld	[_num+2], a
	ld	a, [_num+3]
	adc	a, h
	ld	[_num+3], a
	jr	.add
.power:
	srl	b
	jr	z, .add
	call	.double
	jr	.power
.add:
	ld	hl, _num
	ld	a, [hl]
	add	a, c
	ld	[hl+], a
	ret	nc
	inc	[hl]
	ret	nz
	inc	hl
	inc	[hl]
	ret	nz
	inc	hl
	inc	[hl]
	ret
.double:
	ld	hl, _num
	sla	[hl]
	inc	hl
	rl	[hl]
	inc	hl
	rl	[hl]
	inc	hl
	rl	[hl]
	ret
  __endasm;
}
#endif
static UVal Digits(unsigned char base) {
  unsigned char d, any = 0;
  num.u = 0;
  while (1) {
    d = ch;
    if (d == '_') { Advance(); continue; }
    if (IsDigit(d)) d -= '0';
    else if ((d | 0x20) >= 'a' && (d | 0x20) <= 'f') d = (d | 0x20) - 'a' + 10;
    else break;
    if (d >= base) break;
    Digit(base, d);
    any = 1;
    Advance();
  }
  if (!any) Fail(ASM_ERR_SYNTAX);
  return num.u;
}
// decimal, or a fixed-point literal like 1.25 as 16.16, the fraction rounded (to 7 digits)
static UVal Number(void) {
  UVal v = Digits(10), f;
  unsigned char n;
  if (ch != '.') return v;
  Advance();
  if (!IsDigit(ch)) { Fail(ASM_ERR_SYNTAX); return 0; }
  for (num.u = 0, n = 0; IsDigit(ch); Advance()) if (n < 7) { Digit(10, ch - '0'); ++n; }
  f = num.u;
  for (num.u = 1; n; --n) Digit(10, 0); // 10^n
  for (n = 0; n < 2; ++n) { // f / 10^n, 8 bits at a time (Apply and Div: assembly)
    v = Apply('|', Apply('s', v, 8), Div(Apply('s', f, 8), num.u));
    f = div_rem;
  }
  return Apply('+', v, Apply('g', Apply('s', f, 1), num.u));
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
  if (c == '\\' || c == '"' || c == '\'' || c == '{' || c == '}') return c;
  Fail(ASM_ERR_STRING);
  return 0;
}
static Val Lookup(void) { // ident's value, 0 and undefined when it has none yet
  if (FindDotted()) {
    num.w[0] = sym_value;
    num.w[1] = sym_kind == SYM_EQU || sym_kind == SYM_VAR ? sym_extra : 0;
    return num.v;
  }
  sym_kind = 0xFF;
  if (pass == 2) Fail(ASM_ERR_SYMBOL);
  undefined = 1;
  return 0;
}
static Val Primary(void);
// a string symbol's text replaces the name just read: the character after the name (in ch)
// goes back to be read again after the text
void Expand(void) {
  Pos start = ADDRESS(ASM_HEAP_BLOCK) + sym_value;
  if (ch) --frames[depth].pos;
  ch = 0;
  Push(F_TEXT, SRC_TEXT, start, start + sym_extra)->file = FILE_EXPANSION;
  Advance();
}
static Val Symbol(void) { // ident is a name, a function or the register c
  Val v;
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
        if (!k) v >>= 8;
        v &= 0xFF;
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
static Val Primary(void) {
  Val v;
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
  if (c == '-') { Advance(); return 0 - (UVal)Primary(); }
  if (c == '+') { Advance(); return Primary(); }
  if (c == '~') { Advance(); return ~Primary(); }
  if (c == '!') { Advance(); return !Primary(); }
  if (c == '$') { Advance(); return Digits(16); }
  if (c == '%') { Advance(); return Digits(2); }
  if (c == '&') { Advance(); return Digits(8); }
  if (IsDigit(c)) return Number();
  if (c == '\'') { Advance(); return CharLiteral(); } // through the charmap
  if (c == '@') { Advance(); return pc; }
  if (IsStart(c)) { ReadIdent(); return Symbol(); }
  Fail(ASM_ERR_SYNTAX);
  return 0;
}
// the binary operator at ch into op (0 if none): || && == != < > <= >= + - & | ^ << >> * / %,
// the two-character ones as a letter; op_level is its precedence (the number before it)
static const char op_starts[] = "|&=!<>+-*/%^";
static const char op_pairs[] = "||L&&A==E!=N<<s>>r<=l>=g";
static const char op_levels[] = "\1L\2A\3ENlg<>\4+-\5&|^\6sr\7*/%";
static void ReadOp(void) {
  unsigned char c, i;
  Space();
  c = ch;
  op = 0;
  if (c < '!' || c == ',' || c == ')' || c == ']') return; // most expressions end here
  for (i = 0; op_starts[i] != c; ++i) if (!op_starts[i]) return;
  Advance();
  for (i = 0; op_pairs[i]; i += 3)
    if (op_pairs[i] == c && op_pairs[i + 1] == ch) { Advance(); c = op_pairs[i + 2]; break; }
  if (c == '=' || c == '!') { Fail(ASM_ERR_SYNTAX); return; }
  op = c;
  for (i = 0; op_levels[i] != c; ++i) if (op_levels[i] < 8) op_level = op_levels[i];
}
static Val Binary(unsigned char min) {
  Val left = Primary(), right;
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
Val Eval(void) {
  op = 0;
  return Binary(1);
}
Val Constant(void) { // an expression that must be known in pass 1: sizes, addresses
  Val v = Eval();
  if (undefined) Fail(ASM_ERR_FORWARD);
  return v;
}

// --- skipping: lines of a false IF branch or of a macro or repeat body being recorded.
// Starts on the line feed before them; stops after the directive word that ends them,
// with scan_begin = the position of that line's start. Nested IF/ENDC and REPT/ENDR pairs
// are passed over, so are """ block strings.
Pos scan_begin;
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
unsigned char line_tick; // Progress every 64 lines (the host draws every 5 s)
void Line(void) {
  Frame* f;
  if (!(++line_tick & 63)) Progress();
  f = TextFrame();
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


unsigned char Main(void); // asm_main.c
unsigned char ModuleMain(AsmContext* c) {
  context = c;
  return Main();
}
