// ASM.MOD, second page: arithmetic, the symbol table, instruction encoders and the ROM
// image (asm.c parses; see asm_shared.h). Values are 32 bits; * / % are loops here
// because modules can't import SDCC's helpers.
#include "asm_shared.h"
#include "lib/psram.h"

// --- arithmetic without helpers: values are 32 bits. On the device it's assembly (SDCC's
// long code is several times the size); the C is the PC harness's, checked against RGBDS.
// Apply follows RGBDS: / rounds toward minus infinity and % takes the divisor's sign; a
// negative shift goes the other way, and 32 or more leaves 0 (or -1).
UVal div_rem; // Div's remainder
#ifdef HOST_TEST
static UVal Mul(UVal a, UVal b) {
  UVal r = 0;
  while (b) {
    if (b & 1) r += a;
    a <<= 1;
    b >>= 1;
  }
  return r;
}
UVal Div(UVal a, UVal b) {
  UVal q = 0, r = 0, top;
  unsigned char i;
  for (i = 0; i < 32; ++i) {
    top = r >> 31; // r overflows past 32 bits only when b > 2^31: then it fits
    r = (r << 1) | (a >> 31);
    a <<= 1;
    q <<= 1;
    if (top || r >= b) { r -= b; q |= 1; }
  }
  div_rem = r;
  return q;
}
Val Apply(unsigned char o, Val a, Val b) {
  UVal q, ub;
  unsigned char differ;
  switch (o) {
    case '+': return (UVal)a + b;
    case '-': return (UVal)a - b;
    case '*': return Mul(a, b);
    case '/': case '%':
      if (!b) { Fail(ASM_ERR_DIVIDE); return 0; }
      ub = b < 0 ? 0 - (UVal)b : b;
      q = Div(a < 0 ? 0 - (UVal)a : a, ub);
      differ = (a < 0) != (b < 0);
      if (differ && div_rem) { div_rem = ub - div_rem; ++q; }
      if (o == '/') return differ ? 0 - q : q;
      return b < 0 ? 0 - div_rem : div_rem;
    case '&': return a & b;
    case '|': return a | b;
    case '^': return a ^ b;
    case 's': case 'r':
      if (b < 0) { b = 0 - (UVal)b; o ^= 's' ^ 'r'; }
      if (o == 's') return (UVal)b < 32 ? (UVal)a << b : 0;
      return a >> ((UVal)b < 32 ? b : 31);
    case '<': return a < b;
    case '>': return a > b;
    case 'l': return a <= b;
    case 'g': return a >= b;
    case 'E': return a == b;
    case 'N': return a != b;
    case 'A': return a && b;
    default: return a || b;
  }
}

#else
static UVal t[2]; // the work registers: Apply's operands (the result in the first), Div's dividend and divisor

