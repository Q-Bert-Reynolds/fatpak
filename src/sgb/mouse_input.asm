; Read the SNES bridge mailbox. B/E = before/after commit, C = X, D = Y.
SNESMouseRead:
  call SGBInputBegin; protect P1 without missing the LCD's raster interrupts
  push af
  call SNESMouseSelectOne
  call .next
  call .read
  ld b, a
  call .next
  call .read
  ld c, a
  call .next
  call .read
  ld d, a
  call .next
  call .next
  call .read
  ld e, a
  call .next
  call .next
  call .next
  pop af
  jp SGBInputEnd
.next
  ld a, $10
  ldh [rP1], a
  ld a, $30
  ldh [rP1], a
  ret
.read
  ld a, $20
  ldh [rP1], a
REPT 6
  ldh a, [rP1]
ENDR
  and 15
  ld h, a
  ld a, $10
  ldh [rP1], a
REPT 6
  ldh a, [rP1]
ENDR
  and 15
  swap a
  or h
  ret

