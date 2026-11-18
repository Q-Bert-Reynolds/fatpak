// 32-bit arithmetic for ASM.MOD (asm_emit.c includes this) and LINK.MOD (link.c, with
// MATH_STATIC static): Apply, Div. Fail is the including module's.
#ifndef MATH_STATIC
#define MATH_STATIC
#endif

// --- arithmetic without helpers: values are 32 bits. On the device it's assembly (SDCC's
// long code is several times the size); the C is the PC harness's, checked against RGBDS.
// Apply follows RGBDS: / rounds toward minus infinity and % takes the divisor's sign; a
// negative shift goes the other way, and 32 or more leaves 0 (or -1).
MATH_STATIC UVal div_rem; // Div's remainder
#ifdef HOST_TEST
static UVal Mul(UVal a, UVal b) {
  UVal r = 0;
  while (b) {
    if (b & 1) r += a;
    a <<= 1;
    b >>= 1;
  }
  return r;
}
MATH_STATIC UVal Div(UVal a, UVal b) {
  UVal q = 0, r = 0, top;
  unsigned char i;
  for (i = 0; i < 32; ++i) {
    top = r >> 31; // r overflows past 32 bits only when b > 2^31: then it fits
    r = (r << 1) | (a >> 31);
    a <<= 1;
    q <<= 1;
    if (top || r >= b) { r -= b; q |= 1; }
  }
  div_rem = r;
  return q;
}
MATH_STATIC Val Apply(unsigned char o, Val a, Val b) {
  UVal q, ub;
  unsigned char differ;
  switch (o) {
    case '+': return (UVal)a + b;
    case '-': return (UVal)a - b;
    case '*': return Mul(a, b);
    case '/': case '%':
      if (!b) { Fail(ASM_ERR_DIVIDE); return 0; }
      ub = b < 0 ? 0 - (UVal)b : b;
      q = Div(a < 0 ? 0 - (UVal)a : a, ub);
      differ = (a < 0) != (b < 0);
      if (differ && div_rem) { div_rem = ub - div_rem; ++q; }
      if (o == '/') return differ ? 0 - q : q;
      return b < 0 ? 0 - div_rem : div_rem;
    case '&': return a & b;
    case '|': return a | b;
    case '^': return a ^ b;
    case 's': case 'r':
      if (b < 0) { b = 0 - (UVal)b; o ^= 's' ^ 'r'; }
      if (o == 's') return (UVal)b < 32 ? (UVal)a << b : 0;
      return a >> ((UVal)b < 32 ? b : 31);
    case '<': return a < b;
    case '>': return a > b;
    case 'l': return a <= b;
    case 'g': return a >= b;
    case 'E': return a == b;
    case 'N': return a != b;
    case 'A': return a && b;
    default: return a || b;
  }
}

#else
static UVal t[2]; // the work registers: Apply's operands (the result in the first), Div's dividend and divisor

