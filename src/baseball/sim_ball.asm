DEF BALL_POS_STEPS EQU 10
DEF SIM_BALL_ORIGIN_X EQU 4
DEF SIM_BALL_ORIGIN_Y EQU 4

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
  ld d, 0
  ld a, [ball_vel_z]
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