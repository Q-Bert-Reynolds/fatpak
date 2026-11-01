
DEF SFX_TRIGGER EQU $8000

;\1 = steps, \2 = channels the sfx doesn't use (bit 0 = channel 1), \3 = priority
MACRO SFX_HEADER
  DB LOW(\3 << 4 | \2), \1
ENDM

;\1 = ticks, \2 = sweep, \3 = duty/len, \4 = volume, \5 = note
MACRO SFX_CH1
  DB \1, LOW(rNR10)
  DB \2, \3, \4
  DW \5 | SFX_TRIGGER
ENDM

;\1 = ticks, \2 = duty/len, \3 = volume, \4 = note
MACRO SFX_CH2
  DB \1, LOW(rNR21-1)
  DB 0, \2, \3
  DW \4 | SFX_TRIGGER
ENDM

;\1 = ticks, \2 = duty/len, \3 = volume, \4 = note
MACRO SFX_CH3
  DB \1, LOW(rNR30)
  DB 0, \2, \3
  DW \4 | SFX_TRIGGER
ENDM

;\1 = ticks, \2 = duty/len, \3 = volume, \4 = noise
MACRO SFX_CH4
  DB \1, LOW(rNR41-1)
  DB 0, \2, \3
  DB \4, AUDENA_ON
ENDM

SECTION "SFX", ROMX

SelectSound::
  SFX_HEADER 3, %1110, 0
  SFX_CH1 2, 0, $FF, $FF, E4
  SFX_CH1 4, 0, $FF, $FF, C5
  SFX_CH1 2, 0, $FF, $FF, A5

TitleDropInSound::
  SFX_HEADER 2, %0110, 0
  SFX_CH1 2, %11110111, $FF, $FF, A2
  SFX_CH4 80, $FF, $FF, NOISE_DIV_2K|NOISE_EARTHQUAKE

VersionSlideInSound::
  SFX_HEADER 5, %0110, 1
  SFX_CH1 16, 0, 0, 0, 0
  SFX_CH1 1, %11110111, $FF, $FF, A2
  SFX_CH4 8, $FF, $F0, NOISE_DIV_128|NOISE_STATIC
  SFX_CH4 8, $FF, $F8, NOISE_DIV_64|NOISE_STATIC
  SFX_CH4 8, $FF, $FF, NOISE_DIV_32|NOISE_STATIC

TurnOnPCSound::
  SFX_HEADER 6, %1101, 15
  SFX_CH2 2, 192, 248, C6
  SFX_CH2 2, 0, 8, C2
  SFX_CH2 3, 192, 248, D6
  SFX_CH2 2, 0, 8, C2
  SFX_CH2 2, 192, 248, C7
  SFX_CH2 6, 192, 248, D7

TurnOffPCSound::
  SFX_HEADER 7, %1101, 0
  SFX_CH2 4, 192, 248, D6
  SFX_CH2 2, 0, 8, C2
  SFX_CH2 3, 192, 248, C6
  SFX_CH2 2, 0, 8, C2
  SFX_CH2 2, 192, 248, D5
  SFX_CH2 6, 192, 248, C5
  SFX_CH2 1, 0, $08, $80 ;mute
