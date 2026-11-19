#ifndef FATPAK_MODULE_ASM_SHARED_H
#define FATPAK_MODULE_ASM_SHARED_H
// ASM.MOD's two pages share these (notes/ASSEMBLER.md). asm.c reads characters: stream,
// words, expressions, operands, directives, lines. asm_emit.c: symbols, arithmetic,
// instruction encoders, the image. Calls between them go through ModFar thunks, so the
// split keeps them to a few per statement; pointers never cross pages.
#include "../../build/modules/sdk.h"
#include "asm.h"
#include "asm_obj.h"
#include "../lib/psram.h"

// Advance's fast path: run_n bytes from run_p belong to the current frame without a check.
// Anything that moves the window or changes the frames drops it (run_n = 0).
extern unsigned char run_n;
#undef Window
#ifdef HOST_TEST
#define Window(block) (run_n = 0, psram_select(block))
#else
#define Window(block) (run_n = 0, *(volatile unsigned char*)0xBD03 = (unsigned char)((block) >> 8), *(volatile unsigned char*)0xBD02 = (unsigned char)(block)) // high, then low (lib/psram.h)
#endif

#define NAME_MAX 79

// Values (Val, asm_obj.h) are 32 bits (EQU and = constants, expressions, FOR, {d:} formats);
// addresses, sizes and operands stay 16. A constant's high word is its symbol's extra.

// asm.c
extern AsmContext* context;
extern unsigned char ch; // the character being looked at, 0 past the end
extern unsigned char error, pass, error_ch; // error_ch: the byte at the first failure, before Fail clears ch
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
extern unsigned int scope, found, sym_value, sym_extra, next_unit;
extern unsigned char sym_kind, sym_bank, sym_seen; // sym_seen: Mark()ed
extern unsigned char in_section, sec_rom, sec_bank, rom_used;
extern unsigned int pc, sec_last;
unsigned char Find(void);
void Add(unsigned char kind, unsigned int value, unsigned char bank);
void SetValue(unsigned int value, unsigned int extra);
void Mark(void);
Val Apply(unsigned char o, Val a, Val b);
void Emit(unsigned char b);
void Emit16(unsigned int v);
void EmitFile(void); // INCBIN: file_at to file_end
void Emit8(unsigned int v);
void EmitSigned(unsigned int v);
void Reserve(unsigned int bytes, unsigned char fill);
void Instruction(unsigned char m);
void Progress(void); // the box shows where the pass is (asm_pushs.c)
UVal Div(UVal a, UVal b); // asm_emit.c, unsigned (no SDCC helpers in modules): the quotient; the remainder in div_rem
extern UVal div_rem;
extern unsigned int progress_units, pass1_units;
extern unsigned char unit_n; // the unit being assembled, from 1 (0: the prelude)

#define SYM_LABEL 0
#define SYM_EQU   1 // value: the low word, extra: the high word
#define SYM_VAR   2 // the same
#define SYM_MACRO 3 // value, bank: the body's address (bits 0-15, 16-23), extra: its length
#define SYM_INCLUDE 4 // name: the path, value: its first block, bank and extra: its size (bits 16-23, 0-15)
#define SYM_STRING 5 // EQUS: value: heap offset, extra: length
#define SYM_SECTION 6 // name: '"' and the section's name, value: its index
#define SYM_CACHED 7 // build.cache: name: a file's, as SYM_INCLUDE's; value: its record in the last cache file (asm_cache.c)
// a label's extra is its section, with LABEL_FIXED when that has an address (the label is known);
// its bank is BANK_LINK until the link when the section's bank isn't given. An EQU or = constant's
// bank is 1 when it's EXPORTed.
#define LABEL_FIXED 0x8000
#define BANK_LINK 0xFF
#define SYM_SEEN 0x80 // with the kind: defined this pass (see Mark)

