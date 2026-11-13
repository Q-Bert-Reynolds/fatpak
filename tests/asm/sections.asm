; sections: FRAGMENT, PUSHS/POPS, DS ALIGN and ALIGN offsets; the table at $3F00 holds
; every label's address and bank, so the ROM differs wherever placement does

SECTION "code", ROM0[$150]
Outer:
.a: nop
PUSHS
SECTION "vars", WRAM0
Var: db
.inner: db
PUSHS "more vars", WRAMX, BANK[2]
Deep: ds 3
POPS
.after: db ; Var.after
POPS
.b: nop ; Outer.b: the scope came back
PUSHS "pushed code", ROMX
Pushed: db 1, 2, 3
POPS
  ld a, 1

; fragments join in source order, wherever they are
SECTION FRAGMENT "frag", ROM0
Frag1: db $F1
SECTION "between", ROM0
  db 2
SECTION FRAGMENT "frag", ROM0
Frag2: db $F2, $F3
SECTION "between 2", ROM0
  db 4
PUSHS FRAGMENT "frag", ROM0
Frag3: db $F4
POPS
  db 3 ; still "between 2"
SECTION FRAGMENT "banked", ROMX, BANK[3]
Banked1: ds 5, 5
SECTION FRAGMENT "banked", ROMX
Banked2: db 6

; DS ALIGN in a floating section: no padding, the section takes the alignment
SECTION "unaligned", ROMX
  ds 5, 1
DS ALIGN[8]
Aligned8: db 7

; in an aligned one: padding up to its alignment, then tighter
SECTION "aligned", ROMX, ALIGN[4, 3]
  ds 2, 2
DS ALIGN[6, 1], $EE
Aligned6: db 9
  ds 3, 4
DS ALIGN[2]
Aligned2: db 10

; at a fixed address: padding with the fill
SECTION "fixed", ROM0[$1000]
  db 1
DS ALIGN[4, 2], $FF
Fixed16: db 2
DS ALIGN[3]
Fixed8: db 3

; RAM: space, no fill
SECTION "ram", WRAM0, ALIGN[2]
  ds 3
DS ALIGN[4]
Ram16: ds 2

SECTION "offset", ROMX, ALIGN[5, 7]
Offset: db 11

SECTION "table", ROM0[$3F00]
  dw Outer, Outer.a, Outer.b, Var, Var.inner, Var.after, Deep, Pushed
  db BANK(Deep), BANK(Pushed)
  dw Frag1, Frag2, Frag3, Banked1, Banked2
  db BANK(Banked1), BANK(Banked2)
  dw Aligned8, Aligned6, Aligned2, Fixed16, Fixed8, Ram16, Offset
  db BANK(Aligned8), BANK(Aligned6), BANK(Offset)
