// A project's C unit (tests/ccproj): calls util.c's function and start.asm's, reads its own
// initialized data (copied by _cc_init) and a static whose name util.c uses too.
extern int twice(int x); // start.asm
int util_sum(int n);     // util.c
int util_mod(int a, int b);
int inc_value(void);     // inc.c, through start.asm's INCLUDE "_inc.asm"
static int hidden = 5;
int seed = 1234;
int main(void) {
  if (seed != 1234) return 1;
  if (twice(21) != 42) return 2;
  if (util_sum(4) != 10) return 3;
  if (hidden != 5) return 4;
  if (util_mod(17, 5) != 2 || util_mod(-17, 5) != -2) return 7;
  if (inc_value() != 7) return 5; // the stale _inc.asm until BUILD compiles inc.c
#if CCPROJ != 3 || !defined(LANG_EN) // project.gbp's rgbasm -D defines are the C units' too
  return 6;
#endif
  return 0;
}
