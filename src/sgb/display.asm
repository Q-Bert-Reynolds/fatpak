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
  push hl
  xor d
  ld l, a
  ld h, HIGH(FsCRCHigh)
  ld a, [hl]
  xor e
  ld d, a
  inc h
  ld e, [hl]
  pop hl
  ret
FsHashRow: ; HL 64-byte source, DE CRC; BC clobbered
  ld a, 8
  ldh [fs_count], a
  ld b, HIGH(FsCRCHigh)
.loop
REPT 8
  ld a, [hli]
  xor d
  ld c, a
  ld a, [bc]
  xor e
  ld d, a
  inc b
  ld a, [bc]
  ld e, a
  dec b
ENDR
  ldh a, [fs_count]
  dec a
  ldh [fs_count], a
  jr nz, .loop
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
  ld a, 2
  call FsLog
FsWait:
  ld a, 8
  call FsLog
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
  ld a, 4
  call FsLog
  ; A stalled repaint may never return to FsInput. Persist its timeout here;
  ; FsLogFlush still excludes active modules and rate-limits SD access.
  call FsLogFlush
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
  ld a, [_osk_shown]
  and a
  ld a, 0
  jr z, .keyboard
  ld a, OSK_ROWS
.keyboard
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
  push de
  call FsScrollHashes
  pop de
  ld a, SGBFS_CMD_SCROLL
  ld bc, 2
  call FsTLV
  ld a, d
  call FsByte
  xor a
  jp FsByte

; The SNES rotates retained text rows, so their published hashes must follow.
; Bars and overlay rows stay fixed. Invalidate only the newly exposed row.
FsScrollHashes: ; D = 1 (down) or $FF (up)
  ld a, [_tb_rows]
  dec a
  add a
  ld b, a
  ld a, [_bars]
  add a
  ld c, a
  ld a, d
  cp 1
  jr nz, .up
  ld d, 0
  ld e, c
  ld hl, wide_row_hashes
  add hl, de
  ld d, h
  ld e, l
  inc de
  inc de
  ld a, b
  and a
  jr z, .invalidate
.forward
  ld a, [de]
  inc de
  ld [hli], a
  dec b
  jr nz, .forward
  jr .invalidate
.up
  ld a, b
  add c
  inc a
  ld e, a
  ld d, 0
  ld hl, wide_row_hashes
  add hl, de
  ld d, h
  ld e, l
  dec de
  dec de
  ld a, b
  and a
  jr z, .firstByte
.backward
  ld a, [de]
  dec de
  ld [hld], a
  dec b
  jr nz, .backward
.firstByte
  dec hl
.invalidate
  ld a, $FF
  ld [hli], a
  ld [hl], a
  ret
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
  call FsUI
  ldh a, [fs_pending]
  and a
  ret nz
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
; Build row geometry and merge equal attributes into runs. Worst-case ROW
; remains 202 bytes, so the existing page reservation bounds a whole command.
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
  ; Hash fixed-size source rows first. Only changed rows need width/RLE work.
  ; Bytes past the visible edge may cause a harmless extra redraw, never stale text.
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
  call FsHashRow
  ldh a, [fs_styled]
  and a
  jr z, .hashed
  ldh a, [fs_attrs]
  ld l, a
  ldh a, [fs_attrs+1]
  ld h, a
  call FsHashRow
.hashed
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
  jr .changed ; HL already points at the high byte after a partial match
.forced
  inc hl
.changed
  ld [hl], d
  dec hl
  ld [hl], e
  ldh a, [fs_chars]
  ld l, a
  ldh a, [fs_chars+1]
  ld h, a
  xor a
  ldh [fs_count], a
  ldh [fs_x], a
  ldh [fs_hash], a ; previous attribute, then run count
  ldh [fs_hash+1], a
.count
  call FsAttr
  ld c, a
  and 15
  ld b, a
  ldh a, [fs_x]
  add b
  jr c, .counted
  cp 249
  jr nc, .counted
  ldh [fs_x], a
  inc hl
  ldh a, [fs_hash]
  cp c
  jr z, .sameAttr
  ld a, c
  ldh [fs_hash], a
  ldh a, [fs_hash+1]
  inc a
  ldh [fs_hash+1], a
