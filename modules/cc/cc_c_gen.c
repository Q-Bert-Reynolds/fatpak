// CC pass C: expressions to instructions (the recursive part, on one page).
#define CC_PAGE c_gen
#define CC_NEED_sy_r8
#define CC_NEED_sy_r16
#define CC_NEED_ty_r8
#define CC_NEED_ty_r16
#define CC_NEED_nd_r8
#define CC_NEED_nd_r16
#define CC_NEED_nd_r32
#define CC_NEED_out_str
#include "cc_c.h"

// ---- loads, stores, conversions ----

u16 size_of(u16 t) { return ty_size(t); }

u8 is_local(u16 n) { return ND_OP(n) == N_SYM && SY_KIND(ND_A(n)) == S_LOCAL; }

u8 is_named(u16 n) { u8 k; if (ND_OP(n) != N_SYM) return 0; k = SY_KIND(ND_A(n)); return k == S_GLOBAL || k == S_STATIC || k == S_FUNC; }

u8 simple(u16 n) { // gen(n) leaves DE and BC alone
  switch (ND_OP(n)) {
  case N_NUM: return size_of(ND_TYPE(n)) <= 2;
  case N_SYM: return size_of(ND_TYPE(n)) <= 2 || TK(ND_TYPE(n)) == T_ARRAY || TK(ND_TYPE(n)) == T_STRUCT || TK(ND_TYPE(n)) == T_UNION || TK(ND_TYPE(n)) == T_FUNC;
  case N_STR: return 1;
  case N_ADDR: return ND_OP(ND_A(n)) == N_SYM || ND_OP(ND_A(n)) == N_STR;
  case N_CAST: return size_of(ND_TYPE(n)) <= 2 && size_of(NT_(ND_A(n))) <= 2 && simple(ND_A(n));
  }
  return 0;
}

void operands(u16 l, u16 r) { // DE = l, HL = r
  if (simple(r)) { gen(l); E0(I_LD_D_H); E0(I_LD_E_L); gen(r); }
  else { gen(l); push(I_PUSH_HL); gen(r); pop(I_POP_DE); }
}

void operands32(u16 l, u16 r) { // left on the stack (4 bytes, the helper pops it), right in DEHL
  gen(l); push(I_PUSH_DE); push(I_PUSH_HL); gen(r);
}

void call_helper32(u8 h) { E1(I_CALL_H, h); cg_depth -= 4; }

void arith(u16 n) {
  u8 op = ND_OP(n); u16 t = ND_TYPE(n), l = ND_A(n), r = ND_B(n);
  if (size_of(t) == 4) {
    if (op == N_SHL || op == N_SHR) { gen(l); push(I_PUSH_DE); push(I_PUSH_HL); gen(r); call_helper32(op == N_SHL ? H_SHL32 : ty_is_signed(t) ? H_SHRS32 : H_SHRU32); return; }
    operands32(l, r); binary32(op, t); return;
  }
  if (ND_OP(r) == N_NUM) {
    gen(l);
    if (const_op(op, t, ND_VAL(r))) return;
    E0(I_LD_D_H); E0(I_LD_E_L); E1(I_LD_HL_U, (u16)ND_VAL(r));
    binary16(op, t); return;
  }
  operands(l, r);
  binary16(op, t);
}

u8 compare(u16 n) {
  u8 op = ND_OP(n); u16 l = ND_A(n), r = ND_B(n), t = NT_(l);
  u8 sg = ty_is_signed(t);
  if (size_of(t) == 4) {
    if (op == N_GT || op == N_LE) { u16 s = l; l = r; r = s; op = op == N_GT ? N_LT : N_GE; }
    operands32(l, r); call_helper32(sg ? H_CMPS32 : H_CMPU32);
    return op == N_EQ ? C_Z : op == N_NE ? C_NZ : op == N_LT ? C_C : C_NC;
  }
  if (ND_OP(r) == N_NUM) {
    u16 k = (u16)ND_VAL(r);
    gen(l);
    if (op == N_EQ || op == N_NE) {
      if (k & 0xFF) { E0(I_LD_A_L); E1(I_XOR_A_U, k & 0xFF); E0(I_LD_C_A); E0(I_LD_A_H); if (k >> 8) E1(I_XOR_A_U, k >> 8); E0(I_OR_A_C); }
      else { E0(I_LD_A_H); if (k >> 8) E1(I_XOR_A_U, k >> 8); E0(I_OR_A_L); }
      return op == N_EQ ? C_Z : C_NZ;
    }
    if (sg) { E0(I_LD_A_H); E0(I_XOR_A_X80); E0(I_LD_H_A); k ^= 0x8000; }
    if (op == N_LT || op == N_GE) { E0(I_LD_A_L); E1(I_SUB_A_U, k & 0xFF); E0(I_LD_A_H); E1(I_SBC_A_U, k >> 8); return op == N_LT ? C_C : C_NC; }
    E1(I_LD_A_U, k & 0xFF); E0(I_SUB_A_L); E1(I_LD_A_U, k >> 8); E0(I_SBC_A_H);
    return op == N_GT ? C_C : C_NC;
  }
  operands(l, r);
  if (op == N_EQ || op == N_NE) {
    E0(I_LD_A_E); E0(I_XOR_A_L); E0(I_LD_C_A); E0(I_LD_A_D); E0(I_XOR_A_H); E0(I_OR_A_C);
    return op == N_EQ ? C_Z : C_NZ;
  }
  if (sg) { E0(I_LD_A_D); E0(I_XOR_A_X80); E0(I_LD_D_A); E0(I_LD_A_H); E0(I_XOR_A_X80); E0(I_LD_H_A); }
  if (op == N_LT || op == N_GE) { E0(I_LD_A_E); E0(I_SUB_A_L); E0(I_LD_A_D); E0(I_SBC_A_H); return op == N_LT ? C_C : C_NC; }
  E0(I_LD_A_L); E0(I_SUB_A_E); E0(I_LD_A_H); E0(I_SBC_A_D);
  return op == N_GT ? C_C : C_NC;
}

