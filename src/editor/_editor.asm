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
	EXPORT _EditorShowCursor
	EXPORT _EditorDraw
	EXPORT _WaitFrame
	EXPORT _EditorSetup
	EXPORT _KBPopEvent
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
;src/editor/editor.c:26: static unsigned char IsLastRow(unsigned int row, unsigned int next) {
;	---------------------------------
; Function IsLastRow
; ---------------------------------
_IsLastRow:
;src/editor/editor.c:27: return next == tb_Length() && (next == row || tb_GetChar(next - 1) != ASCII_LF);
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
;src/editor/editor.c:28: }
	ret
;src/editor/editor.c:31: static unsigned int PosAtCol(unsigned int row, unsigned char col) {
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
;src/editor/editor.c:32: unsigned int next = tb_NextRow(row);
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
;src/editor/editor.c:33: unsigned int pos = row;
	pop	hl
	pop	de
	push	de
	push	hl
;src/editor/editor.c:34: while (col && pos != next) {
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
;src/editor/editor.c:35: if (tb_GetChar(pos) == ASCII_LF) return pos;
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
;src/editor/editor.c:36: ++pos;
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
;src/editor/editor.c:37: --col;
	dec	c
	jp	.l00104
.l00106:
;src/editor/editor.c:39: if (pos == next && !IsLastRow(row, next)) --pos; // stay on wrapped row
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
;src/editor/editor.c:40: return pos;
	ld	c, e
	ld	b, d
.l00110:
;src/editor/editor.c:41: }
	add	sp, 6
	ret
;src/editor/editor.c:43: static void MoveUp(void) {
;	---------------------------------
; Function MoveUp
; ---------------------------------
_MoveUp:
;src/editor/editor.c:44: unsigned int row = tb_RowStart(cursor);
	ld	hl, _cursor
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_tb_RowStart
	ld	e, c
	ld	d, b
;src/editor/editor.c:45: if (row == 0) cursor = 0;
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
;src/editor/editor.c:46: else cursor = PosAtCol(tb_RowStart(row - 1), want_col);
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
;src/editor/editor.c:47: }
	ret
;src/editor/editor.c:49: static void MoveDown(void) {
;	---------------------------------
; Function MoveDown
; ---------------------------------
_MoveDown:
;src/editor/editor.c:50: unsigned int row = tb_RowStart(cursor);
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
;src/editor/editor.c:51: unsigned int next = tb_NextRow(row);
	push	hl
	ld	e, l
	ld	d, h
	call	_tb_NextRow
	pop	hl
	ld	e, c
	ld	d, b
;src/editor/editor.c:52: if (IsLastRow(row, next)) cursor = tb_Length();
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
;src/editor/editor.c:53: else cursor = PosAtCol(next, want_col);
	ld	hl, _want_col
	ld	a, [hl]
	call	_PosAtCol
	ld	hl, _cursor
	ld	[hl], c
	inc	hl
	ld	[hl], b
.l00104:
;src/editor/editor.c:54: }
	ret
;src/editor/editor.c:57: static void MoveEnd(void) {
;	---------------------------------
; Function MoveEnd
; ---------------------------------
_MoveEnd:
;src/editor/editor.c:58: unsigned int row = tb_RowStart(cursor);
	ld	hl, _cursor
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_tb_RowStart
	ld	e, c
	ld	d, b
;src/editor/editor.c:59: unsigned int next = tb_NextRow(row);
	push	de
	call	_tb_NextRow
	pop	de
	ld	l, c
;	spillPairReg hl
;	spillPairReg hl
	ld	h, b
;	spillPairReg hl
;	spillPairReg hl
;src/editor/editor.c:61: cursor = next;
	ld	a, l
	ld	[_cursor], a
	ld	a, h
	ld	[_cursor + 1], a
;src/editor/editor.c:62: if (IsLastRow(row, next)) return;
	push	hl
	ld	c, l
	ld	b, h
	call	_IsLastRow
	pop	hl
	or	a, a
	jp	Z, .l00102
	jp	.l00106
.l00102:
;src/editor/editor.c:63: c = tb_GetChar(next - 1);
	ld	e, l
	ld	d, h
	dec	de
	call	_tb_GetChar
;src/editor/editor.c:64: if (c == ' ' || c == ASCII_LF) --cursor;
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
;src/editor/editor.c:65: }
	ret
;src/editor/editor.c:67: static void HandleKey(unsigned char key, unsigned char mods) {
;	---------------------------------
; Function HandleKey
; ---------------------------------
_HandleKey:
	ld	c, a
;src/editor/editor.c:69: if (mods & (KB_MOD_CTRL | KB_MOD_ALT | KB_MOD_SUPER)) return; // TODO: shortcuts
	ld	a, e
	and	a, $38
	jp	NZ,.l00272
	jp	.l00102
.l00272:
	jp	.l00138
.l00102:
;src/editor/editor.c:71: switch (key) {
	ld	a, c
	sub	a, $08
	jp	NZ,.l00273
	jp	.l00117
.l00273:
	ld	a, c
	sub	a, $1B
	jp	NZ,.l00274
	jp	.l00122
.l00274:
	ld	a, c
	sub	a, $7F
	jp	NZ,.l00275
	jp	.l00120
.l00275:
	ld	a, c
	sub	a, $80
	jp	NZ,.l00276
	jp	.l00109
.l00276:
	ld	a, c
	sub	a, $81
	jp	NZ,.l00277
	jp	.l00112
.l00277:
	ld	a, c
	sub	a, $82
	jp	NZ,.l00278
	jp	.l00103
.l00278:
	ld	a, c
	sub	a, $83
	jp	NZ,.l00279
	jp	.l00104
.l00279:
	ld	a, c
	sub	a, $84
	jp	NZ,.l00280
	jp	.l00115
.l00280:
	ld	a, c
	sub	a, $85
	jp	NZ,.l00281
	jp	.l00116
.l00281:
	ld	a, c
	sub	a, $86
	jp	NZ,.l00282
	jp	.l00153
.l00282:
	ld	a, c
	sub	a, $87
	jp	NZ,.l00283
	jp	.l00155
.l00283:
	ld	a, c
	sub	a, $88
	jp	NZ,.l00284
	jp	.l00122
.l00284:
	jp	.l00123
;src/editor/editor.c:72: case KEY_UP: MoveUp(); return;
.l00103:
	jp	_MoveUp
	jp	.l00138
;src/editor/editor.c:73: case KEY_DOWN: MoveDown(); return;
.l00104:
	jp	_MoveDown
	jp	.l00138
;src/editor/editor.c:74: case KEY_PAGE_UP: for (i = TB_ROWS - 1; i; --i) MoveUp(); return;
.l00153:
	ld	c, $11
.l00134:
	push	bc
	call	_MoveUp
	pop	bc
	dec	c
	ld	a, c
	or	a, a
	jp	NZ, .l00134
	jp	.l00138
;src/editor/editor.c:75: case KEY_PAGE_DOWN: for (i = TB_ROWS - 1; i; --i) MoveDown(); return;
.l00155:
	ld	c, $11
.l00136:
	push	bc
	call	_MoveDown
	pop	bc
	dec	c
	ld	a, c
	or	a, a
	jp	NZ, .l00136
	jp	.l00138
;src/editor/editor.c:76: case KEY_LEFT: if (cursor) --cursor; break;
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
;src/editor/editor.c:77: case KEY_RIGHT: if (cursor != tb_Length()) ++cursor; break;
.l00112:
	call	_tb_Length
	ld	hl, _cursor
	ld	a, [hl]
	sub	a, c
	jp	NZ,.l00285
	inc	hl
	ld	a, [hl]
	sub	a, b
	jp	NZ,.l00285
	jp	.l00133
.l00285:
	ld	hl, _cursor
	inc	[hl]
	jp	NZ, .l00286
	inc	hl
	inc	[hl]
.l00286:
	jp	.l00133
;src/editor/editor.c:78: case KEY_HOME: cursor = tb_RowStart(cursor); break;
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
;src/editor/editor.c:79: case KEY_END: MoveEnd(); break;
.l00116:
	call	_MoveEnd
	jp	.l00133
;src/editor/editor.c:80: case KEY_BACKSPACE: if (cursor) tb_Delete(--cursor); break;
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
;src/editor/editor.c:81: case KEY_DELETE: tb_Delete(cursor); break;
.l00120:
	ld	hl, _cursor
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_tb_Delete
	jp	.l00133
;src/editor/editor.c:83: case KEY_INSERT: return;
.l00122:
	jp	.l00138
;src/editor/editor.c:84: default:
.l00123:
;src/editor/editor.c:85: if (key < ' ' && key != ASCII_TAB && key != ASCII_LF) return;
	ld	a, c
	sub	a, $20
	jp	NC, .l00125
	ld	a, c
	sub	a, $09
	jp	NZ,.l00287
	jp	.l00125
.l00287:
	ld	a, c
	sub	a, $0A
	jp	NZ,.l00288
	jp	.l00125
.l00288:
	jp	.l00138
.l00125:
;src/editor/editor.c:86: if (key >= KEY_LEFT && key < 0xA0) return; // unprintable in Latin-1
	ld	a, c
	sub	a, $80
	jp	C, .l00129
	ld	a, c
	sub	a, $A0
	jp	NC, .l00129
	jp	.l00138
.l00129:
;src/editor/editor.c:87: if (tb_Insert(cursor, key)) ++cursor;
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
	jp	NZ, .l00289
	inc	hl
	inc	[hl]
.l00289:
;src/editor/editor.c:88: }
.l00133:
;src/editor/editor.c:89: want_col = (unsigned char)(cursor - tb_RowStart(cursor));
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
.l00138:
;src/editor/editor.c:90: }
	ret
;src/editor/editor.c:93: static unsigned char PadKey(void) {
;	---------------------------------
; Function PadKey
; ---------------------------------
_PadKey:
;src/editor/editor.c:94: unsigned char pressed = button_state & ~last_button_state;
	ld	hl, _last_button_state
	ld	a, [hl]
	cpl
	ld	hl, _button_state
	and	a, [hl]
	ld	c, a
;src/editor/editor.c:95: unsigned char held = button_state & PADF_DPAD;
	ld	a, [hl]
	and	a, $F0
	ld	b, a
;src/editor/editor.c:96: if (pressed & PADF_B) return KEY_BACKSPACE;
	bit	1, c
	jp	NZ,.l00161
	jp	.l00102
.l00161:
	ld	a, $08
	jp	.l00119
.l00102:
;src/editor/editor.c:97: if (pressed & PADF_START) return KEY_ENTER;
	bit	3, c
	jp	NZ,.l00162
	jp	.l00104
.l00162:
	ld	a, $0A
	jp	.l00119
.l00104:
;src/editor/editor.c:98: if (!held) return KEY_NONE;
	ld	a, b
	or	a, a
	jp	NZ, .l00106
	xor	a, a
	jp	.l00119
.l00106:
;src/editor/editor.c:99: if (pressed & PADF_DPAD) pad_timer = PAD_REPEAT_DELAY;
	ld	a, c
	and	a, $F0
	jp	NZ,.l00163
	jp	.l00111
.l00163:
	ld	hl, _pad_timer
	ld	[hl], $14
	jp	.l00112
.l00111:
;src/editor/editor.c:100: else if (--pad_timer) return KEY_NONE;
	ld	hl, _pad_timer
	dec	[hl]
	ld	a, [hl]
	or	a, a
	jp	Z, .l00108
	xor	a, a
	jp	.l00119
.l00108:
;src/editor/editor.c:101: else pad_timer = PAD_REPEAT_RATE;
	ld	hl, _pad_timer
	ld	[hl], $04
.l00112:
;src/editor/editor.c:102: if (held & PADF_UP) return KEY_UP;
	bit	6, b
	jp	NZ,.l00164
	jp	.l00114
.l00164:
	ld	a, $82
	jp	.l00119
.l00114:
;src/editor/editor.c:103: if (held & PADF_DOWN) return KEY_DOWN;
	bit	7, b
	jp	NZ,.l00165
	jp	.l00116
.l00165:
	ld	a, $83
	jp	.l00119
.l00116:
;src/editor/editor.c:104: if (held & PADF_LEFT) return KEY_LEFT;
	bit	5, b
	jp	NZ,.l00166
	jp	.l00118
.l00166:
	ld	a, $80
	jp	.l00119
.l00118:
;src/editor/editor.c:105: return KEY_RIGHT;
	ld	a, $81
.l00119:
;src/editor/editor.c:106: }
	ret
;src/editor/editor.c:108: static void Render(void) {
;	---------------------------------
; Function Render
; ---------------------------------
_Render:
;src/editor/editor.c:109: tb_find = cursor;
	ld	hl, _cursor
	ld	a, [hl]
	ld	hl, _tb_find
	ld	[hl], a
	ld	hl, _cursor + 1
	ld	a, [hl]
	ld	hl, _tb_find + 1
	ld	[hl], a
;src/editor/editor.c:110: tb_Render(top);
	ld	hl, _top
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	jp	_tb_Render
.l00101:
;src/editor/editor.c:111: }
	ret
;src/editor/editor.c:114: static void Refresh(void) {
;	---------------------------------
; Function Refresh
; ---------------------------------
_Refresh:
	dec	sp
;src/editor/editor.c:117: if (top > tb_Length()) top = tb_Length();
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
;src/editor/editor.c:118: top = tb_RowStart(top); // wrapping may have changed
	ld	hl, _top
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_tb_RowStart
	ld	hl, _top
	ld	[hl], c
	inc	hl
	ld	[hl], b
;src/editor/editor.c:119: Render();
	call	_Render
;src/editor/editor.c:120: if (tb_found_row == 0xFF) {
	ld	hl, _tb_found_row
	ld	a, [hl]
	inc	a
	jp	NZ,.l00148
	jp	.l00149
.l00148:
	jp	.l00112
.l00149:
;src/editor/editor.c:121: row = tb_RowStart(cursor);
	ld	hl, _cursor
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_tb_RowStart
;src/editor/editor.c:122: if (cursor < top) top = row;
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
;src/editor/editor.c:124: bottom = tb_bottom;
	ld	hl, _tb_bottom
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
;src/editor/editor.c:125: for (i = TB_ROWS; i; --i) {
	ld	hl, sp+0
	ld	[hl], $12
.l00113:
;src/editor/editor.c:126: top = tb_NextRow(top);
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
;src/editor/editor.c:127: if (bottom == row) break;
	ld	a, e
	sub	a, c
	jp	NZ,.l00150
	ld	a, d
	sub	a, b
	jp	NZ,.l00150
	jp	.l00105
.l00150:
;src/editor/editor.c:128: bottom = tb_NextRow(bottom);
	push	bc
	call	_tb_NextRow
	ld	e, c
	ld	d, b
	pop	bc
;src/editor/editor.c:125: for (i = TB_ROWS; i; --i) {
	ld	hl, sp+0
	dec	[hl]
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00113
.l00105:
;src/editor/editor.c:130: if (!i) top = row;
	ld	hl, sp+0
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00110
	ld	hl, _top
	ld	[hl], c
	inc	hl
	ld	[hl], b
.l00110:
;src/editor/editor.c:132: Render();
	call	_Render
.l00112:
;src/editor/editor.c:134: EditorDraw();
	call	_EditorDraw
;src/editor/editor.c:135: blink_timer = 0;
	ld	hl, _blink_timer
	ld	[hl], $00
;src/editor/editor.c:136: EditorShowCursor(1);
	ld	a, $01
	inc	sp
	jp	_EditorShowCursor
.l00115:
;src/editor/editor.c:137: }
	inc	sp
	ret
;src/editor/editor.c:139: void Editor(void) {
;	---------------------------------
; Function Editor
; ---------------------------------
_Editor::
;src/editor/editor.c:143: EditorSetup();
	call	_EditorSetup
;src/editor/editor.c:144: cursor = 0;
	xor	a, a
	ld	hl, _cursor
	ld	[hl], a
	inc	hl
	ld	[hl], a
;src/editor/editor.c:145: top = 0;
	xor	a, a
	ld	hl, _top
	ld	[hl], a
	inc	hl
	ld	[hl], a
;src/editor/editor.c:146: want_col = 0;
	ld	hl, _want_col
	ld	[hl], $00
;src/editor/editor.c:147: pad_timer = 0;
	ld	hl, _pad_timer
	ld	[hl], $00
;src/editor/editor.c:148: Refresh();
	call	_Refresh
;src/editor/editor.c:150: while (1) {
.l00115:
;src/editor/editor.c:151: WaitFrame();
	call	_WaitFrame
;src/editor/editor.c:152: dirty = 0;
	ld	l, $00
;	spillPairReg hl
;	spillPairReg hl
;src/editor/editor.c:153: while ((key = (unsigned char)(event = KBPopEvent()))) {
.l00101:
	push	hl
	call	_KBPopEvent
	pop	hl
	ld	e, c
	ld	d, b
	ld	a, c
	ld	c, a
	or	a, a
	jp	Z, .l00103
;src/editor/editor.c:154: HandleKey(key, (unsigned char)(event >> 8));
	ld	e, d
	ld	a, c
	call	_HandleKey
;src/editor/editor.c:155: dirty = 1;
	ld	l, $01
;	spillPairReg hl
;	spillPairReg hl
	jp	.l00101
.l00103:
;src/editor/editor.c:157: if ((key = PadKey())) {
	push	hl
	call	_PadKey
	pop	hl
	ld	c, a
	or	a, a
	jp	Z, .l00105
;src/editor/editor.c:158: HandleKey(key, 0);
	ld	e, $00
	ld	a, c
	call	_HandleKey
;src/editor/editor.c:159: dirty = 1;
	ld	l, $01
;	spillPairReg hl
;	spillPairReg hl
.l00105:
;src/editor/editor.c:161: if (dirty) Refresh();
	ld	a, l
	or	a, a
	jp	Z, .l00112
	call	_Refresh
	jp	.l00115
.l00112:
;src/editor/editor.c:162: else if (++blink_timer == CURSOR_BLINK) EditorShowCursor(0);
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
;src/editor/editor.c:163: else if (blink_timer == CURSOR_BLINK + CURSOR_BLINK) {
	ld	hl, _blink_timer
	ld	a, [hl]
	sub	a, $3C
	jp	NZ,.l00156
	jp	.l00157
.l00156:
	jp	.l00115
.l00157:
;src/editor/editor.c:164: EditorShowCursor(1);
	ld	a, $01
	call	_EditorShowCursor
;src/editor/editor.c:165: blink_timer = 0;
	ld	hl, _blink_timer
	ld	[hl], $00
	jp	.l00115
.l00117:
;src/editor/editor.c:168: }
	ret
	SECTION FRAGMENT "src/editor/editor.c_CODE",ROMX
	SECTION FRAGMENT "_INITIALIZER",ROM0
	SECTION FRAGMENT "_CABS (ABS)",ROM0
