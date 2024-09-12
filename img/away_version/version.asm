IF !DEF(_VERSION_TILE_COUNT)
DEF _VERSION_TILE_COUNT EQU 8
_VersionTiles: INCBIN "img/away_version/version.tiles"
DEF _VERSION_ROWS EQU 1
DEF _VERSION_COLUMNS EQU 8
_VersionTileMap: INCBIN "img/away_version/version.tilemap"
ENDC
