INCLUDE "src/keyboard/ps2_keys.asm";PS/2 keys codes

;kb_type
DEF KB_TYPE_NONE EQU 0
DEF KB_TYPE_PS2  EQU 1
DEF KB_TYPE_IGKB EQU 2
DEF KB_TYPE_MOUSE EQU 3;legacy experimental mouse protocol, not a menu choice
DEF KB_DRIVER_SIZE EQU $580

;kb_mode
DEF KB_MODE_NONE    EQU 0
DEF KB_MODE_BUTTONS EQU 1
DEF KB_MODE_EDITOR  EQU 4;key presses are queued as key events

DEF KB_EVENT_COUNT EQU 16;must be a power of 2
DEF KB_SCAN_CODE_COUNT EQU 64;must be a power of 2

;kb_error
DEF PS2_ERROR_TIMEOUT      EQU %100000
DEF PS2_ERROR_UNKNOWN_CODE EQU %010000
DEF PS2_ERROR_KEYBOARD     EQU %001000
DEF PS2_ERROR_START_BIT    EQU %000100
DEF PS2_ERROR_PARITY_BIT   EQU %000010
DEF PS2_ERROR_FINISH_BIT   EQU %000001

DEF KB_FLAG_RELEASE  EQU %00000001 ;$PS2 code $F0
DEF KB_FLAG_EXTENDED EQU %00000010 ;$PS2 code $E0

SECTION "Keyboard Vars", WRAM0
;PS/2 scan codes are 11 bits (S0123456 7PFxxxxx):
; - (S)tart (always 0)
; - Data Bits (0-7) in reverse order
; - Odd (P)arity Bit - if the sum of bits 1-A (data bits + parity) is even, error
; - (F)inish Bit (always 1)
;insideGadgets' USB scan codes are 8-bit
; - most data sent directly as ASCII, including shifted keys
; - some data comes through as USB HID codes
; - the rest are incorrectly converted ASCII codes that can sometimes be converted back to HID codes

kb_scan_code:: DB
_kb_scan_code_buffer::
kb_scan_code_buffer:: DS KB_SCAN_CODE_COUNT;holds last scan codes
_kb_error_buffer::
kb_error_buffer:: DS KB_SCAN_CODE_COUNT;holds last error codes
_kb_buffer_write::
kb_buffer_write:: DB
kb_buffer_read:: DB
_kb_interrupt_count::
kb_interrupt_count:: DB
kb_error:: DB;xxTUKSPF - (T)imeout, (U)nknown Scan Code, (K)eyboard $00 or $FF, (S)tart Bit, (P)arity Bit, (F)inish Bit
_kb_error_count::
kb_error_count:: DB
kb_modifiers:: DB ;FSCAUPNL - (F)unction, (S)hift, (C)trl, (A)lt, S(U)per, Ca(P)s Lock, (N)um Lock, Scro(L)l Lock
kb_flags:: DB;xxxxxxER - (E)xtended key flag, (R)elease key flag
_kb_type::
kb_type:: DB
_kb_driver:: DB;persisted choice; immediately follows kb_type (driver ABI 11)
kb_mode:: DB
kb_event_buffer:: DS KB_EVENT_COUNT*2;key, modifiers
kb_event_write:: DB
kb_event_read:: DB
kb_held_key: DB;PS/2 arrow key held in editor mode (d-pad flag), 0 = none
kb_repeat_timer: DB

SECTION "Keyboard Code Bank 0", ROM0
INCLUDE "src/keyboard/ps2_interrupt.asm"

_KBPeekKey::;returns the next event's key in a without popping it (KEY_NONE if queue is empty)
  ld a, [kb_event_read]
  ld hl, kb_event_write
  cp a, [hl]
  ld a, KEY_NONE
  ret z
  ld a, [kb_event_read]
  ld l, a
  ld h, 0
  add hl, hl
  ld de, kb_event_buffer
  add hl, de
  ld a, [hl]
  ret

_KBPopEvent::
KBPopEvent::;returns key in c (KEY_NONE if queue is empty), modifiers in b
  ld bc, 0
  ld a, [kb_event_read]
  ld hl, kb_event_write
  cp a, [hl]
  ret z
  ld l, a
  inc a
  and a, KB_EVENT_COUNT-1
  ld [kb_event_read], a
  ld h, 0
  add hl, hl
  ld de, kb_event_buffer
  add hl, de
  ld a, [hli]
  ld c, a
  ld b, [hl]
  ret

_KBListen::;selected drivers start themselves; diagnostics must not change the selection
  ret

  KEYBOARD_SECTION
KeyboardDriverStart::
DetectKeyboard::
  jp KeyboardDriverInit
ProcessKeyCodes::
  jp PS2Process
  INCLUDE "src/keyboard/driver_common.asm"
  INCLUDE "src/keyboard/driver_ps2.asm"
  ASSERT @ - KeyboardDriverStart <= KB_DRIVER_SIZE
  DS KB_DRIVER_SIZE - (@ - KeyboardDriverStart), 0
KeyboardDriverEnd::

; Called through ModDriver, while its module is in page 13. This code stays
; outside the replaced slot. The last block is only 384 bytes.
KBDriverInstall::
  bit 7, a
  jr nz, .init
  cp 3
  jr nc, .query
  add a, a
  add a, HIGH(KeyboardDriverStart)
  ld d, a
  ld e, 0
  ld bc, 512
  cp HIGH(KeyboardDriverStart)+4
  jr nz, .copy
  ld bc, KB_DRIVER_SIZE-1024
.copy
  ld hl, EDX_WINDOW
  jp mem_Copy
.query
  ld bc, kb_type
  cp $40
  ret z
  ld bc, KeyboardDriverInit
  ret
.init
  push af
  and 3
  call KeyboardDriverInit
  pop af
  bit 6, a
  ret z
  and 3
  ld [_kb_driver], a
  call _SettingsSave
  ld a, [_doc_large]
  and a
  ret nz
  jp _FileSaveSwap
KeyboardDriverInit::
  ld [kb_type], a
  push af
  xor a
  ldh [rSC], a
  ld hl, kb_buffer_write
  ld [hli], a
  ld [hl], a
  ld hl, kb_event_write
  ld [hli], a
  ld [hl], a
  ld hl, kb_modifiers
  ld [hli], a
  ld [hl], a
  ld [kb_held_key], a
  ldh [kb_button_state], a
  ld hl, _mouse_buttons
  ld [hli], a
  ld [hl], a
  ld [igkb_packet], a
  ld [oam_buffer+8], a
  pop af
  and a
  ret z
  cp KB_TYPE_PS2
  ld a, SCF_START
  jr z, .start
  or SCF_SOURCE
.start
  push af
  xor a
  ldh [rSB], a
  pop af
  ldh [rSC], a
  ret

SECTION "Mouse driver state", WRAMX
_mouse_x:: DB
_mouse_y:: DB
_mouse_buttons:: DB
igkb_ready:: DB
igkb_packet:: DB
igkb_flags:: DB
igkb_dx:: DB
igkb_budget:: DB
; Mouse-only state is reset lazily after KeyboardDriverInit clears igkb_ready.
igkb_tick:: DW
igkb_timeout:: DB
igkb_double:: DB
igkb_last_row:: DB
igkb_nav:: DB
igkb_target:: DB
igkb_action:: DB
igkb_box:: DB
_render_box_first:: DB;shared menu hit-test limit (WRAMX)
