; CC in a project (project.gbp's main lines, notes/COMPILER.md): with C units that have initialized
; data, list this unit before the first and crtend.asm after the last. It heads the initialized
; data's records (the "cc_init" fragments, crt0.asm's format) that the C units add. The game's own
; start-up clears WRAM (C's zero-initialized data), then calls _cc_init once before any C runs.
; (Each unit carries the runtime's helpers it needs under its own names.)

SECTION "cc_init_copy", ROM0
_cc_init::
	ld hl, __cc_init_start
.record:
	ld a, [hl+]
	ld e, a
	ld a, [hl+]
	ld d, a
	or a, e
	ret z
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

SECTION FRAGMENT "cc_init", ROM0
__cc_init_start:
