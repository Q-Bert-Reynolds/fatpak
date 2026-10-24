DEF TILE_ANIM_SIZE         EQU 6;bytes... type, id, bank, address, speed
DEF TILE_ANIM_MAX_COUNT    EQU 4
DEF TILE_ANIM_BUFFER_SIZE  EQU 1 + TILE_ANIM_MAX_COUNT * TILE_ANIM_SIZE

DEF TILE_ANIM_TYPE_LINEAR  EQU 0
DEF TILE_ANIM_TYPE_SCROLL  EQU 1
DEF TILE_ANIM_TYPE_SINE    EQU 2
DEF TILE_ANIM_TYPE_TEXTURE EQU 3

MACRO CALC_VRAM_ADDRESS;a = tile id, puts VRAM address in hl
  swap a
  ld h, a
  and a, $F0
  ld l, a
  ld a, h
  and a, $F
  add a, HIGH(_VRAM8800)
  ld h, a
ENDM

SECTION "Tile Animation WRAMX", WRAMX
tile_anim_timer: DB
tile_anim_buffer:: DS TILE_ANIM_BUFFER_SIZE;byte 0 is count

SECTION "Tile Animation ROM0", ROM0
;hl = address of tile id
;puts tile bytes in tile_buffer
;returns address of next tile in hl
TextureTileAnimation:
  ld a, [tile_anim_timer]
  and a, $F
  ret nz
  
  ld a, [tile_anim_timer]
  swap a
  and a, %11;TODO: read frame count
  push af;frame

.calcVRAM
  ld a, [hli];tile id
  push hl;tile bank address
  
  CALC_VRAM_ADDRESS

.readTileData
  pop de;tile bank address
  pop af;frame
  push hl;vram address
  push af;frame
  ld a, [de];bank
  ld [rROMB0], a
  inc de
  ld a, [de];tile data address
  ld l, a
  inc de
  ld a, [de]
  ld h, a;tile data in hl
  inc de;discard speed
  pop af;frame
  inc de
  ld bc, 16
  and a
  jr z, .writeToVRAM
.loop
    add hl, bc
    dec a
    jr nz, .loop

.writeToVRAM
  pop bc;vram address
REPT 16
  ld a, [hli]
  ld [bc], a
  inc bc
ENDR

  ldh a, [loaded_bank]
  ld [rROMB0], a
  ret 

SECTION "Tile Animation ROMX", ROMX
UpdateTileAnimations:
  ld hl, tile_anim_buffer
  ld a, [hli];tile count
  ld c, a;tile count
  and a
  ret z

  ld a, [tile_anim_timer]
  inc a
  ld [tile_anim_timer], a

  ld a, c;tile count
.loopTiles
    push af;tiles left
    ld a, [hli];type
    ;TODO: calc VRAM address here instead of in anim routines

    ld de, .returnAddress
    push de;return address
    cp TILE_ANIM_TYPE_LINEAR
    jp z, LinearTileAnimation
    cp TILE_ANIM_TYPE_SCROLL
    jp z, ScrollTileAnimation
    cp TILE_ANIM_TYPE_SINE
    jp z, SineTileAnimation
    cp TILE_ANIM_TYPE_TEXTURE
    jp z, TextureTileAnimation
    pop de;return address
    
  .returnAddress
    pop af;tiles left
    dec a;tiles left
    jr nz, .loopTiles
  ret

TileOffsetSinTable:
DB 0, 0, 0, 0, 1, 0, 1, 0;continued in TileOffsetCosTable
TileOffsetCosTable:
DB 1, 1, 0, 1, 0, 1, 0, 1, 0, 0, 0, 0, -1, 0, -1, 0, -1, 0, -1, -1, 0, -1, 0, -1, 0, 0, 0, 0, 1, 0, 1, 0

SineTileAnimation:
  ld a, [hli];tile id
  ld b, a;tile id
  ld a, [tile_anim_timer]
  and 1
  jr z, .testX
  ld bc, 4
  add hl, bc
  ret
.testX
  push bc;b = tile id
  ld d, 0
  ld a, [hli]
  ld c, a;x speed
  bit 7, a
  jr z, .posSpeedX
  call math_Abs
.posSpeedX
  and a, %111
  ld b, a
  ld a, [hl];frames left in lowest 3 bits
  dec a
  and a, %111;frames left
  jr nz, .noXStep
