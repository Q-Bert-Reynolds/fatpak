// ASM.MOD: project.gbp (see asm_shared.h). BUILD looks for it in the document's folder and
// each one above; if there is one, it builds the project instead of the document:
//
//   ; comments
//   main   src/main.asm        the file to assemble, from the project's folder
//   output beisbol.gb          the ROM, from the project's folder (default: main's, as .gb)
//   rgbasm -D NAME[=VALUE] ... as rgbasm's: NAME is an EQUS, "1" without a value
//   rgbfix -jvcs -k 01 ...     as rgbfix's: -v -j -c -C -s and -k -l -m -n -p -r -t -i
//
// The logo and checksums are always fixed (-v) and the ROM padded to a power of two (-p, 0
// by default). Anything else is NOT SUPPORTED, at its line.
#include "asm_shared.h"

static const char proj_name[] = ASM_PROJECT_FILE;
static const char proj_words[] = "\004main\006output\006rgbasm\006rgbfix";
static const char proj_gb[] = ".gb";
static char proj_token[NAME_MAX + 1], proj_value[NAME_MAX + 1];
char output[65];
unsigned int main_file;
Pos main_at, main_end;
Fix fix;

// a word of the line into dest: up to a space, a tab, ';' or the line's end; "..." may hold them.
// Its length, 0 at the line's end
static unsigned char ProjWord(char* dest) {
  unsigned char n = 0, quote = 0;
  Space();
  if (ch == '"') { quote = 1; Advance(); }
  while (ch && ch != 10 && (quote ? ch != '"' : ch != ' ' && ch != '\t' && ch != '\r' && ch != ';')) {
    if (n == NAME_MAX) { Fail(ASM_ERR_NAME); return 0; }
    dest[n++] = ch;
    Advance();
  }
  if (quote) {
    if (ch != '"') { Fail(ASM_ERR_STRING); return 0; }
    Advance();
  }
  dest[n] = 0;
  return n;
}

// rgbfix's numbers: $hex, 0xhex, 0bbinary or decimal, up to 255
static unsigned char ProjByte(const char* s) {
  unsigned char base = 10, d;
  if (*s == '$') { base = 16; ++s; }
  else if (s[0] == '0' && (s[1] | 0x20) == 'x') { base = 16; s += 2; }
  else if (s[0] == '0' && (s[1] | 0x20) == 'b') { base = 2; s += 2; }
  if (!*s) Fail(ASM_ERR_SYNTAX);
  num.u = 0;
  for (; *s && !error; ++s) {
    d = *s;
    if (d >= '0' && d <= '9') d -= '0';
    else if ((d | 0x20) >= 'a' && (d | 0x20) <= 'f') d = (d | 0x20) - 'a' + 10;
    else d = 0xFF;
    if (d >= base) Fail(d == 0xFF && base == 10 ? ASM_ERR_UNSUPPORTED : ASM_ERR_SYNTAX); // MBC names
    Digit(base, d); // the lexer's (assembly)
    if (num.w[1] || num.w[0] > 255) Fail(ASM_ERR_RANGE);
  }
  return (unsigned char)num.w[0];
}

// -D NAME[=VALUE]: an EQUS defined before both passes, like rgbasm's
static void ProjDefine(const char* text) {
  unsigned char i;
  for (i = 0; text[i] && text[i] != '='; ++i) ident[i] = text[i];
  if (!i) { Fail(ASM_ERR_SYNTAX); return; }
  ident[ident_len = i] = 0;
  SaveName();
  str_top = 0;
  if (!text[i]) str[str_top++] = '1';
  else while (text[++i]) str[str_top++] = text[i];
  pass = 2; // defined in both passes, as DEF() sees it
  DefineString(0);
  pass = 0;
}

