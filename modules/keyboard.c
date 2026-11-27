#include "../build/modules/sdk.h"
#include "../src/ui/icons.h"
#include "lib/text.h"

#define TEST_CODES 11 // display rows
#define RAW_BYTES (TEST_CODES * 4)
#define TEST_FIRST 5 // the first one's screen row
#define TEST_ERRORS 0x27 // PS2_ERROR_* bits with a name: the strings from S_KB_FINISH

// Raw serial capture: PS/2 bytes include bits and errors; iGKB shows 44
// uninterpreted bytes in groups of four, without assuming packet boundaries.
// A freezes the display while capture continues, B or Start returns.
unsigned char KeyboardDriverMenu(void* menu);
unsigned char ModuleMain(void* context) {
  ModuleKeyboard state;
  unsigned char codes[RAW_BYTES], errors[RAW_BYTES], read, count = 0, boot;
  unsigned char row, i, j, bit, bytes, errors_seen, limit, width;
  unsigned int event;
  unsigned char paused = 0, pressed, redraw = 0;
  char text[TB_STRIDE], *end;
  if (context) return KeyboardDriverMenu((void*)((unsigned int)context - 1));
  ModHideBox();
  ModKeyboard(&state);
  read = state.write; boot = state.type; bytes = state.bytes; errors_seen = state.errors;
  if (boot == 4) boot = 1; // the SGB's driver: its bytes are the PS/2 keyboard's (the mouse's aren't kept)
  width = boot >= 2 ? 4 : 1;
  limit = boot >= 2 ? RAW_BYTES : TEST_CODES;
  ModListen();
  ModRow(0, Str(S_KB_TITLE));
  ModRow(1, Str(S_DRIVER_NONE + (boot == 3 ? 2 : boot < 3 ? boot : 0)));
  ModRow(4, Str(S_KB_CODES));
  ModRow(TB_ROWS - 1, Str(S_KB_BACK));
  while (1) {
    ModKeyboard(&state);
    if (!paused) {
      end = ModString(text, S_PART(S_KB_BYTES, 0));
      end = ModString(PutNumber(end, (unsigned char)(state.bytes - bytes)), S_PART(S_KB_BYTES, 1));
      ModString(PutNumber(end, (unsigned char)(state.errors - errors_seen)), S_PART(S_KB_BYTES, 2));
      ModRow(2, text);
    }
    if (read != state.write || redraw) {
      redraw = 0;
      while (read != state.write) {
        for (i = 1; i < limit; ++i) codes[i - 1] = codes[i], errors[i - 1] = errors[i];
        event = ModScan(read);
        codes[limit - 1] = (unsigned char)event;
        errors[limit - 1] = event >> 8;
        read = (read + 1) & 63;
        if (count < limit) ++count;
      }
      if (!paused) for (i = 0; i < count; i += width) {
        row = limit - count + i;
        end = PutHex(text, (unsigned char)(read - count + i) & 63);
        *end++ = ':'; *end++ = ' ';
        if (width == 4) {
          for (j = 0; j < 4 && i + j < count; ++j) {
            end = PutHex(end, codes[row + j]);
            *end++ = ' ';
          }
        } else {
          end = PutHex(end, codes[row]);
          *end++ = ' ';
          for (bit = 0x80; bit; bit >>= 1) *end++ = codes[row] & bit ? '1' : '0';
          for (bit = 0; bit < 6; ++bit) if (errors[row] & (1 << bit) & TEST_ERRORS) *end++ = ' ', end = ModString(end, S_KB_FINISH + bit);
        }
        *end = 0;
        ModRow(TEST_FIRST + (width == 4 ? row >> 2 : row), text);
      }
    }
    while ((event = ModEvent())) {
      if (paused) continue;
      end = ModString(text, S_PART(S_KB_KEY, 0));
      end = PutHex(end, (unsigned char)event);
      if ((unsigned char)event >= ' ' && (unsigned char)event < KEY_LEFT) *end++ = ' ', *end++ = (unsigned char)event;
      end = ModString(end, S_PART(S_KB_KEY, 1));
      ModString(PutHex(end, event >> 8), S_PART(S_KB_KEY, 2));
      ModRow(3, text);
    }
    pressed = ModFrame();
    if (pressed & (PADF_B | PADF_START)) break;
    if (pressed & PADF_A) {
      paused = !paused;
      redraw = 1;
      ModRow(4, Str(paused ? S_KB_PAUSED : S_KB_CODES));
    }
  }
  return 0;
}
