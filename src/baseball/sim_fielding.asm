DEF CATCH_RADIUS     EQU 4
DEF CATCH_HEIGHT     EQU 12
DEF HOLD_FRAMES      EQU 20 ;time to transfer the ball before throwing
DEF THROW_HEIGHT     EQU 8
DEF MIN_THROW_SPEED  EQU 16 ;added to throw stat / 4
DEF MAX_THROW_SPEED  EQU 63
DEF MAX_THROW_VEL_Z  EQU 40

PUSHS
SECTION "Simulation Fielding Vars", WRAM0
sim_chaser:       DB ;position that chases the ball after it lands
sim_throw_target: DB ;only this position can catch the ball, 0 = anyone
sim_hold_timer:   DB
POPS

UpdateBall:
  ld a, [ball_state]
  and a, BALL_STATE_FIELDER
  jr nz, HoldBall
  call SimulateBall
  call ChaseBall
  ;fall through to CheckCatch

CheckCatch:
  ld a, [ball_pos_z]
  cp a, CATCH_HEIGHT+1
  ret nc
  ld hl, SimFielder1.pos_y
  ld c, PITCHER
.loop
    ld a, [sim_throw_target]
    and a
    jr z, .checkY
    cp a, c
    jr nz, .next
  .checkY
    ld a, [ball_pos_y]
    sub a, [hl]
    jr nc, .absY
    cpl
    inc a
  .absY
    cp a, CATCH_RADIUS+1
    jr nc, .next
  .checkX
    inc hl
    inc hl
    inc hl;pos_x
    ld a, [ball_pos_x]
    sub a, [hl]
    dec hl
    dec hl
    dec hl;pos_y
    jr nc, .absX
    cpl
    inc a
  .absX
    cp a, CATCH_RADIUS+1
    jr c, .catch
  .next
    ld de, SIM_PLAYER_SIZE
    add hl, de
    inc c
    ld a, c
    cp a, RIGHT_FIELDER+1
    jr nz, .loop
  ret
.catch
  ld a, [sim_throw_target]
  and a
  ld a, [ball_state]
  jr nz, .setFielder;throws aren't fly outs
  bit 6, a;BALL_STATE_LANDED
  jr nz, .setFielder
  or a, BALL_STATE_CAUGHT
.setFielder
  or a, c
  ld [ball_state], a
  xor a
  ld [ball_vel_x], a
  ld [ball_vel_y], a
  ld [ball_vel_z], a
  ld a, HOLD_FRAMES
  ld [sim_hold_timer], a
  ret

ChaseBall:
  ld a, [ball_state]
  and a, BALL_STATE_LANDED
  ret z
  ld a, [ball_pos_x]
  ld d, a
  ld a, [ball_pos_y]
  ld e, a
  ld a, [sim_chaser]
  jp MoveFielderToPosition

HoldBall:;a = position holding the ball
  ld b, a
  dec a
  ld de, SIM_PLAYER_SIZE
  rst math_Multiply
  ld de, SimFielder1.pos_y
  add hl, de
  ld a, [hli]
  ld [ball_pos_y], a
  inc hl
  inc hl;pos_x
  ld a, [hl]
  ld [ball_pos_x], a
  xor a
  ld [ball_pos_x+1], a
  ld [ball_pos_y+1], a
  ld [ball_pos_z+1], a
  ld a, THROW_HEIGHT
  ld [ball_pos_z], a
  push bc;holder
  call UpdateSimCamera
  pop bc;holder

  ld hl, sim_hold_timer
  dec [hl]
  ret nz
  ld a, [ball_state]
  bit 7, a;BALL_STATE_CAUGHT
  jr nz, .endPlay;fly out
  ld a, [sim_throw_target]
  and a
  jr nz, .endPlay;TODO: relays, double plays

.chooseBase;TODO: move to C, consider runners, outs, and arm strength
  ld de, (FIRST_BASE_X << 8) | FIRST_BASE_Y
  ld a, b
  cp a, SHORTSTOP+1
  jr c, .getCoverer
  ld de, (SECOND_BASE_X << 8) | SECOND_BASE_Y
.getCoverer
  push bc;holder
  call GetBaseCoverer
  pop bc;holder
  jr z, .endPlay
  cp a, b
  jp nz, ThrowBall;holder isn't covering the base
.endPlay
  ld hl, ball_state
  res 4, [hl];BALL_STATE_IN_PLAY
  ret

GetBaseCoverer:;de = base xy, returns position in a and nz if found
  ld hl, SimFielder1.dest_x
  ld c, PITCHER
.loop
    ld a, [hli]
    cp a, d
    jr nz, .next
    ld a, [hl]
    cp a, e
    jr nz, .next
    ld a, c
    and a
    ret
  .next
    push de;base xy
    ld de, SIM_PLAYER_SIZE-1
    add hl, de
    pop de;base xy
    inc c
    ld a, c
    cp a, RIGHT_FIELDER+1
    jr nz, .loop
  xor a
  ret

ThrowBall:;a = target position, b = holder position
  ld [sim_throw_target], a
  ld [sim_chaser], a
  ld hl, ball_state
  ld a, [hl]
  and a, ~(BALL_STATE_FIELDER | BALL_STATE_LANDED)
  ld [hl], a

.getThrowSpeed;throw stat / 4 + MIN_THROW_SPEED
  ld a, b
  call GetFielderByPosition
  call GetPlayerThrow
  srl h
  rr l
  srl h
  rr l
  ld a, h
  and a
  jr nz, .maxSpeed
  ld a, l
  add a, MIN_THROW_SPEED
  jr c, .maxSpeed
  cp a, MAX_THROW_SPEED+1
  jr c, .gotSpeed
.maxSpeed
  ld a, MAX_THROW_SPEED
.gotSpeed
  push af;throw speed

.calcDelta;target's destination - ball, halved to fit in signed bytes
  ld a, [sim_throw_target]
  dec a
  ld de, SIM_PLAYER_SIZE
  rst math_Multiply
  ld de, SimFielder1.dest_x
  add hl, de
  ld a, [ball_pos_x]
  ld b, a
  ld a, [hli]
  sub a, b
  rra
  ld d, a
  ld a, [ball_pos_y]
  ld b, a
  ld a, [hl]
  sub a, b
  rra
  ld e, a
  push de;delta/2
  call math_SignedNormalize

.calcVelocity;velocity = speed * direction / 128
  pop hl;delta/2
  pop af;throw speed
  push hl;delta/2
  push af;throw speed
  ld h, d
  ld l, e;direction
  ld d, 0
  ld e, a;throw speed
  push hl;direction
  ld a, h
  call math_SignedMultiply
  add hl, hl
  ld a, h
  ld [ball_vel_x], a
  pop hl;direction
  ld a, l
  call math_SignedMultiply
  add hl, hl
  ld a, h
  ld [ball_vel_y], a

.calcVelocityZ;half the hang time = distance * 12.8 / speed
  pop bc;throw speed
  pop de;delta/2
  push bc;throw speed
  ld a, d
  call math_Abs
  ld d, a
  ld a, e
  call math_Abs
  ld e, a
  call math_Length
  ld de, 26
  rst math_Multiply
  pop bc;throw speed
  ld c, b
  call math_Divide16
  ld a, h
  and a
  jr nz, .maxVelocityZ
  ld a, l
  cp a, MAX_THROW_VEL_Z+1
  jr c, .setVelocityZ
.maxVelocityZ
  ld a, MAX_THROW_VEL_Z
.setVelocityZ
  ld [ball_vel_z], a
  ret
