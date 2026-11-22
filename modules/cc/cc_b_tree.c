// CC pass B: building typed expression trees.
#define CC_PAGE b_tree
#define CC_NEED_ty_r8
#define CC_NEED_ty_r16
#define CC_NEED_nd_r8
#define CC_NEED_nd_r16
#define CC_NEED_nd_w8
#define CC_NEED_nd_w16
#define CC_NEED_nd_r32
#define CC_NEED_nd_w32
#include "cc_b.h"

// ---- nodes ----

s32 norm(s32 v, u16 t) {
  switch (TK(t)) {
  case T_BOOL: return v != 0;
  case T_CHAR: case T_UCHAR: return v & 0xFF;
  case T_SCHAR: return (s32)(int8_t)(v & 0xFF);
  case T_INT: return (s32)(int16_t)(v & 0xFFFF);
  case T_UINT: case T_PTR: return v & 0xFFFF;
  }
  return v;
}

u16 nd(u8 op, u16 type, u16 a, u16 b) {
  u16 n = nnodes;
  if (n == CC_NODES) cc_error(E_EXPRESSION_TOO_LARGE);
  ND_OP_SET(n, op); ND_FLAGS_SET(n, 0); ND_TYPE_SET(n, type); ND_A_SET(n, a); ND_B_SET(n, b); ND_C_SET(n, 0); ND_VAL_SET(n, 0);
  return nnodes++;
}

u16 num(s32 v, u16 type) { u16 n = nd(N_NUM, type, 0, 0); ND_VAL_SET(n, norm(v, type)); return n; }

u8 is_null(u16 n) { return IS_NUM(n) && ty_is_int(NT(n)) && ND_VAL(n) == 0; }

u8 is_lvalue(u16 n) { u8 op = ND_OP(n); return (op == N_SYM && TK(NT(n)) != T_FUNC) || op == N_DEREF || op == N_STR; }

u16 rval(u16 n) { // arrays and functions decay to pointers
  u8 k = TK(NT(n));
  if (k == T_ARRAY) {
    u16 pt = ty_ptr(TY_BASE(NT(n)));
    if (ND_OP(n) == N_DEREF) { u16 p = ND_A(n); return IS_NUM(p) ? num(ND_VAL(p), pt) : nd(N_CAST, pt, p, 0); }
    return nd(N_ADDR, pt, n, 0);
  }
  if (k == T_FUNC) return nd(N_ADDR, ty_ptr(NT(n)), n, 0);
  return n;
}

u16 cast(u16 n, u16 t) {
  u16 f = NT(n);
  t = ty_unqual(t);
  if (TK(t) == T_VOID) return nd(N_CAST, TY_VOID, n, 0);
  if (!ty_is_scalar(t)) { if (ty_same(ty_unqual(f), t)) return n; cc_error(E_CANT_CONVERT_TO_THAT_TYPE); }
  if (!ty_is_scalar(f)) cc_error(E_CANT_CONVERT_A_NON_SCALAR_VALUE);
  if (IS_NUM(n)) return num(ND_VAL(n), t);
  if (ty_unqual(f) == t) return n;
  return nd(N_CAST, t, n, 0);
}

u16 fold_bin(u8 op, u16 t, s32 a, s32 b) {
  u8 u = !ty_is_signed(t);
  u32 x = (u32)a, y = (u32)b; s32 r = 0;
  switch (op) {
  case N_ADD: r = (s32)(x + y); break;
  case N_SUB: r = (s32)(x - y); break;
  case N_MUL: r = (s32)cc_mul32(x, y); break;
  case N_DIV: case N_MOD:
    if (!b) cc_error(E_DIVISION_BY_ZERO);
    if (u) { u32 rem, q = cc_divmod32(x, y, &rem); r = (s32)(op == N_DIV ? q : rem); }
    else if (a == (s32)0x80000000l && b == -1) r = op == N_DIV ? a : 0;
    else r = cc_sdivmod32(a, b, op == N_MOD);
    break;
  case N_SHL: if (b < 0 || b >= (s32)ty_size(t) * 8) cc_error(E_SHIFT_COUNT_OUT_OF_RANGE); r = (s32)(x << b); break;
  case N_SHR: if (b < 0 || b >= (s32)ty_size(t) * 8) cc_error(E_SHIFT_COUNT_OUT_OF_RANGE); r = u ? (s32)(x >> b) : (a < 0 ? ~(~a >> b) : a >> b); break;
  case N_AND: r = a & b; break;
  case N_OR: r = a | b; break;
  case N_XOR: r = a ^ b; break;
  }
  return num(r, t);
}

