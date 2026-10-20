INCLUDE "src/beisbol.inc"

SECTION "Map Test", ROMX

TestMap::
  DISPLAY_OFF
  PLAY_SONG tessie_data, 1
  SET_DEFAULT_PALETTE
  TRAMPOLINE UILoadFontTiles
  ld a, MAP_OVERWORLD
  ld [map], a
  ld a, 20
  ld [map_x], a
  ld [map_y], a
  ld a, MAP_OVERWORLD_CHUNK_BILLETTOWNNE
  ld [map_chunk], a
  call LoadMap
  
  DISPLAY_ON
  
  ld a, WORLD_FRAME_STEP
  ldh [anim_step_size], a
  ld a, 8
  ldh [map_scroll_speed], a

.loop
    call UpdateInput
  .testUp
    ldh a, [button_state]
    and a, PADF_UP
    jr z, .testDown
    call MoveMapUp
    jp .testLeft
  .testDown
    ldh a, [button_state]
    and a, PADF_DOWN
    jr z, .testLeft
    call MoveMapDown
  .testLeft
    ldh a, [button_state]
    and a, PADF_LEFT
    jr z, .testRight
    call MoveMapLeft
    jp .testStartA
  .testRight
    ldh a, [button_state]
    and a, PADF_RIGHT
    jr z, .testStartA
    call MoveMapRight
  .testStartA
    ldh a, [last_button_state]
    and a, PADF_A | PADF_START
    jr nz, .wait
    ldh a, [button_state]
    and a, PADF_A | PADF_START
    jr nz, .exit
  .wait
    call CopyMapSpritesToOAMBuffer
    call gbdk_WaitVBL
    jp .loop
.exit
  ret
