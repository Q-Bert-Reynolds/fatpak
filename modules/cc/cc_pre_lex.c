// CC pass A: reading files and raw tokens.
#define CC_PAGE pre_lex
#include "cc_pre.h"

void lit_add(u8 c) {
  if (lex_skip) return;
  if (heap_n >= (u32)CC_HEAP_BLOCKS * 512) cc_error(E_STRING_LITERALS_TOO_LONG);
  cc_sel((u16)(CC_HEAP_BLOCK + (u16)(heap_n >> 9)));
  cc_win[(u16)heap_n & 511] = c;
  ++heap_n;
}

s16 file_byte(File* f) { // next byte, or -1
  if (f->i == f->n) {
    if (f->eof) return -1;
    f->n = (u8)cc_host_read(f->handle, f->pos, fbuf, sizeof(fbuf));
    f->pos += f->n; f->i = 0;
    if (!f->n) { f->eof = 1; return -1; }
  }
  return (u8)fbuf[f->i++];
}

s16 file_char(File* f) { // next character after line splices; CR dropped
  for (;;) {
    s16 c = file_byte(f);
    if (c == '\r') continue;
    if (c == '\\') {
      s16 d = file_byte(f);
      while (d == '\r') d = file_byte(f);
      if (d == '\n') { ++f->line; continue; }
      if (d >= 0) --f->i; // unread: buf holds it (a refill for it put it at buf[0])
      else return c;
    }
    return c;
  }
}

void adv(void) {
  File* f = &files[nfiles - 1];
  if (f->la[0] == '\n') ++f->line;
  f->la[0] = f->la[1]; f->la[1] = f->la[2];
  f->la[2] = file_char(f);
  cc_line = f->line;
}

void file_push(u8 handle) {
  File* f;
  if (handle == 0xFF) cc_error(E_CANT_OPEN_FILE);
  if (nfiles == CC_FILES) cc_error(E_INCLUDES_NESTED_TOO_DEEPLY);
  if (nfiles) { f = &files[nfiles - 1]; f->pos -= (u8)(f->n - f->i); f->n = f->i = 0; }
  f = &files[nfiles++];
  f->handle = handle; f->n = f->i = f->eof = 0; f->pos = 0; f->line = 1;
  f->la[0] = f->la[1] = f->la[2] = ' ';
  adv(); adv(); adv();
  f->line = 1; cc_line = 1; cc_file = handle; at_bol = 1;
  { // its path, for diagnostics in every pass
    const char* p = cc_host_name(handle); u8* r = cc_at(CC_FILENAME_BLOCK, handle, 6); u8 i;
    for (i = 0; i < 63 && p[i]; ++i) r[i] = (u8)p[i];
    r[i] = 0;
  }
}

// ---- raw lexing from the current file ----

u8 is_id(s16 c) { return (c >= 'a' && c <= 'z') || (c >= 'A' && c <= 'Z') || c == '_' || (c >= '0' && c <= '9'); }

s16 hexval(s16 c) {
  if (c >= '0' && c <= '9') return c - '0';
  if (c >= 'a' && c <= 'f') return c - 'a' + 10;
  if (c >= 'A' && c <= 'F') return c - 'A' + 10;
  return -1;
}

u16 escape(void) { // after the backslash
  s16 c = C0; u16 v;
  adv();
  switch (c) {
  case 'n': return 10; case 't': return 9; case 'r': return 13; case 'a': return 7;
  case 'b': return 8; case 'f': return 12; case 'v': return 11;
  case '\\': case '\'': case '"': case '?': return (u16)c;
  case 'x':
    if (hexval(C0) < 0) cc_error(E_X_NEEDS_HEX_DIGITS);
    for (v = 0; hexval(C0) >= 0; adv()) { v = (u16)(v * 16 + hexval(C0)); if (v > 255) cc_error(E_ESCAPE_OUT_OF_RANGE); }
    return v;
  }
  if (c >= '0' && c <= '7') {
    u8 k;
    v = (u16)(c - '0');
    for (k = 0; k < 2 && C0 >= '0' && C0 <= '7'; ++k, adv()) v = (u16)(v * 8 + C0 - '0');
    if (v > 255) cc_error(E_ESCAPE_OUT_OF_RANGE);
    return v;
  }
  if (!lex_skip) cc_error(E_UNKNOWN_ESCAPE);
  return (u16)c;
}

