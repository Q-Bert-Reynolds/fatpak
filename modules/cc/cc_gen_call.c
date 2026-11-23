// CC pass C: function calls (their own page: cc_gen_code.c's was full).
#define CC_PAGE gen_call
#define CC_NEED_ty_r8
#define CC_NEED_ty_r16
#define CC_NEED_nd_r8
#define CC_NEED_nd_r16
#define CC_NEED_out_str
#include "cc_gen.h"

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

// CC_SDCC with helpers: the runtime's text after the unit's code (the same fragment, so the same
// bank), every __cc_ name as __<unit>_cc_ (C units never share them), without its comment and
// SECTION lines. The unit then needs nothing else: rgbasm on a PC assembles it too.
void copy_runtime(void) {
  char in[64], line[96];
  u16 pos = 0, got = 0, at = 0;
  u8 n = 0, i, c, keep = 1, first = 1;
  gen_sink(SINK_CODE);
  for (;;) {
    if (at == got) { got = cc_host_runtime(pos, in, sizeof(in)); pos += got; at = 0; if (!got) break; }
    c = (u8)in[at++];
    if (first) { keep = c != ';' && c != 'S'; first = 0; }
    if (c == '\r') continue;
    if (n > sizeof(line) - 24) { if (keep) out_bytes(SINK_CODE, line, n); n = 0; }
    line[n++] = (char)c;
    if (n >= 5 && line[n - 5] == '_' && line[n - 4] == '_' && line[n - 3] == 'c' && line[n - 2] == 'c' && line[n - 1] == '_') {
      n -= 3; // __cc_ -> __<unit>_cc_
      for (i = 0; cc_st.unit[i]; ++i) line[n++] = cc_st.unit[i];
      line[n++] = '_'; line[n++] = 'c'; line[n++] = 'c'; line[n++] = '_';
    }
    if (c == '\n') { if (keep) out_bytes(SINK_CODE, line, n); n = 0; first = 1; }
  }
  if (n && keep) out_bytes(SINK_CODE, line, n);
  out_str(SINK_CODE, "\n");
}
#ifndef CC_HOST
// (the Game Boy's; tests/cc_host.c has the PC's) /GBCSYS/CC/ccrt.asm, loaded into the includes' PSRAM (pass A's, free now) the first time
u16 cc_host_runtime(u16 pos, char* dest, u16 n) {
  static const char rt[] = "GBCSYS/CC/ccrt.asm";
  static u16 size;
  static u8 loaded;
  if (!loaded) {
    ModuleLoad load;
    load.block = CC_INCLUDE_BLOCK;
    load.blocks = 128;
    loaded = 1;
    size = cc_load_os(rt, &load) ? 0 : (u16)load.size;
  }
  if (pos >= size) return 0;
  if (n > size - pos) n = (u16)(size - pos);
  m_get((u16)(CC_INCLUDE_BLOCK + (pos >> 9)), pos & 511, dest, n);
  return n;
}
#endif