// o in a, a and b on the stack (popped here), the result in debc
Val Apply(unsigned char o, Val a, Val b) __naked {
  o; a; b;
  __asm
	ld	c, a
	ld	hl, sp+2
	ld	de, _t
	ld	b, 8
.in:
	ld	a, [hl+]
	ld	[de], a
	inc	de
	dec	b
	jr	nz, .in
	ld	de, _t
	ld	hl, _t+4
	ld	a, c
	cp	a, $2B
	jr	z, .add
	cp	a, $2D
	jr	z, .sub
	cp	a, $26
	jr	z, .and
	cp	a, $7C
	jr	z, .or
	cp	a, $5E
	jr	z, .xor
	cp	a, $2A
	jr	z, .mul
	cp	a, $2F
	jr	z, .div
	cp	a, $25
	jr	z, .div
	cp	a, $73
	jr	z, .shift
	cp	a, $72
	jr	z, .shift
	cp	a, $41
	jr	z, .both
	cp	a, $4C
	jr	z, .either
; comparisons, signed: which of x < y, x == y, x > y (bits 0-2) make each one true
	ld	b, 1
	cp	a, $3C
	jr	z, .compare
	ld	b, 4
	cp	a, $3E
	jr	z, .compare
	ld	b, 3
	cp	a, $6C
	jr	z, .compare
	ld	b, 6
	cp	a, $67
	jr	z, .compare
	ld	b, 2
	cp	a, $45
	jr	z, .compare
	ld	b, 5
.compare:
	push	bc
	ld	a, [_t+7]
	xor	a, $80
	ld	c, a
	ld	a, [_t+3]
	xor	a, $80
	cp	a, c
	jr	nz, .ordered
	ld	hl, _t+2
	ld	de, _t+6
	ld	b, 3
.lower:
	ld	a, [de]
	ld	c, a
	ld	a, [hl-]
	cp	a, c
	jr	nz, .ordered
	dec	de
	dec	b
	jr	nz, .lower
.ordered:
	pop	bc
	ld	a, b
	jr	z, .equal
	jr	c, .bit
	rrca
.equal:
	rrca
.bit:
	and	a, 1
.bool:
	ld	hl, _t
	ld	[hl+], a
	xor	a, a
	ld	[hl+], a
	ld	[hl+], a
	ld	[hl], a
	jr	.done
.both:
	ld	hl, _t
	call	ArithZero
	jr	z, .bool
	call	ArithZero
	jr	z, .bool
.true:
	ld	a, 1
	jr	.bool
.either:
	ld	hl, _t
	call	ArithZero
	jr	nz, .true
	call	ArithZero
	jr	nz, .true
	jr	.bool
.add:
	call	ArithAdd
	jr	.done
.sub:
	call	ArithSub
	jr	.done
.and:
	ld	b, 4
.andl:
	ld	a, [de]
	and	a, [hl]
	ld	[de], a
	inc	de
	inc	hl
	dec	b
	jr	nz, .andl
	jr	.done
.or:
	ld	b, 4
.orl:
	ld	a, [de]
	or	a, [hl]
	ld	[de], a
	inc	de
	inc	hl
	dec	b
	jr	nz, .orl
	jr	.done
.xor:
	ld	b, 4
.xorl:
	ld	a, [de]
	xor	a, [hl]
	ld	[de], a
	inc	de
	inc	hl
	dec	b
	jr	nz, .xorl
	jr	.done
.done:
	ld	hl, _t
	ld	a, [hl+]
	ld	c, a
	ld	a, [hl+]
	ld	b, a
	ld	a, [hl+]
	ld	e, a
	ld	d, [hl]
	pop	hl
	add	sp, 8
	jp	hl
; x * y: y shifts out to the right, x left, adding x into div_rem for each 1
.mul:
	ld	hl, _div_rem
	xor	a, a
	ld	[hl+], a
	ld	[hl+], a
	ld	[hl+], a
	ld	[hl], a
	ld	c, 32
.mulbit:
	ld	hl, _t+7
	srl	[hl]
	dec	hl
	rr	[hl]
	dec	hl
	rr	[hl]
	dec	hl
	rr	[hl]
	jr	nc, .mulshift
	ld	de, _div_rem
	ld	hl, _t
	call	ArithAdd
.mulshift:
	ld	hl, _t+4
	call	ArithZero
	jr	z, .result
	ld	hl, _t
	call	ArithShl
	dec	c
	jr	nz, .mulbit
.result:
	ld	hl, _div_rem
	ld	de, _t
	call	ArithCopy
	jr	.done
; / and %: the magnitudes divided, then the signs: a negative quotient rounds down, and the
; remainder takes y's sign
.div:
	ld	hl, _t+4
	call	ArithZero
	jr	nz, .divide
	ld	a, 12
	call	_Fail
	xor	a, a
	jr	.bool
.divide:
	ld	a, [_t+7]
	ld	b, a
	ld	a, [_t+3]
	push	bc
	push	af
	ld	hl, _t
	rlca
	call	c, ArithNeg
	ld	a, [_t+7]
	ld	hl, _t+4
	rlca
	call	c, ArithNeg
	call	ArithDiv
	pop	af
	pop	bc
	xor	a, b
	rlca
	jr	nc, .signs
	push	bc
	ld	hl, _div_rem
	call	ArithZero
	ld	hl, _t
	jr	z, .exact
	ld	de, _div_rem
	ld	hl, _t+4
	call	ArithSub
	ld	hl, _div_rem
	call	ArithNeg
	ld	hl, _t
	call	ArithInc
	ld	hl, _t
.exact:
	call	ArithNeg
	pop	bc
.signs:
	ld	a, c
	cp	a, $25
	jr	nz, .done
	ld	hl, _div_rem
	bit	7, b
	call	nz, ArithNeg
	jr	.result
; << and >>: y's magnitude, up to 32, steps one bit at a time
.shift:
	ld	a, [_t+7]
	rlca
	jr	nc, .count
	ld	hl, _t+4
	call	ArithNeg
	ld	a, c
	xor	a, 1
	ld	c, a
.count:
	ld	hl, _t+5
	ld	a, [hl+]
	or	a, [hl]
	inc	hl
	or	a, [hl]
	ld	b, 32
	jr	nz, .steps
	ld	a, [_t+4]
	cp	a, b
	jr	nc, .steps
	ld	b, a
	or	a, a
	jr	z, .done
.steps:
	ld	a, c
	cp	a, $73
	jr	nz, .right
.left:
	ld	hl, _t
	call	ArithShl
	dec	b
	jr	nz, .left
	jr	.done
.right:
	ld	hl, _t+3
	sra	[hl]
	dec	hl
	rr	[hl]
	dec	hl
	rr	[hl]
	dec	hl
	rr	[hl]
	dec	b
	jr	nz, .right
	jr	.done

; the 4 bytes at de += (-=) those at hl; both move past them
ArithAdd:
	ld	b, 4
	and	a, a
.add:
	ld	a, [de]
	adc	a, [hl]
	ld	[de], a
	inc	de
	inc	hl
	dec	b
	jr	nz, .add
	ret
ArithSub:
	ld	b, 4
	and	a, a
.sub:
	ld	a, [de]
	sbc	a, [hl]
	ld	[de], a
	inc	de
	inc	hl
	dec	b
	jr	nz, .sub
	ret
; the 4 bytes at hl to de
ArithCopy:
	ld	b, 4
.copy:
	ld	a, [hl+]
	ld	[de], a
	inc	de
	dec	b
	jr	nz, .copy
	ret
; z (and a = 0) if the 4 bytes at hl are; hl moves past them
ArithZero:
	ld	a, [hl+]
	or	a, [hl]
	inc	hl
	or	a, [hl]
	inc	hl
	or	a, [hl]
	inc	hl
	ret
; the 4 bytes at hl: negated, plus 1, shifted left (the bit out in carry)
ArithNeg:
	ld	b, 4
	and	a, a
.neg:
	ld	a, 0
	sbc	a, [hl]
	ld	[hl+], a
	dec	b
	jr	nz, .neg
	ret
ArithInc:
	inc	[hl]
	ret	nz
	inc	hl
	inc	[hl]
	ret	nz
	inc	hl
	inc	[hl]
	ret	nz
	inc	hl
	inc	[hl]
	ret
ArithShl:
	and	a, a
ArithRl:
	rl	[hl]
	inc	hl
	rl	[hl]
	inc	hl
	rl	[hl]
	inc	hl
	rl	[hl]
	ret
; t[0] / t[1], unsigned: the quotient in t[0], the remainder in div_rem. The dividend's zero
; top bytes shift out at once; then a bit at a time, comparing before subtracting
ArithDiv:
	ld	hl, _div_rem
	xor	a, a
	ld	[hl+], a
	ld	[hl+], a
	ld	[hl+], a
	ld	[hl], a
	ld	c, 32
.skip:
	ld	a, [_t+3]
	or	a, a
	jr	nz, .bit
	ld	a, [_t+2]
	ld	[_t+3], a
	ld	a, [_t+1]
	ld	[_t+2], a
	ld	a, [_t]
	ld	[_t+1], a
	xor	a, a
	ld	[_t], a
	ld	a, c
	sub	a, 8
	ld	c, a
	jr	nz, .skip
	ret
.bit:
	ld	hl, _t
	call	ArithShl
	ld	hl, _div_rem
	call	ArithRl
	jr	c, .fits
	ld	hl, _div_rem+3
	ld	de, _t+7
	ld	b, 4
.compare:
	ld	a, [de]
	cp	a, [hl]
	jr	nz, .decided
	dec	hl
	dec	de
	dec	b
	jr	nz, .compare
	jr	.fits
.decided:
	jr	nc, .next
.fits:
	ld	de, _div_rem
	ld	hl, _t+4
	call	ArithSub
	ld	hl, _t
	set	0, [hl]
.next:
	dec	c
	jr	nz, .bit
	ret
  __endasm;
}