u16 compare(u8 op, u16 l, u16 r) {
  u16 t;
  l = rval(l); r = rval(r);
  if (TK(NT(l)) == T_PTR || TK(NT(r)) == T_PTR) {
    if (TK(NT(l)) == T_PTR && TK(NT(r)) == T_PTR) t = TY_UINT;
    else if (TK(NT(l)) == T_PTR && is_null(r)) r = cast(r, NT(l));
    else if (TK(NT(r)) == T_PTR && is_null(l)) l = cast(l, NT(r));
    else cc_error(E_COMPARING_A_POINTER_WITH_AN_INTEGER);
    t = TY_UINT;
  } else {
    if (!ty_is_int(NT(l)) || !ty_is_int(NT(r))) cc_error(E_COMPARING_NON_SCALAR_VALUES);
    t = arith(NT(l), NT(r));
    l = cast(l, t); r = cast(r, t);
  }
  if (IS_NUM(l) && IS_NUM(r)) {
    s32 a = ND_VAL(l), b = ND_VAL(r); u8 u = !ty_is_signed(t), v = 0;
    switch (op) {
    case N_EQ: v = a == b; break; case N_NE: v = a != b; break;
    case N_LT: v = u ? (u32)a < (u32)b : a < b; break; case N_LE: v = u ? (u32)a <= (u32)b : a <= b; break;
    case N_GT: v = u ? (u32)a > (u32)b : a > b; break; case N_GE: v = u ? (u32)a >= (u32)b : a >= b; break;
    }
    return num(v, TY_INT);
  }
  t = nd(op, TY_INT, l, r);
  return t;
}

u16 scale(u16 n, u16 ptr) { // an integer index times the pointed-to size, as an int
  u16 size = ty_size(TY_BASE(ptr));
  if (!is_complete(TY_BASE(ptr))) { if (TK(TY_BASE(ptr)) == T_VOID) size = 1; else cc_error(E_ARITHMETIC_ON_A_POINTER_TO_AN_INCOMPLE); }
  n = cast(n, ty_is_signed(NT(n)) ? TY_INT : TY_UINT);
  if (size == 1) return n;
  if (IS_NUM(n)) return num((s32)cc_mul32((u32)ND_VAL(n), size), NT(n));
  return nd(N_MUL, NT(n), n, num(size, NT(n)));
}

