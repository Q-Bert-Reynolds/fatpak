// SETTINGS > THEME: the theme editor, a page of entries, each drawn in its look: the theme (< and >
// load the others), the header and footer, the 15 styles, the 8 palettes; under them every palette's
// colours. The theme in use is in the settings block (src/ui/theme.asm): this edits a copy and puts it
// back at every change, which ModTheme shows at once, so edits live in memory until FILE > SAVE or
// SAVE AS. Themes are /GBCSYS/THEMES/<name>.json, which the host lists at THEME_LIST_BLOCK and saves
// (src/ui/theme.c): this reads them (ModLoad from the card's root) and writes their text.
#include "../build/modules/sdk.h"
#include "lib/psram.h"

#define SETTINGS_BLOCK ((unsigned int)TB_PSRAM_HIGH << 8 | MAIN_SRAM_BANK)
#define ENTRIES 25
#define E_BARS 1 // the header and footer's look
#define E_STYLE 2 // STYLE_TEXT's, then the other styles'
#define E_PALETTE 17 // palette 0's, then the others'
#define LIST_ROWS 14 // then 2 rows: every palette's colours, a mark under the one the entry uses
#define FULLSCREEN 4 // sys_info: SGB fullscreen, no raw tiles there
#define NO_MARK 0xFF

static unsigned char th[THEME_SIZE];
static unsigned char entry, top, changed, dark, fullscreen, mark;
static unsigned char clip_kind, clip[8]; // EDIT > COPY: 1 a look, 2 a palette
static unsigned char buf[TB_COLS * 17]; // ModTiles' row and its palettes, a row's text and styles, a
// box's lines: never two at once (a box's are made again after anything is drawn)
#define line ((char*)buf)
#define styles (buf + MAX_ROW_STRIDE + 1)
#define lines ((char*)buf)
static unsigned char rgb[3]; // Unpack's
static unsigned int at, size, block; // the JSON text: where it's read or written, its size, the window's block

// the JSON's keys for the looks, in STYLE_* order, then THEME_BARS's
static const char* const keys[16] = {"text", "bold", "italic", "bold_italic", "markers", "code", "headings",
  "headings_5_6", "comments", "keywords", "types", "strings", "numbers", "directives", "labels", "header_footer"};

static char* PutText(char* d, const char* s) {
  while (*s) {
    *d++ = *s;
    ++s;
  }
  return d;
}
static char* Digits(char* d, unsigned char n, unsigned char two) { // n < 100, two digits if two
  unsigned char tens = 0;
  while (n >= 10) {
    n -= 10;
    ++tens;
  }
  if (tens || two) *d++ = (char)('0' + tens);
  *d++ = (char)('0' + n);
  return d;
}
// an RGB555 colour's red, green and blue into rgb, and back
static void Unpack(const unsigned char* w) {
  unsigned char lo = w[0], hi = w[1];
  rgb[0] = lo & 31;
  rgb[1] = (unsigned char)(lo >> 5 | (hi & 3) << 3);
  rgb[2] = (hi >> 2) & 31;
}
static void Pack(unsigned char* w) {
  w[0] = (unsigned char)(rgb[0] | rgb[1] << 5);
  w[1] = (unsigned char)(rgb[1] >> 3 | rgb[2] << 2);
}

// the copy back in the settings block
static void Store(void) {
  unsigned int i;
  th[THEME_ENTRY] = entry;
  Window(SETTINGS_BLOCK);
  for (i = 0; i < THEME_SIZE; ++i) WINDOW[THEME_OFFSET + i] = th[i];
}
// and on screen; redraw: the looks changed (every row is drawn again)
static void Commit(unsigned char redraw) {
  Store();
  dark = ModTheme(redraw);
  changed = 1;
}

static char* BoxLine(unsigned char n) { return lines + (n << 4) + (n << 2); } // n * BOX_STRIDE

