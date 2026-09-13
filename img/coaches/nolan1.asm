IF !DEF(_NOLAN1_TILE_COUNT)
DEF _NOLAN1_TILE_COUNT EQU 32
DEF _NOLAN1_ROWS EQU 7
DEF _NOLAN1_COLUMNS EQU 7
DEF _NOLAN1_PALETTE_COUNT EQU 1
_Nolan1Colors:
  RGB 24, 24, 24
  RGB 11, 11, 11
_Nolan1PaletteMap:
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
_Nolan1Tiles: INCBIN "img/coaches/nolan1.tiles"
_Nolan1TileMap: INCBIN "img/coaches/nolan1.tilemap"
ENDC
