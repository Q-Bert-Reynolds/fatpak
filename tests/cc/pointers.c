// arrays, pointer arithmetic and scaling, strings, *p = f(), post-increment stores
#include "check.h"
int arr[5] = {1, 2, 3, 4, 5};
int counter;
char buf[8];
int sum(const int* p, int n) { int s = 0; while (n--) s += *p++; return s; }
int* pick(int* p, int i) { return p + i; }
int next_value(void) { return ++counter * 10; }
void copy(char* d, const char* s) { while ((*d++ = *s++)) ; }
int length(const char* s) { const char* p = s; while (*p) ++p; return p - s; }
int main(void) {
  int local[4], m[3][4], i = 2;
  int* q = local;
  int** pp = &q;
  signed char sb[2];
  char out[4];
  char* o = out;
  long la[3];
  long* lp = la;
  void* vp;
  CHECK(sum(arr, 5) == 15);
  CHECK(*pick(arr, 3) == 4);
  *q = 7; q[1] = 8; *(q + 2) = 9; 3[q] = 10;
  CHECK(local[0] + local[1] + local[2] + local[3] == 34);
  CHECK(&local[3] - &local[0] == 3); CHECK(&local[1] > &local[0]);
  q[i] = next_value(); CHECK(local[2] == 10);
  *pick(local, 1) = next_value(); CHECK(local[1] == 20);
  copy(buf, "hello"); CHECK(length(buf) == 5); CHECK(buf[4] == 'o'); CHECK(buf[5] == 0);
  CHECK(length("") == 0); CHECK("abc"[1] == 'b'); CHECK(sizeof("abc") == 4);
  m[2][3] = 5; m[i][0] = 6; CHECK(*(*(m + 2) + 3) == 5); CHECK(m[2][0] == 6);
  CHECK(sizeof(m) == 24); CHECK(sizeof(m[0]) == 8); CHECK(&m[1][0] - &m[0][0] == 4);
  **pp = 42; CHECK(local[0] == 42);
  sb[0] = -1; sb[1] = -128; CHECK(sb[0] == -1); CHECK(sb[1] < -100);
  *o++ = 'a'; *o++ = 'b'; CHECK(o - out == 2 && out[1] == 'b' && out[0] == 'a');
  lp++; CHECK((char*)lp - (char*)la == 4); lp += 1; CHECK(lp - la == 2);
  vp = local; q = vp; CHECK(q == local); q = 0; CHECK(!q); CHECK(q == 0);
  CHECK(arr + 5 - arr == 5);
  i = 0; while (i < 5) arr[i++] *= 2; CHECK(arr[4] == 10 && arr[0] == 2);
  return 0;
}
