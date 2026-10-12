SECTION "Interrupts", ROM0
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
  ld hl, rLCDInterrupt
  ld a, [hli]
  ld b, a
  ld a, [hl]
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

  ld hl, rLCDInterrupt
  ld a, b
  ld [hli], a
  ld a, c
  ld [hl], a

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

  ld hl, rLCDInterrupt
  ld bc, EndLCDInterrupt
  ld a, b
  ld [hli], a
  ld a, c
  ld [hl], a

  reti

VBLInterrupt::
  PUSH_ALL
  call gbdk_DMATransfer
  call UpdateTime
  call UpdateAudio
  call UpdateSpriteObjects
  ld a, 1
  ldh [vbl_done], a
  POP_ALL
  reti

UpdateTime:
  ld a, [vbl_timer]
  inc a
  ld [vbl_timer], a
  cp a, 60
  ret c
  xor a
  ld [vbl_timer], a

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

UpdateSpriteObjects::
  ld a, [game_state]
  and a, GAME_STATE_PAUSED
  ret nz

  ldh a, [map_anim_frame_step]
  ld b, a
  ld a, [anim_timer]
  inc a
  ld [anim_timer], a
  cp a, b
  ret c
  xor a
  ld [anim_timer], a

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
