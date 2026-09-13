IF !DEF(_SKIP_RIVERS_TILE_COUNT)
DEF _SKIP_RIVERS_TILE_COUNT EQU 28
DEF _SKIP_RIVERS_ROWS EQU 7
DEF _SKIP_RIVERS_COLUMNS EQU 7
DEF _SKIP_RIVERS_PALETTE_COUNT EQU 1
_SkipRiversColors:
  RGB 24, 24, 24
  RGB 11, 11, 11
_SkipRiversPaletteMap:
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
_SkipRiversTiles: INCBIN "img/coaches/skip_rivers.tiles"
_SkipRiversTileMap: INCBIN "img/coaches/skip_rivers.tilemap"
ENDC