u16 binop(u8 op, u16 l, u16 r) {
  u16 t, lt, rt;
  if (op >= N_LT && op <= N_NE) return compare(op, l, r);
  l = rval(l); r = rval(r); lt = NT(l); rt = NT(r);
  if (op == N_ADD || op == N_SUB) {
    if (TK(lt) == T_PTR && ty_is_int(rt)) {
      r = scale(r, lt);
      if (IS_NUM(r) && !ND_VAL(r)) return l;
      if (IS_NUM(l) && IS_NUM(r)) return fold_bin(op, lt, ND_VAL(l), ND_VAL(r));
      return nd(op, lt, l, r);
    }
    if (op == N_ADD && ty_is_int(lt) && TK(rt) == T_PTR) return binop(op, r, l);
    if (op == N_SUB && TK(lt) == T_PTR && TK(rt) == T_PTR) {
      u16 size = ty_size(TY_BASE(lt)), d;
      if (!ty_same(ty_unqual(TY_BASE(lt)), ty_unqual(TY_BASE(rt)))) cc_error(E_SUBTRACTING_POINTERS_TO_DIFFERENT_TYPE);
      if (!size) size = 1;
      d = nd(N_SUB, TY_INT, l, r);
      return size == 1 ? d : nd(N_DIV, TY_INT, d, num(size, TY_INT));
    }
  }
  if (!ty_is_int(lt) || !ty_is_int(rt)) cc_error(E_INVALID_OPERANDS);
  if (op == N_SHL || op == N_SHR) { t = promote(lt); r = cast(r, TY_INT); }
  else { t = arith(lt, rt); r = cast(r, t); }
  l = cast(l, t);
  if (IS_NUM(l) && IS_NUM(r)) return fold_bin(op, t, ND_VAL(l), ND_VAL(r));
  if ((op == N_DIV || op == N_MOD) && IS_NUM(r) && !ND_VAL(r)) cc_error(E_DIVISION_BY_ZERO);
  if ((op == N_SHL || op == N_SHR) && IS_NUM(r) && (ND_VAL(r) < 0 || ND_VAL(r) >= (s32)ty_size(t) * 8)) cc_error(E_SHIFT_COUNT_OUT_OF_RANGE);
  return nd(op, t, l, r);
}

u16 convert(u16 n, u16 t, u8 what) { // as if by assignment
  u16 f;
  n = rval(n); f = NT(n);
  if (TK(t) == T_STRUCT || TK(t) == T_UNION) {
    if (!ty_same(ty_unqual(f), ty_unqual(t))) cc_error(what);
    return n;
  }
  if (TK(t) == T_PTR) {
    if (TK(f) == T_PTR) {
      u16 a = TY_BASE(t), b = TY_BASE(f);
      if (TK(a) != T_VOID && TK(b) != T_VOID && !ty_same(ty_unqual(a), ty_unqual(b))) cc_warn(E_INCOMPATIBLE_POINTER_TYPES);
      else if (TY_QUAL(b) & ~TY_QUAL(a) & (Q_CONST | Q_VOLATILE)) cc_warn(E_CONVERSION_DROPS_A_QUALIFIER);
    } else if (!is_null(n)) cc_error(E_INTEGER_CONVERTED_TO_A_POINTER_WITHOUT);
    return cast(n, t);
  }
  if (ty_is_int(t)) {
    if (TK(f) == T_PTR && TK(t) != T_BOOL) cc_error(E_POINTER_CONVERTED_TO_AN_INTEGER_WITHOU);
    if (TK(f) == T_PTR) return compare(N_NE, n, num(0, TY_INT));
    if (!ty_is_int(f)) cc_error(what);
    return cast(n, t);
  }
  cc_error(what);
  return n;
}

void need_lvalue(u16 n) {
  u16 t = NT(n);
  if (!is_lvalue(n)) cc_error(E_NOT_AN_LVALUE);
  if (TK(t) == T_ARRAY) cc_error(E_CANT_ASSIGN_TO_AN_ARRAY);
  if (TY_QUAL(t) & Q_CONST) cc_error(E_ASSIGNMENT_TO_A_CONST_OBJECT);
}

u16 deref(u16 p) {
  u16 t;
  p = rval(p); t = NT(p);
  if (TK(t) != T_PTR) cc_error(E_DEREFERENCING_A_NON_POINTER);
  if (ND_OP(p) == N_ADDR && TK(NT(ND_A(p))) != T_ARRAY) return ND_A(p); // not a decayed array
  if (TK(TY_BASE(t)) == T_VOID) cc_error(E_DEREFERENCING_A_VOID_POINTER);
  return nd(N_DEREF, TY_BASE(t), p, 0);
}

u16 address(u16 n) {
  if (ND_OP(n) == N_DEREF) return ND_A(n);
  if (!is_lvalue(n) && TK(NT(n)) != T_FUNC) cc_error(E_CANT_TAKE_THAT_ADDRESS);
  return nd(N_ADDR, ty_ptr(NT(n)), n, 0);
}
