IF !DEF(MAP_LOADER)
DEF MAP_LOADER EQU 1

INCLUDE "src/beisbol.inc"
;NOTE: lines commented out with ;; reference removed baseball/RPG code
INCLUDE "data/map_data.asm"

SECTION "Map Loader HRAM", HRAM
map_last_button_state:: DB
map_anim_frame:: DB
map_steps:: DB
map_obj_type:: DB
map_collision_type:: DB
map_collision_data:: DB
map_sprite_collision_index:: DB
map_meta_sprites_bank:: DB
map_scroll_speed:: DB
map_sprite_count:: DB
map_min_x:: DB
map_min_y:: DB
map_max_x:: DB
map_max_y:: DB
map_temp_a: DB
map_temp_b: DB
map_temp_c: DB
map_temp_d: DB
map_temp_type: DB
map_temp_height: DB
map_temp_width: DB
map_temp_x: DB
map_temp_y: DB

SECTION "TestMapObjectMinXY RST", ROM0[$0000]
TestMapObjectMinXY:; de = xy, max XY in max_x,max_y, returns xy in de, sets z if out of range
.testMinX
  ldh a, [map_max_x]                 ;2 bytes
  cp a, d;obj minX                   ;1 byte
  jr c, TestFailed;maxX < obj minX   ;2 bytes
  ret z;TestFailed;maxX == obj minX  ;1 byte
.testMinY
  ldh a, [map_max_y];maxY            ;2 bytes
  cp a, e;obj minY                   ;1 byte
  jr c, TestFailed;maxY < obj minY   ;2 bytes
  ret                                ;1 byte
TestFailed:
  xor a                              ;1 byte
  ret                                ;1 byte

SECTION "TestMapObjectMaxXY RST", ROM0[$0010]
TestMapObjectMaxXY:; hl = xy, min XY in min_x,min_y, returns xy in hl, sets z if out of range
.testMaxX
  ldh a, [map_min_x];minX            ;2 bytes
  cp a, h;obj maxX                   ;1 byte
  ret z;TestFailed;minX == obj maxX  ;1 byte
  jr nc, TestFailed;minX > obj maxX  ;2 bytes
.testMaxY
  ldh a, [map_min_y];minY            ;2 bytes
  cp a, l;obj maxy                   ;1 byte
  ret z;TestFailed;minY == obj maxY  ;1 byte
  jr nc, TestFailed;minY > obj maxY  ;2 bytes
  ret                                ;1 byte

SECTION "Map Loader Code", ROM0
;TODO: move stamps and meta sprites out of ROM0
INCLUDE "maps/map_stamps.gbstamp"

; ROUTINES THAT SWITCH TO A BANK, DO SOME WORK, AND SWITCH BACK
; LoadMap                      loads palettes and tiles, sets meta sprites bank, clears sprites
; GetScreenCollision           bc = xy pixel offset (-127,127), returns z if no collision, obj/collision type in a, extra data in b, map sprite index or -1 in c
; GetMapChunkCollision         hl = chunk address, de = xy, returns z if no collision, obj/collision type in a, extra data in [hl], map sprite index or -1 in c
; GetSpriteCollision           de = pixel xy, returns z if no collision, obj/collision type in a, extra data in [hl], map sprite index or -1 in c
; MoveMapLeft
; MoveMapRight
; MoveMapUp
; MoveMapDown
; DrawMapToScreen              draws map to visible background
; EnterMapDoor                 a = door index
; CheckMapItemFlags            item index in a, returns z if flag not set
; PickUpMapItem                item index in a
; PlayMapTeam                  team index in [map_collision_data]
; RunMapScript                 script index in [map_collision_data]
; GetMapEncounter              returns age in b, player num in c
; ClearMapSprites              removes map sprites from screen and buffer
; CopyMapSpritesToOAMBuffer    iterates through map sprites, copying values to oam_buffer

; ROUTINES THAT EXPECT TO ALREADY BE ON THE CURRENT MAP BANK
; DrawMapLeftEdge              draws column of map tile to background off-screen left
; DrawMapRightEdge             draws column of map tile to background off-screen right
; DrawMapTopEdge               draws row map tiles to background off-screen up
; DrawMapBottomEdge            draws row map tiles to background off-screen down
; DrawMapChunk                 hl = chunk address, de=xy, bc=wh
; GetCurrentMapChunk           returns chunk address in hl, index in a
; SetCurrentMapChunk           hl = chunk address, returns address in hl, index in a
; GetCurrentMapChunkNeighbor   a = direction, returns chunk in hl, index in a
; GetMapChunkNeighbor          a = direction, hl = map chunk, returns chunk in hl, index in a
; GetMapChunk                  a = jump table index, returns chunk in hl, index in a
; GetMapChunkForOffset         bc = xy pixel offset, returns chunk in hl, tile xy in de
; GetMapAddress                address index in [map_collision_data], switches to bank of address and returns it in hl
; GetMapArea                   sets bank to current map, returns address of current chunk's area in hl
; GetMapItem                   item index in a, returns item id/count in bc, flag index/bits in de

; ROUTINES THAT DO NOT REQUIRE BANK SWITCHING
; GetCurrentMap                returns address in hl, bank in a

DEF MAP_DATA_META_SPRITE   EQU 0
DEF MAP_DATA_PALETTES      EQU 1
DEF MAP_DATA_STRINGS       EQU 3
DEF MAP_DATA_DOORS         EQU 5
DEF MAP_DATA_CHUNKS        EQU 7
DEF MAP_DATA_ADDRESSES     EQU 9
DEF MAP_DATA_ITEMS         EQU 11
DEF MAP_DATA_AREAS         EQU 13
DEF MAP_DATA_TILE_ANIMS    EQU 15
DEF MAP_DATA_TILES         EQU 17

DEF MAP_OBJ_TYPE_MASK      EQU %00001111;up to 15 map object types
DEF MAP_OBJ_NONE           EQU 0 ;bg only
DEF MAP_OBJ_NONE_FILL      EQU 1 ;bg only
DEF MAP_OBJ_TILE           EQU 2 ;bg and sprites
DEF MAP_OBJ_TILE_FILL      EQU 3 ;bg only
DEF MAP_OBJ_STAMP          EQU 4 ;bg and sprites
DEF MAP_OBJ_STAMP_FILL     EQU 5 ;bg only
DEF MAP_OBJ_AVATAR         EQU 6 ;sprites only
DEF MAP_OBJ_META_SPRITE    EQU 7 ;sprites only

DEF MAP_COLLISION_MASK     EQU %11110000;up to 15 map collision types
DEF MAP_COLLISION_NONE     EQU 0
DEF MAP_COLLISION_SOLID    EQU 1 << 4
DEF MAP_COLLISION_WATER    EQU 2 << 4
DEF MAP_COLLISION_DOOR     EQU 3 << 4
DEF MAP_COLLISION_TEXT     EQU 4 << 4
DEF MAP_COLLISION_LEDGE    EQU 5 << 4
DEF MAP_COLLISION_GRASS    EQU 6 << 4
DEF MAP_COLLISION_SCRIPT   EQU 7 << 4
DEF MAP_COLLISION_TEAM     EQU 8 << 4
DEF MAP_COLLISION_ITEM     EQU 9 << 4

DEF MAP_STEP_SIZE          EQU 16;2 tiles per step
DEF WALK_ANIM_FRAMES       EQU 4;TODO: should come from GBStampAnimation

DEF MAP_CHUNK_TILE         EQU 0
DEF MAP_CHUNK_PALETTE      EQU 1
DEF MAP_CHUNK_AREA         EQU 2
DEF MAP_CHUNK_NORTH        EQU 3
DEF MAP_CHUNK_EAST         EQU 4
DEF MAP_CHUNK_SOUTH        EQU 5
DEF MAP_CHUNK_WEST         EQU 6
DEF MAP_CHUNK_DATA         EQU 7

DEF MAP_AVATAR_DIRECTION   EQU %11000000
DEF MAP_AVATAR_LEFT        EQU %00000000
DEF MAP_AVATAR_RIGHT       EQU %01000000
DEF MAP_AVATAR_UP          EQU %10000000
DEF MAP_AVATAR_DOWN        EQU %11000000
DEF MAP_AVATAR_EXTRA_DATA  EQU %00111111
DEF MAP_AVATAR_FRAME       EQU %00000111
DEF MAP_AVATAR_BEHAVIOUR   EQU %00111000
DEF MAP_AVATAR_STATIONARY  EQU %00000000
DEF MAP_AVATAR_WANDER      EQU %00001000

