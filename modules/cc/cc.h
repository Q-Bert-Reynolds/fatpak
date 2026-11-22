// CC: a small C compiler for SM83 that writes RGBDS assembly (notes/COMPILER.md).
// Three passes, each a module on the Game Boy, hand over only through PSRAM:
//   A (cc_lex.c)   preprocesses the source into a token stream,
//   B (cc_parse.c) parses it: symbols, types, expression trees, a statement stream, data,
//   C (cc_gen.c)   generates the code and puts the unit's assembly at CC_OUT_BLOCK.
// cc_core.c is in all three (cc_arith.c in A and B, cc_types.c in B and C), and each pass is
// split into pages (cc_pre_*.c, cc_parse_*.c, cc_gen_*.c): on the Game Boy, pieces of one module.
// No libc; the host gives the core files and takes diagnostics (cc_host_*): tests/cc_host.c
// on a PC, cc_dev_*.c on the Game Boy.
#ifndef CC_H
#define CC_H
#include <stdint.h>
#include "cc_msg.h"
typedef uint8_t u8;
typedef uint16_t u16;
typedef int16_t s16;
typedef uint32_t u32;
typedef int32_t s32;
#include "cc_ctx.h"
#ifndef CC_HOST // the module ABI entries the passes call (build/modules/sdk.h's, without its names)
#include "../../build/modules/modules.h" // MODULE_CCB, MODULE_CCC, MODULE_CCERR
extern CcContext* cc_ctx;
void cc_chain(u8 id);
void ModAbort(unsigned char result);
typedef struct { unsigned int block, blocks; unsigned long size; } ModuleLoad;
unsigned char ModLoad(const char* path, ModuleLoad* load);
unsigned char ModSource(unsigned int pos, char* dest);
#endif

// ---- limits (each one is checked; running out is an error naming the table) ----
#define CC_NAMES 4096        // interned identifiers
#define CC_NAME_HEADS 4096   // their hash chains
#define CC_NAME_MAX 54       // characters in one
#define CC_TOKENS 16384      // macro bodies (low end) and expansions (high end)
#define CC_MACROS 2048
#define CC_HEAP_BLOCKS 512   // string literal bytes (256 KiB)
#define CC_STREAM_MAX 65535  // tokens from pass A to pass B
#define CC_TYPES 4096
#define CC_FIELDS 4096       // parameters and struct/union members
#define CC_SYMS 8192
#define CC_NODES 65535       // the unit's expression trees (kept for code generation)
#define CC_PARAMS 16         // in one function (arrays of them are on the OS stack)
#define CC_MACRO_ARGS 16     // of one macro
#define CC_FILES 8           // include depth
#define CC_IFS 32            // #if nesting
#define CC_EXPAND 32         // nested macro expansions
#define CC_SWITCH_CASES 256
#define CC_GOTOS 64
#define CC_DOPS 64           // operations in one declarator
#define CC_ITEMS 256         // initializers of one local
#define CC_MEMBERS 256       // members of the structs being declared, nested
#define CC_DEPTH 48          // parser recursion (expressions, statements, declarators)
#define CC_IR_BLOCKS 512     // the statement stream (256 KiB)
#define CC_SINK_BLOCKS 128   // each output sink (64 KiB)
#define CC_OUT_BLOCKS 128    // the unit's assembly (64 KiB: ASM.MOD's document limit)

// ---- PSRAM: 512-byte blocks through the window at $BE00 (notes/COMPILER.md) ----
// While the compiler runs, ASM.MOD's areas ($0400-$3A03) are free; the finished assembly goes
// to CC_OUT_BLOCK, where ASM.MOD reads it (ASM_TEXT), as MAPVIEW.MOD's wrapper does.
#define CC_NAMEHEAD_BLOCK 0x0410 // 16 blocks
#define CC_NAME_BLOCK     0x0420 // 64-byte records
#define CC_MACRO_BLOCK    0x0620 // 8-byte records
#define CC_TOK_BLOCK      0x0640 // 8-byte tokens
#define CC_HEAP_BLOCK     0x0740 // string literal bytes
#define CC_STREAM_BLOCK   0x0940 // 8-byte tokens, pass A to pass B
#define CC_INCLUDE_BLOCK  0x0D40 // the Game Boy's host loads #included files here
#define CC_TYPE_BLOCK     0x1140 // 16-byte records
#define CC_FIELD_BLOCK    0x11C0 // 8-byte records
#define CC_SYM_BLOCK      0x1200 // 16-byte records
#define CC_NODE_BLOCK     0x1400 // 16-byte records
#define CC_IR_BLOCK       0x1C00 // bytes
#define CC_SINK_BLOCK     0x1E00 // CC_SINKS * CC_SINK_BLOCKS blocks of text
#define CC_DOP_BLOCK      0x2100 // the parser's scratch, 8-byte records: declarator operations (1 block)
#define CC_ITEM_BLOCK     0x2101 // a local's initializers (4 blocks)
#define CC_CASE_BLOCK     0x2105 // switch cases (4 blocks)
#define CC_LABEL_BLOCK    0x2109 // goto labels (1 block)
#define CC_GOTO_BLOCK     0x210A // gotos before their label (1 block)
#define CC_MEMBER_BLOCK   0x210B // struct members being declared, a stack (4 blocks)
#ifdef CC_HOST
extern u8* cc_win;
void cc_sel(u16 block);
#else
#define cc_win ((u8*)0xBE00)
#define cc_sel(b) (*(volatile u8*)0xBD03 = (u8)((b) >> 8), *(volatile u8*)0xBD02 = (u8)(b)) // high, then low
#endif
void m_get(u16 block, u16 off, void* dest, u16 n);
void m_put(u16 block, u16 off, const void* src, u16 n);
// 8-byte scratch records
u16 rec_r16(u16 base, u16 i, u8 off);
void rec_w16(u16 base, u16 i, u8 off, u16 v);

