// CC pass B: declarations, types and symbols.
#define CC_PAGE parse_decl
#define CC_NEED_sy_r8
#define CC_NEED_sy_r16
#define CC_NEED_sy_w8
#define CC_NEED_sy_w16
#define CC_NEED_ty_r8
#define CC_NEED_ty_r16
#define CC_NEED_ty_w8
#define CC_NEED_ty_w16
#define CC_NEED_fl_r16
#define CC_NEED_fl_w16
#include "cc_parse.h"

// ---- types ----

u8 is_complete(u16 t) {
  u8 k = TK(t);
  if (k == T_VOID || k == T_FUNC) return 0;
  if (k == T_ARRAY) return TY_COUNT(t) != 0xFFFF;
  if (k == T_STRUCT || k == T_UNION) return (TY_QUAL(TY_EXTRA(t)) & Q_COMPLETE) != 0;
  return 1;
}

u16 ty_new(u8 kind, u8 qual, u16 base, u16 count, u16 extra, u16 size) {
  u16 t = ntypes;
  if (t == CC_TYPES) cc_error(E_TOO_MANY_TYPES);
  TY_KIND_SET(t, kind); TY_QUAL_SET(t, qual); TY_BASE_SET(t, base); TY_COUNT_SET(t, count); TY_EXTRA_SET(t, extra); TY_SIZE_SET(t, size);
  return ntypes++;
}

u16 ty_find(u8 kind, u8 qual, u16 base, u16 count, u16 extra, u16 size) {
  u16 i;
  for (i = 1; i < ntypes; ++i)
    if (TY_KIND(i) == kind && TY_BASE(i) == base && TY_QUAL(i) == qual && TY_COUNT(i) == count && TY_EXTRA(i) == extra && TY_SIZE(i) == size) return i;
  return ty_new(kind, qual, base, count, extra, size);
}

u16 ty_ptr(u16 base) { return ty_find(T_PTR, 0, base, 0, 0, 2); }

u16 ty_array(u16 base, u16 count) {
  u32 size = count == 0xFFFF ? 0 : cc_mul32(count, ty_size(base));
  if (size > 0x7FFF) cc_error(E_ARRAY_TOO_LARGE);
  return ty_find(T_ARRAY, 0, base, count, 0, (u16)size);
}

u16 ty_qual(u16 t, u8 q) {
  u8 kind = TY_KIND(t), nq;
  if (!q) return t;
  if (kind == T_ARRAY) return ty_array(ty_qual(TY_BASE(t), q), TY_COUNT(t));
  nq = (u8)((TY_QUAL(t) | q) & (Q_CONST | Q_VOLATILE));
  if (kind == T_STRUCT || kind == T_UNION) return ty_find(kind, nq, 0, 0, TY_EXTRA(t), 0);
  return ty_find(kind, nq, TY_BASE(t), TY_COUNT(t), TY_EXTRA(t), TY_SIZE(t));
}

u16 ty_unqual(u16 t) {
  u8 kind = TY_KIND(t);
  if (!(TY_QUAL(t) & (Q_CONST | Q_VOLATILE))) return t;
  if (kind == T_STRUCT || kind == T_UNION) return TY_EXTRA(t);
  if (t < TY_BASIC) return t;
  return ty_find(kind, 0, TY_BASE(t), TY_COUNT(t), TY_EXTRA(t), TY_SIZE(t));
}

u8 ty_same(u16 a, u16 b) {
  u16 i, n, xa, ya; u8 kind = TY_KIND(a);
  if (a == b) return 1;
  if (kind != TY_KIND(b) || ((TY_QUAL(a) ^ TY_QUAL(b)) & (Q_CONST | Q_VOLATILE))) return 0;
  switch (kind) {
  case T_PTR: return ty_same(TY_BASE(a), TY_BASE(b));
  case T_ARRAY:
    n = TY_COUNT(a); i = TY_COUNT(b);
    return ty_same(TY_BASE(a), TY_BASE(b)) && (n == i || n == 0xFFFF || i == 0xFFFF);
  case T_STRUCT: case T_UNION: return TY_EXTRA(a) == TY_EXTRA(b);
  case T_FUNC:
    n = TY_COUNT(a);
    if (!ty_same(TY_BASE(a), TY_BASE(b)) || n != TY_COUNT(b)) return 0;
    xa = TY_EXTRA(a); ya = TY_EXTRA(b);
    for (i = 0; i < n; ++i) if (!ty_same(ty_unqual(FL_TYPE(xa + i)), ty_unqual(FL_TYPE(ya + i)))) return 0;
    return 1;
  }
  return 1;
}

