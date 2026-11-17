; Independently linked at the renderer interval, with imports bound to this OS.
INCLUDE "src/hardware.inc"
INCLUDE "src/constants.asm"
INCLUDE "src/sgb/protocol.asm"
INCLUDE "build/sgb/host.inc"
SECTION "Terminal head", ROMX[$4000], BANK[1]
FsEntry:
  jp FsInit
  jp FsDraw
  jp FsRedraw
  ret ; reserved stage dispatch
  nop
  nop
  jp FsInput
  jp FsInterrupt
  jp FsPalette

; Emitter: no command buffer in WRAM. Sequence zero keeps the page unpublished.
FsByte:
  push hl
  push af
  push af
  ldh a, [fs_write]
  ld l, a
  ldh a, [fs_write+1]
  ld h, a
.wait
  ldh a, [rSTAT]
  and STATF_BUSY
  jr nz, .wait
  pop af
  ld [hli], a
  ld a, l
  ldh [fs_write], a
  ld a, h
  ldh [fs_write+1], a
  pop af
  pop hl
  ret
FsBegin:
  ld a, 0
  ld hl, $8000
  call FsStore
  ld a, 3
  ldh [fs_write], a
  ld a, $80
  ldh [fs_write+1], a
  ret
FsStore: ; HL address, A byte, preserves DE/BC
  push af
.wait
  ldh a, [rSTAT]
  and STATF_BUSY
  jr nz, .wait
  pop af
  ld [hli], a
  ret
FsCRC: ; DE CRC, A byte; preserves BC/HL
  push bc
  xor d
  ld b, a
  swap a
  and $0F
  xor b
  ld b, a
  swap a
  and $F0
  xor e
  ld c, a
  ld a, b
  rrca
  rrca
  rrca
  and $1F
  xor c
  ld d, a
  ld a, b
  rrca
  rrca
  rrca
  and $E0
  xor b
  ld e, a
  pop bc
  ret
FsFlush:
  ldh a, [fs_write]
  ld c, a
  ldh a, [fs_write+1]
  sub $80
  ld b, a
  ld hl, -3
  add hl, bc
  ld b, h
  ld c, l
  ld a, b
  or c
  ret z
  ld hl, $8001
  ld a, c
  call FsStore
  ld a, b
  call FsStore
  inc bc
  inc bc
  ld de, $FFFF
  ldh a, [fs_seq]
  inc a
  jr nz, .seq
  inc a
.seq
  ldh [fs_seq], a
  call FsCRC
  ld hl, $8001
.crc
  ldh a, [rSTAT]
  and STATF_BUSY
  jr nz, .crc
  ld a, [hli]
  call FsCRC
  dec bc
  ld a, b
  or c
  jr nz, .crc
  ld a, e
  call FsStore
  ld a, d
  call FsStore
  ld a, 1
  ldh [fs_pending], a
  ld hl, $8000
  ldh a, [fs_seq]
  call FsStore ; commit last
  ldh [fs_committed], a
FsWait:
  ld a, [_render_frames]
  ld b, a
.wait
  push bc
  call FsPoll
  ldh a, [fs_pending]
  and a
  jr nz, .notAcknowledged
  pop bc
  jp FsBegin
.notAcknowledged
  ld a, [kb_event_write]
  inc a
  and 15
  ld hl, kb_event_read
  cp [hl]
  jr nz, .inputSpace
  pop bc
  ld a, 1
  ldh [fs_deferred], a
  ret ; keep the page committed; let the editor consume queued input
.inputSpace
  call FsFrame
  pop bc
  ldh a, [fs_pending]
  and a
  jp z, FsBegin
  ld a, [_render_frames]
  sub b
  cp SGBFS_PAGE_TIMEOUT_FRAMES
  jr c, .wait
  ld a, 1
  ldh [fs_fault], a
  scf
  ret
FsTLV: ; A opcode, BC payload size
  call FsByte
  ld a, c
  call FsByte
  ld a, b
  jp FsByte
FsLayout:
  ld a, SGBFS_CMD_LAYOUT
  ld bc, 4
  call FsTLV
  ld a, [_render_text_top]
  call FsByte
  ld a, [_tb_rows]
  call FsByte
  ld a, [_bars]
  and a
  ld a, 0
  jr z, .bars
  ld a, 3
.bars
  call FsByte
  ld a, [_screen_rows]
  ld b, a
  ld a, [_tb_rows]
  ld c, a
  ld a, [_bars]
  add a
  add c
  ld c, a
  ld a, b
  sub c
  jp FsByte
