#ifndef FATPAK_EDITOR_BUILD_H
#define FATPAK_EDITOR_BUILD_H

void BuildFile(unsigned char run); // FILE > BUILD, or RUN: assembles the document to <name>.gb, then launches it
#ifdef FATPAK_MODULE_ASM_H // modules/assembler/asm.h
#define BUILD_PREP 2 // BuildModule's which
#define BUILD_ASM  1
#define BUILD_LINK 0
unsigned char BuildModule(AsmContext* c, unsigned char which); // PREP.MOD, ASM.MOD or LINK.MOD with BUILD's progress box
#endif

#endif
