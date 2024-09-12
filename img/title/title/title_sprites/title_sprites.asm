IF !DEF(_TITLE_SPRITES_TILE_COUNT)
DEF _TITLE_SPRITES_TILE_COUNT EQU 27
_TitleSpritesTiles: INCBIN "img/title/title/title_sprites/title_sprites.tiles"
DEF _CALVIN_TITLE_ROWS EQU 7
DEF _CALVIN_TITLE_COLUMNS EQU 5
_CalvinTitleTileMap: INCBIN "img/title/title/title_sprites/calvin_title.tilemap"
ENDC
