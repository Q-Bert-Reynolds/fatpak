// LINK.MOD's second page: reading ASM.MOD's objects (asm_obj.h), the names they define and use,
// and patches: their RPN, and the field each one fills. See link.c.
#include "link.h"
#include "asm_math.c"

// --- byte loops in assembly (SDCC's C took a minute of beisbol's link for them): the window filled
// with b; sum plus its 512 bytes (Copy is in link_read.c)
#ifdef HOST_TEST
void Fill(unsigned char b) { unsigned int i; for (i = 0; i < 512; ++i) WINDOW[i] = b; }
unsigned int Sum(unsigned int sum) { unsigned int i; for (i = 0; i < 512; ++i) sum += WINDOW[i]; return sum; }
#else
void Fill(unsigned char b) __naked {
  b; // a
  __asm
	ld	hl, $BE00
	ld	c, 0
.fill:
	ld	[hl+], a
	ld	[hl+], a
	dec	c
	jr	nz, .fill
	ret
  __endasm;
}
unsigned int Sum(unsigned int sum) __naked {
  sum; // de, the result in bc
  __asm
	ld	hl, $BE00
.sum:
	ld	a, [hl+]
	add	a, e
	ld	e, a
	jr	nc, .carry
	inc	d
.carry:
	ld	a, h
	cp	a, $C0
	jr	nz, .sum
	ld	b, d
	ld	c, e
	ret
  __endasm;
}
#endif

unsigned int obj_end_block, obj_end_ofs;
char name[160];
unsigned char name_n;
// file's name (ASM.MOD's files table): its length, and the stream at it for Read
unsigned char FileName(unsigned int file) {
  in_block = ASM_SYMBOL_BLOCK + (file >> 6);
  in_ofs = ((file & 63) << 3) + 10;
  Read(&name_n, 1);
  return name_n;
}

// --- where each section went: Place's address minus the passes' (both in one region, so within
// 16 bits), and its bank; Moved and Put need nothing else
int sect_delta[ASM_SECTIONS]; // Place's sizes before then
unsigned char sect_bank[ASM_SECTIONS]; // and its ranks (0xFF: placed, or a FRAGMENT's later piece)
void Placed(unsigned int s) { // sec is section s, placed
  sect_delta[s] = sec.base - sec.fill;
  sect_bank[s] = sec.bank;
}

// --- names: section names ('"' first), labels and exported constants, in ASM.MOD's names
// table's blocks: 1024 hash heads in the first 4 (the files table's heads, in the second, aren't
// needed: Report reads files by unit), units from 256, 8 bytes each: next (2), value (4), bank,
// length, name
#define L_HEADER 8
unsigned int name_next;
static unsigned char* NameAt(unsigned int unit) {
  Window(ASM_SYMBOL_BLOCK + (unit >> 6));
  return WINDOW + ((unit & 63) << 3);
}
// name's hash (h * 31 + each character), which Lookup keeps for Insert
#ifdef HOST_TEST
static unsigned int Hash(void) {
  unsigned int h = 0;
  unsigned char i;
  for (i = 0; i < name_n; ++i) h = (h << 5) - h + (unsigned char)name[i];
  return h;
}
#else
static unsigned int Hash(void) __naked {
  __asm
	ld	hl, 0
	ld	de, _name
	ld	a, [_name_n]
.hash:
	or	a, a
	jr	z, .hashed
	push	af
	ld	b, h
	ld	c, l
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	ld	a, l
	sub	a, c
	ld	l, a
	ld	a, h
	sbc	a, b
	ld	h, a
	ld	a, [de]
	inc	de
	add	a, l
	ld	l, a
	jr	nc, .no_carry
	inc	h
.no_carry:
	pop	af
	dec	a
	jr	.hash
.hashed:
	ld	b, h
	ld	c, l
	ret
  __endasm;
}
#endif
static unsigned int name_hash;
static unsigned int* Head(void) { // name_hash's head
  Window(ASM_SYMBOL_BLOCK + ((name_hash >> 8) & 3));
  return (unsigned int*)WINDOW + (name_hash & 255);
}
Val found_value;
unsigned char found_bank;
unsigned int Lookup(void) { // name's unit, found_value and found_bank; 0: none
  unsigned int unit;
  unsigned char* e;
  unsigned char i;
  name_hash = Hash();
  for (unit = *Head(); unit; unit = e[0] | (e[1] << 8)) {
    e = NameAt(unit);
    if (e[7] != name_n) continue;
    for (i = 0; i < name_n && e[L_HEADER + i] == name[i]; ++i);
    if (i < name_n) continue;
    found_value = *(Val*)(e + 2);
    found_bank = e[6];
    return unit;
  }
  return 0;
}
unsigned char Insert(Val value, unsigned char bank) { // 0 if name is there already
  unsigned char units = (L_HEADER + name_n + 7) >> 3, i;
  unsigned int head;
  unsigned char* e;
  if (Lookup()) return 0;
  head = *Head();
  if ((name_next & 63) + units > 64) name_next = (name_next + 63) & ~63;
  if (name_next + units > 49152u) { Fail(ASM_ERR_SYMBOLS); return 1; } // ASM.MOD's files table starts there
  e = NameAt(name_next);
  e[0] = (unsigned char)head;
  e[1] = (unsigned char)(head >> 8);
  *(Val*)(e + 2) = value;
  e[6] = bank;
  e[7] = name_n;
  for (i = 0; i < name_n; ++i) e[L_HEADER + i] = name[i];
  *Head() = name_next;
  name_next += units;
  return 1;
}

