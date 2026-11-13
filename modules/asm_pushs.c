// ASM.MOD: PUSHS and POPS (asm_sect.c has the sections; this is on another page for room)
#include "asm_shared.h"

unsigned char sect_depth;
static unsigned int stack[8], stack_scope[8]; // the section (NO_SECT: none) and label scope

// PUSHS [section]: the open section and label scope wait for POPS
void PushS(void) {
  if (sect_depth == sizeof(stack) / sizeof(stack[0])) { Fail(ASM_ERR_NESTING); return; }
  stack[sect_depth] = in_section ? cur : NO_SECT;
  stack_scope[sect_depth++] = scope;
  CloseSection();
  scope = 0;
  Space();
  if (!AtEnd()) Section();
}
void PopS(void) {
  if (!sect_depth) { Fail(ASM_ERR_SYNTAX); return; }
  CloseSection();
  scope = stack_scope[--sect_depth];
  if ((cur = stack[sect_depth]) != NO_SECT) {
    SectCopy(cur, 0);
    Enter();
  }
}
