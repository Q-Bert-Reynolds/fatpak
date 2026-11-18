// ASM.MOD: every unit starts from the prelude (rgbasm -P reads it before each file). It's read
// once; Snapshot copies what it left (the names table's head block and its blocks, the charmaps'
// names and heads) to ASM_SNAP_BLOCK, and Restore puts back what a unit changed before each of
// its passes: the blocks of prelude symbols it redefined or PURGEd (Dirty), the charmaps if it
// added to them, and before its pass 1 the heads too, which drops the last unit's symbols.
// Exports writes a unit's names for LINK.MOD after its pass 2.
#include "asm_shared.h"

unsigned int heap_mark;
extern unsigned char sym_dirty[64];
#define SNAP_CHARMAP (ASM_SNAP_BLOCK + 1) // after the heads: the charmaps' names and heads blocks
#define SNAP_NAMES (SNAP_CHARMAP + 1 + CM_MAPS - 2) // + the names table's block (from 2)

#ifdef HOST_TEST
static void Copy(unsigned int from, unsigned int to) { // a block, through str[]
  unsigned char half = 0, i, *w;
  do {
    Window(from);
    w = WINDOW + (half << 8);
    i = 0;
    do str[i] = w[i]; while (++i);
    Window(to);
    w = WINDOW + (half << 8);
    do w[i] = str[i]; while (++i);
  } while (++half < 2);
}
#else
static void Copy(unsigned int from, unsigned int to) __naked { // in assembly: the prelude's ~100 blocks
  from; to; // de, bc
  __asm
	ld	h, $BE
.half:
	push	bc
	ld	a, d
	ld	[$BD03], a
	ld	a, e
	ld	[$BD02], a
	push	de
	push	hl
	ld	l, 0
	ld	de, _str
.in:
	ld	a, [hl+]
	ld	[de], a
	inc	de
	ld	a, l
	or	a, a
	jr	nz, .in
	pop	hl
	pop	de
	pop	bc
	ld	a, b
	ld	[$BD03], a
	ld	a, c
	ld	[$BD02], a
	push	bc
	push	de
	push	hl
	ld	l, 0
	ld	de, _str
.out:
	ld	a, [de]
	inc	de
	ld	[hl+], a
	ld	a, l
	or	a, a
	jr	nz, .out
	pop	hl
	pop	de
	pop	bc
	inc	h
	ld	a, h
	cp	a, $C0
	jr	nz, .half
	ret
  __endasm;
}
#endif
static void Charmaps(unsigned char store) {
  unsigned char b = 0;
  do {
    if (store) Copy(ASM_CHARMAP_BLOCK + b, SNAP_CHARMAP + b);
    else Copy(SNAP_CHARMAP + b, ASM_CHARMAP_BLOCK + b);
  } while (++b <= CM_MAPS);
  CharmapSave(store);
  cm_dirty = 0;
}
void Snapshot(void) {
  unsigned int b;
  next_unit = (next_unit + 63) & ~63; // no unit's symbol shares a block with the prelude's
  sym_mark = next_unit;
  heap_mark = heap_top;
  if (SNAP_NAMES + (sym_mark >> 6) > ASM_SNAP_END) { Fail(ASM_ERR_SYMBOLS); return; }
  Copy(ASM_SYMBOL_BLOCK, ASM_SNAP_BLOCK);
  for (b = 2; b < sym_mark >> 6; ++b) Copy(ASM_SYMBOL_BLOCK + b, SNAP_NAMES + b);
  Charmaps(1);
  for (b = 0; b < sizeof(sym_dirty); ++b) sym_dirty[b] = 0;
}
void Restore(unsigned char unit) {
  unsigned int b;
  for (b = 2; b < sym_mark >> 6; ++b) {
    if (sym_dirty[b >> 3] & (1 << (b & 7))) Copy(SNAP_NAMES + b, ASM_SYMBOL_BLOCK + b);
  }
  for (b = 0; b < sizeof(sym_dirty); ++b) sym_dirty[b] = 0;
  if (cm_dirty) Charmaps(0);
  else CharmapSave(0);
  if (unit) {
    Copy(ASM_SNAP_BLOCK, ASM_SYMBOL_BLOCK);
    next_unit = sym_mark;
    heap_top = heap_mark;
  }
}

// the unit's name after str[0..n): the new n. A local label's scope is its global's unit.
static unsigned char Append(unsigned char n, unsigned int unit) {
  unsigned char* e = Entry(unit);
  unsigned char len = e[10];
  e += 11;
  while (len--) str[n++] = *e++;
  return n;
}
static void OutName(unsigned int unit, unsigned int parent) { // "Global.local" for a local label
  unsigned char n = Append(parent ? Append(0, parent) : 0, unit), i;
  Out(n);
  for (i = 0; i < n; ++i) Out(str[i]);
}
// the unit's sections' names, its labels and EXPORTed constants: the newest entries of each chain,
// down to the prelude's
typedef struct { unsigned int next, scope, value; unsigned char kind, bank; unsigned int extra; } SymHead; // an entry's start
void Exports(void) {
  unsigned char h = 0, kind, i, *p;
  unsigned int unit;
  SymHead e;
  do {
    Window(ASM_SYMBOL_BLOCK);
    for (unit = ((unsigned int*)WINDOW)[h]; unit >= sym_mark && !error; unit = e.next) {
      for (p = Entry(unit), i = 0; i < sizeof(SymHead); ++i) ((unsigned char*)&e)[i] = p[i]; // (Out moves the window)
      kind = e.kind & 0x7F;
      if (kind == SYM_SECTION) kind = OBJ_SECTION;
      else if (kind == SYM_LABEL) kind = OBJ_LABEL;
      else if ((kind == SYM_EQU || kind == SYM_VAR) && e.bank) kind = OBJ_CONST; // EXPORTed
      else continue;
      Out(kind);
      if (kind != OBJ_CONST) Out16((kind == OBJ_SECTION ? e.value : e.extra & ~LABEL_FIXED) - unit_sect0);
      if (kind != OBJ_SECTION) Out16(e.value);
      if (kind == OBJ_CONST) Out16(e.extra);
      OutName(unit, e.scope);
    }
  } while (++h);
}
