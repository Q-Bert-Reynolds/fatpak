// Passes B and C: type sizes, the calling convention and label numbers.
#define CC_PAGE types
#define CC_NEED_ty_r8
#define CC_NEED_ty_r16
#define CC_NEED_fl_r16
#include "cc_acc.h"

u16 gen_label(void) { return cc_st.next_label++; }

// ---- the ABI (sdcccall(1), SM83) ----
void abi(u16 ft, u8* where, u16* offs, u16* stack) {
  u16 i, n = TY_COUNT(ft), s = 0, first = TY_EXTRA(ft);
  for (i = 0; i < n; ++i) {
    u16 size = ty_size(FL_TYPE(first + i));
    u8 w = R_STACK;
    if (i == 0) w = size == 1 ? R_A : size == 2 ? R_DE : R_DEBC;
    else if (i == 1 && where[0] == R_A) w = size == 1 ? R_E : size == 2 ? R_DE : R_STACK;
    else if (i == 1 && where[0] == R_DE) w = size == 1 ? R_A : size == 2 ? R_BC : R_STACK;
    where[i] = w;
    offs[i] = s;
    if (w == R_STACK) s = (u16)(s + size);
  }
  *stack = s;
}
// the parameters' frame positions after the prologue pushes the register ones (first, then
// second); returns the bytes pushed
u16 abi_params(u16 ft, s16* pos, u16* stack) {
  u8 where[CC_PARAMS]; u16 offs[CC_PARAMS], i, n = TY_COUNT(ft); s16 depth = 0;
  if (n > CC_PARAMS) cc_error(E_TOO_MANY_PARAMETERS);
  abi(ft, where, offs, stack);
  for (i = 0; i < n; ++i) {
    switch (where[i]) {
    case R_A: depth += 2; pos[i] = (s16)(1 - depth); break;
    case R_E: case R_DE: case R_BC: depth += 2; pos[i] = (s16)-depth; break;
    case R_DEBC: depth += 4; pos[i] = (s16)-depth; break;
    default: pos[i] = (s16)(2 + offs[i]);
    }
  }
  return (u16)depth;
}

// ---- types (both the parser and the generator ask) ----
u16 ty_size(u16 t) {
  switch (TK(t)) {
  case T_BOOL: case T_CHAR: case T_SCHAR: case T_UCHAR: return 1;
  case T_INT: case T_UINT: case T_PTR: return 2;
  case T_LONG: case T_ULONG: return 4;
  case T_ARRAY: return TY_SIZE(t);
  case T_STRUCT: case T_UNION: return TY_SIZE(TY_EXTRA(t));
  }
  return 0;
}
u8 ty_is_int(u16 t) { u8 k = TK(t); return k >= T_BOOL && k <= T_ULONG; }
u8 ty_is_signed(u16 t) { u8 k = TK(t); return k == T_SCHAR || k == T_INT || k == T_LONG; }
u8 ty_is_scalar(u16 t) { u8 k = TK(t); return (k >= T_BOOL && k <= T_ULONG) || k == T_PTR; }

