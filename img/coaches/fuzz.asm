IF !DEF(_FUZZ_TILE_COUNT)
DEF _FUZZ_TILE_COUNT EQU 30
DEF _FUZZ_ROWS EQU 7
DEF _FUZZ_COLUMNS EQU 7
DEF _FUZZ_PALETTE_COUNT EQU 1
_FuzzColors:
  RGB 24, 24, 24
  RGB 11, 11, 11
_FuzzPaletteMap:
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
_FuzzTiles: INCBIN "img/coaches/fuzz.tiles"
_FuzzTileMap: INCBIN "img/coaches/fuzz.tilemap"
ENDC