GetMapText::;a = text index, returns text in str_buffer
  ld b, 0
  ld c, a
  ldh a, [loaded_bank]
  push af;current bank
  push bc;index
  call GetCurrentMap
  SET_BANK

  ld bc, MAP_DATA_STRINGS
  add hl, bc;[hl] = lower byte of strings address
  ld a, [hli]
  ld b, a
  ld a, [hl]
  ld h, a
  ld l, b
  pop bc;index
  call str_FromArray
  ld de, str_buffer
  rst str_Copy
  ld hl, str_buffer

  pop af;previous bank
  SET_BANK
  ret

EnterMapDoor::;a = door index
  ld b, a;index
  ldh a, [loaded_bank]
  push af;current bank
  push bc;index
  call GetCurrentMap
  SET_BANK
  
  ld bc, MAP_DATA_DOORS
  add hl, bc;[hl] = lower byte of doors address
  ld a, [hli]
  ld c, a
  ld a, [hl]
  ld b, a
  pop af;index
  push bc;doors address

  ld de, 5;bytes per door
  rst math_Multiply;index * bytes per door
  pop bc;doors address
  add hl, bc;door at index
  ld a, [hli]
  ld [map], a
  ld a, [hli]
  ld [map_chunk], a
  ld a, [hli]
  ld [map_x], a
  ld a, [hli]
  ld [map_y], a
  ld a, [hl]
  ldh [map_last_button_state], a

  call LoadMap
  
  pop af;previous bank
  SET_BANK
  ret

CheckMapItemFlags:: ;item index in b, returns z if flag not set
  ldh a, [loaded_bank]
  push af;current bank
  call GetMapItem
  pop af;previous bank
  SET_BANK

  ld b, 0
  ld c, d;flag index
  ld hl, item_flags
  add hl, bc;item flag to set
  ld a, [hl];current flags
  and a, e;check bit
  ret

PickUpMapItem:: ;item index in b
  ldh a, [loaded_bank]
  push af;current bank

  call GetMapItem

;;  ld a, BANK(TryPickupItem)
;;  SET_BANK
;;  call TryPickupItem;bc = item id, de = flag index/bits
  jr z, .exit
.clearSprites
  call ClearMapSprites
  call DrawMapToScreen
.exit
  pop af;previous bank
  SET_BANK
  ret

GetMapItem:: ;item index in b, returns item id/count in bc, flag index/bits in de
  push bc;item index in b
  call GetCurrentMap
  SET_BANK

  ld bc, MAP_DATA_ITEMS
  add hl, bc;[hl] = lower byte of items address
  ld a, [hli]
  ld c, a
  ld a, [hl]
  ld b, a
  pop af;item index in a
  push bc;items address
  
  ld h, 0
  ld l, a
  ld de, 3;item id, flag index, flag bit
  rst math_Multiply
  pop bc;items address
  add hl, bc
  ld a, [hli];item id
  ld b, a;item id
  ld c, 1;num items to add
  ld a, [hli];flag index
  ld d, a
  ld a, [hli];flag bits
  ld e, a
  ret

PlayMapTeam:: ;team index in [map_collision_data]
  ldh a, [loaded_bank]
  push af;current bank

  call GetMapAddress;sets team bank, puts team address in hl
;;  ld de, Opponent
;;  ld bc, OpponentEnd-Opponent
;;  call mem_Copy;team lineup in hl
;;  ld de, OpponentLineup
;;  ld bc, OpponentLineupPlayer2-OpponentLineupPlayer1;size of PLAYER_DATA + OPPONENT_PLAYER_DATA
;;  call CreateLineup
;;  TRAMPOLINE PlayTeam

  pop af;previous bank
  SET_BANK
  ret

RunMapScript:: ;script index in [map_collision_data]
  ldh a, [loaded_bank]
  push af;current bank

  call GetMapAddress;sets script bank, puts script address in hl
  ld de, .return
  push de
  jp hl
.return 

  pop af;previous bank
  SET_BANK
  ret

GetMapAddress: ;address index in [map_collision_data], switches to bank of address and returns it in hl
  call GetCurrentMap
  SET_BANK

  ld bc, MAP_DATA_ADDRESSES
  add hl, bc;[hl] = lower byte of scripts address
  ld a, [hli]
  ld c, a
  ld a, [hl]
  ld b, a
  push bc;scripts address
  
  ldh a, [map_collision_data]
  ld de, 3;bank (1 byte) + address (2 bytes)
  rst math_Multiply
  pop bc;scripts address
  add hl, bc
  ld a, [hli];bank
  ld b, a;bank
  ld a, [hli];lower byte of script address
  ld c, a
  ld a, [hli];upper byte of script address
  ld h, a
  ld l, c;hl = script address
  ld a, b;bank
  SET_BANK
  ret

;TODO: handle water vs grass
GetMapEncounter::;returns age in b, player num in c, props in d
  ldh a, [loaded_bank]
  push af;current bank

  call gbdk_Random
  call GetMapArea;switches to map bank, returns area address in hl
  ld a, [hli];num encounters in a, encounter list address in hl
  ld c, a;num encounters
  ld a, [rand_hi]
  ld e, a
.loop
    ld a, [hli];player num
    and a
    jr z, .exit
    ld c, a
    ld a, [hli];age
    ld b, a
    ld a, [hli];props
    ld d, a
    ld a, [hli];chance
    cp a, e
    jr c, .loop
.exit 
  pop af;previous bank
  SET_BANK
  ret

GetMapArea:: ;sets bank to current map, returns current chunk's area in hl
  call GetCurrentMap
  SET_BANK
  push hl;map address

  call GetCurrentMapChunk
  ld bc, MAP_CHUNK_AREA
  add hl, bc
  ld a, [hl];area index

  pop hl;map address
  push af;area index
  ld bc, MAP_DATA_AREAS
  add hl, bc;areas jump table address
  ld a, [hli];lower byte of table address
  ld c, a
  ld a, [hli];upper byte of table address
  ld h, a
  ld l, c;areas jump table

  pop af;area index
  ld b, 0
  ld c, a;area index
  add hl, bc
  add hl, bc;area address
  ld a, [hli];lower byte of area address
  ld c, a
  ld a, [hli];upper byte of area address
  ld h, a
  ld l, c;area in hl

  ret

ClearMapSprites::
  xor a
  ldh [map_sprite_count], a
  ld hl, oam_buffer+4*4
  ld bc, 36*4
  call mem_Set
  xor a
  ld hl, sprite_obj_buffer
  ld bc, SPRITE_OBJ_BUFFER_SIZE
  call mem_Set
  ret

CopyMapSpritesToOAMBuffer::;iterates through map sprites, copying values to oam_buffer
  ldh a, [loaded_bank]
  push af;current bank
  ld hl, oam_buffer+16;4 sprites for user avatar * 4 bytes per sprite
  ld de, sprite_obj_buffer
  ldh a, [map_sprite_count]
  and a
  jp z, .clearRemainingOAM
.loopMapSprites
    push af;count
    ld a, [de];bank
    inc de
    SET_BANK
    ld a, [de];lower address
    ld c, a
    inc de
    ld a, [de];upper address
    ld b, a
    inc de
    push bc;map sprite address
    ldh a, [rSCX]
    ld b, a;bg scroll x
    ld a, [de];x
    add a, 8;x+8
    sub a, b;x+8-scroll x
    ld b, a;x+8-scroll x
    BETWEEN 192, 224
    jp nz, .removeSprite
    inc de
    ldh a, [rSCY]
    ld c, a;bg scroll y
    ld a, [de];y
    add a, 10;y+10... why isn't this 8? exporter?
    sub a, c;y+10-scroll y
    ld c, a
    BETWEEN 192, 224
    ld a, c
    jp nz, .offScreenY
    ldh [map_temp_y], a
    ld a, b;x
    ldh [map_temp_x], a
    inc de
    ld a, [de];extra data
    ldh [map_temp_a], a;extra data
    inc de;next map sprite
    pop bc;map sprite address
    ld a, [bc];map object type/collision flags
    inc bc;initial x 
    inc bc;initial y
    inc bc;tile or lower byte of address
    and a, MAP_OBJ_TYPE_MASK
    cp a, MAP_OBJ_TILE
    jr z, .spriteTile
    cp a, MAP_OBJ_STAMP
    jr z, .spriteStamp
    cp a, MAP_OBJ_AVATAR
    jr z, .spriteAvatar
    cp a, MAP_OBJ_META_SPRITE
    jr z, .metaSprite
  .spriteError ;We should never get here. Why are we?
    ld bc, 4
    add hl, bc
    pop af
    dec a
    jp nz, .loopMapSprites
    jr .clearRemainingOAM
  .metaSprite
    push de;map sprite buffer
    ld a, [bc];lower byte
    ld d, a;lower byte
    inc bc
    ld a, [bc];upper byte
    ld b, a
    ld c, d
    pop de;map sprite buffer
    push de
    dec de;location of current frame
    call CopyMetaSpriteToOAMBuffer
    pop de;map sprite buffer
    pop af;count
    dec a
    jp nz, .loopMapSprites
    jr .clearRemainingOAM
  .spriteAvatar
    push de;map sprite buffer
    ld a, [bc];lower byte
    ld d, a;lower byte
    inc bc
    ld a, [bc];upper byte
    ld b, a
    ld c, d
    ldh a, [map_temp_a];extra data
    ld d, a
    call CopyMapAvatarToOAMBuffer
    pop de;map sprite buffer
    pop af;count
    dec a
    jp nz, .loopMapSprites
    jr .clearRemainingOAM
  .spriteStamp
    push de;map sprite buffer
    ld a, [bc];lower byte
    ld d, a;lower byte
    inc bc
    ld a, [bc];upper byte
    ld b, a
    ld c, d
    call CopySpriteStampToOAMBuffer;bc = stamp, hl = OAM buffer, returns next OAM buffer slot in hl
    pop de;map sprite buffer
    pop af;count
    dec a
    jp nz, .loopMapSprites
    jr .clearRemainingOAM
  .spriteTile
    ldh a, [map_temp_y]
    ld [hli], a;y
    ldh a, [map_temp_x]
    ld [hli], a;x
    ld a, [bc];tile
    ld [hli], a;tile
    inc bc;palette
    ld a, [bc]
    ld [hli], a
  .checkEndOfOAM
    ld a, l
    cp a, LOW(oam_buffer+40*4)
    jr nc, .outOfOAM
    pop af;count
    dec a
    jp nz, .loopMapSprites