FsScroll:
  ld a, [_ring_top]
  ld b, a
  ldh a, [fs_ring]
  ld c, a
  ld a, b
  ldh [fs_ring], a
  sub c
  and 31
  ld d, a
  ldh a, [fs_force]
  and a
  ret nz
  ld a, d
  cp 1
  jr z, .emit
  cp 31
  ret nz
  ld d, $FF
.emit
  ld a, SGBFS_CMD_SCROLL
  ld bc, 2
  call FsTLV
  ld a, d
  call FsByte
  xor a
  jp FsByte
FsRedraw:
  ld a, 1
  ldh [fs_force], a
  ld hl, wide_row_hashes
  ld bc, MAX_SCREEN_ROWS*2
  ld a, $FF
  jp mem_Set
FsDraw:
  ldh a, [fs_pending]
  and a
  jr z, .idle
  call FsWait
  ldh a, [fs_pending]
  and a
  ret nz
.idle
  ldh a, [fs_fault]
  and a
  ret nz
  ld a, 1
  ldh [fs_deferred], a
  call FsBegin
  call FsLayout
  call FsScroll
  xor a
  ldh [fs_row], a
.row
  call FsEncodeRow
  ldh a, [fs_pending]
  and a
  ret nz
  ldh a, [fs_fault]
  and a
  ret nz
  ldh a, [fs_row]
  inc a
  ldh [fs_row], a
  cp 28
  jr c, .row
  call FsCursor
  call FsFlush
  ldh a, [fs_pending]
  and a
  ret nz
  ldh a, [fs_fault]
  and a
  ret nz
  xor a
  ldh [fs_deferred], a
  ldh [fs_force], a
  ret
; Build row geometry first; then one RLE pair per character is valid RLE and
; bounds the largest ROW at 202 bytes. A page reserves a complete command.
FsEncodeRow:
  ldh a, [fs_write+1]
  cp $86
  jr c, .space
  call FsFlush
  ldh a, [fs_pending]
  and a
  ret nz
.space
  ldh a, [fs_row]
  ld c, a
  ld b, 0
  ld hl, _render_row_fonts
  add hl, bc
  ld a, [hl]
  ldh [fs_font], a
  ld hl, _render_row_lines
  add hl, bc
  ld a, [hl]
  push af
  call RenderLineStyled
  ld a, 0
  adc 0
  ldh [fs_styled], a
  pop af
  push af
  ld c, a
  ldh a, [fs_styled]
  and a
  jr z, .fontChosen
  ld a, c
  add a
  ld c, a
  ld b, 0
  ld hl, tb_row_states+1
  add hl, bc
  ld a, [hl]
  and 7 ; MD_HEADING
  jr z, .fontChosen
  cp 5
  jr nc, .fontChosen
  add 2
  ldh [fs_font], a
.fontChosen
  pop af
  call RenderRowAddress
  ld de, tile_buffer
  add hl, de
  ld a, l
  ldh [fs_chars], a
  ld a, h
  ldh [fs_chars+1], a
  ld a, [_tile_attrs]
  ld e, a
  ld a, [_tile_attrs+1]
  ld d, a
  ld a, l
  sub LOW(tile_buffer)
  ld l, a
  ld a, h
  sbc HIGH(tile_buffer)
  ld h, a
  add hl, de
  ld a, l
  ldh [fs_attrs], a
  ld a, h
  ldh [fs_attrs+1], a
  xor a
  ldh [fs_count], a
  ldh [fs_x], a
.count
  call FsAttr
  and 15
  ld b, a
  ldh a, [fs_x]
  add b
  cp 249
  jr nc, .counted
  ldh [fs_x], a
  ldh a, [fs_count]
  inc a
  ldh [fs_count], a
  cp 64
  jr c, .count
.counted
  ; Hash characters, widths/styles, font and selection, without using bitmap caches.
  ld de, $FFFF
  ldh a, [fs_font]
  call FsCRC
  ldh a, [fs_styled]
  call FsCRC
  ldh a, [fs_row]
  add a
  ld c, a
  ld b, 0
  ld hl, _render_sel
  add hl, bc
  ld a, [hli]
  ldh [fs_sel_start], a
  call FsCRC
  ld a, [hl]
  ldh [fs_sel_end], a
  call FsCRC
  ldh a, [fs_chars]
  ld l, a
  ldh a, [fs_chars+1]
  ld h, a
  ldh a, [fs_count]
  ld b, a
  and a
  jr z, .hashed
.hash
  ld a, [hli]
  call FsCRC
  dec b
  jr nz, .hash
.hashed
  xor a
  ldh [fs_x], a
