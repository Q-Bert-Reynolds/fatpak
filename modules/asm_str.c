// ASM.MOD, page 12 with asm_emit.c: string symbols (EQUS) kept in a PSRAM heap that reads
// like an included file (source SRC_HEAP), string expressions and functions, and {}
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
    SetValue(heap_top);
    Entry(found)[8] = (unsigned char)n;
    Entry(found)[9] = (unsigned char)(n >> 8);
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
  unsigned int v;
  char digits[17];
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
  if (sym_kind == SYM_STRING) { Push(F_TEXT, SRC_HEAP, sym_value, sym_value + sym_extra); return; }
  v = sym_value;
  if (!colon) { type = 'X'; hash = 1; }
  base = type == 'b' ? 2 : type == 'o' ? 8 : type == 'x' || type == 'X' ? 16 : 10;
  if (type == 'd' && (v & 0x8000)) { neg = 1; v = -v; }
  n = 0;
  do {
    d = (unsigned char)Apply('%', v, base);
    digits[n++] = d < 10 ? '0' + d : (type == 'x' ? 'a' : 'A') + d - 10;
    v = Apply('/', v, base);
  } while (v);
  hash = hash && base != 10;
  i = 0;
  if (width > FMT_SIZE - 3) width = FMT_SIZE - 3;
  if (!zero) for (d = n + neg + hash; d < width; ++d) fmt_text[i++] = ' '; // spaces go first
  if (neg) fmt_text[i++] = '-';
  if (hash) fmt_text[i++] = base == 16 ? '$' : base == 2 ? '%' : '&';
  if (zero) for (d = n + neg + hash; d < width; ++d) fmt_text[i++] = '0'; // zeros after the sign
  while (n) fmt_text[i++] = digits[--n];
  Push(F_TEXT, SRC_FMT, 0, i);
}

void Purge(void) { Entry(found)[10] = 0; } // unfindable: its length no longer matches any name

