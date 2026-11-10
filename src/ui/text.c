// Small string and number formatters; no C runtime required.
#include "text.h"

static const unsigned long powers_of_ten[] = {1000000, 100000, 10000, 1000, 100, 10};

char* PutText(char* dest, const char* text) {
  while (*text) *dest++ = *text++;
  return dest;
}

char* PutNumber(char* dest, unsigned long n) {
  unsigned char i, digit, started = 0;
  for (i = 0; i < 6; ++i) {
    digit = '0';
    while (n >= powers_of_ten[i]) {
      n -= powers_of_ten[i];
      ++digit;
    }
    if (started || digit != '0') {
      *dest++ = digit;
      started = 1;
    }
  }
  *dest++ = '0' + (unsigned char)n;
  return dest;
}

// pads n to 2 digits
char* PutNumber2(char* dest, unsigned int n) {
  if (n < 10) *dest++ = '0';
  return PutNumber(dest, n);
}

void CopyName(char* dest, const char* src) {
  while ((*dest++ = *src++));
}
