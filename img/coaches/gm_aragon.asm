IF !DEF(_GM_ARAGON_TILE_COUNT)
DEF _GM_ARAGON_TILE_COUNT EQU 33
DEF _GM_ARAGON_ROWS EQU 7
DEF _GM_ARAGON_COLUMNS EQU 7
DEF _GM_ARAGON_PALETTE_COUNT EQU 1
_GmAragonColors:
  RGB 24, 24, 24
  RGB 11, 11, 11
_GmAragonPaletteMap:
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
_GmAragonTiles: INCBIN "img/coaches/gm_aragon.tiles"
_GmAragonTileMap: INCBIN "img/coaches/gm_aragon.tilemap"
ENDC
