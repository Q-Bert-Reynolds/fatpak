;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 4.2.0 #13081 (Linux)
;--------------------------------------------------------
	; MODULE test
	; Generated using the rgbds tokens.

;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	EXPORT _FooterDraw
	EXPORT _PutNumber
	EXPORT _PutText
	EXPORT _WaitFrame
	EXPORT _ClearScreen
	EXPORT _DrawRow
	EXPORT _EditorDraw
	EXPORT _SetFont
	EXPORT _KBListen
	EXPORT _KBPopEvent
	EXPORT _PadPressed
	EXPORT _EndFullScreen
	EXPORT _BeginFullScreen
	EXPORT _KeyboardTest
;--------------------------------------------------------
; special function registers
;--------------------------------------------------------
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	SECTION FRAGMENT "src/keyboard/test.c_DATA",WRAM0
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
	SECTION FRAGMENT "src/keyboard/test.c_HOME",ROM0
	SECTION FRAGMENT "src/keyboard/test.c_HOME",ROM0
;--------------------------------------------------------
; code
;--------------------------------------------------------
	SECTION FRAGMENT "src/keyboard/test.c_CODE",ROMX
;src/keyboard/test.c:15: static char* PutHex(char* dest, unsigned char n) {
;	---------------------------------
	SECTION FRAGMENT "Page 13",ROMX,BANK[6]
	LOAD FRAGMENT "Page 13 RAM",SRAM,BANK[13]
; Function PutHex
; ---------------------------------
_src_keyboard_test_c_PutHex:
	dec	sp
	ld	c, e
	ld	b, d
	ld	hl, sp+0
	ld	[hl], a
;src/keyboard/test.c:16: unsigned char digit = n >> 4;
	ld	a, [hl]
	swap	a
	and	a, $0F
;src/keyboard/test.c:17: *dest++ = digit < 10 ? '0' + digit : 'A' - 10 + digit;
	ld	e, c
	ld	d, b
	inc	bc
	ld	l, a
;	spillPairReg hl
;	spillPairReg hl
	sub	a, $0A
	jp	NC, .l00103
	ld	a, l
	add	a, $30
	jp	.l00104
.l00103:
	ld	a, l
	add	a, $37
.l00104:
	ld	[de], a
;src/keyboard/test.c:18: digit = n & 15;
	ld	hl, sp+0
	ld	a, [hl]
	and	a, $0F
;src/keyboard/test.c:19: *dest++ = digit < 10 ? '0' + digit : 'A' - 10 + digit;
	ld	e, c
	ld	d, b
	inc	bc
;src/keyboard/test.c:17: *dest++ = digit < 10 ? '0' + digit : 'A' - 10 + digit;
	ld	l, a
;	spillPairReg hl
;	spillPairReg hl
;src/keyboard/test.c:19: *dest++ = digit < 10 ? '0' + digit : 'A' - 10 + digit;
	sub	a, $0A
	jp	NC, .l00105
	ld	a, l
	add	a, $30
	jp	.l00106
.l00105:
	ld	a, l
	add	a, $37
.l00106:
	ld	[de], a
;src/keyboard/test.c:20: return dest;
.l00101:
;src/keyboard/test.c:21: }
	inc	sp
	ret
	SECTION FRAGMENT "Page 13",ROMX,BANK[6]
	LOAD FRAGMENT "Page 13 RAM",SRAM,BANK[13]
_src_keyboard_test_c_test_errors:
	DB "finish"
	DB $00
	DB $00
	DB $00
	DB "parity"
	DB $00
	DB $00
	DB $00
	DB "start"
	DB $00
	DB $00
	DB $00
	DB $00
	DB $00
	DB $00
	DB $00
	DB $00
	DB $00
	DB $00
	DB $00
	DB $00
	DB $00
	DB $00
	DB $00
	DB $00
	DB $00
	DB $00
	DB $00
	DB $00
	DB $00
	DB $00
	DB "timeout"
	DB $00
	DB $00
