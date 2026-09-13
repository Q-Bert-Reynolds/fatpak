IF !DEF(_QUEENS_TILE_COUNT)
DEF _QUEENS_TILE_COUNT EQU 36
DEF _QUEENS_ROWS EQU 7
DEF _QUEENS_COLUMNS EQU 7
DEF _QUEENS_PALETTE_COUNT EQU 1
_QueensColors:
  RGB 24, 24, 24
  RGB 11, 11, 11
_QueensPaletteMap:
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
_QueensTiles: INCBIN "img/coaches/queens.tiles"
_QueensTileMap: INCBIN "img/coaches/queens.tilemap"
ENDC
