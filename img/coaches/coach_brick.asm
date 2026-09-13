IF !DEF(_COACH_BRICK_TILE_COUNT)
DEF _COACH_BRICK_TILE_COUNT EQU 23
DEF _COACH_BRICK_ROWS EQU 7
DEF _COACH_BRICK_COLUMNS EQU 7
DEF _COACH_BRICK_PALETTE_COUNT EQU 1
_CoachBrickColors:
  RGB 24, 24, 24
  RGB 11, 11, 11
_CoachBrickPaletteMap:
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
_CoachBrickTiles: INCBIN "img/coaches/coach_brick.tiles"
_CoachBrickTileMap: INCBIN "img/coaches/coach_brick.tilemap"
ENDC