.sameAttr
  ldh a, [fs_count]
  inc a
  ldh [fs_count], a
  cp 64
  jr c, .count
.counted
  ld a, [_bars]
  and a
  jr z, .textRow
  ldh a, [fs_row]
  and a
  jp z, FsBar
  cp 27
  jp z, FsBar
.textRow
  ldh a, [fs_count]
  ld c, a
  ldh a, [fs_hash+1]
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
  ; Empty and whole-row selections need no character-to-pixel walk. These
  ; dominate normal typing and browser navigation; partial spans keep it.
  ldh a, [fs_sel_start]
  and a
  jr nz, .slowSelection
  ldh a, [fs_sel_end]
  and a
  jr z, .simpleSelection
  cp $FF
  jr z, .simpleSelection
.slowSelection
  ldh a, [fs_sel_end]
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
.simpleSelection
  ldh [fs_sel_end], a
  xor a
  ldh [fs_sel_start], a
.selectionDone
  ldh a, [fs_sel_start]
  call FsByte
  ldh a, [fs_sel_end]
  call FsByte
  ldh a, [fs_count]
  call FsByte
  ldh a, [fs_hash+1]
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
  call FsAttrAtX
  ld d, a
  ld e, 0
.sameRun
  inc e
  ldh a, [fs_x]
  inc a
  ldh [fs_x], a
  ld b, a
  ldh a, [fs_count]
  cp b
  jr z, .lastRun
  call FsAttrAtX
  cp d
  jr z, .sameRun
  ld a, e
  call FsByte
  ld a, d
  call FsByte
  jr .runs
.lastRun
  ld a, e
  call FsByte
  ld a, d
  call FsByte
.done
  ret
FsAttr:
  ldh a, [fs_count]
  jr FsAttrIndex
FsAttrAtX:
  ldh a, [fs_x]
; Clobbers HL/BC; DE holds the live RLE run in the emitter.
FsAttrIndex:
  push de
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
  ldh a, [fs_chars]
  ld l, a
  ldh a, [fs_chars+1]
  ld h, a
  add hl, bc
  ld a, [hl]
  cp FOOTER_MARKER
  ld a, 1
  jr z, .return
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
  pop de
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
  ld a, [oam_buffer+1]
  sub 8 ; remove the GB sprite offset; SNES text starts at screen X=0
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
  ldh [fs_log_active], a
  ld hl, fs_ready
  ld bc, fs_state_end-fs_ready
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
  ; Own VBlank before any helper can restore interrupts during startup.
  ; The initial redraw uses P1 for the mailbox; the BIOS-mode handler's
  ; LatchPad would otherwise change controller selection in the middle of it.
  ; The bootstrap clears this flag and restores the renderer on failure.
  ldh a, [sys_info]
  or 4
  ldh [sys_info], a
  call FsLogInit
  ; Upload and its file read are finished. Persist this build's header before
  ; any page wait, while the bootstrap still owns an otherwise idle filesystem.
  call FsLogWrite
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
  ; The bootstrap and its initial draw are over. Later module callbacks may
  ; have a file open, so only the ordinary idle/timeout flush may write now.
  ldh a, [fs_log_active]
  cp 2
  jr nz, .loggingReady
  dec a
  ldh [fs_log_active], a
.loggingReady
  ldh a, [button_state]
  ldh [last_button_state], a
  call FsPoll
  call FsLogFlush
  ldh a, [fs_deferred]
  and a
  call nz, FsDraw
  ldh a, [fs_pending]
  and a
  jr nz, .keyboard
  ldh a, [fs_fault]
  and a
  jr nz, .keyboard
  call FsBegin
  call FsUI
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
  jr z, .flush
  call FsCursor
.flush
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
  ld a, [_render_frames]
  push bc
  ld b, a
  ldh a, [rLY]
  cp 144
  jr c, .vblank
.visible
  ; The interrupt may cover all of VBlank. Do not require foreground code
  ; to observe LY >= 144 after its handler has already advanced the clock.
  ld a, [_render_frames]
  cp b
  jr nz, .advanced
  ldh a, [rLY]
  cp 144
  jr nc, .visible
