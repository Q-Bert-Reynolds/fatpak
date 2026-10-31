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
	EXPORT _tb_NormalizeStep
	EXPORT _tb_Delete
	EXPORT _tb_Insert
	EXPORT _tb_GetChar
	EXPORT _tb_Length
	EXPORT _tb_Clear
	EXPORT _FileSave
	EXPORT _FileLoad
	EXPORT _FileNext
	EXPORT _FileOpenDir
	EXPORT _FileMount
	EXPORT _sd_Detect
	EXPORT _OSKGetKey
	EXPORT _OSKSelect
	EXPORT _OSKDraw
	EXPORT _OSKShow
	EXPORT _EditorDraw
	EXPORT _SetFont
	EXPORT _EditorShowCursor
	EXPORT _WaitFrame
	EXPORT _EditorSetup
	EXPORT _KBPopEvent
	EXPORT _PadPressed
	EXPORT _file_list
	EXPORT _file_name
	EXPORT _normalized
	EXPORT _idle_frames
	EXPORT _everdrive
	EXPORT _font
	EXPORT _modified
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
	SECTION FRAGMENT "src/editor/editor.c_DATA",WRAM0
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
_modified:
	DS 1
_font:
	DS 1
_everdrive:
	DS 1
_idle_frames:
	DS 1
_normalized:
	DS 1
_file_name:
	DS 13
_file_list:
	DS 208
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
;src/editor/editor.c:55: static unsigned char IsLastRow(unsigned int row, unsigned int next) {
;	---------------------------------
; Function IsLastRow
; ---------------------------------
_IsLastRow:
;src/editor/editor.c:56: return next == tb_Length() && (next == row || tb_GetChar(next - 1) != ASCII_LF);
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
;src/editor/editor.c:57: }
	ret
_menu_items:
	DB "OPEN"
	DB $00
	DB $00
	DB $00
	DB $00
	DB $00
	DB $00
	DB $00
	DB $00
	DB $00
	DB "SAVE"
	DB $00
	DB $00
	DB $00
	DB $00
	DB $00
	DB $00
	DB $00
	DB $00
	DB $00
	DB "SAVE AS"
	DB $00
	DB $00
	DB $00
	DB $00
	DB $00
	DB $00
	DB "NEW"
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
	DB "FONT"
	DB $00
	DB $00
	DB $00
	DB $00
	DB $00
	DB $00
	DB $00
	DB $00
	DB $00
