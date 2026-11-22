// CC internals shared by cc_parse.c and cc_gen.c: types, symbols and expression nodes.
#ifndef CC_INT_H
#define CC_INT_H
#include "cc.h"
#include <stddef.h>

// ---- types ----
enum { T_VOID, T_BOOL, T_CHAR, T_SCHAR, T_UCHAR, T_INT, T_UINT, T_LONG, T_ULONG, T_PTR, T_ARRAY, T_FUNC, T_STRUCT, T_UNION };
enum { Q_CONST = 1, Q_VOLATILE = 2, Q_COMPLETE = 4 }; // Q_COMPLETE: a struct/union with members
typedef struct { u8 kind, qual; u16 base, count, extra, size; } Type;
// PTR: base. ARRAY: base, count (0xFFFF unknown). FUNC: base (return), extra/count (parameters).
// STRUCT/UNION: base (tag name), extra/count (members), size.
typedef struct { u16 name, type, offset; } Field;
enum { TY_NONE, TY_VOID, TY_BOOL, TY_CHAR, TY_SCHAR, TY_UCHAR, TY_INT, TY_UINT, TY_LONG, TY_ULONG, TY_BASIC };
u16 ty_size(u16 t);
u8 ty_is_int(u16 t);      // integer (including _Bool, char)
u8 ty_is_signed(u16 t);
u8 ty_is_scalar(u16 t);   // integer or pointer
#define TK(t) TY_KIND(t)

// ---- symbols ----
enum { S_GLOBAL, S_LOCAL, S_STATIC, S_FUNC, S_TYPEDEF, S_ENUMC, S_TAG };
enum { L_NONE, L_EXTERN, L_INTERNAL }; // linkage of globals and functions
typedef struct { u16 name, type; s16 pos; u16 label; u8 kind, linkage, defined, depth; u16 shadow; } Sym;
// S_LOCAL: pos is the frame position (from the SP at entry: parameters on the stack are
// positive, locals negative). S_STATIC: label numbers its storage. S_ENUMC: pos is the value.

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


// ---- the tables live in PSRAM: read and written by value, never through a pointer ----
// (the accessors are in cc_acc.h, a copy in each page that uses them)
#define CC_OFF(t, f) ((u8)offsetof(t, f))
#define SY_NAME(i) sy_r16(i, CC_OFF(Sym, name))
#define SY_TYPE(i) sy_r16(i, CC_OFF(Sym, type))
#define SY_POS(i) ((s16)sy_r16(i, CC_OFF(Sym, pos)))
#define SY_LABEL(i) sy_r16(i, CC_OFF(Sym, label))
#define SY_KIND(i) sy_r8(i, CC_OFF(Sym, kind))
#define SY_LINKAGE(i) sy_r8(i, CC_OFF(Sym, linkage))
#define SY_DEFINED(i) sy_r8(i, CC_OFF(Sym, defined))
#define SY_DEPTH(i) sy_r8(i, CC_OFF(Sym, depth))
#define SY_SHADOW(i) sy_r16(i, CC_OFF(Sym, shadow))
#define SY_NAME_SET(i, v) sy_w16(i, CC_OFF(Sym, name), v)
#define SY_TYPE_SET(i, v) sy_w16(i, CC_OFF(Sym, type), v)
#define SY_POS_SET(i, v) sy_w16(i, CC_OFF(Sym, pos), (u16)(v))
#define SY_LABEL_SET(i, v) sy_w16(i, CC_OFF(Sym, label), v)
#define SY_KIND_SET(i, v) sy_w8(i, CC_OFF(Sym, kind), v)
#define SY_LINKAGE_SET(i, v) sy_w8(i, CC_OFF(Sym, linkage), v)
#define SY_DEFINED_SET(i, v) sy_w8(i, CC_OFF(Sym, defined), v)
#define SY_DEPTH_SET(i, v) sy_w8(i, CC_OFF(Sym, depth), v)
#define SY_SHADOW_SET(i, v) sy_w16(i, CC_OFF(Sym, shadow), v)
#define TY_KIND(i) ty_r8(i, CC_OFF(Type, kind))
#define TY_QUAL(i) ty_r8(i, CC_OFF(Type, qual))
#define TY_BASE(i) ty_r16(i, CC_OFF(Type, base))
#define TY_COUNT(i) ty_r16(i, CC_OFF(Type, count))
#define TY_EXTRA(i) ty_r16(i, CC_OFF(Type, extra))
#define TY_SIZE(i) ty_r16(i, CC_OFF(Type, size))
#define TY_KIND_SET(i, v) ty_w8(i, CC_OFF(Type, kind), v)
#define TY_QUAL_SET(i, v) ty_w8(i, CC_OFF(Type, qual), v)
#define TY_BASE_SET(i, v) ty_w16(i, CC_OFF(Type, base), v)
#define TY_COUNT_SET(i, v) ty_w16(i, CC_OFF(Type, count), v)
#define TY_EXTRA_SET(i, v) ty_w16(i, CC_OFF(Type, extra), v)
#define TY_SIZE_SET(i, v) ty_w16(i, CC_OFF(Type, size), v)
#define FL_NAME(i) fl_r16(i, CC_OFF(Field, name))
#define FL_TYPE(i) fl_r16(i, CC_OFF(Field, type))
#define FL_OFFSET(i) fl_r16(i, CC_OFF(Field, offset))
#define FL_NAME_SET(i, v) fl_w16(i, CC_OFF(Field, name), v)
#define FL_TYPE_SET(i, v) fl_w16(i, CC_OFF(Field, type), v)
#define FL_OFFSET_SET(i, v) fl_w16(i, CC_OFF(Field, offset), v)
#define ND_OP(i) nd_r8(i, CC_OFF(Node, op))
#define ND_FLAGS(i) nd_r8(i, CC_OFF(Node, flags))
#define ND_TYPE(i) nd_r16(i, CC_OFF(Node, type))
#define ND_A(i) nd_r16(i, CC_OFF(Node, a))
#define ND_B(i) nd_r16(i, CC_OFF(Node, b))
#define ND_C(i) nd_r16(i, CC_OFF(Node, c))
#define ND_VAL(i) nd_r32(i, CC_OFF(Node, val))
#define ND_OP_SET(i, v) nd_w8(i, CC_OFF(Node, op), v)
#define ND_FLAGS_SET(i, v) nd_w8(i, CC_OFF(Node, flags), v)
#define ND_TYPE_SET(i, v) nd_w16(i, CC_OFF(Node, type), v)
#define ND_A_SET(i, v) nd_w16(i, CC_OFF(Node, a), v)
#define ND_B_SET(i, v) nd_w16(i, CC_OFF(Node, b), v)
#define ND_C_SET(i, v) nd_w16(i, CC_OFF(Node, c), v)
#define ND_VAL_SET(i, v) nd_w32(i, CC_OFF(Node, val), v)

