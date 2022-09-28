IF !DEF(_NEW_GAME_TILE_COUNT)
_NEW_GAME_TILE_COUNT EQU 35
_NewGameTiles: INCBIN "img/new_game/new_game.tiles"
_SILHOUETTE0_ROWS EQU 7
_SILHOUETTE0_COLUMNS EQU 7
_Silhouette0TileMap: INCBIN "img/new_game/silhouette0.tilemap"
_SILHOUETTE1_ROWS EQU 7
_SILHOUETTE1_COLUMNS EQU 7
_Silhouette1TileMap: INCBIN "img/new_game/silhouette1.tilemap"
ENDC
