IF !DEF(_VERSION_TILE_COUNT)
_VERSION_TILE_COUNT EQU 8
_VersionTiles: INCBIN "img/demo_version/version.tiles"
_VERSION_ROWS EQU 1
_VERSION_COLUMNS EQU 8
_VersionTileMap: INCBIN "img/demo_version/version.tilemap"
ENDC