// a in debc, b on the stack (popped here); the quotient in debc
UVal Div(UVal a, UVal b) __naked {
  a; b;
  __asm
	ld	hl, _t
	ld	a, c
	ld	[hl+], a
	ld	a, b
	ld	[hl+], a
	ld	a, e
	ld	[hl+], a
	ld	[hl], d
	ld	hl, sp+2
	ld	de, _t+4
	call	ArithCopy
	call	ArithDiv
	ld	hl, _t
	ld	a, [hl+]
	ld	c, a
	ld	a, [hl+]
	ld	b, a
	ld	a, [hl+]
	ld	e, a
	ld	d, [hl]
	pop	hl
	add	sp, 4
	jp	hl
  __endasm;
}
#endif


// --- symbols: 8-byte units in PSRAM from ASM_SYMBOL_BLOCK, 256 hash chains whose heads
// fill the first block (units 0-63).
// unit: next (2), scope (2, the unit of the enclosing global label, 0 for globals), value (2),
// kind (1), bank (1), extra (2), length (1), name. An entry never crosses a block.
#define SYM_HEADER 11
unsigned int next_unit, scope, found;
unsigned int sym_value, sym_extra;
unsigned char sym_kind, sym_bank, sym_seen;

unsigned char* Entry(unsigned int unit) {
  Window(ASM_SYMBOL_BLOCK + (unit >> 6));
  return WINDOW + ((unit & 63) << 3);
}
static unsigned int* SymHead(unsigned char h) {
  Window(ASM_SYMBOL_BLOCK);
  return (unsigned int*)WINDOW + h;
}
static unsigned int Scope(void) { return ident[0] == '.' ? scope : 0; }
static unsigned char Hash(void) {
  unsigned int want = Scope();
  unsigned char h = (unsigned char)want ^ (unsigned char)(want >> 8), i;
  for (i = 0; i < ident_len; ++i) h = (h << 5) - h + ident[i];
  return h;
}
// ident's entry: found, sym_value, sym_kind and sym_bank; 0 if it isn't defined
unsigned char Find(void) {
  unsigned int unit = *SymHead(Hash()), want = Scope();
  unsigned char* e;
  unsigned char i;
  while (unit) {
    e = Entry(unit);
    if (e[10] == ident_len && (e[2] | (e[3] << 8)) == want) {
      for (i = 0; i < ident_len && e[SYM_HEADER + i] == ident[i]; ++i);
      if (i == ident_len) {
        found = unit;
        sym_value = e[4] | (e[5] << 8);
        sym_kind = e[6] & 0x7F;
        sym_seen = e[6] >> 7;
        sym_bank = e[7];
        sym_extra = e[8] | (e[9] << 8);
        return 1;
      }
    }
    unit = e[0] | (e[1] << 8);
  }
  return 0;
}
void Add(unsigned char kind, unsigned int value, unsigned char bank) {
  unsigned char units = (SYM_HEADER + ident_len + 7) >> 3, h = Hash(), i;
  unsigned int want = Scope(), head = *SymHead(h);
  unsigned char* e;
  if ((next_unit & 63) + units > 64) next_unit = (next_unit + 63) & ~63;
  if (next_unit + units < next_unit) { Fail(ASM_ERR_SYMBOLS); return; }
  found = next_unit;
  e = Entry(found);
  e[0] = (unsigned char)head;
  e[1] = (unsigned char)(head >> 8);
  e[2] = (unsigned char)want;
  e[3] = (unsigned char)(want >> 8);
  e[4] = (unsigned char)value;
  e[5] = (unsigned char)(value >> 8);
  e[6] = kind;
  e[7] = bank;
  e[8] = (unsigned char)sym_extra;
  e[9] = (unsigned char)(sym_extra >> 8);
  e[10] = ident_len;
  for (i = 0; i < ident_len; ++i) e[SYM_HEADER + i] = ident[i];
  next_unit += units;
  *SymHead(h) = found;
  ++context->symbols;
}
static char local[NAME_MAX + 1];
unsigned char FindDotted(void) { // Find, with Global.local names too
  unsigned char i, dot = 0, ok;
  unsigned int outer = scope;
  for (i = 1; i < ident_len; ++i) if (ident[i] == '.') dot = i;
  if (!dot) return Find();
  for (i = dot; i <= ident_len; ++i) local[i - dot] = ident[i];
  ident_len = dot;
  ident[dot] = 0;
  ok = Find();
  scope = found;
  for (i = 0; (ident[i] = local[i]) != 0; ++i);
  ident_len = i;
  if (ok) ok = Find();
  scope = outer;
  return ok;
}

