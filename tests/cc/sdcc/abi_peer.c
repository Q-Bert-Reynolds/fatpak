// Compiled by SDCC (sdcccall(1)) for tests/cc/abi.c: each s_* combines its arguments so a
// misplaced byte shows; each call_* calls back into CC's c_* with known arguments.
// No multiplication or division: those would need SDCC's library.
typedef unsigned char u8;
typedef signed char s8;
typedef unsigned int u16;
typedef unsigned long u32;
u16 s_b(u8 a) { return a ^ 0x5A00; }
u16 s_w(u16 a) { return a ^ 0x1111; }
u32 s_l(u32 a) { return a ^ 0x01020304ul; }
u16 s_bb(u8 a, u8 b) { return ((u16)a << 8) | b; }
u16 s_bw(u8 a, u16 b) { return a + (b ^ 0x0F0F); }
u16 s_wb(u16 a, u8 b) { return (a ^ 0x0F0F) - b; }
u16 s_ww(u16 a, u16 b) { return a - b; }
u32 s_bl(u8 a, u32 b) { return b - a; }
u32 s_lb(u32 a, u8 b) { return a + ((u32)b << 24); }
u32 s_wl(u16 a, u32 b) { return b ^ a; }
u32 s_lw(u32 a, u16 b) { return a - b; }
u32 s_ll(u32 a, u32 b) { return a - b; }
u16 s_bbb(u8 a, u8 b, u8 c) { return (u16)(a << 8) + (b << 4) + c; }
u16 s_wwbw(u16 a, u16 b, u8 c, u16 d) { return a + b + b + c + c + c + d + d + d + d; }
u32 s_bwbl(u8 a, u16 b, u8 c, u32 d) { return d - a - b - c; }
u8 s_rb(u8 a) { return a + 1; }
s8 s_rsb(s8 a) { return a - 1; }
u8* s_rp(u8* p) { return p + 2; }
void s_store(u16* p, u16 v) { *p = v; }

u16 c_bb(u8 a, u8 b);
u16 c_wwbw(u16 a, u16 b, u8 c, u16 d);
u32 c_lw(u32 a, u16 b);
u32 c_bl(u8 a, u32 b);
u16 c_bwbl(u8 a, u16 b, u8 c, u32 d);
s8 c_rsb(s8 a);
u16 call_bb(void) { return c_bb(0x12, 0x34); }
u16 call_wwbw(void) { return c_wwbw(1, 2, 3, 4); }
u32 call_lw(void) { return c_lw(0x10000ul, 5); }
u32 call_bl(void) { return c_bl(7, 0x12345678ul); }
u16 call_bwbl(void) { return c_bwbl(1, 0x200, 3, 0x40000ul); }
s8 call_rsb(void) { return c_rsb(-100); }
