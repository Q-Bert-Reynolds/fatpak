// Pass B on the Game Boy (CCB.MOD): ModuleMain. Everything it needs is in PSRAM.
#define CC_PAGE dev_parse
#include "cc_acc.h"

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
  cc_ctx = context;
  if (cc_pass_b()) return cc_st.status;
  cc_chain(MODULE_CCC);
  return 0;
}
