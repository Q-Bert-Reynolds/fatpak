SECTION "Core HRAM", HRAM
loaded_bank:: DB
temp_a_reg:: DB

SECTION "Core ROM0", ROM0

; Trampoline                      b = bank, hl = address, can only use a, e, and RAM for args, can return in any register
; UpdateInput
; PauseGame
; ResumeGame
; ClearTiles                      a = clear tile, display should be off
; ClearScreen                     a = clear tile, display should be off
; HideSpritesInRect               hl = wh, de = xy(left/top)
; SetTiles                        a = draw flags, hl=wh, de=xy, bc=firstTile
; CopyToTileBuffer                hl=wh, de=xy, bc=firstTile
; SetBkgTilesWithOffset           hl=wh, de=xy, bc=in_tiles, a=offset
; SetWinTilesWithOffset           hl=wh, de=xy, bc=in_tiles, a=offset
; SetSpriteTiles                  bc = count, hl = map, de = offset\props
; MoveSprites                     bc = xy in screen space, hl = wh in tiles, a = first sprite index
; SetSpriteTilesXY                bc = xy in screen space, hl = wh in tiles, de = tilemap, a = VRAM offset
; CopyBkgToWin
; CopyWinToBuffer
; CopyBufferToWin
; GetZeroPaddedNumber             a = number, returns padded number in str_buffer, affects str_buffer, all registers
; SignedRandom                    a = bitmask, returns signed random bytes in d and e

Trampoline:: ;b = bank, hl = address, can use a, de, and RAM for args, can return in any register
  ldh [temp_a_reg], a
  ldh a, [loaded_bank]
  push af;old bank
  ld a, b;new bank
  SET_BANK
  ldh a, [temp_a_reg]
  ld bc, .bounceBack
  push bc ;put return addres on stack before jumping
  jp hl
.bounceBack
  ldh [temp_a_reg], a
  pop af;old bank
  SET_BANK
  ldh a, [temp_a_reg]
  ret

PauseGame::
  ld a, [game_state]
  or a, GAME_STATE_PAUSED
  ld [game_state], a
  ret

ResumeGame::
  ld a, [game_state]
  and a, ~GAME_STATE_PAUSED
  ld [game_state], a
  ret

ClearTiles:: ;a = tile, display should be off
  ld bc, 32*32+20*18
  ld hl, _SCRN0
  jp mem_SetVRAM

ClearScreen:: ;a = tile, display should be off
  call ClearTiles
  ld a, 166
  ldh [rWX], a
  ld a, 143
  ldh [rWY], a
  call HideAllSprites
.checkGBC
  ldh a, [sys_info]
  and a, SYS_INFO_GBC
  ret z
.clearColors
  ld a, 1
  ldh [rVBK], a
  xor a
  call ClearTiles
  ldh [rVBK], a
  ret 

HideAllSprites::
  xor a
  ld b, OAM_COUNT
  ld hl, oam_buffer
.loop
    ld [hli], a
    ld [hli], a
    inc hl
    inc hl
    dec b
    jr nz, .loop
  call gbdk_DMATransfer
  ret

HideSpritesInRect::;hl=wh, de=xy(left/top)
  add hl, de;hl = right/bottom
  ld a, OAM_COUNT
  ld bc, oam_buffer
.loop
    push af
    ld a, [bc];y
    srl a
    srl a
    srl a
    cp a, e
    jr c, .next;above the top
    jr z, .next
    dec a
    cp a, l
    jr nc, .next;below the bottom
    inc bc
    ld a, [bc];x
    dec bc
    srl a
    srl a
    srl a
    cp a, d
    jr c, .next;left of left
    jr z, .next
    dec a
    cp a, h
    jr nc, .next;right of right
    xor a
    ld [bc], a;clear y
    inc bc
    ld [bc], a;clear x
    dec bc
  .next
    inc bc
    inc bc
    inc bc
    inc bc
    pop af
    dec a
    jr nz, .loop
  ret

SetTiles::;a = draw flags, hl=wh, de=xy, bc=firstTile
  and a, DRAW_FLAGS_WIN
  jp z, gbdk_SetBkgTiles
  jp gbdk_SetWinTiles

