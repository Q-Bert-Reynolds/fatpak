#include "../../build/modules/sdk.h"
#include "text.h"

static const unsigned long tens[] = {1000000000UL, 100000000UL, 10000000UL, 1000000UL,
  100000UL, 10000UL, 1000UL, 100UL, 10UL, 1UL};

char* PutText(char* dest, const char* text) {
  while (*text) *dest++ = *text++;
  return dest;
}

char* PutNumber(char* dest, unsigned long n) {
  unsigned char i, digit, started = 0;
  for (i = 0; i < 10; ++i) {
    for (digit = '0'; n >= tens[i]; ++digit) n -= tens[i];
    if (digit != '0' || started || i == 9) { *dest++ = digit; started = 1; }
  }
  return dest;
}

static char str_buffer[LANG_MAX + 1];
const char* Str(unsigned int id) {
  ModString(str_buffer, id);
  return str_buffer;
}
