IF !DEF(_OLDTIMERS_TILE_COUNT)
DEF _OLDTIMERS_TILE_COUNT EQU 26
DEF _OLDTIMERS_ROWS EQU 7
DEF _OLDTIMERS_COLUMNS EQU 7
DEF _OLDTIMERS_PALETTE_COUNT EQU 1
_OldtimersColors:
  RGB 24, 24, 24
  RGB 11, 11, 11
_OldtimersPaletteMap:
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
_OldtimersTiles: INCBIN "img/coaches/oldtimers.tiles"
_OldtimersTileMap: INCBIN "img/coaches/oldtimers.tilemap"
ENDC
