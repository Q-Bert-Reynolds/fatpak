IF !DEF(_CAPTAIN_SHREVE_TILE_COUNT)
DEF _CAPTAIN_SHREVE_TILE_COUNT EQU 33
DEF _CAPTAIN_SHREVE_ROWS EQU 7
DEF _CAPTAIN_SHREVE_COLUMNS EQU 7
DEF _CAPTAIN_SHREVE_PALETTE_COUNT EQU 1
_CaptainShreveColors:
  RGB 24, 24, 24
  RGB 11, 11, 11
_CaptainShrevePaletteMap:
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
_CaptainShreveTiles: INCBIN "img/coaches/captain_shreve.tiles"
_CaptainShreveTileMap: INCBIN "img/coaches/captain_shreve.tilemap"
ENDC
