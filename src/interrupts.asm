;TODO: shuffle sprite objects, leverage flicker to show more than 40
DEF SPRITE_OBJ_SIZE        EQU 6;bytes... bank, address(2), x, y, extra
DEF SPRITE_OBJ_MAX_COUNT   EQU OAM_COUNT-4;4 sprites reserved for player avatar
DEF SPRITE_OBJ_BUFFER_SIZE EQU SPRITE_OBJ_MAX_COUNT * SPRITE_OBJ_SIZE

DEF TILE_ANIM_SIZE         EQU 3;bytes... id, speed, type
DEF TILE_ANIM_MAX_COUNT    EQU 4
DEF TILE_ANIM_BUFFER_SIZE  EQU 1 + TILE_ANIM_MAX_COUNT * TILE_ANIM_SIZE

SECTION "Interrupt HRAM", HRAM
vbl_timer:: DB ;counts to 60
anim_timer:: DB ;counts to anim_frame_step
anim_frame_step:: DB
rLCDInterrupt:: DW;location of LCD interrupt subroutine

SECTION "Interrupt WRAMX", WRAMX
sprite_obj_buffer:: DS SPRITE_OBJ_BUFFER_SIZE
tile_anim_buffer::  DS TILE_ANIM_BUFFER_SIZE;byte 0 is count

SECTION "VBlank", ROM0[$0040]
  jp VBLInterrupt
SECTION "LCDC", ROM0[$0048]
  jp LCDInterrupt
SECTION "TimerOverflow", ROM0[$0050]
  reti
SECTION "Serial", ROM0[$0058]
  jp SerialInterrupt
SECTION "p1thru4", ROM0[$0060]
  reti

SECTION "Interrupt Code", ROM0
;serial
;   SerialInterrupt
;
;lcd
;   LCDInterrupt
;   SetLCDInterrupt             bc = interrupt address
;   DisableLCDInterrupt
;
;vblank
;   VBLInterrupt
;   UpdateTime                  updates current game time
;   UpdateSpriteObjects         updates sprite_obj_buffer

SerialInterrupt::;TODO: check serial type (keyboard, link, printer)
  PUSH_ALL
  call PS2KeyboardInterrupt
  POP_ALL
  reti

LCDInterrupt::
  PUSH_ALL
  ld c, LOW(rLCDInterrupt)
  ldh a, [c]
  ld b, a
  inc c
  ldh a, [c]
  ld h, b
  ld l, a
  ld bc, EndLCDInterrupt
  push bc ;put return address on stack before jumping
  jp hl
EndLCDInterrupt::
  POP_ALL
  reti

SetLCDInterrupt::;bc = interrupt address
  di

  ld h, ~IEF_STAT
  ldh a, [rIE]
  and a, h
  ldh [rIE], a

  xor a
  ldh [rSTAT], a

  ld a, b
  ldh [rLCDInterrupt], a
  ld a, c
  ldh [rLCDInterrupt+1], a

  ld h, IEF_STAT
  ldh a, [rIE]
  or a, h
  ldh [rIE], a

  ld a, STATF_LYC
  ldh [rSTAT], a
  
  reti

DisableLCDInterrupt::
  di
    
  ld b, ~IEF_STAT
  ldh a, [rIE]
  and a, b
  ldh [rIE], a

  xor a
  ldh [rSTAT], a

  ld bc, EndLCDInterrupt
  ld a, b
  ldh [rLCDInterrupt], a
  ld a, c
  ldh [rLCDInterrupt+1], a

  reti

VBLInterrupt::
  PUSH_ALL
  call gbdk_DMATransfer
  call UpdateTime
  call UpdateAudio
  call UpdateAnimations
  ld a, 1
  ldh [vbl_done], a
  POP_ALL
  reti

UpdateTime:
  ldh a, [vbl_timer]
  inc a
  ldh [vbl_timer], a
  cp a, 60
  ret c
  xor a
  ldh [vbl_timer], a

.testGameState
  ld a, [game_state]
  and a
  ret z;if game hasn't started, don't increment game time

.incrementSeconds
  ld a, [seconds]
  inc a
  ld [seconds], a
  cp a, 60
  ret c

.incrementMinutes
  xor a
  ld [seconds], a
  ld a, [minutes]
  inc a
  ld [minutes], a
  cp a, 60
  ret c

.incrementHours
  xor a
  ld [minutes], a
  ld hl, hours+1 ;low byte
  inc [hl] ;increment low byte inplace
  ret nz ;done if no overflow
  dec hl ;high byte
  inc [hl]
  ret

UpdateAnimations::
  ld a, [game_state]
  and a, GAME_STATE_PAUSED
  ret nz

  ldh a, [anim_frame_step]
  ld b, a
  ldh a, [anim_timer]
  inc a
  ldh [anim_timer], a
  cp a, b
  ret c
  xor a
  ldh [anim_timer], a

  call UpdateSpriteObjects
  call UpdateTileAnimations
  ret

UpdateSpriteObjects::
  ld hl, sprite_obj_buffer
  ldh a, [map_sprite_count]
  and a
  ret z

  cp a, SPRITE_OBJ_MAX_COUNT
  jr c, .loop
  ld a, SPRITE_OBJ_MAX_COUNT
.loop
    push af
    ld a, [hli];bank
    ld [rROMB0], a
    ld a, [hli];lower address
    ld c, a
    ld a, [hli];upper address
    ld b, a
    inc hl;x
    inc hl;y
    ld a, [bc];map object type/collision flags
    and a, MAP_OBJ_TYPE_MASK
    cp a, MAP_OBJ_META_SPRITE
    ld a, [hl];extra data
    jr nz, .next;only step frame if it's a metasprite
    inc a;step frame
    ld [hl], a;
  .next
    inc hl
    pop af
    dec a
    jr nz, .loop
  ld a, [loaded_bank]
  ld [rROMB0], a
  ret

UpdateTileAnimations::
  ld hl, tile_anim_buffer
  ld a, [hli];tile count
  and a
  ret z

  ld c, a;tile count
.loopTiles
    ld b, 16;bytes per tile

    ld a, [hli];tile id
    inc hl;skip speed
    inc hl;skip type
    push hl;next tile
    push bc;bytes per tile, tile count

    ld de, 16
    rst math_Multiply
    ld de, _VRAM8800
    add hl, de
    
    pop bc;bytes per tile, tile count
  .loopBytes
      ld a, [hl]
      rrca
      ld [hli], a
      dec b;bytes left
      jr nz, .loopBytes

    pop hl;next tile
    dec c;tiles left
    jr nz, .loopTiles
  ret

