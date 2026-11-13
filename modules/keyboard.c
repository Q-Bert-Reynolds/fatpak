#include "../build/modules/sdk.h"
#include "../src/ui/icons.h"
#include "lib/text.h"

#define TEST_CODES 11 // scan code rows
#define TEST_FIRST 5 // the first one's screen row
#define TEST_ERRORS 0x27 // PS2_ERROR_* bits with a name: the strings from S_KB_FINISH

// SETTINGS > KEYBOARD TEST: the PS/2 interrupt's bytes (hex, bits, errors, counted from here, up to 255) and
// the keys they make, listening
// even if no keyboard was found at boot (it keeps listening afterwards)
unsigned char ModuleMain(void) {
  ModuleKeyboard state;
  unsigned char codes[TEST_CODES], errors[TEST_CODES], read, count = 0, boot;
  unsigned char row, i, bit, bytes, errors_seen;
  unsigned int event;
  char text[TB_STRIDE], *end;
  ModHideBox();
  ModKeyboard(&state);
  read = state.write; boot = state.type; bytes = state.bytes; errors_seen = state.errors;
  ModListen();
  ModRow(0, Str(S_KB_TITLE));
  ModRow(1, Str(boot == 1 ? S_KB_PS2 : boot ? S_KB_IGKB : S_KB_NONE));
  ModRow(4, Str(S_KB_CODES));
  ModRow(TB_ROWS - 1, Str(S_KB_BACK));
  while (1) {
    ModKeyboard(&state);
    end = ModString(text, S_PART(S_KB_BYTES, 0));
    end = ModString(PutNumber(end, (unsigned char)(state.bytes - bytes)), S_PART(S_KB_BYTES, 1));
    ModString(PutNumber(end, (unsigned char)(state.errors - errors_seen)), S_PART(S_KB_BYTES, 2));
    ModRow(2, text);
    if (read != state.write) {
      while (read != state.write) {
        for (i = 1; i < TEST_CODES; ++i) codes[i - 1] = codes[i], errors[i - 1] = errors[i];
        event = ModScan(read);
        codes[TEST_CODES - 1] = (unsigned char)event;
        errors[TEST_CODES - 1] = event >> 8;
        read = (read + 1) & 63;
        if (count < TEST_CODES) ++count;
      }
      for (i = 0; i < count; ++i) {
        row = TEST_CODES - count + i;
        end = PutHex(text, codes[row]);
        *end++ = ' ';
        for (bit = 0x80; bit; bit >>= 1) *end++ = codes[row] & bit ? '1' : '0';
        for (bit = 0; bit < 6; ++bit) if (errors[row] & (1 << bit) & TEST_ERRORS) *end++ = ' ', end = ModString(end, S_KB_FINISH + bit);
        *end = 0;
        ModRow(TEST_FIRST + TEST_CODES - count + i, text);
      }
    }
    while ((event = ModEvent())) {
      end = ModString(text, S_PART(S_KB_KEY, 0));
      end = PutHex(end, (unsigned char)event);
      if ((unsigned char)event >= ' ' && (unsigned char)event < KEY_LEFT) *end++ = ' ', *end++ = (unsigned char)event;
      end = ModString(end, S_PART(S_KB_KEY, 1));
      ModString(PutHex(end, event >> 8), S_PART(S_KB_KEY, 2));
      ModRow(3, text);
    }
    if (ModFrame() & (PADF_B | PADF_START)) break;
  }
  return 0;
}