// o in a, a and b on the stack (popped here), the result in debc
MATH_STATIC Val Apply(unsigned char o, Val a, Val b) __naked {
  o; a; b;
  __asm
	ld	c, a
	ld	hl, sp+2
	ld	de, _t
	ld	b, 8
.in:
	ld	a, [hl+]
	ld	[de], a
	inc	de
	dec	b
	jr	nz, .in
	ld	de, _t
	ld	hl, _t+4
	ld	a, c
	cp	a, $2B
	jr	z, .add
	cp	a, $2D
	jr	z, .sub
	cp	a, $26
	jr	z, .and
	cp	a, $7C
	jr	z, .or
	cp	a, $5E
	jr	z, .xor
	cp	a, $2A
	jr	z, .mul
	cp	a, $2F
	jr	z, .div
	cp	a, $25
	jr	z, .div
	cp	a, $73
	jr	z, .shift
	cp	a, $72
	jr	z, .shift
	cp	a, $41
	jr	z, .both
	cp	a, $4C
	jr	z, .either
; comparisons, signed: which of x < y, x == y, x > y (bits 0-2) make each one true
	ld	b, 1
	cp	a, $3C
	jr	z, .compare
	ld	b, 4
	cp	a, $3E
	jr	z, .compare
	ld	b, 3
	cp	a, $6C
	jr	z, .compare
	ld	b, 6
	cp	a, $67
	jr	z, .compare
	ld	b, 2
	cp	a, $45
	jr	z, .compare
	ld	b, 5
.compare:
	push	bc
	ld	a, [_t+7]
	xor	a, $80
	ld	c, a
	ld	a, [_t+3]
	xor	a, $80
	cp	a, c
	jr	nz, .ordered
	ld	hl, _t+2
	ld	de, _t+6
	ld	b, 3
.lower:
	ld	a, [de]
	ld	c, a
	ld	a, [hl-]
	cp	a, c
	jr	nz, .ordered
	dec	de
	dec	b
	jr	nz, .lower
.ordered:
	pop	bc
	ld	a, b
	jr	z, .equal
	jr	c, .bit
	rrca
.equal:
	rrca
.bit:
	and	a, 1
.bool:
	ld	hl, _t
	ld	[hl+], a
	xor	a, a
	ld	[hl+], a
	ld	[hl+], a
	ld	[hl], a
	jr	.done
.both:
	ld	hl, _t
	call	ArithZero
	jr	z, .bool
	call	ArithZero
	jr	z, .bool
.true:
	ld	a, 1
	jr	.bool
.either:
	ld	hl, _t
	call	ArithZero
	jr	nz, .true
	call	ArithZero
	jr	nz, .true
	jr	.bool
.add:
	call	ArithAdd
	jr	.done
.sub:
	call	ArithSub
	jr	.done
.and:
	ld	b, 4
.andl:
	ld	a, [de]
	and	a, [hl]
	ld	[de], a
	inc	de
	inc	hl
	dec	b
	jr	nz, .andl
	jr	.done
.or:
	ld	b, 4
.orl:
	ld	a, [de]
	or	a, [hl]
	ld	[de], a
	inc	de
	inc	hl
	dec	b
	jr	nz, .orl
	jr	.done
.xor:
	ld	b, 4
.xorl:
	ld	a, [de]
	xor	a, [hl]
	ld	[de], a
	inc	de
	inc	hl
	dec	b
	jr	nz, .xorl
	jr	.done
.done:
	ld	hl, _t
	ld	a, [hl+]
	ld	c, a
	ld	a, [hl+]
	ld	b, a
	ld	a, [hl+]
	ld	e, a
	ld	d, [hl]
	pop	hl
	add	sp, 8
	jp	hl
; x * y: y shifts out to the right, x left, adding x into div_rem for each 1
.mul:
	ld	hl, _div_rem
	xor	a, a
	ld	[hl+], a
	ld	[hl+], a
	ld	[hl+], a
	ld	[hl], a
	ld	c, 32
.mulbit:
	ld	hl, _t+7
	srl	[hl]
	dec	hl
	rr	[hl]
	dec	hl
	rr	[hl]
	dec	hl
	rr	[hl]
	jr	nc, .mulshift
	ld	de, _div_rem
	ld	hl, _t
	call	ArithAdd
.mulshift:
	ld	hl, _t+4
	call	ArithZero
	jr	z, .result
	ld	hl, _t
	call	ArithShl
	dec	c
	jr	nz, .mulbit
.result:
	ld	hl, _div_rem
	ld	de, _t
	call	ArithCopy
	jr	.done
; / and %: the magnitudes divided, then the signs: a negative quotient rounds down, and the
; remainder takes y's sign
.div:
	ld	hl, _t+4
	call	ArithZero
	jr	nz, .divide
	ld	a, 12
	call	_Fail
	xor	a, a
	jr	.bool
.divide:
	ld	a, [_t+7]
	ld	b, a
	ld	a, [_t+3]
	push	bc
	push	af
	ld	hl, _t
	rlca
	call	c, ArithNeg
	ld	a, [_t+7]
	ld	hl, _t+4
	rlca
	call	c, ArithNeg
	call	ArithDiv
	pop	af
	pop	bc
	xor	a, b
	rlca
	jr	nc, .signs
	push	bc
	ld	hl, _div_rem
	call	ArithZero
	ld	hl, _t
	jr	z, .exact
	ld	de, _div_rem
	ld	hl, _t+4
	call	ArithSub
	ld	hl, _div_rem
	call	ArithNeg
	ld	hl, _t
	call	ArithInc
	ld	hl, _t
.exact:
	call	ArithNeg
	pop	bc
.signs:
	ld	a, c
	cp	a, $25
	jr	nz, .done
	ld	hl, _div_rem
	bit	7, b
	call	nz, ArithNeg
	jr	.result
; << and >>: y's magnitude, up to 32, steps one bit at a time
.shift:
	ld	a, [_t+7]
	rlca
	jr	nc, .count
	ld	hl, _t+4
	call	ArithNeg
	ld	a, c
	xor	a, 1
	ld	c, a
.count:
	ld	hl, _t+5
	ld	a, [hl+]
	or	a, [hl]
	inc	hl
	or	a, [hl]
	ld	b, 32
	jr	nz, .steps
	ld	a, [_t+4]
	cp	a, b
	jr	nc, .steps
	ld	b, a
	or	a, a
	jr	z, .done
.steps:
	ld	a, c
	cp	a, $73
	jr	nz, .right
.left:
	ld	hl, _t
	call	ArithShl
	dec	b
	jr	nz, .left
	jr	.done
.right:
	ld	hl, _t+3
	sra	[hl]
	dec	hl
	rr	[hl]
	dec	hl
	rr	[hl]
	dec	hl
	rr	[hl]
	dec	b
	jr	nz, .right
	jr	.done

; the 4 bytes at de += (-=) those at hl; both move past them
ArithAdd:
	ld	b, 4
	and	a, a
.add:
	ld	a, [de]
	adc	a, [hl]
	ld	[de], a
	inc	de
	inc	hl
	dec	b
	jr	nz, .add
	ret
ArithSub:
	ld	b, 4
	and	a, a
.sub:
	ld	a, [de]
	sbc	a, [hl]
	ld	[de], a
	inc	de
	inc	hl
	dec	b
	jr	nz, .sub
	ret
; the 4 bytes at hl to de
ArithCopy:
	ld	b, 4
.copy:
	ld	a, [hl+]
	ld	[de], a
	inc	de
	dec	b
	jr	nz, .copy
	ret
; z (and a = 0) if the 4 bytes at hl are; hl moves past them
ArithZero:
	ld	a, [hl+]
	or	a, [hl]
	inc	hl
	or	a, [hl]
	inc	hl
	or	a, [hl]
	inc	hl
	ret
; the 4 bytes at hl: negated, plus 1, shifted left (the bit out in carry)
ArithNeg:
	ld	b, 4
	and	a, a
.neg:
	ld	a, 0
	sbc	a, [hl]
	ld	[hl+], a
	dec	b
	jr	nz, .neg
	ret
ArithInc:
	inc	[hl]
	ret	nz
	inc	hl
	inc	[hl]
	ret	nz
	inc	hl
	inc	[hl]
	ret	nz
	inc	hl
	inc	[hl]
	ret
ArithShl:
	and	a, a
ArithRl:
	rl	[hl]
	inc	hl
	rl	[hl]
	inc	hl
	rl	[hl]
	inc	hl
	rl	[hl]
	ret
; t[0] / t[1], unsigned: the quotient in t[0], the remainder in div_rem. The dividend's zero
; top bytes shift out at once; then a bit at a time, comparing before subtracting
ArithDiv:
	ld	hl, _div_rem
	xor	a, a
	ld	[hl+], a
	ld	[hl+], a
	ld	[hl+], a
	ld	[hl], a
	ld	c, 32
.skip:
	ld	a, [_t+3]
	or	a, a
	jr	nz, .bit
	ld	a, [_t+2]
	ld	[_t+3], a
	ld	a, [_t+1]
	ld	[_t+2], a
	ld	a, [_t]
	ld	[_t+1], a
	xor	a, a
	ld	[_t], a
	ld	a, c
	sub	a, 8
	ld	c, a
	jr	nz, .skip
	ret
.bit:
	ld	hl, _t
	call	ArithShl
	ld	hl, _div_rem
	call	ArithRl
	jr	c, .fits
	ld	hl, _div_rem+3
	ld	de, _t+7
	ld	b, 4
.compare:
	ld	a, [de]
	cp	a, [hl]
	jr	nz, .decided
	dec	hl
	dec	de
	dec	b
	jr	nz, .compare
	jr	.fits
.decided:
	jr	nc, .next
.fits:
	ld	de, _div_rem
	ld	hl, _t+4
	call	ArithSub
	ld	hl, _t
	set	0, [hl]
.next:
	dec	c
	jr	nz, .bit
	ret
  __endasm;
}

// a in debc, b on the stack (popped here); the quotient in debc
MATH_STATIC UVal Div(UVal a, UVal b) __naked {
  a; b;
  __asm
	ld	hl, _t
	ld	a, c
	ld	[hl+], a
	ld	a, b
	ld	[hl+], a
	ld	a, e
	ld	[hl+], a
	ld	[hl], d
	ld	hl, sp+2
	ld	de, _t+4
	call	ArithCopy
	call	ArithDiv
	ld	hl, _t
	ld	a, [hl+]
	ld	c, a
	ld	a, [hl+]
	ld	b, a
	ld	a, [hl+]
	ld	e, a
	ld	d, [hl]
	pop	hl
	add	sp, 4
	jp	hl
  __endasm;
}
#endif


