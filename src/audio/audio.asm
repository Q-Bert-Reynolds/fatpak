IF !DEF(AUDIO_ASM)
DEF AUDIO_ASM EQU 1

INCLUDE "src/text_editor.inc"
INCLUDE "src/audio/sfx.asm"

MACRO PLAY_SFX ;\1  = load address
  push hl
  push af
  ld a, BANK(\1)
  ld hl, \1
  call PlaySFX
  pop af
  pop hl
ENDM

SECTION "Audio Vars", WRAM0
sfx_ptr:: DW
sfx_bank:: DB
sfx_priority:: DB;stored in high nibble
sfx_step:: DB
sfx_step_count:: DB
sfx_ticks:: DB
sfx_free_channels:: DB;channels the sfx doesn't use (bit 0 = channel 1), the rest are muted when it ends

SECTION "Audio Code", ROM0
UpdateAudio::
  ldh a, [loaded_bank]
  push af
  
  call UpdateSFX

  pop af
  SET_BANK
  ret

StopSFX:;stops current sfx, resets sfx_priority and sfx_free_channels, only af affected
.testChannel1
  ld a, [sfx_free_channels]
  bit 0, a
  jr nz, .testChannel2
	ld	a,$08;volume zero but don't turn off DAC
	ldh	[rNR12],a
	ld	a,$80;trigger sound to mute
	ldh	[rNR14],a
.testChannel2
  ld a, [sfx_free_channels]
  bit 1, a
  jr nz, .testChannel3
	ld	a,$08
	ldh	[rNR22],a
	ld	a,$80
	ldh	[rNR24],a
.testChannel3
  ld a, [sfx_free_channels]
  bit 2, a
  jr nz, .testChannel4
	ld	a,$08
	ldh	[rNR32],a
	ld	a,$80
	ldh	[rNR34],a
.testChannel4
  ld a, [sfx_free_channels]
  bit 3, a
  jr nz, .resetState
	ld	a,$08
	ldh	[rNR42],a
	ld	a,$80
	ldh	[rNR44],a
.resetState
  xor a
  ld [sfx_priority], a
  ld a, %1111
  ld [sfx_free_channels], a
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

  call StopSFX
  ret

.notDone
  ld a, [sfx_ptr]
  ld h, a
  ld a, [sfx_ptr+1]
  ld l, a

  ldh a, [loaded_bank]
  push af
  
  ld a, [sfx_bank]
  SET_BANK

.loop
    ld a, [hli]
    ld [sfx_ticks], a

    ld a, [hli]
    ld c, a

  REPT 5
    ld a, [hli]
    ldh [c], a
    inc bc
  ENDR

    ld a, [sfx_ticks]
    and a
    jr z, .loop

  ld a, h
  ld [sfx_ptr], a
  ld a, l
  ld [sfx_ptr+1], a

  pop af;restore bank
  SET_BANK

  ret

PlaySFX:: ; a = bank, hl = sfx address
  di
  ld b, a;sfx bank
  ldh a, [loaded_bank]
  push af;previous bank
  ld a, b;sfx bank
  SET_BANK

.checkPriority
  ld a, [sfx_priority]
  ld d, a;old priority
  ld a, [hli];priority and free channels
  ld e, a;free channels
  and a, $F0;new priority
  cp a, d;compare priority
  ld d, a;new priority
  jr c, .exit;don't play if lower priority

.initSFX
  ld a, b;sfx bank
  ld [sfx_bank], a
  ld a, -1
  ld [sfx_step], a
  ld a, 1
  ld [sfx_ticks], a

  call StopSFX;resets sfx_priority and sfx_free_channels
  ld a, d;new priority
  ld [sfx_priority], a;save priority

  ld a, e;priority and free channels
  and a, $F;discard priority
  ld [sfx_free_channels], a

  ld a, [hli];step count
  ld [sfx_step_count], a

  ld a, h;first step in hl
  ld [sfx_ptr], a
  ld a, l
  ld [sfx_ptr+1], a

  ld a, AUDENA_ON
  ldh [rAUDENA], a
  ld a,$FF
  ldh [rAUDVOL], a
  ldh [rAUDTERM], a

.exit
  pop af;bank
  SET_BANK
  reti

ENDC ;AUDIO_ASM
