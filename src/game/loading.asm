;Keep the browser and its Loading... box in VRAM. The loading box uses the
;renderer's CPU-copy path, with no HDMA. Only its resident LCD interrupt stays
;enabled: window/tile addressing still needs raster changes, while VBlank/OAM
;DMA, the spinner and input updates stay stopped for the whole load.
SECTION "Game Loading State", WRAM0
game_loading_ie: DB
game_loading_lcdc: DB

FIXED "Game Loading Stubs";always mapped; leave ROM0 space for warm startup
_GameLoadingBegin:: BANKED_C GameLoadingBegin
_GameLoadingEnd:: BANKED_C GameLoadingEnd

PAGE GAME_PAGE
GameLoadingBegin:
  call RenderWaitDMA;finish any older row queued before CPU-copy mode was selected
.settle
  ld a, [_render_pending]
  and a
  jr nz, .settle
  ldh a, [rSCY]
  ld hl, render_target_scy
  cp a, [hl]
  jr nz, .settle
  ldh a, [rIE]
  ld [game_loading_ie], a
  xor a
  ldh [rIE], a
  ldh a, [rLCDC]
  ld [game_loading_lcdc], a
  call GameLoadingOff
  ldh a, [rLCDC]
  and a, ~LCDCF_OBJON;hide the spinner/cursor while their VBlank updates are stopped
  ldh [rLCDC], a
  call GameLoadingRaster
  ld a, [game_loading_ie]
  and a, IEF_STAT
  ldh [rIE], a
  ret

;Only failures return to the UI. Tiles, palettes and maps were never replaced.
;CPU speed is unchanged throughout loading; GameLaunch selects normal speed for reset.
GameLoadingEnd:
  xor a
  ldh [rIE], a
  call GameLoadingOff
  ld a, [game_loading_lcdc]
  and a, ~LCDCF_ON
  ldh [rLCDC], a
  xor a
  ld [_render_cpu_copy], a
  call GameLoadingRaster
  ld a, [game_loading_ie]
  ldh [rIE], a
  ret

;LCD is off: restart the existing layout from its top-of-frame LCDC/event state.
GameLoadingRaster:
  ld a, SCRN_Y
  ldh [rLYC], a
  call RenderLCDInterrupt
  ldh a, [rIF]
  and a, ~IEF_STAT
  ldh [rIF], a
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
