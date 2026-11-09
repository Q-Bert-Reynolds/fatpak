;A single background row drawn with the menu's VWF composer. No sprites,
;window splits or interrupts are needed while the ROM streams into PSRAM.
SECTION "Game Loading State", WRAM0
game_loading_ie: DB
game_loading_lcdc: DB
game_loading_bgp: DB

SECTION "Game Loading Stubs", ROM0
_GameLoadingBegin:: BANKED_C GameLoadingBegin
_GameLoadingEnd:: BANKED_C GameLoadingEnd
GameLoadingText: DB "Loading...", 0

PAGE GAME_PAGE
GameLoadingBegin:
  call RenderWaitDMA;finish the editor's last row before reusing its buffers
  ldh a, [rIE]
  ld [game_loading_ie], a
  xor a
  ldh [rIE], a
  ldh a, [rLCDC]
  ld [game_loading_lcdc], a
  ldh a, [rBGP]
  ld [game_loading_bgp], a
  call GameLoadingOff
  ld de, GameLoadingText
  ld a, 56
  TRAMPOLINE RenderMenuText
  xor a
  ldh [rVBK], a
  ld hl, $8000;blank tile 0
  ld bc, 16
  call mem_Set
  xor a
  ld hl, $9800
  ld bc, $400
  call mem_Set
  ldh a, [sys_info]
  and a, SYS_INFO_GBC
  jr z, .tiles
  ld a, 1
  ldh [rVBK], a
  xor a
  ld hl, $9800;all background attributes use bank 0, palette 0
  ld bc, $400
  call mem_Set
  xor a
  ldh [rVBK], a
.tiles
  ld hl, render_bitmap
  ld de, $8010
  ld b, TB_WIDTH
.copy
  ld a, [hli];same ink in both bitplanes: palette color 3
  ld [de], a
  inc de
  ld [de], a
  inc de
  dec b
  jr nz, .copy
  ld hl, $9800+8*32
  ld b, TB_COLS
  ld a, 1
.map
  ld [hli], a
  inc a
  dec b
  jr nz, .map
  xor a
  ldh [rSCX], a
  ldh [rSCY], a
  ld a, $E4
  ldh [rBGP], a
  ld a, LCDCF_ON | LCDCF_BG8000 | LCDCF_BGON
  ldh [rLCDC], a
  ret

;Only the error path returns to the renderer. Normal launch keeps this screen
;and IE=0 until reset. The caller runs Layout before drawing the error box.
GameLoadingEnd:
  call GameLoadingOff
  ld a, [game_loading_lcdc]
  and a, ~LCDCF_ON
  ldh [rLCDC], a
  ld a, [game_loading_bgp]
  ldh [rBGP], a
  call RenderSetup
  ld a, [game_loading_ie]
  ldh [rIE], a
  DISPLAY_ON
  ret

GameLoadingOff:
  ldh a, [rLCDC]
  and a, LCDCF_ON
  ret z
.wait
  ldh a, [rLY]
  cp a, SCRN_Y
  jr c, .wait
  ldh a, [rLCDC]
  and a, ~LCDCF_ON
  ldh [rLCDC], a
  ret
END_PAGE
