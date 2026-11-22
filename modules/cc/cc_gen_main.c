// CC pass C, page 1: the pass, the statement stream and static data.
#define CC_PAGE gen_main
#define CC_NEED_sy_r8
#define CC_NEED_sy_r16
#define CC_NEED_ty_r8
#define CC_NEED_ty_r16
#define CC_NEED_nd_r8
#define CC_NEED_nd_r16
#define CC_NEED_nd_w8
#define CC_NEED_out_str
#include "cc_gen.h"

// the pass's variables (declared in the header)
s16 cg_depth;
u16 cur_func, ret_label, stack_args, last_line;
u32 helpers;
u32 ir_at;
u8 dsink;      // where they go
u16 str_len;   // bytes of the string literal being written

void gen_func_begin(u16 sym) {
  u8 where[CC_PARAMS]; u16 offs[CC_PARAMS], i, ft = SY_TYPE(sym);
  gen_sink(SINK_CODE);
  cur_func = sym; last_line = 0;
  out_str(SINK_CODE, "\n");
  gen_sym_name(SINK_CODE, sym);
  out_str(SINK_CODE, SY_LINKAGE(sym) == L_EXTERN ? "::\n" : ":\n");
  if (TY_COUNT(ft) > CC_PARAMS) cc_error(E_TOO_MANY_PARAMETERS);
  abi(ft, where, offs, &stack_args);
  cg_depth = 0;
  for (i = 0; i < TY_COUNT(ft); ++i) {
    switch (where[i]) {
    case R_A: push(I_PUSH_AF); break;
    case R_E: case R_DE: push(I_PUSH_DE); break;
    case R_BC: push(I_PUSH_BC); break;
    case R_DEBC: push(I_PUSH_DE); push(I_PUSH_BC); break;
    }
  }
  ret_label = gen_label();
}

void gen_func_end(void) {
  u16 rt = TY_BASE(SY_TYPE(cur_func));
  char name[CC_NAME_MAX + 1]; u8 len = name_copy(SY_NAME(cur_func), name);
  if (len == 4 && name[0] == 'm' && name[1] == 'a' && name[2] == 'i' && name[3] == 'n' && TK(rt) != T_VOID) {
    if (ty_size(rt) == 1) E0(I_XOR_A); else E0(I_LD_BC_0);
    if (ty_size(rt) == 4) E0(I_LD_DE_0);
  }
  move_sp(cg_depth);
  gen_place(ret_label);
  if (stack_args) { E0(I_POP_HL); move_sp((s16)stack_args); E0(I_JP_HL); }
  else E0(I_RET);
}

void gen_expr(u16 n) {
  if (ND_OP(n) == N_POSTINC) ND_OP_SET(n, N_PREINC);
  else if (ND_OP(n) == N_POSTDEC) ND_OP_SET(n, N_PREDEC);
  gen(n);
}

void gen_return(u16 n) {
  if (n) {
    u16 size = size_of(ND_TYPE(n));
    gen(n);
    if (size == 1) E0(I_LD_A_L);
    else { E0(I_LD_B_H); E0(I_LD_C_L); }
  }
  move_sp(cg_depth);
  E1(I_JP_L, ret_label);
}

void gen_zero_local(u16 sym, u16 bytes) {
  sp_addr(SY_POS(sym));
  if (bytes <= 8) { E0(I_XOR_A); while (bytes--) E0(I_LD_MHLI_A); return; }
  {
    u16 loop = gen_label();
    E1(I_LD_BC_U, bytes);
    gen_place(loop);
    E0(I_XOR_A); E0(I_LD_MHLI_A); E0(I_DEC_BC); E0(I_LD_A_B); E0(I_OR_A_C); E1(I_JP_NZ_L, loop);
  }
}

void gen_switch_value(u16 n, u16 dispatch) { gen(n); E1(I_JP_L, dispatch); }

u8 ir_get8(void) { u8 v; cc_sel((u16)(CC_IR_BLOCK + (u16)(ir_at >> 9))); v = cc_win[(u16)ir_at & 511]; ++ir_at; return v; }

u16 ir_get16(void) { u16 v = ir_get8(); return (u16)(v | (u16)ir_get8() << 8); }

void switch_table(void) {
  u16 count = ir_get16(), deflt = ir_get16(), i, stub, first = cc_st.next_label;
  s16 deflt_depth = (s16)ir_get16();
  u32 cases = ir_at;
  for (i = 0; i < count; ++i) {
    u16 v = ir_get16(), label = ir_get16(); s16 depth = (s16)ir_get16();
    stub = depth == cg_depth ? label : gen_label();
    E0(I_LD_A_L);
    if (v & 0xFF) E1(I_XOR_A_U, v & 0xFF);
    E0(I_LD_C_A); E0(I_LD_A_H);
    if (v >> 8) E1(I_XOR_A_U, v >> 8);
    E0(I_OR_A_C);
    E1(I_JP_Z_L, stub);
  }
  gen_jump(deflt, deflt_depth);
  ir_at = cases; stub = first;
  for (i = 0; i < count; ++i) {
    u16 label; s16 depth;
    ir_get16(); label = ir_get16(); depth = (s16)ir_get16();
    if (depth != cg_depth) { gen_place(stub++); gen_jump(label, depth); }
  }
}

void unit_label(u8 sink, u16 label) { out_str(sink, "__"); out_str(sink, cc_st.unit); out_str(sink, "__"); out_num(sink, label); }

