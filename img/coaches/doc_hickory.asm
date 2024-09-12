IF !DEF(_DOC_HICKORY_TILE_COUNT)
DEF _DOC_HICKORY_TILE_COUNT EQU 29
DEF _DOC_HICKORY_ROWS EQU 7
DEF _DOC_HICKORY_COLUMNS EQU 7
DEF _DOC_HICKORY_PALETTE_COUNT EQU 4
_DocHickoryColors:
  RGB 15, 12, 16
  RGB 10,  8,  8
  RGB 25, 21, 18
  RGB 22, 14, 15
  RGB 25, 21, 18
  RGB 10,  8,  8
  RGB 17, 13, 16
  RGB 20, 15, 13
_DocHickoryPaletteMap:
  DB 0,0,0,0,0,0,0
  DB 0,0,1,1,1,0,0
  DB 0,1,3,3,0,0,0
  DB 0,1,1,2,0,1,0
  DB 0,1,0,0,0,1,0
  DB 0,0,2,2,2,0,0
  DB 0,0,1,1,1,0,0
_DocHickoryTiles: INCBIN "img/coaches/doc_hickory.tiles"
_DocHickoryTileMap: INCBIN "img/coaches/doc_hickory.tilemap"
ENDC