CopyToTileBuffer::;hl=wh, de=xy, bc=firstTile
  push hl;wh
  ld hl, tile_buffer;destination
  COPY_TILE_BLOCK OP_COPY_FROM, SKIP_VRAM

SetToTileBuffer::
  ld hl, tile_buffer
  push bc
  ld b, a
  COPY_TILE_BLOCK OP_SET_TO, SKIP_VRAM

CopyToTileBufferWithOffset: ;hl=wh, de=xy, bc=in_tiles, a=offset
  push de ;xy
  push hl ;wh
  push af ;offset
  push bc ;in_tiles

  ld d, 0
  ld e, h ;de = width
  ld a, l ;a = height
  rst math_Multiply
  pop bc;in_tiles
  pop af;offset
  push hl;count
  push af;offset
  ld hl, tile_buffer
.loop ;for (i = w*h; i > 0; --i)
    ld a, [bc]
    inc bc
    ld d, a
    pop af ;offset
    push af ;offset
    add a, d
    ld [hli], a; tiles[i] = in_tiles[i]+offset;
    
    pop af;offset
    pop de;count
    dec de
    push de;count
    push af;offset

    ld a, d
    and a
    jr nz, .loop
    ld a, e
    and a
    jr nz, .loop

  pop af ;count
  pop af ;offset
  pop hl ;xy
  pop de ;wh
  ret

SetBkgTilesWithOffset:: ;hl=wh, de=xy, bc=in_tiles, a=offset
  call CopyToTileBufferWithOffset
  ld bc, tile_buffer
  jp gbdk_SetBkgTiles
  
SetWinTilesWithOffset:: ;hl=wh, de=xy, bc=in_tiles, a=offset
  call CopyToTileBufferWithOffset
  ld bc, tile_buffer
  jp gbdk_SetWinTiles

SetSpriteTiles:: ;bc = count, hl = map, de = offset\props
  xor a
  ld [_i], a
.loop
    push bc;count
    ld a, [_i]
    ld c, a
    ld a, [hli]
    push hl;map index
    add a, d;offset
    push de;offset\props
    ld d, a ;tile
    call gbdk_SetSpriteTile
    ld a, [_i]
    ld c, a
    pop de;offset\props
    push de;offset\props
    ld d, e
    call gbdk_SetSpriteProp
    pop de;offset\props
    pop hl;map index
    ld a, [_i]
    inc a
    ld [_i], a
    pop bc; count
    dec bc
    ld a, b
    or c
    jr nz, .loop
  ret

; moves a grid of sprite tiles
MoveSprites:: ;bc = xy in screen space, hl = wh in tiles, a = first sprite index
  ld [_a], a
  xor a
  ld [_j], a
.rowLoop ;for (j = 0; j < h; j++)
    xor a
    ld [_i], a
  .columnLoop ;for (i = 0; i < w; i++)
      ld a, [_i]
      add a ;i*2
      add a ;i*4
      add a ;i*8
      add a, b ;i*8+x
      ld d, a

      ld a, [_j]
      add a; j*2
      add a; j*4
      add a; j*8
      add a, c ;j*8+y
      ld e, a

      push bc
      ld a, [_a]
      ld c, a
      inc a
      ld [_a], a

      push hl
      call gbdk_MoveSprite;move_sprite(a++, i*8+x, j*8+y);
      pop hl
      pop bc

      ld a, [_i]
      inc a
      ld [_i], a
      sub a, h
      jr nz, .columnLoop

    ld a, [_j]
    inc a
    ld [_j], a
    sub a, l
    jr nz, .rowLoop
  ret

;; sets and moves a grid of sprite tiles, skips tiles according to flags, resets sprite_first_tile to 0
SetSpriteTilesXY:: ;bc = xy in screen space, hl = wh in tiles, de = tilemap, a = VRAM offset
  ld [sprite_offset], a;offset
  push bc
  ld b, a
  ld a, [sprite_first_tile]
  add a, b
  ld [_a], a;first tile
  pop bc
  xor a
  ld [_j], a;row
