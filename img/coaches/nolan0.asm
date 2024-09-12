IF !DEF(_NOLAN0_TILE_COUNT)
DEF _NOLAN0_TILE_COUNT EQU 28
DEF _NOLAN0_ROWS EQU 7
DEF _NOLAN0_COLUMNS EQU 7
DEF _NOLAN0_PALETTE_COUNT EQU 3
_Nolan0Colors:
  RGB 25, 21, 18
  RGB 18,  8,  7
  RGB 10, 18, 19
  RGB  8,  7, 14
  RGB 25, 21, 18
  RGB 10,  4,  4
_Nolan0PaletteMap:
  DB 0,0,0,0,0,0,0
  DB 0,0,0,2,0,0,0
  DB 0,0,0,0,0,0,0
  DB 1,1,1,1,1,1,1
  DB 1,1,1,1,1,1,1
  DB 1,1,1,1,0,1,1
  DB 1,1,1,1,0,1,1
_Nolan0Tiles: INCBIN "img/coaches/nolan0.tiles"
_Nolan0TileMap: INCBIN "img/coaches/nolan0.tilemap"
ENDC
