// Pass C on the Game Boy (CCC.MOD): ModuleMain. Everything it needs is in PSRAM; after it, ASM.MOD
// assembles the unit's assembly as its document: this fills in the AsmContext the host's
// CcContext shares storage with.
#define CC_PAGE dev_gen
#include "cc_acc.h"
#include "../assembler/asm.h"

void cc_host_diag(u8 error, const char* file, u16 line, u8 code, const char* extra) { (void)error; (void)file; (void)line; (void)code; (void)extra; } // the host reads cc_st

// The pass runs on its own stack, in its BSS: the OS's 1 KiB also holds the host's frames,
// and the compiler's recursion (and FatFs under ModLoad) needed more. Host calls that may hold
// the BSS elsewhere (ModLoad draws ModProgress) switch back to the OS's stack; ModAbort does.
#define CC_STACK 2560
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
    ld hl, _cc_stack + 2560
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
  AsmContext* a = (AsmContext*)context;
  cc_ctx = context;
  if (cc_pass_c()) return cc_st.status;
  a->length = 0; // CcContext's next: nothing more to compile
  a->kind = ASM_DOC | ASM_TEXT;
  a->text_block = CC_OUT_BLOCK;
  a->text_length = cc_st.out_n;
  a->log_bytes = a->cache_blocks = a->obj_blocks = 0;
  return 0;
}

