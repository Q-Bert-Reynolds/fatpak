// frames beyond SP+127, recursion with locals
#include "check.h"
int fill(int n) {
  unsigned char big[300];
  int i, s = 0;
  for (i = 0; i < 300; ++i) big[i] = (unsigned char)(i + n);
  for (i = 0; i < 300; i += 50) s += big[i];
  return s + big[299];
}
int depth(int n) { char pad[20]; pad[0] = (char)n; pad[19] = 1; return n ? depth(n - 1) + pad[19] : pad[0]; }
int after_big(int a, int b, int c) {
  int before = a;
  char big[200];
  int after = b;
  big[199] = (char)c;
  return before + after + big[199];
}
int main(void) {
  CHECK(fill(0) == 0 + 50 + 100 + 150 + 200 + 250 + 43);
  CHECK(depth(20) == 20);
  CHECK(after_big(1, 2, 3) == 6);
  return 0;
}
