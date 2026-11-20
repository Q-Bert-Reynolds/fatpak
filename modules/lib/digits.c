// PutNumber2 and PutHex (text.h), apart from text.c so a module that needs neither doesn't carry them
#include "../../build/modules/sdk.h"
#include "text.h"

char* PutNumber2(char* dest, unsigned char n) {
  unsigned char digit = '0';
  while (n >= 10) { n -= 10; ++digit; }
  *dest++ = digit;
  *dest++ = '0' + n;
  return dest;
}

char* PutHex(char* dest, unsigned char n) {
  unsigned char digit = n >> 4;
  *dest++ = digit < 10 ? '0' + digit : 'A' - 10 + digit;
  digit = n & 15;
  *dest++ = digit < 10 ? '0' + digit : 'A' - 10 + digit;
  return dest;
}
