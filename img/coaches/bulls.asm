IF !DEF(_BULLS_TILE_COUNT)
DEF _BULLS_TILE_COUNT EQU 38
DEF _BULLS_ROWS EQU 7
DEF _BULLS_COLUMNS EQU 7
DEF _BULLS_PALETTE_COUNT EQU 1
_BullsColors:
  RGB 24, 24, 24
  RGB 11, 11, 11
_BullsPaletteMap:
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
_BullsTiles: INCBIN "img/coaches/bulls.tiles"
_BullsTileMap: INCBIN "img/coaches/bulls.tilemap"
ENDC