.vblank
  ld a, [_render_frames]
  cp b
  jr nz, .advanced
  ldh a, [rLY]
  cp 144
  jr c, .vblank
  ; IE does not tell us whether IME allowed the VBlank handler to run.
  ; After a physical frame, publish status ourselves if it did not advance.
  ld a, [_render_frames]
  cp b
  pop bc
  ret nz
  jp FsTick
.advanced
  pop bc
  ret
FsTick:
  ld hl, _render_frames
  inc [hl]
  jr nz, .counted
  inc hl
  inc [hl]
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
  call FsSettle
  and 15
  cp 15
  jr z, .one
  ld a, $10
  ldh [rP1], a
  call FsSettle
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
  cp SGBFS_EVENT_DIAG_GOOD
  jr c, .ordinary
  cp SGBFS_EVENT_DIAG_FRAME+1
  ret nc
  call FsLog
  jp .consumed
.ordinary
  cp SGBFS_EVENT_HELLO
  jr z, .hello
  cp SGBFS_EVENT_ACK
  jr z, .ack
  cp SGBFS_EVENT_KEY
  jr z, .key
  cp SGBFS_EVENT_PAD
  jr z, .pad
  cp SGBFS_EVENT_MOUSE_MOVE+1
  ret nc
  jr .consumed
.pad
  ldh a, [fs_mb+2]
  ldh [button_state], a
  ldh a, [fs_mb+3]
  ld c, a
  ldh a, [pad_latch]
  or c
  ldh [pad_latch], a
  ld a, 9
  call FsLog
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
  ; A matching late ACK completes the preserved page. Resume publication
  ; even if FsWait previously reached its deadline; unrelated ACKs cannot.
  ldh [fs_fault], a
  ld a, 3
  call FsLog
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
  ld a, 5
  call FsLog
.consumed
  ld a, b
  ldh [fs_ack], a
  ret
FsRead:
  ; Match the slow, hardware-tested bench reader, including the released
  ; selection between slots. VBlank never writes P1 in fullscreen mode.
  call FsSettle
  ld a, $20
  ldh [rP1], a
  call FsSettle
  and 15
  ld e, a
  ld a, $10
  ldh [rP1], a
  call FsSettle
  and 15
  swap a
  or e
  ret
FsSettle:
  push bc
  ld b, 32
.wait
  ldh a, [rP1]
  dec b
  jr nz, .wait
  pop bc
  ret


FsBar:
  ldh a, [fs_count]
  add 3
  ld c, a
  ld b, 0
  ld a, SGBFS_CMD_BAR
  call FsTLV
  ldh a, [fs_row]
  and a
  ld a, 0
  jr z, .which
  inc a
.which
  call FsByte
  ldh a, [fs_font]
  call FsByte
  ldh a, [fs_count]
  call FsByte
  ld b, a
  ldh a, [fs_chars]
  ld l, a
  ldh a, [fs_chars+1]
  ld h, a
  ld a, b
  and a
  ret z
.loop
  ld a, [hli]
  call FsByte
  dec b
  jr nz, .loop
  ret
FsUI:
  ; Reserve the entire largest UI update; BOX lines never split a TLV.
  ldh a, [fs_write+1]
  cp $85
  jr c, .room
  call FsFlush
  ldh a, [fs_pending]
  and a
  ret nz
.room
  ldh a, [fs_force]
  and a
  jr nz, .box
  ld a, [_render_box_top]
  ld b, a
  ldh a, [fs_box_top]
  cp b
  jr nz, .box
  ld a, [_render_box_gen]
  ld b, a
  ldh a, [fs_box_gen]
  cp b
  jp z, .highlight
.box
  ld a, SGBFS_CMD_BOX
  ld bc, 5
  call FsTLV
  ld a, [_render_box_top]
  cp $FF
  jr nz, .open
  ld b, 5
.close
  xor a
  call FsByte
  dec b
  jr nz, .close
  jp .rememberBox
.open
  ld a, [_render_box_x]
  call FsByte
  ld a, [_render_box_w]
  call FsByte
  xor a
  call FsByte
  ld a, [_render_box_top]
  call FsByte
  ld a, [_render_box_rows]
  call FsByte
  xor a
  ldh [fs_box_line], a
