IF !DEF(_SMOKE_TILE_COUNT)
DEF _SMOKE_TILE_COUNT EQU 30
DEF _SMOKE_ROWS EQU 7
DEF _SMOKE_COLUMNS EQU 7
DEF _SMOKE_PALETTE_COUNT EQU 1
_SmokeColors:
  RGB 24, 24, 24
  RGB 11, 11, 11
_SmokePaletteMap:
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
_SmokeTiles: INCBIN "img/coaches/smoke.tiles"
_SmokeTileMap: INCBIN "img/coaches/smoke.tilemap"
ENDC