.hashAttrs
  ldh a, [fs_count]
  ld b, a
  ldh a, [fs_x]
  cp b
  jr z, .attrsHashed
  call FsAttrAtX
  call FsCRC
  ldh a, [fs_x]
  inc a
  ldh [fs_x], a
  jr .hashAttrs
.attrsHashed
  ldh a, [fs_row]
  add a
  ld c, a
  ld b, 0
  ld hl, wide_row_hashes
  add hl, bc
  ldh a, [fs_force]
  and a
  jr nz, .forced
  ld a, [hli]
  cp e
  jr nz, .changed
  ld a, [hl]
  cp d
  ret z
.forced
  inc hl
.changed
  ld [hl], d
  dec hl
  ld [hl], e
  ldh a, [fs_count]
  ld c, a
  add a
  add c
  add 7
  ld c, a
  ld b, 0
  ld a, SGBFS_CMD_ROW
  call FsTLV
  ldh a, [fs_row]
  call FsByte
  ldh a, [fs_font]
  call FsByte
  ldh a, [fs_styled]
  call FsByte
  ; Convert immutable character boundaries into half-open pixel boundaries.
  ldh a, [fs_sel_start]
  ldh [fs_sel_cols], a
  ldh a, [fs_sel_end]
  ldh [fs_sel_cols+1], a
  cp $FF
  jr z, .defaultEnd
  ld a, 248
.defaultEnd
  ldh [fs_sel_end], a
  ld a, 248
  ldh [fs_sel_start], a
  xor a
  ldh [fs_x], a
  ldh [fs_width], a
.sel
  ldh a, [fs_x]
  ld b, a
  ldh a, [fs_sel_cols]
  cp b
  jr nz, .end
  ldh a, [fs_width]
  ldh [fs_sel_start], a
.end
  ldh a, [fs_sel_cols+1]
  cp b
  jr nz, .next
  ldh a, [fs_width]
  ldh [fs_sel_end], a
.next
  ldh a, [fs_count]
  cp b
  jr z, .selectionDone
  call FsAttrAtX
  and 15
  ld b, a
  ldh a, [fs_width]
  add b
  ldh [fs_width], a
  ldh a, [fs_x]
  inc a
  ldh [fs_x], a
  jr .sel
.selectionDone
  ldh a, [fs_sel_start]
  call FsByte
  ldh a, [fs_sel_end]
  call FsByte
  ldh a, [fs_count]
  call FsByte
  call FsByte
  ldh a, [fs_chars]
  ld l, a
  ldh a, [fs_chars+1]
  ld h, a
  ldh a, [fs_count]
  ld b, a
  and a
  jr z, .done
.chars
  ld a, [hli]
  call FsByte
  dec b
  jr nz, .chars
  xor a
  ldh [fs_x], a
.runs
  ld a, 1
  call FsByte
  call FsAttrAtX
  call FsByte
  ldh a, [fs_x]
  inc a
  ldh [fs_x], a
  ld b, a
  ldh a, [fs_count]
  cp b
  jr nz, .runs
.done
  ret
FsAttr:
  ldh a, [fs_count]
  jr FsAttrIndex
FsAttrAtX:
  ldh a, [fs_x]
FsAttrIndex:
  push hl
  push de
  push bc
  ld c, a
  ld b, 0
  ldh a, [fs_styled]
  and a
  jr z, .plain
  ldh a, [fs_attrs]
  ld l, a
  ldh a, [fs_attrs+1]
  ld h, a
  add hl, bc
  ld a, [hl]
  and 15
  jr nz, .styled
  ld a, 4 ; padding is a space with a real width, never an invalid zero RLE attr
  jr .return
.styled
  ld a, [hl]
  jr .return
.plain
  ldh a, [fs_font]
  cp 1
  ld a, 8
  jr c, .return
  ld a, 4
  jr nz, .return
  ldh a, [fs_chars]
  ld l, a
  ldh a, [fs_chars+1]
  ld h, a
  add hl, bc
  ld l, [hl]
  ld h, 0
  ld de, FontVWFWidths
  add hl, de
  ld a, [hl]
.return
  pop bc
  pop de
  pop hl
  ret
FsCursor:
  ld a, SGBFS_CMD_CURSOR
  ld bc, 3
  call FsTLV
  ld a, [oam_buffer]
  and a
  jr z, .hidden
  sub 16
  rrca
  rrca
  rrca
  and 31
  call FsByte
  ld a, [oam_buffer+1] ; GB sprite offset also supplies our 8px text margin
  call FsByte
  ld a, [cursor_white]
  inc a
  jp FsByte
.hidden
  xor a
  call FsByte
  xor a
  call FsByte
  xor a
  jp FsByte
