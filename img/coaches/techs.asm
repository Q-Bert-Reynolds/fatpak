IF !DEF(_TECHS_TILE_COUNT)
DEF _TECHS_TILE_COUNT EQU 30
DEF _TECHS_ROWS EQU 7
DEF _TECHS_COLUMNS EQU 7
DEF _TECHS_PALETTE_COUNT EQU 1
_TechsColors:
  RGB 24, 24, 24
  RGB 11, 11, 11
_TechsPaletteMap:
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
_TechsTiles: INCBIN "img/coaches/techs.tiles"
_TechsTileMap: INCBIN "img/coaches/techs.tilemap"
ENDC
