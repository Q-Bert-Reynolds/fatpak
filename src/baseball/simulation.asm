INCLUDE "src/beisbol.inc"

SECTION "Simulation Code", ROMX

INCLUDE "img/field.asm"
INCLUDE "img/simulation.asm"
INCLUDE "src/baseball/sim_player.asm"

;Sprite IDs
;0 to 25  - head and body for 9 fielders and 4 baserunners
;26 to 36 - dust particles for running
;37,38,39 - bounce fx, ball, shadow

DEF SIM_HEAD_TILE_ID EQU $33
DEF SIM_BODY_TILE_ID EQU $64

DEF SIM_PLAYER_ORIGIN_X EQU 4
DEF SIM_PLAYER_ORIGIN_Y EQU 12

DEF PHYS_POS_STEPS EQU 5

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

CalculateLandingSpot2:
  ld d, 0
  ld a, [ball_vel_z]
  sla a
  ld e, a
  jr nc, .skip
  ld d, 1
.skip;hang time = de

  ld a, PHYS_POS_STEPS
  rst math_Multiply
  ld d, h
  ld e, l

  push de;hang time * steps
  ld a, [ball_vel_x]
  rst math_Multiply
  ld a, [ball_pos_x]
  ld d, a
  ld a, [ball_pos_x+1]
  ld e, a
  add hl, de;landing spot x

  pop de;hang time * steps
  push hl;landing spot x

  ld a, [ball_vel_y]
  rst math_Multiply
  ld a, [ball_pos_y]
  ld d, a
  ld a, [ball_pos_y+1]
  ld e, a
  add hl, de;landing spot y
  pop bc;landing spot x

  ld d, b;x
  ld e, h;y
  ret

;TODO: this should calculated directly instead of iteratively
CalculateLandingSpot:; returns landing xy in de
  ld hl, ball_pos_x
  ld de, tile_buffer
  ld bc, ball_state - ball_pos_x
  call mem_Copy;copy ball pos,vel to tile buffer

.loopZ;until z == 0
    ld a, [tile_buffer+8];ball_vel_z
    cp 128;always apply gravity if going up
    jr nc, .applyGravity
    cp 135;don't fall faster than terminal velocity
    jr nc, .XY
  .applyGravity
    sub a, 1
    ld [tile_buffer+8], a;ball_vel_z

  .XY
    ld a, PHYS_POS_STEPS
  .loopXY
      push af;steps left
      ld a, [tile_buffer+6];ball_vel_x
      ld hl, tile_buffer;ball_pos_x
      call math_AddSignedByteToWord

      ld a, [tile_buffer+7];ball_vel_y
      ld hl, tile_buffer+2;ball_pos_y
      call math_AddSignedByteToWord

      ld a, [tile_buffer+8];ball_vel_z
      ld hl, tile_buffer+4;ball_pos_z
      call math_AddSignedByteToWord
      cp 0
      jr z, .skip
      cp 2
      jr nz, .landed
      ld a, 255
      ld [tile_buffer+4], a;ball_pos_z
    .skip
      pop af;steps left
      dec a
      jr nz, .loopXY
    jr .loopZ
.landed
  pop af;discard steps
  ld a, [tile_buffer];ball_pos_x
  ld d, a
  ld a, [tile_buffer+2];ball_pos_y
  ld e, a
  ret

SimulatePlayers:
  ld hl, SimPlayers
  ld a, 13;9 fielders, 4 runners
.loop
    push af;player count
    call UpdateSimPlayerVelocity
    call UpdateSimPlayerPosition
    ld bc, SIM_PLAYER_SIZE
    add hl, bc;next player
    pop af;players left to process
    dec a
    jr nz, .loop
  ret

SimulateBall:
  ld a, [ball_vel_z]
  cp 128;always apply gravity if going up
  jr nc, .applyGravity
  cp 135;don't fall faster than terminal velocity
  jr nc, .updatePosition
.applyGravity
  sub a, 1
  ld [ball_vel_z], a

.updatePosition
  ld a, PHYS_POS_STEPS
.updatePositionLoop
    push af;steps left
    ld a, [ball_vel_x]
    ld hl, ball_pos_x
    call math_AddSignedByteToWord

    ld a, [ball_vel_y]
    ld hl, ball_pos_y
    call math_AddSignedByteToWord

    ld a, [ball_vel_z]
    ld hl, ball_pos_z
    call math_AddSignedByteToWord
    cp 0
    jr z, .skip
    cp 2
    jr nz, .bounce
    ld a, 255
    ld [ball_pos_z], a
    jr .skip
  .bounce
    xor a
    ld [ball_pos_z], a
    ld [ball_pos_z+1], a
    ld a, [ball_vel_z]
    xor a, $FF
    ld b, a
    and a, %10000000
    srl b
    or a, b
    ld [ball_vel_z], a
    ld a, [ball_vel_x]
    ld b, a
    and a, %10000000
    srl b
    or a, b
    ld [ball_vel_x], a
    ld a, [ball_vel_y]
    ld b, a
    and a, %10000000
    srl b
    or a, b
    ld [ball_vel_y], a
  .skip
    pop af;steps left
    dec a
    jr nz, .updatePositionLoop