static unsigned char EntryStyle(unsigned char e) {
  if (e == E_BARS) return THEME_BARS;
  if (e >= E_STYLE && e < E_PALETTE) return e - E_STYLE;
  return STYLE_TEXT;
}
static unsigned char Ink(unsigned char look) { return look & LOOK_DIM ? 2 : look & LOOK_ACCENT ? 1 : 3; }

static void Header(void) {
  char* d = ModString(line, S_PART(S_THEME_HEADER, 0));
  d = PutText(d, (const char*)th + THEME_NAME);
  if (th[THEME_EDITED]) *d++ = '*';
  ModString(d, S_PART(S_THEME_HEADER, 1));
  ModText(TB_ROWS, 1, line);
}
static void Hint(unsigned int id) {
  ModString(line, id);
  ModText(TB_ROWS + 1, 1, line);
}

// a list row: its entry's label, in the entry's look (widths 0: the host's, in that look)
static void DrawEntry(unsigned char row) {
  unsigned char e = top + row, i, n, style = STYLE_TEXT;
  char* d = line;
  for (i = 0; i < MAX_ROW_STRIDE; ++i) styles[i] = STYLE_TEXT << 4;
  *d++ = ' ';
  if (e < ENTRIES) {
    style = EntryStyle(e);
    if (!e) {
      d = ModString(d, S_THEME_E_THEME);
      d = PutText(PutText(PutText(d, ": < "), (const char*)th + THEME_NAME), " >");
    }
    else if (e >= E_PALETTE) {
      d = ModString(d, S_PART(S_THEME_E_PALETTE, 0));
      *d++ = (char)('0' + e - E_PALETTE);
      d = ModString(d, S_PART(S_THEME_E_PALETTE, 1));
    }
    else d = ModString(d, S_THEME_E_TEXT + style);
    n = (unsigned char)(d - line);
    for (i = 1; i < n; ++i) styles[i] = style << 4;
  }
  *d = 0;
  ModText(row, 0, line);
  ModStyle(row, (const char*)styles);
}

// the palette the entry uses (a palette's own), NO_MARK for the theme's row
static unsigned char EntryPalette(void) {
  if (!entry) return NO_MARK;
  if (entry >= E_PALETTE) return entry - E_PALETTE;
  return (th[THEME_LOOKS + EntryStyle(entry)] >> 4) & 7;
}

// every palette's colours, 2 tiles each from tile 2 (colours 0, 1, 2, 3, 0 in stripes), in the
// palettes themselves, so they change as the colours do; under them a mark at EntryPalette's
static void DrawSwatches(void) {
  unsigned int i;
  unsigned char r, t, k;
  unsigned char* d;
  mark = EntryPalette();
  if (fullscreen) return;
  for (r = 0; r < 2; ++r) {
    for (i = 0; i < sizeof(buf); ++i) buf[i] = 0;
    for (t = 0; t < 16; ++t) { // palette t >> 1's left or right tile
      d = buf + ((t + 2) << 4);
      if (!r) {
        for (k = 0; k < 16; k += 2) {
          d[k] = 0x3C;
          d[k + 1] = t & 1 ? 0xFC : 0x03; // 2 2 3 3 3 3 0 0, 0 0 1 1 1 1 2 2
        }
        buf[TB_COLS * 16 + 2 + t] = t >> 1;
      }
      else if ((t >> 1) == mark) for (k = 0; k < 4; ++k) d[k] = 0xFF; // palette 0's ink, 2 pixels high
    }
    ModTiles((LIST_ROWS + r) | THEME_TILES, buf);
  }
}

static void DrawList(void) {
  unsigned char row;
  for (row = 0; row < LIST_ROWS; ++row) DrawEntry(row);
  ModSelect(entry - top, 0, 1);
}
static void DrawAll(void) {
  Header();
  DrawList();
  DrawSwatches();
}

