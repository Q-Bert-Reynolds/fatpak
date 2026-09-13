IF !DEF(_MANIACS_TILE_COUNT)
DEF _MANIACS_TILE_COUNT EQU 26
DEF _MANIACS_ROWS EQU 7
DEF _MANIACS_COLUMNS EQU 7
DEF _MANIACS_PALETTE_COUNT EQU 1
_ManiacsColors:
  RGB 24, 24, 24
  RGB 11, 11, 11
_ManiacsPaletteMap:
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
_ManiacsTiles: INCBIN "img/coaches/maniacs.tiles"
_ManiacsTileMap: INCBIN "img/coaches/maniacs.tilemap"
ENDC
