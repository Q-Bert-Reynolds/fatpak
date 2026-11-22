// CC pass A, page 1: the pass, macro expansion and names.
#define CC_PAGE pre_main
#define CC_NEED_nm_r16
#define CC_NEED_nm_w16
#include "cc_pre.h"

// the pass's variables (declared in the header)
u16 nnames;
u8 lex_skip; // skipping text: no literals kept
char fbuf[128];
File files[CC_FILES];
u8 nfiles;
u8 at_bol, in_directive;
u16 tok_lo, tok_hi;
u16 nmacros;
Src srcs[CC_EXPAND];
u8 nsrc;
Tok pushback;
u8 has_pushback;
u8 ifs[CC_IFS], nifs, skipping;
Tok ppt;

static const char* const fixed_names[] = {
  "", "void", "char", "short", "int", "long", "signed", "unsigned", "_Bool", "const", "volatile",
  "static", "extern", "typedef", "auto", "register", "inline", "struct", "union", "enum", "if",
  "else", "while", "do", "for", "break", "continue", "return", "switch", "case", "default", "goto",
  "sizeof", "restrict", "float", "double",
  // preprocessor names, from KW_COUNT
  "defined", "__FILE__", "__LINE__", "include", "define", "undef", "ifdef", "ifndef", "elif",
  "endif", "error", "warning", "pragma", "line", "__VA_ARGS__"
};

u8 same(const char* a, const char* b, u16 n) { while (n--) if (*a++ != *b++) return 0; return 1; }

u16 slen(const char* s) { u16 n = 0; while (s[n]) ++n; return n; }

u16 name_intern(const char* s, u16 n) {
  u16 h = 5381, i, id;
  u8* r;
  for (i = 0; i < n; ++i) h = (u16)((h << 5) + h + (u8)s[i]);
  if (n > CC_NAME_MAX) cc_error(E_NAME_TOO_LONG);
  h &= CC_NAME_HEADS - 1;
  for (id = rd16(cc_at(CC_NAMEHEAD_BLOCK, h, 1)); id; id = rd16(r + NM_NEXT)) {
    r = cc_at(CC_NAME_BLOCK, id, 6);
    if (r[NM_LEN] == n && same((const char*)r + NM_TEXT, s, n)) return id;
  }
  if (nnames == CC_NAMES) cc_error(E_TOO_MANY_NAMES);
  r = cc_at(CC_NAMEHEAD_BLOCK, h, 1);
  id = rd16(r);
  wr16(r, nnames);
  r = cc_at(CC_NAME_BLOCK, nnames, 6);
  r[NM_LEN] = (u8)n; r[1] = 0;
  wr16(r + NM_MACRO, 0); wr16(r + NM_NEXT, id); wr16(r + NM_SYM, 0); wr16(r + NM_TAG, 0);
  for (i = 0; i < n; ++i) r[NM_TEXT + i] = (u8)s[i];
  return nnames++;
}

void tok_get(u16 i, Tok* t) {
  u8* r = cc_at(CC_TOK_BLOCK, i, 3);
  t->kind = r[0]; t->flags = r[1]; t->a = rd16(r + 2);
  t->v = (u32)rd16(r + 4) | (u32)rd16(r + 6) << 16;
}

void tok_put(u16 i, const Tok* t) {
  u8* r = cc_at(CC_TOK_BLOCK, i, 3);
  r[0] = t->kind; r[1] = t->flags; wr16(r + 2, t->a);
  wr16(r + 4, (u16)t->v); wr16(r + 6, (u16)(t->v >> 16));
}

u16 mc_r16(u16 m, u8 off) { return rd16(cc_at(CC_MACRO_BLOCK, m, 3) + off); }

void mc_w16(u16 m, u8 off, u16 v) { wr16(cc_at(CC_MACRO_BLOCK, m, 3) + off, v); }

u8 mc_r8(u16 m, u8 off) { return cc_at(CC_MACRO_BLOCK, m, 3)[off]; }

void mc_w8(u16 m, u8 off, u8 v) { cc_at(CC_MACRO_BLOCK, m, 3)[off] = v; }

void lo_add(const Tok* t) {
  if (tok_lo >= tok_hi) cc_error(E_MACRO_TOKEN_SPACE_FULL);
  tok_put(tok_lo++, t);
}

