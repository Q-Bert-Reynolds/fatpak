INCLUDE "src/text_editor.inc"

SECTION "Crash Handler RST", ROM0[$0038]
  jp Main

SECTION "Header", ROM0[$0100]
Entry:
  nop
  jp Main
  NINTENDO_LOGO
  GAME_NAME                  ;$134 - Title
  DB CART_COMPATIBLE_DMG_GBC ;$143 - CGB Flag
  DW 0                       ;$144 - Licensee code (not important)
  DB CART_INDICATOR_SGB      ;$146 - SGB Support indicator
  DB CART_ROM_MBC5_RAM_BAT   ;$147 - Cart type
  DB CART_ROM_1024KB         ;$148 - ROM Size 
  DB CART_SRAM_32KB          ;$149 - RAM Size
  CART_DEST                  ;$14a - Destination code
  DB $33                     ;$14b - Old licensee code
  DB 0                       ;$14c - Mask ROM version
  DB 0                       ;$14d - Complement check (important)
  DW 0                       ;$14e - Checksum (not important)

SECTION "Main", ROM0[$0150]
Main::
  SYS_CHECK

.clearHRAM;keeps sys_info from SYS_CHECK, nothing is on the stack yet
  ldh a, [sys_info]
  ld b, a
  xor a
  ld hl, _HRAM
  ld c, $FFFF-_HRAM
.clearHRAMLoop
    ld [hli], a
    dec c
    jr nz, .clearHRAMLoop
  ld a, b
  ldh [sys_info], a

.setupSuperGameBoy
  TRAMPOLINE sgb_Init

.setupDisplay
  di
  DISPLAY_OFF
  call DisableLCDInterrupt
  xor a
  ldh [rSCX], a
  ldh [rSCY], a
  ldh [rWX], a
  ldh [rWY], a
  call gbdk_SetupDMATransfer

.setupGameBoyColor
  ldh a, [sys_info]
  and a, SYS_INFO_GBC
  jr z, .initializeRAM
  call gbdk_CPUFast; GBC always in fast mode
  ld hl, DefaultPalettes
  call GBCCopyPalettesFrom

.initializeRAM
  xor a
  ld hl, _RAM
  ld bc, (_RAMBANK-_RAM)*2
  call mem_Set;clear WRAM
  ld a, KB_MODE_BUTTONS
  TRAMPOLINE SetKeyboardMode
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

.setupInterrupts
  ld a, IEF_VBLANK | IEF_SERIAL
  ldh [rIE], a
  ei
  TRAMPOLINE DetectKeyboard

.startClock
  ld a, GAME_STATE_CLOCK_STARTED
  ld [game_state], a

IF TESTS_ENABLED
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

.start
  TRAMPOLINE _Editor;never returns