void cond_value(u8 c) { // HL = the condition as 0 or 1
  if (c == C_C || c == C_NC) { E0(I_LD_HL_0); if (c == C_NC) E0(I_CCF); E0(I_RL_L); return; }
  { u16 skip = gen_label(); E0(I_LD_HL_0); E1(I_JP_C_L + (c ^ 1), skip); E0(I_INC_L); gen_place(skip); }
}

void test_zero(u16 t) { // Z if the value is zero
  E0(I_LD_A_H); E0(I_OR_A_L);
  if (size_of(t) == 4) { E0(I_OR_A_D); E0(I_OR_A_E); }
}

void gen_branch(u16 n, u16 label, u8 when) {
  u16 skip;
  switch (ND_OP(n)) {
  case N_NUM: if ((ND_VAL(n) != 0) == when) E1(I_JP_L, label); return;
  case N_LNOT: gen_branch(ND_A(n), label, !when); return;
  case N_LAND:
    if (when) { skip = gen_label(); gen_branch(ND_A(n), skip, 0); gen_branch(ND_B(n), label, 1); gen_place(skip); }
    else { gen_branch(ND_A(n), label, 0); gen_branch(ND_B(n), label, 0); }
    return;
  case N_LOR:
    if (when) { gen_branch(ND_A(n), label, 1); gen_branch(ND_B(n), label, 1); }
    else { skip = gen_label(); gen_branch(ND_A(n), skip, 1); gen_branch(ND_B(n), label, 0); gen_place(skip); }
    return;
  case N_LT: case N_LE: case N_GT: case N_GE: case N_EQ: case N_NE: {
    u8 c = compare(n);
    E1(I_JP_C_L + (when ? c : c ^ 1), label);
    return;
  }
  }
  gen(n);
  test_zero(ND_TYPE(n));
  E1(when ? I_JP_NZ_L : I_JP_Z_L, label);
}

// (Loops, not size tests: SDCC 4.2.0 computed the tests up front and lost registers holding
// size and is_named's result to `ld hl, sp+n`, so a long's high word went missing on the Game Boy.)
void store_to(u16 lhs, u16 t) { // the value (HL/DEHL) into lhs, keeping it in HL/DEHL
  u8 size = (u8)size_of(t), i; // 1, 2 or 4
  if (is_named(lhs)) {
    for (i = 0; i < size; ++i) ld_named(i, lhs, i); // named_parts 0-3: from l, h, e, d
    return;
  }
  if (!is_local(lhs)) return;
  E0(I_LD_B_H); E0(I_LD_C_L);
  sp_addr((s16)(SY_POS(ND_A(lhs)) + ND_VAL(lhs)));
  E0(I_LD_MHL_C);
  for (i = 1; i < size; ++i) { E0(I_INC_HL); E0(i == 1 ? I_LD_MHL_B : i == 2 ? I_LD_MHL_E : I_LD_MHL_D); }
  E0(I_LD_H_B); E0(I_LD_L_C);
}

void assign(u16 n) {
  u16 l = ND_A(n), r = ND_B(n), t = NT_(l);
  if (TK(t) == T_STRUCT || TK(t) == T_UNION) {
    gen_addr(l); push(I_PUSH_HL); gen(r); pop(I_POP_DE); push(I_PUSH_DE);
    E1(I_LD_BC_U, size_of(t)); E1(I_CALL_H, H_MEMCPY);
    pop(I_POP_HL);
    return;
  }
  if (is_named(l) || is_local(l)) { gen(r); store_to(l, t); return; }
  gen_addr(l); push(I_PUSH_HL); gen(r); pop(I_POP_BC); store_bc(t);
}

