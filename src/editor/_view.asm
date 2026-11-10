;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 4.2.0 #13081 (Linux)
;--------------------------------------------------------
	; MODULE view
	; Generated using the rgbds tokens.

;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	EXPORT _PutNumber
	EXPORT _PutText
	EXPORT _DrawRow
	EXPORT _RowAddress
	EXPORT _NoHighlight
	EXPORT _ScrollRing
	EXPORT _Layout
	EXPORT _RenderCursorX
	EXPORT _EditorDraw
	EXPORT _HeadingCharWidth
	EXPORT _tb_ScrollRows
	EXPORT _tb_RenderRows
	EXPORT _tb_Render
	EXPORT _tb_NextRow
	EXPORT _tb_RowStart
	EXPORT _tb_LineStart
	EXPORT _tb_CountLines
	EXPORT _tb_GetChar
	EXPORT _tb_Length
	EXPORT _SettingsSave
	EXPORT _OSKSelect
	EXPORT _OSKDraw
	EXPORT _OSKShow
	EXPORT _EditorInvertCursor
	EXPORT _EditorShowCursor
	EXPORT _GetSelection
	EXPORT _ToLatin1
	EXPORT _counted_lines
	EXPORT _counted_pos
	EXPORT _LineEnd
	EXPORT _PlaceCursor
	EXPORT _PosAtX
	EXPORT _ScrollDown
	EXPORT _ScrollUp
	EXPORT _RenderAfterEdit
	EXPORT _CountEdit
	EXPORT _Uncount
	EXPORT _UpdateBars
	EXPORT _Draw
	EXPORT _SetRows
	EXPORT _ToggleBars
	EXPORT _BeginFullScreen
	EXPORT _EndFullScreen
	EXPORT _Render
	EXPORT _Refresh
;--------------------------------------------------------
; special function registers
;--------------------------------------------------------
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	SECTION FRAGMENT "src/editor/view.c_DATA",WRAM0
_counted_pos:
	DS 2
_counted_lines:
	DS 2
_src_editor_view_c_head_level:
	DS 1
_src_editor_view_c_code_line:
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
	SECTION FRAGMENT "src/editor/view.c_HOME",ROM0
	SECTION FRAGMENT "src/editor/view.c_HOME",ROM0
;--------------------------------------------------------
; code
;--------------------------------------------------------
	SECTION FRAGMENT "src/editor/view.c_CODE",ROMX
