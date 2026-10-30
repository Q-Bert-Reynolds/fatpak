INCLUDE "src/tile_anim.asm"

;TODO: shuffle sprite objects, leverage flicker to show more than 40
DEF SPRITE_OBJ_SIZE        EQU 6;bytes... bank, address(2), x, y, extra
DEF SPRITE_OBJ_MAX_COUNT   EQU OAM_COUNT-4;4 sprites reserved for player avatar
DEF SPRITE_OBJ_BUFFER_SIZE EQU SPRITE_OBJ_MAX_COUNT * SPRITE_OBJ_SIZE

SECTION "Interrupt HRAM", HRAM
vbl_timer:: DB ;counts to 60
anim_timer:: DB ;counts to anim_step_size
anim_step_size:: DB
anim_step:: DB ;increments when anim_timer resets
rLCDInterrupt:: DW;location of LCD interrupt subroutine
  
SECTION "Interrupt WRAMX", WRAMX
sprite_obj_buffer:: DS SPRITE_OBJ_BUFFER_SIZE
last_scx: DB
last_scy: DB

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
;   UpdateAnimations            updates animation timer, meta sprites, and tile animations
;   UpdateSpriteObjects         updates meta sprite objects

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
  call LatchPad
  call UpdateTime
  call UpdateAnimations
  call UpdateAudio
  
  ldh a, [rSCX]
  ld [last_scx], a
  ldh a, [rSCY]
  ld [last_scy], a
  
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

.checkGameState
  ld a, [game_state]
  and a, GAME_STATE_CLOCK_STARTED
  ret z

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

UpdateAnimations:
  ld a, [game_state]
  and a, GAME_STATE_PAUSED
  ret nz

  TRAMPOLINE UpdateTileAnimations

  ldh a, [anim_step_size]
  ld b, a
  ldh a, [anim_timer]
  inc a
  ldh [anim_timer], a
  cp a, b
  ret c

  xor a
  ldh [anim_timer], a
  ldh a, [anim_step]
  inc a
  ldh [anim_step], a
  call UpdateSpriteObjects
  ret

UpdateSpriteObjects:
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
