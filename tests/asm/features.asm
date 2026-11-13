; includes, conditionals, macros, repeats, RS counters, indented labels and fixed point
INCLUDE "lib/util.inc"
INCLUDE "./lib/data.inc" ; a leading ./ (FatFs has no relative names; it is dropped)
INCLUDE "lib/data.inc"

DEF VERSION EQU 1.5
DEF FEATURE = 2
IF FEATURE == 1
  DEF MODE EQU 10
ELIF FEATURE == 2
  DEF MODE EQU 20
ELSE
  DEF MODE EQU 30
ENDC
IF DEF(MISSING)
  FAIL "MISSING is not defined"
ENDC
ASSERT MODE == 20, "mode"
WARN "just a warning"

SECTION "Header", ROM0[$100]
  nop
  jp Start
  ds $150 - @, 0

SECTION "Main", ROM0[$150]
Start:
  LD_IMM a, SCREEN_W - SCREEN_H
  LD_IMM hl, DATA_MAGIC
  LD_IMM b, OBJ_FLAGS + OBJ_SIZE * 16
  ld c, RS_END
  ld d, PAIR
  ld e, QUAD
  WAIT_VBLANK
  WAIT_VBLANK
  ld b, 3
  COUNTDOWN b, STEP
  ld a, 0
  ADD_ALL b, c, d
  ld a, MODE
  ld a, VERSION > 1.25
  ld a, VERSION == 1.5
REPT 3
  inc hl
ENDR
REPT 2
.r\@
  dec hl
  jr nz, .r\@
ENDR
  IF 0
  nop
  IF 1
  halt
  ENDC
  ELSE
  stop
  ENDC
Table:
REPT 4
  db @ - Table
ENDR
  Indented: nop
  .inner: inc a
  .bare
  jr .inner
  db "done", 0
