// Small string and number formatters; no C runtime required.
#include "text.h"


char* PutText(char* dest, const char* text) {
  while (*text) *dest++ = *text++;
  return dest;
}

// PutNumber is in src/strings.asm

// pads n to 2 digits
char* PutNumber2(char* dest, unsigned int n) {
  if (n < 10) *dest++ = '0';
  return PutNumber(dest, n);
}

void CopyName(char* dest, const char* src) {
  while ((*dest++ = *src++));
}
