// CC pass B: tokens and expressions.
#define CC_PAGE b_expr
#define CC_NEED_sy_r8
#define CC_NEED_sy_r16
#define CC_NEED_ty_r8
#define CC_NEED_ty_r16
#define CC_NEED_fl_r16
#define CC_NEED_nd_r8
#define CC_NEED_nd_r16
#define CC_NEED_nd_w8
#define CC_NEED_nd_w16
#define CC_NEED_nd_r32
#define CC_NEED_nd_w32
#include "cc_b.h"

void enter(void) { if (++nesting > CC_DEPTH) cc_error(E_NESTED_TOO_DEEPLY); }

// ---- tokens from pass A's stream ----

void stream_next(Tok* t) {
  for (;;) {
    u8* r;
    if (stream_at >= cc_st.nstream) { t->kind = TK_EOF; t->line = stream_line; t->file = stream_file; return; }
    r = cc_at(CC_STREAM_BLOCK, stream_at++, 3);
    t->kind = r[0]; t->flags = r[1]; t->a = (u16)(r[2] | (u16)r[3] << 8);
    t->v = (u32)(r[4] | (u16)r[5] << 8) | (u32)(r[6] | (u16)r[7] << 8) << 16;
    if (t->kind != TK_LINE) break;
    stream_line = t->a; stream_file = (u8)t->v;
  }
  t->line = stream_line; t->file = stream_file;
}

void next(void) {
  if (has_ahead) { tok_copy(&tok, &ahead); has_ahead = 0; }
  else stream_next(&tok);
  cc_line = tok.line; cc_file = tok.file;
}

Tok* peek(void) {
  if (!has_ahead) { stream_next(&ahead); has_ahead = 1; }
  return &ahead;
}

u8 is_kw(u8 k) { return tok.kind == TK_ID && tok.a == k; }

void expect(u8 kind, u8 message) { if (tok.kind != kind) cc_error(message); next(); }

u16 string_literal(void) { // adjacent literals joined; pass C writes them to the strings
  u16 label = gen_label(), len = 0;
  ir_put8(IR_DSTR); ir_put16(label);
  while (tok.kind == TK_STR) {
    ir_put8(IR_DSTRB); ir_put16((u16)tok.v); ir_put16((u16)(tok.v >> 16)); ir_put16(tok.a);
    len = (u16)(len + tok.a);
    if (len >= 0x7FFF) cc_error(E_STRING_TOO_LONG);
    next();
  }
  ir_put8(IR_DSTREND);
  return nd(N_STR, ty_array(TY_CHAR, (u16)(len + 1)), label, 0);
}

u16 primary(void) {
  u16 n, s;
  switch (tok.kind) {
  case TK_NUM: {
    u32 v = tok.v; u8 f = tok.flags; u16 t;
    if (f & TF_LONG) t = (f & TF_UNSIGNED) || v > 0x7FFFFFFFul ? TY_ULONG : TY_LONG;
    else if (f & TF_UNSIGNED) t = v > 0xFFFF ? TY_ULONG : TY_UINT;
    else if (v <= 0x7FFF) t = TY_INT;
    else if (v <= 0xFFFF && (f & TF_RADIX)) t = TY_UINT;
    else t = v <= 0x7FFFFFFFul ? TY_LONG : ((f & TF_RADIX) ? TY_ULONG : TY_ULONG);
    next();
    return num((s32)v, t);
  }
  case TK_CHAR: n = num((s32)tok.v, TY_INT); next(); return n;
  case TK_STR: return string_literal();
  case '(':
    next(); n = expr(); expect(')', E_EXPECTED); return n;
  case TK_ID:
    if (tok.a < KW_COUNT && tok.a) cc_error2(E_UNEXPECTED_KEYWORD, tok.a);
    s = sym_find(tok.a, 0);
    if (!s) cc_error2(E_UNDECLARED, tok.a);
    next();
    switch (SY_KIND(s)) {
    case S_ENUMC: return num(SY_POS(s), TY_INT);
    case S_TYPEDEF: cc_error2(E_UNEXPECTED_TYPE_NAME, SY_NAME(s));
    }
    n = nd(N_SYM, SY_TYPE(s), s, 0);
    return n;
  }
  cc_error(E_EXPECTED_AN_EXPRESSION);
  return 0;
}

