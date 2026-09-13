IF !DEF(_LADS_TILE_COUNT)
DEF _LADS_TILE_COUNT EQU 20
DEF _LADS_ROWS EQU 7
DEF _LADS_COLUMNS EQU 7
DEF _LADS_PALETTE_COUNT EQU 1
_LadsColors:
  RGB 24, 24, 24
  RGB 11, 11, 11
_LadsPaletteMap:
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
_LadsTiles: INCBIN "img/coaches/lads.tiles"
_LadsTileMap: INCBIN "img/coaches/lads.tilemap"
ENDC
