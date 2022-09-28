IF !DEF(_TOWN_MAP_TILE_COUNT)
_TOWN_MAP_TILE_COUNT EQU 46
_TOWN_MAP_ROWS EQU 18
_TOWN_MAP_COLUMNS EQU 20
_TownMapTiles: INCBIN "img/town_map.tiles"
_TownMapTileMap: INCBIN "img/town_map.tilemap"
ENDC
