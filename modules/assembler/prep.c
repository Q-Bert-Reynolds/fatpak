// PREP.MOD: before ASM.MOD (editor/build.c runs it first), which units the last build.obj
// (asm_obj.h) has unchanged: it loads it at ASM_OLD_BLOCK and reads the directory entry of
// project.gbp and of every file it lists (ModSector, one sector at a time). A unit whose files
// all read the same is clean (AsmPrep at ASM_PREP_BLOCK, ASM_OLD in the context); one written
// without a clock (2026-01-01 00:00) never is. With all of them clean and the ROM as the last
// build left it, the build is up to date (ASM_CURRENT): only build.obj's head and lists are read.
// One page, so a build without a project pays little.
#include "link.h"
#ifndef HOST_TEST
#include "../../src/fatfs/lib/ff.h" // FATFS, FIL: the host's, read through ModStat's pointers
#endif

AsmContext* context;
#define NO_CLOCK_DATE 0x5C21 // 2026-01-01, what the host writes without a clock (rtc.c)
#define OFS(field) __builtin_offsetof(BuildHead, field)
static const char build_obj[] = "build.obj";
static const char proj_name[] = ASM_PROJECT_FILE;

static void Old(UVal at, void* p, unsigned char n) { // from the last build.obj
  in_block = ASM_OLD_BLOCK + (unsigned int)(at >> 9);
  in_ofs = (unsigned int)at & 511;
  Read((unsigned char*)p, n);
}
static unsigned char rec[FILE_RECORD];
static UVal sector_at;
static unsigned char sector_ok;
static unsigned char* Entry(void) { // rec's entry as it is now (the last sector read is kept); 0 if unreadable
  UVal s = *(UVal*)rec;
  if (!sector_ok || s != sector_at) {
    if (ModSector(s, ASM_SECTOR_BLOCK)) return 0;
    sector_at = s;
    sector_ok = 1;
  }
  Window(ASM_SECTOR_BLOCK);
  return WINDOW + (*(unsigned int*)(rec + 4) & 511);
}
// an entry's time and date (little-endian: the date the high half), later is more; 0 without a clock
static UVal When(const unsigned char* e) {
  UVal t = *(const UVal*)(e + 22);
  return t == (UVal)NO_CLOCK_DATE << 16 ? 0 : t;
}
// the file record at at still has its entry: name and attributes, cluster, time, date, size
static unsigned char Same(UVal at) {
  unsigned char* e;
  unsigned char i;
  Old(at, rec, FILE_RECORD);
  if (!When(rec + 6) || !(e = Entry())) return 0; // no clock wrote it
  for (i = 0; i < 32; ++i) if ((i < 12 || i >= 20) && e[i] != rec[6 + i]) return 0;
  return 1;
}
// the file ModLoad just read: its entry's sector and place into rec
#ifdef HOST_TEST
extern void HostLastEntry(unsigned char* rec); // tests/asm_host.c
static void LastEntry(void) { HostLastEntry(rec); }
#else
static void LastEntry(void) {
  FIL* f = (FIL*)(unsigned int)ModStat(MODULE_STAT_FILE);
  FATFS* fs = (FATFS*)(unsigned int)ModStat(MODULE_STAT_FS);
  *(UVal*)rec = f->dir_sect;
  *(unsigned int*)(rec + 4) = (unsigned int)(f->dir_ptr - fs->win);
}
#endif
static UVal built; // build.obj's time
static ModuleLoad load;
// the ROM is the last build's: there, its size, and written (by the clock) no earlier than build.obj
static unsigned char Current(AsmContext* c) {
  unsigned int blocks;
  unsigned char* e;
  Old(OFS(output), c->name, sizeof(c->name));
  Old(OFS(rom_blocks), &blocks, 2);
  load.block = ASM_SECTOR_BLOCK; // nothing read: only its entry
  load.blocks = 0;
  if (!built || ModLoad(c->name, &load) == 1 || load.size != (UVal)blocks << 9) return 0;
  LastEntry();
  if (!(e = Entry()) || When(e) < built) return 0;
  c->blocks = blocks;
  return 1;
}
static const char log_text[] = " from " ASM_PROJECT_FILE "\nup to date: nothing changed since it was built\n";
static void Log(AsmContext* c) { // build.log
  unsigned int n = 0;
  const char* s;
  Window(ASM_LOG_BLOCK);
  for (s = c->name; *s; ++s) WINDOW[n++] = *s;
  for (s = log_text; *s; ++s) WINDOW[n++] = *s;
  c->log_bytes = n | 0x8000;
}
static unsigned char SameList(UVal at, unsigned char n) { // n file records from at
  unsigned char len;
  for (; n; --n) {
    if (!Same(at)) return 0;
    Old(at + FILE_RECORD, &len, 1);
    at += FILE_RECORD + 1 + len;
  }
  return 1;
}

