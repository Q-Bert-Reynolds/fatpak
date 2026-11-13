// ASM.MOD: sections (see asm_shared.h). Pass 1 records each section in PSRAM; one without an
// address starts at its region's base for the pass (labels are relocated after). Link then
// places them the way rgblink does, and pass 2 assembles each at its final place. A section's
// name is a symbol ('"' and the name) holding its index, so FRAGMENTs and pass 2 find it again.
#include "asm_shared.h"

#define SECT_SIZE 32
#define SECT_PER_BLOCK (512 / SECT_SIZE)
typedef char sect_fits[sizeof(Sect) <= SECT_SIZE && ASM_SECTIONS / SECT_PER_BLOCK <= ASM_FILE_BLOCK - ASM_SECTION_BLOCK ? 1 : -1];

Sect sec;
unsigned int nsects, cur; // sections recorded, the open (or last) one
unsigned char max_bank;

// region (type) base, size, bank count, first bank's list in heads
static const unsigned int region_base[8] = {0, 0x4000, 0x8000, 0xA000, 0xC000, 0xD000, 0xFE00, 0xFF80};
static const unsigned int region_size[8] = {0x4000, 0x4000, 0x2000, 0x2000, 0x1000, 0x1000, 0xA0, 0x7F};
static const unsigned char region_banks[8] = {1, ROM_BANKS, 2, 4, 1, 8, 1, 1};
static const unsigned char region_first[8] = {0, 1, ROM_BANKS + 1, ROM_BANKS + 3, ROM_BANKS + 7, ROM_BANKS + 8, ROM_BANKS + 16, ROM_BANKS + 17};
#define HEADS (ROM_BANKS + 18)
static unsigned int heads[HEADS]; // Link: each bank's placed sections by address

static unsigned char* SectAt(unsigned int index) {
  Window(ASM_SECTION_BLOCK + index / SECT_PER_BLOCK);
  return WINDOW + (index % SECT_PER_BLOCK) * SECT_SIZE;
}
void SectCopy(unsigned int index, unsigned char store) {
  unsigned char* p = SectAt(index);
  unsigned char* s = (unsigned char*)&sec;
  unsigned char n = sizeof(Sect);
  if (store) do *p++ = *s++; while (--n);
  else do *s++ = *p++; while (--n);
}

void CloseSection(void) {
  if (!in_section) return;
  sec.fill = pc;
  if (pass == 1) sec.size = pc - sec.start;
  SectCopy(cur, 1);
  in_section = 0;
}
void Enter(void) { // sec is open: pc goes on from its fill
  sec_rom = sec.type < 2;
  sec_bank = sec.bank;
  sec_last = region_base[sec.type] + region_size[sec.type] - 1;
  pc = sec.fill;
  in_section = 1;
}
// the first address at or after at that's ofs past a multiple of mask + 1
static unsigned int Align(unsigned int at, unsigned int mask, unsigned int ofs) {
  return ((at - ofs + mask) & ~mask) + ofs;
}

// SECTION [FRAGMENT] "name", type[address][, BANK[n]][, ALIGN[n[, offset]]]
void Section(void) {
  unsigned char type, bank, align = 0, placed = 0, fixed = 0, fragment = 0, k;
  unsigned int address = 0, size, ofs = 0;
  Frame* f;
  CloseSection();
  Space();
  if (ch != '"') {
    ReadIdent();
    if (Keyword(T_ATTRIBUTES) != 2) { Fail(ident_len ? ASM_ERR_UNSUPPORTED : ASM_ERR_SYNTAX); return; }
    fragment = SECT_FRAGMENT;
    Space();
    if (ch != '"') { Fail(ASM_ERR_SYNTAX); return; }
  }
  Advance();
  ident[0] = '"';
  for (ident_len = 1; ch != '"'; ++ident_len) {
    if (!ch || ch == 10) { Fail(ASM_ERR_SYNTAX); return; }
    if (ident_len == NAME_MAX) { Fail(ASM_ERR_NAME); return; }
    ident[ident_len] = ch;
    Advance();
  }
  ident[ident_len] = 0;
  SaveName();
  Advance();
  Expect(',');
  Space();
  ReadIdent();
  type = Keyword(T_TYPES);
  if (type == 0xFF) { Fail(ASM_ERR_SYNTAX); return; }
  bank = type == 1 || type == 5;
  Space();
  if (ch == '[') { Advance(); address = Constant(); Expect(']'); placed = SECT_ADDRESS; }
  while (!error) {
    Space();
    if (ch != ',') break;
    Advance();
    Space();
    ReadIdent();
    k = Keyword(T_ATTRIBUTES); // 0 bank, 1 align
    Expect('[');
    size = Constant();
    Space();
    if (k == 1 && ch == ',') { Advance(); ofs = Constant(); }
    Expect(']');
    if (k == 0) { bank = (unsigned char)size; fixed = SECT_BANK; }
    else if (k == 1) align = (unsigned char)size;
    else Fail(ASM_ERR_UNSUPPORTED);
  }
  if (error) return;
  if (bank >= region_banks[type] || ((type == 1 || type == 5) && !bank) || align > 13 || ofs >> align) { Fail(ASM_ERR_BANK); return; }
  if (placed && (address < region_base[type] || address - region_base[type] >= region_size[type])) { Fail(ASM_ERR_FULL); return; }
  LoadName();
  if (Find()) { // a FRAGMENT goes on, or pass 2 opens it again
    SectCopy(cur = sym_value, 0);
    if (pass == 1 && (!fragment || !(sec.flags & SECT_FRAGMENT) || sec.type != type)) { Fail(ASM_ERR_DUPLICATE); return; }
    if (pass == 2 && !(sec.flags & SECT_OPEN)) {
      sec.flags |= SECT_OPEN;
      sec.fill = sec.base;
      sec.align = sec.align0;
      sec.ofs = sec.ofs0;
    }
  }
  else {
    if (pass == 2) { Fail(ASM_ERR_PHASE); return; }
    if (nsects == ASM_SECTIONS) { Fail(ASM_ERR_NESTING); return; }
    sym_extra = 0;
    Add(SYM_SECTION, cur = nsects++, 0);
    sec.type = type;
    sec.bank = bank;
    sec.align = sec.align0 = align;
    sec.ofs = sec.ofs0 = ofs;
    sec.flags = fixed | fragment | placed;
    sec.start = sec.fill = placed ? address : Align(region_base[type], (1 << align) - 1, ofs); // for this pass
    f = TextFrame();
    sec.file = f->file;
    sec.line = f->line;
    sec.pos = (unsigned int)frames[0].line_pos;
  }
  Enter();
}

