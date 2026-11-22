// CC pass B: initializers, static data and file-scope declarations.
#define CC_PAGE parse_init
#define CC_NEED_sy_r8
#define CC_NEED_sy_r16
#define CC_NEED_sy_w8
#define CC_NEED_sy_w16
#define CC_NEED_ty_r8
#define CC_NEED_ty_r16
#define CC_NEED_fl_r16
#define CC_NEED_nd_r8
#define CC_NEED_nd_r16
#define CC_NEED_nd_r32
#include "cc_parse.h"

void pad_to(u16 off) {
  if (off > init_done) { ir_put8(IR_DFILL); ir_put16(off - init_done); init_done = off; }
}

u8 const_addr(u16 n, u16* sym, u8* is_str, s32* off) {
  u8 op = ND_OP(n); u16 a = ND_A(n), b = ND_B(n);
  switch (op) {
  case N_ADDR: {
    u8 aop = ND_OP(a); u16 y = ND_A(a), k;
    if (aop == N_STR) { *sym = y; *is_str = 1; *off = 0; return 1; }
    if (aop == N_SYM) {
      k = SY_KIND(y);
      if (k == S_GLOBAL || k == S_STATIC || k == S_FUNC) { *sym = y; *is_str = 0; *off = ND_VAL(a); return 1; }
    }
    return 0;
  }
  case N_CAST: return TK(ND_TYPE(n)) == T_PTR && TK(NT(a)) == T_PTR && const_addr(a, sym, is_str, off);
  case N_OFFSET: if (!const_addr(a, sym, is_str, off)) return 0; *off += ND_VAL(n); return 1;
  case N_ADD: case N_SUB:
    if (!IS_NUM(b) || !const_addr(a, sym, is_str, off)) return 0;
    *off += op == N_ADD ? ND_VAL(b) : -ND_VAL(b);
    return 1;
  }
  return 0;
}

void init_value(u16 off, u16 t, u16 n) {
  n = convert(n, t, E_INITIALIZER_OF_THE_WRONG_TYPE);
  if (!init_static) {
    if (nitems == CC_ITEMS) cc_error(E_INITIALIZER_TOO_LONG_FOR_A_LOCAL);
    rec_w16(CC_ITEM_BLOCK, nitems, 0, off); rec_w16(CC_ITEM_BLOCK, nitems, 2, n); ++nitems;
    return;
  }
  pad_to(off);
  if (IS_NUM(n)) {
    s32 v = ND_VAL(n); u16 size = ty_size(t);
    ir_put8(IR_DNUM); ir_put8((u8)size); ir_put16((u16)v); ir_put16((u16)((u32)v >> 16));
  } else {
    u16 sym; u8 is_str; s32 o;
    if (ty_size(t) != 2 || !const_addr(n, &sym, &is_str, &o)) cc_error(E_INITIALIZER_IS_NOT_CONSTANT);
    ir_put8(is_str ? IR_DSADDR : IR_DADDR); ir_put16(sym); ir_put16((u16)o);
  }
  init_done = (u16)(off + ty_size(t));
}

u8 init_string(u16* t, u16 off) { // a char array from a literal; returns 0 if tok isn't one
  u16 elem = TY_BASE(*t), i, n, count = TY_COUNT(*t);
  if (TK(*t) != T_ARRAY || ty_size(elem) != 1 || !ty_is_int(elem)) return 0;
  if (tok.kind != TK_STR) return 0;
  n = 0;
  {
    // copy the literal's bytes (adjacent literals joined) as char values
    while (tok.kind == TK_STR) {
      for (i = 0; i < tok.a; ++i, ++n) {
        if (count != 0xFFFF && n >= count) cc_error(E_STRING_TOO_LONG_FOR_THE_ARRAY);
        init_value((u16)(off + n), elem, num(lit_byte(&tok, i), TY_INT));
      }
      next();
    }
  }
  if (count == 0xFFFF) { *t = ty_array(elem, (u16)(n + 1)); count = (u16)(n + 1); }
  if (n < count) init_value((u16)(off + n), elem, num(0, TY_INT)); // the terminator, if it fits
  return 1;
}

u16 init_elided(u16 t, u16 off) { // an aggregate without its own braces
  u16 k, count, elem, canon;
  if (TK(t) == T_ARRAY) {
    count = TY_COUNT(t); elem = TY_BASE(t);
    if (count == 0xFFFF) cc_error(E_UNSIZED_ARRAY_NEEDS_BRACES);
    for (k = 0; k < count; ++k) {
      if (k) { if (tok.kind != ',' || peek()->kind == '}') break; next(); }
      init_any(elem, (u16)(off + cc_mul16(k, ty_size(elem))));
    }
  } else {
    canon = TY_EXTRA(t);
    for (k = 0; k < (TK(t) == T_UNION ? 1 : TY_COUNT(canon)); ++k) {
      u16 f = TY_BASE(canon) + k;
      if (k) { if (tok.kind != ',' || peek()->kind == '}') break; next(); }
      init_any(FL_TYPE(f), (u16)(off + FL_OFFSET(f)));
    }
  }
  return t;
}

