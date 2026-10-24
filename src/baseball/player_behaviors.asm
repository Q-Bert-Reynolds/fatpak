
; .player     DB ;upper nibble = team, lower nibble = lineup order
; .anim_state DB ;upper nibble = running/fielding/throwing, lower nibble = frame
; .vel_y      DB
; .pos_y      DW
; .vel_x      DB
; .pos_x      DW
; .dest_x     DB
; .dest_y     DB

SetSimPlayerDestination:;hl = sim player addres, de = xy
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

.setDestination
  ld a, d;x
  ld [hli], a;dest_x
  ld a, e;y
  ld [hli], a;dest_y

.calcDirection
  ld a, d
  sub a, b;dest_x - pos_x
  ld d, a
  ld a, e
  sub a, c;dest_y - pos_y
  ld e, a
  call math_Normalize
  
.setVelocity
  pop hl;address of vel_y
  ld [hl], e;vel_y
  inc hl
  inc hl
  inc hl
  ld [hl], d

  ret

