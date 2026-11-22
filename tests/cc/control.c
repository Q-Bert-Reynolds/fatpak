// loops, switch, goto across stack depths, recursion, values live across calls
#include "check.h"
int fib(int n) { return n < 2 ? n : fib(n - 1) + fib(n - 2); }
int fact(int n) { if (n <= 1) return 1; return n * fact(n - 1); }
int classify(int x) {
  switch (x) { case 0: return 10; case 1: case 2: return 20; case -1: return 30; case 1000: return 40; default: return 50; }
}
int fallthrough(int x) {
  int r = 0;
  switch (x) { case 1: r += 1; case 2: r += 2; break; case 3: { int t = 5; r = t; break; } default: r = -1; }
  return r;
}
int into_block(int x) {
  int r = 0;
  switch (x) { case 0: { int a = 1, b = 2; r = a + b; case 1: r += 7; break; } case 2: r = 9; }
  return r;
}
int no_default(char c) { int r = 1; switch (c) { case 'a': r = 2; break; case 'z': r = 3; } return r; }
int loops(void) {
  int i, s = 0, n = 3, c = 0, j;
  for (i = 0; i < 10; i++) { if (i == 3) continue; if (i == 8) break; s += i; }
  CHECK(s == 25);
  do { c++; } while (--n > 0);
  CHECK(c == 3);
  s = 0;
  for (int a = 0; a < 4; ++a) { int arr[3]; for (j = 0; j < 3; ++j) { arr[j] = a * j; if (j == 2) break; } s += arr[2]; }
  CHECK(s == 12);
  n = 0; while (1) { int k = n * 2; if (k > 10) break; n++; } CHECK(n == 6);
  for (;;) { if (++n == 9) break; } CHECK(n == 9);
  return 0;
}
int gotos(int n) {
  int r = 0;
again:
  if (n > 0) { int k = n; r += k; n--; goto again; }
  { int z = 1; if (r > 5) goto out; r = -r + z; }
  goto skip;
  { int w = 3; skip: r += 1; (void)w; }
out:
  return r;
}
int live(int a) { int b = a * 2; int c = fib(5) + b; return c + a + fib(3); }
int main(void) {
  CHECK(fib(10) == 55); CHECK(fact(7) == 5040);
  CHECK(classify(0) == 10); CHECK(classify(2) == 20); CHECK(classify(-1) == 30);
  CHECK(classify(1000) == 40); CHECK(classify(999) == 50); CHECK(classify(-32768) == 50);
  CHECK(fallthrough(1) == 3); CHECK(fallthrough(2) == 2); CHECK(fallthrough(3) == 5); CHECK(fallthrough(4) == -1);
  CHECK(into_block(0) == 10); CHECK(into_block(1) == 7); CHECK(into_block(2) == 9); CHECK(into_block(3) == 0);
  CHECK(no_default('a') == 2); CHECK(no_default('z') == 3); CHECK(no_default('q') == 1);
  RUN(loops);
  CHECK(gotos(3) == 6); CHECK(gotos(1) == 1); CHECK(gotos(0) == 2);
  CHECK(live(4) == 4 + 8 + 5 + 2);
  return 0;
}
