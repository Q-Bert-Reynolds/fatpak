DEF SIM_HEAD_TILE_ID EQU $33
DEF SIM_BODY_TILE_ID EQU $64

DEF SIM_PLAYER_ORIGIN_X EQU 4
DEF SIM_PLAYER_ORIGIN_Y EQU 10

DEF SIM_PLAYER_ACCEL     EQU 8   ;velocity change per frame
DEF SIM_PLAYER_MIN_SPEED EQU 96  ;added to speed stat / 2
DEF SIM_PLAYER_MAX_SPEED EQU 127 ;1/256ths of a pixel per frame

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
.speed      DB
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

;fielder assignments
DEF STAY   EQU 0
DEF BALL   EQU 1
DEF BACKUP EQU 2
DEF COVER1 EQU 3
DEF COVER2 EQU 4
DEF COVER3 EQU 5
DEF COVERH EQU 6

DEF CF_LEFT_GAP EQU 10;row used when the center fielder takes a ball left of second

FielderAssignments:;row = position fielding the ball, column = fielder
  ;   P       C       1B      2B      3B      SS      LF      CF      RF
  DB BALL,   COVERH, COVER1, STAY,   COVER3, COVER2, STAY,   STAY,   STAY  ;P
  DB COVERH, BALL,   COVER1, STAY,   COVER3, COVER2, STAY,   STAY,   STAY  ;C
  DB COVER1, COVERH, BALL,   STAY,   COVER3, COVER2, STAY,   STAY,   STAY  ;1B
  DB STAY,   COVERH, COVER1, BALL,   COVER3, COVER2, STAY,   STAY,   STAY  ;2B
  DB STAY,   COVERH, COVER1, COVER2, BALL,   COVER3, STAY,   STAY,   STAY  ;3B
  DB STAY,   COVERH, COVER1, COVER2, COVER3, BALL,   STAY,   STAY,   STAY  ;SS
  DB STAY,   COVERH, COVER1, COVER2, COVER3, STAY,   BALL,   BACKUP, STAY  ;LF
  DB STAY,   COVERH, COVER1, STAY,   COVER3, COVER2, STAY,   BALL,   BACKUP;CF right gap
  DB STAY,   COVERH, COVER1, STAY,   COVER3, COVER2, STAY,   BACKUP, BALL  ;RF
  DB STAY,   COVERH, COVER1, STAY,   COVER3, COVER2, BACKUP, BALL,   STAY  ;CF left gap

BasePositions:
  DB FIRST_BASE_X, FIRST_BASE_Y
  DB SECOND_BASE_X, SECOND_BASE_Y
  DB THIRD_BASE_X, THIRD_BASE_Y
  DB HOME_PLATE_X, HOME_PLATE_Y

MoveFieldersForPlay:;a = position fielding the ball, de = landing xy
  cp a, CENTER_FIELDER
  jr nz, .getAssignments
  ld b, a
  ld a, d
  add a, e;x + y > 255 is right of the line from home through second
  ld a, b
  jr c, .getAssignments
  ld a, CF_LEFT_GAP
.getAssignments
  dec a
  push de;landing xy
  ld de, RIGHT_FIELDER
  rst math_Multiply
  ld de, FielderAssignments
  add hl, de
  pop de;landing xy
  ld a, PITCHER
.loop
    push af;position
    push de;landing xy
    push hl;assignment address
    ld a, [hl]
    and a
    jr z, .next;STAY
    dec a
    jr z, .move;BALL
    dec a
    jr z, .backup
  .cover
    add a, a
    ld c, a
    ld b, 0
    ld hl, BasePositions-2
    add hl, bc
    ld a, [hli]
    ld d, a
    ld e, [hl]
    jr .move
  .backup
    call GetBackupPosition
  .move
    pop hl;assignment address
    pop bc;landing xy
    pop af;position
    push af
    push bc
    push hl
    call MoveFielderToPosition
  .next
    pop hl;assignment address
    pop de;landing xy
    pop af;position
    inc hl
    inc a
    cp a, RIGHT_FIELDER+1
    jr nz, .loop
  ret

GetBackupPosition:;de = landing xy, returns xy behind landing (away from home) in de
  push de;landing xy
  ld a, d
  sub a, HOME_PLATE_X
  rra;halve 9 bit differences to fit in signed bytes
  ld b, a
  ld a, e
  sub a, HOME_PLATE_Y
  rra
  ld e, a
  ld d, b
  call math_SignedNormalize
  sra d
  sra d
  sra d;~16 pixels
  sra e
  sra e
  sra e
  pop bc;landing xy
  ld a, b
  ld b, d
  call AddSignedOffsetClamped
  ld d, a
  ld a, c
  ld b, e
  call AddSignedOffsetClamped
  ld e, a
  ret

AddSignedOffsetClamped:;a = position, b = signed offset, returns position clamped to 0-255 in a
  add a, b
  bit 7, b
  jr nz, .negative
  ret nc
  ld a, 255
  ret