// shared by asm.c and asm_line.c
#define D_SECTION 0
#define D_DB 1
#define D_DS 3
#define D_DEF 4
#define D_EXPORT 6
#define D_GLOBAL 7
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
#define D_CHARMAP 28 // then NEWCHARMAP, SETCHARMAP, PUSHC, POPC
#define D_POPC 32
#define D_PUSHS 33
#define D_POPS 34
#define D_DL 35
#define DIRECTIVES 36 // the supported ones
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
#define FRAMES 16
// Text is read by address (Pos): below 64 KiB the document, else a PSRAM byte
// (block << 9 | offset): files, the EQUS heap. Small sources in memory have their own numbers.
typedef unsigned long Pos;
#define BLOCK(p) ((unsigned int)((p) >> 8) >> 1)
#define ADDRESS(block) ((Pos)(block) << 9)
#define SRC_TEXT 0 // by address
#define SRC_ARGS 0xFF // args[]
#define SRC_ID 0xFE // idtext[]
#define FILE_EXPANSION 0xFFFF // Frame.file of an EQUS or {} expansion
typedef struct {
  unsigned char kind, source;
  Pos pos, end; // the next character, one past the last
  Pos start; // a repeat body's first character
  unsigned int count; // and its iterations left
  Pos line_pos; // where its current line starts
  unsigned int line; // in the file, from 1
  unsigned int file; // the INCLUDE symbol of the file it's in (0: the document), or FILE_EXPANSION
  unsigned int first_line; // a repeat body's, for rewinding
  unsigned int for_unit; // FOR: its variable's symbol unit (0 for REPT)
  Val for_step; // and step
  unsigned int id; // \@
  unsigned char args, nargs; // a macro's arguments in args[], 0-ended each
} Frame;
// asm_sect.c: sections (Sect, asm_obj.h), each found by a SYM_SECTION symbol. The open one is
// in sec, written back when it closes.
extern Sect sec;
extern unsigned int nsects, cur;
extern unsigned char sect_depth; // PUSHS
void SectCopy(unsigned int index, unsigned char store); // sec from (0) or to (1) PSRAM
void Section(void);
void Enter(void); // sec is open: pc goes on from its fill
void CloseSection(void);
void PushS(void);
void PopS(void);
unsigned int AlignPad(unsigned char a, unsigned int ofs); // DS ALIGN: the bytes to its address
void AlignTo(unsigned char a, unsigned int ofs); // then the section's alignment is at least that
void UnitData(void); // after a unit's pass 1: its ROM sections' blocks in ASM_DATA_BLOCK
extern unsigned int unit_sect0, data_top; // the unit's first section; the next free data block
extern unsigned int sec_dbase; // the open section's data block for pc 0 (Emit: + pc / 512)
extern Frame frames[FRAMES];
extern unsigned char depth, chunk_n, arg_top;
extern char args[256], path[128];
extern unsigned int unique;
unsigned char Keyword(unsigned char which); // the index of ident in a T_ table, 0xFF if absent
unsigned char IsStart(unsigned char c);
unsigned char IsIdentChar(unsigned char c);
Frame* TextFrame(void);
Frame* Push(unsigned char kind, unsigned char source, Pos pos, Pos end); // file: the current frame's
void ToEnd(void);
void Operands(void);

void Advance(void);
void Space(void);
unsigned char AtEnd(void);
void Expect(unsigned char c);
void ReadIdent(void);
void SaveName(void);
void LoadName(void);
unsigned char Char(void);
Val Eval(void);
Val Constant(void);
unsigned char FindDotted(void); // asm_emit.c
unsigned char* Entry(unsigned int unit);
// Two tables share the hash code: names (sym_table 0: the prelude's and the unit's symbols, emptied
// back to the prelude's for each unit) and files (1: INCLUDE, INCBIN and build.cache's, kept all
// build). Each has its heads block; their entries are in separate ranges.
extern unsigned char sym_table;
extern unsigned int file_next; // the files table's next unit
extern unsigned int sym_mark; // the names table's first unit after the prelude's (a block's start)
void Dirty(unsigned int unit); // a prelude symbol is about to change: its block goes back for the next pass
void Snapshot(void); // asm_prelude.c: the prelude's names, heap and charmaps, to put back for each unit
void Restore(unsigned char unit); // before each pass of a unit: the prelude's again (unit: its symbols go too)
extern unsigned char cm_dirty; // asm_str.c: a charmap changed since the snapshot
void CharmapSave(unsigned char store); // its variables to (1) or from (0) the snapshot
extern unsigned int heap_mark;

// relocation: an expression's value is known (xs 0), a pass value in section xsect of this unit
// (1: a label or @ whose section Link places), or RPN in rpn[] (2: anything else the link
// works out). A patch-able value (an operand, a data item, ASSERT) leaves its state in prel.
extern unsigned char xs, prel, rpn_n, importing; // importing: unknown names in pass 2 are other units'
extern unsigned int xsect, psect;
extern unsigned char rpn[RPN_SIZE];
extern Val pval;
extern unsigned char x_ls, x_lmark; // Combine's left operand: its state and RPN start
extern unsigned int x_lsect;
Val Combine(unsigned char o, Val a, Val b); // asm_rel.c: o on a (x_ls) and b (xs)
Val Rel(unsigned char o, Val v); // a unary operator on v, which isn't known (xs): RPN
void RelSect(unsigned char op, unsigned int s); // RPN_SREL's or RPN_BANKSECT's operand for section s
void Import(void); // ident is another unit's: RPN_SYM with its name (xs 2)
void Patch(unsigned char type); // pass 2: prel's value at pc, for the link
Val Known(void); // Eval, which must not need the link
void PushId(void); // \@: its text in idtext[] as a frame
extern char idtext[8];
void Where(void); // where_file, where_line, where_pos: the place an error or patch is reported at
extern unsigned int where_file, where_line, where_pos;
// the patch and export streams (asm_obj.h): Out writes at out_block, out_ofs, up to out_end
extern unsigned int out_block, out_ofs, out_end;
void Out(unsigned char b);
void Out16(unsigned int v);
void Assemble(void); // asm_line.c: the prelude, then each unit's two passes and its objects
void Opened(unsigned int file); // asm_rel.c: OBJ_FILE, in pass 2
void Keep(unsigned char i); // an unchanged unit's room
extern AsmPrep prep; // asm_main.c: LINK.MOD's check (ASM_PREP_BLOCK), zero without one
unsigned char Clean(unsigned char i); // asm_rel.c: unit i is unchanged (LINK.MOD's check)
extern unsigned int files_end; // where files may be loaded to (build.obj may be above)
void Exports(void); // the unit's section names, labels and EXPORTed constants
extern unsigned int patches, lines_read; // patches written; 64-line steps read, all passes
#define CM_MAPS 8 // asm_str.c's charmaps: a names block and each map's heads block, from ASM_CHARMAP_BLOCK

