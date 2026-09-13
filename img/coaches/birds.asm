IF !DEF(_BIRDS_TILE_COUNT)
DEF _BIRDS_TILE_COUNT EQU 34
DEF _BIRDS_ROWS EQU 7
DEF _BIRDS_COLUMNS EQU 7
DEF _BIRDS_PALETTE_COUNT EQU 1
_BirdsColors:
  RGB 24, 24, 24
  RGB 11, 11, 11
_BirdsPaletteMap:
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
_BirdsTiles: INCBIN "img/coaches/birds.tiles"
_BirdsTileMap: INCBIN "img/coaches/birds.tilemap"
ENDC
