; Arithmetic retained from math.asm by Nolan Baker.
; Only the multiply RST/shift helper and division used by strings.asm are linked.
IF !DEF(MATH_ASM)
DEF MATH_ASM EQU 1

MACRO rev_Check_math_asm
  IF \1 > 1
    WARN "Version \1 or later of 'math.asm' is required."
  ENDC
ENDM

SECTION "math_Multiply RST", ROM0[$0020]
math_Multiply:: ; hl = de * a where 0 <= a <= 255
  ld hl, 0
  and a
  ret z
  cp a, 16
  jp nc, math_ShiftMultiply
.loop
    add hl, de
    dec a
    jr nz, .loop
  ret

SECTION "Math Code", ROM0
math_ShiftMultiply: ; hl = de * a where 16 <= a <= 255, hl = 0
  add a, a
  jr nc, .skipMSB
  add hl, de
.skipMSB:
REPT 7
  add hl, hl
  add a, a
  jr nc, .skip\@
  add hl, de
.skip\@:
ENDR
  ret

math_Divide32:: ;dehl (remainder a) = dehl / c
  xor	a
  ld	b, 32
.loop:
    add	hl, hl
    rl e
    rl d
    rla
    jr c, .skip
    cp c
    jr c, .skip
    sub	c
    inc	l
  .skip
    dec b
    jr nz, .loop
  ret

ENDC
