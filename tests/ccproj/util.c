// tests/ccproj's second C unit: its own static named like math.c's
static int hidden = 7;
int util_sum(int n) { int s = 0; while (n) s += n--; return s + hidden - 7; }
