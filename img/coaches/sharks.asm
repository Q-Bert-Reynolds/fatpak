IF !DEF(_SHARKS_TILE_COUNT)
DEF _SHARKS_TILE_COUNT EQU 40
DEF _SHARKS_ROWS EQU 7
DEF _SHARKS_COLUMNS EQU 7
DEF _SHARKS_PALETTE_COUNT EQU 1
_SharksColors:
  RGB 24, 24, 24
  RGB 11, 11, 11
_SharksPaletteMap:
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
_SharksTiles: INCBIN "img/coaches/sharks.tiles"
_SharksTileMap: INCBIN "img/coaches/sharks.tilemap"
ENDC
