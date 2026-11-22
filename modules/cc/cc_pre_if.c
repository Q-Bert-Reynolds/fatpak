// CC pass A: #if arithmetic.
#define CC_PAGE pre_if
#include "cc_pre.h"

void pp_unary(PPV* r) {
  r->u = 0; r->v = 0;
  switch (ppt.kind) {
  case TK_NUM: r->v = (s32)ppt.v; r->u = (ppt.flags & TF_UNSIGNED) || ppt.v > 0x7FFFFFFFul; pp_adv(); return;
  case TK_CHAR: r->v = (s32)ppt.v; pp_adv(); return;
  case TK_ID: pp_adv(); return; // an identifier left after expansion is 0
  case '(': pp_adv(); pp_expr(0, r); if (ppt.kind != ')') cc_error(E_MISSING_IN_HASH_IF); pp_adv(); return;
  case '+': pp_adv(); pp_unary(r); return;
  case '-': pp_adv(); pp_unary(r); r->v = (s32)(0u - (u32)r->v); return;
  case '~': pp_adv(); pp_unary(r); r->v = ~r->v; return;
  case '!': pp_adv(); pp_unary(r); r->v = !r->v; r->u = 0; return;
  }
  cc_error(E_BAD_HASH_IF_EXPRESSION);
}

u8 pp_prec(u8 k) {
  switch (k) {
  case '?': return 1; case TK_OROR: return 2; case TK_ANDAND: return 3; case '|': return 4; case '^': return 5;
  case '&': return 6; case TK_EQ: case TK_NE: return 7; case '<': case '>': case TK_LE: case TK_GE: return 8;
  case TK_SHL: case TK_SHR: return 9; case '+': case '-': return 10; case '*': case '/': case '%': return 11;
  }
  return 0;
}

void pp_expr(u8 min, PPV* l) {
  PPV r;
  pp_unary(l);
  for (;;) {
    u8 k = ppt.kind, p = pp_prec(k), u;
    if (!p || p <= min) return;
    pp_adv();
    if (k == '?') {
      PPV a, b;
      pp_expr(0, &a);
      if (ppt.kind != ':') cc_error(E_MISSING_IN_HASH_IF_2);
      pp_adv(); pp_expr(0, &b);
      u = a.u | b.u;
      l->v = l->v ? a.v : b.v; l->u = u; // (no struct copy: SDCC would call memcpy)
      continue;
    }
    pp_expr(p, &r);
    u = l->u | r.u;
    switch (k) {
    case TK_OROR: l->v = l->v || r.v; u = 0; break;
    case TK_ANDAND: l->v = l->v && r.v; u = 0; break;
    case '|': l->v |= r.v; break; case '^': l->v ^= r.v; break; case '&': l->v &= r.v; break;
    case TK_EQ: l->v = l->v == r.v; u = 0; break; case TK_NE: l->v = l->v != r.v; u = 0; break;
    case '<': l->v = u ? (u32)l->v < (u32)r.v : l->v < r.v; u = 0; break;
    case '>': l->v = u ? (u32)l->v > (u32)r.v : l->v > r.v; u = 0; break;
    case TK_LE: l->v = u ? (u32)l->v <= (u32)r.v : l->v <= r.v; u = 0; break;
    case TK_GE: l->v = u ? (u32)l->v >= (u32)r.v : l->v >= r.v; u = 0; break;
    case TK_SHL: l->v = (s32)((u32)l->v << (r.v & 31)); break;
    case TK_SHR: l->v = u ? (s32)((u32)l->v >> (r.v & 31)) : l->v >> (r.v & 31); break;
    case '+': l->v = (s32)((u32)l->v + (u32)r.v); break;
    case '-': l->v = (s32)((u32)l->v - (u32)r.v); break;
    case '*': l->v = (s32)cc_mul32((u32)l->v, (u32)r.v); break;
    case '/': case '%':
      if (!r.v) cc_error(E_DIVISION_BY_ZERO_IN_HASH_IF);
      if (u) { u32 rem, q = cc_divmod32((u32)l->v, (u32)r.v, &rem); l->v = (s32)(k == '/' ? q : rem); }
      else if (l->v == (s32)0x80000000l && r.v == -1) l->v = k == '/' ? l->v : 0;
      else l->v = cc_sdivmod32(l->v, r.v, k == '%');
      break;
    }
    l->u = u;
  }
}

void pp_adv(void) { pp_next(&ppt); }
