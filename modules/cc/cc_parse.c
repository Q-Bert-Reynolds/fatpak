// CC's parser: declarations, types, statements and expressions. Statements are generated
// as they are parsed (cc_gen.c); each full expression becomes a typed tree in `nodes`,
// with constants folded and C99's promotions and conversions made explicit, and the tree
// is released once its code is written.
#include "cc_int.h"
#include <setjmp.h>

Type types[CC_TYPES];
Field fields[CC_FIELDS];
Sym syms[CC_SYMS];
Node nodes[CC_NODES];
static u16 ntypes, nfields, nsyms, nnodes;
static jmp_buf on_error;
static Tok tok, ahead;
static u8 has_ahead, lexing, nesting, block_depth;
static u16 func_sym;
static u16 brk_label, cont_label;
static s16 brk_depth, cont_depth;
static u16 block_bytes; // locals allocated by the innermost block so far
static u8 failed;

// ---- diagnostics ----
static void diag(u8 error, const char* message, u16 name) {
  char buf[160]; u16 n = 0; u8 len, file = lexing ? lex_file : tok.file; u16 line = lexing ? lex_line : tok.line;
  while (*message && n < 100) buf[n++] = *message++;
  if (name) {
    const char* s = name_text(name, &len);
    buf[n++] = ':'; buf[n++] = ' ';
    while (len-- && n < sizeof(buf) - 1) buf[n++] = *s++;
  }
  buf[n] = 0;
  cc_host_diag(error, cc_host_name(file), line, 0, buf);
}
void cc_error(const char* message) { diag(1, message, 0); failed = 1; longjmp(on_error, 1); }
void cc_error2(const char* message, u16 name) { diag(1, message, name); failed = 1; longjmp(on_error, 1); }
void cc_warn(const char* message) { diag(0, message, 0); }
static void enter(void) { if (++nesting > CC_DEPTH) cc_error("nested too deeply"); }
#define leave() (--nesting)

// ---- tokens ----
static void next(void) {
  if (has_ahead) { tok = ahead; has_ahead = 0; return; }
  lexing = 1; pp_next(&tok); lexing = 0;
}
static Tok* peek(void) {
  if (!has_ahead) { lexing = 1; pp_next(&ahead); lexing = 0; has_ahead = 1; }
  return &ahead;
}
static u8 is_kw(u8 k) { return tok.kind == TK_ID && tok.a == k; }
static void expect(u8 kind, const char* message) { if (tok.kind != kind) cc_error(message); next(); }

// ---- types ----
u16 ty_size(u16 t) {
  switch (TK(t)) {
  case T_BOOL: case T_CHAR: case T_SCHAR: case T_UCHAR: return 1;
  case T_INT: case T_UINT: case T_PTR: return 2;
  case T_LONG: case T_ULONG: return 4;
  case T_ARRAY: return types[t].size;
  case T_STRUCT: case T_UNION: return types[types[t].extra].size;
  }
  return 0;
}
u8 ty_is_int(u16 t) { return TK(t) >= T_BOOL && TK(t) <= T_ULONG; }
u8 ty_is_signed(u16 t) { u8 k = TK(t); return k == T_SCHAR || k == T_INT || k == T_LONG; }
u8 ty_is_scalar(u16 t) { return ty_is_int(t) || TK(t) == T_PTR; }
static u8 is_complete(u16 t) {
  u8 k = TK(t);
  if (k == T_VOID || k == T_FUNC) return 0;
  if (k == T_ARRAY) return types[t].count != 0xFFFF;
  if (k == T_STRUCT || k == T_UNION) return (types[types[t].extra].qual & Q_COMPLETE) != 0;
  return 1;
}
static u16 ty_new(u8 kind, u8 qual, u16 base, u16 count, u16 extra, u16 size) {
  Type* t;
  if (ntypes == CC_TYPES) cc_error("too many types");
  t = &types[ntypes];
  t->kind = kind; t->qual = qual; t->base = base; t->count = count; t->extra = extra; t->size = size;
  return ntypes++;
}
static u16 ty_find(u8 kind, u8 qual, u16 base, u16 count, u16 extra, u16 size) {
  u16 i;
  for (i = 1; i < ntypes; ++i) {
    Type* t = &types[i];
    if (t->kind == kind && t->qual == qual && t->base == base && t->count == count && t->extra == extra && t->size == size) return i;
  }
  return ty_new(kind, qual, base, count, extra, size);
}
static u16 ty_ptr(u16 base) { return ty_find(T_PTR, 0, base, 0, 0, 2); }
static u16 ty_array(u16 base, u16 count) {
  u32 size = count == 0xFFFF ? 0 : (u32)count * ty_size(base);
  if (size > 0x7FFF) cc_error("array too large");
  return ty_find(T_ARRAY, 0, base, count, 0, (u16)size);
}
static u16 ty_qual(u16 t, u8 q) {
  Type* y = &types[t]; u8 nq;
  if (!q) return t;
  if (y->kind == T_ARRAY) return ty_array(ty_qual(y->base, q), y->count);
  nq = (u8)((y->qual | q) & (Q_CONST | Q_VOLATILE));
  if (y->kind == T_STRUCT || y->kind == T_UNION) return ty_find(y->kind, nq, 0, 0, y->extra, 0);
  return ty_find(y->kind, nq, y->base, y->count, y->extra, y->size);
}
static u16 ty_unqual(u16 t) {
  Type* y = &types[t];
  if (!(y->qual & (Q_CONST | Q_VOLATILE))) return t;
  if (y->kind == T_STRUCT || y->kind == T_UNION) return y->extra;
  if (t < TY_BASIC) return t;
  return ty_find(y->kind, 0, y->base, y->count, y->extra, y->size);
}
static u8 ty_same(u16 a, u16 b) {
  Type *x = &types[a], *y = &types[b]; u16 i;
  if (a == b) return 1;
  if (x->kind != y->kind || ((x->qual ^ y->qual) & (Q_CONST | Q_VOLATILE))) return 0;
  switch (x->kind) {
  case T_PTR: return ty_same(x->base, y->base);
  case T_ARRAY: return ty_same(x->base, y->base) && (x->count == y->count || x->count == 0xFFFF || y->count == 0xFFFF);
  case T_STRUCT: case T_UNION: return x->extra == y->extra;
  case T_FUNC:
    if (!ty_same(x->base, y->base) || x->count != y->count) return 0;
    for (i = 0; i < x->count; ++i) if (!ty_same(ty_unqual(fields[x->extra + i].type), ty_unqual(fields[y->extra + i].type))) return 0;
    return 1;
  }
  return 1;
}
static u16 promote(u16 t) { u8 k = TK(t); return k >= T_BOOL && k <= T_UCHAR ? TY_INT : ty_unqual(t); }
static u16 arith(u16 a, u16 b) {
  u8 x = TK(promote(a)), y = TK(promote(b));
  if (x == T_ULONG || y == T_ULONG) return TY_ULONG;
  if (x == T_LONG || y == T_LONG) return TY_LONG;
  if (x == T_UINT || y == T_UINT) return TY_UINT;
  return TY_INT;
}

// ---- symbols ----
static u16 sym_find(u16 name, u8 tag) {
  u16 i = nsyms;
  while (i-- > 1) if (syms[i].name == name && (syms[i].kind == S_TAG) == tag) return i;
  return 0;
}
static u16 sym_add(u16 name, u8 kind, u16 type) {
  Sym* s; u16 old = sym_find(name, kind == S_TAG);
  if (old && syms[old].depth == block_depth && name) cc_error2("already declared", name);
  if (nsyms == CC_SYMS) cc_error("too many symbols");
  s = &syms[nsyms];
  s->name = name; s->kind = kind; s->type = type; s->pos = 0; s->label = 0; s->linkage = L_NONE; s->defined = 0; s->depth = block_depth;
  return nsyms++;
}
static u8 is_typedef_name(const Tok* t) {
  u16 s;
  if (t->kind != TK_ID || t->a < KW_COUNT) return 0;
  s = sym_find(t->a, 0);
  return s && syms[s].kind == S_TYPEDEF;
}
static u8 starts_type(const Tok* t) {
  if (t->kind != TK_ID) return 0;
  switch (t->a) {
  case KW_VOID: case KW_CHAR: case KW_SHORT: case KW_INT: case KW_LONG: case KW_SIGNED: case KW_UNSIGNED:
  case KW_BOOL: case KW_CONST: case KW_VOLATILE: case KW_STRUCT: case KW_UNION: case KW_ENUM:
  case KW_STATIC: case KW_EXTERN: case KW_TYPEDEF: case KW_AUTO: case KW_REGISTER: case KW_INLINE:
  case KW_RESTRICT: case KW_FLOAT: case KW_DOUBLE: return 1;
  }
  return is_typedef_name(t);
}

