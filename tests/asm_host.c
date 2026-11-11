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

int main(int argc, char** argv) {
  FILE* f = fopen(argv[1], "rb");
  AsmContext c = {0};
  unsigned char status;
  if (!f) return 2;
  fseek(f, 0, SEEK_END); source_len = ftell(f); fseek(f, 0, SEEK_SET);
  source = malloc(source_len + 1);
  fread(source, 1, source_len, f); fclose(f);
  status = ModuleMain(&c);
  printf("%u %u %u %u %u\n", status, c.line, c.pos, c.blocks, c.symbols);
  if (!status && argc > 2) {
    f = fopen(argv[2], "wb");
    fwrite(psram + 0x0400ul * 512, 512, c.blocks, f);
    fclose(f);
  }
  return 0;
}
