INCLUDE "src/hardware.inc"
; The SGB BIOS's pace for FatPak's attributes at 160x144 (src/sgb/attributes.asm): PAL01 and PAL23, then the whole
; screen as 9 single-packet ATTR_CHRs (2 rows each) GAP frames apart, as the OS sends them; then two 1-packet
; ATTR_CHRs a frame apart, which tests/sgb/attr.lua only reports (the SGB's GB frame is shorter than the SNES's:
; both can land in one SNES frame, and the BIOS takes a packet a frame). $C100: $A1 the screen sent, $A2 the rows.
; Measured 2026-11-26: 6 packets of one command back to back are lost (a frame apart they arrive); GAP 2 passes on
; SGB1 1.0, 1.1, 1.2 and SGB2. Built and run by tests/run_sgb_attr.sh.
IF !DEF(GAP)
DEF GAP EQU 2
ENDC
SECTION "Header", ROM0[$100]
  nop
  jp Main
  DS $150 - @, 0
SECTION "Main", ROM0[$150]
Main:
  di
  ld sp, $DFFF
  xor a
  ld [$C100], a
  call WaitVBlank
  xor a
  ldh [rLCDC], a
  ld hl, $8010 ; tile 1: colour 3
  ld b, 16
.tile
  ld a, $FF
  ld [hli], a
  dec b
  jr nz, .tile
  ld hl, $9800
  ld bc, $400
.map
  ld a, 1
  ld [hli], a
  dec bc
  ld a, b
  or c
  jr nz, .map
  ld a, $E4
  ldh [rBGP], a
  ld a, LCDCF_ON | LCDCF_BGON | LCDCF_BG8000 | LCDCF_BG9800
  ldh [rLCDC], a
  ld b, 0
  call Frames
  ld b, 0
  call Frames
  ld hl, Pal01
  call Send
  ld b, 6
  call Frames
  ld hl, Pal23
  call Send
  ld b, 6
  call Frames
  ld hl, AttrPairs ; 9 single-packet commands, GAP frames apart (the OS's pace)
  ld c, 9
.screen
  push bc
  call Send
  ld b, GAP
  call Frames
  pop bc
  dec c
  jr nz, .screen
  ld a, $A1
  ld [$C100], a
  ld b, 30
  call Frames
  ld hl, AttrRow0
  call Send
  ld b, 1
  call Frames
  ld hl, AttrRow1
  call Send
  ld a, $A2
  ld [$C100], a
.idle
  jr .idle

Frames: ; b frames
  call WaitVBlank
  dec b
  jr nz, Frames
  ret
WaitVBlank:
.out
  ldh a, [rLY]
  cp 144
  jr z, .out
.in
  ldh a, [rLY]
  cp 144
  jr nz, .in
  ret

; hl = a packet's 16 bytes, returns hl past them
Send:
  xor a
  ldh [rP1], a
  ld a, $30
  ldh [rP1], a
  ld b, 16
.byte
  ld e, 8
  ld a, [hli]
  ld d, a
.bit
  bit 0, d
  ld a, $10
  jr nz, .one
  ld a, $20
.one
  ldh [rP1], a
  ld a, $30
  ldh [rP1], a
  rr d
  dec e
  jr nz, .bit
  dec b
  jr nz, .byte
  ld a, $20
  ldh [rP1], a
  ld a, $30
  ldh [rP1], a
  ret

MACRO RGB
  DW (\3 << 10) | (\2 << 5) | \1
ENDM
Pal01: DB $01
  RGB 0, 0, 0
  RGB 31, 0, 0
  RGB 31, 0, 0
  RGB 31, 0, 0 ; palette 0: red
  RGB 0, 31, 0
  RGB 0, 31, 0
  RGB 0, 31, 0 ; palette 1: green
  DB 0
Pal23: DB $09
  RGB 0, 0, 0
  RGB 0, 0, 31
  RGB 0, 0, 31
  RGB 0, 0, 31 ; palette 2: blue
  RGB 31, 31, 31
  RGB 31, 31, 31
  RGB 31, 31, 31 ; palette 3: white
  DB 0
AttrPairs: ; rows 2k and 2k+1: cell (x, y): (x + y) & 3
FOR K, 9
  DB $39, 0, K * 2, 40, 0, 0
  FOR Y, K * 2, K * 2 + 2
    FOR X, 0, 20, 4
      DB ((X + Y) & 3) << 6 | ((X + 1 + Y) & 3) << 4 | ((X + 2 + Y) & 3) << 2 | ((X + 3 + Y) & 3)
    ENDR
  ENDR
ENDR
AttrRow0: ; 1 packet: row 0 all palette 3
  DB $39, 0, 0, 20, 0, 0
  DB $FF, $FF, $FF, $FF, $FF
  DS 5, 0
AttrRow1: ; 1 packet: row 1 all palette 0
  DB $39, 0, 1, 20, 0, 0
  DB 0, 0, 0, 0, 0
  DS 5, 0