.lines
  ldh a, [fs_box_line]
  and a
  jr z, .empty
  ld b, a
  ld a, [_render_box_rows]
  dec a
  cp b
  jr z, .empty
  ld a, b
  dec a
  call _BoxLine
  ld h, b
  ld l, c
  ld b, 0
.count
  ld a, [hli]
  and a
  jr z, .counted
  inc b
  ld a, b
  cp BOX_STRIDE-1
  jr c, .count
.counted
  push bc
  ld a, b
  add 3
  ld c, a
  ld b, 0
  ld a, SGBFS_CMD_BOX_LINE
  call FsTLV
  ldh a, [fs_box_line]
  call FsByte
  ld a, 1
  call FsByte
  pop bc
  ld a, b
  call FsByte
  ld hl, wide_scratch
  and a
  jr z, .next
.chars
  ld a, [hli]
  call FsByte
  dec b
  jr nz, .chars
  jr .next
.empty
  ld a, SGBFS_CMD_BOX_LINE
  ld bc, 3
  call FsTLV
  ldh a, [fs_box_line]
  call FsByte
  ld a, 1
  call FsByte
  xor a
  call FsByte
.next
  ldh a, [fs_box_line]
  inc a
  ldh [fs_box_line], a
  ld b, a
  ld a, [_render_box_rows]
  cp b
  jp nz, .lines
.rememberBox
  ld a, [_render_box_top]
  ldh [fs_box_top], a
  ld a, [_render_box_gen]
  ldh [fs_box_gen], a
  ld a, $FE
  ldh [fs_box_sel], a
.highlight
  ld a, [_render_box_top]
  cp $FF
  jr z, .osk
  ld a, [_render_box_sel]
  ld b, a
  ldh a, [fs_box_sel]
  cp b
  jr z, .osk
  ld a, b
  ldh [fs_box_sel], a
  push af
  ld a, SGBFS_CMD_BOX_HI
  ld bc, 1
  call FsTLV
  pop af
  call FsByte
.osk
  ld a, [oam_buffer+4]
  and a
  ld a, $FF
  jr z, .key
  ld a, [_osk_y]
  ld b, a
  add a
  add a
  add b
  add a
  ld b, a
  ld a, [_osk_x]
  add b
.key
  ld c, a
  ldh a, [fs_force]
  and a
  jr nz, .oskChanged
  ldh a, [fs_osk_key]
  cp c
  jr nz, .oskChanged
  ld a, [_osk_layer]
  ld b, a
  ldh a, [fs_osk_layer]
  cp b
  jr z, .busyState
.oskChanged
  ld a, c
  ldh [fs_osk_key], a
  ld a, [_osk_layer]
  ldh [fs_osk_layer], a
  ld a, SGBFS_CMD_OSK
  ld bc, 2
  call FsTLV
  ldh a, [fs_osk_layer]
  call FsByte
  ldh a, [fs_osk_key]
  call FsByte
.busyState
  ld a, [_module_busy]
  ld b, a
  ldh a, [fs_busy]
  cp b
  jr z, .progress
  ld a, b
  ldh [fs_busy], a
  and a
  ld a, 0
  jr z, .busy
  inc a
.busy
  push af
  ld a, SGBFS_CMD_BUSY
  ld bc, 1
  call FsTLV
  pop af
  call FsByte
.progress
  ld hl, fs_progress_loaded
  ld de, fs_progress_sent
  ld b, 4
.compareProgress
  ld a, [de]
  cp [hl]
  jr nz, .sendProgress
  inc hl
  inc de
  dec b
  jr nz, .compareProgress
  ret
.sendProgress
  ld hl, fs_progress_loaded
  ld de, fs_progress_sent
  ld b, 4
.rememberProgress
  ld a, [hli]
  ld [de], a
  inc de
  dec b
  jr nz, .rememberProgress
  ld a, SGBFS_CMD_PROGRESS
  ld bc, 8
  call FsTLV
  ld hl, fs_progress_loaded
  call FsKiB
  ld hl, fs_progress_total
  jp FsKiB