.rowLoop ;for (j = 0; j < h; j++)
    xor a
    ld [_i], a
  .columnLoop ;for (i = 0; i < w; i++)
      push bc;xy
      push hl;wh

      ld a, [sprite_flags]
      and SPRITE_FLAGS_SKIP
      jr z, .noSkip
      ld a, [sprite_skip_id]
      ld h, a
      ld a, [de]
      cp h;skip me
      jr z, .skip
    .noSkip
      ld a, [_a]
      cp a, OAM_COUNT
      jr nc, .skip
      push de;tilemap
      
      ld e, a
      inc a
      ld [_a], a
      ld hl, oam_buffer
      sla e ;multiply e by 4
      sla e
      ld d, 0
      add hl, de

      ld a, [_j]
      add a; j*2
      add a; j*4
      add a; j*8
      add a, c ;j*8+y
      ld [hli], a;y

      ld a, [_i]
      add a ;i*2
      add a ;i*4
      add a ;i*8
      add a, b ;i*8+x
      ld [hli], a;x

      ld a, [sprite_offset];offset
      ld b, a
      pop de;tilemap
      ld a, [de]
      add a, b
      ld [hli], a;tile

      ld a, [sprite_props]
      ld [hli], a

    .skip
      inc de;tile index
      pop hl;wh
      pop bc;xy

      ld a, [_i]
      inc a
      ld [_i], a
      sub a, h
      jr nz, .columnLoop

    ld a, [_j]
    inc a
    ld [_j], a
    sub a, l
    jr nz, .rowLoop

  ld a, [sprite_flags]
  and SPRITE_FLAGS_CLEAR_END
  ret z

  ld a, [_a]
  ld e, a
  ld hl, oam_buffer
  sla e ;multiply e by 4
  sla e
  ld d, 0
  add hl, de
  ld a, 160
  sub a, e
  ld b, 0
  ld c, a
  xor a
  call mem_Set

  xor a
  ld [sprite_first_tile], a;reset first tile to zero ;TODO: handle this better

  ret

FlipTileMapX::;hl=wh; bc=in_tiles, de=out_tiles
  push hl;wh
  xor a
  ld [_j], a
.rowLoop
    pop hl;wh
    push hl
    ld a, h
    ld [_i], a

    push de;out_tiles
    ld d, 0
    ld e, a
    ld a, [_j]
    inc a
    rst math_Multiply
    dec hl
    add hl, bc
    pop de;out_tiles
  .columnLoop
      ld a, [hld]
      ld [de], a
      inc de

      ld a, [_i]
      dec a
      ld [_i], a
      jr nz, .columnLoop
    ld a, [_j]
    inc a
    ld [_j], a
    pop hl;wh
    push hl
    cp l
    jr nz, .rowLoop

  pop hl
  ret

ReverseByte:;byte in a
  push bc
  ld b,a    ; a = 76543210
  rlca
  rlca      ; a = 54321076
  xor b
  and $AA
  xor b     ; a = 56341270
  ld b,a
  rlca
  rlca
  rlca      ; a = 41270563
  rrc b     ; b = 05634127
  xor b
  and $66
  xor b     ; a = 01234567
  pop bc
  ret

CopyBkgToWin::
.scrollXYToTileXY;returns xy in de
  ld e, %00011111
  ldh a, [rSCX]
  rra;x/2
  rra;x/4
  rra;x/8
  and a, e;clear carry bits
  ld d, a ;x
  ldh a, [rSCY]
  rra;x/2
  rra;x/4
  rra;x/8
  and a, e;clear carry bits
  ld e, a ;y
  
.distanceToScreenOrVRAMEdge;tile xy in de, returns wh in hl
  ld a, 32
  sub a, d
  cp a, 20
  jr c, .skipWidth
  ld a, 20
.skipWidth
  ld h, a
  ld a, 32
  sub a, e
  cp a, 18
  jr c, .skipHeight
  ld a, 18
.skipHeight
  ld l, a
  
.upperLeft
  push hl;wh
  push de;xy
  ld bc, bkg_buffer
  call gbdk_GetBkgTiles

  pop de;xy
  pop hl;wh
  push hl
  push de
  ld de, 0
  ld bc, bkg_buffer
  call gbdk_SetWinTiles

  pop de;xy
  pop hl;wh
  push hl
  push de

  ld a, 32-20
  cp d
  jp nc, .bottomLeft
  ld d, h;x = left width
  ld a, 20
  sub a, h
  ld h, a; right width

