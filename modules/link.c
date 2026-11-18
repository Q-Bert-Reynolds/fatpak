// LINK.MOD: after ASM.MOD (editor/build.c runs one, then the other), what rgblink and rgbfix do
// with its units (asm_obj.h): joins FRAGMENTs of a name, places the sections, gives every label
// its address, copies the sections' bytes into the image, works out each patch, then the header
// and checksums. Then build.log, also after an assembly error. See notes/ASSEMBLER.md.
#include "link.h"

AsmContext* context;
AsmLink link; // ASM.MOD's
unsigned char error;
void Fail(unsigned char code) {
  if (!error) error = code;
}

// --- sections
Sect sec, other;
unsigned char max_bank;
unsigned char* SectAt(unsigned int index) {
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
// region (type) base, size, bank count, first bank's list in heads
static const unsigned int region_base[8] = {0, 0x4000, 0x8000, 0xA000, 0xC000, 0xD000, 0xFE00, 0xFF80};
static const unsigned int region_size[8] = {0x4000, 0x4000, 0x2000, 0x2000, 0x1000, 0x1000, 0xA0, 0x7F};
static const unsigned char region_banks[8] = {1, ROM_BANKS, 2, 4, 1, 8, 1, 1};
static const unsigned char region_first[8] = {0, 1, ROM_BANKS + 1, ROM_BANKS + 3, ROM_BANKS + 7, ROM_BANKS + 8, ROM_BANKS + 16, ROM_BANKS + 17};
#define HEADS (ROM_BANKS + 18)
static unsigned int heads[HEADS]; // each bank's placed sections by address

// where an error is: the file's symbol (ASM.MOD's files table is still in PSRAM), line, position
void Report(unsigned int file, unsigned int line, unsigned int pos) {
  AsmContext* c = context;
  unsigned char *e, n, i, from = 0;
  c->file = file;
  c->line = line;
  c->pos = pos;
  c->base = 0;
  if (!file) return;
  Window(ASM_SYMBOL_BLOCK + (file >> 6));
  e = WINDOW + ((file & 63) << 3);
  n = e[10];
  if (n > sizeof(c->name) - 1) from = n - (sizeof(c->name) - 1); // the path's end
  for (i = 0; from < n; ++i) {
    if ((c->name[i] = e[11 + from++]) == '/') c->base = i + 1;
  }
  c->name[i] = 0;
}
void FailAt(unsigned char code, unsigned int file, unsigned int line, unsigned int pos) {
  if (error) return;
  error = code;
  Report(file, line, pos);
}
void SectFail(unsigned char code, unsigned int s) { // at the section's SECTION line
  SectCopy(s, 0);
  FailAt(code, sec.file, sec.line, sec.pos);
}
void Phase(unsigned char p) { // the box says what's happening, between its own steps
  context->pass = p;
  ModProgress(0);
}

// --- joining FRAGMENTs: s continues r (its first piece, with the same name), like rgblink: from
// r's end, and r takes on s's bank, address or alignment (moved back by r's size so far)
static void Swap(void) { // sec and other trade places (no memcpy in modules)
  unsigned char *a = (unsigned char*)&sec, *b = (unsigned char*)&other, n = sizeof(Sect), t;
  do { t = *a; *a++ = *b; *b++ = t; } while (--n);
}
void Join(unsigned int r, unsigned int s) {
  unsigned int mask, ofs, org;
  SectCopy(s, 0);
  Swap();
  SectCopy(r, 0);
  if (!(other.flags & SECT_FRAGMENT) || !(sec.flags & SECT_FRAGMENT) || other.type != sec.type) { SectFail(ASM_ERR_DUPLICATE, s); return; }
  if (other.flags & SECT_BANK) {
    if (!(sec.flags & SECT_BANK)) {
      sec.flags |= SECT_BANK;
      sec.bank = other.bank;
    }
    else if (sec.bank != other.bank) { SectFail(ASM_ERR_BANK, s); return; }
  }
  mask = (1 << sec.align) - 1;
  if (other.flags & SECT_ADDRESS) {
    org = other.start - sec.size;
    if (sec.flags & SECT_ADDRESS ? sec.start != org : (org - sec.ofs) & mask) { SectFail(ASM_ERR_OVERLAP, s); return; }
    sec.flags |= SECT_ADDRESS;
    sec.start = org;
  }
  else if (other.align) {
    ofs = (other.ofs - sec.size) & ((1 << other.align) - 1);
    if (sec.flags & SECT_ADDRESS) {
      if ((sec.start - ofs) & ((1 << other.align) - 1)) { SectFail(ASM_ERR_OVERLAP, s); return; }
    }
    else if ((ofs - sec.ofs) & mask & ((1 << other.align) - 1)) { SectFail(ASM_ERR_OVERLAP, s); return; }
    else if (other.align > sec.align) {
      sec.align = other.align;
      sec.ofs = ofs;
    }
  }
  other.piece = sec.size;
  other.root = r;
  other.flags |= SECT_PLACED; // Link places r
  sec.size += other.size;
  SectCopy(r, 1);
  Swap();
  SectCopy(s, 1);
}
// --- placing: rgblink's order, biggest first: address and bank given, then bank (one-bank
// regions count), then address, then neither; within those aligned first (the rank), then
// bigger, then later in the source (Place keeps ranks and sizes in WRAM for it)
static unsigned char Rank(void) {
  unsigned char bank = (sec.flags & SECT_BANK) || region_banks[sec.type] == 1;
  return (sec.flags & SECT_ADDRESS ? (bank ? 6 : 2) : (bank ? 4 : 0)) | (sec.align != 0);
}
// the first address at or after at that's ofs past a multiple of mask + 1
static unsigned int Align(unsigned int at, unsigned int mask, unsigned int ofs) {
  return ((at - ofs + mask) & ~mask) + ofs;
}
// places every section like rgblink; NO_SECT, or the one that can't be placed
static unsigned int Place(void) {
  unsigned int n, i, best, at, mask, prev, t, base, end, best_size = 0;
  unsigned char bank, last, found, r, best_rank = 0;
  Sect* p;
  for (i = 0; i < HEADS; ++i) heads[i] = NO_SECT;
  for (i = 0; i < link.nsects; ++i) { // each one's rank and size in WRAM, for the order
    SectCopy(i, 0);
    sect_bank[i] = sec.flags & SECT_PLACED ? 0xFF : Rank();
    sect_delta[i] = sec.size;
  }
  for (n = 0; n < link.nsects; ++n) {
    best = NO_SECT;
    for (i = 0; i < link.nsects; ++i) { // the first left: by rank, then size, then the later one
      if ((r = sect_bank[i]) == 0xFF) continue;
      if (best == NO_SECT || r > best_rank || (r == best_rank && (unsigned int)sect_delta[i] >= best_size)) {
        best = i;
        best_rank = r;
        best_size = sect_delta[i];
      }
    }
    if (best == NO_SECT) break; // the rest are FRAGMENTs' later pieces
    sect_bank[best] = 0xFF;
    SectCopy(best, 0);
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

// --- the image
static unsigned char buf[256];
// zeroes the image, then copies each ROM section's bytes from its data blocks to its place
static void Image(void) {
  unsigned int block, i, from, from_ofs, to, to_ofs, left, n;
  for (block = 0; block < context->blocks; ++block) {
    if (!(block & 63)) Phase(4);
    Window(ASM_IMAGE_BLOCK + block);
    Fill(0);
  }
  for (i = 0; i < link.nsects; ++i) {
    SectCopy(i, 0);
    if (sec.type > 1) continue;
    from = sec.data;
    from_ofs = sec.fill & 511; // its pass start's place in the first block
    to = ASM_IMAGE_BLOCK + (sec.bank << 5) + ((sec.base & 0x3FFF) >> 9);
    to_ofs = sec.base & 511;
    for (left = sec.size; left; left -= n) {
      n = 512 - (from_ofs > to_ofs ? from_ofs : to_ofs);
      if (n > 256) n = 256;
      if (n > left) n = left;
      copy_n = (unsigned char)n;
      Window(from);
      Copy(buf, WINDOW + from_ofs);
      Window(to);
      Copy(WINDOW + to_ofs, buf);
      from_ofs += n; // not inside the test: see Read
      to_ofs += n;
      if (from_ofs == 512) { from_ofs = 0; ++from; }
      if (to_ofs == 512) { to_ofs = 0; ++to; }
    }
  }
}

// logo, ROM size, header and global checksums (rgbfix -v): the image is the last word
// project.gbp's rgbfix options: the bytes each sets, after the title, game ID and licensee
static const unsigned char logo[48] = {
  0xCE, 0xED, 0x66, 0x66, 0xCC, 0x0D, 0x00, 0x0B, 0x03, 0x73, 0x00, 0x83, 0x00, 0x0C, 0x00, 0x0D,
  0x00, 0x08, 0x11, 0x1F, 0x88, 0x89, 0x00, 0x0E, 0xDC, 0xCC, 0x6E, 0xE6, 0xDD, 0xDD, 0xD9, 0x99,
  0xBB, 0xBB, 0x67, 0x63, 0x6E, 0x0E, 0xEC, 0xCC, 0xDD, 0xDC, 0x99, 0x9F, 0xBB, 0xB9, 0x33, 0x3E};
static const unsigned char fix_at[7] = {0x4A, 0x43, 0x46, 0x4B, 0x47, 0x49, 0x4C};
static void Header(void) {
  unsigned int block, blocks = context->blocks, sum = 0, i;
  unsigned char x = 0, code = 0, n;
  Fix* fix = &link.fix;
  if (fix->given & 0x80) { // -p: past the last bank, up to the power of two (Image left it 0)
    for (block = (unsigned int)(max_bank + 1) << 5; block < blocks; ++block) {
      Window(ASM_IMAGE_BLOCK + block);
      Fill(fix->bytes[7]);
    }
  }
  Window(ASM_IMAGE_BLOCK);
  n = fix->id_n ? 11 : fix->given & 2 ? 15 : 16; // the title's room, as rgbfix truncates it
  for (i = 0; i < fix->title_n && i < n; ++i) WINDOW[0x134 + i] = fix->title[i];
  for (i = 0; i < fix->id_n; ++i) WINDOW[0x13F + i] = fix->id[i];
  for (i = 0; i < fix->licensee_n; ++i) WINDOW[0x144 + i] = fix->licensee[i];
  for (i = 0; i < 7; ++i) if (fix->given & (1 << i)) WINDOW[0x100 + fix_at[i]] = fix->bytes[i];
  for (i = 0; i < 48; ++i) WINDOW[0x104 + i] = logo[i];
  for (i = blocks >> 7; i; i >>= 1) ++code;
  WINDOW[0x148] = code;
  for (i = 0x134; i < 0x14D; ++i) x -= WINDOW[i] + 1;
  WINDOW[0x14D] = x;
  WINDOW[0x14E] = WINDOW[0x14F] = 0;
  for (block = 0; block < blocks; ++block) {
    if (!(block & 63)) Phase(4);
    Window(ASM_IMAGE_BLOCK + block);
    sum = Sum(sum);
  }
  Window(ASM_IMAGE_BLOCK);
  WINDOW[0x14E] = (unsigned char)(sum >> 8);
  WINDOW[0x14F] = (unsigned char)sum;
}

static void Run(void) {
  unsigned int i;
  for (i = 0; i < link.nsects; ++i) { // each section's pass start, for its labels (Join moves start)
    SectCopy(i, 0);
    sec.fill = sec.start;
    sec.root = i;
    sec.piece = 0;
    SectCopy(i, 1);
  }
  for (i = 0; i < 2048; ++i) { // the names' heads (the files' entries stay, for Report)
    Window(ASM_SYMBOL_BLOCK + (i >> 9));
    WINDOW[i & 511] = 0;
  }
  name_next = 256;
  Phase(3);
  Walk(0);
  if (error) return;
  if ((i = Place()) != NO_SECT) { // reported at the section that doesn't fit
    SectCopy(i, 0);
    SectFail(sec.flags & SECT_ADDRESS ? ASM_ERR_OVERLAP : ASM_ERR_FULL, i);
    return;
  }
  for (i = 0; i < link.nsects; ++i) { // FRAGMENTs' later pieces go where their first one went
    SectCopy(i, 0);
    if (sec.root != i) {
      Swap();
      SectCopy(other.root, 0);
      other.base = sec.base + other.piece;
      other.bank = sec.bank;
      Swap();
      SectCopy(i, 1);
    }
    Placed(i);
  }
  Walk(1);
  if (error) return;
  for (i = 64; i < (unsigned int)(max_bank + 1) << 5; i <<= 1);
  context->blocks = i;
  Image();
  Walk(2);
  if (error) return;
  Header();
}

// --- build.log (beside the project or the document; the host writes it):
//
//   beisbol.gb from project.gbp
//   assembling  22:40   ~29440 lines, 50 units
//     card       0:23   394 files found and read, 392 through build.cache
//   linking      0:30   295 sections, 13021 patches
//   total       23:10
//   PSRAM copies retried: 0
//   built 512 KB
static unsigned int log_n;
static void LogChar(char c) {
  if (log_n == 1024) return;
  Window(ASM_LOG_BLOCK + (log_n >> 9));
  WINDOW[log_n & 511] = c;
  ++log_n;
}
static void LogText(const char* s) { while (*s) LogChar(*s++); }
static void LogNumber(unsigned int v) {
  char digits[5];
  unsigned char n = 0;
  do { v = (unsigned int)Div(v, 10); digits[n++] = '0' + (unsigned char)div_rem; } while (v);
  while (n) LogChar(digits[--n]);
}
// seconds as minutes:seconds, the minutes right-aligned in 4 (no SDCC helpers: subtraction)
static void LogTime(unsigned int seconds) {
  unsigned int minutes = 0;
  unsigned char tens = 0;
  for (; seconds >= 60; seconds -= 60) ++minutes;
  for (; seconds >= 10; seconds -= 10) ++tens;
  if (minutes < 1000) LogChar(' ');
  if (minutes < 100) LogChar(' ');
  if (minutes < 10) LogChar(' ');
  LogNumber(minutes);
  LogChar(':');
  LogChar('0' + tens);
  LogChar('0' + (unsigned char)seconds);
  LogText("   ");
}
static void Log(char* output, unsigned int seconds) {
  char text[LANG_MAX + 1];
  log_n = 0;
  LogText(link.project ? (const char*)output : "the document");
  LogText(link.project ? " from " ASM_PROJECT_FILE "\n" : "\n");
  LogText("assembling ");
  LogTime(link.seconds);
  LogChar('~');
  LogNumber(link.lines << 6);
  LogText(" lines");
  if (link.units) {
    LogText(", ");
    LogNumber(link.units);
    LogText(" units");
  }
  LogText("\n  card     ");
  LogTime((unsigned int)Div(link.card_frames, 60));
  LogNumber(link.files_read);
  LogText(" files found and read, ");
  LogNumber(link.cache_files);
  LogText(" through build.cache\n");
  if (!link.error) {
    LogText("linking    ");
    LogTime(seconds);
    LogNumber(link.nsects);
    LogText(" sections, ");
    LogNumber(link.patches);
    LogText(" patches\n");
  }
  LogText("total      ");
  LogTime(link.seconds + seconds);
  LogText("\nPSRAM copies retried: ");
  LogNumber((unsigned int)ModStat(MODULE_STAT_RETRIES) + link.retries);
  LogChar('\n');
  if (error) { // where and why it stopped
    LogText("stopped: ");
    LogText(context->file ? (const char*)context->name : "the document");
    LogText(" line ");
    LogNumber(context->line);
    LogText(": ");
    ModString(text, S_ERR_SYNTAX + error - 1);
    LogText(text);
    // The editor reports a macro's call site. Keep its body position too: a hardware
    // failure inside a large macro otherwise gives no clue which statement failed.
    if (link.macro_line) {
      LogText("\nmacro ");
      LogNumber(link.macro_line);
    }
    if (link.error) {
      LogText("\nbyte ");
      LogNumber(link.error_ch);
    }
  }
  else {
    LogText("built ");
    LogNumber(context->blocks >> 1);
    LogText(" KB");
  }
  LogChar('\n');
  context->log_bytes = log_n | 0x8000; // FileWriteImage's count
}

unsigned char ModuleMain(AsmContext* c) {
  unsigned char* p = (unsigned char*)&link;
  unsigned char i;
  char output[sizeof(c->name)];
  context = c;
  Window(ASM_LINK_BLOCK);
  for (i = 0; i < sizeof(AsmLink); ++i) p[i] = WINDOW[i];
  error = link.error;
  for (i = 0; (output[i] = c->name[i]) != 0; ++i); // the ROM's path, before an error's file takes its place
  if (!error) Run();
  Log(output, (unsigned int)ModStat(MODULE_STAT_SECONDS) - link.seconds); // its clock went on from ASM.MOD's
  return error;
}