;src/editor/view.c:27: static unsigned char FindRow(unsigned int pos) {
;	---------------------------------
	SECTION FRAGMENT "Page 5",ROMX,BANK[2]
	LOAD FRAGMENT "Page 5 RAM",SRAM,BANK[5]
; Function FindRow
; ---------------------------------
_src_editor_view_c_FindRow:
	dec	sp
	dec	sp
	ld	c, e
	ld	b, d
;src/editor/view.c:29: for (row = 0; row < tb_rows; ++row) {
	ld	hl, sp+0
	ld	[hl], $00
	inc	hl
	ld	[hl], $00
.l00107:
	ld	hl, sp+1
	ld	a, [hl]
	ld	hl, _tb_rows
	sub	a, [hl]
	jp	NC, .l00105
;src/editor/view.c:30: if (pos < tb_row_starts[row]) return 0xFF;
	ld	hl, sp+1
	ld	a, [hl]
	ld	e, $00
	ld	l, a
	ld	h, e
	add	hl, hl
	ld	de, _tb_row_starts
	add	hl, de
	ld	a, [hl+]
	ld	h, [hl]
;	spillPairReg hl
	ld	l, a
;	spillPairReg hl
;	spillPairReg hl
	ld	a, c
	sub	a, l
	ld	a, b
	sbc	a, h
	jp	NC, .l00102
	ld	a, $FF
	jp	.l00109
.l00102:
;src/editor/view.c:31: if (pos < tb_row_starts[row + 1]) return row;
	ld	hl, sp+1
	ld	a, [hl]
	inc	a
	ld	l, a
;	spillPairReg hl
;	spillPairReg hl
	rlca
	sbc	a, a
	ld	h, a
	add	hl, hl
	ld	de, _tb_row_starts
	add	hl, de
	ld	a, [hl+]
	ld	h, [hl]
;	spillPairReg hl
	ld	l, a
;	spillPairReg hl
;	spillPairReg hl
	ld	a, c
	sub	a, l
	ld	a, b
	sbc	a, h
	jp	NC, .l00108
	ld	hl, sp+0
	ld	a, [hl]
	jp	.l00109
.l00108:
;src/editor/view.c:29: for (row = 0; row < tb_rows; ++row) {
	ld	hl, sp+1
	inc	[hl]
	ld	a, [hl]
	dec	hl
	ld	[hl], a
	jp	.l00107
.l00105:
;src/editor/view.c:33: return pos == tb_Length() ? tb_end_row : 0xFF;
	push	bc
	call	_tb_Length
	ld	e, c
	ld	d, b
	pop	bc
	ld	a, e
	sub	a, c
	jp	NZ,.l00138
	ld	a, d
	sub	a, b
	jp	NZ,.l00138
	jp	.l00139
.l00138:
	jp	.l00111
.l00139:
	ld	hl, _tb_end_row
	ld	a, [hl]
	ld	c, $00
	jp	.l00112
.l00111:
	ld	a, $FF
	ld	c, $00
.l00112:
.l00109:
;src/editor/view.c:34: }
	inc	sp
	inc	sp
	ret
;src/editor/view.c:37: unsigned int LineEnd(unsigned char row) {
;	---------------------------------
	SECTION FRAGMENT "Page 5",ROMX,BANK[2]
	LOAD FRAGMENT "Page 5 RAM",SRAM,BANK[5]
; Function LineEnd
; ---------------------------------
_LineEnd::
	ld	c, a
;src/editor/view.c:38: return row == tb_end_row ? tb_Length() : tb_row_starts[row + 1] - 1;
	ld	hl, _tb_end_row
	ld	a, [hl]
	sub	a, c
	jp	NZ,.l00110
	jp	.l00111
.l00110:
	jp	.l00103
.l00111:
	call	_tb_Length
	jp	.l00104
.l00103:
	ld	a, c
	inc	a
	ld	l, a
;	spillPairReg hl
;	spillPairReg hl
	rlca
	sbc	a, a
	ld	h, a
	add	hl, hl
	ld	de, _tb_row_starts
	add	hl, de
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	dec	bc
.l00104:
.l00101:
;src/editor/view.c:39: }
	ret
;src/editor/view.c:42: unsigned char PlaceCursor(void) {
;	---------------------------------
	SECTION FRAGMENT "Page 5",ROMX,BANK[2]
	LOAD FRAGMENT "Page 5 RAM",SRAM,BANK[5]
; Function PlaceCursor
; ---------------------------------
_PlaceCursor::
	dec	sp
;src/editor/view.c:43: unsigned char row = FindRow(cursor), count;
	ld	hl, _cursor
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_src_editor_view_c_FindRow
	ld	hl, sp+0
	ld	[hl], a
;src/editor/view.c:45: if (row == 0xFF) return 0;
	ld	a, [hl]
	inc	a
	jp	NZ,.l00161
	jp	.l00162
.l00161:
	jp	.l00102
.l00162:
	xor	a, a
	jp	.l00116
.l00102:
;src/editor/view.c:46: col = cursor - tb_row_starts[row];
	ld	bc, _tb_row_starts+0
	ld	hl, sp+0
	ld	e, [hl]
	ld	d, $00
	ld	l, e
	ld	h, d
	add	hl, hl
	add	hl, bc
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	ld	hl, _cursor
	ld	a, [hl]
	sub	a, c
	ld	e, a
	inc	hl
	ld	a, [hl]
	sbc	a, b
	ld	d, a
;src/editor/view.c:47: count = tb_row_counts[row];
	ld	bc, _tb_row_counts+0
	ld	hl, sp+0
	ld	l, [hl]
	ld	h, $00
	add	hl, bc
	ld	c, l
	ld	b, h
	ld	a, [bc]
;src/editor/view.c:51: if (col > count || (col == count && cursor != LineEnd(row))) return 0;
	ld	c, a
	ld	b, $00
;src/editor/view.c:48: if (tb_nowrap) { // its character is drawn, or it's after the line's last one
	ld	hl, _tb_nowrap
	ld	a, [hl]
	or	a, a
	jp	Z, .l00112
;src/editor/view.c:49: if (col < tb_left) return 0;
	ld	hl, _tb_left
	ld	a, e
	sub	a, [hl]
	inc	hl
	ld	a, d
	sbc	a, [hl]
	jp	NC, .l00104
	xor	a, a
	jp	.l00116
.l00104:
;src/editor/view.c:50: col -= tb_left;
	ld	a, e
	ld	hl, _tb_left
	sub	a, [hl]
	ld	e, a
	ld	a, d
	inc	hl
	sbc	a, [hl]
	ld	d, a
;src/editor/view.c:51: if (col > count || (col == count && cursor != LineEnd(row))) return 0;
	ld	a, c
	sub	a, e
	ld	a, b
	sbc	a, d
	jp	C, .l00105
	ld	a, c
	sub	a, e
	jp	NZ,.l00163
	ld	a, b
	sub	a, d
	jp	NZ,.l00163
	jp	.l00164
.l00163:
	jp	.l00113
.l00164:
	push	de
	ld	hl, sp+2
	ld	a, [hl]
	call	_LineEnd
	pop	de
	ld	hl, _cursor
	ld	a, [hl]
	sub	a, c
	jp	NZ,.l00165
	inc	hl
	ld	a, [hl]
	sub	a, b
	jp	NZ,.l00165
	jp	.l00113
.l00165:
.l00105:
	xor	a, a
	jp	.l00116
.l00112:
;src/editor/view.c:53: else if (col > count) col = count; // hanging spaces
	ld	a, c
	sub	a, e
	ld	a, b
	sbc	a, d
	jp	NC, .l00113
	ld	e, c
	ld	d, b
.l00113:
;src/editor/view.c:54: tb_found_row = row;
	ld	hl, sp+0
	ld	a, [hl]
	ld	hl, _tb_found_row
	ld	[hl], a
;src/editor/view.c:55: tb_found_col = (unsigned char)col;
	ld	hl, _tb_found_col
	ld	[hl], e
;src/editor/view.c:56: if (!keep_x) want_x = RenderCursorX(tb_found_col);
	ld	hl, _keep_x
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00115
	ld	hl, _tb_found_col
	ld	a, [hl]
	call	_RenderCursorX
	ld	hl, _want_x
	ld	[hl], a
.l00115:
;src/editor/view.c:57: keep_x = 0;
	ld	hl, _keep_x
	ld	[hl], $00
;src/editor/view.c:58: blink_timer = 0;
	ld	hl, _blink_timer
	ld	[hl], $00
;src/editor/view.c:59: EditorInvertCursor(GetSelection() && cursor == sel_start); // the selection starts at the cursor's x
	call	_GetSelection__far
	or	a, a
	jp	Z, .l00118
	ld	hl, _cursor
	ld	a, [hl]
	ld	hl, _sel_start
	sub	a, [hl]
	jp	NZ,.l00166
	ld	hl, _cursor + 1
	ld	a, [hl]
	ld	hl, _sel_start + 1
	sub	a, [hl]
	jp	NZ,.l00166
	jp	.l00119
.l00166:
.l00118:
	ld	c, $00
	jp	.l00120
.l00119:
	ld	c, $01
.l00120:
	ld	a, c
	call	_EditorInvertCursor
;src/editor/view.c:60: EditorShowCursor(1);
	ld	a, $01
	call	_EditorShowCursor
;src/editor/view.c:61: bars_changed = 1;
	ld	hl, _bars_changed
	ld	[hl], $01
;src/editor/view.c:62: return 1;
	ld	a, $01
.l00116:
;src/editor/view.c:63: }
	inc	sp
	ret
;src/editor/view.c:66: unsigned int PosAtX(unsigned char row, unsigned char x) {
;	---------------------------------
	SECTION FRAGMENT "Page 5",ROMX,BANK[2]
	LOAD FRAGMENT "Page 5 RAM",SRAM,BANK[5]
; Function PosAtX
; ---------------------------------
_PosAtX::
	add	sp, -9
	ld	hl, sp+7
	ld	[hl], a
	dec	hl
	ld	[hl], e
;src/editor/view.c:67: unsigned char* attrs = (unsigned char*)RowAddress(row) + (tile_attrs - tile_buffer);
	inc	hl
	ld	a, [hl]
	call	_RowAddress__far
	pop	hl
	push	bc
	ld	de, _tile_attrs
	ld	hl, _tile_buffer
	ld	a, e
	sub	a, l
	ld	e, a
	ld	a, d
	sbc	a, h
	ld	hl, sp+3
	ld	[hl], a
	dec	hl
	ld	[hl], e
	inc	hl
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	pop	hl
	push	hl
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+6
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+5
	ld	[hl], a
	dec	hl
	ld	a, [hl]
	ld	hl, sp+0
	ld	[hl], a
	ld	hl, sp+5
	ld	a, [hl]
	ld	hl, sp+1
	ld	[hl], a
;src/editor/view.c:68: unsigned char count = tb_row_counts[row], col = 0, width;
	ld	bc, _tb_row_counts+0
	ld	hl, sp+7
	ld	l, [hl]
	ld	h, $00
	add	hl, bc
	ld	c, l
	ld	b, h
	ld	a, [bc]
	ld	hl, sp+2
	ld	[hl], a
;src/editor/view.c:70: while (col < count) {
	ld	hl, sp+8
	ld	[hl], $00
.l00103:
	ld	hl, sp+8
	ld	a, [hl]
	ld	hl, sp+2
	sub	a, [hl]
	jp	NC, .l00105
;src/editor/view.c:71: width = attrs[col] & STYLE_WIDTH;
	pop	de
	push	de
	ld	hl, sp+8
	ld	l, [hl]
	ld	h, $00
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, [bc]
	and	a, $0F
	ld	hl, sp+3
	ld	[hl], a
;src/editor/view.c:72: if (x < ((width + 1) >> 1)) break;
	ld	c, [hl]
	ld	b, $00
	inc	bc
	sra	b
	rr	c
	ld	hl, sp+6
	ld	a, [hl]
	dec	hl
	dec	hl
	ld	[hl], a
	inc	hl
	ld	[hl], $00
	dec	hl
	ld	a, [hl]
	sub	a, c
	inc	hl
	ld	a, [hl]
	sbc	a, b
	ld	d, [hl]
	ld	a, b
	ld	e, a
	bit	7, e
	jp	Z, .l00164
	bit	7, d
	jp	NZ, .l00165
	cp	a, a
	jp	.l00165
.l00164:
	bit	7, d
	jp	Z, .l00165
	scf
.l00165:
	jp	C, .l00105
;src/editor/view.c:73: x = x < width ? 0 : x - width;
	ld	hl, sp+6
	ld	a, [hl]
	ld	hl, sp+3
	sub	a, [hl]
	jp	NC, .l00114
	xor	a, a
	inc	hl
	ld	[hl], a
	inc	hl
	ld	[hl], a
	jp	.l00115
.l00114:
	ld	hl, sp+6
	ld	a, [hl]
	ld	hl, sp+3
	sub	a, [hl]
	inc	hl
	ld	[hl], a
	inc	hl
	ld	[hl], $00
.l00115:
	ld	hl, sp+4
	ld	a, [hl]
	inc	hl
	inc	hl
	ld	[hl], a
;src/editor/view.c:74: ++col;
	inc	hl
	inc	hl
	inc	[hl]
	jp	.l00103
.l00105:
;src/editor/view.c:76: pos = tb_row_starts[row] + col;
	ld	hl, sp+7
	ld	a, [hl]
	ld	hl, sp+4
	ld	[hl], a
	inc	hl
	ld	[hl], $00
	dec	hl
	ld	a, [hl]
	ld	hl, sp+0
	ld	[hl], a
	ld	hl, sp+5
	ld	a, [hl]
	ld	hl, sp+1
	ld	[hl], a
	dec	hl
	sla	[hl]
	inc	hl
	rl	[hl]
	pop	de
	push	de
	ld	hl, _tb_row_starts
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+6
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+5
	ld	[hl], a
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	ld	hl, sp+0
	ld	[hl], a
	inc	de
	ld	a, [de]
	inc	hl
	ld	[hl], a
	ld	hl, sp+8
	ld	a, [hl]
	ld	hl, sp+4
	ld	[hl], a
	inc	hl
	ld	[hl], $00
	dec	hl
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	pop	hl
	push	hl
	add	hl, bc
	push	hl
	ld	a, l
	ld	hl, sp+6
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+5
	ld	[hl], a
;src/editor/view.c:77: if (tb_nowrap) {
	ld	hl, _tb_nowrap
	ld	a, [hl]
	or	a, a
	jp	Z, .l00107
;src/editor/view.c:78: pos += tb_left;
	ld	hl, sp+5
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, _tb_left
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	add	hl, de
	ld	c, l
	ld	b, h
	ld	hl, sp+4
	ld	[hl], c
	inc	hl
	ld	[hl], b
;src/editor/view.c:79: return pos > LineEnd(row) ? LineEnd(row) : pos;
	inc	hl
	inc	hl
	ld	a, [hl]
	call	_LineEnd
	ld	hl, sp+4
	ld	a, c
	sub	a, [hl]
	inc	hl
	ld	a, b
	sbc	a, [hl]
	jp	NC, .l00116
	ld	hl, sp+7
	ld	a, [hl]
	call	_LineEnd
	ld	hl, sp+4
	ld	[hl], c
	inc	hl
	ld	[hl], b
	jp	.l00117
.l00116:
.l00117:
	ld	hl, sp+4
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	jp	.l00112
.l00107:
;src/editor/view.c:81: if (col == count && pos == tb_row_starts[row + 1] && tb_end_row != row) --pos; // stay on wrapped row
	ld	hl, sp+2
	ld	a, [hl]
	ld	hl, sp+8
	sub	a, [hl]
	jp	NZ,.l00167
	jp	.l00168
.l00167:
	jp	.l00109
.l00168:
	ld	hl, sp+7
	ld	a, [hl]
	inc	hl
	ld	[hl], a
	inc	[hl]
	ld	a, [hl]
	ld	hl, sp+2
	ld	[hl], a
	rlca
	sbc	a, a
	inc	hl
	ld	[hl], a
	dec	hl
	ld	a, [hl]
	dec	hl
	dec	hl
	ld	[hl], a
	ld	hl, sp+3
	ld	a, [hl]
	dec	hl
	dec	hl
	ld	[hl], a
	dec	hl
	sla	[hl]
	inc	hl
	rl	[hl]
	pop	de
	push	de
	ld	hl, _tb_row_starts
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+4
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+3
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
	inc	hl
	ld	a, [hl]
	dec	hl
	dec	hl
	sub	a, [hl]
	jp	NZ,.l00170
	ld	hl, sp+5
	ld	a, [hl]
	dec	hl
	dec	hl
	sub	a, [hl]
	jp	NZ,.l00170
	jp	.l00171
.l00170:
	jp	.l00109
.l00171:
	ld	hl, _tb_end_row
	ld	a, [hl]
	ld	hl, sp+7
	sub	a, [hl]
	jp	NZ,.l00172
	jp	.l00109
.l00172:
	ld	hl, sp+5
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	dec	de
	dec	hl
	ld	[hl], e
	inc	hl
	ld	[hl], d
.l00109:
;src/editor/view.c:82: return pos;
	ld	hl, sp+4
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
.l00112:
;src/editor/view.c:83: }
	add	sp, 9
	ret
;src/editor/view.c:86: static unsigned char TextRows(void) {
;	---------------------------------
	SECTION FRAGMENT "Page 5",ROMX,BANK[2]
	LOAD FRAGMENT "Page 5 RAM",SRAM,BANK[5]
; Function TextRows
; ---------------------------------
_src_editor_view_c_TextRows:
;src/editor/view.c:87: return TB_ROWS - (bars << 1) - (osk_shown ? OSK_ROWS : 0);
	ld	hl, _bars
	ld	a, [hl]
	add	a, a
	ld	c, a
	ld	a, $12
	sub	a, c
	ld	c, a
	ld	hl, _osk_shown
	ld	a, [hl]
	or	a, a
	jp	Z, .l00103
	ld	de, $0005
	jp	.l00104
.l00103:
	ld	de, $0000
.l00104:
	ld	a, c
	sub	a, e
.l00101:
;src/editor/view.c:88: }
	ret
;src/editor/view.c:91: void ScrollDown(void) {
;	---------------------------------
	SECTION FRAGMENT "Page 5",ROMX,BANK[2]
	LOAD FRAGMENT "Page 5 RAM",SRAM,BANK[5]
; Function ScrollDown
; ---------------------------------
_ScrollDown::
;src/editor/view.c:92: ScrollRing(1);
	ld	a, $01
	call	_ScrollRing
;src/editor/view.c:93: tb_ScrollRows(1);
	ld	a, $01
	call	_tb_ScrollRows
;src/editor/view.c:94: tb_RenderRows(tb_rows - 1, tb_rows);
	ld	hl, _tb_rows
	ld	c, [hl]
	dec	c
	ld	e, [hl]
	ld	a, c
	call	_tb_RenderRows
;src/editor/view.c:95: top = tb_row_starts[0];
	ld	de, _tb_row_starts + 0
	ld	a, [de]
	ld	hl, _top
	ld	[hl], a
	inc	de
	ld	a, [de]
	inc	hl
	ld	[hl], a
;src/editor/view.c:96: redraw = 1;
	ld	hl, _redraw
	ld	[hl], $01
.l00101:
;src/editor/view.c:97: }
	ret
;src/editor/view.c:100: void ScrollUp(unsigned int new_top) {
;	---------------------------------
	SECTION FRAGMENT "Page 5",ROMX,BANK[2]
	LOAD FRAGMENT "Page 5 RAM",SRAM,BANK[5]
; Function ScrollUp
; ---------------------------------
_ScrollUp::
	ld	c, e
	ld	b, d
;src/editor/view.c:101: ScrollRing(0);
	push	bc
	xor	a, a
	call	_ScrollRing
	pop	bc
;src/editor/view.c:102: tb_ScrollRows(0);
	push	bc
	xor	a, a
	call	_tb_ScrollRows
	pop	bc
;src/editor/view.c:103: tb_row_starts[0] = new_top;
	ld	hl, _tb_row_starts
	ld	[hl], c
	inc	hl
	ld	[hl], b
;src/editor/view.c:104: tb_RenderRows(0, 1);
	push	bc
	ld	e, $01
	xor	a, a
	call	_tb_RenderRows
	pop	bc
;src/editor/view.c:105: top = new_top;
	ld	hl, _top
	ld	[hl], c
	inc	hl
	ld	[hl], b
;src/editor/view.c:106: redraw = 1;
	ld	hl, _redraw
	ld	[hl], $01
.l00101:
;src/editor/view.c:107: }
	ret
;src/editor/view.c:111: void RenderAfterEdit(void) {
;	---------------------------------
	SECTION FRAGMENT "Page 5",ROMX,BANK[2]
	LOAD FRAGMENT "Page 5 RAM",SRAM,BANK[5]
; Function RenderAfterEdit
; ---------------------------------
_RenderAfterEdit::
	add	sp, -16
;src/editor/view.c:112: unsigned char row = edit_row, end_row = tb_end_row, i;
	ld	hl, _edit_row
	ld	a, [hl]
	ld	hl, sp+14
	ld	[hl], a
	ld	hl, _tb_end_row
	ld	a, [hl]
	ld	hl, sp+0
	ld	[hl], a
;src/editor/view.c:113: unsigned int old_next, old_state, expected, delta = (unsigned int)(int)edit_delta;
	ld	hl, _edit_delta
	ld	a, [hl]
	ld	c, a
	rlca
	sbc	a, a
	ld	b, a
	ld	hl, sp+1
	ld	[hl], c
	inc	hl
	ld	[hl], b
;src/editor/view.c:114: if (row) --row; // the previous row's wrapping can change too
	ld	hl, sp+14
	ld	a, [hl]
	or	a, a
	jp	Z, .l00102
	dec	[hl]
.l00102:
;src/editor/view.c:115: if (end_row != 0xFF && end_row >= row) tb_end_row = 0xFF; // found again while scanning
	ld	hl, sp+0
	ld	a, [hl]
	inc	a
	jp	NZ,.l00184
	ld	a,$01
	jp	.l00185
.l00184:
	xor	a,a
.l00185:
	ld	hl, sp+3
	ld	[hl], a
	bit	0, [hl]
	jp	NZ, .l00134
	ld	hl, sp+0
	ld	a, [hl]
	ld	hl, sp+14
	sub	a, [hl]
	jp	C, .l00134
	ld	hl, _tb_end_row
	ld	[hl], $FF
.l00134:
	ld	hl, sp+14
	ld	a, [hl]
	inc	hl
	ld	[hl], a
.l00119:
;src/editor/view.c:116: for (; row < tb_rows; ++row) {
	ld	hl, sp+15
	ld	a, [hl]
	ld	hl, _tb_rows
	sub	a, [hl]
	jp	NC, .l00114
;src/editor/view.c:117: old_next = tb_row_starts[row + 1];
	ld	hl, sp+15
	ld	a, [hl]
	ld	hl, sp+4
	ld	[hl], a
	ld	a, [hl]
	inc	a
	inc	hl
	ld	[hl], a
	ld	a, [hl]
	ld	hl, sp+12
	ld	[hl], a
	rlca
	sbc	a, a
	inc	hl
	ld	[hl], a
	dec	hl
	sla	[hl]
	inc	hl
	rl	[hl]
	ld	de, _tb_row_starts
	dec	hl
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+8
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+7
	ld	[hl], a
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	ld	c, a
	inc	de
	ld	a, [de]
	ld	b, a
;src/editor/view.c:118: old_state = tb_row_states[row + 1];
	ld	de, _tb_row_states
	ld	hl, sp+12
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+10
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+9
	ld	[hl], a
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	inc	hl
	ld	[hl], a
	inc	de
	ld	a, [de]
	inc	hl
	ld	[hl], a
;src/editor/view.c:119: expected = old_next + delta;
	ld	hl, sp+1
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	add	hl, bc
	ld	e, l
	ld	a, h
	ld	hl, sp+12
	ld	[hl], e
	inc	hl
	ld	[hl], a
;src/editor/view.c:120: tb_RenderRows(row, row + 1);
	push	bc
	ld	hl, sp+7
	ld	e, [hl]
	ld	hl, sp+17
	ld	a, [hl]
	call	_tb_RenderRows
	pop	bc
;src/editor/view.c:121: if (old_next > edit_pos && tb_row_starts[row + 1] == expected && tb_row_states[row + 1] == old_state) {
	ld	hl, _edit_pos
	ld	a, [hl]
	sub	a, c
	inc	hl
	ld	a, [hl]
	sbc	a, b
	jp	NC, .l00120
	ld	hl, sp+7
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	ld	c, a
	inc	de
	ld	a, [de]
	ld	b, a
	ld	hl, sp+12
	ld	a, [hl]
	sub	a, c
	jp	NZ,.l00187
	inc	hl
	ld	a, [hl]
	sub	a, b
	jp	NZ,.l00187
	jp	.l00188
.l00187:
	jp	.l00120
.l00188:
	ld	hl, sp+9
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	ld	c, a
	inc	de
	ld	a, [de]
	ld	b, a
	inc	hl
	ld	a, [hl]
	sub	a, c
	jp	NZ,.l00189
	inc	hl
	ld	a, [hl]
	sub	a, b
	jp	NZ,.l00189
	jp	.l00190
.l00189:
	jp	.l00120
.l00190:
;src/editor/view.c:122: for (i = row + 2; i <= tb_rows; ++i) tb_row_starts[i] += delta; // rows below just moved
	ld	hl, sp+4
	ld	a, [hl]
	add	a, $02
	ld	hl, sp+15
	ld	[hl], a
.l00116:
	ld	hl, _tb_rows
	ld	a, [hl]
	ld	hl, sp+15
	sub	a, [hl]
	jp	C, .l00106
	ld	a, [hl]
	ld	b, $00
	add	a, a
	rl	b
	add	a, LOW(_tb_row_starts)
	ld	c, a
	ld	a, b
	adc	a, HIGH(_tb_row_starts)
	ld	b, a
	ld	e, c
	ld	d, b
	ld	a, [de]
	ld	hl, sp+12
	ld	[hl], a
	inc	de
	ld	a, [de]
	inc	hl
	ld	[hl], a
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, sp+1
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	add	hl, de
	ld	e, l
	ld	d, h
	ld	a, e
	ld	[bc], a
	inc	bc
	ld	a, d
	ld	[bc], a
	ld	hl, sp+15
	inc	[hl]
	jp	.l00116
.l00106:
;src/editor/view.c:123: if (end_row != 0xFF && end_row > row) tb_end_row = end_row;
	ld	hl, sp+3
	bit	0, [hl]
	jp	NZ, .l00114
	ld	hl, sp+14
	ld	a, [hl]
	ld	hl, sp+0
	sub	a, [hl]
	jp	NC, .l00114
	ld	a, [hl]
	ld	hl, _tb_end_row
	ld	[hl], a
;src/editor/view.c:124: break;
	jp	.l00114
.l00120:
;src/editor/view.c:116: for (; row < tb_rows; ++row) {
	ld	hl, sp+15
	inc	[hl]
	ld	a, [hl]
	dec	hl
	ld	[hl], a
	jp	.l00119
.l00114:
;src/editor/view.c:127: redraw = 1;
	ld	hl, _redraw
	ld	[hl], $01
.l00121:
;src/editor/view.c:128: }
	add	sp, 16
	ret
;src/editor/view.c:131: static void SetHighlight(void) {
;	---------------------------------
	SECTION FRAGMENT "Page 5",ROMX,BANK[2]
	LOAD FRAGMENT "Page 5 RAM",SRAM,BANK[5]
; Function SetHighlight
; ---------------------------------
_src_editor_view_c_SetHighlight:
	add	sp, -12
;src/editor/view.c:134: NoHighlight();
	call	_NoHighlight
;src/editor/view.c:135: if (!GetSelection()) return;
	call	_GetSelection__far
	ld	c, a
	ld	a, c
	or	a, a
	jp	NZ, .l00140
	jp	.l00119
;src/editor/view.c:136: for (row = 0; row < tb_rows; ++row) {
.l00140:
	ld	bc, _tb_row_starts+0
	ld	hl, sp+11
	ld	[hl], $00
.l00118:
	ld	hl, sp+11
	ld	a, [hl]
	ld	hl, _tb_rows
	sub	a, [hl]
	jp	NC, .l00119
;src/editor/view.c:137: row_start = tb_row_starts[row];
	ld	hl, sp+11
	ld	a, [hl]
	ld	e, $00
	ld	l, a
	ld	h, e
	add	hl, hl
	add	hl, bc
	ld	e, l
	ld	d, h
	ld	a, [de]
	ld	hl, sp+7
	ld	[hl], a
	inc	de
	ld	a, [de]
	inc	hl
	ld	[hl], a
;src/editor/view.c:138: next = tb_row_starts[row + 1];
	ld	hl, sp+11
	ld	a, [hl]
	inc	a
	ld	l, a
;	spillPairReg hl
;	spillPairReg hl
	rlca
	sbc	a, a
	ld	h, a
	add	hl, hl
	add	hl, bc
	ld	e, l
	ld	d, h
	ld	a, [de]
	ld	hl, sp+9
	ld	[hl], a
	inc	de
	ld	a, [de]
	inc	hl
	ld	[hl], a
;src/editor/view.c:139: if (sel_end <= row_start) break;
	ld	hl, sp+7
	ld	e, l
	ld	d, h
	ld	hl, _sel_end
	ld	a, [de]
	inc	de
	sub	a, [hl]
	inc	hl
	ld	a, [de]
	sbc	a, [hl]
	jp	NC, .l00119
;src/editor/view.c:140: if (sel_start >= next) continue;
	ld	de, _sel_start
	ld	hl, sp+9
	ld	a, [de]
	inc	de
	sub	a, [hl]
	inc	hl
	ld	a, [de]
	sbc	a, [hl]
	jp	NC, .l00115
;src/editor/view.c:141: count = tb_row_counts[row];
	ld	de, _tb_row_counts
	ld	hl, sp+11
	ld	l, [hl]
	ld	h, $00
	add	hl, de
	ld	e, l
	ld	d, h
	ld	a, [de]
	ld	hl, sp+2
	ld	[hl], a
;src/editor/view.c:142: base = row_start + (tb_nowrap ? tb_left : 0); // first drawn character
	ld	hl, _tb_nowrap
	ld	a, [hl]
	or	a, a
	jp	Z, .l00121
	ld	hl, _tb_left
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	jp	.l00122
.l00121:
	ld	de, $0000
.l00122:
	ld	hl, sp+7
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	add	hl, de
	ld	e, l
	ld	a, h
	ld	hl, sp+3
	ld	[hl], e
	inc	hl
	ld	[hl], a
;src/editor/view.c:143: first = 0;
	inc	hl
	ld	[hl], $00
;src/editor/view.c:144: if (sel_start > base) first = sel_start - base > count ? count : (unsigned char)(sel_start - base);
	ld	hl, sp+2
	ld	a, [hl]
	ld	hl, sp+6
	ld	[hl], a
	inc	hl
	ld	[hl], $00
	ld	hl, sp+3
	ld	a, [hl]
	ld	hl, sp+8
	ld	[hl], a
	ld	hl, sp+3
	ld	e, l
	ld	d, h
	ld	hl, _sel_start
	ld	a, [de]
	inc	de
	sub	a, [hl]
	inc	hl
	ld	a, [de]
	sbc	a, [hl]
	jp	NC, .l00108
	ld	hl, _sel_start + 1
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, sp+3
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	ld	a, e
	sub	a, l
	ld	e, a
	ld	a, d
	sbc	a, h
	ld	hl, sp+1
	ld	[hl], a
	dec	hl
	ld	[hl], e
	ld	hl, sp+6
	ld	e, l
	ld	d, h
	ld	hl, sp+0
	ld	a, [de]
	inc	de
	sub	a, [hl]
	inc	hl
	ld	a, [de]
	sbc	a, [hl]
	jp	NC, .l00123
	ld	hl, sp+2
	ld	a, [hl]
	jp	.l00124
.l00123:
	ld	hl, _sel_start
	ld	a, [hl]
	ld	hl, sp+8
	sub	a, [hl]
.l00124:
	ld	hl, sp+5
	ld	[hl], a
.l00108:
;src/editor/view.c:145: if (sel_end < next || row == tb_end_row) { // ends in this row
	ld	de, _sel_end
	ld	hl, sp+9
	ld	a, [de]
	inc	de
	sub	a, [hl]
	inc	hl
	ld	a, [de]
	sbc	a, [hl]
	jp	C, .l00111
	ld	hl, sp+11
	ld	a, [hl]
	ld	hl, _tb_end_row
	sub	a, [hl]
	jp	NZ,.l00190
	jp	.l00191
.l00190:
	jp	.l00112
.l00191:
.l00111:
;src/editor/view.c:146: end = sel_end <= base ? 0 : sel_end - base > count ? count : (unsigned char)(sel_end - base);
	ld	hl, sp+3
	ld	e, l
	ld	d, h
	ld	hl, _sel_end
	ld	a, [de]
	inc	de
	sub	a, [hl]
	inc	hl
	ld	a, [de]
	sbc	a, [hl]
	jp	C, .l00125
	xor	a, a
	ld	e, a
	jp	.l00126
.l00125:
	ld	hl, _sel_end + 1
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, sp+3
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	ld	a, e
	sub	a, l
	ld	e, a
	ld	a, d
	sbc	a, h
	ld	hl, sp+10
	ld	[hl], a
	dec	hl
	ld	[hl], e
	ld	hl, sp+6
	ld	e, l
	ld	d, h
	ld	hl, sp+9
	ld	a, [de]
	inc	de
	sub	a, [hl]
	inc	hl
	ld	a, [de]
	sbc	a, [hl]
	jp	NC, .l00127
	ld	hl, sp+2
	ld	a, [hl]
	jp	.l00128
.l00127:
	ld	hl, _sel_end
	ld	a, [hl]
	ld	hl, sp+8
	sub	a, [hl]
.l00128:
	ld	e, $00
.l00126:
	ld	hl, sp+10
	ld	[hl], a
;src/editor/view.c:147: if (end <= first) continue;
	ld	hl, sp+5
	ld	a, [hl]
	ld	hl, sp+10
	sub	a, [hl]
	jp	C, .l00113
	jp	.l00115
.l00112:
;src/editor/view.c:149: else end = 0xFF; // continues, so the line feed or wrap is selected too
	ld	hl, sp+10
	ld	[hl], $FF
.l00113:
;src/editor/view.c:150: render_sel[(row + bars) << 1] = first;
	ld	hl, sp+11
	ld	a, [hl]
	ld	hl, _bars
	add	a, [hl]
	add	a, a
	ld	e, a
	rlca
	sbc	a, a
	ld	d, a
	ld	hl, _render_sel
	add	hl, de
	ld	e, l
	ld	d, h
	ld	hl, sp+5
	ld	a, [hl]
	ld	[de], a
;src/editor/view.c:151: render_sel[((row + bars) << 1) + 1] = end;
	ld	hl, sp+11
	ld	a, [hl]
	ld	hl, _bars
	add	a, [hl]
	add	a, a
	inc	a
	ld	e, a
	rlca
	sbc	a, a
	ld	d, a
	ld	hl, _render_sel
	add	hl, de
	ld	e, l
	ld	d, h
	ld	hl, sp+10
	ld	a, [hl]
	ld	[de], a
.l00115:
;src/editor/view.c:136: for (row = 0; row < tb_rows; ++row) {
	ld	hl, sp+11
	inc	[hl]
	jp	.l00118
.l00119:
;src/editor/view.c:153: }
	add	sp, 12
	ret
;src/editor/view.c:156: static unsigned int LinesBefore(unsigned int pos) {
;	---------------------------------
	SECTION FRAGMENT "Page 5",ROMX,BANK[2]
	LOAD FRAGMENT "Page 5 RAM",SRAM,BANK[5]
; Function LinesBefore
; ---------------------------------
_src_editor_view_c_LinesBefore:
;src/editor/view.c:157: if (pos >= counted_pos) counted_lines += tb_CountLines(counted_pos, pos);
	ld	hl, _counted_pos
	ld	a, e
	sub	a, [hl]
	inc	hl
	ld	a, d
	sbc	a, [hl]
	jp	C, .l00105
	push	de
	ld	c, e
	ld	b, d
	ld	hl, _counted_pos
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_tb_CountLines
	pop	de
	ld	hl, _counted_lines
	ld	a, [hl]
	add	a, c
	ld	[hl], a
	inc	hl
	ld	a, [hl]
	adc	a, b
	ld	[hl], a
	jp	.l00106
.l00105:
;src/editor/view.c:158: else if (pos < counted_pos - pos) counted_lines = tb_CountLines(0, pos);
	ld	hl, _counted_pos
	ld	a, [hl]
	sub	a, e
	ld	c, a
	inc	hl
	ld	a, [hl]
	sbc	a, d
	ld	b, a
	ld	a, e
	sub	a, c
	ld	a, d
	sbc	a, b
	jp	NC, .l00102
	push	de
	ld	c, e
	ld	b, d
	ld	de, $0000
	call	_tb_CountLines
	pop	de
	ld	hl, _counted_lines
	ld	[hl], c
	inc	hl
	ld	[hl], b
	jp	.l00106
.l00102:
;src/editor/view.c:159: else counted_lines -= tb_CountLines(pos, counted_pos);
	push	de
	ld	hl, _counted_pos
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	call	_tb_CountLines
	pop	de
	ld	hl, _counted_lines
	ld	a, [hl]
	sub	a, c
	ld	[hl], a
	inc	hl
	ld	a, [hl]
	sbc	a, b
	ld	[hl], a
.l00106:
;src/editor/view.c:160: counted_pos = pos;
	ld	hl, _counted_pos
	ld	[hl], e
	inc	hl
	ld	[hl], d
;src/editor/view.c:161: return counted_lines;
	ld	hl, _counted_lines
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
.l00107:
;src/editor/view.c:162: }
	ret
;src/editor/view.c:165: void CountEdit(unsigned int pos, unsigned char c, unsigned char inserted) {
;	---------------------------------
	SECTION FRAGMENT "Page 5",ROMX,BANK[2]
	LOAD FRAGMENT "Page 5 RAM",SRAM,BANK[5]
; Function CountEdit
; ---------------------------------
_CountEdit::
	ld	c, a
;src/editor/view.c:166: if (pos >= counted_pos) return;
	ld	hl, _counted_pos
	ld	a, e
	sub	a, [hl]
	inc	hl
	ld	a, d
	sbc	a, [hl]
	jp	C, .l00102
	jp	.l00110
.l00102:
;src/editor/view.c:169: if (c == ASCII_LF) ++counted_lines;
	ld	a, c
	sub	a, $0A
	jp	NZ,.l00132
	ld	a,$01
	jp	.l00133
.l00132:
	xor	a,a
.l00133:
	ld	c, a
;src/editor/view.c:167: if (inserted) {
	ld	hl, sp+2
	ld	a, [hl]
	or	a, a
	jp	Z, .l00108
;src/editor/view.c:168: ++counted_pos;
	ld	hl, _counted_pos
	inc	[hl]
	jp	NZ, .l00134
	inc	hl
	inc	[hl]
.l00134:
;src/editor/view.c:169: if (c == ASCII_LF) ++counted_lines;
	ld	a, c
	or	a, a
	jp	Z, .l00110
	ld	hl, _counted_lines
	inc	[hl]
	jp	NZ, .l00135
	inc	hl
	inc	[hl]
.l00135:
	jp	.l00110
.l00108:
;src/editor/view.c:172: --counted_pos;
	ld	hl, _counted_pos + 1
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	dec	de
	dec	hl
	ld	[hl], e
	inc	hl
	ld	[hl], d
;src/editor/view.c:173: if (c == ASCII_LF) --counted_lines;
	ld	a, c
	or	a, a
	jp	Z, .l00110
	ld	hl, _counted_lines + 1
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	dec	de
	dec	hl
	ld	[hl], e
	inc	hl
	ld	[hl], d
.l00110:
;src/editor/view.c:175: }
	pop	hl
	inc	sp
	jp hl
;src/editor/view.c:178: void Uncount(unsigned int pos) {
;	---------------------------------
	SECTION FRAGMENT "Page 5",ROMX,BANK[2]
	LOAD FRAGMENT "Page 5 RAM",SRAM,BANK[5]
; Function Uncount
; ---------------------------------
_Uncount::
;src/editor/view.c:179: if (pos < counted_pos) counted_pos = counted_lines = 0;
	ld	hl, _counted_pos
	ld	a, e
	sub	a, [hl]
	inc	hl
	ld	a, d
	sbc	a, [hl]
	jp	NC, .l00103
	xor	a, a
	ld	hl, _counted_lines
	ld	[hl], a
	inc	hl
	ld	[hl], a
	xor	a, a
	ld	hl, _counted_pos
	ld	[hl], a
	inc	hl
	ld	[hl], a
.l00103:
;src/editor/view.c:180: }
	ret
;src/editor/view.c:183: static unsigned char RowEndsLine(unsigned char row) {
;	---------------------------------
	SECTION FRAGMENT "Page 5",ROMX,BANK[2]
	LOAD FRAGMENT "Page 5 RAM",SRAM,BANK[5]
; Function RowEndsLine
; ---------------------------------
_src_editor_view_c_RowEndsLine:
	ld	e, a
;src/editor/view.c:184: return tb_GetChar(tb_row_starts[row + 1] - 1) == ASCII_LF;
	ld	bc, _tb_row_starts+0
	inc	e
	ld	a, e
	rlca
	sbc	a, a
	ld	l, e
	ld	h, a
	add	hl, hl
	add	hl, bc
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	dec	bc
	ld	e, c
	ld	d, b
	call	_tb_GetChar
	sub	a, $0A
	jp	NZ,.l00103
	ld	a,$01
	jp	.l00104
.l00103:
	xor	a,a
.l00104:
.l00101:
;src/editor/view.c:185: }
	ret
;src/editor/view.c:187: static unsigned int CursorLine(void) {
;	---------------------------------
	SECTION FRAGMENT "Page 5",ROMX,BANK[2]
	LOAD FRAGMENT "Page 5 RAM",SRAM,BANK[5]
; Function CursorLine
; ---------------------------------
_src_editor_view_c_CursorLine:
;src/editor/view.c:188: unsigned int line = LinesBefore(top) + 1;
	ld	hl, _top
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_src_editor_view_c_LinesBefore
	inc	bc
;src/editor/view.c:190: for (row = 0; row < tb_found_row; ++row) if (RowEndsLine(row)) ++line;
	ld	e, $00
.l00105:
	ld	a, e
	ld	hl, _tb_found_row
	sub	a, [hl]
	jp	NC, .l00103
	push	bc
	push	de
	ld	a, e
	call	_src_editor_view_c_RowEndsLine
	pop	de
	pop	bc
	or	a, a
	jp	Z, .l00106
	inc	bc
.l00106:
	inc	e
	jp	.l00105
.l00103:
;src/editor/view.c:191: return line;
.l00107:
;src/editor/view.c:192: }
	ret
;src/editor/view.c:194: static unsigned int CursorColumn(void) {
;	---------------------------------
	SECTION FRAGMENT "Page 5",ROMX,BANK[2]
	LOAD FRAGMENT "Page 5 RAM",SRAM,BANK[5]
; Function CursorColumn
; ---------------------------------
_src_editor_view_c_CursorColumn:
	dec	sp
	dec	sp
;src/editor/view.c:195: unsigned char row = tb_found_row;
	ld	hl, _tb_found_row
	ld	c, [hl]
;src/editor/view.c:197: while (row && !RowEndsLine(row - 1)) --row;
.l00102:
	ld	a, c
	or	a, a
	jp	Z, .l00104
	ld	b, c
	dec	b
	push	bc
	ld	a, b
	call	_src_editor_view_c_RowEndsLine
	pop	bc
	or	a, a
	jp	NZ, .l00104
	dec	c
	jp	.l00102
.l00104:
;src/editor/view.c:198: start = tb_row_starts[row];
	ld	l, c
;	spillPairReg hl
;	spillPairReg hl
	ld	h, $00
;	spillPairReg hl
;	spillPairReg hl
	add	hl, hl
	ld	de, _tb_row_starts
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
;src/editor/view.c:199: if (!row && start && tb_GetChar(start - 1) != ASCII_LF) start = tb_LineStart(start);
	ld	a, c
	or	a, a
	jp	NZ, .l00106
	ld	hl, sp+1
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	jp	Z, .l00106
	pop	bc
	push	bc
	dec	bc
	ld	e, c
	ld	d, b
	call	_tb_GetChar
	sub	a, $0A
	jp	NZ,.l00142
	jp	.l00106
.l00142:
	pop	de
	push	de
	call	_tb_LineStart
	pop	hl
	push	bc
.l00106:
;src/editor/view.c:200: return cursor - start + 1;
	ld	hl, _cursor + 1
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	pop	hl
	push	hl
	ld	a, e
	sub	a, l
	ld	e, a
	ld	a, d
	sbc	a, h
	ld	b, a
	ld	c, e
	inc	bc
.l00109:
;src/editor/view.c:201: }
	inc	sp
	inc	sp
	ret
;src/editor/view.c:204: void UpdateBars(void) {
;	---------------------------------
	SECTION FRAGMENT "Page 5",ROMX,BANK[2]
	LOAD FRAGMENT "Page 5 RAM",SRAM,BANK[5]
; Function UpdateBars
; ---------------------------------
_UpdateBars::
	add	sp, -48
;src/editor/view.c:206: char* end = file_name[0] ? ToLatin1(text, file_name, TB_STRIDE - 3) : PutText(text, "Untitled");
	ld	bc, _file_name+0
	ld	a, [bc]
	ld	e, a
	ld	a, e
	or	a, a
	jp	Z, .l00116
	ld	hl, sp+0
	ld	e, l
	ld	d, h
	ld	a, $25
	push	af
	inc	sp
	call	_ToLatin1__far
	jp	.l00117
.l00116:
	ld	bc, _src_editor_view_c___str_0
	ld	hl, 0
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_PutText
.l00117:
;src/editor/view.c:207: if (modified) *end++ = '*';
	ld	hl, _modified
	ld	a, [hl]
	or	a, a
	jp	Z, .l00102
	ld	a, $2A
	ld	[bc], a
	inc	bc
.l00102:
;src/editor/view.c:208: *end = 0;
	xor	a, a
	ld	[bc], a
;src/editor/view.c:209: DrawRow(HEADER_LINE, 1, text);
	ld	hl, 0
	add	hl, sp
	push	hl
	ld	e, $01
	ld	a, $12
	call	_DrawRow__far
;src/editor/view.c:210: if (tb_found_row == 0xFF) return; // cursor isn't on screen
	ld	hl, _tb_found_row
	ld	a, [hl]
	inc	a
	jp	NZ,.l00148
	jp	.l00149
.l00148:
	jp	.l00104
.l00149:
	jp	.l00114
.l00104:
;src/editor/view.c:211: if (GetSelection()) {
	call	_GetSelection__far
	ld	c, a
	ld	a, c
	or	a, a
	jp	Z, .l00112
;src/editor/view.c:212: end = PutNumber(text, sel_end - sel_start);
	ld	hl, _sel_end
	ld	a, [hl]
	ld	hl, _sel_start
	sub	a, [hl]
	ld	c, a
	ld	hl, _sel_end + 1
	ld	a, [hl]
	ld	hl, _sel_start + 1
	sbc	a, [hl]
	ld	b, a
	ld	de, $0000
	push	de
	push	bc
	ld	hl, 4
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_PutNumber__far
	ld	e, c
	ld	d, b
;src/editor/view.c:213: end = PutText(end, " selected");
	ld	bc, _src_editor_view_c___str_1
	call	_PutText
	ld	e, c
	ld	d, b
	jp	.l00113
.l00112:
;src/editor/view.c:216: end = PutText(text, "Line ");
	ld	bc, _src_editor_view_c___str_2
	ld	hl, 0
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_PutText
;src/editor/view.c:217: if (!doc_large) end = PutNumber(end, CursorLine());
	ld	hl, _doc_large
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00109
	push	bc
	call	_src_editor_view_c_CursorLine
	ld	e, c
	ld	d, b
	pop	bc
	ld	hl, $0000
	push	hl
	push	de
	ld	e, c
	ld	d, b
	call	_PutNumber__far
	ld	e, c
	ld	d, b
	jp	.l00110
.l00109:
;src/editor/view.c:218: else if (lines_known) end = PutNumber(end, CursorLine() + win_lines);
	ld	hl, _lines_known
	ld	a, [hl]
	or	a, a
	jp	Z, .l00106
	push	bc
	call	_src_editor_view_c_CursorLine
	ld	e, c
	ld	d, b
	pop	bc
	ld	hl, sp+40
	ld	[hl], e
	inc	hl
	ld	[hl], d
	xor	a, a
	inc	hl
	ld	[hl], a
	inc	hl
	ld	[hl], a
	dec	hl
	dec	hl
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, e
	ld	hl, _win_lines
	add	a, [hl]
	ld	e, a
	ld	a, d
	inc	hl
	adc	a, [hl]
	push	af
	ld	hl, sp+47
	ld	[hl], a
	dec	hl
	ld	[hl], e
	dec	hl
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, _win_lines + 2
	pop	af
	ld	a, e
	adc	a, [hl]
	ld	e, a
	ld	a, d
	inc	hl
	adc	a, [hl]
	ld	hl, sp+47
	ld	[hl], a
	dec	hl
	ld	[hl], e
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	push	de
	ld	hl, sp+46
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	push	de
	ld	e, c
	ld	d, b
	call	_PutNumber__far
	ld	e, c
	ld	d, b
	jp	.l00110
.l00106:
;src/editor/view.c:219: else *end++ = '?';
	ld	a, $3F
	ld	[bc], a
	ld	e, c
	ld	d, b
	inc	de
.l00110:
;src/editor/view.c:220: end = PutText(end, ", Col ");
	ld	bc, _src_editor_view_c___str_3
	call	_PutText
	ld	e, c
	ld	d, b
;src/editor/view.c:221: end = PutNumber(end, CursorColumn());
	push	de
	call	_src_editor_view_c_CursorColumn
	pop	de
	ld	hl, $0000
	push	hl
	push	bc
	call	_PutNumber__far
	ld	e, c
	ld	d, b
.l00113:
;src/editor/view.c:223: *end = 0;
	xor	a, a
	ld	[de], a
;src/editor/view.c:224: DrawRow(STATUS_LINE, 1, text);
	ld	hl, 0
	add	hl, sp
	push	hl
	ld	e, $01
	ld	a, $13
	call	_DrawRow__far
.l00114:
;src/editor/view.c:225: }
	add	sp, 48
	ret
	SECTION FRAGMENT "src/editor/view.c FIXED",ROMX,BANK[1]
_src_editor_view_c___str_0:
	DB "Untitled"
	DB $00
	SECTION FRAGMENT "src/editor/view.c FIXED",ROMX,BANK[1]
_src_editor_view_c___str_1:
	DB " selected"
	DB $00
	SECTION FRAGMENT "src/editor/view.c FIXED",ROMX,BANK[1]
_src_editor_view_c___str_2:
	DB "Line "
	DB $00
	SECTION FRAGMENT "src/editor/view.c FIXED",ROMX,BANK[1]
_src_editor_view_c___str_3:
	DB ", Col "
	DB $00
;src/editor/view.c:227: void Draw(void) {
;	---------------------------------
	SECTION FRAGMENT "Page 5",ROMX,BANK[2]
	LOAD FRAGMENT "Page 5 RAM",SRAM,BANK[5]
; Function Draw
; ---------------------------------
_Draw::
;src/editor/view.c:228: SetHighlight();
	call	_src_editor_view_c_SetHighlight
;src/editor/view.c:229: if (bars) UpdateBars();
	ld	hl, _bars
	ld	a, [hl]
	or	a, a
	jp	Z, .l00102
	call	_UpdateBars
.l00102:
;src/editor/view.c:230: EditorDraw();
	jp	_EditorDraw
.l00103:
;src/editor/view.c:231: }
	ret
;src/editor/view.c:234: void SetRows(void) {
;	---------------------------------
	SECTION FRAGMENT "Page 5",ROMX,BANK[2]
	LOAD FRAGMENT "Page 5 RAM",SRAM,BANK[5]
; Function SetRows
; ---------------------------------
_SetRows::
;src/editor/view.c:235: bars = bars_on;
	ld	hl, _bars_on
	ld	a, [hl]
	ld	hl, _bars
	ld	[hl], a
;src/editor/view.c:236: tb_rows = TextRows();
	call	_src_editor_view_c_TextRows
	ld	hl, _tb_rows
	ld	[hl], a
;src/editor/view.c:237: Layout();
	call	_Layout
;src/editor/view.c:238: if (osk_shown) {
	ld	hl, _osk_shown
	ld	a, [hl]
	or	a, a
	jp	Z, .l00102
;src/editor/view.c:239: OSKDraw(osk_layer, tb_rows);
	ld	hl, _tb_rows
	ld	e, [hl]
	ld	hl, _osk_layer
	ld	a, [hl]
	call	_OSKDraw
;src/editor/view.c:240: OSKSelect(osk_x, osk_y);
	ld	hl, _osk_y
	ld	e, [hl]
	ld	hl, _osk_x
	ld	a, [hl]
	call	_OSKSelect
.l00102:
;src/editor/view.c:242: OSKShow(osk_shown);
	ld	hl, _osk_shown
	ld	a, [hl]
	call	_OSKShow
;src/editor/view.c:243: dirty = 1;
	ld	hl, _dirty
	ld	[hl], $01
.l00103:
;src/editor/view.c:244: }
	ret
;src/editor/view.c:247: void ToggleBars(void) {
;	---------------------------------
	SECTION FRAGMENT "Page 6",ROMX,BANK[3]
	LOAD FRAGMENT "Page 6 RAM",SRAM,BANK[6]
; Function ToggleBars
; ---------------------------------
_ToggleBars::
;src/editor/view.c:248: bars_on = !bars_on;
	ld	hl, _bars_on
	ld	a, [hl]
	sub	a,$01
	ld	a, $00
	rla
	ld	[hl], a
;src/editor/view.c:249: SetRows();
	call	_SetRows__far
;src/editor/view.c:250: SettingsSave();
	jp	_SettingsSave
.l00101:
;src/editor/view.c:251: }
	ret
;src/editor/view.c:254: void BeginFullScreen(void) {
;	---------------------------------
	SECTION FRAGMENT "Page 6",ROMX,BANK[3]
	LOAD FRAGMENT "Page 6 RAM",SRAM,BANK[6]
; Function BeginFullScreen
; ---------------------------------
_BeginFullScreen::
;src/editor/view.c:255: EditorShowCursor(0);
	xor	a, a
	call	_EditorShowCursor
;src/editor/view.c:256: if (osk_shown) OSKShow(0);
	ld	hl, _osk_shown
	ld	a, [hl]
	or	a, a
	jp	Z, .l00102
	xor	a, a
	call	_OSKShow
.l00102:
;src/editor/view.c:257: bars = 0;
	ld	hl, _bars
	ld	[hl], $00
;src/editor/view.c:258: tb_rows = TB_ROWS;
	ld	hl, _tb_rows
	ld	[hl], $12
;src/editor/view.c:259: Layout();
	call	_Layout__far
;src/editor/view.c:260: NoHighlight();
	call	_NoHighlight__far
;src/editor/view.c:261: dirty = 1;
	ld	hl, _dirty
	ld	[hl], $01
.l00103:
;src/editor/view.c:262: }
	ret
;src/editor/view.c:264: void EndFullScreen(void) {
;	---------------------------------
	SECTION FRAGMENT "Page 6",ROMX,BANK[3]
	LOAD FRAGMENT "Page 6 RAM",SRAM,BANK[6]
; Function EndFullScreen
; ---------------------------------
_EndFullScreen::
;src/editor/view.c:265: SetRows();
	jp	_SetRows__far
.l00101:
;src/editor/view.c:266: }
	ret
;src/editor/view.c:268: void Render(void) {
;	---------------------------------
	SECTION FRAGMENT "Page 7",ROMX,BANK[3]
	LOAD FRAGMENT "Page 7 RAM",SRAM,BANK[7]
; Function Render
; ---------------------------------
_Render::
;src/editor/view.c:269: tb_find = cursor;
	ld	hl, _cursor
	ld	a, [hl]
	ld	hl, _tb_find
	ld	[hl], a
	ld	hl, _cursor + 1
	ld	a, [hl]
	ld	hl, _tb_find + 1
	ld	[hl], a
;src/editor/view.c:270: tb_Render(top);
	ld	hl, _top
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	jp	_tb_Render
.l00101:
;src/editor/view.c:271: }
	ret
;src/editor/view.c:273: static unsigned char CharWidth(unsigned char c) {
;	---------------------------------
	SECTION FRAGMENT "Page 5",ROMX,BANK[2]
	LOAD FRAGMENT "Page 5 RAM",SRAM,BANK[5]
; Function CharWidth
; ---------------------------------
_src_editor_view_c_CharWidth:
	ld	e, a
;src/editor/view.c:274: if (c < ' ') c = ' '; // control characters are drawn as spaces
	ld	a, e
	sub	a, $20
	jp	NC, .l00102
	ld	e, $20
.l00102:
;src/editor/view.c:275: if (code_line) return CODE_WIDTH;
	ld	hl, _src_editor_view_c_code_line
	ld	a, [hl]
	or	a, a
	jp	Z, .l00104
	ld	a, $04
	jp	.l00105
.l00104:
;src/editor/view.c:276: return head_level ? HeadingCharWidth(head_level, c) : font_widths[c];
	ld	hl, _src_editor_view_c_head_level
	ld	a, [hl]
	or	a, a
	jp	Z, .l00107
	ld	a, [hl]
	call	_HeadingCharWidth
	jp	.l00108
.l00107:
	ld	hl, _font_widths
	ld	d, $00
	add	hl, de
	ld	a, [hl]
.l00108:
.l00105:
;src/editor/view.c:277: }
	ret
;src/editor/view.c:281: static void LineHeading(unsigned int start, unsigned char row) {
;	---------------------------------
	SECTION FRAGMENT "Page 5",ROMX,BANK[2]
	LOAD FRAGMENT "Page 5 RAM",SRAM,BANK[5]
; Function LineHeading
; ---------------------------------
_src_editor_view_c_LineHeading:
	add	sp, -7
	ld	hl, sp+5
	ld	[hl], e
	inc	hl
	ld	[hl], d
	dec	hl
	dec	hl
	ld	[hl], a
;src/editor/view.c:282: unsigned int pos = start, length = tb_Length();
	call	_tb_Length
	pop	hl
	push	bc
;src/editor/view.c:283: head_level = 0;
	ld	hl, _src_editor_view_c_head_level
	ld	[hl], $00
;src/editor/view.c:284: code_line = 0;
	ld	hl, _src_editor_view_c_code_line
	ld	[hl], $00
;src/editor/view.c:285: if (tb_lang != LANG_MD) return;
	ld	hl, _tb_lang
	ld	a, [hl]
	dec	a
	jp	NZ,.l00196
	jp	.l00128
.l00196:
	jp	.l00122
;src/editor/view.c:286: while (pos < length && pos - start < 3 && tb_GetChar(pos) == '`') ++pos;
.l00128:
	ld	hl, sp+5
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
.l00105:
	ld	hl, sp+6
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, c
	sub	a, e
	ld	e, a
	ld	a, b
	sbc	a, d
	ld	hl, sp+3
	ld	[hl], a
	dec	hl
	ld	[hl], e
	dec	hl
	dec	hl
	ld	a, c
	sub	a, [hl]
	inc	hl
	ld	a, b
	sbc	a, [hl]
	jp	NC, .l00107
	ld	hl, sp+2
	ld	a, [hl]
	sub	a, $03
	inc	hl
	ld	a, [hl]
	sbc	a, $00
	jp	NC, .l00107
	push	bc
	ld	e, c
	ld	d, b
	call	_tb_GetChar
	pop	bc
	sub	a, $60
	jp	NZ,.l00197
	jp	.l00198
.l00197:
	jp	.l00107
.l00198:
	inc	bc
	jp	.l00105
.l00107:
;src/editor/view.c:287: if (pos - start == 3 || (row != 0xFF && (tb_row_states[row] & MD_FENCE_STATE))) { code_line = 1; return; }
	ld	hl, sp+2
	ld	a, [hl]
	sub	a, $03
	inc	hl
	or	a, [hl]
	jp	NZ,.l00199
	jp	.l00108
.l00199:
	ld	hl, sp+4
	ld	a, [hl]
	inc	a
	jp	NZ,.l00200
	jp	.l00134
.l00200:
	ld	hl, sp+4
	ld	a, [hl]
	ld	c, $00
	ld	l, a
	ld	h, c
	add	hl, hl
	ld	de, _tb_row_states
	add	hl, de
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	bit	6, b
	jp	NZ,.l00201
	jp	.l00134
.l00201:
.l00108:
	ld	hl, _src_editor_view_c_code_line
	ld	[hl], $01
	jp	.l00122
;src/editor/view.c:289: while (pos < length && pos - start < 7 && tb_GetChar(pos) == '#') ++pos;
.l00134:
	ld	hl, sp+5
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
.l00114:
	ld	hl, sp+6
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, c
	sub	a, e
	ld	e, a
	ld	a, b
	sbc	a, d
	ld	hl, sp+3
	ld	[hl], a
	dec	hl
	ld	[hl], e
	dec	hl
	dec	hl
	ld	a, c
	sub	a, [hl]
	inc	hl
	ld	a, b
	sbc	a, [hl]
	jp	NC, .l00116
	ld	hl, sp+2
	ld	a, [hl]
	sub	a, $07
	inc	hl
	ld	a, [hl]
	sbc	a, $00
	jp	NC, .l00116
	push	bc
	ld	e, c
	ld	d, b
	call	_tb_GetChar
	pop	bc
	sub	a, $23
	jp	NZ,.l00202
	jp	.l00203
.l00202:
	jp	.l00116
.l00203:
	inc	bc
	jp	.l00114
.l00116:
;src/editor/view.c:290: if (pos == start || pos - start > 4 || pos == length || tb_GetChar(pos) != ' ') return;
	ld	hl, sp+5
	ld	a, [hl]
	sub	a, c
	jp	NZ,.l00204
	inc	hl
	ld	a, [hl]
	sub	a, b
	jp	NZ,.l00204
	jp	.l00117
.l00204:
	ld	hl, sp+2
	ld	a, $04
	sub	a, [hl]
	inc	hl
	ld	a, $00
	sbc	a, [hl]
	jp	C, .l00117
	ld	hl, sp+0
	ld	a, [hl]
	sub	a, c
	jp	NZ,.l00205
	inc	hl
	ld	a, [hl]
	sub	a, b
	jp	NZ,.l00205
	jp	.l00117
.l00205:
	push	bc
	ld	e, c
	ld	d, b
	call	_tb_GetChar
	pop	bc
	sub	a, $20
	jp	NZ,.l00206
	jp	.l00118
.l00206:
.l00117:
	jp	.l00122
.l00118:
;src/editor/view.c:291: head_level = (unsigned char)(pos - start);
	ld	a, c
	ld	hl, sp+5
	ld	c, [hl]
	sub	a, c
	ld	hl, _src_editor_view_c_head_level
	ld	[hl], a
.l00122:
;src/editor/view.c:292: }
	add	sp, 7
	ret
;src/editor/view.c:296: static unsigned char ScrollX(void) {
;	---------------------------------
	SECTION FRAGMENT "Page 5",ROMX,BANK[2]
	LOAD FRAGMENT "Page 5 RAM",SRAM,BANK[5]
; Function ScrollX
; ---------------------------------
_src_editor_view_c_ScrollX:
	add	sp, -9
;src/editor/view.c:297: unsigned char row = tb_found_row, count;
	ld	hl, _tb_found_row
	ld	a, [hl]
	ld	hl, sp+0
	ld	[hl], a
;src/editor/view.c:298: unsigned int start = row == 0xFF ? tb_LineStart(cursor) : tb_row_starts[row];
	ld	a, [hl]
	inc	a
	jp	NZ,.l00221
	ld	a,$01
	jp	.l00222
.l00221:
	xor	a,a
.l00222:
	ld	hl, sp+8
	ld	[hl], a
	ld	a, [hl]
	or	a, a
	jp	Z, .l00132
	ld	hl, _cursor
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_tb_LineStart
	jp	.l00133
.l00132:
	ld	bc, _tb_row_starts+0
	ld	hl, sp+0
	ld	e, [hl]
	ld	d, $00
	ld	l, e
	ld	h, d
	add	hl, hl
	add	hl, bc
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
.l00133:
	ld	hl, sp+1
	ld	[hl], c
	inc	hl
	ld	[hl], b
;src/editor/view.c:299: unsigned int col = cursor - start, length = tb_Length(), pos, x = 0, left;
	ld	hl, _cursor + 1
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, sp+1
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	ld	a, e
	sub	a, l
	ld	e, a
	ld	a, d
	sbc	a, h
	ld	b, a
	ld	c, e
	push	bc
	call	_tb_Length
	ld	e, c
	ld	d, b
	pop	bc
	ld	hl, sp+3
	ld	[hl], e
	inc	hl
	ld	[hl], d
;src/editor/view.c:300: unsigned char c, keep = KEEP_LEFT;
	inc	hl
	ld	[hl], $28
;src/editor/view.c:301: if (col < tb_left) keep = KEEP_RIGHT;
	ld	hl, _tb_left
	ld	a, c
	sub	a, [hl]
	inc	hl
	ld	a, b
	sbc	a, [hl]
	jp	NC, .l00110
	ld	hl, sp+5
	ld	[hl], $78
	jp	.l00111
.l00110:
;src/editor/view.c:302: else if (row != 0xFF) { // its char is drawn, or it's the line's end right of its last one
	ld	hl, sp+8
	ld	e, [hl]
	bit	0, e
	jp	NZ, .l00111
;src/editor/view.c:303: count = tb_row_counts[row];
	ld	de, _tb_row_counts+0
	ld	hl, sp+0
	ld	l, [hl]
	ld	h, $00
	add	hl, de
	ld	e, l
	ld	d, h
	ld	a, [de]
	ld	hl, sp+6
	ld	[hl], a
;src/editor/view.c:304: if (col - tb_left < count) return 0;
	ld	a, c
	ld	hl, _tb_left
	sub	a, [hl]
	ld	e, a
	ld	a, b
	inc	hl
	sbc	a, [hl]
	ld	d, a
	ld	hl, sp+6
	ld	a, [hl]
	inc	hl
	ld	[hl], a
	inc	hl
	ld	[hl], $00
	dec	hl
	ld	a, e
	sub	a, [hl]
	inc	hl
	ld	a, d
	sbc	a, [hl]
	jp	NC, .l00102
	xor	a, a
	jp	.l00130
.l00102:
;src/editor/view.c:305: if (col - tb_left == count && cursor == LineEnd(row) && RenderCursorX(count) < TB_WIDTH - 1) return 0;
	ld	hl, sp+7
	ld	a, [hl]
	sub	a, e
	jp	NZ,.l00223
	inc	hl
	ld	a, [hl]
	sub	a, d
	jp	NZ,.l00223
	jp	.l00224
.l00223:
	jp	.l00111
.l00224:
	push	bc
	ld	hl, sp+2
	ld	a, [hl]
	call	_LineEnd
	ld	e, c
	ld	d, b
	pop	bc
	ld	hl, _cursor
	ld	a, [hl]
	sub	a, e
	jp	NZ,.l00225
	inc	hl
	ld	a, [hl]
	sub	a, d
	jp	NZ,.l00225
	jp	.l00226
.l00225:
	jp	.l00111
.l00226:
	push	bc
	ld	hl, sp+8
	ld	a, [hl]
	call	_RenderCursorX
	pop	bc
	sub	a, $9F
	jp	NC, .l00111
	xor	a, a
	jp	.l00130
.l00111:
;src/editor/view.c:307: LineHeading(start, row);
	push	bc
	ld	hl, sp+2
	ld	a, [hl]
	inc	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_src_editor_view_c_LineHeading
	pop	bc
;src/editor/view.c:308: if (keep == KEEP_LEFT) { // more if the line ends sooner, so the screen isn't left empty
	ld	hl, sp+5
	ld	a, [hl]
	sub	a, $28
	jp	NZ,.l00227
	jp	.l00228
.l00227:
	jp	.l00116
.l00228:
;src/editor/view.c:309: for (pos = cursor, x = 0; pos < length && (c = tb_GetChar(pos)) != ASCII_LF && x <= TB_WIDTH; ++pos) x += CharWidth(c);
	ld	hl, _cursor
	ld	a, [hl]
	ld	hl, sp+7
	ld	[hl], a
	ld	hl, _cursor + 1
	ld	a, [hl]
	ld	hl, sp+8
	ld	[hl], a
	ld	de, $0000
.l00125:
	push	de
	ld	hl, sp+9
	ld	e, l
	ld	d, h
	ld	hl, sp+5
	ld	a, [de]
	inc	de
	sub	a, [hl]
	inc	hl
	ld	a, [de]
	sbc	a, [hl]
	pop	de
	jp	NC, .l00112
	push	bc
	push	de
	ld	hl, sp+11
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_tb_GetChar
	pop	de
	pop	bc
	ld	l, a
;	spillPairReg hl
;	spillPairReg hl
	sub	a, $0A
	jp	NZ,.l00229
	jp	.l00112
.l00229:
	ld	a, $A0
	cp	a, e
	ld	a, $00
	sbc	a, d
	jp	C, .l00112
	push	bc
	push	de
	ld	a, l
	call	_src_editor_view_c_CharWidth
	pop	de
	pop	bc
	ld	h, $00
;	spillPairReg hl
;	spillPairReg hl
	ld	l, a
;	spillPairReg hl
;	spillPairReg hl
	add	hl, de
	ld	e, l
	ld	d, h
	ld	hl, sp+7
	inc	[hl]
	jp	NZ, .l00230
	inc	hl
	inc	[hl]
.l00230:
	jp	.l00125
.l00112:
;src/editor/view.c:310: if (x < TB_WIDTH - 1 - KEEP_LEFT) keep = TB_WIDTH - 1 - x;
	ld	a, e
	sub	a, $77
	ld	a, d
	sbc	a, $00
	jp	NC, .l00116
	ld	a, $9F
	sub	a, e
	ld	hl, sp+5
	ld	[hl], a
.l00116:
;src/editor/view.c:312: for (left = col, x = 0; left; --left) {
	xor	a, a
	ld	hl, sp+3
	ld	[hl], a
	inc	hl
	ld	[hl], a
.l00128:
	ld	a, b
	or	a, c
	jp	Z, .l00119
;src/editor/view.c:313: if ((x += CharWidth(tb_GetChar(start + left - 1))) > keep) break;
	ld	hl, sp+1
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	add	hl, bc
	ld	e, l
	ld	d, h
	dec	de
	push	bc
	call	_tb_GetChar
	ld	e, a
	pop	bc
	push	bc
	ld	a, e
	call	_src_editor_view_c_CharWidth
	pop	bc
	ld	d, $00
	ld	e, a
	ld	hl, sp+3
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	add	hl, de
	ld	e, l
	ld	d, h
	ld	hl, sp+3
	ld	[hl], e
	inc	hl
	ld	[hl], d
	inc	hl
	ld	a, [hl]
	inc	hl
	inc	hl
	ld	[hl], a
	inc	hl
	ld	[hl], $00
	dec	hl
	ld	a, [hl]
	sub	a, e
	inc	hl
	ld	a, [hl]
	sbc	a, d
	jp	C, .l00119
;src/editor/view.c:312: for (left = col, x = 0; left; --left) {
	dec	bc
	jp	.l00128
.l00119:
;src/editor/view.c:315: if (left == tb_left) return 0;
	ld	hl, _tb_left
	ld	a, [hl]
	sub	a, c
	jp	NZ,.l00231
	inc	hl
	ld	a, [hl]
	sub	a, b
	jp	NZ,.l00231
	jp	.l00232
.l00231:
	jp	.l00121
.l00232:
	xor	a, a
	jp	.l00130
.l00121:
;src/editor/view.c:316: tb_left = left;
	ld	hl, _tb_left
	ld	[hl], c
	inc	hl
	ld	[hl], b
;src/editor/view.c:317: return 1;
	ld	a, $01
.l00130:
;src/editor/view.c:318: }
	add	sp, 9
	ret
;src/editor/view.c:321: void Refresh(void) {
;	---------------------------------
	SECTION FRAGMENT "Page 5",ROMX,BANK[2]
	LOAD FRAGMENT "Page 5 RAM",SRAM,BANK[5]
; Function Refresh
; ---------------------------------
_Refresh::
	add	sp, -3
;src/editor/view.c:324: if (top > tb_Length()) top = tb_Length();
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
;src/editor/view.c:325: top = tb_RowStart(top); // wrapping may have changed
	ld	hl, _top
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_tb_RowStart
	ld	hl, _top
	ld	[hl], c
	inc	hl
	ld	[hl], b
;src/editor/view.c:326: Render();
	call	_Render__far
;src/editor/view.c:327: if (tb_found_row == 0xFF) {
	ld	hl, _tb_found_row
	ld	a, [hl]
	inc	a
	jp	NZ,.l00209
	jp	.l00210
.l00209:
	jp	.l00119
.l00210:
;src/editor/view.c:328: row = tb_RowStart(cursor);
	ld	hl, _cursor
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_tb_RowStart
;src/editor/view.c:329: if (cursor < top) {
	ld	de, _cursor
	ld	hl, _top
	ld	a, [de]
	inc	de
	sub	a, [hl]
	inc	hl
	ld	a, [de]
	sbc	a, [hl]
	jp	NC, .l00116
;src/editor/view.c:330: if (top && row == tb_RowStart(top - 1)) ScrollRing(0); // one row up
	ld	hl, _top + 1
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	jp	Z, .l00104
	inc	hl
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	dec	de
	push	bc
	call	_tb_RowStart
	ld	e, c
	ld	d, b
	pop	bc
	ld	a, e
	sub	a, c
	jp	NZ,.l00211
	ld	a, d
	sub	a, b
	jp	NZ,.l00211
	jp	.l00212
.l00211:
	jp	.l00104
.l00212:
	push	bc
	xor	a, a
	call	_ScrollRing
	pop	bc
.l00104:
;src/editor/view.c:331: top = row;
	ld	hl, _top
	ld	[hl], c
	inc	hl
	ld	[hl], b
	jp	.l00117
.l00116:
;src/editor/view.c:334: bottom = tb_row_starts[tb_rows];
	ld	de, _tb_row_starts+0
	ld	hl, _tb_rows
	ld	l, [hl]
;	spillPairReg hl
;	spillPairReg hl
	ld	h, $00
;	spillPairReg hl
;	spillPairReg hl
	add	hl, hl
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
;src/editor/view.c:335: for (i = tb_rows; i; --i) {
	ld	hl, _tb_rows
	ld	a, [hl]
	ld	hl, sp+2
	ld	[hl], a
.l00124:
	ld	hl, sp+2
	ld	a, [hl]
	or	a, a
	jp	Z, .l00108
;src/editor/view.c:336: top = tb_NextRow(top);
	push	bc
	ld	hl, _top
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_tb_NextRow
	ld	e, c
	ld	d, b
	pop	bc
	ld	hl, _top
	ld	[hl], e
	inc	hl
	ld	[hl], d
;src/editor/view.c:337: if (bottom == row) break;
	ld	hl, sp+0
	ld	a, [hl]
	sub	a, c
	jp	NZ,.l00213
	inc	hl
	ld	a, [hl]
	sub	a, b
	jp	NZ,.l00213
	jp	.l00108
.l00213:
;src/editor/view.c:338: bottom = tb_NextRow(bottom);
	push	bc
	pop	hl
	pop	de
	push	de
	push	hl
	call	_tb_NextRow
	ld	e, c
	ld	d, b
	pop	bc
	inc	sp
	inc	sp
	push	de
;src/editor/view.c:335: for (i = tb_rows; i; --i) {
	ld	hl, sp+2
	dec	[hl]
	jp	.l00124
.l00108:
;src/editor/view.c:340: if (!i) { // the cursor's row goes at the bottom
	ld	hl, sp+2
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00113
;src/editor/view.c:341: top = row;
	ld	hl, _top
	ld	[hl], c
	inc	hl
	ld	[hl], b
;src/editor/view.c:342: for (i = tb_rows - 1; i && top; --i) top = tb_RowStart(top - 1);
	ld	hl, _tb_rows
	ld	c, [hl]
	dec	c
.l00128:
	ld	a, c
	or	a, a
	jp	Z, .l00117
	ld	hl, _top + 1
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	jp	Z, .l00117
	inc	hl
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	dec	de
	push	bc
	call	_tb_RowStart
	ld	e, c
	ld	d, b
	pop	bc
	ld	hl, _top
	ld	[hl], e
	inc	hl
	ld	[hl], d
	dec	c
	jp	.l00128
.l00113:
;src/editor/view.c:344: else if (i == tb_rows) ScrollRing(1); // one row down
	ld	hl, _tb_rows
	ld	a, [hl]
	ld	hl, sp+2
	sub	a, [hl]
	jp	NZ,.l00214
	jp	.l00215
.l00214:
	jp	.l00117
.l00215:
	ld	a, $01
	call	_ScrollRing
.l00117:
;src/editor/view.c:346: Render();
	call	_Render__far
.l00119:
;src/editor/view.c:348: if (tb_nowrap && ScrollX()) Render();
	ld	hl, _tb_nowrap
	ld	a, [hl]
	or	a, a
	jp	Z, .l00121
	call	_src_editor_view_c_ScrollX
	or	a, a
	jp	Z, .l00121
	call	_Render__far
.l00121:
;src/editor/view.c:349: Draw();
	call	_Draw
;src/editor/view.c:350: redraw = 0;
	ld	hl, _redraw
	ld	[hl], $00
;src/editor/view.c:351: moved = 0;
	ld	hl, _moved
	ld	[hl], $00
;src/editor/view.c:352: PlaceCursor();
	call	_PlaceCursor
.l00130:
;src/editor/view.c:353: }
	add	sp, 3
	ret
	SECTION FRAGMENT "Page 5",ROMX,BANK[2]
	LOAD FRAGMENT "Page 5 RAM",SRAM,BANK[5]
	SECTION FRAGMENT "_INITIALIZER",ROM0
	SECTION FRAGMENT "_CABS (ABS)",ROM0