FsPalette:
  ldh a, [fs_pending]
  and a
  call nz, FsWait
  ldh a, [fs_pending]
  and a
  ret nz
  call FsBegin
  ld a, SGBFS_CMD_PALETTE
  ld bc, 18
  call FsTLV
  xor a
  call FsByte
  ld a, 8
  call FsByte
  ld hl, FsLight
  ld a, [_theme]
  and a
  jr z, .colors
  ld hl, FsDark
.colors
  ld b, 16
.loop
  ld a, [hli]
  call FsByte
  dec b
  jr nz, .loop
  jp FsFlush
FsLight:
  DW 29|29<<5|27<<10,20|25<<5|31<<10,14|17<<5|14<<10,2|2<<5|3<<10
  DW 4|9<<5|24<<10,19|4<<5|4<<10,15|5<<5|20<<10,21|10<<5
FsDark:
  DW 3|3<<5|4<<10,6|10<<5|18<<10,13|15<<5|13<<10,27|27<<5|25<<10
  DW 13|19<<5|31<<10,31|15<<5|13<<10,25|14<<5|30<<10,31|22<<5|10<<10
ASSERT @ <= FontVWFWidths, "terminal head overlaps retained font metrics"

SECTION "Terminal tail", ROMX[FontVWFWidths+256], BANK[1]
FsInit:
  xor a
  ld hl, fs_ready
  ld bc, fs_tick_frame-fs_ready+1
  call mem_Set
  ldh [rIE], a
  ldh [rSTAT], a
  ldh [rIF], a
  ldh a, [rLCDC]
  bit 7, a
  jr z, .off
.wait
  ldh a, [rLY]
  cp 144
  jr c, .wait
.off
  xor a
  ldh [rLCDC], a
  ldh [rSCX], a
  ldh [rSCY], a
  ldh [rWY], a
  ld hl, $8000
  ld bc, $1800
  call mem_Set
  ld hl, $9800
  ld bc, $400
  ld a, $FF
  call mem_Set
  ld hl, $9800
  xor a
  ld c, 12
.maprow
  ld b, 20
.mapcol
  ld [hli], a
  inc a
  dec b
  jr nz, .mapcol
  ld de, 12
  add hl, de
  dec c
  jr nz, .maprow
  ld b, 16
.statusmap
  ld [hli], a
  inc a
  dec b
  jr nz, .statusmap
  ld a, $E4
  ldh [rBGP], a
  ld a, $91
  ldh [rLCDC], a
  ld b, SGBFS_HELLO_TIMEOUT_FRAMES
.hello
  push bc
  call FsPoll
  call FsFrame
  pop bc
  ldh a, [fs_ready]
  and a
  jr nz, .ready
  dec b
  jr nz, .hello
  ld a, 1
  ret
.ready
  call FsPalette
  ldh a, [fs_fault]
  and a
  ret nz
  call _GeometryWide
  ld a, [_bars]
  add a
  ld b, a
  ld a, 28
  sub b
  ld [_tb_rows], a
  call _Layout__far
  ld hl, wide_tile_buffer
  ld bc, 28*64
  ld a, ' '
  call mem_Set
  ld hl, wide_tile_attrs
  ld bc, 28*64
  ld a, 4
  call mem_Set
  call FsRedraw
  ldh a, [sys_info]
  or 4
  ldh [sys_info], a
  xor a
  ldh [fs_fault], a
  ld [_render_pending], a
  ldh [button_state], a
  ldh [last_button_state], a
  ldh [pad_latch], a
  ldh [pad_latch_last], a
  call FsBegin
  xor a
  ret
FsInput:
  xor a
  ldh [button_state], a
  ldh [last_button_state], a
  call FsPoll
  ldh a, [fs_deferred]
  and a
  call nz, FsDraw
  ldh a, [fs_pending]
  and a
  jr nz, .keyboard
  ldh a, [fs_fault]
  and a
  jr nz, .keyboard
  ld hl, oam_buffer
  ld de, fs_cursor
  ld b, 2
  ld c, 0
.compare
  ld a, [de]
  cp [hl]
  jr z, .same
  inc c
.same
  ld a, [hli]
  ld [de], a
  inc de
  dec b
  jr nz, .compare
  ld a, [cursor_white]
  ld b, a
  ld a, [de]
  cp b
  jr z, .cursorLook
  inc c
.cursorLook
  ld a, b
  ld [de], a
  ld a, c
  and a
  jr z, .keyboard
  call FsBegin
  call FsCursor
  call FsFlush
