IF !DEF(_NEW_GAME_TILE_COUNT)
DEF _NEW_GAME_TILE_COUNT EQU 35
_NewGameTiles: INCBIN "img/new_game/new_game.tiles"
DEF _SILHOUETTE0_ROWS EQU 7
DEF _SILHOUETTE0_COLUMNS EQU 7
_Silhouette0TileMap: INCBIN "img/new_game/silhouette0.tilemap"
DEF _SILHOUETTE1_ROWS EQU 7
DEF _SILHOUETTE1_COLUMNS EQU 7
_Silhouette1TileMap: INCBIN "img/new_game/silhouette1.tilemap"
ENDC
