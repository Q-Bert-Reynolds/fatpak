; header, data directives, expressions, locals, sections and banks
DEF SIZE EQU 4 * 3 + 2        ; 14
DEF MASK = %1010_0101
REDEF MASK = MASK | $0F
DEF OLD EQU $1234
DEF VAR = 3
REDEF VAR = VAR + 1
EXPORT Start

SECTION "Header", ROM0[$100]
  nop
  jp Start
  ds $150 - @, 0

SECTION "Main", ROM0[$150]
Start::
  ld sp, $FFFE
  ld hl, Table
  ld a, HIGH(Table)
  ld a, LOW(Table)
  ld b, SIZE
  ld c, MASK & $FF
  ld de, OLD
  ld a, VAR
  ld a, 'A'
  ld a, '\n'
  ld a, -SIZE
  ld a, ~1
  ld a, !0
  ld a, 7 % 3 + 2 << 2
  ld a, (1 + 2) * 3
  ld a, 1 == 1
  ld a, 2 != 1
  ld a, 1 < 2
  ld a, 3 >= 3
  ld a, 1 && 0
  ld a, 1 || 0
  ld a, $FF >> 4
  ld a, 6 ^ 3
  ld a, 1 <= 2
  ld a, 4 > 2
  ld hl, &17
.loop
  dec b
  jr nz, .loop
  ld a, BANK(Far)
  ld a, BANK(@)
  ld hl, Far
  ld a, [wCounter]
  ldh a, [hFlag]
  ld hl, Table.second
  call Other
.done:
  jr .done

Other:
.loop:
  inc a
  jr nz, .loop
  ret

Table:
  db 1, 2, 3, "Hi\"there\\", 0
.second:
  dw $1234, Start, Table.second - Table
  ds 3
  ds 2, $AA
  db $FF
  db -1
  DB "x"

SECTION "Bank one", ROMX, BANK[1]
Far:
  ld a, 1
  ld hl, FarData
FarData:
  db 42
  ds 16, 1

SECTION "Bank two", ROMX[$4100], BANK[2]
  db "two"
  dw Far, FarData

SECTION "Vars", WRAM0[$C000]
wCounter: db
wPair: dw
wBuffer: ds 16
wEnd:

SECTION "High", HRAM
hFlag: db
hOther: ds 2

SECTION "Tail", ROM0[$3F00]
  dw wEnd, hOther
