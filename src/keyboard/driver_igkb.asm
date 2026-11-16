INCLUDE "src/keyboard/igkb_handlers.asm"

; Poll once per frame without a delay or an interrupt-side bank switch.
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
  jr nz, .read
  inc a
  ld [igkb_ready], a
  ld a, 80
  ld [_mouse_x], a
  ld a, 72
  ld [_mouse_y], a
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
  cp $FF
  jr nz, .byte
  ld a, [kb_type]
  cp KB_TYPE_MOUSE
  ret nz
  ld a, $FF; magnitude 127 is valid mouse data
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
  ld a, b
  jp nz, IGKBHandleCode
  call IGKBMouseByte
  ld hl, igkb_budget
  dec [hl]
  ret z
.waitNext
  ldh a, [rSC]
  bit 7, a
  jr nz, .waitNext; internal clock: at most one byte time, no external-clock wait
  jp IGKBProcess.read

; Mouse firmware: $40|buttons|signs, $80|abs(x), $80|abs(y).
; A header can restart an incomplete packet; idle zero bytes do not advance it.
IGKBMouseByte:
  bit 7, a
  jr nz, .move
  bit 6, a
  ret z
  ld [igkb_flags], a
  ld a, 1
  ld [igkb_packet], a
  ret
.move
  and $7F
  ld b, a
  ld a, [igkb_packet]
  cp 1
  jr z, .x
  cp 2
  ret nz
  xor a
  ld [igkb_packet], a
  ld a, [igkb_flags]
  bit 5, a
  ld a, b
  jr nz, .yPos
  cpl
  inc a
.yPos
  ld e, a
  ld a, [_mouse_y]
  call .add
  cp 144
  jr c, .yStore
  ld a, 143
.yStore
  ld [_mouse_y], a
  ld a, [igkb_dx]
  ld e, a
  ld a, [_mouse_x]
  call .add
  cp 160
  jr c, .xStore
  ld a, 159
.xStore
  ld [_mouse_x], a
  ld a, [igkb_flags]
  and 7
  ld b, a
  ld a, [_mouse_buttons]
  xor b
  and b
  ld c, a; newly pressed buttons
  ld a, b
  ld [_mouse_buttons], a
  ; Sprite 2 uses the editor's I-beam tile and palette. It is separate
  ; from the insertion cursor (sprite 0) and on-screen keyboard (sprite 1) and hidden when changing driver.
  ld hl, oam_buffer+8
  ld a, [_mouse_y]
  add 16
  ld [hli], a
  ld a, [_mouse_x]
  add 8
  ld [hli], a
  ld [hl], 0
  inc hl
  ld [hl], OAMF_PAL1
  push bc
  call IGKBMouseAction
  pop bc
  ret

.x
  ld a, b
  ld [igkb_dx], a
  ld a, [igkb_flags]
  bit 4, a
  ld a, b
  jr nz, .xPos
  cpl
  inc a
.xPos
  ld [igkb_dx], a
  ld a, 2
  ld [igkb_packet], a
  ret
.add; A + signed E, saturated at 0..255
  bit 7, e
  jr z, .positive
  add e
  ret c
  xor a
  ret
.positive
  add e
  ret nc
  ld a, 255
  ret

; Mouse reports drive editor hit testing, and hover/navigation in boxes and
; browser lists. Keep these routines in the replaceable slot, not resident C.
IGKBMouseAction:
  bit 1, c
  ld a, KEY_ESCAPE
  jp nz, KBHandleEditorKey
  ld a, [_render_box_top]
  cp $FF
  jr nz, .menu
  ld a, [_render_text]
  and a
  jr z, .browser
  ld a, [_module_busy]
  and a
  ret nz
  ld a, [_mouse_buttons]
  bit 0, a
  ret z
  ld a, [_mouse_y]
  srl a
  srl a
  srl a
  ld hl, _render_text_top
  sub [hl]
  ld hl, _tb_rows
  cp [hl]
  ret nc
  push bc; new button edges
  ld hl, _mouse_x
  ld e, [hl]
  call _PosAtX__far
  ld a, c
  ld [_cursor], a
  ld a, b
  ld [_cursor+1], a
  ld d, b
  ld e, c
  pop bc
  bit 0, c
  jr z, .drag
  xor a
  ld [_selecting], a
  ld a, e
  ld [_anchor], a
  ld a, d
  ld [_anchor+1], a
  jr .moved
.drag
  ld a, 1
  ld [_selecting], a
.moved
  ld a, 1
  ld [_moved], a
  ld [_redraw], a
  ret
.menu
  ld a, [_render_box_sel]
  cp $FF
  jr z, .buttons; message box, not a menu
  ld b, a; selected row, including upper padding
  ld a, [_mouse_x]
  ld hl, _render_box_x
  sub [hl]
  ld hl, _render_box_w
  cp [hl]
  ret nc
  ld a, [_mouse_y]
  srl a
  srl a
  srl a
  ld hl, _render_box_top
  sub [hl]
  and a
  ret z
  ld hl, _render_box_rows
  inc a
  cp [hl]
  ret nc
  dec a; target row
  jr .navigate
.browser
  ld a, [_mouse_y]
  srl a
  srl a
  srl a
  and a
  ret z
  cp 17
  ret nc
  ld d, a; target list row
  ld b, 1
  ld hl, _render_sel+3
.find
  ld a, [hli]
  inc hl
  cp $FF
  jr z, .found
  inc b
  ld a, b
  cp 17
  jr c, .find
  ret
.found
  ld a, d
.navigate
  sub b
  jr z, .buttons
  ld b, KEY_DOWN
  jr nc, .count
  cpl
  inc a
  ld b, KEY_UP
.count
  cp KB_EVENT_COUNT-2
  jr c, .queue
  ld a, KB_EVENT_COUNT-2
.queue
  ld d, a
.next
  push bc
  push de
  ld a, b
  call KBHandleEditorKey
  pop de
  pop bc
  dec d
  jr nz, .next
.buttons
  bit 0, c
  ld a, KEY_ENTER
  jp nz, KBHandleEditorKey
  ret
