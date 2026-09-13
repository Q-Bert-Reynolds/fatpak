IF !DEF(_SWIMMERS_TILE_COUNT)
DEF _SWIMMERS_TILE_COUNT EQU 27
DEF _SWIMMERS_ROWS EQU 7
DEF _SWIMMERS_COLUMNS EQU 7
DEF _SWIMMERS_PALETTE_COUNT EQU 1
_SwimmersColors:
  RGB 24, 24, 24
  RGB 11, 11, 11
_SwimmersPaletteMap:
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
_SwimmersTiles: INCBIN "img/coaches/swimmers.tiles"
_SwimmersTileMap: INCBIN "img/coaches/swimmers.tilemap"
ENDC
