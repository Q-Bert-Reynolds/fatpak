#ifndef FATPAK_KEYBOARD_KEYBOARD_H
#define FATPAK_KEYBOARD_KEYBOARD_H

#include "../constants.h"

extern unsigned char KBPeekKey(void); // next event's key without popping it (KEY_NONE if empty)
extern unsigned int KBPopEvent(void); // key in low byte (KEY_NONE if empty), modifiers in high byte
extern void KBListen(void); // keep the selected driver listening (diagnostics never switches drivers)
extern unsigned char kb_driver; // saved selection: none, PS/2, iGKB, SNES mouse (4); legacy mouse choice 3 maps to iGKB
extern unsigned char kb_type; // KB_TYPE_* in src/keyboard/keyboard.asm: 0 none, 1 PS/2, 2 iGKB, 3 legacy experimental mouse, the SGB's (the SNES mouse with): 4 PS/2, 5 no keyboard, 6 iGKB
extern unsigned char kb_scan_code_buffer[64]; // last raw serial bytes (KB_SCAN_CODE_COUNT), idle zeros excluded for iGKB
extern unsigned char kb_error_buffer[64]; // their PS2_ERROR_* bits (zero for iGKB)
extern unsigned char kb_buffer_write; // next one it writes
extern unsigned char kb_interrupt_count; // bytes received (wraps)
extern unsigned char kb_error_count; // bytes with errors (wraps)

#endif