.upperRight
  push hl;wh
  push de;xy
  ld d, 0
  ld bc, bkg_buffer
  call gbdk_GetBkgTiles

  pop de;xy
  pop hl;wh
  push hl
  push de
  ld e, 0
  ld bc, bkg_buffer
  call gbdk_SetWinTiles

  pop de;xy
  pop hl;wh
  
  ld a, 32-18
  cp e
  jr nc, .bottomLeft;skip bottom right
  ld e, l;y = upper height
  ld a, 18
  sub a, l
  ld l, a; bottom right height

.bottomRight
  push hl;wh
  push de;xy
  ld de, 0
  ld bc, bkg_buffer
  call gbdk_GetBkgTiles

  pop de;xy
  pop hl;wh
  push hl;wh
  push de;xy
  ld bc, bkg_buffer
  call gbdk_SetWinTiles

  pop de;xy
  pop hl;wh

.bottomLeft
  pop de;xy
  pop hl;wh
  ld a, 32-18
  cp e
  jr nc, .checkGBC;skip bottom 
  ld e, l;y = upper height
  ld a, 18
  sub a, l
  ld l, a; bottom height

  push hl;wh
  push de;xy
  ld e, 0
  ld bc, bkg_buffer
  call gbdk_GetBkgTiles

  pop de;xy
  pop hl;wh
  push hl;wh
  push de;xy
  ld d, 0
  ld bc, bkg_buffer
  call gbdk_SetWinTiles

  pop de;xy
  pop hl;wh 

.checkGBC
  ldh a, [sys_info]
  and a, SYS_INFO_GBC
  ret z

  ldh a, [rVBK]
  bit 0, a
  jr nz, .resetVRAMBank;if rVBK == 1, we've already set colors, so we're done

  ld a, 1
  ldh [rVBK], a
  jp CopyBkgToWin; otherwise, set rVBK to 1 and copy again

.resetVRAMBank
  xor a
  ldh [rVBK], a
  ret

CopyWinToBuffer::
  ld hl, $1412;20,18
  ld de, 0
  ld bc, win_buffer
  call gbdk_GetWinTiles
  ldh a, [sys_info]
  and a, SYS_INFO_GBC
  ret z
  ld a, 2
  ldh [rSVBK], a
  dec a
  ldh [rVBK], a
  ld hl, $1412;20,18
  ld de, 0
  ld bc, win_buffer
  call gbdk_GetWinTiles
  xor a
  ldh [rSVBK], a
  ldh [rVBK], a
  ret

CopyBufferToWin::
  ld hl, $1412;20,18
  ld de, 0
  ld bc, win_buffer
  call gbdk_SetWinTiles
  ldh a, [sys_info]
  and a, SYS_INFO_GBC
  ret z
  ld a, 2
  ldh [rSVBK], a
  dec a
  ldh [rVBK], a
  ld hl, $1412;20,18
  ld de, 0
  ld bc, win_buffer
  call gbdk_SetWinTiles
  xor a
  ldh [rSVBK], a
  ldh [rVBK], a
  ret

GetZeroPaddedNumber::;a = number, returns padded number in str_buffer, affects str_buffer, all registers
  ld h, 0
  ld l, a
  ld de, name_buffer
  call str_Number

  ld hl, str_buffer
  ld a, '0'
  ld [hli], a
  ld [hli], a
  ld [hli], a

  ld hl, name_buffer
  call str_Length
  ld a, 3
  sub a, e
  ld e, a
  ld hl, str_buffer
  add hl, de
  ld d, h
  ld e, l
  ld hl, name_buffer
  jp str_Copy

SignedRandom:: ;a = bitmask, returns signed random bytes in d and e
  push af
  call gbdk_Random
  pop af
  push af
  and a, d
  ld b, a
  ld a, d
  and %10000000
  jr z, .skipD
  ld a, b
  cpl
  inc a
  ld b, a
.skipD
  ld d, b

  pop af
  and a, e
  ld b, a
  ld a, e
  and %10000000
  jr z, .skipE
  ld a, b
  cpl
  inc a
  ld b, a
.skipE
  ld e, b
  ret
