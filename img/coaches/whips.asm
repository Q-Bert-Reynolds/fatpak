IF !DEF(_WHIPS_TILE_COUNT)
DEF _WHIPS_TILE_COUNT EQU 33
DEF _WHIPS_ROWS EQU 7
DEF _WHIPS_COLUMNS EQU 7
DEF _WHIPS_PALETTE_COUNT EQU 1
_WhipsColors:
  RGB 24, 24, 24
  RGB 11, 11, 11
_WhipsPaletteMap:
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
_WhipsTiles: INCBIN "img/coaches/whips.tiles"
_WhipsTileMap: INCBIN "img/coaches/whips.tilemap"
ENDC
