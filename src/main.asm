DEF TESTS_ENABLED    EQU 0
DEF INTRO_ENABLED    EQU 0
DEF TITLE_ENABLED    EQU 0
DEF NEW_GAME_ENABLED EQU 0
DEF WORLD_ENABLED    EQU 1
DEF PLAY_ENABLED     EQU 1

INCLUDE "src/beisbol.inc"

MACRO RUN_TESTS
  call KeyboardDemo
  DISPLAY_OFF
  TRAMPOLINE UILoadFontTiles
  ld a, ' '
  call ClearScreen
  DISPLAY_ON
  SHOW_WIN
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

SECTION "Header", ROM0[$100]
Entry:
  nop
  jp Main
  NINTENDO_LOGO
IF DEF(_HOME)
  DB "BEISBOL HOME",0,0,0    ;Cart name - 15bytes
ELIF DEF(_AWAY)
  DB "BEISBOL AWAY",0,0,0    ;Cart name - 15bytes
ELSE
  DB "BEISBOL DEMO",0,0,0    ;Cart name - 15bytes
ENDC
  DB CART_COMPATIBLE_DMG_GBC ;$143
  DB 0,0                     ;$144 - Licensee code (not important)
  DB CART_INDICATOR_SGB      ;$146 - SGB Support indicator
  DB CART_ROM_MBC5_RAM_BAT   ;$147 - Cart type
  DB CART_ROM_1024KB         ;$148 - ROM Size 
  DB CART_SRAM_32KB          ;$149 - RAM Size
  DB 1                       ;$14a - Destination code
  DB $33                     ;$14b - Old licensee code
  DB 0                       ;$14c - Mask ROM version
  DB 0                       ;$14d - Complement check (important)
  DW 0                       ;$14e - Checksum (not important)

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

SECTION "Main", ROM0[$0150]
Main::
.gbcCheck ;must happen first
  cp a, BOOTUP_A_MGB;is this a Pocket
  jr z, .gbp
  ; NOTE: Never actually checking for DMG. 
  ;       Assumes DMG if other tests fail. 
  ;       Used to check emulators.
  ;       https://github.com/ISSOtm/Aevilia-GB/blob/master/home.asm
  ; cp a, BOOTUP_A_DMG
  ; jr z, .dmg
  cp a, BOOTUP_A_CGB;is this a GBC
  ld a, 0;don't xor here
  jr nz, .setSysInfo
  bit 0, b;is it also a GBA
  jr z, .gbc
.gba;BOOTUP_B_AGB
  or a, SYS_INFO_GBA
.gbc;BOOTUP_B_CGB
  or a, SYS_INFO_GBC
  jr .setSysInfo
.gbp
  ld a, SYS_INFO_GBP
.setSysInfo
  ld [sys_info], a

.setupGameBoyColor
  ld a, [sys_info]
  and a, SYS_INFO_GBC
  jr z, .setupDisplay
  call gbdk_CPUFast; GBC always in fast mode
  CGB_COMPATIBILITY

.setupDisplay
  di
  DISPLAY_OFF
  DISABLE_LCD_INTERRUPT
  xor a
  ldh [rSCX], a
  ldh [rSCY], a
  ldh [rWX], a
  ldh [rWY], a
  call gbdk_SetupDMATransfer

.initializeRAM
  ld hl, _RAM
  ld bc, _breakpoint-_RAM;don't clear breakpoint or sys_info
  xor a
  call mem_Set
  ld hl, sys_info+1
  ld bc, (_RAM+$2000)-sys_info
  xor a
  call mem_Set
  ld a, KB_MODE_BUTTONS
  ld [kb_mode], a
  ld sp, stack_bottom

.setupAudio
  ld hl, rAUDENA
  ld [hl], AUDENA_OFF
  ld a, $FF
  ldh [rAUDTERM], a
  ldh [rAUDVOL], a
  
.setupDrawing
  xor a
  call ClearScreen
  CLEAR_SCREEN 0
  SET_DEFAULT_PALETTE

  ld a, LCDCF_OFF | LCDCF_WIN9C00 | LCDCF_BLK21 | LCDCF_OBJ8 | LCDCF_OBJON | LCDCF_BGON
  ldh [rLCDC], a

.setupSuperGameBoy
  ld a, SGB_BANK
  SET_BANK
  call sgb_Init
  SET_DEFAULT_PALETTE

.setupInterrupts
  ld a, IEF_VBLANK | IEF_SERIAL
  ldh [rIE], a
  ei
  TRAMPOLINE DetectKeyboard

.seed ;load temp data
  ld a, TEMP_BANK
  SET_BANK
  call Seed
  
.loadGame
  call LoadOptions
  call CheckSave
  jp z, .finishLoading
  call LoadGame
  ld a, PADF_DOWN
  ldh [map_last_button_state], a
.finishLoading

IF TESTS_ENABLED == 1
  RUN_TESTS
  DISPLAY_OFF
  ld a, 1
  ldh [rVBK], a
  CLEAR_SCREEN 0
  xor a
  ldh [rSCX], a
  ldh [rSCY], a
  ldh [rVBK], a
ENDC

.start ;show intro credits, batting animation
IF INTRO_ENABLED == 1
  TRAMPOLINE Start
  HIDE_ALL_SPRITES
ENDC

IF TITLE_ENABLED == 1
.title ;show title drop, version slide, cycle of players, new game/continue screen
  ld a, BANK(Title)
  SET_BANK
  call Title ;sets z if new game pressed
  jr nz, .startClock
ENDC

IF NEW_GAME_ENABLED == 1
.newGame
  TRAMPOLINE NewGame
  TRAMPOLINE Seed
ENDC

.startClock
  ld a, GAME_STATE_CLOCK_STARTED
  ld [game_state], a

.mainLoop
IF WORLD_ENABLED == 1
  .world; walk around, find a game, repeat
    ld a, [game_state]
    and a, ~GAME_STATE_PLAY_BALL
    ld [game_state], a
    TRAMPOLINE Overworld
ENDC

IF PLAY_ENABLED == 1
  .baseball
    ld a, [game_state]
    or a, GAME_STATE_PLAY_BALL
    ld [game_state], a
    TRAMPOLINE StartGame
ENDC
    jr .mainLoop; TODO: if game finished, exit

  xor a
  SET_BANK
  jp Main ;restart the game
  nop
  ret