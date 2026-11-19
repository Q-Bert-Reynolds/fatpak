// ASM.MOD: sections (see asm_shared.h). Pass 1 records each section in PSRAM; one without an
// address starts at its region's base in both passes, and its labels keep those pass values:
// LINK.MOD places the sections the way rgblink does and moves them. A section's name is a symbol
// ('"' and the name) holding its index, so FRAGMENTs and pass 2 find it again; each unit has its own.
#include "asm_shared.h"

typedef char sect_fits[sizeof(Sect) == SECT_SIZE && ASM_SECTIONS / SECT_PER_BLOCK <= ASM_DATA_BLOCK - ASM_SECTION_BLOCK ? 1 : -1];

Sect sec;
unsigned int nsects, cur; // sections recorded, the open (or last) one
unsigned int unit_sect0, data_top;

// region (type) base, size, bank count
static const unsigned int region_base[8] = {0, 0x4000, 0x8000, 0xA000, 0xC000, 0xD000, 0xFE00, 0xFF80};
static const unsigned int region_size[8] = {0x4000, 0x4000, 0x2000, 0x2000, 0x1000, 0x1000, 0xA0, 0x7F};
static const unsigned char region_banks[8] = {1, ROM_BANKS, 2, 4, 1, 8, 1, 1};

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

void Enter(void) { // sec is open: pc goes on from its fill
  sec_rom = sec.type < 2;
  sec_bank = (sec.flags & SECT_BANK) || region_banks[sec.type] == 1 ? sec.bank : BANK_LINK;
  sec_last = region_base[sec.type] + region_size[sec.type] - 1;
  sec_dbase = sec.data - (sec.start >> 9);
  pc = sec.fill;
  in_section = 1;
}
// after a unit's pass 1: each ROM section's bytes get blocks from ASM_DATA_BLOCK, the first
// holding its start address's 512 bytes (pass 2 writes them at pc % 512)
void UnitData(void) {
  unsigned int i;
  for (i = unit_sect0; i < nsects && !error; ++i) {
    SectCopy(i, 0);
    sec.data = data_top;
    if (sec.type < 2 && sec.size) {
      data_top += ((sec.start & 511) + sec.size + 511) >> 9;
      if (data_top > ASM_DATA_END) Fail(ASM_ERR_FULL);
    }
    SectCopy(i, 1);
  }
}
void CloseSection(void) {
  if (!in_section) return;
  sec.fill = pc;
  if (pass == 1) sec.size = pc - sec.start;
  SectCopy(cur, 1);
  in_section = 0;
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
      sec.fill = sec.start;
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