// --- labels and patches
unsigned int first; // the unit's first section
unsigned int at_file, at_line, at_pos; // the patch's place
static Val Moved(unsigned int s, Val v) { // a pass value in the unit's section s, where it went
  return Apply('+', v, (Val)sect_delta[first + s]);
}
static void Poke(unsigned char bank, unsigned int address, unsigned char b) {
  Window(ASM_IMAGE_BLOCK + (bank << 5) + ((address & 0x3FFF) >> 9));
  WINDOW[address & 511] = b;
}

// --- patches: RPN on a stack of values
#define STACK 16
static Val stack[STACK];
static unsigned char rpn[RPN_SIZE], rpn_n;
static Val Value(void) {
  unsigned char i = 0, sp = 0, o, j;
  unsigned int s;
  Val v;
  while (i < rpn_n && !error) {
    o = rpn[i++];
    if (o == RPN_CONST) {
      v = *(Val*)(rpn + i);
      i += 4;
    }
    else if (o == RPN_SREL || o == RPN_BANKSECT) {
      s = rpn[i] | (rpn[i + 1] << 8);
      i += 2;
      if (o == RPN_SREL) {
        v = Moved(s, *(Val*)(rpn + i));
        i += 4;
      }
      else v = sect_bank[first + s];
    }
    else if (o == RPN_SYM || o == RPN_BANKSYM) {
      name_n = rpn[i++];
      for (j = 0; j < name_n; ++j) name[j] = rpn[i++];
      if (!Lookup()) { FailAt(ASM_ERR_SYMBOL, at_file, at_line, at_pos); return 0; }
      v = o == RPN_SYM ? found_value : found_bank;
    }
    else if (o >= 'a' && o != 'g' && o != 'l' && o != 'r' && o != 's') { // unary
      v = stack[--sp];
      if (o == RPN_NEG) v = Apply('-', 0, v);
      else if (o == RPN_NOT) v = Apply('^', v, -1);
      else if (o == RPN_LNOT) v = !v;
      else {
        if (o == RPN_HIGH) v = Apply('r', v, 8);
        v = Apply('&', v, 0xFF);
      }
    }
    else {
      v = stack[--sp];
      v = Apply(o, stack[--sp], v);
    }
    if (sp == STACK) { Fail(ASM_ERR_NESTING); return 0; }
    stack[sp++] = v;
  }
  return stack[0];
}
// the patch's value into its field at pass address pc in the unit's section s
static void Put(unsigned int s, unsigned int pc, unsigned char type) {
  unsigned int address, u;
  unsigned char bank, i;
  Val v = Value();
  if (error) return;
  s += first;
  bank = sect_bank[s];
  address = pc + sect_delta[s];
  u = (unsigned int)v;
  if (type == P_JR) {
    u -= address + 1;
    if (u >= 128 && u < 0xFF80) { FailAt(ASM_ERR_JR, at_file, at_line, at_pos); return; }
  }
  else if (type == P_ASSERT) {
    if (!v) FailAt(ASM_ERR_ASSERT, at_file, at_line, at_pos);
    return;
  }
  else if (type == P_RST) {
    if (u & 0xFFC7) { FailAt(ASM_ERR_OPERAND, at_file, at_line, at_pos); return; }
    u |= 0xC7;
  }
  else if (type == P_HRAM ? u >= 256 && u < 0xFF00 : type == P_BYTE ? u >= 256 && u < 0xFF80 : type == P_SIGNED && u >= 128 && u < 0xFF80) {
    FailAt(ASM_ERR_RANGE, at_file, at_line, at_pos);
    return;
  }
  i = type == P_LONG ? 4 : type == P_WORD ? 2 : 1;
  if (i == 1) *(unsigned char*)&v = (unsigned char)u; // jr's distance, rst's opcode, ldh's low byte
  for (s = 0; s < i; ++s) Poke(bank, address + s, ((unsigned char*)&v)[s]);
}
// ASM.MOD's objects, one step at a time: 0 the section names (the first of a name is a
// section, later FRAGMENTs join it), 1 labels and exported constants (each one's address and
// bank, by name), 2 patches
static unsigned char head[PATCH_HEAD];
#define HEAD16(at) (head[at] | (head[(at) + 1] << 8))
void Walk(unsigned char step) {
  unsigned char kind, n, unit = 0, kept = 0;
  unsigned int back_block = 0, back_ofs = 0;
  unsigned int s;
  Val v;
  in_block = ASM_OBJ_BLOCK;
  in_ofs = 0;
  while (!error) {
    if (kept && in_block == kept_end_block && in_ofs == kept_end_ofs) { // an unchanged unit's end: back
      kept = 0;
      in_block = back_block;
      in_ofs = back_ofs;
    }
    Read(&kind, 1);
    if (kind == OBJ_KEEP) { // an unchanged unit's object, in the last build.obj
      Read(&n, 1);
      back_block = in_block;
      back_ofs = in_ofs;
      kept = 1;
      report_unit = unit++;
      KeepAt(n);
      if (step == 2) Phase(3);
      continue;
    }
    if (kind == OBJ_END) {
      obj_end_block = in_block; // just past it: build.obj takes the stream to here
      obj_end_ofs = in_ofs;
      break;
    }
    if (kind == OBJ_UNIT) {
      Read(head, 4);
      first = HEAD16(0);
      report_unit = unit++;
      if (step == 2) Phase(3);
      continue;
    }
    if (kind == OBJ_FILE) { // a file the unit read: for build.obj
      Skip(2);
      continue;
    }
    if (kind == OBJ_PATCH) { // section, pass address, type, file, line, pos, RPN length
      Read(head, PATCH_HEAD);
      n = head[11];
      if (step != 2) { Skip(n); continue; }
      at_file = HEAD16(5);
      at_line = HEAD16(7);
      at_pos = HEAD16(9);
      rpn_n = n;
      Read(rpn, n);
      Put(HEAD16(0), HEAD16(2), head[4]);
      ++link.patches;
      continue;
    }
    Read(head, kind == OBJ_SECTION ? 3 : 5); // the section and length, or a label's or constant's 4 bytes too
    name_n = head[kind == OBJ_SECTION ? 2 : 4];
    if (step == 2 || (step == 0) != (kind == OBJ_SECTION)) { Skip(name_n); continue; }
    Read((unsigned char*)name, name_n);
    s = first + HEAD16(0);
    if (kind == OBJ_SECTION) {
      if (!Insert(s, 0)) Join((unsigned int)found_value, s);
      continue;
    }
    v = kind == OBJ_CONST ? *(Val*)head : Moved(HEAD16(0), (Val)HEAD16(2));
    if (!Insert(v, kind == OBJ_LABEL ? sect_bank[s] : 0)) SectFail(ASM_ERR_DUPLICATE, kind == OBJ_LABEL ? s : first);
  }
}
