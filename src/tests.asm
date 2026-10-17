MACRO RUN_TESTS
  TRAMPOLINE SFXTest;call KeyboardDemo
ENDM

MACRO TEST_SIM ;\1 = speed, \2 = deg left/right, \3 = deg up/down
  ld a, \1
  ld b, \2
  ld c, \3
  call RunSimulation;a = exit velocity b = spray angle c = launch angle
ENDM

MACRO TEST_ANNOUNCER ;\1 = angle left or right
  ld hl, str_buffer
  xor a
  ld [hl], a
  ld b, \1
  call AppendOutfieldLocationTextByAngle
  ld hl, str_buffer
  call RevealTextAndWait
ENDM

IF TESTS_ENABLED
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
ENDC;TESTS_ENABLED