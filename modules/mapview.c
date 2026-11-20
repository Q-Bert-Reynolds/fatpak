// MAPVIEW: a Beisbol .gbmap (RGBDS source from gbmapeditor), read only, scrolled the way the game
// scrolls it. The browser runs it with the map's folder as module_dir (src/browser/viewer.c's ViewMap,
// MapContext in mapview.h), so every name here is found as the map's own INCLUDEs would be: in its
// folder or one above it.
//
// The map is viewed from a cache, /GBCSYS/CACHE/<its path>.cache: ASM.MOD and LINK.MOD's image of a
// wrapper this module writes (Wrapper): a key at $0000 (the map's directory entry, so an edited map
// is built again, and its tileset's path), the project's rgbasm -D and -P (project.gbp, as ASM.MOD
// would build it), then the map and map_stamps.gbstamp at $4000 of bank 1. Names the map uses that
// those don't define (scripts, text, other maps) are 0 (ASM_LOOSE). The first view and one after
// the map changed return MAP_BUILD; the host builds it and runs this again, which reports an error
// or views it.
//
// Each chunk (32x32 tiles) is drawn once into PSRAM the way map_loader.asm's DrawMapChunk draws it
// to the screen: the chunk's tile, then its background objects in order. Sprites aren't drawn. The
// screen is the BG map itself (ModBackground): the view moves a pixel a frame (four with B held)
// with SCX and SCY, and draws only the column or row of tiles coming into view, as the game does,
// crossing into the chunk's neighbours. Tiles 0-127 are img/ui_font.tiles and 128-255 the map's
// tileset; the bars over it unless full screen; GBC: in the map's BG palettes, DMG/SGB: greys.
//
// Controls (notes/MODULES.md): the d-pad scrolls, B held runs, Start opens the menu (Rebuild, Full
// screen, Close; Start or B closes it). The bars: the map's name in the header, where the view is at
// the footer's left. Select is kept for the map tools.
#include "../build/modules/sdk.h"
#include "lib/psram.h"
#include "lib/text.h"
#include "mapview.h"
#ifndef HOST_TEST
#include "../src/fatfs/lib/ff.h" // FIL and FATFS, read through ModStat's pointers
#endif

// PSRAM blocks: nothing else uses $0200-$03FF while the browser runs this (the large-file add
// buffer starts at $0400, where ASM.MOD works)
#define WRAP 0x0200   // the wrapper, 4 blocks (ASM.MOD reads it from here)
#define WRAP_MAX 2048
#define IMG 0x0200    // then the cache: ROM0 (the key) and bank 1 (the map), 64 blocks
#define IMG_BLOCKS 64
#define TIL 0x0240    // tiles 0-255, 16 bytes each, 8 blocks
#define SECTOR 0x0240 // the map's directory sector, before the tiles are read
#define CHK 0x0248    // chunks as drawn: 4 blocks each, a row of 32 tiles then its 32 palettes
#define SLOTS 100     // chunk numbers below this keep theirs; the 4 after are drawn again each time

// the cache's key, at image address 0: magic, version, the map's directory entry (time, date and
// size), then the tileset's path from KEY_TILES, NUL ended
#define KEY_VERSION 1
#define KEY_ENTRY 5
#define KEY_SIZE 13
#define KEY_TILES 16

// map_loader.inc's format
#define OBJ_TILE 2
#define OBJ_TILE_FILL 3
#define OBJ_STAMP 4
#define OBJ_STAMP_FILL 5
#define COLLISION_DOOR 0x30 // these four have a byte of extra data
#define COLLISION_TEXT 0x40
#define COLLISION_LEDGE 0x50
#define COLLISION_SCRIPT 0x70
#define MAP 0x4000 // where the wrapper puts the map
#define H_PALETTES 1 // header words
#define H_CHUNKS 7
#define NORTH 3 // a chunk's neighbours
#define EAST 4
#define SOUTH 5
#define WEST 6
#define CHUNK 32

