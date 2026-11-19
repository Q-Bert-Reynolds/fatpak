// ASM.MOD, second page: arithmetic, the symbol table, instruction encoders and the ROM
// image (asm.c parses; see asm_shared.h). Values are 32 bits; * / % are loops here
// because modules can't import SDCC's helpers.
#include "asm_shared.h"
#include "../lib/psram.h"

#include "asm_math.c"

// --- symbols: 8-byte units in PSRAM from ASM_SYMBOL_BLOCK. Two tables of 256 hash chains, their
// heads in the first two blocks: names (sym_table 0, units 128 up to FILE_UNITS) and files (1,
// from FILE_UNITS).
// unit: next (2), scope (2, the unit of the enclosing global label, 0 for globals), value (2),
// kind (1), bank (1), extra (2), length (1), name. An entry never crosses a block.
#define SYM_HEADER 11
unsigned int next_unit, scope, found;
unsigned int file_next; // Main starts it at FILE_UNITS
unsigned char sym_table;
unsigned int sym_mark;
unsigned char sym_dirty[64]; // a bit per names block below sym_mark that changed (Restore puts it back)
unsigned int sym_value, sym_extra;
unsigned char sym_kind, sym_bank, sym_seen;

unsigned char* Entry(unsigned int unit) {
  Window(ASM_SYMBOL_BLOCK + (unit >> 6));
  return WINDOW + ((unit & 63) << 3);
}
static unsigned int* SymHead(unsigned char h) {
  Window(ASM_SYMBOL_BLOCK + sym_table);
  return (unsigned int*)WINDOW + h;
}
void Dirty(unsigned int unit) {
  if (unit < sym_mark) sym_dirty[unit >> 9] |= 1 << ((unit >> 6) & 7);
}
static unsigned int Scope(void) { return ident[0] == '.' ? scope : 0; }
static unsigned char Hash(void) {
  unsigned int want = Scope();
  unsigned char h = (unsigned char)want ^ (unsigned char)(want >> 8), i;
  for (i = 0; i < ident_len; ++i) h = (h << 5) - h + ident[i];
  return h;
}
// ident's entry in sym_table: found, sym_value, sym_kind and sym_bank; 0 if it isn't defined
#ifdef HOST_TEST
unsigned char Find(void) {
  unsigned int unit = *SymHead(Hash()), want = Scope(), s;
  unsigned char* e;
  unsigned char i;
  while (unit) {
    e = Entry(unit);
    s = e[2] | (e[3] << 8);
    if (e[10] == ident_len && s == want) {
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
#else
// in assembly: every name read goes through it (it was 16% of pass 2 in C)
static unsigned int find_want, find_unit;
unsigned char Find(void) __naked {
  __asm
	call	_Scope
	ld	a, b
	ld	[_find_want+1], a
	ld	a, c
	ld	[_find_want], a
	call	_Hash
	call	_SymHead
	ld	a, [bc]
	ld	e, a
	inc	bc
	ld	a, [bc]
	ld	d, a
.next:
	ld	a, d
	or	a, e
	ret	z
	ld	hl, _find_unit
	ld	[hl], e
	inc	hl
	ld	[hl], d
	call	_Entry
	ld	h, b
	ld	l, c
	ld	a, [hl+]
	ld	e, a
	ld	a, [hl+]
	ld	d, a
	ld	a, [_find_want]
	cp	a, [hl]
	jr	nz, .next
	inc	hl
	ld	a, [_find_want+1]
	cp	a, [hl]
	jr	nz, .next
	ld	bc, 7
	add	hl, bc
	ld	a, [_ident_len]
	cp	a, [hl]
	jr	nz, .next
	inc	hl
	push	de
	ld	b, a
	ld	de, _ident
	or	a, a
	jr	z, .match
.name:
	ld	a, [de]
	cp	a, [hl]
	jr	nz, .differ
	inc	de
	inc	hl
	dec	b
	jr	nz, .name
.match:
	pop	de
	ld	hl, _find_unit
	ld	a, [hl+]
	ld	e, a
	ld	d, [hl]
	ld	hl, _found
	ld	[hl], e
	inc	hl
	ld	[hl], d
	call	_Entry
	ld	hl, 4
	add	hl, bc
	ld	a, [hl+]
	ld	[_sym_value], a
	ld	a, [hl+]
	ld	[_sym_value+1], a
	ld	a, [hl]
	and	a, $7F
	ld	[_sym_kind], a
	ld	a, [hl+]
	rlca
	and	a, 1
	ld	[_sym_seen], a
	ld	a, [hl+]
	ld	[_sym_bank], a
	ld	a, [hl+]
	ld	[_sym_extra], a
	ld	a, [hl]
	ld	[_sym_extra+1], a
	ld	a, 1
	ret
.differ:
	pop	de
	jr	.next
  __endasm;
}
#endif
void Add(unsigned char kind, unsigned int value, unsigned char bank) {
  unsigned char units = (SYM_HEADER + ident_len + 7) >> 3, h = Hash(), i;
  unsigned int want = Scope(), head = *SymHead(h);
  unsigned int* top = sym_table ? &file_next : &next_unit;
  unsigned char* e;
  if ((*top & 63) + units > 64) *top = (*top + 63) & ~63;
  if (*top + units < *top || (!sym_table && *top + units > FILE_UNITS)) { Fail(ASM_ERR_SYMBOLS); return; }
  found = *top;
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
  *top += units;
  *SymHead(h) = found;
  ++context->symbols;
}
static char local[NAME_MAX + 1];
// Find, with Global.local names too; when that isn't found, ident is the whole name again (an import)
unsigned char FindDotted(void) {
  unsigned char i, dot = 0, n = ident_len, ok;
  unsigned int outer = scope;
  for (i = 1; i < n; ++i) if (ident[i] == '.') dot = i;
  if (!dot) return Find();
  for (i = 0; i <= n; ++i) local[i] = ident[i];
  ident[dot] = 0;
  ident_len = dot;
  if ((ok = Find()) != 0) {
    scope = found;
    for (i = dot; i <= n; ++i) ident[i - dot] = local[i];
    ident_len = n - dot;
    ok = Find();
    scope = outer;
  }
  if (!ok) {
    for (i = 0; i <= n; ++i) ident[i] = local[i];
    ident_len = n;
  }
  return ok;
}

// a FOR variable (SYM_VAR) moves on: its value (bytes 4, 5, 8, 9) + step
#ifdef HOST_TEST
void StepVar(unsigned int unit, Val step) {
  unsigned char* e;
  Dirty(unit);
  e = Entry(unit);
  UVal v = ((UVal)e[9] << 24 | (UVal)e[8] << 16 | (unsigned int)(e[5] << 8) | e[4]) + step;
  e[4] = (unsigned char)v;
  e[5] = (unsigned char)(v >> 8);
  e[8] = (unsigned char)(v >> 16);
  e[9] = (unsigned char)(v >> 24);
}
#else
void StepVar(unsigned int unit, Val step) __naked {
  unit; step; // unit in de, step on the stack (popped here)
  __asm
	push	de
	call	_Dirty
	pop	de
	call	_Entry
	ld	hl, sp+2
	ld	d, h
	ld	e, l
	ld	hl, 4
	add	hl, bc
	ld	a, [de]
	add	a, [hl]
	ld	[hl+], a
	inc	de
	ld	a, [de]
	adc	a, [hl]
	ld	[hl], a
	inc	de
	push	af
	ld	hl, 8
	add	hl, bc
	pop	af
	ld	a, [de]
	adc	a, [hl]
	ld	[hl+], a
	inc	de
	ld	a, [de]
	adc	a, [hl]
	ld	[hl], a
	pop	hl
	add	sp, 4
	jp	hl
  __endasm;
}
#endif

// found was defined in this pass so far (pass 2 marks; pass 1 doesn't need to): DEF() reads it.
// The prelude's are marked already.
void Mark(void) {
  unsigned char* e = Entry(found);
  if (!(e[6] & 0x80)) e[6] |= 0x80;
}
void SetValue(unsigned int value, unsigned int extra) {
  unsigned char* e;
  Dirty(found);
  e = Entry(found);
  e[4] = (unsigned char)value;
  e[5] = (unsigned char)(value >> 8);
  e[8] = (unsigned char)extra;
  e[9] = (unsigned char)(extra >> 8);
}


// --- the current section (asm.c keeps it)
unsigned char in_section, sec_rom, sec_bank, rom_used;
unsigned int pc, sec_last, sec_dbase;


// --- output: pass 2 writes each ROM section's bytes in its blocks from ASM_DATA_BLOCK (the one
// for pc is sec_dbase + pc / 512, at pc % 512); LINK.MOD copies them to where it puts the section
void Emit(unsigned char b) {
  if (!in_section || !sec_rom) { Fail(ASM_ERR_SECTION); return; }
  if (pc > sec_last) { Fail(ASM_ERR_FULL); return; }
  if (pass == 2) {
    Window(sec_dbase + (pc >> 9));
    WINDOW[pc & 511] = b;
  }
  rom_used = 1;
  ++pc;
}
// INCBIN's bytes, file_at to file_end: a run at a time through str[], each within a 256-byte
// half of a file block and one image block, instead of a far call for every byte. Pass 1 only counts.
#ifdef HOST_TEST
void EmitFile(void) {
  Pos left = file_end - file_at;
  unsigned int n, i;
  unsigned char* w;
  while (left && !error) {
    if (!in_section || !sec_rom) { Fail(ASM_ERR_SECTION); return; }
    n = 256 - (unsigned char)file_at;
    i = 512 - (pc & 511);
    if (n > i) n = i;
    if (left < n) n = (unsigned int)left;
    if (pc + n - 1 > sec_last) { Fail(ASM_ERR_FULL); return; }
    if (pass == 2) {
      Window(BLOCK(file_at));
      w = WINDOW + ((unsigned int)file_at & 511);
      for (i = 0; i < n; ++i) str[i] = w[i];
      Window(sec_dbase + (pc >> 9));
      w = WINDOW + (pc & 511);
      for (i = 0; i < n; ++i) w[i] = str[i];
    }
    rom_used = 1;
    pc += n;
    file_at += n;
    left -= n;
  }
}
#else
void EmitFile(void) __naked {
  __asm
.next:
	ld	a, [_error]
	or	a, a
	ret	nz
;// c = n - 1: a run stops at the next 256-byte boundary of the file or the image (one block each)
	ld	a, [_file_at]
	ld	b, a
	ld	a, [_pc]
	cp	a, b
	jr	nc, .max
	ld	a, b
.max:
	cpl
	ld	c, a
;// and at file_end, when it's in the same 256 bytes; at it: done
	ld	hl, _file_at+3
	ld	de, _file_end+3
	ld	b, 3
.same:
	ld	a, [de]
	cp	a, [hl]
	jr	nz, .some
	dec	hl
	dec	de
	dec	b
	jr	nz, .same
	ld	a, [de]
	sub	a, [hl]
	ret	z
	dec	a
	cp	a, c
	jr	nc, .some
	ld	c, a
.some:
	ld	b, 0
	ld	a, [_in_section]
	or	a, a
	jr	z, .section
	ld	a, [_sec_rom]
	or	a, a
	jr	z, .section
;// the run's last byte past sec_last: full
	ld	hl, _pc
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	add	hl, bc
	ld	a, [_sec_last]
	sub	a, l
	ld	a, [_sec_last+1]
	sbc	a, h
	jr	c, .full
	inc	hl
	push	hl
	ld	a, [_pass]
	cp	a, 2
	jr	nz, .count
;// pass 2: the file's block (file_at >> 9) in the window, its bytes to str
	xor	a, a
	ld	[_run_n], a
	ld	hl, _file_at+3
	ld	a, [hl-]
	ld	d, a
	ld	a, [hl-]
	ld	e, a
	srl	d
	rr	e
	ld	a, [hl-]
	rra
	ld	d, a
	ld	a, e
	ld	[$BD03], a
	ld	a, d
	ld	[$BD02], a
	ld	a, [hl]
	ld	l, a
	ld	a, $BE
	adc	a, 0
	ld	h, a
	ld	de, _str
	ld	b, c
	inc	b
.in:
	ld	a, [hl+]
	ld	[de], a
	inc	de
	dec	b
	jr	nz, .in
;// then the section's data block for pc: sec_dbase + pc / 512
	ld	a, [_pc+1]
	srl	a
	ld	hl, _sec_dbase
	add	a, [hl]
	ld	e, a
	inc	hl
	ld	a, [hl]
	adc	a, b
	ld	[$BD03], a
	ld	a, e
	ld	[$BD02], a
	ld	a, [_pc+1]
	and	a, 1
	add	a, $BE
	ld	h, a
	ld	a, [_pc]
	ld	l, a
	ld	de, _str
	ld	b, c
	inc	b
.out:
	ld	a, [de]
	inc	de
	ld	[hl+], a
	dec	b
	jr	nz, .out
;// pc and file_at move on
.count:
	pop	hl
	ld	a, l
	ld	[_pc], a
	ld	a, h
	ld	[_pc+1], a
	ld	a, 1
	ld	[_rom_used], a
	ld	hl, _file_at
	scf
	ld	a, [hl]
	adc	a, c
	ld	[hl+], a
	ld	a, [hl]
	adc	a, b
	ld	[hl+], a
	ld	a, [hl]
	adc	a, b
	ld	[hl+], a
	ld	a, [hl]
	adc	a, b
	ld	[hl], a
	jp	.next
.section:
	ld	a, 7
	jp	_Fail
.full:
	ld	a, 8
	jp	_Fail
  __endasm;
}
#endif
// a value only the link knows (prel) is a patch, and 0 for now
void Emit16(unsigned int v) {
  if (prel) Patch(P_WORD);
  Emit((unsigned char)v);
  Emit((unsigned char)(v >> 8));
}
void Emit8(unsigned int v) { // -128..255
  if (prel) Patch(P_BYTE);
  else if (pass == 2 && v >= 256 && v < 0xFF80) Fail(ASM_ERR_RANGE);
  Emit((unsigned char)v);
}
void EmitSigned(unsigned int v) { // -128..127
  if (prel) Patch(P_SIGNED);
  else if (pass == 2 && v >= 128 && v < 0xFF80) Fail(ASM_ERR_RANGE);
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
  if (prel) Patch(P_HRAM);
  else if (pass == 2 && v >= 256 && v < 0xFF00) Fail(ASM_ERR_RANGE);
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
    if (prel == 1 && psect == cur) prel = 0; // a pass value in this section: the distance is known
    if (prel) Patch(P_JR);
    else {
      target -= pc + 1;
      if (pass == 2 && target >= 128 && target < 0xFF80) Fail(ASM_ERR_JR);
    }
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
    if (okind[0] != K_IMM || (!prel && (oval[0] & 0xFFC7))) Fail(ASM_ERR_OPERAND);
    else if (prel) { Patch(P_RST); Emit(0xC7); }
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
    if (okind[0] != K_IMM || prel || oval[0] > 7 || okind[1] != K_R8) Fail(ASM_ERR_OPERAND);
    else { Emit(0xCB); Emit(((m - M_BIT + 1) << 6) | (oval[0] << 3) | oreg[1]); }
  }
}