.negative
  ret c
  xor a
  ret

MoveFielderToPosition:;a = position, de = xy
  push de;xy
  dec a
  ld de, SIM_PLAYER_SIZE
  rst math_Multiply
  ld de, SimFielder1.dest_x
  add hl, de

  pop de;xy
  ld [hl], d;x
  inc hl
  ld [hl], e;y
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

UpdateSimPlayerVelocity: ;hl = sim player address
  push hl;sim player address
  ld de, SimFielder1.pos_y - SimFielder1
  add hl, de
  ld c, [hl];pos_y
  ld e, SimFielder1.pos_x - SimFielder1.pos_y
  add hl, de
  ld b, [hl];pos_x
  ld e, SimFielder1.dest_x - SimFielder1.pos_x
  add hl, de

.calcDelta;halve 9 bit differences to fit in signed bytes
  ld a, [hli];dest_x
  sub a, b
  ld b, a;dx, 0 when arrived
  rra
  ld d, a;dx/2
  ld a, [hli];dest_y
  sub a, c
  ld c, a;dy, 0 when arrived
  rra
  ld e, a;dy/2
  or a, d
  jr nz, .getSpeed
  ld d, b;dx/2 and dy/2 can both be 0 when dx or dy is 1
  ld e, c
.getSpeed
  ld a, [hl];speed
  push bc;dx, dy
  push af;speed
  call math_SignedNormalize

.calcTargetVelocity;target = speed * direction / 128
  pop af;speed
  ld h, d
  ld l, e;direction
  ld d, 0
  ld e, a;speed
  push hl;direction
  ld a, h
  call math_SignedMultiply
  add hl, hl
  pop bc;direction
  push hl;target x in h
  ld a, c
  call math_SignedMultiply
  add hl, hl
  pop bc;target x in b
  ld c, h;target y

.setVelocity
  pop de;dx, dy
  pop hl;sim player address
  push hl
  inc hl
  inc hl;vel_y
  ld a, e;dy
  and a
  jr z, .stopY
  ld a, c;target y
  call AccelerateSimPlayer
  jr .setVelocityX
.stopY
  ld [hl], a
.setVelocityX
  inc hl
  inc hl
  inc hl;vel_x
  ld a, d;dx
  and a
  jr z, .stopX
  ld a, b;target x
  call AccelerateSimPlayer
  pop hl;sim player address
  ret
.stopX
  ld [hl], a
  pop hl;sim player address
  ret

AccelerateSimPlayer:;a = target velocity, hl = velocity address
  xor a, $80;bias signed values so they compare as unsigned
  ld e, a
  ld a, [hl]
  xor a, $80
  cp a, e
  jr nc, .slowDown
.speedUp
  add a, SIM_PLAYER_ACCEL
  jr c, .clamp
  cp a, e
  jr c, .set
  jr .clamp
.slowDown
  sub a, SIM_PLAYER_ACCEL
  jr c, .clamp
  cp a, e
  jr nc, .set
.clamp
  ld a, e
.set
  xor a, $80
  ld [hl], a
  ret

SetSimPlayerSpeed:;hl = player, de = sim player speed address
  call GetPlayerSpeed
  srl h
  rr l
  ld a, h
  and a
  jr nz, .max
  ld a, l
  add a, SIM_PLAYER_MIN_SPEED
  jr c, .max
  cp a, SIM_PLAYER_MAX_SPEED+1
  jr c, .set
.max
  ld a, SIM_PLAYER_MAX_SPEED
.set
  ld [de], a
  ret

SetSimRunnerSpeed:;a = lineup order (1-9, 0 = no runner), de = sim player speed address
  and a
  ret z
  dec a
  ld b, a
  push de
  call IsUserFielding
  ld a, b
  jr nz, .opponentIsBatting
  call GetUserPlayerInLineup
  jr .setSpeed
.opponentIsBatting
  call GetOpposingPlayerInLineup
.setSpeed
  pop de
  jr SetSimPlayerSpeed

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

.setSpeeds
  call CurrentOrderInLineup
  inc a
  ld de, SimRunner0.speed
  call SetSimRunnerSpeed
  ld a, [runners_on_base]
  and a, $0F
  ld de, SimRunner1.speed
  call SetSimRunnerSpeed
  ld a, [runners_on_base]
  swap a
  and a, $0F
  ld de, SimRunner2.speed
  call SetSimRunnerSpeed
  ld a, [runners_on_base+1]
  and a, $0F
  ld de, SimRunner3.speed
  call SetSimRunnerSpeed

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

  ld de, SimFielder1.speed
  ld a, PITCHER
.setSpeeds
    push af;position
    push de;sim player speed address
    call GetFielderByPosition
    pop de;sim player speed address
    call SetSimPlayerSpeed
    ld hl, SIM_PLAYER_SIZE
    add hl, de
    ld d, h
    ld e, l
    pop af;position
    inc a
    cp a, RIGHT_FIELDER+1
    jr nz, .setSpeeds
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