// after Link: every label moves with its section (extra = its index), and takes its bank
void Relocate(void) {
  unsigned int unit;
  unsigned char h = 0, *e;
  do {
    for (unit = *SymHead(h); unit; unit = e[0] | (e[1] << 8)) {
      e = Entry(unit);
      if ((e[6] & 0x7F) != SYM_LABEL) continue;
      SectCopy(e[8] | (e[9] << 8), 0);
      e = Entry(unit); // the section's block was in the window
      sym_value = (e[4] | (e[5] << 8)) - sec.start + sec.base;
      e[4] = (unsigned char)sym_value;
      e[5] = (unsigned char)(sym_value >> 8);
      e[7] = sec.bank;
    }
  } while (++h);
}

void StepVar(unsigned int unit, Val step) { // a FOR variable (SYM_VAR): both words
  unsigned char* e = Entry(unit);
  UVal v = ((UVal)e[9] << 24 | (UVal)e[8] << 16 | (unsigned int)(e[5] << 8) | e[4]) + step;
  e[4] = (unsigned char)v;
  e[5] = (unsigned char)(v >> 8);
  e[8] = (unsigned char)(v >> 16);
  e[9] = (unsigned char)(v >> 24);
}

// found was defined in this pass so far (pass 2 marks; pass 1 doesn't need to): DEF() reads it
void Mark(void) { Entry(found)[6] |= 0x80; }
void SetValue(unsigned int value, unsigned int extra) {
  unsigned char* e = Entry(found);
  e[4] = (unsigned char)value;
  e[5] = (unsigned char)(value >> 8);
  e[8] = (unsigned char)extra;
  e[9] = (unsigned char)(extra >> 8);
}