// A project's C units (notes/COMPILER.md): a main file _name.asm with name.c beside it is CC's
// output. The first one from unit c->symbols on that's missing or older than its .c (or either was
// written without a clock) is the host's to compile: its .c in c->name, its index in c->symbols and
// ASM_COMPILE. project.gbp is read at ASM_IMAGE_BLOCK (free until ASM.MOD), its main lines only.
static UVal proj_at, proj_size;
static unsigned char Byte(void) { // project.gbp's next byte, 0 at its end
  if (proj_at >= proj_size) return 0;
  Window(ASM_IMAGE_BLOCK + (unsigned int)(proj_at >> 9));
  return WINDOW[(unsigned int)proj_at++ & 511];
}
static char word[80];
static unsigned char Word(unsigned char* c) { // the line's next word into word (from c, the byte after it in c), its length
  unsigned char n = 0, ch = *c;
  while (ch == ' ' || ch == '\t' || ch == '\r') ch = Byte();
  if (ch == '"') ch = Byte();
  while (ch && ch != ' ' && ch != '\t' && ch != '\r' && ch != '\n' && ch != ';' && ch != '"') {
    if (n < sizeof(word) - 5) word[n++] = ch;
    ch = Byte();
  }
  if (ch == '"') ch = Byte();
  word[n] = 0;
  *c = ch;
  return n;
}
// word (n characters, its name at base) is _name.asm (one test at a time: SDCC 4.2 has lost values
// computing several up front, notes/MODULES.md)
static unsigned char Generated(unsigned char n, unsigned char base) {
  if (word[base] != '_') return 0;
  if (n < base + 6) return 0;
  if (word[n - 4] != '.') return 0;
  if ((word[n - 3] | 0x20) != 'a') return 0;
  if ((word[n - 2] | 0x20) != 's') return 0;
  return (word[n - 1] | 0x20) == 'm';
}
static UVal Stamp(const char* path) { // a file's time and date, 0 without a clock, 1 if it isn't there
  load.block = ASM_SECTOR_BLOCK;
  load.blocks = 0; // its entry only
  if (ModLoad(path, &load) == 1) return 1;
  LastEntry();
  sector_ok = 0;
  return (path = (const char*)Entry()) != 0 ? When((const unsigned char*)path) : 0;
}
static unsigned char Stale(AsmContext* c) {
  unsigned char ch, n, base, i, unit = 0, main;
  UVal made, src;
  load.block = ASM_IMAGE_BLOCK;
  load.blocks = 16;
  if (ModLoad(proj_name, &load)) return 0; // none (or too big to be a list of files)
  proj_at = 0;
  proj_size = load.size;
  ch = Byte();
  while (ch) {
    main = 0;
    if (Word(&ch) == 4) {
      for (i = 0; i < 4; ++i) word[i] |= 0x20;
      main = word[0] == 'm' && word[1] == 'a' && word[2] == 'i' && word[3] == 'n';
    }
    while (main) {
      n = Word(&ch);
      if (!n) break;
      for (base = i = 0; i < n; ++i) if (word[i] == '/') base = i + 1;
      ++unit;
      if (unit <= c->symbols) continue;
      if (!Generated(n, base)) continue;
      made = Stamp(word);
      for (i = base; i < n - 5; ++i) word[i] = word[i + 1]; // dir/_name.asm -> dir/name.c
      word[i] = '.'; word[i + 1] = 'c'; word[i + 2] = 0;
      src = Stamp(word);
      if (src == 1) continue; // no .c beside it: an ordinary unit
      if (made <= 1 || !src || made < src) { // missing, older, or a time without a clock
        for (i = 0; (c->name[i] = word[i]) != 0; ++i);
        c->symbols = unit - 1;
        c->kind |= ASM_COMPILE;
        return 1;
      }
    }
    while (ch && ch != '\n') ch = Byte(); // the rest of the line (comments, other keywords)
    if (ch) ch = Byte();
  }
  return 0;
}

