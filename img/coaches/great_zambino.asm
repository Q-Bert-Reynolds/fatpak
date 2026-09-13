IF !DEF(_GREAT_ZAMBINO_TILE_COUNT)
DEF _GREAT_ZAMBINO_TILE_COUNT EQU 38
DEF _GREAT_ZAMBINO_ROWS EQU 7
DEF _GREAT_ZAMBINO_COLUMNS EQU 7
DEF _GREAT_ZAMBINO_PALETTE_COUNT EQU 1
_GreatZambinoColors:
  RGB 24, 24, 24
  RGB 11, 11, 11
_GreatZambinoPaletteMap:
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
_GreatZambinoTiles: INCBIN "img/coaches/great_zambino.tiles"
_GreatZambinoTileMap: INCBIN "img/coaches/great_zambino.tilemap"
ENDC
