#ifndef FATPAK_MODULE_ASM_SHARED_H
#define FATPAK_MODULE_ASM_SHARED_H
// ASM.MOD's two pages share these (notes/ASSEMBLER.md). asm.c reads characters: stream,
// words, expressions, operands, directives, lines. asm_emit.c: symbols, arithmetic,
// instruction encoders, the image. Calls between them go through ModFar thunks, so the
// split keeps them to a few per statement; pointers never cross pages.
#include "../build/modules/sdk.h"
#include "asm.h"
#include "lib/psram.h"

// Advance's fast path: run_n bytes from run_p belong to the current frame without a check.
// Anything that moves the window or changes the frames drops it (run_n = 0).
extern unsigned char run_n;
#undef Window
#ifdef HOST_TEST
#define Window(block) (run_n = 0, psram_select(block))
#else
#define Window(block) (run_n = 0, *(volatile unsigned char*)0xBD03 = (unsigned char)((block) >> 8), *(volatile unsigned char*)0xBD02 = (unsigned char)(block)) // high, then low (lib/psram.h)
#endif

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
extern unsigned int scope, found, sym_value, sym_extra, next_unit, heads[256];
extern unsigned char sym_kind, sym_bank, sym_seen; // sym_seen: Mark()ed
extern unsigned char in_section, sec_rom, sec_bank, rom_used;
extern unsigned int pc, sec_last;
unsigned char Find(void);
void Add(unsigned char kind, unsigned int value, unsigned char bank);
void SetValue(unsigned int value);
void Mark(void);
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
#define SYM_MACRO 3 // value: body start, bank: source, extra: body end
#define SYM_INCLUDE 4 // name: the path, value: source number
#define SYM_STRING 5 // EQUS: value: heap offset, extra: length
#define SYM_SEEN 0x80 // with the kind: defined this pass (see Mark)

// shared by asm.c and asm_line.c
#define D_SECTION 0
#define D_DB 1
#define D_DS 3
#define D_DEF 4
#define D_REDEF 5
#define D_INCLUDE 8
#define D_IF 9
#define D_ELIF 10
#define D_ELSE 11
#define D_ENDC 12
#define D_MACRO 13
#define D_ENDM 14
#define D_REPT 15
#define D_ENDR 16
#define D_RSRESET 17
#define D_RSSET 18
#define D_FAIL 22
#define D_ASSERT 23
#define D_PURGE 24
#define D_SHIFT 25
#define D_INCBIN 26
#define D_FOR 27
#define DIRECTIVES 28 // the supported ones
#define T_MNEMONICS 0
#define T_DIRECTIVES 1
#define T_REGISTERS 2
#define T_BRACKETS 3
#define T_FUNCTIONS 4
#define T_TYPES 5
#define T_ATTRIBUTES 6
#define T_DEFINERS 7
#define T_STRFUNCS 8
#define F_TEXT 0
#define F_MACRO 1
#define F_REPT 2
#define F_ARG 3
#define FRAMES 10
#define SRC_ARGS 0xFF // args[]
#define SRC_ID 0xFE // idtext[]
typedef struct {
  unsigned char kind, source;
  unsigned int pos, end; // the next character, one past the last
  unsigned int start, count; // a repeat body's first character and iterations left
  unsigned int line, line_pos; // in the source, from 1; where its current line starts
  unsigned int first_line; // a repeat body's, for rewinding
  unsigned int for_unit, for_step; // FOR: its variable's symbol unit (0 for REPT) and step
  unsigned int id; // \@
  unsigned char args, nargs; // a macro's arguments in args[], 0-ended each
} Frame;
#define ROM_BANKS 64 // ASM_IMAGE_BLOCKS / 32
#define ASM_SECTIONS 64
#define SECT_ADDRESS 1 // flags: the address was given
#define SECT_BANK 2 // the bank was given
#define SECT_PLACED 4 // Link placed it
typedef struct {
  unsigned char type, bank, align, flags; // type: index into the region tables (ROM0 ROMX VRAM SRAM WRAM0 WRAMX OAM HRAM)
  unsigned int start, size, base; // pass 1's start (the address, or the region's start), size; Link's address
  unsigned char file; // where it was declared, for errors
  unsigned int line, pos;
} Sect;
extern Sect sects[ASM_SECTIONS];
extern unsigned char nsects, cur;
unsigned char Link(void);
void Relocate(void);
extern Frame frames[FRAMES];
extern unsigned char depth, chunk_n, arg_top, includes, max_bank;
extern char args[256], path[48];
extern unsigned int unique, inc_len[ASM_INCLUDES];
unsigned char Keyword(unsigned char which); // the index of ident in a T_ table, 0xFF if absent
unsigned char IsStart(unsigned char c);
unsigned char IsIdentChar(unsigned char c);
Frame* TextFrame(void);
Frame* Push(unsigned char kind, unsigned char source, unsigned int pos, unsigned int end);
void ToEnd(void);
void Operands(void);
void Pass(unsigned char p);
void Advance(void);
void Space(void);
unsigned char AtEnd(void);
void Expect(unsigned char c);
void ReadIdent(void);
void SaveName(void);
void LoadName(void);
unsigned char Char(void);
unsigned int Eval(void);
unsigned int Constant(void);
unsigned char FindDotted(void); // asm_emit.c
unsigned char* Entry(unsigned int unit);

// asm_str.c: string symbols on a heap in PSRAM, string expressions, {} interpolation
#define STR_SIZE 256
#define FMT_SIZE 24
#define SRC_HEAP (ASM_INCLUDES + 1) // a source like an included file: the EQUS heap
#define SRC_FMT 0xFD // fmt_text
#define ASM_HEAP_BLOCK (ASM_INCLUDE_BLOCK + (ASM_INCLUDES << 7))
extern char str[], fmt_text[]; // sized in asm_str.c (asm_nostr.c leaves them tiny)
extern unsigned int str_top, heap_top;
extern unsigned char redef, literal, bs_literal; // REDEF is defining; >0: no {} interpolation (comments, skipping)
unsigned int StrExpr(void);
unsigned int StrNumber(unsigned char k);
void DefineString(unsigned int start);
void Interpolate(void);
void Purge(void);
unsigned char Comma(void); // asm_str.c: past a comma, 0 if there isn't one
void Expand(void); // asm.c: the string symbol just read replaces it in the source
#define SKIP_IF 0
#define SKIP_REPT 1
#define SKIP_MACRO 2
extern unsigned int scan_begin;
unsigned char Scan(unsigned char mode); // asm.c: skips lines to the directive that ends them
void Line(void);
void Label(void); // asm_line.c
void Statement(void);
void DefineValue(unsigned char kind, unsigned int v); // name gets v
void Repeat(unsigned int n, unsigned int unit, unsigned int step); // the body after this line n times
unsigned char OpenFile(void); // INCLUDE and INCBIN's "path": its source number, 0 if it failed
void StepVar(unsigned int unit, unsigned int step); // asm_emit.c: FOR's variable moves on
void For(void); // asm_str.c
void Incbin(void);
#endif