// ASM_CHECK, after a build that stopped (BUILD runs this again after LINK.MOD wrote build.log):
// each file in ASM.MOD's files table (still in PSRAM) is read from the card again, into the ROM
// image's blocks, and compared with the copy it assembled, twice. build.log gets a line for each
// one that differs and a count. Hardware PSRAM copies have read back wrong (notes/MODULES.md):
// this tells a damaged copy (the same bytes differ twice) or a bad read (not the same ones) from
// an assembler bug (nothing differs).
#define CHECK_FILES 128 // at most: an error late in a big project doesn't wait minutes
#define ENTRY_KIND_INCLUDE 4 // asm_shared.h's SYM_INCLUDE: a file read whole into PSRAM
static unsigned int log_n;
static void Put(char ch) {
  if (log_n >= 1024) return; // ASM_LOG_BLOCK's 2 blocks
  Window(ASM_LOG_BLOCK + (log_n >> 9));
  WINDOW[log_n & 511] = ch;
  ++log_n;
}
static void PutText(const char* s) { while (*s) Put(*s++); }
static const unsigned int tens[] = {10000, 1000, 100, 10, 1};
static void PutNumber(unsigned int v) { // no SDCC helpers in a module: no / or %
  unsigned char i, d, any = 0;
  for (i = 0; i < 5; ++i) {
    for (d = '0'; v >= tens[i]; v -= tens[i]) ++d;
    if (d != '0' || any || i == 4) { Put(d); any = 1; }
  }
}
static const char hex[] = "0123456789abcdef";
static void PutHex(unsigned char b) { Put(hex[b >> 4]); Put(hex[b & 15]); }
static unsigned char chunk[64];
static UVal diff_at;
static unsigned int diff_line;
static unsigned char diff_copy, diff_card;
// the bytes of the copy at block that aren't the card's (at ASM_IMAGE_BLOCK), the first's place in diff_*
static unsigned int Differ(unsigned int block, UVal size) {
  UVal at = 0;
  unsigned int n = 0, line = 1, o;
  unsigned char i, k, ch;
  while (at < size) {
    k = size - at < 64 ? (unsigned char)(size - at) : 64; // 64s never cross a block
    o = (unsigned int)at & 511;
    Window(block + (unsigned int)(at >> 9));
    for (i = 0; i < k; ++i) chunk[i] = WINDOW[o + i];
    Window(ASM_IMAGE_BLOCK + (unsigned int)(at >> 9));
    for (i = 0; i < k; ++i) {
      ch = WINDOW[o + i];
      if (ch != chunk[i]) {
        if (!n) {
          diff_at = at + i;
          diff_line = line;
          diff_copy = chunk[i];
          diff_card = ch;
        }
        if (n != 0xFFFF) ++n;
      }
      if (chunk[i] == 10) ++line;
    }
    at += k;
  }
  return n;
}
static char check_path[80];
static void Check(AsmContext* c) {
  unsigned int u, next, block, files = 0, bad = 0, steps = 0, a, b;
  UVal size;
  unsigned char h = 0, i, n, kind, *e;
  log_n = c->log_bytes & 0x7FFF;
  PutText("card check:");
  do {
    Window(ASM_SYMBOL_BLOCK + 1); // the files table's heads
    u = ((unsigned int*)WINDOW)[h];
    while (u >= FILE_UNITS && files < CHECK_FILES && ++steps < 4096) {
      Window(ASM_SYMBOL_BLOCK + (u >> 6));
      e = WINDOW + ((u & 63) << 3);
      next = e[0] | e[1] << 8;
      block = e[4] | e[5] << 8;
      kind = e[6];
      size = (unsigned int)(e[8] | e[9] << 8) | (UVal)e[7] << 16; // unsigned: 32 KB and up mustn't sign-extend
      n = e[10];
      u = next;
      if (kind != ENTRY_KIND_INCLUDE || n >= sizeof(check_path) - 1) continue; // only its end: not found again
      for (i = 0; i < n; ++i) check_path[i] = e[11 + i];
      check_path[n] = 0;
      ++files;
      load.block = ASM_IMAGE_BLOCK;
      load.blocks = ASM_IMAGE_BLOCKS;
      if (ModLoad(check_path, &load) || load.size != size) {
        ++bad;
        PutText("\n  ");
        PutText(check_path);
        PutText(": not read again the same size");
        continue;
      }
      a = Differ(block, size);
      b = Differ(block, size);
      if (!a && !b) continue;
      ++bad;
      PutText("\n  ");
      PutText(check_path);
      PutText(": ");
      PutNumber(a);
      PutText(" bytes differ, then ");
      PutNumber(b);
      PutText(", first at $");
      PutHex((unsigned char)(diff_at >> 16));
      PutHex((unsigned char)(diff_at >> 8));
      PutHex((unsigned char)diff_at);
      PutText(" line ");
      PutNumber(diff_line);
      PutText(": ");
      PutHex(diff_copy);
      PutText(", card ");
      PutHex(diff_card);
    }
  } while (++h);
  PutText("\n  ");
  PutNumber(files);
  PutText(" files read again from the card, ");
  PutNumber(bad);
  PutText(" differ\n");
  c->log_bytes = log_n | 0x8000;
}