u16 member(u16 n, u8 arrow) {
  u16 t, canon, i, name, ft;
  if (arrow) { n = rval(n); if (TK(NT(n)) != T_PTR) cc_error(E_ARROW_NEEDS_A_POINTER); t = TY_BASE(NT(n)); }
  else t = NT(n);
  if (TK(t) != T_STRUCT && TK(t) != T_UNION) cc_error(E_MEMBER_OF_A_NON_STRUCT);
  if (!is_complete(t)) cc_error(E_INCOMPLETE_STRUCT);
  if (tok.kind != TK_ID) cc_error(E_EXPECTED_A_MEMBER_NAME);
  name = tok.a; next();
  canon = TY_EXTRA(t);
  for (i = 0; i < TY_COUNT(canon); ++i) if (FL_NAME(TY_BASE(canon) + i) == name) break;
  if (i == TY_COUNT(canon)) cc_error2(E_NO_SUCH_MEMBER, name);
  i += TY_BASE(canon);
  ft = ty_qual(FL_TYPE(i), TY_QUAL(t) & (Q_CONST | Q_VOLATILE));
  if (arrow) {
    u16 o;
    if (IS_NUM(n)) o = num(ND_VAL(n) + FL_OFFSET(i), ty_ptr(ft)); // offsetof's null pointer
    else { o = nd(N_OFFSET, ty_ptr(ft), n, 0); ND_VAL_SET(o, FL_OFFSET(i)); }
    return nd(N_DEREF, ft, o, 0);
  }
  if (ND_OP(n) == N_SYM) { u16 m = nd(N_SYM, ft, ND_A(n), 0); ND_VAL_SET(m, ND_VAL(n) + FL_OFFSET(i)); return m; }
  if (ND_OP(n) == N_DEREF) {
    u16 p = ND_A(n), o = nd(N_OFFSET, ty_ptr(ft), p, 0);
    ND_VAL_SET(o, FL_OFFSET(i));
    return nd(N_DEREF, ft, o, 0);
  }
  cc_error(E_MEMBER_OF_A_VALUE_THAT_ISNT_AN_LVALUE);
  return 0;
}

u16 call(u16 fn) {
  u16 ft, first = 0, last = 0, i = 0, n;
  if (TK(NT(fn)) == T_FUNC) ft = NT(fn);
  else { fn = rval(fn); if (TK(NT(fn)) != T_PTR || TK(TY_BASE(NT(fn))) != T_FUNC) cc_error(E_CALLING_A_NON_FUNCTION); ft = TY_BASE(NT(fn)); }
  next(); // (
  if (tok.kind != ')') for (;;) {
    u16 a = assign(), arg;
    if (i >= TY_COUNT(ft)) cc_error(E_TOO_MANY_ARGUMENTS);
    a = convert(a, FL_TYPE(TY_EXTRA(ft) + i), E_ARGUMENT_OF_THE_WRONG_TYPE);
    if (TK(NT(a)) == T_STRUCT || TK(NT(a)) == T_UNION) cc_error(E_STRUCT_ARGUMENTS_ARE_NOT_SUPPORTED);
    arg = nd(N_ARG, NT(a), a, 0);
    if (last) ND_B_SET(last, arg); else first = arg;
    last = arg; ++i;
    if (tok.kind != ',') break;
    next();
  }
  expect(')', E_EXPECTED_AFTER_ARGUMENTS);
  if (i < TY_COUNT(ft)) cc_error(E_TOO_FEW_ARGUMENTS);
  if (TK(TY_BASE(ft)) == T_STRUCT || TK(TY_BASE(ft)) == T_UNION) cc_error(E_STRUCT_RETURN_VALUES_ARE_NOT_SUPPORTED);
  n = nd(N_CALL, ty_unqual(TY_BASE(ft)), fn, first);
  return n;
}

u16 incdec(u8 op, u16 n) {
  u16 t = NT(n), r;
  need_lvalue(n);
  if (!ty_is_scalar(t)) cc_error(E_INCDEC_NEEDS_A_SCALAR);
  r = nd(op, ty_unqual(t), n, 0);
  ND_VAL_SET(r, 1);
  if (TK(t) == T_PTR) { ND_VAL_SET(r, ty_size(TY_BASE(t))); if (!ND_VAL(r)) { if (TK(TY_BASE(t)) == T_VOID) ND_VAL_SET(r, 1); else cc_error(E_INCDEC_ON_A_POINTER_TO_AN_INCOMPLETE_T); } }
  return r;
}

