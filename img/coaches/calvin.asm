IF !DEF(_CALVIN_TILE_COUNT)
_CALVIN_TILE_COUNT EQU 26
_CALVIN_ROWS EQU 7
_CALVIN_COLUMNS EQU 7
_CALVIN_PALETTE_COUNT EQU 2
_CalvinColors:
  RGB 18,  6,  6
  RGB  8,  5,  4
  RGB 16, 10,  7
  RGB  8,  5,  4
_CalvinPaletteMap:
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
_CalvinTiles: INCBIN "img/coaches/calvin.tiles"
_CalvinTileMap: INCBIN "img/coaches/calvin.tilemap"
ENDC
