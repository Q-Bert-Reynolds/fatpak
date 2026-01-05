;--------------------------------------------------------
; File Created by SDCC : free open source ISO C Compiler 
; Version 4.2.8 #13684 (MINGW64)
;--------------------------------------------------------
	; MODULE test
	; Generated using the rgbds tokens.

;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	EXPORT _cFunctionTest
	EXPORT _fib
	EXPORT _str_Number
	EXPORT _RevealTextAndWait
	EXPORT _some_text
;--------------------------------------------------------
; special function registers
;--------------------------------------------------------
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	SECTION FRAGMENT "src/test.c_DATA",WRAMX
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	SECTION FRAGMENT "_INITIALIZED",ROM0
;--------------------------------------------------------
; absolute external ram data
;--------------------------------------------------------
	SECTION FRAGMENT "_DABS (ABS)",ROM0
;--------------------------------------------------------
; global & static initialisations
;--------------------------------------------------------
	SECTION FRAGMENT "_HOME",ROM0
	SECTION FRAGMENT "_GSINIT",ROM0
	SECTION FRAGMENT "_GSFINAL",ROM0
	SECTION FRAGMENT "_GSINIT",ROM0
;--------------------------------------------------------
; Home
;--------------------------------------------------------
	SECTION FRAGMENT "src/test.c_HOME",ROM0
	SECTION FRAGMENT "src/test.c_HOME",ROM0
;--------------------------------------------------------
; code
;--------------------------------------------------------
	SECTION FRAGMENT "src/test.c_CODE",ROMX
;src/test.c:12: char fib(char i) {
;	---------------------------------
; Function fib
; ---------------------------------
_fib::
;src/test.c:13: if (i < 2) return i;
	ld	c, a
	sub	a, $02
	jr	NC, .l00102
	ld	a, c
	jr	.l00103
.l00102:
;src/test.c:14: return fib(i-1) + fib(i-2);
	ld	b, c
	dec	b
	push	bc
	ld	a, b
	call	_fib
	ld	e, a
	pop	bc
	dec	c
	dec	c
	push	de
	ld	a, c
	call	_fib
	pop	de
	add	a, e
.l00103:
;src/test.c:15: }
	ret
;src/test.c:21: void cFunctionTest(void) {
;	---------------------------------
; Function cFunctionTest
; ---------------------------------
_cFunctionTest::
;src/test.c:22: RevealTextAndWait(1, some_text);
	ld	de, _some_text
	ld	a, $01
	call	_RevealTextAndWait
;src/test.c:23: for (char i = 0; i < 12; i++) {
	ld	l, $00
;	spillPairReg hl
;	spillPairReg hl
.l00103:
	ld	a, l
	sub	a, $0C
	ret	NC
;src/test.c:24: str_Number(fib(i));
	push	hl
	ld	a, l
	call	_fib
	pop	hl
	ld	c, a
	ld	b, $00
	ld	de, $0000
	push	hl
	call	_str_Number
	ld	de, _name_buffer
	ld	a, $01
	call	_RevealTextAndWait
	pop	hl
;src/test.c:23: for (char i = 0; i < 12; i++) {
	inc	l
	jr	.l00103
.l00105:
;src/test.c:27: }
	ret
_some_text:
	DB "This is a test."
	DB $80
	DB "As is this."
	DB $00
	SECTION FRAGMENT "src/test.c_CODE",ROMX
	SECTION FRAGMENT "_INITIALIZER",ROM0
	SECTION FRAGMENT "_CABS (ABS)",ROM0
