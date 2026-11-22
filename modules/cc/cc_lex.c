// CC's lexer and preprocessor: files -> tokens with #include, #define (object- and
// function-like), #undef, #if/#ifdef/#ifndef/#elif/#else/#endif, #error, #warning,
// defined, __FILE__ and __LINE__.
//
// Macro expansion: a function-like macro's arguments are expanded first (each one alone,
// behind a barrier so it can't read past its end), substituted, and the result is read
// again with the macro disabled until that list is used up. A disabled macro's name seen
// meanwhile is painted (TF_NOEXPAND) so it never expands later. Token lists share one
// arena: definitions and argument work grow up from the bottom, active expansions grow
// down from the top and are freed as they finish.
#include "cc.h"

// ---- names ----
typedef struct { u16 off; u8 len; u8 pad; u16 macro; } Name;
static Name names[CC_NAMES];
static u16 nnames = 1;
static char name_pool[CC_NAME_POOL];
static u16 name_pool_n;
static u16 name_hash[CC_NAMES * 2];

static u8 same(const char* a, const char* b, u16 n) { while (n--) if (*a++ != *b++) return 0; return 1; }
static u16 slen(const char* s) { u16 n = 0; while (s[n]) ++n; return n; }

u16 name_intern(const char* s, u16 n) {
  u16 h = 5381, i;
  for (i = 0; i < n; ++i) h = (u16)(h * 33 + (u8)s[i]);
  if (n > 255) cc_error("name too long");
  for (i = h & (CC_NAMES * 2 - 1);; i = (i + 1) & (CC_NAMES * 2 - 1)) {
    u16 id = name_hash[i];
    if (!id) break;
    if (names[id].len == n && same(name_pool + names[id].off, s, n)) return id;
  }
  if (nnames == CC_NAMES) cc_error("too many names");
  if (name_pool_n + n > CC_NAME_POOL) cc_error("name pool full");
  names[nnames].off = name_pool_n; names[nnames].len = (u8)n; names[nnames].macro = 0;
  for (h = 0; h < n; ++h) name_pool[name_pool_n++] = s[h];
  name_hash[i] = nnames;
  return nnames++;
}
const char* name_text(u16 id, u8* len) { *len = names[id].len; return name_pool + names[id].off; }

static const char* const fixed_names[] = {
  "", "void", "char", "short", "int", "long", "signed", "unsigned", "_Bool", "const", "volatile",
  "static", "extern", "typedef", "auto", "register", "inline", "struct", "union", "enum", "if",
  "else", "while", "do", "for", "break", "continue", "return", "switch", "case", "default", "goto",
  "sizeof", "restrict", "float", "double",
  // preprocessor names, from KW_COUNT
  "defined", "__FILE__", "__LINE__", "include", "define", "undef", "ifdef", "ifndef", "elif",
  "endif", "error", "warning", "pragma", "line", "__VA_ARGS__"
};
enum { NM_DEFINED = KW_COUNT, NM_FILE, NM_LINE, NM_INCLUDE, NM_DEFINE, NM_UNDEF, NM_IFDEF,
       NM_IFNDEF, NM_ELIF, NM_ENDIF, NM_ERROR, NM_WARNING, NM_PRAGMA, NM_LINENO, NM_VA_ARGS, NM_FIXED };

// ---- string literal bytes ----
static u8 lit_pool[CC_LIT_POOL]; static u16 lit_n;
static u8 perm_pool[CC_PERM_POOL]; static u16 perm_n;
static u8 lex_perm, lex_skip; // literals go to perm_pool (a #define body); skipping text
u8 lit_byte(const Tok* t, u16 i) { return t->flags & TF_PERM ? perm_pool[t->v + i] : lit_pool[t->v + i]; }
void lit_reset(void) { lit_n = 0; }
static void lit_add(u8 c) {
  if (lex_skip) return;
  if (lex_perm) { if (perm_n == CC_PERM_POOL) cc_error("macro string pool full"); perm_pool[perm_n++] = c; }
  else { if (lit_n == CC_LIT_POOL) cc_error("string literals too long"); lit_pool[lit_n++] = c; }
}

