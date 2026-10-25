DEF BALL_POS_STEPS EQU 5

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

CalculateLandingSpot2:
  ld d, 0
  ld a, [ball_vel_z]
  sla a
  ld e, a
  jr nc, .skip
  ld d, 1
.skip;hang time = de

  ld a, BALL_POS_STEPS
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
    ld a, BALL_POS_STEPS
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