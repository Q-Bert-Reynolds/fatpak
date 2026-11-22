; CC's runtime helpers. Every helper may change A, BC, DE, HL and the flags.
; 16-bit: left operand in DE, right in HL, result in HL.
; 32-bit: left operand on the stack above the return address (4 bytes, low byte first;
; the helper removes it), right in DEHL (DE high), result in DEHL. The comparisons return
; only flags: C if left < right, Z if equal. Shifts take the count in L.

SECTION "cc_runtime", ROM0

; HL = DE * HL
__cc_mul16::
	ld b, h
	ld c, l
	ld hl, 0
	ld a, 16
.loop:
	add hl, hl
	sla c
	rl b
	jr nc, .skip
	add hl, de
.skip:
	dec a
	jr nz, .loop
	ret

; DE / BC unsigned: DE = quotient, HL = remainder
__cc_divmodu16:
	ld hl, 0
	ld a, 16
.loop:
	push af
	sla e
	rl d
	rl l
	rl h
	jr c, .force ; 17 bits: certainly at least BC
	ld a, l
	sub a, c
	ld l, a
	ld a, h
	sbc a, b
	ld h, a
	jr nc, .fits
	add hl, bc
	jr .next
.force:
	ld a, l
	sub a, c
	ld l, a
	ld a, h
	sbc a, b
	ld h, a
.fits:
	inc e
.next:
	pop af
	dec a
	jr nz, .loop
	ret

__cc_divu16::
	ld b, h
	ld c, l
	call __cc_divmodu16
	ld h, d
	ld l, e
	ret

__cc_modu16::
	ld b, h
	ld c, l
	jp __cc_divmodu16

; signed: the quotient truncates toward zero, the remainder takes the dividend's sign
__cc_divs16::
	ld a, d
	xor a, h
	push af
	call __cc_abs16
	call __cc_divmodu16
	ld h, d
	ld l, e
	pop af
	bit 7, a
	ret z
	jr __cc_neg16

__cc_mods16::
	ld a, d
	push af
	call __cc_abs16
	call __cc_divmodu16
	pop af
	bit 7, a
	ret z
	; fall through
__cc_neg16: ; HL = -HL
	xor a
	sub a, l
	ld l, a
	sbc a, a
	sub a, h
	ld h, a
	ret

__cc_abs16: ; DE = |DE|, BC = |HL|
	bit 7, d
	jr z, .de
	xor a
	sub a, e
	ld e, a
	sbc a, a
	sub a, d
	ld d, a
.de:
	bit 7, h
	jr z, .hl
	call __cc_neg16
.hl:
	ld b, h
	ld c, l
	ret

; HL = DE << L, DE >> L
__cc_shl16::
	ld a, l
	ld h, d
	ld l, e
	or a, a
	ret z
.loop:
	add hl, hl
	dec a
	jr nz, .loop
	ret

__cc_shru16::
	ld a, l
	ld h, d
	ld l, e
	or a, a
	ret z
.loop:
	srl h
	rr l
	dec a
	jr nz, .loop
	ret

__cc_shrs16::
	ld a, l
	ld h, d
	ld l, e
	or a, a
	ret z
.loop:
	sra h
	rr l
	dec a
	jr nz, .loop
	ret

; calls the address in HL (indirect calls)
__cc_jphl::
	jp hl

; copies BC bytes from HL to DE
__cc_memcpy::
	ld a, b
	or a, c
	ret z
.loop:
	ld a, [hl+]
	ld [de], a
	inc de
	dec bc
	ld a, b
	or a, c
	jr nz, .loop
	ret

; ---- 32 bits ----

; returns, removing the 4-byte left operand
__cc_ret4:
	pop bc
	add sp, 4
	push bc
	ret

__cc_add32::
	ld b, h
	ld c, l
	ld hl, sp + 2
	ld a, [hl+]
	add a, c
	ld c, a
	ld a, [hl+]
	adc a, b
	ld b, a
	ld a, [hl+]
	adc a, e
	ld e, a
	ld a, [hl]
	adc a, d
	ld d, a
	ld h, b
	ld l, c
	jr __cc_ret4

__cc_sub32::
	ld b, h
	ld c, l
	ld hl, sp + 2
	ld a, [hl+]
	sub a, c
	ld c, a
	ld a, [hl+]
	sbc a, b
	ld b, a
	ld a, [hl+]
	sbc a, e
	ld e, a
	ld a, [hl]
	sbc a, d
	ld d, a
	ld h, b
	ld l, c
	jr __cc_ret4

__cc_and32::
	ld b, h
	ld c, l
	ld hl, sp + 2
	ld a, [hl+]
	and a, c
	ld c, a
	ld a, [hl+]
	and a, b
	ld b, a
	ld a, [hl+]
	and a, e
	ld e, a
	ld a, [hl]
	and a, d
	ld d, a
	ld h, b
	ld l, c
	jr __cc_ret4

