// sdcccall(1) argument and return combinations, stack arguments, function pointers
#include "check.h"
typedef unsigned char u8;
typedef unsigned int u16;
typedef unsigned long u32;
u16 f_b(u8 a) { return a; }
u16 f_bb(u8 a, u8 b) { return a * 256u + b; }
u16 f_bw(u8 a, u16 b) { return a + b; }
u16 f_wb(u16 a, u8 b) { return a - b; }
u16 f_ww(u16 a, u16 b) { return a - b; }
u16 f_bbb(u8 a, u8 b, u8 c) { return a * 100u + b * 10u + c; }
u16 f_wwbw(u16 a, u16 b, u8 c, u16 d) { return a + b * 2 + c * 3 + d * 4; }
u16 f_bwbl(u8 a, u16 b, u8 c, u32 d) { return a + b + c + (u16)(d >> 16); }
u32 f_l(u32 a) { return a + 1; }
u32 f_lw(u32 a, u16 b) { return a + b; }
u32 f_wl(u16 a, u32 b) { return b - a; }
u32 f_bl(u8 a, u32 b) { return b * a; }
u32 f_lb(u32 a, u8 b) { return a >> b; }
u32 f_ll(u32 a, u32 b) { return a ^ b; }
u8 r_b(u8 x) { return x + 1; }
signed char r_sb(void) { return -3; }
_Bool r_bool(int x) { return x; }
char* r_p(char* p) { return p + 1; }
void set(int* p, int v) { *p = v; }
int many(int a, int b, int c, int d, int e, int f) { return a - b + c - d + e - f; }
int (*fp)(int, int, int, int, int, int) = many;
u16 apply(u16 (*f)(u16, u16), u16 x, u16 y) { return f(x, y); }
int main(void) {
  char s[3];
  int v = 0;
  u8 k = 7;
  u16 (*g)(u8, u8) = f_bb;
  CHECK(f_b(200) == 200);
  CHECK(f_bb(1, 2) == 258); CHECK(f_bw(5, 1000) == 1005); CHECK(f_wb(1000, 5) == 995);
  CHECK(f_ww(50000u, 1) == 49999u); CHECK(f_bbb(1, 2, 3) == 123);
  CHECK(f_wwbw(1, 2, 3, 4) == 1 + 4 + 9 + 16);
  CHECK(f_bwbl(1, 2, 3, 0x50000ul) == 11);
  CHECK(f_l(0xFFFFul) == 0x10000ul); CHECK(f_lw(0x1FFFFul, 1) == 0x20000ul);
  CHECK(f_wl(1, 0x10000ul) == 0xFFFFul); CHECK(f_bl(3, 0x20000ul) == 0x60000ul);
  CHECK(f_lb(0x80000000ul, 31) == 1); CHECK(f_ll(0x12345678ul, 0xFFFFFFFFul) == 0xEDCBA987ul);
  CHECK(r_b(255) == 0); CHECK(r_b(k) == 8); CHECK(r_sb() == -3); CHECK(r_sb() < 0);
  CHECK(r_bool(256) == 1); CHECK(r_bool(0) == 0);
  CHECK(r_p(s) == s + 1);
  set(&v, 77); CHECK(v == 77);
  CHECK(many(60, 1, 2, 3, 4, 5) == 57); CHECK(fp(60, 1, 2, 3, 4, 5) == 57); CHECK((*fp)(1, 1, 1, 1, 1, 1) == 0);
  CHECK(apply(f_ww, 10, 4) == 6); CHECK(g(2, 3) == 515);
  CHECK(f_ww(f_ww(10, 3), f_bb(0, 2)) == 5);
  CHECK(f_wwbw(f_b(1), f_bb(0, 2), r_b(2), many(10, 1, 1, 1, 1, 1) - 5) == 1 + 4 + 9 + 16);
  return 0;
}
