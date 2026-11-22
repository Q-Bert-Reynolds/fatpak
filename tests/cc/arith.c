// integer arithmetic: promotions, signed/unsigned boundaries, carries, division, shifts
#include "check.h"
int count;
int side(int v) { ++count; return v; }
int ints(void) {
  int x = -7, y = 2, lo = -32768, hi = 32767, z = 0;
  unsigned u = 65535u, v = 50000u, one = 1;
  CHECK(x / y == -3); CHECK(x % y == -1);
  CHECK(-x / y == 3); CHECK(7 % -y == 1); CHECK(x % -y == -1);
  CHECK(x * 3 == -21); CHECK(x * -3 == 21);
  CHECK(u / 2 == 32767u); CHECK(v % 7 == 6); CHECK(v / 7 == 7142);
  CHECK(300u * (unsigned)y * 100u == 60000u);
  CHECK((unsigned)hi + one == 32768u);
  CHECK(u + one == 0);
  CHECK(lo < hi); CHECK(hi > lo); CHECK(lo <= lo); CHECK(!(hi < lo)); CHECK(lo != hi);
  CHECK(lo < 0); CHECK(hi >= 0); CHECK(-1 < z); CHECK(z > -1);
  CHECK(!(x < one)); CHECK(x < 1);  // -7 < 1u converts to unsigned
  CHECK(u > v); CHECK(v >= 50000u); CHECK(v > 32767);
  CHECK(-x == 7); CHECK(~x == 6); CHECK(!z); CHECK(!!x == 1);
  CHECK((x & 0xFF00) == (int)0xFF00); CHECK((x | 0x00F0) == -7); CHECK((x ^ 0xFFFF) == 6);
  CHECK(x + 3 == -4); CHECK(x - 3 == -10); CHECK(x + -2 == -9); CHECK(x + 300 == 293);
  CHECK(x * 8 == -56); CHECK(u / 16 == 4095); CHECK(u % 16 == 15);
  return 0;
}
int shifts(void) {
  int s = 3, n = -16, k = 9, w = 1;
  unsigned m = 0x8000u, f = 0xFFFFu;
  CHECK(5 << s == 40); CHECK(n >> 2 == -4); CHECK(n >> s == -2); CHECK((m >> s) == 0x1000u);
  CHECK(f >> 8 == 255); CHECK(f >> k == 127); CHECK((n >> 9) == -1); CHECK((w << 14) == 0x4000);
  CHECK((m >> 15) == 1); CHECK(((unsigned)n >> 12) == 15); CHECK((1u << k) == 512);
  CHECK(((unsigned)n << 4) == 0xFF00u); CHECK((f << s) == 0xFFF8u);
  return 0;
}
int chars(void) {
  unsigned char c = 200, z = 255;
  signed char sc = -5, big = 100;
  char plain = 250;
  CHECK(c + c == 400); CHECK(sc * 2 == -10); CHECK((unsigned char)(c + 100) == 44);
  CHECK(sc < 0); CHECK((unsigned char)sc == 251); CHECK(c > sc); CHECK(plain > 0);
  CHECK(big + big == 200); CHECK((signed char)c == -56); CHECK((int)(signed char)z == -1);
  c += 100; CHECK(c == 44);
  z++; CHECK(z == 0); z--; CHECK(z == 255);
  CHECK(sizeof(c) == 1); CHECK(sizeof(c + c) == 2); CHECK(sizeof(int) == 2); CHECK(sizeof(long) == 4);
  CHECK(sizeof(char*) == 2); CHECK(sizeof(short) == 2);
  CHECK('A' == 65); CHECK('\n' == 10); CHECK('\x7f' == 127); CHECK('\377' == 255);
  return 0;
}
int compound(void) {
  int x = 10, i = 5, j;
  unsigned char b = 250;
  x += 5; CHECK(x == 15); x -= 3; CHECK(x == 12); x *= 4; CHECK(x == 48); x /= 3; CHECK(x == 16);
  x %= 5; CHECK(x == 1); x <<= 4; CHECK(x == 16); x >>= 1; CHECK(x == 8); x &= 12; CHECK(x == 8);
  x |= 3; CHECK(x == 11); x ^= 6; CHECK(x == 13); x -= 20; CHECK(x == -7); x /= 2; CHECK(x == -3);
  x *= i; CHECK(x == -15); x %= i + 3; CHECK(x == -7); x *= i - 1; CHECK(x == -28);
  b += 10; CHECK(b == 4); b -= 5; CHECK(b == 255); b <<= 1; CHECK(b == 254); b >>= 4; CHECK(b == 15);
  j = i++; CHECK(j == 5 && i == 6); j = ++i; CHECK(j == 7 && i == 7);
  j = i--; CHECK(j == 7 && i == 6); j = --i; CHECK(j == 5 && i == 5);
  return 0;
}
int logic(void) {
  int t = 1, f = 0, r;
  count = 0;
  r = f && side(1); CHECK(r == 0 && count == 0);
  r = t || side(1); CHECK(r == 1 && count == 0);
  r = t && side(2); CHECK(r == 1 && count == 1);
  r = f || side(0); CHECK(r == 0 && count == 2);
  r = (t && f) || (t && !f); CHECK(r == 1);
  r = t ? f ? 1 : 2 : 3; CHECK(r == 2);
  r = (side(5), side(6)); CHECK(r == 6 && count == 4);
  r = t > f ? side(9) : side(10); CHECK(r == 9 && count == 5);
  if (t && (f || t) && !(f && side(1))) r = 11; else r = 12;
  CHECK(r == 11 && count == 5);
  { _Bool b = 5; CHECK(b == 1); b = 0x100; CHECK(b == 1); b = 0; CHECK(b == 0); b = t - 1; CHECK(!b); }
  return 0;
}
int main(void) {
  RUN(ints); RUN(shifts); RUN(chars); RUN(compound); RUN(logic);
  return 0;
}
