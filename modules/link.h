#ifndef FATPAK_MODULE_LINK_H
#define FATPAK_MODULE_LINK_H
// LINK.MOD's two pages share these (link.c: placing, the image, header and log; link_obj.c:
// reading the objects, names and patches). Calls between them go through ModFar thunks.
#include "../build/modules/sdk.h"
#include "asm.h"
#include "asm_obj.h"
#include "lib/psram.h"

// link.c
extern AsmContext* context;
extern AsmLink link; // ASM.MOD's
extern unsigned char error, max_bank;
extern Sect sec, other;
void Fail(unsigned char code);
void FailAt(unsigned char code, unsigned int file, unsigned int line, unsigned int pos);
void SectFail(unsigned char code, unsigned int s); // at the section's SECTION line
void Report(unsigned int file, unsigned int line, unsigned int pos);
void Phase(unsigned char p);
unsigned char* SectAt(unsigned int index);
void SectCopy(unsigned int index, unsigned char store); // sec from (0) or to (1) PSRAM
void Join(unsigned int r, unsigned int s); // FRAGMENT s continues r

// link_obj.c
Val Apply(unsigned char o, Val a, Val b); // asm_math.c
UVal Div(UVal a, UVal b);
extern UVal div_rem;
extern unsigned int name_next; // the names table's next unit
extern Val found_value; // Lookup's
extern unsigned char found_bank;
unsigned char Insert(Val value, unsigned char bank); // name; 0 if it's there already (found_value is its)
extern unsigned int first; // the unit's first section
void Walk(unsigned char step); // 0 section names, 1 labels and exported constants, 2 patches
extern int sect_delta[ASM_SECTIONS];
extern unsigned char sect_bank[ASM_SECTIONS];
extern unsigned char copy_n;
void Fill(unsigned char b); // the window's 512 bytes
unsigned int Sum(unsigned int sum); // plus the window's bytes
void Copy(unsigned char* to, const unsigned char* from); // copy_n bytes (0: 256)
void Placed(unsigned int s); // sec, section s, has its place: Walk's table of them
#endif