.slowXToStop
  ld a, [ball_vel_x]
  cp -1
  jr nz, .slowYToStop
  xor a
  ld [ball_vel_x], a

.slowYToStop
  ld a, [ball_vel_y]
  cp -1
  jr nz, .updateCameraY
  xor a
  ld [ball_vel_y], a

.updateCameraY
  ld a, [ball_pos_z]
  srl a
  srl a
  srl a
  ld b, a
  ld a, [ball_pos_y]
  sub a, b
  cp 80
  jr c, .moveToTop
  cp 191
  jr nc, .moveToBottom
  sub a, 80
  ldh [rSCY], a
  jr .updateCameraX
.moveToTop
  xor a
  ldh [rSCY], a
  jr .updateCameraX
.moveToBottom
  ld a, 112
  ldh [rSCY], a

.updateCameraX
  ld a, [ball_pos_x]
  cp 84
  jr c, .moveToLeft
  cp 179
  jr nc, .moveToRight
  sub a, 84
  ldh [rSCX], a
  ret
.moveToLeft
  xor a
  ldh [rSCX], a
  ret
.moveToRight
  ld a, 96
  ldh [rSCX], a
  ret

DrawBall:
  ld hl, oam_buffer+38*4;ball and shadow are second to last sprites
  ldh a, [rSCY]
  ld b, a
  ld a, [ball_pos_y]
  sub a, b
  ld b, a
  ld a, [ball_pos_z]
  srl a
  ld c, a
  ld a, b
  sub a, c
  ld [hli], a;y
  ldh a, [rSCX]
  ld b, a
  ld a, [ball_pos_x]
  sub a, b
  ld [hli], a;x
  ld a, [ball_pos_z]
  swap a
  and %00001111
  ld [hli], a;tile
  ld a, OAMF_PAL1
  ld [hli], a;prop

.drawShadow
  ldh a, [rSCY]
  ld b, a
  ld a, [ball_pos_y]
  sub a, b
  inc a
  ld [hli], a
  ldh a, [rSCX]
  ld b, a
  ld a, [ball_pos_x]
  sub a, b
  inc a
  ld [hli], a
  ld a, 16
  ld [hli], a
  xor a
  ld [hl], a

  ret

InitRunners:
  ;TODO: set palettebased on player data

.batter
  ld a, HOME_PLATE_X+4;TODO: place based on handedness
  ld [SimRunner0.pos_x], a
  ld a, HOME_PLATE_Y+4
  ld [SimRunner0.pos_y], a
  ld a, FIRST_BASE_X
  ld [SimRunner0.dest_x], a
  ld a, FIRST_BASE_Y
  ld [SimRunner0.dest_y], a

.firstBase
  ld bc, 0
  ld a, [runners_on_base]
  and a, $0F
  jr z, .setFirstBaserRunner
  ld b, FIRST_BASE_X+4
  ld c, FIRST_BASE_Y-12
.setFirstBaserRunner
  INIT_SIM_PLAYER Runner, 1, b, c

.secondBase
  ld bc, 0
  ld a, [runners_on_base]
  swap a
  and a, $0F
  jr z, .setSecondBaserRunner
  ld b, SECOND_BASE_X-12
  ld c, SECOND_BASE_Y-12
.setSecondBaserRunner
  INIT_SIM_PLAYER Runner, 2, b, c

.thirdBase
  ld bc, 0
  ld a, [runners_on_base+1]
  and a, $0F
  jr z, .setThirdBaserRunner
  ld b, THIRD_BASE_X-12
  ld c, THIRD_BASE_Y+4
.setThirdBaserRunner
  INIT_SIM_PLAYER Runner, 3, b, c

  call DrawRunners
  ret


InitFielders:
  INIT_SIM_PLAYER Fielder, 1,  81, 174 ;pitcher
  INIT_SIM_PLAYER Fielder, 2,  36, 220 ;catcher
  INIT_SIM_PLAYER Fielder, 3, 130, 204 ;first
  INIT_SIM_PLAYER Fielder, 4, 152, 142 ;second
  INIT_SIM_PLAYER Fielder, 5,  55, 124 ;third
  INIT_SIM_PLAYER Fielder, 6, 111, 100 ;short
  INIT_SIM_PLAYER Fielder, 7,  84,  24 ;left field
  INIT_SIM_PLAYER Fielder, 8, 190,  56 ;center field
  INIT_SIM_PLAYER Fielder, 9, 214, 180 ;right field
  call DrawFielders
  ret

