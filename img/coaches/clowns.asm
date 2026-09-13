IF !DEF(_CLOWNS_TILE_COUNT)
DEF _CLOWNS_TILE_COUNT EQU 40
DEF _CLOWNS_ROWS EQU 7
DEF _CLOWNS_COLUMNS EQU 7
DEF _CLOWNS_PALETTE_COUNT EQU 1
_ClownsColors:
  RGB 24, 24, 24
  RGB 11, 11, 11
_ClownsPaletteMap:
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
_ClownsTiles: INCBIN "img/coaches/clowns.tiles"
_ClownsTileMap: INCBIN "img/coaches/clowns.tilemap"
ENDC
