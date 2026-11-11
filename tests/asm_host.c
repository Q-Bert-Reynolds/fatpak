// Runs modules/asm.c on a PC: tests/test_asm.py compares its ROM with RGBDS's.
// usage: asm_host source.asm image.gb  (prints "status line pos blocks symbols")
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#define int short // the module is built with 16-bit ints, like SDCC
#include "../modules/asm.h"
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
static unsigned short Load(const char* name, unsigned short block) {
  char full[2048]; FILE* f; long size; unsigned char* at = psram + (unsigned long)block * 512;
  snprintf(full, sizeof(full), "%s%s", source_dir, name);
  f = fopen(full, "rb");
  if (!f) return 0;
  fseek(f, 0, SEEK_END); size = ftell(f); fseek(f, 0, SEEK_SET);
  if (size >= 0x10000) { fclose(f); return 0xFFFF; }
  if (fread(at, 1, size, f) != (size_t)size) size = 0;
  fclose(f);
  return (unsigned short)size;
}
unsigned short ModFile(const char* path, unsigned short block) {
  unsigned short length = Load(path, block);
  const char* base = strrchr(path, '/');
  if (!length && base) length = Load(base + 1, block);
  return length;
}

int main(int argc, char** argv) {
  FILE* f = fopen(argv[1], "rb");
  AsmContext c = {0};
  unsigned char status;
  if (!f) return 2;
  { const char* slash = strrchr(argv[1], '/'); if (slash) snprintf(source_dir, sizeof(source_dir), "%.*s", (int)(slash - argv[1] + 1), argv[1]); }
  fseek(f, 0, SEEK_END); source_len = ftell(f); fseek(f, 0, SEEK_SET);
  c.length = (unsigned short)source_len;
  source = malloc(source_len + 1);
  fread(source, 1, source_len, f); fclose(f);
  status = ModuleMain(&c);
  printf("%u %u %u %u %u %u\n", status, c.line, c.pos, c.blocks, c.symbols, c.file);
  if (!status && argc > 2) {
    f = fopen(argv[2], "wb");
    fwrite(psram + 0x0400ul * 512, 512, c.blocks, f);
    fclose(f);
  }
  return 0;
}
