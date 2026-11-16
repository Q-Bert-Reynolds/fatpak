DEF IGKB_POINTER_TILE EQU 122
DEF IGKB_POINTER_TIMEOUT EQU 120; two seconds at 60 Hz
DEF IGKB_DOUBLE_TIMEOUT EQU 24; 400 ms between presses

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
DEF IGKBMouseReport EQU @
  ld a, [igkb_flags]
  and 7
  ld b, a
  ld a, [_mouse_buttons]
  xor b
  and b
  ld c, a; newly pressed buttons
  ld a, b
  ld [_mouse_buttons], a
  push bc
  ; Tile 122 is in the unused gap between the DMG text blocks. It is
  ; also free in GBC bank 0, and does not borrow either existing sprite tile.
  xor a
  ldh [rVBK], a
  ld hl, IGKBPointerTile
  ld de, _VRAM8000 + IGKB_POINTER_TILE*16
  ld bc, 16
  call mem_CopyVRAM
  pop bc
  ld a, IGKB_POINTER_TIMEOUT
  ld [igkb_timeout], a
  ld hl, oam_buffer+8
  ld a, [_mouse_y]
  add 16
  ld [hli], a
  ld a, [_mouse_x]
  add 8
  ld [hli], a
  ld [hl], IGKB_POINTER_TILE
  inc hl
  ld [hl], 0; palette 0: independent of insertion cursor inversion
  jp IGKBMouseAction

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

; Age visibility and the double-click window once per displayed frame.
IGKBMouseFrame:
  di
  ld a, [_render_frames]
  ld e, a
  ld a, [_render_frames+1]
  ld d, a
  ei
  ld hl, igkb_tick
  ld a, e
  sub [hl]
  ld b, a
  ld [hl], e
  inc hl
  ld a, d
  sbc [hl]
  ld [hl], d
  and a
  ld a, 255
  jr nz, .elapsed
  ld a, b
.elapsed
  ld b, a
  ld hl, igkb_double
  call .age
  ld hl, igkb_timeout
  call .age
  ld a, [hl]
  and a
  jr nz, .service
  ld [oam_buffer+8], a
  jr .service
.age
  ld a, [hl]
  sub b
  jr nc, .store
  xor a
.store
  ld [hl], a
  ret
.service
  jp IGKBMouseNavigate

; Browser reports select a row in one event. Menu navigation waits for
; consumption and confirms the requested row before performing an action.
IGKBMouseAction:
  ld a, [_render_box_top]
  cp $FF
  jr nz, .menu
  ld a, [_module_busy]
  and a
  ret nz
  ld a, [_render_text]
  and a
  jp z, .browser
  bit 1, c
  ld a, KEY_MENU
  jp nz, KBHandleEditorKey
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
  push bc
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
  ld [igkb_box], a
  ld a, c
  and 3
  jr nz, .hit
  ld a, [igkb_action]
  and a
  ret nz
.hit
  ld a, [_mouse_x]
  ld hl, _render_box_x
  sub [hl]
  ld hl, _render_box_w
  cp [hl]
  jr nc, .outside
  ld a, [_mouse_y]
  srl a
  srl a
  srl a
  ld hl, _render_box_top
  sub [hl]
  and a
  jr z, .outside
  ld hl, _render_box_rows
  inc a
  cp [hl]
  jr nc, .outside
  dec a
  ld [igkb_target], a
  ld a, [_render_box_sel]
  cp $FF
  jr z, .confirm; message boxes have no selection
  ld a, [igkb_target]
  ld hl, _render_box_first
  cp [hl]
  ret c
  bit 0, c
  ld a, KEY_ENTER
  jr nz, .schedule
  ; Releases must not erase a click still waiting for its navigation.
  ld a, [igkb_action]
  and a
  ret nz
  xor a
  jr .schedule
.confirm
  bit 0, c
  ld a, KEY_ENTER
  jp nz, KBHandleEditorKey
  ret
.outside
  bit 0, c
  ret z
  xor a
  ld [igkb_nav], a
  ld [igkb_action], a
  ld a, KEY_ESCAPE
  jp KBHandleEditorKey
.browser
  ld a, c
  and 3
  ret z; hovering leaves the browser selection alone
  ld a, [_mouse_y]
  srl a
  srl a
  srl a
  and a
  ret z
  cp 17
  ret nc
  ld [igkb_target], a
  ; Browser text rows are stored at row-1; an empty row has no name.
  dec a
  ld l, a
  ld h, 0
  add hl, hl
  add hl, hl
  add hl, hl
  ld d, h
  ld e, l
  add hl, hl
  add hl, hl
  add hl, de; row * 40 (TB_STRIDE)
  ld de, tile_buffer+1
  add hl, de
  ld a, [hl]
  and a
  ret z
  cp ' '
  ret z
  ld a, $FF
  ld [igkb_box], a
  bit 1, c
  jr z, .left
  xor a
  ld [igkb_double], a
  ld a, KEY_MENU
  jr .schedule
.left
  ld a, [igkb_target]
  ld hl, igkb_last_row
  cp [hl]
  ld [hl], a
  jr nz, .first
  ld a, [igkb_double]
  and a
  jr z, .first
  xor a
  ld [igkb_double], a
  ld a, KEY_ENTER
  jr .schedule
.first
  ld a, IGKB_DOUBLE_TIMEOUT
  ld [igkb_double], a
  xor a; single click only selects
.schedule
  ld [igkb_action], a
  ld a, 1
  ld [igkb_nav], a
  jp IGKBMouseNavigate

IGKBMouseNavigate:
  ld a, [igkb_nav]
  and a
  ret z
  ld a, [kb_event_read]
  ld hl, kb_event_write
  cp [hl]
  ret nz
  ld a, [igkb_box]
  ld hl, _render_box_top
  cp [hl]
  jr nz, .cancel; the menu changed before navigation completed
  cp $FF
  jr z, .browser
  ld a, [_render_box_sel]
  jr .target
.browser
  ld a, [_render_text]
  and a
  jr nz, .cancel
  ld a, [_module_busy]
  and a
  jr nz, .cancel
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
  jr .cancel
.found
  ld a, [igkb_target]
  cp b
  jr z, .done
  add KEY_MOUSE_ROW-1
  jp KBHandleEditorKey
.target
  ld hl, igkb_target
  cp [hl]
  jr z, .done
  ld a, KEY_UP
  jp nc, KBHandleEditorKey
  ld a, KEY_DOWN
  jp KBHandleEditorKey
.done
  xor a
  ld [igkb_nav], a
  ld hl, igkb_action
  ld a, [hl]
  ld [hl], 0
  and a
  jp nz, KBHandleEditorKey
  ret
.cancel
  xor a
  ld [igkb_nav], a
  ld [igkb_action], a
  ret

IGKBPointerTile:
  INCBIN "img/ui_font.tiles", 26*16, 16