#define WALK 1 // pixels a frame
#define RUN 4  // with B held
#define COLS (TB_COLS + 1) // BG map columns and rows kept drawn: the screen's and the one it's part way into
#define ROWS (TB_ROWS + 1)

#define MENU_BUILD 0 // Menu's items
#define MENU_FULL 1
#define MENU_CLOSE 2
#define MENU_ITEMS 3
#define MENU_BACK 3 // Start or B (or Full screen): back to the map

static MapContext* m;
static char text[MAP_CACHE_SIZE]; // the cache's path, a box's text, a word of project.gbp
static char tiles[48]; // the tileset's path: "img/maps/", the label's snake case, ".tiles"
static unsigned char key[KEY_SIZE];
static unsigned short at, chunks; // the reader's place; the chunk table
static unsigned char count; // the chunks in it
static unsigned char cached[SLOTS], slots[4]; // drawn chunks; the view's: here, east, south, south east
static unsigned char slot, fill_tile, fill_pal; // Fill's
static unsigned char chunk, tx, ty, gbc; // the view: its chunk, its top left tile in it
static unsigned char full, moved; // no bars (ModBackground's mode 2); the footer is behind the view
static unsigned char cam_x, cam_y; // its top left pixel in the chunk
static unsigned short wrap_n; // the wrapper's length

#ifdef HOST_TEST
extern unsigned char host_vbk, host_bgp; // the tests' registers
#define VBK host_vbk
#define BGP host_bgp
#else
#define VBK (*(volatile unsigned char*)0xFF4F)
#define BGP (*(volatile unsigned char*)0xFF47)
#endif
#define BG_MAP ((unsigned char*)0x9800)

// --- PSRAM ---------------------------------------------------------------------------------------

static unsigned char Byte(unsigned short a) {
  Window(IMG + (a >> 9));
  return WINDOW[a & 511];
}
static unsigned char Get(void) { return Byte(at++); } // at's byte
static unsigned short GetWord(void) { unsigned char lo = Get(); return lo | (unsigned short)Get() << 8; }

// a name's file, from the map's folder or one above it: 0 there, 1 not, 2 bigger than blocks
static unsigned char Load(const char* name, unsigned short block, unsigned char blocks) {
  ModuleLoad load;
  load.block = block;
  load.blocks = blocks;
  return ModLoad(name, &load);
}

// --- The cache's key -----------------------------------------------------------------------------

// the map's tileset: the first _...Tiles name in its first 4 KiB (the header's), as
// img/maps/snake_case.tiles in tiles, else "". ModRead (into text): before anything closes the map
static unsigned char Same(const char* a, const char* b) { // a starts with b
  while (*b) if (*a++ != *b++) return 0;
  return 1;
}
static void TilesPath(void) {
  char name[40], *dst, c;
  unsigned char n = 0, got, i;
  unsigned short pos = 0;
  tiles[0] = 0;
  while (pos < 4096 && (got = ModRead(pos, text, MODULE_SOURCE_CHUNK))) {
    for (i = 0; i < got; ++i) {
      c = text[i];
      if (c == '_' || (unsigned char)((c | 0x20) - 'a') < 26 || (unsigned char)(c - '0') < 10) { // a name's
        if (n < sizeof(tiles) - 16 && (n || c == '_')) name[n++] = c;
        continue;
      }
      name[n] = 0;
      if (n > 6 && Same(name + n - 5, "Tiles")) {
        dst = PutText(tiles, "img/maps/"); // _WorldSpritesTiles: img/maps/world_sprites.tiles
        for (i = 1; i < n - 5; ++i) {
          c = name[i];
          if (c >= 'A' && c <= 'Z') {
            if (i > 1) *dst++ = '_';
            c |= 0x20;
          }
          *dst++ = c;
        }
        *PutText(dst, ".tiles") = 0;
        return;
      }
      n = 0;
    }
    pos += got;
  }
}

