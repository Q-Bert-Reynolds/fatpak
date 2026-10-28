INCLUDE "src/beisbol.inc"

SECTION "Simulation Code", ROMX

INCLUDE "img/field.asm"
INCLUDE "img/simulation.asm"
INCLUDE "src/baseball/sim_ball.asm"
INCLUDE "src/baseball/sim_player.asm"
INCLUDE "src/baseball/sim_fielding.asm"
INCLUDE "src/baseball/sim_running.asm"

;Sprite IDs
;0 to 25  - head and body for 9 fielders and 4 baserunners
;26 to 36 - dust particles for running
;37,38,39 - bounce fx, ball, shadow

ShowField:
  DISPLAY_OFF
  ld de, $8800;_VRAM+$1000+_UI_FONT_TILE_COUNT*16
  ld bc, _FIELD_TILE_COUNT*16
  ld hl, _FieldTiles
  call mem_CopyVRAM

  ld hl, $2020
  ld de, 0
  ld bc, _FieldTileMap
  ld a, _UI_FONT_TILE_COUNT
  call SetBkgTilesWithOffset

  ld de, $8000
  ld bc, _SIMULATION_TILE_COUNT*16
  ld hl, _SimulationTiles
  call mem_CopyVRAM

  ld a, 20
  ldh [rSCX], a
  ld a, 84
  ldh [rSCY], a
  DISPLAY_ON
  ret

SGBSimulationAttrBlk:
  ATTR_BLK 1
  ATTR_BLK_DATA %001, 3,3,3, 0,0, 20,18
  
RunSimulation::;a = ball speed, d = spray angle, e = launch angle
  push af;ball speed
  push de;spray/launch angle
  
  HIDE_WIN
  call HideAllSprites

.setPalettes
  ld hl, rOBP0
  ld [hl], DMG_PAL_BLBW
  ld hl, rOBP1
  ld [hl], DMG_PAL_BLWW

  ld bc, PaletteCalvin
  ld de, PaletteField
  call SetPalettesDirect

.setSGB
  ld hl, SGBSimulationAttrBlk
  call sgb_PacketTransfer

.setGBC  
  ldh a, [sys_info]
  and a, SYS_INFO_GBC
  jr z, .endSetPalettes
  
  ld hl, tile_buffer
  ld bc, 32*32
  ld a, 3
  call mem_Set
  ld d, 0;x
  ld e, 0;y
  ld h, 32;w
  ld l, 32;h
  ld bc, tile_buffer
  call GBCSetBkgPaletteMap
.endSetPalettes
  
  call ShowField

  pop bc;spray/launch angle
  pop af;ball speed
  call InitBall
  call InitRunners
  call InitFielders

  call CalculateLandingSpot ;returns landing xy in de
  push de;xy
  call GetClosestFielderByLocation ;de = xy, returns position number in a, distance in b
  pop de;xy
  ld [sim_chaser], a
  call MoveFieldersForPlay;a = position, de = xy
.loop
    call UpdateBall
    call UpdateRunners
    call SimulatePlayers
    call DrawBall
    call DrawRunners
    call DrawFielders
    call gbdk_WaitVBL

IF SIM_TEST_ENABLED
    call UpdateInput
    ld a, [last_button_state]
    and a, PADF_A | PADF_B
    jr nz, .loop
    ld a, [button_state]
    and a, PADF_B
    jr nz, .endSimulation
    ld a, [button_state]
    and a, PADF_A
    jr z, .loop
    

  ld a, %01110111
  call SignedRandom;runners
  ld a, d
  ld [runners_on_base], a
  ld a, e
  ld [runners_on_base+1], a

  ld a, %01111111
  call SignedRandom;ball speed
  push de

  ld a, %1000111
  call SignedRandom;direction

  pop af
  add a, 127
  jp RunSimulation
ELSE
    ld a, [ball_state]
    and a, BALL_STATE_IN_PLAY
    jr nz, .loop
    call AreRunnersRunning
    jr nz, .loop
ENDC

.endSimulation
  DISPLAY_OFF
  xor a
  ldh [rSCX], a
  ldh [rSCY], a
  CLEAR_SCREEN ' '
  SHOW_WIN
  DISPLAY_ON
  ret