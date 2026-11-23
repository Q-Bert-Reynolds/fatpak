// CC pass C: instruction text, and the leaf emitters.
#define CC_PAGE gen_emit
#define CC_NEED_sy_r8
#define CC_NEED_sy_r16
#define CC_NEED_ty_r8
#define CC_NEED_nd_r16
#define CC_NEED_nd_r32
#define CC_NEED_out_str
#define CC_NEED_cc_copy
#include "cc_gen.h"

static const char* const named_parts[][2] = { // ld_named: before and after the name
  { "ld a, l\n\tld [", "], a" },
  { "ld a, h\n\tld [", "], a" },
  { "ld a, e\n\tld [", "], a" },
  { "ld a, d\n\tld [", "], a" },
  { "ld hl, ", "" },
};

static const char* const templates[I_COUNT] = {
  "jp c, %L",
  "jp nc, %L",
  "jp z, %L",
  "jp nz, %L",
  "and a, %u",
  "or a, %u",
  "xor a, %u",
  "and a, e",
  "or a, e",
  "xor a, e",
  "and a, d",
  "or a, d",
  "xor a, d",
  "push af",
  "push bc",
  "push de",
  "push hl",
  "pop af",
  "pop bc",
  "pop de",
  "pop hl",
  "add sp, 127",
  "add sp, -128",
  "add sp, %d",
  "ld hl, %d",
  "add hl, sp",
  "ld sp, hl",
  "jp %L",
  "ld hl, sp + %d",
  "ld hl, sp - %d",
  "xor a",
  "ld bc, 0",
  "ld de, 0",
  "jp hl",
  "ret",
  "ld l, [hl]",
  "ld h, 0",
  "ld a, [hl]",
  "ld l, a",
  "add a, a",
  "sbc a, a",
  "ld h, a",
  "ld a, [hl+]",
  "ld h, [hl]",
  "ld c, a",
  "ld b, a",
  "ld e, a",
  "ld d, [hl]",
  "ld h, b",
  "ld l, c",
  "ld a, l",
  "ld [bc], a",
  "inc bc",
  "ld a, h",
  "ld a, e",
  "ld a, d",
  "or l",
  "or d",
  "or e",
  "add a, $FF",
  "ld hl, 0",
  "rl l",
  "ld d, a",
  "ld d, h",
  "ld e, l",
  "call %H",
  "ld h, l",
  "ld l, 0",
  "add hl, hl",
  "ld l, h",
  "sra h",
  "srl h",
  "rr l",
  "inc hl",
  "dec hl",
  "ld de, %u",
  "add hl, de",
  "sub a, l",
  "sbc a, h",
  "ld hl, %u",
  "or a, c",
  "or a, l",
  "xor a, $80",
  "sub a, %u",
  "sbc a, %u",
  "ld a, %u",
  "xor a, l",
  "xor a, h",
  "sub a, e",
  "sbc a, d",
  "ccf",
  "inc l",
  "ld b, h",
  "ld c, l",
  "ld [hl], c",
  "ld [hl], b",
  "ld [hl], e",
  "ld [hl], d",
  "ld bc, %u",
  "inc de",
  "dec de",
  "add hl, bc",
  "ld h, d",
  "ld l, e",
  "inc sp",
  "call %S",
  "sub a, h",
  "cpl",
  "sub a, 1",
  "ld hl, 1",
  "ld [hl+], a",
  "dec bc",
  "ld a, b",
  "ld [hl], %u",
  "or a, h",
  "ld b, [hl]",
};

static const char* const helper_names[] = {
  "__cc_mul16", "__cc_divs16", "__cc_divu16", "__cc_mods16", "__cc_modu16", "__cc_shl16", "__cc_shrs16", "__cc_shru16",
  "__cc_jphl", "__cc_memcpy", "__cc_add32", "__cc_sub32", "__cc_and32", "__cc_or32", "__cc_xor32", "__cc_mul32",
  "__cc_divs32", "__cc_divu32", "__cc_mods32", "__cc_modu32", "__cc_shl32", "__cc_shrs32", "__cc_shru32",
  "__cc_cmps32", "__cc_cmpu32", "__cc_neg32"
};