// ---- nodes ----
static s32 norm(s32 v, u16 t) {
  switch (TK(t)) {
  case T_BOOL: return v != 0;
  case T_CHAR: case T_UCHAR: return v & 0xFF;
  case T_SCHAR: return (s32)(int8_t)(v & 0xFF);
  case T_INT: return (s32)(int16_t)(v & 0xFFFF);
  case T_UINT: case T_PTR: return v & 0xFFFF;
  }
  return v;
}
static u16 nd(u8 op, u16 type, u16 a, u16 b) {
  Node* n;
  if (nnodes == CC_NODES) cc_error("expression too large");
  n = &nodes[nnodes];
  n->op = op; n->flags = 0; n->type = type; n->a = a; n->b = b; n->c = 0; n->val = 0;
  return nnodes++;
}
static u16 num(s32 v, u16 type) { u16 n = nd(N_NUM, type, 0, 0); nodes[n].val = norm(v, type); return n; }
#define IS_NUM(n) (nodes[n].op == N_NUM)
#define NT(n) (nodes[n].type)
static u8 is_null(u16 n) { return IS_NUM(n) && ty_is_int(NT(n)) && nodes[n].val == 0; }
static u8 is_lvalue(u16 n) { u8 op = nodes[n].op; return (op == N_SYM && TK(NT(n)) != T_FUNC) || op == N_DEREF || op == N_STR; }

