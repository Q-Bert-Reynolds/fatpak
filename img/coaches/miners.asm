IF !DEF(_MINERS_TILE_COUNT)
DEF _MINERS_TILE_COUNT EQU 40
DEF _MINERS_ROWS EQU 7
DEF _MINERS_COLUMNS EQU 7
DEF _MINERS_PALETTE_COUNT EQU 1
_MinersColors:
  RGB 24, 24, 24
  RGB 11, 11, 11
_MinersPaletteMap:
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
_MinersTiles: INCBIN "img/coaches/miners.tiles"
_MinersTileMap: INCBIN "img/coaches/miners.tilemap"
ENDC
