IF !DEF(_GM_VENKMAN_TILE_COUNT)
DEF _GM_VENKMAN_TILE_COUNT EQU 27
DEF _GM_VENKMAN_ROWS EQU 7
DEF _GM_VENKMAN_COLUMNS EQU 7
DEF _GM_VENKMAN_PALETTE_COUNT EQU 1
_GmVenkmanColors:
  RGB 24, 24, 24
  RGB 11, 11, 11
_GmVenkmanPaletteMap:
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
_GmVenkmanTiles: INCBIN "img/coaches/gm_venkman.tiles"
_GmVenkmanTileMap: INCBIN "img/coaches/gm_venkman.tilemap"
ENDC
