DEF SIM_HEAD_TILE_ID EQU $33
DEF SIM_BODY_TILE_ID EQU $64

DEF SIM_PLAYER_ORIGIN_X EQU 4
DEF SIM_PLAYER_ORIGIN_Y EQU 10

MACRO SIM_PLAYER_DATA ;\1 = fielder/runner, \2 = position/base
Sim\1\2:
.player     DB ;upper nibble = team, lower nibble = lineup order
.anim_state DB ;upper nibble = running/fielding/throwing, lower nibble = frame
.vel_y      DB
.pos_y      DW
.vel_x      DB
.pos_x      DW
.dest_x     DB
.dest_y     DB
ENDM

MACRO INIT_SIM_PLAYER ;\1 = fielder/runner, \2 = position/base, \3 = x, \4 = y
  ld a, \3;x
  ld [Sim\1\2.pos_x], a
  ld [Sim\1\2.dest_x], a
  ld a, \4;y
  ld [Sim\1\2.pos_y], a
  ld [Sim\1\2.dest_y], a
ENDM

PUSHS
SECTION "Simulation Vars", WRAM0
SimPlayers:
SimFielders:
  SIM_PLAYER_DATA Fielder, 1;pitcher
  SIM_PLAYER_DATA Fielder, 2;catcher
  SIM_PLAYER_DATA Fielder, 3;first base
  SIM_PLAYER_DATA Fielder, 4;second base
  SIM_PLAYER_DATA Fielder, 5;third base
  SIM_PLAYER_DATA Fielder, 6;shortstop
  SIM_PLAYER_DATA Fielder, 7;left field
  SIM_PLAYER_DATA Fielder, 8;center field
  SIM_PLAYER_DATA Fielder, 9;right field

SimRunners:
  SIM_PLAYER_DATA Runner, 0;batter
  SIM_PLAYER_DATA Runner, 1;first
  SIM_PLAYER_DATA Runner, 2;second
  SIM_PLAYER_DATA Runner, 3;third
POPS

DEF SIM_PLAYER_SIZE EQU SimFielder2 - SimFielder1

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

UpdateSimPlayerVelocity: ;hl = sim player address
  push hl;sim player address

  inc hl;skip player
  inc hl;skip anim_state
  push hl;address of vel_y

.getPosition
  inc hl;skip vel_y
  ld c, [hl];pos_y
  inc hl
  inc hl;skip pos_y frac

  inc hl;skip vel_x
  ld b, [hl];pos_x
  inc hl
  inc hl;skip pos_x frac

.getDestination
  ld a, [hli]
  ld d, a;dest_x
  ld e, [hl];dest_y

.calcDirection
  ld a, d
  sub a, b;dest_x - pos_x
  ld d, a
  ld a, e
  sub a, c;dest_y - pos_y
  ld e, a
  call math_SignedNormalize
  
.setVelocity
  ;TODO: lerp velocity to speed * direction
  pop hl;address of vel_y
  ld [hl], e;vel_y
  inc hl
  inc hl
  inc hl
  ld [hl], d

  pop hl;sim player address
  ret

UpdateSimPlayerPosition: ;hl = sim player address
  push hl;sim player address
  inc hl;skip player data
  inc hl;skip animation state

  ld a, [hli];y velocity
  push hl
  call math_AddSignedByteToWord;a = y vel, hl = y pos
  pop hl
  inc hl
  inc hl

  ld a, [hli];x velocity
  call math_AddSignedByteToWord;a = x vel, hl = x pos
  pop hl;sim player address
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