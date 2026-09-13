IF !DEF(_GM_ELSA_TILE_COUNT)
DEF _GM_ELSA_TILE_COUNT EQU 29
DEF _GM_ELSA_ROWS EQU 7
DEF _GM_ELSA_COLUMNS EQU 7
DEF _GM_ELSA_PALETTE_COUNT EQU 1
_GmElsaColors:
  RGB 24, 24, 24
  RGB 11, 11, 11
_GmElsaPaletteMap:
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
  DB 0,0,0,0,0,0,0
_GmElsaTiles: INCBIN "img/coaches/gm_elsa.tiles"
_GmElsaTileMap: INCBIN "img/coaches/gm_elsa.tilemap"
ENDC