// asm_str.c: string symbols on a heap in PSRAM, string expressions, {} interpolation
#define STR_SIZE 256
#define FMT_SIZE 36 // a 32-bit value in binary, its sign and %
#define SRC_FMT 0xFD // fmt_text
extern char str[], fmt_text[]; // sized in asm_str.c (asm_nostr.c leaves them tiny)
extern unsigned int str_top, heap_top;
extern unsigned char redef, literal, bs_literal; // REDEF is defining; >0: no {} interpolation (comments, skipping)
unsigned int StrExpr(void);
unsigned int StrNumber(unsigned char k);
void DefineString(unsigned int start);
void Interpolate(void);
void Purge(unsigned char at, unsigned char b);
void CharmapReset(void); // charmaps (asm_str.c)
void Charmap(unsigned char d); // d: 0 CHARMAP, 1 NEWCHARMAP, 2 SETCHARMAP, 3 PUSHC, 4 POPC
void MapEmit(unsigned int start); // str[start..str_top) through the charmap, used up
unsigned int CharLiteral(void);
unsigned char Comma(void); // asm_str.c: past a comma, 0 if there isn't one
void Expand(void); // asm.c: the string symbol just read replaces it in the source
#define SKIP_IF 0
#define SKIP_REPT 1
#define SKIP_MACRO 2
extern Pos scan_begin;
unsigned char Scan(unsigned char mode); // asm.c: skips lines to the directive that ends them
void Line(void);
void Label(void); // asm_line.c
void Statement(void);
void DefineValue(unsigned char kind, Val v); // name gets v
void Repeat(unsigned int n, unsigned int unit, Val step); // the body after this line n times
unsigned int OpenFile(void); // INCLUDE and INCBIN's "path": its symbol, 0 if it failed; sets file_at, file_size
// asm_proj.c: project.gbp
extern AsmLink asm_link; // asm_main.c: for LINK.MOD at the end
#define fix asm_link.fix
extern char output[65]; // the ROM's path from the project's folder
// main's files: each a unit (rgbasm runs one per file and rgblink joins them), its own symbols but
// for labels and sections (rgbasm -E's), in link order; none: assemble the document
#define UNITS 63
extern unsigned int units[UNITS], prelude; // their INCLUDE symbols; rgbasm -P's file (0: none)
extern unsigned char nunits;
typedef union { Val v; UVal u; unsigned int w[2]; } Num;
extern Num num; // asm.c: a number being read
void Digit(unsigned char base, unsigned char d); // num = num * base + d (2, 8, 10, 16)
unsigned char Project(void);
void Output(void); // asm_projw.c: output gets path, as .gb
// asm_cache.c: build.cache
extern unsigned int cache_n, cache_files, files_read;
extern unsigned char card_frames[4]; // 32 bits
void CacheStart(void); // after project.gbp
unsigned char CacheLoad(ModuleLoad* load, unsigned int record); // ModLoad(path, load), through the cache record (0: none) when it can
void CacheEnd(void);
unsigned int LoadPath(void); // the same for path[], 0 with file_error if it can't be read
extern unsigned char file_error;
extern Pos file_at, file_size, file_end; // and file_at + file_size
extern unsigned int file_top; // the next free block from ASM_FILE_BLOCK
void StepVar(unsigned int unit, Val step); // asm_emit.c: FOR's variable moves on
void For(void); // asm_str.c
void Incbin(void);
void FileOf(unsigned int file); // asm_loop.c: file_at, file_size, file_end from its symbol
void DocText(void); // asm_fileof.c: with ASM_TEXT, the document pushed as a frame like an included file
void Include(void); // asm_loop.c
void Report(unsigned int file, unsigned int line, unsigned int pos); // asm_main.c: where the error is, into the context
void ReportWhere(void); // Where, into the context
#endif
