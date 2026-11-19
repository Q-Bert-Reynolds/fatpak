// MAPVIEW: a Beisbol .gbmap (RGBDS source from gbmapeditor), read only. It assembles the parts it
// draws from: the host opens the map and passes its path; the module reads the map first (ModRead
// needs the host's file, and ModLoad closes it), then map_stamps.gbstamp from the map's folder or
// one above it. Labels, DEF ... EQU, DB, DW and RGB are assembled into PSRAM, with map_loader.inc's
// MAP_OBJ_ and MAP_COLLISION_ constants built in; IF, WARN and the rest are ignored, a DW of a label
// further on (a stamp's) is patched at the end, and symbols defined nowhere (other maps, scripts,
// BANK()) are 0. The map's first _...Tiles label, _BusinessesTiles say, names
// img/maps/businesses.tiles for tiles 128-255, and img/ui_font.tiles has 0-127, as Beisbol loads them.
//
// Each chunk (32x32 tiles) is drawn once into PSRAM the way map_loader.asm's DrawMapChunk draws it
// to the screen: the chunk's tile, then its background objects in order. Sprites aren't drawn.
// The view fills the screen, no bars, from chunk 0's top left; the d-pad scrolls a tile at a time
// into the neighbouring chunks as the game does. GBC: the map's background palettes, through
// ModColorTiles; DMG/SGB: the tiles' greys.
#include "../build/modules/sdk.h"
#include "lib/psram.h"

// PSRAM blocks: nothing else uses $0200-$03FF (the large-file add buffer starts at $0400)
#define IMG 0x0200 // the assembled bytes, 16 KiB
#define IMG_SIZE 0x4000u
#define SYM 0x0220 // 256 hash heads, then 8-byte symbols from block 1
#define SYM_MAX (31 * 64)
#define FIX 0x0240 // a DW of a symbol not yet defined: where, which symbol (4 bytes each)
#define FIX_MAX (4 * 128)
#define TXT 0x0244 // an included file, whole
#define TXT_BLOCKS 60
#define TIL 0x0280 // tiles 0-255, 16 bytes each
#define CHK 0x0288 // chunks as drawn: 4 blocks each, a row of 32 tiles then its 32 palettes
#define SLOTS 90 // chunk numbers below this keep theirs; the 4 after are drawn again each time

// map_loader.inc, the format the game reads, and its names for the parts the map files use: an object
// type is its index in objects, a collision 16 times its index in collisions
static const char objects[] = "NONE\0NONE_FILL\0TILE\0TILE_FILL\0STAMP\0STAMP_FILL\0AVATAR\0META_SPRITE\0";
static const char collisions[] = "NONE\0SOLID\0WATER\0DOOR\0TEXT\0LEDGE\0GRASS\0SCRIPT\0TEAM\0ITEM\0";
#define OBJ_TILE 2
#define OBJ_TILE_FILL 3
#define OBJ_STAMP 4
#define OBJ_STAMP_FILL 5
#define COLLISION_DOOR 0x30 // these four have a byte of extra data
#define COLLISION_TEXT 0x40
#define COLLISION_LEDGE 0x50
#define COLLISION_SCRIPT 0x70
#define H_PALETTES 1 // header words
#define H_CHUNKS 7
#define NORTH 3 // a chunk's neighbours
#define EAST 4
#define SOUTH 5
#define WEST 6

#define LINE_MAX 160 // the maps' longest is under 80
#define CHUNK 32

// a row of tiles then their palettes for ModColorTiles, once the files are read; before, a line of
// source or a path to look for, and the reader's buffer
static unsigned char area[TB_COLS * 16 + TB_COLS];
#define out area
#define line ((char*)area)
#define buf (area + LINE_MAX + 1)
typedef char area_fits[LINE_MAX + 1 + MODULE_SOURCE_CHUNK <= sizeof(area) && PATH_SIZE + 1 + 72 <= sizeof(area) - 72 ? 1 : -1];
static char* p; // the parser's place in line
static const char* map_path; // the host's, from the root
static unsigned char dir_len; // the map's folder: map_path's first dir_len characters
static char tiles_label[32]; // the map's first undefined _...Tiles symbol
#define TILES_PATH ((char*)area + sizeof(area) - 72) // its file: past what Find writes in line, a
// folder (at most PATH_SIZE) and a name; "img/maps/", at most 50 of snake_case, ".tiles"
static unsigned char from_map, buf_n, buf_i, cur_len;
static unsigned long map_pos; // the map is read as it's assembled, an included file from TXT
static unsigned short txt_pos, txt_size;
static const char* cur_name;
static unsigned short cur_h, cur_h2, pc, symbols, fixups, fwd, map_base, lines, at;
static unsigned char row_tiles[TB_COLS], row_pals[TB_COLS];
static unsigned char cached[SLOTS];
static unsigned short chunks; // the chunk table
static unsigned char slot, fill_tile, fill_pal; // Fill's
static unsigned char chunk, x, y; // the view's top left: in chunk, tile x, y

