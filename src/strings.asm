IF !DEF(STRINGS_ASM)
DEF STRINGS_ASM EQU 1

INCLUDE "src/math.asm"

SECTION "PutNumber dest", HRAM
put_dest: DS 2

SECTION "Strings Code", ROM0
; char* PutNumber(char* dest, unsigned long n): n's decimal digits at dest, without a
; terminator; returns the address after them. dest in de, n on the stack (popped here).
; The digits come out lowest first, so they go on the stack above a 0 and are popped in order.
_PutNumber::
  ld a, e
  ldh [put_dest], a
  ld a, d
  ldh [put_dest+1], a
  ld hl, sp+2
  ld a, [hl+]
  ld c, a
  ld a, [hl+]
  ld b, a
  ld a, [hl+]
  ld e, a
  ld d, [hl]
  ld h, b
  ld l, c;dehl = n
  xor a
  push af;the end mark: digits are never 0
.digit
  ld c, 10
  call math_Divide32
  add a, 48;'0'
  push af
  ld a, d
  or a, e
  or a, h
  or a, l
  jr nz, .digit
  ldh a, [put_dest]
  ld c, a
  ldh a, [put_dest+1]
  ld b, a
.store
  pop af
  or a, a
  jr z, .done
  ld [bc], a
  inc bc
  jr .store
.done
  pop hl
  add sp, 4
  jp hl

ENDC ;STRINGS_ASM