// ---- the state the passes hand on (cc_ctx.h's CcState at CC_STATE_BLOCK) ----
extern CcState cc_st;      // each pass's copy (cc_state_load, cc_state_save)
void cc_state_load(void);
void cc_state_save(void);
typedef char cc_extra_fits[sizeof(((CcState*)0)->err_extra) == CC_NAME_MAX + 1 ? 1 : -1];

// ---- host interface ----
// Opens an #include (or, with from == 0xFF, the main file). Returns a handle below 64, or 0xFF.
u8 cc_host_open(const char* name, u8 angled, u8 from);
// Reads up to n bytes at pos; returns the count, 0 at the end.
u16 cc_host_read(u8 file, u32 pos, char* dest, u16 n);
void cc_host_close(u8 file);
const char* cc_host_name(u8 file);
// One error (the compile stops after it) or warning: a code from cc_msg.h, with a name or
// #error's text in extra (or 0). The Game Boy's host can ignore it and read cc_st.
void cc_host_diag(u8 error, const char* file, u16 line, u8 code, const char* extra);

// The passes, in order; each returns cc_st.status. Pass A: cc_pass_a_init, then any
// cc_define (-D name[=value]), then cc_pass_a with the main file and the unit's name.
void cc_pass_a_init(void);
void cc_define(const char* name, const char* value);
u8 cc_pass_a(const char* path, const char* unit, u8 flags); // flags: CC_WRAP
u8 cc_pass_b(void);
u8 cc_pass_c(void);

// ---- shared between the core's files ----
typedef struct { u8 kind, flags; u16 a; u32 v; u16 line; u8 file; } Tok;
enum { // token kinds; single-character punctuators are their ASCII code
  TK_EOF = 0, TK_NL, TK_ID, TK_NUM, TK_CHAR, TK_STR, TK_END, TK_ARG, TK_LINE, // TK_LINE: in the stream, a = line, v = file
  TK_INC = 128, TK_DEC, TK_ARROW, TK_SHL, TK_SHR, TK_LE, TK_GE, TK_EQ, TK_NE, TK_ANDAND, TK_OROR,
  TK_ADDA, TK_SUBA, TK_MULA, TK_DIVA, TK_MODA, TK_ANDA, TK_ORA, TK_XORA, TK_SHLA, TK_SHRA,
  TK_ELLIPSIS, TK_HASHHASH
};
enum { TF_SPACE = 1, TF_BOL = 2, TF_NOEXPAND = 4, TF_UNSIGNED = 16, TF_LONG = 32, TF_RADIX = 64 }; // TF_RADIX: hex, octal or binary
enum { // keywords: the first names interned, so a TK_ID's a equals one of these
  KW_NONE, KW_VOID, KW_CHAR, KW_SHORT, KW_INT, KW_LONG, KW_SIGNED, KW_UNSIGNED, KW_BOOL,
  KW_CONST, KW_VOLATILE, KW_STATIC, KW_EXTERN, KW_TYPEDEF, KW_AUTO, KW_REGISTER, KW_INLINE,
  KW_STRUCT, KW_UNION, KW_ENUM, KW_IF, KW_ELSE, KW_WHILE, KW_DO, KW_FOR, KW_BREAK,
  KW_CONTINUE, KW_RETURN, KW_SWITCH, KW_CASE, KW_DEFAULT, KW_GOTO, KW_SIZEOF, KW_RESTRICT,
  KW_FLOAT, KW_DOUBLE, KW_COUNT
};

// names: 64-byte records at CC_NAME_BLOCK (cc_lex.c interns them)
#define NM_LEN 0
#define NM_MACRO 2
#define NM_NEXT 4
#define NM_SYM 6   // the parser's visible symbol and tag
#define NM_TAG 8
#define NM_TEXT 10
u16 name_intern(const char* s, u16 n);
u8 name_copy(u16 id, char* buf); // its text and a 0 in buf (CC_NAME_MAX + 1 bytes); returns the length
u16 name_sym(u16 id); void name_set_sym(u16 id, u16 sym);
u16 name_tag(u16 id); void name_set_tag(u16 id, u16 sym);
u8 lit_byte(const Tok* t, u16 i);   // byte i of a TK_STR token
void tok_copy(Tok* d, const Tok* s);

// arithmetic without SDCC's helpers (cc_mem.c)
u32 cc_mul32(u32 a, u32 b);
u16 cc_mul16(u16 a, u16 b);
u32 cc_divmod32(u32 a, u32 b, u32* rem);
s32 cc_sdivmod32(s32 a, s32 b, u8 want_rem);

// diagnostics at cc_file, cc_line. An error ends the pass: on the PC by longjmp to the pass's
// CC_CATCH, on the Game Boy by ModAbort (the module returns the error's code, cc_st saved).
#ifdef CC_HOST
#include <setjmp.h>
extern jmp_buf cc_fail;
#define CC_CATCH() if (setjmp(cc_fail)) { cc_state_save(); return cc_st.status; }
#else
#define CC_CATCH()
#endif
extern u16 cc_line;
extern u8 cc_file;
void cc_error(u8 code);
void cc_error2(u8 code, u16 name);
void cc_error_text(u8 code, const char* text);
void cc_diag_text(u8 code, const char* text);
void cc_warn(u8 code);

// formatting into the sinks
void out_bytes(u8 sink, const char* s, u16 n);
void out_num(u8 sink, s32 n);
void out_name(u8 sink, u16 name);
#endif