void lex_raw(Tok* t) {
  s16 c;
  t->flags = 0;
again:
  for (;;) { // white space and comments
    if (C0 == '\n') { if (in_directive) break; adv(); at_bol = 1; t->flags |= TF_SPACE; continue; }
    if (C0 == ' ' || C0 == '\t' || C0 == '\f' || C0 == '\v') { adv(); t->flags |= TF_SPACE; continue; }
    if (C0 == '/' && C1 == '/') { while (C0 != '\n' && C0 >= 0) adv(); t->flags |= TF_SPACE; continue; }
    if (C0 == '/' && C1 == '*') {
      adv(); adv();
      while (!(C0 == '*' && C1 == '/')) { if (C0 < 0) cc_error(E_UNTERMINATED_COMMENT); adv(); }
      adv(); adv(); t->flags |= TF_SPACE; continue;
    }
    break;
  }
  if (at_bol) t->flags |= TF_BOL;
  at_bol = 0;
  t->line = cc_line; t->file = cc_file;
  c = C0;
  if (c < 0) { t->kind = TK_EOF; return; }
  if (c == '\n') { t->kind = TK_NL; return; } // only in a directive
  if (is_id(c) && !(c >= '0' && c <= '9')) {
    char buf[CC_NAME_MAX + 1]; u16 n = 0; // (the OS stack is small: a name is at most CC_NAME_MAX)
    while (is_id(C0)) {
      if (n == sizeof(buf)) { if (!lex_skip) cc_error(E_NAME_TOO_LONG); n = 0; } // skipped text: anything
      buf[n++] = (char)C0; adv();
    }
    t->kind = TK_ID; t->a = name_intern(buf, n);
    return;
  }
  if (c >= '0' && c <= '9') { lex_number(t); return; }
  if (c == '\'') {
    adv();
    if (C0 == '\'' || C0 == '\n' || C0 < 0) { if (lex_skip) goto skip_char; cc_error(E_EMPTY_CHARACTER_CONSTANT); }
    if (C0 == '\\') { adv(); t->v = escape(); } else { t->v = (u16)C0; adv(); }
    if (C0 != '\'') { if (lex_skip) goto skip_char; cc_error(E_CHARACTER_CONSTANT_NEEDS_ONE_CHARACTER); }
    adv();
    t->kind = TK_CHAR;
    return;
  skip_char:
    while (C0 != '\n' && C0 >= 0 && C0 != '\'') adv();
    if (C0 == '\'') adv();
    goto again;
  }
  if (c == '"') {
    adv();
    t->kind = TK_STR; t->v = heap_n; t->a = 0;
    while (C0 != '"') {
      u16 b;
      if (C0 == '\n' || C0 < 0) { if (lex_skip) { t->a = 0; return; } cc_error(E_UNTERMINATED_STRING); }
      if (C0 == '\\') { adv(); b = escape(); } else { b = (u16)C0; adv(); }
      lit_add((u8)b); ++t->a;
    }
    adv();
    return;
  }
  adv();
  t->kind = (u8)c;
  switch (c) {
  case '+': if (C0 == '+') { adv(); t->kind = TK_INC; } else if (C0 == '=') { adv(); t->kind = TK_ADDA; } break;
  case '-': if (C0 == '-') { adv(); t->kind = TK_DEC; } else if (C0 == '=') { adv(); t->kind = TK_SUBA; } else if (C0 == '>') { adv(); t->kind = TK_ARROW; } break;
  case '*': if (C0 == '=') { adv(); t->kind = TK_MULA; } break;
  case '/': if (C0 == '=') { adv(); t->kind = TK_DIVA; } break;
  case '%': if (C0 == '=') { adv(); t->kind = TK_MODA; } break;
  case '&': if (C0 == '&') { adv(); t->kind = TK_ANDAND; } else if (C0 == '=') { adv(); t->kind = TK_ANDA; } break;
  case '|': if (C0 == '|') { adv(); t->kind = TK_OROR; } else if (C0 == '=') { adv(); t->kind = TK_ORA; } break;
  case '^': if (C0 == '=') { adv(); t->kind = TK_XORA; } break;
  case '=': if (C0 == '=') { adv(); t->kind = TK_EQ; } break;
  case '!': if (C0 == '=') { adv(); t->kind = TK_NE; } break;
  case '<':
    if (C0 == '<') { adv(); t->kind = TK_SHL; if (C0 == '=') { adv(); t->kind = TK_SHLA; } }
    else if (C0 == '=') { adv(); t->kind = TK_LE; }
    break;
  case '>':
    if (C0 == '>') { adv(); t->kind = TK_SHR; if (C0 == '=') { adv(); t->kind = TK_SHRA; } }
    else if (C0 == '=') { adv(); t->kind = TK_GE; }
    break;
  case '.': if (C0 == '.' && C1 == '.') { adv(); adv(); t->kind = TK_ELLIPSIS; } else if (C0 >= '0' && C0 <= '9' && !lex_skip) cc_error(E_FLOATING_POINT_IS_NOT_SUPPORTED); break;
  case '#': if (C0 == '#') { adv(); t->kind = TK_HASHHASH; } break;
  case '(': case ')': case '[': case ']': case '{': case '}': case ',': case ';': case ':':
  case '?': case '~': break;
  default:
    if (!lex_skip) cc_error(E_UNEXPECTED_CHARACTER);
    goto again;
  }
}
