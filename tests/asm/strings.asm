; EQUS, string functions, {} interpolation, PURGE, and a macro defined from a string
DEF NAME EQUS "FatPak"
DEF LIST EQUS "4,9,2"
DEF DOTS EQUS STRRPL("1.2.3", ".", ",")
DEF JOIN EQUS STRCAT("ab", "cd", "{NAME}")
DEF UP EQUS STRUPR("mixed Case")
DEF LOWER EQUS STRLWR("MIXED Case")
DEF PART EQUS STRSLICE("hello", 1, 3)
DEF TAIL EQUS STRSLICE("hello", -2)
DEF OLD EQUS STRSUB("hello", 2, 3)
DEF COUNT EQU 42
DEF NEG EQU -5
REDEF NAME EQUS "{NAME}!"
DEF OPCODE EQUS "ld a, 7"
DEF CHECK EQUS """MACRO checked
    IF \\1 != \\2
        FAIL "mismatch \\1 \\2"
    ENDC
    db \\1 + \\2
ENDM"""

MACRO make_label ; \1 name, \2 value
\1_{d:COUNT}: db \2
ENDM

SECTION "Strings", ROM0[$150]
Start:
  db "{NAME}", 0
  db LIST
  db DOTS
  db "{JOIN}|{UP}|{LOWER}|{PART}|{TAIL}|{OLD}"
  db STRCAT("<", "{NAME}", ">")
  db STRLEN("hello"), STRLEN("{NAME}"), STRCMP("a", "b"), STRCMP("b", "a"), STRCMP("x", "x")
  db STRFIND("hello", "l"), STRRFIND("hello", "l"), STRFIND("hello", "z")
  db "{COUNT}|{d:COUNT}|{x:COUNT}|{X:COUNT}|{b:COUNT}|{o:COUNT}|{#x:COUNT}|{#b:COUNT}|{05d:COUNT}|{5d:COUNT}|{d:NEG}"
  OPCODE
  CHECK
  checked 3, 3
  make_label Thing, 5
  db LOW(Thing_42), "a\\b"
PURGE CHECK, checked, OPCODE
DEF CHECK EQUS "nop"
  CHECK
  db DEF(OPCODE), DEF(CHECK)
