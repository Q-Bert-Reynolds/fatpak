// CC pass A: directives and numbers.
#define CC_PAGE pre_dir
#define CC_NEED_nm_r16
#define CC_NEED_nm_w16
#include "cc_pre.h"

void lex_number(Tok* t) {
  u32 v = 0; u8 base = 10, digits = 0; s16 d;
  if (C0 == '0' && (C1 == 'x' || C1 == 'X')) { base = 16; adv(); adv(); }
  else if (C0 == '0' && (C1 == 'b' || C1 == 'B')) { base = 2; adv(); adv(); }
  else if (C0 == '0') base = 8;
  for (;; adv()) {
    d = hexval(C0);
    if (d < 0 || (base != 16 && d > 9)) break;
    if (d >= base) { if (!lex_skip) cc_error(E_BAD_DIGIT_IN_NUMBER); d = 0; }
    if (v > cc_divmod32(0xFFFFFFFFul - (u32)d, base, 0) && !lex_skip) cc_error(E_INTEGER_CONSTANT_TOO_LARGE);
    v = cc_mul32(v, base) + (u32)d; ++digits;
  }
  if (!digits && !lex_skip) cc_error(E_NUMBER_HAS_NO_DIGITS);
  t->kind = TK_NUM; t->v = v;
  if (base != 10) t->flags |= TF_RADIX;
  for (;;) {
    if (C0 == 'u' || C0 == 'U') { t->flags |= TF_UNSIGNED; adv(); }
    else if (C0 == 'l' || C0 == 'L') { if (C1 == 'l' || C1 == 'L') { if (!lex_skip) cc_error(E_LONG_LONG_IS_NOT_SUPPORTED); adv(); } t->flags |= TF_LONG; adv(); }
    else break;
  }
  if (is_id(C0) || C0 == '.') {
    if (!lex_skip) cc_error(C0 == '.' || C0 == 'e' || C0 == 'E' || C0 == 'f' ? E_FLOATING_POINT_IS_NOT_SUPPORTED : E_BAD_NUMBER_SUFFIX);
    while (is_id(C0) || C0 == '.') adv();
  }
}

void update_skip(void) { u8 i; skipping = 0; for (i = 0; i < nifs; ++i) if (ifs[i] != IF_ACTIVE) skipping = 1; lex_skip = skipping; }

void directive_line(Tok* t) { lex_raw(t); } // in_directive is set: ends with TK_NL

void skip_line(void) { Tok t; do directive_line(&t); while (t.kind != TK_NL && t.kind != TK_EOF); }

u8 pp_condition(void) { // the rest of the directive line
  u16 mark = tok_lo; Tok t; PPV v;
  for (;;) {
    directive_line(&t);
    if (t.kind == TK_NL || t.kind == TK_EOF) break;
    if (t.kind == TK_ID && t.a == NM_DEFINED) {
      u8 paren;
      directive_line(&t); paren = t.kind == '(';
      if (paren) directive_line(&t);
      if (t.kind != TK_ID) cc_error(E_DEFINED_NEEDS_A_NAME);
      t.v = MACRO_OF(t.a) || t.a == NM_FILE || t.a == NM_LINE; t.kind = TK_NUM; t.flags = 0;
      if (paren) { Tok c; directive_line(&c); if (c.kind != ')') cc_error(E_MISSING_AFTER_DEFINED); }
    }
    lo_add(&t);
  }
  if (tok_lo == mark) cc_error(E_HASH_IF_NEEDS_AN_EXPRESSION);
  src_push(mark, tok_lo, 0, 0, 1);
  pp_adv();
  pp_expr(0, &v);
  if (ppt.kind != TK_END) cc_error(E_EXTRA_TOKENS_IN_HASH_IF);
  --nsrc; tok_lo = mark;
  return v.v != 0;
}

void define(void) {
  Tok t, n; u16 params[CC_MACRO_ARGS], start; u8 np = 0xFF, i; u16 id;
  directive_line(&n);
  if (n.kind != TK_ID) cc_error(E_HASH_DEFINE_NEEDS_A_NAME);
  if (C0 == '(') { // function-like: no space before the parenthesis
    directive_line(&t);
    np = 0;
    directive_line(&t);
    if (t.kind != ')') for (;;) {
      if (t.kind == TK_ELLIPSIS) cc_error(E_VARIADIC_MACROS_ARE_NOT_SUPPORTED);
      if (t.kind != TK_ID) cc_error(E_BAD_MACRO_PARAMETER);
      if (np == CC_MACRO_ARGS) cc_error(E_TOO_MANY_MACRO_PARAMETERS);
      params[np++] = t.a;
      directive_line(&t);
      if (t.kind == ')') break;
      if (t.kind != ',') cc_error(E_EXPECTED_OR_IN_MACRO_PARAMETERS);
      directive_line(&t);
    }
  }
  id = MACRO_OF(n.a);
  if (!id) { if (nmacros == CC_MACROS) cc_error(E_TOO_MANY_MACROS); id = nmacros++; }
  start = tok_lo;
  for (;;) {
    directive_line(&t);
    if (t.kind == TK_NL || t.kind == TK_EOF) break;
    if (t.kind == TK_ID && np != 0xFF) for (i = 0; i < np; ++i) if (params[i] == t.a) { t.kind = TK_ARG; t.a = i; break; }
    if (t.kind == '#' && np != 0xFF) cc_error(E_HASH_IN_MACROS_IS_NOT_SUPPORTED_YET);
    if (t.kind == TK_HASHHASH) cc_error(E_HASH_HASH_IN_MACROS_IS_NOT_SUPPORTED_Y);
    lo_add(&t);
  }
  mc_w16(id, MC_NAME, n.a); mc_w16(id, MC_START, start); mc_w16(id, MC_LEN, (u16)(tok_lo - start));
  mc_w8(id, MC_NPARAMS, np); mc_w8(id, MC_DISABLED, 0);
  SET_MACRO_OF(n.a, id);
}

