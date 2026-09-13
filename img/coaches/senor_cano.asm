IF !DEF(_SENOR_CANO_TILE_COUNT)
DEF _SENOR_CANO_TILE_COUNT EQU 22
DEF _SENOR_CANO_ROWS EQU 7
DEF _SENOR_CANO_COLUMNS EQU 7
DEF _SENOR_CANO_PALETTE_COUNT EQU 1
_SenorCanoColors:
  RGB 24, 24, 24
  RGB 11, 11, 11
_SenorCanoPaletteMap:
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
_SenorCanoTiles: INCBIN "img/coaches/senor_cano.tiles"
_SenorCanoTileMap: INCBIN "img/coaches/senor_cano.tilemap"
ENDC
