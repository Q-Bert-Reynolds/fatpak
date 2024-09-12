IF !DEF(_COPYRIGHTS_TILE_COUNT)
DEF _COPYRIGHTS_TILE_COUNT EQU 32
_CopyrightsTiles: INCBIN "img/title/copyrights/copyrights.tiles"
DEF _COPYRIGHT_ROWS EQU 18
DEF _COPYRIGHT_COLUMNS EQU 20
_CopyrightTileMap: INCBIN "img/title/copyrights/copyright.tilemap"
ENDC
