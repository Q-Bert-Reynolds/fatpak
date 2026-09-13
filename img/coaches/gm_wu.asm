IF !DEF(_GM_WU_TILE_COUNT)
DEF _GM_WU_TILE_COUNT EQU 40
DEF _GM_WU_ROWS EQU 7
DEF _GM_WU_COLUMNS EQU 7
DEF _GM_WU_PALETTE_COUNT EQU 1
_GmWuColors:
  RGB 24, 24, 24
  RGB 11, 11, 11
_GmWuPaletteMap:
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
_GmWuTiles: INCBIN "img/coaches/gm_wu.tiles"
_GmWuTileMap: INCBIN "img/coaches/gm_wu.tilemap"
ENDC
