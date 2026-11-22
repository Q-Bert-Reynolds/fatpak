// CC pass B (parsing) shared by its pages: cc_parse_*.c (notes/COMPILER.md)
#ifndef CC_B_H
#define CC_B_H
// CC's pass B: declarations, types, statements and expressions, from pass A's token stream.
// Each full expression becomes a typed tree of nodes in PSRAM, with constants folded and
// C99's promotions and conversions explicit; each statement becomes ops in the statement
// stream (IR_*) that pass C generates code from. Static data is written here, to its sinks.
#include "cc_acc.h"
extern u16 ntypes, nfields, nsyms, nnodes;
extern Tok tok, ahead;
extern u8 has_ahead, nesting, block_depth;
extern u16 func_sym;
extern u16 brk_label, cont_label;
extern s16 brk_depth, cont_depth;
extern u16 block_bytes; // locals allocated by the innermost block so far
extern u16 stream_at;   // the next token of pass A's stream
extern u16 stream_line;
extern u8 stream_file;
#define leave() (--nesting)
// ---- the statement stream: pass C runs the real gen_* ----
#define IS_NUM(n) (ND_OP(n) == N_NUM)
#define NT(n) ND_TYPE(n)
// ---- declarations ----
// declspec's storage class and declarator's name, until the next call: globals, not results
// through pointers to locals, which SDCC 4.2.0 gave stack slots it reused (notes/COMPILER.md)
extern u8 spec_storage;
extern u16 decl_name;
extern u16 member_top; // the next free member record at CC_MEMBER_BLOCK
enum { D_PTR, D_ARRAY, D_FUNC };
extern u8 ndops; // records at CC_DOP_BLOCK: kind, qual, a, b
extern u16 dcl_name;
// ---- initializers ----
// Static storage: values are written to a sink as they're parsed. Automatic storage: they
// are collected (offset, node) and stored once the object is allocated.
extern u16 nitems; // records at CC_ITEM_BLOCK: offset, node
extern u8 init_static;
extern u16 init_done;
// switch state
// cases at CC_CASE_BLOCK: value, label, depth
#define CASE_VAL(i) rec_r16(CC_CASE_BLOCK, i, 0)
#define CASE_LABEL(i) rec_r16(CC_CASE_BLOCK, i, 2)
#define CASE_DEPTH(i) ((s16)rec_r16(CC_CASE_BLOCK, i, 4))
extern u16 ncases, switch_base, default_label;
extern s16 default_depth;
extern u8 in_switch;
extern u16 switch_type;
// goto state
// labels at CC_LABEL_BLOCK: name, label, depth, defined; gotos at CC_GOTO_BLOCK: name, stub, depth
extern u16 nlabels, ngotos;
#define LB_NAME(i) rec_r16(CC_LABEL_BLOCK, i, 0)
#define LB_LABEL(i) rec_r16(CC_LABEL_BLOCK, i, 2)
#define LB_DEPTH(i) ((s16)rec_r16(CC_LABEL_BLOCK, i, 4))
#define LB_DEFINED(i) rec_r16(CC_LABEL_BLOCK, i, 6)
#define GT_NAME(i) rec_r16(CC_GOTO_BLOCK, i, 0)
#define GT_STUB(i) rec_r16(CC_GOTO_BLOCK, i, 2)
#define GT_DEPTH(i) ((s16)rec_r16(CC_GOTO_BLOCK, i, 4))

// functions, all pages
void enter(void);
void gen_func_begin(u16 sym);
void gen_func_end(void);
void gen_place(u16 label);
void gen_jump(u16 label, s16 depth);
void gen_expr(u16 n);
void gen_branch(u16 n, u16 label, u8 when);
void gen_return(u16 n);
void gen_alloc(u16 bytes);
void gen_free(u16 bytes);
void gen_zero_local(u16 sym, u16 bytes);
void gen_switch_value(u16 n, u16 dispatch);
void gen_comment_line(u16 line);
void gen_depth(s16 depth);
void stream_next(Tok* t);
void next(void);
Tok* peek(void);
u8 is_kw(u8 k);
void expect(u8 kind, u8 message);
u8 is_complete(u16 t);
u16 ty_new(u8 kind, u8 qual, u16 base, u16 count, u16 extra, u16 size);
u16 ty_find(u8 kind, u8 qual, u16 base, u16 count, u16 extra, u16 size);
u16 ty_ptr(u16 base);
u16 ty_array(u16 base, u16 count);
u16 ty_qual(u16 t, u8 q);
u16 ty_unqual(u16 t);
u8 ty_same(u16 a, u16 b);
u16 promote(u16 t);
u16 arith(u16 a, u16 b);
u16 sym_find(u16 name, u8 tag);
u16 sym_add(u16 name, u8 kind, u16 type);
void scope_pop(u16 mark);
u8 is_typedef_name(const Tok* t);
u8 starts_type(const Tok* t);
s32 norm(s32 v, u16 t);
u16 nd(u8 op, u16 type, u16 a, u16 b);
u16 num(s32 v, u16 type);
u8 is_null(u16 n);
u8 is_lvalue(u16 n);
u16 rval(u16 n);
u16 cast(u16 n, u16 t);
u16 fold_bin(u8 op, u16 t, s32 a, s32 b);
u16 compare(u8 op, u16 l, u16 r);
u16 scale(u16 n, u16 ptr);
u16 binop(u8 op, u16 l, u16 r);
u16 convert(u16 n, u16 t, u8 what);
void need_lvalue(u16 n);
u16 deref(u16 p);
u16 address(u16 n);
u16 string_literal(void);
u16 primary(void);
u16 member(u16 n, u8 arrow);
u16 call(u16 fn);
u16 incdec(u8 op, u16 n);
u16 postfix(u16 n);
u16 unary(void);
u8 bin_prec(u8 k, u8* op);
u16 binary(u8 min);
u16 cond_expr(void);
u16 assign(void);
u16 expr(void);
s32 const_expr(void);
void push_dop(u8 kind, u8 qual, u16 a, u16 b);
void params(void);
void direct_dcl(void);
void dcl(void);
u16 declarator(u16 base);
u16 type_name(void);
u16 declspec(void);
u16 struct_spec(void);
u16 enum_spec(void);
void pad_to(u16 off);
u8 const_addr(u16 n, u16* sym, u8* is_str, s32* off);
void init_value(u16 off, u16 t, u16 n);
u8 init_string(u16* t, u16 off);
u16 init_elided(u16 t, u16 off);
u16 init_any(u16 t, u16 off);
u8 rom_type(u16 t);
void data_sink(u8 sink, u16 sym);
void define_static(u16 s);
u16 declare_global(u16 name, u16 t, u8 storage);
void declare_params(u16 ft);
void function_body(u16 s);
void external_declaration(void);
void reset_nodes(void);
void expr_statement(void);
u16 condition(void);
void branch_on(u16 n, u16 label, u8 when);
u16 label_find(u16 name);
u16 label_new(u16 name);
void statement(void);
void local_declaration(void);
void compound(void);
void basic_types(void);
void end_function_labels(void);
u8 cc_pass_b(void);
void ir_put8(u8 v);
void ir_put16(u16 v);
#endif