.clearRemainingOAM
    ld a, l
    cp a, LOW(oam_buffer+40*4);assumes lower byte oam_buffer address is 0
    jr nc, .exit
    xor a
    ld [hli], a
    jr .clearRemainingOAM
.exit
  pop af;bank
  SET_BANK
  ret
.outOfOAM
  pop af;toss count
  jr .exit
.offScreenY
  dec de;[x]
.removeSprite
  pop bc;discard map sprite address
  push hl;OAM
  dec de;[upper map sprite address]
  dec de;[lower map sprite address]
  dec de;[bank], sprite to be removed
  ldh a, [map_sprite_count]
  dec a
  ldh [map_sprite_count], a
  jr z, .empty
.moveLastToRemovedAddress;sprite_obj_buffer + (map_sprite_count * SPRITE_OBJ_SIZE)
  push de;removed sprite address
  ld c, a;map_sprite_count
  ld b, 0
  
IF SPRITE_OBJ_SIZE != 6
  FAIL "ERROR: SPRITE_OBJ_SIZE == {SPRITE_OBJ_SIZE}. Fast multiplication assumes 6."
ENDC
  ; Fast c * 6 calculation: (c * 4) + (c * 2)
  ld h, b
  ld l, c   ;hl = count
  add hl, hl;hl = count * 2
  ld e, l
  ld d, h   ;de = count * 2
  add hl, hl;hl = count * 4
  add hl, de;hl = count * 6
  
  ld de, sprite_obj_buffer
  add hl, de;last sprite address
  pop de;removed sprite address
  push de

REPT SPRITE_OBJ_SIZE
  ld a, [hli]
  ld [de], a
  inc de
ENDR
  pop de;removed sprite address
  pop hl;OAM
  pop af;sprites left
  dec a
  jp nz, .loopMapSprites
  jp .clearRemainingOAM
.empty
  pop hl;OAM
  pop af;discard sprites left
  jp .clearRemainingOAM

CopySpriteStampToOAMBuffer:;bc = stamp, hl = OAM buffer, [map_temp_x][map_temp_y] = position, returns count in a, sets z if count is 0
  ld a, [bc];stamp width
  ldh [map_temp_width], a
  sla a
  sla a;8px * width / 2
  ld d, a
  ldh a, [map_temp_x];x
  sub a, d
  add a, 8
  ld d, a
  inc bc

  ld a, [bc];stamp height
  ldh [map_temp_height], a
  sla a
  sla a;8px * height / 2
  ld e, a
  ldh a, [map_temp_y];y
  sub a, e
  ld e, a
  inc bc

  push hl;OAM buffer
  ldh a, [map_temp_height]
.loopTilesY
    push af;height
    push de;xy
    ldh a, [map_temp_width]
  .loopTilesX
      push af;width
      push de;xy
      ld a, e
      ld [hli], a;y
      ld a, d
      ld [hli], a;x
      ld a, [bc]
      ld [hli], a;tile
      inc bc
      inc hl;skip props
      pop de;xy
      ld a, 8
      add a, d
      ld d, a;x
      pop af;width
      dec a
      jr nz, .loopTilesX
    pop de;xy
    ld a, 8
    add a, e
    ld e, a;y
    pop af;height
    dec a
    jr nz, .loopTilesY

  pop hl;OAM buffer
  ldh a, [map_temp_height]
.loopPropsY
    push af;height
    ldh a, [map_temp_width]
  .loopPropsX
      push af;width
      inc hl;skip y
      inc hl;skip x
      inc hl;skip tile
      ld a, [bc];props
      ld [hli], a
      inc bc
      pop af;width
      dec a
      jr nz, .loopPropsX
    pop af;height
    dec a
    jr nz, .loopPropsY
  ret

CopyMetaSpriteToOAMBuffer::;bc = meta sprite, de = location of current frame, hl = OAM buffer, [map_temp_x][map_temp_y] = position, returns count in a
  ldh a, [loaded_bank]
  push af;loaded bank
  ld a, [map_meta_sprites_bank]
  SET_BANK
  push de;location of current frame
  inc bc;skip width
  inc bc;skip height
  ld a, [bc];frame count
  inc bc
  cp a, 1
  jr z, .frameZero;frame count == 1
  ld d, a;frame count
  ld a, [map_temp_a];current frame
  and a
  jr z, .frameZero
  cp a, d;compare current frame to frame count
  jr c, .calcFrame;if current frame >= frame count

.frameZero
  pop de;address of current frame
  xor a
  ld [de], a;reset to frame zero
  ld a, [bc];sprite count
  inc bc;first sprite address
  jr .copyToOAM;no need to calculate frame if frame zero

.calcFrame
  pop de;discard address of current frame
  push hl;oam
  push af;current frame
  ld a, [bc];sprite count
  push af;sprite count
  ld h, 0
  ld l, a;sprite count
  add hl, hl;sprite count * 2
  add hl, hl;sprite count * 4 (bytes per sprite)
  inc bc;first sprite address
  push bc
  ld b, h
  ld c, l;byte count
  ld de, tile_buffer
  pop hl;first sprite address
  call mem_Copy;puts frame 0 data in tile buffer, frame 1 address in hl
  pop af;sprite count
  ld b, a
  pop af;current frame
  ld d, a
  push bc;sprite count
.copyFramesLoop
    ld a, [hli];change count
    and a
    jr z, .nextFrame
    ld e, a
  .copyChangesLoop
      ld bc, tile_buffer
      ld a, [hli];byte offset
      add a, c
      ld c, a;no need to check carry, tile buffer is at beginning of WRAMX
      ld a, [hli];new data
      ld [bc], a
      dec e
      jr nz, .copyChangesLoop
  .nextFrame
    dec d
    jr nz, .copyFramesLoop
  pop af;sprite count
  ld bc, tile_buffer
  pop hl;oam

.copyToOAM
  push af;sprite count
  ld e, a
.loop
    ldh a, [map_temp_y]
    ld d, a
    ld a, [bc];y
    add a, d
    ld [hli], a
    inc bc

    ldh a, [map_temp_x]
    ld d, a
    ld a, [bc];x
    add a, d
    ld [hli], a
    inc bc

    ld a, [bc];tile
    ld [hli], a
    inc bc

    ld a, [bc];props
    ld [hli], a
    inc bc

    dec e
    jr nz, .loop

  pop bc;sprite count in b
  pop af;previously loaded bank
  SET_BANK
  ld a, b;sprite count
  ret 

CopyMapAvatarToOAMBuffer::;hl = oam buffer address, bc = avatar address, d = extra data, returns new extra data in d
  push de;d = extra data
  ldh a, [loaded_bank]
  push af;loaded bank
  ld a, BANK(GBAvatars)
  SET_BANK;assumes all map avatars and animations are in the same bank
  ld a, d;extra data
  and a, MAP_AVATAR_DIRECTION
  rlc a
  rlc a
.getAddressForDirection
  jr z, .loadAnimation
  inc bc
  inc bc
  dec a
  jr .getAddressForDirection
