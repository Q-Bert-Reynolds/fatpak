; 32-bit values: arithmetic, constants, dl, fixed point, FOR and {} formats, like RGBDS

MACRO D24 ; beisbol's
  DB (\1 & $FF0000) >> 16
  DB (\1 & $00FF00) >> 8
  DB (\1 & $0000FF)
ENDM
MACRO D32
  DB (\1 & $FF000000) >> 24
  DB (\1 & $00FF0000) >> 16
  DB (\1 & $0000FF00) >> 8
  DB (\1 & $000000FF)
ENDM

DEF BIG EQU 1234567
DEF NEG EQU -100000
DEF MAX EQU $7FFFFFFF
DEF MIN EQU $80000000
DEF COUNT = 70000
DEF COUNT = COUNT + 70000
REDEF COUNT = COUNT * 3

SECTION "values", ROM0[$150]
  D24 1000
  D24 250000
  D24 BIG
  D32 $DEADBEEF
  D32 NEG
  D32 MIN
  dl BIG, NEG, MAX, MIN, COUNT, MAX + 1, -MIN
  dl 100000 * 3, $12345678 * $9ABC, BIG * -7
  ; division rounds down, % takes the divisor's sign
  dl -7 / 2, -7 % 2, 7 / -2, 7 % -2, -8 / 2, -8 % 2, -7 / -2, -7 % -2
  dl MIN / -1, MIN % -1, BIG / 1000, BIG % 1000, 4000000000 / 3
  ; shifts: arithmetic right, 32 or more, negative counts
  dl MIN >> 24, $FF000000 >> 24, 1 << 31, 1 << 32, 5 >> 40, -5 >> 40, 1 << -1, 8 >> -1
  dl ~0, ~MIN, -1 ^ $FFFF0000, $F0F0F0F0 & $FF00FF00, $0F000000 | $F0
  ; signed comparisons
  db -1 < 1, MIN < 0, MAX > MIN, NEG <= NEG, BIG >= 1234568, BIG == 1234567, NEG != -100000
  db HIGH($123456), LOW($123456), HIGH(NEG), LOW(BIG)
  ; fixed point: 16.16, rounded
  dl 1.25, 1.5, 0.1, 3.14159, 2.000001, 0.99999, 0.9999999, 12345.678
  ; truncated operands still fit
  ld a, (BIG >> 16) & $FF
  ld hl, BIG & $FFFF
  ld bc, -1
  db -128, 255
  dw -32768, 65535
IF BIG > 65536
  db 1
ELSE
  db 0
ENDC
  ASSERT BIG == 1234567 && COUNT == 420000
  ASSERT (BIG >> 16) == 18

; FOR over 32-bit ranges
FOR V, 100000, 100003
  dl V
ENDR
  dl V
FOR V, -70000, -70006, -2
  dl V
ENDR
  dl V

; {} formats of 32-bit values
DEF FX EQUS "{BIG}"
DEF FY EQUS "{d:NEG}"
DEF FZ EQUS "{u:NEG}"
DEF FW EQUS "{x:MIN}"
DEF FB EQUS "{b:MAX}"
DEF FO EQUS "{#o:BIG}"
DEF FP EQUS "{012d:NEG}"
  db "{FX} {FY} {FZ} {FW} {FB} {FO} {FP}"
  dl STRLEN("{FB}")

; labels stay 16 bits; their arithmetic is 32
Here:
  dl Here + $10000, Here - $10000, (Here << 8) >> 8