// ---- files ----
typedef struct { u8 handle, n, i, eof; u32 pos; u16 line; s16 la[3]; char buf[128]; } File;
static File files[CC_FILES];
static u8 nfiles;
u16 lex_line; u8 lex_file;
static u8 at_bol, in_directive;

static s16 file_byte(File* f) { // next byte, or -1
  if (f->i == f->n) {
    if (f->eof) return -1;
    f->n = (u8)cc_host_read(f->handle, f->pos, f->buf, sizeof(f->buf));
    f->pos += f->n; f->i = 0;
    if (!f->n) { f->eof = 1; return -1; }
  }
  return (u8)f->buf[f->i++];
}
static s16 file_char(File* f) { // next character after line splices; CR dropped
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
#define C0 (files[nfiles - 1].la[0])
#define C1 (files[nfiles - 1].la[1])
#define C2 (files[nfiles - 1].la[2])
static void adv(void) {
  File* f = &files[nfiles - 1];
  if (f->la[0] == '\n') ++f->line;
  f->la[0] = f->la[1]; f->la[1] = f->la[2];
  f->la[2] = file_char(f);
  lex_line = f->line;
}
static void file_push(u8 handle) {
  File* f;
  if (handle == 0xFF) cc_error("can't open file");
  if (nfiles == CC_FILES) cc_error("includes nested too deeply");
  f = &files[nfiles++];
  f->handle = handle; f->n = f->i = f->eof = 0; f->pos = 0; f->line = 1;
  f->la[0] = f->la[1] = f->la[2] = ' ';
  adv(); adv(); adv();
  f->line = 1; lex_line = 1; lex_file = handle; at_bol = 1;
}
u8 lex_open_main(const char* path) { file_push(cc_host_open(path, 0, 0xFF)); return files[0].handle; }

// ---- raw lexing from the current file ----
static u8 is_id(s16 c) { return (c >= 'a' && c <= 'z') || (c >= 'A' && c <= 'Z') || c == '_' || (c >= '0' && c <= '9'); }
static s16 hexval(s16 c) {
  if (c >= '0' && c <= '9') return c - '0';
  if (c >= 'a' && c <= 'f') return c - 'a' + 10;
  if (c >= 'A' && c <= 'F') return c - 'A' + 10;
  return -1;
}
static u16 escape(void) { // after the backslash
  s16 c = C0; u16 v;
  adv();
  switch (c) {
  case 'n': return 10; case 't': return 9; case 'r': return 13; case 'a': return 7;
  case 'b': return 8; case 'f': return 12; case 'v': return 11;
  case '\\': case '\'': case '"': case '?': return (u16)c;
  case 'x':
    if (hexval(C0) < 0) cc_error("\\x needs hex digits");
    for (v = 0; hexval(C0) >= 0; adv()) { v = (u16)(v * 16 + hexval(C0)); if (v > 255) cc_error("escape out of range"); }
    return v;
  }
  if (c >= '0' && c <= '7') {
    u8 k;
    v = (u16)(c - '0');
    for (k = 0; k < 2 && C0 >= '0' && C0 <= '7'; ++k, adv()) v = (u16)(v * 8 + C0 - '0');
    if (v > 255) cc_error("escape out of range");
    return v;
  }
  if (!lex_skip) cc_error("unknown escape");
  return (u16)c;
}
static void lex_number(Tok* t) {
  u32 v = 0; u8 base = 10, digits = 0; s16 d;
  if (C0 == '0' && (C1 == 'x' || C1 == 'X')) { base = 16; adv(); adv(); }
  else if (C0 == '0' && (C1 == 'b' || C1 == 'B')) { base = 2; adv(); adv(); }
  else if (C0 == '0') base = 8;
  for (;; adv()) {
    d = hexval(C0);
    if (d < 0 || (base != 16 && d > 9)) break;
    if (d >= base) { if (!lex_skip) cc_error("bad digit in number"); d = 0; }
    if (v > (0xFFFFFFFFul - (u32)d) / base && !lex_skip) cc_error("integer constant too large");
    v = v * base + (u32)d; ++digits;
  }
  if (!digits && !lex_skip) cc_error("number has no digits");
  t->kind = TK_NUM; t->v = v;
  if (base != 10) t->flags |= TF_RADIX;
  for (;;) {
    if (C0 == 'u' || C0 == 'U') { t->flags |= TF_UNSIGNED; adv(); }
    else if (C0 == 'l' || C0 == 'L') { if (C1 == 'l' || C1 == 'L') { if (!lex_skip) cc_error("long long is not supported"); adv(); } t->flags |= TF_LONG; adv(); }
    else break;
  }
  if (is_id(C0) || C0 == '.') {
    if (!lex_skip) cc_error(C0 == '.' || C0 == 'e' || C0 == 'E' || C0 == 'f' ? "floating point is not supported" : "bad number suffix");
    while (is_id(C0) || C0 == '.') adv();
  }
}

static void lex_raw(Tok* t) {
  s16 c;
  t->flags = 0;
again:
  for (;;) { // white space and comments
    if (C0 == '\n') { if (in_directive) break; adv(); at_bol = 1; t->flags |= TF_SPACE; continue; }
    if (C0 == ' ' || C0 == '\t' || C0 == '\f' || C0 == '\v') { adv(); t->flags |= TF_SPACE; continue; }
    if (C0 == '/' && C1 == '/') { while (C0 != '\n' && C0 >= 0) adv(); t->flags |= TF_SPACE; continue; }
    if (C0 == '/' && C1 == '*') {
      adv(); adv();
      while (!(C0 == '*' && C1 == '/')) { if (C0 < 0) cc_error("unterminated comment"); adv(); }
      adv(); adv(); t->flags |= TF_SPACE; continue;
    }
    break;
  }
  if (at_bol) t->flags |= TF_BOL;
  at_bol = 0;
  t->line = lex_line; t->file = lex_file;
  c = C0;
  if (c < 0) { t->kind = TK_EOF; return; }
  if (c == '\n') { t->kind = TK_NL; return; } // only in a directive
  if (is_id(c) && !(c >= '0' && c <= '9')) {
    char buf[256]; u16 n = 0;
    while (is_id(C0)) { if (n == sizeof(buf)) cc_error("name too long"); buf[n++] = (char)C0; adv(); }
    t->kind = TK_ID; t->a = name_intern(buf, n);
    return;
  }
  if (c >= '0' && c <= '9') { lex_number(t); return; }
  if (c == '\'') {
    adv();
    if (C0 == '\'' || C0 == '\n' || C0 < 0) { if (lex_skip) goto skip_char; cc_error("empty character constant"); }
    if (C0 == '\\') { adv(); t->v = escape(); } else { t->v = (u16)C0; adv(); }
    if (C0 != '\'') { if (lex_skip) goto skip_char; cc_error("character constant needs one character and a closing '"); }
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
    t->kind = TK_STR; t->v = lex_perm ? perm_n : lit_n; t->a = 0;
    if (lex_perm) t->flags |= TF_PERM;
    while (C0 != '"') {
      u16 b;
      if (C0 == '\n' || C0 < 0) { if (lex_skip) { t->a = 0; return; } cc_error("unterminated string"); }
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
  case '.': if (C0 == '.' && C1 == '.') { adv(); adv(); t->kind = TK_ELLIPSIS; } else if (C0 >= '0' && C0 <= '9' && !lex_skip) cc_error("floating point is not supported"); break;
  case '#': if (C0 == '#') { adv(); t->kind = TK_HASHHASH; } break;
  case '(': case ')': case '[': case ']': case '{': case '}': case ',': case ';': case ':':
  case '?': case '~': break;
  default:
    if (!lex_skip) cc_error("unexpected character");
    goto again;
  }
}

// ---- token arena, macros, sources ----
static Tok toks[CC_TOKENS];
static u16 tok_lo, tok_hi = CC_TOKENS;
typedef struct { u16 name, start, len; u8 nparams, disabled; } Macro; // nparams 0xFF: object-like
static Macro macros[CC_MACROS];
static u16 nmacros = 1;
typedef struct { u16 pos, end, free_to, macro; u8 barrier; } Src;
static Src srcs[CC_EXPAND];
static u8 nsrc;
static Tok pushback; static u8 has_pushback;

static void lo_add(const Tok* t) {
  if (tok_lo >= tok_hi) cc_error("macro token space full");
  toks[tok_lo++] = *t;
}
static void src_push(u16 pos, u16 end, u16 free_to, u16 macro, u8 barrier) {
  Src* s;
  if (nsrc == CC_EXPAND) cc_error("macros nested too deeply");
  s = &srcs[nsrc++];
  s->pos = pos; s->end = end; s->free_to = free_to; s->macro = macro; s->barrier = barrier;
  if (macro) macros[macro].disabled = 1;
}

// ---- conditionals ----
enum { IF_ACTIVE, IF_WAITING, IF_DONE }; // taking this branch; none taken yet; one taken (or the parent skips)
static u8 ifs[CC_IFS], nifs, skipping;
static void update_skip(void) { u8 i; skipping = 0; for (i = 0; i < nifs; ++i) if (ifs[i] != IF_ACTIVE) skipping = 1; lex_skip = skipping; }

static void file_next(Tok* t);
static void raw_next(Tok* t) {
  if (has_pushback) { *t = pushback; has_pushback = 0; return; }
  while (nsrc) {
    Src* s = &srcs[nsrc - 1];
    if (s->pos < s->end) { *t = toks[s->pos++]; t->line = lex_line; t->file = lex_file; return; }
    if (s->barrier) { t->kind = TK_END; t->flags = 0; return; }
    if (s->macro) macros[s->macro].disabled = 0;
    if (s->free_to) tok_hi = s->free_to;
    --nsrc;
  }
  file_next(t);
}

static void directive_line(Tok* t) { lex_raw(t); } // in_directive is set: ends with TK_NL
static void skip_line(void) { Tok t; do directive_line(&t); while (t.kind != TK_NL && t.kind != TK_EOF); }

// #if arithmetic (results through pointers: SDCC can't return structs)
typedef struct { s32 v; u8 u; } PPV;
static Tok ppt;
static void pp_adv(void);
static void pp_expr(u8 min, PPV* l);
static void pp_unary(PPV* r) {
  r->u = 0; r->v = 0;
  switch (ppt.kind) {
  case TK_NUM: r->v = (s32)ppt.v; r->u = (ppt.flags & TF_UNSIGNED) || ppt.v > 0x7FFFFFFFul; pp_adv(); return;
  case TK_CHAR: r->v = (s32)ppt.v; pp_adv(); return;
  case TK_ID: pp_adv(); return; // an identifier left after expansion is 0
  case '(': pp_adv(); pp_expr(0, r); if (ppt.kind != ')') cc_error("missing ) in #if"); pp_adv(); return;
  case '+': pp_adv(); pp_unary(r); return;
  case '-': pp_adv(); pp_unary(r); r->v = (s32)(0u - (u32)r->v); return;
  case '~': pp_adv(); pp_unary(r); r->v = ~r->v; return;
  case '!': pp_adv(); pp_unary(r); r->v = !r->v; r->u = 0; return;
  }
  cc_error("bad #if expression");
}
static u8 pp_prec(u8 k) {
  switch (k) {
  case '?': return 1; case TK_OROR: return 2; case TK_ANDAND: return 3; case '|': return 4; case '^': return 5;
  case '&': return 6; case TK_EQ: case TK_NE: return 7; case '<': case '>': case TK_LE: case TK_GE: return 8;
  case TK_SHL: case TK_SHR: return 9; case '+': case '-': return 10; case '*': case '/': case '%': return 11;
  }
  return 0;
}
static void pp_expr(u8 min, PPV* l) {
  PPV r;
  pp_unary(l);
  for (;;) {
    u8 k = ppt.kind, p = pp_prec(k), u;
    if (!p || p <= min) return;
    pp_adv();
    if (k == '?') {
      PPV a, b;
      pp_expr(0, &a);
      if (ppt.kind != ':') cc_error("missing : in #if");
      pp_adv(); pp_expr(0, &b);
      u = a.u | b.u;
      *l = l->v ? a : b; l->u = u;
      continue;
    }
    pp_expr(p, &r);
    u = l->u | r.u;
    switch (k) {
    case TK_OROR: l->v = l->v || r.v; u = 0; break;
    case TK_ANDAND: l->v = l->v && r.v; u = 0; break;
    case '|': l->v |= r.v; break; case '^': l->v ^= r.v; break; case '&': l->v &= r.v; break;
    case TK_EQ: l->v = l->v == r.v; u = 0; break; case TK_NE: l->v = l->v != r.v; u = 0; break;
    case '<': l->v = u ? (u32)l->v < (u32)r.v : l->v < r.v; u = 0; break;
    case '>': l->v = u ? (u32)l->v > (u32)r.v : l->v > r.v; u = 0; break;
    case TK_LE: l->v = u ? (u32)l->v <= (u32)r.v : l->v <= r.v; u = 0; break;
    case TK_GE: l->v = u ? (u32)l->v >= (u32)r.v : l->v >= r.v; u = 0; break;
    case TK_SHL: l->v = (s32)((u32)l->v << (r.v & 31)); break;
    case TK_SHR: l->v = u ? (s32)((u32)l->v >> (r.v & 31)) : l->v >> (r.v & 31); break;
    case '+': l->v = (s32)((u32)l->v + (u32)r.v); break;
    case '-': l->v = (s32)((u32)l->v - (u32)r.v); break;
    case '*': l->v = (s32)((u32)l->v * (u32)r.v); break;
    case '/': case '%':
      if (!r.v) cc_error("division by zero in #if");
      if (u) l->v = (s32)(k == '/' ? (u32)l->v / (u32)r.v : (u32)l->v % (u32)r.v);
      else if (l->v == (s32)0x80000000l && r.v == -1) l->v = k == '/' ? l->v : 0;
      else l->v = k == '/' ? l->v / r.v : l->v % r.v;
      break;
    }
    l->u = u;
  }
}
static void pp_adv(void) { pp_next(&ppt); }
static u8 pp_condition(void) { // the rest of the directive line
  u16 mark = tok_lo; Tok t; PPV v;
  for (;;) {
    directive_line(&t);
    if (t.kind == TK_NL || t.kind == TK_EOF) break;
    if (t.kind == TK_ID && t.a == NM_DEFINED) {
      u8 paren;
      directive_line(&t); paren = t.kind == '(';
      if (paren) directive_line(&t);
      if (t.kind != TK_ID) cc_error("defined needs a name");
      t.v = names[t.a].macro || t.a == NM_FILE || t.a == NM_LINE; t.kind = TK_NUM; t.flags = 0;
      if (paren) { Tok c; directive_line(&c); if (c.kind != ')') cc_error("missing ) after defined"); }
    }
    lo_add(&t);
  }
  if (tok_lo == mark) cc_error("#if needs an expression");
  src_push(mark, tok_lo, 0, 0, 1);
  pp_adv();
  pp_expr(0, &v);
  if (ppt.kind != TK_END) cc_error("extra tokens in #if");
  --nsrc; tok_lo = mark;
  return v.v != 0;
}

static void define(void) {
  Tok t, n; u16 params[32]; u8 np = 0xFF, i; Macro* m; u16 id;
  directive_line(&n);
  if (n.kind != TK_ID) cc_error("#define needs a name");
  if (C0 == '(') { // function-like: no space before the parenthesis
    directive_line(&t);
    np = 0;
    directive_line(&t);
    if (t.kind != ')') for (;;) {
      if (t.kind == TK_ELLIPSIS) cc_error("variadic macros are not supported");
      if (t.kind != TK_ID) cc_error("bad macro parameter");
      if (np == 32) cc_error("too many macro parameters");
      params[np++] = t.a;
      directive_line(&t);
      if (t.kind == ')') break;
      if (t.kind != ',') cc_error("expected , or ) in macro parameters");
      directive_line(&t);
    }
  }
  id = names[n.a].macro;
  if (!id) { if (nmacros == CC_MACROS) cc_error("too many macros"); id = nmacros++; }
  m = &macros[id];
  m->name = n.a; m->nparams = np; m->disabled = 0; m->start = tok_lo;
  lex_perm = 1;
  for (;;) {
    directive_line(&t);
    if (t.kind == TK_NL || t.kind == TK_EOF) break;
    if (t.kind == TK_ID && np != 0xFF) for (i = 0; i < np; ++i) if (params[i] == t.a) { t.kind = TK_ARG; t.a = i; break; }
    if (t.kind == '#' && np != 0xFF) cc_error("# in macros is not supported yet");
    if (t.kind == TK_HASHHASH) cc_error("## in macros is not supported yet");
    lo_add(&t);
  }
  lex_perm = 0;
  m->len = (u16)(tok_lo - m->start);
  names[n.a].macro = id;
}

static void include(void) {
  char path[128]; u8 n = 0, close, angled;
  while (C0 == ' ' || C0 == '\t') adv();
  if (C0 != '"' && C0 != '<') cc_error("#include needs \"file\" or <file>");
  angled = C0 == '<'; close = angled ? '>' : '"';
  adv();
  while (C0 != close) {
    if (C0 == '\n' || C0 < 0) cc_error("unterminated #include name");
    if (n == sizeof(path) - 1) cc_error("#include name too long");
    path[n++] = (char)C0; adv();
  }
  adv(); path[n] = 0;
  skip_line();
  in_directive = 0;
  file_push(cc_host_open(path, angled, files[nfiles - 1].handle));
}

static void directive(void) {
  Tok t; u16 d;
  in_directive = 1;
  directive_line(&t);
  if (t.kind == TK_NL) { in_directive = 0; return; } // a lone #
  if (t.kind != TK_ID) { if (skipping) { skip_line(); in_directive = 0; return; } cc_error("bad directive"); }
  d = t.a;
  if (d == KW_IF || d == NM_IFDEF || d == NM_IFNDEF) {
    u8 take;
    if (nifs == CC_IFS) cc_error("#if nested too deeply");
    if (skipping) { ifs[nifs++] = IF_DONE; skip_line(); update_skip(); in_directive = 0; return; }
    if (d == KW_IF) take = pp_condition();
    else {
      directive_line(&t);
      if (t.kind != TK_ID) cc_error("#ifdef needs a name");
      take = names[t.a].macro || t.a == NM_FILE || t.a == NM_LINE;
      if (d == NM_IFNDEF) take = !take;
      skip_line();
    }
    ifs[nifs++] = take ? IF_ACTIVE : IF_WAITING;
    update_skip(); in_directive = 0; return;
  }
  if (d == NM_ELIF || d == KW_ELSE) {
    u8* s;
    if (!nifs) cc_error(d == KW_ELSE ? "#else without #if" : "#elif without #if");
    s = &ifs[nifs - 1];
    if (*s == IF_WAITING) {
      u8 parent; --nifs; update_skip(); parent = skipping; ++nifs;
      if (!parent && (d == KW_ELSE ? (skip_line(), 1) : pp_condition())) *s = IF_ACTIVE;
      else if (d == KW_ELSE) *s = IF_DONE;
    } else { *s = IF_DONE; skip_line(); }
    update_skip(); in_directive = 0; return;
  }
  if (d == NM_ENDIF) {
    if (!nifs) cc_error("#endif without #if");
    --nifs; skip_line(); update_skip(); in_directive = 0; return;
  }
  if (skipping) { skip_line(); in_directive = 0; return; }
  if (d == NM_INCLUDE) { include(); return; }
  if (d == NM_DEFINE) define();
  else if (d == NM_UNDEF) {
    directive_line(&t);
    if (t.kind != TK_ID) cc_error("#undef needs a name");
    names[t.a].macro = 0; skip_line();
  } else if (d == NM_ERROR || d == NM_WARNING) {
    char msg[80]; u8 n = 0;
    while (C0 == ' ' || C0 == '\t') adv();
    while (C0 != '\n' && C0 >= 0) { if (n < sizeof(msg) - 1) msg[n++] = (char)C0; adv(); }
    msg[n] = 0;
    if (d == NM_ERROR) cc_error(n ? msg : "#error");
    cc_warn(n ? msg : "#warning");
  } else if (d == NM_PRAGMA) cc_error("unknown #pragma");
  else cc_error("unknown directive");
  in_directive = 0;
}

static void file_next(Tok* t) {
  for (;;) {
    lex_raw(t);
    if (t->kind == TK_EOF) {
      if (nfiles > 1) {
        cc_host_close(files[--nfiles].handle);
        lex_file = files[nfiles - 1].handle; lex_line = files[nfiles - 1].line; at_bol = 1;
        continue;
      }
      if (nifs) cc_error("#if without #endif");
      return;
    }
    if (t->kind == '#' && (t->flags & TF_BOL)) { directive(); continue; }
    if (skipping) continue;
    return;
  }
}

static void expand_call(u16 id) {
  Macro* m = &macros[id];
  u16 mark = tok_lo, astart[32], aend[32], estart[32], eend[32], depth = 0, i, rstart, rlen;
  u8 nargs = 0;
  Tok t;
  astart[0] = tok_lo;
  for (;;) {
    raw_next(&t);
    if (t.kind == TK_EOF || t.kind == TK_END) cc_error("unterminated macro call");
    if (t.kind == '(') ++depth;
    else if (t.kind == ')') { if (!depth) break; --depth; }
    else if (t.kind == ',' && !depth) {
      if (nargs == 31) cc_error("too many macro arguments");
      aend[nargs++] = tok_lo; astart[nargs] = tok_lo; continue;
    }
    lo_add(&t);
  }
  aend[nargs++] = tok_lo;
  if (m->nparams == 0 && nargs == 1 && aend[0] == astart[0]) nargs = 0;
  if (nargs != m->nparams) cc_error2("wrong number of macro arguments", m->name);
  for (i = 0; i < nargs; ++i) { // expand each argument alone
    estart[i] = tok_lo;
    src_push(astart[i], aend[i], 0, 0, 1);
    for (;;) { pp_next(&t); if (t.kind == TK_END) break; lo_add(&t); }
    --nsrc;
    eend[i] = tok_lo;
  }
  rstart = tok_lo;
  for (i = 0; i < m->len; ++i) {
    t = toks[m->start + i];
    if (t.kind == TK_ARG) { u16 j; for (j = estart[t.a]; j < eend[t.a]; ++j) lo_add(&toks[j]); }
    else lo_add(&t);
  }
  rlen = (u16)(tok_lo - rstart);
  if ((u16)(tok_hi - rlen) < tok_lo || rlen > tok_hi) cc_error("macro token space full");
  tok_hi = (u16)(tok_hi - rlen);
  for (i = 0; i < rlen; ++i) toks[tok_hi + i] = toks[rstart + i];
  tok_lo = mark;
  src_push(tok_hi, (u16)(tok_hi + rlen), (u16)(tok_hi + rlen), id, 0);
}

void pp_next(Tok* t) {
  for (;;) {
    u16 id;
    raw_next(t);
    if (t->kind != TK_ID || (t->flags & TF_NOEXPAND)) return;
    id = names[t->a].macro;
    if (!id) {
      if (t->a == NM_LINE) { t->kind = TK_NUM; t->v = lex_line; t->flags = 0; }
      else if (t->a == NM_FILE) {
        const char* s = cc_host_name(lex_file); u16 i, n = slen(s);
        t->kind = TK_STR; t->flags = 0; t->v = lit_n; t->a = n;
        for (i = 0; i < n; ++i) lit_add((u8)s[i]);
      }
      return;
    }
    if (macros[id].disabled) { t->flags |= TF_NOEXPAND; return; }
    if (macros[id].nparams == 0xFF) { src_push(macros[id].start, macros[id].start + macros[id].len, 0, id, 0); continue; }
    {
      Tok n; raw_next(&n);
      if (n.kind != '(') { pushback = n; has_pushback = 1; return; }
    }
    expand_call(id);
  }
}

void cc_define(const char* name, const char* value) {
  Tok t; u16 id, n = name_intern(name, slen(name));
  s32 v = 0; u8 neg = 0;
  id = names[n].macro;
  if (!id) id = nmacros++;
  macros[id].name = n; macros[id].nparams = 0xFF; macros[id].disabled = 0; macros[id].start = tok_lo;
  if (!value) value = "1";
  if (*value == '-') { neg = 1; ++value; }
  if (*value >= '0' && *value <= '9') {
    while (*value >= '0' && *value <= '9') v = v * 10 + (*value++ - '0');
    t.kind = TK_NUM; t.flags = 0; t.v = (u32)v;
    if (neg) { Tok m; m.kind = '-'; m.flags = 0; lo_add(&m); }
    lo_add(&t);
  } else if (*value) { t.kind = TK_ID; t.flags = 0; t.a = name_intern(value, slen(value)); lo_add(&t); }
  macros[id].len = (u16)(tok_lo - macros[id].start);
  names[n].macro = id;
}

void lex_init(void) {
  u16 i;
  for (i = 1; i < NM_FIXED; ++i) name_intern(fixed_names[i], slen(fixed_names[i]));
}