FsKiB:
  inc hl
  ld a, [hld]
  srl a
  ld b, a
  ld a, [hl]
  rra
  call FsByte
  ld a, b
  call FsByte
  xor a
  call FsByte
  jp FsByte
; Binary flight recorder. The first 8 KiB of SGB_FILE staging is free once
; upload finishes. Records never touch document, undo, or assembler scratch.
; SD writes happen only from ordinary input, never from the VBlank handler.
FsLogInit:
IF DEF(SGB_LOG_DISABLE)
  ret ; FsInit cleared fs_log_active; control build performs no recorder I/O.
ENDC
  xor a
  ldh [fs_log_size], a
  ldh [fs_log_size+1], a
  ldh [fs_log_dirty], a
  ldh [fs_log_tick], a
  ldh [fs_log_tick+1], a
  ld a, 2 ; bootstrap owns an idle filesystem until the first input callback
  ldh [fs_log_active], a
  call FsLogWindow
  push bc
  ld de, FsLogHeader
  ld b, 16
.header
  ld a, [de]
  inc de
  call FsLogByte
  dec b
  jr nz, .header
  ld a, [$014E]
  ld [$BE08], a
  ld a, [$014F]
  ld [$BE09], a
  ; Preserve the validated SGB.DAT CRC before records reuse its staging area.
  ld a, [$BE1A]
  ld [$BE0B], a
  ld a, [$BE1B]
  ld [$BE0C], a
  pop bc
  call FsLogRestore
  ld a, 1
  jp FsLog
FsLogHeader:
  DB "SGBLOG1", 0, 0, 0, 12, 0, 0, 0, 0, 0
FsLogPath:
  DB "/GBCSYS/SGB.LOG", 0
FsLogWindow:
  ld a, [$BD03]
  ld b, a
  ld a, [$BD02]
  ld c, a
  ld a, HIGH(SGB_FILE_BLOCK)
  ld [$BD03], a
  ldh a, [fs_log_size+1]
  srl a
  add LOW(SGB_FILE_BLOCK)
  ld [$BD02], a
  ldh a, [fs_log_size]
  ld l, a
  ldh a, [fs_log_size+1]
  and 1
  add $BE
  ld h, a
  ret
FsLogRestore:
  ld a, b
  ld [$BD03], a
  ld a, c
  ld [$BD02], a
  ret
FsLogByte:
  ld [hli], a
  ldh a, [fs_log_size]
  inc a
  ldh [fs_log_size], a
  jr nz, .counted
  ldh a, [fs_log_size+1]
  inc a
  ldh [fs_log_size+1], a
.counted
  ld a, h
  cp $C0
  ret nz
  ld h, $BE
  ld a, [$BD02]
  inc a
  ld [$BD02], a
  ret
FsLog:
  push af
  push bc
  push de
  push hl
  ld d, a
  ldh a, [fs_log_active]
  and a
  jp z, .done
  ldh a, [fs_log_size+1]
  cp $1F
  jp nc, .done
  call FsLogWindow
  push bc
  ld a, d
  call FsLogByte
  ldh a, [fs_seq]
  call FsLogByte
.frame
  ld a, [_render_frames+1]
  ld b, a
  ld a, [_render_frames]
  ld c, a
  ld a, [_render_frames+1]
  cp b
  jr nz, .frame
  ld a, c
  call FsLogByte
  ld a, b
  call FsLogByte
  ldh a, [fs_pending]
  call FsLogByte
  ldh a, [fs_fault]
  call FsLogByte
  ldh a, [fs_mb]
  call FsLogByte
  ldh a, [fs_mb+1]
  call FsLogByte
  ld a, d
  cp 8
  jr z, .waitState
  ldh a, [fs_mb+2]
  call FsLogByte
  ldh a, [fs_mb+3]
  call FsLogByte
  ld a, d
  cp 7
  jr z, .writeError
  cp 6
  jr z, .flushTime
  ldh a, [fs_row]
  call FsLogByte
  ldh a, [fs_deferred]
  jr .last
.flushTime
  ldh a, [fs_log_tick]
  call FsLogByte
  ldh a, [fs_log_tick+1]
  jr .last
