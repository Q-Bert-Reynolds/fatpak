; Deselect both P1 groups, then rotate to controller 1. Leaves P1=$30. The ID is read a few times after each
; select: right after the write P1 can still show the last group's buttons, $F with none pressed, which stopped
; it on the mouse's controller (its bytes then read as buttons: Start, Select, ...)
SNESMouseSelectOne:
  ld a, $30
  ldh [rP1], a
.loop
REPT 4
  ldh a, [rP1]
ENDR
  and 15
  cp 15
  ret z
  ld a, $10
  ldh [rP1], a
  ld a, $30
  ldh [rP1], a
  jr .loop
