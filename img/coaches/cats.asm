IF !DEF(_CATS_TILE_COUNT)
DEF _CATS_TILE_COUNT EQU 29
DEF _CATS_ROWS EQU 7
DEF _CATS_COLUMNS EQU 7
DEF _CATS_PALETTE_COUNT EQU 1
_CatsColors:
  RGB 24, 24, 24
  RGB 11, 11, 11
_CatsPaletteMap:
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
_CatsTiles: INCBIN "img/coaches/cats.tiles"
_CatsTileMap: INCBIN "img/coaches/cats.tilemap"
ENDC