// the map's directory entry (time, date and size) into key, from the host's file (the map until a
// ModLoad closes it). HOST_TEST: none
static void Entry(void) {
#ifndef HOST_TEST
  FIL* f = (FIL*)(unsigned short)ModStat(MODULE_STAT_FILE);
  FATFS* fs = (FATFS*)(unsigned short)ModStat(MODULE_STAT_FS);
  unsigned char i, *e;
  if (ModSector(f->dir_sect, SECTOR)) return;
  Window(SECTOR);
  e = WINDOW + (unsigned short)(f->dir_ptr - fs->win) + 22;
  for (i = 0; i < 4; ++i) key[KEY_ENTRY + i] = e[i]; // time, date
  for (i = 0; i < 4; ++i) key[KEY_ENTRY + 4 + i] = e[6 + i]; // size
#endif
}

// the loaded cache's key and tileset's path into key and tiles
static void FromKey(void) {
  unsigned char i;
  Window(IMG);
  for (i = 0; i < KEY_SIZE; ++i) key[i] = WINDOW[i];
  for (i = 0; i < sizeof(tiles) - 1 && (tiles[i] = WINDOW[KEY_TILES + i]) != 0; ++i);
  tiles[i] = 0;
}

// /GBCSYS/CACHE/<the map's path>.cache into text
static void CachePath(void) {
  *PutText(PutText(PutText(PutText(PutText(text, "/GBCSYS/CACHE"), m->dir), "/"), m->name), ".cache") = 0;
}

// the cache into IMG, if it's there and its key is the map's (or the host just wrote it); its key
// and tileset's path into key and tiles
static unsigned char Cached(void) {
  unsigned char i;
  CachePath();
  if (Load(text + 1, IMG, IMG_BLOCKS)) return 0;
  Window(IMG);
  for (i = 0; i < KEY_ENTRY; ++i) if (WINDOW[i] != key[i]) return 0; // magic and version
  if (m->state != MAP_BUILT) for (; i < KEY_SIZE; ++i) if (WINDOW[i] != key[i]) return 0;
  FromKey();
  return 1;
}

// --- The wrapper ---------------------------------------------------------------------------------

static void Out(const char* s) {
  while (*s && wrap_n < WRAP_MAX) {
    Window(WRAP + (wrap_n >> 9));
    WINDOW[wrap_n & 511] = *s++;
    ++wrap_n;
  }
}

static void OutNumber(unsigned char n) {
  char digits[4];
  *PutNumber(digits, n) = 0;
  Out(digits);
}

// what a map takes from its game's headers, instead of the project's -P file (Beisbol's includes
// every header the game has, about 2,300 lines): map_loader.inc's object types, collisions and
// avatar directions and behaviours (value: the name's index << shift), and color.inc's RGB. Other
// names the map doesn't define (doors' targets, scripts, teams) are linked as 0 (ASM_LOOSE)
static const char* const prelude[4] = {
  "MAP_OBJ_\0NONE NONE_FILL TILE TILE_FILL STAMP STAMP_FILL AVATAR META_SPRITE",
  "MAP_COLLISION_\4NONE SOLID WATER DOOR TEXT LEDGE GRASS SCRIPT TEAM ITEM",
  "MAP_AVATAR_\6LEFT RIGHT UP DOWN",
  "MAP_AVATAR_\3STATIONARY WANDER",
};

static void Prelude(void) {
  const char *group, *p;
  char* t;
  unsigned char i, g, shift;
  Out("MACRO RGB\n DW \\3 << 10 | \\2 << 5 | \\1\nENDM\n");
  for (g = 0; g < 4; ++g) {
    group = prelude[g];
    for (p = group; *p >= 'A'; ++p); // the prefix, then its shift
    shift = *p++;
    for (i = 0; *p; ++i) {
      Out("DEF ");
      for (t = text; *group >= 'A'; ) *t++ = *group++; // the prefix
      for (; *p > ' '; ) *t++ = *p++; // the name
      *t = 0;
      group = prelude[g];
      Out(text);
      Out(" EQU ");
      OutNumber(i << shift);
      Out("\n");
      if (*p) ++p;
    }
  }
}

