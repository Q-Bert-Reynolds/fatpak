// A project's C unit (tests/ccproj): calls util.c's function and start.asm's, reads its own
// initialized data (copied by _cc_init) and a static whose name util.c uses too.
extern int twice(int x); // start.asm
int util_sum(int n);     // util.c
static int hidden = 5;
int seed = 1234;
int main(void) {
  if (seed != 1234) return 1;
  if (twice(21) != 42) return 2;
  if (util_sum(4) != 10) return 3;
  if (hidden != 5) return 4;
  return 0;
}
