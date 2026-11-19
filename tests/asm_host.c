#define _XOPEN_SOURCE 700 // nftw
// Runs modules/assembler/asm.c on a PC: tests/test_asm.py compares its ROM with RGBDS's.
// usage: asm_host source.asm image.gb  (prints "status line pos blocks symbols")
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#include <time.h>
#include <ftw.h>
#define int short // the module is built with 16-bit ints, like SDCC
#include "../modules/assembler/asm.h"
#include "../src/constants.h"
#undef int

static unsigned char psram[16 << 20];
unsigned char* psram_window;
extern unsigned long psram_selects; unsigned long psram_selects; // ASM_HOST_STATS: window moves, a proxy for the device's time
void psram_select(unsigned int block) { psram_window = psram + (unsigned long)block * 512; ++psram_selects; }

static char loaded[4096][512]; // files seen, and their inodes: a made-up entry's "sector"
static unsigned long loaded_ino[4096];
static unsigned loaded_n, last_loaded;
static unsigned Known(const char* path) { // its number, from 1
  struct stat st;
  unsigned i;
  for (i = 0; i < loaded_n; ++i) if (!strcmp(loaded[i], path)) return i + 1;
  if (loaded_n == 4096 || stat(path, &st)) return 0;
  snprintf(loaded[loaded_n], sizeof(loaded[0]), "%s", path);
  loaded_ino[loaded_n] = st.st_ino;
  return ++loaded_n;
}
static int Seen(const char* path, const struct stat* st, int type, struct FTW* w) { (void)st; (void)w; if (type == FTW_F) Known(path); return 0; }
static unsigned char* source;
static unsigned long source_len;
unsigned char ModSource(unsigned short pos, char* dest) {
  unsigned long n = pos < source_len ? source_len - pos : 0;
  if (n > 128) n = 128;
  memcpy(dest, source + pos, n);
  return (unsigned char)n;
}
unsigned char ModuleMain(AsmContext* c);
unsigned char LinkMain(AsmContext* c); // LINK.MOD's ModuleMain (modules/assembler/link.c)
unsigned char PrepMain(AsmContext* c); // PREP.MOD's (modules/assembler/prep.c)

