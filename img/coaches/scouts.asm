IF !DEF(_SCOUTS_TILE_COUNT)
DEF _SCOUTS_TILE_COUNT EQU 32
DEF _SCOUTS_ROWS EQU 7
DEF _SCOUTS_COLUMNS EQU 7
DEF _SCOUTS_PALETTE_COUNT EQU 1
_ScoutsColors:
  RGB 24, 24, 24
  RGB 11, 11, 11
_ScoutsPaletteMap:
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
_ScoutsTiles: INCBIN "img/coaches/scouts.tiles"
_ScoutsTileMap: INCBIN "img/coaches/scouts.tilemap"
ENDC
