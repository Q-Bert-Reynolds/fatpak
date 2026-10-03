IF !DEF(_PLAY_TILE_COUNT)
DEF _PLAY_TILE_COUNT EQU 116
_PlayTiles: INCBIN "img/play/play.tiles"
DEF _BASEBALL_FX_ROWS EQU 8
DEF _BASEBALL_FX_COLUMNS EQU 16
_BaseballFxTileMap: INCBIN "img/play/baseball_fx.tilemap"
ENDC
