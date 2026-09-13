IF !DEF(_PSYCHOS_TILE_COUNT)
DEF _PSYCHOS_TILE_COUNT EQU 30
DEF _PSYCHOS_ROWS EQU 7
DEF _PSYCHOS_COLUMNS EQU 7
DEF _PSYCHOS_PALETTE_COUNT EQU 1
_PsychosColors:
  RGB 24, 24, 24
  RGB 11, 11, 11
_PsychosPaletteMap:
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
_PsychosTiles: INCBIN "img/coaches/psychos.tiles"
_PsychosTileMap: INCBIN "img/coaches/psychos.tilemap"
ENDC