.loadAnimation
  push hl;oam address
  ld e, l;lower byte of oam address
  srl e
  srl e;oam index = oam address/4
  ld a, [bc];lower byte
  ld l, a
  inc bc
  ld a, [bc];upper byte
  ld h, a
  ld b, e;index
  xor a
  call AnimateAvatar
  pop hl;oam address
.moveToPosition
  ld d, 8
  ldh a, [map_temp_x]
  sub a, d
  add a, 8
  ld d, a

  ld e, 8
  ldh a, [map_temp_y]
  sub a, e
  ld e, a
  
  ld a, 2;height
.loopY
    push af;height
    push de;xy
    ld a, 2;width
  .loopX
      push af;width
      ld a, e
      ld [hli], a;y
      ld a, d
      ld [hli], a;x
      inc hl
      inc hl
      ld a, 8
      add a, d
      ld d, a;x
      pop af;width
      dec a
      jr nz, .loopX
    pop de;xy
    ld a, 8
    add a, e
    ld e, a;y
    pop af;height
    dec a
    jr nz, .loopY
.restoreBank
  pop af;previously loaded bank
  SET_BANK
  pop de;extra data
  ret

AnimateAvatar::;a = frame(<52), hl = animation, b = OAM index
  push af;frame
  push bc;b = OAM index
  ld b, a;frame
  add a, a;a*2
  add a, a;a*4
  add a, b;a*5
  ld b, 0
  ld c, a
  add hl, bc

  ld a, [hli];flip
  push af;flip

  ld a, [hli]
  ld c, a
  ld a, [hli]
  ld b, a;tilemap

  ld a, [hli]
  ld e, a
  ld a, [hl]
  ld d, a;propmap

  ld h, b
  ld l, c;tilemap

  pop af;flip
  and a
  jr z, .copyToOAM

  ld a, 4
  ld bc, tile_buffer
.flipPropsLoop
    push af
    ld a, [de]
    xor a, OAMF_XFLIP
    ld [bc], a
    inc de
    inc bc

    pop af
    dec a
    jr nz, .flipPropsLoop

  ld de, tile_buffer+4
  ld bc, 4
  call mem_Copy

  ld hl, tile_buffer
  ld c, 4
.swapLoop
    ld a, [hli]
    ld b, a
    ld a, [hld]
    ld [hli], a
    ld a, b
    ld [hli], a
    dec c
    jr nz, .swapLoop

  ld de, tile_buffer
  ld hl, tile_buffer+4

.copyToOAM
  pop bc;b = offset
  push hl
  ld hl, oam_buffer
  ld c, b
  ld b, 0
  add hl, bc
  add hl, bc
  add hl, bc
  add hl, bc
  ld b, h
  ld c, l
  pop hl
  ld a, 4
.loop
    push af
    inc bc
    inc bc
    ld a, [hli]
    ld [bc], a
    inc bc
    ld a, [de]
    inc de
    ld [bc], a
    inc bc
    pop af
    dec a
    jr nz, .loop

  pop af;frame
  inc a
  cp WALK_ANIM_FRAMES
  ret nz
  xor a
  ret

GetScreenCollision::;bc = xy pixel offset (-127,127), returns z if no collision, obj/collision type in a, extra data in b, map sprite index or -1 in c
  ldh a, [loaded_bank]
  push af;current bank
  push bc;xy offset
  call GetCurrentMap
  SET_BANK
  pop bc;xy offset
  call GetMapChunkForOffset
  call GetMapChunkCollision
  pop de;previous bank
  push af;obj/collision type and flags
  ld a, [hl];extra data
  ld b, a
  ld a, d;previous bank
  SET_BANK
  pop af;obj/collision type and flags
  ret

GetMapChunkCollision:;hl = chunk address, de = xy, returns z if no collision, obj/collision type in a, extra data in [hl], map sprite index or -1 in c
  push hl;chunk address
  push de;xy
  call GetSpriteCollision
  jp nz, .spriteCollisionFound
  pop de;xy
  pop bc;chunk address
  ld a, d
  srl a
  ldh [map_temp_x], a
  ld a, e
  srl a
  ldh [map_temp_y], a
  ld hl, MAP_CHUNK_DATA
  add hl, bc
.loop
    ld a, [hli];map object type and collision
    and a
    ret z; done if 0
    
    ld b, a;map object type and collision
    and a, MAP_COLLISION_MASK
    ld c, a;collision type
    push bc;b = obj type and collision, c = just collision
    
    ld a, [hli];x
    srl a
    ld d, a
    ld a, [hli];y
    srl a
    ld e, a
    
    ld a, b;map object type and collision
    and a, MAP_OBJ_TYPE_MASK
    cp a, MAP_OBJ_STAMP
    jp z, .stamp
    cp a, MAP_OBJ_TILE
    jp z, .tile
    cp a, MAP_OBJ_NONE
    jp z, .blankTile
    cp a, MAP_OBJ_NONE_FILL
    jp z, .blankFill
    ;fall through to .fill instead of comparing and jumping
    ; cp a, MAP_OBJ_STAMP_FILL
    ; jp z, .fill
    ; cp a, MAP_OBJ_TILE_FILL
    ; jp z, .fill
  
  .fill
    inc hl;skip tile/char/stringID
    inc hl;skip palette
  .blankFill
    ldh a, [map_temp_x]
    cp a, d;x1
    jr c, .skip2Bytes
    ldh a, [map_temp_y]
    cp a, e;y1
    jr c, .skip2Bytes
    ld a, [hli];x2
    inc a
    srl a
    ld d, a
    ld a, [hli];y2
    inc a
    srl a
    ld e, a
    ldh a, [map_temp_x]
    cp a, d;x2
    jp nc, .checkExtraData
    ldh a, [map_temp_y]
    cp a, e;y2
    jp c, .collisonFound
    jp .checkExtraData

  .tile
    inc hl;skip tile or stamp lower address
    inc hl;skip palete or stamp upper address
  .blankTile
    ldh a, [map_temp_x]
    cp a, d;x
    jp nz, .checkExtraData
    ldh a, [map_temp_y]
    cp a, e;y
    jp z, .collisonFound
    jp .checkExtraData

  .stamp
    ldh a, [map_temp_x]
    cp a, d;x
    jr c, .skip2Bytes
    ldh a, [map_temp_y]
    cp a, e;y
    jr c, .skip2Bytes
    ld a, [hli];stamp lower address
    ld c, a
    ld a, [hli];stamp upper address
    ld b, a;bc = stamp address
    ld a, [bc];width
    inc a
    srl a
    inc bc
    add a, d;x+width
    ld d, a;x2
    ldh a, [map_temp_x]
    cp a, d;x2
    jp nc, .checkExtraData
    ld a, [bc];height
    inc a
    srl a
    add a, e;y+height
    ld e, a;y2
    ldh a, [map_temp_y]
    cp a, e;y2
    jp c, .collisonFound
    jp .checkExtraData

  .skip2Bytes
    inc hl
    inc hl

  .checkExtraData
    pop bc;b = obj type and collision, c = just collision
    ld a, c
    cp a, MAP_COLLISION_TEXT
    jp z, .hasExtraData
    cp a, MAP_COLLISION_SCRIPT
    jp z, .hasExtraData
    cp a, MAP_COLLISION_LEDGE
    jr z, .hasExtraData
    cp a, MAP_COLLISION_DOOR
    jr z, .hasExtraData
    jp .loop
  .hasExtraData
    inc hl
    jp .loop

.spriteCollisionFound
  pop de;toss xy
  pop de;toss chunk address
  ret;a = obj/collision type, [hl] = extra data, c = sprite index

.collisonFound
  pop bc;b = obj type and collision, c = just collision
  ld a, c
  cp a, MAP_COLLISION_NONE
  jp z, .loop
  ld a, b;obj/collision type
  ret

GetSpriteCollision::;de = tile xy, returns z if no collision, obj/collision type in a, extra data in [hl], map sprite index or -1 in c
  ld c, -1
  ldh a, [map_sprite_count]
  and a
  ret z;done if no sprites in buffer
  
  ;sprite xy/16 = tile xy/2
  srl d;x/2
  swap d
  srl e;y/2
  swap e

  PUSH_VAR loaded_bank
  ld hl, sprite_obj_buffer
  ldh a, [map_sprite_count]
.loop
    push af;count
    ld a, [hli];bank
    SET_BANK
    ld a, [hli];lower byte of address
    ld c, a
    ld a, [hli];upper byte of address
    ld b, a
    ld a, [hli];x
    and a, %11110000
    cp a, d
    jr nz, .xMismatch
    ld a, [hli];y
    and a, %11110000
    cp a, e
    jr nz, .yMismatch
    jr .matchFound
  .xMismatch
    inc hl;skip y
  .yMismatch
    inc hl;skip extra data
    pop af;count
    dec a
    jr nz, .loop
