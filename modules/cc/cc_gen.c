// CC's SM83 code generator: expression trees -> RGBDS assembly, written straight to the
// code sink. A value is in HL (DEHL for 32 bits: DE high), held extended to 16 bits by its
// type, so promotions cost nothing. Binary operators take the left operand in DE and the
// right in HL; stores go through BC. Every push and pop moves cg_depth, so a local's
// SP offset and each jump's stack adjustment are known exactly; nothing relies on a
// peephole pass or an assembler retry. Calls use SDCC's sdcccall(1) for SM83.
#include "cc_int.h"
#include <stdarg.h>

s16 cg_depth;
const char* cg_unit;
static u16 next_label = 1;
static u8 sink_open[CC_SINKS];
static u16 cur_func, ret_label, stack_args, last_line;
static s16 param_pos[32];
static u32 helpers;

// ---- text ----
static u16 slen(const char* s) { u16 n = 0; while (s[n]) ++n; return n; }
void out_str(u8 sink, const char* s) { cc_host_write(sink, s, slen(s)); }
void out_num(u8 sink, s32 n) {
  char buf[12]; u8 i = sizeof(buf); u32 v = n < 0 ? 0u - (u32)n : (u32)n;
  buf[--i] = 0;
  do { buf[--i] = (char)('0' + v % 10); v /= 10; } while (v);
  if (n < 0) buf[--i] = '-';
  out_str(sink, buf + i);
}
void out_hex(u8 sink, u16 n) {
  char buf[6]; u8 i;
  buf[0] = '$';
  for (i = 0; i < 4; ++i) buf[1 + i] = "0123456789ABCDEF"[(n >> (12 - 4 * i)) & 15];
  buf[5] = 0;
  out_str(sink, buf);
}
void out_name(u8 sink, u16 name) { u8 n; const char* s = name_text(name, &n); cc_host_write(sink, s, n); }
void gen_sym_name(u8 sink, u16 s) {
  Sym* y = &syms[s];
  if (y->kind == S_STATIC) { out_str(sink, "__"); out_str(sink, cg_unit); out_str(sink, "__s"); out_num(sink, y->label); }
  else if (y->linkage == L_INTERNAL) { out_str(sink, "__"); out_str(sink, cg_unit); out_str(sink, "_"); out_name(sink, y->name); }
  else { out_str(sink, "_"); out_name(sink, y->name); }
}
static const char* const helper_names[] = {
  "__cc_mul16", "__cc_divs16", "__cc_divu16", "__cc_mods16", "__cc_modu16", "__cc_shl16", "__cc_shrs16", "__cc_shru16",
  "__cc_jphl", "__cc_memcpy", "__cc_add32", "__cc_sub32", "__cc_and32", "__cc_or32", "__cc_xor32", "__cc_mul32",
  "__cc_divs32", "__cc_divu32", "__cc_mods32", "__cc_modu32", "__cc_shl32", "__cc_shrs32", "__cc_shru32",
  "__cc_cmps32", "__cc_cmpu32", "__cc_neg32"
};
enum { H_MUL16, H_DIVS16, H_DIVU16, H_MODS16, H_MODU16, H_SHL16, H_SHRS16, H_SHRU16, H_JPHL, H_MEMCPY,
       H_ADD32, H_SUB32, H_AND32, H_OR32, H_XOR32, H_MUL32, H_DIVS32, H_DIVU32, H_MODS32, H_MODU32,
       H_SHL32, H_SHRS32, H_SHRU32, H_CMPS32, H_CMPU32, H_NEG32, H_COUNT };
