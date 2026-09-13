IF !DEF(_GM_GANDIL_TILE_COUNT)
DEF _GM_GANDIL_TILE_COUNT EQU 30
DEF _GM_GANDIL_ROWS EQU 7
DEF _GM_GANDIL_COLUMNS EQU 7
DEF _GM_GANDIL_PALETTE_COUNT EQU 1
_GmGandilColors:
  RGB 24, 24, 24
  RGB 11, 11, 11
_GmGandilPaletteMap:
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
_GmGandilTiles: INCBIN "img/coaches/gm_gandil.tiles"
_GmGandilTileMap: INCBIN "img/coaches/gm_gandil.tilemap"
ENDC