// One instruction: a template (I_*), its operands a then b in order: %u 16-bit unsigned,

// %d signed, %L label, %S symbol's assembly name, %H runtime helper.

void helpers_comment(void) { // the helpers the unit calls (helper_names is on this page)
  u8 i;
  if (!helpers) return;
  gen_sink(SINK_CODE);
  out_str(SINK_CODE, "\n; runtime helpers:");
  for (i = 0; i < H_COUNT; ++i) if (helpers & (1ul << i)) { out_str(SINK_CODE, " "); out_str(SINK_CODE, helper_names[i]); }
  out_str(SINK_CODE, "\n");
}

// After a jp or ret nothing runs until the next label, so emit drops those instructions; a jp
// waits (cg_jump) and is dropped if its label comes next. Anything else written to the code
// sink first writes it (out_bytes), apart from line comments.
u8 cg_dead, cg_void, cg_jumping, cg_quiet;
static u16 cg_jump;
void emit(u8 op, u16 a, u16 b) {
  const char* f = templates[op];
  char buf[24];
  u8 n = 1, second = 0;
  if (cg_dead) return;
  if (op == I_JP_L && !cg_quiet) { cg_jump = a; cg_jumping = 1; cg_dead = 1; return; }
  if (op == I_RET) cg_dead = 1;
  buf[0] = '\t';
  for (;; ++f) {
    u16 v;
    if (*f && *f != '%') { buf[n++] = *f; continue; }
    out_bytes(SINK_CODE, buf, n); n = 0;
    if (!*f) break;
    v = second ? b : a; second = 1;
    switch (*++f) {
    case 'u': out_num(SINK_CODE, v); break;
    case 'd': out_num(SINK_CODE, (s16)v); break;
    case 'L': out_str(SINK_CODE, ".L"); out_num(SINK_CODE, v); break;
    case 'S': gen_sym_name(SINK_CODE, v); break;
    case 'H':
      helpers |= 1ul << v;
      if (cc_st.flags & CC_SDCC) { out_str(SINK_CODE, "__"); out_str(SINK_CODE, cc_st.unit); out_str(SINK_CODE, helper_names[v] + 1); }
      else out_str(SINK_CODE, helper_names[v]);
      break;
    }
  }
  out_str(SINK_CODE, "\n");
}

void gen_place(u16 label) {
  if (cg_jumping && cg_jump == label) cg_jumping = 0; // a jump to the next line
  cg_dead = 0;
  out_str(SINK_CODE, ".L"); out_num(SINK_CODE, label); out_str(SINK_CODE, ":\n");
}

void gen_comment_line(u16 line) {
  if (line == last_line) return;
  last_line = line;
  cg_quiet = 1; // before a waiting jp: a comment doesn't run
  out_str(SINK_CODE, "; line "); out_num(SINK_CODE, line); out_str(SINK_CODE, "\n");
  cg_quiet = 0;
}

// ---- stack ----

void push(u8 op) { E0(op); cg_depth += 2; }

void pop(u8 op) { E0(op); cg_depth -= 2; }

void move_sp(s16 bytes) { // SP += bytes; may use HL when far (only between statements, or with HL free)
  if (bytes >= -256 && bytes <= 254) {
    while (bytes > 127) { E0(I_ADD_SP_127); bytes -= 127; }
    while (bytes < -128) { E0(I_ADD_SP_N128); bytes += 128; }
    if (bytes) E1(I_ADD_SP_D, bytes);
  } else { E1(I_LD_HL_D, bytes); E0(I_ADD_HL_SP); E0(I_LD_SP_HL); }
}

void gen_alloc(u16 bytes) { move_sp((s16)-bytes); cg_depth = (s16)(cg_depth + bytes); }

void gen_free(u16 bytes) { move_sp((s16)bytes); cg_depth = (s16)(cg_depth - bytes); }

void gen_jump(u16 label, s16 depth) { move_sp((s16)(cg_depth - depth)); E1(I_JP_L, label); }

