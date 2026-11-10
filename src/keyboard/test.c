// Live PS/2 scan-code and decoded-event viewer.
#include "test.h"
#include "../editor/view.h"
#include "../input.h"
#include "keyboard.h"
#include "../ui/render.h"
#include "../ui/screen.h"
#include "../ui/text.h"
#include "../ui/icons.h"
#include "../ui/footer.h"

#define TEST_CODES 11 // scan code rows
#define TEST_FIRST 5 // the first one's screen row
static const char test_errors[][9] = {"finish", "parity", "start", "", "", "timeout"}; // PS2_ERROR_* bits

static char* PutHex(char* dest, unsigned char n) {
  unsigned char digit = n >> 4;
  *dest++ = digit < 10 ? '0' + digit : 'A' - 10 + digit;
  digit = n & 15;
  *dest++ = digit < 10 ? '0' + digit : 'A' - 10 + digit;
  return dest;
}

// HELP > KEYBOARD TEST: the PS/2 interrupt's bytes (hex, bits, errors, counted from here, up to 255) and
// the keys they make, listening
// even if no keyboard was found at boot (it keeps listening afterwards)
void KeyboardTest(void) {
  unsigned char codes[TEST_CODES], errors[TEST_CODES], read = kb_buffer_write, count = 0, boot = kb_type;
  unsigned char row, i, bit, editor_font = font, bytes = kb_interrupt_count, errors_seen = kb_error_count;
  unsigned int event;
  char text[TB_STRIDE], *end;
  font = FONT_VWF;
  SetFont(font);
  render_text = 0;
  BeginFullScreen();
  ClearScreen();
  KBListen();
  DrawRow(0, 0, "KEYBOARD TEST");
  DrawRow(1, 0, boot == 1 ? "Found at boot: PS/2" : boot ? "Found at boot: iGKB" : "Found at boot: none, listening anyway");
  DrawRow(4, 0, "Scan codes (newest last):");
  FooterDraw(TB_ROWS - 1, 0, ICON_B"/" ICON_START" Back");
  while (1) {
    end = PutText(text, "Bytes ");
    end = PutNumber(end, (unsigned char)(kb_interrupt_count - bytes));
    end = PutText(end, "   with errors ");
    end = PutNumber(end, (unsigned char)(kb_error_count - errors_seen));
    *end = 0;
    DrawRow(2, 0, text);
    if (read != kb_buffer_write) {
      while (read != kb_buffer_write) {
        for (i = 1; i < TEST_CODES; ++i) codes[i - 1] = codes[i], errors[i - 1] = errors[i];
        codes[TEST_CODES - 1] = kb_scan_code_buffer[read];
        errors[TEST_CODES - 1] = kb_error_buffer[read];
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
        DrawRow(TEST_FIRST + TEST_CODES - count + i, 0, text);
      }
    }
    while ((event = KBPopEvent())) {
      end = PutText(text, "Key ");
      end = PutHex(end, (unsigned char)event);
      if ((unsigned char)event >= ' ' && (unsigned char)event < KEY_LEFT) *end++ = ' ', *end++ = (unsigned char)event;
      end = PutText(end, "   modifiers ");
      end = PutHex(end, event >> 8);
      *end = 0;
      DrawRow(3, 0, text);
    }
    EditorDraw();
    WaitFrame();
    if (PadPressed() & (PADF_B | PADF_START)) break;
  }
  font = editor_font;
  SetFont(font);
  render_text = 1;
  EndFullScreen();
}
