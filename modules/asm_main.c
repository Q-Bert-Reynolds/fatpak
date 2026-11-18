// ASM.MOD: the build and the result (ModuleMain in asm.c calls Main), in whichever page has
// room. See asm_shared.h; LINK.MOD runs next with what this leaves (asm_obj.h).
#include "asm_shared.h"

// rgbasm's version symbols: this assembles what RGBDS 1.0 does, where it does
// (named arrays, not literals: SDCC's ___str_n names would clash with asm_str.c's on this page)
static const char version_major[] = "__RGBDS_MAJOR__", version_minor[] = "__RGBDS_MINOR__", version_patch[] = "__RGBDS_PATCH__";
static void Builtin(const char* word, unsigned int value) {
  for (ident_len = 0; (ident[ident_len] = word[ident_len]) != 0; ++ident_len);
  Add(SYM_EQU | SYM_SEEN, value, 0); // defined before both passes
}
// where an error or a patch is reported: an error in a macro body is reported at its invocation
// (whose line feed was already counted), one in a repeat at the body line; expansions of string
// symbols and {} report the line they're on
void PushId(void) { // \@: _u and the innermost macro or repeat's number
  Frame* m = &frames[depth];
  unsigned int id;
  unsigned char i = 7;
  while (m > frames && m->kind != F_MACRO && m->kind != F_REPT) --m;
  id = m->id;
  idtext[i] = 0;
  do { id = (unsigned int)Div(id, 10); idtext[--i] = '0' + (unsigned char)div_rem; } while (id); // no SDCC helpers
  idtext[--i] = 'u';
  idtext[--i] = '_';
  Push(F_ARG, SRC_ID, i, 7);
}
unsigned int where_file, where_line, where_pos;
void Where(void) {
  Frame* f;
  unsigned char i = 0;
  for (f = &frames[depth]; f > frames && (f->kind == F_MACRO || f->kind == F_ARG || f->file == FILE_EXPANSION); --f)
    if (f->kind == F_MACRO) i = 1;
  where_file = f->file;
  where_line = f->line - i;
  where_pos = (unsigned int)(f->file ? frames[0].line_pos : f->line_pos);
}
// where the error is: its file's symbol and name, line and the document position
void Report(unsigned int file, unsigned int line, unsigned int pos) {
  AsmContext* c = context;
  unsigned char *e, n, i, from = 0;
  c->file = file;
  c->line = line;
  c->pos = pos;
  c->base = 0;
  if (!file) return;
  e = Entry(file);
  n = e[10];
  if (n > sizeof(c->name) - 1) from = n - (sizeof(c->name) - 1); // the path's end
  for (i = 0; from < n; ++i) {
    if ((c->name[i] = e[11 + from++]) == '/') c->base = i + 1;
  }
  c->name[i] = 0;
}
void ReportWhere(void) {
  Where();
  Report(where_file, where_line, where_pos);
}
AsmLink asm_link; // what LINK.MOD gets, fix (project.gbp's rgbfix options) included
AsmPrep prep;
unsigned int files_end;
unsigned char Main(void) {
  unsigned int i;
  unsigned char *h, *s;
  Frame* f;
  context->symbols = 0;
  context->log_bytes = context->cache_blocks = 0;
  cache_n = 0xFFFF; // none until CacheStart
  cache_files = files_read = 0;
  card_frames[0] = card_frames[1] = card_frames[2] = card_frames[3] = 0;
  for (i = 0; i < 1024; ++i) { // the names' and the files' hash heads
    Window(ASM_SYMBOL_BLOCK + (i >> 9));
    WINDOW[i & 511] = 0;
  }
  next_unit = 128; // after them (unit 0 means "none")
  file_next = FILE_UNITS;
  heap_top = 0;
  file_top = ASM_FILE_BLOCK;
  files_end = ASM_FILE_END;
  for (h = (unsigned char*)&prep, i = 0; i < sizeof(AsmPrep); ++i) *h++ = 0;
  if (context->kind & ASM_OLD) { // LINK.MOD's check: unchanged units, and build.obj above the files
    Window(ASM_PREP_BLOCK);
    for (h = (unsigned char*)&prep, s = WINDOW, i = 0; i < sizeof(AsmPrep); ++i) *h++ = *s++;
    files_end = ASM_OLD_BLOCK;
  }
  asm_link.assembled = 0;
  data_top = ASM_DATA_BLOCK;
  out_block = ASM_OBJ_BLOCK;
  out_ofs = 0;
  out_end = ASM_FILE_BLOCK;
  patches = lines_read = 0;
  Builtin(version_major, 1);
  Builtin(version_minor, 0);
  Builtin(version_patch, 1);
  nsects = 0;
  nunits = 0;
  prelude = 0;
  fix.given = fix.title_n = fix.licensee_n = fix.id_n = 0;
  output[0] = 0;
  if (Project()) context->kind |= ASM_PROJECT;
  else if (!(context->kind & ASM_DOC)) return ASM_NOT_ASM;
  if (!error) Assemble();
  if (!error && !rom_used) Fail(ASM_ERR_EMPTY);
  if (error) ReportWhere();
  CacheEnd();
  f = TextFrame();
  asm_link.error = error;
  asm_link.error_ch = error_ch;
  asm_link.macro_line = error && f->kind == F_MACRO ? f->line : 0; // the log says where in the body
  asm_link.nsects = nsects;
  asm_link.units = nunits;
  asm_link.patches = patches;
  asm_link.lines = lines_read;
  asm_link.seconds = (unsigned int)ModStat(MODULE_STAT_SECONDS);
  asm_link.card_frames = *(unsigned long*)card_frames;
  asm_link.files_read = files_read;
  asm_link.cache_files = cache_files;
  asm_link.retries = (unsigned int)ModStat(MODULE_STAT_RETRIES);
  asm_link.project = nunits != 0;
  asm_link.data_end = data_top;
  Window(ASM_LINK_BLOCK);
  for (h = WINDOW, s = (unsigned char*)&asm_link, i = 0; i < sizeof(AsmLink); ++i) *h++ = *s++;
  if (!error && nunits) for (i = 0; (context->name[i] = output[i]) != 0; ++i);
  return error;
}