// One instruction line. %s text, %d signed number, %u 16-bit unsigned number, %L label,
// %S symbol (its assembly name), %H helper.
static void emit(const char* f, ...) {
  va_list ap;
  char lit[2]; lit[1] = 0;
  va_start(ap, f);
  out_str(SINK_CODE, "\t");
  for (; *f; ++f) {
    if (*f != '%') { lit[0] = *f; out_str(SINK_CODE, lit); continue; }
    switch (*++f) {
    case 's': out_str(SINK_CODE, va_arg(ap, const char*)); break;
    case 'd': out_num(SINK_CODE, (s32)va_arg(ap, int)); break;
    case 'u': out_num(SINK_CODE, (s32)(u16)va_arg(ap, int)); break;
    case 'L': out_str(SINK_CODE, ".L"); out_num(SINK_CODE, (u16)va_arg(ap, int)); break;
    case 'S': gen_sym_name(SINK_CODE, (u16)va_arg(ap, int)); break;
    case 'H': { int h = va_arg(ap, int); helpers |= 1ul << h; out_str(SINK_CODE, helper_names[h]); break; }
    }
  }
  out_str(SINK_CODE, "\n");
  va_end(ap);
}
u16 gen_label(void) { return next_label++; }
void gen_place(u16 label) { out_str(SINK_CODE, ".L"); out_num(SINK_CODE, label); out_str(SINK_CODE, ":\n"); }
void gen_comment_line(u16 line) {
  if (line == last_line) return;
  last_line = line;
  out_str(SINK_CODE, "; line "); out_num(SINK_CODE, line); out_str(SINK_CODE, "\n");
}
void gen_sink(u8 sink) {
  static const char* const names[] = { "code", "rodata", "str", "data", "", "bss" };
  static const char* const kinds[] = { "ROM0", "ROM0", "ROM0", "WRAM0", "", "WRAM0" };
  if (sink_open[sink]) return;
  sink_open[sink] = 1;
  if (sink == SINK_INIT) { out_str(sink, "\nSECTION FRAGMENT \"cc_init\", ROM0\n"); return; }
  out_str(sink, "\nSECTION \"cc."); out_str(sink, cg_unit); out_str(sink, "."); out_str(sink, names[sink]);
  out_str(sink, "\", "); out_str(sink, kinds[sink]); out_str(sink, "\n");
}

// ---- stack ----
static void push(const char* r) { emit("push %s", r); cg_depth += 2; }
static void pop(const char* r) { emit("pop %s", r); cg_depth -= 2; }
static void move_sp(s16 bytes) { // SP += bytes; may use HL when far (only between statements, or with HL free)
  if (bytes >= -256 && bytes <= 254) {
    while (bytes > 127) { emit("add sp, 127"); bytes -= 127; }
    while (bytes < -128) { emit("add sp, -128"); bytes += 128; }
    if (bytes) emit("add sp, %d", bytes);
  } else { emit("ld hl, %d", bytes); emit("add hl, sp"); emit("ld sp, hl"); }
}
void gen_alloc(u16 bytes) { move_sp((s16)-bytes); cg_depth = (s16)(cg_depth + bytes); }
void gen_free(u16 bytes) { move_sp((s16)bytes); cg_depth = (s16)(cg_depth - bytes); }
void gen_jump(u16 label, s16 depth) { move_sp((s16)(cg_depth - depth)); emit("jp %L", label); }
static void sp_addr(s16 pos) { // HL = the address at frame position pos
  s16 k = (s16)(pos + cg_depth);
  if (k >= 0 && k <= 127) emit("ld hl, sp + %d", k);
  else if (k < 0 && k >= -128) emit("ld hl, sp - %d", -k);
  else { emit("ld hl, %d", k); emit("add hl, sp"); }
}