static u16 rval(u16 n) { // arrays and functions decay to pointers
  u8 k = TK(NT(n));
  if (k == T_ARRAY) {
    u16 pt = ty_ptr(types[NT(n)].base);
    if (nodes[n].op == N_DEREF) { u16 p = nodes[n].a; return IS_NUM(p) ? num(nodes[p].val, pt) : nd(N_CAST, pt, p, 0); }
    return nd(N_ADDR, pt, n, 0);
  }
  if (k == T_FUNC) return nd(N_ADDR, ty_ptr(NT(n)), n, 0);
  return n;
}
static u16 cast(u16 n, u16 t) {
  u16 f = NT(n);
  t = ty_unqual(t);
  if (TK(t) == T_VOID) return nd(N_CAST, TY_VOID, n, 0);
  if (!ty_is_scalar(t)) { if (ty_same(ty_unqual(f), t)) return n; cc_error("can't convert to that type"); }
  if (!ty_is_scalar(f)) cc_error("can't convert a non-scalar value");
  if (IS_NUM(n)) return num(nodes[n].val, t);
  if (ty_unqual(f) == t) return n;
  return nd(N_CAST, t, n, 0);
}
static u16 fold_bin(u8 op, u16 t, s32 a, s32 b) {
  u8 u = !ty_is_signed(t);
  u32 x = (u32)a, y = (u32)b; s32 r = 0;
  switch (op) {
  case N_ADD: r = (s32)(x + y); break;
  case N_SUB: r = (s32)(x - y); break;
  case N_MUL: r = (s32)(x * y); break;
  case N_DIV: case N_MOD:
    if (!b) cc_error("division by zero");
    if (u) r = (s32)(op == N_DIV ? x / y : x % y);
    else if (a == (s32)0x80000000l && b == -1) r = op == N_DIV ? a : 0;
    else r = op == N_DIV ? a / b : a % b;
    break;
  case N_SHL: if (b < 0 || b >= (s32)ty_size(t) * 8) cc_error("shift count out of range"); r = (s32)(x << b); break;
  case N_SHR: if (b < 0 || b >= (s32)ty_size(t) * 8) cc_error("shift count out of range"); r = u ? (s32)(x >> b) : (a < 0 ? ~(~a >> b) : a >> b); break;
  case N_AND: r = a & b; break;
  case N_OR: r = a | b; break;
  case N_XOR: r = a ^ b; break;
  }
  return num(r, t);
}
static u16 compare(u8 op, u16 l, u16 r) {
  u16 t;
  l = rval(l); r = rval(r);
  if (TK(NT(l)) == T_PTR || TK(NT(r)) == T_PTR) {
    if (TK(NT(l)) == T_PTR && TK(NT(r)) == T_PTR) t = TY_UINT;
    else if (TK(NT(l)) == T_PTR && is_null(r)) r = cast(r, NT(l));
    else if (TK(NT(r)) == T_PTR && is_null(l)) l = cast(l, NT(r));
    else cc_error("comparing a pointer with an integer");
    t = TY_UINT;
  } else {
    if (!ty_is_int(NT(l)) || !ty_is_int(NT(r))) cc_error("comparing non-scalar values");
    t = arith(NT(l), NT(r));
    l = cast(l, t); r = cast(r, t);
  }
  if (IS_NUM(l) && IS_NUM(r)) {
    s32 a = nodes[l].val, b = nodes[r].val; u8 u = !ty_is_signed(t), v = 0;
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
static u16 scale(u16 n, u16 ptr) { // an integer index times the pointed-to size, as an int
  u16 size = ty_size(types[ptr].base);
  if (!is_complete(types[ptr].base)) { if (TK(types[ptr].base) == T_VOID) size = 1; else cc_error("arithmetic on a pointer to an incomplete type"); }
  n = cast(n, ty_is_signed(NT(n)) ? TY_INT : TY_UINT);
  if (size == 1) return n;
  if (IS_NUM(n)) return num(nodes[n].val * size, NT(n));
  return nd(N_MUL, NT(n), n, num(size, NT(n)));
}
static u16 binop(u8 op, u16 l, u16 r) {
  u16 t, lt, rt;
  if (op >= N_LT && op <= N_NE) return compare(op, l, r);
  l = rval(l); r = rval(r); lt = NT(l); rt = NT(r);
  if (op == N_ADD || op == N_SUB) {
    if (TK(lt) == T_PTR && ty_is_int(rt)) {
      r = scale(r, lt);
      if (IS_NUM(r) && !nodes[r].val) return l;
      if (IS_NUM(l) && IS_NUM(r)) return fold_bin(op, lt, nodes[l].val, nodes[r].val);
      return nd(op, lt, l, r);
    }
    if (op == N_ADD && ty_is_int(lt) && TK(rt) == T_PTR) return binop(op, r, l);
    if (op == N_SUB && TK(lt) == T_PTR && TK(rt) == T_PTR) {
      u16 size = ty_size(types[lt].base), d;
      if (!ty_same(ty_unqual(types[lt].base), ty_unqual(types[rt].base))) cc_error("subtracting pointers to different types");
      if (!size) size = 1;
      d = nd(N_SUB, TY_INT, l, r);
      return size == 1 ? d : nd(N_DIV, TY_INT, d, num(size, TY_INT));
    }
  }
  if (!ty_is_int(lt) || !ty_is_int(rt)) cc_error("invalid operands");
  if (op == N_SHL || op == N_SHR) { t = promote(lt); r = cast(r, TY_INT); }
  else { t = arith(lt, rt); r = cast(r, t); }
  l = cast(l, t);
  if (IS_NUM(l) && IS_NUM(r)) return fold_bin(op, t, nodes[l].val, nodes[r].val);
  if ((op == N_DIV || op == N_MOD) && IS_NUM(r) && !nodes[r].val) cc_error("division by zero");
  if ((op == N_SHL || op == N_SHR) && IS_NUM(r) && (nodes[r].val < 0 || nodes[r].val >= (s32)ty_size(t) * 8)) cc_error("shift count out of range");
  return nd(op, t, l, r);
}
static u16 convert(u16 n, u16 t, const char* what) { // as if by assignment
  u16 f;
  n = rval(n); f = NT(n);
  if (TK(t) == T_STRUCT || TK(t) == T_UNION) {
    if (!ty_same(ty_unqual(f), ty_unqual(t))) cc_error(what);
    return n;
  }
  if (TK(t) == T_PTR) {
    if (TK(f) == T_PTR) {
      u16 a = types[t].base, b = types[f].base;
      if (TK(a) != T_VOID && TK(b) != T_VOID && !ty_same(ty_unqual(a), ty_unqual(b))) cc_warn("incompatible pointer types");
      else if (types[b].qual & ~types[a].qual & (Q_CONST | Q_VOLATILE)) cc_warn("conversion drops a qualifier");
    } else if (!is_null(n)) cc_error("integer converted to a pointer without a cast");
    return cast(n, t);
  }
  if (ty_is_int(t)) {
    if (TK(f) == T_PTR && TK(t) != T_BOOL) cc_error("pointer converted to an integer without a cast");
    if (TK(f) == T_PTR) return compare(N_NE, n, num(0, TY_INT));
    if (!ty_is_int(f)) cc_error(what);
    return cast(n, t);
  }
  cc_error(what);
  return n;
}
static void need_lvalue(u16 n) {
  u16 t = NT(n);
  if (!is_lvalue(n)) cc_error("not an lvalue");
  if (TK(t) == T_ARRAY) cc_error("can't assign to an array");
  if (types[t].qual & Q_CONST) cc_error("assignment to a const object");
}
static u16 deref(u16 p) {
  u16 t;
  p = rval(p); t = NT(p);
  if (TK(t) != T_PTR) cc_error("dereferencing a non-pointer");
  if (nodes[p].op == N_ADDR && TK(NT(nodes[p].a)) != T_ARRAY) return nodes[p].a; // not a decayed array
  if (TK(types[t].base) == T_VOID) cc_error("dereferencing a void pointer");
  return nd(N_DEREF, types[t].base, p, 0);
}
static u16 address(u16 n) {
  if (nodes[n].op == N_DEREF) return nodes[n].a;
  if (!is_lvalue(n) && TK(NT(n)) != T_FUNC) cc_error("can't take that address");
  return nd(N_ADDR, ty_ptr(NT(n)), n, 0);
}

// ---- expressions ----
static u16 expr(void);
static u16 assign(void);
static u16 cond_expr(void);
static u16 unary(void);
static u16 type_name(void);
static u16 str_label;
static u16 string_literal(void) { // adjacent literals joined; emitted to the unit's strings now
  u16 label = gen_label(), len = 0, i, n;
  u8 first = 1;
  gen_sink(SINK_STR);
  out_str(SINK_STR, "__"); out_str(SINK_STR, cg_unit); out_str(SINK_STR, "__"); out_num(SINK_STR, label); out_str(SINK_STR, ":");
  while (tok.kind == TK_STR) {
    for (i = 0; i < tok.a; ++i) {
      if (!(len & 15)) out_str(SINK_STR, first ? "\n\tDB " : "\n\tDB ");
      else out_str(SINK_STR, ", ");
      out_num(SINK_STR, lit_byte(&tok, i)); ++len; first = 0;
    }
    next();
  }
  out_str(SINK_STR, len & 15 ? ", 0\n" : "\n\tDB 0\n");
  if (len >= 0x7FFF) cc_error("string too long");
  n = nd(N_STR, ty_array(TY_CHAR, (u16)(len + 1)), label, 0);
  str_label = label;
  return n;
}
static u16 primary(void) {
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
    next(); n = expr(); expect(')', "expected )"); return n;
  case TK_ID:
    if (tok.a < KW_COUNT && tok.a) cc_error2("unexpected keyword", tok.a);
    s = sym_find(tok.a, 0);
    if (!s) cc_error2("undeclared", tok.a);
    next();
    switch (syms[s].kind) {
    case S_ENUMC: return num(syms[s].pos, TY_INT);
    case S_TYPEDEF: cc_error2("unexpected type name", syms[s].name);
    }
    n = nd(N_SYM, syms[s].type, s, 0);
    return n;
  }
  cc_error("expected an expression");
  return 0;
}
static u16 member(u16 n, u8 arrow) {
  u16 t, canon, i, name, ft;
  if (arrow) { n = rval(n); if (TK(NT(n)) != T_PTR) cc_error("-> needs a pointer"); t = types[NT(n)].base; }
  else t = NT(n);
  if (TK(t) != T_STRUCT && TK(t) != T_UNION) cc_error("member of a non-struct");
  if (!is_complete(t)) cc_error("incomplete struct");
  if (tok.kind != TK_ID) cc_error("expected a member name");
  name = tok.a; next();
  canon = types[t].extra;
  for (i = 0; i < types[canon].count; ++i) if (fields[types[canon].base + i].name == name) break;
  if (i == types[canon].count) cc_error2("no such member", name);
  i += types[canon].base;
  ft = ty_qual(fields[i].type, types[t].qual & (Q_CONST | Q_VOLATILE));
  if (arrow) {
    u16 o;
    if (IS_NUM(n)) o = num(nodes[n].val + fields[i].offset, ty_ptr(ft)); // offsetof's null pointer
    else { o = nd(N_OFFSET, ty_ptr(ft), n, 0); nodes[o].val = fields[i].offset; }
    return nd(N_DEREF, ft, o, 0);
  }
  if (nodes[n].op == N_SYM) { u16 m = nd(N_SYM, ft, nodes[n].a, 0); nodes[m].val = nodes[n].val + fields[i].offset; return m; }
  if (nodes[n].op == N_DEREF) {
    u16 p = nodes[n].a, o = nd(N_OFFSET, ty_ptr(ft), p, 0);
    nodes[o].val = fields[i].offset;
    return nd(N_DEREF, ft, o, 0);
  }
  cc_error("member of a value that isn't an lvalue");
  return 0;
}
static u16 call(u16 fn) {
  u16 ft, first = 0, last = 0, i = 0, n;
  if (TK(NT(fn)) == T_FUNC) ft = NT(fn);
  else { fn = rval(fn); if (TK(NT(fn)) != T_PTR || TK(types[NT(fn)].base) != T_FUNC) cc_error("calling a non-function"); ft = types[NT(fn)].base; }
  next(); // (
  if (tok.kind != ')') for (;;) {
    u16 a = assign(), arg;
    if (i >= types[ft].count) cc_error("too many arguments");
    a = convert(a, fields[types[ft].extra + i].type, "argument of the wrong type");
    if (TK(NT(a)) == T_STRUCT || TK(NT(a)) == T_UNION) cc_error("struct arguments are not supported");
    arg = nd(N_ARG, NT(a), a, 0);
    if (last) nodes[last].b = arg; else first = arg;
    last = arg; ++i;
    if (tok.kind != ',') break;
    next();
  }
  expect(')', "expected ) after arguments");
  if (i < types[ft].count) cc_error("too few arguments");
  if (TK(types[ft].base) == T_STRUCT || TK(types[ft].base) == T_UNION) cc_error("struct return values are not supported");
  n = nd(N_CALL, ty_unqual(types[ft].base), fn, first);
  return n;
}
static u16 incdec(u8 op, u16 n) {
  u16 t = NT(n), r;
  need_lvalue(n);
  if (!ty_is_scalar(t)) cc_error("++/-- needs a scalar");
  r = nd(op, ty_unqual(t), n, 0);
  nodes[r].val = 1;
  if (TK(t) == T_PTR) { nodes[r].val = ty_size(types[t].base); if (!nodes[r].val) { if (TK(types[t].base) == T_VOID) nodes[r].val = 1; else cc_error("++/-- on a pointer to an incomplete type"); } }
  return r;
}
static u16 postfix(u16 n) {
  for (;;) {
    switch (tok.kind) {
    case '[': next(); n = deref(binop(N_ADD, n, expr())); expect(']', "expected ]"); continue;
    case '(': n = call(n); continue;
    case '.': next(); n = member(n, 0); continue;
    case TK_ARROW: next(); n = member(n, 1); continue;
    case TK_INC: next(); n = incdec(N_POSTINC, n); continue;
    case TK_DEC: next(); n = incdec(N_POSTDEC, n); continue;
    }
    return n;
  }
}
static u16 unary(void) {
  u16 n, t; u8 k = tok.kind;
  enter();
  if (k == '(' && starts_type(peek())) {
    next(); t = type_name(); expect(')', "expected ) after the type");
    if (tok.kind == '{') cc_error("compound literals are not supported");
    n = unary();
    n = rval(n);
    if (TK(t) != T_VOID && !ty_is_scalar(t)) cc_error("cast to a non-scalar type");
    n = cast(n, t);
    leave(); return n;
  }
  if (is_kw(KW_SIZEOF)) {
    u16 mark = nnodes, size;
    next();
    if (tok.kind == '(' && starts_type(peek())) { next(); t = type_name(); expect(')', "expected ) after the type"); }
    else { n = unary(); t = NT(n); nnodes = mark; }
    if (!is_complete(t)) cc_error("sizeof an incomplete type");
    size = ty_size(t);
    leave(); return num(size, TY_UINT);
  }
  switch (k) {
  case TK_INC: next(); n = incdec(N_PREINC, unary()); break;
  case TK_DEC: next(); n = incdec(N_PREDEC, unary()); break;
  case '&': next(); n = unary(); n = address(n); break;
  case '*': next(); n = unary(); n = rval(n); if (TK(NT(n)) == T_PTR && TK(types[NT(n)].base) == T_FUNC) break; n = deref(n); break;
  case '+': case '-': case '~':
    next(); n = rval(unary());
    if (!ty_is_int(NT(n))) cc_error("arithmetic on a non-integer");
    t = promote(NT(n)); n = cast(n, t);
    if (k == '+') break;
    if (IS_NUM(n)) { n = num(k == '-' ? (s32)(0u - (u32)nodes[n].val) : ~nodes[n].val, t); break; }
    n = nd(k == '-' ? N_NEG : N_BNOT, t, n, 0);
    break;
  case '!':
    next(); n = rval(unary());
    if (!ty_is_scalar(NT(n))) cc_error("! needs a scalar");
    if (IS_NUM(n)) { n = num(!nodes[n].val, TY_INT); break; }
    n = nd(N_LNOT, TY_INT, n, 0);
    break;
  default: n = postfix(primary());
  }
  leave();
  return n;
}
static u8 bin_prec(u8 k, u8* op) {
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
static u16 binary(u8 min) {
  u16 l = unary();
  for (;;) {
    u8 op, p = bin_prec(tok.kind, &op);
    u16 r;
    if (!p || p <= min) return l;
    next();
    enter(); r = binary(p); leave();
    if (op == N_LAND || op == N_LOR) {
      l = rval(l); r = rval(r);
      if (!ty_is_scalar(NT(l)) || !ty_is_scalar(NT(r))) cc_error("&& and || need scalars");
      if (IS_NUM(l) && IS_NUM(r)) l = num(op == N_LAND ? (nodes[l].val && nodes[r].val) : (nodes[l].val || nodes[r].val), TY_INT);
      else l = nd(op, TY_INT, l, r);
    } else l = binop(op, l, r);
  }
}
static u16 cond_expr(void) {
  u16 c = binary(0), a, b, t, n;
  if (tok.kind != '?') return c;
  next();
  c = rval(c);
  if (!ty_is_scalar(NT(c))) cc_error("condition needs a scalar");
  enter(); a = rval(expr()); expect(':', "expected : in ?:"); b = rval(cond_expr()); leave();
  if (ty_is_int(NT(a)) && ty_is_int(NT(b))) { t = arith(NT(a), NT(b)); a = cast(a, t); b = cast(b, t); }
  else if (TK(NT(a)) == T_PTR && TK(NT(b)) == T_PTR) t = TK(types[NT(a)].base) == T_VOID ? NT(a) : NT(b);
  else if (TK(NT(a)) == T_PTR && is_null(b)) { t = NT(a); b = cast(b, t); }
  else if (TK(NT(b)) == T_PTR && is_null(a)) { t = NT(b); a = cast(a, t); }
  else if (TK(NT(a)) == T_VOID && TK(NT(b)) == T_VOID) t = TY_VOID;
  else { cc_error("?: operands have different types"); t = 0; }
  if (IS_NUM(c)) return nodes[c].val ? a : b;
  n = nd(N_COND, ty_unqual(t), c, a);
  nodes[n].c = b;
  return n;
}
static u16 assign(void) {
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
    r = convert(r, t, "assignment of the wrong type");
    return nd(N_ASSIGN, ty_unqual(t), l, r);
  }
  r = rval(r);
  if (TK(t) == T_PTR && (op == N_ADD || op == N_SUB)) {
    if (!ty_is_int(NT(r))) cc_error("pointer += needs an integer");
    r = scale(r, t);
    n = nd(N_OPASSIGN, ty_unqual(t), l, r); nodes[n].flags = op; nodes[n].c = ty_unqual(t);
    return n;
  }
  if (!ty_is_int(t) || !ty_is_int(NT(r))) cc_error("compound assignment needs integers");
  {
    u16 ct = op == N_SHL || op == N_SHR ? promote(t) : arith(t, NT(r));
    r = cast(r, op == N_SHL || op == N_SHR ? TY_INT : ct);
    if ((op == N_DIV || op == N_MOD) && IS_NUM(r) && !nodes[r].val) cc_error("division by zero");
    n = nd(N_OPASSIGN, ty_unqual(t), l, r); nodes[n].flags = op; nodes[n].c = ct;
  }
  return n;
}
static u16 expr(void) {
  u16 n = assign();
  while (tok.kind == ',') {
    u16 r;
    next(); r = assign();
    n = nd(N_COMMA, NT(rval(r)), n, rval(r));
  }
  return n;
}
static s32 const_expr(void) {
  u16 n = cond_expr();
  if (!IS_NUM(n)) cc_error("expected a constant");
  return nodes[n].val;
}

// ---- declarations ----
typedef struct { u16 type; u8 storage, is_inline; } Spec;
enum { D_PTR, D_ARRAY, D_FUNC };
typedef struct { u8 kind, qual; u16 a, b; } DOp;
static DOp dops[64];
static u8 ndops;
static u16 dcl_name;
static void push_dop(u8 kind, u8 qual, u16 a, u16 b) {
  if (ndops == 64) cc_error("declarator too complex");
  dops[ndops].kind = kind; dops[ndops].qual = qual; dops[ndops].a = a; dops[ndops].b = b; ++ndops;
}
static void declspec(Spec* s);
static u16 declarator(u16 base, u16* name);
static u16 struct_spec(void);
static u16 enum_spec(void);
static void params(void) { // after (: pushes D_FUNC
  u16 names[32], typs[32], i; u8 n = 0;
  if (is_kw(KW_VOID) && peek()->kind == ')') { next(); }
  if (tok.kind != ')') for (;;) {
    Spec s; u16 t, name = 0;
    if (tok.kind == TK_ELLIPSIS) cc_error("variadic functions are not supported");
    if (!starts_type(&tok)) cc_error("expected a parameter type");
    declspec(&s);
    if (s.storage && s.storage != KW_REGISTER) cc_error("bad storage class for a parameter");
    t = declarator(s.type, &name);
    if (TK(t) == T_ARRAY) t = ty_ptr(types[t].base);
    else if (TK(t) == T_FUNC) t = ty_ptr(t);
    if (TK(t) == T_VOID) cc_error("void parameter");
    if (TK(t) == T_STRUCT || TK(t) == T_UNION) cc_error("struct parameters are not supported");
    if (n == 32) cc_error("too many parameters");
    names[n] = name; typs[n] = t; ++n;
    if (tok.kind != ',') break;
    next();
  }
  expect(')', "expected ) after parameters");
  if (nfields + n > CC_FIELDS) cc_error("too many parameters and members");
  for (i = 0; i < n; ++i) { fields[nfields + i].name = names[i]; fields[nfields + i].type = typs[i]; fields[nfields + i].offset = 0; }
  push_dop(D_FUNC, 0, nfields, n);
  nfields += n;
}
static void dcl(void);
static void direct_dcl(void) {
  if (tok.kind == TK_ID && !is_typedef_name(&tok) && !(tok.a < KW_COUNT && tok.a)) { dcl_name = tok.a; next(); }
  else if (tok.kind == '(') {
    Tok* p = peek();
    if (p->kind == '*' || p->kind == '(' || (p->kind == TK_ID && !starts_type(p))) {
      next(); enter(); dcl(); leave(); expect(')', "expected ) in declarator");
    }
  }
  for (;;) {
    if (tok.kind == '[') {
      u16 count = 0xFFFF;
      next();
      if (tok.kind != ']') { s32 v = const_expr(); if (v <= 0 || v > 0x7FFF) cc_error("bad array size"); count = (u16)v; }
      expect(']', "expected ]");
      push_dop(D_ARRAY, 0, count, 0);
    } else if (tok.kind == '(') { next(); enter(); params(); leave(); }
    else break;
  }
}
static void dcl(void) {
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
    if (n == 16) cc_error("too many *s");
    quals[n++] = q;
  }
  direct_dcl();
  for (i = n; i-- > 0; ) push_dop(D_PTR, quals[i], 0, 0);
}
static u16 declarator(u16 base, u16* name) {
  u8 mark = ndops, i;
  u16 t = base, saved = dcl_name;
  dcl_name = 0;
  dcl();
  *name = dcl_name; dcl_name = saved;
  for (i = ndops; i-- > mark; ) {
    DOp* d = &dops[i];
    if (d->kind == D_PTR) t = ty_qual(ty_ptr(t), d->qual);
    else if (d->kind == D_ARRAY) {
      if (TK(t) == T_FUNC) cc_error("array of functions");
      if (!is_complete(t)) cc_error("array of an incomplete type");
      t = ty_array(t, d->a);
    } else {
      if (TK(t) == T_ARRAY || TK(t) == T_FUNC) cc_error("function returning an array or function");
      t = ty_new(T_FUNC, 0, t, d->b, d->a, 0);
    }
  }
  ndops = mark;
  return t;
}
static u16 type_name(void) {
  Spec s; u16 name, t;
  declspec(&s);
  if (s.storage) cc_error("storage class in a type name");
  t = declarator(s.type, &name);
  if (name) cc_error("unexpected name in a type");
  return t;
}
static void declspec(Spec* out) {
  Spec s; u8 q = 0, nvoid = 0, nchar = 0, nshort = 0, nint = 0, nlong = 0, nsigned = 0, nunsigned = 0, nbool = 0;
  u16 other = 0;
  s.storage = 0; s.is_inline = 0;
  for (;;) {
    if (tok.kind != TK_ID) break;
    switch (tok.a) {
    case KW_STATIC: case KW_EXTERN: case KW_TYPEDEF: case KW_AUTO: case KW_REGISTER:
      if (s.storage) cc_error("more than one storage class");
      s.storage = (u8)tok.a; next(); continue;
    case KW_CONST: q |= Q_CONST; next(); continue;
    case KW_VOLATILE: q |= Q_VOLATILE; next(); continue;
    case KW_RESTRICT: next(); continue;
    case KW_INLINE: s.is_inline = 1; next(); continue;
    case KW_VOID: ++nvoid; next(); continue;
    case KW_CHAR: ++nchar; next(); continue;
    case KW_SHORT: ++nshort; next(); continue;
    case KW_INT: ++nint; next(); continue;
    case KW_LONG: ++nlong; next(); continue;
    case KW_SIGNED: ++nsigned; next(); continue;
    case KW_UNSIGNED: ++nunsigned; next(); continue;
    case KW_BOOL: ++nbool; next(); continue;
    case KW_FLOAT: case KW_DOUBLE: cc_error("floating point is not supported"); continue;
    case KW_STRUCT: case KW_UNION: if (other) cc_error("two types"); other = struct_spec(); continue;
    case KW_ENUM: if (other) cc_error("two types"); other = enum_spec(); continue;
    }
    if (!other && !(nvoid | nchar | nshort | nint | nlong | nsigned | nunsigned | nbool) && is_typedef_name(&tok)) {
      other = syms[sym_find(tok.a, 0)].type; next(); continue;
    }
    break;
  }
  if (nlong > 1) cc_error("long long is not supported");
  if (other) {
    if (nvoid | nchar | nshort | nint | nlong | nsigned | nunsigned | nbool) cc_error("two types");
    s.type = other;
  } else if (nvoid) { if (nvoid > 1 || nchar | nshort | nint | nlong | nsigned | nunsigned | nbool) cc_error("bad type"); s.type = TY_VOID; }
  else if (nbool) { if (nbool > 1 || nchar | nshort | nint | nlong | nsigned | nunsigned) cc_error("bad type"); s.type = TY_BOOL; }
  else if (nsigned && nunsigned) { cc_error("signed and unsigned"); s.type = 0; }
  else if (nchar) { if (nchar > 1 || nshort | nint | nlong) cc_error("bad type"); s.type = nsigned ? TY_SCHAR : nunsigned ? TY_UCHAR : TY_CHAR; }
  else if (nshort) { if (nshort > 1 || nlong || nint > 1) cc_error("bad type"); s.type = nunsigned ? TY_UINT : TY_INT; }
  else if (nlong) { if (nint > 1) cc_error("bad type"); s.type = nunsigned ? TY_ULONG : TY_LONG; }
  else if (nint || nsigned || nunsigned) { if (nint > 1) cc_error("bad type"); s.type = nunsigned ? TY_UINT : TY_INT; }
  else { cc_error("expected a type"); s.type = 0; }
  s.type = ty_qual(s.type, q);
  *out = s;
}
static u16 struct_spec(void) {
  u8 is_union = is_kw(KW_UNION), kind = is_union ? T_UNION : T_STRUCT;
  u16 tag = 0, s = 0, t;
  next();
  if (tok.kind == TK_ID) { tag = tok.a; next(); }
  if (tag) {
    s = sym_find(tag, 1);
    if (s && TK(syms[s].type) != kind) cc_error2("tag is a different kind", tag);
    if (s && tok.kind == '{' && syms[s].depth != block_depth) s = 0; // a new one shadows it
  }
  if (!s) {
    if (!tag && tok.kind != '{') cc_error("struct needs a tag or members");
    t = ty_new(kind, 0, 0, 0, 0, 0); types[t].extra = t;
    if (tag) { s = sym_add(tag, S_TAG, t); }
  } else t = syms[s].type;
  if (tok.kind != '{') return t;
  if (types[t].qual & Q_COMPLETE) cc_error2("struct defined twice", tag);
  next();
  {
    u16 names[64], typs[64], i; u8 n = 0; u16 size = 0;
    while (tok.kind != '}') {
      Spec sp;
      declspec(&sp);
      if (sp.storage) cc_error("storage class in a struct");
      for (;;) {
        u16 name, ft = declarator(sp.type, &name);
        if (tok.kind == ':') cc_error("bitfields are not supported");
        if (!is_complete(ft)) cc_error("member of an incomplete type");
        if (!name) cc_error("member needs a name");
        for (i = 0; i < n; ++i) if (names[i] == name) cc_error2("duplicate member", name);
        if (n == 64) cc_error("too many members");
        names[n] = name; typs[n] = ft; ++n;
        if (tok.kind != ',') break;
        next();
      }
      expect(';', "expected ; after a member");
    }
    next();
    if (!n) cc_error("empty struct");
    if (nfields + n > CC_FIELDS) cc_error("too many parameters and members");
    for (i = 0; i < n; ++i) {
      u16 fs = ty_size(typs[i]);
      fields[nfields + i].name = names[i]; fields[nfields + i].type = typs[i];
      fields[nfields + i].offset = is_union ? 0 : size;
      if (is_union) { if (fs > size) size = fs; }
      else { if ((u32)size + fs > 0x7FFF) cc_error("struct too large"); size = (u16)(size + fs); }
    }
    types[t].base = nfields; types[t].count = n; types[t].size = size; types[t].qual |= Q_COMPLETE;
    nfields += n;
  }
  return t;
}
static u16 enum_spec(void) {
  s32 v = 0;
  next();
  if (tok.kind == TK_ID) {
    u16 tag = tok.a, s = sym_find(tag, 1);
    next();
    if (!s) sym_add(tag, S_TAG, TY_INT);
    if (tok.kind != '{') return TY_INT;
  }
  expect('{', "expected { after enum");
  while (tok.kind != '}') {
    u16 name, s;
    if (tok.kind != TK_ID) cc_error("expected an enumerator");
    name = tok.a; next();
    if (tok.kind == '=') { next(); v = const_expr(); }
    if (v < -32768 || v > 32767) cc_error("enumerator out of range");
    s = sym_add(name, S_ENUMC, TY_INT);
    syms[s].pos = (s16)v;
    ++v;
    if (tok.kind != ',') break;
    next();
  }
  expect('}', "expected } after enumerators");
  return TY_INT;
}