// the wrapper ASM.MOD builds, and the build's context: the key and the tileset's path, the
// prelude, then the map and the stamps file (if there is one) at MAP; and the cache's path for
// the host at MAP_PATH_BLOCK. MAP_BUILD
static unsigned char Wrapper(void) {
  unsigned char i;
  unsigned char* b = (unsigned char*)&m->build;
  for (i = 0; i < sizeof(AsmContext); ++i) b[i] = 0;
  wrap_n = 0;
  Out("SECTION \"FatPak map key\", ROM0[0]\n DB ");
  for (i = 0; i < KEY_SIZE; ++i) {
    OutNumber(key[i]);
    Out(", ");
  }
  Out("0, 0, 0\n DB \"");
  Out(tiles);
  Out("\", 0\n");
  Prelude();
  Out("SECTION \"FatPak map\", ROMX[$4000], BANK[1]\nINCLUDE \"");
  Out(m->name);
  Out("\"\n");
  if (Load("map_stamps.gbstamp", TIL, 0) == 2) Out("INCLUDE \"map_stamps.gbstamp\"\n");
  m->build.kind = ASM_DOC | ASM_TEXT | ASM_LOOSE;
  m->build.text_block = WRAP;
  m->build.text_length = wrap_n;
  CachePath();
  Window(MAP_PATH_BLOCK);
  for (i = 0; (WINDOW[i] = text[i]) != 0; ++i);
  return MAP_BUILD;
}

// a box's two lines: strings id and id + 1
static char* Lines(unsigned int id) {
  char* end = ModString(text, id);
  *end++ = '\n';
  return ModString(end, id + 1);
}

// what the host's build said, in a box until a key
static unsigned char Report(void) {
  char* end;
  if (m->state == MAP_LARGE) end = Lines(S_MAP_LARGE);
  else if (!m->result) { // status is only set when ASM.MOD and LINK.MOD ran // the file, line and error, as FILE > BUILD shows them
    end = m->build.file ? PutText(text, m->build.name + m->build.base) : ModString(text, S_MAP_WRAPPER);
    *end++ = '\n';
    end = ModString(PutNumber(ModString(end, S_PART(S_BUILD_LINE, 0)), m->build.line), S_PART(S_BUILD_LINE, 1));
    *end++ = '\n';
    end = ModString(end, S_ERR_SYNTAX + m->status - 1);
  }
  else {
    end = ModString(text, S_MAP_CANT_BUILD);
    *end++ = '\n';
    end = ModString(PutNumber(ModString(end, S_PART(S_MAP_ERROR_N, 0)), m->result), S_PART(S_MAP_ERROR_N, 1));
  }
  *end = 0;
  ModBox(text);
  while (!ModKey());
  return 0;
}

// --- Drawing chunks ------------------------------------------------------------------------------

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
  if (index >= count) return 0;
  at = chunks + ((unsigned short)index << 1);
  return GetWord();
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

// the slot with chunk index drawn in it; scratch (0-3) for one past the cache
static unsigned char Slot(unsigned char index, unsigned char scratch) {
  slot = index;
  if (index >= SLOTS) slot = SLOTS + scratch;
  else if (cached[index]) return slot;
  else cached[index] = 1;
  DrawChunk(index);
  return slot;
}

// the view's chunk and its neighbours to the east, south and south east
static void Slots(void) {
  unsigned char south = Neighbour(chunk, SOUTH);
  slots[0] = Slot(chunk, 0);
  slots[1] = Slot(Neighbour(chunk, EAST), 1);
  slots[2] = Slot(south, 2);
  slots[3] = Slot(Neighbour(south, EAST), 3);
}

// --- The screen ----------------------------------------------------------------------------------

