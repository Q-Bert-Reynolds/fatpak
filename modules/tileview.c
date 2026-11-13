// TILEVIEW: a .tiles file (16 bytes of Game Boy 2bpp a tile, as img2rgbds.py writes them), read
// only. The selected tile is drawn 8x, each pixel a whole tile, framed, with 2x and 1x copies beside
// it; below, a sheet of the tiles at their size, 16 a row, the selected one inverted. Every text row
// is raw tiles (ModTiles). The host (src/browser/viewer.c) opens the file, draws the header and
// passes the file's size; the footer shows the tile's number and offset.
#include "../build/modules/sdk.h"
#include "lib/text.h"

#define ZOOM 2 // first column of the 8x tile, text rows 1-8 (rows 0 and 9 frame it)
#define BIG_COL 13 // 2x tile, beside zoom rows BIG_Y and BIG_Y + 1
#define BIG_Y 3
#define SMALL_COL 16 // 1x tile, beside the 2x tile's lower half
#define SHEET_COL 2
#define SHEET_ROW 10
#define SHEET_ROWS (TB_ROWS - 2 - SHEET_ROW)
#define PAGE (SHEET_ROWS * 16) // tiles the sheet shows

static unsigned char out[TB_COLS * 16]; // a row of tiles for ModTiles
static unsigned char tile[16]; // the selected tile
static unsigned int count, current, first; // tiles, the selected one, the sheet's first (a multiple of 16)
static char text[TB_STRIDE + 1];
static const unsigned char doubled[16] = { // 4 pixels of a plane, each twice
  0x00, 0x03, 0x0C, 0x0F, 0x30, 0x33, 0x3C, 0x3F, 0xC0, 0xC3, 0xCC, 0xCF, 0xF0, 0xF3, 0xFC, 0xFF};

static void Clear(void) {
  unsigned int i;
  for (i = 0; i < sizeof(out); ++i) out[i] = 0;
}

// n (at most 128) bytes from tile t into dest, zeros past the end of the file
static void Fetch(unsigned int t, unsigned char* dest, unsigned char n) {
  unsigned char got = t < count ? ModRead((unsigned long)t << 4, (char*)dest, n) : 0;
  while (got < n) dest[got++] = 0;
}

static unsigned char* Cell(unsigned char col) { return out + ((unsigned int)col << 4); }

// ORs bits into lines first to first + lines - 1 of both planes of the cell at col (color 3)
static void Edge(unsigned char col, unsigned char bits, unsigned char first_line, unsigned char lines) {
  unsigned char* p = Cell(col) + (first_line << 1);
  while (lines--) { *p++ |= bits; *p++ |= bits; }
}

// row of the frame around the 8x tile: line 7 above it, line 0 below
static void Frame(unsigned char row, unsigned char line) {
  unsigned char col;
  Clear();
  for (col = ZOOM; col < ZOOM + 8; ++col) Edge(col, 0xFF, line, 1);
  Edge(ZOOM - 1, 0x01, line, 1);
  Edge(ZOOM + 8, 0x80, line, 1);
  ModTiles(row, out);
}

// half (0 top, 1 bottom) of the 2x tile
static void Big(unsigned char half) {
  unsigned char col, line, y, lo, hi, *p;
  for (col = 0; col < 2; ++col) {
    p = Cell(BIG_COL + col);
    for (line = 0; line < 8; ++line) {
      y = ((half << 2) + (line >> 1)) << 1;
      lo = tile[y];
      hi = tile[y + 1];
      if (!col) { lo >>= 4; hi >>= 4; }
      *p++ = doubled[lo & 15];
      *p++ = doubled[hi & 15];
    }
  }
}