.noMatchFound
  POP_VAR loaded_bank
  SET_BANK
  ld c, -1
  xor a
  ret
.matchFound
  ld hl, 5
  add hl, bc;extra data, if any
  ld a, [bc];obj/collision type
  ld b, a
  and a, MAP_OBJ_TYPE_MASK
  cp a, MAP_OBJ_AVATAR
  jr nz, .finish
  inc hl
.finish
  pop af;count
  ld c, a
  ldh a, [map_sprite_count]
  sub a, c
  ld c, a;sprite index
  POP_VAR loaded_bank
  SET_BANK
  ld a, b;obj/collision type
  or a, MAP_COLLISION_MASK;test for collision
  ld a, b;return obj/collision type
  ret

MoveMapLeft::
  ldh a, [loaded_bank]
  push af;current bank
  call GetCurrentMap
  SET_BANK
  ldh a, [map_scroll_speed]
  ld b, a
  ldh a, [rSCX]
  sub a, b
  push af;new scx
  ld d, a
  jr nc, .noChunkChangeWest
  ld a, MAP_CHUNK_WEST
  call GetCurrentMapChunkNeighbor
  call SetCurrentMapChunk
.noChunkChangeWest
  srl d
  srl d
  srl d
  ld a, [map_x]
  cp a, d
  jp z, .move;if x == map_x, no draw
  ld a, d
  ld [map_x], a
  call DrawMapLeftEdge
.move
  pop af;new scx
  ldh [rSCX], a
  pop af;previous bank
  SET_BANK
  ret

MoveMapRight::
  ldh a, [loaded_bank]
  push af;current bank
  call GetCurrentMap
  SET_BANK
  ldh a, [map_scroll_speed]
  ld b, a
  ldh a, [rSCX]
  add a, b
  push af
  ld d, a
  jr nc, .noChunkChangeEast
  ld a, MAP_CHUNK_EAST
  call GetCurrentMapChunkNeighbor
  call SetCurrentMapChunk
.noChunkChangeEast
  srl d
  srl d
  srl d
  ld a, [map_x]
  cp a, d
  jp z, .move;if x == map_x, no draw
  ld a, d
  ld [map_x], a
  call DrawMapRightEdge
.move
  pop af
  ldh [rSCX], a
  pop af;previous bank
  SET_BANK
  ret

MoveMapUp::
  ldh a, [loaded_bank]
  push af;current bank
  call GetCurrentMap
  SET_BANK
  ldh a, [map_scroll_speed]
  ld b, a
  ldh a, [rSCY]
  sub a, b
  push af
  ld e, a
  jr nc, .noChunkChangeNorth
  ld a, MAP_CHUNK_NORTH
  call GetCurrentMapChunkNeighbor
  call SetCurrentMapChunk
.noChunkChangeNorth
  srl e
  srl e
  srl e
  ld a, [map_y]
  cp a, e
  jp z, .move;if y == map_y, no draw
  ld a, e
  ld [map_y], a
  call DrawMapTopEdge
.move
  pop af
  ldh [rSCY], a
  pop af;previous bank
  SET_BANK
  ret

MoveMapDown::
  ldh a, [loaded_bank]
  push af;current bank
  call GetCurrentMap
  SET_BANK
  ldh a, [map_scroll_speed]
  ld b, a
  ldh a, [rSCY]
  add a, b
  push af
  ld e, a
  jr nc, .noChunkChangeSouth
  ld a, MAP_CHUNK_SOUTH
  call GetCurrentMapChunkNeighbor
  call SetCurrentMapChunk
.noChunkChangeSouth
  srl e
  srl e
  srl e
  ld a, [map_y]
  cp a, e
  jp z, .move;if y == map_y, no draw
  ld a, e
  ld [map_y], a
  call DrawMapBottomEdge
.move
  pop af
  ldh [rSCY], a
  pop af;previous bank
  SET_BANK
  ret

LoadMap::
  di
  ldh a, [loaded_bank]
  push af;current bank

  call GetCurrentMap
  SET_BANK
  push af;map bank
  push hl;map address

  ld a, [hli]
  ld [map_meta_sprites_bank], a
  ldh a, [sys_info]
  and a, SYS_INFO_GBC
  jr z, .setMapTiles

.setMapPalettes
  ld a, [hli]
  ld b, a
  ld a, [hl]
  ld h, a
  ld l, b;hl = palette address

  ld a, BCPSF_AUTOINC
  ldh [rBCPS], a
  ld c, 8;TODO: only load last 7 palettes, first should be UI
.bgLoop
    ld a, [hli]
    ldh [rBCPD], a
    ld a, [hli]
    ldh [rBCPD], a;color 1
    ld a, [hli]
    ldh [rBCPD], a
    ld a, [hli]
    ldh [rBCPD], a;color 2
    ld a, [hli]
    ldh [rBCPD], a
    ld a, [hli]
    ldh [rBCPD], a;color 3
    xor a
    ldh [rBCPD], a
    ldh [rBCPD], a;color 4 always black
    dec c
    jr nz, .bgLoop

  ld a, OCPSF_AUTOINC
  ldh [rOCPS], a
  ld c, 7;last palette is skipped, always the player's colors
.spriteLoop
    ldh [rOCPD], a;don't load from hl
    ldh [rOCPD], a;first color isn't used
    ld a, [hli]
    ldh [rOCPD], a
    ld a, [hli]
    ldh [rOCPD], a;color 2
    ld a, [hli]
    ldh [rOCPD], a
    ld a, [hli]
    ldh [rOCPD], a;color 3
    ld a, [hli]
    ldh [rOCPD], a
    ld a, [hli]
    ldh [rOCPD], a;color 4
    dec c
    jr nz, .spriteLoop

.setMapTiles
  pop hl;map address

  ;animations
  ld bc, MAP_DATA_TILE_ANIMS
  add hl, bc;current map address + tile anim offset
  ld a, [hli]
  ld e, a
  ld a, [hli]
  ld d, a;bg tiles address in de
  push hl

  ld h, d
  ld l, e
  ld a, [hl];count
  ld b, a
  add a, a;count*2
  add a, b;count*3
  add a, a;count*6
  inc a;count*6+1
  ld b, 0
  ld c, a
  ld de, tile_anim_buffer
  call mem_Copy

  ;images
  pop hl
  ld a, [hli]
  ld b, a;bg tiles bank
  ld a, [hli]
  ld e, a
  ld a, [hli]
  ld d, a;bg tiles address in de
  push hl;sprite tiles
  
  ld a, b
  ld [rROMB0], a;bg tiles bank
  ld h, d
  ld l, e;bg tiles address in hl
  ld de, $8800
  ld bc, 128*16;tiles*bytes/tile
  call mem_CopyVRAM

  pop hl;sprite tiles
  pop af;map bank
  ld [rROMB0], a;restore map bank to read sprite tiles

  ld a, [hli]
  ld b, a;sprite tiles bank
  ld a, [hli]
  ld e, a
  ld a, [hli]
  ld d, a;sprite tiles address in de

  ld a, b
  ld [rROMB0], a;sprite tiles bank
  ld h, d
  ld l, e;sprite tiles address in hl
  ld de, $8000
  ld bc, 128*16;tiles*bytes/tile
  call mem_CopyVRAM

.drawMap
  call ClearMapSprites
  call DrawMapToScreen
  call CopyMapSpritesToOAMBuffer

  pop af;previous bank
  SET_BANK
  reti

DrawMapLeftEdge:
  ld bc, $0113
  ld a, [map_x]
  ld d, a
  ld a, [map_y]
  ld e, a
.testY
  cp a, 14
  jr c, .drawCurrentChunk
  ld a, 32
  sub a, e;bottom-y
  ld c, a;h=bottom-y
.drawCurrentChunk
  push bc;wh
  push de;xy
  call GetCurrentMapChunk
  call DrawMapChunk
  pop de;xy
  pop bc;wh
.testSouth
  ld a, c;h
  cp a, 19;full h
  ret z
.drawSouthChunk
  ld e, 0
  ld a, 19;full h
  sub a, c;19-h
  ld c, a;h=19-h
  ld a, MAP_CHUNK_SOUTH
  call GetCurrentMapChunkNeighbor
  call DrawMapChunk
  ret

DrawMapRightEdge:
  call GetCurrentMapChunk
  ld bc, $0113
  ld a, [map_y]
  ld e, a
  ld a, [map_x]
  add a, 20
  ld d, a
.testX
  sub a, 32
  jr c, .testY
  ld d, a
  ld a, MAP_CHUNK_EAST
  call GetMapChunkNeighbor
.testY
  ld a, e;y
  cp a, 14
  jr c, .drawCurrentChunk
  ld a, 32
  sub a, e;bottom-y
  ld c, a;h=bottom-y