.stepX
  ld a, [hl]
  and a, %11111000
  add a, %1000
  or a, b;reset frames left
  ld [hli], a
  rrca
  rrca
  rrca
  and a, %11111
  ld e, a
  push hl
  ld hl, TileOffsetCosTable
  add hl, de
  ld a, [hl];x offset
  bit 7, c
  jr z, .setXOffset
  cpl
  inc a
.setXOffset
  ld d, a
  pop hl
  jr .testY
.noXStep
  ld a, [hl]
  dec a
  ld [hli], a
.testY
  ld e, 0;y offset
  ld a, [hli]
  ld c, a
  bit 7, a
  jr z, .posSpeedY
  call math_Abs
.posSpeedY
  and %111;max speed is 7
  ld b, a;y speed
  ld a, [hl];frames left in lowest 3 bits
  dec a
  and %111;frames left
  jr nz, .noYStep
.stepY
  ld a, [hl]
  and %11111000
  add a, %1000
  or a, b;reset frames left
  ld [hli], a
  rrca
  rrca
  rrca
  and a, %11111
  push bc
  ld b, 0
  ld c, a
  push hl
  ld hl, TileOffsetSinTable
  add hl, bc
  ld a, [hl];y offset
  pop hl
  pop bc
  bit 7, c
  jr z, .setYOffset
  cpl
  inc a
.setYOffset
  ld e, a
  jr .checkOffset
.noYStep
  ld a, [hl]
  dec a
  ld [hli], a
.checkOffset
  pop bc;b = tile id
  ld a, d
  or a, e
  ret z;no rotation
.rotateTile
  push hl;next tile
  ld a, b;tile id
  CALC_VRAM_ADDRESS
  call RotateTileByOne
  pop hl;next tile
  ret


LinearTileAnimation:
  ld a, [hli];tile id
  ld b, a;tile id
.testX
  ld d, 0
  ld a, [hli]
  ld c, a;x speed
  ld a, [hl];x frames left before step
  dec a
  jr nz, .updateXFrame
  inc d
  ld a, c;reset x frame to |x speed|
  bit 7, a
  jr z, .updateXFrame
  ld d, -1
  call math_Abs
.updateXFrame
  ld [hli], a
.testY
  ld e, 0
  ld a, [hli]
  ld c, a;y speed
  ld a, [hl];y frames left before step
  dec a
  jr nz, .updateYFrame
  inc e
  ld a, c;reset y frame to |y speed|
  bit 7, a
  jr z, .updateYFrame
  ld e, -1
  call math_Abs
.updateYFrame
  ld [hli], a
.checkOffset
  ld a, d
  or e
  ret z;no rotation
.rotateTile
  push hl;next tile
  ld a, b;tile id
  CALC_VRAM_ADDRESS
  call RotateTileByOne
  pop hl;next tile
  ret

CalcScroll:;a = diff, c = shifts, hl = accumulator address, returns rotation in a, clobbers bc, increments hl
  and a
  jr z, .noChange
  ld b, a;diff
  ld a, c;shifts
  ld c, 0;frac
  and a
  jr z, .addAccum;no shift
.shiftLoop
  sra b;shift right, keep sign
  rr c;rotate carry into frac
  dec a
  jr nz, .shiftLoop
.addAccum
  ld a, [hl];current remainder
  add a, c;add frac
  ld [hli], a;update remainder
  ld a, b
  adc a, 0;diff + carry
  ret
.noChange
  inc hl
  ret

ScrollTileAnimation:
  ld a, [last_scx]
  ld d, a
  ldh a, [rSCX]
  sub a, d
  ld d, a;diff x

  ld a, [last_scy]
  ld e, a
  ldh a, [rSCY]
  sub a, e;diff y
  ld e, a

  or a, d
  jr nz, .scrollChanged
.incrementTileAndExit
  ld bc, 5
  add hl, bc
  ret

.scrollChanged
  ld a, [hli];tile id
  ld b, a
  push bc;b = tile id
  
  ld a, [hli];x shift
  ld c, a
  ld a, d;x diff
  call CalcScroll
  ld d, a;x rotation

  ld a, [hli];y shift
  ld c, a
  ld a, e;y diff
  call CalcScroll
  ld e, a;y rotation

  pop bc;b = tile id
  ld a, d
  or e
  ret z;scrolled to same offset

.rotateTile
  push hl;next tile
  ld a, b;tile id
  CALC_VRAM_ADDRESS
  call RotateTile
  pop hl;next tile
  ret

