IF !DEF(_001BUBBI_TILE_COUNT)
DEF _001BUBBI_TILE_COUNT EQU 22
DEF _001BUBBI_ROWS EQU 5
DEF _001BUBBI_COLUMNS EQU 5
DEF _001BUBBI_PALETTE_COUNT EQU 3
_001BubbiColors:
  RGB  4, 12,  9
  RGB  8,  7,  4
  RGB  6, 12, 15
  RGB  4,  4,  6
  RGB 21,  5, 10
  RGB  8,  7,  4
_001BubbiPaletteMap:
  DB 0,0,0,0,0
  DB 0,0,0,0,0
  DB 0,0,0,0,0
  DB 0,0,0,0,0
  DB 0,0,0,0,0
_001BubbiTiles: INCBIN "img/players/001Bubbi.tiles"
_001BubbiTileMap: INCBIN "img/players/001Bubbi.tilemap"
ENDC