// ---- initializers ----
// Static storage: values are written to a sink as they're parsed. Automatic storage: they
// are collected (offset, node) and stored once the object is allocated.
typedef struct { u16 off, node; } Item;
static Item items[256];
static u16 nitems;
static u8 init_static, init_sink;
static u16 init_done;
static void out_line(const char* d) { out_str(init_sink, "\t"); out_str(init_sink, d); out_str(init_sink, " "); }
static void pad_to(u16 off) {
  if (off > init_done) { out_line("DS"); out_num(init_sink, off - init_done); out_str(init_sink, ", 0\n"); init_done = off; }
}
static u8 const_addr(u16 n, u16* sym, u8* is_str, s32* off) {
  Node* x = &nodes[n];
  switch (x->op) {
  case N_ADDR: {
    Node* y = &nodes[x->a];
    if (y->op == N_STR) { *sym = y->a; *is_str = 1; *off = 0; return 1; }
    if (y->op == N_SYM && (syms[y->a].kind == S_GLOBAL || syms[y->a].kind == S_STATIC || syms[y->a].kind == S_FUNC)) {
      *sym = y->a; *is_str = 0; *off = y->val; return 1;
    }
    return 0;
  }
  case N_CAST: return TK(x->type) == T_PTR && TK(NT(x->a)) == T_PTR && const_addr(x->a, sym, is_str, off);
  case N_OFFSET: if (!const_addr(x->a, sym, is_str, off)) return 0; *off += x->val; return 1;
  case N_ADD: case N_SUB:
    if (!IS_NUM(x->b) || !const_addr(x->a, sym, is_str, off)) return 0;
    *off += x->op == N_ADD ? nodes[x->b].val : -nodes[x->b].val;
    return 1;
  }
  return 0;
}
static void init_value(u16 off, u16 t, u16 n) {
  n = convert(n, t, "initializer of the wrong type");
  if (!init_static) {
    if (nitems == 256) cc_error("initializer too long for a local");
    items[nitems].off = off; items[nitems].node = n; ++nitems;
    return;
  }
  pad_to(off);
  if (IS_NUM(n)) {
    s32 v = nodes[n].val; u16 size = ty_size(t);
    if (size == 1) { out_line("DB"); out_num(init_sink, v & 0xFF); }
    else if (size == 2) { out_line("DW"); out_num(init_sink, v & 0xFFFF); }
    else { out_line("DW"); out_num(init_sink, v & 0xFFFF); out_str(init_sink, ", "); out_num(init_sink, (v >> 16) & 0xFFFF); }
  } else {
    u16 sym; u8 is_str; s32 o;
    if (ty_size(t) != 2 || !const_addr(n, &sym, &is_str, &o)) cc_error("initializer is not constant");
    out_line("DW");
    if (is_str) { out_str(init_sink, "__"); out_str(init_sink, cg_unit); out_str(init_sink, "__"); out_num(init_sink, sym); }
    else gen_sym_name(init_sink, sym);
    if (o) { out_str(init_sink, o > 0 ? " + " : " - "); out_num(init_sink, o > 0 ? o : -o); }
  }
  out_str(init_sink, "\n");
  init_done = (u16)(off + ty_size(t));
  nnodes = 1;
}
static u16 init_any(u16 t, u16 off);
static u8 init_string(u16* t, u16 off) { // a char array from a literal; returns 0 if tok isn't one
  u16 elem = types[*t].base, i, n, count = types[*t].count;
  if (TK(*t) != T_ARRAY || ty_size(elem) != 1 || !ty_is_int(elem)) return 0;
  if (tok.kind != TK_STR) return 0;
  n = 0;
  {
    // copy the literal's bytes (adjacent literals joined) as char values
    while (tok.kind == TK_STR) {
      for (i = 0; i < tok.a; ++i, ++n) {
        if (count != 0xFFFF && n >= count) cc_error("string too long for the array");
        init_value((u16)(off + n), elem, num(lit_byte(&tok, i), TY_INT));
      }
      next();
    }
  }
  if (count == 0xFFFF) { *t = ty_array(elem, (u16)(n + 1)); count = (u16)(n + 1); }
  if (n < count) init_value((u16)(off + n), elem, num(0, TY_INT)); // the terminator, if it fits
  return 1;
}
static u16 init_elided(u16 t, u16 off) { // an aggregate without its own braces
  u16 k, count, elem, canon;
  if (TK(t) == T_ARRAY) {
    count = types[t].count; elem = types[t].base;
    if (count == 0xFFFF) cc_error("unsized array needs braces");
    for (k = 0; k < count; ++k) {
      if (k) { if (tok.kind != ',' || peek()->kind == '}') break; next(); }
      init_any(elem, (u16)(off + k * ty_size(elem)));
    }
  } else {
    canon = types[t].extra;
    for (k = 0; k < (TK(t) == T_UNION ? 1 : types[canon].count); ++k) {
      Field* f = &fields[types[canon].base + k];
      if (k) { if (tok.kind != ',' || peek()->kind == '}') break; next(); }
      init_any(f->type, (u16)(off + f->offset));
    }
  }
  return t;
}
static u16 init_any(u16 t, u16 off) { // returns the type (an unsized array gets its size)
  enter();
  if (TK(t) == T_ARRAY && init_string(&t, off)) { leave(); return t; }
  if (TK(t) == T_ARRAY || TK(t) == T_STRUCT || TK(t) == T_UNION) {
    u16 k = 0, elem = types[t].base, count = types[t].count, canon = types[t].extra;
    if (tok.kind != '{') { if (TK(t) == T_ARRAY && count == 0xFFFF) cc_error("unsized array needs braces"); t = init_elided(t, off); leave(); return t; }
    next();
    if (TK(t) == T_ARRAY && tok.kind == TK_STR && init_string(&t, off)) {
      if (tok.kind == ',') next();
      expect('}', "expected } after the string");
      leave(); return t;
    }
    while (tok.kind != '}') {
      if (tok.kind == '.' || tok.kind == '[') cc_error("designated initializers are not supported");
      if (TK(t) == T_ARRAY) {
        if (count != 0xFFFF && k >= count) cc_error("too many initializers");
        init_any(elem, (u16)(off + k * ty_size(elem)));
      } else {
        if (k >= (TK(t) == T_UNION ? 1 : types[canon].count)) cc_error("too many initializers");
        init_any(fields[types[canon].base + k].type, (u16)(off + fields[types[canon].base + k].offset));
      }
      ++k;
      if (tok.kind != ',') break;
      next();
    }
    expect('}', "expected } after initializers");
    if (TK(t) == T_ARRAY && count == 0xFFFF) { if (!k) cc_error("empty initializer"); t = ty_array(elem, k); }
    leave(); return t;
  }
  if (tok.kind == '{') {
    next(); init_value(off, t, assign());
    if (tok.kind == ',') next();
    expect('}', "expected } after the initializer");
  } else init_value(off, t, assign());
  leave();
  return t;
}
static u8 rom_type(u16 t) { // static objects of const (not volatile) type live in ROM
  while (TK(t) == T_ARRAY) t = types[t].base;
  return (types[t].qual & (Q_CONST | Q_VOLATILE)) == Q_CONST;
}
static void name_line(u8 sink, u16 sym) {
  gen_sym_name(sink, sym);
  out_str(sink, syms[sym].linkage == L_EXTERN ? "::\n" : ":\n");
}
// storage for a global or static local; with an initializer if tok is '='
static void define_static(u16 s) {
  u16 t = syms[s].type, end = 0;
  if (tok.kind != '=') {
    if (!is_complete(t)) cc_error2("storage size unknown", syms[s].name);
    gen_sink(SINK_BSS);
    name_line(SINK_BSS, s);
    out_str(SINK_BSS, "\tDS "); out_num(SINK_BSS, ty_size(t)); out_str(SINK_BSS, "\n");
    syms[s].defined = 2;
    return;
  }
  next();
  init_static = 1; init_done = 0;
  if (rom_type(t)) { init_sink = SINK_RODATA; gen_sink(SINK_RODATA); name_line(SINK_RODATA, s); }
  else {
    init_sink = SINK_INIT; gen_sink(SINK_INIT);
    end = gen_label();
    out_str(SINK_INIT, "\tDW "); gen_sym_name(SINK_INIT, s);
    out_str(SINK_INIT, ", __"); out_str(SINK_INIT, cg_unit); out_str(SINK_INIT, "__"); out_num(SINK_INIT, end); out_str(SINK_INIT, "\n");
  }
  t = init_any(t, 0);
  syms[s].type = t;
  if (!is_complete(t)) cc_error("storage size unknown");
  pad_to(ty_size(t));
  if (end) {
    out_str(SINK_INIT, "__"); out_str(SINK_INIT, cg_unit); out_str(SINK_INIT, "__"); out_num(SINK_INIT, end); out_str(SINK_INIT, ":\n");
    gen_sink(SINK_DATA);
    name_line(SINK_DATA, s);
    out_str(SINK_DATA, "\tDS "); out_num(SINK_DATA, ty_size(t)); out_str(SINK_DATA, "\n");
  }
  init_static = 0;
  syms[s].defined = 2;
}
static u16 declare_global(u16 name, u16 t, u8 storage) { // file scope, or extern in a block
  u16 s = sym_find(name, 0);
  u8 link = storage == KW_STATIC ? L_INTERNAL : L_EXTERN;
  u8 kind = TK(t) == T_FUNC ? S_FUNC : S_GLOBAL;
  if (s && (syms[s].kind == S_GLOBAL || syms[s].kind == S_FUNC) && (syms[s].depth == 0 || storage == KW_EXTERN)) {
    if (syms[s].kind != kind || !ty_same(syms[s].type, t)) {
      if (!(kind == S_GLOBAL && TK(t) == T_ARRAY && TK(syms[s].type) == T_ARRAY && ty_same(types[t].base, types[syms[s].type].base)))
        cc_error2("declared differently before", name);
      if (types[t].count != 0xFFFF) syms[s].type = t;
    }
    if (storage == KW_STATIC && syms[s].linkage == L_EXTERN) cc_error2("static after a non-static declaration", name);
    if (block_depth && syms[s].depth != block_depth) { // make it visible in this block too
      u16 c = sym_add(name, kind, syms[s].type);
      syms[c] = syms[s]; syms[c].depth = block_depth;
      return c;
    }
    return s;
  }
  s = sym_add(name, kind, t);
  syms[s].linkage = link;
  if (block_depth) syms[s].depth = block_depth;
  return s;
}

