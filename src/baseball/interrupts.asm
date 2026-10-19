
MoveCoach:
  xor a
  ldh [rLYC], a

  ld a, [_x]
  ld b, a
  xor a
  sub a, b
  ldh [rSCX], a; SCX_REG = 256-x;
  
  xor a
  ld [_j], a
.rowLoop; for (j = 0; j < 3; ++j) {
    xor a
    ld [_i], a
.columnLoop;for (i = 0; i < _CALVIN_BACK_2X_COLUMNS-1; ++i) {
      ld a, [_j]
      ld de, (_CALVIN_BACK_2X_COLUMNS-1)
      rst math_Multiply ;hl = j*(_CALVIN_BACK_2X_COLUMNS-1)
      ld a, [_i]
      add a, l
      ld c, a ;c = j*(_CALVIN_BACK_2X_COLUMNS-1)+i

      ld a, [_i]
      add a, a;i*2
      add a, a;i*4
      add a, a;i*8
      add a, 16;i*8+16
      ld b, a
      ld a, [_x]
      add a, b;i*8+x+16
      ld d, a;x = i*8+x+16

      ld a, [_j]
      add a, a;j*2
      add a, a;j*4
      add a, a;j*8
      add a, 56;i*8+56
      ld e, a;y = j*8+56
      call gbdk_MoveSprite;move_sprite(j*(_CALVIN_BACK_2X_COLUMNS-1)+i, i*8+x+16, j*8+56);

      ld a, [_i]
      inc a
      ld [_i], a
      cp (_CALVIN_BACK_2X_COLUMNS-1)
      jr nz, .columnLoop
    ld a, [_j]
    inc a
    ld [_j], a
    cp 3
    jr nz, .rowLoop
  ret

SlideInLCDInterrupt::
  ldh a, [rLY]
  cp 56
  jr nc, .checkMoveCoach; if (LY_REG == 0){
    ld a, 56
    ldh [rLYC], a
    ld a, [_x]
    ldh [rSCX], a
    ret
.checkMoveCoach; else if (LY_REG == 56) move_coach();
  ret nz
  call MoveCoach
  ret

SlideOutLCDInterrupt::
  ldh a, [rLY]
  cp 56
  jr nc, .checkMoveCoach; if (LY_REG == 0){
    ld a, 56
    ldh [rLYC], a
    xor a
    ldh [rSCX], a
    ret
.checkMoveCoach; else if (LY_REG == 56) move_coach();
  ret nz
  call MoveCoach
  ret
