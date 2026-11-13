// ASM.MOD, page 12 with asm_emit.c: string symbols (EQUS) kept in a PSRAM heap that reads
// like an included file (by address, from ASM_HEAP_BLOCK), string expressions and functions, and {}
// interpolation. See notes/ASSEMBLER.md.
#include "asm_shared.h"

char str[STR_SIZE]; // string expression results; nested ones stack up from str_top
unsigned int str_top, heap_top;
char fmt_text[FMT_SIZE]; // a formatted number for {}, read as source SRC_FMT
unsigned char redef;

static unsigned char HeapByte(unsigned int p) {
  Window(ASM_HEAP_BLOCK + (p >> 9));
  return WINDOW[p & 511];
}
static void Put(unsigned char c) {
  if (str_top == STR_SIZE) { Fail(ASM_ERR_STRING); return; }
  str[str_top++] = c;
}
// "..." or """...""" (which may span lines), at its opening quote
static void Literal(void) {
  unsigned char triple = 0, n;
  Advance();
  if (ch == '"') {
    Advance();
    if (ch != '"') return; // ""
    Advance();
    triple = 1;
  }
  while (!error) {
    if (ch == '"') {
      Advance();
      if (!triple) return;
      for (n = 1; ch == '"' && n < 3; ++n) Advance();
      if (n == 3) return;
      while (n--) Put('"');
    }
    else if (triple && ch == 10) { Put(10); Advance(); }
    else Put(Char());
  }
}
// an index into a string of length n: negative ones count from its end (STRSLICE)
static unsigned int Index(unsigned int v, unsigned int n) {
  if (v & 0x8000) v += n;
  return v > n ? n : v;
}
// a string expression at ch (or in ident when pending) onto str; returns where it starts
unsigned int StrExpr(void) {
  unsigned int start = str_top, from, to, i, n, a, b;
  unsigned char k;
  Space();
  if (!pending) {
    if (ch == '"') { Literal(); return start; }
    if (!IsStart(ch)) { Fail(ASM_ERR_SYNTAX); return start; }
    ReadIdent();
  }
  pending = 0;
  k = Keyword(T_STRFUNCS);
  if (k == 0xFF) { // a string symbol
    if (!FindDotted() || sym_kind != SYM_STRING) { Fail(ASM_ERR_SYMBOL); return start; }
    for (i = 0; i < sym_extra; ++i) Put(HeapByte(sym_value + i));
    return start;
  }
  Expect('(');
  StrExpr();
  n = str_top - start;
  switch (k) {
    case 0: // STRCAT: the rest follow it
      while (Comma()) StrExpr();
      break;
    case 1: case 2: // STRUPR, STRLWR
      for (i = start; i < str_top; ++i) {
        b = str[i];
        if (k == 1 && b >= 'a' && b <= 'z') str[i] = b - 32;
        if (k == 2 && b >= 'A' && b <= 'Z') str[i] = b + 32;
      }
      break;
    case 3: case 4: // STRSLICE(s, from[, to]) 0-based; STRSUB(s, pos[, length]) 1-based
      to = n;
      from = Comma() ? Constant() : 0;
      if (Comma()) to = Constant();
      if (k == 3) { from = Index(from, n); to = Index(to, n); }
      else {
        from = from ? Index(from - 1, n) : 0;
        to = to > n - from ? n : from + to;
      }
      if (to < from) to = from;
      for (i = from; i < to; ++i) str[start + i - from] = str[start + i];
      str_top = start + to - from;
      break;
    default: // STRRPL(s, old, new): built after the arguments, then moved down
      a = str_top;
      if (Comma()) StrExpr();
      b = str_top;
      if (Comma()) StrExpr();
      to = str_top;
      for (i = start; i < a && !error;) {
        for (from = 0; a + from < b && i + from < a && str[i + from] == str[a + from]; ++from);
        if (b > a && a + from == b) { // a match
          for (from = b; from < to; ++from) Put(str[from]);
          i += b - a;
        }
        else Put(str[i++]);
      }
      for (i = to; i < str_top; ++i) str[start + i - to] = str[i];
      str_top = start + str_top - to;
  }
  Expect(')');
  return start;
}
// STRLEN, STRCMP, STRFIND, STRRFIND (Symbol: k is their index in T_FUNCTIONS, from 5)
unsigned int StrNumber(unsigned char k) {
  unsigned int start = str_top, a, b, n, i, j, v = 0;
  Expect('(');
  StrExpr();
  a = str_top;
  if (k != 5) { Comma(); StrExpr(); }
  b = str_top;
  Expect(')');
  if (k == 5) v = a - start;
  else if (k == 6) { // -1, 0 or 1, like strcmp
    for (i = start, j = a; i < a && j < b && str[i] == str[j]; ++i, ++j);
    if (i < a && j < b) v = (unsigned char)str[i] < (unsigned char)str[j] ? 0xFFFF : 1;
    else v = i < a ? 1 : j < b ? 0xFFFF : 0;
  }
  else { // the first (last) index of the second string in the first, -1 if none
    v = 0xFFFF;
    n = b - a;
    for (i = start; i + n <= a; ++i) {
      for (j = 0; j < n && str[i + j] == str[a + j]; ++j);
      if (j == n) { v = i - start; if (k == 7) break; }
    }
  }
  str_top = start;
  return v;
}
// DEF/REDEF name EQUS: the string at start (to str_top) goes on the heap
void DefineString(unsigned int start) {
  unsigned int n = str_top - start, i;
  for (i = 0; i < n; ++i) {
    Window(ASM_HEAP_BLOCK + ((heap_top + i) >> 9));
    WINDOW[(heap_top + i) & 511] = str[start + i];
  }
  str_top = start;
  if (heap_top + n < heap_top) { Fail(ASM_ERR_FULL); return; }
  LoadName();
  sym_extra = n;
  if (Find()) {
    if (sym_kind != SYM_STRING || (pass == 1 && !redef)) { Fail(ASM_ERR_DUPLICATE); return; }
    SetValue(heap_top, n);
  }
  else Add(pass == 2 ? SYM_STRING | SYM_SEEN : SYM_STRING, heap_top, 0);
  if (pass == 2) Mark();
  heap_top += n;
}

