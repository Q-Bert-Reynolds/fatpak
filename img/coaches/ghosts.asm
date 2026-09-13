IF !DEF(_GHOSTS_TILE_COUNT)
DEF _GHOSTS_TILE_COUNT EQU 35
DEF _GHOSTS_ROWS EQU 7
DEF _GHOSTS_COLUMNS EQU 7
DEF _GHOSTS_PALETTE_COUNT EQU 1
_GhostsColors:
  RGB 24, 24, 24
  RGB 11, 11, 11
_GhostsPaletteMap:
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
_GhostsTiles: INCBIN "img/coaches/ghosts.tiles"
_GhostsTileMap: INCBIN "img/coaches/ghosts.tilemap"
ENDC