static void statement(void);
static void compound(void);
static void local_declaration(void);
static void declare_params(u16 ft) {
  s16 pos[32]; u16 i;
  gen_params(ft, pos);
  for (i = 0; i < types[ft].count; ++i) {
    Field* f = &fields[types[ft].extra + i];
    u16 s;
    if (!f->name) cc_error("parameter needs a name");
    s = sym_add(f->name, S_LOCAL, f->type);
    syms[s].pos = pos[i];
  }
}
static void function_body(u16 s) {
  u16 mark;
  if (syms[s].defined) cc_error2("function defined twice", syms[s].name);
  syms[s].defined = 2;
  func_sym = s;
  gen_func_begin(s);
  mark = nsyms; ++block_depth;
  declare_params(syms[s].type);
  block_bytes = 0;
  compound();
  nsyms = mark; --block_depth;
  gen_func_end();
}
static void external_declaration(void) {
  Spec sp; u8 first = 1;
  if (tok.kind == ';') { next(); return; }
  if (!starts_type(&tok)) cc_error("expected a declaration");
  declspec(&sp);
  if (tok.kind == ';') { next(); return; }
  for (;;) {
    u16 name, t = declarator(sp.type, &name), s;
    if (!name) cc_error("declaration needs a name");
    if (sp.storage == KW_TYPEDEF) { s = sym_add(name, S_TYPEDEF, t); }
    else {
      if (sp.storage == KW_AUTO || sp.storage == KW_REGISTER) cc_error("auto or register at file scope");
      s = declare_global(name, t, sp.storage);
      if (TK(t) == T_FUNC) {
        if (tok.kind == '{') {
          if (!first) cc_error("function definition in a declaration list");
          syms[s].type = t; // the definition's parameter names
          function_body(s);
          return;
        }
      } else if (tok.kind == '=') {
        if (sp.storage == KW_EXTERN) cc_warn("extern with an initializer");
        if (syms[s].defined == 2) cc_error2("defined twice", name);
        define_static(s);
      } else if (sp.storage != KW_EXTERN && !syms[s].defined) syms[s].defined = 1; // tentative
    }
    first = 0;
    if (tok.kind != ',') break;
    next();
  }
  expect(';', "expected ; after the declaration");
}

