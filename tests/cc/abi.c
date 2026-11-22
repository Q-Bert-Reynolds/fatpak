// sdcccall(1) both ways: CC calls functions SDCC compiled (tests/cc/sdcc/abi_peer.c) and
// SDCC calls functions CC compiled.
// peer: sdcc/abi_peer.c
#include "check.h"
typedef unsigned char u8;
typedef signed char s8;
typedef unsigned int u16;
typedef unsigned long u32;
u16 s_b(u8 a); u16 s_w(u16 a); u32 s_l(u32 a);
u16 s_bb(u8 a, u8 b); u16 s_bw(u8 a, u16 b); u16 s_wb(u16 a, u8 b); u16 s_ww(u16 a, u16 b);
u32 s_bl(u8 a, u32 b); u32 s_lb(u32 a, u8 b); u32 s_wl(u16 a, u32 b); u32 s_lw(u32 a, u16 b);
u32 s_ll(u32 a, u32 b); u16 s_bbb(u8 a, u8 b, u8 c); u16 s_wwbw(u16 a, u16 b, u8 c, u16 d);
u32 s_bwbl(u8 a, u16 b, u8 c, u32 d); u8 s_rb(u8 a); s8 s_rsb(s8 a); u8* s_rp(u8* p);
void s_store(u16* p, u16 v);
u16 call_bb(void); u16 call_wwbw(void); u32 call_lw(void); u32 call_bl(void); u16 call_bwbl(void);
s8 call_rsb(void);
u16 c_bb(u8 a, u8 b) { return a * 256u + b; }
u16 c_wwbw(u16 a, u16 b, u8 c, u16 d) { return a * 1000u + b * 100u + c * 10u + d; }
u32 c_lw(u32 a, u16 b) { return a * b; }
u32 c_bl(u8 a, u32 b) { return b + a; }
u16 c_bwbl(u8 a, u16 b, u8 c, u32 d) { return a + b + c + (u16)(d >> 8); }
s8 c_rsb(s8 a) { return a / 2; }
int main(void) {
  u8 buf[4];
  u16 w = 0;
  CHECK(s_b(0xA5) == 0x5AA5); CHECK(s_w(0x1234) == 0x0325); CHECK(s_l(0x10203040ul) == 0x11223344ul);
  CHECK(s_bb(0x12, 0x34) == 0x1234); CHECK(s_bw(1, 0x0F0F) == 1); CHECK(s_wb(0x0F0F, 1) == 0xFFFF);
  CHECK(s_ww(10, 3) == 7); CHECK(s_bl(1, 0x10000ul) == 0xFFFFul); CHECK(s_lb(1, 2) == 0x02000001ul);
  CHECK(s_wl(0xFFFF, 0x12340000ul) == 0x1234FFFFul); CHECK(s_lw(0x10000ul, 1) == 0xFFFFul);
  CHECK(s_ll(0xFFFFFFFFul, 0xFFFFFFFEul) == 1);
  CHECK(s_bbb(1, 2, 3) == 0x123); CHECK(s_wwbw(1, 2, 3, 4) == 30); CHECK(s_bwbl(1, 2, 3, 100) == 94);
  CHECK(s_rb(255) == 0); CHECK(s_rsb(-128) == 127); CHECK(s_rsb(0) == -1); CHECK(s_rp(buf) == buf + 2);
  s_store(&w, 0xBEEF); CHECK(w == 0xBEEF);
  CHECK(call_bb() == 0x1234); CHECK(call_wwbw() == 1234); CHECK(call_lw() == 0x50000ul);
  CHECK(call_bl() == 0x1234567Ful); CHECK(call_bwbl() == 0x200 + 4 + 0x400); CHECK(call_rsb() == -50);
  return 0;
}