u16 promote(u16 t) { u8 k = TK(t); return k >= T_BOOL && k <= T_UCHAR ? TY_INT : ty_unqual(t); }

u16 arith(u16 a, u16 b) {
  u8 x = TK(promote(a)), y = TK(promote(b));
  if (x == T_ULONG || y == T_ULONG) return TY_ULONG;
  if (x == T_LONG || y == T_LONG) return TY_LONG;
  if (x == T_UINT || y == T_UINT) return TY_UINT;
  return TY_INT;
}

// ---- symbols ----

u16 sym_find(u16 name, u8 tag) { return tag ? name_tag(name) : name_sym(name); }

// Symbols are never removed (code generation reads them later): a name's visible symbol heads

// a chain through shadow, and leaving a scope puts the heads back (scope_pop).

u16 sym_add(u16 name, u8 kind, u16 type) {
  u16 s = nsyms, old = sym_find(name, kind == S_TAG);
  if (old && SY_DEPTH(old) == block_depth && name) cc_error2(E_ALREADY_DECLARED, name);
  if (s == CC_SYMS) cc_error(E_TOO_MANY_SYMBOLS);
  SY_NAME_SET(s, name); SY_KIND_SET(s, kind); SY_TYPE_SET(s, type); SY_POS_SET(s, 0); SY_LABEL_SET(s, 0);
  SY_LINKAGE_SET(s, L_NONE); SY_DEFINED_SET(s, 0); SY_DEPTH_SET(s, block_depth);
  if (name) {
    if (kind == S_TAG) { SY_SHADOW_SET(s, name_tag(name)); name_set_tag(name, s); }
    else { SY_SHADOW_SET(s, name_sym(name)); name_set_sym(name, s); }
  }
  return nsyms++;
}

void scope_pop(u16 mark) {
  u16 s = nsyms;
  while (s-- > mark) {
    u16 name = SY_NAME(s);
    if (!name) continue;
    if (SY_KIND(s) == S_TAG) name_set_tag(name, SY_SHADOW(s));
    else name_set_sym(name, SY_SHADOW(s));
  }
}

u8 is_typedef_name(const Tok* t) {
  u16 s;
  if (t->kind != TK_ID || t->a < KW_COUNT) return 0;
  s = sym_find(t->a, 0);
  return s && SY_KIND(s) == S_TYPEDEF;
}

u8 starts_type(const Tok* t) {
  if (t->kind != TK_ID) return 0;
  switch (t->a) {
  case KW_VOID: case KW_CHAR: case KW_SHORT: case KW_INT: case KW_LONG: case KW_SIGNED: case KW_UNSIGNED:
  case KW_BOOL: case KW_CONST: case KW_VOLATILE: case KW_STRUCT: case KW_UNION: case KW_ENUM:
  case KW_STATIC: case KW_EXTERN: case KW_TYPEDEF: case KW_AUTO: case KW_REGISTER: case KW_INLINE:
  case KW_RESTRICT: case KW_FLOAT: case KW_DOUBLE: return 1;
  }
  return is_typedef_name(t);
}

void push_dop(u8 kind, u8 qual, u16 a, u16 b) {
  if (ndops == CC_DOPS) cc_error(E_DECLARATOR_TOO_COMPLEX);
  rec_w16(CC_DOP_BLOCK, ndops, 0, (u16)(kind | qual << 8)); rec_w16(CC_DOP_BLOCK, ndops, 2, a); rec_w16(CC_DOP_BLOCK, ndops, 4, b); ++ndops;
}