// a box item: " " and id's text with value's (a string, or the digit if value is 0) for its {}
static void Item(unsigned char n, unsigned int id, unsigned int value, unsigned char digit) {
  char* d = BoxLine(n);
  *d++ = ' ';
  d = ModString(d, S_PART(id, 0));
  if (value) d = ModString(d, value);
  else *d++ = (char)('0' + digit);
  ModString(d, S_PART(id, 1));
}

// the ids in list (up to 5) as a menu; returns the line
// chosen, NO_MARK for B or Start
static unsigned char Pick(const unsigned int* list, unsigned char count, unsigned char sel) {
  unsigned char key, i;
  for (i = 0; i < count; ++i) {
    char* d = BoxLine(i);
    *d++ = ' ';
    ModString(d, list[i]);
  }
  while (1) {
    ModMenu(lines, count, sel);
    do key = ModKey(); while (!key);
    if (key == KEY_UP) sel = sel ? sel - 1 : count - 1;
    else if (key == KEY_DOWN) sel = sel == count - 1 ? 0 : sel + 1;
    else if (key == KEY_ENTER) break;
    else if (key == KEY_BACKSPACE || key == KEY_MENU) {
      sel = NO_MARK;
      break;
    }
  }
  ModHideBox();
  return sel;
}

// a look's box: PALETTE, INK, BOLD (the header and footer's: those), ITALIC, FONT; left and right
// change the one selected (A too), each change shown at once
static void EditLook(unsigned char style) {
  unsigned char sel = 0, key, v, n, count = style == THEME_BARS ? 3 : 5;
  unsigned char* look = th + THEME_LOOKS + style;
  Hint(S_THEME_BOX_HINT);
  while (1) {
    v = *look;
    Item(0, S_THEME_P_PALETTE, 0, (v >> 4) & 7);
    Item(1, S_THEME_P_INK, 0, Ink(v));
    Item(2, S_THEME_P_BOLD, v & LOOK_BOLD ? S_ON : S_OFF, 0);
    Item(3, S_THEME_P_ITALIC, v & LOOK_ITALIC ? S_ON : S_OFF, 0);
    Item(4, S_THEME_P_FONT, v & LOOK_CODE ? S_THEME_V_CODE : S_THEME_V_TEXT, 0);
    ModMenu(lines, count, sel);
    do key = ModKey(); while (!key);
    if (key == KEY_UP) sel = sel ? sel - 1 : count - 1;
    else if (key == KEY_DOWN) sel = sel == count - 1 ? 0 : sel + 1;
    else if (key == KEY_BACKSPACE || key == KEY_MENU) break;
    else if (key == KEY_LEFT || key == KEY_RIGHT || key == KEY_ENTER) {
      if (!sel) {
        n = (v >> 4) & 7;
        n = key == KEY_LEFT ? n - 1 : n + 1;
        v = (unsigned char)((v & ~LOOK_PALETTE) | (n & 7) << 4);
      }
      else if (sel == 1) {
        n = Ink(v);
        if (key == KEY_LEFT) n = n == 1 ? 3 : n - 1;
        else n = n == 3 ? 1 : n + 1;
        v &= (unsigned char)~(LOOK_DIM | LOOK_ACCENT);
        if (n == 2) v |= LOOK_DIM;
        else if (n == 1) v |= LOOK_ACCENT;
      }
      else if (sel == 2) v ^= LOOK_BOLD;
      else if (sel == 3) v ^= LOOK_ITALIC;
      else v ^= LOOK_CODE;
      *look = v;
      th[THEME_EDITED] = 1;
      Commit(1);
      DrawAll();
    }
  }
  ModHideBox();
  Hint(S_THEME_HINT);
}

static unsigned char* Colour(unsigned char p, unsigned char c) { return th + THEME_PALETTES + (p << 3) + (c << 1); }

