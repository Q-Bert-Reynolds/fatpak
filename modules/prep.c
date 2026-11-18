// PREP.MOD: before ASM.MOD (editor/build.c runs it first), which units the last build.obj
// (asm_obj.h) has unchanged: it loads it at ASM_OLD_BLOCK and reads the directory entry of
// project.gbp and of every file it lists (ModSector, one sector at a time). A unit whose files
// all read the same is clean (AsmPrep at ASM_PREP_BLOCK, ASM_OLD in the context); one written
// without a clock (2026-01-01 00:00) never is. One page, so a build without a project pays little.
#include "link.h"

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
// the file record at at still has its entry: name and attributes, cluster, time, date, size
static unsigned char Same(UVal at) {
  unsigned char* e;
  unsigned char i;
  UVal s;
  Old(at, rec, FILE_RECORD);
  if (rec[6 + 22] == 0 && rec[6 + 23] == 0 && rec[6 + 24] == (NO_CLOCK_DATE & 255) && rec[6 + 25] == NO_CLOCK_DATE >> 8) return 0; // no clock wrote it
  s = *(UVal*)rec;
  if (!sector_ok || s != sector_at) {
    if (ModSector(s, ASM_SECTOR_BLOCK)) return 0;
    sector_at = s;
    sector_ok = 1;
  }
  Window(ASM_SECTOR_BLOCK);
  e = WINDOW + (*(unsigned int*)(rec + 4) & 511);
  for (i = 0; i < 32; ++i) if ((i < 12 || i >= 20) && e[i] != rec[6 + i]) return 0;
  return 1;
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
  ModuleLoad load;
  BuildUnit u;
  AsmPrep prep;
  UVal magic, at;
  unsigned char version, units, i, n, *w;
  context = c;
  for (w = (unsigned char*)&prep, i = 0; i < sizeof(AsmPrep); ++i) *w++ = 0;
  load.block = ASM_OLD_BLOCK;
  load.blocks = ASM_FILE_END - ASM_OLD_BLOCK;
  if (!ModLoad(build_obj, &load)) {
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
      c->kind |= ASM_OLD;
    }
  }
  Window(ASM_PREP_BLOCK);
  for (w = (unsigned char*)&prep, i = 0; i < sizeof(AsmPrep); ++i) WINDOW[i] = *w++;
  return 0;
}
