IF !DEF(_JOCKS_TILE_COUNT)
DEF _JOCKS_TILE_COUNT EQU 32
DEF _JOCKS_ROWS EQU 7
DEF _JOCKS_COLUMNS EQU 7
DEF _JOCKS_PALETTE_COUNT EQU 1
_JocksColors:
  RGB 24, 24, 24
  RGB 11, 11, 11
_JocksPaletteMap:
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
_JocksTiles: INCBIN "img/coaches/jocks.tiles"
_JocksTileMap: INCBIN "img/coaches/jocks.tilemap"
ENDC