__cc_or32::
	ld b, h
	ld c, l
	ld hl, sp + 2
	ld a, [hl+]
	or a, c
	ld c, a
	ld a, [hl+]
	or a, b
	ld b, a
	ld a, [hl+]
	or a, e
	ld e, a
	ld a, [hl]
	or a, d
	ld d, a
	ld h, b
	ld l, c
	jr __cc_ret4

__cc_xor32::
	ld b, h
	ld c, l
	ld hl, sp + 2
	ld a, [hl+]
	xor a, c
	ld c, a
	ld a, [hl+]
	xor a, b
	ld b, a
	ld a, [hl+]
	xor a, e
	ld e, a
	ld a, [hl]
	xor a, d
	ld d, a
	ld h, b
	ld l, c
	jr __cc_ret4

; DEHL = -DEHL (an ordinary call: nothing on the stack)
__cc_neg32::
	xor a
	sub a, l
	ld l, a
	ld a, 0
	sbc a, h
	ld h, a
	ld a, 0
	sbc a, e
	ld e, a
	ld a, 0
	sbc a, d
	ld d, a
	ret

; flags only; returns with pops, which keep them
__cc_cmps32::
	ld a, d ; compare signed as unsigned with both sign bits flipped
	xor a, $80
	ld d, a
	ld b, h
	ld c, l
	ld hl, sp + 5
	ld a, [hl]
	xor a, $80
	ld [hl], a
	ld h, b
	ld l, c
	; fall through
__cc_cmpu32::
	ld b, h
	ld c, l
	ld hl, sp + 2
	ld a, [hl+]
	sub a, c
	ld c, a
	ld a, [hl+]
	sbc a, b
	ld b, a
	ld a, [hl+]
	sbc a, e
	ld e, a
	ld a, [hl]
	sbc a, d
	ld d, a
	sbc a, a ; $FF if left < right
	ld h, a
	ld a, d
	or a, e
	or a, b
	or a, c
	jr z, .done ; equal: Z, NC
	ld a, h
	rla ; C if less; Z clear
.done:
	pop bc
	pop hl
	pop hl
	push bc
	ret

; DEHL = DE * BC (the full 32-bit product)
__cc_mul16x16:
	ld hl, 0
	ld a, 16
.loop:
	add hl, hl
	rl e
	rl d
	jr nc, .skip
	add hl, bc
	jr nc, .skip
	inc de
.skip:
	dec a
	jr nz, .loop
	ret

; a * b = aL*bL + ((aH*bL + aL*bH) << 16)
__cc_mul32::
	push de
	push hl ; sp+0 bL, sp+2 bH, sp+4 return, sp+6 aL, sp+8 aH
	ld hl, sp + 8
	ld a, [hl+]
	ld e, a
	ld d, [hl]
	pop bc
	push bc
	call __cc_mul16x16 ; aH * bL
	push hl ; sp+0 t, sp+2 bL, sp+4 bH, sp+6 return, sp+8 aL
	ld hl, sp + 8
	ld a, [hl+]
	ld e, a
	ld d, [hl]
	ld hl, sp + 4
	ld a, [hl+]
	ld c, a
	ld b, [hl]
	call __cc_mul16x16 ; aL * bH
	pop bc
	add hl, bc
	push hl ; sp+0 high word, sp+2 bL, sp+4 bH, sp+6 return, sp+8 aL
	ld hl, sp + 8
	ld a, [hl+]
	ld e, a
	ld d, [hl]
	ld hl, sp + 2
	ld a, [hl+]
	ld c, a
	ld b, [hl]
	call __cc_mul16x16 ; aL * bL
	pop bc
	ld a, e
	add a, c
	ld e, a
	ld a, d
	adc a, b
	ld d, a
	pop bc
	pop bc
	jp __cc_ret4

; Unsigned 32-bit division on a block above the return address: sp+2 dividend (becomes
; the quotient), sp+6 remainder (zero on entry), sp+10 divisor.
__cc_udivmod32:
	ld a, 32
.loop:
	push af ; the block is now at sp+4
	ld hl, sp + 4
	sla [hl] ; remainder:dividend <<= 1
	inc hl
	rl [hl]
	inc hl
	rl [hl]
	inc hl
	rl [hl]
	inc hl
	rl [hl]
	inc hl
	rl [hl]
	inc hl
	rl [hl]
	inc hl
	rl [hl] ; C: a bit left the remainder, so it is certainly at least the divisor
	dec hl
	dec hl
	dec hl
	ld b, [hl]
	inc hl
	ld c, [hl]
	inc hl
	ld d, [hl]
	inc hl
	ld e, [hl]
	inc hl ; the divisor; the flags are still the shift's
	jr c, .force
	ld a, b
	sub a, [hl]
	ld b, a
	inc hl
	ld a, c
	sbc a, [hl]
	ld c, a
	inc hl
	ld a, d
	sbc a, [hl]
	ld d, a
	inc hl
	ld a, e
	sbc a, [hl]
	ld e, a
	jr c, .next
	jr .store
