DEF TILE_ANIM_SIZE         EQU 6;bytes... type, id, bank, address, speed
DEF TILE_ANIM_MAX_COUNT    EQU 4
DEF TILE_ANIM_BUFFER_SIZE  EQU 1 + TILE_ANIM_MAX_COUNT * TILE_ANIM_SIZE

DEF TILE_ANIM_TYPE_LINEAR  EQU 0
DEF TILE_ANIM_TYPE_SCROLL  EQU 1
DEF TILE_ANIM_TYPE_SINE    EQU 2
DEF TILE_ANIM_TYPE_TEXTURE EQU 3

MACRO ROTATE_TILE ;\1
REPT 16
  ld a, [hl]
  \1
  ld [hli], a
ENDR
  ret
ENDM

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

ScrollTileAnimation:
  ld a, [last_scx]
  ld b, a
  ldh a, [rSCX]
  cp a, b
  jr nz, .scrollChanged
  ld a, [last_scy]
  ld b, a
  ldh a, [rSCY]
  cp a, b
  jr nz, .scrollChanged
.incrementTileAndExit
  ld bc, 5
  add hl, bc
  ret

.scrollChanged
  call CopyTileAnimDataToBuffer
  ld a, [hli];speed
  push hl;next tile
  ld hl, _VRAM8800
  add hl, de
  push hl;dest

  ;TODO: speed should drive rotation
  ldh a, [rSCX]
  rrca
  rrca
  rrca
  and a, %111
  ld d, a
  ldh a, [rSCY]
  rrca
  rrca
  cpl a
  and a, %1110
  ld e, a
  
;NOTE jump or fallthrough only... no jump
CopyBufferedTileToVRAM:;hl = VRAM address, de = xy offset
  ld b, 0
  ld c, a
  ld hl, tile_buffer
  add hl, bc
  ld b, h
  ld c, l
  pop hl;dest

  PUSH_ALL
  ld a, d
  ld hl, tile_buffer
  call RotateTileRight
  POP_ALL

  ld a, 16
  sub a, e
.loop
    push af;bytes left
    ld a, [bc]
    inc bc
    ld [hli], a
    pop af;bytes left
    dec a;bytes left
    jr nz, .loop

  ld a, e
  and a
  jr z, .done
  ld bc, tile_buffer
.loop2
    push af;bytes left
    ld a, [bc]
    inc bc
    ld [hli], a
    pop af;bytes left
    dec a;bytes left
    jr nz, .loop2
.done
  pop hl;next tile
  ret

TileOffsetSinTable:
DB 0, 0, 0, 0, 1, 1, 2, 2, 3, 4, 4, 5, 5, 6, 6, 7, 7, 7, 7, 7, 6, 6, 5, 5, 4, 4, 3, 2, 2, 1, 1, 0
TileOffsetCosTable:
DB 3, 4, 4, 5, 5, 6, 6, 7, 7, 7, 7, 7, 6, 6, 5, 5, 4, 4, 3, 2, 2, 1, 1, 0, 0, 0, 0, 0, 1, 1, 2, 2

SineTileAnimation:
  call CopyTileAnimDataToBuffer
  ld a, [hli];speed
  push hl;next tile
  ld hl, _VRAM8800
  add hl, de
  push hl;dest

  ld a, [tile_anim_timer]
  swap a
  and $F
  add a, a
  ld h, 0
  ld l, a
  ld bc, TileOffsetCosTable
  add hl, bc
  ld a, [hl]
  ld d, a;x offset

  ld a, [tile_anim_timer]
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
  ld bc, tile_buffer

  jp CopyBufferedTileToVRAM

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

RotateTileRight:;a = amount, ;hl = address
  and a, %111
  ret z
  ld de, .return
  push de;return address

  dec a
  jp z, RotateTileRight1
  dec a
  jp z, RotateTileRight2
  dec a
  jp z, RotateTileRight3
  dec a
  jp z, RotateTileRight4
  dec a
  jp z, RotateTileRight5
  dec a
  jp z, RotateTileRight6
  dec a
  jp z, RotateTileRight7

  pop de;return address

.return
  ret

RotateTileRight1: ROTATE_TILE rrca
RotateTileRight2: ROTATE_TILE rrca \n rrca
RotateTileRight3: ROTATE_TILE rrca \n rrca \n rrca
RotateTileRight4: ROTATE_TILE swap a
RotateTileRight5: ROTATE_TILE swap a \n rrca
RotateTileRight6: ROTATE_TILE rlca \n rlca
RotateTileRight7: ROTATE_TILE rlca