// ---- statements ----
static void reset_nodes(void) { nnodes = 1; }
static void expr_statement(void) {
  u16 n = expr();
  gen_expr(n);
  reset_nodes();
}
static u16 condition(void) { // ( expr ) as a scalar
  u16 n;
  expect('(', "expected (");
  n = rval(expr());
  if (!ty_is_scalar(NT(n))) cc_error("condition needs a scalar");
  expect(')', "expected )");
  return n;
}
static void branch_on(u16 n, u16 label, u8 when) {
  if (IS_NUM(n)) { if ((nodes[n].val != 0) == when) gen_jump(label, cg_depth); }
  else gen_branch(n, label, when);
  reset_nodes();
}
// switch state
static s32 case_vals[CC_SWITCH_CASES]; static u16 case_labels[CC_SWITCH_CASES]; static s16 case_depths[CC_SWITCH_CASES];
static u16 ncases, switch_base, default_label; static s16 default_depth; static u8 in_switch; static u16 switch_type;
// goto state
typedef struct { u16 name, label; s16 depth; u8 defined; } Label;
static Label labels[CC_GOTOS]; static u16 nlabels;
typedef struct { u16 name, stub; s16 depth; } Goto;
static Goto gotos[CC_GOTOS]; static u16 ngotos;

static void statement(void) {
  u16 l1, l2, l3, n;
  u16 sb = brk_label, sc = cont_label; s16 db = brk_depth, dc = cont_depth;
  enter();
  gen_comment_line(tok.line);
  if (tok.kind == '{') { compound(); leave(); return; }
  if (tok.kind == ';') { next(); leave(); return; }
  if (tok.kind == TK_ID && peek()->kind == ':' && !(tok.a < KW_COUNT && tok.a)) {
    u16 name = tok.a, i;
    next(); next();
    for (i = 0; i < nlabels; ++i) if (labels[i].name == name) break;
    if (i < nlabels && labels[i].defined) cc_error2("label defined twice", name);
    if (i == nlabels) { if (nlabels == CC_GOTOS) cc_error("too many labels"); labels[i].name = name; labels[i].label = gen_label(); ++nlabels; }
    labels[i].defined = 1; labels[i].depth = cg_depth;
    { // pending gotos from other depths go through a stub that moves SP
      u16 j, skip = 0;
      for (j = 0; j < ngotos; ++j) if (gotos[j].name == name) {
        if (gotos[j].depth == cg_depth) continue;
        if (!skip) { skip = gen_label(); gen_jump(skip, cg_depth); }
        { s16 save = cg_depth; cg_depth = gotos[j].depth; gen_place(gotos[j].stub); gen_jump(labels[i].label, save); cg_depth = save; }
      }
      if (skip) gen_place(skip);
      for (j = 0; j < ngotos; ++j) if (gotos[j].name == name && gotos[j].depth == cg_depth) gen_place(gotos[j].stub);
    }
    gen_place(labels[i].label);
    statement();
    leave(); return;
  }
  if (tok.kind != TK_ID || tok.a >= KW_COUNT || !tok.a) {
    if (starts_type(&tok)) cc_error("declaration needs to be in a block");
    expr_statement(); expect(';', "expected ;"); leave(); return;
  }
  switch (tok.a) {
  case KW_IF:
    next(); n = condition();
    l1 = gen_label();
    branch_on(n, l1, 0);
    statement();
    if (is_kw(KW_ELSE)) {
      next(); l2 = gen_label();
      gen_jump(l2, cg_depth); gen_place(l1);
      statement();
      gen_place(l2);
    } else gen_place(l1);
    break;
  case KW_WHILE:
    next();
    cont_label = gen_label(); brk_label = gen_label(); cont_depth = brk_depth = cg_depth;
    gen_place(cont_label);
    n = condition();
    branch_on(n, brk_label, 0);
    statement();
    gen_jump(cont_label, cg_depth);
    gen_place(brk_label);
    break;
  case KW_DO:
    next();
    l1 = gen_label(); cont_label = gen_label(); brk_label = gen_label(); cont_depth = brk_depth = cg_depth;
    gen_place(l1);
    statement();
    if (!is_kw(KW_WHILE)) cc_error("expected while after do");
    next();
    gen_place(cont_label);
    n = condition();
    branch_on(n, l1, 1);
    expect(';', "expected ; after do-while");
    gen_place(brk_label);
    break;
  case KW_FOR: {
    u16 mark = nsyms, bytes = block_bytes;
    next(); expect('(', "expected ( after for");
    ++block_depth; block_bytes = 0;
    if (tok.kind != ';') {
      if (starts_type(&tok)) local_declaration();
      else { expr_statement(); expect(';', "expected ;"); }
    } else next();
    l1 = gen_label(); l2 = gen_label(); l3 = gen_label();
    brk_label = gen_label(); cont_label = l3; cont_depth = brk_depth = cg_depth;
    gen_place(l1); // the condition
    if (tok.kind != ';') {
      n = rval(expr());
      if (!ty_is_scalar(NT(n))) cc_error("condition needs a scalar");
      branch_on(n, brk_label, 0);
    }
    expect(';', "expected ; in for");
    gen_jump(l2, cg_depth);
    gen_place(l3); // the step
    if (tok.kind != ')') expr_statement();
    expect(')', "expected ) in for");
    gen_jump(l1, cg_depth);
    gen_place(l2); // the body
    statement();
    gen_jump(l3, cg_depth);
    gen_place(brk_label);
    if (block_bytes) gen_free(block_bytes);
    nsyms = mark; --block_depth; block_bytes = bytes;
    break;
  }
  case KW_SWITCH: {
    u16 base = switch_base, dflt = default_label, st = switch_type; s16 ddepth = default_depth; u8 was = in_switch;
    u16 dispatch;
    next(); n = condition();
    if (!ty_is_int(NT(n))) cc_error("switch needs an integer");
    n = cast(n, promote(NT(n)));
    if (ty_size(NT(n)) > 2) cc_error("switch on a long is not supported yet");
    switch_type = NT(n);
    dispatch = gen_label(); brk_label = gen_label(); brk_depth = cg_depth;
    gen_switch_value(n, dispatch);
    reset_nodes();
    switch_base = ncases; default_label = 0; in_switch = 1;
    statement();
    gen_jump(brk_label, brk_depth);
    gen_place(dispatch);
    gen_switch_table((u16)(ncases - switch_base), case_vals + switch_base, case_labels + switch_base, case_depths + switch_base, default_label ? default_label : brk_label, default_label ? default_depth : brk_depth);
    gen_place(brk_label);
    ncases = switch_base; switch_base = base; default_label = dflt; default_depth = ddepth; in_switch = was; switch_type = st;
    break;
  }
  case KW_CASE: {
    s32 v; u16 i;
    if (!in_switch) cc_error("case outside a switch");
    next(); v = norm(const_expr(), switch_type); expect(':', "expected : after case");
    reset_nodes();
    for (i = switch_base; i < ncases; ++i) if (case_vals[i] == v) cc_error("duplicate case");
    if (ncases == CC_SWITCH_CASES) cc_error("too many cases");
    case_vals[ncases] = v; case_labels[ncases] = gen_label(); case_depths[ncases] = cg_depth;
    gen_place(case_labels[ncases++]);
    statement();
    break;
  }
  case KW_DEFAULT:
    if (!in_switch) cc_error("default outside a switch");
    if (default_label) cc_error("two defaults");
    next(); expect(':', "expected : after default");
    default_label = gen_label(); default_depth = cg_depth;
    gen_place(default_label);
    statement();
    break;
  case KW_BREAK:
    next(); if (!brk_label) cc_error("break outside a loop or switch");
    gen_jump(brk_label, brk_depth); expect(';', "expected ; after break");
    break;
  case KW_CONTINUE:
    next(); if (!cont_label) cc_error("continue outside a loop");
    gen_jump(cont_label, cont_depth); expect(';', "expected ; after continue");
    break;
  case KW_RETURN: {
    u16 rt = types[syms[func_sym].type].base;
    next();
    if (tok.kind == ';') { if (TK(rt) != T_VOID) cc_error("return needs a value"); gen_return(0); }
    else {
      n = expr();
      if (TK(rt) == T_VOID) { if (TK(NT(n)) != T_VOID) cc_error("return with a value in a void function"); gen_expr(n); gen_return(0); }
      else gen_return(convert(n, rt, "return value of the wrong type"));
      reset_nodes();
    }
    expect(';', "expected ; after return");
    break;
  }
  case KW_GOTO: {
    u16 name, i;
    next();
    if (tok.kind != TK_ID) cc_error("goto needs a label");
    name = tok.a; next();
    for (i = 0; i < nlabels; ++i) if (labels[i].name == name) break;
    if (i < nlabels && labels[i].defined) gen_jump(labels[i].label, labels[i].depth);
    else {
      if (i == nlabels) { if (nlabels == CC_GOTOS) cc_error("too many labels"); labels[i].name = name; labels[i].label = gen_label(); labels[i].defined = 0; ++nlabels; }
      if (ngotos == CC_GOTOS) cc_error("too many gotos");
      gotos[ngotos].name = name; gotos[ngotos].stub = gen_label(); gotos[ngotos].depth = cg_depth;
      gen_jump(gotos[ngotos].stub, cg_depth);
      ++ngotos;
    }
    expect(';', "expected ; after goto");
    break;
  }
  default:
    if (starts_type(&tok)) cc_error("declaration needs to be in a block");
    expr_statement(); expect(';', "expected ;");
  }
  brk_label = sb; cont_label = sc; brk_depth = db; cont_depth = dc;
  leave();
}
static void local_declaration(void) {
  Spec sp;
  declspec(&sp);
  if (tok.kind == ';') { next(); return; }
  for (;;) {
    u16 name, t = declarator(sp.type, &name), s;
    if (!name) cc_error("declaration needs a name");
    if (sp.storage == KW_TYPEDEF) sym_add(name, S_TYPEDEF, t);
    else if (sp.storage == KW_EXTERN || TK(t) == T_FUNC) {
      if (sp.storage == KW_STATIC) cc_error("static function in a block");
      declare_global(name, t, KW_EXTERN);
      if (tok.kind == '=') cc_error("extern in a block with an initializer");
    } else if (sp.storage == KW_STATIC) {
      s = sym_add(name, S_STATIC, t);
      syms[s].label = gen_label(); syms[s].linkage = L_INTERNAL;
      define_static(s);
    } else {
      u16 size, i;
      s = sym_add(name, S_LOCAL, t);
      if (tok.kind == '=') {
        next();
        nitems = 0; init_static = 0;
        if (TK(t) == T_ARRAY || TK(t) == T_STRUCT || TK(t) == T_UNION) t = init_any(t, 0);
        else { items[0].off = 0; items[0].node = convert(assign(), t, "initializer of the wrong type"); nitems = 1; }
        syms[s].type = t;
        if (!is_complete(t)) cc_error2("storage size unknown", name);
        size = ty_size(t);
        gen_alloc(size); block_bytes = (u16)(block_bytes + size);
        syms[s].pos = (s16)-cg_depth;
        if (TK(t) == T_ARRAY || TK(t) == T_STRUCT || TK(t) == T_UNION) gen_zero_local(s, size);
        for (i = 0; i < nitems; ++i) {
          u16 v = items[i].node, dest = nd(N_SYM, NT(v), s, 0), a;
          nodes[dest].val = items[i].off;
          if (TK(NT(v)) == T_STRUCT || TK(NT(v)) == T_UNION) nodes[dest].type = NT(v);
          a = nd(N_ASSIGN, NT(dest), dest, v);
          gen_expr(a);
        }
        reset_nodes();
      } else {
        if (!is_complete(t)) cc_error2("storage size unknown", name);
        size = ty_size(t);
        gen_alloc(size); block_bytes = (u16)(block_bytes + size);
        syms[s].pos = (s16)-cg_depth;
      }
    }
    if (tok.kind != ',') break;
    next();
  }
  expect(';', "expected ; after the declaration");
}
static void compound(void) {
  u16 mark = nsyms, bytes = block_bytes;
  next(); // {
  ++block_depth; block_bytes = 0;
  while (tok.kind != '}') {
    if (tok.kind == TK_EOF) cc_error("missing }");
    if (starts_type(&tok) && !(tok.kind == TK_ID && peek()->kind == ':')) local_declaration();
    else statement();
  }
  next();
  if (block_bytes) gen_free(block_bytes);
  nsyms = mark; --block_depth; block_bytes = bytes;
}

