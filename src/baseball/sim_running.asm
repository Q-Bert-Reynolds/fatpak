;runner state
DEF RUNNER_OUT     EQU %10000000
DEF RUNNER_SCORED  EQU %01000000
DEF RUNNER_PRESENT EQU %00001000
DEF RUNNER_BASE    EQU %00000111 ;base the runner is on or heading to (1-4)

DEF ADVANCE_DIST_LOOSE EQU 120 ;runners take the next base if the ball is farther than this from it
DEF ADVANCE_DIST_HELD  EQU 200

PUSHS
SECTION "Simulation Running Vars", WRAM0
sim_runner_state: DS 4 ;batter, first, second, third
sim_runner_index: DB
sim_forced:       DB ;runners with index < sim_forced are forced
POPS

InitRunnerStates:
  ld a, RUNNER_PRESENT | 1
  ld [sim_runner_state], a
  ld a, [runners_on_base]
  and a, $0F
  ld b, 1
  call .getState
  ld [sim_runner_state+1], a
  ld a, [runners_on_base]
  swap a
  and a, $0F
  ld b, 2
  call .getState
  ld [sim_runner_state+2], a
  ld a, [runners_on_base+1]
  and a, $0F
  ld b, 3
  call .getState
  ld [sim_runner_state+3], a
  ret
.getState;a = lineup order, b = base, returns state in a
  and a
  ret z
  ld a, b
  or a, RUNNER_PRESENT
  ret

UpdateRunners:
.countForced;consecutive runners starting with the batter, none if the ball was caught
  ld b, 0
  ld a, [ball_state]
  and a, BALL_STATE_CAUGHT
  jr nz, .setForced
  ld hl, sim_runner_state
.countForcedLoop
    ld a, [hli]
    and a, RUNNER_PRESENT | RUNNER_OUT | RUNNER_SCORED
    cp a, RUNNER_PRESENT
    jr nz, .setForced
    inc b
    ld a, b
    cp a, 4
    jr nz, .countForcedLoop
.setForced
  ld a, b
  ld [sim_forced], a

  ld a, 3;lead runners first so they don't block trailing runners
.loop
    ld [sim_runner_index], a
    call UpdateRunner
    ld a, [sim_runner_index]
    dec a
    cp a, $FF
    jr nz, .loop
  ret

UpdateRunner:
  call GetRunnerStateAddress
  ld a, [hl]
  and a, RUNNER_PRESENT | RUNNER_OUT | RUNNER_SCORED
  cp a, RUNNER_PRESENT
  ret nz
  ld a, [sim_runner_index]
  and a
  jr nz, .checkArrived
  ld a, [ball_state]
  and a, BALL_STATE_CAUGHT
  jr nz, .out;batter flied out

.checkArrived
  call GetRunnerAddress
  call GetSimPlayerXY
  ld de, SimRunner0.dest_x - SimRunner0
  add hl, de
  ld a, [hli]
  cp a, b
  jr nz, .running
  ld a, [hl]
  cp a, c
  jr z, .arrived

.running;bc = runner xy
  ld a, [ball_state]
  and a, BALL_STATE_FIELDER
  ret z
  ld a, [ball_pos_x];held ball is in the fielder's glove
  ld d, a
  ld a, [ball_pos_y]
  ld e, a
.checkTagOut
  call ApproxDistance
  cp a, CATCH_RADIUS+1
  jr c, .out
.checkForceOut;fielder holding the ball is on the base a forced runner is heading to
  call IsRunnerForced
  ret nc
  call GetRunnerStateAddress
  ld a, [hl]
  and a, RUNNER_BASE
  ld b, a
  ld a, [sim_runner_index]
  inc a
  cp a, b
  ret nz
  call GetBasePosition;bc = base xy
  call ApproxDistance
  cp a, CATCH_RADIUS+1
  ret nc
.out
  call GetRunnerStateAddress
  set 7, [hl];RUNNER_OUT
  jr .remove
.scored
  set 6, [hl];RUNNER_SCORED
.remove
  call GetRunnerAddress
  inc hl
  inc hl;vel_y
  xor a
REPT SimRunner0.dest_y - SimRunner0.vel_y + 1;velocity, position, and destination
  ld [hli], a
ENDR
  ret

.arrived
  call GetRunnerStateAddress
  ld a, [hl]
  and a, RUNNER_BASE
  cp a, 4
  jr z, .scored
  ld b, a;base