.drawCurrentChunk
  push bc;wh
  push de;xy
  push hl;chunk
  call DrawMapChunk
  pop hl;chunk
  pop de;xy
  pop bc;wh
.testSouth
  ld a, c;h
  cp a, 19;full h
  ret z
.drawSouthChunk
  ld e, 0
  ld a, 19;full h
  sub a, c;19-h
  ld c, a;h=19-h
  ld a, MAP_CHUNK_SOUTH
  call GetMapChunkNeighbor
  call DrawMapChunk
  ret

DrawMapTopEdge:
  ld a, [map_x]
  ld d, a
  ld a, [map_y]
  ld e, a
  ld bc, $1501
.testX
  ld a, d;x
  cp a, 12
  jr c, .drawCurrentChunk
  ld a, 32
  sub a, d;right-x
  ld b, a;w=right-x
.drawCurrentChunk
  push bc;wh
  push de;xy
  call GetCurrentMapChunk
  call DrawMapChunk
  pop de;xy
  pop bc;wh
.testEast
  ld a, b;w
  cp a, 21;full w
  ret z
.drawEastChunk
  ld d, 0
  ld a, 21;full w
  sub a, b;21-w
  ld b, a;w=21-w
  ld a, MAP_CHUNK_EAST
  call GetCurrentMapChunkNeighbor
  call DrawMapChunk
  ret

DrawMapBottomEdge:
  call GetCurrentMapChunk
  ld bc, $1501
  ld a, [map_x]
  ld d, a
  ld a, [map_y]
  add a, 18
  ld e, a
.testY
  sub a, 32
  jr c, .testX
  ld e, a
  ld a, MAP_CHUNK_SOUTH
  call GetMapChunkNeighbor
.testX
  ld a, d;x
  cp a, 12
  jr c, .drawCurrentChunk
  ld a, 32
  sub a, d;right-x
  ld b, a;w=right-x
.drawCurrentChunk
  push bc;wh
  push de;xy
  push hl;chunk
  call DrawMapChunk
  pop hl;chunk
  pop de;xy
  pop bc;wh
.testEast
  ld a, b;w
  cp a, 21;full w
  ret z
.drawEastChunk
  ld d, 0
  ld a, 21;full w
  sub a, b;21-w
  ld b, a;w=21-w
  ld a, MAP_CHUNK_EAST
  call GetMapChunkNeighbor
  call DrawMapChunk
  ret
  
DrawMapToScreen::
  ldh a, [loaded_bank]
  push af;current bank
  call GetCurrentMap
  SET_BANK
  
  ld a, [map_x]
  ld d, a
  sla a
  sla a
  sla a
  ldh [rSCX], a
  ld a, [map_y]
  ld e, a
  sla a
  sla a
  sla a
  ldh [rSCY], a
  ld bc, $1513;w+1,h+1
.testX
  ld a, d;x
  cp a, 12
  jr c, .testY
  ld a, 32
  sub a, d;right-x
  ld b, a;w=right-x
.testY
  ld a, e;y
  cp a, 14
  jr c, .drawCurrentChunk
  ld a, 32
  sub a, e;bottom-y
  ld c, a;h=bottom-y
.drawCurrentChunk
  push bc;wh
  push de;xy
  call GetCurrentMapChunk
  call DrawMapChunk
  pop de;xy
  pop bc;wh
.testEast
  ld a, b;w
  cp a, 21;full w
  jr z, .testSouth
.drawEastChunk
  push bc;wh
  push de;xy
  ld d, 0
  ld a, 21;full w
  sub a, b;21-w
  ld b, a;w=21-w
  ld a, MAP_CHUNK_EAST
  call GetCurrentMapChunkNeighbor
  call DrawMapChunk
  pop de;xy
  pop bc;wh
.testSouth
  ld a, c;h
  cp a, 19;full h
  jp z, .finish
.drawSouthChunk
  ld e, 0
  ld a, 19;full h
  sub a, c;19-h
  ld c, a;h=19-h
  push bc;wh
  push de;xy
  ld a, MAP_CHUNK_SOUTH
  call GetCurrentMapChunkNeighbor
  call DrawMapChunk
  pop de;xy
  pop bc;wh
.testSouthEast
  ld a, b;w
  cp a, 21;full w
  jp z, .finish
.drawSouthEastChunk
  ld d, 0
  ld a, 21;full w
  sub a, b;21-w
  ld b, a;w=21-w
  ld a, MAP_CHUNK_SOUTH
  call GetCurrentMapChunkNeighbor
  ld a, MAP_CHUNK_EAST
  call GetMapChunkNeighbor
  call DrawMapChunk
.finish
  pop af;previous bank
  SET_BANK
  ret

DrawMapChunk::; hl = chunk address, de=xy, bc=wh
.testWidth
  ld a, b;w
  and a
  ret z 
.testHeight 
  ld a, c;h
  and a
  ret z

.storeMinMax
  ld a, d
  ldh [map_min_x], a;minX
  ld a, e
  ldh [map_min_y], a;minY
  ld a, b
  add a, d;x+w
  ldh [map_max_x], a;maxX
  ld a, c
  add a, e;y+h
  ldh [map_max_y], a;maxY
  xor a
  ldh [rVBK], a
.setChunkTile
  ld a, [hli];tile
  push hl;palette address
  push de;xy
  push bc;wh
  ld hl, _SCRN0
  call gbdk_SetTilesTo
  pop bc;wh
  pop de;xy
  pop hl;palette address
.setChunkPalette
  ldh a, [sys_info]
  and a, SYS_INFO_GBC
  jr z, .drawMapObjects
  ld a, 1
  ldh [rVBK], a
  ld a, [hl];pal, no increment since this section can be skipped
  push hl
  ld hl, _SCRN0
  call gbdk_SetTilesTo
  pop hl
  xor a
  ldh [rVBK], a
.drawMapObjects
  ld bc, MAP_CHUNK_DATA-1;already skipped tile
  add hl, bc;skip pal, neighboring chunks, area, and collision
.drawTilesLoop
    ld a, [hli];map object type and collision
    and a
    jp z, .loadSpritesLoop
    ld b, a;map object type and collision

    ld a, [hli];x
    ld d, a
    ld a, [hli];y
    ld e, a
    ld a, b;map object type and collision
    push af;map object type and collision
    and a, MAP_OBJ_TYPE_MASK
    cp a, MAP_OBJ_STAMP
    jp z, .stamp
    cp a, MAP_OBJ_STAMP_FILL
    jp z, .stampFill
    cp a, MAP_OBJ_TILE
    jp z, .tile
    cp a, MAP_OBJ_TILE_FILL
    jp z, .tileFill
    cp a, MAP_OBJ_NONE
    jr z, .checkExtraData
    ; else MAP_OBJ_NONE_FILL
  .noneFill
    inc hl
    inc hl
    jp .checkExtraData
  .tileFill
    call DrawMapTileFill;also does text
    jp .checkExtraData
  .tile
    call DrawMapTile
    jp .checkExtraData
  .stampFill
    call DrawMapStampFill
    jp .checkExtraData
  .stamp
    call DrawMapStamp
    ; jp .checkExtraData

  .checkExtraData
    pop af;map object type and collision
    and a, MAP_COLLISION_MASK
    cp a, MAP_COLLISION_SCRIPT
    jp z, .hasExtraData
    cp a, MAP_COLLISION_TEXT
    jp z, .hasExtraData
    cp a, MAP_COLLISION_LEDGE
    jr z, .hasExtraData
    cp a, MAP_COLLISION_DOOR
    jr z, .hasExtraData
    jp .drawTilesLoop
  .hasExtraData
    inc hl
    jp .drawTilesLoop

