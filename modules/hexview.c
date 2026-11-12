// HEXVIEW: a binary file, read only, 8 bytes a row in hex then as characters (a dim period
// for bytes that don't print). The host (src/browser/hexview.c) opens the file, draws the
// header, sets the 4 px fixed font and styled rows, and passes the file's size. The footer
// shows the selected byte's address, binary and decimal.
#include "../build/modules/sdk.h"
#include "lib/text.h"

#define ROWS (TB_ROWS - 2)
#define PAGE (ROWS * 8)
#define LEFT 2 // first hex column: 35 columns of 4 px, about centered
#define CHARS (LEFT + 27) // first character column, after 8 hex bytes and 4 spaces
#define PLAIN (STYLE_TEXT << 4 | 4) // tile_attrs: style and width
#define DIM (STYLE_MARK << 4 | 4)

static unsigned long size, top, cursor; // byte offsets, top a multiple of 8
static unsigned char bytes[PAGE];
static char text[TB_STRIDE + 1], styles[TB_STRIDE];

// draws text row row from n (at most 8) bytes at data
static void Line(unsigned char row, const unsigned char* data, unsigned char n) {
  unsigned char i, c, col = LEFT;
  for (i = 0; i < TB_STRIDE; ++i) { text[i] = ' '; styles[i] = PLAIN; }
  text[TB_STRIDE] = 0;
  for (i = 0; i < n; ++i) {
    c = data[i];
    PutHex(text + col, c);
    col += 3;
    if (c < ' ' || c > '~') { c = '.'; styles[CHARS + i] = DIM; }
    text[CHARS + i] = c;
  }
  ModText(row, 0, text);
  ModStyle(row, styles);
}

static void Row(unsigned char row) {
  Line(row, bytes, ModRead(top + ((unsigned int)row << 3), (char*)bytes, 8));
}

static void Page(void) {
  unsigned char n = ModRead(top, (char*)bytes, PAGE), row, count;
  for (row = 0; row < ROWS; ++row) {
    count = n > 8 ? 8 : n;
    Line(row, bytes + ((unsigned int)row << 3), count);
    n -= count;
  }
}

// highlights the byte's hex digits and shows it in the footer, e.g. $0001A4  %11011001  217
// (over 16 MiB $01A4F0C2 %11011001 217: the footer's text stops where the clock starts)
static void Show(void) {
  const unsigned char* at = (const unsigned char*)&cursor;
  unsigned char value = 0, bit, col = LEFT, i = at[0] & 7;
  char* end = text;
  while (i--) col += 3;
  ModSelect((unsigned char)((cursor - top) >> 3), col, col + 2);
  ModRead(cursor, (char*)&value, 1);
  *end++ = '$';
  if (size > 0x1000000UL) end = PutHex(end, at[3]); // and single spaces, the clock needs the rest
  end = PutHex(end, at[2]);
  end = PutHex(end, at[1]);
  end = PutHex(end, at[0]);
  *end++ = ' ';
  if (size <= 0x1000000UL) *end++ = ' ';
  *end++ = '%';
  for (bit = 0x80; bit; bit >>= 1) *end++ = value & bit ? '1' : '0';
  *end++ = ' ';
  if (size <= 0x1000000UL) *end++ = ' ';
  *PutNumber(end, value) = 0;
  ModText(STATUS_LINE, 1, text);
}

unsigned char ModuleMain(const unsigned long* file_size) {
  unsigned long next, last, first;
  unsigned char key, down;
  size = *file_size;
  last = size - 1; // the host only opens files with a NUL in them
  top = cursor = 0;
  Page();
  ModHideBox(); // the host's loading box
  Show();
  while (1) {
    key = ModKey(); // every frame, 0 for none: redraw only after a move
    if (key == KEY_BACKSPACE || key == KEY_ESCAPE) break;
    next = cursor;
    if (key == KEY_LEFT) { if (next) --next; }
    else if (key == KEY_RIGHT) { if (next < last) ++next; }
    else if (key == KEY_UP) { if (next >= 8) next -= 8; }
    else if (key == KEY_DOWN) { if ((next | 7) < last) next = next + 8 < last ? next + 8 : last; }
    else if (key == KEY_PAGE_UP) next = next >= PAGE ? next - PAGE : next & 7;
    else if (key == KEY_PAGE_DOWN) next = next + PAGE < last ? next + PAGE : last;
    else if (key == KEY_HOME) next = 0;
    else if (key == KEY_END) next = last;
    if (next == cursor) continue;
    cursor = next;
    first = top;
    if (next < top) first = next & ~7UL;
    else if (next >= top + PAGE) first = (next & ~7UL) - (PAGE - 8);
    if (first != top) {
      down = first > top;
      if (first == top + 8 || first + 8 == top) { // a row at a time, so the screen ring keeps its drawn rows
        top = first;
        ModScroll(down);
        Row(down ? ROWS - 1 : 0);
      }
      else {
        top = first;
        Page();
      }
    }
    Show();
  }
  return 0;
}