u16 postfix(u16 n) {
  for (;;) {
    switch (tok.kind) {
    case '[': next(); n = deref(binop(N_ADD, n, expr())); expect(']', E_EXPECTED_2); continue;
    case '(': n = call(n); continue;
    case '.': next(); n = member(n, 0); continue;
    case TK_ARROW: next(); n = member(n, 1); continue;
    case TK_INC: next(); n = incdec(N_POSTINC, n); continue;
    case TK_DEC: next(); n = incdec(N_POSTDEC, n); continue;
    }
    return n;
  }
}

u16 unary(void) {
  u16 n, t; u8 k = tok.kind;
  enter();
  if (k == '(' && starts_type(peek())) {
    next(); t = type_name(); expect(')', E_EXPECTED_AFTER_THE_TYPE);
    if (tok.kind == '{') cc_error(E_COMPOUND_LITERALS_ARE_NOT_SUPPORTED);
    n = unary();
    n = rval(n);
    if (TK(t) != T_VOID && !ty_is_scalar(t)) cc_error(E_CAST_TO_A_NON_SCALAR_TYPE);
    n = cast(n, t);
    leave(); return n;
  }
  if (is_kw(KW_SIZEOF)) {
    u16 mark = nnodes, size;
    next();
    if (tok.kind == '(' && starts_type(peek())) { next(); t = type_name(); expect(')', E_EXPECTED_AFTER_THE_TYPE); }
    else { n = unary(); t = NT(n); nnodes = mark; }
    if (!is_complete(t)) cc_error(E_SIZEOF_AN_INCOMPLETE_TYPE);
    size = ty_size(t);
    leave(); return num(size, TY_UINT);
  }
  switch (k) {
  case TK_INC: next(); n = incdec(N_PREINC, unary()); break;
  case TK_DEC: next(); n = incdec(N_PREDEC, unary()); break;
  case '&': next(); n = unary(); n = address(n); break;
  case '*': next(); n = unary(); n = rval(n); if (TK(NT(n)) == T_PTR && TK(TY_BASE(NT(n))) == T_FUNC) break; n = deref(n); break;
  case '+': case '-': case '~':
    next(); n = rval(unary());
    if (!ty_is_int(NT(n))) cc_error(E_ARITHMETIC_ON_A_NON_INTEGER);
    t = promote(NT(n)); n = cast(n, t);
    if (k == '+') break;
    if (IS_NUM(n)) { n = num(k == '-' ? (s32)(0u - (u32)ND_VAL(n)) : ~ND_VAL(n), t); break; }
    n = nd(k == '-' ? N_NEG : N_BNOT, t, n, 0);
    break;
  case '!':
    next(); n = rval(unary());
    if (!ty_is_scalar(NT(n))) cc_error(E_NEEDS_A_SCALAR);
    if (IS_NUM(n)) { n = num(!ND_VAL(n), TY_INT); break; }
    n = nd(N_LNOT, TY_INT, n, 0);
    break;
  default: n = postfix(primary());
  }
  leave();
  return n;
}

u8 bin_prec(u8 k, u8* op) {
  switch (k) {
  case TK_OROR: *op = N_LOR; return 1;
  case TK_ANDAND: *op = N_LAND; return 2;
  case '|': *op = N_OR; return 3;
  case '^': *op = N_XOR; return 4;
  case '&': *op = N_AND; return 5;
  case TK_EQ: *op = N_EQ; return 6; case TK_NE: *op = N_NE; return 6;
  case '<': *op = N_LT; return 7; case '>': *op = N_GT; return 7; case TK_LE: *op = N_LE; return 7; case TK_GE: *op = N_GE; return 7;
  case TK_SHL: *op = N_SHL; return 8; case TK_SHR: *op = N_SHR; return 8;
  case '+': *op = N_ADD; return 9; case '-': *op = N_SUB; return 9;
  case '*': *op = N_MUL; return 10; case '/': *op = N_DIV; return 10; case '%': *op = N_MOD; return 10;
  }
  return 0;
}

