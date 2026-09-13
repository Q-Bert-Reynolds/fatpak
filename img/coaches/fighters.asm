IF !DEF(_FIGHTERS_TILE_COUNT)
DEF _FIGHTERS_TILE_COUNT EQU 37
DEF _FIGHTERS_ROWS EQU 7
DEF _FIGHTERS_COLUMNS EQU 7
DEF _FIGHTERS_PALETTE_COUNT EQU 1
_FightersColors:
  RGB 24, 24, 24
  RGB 11, 11, 11
_FightersPaletteMap:
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
_FightersTiles: INCBIN "img/coaches/fighters.tiles"
_FightersTileMap: INCBIN "img/coaches/fighters.tilemap"
ENDC
