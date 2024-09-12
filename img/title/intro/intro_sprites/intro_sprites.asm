IF !DEF(_INTRO_SPRITES_TILE_COUNT)
DEF _INTRO_SPRITES_TILE_COUNT EQU 2
_IntroSpritesTiles: INCBIN "img/title/intro/intro_sprites/intro_sprites.tiles"
DEF _INTRO_BASEBALL_ROWS EQU 1
DEF _INTRO_BASEBALL_COLUMNS EQU 1
_IntroBaseballTileMap: INCBIN "img/title/intro/intro_sprites/intro_baseball.tilemap"
DEF _INTRO_SPARKS_ROWS EQU 1
DEF _INTRO_SPARKS_COLUMNS EQU 1
_IntroSparksTileMap: INCBIN "img/title/intro/intro_sprites/intro_sparks.tilemap"
ENDC