;src/keyboard/test.c:26: void KeyboardTest(void) {
;	---------------------------------
	SECTION FRAGMENT "Page 13",ROMX,BANK[6]
	LOAD FRAGMENT "Page 13 RAM",SRAM,BANK[13]
; Function KeyboardTest
; ---------------------------------
_KeyboardTest::
	add	sp, -79
;src/keyboard/test.c:27: unsigned char codes[TEST_CODES], errors[TEST_CODES], read = kb_buffer_write, count = 0, boot = kb_type;
	ld	hl, _kb_buffer_write
	ld	a, [hl]
	ld	hl, sp+62
	ld	[hl], a
	inc	hl
	ld	[hl], $00
	ld	hl, _kb_type
	ld	a, [hl]
	ld	hl, sp+78
	ld	[hl], a
;src/keyboard/test.c:28: unsigned char row, i, bit, editor_font = font, bytes = kb_interrupt_count, errors_seen = kb_error_count;
	ld	hl, _font
	ld	a, [hl]
	ld	hl, sp+64
	ld	[hl], a
	ld	hl, _kb_interrupt_count
	ld	a, [hl]
	ld	hl, sp+65
	ld	[hl], a
	ld	hl, _kb_error_count
	ld	a, [hl]
	ld	hl, sp+66
	ld	[hl], a
;src/keyboard/test.c:31: font = FONT_VWF;
	ld	hl, _font
	ld	[hl], $01
;src/keyboard/test.c:32: SetFont(font);
	ld	a, $01
	call	_SetFont
;src/keyboard/test.c:33: render_text = 0;
	ld	hl, _render_text
	ld	[hl], $00
;src/keyboard/test.c:34: BeginFullScreen();
	call	_BeginFullScreen__far
;src/keyboard/test.c:35: ClearScreen();
	call	_ClearScreen__far
;src/keyboard/test.c:36: KBListen();
	call	_KBListen
;src/keyboard/test.c:37: DrawRow(0, 0, "KEYBOARD TEST");
	ld	de, _src_keyboard_test_c___str_5
	push	de
	ld	e, $00
	xor	a, a
	call	_DrawRow__far
;src/keyboard/test.c:38: DrawRow(1, 0, boot == 1 ? "Found at boot: PS/2" : boot ? "Found at boot: iGKB" : "Found at boot: none, listening anyway");
	ld	hl, sp+78
	ld	a, [hl]
	dec	a
	jp	NZ,.l00262
	jp	.l00263
.l00262:
	jp	.l00137
.l00263:
	ld	de, _src_keyboard_test_c___str_6+0
	jp	.l00138
.l00137:
	ld	hl, sp+78
	ld	a, [hl]
	or	a, a
	jp	Z, .l00139
	ld	de, _src_keyboard_test_c___str_7+0
	dec	hl
	ld	[hl], e
	inc	hl
	ld	[hl], d
	jp	.l00140
.l00139:
	ld	de, _src_keyboard_test_c___str_8+0
	ld	hl, sp+77
	ld	[hl], e
	inc	hl
	ld	[hl], d
.l00140:
	ld	hl, sp+77
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
.l00138:
	push	de
	ld	e, $00
	ld	a, $01
	call	_DrawRow__far
;src/keyboard/test.c:39: DrawRow(4, 0, "Scan codes (newest last):");
	ld	de, _src_keyboard_test_c___str_9
	push	de
	ld	e, $00
	ld	a, $04
	call	_DrawRow__far
;src/keyboard/test.c:40: FooterDraw(TB_ROWS - 1, 0, "B or Start: back");
	ld	de, _src_keyboard_test_c___str_10
	push	de
	ld	e, $00
	ld	a, $11
	call	_FooterDraw__far
;src/keyboard/test.c:41: while (1) {
.l00124:
;src/keyboard/test.c:42: end = PutText(text, "Bytes ");
	ld	bc, _src_keyboard_test_c___str_11
	ld	hl, 22
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_PutText__far
;src/keyboard/test.c:43: end = PutNumber(end, (unsigned char)(kb_interrupt_count - bytes));
	ld	hl, _kb_interrupt_count
	ld	a, [hl]
	ld	hl, sp+65
	sub	a, [hl]
	ld	e, a
	ld	d, $00
	ld	hl, $0000
	push	hl
	push	de
	ld	e, c
	ld	d, b
	call	_PutNumber__far
	ld	e, c
	ld	d, b
;src/keyboard/test.c:44: end = PutText(end, "   with errors ");
	ld	bc, _src_keyboard_test_c___str_12
	call	_PutText__far
;src/keyboard/test.c:45: end = PutNumber(end, (unsigned char)(kb_error_count - errors_seen));
	ld	hl, _kb_error_count
	ld	a, [hl]
	ld	hl, sp+66
	sub	a, [hl]
	ld	e, a
	ld	d, $00
	ld	hl, $0000
	push	hl
	push	de
	ld	e, c
	ld	d, b
	call	_PutNumber__far
;src/keyboard/test.c:46: *end = 0;
	xor	a, a
	ld	[bc], a
;src/keyboard/test.c:47: DrawRow(2, 0, text);
	ld	hl, 22
	add	hl, sp
	push	hl
	ld	e, $00
	ld	a, $02
	call	_DrawRow__far
;src/keyboard/test.c:48: if (read != kb_buffer_write) {
	ld	hl, sp+62
	ld	a, [hl]
	ld	hl, _kb_buffer_write
	sub	a, [hl]
	jp	NZ,.l00264
	jp	.l00162
.l00264:
;src/keyboard/test.c:49: while (read != kb_buffer_write) {
	ld	hl, sp+63
	ld	a, [hl]
	ld	hl, sp+78
	ld	[hl], a
.l00104:
	ld	hl, _kb_buffer_write
	ld	a, [hl]
	ld	hl, sp+62
	sub	a, [hl]
	jp	NZ,.l00265
	jp	.l00168
.l00265:
;src/keyboard/test.c:50: for (i = 1; i < TEST_CODES; ++i) codes[i - 1] = codes[i], errors[i - 1] = errors[i];
	ld	c, $01
.l00126:
	ld	a, c
	dec	a
	ld	hl, sp+76
	ld	[hl], a
	rlca
	sbc	a, a
	inc	hl
	ld	[hl], a
	push	hl
	ld	hl, 2
	add	hl, sp
	ld	e, l
	ld	d, h
	pop	hl
	ld	hl, sp+76
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	add	hl, de
	ld	e, l
	ld	d, h
	push	de
	ld	e, c
	ld	d, $00
	ld	hl, 2
	add	hl, sp
	add	hl, de
	pop	de
	ld	a, [hl]
	ld	[de], a
	push	hl
	ld	hl, 13
	add	hl, sp
	ld	e, l
	ld	d, h
	pop	hl
	ld	hl, sp+76
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	add	hl, de
	ld	e, l
	ld	d, h
	push	de
	ld	e, c
	ld	d, $00
	ld	hl, 13
	add	hl, sp
	add	hl, de
	pop	de
	ld	a, [hl]
	ld	[de], a
	inc	c
	ld	a, c
	sub	a, $0B
	jp	C, .l00126
;src/keyboard/test.c:51: codes[TEST_CODES - 1] = kb_scan_code_buffer[read];
	ld	de, _kb_scan_code_buffer
	ld	hl, sp+62
	ld	l, [hl]
	ld	h, $00
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, [bc]
	ld	hl, sp+10
	ld	[hl], a
;src/keyboard/test.c:52: errors[TEST_CODES - 1] = kb_error_buffer[read];
	ld	de, _kb_error_buffer
	ld	hl, sp+62
	ld	l, [hl]
	ld	h, $00
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, [bc]
	ld	hl, sp+21
	ld	[hl], a
;src/keyboard/test.c:53: read = (read + 1) & 63;
	ld	hl, sp+62
	ld	a, [hl]
	inc	a
	and	a, $3F
	ld	[hl], a
;src/keyboard/test.c:54: if (count < TEST_CODES) ++count;
	ld	hl, sp+78
	ld	a, [hl]
	sub	a, $0B
	jp	NC, .l00104
	inc	[hl]
	jp	.l00104
.l00168:
	ld	hl, sp+78
	ld	a, [hl]
	ld	hl, sp+63
	ld	[hl], a
;src/keyboard/test.c:56: for (i = 0; i < count; ++i) {
	ld	hl, sp+77
	ld	[hl], $00
.l00133:
	ld	hl, sp+77
	ld	a, [hl]
	ld	hl, sp+63
	sub	a, [hl]
	jp	NC, .l00162
;src/keyboard/test.c:57: row = TEST_CODES - count + i;
	ld	a, [hl]
	ld	hl, sp+67
	ld	[hl], a
	ld	a, $0B
	sub	a, [hl]
	push	af
	ld	hl, sp+79
	ld	a, [hl]
	ld	hl, sp+70
	ld	[hl], a
	pop	af
	add	a, [hl]
	ld	hl, sp+78
	ld	[hl], a
;src/keyboard/test.c:58: end = PutHex(text, codes[row]);
	push	hl
	ld	hl, 2
	add	hl, sp
	ld	e, l
	ld	d, h
	pop	hl
	ld	hl, sp+78
	ld	l, [hl]
	ld	h, $00
	add	hl, de
	ld	e, l
	ld	d, h
	ld	a, [de]
	ld	c, a
	push	de
	ld	a, c
	ld	hl, 24
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_src_keyboard_test_c_PutHex
	pop	de
;src/keyboard/test.c:59: *end++ = ' ';
	ld	a, $20
	ld	[bc], a
	inc	bc
;src/keyboard/test.c:60: for (bit = 0x80; bit; bit >>= 1) *end++ = codes[row] & bit ? '1' : '0';
	ld	hl, sp+76
	ld	[hl], $80
	ld	hl, sp+72
	ld	[hl], e
	inc	hl
	ld	[hl], d
.l00128:
	ld	hl, sp+74
	ld	[hl], c
	inc	hl
	ld	[hl], b
	inc	bc
	dec	hl
	dec	hl
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	ld	hl, sp+76
	and	a, [hl]
	or	a, a
	jp	Z, .l00141
	ld	de, $0031
	jp	.l00142
.l00141:
	ld	de, $0030
.l00142:
	ld	a, e
	ld	hl, sp+74
	push	af
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	pop	af
	ld	[hl], a
	ld	hl, sp+76
	ld	a, [hl]
	srl	a
	ld	[hl], a
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00128
;src/keyboard/test.c:61: for (bit = 0; bit < 6; ++bit) if (errors[row] & (1 << bit) && test_errors[bit][0]) *end++ = ' ', end = PutText(end, test_errors[bit]);
	ld	hl, sp+69
	ld	[hl], c
	inc	hl
	ld	[hl], b
	push	hl
	ld	hl, 13
	add	hl, sp
	ld	e, l
	ld	d, h
	pop	hl
	ld	hl, sp+78
	ld	l, [hl]
	ld	h, $00
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+73
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+72
	ld	[hl], a
	ld	hl, sp+78
	ld	[hl], $00
.l00130:
	ld	hl, sp+72
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	ld	hl, sp+78
	ld	b, [hl]
	ld	de, $0001
	inc	b
	jp	.l00267
.l00266:
	sla	e
	rl	d
.l00267:
	dec	b
	jr	NZ,.l00266
	ld	b, $00
	and	a, e
	ld	c, a
	ld	a, b
	and	a, d
	or	a, c
	jp	Z, .l00131
	ld	c, [hl]
	ld	b, $00
	ld	l, c
	ld	h, b
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, bc
	push	hl
	ld	a, l
	ld	hl, sp+75
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+74
	ld	[hl], a
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, _src_keyboard_test_c_test_errors
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+77
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+76
	ld	[hl], a
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	or	a, a
	jp	Z, .l00131
	ld	hl, sp+69
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	ld	[hl], $20
	ld	hl, sp+69
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	inc	de
	ld	hl, sp+75
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	call	_PutText__far
	ld	hl, sp+69
	ld	[hl], c
	inc	hl
	ld	[hl], b
.l00131:
	ld	hl, sp+78
	inc	[hl]
	ld	a, [hl]
	sub	a, $06
	jp	C, .l00130
;src/keyboard/test.c:62: *end = 0;
	ld	hl, sp+69
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	ld	[hl], $00
;src/keyboard/test.c:63: DrawRow(TEST_FIRST + TEST_CODES - count + i, 0, text);
	ld	hl, 22
	add	hl, sp
	ld	c, l
	ld	b, h
	ld	a, $10
	ld	hl, sp+67
	sub	a, [hl]
	inc	hl
	add	a, [hl]
	ld	l, a
;	spillPairReg hl
;	spillPairReg hl
	push	bc
	ld	e, $00
	ld	a, l
	call	_DrawRow__far
;src/keyboard/test.c:56: for (i = 0; i < count; ++i) {
	ld	hl, sp+77
	inc	[hl]
	jp	.l00133
;src/keyboard/test.c:66: while ((event = KBPopEvent())) {
.l00162:
.l00118:
	call	_KBPopEvent
	ld	hl, sp+74
	ld	[hl], c
	inc	hl
	ld	[hl], b
	ld	a, b
	or	a, c
	jp	Z, .l00120
;src/keyboard/test.c:67: end = PutText(text, "Key ");
	ld	bc, _src_keyboard_test_c___str_13
	ld	hl, 22
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_PutText__far
;src/keyboard/test.c:68: end = PutHex(end, (unsigned char)event);
	ld	hl, sp+74
	ld	a, [hl]
	inc	hl
	inc	hl
	ld	[hl], a
	ld	a, [hl]
	ld	e, c
	ld	d, b
	call	_src_keyboard_test_c_PutHex
	ld	hl, sp+77
	ld	[hl], c
	inc	hl
	ld	[hl], b
;src/keyboard/test.c:69: if ((unsigned char)event >= ' ' && (unsigned char)event < KEY_LEFT) *end++ = ' ', *end++ = (unsigned char)event;
	dec	hl
	dec	hl
	ld	a, [hl]
	sub	a, $20
	jp	C, .l00116
	ld	a, [hl]
	sub	a, $80
	jp	NC, .l00116
	inc	hl
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	ld	[hl], $20
	ld	hl, sp+77
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	inc	bc
	dec	hl
	dec	hl
	ld	a, [hl]
	ld	[bc], a
	inc	bc
	inc	hl
	ld	[hl], c
	inc	hl
	ld	[hl], b
.l00116:
;src/keyboard/test.c:70: end = PutText(end, "   modifiers ");
	ld	bc, _src_keyboard_test_c___str_14
	ld	hl, sp+77
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_PutText__far
;src/keyboard/test.c:71: end = PutHex(end, event >> 8);
	ld	hl, sp+75
	ld	e, [hl]
	ld	a, e
	ld	e, c
	ld	d, b
	call	_src_keyboard_test_c_PutHex
;src/keyboard/test.c:72: *end = 0;
	xor	a, a
	ld	[bc], a
;src/keyboard/test.c:73: DrawRow(3, 0, text);
	ld	hl, 22
	add	hl, sp
	push	hl
	ld	e, $00
	ld	a, $03
	call	_DrawRow__far
	jp	.l00118
.l00120:
;src/keyboard/test.c:75: EditorDraw();
	call	_EditorDraw
;src/keyboard/test.c:76: WaitFrame();
	call	_WaitFrame
;src/keyboard/test.c:77: if (PadPressed() & (PADF_B | PADF_START)) break;
	call	_PadPressed
	and	a, $0A
	jp	NZ,.l00268
	jp	.l00124
.l00268:
;src/keyboard/test.c:79: font = editor_font;
	ld	hl, sp+64
	ld	a, [hl]
	ld	hl, _font
	ld	[hl], a
;src/keyboard/test.c:80: SetFont(font);
	ld	a, [hl]
	call	_SetFont
;src/keyboard/test.c:81: render_text = 1;
	ld	hl, _render_text
	ld	[hl], $01
;src/keyboard/test.c:82: EndFullScreen();
	call	_EndFullScreen__far
.l00135:
;src/keyboard/test.c:83: }
	add	sp, 79
	ret
	SECTION FRAGMENT "src/keyboard/test.c FIXED",ROMX,BANK[1]
_src_keyboard_test_c___str_5:
	DB "KEYBOARD TEST"
	DB $00
	SECTION FRAGMENT "src/keyboard/test.c FIXED",ROMX,BANK[1]
_src_keyboard_test_c___str_6:
	DB "Found at boot: PS/2"
	DB $00
	SECTION FRAGMENT "src/keyboard/test.c FIXED",ROMX,BANK[1]
_src_keyboard_test_c___str_7:
	DB "Found at boot: iGKB"
	DB $00
	SECTION FRAGMENT "src/keyboard/test.c FIXED",ROMX,BANK[1]
_src_keyboard_test_c___str_8:
	DB "Found at boot: none, listening anyway"
	DB $00
	SECTION FRAGMENT "src/keyboard/test.c FIXED",ROMX,BANK[1]
_src_keyboard_test_c___str_9:
	DB "Scan codes (newest last):"
	DB $00
	SECTION FRAGMENT "src/keyboard/test.c FIXED",ROMX,BANK[1]
_src_keyboard_test_c___str_10:
	DB "B or Start: back"
	DB $00
	SECTION FRAGMENT "src/keyboard/test.c FIXED",ROMX,BANK[1]
_src_keyboard_test_c___str_11:
	DB "Bytes "
	DB $00
	SECTION FRAGMENT "src/keyboard/test.c FIXED",ROMX,BANK[1]
_src_keyboard_test_c___str_12:
	DB "   with errors "
	DB $00
	SECTION FRAGMENT "src/keyboard/test.c FIXED",ROMX,BANK[1]
_src_keyboard_test_c___str_13:
	DB "Key "
	DB $00
	SECTION FRAGMENT "src/keyboard/test.c FIXED",ROMX,BANK[1]
_src_keyboard_test_c___str_14:
	DB "   modifiers "
	DB $00
	SECTION FRAGMENT "src/keyboard/test.c FIXED",ROMX,BANK[1]
	SECTION FRAGMENT "_INITIALIZER",ROM0
	SECTION FRAGMENT "_CABS (ABS)",ROM0