// line y of the selected tile, 8x, with the frame's sides and the copies beside it
static void ZoomRow(unsigned char y) {
  unsigned char x, bit = 0x80, lo, hi, line, *p;
  Clear();
  for (x = 0; x < 8; ++x, bit >>= 1) {
    lo = tile[y << 1] & bit ? 0xFF : 0;
    hi = tile[(y << 1) + 1] & bit ? 0xFF : 0;
    p = Cell(ZOOM + x);
    for (line = 0; line < 8; ++line) { *p++ = lo; *p++ = hi; }
  }
  Edge(ZOOM - 1, 0x01, 0, 8);
  Edge(ZOOM + 8, 0x80, 0, 8);
  if (y == BIG_Y || y == BIG_Y + 1) Big(y - BIG_Y);
  if (y == BIG_Y + 1) for (x = 0, p = Cell(SMALL_COL); x < 16; ++x) p[x] = tile[x];
  ModTiles(y + 1, out);
}

// row r of the sheet
static void SheetRow(unsigned char r) {
  unsigned int t = first + ((unsigned int)r << 4);
  unsigned char i, *p = Cell(SHEET_COL);
  Clear();
  Fetch(t, p, 128);
  Fetch(t + 8, p + 128, 128);
  if (current >= t && current < t + 16) {
    p = Cell(SHEET_COL + (unsigned char)(current - t));
    for (i = 0; i < 16; ++i) p[i] = ~p[i];
  }
  ModTiles(SHEET_ROW + r, out);
}

// the selected tile 8x and in the footer: "Tile 26/256  $01A0", over 4096 tiles (64 KiB)
// "26/65535  $0001A0" (the footer's text stops where the clock starts)
static void Show(void) {
  unsigned long offset = (unsigned long)current << 4;
  const unsigned char* at = (const unsigned char*)&offset;
  char* end = text;
  unsigned char y;
  Fetch(current, tile, 16);
  for (y = 0; y < 8; ++y) ZoomRow(y);
  if (count <= 4096) end = ModString(end, S_TILE_N);
  end = PutNumber(end, current);
  *end++ = '/';
  end = PutNumber(end, count);
  end = PutText(end, "  $");
  if (count > 4096) end = PutHex(end, at[2]);
  end = PutHex(end, at[1]);
  end = PutHex(end, at[0]);
  *end = 0;
  ModText(STATUS_LINE, 1, text);
}

unsigned char ModuleMain(const unsigned long* file_size) {
  unsigned long tiles = (*file_size + 15) >> 4; // the host only opens files with something in them
  unsigned int next, old, top;
  unsigned char key, r;
  count = tiles > 0xFFFF ? 0xFFFF : (unsigned int)tiles;
  current = first = 0;
  ModHideBox(); // the host's loading box; hiding it redraws text rows, so before the tiles
  Frame(0, 7);
  Frame(9, 0);
  Show();
  for (r = 0; r < SHEET_ROWS; ++r) SheetRow(r);
  while (1) {
    key = ModKey();
    if (key == KEY_BACKSPACE || key == KEY_ESCAPE) break;
    next = current;
    if (key == KEY_LEFT) { if (next) --next; }
    else if (key == KEY_RIGHT) { if (next + 1 < count) ++next; }
    else if (key == KEY_UP) { if (next >= 16) next -= 16; }
    else if (key == KEY_DOWN) { if (next + 16 < count) next += 16; }
    else if (key == KEY_PAGE_UP) next = next >= PAGE ? next - PAGE : next & 15;
    else if (key == KEY_PAGE_DOWN) next = next + PAGE < count ? next + PAGE : count - 1;
    else if (key == KEY_HOME) next = 0;
    else if (key == KEY_END) next = count - 1;
    if (next == current) continue;
    old = current;
    current = next;
    top = first;
    if (next < first) first = next & ~15u;
    else if (next >= first + PAGE) first = (next & ~15u) - (PAGE - 16);
    if (first != top) for (r = 0; r < SHEET_ROWS; ++r) SheetRow(r);
    else {
      SheetRow((unsigned char)((old - first) >> 4));
      if ((old - first) >> 4 != (next - first) >> 4) SheetRow((unsigned char)((next - first) >> 4));
    }
    Show();
  }
  return 0;
}