void sp_addr(s16 pos) { // HL = the address at frame position pos
  s16 k = (s16)(pos + cg_depth);
  if (k >= 0 && k <= 127) E1(I_LD_HL_SP_P_D, k);
  else if (k < 0 && k >= -128) E1(I_LD_HL_SP_N_D, -k);
  else { E1(I_LD_HL_D, k); E0(I_ADD_HL_SP); }
}

void load(u16 t) { // from the address in HL
  switch (TK(t)) {
  case T_BOOL: case T_CHAR: case T_UCHAR: E0(I_LD_L_MHL); E0(I_LD_H_0); return;
  case T_SCHAR: E0(I_LD_A_MHL); E0(I_LD_L_A); E0(I_ADD_A_A); E0(I_SBC_A_A); E0(I_LD_H_A); return;
  case T_INT: case T_UINT: case T_PTR: E0(I_LD_A_MHLI); E0(I_LD_H_MHL); E0(I_LD_L_A); return;
  case T_LONG: case T_ULONG:
    E0(I_LD_A_MHLI); E0(I_LD_C_A); E0(I_LD_A_MHLI); E0(I_LD_B_A); E0(I_LD_A_MHLI); E0(I_LD_E_A);
    E0(I_LD_D_MHL); E0(I_LD_H_B); E0(I_LD_L_C); return;
  }
}

void store_bc(u16 t) { // the value to the address in BC
  u16 size = size_of(t);
  E0(I_LD_A_L); E0(I_LD_MBC_A);
  if (size == 1) return;
  E0(I_INC_BC); E0(I_LD_A_H); E0(I_LD_MBC_A);
  if (size == 2) return;
  E0(I_INC_BC); E0(I_LD_A_E); E0(I_LD_MBC_A);
  E0(I_INC_BC); E0(I_LD_A_D); E0(I_LD_MBC_A);
}

void extend8(u8 is_signed) {
  if (is_signed) { E0(I_LD_A_L); E0(I_ADD_A_A); E0(I_SBC_A_A); E0(I_LD_H_A); }
  else E0(I_LD_H_0);
}

void conv(u16 from, u16 to) {
  u16 fs = size_of(from), ts = size_of(to);
  u8 fk = TK(from), tk = TK(to);
  if (tk == T_VOID || fk == T_VOID) return;
  if (tk == T_BOOL) {
    if (fk == T_BOOL) return;
    E0(I_LD_A_H); E0(I_OR_L);
    if (fs == 4) { E0(I_OR_D); E0(I_OR_E); }
    E0(I_ADD_A_XFF); E0(I_LD_HL_0); E0(I_RL_L);
    return;
  }
  if (ts == 1) { if (fk != T_BOOL && (fs != 1 || ty_is_signed(from) != ty_is_signed(to))) extend8(ty_is_signed(to)); return; }
  if (ts == 4 && fs < 4) {
    if (ty_is_signed(from)) { E0(I_LD_A_H); E0(I_ADD_A_A); E0(I_SBC_A_A); E0(I_LD_D_A); E0(I_LD_E_A); }
    else E0(I_LD_DE_0);
  }
}

void ld_named(u8 which, u16 n, s16 extra) { // the named object's address, offset by extra, in an instruction
  // e.g. "ld hl, " name+off "" / "ld [" name+off "], a"
  s32 off = ND_VAL(n) + extra;
  if (cg_dead) return;
  out_str(SINK_CODE, "\t"); out_str(SINK_CODE, named_parts[which][0]);
  gen_sym_name(SINK_CODE, ND_A(n));
  if (off) { out_str(SINK_CODE, off > 0 ? " + " : " - "); out_num(SINK_CODE, off > 0 ? off : -off); }
  out_str(SINK_CODE, named_parts[which][1]); out_str(SINK_CODE, "\n");
}

u8 log2_16(s32 v) { u8 k; for (k = 0; k < 16; ++k) if (v == (1l << k)) return k; return 0xFF; }