u16 binary(u8 min) {
  u16 l = unary();
  for (;;) {
    u8 op, p = bin_prec(tok.kind, &op);
    u16 r;
    if (!p || p <= min) return l;
    next();
    enter(); r = binary(p); leave();
    if (op == N_LAND || op == N_LOR) {
      l = rval(l); r = rval(r);
      if (!ty_is_scalar(NT(l)) || !ty_is_scalar(NT(r))) cc_error(E_AND_AND_OR_NEED_SCALARS);
      if (IS_NUM(l) && IS_NUM(r)) l = num(op == N_LAND ? (ND_VAL(l) && ND_VAL(r)) : (ND_VAL(l) || ND_VAL(r)), TY_INT);
      else l = nd(op, TY_INT, l, r);
    } else l = binop(op, l, r);
  }
}

u16 cond_expr(void) {
  u16 c = binary(0), a, b, t, n;
  if (tok.kind != '?') return c;
  next();
  c = rval(c);
  if (!ty_is_scalar(NT(c))) cc_error(E_CONDITION_NEEDS_A_SCALAR);
  enter(); a = rval(expr()); expect(':', E_EXPECTED_IN); b = rval(cond_expr()); leave();
  if (ty_is_int(NT(a)) && ty_is_int(NT(b))) { t = arith(NT(a), NT(b)); a = cast(a, t); b = cast(b, t); }
  else if (TK(NT(a)) == T_PTR && TK(NT(b)) == T_PTR) t = TK(TY_BASE(NT(a))) == T_VOID ? NT(a) : NT(b);
  else if (TK(NT(a)) == T_PTR && is_null(b)) { t = NT(a); b = cast(b, t); }
  else if (TK(NT(b)) == T_PTR && is_null(a)) { t = NT(b); a = cast(a, t); }
  else if (TK(NT(a)) == T_VOID && TK(NT(b)) == T_VOID) t = TY_VOID;
  else { cc_error(E_COND_OPERANDS_HAVE_DIFFERENT_TYPES); t = 0; }
  if (IS_NUM(c)) return ND_VAL(c) ? a : b;
  n = nd(N_COND, ty_unqual(t), c, a);
  ND_C_SET(n, b);
  return n;
}

u16 assign(void) {
  u16 l = cond_expr(), r, n, t;
  u8 op = 0;
  switch (tok.kind) {
  case '=': break;
  case TK_ADDA: op = N_ADD; break; case TK_SUBA: op = N_SUB; break; case TK_MULA: op = N_MUL; break;
  case TK_DIVA: op = N_DIV; break; case TK_MODA: op = N_MOD; break; case TK_ANDA: op = N_AND; break;
  case TK_ORA: op = N_OR; break; case TK_XORA: op = N_XOR; break; case TK_SHLA: op = N_SHL; break;
  case TK_SHRA: op = N_SHR; break;
  default: return l;
  }
  next();
  need_lvalue(l);
  enter(); r = assign(); leave();
  t = NT(l);
  if (!op) {
    r = convert(r, t, E_ASSIGNMENT_OF_THE_WRONG_TYPE);
    return nd(N_ASSIGN, ty_unqual(t), l, r);
  }
  r = rval(r);
  if (TK(t) == T_PTR && (op == N_ADD || op == N_SUB)) {
    if (!ty_is_int(NT(r))) cc_error(E_POINTER_NEEDS_AN_INTEGER);
    r = scale(r, t);
    n = nd(N_OPASSIGN, ty_unqual(t), l, r); ND_FLAGS_SET(n, op); ND_C_SET(n, ty_unqual(t));
    return n;
  }
  if (!ty_is_int(t) || !ty_is_int(NT(r))) cc_error(E_COMPOUND_ASSIGNMENT_NEEDS_INTEGERS);
  {
    u16 ct = op == N_SHL || op == N_SHR ? promote(t) : arith(t, NT(r));
    r = cast(r, op == N_SHL || op == N_SHR ? TY_INT : ct);
    if ((op == N_DIV || op == N_MOD) && IS_NUM(r) && !ND_VAL(r)) cc_error(E_DIVISION_BY_ZERO);
    n = nd(N_OPASSIGN, ty_unqual(t), l, r); ND_FLAGS_SET(n, op); ND_C_SET(n, ct);
  }
  return n;
}

u16 expr(void) {
  u16 n = assign();
  while (tok.kind == ',') {
    u16 r;
    next(); r = assign();
    n = nd(N_COMMA, NT(rval(r)), n, rval(r));
  }
  return n;
}

s32 const_expr(void) {
  u16 n = cond_expr();
  if (!IS_NUM(n)) cc_error(E_EXPECTED_A_CONSTANT);
  return ND_VAL(n);
}