void src_push(u16 pos, u16 end, u16 free_to, u16 macro, u8 barrier) {
  Src* s;
  if (nsrc == CC_EXPAND) cc_error(E_MACROS_NESTED_TOO_DEEPLY);
  s = &srcs[nsrc++];
  s->pos = pos; s->end = end; s->free_to = free_to; s->macro = macro; s->barrier = barrier;
  if (macro) mc_w8(macro, MC_DISABLED, 1);
}

void raw_next(Tok* t) {
  if (has_pushback) { tok_copy(t, &pushback); has_pushback = 0; return; }
  while (nsrc) {
    Src* s = &srcs[nsrc - 1];
    if (s->pos < s->end) { tok_get(s->pos++, t); t->line = cc_line; t->file = cc_file; return; }
    if (s->barrier) { t->kind = TK_END; t->flags = 0; return; }
    if (s->macro) mc_w8(s->macro, MC_DISABLED, 0);
    if (s->free_to) tok_hi = s->free_to;
    --nsrc;
  }
  file_next(t);
}

void expand_call(u16 id) {
  u16 mstart = mc_r16(id, MC_START), mlen = mc_r16(id, MC_LEN); u8 np = mc_r8(id, MC_NPARAMS);
  u16 mark = tok_lo, astart[CC_MACRO_ARGS], aend[CC_MACRO_ARGS], estart[CC_MACRO_ARGS], eend[CC_MACRO_ARGS], depth = 0, i, rstart, rlen;
  u8 nargs = 0;
  Tok t;
  astart[0] = tok_lo;
  for (;;) {
    raw_next(&t);
    if (t.kind == TK_EOF || t.kind == TK_END) cc_error(E_UNTERMINATED_MACRO_CALL);
    if (t.kind == '(') ++depth;
    else if (t.kind == ')') { if (!depth) break; --depth; }
    else if (t.kind == ',' && !depth) {
      if (nargs == CC_MACRO_ARGS - 1) cc_error(E_TOO_MANY_MACRO_ARGUMENTS);
      aend[nargs++] = tok_lo; astart[nargs] = tok_lo; continue;
    }
    lo_add(&t);
  }
  aend[nargs++] = tok_lo;
  if (np == 0 && nargs == 1 && aend[0] == astart[0]) nargs = 0;
  if (nargs != np) cc_error2(E_WRONG_NUMBER_OF_MACRO_ARGUMENTS, mc_r16(id, MC_NAME));
  for (i = 0; i < nargs; ++i) { // expand each argument alone
    estart[i] = tok_lo;
    src_push(astart[i], aend[i], 0, 0, 1);
    for (;;) { pp_next(&t); if (t.kind == TK_END) break; lo_add(&t); }
    --nsrc;
    eend[i] = tok_lo;
  }
  rstart = tok_lo;
  for (i = 0; i < mlen; ++i) {
    tok_get(mstart + i, &t);
    if (t.kind == TK_ARG) { u16 j, e = eend[t.a]; for (j = estart[t.a]; j < e; ++j) { tok_get(j, &t); lo_add(&t); } }
    else lo_add(&t);
  }
  rlen = (u16)(tok_lo - rstart);
  if ((u16)(tok_hi - rlen) < tok_lo || rlen > tok_hi) cc_error(E_MACRO_TOKEN_SPACE_FULL);
  tok_hi = (u16)(tok_hi - rlen);
  for (i = 0; i < rlen; ++i) { tok_get(rstart + i, &t); tok_put(tok_hi + i, &t); }
  tok_lo = mark;
  src_push(tok_hi, (u16)(tok_hi + rlen), (u16)(tok_hi + rlen), id, 0);
}

