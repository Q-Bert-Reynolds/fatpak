// CC: a small C compiler for SM83 that writes RGBDS assembly (notes/COMPILER.md).
// The core (cc_lex.c, cc_parse.c, cc_gen.c) uses no libc beyond setjmp and stdarg: the host supplies
// files, output sinks and diagnostics through the cc_host_* functions below, so the same
// code runs in tests/cc_host.c on a PC and, later, as CC.MOD on the Game Boy.
// Tables are fixed arrays addressed by 16-bit ids, never pointers, so they can move to PSRAM.
#ifndef CC_H
#define CC_H
#include <stdint.h>
typedef uint8_t u8;
typedef uint16_t u16;
typedef int16_t s16;
typedef uint32_t u32;
typedef int32_t s32;

// ---- limits (each one is checked; running out is an error naming the table) ----
#define CC_NAMES 2048        // interned identifiers
#define CC_NAME_POOL 24576   // their characters
#define CC_TOKENS 8192       // macro bodies (low end) and expansions (high end)
#define CC_MACROS 1024
#define CC_PERM_POOL 4096    // string literal bytes inside #define bodies
#define CC_LIT_POOL 4096     // string literal bytes of the current declaration
#define CC_TYPES 1024
#define CC_FIELDS 1024       // parameters and struct/union members
#define CC_SYMS 1024
#define CC_NODES 1024        // one statement's expression trees
#define CC_FILES 8           // include depth
#define CC_IFS 32            // #if nesting
#define CC_EXPAND 64         // nested macro expansions
#define CC_SWITCH_CASES 256
#define CC_GOTOS 64
#define CC_DEPTH 48          // parser recursion (expressions, statements, declarators)

// ---- host interface ----
// Opens an #include (or, with from == 0xFF, the main file). Returns a handle, or 0xFF.
u8 cc_host_open(const char* name, u8 angled, u8 from);
// Reads up to n bytes at pos; returns the count, 0 at the end.
u16 cc_host_read(u8 file, u32 pos, char* dest, u16 n);
void cc_host_close(u8 file);
const char* cc_host_name(u8 file);
// Appends text to an output sink. The unit's assembly is the sinks in order 0..CC_SINKS-1.
enum { SINK_CODE, SINK_RODATA, SINK_STR, SINK_DATA, SINK_INIT, SINK_BSS, CC_SINKS };
void cc_host_write(u8 sink, const char* text, u16 n);
// One error (the compile stops after it) or warning, at file/line/column.
void cc_host_diag(u8 error, const char* file, u16 line, u16 col, const char* message);

// Compiles the main file. unit names this translation unit's internal symbols (letters,
// digits, _). Returns 0 on success, 1 after an error.
u8 cc_compile(const char* path, const char* unit);
// -D name[=value] before cc_compile (value "1" when absent)
void cc_define(const char* name, const char* value);

// ---- shared between the core's files ----
typedef struct { u8 kind, flags; u16 a; u32 v; u16 line; u8 file; } Tok;
enum { // token kinds; single-character punctuators are their ASCII code
  TK_EOF = 0, TK_NL, TK_ID, TK_NUM, TK_CHAR, TK_STR, TK_END, TK_ARG,
  TK_INC = 128, TK_DEC, TK_ARROW, TK_SHL, TK_SHR, TK_LE, TK_GE, TK_EQ, TK_NE, TK_ANDAND, TK_OROR,
  TK_ADDA, TK_SUBA, TK_MULA, TK_DIVA, TK_MODA, TK_ANDA, TK_ORA, TK_XORA, TK_SHLA, TK_SHRA,
  TK_ELLIPSIS, TK_HASHHASH
};
enum { TF_SPACE = 1, TF_BOL = 2, TF_NOEXPAND = 4, TF_PERM = 8, TF_UNSIGNED = 16, TF_LONG = 32, TF_RADIX = 64 }; // TF_RADIX: hex, octal or binary
enum { // keywords: the first names interned, so a TK_ID's a equals one of these
  KW_NONE, KW_VOID, KW_CHAR, KW_SHORT, KW_INT, KW_LONG, KW_SIGNED, KW_UNSIGNED, KW_BOOL,
  KW_CONST, KW_VOLATILE, KW_STATIC, KW_EXTERN, KW_TYPEDEF, KW_AUTO, KW_REGISTER, KW_INLINE,
  KW_STRUCT, KW_UNION, KW_ENUM, KW_IF, KW_ELSE, KW_WHILE, KW_DO, KW_FOR, KW_BREAK,
  KW_CONTINUE, KW_RETURN, KW_SWITCH, KW_CASE, KW_DEFAULT, KW_GOTO, KW_SIZEOF, KW_RESTRICT,
  KW_FLOAT, KW_DOUBLE, KW_COUNT
};

// lexer/preprocessor (cc_lex.c)
void lex_init(void);
u8 lex_open_main(const char* path);
void pp_next(Tok* t);
u16 name_intern(const char* s, u16 n);
const char* name_text(u16 id, u8* len);
u8 lit_byte(const Tok* t, u16 i);   // byte i of a TK_STR token
void lit_reset(void);               // forget the current declaration's literal bytes
extern u16 lex_line; extern u8 lex_file;

// diagnostics (cc_parse.c)
void cc_error(const char* message);
void cc_error2(const char* message, u16 name);
void cc_warn(const char* message);

// formatting into the sinks (cc_gen.c)
void out_str(u8 sink, const char* s);
void out_num(u8 sink, s32 n);
void out_hex(u8 sink, u16 n);
void out_name(u8 sink, u16 name);
#endif