.writeError
  ld a, e ; FatFs result supplied by FsLogFlush
  call FsLogByte
  xor a
  jr .last
.waitState
  ldh a, [rLCDC]
  call FsLogByte
  ldh a, [rLY]
  call FsLogByte
  ldh a, [rIE]
  call FsLogByte
  ldh a, [rIF]
.last
  call FsLogByte
  pop bc
  call FsLogRestore
  ld a, 1
  ldh [fs_log_dirty], a
  ; Initial drawing can stall before reaching FsInput, with module_busy set.
  ; Its source file is already closed. Save each page exchange now, while
  ; later module callbacks retain the normal no-filesystem-recursion guard.
  ldh a, [fs_log_active]
  cp 2
  jr nz, .done
  ld a, d
  cp 8
  jr z, .persist
  cp 2
  jr c, .done
  cp 5
  jr nc, .done
.persist
  call FsLogWrite
.done
  pop hl
  pop de
  pop bc
  pop af
  ret
FsLogFlush:
  ldh a, [fs_log_active]
  and a
  ret z
  ldh a, [fs_log_dirty]
  and a
  ret z
  ld a, [_module_busy]
  and a
  ret nz
  ldh a, [fs_pending]
  and a
  jr z, .idle
  ldh a, [fs_fault]
  and a
  ret z
.idle
  ld a, [_render_frames]
  ld e, a
  ldh a, [fs_log_tick]
  ld c, a
  ld a, e
  sub c
  ld e, a
  ld a, [_render_frames+1]
  ld d, a
  ldh a, [fs_log_tick+1]
  ld c, a
  ld a, d
  sbc c
  jr nz, FsLogWrite
  ld a, e
  cp 240
  ret c
FsLogWrite:
  ldh a, [fs_log_active]
  and a
  ret z
  ld a, [_render_frames]
  ldh [fs_log_tick], a
  ld a, [_render_frames+1]
  ldh [fs_log_tick+1], a
  ld a, [$BD03]
  ld b, a
  ld a, [$BD02]
  ld c, a
  push bc
  ld de, FsLogPath
  ldh a, [fs_log_size]
  ld c, a
  ldh a, [fs_log_size+1]
  or $C0
  ld b, a
  ; The first hardware trace stopped at the first write with VBlank active.
  ; Keep the SPI/file operation isolated from interrupt callbacks without
  ; changing the caller's IME or discarding its pending interrupt requests.
  ldh a, [rIE]
  push af
  xor a
  ldh [rIE], a
  call _FileWriteImage
  ld d, a
  pop af
  ldh [rIE], a
  pop bc
  call FsLogRestore
  xor a
  ldh [fs_log_dirty], a
  ld a, d
  and a
  jr z, .ok
  ; A transient SD failure must not discard the rest of the hardware trace.
  ; Keep recording and retry on the next interval; preserve the error code.
  ld e, a
  ld a, 7
  jp FsLog
.ok
  ld a, 6
  jp FsLog
ASSERT @ <= _RenderOverlayEnd, "terminal exceeds audited renderer interval"

; Split, page-aligned CCITT tables avoid a multiply/add for each lookup.
; They occupy existing overlay space, without additional WRAM or upload bytes.
SECTION "Terminal CRC tables", ROMX[$5000], BANK[1]
FsCRCHigh:
FOR index, 256
  DEF value = index << 8
  REPT 8
    IF value & $8000
      REDEF value = ((value << 1) ^ $1021) & $FFFF
    ELSE
      REDEF value = (value << 1) & $FFFF
    ENDC
  ENDR
  DB HIGH(value)
  PURGE value
ENDR
FsCRCLow:
FOR index, 256
  DEF value = index << 8
  REPT 8
    IF value & $8000
      REDEF value = ((value << 1) ^ $1021) & $FFFF
    ELSE
      REDEF value = (value << 1) & $FFFF
    ENDC
  ENDR
  DB LOW(value)
  PURGE value
ENDR
ASSERT LOW(FsCRCHigh) == 0 && FsCRCLow == FsCRCHigh+256
ASSERT @ <= _RenderOverlayEnd, "CRC tables exceed audited renderer interval"
