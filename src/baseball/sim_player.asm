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