unsigned char ModuleMain(AsmContext* c) {
  BuildUnit u;
  AsmPrep prep;
  UVal magic, at;
  unsigned char version, units, i, n, *w, loaded;
  context = c;
  if (c->kind & ASM_CHECK) {
    if (c->log_bytes) Check(c);
    return 0;
  }
  if (Stale(c)) return 0;
  for (w = (unsigned char*)&prep, i = 0; i < sizeof(AsmPrep); ++i) *w++ = 0;
  load.block = ASM_OLD_BLOCK;
  load.blocks = BUILD_HEAD_BLOCKS; // the head and lists first: all an up-to-date build needs
  loaded = ModLoad(build_obj, &load);
  if (loaded != 1 && load.size >= BUILD_HEAD_BLOCKS * 512UL) {
    LastEntry();
    sector_ok = 0;
    built = (w = Entry()) ? When(w) : 0;
    Old(OFS(magic), &magic, 4);
    Old(OFS(version), &version, 1);
    Old(OFS(units), &units, 1);
    Old(OFS(prelude), &at, 4);
    Old(OFS(prelude_n), &n, 1);
    sector_ok = 0;
    if (magic == OBJ_MAGIC && version == OBJ_VERSION && units <= 63 &&
        Same(OFS(project)) && SameList(at, n)) { // project.gbp and the prelude unchanged
      prep.valid = prep.all_clean = 1;
      for (i = 0; i < units; ++i) {
        Old(OFS(unit) + (unsigned int)i * sizeof(BuildUnit), &u, sizeof(BuildUnit));
        if (!SameList(u.files, u.files_n)) { prep.all_clean = 0; continue; }
        prep.clean[i >> 3] |= 1 << (i & 7);
        Window(ASM_PREP_BLOCK + 1); // its sections, which ASM.MOD numbers
        ((unsigned int*)WINDOW)[i] = u.n;
      }
      if (prep.all_clean && Current(c)) {
        c->kind |= ASM_CURRENT | ASM_PROJECT;
        Log(c);
        return 0;
      }
      load.block = ASM_OLD_BLOCK; // the rest, for LINK.MOD
      load.blocks = ASM_FILE_END - ASM_OLD_BLOCK;
      if (loaded == 2 && ModLoad(build_obj, &load)) prep.valid = prep.all_clean = 0;
      else c->kind |= ASM_OLD;
    }
  }
  Window(ASM_PREP_BLOCK);
  for (w = (unsigned char*)&prep, i = 0; i < sizeof(AsmPrep); ++i) WINDOW[i] = *w++;
  return 0;
}
