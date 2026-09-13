IF !DEF(_LUCK_TILE_COUNT)
DEF _LUCK_TILE_COUNT EQU 34
DEF _LUCK_ROWS EQU 7
DEF _LUCK_COLUMNS EQU 7
DEF _LUCK_PALETTE_COUNT EQU 1
_LuckColors:
  RGB 24, 24, 24
  RGB 11, 11, 11
_LuckPaletteMap:
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
_LuckTiles: INCBIN "img/coaches/luck.tiles"
_LuckTileMap: INCBIN "img/coaches/luck.tilemap"
ENDC
