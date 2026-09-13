IF !DEF(_KIDS_TILE_COUNT)
DEF _KIDS_TILE_COUNT EQU 23
DEF _KIDS_ROWS EQU 7
DEF _KIDS_COLUMNS EQU 7
DEF _KIDS_PALETTE_COUNT EQU 1
_KidsColors:
  RGB 24, 24, 24
  RGB 11, 11, 11
_KidsPaletteMap:
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
_KidsTiles: INCBIN "img/coaches/kids.tiles"
_KidsTileMap: INCBIN "img/coaches/kids.tilemap"
ENDC