static const char proj_letters[] = "jcslmrnp"; // the ones that set a byte, in fix.bytes order (-C sets c's)
// the options after rgbasm (0) or rgbfix (1)
static void ProjOptions(unsigned char fixing) {
  const char *p, *v;
  unsigned char c, i;
  while (ProjWord(proj_token) && !error) {
    if (proj_token[0] != '-' || !proj_token[1]) { Fail(ASM_ERR_SYNTAX); return; }
    for (p = proj_token + 1; (c = *p) != 0 && !error; ++p) {
      if (!fixing) {
        if (c == 'W') break; // warnings: nothing to warn about
        if (c != 'D') { Fail(ASM_ERR_UNSUPPORTED); return; }
      }
      else if (c == 'v') continue; // always
      else if (c == 'C') { fix.bytes[1] = 0xC0; fix.given |= 2; continue; }
      if (c == 'j' || c == 'c' || c == 's') {
        for (i = 0; proj_letters[i] != c; ++i);
        fix.bytes[i] = c == 'j' ? 1 : c == 'c' ? 0x80 : 3;
        fix.given |= 1 << i;
        continue;
      }
      // the rest take a value: the rest of this word, or the next one
      if (fixing) {
        for (i = 0; proj_letters[i] && proj_letters[i] != c; ++i);
        if (!proj_letters[i] && c != 't' && c != 'k' && c != 'i') { Fail(ASM_ERR_UNSUPPORTED); return; }
      }
      if (p[1]) v = p + 1;
      else if (ProjWord(proj_value)) v = proj_value;
      else { Fail(ASM_ERR_SYNTAX); return; }
      if (c == 'D') ProjDefine(v);
      else if (c == 't' || c == 'k' || c == 'i') {
        char* dest = c == 't' ? fix.title : c == 'k' ? fix.licensee : fix.id;
        unsigned char size = c == 't' ? 16 : c == 'k' ? 2 : 4;
        for (i = 0; v[i] && i < size; ++i) dest[i] = v[i];
        if (c == 't') fix.title_n = i; else if (c == 'k') fix.licensee_n = i; else fix.id_n = i;
      }
      else {
        for (i = 0; proj_letters[i] != c; ++i);
        fix.bytes[i] = ProjByte(v);
        fix.given |= 1 << i;
      }
      break;
    }
  }
}

// which of proj_words[] ident is, 0xFF if none
static unsigned char ProjWhich(void) {
  const char* w = proj_words;
  unsigned char index = 0, i;
  while (*w) {
    if (*w == ident_len) {
      for (i = 0; i < ident_len && w[1 + i] == (ident[i] | 0x20); ++i);
      if (i == ident_len) return index;
    }
    w += *w + 1;
    ++index;
  }
  return 0xFF;
}

// reads project.gbp if there is one: 0 if there isn't (an error is reported at its line)
unsigned char Project(void) {
  unsigned char i, k;
  unsigned int file;
  for (i = 0; (path[i] = proj_name[i]) != 0; ++i);
  if (!(file = LoadPath())) return 0;
  depth = 0;
  frames[0].kind = F_TEXT;
  frames[0].source = SRC_TEXT;
  frames[0].file = file;
  frames[0].pos = file_at;
  frames[0].end = file_end;
  frames[0].line = 1;
  CacheStart(); // before main: it reads through build.cache too
  run_n = 0;
  ++literal; // no {} in it
  Advance();
  while (ch && !error) {
    Space();
    if (IsStart(ch)) {
      ReadIdent();
      k = ProjWhich();
      if (k == 0) { // main: read now, so a missing one is reported here
        ProjWord(path);
        if (!error && !(main_file = LoadPath())) Fail(file_error);
        main_at = file_at;
        main_end = file_end;
      }
      else if (k == 1) ProjWord(output);
      else if (k != 0xFF) ProjOptions(k - 2);
      else Fail(ASM_ERR_UNSUPPORTED);
    }
    Space();
    if (ch == ';') ToEnd();
    if (ch == 10) Advance();
    else if (ch && !error) Fail(ASM_ERR_SYNTAX);
  }
  --literal;
  if (!error && !main_file) Fail(ASM_ERR_FILE); // no main line: at the file's end
  if (error) return 1;
  if (!output[0]) { // main's path (still in path), as .gb
    for (i = 0, k = 0xFF; path[i] && i < sizeof(output) - 4; ++i) {
      if ((output[i] = path[i]) == '.') k = i;
      else if (path[i] == '/') k = 0xFF;
    }
    if (k == 0xFF) k = i;
    for (i = 0; (output[k + i] = proj_gb[i]) != 0; ++i);
  }
  return 1;
}
