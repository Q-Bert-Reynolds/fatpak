IF !DEF(_USER_INFO_TILE_COUNT)
_USER_INFO_TILE_COUNT EQU 37
_USER_INFO_ROWS EQU 18
_USER_INFO_COLUMNS EQU 20
_UserInfoTiles: INCBIN "img/user_info.tiles"
_UserInfoTileMap: INCBIN "img/user_info.tilemap"
ENDC