DrawRunners:
  ld de, oam_buffer+9*2*4
  ld hl, SimRunner0.pos_y
  ld b, OAMF_PAL1
  ld c, 4
  jr DrawPlayers

DrawFielders:
  ld de, oam_buffer
  ld hl, SimFielder1.pos_y
  ld b, OAMF_PAL0
  ld c, 9
  ;fall through to DrawPlayers

DrawPlayers:;c = num players, de = oam_buffer address, hl = first player's pos_y
.loop
    push bc;palette, players left
  .drawBody
    ldh a, [rSCY]
    ld b, a
    ld a, [hli];y
    add a, SIM_PLAYER_ORIGIN_Y
    inc hl
    inc hl;skip to x position
    sub a, b
    ld [de], a
    inc de
    ldh a, [rSCX]
    ld b, a
    ld a, [hld];x
    add a, SIM_PLAYER_ORIGIN_X
    dec hl
    dec hl;return to y position
    sub a, b
    ld [de], a
    inc de
    ld a, SIM_BODY_TILE_ID
    ld [de], a;tile
    inc de
  .drawHead
    pop bc;palette, players left
    push bc
    ld a, b
    ld [de], a;prop
    inc de
    ldh a, [rSCY]
    ld b, a
    ld a, [hli];y
    add a, SIM_PLAYER_ORIGIN_Y
    inc hl
    inc hl;skip to x position
    sub a, b
    sub a, 8
    ld [de], a
    inc de
    ldh a, [rSCX]
    ld b, a
    ld a, [hl];x
    add a, SIM_PLAYER_ORIGIN_X
    sub a, b
    ld [de], a
    inc de
    ld bc, SimFielder2.pos_y - SimFielder1.pos_x
    add hl, bc
    ld a, SIM_HEAD_TILE_ID
    ld [de], a;tile
    inc de
    xor a
    ld [de], a;prop
    inc de
  .nextPlayer
    pop bc;props, players left
    dec c
    jr nz, .loop
  ret

InitBall:;a = ball speed b = spray angle c = launch angle
  ld d, 0
  ld e, a
  push de;speed
  push bc;angles

  ; put ball in front of home plate
  ld a, HOME_PLATE_X+4
  ld [ball_pos_x], a
  ld a, HOME_PLATE_Y+12
  ld [ball_pos_y], a
  ld a, 1
  ld [ball_pos_z], a

  xor a
  ld [ball_pos_x+1], a
  ld [ball_pos_y+1], a
  ld [ball_pos_z+1], a

.calcZVelocity;z = a * sin(c)
  pop bc;spray,launch
  pop de;speed
  push de;speed
  push bc;spray,launch
  push de;speed

  ld a, c
  call math_Sin127
  pop hl;speed
  add hl, hl
  ld d, h
  ld e, l
  call math_SignedMultiply;v * sin(ang)*127
  ld a, h
  ld [ball_vel_z], a

.calcForwardVelocity;forward = a * cos(c)
  pop bc;spray,launch
  pop de;speed
  push bc;spray,launch
  push de;speed

  ld a, c
  call math_Cos127
  pop hl;de;speed
  ; call math_SignedMultiply;hl = forward = speed*cos(launch)*127 = de*cos(c)*127

.calcXVelocity;TODO: x = forward * sin(45-b)
  pop bc;angles
  push bc;angles
  push hl;forward

  ld a, 45
  add a, b
  call math_Sin127
  pop de;forward
  push de;forward
  call math_SignedMultiply;hl = x speed * 127
  ld a, h
  ld [ball_vel_x], a
  
.calcYVelocity;TODO: y = forward * cos(45-b)
  pop hl;forward
  pop bc;angles
  push hl;forward

  ld a, 45
  add a, b
  call math_Cos127
  pop de;forward
  call math_SignedMultiply;hl = y speed * 127
  ld a, h
  cpl
  inc a
  ld [ball_vel_y], a
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

.loop
    call SimulateBall
    call SimulatePlayers

    call DrawBall
    call DrawRunners
    call DrawFielders

    call gbdk_WaitVBL

    ld a, [ball_vel_x]
    ld b, a
    ld a, [ball_vel_y]
    or a, b
    ld b, a
    ld a, [ball_vel_z]
    or a, b
    ld b, a
    ld a, [ball_pos_z]
    or a, b
    jr nz, .loop
    
IF SIM_TEST_ENABLED
  ld a, %0001111
  call SignedRandom
  push de
  ld a, %1000111
  call SignedRandom
  pop af
  add a, 100
  jp RunSimulation
ENDC

  DISPLAY_OFF
  xor a
  ldh [rSCX], a
  ldh [rSCY], a
  CLEAR_SCREEN ' '
  SHOW_WIN
  DISPLAY_ON
  ret