// a palette's box: its 4 colours' red, green and blue; up and down pick a colour, A the next of its
// channels (marked >), left and right change it, the palette shown at once
static void EditPalette(unsigned char p) {
  unsigned char sel = 0, ch = 0, key, c, k, was;
  unsigned char* w;
  char* d;
  Hint(S_THEME_COLOR_HINT);
  while (1) {
    for (c = 0; c < 4; ++c) {
      d = BoxLine(c);
      Unpack(Colour(p, c));
      *d++ = ' ';
      d = ModString(d, S_PART(S_THEME_P_COLOR, 0));
      *d++ = (char)('0' + c);
      for (k = 0; k < 3; ++k) {
        d = ModString(d, S_PART(S_THEME_P_COLOR, k + 1));
        if (c == sel && k == ch) d[-2] = '>'; // the space before the channel's letter
        d = Digits(d, rgb[k], 1);
      }
      ModString(d, S_PART(S_THEME_P_COLOR, 4));
    }
    ModMenu(lines, 4, sel);
    do key = ModKey(); while (!key);
    if (key == KEY_UP) sel = sel ? sel - 1 : 3;
    else if (key == KEY_DOWN) sel = sel == 3 ? 0 : sel + 1;
    else if (key == KEY_ENTER) ch = ch == 2 ? 0 : ch + 1;
    else if (key == KEY_BACKSPACE || key == KEY_MENU) break;
    else if (key == KEY_LEFT || key == KEY_RIGHT) {
      w = Colour(p, sel);
      Unpack(w);
      if (key == KEY_LEFT) { if (rgb[ch]) --rgb[ch]; }
      else if (rgb[ch] < 31) ++rgb[ch];
      Pack(w);
      was = th[THEME_EDITED];
      th[THEME_EDITED] = 1;
      k = dark;
      Commit(0); // the palettes only: the hardware's, so the swatches change too
      if (!was) Header();
      if (dark != k) DrawSwatches(); // the DMG's shades turned over: its raw tiles are drawn as they were
    }
  }
  ModHideBox();
  Hint(S_THEME_HINT);
}

// reading a theme file's text at THEME_JSON_BLOCK (size bytes), a forgiving JSON reader: commas and
// colons count as spaces, unknown keys are skipped, missing ones keep what the theme had
static unsigned char Peek(void) {
  unsigned int b;
  if (at >= size) return 0;
  b = THEME_JSON_BLOCK + (at >> 9);
  if (b != block) {
    Window(b);
    block = b;
  }
  return WINDOW[at & 511];
}
static unsigned char Space(unsigned char c) { return c == ' ' || c == 9 || c == 10 || c == 13 || c == ',' || c == ':'; }
static unsigned char Skip(void) { // the next char that isn't a space, not read
  unsigned char c;
  while (1) {
    c = Peek();
    if (!Space(c)) return c;
    ++at;
  }
}
static void Word(void) { // a number's or true's chars
  unsigned char c;
  while (1) {
    c = Peek();
    if (!c || Space(c) || c == ']' || c == '}') return;
    ++at;
  }
}
static void ReadString(char* dest) { // at its opening quote; up to 15 chars into dest (if it isn't 0)
  unsigned char c, n = 0;
  ++at;
  while (1) {
    c = Peek();
    if (!c) break;
    ++at;
    if (c == '"') break;
    if (c == 92) { // a backslash: what follows is skipped
      ++at;
      continue;
    }
    if (dest && n < 15) dest[n++] = (char)c;
  }
  if (dest) dest[n] = 0;
}
static void SkipValue(void) {
  unsigned char depth = 0, c;
  do {
    c = Skip();
    if (!c) return;
    if (c == '"') ReadString(0);
    else if (c == '[' || c == '{') { ++depth; ++at; }
    else if (c == ']' || c == '}') {
      if (!depth) return;
      --depth;
      ++at;
    }
    else Word();
  } while (depth);
}
static unsigned char Number(void) {
  unsigned char n = 0, c;
  while (1) {
    c = Peek();
    if (c < '0' || c > '9') return n;
    if (n < 100) n = (unsigned char)((n << 3) + (n << 1) + (c - '0'));
    ++at;
  }
}
static unsigned char Bool(void) {
  unsigned char c = Skip();
  Word();
  return c == 't';
}
static unsigned char Same(const char* a, const char* b) {
  while (*a && *a == *b) { ++a; ++b; }
  return *a == *b;
}

