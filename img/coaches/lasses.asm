IF !DEF(_LASSES_TILE_COUNT)
DEF _LASSES_TILE_COUNT EQU 24
DEF _LASSES_ROWS EQU 7
DEF _LASSES_COLUMNS EQU 7
DEF _LASSES_PALETTE_COUNT EQU 1
_LassesColors:
  RGB 24, 24, 24
  RGB 11, 11, 11
_LassesPaletteMap:
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
_LassesTiles: INCBIN "img/coaches/lasses.tiles"
_LassesTileMap: INCBIN "img/coaches/lasses.tilemap"
ENDC
