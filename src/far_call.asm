;Far calls for C split across ROM banks (see bank_split.py).
;A thunk saves a in [far_a] and the target in [far_target], then jumps here with the bank in a.
;The return address and caller's bank go on a WRAM stack instead of the CPU stack, so the
;callee sees its stack args where it expects them. a, bc, de args and returns are kept.

DEF FAR_CALL_DEPTH EQU 16

SECTION "Far Call Vars", WRAM0
far_stack: DS FAR_CALL_DEPTH*3;bank, return address
far_depth: DB
far_bank: DB
far_target:: DW
far_a:: DB
far_ret: DW

SECTION "Far Call", ROM0

;a = frame index, returns frame address in hl, only affects a
FarFrame:
  ld l, a
  add a, a
  add a, l;*3
  add a, LOW(far_stack)
  ld l, a
  ld a, HIGH(far_stack)
  adc a, 0
  ld h, a
  ret

FarCall::;a = bank, [far_target] = function, [far_a] = a arg
  ld [far_bank], a
  pop hl;return address
  ld a, l
  ld [far_ret], a
  ld a, h
  ld [far_ret+1], a
  ld a, [far_depth]
  inc a
  ld [far_depth], a
  dec a
  call FarFrame
  ldh a, [loaded_bank]
  ld [hli], a
  ld a, [far_ret]
  ld [hli], a
  ld a, [far_ret+1]
  ld [hl], a
  ld a, [far_bank]
  SET_BANK
  ld a, [far_target]
  ld l, a
  ld a, [far_target+1]
  ld h, a
  ld a, [far_a]
  call .jpHL
  ld [far_a], a
  ld a, [far_depth]
  dec a
  ld [far_depth], a
  call FarFrame
  ld a, [hli]
  SET_BANK
  ld a, [hli]
  ld h, [hl]
  ld l, a
  ld a, [far_a]
  jp hl
.jpHL
  jp hl
