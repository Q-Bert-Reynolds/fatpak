#ifndef FATPAK_KEYBOARD_KEYBOARD_H
#define FATPAK_KEYBOARD_KEYBOARD_H

#include "../constants.h"

extern unsigned char KBPeekKey(void); // next event's key without popping it (KEY_NONE if empty)
extern unsigned int KBPopEvent(void); // key in low byte (KEY_NONE if empty), modifiers in high byte
extern void KBListen(void); // listen for a PS/2 keyboard even if none was found at boot
extern unsigned char kb_type; // KB_TYPE_* in src/keyboard/keyboard.asm: 0 none, 1 PS/2, 2 iGKB
extern unsigned char kb_scan_code_buffer[64]; // the PS/2 interrupt's last scan codes (KB_SCAN_CODE_COUNT)
extern unsigned char kb_error_buffer[64]; // and their PS2_ERROR_* bits
extern unsigned char kb_buffer_write; // next one it writes
extern unsigned char kb_interrupt_count; // bytes received (wraps)
extern unsigned char kb_error_count; // bytes with errors (wraps)

#endif
