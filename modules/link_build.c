// LINK.MOD: build.obj (asm_obj.h). Before ASM.MOD, PREP.MOD (prep.c) loads the last one and checks
// the directory entries of every file it lists: a unit whose files are all unchanged isn't
// assembled. After ASM.MOD, Restore copies those units' sections and data where it numbered them,
// Walk reads their objects in it, and once the link worked Compose puts the new build.obj
// together over the files.
#include "link.h"
#ifndef HOST_TEST
#include "../src/fatfs/lib/ff.h" // FATFS, FIL: the host's, read through ModStat's pointers
#endif

#define CACHE_HEAD 14 // build.cache's index (asm_cache.h): a head, then per file its path and 17 bytes

static const char project[] = ASM_PROJECT_FILE;
#define OFS(field) __builtin_offsetof(BuildHead, field) // (gcc and SDCC; stddef.h breaks the PC's -Dint=short)

// the stream at block base and ofs bytes after it
static void At(unsigned int base, UVal ofs) {
  in_block = base + (unsigned int)(ofs >> 9);
  in_ofs = (unsigned int)ofs & 511;
}
static unsigned char rec[FILE_RECORD]; // a file's record: sector, place, entry

// --- writing, at out_block and out_ofs
static unsigned int out_block, out_ofs;
static void Write(const unsigned char* p, unsigned char n) {
  unsigned int left;
  while (n) {
    left = 512 - out_ofs;
    copy_n = n < left ? n : (unsigned char)left;
    Window(out_block);
    Copy(WINDOW + out_ofs, p);
    p += copy_n;
    n -= copy_n;
    out_ofs += copy_n;
    if (out_ofs == 512) {
      out_ofs = 0;
      ++out_block;
    }
  }
}
static UVal Written(void) { // bytes from build.obj's start
  return ((UVal)(out_block - ASM_BUILD_BLOCK) << 9) + out_ofs;
}
// the file lists go in the head's blocks, after BuildHead: Lists trades out for their place
static unsigned int list_block, list_ofs;
static void Lists(void) {
  unsigned int t = out_block;
  out_block = list_block;
  list_block = t;
  t = out_ofs;
  out_ofs = list_ofs;
  list_ofs = t;
}
// bytes from the stream to out, through buf
static void Move(UVal n) {
  unsigned char k;
  while (n) {
    k = n > 128 ? 128 : (unsigned char)n;
    Read(buf, k);
    Write(buf, k);
    n -= k;
  }
}