static char source_dir[1024];
typedef struct { unsigned short block, blocks; unsigned long size; } ModuleLoad; // sdk.h's, with 16-bit ints
static unsigned char Load(const char* name, unsigned n, ModuleLoad* load) { // the first n characters of source_dir, then name
  char full[2048]; FILE* f; long size; unsigned char* at = psram + (unsigned long)load->block * 512;
  const char* part;
  for (part = name; *part; ) { // FatFs has no relative names (FF_FS_RPATH 0): "." and ".." aren't found
    if (part[0] == '.' && (!part[1] || part[1] == '/' || (part[1] == '.' && (!part[2] || part[2] == '/')))) return 1;
    while (*part && *part != '/') ++part;
    while (*part == '/') ++part;
  }
  snprintf(full, sizeof(full), "%.*s%s", (int)n, source_dir, name);
  f = fopen(full, "rb");
  if (!f) return 1;
  fseek(f, 0, SEEK_END); size = ftell(f); fseek(f, 0, SEEK_SET);
  load->size = size;
  last_loaded = Known(full);
  if (size >= 0x1000000 || (size + 511) / 512 > load->blocks) { // its first blocks, like the OS
    if (fread(at, 1, (size_t)load->blocks * 512, f)) {}
    fclose(f);
    return 2;
  }
  if (fread(at, 1, size, f) != (size_t)size) size = 0;
  fclose(f);
  return 0;
}
static unsigned files;
// like the OS (src/modules/runtime.c): from the source's folder, then each folder above it,
// then the base name in the source's folder
static AsmContext* progress_context;
void ModProgress(const char* text) { // ASM_PROGRESS=1 prints each one, as build.c's BuildProgress would
  AsmContext* c = progress_context;
  if (getenv("ASM_HOST_STATS") && c->pass >= 3 && c->pass <= 4) fprintf(stderr, "phase %d at %lu window moves\n", c->pass, psram_selects);
  if (!getenv("ASM_PROGRESS")) return;
  if (text) fprintf(stderr, "%s\n", text);
  else fprintf(stderr, "Pass %d: %d%s|%s|line %d\n", c->pass, c->progress, c->pass == 1 ? "k lines" : "%",
               c->file ? c->name : "(the document)", c->line);
}
static int first_level = -1; // the folder that found the first file (project.gbp's): searched first, like the OS
unsigned long ModStat(unsigned char which) { (void)which; return 0; } // no clock here: build.log's times are 0:00; no FAT volume: no build.cache
// directory entries made up for build.obj: a file's "sector" is its number here, its entry at 0 in
// it, with the file's size and modification time as FatFs would write them
void HostLastEntry(unsigned char* rec) { // the inode as the sector, the entry at 0
  unsigned long ino = last_loaded ? loaded_ino[last_loaded - 1] : 0;
  rec[0] = ino; rec[1] = ino >> 8; rec[2] = ino >> 16; rec[3] = ino >> 24;
  rec[4] = rec[5] = 0;
}
unsigned char ModSector(unsigned long sector, unsigned short block) {
  unsigned char* e = psram + (unsigned long)block * 512;
  struct stat st; struct tm* t; unsigned time_, date;
  unsigned i;
  char root[2048];
  for (i = 0; i < loaded_n && (loaded_ino[i] & 0xFFFFFFFFul) != sector; ++i);
  if (i == loaded_n && first_level >= 0) { // every file in the project's folder, by inode
    snprintf(root, sizeof(root), "%.*s.", first_level, source_dir);
    nftw(root, Seen, 16, FTW_PHYS);
    for (i = 0; i < loaded_n && (loaded_ino[i] & 0xFFFFFFFFul) != sector; ++i);
  }
  if (i == loaded_n || stat(loaded[i], &st)) return 1;
  memset(e, 0, 512); memset(e, ' ', 11); e[11] = 0x20;
  sprintf((char*)e, "%09ld", (long)st.st_mtim.tv_nsec); e[9] = ' '; // the name: below FAT's 2 s, for tests that rewrite a file quickly
  t = localtime(&st.st_mtime);
  time_ = t->tm_hour << 11 | t->tm_min << 5 | t->tm_sec / 2; date = (t->tm_year - 80) << 9 | (t->tm_mon + 1) << 5 | t->tm_mday;
  e[22] = time_; e[23] = time_ >> 8; e[24] = date; e[25] = date >> 8;
  e[26] = (unsigned char)sector; e[27] = (unsigned char)(sector >> 8);
  e[28] = st.st_size; e[29] = st.st_size >> 8; e[30] = st.st_size >> 16; e[31] = st.st_size >> 24;
  return 0;
}
char* ModString(char* dest, unsigned short id) { return dest + sprintf(dest, "error %u", id); }
unsigned char ModLoad(const char* path, ModuleLoad* load) {
  unsigned n = strlen(source_dir), end = n;
  unsigned char result = 1;
  const char* base = strrchr(path, '/');
  if (first_level >= 0) result = Load(path, first_level, load);
  while (result == 1 && (result = Load(path, n, load)) == 1 && n) {
    --n; // past the folder's own slash, to the one before it
    while (n && source_dir[n - 1] != '/') --n;
  }
  if (result != 1 && first_level < 0) first_level = n; // (too big too: PREP.MOD reads build.obj's head)
  if (result == 1 && base) result = Load(base + 1, end, load);
  if (getenv("ASM_HOST_FILES")) fprintf(stderr, "%u %s (%lu bytes at block %u)\n", ++files, path, load->size, load->block);
  return result;
}