// ---- the ABI (sdcccall(1), SM83) ----
enum { R_A, R_E, R_DE, R_BC, R_DEBC, R_STACK };
static void abi(u16 ft, u8* where, u16* offs, u16* stack) {
  u16 i, n = types[ft].count, s = 0;
  for (i = 0; i < n; ++i) {
    u16 size = ty_size(fields[types[ft].extra + i].type);
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
void gen_func_begin(u16 sym) {
  u8 where[32]; u16 offs[32], i, ft = syms[sym].type;
  gen_sink(SINK_CODE);
  cur_func = sym; last_line = 0;
  out_str(SINK_CODE, "\n");
  gen_sym_name(SINK_CODE, sym);
  out_str(SINK_CODE, syms[sym].linkage == L_EXTERN ? "::\n" : ":\n");
  if (types[ft].count > 32) cc_error("too many parameters");
  abi(ft, where, offs, &stack_args);
  cg_depth = 0;
  for (i = 0; i < types[ft].count; ++i) {
    switch (where[i]) {
    case R_A: push("af"); param_pos[i] = (s16)(1 - cg_depth); break;
    case R_E: push("de"); param_pos[i] = (s16)-cg_depth; break;
    case R_DE: push("de"); param_pos[i] = (s16)-cg_depth; break;
    case R_BC: push("bc"); param_pos[i] = (s16)-cg_depth; break;
    case R_DEBC: push("de"); push("bc"); param_pos[i] = (s16)-cg_depth; break;
    default: param_pos[i] = (s16)(2 + offs[i]);
    }
  }
  ret_label = gen_label();
}
void gen_params(u16 ft, s16* pos) { u16 i; for (i = 0; i < types[ft].count; ++i) pos[i] = param_pos[i]; }
void gen_func_end(void) {
  u16 rt = types[syms[cur_func].type].base;
  u8 len; const char* name = name_text(syms[cur_func].name, &len);
  if (len == 4 && name[0] == 'm' && name[1] == 'a' && name[2] == 'i' && name[3] == 'n' && TK(rt) != T_VOID) {
    if (ty_size(rt) == 1) emit("xor a"); else emit("ld bc, 0");
    if (ty_size(rt) == 4) emit("ld de, 0");
  }
  move_sp(cg_depth);
  gen_place(ret_label);
  if (stack_args) { emit("pop hl"); move_sp((s16)stack_args); emit("jp hl"); }
  else emit("ret");
}

// ---- loads, stores, conversions ----
static u16 size_of(u16 t) { return ty_size(t); }
static void load(u16 t) { // from the address in HL
  switch (TK(t)) {
  case T_BOOL: case T_CHAR: case T_UCHAR: emit("ld l, [hl]"); emit("ld h, 0"); return;
  case T_SCHAR: emit("ld a, [hl]"); emit("ld l, a"); emit("add a, a"); emit("sbc a, a"); emit("ld h, a"); return;
  case T_INT: case T_UINT: case T_PTR: emit("ld a, [hl+]"); emit("ld h, [hl]"); emit("ld l, a"); return;
  case T_LONG: case T_ULONG:
    emit("ld a, [hl+]"); emit("ld c, a"); emit("ld a, [hl+]"); emit("ld b, a"); emit("ld a, [hl+]"); emit("ld e, a");
    emit("ld d, [hl]"); emit("ld h, b"); emit("ld l, c"); return;
  }
}
static void store_bc(u16 t) { // the value to the address in BC
  u16 size = size_of(t);
  emit("ld a, l"); emit("ld [bc], a");
  if (size == 1) return;
  emit("inc bc"); emit("ld a, h"); emit("ld [bc], a");
  if (size == 2) return;
  emit("inc bc"); emit("ld a, e"); emit("ld [bc], a");
  emit("inc bc"); emit("ld a, d"); emit("ld [bc], a");
}
static void extend8(u8 is_signed) {
  if (is_signed) { emit("ld a, l"); emit("add a, a"); emit("sbc a, a"); emit("ld h, a"); }
  else emit("ld h, 0");
}
static void conv(u16 from, u16 to) {
  u16 fs = size_of(from), ts = size_of(to);
  u8 fk = TK(from), tk = TK(to);
  if (tk == T_VOID || fk == T_VOID) return;
  if (tk == T_BOOL) {
    if (fk == T_BOOL) return;
    emit("ld a, h"); emit("or l");
    if (fs == 4) { emit("or d"); emit("or e"); }
    emit("add a, $FF"); emit("ld hl, 0"); emit("rl l");
    return;
  }
  if (ts == 1) { if (fk != T_BOOL && (fs != 1 || ty_is_signed(from) != ty_is_signed(to))) extend8(ty_is_signed(to)); return; }
  if (ts == 4 && fs < 4) {
    if (ty_is_signed(from)) { emit("ld a, h"); emit("add a, a"); emit("sbc a, a"); emit("ld d, a"); emit("ld e, a"); }
    else emit("ld de, 0");
  }
}

// ---- expressions ----
#define NT_(n) (nodes[n].type)
static void gen(u16 n);
static void gen_addr(u16 n);
static u8 is_local(u16 n) { return nodes[n].op == N_SYM && syms[nodes[n].a].kind == S_LOCAL; }
static u8 is_named(u16 n) { u8 k; if (nodes[n].op != N_SYM) return 0; k = syms[nodes[n].a].kind; return k == S_GLOBAL || k == S_STATIC || k == S_FUNC; }
static void ld_named(const char* fmt_pre, u16 n, s16 extra, const char* post) {
  // e.g. "ld hl, " name+off "" / "ld [" name+off "], a"
  s32 off = nodes[n].val + extra;
  out_str(SINK_CODE, "\t"); out_str(SINK_CODE, fmt_pre);
  gen_sym_name(SINK_CODE, nodes[n].a);
  if (off) { out_str(SINK_CODE, off > 0 ? " + " : " - "); out_num(SINK_CODE, off > 0 ? off : -off); }
  out_str(SINK_CODE, post); out_str(SINK_CODE, "\n");
}
static u8 simple(u16 n) { // gen(n) leaves DE and BC alone
  Node* x = &nodes[n];
  switch (x->op) {
  case N_NUM: return size_of(x->type) <= 2;
  case N_SYM: return size_of(x->type) <= 2 || TK(x->type) == T_ARRAY || TK(x->type) == T_STRUCT || TK(x->type) == T_UNION || TK(x->type) == T_FUNC;
  case N_STR: return 1;
  case N_ADDR: return nodes[x->a].op == N_SYM || nodes[x->a].op == N_STR;
  case N_CAST: return size_of(x->type) <= 2 && size_of(NT_(x->a)) <= 2 && simple(x->a);
  }
  return 0;
}
static void operands(u16 l, u16 r) { // DE = l, HL = r
  if (simple(r)) { gen(l); emit("ld d, h"); emit("ld e, l"); gen(r); }
  else { gen(l); push("hl"); gen(r); pop("de"); }
}
static void operands32(u16 l, u16 r) { // left on the stack (4 bytes, the helper pops it), right in DEHL
  gen(l); push("de"); push("hl"); gen(r);
}
static void call_helper32(u8 h) { emit("call %H", h); cg_depth -= 4; }
static u8 log2_16(s32 v) { u8 k; for (k = 0; k < 16; ++k) if (v == (1l << k)) return k; return 0xFF; }
static void shift_const(u8 op, u8 is_signed, u16 k) {
  if (k >= 16) { emit("ld hl, 0"); return; }
  if (op == N_SHL) {
    if (k >= 8) { emit("ld h, l"); emit("ld l, 0"); k -= 8; }
    while (k--) emit("add hl, hl");
  } else {
    if (k >= 8) { emit("ld l, h"); if (is_signed) { emit("ld a, h"); emit("add a, a"); emit("sbc a, a"); emit("ld h, a"); } else emit("ld h, 0"); k -= 8; }
    while (k--) { emit(is_signed ? "sra h" : "srl h"); emit("rr l"); }
  }
}
// HL op= constant for 16-bit types; returns 0 if a helper call is still needed
static u8 const_op(u8 op, u16 t, s32 v) {
  u16 k = (u16)v; u8 sg = ty_is_signed(t), p;
  switch (op) {
  case N_ADD: case N_SUB:
    if (op == N_SUB) k = (u16)(0u - k);
    if (k == 0) return 1;
    if (k <= 3) { while (k--) emit("inc hl"); return 1; }
    if (k >= 0xFFFD) { while (k++) emit("dec hl"); return 1; }
    emit("ld de, %u", k); emit("add hl, de"); return 1;
  case N_AND: case N_OR: case N_XOR: {
    const char* m = op == N_AND ? "and" : op == N_OR ? "or" : "xor";
    u8 lo = (u8)k, hi = (u8)(k >> 8);
    if (op == N_AND && lo == 0) emit("ld l, 0");
    else if (!(op != N_AND && lo == 0) && !(op == N_AND && lo == 0xFF)) { emit("ld a, l"); emit("%s a, %u", m, lo); emit("ld l, a"); }
    if (op == N_AND && hi == 0) emit("ld h, 0");
    else if (!(op != N_AND && hi == 0) && !(op == N_AND && hi == 0xFF)) { emit("ld a, h"); emit("%s a, %u", m, hi); emit("ld h, a"); }
    return 1;
  }
  case N_SHL: case N_SHR: shift_const(op, sg, k); return 1;
  case N_MUL: p = log2_16(k); if (p == 0xFF) return 0; shift_const(N_SHL, 0, p); return 1;
  case N_DIV: if (sg) return 0; p = log2_16(k); if (p == 0xFF) return 0; shift_const(N_SHR, 0, p); return 1;
  case N_MOD: if (sg) return 0; p = log2_16(k); if (p == 0xFF) return 0; return const_op(N_AND, t, k - 1);
  }
  return 0;
}
static void binary16(u8 op, u16 t) { // HL = DE op HL
  u8 sg = ty_is_signed(t);
  switch (op) {
  case N_ADD: emit("add hl, de"); return;
  case N_SUB: emit("ld a, e"); emit("sub a, l"); emit("ld l, a"); emit("ld a, d"); emit("sbc a, h"); emit("ld h, a"); return;
  case N_AND: case N_OR: case N_XOR: {
    const char* m = op == N_AND ? "and" : op == N_OR ? "or" : "xor";
    emit("ld a, l"); emit("%s a, e", m); emit("ld l, a"); emit("ld a, h"); emit("%s a, d", m); emit("ld h, a"); return;
  }
  case N_MUL: emit("call %H", H_MUL16); return;
  case N_DIV: emit("call %H", sg ? H_DIVS16 : H_DIVU16); return;
  case N_MOD: emit("call %H", sg ? H_MODS16 : H_MODU16); return;
  case N_SHL: emit("call %H", H_SHL16); return;
  case N_SHR: emit("call %H", sg ? H_SHRS16 : H_SHRU16); return;
  }
}
static void binary32(u8 op, u16 t) { // DEHL = (stack) op DEHL
  u8 sg = ty_is_signed(t), h = 0;
  switch (op) {
  case N_ADD: h = H_ADD32; break; case N_SUB: h = H_SUB32; break; case N_AND: h = H_AND32; break;
  case N_OR: h = H_OR32; break; case N_XOR: h = H_XOR32; break; case N_MUL: h = H_MUL32; break;
  case N_DIV: h = sg ? H_DIVS32 : H_DIVU32; break; case N_MOD: h = sg ? H_MODS32 : H_MODU32; break;
  case N_SHL: h = H_SHL32; break; case N_SHR: h = sg ? H_SHRS32 : H_SHRU32; break;
  }
  call_helper32(h);
}
static void arith(u16 n) {
  Node* x = &nodes[n];
  u8 op = x->op; u16 t = x->type, l = x->a, r = x->b;
  if (size_of(t) == 4) {
    if (op == N_SHL || op == N_SHR) { gen(l); push("de"); push("hl"); gen(r); call_helper32(op == N_SHL ? H_SHL32 : ty_is_signed(t) ? H_SHRS32 : H_SHRU32); return; }
    operands32(l, r); binary32(op, t); return;
  }
  if (nodes[r].op == N_NUM) {
    gen(l);
    if (const_op(op, t, nodes[r].val)) return;
    emit("ld d, h"); emit("ld e, l"); emit("ld hl, %u", (u16)nodes[r].val);
    binary16(op, t); return;
  }
  operands(l, r);
  binary16(op, t);
}
// comparisons: emit code that sets a flag, return the condition that means true
enum { C_C, C_NC, C_Z, C_NZ };
static const char* const cond_names[] = { "c", "nc", "z", "nz" };
static u8 compare(u16 n) {
  Node* x = &nodes[n];
  u8 op = x->op; u16 l = x->a, r = x->b, t = NT_(l);
  u8 sg = ty_is_signed(t);
  if (size_of(t) == 4) {
    if (op == N_GT || op == N_LE) { u16 s = l; l = r; r = s; op = op == N_GT ? N_LT : N_GE; }
    operands32(l, r); call_helper32(sg ? H_CMPS32 : H_CMPU32);
    return op == N_EQ ? C_Z : op == N_NE ? C_NZ : op == N_LT ? C_C : C_NC;
  }
  if (nodes[r].op == N_NUM) {
    u16 k = (u16)nodes[r].val;
    gen(l);
    if (op == N_EQ || op == N_NE) {
      if (k & 0xFF) { emit("ld a, l"); emit("xor a, %u", k & 0xFF); emit("ld c, a"); emit("ld a, h"); if (k >> 8) emit("xor a, %u", k >> 8); emit("or a, c"); }
      else { emit("ld a, h"); if (k >> 8) emit("xor a, %u", k >> 8); emit("or a, l"); }
      return op == N_EQ ? C_Z : C_NZ;
    }
    if (sg) { emit("ld a, h"); emit("xor a, $80"); emit("ld h, a"); k ^= 0x8000; }
    if (op == N_LT || op == N_GE) { emit("ld a, l"); emit("sub a, %u", k & 0xFF); emit("ld a, h"); emit("sbc a, %u", k >> 8); return op == N_LT ? C_C : C_NC; }
    emit("ld a, %u", k & 0xFF); emit("sub a, l"); emit("ld a, %u", k >> 8); emit("sbc a, h");
    return op == N_GT ? C_C : C_NC;
  }
  operands(l, r);
  if (op == N_EQ || op == N_NE) {
    emit("ld a, e"); emit("xor a, l"); emit("ld c, a"); emit("ld a, d"); emit("xor a, h"); emit("or a, c");
    return op == N_EQ ? C_Z : C_NZ;
  }
  if (sg) { emit("ld a, d"); emit("xor a, $80"); emit("ld d, a"); emit("ld a, h"); emit("xor a, $80"); emit("ld h, a"); }
  if (op == N_LT || op == N_GE) { emit("ld a, e"); emit("sub a, l"); emit("ld a, d"); emit("sbc a, h"); return op == N_LT ? C_C : C_NC; }
  emit("ld a, l"); emit("sub a, e"); emit("ld a, h"); emit("sbc a, d");
  return op == N_GT ? C_C : C_NC;
}
static void cond_value(u8 c) { // HL = the condition as 0 or 1
  if (c == C_C || c == C_NC) { emit("ld hl, 0"); if (c == C_NC) emit("ccf"); emit("rl l"); return; }
  { u16 skip = gen_label(); emit("ld hl, 0"); emit("jp %s, %L", cond_names[c ^ 1], skip); emit("inc l"); gen_place(skip); }
}
static void test_zero(u16 t) { // Z if the value is zero
  emit("ld a, h"); emit("or a, l");
  if (size_of(t) == 4) { emit("or a, d"); emit("or a, e"); }
}
void gen_branch(u16 n, u16 label, u8 when) {
  Node* x = &nodes[n];
  u16 skip;
  switch (x->op) {
  case N_NUM: if ((x->val != 0) == when) emit("jp %L", label); return;
  case N_LNOT: gen_branch(x->a, label, !when); return;
  case N_LAND:
    if (when) { skip = gen_label(); gen_branch(x->a, skip, 0); gen_branch(x->b, label, 1); gen_place(skip); }
    else { gen_branch(x->a, label, 0); gen_branch(x->b, label, 0); }
    return;
  case N_LOR:
    if (when) { gen_branch(x->a, label, 1); gen_branch(x->b, label, 1); }
    else { skip = gen_label(); gen_branch(x->a, skip, 1); gen_branch(x->b, label, 0); gen_place(skip); }
    return;
  case N_LT: case N_LE: case N_GT: case N_GE: case N_EQ: case N_NE: {
    u8 c = compare(n);
    emit("jp %s, %L", cond_names[when ? c : c ^ 1], label);
    return;
  }
  }
  gen(n);
  test_zero(x->type);
  emit("jp %s, %L", when ? "nz" : "z", label);
}
static void store_to(u16 lhs, u16 t) { // the value (HL/DEHL) into lhs, keeping it in HL/DEHL
  u16 size = size_of(t);
  if (is_named(lhs)) {
    ld_named("ld a, l\n\tld [", lhs, 0, "], a");
    if (size >= 2) ld_named("ld a, h\n\tld [", lhs, 1, "], a");
    if (size == 4) { ld_named("ld a, e\n\tld [", lhs, 2, "], a"); ld_named("ld a, d\n\tld [", lhs, 3, "], a"); }
    return;
  }
  if (is_local(lhs)) {
    emit("ld b, h"); emit("ld c, l");
    sp_addr((s16)(syms[nodes[lhs].a].pos + nodes[lhs].val));
    emit("ld [hl], c");
    if (size >= 2) { emit("inc hl"); emit("ld [hl], b"); }
    if (size == 4) { emit("inc hl"); emit("ld [hl], e"); emit("inc hl"); emit("ld [hl], d"); }
    emit("ld h, b"); emit("ld l, c");
    return;
  }
}
static void assign(u16 n) {
  Node* x = &nodes[n];
  u16 l = x->a, r = x->b, t = NT_(l);
  if (TK(t) == T_STRUCT || TK(t) == T_UNION) {
    gen_addr(l); push("hl"); gen(r); pop("de"); push("de");
    emit("ld bc, %u", size_of(t)); emit("call %H", H_MEMCPY);
    pop("hl");
    return;
  }
  if (is_named(l) || is_local(l)) { gen(r); store_to(l, t); return; }
  gen_addr(l); push("hl"); gen(r); pop("bc"); store_bc(t);
}
static void opassign(u16 n) {
  Node* x = &nodes[n];
  u16 l = x->a, r = x->b, t = NT_(l), ct = x->c;
  u8 op = x->flags;
  gen_addr(l); push("hl");
  load(t); conv(t, ct);
  if (size_of(ct) == 4) {
    push("de"); push("hl"); gen(r);
    if (op == N_SHL || op == N_SHR) call_helper32(op == N_SHL ? H_SHL32 : ty_is_signed(ct) ? H_SHRS32 : H_SHRU32);
    else binary32(op, ct);
  } else if (nodes[r].op == N_NUM && const_op(op, ct, nodes[r].val)) {}
  else if (simple(r)) { emit("ld d, h"); emit("ld e, l"); gen(r); binary16(op, ct); }
  else { push("hl"); gen(r); pop("de"); binary16(op, ct); }
  conv(ct, t);
  pop("bc"); store_bc(t);
}
static void incdec(u16 n) {
  Node* x = &nodes[n];
  u16 t = x->type, step = (u16)x->val;
  u8 op = x->op, inc = op == N_PREINC || op == N_POSTINC, post = op == N_POSTINC || op == N_POSTDEC;
  gen_addr(x->a); push("hl"); load(t);
  if (size_of(t) == 4) {
    u16 skip = gen_label();
    pop("bc");
    if (post) { push("de"); push("hl"); }
    if (inc) { emit("inc hl"); emit("ld a, h"); emit("or a, l"); emit("jp nz, %L", skip); emit("inc de"); gen_place(skip); }
    else { emit("ld a, h"); emit("or a, l"); emit("jp nz, %L", skip); emit("dec de"); gen_place(skip); emit("dec hl"); }
    store_bc(t);
    if (post) { pop("hl"); pop("de"); }
    return;
  }
  if (post) { emit("ld d, h"); emit("ld e, l"); }
  if (step == 1) emit(inc ? "inc hl" : "dec hl");
  else { emit("ld bc, %u", inc ? step : (u16)(0u - step)); emit("add hl, bc"); }
  conv(TY_INT, t);
  pop("bc"); store_bc(t);
  if (post) { emit("ld h, d"); emit("ld l, e"); }
}
static void call(u16 n) {
  Node* x = &nodes[n];
  u16 fn = x->a, ft, args[32], nargs = 0, i, a, stack;
  u8 where[32]; u16 offs[32]; u8 direct;
  if (TK(NT_(fn)) == T_FUNC) ft = NT_(fn); else ft = types[NT_(fn)].base;
  if (nodes[fn].op == N_ADDR && TK(NT_(nodes[fn].a)) == T_FUNC) fn = nodes[fn].a;
  direct = is_named(fn) && TK(NT_(fn)) == T_FUNC;
  for (a = x->b; a; a = nodes[a].b) args[nargs++] = nodes[a].a;
  abi(ft, where, offs, &stack);
  for (i = nargs; i-- > 0; ) {
    u16 size;
    if (where[i] != R_STACK) continue;
    gen(args[i]); size = size_of(NT_(args[i]));
    if (size == 1) { emit("ld h, l"); push("hl"); emit("inc sp"); --cg_depth; }
    else if (size == 2) push("hl");
    else { push("de"); push("hl"); }
  }
  for (i = 0; i < nargs && i < 2; ++i) {
    if (where[i] == R_STACK) continue;
    gen(args[i]);
    if (where[i] == R_A) emit("ld h, l");
    if (where[i] == R_DEBC) push("de");
    push("hl");
  }
  if (!direct) gen(fn);
  for (i = nargs < 2 ? nargs : 2; i-- > 0; ) {
    switch (where[i]) {
    case R_A: pop("af"); break;
    case R_E: case R_DE: pop("de"); break;
    case R_BC: pop("bc"); break;
    case R_DEBC: pop("bc"); pop("de"); break;
    }
  }
  if (direct) emit("call %S", nodes[fn].a);
  else emit("call %H", H_JPHL);
  cg_depth = (s16)(cg_depth - stack);
  switch (size_of(x->type)) {
  case 1: emit("ld l, a"); if (TK(x->type) != T_BOOL) extend8(ty_is_signed(x->type)); else emit("ld h, 0"); break;
  case 2: case 4: if (TK(x->type) != T_VOID) { emit("ld h, b"); emit("ld l, c"); } break;
  }
}
static void gen_addr(u16 n) {
  Node* x = &nodes[n];
  switch (x->op) {
  case N_SYM:
    if (syms[x->a].kind == S_LOCAL) sp_addr((s16)(syms[x->a].pos + x->val));
    else ld_named("ld hl, ", n, 0, "");
    return;
  case N_DEREF: gen(x->a); return;
  case N_STR:
    out_str(SINK_CODE, "\tld hl, __"); out_str(SINK_CODE, cg_unit); out_str(SINK_CODE, "__"); out_num(SINK_CODE, x->a); out_str(SINK_CODE, "\n");
    return;
  }
  cc_error("internal: no address");
}
static void gen(u16 n) {
  Node* x = &nodes[n];
  u16 t = x->type;
  u8 k = TK(t);
  switch (x->op) {
  case N_NUM:
    if (size_of(t) == 4) { emit("ld de, %u", (u16)((u32)x->val >> 16)); emit("ld hl, %u", (u16)x->val); }
    else emit("ld hl, %u", (u16)x->val);
    return;
  case N_SYM: case N_STR:
    gen_addr(n);
    if (k != T_ARRAY && k != T_STRUCT && k != T_UNION && k != T_FUNC) load(t);
    return;
  case N_ADDR: gen_addr(x->a); return;
  case N_DEREF:
    gen(x->a);
    if (k != T_ARRAY && k != T_STRUCT && k != T_UNION && k != T_FUNC) load(t);
    return;
  case N_OFFSET: gen(x->a); if (x->val) const_op(N_ADD, TY_UINT, x->val); return;
  case N_CAST: gen(x->a); conv(NT_(x->a), t); return;
  case N_NEG:
    gen(x->a);
    if (size_of(t) == 4) { emit("call %H", H_NEG32); return; }
    emit("xor a"); emit("sub a, l"); emit("ld l, a"); emit("sbc a, a"); emit("sub a, h"); emit("ld h, a");
    return;
  case N_BNOT:
    gen(x->a);
    emit("ld a, l"); emit("cpl"); emit("ld l, a"); emit("ld a, h"); emit("cpl"); emit("ld h, a");
    if (size_of(t) == 4) { emit("ld a, e"); emit("cpl"); emit("ld e, a"); emit("ld a, d"); emit("cpl"); emit("ld d, a"); }
    return;
  case N_LNOT:
    gen(x->a); test_zero(NT_(x->a)); emit("sub a, 1"); emit("ld hl, 0"); emit("rl l");
    return;
  case N_ADD: case N_SUB: case N_MUL: case N_DIV: case N_MOD: case N_SHL: case N_SHR: case N_AND: case N_OR: case N_XOR:
    arith(n); return;
  case N_LT: case N_LE: case N_GT: case N_GE: case N_EQ: case N_NE: cond_value(compare(n)); return;
  case N_LAND: case N_LOR: {
    u16 f = gen_label(), e = gen_label();
    gen_branch(n, f, 0);
    emit("ld hl, 1"); emit("jp %L", e);
    gen_place(f); emit("ld hl, 0"); gen_place(e);
    return;
  }
  case N_COND: {
    u16 f = gen_label(), e = gen_label();
    gen_branch(x->a, f, 0);
    gen(x->b); emit("jp %L", e);
    gen_place(f); gen(x->c); gen_place(e);
    return;
  }
  case N_COMMA: gen(x->a); gen(x->b); return;
  case N_ASSIGN: assign(n); return;
  case N_OPASSIGN: opassign(n); return;
  case N_PREINC: case N_PREDEC: case N_POSTINC: case N_POSTDEC: incdec(n); return;
  case N_CALL: call(n); return;
  }
  cc_error("internal: unknown node");
}
void gen_expr(u16 n) {
  if (nodes[n].op == N_POSTINC) nodes[n].op = N_PREINC;
  else if (nodes[n].op == N_POSTDEC) nodes[n].op = N_PREDEC;
  gen(n);
}
void gen_return(u16 n) {
  if (n) {
    u16 size = size_of(nodes[n].type);
    gen(n);
    if (size == 1) emit("ld a, l");
    else { emit("ld b, h"); emit("ld c, l"); }
  }
  move_sp(cg_depth);
  emit("jp %L", ret_label);
}
void gen_zero_local(u16 sym, u16 bytes) {
  sp_addr(syms[sym].pos);
  if (bytes <= 8) { emit("xor a"); while (bytes--) emit("ld [hl+], a"); return; }
  {
    u16 loop = gen_label();
    emit("ld bc, %u", bytes);
    gen_place(loop);
    emit("xor a"); emit("ld [hl+], a"); emit("dec bc"); emit("ld a, b"); emit("or a, c"); emit("jp nz, %L", loop);
  }
}
void gen_switch_value(u16 n, u16 dispatch) { gen(n); emit("jp %L", dispatch); }
void gen_switch_table(u16 count, const s32* values, const u16* labels, const s16* depths, u16 deflt, s16 deflt_depth) {
  u16 i, stubs[CC_SWITCH_CASES];
  for (i = 0; i < count; ++i) {
    u16 v = (u16)values[i];
    stubs[i] = depths[i] == cg_depth ? labels[i] : gen_label();
    emit("ld a, l");
    if (v & 0xFF) emit("xor a, %u", v & 0xFF);
    emit("ld c, a"); emit("ld a, h");
    if (v >> 8) emit("xor a, %u", v >> 8);
    emit("or a, c");
    emit("jp z, %L", stubs[i]);
  }
  gen_jump(deflt, deflt_depth);
  for (i = 0; i < count; ++i) if (stubs[i] != labels[i]) { gen_place(stubs[i]); gen_jump(labels[i], depths[i]); }
}
void gen_unit_end(void) {
  u8 i;
  if (!helpers) return;
  gen_sink(SINK_CODE);
  out_str(SINK_CODE, "\n; runtime helpers:");
  for (i = 0; i < H_COUNT; ++i) if (helpers & (1ul << i)) { out_str(SINK_CODE, " "); out_str(SINK_CODE, helper_names[i]); }
  out_str(SINK_CODE, "\n");
}