// --- the current section (asm.c keeps it)
unsigned char in_section, sec_rom, sec_bank, rom_used;
unsigned int pc, sec_last;


// --- output
void Emit(unsigned char b) {
  if (!in_section || !sec_rom) { Fail(ASM_ERR_SECTION); return; }
  if (pc > sec_last) { Fail(ASM_ERR_FULL); return; }
  if (pass == 2) {
    Window(ASM_IMAGE_BLOCK + (sec_bank << 5) + ((pc & 0x3FFF) >> 9));
    WINDOW[pc & 511] = b;
  }
  rom_used = 1;
  ++pc;
}
void Emit16(unsigned int v) {
  Emit((unsigned char)v);
  Emit((unsigned char)(v >> 8));
}
void Emit8(unsigned int v) { // -128..255
  if (pass == 2 && v >= 256 && v < 0xFF80) Fail(ASM_ERR_RANGE);
  Emit((unsigned char)v);
}
void EmitSigned(unsigned int v) { // -128..127
  if (pass == 2 && v >= 128 && v < 0xFF80) Fail(ASM_ERR_RANGE);
  Emit((unsigned char)v);
}
void Reserve(unsigned int bytes, unsigned char fill) { // ds: bytes in ROM, space in RAM
  if (!in_section) { Fail(ASM_ERR_SECTION); return; }
  if (sec_rom) { while (bytes-- && !error) Emit(fill); return; }
  if (bytes > sec_last - pc + 1) { Fail(ASM_ERR_FULL); return; }
  pc += bytes;
}


static unsigned char Is(unsigned char i, unsigned char kind, unsigned char reg) {
  return okind[i] == kind && oreg[i] == reg;
}
static unsigned char Cond(unsigned char i) {
  if (okind[i] == K_COND) return oreg[i];
  if (Is(i, K_R8, 1)) return 3;
  Fail(ASM_ERR_OPERAND);
  return 0;
}


// --- instructions
#define M_LD 14
#define M_ADD 18
#define M_INC 26
#define M_JP 28
#define M_RLC 35
#define M_BIT 43
static const unsigned char simple[14] = {0x00, 0x76, 0x10, 0xF3, 0xFB, 0x07, 0x0F, 0x17, 0x1F, 0x27, 0x2F, 0x37, 0x3F, 0xD9};

