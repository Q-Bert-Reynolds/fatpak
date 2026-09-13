IF !DEF(_RANGERS_TILE_COUNT)
DEF _RANGERS_TILE_COUNT EQU 31
DEF _RANGERS_ROWS EQU 7
DEF _RANGERS_COLUMNS EQU 7
DEF _RANGERS_PALETTE_COUNT EQU 1
_RangersColors:
  RGB 24, 24, 24
  RGB 11, 11, 11
_RangersPaletteMap:
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
_RangersTiles: INCBIN "img/coaches/rangers.tiles"
_RangersTileMap: INCBIN "img/coaches/rangers.tilemap"
ENDC
