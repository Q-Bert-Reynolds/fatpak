IF !DEF(_ROCKETS_TILE_COUNT)
DEF _ROCKETS_TILE_COUNT EQU 38
DEF _ROCKETS_ROWS EQU 7
DEF _ROCKETS_COLUMNS EQU 7
DEF _ROCKETS_PALETTE_COUNT EQU 1
_RocketsColors:
  RGB 24, 24, 24
  RGB 11, 11, 11
_RocketsPaletteMap:
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
_RocketsTiles: INCBIN "img/coaches/rockets.tiles"
_RocketsTileMap: INCBIN "img/coaches/rockets.tilemap"
ENDC
