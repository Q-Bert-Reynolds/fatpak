;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 4.2.0 #13081 (Linux)
;--------------------------------------------------------
	; MODULE editor
	; Generated using the rgbds tokens.

;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	EXPORT _tb_Render
	EXPORT _tb_NextRow
	EXPORT _tb_RowStart
	EXPORT _tb_Delete
	EXPORT _tb_Insert
	EXPORT _tb_GetChar
	EXPORT _tb_Length
	EXPORT _OSKGetKey
	EXPORT _OSKSelect
	EXPORT _OSKDraw
	EXPORT _OSKShow
	EXPORT _EditorShowCursor
	EXPORT _EditorDraw
	EXPORT _WaitFrame
	EXPORT _EditorSetup
	EXPORT _KBPopEvent
	EXPORT _PadPressed
	EXPORT _osk_y
	EXPORT _osk_x
	EXPORT _osk_layer
	EXPORT _osk_shown
	EXPORT _dirty
	EXPORT _blink_timer
	EXPORT _pad_timer
	EXPORT _want_col
	EXPORT _top
	EXPORT _cursor
	EXPORT _Editor
;--------------------------------------------------------
; special function registers
;--------------------------------------------------------
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	SECTION FRAGMENT "src/editor/editor.c_DATA",WRAMX
_cursor:
	DS 2
_top:
	DS 2
_want_col:
	DS 1
_pad_timer:
	DS 1
_blink_timer:
	DS 1
_dirty:
	DS 1
_osk_shown:
	DS 1
_osk_layer:
	DS 1
_osk_x:
	DS 1
_osk_y:
	DS 1
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
	SECTION FRAGMENT "src/editor/editor.c_HOME",ROM0
	SECTION FRAGMENT "src/editor/editor.c_HOME",ROM0
;--------------------------------------------------------
; code
;--------------------------------------------------------
	SECTION FRAGMENT "src/editor/editor.c_CODE",ROMX
;src/editor/editor.c:31: static unsigned char IsLastRow(unsigned int row, unsigned int next) {
;	---------------------------------
; Function IsLastRow
; ---------------------------------
_IsLastRow:
;src/editor/editor.c:32: return next == tb_Length() && (next == row || tb_GetChar(next - 1) != ASCII_LF);
	push	bc
	push	de
	call	_tb_Length
	ld	l, c
;	spillPairReg hl
;	spillPairReg hl
	ld	h, b
;	spillPairReg hl
;	spillPairReg hl
	pop	de
	pop	bc
	ld	a, l
	sub	a, c
	jp	NZ,.l00120
	ld	a, h
	sub	a, b
	jp	NZ,.l00120
	jp	.l00121
.l00120:
	jp	.l00103
.l00121:
	ld	a, c
	sub	a, e
	jp	NZ,.l00122
	ld	a, b
	sub	a, d
	jp	NZ,.l00122
	jp	.l00104
.l00122:
	dec	bc
	ld	e, c
	ld	d, b
	call	_tb_GetChar
	sub	a, $0A
	jp	NZ,.l00123
	jp	.l00124
.l00123:
	jp	.l00104
.l00124:
.l00103:
	xor	a, a
	jp	.l00105
.l00104:
	ld	a, $01
.l00105:
.l00101:
;src/editor/editor.c:33: }
	ret