static void Need(unsigned char n) { if (nops != n) Fail(ASM_ERR_OPERAND); }
static void Ld(void) {
  unsigned char k0 = okind[0], k1 = okind[1], r0 = oreg[0], r1 = oreg[1];
  Need(2);
  if (k0 == K_R8 && k1 == K_R8) {
    if (r0 == 6 && r1 == 6) Fail(ASM_ERR_OPERAND);
    Emit(0x40 | (r0 << 3) | r1);
  }
  else if (k0 == K_R8 && k1 == K_IMM) { Emit(0x06 | (r0 << 3)); Emit8(oval[1]); }
  else if (k0 == K_R16 && k1 == K_IMM) { Emit(0x01 | (r0 << 4)); Emit16(oval[1]); }
  else if (Is(0, K_R16, 2) && k1 == K_SPREL) { Emit(0xF8); EmitSigned(oval[1]); }
  else if (Is(0, K_R16, 3) && Is(1, K_R16, 2)) Emit(0xF9);
  else if (k0 == K_MEMR && Is(1, K_R8, 7)) Emit(0x02 | (r0 << 4));
  else if (Is(0, K_R8, 7) && k1 == K_MEMR) Emit(0x0A | (r1 << 4));
  else if (k0 == K_MEM && Is(1, K_R8, 7)) { Emit(0xEA); Emit16(oval[0]); }
  else if (Is(0, K_R8, 7) && k1 == K_MEM) { Emit(0xFA); Emit16(oval[1]); }
  else if (k0 == K_MEM && Is(1, K_R16, 3)) { Emit(0x08); Emit16(oval[0]); }
  else if (k0 == K_MEMC && Is(1, K_R8, 7)) Emit(0xE2);
  else if (Is(0, K_R8, 7) && k1 == K_MEMC) Emit(0xF2);
  else Fail(ASM_ERR_OPERAND);
}
static void High(unsigned int v) { // ldh's address: $FF00-$FFFF, or just its low byte
  if (pass == 2 && v >= 256 && v < 0xFF00) Fail(ASM_ERR_RANGE);
  Emit((unsigned char)v);
}
static void Ldh(void) {
  Need(2);
  if (okind[0] == K_MEM && Is(1, K_R8, 7)) { Emit(0xE0); High(oval[0]); }
  else if (Is(0, K_R8, 7) && okind[1] == K_MEM) { Emit(0xF0); High(oval[1]); }
  else if (okind[0] == K_MEMC && Is(1, K_R8, 7)) Emit(0xE2);
  else if (Is(0, K_R8, 7) && okind[1] == K_MEMC) Emit(0xF2);
  else Fail(ASM_ERR_OPERAND);
}
static void Alu(unsigned char g) { // add adc sub sbc and xor or cp, with or without "a,"
  unsigned char i = 0;
  if (nops == 2) {
    if (g == 0 && Is(0, K_R16, 2) && okind[1] == K_R16) { Emit(0x09 | (oreg[1] << 4)); return; }
    if (g == 0 && Is(0, K_R16, 3) && okind[1] == K_IMM) { Emit(0xE8); EmitSigned(oval[1]); return; }
    if (!Is(0, K_R8, 7)) { Fail(ASM_ERR_OPERAND); return; }
    i = 1;
  }
  else Need(1);
  if (okind[i] == K_R8) Emit(0x80 | (g << 3) | oreg[i]);
  else if (okind[i] == K_IMM) { Emit(0xC6 | (g << 3)); Emit8(oval[i]); }
  else Fail(ASM_ERR_OPERAND);
}
static void Jump(unsigned char m) { // jp jr call ret
  unsigned char cc = 0xFF, has = m != 31;
  unsigned int target;
  if (m == 28 && nops == 1 && (Is(0, K_R16, 2) || Is(0, K_R8, 6))) { Emit(0xE9); return; }
  if (nops == has + 1) cc = Cond(0) << 3;
  else Need(has);
  if (m == 31) { Emit(cc == 0xFF ? 0xC9 : 0xC0 | cc); return; }
  if (okind[nops - 1] != K_IMM) { Fail(ASM_ERR_OPERAND); return; }
  target = oval[nops - 1];
  if (m == 29) {
    Emit(cc == 0xFF ? 0x18 : 0x20 | cc);
    target -= pc + 1;
    if (pass == 2 && target >= 128 && target < 0xFF80) Fail(ASM_ERR_JR);
    Emit((unsigned char)target);
  }
  else {
    Emit(cc == 0xFF ? (m == 28 ? 0xC3 : 0xCD) : (m == 28 ? 0xC2 : 0xC4) | cc);
    Emit16(target);
  }
}
void Instruction(unsigned char m) {
  unsigned char r;
  if (m < M_LD) { // and the optional operands: cpl a, stop n (its second byte, else 0)
    if (!(nops == 1 && ((m == 10 && Is(0, K_R8, 7)) || (m == 2 && okind[0] == K_IMM)))) Need(0);
    Emit(simple[m]);
    if (m == 2) Emit8(nops ? oval[0] : 0);
  }
  else if (m == M_LD) Ld();
  else if (m == 15) Ldh();
  else if (m <= 17) { // ldi ldd
    Need(2);
    r = m == 16 ? 0x22 : 0x32;
    if (Is(0, K_R8, 6) && Is(1, K_R8, 7)) Emit(r);
    else if (Is(0, K_R8, 7) && Is(1, K_R8, 6)) Emit(r | 8);
    else Fail(ASM_ERR_OPERAND);
  }
  else if (m < M_INC) Alu(m - M_ADD);
  else if (m < M_JP) {
    Need(1);
    r = m - M_INC;
    if (okind[0] == K_R8) Emit(0x04 | r | (oreg[0] << 3));
    else if (okind[0] == K_R16) Emit(0x03 | (r << 3) | (oreg[0] << 4));
    else Fail(ASM_ERR_OPERAND);
  }
  else if (m <= 31) Jump(m);
  else if (m == 32) { // rst
    Need(1);
    if (okind[0] != K_IMM || (oval[0] & 0xFFC7)) Fail(ASM_ERR_OPERAND);
    else Emit(0xC7 | (unsigned char)oval[0]);
  }
  else if (m <= 34) { // push pop
    Need(1);
    r = m == 33 ? 0xC5 : 0xC1;
    if (okind[0] == K_AF) Emit(r | 0x30);
    else if (okind[0] == K_R16 && oreg[0] < 3) Emit(r | (oreg[0] << 4));
    else Fail(ASM_ERR_OPERAND);
  }
  else if (m < M_BIT) {
    Need(1);
    if (okind[0] != K_R8) Fail(ASM_ERR_OPERAND);
    else { Emit(0xCB); Emit(((m - M_RLC) << 3) | oreg[0]); }
  }
  else {
    Need(2);
    if (okind[0] != K_IMM || oval[0] > 7 || okind[1] != K_R8) Fail(ASM_ERR_OPERAND);
    else { Emit(0xCB); Emit(((m - M_BIT + 1) << 6) | (oval[0] << 3) | oreg[1]); }
  }
}


