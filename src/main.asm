INCLUDE "src/text_editor.inc"

SECTION "Crash Handler RST", ROM0[$0038]
  jp Main

SECTION "Header", ROM0[$0100]
Entry:
  nop
  jp Main
  NINTENDO_LOGO
IF DEF(EVERDRIVE_OS);rgbfix writes the rest: title GBXOS, maker KRKZ, ROM only, 128KB, like GBCOS.BIN
  DS $150-@, 0
ELSE
  GAME_NAME                  ;$134 - Title
  DB CART_COMPATIBLE_DMG_GBC ;$143 - CGB Flag
  DW 0                       ;$144 - Licensee code (not important)
  DB CART_INDICATOR_SGB      ;$146 - SGB Support indicator
  DB CART_ROM_MBC5_RAM_BAT   ;$147 - Cart type
  DB CART_ROM_1024KB         ;$148 - ROM Size 
  DB CART_SRAM_128KB         ;$149 - RAM Size
  CART_DEST                  ;$14a - Destination code
  DB $33                     ;$14b - Old licensee code
  DB 0                       ;$14c - Mask ROM version
  DB 0                       ;$14d - Complement check (important)
  DW 0                       ;$14e - Checksum (not important)
ENDC

IF DEF(EVERDRIVE_OS)
SECTION "OS Info", ROM0[$01F0];like GBCOS.BIN: version 0, 1, and $01F2 is a flag the cart may set
  DB 0, 1
  DS 2, 0
; Original resident bytes at the six addresses written as mapper registers.
ingame_os_bytes:: DS 6, 0
  DS 6, 0
SECTION "Main", ROM0
ELSE
SECTION "Main", ROM0[$0150]
ENDC
Main::
IF DEF(EVERDRIVE_OS);the EverDrive's loader ran after the boot ROM, so its registers are gone
  di
  ld sp, $FFFE;where the boot ROM leaves it, the loader's may be in WRAM (cleared below)
  ld a, 1
  ldh [rSVBK], a
  xor a;sgb_Init enables interrupts before Main sets them up
  ldh [rIE], a
  ld a, $A5;unlock before patching the resident interrupt vector
  ld [$BD0A], a
IF !DEF(BISECT_LAUNCH)
  xor a;$01F0 back to 0 like the EverDrive OS's boot (GameLaunch sets it)
  ld [$01F0], a
ENDC
IF !DEF(BISECT_BOOT)
  xor a;like the EverDrive OS's boot: mapper 0 (OS), $BD09 = 4 (the launch writes 0). Without it, a game launched
  ld [$BD07], a;after one went back to the OS from its in-game menu went straight back to the OS on the X7
  ld a, 4
  ld [$BD09], a
ENDC
  ld a, $04;the window shows PSRAM
  ld [EDX_CONFIG], a
  ; Restore the editor's vector after the mapper and cart switch are in OS mode.
  ld hl, $0041;$0040 jumps to our VBlank, not the in-game menu (src/editor/ingame.asm)
  ld [hl], LOW(VBLInterrupt)
  inc l
  ld [hl], HIGH(VBLInterrupt)
  ld a, TB_PSRAM_HIGH
  ld [EDX_BLOCK+1], a
  ld bc, 0;not a GBA (can't tell), sgb_Init asks for a Super Game Boy
  ld a, 1;GBC if VBK keeps bit 0 both ways
  ldh [rVBK], a
  ldh a, [rVBK]
  rra
  jr nc, .notGBC
  xor a
  ldh [rVBK], a
  ldh a, [rVBK]
  rra
  jr c, .notGBC
  ld a, BOOTUP_A_CGB
  jr .sysCheck
.notGBC
  ld a, BOOTUP_A_DMG
.sysCheck
ENDC
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
  TRAMPOLINE GBCSetDefaultPalettes

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
