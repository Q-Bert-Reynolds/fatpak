IF !DEF(_RALPH_SOTO_TILE_COUNT)
DEF _RALPH_SOTO_TILE_COUNT EQU 34
DEF _RALPH_SOTO_ROWS EQU 7
DEF _RALPH_SOTO_COLUMNS EQU 7
DEF _RALPH_SOTO_PALETTE_COUNT EQU 1
_RalphSotoColors:
  RGB 24, 24, 24
  RGB 11, 11, 11
_RalphSotoPaletteMap:
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
_RalphSotoTiles: INCBIN "img/coaches/ralph_soto.tiles"
_RalphSotoTileMap: INCBIN "img/coaches/ralph_soto.tilemap"
ENDC
