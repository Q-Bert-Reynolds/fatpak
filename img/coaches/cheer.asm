IF !DEF(_CHEER_TILE_COUNT)
DEF _CHEER_TILE_COUNT EQU 36
DEF _CHEER_ROWS EQU 7
DEF _CHEER_COLUMNS EQU 7
DEF _CHEER_PALETTE_COUNT EQU 1
_CheerColors:
  RGB 24, 24, 24
  RGB 11, 11, 11
_CheerPaletteMap:
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
_CheerTiles: INCBIN "img/coaches/cheer.tiles"
_CheerTileMap: INCBIN "img/coaches/cheer.tilemap"
ENDC
