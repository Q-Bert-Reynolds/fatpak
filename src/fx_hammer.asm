;FX HAMMER Version 1.0 (c)2000 Aleksi Eeben (email:aleksi@cncd.fi)
;modified from disassembly (https://github.com/DevEd2/FXHammer-Disasm/blob/master/FXHammer.asm)

; FXHammer_Play      Plays the SFX at the index stored in register a
; FXHammer_Stop      Stops the currently playing SFX
; FXHammer_Update    called during vblank

SECTION "FX Hammer RAM", WRAM0
;Bit 2: Ch2 reserved for playing a sample trigged in music data (1 = yes, 0 = no)
;Bit 1: Ch2 reserved for sound FX routines (1 = yes, 0 = no)
;Bit 0: Ch2 music note playing (1 = no, 0 = yes)
;When Ch2Flags is not $00,  no instrument sound data is read and all Ch2 sound registers (rNR3x) remain intact.
Ch2Flags: DB

;Bit 1: Ch4 reserved for sound FX routines (1 = yes,0 = no)
;Bit 0: Ch4 music note playing (1 = no,0 = yes)
;When Ch4Flags is not $00,  no instrument sound data is read and all Ch4 sound registers (rNR4x) remain intact.
Ch4Flags: DB
 
FXCurrentPri: DB ;Priority of current Sound FX playing ($00 = lowest)
FXSoundCount: DB ;Countdown (in frames) before moving to next step in Sound FX
FXSoundP: DB ;Current Step
FXSoundH: DB ;Current Sound FX (FX number + $44)

;A step is described in 8 bytes:
;TIME/END (TM)
;CH2/P_EV (P)
;CH2/_LEV (L)
;CH2/PWDT (W)
;CH2/NOTE (NT)
;CH4/P_EV (P)
;CH4/_LEV (L)
;CH4/FRQD (FR)

SECTION "FX Hammer", ROMX, BANK[FX_HAMMER_BANK]

FXHammer_Play:: ;a = index
  ld e, a
  ld d, HIGH(FXHammerData)
  ld hl, FXCurrentPri
  ld a, [de]
  cp [hl]
  jr z, .sameprio
  ;[hl] > a
  ret c
.sameprio:
  ;store prio
  ld [hl], a
  ;+0x100
  inc d
  ld a, [de]
  swap a
  and $f
  ld l, LOW(Ch2Flags)
  or [hl]
  ld [hl], a
  ld a, [de]
  and $f
  ld l, LOW(Ch4Flags)
  or [hl]
  ld [hl], a
  ld l, LOW(FXSoundCount)
  ;trigger step on next update
  ld a, 1
  ld [hl+], a
  ;FXSoundP
  xor a
  ld [hl+], a
  ld a, HIGH(FXHammerData)+2
  ;e is FX number
  add e
  ld [hl], a
  ret
 
FXHammer_Stop:
  ld hl, Ch2Flags
  bit 1, [hl]
  ;no sound playing
  jr z, .skip_ch2
  ld a, $08
  ldh [rNR22], a
  ld a, $80
  ldh [rNR24], a
  ld [hl], 1
.skip_ch2:
  ld l, LOW(Ch4Flags)
  ;turn off music note (inverted bit)
  set 0, [hl]
  bit 1, [hl]
  ;no sound playing
  jr z, .skip_ch4
  ld a, $08
  ldh [rNR42], a
  ld a, $80
  ldh [rNR44], a
  ld [hl], 1
.skip_ch4:
  ld l, LOW(FXCurrentPri)
  xor a
  ld [hl+], a
  ;FXSoundCount
  ld [hl], a
  ret
 
;progress a frame
FXHammer_Update:
  xor a
  ld hl, FXSoundCount
  or [hl]
  ;ret == 0
  ret z
  
  ld a, %1111
  ld [gbt_channels_enabled], a;assume all channels are allowed
  
  dec [hl]
  ;ret != 1
  ret nz
  inc l
  ld a, [hl+]
  ;FXSoundP
  ;de = pointer
  ld d, [hl]
  ld e, a
  ;pointer+0
  ;TIME/END (TM)
  ;$80 is knee
  ld a, [de]
  ld l, LOW(FXSoundCount)
  ld [hl-], a
  or a
  jr nz, .keepprio
  ;FXCurrentPri
  ;Prio is reset on last step
  ld [hl], a
.keepprio:
  ld l, LOW(Ch2Flags)
  bit 1, [hl]
  ;already music on channel 2
  jr z, .skip_ch2
  inc e
  ;pointer+1
  ;CH2/PLEV (P)
  ;0x22,  0x20,  0x02 or 0x00
  ld a, [de]
  or a
  jr nz, .notmute_ch2
  ld [hl], 1
  ;disable envelope
  ld a, $08
  ldh [rNR22], a
  ;restart sound
  ld a, $80
  ldh [rNR24], a
  jr .skip_ch2mute
.notmute_ch2:
  ld b, a
  ld a, [gbt_channels_enabled];mute gbt_player ch 2
  and %1101
  ld [gbt_channels_enabled], a
  ;Pan
  ldh a, [rNR51]
  and $dd
  or b
  ldh [rNR51], a
  inc e
  ;pointer+2
  ;CH2/PLEV (L)
  ;0x00,  0x10 ... 0xF0
  ld a, [de]
  ldh [rNR22], a
  inc e
  ;pointer+3
  ;CH2/PWDT (W)
  ld a, [de]
  ldh [rNR21], a
  inc e
  ;pointer+4
  ;CH2/NOTE (NT)
  ld a, [de]
  ld b, HIGH(FXHammerData)
  ld c, a
  ;bc = pointer to note
  ld a, [bc]
  ldh [rNR23], a
  inc c
  ld a, [bc]
  ldh [rNR24], a
  jr .noskip
  ;skip pointer by four
  ;aka skip channel 2
.skip_ch2:
  inc e
.skip_ch2mute:
  inc e
  inc e
  inc e
.noskip:
  ld l, LOW(Ch4Flags)
  bit 1, [hl]
  ;already music on channel 4
  jr z, .skip_ch4
  inc e
  ;pointer+5
  ;CH4/PLEV (P)
  ;0x88,  0x80,  0x08 or 0x00
  ld a, [de]
  or a
  jr nz, .notmute_ch4
  ld [hl], 1
  ld a, $08
  ldh [rNR42], a
  ld a, $80
  ldh [rNR44], a
  jr .skip_ch4
.notmute_ch4:
  ld b, a
  ld a, [gbt_channels_enabled];mute gbt_player ch 4
  and %0111
  ld [gbt_channels_enabled], a
  ;Pan
  ldh a, [rNR51]
  and $77
  or b
  ldh [rNR51], a
  inc e
  ;pointer+6
  ;CH4/PLEV (L)
  ;0x00,  0x10 ... 0xF0
  ld a, [de]
  ldh [rNR42], a
  inc e
  ;pointer+7
  ;CH4/FRQD (FR)
  ld a, [de]
  ldh [rNR43], a
  ld a, $80
  ldh [rNR44], a
  inc e
  ld l, LOW(FXSoundP)
  ;set pointer to next step
  ld [hl], e
  ret
.skip_ch4:
  ld l, LOW(FXSoundP)
  ld a, 8
  add [hl]
  ;set pointer to next step
  ld [hl], a
  ret
 
SECTION "FXHammer Data", ROMX, BANK[FX_HAMMER_BANK], ALIGN[8]
;To get sound data, open hammered.sav and copy everything from $200-$3FFF into SoundData.bin.
FXHammerData: INCBIN "sfx/hammered.bin"
