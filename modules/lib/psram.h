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
// high byte first, then low, like the stock OS: the low byte write is what switches the window
#define Window(block) (*(volatile unsigned char*)0xBD03 = (unsigned char)((block) >> 8), *(volatile unsigned char*)0xBD02 = (unsigned char)(block))
#define WINDOW ((unsigned char*)0xBE00)
#endif
#endif
