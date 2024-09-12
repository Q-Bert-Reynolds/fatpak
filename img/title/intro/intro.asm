IF !DEF(_INTRO_TILE_COUNT)
DEF _INTRO_TILE_COUNT EQU 150
_IntroTiles: INCBIN "img/title/intro/intro.tiles"
DEF _INTRO_PITCH2_ROWS EQU 6
DEF _INTRO_PITCH2_COLUMNS EQU 11
_IntroPitch2TileMap: INCBIN "img/title/intro/intro_pitch2.tilemap"
DEF _INTRO_PITCH0_ROWS EQU 6
DEF _INTRO_PITCH0_COLUMNS EQU 11
_IntroPitch0TileMap: INCBIN "img/title/intro/intro_pitch0.tilemap"
DEF _INTRO_PITCH1_ROWS EQU 6
DEF _INTRO_PITCH1_COLUMNS EQU 11
_IntroPitch1TileMap: INCBIN "img/title/intro/intro_pitch1.tilemap"
DEF _INTRO_LIGHT_OUT_ROWS EQU 2
DEF _INTRO_LIGHT_OUT_COLUMNS EQU 2
_IntroLightOutTileMap: INCBIN "img/title/intro/intro_light_out.tilemap"
DEF _INTRO_LIGHTS_ROWS EQU 18
DEF _INTRO_LIGHTS_COLUMNS EQU 20
_IntroLightsTileMap: INCBIN "img/title/intro/intro_lights.tilemap"
DEF _INTRO_PITCH_ROWS EQU 18
DEF _INTRO_PITCH_COLUMNS EQU 32
_IntroPitchTileMap: INCBIN "img/title/intro/intro_pitch.tilemap"
ENDC
