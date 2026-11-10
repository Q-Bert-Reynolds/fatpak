;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 4.2.0 #13081 (Linux)
;--------------------------------------------------------
	; MODULE text
	; Generated using the rgbds tokens.

;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	EXPORT _PutText
	EXPORT _PutNumber
	EXPORT _PutNumber2
	EXPORT _CopyName
;--------------------------------------------------------
; special function registers
;--------------------------------------------------------
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	SECTION FRAGMENT "src/ui/text.c_DATA",WRAM0
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
	SECTION FRAGMENT "src/ui/text.c_HOME",ROM0
	SECTION FRAGMENT "src/ui/text.c_HOME",ROM0
;--------------------------------------------------------
; code
;--------------------------------------------------------
	SECTION FRAGMENT "src/ui/text.c_CODE",ROMX
;src/ui/text.c:6: char* PutText(char* dest, const char* text) {
;	---------------------------------
	SECTION FRAGMENT "Page 5",ROMX,BANK[2]
	LOAD FRAGMENT "Page 5 RAM",SRAM,BANK[5]
; Function PutText
; ---------------------------------
_PutText::
;src/ui/text.c:7: while (*text) *dest++ = *text++;
.l00101:
	ld	a, [bc]
	or	a, a
	jp	Z, .l00103
	inc	bc
	ld	[de], a
	inc	de
	jp	.l00101
.l00103:
;src/ui/text.c:8: return dest;
	ld	c, e
	ld	b, d
.l00104:
;src/ui/text.c:9: }
	ret
	SECTION FRAGMENT "src/ui/text.c FIXED",ROMX,BANK[1]
_src_ui_text_c_powers_of_ten:
	DB $40, $42, $0F, $00	; 1000000
	DB $A0, $86, $01, $00	; 100000
	DB $10, $27, $00, $00	; 10000
	DB $E8, $03, $00, $00	; 1000
	DB $64, $00, $00, $00	; 100
	DB $0A, $00, $00, $00	; 10
