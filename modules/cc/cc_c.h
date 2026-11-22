// CC pass C (code generation) shared by its pages: cc_c_*.c (notes/COMPILER.md)
#ifndef CC_C_H
#define CC_C_H
// CC's SM83 code generator: expression trees -> RGBDS assembly, written straight to the
// code sink. A value is in HL (DEHL for 32 bits: DE high), held extended to 16 bits by its
// type, so promotions cost nothing. Binary operators take the left operand in DE and the
// right in HL; stores go through BC. Every push and pop moves cg_depth, so a local's
// SP offset and each jump's stack adjustment are known exactly; nothing relies on a
// peephole pass or an assembler retry. Calls use SDCC's sdcccall(1) for SM83.
#include "cc_acc.h"
#include "cc_ops.h"
extern u16 cur_func, ret_label, stack_args, last_line;
extern u32 helpers;
enum { H_MUL16, H_DIVS16, H_DIVU16, H_MODS16, H_MODU16, H_SHL16, H_SHRS16, H_SHRU16, H_JPHL, H_MEMCPY,
       H_ADD32, H_SUB32, H_AND32, H_OR32, H_XOR32, H_MUL32, H_DIVS32, H_DIVU32, H_MODS32, H_MODU32,
       H_SHL32, H_SHRS32, H_SHRU32, H_CMPS32, H_CMPU32, H_NEG32, H_COUNT };
// ---- expressions ----
#define NT_(n) (ND_TYPE(n))
// comparisons: emit code that sets a flag, return the condition that means true
enum { C_C, C_NC, C_Z, C_NZ };
// IR_SWTAB from the stream: the comparisons, then a stub for each case at another depth
extern u32 ir_at;
// ---- static data (the parser's IR_D* ops) ----
extern u8 dsink;      // where they go
extern u16 str_len;   // bytes of the string literal being written

// functions, all pages
void helpers_comment(void);
void emit(u8 op, u16 a, u16 b);
void gen_place(u16 label);
void gen_comment_line(u16 line);
void push(u8 op);
void pop(u8 op);
void move_sp(s16 bytes);
void gen_alloc(u16 bytes);
void gen_free(u16 bytes);
void gen_jump(u16 label, s16 depth);
void sp_addr(s16 pos);
void gen_func_begin(u16 sym);
void gen_func_end(void);
u16 size_of(u16 t);
void load(u16 t);
void store_bc(u16 t);
void extend8(u8 is_signed);
void conv(u16 from, u16 to);
u8 is_local(u16 n);
u8 is_named(u16 n);
void ld_named(u8 which, u16 n, s16 extra);
u8 simple(u16 n);
void operands(u16 l, u16 r);
void operands32(u16 l, u16 r);
void call_helper32(u8 h);
u8 log2_16(s32 v);
void shift_const(u8 op, u8 is_signed, u16 k);
u8 const_op(u8 op, u16 t, s32 v);
void binary16(u8 op, u16 t);
void binary32(u8 op, u16 t);
void arith(u16 n);
u8 compare(u16 n);
void cond_value(u8 c);
void test_zero(u16 t);
void gen_branch(u16 n, u16 label, u8 when);
void store_to(u16 lhs, u16 t);
void assign(u16 n);
void opassign(u16 n);
void incdec(u16 n);
void call(u16 n);
void gen_addr(u16 n);
void gen(u16 n);
void gen_expr(u16 n);
void gen_return(u16 n);
void gen_zero_local(u16 sym, u16 bytes);
void gen_switch_value(u16 n, u16 dispatch);
u8 ir_get8(void);
u16 ir_get16(void);
void switch_table(void);
void unit_label(u8 sink, u16 label);
void data_op(u8 op);
void copy_sink(u8 sink);
u8 cc_pass_c(void);
void out_bytes(u8 sink, const char* s, u16 n);
void out_num(u8 sink, s32 n);
void out_name(u8 sink, u16 name);
void gen_sym_name(u8 sink, u16 s);
void gen_sink(u8 sink);
#endif