#ifdef HOST_TEST
void VPut(unsigned char* to, unsigned char value); // the tests' harness
void VTile(unsigned char* to, const unsigned char* from);
void LoadPalettes(const unsigned char* colors);
#else
// a byte to VRAM outside mode 3
static void VPut(unsigned char* to, unsigned char value) __naked {
  to; value;
  __asm
	ld	b, a
	ld	h, d
	ld	l, e
	di
.vput:
	ldh	a, [$FF41] ;// STAT: mode 2 or 3 has bit 1
	and	a, 2
	jr	nz, .vput
	ld	[hl], b
	ei
	ret
  __endasm;
}

// a tile's 16 bytes to VRAM, each outside mode 3 (C's loop of VPut took most of a second for 256)
static void VTile(unsigned char* to, const unsigned char* from) __naked {
  to; from;
  __asm
	ld	h, b
	ld	l, c
	ld	c, 16
.vtile:
	di
.vtwait:
	ldh	a, [$FF41]
	and	a, 2
	jr	nz, .vtwait
	ld	a, [hl+]
	ld	[de], a
	ei
	inc	de
	dec	c
	jr	nz, .vtile
	ret
  __endasm;
}

// the 8 BG palettes, 64 bytes
static void LoadPalettes(const unsigned char* colors) __naked {
  colors;
  __asm
	ld	h, d
	ld	l, e
	ld	a, $80
	ldh	[$FF68], a ;// BCPS: palette 0, auto increment
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

// tile x, y of the view's chunk (0-63: past 31 are the neighbours') onto its BG map cell
static void Cell(unsigned char x, unsigned char y) {
  unsigned char s = slots[(y >= CHUNK) << 1 | (x >= CHUNK)], tile, pal, *row;
  unsigned char* to = BG_MAP + ((unsigned short)(y & 31) << 5) + (x & 31);
  y &= 31;
  Window(CHK + ((unsigned short)s << 2) + (y >> 3));
  row = WINDOW + ((y & 7) << 6) + (x & 31);
  tile = *row;
  pal = row[CHUNK] & 7;
  VPut(to, tile);
  if (gbc) {
    VBK = 1;
    VPut(to, tile < 128 ? pal | 8 : pal); // the font's tiles are in bank 1
    VBK = 0;
  }
}
static void Column(unsigned char x) { unsigned char y; for (y = ty; y != ty + ROWS; ++y) Cell(x, y); }
static void Row(unsigned char y) { unsigned char x; for (x = tx; x != tx + COLS; ++x) Cell(x, y); }

// the bars: the map's name in the header, and where the view is at the footer's left, as the editor
// has its line and column
static void Bars(void) {
  char* end;
  ModText(HEADER_LINE, 1, m->name);
  end = PutNumber(ModString(text, S_MAP_CHUNK), chunk);
  end = PutNumber(PutText(end, "  "), tx);
  end = PutNumber(PutText(end, ","), ty);
  *end = 0;
  ModText(STATUS_LINE, 1, text);
}

// the map over the screen: tiles 128-255 at $8800 (bank 0), 0-127 at $9000 (bank 1 on GBC), in
// the text's $8800 mode; the palettes; every cell in view. After the host has drawn its rows
static void Show(void) {
  unsigned short t;
  unsigned char i, y, colors[64];
  ModDraw(); // the host's rows, then a frame or two for a box's rows to go back to their map rows
  ModFrame();
  ModFrame();
  ModBackground(1 + full, (unsigned short)cam_y << 8 | (unsigned char)cam_x);
  Bars();
  for (t = 0; t < 256; ++t) {
    if (gbc) VBK = t < 128;
    Window(TIL + (t >> 5));
    VTile((unsigned char*)(t < 128 ? 0x9000 + (t << 4) : 0x8000 + (t << 4)), WINDOW + ((t & 31) << 4));
  }
  VBK = 0;
  if (gbc) { // 8 palettes of 3 colours, the fourth black as the game loads them
    at = MAP + H_PALETTES;
    at = GetWord();
    for (i = 0, y = 0; i < 8; ++i) {
      for (t = 0; t < 6; ++t) colors[y++] = Get();
      colors[y++] = 0;
      colors[y++] = 0;
    }
    LoadPalettes(colors);
  }
  else BGP = 0xE4;
  for (y = ty; y != ty + ROWS; ++y) Row(y);
}

// GBC: the host's box (ModMenu) over the map. While the module has the BG map, the host draws text row r
// into block r + 4 (a box of up to 6 lines: blocks 9-16, tiles the map's leave); its cells are pointed at
// them, palette 0 like the bars. ModStat(MODULE_STAT_BOX): its top row, rows, x and width in pixels
static void BoxCells(void) {
  const unsigned char* box = (const unsigned char*)(unsigned short)ModStat(MODULE_STAT_BOX);
  unsigned char r, c, b, id, *to;
  for (r = box[0]; r != box[0] + box[1]; ++r) {
    b = r + 4;
    if (b >= 12) b -= 12; // bank 1's blocks
    id = 128 + (b << 4) + (b << 2); // block b's first tile, $8800 mode (past 255: $9000 on)
    for (c = box[2] >> 3; c <= (unsigned char)(box[2] + box[3] - 1) >> 3; ++c) {
      to = BG_MAP + ((unsigned short)((ty + r) & 31) << 5) + ((tx + c) & 31);
      VPut(to, id + c);
      VBK = 1;
      VPut(to, r + 4 >= 12 ? 8 : 0);
      VBK = 0;
    }
  }
}

// Start's menu with the bars, over the map on GBC (BoxCells), the host's text on DMG/SGB (the map has every
// tile the background reaches): MENU_BUILD or MENU_CLOSE, or MENU_BACK when Start or B closes it or Full
// screen turns the bars off or on (the map again, where it was)
static unsigned char Menu(void) {
  char lines[MENU_ITEMS * BOX_STRIDE];
  unsigned char selected = MENU_BUILD, key, i;
  for (i = 0; i < MENU_ITEMS; ++i) *ModString(PutText(lines + i * BOX_STRIDE, " "), S_MAP_REBUILD + i) = 0;
  if (gbc) ModBackground(1, (unsigned short)cam_y << 8 | (unsigned char)cam_x); // the bars, full screen or not
  else ModBackground(0, 0);
  Bars();
  ModMenu(lines, MENU_ITEMS, selected);
  if (gbc) BoxCells();
  while (1) {
    ModMenu(lines, MENU_ITEMS, selected);
    while (!(key = ModKey()));
    if (key == KEY_UP) selected = selected ? selected - 1 : MENU_ITEMS - 1;
    else if (key == KEY_DOWN) selected = selected == MENU_ITEMS - 1 ? 0 : selected + 1;
    else if (key == KEY_ENTER) break;
    else if (key == KEY_ESCAPE || key == KEY_BACKSPACE || key == KEY_MENU) { selected = MENU_BACK; break; }
  }
  ModHideBox();
  if (selected == MENU_FULL) {
    full ^= 1;
    selected = MENU_BACK;
  }
  if (selected == MENU_BACK) {
    if (!gbc) Show();
    else for (i = 0; i != ROWS; ++i) Row(ty + i); // the box's cells: the map again
  }
  return selected;
}

// a step of the view (to the d-pad's held directions): step pixels, a column or row drawn as it
// comes into view (before the scroll that shows it)
static void Cross(unsigned char side) { // into the chunk's neighbour
  chunk = Neighbour(chunk, side);
  Slots();
}
static void Step(unsigned char held, unsigned char step) {
  unsigned char nt;
  if (held & PADF_RIGHT) {
    if ((unsigned char)(cam_x + step) < cam_x) { tx -= CHUNK; Cross(EAST); }
    cam_x += step;
    if ((nt = cam_x >> 3) != tx) { tx = nt; Column(tx + COLS - 1); }
  }
  else if (held & PADF_LEFT) {
    if (step > cam_x) { tx += CHUNK; Cross(WEST); }
    cam_x -= step;
    if ((nt = cam_x >> 3) != tx) { tx = nt; Column(tx); }
  }
  if (held & PADF_DOWN) {
    if ((unsigned char)(cam_y + step) < cam_y) { ty -= CHUNK; Cross(SOUTH); }
    cam_y += step;
    if ((nt = cam_y >> 3) != ty) { ty = nt; Row(ty + ROWS - 1); }
  }
  else if (held & PADF_UP) {
    if (step > cam_y) { ty += CHUNK; Cross(NORTH); }
    cam_y -= step;
    if ((nt = cam_y >> 3) != ty) { ty = nt; Row(ty); }
  }
}

// the view, from chunk 0's top left: a pixel a frame, RUN with B held, steps for each frame since
// the last pass (one can take two when a column or row is drawn); the footer says where once the
// d-pad is let go (a row of text each step would slow it). 1 to build the cache again, 0 to close
// (only the menu does either: B runs)
static unsigned char View(void) {
  unsigned char pressed, held, step, frames, now, last;
  chunk = tx = ty = 0;
  cam_x = cam_y = 0;
  Slots();
  Show();
  last = (unsigned char)ModStat(MODULE_STAT_FRAMES);
  while (1) {
    pressed = ModFrame();
    held = ModBackground(1 + full, (unsigned short)cam_y << 8 | (unsigned char)cam_x);
    now = (unsigned char)ModStat(MODULE_STAT_FRAMES);
    frames = now - last;
    last = now;
    if (frames > 4) frames = 4;
    if ((pressed & PADF_START) || (unsigned char)ModEvent() == KEY_ESCAPE) { // the keyboard's queue too, so it's not stale
      if ((step = Menu()) != MENU_BACK) return step == MENU_BUILD;
      last = (unsigned char)ModStat(MODULE_STAT_FRAMES);
      continue;
    }
    step = held & PADF_B ? RUN : WALK;
    if (held & PADF_DPAD) {
      while (frames--) Step(held, step);
      moved = 1;
    }
    else if (moved && !full) {
      Bars();
      moved = 0;
    }
  }
}

unsigned char ModuleMain(MapContext* context) {
  unsigned char i;
  m = context;
  if (m->state == MAP_LARGE || (m->state == MAP_BUILT && (m->result || m->status))) return Report();
  ModBox(Str(S_MAP_READING));
  key[0] = 'F'; key[1] = 'P'; key[2] = 'M'; key[3] = 'C'; key[4] = KEY_VERSION;
  for (i = KEY_ENTRY; i < KEY_SIZE; ++i) key[i] = 0;
  if (m->state == MAP_NEW) {
    Entry();
    TilesPath();
  }
  if (!Cached()) {
    if (m->state != MAP_NEW) { m->result = 0xFF; return Report(); } // built, but not readable
    return Wrapper();
  }
  for (i = 0; i < SLOTS; ++i) cached[i] = 0;
  at = MAP + H_CHUNKS;
  chunks = at = GetWord();
  count = 0; // the table's words, up to the first chunk's own bytes
  if (chunks) for (at = GetWord(); count < 255 && chunks + ((unsigned short)count << 1) < at; ++count);
  for (at = 0; at < 8 * 512; ++at) { // tiles: none until a file has them
    Window(TIL + (at >> 9));
    WINDOW[at & 511] = 0;
  }
  Load("img/ui_font.tiles", TIL, 4);
  if (tiles[0]) Load(tiles, TIL + 4, 4);
  VBK = 0;
  gbc = VBK != 0xFF; // DMG's reads $FF; GBC's the bank, the rest of it set
  ModHideBox();
  i = View();
  ModBackground(0, 0);
  if (i) { // Start's "build it again": the key and tileset from the cache
    m->state = MAP_NEW;
    FromKey();
    return Wrapper();
  }
  return 0;
}

#ifdef HOST_TEST
void HostRedraw(void) { Show(); } // the tests compare what scrolling drew with a fresh draw
#endif
