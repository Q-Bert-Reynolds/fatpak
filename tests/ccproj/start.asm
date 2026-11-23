; the C project test's start-up: the game's own, in assembly. C needs zeroed WRAM and _cc_init
; (cchead.asm) before it runs; main's result goes where tests/test_cc_build.cpp's RunROM reads it.
SECTION "result", WRAM0[$C000]
	ds 3

SECTION "header", ROM0[$0100]
	nop
	jp Start
	ds $150 - @, 0

SECTION "start", ROM0
Start:
	di
	ld sp, $E000
	ld hl, $C000
	ld bc, $2000
.clear:
	xor a
	ld [hl+], a
	dec bc
	ld a, b
	or a, c
	jr nz, .clear
	call _cc_init
	call _main
	ld a, c
	ld [$C000], a
	ld a, b
	ld [$C001], a
	ld a, $A5
	ld [$C002], a
.halt:
	halt
	nop
	jr .halt

; a C unit's assembly included, not listed (BUILD compiles inc.c again when it's newer)
INCLUDE "_inc.asm"

SECTION "twice", ROM0
; int twice(int x), for C: SDCC's convention, x in de and the result in bc
_twice::
	ld h, d
	ld l, e
	add hl, hl
	ld b, h
	ld c, l
	ret