void params(void) { // after (: pushes D_FUNC
  u16 names[CC_PARAMS], typs[CC_PARAMS], i; u8 n = 0;
  if (is_kw(KW_VOID) && peek()->kind == ')') { next(); }
  if (tok.kind != ')') for (;;) {
    u16 t, name = 0, base;
    if (tok.kind == TK_ELLIPSIS) cc_error(E_VARIADIC_FUNCTIONS_ARE_NOT_SUPPORTED);
    if (!starts_type(&tok)) cc_error(E_EXPECTED_A_PARAMETER_TYPE);
    base = declspec();
    if (spec_storage && spec_storage != KW_REGISTER) cc_error(E_BAD_STORAGE_CLASS_FOR_A_PARAMETER);
    t = declarator(base); name = decl_name;
    if (TK(t) == T_ARRAY) t = ty_ptr(TY_BASE(t));
    else if (TK(t) == T_FUNC) t = ty_ptr(t);
    if (TK(t) == T_VOID) cc_error(E_VOID_PARAMETER);
    if (TK(t) == T_STRUCT || TK(t) == T_UNION) cc_error(E_STRUCT_PARAMETERS_ARE_NOT_SUPPORTED);
    if (n == CC_PARAMS) cc_error(E_TOO_MANY_PARAMETERS);
    names[n] = name; typs[n] = t; ++n;
    if (tok.kind != ',') break;
    next();
  }
  expect(')', E_EXPECTED_AFTER_PARAMETERS);
  if (nfields + n > CC_FIELDS) cc_error(E_TOO_MANY_PARAMETERS_AND_MEMBERS);
  for (i = 0; i < n; ++i) { FL_NAME_SET(nfields + i, names[i]); FL_TYPE_SET(nfields + i, typs[i]); FL_OFFSET_SET(nfields + i, 0); }
  push_dop(D_FUNC, 0, nfields, n);
  nfields += n;
}

void direct_dcl(void) {
  if (tok.kind == TK_ID && !is_typedef_name(&tok) && !(tok.a < KW_COUNT && tok.a)) { dcl_name = tok.a; next(); }
  else if (tok.kind == '(') {
    Tok* p = peek();
    if (p->kind == '*' || p->kind == '(' || (p->kind == TK_ID && !starts_type(p))) {
      next(); enter(); dcl(); leave(); expect(')', E_EXPECTED_IN_DECLARATOR);
    }
  }
  for (;;) {
    if (tok.kind == '[') {
      u16 count = 0xFFFF;
      next();
      if (tok.kind != ']') { s32 v = const_expr(); if (v <= 0 || v > 0x7FFF) cc_error(E_BAD_ARRAY_SIZE); count = (u16)v; }
      expect(']', E_EXPECTED_2);
      push_dop(D_ARRAY, 0, count, 0);
    } else if (tok.kind == '(') { next(); enter(); params(); leave(); }
    else break;
  }
}

void dcl(void) {
  u8 quals[16], n = 0, i;
  while (tok.kind == '*') {
    u8 q = 0;
    next();
    for (;;) {
      if (is_kw(KW_CONST)) q |= Q_CONST;
      else if (is_kw(KW_VOLATILE)) q |= Q_VOLATILE;
      else if (is_kw(KW_RESTRICT)) {}
      else break;
      next();
    }
    if (n == 16) cc_error(E_TOO_MANY_S);
    quals[n++] = q;
  }
  direct_dcl();
  for (i = n; i-- > 0; ) push_dop(D_PTR, quals[i], 0, 0);
}

u16 declarator(u16 base) { // its name in decl_name
  u8 mark = ndops, i;
  u16 t = base, saved = dcl_name;
  dcl_name = 0;
  dcl();
  decl_name = dcl_name; dcl_name = saved;
  for (i = ndops; i-- > mark; ) {
    u16 kq = rec_r16(CC_DOP_BLOCK, i, 0), da = rec_r16(CC_DOP_BLOCK, i, 2), db = rec_r16(CC_DOP_BLOCK, i, 4);
    u8 dkind = (u8)kq, dqual = (u8)(kq >> 8);
    if (dkind == D_PTR) t = ty_qual(ty_ptr(t), dqual);
    else if (dkind == D_ARRAY) {
      if (TK(t) == T_FUNC) cc_error(E_ARRAY_OF_FUNCTIONS);
      if (!is_complete(t)) cc_error(E_ARRAY_OF_AN_INCOMPLETE_TYPE);
      t = ty_array(t, da);
    } else {
      if (TK(t) == T_ARRAY || TK(t) == T_FUNC) cc_error(E_FUNCTION_RETURNING_AN_ARRAY_OR_FUNCTIO);
      t = ty_new(T_FUNC, 0, t, db, da, 0);
    }
  }
  ndops = mark;
  return t;
}