;src/editor/editor.c:36: static unsigned int PosAtCol(unsigned int row, unsigned char col) {
;	---------------------------------
; Function PosAtCol
; ---------------------------------
_PosAtCol:
	add	sp, -6
	ld	hl, sp+2
	ld	[hl], e
	inc	hl
	ld	[hl], d
	ld	c, a
;src/editor/editor.c:37: unsigned int next = tb_NextRow(row);
	push	bc
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_tb_NextRow
	ld	e, c
	ld	d, b
	pop	bc
	inc	sp
	inc	sp
	push	de
;src/editor/editor.c:38: unsigned int pos = row;
	pop	hl
	pop	de
	push	de
	push	hl
;src/editor/editor.c:39: while (col && pos != next) {
	ld	hl, sp+2
	ld	a, [hl]
	inc	hl
	inc	hl
	ld	[hl], a
	dec	hl
	ld	a, [hl]
	inc	hl
	inc	hl
	ld	[hl], a
.l00104:
	ld	a, c
	or	a, a
	jp	Z, .l00106
	ld	hl, sp+4
	ld	a, [hl]
	ld	hl, sp+0
	sub	a, [hl]
	jp	NZ,.l00142
	ld	hl, sp+5
	ld	a, [hl]
	ld	hl, sp+1
	sub	a, [hl]
	jp	NZ,.l00142
	jp	.l00106
.l00142:
;src/editor/editor.c:40: if (tb_GetChar(pos) == ASCII_LF) return pos;
	push	bc
	push	de
	ld	hl, sp+8
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_tb_GetChar
	pop	de
	pop	bc
	sub	a, $0A
	jp	NZ,.l00143
	jp	.l00144
.l00143:
	jp	.l00102
.l00144:
	ld	c, e
	ld	b, d
	jp	.l00110
.l00102:
;src/editor/editor.c:41: ++pos;
	ld	hl, sp+4
	inc	[hl]
	jp	NZ, .l00145
	inc	hl
	inc	[hl]
.l00145:
	ld	hl, sp+4
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
;src/editor/editor.c:42: --col;
	dec	c
	jp	.l00104
.l00106:
;src/editor/editor.c:44: if (pos == next && !IsLastRow(row, next)) --pos; // stay on wrapped row
	ld	hl, sp+0
	ld	a, [hl]
	sub	a, e
	jp	NZ,.l00146
	inc	hl
	ld	a, [hl]
	sub	a, d
	jp	NZ,.l00146
	jp	.l00147
.l00146:
	jp	.l00108
.l00147:
	push	de
	pop	hl
	pop	bc
	push	bc
	push	hl
	ld	hl, sp+4
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_IsLastRow
	pop	de
	or	a, a
	jp	NZ, .l00108
	dec	de
.l00108:
;src/editor/editor.c:45: return pos;
	ld	c, e
	ld	b, d
.l00110:
;src/editor/editor.c:46: }
	add	sp, 6
	ret
;src/editor/editor.c:48: static void MoveUp(void) {
;	---------------------------------
; Function MoveUp
; ---------------------------------
_MoveUp:
;src/editor/editor.c:49: unsigned int row = tb_RowStart(cursor);
	ld	hl, _cursor
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_tb_RowStart
	ld	e, c
	ld	d, b
;src/editor/editor.c:50: if (row == 0) cursor = 0;
	ld	a, b
	or	a, c
	jp	NZ, .l00102
	xor	a, a
	ld	hl, _cursor
	ld	[hl], a
	inc	hl
	ld	[hl], a
	jp	.l00104
.l00102:
;src/editor/editor.c:51: else cursor = PosAtCol(tb_RowStart(row - 1), want_col);
	dec	de
	call	_tb_RowStart
	ld	hl, _want_col
	ld	a, [hl]
	ld	e, c
	ld	d, b
	call	_PosAtCol
	ld	hl, _cursor
	ld	[hl], c
	inc	hl
	ld	[hl], b
.l00104:
;src/editor/editor.c:52: }
	ret
;src/editor/editor.c:54: static void MoveDown(void) {
;	---------------------------------
; Function MoveDown
; ---------------------------------
_MoveDown:
;src/editor/editor.c:55: unsigned int row = tb_RowStart(cursor);
	ld	hl, _cursor
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_tb_RowStart
	ld	l, c
;	spillPairReg hl
;	spillPairReg hl
	ld	h, b
;	spillPairReg hl
;	spillPairReg hl
;src/editor/editor.c:56: unsigned int next = tb_NextRow(row);
	push	hl
	ld	e, l
	ld	d, h
	call	_tb_NextRow
	pop	hl
	ld	e, c
	ld	d, b
;src/editor/editor.c:57: if (IsLastRow(row, next)) cursor = tb_Length();
	push	de
	ld	c, e
	ld	b, d
	ld	e, l
	ld	d, h
	call	_IsLastRow
	pop	de
	or	a, a
	jp	Z, .l00102
	call	_tb_Length
	ld	hl, _cursor
	ld	[hl], c
	inc	hl
	ld	[hl], b
	jp	.l00104
.l00102:
;src/editor/editor.c:58: else cursor = PosAtCol(next, want_col);
	ld	hl, _want_col
	ld	a, [hl]
	call	_PosAtCol
	ld	hl, _cursor
	ld	[hl], c
	inc	hl
	ld	[hl], b
.l00104:
;src/editor/editor.c:59: }
	ret
;src/editor/editor.c:62: static void MoveEnd(void) {
;	---------------------------------
; Function MoveEnd
; ---------------------------------
_MoveEnd:
;src/editor/editor.c:63: unsigned int row = tb_RowStart(cursor);
	ld	hl, _cursor
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_tb_RowStart
	ld	e, c
	ld	d, b
;src/editor/editor.c:64: unsigned int next = tb_NextRow(row);
	push	de
	call	_tb_NextRow
	pop	de
	ld	l, c
;	spillPairReg hl
;	spillPairReg hl
	ld	h, b
;	spillPairReg hl
;	spillPairReg hl
;src/editor/editor.c:66: cursor = next;
	ld	a, l
	ld	[_cursor], a
	ld	a, h
	ld	[_cursor + 1], a
;src/editor/editor.c:67: if (IsLastRow(row, next)) return;
	push	hl
	ld	c, l
	ld	b, h
	call	_IsLastRow
	pop	hl
	or	a, a
	jp	Z, .l00102
	jp	.l00106
.l00102:
;src/editor/editor.c:68: c = tb_GetChar(next - 1);
	ld	e, l
	ld	d, h
	dec	de
	call	_tb_GetChar
;src/editor/editor.c:69: if (c == ' ' || c == ASCII_LF) --cursor;
	cp	a, $20
	jp	NZ,.l00118
	jp	.l00103
.l00118:
	sub	a, $0A
	jp	NZ,.l00119
	jp	.l00120
.l00119:
	jp	.l00106
.l00120:
.l00103:
	ld	hl, _cursor + 1
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	dec	de
	dec	hl
	ld	[hl], e
	inc	hl
	ld	[hl], d
.l00106:
;src/editor/editor.c:70: }
	ret
;src/editor/editor.c:72: static void HandleKey(unsigned char key, unsigned char mods) {
;	---------------------------------
; Function HandleKey
; ---------------------------------
_HandleKey:
	ld	c, a
;src/editor/editor.c:74: if (mods & (KB_MOD_CTRL | KB_MOD_ALT | KB_MOD_SUPER)) return; // TODO: shortcuts
	ld	a, e
	and	a, $38
	jp	NZ,.l00274
	jp	.l00102
.l00274:
	jp	.l00140
.l00102:
;src/editor/editor.c:76: switch (key) {
	ld	a, c
	sub	a, $08
	jp	NZ,.l00275
	jp	.l00117
.l00275:
	ld	a, c
	sub	a, $1B
	jp	NZ,.l00276
	jp	.l00122
.l00276:
	ld	a, c
	sub	a, $7F
	jp	NZ,.l00277
	jp	.l00120
.l00277:
	ld	a, c
	sub	a, $80
	jp	NZ,.l00278
	jp	.l00109
.l00278:
	ld	a, c
	sub	a, $81
	jp	NZ,.l00279
	jp	.l00112
.l00279:
	ld	a, c
	sub	a, $82
	jp	NZ,.l00280
	jp	.l00103
.l00280:
	ld	a, c
	sub	a, $83
	jp	NZ,.l00281
	jp	.l00104
.l00281:
	ld	a, c
	sub	a, $84
	jp	NZ,.l00282
	jp	.l00115
.l00282:
	ld	a, c
	sub	a, $85
	jp	NZ,.l00283
	jp	.l00116
.l00283:
	ld	a, c
	sub	a, $86
	jp	NZ,.l00284
	jp	.l00105
.l00284:
	ld	a, c
	sub	a, $87
	jp	NZ,.l00285
	jp	.l00107
.l00285:
	ld	a, c
	sub	a, $88
	jp	NZ,.l00286
	jp	.l00122
.l00286:
	jp	.l00123
;src/editor/editor.c:77: case KEY_UP: MoveUp(); return;
.l00103:
	jp	_MoveUp
	jp	.l00140
;src/editor/editor.c:78: case KEY_DOWN: MoveDown(); return;
.l00104:
	jp	_MoveDown
	jp	.l00140
;src/editor/editor.c:79: case KEY_PAGE_UP: for (i = tb_rows - 1; i; --i) MoveUp(); return;
.l00105:
	ld	hl, _tb_rows
	ld	c, [hl]
	dec	c
.l00135:
	ld	a, c
	or	a, a
	jp	Z, .l00106
	push	bc
	call	_MoveUp
	pop	bc
	dec	c
	jp	.l00135
.l00106:
	jp	.l00140
;src/editor/editor.c:80: case KEY_PAGE_DOWN: for (i = tb_rows - 1; i; --i) MoveDown(); return;
.l00107:
	ld	hl, _tb_rows
	ld	c, [hl]
	dec	c
.l00138:
	ld	a, c
	or	a, a
	jp	Z, .l00108
	push	bc
	call	_MoveDown
	pop	bc
	dec	c
	jp	.l00138
.l00108:
	jp	.l00140
;src/editor/editor.c:81: case KEY_LEFT: if (cursor) --cursor; break;
.l00109:
	ld	hl, _cursor + 1
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	jp	Z, .l00133
	inc	hl
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	dec	de
	dec	hl
	ld	[hl], e
	inc	hl
	ld	[hl], d
	jp	.l00133
;src/editor/editor.c:82: case KEY_RIGHT: if (cursor != tb_Length()) ++cursor; break;
.l00112:
	call	_tb_Length
	ld	hl, _cursor
	ld	a, [hl]
	sub	a, c
	jp	NZ,.l00287
	inc	hl
	ld	a, [hl]
	sub	a, b
	jp	NZ,.l00287
	jp	.l00133
.l00287:
	ld	hl, _cursor
	inc	[hl]
	jp	NZ, .l00288
	inc	hl
	inc	[hl]
.l00288:
	jp	.l00133
;src/editor/editor.c:83: case KEY_HOME: cursor = tb_RowStart(cursor); break;
.l00115:
	ld	hl, _cursor
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_tb_RowStart
	ld	hl, _cursor
	ld	[hl], c
	inc	hl
	ld	[hl], b
	jp	.l00133
;src/editor/editor.c:84: case KEY_END: MoveEnd(); break;
.l00116:
	call	_MoveEnd
	jp	.l00133
;src/editor/editor.c:85: case KEY_BACKSPACE: if (cursor) tb_Delete(--cursor); break;
.l00117:
	ld	hl, _cursor + 1
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	jp	Z, .l00133
	inc	hl
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	dec	de
	dec	hl
	ld	[hl], e
	inc	hl
	ld	[hl], d
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_tb_Delete
	jp	.l00133
;src/editor/editor.c:86: case KEY_DELETE: tb_Delete(cursor); break;
.l00120:
	ld	hl, _cursor
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_tb_Delete
	jp	.l00133
;src/editor/editor.c:88: case KEY_INSERT: return;
.l00122:
	jp	.l00140
;src/editor/editor.c:89: default:
.l00123:
;src/editor/editor.c:90: if (key < ' ' && key != ASCII_TAB && key != ASCII_LF) return;
	ld	a, c
	sub	a, $20
	jp	NC, .l00125
	ld	a, c
	sub	a, $09
	jp	NZ,.l00289
	jp	.l00125
.l00289:
	ld	a, c
	sub	a, $0A
	jp	NZ,.l00290
	jp	.l00125
.l00290:
	jp	.l00140
.l00125:
;src/editor/editor.c:91: if (key >= KEY_LEFT && key < 0xA0) return; // unprintable in Latin-1
	ld	a, c
	sub	a, $80
	jp	C, .l00129
	ld	a, c
	sub	a, $A0
	jp	NC, .l00129
	jp	.l00140
.l00129:
;src/editor/editor.c:92: if (tb_Insert(cursor, key)) ++cursor;
	ld	a, c
	ld	hl, _cursor
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_tb_Insert
	or	a, a
	jp	Z, .l00133
	ld	hl, _cursor
	inc	[hl]
	jp	NZ, .l00291
	inc	hl
	inc	[hl]
.l00291:
;src/editor/editor.c:93: }
.l00133:
;src/editor/editor.c:94: want_col = (unsigned char)(cursor - tb_RowStart(cursor));
	ld	hl, _cursor
	ld	e, [hl]
	push	de
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_tb_RowStart
	pop	de
	ld	a, e
	sub	a, c
	ld	hl, _want_col
	ld	[hl], a
.l00140:
;src/editor/editor.c:95: }
	ret
;src/editor/editor.c:98: static unsigned char DpadRepeat(unsigned char pressed) {
;	---------------------------------
; Function DpadRepeat
; ---------------------------------
_DpadRepeat:
	ld	c, a
;src/editor/editor.c:99: unsigned char held = (button_state | pressed) & PADF_DPAD;
	ld	hl, _button_state
	ld	a, [hl]
	or	a, c
	and	a, $F0
	ld	b, a
;src/editor/editor.c:100: if (!held) return 0;
	or	a, a
	jp	NZ, .l00102
	xor	a, a
	jp	.l00109
.l00102:
;src/editor/editor.c:101: if (pressed & PADF_DPAD) pad_timer = PAD_REPEAT_DELAY;
	ld	a, c
	and	a, $F0
	jp	NZ,.l00126
	jp	.l00107
.l00126:
	ld	hl, _pad_timer
	ld	[hl], $14
	jp	.l00108
.l00107:
;src/editor/editor.c:102: else if (--pad_timer) return 0;
	ld	hl, _pad_timer
	dec	[hl]
	ld	a, [hl]
	or	a, a
	jp	Z, .l00104
	xor	a, a
	jp	.l00109
.l00104:
;src/editor/editor.c:103: else pad_timer = PAD_REPEAT_RATE;
	ld	hl, _pad_timer
	ld	[hl], $04
.l00108:
;src/editor/editor.c:104: return held;
	ld	a, b
.l00109:
;src/editor/editor.c:105: }
	ret
;src/editor/editor.c:107: static void ToggleOSK(void) {
;	---------------------------------
; Function ToggleOSK
; ---------------------------------
_ToggleOSK:
;src/editor/editor.c:108: osk_shown = !osk_shown;
	ld	hl, _osk_shown
	ld	a, [hl]
	sub	a,$01
	ld	a, $00
	rla
	ld	[hl], a
;src/editor/editor.c:109: tb_rows = osk_shown ? TB_ROWS - OSK_ROWS : TB_ROWS;
	ld	a, [hl]
	or	a, a
	jp	Z, .l00105
	ld	bc, $000D
	jp	.l00106
.l00105:
	ld	bc, $0012
.l00106:
	ld	hl, _tb_rows
	ld	[hl], c
;src/editor/editor.c:110: if (osk_shown) {
	ld	hl, _osk_shown
	ld	a, [hl]
	or	a, a
	jp	Z, .l00102
;src/editor/editor.c:111: OSKDraw(osk_layer);
	ld	hl, _osk_layer
	ld	a, [hl]
	call	_OSKDraw
;src/editor/editor.c:112: OSKSelect(osk_x, osk_y);
	ld	hl, _osk_y
	ld	e, [hl]
	ld	hl, _osk_x
	ld	a, [hl]
	call	_OSKSelect
.l00102:
;src/editor/editor.c:114: OSKShow(osk_shown);
	ld	hl, _osk_shown
	ld	a, [hl]
	call	_OSKShow
;src/editor/editor.c:115: dirty = 1;
	ld	hl, _dirty
	ld	[hl], $01
.l00103:
;src/editor/editor.c:116: }
	ret
;src/editor/editor.c:118: static void SetOSKLayer(unsigned char layer) {
;	---------------------------------
; Function SetOSKLayer
; ---------------------------------
_SetOSKLayer:
	ld	c, a
;src/editor/editor.c:119: osk_layer = osk_layer == layer ? OSK_LOWER : layer;
	ld	hl, _osk_layer
	ld	a, [hl]
	sub	a, c
	jp	NZ,.l00110
	jp	.l00111
.l00110:
	jp	.l00103
.l00111:
	xor	a, a
	ld	l, a
;	spillPairReg hl
;	spillPairReg hl
	jp	.l00104
.l00103:
	ld	a, c
	ld	l, $00
;	spillPairReg hl
;	spillPairReg hl
.l00104:
	ld	[_osk_layer], a
;src/editor/editor.c:120: OSKDraw(osk_layer);
	ld	hl, _osk_layer
	ld	a, [hl]
	jp	_OSKDraw
.l00101:
;src/editor/editor.c:121: }
	ret
;src/editor/editor.c:123: static unsigned char PressOSKKey(void) {
;	---------------------------------
; Function PressOSKKey
; ---------------------------------
_PressOSKKey:
;src/editor/editor.c:125: if (osk_y == OSK_ROWS - 1) {
	ld	hl, _osk_y
	ld	a, [hl]
	sub	a, $04
	jp	NZ,.l00149
	jp	.l00150
.l00149:
	jp	.l00114
.l00150:
;src/editor/editor.c:126: if (osk_x == 0) SetOSKLayer(OSK_SHIFT);
	ld	hl, _osk_x
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00111
	ld	a, $01
	call	_SetOSKLayer
	jp	.l00112
.l00111:
;src/editor/editor.c:127: else if (osk_x == 1) SetOSKLayer(OSK_SYMBOLS);
	ld	hl, _osk_x
	ld	a, [hl]
	dec	a
	jp	NZ,.l00151
	jp	.l00152
.l00151:
	jp	.l00108
.l00152:
	ld	a, $02
	call	_SetOSKLayer
	jp	.l00112
.l00108:
;src/editor/editor.c:128: else if (osk_x == OSK_COLS - 2) return KEY_LEFT;
	ld	hl, _osk_x
	ld	a, [hl]
	sub	a, $08
	jp	NZ,.l00153
	jp	.l00154
.l00153:
	jp	.l00105
.l00154:
	ld	a, $80
	jp	.l00117
.l00105:
;src/editor/editor.c:129: else if (osk_x == OSK_COLS - 1) return KEY_RIGHT;
	ld	hl, _osk_x
	ld	a, [hl]
	sub	a, $09
	jp	NZ,.l00155
	jp	.l00156
.l00155:
	jp	.l00102
.l00156:
	ld	a, $81
	jp	.l00117
.l00102:
;src/editor/editor.c:130: else return ' ';
	ld	a, $20
	jp	.l00117
.l00112:
;src/editor/editor.c:131: return KEY_NONE;
	xor	a, a
	jp	.l00117
.l00114:
;src/editor/editor.c:133: key = OSKGetKey(osk_layer, (osk_y << 3) + (osk_y << 1) + osk_x);
	ld	hl, _osk_y
	ld	c, [hl]
	ld	a, c
	add	a, a
	add	a, a
	add	a, a
	sla	c
	add	a, c
	ld	hl, _osk_x
	ld	c, [hl]
	add	a, c
	ld	e, a
	ld	hl, _osk_layer
	ld	a, [hl]
	call	_OSKGetKey
	ld	c, a
;src/editor/editor.c:134: if (osk_layer == OSK_SHIFT) SetOSKLayer(OSK_SHIFT); // shift is one shot
	ld	hl, _osk_layer
	ld	a, [hl]
	dec	a
	jp	NZ,.l00157
	jp	.l00158
.l00157:
	jp	.l00116
.l00158:
	push	bc
	ld	a, $01
	call	_SetOSKLayer
	pop	bc
.l00116:
;src/editor/editor.c:135: return key;
	ld	a, c
.l00117:
;src/editor/editor.c:136: }
	ret
;src/editor/editor.c:138: static void MoveOSKSelection(unsigned char held) {
;	---------------------------------
; Function MoveOSKSelection
; ---------------------------------
_MoveOSKSelection:
	ld	c, a
;src/editor/editor.c:139: if (held & PADF_UP) osk_y = osk_y ? osk_y - 1 : OSK_ROWS - 1;
	ld	hl, _osk_y
	ld	b, [hl]
	bit	6, c
	jp	NZ,.l00161
	jp	.l00104
.l00161:
	ld	hl, _osk_y
	ld	a, [hl]
	or	a, a
	jp	Z, .l00113
	dec	b
	jp	.l00114
.l00113:
	ld	b, $04
.l00114:
	ld	hl, _osk_y
	ld	[hl], b
	jp	.l00105
.l00104:
;src/editor/editor.c:140: else if (held & PADF_DOWN) osk_y = osk_y == OSK_ROWS - 1 ? 0 : osk_y + 1;
	bit	7, c
	jp	NZ,.l00162
	jp	.l00105
.l00162:
	ld	hl, _osk_y
	ld	a, [hl]
	sub	a, $04
	jp	NZ,.l00163
	jp	.l00164
.l00163:
	jp	.l00115
.l00164:
	ld	b, $00
	xor	a, a
	jp	.l00116
.l00115:
	inc	b
	ld	a, b
	rlca
	sbc	a, a
.l00116:
	ld	hl, _osk_y
	ld	[hl], b
.l00105:
;src/editor/editor.c:141: if (held & PADF_LEFT) osk_x = osk_x ? osk_x - 1 : OSK_COLS - 1;
	ld	hl, _osk_x
	ld	e, [hl]
	bit	5, c
	jp	NZ,.l00165
	jp	.l00109
.l00165:
	ld	hl, _osk_x
	ld	a, [hl]
	or	a, a
	jp	Z, .l00117
	dec	e
	jp	.l00118
.l00117:
	ld	e, $09
.l00118:
	ld	hl, _osk_x
	ld	[hl], e
	jp	.l00110
.l00109:
;src/editor/editor.c:142: else if (held & PADF_RIGHT) osk_x = osk_x == OSK_COLS - 1 ? 0 : osk_x + 1;
	bit	4, c
	jp	NZ,.l00166
	jp	.l00110
.l00166:
	ld	hl, _osk_x
	ld	a, [hl]
	sub	a, $09
	jp	NZ,.l00167
	jp	.l00168
.l00167:
	jp	.l00119
.l00168:
	ld	e, $00
	xor	a, a
	jp	.l00120
.l00119:
	inc	e
	ld	a, e
	rlca
	sbc	a, a
.l00120:
	ld	hl, _osk_x
	ld	[hl], e
.l00110:
;src/editor/editor.c:143: OSKSelect(osk_x, osk_y);
	ld	hl, _osk_y
	ld	e, [hl]
	ld	hl, _osk_x
	ld	a, [hl]
	jp	_OSKSelect
.l00111:
;src/editor/editor.c:144: }
	ret
;src/editor/editor.c:148: static unsigned char PadKey(void) {
;	---------------------------------
; Function PadKey
; ---------------------------------
_PadKey:
;src/editor/editor.c:149: unsigned char pressed = PadPressed();
	call	_PadPressed
	ld	c, a
;src/editor/editor.c:151: if (pressed & PADF_SELECT) ToggleOSK();
	bit	2, c
	jp	NZ,.l00172
	jp	.l00102
.l00172:
	push	bc
	call	_ToggleOSK
	pop	bc
.l00102:
;src/editor/editor.c:152: if (pressed & PADF_B) return KEY_BACKSPACE;
	bit	1, c
	jp	NZ,.l00173
	jp	.l00104
.l00173:
	ld	a, $08
	jp	.l00120
.l00104:
;src/editor/editor.c:153: if (pressed & PADF_START) return KEY_ENTER;
	bit	3, c
	jp	NZ,.l00174
	jp	.l00106
.l00174:
	ld	a, $0A
	jp	.l00120
.l00106:
;src/editor/editor.c:154: if (osk_shown && (pressed & PADF_A)) return PressOSKKey();
	ld	hl, _osk_shown
	ld	a, [hl]
	or	a, a
	jp	Z, .l00108
	bit	0, c
	jp	NZ,.l00175
	jp	.l00108
.l00175:
	jp	_PressOSKKey
	jp	.l00120
.l00108:
;src/editor/editor.c:155: held = DpadRepeat(pressed);
	ld	a, c
	call	_DpadRepeat
	ld	c, a
;src/editor/editor.c:156: if (!held) return KEY_NONE;
	ld	a, c
	or	a, a
	jp	NZ, .l00111
	xor	a, a
	jp	.l00120
.l00111:
;src/editor/editor.c:157: if (osk_shown) {
	ld	hl, _osk_shown
	ld	a, [hl]
	or	a, a
	jp	Z, .l00113
;src/editor/editor.c:158: MoveOSKSelection(held);
	ld	a, c
	call	_MoveOSKSelection
;src/editor/editor.c:159: return KEY_NONE;
	xor	a, a
	jp	.l00120
.l00113:
;src/editor/editor.c:161: if (held & PADF_UP) return KEY_UP;
	bit	6, c
	jp	NZ,.l00176
	jp	.l00115
.l00176:
	ld	a, $82
	jp	.l00120
.l00115:
;src/editor/editor.c:162: if (held & PADF_DOWN) return KEY_DOWN;
	bit	7, c
	jp	NZ,.l00177
	jp	.l00117
.l00177:
	ld	a, $83
	jp	.l00120
.l00117:
;src/editor/editor.c:163: if (held & PADF_LEFT) return KEY_LEFT;
	bit	5, c
	jp	NZ,.l00178
	jp	.l00119
.l00178:
	ld	a, $80
	jp	.l00120
.l00119:
;src/editor/editor.c:164: return KEY_RIGHT;
	ld	a, $81
.l00120:
;src/editor/editor.c:165: }
	ret
;src/editor/editor.c:167: static void Render(void) {
;	---------------------------------
; Function Render
; ---------------------------------
_Render:
;src/editor/editor.c:168: tb_find = cursor;
	ld	hl, _cursor
	ld	a, [hl]
	ld	hl, _tb_find
	ld	[hl], a
	ld	hl, _cursor + 1
	ld	a, [hl]
	ld	hl, _tb_find + 1
	ld	[hl], a
;src/editor/editor.c:169: tb_Render(top);
	ld	hl, _top
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	jp	_tb_Render
.l00101:
;src/editor/editor.c:170: }
	ret
;src/editor/editor.c:173: static void Refresh(void) {
;	---------------------------------
; Function Refresh
; ---------------------------------
_Refresh:
	dec	sp
;src/editor/editor.c:176: if (top > tb_Length()) top = tb_Length();
	call	_tb_Length
	ld	hl, _top
	ld	a, c
	sub	a, [hl]
	inc	hl
	ld	a, b
	sbc	a, [hl]
	jp	NC, .l00102
	call	_tb_Length
	ld	hl, _top
	ld	[hl], c
	inc	hl
	ld	[hl], b
.l00102:
;src/editor/editor.c:177: top = tb_RowStart(top); // wrapping may have changed
	ld	hl, _top
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_tb_RowStart
	ld	hl, _top
	ld	[hl], c
	inc	hl
	ld	[hl], b
;src/editor/editor.c:178: Render();
	call	_Render
;src/editor/editor.c:179: if (tb_found_row == 0xFF) {
	ld	hl, _tb_found_row
	ld	a, [hl]
	inc	a
	jp	NZ,.l00154
	jp	.l00155
.l00154:
	jp	.l00112
.l00155:
;src/editor/editor.c:180: row = tb_RowStart(cursor);
	ld	hl, _cursor
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_tb_RowStart
;src/editor/editor.c:181: if (cursor < top) top = row;
	ld	de, _cursor
	ld	hl, _top
	ld	a, [de]
	inc	de
	sub	a, [hl]
	inc	hl
	ld	a, [de]
	sbc	a, [hl]
	jp	NC, .l00109
	ld	hl, _top
	ld	[hl], c
	inc	hl
	ld	[hl], b
	jp	.l00110
.l00109:
;src/editor/editor.c:183: bottom = tb_bottom;
	ld	hl, _tb_bottom
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
;src/editor/editor.c:184: for (i = tb_rows; i; --i) {
	ld	hl, _tb_rows
	ld	a, [hl]
	ld	hl, sp+0
	ld	[hl], a
.l00114:
	ld	hl, sp+0
	ld	a, [hl]
	or	a, a
	jp	Z, .l00105
;src/editor/editor.c:185: top = tb_NextRow(top);
	push	bc
	push	de
	ld	hl, _top
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_tb_NextRow
	ld	l, c
;	spillPairReg hl
;	spillPairReg hl
	ld	h, b
;	spillPairReg hl
;	spillPairReg hl
	pop	de
	pop	bc
	ld	a, l
	ld	[_top], a
	ld	a, h
	ld	[_top + 1], a
;src/editor/editor.c:186: if (bottom == row) break;
	ld	a, e
	sub	a, c
	jp	NZ,.l00156
	ld	a, d
	sub	a, b
	jp	NZ,.l00156
	jp	.l00105
.l00156:
;src/editor/editor.c:187: bottom = tb_NextRow(bottom);
	push	bc
	call	_tb_NextRow
	ld	e, c
	ld	d, b
	pop	bc
;src/editor/editor.c:184: for (i = tb_rows; i; --i) {
	ld	hl, sp+0
	dec	[hl]
	jp	.l00114
.l00105:
;src/editor/editor.c:189: if (!i) top = row;
	ld	hl, sp+0
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00110
	ld	hl, _top
	ld	[hl], c
	inc	hl
	ld	[hl], b
.l00110:
;src/editor/editor.c:191: Render();
	call	_Render
.l00112:
;src/editor/editor.c:193: EditorDraw();
	call	_EditorDraw
;src/editor/editor.c:194: blink_timer = 0;
	ld	hl, _blink_timer
	ld	[hl], $00
;src/editor/editor.c:195: EditorShowCursor(1);
	ld	a, $01
	inc	sp
	jp	_EditorShowCursor
.l00116:
;src/editor/editor.c:196: }
	inc	sp
	ret
;src/editor/editor.c:198: void Editor(void) {
;	---------------------------------
; Function Editor
; ---------------------------------
_Editor::
;src/editor/editor.c:202: EditorSetup();
	call	_EditorSetup
;src/editor/editor.c:203: cursor = 0;
	xor	a, a
	ld	hl, _cursor
	ld	[hl], a
	inc	hl
	ld	[hl], a
;src/editor/editor.c:204: top = 0;
	xor	a, a
	ld	hl, _top
	ld	[hl], a
	inc	hl
	ld	[hl], a
;src/editor/editor.c:205: want_col = 0;
	ld	hl, _want_col
	ld	[hl], $00
;src/editor/editor.c:206: pad_timer = 0;
	ld	hl, _pad_timer
	ld	[hl], $00
;src/editor/editor.c:207: osk_shown = 0;
	ld	hl, _osk_shown
	ld	[hl], $00
;src/editor/editor.c:208: osk_layer = OSK_LOWER;
	ld	hl, _osk_layer
	ld	[hl], $00
;src/editor/editor.c:209: osk_x = 0;
	ld	hl, _osk_x
	ld	[hl], $00
;src/editor/editor.c:210: osk_y = 0;
	ld	hl, _osk_y
	ld	[hl], $00
;src/editor/editor.c:211: tb_rows = TB_ROWS;
	ld	hl, _tb_rows
	ld	[hl], $12
;src/editor/editor.c:212: Refresh();
	call	_Refresh
;src/editor/editor.c:214: while (1) {
.l00115:
;src/editor/editor.c:215: WaitFrame();
	call	_WaitFrame
;src/editor/editor.c:216: while ((key = (unsigned char)(event = KBPopEvent()))) {
.l00101:
	call	_KBPopEvent
	ld	l, c
;	spillPairReg hl
;	spillPairReg hl
	ld	c, l
	ld	e, b
	ld	a, l
	ld	l, a
;	spillPairReg hl
;	spillPairReg hl
	or	a, a
	jp	Z, .l00103
;src/editor/editor.c:217: HandleKey(key, (unsigned char)(event >> 8));
	ld	a, l
	call	_HandleKey
;src/editor/editor.c:218: dirty = 1;
	ld	hl, _dirty
	ld	[hl], $01
	jp	.l00101
.l00103:
;src/editor/editor.c:220: if ((key = PadKey())) {
	call	_PadKey
	ld	c, a
	or	a, a
	jp	Z, .l00105
;src/editor/editor.c:221: HandleKey(key, 0);
	ld	e, $00
	ld	a, c
	call	_HandleKey
;src/editor/editor.c:222: dirty = 1;
	ld	hl, _dirty
	ld	[hl], $01
.l00105:
;src/editor/editor.c:224: if (dirty) {
	ld	hl, _dirty
	ld	a, [hl]
	or	a, a
	jp	Z, .l00112
;src/editor/editor.c:225: Refresh();
	call	_Refresh
;src/editor/editor.c:226: dirty = 0;
	ld	hl, _dirty
	ld	[hl], $00
	jp	.l00115
.l00112:
;src/editor/editor.c:228: else if (++blink_timer == CURSOR_BLINK) EditorShowCursor(0);
	ld	hl, _blink_timer
	inc	[hl]
	ld	a, [hl]
	sub	a, $1E
	jp	NZ,.l00154
	jp	.l00155
.l00154:
	jp	.l00109
.l00155:
	xor	a, a
	call	_EditorShowCursor
	jp	.l00115
.l00109:
;src/editor/editor.c:229: else if (blink_timer == CURSOR_BLINK + CURSOR_BLINK) {
	ld	hl, _blink_timer
	ld	a, [hl]
	sub	a, $3C
	jp	NZ,.l00156
	jp	.l00157
.l00156:
	jp	.l00115
.l00157:
;src/editor/editor.c:230: EditorShowCursor(1);
	ld	a, $01
	call	_EditorShowCursor
;src/editor/editor.c:231: blink_timer = 0;
	ld	hl, _blink_timer
	ld	[hl], $00
	jp	.l00115
.l00117:
;src/editor/editor.c:234: }
	ret
	SECTION FRAGMENT "src/editor/editor.c_CODE",ROMX
	SECTION FRAGMENT "_INITIALIZER",ROM0
	SECTION FRAGMENT "_CABS (ABS)",ROM0