_discard_items:
	DB "NO"
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
	DB "YES"
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
;src/editor/editor.c:60: static unsigned int PosAtCol(unsigned int row, unsigned char col) {
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
;src/editor/editor.c:61: unsigned int next = tb_NextRow(row);
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
;src/editor/editor.c:62: unsigned int pos = row;
	pop	hl
	pop	de
	push	de
	push	hl
;src/editor/editor.c:63: while (col && pos != next) {
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
;src/editor/editor.c:64: if (tb_GetChar(pos) == ASCII_LF) return pos;
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
;src/editor/editor.c:65: ++pos;
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
;src/editor/editor.c:66: --col;
	dec	c
	jp	.l00104
.l00106:
;src/editor/editor.c:68: if (pos == next && !IsLastRow(row, next)) --pos; // stay on wrapped row
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
;src/editor/editor.c:69: return pos;
	ld	c, e
	ld	b, d
.l00110:
;src/editor/editor.c:70: }
	add	sp, 6
	ret
;src/editor/editor.c:72: static void MoveUp(void) {
;	---------------------------------
; Function MoveUp
; ---------------------------------
_MoveUp:
;src/editor/editor.c:73: unsigned int row = tb_RowStart(cursor);
	ld	hl, _cursor
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_tb_RowStart
	ld	e, c
	ld	d, b
;src/editor/editor.c:74: if (row == 0) cursor = 0;
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
;src/editor/editor.c:75: else cursor = PosAtCol(tb_RowStart(row - 1), want_col);
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
;src/editor/editor.c:76: }
	ret
;src/editor/editor.c:78: static void MoveDown(void) {
;	---------------------------------
; Function MoveDown
; ---------------------------------
_MoveDown:
;src/editor/editor.c:79: unsigned int row = tb_RowStart(cursor);
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
;src/editor/editor.c:80: unsigned int next = tb_NextRow(row);
	push	hl
	ld	e, l
	ld	d, h
	call	_tb_NextRow
	pop	hl
	ld	e, c
	ld	d, b
;src/editor/editor.c:81: if (IsLastRow(row, next)) cursor = tb_Length();
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
;src/editor/editor.c:82: else cursor = PosAtCol(next, want_col);
	ld	hl, _want_col
	ld	a, [hl]
	call	_PosAtCol
	ld	hl, _cursor
	ld	[hl], c
	inc	hl
	ld	[hl], b
.l00104:
;src/editor/editor.c:83: }
	ret
;src/editor/editor.c:86: static void MoveEnd(void) {
;	---------------------------------
; Function MoveEnd
; ---------------------------------
_MoveEnd:
;src/editor/editor.c:87: unsigned int row = tb_RowStart(cursor);
	ld	hl, _cursor
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_tb_RowStart
	ld	e, c
	ld	d, b
;src/editor/editor.c:88: unsigned int next = tb_NextRow(row);
	push	de
	call	_tb_NextRow
	pop	de
	ld	l, c
;	spillPairReg hl
;	spillPairReg hl
	ld	h, b
;	spillPairReg hl
;	spillPairReg hl
;src/editor/editor.c:90: cursor = next;
	ld	a, l
	ld	[_cursor], a
	ld	a, h
	ld	[_cursor + 1], a
;src/editor/editor.c:91: if (IsLastRow(row, next)) return;
	push	hl
	ld	c, l
	ld	b, h
	call	_IsLastRow
	pop	hl
	or	a, a
	jp	Z, .l00102
	jp	.l00106
.l00102:
;src/editor/editor.c:92: c = tb_GetChar(next - 1);
	ld	e, l
	ld	d, h
	dec	de
	call	_tb_GetChar
;src/editor/editor.c:93: if (c == ' ' || c == ASCII_LF) --cursor;
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
;src/editor/editor.c:94: }
	ret
;src/editor/editor.c:96: static void HandleKey(unsigned char key, unsigned char mods) {
;	---------------------------------
; Function HandleKey
; ---------------------------------
_HandleKey:
	ld	c, a
;src/editor/editor.c:98: if (mods & (KB_MOD_CTRL | KB_MOD_ALT | KB_MOD_SUPER)) return; // TODO: shortcuts
	ld	a, e
	and	a, $38
	jp	NZ,.l00287
	jp	.l00102
.l00287:
	jp	.l00143
.l00102:
;src/editor/editor.c:100: switch (key) {
	ld	a, c
	sub	a, $08
	jp	NZ,.l00288
	jp	.l00117
.l00288:
	ld	a, c
	sub	a, $1B
	jp	NZ,.l00289
	jp	.l00125
.l00289:
	ld	a, c
	sub	a, $7F
	jp	NZ,.l00290
	jp	.l00121
.l00290:
	ld	a, c
	sub	a, $80
	jp	NZ,.l00291
	jp	.l00109
.l00291:
	ld	a, c
	sub	a, $81
	jp	NZ,.l00292
	jp	.l00112
.l00292:
	ld	a, c
	sub	a, $82
	jp	NZ,.l00293
	jp	.l00103
.l00293:
	ld	a, c
	sub	a, $83
	jp	NZ,.l00294
	jp	.l00104
.l00294:
	ld	a, c
	sub	a, $84
	jp	NZ,.l00295
	jp	.l00115
.l00295:
	ld	a, c
	sub	a, $85
	jp	NZ,.l00296
	jp	.l00116
.l00296:
	ld	a, c
	sub	a, $86
	jp	NZ,.l00297
	jp	.l00105
.l00297:
	ld	a, c
	sub	a, $87
	jp	NZ,.l00298
	jp	.l00107
.l00298:
	ld	a, c
	sub	a, $88
	jp	NZ,.l00299
	jp	.l00125
.l00299:
	jp	.l00126
;src/editor/editor.c:101: case KEY_UP: MoveUp(); return;
.l00103:
	jp	_MoveUp
	jp	.l00143
;src/editor/editor.c:102: case KEY_DOWN: MoveDown(); return;
.l00104:
	jp	_MoveDown
	jp	.l00143
;src/editor/editor.c:103: case KEY_PAGE_UP: for (i = tb_rows - 1; i; --i) MoveUp(); return;
.l00105:
	ld	hl, _tb_rows
	ld	c, [hl]
	dec	c
.l00138:
	ld	a, c
	or	a, a
	jp	Z, .l00106
	push	bc
	call	_MoveUp
	pop	bc
	dec	c
	jp	.l00138
.l00106:
	jp	.l00143
;src/editor/editor.c:104: case KEY_PAGE_DOWN: for (i = tb_rows - 1; i; --i) MoveDown(); return;
.l00107:
	ld	hl, _tb_rows
	ld	c, [hl]
	dec	c
.l00141:
	ld	a, c
	or	a, a
	jp	Z, .l00108
	push	bc
	call	_MoveDown
	pop	bc
	dec	c
	jp	.l00141
.l00108:
	jp	.l00143
;src/editor/editor.c:105: case KEY_LEFT: if (cursor) --cursor; break;
.l00109:
	ld	hl, _cursor + 1
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	jp	Z, .l00136
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
	jp	.l00136
;src/editor/editor.c:106: case KEY_RIGHT: if (cursor != tb_Length()) ++cursor; break;
.l00112:
	call	_tb_Length
	ld	hl, _cursor
	ld	a, [hl]
	sub	a, c
	jp	NZ,.l00300
	inc	hl
	ld	a, [hl]
	sub	a, b
	jp	NZ,.l00300
	jp	.l00136
.l00300:
	ld	hl, _cursor
	inc	[hl]
	jp	NZ, .l00301
	inc	hl
	inc	[hl]
.l00301:
	jp	.l00136
;src/editor/editor.c:107: case KEY_HOME: cursor = tb_RowStart(cursor); break;
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
	jp	.l00136
;src/editor/editor.c:108: case KEY_END: MoveEnd(); break;
.l00116:
	call	_MoveEnd
	jp	.l00136
;src/editor/editor.c:109: case KEY_BACKSPACE:
.l00117:
;src/editor/editor.c:110: if (cursor && tb_Delete(--cursor)) modified = 1;
	ld	hl, _cursor + 1
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	jp	Z, .l00136
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
	or	a, a
	jp	Z, .l00136
	ld	hl, _modified
	ld	[hl], $01
;src/editor/editor.c:111: break;
	jp	.l00136
;src/editor/editor.c:112: case KEY_DELETE:
.l00121:
;src/editor/editor.c:113: if (tb_Delete(cursor)) modified = 1;
	ld	hl, _cursor
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_tb_Delete
	or	a, a
	jp	Z, .l00136
	ld	hl, _modified
	ld	[hl], $01
;src/editor/editor.c:114: break;
	jp	.l00136
;src/editor/editor.c:116: case KEY_INSERT: return;
.l00125:
	jp	.l00143
;src/editor/editor.c:117: default:
.l00126:
;src/editor/editor.c:118: if (key < ' ' && key != ASCII_TAB && key != ASCII_LF) return;
	ld	a, c
	sub	a, $20
	jp	NC, .l00128
	ld	a, c
	sub	a, $09
	jp	NZ,.l00302
	jp	.l00128
.l00302:
	ld	a, c
	sub	a, $0A
	jp	NZ,.l00303
	jp	.l00128
.l00303:
	jp	.l00143
.l00128:
;src/editor/editor.c:119: if (key >= KEY_LEFT && key < 0xA0) return; // unprintable in Latin-1
	ld	a, c
	sub	a, $80
	jp	C, .l00132
	ld	a, c
	sub	a, $A0
	jp	NC, .l00132
	jp	.l00143
.l00132:
;src/editor/editor.c:120: if (tb_Insert(cursor, key)) {
	ld	a, c
	ld	hl, _cursor
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_tb_Insert
	or	a, a
	jp	Z, .l00136
;src/editor/editor.c:121: ++cursor;
	ld	hl, _cursor
	inc	[hl]
	jp	NZ, .l00304
	inc	hl
	inc	[hl]
.l00304:
;src/editor/editor.c:122: modified = 1;
	ld	hl, _modified
	ld	[hl], $01
;src/editor/editor.c:124: }
.l00136:
;src/editor/editor.c:125: want_col = (unsigned char)(cursor - tb_RowStart(cursor));
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
.l00143:
;src/editor/editor.c:126: }
	ret
;src/editor/editor.c:129: static unsigned char DpadRepeat(unsigned char pressed) {
;	---------------------------------
; Function DpadRepeat
; ---------------------------------
_DpadRepeat:
	ld	c, a
;src/editor/editor.c:130: unsigned char held = (button_state | pressed) & PADF_DPAD;
	ld	hl, _button_state
	ld	a, [hl]
	or	a, c
	and	a, $F0
	ld	b, a
;src/editor/editor.c:131: if (!held) return 0;
	or	a, a
	jp	NZ, .l00102
	xor	a, a
	jp	.l00109
.l00102:
;src/editor/editor.c:132: if (pressed & PADF_DPAD) pad_timer = PAD_REPEAT_DELAY;
	ld	a, c
	and	a, $F0
	jp	NZ,.l00126
	jp	.l00107
.l00126:
	ld	hl, _pad_timer
	ld	[hl], $14
	jp	.l00108
.l00107:
;src/editor/editor.c:133: else if (--pad_timer) return 0;
	ld	hl, _pad_timer
	dec	[hl]
	ld	a, [hl]
	or	a, a
	jp	Z, .l00104
	xor	a, a
	jp	.l00109
.l00104:
;src/editor/editor.c:134: else pad_timer = PAD_REPEAT_RATE;
	ld	hl, _pad_timer
	ld	[hl], $04
.l00108:
;src/editor/editor.c:135: return held;
	ld	a, b
.l00109:
;src/editor/editor.c:136: }
	ret
;src/editor/editor.c:138: static void ToggleOSK(void) {
;	---------------------------------
; Function ToggleOSK
; ---------------------------------
_ToggleOSK:
;src/editor/editor.c:139: osk_shown = !osk_shown;
	ld	hl, _osk_shown
	ld	a, [hl]
	sub	a,$01
	ld	a, $00
	rla
	ld	[hl], a
;src/editor/editor.c:140: tb_rows = osk_shown ? TB_ROWS - OSK_ROWS : TB_ROWS;
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
;src/editor/editor.c:141: if (osk_shown) {
	ld	hl, _osk_shown
	ld	a, [hl]
	or	a, a
	jp	Z, .l00102
;src/editor/editor.c:142: OSKDraw(osk_layer);
	ld	hl, _osk_layer
	ld	a, [hl]
	call	_OSKDraw
;src/editor/editor.c:143: OSKSelect(osk_x, osk_y);
	ld	hl, _osk_y
	ld	e, [hl]
	ld	hl, _osk_x
	ld	a, [hl]
	call	_OSKSelect
.l00102:
;src/editor/editor.c:145: OSKShow(osk_shown);
	ld	hl, _osk_shown
	ld	a, [hl]
	call	_OSKShow
;src/editor/editor.c:146: dirty = 1;
	ld	hl, _dirty
	ld	[hl], $01
.l00103:
;src/editor/editor.c:147: }
	ret
;src/editor/editor.c:149: static void SetOSKLayer(unsigned char layer) {
;	---------------------------------
; Function SetOSKLayer
; ---------------------------------
_SetOSKLayer:
	ld	c, a
;src/editor/editor.c:150: osk_layer = osk_layer == layer ? OSK_LOWER : layer;
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
;src/editor/editor.c:151: OSKDraw(osk_layer);
	ld	hl, _osk_layer
	ld	a, [hl]
	call	_OSKDraw
;src/editor/editor.c:152: dirty = 1;
	ld	hl, _dirty
	ld	[hl], $01
.l00101:
;src/editor/editor.c:153: }
	ret
;src/editor/editor.c:155: static unsigned char PressOSKKey(void) {
;	---------------------------------
; Function PressOSKKey
; ---------------------------------
_PressOSKKey:
;src/editor/editor.c:157: if (osk_y == OSK_ROWS - 1) {
	ld	hl, _osk_y
	ld	a, [hl]
	sub	a, $04
	jp	NZ,.l00157
	jp	.l00158
.l00157:
	jp	.l00117
.l00158:
;src/editor/editor.c:158: if (osk_x == 0) SetOSKLayer(OSK_SHIFT);
	ld	hl, _osk_x
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00114
	ld	a, $01
	call	_SetOSKLayer
	jp	.l00115
.l00114:
;src/editor/editor.c:159: else if (osk_x == 1) SetOSKLayer(OSK_SYMBOLS);
	ld	hl, _osk_x
	ld	a, [hl]
	dec	a
	jp	NZ,.l00159
	jp	.l00160
.l00159:
	jp	.l00111
.l00160:
	ld	a, $02
	call	_SetOSKLayer
	jp	.l00115
.l00111:
;src/editor/editor.c:160: else if (osk_x == OSK_COLS - 3) return KEY_MENU;
	ld	hl, _osk_x
	ld	a, [hl]
	sub	a, $07
	jp	NZ,.l00161
	jp	.l00162
.l00161:
	jp	.l00108
.l00162:
	ld	a, $89
	jp	.l00120
.l00108:
;src/editor/editor.c:161: else if (osk_x == OSK_COLS - 2) return KEY_LEFT;
	ld	hl, _osk_x
	ld	a, [hl]
	sub	a, $08
	jp	NZ,.l00163
	jp	.l00164
.l00163:
	jp	.l00105
.l00164:
	ld	a, $80
	jp	.l00120
.l00105:
;src/editor/editor.c:162: else if (osk_x == OSK_COLS - 1) return KEY_RIGHT;
	ld	hl, _osk_x
	ld	a, [hl]
	sub	a, $09
	jp	NZ,.l00165
	jp	.l00166
.l00165:
	jp	.l00102
.l00166:
	ld	a, $81
	jp	.l00120
.l00102:
;src/editor/editor.c:163: else return ' ';
	ld	a, $20
	jp	.l00120
.l00115:
;src/editor/editor.c:164: return KEY_NONE;
	xor	a, a
	jp	.l00120
.l00117:
;src/editor/editor.c:166: key = OSKGetKey(osk_layer, (osk_y << 3) + (osk_y << 1) + osk_x);
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
;src/editor/editor.c:167: if (osk_layer == OSK_SHIFT) SetOSKLayer(OSK_SHIFT); // shift is one shot
	ld	hl, _osk_layer
	ld	a, [hl]
	dec	a
	jp	NZ,.l00167
	jp	.l00168
.l00167:
	jp	.l00119
.l00168:
	push	bc
	ld	a, $01
	call	_SetOSKLayer
	pop	bc
.l00119:
;src/editor/editor.c:168: return key;
	ld	a, c
.l00120:
;src/editor/editor.c:169: }
	ret
;src/editor/editor.c:171: static void MoveOSKSelection(unsigned char held) {
;	---------------------------------
; Function MoveOSKSelection
; ---------------------------------
_MoveOSKSelection:
	ld	c, a
;src/editor/editor.c:172: if (held & PADF_UP) osk_y = osk_y ? osk_y - 1 : OSK_ROWS - 1;
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
;src/editor/editor.c:173: else if (held & PADF_DOWN) osk_y = osk_y == OSK_ROWS - 1 ? 0 : osk_y + 1;
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
;src/editor/editor.c:174: if (held & PADF_LEFT) osk_x = osk_x ? osk_x - 1 : OSK_COLS - 1;
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
;src/editor/editor.c:175: else if (held & PADF_RIGHT) osk_x = osk_x == OSK_COLS - 1 ? 0 : osk_x + 1;
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
;src/editor/editor.c:176: OSKSelect(osk_x, osk_y);
	ld	hl, _osk_y
	ld	e, [hl]
	ld	hl, _osk_x
	ld	a, [hl]
	jp	_OSKSelect
.l00111:
;src/editor/editor.c:177: }
	ret
;src/editor/editor.c:181: static unsigned char PadKey(void) {
;	---------------------------------
; Function PadKey
; ---------------------------------
_PadKey:
;src/editor/editor.c:182: unsigned char pressed = PadPressed();
	call	_PadPressed
	ld	c, a
;src/editor/editor.c:184: if (pressed & PADF_SELECT) ToggleOSK();
	bit	2, c
	jp	NZ,.l00172
	jp	.l00102
.l00172:
	push	bc
	call	_ToggleOSK
	pop	bc
.l00102:
;src/editor/editor.c:185: if (pressed & PADF_B) return KEY_BACKSPACE;
	bit	1, c
	jp	NZ,.l00173
	jp	.l00104
.l00173:
	ld	a, $08
	jp	.l00120
.l00104:
;src/editor/editor.c:186: if (pressed & PADF_START) return KEY_ENTER;
	bit	3, c
	jp	NZ,.l00174
	jp	.l00106
.l00174:
	ld	a, $0A
	jp	.l00120
.l00106:
;src/editor/editor.c:187: if (osk_shown && (pressed & PADF_A)) return PressOSKKey();
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
;src/editor/editor.c:188: held = DpadRepeat(pressed);
	ld	a, c
	call	_DpadRepeat
	ld	c, a
;src/editor/editor.c:189: if (!held) return KEY_NONE;
	ld	a, c
	or	a, a
	jp	NZ, .l00111
	xor	a, a
	jp	.l00120
.l00111:
;src/editor/editor.c:190: if (osk_shown) {
	ld	hl, _osk_shown
	ld	a, [hl]
	or	a, a
	jp	Z, .l00113
;src/editor/editor.c:191: MoveOSKSelection(held);
	ld	a, c
	call	_MoveOSKSelection
;src/editor/editor.c:192: return KEY_NONE;
	xor	a, a
	jp	.l00120
.l00113:
;src/editor/editor.c:194: if (held & PADF_UP) return KEY_UP;
	bit	6, c
	jp	NZ,.l00176
	jp	.l00115
.l00176:
	ld	a, $82
	jp	.l00120
.l00115:
;src/editor/editor.c:195: if (held & PADF_DOWN) return KEY_DOWN;
	bit	7, c
	jp	NZ,.l00177
	jp	.l00117
.l00177:
	ld	a, $83
	jp	.l00120
.l00117:
;src/editor/editor.c:196: if (held & PADF_LEFT) return KEY_LEFT;
	bit	5, c
	jp	NZ,.l00178
	jp	.l00119
.l00178:
	ld	a, $80
	jp	.l00120
.l00119:
;src/editor/editor.c:197: return KEY_RIGHT;
	ld	a, $81
.l00120:
;src/editor/editor.c:198: }
	ret
;src/editor/editor.c:201: static unsigned char MenuKey(void) {
;	---------------------------------
; Function MenuKey
; ---------------------------------
_MenuKey:
;src/editor/editor.c:203: WaitFrame();
	call	_WaitFrame
;src/editor/editor.c:204: if ((key = (unsigned char)KBPopEvent())) return key;
	call	_KBPopEvent
	ld	a, c
	ld	c, a
	or	a, a
	jp	Z, .l00102
	ld	a, c
	jp	.l00111
.l00102:
;src/editor/editor.c:205: pressed = PadPressed();
	call	_PadPressed
	ld	c, a
;src/editor/editor.c:206: if (pressed & (PADF_A | PADF_START)) return KEY_ENTER;
	ld	a, c
	and	a, $09
	jp	NZ,.l00138
	jp	.l00104
.l00138:
	ld	a, $0A
	jp	.l00111
.l00104:
;src/editor/editor.c:207: if (pressed & PADF_B) return KEY_ESCAPE;
	bit	1, c
	jp	NZ,.l00139
	jp	.l00106
.l00139:
	ld	a, $1B
	jp	.l00111
.l00106:
;src/editor/editor.c:208: held = DpadRepeat(pressed);
	ld	a, c
	call	_DpadRepeat
;src/editor/editor.c:209: if (held & PADF_UP) return KEY_UP;
	bit	6, a
	jp	NZ,.l00140
	jp	.l00108
.l00140:
	ld	a, $82
	jp	.l00111
.l00108:
;src/editor/editor.c:210: if (held & PADF_DOWN) return KEY_DOWN;
	rlca
	jp	C,.l00141
	jp	.l00110
.l00141:
	ld	a, $83
	jp	.l00111
.l00110:
;src/editor/editor.c:211: return KEY_NONE;
	xor	a, a
.l00111:
;src/editor/editor.c:212: }
	ret
;src/editor/editor.c:214: static char* RowAddress(unsigned char row) {
;	---------------------------------
; Function RowAddress
; ---------------------------------
_RowAddress:
	ld	e, a
;src/editor/editor.c:215: unsigned int offset = row;
	ld	d, $00
;src/editor/editor.c:216: return (char*)tile_buffer + (offset << 5) + (offset << 3); // row * TB_STRIDE
	ld	bc, _tile_buffer+0
	ld	l, e
	ld	h, d
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, bc
	ld	c, l
	ld	b, h
	ld	l, e
	ld	h, d
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, bc
	ld	c, l
	ld	b, h
.l00101:
;src/editor/editor.c:217: }
	ret
;src/editor/editor.c:220: static void DrawRow(unsigned char row, unsigned char col, const char* text) {
;	---------------------------------
; Function DrawRow
; ---------------------------------
_DrawRow:
	dec	sp
	dec	sp
	ld	c, a
	ld	hl, sp+1
	ld	[hl], e
;src/editor/editor.c:221: char* dest = RowAddress(row);
	ld	a, c
	call	_RowAddress
;src/editor/editor.c:223: for (i = 0; i < TB_STRIDE; ++i) dest[i] = ' ';
	ld	e, $00
.l00103:
	ld	l, e
	ld	h, $00
	add	hl, bc
	ld	[hl], $20
	inc	e
	ld	a, e
	sub	a, $28
	jp	C, .l00103
;src/editor/editor.c:224: for (dest += col; *text && col < TB_STRIDE; ++col) *dest++ = *text++;
	ld	hl, sp+1
	ld	l, [hl]
	ld	h, $00
	add	hl, bc
	ld	e, l
	ld	d, h
	ld	hl, sp+4
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	ld	hl, sp+1
	ld	a, [hl]
.l00107:
	push	af
	ld	a, [bc]
	ld	l, a
;	spillPairReg hl
;	spillPairReg hl
	pop	af
	inc	l
	dec	l
	jp	Z, .l00109
	cp	a, $28
	jp	NC, .l00109
	push	af
	ld	a, l
	ld	hl, sp+2
	ld	[hl], a
	pop	af
	inc	bc
	push	af
	ld	a, [hl]
	ld	[de], a
	pop	af
	inc	de
	inc	a
	jp	.l00107
.l00109:
;src/editor/editor.c:225: }
	inc	sp
	inc	sp
	pop	hl
	inc	sp
	inc	sp
	jp hl 
;src/editor/editor.c:227: static void ClearScreen(void) {
;	---------------------------------
; Function ClearScreen
; ---------------------------------
_ClearScreen:
;src/editor/editor.c:229: for (row = 0; row < TB_ROWS; ++row) DrawRow(row, 0, "");
	ld	c, $00
.l00102:
	push	bc
	ld	de, ___str_7
	push	de
	ld	e, $00
	ld	a, c
	call	_DrawRow
	pop	bc
	inc	c
	ld	a, c
	sub	a, $12
	jp	C, .l00102
.l00104:
;src/editor/editor.c:230: }
	ret
___str_7:
	DB $00
;src/editor/editor.c:233: static void BeginFullScreen(void) {
;	---------------------------------
; Function BeginFullScreen
; ---------------------------------
_BeginFullScreen:
;src/editor/editor.c:234: EditorShowCursor(0);
	xor	a, a
	call	_EditorShowCursor
;src/editor/editor.c:235: if (osk_shown) OSKShow(0);
	ld	hl, _osk_shown
	ld	a, [hl]
	or	a, a
	jp	Z, .l00102
	xor	a, a
	call	_OSKShow
.l00102:
;src/editor/editor.c:236: tb_rows = TB_ROWS;
	ld	hl, _tb_rows
	ld	[hl], $12
;src/editor/editor.c:237: dirty = 1;
	ld	hl, _dirty
	ld	[hl], $01
.l00103:
;src/editor/editor.c:238: }
	ret
;src/editor/editor.c:240: static void EndFullScreen(void) {
;	---------------------------------
; Function EndFullScreen
; ---------------------------------
_EndFullScreen:
;src/editor/editor.c:241: if (osk_shown) {
	ld	hl, _osk_shown
	ld	a, [hl]
	or	a, a
	jp	Z, .l00103
;src/editor/editor.c:242: tb_rows = TB_ROWS - OSK_ROWS;
	ld	hl, _tb_rows
	ld	[hl], $0D
;src/editor/editor.c:243: OSKDraw(osk_layer);
	ld	hl, _osk_layer
	ld	a, [hl]
	call	_OSKDraw
;src/editor/editor.c:244: OSKSelect(osk_x, osk_y);
	ld	hl, _osk_y
	ld	e, [hl]
	ld	hl, _osk_x
	ld	a, [hl]
	call	_OSKSelect
;src/editor/editor.c:245: OSKShow(1);
	ld	a, $01
	jp	_OSKShow
.l00103:
;src/editor/editor.c:247: }
	ret
;src/editor/editor.c:250: static unsigned char Choose(const char* title, const char* items, unsigned char count) {
;	---------------------------------
; Function Choose
; ---------------------------------
_Choose:
	add	sp, -12
	ld	hl, sp+9
	ld	[hl], e
	inc	hl
	ld	[hl], d
	ld	hl, sp+7
	ld	[hl], c
	inc	hl
	ld	[hl], b
;src/editor/editor.c:251: unsigned char i, key, selected = 0;
	ld	hl, sp+0
	ld	[hl], $00
;src/editor/editor.c:252: BeginFullScreen();
	call	_BeginFullScreen
;src/editor/editor.c:253: while (1) {
.l00119:
;src/editor/editor.c:254: ClearScreen();
	call	_ClearScreen
;src/editor/editor.c:255: DrawRow(0, 0, title);
	ld	hl, sp+9
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	push	de
	ld	e, $00
	xor	a, a
	call	_DrawRow
;src/editor/editor.c:256: for (i = 0; i < count; ++i) {
	ld	hl, sp+11
	ld	[hl], $00
.l00122:
	ld	hl, sp+11
	ld	a, [hl]
	ld	hl, sp+14
	sub	a, [hl]
	jp	NC, .l00103
;src/editor/editor.c:257: DrawRow(i + 2, 2, items + (i << 3) + (i << 2) + i); // i * FILE_NAME_SIZE
	ld	hl, sp+11
	ld	a, [hl]
	ld	hl, sp+5
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
	ld	a, $03
.l00191:
	ld	hl, sp+3
	sla	[hl]
	inc	hl
	rl	[hl]
	dec	a
	jp	NZ, .l00191
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, sp+7
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+3
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+2
	ld	[hl], a
	ld	hl, sp+5
	ld	a, [hl]
	dec	hl
	dec	hl
	ld	[hl], a
	ld	hl, sp+6
	ld	a, [hl]
	dec	hl
	dec	hl
	ld	[hl], a
	ld	a, $02
.l00192:
	ld	hl, sp+3
	sla	[hl]
	inc	hl
	rl	[hl]
	dec	a
	jp	NZ, .l00192
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, sp+1
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
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
	ld	hl, sp+11
	ld	l, [hl]
	ld	h, $00
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+5
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+4
	ld	[hl], a
	ld	hl, sp+11
	ld	a, [hl]
	add	a, $02
	ld	hl, sp+6
	ld	[hl], a
	ld	hl, sp+3
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	push	de
	ld	e, $02
	inc	hl
	inc	hl
	ld	a, [hl]
	call	_DrawRow
;src/editor/editor.c:258: if (i == selected) RowAddress(i + 2)[1] = MARKER;
	ld	hl, sp+11
	ld	a, [hl]
	ld	hl, sp+0
	sub	a, [hl]
	jp	NZ,.l00193
	jp	.l00194
.l00193:
	jp	.l00123
.l00194:
	ld	hl, sp+6
	ld	a, [hl]
	call	_RowAddress
	ld	hl, sp+3
	ld	[hl], c
	inc	hl
	ld	[hl], b
	ld	hl, sp+4
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $0001
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
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	ld	[hl], $0D
.l00123:
;src/editor/editor.c:256: for (i = 0; i < count; ++i) {
	ld	hl, sp+11
	inc	[hl]
	jp	.l00122
.l00103:
;src/editor/editor.c:260: EditorDraw(tb_rows);
	ld	hl, _tb_rows
	ld	a, [hl]
	call	_EditorDraw
;src/editor/editor.c:261: while (!(key = MenuKey()));
.l00104:
	call	_MenuKey
	ld	c, a
	or	a, a
	jp	Z, .l00104
;src/editor/editor.c:262: if (key == KEY_UP) selected = selected ? selected - 1 : count - 1;
	ld	hl, sp+0
	ld	a, [hl]
	ld	hl, sp+11
	ld	[hl], a
	ld	a, c
	sub	a, $82
	jp	NZ,.l00195
	jp	.l00196
.l00195:
	jp	.l00116
.l00196:
	ld	hl, sp+0
	ld	a, [hl]
	or	a, a
	jp	Z, .l00126
	ld	hl, sp+11
	ld	e, [hl]
	dec	e
	jp	.l00127
.l00126:
	ld	hl, sp+14
	ld	a, [hl]
	ld	hl, sp+11
	ld	[hl], a
	ld	e, [hl]
	dec	e
.l00127:
	ld	hl, sp+0
	ld	[hl], e
	jp	.l00119
.l00116:
;src/editor/editor.c:263: else if (key == KEY_DOWN) selected = selected == count - 1 ? 0 : selected + 1;
	ld	a, c
	sub	a, $83
	jp	NZ,.l00197
	jp	.l00198
.l00197:
	jp	.l00113
.l00198:
	ld	hl, sp+14
	ld	c, [hl]
	ld	b, $00
	dec	bc
	ld	hl, sp+0
	ld	e, [hl]
	ld	d, $00
	ld	a, e
	sub	a, c
	jp	NZ,.l00199
	ld	a, d
	sub	a, b
	jp	NZ,.l00199
	jp	.l00200
.l00199:
	jp	.l00128
.l00200:
	ld	c, $00
	xor	a, a
	jp	.l00129
.l00128:
	ld	hl, sp+11
	ld	a, [hl]
	inc	a
	ld	c, a
	rlca
	sbc	a, a
.l00129:
	ld	hl, sp+0
	ld	[hl], c
	jp	.l00119
.l00113:
;src/editor/editor.c:264: else if (key == KEY_ENTER) break;
	ld	a, c
	sub	a, $0A
	jp	NZ,.l00201
	jp	.l00120
.l00201:
;src/editor/editor.c:265: else if (key == KEY_ESCAPE) {
	ld	a, c
	sub	a, $1B
	jp	NZ,.l00202
	jp	.l00203
.l00202:
	jp	.l00119
.l00203:
;src/editor/editor.c:266: selected = CANCEL;
	ld	hl, sp+0
	ld	[hl], $FF
;src/editor/editor.c:267: break;
.l00120:
;src/editor/editor.c:270: EndFullScreen();
	call	_EndFullScreen
;src/editor/editor.c:271: return selected;
	ld	hl, sp+0
	ld	a, [hl]
.l00124:
;src/editor/editor.c:272: }
	add	sp, 12
	pop	hl
	inc	sp
	jp hl 
;src/editor/editor.c:275: static void ShowMessage(const char* text) {
;	---------------------------------
; Function ShowMessage
; ---------------------------------
_ShowMessage:
;src/editor/editor.c:276: Render();
	push	de
	call	_Render
	pop	de
;src/editor/editor.c:277: EditorShowCursor(0);
	push	de
	xor	a, a
	call	_EditorShowCursor
	pop	de
;src/editor/editor.c:278: DrawRow(tb_rows - 1, 0, text);
	ld	hl, _tb_rows
	ld	c, [hl]
	dec	c
	push	de
	ld	e, $00
	ld	a, c
	call	_DrawRow
;src/editor/editor.c:279: EditorDraw(tb_rows);
	ld	hl, _tb_rows
	ld	a, [hl]
	call	_EditorDraw
;src/editor/editor.c:280: while (!MenuKey());
.l00101:
	call	_MenuKey
	or	a, a
	jp	Z, .l00101
;src/editor/editor.c:281: dirty = 1;
	ld	hl, _dirty
	ld	[hl], $01
.l00104:
;src/editor/editor.c:282: }
	ret
;src/editor/editor.c:284: static void ShowError(unsigned char result, const char* denied) {
;	---------------------------------
; Function ShowError
; ---------------------------------
_ShowError:
	add	sp, -17
	ld	hl, sp+16
	ld	[hl], a
	dec	hl
	dec	hl
	ld	[hl], e
	inc	hl
	ld	[hl], d
;src/editor/editor.c:285: char text[12] = "SD ERROR ";
	ld	hl, sp+0
	ld	[hl], $53
	inc	hl
	ld	[hl], $44
	inc	hl
	ld	[hl], $20
	inc	hl
	ld	[hl], $45
	inc	hl
	ld	[hl], $52
	inc	hl
	ld	[hl], $52
	inc	hl
	ld	[hl], $4F
	inc	hl
	ld	[hl], $52
	inc	hl
	ld	[hl], $20
	inc	hl
	ld	[hl], $00
	inc	hl
	ld	[hl], $00
	inc	hl
	ld	[hl], $00
;src/editor/editor.c:286: if (result == FR_NOT_READY) ShowMessage("NO SD CARD");
	ld	hl, sp+16
	ld	a, [hl]
	sub	a, $03
	jp	NZ,.l00140
	jp	.l00141
.l00140:
	jp	.l00111
.l00141:
	ld	de, ___str_9
	call	_ShowMessage
	jp	.l00113
.l00111:
;src/editor/editor.c:287: else if (result == FR_NO_FILESYSTEM) ShowMessage("NO FAT VOLUME");
	ld	hl, sp+16
	ld	a, [hl]
	sub	a, $0D
	jp	NZ,.l00142
	jp	.l00143
.l00142:
	jp	.l00108
.l00143:
	ld	de, ___str_10
	call	_ShowMessage
	jp	.l00113
.l00108:
;src/editor/editor.c:288: else if (result == FR_DENIED) ShowMessage(denied);
	ld	hl, sp+16
	ld	a, [hl]
	sub	a, $07
	jp	NZ,.l00144
	jp	.l00145
.l00144:
	jp	.l00105
.l00145:
	ld	hl, sp+14
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_ShowMessage
	jp	.l00113
.l00105:
;src/editor/editor.c:290: text[9] = '0';
	ld	hl, sp+9
	ld	[hl], $30
;src/editor/editor.c:291: while (result >= 10) {
.l00101:
;src/editor/editor.c:293: result -= 10;
	ld	hl, sp+16
	ld	a, [hl]
	ld	hl, sp+12
	ld	[hl], a
;src/editor/editor.c:291: while (result >= 10) {
	ld	hl, sp+16
	ld	a, [hl]
	sub	a, $0A
	jp	C, .l00103
;src/editor/editor.c:292: ++text[9];
	ld	hl, sp+9
	ld	a, [hl]
	ld	hl, sp+13
	ld	[hl], a
	ld	a, [hl]
	inc	a
	ld	hl, sp+9
	ld	[hl], a
;src/editor/editor.c:293: result -= 10;
	ld	hl, sp+12
	ld	a, [hl]
	add	a, $F6
	ld	hl, sp+16
	ld	[hl], a
	jp	.l00101
.l00103:
;src/editor/editor.c:295: text[10] = '0' + result;
	ld	hl, sp+12
	ld	a, [hl]
	add	a, $30
	dec	hl
	dec	hl
	ld	[hl], a
;src/editor/editor.c:296: text[11] = 0;
	inc	hl
	ld	[hl], $00
;src/editor/editor.c:297: ShowMessage(text);
	ld	hl, 0
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_ShowMessage
.l00113:
;src/editor/editor.c:299: }
	add	sp, 17
	ret
___str_9:
	DB "NO SD CARD"
	DB $00
___str_10:
	DB "NO FAT VOLUME"
	DB $00
;src/editor/editor.c:301: static void CopyName(char* dest, const char* src) {
;	---------------------------------
; Function CopyName
; ---------------------------------
_CopyName:
;src/editor/editor.c:302: while ((*dest++ = *src++));
.l00101:
	ld	a, [bc]
	inc	bc
	ld	[de], a
	inc	de
	or	a, a
	jp	NZ, .l00101
.l00104:
;src/editor/editor.c:303: }
	ret
;src/editor/editor.c:306: static unsigned char CanDiscard(void) {
;	---------------------------------
; Function CanDiscard
; ---------------------------------
_CanDiscard:
;src/editor/editor.c:307: return !modified || Choose("DISCARD CHANGES?", discard_items[0], 2) == 1;
	ld	hl, _modified
	ld	a, [hl]
	or	a, a
	jp	Z, .l00104
	ld	a, $02
	push	af
	inc	sp
	ld	bc, _discard_items
	ld	de, ___str_11
	call	_Choose
	dec	a
	jp	NZ,.l00116
	jp	.l00104
.l00116:
	xor	a, a
	jp	.l00105
.l00104:
	ld	a, $01
.l00105:
.l00101:
;src/editor/editor.c:308: }
	ret
___str_11:
	DB "DISCARD CHANGES?"
	DB $00
;src/editor/editor.c:310: static void ResetCursor(void) {
;	---------------------------------
; Function ResetCursor
; ---------------------------------
_ResetCursor:
;src/editor/editor.c:311: cursor = 0;
	xor	a, a
	ld	hl, _cursor
	ld	[hl], a
	inc	hl
	ld	[hl], a
;src/editor/editor.c:312: top = 0;
	xor	a, a
	ld	hl, _top
	ld	[hl], a
	inc	hl
	ld	[hl], a
;src/editor/editor.c:313: want_col = 0;
	ld	hl, _want_col
	ld	[hl], $00
;src/editor/editor.c:314: modified = 0;
	ld	hl, _modified
	ld	[hl], $00
;src/editor/editor.c:315: dirty = 1;
	ld	hl, _dirty
	ld	[hl], $01
.l00101:
;src/editor/editor.c:316: }
	ret
;src/editor/editor.c:318: static void NewFile(void) {
;	---------------------------------
; Function NewFile
; ---------------------------------
_NewFile:
;src/editor/editor.c:319: if (!CanDiscard()) return;
	call	_CanDiscard
	or	a, a
	jp	NZ, .l00102
	jp	.l00103
.l00102:
;src/editor/editor.c:320: tb_Clear();
	call	_tb_Clear
;src/editor/editor.c:321: file_name[0] = 0;
	ld	hl, _file_name
	ld	[hl], $00
;src/editor/editor.c:322: fs_crlf = 0;
	ld	hl, _fs_crlf
	ld	[hl], $00
;src/editor/editor.c:323: ResetCursor();
	jp	_ResetCursor
.l00103:
;src/editor/editor.c:324: }
	ret
;src/editor/editor.c:326: static void OpenFile(void) {
;	---------------------------------
; Function OpenFile
; ---------------------------------
_OpenFile:
	dec	sp
;src/editor/editor.c:328: if (!CanDiscard()) return;
	call	_CanDiscard
	ld	c, a
	ld	a, c
	or	a, a
	jp	NZ, .l00102
	jp	.l00116
.l00102:
;src/editor/editor.c:329: if ((result = FileMount()) || (result = FileOpenDir())) {
	call	_FileMount
	ld	c, a
	or	a, a
	jp	NZ, .l00103
	call	_FileOpenDir
	ld	c, a
	or	a, a
	jp	Z, .l00122
.l00103:
;src/editor/editor.c:330: ShowError(result, "");
	ld	de, ___str_12
	ld	a, c
	inc	sp
	jp	_ShowError
;src/editor/editor.c:331: return;
	jp	.l00116
;src/editor/editor.c:333: while (count < FILE_LIST_MAX && FileNext(file_list[count])) ++count;
.l00122:
	ld	c, $00
.l00107:
	ld	a, c
	sub	a, $10
	jp	NC, .l00109
	ld	b, $00
	ld	l, c
	ld	h, b
	add	hl, hl
	add	hl, bc
	add	hl, hl
	add	hl, hl
	add	hl, bc
	ld	de, _file_list
	add	hl, de
	ld	e, l
	ld	d, h
	push	bc
	call	_FileNext
	pop	bc
	or	a, a
	jp	Z, .l00109
	inc	c
	jp	.l00107
.l00109:
;src/editor/editor.c:334: if (!count) {
	ld	a, c
	or	a, a
	jp	NZ, .l00111
;src/editor/editor.c:335: ShowMessage("NO .TXT FILES");
	ld	de, ___str_13
	inc	sp
	jp	_ShowMessage
;src/editor/editor.c:336: return;
	jp	.l00116
.l00111:
;src/editor/editor.c:338: selected = Choose("OPEN", file_list[0], count);
	ld	a, c
	push	af
	inc	sp
	ld	bc, _file_list
	ld	de, ___str_14
	call	_Choose
	ld	c, a
;src/editor/editor.c:339: if (selected == CANCEL) return;
	ld	a, c
	inc	a
	jp	NZ,.l00159
	jp	.l00160
.l00159:
	jp	.l00113
.l00160:
	jp	.l00116
.l00113:
;src/editor/editor.c:340: result = FileLoad(file_list[selected]);
	ld	b, $00
	ld	l, c
	ld	h, b
	add	hl, hl
	add	hl, bc
	add	hl, hl
	add	hl, hl
	add	hl, bc
	ld	c, l
	ld	b, h
	ld	hl, _file_list
	add	hl, bc
	ld	c, l
	ld	b, h
	ld	e, c
	ld	d, b
	push	bc
	call	_FileLoad
	pop	bc
	ld	hl, sp+0
	ld	[hl], a
;src/editor/editor.c:341: CopyName(file_name, file_list[selected]);
	ld	de, _file_name
	call	_CopyName
;src/editor/editor.c:342: ResetCursor();
	call	_ResetCursor
;src/editor/editor.c:343: if (result) ShowError(result, "FILE TOO BIG");
	ld	hl, sp+0
	ld	a, [hl]
	or	a, a
	jp	Z, .l00116
	ld	de, ___str_15
	ld	a, [hl]
	inc	sp
	jp	_ShowError
.l00116:
;src/editor/editor.c:344: }
	inc	sp
	ret
___str_12:
	DB $00
___str_13:
	DB "NO .TXT FILES"
	DB $00
___str_14:
	DB "OPEN"
	DB $00
___str_15:
	DB "FILE TOO BIG"
	DB $00
;src/editor/editor.c:347: static unsigned char AskFileName(void) {
;	---------------------------------
; Function AskFileName
; ---------------------------------
_AskFileName:
	add	sp, -32
;src/editor/editor.c:352: Render();
	ld	c, $00
.l00134:
;src/editor/editor.c:351: for (; file_name[length] && file_name[length] != '.'; ++length) name[length] = file_name[length];
	ld	hl, _file_name
	ld	b, $00
	add	hl, bc
	ld	b, [hl]
	ld	a, b
	or	a, a
	jp	Z, .l00165
	ld	a, b
	sub	a, $2E
	jp	NZ,.l00252
	jp	.l00165
.l00252:
	ld	e, c
	ld	d, $00
	ld	hl, 0
	add	hl, sp
	add	hl, de
	ld	[hl], b
	inc	c
	jp	.l00134
.l00165:
	ld	hl, sp+31
	ld	[hl], c
;src/editor/editor.c:352: Render();
	call	_Render
;src/editor/editor.c:353: EditorShowCursor(0);
	xor	a, a
	call	_EditorShowCursor
;src/editor/editor.c:354: while (1) {
.l00129:
;src/editor/editor.c:355: CopyName(text, "SAVE AS ");
	ld	bc, ___str_16
	ld	hl, 9
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_CopyName
;src/editor/editor.c:356: for (i = 0; i < length; ++i) text[8 + i] = name[i];
	ld	e, $00
.l00137:
	ld	a, e
	ld	hl, sp+31
	sub	a, [hl]
	jp	NC, .l00102
	ld	a, e
	add	a, $08
	ld	c, a
	rlca
	sbc	a, a
	ld	b, a
	ld	hl, 9
	add	hl, sp
	add	hl, bc
	ld	c, l
	ld	b, h
	push	de
	ld	d, $00
	ld	hl, 2
	add	hl, sp
	add	hl, de
	pop	de
	ld	a, [hl]
	ld	[bc], a
	inc	e
	jp	.l00137
.l00102:
;src/editor/editor.c:357: CopyName(text + 8 + length, "_.TXT");
	ld	hl, 17
	add	hl, sp
	ld	c, l
	ld	b, h
	ld	hl, sp+31
	ld	l, [hl]
	ld	h, $00
	add	hl, bc
	ld	e, l
	ld	d, h
	ld	bc, ___str_17
	call	_CopyName
;src/editor/editor.c:358: DrawRow(0, 0, text);
	ld	hl, 9
	add	hl, sp
	push	hl
	ld	e, $00
	xor	a, a
	call	_DrawRow
;src/editor/editor.c:359: EditorDraw(tb_rows);
	ld	hl, _tb_rows
	ld	a, [hl]
	call	_EditorDraw
;src/editor/editor.c:360: do {
.l00105:
;src/editor/editor.c:361: WaitFrame();
	call	_WaitFrame
;src/editor/editor.c:362: key = (unsigned char)KBPopEvent();
	call	_KBPopEvent
	ld	hl, sp+30
	ld	[hl], c
;src/editor/editor.c:363: if (!key) key = PadKey();
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00106
	call	_PadKey
	ld	hl, sp+30
	ld	[hl], a
.l00106:
;src/editor/editor.c:364: } while (!key);
	ld	hl, sp+30
	ld	a, [hl]
	or	a, a
	jp	Z, .l00105
;src/editor/editor.c:365: if (key == KEY_ENTER && length) break;
	ld	a, [hl]
	sub	a, $0A
	jp	NZ,.l00253
	jp	.l00254
.l00253:
	jp	.l00109
.l00254:
	ld	hl, sp+31
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00164
.l00109:
;src/editor/editor.c:366: if (key == KEY_ESCAPE || (key == KEY_BACKSPACE && !length)) {
	ld	hl, sp+30
	ld	a, [hl]
	sub	a, $1B
	jp	NZ,.l00255
	jp	.l00111
.l00255:
	ld	hl, sp+30
	ld	a, [hl]
	sub	a, $08
	jp	NZ,.l00256
	ld	a,$01
	jp	.l00257
.l00256:
	xor	a,a
.l00257:
	ld	c, a
	ld	a, c
	or	a, a
	jp	Z, .l00112
	ld	hl, sp+31
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00112
.l00111:
;src/editor/editor.c:367: dirty = 1;
	ld	hl, _dirty
	ld	[hl], $01
;src/editor/editor.c:368: return 0;
	xor	a, a
	jp	.l00142
.l00112:
;src/editor/editor.c:370: if (key == KEY_BACKSPACE) --length;
	ld	a, c
	or	a, a
	jp	Z, .l00116
	ld	hl, sp+31
	dec	[hl]
.l00116:
;src/editor/editor.c:371: if (key >= 'a' && key <= 'z') key -= 'a' - 'A';
	ld	hl, sp+30
	ld	a, [hl]
	sub	a, $61
	jp	C, .l00118
	ld	a, $7A
	sub	a, [hl]
	jp	C, .l00118
	ld	a, [hl]
	add	a, $E0
	ld	[hl], a
.l00118:
;src/editor/editor.c:372: if (length < BASE_NAME_SIZE && ((key >= 'A' && key <= 'Z') || (key >= '0' && key <= '9') || key == '_' || key == '-')) {
	ld	hl, sp+31
	ld	a, [hl]
	sub	a, $08
	jp	NC, .l00129
	dec	hl
	ld	a, [hl]
	sub	a, $41
	jp	C, .l00124
	ld	a, $5A
	sub	a, [hl]
	jp	NC, .l00120
.l00124:
	ld	hl, sp+30
	ld	a, [hl]
	sub	a, $30
	jp	C, .l00125
	ld	a, $39
	sub	a, [hl]
	jp	NC, .l00120
.l00125:
	ld	hl, sp+30
	ld	a, [hl]
	sub	a, $5F
	jp	NZ,.l00258
	jp	.l00120
.l00258:
	ld	hl, sp+30
	ld	a, [hl]
	sub	a, $2D
	jp	NZ,.l00259
	jp	.l00260
.l00259:
	jp	.l00129
.l00260:
.l00120:
;src/editor/editor.c:373: name[length++] = key;
	ld	hl, sp+31
	ld	e, [hl]
	inc	[hl]
	ld	d, $00
	ld	hl, 0
	add	hl, sp
	add	hl, de
	ld	c, l
	ld	b, h
	ld	hl, sp+30
	ld	a, [hl]
	ld	[bc], a
	jp	.l00129
;src/editor/editor.c:376: for (i = 0; i < length; ++i) file_name[i] = name[i];
.l00164:
	ld	e, $00
.l00140:
	ld	a, e
	ld	hl, sp+31
	sub	a, [hl]
	jp	NC, .l00131
	ld	a, LOW(_file_name)
	add	a, e
	ld	c, a
	ld	a, HIGH(_file_name)
	adc	a, $00
	ld	b, a
	push	de
	ld	d, $00
	ld	hl, 2
	add	hl, sp
	add	hl, de
	pop	de
	ld	a, [hl]
	ld	[bc], a
	inc	e
	jp	.l00140
.l00131:
;src/editor/editor.c:377: CopyName(file_name + length, ".TXT");
	ld	de, _file_name
	ld	hl, sp+31
	ld	l, [hl]
	ld	h, $00
	add	hl, de
	ld	e, l
	ld	d, h
	ld	bc, ___str_18
	call	_CopyName
;src/editor/editor.c:378: dirty = 1;
	ld	hl, _dirty
	ld	[hl], $01
;src/editor/editor.c:379: return 1;
	ld	a, $01
.l00142:
;src/editor/editor.c:380: }
	add	sp, 32
	ret
___str_16:
	DB "SAVE AS "
	DB $00
___str_17:
	DB "_.TXT"
	DB $00
___str_18:
	DB ".TXT"
	DB $00
;src/editor/editor.c:382: static void SaveFile(unsigned char ask) {
;	---------------------------------
; Function SaveFile
; ---------------------------------
_SaveFile:
	ld	c, a
;src/editor/editor.c:384: if ((ask || !file_name[0]) && !AskFileName()) return;
	ld	a, c
	or	a, a
	jp	NZ, .l00104
	ld	a, [_file_name + 0]
	or	a, a
	jp	NZ, .l00102
.l00104:
	call	_AskFileName
	or	a, a
	jp	NZ, .l00102
	jp	.l00108
.l00102:
;src/editor/editor.c:385: if ((result = FileMount()) || (result = FileSave(file_name))) {
	call	_FileMount
	ld	c, a
	or	a, a
	jp	NZ, .l00105
	ld	de, _file_name
	call	_FileSave
	ld	c, a
	or	a, a
	jp	Z, .l00106
.l00105:
;src/editor/editor.c:386: ShowError(result, "DISK FULL");
	ld	de, ___str_19
	ld	a, c
	jp	_ShowError
;src/editor/editor.c:387: return;
	jp	.l00108
.l00106:
;src/editor/editor.c:389: modified = 0;
	ld	hl, _modified
	ld	[hl], $00
;src/editor/editor.c:390: ShowMessage("SAVED");
	ld	de, ___str_20
	jp	_ShowMessage
.l00108:
;src/editor/editor.c:391: }
	ret
___str_19:
	DB "DISK FULL"
	DB $00
___str_20:
	DB "SAVED"
	DB $00
;src/editor/editor.c:394: static void ToggleFont(void) {
;	---------------------------------
; Function ToggleFont
; ---------------------------------
_ToggleFont:
;src/editor/editor.c:395: font = font == FONT_VWF ? FONT_MONO : FONT_VWF;
	ld	hl, _font
	ld	a, [hl]
	dec	a
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
	ld	a, $01
	ld	l, $00
;	spillPairReg hl
;	spillPairReg hl
.l00104:
	ld	[_font], a
;src/editor/editor.c:396: SetFont(font);
	ld	hl, _font
	ld	a, [hl]
	call	_SetFont
;src/editor/editor.c:397: dirty = 1;
	ld	hl, _dirty
	ld	[hl], $01
.l00101:
;src/editor/editor.c:398: }
	ret
;src/editor/editor.c:400: static void FileMenu(void) {
;	---------------------------------
; Function FileMenu
; ---------------------------------
_FileMenu:
;src/editor/editor.c:401: switch (Choose("MENU", menu_items[0], 5)) {
	ld	a, $05
	push	af
	inc	sp
	ld	bc, _menu_items
	ld	de, ___str_21
	call	_Choose
	ld	c, a
	ld	a, $04
	sub	a, c
	jp	C, .l00107
	ld	b, $00
	ld	hl, .l00114
	add	hl, bc
	add	hl, bc
	add	hl, bc
	jp	hl
.l00114:
	jp	.l00101
	jp	.l00102
	jp	.l00103
	jp	.l00104
	jp	.l00105
;src/editor/editor.c:402: case 0: OpenFile(); break;
.l00101:
	jp	_OpenFile
	jp	.l00107
;src/editor/editor.c:403: case 1: SaveFile(0); break;
.l00102:
	xor	a, a
	jp	_SaveFile
	jp	.l00107
;src/editor/editor.c:404: case 2: SaveFile(1); break;
.l00103:
	ld	a, $01
	jp	_SaveFile
	jp	.l00107
;src/editor/editor.c:405: case 3: NewFile(); break;
.l00104:
	jp	_NewFile
	jp	.l00107
;src/editor/editor.c:406: case 4: ToggleFont(); break;
.l00105:
	jp	_ToggleFont
;src/editor/editor.c:407: }
.l00107:
;src/editor/editor.c:408: }
	ret
___str_21:
	DB "MENU"
	DB $00
;src/editor/editor.c:411: static unsigned char HandleFileKey(unsigned char key, unsigned char mods) {
;	---------------------------------
; Function HandleFileKey
; ---------------------------------
_HandleFileKey:
	ld	c, a
;src/editor/editor.c:412: if (key == KEY_MENU || key == KEY_ESCAPE) FileMenu();
	ld	a, c
	sub	a, $89
	jp	NZ,.l00155
	jp	.l00119
.l00155:
	ld	a, c
	sub	a, $1B
	jp	NZ,.l00156
	jp	.l00157
.l00156:
	jp	.l00120
.l00157:
.l00119:
	call	_FileMenu
	jp	.l00121
.l00120:
;src/editor/editor.c:413: else if (!(mods & KB_MOD_CTRL)) return 0;
	bit	5, e
	jp	NZ,.l00158
	jp	.l00159
.l00158:
	jp	.l00117
.l00159:
	xor	a, a
	jp	.l00123
.l00117:
;src/editor/editor.c:414: else if (key == 'o' || key == 'O') OpenFile();
	ld	a, c
	sub	a, $6F
	jp	NZ,.l00160
	jp	.l00112
.l00160:
	ld	a, c
	sub	a, $4F
	jp	NZ,.l00161
	jp	.l00162
.l00161:
	jp	.l00113
.l00162:
.l00112:
	call	_OpenFile
	jp	.l00121
.l00113:
;src/editor/editor.c:415: else if (key == 's' || key == 'S') SaveFile(0);
	ld	a, c
	sub	a, $73
	jp	NZ,.l00163
	jp	.l00108
.l00163:
	ld	a, c
	sub	a, $53
	jp	NZ,.l00164
	jp	.l00165
.l00164:
	jp	.l00109
.l00165:
.l00108:
	xor	a, a
	call	_SaveFile
	jp	.l00121
.l00109:
;src/editor/editor.c:416: else if (key == 'n' || key == 'N') NewFile();
	ld	a, c
	sub	a, $6E
	jp	NZ,.l00166
	jp	.l00104
.l00166:
	ld	a, c
	sub	a, $4E
	jp	NZ,.l00167
	jp	.l00168
.l00167:
	jp	.l00105
.l00168:
.l00104:
	call	_NewFile
	jp	.l00121
.l00105:
;src/editor/editor.c:417: else if (key == 'f' || key == 'F') ToggleFont();
	ld	a, c
	sub	a, $66
	jp	NZ,.l00169
	jp	.l00101
.l00169:
	ld	a, c
	sub	a, $46
	jp	NZ,.l00170
	jp	.l00171
.l00170:
	jp	.l00121
.l00171:
.l00101:
	call	_ToggleFont
.l00121:
;src/editor/editor.c:418: dirty = 1;
	ld	hl, _dirty
	ld	[hl], $01
;src/editor/editor.c:419: return 1;
	ld	a, $01
.l00123:
;src/editor/editor.c:420: }
	ret
;src/editor/editor.c:422: static void Render(void) {
;	---------------------------------
; Function Render
; ---------------------------------
_Render:
;src/editor/editor.c:423: tb_find = cursor;
	ld	hl, _cursor
	ld	a, [hl]
	ld	hl, _tb_find
	ld	[hl], a
	ld	hl, _cursor + 1
	ld	a, [hl]
	ld	hl, _tb_find + 1
	ld	[hl], a
;src/editor/editor.c:424: tb_Render(top);
	ld	hl, _top
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	jp	_tb_Render
.l00101:
;src/editor/editor.c:425: }
	ret
;src/editor/editor.c:428: static void Refresh(void) {
;	---------------------------------
; Function Refresh
; ---------------------------------
_Refresh:
	dec	sp
;src/editor/editor.c:431: if (top > tb_Length()) top = tb_Length();
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
;src/editor/editor.c:432: top = tb_RowStart(top); // wrapping may have changed
	ld	hl, _top
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_tb_RowStart
	ld	hl, _top
	ld	[hl], c
	inc	hl
	ld	[hl], b
;src/editor/editor.c:433: Render();
	call	_Render
;src/editor/editor.c:434: if (tb_found_row == 0xFF) {
	ld	hl, _tb_found_row
	ld	a, [hl]
	inc	a
	jp	NZ,.l00154
	jp	.l00155
.l00154:
	jp	.l00112
.l00155:
;src/editor/editor.c:435: row = tb_RowStart(cursor);
	ld	hl, _cursor
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_tb_RowStart
;src/editor/editor.c:436: if (cursor < top) top = row;
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
;src/editor/editor.c:438: bottom = tb_bottom;
	ld	hl, _tb_bottom
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
;src/editor/editor.c:439: for (i = tb_rows; i; --i) {
	ld	hl, _tb_rows
	ld	a, [hl]
	ld	hl, sp+0
	ld	[hl], a
.l00114:
	ld	hl, sp+0
	ld	a, [hl]
	or	a, a
	jp	Z, .l00105
;src/editor/editor.c:440: top = tb_NextRow(top);
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
;src/editor/editor.c:441: if (bottom == row) break;
	ld	a, e
	sub	a, c
	jp	NZ,.l00156
	ld	a, d
	sub	a, b
	jp	NZ,.l00156
	jp	.l00105
.l00156:
;src/editor/editor.c:442: bottom = tb_NextRow(bottom);
	push	bc
	call	_tb_NextRow
	ld	e, c
	ld	d, b
	pop	bc
;src/editor/editor.c:439: for (i = tb_rows; i; --i) {
	ld	hl, sp+0
	dec	[hl]
	jp	.l00114
.l00105:
;src/editor/editor.c:444: if (!i) top = row;
	ld	hl, sp+0
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00110
	ld	hl, _top
	ld	[hl], c
	inc	hl
	ld	[hl], b
.l00110:
;src/editor/editor.c:446: Render();
	call	_Render
.l00112:
;src/editor/editor.c:448: EditorDraw(tb_rows);
	ld	hl, _tb_rows
	ld	a, [hl]
	call	_EditorDraw
;src/editor/editor.c:449: blink_timer = 0;
	ld	hl, _blink_timer
	ld	[hl], $00
;src/editor/editor.c:450: EditorShowCursor(1);
	ld	a, $01
	inc	sp
	jp	_EditorShowCursor
.l00116:
;src/editor/editor.c:451: }
	inc	sp
	ret
;src/editor/editor.c:453: void Editor(void) {
;	---------------------------------
; Function Editor
; ---------------------------------
_Editor::
;src/editor/editor.c:457: EditorSetup();
	call	_EditorSetup
;src/editor/editor.c:458: everdrive = sd_Detect();
	call	_sd_Detect
	ld	hl, _everdrive
	ld	[hl], a
;src/editor/editor.c:459: idle_frames = 0;
	ld	hl, _idle_frames
	ld	[hl], $00
;src/editor/editor.c:460: normalized = 0;
	ld	hl, _normalized
	ld	[hl], $00
;src/editor/editor.c:461: cursor = 0;
	xor	a, a
	ld	hl, _cursor
	ld	[hl], a
	inc	hl
	ld	[hl], a
;src/editor/editor.c:462: top = 0;
	xor	a, a
	ld	hl, _top
	ld	[hl], a
	inc	hl
	ld	[hl], a
;src/editor/editor.c:463: want_col = 0;
	ld	hl, _want_col
	ld	[hl], $00
;src/editor/editor.c:464: pad_timer = 0;
	ld	hl, _pad_timer
	ld	[hl], $00
;src/editor/editor.c:465: modified = 0;
	ld	hl, _modified
	ld	[hl], $00
;src/editor/editor.c:466: font = FONT_VWF;
	ld	hl, _font
	ld	[hl], $01
;src/editor/editor.c:467: file_name[0] = 0;
	ld	hl, _file_name
	ld	[hl], $00
;src/editor/editor.c:468: fs_crlf = 0;
	ld	hl, _fs_crlf
	ld	[hl], $00
;src/editor/editor.c:469: osk_shown = 0;
	ld	hl, _osk_shown
	ld	[hl], $00
;src/editor/editor.c:470: osk_layer = OSK_LOWER;
	ld	hl, _osk_layer
	ld	[hl], $00
;src/editor/editor.c:471: osk_x = 0;
	ld	hl, _osk_x
	ld	[hl], $00
;src/editor/editor.c:472: osk_y = 0;
	ld	hl, _osk_y
	ld	[hl], $00
;src/editor/editor.c:473: tb_rows = TB_ROWS;
	ld	hl, _tb_rows
	ld	[hl], $12
;src/editor/editor.c:474: Refresh();
	call	_Refresh
;src/editor/editor.c:476: while (1) {
.l00124:
;src/editor/editor.c:477: WaitFrame();
	call	_WaitFrame
;src/editor/editor.c:478: while ((key = (unsigned char)(event = KBPopEvent()))) {
.l00103:
	call	_KBPopEvent
	ld	e, c
	ld	d, b
	ld	c, e
	ld	b, d
	ld	a, e
	ld	l, a
;	spillPairReg hl
;	spillPairReg hl
	or	a, a
	jp	Z, .l00105
;src/editor/editor.c:479: if (!HandleFileKey(key, (unsigned char)(event >> 8))) HandleKey(key, (unsigned char)(event >> 8));
	ld	h, b
;	spillPairReg hl
;	spillPairReg hl
	push	hl
	ld	e, h
	ld	a, l
	call	_HandleFileKey
	pop	hl
	or	a, a
	jp	NZ, .l00102
	ld	e, h
	ld	a, l
	call	_HandleKey
.l00102:
;src/editor/editor.c:480: dirty = 1;
	ld	hl, _dirty
	ld	[hl], $01
	jp	.l00103
.l00105:
;src/editor/editor.c:482: if ((key = PadKey())) {
	call	_PadKey
	ld	c, a
	or	a, a
	jp	Z, .l00109
;src/editor/editor.c:483: if (!HandleFileKey(key, 0)) HandleKey(key, 0);
	push	bc
	ld	e, $00
	ld	a, c
	call	_HandleFileKey
	pop	bc
	or	a, a
	jp	NZ, .l00107
	ld	e, $00
	ld	a, c
	call	_HandleKey
.l00107:
;src/editor/editor.c:484: dirty = 1;
	ld	hl, _dirty
	ld	[hl], $01
.l00109:
;src/editor/editor.c:486: if (dirty) {
	ld	hl, _dirty
	ld	a, [hl]
	or	a, a
	jp	Z, .l00111
;src/editor/editor.c:487: Refresh();
	call	_Refresh
;src/editor/editor.c:488: dirty = 0;
	ld	hl, _dirty
	ld	[hl], $00
;src/editor/editor.c:489: idle_frames = 0;
	ld	hl, _idle_frames
	ld	[hl], $00
;src/editor/editor.c:490: normalized = 0;
	ld	hl, _normalized
	ld	[hl], $00
;src/editor/editor.c:491: continue;
	jp	.l00124
.l00111:
;src/editor/editor.c:493: if (idle_frames < NORMALIZE_DELAY) ++idle_frames;
	ld	hl, _idle_frames
	ld	a, [hl]
	sub	a, $1E
	jp	NC, .l00116
	inc	[hl]
	jp	.l00117
.l00116:
;src/editor/editor.c:494: else if (!everdrive && !normalized) normalized = tb_NormalizeStep(); // keeps the .sav readable as text
	ld	hl, _everdrive
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00117
	ld	hl, _normalized
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00117
	call	_tb_NormalizeStep
	ld	hl, _normalized
	ld	[hl], a
.l00117:
;src/editor/editor.c:495: if (++blink_timer == CURSOR_BLINK) EditorShowCursor(0);
	ld	hl, _blink_timer
	inc	[hl]
	ld	a, [hl]
	sub	a, $1E
	jp	NZ,.l00188
	jp	.l00189
.l00188:
	jp	.l00121
.l00189:
	xor	a, a
	call	_EditorShowCursor
	jp	.l00124
.l00121:
;src/editor/editor.c:496: else if (blink_timer == CURSOR_BLINK + CURSOR_BLINK) {
	ld	hl, _blink_timer
	ld	a, [hl]
	sub	a, $3C
	jp	NZ,.l00190
	jp	.l00191
.l00190:
	jp	.l00124
.l00191:
;src/editor/editor.c:497: EditorShowCursor(1);
	ld	a, $01
	call	_EditorShowCursor
;src/editor/editor.c:498: blink_timer = 0;
	ld	hl, _blink_timer
	ld	[hl], $00
	jp	.l00124
.l00126:
;src/editor/editor.c:501: }
	ret
	SECTION FRAGMENT "src/editor/editor.c_CODE",ROMX
	SECTION FRAGMENT "_INITIALIZER",ROM0
	SECTION FRAGMENT "_CABS (ABS)",ROM0