.loadSpritesLoop
    ld a, [hl];check done
    and a
    ret z
    ld b, a
    and a, MAP_OBJ_TYPE_MASK
    ldh [map_temp_type], a
    ld a, b
    and a, MAP_COLLISION_MASK
    ldh [map_temp_c], a;collision type

  .testItem
    cp a, MAP_COLLISION_ITEM
    jr nz, .testXY
    push hl; current address
    ld de, 5
    add hl, de
    ld a, [hl]
    ld b, a;item index
    call CheckMapItemFlags
    pop hl; current address
    jp z, .testXY
    ld de, 6
    add hl, de
    jr .loadSpritesLoop
    
  .testXY
    push hl; current address
    inc hl
    ld a, [hli];x
    ld d, a
    ld a, [hli];y
    ld e, a
    push de;xy
    inc d
    srl d
    srl d
    srl d;x/8
    inc e
    srl e
    srl e
    srl e;y/8
    rst TestMapObjectMinXY
    jr z, .outOfRange
    push hl;map sprite address
    ld h, d
    inc h
    ld l, e
    inc l
    rst TestMapObjectMaxXY
    pop hl;map sprite address
    jr z, .outOfRange

    pop de;xy
  .testBankAndAddress
    ld hl, sprite_obj_buffer
    ldh a, [loaded_bank]
    ld b, a;bank
    ldh a, [map_sprite_count]
    and a
    jr z, .addSpritesToBuffer
    pop de;current sprite address
    push de;current sprite address
  .loopMapSprites
      push af;count
      ld a, [hli];bank
      cp a, b;check bank
      jr nz, .bankMismatch
      ld a, [hli];lower byte of address
      cp a, e;compare lower byte
      jr nz, .addressMismatch
      ld a, [hl];upper byte of address
      cp a, d;compare upper byte
      jr nz, .addressMismatch
      jr .spriteAlreadyInBuffer
    .bankMismatch
      inc hl;skip lower address byte
    .addressMismatch
      inc hl;skip upper address byte
      inc hl;skip x
      inc hl;skip y
      inc hl;skip extra data
      pop af;count
      dec a
      jr nz, .loopMapSprites

  .addSpritesToBuffer;hl = next map sprite address
    ldh a, [map_sprite_count]
    inc a
    ldh [map_sprite_count], a
    pop de;current sprite address
    ldh a, [loaded_bank]
    ld [hli], a;bank
    ld a, e
    ld [hli], a;lower byte
    ld a, d
    ld [hli], a;upper byte
    inc de
    ld a, [de];x
    ld [hli], a;x
    inc de
    ld a, [de];y
    ld [hli], a;y
    inc de;tile or address lower
    inc de;pal or address upper
    inc de;next (or extra data)
    ldh a, [map_temp_type]
    cp a, MAP_OBJ_AVATAR
    jr z, .getAvatarExtraData
    ; xor a
    ld a, 2
    jr .initMapSpriteExtraData
  .getAvatarExtraData
    ld a, [de]
  .initMapSpriteExtraData
    ld [hli], a;extra data (zero if not an avatar)
    ld h, d
    ld l, e
    jr .checkExtraSpriteData
  .spriteAlreadyInBuffer
    pop af;discard count
    pop de;current sprite address
    ld hl, 5
    add hl, de
    jr .checkExtraSpriteData
  .outOfRange
    pop de;toss xy
    pop de;toss current sprite address
    inc hl;skip tile or stamp lower
    inc hl;skip palette or stamp upper
  .checkExtraSpriteData
    ldh a, [map_temp_type]
    cp a, MAP_OBJ_AVATAR
    jr nz, .checkSpriteCollisionData
    inc hl ;skip avatar extra data
  .checkSpriteCollisionData
    ldh a, [map_temp_c]
    cp a, MAP_COLLISION_WATER;everything but none and solid have extra data
    jp c, .loadSpritesLoop
  .spriteHasExtraData
    inc hl
    jp .loadSpritesLoop
    
DrawMapStampFill:;hl = stamp fill data, de = xy, min/max XY in min_x,min_y,max_x,max_y
  rst TestMapObjectMinXY
  jr z, .outOfRange

.draw
  ld a, [hli];stamp lower address
  ld c, a
  ld a, [hli];stamp upper address
  ld b, a;bc = stamp address
  push hl;maxX
  ld a, [bc];stamp width
  ld h, a
  inc bc
  ld a, [bc];stamp height
  ld c, a;height
  ld b, h;width
  pop hl;maxX
  ld a, [hli];a = maxX, [hl] = rows
.columnLoop
    push af;maxX
    push de;xy
    ld a, [hld];a = rows, [hl] = maxX
    dec hl;stamp upper address
    dec hl;stamp lower address
  .rowLoop
      push af;maxY
      push bc;wh
      push de;xy
      push hl;stamp data
      call DrawMapStamp;hl = stamp data, de = xy
      pop hl;stamp data
      pop de;xy
      pop bc;wh
      ld a, c;height
      add a, e;y+height
      ld e, a;next y
      pop af;maxY
      cp a, e
      jr nz, .rowLoop
    inc hl
    inc hl
    inc hl
    pop de;xy
    ld a, b;width
    add a, d;x+width
    ld d, a;next x
    pop af;maxX
    cp a, d
    jr nz, .columnLoop
  inc hl
  ret
.outOfRange
  ld bc, 4
  add hl, bc
  ret

DrawMapTileFill:;a = map obj type, hl = tile fill data, de = xy, min/max XY in min_x,min_y,max_x,max_y
  ldh [map_temp_c], a;map obj type
  ld bc, 0
.testX
  ldh a, [map_max_x];maxX
  cp a, d;x
  jp c, .outOfRange;maxX < x
  jp z, .outOfRange;maxX == x
  ldh a, [map_min_x];minX
  cp a, d
  jr c, .testY
  ld d, a
.testY
  ldh a, [map_max_y];maxY
  cp a, e;y
  jp c, .outOfRange;maxY < y
  jp z, .outOfRange;maxY == y
  ldh a, [map_min_y];minY
  cp a, e
  jr c, .draw
  ld e, a
.draw
  ld a, [hli];tile/char/string
  ldh [map_temp_a], a
  ld a, [hli];palette
  ldh [map_temp_b], a
  ld a, [hli];fill maxX
  ld b, a;fill maxX
  ldh a, [map_max_x];chunk maxX
  cp a, b
  jr nc, .skipMaxXTruncate;chunk maxX >= fill maxX
  ld b, a;fill maxX = chunk maxX
.skipMaxXTruncate
  ld a, [hli];fill maxY
  ld c, a;fill maxY
  ldh a, [map_max_y];chunk maxY
  cp a, c
  jr nc, .skipMaxYTruncate;chunk maxY >= fill maxY
  ld c, a;fill maxY = chunk maxY
.skipMaxYTruncate
  ld a, b;maxX
  sub a, d;width
  ret c;if width<0
  ret z;if width==0
  ld b, a
  ld a, c;maxY
  sub a, e;height
  ret c;if height<0
  ret z;if height==0
  ld c, a
  push hl;next map object
  ldh a, [map_temp_a];tile
  push de;xy
  push bc;wh
.singleTile
  ld hl, _SCRN0
  call gbdk_SetTilesTo
.palettes
  pop bc;wh
  pop de;xy
  ldh a, [sys_info]
  and a, SYS_INFO_GBC
  jr z, .nextMapObject
  ld a, 1
  ldh [rVBK], a
  ldh a, [map_temp_b];palette
  ld hl, _SCRN0
  call gbdk_SetTilesTo
  xor a
  ldh [rVBK], a
.nextMapObject
  pop hl;next map object
  ret
.outOfRange
  ld bc, 4
  add hl, bc
  ret

DrawMapStamp:;hl = stamp data, de = xy, min/max XY in min_x,min_y,max_x,max_y, returns wh in bc
  rst TestMapObjectMinXY
  jr z, .outOfRange

.loadStampData
  ld a, [hli];stamp lower address
  ld c, a
  ld a, [hli];stamp upper address
  ld b, a;bc = stamp address
  push hl;next object address
  ld a, [bc];stamp width
  ld h, a
  inc bc
  ld a, [bc];stamp height
  ld l, a
  add hl, de;maxXY = wh + xy, assumes l + e < 256

  rst TestMapObjectMaxXY
  jp z, .nextMapObject

.clipStamp
  inc bc;stamp tiles
  call ClipStamp

.setTiles
  push hl;wh
  push de;xy
  ld bc, tile_buffer
  call gbdk_SetBkgTiles;returns bc=stamp palette
  pop de;xy
  pop hl;wh

.setPalettes
  ldh a, [sys_info]
  and a, SYS_INFO_GBC
  jp z, .nextMapObject
  ld a, 1
  ldh [rVBK], a
  ld a, 2
  ldh [rSVBK], a
  ld bc, tile_buffer
  ld a, [bc]
  bit 7, a
  jr z, .nonUniformPal
.uniformPal
  and a, %01111111;tile
  ld b, h
  ld c, l;bc = wh
  ld hl, _SCRN0
  call gbdk_SetTilesTo
  jr .finishPal
.nonUniformPal
  call gbdk_SetBkgTiles
.finishPal
  xor a
  ldh [rVBK], a
  ldh [rSVBK], a
.nextMapObject
  pop hl
  ret
.outOfRange
  ld bc, 0
  inc hl
  inc hl
  ret

;bc = stamp tiles, de = stamp minXY, hl = stamp maxXY
;chunk min/max XY in min_x,min_y,max_x,max_y
;returns tilemap/palettemap in tile_buffer, xy in de, wh in hl
ClipStamp:
  push de;xy
  push bc;stamp tiles

  ldh a, [map_min_x];chunk minX
  sub a, d;stamp minX
  jr nc, .setMinX
  xor a
