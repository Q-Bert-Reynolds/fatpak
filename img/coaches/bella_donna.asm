IF !DEF(_BELLA_DONNA_TILE_COUNT)
DEF _BELLA_DONNA_TILE_COUNT EQU 30
DEF _BELLA_DONNA_ROWS EQU 7
DEF _BELLA_DONNA_COLUMNS EQU 7
DEF _BELLA_DONNA_PALETTE_COUNT EQU 1
_BellaDonnaColors:
  RGB 24, 24, 24
  RGB 11, 11, 11
_BellaDonnaPaletteMap:
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
_BellaDonnaTiles: INCBIN "img/coaches/bella_donna.tiles"
_BellaDonnaTileMap: INCBIN "img/coaches/bella_donna.tilemap"
ENDC