u16 type_name(void) {
  u16 name, t = declspec();
  if (spec_storage) cc_error(E_STORAGE_CLASS_IN_A_TYPE_NAME);
  t = declarator(t); name = decl_name;
  if (name) cc_error(E_UNEXPECTED_NAME_IN_A_TYPE);
  return t;
}

u16 declspec(void) { // the type; its storage class in spec_storage
  u16 type; u8 storage = 0, q = 0, nvoid = 0, nchar = 0, nshort = 0, nint = 0, nlong = 0, nsigned = 0, nunsigned = 0, nbool = 0;
  u16 other = 0;
  for (;;) {
    if (tok.kind != TK_ID) break;
    switch (tok.a) {
    case KW_STATIC: case KW_EXTERN: case KW_TYPEDEF: case KW_AUTO: case KW_REGISTER:
      if (storage) cc_error(E_MORE_THAN_ONE_STORAGE_CLASS);
      storage = (u8)tok.a; next(); continue;
    case KW_CONST: q |= Q_CONST; next(); continue;
    case KW_VOLATILE: q |= Q_VOLATILE; next(); continue;
    case KW_RESTRICT: next(); continue;
    case KW_INLINE: next(); continue;
    case KW_VOID: ++nvoid; next(); continue;
    case KW_CHAR: ++nchar; next(); continue;
    case KW_SHORT: ++nshort; next(); continue;
    case KW_INT: ++nint; next(); continue;
    case KW_LONG: ++nlong; next(); continue;
    case KW_SIGNED: ++nsigned; next(); continue;
    case KW_UNSIGNED: ++nunsigned; next(); continue;
    case KW_BOOL: ++nbool; next(); continue;
    case KW_FLOAT: case KW_DOUBLE: cc_error(E_FLOATING_POINT_IS_NOT_SUPPORTED); continue;
    case KW_STRUCT: case KW_UNION: if (other) cc_error(E_TWO_TYPES); other = struct_spec(); continue;
    case KW_ENUM: if (other) cc_error(E_TWO_TYPES); other = enum_spec(); continue;
    }
    if (!other && !(nvoid | nchar | nshort | nint | nlong | nsigned | nunsigned | nbool) && is_typedef_name(&tok)) {
      other = SY_TYPE(sym_find(tok.a, 0)); next(); continue;
    }
    break;
  }
  if (nlong > 1) cc_error(E_LONG_LONG_IS_NOT_SUPPORTED);
  if (other) {
    if (nvoid | nchar | nshort | nint | nlong | nsigned | nunsigned | nbool) cc_error(E_TWO_TYPES);
    type = other;
  } else if (nvoid) { if (nvoid > 1 || nchar | nshort | nint | nlong | nsigned | nunsigned | nbool) cc_error(E_BAD_TYPE); type = TY_VOID; }
  else if (nbool) { if (nbool > 1 || nchar | nshort | nint | nlong | nsigned | nunsigned) cc_error(E_BAD_TYPE); type = TY_BOOL; }
  else if (nsigned && nunsigned) { cc_error(E_SIGNED_AND_UNSIGNED); type = 0; }
  else if (nchar) { if (nchar > 1 || nshort | nint | nlong) cc_error(E_BAD_TYPE); type = nsigned ? TY_SCHAR : nunsigned ? TY_UCHAR : TY_CHAR; }
  else if (nshort) { if (nshort > 1 || nlong || nint > 1) cc_error(E_BAD_TYPE); type = nunsigned ? TY_UINT : TY_INT; }
  else if (nlong) { if (nint > 1) cc_error(E_BAD_TYPE); type = nunsigned ? TY_ULONG : TY_LONG; }
  else if (nint || nsigned || nunsigned) { if (nint > 1) cc_error(E_BAD_TYPE); type = nunsigned ? TY_UINT : TY_INT; }
  else { cc_error(E_EXPECTED_A_TYPE); type = 0; }
  type = ty_qual(type, q);
  spec_storage = storage;
  return type;
}

