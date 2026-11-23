// Pass A on the Game Boy (CCA.MOD): ModuleMain, and the host functions through the module ABI.
// The document comes from the text buffer (ModSource); each #include is loaded whole into
// PSRAM (ModLoad, which looks in the document's folder, then the folders above it), a slot
// of 64 KiB per nesting level from CC_INCLUDE_BLOCK; <name> is GBCSYS/CC/include/name.
#define CC_PAGE dev_pre
#include "cc_acc.h"

#define DEV_FILES 32 // handles: 0 the document, then each #include, in order
static u8 next_handle, open_n, slot_of[DEV_FILES], unit_loaded; // unit_loaded: file 0 is a project's C unit, from the card
static u16 size_of_file[DEV_FILES];
static char name_buf[64];

static void set_name(const char* s) { u8 i; for (i = 0; i < sizeof(name_buf) - 1 && s[i]; ++i) name_buf[i] = s[i]; name_buf[i] = 0; }
// path = the folder of file from's path (as file_push recorded it) and name, ../ and ./ folded: a
// "name" include is beside the file that includes it (a project's unit includes "../x.h" from
// src/baseball/); ModLoad then finds it from the project's folder. Its length.
static char path[96]; // (static: ModLoad runs FatFs on the same small stack)
static u8 beside(u8 from, const char* name) {
  const u8* r = cc_at(CC_FILENAME_BLOCK, from, 6);
  u8 n = 0, i;
  for (i = 0; i < 63 && r[i]; ++i) if ((path[i] = (char)r[i]) == '/') n = i + 1;
  for (;;) {
    if (name[0] == '.' && name[1] == '/') name += 2;
    else if (name[0] == '.' && name[1] == '.' && name[2] == '/' && n) {
      name += 3;
      for (--n; n && path[n - 1] != '/'; --n);
    }
    else break;
  }
  for (i = 0; name[i] && n < sizeof(path) - 1; ++i) path[n++] = name[i];
  path[n] = 0;
  return n;
}
u8 cc_host_open(const char* name, u8 angled, u8 from) {
  static const char system[] = "GBCSYS/CC/include/";
  ModuleLoad load;
  u8 n = 0, i, h;
  if (from == 0xFF) { // the document (the host knows its name), or a project's C unit
    name_buf[0] = 0; next_handle = 1;
    if (!cc_ctx->source) return 0;
    name = cc_ctx->source; angled = 0; next_handle = 0; unit_loaded = 1;
  }
  if (next_handle == DEV_FILES || open_n == CC_FILES - 1) return 0xFF;
  load.block = (u16)(CC_INCLUDE_BLOCK + open_n * 128);
  load.blocks = 128;
  if (!angled && from != 0xFF && beside(from, name) && !cc_load_os(path, &load)) goto opened;
  if (angled) for (i = 0; system[i]; ++i) path[n++] = system[i];
  for (i = 0; name[i] && n < sizeof(path) - 1; ++i) path[n++] = name[i];
  path[n] = 0;
  if (cc_load_os(path, &load)) return 0xFF;
opened:
  h = next_handle++;
  slot_of[h] = open_n++;
  size_of_file[h] = load.size > 0xFFFF ? 0xFFFF : (u16)load.size;
  set_name(path);
  return h;
}
u16 cc_host_read(u8 file, u32 pos, char* dest, u16 n) {
  u16 size;
  if (!file && !unit_loaded) return ModSource((u16)pos, dest); // up to 128 bytes, the buffer's size
  size = size_of_file[file];
  if (pos >= size) return 0;
  if (n > size - (u16)pos) n = (u16)(size - (u16)pos);
  m_get((u16)(CC_INCLUDE_BLOCK + slot_of[file] * 128 + ((u16)pos >> 9)), (u16)pos & 511, dest, n);
  return n;
}
void cc_host_close(u8 file) { if (file) --open_n; }
const char* cc_host_name(u8 file) { (void)file; return name_buf; } // asked right after opening
void cc_host_diag(u8 error, const char* file, u16 line, u8 code, const char* extra) { (void)error; (void)file; (void)line; (void)code; (void)extra; } // the host reads cc_st

// The pass runs on its own stack, in its BSS: the OS's 1 KiB also holds the host's frames,
// and the compiler's recursion (and FatFs under ModLoad) needed more. Host calls that may hold
// the BSS elsewhere (ModLoad draws ModProgress) switch back to the OS's stack; ModAbort does.
#define CC_STACK 1792
u8 cc_stack[CC_STACK];
u16 cc_os_sp;
static unsigned char pass_main(CcContext* context);
unsigned char ModuleMain(CcContext* context) __naked {
  context;
  __asm
    ld hl, sp + 0           ;// the OS's stack, for ModLoad and the return
    ld a, l
    ld [_cc_os_sp], a
    ld a, h
    ld [_cc_os_sp + 1], a
    ld hl, _cc_stack + 1792
    ld sp, hl
    call _pass_main         ;// de: the context, still
    ld e, a                 ;// the result
    ld hl, _cc_os_sp
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    ld sp, hl
    ld a, e
    ret
  __endasm;
}
static unsigned char pass_main(CcContext* context) {
  // the unit's prefix: the document's name up to its dot, as letters, digits and _
  char unit[24];
  const char* s = context->name;
  u8 n = 0;
  cc_ctx = context;
  for (; *s && *s != '.' && n < sizeof(unit) - 1; ++s)
    unit[n++] = (*s >= 'a' && *s <= 'z') || (*s >= 'A' && *s <= 'Z') || (*s >= '0' && *s <= '9') ? *s : '_';
  unit[n] = 0;
  cc_pass_a_init();
  if (cc_pass_a(context->source ? context->source : "", unit, context->source ? CC_SDCC : CC_WRAP)) return cc_st.status;
  cc_chain(MODULE_CCB);
  return 0;
}