// ---- shared (cc_mem.c) ----
u16 gen_label(void);            // a new label number (the counter goes on from pass to pass)
void gen_sink(u8 sink);         // opens the sink's section the first time
void gen_sym_name(u8 sink, u16 sym);
enum { R_A, R_E, R_DE, R_BC, R_DEBC, R_STACK }; // where an argument goes
void abi(u16 ft, u8* where, u16* offs, u16* stack);
u16 abi_params(u16 ft, s16* pos, u16* stack);
void ir_put8(u8 v);
void ir_put16(u16 v);

// ---- the statement stream, pass B to pass C: an op, then its operands (16 bits unless noted) ----
enum {
  IR_END,     // the unit's end
  IR_FUNC,    // sym: a function's start
  IR_FEND,    // its end
  IR_PLACE,   // label
  IR_JUMP,    // label, depth
  IR_EXPR,    // node
  IR_BRANCH,  // node, label, when (8 bits)
  IR_RETURN,  // node (0: none)
  IR_ALLOC,   // bytes
  IR_FREE,    // bytes
  IR_ZERO,    // sym, bytes
  IR_SWVAL,   // node, dispatch label
  IR_SWTAB,   // count, default label, its depth, then count * (value, label, depth)
  IR_LINE,    // line
  IR_DEPTH,   // depth: what follows (after a jump) is at this stack depth
  // static data, written by pass C to the sink IR_DSINK chose
  IR_DSINK,   // sink (8 bits): opens its section
  IR_DNAME,   // sym: its label
  IR_DLABEL,  // label: __unit__<label>
  IR_DFILL,   // bytes of zeros
  IR_DRES,    // bytes reserved (RAM)
  IR_DNUM,    // size (8 bits), value low, high: DB or DW
  IR_DADDR,   // sym, offset: DW its address
  IR_DSADDR,  // label, offset: DW a literal's address
  IR_DINIT,   // sym, end label: an initialized-data record's head
  IR_DSTR,    // label: a string literal follows, in pieces
  IR_DSTRB,   // heap offset low, high, length: one piece's bytes
  IR_DSTREND  // the terminating 0
};

// ---- code generation: pass C runs these; pass B's versions write the stream ----
extern s16 cg_depth;            // bytes pushed since the function's entry
void gen_func_begin(u16 sym);
void gen_func_end(void);
void gen_place(u16 label);      // the label is here
void gen_jump(u16 label, s16 depth); // jump there, leaving the stack at depth
void gen_expr(u16 n);           // evaluate for side effects
void gen_branch(u16 n, u16 label, u8 when); // jump if (n != 0) == when
void gen_return(u16 n);         // n = 0: no value
void gen_alloc(u16 bytes);
void gen_free(u16 bytes);
void gen_zero_local(u16 sym, u16 bytes);
void gen_switch_value(u16 n, u16 dispatch); // the value in HL, then a jump to dispatch
void gen_comment_line(u16 line);
#endif
