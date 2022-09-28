IF !DEF(_STRIKE_ZONE_TILE_COUNT)
_STRIKE_ZONE_TILE_COUNT EQU 3
_STRIKE_ZONE_ROWS EQU 1
_STRIKE_ZONE_COLUMNS EQU 3
_StrikeZoneTiles: INCBIN "img/strike_zone.tiles"
_StrikeZoneTileMap: INCBIN "img/strike_zone.tilemap"
ENDC