.keyboard
  ; Physical PS/2/iGKB can continue supplying the normal event queue.
  ld b, HOST_BANK_ProcessKeyCodes
  ld hl, ProcessKeyCodes
  call Trampoline
  jp UpdateInputReturn
FsInterrupt:
  call FsTick
  jp VBLContinue
FsFrame:
  ldh a, [rLY]
  cp 144
  jr c, .vblank
.visible
  ldh a, [rLY]
  cp 144
  jr nc, .visible
.vblank
  ldh a, [rLY]
  cp 144
  jr c, .vblank
  ldh a, [rIE]
  bit 0, a
  ret nz
  ; Bootstrap and wide-module callbacks can have VBlank masked.
  jp FsTick
FsTick:
  ld hl, _render_frames
  inc [hl]
  jr nz, .counted
  inc hl
.counted
  ld hl, fs_status
  ld a, $53
  ld [hli], a
  ld a, 1
  ld [hli], a
  ld a, [_render_frames]
  ld [hli], a
  ld a, [_render_frames+1]
  ld [hli], a
  ldh a, [fs_ack]
  ld [hli], a
  xor a
  ld [hli], a
  ldh a, [fs_committed]
  ld [hli], a
  xor a
  ld [hli], a
  ld b, 6
.zero
  ld [hli], a
  dec b
  jr nz, .zero
  ld hl, fs_status
  ld de, $FFFF
  ld b, 14
.crc
  ld a, [hli]
  call FsCRC
  dec b
  jr nz, .crc
  ld [hl], e
  inc hl
  ld [hl], d
  ld hl, fs_status
  ld de, $8F00
  ld b, 16
.copy
  ld a, [hli]
  ld [de], a
  inc de
  dec b
  jr nz, .copy
  ret
FsPoll:
  ; Four-player byte order is commit/type/A/B; bound controller selection so
  ; absent/broken hardware cannot trap the OS in a P1-selection loop.
  ld a, $30
  ldh [rP1], a
  ld b, 4
.select
  ldh a, [rP1]
  and 15
  cp 15
  jr z, .one
  ld a, $10
  ldh [rP1], a
  ld a, $30
  ldh [rP1], a
  dec b
  jr nz, .select
  ret
.one
  call FsRead
  ld c, a
  ld hl, fs_mb
  ld b, 4
.read
  ld [hli], a
  ld a, $30
  ldh [rP1], a
  call FsRead
  dec b
  jr nz, .read
  cp c
  ret nz
  and a
  ret z
  bit 7, a
  ret nz
  ld b, a
  ldh a, [fs_ack]
  cp b
  ret z
  ldh a, [fs_mb+1]
  and a
  ret z
  cp SGBFS_EVENT_HELLO
  jr z, .hello
  cp SGBFS_EVENT_ACK
  jr z, .ack
  cp SGBFS_EVENT_KEY
  jr z, .key
  cp SGBFS_EVENT_MOUSE_MOVE+1
  ret nc
  jr .consumed
.hello
  ldh a, [fs_mb+2]
  cp 1
  ret nz
  ld a, 1
  ldh [fs_ready], a
  jr .consumed
.ack
  ldh a, [fs_mb+2]
  and a
  ret nz
  ldh a, [fs_mb+3]
  ld c, a
  ldh a, [fs_seq]
  cp c
  ret nz
  xor a
  ldh [fs_pending], a
  jr .consumed
.key
  ldh a, [fs_mb+2]
  and a
  ret z
  ldh a, [fs_mb+3]
  cp 8
  ret nc
  ld a, [kb_event_write]
  ld c, a
  inc a
  and 15
  ld hl, kb_event_read
  cp [hl]
  ret z ; no echo until input can be kept
  ld [kb_event_write], a
  ld l, c
  ld h, 0
  add hl, hl
  ld de, kb_event_buffer
  add hl, de
  ldh a, [fs_mb+2]
  ld [hli], a
  ldh a, [fs_mb+3]
  ld c, a
  xor a
  bit 0, c
  jr z, .ctrl
  or $40
.ctrl
  bit 1, c
  jr z, .alt
  or $20
.alt
  bit 2, c
  jr z, .modifiers
  or $10
.modifiers
  ld [hl], a
.consumed
  ld a, b
  ldh [fs_ack], a
  ret
FsRead:
  ld a, $20
  ldh [rP1], a
REPT 6
  ldh a, [rP1]
ENDR
  and 15
  ld e, a
  ld a, $10
  ldh [rP1], a
REPT 6
  ldh a, [rP1]
ENDR
  and 15
  swap a
  or e
  ret
ASSERT @ <= _RenderOverlayEnd, "terminal exceeds audited renderer interval"