// {name} or {format:name}, just after the brace: the text that replaces it becomes a frame.
// A string symbol's text is its heap range; a number is formatted into fmt_text: by default
// $ and uppercase hex, else [#][0][width] and d u x X b o (# adds $ % & to x b o)
static char word[NAME_MAX + 1];
static unsigned char word_len;
void Interpolate(void) {
  unsigned char spec[NAME_MAX + 8], n = 0, colon = 0, i, type = 0, hash = 0, zero = 0, width = 0, base, d, neg = 0;
  UVal v;
  Pos at;
  char digits[33];
  Advance();
  while (ch != '}') {
    if (!ch || ch == 10 || n == sizeof(spec) - 1) { Fail(ASM_ERR_SYNTAX); return; }
    if (ch == ':' && !colon) colon = n + 1;
    spec[n++] = ch;
    Advance();
  }
  spec[n] = 0;
  for (i = 0; i <= ident_len; ++i) word[i] = ident[i]; // a word may be half read: {} can be inside one
  word_len = ident_len;
  for (ident_len = 0; spec[colon + ident_len]; ++ident_len) ident[ident_len] = spec[colon + ident_len];
  ident[ident_len] = 0;
  d = FindDotted();
  for (i = 0; i <= word_len; ++i) ident[i] = word[i];
  ident_len = word_len;
  if (!d) { Fail(ASM_ERR_SYMBOL); return; }
  for (i = 0; i + 1 < colon; ++i) { // the format
    d = spec[i];
    if (d == '#') hash = 1;
    else if (d == '0' && !width) zero = 1;
    else if (d >= '0' && d <= '9') width = width * 10 + d - '0';
    else type = d;
  }
  if (sym_kind == SYM_STRING) {
    at = ADDRESS(ASM_HEAP_BLOCK) + sym_value;
    Push(F_TEXT, SRC_TEXT, at, at + sym_extra)->file = FILE_EXPANSION;
    return;
  }
  v = sym_value;
  if (sym_kind == SYM_EQU || sym_kind == SYM_VAR) v |= (UVal)sym_extra << 16;
  if (!colon) { type = 'X'; hash = 1; }
  base = type == 'b' ? 2 : type == 'o' ? 8 : type == 'x' || type == 'X' ? 16 : 10;
  if (type == 'd' && (v >> 31)) { neg = 1; v = 0 - v; }
  n = 0;
  do {
    v = Div(v, base);
    d = (unsigned char)div_rem;
    digits[n++] = d < 10 ? '0' + d : (type == 'x' ? 'a' : 'A') + d - 10;
  } while (v);
  hash = hash && base != 10;
  i = 0;
  if (width > FMT_SIZE - 3) width = FMT_SIZE - 3;
  if (!zero) for (d = n + neg + hash; d < width; ++d) fmt_text[i++] = ' '; // spaces go first
  if (neg) fmt_text[i++] = '-';
  if (hash) fmt_text[i++] = base == 16 ? '$' : base == 2 ? '%' : '&';
  if (zero) for (d = n + neg + hash; d < width; ++d) fmt_text[i++] = '0'; // zeros after the sign
  while (n) fmt_text[i++] = digits[--n];
  Push(F_TEXT, SRC_FMT, 0, i)->file = FILE_EXPANSION;
}

