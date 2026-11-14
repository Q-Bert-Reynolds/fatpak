// Runs modules/asm.c on a PC: tests/test_asm.py compares its ROM with RGBDS's.
// usage: asm_host source.asm image.gb  (prints "status line pos blocks symbols")
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#define int short // the module is built with 16-bit ints, like SDCC
#include "../modules/asm.h"
#include "../src/constants.h"
#undef int

static unsigned char psram[16 << 20];
unsigned char* psram_window;
void psram_select(unsigned int block) { psram_window = psram + (unsigned long)block * 512; }

static unsigned char* source;
static unsigned long source_len;
unsigned char ModSource(unsigned short pos, char* dest) {
  unsigned long n = pos < source_len ? source_len - pos : 0;
  if (n > 128) n = 128;
  memcpy(dest, source + pos, n);
  return (unsigned char)n;
}
unsigned char ModuleMain(AsmContext* c);

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
  if (size >= 0x1000000 || (size + 511) / 512 > load->blocks) { fclose(f); return 2; }
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
  if (!getenv("ASM_PROGRESS")) return;
  if (text) fprintf(stderr, "%s\n", text);
  else fprintf(stderr, "Pass %d: %d%s|%s|line %d\n", c->pass, c->progress, c->pass == 1 ? "k lines" : "%",
               c->file ? c->name : "(the document)", c->line);
}
static int first_level = -1; // the folder that found the first file (project.gbp's): searched first, like the OS
unsigned long ModStat(unsigned char which) { (void)which; return 0; } // no clock here: build.log's times are 0:00
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
  if (!result && first_level < 0) first_level = n;
  if (result == 1 && base) result = Load(base + 1, end, load);
  if (getenv("ASM_HOST_FILES")) fprintf(stderr, "%u %s (%lu bytes at block %u)\n", ++files, path, load->size, load->block);
  return result;
}

int main(int argc, char** argv) {
  FILE* f = fopen(argv[1], "rb");
  AsmContext c = {0};
  unsigned char status;
  if (!f) return 2;
  { const char* slash = strrchr(argv[1], '/'); if (slash) snprintf(source_dir, sizeof(source_dir), "%.*s", (int)(slash - argv[1] + 1), argv[1]); }
  fseek(f, 0, SEEK_END); source_len = ftell(f); fseek(f, 0, SEEK_SET);
  c.length = (unsigned short)source_len;
  c.kind = strstr(argv[1], ".asm") || strstr(argv[1], ".inc") ? ASM_DOC : 0;
  source = malloc(source_len + 1);
  fread(source, 1, source_len, f); fclose(f);
  progress_context = &c;
  status = ModuleMain(&c);
  printf("%u %u %u %u %u %u %s\n", status, c.line, c.pos, c.blocks, c.symbols, c.file,
         c.kind & ASM_PROJECT && !status ? c.name : c.file ? c.name + c.base : "");
  if (getenv("ASM_LOG")) fwrite(psram + (unsigned long)ASM_LOG_BLOCK * 512, 1, c.log_bytes, stderr); // build.log
  if (!status && argc > 2) {
    f = fopen(argv[2], "wb");
    fwrite(psram + 0x0400ul * 512, 512, c.blocks, f);
    fclose(f);
  }
  return 0;
}