// --- PSRAM ---------------------------------------------------------------------------------------

static unsigned char Byte(unsigned short a) {
  Window(IMG + (a >> 9));
  return WINDOW[a & 511];
}

static unsigned char Get(void) { return Byte(at++); } // at's byte
static unsigned short GetWord(void) { unsigned char lo = Get(); return lo | (unsigned short)Get() << 8; }

static void Emit(unsigned char b) {
  if (pc < IMG_SIZE) {
    Window(IMG + (pc >> 9));
    WINDOW[pc & 511] = b;
  }
  ++pc;
}

static char* Put(char* dest, const char* text) { // text and its NUL; returns where the NUL went
  while ((*dest = *text++)) ++dest;
  return dest;
}

static void Clear(unsigned short block, unsigned char blocks) {
  unsigned char* w;
  while (blocks--) {
    Window(block); // a macro: block once
    ++block;
    for (w = WINDOW; w != WINDOW + 512; ++w) *w = 0;
  }
}

// --- Symbols -------------------------------------------------------------------------------------

static unsigned char* Entry(unsigned short i) { // next, h2, value, length, defined
  Window(SYM + 1 + (i >> 6));
  return WINDOW + ((i & 63) << 3);
}

static unsigned short* Head(void) {
  Window(SYM);
  return (unsigned short*)WINDOW + (unsigned char)(cur_h ^ cur_h >> 8);
}

// cur's symbol, made (undefined) if it's new; 0 if the table is full
static unsigned short Symbol(void) {
  unsigned short i = *Head(), head = i;
  unsigned char* e;
  while (i) {
    e = Entry(i);
    if (*(unsigned short*)(e + 2) == cur_h2 && e[6] == cur_len) return i;
    i = *(unsigned short*)e;
  }
  if (symbols == SYM_MAX - 1) return 0;
  e = Entry(i = ++symbols);
  *(unsigned short*)e = head;
  *(unsigned short*)(e + 2) = cur_h2;
  e[6] = cur_len;
  e[7] = 0;
  *Head() = i;
  return i;
}

static void Define(unsigned short value) {
  unsigned short i = Symbol();
  unsigned char* e;
  if (!i) return;
  e = Entry(i);
  *(unsigned short*)(e + 4) = value;
  e[7] = 1;
}

static unsigned short Value(unsigned short i) { // 0 if it's undefined
  unsigned char* e = Entry(i);
  return e[7] ? *(unsigned short*)(e + 4) : 0;
}

// --- Reading -------------------------------------------------------------------------------------

static char Next(void) { // the next character, 0 at the end
  unsigned char* w;
  if (buf_i == buf_n) {
    buf_i = buf_n = 0;
    if (from_map) {
      if (!(buf_n = ModRead(map_pos, (char*)buf, MODULE_SOURCE_CHUNK))) return 0;
      map_pos += buf_n;
    }
    else {
      Window(TXT + (txt_pos >> 9));
      w = WINDOW + (txt_pos & 511);
      while (txt_pos != txt_size && buf_n != MODULE_SOURCE_CHUNK) { buf[buf_n++] = *w++; ++txt_pos; }
      if (!buf_n) return 0;
    }
  }
  return buf[buf_i++];
}

// a line into line without its comment; 0 at the end of the file
static unsigned char GetLine(void) {
  unsigned char n = 0, quote = 0, comment = 0;
  char c;
  while ((c = Next()) && c != '\n') {
    if (c == '"') quote ^= 1;
    else if (c == ';' && !quote) comment = 1;
    if (!comment && c != '\r' && n < LINE_MAX) line[n++] = c;
  }
  line[n] = 0;
  return c || n;
}

// --- Expressions ---------------------------------------------------------------------------------

static unsigned char IsIdent(char c) {
  return (c >= 'A' && c <= 'Z') || (c >= 'a' && c <= 'z') || (c >= '0' && c <= '9') || c == '_' || c == '#' || c == '@';
}

static void Spaces(void) { while (*p == ' ' || *p == '\t') ++p; }

static unsigned char Comma(void) { // skips one
  Spaces();
  if (*p != ',') return 0;
  ++p;
  return 1;
}

// the identifier at p into cur; its length
static unsigned char Ident(void) {
  char c;
  cur_name = p;
  cur_h = cur_h2 = 0;
  while (IsIdent(c = *p)) {
    cur_h = (cur_h << 4 | cur_h >> 12) ^ c;
    cur_h2 = (cur_h2 << 3 | cur_h2 >> 13) + c;
    ++p;
  }
  return cur_len = (unsigned char)(p - cur_name);
}

static unsigned char Is(const char* keyword) { // cur is keyword (upper case)
  unsigned char i;
  for (i = 0; i < cur_len; ++i) if ((cur_name[i] & 0xDF) != keyword[i]) return 0;
  return !keyword[i];
}

static unsigned short Expr(void);

// the map's tileset: the first _...Tiles it uses
static void TilesLabel(void) {
  const char *n = cur_name, *t = "Tiles";
  unsigned char i;
  if (!from_map || tiles_label[0] || cur_len < 7 || cur_len >= sizeof(tiles_label) || *n != '_') return;
  for (i = cur_len - 5; *t; ++i) if (n[i] != *t++) return;
  for (i = 0; i < cur_len; ++i) tiles_label[i] = n[i];
  tiles_label[i] = 0;
}

static unsigned short Term(void) {
  unsigned short v = 0, i;
  unsigned char base = 0, d;
  char c;
  Spaces();
  c = *p++;
  if (c == '(') {
    v = Expr();
    Spaces();
    if (*p == ')') ++p;
  }
  else if (c == '-') v = -Term();
  else if (c == '~') v = ~Term();
  else if (c == '!') v = !Term();
  else if (c == '$') base = 4;
  else if (c == '%') base = 1;
  else if (c >= '0' && c <= '9') { --p; base = 10; }
  else if (IsIdent(c)) {
    --p;
    Ident();
    Spaces();
    if (*p == '(') { // BANK(x), DEF(x): 0
      ++p;
      Spaces();
      Ident();
      TilesLabel();
      while (*p && *p++ != ')');
      return 0;
    }
    TilesLabel();
    if ((i = Symbol())) {
      if (Entry(i)[7]) return Value(i);
      if (!fwd) fwd = i;
    }
  }
  else if (!c) --p;
  while (base) { // the digits of a number
    c = *p | 0x20;
    if (c >= '0' && c <= '9') d = c - '0';
    else if (c >= 'a' && c <= 'f') d = c - 'a' + 10;
    else break;
    if (base == 10) {
      if (d > 9) break;
      v = (v << 3) + (v << 1) + d;
    }
    else {
      if (d >> base) break;
      v = v << base | d;
    }
    ++p;
  }
  return v;
}

static unsigned short Expr(void) {
  unsigned short v = Term(), t;
  char op;
  while (1) {
    Spaces();
    op = *p;
    if (op == '<' || op == '>') {
      if (p[1] != op) break;
      ++p;
    }
    else if (op != '|' && op != '&' && op != '^' && op != '+' && op != '-') break;
    ++p;
    t = Term();
    if (op == '|') v |= t;
    else if (op == '&') v &= t;
    else if (op == '^') v ^= t;
    else if (op == '+') v += t;
    else if (op == '-') v -= t;
    else if (op == '<') v <<= t;
    else v >>= t;
  }
  return v;
}

// --- Lines ---------------------------------------------------------------------------------------

static void Data(unsigned char kind) { // 1 DB, 2 DW, 3 RGB
  unsigned short v;
  char c;
  do {
    Spaces();
    if (*p == '"') { // DB's text
      while ((c = *++p) && c != '"') {
        if (c == '\\' && p[1] && *++p == 'n') c = '\n';
        else if (c == '\\') c = *p;
        Emit(c);
      }
      if (c) ++p;
      continue;
    }
    fwd = 0;
    v = Expr();
    if (kind == 3) {
      Comma();
      v |= Expr() << 5;
      Comma();
      v |= Expr() << 10;
    }
    else if (kind == 2 && fwd && fixups < FIX_MAX) {
      Window(FIX + (fixups >> 7));
      ((unsigned short*)WINDOW)[(fixups & 127) << 1] = pc;
      ((unsigned short*)WINDOW)[((fixups & 127) << 1) + 1] = fwd;
      ++fixups;
    }
    Emit((unsigned char)v);
    if (kind != 1) Emit((unsigned char)(v >> 8));
  } while (Comma());
}

static void Line(void) {
  const char* n;
  unsigned char len;
  unsigned short h, h2, v;
  p = line;
  if (*p == '.') { // a local label: nothing refers to them
    ++p;
    Ident();
    while (*p == ':') ++p;
  }
  else if (IsIdent(*p)) {
    Ident();
    if (*p == ':') {
      Define(pc);
      while (*p == ':') ++p;
    }
    else p = line; // a directive in the first column
  }
  Spaces();
  if (!Ident()) return;
  if (Is("DB")) Data(1);
  else if (Is("DW")) Data(2);
  else if (Is("RGB")) Data(3);
  else if (Is("DEF")) { // DEF name EQU value, or =
    Spaces();
    Ident();
    n = cur_name;
    len = cur_len;
    h = cur_h;
    h2 = cur_h2;
    Spaces();
    if (*p == '=') ++p;
    else {
      Ident();
      if (!Is("EQU")) return;
    }
    v = Expr();
    cur_name = n;
    cur_len = len;
    cur_h = h;
    cur_h2 = h2;
    Define(v);
  }
}

// prefix and each name in names (NUL after each, an empty one at the end), step apart from 0
static void Constants(const char* prefix, const char* names, unsigned char step) {
  unsigned short v = 0;
  while (*names) {
    Put(Put(line, prefix), names);
    while (*names++);
    p = line;
    Ident();
    Define(v);
    v += step;
  }
}

static void Assemble(void) {
  buf_i = buf_n = 0;
  txt_pos = 0;
  while (GetLine()) {
    Line();
    if (!(++lines & 63)) ModProgress("Reading map...");
  }
}

// file, from the map's folder or one above it, into PSRAM from block, at most blocks; 0 if it's there
static unsigned char Find(const char* file, unsigned short block, unsigned char blocks) {
  ModuleLoad load;
  unsigned char n = dir_len, i, result;
  while (1) {
    for (i = 0; i < n; ++i) line[i] = map_path[i];
    if (n) line[i++] = '/';
    Put(line + i, file);
    load.block = block;
    load.blocks = blocks;
    if ((result = ModLoad(line, &load)) != 1) {
      txt_size = (unsigned short)load.size;
      return result;
    }
    if (!n) return 1;
    while (n && map_path[--n] != '/'); // up a folder
  }
}

// --- Drawing -------------------------------------------------------------------------------------

// tiles [x1, x2) x [y1, y2) of slot's chunk, clipped to it, to fill_tile and fill_pal
static void Fill(unsigned char x1, unsigned char y1, unsigned char x2, unsigned char y2) {
  unsigned char *row, i;
  if (x2 > CHUNK) x2 = CHUNK;
  if (y2 > CHUNK) y2 = CHUNK;
  for (; y1 < y2; ++y1) {
    Window(CHK + ((unsigned short)slot << 2) + (y1 >> 3));
    row = WINDOW + ((y1 & 7) << 6) + x1;
    for (i = x1; i < x2; ++i, ++row) {
      *row = fill_tile;
      row[CHUNK] = fill_pal;
    }
  }
}

// the stamp at image address s with its top left at sx, sy
static void Stamp(unsigned char sx, unsigned char sy, unsigned short s) {
  unsigned char w, h, r, c, uniform;
  unsigned short pals, k;
  if (!s) return;
  w = Byte(s);
  h = Byte(s + 1);
  pals = s + 2;
  for (r = 0; r < h; ++r) pals += w;
  uniform = Byte(pals) & 0x80;
  fill_pal = Byte(pals);
  for (r = 0, k = 0; r < h; ++r, ++sy)
    for (c = 0; c < w; ++c, ++k) {
      fill_tile = Byte(s + 2 + k);
      if (!uniform) fill_pal = Byte(pals + k);
      if ((unsigned char)(sx + c) < CHUNK && sy < CHUNK) Fill(sx + c, sy, sx + c + 1, sy + 1);
    }
}

static unsigned short ChunkAt(unsigned char index) {
  at = chunks + ((unsigned short)index << 1);
  return chunks ? GetWord() : 0;
}

static void DrawChunk(unsigned char index) {
  unsigned short s;
  unsigned char t, x1, y1, x2, y2, w, h, cx;
  fill_tile = fill_pal = 0;
  if ((at = ChunkAt(index))) {
    fill_tile = Get();
    fill_pal = Get();
    at += 5;
  }
  Fill(0, 0, CHUNK, CHUNK);
  if (!at) return;
  while ((t = Get())) {
    x1 = Get();
    y1 = Get();
    switch (t & 15) {
      case OBJ_TILE:
      case OBJ_TILE_FILL:
        fill_tile = Get();
        fill_pal = Get();
        x2 = x1 + 1;
        y2 = y1 + 1;
        if ((t & 15) == OBJ_TILE_FILL) {
          x2 = Get();
          y2 = Get();
        }
        Fill(x1, y1, x2, y2);
        break;
      case OBJ_STAMP:
        s = GetWord();
        Stamp(x1, y1, s);
        break;
      case OBJ_STAMP_FILL:
        s = GetWord();
        x2 = Get();
        y2 = Get();
        if (!s || !(w = Byte(s)) || !(h = Byte(s + 1))) break;
        for (; y1 < y2 && y1 < CHUNK; y1 += h)
          for (cx = x1; cx < x2 && cx < CHUNK; cx += w) Stamp(cx, y1, s);
        break;
      case 0: // MAP_OBJ_NONE: a collision only
        break;
      default: // MAP_OBJ_NONE_FILL, and what the loader skips the same way
        at += 2;
    }
    t &= 0xF0;
    if (t == COLLISION_DOOR || t == COLLISION_TEXT || t == COLLISION_LEDGE || t == COLLISION_SCRIPT) ++at;
  }
}

static unsigned char Neighbour(unsigned char index, unsigned char side) {
  unsigned short a = ChunkAt(index);
  return a ? Byte(a + side) : index;
}

// sets slot to the one with chunk index drawn; scratch (0-3) for one past the cache
static unsigned char Slot(unsigned char index, unsigned char scratch) {
  slot = index;
  if (index >= SLOTS) slot = SLOTS + scratch;
  else if (cached[index]) return slot;
  else cached[index] = 1;
  DrawChunk(index);
  return slot;
}

// n tiles of row ty of slot s's chunk from tx, into row_tiles and row_pals at col
static void Copy(unsigned char s, unsigned char ty, unsigned char tx, unsigned char col, unsigned char n) {
  unsigned char* row;
  Window(CHK + ((unsigned short)s << 2) + (ty >> 3));
  row = WINDOW + ((ty & 7) << 6) + tx;
  while (n--) {
    row_tiles[col] = *row;
    row_pals[col++] = row[CHUNK];
    ++row;
  }
}

static void Draw(void) {
  unsigned char r, ty, here, i, t, *src, *dst, slots[4];
  unsigned char first = CHUNK - x < TB_COLS ? CHUNK - x : TB_COLS;
  here = chunk;
  slots[0] = Slot(here, 0);
  slots[1] = Slot(Neighbour(here, EAST), 1);
  here = Neighbour(here, SOUTH);
  slots[2] = Slot(here, 2);
  slots[3] = Slot(Neighbour(here, EAST), 3);
  for (r = 0; r < TB_ROWS; ++r) {
    ty = y + r;
    here = 0;
    if (ty >= CHUNK) { ty -= CHUNK; here = 2; }
    Copy(slots[here], ty, x, 0, first);
    if (first < TB_COLS) Copy(slots[here + 1], ty, 0, first, TB_COLS - first);
    dst = out;
    for (i = 0; i < TB_COLS; ++i) {
      t = row_tiles[i];
      Window(TIL + (t >> 5));
      src = WINDOW + ((t & 31) << 4);
      for (t = 0; t < 16; ++t) *dst++ = *src++;
      out[TB_COLS * 16 + i] = row_pals[i];
    }
    ModColorTiles(r, out);
  }
}

// the BG palettes, 64 bytes
#ifdef HOST_TEST
void LoadPalettes(const unsigned char* colors); // tests' harness
#else
static void LoadPalettes(const unsigned char* colors) __naked {
  colors;
  __asm
	ld	h, d
	ld	l, e
	ld	a, $80
	ldh	[$FF68], a
	ld	c, 64
.colour:
	di
.wait:
	ldh	a, [$FF41]
	and	a, 2
	jr	nz, .wait
	ld	a, [hl+]
	ldh	[$FF69], a
	ei
	dec	c
	jr	nz, .colour
	ret
  __endasm;
}
#endif

static unsigned char Fail(const char* text) {
  ModBox(text);
  ModKey();
  return 1;
}

unsigned char ModuleMain(const char* path) {
  unsigned char i, k, key;
  unsigned short a, a2, end_pc, *w;
  map_path = path + (*path == '/');
  for (i = dir_len = 0; map_path[i]; ++i) if (map_path[i] == '/') dir_len = i;
  ModBox("Reading map...");
  Clear(SYM, 1);
  Clear(TIL, 8);
  symbols = fixups = lines = 0;
  pc = 1; // 0 is an address nothing has
  tiles_label[0] = from_map = 0;
  for (i = 0; i < SLOTS; ++i) cached[i] = 0;
  Constants("MAP_OBJ_", objects, 1);
  Constants("MAP_COLLISION_", collisions, 16);
  from_map = 1;
  map_pos = 0;
  map_base = pc;
  Assemble();
  from_map = 0;
  if (!Find("map_stamps.gbstamp", TXT, TXT_BLOCKS)) Assemble();
  for (a = 0, end_pc = pc; a < fixups; ++a) { // the DWs of labels below them
    Window(FIX + (a >> 7));
    w = (unsigned short*)WINDOW + ((a & 127) << 1);
    pc = w[0];
    a2 = Value(w[1]);
    Emit((unsigned char)a2);
    Emit((unsigned char)(a2 >> 8));
  }
  pc = end_pc;
  if (pc >= IMG_SIZE || pc == map_base) return Fail("Not a map");
  at = map_base + H_CHUNKS;
  chunks = GetWord();
  Find("img/ui_font.tiles", TIL, 4);
  if (tiles_label[0]) { // _ForestTiles: img/maps/forest.tiles, _WorldSpritesTiles: world_sprites
    char *src = tiles_label + 1, *dst = Put(TILES_PATH, "img/maps/");
    for (; src[5]; ++src) {
      key = *src;
      if (key >= 'A' && key <= 'Z') {
        if (src != tiles_label + 1) *dst++ = '_';
        key |= 0x20;
      }
      *dst++ = key;
    }
    Put(dst, ".tiles");
    Find(TILES_PATH, TIL + 4, 4);
  }
  at = map_base + H_PALETTES;
  at = GetWord(); // 8 palettes of 3 colours, the fourth black as the game loads them
  for (i = 0, k = 0; i < 8; ++i) { // in out, which Draw uses after
    for (key = 0; key < 6; ++key) out[k++] = Get();
    out[k++] = 0;
    out[k++] = 0;
  }
  chunk = x = y = 0;
  ModHideBox();
  LoadPalettes(out);
  Draw();
  while ((key = ModKey()) != KEY_BACKSPACE && key != KEY_ESCAPE) {
    i = chunk;
    if (key == KEY_LEFT) {
      if (!x--) { chunk = Neighbour(i, WEST); x = CHUNK - 1; }
    }
    else if (key == KEY_RIGHT) {
      if (++x == CHUNK) { chunk = Neighbour(i, EAST); x = 0; }
    }
    else if (key == KEY_UP) {
      if (!y--) { chunk = Neighbour(i, NORTH); y = CHUNK - 1; }
    }
    else if (key == KEY_DOWN) {
      if (++y == CHUNK) { chunk = Neighbour(i, SOUTH); y = 0; }
    }
    else continue;
    Draw();
  }
  ModColorTiles(0, 0); // the theme's palettes back
  return 0;
}
