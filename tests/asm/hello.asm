; Hello: a checkerboard. Open in FatPak and use FILE > RUN (F5) or BUILD (F7).
DEF rLCDC EQU $FF40
DEF rLY   EQU $FF44
DEF rBGP  EQU $FF47

SECTION "Header", ROM0[$100]
  nop
  jp Start
  ds $150 - @, 0

SECTION "Main", ROM0[$150]
Start:
  di
  ld sp, $FFFE
.vblank
  ldh a, [rLY]
  cp 144
  jr c, .vblank
  xor a
  ldh [rLCDC], a            ; LCD off: VRAM is free
  ld hl, $8000              ; tile 0: light, tile 1: dark checks
  ld de, Tiles
  ld b, Tiles.end - Tiles
.copy
  ld a, [de]
  inc de
  ld [hl+], a
  dec b
  jr nz, .copy
  ld hl, $9800              ; the map alternates them
  ld bc, 32 * 18
.map
  ld a, l
  xor h
  and 1
  ld [hl+], a
  dec bc
  ld a, b
  or c
  jr nz, .map
  ld a, %11100100
  ldh [rBGP], a
  ld a, %10010001           ; LCD on, BG on, tiles at $8000
  ldh [rLCDC], a
.forever
  halt
  nop
  jr .forever

Tiles:
  db $0F, $0F, $0F, $0F, $0F, $0F, $0F, $0F, $F0, $F0, $F0, $F0, $F0, $F0, $F0, $F0
  db $FF, $0F, $FF, $0F, $FF, $0F, $FF, $0F, $FF, $F0, $FF, $F0, $FF, $F0, $FF, $F0
.end