// --- directory entries, read through ModSector (the last sector read is kept)
static UVal sector_at;
static unsigned char sector_ok;
static unsigned char* EntryAt(void) { // rec's entry as it is now; 0 if its sector can't be read
  UVal s = *(UVal*)rec; // 4 bytes (UVal: also on the PC)
  if (!sector_ok || s != sector_at) {
    if (ModSector(s, ASM_SECTOR_BLOCK)) return 0;
    sector_at = s;
    sector_ok = 1;
  }
  Window(ASM_SECTOR_BLOCK);
  return WINDOW + (*(unsigned int*)(rec + 4) & 511);
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

// --- the last build.obj, at ASM_OLD_BLOCK
static void Old(UVal at, void* p, unsigned char n) {
  At(ASM_OLD_BLOCK, at);
  Read((unsigned char*)p, n);
}
#define OLD_HEAD(field, p) Old(OFS(field), p, sizeof(((BuildHead*)0)->field))
static void OldUnit(unsigned char u, BuildUnit* p) {
  Old(OFS(unit) + (unsigned int)u * sizeof(BuildUnit), p, sizeof(BuildUnit));
}
static UVal Next(UVal at) { // past the file record at at
  unsigned char n;
  Old(at + FILE_RECORD, &n, 1);
  return at + FILE_RECORD + 1 + n;
}
static void OldList(UVal at, unsigned char n) { // n file records from at, to out
  UVal end = at;
  unsigned int b = in_block, o = in_ofs;
  while (n--) end = Next(end);
  At(ASM_OLD_BLOCK, at);
  Move(end - at);
  in_block = b;
  in_ofs = o;
}
unsigned char OldName(unsigned char unit, unsigned int file) {
  BuildUnit u;
  UVal at;
  unsigned char n;
  OldUnit(unit, &u);
  for (at = u.files; --file; at = Next(at));
  Old(at + FILE_RECORD, &n, 1); // the stream is at the path
  return n;
}

static AsmPrep prep;
static unsigned char Kept(unsigned char u) { return (context->kind & ASM_OLD) && (prep.clean[u >> 3] & (1 << (u & 7))); }
// after ASM.MOD: the unchanged units' sections from build.obj where ASM.MOD numbered them (OBJ_KEEP),
// their data blocks after the others; Walk reads their objects there (KeepAt)
void Restore(void) {
  BuildUnit u;
  unsigned int k, first;
  unsigned char i, units;
  Window(ASM_PREP_BLOCK);
  for (i = 0; i < sizeof(AsmPrep); ++i) ((unsigned char*)&prep)[i] = WINDOW[i];
  OLD_HEAD(units, &units);
  for (i = 0; i < units; ++i) {
    if (!Kept(i)) continue;
    OldUnit(i, &u);
    Window(ASM_PREP_BLOCK + 2);
    first = ((unsigned int*)WINDOW)[i];
    for (k = 0; k < u.n; ++k) {
      Old(BUILD_HEAD_BLOCKS * 512UL + (UVal)(u.first + k) * SECT_SIZE, &sec, sizeof(Sect));
      sec.data += link.data_end - u.data; // build.obj's block, now after the data ASM.MOD made
      sec.rank = i; // whose list its file is in (Report)
      SectCopy(first + k, 1);
    }
    At(ASM_OLD_BLOCK + u.data, 0);
    out_block = link.data_end;
    out_ofs = 0;
    Move((UVal)u.data_n << 9);
    link.data_end += u.data_n;
  }
}
// unit u's object in build.obj, past its OBJ_UNIT, for Walk: first, and where it ends
unsigned int kept_end_block, kept_end_ofs;
void KeepAt(unsigned char u) {
  BuildUnit b;
  OldUnit(u, &b);
  At(ASM_OLD_BLOCK, b.obj + b.obj_n);
  kept_end_block = in_block;
  kept_end_ofs = in_ofs;
  Window(ASM_PREP_BLOCK + 2);
  first = ((unsigned int*)WINDOW)[u];
  At(ASM_OLD_BLOCK, b.obj + 5);
}

// the section records before the link (which joins FRAGMENTs and places them), for build.obj
void Snap(void) {
  At(ASM_SECTION_BLOCK, 0);
  out_block = ASM_BUILD_BLOCK + BUILD_HEAD_BLOCKS;
  out_ofs = 0;
  Move((UVal)link.nsects * SECT_SIZE);
}

// --- the new build.obj
static unsigned int list[64]; // the unit's files (their symbols), in the order it read them
static unsigned char list_n;
static unsigned char Listed(unsigned int file) { // file's number in list (from 1), added if new
  unsigned char i;
  for (i = 0; i < list_n; ++i) if (list[i] == file) return i + 1;
  if (list_n == 64) return 0;
  list[list_n] = file;
  return ++list_n;
}
static unsigned char compose_ok;
// the list's files as records at out: each one's entry from build.cache's index (its sector and
// place) and the card
static UVal FileRecords(void) {
  unsigned char i, n, *e;
  unsigned int b = in_block, o = in_ofs;
  UVal start = Written();
  for (i = 0; i < list_n && compose_ok; ++i) {
    name_n = FileName(list[i]);
    Read((unsigned char*)name, name_n);
    if (!Lookup()) { compose_ok = 0; context->obj_blocks = 0x8100 | i; break; } // not through build.cache: no record
    At(ASM_CACHE_BLOCK, found_value);
    Read(rec, 6);
    if (!(e = EntryAt())) { compose_ok = 0; break; }
    for (n = 0; n < 32; ++n) rec[6 + n] = e[n];
    Write(rec, FILE_RECORD);
    Write(&name_n, 1);
    Write((unsigned char*)name, name_n);
  }
  in_block = b;
  in_ofs = o;
  return start;
}
static void HeadPut(unsigned int at, const void* p, unsigned char n) {
  unsigned int b = out_block, o = out_ofs;
  out_block = ASM_BUILD_BLOCK + (at >> 9);
  out_ofs = at & 511;
  Write((const unsigned char*)p, n);
  out_block = b;
  out_ofs = o;
}
static Sect* Snapped(unsigned int i) { // section i's record in build.obj
  Window(ASM_BUILD_BLOCK + BUILD_HEAD_BLOCKS + (i >> 4));
  return (Sect*)(WINDOW + (i & 15) * SECT_SIZE);
}
// the unit's object ends: its file list (as the last build.obj had it, or made from its files),
// its data blocks, its place in the head
static BuildUnit u;
static unsigned char unit, kept;
static void UnitEnd(void) {
  BuildUnit old;
  unsigned int i, b = in_block, o = in_ofs, end;
  Sect* p;
  u.obj_n = Written() - u.obj;
  Lists();
  u.files = Written();
  if (kept) {
    OldUnit(unit, &old);
    u.files_n = old.files_n;
    OldList(old.files, old.files_n);
  }
  else {
    for (i = u.first; i < u.first + u.n; ++i) { // its sections' files too
      p = Snapped(i);
      if (p->file >= FILE_UNITS) p->file = Listed(p->file);
    }
    FileRecords();
    u.files_n = list_n;
  }
  Lists();
  u.data = 0xFFFF; // its data blocks: from the first of its ROM sections' to the end of the last's
  end = 0;
  for (i = u.first; i < u.first + u.n; ++i) {
    p = Snapped(i);
    if (p->type > 1 || !p->size) continue;
    if (p->data < u.data) u.data = p->data;
    if (p->data + (((p->start & 511) + p->size + 511) >> 9) > end) end = p->data + (((p->start & 511) + p->size + 511) >> 9);
  }
  if (u.data == 0xFFFF) u.data = end = 0;
  u.data_n = end - u.data;
  HeadPut(OFS(unit) + unit * sizeof(BuildUnit), &u, sizeof(BuildUnit));
  in_block = b;
  in_ofs = o;
}
// build.obj at ASM_BUILD_BLOCK: the head, section records (Snap left them), data, then each unit's
// object stream (with its files as numbers in its list) and list; context->obj_blocks
void Compose(void) {
  BuildUnit old;
  ModuleLoad load;
  UVal magic = OBJ_MAGIC, at, size;
  unsigned int sect_blocks = (link.nsects * SECT_SIZE + 511) >> 9, data_at, i, v;
  unsigned char kind, units = (unsigned char)link.units, version = OBJ_VERSION, n, started = 0, *e;
  if (!units || !context->cache_blocks) return; // only a project's, with build.cache's index
  if ((context->kind & ASM_OLD) && prep.all_clean) return; // it would be the same: the card keeps it
  compose_ok = 1;
  sector_ok = 0;
  list_block = ASM_BUILD_BLOCK + (sizeof(BuildHead) >> 9);
  list_ofs = sizeof(BuildHead) & 511;
  for (i = 0; i < BUILD_HEAD_BLOCKS; ++i) { // the head, which is written a field at a time
    Window(ASM_BUILD_BLOCK + i);
    Fill(0);
  }
  Names(); // build.cache's index into the names table: a file's path to its record
  At(ASM_CACHE_BLOCK, CACHE_HEAD);
  while (1) {
    Read(&name_n, 1);
    if (!name_n) break;
    Read((unsigned char*)name, name_n);
    Insert(((UVal)(in_block - ASM_CACHE_BLOCK) << 9) + in_ofs, 0);
    Skip(17);
  }
  // project.gbp's record (read again, where ASM.MOD's prelude snapshot was, to find its entry)
  load.block = ASM_SNAP_BLOCK;
  load.blocks = ASM_SNAP_END - ASM_SNAP_BLOCK;
  if (ModLoad(project, &load)) return;
  LastEntry();
  if (!(e = EntryAt())) return;
  for (n = 0; n < 32; ++n) rec[6 + n] = e[n];
  HeadPut(OFS(project), rec, FILE_RECORD);
  // the data (the unchanged units' too: Restore put theirs after), the sections' blocks counted
  // from build.obj's start
  data_at = BUILD_HEAD_BLOCKS + sect_blocks;
  At(ASM_DATA_BLOCK, 0);
  out_block = ASM_BUILD_BLOCK + data_at;
  out_ofs = 0;
  Move((UVal)(link.data_end - ASM_DATA_BLOCK) << 9);
  for (i = 0; i < link.nsects; ++i) Snapped(i)->data += data_at - ASM_DATA_BLOCK;
  // each unit's object, its files as numbers in its list; an unchanged one's from the last build.obj
  At(ASM_OBJ_BLOCK, 0);
  unit = 0;
  list_n = 0;
  while (compose_ok) {
    Read(&kind, 1);
    if (kind == OBJ_UNIT || kind == OBJ_KEEP || kind == OBJ_END) {
      if (!started) { // the prelude's files (or the last build.obj's list, when it didn't run)
        started = 1;
        Lists();
        at = Written();
        n = list_n;
        if (!list_n && (context->kind & ASM_OLD)) {
          v = in_block;
          i = in_ofs;
          OLD_HEAD(prelude, &size);
          OLD_HEAD(prelude_n, &n);
          in_block = v;
          in_ofs = i;
          OldList(size, n);
        }
        else FileRecords();
        Lists();
        HeadPut(OFS(prelude), &at, 4);
        HeadPut(OFS(prelude_n), &n, 1);
      }
      else {
        UnitEnd();
        ++unit;
      }
      if (kind == OBJ_END) break;
      list_n = 0;
      u.obj = Written();
      kept = kind == OBJ_KEEP;
      if (kept) { // its object as it was, from its sections' numbers now
        Read(&n, 1);
        v = in_block;
        i = in_ofs;
        OldUnit(n, &old);
        Window(ASM_PREP_BLOCK + 2);
        u.first = ((unsigned int*)WINDOW)[n];
        u.n = old.n;
        kind = OBJ_UNIT;
        Write(&kind, 1);
        Write((unsigned char*)&u.first, 4);
        At(ASM_OLD_BLOCK, old.obj + 5);
        Move(old.obj_n - 5);
        in_block = v;
        in_ofs = i;
      }
      else {
        Read((unsigned char*)&u.first, 4);
        Write(&kind, 1);
        Write((unsigned char*)&u.first, 4);
      }
      continue;
    }
    Write(&kind, 1);
    if (kind == OBJ_FILE) {
      Read((unsigned char*)&v, 2);
      if (v >= FILE_UNITS) v = Listed(v);
      Write((unsigned char*)&v, 2);
      continue;
    }
    if (kind == OBJ_PATCH) {
      Read(buf, PATCH_HEAD);
      v = buf[5] | (buf[6] << 8);
      if (v >= FILE_UNITS) {
        v = Listed(v);
        buf[5] = (unsigned char)v;
        buf[6] = (unsigned char)(v >> 8);
      }
      Write(buf, PATCH_HEAD);
      Move(buf[11]);
      continue;
    }
    n = kind == OBJ_SECTION ? 3 : 5;
    Read(buf, n);
    Write(buf, n);
    Move(buf[n - 1]);
  }
  size = Written();
  if (!compose_ok || out_block >= ASM_OLD_BLOCK) return; // too big to put together (or a file without a record)
  if (list_block > ASM_BUILD_BLOCK + BUILD_HEAD_BLOCKS || (list_block == ASM_BUILD_BLOCK + BUILD_HEAD_BLOCKS && list_ofs)) return; // the lists didn't fit
  HeadPut(OFS(magic), &magic, 4);
  HeadPut(OFS(version), &version, 1);
  HeadPut(OFS(units), &units, 1);
  HeadPut(OFS(nsects), &link.nsects, 2);
  HeadPut(OFS(data), &data_at, 2);
  HeadPut(OFS(size), &size, 4);
  HeadPut(OFS(rom_blocks), &context->blocks, 2);
  for (n = 0; context->name[n]; ++n);
  HeadPut(OFS(output), context->name, n + 1);
  context->obj_blocks = (out_block - ASM_BUILD_BLOCK + (out_ofs != 0)) | 0x2000;
}
