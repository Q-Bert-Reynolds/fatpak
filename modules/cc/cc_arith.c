// Passes A and B: arithmetic without SDCC's helpers (a module can't link them).
#define CC_PAGE arith
#include "cc_acc.h"

// ---- arithmetic without SDCC's helpers (a module can't link them) ----
u32 cc_mul32(u32 a, u32 b) {
  u32 r = 0;
  while (b) { if (b & 1) r += a; a <<= 1; b >>= 1; }
  return r;
}
u16 cc_mul16(u16 a, u16 b) {
  u16 r = 0;
  while (b) { if (b & 1) r += a; a <<= 1; b >>= 1; }
  return r;
}
u32 cc_divmod32(u32 a, u32 b, u32* rem) { // b nonzero
  u32 q = 0, r = 0;
  u8 i;
  for (i = 0; i < 32; ++i) {
    r = r << 1 | a >> 31; a <<= 1; q <<= 1;
    if (r >= b) { r -= b; q |= 1; }
  }
  if (rem) *rem = r;
  return q;
}
// C's signed division: the quotient truncates toward zero, the remainder takes the dividend's sign
s32 cc_sdivmod32(s32 a, s32 b, u8 want_rem) {
  u32 r, q = cc_divmod32(a < 0 ? 0u - (u32)a : (u32)a, b < 0 ? 0u - (u32)b : (u32)b, &r);
  if (want_rem) return a < 0 ? (s32)(0u - r) : (s32)r;
  return (a < 0) != (b < 0) ? (s32)(0u - q) : (s32)q;
}

