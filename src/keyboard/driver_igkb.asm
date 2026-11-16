INCLUDE "src/keyboard/igkb_handlers.asm"

; Poll at most three bytes per frame, using the existing byte decoder.
; Raw capture does not depend on knowing keyboard/mouse packet boundaries.
IGKBProcess::
  ld a, 3
  ld [igkb_budget], a
  ld a, [kb_type]
  cp KB_TYPE_IGKB
  ret c
  cp KB_TYPE_MOUSE
  jr nz, .read
  ld a, [igkb_ready]
  and a
  jr nz, .mouseFrame
  inc a
  ld [igkb_ready], a
  ld a, 80
  ld [_mouse_x], a
  ld a, 72
  ld [_mouse_y], a
  xor a
  ld [igkb_timeout], a
  ld [igkb_double], a
  ld [igkb_nav], a
  ld [igkb_action], a
  ld a, [_render_frames]
  ld [igkb_tick], a
  ld a, [_render_frames+1]
  ld [igkb_tick+1], a
.mouseFrame
  call IGKBMouseFrame
.read
  ldh a, [rSC]
  bit 7, a
  ret nz
  ldh a, [rSB]
  push af
  xor a
  ldh [rSB], a
  ld a, SCF_START | SCF_SOURCE
  ldh [rSC], a
  pop af
  and a
  ret z
  ; Capture every nonzero byte, including $FF, before decoding.
.byte
  push af
  ld a, [kb_buffer_write]
  ld c, a
  ld b, 0
  ld hl, kb_scan_code_buffer
  add hl, bc
  pop af
  ld [hl], a
  push af
  ld hl, kb_error_buffer
  add hl, bc
  ld [hl], 0
  ld a, c
  inc a
  and KB_SCAN_CODE_COUNT-1
  ld [kb_buffer_write], a
  pop af
  ld b, a
  ld hl, kb_interrupt_count
  inc [hl]
  ld a, [kb_type]
  cp KB_TYPE_MOUSE
  jr z, .mouse
  ld a, b
  call IGKBHandleCode
  jr .budget
.mouse
  ld a, b
  call IGKBMouseByte
.budget
  ld hl, igkb_budget
  dec [hl]
  ret z
.waitNext
  ldh a, [rSC]
  bit 7, a
  jr nz, .waitNext; internal clock: at most one byte time, no external-clock wait
  jp IGKBProcess.read

INCLUDE "src/keyboard/driver_mouse.asm"