void data_op(u8 op) {
  u16 a, b;
  s16 o;
  switch (op) {
  case IR_DSINK: dsink = ir_get8(); gen_sink(dsink); return;
  case IR_DNAME: a = ir_get16(); gen_sym_name(dsink, a); out_str(dsink, SY_LINKAGE(a) == L_EXTERN ? "::\n" : ":\n"); return;
  case IR_DLABEL: unit_label(dsink, ir_get16()); out_str(dsink, ":\n"); return;
  case IR_DFILL: out_str(dsink, "\tDS "); out_num(dsink, ir_get16()); out_str(dsink, ", 0\n"); return;
  case IR_DRES: out_str(dsink, "\tDS "); out_num(dsink, ir_get16()); out_str(dsink, "\n"); return;
  case IR_DNUM:
    op = ir_get8(); a = ir_get16(); b = ir_get16();
    out_str(dsink, op == 1 ? "\tDB " : "\tDW "); out_num(dsink, op == 1 ? (a & 0xFF) : a);
    if (op == 4) { out_str(dsink, ", "); out_num(dsink, b); }
    out_str(dsink, "\n");
    return;
  case IR_DADDR: case IR_DSADDR:
    a = ir_get16(); o = (s16)ir_get16();
    out_str(dsink, "\tDW ");
    if (op == IR_DADDR) gen_sym_name(dsink, a); else unit_label(dsink, a);
    if (o) { out_str(dsink, o > 0 ? " + " : " - "); out_num(dsink, o > 0 ? o : -o); }
    out_str(dsink, "\n");
    return;
  case IR_DINIT:
    a = ir_get16(); b = ir_get16();
    out_str(dsink, "\tDW "); gen_sym_name(dsink, a); out_str(dsink, ", "); unit_label(dsink, b); out_str(dsink, "\n");
    return;
  case IR_DSTR: gen_sink(SINK_STR); unit_label(SINK_STR, ir_get16()); out_str(SINK_STR, ":"); str_len = 0; return;
  case IR_DSTRB: {
    Tok t; u16 i, n;
    t.v = ir_get16(); t.v |= (u32)ir_get16() << 16; n = ir_get16();
    for (i = 0; i < n; ++i, ++str_len) {
      out_str(SINK_STR, str_len & 15 ? ", " : "\n\tDB ");
      out_num(SINK_STR, lit_byte(&t, i));
    }
    return;
  }
  case IR_DSTREND: out_str(SINK_STR, str_len & 15 ? ", 0\n" : "\n\tDB 0\n"); return;
  }
  cc_error(E_INTERNAL_UNKNOWN_NODE);
}

// ---- pass C ----

void copy_sink(u8 sink) { // after the others at CC_OUT_BLOCK
  u8 buf[64];
  u16 n = cc_st.sink_n[sink], at = 0;
  if ((u32)cc_st.out_n + n > (u32)CC_OUT_BLOCKS * 512) cc_error(E_OUTPUT_TOO_LARGE);
  while (at < n) {
    u16 k = (u16)(n - at) > (u16)sizeof(buf) ? (u16)sizeof(buf) : (u16)(n - at);
    m_get((u16)(CC_SINK_BLOCK + sink * CC_SINK_BLOCKS + (at >> 9)), at & 511, buf, k);
    m_put((u16)(CC_OUT_BLOCK + (cc_st.out_n >> 9)), cc_st.out_n & 511, buf, k);
    at = (u16)(at + k); cc_st.out_n = (u16)(cc_st.out_n + k);
  }
}

u8 cc_pass_c(void) {
  u8 i;
  cc_state_load();
  CC_CATCH();
  ir_at = 0;
  if (cc_st.flags & CC_WRAP) out_str(SINK_CODE, "INCLUDE \"GBCSYS/CC/crt0.asm\"\n"); // the start-up first: its cc_init fragment heads the list
  for (;;) {
    u8 op = ir_get8();
    u16 a, b;
    switch (op) {
    case IR_END: break;
    case IR_FUNC: gen_func_begin(ir_get16()); continue;
    case IR_FEND: gen_func_end(); continue;
    case IR_PLACE: gen_place(ir_get16()); continue;
    case IR_JUMP: a = ir_get16(); gen_jump(a, (s16)ir_get16()); continue;
    case IR_EXPR: gen_expr(ir_get16()); continue;
    case IR_BRANCH: a = ir_get16(); b = ir_get16(); gen_branch(a, b, ir_get8()); continue;
    case IR_RETURN: gen_return(ir_get16()); continue;
    case IR_ALLOC: gen_alloc(ir_get16()); continue;
    case IR_FREE: gen_free(ir_get16()); continue;
    case IR_ZERO: a = ir_get16(); gen_zero_local(a, ir_get16()); continue;
    case IR_SWVAL: a = ir_get16(); gen_switch_value(a, ir_get16()); continue;
    case IR_SWTAB: switch_table(); continue;
    case IR_LINE: cc_line = ir_get16(); gen_comment_line(cc_line); continue;
    case IR_DEPTH: cg_depth = (s16)ir_get16(); continue;
    case IR_DSINK: case IR_DNAME: case IR_DLABEL: case IR_DFILL: case IR_DRES: case IR_DNUM: case IR_DADDR:
    case IR_DSADDR: case IR_DINIT: case IR_DSTR: case IR_DSTRB: case IR_DSTREND: data_op(op); continue;
    default: cc_error(E_INTERNAL_UNKNOWN_NODE);
    }
    break;
  }
  helpers_comment();
  if (cc_st.flags & CC_WRAP) out_str(SINK_BSS, "INCLUDE \"GBCSYS/CC/ccrt.asm\"\nINCLUDE \"GBCSYS/CC/crtend.asm\"\n");
  out_flush();
  cc_st.out_n = 0;
  for (i = 0; i < CC_SINKS; ++i) copy_sink(i);
  cc_state_save();
  return 0;
}
