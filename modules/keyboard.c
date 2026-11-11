#include "../build/modules/sdk.h"
#include "../src/ui/icons.h"
#include "lib/text.h"

#define TEST_CODES 11 // scan code rows
#define TEST_FIRST 5 // the first one's screen row
static const char test_errors[][9] = {"finish", "parity", "start", "", "", "timeout"}; // PS2_ERROR_* bits

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
  ModRow(0, "KEYBOARD TEST");
  ModRow(1, boot == 1 ? "Found at boot: PS/2" : boot ? "Found at boot: iGKB" : "Found at boot: none, listening anyway");
  ModRow(4, "Scan codes (newest last):");
  ModRow(TB_ROWS - 1, ICON_B"/" ICON_START" Back");
  while (1) {
    ModKeyboard(&state);
    end = PutText(text, "Bytes ");
    end = PutNumber(end, (unsigned char)(state.bytes - bytes));
    end = PutText(end, "   with errors ");
    end = PutNumber(end, (unsigned char)(state.errors - errors_seen));
    *end = 0;
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
        for (bit = 0; bit < 6; ++bit) if (errors[row] & (1 << bit) && test_errors[bit][0]) *end++ = ' ', end = PutText(end, test_errors[bit]);
        *end = 0;
        ModRow(TEST_FIRST + TEST_CODES - count + i, text);
      }
    }
    while ((event = ModEvent())) {
      end = PutText(text, "Key ");
      end = PutHex(end, (unsigned char)event);
      if ((unsigned char)event >= ' ' && (unsigned char)event < KEY_LEFT) *end++ = ' ', *end++ = (unsigned char)event;
      end = PutText(end, "   modifiers ");
      end = PutHex(end, event >> 8);
      *end = 0;
      ModRow(3, text);
    }
    if (ModFrame() & (PADF_B | PADF_START)) break;
  }
  return 0;
}
