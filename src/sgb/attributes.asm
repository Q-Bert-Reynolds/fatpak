;SGB colours at 160x144. The SGB has 4 palettes (SGBThemePalettes, src/ui/theme.asm, picks them from the
;theme's 8: sgb_pal_map) and a palette for each of the screen's 20x18 cells, which ATTR_CHR sets. The GB
;renderer records the palettes of each block's tiles (SGBRecordRow, src/ui/render.asm: GBC's map attributes'
;palettes) in sgb_attr_rows, 2 bits a tile. SGBAttrFlush (WaitFrame) lays them out as the screen shows them
;(_render_row_blocks) and sends a pair of rows that changed since it was sent: one single-packet command, at
;most every SGB_PACKET_GAP frames, so scrolling's colours come a few frames late.
;The BIOS takes a packet a frame (the real BIOSes in Mesen: packets back to back are lost, a frame apart in a
;command arrive, commands a frame apart sometimes don't), so another packet in the same frame replaces one:
;the mouse bridge's ACK must never be the one lost (SGBPacketAck).
;While a module has the BG map (ModBackground), sgb_attr_rows are the screen's rows and the module's
;(SGBModuleColors), and the SGB's palettes may be its own until ModBackground(0) applies the theme again.

DEF SGB_PACKET_GAP EQU 2;frames from a packet to an attribute packet, and from one to the bridge's ACK

SECTION "SGB attributes", ROM0

;every pair of rows sent again, all palette 0 meanwhile (RenderSetup: the BIOS's attributes aren't known)
SGBAttrReset::
  ld a, $FF;never a hash (SGBAttrPacket's bit 15 is 0): every pair differs
  ld hl, sgb_attr_sent
  ld bc, SGB_ATTR_PAIRS*2
  call mem_Set
  ld a, [_render_frames]
  sub a, SGB_PACKET_GAP
  ldh [sgb_attr_frame], a
  ldh [sgb_packet_frame], a
SGBAttrClear::;every cell palette 0, affects a, hl, preserves bc, de
  ld hl, sgb_attr_rows
  ld a, TB_ROWS*5
.clear
    ld [hl], 0
    inc hl
    dec a
    jr nz, .clear
  ret

;C: _WaitFrame, each frame: a pair of rows whose palettes changed, if no packet was sent in the last
;SGB_PACKET_GAP frames
SGBAttrFlush::
  ldh a, [sys_info]
  and a, SYS_INFO_SGB | SYS_INFO_GBC | SYS_INFO_SGBFS
  cp a, SYS_INFO_SGB
  ret nz
  ld a, [_render_pending];(the rows' blocks aren't the screen's until it scrolls)
  and a
  ret nz
  ld a, [_render_frames]
  ld b, a
  ldh a, [sgb_packet_frame]
  ld c, a
  ld a, b
  sub a, c
  cp a, SGB_PACKET_GAP
  ret c
  ldh a, [sgb_attr_frame]
  ld c, a
  ld a, b
  sub a, c
  cp a, SGB_PACKET_GAP
  ret c
  ld c, 0
.pair
    push bc
    call SGBAttrPacket
    pop bc
    ld a, c
    add a, a
    add a, LOW(sgb_attr_sent)
    ld e, a
    adc a, HIGH(sgb_attr_sent)
    sub a, e
    ld d, a
    ld a, [de]
    cp a, l
    jr nz, .send
    inc de
    ld a, [de]
    cp a, h
    jr nz, .sendHigh
    inc c
    ld a, c
    cp a, SGB_ATTR_PAIRS
    jr c, .pair
  ret
.send
  ld a, l
  ld [de], a
  inc de
.sendHigh
  ld a, h
  ld [de], a
  ld a, [_render_frames]
  ldh [sgb_attr_frame], a
  call SGBInputBegin
  push af
  ld hl, cmd_buffer
  call sgb_PacketTransferFast
  pop af
  jp SGBInputEnd

;c = a pair of screen rows: their ATTR_CHR packet in cmd_buffer, returns hl = a hash of its cells
SGBAttrPacket:
  ld hl, cmd_buffer
  ld a, SGB_CODE_ATTR_CHR << 3 | 1
  ld [hli], a
  xor a
  ld [hli], a;x
  ld a, c
  add a, a
  ld [hli], a;y
  ld b, a
  ld a, TB_COLS*2
  ld [hli], a;cells
  xor a
  ld [hli], a
  ld [hli], a;left to right, then the next row
  ld d, a
  ld e, a
  call .row
  inc b
  call .row
  xor a
REPT 5
  ld [hli], a
ENDR
  res 7, d
  ld h, d
  ld l, e
  ret
.row;b = screen row, hl = to, de = the hash; returns hl past its 5 bytes
  push bc
  push hl
  ldh a, [render_background]
  and a
  ld a, b
  jr nz, .index;a module's: the screen's rows
  ld hl, _render_row_blocks
  add a, l
  ld l, a
  adc a, h
  sub a, l
  ld h, a
  ld a, [hl]
.index
  ld c, a
  add a, a
  add a, a
  add a, c
  add a, LOW(sgb_attr_rows)
  ld l, a
  adc a, HIGH(sgb_attr_rows)
  sub a, l
  ld h, a
  pop bc;to
REPT 5
  ld a, e
  rlca
  xor a, [hl]
  ld e, a
  add a, d
  ld d, a
  ld a, [hli]
  ld [bc], a
  inc bc
ENDR
  ld h, b
  ld l, c
  pop bc
  ret

;the SNES mouse driver's ACK (src/keyboard/driver_snes_mouse.asm), hl = its packet: not within SGB_PACKET_GAP
;frames of an attribute packet, which it would replace or be replaced by (a lost ACK stops the bridge's reports)
SGBPacketAck::
  ld de, $0C00;about 2 frames, should the frame count stop
.wait
  ld a, [_render_frames]
  ld b, a
  ldh a, [sgb_attr_frame]
  ld c, a
  ld a, b
  sub a, c
  cp a, SGB_PACKET_GAP
  jr nc, .send
  dec de
  ld a, d
  or a, e
  jr nz, .wait
.send
  ld a, [_render_frames]
  ldh [sgb_packet_frame], a
  jp sgb_PacketTransferFast

;ModBackground's modes on an SGB at 160x144 while a module has the BG map (ABI 13; MAPVIEW.MOD): 8, de = 2
;packets, PAL01 and PAL23 (its palettes), sent now; 9, de = the screen's 360 palettes, 2 bits each, rows of 20
;left to right (90 bytes), sent as they change. Elsewhere (GBC, DMG, fullscreen) nothing
SGBModuleColors:
  ld b, a
  ldh a, [sys_info]
  and a, SYS_INFO_SGB | SYS_INFO_GBC
  cp a, SYS_INFO_SGB
  ret nz
  ldh a, [render_background]
  and a
  ret z
  ld h, d
  ld l, e
  bit 0, b
  jr nz, .cells
  call SGBInputBegin
  push af
  call _sgb_PacketTransfer;(each waits its 4 frames)
  call _sgb_PacketTransfer
  pop af
  jp SGBInputEnd
.cells
  ld de, sgb_attr_rows
  ld bc, TB_ROWS*5
  jp mem_Copy
