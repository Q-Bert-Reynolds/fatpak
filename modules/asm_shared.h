#ifndef FATPAK_MODULE_ASM_SHARED_H
#define FATPAK_MODULE_ASM_SHARED_H
// ASM.MOD's two pages share these (notes/ASSEMBLER.md). asm.c reads characters: stream,
// words, expressions, operands, directives, lines. asm_emit.c: symbols, arithmetic,
// instruction encoders, the image. Calls between them go through ModFar thunks, so the
// split keeps them to a few per statement; pointers never cross pages.
#include "../build/modules/sdk.h"
#include "asm.h"

#define NAME_MAX 32

// asm.c
extern AsmContext* context;
extern unsigned char ch; // the character being looked at, 0 past the end
extern unsigned char error, pass;
extern unsigned int line, line_pos, pos;
extern unsigned char at, count;
extern char ident[NAME_MAX + 1], name[NAME_MAX + 1];
extern unsigned char ident_len;
extern unsigned char undefined, pending, bracket, mem_c;
extern unsigned char okind[2], oreg[2], nops; // the statement's operands: kind, register, value
extern unsigned int oval[2];
#define K_IMM   0
#define K_R8    1 // b c d e h l [hl] a
#define K_R16   2 // bc de hl sp
#define K_AF    3
#define K_COND  4 // nz z nc; c arrives as K_R8 1
#define K_MEM   5 // [n16]
#define K_MEMR  6 // [bc] [de] [hli] [hld]
#define K_MEMC  7 // [c], [$ff00+c]
#define K_SPREL 8 // sp+e8
void Fail(unsigned char code);

// asm_emit.c
extern unsigned int scope, found, sym_value, next_unit, heads[256];
extern unsigned char sym_kind, sym_bank;
extern unsigned char in_section, sec_rom, sec_bank, rom_used;
extern unsigned int pc, sec_last;
unsigned char Find(void);
void Add(unsigned char kind, unsigned int value, unsigned char bank);
void SetValue(unsigned int value);
unsigned int Apply(unsigned char o, unsigned int a, unsigned int b);
void Emit(unsigned char b);
void Emit16(unsigned int v);
void Emit8(unsigned int v);
void EmitSigned(unsigned int v);
void Reserve(unsigned int bytes, unsigned char fill);
void Instruction(unsigned char m);
void Fill(void);
void Header(void);

#define SYM_LABEL 0
#define SYM_EQU   1
#define SYM_VAR   2

#endif
