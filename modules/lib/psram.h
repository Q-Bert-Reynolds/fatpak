#ifndef FATPAK_MODULE_PSRAM_H
#define FATPAK_MODULE_PSRAM_H
// The 512-byte PSRAM window for modules. RunModule puts the block back afterwards.
// HOST_TEST (tests/asm_host.c) replaces the hardware with an array.
#ifdef HOST_TEST
extern unsigned char* psram_window;
extern void psram_select(unsigned int block);
#define Window(block) psram_select(block)
#define WINDOW psram_window
#else
#define Window(block) (*(volatile unsigned int*)0xBD02 = (block))
#define WINDOW ((unsigned char*)0xBE00)
#endif
#endif
