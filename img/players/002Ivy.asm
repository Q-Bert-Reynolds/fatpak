IF !DEF(_002IVY_TILE_COUNT)
_002IVY_TILE_COUNT EQU 30
_002IVY_ROWS EQU 7
_002IVY_COLUMNS EQU 7
_002IVY_PALETTE_COUNT EQU 2
_002IvyColors:
  RGB  4,  4,  4
  RGB  6, 10,  8
  RGB  3, 14, 13
  RGB  0, 10, 11
_002IvyPaletteMap:
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,1,0
  DB 0,0,0,0,0,0,0
_002IvyTiles: INCBIN "img/players/002Ivy.tiles"
_002IvyTileMap: INCBIN "img/players/002Ivy.tilemap"
ENDC