;src/ui/text.c:11: char* PutNumber(char* dest, unsigned long n) {
;	---------------------------------
	SECTION FRAGMENT "Page 4",ROMX,BANK[2]
	LOAD FRAGMENT "Page 4 RAM",SRAM,BANK[4]
; Function PutNumber
; ---------------------------------
_PutNumber::
	add	sp, -10
	ld	hl, sp+6
	ld	[hl], e
	inc	hl
	ld	[hl], d
;src/ui/text.c:12: unsigned char i, digit, started = 0;
	ld	hl, sp+4
	ld	[hl], $00
;src/ui/text.c:13: for (i = 0; i < 6; ++i) {
	ld	hl, sp+8
	ld	[hl], $00
;src/ui/text.c:15: while (n >= powers_of_ten[i]) {
.l00113:
	ld	hl, sp+9
	ld	[hl], $30
.l00101:
	ld	hl, sp+8
	ld	a, [hl]
	ld	c, $00
	ld	l, a
	ld	h, c
	add	hl, hl
	add	hl, hl
	ld	de, _src_ui_text_c_powers_of_ten
	add	hl, de
	ld	e, l
	ld	d, h
	ld	a, [de]
	ld	hl, sp+0
	ld	[hl], a
	inc	de
	ld	a, [de]
	inc	hl
	ld	[hl], a
	inc	de
	ld	a, [de]
	inc	hl
	ld	[hl], a
	inc	de
	ld	a, [de]
	inc	hl
	ld	[hl], a
	ld	hl, sp+12
	ld	e, l
	ld	d, h
	ld	hl, sp+0
	ld	a, [de]
	inc	de
	sub	a, [hl]
	inc	hl
	ld	a, [de]
	inc	de
	sbc	a, [hl]
	inc	hl
	ld	a, [de]
	inc	de
	sbc	a, [hl]
	inc	hl
	ld	a, [de]
	sbc	a, [hl]
	jp	C, .l00117
;src/ui/text.c:16: n -= powers_of_ten[i];
	ld	hl, sp+13
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, e
	ld	hl, sp+0
	sub	a, [hl]
	ld	e, a
	ld	a, d
	inc	hl
	sbc	a, [hl]
	push	af
	ld	hl, sp+15
	ld	[hl], a
	dec	hl
	ld	[hl], e
	ld	hl, sp+17
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, sp+4
	pop	af
	ld	a, e
	sbc	a, [hl]
	ld	e, a
	ld	a, d
	inc	hl
	sbc	a, [hl]
	ld	hl, sp+15
	ld	[hl], a
	dec	hl
	ld	[hl], e
;src/ui/text.c:17: ++digit;
	ld	hl, sp+9
	inc	[hl]
	jp	.l00101
.l00117:
	ld	hl, sp+9
	ld	a, [hl]
	ld	hl, sp+5
	ld	[hl], a
;src/ui/text.c:19: if (started || digit != '0') {
	dec	hl
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00104
	ld	hl, sp+9
	ld	a, [hl]
	sub	a, $30
	jp	NZ,.l00139
	jp	.l00109
.l00139:
.l00104:
;src/ui/text.c:20: *dest++ = digit;
	ld	hl, sp+7
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	dec	hl
	dec	hl
	ld	a, [hl]
	ld	[de], a
	inc	hl
	inc	[hl]
	jp	NZ, .l00140
	inc	hl
	inc	[hl]
.l00140:
;src/ui/text.c:21: started = 1;
	ld	hl, sp+4
	ld	[hl], $01
.l00109:
;src/ui/text.c:13: for (i = 0; i < 6; ++i) {
	ld	hl, sp+8
	inc	[hl]
	ld	a, [hl]
	sub	a, $06
	jp	C, .l00113
;src/ui/text.c:24: *dest++ = '0' + (unsigned char)n;
	ld	hl, sp+12
	ld	a, [hl]
	add	a, $30
	ld	c, a
	ld	hl, sp+6
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	ld	[hl], c
	ld	hl, sp+6
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	inc	bc
;src/ui/text.c:25: return dest;
.l00110:
;src/ui/text.c:26: }
	add	sp, 10
	pop	hl
	add	sp, 4
	jp hl
;src/ui/text.c:29: char* PutNumber2(char* dest, unsigned int n) {
;	---------------------------------
	SECTION FRAGMENT "Page 14",ROMX,BANK[7]
	LOAD FRAGMENT "Page 14 RAM",SRAM,BANK[14]
; Function PutNumber2
; ---------------------------------
_PutNumber2::
;src/ui/text.c:30: if (n < 10) *dest++ = '0';
	ld	a, c
	sub	a, $0A
	ld	a, b
	sbc	a, $00
	jp	NC, .l00102
	ld	a, $30
	ld	[de], a
	inc	de
.l00102:
;src/ui/text.c:31: return PutNumber(dest, n);
	ld	hl, $0000
	push	hl
	push	bc
	call	_PutNumber__far
.l00103:
;src/ui/text.c:32: }
	ret
;src/ui/text.c:34: void CopyName(char* dest, const char* src) {
;	---------------------------------
	SECTION FRAGMENT "Page 4",ROMX,BANK[2]
	LOAD FRAGMENT "Page 4 RAM",SRAM,BANK[4]
; Function CopyName
; ---------------------------------
_CopyName::
;src/ui/text.c:35: while ((*dest++ = *src++));
.l00101:
	ld	a, [bc]
	inc	bc
	ld	[de], a
	inc	de
	or	a, a
	jp	NZ, .l00101
.l00104:
;src/ui/text.c:36: }
	ret
	SECTION FRAGMENT "Page 4",ROMX,BANK[2]
	LOAD FRAGMENT "Page 4 RAM",SRAM,BANK[4]
	SECTION FRAGMENT "_INITIALIZER",ROM0
	SECTION FRAGMENT "_CABS (ABS)",ROM0
