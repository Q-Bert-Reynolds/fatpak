; Four SGB input bytes: BIOS pad 1, commit/buttons, absolute X, absolute Y.
; Read commit twice around the coordinates, and always leave pad 1 selected.
SNESMouseProcess:
  ld a, [kb_type]
  cp KB_TYPE_SNES_MOUSE
  ret nz
  ld a, [igkb_ready]
  and a
  jr nz, .frame
  inc a
  ld [igkb_ready], a
  xor a
  ld [igkb_timeout], a
  ld [igkb_double], a
  ld [igkb_nav], a
  ld [igkb_action], a
  ld [igkb_packet], a
.frame
  call IGKBMouseFrame
  call SNESMouseRead
  ld a, b
  cp e
  ret nz
  bit 7, a
  ret nz
  ld hl, igkb_packet
  cp [hl]
  ret z
  ld [hl], a
  call .ack
  bit 0, b
  jr z, .absent
  xor a
  call .capture
  ld a, b
  call .capture
  ld a, c
  call .capture
  ld a, d
  call .capture
  ld a, b
  srl a
  and 3
  ld [igkb_flags], a
  ld a, c
  cp 160
  ret nc
  ld [_mouse_x], a
  ld a, d
  cp 144
  ret nc
  ld [_mouse_y], a
  jp IGKBMouseReport
.absent
  xor a
  ld [_mouse_buttons], a
  ld [oam_buffer+8], a
  ret

.ack
  push bc
  push de
  call SGBInputBegin
  push af
  ld hl, SNESMouseAck
  call sgb_PacketTransferFast
  call SNESMouseSelectOne
  pop af
  pop de
  pop bc
  jp SGBInputEnd
.capture
  push bc
  push af
  ld a, [kb_buffer_write]
  ld c, a
  ld b, 0
  ld hl, kb_scan_code_buffer
  add hl, bc
  pop af
  ld [hl], a
  ld hl, kb_error_buffer
  add hl, bc
  ld [hl], 0
  ld a, c
  inc a
  and KB_SCAN_CODE_COUNT-1
  ld [kb_buffer_write], a
  ld hl, kb_interrupt_count
  inc [hl]
  pop bc
  ret

SNESMouseAck:
  DB $79, $f0, $1f, 0, 1, 1
  DS 10
INCLUDE "src/sgb/mouse_input.asm"

INCLUDE "src/keyboard/driver_mouse.asm"
