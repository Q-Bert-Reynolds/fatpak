// CC internals shared by cc_parse.c and cc_gen.c: types, symbols and expression nodes.
#ifndef CC_INT_H
#define CC_INT_H
#include "cc.h"

// ---- types ----
enum { T_VOID, T_BOOL, T_CHAR, T_SCHAR, T_UCHAR, T_INT, T_UINT, T_LONG, T_ULONG, T_PTR, T_ARRAY, T_FUNC, T_STRUCT, T_UNION };
enum { Q_CONST = 1, Q_VOLATILE = 2, Q_COMPLETE = 4 }; // Q_COMPLETE: a struct/union with members
typedef struct { u8 kind, qual; u16 base, count, extra, size; } Type;
// PTR: base. ARRAY: base, count (0xFFFF unknown). FUNC: base (return), extra/count (parameters).
// STRUCT/UNION: base (tag name), extra/count (members), size.
typedef struct { u16 name, type, offset; } Field;
enum { TY_NONE, TY_VOID, TY_BOOL, TY_CHAR, TY_SCHAR, TY_UCHAR, TY_INT, TY_UINT, TY_LONG, TY_ULONG, TY_BASIC };
extern Type types[CC_TYPES];
extern Field fields[CC_FIELDS];
u16 ty_size(u16 t);
u8 ty_is_int(u16 t);      // integer (including _Bool, char)
u8 ty_is_signed(u16 t);
u8 ty_is_scalar(u16 t);   // integer or pointer
#define TK(t) (types[t].kind)

// ---- symbols ----
enum { S_GLOBAL, S_LOCAL, S_STATIC, S_FUNC, S_TYPEDEF, S_ENUMC, S_TAG };
enum { L_NONE, L_EXTERN, L_INTERNAL }; // linkage of globals and functions
typedef struct { u16 name, type; s16 pos; u16 label; u8 kind, linkage, defined, depth; } Sym;
// S_LOCAL: pos is the frame position (from the SP at entry: parameters on the stack are
// positive, locals negative). S_STATIC: label numbers its storage. S_ENUMC: pos is the value.
extern Sym syms[CC_SYMS];

// ---- expression nodes (one statement's worth; reset after it is generated) ----
enum {
  N_NUM, N_SYM, N_STR, N_ADDR, N_DEREF, N_OFFSET, N_CAST,
  N_NEG, N_BNOT, N_LNOT,
  N_ADD, N_SUB, N_MUL, N_DIV, N_MOD, N_SHL, N_SHR, N_AND, N_OR, N_XOR,
  N_LT, N_LE, N_GT, N_GE, N_EQ, N_NE,
  N_LAND, N_LOR, N_COND, N_COMMA, N_ASSIGN, N_OPASSIGN,
  N_PREINC, N_PREDEC, N_POSTINC, N_POSTDEC, N_CALL, N_ARG
};
typedef struct { u8 op, flags; u16 type, a, b, c; s32 val; } Node;
// N_NUM: val. N_SYM: a = symbol, val = byte offset into it (a member or element).
// N_STR: a = literal label. N_OFFSET: pointer a plus val bytes. N_CAST: a converted to type.
// N_COND: a ? b : c. N_OPASSIGN: a op= b, flags = op (N_ADD...), c = the type it computes in.
// N_PREINC..N_POSTDEC: val = step. N_CALL: a = callee, b = first N_ARG (a = value, b = next).
extern Node nodes[CC_NODES];

// ---- code generation (cc_gen.c) ----
extern s16 cg_depth;            // bytes pushed since the function's entry
extern const char* cg_unit;
void gen_func_begin(u16 sym);
void gen_func_end(void);
u16 gen_label(void);            // a new label number
void gen_place(u16 label);      // the label is here
void gen_jump(u16 label, s16 depth); // jump there, leaving the stack at depth
void gen_expr(u16 n);           // evaluate for side effects
void gen_branch(u16 n, u16 label, u8 when); // jump if (n != 0) == when
void gen_return(u16 n);         // n = 0: no value
void gen_alloc(u16 bytes);
void gen_free(u16 bytes);
void gen_zero_local(u16 sym, u16 bytes);
void gen_switch_value(u16 n, u16 dispatch); // the value in HL, then a jump to dispatch
void gen_switch_table(u16 count, const s32* values, const u16* labels, const s16* depths, u16 deflt, s16 deflt_depth);
void gen_sink(u8 sink);          // opens the sink's section the first time
void gen_unit_end(void);
void gen_params(u16 functype, s16* pos); // frame positions of the parameters (after gen_func_begin)
void gen_sym_name(u8 sink, u16 sym);
void gen_comment_line(u16 line);
#endif