void shift_const(u8 op, u8 is_signed, u16 k) {
  if (k >= 16) { E0(I_LD_HL_0); return; }
  if (op == N_SHL) {
    if (k >= 8) { E0(I_LD_H_L); E0(I_LD_L_0); k -= 8; }
    while (k--) E0(I_ADD_HL_HL);
  } else {
    if (k >= 8) { E0(I_LD_L_H); if (is_signed) { E0(I_LD_A_H); E0(I_ADD_A_A); E0(I_SBC_A_A); E0(I_LD_H_A); } else E0(I_LD_H_0); k -= 8; }
    while (k--) { E0(is_signed ? I_SRA_H : I_SRL_H); E0(I_RR_L); }
  }
}

// HL op= constant for 16-bit types; returns 0 if a helper call is still needed

u8 const_op(u8 op, u16 t, s32 v) {
  u16 k = (u16)v; u8 sg = ty_is_signed(t), p;
  switch (op) {
  case N_ADD: case N_SUB:
    if (op == N_SUB) k = (u16)(0u - k);
    if (k == 0) return 1;
    if (k <= 3) { while (k--) E0(I_INC_HL); return 1; }
    if (k >= 0xFFFD) { while (k++) E0(I_DEC_HL); return 1; }
    E1(I_LD_DE_U, k); E0(I_ADD_HL_DE); return 1;
  case N_AND: case N_OR: case N_XOR: {
    u8 m = op == N_AND ? 0 : op == N_OR ? 1 : 2; // and, or, xor
    u8 lo = (u8)k, hi = (u8)(k >> 8);
    if (op == N_AND && lo == 0) E0(I_LD_L_0);
    else if (!(op != N_AND && lo == 0) && !(op == N_AND && lo == 0xFF)) { E0(I_LD_A_L); E1(I_AND_A_U + m, lo); E0(I_LD_L_A); }
    if (op == N_AND && hi == 0) E0(I_LD_H_0);
    else if (!(op != N_AND && hi == 0) && !(op == N_AND && hi == 0xFF)) { E0(I_LD_A_H); E1(I_AND_A_U + m, hi); E0(I_LD_H_A); }
    return 1;
  }
  case N_SHL: case N_SHR: shift_const(op, sg, k); return 1;
  case N_MUL: p = log2_16(k); if (p == 0xFF) return 0; shift_const(N_SHL, 0, p); return 1;
  case N_DIV: if (sg) return 0; p = log2_16(k); if (p == 0xFF) return 0; shift_const(N_SHR, 0, p); return 1;
  case N_MOD: if (sg) return 0; p = log2_16(k); if (p == 0xFF) return 0; return const_op(N_AND, t, k - 1);
  }
  return 0;
}

void binary16(u8 op, u16 t) { // HL = DE op HL
  u8 sg = ty_is_signed(t);
  switch (op) {
  case N_ADD: E0(I_ADD_HL_DE); return;
  case N_SUB: E0(I_LD_A_E); E0(I_SUB_A_L); E0(I_LD_L_A); E0(I_LD_A_D); E0(I_SBC_A_H); E0(I_LD_H_A); return;
  case N_AND: case N_OR: case N_XOR: {
    u8 m = op == N_AND ? 0 : op == N_OR ? 1 : 2; // and, or, xor
    E0(I_LD_A_L); E0(I_AND_A_E + m); E0(I_LD_L_A); E0(I_LD_A_H); E0(I_AND_A_D + m); E0(I_LD_H_A); return;
  }
  case N_MUL: E1(I_CALL_H, H_MUL16); return;
  case N_DIV: E1(I_CALL_H, sg ? H_DIVS16 : H_DIVU16); return;
  case N_MOD: E1(I_CALL_H, sg ? H_MODS16 : H_MODU16); return;
  case N_SHL: E1(I_CALL_H, H_SHL16); return;
  case N_SHR: E1(I_CALL_H, sg ? H_SHRS16 : H_SHRU16); return;
  }
}

