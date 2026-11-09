INCLUDE "src/text_editor.inc"

SECTION "Crash Handler RST", ROM0[$0038]
  jp Main

SECTION "Header", ROM0[$0100]
Entry:
  nop
  jp Main
  NINTENDO_LOGO
;rgbfix writes the rest: title GBXOS, maker KRKZ, ROM only, 128KB, like GBCOS.BIN
  DS $150-@, 0

SECTION "OS Info", ROM0[$01F0]
; Stock GBCOS compatibility flags, not a version number. Girlboss tracks save
; backups in EDITOR.GAM; the cartridge/stock OS may also inspect these bytes.
os_game_launched:: DB 0;cleared at startup, set before launching a game
os_initialization_pending:: DB 1;stock OS's first-initialization marker (unused here)
os_return_to_menu_requested:: DB 0;stock OS's return request (unused here)
os_snapshot_use_32k_ram:: DB 0;stock snapshot RAM-size flag, derived from the RAM mask
; Original resident bytes at the six addresses written as mapper registers.
ingame_os_bytes:: DS 6, 0
os_info_reserved:: DS 6, 0
ASSERT os_game_launched == $01F0
ASSERT os_initialization_pending == $01F1
ASSERT os_return_to_menu_requested == $01F2
ASSERT os_snapshot_use_32k_ram == $01F3
ASSERT @ == $0200

SECTION "Main", ROM0
Main::
  di
  ld sp, $FFFE;where the boot ROM leaves it, the loader's may be in WRAM (cleared below)
  ld a, 1
  ldh [rSVBK], a
  xor a;sgb_Init enables interrupts before Main sets them up
  ldh [rIE], a
  ld a, EDX_KEY_UNLOCK;unlock before patching the resident interrupt vector
  ld [EDX_KEY], a
  xor a
  ld [os_game_launched], a
  ld [EDX_MAPPER], a;select the OS mapper before clearing the cart-switch state
  ld a, 4
  ld [EDX_SWITCH], a;needed when launching another game after a warm return
  ld a, $04;the window shows PSRAM
  ld [EDX_CONFIG], a
  call CartConfigureFeatures;model-specific RTC/snapshot gates, like stock startup
  ; Restore the editor's vector after the mapper and cart switch are in OS mode.
  ld hl, $0041;$0040 jumps to our VBlank, not the in-game menu (src/editor/ingame.asm)
  ld [hl], LOW(VBLInterrupt)
  inc l
  ld [hl], HIGH(VBLInterrupt)
  ld a, TB_PSRAM_HIGH
  ld [EDX_BLOCK+1], a

.clearHRAM;nothing is on the stack yet; hardware detection starts from known flags
  xor a
  ld hl, _HRAM
  ld c, $FFFF-_HRAM
.clearHRAMLoop
  ld [hli], a
  dec c
  jr nz, .clearHRAMLoop

.detectGameBoyColor
  ; The loader (or a warm return) has already changed the boot registers.
  ; VBK must retain both values: DMG reads $FF regardless of writes.
  ld a, 1
  ldh [rVBK], a
  ldh a, [rVBK]
  bit 0, a
  jr z, .notGBC
  xor a
  ldh [rVBK], a
  ldh a, [rVBK]
  bit 0, a
  jr nz, .notGBC
  ld a, SYS_INFO_GBC
  jr .setSystemInfo
.notGBC
  ld a, SYS_INFO_DMG;DMG-compatible mode; the SGB probe may add SYS_INFO_SGB
.setSystemInfo
  ldh [sys_info], a

.setupSuperGameBoy
  TRAMPOLINE sgb_Init;MLT_REQ detects SGB; skips the probe in CGB mode

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

.start
  TRAMPOLINE _Editor;never returns