.setMinX
  ldh [map_temp_a], a;x offset
  ld b, a

  ldh a, [map_min_y];chunk minY
  sub a, e;stamp minY
  jr nc, .setMinY
  xor a
.setMinY
  ldh [map_temp_b], a;y offset
  ld c, a

  ldh a, [map_max_x];chunk maxX
  cp a, h;stamp maxX
  jr c, .setClippedWidth;chunk maxX >= stamp maxX
  ld a, h;maxX
.setClippedWidth
  sub a, d;maxX - stamp minX
  sub a, b;maxX - stamp minX - x offset
  ldh [map_temp_c], a;clipped width

  ldh a, [map_max_y];chunk maxY
  cp a, l;stamp maxY
  jr c, .setClippedHeight;chunk maxY >= stamp maxY
  ld a, l;maxY
.setClippedHeight
  sub a, e;maxY - stamp minY
  sub a, c;maxY - stamp minY - y offset
  ldh [map_temp_d], a;clipped height

.setFullWidthHeight;in hl
  ld a, h
  sub a, d;x2-x1
  ld d, a;full stamp width
  ld a, l
  sub a, e;y2-y1
  ld e, a;full stamp height

.copyTilesToBuffer
  push de;wh
  ldh a, [map_temp_b];clip y
  ld e, a
  ld a, d;full width
  ld d, 0;de = clip y
  rst math_Multiply
  ld b, h
  ld c, l;bc = y clip * width
  pop de;wh
  pop hl;stamp tiles
  push hl;stamp tiles start
  add hl, bc;stamp tiles + y clip * width
  ld b, 0
  ldh a, [map_temp_a];x
  ld c, a
  add hl, bc;stamp tiles + y clip * width + x clip
  pop bc;stamp tiles
  push hl;stamp tiles + offset
  push bc;stamp tiles
  ld bc, tile_buffer
  ld a, e;full height
  ld e, d
  ld d, 0;de = full width
  push af;full height
  ldh a, [map_temp_d];clip height
.loopTilemapRows
    push af;rows left
    push hl;stamp tiles
    ldh a, [map_temp_c];clip width
  .loopTilemapColumns
      push af;columns left
      ld a, [hli]
      ld [bc], a
      inc bc
      pop af;columns left
      dec a
      jr nz, .loopTilemapColumns
    pop hl;stamp tiles
    add hl, de;next row
    pop af;rows left
    dec a
    jr nz, .loopTilemapRows

.checkGBC
  ldh a, [sys_info]
  and a, SYS_INFO_GBC
  jr nz, .copyPaletteToBuffer
.notGBC
  pop af;discard full height
  pop hl;discard stamp tiles address
  pop hl;discard stamp tiles + offset
  jp .done

.copyPaletteToBuffer
  ld a, 2
  ldh [rSVBK], a
  pop af;full height
  rst math_Multiply
  ld b, h
  ld c, l;bc = width * height
  pop hl;stamp tiles
  add hl, bc;palette start = stamp tiles + full width * full height
  ld a, [hl];check for uniform tile
  bit 7, a
  jr z, .nonUniformPal
.uniformPal
  pop hl;discard stamp tiles + offset
  ld [tile_buffer], a
  jp .finishPalette

.nonUniformPal
  pop hl;stamp tiles+offset
  add hl, bc;palette start + offset = stamp tiles + offset + full width * full height
  ld bc, tile_buffer
  ldh a, [map_temp_d];clip height
.loopPalettemapRows
    push af;rows left
    push hl;stamp tiles
    ldh a, [map_temp_c];clip width
  .loopPalettemapColumns
      push af;columns left
      ld a, [hli]
      ld [bc], a
      inc bc
      pop af;columns left
      dec a
      jr nz, .loopPalettemapColumns
    pop hl;stamp tiles
    add hl, de;next row
    pop af;rows left
    dec a
    jr nz, .loopPalettemapRows

.finishPalette
  xor a
  ldh [rSVBK], a

.done
  pop de;xy
  ldh a, [map_temp_a]
  add a, d
  ld d, a;x
  ldh a, [map_temp_b]
  add a, e
  ld e, a;y
  ldh a, [map_temp_c]
  ld h, a;w
  ldh a, [map_temp_d]
  ld l, a;h
  ret

DrawMapTile:;hl = tile data, de = xy, min/max XY in min_x,min_y,max_x,max_y
.testX
  ldh a, [map_max_x];maxX
  cp a, d;x
  jr c, .tileOutOfRange;maxX < x
  jr z, .tileOutOfRange;maxX == x
  ldh a, [map_min_x];minX
  cp a, d;x
  jr z, .testY;minX == x
  jr nc, .tileOutOfRange;minX > x
.testY
  ldh a, [map_max_y];maxY
  cp a, e;y
  jr c, .tileOutOfRange;maxY < y
  jr z, .tileOutOfRange;maxY == y
  ldh a, [map_min_y];minY
  cp a, e;y
  jr z, .draw;minY == y
  jr nc, .tileOutOfRange;minY > y
.draw
  ld a, [hli];tile
  ld b, a
  ld a, [hli];palette
  push hl;next map object
  push af;palette
  ld a, b;tile
  ld bc, $0101
  ld hl, _SCRN0
  push de;xy
  call gbdk_SetTilesTo
  pop de;xy
  pop bc;palette
  ldh a, [sys_info]
  and a, SYS_INFO_GBC
  jp z, .nextMapObject
  ld a, 1
  ldh [rVBK], a
  ld a, b;palette
  ld bc, $0101
  ld hl, _SCRN0
  call gbdk_SetTilesTo
  xor a
  ldh [rVBK], a
.nextMapObject
  pop hl;next map object
  ret
.tileOutOfRange
  inc hl
  inc hl
  ret

GetCurrentMap::;returns address in hl, bank in a
  ld a, [map]
  ld b, 0
  ld c, a
  ld hl, MapAddresses
  add hl, bc
  add hl, bc
  ld a, [hli]
  ld e, a
  ld a, [hl]
  ld d, a
  ld hl, MapBanks
  add hl, bc
  ld a, [hl]
  ld h, d
  ld l, e
  ret

GetCurrentMapChunk:;returns chunk address in hl, index in a
  ld a, [map_chunk]
  call GetMapChunk
  ret

SetCurrentMapChunk::;a = chunk index, returns address in hl, index in a
  ld [map_chunk], a
  call GetMapChunk
  ret
GetCurrentMapChunkNeighbor:;a = direction, returns chunk in hl, index in a
  push af;dir
  call GetCurrentMapChunk
  pop af;dir
  ;fall through
GetMapChunkNeighbor:;a = direction, hl = map chunk, returns chunk in hl, index in a
  push bc
  ld b, 0
  ld c, a
  add hl, bc
  ld a, [hl];jump table index
  call GetMapChunk
  pop bc
  ret

GetMapChunk:;a = jump table index, returns chunk in hl, index in a
  push de
  push bc
  push af;index
  call GetCurrentMap;should already be in correct bank
  ld bc, MAP_DATA_CHUNKS
  add hl, bc;[hl] = lower byte of chunk jump table
  ld a, [hli]
  ld b, a
  ld a, [hl]
  ld h, a
  ld l, b;hl = chunk jump table address
  pop af;index
  push af;index
  ld b, 0
  ld c, a
  add hl, bc
  add hl, bc
  ld a, [hli]
  ld b, a
  ld a, [hl]
  ld h, a
  ld l, b
  pop af;index
  pop bc
  pop de
  ret

GetMapChunkForOffset::;bc = xy pixel offset (-127,127), returns chunk in hl, tile xy in de
  call GetCurrentMapChunk
.testX
  ldh a, [rSCX]
  add a, b;x+rSCX
  ld d, a;x+rSCX
  jr nc, .testY
.wrapX
  ld a, b;x
  cp a, 128
  jr c, .east
.west
  ld a, MAP_CHUNK_WEST
  call GetMapChunkNeighbor
  jr .testY
.east
  ld a, MAP_CHUNK_EAST
  call GetMapChunkNeighbor
  ;fall through to testY
.testY
  ldh a, [rSCY]
  add a, c;y+rSCY
  ld e, a;y+rSCY
  jr nc, .finish
.wrapY
  ld a, c;y
  cp a, 128
  jr c, .south
.north
  ld a, MAP_CHUNK_NORTH
  call GetMapChunkNeighbor
  jr .finish
.south
  ld a, MAP_CHUNK_SOUTH
  call GetMapChunkNeighbor
.finish
  srl d
  srl d
  srl d
  srl e
  srl e
  srl e
  ret

ENDC ;MAP_LOADER