void include(void) {
  static char path[128]; u8 n = 0, close, angled; // (static: the OS stack is small)
  while (C0 == ' ' || C0 == '\t') adv();
  if (C0 != '"' && C0 != '<') cc_error(E_HASH_INCLUDE_NEEDS_FILE_OR_FILE);
  angled = C0 == '<'; close = angled ? '>' : '"';
  adv();
  while (C0 != close) {
    if (C0 == '\n' || C0 < 0) cc_error(E_UNTERMINATED_HASH_INCLUDE_NAME);
    if (n == sizeof(path) - 1) cc_error(E_HASH_INCLUDE_NAME_TOO_LONG);
    path[n++] = (char)C0; adv();
  }
  adv(); path[n] = 0;
  skip_line();
  in_directive = 0;
  file_push(cc_host_open(path, angled, files[nfiles - 1].handle));
}

void directive(void) {
  Tok t; u16 d;
  in_directive = 1;
  directive_line(&t);
  if (t.kind == TK_NL) { in_directive = 0; return; } // a lone #
  if (t.kind != TK_ID) { if (skipping) { skip_line(); in_directive = 0; return; } cc_error(E_BAD_DIRECTIVE); }
  d = t.a;
  if (d == KW_IF || d == NM_IFDEF || d == NM_IFNDEF) {
    u8 take;
    if (nifs == CC_IFS) cc_error(E_HASH_IF_NESTED_TOO_DEEPLY);
    if (skipping) { ifs[nifs++] = IF_DONE; skip_line(); update_skip(); in_directive = 0; return; }
    if (d == KW_IF) take = pp_condition();
    else {
      directive_line(&t);
      if (t.kind != TK_ID) cc_error(E_HASH_IFDEF_NEEDS_A_NAME);
      take = MACRO_OF(t.a) || t.a == NM_FILE || t.a == NM_LINE;
      if (d == NM_IFNDEF) take = !take;
      skip_line();
    }
    ifs[nifs++] = take ? IF_ACTIVE : IF_WAITING;
    update_skip(); in_directive = 0; return;
  }
  if (d == NM_ELIF || d == KW_ELSE) {
    u8* s;
    if (!nifs) cc_error(d == KW_ELSE ? E_HASH_ELSE_WITHOUT_HASH_IF : E_HASH_ELIF_WITHOUT_HASH_IF);
    s = &ifs[nifs - 1];
    if (*s == IF_WAITING) {
      u8 parent; --nifs; update_skip(); parent = skipping; ++nifs;
      if (!parent && (d == KW_ELSE ? (skip_line(), 1) : pp_condition())) *s = IF_ACTIVE;
      else if (d == KW_ELSE) *s = IF_DONE;
    } else { *s = IF_DONE; skip_line(); }
    update_skip(); in_directive = 0; return;
  }
  if (d == NM_ENDIF) {
    if (!nifs) cc_error(E_HASH_ENDIF_WITHOUT_HASH_IF);
    --nifs; skip_line(); update_skip(); in_directive = 0; return;
  }
  if (skipping) { skip_line(); in_directive = 0; return; }
  if (d == NM_INCLUDE) { include(); return; }
  if (d == NM_DEFINE) define();
  else if (d == NM_UNDEF) {
    directive_line(&t);
    if (t.kind != TK_ID) cc_error(E_HASH_UNDEF_NEEDS_A_NAME);
    SET_MACRO_OF(t.a, 0); skip_line();
  } else if (d == NM_ERROR || d == NM_WARNING) {
    char msg[80]; u8 n = 0;
    while (C0 == ' ' || C0 == '\t') adv();
    while (C0 != '\n' && C0 >= 0) { if (n < sizeof(msg) - 1) msg[n++] = (char)C0; adv(); }
    msg[n] = 0;
    if (d == NM_ERROR) cc_error_text(E_HASH_ERROR_TEXT, msg);
    cc_diag_text(E_HASH_WARNING_TEXT, msg);
  } else if (d == NM_PRAGMA) cc_error(E_UNKNOWN_HASH_PRAGMA);
  else cc_error(E_UNKNOWN_DIRECTIVE);
  in_directive = 0;
}

void file_next(Tok* t) {
  for (;;) {
    lex_raw(t);
    if (t->kind == TK_EOF) {
      if (nfiles > 1) {
        cc_host_close(files[--nfiles].handle);
        cc_file = files[nfiles - 1].handle; cc_line = files[nfiles - 1].line; at_bol = 1;
        continue;
      }
      if (nifs) cc_error(E_HASH_IF_WITHOUT_HASH_ENDIF);
      return;
    }
    if (t->kind == '#' && (t->flags & TF_BOL)) { directive(); continue; }
    if (skipping) continue;
    return;
  }
}