void pp_next(Tok* t) {
  for (;;) {
    u16 id;
    raw_next(t);
    if (t->kind != TK_ID || (t->flags & TF_NOEXPAND)) return;
    id = MACRO_OF(t->a);
    if (!id) {
      if (t->a == NM_LINE) { t->kind = TK_NUM; t->v = cc_line; t->flags = 0; }
      else if (t->a == NM_FILE) {
        const char* s = cc_host_name(cc_file); u16 i, n = slen(s);
        t->kind = TK_STR; t->flags = 0; t->v = heap_n; t->a = n;
        for (i = 0; i < n; ++i) lit_add((u8)s[i]);
      }
      return;
    }
    if (mc_r8(id, MC_DISABLED)) { t->flags |= TF_NOEXPAND; return; }
    if (mc_r8(id, MC_NPARAMS) == 0xFF) { u16 st = mc_r16(id, MC_START); src_push(st, st + mc_r16(id, MC_LEN), 0, id, 0); continue; }
    {
      Tok n; raw_next(&n);
      if (n.kind != '(') { tok_copy(&pushback, &n); has_pushback = 1; return; }
    }
    expand_call(id);
  }
}

void cc_define(const char* name, const char* value) {
  Tok t; u16 id, n = name_intern(name, slen(name));
  s32 v = 0; u8 neg = 0;
  u16 start = tok_lo;
  id = MACRO_OF(n);
  if (!id) id = nmacros++;
  if (!value) value = "1";
  if (*value == '-') { neg = 1; ++value; }
  if (*value >= '0' && *value <= '9') {
    while (*value >= '0' && *value <= '9') v = (v << 3) + (v << 1) + (*value++ - '0');
    t.kind = TK_NUM; t.flags = 0; t.v = (u32)v;
    if (neg) { Tok m; m.kind = '-'; m.flags = 0; lo_add(&m); }
    lo_add(&t);
  } else if (*value) { t.kind = TK_ID; t.flags = 0; t.a = name_intern(value, slen(value)); lo_add(&t); }
  mc_w16(id, MC_NAME, n); mc_w16(id, MC_START, start); mc_w16(id, MC_LEN, (u16)(tok_lo - start));
  mc_w8(id, MC_NPARAMS, 0xFF); mc_w8(id, MC_DISABLED, 0);
  SET_MACRO_OF(n, id);
}

void cc_pass_a_init(void) {
  u16 i;
  nnames = 1; nmacros = 1; tok_hi = CC_TOKENS; // no initialized data in a module
  for (i = 0; i < CC_NAME_HEADS; ++i) { u8* r = cc_at(CC_NAMEHEAD_BLOCK, i, 1); r[0] = r[1] = 0; }
  for (i = 1; i < NM_FIXED; ++i) name_intern(fixed_names[i], slen(fixed_names[i]));
}

// ---- pass A: the token stream, with a TK_LINE before a token on another line or in another file ----

void stream_put(const Tok* t) {
  u8* r;
  if (cc_st.nstream == CC_STREAM_MAX) cc_error(E_OUTPUT_TOO_LARGE);
  r = cc_at(CC_STREAM_BLOCK, cc_st.nstream++, 3);
  r[0] = t->kind; r[1] = t->flags; r[2] = (u8)t->a; r[3] = (u8)(t->a >> 8);
  r[4] = (u8)t->v; r[5] = (u8)(t->v >> 8); r[6] = (u8)(t->v >> 16); r[7] = (u8)(t->v >> 24);
}

void stream_all(void) { // after setjmp: its locals may live in registers
  Tok t, mark;
  u16 line = 0; u8 file = 0xFF;
  do {
    pp_next(&t);
    if (t.line != line || t.file != file) {
      line = t.line; file = t.file;
      mark.kind = TK_LINE; mark.flags = 0; mark.a = line; mark.v = file;
      stream_put(&mark);
    }
    if (t.kind != TK_EOF) stream_put(&t);
  } while (t.kind != TK_EOF);
}

u8 cc_pass_a(const char* path, const char* unit, u8 flags) {
  u8 i;
  u32 heap = heap_n; // cc_define's literals
  for (i = 0; i < sizeof(cc_st); ++i) ((u8*)&cc_st)[i] = 0;
  heap_n = heap;
  for (i = 0; unit[i] && i < sizeof(cc_st.unit) - 1; ++i) cc_st.unit[i] = unit[i];
  cc_st.next_label = 1;
  cc_st.flags = flags;
  CC_CATCH();
  file_push(cc_host_open(path, 0, 0xFF));
  stream_all();
  cc_st.nnames = nnames;
  cc_state_save();
  return 0;
}
