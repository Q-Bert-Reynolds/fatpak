;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 4.2.0 #13081 (Linux)
;--------------------------------------------------------
	; MODULE info
	; Generated using the rgbds tokens.

;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	EXPORT _PutNumber2
	EXPORT _PutNumber
	EXPORT _PutText
	EXPORT _DrawRow
	EXPORT _EditorDraw
	EXPORT _HideBox
	EXPORT _ShowBusy
	EXPORT _MenuKey
	EXPORT _ToLatin1
	EXPORT _IsGame
	EXPORT _BeginView
	EXPORT _FileLanguage
	EXPORT _FileInspect
	EXPORT _PutSize
	EXPORT _ShowFileInfo
;--------------------------------------------------------
; special function registers
;--------------------------------------------------------
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	SECTION FRAGMENT "src/browser/info.c_DATA",WRAM0
_src_browser_info_c_line:
	DS 65
_src_browser_info_c_details:
	DS 38
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
	SECTION FRAGMENT "src/browser/info.c_HOME",ROM0
	SECTION FRAGMENT "src/browser/info.c_HOME",ROM0
;--------------------------------------------------------
; code
;--------------------------------------------------------
	SECTION FRAGMENT "src/browser/info.c_CODE",ROMX
;src/browser/info.c:18: char* PutSize(char* dest, unsigned long size) {
;	---------------------------------
	SECTION FRAGMENT "Page 6",ROMX,BANK[3]
	LOAD FRAGMENT "Page 6 RAM",SRAM,BANK[6]
; Function PutSize
; ---------------------------------
_PutSize::
	add	sp, -5
	ld	c, e
	ld	b, d
;src/browser/info.c:19: unsigned char unit = 0, tenth;
	ld	hl, sp+0
	ld	[hl], $00
;src/browser/info.c:20: unsigned long whole = size, remainder = 0;
	ld	hl, sp+7
	ld	d, h
	ld	e, l
	ld	hl, sp+1
	ld	a, [de]
	ld	[hl+], a
	inc	de
	ld	a, [de]
	ld	[hl+], a
	inc	de
	ld	a, [de]
	ld	[hl+], a
	inc	de
	ld	a, [de]
	ld	[hl], a
;src/browser/info.c:21: if (size >= 1048576UL) {
	ld	hl, sp+1
	ld	a, [hl]
	sub	a, $00
	inc	hl
	ld	a, [hl]
	sbc	a, $00
	inc	hl
	ld	a, [hl]
	sbc	a, $10
	inc	hl
	ld	a, [hl]
	sbc	a, $00
	jp	C, .l00105
;src/browser/info.c:22: unit = 2;
	ld	hl, sp+0
	ld	[hl], $02
;src/browser/info.c:23: whole = size >> 20;
	ld	a, $14
.l00140:
	ld	hl, sp+4
	srl	[hl]
	dec	hl
	rr	[hl]
	dec	hl
	rr	[hl]
	dec	hl
	rr	[hl]
.l00141:
	dec	a
	jr	NZ, .l00140
;src/browser/info.c:24: remainder = size & 1048575UL;
	ld	hl, sp+7
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	inc	hl
	ld	a, [hl]
	and	a, $0F
	ld	l, a
;	spillPairReg hl
;	spillPairReg hl
	ld	h, $00
;	spillPairReg hl
;	spillPairReg hl
;src/browser/info.c:25: tenth = (remainder * 10) >> 20;
	push	bc
	push	hl
	push	de
	ld	bc, $000A
	ld	de, $0000
	call	__mullong
	ld	l, c
;	spillPairReg hl
;	spillPairReg hl
	ld	h, b
;	spillPairReg hl
;	spillPairReg hl
	pop	bc
	ld	hl, $0000
	ld	a, $04
.l00142:
	srl	d
	rr	e
.l00143:
	dec	a
	jr	NZ, .l00142
	jp	.l00106
.l00105:
;src/browser/info.c:27: else if (size >= 1024) {
	ld	hl, sp+1
	ld	a, [hl]
	sub	a, $00
	inc	hl
	ld	a, [hl]
	sbc	a, $04
	inc	hl
	ld	a, [hl]
	sbc	a, $00
	inc	hl
	ld	a, [hl]
	sbc	a, $00
	jp	C, .l00102
;src/browser/info.c:28: unit = 1;
	ld	hl, sp+0
	ld	[hl], $01
;src/browser/info.c:29: whole = size >> 10;
	ld	a, $0A
.l00144:
	ld	hl, sp+4
	srl	[hl]
	dec	hl
	rr	[hl]
	dec	hl
	rr	[hl]
	dec	hl
	rr	[hl]
.l00145:
	dec	a
	jr	NZ, .l00144
;src/browser/info.c:30: remainder = size & 1023;
	ld	hl, sp+7
	ld	e, [hl]
	inc	hl
	ld	a, [hl]
	and	a, $03
	ld	d, a
	ld	hl, $0000
;src/browser/info.c:31: tenth = (remainder * 10) >> 10;
	push	bc
	push	hl
	push	de
	ld	bc, $000A
	ld	de, $0000
	call	__mullong
	ld	h, e
;	spillPairReg hl
;	spillPairReg hl
	ld	e, c
	ld	l, d
;	spillPairReg hl
;	spillPairReg hl
	ld	d, b
	pop	bc
	ld	e, d
	ld	d, h
	ld	h, $00
;	spillPairReg hl
;	spillPairReg hl
	ld	a, $02
.l00146:
	srl	l
	rr	d
	rr	e
.l00147:
	dec	a
	jr	NZ, .l00146
	jp	.l00106
.l00102:
;src/browser/info.c:33: else tenth = 0;
	ld	e, $00
.l00106:
;src/browser/info.c:34: dest = PutNumber(dest, whole);
	push	de
	ld	hl, sp+5
	ld	a, [hl]
	inc	hl
	ld	h, [hl]
;	spillPairReg hl
;	spillPairReg hl
	ld	l, a
;	spillPairReg hl
;	spillPairReg hl
	push	hl
	ld	hl, sp+5
	ld	a, [hl]
	inc	hl
	ld	h, [hl]
;	spillPairReg hl
;	spillPairReg hl
	ld	l, a
;	spillPairReg hl
;	spillPairReg hl
	push	hl
	ld	e, c
	ld	d, b
	call	_PutNumber__far
	pop	de
;src/browser/info.c:35: if (tenth) { *dest++ = '.'; *dest++ = '0' + tenth; }
	ld	a, e
	or	a, a
	jp	Z, .l00108
	ld	a, $2E
	ld	[bc], a
	inc	bc
	ld	a, e
	add	a, $30
	ld	[bc], a
	inc	bc
.l00108:
;src/browser/info.c:36: if (unit) *dest++ = unit == 1 ? 'K' : 'M';
	ld	hl, sp+0
	ld	a, [hl]
	or	a, a
	jp	Z, .l00110
	ld	e, c
	ld	d, b
	inc	bc
	ld	a, [hl]
	dec	a
	jp	NZ,.l00148
	jp	.l00149
.l00148:
	jp	.l00113
.l00149:
	ld	hl, $004B
	jp	.l00114
.l00113:
	ld	hl, $004D
.l00114:
	ld	a, l
	ld	[de], a
.l00110:
;src/browser/info.c:37: *dest++ = 'B';
	ld	a, $42
	ld	[bc], a
	inc	bc
;src/browser/info.c:38: return dest;
.l00111:
;src/browser/info.c:39: }
	add	sp, 5
	pop	hl
	add	sp, 4
	jp hl
	SECTION FRAGMENT "src/browser/info.c FIXED",ROMX,BANK[1]
_src_browser_info_c_types:
	DW _src_browser_info_c__str_0
	DW _src_browser_info_c__str_1
	DW _src_browser_info_c__str_2
	DW _src_browser_info_c__str_3
	SECTION FRAGMENT "src/browser/info.c FIXED",ROMX,BANK[1]
_src_browser_info_c__str_0:
	DB "Plain Text"
	DB $00
	SECTION FRAGMENT "src/browser/info.c FIXED",ROMX,BANK[1]
_src_browser_info_c__str_1:
	DB "Markdown"
	DB $00
	SECTION FRAGMENT "src/browser/info.c FIXED",ROMX,BANK[1]
_src_browser_info_c__str_2:
	DB "C source"
	DB $00
	SECTION FRAGMENT "src/browser/info.c FIXED",ROMX,BANK[1]
_src_browser_info_c__str_3:
	DB "Assembly"
	DB $00
;src/browser/info.c:41: static char* Field(const char* label) { return PutText(line, label); }
;	---------------------------------
	SECTION FRAGMENT "src/browser/info.c ROM0",ROM0
; Function Field
; ---------------------------------
_src_browser_info_c_Field:
	ld	c, e
	ld	b, d
	ld	de, _src_browser_info_c_line
	jp	_PutText__far
.l00101:
	ret
;src/browser/info.c:42: static void Row(unsigned char row) { DrawRow(row, 1, line); }
;	---------------------------------
	SECTION FRAGMENT "src/browser/info.c ROM0",ROM0
; Function Row
; ---------------------------------
_src_browser_info_c_Row:
	ld	c, a
	ld	de, _src_browser_info_c_line
	push	de
	ld	e, $01
	ld	a, c
	call	_DrawRow__far
.l00101:
	ret
;src/browser/info.c:43: static void Value(unsigned char row, const char* label, const char* value) {
;	---------------------------------
	SECTION FRAGMENT "src/browser/info.c ROM0",ROM0
; Function Value
; ---------------------------------
_src_browser_info_c_Value:
	dec	sp
	ld	hl, sp+0
	ld	[hl], a
;src/browser/info.c:44: *PutText(Field(label), value) = 0;
	call	_src_browser_info_c_Field
	ld	e, c
	ld	d, b
	ld	hl, sp+3
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	call	_PutText__far
	xor	a, a
	ld	[bc], a
;src/browser/info.c:45: Row(row);
	ld	hl, sp+0
	ld	a, [hl]
	call	_src_browser_info_c_Row
.l00101:
;src/browser/info.c:46: }
	inc	sp
	pop	hl
	inc	sp
	inc	sp
	jp hl
;src/browser/info.c:47: static void SizeRow(unsigned char row, const char* label, unsigned long size) {
;	---------------------------------
	SECTION FRAGMENT "src/browser/info.c ROM0",ROM0
; Function SizeRow
; ---------------------------------
_src_browser_info_c_SizeRow:
	dec	sp
	ld	hl, sp+0
	ld	[hl], a
;src/browser/info.c:48: *PutSize(Field(label), size) = 0;
	call	_src_browser_info_c_Field
	ld	hl, sp+5
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	push	de
	ld	hl, sp+5
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	push	de
	ld	e, c
	ld	d, b
	call	_PutSize__far
	xor	a, a
	ld	[bc], a
;src/browser/info.c:49: Row(row);
	ld	hl, sp+0
	ld	a, [hl]
	call	_src_browser_info_c_Row
.l00101:
;src/browser/info.c:50: }
	inc	sp
	pop	hl
	add	sp, 4
	jp hl
;src/browser/info.c:51: static void DateRow(unsigned char row, const char* label, unsigned int date, unsigned int time) {
;	---------------------------------
	SECTION FRAGMENT "src/browser/info.c ROM0",ROM0
; Function DateRow
; ---------------------------------
_src_browser_info_c_DateRow:
	dec	sp
	ld	hl, sp+0
	ld	[hl], a
;src/browser/info.c:52: char* p = Field(label);
	call	_src_browser_info_c_Field
	ld	e, c
	ld	d, b
;src/browser/info.c:53: if (!date) p = PutText(p, "--");
	ld	hl, sp+4
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	jp	NZ, .l00104
	ld	bc, _src_browser_info_c___str_4
	call	_PutText__far
	jp	.l00105
.l00104:
;src/browser/info.c:55: p = PutNumber(p, 1980 + (date >> 9));
	ld	hl, sp+4
	ld	a, [hl]
	srl	a
	ld	c, a
	ld	b, $00
	ld	hl, $07BC
	add	hl, bc
	ld	c, l
	ld	b, h
	ld	hl, $0000
	push	hl
	push	bc
	call	_PutNumber__far
;src/browser/info.c:56: *p++ = '-';
	ld	a, $2D
	ld	[bc], a
	ld	e, c
	ld	d, b
	inc	de
;src/browser/info.c:57: p = PutNumber2(p, (date >> 5) & 15);
	ld	hl, sp+4
	dec	hl
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	ld	a, $05
.l00118:
	srl	b
	rr	c
	dec	a
	jp	NZ, .l00118
	ld	a, c
	and	a, $0F
	ld	c, a
	ld	b, $00
	call	_PutNumber2__far
;src/browser/info.c:58: *p++ = '-';
	ld	a, $2D
	ld	[bc], a
	ld	e, c
	ld	d, b
	inc	de
;src/browser/info.c:59: p = PutNumber2(p, date & 31);
	ld	hl, sp+3
	ld	a, [hl]
	and	a, $1F
	ld	c, a
	ld	b, $00
	call	_PutNumber2__far
;src/browser/info.c:60: if (time != 0xFFFF) {
	ld	hl, sp+5
	ld	a, [hl]
	inc	hl
	and	a, [hl]
	inc	a
	jp	NZ,.l00119
	jp	.l00105
.l00119:
;src/browser/info.c:61: *p++ = ' ';
	ld	a, $20
	ld	[bc], a
	ld	e, c
	ld	d, b
	inc	de
;src/browser/info.c:62: p = PutNumber2(p, time >> 11);
	ld	hl, sp+6
	ld	a, [hl]
	swap	a
	rlca
	and	a, $1F
	ld	c, a
	ld	b, $00
	call	_PutNumber2__far
;src/browser/info.c:63: *p++ = ':';
	ld	a, $3A
	ld	[bc], a
	ld	e, c
	ld	d, b
	inc	de
;src/browser/info.c:64: p = PutNumber2(p, (time >> 5) & 63);
	ld	hl, sp+6
	dec	hl
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	ld	a, $05
.l00120:
	srl	b
	rr	c
	dec	a
	jp	NZ, .l00120
	ld	a, c
	and	a, $3F
	ld	c, a
	ld	b, $00
	call	_PutNumber2__far
.l00105:
;src/browser/info.c:67: *p = 0;
	xor	a, a
	ld	[bc], a
;src/browser/info.c:68: Row(row);
	ld	hl, sp+0
	ld	a, [hl]
	call	_src_browser_info_c_Row
.l00106:
;src/browser/info.c:69: }
	inc	sp
	pop	hl
	add	sp, 4
	jp hl
	SECTION FRAGMENT "src/browser/info.c FIXED",ROMX,BANK[1]
_src_browser_info_c___str_4:
	DB "--"
	DB $00
;src/browser/info.c:72: static void GameInfo(void) {
;	---------------------------------
	SECTION FRAGMENT "src/browser/info.c FIXED",ROMX,BANK[1]
; Function GameInfo
; ---------------------------------
_src_browser_info_c_GameInfo:
	add	sp, -6
;src/browser/info.c:73: unsigned char* h = details.header;
;src/browser/info.c:74: unsigned char i, c, mapper = h[19];
	ld	hl, (_src_browser_info_c_details + 27) + 0
	ld	a, [hl]
	ld	hl, sp+5
	ld	[hl], a
;src/browser/info.c:76: char* p = Field("Title: ");
	ld	de, _src_browser_info_c___str_5
	call	_src_browser_info_c_Field
;src/browser/info.c:77: for (i = 0; i < (h[15] & 0x80 ? 15 : 16) && h[i]; ++i) {
	ld	hl, sp+4
	ld	[hl], $00
.l00136:
	ld	a, [(_src_browser_info_c_details + 23) + 0]
	rlca
	jp	C,.l00307
	jp	.l00140
.l00307:
	ld	hl, sp+0
	ld	[hl], $0F
	xor	a, a
	inc	hl
	ld	[hl], a
	jp	.l00141
.l00140:
	ld	hl, sp+0
	ld	[hl], $10
	xor	a, a
	inc	hl
	ld	[hl], a
.l00141:
	ld	hl, sp+4
	ld	a, [hl]
	dec	hl
	dec	hl
	ld	[hl], a
	inc	hl
	ld	[hl], $00
	ld	hl, sp+2
	ld	e, l
	ld	d, h
	ld	hl, sp+0
	ld	a, [de]
	inc	de
	sub	a, [hl]
	inc	hl
	ld	a, [de]
	sbc	a, [hl]
	ld	a, [de]
	ld	d, a
	ld	e, [hl]
	bit	7, e
	jp	Z, .l00308
	bit	7, d
	jp	NZ, .l00309
	cp	a, a
	jp	.l00309
.l00308:
	bit	7, d
	jp	Z, .l00309
	scf
.l00309:
	jp	NC, .l00101
	ld	de, (_src_browser_info_c_details + 8)
	ld	hl, sp+4
	ld	l, [hl]
	ld	h, $00
	add	hl, de
	ld	e, l
	ld	d, h
	ld	a, [de]
	or	a, a
	jp	Z, .l00101
;src/browser/info.c:78: c = h[i];
;src/browser/info.c:79: *p++ = c >= 32 && c < 127 ? c : '?';
	ld	e, c
	ld	d, b
	inc	bc
	cp	a, $20
	jp	C, .l00142
	cp	a, $7F
	jp	NC, .l00142
	ld	l, $00
;	spillPairReg hl
;	spillPairReg hl
	jp	.l00143
.l00142:
	ld	a, $3F
	ld	l, $00
;	spillPairReg hl
;	spillPairReg hl
.l00143:
	ld	[de], a
;src/browser/info.c:77: for (i = 0; i < (h[15] & 0x80 ? 15 : 16) && h[i]; ++i) {
	ld	hl, sp+4
	inc	[hl]
	jp	.l00136
.l00101:
;src/browser/info.c:81: *p = 0;
	xor	a, a
	ld	[bc], a
;src/browser/info.c:82: Row(7);
	ld	a, $07
	call	_src_browser_info_c_Row
;src/browser/info.c:83: Value(8, "Platform: ", !(h[15] & 0x80) ? "Game Boy" : h[15] & 0x40 ? "Color only" : "GB / Color");
	ld	hl, (_src_browser_info_c_details + 23) + 0
	ld	c, [hl]
	ld	a, c
	rlca
	and	a, $01
	ld	e, a
	ld	a, e
	or	a, a
	jp	NZ, .l00147
	ld	de, _src_browser_info_c___str_7+0
	jp	.l00148
.l00147:
	bit	6, c
	jp	NZ,.l00310
	jp	.l00149
.l00310:
	ld	de, _src_browser_info_c___str_8+0
	jp	.l00150
.l00149:
	ld	de, _src_browser_info_c___str_9+0
.l00150:
.l00148:
	push	de
	ld	de, _src_browser_info_c___str_6
	ld	a, $08
	call	_src_browser_info_c_Value
;src/browser/info.c:84: Value(9, "Super GB: ", h[18] == 3 ? "Yes" : "No");
	ld	a, [(_src_browser_info_c_details + 26) + 0]
	sub	a, $03
	jp	NZ,.l00311
	jp	.l00312
.l00311:
	jp	.l00151
.l00312:
	ld	bc, _src_browser_info_c___str_11+0
	jp	.l00152
.l00151:
	ld	bc, _src_browser_info_c___str_12+0
.l00152:
	push	bc
	ld	de, _src_browser_info_c___str_10
	ld	a, $09
	call	_src_browser_info_c_Value
;src/browser/info.c:85: p = Field("Mapper: ");
	ld	de, _src_browser_info_c___str_13
	call	_src_browser_info_c_Field
	ld	e, c
	ld	d, b
;src/browser/info.c:87: else if (mapper == 5 || mapper == 6) p = PutText(p, "MBC2");
	ld	hl, sp+5
	ld	a, [hl]
	sub	a, $05
	jp	NZ,.l00313
	ld	a,$01
	jp	.l00314
.l00313:
	xor	a,a
.l00314:
	ld	hl, sp+0
	ld	[hl], a
	ld	hl, sp+5
	ld	a, [hl]
	sub	a, $06
	jp	NZ,.l00315
	ld	a,$01
	jp	.l00316
.l00315:
	xor	a,a
.l00316:
	ld	hl, sp+1
	ld	[hl], a
;src/browser/info.c:86: if (mapper >= 1 && mapper <= 3) p = PutText(p, "MBC1");
	ld	hl, sp+5
	ld	a, [hl]
	sub	a, $01
	jp	C, .l00120
	ld	a, $03
	sub	a, [hl]
	jp	C, .l00120
	ld	bc, _src_browser_info_c___str_14
	call	_PutText__far
	jp	.l00121
.l00120:
;src/browser/info.c:87: else if (mapper == 5 || mapper == 6) p = PutText(p, "MBC2");
	ld	hl, sp+0
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00115
	inc	hl
	ld	a, [hl]
	or	a, a
	jp	Z, .l00116
.l00115:
	ld	bc, _src_browser_info_c___str_15
	call	_PutText__far
	jp	.l00121
.l00116:
;src/browser/info.c:88: else if (mapper >= 15 && mapper <= 19) p = PutText(p, "MBC3");
	ld	hl, sp+5
	ld	a, [hl]
	sub	a, $0F
	jp	C, .l00112
	ld	a, $13
	sub	a, [hl]
	jp	C, .l00112
	ld	bc, _src_browser_info_c___str_16
	call	_PutText__far
	jp	.l00121
.l00112:
;src/browser/info.c:89: else if (mapper >= 25 && mapper <= 30) p = PutText(p, "MBC5");
	ld	hl, sp+5
	ld	a, [hl]
	sub	a, $19
	jp	C, .l00108
	ld	a, $1E
	sub	a, [hl]
	jp	C, .l00108
	ld	bc, _src_browser_info_c___str_17
	call	_PutText__far
	jp	.l00121
.l00108:
;src/browser/info.c:90: else if (mapper == 0 || mapper == 8 || mapper == 9) p = PutText(p, "ROM");
	ld	hl, sp+5
	ld	a, [hl]
	or	a, a
	jp	Z, .l00102
	ld	a, [hl]
	sub	a, $08
	jp	NZ,.l00317
	jp	.l00102
.l00317:
	ld	hl, sp+5
	ld	a, [hl]
	sub	a, $09
	jp	NZ,.l00318
	jp	.l00319
.l00318:
	jp	.l00103
.l00319:
.l00102:
	ld	bc, _src_browser_info_c___str_18
	call	_PutText__far
	jp	.l00121
.l00103:
;src/browser/info.c:91: else { p = PutText(p, "type "); p = PutNumber(p, mapper); }
	ld	bc, _src_browser_info_c___str_19
	call	_PutText__far
	ld	hl, sp+5
	ld	a, [hl]
	ld	hl, sp+2
	ld	[hl], a
	xor	a, a
	inc	hl
	ld	[hl], a
	inc	hl
	ld	[hl], a
	inc	hl
	ld	[hl], a
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	push	de
	ld	hl, sp+4
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	push	de
	ld	e, c
	ld	d, b
	call	_PutNumber__far
.l00121:
;src/browser/info.c:92: *p = 0;
	xor	a, a
	ld	[bc], a
;src/browser/info.c:93: Row(10);
	ld	a, $0A
	call	_src_browser_info_c_Row
;src/browser/info.c:94: if (h[20] <= 8) { size = 32768UL << h[20]; SizeRow(11, "ROM: ", size); }
	ld	hl, (_src_browser_info_c_details + 28) + 0
	ld	a, [hl]
	ld	hl, sp+5
	ld	[hl], a
	ld	a, $08
	ld	hl, sp+5
	sub	a, [hl]
	jp	C, .l00124
	ld	a, [hl]
	push	af
	ld	bc, $8000
	ld	de, $0000
	pop	af
	inc	a
	jp	.l00321
.l00320:
	sla	c
	rl	b
	rl	e
	rl	d
.l00321:
	dec	a
	jr	NZ,.l00320
	push	de
	push	bc
	ld	de, _src_browser_info_c___str_20
	ld	a, $0B
	call	_src_browser_info_c_SizeRow
	jp	.l00125
.l00124:
;src/browser/info.c:95: else Value(11, "ROM: ", "Unknown");
	ld	de, _src_browser_info_c___str_21
	push	de
	ld	de, _src_browser_info_c___str_20
	ld	a, $0B
	call	_src_browser_info_c_Value
.l00125:
;src/browser/info.c:96: if (mapper == 5 || mapper == 6) Value(12, "RAM: ", "512 x 4 bits");
	ld	hl, sp+0
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00130
	inc	hl
	ld	a, [hl]
	or	a, a
	jp	Z, .l00131
.l00130:
	ld	de, _src_browser_info_c___str_23
	push	de
	ld	de, _src_browser_info_c___str_22
	ld	a, $0C
	call	_src_browser_info_c_Value
	jp	.l00132
.l00131:
;src/browser/info.c:98: c = h[21];
	ld	hl, (_src_browser_info_c_details + 29) + 0
	ld	a, [hl]
	ld	hl, sp+1
	ld	[hl], a
;src/browser/info.c:99: size = c == 2 ? 8192UL : c == 3 ? 32768UL : c == 4 ? 131072UL : c == 5 ? 65536UL : 0;
	ld	hl, sp+1
	ld	a, [hl]
	sub	a, $02
	jp	NZ,.l00322
	jp	.l00323
.l00322:
	jp	.l00153
.l00323:
	ld	hl, sp+2
	ld	[hl], $00
	inc	hl
	ld	[hl], $20
	xor	a, a
	inc	hl
	ld	[hl], a
	inc	hl
	ld	[hl], a
	jp	.l00154
.l00153:
	ld	hl, sp+1
	ld	a, [hl]
	sub	a, $03
	jp	NZ,.l00324
	jp	.l00325
.l00324:
	jp	.l00155
.l00325:
	ld	bc, $8000
	xor	a, a
	ld	e, a
	jp	.l00156
.l00155:
	ld	hl, sp+1
	ld	a, [hl]
	sub	a, $04
	jp	NZ,.l00326
	jp	.l00327
.l00326:
	jp	.l00157
.l00327:
	xor	a, a
	ld	hl, sp+2
	ld	[hl], a
	inc	hl
	ld	[hl], a
	inc	hl
	ld	[hl], $02
	xor	a, a
	inc	hl
	ld	[hl], a
	jp	.l00158
.l00157:
	ld	hl, sp+1
	ld	a, [hl]
	sub	a, $05
	jp	NZ,.l00328
	jp	.l00329
.l00328:
	jp	.l00159
.l00329:
	xor	a, a
	ld	hl, sp+2
	ld	[hl], a
	inc	hl
	ld	[hl], a
	inc	hl
	ld	[hl], $01
	xor	a, a
	inc	hl
	ld	[hl], a
	jp	.l00160
.l00159:
	xor	a, a
	ld	hl, sp+2
	ld	[hl], a
	inc	hl
	ld	[hl], a
	inc	hl
	ld	[hl], a
	inc	hl
	ld	[hl], a
.l00160:
.l00158:
	pop	hl
	pop	bc
	push	bc
	push	hl
	ld	hl, sp+4
	ld	a, [hl]
	inc	hl
	ld	e, [hl]
.l00156:
	ld	hl, sp+2
	ld	[hl], c
	inc	hl
	ld	[hl], b
	inc	hl
	ld	[hl], a
	inc	hl
	ld	[hl], e
.l00154:
;src/browser/info.c:100: if (c == 1 || c > 5) Value(12, "RAM: ", "Unknown");
	ld	hl, sp+1
	ld	a, [hl]
	dec	a
	jp	NZ,.l00330
	jp	.l00126
.l00330:
	ld	a, $05
	ld	hl, sp+1
	sub	a, [hl]
	jp	NC, .l00127
.l00126:
	ld	de, _src_browser_info_c___str_21
	push	de
	ld	de, _src_browser_info_c___str_22
	ld	a, $0C
	call	_src_browser_info_c_Value
	jp	.l00132
.l00127:
;src/browser/info.c:101: else SizeRow(12, "RAM: ", size);
	ld	hl, sp+4
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	push	de
	ld	hl, sp+4
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	push	de
	ld	de, _src_browser_info_c___str_22
	ld	a, $0C
	call	_src_browser_info_c_SizeRow
.l00132:
;src/browser/info.c:103: Value(13, "Region: ", h[22] == 0 ? "Japan" : h[22] == 1 ? "Overseas" : "Unknown");
	ld	a, [(_src_browser_info_c_details + 30) + 0]
	or	a, a
	jp	NZ, .l00161
	ld	de, _src_browser_info_c___str_25+0
	jp	.l00162
.l00161:
	dec	a
	jp	NZ,.l00331
	jp	.l00332
.l00331:
	jp	.l00163
.l00332:
	ld	de, _src_browser_info_c___str_26+0
	jp	.l00164
.l00163:
	ld	de, _src_browser_info_c___str_21+0
.l00164:
.l00162:
	ld	hl, sp+4
	ld	[hl], e
	inc	hl
	ld	[hl], d
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	push	de
	ld	de, _src_browser_info_c___str_24
	ld	a, $0D
	call	_src_browser_info_c_Value
;src/browser/info.c:104: *PutNumber(Field("Revision: "), h[24]) = 0;
	ld	a, [(_src_browser_info_c_details + 32) + 0]
	ld	hl, sp+0
	ld	[hl], a
	xor	a, a
	inc	hl
	ld	[hl], a
	inc	hl
	ld	[hl], a
	inc	hl
	ld	[hl], a
	ld	de, _src_browser_info_c___str_27
	call	_src_browser_info_c_Field
	ld	hl, sp+4
	ld	[hl], c
	inc	hl
	ld	[hl], b
	pop	hl
	pop	de
	push	de
	push	hl
	push	de
	pop	hl
	pop	de
	push	de
	push	hl
	push	de
	ld	hl, sp+8
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_PutNumber__far
	xor	a, a
	ld	[bc], a
;src/browser/info.c:105: Row(14);
	ld	a, $0E
	call	_src_browser_info_c_Row
;src/browser/info.c:106: Value(15, "Header checksum: ", details.status == 1 ? "OK" : "Bad");
	ld	a, [(_src_browser_info_c_details + 37) + 0]
	dec	a
	jp	NZ,.l00333
	jp	.l00334
.l00333:
	jp	.l00165
.l00334:
	ld	bc, _src_browser_info_c___str_29+0
	jp	.l00166
.l00165:
	ld	bc, _src_browser_info_c___str_30+0
.l00166:
	push	bc
	ld	de, _src_browser_info_c___str_28
	ld	a, $0F
	call	_src_browser_info_c_Value
.l00138:
;src/browser/info.c:107: }
	add	sp, 6
	ret
	SECTION FRAGMENT "src/browser/info.c FIXED",ROMX,BANK[1]
_src_browser_info_c___str_5:
	DB "Title: "
	DB $00
	SECTION FRAGMENT "src/browser/info.c FIXED",ROMX,BANK[1]
_src_browser_info_c___str_6:
	DB "Platform: "
	DB $00
	SECTION FRAGMENT "src/browser/info.c FIXED",ROMX,BANK[1]
_src_browser_info_c___str_7:
	DB "Game Boy"
	DB $00
	SECTION FRAGMENT "src/browser/info.c FIXED",ROMX,BANK[1]
_src_browser_info_c___str_8:
	DB "Color only"
	DB $00
	SECTION FRAGMENT "src/browser/info.c FIXED",ROMX,BANK[1]
_src_browser_info_c___str_9:
	DB "GB / Color"
	DB $00
	SECTION FRAGMENT "src/browser/info.c FIXED",ROMX,BANK[1]
_src_browser_info_c___str_10:
	DB "Super GB: "
	DB $00
	SECTION FRAGMENT "src/browser/info.c FIXED",ROMX,BANK[1]
_src_browser_info_c___str_11:
	DB "Yes"
	DB $00
	SECTION FRAGMENT "src/browser/info.c FIXED",ROMX,BANK[1]
_src_browser_info_c___str_12:
	DB "No"
	DB $00
	SECTION FRAGMENT "src/browser/info.c FIXED",ROMX,BANK[1]
_src_browser_info_c___str_13:
	DB "Mapper: "
	DB $00
	SECTION FRAGMENT "src/browser/info.c FIXED",ROMX,BANK[1]
_src_browser_info_c___str_14:
	DB "MBC1"
	DB $00
	SECTION FRAGMENT "src/browser/info.c FIXED",ROMX,BANK[1]
_src_browser_info_c___str_15:
	DB "MBC2"
	DB $00
	SECTION FRAGMENT "src/browser/info.c FIXED",ROMX,BANK[1]
_src_browser_info_c___str_16:
	DB "MBC3"
	DB $00
	SECTION FRAGMENT "src/browser/info.c FIXED",ROMX,BANK[1]
_src_browser_info_c___str_17:
	DB "MBC5"
	DB $00
	SECTION FRAGMENT "src/browser/info.c FIXED",ROMX,BANK[1]
_src_browser_info_c___str_18:
	DB "ROM"
	DB $00
	SECTION FRAGMENT "src/browser/info.c FIXED",ROMX,BANK[1]
_src_browser_info_c___str_19:
	DB "type "
	DB $00
	SECTION FRAGMENT "src/browser/info.c FIXED",ROMX,BANK[1]
_src_browser_info_c___str_20:
	DB "ROM: "
	DB $00
	SECTION FRAGMENT "src/browser/info.c FIXED",ROMX,BANK[1]
_src_browser_info_c___str_21:
	DB "Unknown"
	DB $00
	SECTION FRAGMENT "src/browser/info.c FIXED",ROMX,BANK[1]
_src_browser_info_c___str_22:
	DB "RAM: "
	DB $00
	SECTION FRAGMENT "src/browser/info.c FIXED",ROMX,BANK[1]
_src_browser_info_c___str_23:
	DB "512 x 4 bits"
	DB $00
	SECTION FRAGMENT "src/browser/info.c FIXED",ROMX,BANK[1]
_src_browser_info_c___str_24:
	DB "Region: "
	DB $00
	SECTION FRAGMENT "src/browser/info.c FIXED",ROMX,BANK[1]
_src_browser_info_c___str_25:
	DB "Japan"
	DB $00
	SECTION FRAGMENT "src/browser/info.c FIXED",ROMX,BANK[1]
_src_browser_info_c___str_26:
	DB "Overseas"
	DB $00
	SECTION FRAGMENT "src/browser/info.c FIXED",ROMX,BANK[1]
_src_browser_info_c___str_27:
	DB "Revision: "
	DB $00
	SECTION FRAGMENT "src/browser/info.c FIXED",ROMX,BANK[1]
_src_browser_info_c___str_28:
	DB "Header checksum: "
	DB $00
	SECTION FRAGMENT "src/browser/info.c FIXED",ROMX,BANK[1]
_src_browser_info_c___str_29:
	DB "OK"
	DB $00
	SECTION FRAGMENT "src/browser/info.c FIXED",ROMX,BANK[1]
_src_browser_info_c___str_30:
	DB "Bad"
	DB $00
;src/browser/info.c:109: void ShowFileInfo(const char* path, const FileEntry* entry) {
;	---------------------------------
	SECTION FRAGMENT "src/browser/info.c FIXED",ROMX,BANK[1]
; Function ShowFileInfo
; ---------------------------------
_ShowFileInfo::
	add	sp, -11
	ld	hl, sp+9
	ld	[hl], e
	inc	hl
	ld	[hl], d
	ld	hl, sp+7
	ld	[hl], c
	inc	hl
	ld	[hl], b
;src/browser/info.c:110: unsigned char row, result = 0, key;
	ld	hl, sp+0
	ld	[hl], $00
;src/browser/info.c:111: details.game = !entry->dir && IsGame(entry->name);
	ld	hl, sp+8
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $004F
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+3
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+2
	ld	[hl], a
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	or	a, a
	jp	NZ, .l00129
	ld	hl, sp+7
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_IsGame__far
	or	a, a
	jp	NZ, .l00130
.l00129:
	xor	a, a
	jp	.l00131
.l00130:
	ld	a, $01
.l00131:
	ld	hl, (_src_browser_info_c_details + 36)
	ld	[hl], a
;src/browser/info.c:112: details.status = 0;
	ld	hl, (_src_browser_info_c_details + 37)
	ld	[hl], $00
;src/browser/info.c:113: if (!entry->dir) {
	ld	hl, sp+2
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	ld	hl, sp+6
	ld	[hl], a
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00102
;src/browser/info.c:114: ShowBusy("Reading info...");
	ld	de, _src_browser_info_c___str_31
	call	_ShowBusy
;src/browser/info.c:115: result = FileInspect(path, &details);
	ld	bc, _src_browser_info_c_details
	ld	hl, sp+9
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_FileInspect
	ld	hl, sp+0
	ld	[hl], a
.l00102:
;src/browser/info.c:117: HideBox();
	call	_HideBox__far
;src/browser/info.c:118: BeginView(1);
	ld	a, $01
	call	_BeginView__far
;src/browser/info.c:119: *ToLatin1(line, entry->name, FS_NAME_SIZE - 1) = 0;
	ld	a, $40
	push	af
	inc	sp
	ld	hl, sp+8
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	ld	de, _src_browser_info_c_line
	call	_ToLatin1
	xor	a, a
	ld	[bc], a
;src/browser/info.c:120: DrawRow(HEADER_LINE, 1, line);
	ld	de, _src_browser_info_c_line
	push	de
	ld	e, $01
	ld	a, $12
	call	_DrawRow__far
;src/browser/info.c:121: DrawRow(STATUS_LINE, 1, "B/Esc: exit");
	ld	de, _src_browser_info_c___str_32
	push	de
	ld	e, $01
	ld	a, $13
	call	_DrawRow__far
;src/browser/info.c:122: for (row = 0; row < TB_ROWS - 2; ++row) DrawRow(row, 0, "");
	ld	c, $00
.l00125:
	push	bc
	ld	de, _src_browser_info_c___str_33
	push	de
	ld	e, $00
	ld	a, c
	call	_DrawRow__far
	pop	bc
	inc	c
	ld	a, c
	sub	a, $10
	jp	C, .l00125
;src/browser/info.c:123: Value(0, "Type: ", entry->dir ? "Folder" : details.game ? "Game Boy ROM" : details.status == 2 ? "Binary" : types[FileLanguage(entry->name)]);
	ld	hl, sp+2
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	or	a, a
	jp	Z, .l00132
	ld	de, _src_browser_info_c___str_35+0
	jp	.l00133
.l00132:
	ld	a, [(_src_browser_info_c_details + 36) + 0]
	or	a, a
	jp	Z, .l00134
	ld	de, _src_browser_info_c___str_36+0
	jp	.l00135
.l00134:
	ld	a, [(_src_browser_info_c_details + 37) + 0]
	sub	a, $02
	jp	NZ,.l00221
	jp	.l00222
.l00221:
	jp	.l00136
.l00222:
	ld	de, _src_browser_info_c___str_37+0
	ld	hl, sp+5
	ld	[hl], e
	inc	hl
	ld	[hl], d
	jp	.l00137
.l00136:
	ld	hl, sp+7
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_FileLanguage__far
	ld	hl, sp+6
	ld	[hl], a
	ld	hl, sp+6
	ld	a, [hl]
	dec	hl
	ld	[hl], a
	inc	hl
	ld	[hl], $00
	dec	hl
	ld	a, [hl]
	dec	hl
	dec	hl
	ld	[hl], a
	ld	hl, sp+6
	ld	a, [hl]
	dec	hl
	dec	hl
	ld	[hl], a
	dec	hl
	sla	[hl]
	inc	hl
	rl	[hl]
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, _src_browser_info_c_types
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+7
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+6
	ld	[hl], a
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	dec	hl
	ld	[hl], a
	inc	de
	ld	a, [de]
	inc	hl
	ld	[hl], a
.l00137:
	ld	hl, sp+5
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
.l00135:
.l00133:
	push	de
	ld	de, _src_browser_info_c___str_34
	xor	a, a
	call	_src_browser_info_c_Value
;src/browser/info.c:124: if (entry->dir) Value(1, "Size: ", "--");
	ld	hl, sp+2
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	ld	hl, sp+6
	ld	[hl], a
	ld	a, [hl]
	or	a, a
	jp	Z, .l00105
	ld	de, _src_browser_info_c___str_39
	push	de
	ld	de, _src_browser_info_c___str_38
	ld	a, $01
	call	_src_browser_info_c_Value
	jp	.l00106
.l00105:
;src/browser/info.c:125: else SizeRow(1, "Size: ", entry->size);
	ld	hl, sp+8
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $0041
	add	hl, de
	ld	c, l
	ld	b, h
	ld	e, c
	ld	d, b
	ld	a, [de]
	ld	hl, sp+3
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
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	push	de
	ld	hl, sp+5
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	push	de
	ld	de, _src_browser_info_c___str_38
	ld	a, $01
	call	_src_browser_info_c_SizeRow
.l00106:
;src/browser/info.c:126: DateRow(3, "Created: ", entry->cdate, entry->ctime);
	ld	hl, sp+8
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $004B
	add	hl, de
	ld	c, l
	ld	b, h
	ld	e, c
	ld	d, b
	ld	a, [de]
	ld	hl, sp+5
	ld	[hl], a
	inc	de
	ld	a, [de]
	inc	hl
	ld	[hl], a
	inc	hl
	inc	hl
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $0049
	add	hl, de
	ld	c, l
	ld	b, h
	ld	l, c
	ld	h, b
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	ld	hl, sp+5
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	push	de
	push	bc
	ld	de, _src_browser_info_c___str_40
	ld	a, $03
	call	_src_browser_info_c_DateRow
;src/browser/info.c:127: DateRow(4, "Accessed: ", entry->adate, 0xFFFF);
	ld	hl, sp+8
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $004D
	add	hl, de
	ld	c, l
	ld	b, h
	ld	l, c
	ld	h, b
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	ld	de, $FFFF
	push	de
	push	bc
	ld	de, _src_browser_info_c___str_41
	ld	a, $04
	call	_src_browser_info_c_DateRow
;src/browser/info.c:128: DateRow(5, "Modified: ", entry->date, entry->time);
	ld	hl, sp+8
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $0047
	add	hl, de
	ld	c, l
	ld	b, h
	ld	e, c
	ld	d, b
	ld	a, [de]
	ld	hl, sp+5
	ld	[hl], a
	inc	de
	ld	a, [de]
	inc	hl
	ld	[hl], a
	inc	hl
	inc	hl
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $0045
	add	hl, de
	ld	c, l
	ld	b, h
	ld	l, c
	ld	h, b
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	ld	hl, sp+5
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	push	de
	push	bc
	ld	de, _src_browser_info_c___str_42
	ld	a, $05
	call	_src_browser_info_c_DateRow
;src/browser/info.c:129: if (result) Value(7, "Read: ", "SD error");
	ld	hl, sp+0
	ld	a, [hl]
	or	a, a
	jp	Z, .l00119
	ld	de, _src_browser_info_c___str_44
	push	de
	ld	de, _src_browser_info_c___str_43
	ld	a, $07
	call	_src_browser_info_c_Value
	jp	.l00120
.l00119:
;src/browser/info.c:130: else if (details.game) {
	ld	a, [(_src_browser_info_c_details + 36) + 0]
	or	a, a
	jp	Z, .l00116
;src/browser/info.c:131: if (details.status) GameInfo();
	ld	a, [(_src_browser_info_c_details + 37) + 0]
	or	a, a
	jp	Z, .l00108
	call	_src_browser_info_c_GameInfo
	jp	.l00120
.l00108:
;src/browser/info.c:132: else Value(7, "Header: ", "Too short");
	ld	de, _src_browser_info_c___str_46
	push	de
	ld	de, _src_browser_info_c___str_45
	ld	a, $07
	call	_src_browser_info_c_Value
	jp	.l00120
.l00116:
;src/browser/info.c:134: else if (!entry->dir) {
	ld	hl, sp+2
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	or	a, a
	jp	NZ, .l00120
;src/browser/info.c:123: Value(0, "Type: ", entry->dir ? "Folder" : details.game ? "Game Boy ROM" : details.status == 2 ? "Binary" : types[FileLanguage(entry->name)]);
	ld	hl, (_src_browser_info_c_details + 37) + 0
	ld	a, [hl]
	ld	hl, sp+6
	ld	[hl], a
;src/browser/info.c:135: if (details.status == 1) {
	ld	hl, sp+6
	ld	a, [hl]
	dec	a
	jp	NZ,.l00224
	jp	.l00225
.l00224:
	jp	.l00111
.l00225:
;src/browser/info.c:136: *PutNumber(Field("Words: "), details.words) = 0;
	ld	de, _src_browser_info_c_details + 0
	ld	a, [de]
	ld	hl, sp+1
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
	ld	de, _src_browser_info_c___str_47
	call	_src_browser_info_c_Field
	ld	hl, sp+5
	ld	[hl], c
	inc	hl
	ld	[hl], b
	ld	hl, sp+3
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	push	de
	ld	hl, sp+3
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	push	de
	ld	hl, sp+9
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_PutNumber__far
	xor	a, a
	ld	[bc], a
;src/browser/info.c:137: Row(7);
	ld	a, $07
	call	_src_browser_info_c_Row
;src/browser/info.c:138: *PutNumber(Field("Lines: "), details.lines) = 0;
	ld	de, (_src_browser_info_c_details + 4) + 0
	ld	a, [de]
	ld	hl, sp+1
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
	ld	de, _src_browser_info_c___str_48
	call	_src_browser_info_c_Field
	ld	hl, sp+5
	ld	[hl], c
	inc	hl
	ld	[hl], b
	ld	hl, sp+3
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	push	de
	ld	hl, sp+3
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	push	de
	ld	hl, sp+9
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_PutNumber__far
	xor	a, a
	ld	[bc], a
;src/browser/info.c:139: Row(8);
	ld	a, $08
	call	_src_browser_info_c_Row
	jp	.l00120
.l00111:
;src/browser/info.c:141: else Value(7, "Counts: ", details.status == 2 ? "Binary file" : "Skipped (>32KB)");
	ld	hl, sp+6
	ld	a, [hl]
	sub	a, $02
	jp	NZ,.l00226
	jp	.l00227
.l00226:
	jp	.l00138
.l00227:
	ld	de, _src_browser_info_c___str_50+0
	ld	hl, sp+5
	ld	[hl], e
	inc	hl
	ld	[hl], d
	jp	.l00139
.l00138:
	ld	de, _src_browser_info_c___str_51+0
	ld	hl, sp+5
	ld	[hl], e
	inc	hl
	ld	[hl], d
.l00139:
	ld	hl, sp+5
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	push	de
	ld	de, _src_browser_info_c___str_49
	ld	a, $07
	call	_src_browser_info_c_Value
.l00120:
;src/browser/info.c:143: EditorDraw();
	call	_EditorDraw
;src/browser/info.c:144: do { key = MenuKey(); } while (key != KEY_BACKSPACE && key != KEY_ESCAPE);
.l00122:
	call	_MenuKey__far
	cp	a, $08
	jp	NZ,.l00228
	jp	.l00127
.l00228:
	sub	a, $1B
	jp	NZ,.l00229
	jp	.l00230
.l00229:
	jp	.l00122
.l00230:
.l00127:
;src/browser/info.c:145: }
	add	sp, 11
	ret
	SECTION FRAGMENT "src/browser/info.c FIXED",ROMX,BANK[1]
_src_browser_info_c___str_31:
	DB "Reading info..."
	DB $00
	SECTION FRAGMENT "src/browser/info.c FIXED",ROMX,BANK[1]
_src_browser_info_c___str_32:
	DB "B/Esc: exit"
	DB $00
	SECTION FRAGMENT "src/browser/info.c FIXED",ROMX,BANK[1]
_src_browser_info_c___str_33:
	DB $00
	SECTION FRAGMENT "src/browser/info.c FIXED",ROMX,BANK[1]
_src_browser_info_c___str_34:
	DB "Type: "
	DB $00
	SECTION FRAGMENT "src/browser/info.c FIXED",ROMX,BANK[1]
_src_browser_info_c___str_35:
	DB "Folder"
	DB $00
	SECTION FRAGMENT "src/browser/info.c FIXED",ROMX,BANK[1]
_src_browser_info_c___str_36:
	DB "Game Boy ROM"
	DB $00
	SECTION FRAGMENT "src/browser/info.c FIXED",ROMX,BANK[1]
_src_browser_info_c___str_37:
	DB "Binary"
	DB $00
	SECTION FRAGMENT "src/browser/info.c FIXED",ROMX,BANK[1]
_src_browser_info_c___str_38:
	DB "Size: "
	DB $00
	SECTION FRAGMENT "src/browser/info.c FIXED",ROMX,BANK[1]
_src_browser_info_c___str_39:
	DB "--"
	DB $00
	SECTION FRAGMENT "src/browser/info.c FIXED",ROMX,BANK[1]
_src_browser_info_c___str_40:
	DB "Created: "
	DB $00
	SECTION FRAGMENT "src/browser/info.c FIXED",ROMX,BANK[1]
_src_browser_info_c___str_41:
	DB "Accessed: "
	DB $00
	SECTION FRAGMENT "src/browser/info.c FIXED",ROMX,BANK[1]
_src_browser_info_c___str_42:
	DB "Modified: "
	DB $00
	SECTION FRAGMENT "src/browser/info.c FIXED",ROMX,BANK[1]
_src_browser_info_c___str_43:
	DB "Read: "
	DB $00
	SECTION FRAGMENT "src/browser/info.c FIXED",ROMX,BANK[1]
_src_browser_info_c___str_44:
	DB "SD error"
	DB $00
	SECTION FRAGMENT "src/browser/info.c FIXED",ROMX,BANK[1]
_src_browser_info_c___str_45:
	DB "Header: "
	DB $00
	SECTION FRAGMENT "src/browser/info.c FIXED",ROMX,BANK[1]
_src_browser_info_c___str_46:
	DB "Too short"
	DB $00
	SECTION FRAGMENT "src/browser/info.c FIXED",ROMX,BANK[1]
_src_browser_info_c___str_47:
	DB "Words: "
	DB $00
	SECTION FRAGMENT "src/browser/info.c FIXED",ROMX,BANK[1]
_src_browser_info_c___str_48:
	DB "Lines: "
	DB $00
	SECTION FRAGMENT "src/browser/info.c FIXED",ROMX,BANK[1]
_src_browser_info_c___str_49:
	DB "Counts: "
	DB $00
	SECTION FRAGMENT "src/browser/info.c FIXED",ROMX,BANK[1]
_src_browser_info_c___str_50:
	DB "Binary file"
	DB $00
	SECTION FRAGMENT "src/browser/info.c FIXED",ROMX,BANK[1]
_src_browser_info_c___str_51:
	DB "Skipped (>32KB)"
	DB $00
	SECTION FRAGMENT "src/browser/info.c FIXED",ROMX,BANK[1]
	SECTION FRAGMENT "_INITIALIZER",ROM0
	SECTION FRAGMENT "_CABS (ABS)",ROM0