.force:
	ld a, b
	sub a, [hl]
	ld b, a
	inc hl
	ld a, c
	sbc a, [hl]
	ld c, a
	inc hl
	ld a, d
	sbc a, [hl]
	ld d, a
	inc hl
	ld a, e
	sbc a, [hl]
	ld e, a
.store:
	ld hl, sp + 8
	ld [hl], b
	inc hl
	ld [hl], c
	inc hl
	ld [hl], d
	inc hl
	ld [hl], e
	ld hl, sp + 4
	set 0, [hl]
.next:
	pop af
	dec a
	jr nz, .loop
	ret

__cc_udiv32_setup: ; called by divu32/modu32 with its left operand at sp+4 and the divisor in DEHL
	; builds the block below the caller's frame and runs the division
	pop bc ; this return
	push de
	push hl ; divisor
	ld hl, 0
	push hl
	push hl ; remainder
	ld hl, sp + 12 ; the left operand's high word (sp+8 return of divu32, sp+10 left)
	ld a, [hl+]
	ld h, [hl]
	ld l, a
	push hl
	ld hl, sp + 12 ; its low word
	ld a, [hl+]
	ld h, [hl]
	ld l, a
	push hl
	push bc
	jp __cc_udivmod32 ; returns to divu32 with the block at sp+0

__cc_divu32::
	call __cc_udiv32_setup
	pop hl
	pop de
	add sp, 8
	jp __cc_ret4

__cc_modu32::
	call __cc_udiv32_setup
	add sp, 4
	pop hl
	pop de
	add sp, 4
	jp __cc_ret4

; signed: A bit 7 = the result's sign, bit 0 = modulo
__cc_divs32::
	push de
	push hl ; R at sp+0, return sp+4, L sp+6
	ld hl, sp + 9
	ld a, [hl]
	ld hl, sp + 3
	xor a, [hl] ; the quotient's sign
	and a, $80
	jr __cc_sdiv32

__cc_mods32::
	push de
	push hl
	ld hl, sp + 9
	ld a, [hl] ; the remainder's sign is the dividend's
	and a, $80
	or a, 1
	; fall through
__cc_sdiv32:
	pop hl
	pop de ; DEHL = R
	push af ; A at sp+1, return sp+2, L sp+4
	bit 7, d
	call nz, __cc_neg32
	push de
	push hl ; |R| at sp+0, A sp+5, return sp+6, L sp+8
	ld hl, sp + 8
	ld a, [hl+]
	ld c, a
	ld a, [hl+]
	ld b, a
	ld a, [hl+]
	ld e, a
	ld d, [hl]
	ld h, b
	ld l, c
	bit 7, d
	call nz, __cc_neg32
	push de
	push hl ; |L| at sp+0, |R| sp+4, A sp+9, return sp+10, L sp+12
	ld hl, sp + 4
	ld a, [hl+]
	ld c, a
	ld a, [hl+]
	ld b, a
	ld a, [hl+]
	ld e, a
	ld d, [hl]
	ld hl, sp + 9
	bit 0, [hl]
	ld h, b
	ld l, c ; DEHL = |R|
	jr nz, .mod
	call __cc_divu32 ; removes |L|
	jr .sign
.mod:
	call __cc_modu32
.sign: ; |R| at sp+0, A sp+5, return sp+6
	add sp, 4
	pop af
	bit 7, a
	call nz, __cc_neg32
	jp __cc_ret4

; DEHL = left << L, >> L (count in L; 32 or more gives 0, or -1 for a negative signed value)
__cc_shift32_load: ; A = count; DEHL = the left operand at sp+4 (above two returns)
	ld a, l
	ld hl, sp + 4
	ld c, [hl]
	inc hl
	ld b, [hl]
	inc hl
	ld e, [hl]
	inc hl
	ld d, [hl]
	ld h, b
	ld l, c
	or a, a
	ret

__cc_shl32::
	call __cc_shift32_load
	jr z, .done
.loop:
	add hl, hl
	rl e
	rl d
	dec a
	jr nz, .loop
.done:
	jp __cc_ret4

__cc_shru32::
	call __cc_shift32_load
	jr z, .done
.loop:
	srl d
	rr e
	rr h
	rr l
	dec a
	jr nz, .loop
.done:
	jp __cc_ret4

__cc_shrs32::
	call __cc_shift32_load
	jr z, .done
.loop:
	sra d
	rr e
	rr h
	rr l
	dec a
	jr nz, .loop
.done:
	jp __cc_ret4