// "palettes": 8 palettes of 4 colours of red, green and blue (0-31), in order
static void ReadPalettes(void) {
  unsigned char depth = 0, c, ch = 0, colour = 0;
  do {
    c = Skip();
    if (!c) return;
    if (c == '[') { ++depth; ++at; }
    else if (c == ']') {
      if (!depth) return;
      --depth;
      ++at;
    }
    else if (c >= '0' && c <= '9') {
      c = Number();
      rgb[ch] = c > 31 ? 31 : c;
      ++ch;
      if (ch == 3) {
        ch = 0;
        if (colour < 32) {
          Pack(th + THEME_PALETTES + (colour << 1));
          ++colour;
        }
      }
    }
    else SkipValue();
  } while (depth);
}

// a look: {"palette": 0-7, "ink": 1-3, "bold": true, "italic": false, "font": "text" or "code"}
static void ReadLook(unsigned char s) {
  char key[16];
  unsigned char v = th[THEME_LOOKS + s], c, n;
  if (Skip() != '{') {
    SkipValue();
    return;
  }
  ++at;
  while (1) {
    c = Skip();
    if (c != '"') {
      if (c == '}') ++at;
      break;
    }
    ReadString(key);
    c = Skip();
    if (Same(key, "palette")) v = (unsigned char)((v & ~LOOK_PALETTE) | (Number() & 7) << 4);
    else if (Same(key, "ink")) {
      n = Number();
      v &= (unsigned char)~(LOOK_DIM | LOOK_ACCENT);
      if (n == 2) v |= LOOK_DIM;
      else if (n == 1) v |= LOOK_ACCENT;
    }
    else if (Same(key, "bold")) v = Bool() ? v | LOOK_BOLD : v & (unsigned char)~LOOK_BOLD;
    else if (Same(key, "italic")) v = Bool() ? v | LOOK_ITALIC : v & (unsigned char)~LOOK_ITALIC;
    else if (Same(key, "font") && c == '"') {
      ReadString(key);
      v = Same(key, "code") ? v | LOOK_CODE : v & (unsigned char)~LOOK_CODE;
    }
    else SkipValue();
  }
  if (s == THEME_BARS) v &= (unsigned char)~(LOOK_ITALIC | LOOK_CODE);
  th[THEME_LOOKS + s] = v;
}

static void Parse(void) {
  char key[16];
  unsigned char s;
  at = 0;
  block = 0xFFFF;
  if (Skip() != '{') return;
  ++at;
  while (Skip() == '"') {
    ReadString(key);
    if (Same(key, "palettes")) ReadPalettes();
    else {
      for (s = 0; s < 16 && !Same(key, keys[s]); ++s);
      if (s < 16) ReadLook(s);
      else SkipValue();
    }
  }
}

// /GBCSYS/THEMES/<name>.json into the copy, not edited; 0 if it can't be read
static unsigned char LoadTheme(const char* name) {
  char path[sizeof("GBCSYS/THEMES/.json") + THEME_NAME_MAX];
  ModuleLoad load;
  unsigned char i;
  *PutText(PutText(PutText(path, "GBCSYS/THEMES/"), name), ".json") = 0;
  load.block = THEME_JSON_BLOCK;
  load.blocks = THEME_JSON_BLOCKS;
  if (ModLoad(path, &load)) return 0;
  size = (unsigned int)load.size;
  Parse();
  for (i = 0; i <= THEME_NAME_MAX; ++i) th[THEME_NAME + i] = name[i];
  th[THEME_EDITED] = 0;
  return 1;
}

