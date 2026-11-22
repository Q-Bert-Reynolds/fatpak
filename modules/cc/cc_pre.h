// CC pass A (preprocessing) shared by its pages: cc_pre_*.c (notes/COMPILER.md)
#ifndef CC_A_H
#define CC_A_H
// CC's lexer and preprocessor: files -> tokens with #include, #define (object- and
// function-like), #undef, #if/#ifdef/#ifndef/#elif/#else/#endif, #error, #warning,
// defined, __FILE__ and __LINE__.
//
// Macro expansion: a function-like macro's arguments are expanded first (each one alone,
// behind a barrier so it can't read past its end), substituted, and the result is read
// again with the macro disabled until that list is used up. A disabled macro's name seen
// meanwhile is painted (TF_NOEXPAND) so it never expands later. Token lists share one
// arena: definitions and argument work grow up from the bottom, active expansions grow
// down from the top and are freed as they finish.
#include "cc_acc.h"
// ---- names: 64-byte records in PSRAM, chained from CC_NAME_HEADS heads ----
// record: length, pad, macro, next in the chain, the parser's symbol and tag heads, the text
extern u16 nnames;
#define MACRO_OF(id) nm_r16(id, NM_MACRO)
#define SET_MACRO_OF(id, m) nm_w16(id, NM_MACRO, m)
enum { NM_DEFINED = KW_COUNT, NM_FILE, NM_LINE, NM_INCLUDE, NM_DEFINE, NM_UNDEF, NM_IFDEF,
       NM_IFNDEF, NM_ELIF, NM_ENDIF, NM_ERROR, NM_WARNING, NM_PRAGMA, NM_LINENO, NM_VA_ARGS, NM_FIXED };
// ---- string literal bytes: a heap in PSRAM, never reset ----
#define heap_n cc_st.heap_n
extern u8 lex_skip; // skipping text: no literals kept
// ---- files ----
// one read buffer, the innermost file's: an #include rewinds its parent to the unread bytes
typedef struct { u8 handle, n, i, eof; u32 pos; u16 line; s16 la[3]; } File;
extern char fbuf[128];
extern File files[CC_FILES];
extern u8 nfiles;
extern u8 at_bol, in_directive;
#define C0 (files[nfiles - 1].la[0])
#define C1 (files[nfiles - 1].la[1])
#define C2 (files[nfiles - 1].la[2])
// ---- token arena, macros, sources ----
// tokens: 8 bytes in PSRAM (kind, flags, a, v)
extern u16 tok_lo, tok_hi;
// macros: 8 bytes in PSRAM (name, start, length, parameters or 0xFF for object-like, disabled)
extern u16 nmacros;
#define MC_NAME 0
#define MC_START 2
#define MC_LEN 4
#define MC_NPARAMS 6
#define MC_DISABLED 7
typedef struct { u16 pos, end, free_to, macro; u8 barrier; } Src;
extern Src srcs[CC_EXPAND];
extern u8 nsrc;
extern Tok pushback;
extern u8 has_pushback;
// ---- conditionals ----
enum { IF_ACTIVE, IF_WAITING, IF_DONE }; // taking this branch; none taken yet; one taken (or the parent skips)
extern u8 ifs[CC_IFS], nifs, skipping;
// #if arithmetic (results through pointers: SDCC can't return structs)
typedef struct { s32 v; u8 u; } PPV;
extern Tok ppt;

// functions, all pages
u8 same(const char* a, const char* b, u16 n);
u16 slen(const char* s);
u16 name_intern(const char* s, u16 n);
void lit_add(u8 c);
s16 file_byte(File* f);
s16 file_char(File* f);
void adv(void);
void file_push(u8 handle);
u8 is_id(s16 c);
s16 hexval(s16 c);
u16 escape(void);
void lex_number(Tok* t);
void lex_raw(Tok* t);
void tok_get(u16 i, Tok* t);
void tok_put(u16 i, const Tok* t);
u16 mc_r16(u16 m, u8 off);
void mc_w16(u16 m, u8 off, u16 v);
u8 mc_r8(u16 m, u8 off);
void mc_w8(u16 m, u8 off, u8 v);
void lo_add(const Tok* t);
void src_push(u16 pos, u16 end, u16 free_to, u16 macro, u8 barrier);
void update_skip(void);
void raw_next(Tok* t);
void directive_line(Tok* t);
void skip_line(void);
void pp_unary(PPV* r);
u8 pp_prec(u8 k);
void pp_expr(u8 min, PPV* l);
void pp_adv(void);
u8 pp_condition(void);
void define(void);
void include(void);
void directive(void);
void file_next(Tok* t);
void expand_call(u16 id);
void pp_next(Tok* t);
void cc_define(const char* name, const char* value);
void cc_pass_a_init(void);
void stream_put(const Tok* t);
void stream_all(void);
u8 cc_pass_a(const char* path, const char* unit, u8 flags);
#endif
