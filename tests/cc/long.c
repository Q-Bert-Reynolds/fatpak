// 32-bit arithmetic through the runtime helpers
#include "check.h"
long sq(long x) { return x * x; }
int main(void) {
  long a = 100000l, b = -3l, z = 0;
  unsigned long u = 0xFFFFFFFFul, v = 0x80000000ul;
  int i = -2;
  unsigned w = 40000u;
  CHECK(a + b == 99997l); CHECK(a - b == 100003l); CHECK(a * b == -300000l);
  CHECK(a / b == -33333l); CHECK(a % b == 1); CHECK(-a / 7 == -14285l); CHECK(-a % 7 == -5);
  CHECK(u / 3 == 0x55555555ul); CHECK(u % 10 == 5); CHECK(v / 0x10000ul == 0x8000ul);
  CHECK(u / v == 1); CHECK(u % v == 0x7FFFFFFFul); CHECK(u / 0xFFFFFFFEul == 1);
  CHECK(sq(46340l) == 2147395600l);
  CHECK((a << 3) == 800000l); CHECK((b >> 1) == -2l); CHECK((v >> 31) == 1); CHECK((u << 31) == 0x80000000ul);
  CHECK(a > b); CHECK(b < z); CHECK(!(a < b)); CHECK(a >= a); CHECK(b <= z); CHECK(u > v); CHECK(a != b);
  CHECK(-a == -100000l); CHECK(~z == -1l); CHECK(!z); CHECK((a & 0xFFFF) == 0x86A0);
  CHECK((a | 1) == 100001l); CHECK((a ^ a) == 0);
  CHECK(i == -2l); CHECK((long)i < 0); CHECK((long)w == 40000l); CHECK((unsigned long)i == 0xFFFFFFFEul);
  CHECK((int)a == (int)0x86A0); CHECK((unsigned char)a == 0xA0);
  a += 1; CHECK(a == 100001l); a *= 2; CHECK(a == 200002l); a >>= 1; CHECK(a == 100001l); a -= i; CHECK(a == 100003l);
  a++; CHECK(a == 100004l); a--; --a; CHECK(a == 100002l);
  { long c = 0xFFFFl; c++; CHECK(c == 0x10000l); c--; CHECK(c == 0xFFFFl); }
  { long d = 0x10000l; CHECK(d-- == 0x10000l && d == 0xFFFFl); CHECK(++d == 0x10000l); }
  CHECK(sizeof(a) == 4 && sizeof(a + i) == 4);
  CHECK(70000 == 70000l); CHECK(sizeof(70000) == 4); CHECK(sizeof(0xFFFF) == 2); CHECK(sizeof(65535) == 4);
  return 0;
}
