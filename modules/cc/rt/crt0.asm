; CC start-up (notes/COMPILER.md): vectors, header, stack, cleared WRAM, initialized data,
; then main. Link this unit first and crtend.asm last: initialized data is a list of
; records in the "cc_init" fragments between them (DW dest, end; the bytes up to end),
; ended by crtend's DW 0.
; Interrupts stay disabled; vectors return at once. main's int result goes to cc_exit and
; cc_done becomes $A5, then the CPU halts.

SECTION "cc_vectors", ROM0[$0040]
	reti ; VBlank
	ds 7, 0
	reti ; STAT
	ds 7, 0
	reti ; timer
	ds 7, 0
	reti ; serial
	ds 7, 0
	reti ; joypad

SECTION "cc_header", ROM0[$0100]
	nop
	jp __cc_start
	ds $150 - @, 0

SECTION "cc_start", ROM0
__cc_start:
	di
	ld sp, $E000
	ld hl, $C000 ; clear WRAM (the stack is at its top, unused so far)
	ld bc, $2000
.clear:
	xor a
	ld [hl+], a
	dec bc
	ld a, b
	or a, c
	jr nz, .clear
	ld hl, __cc_init_start
.record:
	ld a, [hl+]
	ld e, a
	ld a, [hl+]
	ld d, a
	or a, e
	jr z, .main
	ld a, [hl+]
	ld c, a
	ld a, [hl+]
	ld b, a
.copy:
	ld a, l
	cp a, c
	jr nz, .byte
	ld a, h
	cp a, b
	jr z, .record
.byte:
	ld a, [hl+]
	ld [de], a
	inc de
	jr .copy
.main:
	call _main
	ld a, c
	ld [_cc_exit], a
	ld a, b
	ld [_cc_exit + 1], a
	ld a, $A5
	ld [_cc_done], a
.halt:
	halt
	nop
	jr .halt

SECTION FRAGMENT "cc_init", ROM0
__cc_init_start:

SECTION "cc_state", WRAM0
_cc_exit:: ds 2
_cc_done:: ds 1
