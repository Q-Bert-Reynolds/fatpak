; Deselect both P1 groups, then rotate to controller 1. Leaves P1=$30.
SNESMouseSelectOne:
  ld a, $30
  ldh [rP1], a
.loop
  ldh a, [rP1]
  and 15
  cp 15
  ret z
  ld a, $10
  ldh [rP1], a
  ld a, $30
  ldh [rP1], a
  jr .loop