// ---- the unit ----
static void basic_types(void) {
  static const u8 kinds[] = { T_VOID, T_BOOL, T_CHAR, T_SCHAR, T_UCHAR, T_INT, T_UINT, T_LONG, T_ULONG };
  u8 i;
  ntypes = 1;
  for (i = 0; i < sizeof(kinds); ++i) ty_new(kinds[i], 0, 0, 0, 0, i == 0 ? 0 : (kinds[i] >= T_LONG ? 4 : kinds[i] >= T_INT ? 2 : 1));
}
static void end_function_labels(void) {
  u16 i;
  for (i = 0; i < nlabels; ++i) if (!labels[i].defined) cc_error2("goto to an undefined label", labels[i].name);
  nlabels = ngotos = 0;
}
u8 cc_compile(const char* path, const char* unit) {
  u16 i;
  cg_unit = unit;
  failed = 0;
  if (setjmp(on_error)) return 1;
  basic_types();
  nsyms = 1; nnodes = 1; nfields = 0;
  lex_open_main(path);
  next();
  while (tok.kind != TK_EOF) {
    external_declaration();
    if (nlabels) end_function_labels();
    lit_reset();
    reset_nodes();
  }
  for (i = 1; i < nsyms; ++i) // tentative definitions
    if (syms[i].kind == S_GLOBAL && syms[i].defined == 1) {
      if (TK(syms[i].type) == T_ARRAY && types[syms[i].type].count == 0xFFFF) syms[i].type = ty_array(types[syms[i].type].base, 1);
      tok.kind = 0; define_static(i);
    }
  gen_unit_end();
  return failed;
}