int main(int argc, char** argv) {
  FILE* f = fopen(argv[1], "rb");
  AsmContext c = {0};
  unsigned char status;
  int level;
  if (!f) return 2;
  { const char* slash = strrchr(argv[1], '/'); if (slash) snprintf(source_dir, sizeof(source_dir), "%.*s", (int)(slash - argv[1] + 1), argv[1]); }
  if (getenv("ASM_HOST_DIR")) snprintf(source_dir, sizeof(source_dir), "%s/", getenv("ASM_HOST_DIR")); // the document's folder (MAPVIEW's map's)
  fseek(f, 0, SEEK_END); source_len = ftell(f); fseek(f, 0, SEEK_SET);
  c.length = (unsigned short)source_len;
  c.kind = strstr(argv[1], ".asm") || strstr(argv[1], ".inc") ? ASM_DOC : 0;
  source = malloc(source_len + 1);
  fread(source, 1, source_len, f); fclose(f);
  progress_context = &c;
  if (getenv("ASM_HOST_TEXT")) { // MAPVIEW.MOD's way: the source in PSRAM (ASM_TEXT), names nothing defines as 0
    memcpy(psram + 0x0200ul * 512, source, source_len);
    c.kind = ASM_DOC | ASM_TEXT | ASM_LOOSE;
    c.text_block = 0x0200;
    c.text_length = c.length;
    c.length = 0;
  }
  else PrepMain(&c); // PREP.MOD's check of build.obj first, as BUILD runs it
  level = first_level;
  if (c.kind & ASM_CURRENT) { // up to date: the ROM as it is (for the caller's image.gb)
    char full[2048]; FILE* o;
    snprintf(full, sizeof(full), "%.*s%s", level, source_dir, c.name);
    if ((o = fopen(full, "rb"))) { if (fread(psram + 0x0400ul * 512, 512, c.blocks, o)) {} fclose(o); }
    status = 0;
  }
  else {
    first_level = -1; // (each module run searches afresh)
    status = ModuleMain(&c);
    if (getenv("ASM_HOST_STATS")) fprintf(stderr, "ASM.MOD: %lu window moves\n", psram_selects);
    psram_selects = 0;
    if (status != ASM_NOT_ASM) status = LinkMain(&c); // as editor/build.c runs them
    level = first_level;
  }
  if (!status && c.obj_blocks && level >= 0) { // build.obj beside project.gbp, as WriteOutputs writes it
    char full[2048]; FILE* o;
    snprintf(full, sizeof(full), "%.*sbuild.obj", level, source_dir);
    if ((o = fopen(full, "wb"))) { fwrite(psram + (unsigned long)ASM_BUILD_BLOCK * 512, 512, c.obj_blocks & 0x1FFF, o); fclose(o); }
  }
  if (!status && (c.kind & ASM_PROJECT) && !(c.kind & ASM_CURRENT) && level >= 0 && !getenv("ASM_NO_ROM")) { // then the ROM, as BuildFile writes it
    char full[2048]; FILE* o;
    snprintf(full, sizeof(full), "%.*s%s", level, source_dir, c.name);
    if ((o = fopen(full, "wb"))) { fwrite(psram + 0x0400ul * 512, 512, c.blocks, o); fclose(o); }
  }
  if (getenv("ASM_HOST_STATS")) fprintf(stderr, "LINK.MOD: %lu window moves\n", psram_selects);
  printf("%u %u %u %u %u %u %s\n", status, c.line, c.pos, c.blocks, c.symbols, c.file,
         c.kind & ASM_PROJECT && !status ? c.name : c.file ? c.name + c.base : "");
  if (getenv("ASM_HOST_STATS")) { // how full ASM.MOD's PSRAM regions got
    extern unsigned short data_top, file_top, sym_mark, next_unit, out_block;
    fprintf(stderr, "units from build.obj: %s, obj_blocks %x\n", c.kind & ASM_OLD ? "yes" : "no", c.obj_blocks);
    fprintf(stderr, "data %u of %u blocks, files %u of %u, prelude names to unit %u (snapshot %u of %u blocks)\n",
            data_top - ASM_DATA_BLOCK, ASM_DATA_END - ASM_DATA_BLOCK, file_top - ASM_FILE_BLOCK, ASM_FILE_END - ASM_FILE_BLOCK,
            sym_mark, 10 + (sym_mark >> 6), ASM_SNAP_END - ASM_SNAP_BLOCK);
    fprintf(stderr, "objects %u of %u blocks\n", out_block - ASM_OBJ_BLOCK, ASM_FILE_BLOCK - ASM_OBJ_BLOCK);
  }
  if (getenv("ASM_LOG")) fwrite(psram + (unsigned long)ASM_LOG_BLOCK * 512, 1, c.log_bytes & 0x7FFF, stderr); // build.log
  if (!status && argc > 2) {
    f = fopen(argv[2], "wb");
    fwrite(psram + 0x0400ul * 512, 512, c.blocks, f);
    fclose(f);
  }
  return 0;
}
