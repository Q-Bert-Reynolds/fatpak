IF !DEF(AUDIO_ASM)
DEF AUDIO_ASM EQU 1

INCLUDE "src/beisbol.inc"
INCLUDE "src/gbt_player/gbt_player.inc"
INCLUDE "src/gbt_player/gbt_player.asm"
INCLUDE "src/gbt_player/gbt_player_bank1.asm"
INCLUDE "src/fx_hammer.asm"

INCLUDE "music/intro_lights.asm"
INCLUDE "music/charge_fanfare.asm"
INCLUDE "music/take_me_out_to_the_ballgame.asm"
INCLUDE "music/hurrah_for_our_national_game.asm"
INCLUDE "music/tessie.asm"

INCLUDE "src/sfx.asm"

MACRO PLAY_SONG ;\1 load address, \2 loop
  di
  ld a, BANK(\1)
  ld hl, \1
  call PlaySong
  ei
  ld a, \2
  ld [gbt_loop_enabled], a
ENDM

MACRO PLAY_SFX ;\1  = load address
  push hl
  push af
  ld a, BANK(\1)
  ld hl, \1
  call PlaySFX
  pop af
  pop hl
ENDM

MACRO PLAY_FXHAMMER ;\1 = index
  di
  ld a, \1
  TRAMPOLINE FXHammer_Play
  ei
ENDM

SECTION "Audio Vars", WRAM0
rCurrentSFX:: DW
current_sfx_bank:: DB
sfx_step:: DB
sfx_step_count:: DB
sfx_ticks:: DB
sfx_disable_mask:: DB

SECTION "Audio Code", ROM0
UpdateAudio::
  ldh a, [loaded_bank]
  push af
  
  call UpdateSFX
  TRAMPOLINE FXHammer_Update
  call gbt_update
  
  pop af
  SET_BANK
  ret

FinishSFX:
.testChannel1
  ld a, [sfx_disable_mask]
  bit 0, a
  jr z, .testChannel2
  xor a
  ldh [rNR12], a ; volume 0
.testChannel2
  ld a, [sfx_disable_mask]
  bit 1, a
  jr z, .testChannel3
  xor a
  ldh [rNR22], a ; volume 0
.testChannel3
  ld a, [sfx_disable_mask]
  bit 2, a
  jr z, .testChannel4
  xor a
  ldh [rNR32], a ; volume 0
.testChannel4
  ld a, [sfx_disable_mask]
  bit 3, a
  ret z
  xor a
  ldh [rNR42], a ; volume 0
  ret

UpdateSFX:
  ld a, [sfx_step_count]
  ld b, a
  ld a, [sfx_step]
  cp a, b
  ret z

  ld a, [sfx_ticks]
  dec a
  ld [sfx_ticks], a
  ret nz

  ld a, [sfx_step]
  inc a
  ld [sfx_step], a
  cp a, b;step count
  jr nz, .notDone

  call FinishSFX
  ld a, %1111
  ld [gbt_channels_enabled], a
  ret

.notDone
  ld de, 8
  call math_Multiply
  ld b, 0
  ld c, l
  inc c
  inc c

  ld a, [rCurrentSFX]
  ld h, a
  ld a, [rCurrentSFX+1]
  ld l, a
  add hl, bc;current step

  ldh a, [loaded_bank]
  push af
  
  ld a, [current_sfx_bank]
  SET_BANK

  ld a, [hli]
  ld [sfx_ticks], a

  ld a, [hli]
  ld [gbt_channels_enabled], a

  ld a, [hli]
  ld b, $FF
  ld c, a

REPT 4
  ld a, [hli]
  ld [bc], a
  inc bc
ENDR

  ld a, AUDENA_ON
  ldh [rAUDENA], a
  
  ld a, [hl]
  or AUDHIGH_RESTART
  ld [bc], a

  pop af;restore bank
  SET_BANK

  ret

PlaySFX:: ; a = bank, hl = sfx address
  di
  push af
  push hl
  call FinishSFX
  pop hl
  pop af

  ld [current_sfx_bank], a
  ld a, h
  ld [rCurrentSFX], a
  ld a, l
  ld [rCurrentSFX+1], a
  xor a
  ld [sfx_step_count], a
  ld a, -1
  ld [sfx_step], a
  ld a, 1
  ld [sfx_ticks], a

  ldh a, [loaded_bank]
  push af;bank

  ld a, [current_sfx_bank]
  SET_BANK

  ld a, [hli];step count
  ld [sfx_step_count], a
  ld a, [hl];channels to disable on finish
  ld [sfx_disable_mask], a

  pop af;bank
  SET_BANK

  ld a, AUDENA_ON
  ldh [rAUDENA], a
  ld a,$FF
  ldh [rAUDVOL], a
  ldh [rAUDTERM], a
  
  reti

PlaySong:: ; a = bank, hl = song address
  ld d, h
  ld e, l ;de = pointer to song data
  ld b, 0
  ld c, a ;data bank

  ldh a, [loaded_bank]
  push af;bank

  ld a, 1 ;song speed
  call gbt_play

  pop af;bank
  SET_BANK
  ret

ENDC ;AUDIO_ASM
