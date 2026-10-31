// SDCC runtime helpers, its libraries aren't linked in the rgbds pipeline.
// (string.h maps memcpy to __memcpy, so fatfs.c's memcpy covers that one)
// Shift and add versions, they must not use * or / on longs themselves.

long _mullong(long a, long b) {
  unsigned long x = a, y = b, result = 0;
  while (y) {
    if (y & 1) result += x;
    x <<= 1;
    y >>= 1;
  }
  return result;
}

unsigned long _divulong(unsigned long x, unsigned long y) {
  unsigned long quotient = 0, remainder = 0;
  unsigned char i;
  for (i = 32; i; --i) {
    remainder = (remainder << 1) | (x >> 31);
    x <<= 1;
    quotient <<= 1;
    if (remainder >= y) {
      remainder -= y;
      quotient |= 1;
    }
  }
  return quotient;
}