void Purge(void) { Entry(found)[10] = 0; } // unfindable: its length no longer matches any name


// --- charmaps (CHARMAP, NEWCHARMAP, SETCHARMAP, PUSHC, POPC): in PSRAM from ASM_CHARMAP_BLOCK.
// Block CM_NAMES holds the names (32 bytes each, length first); each map has a block of 256
// heads, one per first character, pointing into a shared pool of entries: next (2), length,
// value count, the string, the values. A new map copies its base's heads and later entries go
// in front, so maps share their tails. Rebuilt every pass, in the same order.
#define CM_NAMES ASM_CHARMAP_BLOCK
#define CM_HEADS (ASM_CHARMAP_BLOCK + 1) // + map
#define CM_MAPS 8
#define CM_POOL (ASM_CHARMAP_BLOCK + 1 + CM_MAPS) // its first block; pool positions are bytes from there
static unsigned char cm_current, cm_count, cm_used; // cm_used: a bit for each map with entries
static unsigned char cm_stack[8], cm_sp;
static unsigned int cm_top; // the pool's next free byte (0 means "none")

static unsigned char PoolByte(unsigned int p) {
  Window(CM_POOL + (p >> 9));
  return WINDOW[p & 511];
}
static void PoolPut(unsigned char b) {
  if (cm_top >= 120u << 9) { Fail(ASM_ERR_FULL); return; } // the pool ends at block $18FF
  Window(CM_POOL + (cm_top >> 9));
  WINDOW[cm_top & 511] = b;
  ++cm_top;
}
static unsigned int Head(unsigned char map, unsigned char c) {
  Window(CM_HEADS + map);
  return WINDOW[c << 1] | (WINDOW[(c << 1) + 1] << 8);
}
static void SetHead(unsigned char map, unsigned char c, unsigned int p) {
  Window(CM_HEADS + map);
  WINDOW[c << 1] = (unsigned char)p;
  WINDOW[(c << 1) + 1] = (unsigned char)(p >> 8);
}
// map's heads: a copy of base's, or all none (base 0xFF)
static void Heads(unsigned char map, unsigned char base) {
  unsigned int i;
  for (i = 0; i < 512; ++i) {
    if (base == 0xFF) { Window(CM_HEADS + map); WINDOW[i] = 0; }
    else { Window(CM_HEADS + base); str[0] = WINDOW[i]; Window(CM_HEADS + map); WINDOW[i] = str[0]; }
  }
  if (base == 0xFF || !(cm_used & (1 << base))) cm_used &= ~(1 << map);
  else cm_used |= 1 << map;
}
// the map named ident, 0xFF if none
static unsigned char MapNamed(void) {
  unsigned char m, i;
  for (m = 0; m < cm_count; ++m) {
    Window(CM_NAMES);
    if (WINDOW[m << 5] != ident_len) continue;
    for (i = 0; i < ident_len && WINDOW[(m << 5) + 1 + i] == ident[i]; ++i);
    if (i == ident_len) return m;
  }
  return 0xFF;
}
static void NameMap(unsigned char m) {
  unsigned char i;
  Window(CM_NAMES);
  WINDOW[m << 5] = ident_len;
  for (i = 0; i < ident_len && i < 31; ++i) WINDOW[(m << 5) + 1 + i] = ident[i];
}
void CharmapReset(void) { // each pass starts with an empty "main"
  cm_current = cm_sp = cm_used = 0;
  cm_top = 2;
  cm_count = 1;
  for (ident_len = 0; ident_len < 4; ++ident_len) ident[ident_len] = "main"[ident_len];
  ident[4] = 0;
  NameMap(0);
  Heads(0, 0xFF);
}
// the longest entry of the current map matching str[at..end): its pool position, 0 if none
static unsigned int Match(unsigned int at, unsigned int end, unsigned char* matched) {
  unsigned int p, best = 0;
  unsigned char n, i, best_n = 0;
  for (p = Head(cm_current, (unsigned char)str[at]); p; p = PoolByte(p) | (PoolByte(p + 1) << 8)) {
    n = PoolByte(p + 2);
    if (n <= best_n || at + n > end) continue; // a newer entry of the same length wins: it's first
    for (i = 1; i < n && PoolByte(p + 4 + i) == (unsigned char)str[at + i]; ++i);
    if (i == n) { best = p; best_n = n; }
  }
  *matched = best_n;
  return best;
}
// emits str[start..str_top) through the current charmap, and uses it up
void MapEmit(unsigned int start) {
  unsigned int at, p, end = str_top;
  unsigned char n, v, i;
  for (at = start; at < end && !error;) {
    if (!(cm_used & (1 << cm_current)) || !(p = Match(at, end, &n))) { Emit(str[at++]); continue; }
    v = PoolByte(p + 3);
    for (i = 0; i < v; ++i) Emit(PoolByte(p + 4 + n + i));
    at += n;
  }
  str_top = start;
}
// 'x' (just after the quote): one charmap entry, or one unmapped character
unsigned int CharLiteral(void) {
  unsigned int start = str_top, p, v;
  unsigned char n = 0;
  while (ch != '\'' && !error) {
    v = Char();
    if (str_top == STR_SIZE) Fail(ASM_ERR_STRING);
    else str[str_top++] = (char)v;
  }
  Advance();
  v = (unsigned char)str[start];
  if (str_top - start != 1 || (cm_used & (1 << cm_current))) {
    p = (cm_used & (1 << cm_current)) ? Match(start, str_top, &n) : 0;
    if (p && n == str_top - start) { // one entry: it must be one byte
      if (PoolByte(p + 3) == 1) v = PoolByte(p + 4 + n);
      else Fail(ASM_ERR_STRING);
    }
    else if (str_top - start != 1) Fail(ASM_ERR_STRING);
  }
  str_top = start;
  return v;
}
// d: 0 CHARMAP "string", value, ...; 1 NEWCHARMAP name[, base]; 2 SETCHARMAP name; 3 PUSHC; 4 POPC
void Charmap(unsigned char d) {
  unsigned int start, entry;
  unsigned char m, n, base;
  if (d == 3) { if (cm_sp == sizeof(cm_stack)) Fail(ASM_ERR_NESTING); else cm_stack[cm_sp++] = cm_current; return; }
  if (d == 4) { if (!cm_sp) Fail(ASM_ERR_SYNTAX); else cm_current = cm_stack[--cm_sp]; return; }
  if (d == 0) {
    start = StrExpr();
    n = (unsigned char)(str_top - start);
    if (!n || str_top - start > 255) { Fail(ASM_ERR_STRING); return; }
    entry = cm_top;
    PoolPut((unsigned char)Head(cm_current, (unsigned char)str[start]));
    PoolPut((unsigned char)(Head(cm_current, (unsigned char)str[start]) >> 8));
    PoolPut(n);
    PoolPut(0); // the value count, written below
    for (m = 0; m < n; ++m) PoolPut(str[start + m]);
    for (m = 0; Comma(); ++m) PoolPut((unsigned char)Constant());
    if (!m) { Fail(ASM_ERR_SYNTAX); return; }
    cm_top -= m + n + 1; // the count, then back to the end
    PoolPut(m);
    cm_top += n + m;
    SetHead(cm_current, (unsigned char)str[start], entry);
    cm_used |= 1 << cm_current;
    str_top = start;
    return;
  }
  Space();
  ReadIdent();
  if (!ident_len) { Fail(ASM_ERR_SYNTAX); return; }
  m = MapNamed();
  if (d == 2) { if (m == 0xFF) Fail(ASM_ERR_SYMBOL); else cm_current = m; return; }
  if (m != 0xFF) { Fail(ASM_ERR_DUPLICATE); return; } // each pass rebuilds the maps, so pass 2 starts empty too
  if (cm_count == CM_MAPS) { Fail(ASM_ERR_NESTING); return; }
  m = cm_count++;
  NameMap(m);
  base = 0xFF;
  if (Comma()) {
    Space();
    ReadIdent();
    base = MapNamed();
    if (base == 0xFF) { Fail(ASM_ERR_SYMBOL); return; }
  }
  Heads(m, base);
  cm_current = m;
}
