IF !DEF(_MECHS_TILE_COUNT)
DEF _MECHS_TILE_COUNT EQU 34
DEF _MECHS_ROWS EQU 7
DEF _MECHS_COLUMNS EQU 7
DEF _MECHS_PALETTE_COUNT EQU 1
_MechsColors:
  RGB 24, 24, 24
  RGB 11, 11, 11
_MechsPaletteMap:
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
_MechsTiles: INCBIN "img/coaches/mechs.tiles"
_MechsTileMap: INCBIN "img/coaches/mechs.tilemap"
ENDC
