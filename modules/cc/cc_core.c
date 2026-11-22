// What every CC pass links (each module its own copy): the state handed from pass to pass,
// scratch records, byte ranges in PSRAM, names, literal bytes and diagnostics.
#define CC_PAGE core
#define CC_NEED_nm_r16
#define CC_NEED_nm_w16
#include "cc_acc.h"

CcState cc_st;
#ifdef CC_HOST
jmp_buf cc_fail;
#define CC_FAIL() longjmp(cc_fail, 1)
#else
#define CC_FAIL() (cc_state_save(), cc_chain(MODULE_CCERR), ModAbort(cc_st.status))
CcContext* cc_ctx;
// the module the host runs next (0: none): CCB, CCC or CCERR, by ID and path
void cc_chain(u8 id) {
  static const char base[] = "/GBCSYS/MODULES/CC";
  char* p = cc_ctx->path;
  u8 i;
  cc_ctx->next = id;
  for (i = 0; base[i]; ++i) *p++ = base[i];
  if (id == MODULE_CCERR) { *p++ = 'E'; *p++ = 'R'; *p++ = 'R'; }
  else *p++ = id == MODULE_CCB ? 'B' : 'C';
  *p++ = '.'; *p++ = 'M'; *p++ = 'O'; *p++ = 'D'; *p = 0;
}
#endif
u16 cc_line;
u8 cc_file;

typedef char cc_sym_fits[sizeof(Sym) <= 16 ? 1 : -1]; // SDCC packs records; the PC may pad, but no more than this
typedef char cc_type_fits[sizeof(Type) <= 16 ? 1 : -1];
typedef char cc_field_fits[sizeof(Field) <= 8 ? 1 : -1];
typedef char cc_node_fits[sizeof(Node) <= 16 ? 1 : -1];
typedef char cc_state_fits[sizeof(CcState) <= 512 ? 1 : -1];

u16 rec_r16(u16 base, u16 i, u8 off) { return rd16(cc_at(base, i, 3) + off); }
void rec_w16(u16 base, u16 i, u8 off, u16 v) { wr16(cc_at(base, i, 3) + off, v); }
// n bytes at (block, offset), across blocks
void m_get(u16 block, u16 off, void* dest, u16 n) {
  u8* d = (u8*)dest;
  while (n--) {
    if (off == 512) { ++block; off = 0; }
    cc_sel(block);
    *d++ = cc_win[off++];
  }
}
void m_put(u16 block, u16 off, const void* src, u16 n) {
  const u8* s = (const u8*)src;
  while (n--) {
    if (off == 512) { ++block; off = 0; }
    cc_sel(block);
    cc_win[off++] = *s++;
  }
}
void cc_state_load(void) { m_get(CC_STATE_BLOCK, 0, &cc_st, sizeof(cc_st)); }
void cc_state_save(void) { m_put(CC_STATE_BLOCK, 0, &cc_st, sizeof(cc_st)); }

// a token copy without memcpy (which SDCC calls for a struct assignment, and a module can't link)
void tok_copy(Tok* d, const Tok* s) { d->kind = s->kind; d->flags = s->flags; d->a = s->a; d->v = s->v; d->line = s->line; d->file = s->file; }

// ---- names (cc_lex.c interns them) ----
u8 name_copy(u16 id, char* buf) {
  u8* r = cc_at(CC_NAME_BLOCK, id, 6);
  u8 n = r[NM_LEN], i;
  for (i = 0; i < n; ++i) buf[i] = (char)r[NM_TEXT + i];
  buf[n] = 0;
  return n;
}
u16 name_sym(u16 id) { return nm_r16(id, NM_SYM); }
void name_set_sym(u16 id, u16 sym) { nm_w16(id, NM_SYM, sym); }
u16 name_tag(u16 id) { return nm_r16(id, NM_TAG); }
void name_set_tag(u16 id, u16 sym) { nm_w16(id, NM_TAG, sym); }

// ---- string literal bytes (cc_lex.c's heap) ----
u8 lit_byte(const Tok* t, u16 i) {
  u32 o = t->v + i;
  cc_sel((u16)(CC_HEAP_BLOCK + (u16)(o >> 9)));
  return cc_win[(u16)o & 511];
}

// ---- diagnostics: the first error goes to cc_st for the Game Boy's host, and every one to
// cc_host_diag (the PC's harness prints it) ----
static void file_name(u8 file, char* buf) { // 64 bytes
  u8* r = cc_at(CC_FILENAME_BLOCK, file, 6);
  u8 i;
  for (i = 0; i < 63 && r[i]; ++i) buf[i] = (char)r[i];
  buf[i] = 0;
}
static void diag(u8 error, u8 code, const char* extra) {
  char name[64];
  u8 i;
  file_name(cc_file, name);
  cc_host_diag(error, name, cc_line, code, extra);
  if (!error || cc_st.status) return;
  cc_st.status = code; cc_st.err_file = cc_file; cc_st.err_line = cc_line;
  for (i = 0; extra && extra[i] && i < sizeof(cc_st.err_extra) - 1; ++i) cc_st.err_extra[i] = extra[i];
  cc_st.err_extra[i] = 0;
}
void cc_error(u8 code) { diag(1, code, 0); CC_FAIL(); }
void cc_error2(u8 code, u16 name) { char buf[CC_NAME_MAX + 1]; name_copy(name, buf); diag(1, code, buf); CC_FAIL(); }
void cc_error_text(u8 code, const char* text) { diag(1, code, text); CC_FAIL(); }
void cc_diag_text(u8 code, const char* text) { diag(0, code, text); }
void cc_warn(u8 code) { diag(0, code, 0); }

