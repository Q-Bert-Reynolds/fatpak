IF !DEF(_SAILORS_TILE_COUNT)
DEF _SAILORS_TILE_COUNT EQU 34
DEF _SAILORS_ROWS EQU 7
DEF _SAILORS_COLUMNS EQU 7
DEF _SAILORS_PALETTE_COUNT EQU 1
_SailorsColors:
  RGB 24, 24, 24
  RGB 11, 11, 11
_SailorsPaletteMap:
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
_SailorsTiles: INCBIN "img/coaches/sailors.tiles"
_SailorsTileMap: INCBIN "img/coaches/sailors.tilemap"
ENDC