u16 init_any(u16 t, u16 off) { // returns the type (an unsized array gets its size)
  enter();
  if (TK(t) == T_ARRAY && init_string(&t, off)) { leave(); return t; }
  if (TK(t) == T_ARRAY || TK(t) == T_STRUCT || TK(t) == T_UNION) {
    u16 k = 0, elem = TY_BASE(t), count = TY_COUNT(t), canon = TY_EXTRA(t);
    if (tok.kind != '{') { if (TK(t) == T_ARRAY && count == 0xFFFF) cc_error(E_UNSIZED_ARRAY_NEEDS_BRACES); t = init_elided(t, off); leave(); return t; }
    next();
    if (TK(t) == T_ARRAY && tok.kind == TK_STR && init_string(&t, off)) {
      if (tok.kind == ',') next();
      expect('}', E_EXPECTED_AFTER_THE_STRING);
      leave(); return t;
    }
    while (tok.kind != '}') {
      if (tok.kind == '.' || tok.kind == '[') cc_error(E_DESIGNATED_INITIALIZERS_ARE_NOT_SUPPOR);
      if (TK(t) == T_ARRAY) {
        if (count != 0xFFFF && k >= count) cc_error(E_TOO_MANY_INITIALIZERS);
        init_any(elem, (u16)(off + cc_mul16(k, ty_size(elem))));
      } else {
        if (k >= (TK(t) == T_UNION ? 1 : TY_COUNT(canon))) cc_error(E_TOO_MANY_INITIALIZERS);
        init_any(FL_TYPE(TY_BASE(canon) + k), (u16)(off + FL_OFFSET(TY_BASE(canon) + k)));
      }
      ++k;
      if (tok.kind != ',') break;
      next();
    }
    expect('}', E_EXPECTED_AFTER_INITIALIZERS);
    if (TK(t) == T_ARRAY && count == 0xFFFF) { if (!k) cc_error(E_EMPTY_INITIALIZER); t = ty_array(elem, k); }
    leave(); return t;
  }
  if (tok.kind == '{') {
    next(); init_value(off, t, assign());
    if (tok.kind == ',') next();
    expect('}', E_EXPECTED_AFTER_THE_INITIALIZER);
  } else init_value(off, t, assign());
  leave();
  return t;
}

u8 rom_type(u16 t) { // static objects of const (not volatile) type live in ROM
  while (TK(t) == T_ARRAY) t = TY_BASE(t);
  return (TY_QUAL(t) & (Q_CONST | Q_VOLATILE)) == Q_CONST;
}

void data_sink(u8 sink, u16 sym) { ir_put8(IR_DSINK); ir_put8(sink); if (sym) { ir_put8(IR_DNAME); ir_put16(sym); } }

// storage for a global or static local; with an initializer if tok is '='

void define_static(u16 s) {
  u16 t = SY_TYPE(s), end = 0;
  if (tok.kind != '=') {
    if (!is_complete(t)) cc_error2(E_STORAGE_SIZE_UNKNOWN, SY_NAME(s));
    data_sink(SINK_BSS, s);
    ir_put8(IR_DRES); ir_put16(ty_size(t));
    SY_DEFINED_SET(s, 2);
    return;
  }
  next();
  init_static = 1; init_done = 0;
  if (rom_type(t)) data_sink(SINK_RODATA, s);
  else {
    data_sink(SINK_INIT, 0);
    end = gen_label();
    ir_put8(IR_DINIT); ir_put16(s); ir_put16(end);
  }
  t = init_any(t, 0);
  SY_TYPE_SET(s, t);
  if (!is_complete(t)) cc_error(E_STORAGE_SIZE_UNKNOWN);
  pad_to(ty_size(t));
  if (end) {
    ir_put8(IR_DLABEL); ir_put16(end);
    data_sink(SINK_DATA, s);
    ir_put8(IR_DRES); ir_put16(ty_size(t));
  }
  init_static = 0;
  SY_DEFINED_SET(s, 2);
}

u16 declare_global(u16 name, u16 t, u8 storage) { // file scope, or extern in a block
  u16 s = sym_find(name, 0);
  u8 link = storage == KW_STATIC ? L_INTERNAL : L_EXTERN;
  u8 kind = TK(t) == T_FUNC ? S_FUNC : S_GLOBAL;
  if (s && (SY_KIND(s) == S_GLOBAL || SY_KIND(s) == S_FUNC) && (SY_DEPTH(s) == 0 || storage == KW_EXTERN)) {
    if (SY_KIND(s) != kind || !ty_same(SY_TYPE(s), t)) {
      if (!(kind == S_GLOBAL && TK(t) == T_ARRAY && TK(SY_TYPE(s)) == T_ARRAY && ty_same(TY_BASE(t), TY_BASE(SY_TYPE(s)))))
        cc_error2(E_DECLARED_DIFFERENTLY_BEFORE, name);
      if (TY_COUNT(t) != 0xFFFF) SY_TYPE_SET(s, t);
    }
    if (storage == KW_STATIC && SY_LINKAGE(s) == L_EXTERN) cc_error2(E_STATIC_AFTER_A_NON_STATIC_DECLARATION, name);
    if (block_depth && SY_DEPTH(s) != block_depth) { // make it visible in this block too
      u16 c = sym_add(name, kind, SY_TYPE(s));
      SY_POS_SET(c, SY_POS(s)); SY_LABEL_SET(c, SY_LABEL(s)); SY_LINKAGE_SET(c, SY_LINKAGE(s));
      SY_DEFINED_SET(c, 3); // an alias: the file-scope symbol is the one defined
      return c;
    }
    return s;
  }
  s = sym_add(name, kind, t);
  SY_LINKAGE_SET(s, link);
  if (block_depth) SY_DEPTH_SET(s, block_depth);
  return s;
}
