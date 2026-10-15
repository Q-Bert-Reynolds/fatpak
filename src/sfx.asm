
DEF SFX_TRIGGER EQU $8000

;\1 = ticks, \2 = mask, \3 = sweep, \4 = duty/len, \5 = volume, \6 = note
MACRO SFX_CH1
  DB \1, \2, LOW(rNR10)
  DB \3, \4, \5
  DW \6 | SFX_TRIGGER
ENDM

;\1 = ticks, \2 = mask, \3 = duty/len, \4 = volume, \5 = note
MACRO SFX_CH2
  DB \1, \2, LOW(rNR21-1)
  DB 0, \3, \4
  DW \5 | SFX_TRIGGER
ENDM

;\1 = ticks, \2 = mask, \3 = duty/len, \4 = volume, \5 = note
MACRO SFX_CH3
  DB \1, \2, LOW(rNR30)
  DB 0, \3, \4
  DW \5 | SFX_TRIGGER
ENDM

;\1 = ticks, \2 = mask, \3 = duty/len, \4 = volume, \5 = noise
MACRO SFX_CH4
  DB \1, \2, LOW(rNR41-1)
  DB 0, \3, \4
  DB \5, AUDENA_ON
ENDM

INCLUDE "sfx/hammered.asm"

SECTION "SFX", ROMX

SelectSound::
  DB 3;steps
  SFX_CH1 2, %1110, 0, $FF, $FF, E5
  SFX_CH1 4, %1110, 0, $FF, $FF, C6
  SFX_CH1 2, %1110, 0, $FF, $FF, A6

TitleDropInSound::
  DB 2;steps
  SFX_CH1 2, %1110, %11110111, $FF, $FF, A3
  SFX_CH4 80, %0110, $FF, $FF, NOISE_DIV_2K|NOISE_EARTHQUAKE

VersionSlideInSound::
  DB 5;steps
  SFX_CH1 16, %1111, 0, 0, 0, 0
  SFX_CH1 1, %1111, %11110111, $FF, $FF, A3
  SFX_CH4 8, %0110, $FF, $F0, NOISE_DIV_128|NOISE_STATIC
  SFX_CH4 8, %0110, $FF, $F8, NOISE_DIV_64|NOISE_STATIC
  SFX_CH4 8, %0110, $FF, $FF, NOISE_DIV_32|NOISE_STATIC