// writing the theme's text to THEME_JSON_BLOCK, its size at THEME_JSON_SIZE
static void Put(char c) {
  unsigned int b = THEME_JSON_BLOCK + (at >> 9);
  if (b != block) {
    Window(b);
    block = b;
  }
  WINDOW[at & 511] = (unsigned char)c;
  ++at;
}
static void PutS(const char* s) {
  while (*s) {
    Put(*s);
    ++s;
  }
}
static void PutN(unsigned char n) {
  char digits[3];
  *Digits(digits, n, 0) = 0;
  PutS(digits);
}
static void PutBool(const char* key, unsigned char on) {
  PutS(", \"");
  PutS(key);
  PutS("\": ");
  PutS(on ? "true" : "false");
}
static void Emit(void) {
  unsigned char p, c, k, v;
  at = 0;
  block = 0xFFFF;
  Put('{'); // (rgbasm reads braces in a string as its own)
  Put(10);
  PutS("  \"palettes\": [");
  Put(10);
  for (p = 0; p < 8; ++p) {
    PutS("    [");
    for (c = 0; c < 4; ++c) {
      if (c) PutS(", ");
      Unpack(Colour(p, c));
      Put('[');
      for (k = 0; k < 3; ++k) {
        if (k) PutS(", ");
        PutN(rgb[k]);
      }
      Put(']');
    }
    Put(']');
    if (p != 7) Put(',');
    Put(10);
  }
  PutS("  ]");
  for (k = 0; k < 16; ++k) {
    v = th[THEME_LOOKS + k];
    Put(',');
    Put(10);
    PutS("  \"");
    PutS(keys[k]);
    PutS("\": ");
    Put('{');
    PutS("\"palette\": ");
    PutN((v >> 4) & 7);
    PutS(", \"ink\": ");
    PutN(Ink(v));
    PutBool("bold", v & LOOK_BOLD);
    if (k != THEME_BARS) {
      PutBool("italic", v & LOOK_ITALIC);
      PutS(", \"font\": \"");
      PutS(v & LOOK_CODE ? "code" : "text");
      Put('"');
    }
    Put('}');
  }
  Put(10);
  Put('}');
  Put(10);
  th[THEME_JSON_SIZE] = (unsigned char)at;
  th[THEME_JSON_SIZE + 1] = (unsigned char)(at >> 8);
}

// the themes the host listed: their count, the i'th's name into dest
static unsigned char Themes(void) {
  Window(THEME_LIST_BLOCK);
  return WINDOW[0];
}
static void ThemeName(unsigned char i, char* dest) {
  unsigned char k;
  Window(THEME_LIST_BLOCK);
  for (k = 0; k <= THEME_NAME_MAX; ++k) dest[k] = (char)WINDOW[16 + (i << 4) + k];
}

// < and > on the theme's row: the one before or after it in the folder (edits asked about first)
static void NextTheme(unsigned char right) {
  static const unsigned int choices[] = {S_THEME_KEEP, S_THEME_DISCARD};
  char name[16];
  unsigned char n = Themes(), i;
  if (!n) return;
  if (th[THEME_EDITED] && Pick(choices, 2, 0) != 1) return;
  for (i = 0; i < n; ++i) {
    ThemeName(i, name);
    if (Same(name, (const char*)th + THEME_NAME)) break;
  }
  if (i == n) i = right ? n - 1 : 0; // not saved yet: from the first or last
  if (right) i = i + 1 == n ? 0 : i + 1;
  else i = i ? i - 1 : n - 1;
  ThemeName(i, name);
  if (!LoadTheme(name)) {
    Hint(S_THEME_UNREADABLE);
    return;
  }
  Commit(1);
  DrawAll();
}

