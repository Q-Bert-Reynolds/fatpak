IF !DEF(_NOLAN2_TILE_COUNT)
DEF _NOLAN2_TILE_COUNT EQU 33
DEF _NOLAN2_ROWS EQU 7
DEF _NOLAN2_COLUMNS EQU 7
DEF _NOLAN2_PALETTE_COUNT EQU 1
_Nolan2Colors:
  RGB 24, 24, 24
  RGB 11, 11, 11
_Nolan2PaletteMap:
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
_Nolan2Tiles: INCBIN "img/coaches/nolan2.tiles"
_Nolan2TileMap: INCBIN "img/coaches/nolan2.tilemap"
ENDC