void opassign(u16 n) {
  u16 l = ND_A(n), r = ND_B(n), t = NT_(l), ct = ND_C(n);
  u8 op = ND_FLAGS(n);
  gen_addr(l); push(I_PUSH_HL);
  load(t); conv(t, ct);
  if (size_of(ct) == 4) {
    push(I_PUSH_DE); push(I_PUSH_HL); gen(r);
    if (op == N_SHL || op == N_SHR) call_helper32(op == N_SHL ? H_SHL32 : ty_is_signed(ct) ? H_SHRS32 : H_SHRU32);
    else binary32(op, ct);
  } else if (ND_OP(r) == N_NUM && const_op(op, ct, ND_VAL(r))) {}
  else if (simple(r)) { E0(I_LD_D_H); E0(I_LD_E_L); gen(r); binary16(op, ct); }
  else { push(I_PUSH_HL); gen(r); pop(I_POP_DE); binary16(op, ct); }
  conv(ct, t);
  pop(I_POP_BC); store_bc(t);
}

void incdec(u16 n) {
  u16 t = ND_TYPE(n), step = (u16)ND_VAL(n);
  u8 op = ND_OP(n), inc = op == N_PREINC || op == N_POSTINC, post = op == N_POSTINC || op == N_POSTDEC;
  gen_addr(ND_A(n)); push(I_PUSH_HL); load(t);
  if (size_of(t) == 4) {
    u16 skip = gen_label();
    pop(I_POP_BC);
    if (post) { push(I_PUSH_DE); push(I_PUSH_HL); }
    if (inc) { E0(I_INC_HL); E0(I_LD_A_H); E0(I_OR_A_L); E1(I_JP_NZ_L, skip); E0(I_INC_DE); gen_place(skip); }
    else { E0(I_LD_A_H); E0(I_OR_A_L); E1(I_JP_NZ_L, skip); E0(I_DEC_DE); gen_place(skip); E0(I_DEC_HL); }
    store_bc(t);
    if (post) { pop(I_POP_HL); pop(I_POP_DE); }
    return;
  }
  if (post) { E0(I_LD_D_H); E0(I_LD_E_L); }
  if (step == 1) E0(inc ? I_INC_HL : I_DEC_HL);
  else { E1(I_LD_BC_U, inc ? step : (u16)(0u - step)); E0(I_ADD_HL_BC); }
  conv(TY_INT, t);
  pop(I_POP_BC); store_bc(t);
  if (post) { E0(I_LD_H_D); E0(I_LD_L_E); }
}

void call(u16 n) {
  u16 fn = ND_A(n), ft, args[CC_PARAMS], nargs = 0, i, a, stack;
  u8 where[CC_PARAMS]; u16 offs[CC_PARAMS]; u8 direct;
  if (TK(NT_(fn)) == T_FUNC) ft = NT_(fn); else ft = TY_BASE(NT_(fn));
  if (ND_OP(fn) == N_ADDR && TK(NT_(ND_A(fn))) == T_FUNC) fn = ND_A(fn);
  direct = is_named(fn) && TK(NT_(fn)) == T_FUNC;
  for (a = ND_B(n); a; a = ND_B(a)) args[nargs++] = ND_A(a);
  abi(ft, where, offs, &stack);
  for (i = nargs; i-- > 0; ) {
    u16 size;
    if (where[i] != R_STACK) continue;
    gen(args[i]); size = size_of(NT_(args[i]));
    if (size == 1) { E0(I_LD_H_L); push(I_PUSH_HL); E0(I_INC_SP); --cg_depth; }
    else if (size == 2) push(I_PUSH_HL);
    else { push(I_PUSH_DE); push(I_PUSH_HL); }
  }
  for (i = 0; i < nargs && i < 2; ++i) {
    if (where[i] == R_STACK) continue;
    gen(args[i]);
    if (where[i] == R_A) E0(I_LD_H_L);
    if (where[i] == R_DEBC) push(I_PUSH_DE);
    push(I_PUSH_HL);
  }
  if (!direct) gen(fn);
  for (i = nargs < 2 ? nargs : 2; i-- > 0; ) {
    switch (where[i]) {
    case R_A: pop(I_POP_AF); break;
    case R_E: case R_DE: pop(I_POP_DE); break;
    case R_BC: pop(I_POP_BC); break;
    case R_DEBC: pop(I_POP_BC); pop(I_POP_DE); break;
    }
  }
  if (direct) E1(I_CALL_S, ND_A(fn));
  else E1(I_CALL_H, H_JPHL);
  cg_depth = (s16)(cg_depth - stack);
  switch (size_of(ND_TYPE(n))) {
  case 1: E0(I_LD_L_A); if (TK(ND_TYPE(n)) != T_BOOL) extend8(ty_is_signed(ND_TYPE(n))); else E0(I_LD_H_0); break;
  case 2: case 4: if (TK(ND_TYPE(n)) != T_VOID) { E0(I_LD_H_B); E0(I_LD_L_C); } break;
  }
}