// EDIT > COPY and PASTE: a look onto a look, a palette onto a palette
static void CopyPaste(unsigned char paste) {
  unsigned char kind = !entry ? 0 : entry < E_PALETTE ? 1 : 2, i, v;
  unsigned char* src = kind == 1 ? th + THEME_LOOKS + EntryStyle(entry) : Colour(entry - E_PALETTE, 0);
  if (!kind) return;
  if (!paste) {
    clip_kind = kind;
    for (i = 0; i < 8; ++i) clip[i] = src[i];
    return;
  }
  if (clip_kind != kind) return;
  if (kind == 1) {
    v = clip[0];
    if (entry == E_BARS) v &= (unsigned char)~(LOOK_ITALIC | LOOK_CODE);
    *src = v;
  }
  else for (i = 0; i < 8; ++i) src[i] = clip[i];
  th[THEME_EDITED] = 1;
  Commit(1);
  DrawAll();
}

static void Help(void) {
  unsigned char i;
  for (i = 0; i < 4; ++i) {
    char* d = BoxLine(i);
    *d++ = ' ';
    ModString(d, S_THEME_HELP + i);
  }
  ModMenu(lines, 4, NO_MARK);
  while (!ModKey());
  ModHideBox();
}

// Start: FILE (SAVE, SAVE AS), EDIT (COPY, PASTE), HELP, CLOSE (this is SETTINGS' own); returns the
// module's result, NO_MARK to go on
static unsigned char Menu(void) {
  static const unsigned int menu[] = {S_MENU_FILE, S_MENU_EDIT, S_MENU_HELP, S_MENU_CLOSE};
  static const unsigned int file[] = {S_SUB_SAVE, S_SUB_SAVE_AS};
  static const unsigned int edit[] = {S_BEDIT_COPY, S_BEDIT_PASTE};
  unsigned char item = 0, sub;
  while (1) {
    item = Pick(menu, 4, item);
    if (item == NO_MARK) return NO_MARK;
    if (item == 2) {
      Help();
      return NO_MARK;
    }
    if (item == 3) return changed ? THEME_CHANGED : THEME_DONE;
    sub = Pick(item ? edit : file, 2, 0);
    if (sub == NO_MARK) continue; // B: back to the menu
    if (item) {
      CopyPaste(sub);
      return NO_MARK;
    }
    Emit();
    return sub ? THEME_SAVE_AS : THEME_SAVE;
  }
}

static void Move(unsigned char down) {
  unsigned char was = top;
  if (down) entry = entry == ENTRIES - 1 ? 0 : entry + 1;
  else entry = entry ? entry - 1 : ENTRIES - 1;
  if (entry < top) top = entry;
  else if (entry >= top + LIST_ROWS) top = entry - LIST_ROWS + 1;
  if (top != was) DrawList();
  else ModSelect(entry - top, 0, 1);
  if (EntryPalette() != mark) DrawSwatches();
}

unsigned char ModuleMain(void) {
  unsigned char key, i, result;
  fullscreen = *(const unsigned char*)ModDriver(0x43) & FULLSCREEN;
  Window(SETTINGS_BLOCK);
  for (i = 0; i < THEME_SIZE; ++i) th[i] = WINDOW[THEME_OFFSET + i];
  entry = th[THEME_ENTRY];
  if (entry >= ENTRIES) entry = 0;
  top = entry >= LIST_ROWS ? entry - LIST_ROWS + 1 : 0;
  changed = 0;
  dark = ModTheme(0);
  ModHideBox();
  DrawAll();
  Hint(S_THEME_HINT);
  while (1) {
    do key = ModKey(); while (!key);
    if (key == KEY_UP || key == KEY_DOWN) Move(key == KEY_DOWN);
    else if (!entry && (key == KEY_LEFT || key == KEY_RIGHT || key == KEY_ENTER)) NextTheme(key != KEY_LEFT);
    else if (key == KEY_ENTER) {
      if (entry >= E_PALETTE) EditPalette(entry - E_PALETTE);
      else EditLook(EntryStyle(entry));
    }
    else if (key == KEY_MENU) {
      result = Menu();
      if (result != NO_MARK) {
        Store();
        return result;
      }
    }
  }
}
