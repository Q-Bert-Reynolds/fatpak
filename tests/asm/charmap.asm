; CHARMAP, NEWCHARMAP, SETCHARMAP, PUSHC and POPC: longest match, unmapped characters as
; themselves, several bytes for one entry, character literals, and maps built on others
NEWCHARMAP game
CHARMAP "<dots>", 10
CHARMAP "<do", 99
CHARMAP "A", 65 + 100
CHARMAP "AB", 200
CHARMAP "x", 1, 2, 3
CHARMAP "é", $E9
DEF WORD EQUS "AB"

SECTION "Charmap", ROM0[$150]
  db "A<dots>AB<do>xyz", 0
  db 'A', '<dots>', "{WORD}"
  ld a, 'B'
  cp 'A'
SETCHARMAP main
  db "A<dots>", 'A'
NEWCHARMAP other, game
CHARMAP "z", 26
  db "ABz"
SETCHARMAP game
  db "z"
PUSHC
SETCHARMAP main
  db "A"
POPC
  db "A", "é"
  db "\{\}", 0
CHARMAP "\{", 123
  db "\{"