RotateTile:;de = xy(0-7); hl = tile address
  ld a, d;x
  and a, %111;x=0-7
  rlca;x<<1
  rlca;x<<2
  rlca;x<<3
  ld d, a
  ld a, e;y
  and a, %111;y=0-7
  or a, d;index = x<<3 | y
  add a, a;index*2
  ld e, a
  ld d, HIGH(RotateTileJumpTable)
  ld a, [de]
  ld c, a
  inc e
  ld a, [de]
  ld b, a;bc = routine address
  push bc;push routine address on stack
  ret;returns to routine address

RotateTileByOne:;de = xy(-1,0,1); hl = tile address
  ld a, d
  cp a, 1
  jr z, .incX
  jr c, .zeroX
.decX
  ld a, e
  cp a, 1
  jp z, RotateTileX7Y1
  jp c, RotateTileX7Y0
  jp RotateTileX7Y7
.incX
  ld a, e
  cp a, 1
  jp z, RotateTileX1Y1
  jr c, RotateTileX1Y0
  jp RotateTileX1Y7
.zeroX
  ld a, e
  cp a, 1
  jp z, RotateTileX0Y1
  jp RotateTileX0Y7

MACRO ROTATE_TILE_X ; \1 = x (1..7)
  IF \1 == 4
    swap a
  ELIF \1 < 4
    REPT \1
      rrca
    ENDR
  ELSE
    REPT 8-\1
      rlca
    ENDR
  ENDC
ENDM;ROTATE_TILE_X

MACRO ROTATE_TILE_XY ;\1 = x, \2 = y
RotateTileX\1Y\2:
IF \2 <= 4;shift down
  ;advance hl to wrapped rows and push them onto stack
  ld de, 2*(8-\2)
  add hl, de;start of wrapped rows
  REPT \2
    ld a, [hli]
    ld c, a;low bitplane
    ld a, [hli]
    ld b, a;high bitplane
    IF \2 > 1
      push bc;stack row
    ENDC
  ENDR

  ;set hl to destination end (byte 15) and de to source end (byte 15 - 2y)
  dec hl;byte 15
  ld d, h
  ld a, l
  sub 2*\2
  ld e, a

  ;stream non-wrapping rows backwards
  REPT 2*(8-\2)
    ld a, [de]
    dec e
    ROTATE_TILE_X \1
    ld [hld], a
  ENDR

  ;pop wrapped rows and write into rows 0 to (y-1)
  REPT \2
    IF \2 > 1
      pop bc
    ENDC
    ld a, b
    ROTATE_TILE_X \1
    ld [hld], a
    ld a, c
    ROTATE_TILE_X \1
    ld [hld], a
  ENDR

ELSE;shift up
  ;push top rows onto stack
  REPT 8 - \2
    ld a, [hli]
    ld c, a
    ld a, [hli]
    ld b, a
    IF \2 < 7
      push bc
    ENDC
  ENDR

  ;src de = byte 2*(8-y), dest hl = byte 0
  ld d, h
  ld e, l
  ld a, l
  sub 2*(8-\2)
  ld l, a

  ;stream remaining rows forwards
  REPT 2*\2
    ld a, [de]
    inc e
    ROTATE_TILE_X \1
    ld [hli], a
  ENDR

  ;advance hl to byte 15
  ld a, l
  add a, 2*(8-\2)-1
  ld l, a

  ;stream backwards
  REPT 8-\2
    IF \2 < 7;no need for stack if y = 7
      pop bc
    ENDC
    ld a, b
    ROTATE_TILE_X \1
    ld [hld], a
    ld a, c
    ROTATE_TILE_X \1
    ld [hld], a
  ENDR
ENDC
  ret
ENDM;ROTATE_TILE_XY


RotateTileX0Y0:
  ret

FOR x, 1, 8
RotateTileX{d:x}Y0:
  REPT 16
    ld a, [hl]
    ROTATE_TILE_X {d:x}
    ld [hli], a
  ENDR
  ret
ENDR

FOR x, 8
  FOR y, 1, 8
    ROTATE_TILE_XY {d:x}, {d:y}
  ENDR
ENDR

DS ALIGN[8]
RotateTileJumpTable:
FOR x, 8
  FOR y, 8
    DW RotateTileX{d:x}Y{d:y}
  ENDR
ENDR
