// enums, typedef'd function pointers, static functions, local string arrays, offsetof,
// conditional pointers, nested struct arrays, char compares in branches
#include "check.h"
#include <stddef.h>
#include <stdbool.h>
#include <limits.h>
enum color { RED, GREEN = 5, BLUE, LAST = BLUE + 10 };
typedef int (*binop)(int, int);
static int add(int a, int b) { return a + b; }
static int sub(int a, int b) { return a - b; }
static binop ops[2] = { add, sub };
struct inner { char name[4]; int vals[2]; };
struct outer { int id; struct inner in[2]; };
struct outer o = { 7, { { "ab", { 1, 2 } }, { "cd", { 3, 4 } } } };
static bool is_digit(char c) { return c >= '0' && c <= '9'; }
static int parse(const char* s) { int v = 0; while (is_digit(*s)) v = v * 10 + (*s++ - '0'); return v; }
static long lfact(int n) { return n <= 1 ? 1 : n * lfact(n - 1); }
int main(void) {
  char word[] = "word";
  char sized[6] = "ab";
  int a = 3, b = 4;
  int* p = a > b ? &a : &b;
  enum color c = BLUE;
  unsigned char uc = 200;
  int k, s = 0;
  CHECK(RED == 0 && GREEN == 5 && BLUE == 6 && LAST == 16 && c == 6);
  CHECK(ops[0](2, 3) == 5 && ops[1](2, 3) == -1);
  CHECK(sizeof(word) == 5 && word[3] == 'd' && word[4] == 0);
  CHECK(sized[1] == 'b' && sized[2] == 0 && sized[5] == 0);
  CHECK(*p == 4); p = a < b ? &a : 0; CHECK(p == &a);
  CHECK(o.in[1].name[1] == 'd' && o.in[1].vals[1] == 4 && o.in[0].vals[0] == 1 && o.id == 7);
  CHECK(offsetof(struct outer, in) == 2 && offsetof(struct inner, vals) == 4);
  { char arr[offsetof(struct outer, in[1])]; CHECK(sizeof(arr) == 10); }
  CHECK(parse("1234x") == 1234);
  if (uc > 199) s = 1; CHECK(s == 1);
  if (uc < 100 || uc == 200) s = 2; CHECK(s == 2);
  CHECK(lfact(10) == 3628800l);
  for (k = 0, s = 0; k < 10; k++) { if (k & 1) continue; s += k; } CHECK(s == 20);
  k = 0; do { if (k == 2) { k += 10; continue; } k++; } while (k < 5); CHECK(k == 12);
  CHECK(INT_MAX == 32767 && INT_MIN < -32767 && UINT_MAX == 65535u && LONG_MAX == 2147483647l);
  CHECK(true && !false);
  return 0;
}
