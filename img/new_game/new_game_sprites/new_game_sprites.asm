IF !DEF(_NEW_GAME_SPRITES_TILE_COUNT)
DEF _NEW_GAME_SPRITES_TILE_COUNT EQU 4
_NewGameSpritesTiles: INCBIN "img/new_game/new_game_sprites/new_game_sprites.tiles"
DEF _NEW_GAME_CALVIN_ROWS EQU 2
DEF _NEW_GAME_CALVIN_COLUMNS EQU 2
_NewGameCalvinTileMap: INCBIN "img/new_game/new_game_sprites/new_game_calvin.tilemap"
ENDC