u16 struct_spec(void) {
  u8 is_union = is_kw(KW_UNION), kind = is_union ? T_UNION : T_STRUCT;
  u16 tag = 0, s = 0, t;
  next();
  if (tok.kind == TK_ID) { tag = tok.a; next(); }
  if (tag) {
    s = sym_find(tag, 1);
    if (s && TK(SY_TYPE(s)) != kind) cc_error2(E_TAG_IS_A_DIFFERENT_KIND, tag);
    if (s && tok.kind == '{' && SY_DEPTH(s) != block_depth) s = 0; // a new one shadows it
  }
  if (!s) {
    if (!tag && tok.kind != '{') cc_error(E_STRUCT_NEEDS_A_TAG_OR_MEMBERS);
    t = ty_new(kind, 0, 0, 0, 0, 0); TY_EXTRA_SET(t, t);
    if (tag) { s = sym_add(tag, S_TAG, t); }
  } else t = SY_TYPE(s);
  if (tok.kind != '{') return t;
  if (TY_QUAL(t) & Q_COMPLETE) cc_error2(E_STRUCT_DEFINED_TWICE, tag);
  next();
  {
    // the members on a scratch stack in PSRAM (a nested struct's above them): name, type
    u16 at = member_top, i, n = 0, size = 0;
    while (tok.kind != '}') {
      u16 base = declspec();
      if (spec_storage) cc_error(E_STORAGE_CLASS_IN_A_STRUCT);
      for (;;) {
        u16 ft = declarator(base), name = decl_name;
        if (tok.kind == ':') cc_error(E_BITFIELDS_ARE_NOT_SUPPORTED);
        if (!is_complete(ft)) cc_error(E_MEMBER_OF_AN_INCOMPLETE_TYPE);
        if (!name) cc_error(E_MEMBER_NEEDS_A_NAME);
        for (i = 0; i < n; ++i) if (rec_r16(CC_MEMBER_BLOCK, at + i, 0) == name) cc_error2(E_DUPLICATE_MEMBER, name);
        if (at + n == CC_MEMBERS) cc_error(E_TOO_MANY_MEMBERS);
        rec_w16(CC_MEMBER_BLOCK, at + n, 0, name); rec_w16(CC_MEMBER_BLOCK, at + n, 2, ft); member_top = at + ++n;
        if (tok.kind != ',') break;
        next();
      }
      expect(';', E_EXPECTED_AFTER_A_MEMBER_SEMI);
    }
    next();
    if (!n) cc_error(E_EMPTY_STRUCT);
    if (nfields + n > CC_FIELDS) cc_error(E_TOO_MANY_PARAMETERS_AND_MEMBERS);
    member_top = at;
    for (i = 0; i < n; ++i) {
      u16 ft = rec_r16(CC_MEMBER_BLOCK, at + i, 2), fs = ty_size(ft);
      FL_NAME_SET(nfields + i, rec_r16(CC_MEMBER_BLOCK, at + i, 0)); FL_TYPE_SET(nfields + i, ft);
      FL_OFFSET_SET(nfields + i, is_union ? 0 : size);
      if (is_union) { if (fs > size) size = fs; }
      else { if ((u32)size + fs > 0x7FFF) cc_error(E_STRUCT_TOO_LARGE); size = (u16)(size + fs); }
    }
    TY_BASE_SET(t, nfields); TY_COUNT_SET(t, n); TY_SIZE_SET(t, size); TY_QUAL_SET(t, TY_QUAL(t) | (Q_COMPLETE));
    nfields += n;
  }
  return t;
}

u16 enum_spec(void) {
  s32 v = 0;
  next();
  if (tok.kind == TK_ID) {
    u16 tag = tok.a, s = sym_find(tag, 1);
    next();
    if (!s) sym_add(tag, S_TAG, TY_INT);
    if (tok.kind != '{') return TY_INT;
  }
  expect('{', E_EXPECTED_AFTER_ENUM);
  while (tok.kind != '}') {
    u16 name, s;
    if (tok.kind != TK_ID) cc_error(E_EXPECTED_AN_ENUMERATOR);
    name = tok.a; next();
    if (tok.kind == '=') { next(); v = const_expr(); }
    if (v < -32768 || v > 32767) cc_error(E_ENUMERATOR_OUT_OF_RANGE);
    s = sym_add(name, S_ENUMC, TY_INT);
    SY_POS_SET(s, (s16)v);
    ++v;
    if (tok.kind != ',') break;
    next();
  }
  expect('}', E_EXPECTED_AFTER_ENUMERATORS);
  return TY_INT;
}
