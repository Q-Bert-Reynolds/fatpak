#ifndef FATPAK_MODULE_LINK_H
#define FATPAK_MODULE_LINK_H
// LINK.MOD's two pages share these (link.c: placing, the image, header and log; link_obj.c:
// reading the objects, names and patches). Calls between them go through ModFar thunks.
#include "../../build/modules/sdk.h"
#include "asm.h"
#include "asm_obj.h"
#include "../lib/psram.h"

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

// link_read.c (and PREP.MOD's)
extern unsigned char copy_n;
void Copy(unsigned char* to, const unsigned char* from); // copy_n bytes (0: 256)
// link_obj.c
Val Apply(unsigned char o, Val a, Val b); // asm_math.c
UVal Div(UVal a, UVal b);
extern UVal div_rem;
extern unsigned int name_next; // the names table's next unit
extern Val found_value; // Lookup's
extern unsigned char found_bank;
unsigned char Insert(Val value, unsigned char bank);
unsigned int Lookup(void);
void Names(void); // the names table empty // name's unit (0: none), found_value and found_bank
extern char name[160];
extern unsigned char name_n;
extern unsigned char buf[256]; // link.c: scratch // name; 0 if it's there already (found_value is its)
extern unsigned int first; // the unit's first section
void Walk(unsigned char step); // 0 names: sections, labels and exported constants; 1 patches
extern int sect_delta[ASM_SECTIONS];
extern unsigned char sect_bank[ASM_SECTIONS];
void Fill(unsigned char b); // the window's 512 bytes
unsigned int Sum(unsigned int sum); // plus the window's bytes
void Placed(unsigned int s);
extern unsigned int in_block, in_ofs; // the stream Read reads
void Read(unsigned char* p, unsigned char n);
void Skip(unsigned char n);
unsigned char FileName(unsigned int file); // its length, the stream at it
extern unsigned char report_unit;
// link_build.c: build.obj
unsigned char OldName(unsigned char unit, unsigned int file); // file's path in the last build.obj's list for unit
void Restore(void); // their sections, data and objects into the room ASM.MOD left
void Snap(void); // the section records as they are before the link, for build.obj
void Compose(void); // after: build.obj at ASM_BUILD_BLOCK
void KeepAt(unsigned char u); // the stream at unchanged unit u's object (past OBJ_UNIT), first its first section
extern unsigned int kept_end_block, kept_end_ofs; // and where that ends
extern unsigned int obj_end_block, obj_end_ofs; // the object stream's end (Walk) // sec, section s, has its place: Walk's table of them
#endif
