DEF BALL_POS_STEPS EQU 10
DEF SIM_BALL_ORIGIN_X EQU 4
DEF SIM_BALL_ORIGIN_Y EQU 4
DEF ROLL_VEL_Z        EQU 4 ;bounces slower than this roll instead

InitBall:;a = ball speed b = spray angle c = launch angle
  ld d, 0
  ld e, a
  push de;speed
  push bc;angles

  ; put ball in front of home plate
  ld a, HOME_PLATE_X+4
  ld [ball_pos_x], a
  ld a, HOME_PLATE_Y+8
  ld [ball_pos_y], a
  ld a, 1
  ld [ball_pos_z], a
  ld a, BALL_STATE_IN_PLAY
  ld [ball_state], a

  xor a
  ld [ball_pos_x+1], a
  ld [ball_pos_y+1], a
  ld [ball_pos_z+1], a
  ld [sim_throw_target], a

.calcZVelocity;z = a * sin(c)
  pop bc;spray,launch
  pop de;speed
  push de;speed
  push bc;spray,launch
  push de;speed

  ld a, c
  call math_Sin127
  pop de;speed
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
  pop de;speed
  call math_SignedMultiply;hl = forward = speed*cos(launch)*127 = de*cos(c)*127
  ld a, h
  ld l, a
  add a, a
  sbc a, a
  ld h, a

.calcXVelocity;TODO: x = forward * cos(45-b)
  pop bc;angles
  push bc;angles
  push hl;forward

  ld a, 45
  sub a, b
  call math_Cos127
  pop de;forward
  push de;forward
  call math_SignedMultiply;hl = x speed * 127
  ld a, h
  ld [ball_vel_x], a
  
.calcYVelocity;TODO: y = forward * sin(45-b)
  pop hl;forward
  pop bc;angles
  push hl;forward

  ld a, 45
  sub a, b
  call math_Sin127
  pop de;forward
  call math_SignedMultiply;hl = y speed * 127
  ld a, h
  cpl
  inc a
  ld [ball_vel_y], a
  ret

CalculateLandingSpot:; returns landing xy in de
  ld a, [ball_vel_z]
  dec a
  bit 7, a
  jr nz, CalculateRollingStop
  inc a
  ld d, 0
  sla a
  ld e, a
  ld a, BALL_POS_STEPS
  rst math_Multiply
  ld d, h
  ld e, l
  push de;hang time * steps
  ld a, [ball_pos_x]
  ld b, a
  ld a, [ball_vel_x]
  call LandingOnAxis
  pop de;hang time * steps
  push af;landing x
  ld a, [ball_pos_y]
  ld b, a
  ld a, [ball_vel_y]
  call LandingOnAxis
  ld e, a;landing y
  pop af;landing x
  ld d, a
  ret

CalculateRollingStop:; returns xy where the ball stops rolling in de
  ld a, [ball_pos_x]
  ld b, a
  ld a, [ball_vel_x]
  call RollOnAxis
  push af;landing x
  ld a, [ball_pos_y]
  ld b, a
  ld a, [ball_vel_y]
  call RollOnAxis
  ld e, a;landing y
  pop af;landing x
  ld d, a
  ret

RollOnAxis:;a = signed velocity, b = position, returns position where the ball stops rolling in a
  ld c, a
  call math_Abs
  inc a
  ld de, BALL_POS_STEPS
  rst math_Multiply;friction slows the ball by 1 every 2 frames, so it travels 10*v*(v+1)
  ld d, h
  ld e, l
  ld a, c
  ;fall through to LandingOnAxis

LandingOnAxis:;a = signed velocity, b = position, de = hang time * steps, returns landing position clamped to 0-255 in a
  ld c, a
  push bc;position, velocity
  call math_Abs
  ld h, 0
  ld l, a
  call math_Multiply16;bcde = distance in 1/256ths of a pixel
  ld a, b
  or a, c
  pop bc;position, velocity
  jr nz, .clamp;off the field
  ld a, b
  bit 7, c
  jr nz, .subtract
  add a, d
  ret nc
  ld a, 255
  ret
.subtract
  sub a, d
  ret nc
  xor a
  ret
.clamp
  bit 7, c
  ld a, 255
  ret z
  xor a
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
  add a, SIM_BALL_ORIGIN_Y
  ld [hli], a;y
  ldh a, [rSCX]
  ld b, a
  ld a, [ball_pos_x]
  sub a, b
  add a, SIM_BALL_ORIGIN_X
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
  add a, SIM_BALL_ORIGIN_Y
  inc a
  ld [hli], a
  ldh a, [rSCX]
  ld b, a
  ld a, [ball_pos_x]
  sub a, b
  add a, SIM_BALL_ORIGIN_X
  inc a
  ld [hli], a
  ld a, 16
  ld [hli], a
  xor a
  ld [hl], a
  ret

DampBounce:;hl = velocity, v -= v/8
  ld a, [hl]
  sra a
  sra a
  sra a
  ld b, a
  ld a, [hl]
  sub a, b
  ld [hl], a
  ret

ApplyFriction:;hl = velocity, moves it 1 toward 0
  ld a, [hl]
  and a
  ret z
  rla
  jr c, .negative
  dec [hl]
  ret
.negative
  inc [hl]
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
  ld a, BALL_POS_STEPS
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
    ld hl, ball_state
    set 6, [hl];BALL_STATE_LANDED
    xor a
    ld [ball_pos_z], a
    ld [ball_pos_z+1], a
    ld a, [ball_vel_z]
    cpl
    sra a;bounce back up at half speed
    cp a, ROLL_VEL_Z
    jr c, .roll
    ld [ball_vel_z], a
    ld hl, ball_vel_x
    call DampBounce
    ld hl, ball_vel_y
    call DampBounce
    jr .skip
  .roll
    xor a
    ld [ball_vel_z], a
    ld a, [sim_frame]
    rra
    jr nc, .skip
    ld hl, ball_vel_x
    call ApplyFriction
    ld hl, ball_vel_y
    call ApplyFriction
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
  jr nz, UpdateSimCamera
  xor a
  ld [ball_vel_y], a

UpdateSimCamera:
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