// rgblink's order, biggest first: address and bank given, then bank (one-bank regions count),
// then address, then neither; within those aligned first (the rank), then bigger, then later in
// the source
static unsigned char Rank(void) {
  unsigned char bank = (sec.flags & SECT_BANK) || region_banks[sec.type] == 1;
  return (sec.flags & SECT_ADDRESS ? (bank ? 6 : 2) : (bank ? 4 : 0)) | (sec.align != 0);
}
// a's place comes before b's (by rank and size; the index breaks ties)
static unsigned char Before(const Sect* a, unsigned int ia, const Sect* b, unsigned int ib) {
  if (a->rank != b->rank) return a->rank > b->rank;
  if (a->size != b->size) return a->size > b->size;
  return ia > ib;
}
// places every section like rgblink; NO_SECT, or the one that can't be placed
unsigned int Link(void) {
  unsigned int n, i, best, at, mask, prev, t, base, end;
  unsigned char bank, last, found;
  Sect* p;
  max_bank = 0;
  for (i = 0; i < HEADS; ++i) heads[i] = NO_SECT;
  for (i = 0; i < nsects; ++i) {
    SectCopy(i, 0);
    sec.rank = Rank();
    SectCopy(i, 1);
  }
  for (n = 0; n < nsects; ++n) {
    best = NO_SECT;
    for (i = 0; i < nsects; ++i) { // the first left (sec holds the best so far)
      p = (Sect*)SectAt(i);
      if (!(p->flags & SECT_PLACED) && (best == NO_SECT || Before(p, i, &sec, best))) {
        best = i;
        SectCopy(i, 0);
      }
    }
    mask = (1 << sec.align) - 1;
    bank = (sec.flags & SECT_BANK) ? sec.bank : sec.type == 1 || sec.type == 5;
    last = (sec.flags & SECT_BANK) ? bank : region_banks[sec.type] - 1;
    found = 0;
    if (!sec.size) { // empty: its address, or the region's start; it takes no room
      sec.bank = bank;
      sec.base = (sec.flags & SECT_ADDRESS) ? sec.start : Align(region_base[sec.type], mask, 0); // rgblink ignores the offset
      found = 1;
    }
    for (; !found && bank <= last; ++bank) { // the first gap in the bank's list where it fits
      at = (sec.flags & SECT_ADDRESS) ? sec.start : Align(region_base[sec.type], mask, sec.ofs);
      prev = NO_SECT;
      for (t = heads[region_first[sec.type] + bank]; t != NO_SECT; prev = t, t = p->next) {
        p = (Sect*)SectAt(t);
        base = p->base;
        end = base + p->size;
        if ((unsigned long)at + sec.size <= base) break;
        if (at < end) {
          if (sec.flags & SECT_ADDRESS) break;
          at = Align(end, mask, sec.ofs);
          if (at < end) { at = 0xFFFF; break; } // past $FFFF: doesn't fit
        }
      }
      if (at < region_base[sec.type] || (unsigned long)at + sec.size > (unsigned long)region_base[sec.type] + region_size[sec.type]) continue;
      if (t != NO_SECT && (unsigned long)at + sec.size > base) continue; // a fixed address that overlaps
      found = 1;
      sec.bank = bank;
      sec.base = at;
      sec.next = t;
      if (prev == NO_SECT) heads[region_first[sec.type] + bank] = best;
      else ((Sect*)SectAt(prev))->next = best;
    }
    if (!found) return best;
    sec.flags |= SECT_PLACED;
    SectCopy(best, 1);
    if (sec.type < 2 && sec.bank > max_bank) max_bank = sec.bank; // empty ones too, like rgblink
  }
  return NO_SECT;
}
