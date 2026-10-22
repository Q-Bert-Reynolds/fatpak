DEF TILE_ANIM_SIZE         EQU 6;bytes... type, id, bank, address, speed
DEF TILE_ANIM_MAX_COUNT    EQU 4
DEF TILE_ANIM_BUFFER_SIZE  EQU 1 + TILE_ANIM_MAX_COUNT * TILE_ANIM_SIZE

DEF TILE_ANIM_TYPE_LINEAR  EQU 0
DEF TILE_ANIM_TYPE_SCROLL  EQU 1
DEF TILE_ANIM_TYPE_SINE    EQU 2
DEF TILE_ANIM_TYPE_TEXTURE EQU 3

SECTION "Tile Animation WRAMX", WRAMX
tile_anim_timer: DB
tile_anim_buffer:: DS TILE_ANIM_BUFFER_SIZE;byte 0 is count

SECTION "Tile Animation ROM0", ROM0
CopyTileAnimDataToBuffer:;hl = tile index address, puts tile bytes in tile_buffer, returns offset in de, address of tile speed in hl
  ld a, [hli];tile id
  push hl;tile bank address
  ld h, 0
  ld l, a
  add hl, hl;*2
  add hl, hl;*4
  add hl, hl;*8
  add hl, hl;*16
  pop de;tile bank address
  push hl;offset offset
.blah
  ld a, [de];bank
  ld [rROMB0], a
  inc de
  ld a, [de];tile
  ld l, a
  inc de
  ld a, [de]
  ld h, a
  inc de
  pop bc;offset
  push bc;offset
  add hl, bc
  push de;address of tile speed

  ld de, tile_buffer
REPT 16
  ld a, [hli]
  ld [de], a
  inc de
ENDR
  pop hl;address of tile speed
  pop de;offset

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
DB 0, 0, 0, 0, 1, 0, 1, 0, 1, 1, 0, 1, 0, 1, 0, 1, 0, 0, 0, 0, -1, 0, -1, 0, -1, 0, -1, -1, 0, -1, 0, -1
TileOffsetCosTable:
DB 1, 1, 0, 1, 0, 1, 0, 1, 0, 0, 0, 0, -1, 0, -1, 0, -1, 0, -1, -1, 0, -1, 0, -1, 0, 0, 0, 0, 1, 0, 1, 0

SineTileAnimation:
  ld a, [hli];tile id
  ld b, a;tile id
  inc hl
  inc hl
  inc hl
  ld a, [hli]
  ld c, a;speed
  push hl;next tile
  push bc;id, speed

  call math_Abs;speed in a
  ld c, a;|speed|
  ld a, [tile_anim_timer]
  ld h, a
  call math_Divide8;step / speed
  pop bc;id, speed
  and a
  jr nz, .done

  push bc;id, speed
  ld a, l
  ld d, l
  swap a
  and $F
  add a, a
  ld h, 0
  ld l, a
  ld bc, TileOffsetCosTable
  add hl, bc
  ld a, [hl]
  ld l, d
  ld d, a;x offset

  ld a, l
  swap a
  and $F
  add a, a
  ld h, 0
  ld l, a
  ld bc, TileOffsetSinTable
  add hl, bc
  ld a, [hl]
  rlca
  ld e, a;y offset

.calcVRAM
  pop bc;id, speed
  ld h, 0
  ld l, b
  add hl, hl;*2
  add hl, hl;*4
  add hl, hl;*8
  add hl, hl;*16
  ld bc, _VRAM8800
  add hl, bc
  call RotateTile
  
.done
  pop hl;next tile
  ret

TextureTileAnimation:
  ;TODO

LinearTileAnimation:
  ld a, [hli];tile id
  ld b, a;tile id
  inc hl
  inc hl
  inc hl
  ld a, [hli]
  ld c, a;speed
  push hl;next tile
  push bc;id, speed
  
  ld a, c;speed
  call math_Abs
  ld c, a;|speed|
  ld a, [tile_anim_timer]
  ld h, a
  call math_Divide8;step / speed
  pop bc;id, speed
  and a
  jr nz, .done
  
.calcVRAM
  ld h, 0
  ld l, b
  add hl, hl;*2
  add hl, hl;*4
  add hl, hl;*8
  add hl, hl;*16
  ld de, _VRAM8800
  add hl, de

  ld b, 16
  ld a, c
  and a, %10000000
  ld a, c
  jr z, .shiftRightLoop
  
  cpl
  inc a
  jr .shiftLeftLoop

.shiftRightLoop
    ld a, [hl]
    rrca
    ld [hli], a
    dec b;bytes left
    jr nz, .shiftRightLoop
  jr .done

.shiftLeftLoop
    ld a, [hl]
    rlca
    ld [hli], a
    dec b;bytes left
    jr nz, .shiftLeftLoop

.done
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
  or a, e
  ret z
  
  push hl;next tile
  ld h, 0
  ld l, b;tile id
  add hl, hl;*2
  add hl, hl;*4
  add hl, hl;*8
  add hl, hl;*16
  ld bc, _VRAM8800
  add hl, bc
  call RotateTile
  pop hl;next tile
  ret

RotateTile:;de = xy; hl = tile address
  ld a, d;x
  and a, %111;x=0-7
  rlca;x<<1
  rlca;x<<2
  rlca;x<<3
  ld d, a
  ld a, e;y
  and a, %111;y=0-7
  or a, d;index = x<<3 | y
  add a, a                            ; a = index * 2 (0..126)
  ld e, a
  ld d, HIGH(RotateTileJumpTable)     ; DE = entry address
  ld a, [de]
  ld c, a
  inc e
  ld a, [de]
  ld b, a                             ; BC = Target routine address
  push bc
  ret                                 ; Tail-call jump to RotateTile_Y_X
  
DS ALIGN[8]
RotateTileJumpTable:
FOR x, 8
  FOR y, 8
    DW RotateTileX{d:x}Y{d:y}
  ENDR
ENDR

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
  ;advance hl to wrapped rows and push them onto stack
  ld de, 16-2*\2
  add hl, de;start of wrapped rows
  REPT \2
    ld a, [hli]
    ld c, a;low bitplane
    ld a, [hli]
    ld b, a;high bitplane
    push bc;stack row
  ENDR

  ;set hl to destination end (byte 15) and de to source end (byte 15 - 2y)
  dec hl;byte 15
  ld d, h
  ld e, l
  REPT 2*\2
    dec de;byte 15-2y
  ENDR

  ;stream non-wrapping rows backwards
  REPT 16-2*\2
    ld a, [de]
    dec de
    ROTATE_TILE_X \1
    ld [hld], a
  ENDR

  ;pop wrapped rows and write into rows 0 to (y-1)
  REPT \2
    pop bc
    ld a, b
    ROTATE_TILE_X \1
    ld [hld], a
    ld a, c
    ROTATE_TILE_X \1
    ld [hld], a
  ENDR
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