// zeroes the image before pass 2
void Fill(void) {
  unsigned int block, i;
  for (block = 0; block < context->blocks; ++block) {
    Window(ASM_IMAGE_BLOCK + block);
    for (i = 0; i < 512; ++i) WINDOW[i] = 0;
  }
}

static const unsigned char logo[48] = {
  0xCE, 0xED, 0x66, 0x66, 0xCC, 0x0D, 0x00, 0x0B, 0x03, 0x73, 0x00, 0x83, 0x00, 0x0C, 0x00, 0x0D,
  0x00, 0x08, 0x11, 0x1F, 0x88, 0x89, 0x00, 0x0E, 0xDC, 0xCC, 0x6E, 0xE6, 0xDD, 0xDD, 0xD9, 0x99,
  0xBB, 0xBB, 0x67, 0x63, 0x6E, 0x0E, 0xEC, 0xCC, 0xDD, 0xDC, 0x99, 0x9F, 0xBB, 0xB9, 0x33, 0x3E};

// logo, ROM size, header and global checksums (rgbfix -v): the image is the last word
void Header(void) {
  unsigned int block, blocks = context->blocks, sum = 0, i;
  unsigned char x = 0, code = 0;
  Window(ASM_IMAGE_BLOCK);
  for (i = 0; i < 48; ++i) WINDOW[0x104 + i] = logo[i];
  for (i = blocks >> 7; i; i >>= 1) ++code;
  WINDOW[0x148] = code;
  for (i = 0x134; i < 0x14D; ++i) x -= WINDOW[i] + 1;
  WINDOW[0x14D] = x;
  WINDOW[0x14E] = WINDOW[0x14F] = 0;
  for (block = 0; block < blocks; ++block) {
    Window(ASM_IMAGE_BLOCK + block);
    for (i = 0; i < 512; ++i) sum += WINDOW[i];
  }
  Window(ASM_IMAGE_BLOCK);
  WINDOW[0x14E] = (unsigned char)(sum >> 8);
  WINDOW[0x14F] = (unsigned char)sum;
}