void gen_addr(u16 n) {
  switch (ND_OP(n)) {
  case N_SYM:
    if (SY_KIND(ND_A(n)) == S_LOCAL) sp_addr((s16)(SY_POS(ND_A(n)) + ND_VAL(n)));
    else ld_named(4, n, 0);
    return;
  case N_DEREF: gen(ND_A(n)); return;
  case N_STR:
    out_str(SINK_CODE, "\tld hl, __"); out_str(SINK_CODE, cc_st.unit); out_str(SINK_CODE, "__"); out_num(SINK_CODE, ND_A(n)); out_str(SINK_CODE, "\n");
    return;
  }
  cc_error(E_INTERNAL_NO_ADDRESS);
}

void gen(u16 n) {
  u16 t = ND_TYPE(n);
  u8 k = TK(t);
  switch (ND_OP(n)) {
  case N_NUM:
    if (size_of(t) == 4) { E1(I_LD_DE_U, (u16)((u32)ND_VAL(n) >> 16)); E1(I_LD_HL_U, (u16)ND_VAL(n)); }
    else E1(I_LD_HL_U, (u16)ND_VAL(n));
    return;
  case N_SYM: case N_STR:
    gen_addr(n);
    if (k != T_ARRAY && k != T_STRUCT && k != T_UNION && k != T_FUNC) load(t);
    return;
  case N_ADDR: gen_addr(ND_A(n)); return;
  case N_DEREF:
    gen(ND_A(n));
    if (k != T_ARRAY && k != T_STRUCT && k != T_UNION && k != T_FUNC) load(t);
    return;
  case N_OFFSET: gen(ND_A(n)); if (ND_VAL(n)) const_op(N_ADD, TY_UINT, ND_VAL(n)); return;
  case N_CAST: gen(ND_A(n)); conv(NT_(ND_A(n)), t); return;
  case N_NEG:
    gen(ND_A(n));
    if (size_of(t) == 4) { E1(I_CALL_H, H_NEG32); return; }
    E0(I_XOR_A); E0(I_SUB_A_L); E0(I_LD_L_A); E0(I_SBC_A_A); E0(I_SUB_A_H); E0(I_LD_H_A);
    return;
  case N_BNOT:
    gen(ND_A(n));
    E0(I_LD_A_L); E0(I_CPL); E0(I_LD_L_A); E0(I_LD_A_H); E0(I_CPL); E0(I_LD_H_A);
    if (size_of(t) == 4) { E0(I_LD_A_E); E0(I_CPL); E0(I_LD_E_A); E0(I_LD_A_D); E0(I_CPL); E0(I_LD_D_A); }
    return;
  case N_LNOT:
    gen(ND_A(n)); test_zero(NT_(ND_A(n))); E0(I_SUB_A_1); E0(I_LD_HL_0); E0(I_RL_L);
    return;
  case N_ADD: case N_SUB: case N_MUL: case N_DIV: case N_MOD: case N_SHL: case N_SHR: case N_AND: case N_OR: case N_XOR:
    arith(n); return;
  case N_LT: case N_LE: case N_GT: case N_GE: case N_EQ: case N_NE: cond_value(compare(n)); return;
  case N_LAND: case N_LOR: {
    u16 f = gen_label(), e = gen_label();
    gen_branch(n, f, 0);
    E0(I_LD_HL_1); E1(I_JP_L, e);
    gen_place(f); E0(I_LD_HL_0); gen_place(e);
    return;
  }
  case N_COND: {
    u16 f = gen_label(), e = gen_label();
    gen_branch(ND_A(n), f, 0);
    gen(ND_B(n)); E1(I_JP_L, e);
    gen_place(f); gen(ND_C(n)); gen_place(e);
    return;
  }
  case N_COMMA: gen(ND_A(n)); gen(ND_B(n)); return;
  case N_ASSIGN: assign(n); return;
  case N_OPASSIGN: opassign(n); return;
  case N_PREINC: case N_PREDEC: case N_POSTINC: case N_POSTDEC: incdec(n); return;
  case N_CALL: call(n); return;
  }
  cc_error(E_INTERNAL_UNKNOWN_NODE);
}
