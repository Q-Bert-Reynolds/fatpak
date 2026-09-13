IF !DEF(_BEASTS_TILE_COUNT)
DEF _BEASTS_TILE_COUNT EQU 39
DEF _BEASTS_ROWS EQU 7
DEF _BEASTS_COLUMNS EQU 7
DEF _BEASTS_PALETTE_COUNT EQU 1
_BeastsColors:
  RGB 24, 24, 24
  RGB 11, 11, 11
_BeastsPaletteMap:
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
_BeastsTiles: INCBIN "img/coaches/beasts.tiles"
_BeastsTileMap: INCBIN "img/coaches/beasts.tilemap"
ENDC