void binary32(u8 op, u16 t) { // DEHL = (stack) op DEHL
  u8 sg = ty_is_signed(t), h = 0;
  switch (op) {
  case N_ADD: h = H_ADD32; break; case N_SUB: h = H_SUB32; break; case N_AND: h = H_AND32; break;
  case N_OR: h = H_OR32; break; case N_XOR: h = H_XOR32; break; case N_MUL: h = H_MUL32; break;
  case N_DIV: h = sg ? H_DIVS32 : H_DIVU32; break; case N_MOD: h = sg ? H_MODS32 : H_MODU32; break;
  case N_SHL: h = H_SHL32; break; case N_SHR: h = sg ? H_SHRS32 : H_SHRU32; break;
  }
  call_helper32(h);
}

// ---- output sinks: text in PSRAM, CC_SINK_BLOCKS blocks each ----

// Output gathers in ob (ob_n bytes of sink ob_sink, already counted in its sink_n) and goes to
// PSRAM 64 bytes at a time: most pieces are a few characters, and an m_put each was ~6% of a
// build. cc_pass_c calls out_flush before it reads the sinks.
static u8 ob[64], ob_n, ob_sink;
void out_flush(void) {
  u16 at;
  if (!ob_n) return;
  at = (u16)(cc_st.sink_n[ob_sink] - ob_n);
  m_put((u16)(CC_SINK_BLOCK + ob_sink * CC_SINK_BLOCKS + (at >> 9)), at & 511, ob, ob_n);
  ob_n = 0;
}
void out_bytes(u8 sink, const char* s, u16 n) {
  u16 at = cc_st.sink_n[sink];
  if ((u32)at + n > (u32)CC_SINK_BLOCKS * 512 - 1) cc_error(E_OUTPUT_TOO_LARGE);
  if (cg_jumping && sink == SINK_CODE && !cg_quiet) { // the waiting jp first
    u8 dead = cg_dead;
    cg_jumping = 0; cg_dead = 0; cg_quiet = 1;
    emit(I_JP_L, cg_jump, 0);
    cg_quiet = 0; cg_dead = dead;
    at = cc_st.sink_n[sink];
  }
  if (sink != ob_sink) { out_flush(); ob_sink = sink; }
  if (n > (u16)(sizeof(ob) - ob_n)) out_flush();
  cc_st.sink_n[sink] = (u16)(at + n);
  if (n > sizeof(ob)) { m_put((u16)(CC_SINK_BLOCK + sink * CC_SINK_BLOCKS + (at >> 9)), at & 511, s, n); return; }
  cc_copy(ob + ob_n, (const u8*)s, n);
  ob_n = (u8)(ob_n + n);
}

void out_num(u8 sink, s32 n) { // by subtraction: no SDCC division helpers in a module
  static const u32 tens[] = { 1000000000ul, 100000000ul, 10000000ul, 1000000ul, 100000ul, 10000ul, 1000ul, 100ul, 10ul, 1ul };
  char buf[12]; u8 i = 0, k, started = 0; u32 v = n < 0 ? 0u - (u32)n : (u32)n;
  if (n < 0) buf[i++] = '-';
  for (k = 0; k < 10; ++k) {
    char d = '0';
    while (v >= tens[k]) { v -= tens[k]; ++d; }
    if (d != '0' || started || k == 9) { buf[i++] = d; started = 1; }
  }
  out_bytes(sink, buf, i);
}

void out_name(u8 sink, u16 name) { char buf[CC_NAME_MAX + 1]; u8 n = name_copy(name, buf); out_bytes(sink, buf, n); }

void gen_sym_name(u8 sink, u16 s) {
  if (SY_KIND(s) == S_STATIC) { out_str(sink, "__"); out_str(sink, cc_st.unit); out_str(sink, "__s"); out_num(sink, SY_LABEL(s)); }
  else if (SY_LINKAGE(s) == L_INTERNAL) { out_str(sink, "__"); out_str(sink, cc_st.unit); out_str(sink, "_"); out_name(sink, SY_NAME(s)); }
  else { out_str(sink, "_"); out_name(sink, SY_NAME(s)); }
}

