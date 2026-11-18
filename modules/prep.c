// PREP.MOD: before ASM.MOD (editor/build.c runs it first), which units the last build.obj
// (asm_obj.h) has unchanged: it loads it at ASM_OLD_BLOCK and reads the directory entry of
// project.gbp and of every file it lists (ModSector, one sector at a time). A unit whose files
// all read the same is clean (AsmPrep at ASM_PREP_BLOCK, ASM_OLD in the context); one written
// without a clock (2026-01-01 00:00) never is. With all of them clean and the ROM as the last
// build left it, the build is up to date (ASM_CURRENT): only build.obj's head and lists are read.
// One page, so a build without a project pays little.
#include "link.h"
#ifndef HOST_TEST
#include "../src/fatfs/lib/ff.h" // FATFS, FIL: the host's, read through ModStat's pointers
#endif

AsmContext* context;
#define NO_CLOCK_DATE 0x5C21 // 2026-01-01, what the host writes without a clock (rtc.c)
#define OFS(field) __builtin_offsetof(BuildHead, field)
static const char build_obj[] = "build.obj";

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

unsigned char ModuleMain(AsmContext* c) {
  BuildUnit u;
  AsmPrep prep;
  UVal magic, at;
  unsigned char version, units, i, n, *w, loaded;
  context = c;
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