.checkBall
  ld a, [ball_state]
  and a, BALL_STATE_FIELDER
  ld c, ADVANCE_DIST_HELD
  jr nz, .checkForced
  ld c, ADVANCE_DIST_LOOSE
  ld a, [sim_throw_target]
  and a
  jr nz, .checkForced
  ld a, [ball_state]
  and a, BALL_STATE_LANDED
  jr z, .hold;wait on the base until a fly ball lands or is caught
.checkForced
  call IsRunnerForced
  jr nc, .checkDistance
  ld a, [sim_runner_index]
  cp a, b
  jr z, .advance;forced off of the original base
.checkDistance;b = base, c = min distance from ball to the next base
  push bc
  ld a, b
  inc a
  call GetBasePosition
  ld d, b
  ld e, c;next base xy
  ld a, [ball_pos_x]
  ld b, a
  ld a, [ball_pos_y]
  ld c, a
  call ApproxDistance
  pop bc
  cp a, c
  jr c, .hold
  call IsNextBaseTaken
  jr nz, .hold
.advance
  call GetRunnerStateAddress
  inc [hl]
  inc b
.hold;b = base to run to
  call GetRunnerAddress
  ld a, b
  push hl;runner
  call GetBasePosition
  pop hl;runner
  ld de, SimRunner0.dest_x - SimRunner0
  add hl, de
  ld [hl], b
  inc hl
  ld [hl], c
  ret

IsRunnerForced:;returns carry if forced
  push hl
  ld hl, sim_forced
  ld a, [sim_runner_index]
  cp a, [hl]
  pop hl
  ret

IsNextBaseTaken:;b = base, returns nz if a runner ahead is on or heading to base b+1
  ld a, b
  inc a
  or a, RUNNER_PRESENT
  ld d, a;state of a runner on the next base
  ld a, [sim_runner_index]
.loop
    inc a
    cp a, 4
    jr z, .notTaken
    ld e, a
    call GetRunnerStateAddress.index
    ld a, [hl]
    cp a, d
    ld a, e
    jr nz, .loop
  or a, 1;nz
  ret
.notTaken
  xor a
  ret

GetRunnerStateAddress:;returns address of current runner's state in hl
  ld a, [sim_runner_index]
.index;a = runner index
  ld hl, sim_runner_state
  add a, l
  ld l, a
  adc a, h
  sub a, l
  ld h, a
  ret

GetRunnerAddress:;returns address of current runner in hl
  push de
  ld a, [sim_runner_index]
  ld de, SIM_PLAYER_SIZE
  rst math_Multiply
  ld de, SimRunner0
  add hl, de
  pop de
  ret

GetSimPlayerXY:;hl = sim player, returns xy in bc
  push hl
  ld bc, SimRunner0.pos_y - SimRunner0
  add hl, bc
  ld c, [hl]
  inc hl
  inc hl
  inc hl;pos_x
  ld b, [hl]
  pop hl
  ret

GetBasePosition:;a = base (1-4), returns xy in bc
  add a, a
  add a, LOW(BasePositions-2)
  ld c, a
  adc a, HIGH(BasePositions-2)
  sub a, c
  ld b, a
  ld a, [bc]
  inc bc
  push af
  ld a, [bc]
  ld c, a
  pop af
  ld b, a
  ret

ApproxDistance:;bc = xy, de = xy, returns max + min/2 in a
  push bc
  ld a, b
  sub a, d
  jr nc, .absX
  cpl
  inc a
.absX
  ld b, a
  ld a, c
  sub a, e
  jr nc, .absY
  cpl
  inc a
.absY
  cp a, b
  jr nc, .gotMax
  ld c, a
  ld a, b
  ld b, c
.gotMax
  srl b
  add a, b
  jr nc, .done
  ld a, 255
.done
  pop bc
  ret

AreRunnersRunning:;returns nz if any runner hasn't reached their destination
  ld hl, SimRunner0.pos_y
  ld c, 4
.loop
    push hl
    ld a, [hli];pos_y
    ld b, a
    inc hl
    inc hl
    ld a, [hli];pos_x
    inc hl
    cp a, [hl];dest_x
    jr nz, .running
    inc hl
    ld a, [hl];dest_y
    cp a, b
    jr nz, .running
    pop hl
    ld de, SIM_PLAYER_SIZE
    add hl, de
    dec c
    jr nz, .loop
  ret;z
.running
  pop hl
  ret;nz
