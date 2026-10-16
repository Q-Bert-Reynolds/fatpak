
DEF SFX_TRIGGER EQU $8000

;\1 = steps, \2 = gbt_channels_enabled, \3 = priority
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

INCLUDE "sfx/fxbank.asm"
INCLUDE "sfx/vyskeisfx1.asm"
INCLUDE "sfx/ui.asm"

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

SECTION "SFX Test", ROMX

DEF NUM_SFX_FILES EQU 4
SFXFileNames:
  DB "fxbank.sav", 0
  DB "vyskeisfx1.sav", 0
  DB "ui.sav", 0
  DB "builtin", 0

SFXFileCounts:
  DB NUM_FXBANK_SOUNDS
  DB NUM_VYSKEISFX1_SOUNDS
  DB NUM_UI_SOUNDS
  DB 3

SFXFileTitles:
  DW FXBankSFXTitles
  DW VyskeisFX1SFXTitles
  DW UISFXTitles
  DW BuiltinSFXTitles

SFXFileAddresses:
  DW FXBankSFXAddresses
  DW VyskeisFX1SFXAddresses
  DW UISFXAddresses
  DW BuiltinSFXAddresses

SFXFileBanks:
  DW FXBankSFXBanks
  DW VyskeisFX1SFXBanks
  DW UISFXBanks
  DW BuiltinSFXBanks

FXBankSFXTitles: FXBANK_TITLES
VyskeisFX1SFXTitles: VYSKEISFX1_TITLES
UISFXTitles: UI_TITLES
BuiltinSFXTitles:
  DB "Select", 0
  DB "Title Drop In", 0
  DB "Version Slide In", 0

FXBankSFXAddresses: FXBANK_ADDRESSES
VyskeisFX1SFXAddresses: VYSKEISFX1_ADDRESSES
UISFXAddresses: UI_ADDRESSES
BuiltinSFXAddresses:
  DW SelectSound
  DW TitleDropInSound
  DW VersionSlideInSound

FXBankSFXBanks: FXBANK_BANKS
VyskeisFX1SFXBanks: VYSKEISFX1_BANKS
UISFXBanks: UI_BANKS
BuiltinSFXBanks:
  DB BANK(SelectSound)
  DB BANK(TitleDropInSound)
  DB BANK(VersionSlideInSound)

SFXTest::
  DISPLAY_OFF
  TRAMPOLINE UILoadFontTiles
  CLEAR_SCREEN ' '
  DISPLAY_ON

  xor a
  ld [_x], a;sfx file
  ld [_y], a;index
  call DrawTitle
.loop
    call WaitPadUp
  .checkA
    ld a, [button_state]
    and a, PADF_A
    jr z, .checkLeft
    call PlaySelectedSound
    jr .wait
    
  .checkLeft
    ld a, [button_state]
    and a, PADF_LEFT
    jr z, .checkRight
    ld a, [_x]
    and a
    jr nz, .decFile
    ld a, NUM_SFX_FILES
  .decFile
    dec a
    ld [_x], a
    xor a
    ld [_y], a
    jr .draw

  .checkRight
    ld a, [button_state]
    and a, PADF_RIGHT
    jr z, .checkUp
    ld a, [_x]
    inc a
    cp a, NUM_SFX_FILES
    jr nz, .incFile
    xor a
  .incFile
    ld [_x], a
    xor a
    ld [_y], a
    jr .draw

  .checkUp
    ld a, [button_state]
    and a, PADF_UP
    jr z, .checkDown
    ld a, [_y]
    and a
    jr nz, .decSound
    ld a, [_x]
    ld b, 0
    ld c, a
    ld hl, SFXFileCounts
    add hl, bc
    ld a, [hl]
  .decSound
    dec a
    ld [_y], a
    jr .draw

  .checkDown
    ld a, [button_state]
    and a, PADF_DOWN
    jr z, .wait
    ld a, [_y]
    inc a
    ld d, a
    ld a, [_x]
    ld b, 0
    ld c, a
    ld hl, SFXFileCounts
    add hl, bc
    ld a, [hl]
    cp a, d
    ld a, d
    jr nz, .incSound
    xor a
  .incSound
    ld [_y], a

  .draw
    call DrawTitle
  .wait
    call gbdk_WaitVBL
    jp .loop

DrawTitle:
  CLEAR_BKG_AREA 0,0,20,2,' '
  ld a, [_x]
  ld b, 0
  ld c, a
  ld hl, SFXFileNames
  call str_FromArray
  ld a, DRAW_FLAGS_BKG
  ld bc, 1
  ld de, 0
  call DrawText

  ld a, [_x]
  add a, a
  ld b, 0
  ld c, a
  ld hl, SFXFileTitles
  add hl, bc
  ld a, [hli]
  ld c, a
  ld a, [hl]
  ld b, a;sound titles in bc
  ld h, b
  ld l, c
  ld a, [_y]
  ld b, 0
  ld c, a
  call str_FromArray
  ld a, DRAW_FLAGS_BKG
  ld bc, 1
  ld de, 1
  call DrawText
  ret

PlaySelectedSound:
  ld a, [_x]
  add a, a
  ld b, 0
  ld c, a
  ld hl, SFXFileAddresses
  add hl, bc
  ld a, [hli]
  ld c, a
  ld a, [hl]
  ld b, a;sound addresses in bc
  ld a, [_y]
  add a, a
  ld h, 0
  ld l, a
  add hl, bc
  ld a, [hli]
  ld c, a
  ld a, [hl]
  ld b, a
  push bc;sound address

  ld a, [_x]
  add a, a
  ld b, 0
  ld c, a
  ld hl, SFXFileBanks
  add hl, bc
  ld a, [hli]
  ld c, a
  ld a, [hl]
  ld b, a;sound banks in bc
  ld a, [_y]
  ld h, 0
  ld l, a
  add hl, bc
  ld a, [hli];sound bank
  pop hl;sound address
  call PlaySFX
  ret


  

