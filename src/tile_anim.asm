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
  ld bc, 16
  call mem_Copy
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
  and a, %01111111
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
  ret z

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
  
  ld b, 0
  ld c, a
  ld hl, tile_buffer
  add hl, bc
  ld b, h
  ld c, l

  pop hl;dest
  ld a, 16
  sub a, e
.bytesLoop
    push af;bytes left
    push de;xy offset
    ld a, [bc]
    inc bc
    inc d
  .bitsLoop
      dec d
      jr z, .writeByte
      rrca
      jr .bitsLoop
  .writeByte
    ld [hli], a

    pop de;xy offset
    pop af;bytes left
    dec a;bytes left
    jr nz, .bytesLoop

  ld a, e
  and a
  jr z, .done
  ld bc, tile_buffer
.bytesLoop2
    push af;bytes left
    push de;xy offset
    ld a, [bc]
    inc bc
    inc d
  .bitsLoop2
      dec d
      jr z, .writeByte2
      rrca
      jr .bitsLoop2
  .writeByte2
    ld [hli], a

    pop de;xy offset
    pop af;bytes left
    dec a;bytes left
    jr nz, .bytesLoop2
.done
  pop hl;next tile
  ret

SineTileAnimation:
TextureTileAnimation:
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
  jr nz, .shiftLeftLoop

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