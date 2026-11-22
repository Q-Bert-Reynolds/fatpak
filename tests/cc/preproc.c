// the preprocessor: includes and guards, nested function-like macros, #if arithmetic
#include "check.h"
#include "preproc.h"
#include "preproc.h"
#define MAX(a, b) ((a) > (b) ? (a) : (b))
#define FOUR TWICE(2)
#define EMPTY
#define CALL(f, x) f(x)
#define SELF SELF
#define LEVEL 3
#if LEVEL > 2 && defined(MAX) && !defined(NOPE)
#define DEEP 1
#elif LEVEL
#define DEEP 2
#else
#define DEEP 3
#endif
#ifdef NOPE
#error not here
#endif
#if (1 << 4) == 16 && -1 < 0 && 0xFFFF > 0 && (7 / 2 == 3) && (5 % 3 == 2)
#define ARITH 1
#endif
#if 0
'unterminated text in a skipped block
#endif
#undef LEVEL
#ifndef LEVEL
#define UNDEFINED_OK 1
#endif
int included_function(int x) { return TWICE(x) + 1; }
int main(void) {
  int SELF = 4;
  CHECK(MAX(3, MAX(9, 4)) == 9); CHECK(FOUR == 4); CHECK(CALL(TWICE, 5) == 10);
  CHECK(DEEP == 1); CHECK(ARITH == 1); CHECK(UNDEFINED_OK == 1);
  CHECK(included_function(2) == 5); CHECK(SELF == 4);
  CHECK(__LINE__ == 37); EMPTY
  CHECK(MAX(1, 2) EMPTY == 2);
  return 0;
}
