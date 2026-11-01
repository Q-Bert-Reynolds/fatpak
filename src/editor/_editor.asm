;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 4.2.0 #13081 (Linux)
;--------------------------------------------------------
	; MODULE editor
	; Generated using the rgbds tokens.

;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	EXPORT _tb_ScrollRows
	EXPORT _tb_RenderRows
	EXPORT _tb_Render
	EXPORT _tb_NextRow
	EXPORT _tb_RowStart
	EXPORT _tb_LineStart
	EXPORT _tb_CountLines
	EXPORT _tb_NormalizeStep
	EXPORT _tb_ClipLength
	EXPORT _tb_Paste
	EXPORT _tb_Copy
	EXPORT _tb_DeleteRange
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
	EXPORT _RenderSetMapRow
	EXPORT _RenderCursorX
	EXPORT _EditorDraw
	EXPORT _SetFont
	EXPORT _EditorInvertCursor
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
	EXPORT _edit_delta
	EXPORT _edit_pos
	EXPORT _edit_row
	EXPORT _edited
	EXPORT _counted_lines
	EXPORT _counted_pos
	EXPORT _bars_changed
	EXPORT _bars
	EXPORT _bars_on
	EXPORT _map_blocks
	EXPORT _ring_pos
	EXPORT _ring_top
	EXPORT _redraw
	EXPORT _moved
	EXPORT _keep_x
	EXPORT _want_x
	EXPORT _sel_end
	EXPORT _sel_start
	EXPORT _selecting
	EXPORT _anchor
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
_anchor:
	DS 2
_selecting:
	DS 1
_sel_start:
	DS 2
_sel_end:
	DS 2
_want_x:
	DS 1
_keep_x:
	DS 1
_moved:
	DS 1
_redraw:
	DS 1
_ring_top:
	DS 1
_ring_pos:
	DS 1
_map_blocks:
	DS 32
_bars_on:
	DS 1
_bars:
	DS 1
_bars_changed:
	DS 1
_counted_pos:
	DS 2
_counted_lines:
	DS 2
_edited:
	DS 1
_edit_row:
	DS 1
_edit_pos:
	DS 2
_edit_delta:
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
;src/editor/editor.c:106: static unsigned char FindRow(unsigned int pos) {
;	---------------------------------
; Function FindRow
; ---------------------------------
_FindRow:
	dec	sp
	dec	sp
	ld	c, e
	ld	b, d
;src/editor/editor.c:108: for (row = 0; row < tb_rows; ++row) {
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
;src/editor/editor.c:109: if (pos < tb_row_starts[row]) return 0xFF;
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
;src/editor/editor.c:110: if (pos < tb_row_starts[row + 1]) return row;
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
;src/editor/editor.c:108: for (row = 0; row < tb_rows; ++row) {
	ld	hl, sp+1
	inc	[hl]
	ld	a, [hl]
	dec	hl
	ld	[hl], a
	jp	.l00107
.l00105:
;src/editor/editor.c:112: return pos == tb_Length() ? tb_end_row : 0xFF;
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
;src/editor/editor.c:113: }
	inc	sp
	inc	sp
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
	DB "FULL SCREEN"
	DB $00
	DB $00
	DB "HELP"
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
_help_lines:
	DB "HELP"
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
	DB "Esc  menu      F1  help"
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
	DB "F11  full screen"
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
	DB "Ctrl+O, S, N  open, save, new"
	DB $00
	DB $00
	DB $00
	DB $00
	DB $00
	DB $00
	DB $00
	DB "Ctrl+F  switch font"
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
	DB "Shift + moving  select"
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
	DB "Ctrl+A  select all"
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
	DB "Ctrl+X, C, V  cut, copy, paste"
	DB $00
	DB $00
	DB $00
	DB $00
	DB $00
	DB $00
	DB "Ctrl+Left, Right  move by word"
	DB $00
	DB $00
	DB $00
	DB $00
	DB $00
	DB $00
	DB "Ctrl+Up, Down  scroll"
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
	DB "Ctrl+Home, End  start or end"
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
	DB "Select  on screen keyboard"
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
	DB "A  type the selected key"
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
	DB "B  backspace    Start  new line"
	DB $00
	DB $00
	DB $00
	DB $00
	DB $00
	DB "D-pad  move"
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
	DB "Press any key to close"
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
;src/editor/editor.c:118: static unsigned char PlaceCursor(void) {
;	---------------------------------
; Function PlaceCursor
; ---------------------------------
_PlaceCursor:
	add	sp, -4
;src/editor/editor.c:119: unsigned char row = FindRow(cursor);
	ld	hl, _cursor
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_FindRow
	ld	c, a
;src/editor/editor.c:121: if (row == 0xFF) return 0;
	ld	a, c
	inc	a
	jp	NZ,.l00132
	jp	.l00133
.l00132:
	jp	.l00102
.l00133:
	xor	a, a
	jp	.l00107
.l00102:
;src/editor/editor.c:122: col = cursor - tb_row_starts[row];
	ld	de, _tb_row_starts+0
	ld	l, c
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
	ld	hl, sp+3
	ld	[hl], a
	dec	hl
	ld	[hl], e
	pop	hl
	pop	de
	push	de
	push	hl
;src/editor/editor.c:123: if (col > tb_row_counts[row]) col = tb_row_counts[row]; // hanging spaces
	ld	hl, _tb_row_counts
	ld	b, $00
	add	hl, bc
	ld	b, [hl]
	ld	l, $00
;	spillPairReg hl
;	spillPairReg hl
	ld	a, b
	sub	a, e
	ld	a, l
	sbc	a, d
	jp	NC, .l00104
	ld	d, l
	ld	e, b
.l00104:
;src/editor/editor.c:124: tb_found_row = row;
	ld	hl, _tb_found_row
	ld	[hl], c
;src/editor/editor.c:125: tb_found_col = (unsigned char)col;
	ld	hl, _tb_found_col
	ld	[hl], e
;src/editor/editor.c:126: if (!keep_x) want_x = RenderCursorX(tb_found_col);
	ld	hl, _keep_x
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00106
	ld	hl, _tb_found_col
	ld	a, [hl]
	call	_RenderCursorX
	ld	hl, _want_x
	ld	[hl], a
.l00106:
;src/editor/editor.c:127: keep_x = 0;
	ld	hl, _keep_x
	ld	[hl], $00
;src/editor/editor.c:128: blink_timer = 0;
	ld	hl, _blink_timer
	ld	[hl], $00
;src/editor/editor.c:129: EditorInvertCursor(GetSelection() && cursor == sel_start); // the selection starts at the cursor's x
	call	_GetSelection
	or	a, a
	jp	Z, .l00109
	ld	hl, _cursor
	ld	a, [hl]
	ld	hl, _sel_start
	sub	a, [hl]
	jp	NZ,.l00134
	ld	hl, _cursor + 1
	ld	a, [hl]
	ld	hl, _sel_start + 1
	sub	a, [hl]
	jp	NZ,.l00134
	jp	.l00110
.l00134:
.l00109:
	ld	c, $00
	jp	.l00111
.l00110:
	ld	c, $01
.l00111:
	ld	a, c
	call	_EditorInvertCursor
;src/editor/editor.c:130: EditorShowCursor(1);
	ld	a, $01
	call	_EditorShowCursor
;src/editor/editor.c:131: bars_changed = 1;
	ld	hl, _bars_changed
	ld	[hl], $01
;src/editor/editor.c:132: return 1;
	ld	a, $01
.l00107:
;src/editor/editor.c:133: }
	add	sp, 4
	ret
;src/editor/editor.c:136: static unsigned int PosAtX(unsigned char row, unsigned char x) {
;	---------------------------------
; Function PosAtX
; ---------------------------------
_PosAtX:
	add	sp, -10
	ld	hl, sp+6
	ld	[hl], a
	dec	hl
	ld	[hl], e
;src/editor/editor.c:137: char* chars = RowAddress(row);
	inc	hl
	ld	a, [hl]
	call	_RowAddress
	ld	hl, sp+8
	ld	[hl], c
	inc	hl
	ld	[hl], b
	ld	hl, sp+8
	ld	a, [hl]
	ld	hl, sp+1
	ld	[hl], a
	ld	hl, sp+9
	ld	a, [hl]
	ld	hl, sp+2
	ld	[hl], a
;src/editor/editor.c:138: unsigned char count = tb_row_counts[row], col = 0, width;
	ld	de, _tb_row_counts
	ld	hl, sp+6
	ld	l, [hl]
	ld	h, $00
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, [bc]
	ld	hl, sp+4
	ld	[hl], a
;src/editor/editor.c:140: while (col < count) {
	ld	hl, sp+7
	ld	[hl], $00
.l00103:
	ld	hl, sp+7
	ld	a, [hl]
	ld	hl, sp+4
	sub	a, [hl]
	jp	NC, .l00105
;src/editor/editor.c:141: width = font_widths[(unsigned char)chars[col]];
	dec	hl
	dec	hl
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, sp+7
	ld	l, [hl]
	ld	h, $00
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, [bc]
	ld	c, a
	ld	hl, _font_widths
	ld	b, $00
	add	hl, bc
	ld	a, [hl]
	ld	hl, sp+3
	ld	[hl], a
;src/editor/editor.c:142: if (x < ((width + 1) >> 1)) break;
	ld	hl, sp+3
	ld	c, [hl]
	ld	b, $00
	inc	bc
	sra	b
	rr	c
	inc	hl
	inc	hl
	ld	a, [hl]
	ld	hl, sp+8
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
	jp	Z, .l00150
	bit	7, d
	jp	NZ, .l00151
	cp	a, a
	jp	.l00151
.l00150:
	bit	7, d
	jp	Z, .l00151
	scf
.l00151:
	jp	C, .l00105
;src/editor/editor.c:143: x = x < width ? 0 : x - width;
	ld	hl, sp+5
	ld	a, [hl]
	dec	hl
	dec	hl
	sub	a, [hl]
	jp	NC, .l00112
	xor	a, a
	ld	hl, sp+8
	ld	[hl], a
	inc	hl
	ld	[hl], a
	jp	.l00113
.l00112:
	ld	hl, sp+5
	ld	a, [hl]
	dec	hl
	dec	hl
	sub	a, [hl]
	ld	hl, sp+8
	ld	[hl], a
	inc	hl
	ld	[hl], $00
.l00113:
	ld	hl, sp+8
	ld	a, [hl]
	ld	hl, sp+5
	ld	[hl], a
;src/editor/editor.c:144: ++col;
	inc	hl
	inc	hl
	inc	[hl]
	jp	.l00103
.l00105:
;src/editor/editor.c:146: pos = tb_row_starts[row] + col;
	ld	hl, sp+6
	ld	a, [hl]
	ld	d, $00
	add	a, a
	rl	d
	ld	e, a
	ld	hl, _tb_row_starts
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
	ld	hl, sp+0
	ld	[hl], a
	inc	de
	ld	a, [de]
	inc	hl
	ld	[hl], a
	ld	hl, sp+7
	ld	a, [hl]
	inc	hl
	ld	[hl], a
	inc	hl
	ld	[hl], $00
	dec	hl
	ld	a, [hl]
	ld	hl, sp+2
	ld	[hl], a
	ld	hl, sp+9
	ld	a, [hl]
	ld	hl, sp+3
	ld	[hl], a
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	pop	hl
	push	hl
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+10
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+9
	ld	[hl], a
;src/editor/editor.c:147: if (col == count && pos == tb_row_starts[row + 1] && tb_end_row != row) --pos; // stay on wrapped row
	ld	hl, sp+4
	ld	a, [hl]
	ld	hl, sp+7
	sub	a, [hl]
	jp	NZ,.l00153
	jp	.l00154
.l00153:
	jp	.l00107
.l00154:
	ld	hl, sp+6
	ld	a, [hl]
	inc	a
	ld	l, a
;	spillPairReg hl
;	spillPairReg hl
	rlca
	sbc	a, a
	ld	h, a
;	spillPairReg hl
;	spillPairReg hl
	add	hl, hl
	ld	c, l
	ld	b, h
	ld	hl, _tb_row_starts
	add	hl, bc
	push	hl
	ld	a, l
	ld	hl, sp+5
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+4
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
	ld	hl, sp+8
	ld	a, [hl]
	sub	a, c
	jp	NZ,.l00155
	inc	hl
	ld	a, [hl]
	sub	a, b
	jp	NZ,.l00155
	jp	.l00156
.l00155:
	jp	.l00107
.l00156:
	ld	hl, _tb_end_row
	ld	a, [hl]
	ld	hl, sp+6
	sub	a, [hl]
	jp	NZ,.l00157
	jp	.l00107
.l00157:
	ld	hl, sp+9
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	dec	de
	dec	hl
	ld	[hl], e
	inc	hl
	ld	[hl], d
.l00107:
;src/editor/editor.c:148: return pos;
	ld	hl, sp+8
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
.l00110:
;src/editor/editor.c:149: }
	add	sp, 10
	ret
;src/editor/editor.c:153: static void StageSplits(void) {
;	---------------------------------
; Function StageSplits
; ---------------------------------
_StageSplits:
	add	sp, -6
;src/editor/editor.c:154: unsigned char row, block, mode, current = 0xFF, shared = 0xFF, count = 0;
	ld	hl, sp+1
	ld	[hl], $FF
	inc	hl
	ld	[hl], $FF
	inc	hl
	ld	[hl], $00
;src/editor/editor.c:155: for (row = 0; row < TB_ROWS; ++row) {
	inc	hl
	inc	hl
	ld	[hl], $00
.l00114:
;src/editor/editor.c:156: block = render_row_blocks[row];
	ld	de, _render_row_blocks
	ld	hl, sp+5
	ld	l, [hl]
	ld	h, $00
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, [bc]
	ld	c, a
;src/editor/editor.c:157: if ((block >= 6 && block < 9) || block >= 15) {
	ld	a, c
	sub	a, $06
	ld	a, $00
	rla
	ld	b, a
	bit	0, b
	jp	NZ, .l00106
	ld	a, c
	sub	a, $09
	jp	C, .l00103
.l00106:
	ld	a, c
	sub	a, $0F
	jp	C, .l00104
.l00103:
;src/editor/editor.c:158: if (shared == 0xFF) shared = row;
	ld	hl, sp+2
	ld	a, [hl]
	inc	a
	jp	NZ,.l00155
	jp	.l00156
.l00155:
	jp	.l00112
.l00156:
	ld	hl, sp+5
	ld	a, [hl]
	ld	hl, sp+2
	ld	[hl], a
;src/editor/editor.c:159: continue;
	jp	.l00112
.l00104:
;src/editor/editor.c:161: mode = block < 6 ? LCDC_TILES_8000 : 0;
	ld	a, b
	or	a, a
	jp	Z, .l00117
	ld	bc, $0010
	jp	.l00118
.l00117:
	ld	bc, $0000
.l00118:
	ld	hl, sp+4
	ld	[hl], c
;src/editor/editor.c:162: if (current == 0xFF) render_pending_top_mode = mode;
	ld	hl, sp+1
	ld	a, [hl]
	inc	a
	jp	NZ,.l00157
	jp	.l00158
.l00157:
	jp	.l00110
.l00158:
	ld	hl, sp+4
	ld	a, [hl]
	ld	hl, _render_pending_top_mode
	ld	[hl], a
	jp	.l00111
.l00110:
;src/editor/editor.c:163: else if (mode != current) {
	ld	hl, sp+1
	ld	a, [hl]
	ld	hl, sp+4
	sub	a, [hl]
	jp	NZ,.l00159
	jp	.l00111
.l00159:
;src/editor/editor.c:164: render_pending_splits[count++] = ((shared + row - 1) >> 1) << 3;
	ld	hl, sp+3
	ld	e, [hl]
	ld	c, [hl]
	inc	c
	ld	d, $00
	ld	hl, _render_pending_splits
	add	hl, de
	inc	sp
	inc	sp
	push	hl
	ld	hl, sp+2
	ld	a, [hl]
	ld	b, $00
	ld	hl, sp+5
	ld	e, [hl]
	ld	d, $00
	ld	l, a
	ld	h, b
	add	hl, de
	dec	hl
	sra	h
	rr	l
	ld	a, l
	add	a, a
	add	a, a
	add	a, a
	ld	b, a
	pop	hl
	push	hl
	ld	[hl], b
;src/editor/editor.c:165: render_pending_splits[count++] = mode;
	ld	b, c
	ld	a, c
	inc	a
	ld	hl, sp+3
	ld	[hl], a
	ld	a, LOW(_render_pending_splits)
	add	a, b
	ld	c, a
	ld	a, HIGH(_render_pending_splits)
	adc	a, $00
	ld	b, a
	inc	hl
	ld	a, [hl]
	ld	[bc], a
.l00111:
;src/editor/editor.c:167: current = mode;
	ld	hl, sp+4
	ld	a, [hl]
	ld	hl, sp+1
	ld	[hl], a
;src/editor/editor.c:168: shared = 0xFF;
	inc	hl
	ld	[hl], $FF
.l00112:
;src/editor/editor.c:155: for (row = 0; row < TB_ROWS; ++row) {
	ld	hl, sp+5
	inc	[hl]
	ld	a, [hl]
	sub	a, $12
	jp	C, .l00114
;src/editor/editor.c:170: render_pending_split_count = count >> 1;
	dec	hl
	dec	hl
	ld	a, [hl]
	srl	a
	ld	hl, _render_pending_split_count
	ld	[hl], a
.l00115:
;src/editor/editor.c:171: }
	add	sp, 6
	ret
;src/editor/editor.c:174: static unsigned char RingLength(void) {
;	---------------------------------
; Function RingLength
; ---------------------------------
_RingLength:
;src/editor/editor.c:175: return bars ? TB_ROWS - 2 : TB_ROWS;
	ld	hl, _bars
	ld	a, [hl]
	or	a, a
	jp	Z, .l00103
	ld	bc, $0010
	jp	.l00104
.l00103:
	ld	bc, $0012
.l00104:
	ld	a, c
.l00101:
;src/editor/editor.c:176: }
	ret
;src/editor/editor.c:179: static unsigned char TextRows(void) {
;	---------------------------------
; Function TextRows
; ---------------------------------
_TextRows:
;src/editor/editor.c:180: return RingLength() - (osk_shown ? OSK_ROWS : 0);
	call	_RingLength
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
;src/editor/editor.c:181: }
	ret
;src/editor/editor.c:186: static void Layout(void) {
;	---------------------------------
; Function Layout
; ---------------------------------
_Layout:
	add	sp, -6
;src/editor/editor.c:187: unsigned char row, line, block, map_row, i = ring_pos, length = RingLength();
	ld	hl, _ring_pos
	ld	a, [hl]
	ld	hl, sp+4
	ld	[hl], a
	call	_RingLength
	ld	hl, sp+0
	ld	[hl], a
;src/editor/editor.c:188: render_pending = 0;
	ld	hl, _render_pending
	ld	[hl], $00
;src/editor/editor.c:189: render_text_top = bars;
	ld	hl, _bars
	ld	a, [hl]
	ld	hl, _render_text_top
	ld	[hl], a
;src/editor/editor.c:190: for (row = 0; row < TB_ROWS; ++row) {
	ld	hl, sp+5
	ld	[hl], $00
.l00111:
;src/editor/editor.c:191: if (bars && (!row || row == TB_ROWS - 1)) {
	ld	hl, _bars
	ld	a, [hl]
	or	a, a
	jp	Z, .l00104
	ld	hl, sp+5
	ld	a, [hl]
	or	a, a
	jp	Z, .l00103
	ld	a, [hl]
	sub	a, $11
	jp	NZ,.l00181
	jp	.l00182
.l00181:
	jp	.l00104
.l00182:
.l00103:
;src/editor/editor.c:192: block = row ? STATUS_BLOCK : HEADER_BLOCK;
	ld	hl, sp+5
	ld	a, [hl]
	or	a, a
	jp	Z, .l00115
	ld	bc, $0011
	jp	.l00116
.l00115:
	ld	bc, $0008
.l00116:
	ld	hl, sp+1
	ld	[hl], c
;src/editor/editor.c:193: line = row ? STATUS_LINE : HEADER_LINE;
	ld	hl, sp+5
	ld	a, [hl]
	or	a, a
	jp	Z, .l00117
	ld	hl, sp+2
	ld	[hl], $13
	xor	a, a
	inc	hl
	ld	[hl], a
	jp	.l00118
.l00117:
	ld	hl, sp+2
	ld	[hl], $12
	xor	a, a
	inc	hl
	ld	[hl], a
.l00118:
	ld	hl, sp+2
	ld	c, [hl]
;src/editor/editor.c:194: render_row_fonts[row] = FONT_VWF;
	ld	de, _render_row_fonts
	ld	hl, sp+5
	ld	l, [hl]
	ld	h, $00
	add	hl, de
	ld	e, l
	ld	d, h
	ld	a, $01
	ld	[de], a
	jp	.l00105
.l00104:
;src/editor/editor.c:197: block = bars && i >= HEADER_BLOCK ? i + 1 : i;
	ld	hl, _bars
	ld	a, [hl]
	or	a, a
	jp	Z, .l00119
	ld	hl, sp+4
	ld	a, [hl]
	sub	a, $08
	jp	C, .l00119
	ld	a, [hl]
	inc	a
	jp	.l00120
.l00119:
	ld	hl, sp+4
	ld	a, [hl]
.l00120:
	ld	hl, sp+1
	ld	[hl], a
;src/editor/editor.c:198: if (++i == length) i = 0;
	ld	hl, sp+4
	inc	[hl]
	ld	a, [hl]
	ld	hl, sp+0
	sub	a, [hl]
	jp	NZ,.l00183
	jp	.l00184
.l00183:
	jp	.l00102
.l00184:
	ld	hl, sp+4
	ld	[hl], $00
.l00102:
;src/editor/editor.c:199: line = row - bars;
	ld	hl, sp+5
	ld	a, [hl]
	ld	hl, _bars
	sub	a, [hl]
	ld	c, a
;src/editor/editor.c:200: render_row_fonts[row] = line < tb_rows ? font : FONT_MONO; // on screen keyboard
	ld	de, _render_row_fonts
	ld	hl, sp+5
	ld	l, [hl]
	ld	h, $00
	add	hl, de
	ld	e, l
	ld	d, h
	ld	a, c
	ld	hl, _tb_rows
	sub	a, [hl]
	jp	NC, .l00124
	ld	hl, _font
	ld	a, [hl]
	ld	b, $00
	jp	.l00125
.l00124:
	xor	a, a
	ld	b, a
.l00125:
	ld	[de], a
.l00105:
;src/editor/editor.c:202: render_row_blocks[row] = block;
	ld	de, _render_row_blocks
	ld	hl, sp+5
	ld	l, [hl]
	ld	h, $00
	add	hl, de
	ld	e, l
	ld	d, h
	ld	hl, sp+1
	ld	a, [hl]
	ld	[de], a
;src/editor/editor.c:203: render_row_lines[row] = line;
	ld	de, _render_row_lines
	ld	hl, sp+5
	ld	l, [hl]
	ld	h, $00
	add	hl, de
	ld	e, l
	ld	d, h
	ld	a, c
	ld	[de], a
;src/editor/editor.c:204: map_row = (ring_top + row) & (BG_MAP_ROWS - 1);
	ld	hl, _ring_top
	ld	a, [hl]
	ld	hl, sp+5
	add	a, [hl]
	and	a, $1F
	ld	d, a
;src/editor/editor.c:205: if (map_blocks[map_row] != block) {
	ld	a, LOW(_map_blocks)
	add	a, d
	ld	c, a
	ld	a, HIGH(_map_blocks)
	adc	a, $00
	ld	b, a
	ld	a, [bc]
	ld	e, a
	ld	hl, sp+1
	ld	a, [hl]
	sub	a, e
	jp	NZ,.l00185
	jp	.l00112
.l00185:
;src/editor/editor.c:206: map_blocks[map_row] = block;
	ld	hl, sp+1
	ld	a, [hl]
	ld	[bc], a
;src/editor/editor.c:207: RenderSetMapRow(map_row, block);
	ld	e, [hl]
	ld	a, d
	call	_RenderSetMapRow
.l00112:
;src/editor/editor.c:190: for (row = 0; row < TB_ROWS; ++row) {
	ld	hl, sp+5
	inc	[hl]
	ld	a, [hl]
	sub	a, $12
	jp	C, .l00111
;src/editor/editor.c:210: StageSplits();
	call	_StageSplits
;src/editor/editor.c:211: render_pending_scy = ring_top << 3;
	ld	hl, _ring_top
	ld	a, [hl]
	add	a, a
	add	a, a
	add	a, a
	ld	hl, _render_pending_scy
	ld	[hl], a
;src/editor/editor.c:212: render_pending = 1;
	ld	hl, _render_pending
	ld	[hl], $01
.l00113:
;src/editor/editor.c:213: }
	add	sp, 6
	ret
;src/editor/editor.c:216: static void ScrollRing(unsigned char down) {
;	---------------------------------
; Function ScrollRing
; ---------------------------------
_ScrollRing:
	add	sp, -7
	ld	hl, sp+6
	ld	[hl], a
;src/editor/editor.c:217: unsigned char length = RingLength();
	call	_RingLength
	ld	hl, sp+5
	ld	[hl], a
;src/editor/editor.c:219: ring_pos = ring_pos == length - 1 ? 0 : ring_pos + 1;
	ld	hl, _ring_pos
	ld	a, [hl]
	ld	hl, sp+0
	ld	[hl], a
;src/editor/editor.c:220: ring_top = (ring_top + 1) & (BG_MAP_ROWS - 1);
	ld	hl, _ring_top
	ld	a, [hl]
	ld	hl, sp+1
	ld	[hl], a
;src/editor/editor.c:218: if (down) {
	ld	hl, sp+6
	ld	a, [hl]
	or	a, a
	jp	Z, .l00102
;src/editor/editor.c:219: ring_pos = ring_pos == length - 1 ? 0 : ring_pos + 1;
	dec	hl
	ld	a, [hl]
	dec	hl
	ld	[hl], a
	inc	hl
	ld	[hl], $00
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $0001
	ld	a, e
	sub	a, l
	ld	e, a
	ld	a, d
	sbc	a, h
	ld	hl, sp+3
	ld	[hl], a
	dec	hl
	ld	[hl], e
	ld	hl, _ring_pos
	ld	a, [hl]
	ld	hl, sp+4
	ld	[hl], a
	inc	hl
	ld	[hl], $00
	ld	hl, sp+2
	ld	a, [hl]
	inc	hl
	inc	hl
	sub	a, [hl]
	jp	NZ,.l00125
	dec	hl
	ld	a, [hl]
	inc	hl
	inc	hl
	sub	a, [hl]
	jp	NZ,.l00125
	jp	.l00126
.l00125:
	jp	.l00106
.l00126:
	ld	c, $00
	xor	a, a
	jp	.l00107
.l00106:
	ld	hl, sp+0
	ld	a, [hl]
	inc	a
	ld	c, a
	rlca
	sbc	a, a
.l00107:
	ld	hl, _ring_pos
	ld	[hl], c
;src/editor/editor.c:220: ring_top = (ring_top + 1) & (BG_MAP_ROWS - 1);
	ld	hl, sp+1
	ld	a, [hl]
	inc	a
	and	a, $1F
	ld	hl, _ring_top
	ld	[hl], a
	jp	.l00103
.l00102:
;src/editor/editor.c:223: ring_pos = ring_pos ? ring_pos - 1 : length - 1;
	ld	hl, _ring_pos
	ld	a, [hl]
	or	a, a
	jp	Z, .l00108
	ld	hl, sp+0
	ld	a, [hl]
	dec	a
	jp	.l00109
.l00108:
	ld	hl, sp+5
	ld	a, [hl]
	dec	a
.l00109:
	ld	hl, _ring_pos
	ld	[hl], a
;src/editor/editor.c:224: ring_top = (ring_top - 1) & (BG_MAP_ROWS - 1);
	ld	hl, sp+1
	ld	a, [hl]
	dec	a
	and	a, $1F
	ld	hl, _ring_top
	ld	[hl], a
.l00103:
;src/editor/editor.c:226: Layout();
	call	_Layout
.l00104:
;src/editor/editor.c:227: }
	add	sp, 7
	ret
;src/editor/editor.c:230: static void ScrollDown(void) {
;	---------------------------------
; Function ScrollDown
; ---------------------------------
_ScrollDown:
;src/editor/editor.c:231: ScrollRing(1);
	ld	a, $01
	call	_ScrollRing
;src/editor/editor.c:232: tb_ScrollRows(1);
	ld	a, $01
	call	_tb_ScrollRows
;src/editor/editor.c:233: tb_RenderRows(tb_rows - 1, tb_rows);
	ld	hl, _tb_rows
	ld	c, [hl]
	dec	c
	ld	e, [hl]
	ld	a, c
	call	_tb_RenderRows
;src/editor/editor.c:234: top = tb_row_starts[0];
	ld	de, _tb_row_starts + 0
	ld	a, [de]
	ld	hl, _top
	ld	[hl], a
	inc	de
	ld	a, [de]
	inc	hl
	ld	[hl], a
;src/editor/editor.c:235: redraw = 1;
	ld	hl, _redraw
	ld	[hl], $01
.l00101:
;src/editor/editor.c:236: }
	ret
;src/editor/editor.c:239: static void ScrollUp(unsigned int new_top) {
;	---------------------------------
; Function ScrollUp
; ---------------------------------
_ScrollUp:
	ld	c, e
	ld	b, d
;src/editor/editor.c:240: ScrollRing(0);
	push	bc
	xor	a, a
	call	_ScrollRing
	pop	bc
;src/editor/editor.c:241: tb_ScrollRows(0);
	push	bc
	xor	a, a
	call	_tb_ScrollRows
	pop	bc
;src/editor/editor.c:242: tb_row_starts[0] = new_top;
	ld	hl, _tb_row_starts
	ld	[hl], c
	inc	hl
	ld	[hl], b
;src/editor/editor.c:243: tb_RenderRows(0, 1);
	push	bc
	ld	e, $01
	xor	a, a
	call	_tb_RenderRows
	pop	bc
;src/editor/editor.c:244: top = new_top;
	ld	hl, _top
	ld	[hl], c
	inc	hl
	ld	[hl], b
;src/editor/editor.c:245: redraw = 1;
	ld	hl, _redraw
	ld	[hl], $01
.l00101:
;src/editor/editor.c:246: }
	ret
;src/editor/editor.c:250: static void RenderAfterEdit(void) {
;	---------------------------------
; Function RenderAfterEdit
; ---------------------------------
_RenderAfterEdit:
	add	sp, -12
;src/editor/editor.c:251: unsigned char row = edit_row, end_row = tb_end_row, i;
	ld	hl, _edit_row
	ld	a, [hl]
	ld	hl, sp+10
	ld	[hl], a
	ld	hl, _tb_end_row
	ld	a, [hl]
	ld	hl, sp+0
	ld	[hl], a
;src/editor/editor.c:252: unsigned int old_next, expected, delta = (unsigned int)(int)edit_delta;
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
;src/editor/editor.c:253: if (row) --row; // the previous row's wrapping can change too
	ld	hl, sp+10
	ld	a, [hl]
	or	a, a
	jp	Z, .l00102
	dec	[hl]
.l00102:
;src/editor/editor.c:254: if (end_row != 0xFF && end_row >= row) tb_end_row = 0xFF; // found again while scanning
	ld	hl, sp+0
	ld	a, [hl]
	inc	a
	jp	NZ,.l00178
	ld	a,$01
	jp	.l00179
.l00178:
	xor	a,a
.l00179:
	ld	hl, sp+3
	ld	[hl], a
	bit	0, [hl]
	jp	NZ, .l00132
	ld	hl, sp+0
	ld	a, [hl]
	ld	hl, sp+10
	sub	a, [hl]
	jp	C, .l00132
	ld	hl, _tb_end_row
	ld	[hl], $FF
.l00132:
	ld	hl, sp+10
	ld	a, [hl]
	inc	hl
	ld	[hl], a
.l00118:
;src/editor/editor.c:255: for (; row < tb_rows; ++row) {
	ld	hl, sp+11
	ld	a, [hl]
	ld	hl, _tb_rows
	sub	a, [hl]
	jp	NC, .l00113
;src/editor/editor.c:256: old_next = tb_row_starts[row + 1];
	ld	hl, sp+11
	ld	a, [hl]
	ld	hl, sp+4
	ld	[hl], a
	ld	a, [hl]
	inc	a
	inc	hl
	ld	[hl], a
	ld	a, [hl]
	ld	hl, sp+8
	ld	[hl], a
	rlca
	sbc	a, a
	inc	hl
	ld	[hl], a
	dec	hl
	sla	[hl]
	inc	hl
	rl	[hl]
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, _tb_row_starts
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
;src/editor/editor.c:257: expected = old_next + delta;
	ld	hl, sp+1
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	add	hl, bc
	ld	e, l
	ld	a, h
	ld	hl, sp+8
	ld	[hl], e
	inc	hl
	ld	[hl], a
;src/editor/editor.c:258: tb_RenderRows(row, row + 1);
	push	bc
	ld	hl, sp+7
	ld	e, [hl]
	ld	hl, sp+13
	ld	a, [hl]
	call	_tb_RenderRows
	pop	bc
;src/editor/editor.c:259: if (old_next > edit_pos && tb_row_starts[row + 1] == expected) {
	ld	hl, _edit_pos
	ld	a, [hl]
	sub	a, c
	inc	hl
	ld	a, [hl]
	sbc	a, b
	jp	NC, .l00119
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
	inc	hl
	ld	a, [hl]
	sub	a, c
	jp	NZ,.l00181
	inc	hl
	ld	a, [hl]
	sub	a, b
	jp	NZ,.l00181
	jp	.l00182
.l00181:
	jp	.l00119
.l00182:
;src/editor/editor.c:260: for (i = row + 2; i <= tb_rows; ++i) tb_row_starts[i] += delta; // rows below just moved
	ld	hl, sp+4
	ld	a, [hl]
	add	a, $02
	ld	hl, sp+11
	ld	[hl], a
.l00115:
	ld	hl, _tb_rows
	ld	a, [hl]
	ld	hl, sp+11
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
	ld	hl, sp+8
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
	ld	hl, sp+11
	inc	[hl]
	jp	.l00115
.l00106:
;src/editor/editor.c:261: if (end_row != 0xFF && end_row > row) tb_end_row = end_row;
	ld	hl, sp+3
	bit	0, [hl]
	jp	NZ, .l00113
	ld	hl, sp+10
	ld	a, [hl]
	ld	hl, sp+0
	sub	a, [hl]
	jp	NC, .l00113
	ld	a, [hl]
	ld	hl, _tb_end_row
	ld	[hl], a
;src/editor/editor.c:262: break;
	jp	.l00113
.l00119:
;src/editor/editor.c:255: for (; row < tb_rows; ++row) {
	ld	hl, sp+11
	inc	[hl]
	ld	a, [hl]
	dec	hl
	ld	[hl], a
	jp	.l00118
.l00113:
;src/editor/editor.c:265: redraw = 1;
	ld	hl, _redraw
	ld	[hl], $01
.l00120:
;src/editor/editor.c:266: }
	add	sp, 12
	ret
;src/editor/editor.c:269: static void Edited(unsigned int pos, signed char delta) {
;	---------------------------------
; Function Edited
; ---------------------------------
_Edited:
	ld	c, a
;src/editor/editor.c:270: modified = 1;
	ld	hl, _modified
	ld	[hl], $01
;src/editor/editor.c:271: if (edited) dirty = 1;
	ld	hl, _edited
	ld	a, [hl]
	or	a, a
	jp	Z, .l00102
	ld	hl, _dirty
	ld	[hl], $01
.l00102:
;src/editor/editor.c:272: edited = 1;
	ld	hl, _edited
	ld	[hl], $01
;src/editor/editor.c:273: edit_row = tb_found_row;
	ld	hl, _tb_found_row
	ld	a, [hl]
	ld	hl, _edit_row
	ld	[hl], a
;src/editor/editor.c:274: edit_pos = pos;
	ld	hl, _edit_pos
	ld	[hl], e
	inc	hl
	ld	[hl], d
;src/editor/editor.c:275: edit_delta = delta;
	ld	hl, _edit_delta
	ld	[hl], c
.l00103:
;src/editor/editor.c:276: }
	ret
;src/editor/editor.c:279: static unsigned char GetSelection(void) {
;	---------------------------------
; Function GetSelection
; ---------------------------------
_GetSelection:
;src/editor/editor.c:280: if (!selecting || anchor == cursor) return 0;
	ld	hl, _selecting
	ld	a, [hl]
	or	a, a
	jp	Z, .l00101
	ld	hl, _anchor
	ld	a, [hl]
	ld	hl, _cursor
	sub	a, [hl]
	jp	NZ,.l00119
	ld	hl, _anchor + 1
	ld	a, [hl]
	ld	hl, _cursor + 1
	sub	a, [hl]
	jp	NZ,.l00119
	jp	.l00120
.l00119:
	jp	.l00102
.l00120:
.l00101:
	xor	a, a
	jp	.l00107
.l00102:
;src/editor/editor.c:282: sel_start = anchor;
	ld	hl, _anchor
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
;src/editor/editor.c:283: sel_end = cursor;
	ld	hl, _cursor
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
;src/editor/editor.c:281: if (anchor < cursor) {
	push	de
	ld	de, _anchor
	dec	hl
	ld	a, [de]
	inc	de
	sub	a, [hl]
	inc	hl
	ld	a, [de]
	sbc	a, [hl]
	pop	de
	jp	NC, .l00105
;src/editor/editor.c:282: sel_start = anchor;
	ld	hl, _sel_start
	ld	[hl], c
	inc	hl
	ld	[hl], b
;src/editor/editor.c:283: sel_end = cursor;
	ld	hl, _sel_end
	ld	[hl], e
	inc	hl
	ld	[hl], d
	jp	.l00106
.l00105:
;src/editor/editor.c:286: sel_start = cursor;
	ld	hl, _sel_start
	ld	[hl], e
	inc	hl
	ld	[hl], d
;src/editor/editor.c:287: sel_end = anchor;
	ld	hl, _sel_end
	ld	[hl], c
	inc	hl
	ld	[hl], b
.l00106:
;src/editor/editor.c:289: return 1;
	ld	a, $01
.l00107:
;src/editor/editor.c:290: }
	ret
;src/editor/editor.c:292: static void ClearSelection(void) {
;	---------------------------------
; Function ClearSelection
; ---------------------------------
_ClearSelection:
;src/editor/editor.c:293: if (selecting) redraw = 1;
	ld	hl, _selecting
	ld	a, [hl]
	or	a, a
	jp	Z, .l00102
	ld	hl, _redraw
	ld	[hl], $01
.l00102:
;src/editor/editor.c:294: selecting = 0;
	ld	hl, _selecting
	ld	[hl], $00
.l00103:
;src/editor/editor.c:295: }
	ret
;src/editor/editor.c:298: static void NoHighlight(void) {
;	---------------------------------
; Function NoHighlight
; ---------------------------------
_NoHighlight:
;src/editor/editor.c:300: for (i = 0; i < TB_ROWS * 2; ++i) render_sel[i] = 0;
	ld	c, $00
.l00104:
	ld	hl, _render_sel
	ld	b, $00
	add	hl, bc
	ld	[hl], $00
	inc	c
	ld	a, c
	sub	a, $24
	jp	C, .l00104
;src/editor/editor.c:301: if (bars) render_sel[1] = render_sel[(TB_ROWS << 1) - 1] = 0xFF;
	ld	hl, _bars
	ld	a, [hl]
	or	a, a
	jp	Z, .l00106
	ld	hl, (_render_sel + 35)
	ld	[hl], $FF
	ld	hl, (_render_sel + 1)
	ld	[hl], $FF
.l00106:
;src/editor/editor.c:302: }
	ret
;src/editor/editor.c:305: static void SetHighlight(void) {
;	---------------------------------
; Function SetHighlight
; ---------------------------------
_SetHighlight:
	add	sp, -10
;src/editor/editor.c:308: NoHighlight();
	call	_NoHighlight
;src/editor/editor.c:309: if (!GetSelection()) return;
	call	_GetSelection
	ld	hl, sp+9
	ld	[hl], a
	ld	hl, sp+9
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00134
	jp	.l00119
;src/editor/editor.c:310: for (row = 0; row < tb_rows; ++row) {
.l00134:
	ld	hl, sp+9
	ld	[hl], $00
.l00118:
	ld	hl, sp+9
	ld	a, [hl]
	ld	hl, _tb_rows
	sub	a, [hl]
	jp	NC, .l00119
;src/editor/editor.c:311: row_start = tb_row_starts[row];
	ld	hl, sp+9
	ld	a, [hl]
	dec	hl
	dec	hl
	ld	[hl], a
	inc	hl
	ld	[hl], $00
	dec	hl
	ld	a, [hl]
	dec	hl
	dec	hl
	ld	[hl], a
	ld	hl, sp+8
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
	ld	hl, _tb_row_starts
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+9
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+8
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
;src/editor/editor.c:312: next = tb_row_starts[row + 1];
	ld	hl, sp+9
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
	ld	e, l
	ld	d, h
	ld	a, [de]
	ld	hl, sp+2
	ld	[hl], a
	inc	de
	ld	a, [de]
	inc	hl
	ld	[hl], a
;src/editor/editor.c:313: if (sel_end <= row_start) break;
	ld	hl, sp+0
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
;src/editor/editor.c:314: if (sel_start >= next) continue;
	ld	de, _sel_start
	ld	hl, sp+2
	ld	a, [de]
	inc	de
	sub	a, [hl]
	inc	hl
	ld	a, [de]
	sbc	a, [hl]
	jp	NC, .l00115
;src/editor/editor.c:315: count = tb_row_counts[row];
	ld	de, _tb_row_counts
	ld	hl, sp+9
	ld	l, [hl]
	ld	h, $00
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, [bc]
	ld	hl, sp+4
	ld	[hl], a
;src/editor/editor.c:316: first = 0;
	inc	hl
	ld	[hl], $00
;src/editor/editor.c:317: if (sel_start > row_start) first = sel_start - row_start > count ? count : (unsigned char)(sel_start - row_start);
	dec	hl
	ld	a, [hl]
	inc	hl
	inc	hl
	ld	[hl], a
	inc	hl
	ld	[hl], $00
	ld	hl, sp+0
	ld	a, [hl]
	ld	hl, sp+8
	ld	[hl], a
	ld	hl, sp+0
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
	pop	hl
	push	hl
	ld	a, e
	sub	a, l
	ld	e, a
	ld	a, d
	sbc	a, h
	ld	b, a
	ld	c, e
	ld	hl, sp+6
	ld	a, [hl]
	sub	a, c
	inc	hl
	ld	a, [hl]
	sbc	a, b
	jp	NC, .l00121
	ld	hl, sp+4
	ld	d, [hl]
	jp	.l00122
.l00121:
	ld	hl, _sel_start
	ld	a, [hl]
	ld	hl, sp+8
	sub	a, [hl]
	ld	d, a
.l00122:
	ld	hl, sp+5
	ld	[hl], d
.l00108:
;src/editor/editor.c:318: if (sel_end < next || row == tb_end_row) { // ends in this row
	ld	de, _sel_end
	ld	hl, sp+2
	ld	a, [de]
	inc	de
	sub	a, [hl]
	inc	hl
	ld	a, [de]
	sbc	a, [hl]
	jp	C, .l00111
	ld	hl, sp+9
	ld	a, [hl]
	ld	hl, _tb_end_row
	sub	a, [hl]
	jp	NZ,.l00177
	jp	.l00178
.l00177:
	jp	.l00112
.l00178:
.l00111:
;src/editor/editor.c:319: end = sel_end - row_start > count ? count : (unsigned char)(sel_end - row_start);
	ld	hl, _sel_end + 1
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
	ld	hl, sp+6
	ld	a, [hl]
	sub	a, c
	inc	hl
	ld	a, [hl]
	sbc	a, b
	jp	NC, .l00123
	ld	hl, sp+4
	ld	e, [hl]
	jp	.l00124
.l00123:
	ld	hl, _sel_end
	ld	a, [hl]
	ld	hl, sp+7
	ld	[hl], a
	ld	a, [hl]
	inc	hl
	sub	a, [hl]
	ld	e, a
.l00124:
;src/editor/editor.c:320: if (end <= first) continue;
	ld	hl, sp+5
	ld	a, [hl]
	sub	a, e
	jp	C, .l00113
	jp	.l00115
.l00112:
;src/editor/editor.c:322: else end = 0xFF; // continues, so the line feed or wrap is selected too
	ld	e, $FF
.l00113:
;src/editor/editor.c:323: render_sel[(row + bars) << 1] = first;
	ld	hl, sp+9
	ld	a, [hl]
	ld	hl, _bars
	add	a, [hl]
	add	a, a
	ld	c, a
	rlca
	sbc	a, a
	ld	b, a
	ld	hl, _render_sel
	add	hl, bc
	ld	c, l
	ld	b, h
	ld	hl, sp+5
	ld	a, [hl]
	ld	[bc], a
;src/editor/editor.c:324: render_sel[((row + bars) << 1) + 1] = end;
	ld	hl, sp+9
	ld	a, [hl]
	ld	hl, _bars
	add	a, [hl]
	add	a, a
	inc	a
	ld	c, a
	rlca
	sbc	a, a
	ld	b, a
	ld	hl, _render_sel
	add	hl, bc
	ld	[hl], e
.l00115:
;src/editor/editor.c:310: for (row = 0; row < tb_rows; ++row) {
	ld	hl, sp+9
	inc	[hl]
	jp	.l00118
.l00119:
;src/editor/editor.c:326: }
	add	sp, 10
	ret
;src/editor/editor.c:329: static unsigned int LinesBefore(unsigned int pos) {
;	---------------------------------
; Function LinesBefore
; ---------------------------------
_LinesBefore:
;src/editor/editor.c:330: if (pos >= counted_pos) counted_lines += tb_CountLines(counted_pos, pos);
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
;src/editor/editor.c:331: else if (pos < counted_pos - pos) counted_lines = tb_CountLines(0, pos);
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
;src/editor/editor.c:332: else counted_lines -= tb_CountLines(pos, counted_pos);
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
;src/editor/editor.c:333: counted_pos = pos;
	ld	hl, _counted_pos
	ld	[hl], e
	inc	hl
	ld	[hl], d
;src/editor/editor.c:334: return counted_lines;
	ld	hl, _counted_lines
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
.l00107:
;src/editor/editor.c:335: }
	ret
;src/editor/editor.c:338: static void CountEdit(unsigned int pos, unsigned char c, unsigned char inserted) {
;	---------------------------------
; Function CountEdit
; ---------------------------------
_CountEdit:
	ld	c, a
;src/editor/editor.c:339: if (pos >= counted_pos) return;
	ld	hl, _counted_pos
	ld	a, e
	sub	a, [hl]
	inc	hl
	ld	a, d
	sbc	a, [hl]
	jp	C, .l00102
	jp	.l00110
.l00102:
;src/editor/editor.c:342: if (c == ASCII_LF) ++counted_lines;
	ld	a, c
	sub	a, $0A
	jp	NZ,.l00132
	ld	a,$01
	jp	.l00133
.l00132:
	xor	a,a
.l00133:
	ld	c, a
;src/editor/editor.c:340: if (inserted) {
	ld	hl, sp+2
	ld	a, [hl]
	or	a, a
	jp	Z, .l00108
;src/editor/editor.c:341: ++counted_pos;
	ld	hl, _counted_pos
	inc	[hl]
	jp	NZ, .l00134
	inc	hl
	inc	[hl]
.l00134:
;src/editor/editor.c:342: if (c == ASCII_LF) ++counted_lines;
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
;src/editor/editor.c:345: --counted_pos;
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
;src/editor/editor.c:346: if (c == ASCII_LF) --counted_lines;
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
;src/editor/editor.c:348: }
	pop	hl
	inc	sp
	jp hl 
;src/editor/editor.c:351: static void Uncount(unsigned int pos) {
;	---------------------------------
; Function Uncount
; ---------------------------------
_Uncount:
;src/editor/editor.c:352: if (pos < counted_pos) counted_pos = counted_lines = 0;
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
;src/editor/editor.c:353: }
	ret
;src/editor/editor.c:356: static unsigned char RowEndsLine(unsigned char row) {
;	---------------------------------
; Function RowEndsLine
; ---------------------------------
_RowEndsLine:
	ld	e, a
;src/editor/editor.c:357: return tb_GetChar(tb_row_starts[row + 1] - 1) == ASCII_LF;
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
;src/editor/editor.c:358: }
	ret
;src/editor/editor.c:360: static unsigned int CursorLine(void) {
;	---------------------------------
; Function CursorLine
; ---------------------------------
_CursorLine:
;src/editor/editor.c:361: unsigned int line = LinesBefore(top) + 1;
	ld	hl, _top
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_LinesBefore
	inc	bc
;src/editor/editor.c:363: for (row = 0; row < tb_found_row; ++row) if (RowEndsLine(row)) ++line;
	ld	e, $00
.l00105:
	ld	a, e
	ld	hl, _tb_found_row
	sub	a, [hl]
	jp	NC, .l00103
	push	bc
	push	de
	ld	a, e
	call	_RowEndsLine
	pop	de
	pop	bc
	or	a, a
	jp	Z, .l00106
	inc	bc
.l00106:
	inc	e
	jp	.l00105
.l00103:
;src/editor/editor.c:364: return line;
.l00107:
;src/editor/editor.c:365: }
	ret
;src/editor/editor.c:367: static unsigned int CursorColumn(void) {
;	---------------------------------
; Function CursorColumn
; ---------------------------------
_CursorColumn:
	dec	sp
	dec	sp
;src/editor/editor.c:368: unsigned char row = tb_found_row;
	ld	hl, _tb_found_row
	ld	c, [hl]
;src/editor/editor.c:370: while (row && !RowEndsLine(row - 1)) --row;
.l00102:
	ld	a, c
	or	a, a
	jp	Z, .l00104
	ld	b, c
	dec	b
	push	bc
	ld	a, b
	call	_RowEndsLine
	pop	bc
	or	a, a
	jp	NZ, .l00104
	dec	c
	jp	.l00102
.l00104:
;src/editor/editor.c:371: start = tb_row_starts[row];
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
;src/editor/editor.c:372: if (!row && start && tb_GetChar(start - 1) != ASCII_LF) start = tb_LineStart(start);
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
;src/editor/editor.c:373: return cursor - start + 1;
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
;src/editor/editor.c:374: }
	inc	sp
	inc	sp
	ret
;src/editor/editor.c:376: static char* PutText(char* dest, const char* text) {
;	---------------------------------
; Function PutText
; ---------------------------------
_PutText:
;src/editor/editor.c:377: while (*text) *dest++ = *text++;
.l00101:
	ld	a, [bc]
	or	a, a
	jp	Z, .l00103
	inc	bc
	ld	[de], a
	inc	de
	jp	.l00101
.l00103:
;src/editor/editor.c:378: return dest;
	ld	c, e
	ld	b, d
.l00104:
;src/editor/editor.c:379: }
	ret
;src/editor/editor.c:383: static char* PutNumber(char* dest, unsigned int n) {
;	---------------------------------
; Function PutNumber
; ---------------------------------
_PutNumber:
	add	sp, -8
	ld	hl, sp+4
	ld	[hl], e
	inc	hl
	ld	[hl], d
	ld	hl, sp+2
	ld	[hl], c
	inc	hl
	ld	[hl], b
;src/editor/editor.c:384: unsigned char i, digit, started = 0;
	ld	hl, sp+0
	ld	[hl], $00
;src/editor/editor.c:385: for (i = 0; i < 4; ++i) {
	ld	hl, sp+6
	ld	[hl], $00
;src/editor/editor.c:387: while (n >= powers_of_ten[i]) {
.l00113:
	ld	hl, sp+7
	ld	[hl], $30
.l00101:
	ld	hl, sp+6
	ld	a, [hl]
	ld	c, $00
	ld	l, a
	ld	h, c
	add	hl, hl
	ld	de, _powers_of_ten
	add	hl, de
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	ld	hl, sp+2
	ld	a, [hl]
	sub	a, c
	inc	hl
	ld	a, [hl]
	sbc	a, b
	jp	C, .l00117
;src/editor/editor.c:388: n -= powers_of_ten[i];
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, e
	sub	a, c
	ld	e, a
	ld	a, d
	sbc	a, b
	ld	[hl], a
	dec	hl
	ld	[hl], e
;src/editor/editor.c:389: ++digit;
	ld	hl, sp+7
	inc	[hl]
	jp	.l00101
.l00117:
	ld	hl, sp+7
	ld	a, [hl]
	ld	hl, sp+1
	ld	[hl], a
;src/editor/editor.c:391: if (started || digit != '0') {
	dec	hl
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00104
	ld	hl, sp+7
	ld	a, [hl]
	sub	a, $30
	jp	NZ,.l00139
	jp	.l00109
.l00139:
.l00104:
;src/editor/editor.c:392: *dest++ = digit;
	ld	hl, sp+5
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, sp+1
	ld	a, [hl]
	ld	[de], a
	ld	hl, sp+4
	inc	[hl]
	jp	NZ, .l00140
	inc	hl
	inc	[hl]
.l00140:
;src/editor/editor.c:393: started = 1;
	ld	hl, sp+0
	ld	[hl], $01
.l00109:
;src/editor/editor.c:385: for (i = 0; i < 4; ++i) {
	ld	hl, sp+6
	inc	[hl]
	ld	a, [hl]
	sub	a, $04
	jp	C, .l00113
;src/editor/editor.c:396: *dest++ = '0' + (unsigned char)n;
	ld	hl, sp+2
	ld	a, [hl]
	ld	hl, sp+7
	ld	[hl], a
	ld	a, [hl]
	add	a, $30
	ld	c, a
	ld	hl, sp+4
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	ld	[hl], c
	ld	hl, sp+4
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	inc	bc
;src/editor/editor.c:397: return dest;
.l00110:
;src/editor/editor.c:398: }
	add	sp, 8
	ret
_powers_of_ten:
	DW $2710
	DW $03E8
	DW $0064
	DW $000A
;src/editor/editor.c:401: static void UpdateBars(void) {
;	---------------------------------
; Function UpdateBars
; ---------------------------------
_UpdateBars:
	add	sp, -40
;src/editor/editor.c:403: char* end = PutText(text, file_name[0] ? file_name : "Untitled");
	ld	bc, _file_name+0
	ld	a, [bc]
	or	a, a
	jp	Z, .l00110
	jp	.l00111
.l00110:
	ld	bc, ___str_25+0
.l00111:
	ld	hl, 0
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_PutText
;src/editor/editor.c:404: if (modified) *end++ = '*';
	ld	hl, _modified
	ld	a, [hl]
	or	a, a
	jp	Z, .l00102
	ld	a, $2A
	ld	[bc], a
	inc	bc
.l00102:
;src/editor/editor.c:405: *end = 0;
	xor	a, a
	ld	[bc], a
;src/editor/editor.c:406: DrawRow(HEADER_LINE, 1, text);
	ld	hl, 0
	add	hl, sp
	push	hl
	ld	e, $01
	ld	a, $12
	call	_DrawRow
;src/editor/editor.c:407: if (tb_found_row == 0xFF) return; // cursor isn't on screen
	ld	hl, _tb_found_row
	ld	a, [hl]
	inc	a
	jp	NZ,.l00132
	jp	.l00133
.l00132:
	jp	.l00104
.l00133:
	jp	.l00108
.l00104:
;src/editor/editor.c:408: if (GetSelection()) {
	call	_GetSelection
	ld	c, a
	ld	a, c
	or	a, a
	jp	Z, .l00106
;src/editor/editor.c:409: end = PutNumber(text, sel_end - sel_start);
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
	ld	hl, 0
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_PutNumber
	ld	e, c
	ld	d, b
;src/editor/editor.c:410: end = PutText(end, " selected");
	ld	bc, ___str_26
	call	_PutText
	jp	.l00107
.l00106:
;src/editor/editor.c:413: end = PutText(text, "Line ");
	ld	bc, ___str_27
	ld	hl, 0
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_PutText
	ld	e, c
	ld	d, b
;src/editor/editor.c:414: end = PutNumber(end, CursorLine());
	push	de
	call	_CursorLine
	pop	de
	call	_PutNumber
	ld	e, c
	ld	d, b
;src/editor/editor.c:415: end = PutText(end, ", Col ");
	ld	bc, ___str_28
	call	_PutText
	ld	e, c
	ld	d, b
;src/editor/editor.c:416: end = PutNumber(end, CursorColumn());
	push	de
	call	_CursorColumn
	pop	de
	call	_PutNumber
.l00107:
;src/editor/editor.c:418: *end = 0;
	xor	a, a
	ld	[bc], a
;src/editor/editor.c:419: DrawRow(STATUS_LINE, 1, text);
	ld	hl, 0
	add	hl, sp
	push	hl
	ld	e, $01
	ld	a, $13
	call	_DrawRow
.l00108:
;src/editor/editor.c:420: }
	add	sp, 40
	ret
___str_25:
	DB "Untitled"
	DB $00
___str_26:
	DB " selected"
	DB $00
___str_27:
	DB "Line "
	DB $00
___str_28:
	DB ", Col "
	DB $00
;src/editor/editor.c:422: static void Draw(void) {
;	---------------------------------
; Function Draw
; ---------------------------------
_Draw:
;src/editor/editor.c:423: SetHighlight();
	call	_SetHighlight
;src/editor/editor.c:424: if (bars) UpdateBars();
	ld	hl, _bars
	ld	a, [hl]
	or	a, a
	jp	Z, .l00102
	call	_UpdateBars
.l00102:
;src/editor/editor.c:425: EditorDraw();
	jp	_EditorDraw
.l00103:
;src/editor/editor.c:426: }
	ret
;src/editor/editor.c:429: static void ScrollTo(unsigned int new_top) {
;	---------------------------------
; Function ScrollTo
; ---------------------------------
_ScrollTo:
	ld	hl, _top
	ld	[hl], e
	inc	hl
	ld	[hl], d
;src/editor/editor.c:431: Render();
	call	_Render
;src/editor/editor.c:432: redraw = 1;
	ld	hl, _redraw
	ld	[hl], $01
.l00101:
;src/editor/editor.c:433: }
	ret
;src/editor/editor.c:435: static void MoveUp(void) {
;	---------------------------------
; Function MoveUp
; ---------------------------------
_MoveUp:
;src/editor/editor.c:436: unsigned char row = tb_found_row;
	ld	hl, _tb_found_row
	ld	a, [hl]
;src/editor/editor.c:437: keep_x = 1;
	ld	hl, _keep_x
	ld	[hl], $01
;src/editor/editor.c:438: if (row) cursor = PosAtX(row - 1, want_x);
	or	a, a
	jp	Z, .l00105
	ld	c, a
	dec	c
	ld	hl, _want_x
	ld	e, [hl]
	ld	a, c
	call	_PosAtX
	ld	hl, _cursor
	ld	[hl], c
	inc	hl
	ld	[hl], b
	jp	.l00107
.l00105:
;src/editor/editor.c:439: else if (!top) cursor = 0;
	ld	hl, _top + 1
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	jp	NZ, .l00102
	xor	a, a
	ld	hl, _cursor
	ld	[hl], a
	inc	hl
	ld	[hl], a
	jp	.l00107
.l00102:
;src/editor/editor.c:441: ScrollUp(tb_RowStart(top - 1));
	ld	hl, _top + 1
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	dec	de
	call	_tb_RowStart
	ld	e, c
	ld	d, b
	call	_ScrollUp
;src/editor/editor.c:442: cursor = PosAtX(0, want_x);
	ld	hl, _want_x
	ld	e, [hl]
	xor	a, a
	call	_PosAtX
	ld	hl, _cursor
	ld	[hl], c
	inc	hl
	ld	[hl], b
.l00107:
;src/editor/editor.c:444: }
	ret
;src/editor/editor.c:446: static void MoveDown(void) {
;	---------------------------------
; Function MoveDown
; ---------------------------------
_MoveDown:
	dec	sp
;src/editor/editor.c:447: unsigned char row = tb_found_row;
	ld	hl, _tb_found_row
	ld	a, [hl]
	ld	hl, sp+0
	ld	[hl], a
;src/editor/editor.c:448: keep_x = 1;
	ld	hl, _keep_x
	ld	[hl], $01
;src/editor/editor.c:449: if (tb_end_row == row) cursor = tb_Length(); // last row
	ld	hl, _tb_end_row
	ld	a, [hl]
	ld	hl, sp+0
	sub	a, [hl]
	jp	NZ,.l00119
	jp	.l00120
.l00119:
	jp	.l00105
.l00120:
	call	_tb_Length
	ld	hl, _cursor
	ld	[hl], c
	inc	hl
	ld	[hl], b
	jp	.l00107
.l00105:
;src/editor/editor.c:450: else if (row + 1 < tb_rows) cursor = PosAtX(row + 1, want_x);
	ld	hl, sp+0
	ld	c, [hl]
	ld	b, $00
	inc	bc
	ld	hl, _tb_rows
	ld	l, [hl]
;	spillPairReg hl
;	spillPairReg hl
	ld	h, $00
;	spillPairReg hl
;	spillPairReg hl
	ld	a, h
	ld	e, a
	ld	a, b
	ld	d, a
	ld	a, c
	sub	a, l
	ld	a, b
	sbc	a, h
	bit	7, e
	jp	Z, .l00121
	bit	7, d
	jp	NZ, .l00122
	cp	a, a
	jp	.l00122
.l00121:
	bit	7, d
	jp	Z, .l00122
	scf
.l00122:
	jp	NC, .l00102
	ld	hl, sp+0
	ld	c, [hl]
	inc	c
	ld	hl, _want_x
	ld	e, [hl]
	ld	a, c
	call	_PosAtX
	ld	hl, _cursor
	ld	[hl], c
	inc	hl
	ld	[hl], b
	jp	.l00107
.l00102:
;src/editor/editor.c:452: ScrollDown();
	call	_ScrollDown
;src/editor/editor.c:453: cursor = PosAtX(row, want_x);
	ld	hl, _want_x
	ld	e, [hl]
	ld	hl, sp+0
	ld	a, [hl]
	call	_PosAtX
	ld	hl, _cursor
	ld	[hl], c
	inc	hl
	ld	[hl], b
.l00107:
;src/editor/editor.c:455: }
	inc	sp
	ret
;src/editor/editor.c:457: static void PageUp(void) {
;	---------------------------------
; Function PageUp
; ---------------------------------
_PageUp:
;src/editor/editor.c:458: unsigned char row = tb_found_row, i;
	ld	hl, _tb_found_row
	ld	c, [hl]
;src/editor/editor.c:459: keep_x = 1;
	ld	hl, _keep_x
	ld	[hl], $01
;src/editor/editor.c:460: if (!top) {
	ld	hl, _top + 1
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	jp	NZ, .l00102
;src/editor/editor.c:461: cursor = 0;
	xor	a, a
	ld	hl, _cursor
	ld	[hl], a
	inc	hl
	ld	[hl], a
;src/editor/editor.c:462: return;
	jp	.l00108
.l00102:
;src/editor/editor.c:464: for (i = tb_rows - 1; i && top; --i) top = tb_RowStart(top - 1);
	ld	hl, _tb_rows
	ld	b, [hl]
	dec	b
.l00106:
	ld	a, b
	or	a, a
	jp	Z, .l00103
	ld	hl, _top + 1
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	jp	Z, .l00103
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
	dec	b
	jp	.l00106
.l00103:
;src/editor/editor.c:465: ScrollTo(top);
	push	bc
	ld	hl, _top
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_ScrollTo
	pop	bc
;src/editor/editor.c:466: cursor = PosAtX(row, want_x);
	ld	hl, _want_x
	ld	e, [hl]
	ld	a, c
	call	_PosAtX
	ld	hl, _cursor
	ld	[hl], c
	inc	hl
	ld	[hl], b
.l00108:
;src/editor/editor.c:467: }
	ret
;src/editor/editor.c:469: static void PageDown(void) {
;	---------------------------------
; Function PageDown
; ---------------------------------
_PageDown:
;src/editor/editor.c:470: unsigned char row = tb_found_row;
	ld	hl, _tb_found_row
	ld	c, [hl]
;src/editor/editor.c:471: keep_x = 1;
	ld	hl, _keep_x
	ld	[hl], $01
;src/editor/editor.c:472: if (tb_end_row != 0xFF) {
	ld	hl, _tb_end_row
	ld	a, [hl]
	inc	a
	jp	NZ,.l00123
	jp	.l00102
.l00123:
;src/editor/editor.c:473: cursor = tb_Length();
	call	_tb_Length
	ld	hl, _cursor
	ld	[hl], c
	inc	hl
	ld	[hl], b
;src/editor/editor.c:474: return;
	jp	.l00106
.l00102:
;src/editor/editor.c:476: ScrollTo(tb_row_starts[tb_rows - 1]);
	ld	hl, _tb_rows
	ld	a, [hl]
	dec	a
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
	push	bc
	ld	e, l
	ld	d, h
	call	_ScrollTo
	pop	bc
;src/editor/editor.c:477: if (tb_end_row != 0xFF && row > tb_end_row) row = tb_end_row;
	ld	hl, _tb_end_row
	ld	a, [hl]
	inc	a
	jp	NZ,.l00124
	jp	.l00104
.l00124:
	ld	hl, _tb_end_row
	ld	a, [hl]
	sub	a, c
	jp	NC, .l00104
	ld	c, [hl]
.l00104:
;src/editor/editor.c:478: cursor = PosAtX(row, want_x);
	ld	hl, _want_x
	ld	e, [hl]
	ld	a, c
	call	_PosAtX
	ld	hl, _cursor
	ld	[hl], c
	inc	hl
	ld	[hl], b
.l00106:
;src/editor/editor.c:479: }
	ret
;src/editor/editor.c:482: static void MoveEnd(void) {
;	---------------------------------
; Function MoveEnd
; ---------------------------------
_MoveEnd:
	add	sp, -4
;src/editor/editor.c:483: unsigned char row = tb_found_row, count = tb_row_counts[row];
	ld	hl, _tb_found_row
	ld	a, [hl]
	ld	hl, sp+0
	ld	[hl], a
	ld	bc, _tb_row_counts+0
	ld	l, [hl]
	ld	h, $00
	add	hl, bc
	ld	c, l
	ld	b, h
	ld	a, [bc]
	ld	hl, sp+1
	ld	[hl], a
;src/editor/editor.c:484: cursor = tb_row_starts[row] + count;
	dec	hl
	ld	c, [hl]
	ld	b, $00
	ld	l, c
	ld	h, b
	add	hl, hl
	ld	de, _tb_row_starts
	add	hl, de
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	ld	hl, sp+1
	ld	a, [hl]
	inc	hl
	ld	[hl], a
	inc	hl
	ld	[hl], $00
	pop	hl
	pop	de
	push	de
	push	hl
	ld	a, e
	add	a, c
	ld	hl, _cursor
	ld	[hl], a
	ld	a, d
	adc	a, b
	inc	hl
	ld	[hl], a
;src/editor/editor.c:485: if (count && cursor == tb_row_starts[row + 1] && tb_end_row != row && RowAddress(row)[count - 1] == ' ') --cursor;
	ld	hl, sp+1
	ld	a, [hl]
	or	a, a
	jp	Z, .l00106
	dec	hl
	ld	a, [hl]
	inc	a
	ld	l, a
;	spillPairReg hl
;	spillPairReg hl
	rlca
	sbc	a, a
	ld	h, a
;	spillPairReg hl
;	spillPairReg hl
	add	hl, hl
	ld	de, _tb_row_starts
	add	hl, de
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	ld	hl, _cursor
	ld	a, [hl]
	sub	a, c
	jp	NZ,.l00128
	inc	hl
	ld	a, [hl]
	sub	a, b
	jp	NZ,.l00128
	jp	.l00129
.l00128:
	jp	.l00106
.l00129:
	ld	hl, _tb_end_row
	ld	a, [hl]
	ld	hl, sp+0
	sub	a, [hl]
	jp	NZ,.l00130
	jp	.l00106
.l00130:
	ld	hl, sp+0
	ld	a, [hl]
	call	_RowAddress
	pop	hl
	push	bc
	ld	hl, sp+3
	dec	hl
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	dec	bc
	pop	hl
	push	hl
	add	hl, bc
	ld	c, l
	ld	b, h
	ld	a, [bc]
	sub	a, $20
	jp	NZ,.l00131
	jp	.l00132
.l00131:
	jp	.l00106
.l00132:
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
;src/editor/editor.c:486: }
	add	sp, 4
	ret
;src/editor/editor.c:488: static void DeleteSelection(void) {
;	---------------------------------
; Function DeleteSelection
; ---------------------------------
_DeleteSelection:
;src/editor/editor.c:489: Uncount(sel_start);
	ld	hl, _sel_start
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_Uncount
;src/editor/editor.c:490: tb_DeleteRange(sel_start, sel_end - sel_start);
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
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_tb_DeleteRange
;src/editor/editor.c:491: cursor = sel_start;
	ld	hl, _sel_start
	ld	a, [hl]
	ld	hl, _cursor
	ld	[hl], a
	ld	hl, _sel_start + 1
	ld	a, [hl]
	ld	hl, _cursor + 1
	ld	[hl], a
;src/editor/editor.c:492: selecting = 0;
	ld	hl, _selecting
	ld	[hl], $00
;src/editor/editor.c:493: modified = 1;
	ld	hl, _modified
	ld	[hl], $01
;src/editor/editor.c:494: dirty = 1;
	ld	hl, _dirty
	ld	[hl], $01
.l00101:
;src/editor/editor.c:495: }
	ret
;src/editor/editor.c:497: static unsigned char Copy(void) {
;	---------------------------------
; Function Copy
; ---------------------------------
_Copy:
;src/editor/editor.c:498: if (!GetSelection()) return 0;
	call	_GetSelection
	or	a, a
	jp	NZ, .l00102
	xor	a, a
	jp	.l00105
.l00102:
;src/editor/editor.c:499: if (tb_Copy(sel_start, sel_end - sel_start)) return 1;
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
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_tb_Copy
	or	a, a
	jp	Z, .l00104
	ld	a, $01
	jp	.l00105
.l00104:
;src/editor/editor.c:500: ShowMessage("TOO BIG TO COPY");
	ld	de, ___str_29
	call	_ShowMessage
;src/editor/editor.c:501: return 0;
	xor	a, a
.l00105:
;src/editor/editor.c:502: }
	ret
___str_29:
	DB "TOO BIG TO COPY"
	DB $00
;src/editor/editor.c:504: static void Paste(void) {
;	---------------------------------
; Function Paste
; ---------------------------------
_Paste:
	add	sp, -4
;src/editor/editor.c:505: unsigned int length = tb_ClipLength(), room = TB_SIZE - tb_Length();
	call	_tb_ClipLength
	push	bc
	call	_tb_Length
	ld	hl, sp+2
	ld	[hl], c
	inc	hl
	ld	[hl], b
	pop	bc
	ld	de, $5FD0
	pop	hl
	push	hl
	ld	a, e
	sub	a, l
	ld	e, a
	ld	a, d
	sbc	a, h
	ld	hl, sp+3
	ld	[hl], a
	dec	hl
	ld	[hl], e
;src/editor/editor.c:506: if (!length) return;
	ld	a, b
	or	a, c
	jp	NZ, .l00102
	jp	.l00109
.l00102:
;src/editor/editor.c:507: if (GetSelection()) room += sel_end - sel_start;
	push	bc
	call	_GetSelection
	pop	bc
	or	a, a
	jp	Z, .l00104
	ld	hl, _sel_end
	ld	a, [hl]
	ld	hl, _sel_start
	sub	a, [hl]
	ld	e, a
	ld	hl, _sel_end + 1
	ld	a, [hl]
	ld	hl, _sel_start + 1
	sbc	a, [hl]
	ld	d, a
	ld	hl, sp+2
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+4
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+3
	ld	[hl], a
.l00104:
;src/editor/editor.c:508: if (length > room) {
	ld	hl, sp+2
	ld	a, [hl]
	sub	a, c
	inc	hl
	ld	a, [hl]
	sbc	a, b
	jp	NC, .l00106
;src/editor/editor.c:509: ShowMessage("TEXT FULL");
	ld	de, ___str_30
	call	_ShowMessage
;src/editor/editor.c:510: return;
	jp	.l00109
.l00106:
;src/editor/editor.c:512: if (GetSelection()) DeleteSelection();
	push	bc
	call	_GetSelection
	pop	bc
	or	a, a
	jp	Z, .l00108
	push	bc
	call	_DeleteSelection
	pop	bc
.l00108:
;src/editor/editor.c:513: Uncount(cursor);
	push	bc
	ld	hl, _cursor
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_Uncount
	pop	bc
;src/editor/editor.c:514: tb_Paste(cursor);
	push	bc
	ld	hl, _cursor
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_tb_Paste
	pop	bc
;src/editor/editor.c:515: cursor += length;
	ld	hl, _cursor
	ld	a, [hl]
	add	a, c
	ld	[hl], a
	inc	hl
	ld	a, [hl]
	adc	a, b
	ld	[hl], a
;src/editor/editor.c:516: modified = 1;
	ld	hl, _modified
	ld	[hl], $01
;src/editor/editor.c:517: dirty = 1;
	ld	hl, _dirty
	ld	[hl], $01
.l00109:
;src/editor/editor.c:518: }
	add	sp, 4
	ret
___str_30:
	DB "TEXT FULL"
	DB $00
;src/editor/editor.c:521: static unsigned char CharClass(unsigned char c) {
;	---------------------------------
; Function CharClass
; ---------------------------------
_CharClass:
	ld	c, a
;src/editor/editor.c:522: if (c == ' ' || c == ASCII_TAB || c == ASCII_LF) return 0;
	ld	a, c
	sub	a, $20
	jp	NZ,.l00146
	jp	.l00101
.l00146:
	ld	a, c
	sub	a, $09
	jp	NZ,.l00147
	jp	.l00101
.l00147:
	ld	a, c
	sub	a, $0A
	jp	NZ,.l00148
	jp	.l00149
.l00148:
	jp	.l00102
.l00149:
.l00101:
	xor	a, a
	jp	.l00114
.l00102:
;src/editor/editor.c:523: if ((c >= '0' && c <= '9') || (c >= 'A' && c <= 'Z') || (c >= 'a' && c <= 'z') || c == '_' || c >= 0xC0) return 1;
	ld	a, c
	sub	a, $30
	jp	C, .l00109
	ld	a, $39
	sub	a, c
	jp	NC, .l00105
.l00109:
	ld	a, c
	sub	a, $41
	jp	C, .l00111
	ld	a, $5A
	sub	a, c
	jp	NC, .l00105
.l00111:
	ld	a, c
	sub	a, $61
	jp	C, .l00112
	ld	a, $7A
	sub	a, c
	jp	NC, .l00105
.l00112:
	ld	a, c
	sub	a, $5F
	jp	NZ,.l00150
	jp	.l00105
.l00150:
	ld	a, c
	sub	a, $C0
	jp	C, .l00106
.l00105:
	ld	a, $01
	jp	.l00114
.l00106:
;src/editor/editor.c:524: return 2;
	ld	a, $02
.l00114:
;src/editor/editor.c:525: }
	ret
;src/editor/editor.c:528: static void WordRight(void) {
;	---------------------------------
; Function WordRight
; ---------------------------------
_WordRight:
	dec	sp
;src/editor/editor.c:529: unsigned int length = tb_Length();
	call	_tb_Length
;src/editor/editor.c:531: while (cursor < length && !CharClass(tb_GetChar(cursor))) ++cursor;
.l00102:
	ld	hl, _cursor
	ld	a, [hl]
	sub	a, c
	inc	hl
	ld	a, [hl]
	sbc	a, b
	jp	NC, .l00104
	push	bc
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_tb_GetChar
	ld	e, a
	pop	bc
	push	bc
	ld	a, e
	call	_CharClass
	pop	bc
	or	a, a
	jp	NZ, .l00104
	ld	hl, _cursor
	inc	[hl]
	jp	NZ, .l00143
	inc	hl
	inc	[hl]
.l00143:
	jp	.l00102
.l00104:
;src/editor/editor.c:532: if (cursor == length) return;
	ld	hl, _cursor
	ld	a, [hl]
	sub	a, c
	jp	NZ,.l00144
	inc	hl
	ld	a, [hl]
	sub	a, b
	jp	NZ,.l00144
	jp	.l00145
.l00144:
	jp	.l00106
.l00145:
	jp	.l00111
.l00106:
;src/editor/editor.c:533: token = CharClass(tb_GetChar(cursor));
	push	bc
	ld	hl, _cursor
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_tb_GetChar
	ld	e, a
	pop	bc
	push	bc
	ld	a, e
	call	_CharClass
	pop	bc
	ld	hl, sp+0
	ld	[hl], a
;src/editor/editor.c:534: do ++cursor;
.l00108:
	ld	hl, _cursor
	inc	[hl]
	jp	NZ, .l00146
	inc	hl
	inc	[hl]
.l00146:
;src/editor/editor.c:535: while (cursor < length && CharClass(tb_GetChar(cursor)) == token);
	ld	hl, _cursor
	ld	a, [hl]
	sub	a, c
	inc	hl
	ld	a, [hl]
	sbc	a, b
	jp	NC, .l00111
	push	bc
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_tb_GetChar
	ld	e, a
	pop	bc
	push	bc
	ld	a, e
	call	_CharClass
	ld	e, a
	pop	bc
	ld	hl, sp+0
	ld	a, [hl]
	sub	a, e
	jp	NZ,.l00147
	jp	.l00108
.l00147:
.l00111:
;src/editor/editor.c:536: }
	inc	sp
	ret
;src/editor/editor.c:539: static void WordLeft(void) {
;	---------------------------------
; Function WordLeft
; ---------------------------------
_WordLeft:
;src/editor/editor.c:541: while (cursor && !CharClass(tb_GetChar(cursor - 1))) --cursor;
.l00102:
	ld	hl, _cursor + 1
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	dec	de
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	jp	Z, .l00104
	call	_tb_GetChar
	ld	c, a
	ld	a, c
	call	_CharClass
	ld	hl, _cursor + 1
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	dec	de
	or	a, a
	jp	NZ, .l00104
	dec	hl
	ld	[hl], e
	inc	hl
	ld	[hl], d
	jp	.l00102
.l00104:
;src/editor/editor.c:542: if (!cursor) return;
	ld	hl, _cursor + 1
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	jp	NZ, .l00106
	jp	.l00111
.l00106:
;src/editor/editor.c:543: token = CharClass(tb_GetChar(cursor - 1));
	call	_tb_GetChar
	ld	c, a
	ld	a, c
	call	_CharClass
	ld	c, a
;src/editor/editor.c:544: do --cursor;
.l00108:
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
;src/editor/editor.c:545: while (cursor && CharClass(tb_GetChar(cursor - 1)) == token);
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	jp	Z, .l00111
	inc	hl
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	dec	de
	push	bc
	call	_tb_GetChar
	ld	e, a
	pop	bc
	push	bc
	ld	a, e
	call	_CharClass
	pop	bc
	sub	a, c
	jp	NZ,.l00143
	jp	.l00108
.l00143:
.l00111:
;src/editor/editor.c:546: }
	ret
;src/editor/editor.c:549: static void ScrollLine(unsigned char down) {
;	---------------------------------
; Function ScrollLine
; ---------------------------------
_ScrollLine:
	ld	c, a
;src/editor/editor.c:550: unsigned char row = tb_found_row;
	ld	hl, _tb_found_row
	ld	b, [hl]
;src/editor/editor.c:551: keep_x = 1;
	ld	hl, _keep_x
	ld	[hl], $01
;src/editor/editor.c:552: if (down) {
	ld	a, c
	or	a, a
	jp	Z, .l00110
;src/editor/editor.c:553: if (tb_end_row != 0xFF) return; // the end of the text is on screen
	ld	hl, _tb_end_row
	ld	a, [hl]
	inc	a
	jp	NZ,.l00139
	jp	.l00102
.l00139:
	jp	.l00112
.l00102:
;src/editor/editor.c:554: ScrollDown();
	push	bc
	call	_ScrollDown
	pop	bc
;src/editor/editor.c:555: if (!row) cursor = PosAtX(0, want_x);
	ld	a, b
	or	a, a
	jp	NZ, .l00112
	ld	hl, _want_x
	ld	e, [hl]
	xor	a, a
	call	_PosAtX
	ld	hl, _cursor
	ld	[hl], c
	inc	hl
	ld	[hl], b
	jp	.l00112
.l00110:
;src/editor/editor.c:557: else if (top) {
	ld	hl, _top + 1
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	jp	Z, .l00112
;src/editor/editor.c:558: ScrollUp(tb_RowStart(top - 1));
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
	push	bc
	call	_ScrollUp
	pop	bc
;src/editor/editor.c:559: if (row == tb_rows - 1) cursor = PosAtX(row, want_x);
	ld	hl, _tb_rows
	ld	e, [hl]
	ld	d, $00
	dec	de
	ld	c, b
	ld	l, $00
;	spillPairReg hl
;	spillPairReg hl
	ld	a, c
	sub	a, e
	jp	NZ,.l00140
	ld	a, l
	sub	a, d
	jp	NZ,.l00140
	jp	.l00141
.l00140:
	jp	.l00112
.l00141:
	ld	hl, _want_x
	ld	e, [hl]
	ld	a, b
	call	_PosAtX
	ld	hl, _cursor
	ld	[hl], c
	inc	hl
	ld	[hl], b
.l00112:
;src/editor/editor.c:561: }
	ret
;src/editor/editor.c:564: static void HandleCtrlKey(unsigned char key) {
;	---------------------------------
; Function HandleCtrlKey
; ---------------------------------
_HandleCtrlKey:
	ld	l, a
;	spillPairReg hl
;	spillPairReg hl
;src/editor/editor.c:565: if (key >= 'A' && key <= 'Z') key += 'a' - 'A';
	ld	a, l
	sub	a, $41
	jp	C, .l00102
	ld	a, $5A
	sub	a, l
	jp	C, .l00102
	ld	c, $20
	add	hl, bc
.l00102:
;src/editor/editor.c:566: if (key == 'a') {
	ld	a, l
	sub	a, $61
	jp	NZ,.l00153
	jp	.l00154
.l00153:
	jp	.l00114
.l00154:
;src/editor/editor.c:567: anchor = 0;
	xor	a, a
	ld	hl, _anchor
	ld	[hl], a
	inc	hl
	ld	[hl], a
;src/editor/editor.c:568: cursor = tb_Length();
	call	_tb_Length
	ld	hl, _cursor
	ld	[hl], c
	inc	hl
	ld	[hl], b
;src/editor/editor.c:569: selecting = 1;
	ld	hl, _selecting
	ld	[hl], $01
;src/editor/editor.c:570: moved = 1;
	ld	hl, _moved
	ld	[hl], $01
;src/editor/editor.c:571: redraw = 1;
	ld	hl, _redraw
	ld	[hl], $01
	jp	.l00116
.l00114:
;src/editor/editor.c:573: else if (key == 'c') Copy();
	ld	a, l
	sub	a, $63
	jp	NZ,.l00155
	jp	.l00156
.l00155:
	jp	.l00111
.l00156:
	jp	_Copy
	jp	.l00116
.l00111:
;src/editor/editor.c:574: else if (key == 'x' && Copy()) DeleteSelection();
	ld	a, l
	sub	a, $78
	jp	NZ,.l00157
	jp	.l00158
.l00157:
	jp	.l00107
.l00158:
	push	hl
	call	_Copy
	pop	hl
	or	a, a
	jp	Z, .l00107
	jp	_DeleteSelection
	jp	.l00116
.l00107:
;src/editor/editor.c:575: else if (key == 'v') Paste();
	ld	a, l
	sub	a, $76
	jp	NZ,.l00159
	jp	.l00160
.l00159:
	jp	.l00116
.l00160:
	jp	_Paste
.l00116:
;src/editor/editor.c:576: }
	ret
;src/editor/editor.c:579: static void HandleKey(unsigned char key, unsigned char mods) {
;	---------------------------------
; Function HandleKey
; ---------------------------------
_HandleKey:
	add	sp, -3
	ld	hl, sp+2
	ld	[hl], a
	dec	hl
	ld	[hl], e
;src/editor/editor.c:580: unsigned char ctrl = mods & KB_MOD_CTRL, c;
	ld	a, [hl]
	and	a, $20
	dec	hl
	ld	[hl], a
;src/editor/editor.c:581: if (mods & (KB_MOD_ALT | KB_MOD_SUPER)) return;
	inc	hl
	ld	a, [hl]
	and	a, $18
	jp	NZ,.l00342
	jp	.l00102
.l00342:
	jp	.l00168
.l00102:
;src/editor/editor.c:582: if (key < KEY_LEFT || key > KEY_PAGE_DOWN) {
	ld	hl, sp+2
	ld	a, [hl]
	sub	a, $80
	ld	a, $00
	rla
	ld	c, a
	ld	a, c
	or	a, a
	jp	NZ, .l00116
	ld	a, $87
	sub	a, [hl]
	jp	NC, .l00117
.l00116:
;src/editor/editor.c:583: if (ctrl) {
	ld	hl, sp+0
	ld	a, [hl]
	or	a, a
	jp	Z, .l00118
;src/editor/editor.c:584: HandleCtrlKey(key);
	inc	hl
	inc	hl
	ld	a, [hl]
	call	_HandleCtrlKey
;src/editor/editor.c:585: return;
	jp	.l00168
.l00117:
;src/editor/editor.c:588: else if (mods & KB_MOD_SHIFT) { // shift + movement selects
	push	hl
	ld	hl, sp+3
	bit	6, [hl]
	pop	hl
	jp	NZ,.l00343
	jp	.l00114
.l00343:
;src/editor/editor.c:589: if (!selecting) anchor = cursor;
	ld	hl, _selecting
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00106
	ld	hl, _cursor
	ld	a, [hl]
	ld	hl, _anchor
	ld	[hl], a
	ld	hl, _cursor + 1
	ld	a, [hl]
	ld	hl, _anchor + 1
	ld	[hl], a
.l00106:
;src/editor/editor.c:590: selecting = 1;
	ld	hl, _selecting
	ld	[hl], $01
;src/editor/editor.c:591: redraw = 1;
	ld	hl, _redraw
	ld	[hl], $01
	jp	.l00118
.l00114:
;src/editor/editor.c:593: else if (!ctrl && GetSelection() && (key == KEY_LEFT || key == KEY_RIGHT)) { // to that end of the selection
	ld	hl, sp+0
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00108
	push	bc
	call	_GetSelection
	pop	bc
	or	a, a
	jp	Z, .l00108
	ld	hl, sp+2
	ld	a, [hl]
	sub	a, $80
	jp	NZ,.l00344
	ld	a,$01
	jp	.l00345
.l00344:
	xor	a,a
.l00345:
	ld	e, a
	ld	a, e
	or	a, a
	jp	NZ, .l00107
	ld	hl, sp+2
	ld	a, [hl]
	sub	a, $81
	jp	NZ,.l00346
	jp	.l00347
.l00346:
	jp	.l00108
.l00347:
.l00107:
;src/editor/editor.c:594: cursor = key == KEY_LEFT ? sel_start : sel_end;
	ld	a, e
	or	a, a
	jp	Z, .l00170
	ld	hl, _sel_start
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	jp	.l00171
.l00170:
	ld	hl, _sel_end
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
.l00171:
	ld	hl, _cursor
	ld	[hl], c
	inc	hl
	ld	[hl], b
;src/editor/editor.c:595: ClearSelection();
	call	_ClearSelection
;src/editor/editor.c:596: moved = 1;
	ld	hl, _moved
	ld	[hl], $01
;src/editor/editor.c:597: return;
	jp	.l00168
.l00108:
;src/editor/editor.c:599: else ClearSelection();
	push	bc
	call	_ClearSelection
	pop	bc
.l00118:
;src/editor/editor.c:600: moved = 1;
	ld	hl, _moved
	ld	[hl], $01
;src/editor/editor.c:601: if (ctrl) {
	ld	hl, sp+0
	ld	a, [hl]
	or	a, a
	jp	Z, .l00128
;src/editor/editor.c:602: switch (key) {
	inc	hl
	inc	hl
	ld	a, [hl]
	sub	a, $80
	jp	NZ,.l00348
	jp	.l00120
.l00348:
	ld	hl, sp+2
	ld	a, [hl]
	sub	a, $81
	jp	NZ,.l00349
	jp	.l00121
.l00349:
	ld	hl, sp+2
	ld	a, [hl]
	sub	a, $82
	jp	NZ,.l00350
	jp	.l00122
.l00350:
	ld	hl, sp+2
	ld	a, [hl]
	sub	a, $83
	jp	NZ,.l00351
	jp	.l00123
.l00351:
	ld	hl, sp+2
	ld	a, [hl]
	sub	a, $84
	jp	NZ,.l00352
	jp	.l00124
.l00352:
	ld	hl, sp+2
	ld	a, [hl]
	sub	a, $85
	jp	NZ,.l00353
	jp	.l00125
.l00353:
	jp	.l00128
;src/editor/editor.c:603: case KEY_LEFT: WordLeft(); return;
.l00120:
	call	_WordLeft
	jp	.l00168
;src/editor/editor.c:604: case KEY_RIGHT: WordRight(); return;
.l00121:
	call	_WordRight
	jp	.l00168
;src/editor/editor.c:605: case KEY_UP: ScrollLine(0); return;
.l00122:
	xor	a, a
	call	_ScrollLine
	jp	.l00168
;src/editor/editor.c:606: case KEY_DOWN: ScrollLine(1); return;
.l00123:
	ld	a, $01
	call	_ScrollLine
	jp	.l00168
;src/editor/editor.c:607: case KEY_HOME: cursor = 0; return;
.l00124:
	xor	a, a
	ld	hl, _cursor
	ld	[hl], a
	inc	hl
	ld	[hl], a
	jp	.l00168
;src/editor/editor.c:608: case KEY_END: cursor = tb_Length(); return;
.l00125:
	call	_tb_Length
	ld	hl, _cursor
	ld	[hl], c
	inc	hl
	ld	[hl], b
	jp	.l00168
;src/editor/editor.c:609: }
.l00128:
;src/editor/editor.c:611: switch (key) {
	ld	a, c
	or	a, a
	jp	NZ, .l00141
	ld	a, $87
	ld	hl, sp+2
	sub	a, [hl]
	jp	C, .l00141
	ld	a, [hl]
	add	a, $80
	ld	c, a
	ld	b, $00
	ld	hl, .l00354
	add	hl, bc
	add	hl, bc
	add	hl, bc
	jp	hl
.l00354:
	jp	.l00133
	jp	.l00136
	jp	.l00129
	jp	.l00130
	jp	.l00139
	jp	.l00140
	jp	.l00131
	jp	.l00132
;src/editor/editor.c:612: case KEY_UP: MoveUp(); return;
.l00129:
	call	_MoveUp
	jp	.l00168
;src/editor/editor.c:613: case KEY_DOWN: MoveDown(); return;
.l00130:
	call	_MoveDown
	jp	.l00168
;src/editor/editor.c:614: case KEY_PAGE_UP: PageUp(); return;
.l00131:
	call	_PageUp
	jp	.l00168
;src/editor/editor.c:615: case KEY_PAGE_DOWN: PageDown(); return;
.l00132:
	call	_PageDown
	jp	.l00168
;src/editor/editor.c:616: case KEY_LEFT: if (cursor) --cursor; return;
.l00133:
	ld	hl, _cursor + 1
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	jp	Z, .l00135
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
.l00135:
	jp	.l00168
;src/editor/editor.c:617: case KEY_RIGHT: if (cursor != tb_Length()) ++cursor; return;
.l00136:
	call	_tb_Length
	ld	hl, _cursor
	ld	a, [hl]
	sub	a, c
	jp	NZ,.l00355
	inc	hl
	ld	a, [hl]
	sub	a, b
	jp	NZ,.l00355
	jp	.l00138
.l00355:
	ld	hl, _cursor
	inc	[hl]
	jp	NZ, .l00356
	inc	hl
	inc	[hl]
.l00356:
.l00138:
	jp	.l00168
;src/editor/editor.c:618: case KEY_HOME: cursor = tb_row_starts[tb_found_row]; return;
.l00139:
	ld	hl, _tb_found_row
	ld	l, [hl]
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
	ld	hl, _cursor
	ld	[hl], a
	inc	de
	ld	a, [de]
	inc	hl
	ld	[hl], a
	jp	.l00168
;src/editor/editor.c:619: case KEY_END: MoveEnd(); return;
.l00140:
	call	_MoveEnd
	jp	.l00168
;src/editor/editor.c:620: }
.l00141:
;src/editor/editor.c:621: moved = 0;
	ld	hl, _moved
	ld	[hl], $00
;src/editor/editor.c:622: if (key == KEY_ESCAPE || key == KEY_INSERT) return;
	ld	hl, sp+2
	ld	a, [hl]
	sub	a, $1B
	jp	NZ,.l00357
	jp	.l00142
.l00357:
	ld	hl, sp+2
	ld	a, [hl]
	sub	a, $88
	jp	NZ,.l00358
	jp	.l00359
.l00358:
	jp	.l00143
.l00359:
.l00142:
	jp	.l00168
.l00143:
;src/editor/editor.c:623: if (GetSelection()) { // typing replaces the selection
	call	_GetSelection
	or	a, a
	jp	Z, .l00149
;src/editor/editor.c:624: DeleteSelection();
	call	_DeleteSelection
;src/editor/editor.c:625: if (key == KEY_BACKSPACE || key == KEY_DELETE) return;
	ld	hl, sp+2
	ld	a, [hl]
	sub	a, $08
	jp	NZ,.l00360
	jp	.l00145
.l00360:
	ld	hl, sp+2
	ld	a, [hl]
	sub	a, $7F
	jp	NZ,.l00361
	jp	.l00362
.l00361:
	jp	.l00149
.l00362:
.l00145:
	jp	.l00168
.l00149:
;src/editor/editor.c:627: selecting = 0;
	ld	hl, _selecting
	ld	[hl], $00
;src/editor/editor.c:628: switch (key) {
	ld	hl, sp+2
	ld	a, [hl]
	sub	a, $08
	jp	NZ,.l00363
	jp	.l00150
.l00363:
	ld	hl, sp+2
	ld	a, [hl]
	sub	a, $7F
	jp	NZ,.l00364
	jp	.l00154
.l00364:
	jp	.l00157
;src/editor/editor.c:629: case KEY_BACKSPACE:
.l00150:
;src/editor/editor.c:630: if (cursor && (c = tb_Delete(cursor - 1))) {
	ld	hl, _cursor + 1
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	jp	Z, .l00168
	inc	hl
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	dec	de
	call	_tb_Delete
	ld	c, a
	or	a, a
	jp	Z, .l00168
;src/editor/editor.c:631: CountEdit(cursor - 1, c, 0);
	ld	hl, _cursor + 1
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	dec	de
	xor	a, a
	push	af
	inc	sp
	ld	a, c
	call	_CountEdit
;src/editor/editor.c:632: Edited(--cursor, -1);
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
	ld	a, $FF
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_Edited
;src/editor/editor.c:634: break;
	jp	.l00168
;src/editor/editor.c:635: case KEY_DELETE:
.l00154:
;src/editor/editor.c:636: if ((c = tb_Delete(cursor))) {
	ld	hl, _cursor
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_tb_Delete
	ld	c, a
	or	a, a
	jp	Z, .l00168
;src/editor/editor.c:637: CountEdit(cursor, c, 0);
	xor	a, a
	push	af
	inc	sp
	ld	a, c
	ld	hl, _cursor
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_CountEdit
;src/editor/editor.c:638: Edited(cursor, -1);
	ld	a, $FF
	ld	hl, _cursor
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_Edited
;src/editor/editor.c:640: break;
	jp	.l00168
;src/editor/editor.c:641: default:
.l00157:
;src/editor/editor.c:642: if (key < ' ' && key != ASCII_TAB && key != ASCII_LF) return;
	ld	hl, sp+2
	ld	a, [hl]
	sub	a, $20
	jp	NC, .l00159
	ld	a, [hl]
	sub	a, $09
	jp	NZ,.l00365
	jp	.l00159
.l00365:
	ld	hl, sp+2
	ld	a, [hl]
	sub	a, $0A
	jp	NZ,.l00366
	jp	.l00159
.l00366:
	jp	.l00168
.l00159:
;src/editor/editor.c:643: if (key >= KEY_LEFT && key < 0xA0) return; // unprintable in Latin-1
	ld	hl, sp+2
	ld	a, [hl]
	sub	a, $80
	jp	C, .l00163
	ld	a, [hl]
	sub	a, $A0
	jp	NC, .l00163
	jp	.l00168
.l00163:
;src/editor/editor.c:644: if (tb_Insert(cursor, key)) {
	ld	hl, sp+2
	ld	a, [hl]
	ld	hl, _cursor
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_tb_Insert
	or	a, a
	jp	Z, .l00168
;src/editor/editor.c:645: CountEdit(cursor, key, 1);
	ld	a, $01
	push	af
	inc	sp
	ld	hl, sp+3
	ld	a, [hl]
	ld	hl, _cursor
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_CountEdit
;src/editor/editor.c:646: Edited(cursor++, 1);
	ld	hl, _cursor
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	dec	hl
	inc	[hl]
	jp	NZ, .l00367
	inc	hl
	inc	[hl]
.l00367:
	ld	a, $01
	call	_Edited
;src/editor/editor.c:648: }
.l00168:
;src/editor/editor.c:649: }
	add	sp, 3
	ret
;src/editor/editor.c:652: static unsigned char DpadRepeat(unsigned char pressed) {
;	---------------------------------
; Function DpadRepeat
; ---------------------------------
_DpadRepeat:
	ld	c, a
;src/editor/editor.c:653: unsigned char held = (button_state | pressed) & PADF_DPAD;
	ld	hl, _button_state
	ld	a, [hl]
	or	a, c
	and	a, $F0
	ld	b, a
;src/editor/editor.c:654: if (!held) return 0;
	or	a, a
	jp	NZ, .l00102
	xor	a, a
	jp	.l00109
.l00102:
;src/editor/editor.c:655: if (pressed & PADF_DPAD) pad_timer = PAD_REPEAT_DELAY;
	ld	a, c
	and	a, $F0
	jp	NZ,.l00126
	jp	.l00107
.l00126:
	ld	hl, _pad_timer
	ld	[hl], $14
	jp	.l00108
.l00107:
;src/editor/editor.c:656: else if (--pad_timer) return 0;
	ld	hl, _pad_timer
	dec	[hl]
	ld	a, [hl]
	or	a, a
	jp	Z, .l00104
	xor	a, a
	jp	.l00109
.l00104:
;src/editor/editor.c:657: else pad_timer = PAD_REPEAT_RATE;
	ld	hl, _pad_timer
	ld	[hl], $04
.l00108:
;src/editor/editor.c:658: return held;
	ld	a, b
.l00109:
;src/editor/editor.c:659: }
	ret
;src/editor/editor.c:662: static void SetRows(void) {
;	---------------------------------
; Function SetRows
; ---------------------------------
_SetRows:
;src/editor/editor.c:663: bars = bars_on;
	ld	hl, _bars_on
	ld	a, [hl]
	ld	hl, _bars
	ld	[hl], a
;src/editor/editor.c:664: tb_rows = TextRows();
	call	_TextRows
	ld	hl, _tb_rows
	ld	[hl], a
;src/editor/editor.c:665: Layout();
	call	_Layout
;src/editor/editor.c:666: if (osk_shown) {
	ld	hl, _osk_shown
	ld	a, [hl]
	or	a, a
	jp	Z, .l00102
;src/editor/editor.c:667: OSKDraw(osk_layer, tb_rows);
	ld	hl, _tb_rows
	ld	e, [hl]
	ld	hl, _osk_layer
	ld	a, [hl]
	call	_OSKDraw
;src/editor/editor.c:668: OSKSelect(osk_x, osk_y);
	ld	hl, _osk_y
	ld	e, [hl]
	ld	hl, _osk_x
	ld	a, [hl]
	call	_OSKSelect
.l00102:
;src/editor/editor.c:670: OSKShow(osk_shown);
	ld	hl, _osk_shown
	ld	a, [hl]
	call	_OSKShow
;src/editor/editor.c:671: dirty = 1;
	ld	hl, _dirty
	ld	[hl], $01
.l00103:
;src/editor/editor.c:672: }
	ret
;src/editor/editor.c:674: static void ToggleOSK(void) {
;	---------------------------------
; Function ToggleOSK
; ---------------------------------
_ToggleOSK:
;src/editor/editor.c:675: osk_shown = !osk_shown;
	ld	hl, _osk_shown
	ld	a, [hl]
	sub	a,$01
	ld	a, $00
	rla
	ld	[hl], a
;src/editor/editor.c:676: SetRows();
	jp	_SetRows
.l00101:
;src/editor/editor.c:677: }
	ret
;src/editor/editor.c:680: static void ToggleBars(void) {
;	---------------------------------
; Function ToggleBars
; ---------------------------------
_ToggleBars:
;src/editor/editor.c:681: bars_on = !bars_on;
	ld	hl, _bars_on
	ld	a, [hl]
	sub	a,$01
	ld	a, $00
	rla
	ld	[hl], a
;src/editor/editor.c:682: SetRows();
	jp	_SetRows
.l00101:
;src/editor/editor.c:683: }
	ret
;src/editor/editor.c:685: static void SetOSKLayer(unsigned char layer) {
;	---------------------------------
; Function SetOSKLayer
; ---------------------------------
_SetOSKLayer:
	ld	c, a
;src/editor/editor.c:686: osk_layer = osk_layer == layer ? OSK_LOWER : layer;
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
;src/editor/editor.c:687: OSKDraw(osk_layer, tb_rows);
	ld	hl, _tb_rows
	ld	e, [hl]
	ld	hl, _osk_layer
	ld	a, [hl]
	call	_OSKDraw
;src/editor/editor.c:688: dirty = 1;
	ld	hl, _dirty
	ld	[hl], $01
.l00101:
;src/editor/editor.c:689: }
	ret
;src/editor/editor.c:691: static unsigned char PressOSKKey(void) {
;	---------------------------------
; Function PressOSKKey
; ---------------------------------
_PressOSKKey:
;src/editor/editor.c:693: if (osk_y == OSK_ROWS - 1) {
	ld	hl, _osk_y
	ld	a, [hl]
	sub	a, $04
	jp	NZ,.l00157
	jp	.l00158
.l00157:
	jp	.l00117
.l00158:
;src/editor/editor.c:694: if (osk_x == 0) SetOSKLayer(OSK_SHIFT);
	ld	hl, _osk_x
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00114
	ld	a, $01
	call	_SetOSKLayer
	jp	.l00115
.l00114:
;src/editor/editor.c:695: else if (osk_x == 1) SetOSKLayer(OSK_SYMBOLS);
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
;src/editor/editor.c:696: else if (osk_x == OSK_COLS - 3) return KEY_MENU;
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
;src/editor/editor.c:697: else if (osk_x == OSK_COLS - 2) return KEY_LEFT;
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
;src/editor/editor.c:698: else if (osk_x == OSK_COLS - 1) return KEY_RIGHT;
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
;src/editor/editor.c:699: else return ' ';
	ld	a, $20
	jp	.l00120
.l00115:
;src/editor/editor.c:700: return KEY_NONE;
	xor	a, a
	jp	.l00120
.l00117:
;src/editor/editor.c:702: key = OSKGetKey(osk_layer, (osk_y << 3) + (osk_y << 1) + osk_x);
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
;src/editor/editor.c:703: if (osk_layer == OSK_SHIFT) SetOSKLayer(OSK_SHIFT); // shift is one shot
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
;src/editor/editor.c:704: return key;
	ld	a, c
.l00120:
;src/editor/editor.c:705: }
	ret
;src/editor/editor.c:707: static void MoveOSKSelection(unsigned char held) {
;	---------------------------------
; Function MoveOSKSelection
; ---------------------------------
_MoveOSKSelection:
	ld	c, a
;src/editor/editor.c:708: if (held & PADF_UP) osk_y = osk_y ? osk_y - 1 : OSK_ROWS - 1;
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
;src/editor/editor.c:709: else if (held & PADF_DOWN) osk_y = osk_y == OSK_ROWS - 1 ? 0 : osk_y + 1;
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
;src/editor/editor.c:710: if (held & PADF_LEFT) osk_x = osk_x ? osk_x - 1 : OSK_COLS - 1;
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
;src/editor/editor.c:711: else if (held & PADF_RIGHT) osk_x = osk_x == OSK_COLS - 1 ? 0 : osk_x + 1;
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
;src/editor/editor.c:712: OSKSelect(osk_x, osk_y);
	ld	hl, _osk_y
	ld	e, [hl]
	ld	hl, _osk_x
	ld	a, [hl]
	jp	_OSKSelect
.l00111:
;src/editor/editor.c:713: }
	ret
;src/editor/editor.c:717: static unsigned char PadKey(void) {
;	---------------------------------
; Function PadKey
; ---------------------------------
_PadKey:
;src/editor/editor.c:718: unsigned char pressed = PadPressed();
	call	_PadPressed
	ld	c, a
;src/editor/editor.c:720: if (pressed & PADF_SELECT) ToggleOSK();
	bit	2, c
	jp	NZ,.l00172
	jp	.l00102
.l00172:
	push	bc
	call	_ToggleOSK
	pop	bc
.l00102:
;src/editor/editor.c:721: if (pressed & PADF_B) return KEY_BACKSPACE;
	bit	1, c
	jp	NZ,.l00173
	jp	.l00104
.l00173:
	ld	a, $08
	jp	.l00120
.l00104:
;src/editor/editor.c:722: if (pressed & PADF_START) return KEY_ENTER;
	bit	3, c
	jp	NZ,.l00174
	jp	.l00106
.l00174:
	ld	a, $0A
	jp	.l00120
.l00106:
;src/editor/editor.c:723: if (osk_shown && (pressed & PADF_A)) return PressOSKKey();
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
;src/editor/editor.c:724: held = DpadRepeat(pressed);
	ld	a, c
	call	_DpadRepeat
	ld	c, a
;src/editor/editor.c:725: if (!held) return KEY_NONE;
	ld	a, c
	or	a, a
	jp	NZ, .l00111
	xor	a, a
	jp	.l00120
.l00111:
;src/editor/editor.c:726: if (osk_shown) {
	ld	hl, _osk_shown
	ld	a, [hl]
	or	a, a
	jp	Z, .l00113
;src/editor/editor.c:727: MoveOSKSelection(held);
	ld	a, c
	call	_MoveOSKSelection
;src/editor/editor.c:728: return KEY_NONE;
	xor	a, a
	jp	.l00120
.l00113:
;src/editor/editor.c:730: if (held & PADF_UP) return KEY_UP;
	bit	6, c
	jp	NZ,.l00176
	jp	.l00115
.l00176:
	ld	a, $82
	jp	.l00120
.l00115:
;src/editor/editor.c:731: if (held & PADF_DOWN) return KEY_DOWN;
	bit	7, c
	jp	NZ,.l00177
	jp	.l00117
.l00177:
	ld	a, $83
	jp	.l00120
.l00117:
;src/editor/editor.c:732: if (held & PADF_LEFT) return KEY_LEFT;
	bit	5, c
	jp	NZ,.l00178
	jp	.l00119
.l00178:
	ld	a, $80
	jp	.l00120
.l00119:
;src/editor/editor.c:733: return KEY_RIGHT;
	ld	a, $81
.l00120:
;src/editor/editor.c:734: }
	ret
;src/editor/editor.c:737: static unsigned char MenuKey(void) {
;	---------------------------------
; Function MenuKey
; ---------------------------------
_MenuKey:
;src/editor/editor.c:739: WaitFrame();
	call	_WaitFrame
;src/editor/editor.c:740: if ((key = (unsigned char)KBPopEvent())) return key;
	call	_KBPopEvent
	ld	a, c
	ld	c, a
	or	a, a
	jp	Z, .l00102
	ld	a, c
	jp	.l00111
.l00102:
;src/editor/editor.c:741: pressed = PadPressed();
	call	_PadPressed
	ld	c, a
;src/editor/editor.c:742: if (pressed & (PADF_A | PADF_START)) return KEY_ENTER;
	ld	a, c
	and	a, $09
	jp	NZ,.l00138
	jp	.l00104
.l00138:
	ld	a, $0A
	jp	.l00111
.l00104:
;src/editor/editor.c:743: if (pressed & PADF_B) return KEY_ESCAPE;
	bit	1, c
	jp	NZ,.l00139
	jp	.l00106
.l00139:
	ld	a, $1B
	jp	.l00111
.l00106:
;src/editor/editor.c:744: held = DpadRepeat(pressed);
	ld	a, c
	call	_DpadRepeat
;src/editor/editor.c:745: if (held & PADF_UP) return KEY_UP;
	bit	6, a
	jp	NZ,.l00140
	jp	.l00108
.l00140:
	ld	a, $82
	jp	.l00111
.l00108:
;src/editor/editor.c:746: if (held & PADF_DOWN) return KEY_DOWN;
	rlca
	jp	C,.l00141
	jp	.l00110
.l00141:
	ld	a, $83
	jp	.l00111
.l00110:
;src/editor/editor.c:747: return KEY_NONE;
	xor	a, a
.l00111:
;src/editor/editor.c:748: }
	ret
;src/editor/editor.c:750: static char* RowAddress(unsigned char row) {
;	---------------------------------
; Function RowAddress
; ---------------------------------
_RowAddress:
	ld	e, a
;src/editor/editor.c:751: unsigned int offset = row;
	ld	d, $00
;src/editor/editor.c:752: return (char*)tile_buffer + (offset << 5) + (offset << 3); // row * TB_STRIDE
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
;src/editor/editor.c:753: }
	ret
;src/editor/editor.c:756: static void DrawRow(unsigned char row, unsigned char col, const char* text) {
;	---------------------------------
; Function DrawRow
; ---------------------------------
_DrawRow:
	dec	sp
	dec	sp
	ld	c, a
	ld	hl, sp+1
	ld	[hl], e
;src/editor/editor.c:757: char* dest = RowAddress(row);
	ld	a, c
	call	_RowAddress
;src/editor/editor.c:759: for (i = 0; i < TB_STRIDE; ++i) dest[i] = ' ';
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
;src/editor/editor.c:760: for (dest += col; *text && col < TB_STRIDE; ++col) *dest++ = *text++;
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
;src/editor/editor.c:761: }
	inc	sp
	inc	sp
	pop	hl
	inc	sp
	inc	sp
	jp hl 
;src/editor/editor.c:763: static void ClearScreen(void) {
;	---------------------------------
; Function ClearScreen
; ---------------------------------
_ClearScreen:
;src/editor/editor.c:765: for (row = 0; row < TB_ROWS; ++row) DrawRow(row, 0, "");
	ld	c, $00
.l00102:
	push	bc
	ld	de, ___str_31
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
;src/editor/editor.c:766: }
	ret
___str_31:
	DB $00
;src/editor/editor.c:769: static void BeginFullScreen(void) {
;	---------------------------------
; Function BeginFullScreen
; ---------------------------------
_BeginFullScreen:
;src/editor/editor.c:770: EditorShowCursor(0);
	xor	a, a
	call	_EditorShowCursor
;src/editor/editor.c:771: if (osk_shown) OSKShow(0);
	ld	hl, _osk_shown
	ld	a, [hl]
	or	a, a
	jp	Z, .l00102
	xor	a, a
	call	_OSKShow
.l00102:
;src/editor/editor.c:772: bars = 0;
	ld	hl, _bars
	ld	[hl], $00
;src/editor/editor.c:773: tb_rows = TB_ROWS;
	ld	hl, _tb_rows
	ld	[hl], $12
;src/editor/editor.c:774: Layout();
	call	_Layout
;src/editor/editor.c:775: NoHighlight();
	call	_NoHighlight
;src/editor/editor.c:776: dirty = 1;
	ld	hl, _dirty
	ld	[hl], $01
.l00103:
;src/editor/editor.c:777: }
	ret
;src/editor/editor.c:779: static void EndFullScreen(void) {
;	---------------------------------
; Function EndFullScreen
; ---------------------------------
_EndFullScreen:
;src/editor/editor.c:780: SetRows();
	jp	_SetRows
.l00101:
;src/editor/editor.c:781: }
	ret
;src/editor/editor.c:784: static unsigned char Choose(const char* title, const char* items, unsigned char count) {
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
;src/editor/editor.c:785: unsigned char i, key, selected = 0;
	ld	hl, sp+0
	ld	[hl], $00
;src/editor/editor.c:786: BeginFullScreen();
	call	_BeginFullScreen
;src/editor/editor.c:787: while (1) {
.l00119:
;src/editor/editor.c:788: ClearScreen();
	call	_ClearScreen
;src/editor/editor.c:789: DrawRow(0, 0, title);
	ld	hl, sp+9
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	push	de
	ld	e, $00
	xor	a, a
	call	_DrawRow
;src/editor/editor.c:790: for (i = 0; i < count; ++i) {
	ld	hl, sp+11
	ld	[hl], $00
.l00122:
	ld	hl, sp+11
	ld	a, [hl]
	ld	hl, sp+14
	sub	a, [hl]
	jp	NC, .l00103
;src/editor/editor.c:791: DrawRow(i + 2, 2, items + (i << 3) + (i << 2) + i); // i * FILE_NAME_SIZE
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
;src/editor/editor.c:792: if (i == selected) RowAddress(i + 2)[1] = MARKER;
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
;src/editor/editor.c:790: for (i = 0; i < count; ++i) {
	ld	hl, sp+11
	inc	[hl]
	jp	.l00122
.l00103:
;src/editor/editor.c:794: EditorDraw();
	call	_EditorDraw
;src/editor/editor.c:795: while (!(key = MenuKey()));
.l00104:
	call	_MenuKey
	ld	c, a
	or	a, a
	jp	Z, .l00104
;src/editor/editor.c:796: if (key == KEY_UP) selected = selected ? selected - 1 : count - 1;
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
;src/editor/editor.c:797: else if (key == KEY_DOWN) selected = selected == count - 1 ? 0 : selected + 1;
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
;src/editor/editor.c:798: else if (key == KEY_ENTER) break;
	ld	a, c
	sub	a, $0A
	jp	NZ,.l00201
	jp	.l00120
.l00201:
;src/editor/editor.c:799: else if (key == KEY_ESCAPE) {
	ld	a, c
	sub	a, $1B
	jp	NZ,.l00202
	jp	.l00203
.l00202:
	jp	.l00119
.l00203:
;src/editor/editor.c:800: selected = CANCEL;
	ld	hl, sp+0
	ld	[hl], $FF
;src/editor/editor.c:801: break;
.l00120:
;src/editor/editor.c:804: EndFullScreen();
	call	_EndFullScreen
;src/editor/editor.c:805: return selected;
	ld	hl, sp+0
	ld	a, [hl]
.l00124:
;src/editor/editor.c:806: }
	add	sp, 12
	pop	hl
	inc	sp
	jp hl 
;src/editor/editor.c:809: static void ShowMessage(const char* text) {
;	---------------------------------
; Function ShowMessage
; ---------------------------------
_ShowMessage:
;src/editor/editor.c:810: Render();
	push	de
	call	_Render
	pop	de
;src/editor/editor.c:811: EditorShowCursor(0);
	push	de
	xor	a, a
	call	_EditorShowCursor
	pop	de
;src/editor/editor.c:812: NoHighlight();
	push	de
	call	_NoHighlight
	pop	de
;src/editor/editor.c:813: if (bars) {
	ld	hl, _bars
	ld	a, [hl]
	or	a, a
	jp	Z, .l00102
;src/editor/editor.c:814: UpdateBars();
	push	de
	call	_UpdateBars
	pop	de
;src/editor/editor.c:815: DrawRow(STATUS_LINE, 1, text);
	push	de
	ld	e, $01
	ld	a, $13
	call	_DrawRow
	jp	.l00103
.l00102:
;src/editor/editor.c:817: else DrawRow(tb_rows - 1, 0, text);
	ld	hl, _tb_rows
	ld	c, [hl]
	dec	c
	push	de
	ld	e, $00
	ld	a, c
	call	_DrawRow
.l00103:
;src/editor/editor.c:818: EditorDraw();
	call	_EditorDraw
;src/editor/editor.c:819: while (!MenuKey());
.l00104:
	call	_MenuKey
	or	a, a
	jp	Z, .l00104
;src/editor/editor.c:820: dirty = 1;
	ld	hl, _dirty
	ld	[hl], $01
.l00107:
;src/editor/editor.c:821: }
	ret
;src/editor/editor.c:823: static void ShowError(unsigned char result, const char* denied) {
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
;src/editor/editor.c:824: char text[12] = "SD ERROR ";
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
;src/editor/editor.c:825: if (result == FR_NOT_READY) ShowMessage("NO SD CARD");
	ld	hl, sp+16
	ld	a, [hl]
	sub	a, $03
	jp	NZ,.l00140
	jp	.l00141
.l00140:
	jp	.l00111
.l00141:
	ld	de, ___str_33
	call	_ShowMessage
	jp	.l00113
.l00111:
;src/editor/editor.c:826: else if (result == FR_NO_FILESYSTEM) ShowMessage("NO FAT VOLUME");
	ld	hl, sp+16
	ld	a, [hl]
	sub	a, $0D
	jp	NZ,.l00142
	jp	.l00143
.l00142:
	jp	.l00108
.l00143:
	ld	de, ___str_34
	call	_ShowMessage
	jp	.l00113
.l00108:
;src/editor/editor.c:827: else if (result == FR_DENIED) ShowMessage(denied);
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
;src/editor/editor.c:829: text[9] = '0';
	ld	hl, sp+9
	ld	[hl], $30
;src/editor/editor.c:830: while (result >= 10) {
.l00101:
;src/editor/editor.c:832: result -= 10;
	ld	hl, sp+16
	ld	a, [hl]
	ld	hl, sp+12
	ld	[hl], a
;src/editor/editor.c:830: while (result >= 10) {
	ld	hl, sp+16
	ld	a, [hl]
	sub	a, $0A
	jp	C, .l00103
;src/editor/editor.c:831: ++text[9];
	ld	hl, sp+9
	ld	a, [hl]
	ld	hl, sp+13
	ld	[hl], a
	ld	a, [hl]
	inc	a
	ld	hl, sp+9
	ld	[hl], a
;src/editor/editor.c:832: result -= 10;
	ld	hl, sp+12
	ld	a, [hl]
	add	a, $F6
	ld	hl, sp+16
	ld	[hl], a
	jp	.l00101
.l00103:
;src/editor/editor.c:834: text[10] = '0' + result;
	ld	hl, sp+12
	ld	a, [hl]
	add	a, $30
	dec	hl
	dec	hl
	ld	[hl], a
;src/editor/editor.c:835: text[11] = 0;
	inc	hl
	ld	[hl], $00
;src/editor/editor.c:836: ShowMessage(text);
	ld	hl, 0
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_ShowMessage
.l00113:
;src/editor/editor.c:838: }
	add	sp, 17
	ret
___str_33:
	DB "NO SD CARD"
	DB $00
___str_34:
	DB "NO FAT VOLUME"
	DB $00
;src/editor/editor.c:840: static void CopyName(char* dest, const char* src) {
;	---------------------------------
; Function CopyName
; ---------------------------------
_CopyName:
;src/editor/editor.c:841: while ((*dest++ = *src++));
.l00101:
	ld	a, [bc]
	inc	bc
	ld	[de], a
	inc	de
	or	a, a
	jp	NZ, .l00101
.l00104:
;src/editor/editor.c:842: }
	ret
;src/editor/editor.c:845: static unsigned char CanDiscard(void) {
;	---------------------------------
; Function CanDiscard
; ---------------------------------
_CanDiscard:
;src/editor/editor.c:846: return !modified || Choose("DISCARD CHANGES?", discard_items[0], 2) == 1;
	ld	hl, _modified
	ld	a, [hl]
	or	a, a
	jp	Z, .l00104
	ld	a, $02
	push	af
	inc	sp
	ld	bc, _discard_items
	ld	de, ___str_35
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
;src/editor/editor.c:847: }
	ret
___str_35:
	DB "DISCARD CHANGES?"
	DB $00
;src/editor/editor.c:849: static void ResetCursor(void) {
;	---------------------------------
; Function ResetCursor
; ---------------------------------
_ResetCursor:
;src/editor/editor.c:850: cursor = 0;
	xor	a, a
	ld	hl, _cursor
	ld	[hl], a
	inc	hl
	ld	[hl], a
;src/editor/editor.c:851: counted_pos = 0;
	xor	a, a
	ld	hl, _counted_pos
	ld	[hl], a
	inc	hl
	ld	[hl], a
;src/editor/editor.c:852: counted_lines = 0;
	xor	a, a
	ld	hl, _counted_lines
	ld	[hl], a
	inc	hl
	ld	[hl], a
;src/editor/editor.c:853: selecting = 0;
	ld	hl, _selecting
	ld	[hl], $00
;src/editor/editor.c:854: top = 0;
	xor	a, a
	ld	hl, _top
	ld	[hl], a
	inc	hl
	ld	[hl], a
;src/editor/editor.c:855: want_x = 0;
	ld	hl, _want_x
	ld	[hl], $00
;src/editor/editor.c:856: modified = 0;
	ld	hl, _modified
	ld	[hl], $00
;src/editor/editor.c:857: dirty = 1;
	ld	hl, _dirty
	ld	[hl], $01
.l00101:
;src/editor/editor.c:858: }
	ret
;src/editor/editor.c:860: static void NewFile(void) {
;	---------------------------------
; Function NewFile
; ---------------------------------
_NewFile:
;src/editor/editor.c:861: if (!CanDiscard()) return;
	call	_CanDiscard
	or	a, a
	jp	NZ, .l00102
	jp	.l00103
.l00102:
;src/editor/editor.c:862: tb_Clear();
	call	_tb_Clear
;src/editor/editor.c:863: file_name[0] = 0;
	ld	hl, _file_name
	ld	[hl], $00
;src/editor/editor.c:864: fs_crlf = 0;
	ld	hl, _fs_crlf
	ld	[hl], $00
;src/editor/editor.c:865: ResetCursor();
	jp	_ResetCursor
.l00103:
;src/editor/editor.c:866: }
	ret
;src/editor/editor.c:868: static void OpenFile(void) {
;	---------------------------------
; Function OpenFile
; ---------------------------------
_OpenFile:
	dec	sp
;src/editor/editor.c:870: if (!CanDiscard()) return;
	call	_CanDiscard
	ld	c, a
	ld	a, c
	or	a, a
	jp	NZ, .l00102
	jp	.l00116
.l00102:
;src/editor/editor.c:871: if ((result = FileMount()) || (result = FileOpenDir())) {
	call	_FileMount
	ld	c, a
	or	a, a
	jp	NZ, .l00103
	call	_FileOpenDir
	ld	c, a
	or	a, a
	jp	Z, .l00122
.l00103:
;src/editor/editor.c:872: ShowError(result, "");
	ld	de, ___str_36
	ld	a, c
	inc	sp
	jp	_ShowError
;src/editor/editor.c:873: return;
	jp	.l00116
;src/editor/editor.c:875: while (count < FILE_LIST_MAX && FileNext(file_list[count])) ++count;
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
;src/editor/editor.c:876: if (!count) {
	ld	a, c
	or	a, a
	jp	NZ, .l00111
;src/editor/editor.c:877: ShowMessage("NO .TXT FILES");
	ld	de, ___str_37
	inc	sp
	jp	_ShowMessage
;src/editor/editor.c:878: return;
	jp	.l00116
.l00111:
;src/editor/editor.c:880: selected = Choose("OPEN", file_list[0], count);
	ld	a, c
	push	af
	inc	sp
	ld	bc, _file_list
	ld	de, ___str_38
	call	_Choose
	ld	c, a
;src/editor/editor.c:881: if (selected == CANCEL) return;
	ld	a, c
	inc	a
	jp	NZ,.l00159
	jp	.l00160
.l00159:
	jp	.l00113
.l00160:
	jp	.l00116
.l00113:
;src/editor/editor.c:882: result = FileLoad(file_list[selected]);
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
;src/editor/editor.c:883: CopyName(file_name, file_list[selected]);
	ld	de, _file_name
	call	_CopyName
;src/editor/editor.c:884: ResetCursor();
	call	_ResetCursor
;src/editor/editor.c:885: if (result) ShowError(result, "FILE TOO BIG");
	ld	hl, sp+0
	ld	a, [hl]
	or	a, a
	jp	Z, .l00116
	ld	de, ___str_39
	ld	a, [hl]
	inc	sp
	jp	_ShowError
.l00116:
;src/editor/editor.c:886: }
	inc	sp
	ret
___str_36:
	DB $00
___str_37:
	DB "NO .TXT FILES"
	DB $00
___str_38:
	DB "OPEN"
	DB $00
___str_39:
	DB "FILE TOO BIG"
	DB $00
;src/editor/editor.c:889: static unsigned char AskFileName(void) {
;	---------------------------------
; Function AskFileName
; ---------------------------------
_AskFileName:
	add	sp, -36
;src/editor/editor.c:894: Render();
	ld	c, $00
.l00137:
;src/editor/editor.c:893: for (; file_name[length] && file_name[length] != '.'; ++length) name[length] = file_name[length];
	ld	hl, _file_name
	ld	b, $00
	add	hl, bc
	ld	b, [hl]
	ld	a, b
	or	a, a
	jp	Z, .l00169
	ld	a, b
	sub	a, $2E
	jp	NZ,.l00260
	jp	.l00169
.l00260:
	ld	e, c
	ld	d, $00
	ld	hl, 0
	add	hl, sp
	add	hl, de
	ld	[hl], b
	inc	c
	jp	.l00137
.l00169:
	ld	hl, sp+34
	ld	[hl], c
;src/editor/editor.c:894: Render();
	call	_Render
;src/editor/editor.c:895: EditorShowCursor(0);
	xor	a, a
	call	_EditorShowCursor
;src/editor/editor.c:896: NoHighlight();
	call	_NoHighlight
;src/editor/editor.c:897: while (1) {
.l00132:
;src/editor/editor.c:898: CopyName(text, "SAVE AS ");
	ld	bc, ___str_40
	ld	hl, 9
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_CopyName
;src/editor/editor.c:899: for (i = 0; i < length; ++i) text[8 + i] = name[i];
	ld	hl, sp+35
	ld	[hl], $00
.l00140:
	ld	hl, sp+35
	ld	a, [hl]
	dec	hl
	sub	a, [hl]
	jp	NC, .l00102
	inc	hl
	ld	a, [hl]
	dec	hl
	dec	hl
	ld	[hl], a
	ld	a, [hl]
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
	push	hl
	ld	hl, 2
	add	hl, sp
	ld	e, l
	ld	d, h
	pop	hl
	ld	hl, sp+35
	ld	l, [hl]
	ld	h, $00
	add	hl, de
	ld	e, l
	ld	d, h
	ld	a, [de]
	ld	[bc], a
	ld	hl, sp+35
	inc	[hl]
	jp	.l00140
.l00102:
;src/editor/editor.c:900: CopyName(text + 8 + length, "_.TXT");
	ld	bc, ___str_41
	ld	hl, 17
	add	hl, sp
	ld	e, l
	ld	d, h
	ld	hl, sp+34
	ld	l, [hl]
	ld	h, $00
	add	hl, de
	ld	e, l
	ld	d, h
	call	_CopyName
;src/editor/editor.c:901: if (bars) DrawRow(HEADER_LINE, 1, text);
	ld	hl, _bars
	ld	a, [hl]
	or	a, a
	jp	Z, .l00104
	ld	hl, 9
	add	hl, sp
	push	hl
	ld	e, $01
	ld	a, $12
	call	_DrawRow
	jp	.l00105
.l00104:
;src/editor/editor.c:902: else DrawRow(0, 0, text);
	ld	hl, 9
	add	hl, sp
	push	hl
	ld	e, $00
	xor	a, a
	call	_DrawRow
.l00105:
;src/editor/editor.c:903: EditorDraw();
	call	_EditorDraw
;src/editor/editor.c:904: do {
.l00108:
;src/editor/editor.c:905: WaitFrame();
	call	_WaitFrame
;src/editor/editor.c:906: key = (unsigned char)KBPopEvent();
	call	_KBPopEvent
	ld	hl, sp+35
	ld	[hl], c
;src/editor/editor.c:907: if (!key) key = PadKey();
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00109
	call	_PadKey
	ld	hl, sp+35
	ld	[hl], a
.l00109:
;src/editor/editor.c:908: } while (!key);
	ld	hl, sp+35
	ld	a, [hl]
	or	a, a
	jp	Z, .l00108
;src/editor/editor.c:909: if (key == KEY_ENTER && length) break;
	ld	a, [hl]
	sub	a, $0A
	jp	NZ,.l00261
	jp	.l00262
.l00261:
	jp	.l00112
.l00262:
	ld	hl, sp+34
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00168
.l00112:
;src/editor/editor.c:910: if (key == KEY_ESCAPE || (key == KEY_BACKSPACE && !length)) {
	ld	hl, sp+35
	ld	a, [hl]
	sub	a, $1B
	jp	NZ,.l00263
	jp	.l00114
.l00263:
	ld	hl, sp+35
	ld	a, [hl]
	sub	a, $08
	jp	NZ,.l00264
	ld	a,$01
	jp	.l00265
.l00264:
	xor	a,a
.l00265:
	ld	c, a
	ld	a, c
	or	a, a
	jp	Z, .l00115
	ld	hl, sp+34
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00115
.l00114:
;src/editor/editor.c:911: dirty = 1;
	ld	hl, _dirty
	ld	[hl], $01
;src/editor/editor.c:912: return 0;
	xor	a, a
	jp	.l00145
.l00115:
;src/editor/editor.c:914: if (key == KEY_BACKSPACE) --length;
	ld	a, c
	or	a, a
	jp	Z, .l00119
	ld	hl, sp+34
	dec	[hl]
.l00119:
;src/editor/editor.c:915: if (key >= 'a' && key <= 'z') key -= 'a' - 'A';
	ld	hl, sp+35
	ld	a, [hl]
	sub	a, $61
	jp	C, .l00121
	ld	a, $7A
	sub	a, [hl]
	jp	C, .l00121
	ld	a, [hl]
	add	a, $E0
	ld	[hl], a
.l00121:
;src/editor/editor.c:916: if (length < BASE_NAME_SIZE && ((key >= 'A' && key <= 'Z') || (key >= '0' && key <= '9') || key == '_' || key == '-')) {
	ld	hl, sp+34
	ld	a, [hl]
	sub	a, $08
	jp	NC, .l00132
	inc	hl
	ld	a, [hl]
	sub	a, $41
	jp	C, .l00127
	ld	a, $5A
	sub	a, [hl]
	jp	NC, .l00123
.l00127:
	ld	hl, sp+35
	ld	a, [hl]
	sub	a, $30
	jp	C, .l00128
	ld	a, $39
	sub	a, [hl]
	jp	NC, .l00123
.l00128:
	ld	hl, sp+35
	ld	a, [hl]
	sub	a, $5F
	jp	NZ,.l00266
	jp	.l00123
.l00266:
	ld	hl, sp+35
	ld	a, [hl]
	sub	a, $2D
	jp	NZ,.l00267
	jp	.l00268
.l00267:
	jp	.l00132
.l00268:
.l00123:
;src/editor/editor.c:917: name[length++] = key;
	ld	hl, sp+34
	ld	e, [hl]
	inc	[hl]
	ld	d, $00
	ld	hl, 0
	add	hl, sp
	add	hl, de
	ld	c, l
	ld	b, h
	ld	hl, sp+35
	ld	a, [hl]
	ld	[bc], a
	jp	.l00132
;src/editor/editor.c:920: for (i = 0; i < length; ++i) file_name[i] = name[i];
.l00168:
	ld	hl, sp+35
	ld	[hl], $00
.l00143:
	ld	hl, sp+35
	ld	a, [hl]
	dec	hl
	sub	a, [hl]
	jp	NC, .l00134
	ld	de, _file_name
	inc	hl
	ld	l, [hl]
	ld	h, $00
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+32
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+31
	ld	[hl], a
	push	hl
	ld	hl, 2
	add	hl, sp
	ld	e, l
	ld	d, h
	pop	hl
	ld	hl, sp+35
	ld	l, [hl]
	ld	h, $00
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+34
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+33
	ld	[hl], a
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	ld	c, a
	ld	hl, sp+30
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	ld	[hl], c
	ld	hl, sp+35
	inc	[hl]
	jp	.l00143
.l00134:
;src/editor/editor.c:921: CopyName(file_name + length, ".TXT");
	ld	de, _file_name
	ld	hl, sp+34
	ld	l, [hl]
	ld	h, $00
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+33
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+32
	ld	[hl], a
	dec	hl
	ld	a, [hl]
	ld	hl, sp+34
	ld	[hl], a
	dec	hl
	dec	hl
	ld	a, [hl]
	ld	hl, sp+35
	ld	[hl], a
	ld	bc, ___str_42
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_CopyName
;src/editor/editor.c:922: dirty = 1;
	ld	hl, _dirty
	ld	[hl], $01
;src/editor/editor.c:923: return 1;
	ld	a, $01
.l00145:
;src/editor/editor.c:924: }
	add	sp, 36
	ret
___str_40:
	DB "SAVE AS "
	DB $00
___str_41:
	DB "_.TXT"
	DB $00
___str_42:
	DB ".TXT"
	DB $00
;src/editor/editor.c:926: static void SaveFile(unsigned char ask) {
;	---------------------------------
; Function SaveFile
; ---------------------------------
_SaveFile:
	ld	c, a
;src/editor/editor.c:928: if ((ask || !file_name[0]) && !AskFileName()) return;
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
;src/editor/editor.c:929: if ((result = FileMount()) || (result = FileSave(file_name))) {
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
;src/editor/editor.c:930: ShowError(result, "DISK FULL");
	ld	de, ___str_43
	ld	a, c
	jp	_ShowError
;src/editor/editor.c:931: return;
	jp	.l00108
.l00106:
;src/editor/editor.c:933: modified = 0;
	ld	hl, _modified
	ld	[hl], $00
;src/editor/editor.c:934: ShowMessage("SAVED");
	ld	de, ___str_44
	jp	_ShowMessage
.l00108:
;src/editor/editor.c:935: }
	ret
___str_43:
	DB "DISK FULL"
	DB $00
___str_44:
	DB "SAVED"
	DB $00
;src/editor/editor.c:938: static void ToggleFont(void) {
;	---------------------------------
; Function ToggleFont
; ---------------------------------
_ToggleFont:
;src/editor/editor.c:939: font = font == FONT_VWF ? FONT_MONO : FONT_VWF;
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
;src/editor/editor.c:940: SetFont(font);
	ld	hl, _font
	ld	a, [hl]
	call	_SetFont
;src/editor/editor.c:941: dirty = 1;
	ld	hl, _dirty
	ld	[hl], $01
.l00101:
;src/editor/editor.c:942: }
	ret
;src/editor/editor.c:945: static void ShowHelp(void) {
;	---------------------------------
; Function ShowHelp
; ---------------------------------
_ShowHelp:
	dec	sp
;src/editor/editor.c:946: unsigned char row, editor_font = font;
	ld	hl, _font
	ld	a, [hl]
	ld	hl, sp+0
	ld	[hl], a
;src/editor/editor.c:947: font = FONT_VWF;
	ld	hl, _font
	ld	[hl], $01
;src/editor/editor.c:948: SetFont(font);
	ld	a, $01
	call	_SetFont
;src/editor/editor.c:949: BeginFullScreen();
	call	_BeginFullScreen
;src/editor/editor.c:950: for (row = 0; row < HELP_ROWS; ++row) DrawRow(row, 0, help_lines[row]);
	ld	c, $00
.l00105:
	ld	b, $00
	ld	l, c
	ld	h, b
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, bc
	add	hl, hl
	add	hl, hl
	ld	de, _help_lines
	add	hl, de
	push	bc
	push	hl
	ld	e, $00
	ld	a, c
	call	_DrawRow
	pop	bc
	inc	c
	ld	a, c
	sub	a, $12
	jp	C, .l00105
;src/editor/editor.c:951: EditorDraw();
	call	_EditorDraw
;src/editor/editor.c:952: while (!MenuKey());
.l00102:
	call	_MenuKey
	or	a, a
	jp	Z, .l00102
;src/editor/editor.c:953: font = editor_font;
	ld	hl, sp+0
	ld	a, [hl]
	ld	hl, _font
	ld	[hl], a
;src/editor/editor.c:954: SetFont(font);
	ld	a, [hl]
	call	_SetFont
;src/editor/editor.c:955: EndFullScreen();
	inc	sp
	jp	_EndFullScreen
.l00107:
;src/editor/editor.c:956: }
	inc	sp
	ret
;src/editor/editor.c:958: static void FileMenu(void) {
;	---------------------------------
; Function FileMenu
; ---------------------------------
_FileMenu:
;src/editor/editor.c:959: switch (Choose("MENU", menu_items[0], 7)) {
	ld	a, $07
	push	af
	inc	sp
	ld	bc, _menu_items
	ld	de, ___str_45
	call	_Choose
	ld	c, a
	ld	a, $06
	sub	a, c
	jp	C, .l00109
	ld	b, $00
	ld	hl, .l00116
	add	hl, bc
	add	hl, bc
	add	hl, bc
	jp	hl
.l00116:
	jp	.l00101
	jp	.l00102
	jp	.l00103
	jp	.l00104
	jp	.l00105
	jp	.l00106
	jp	.l00107
;src/editor/editor.c:960: case 0: OpenFile(); break;
.l00101:
	jp	_OpenFile
	jp	.l00109
;src/editor/editor.c:961: case 1: SaveFile(0); break;
.l00102:
	xor	a, a
	jp	_SaveFile
	jp	.l00109
;src/editor/editor.c:962: case 2: SaveFile(1); break;
.l00103:
	ld	a, $01
	jp	_SaveFile
	jp	.l00109
;src/editor/editor.c:963: case 3: NewFile(); break;
.l00104:
	jp	_NewFile
	jp	.l00109
;src/editor/editor.c:964: case 4: ToggleFont(); break;
.l00105:
	jp	_ToggleFont
	jp	.l00109
;src/editor/editor.c:965: case 5: ToggleBars(); break;
.l00106:
	jp	_ToggleBars
	jp	.l00109
;src/editor/editor.c:966: case 6: ShowHelp(); break;
.l00107:
	jp	_ShowHelp
;src/editor/editor.c:967: }
.l00109:
;src/editor/editor.c:968: }
	ret
___str_45:
	DB "MENU"
	DB $00
;src/editor/editor.c:971: static unsigned char HandleFileKey(unsigned char key, unsigned char mods) {
;	---------------------------------
; Function HandleFileKey
; ---------------------------------
_HandleFileKey:
	ld	c, a
;src/editor/editor.c:972: if (key == KEY_MENU || key == KEY_ESCAPE) FileMenu();
	ld	a, c
	sub	a, $89
	jp	NZ,.l00172
	jp	.l00126
.l00172:
	ld	a, c
	sub	a, $1B
	jp	NZ,.l00173
	jp	.l00174
.l00173:
	jp	.l00127
.l00174:
.l00126:
	call	_FileMenu
	jp	.l00128
.l00127:
;src/editor/editor.c:973: else if (key == KEY_F1) ShowHelp();
	ld	a, c
	sub	a, $90
	jp	NZ,.l00175
	jp	.l00176
.l00175:
	jp	.l00124
.l00176:
	call	_ShowHelp
	jp	.l00128
.l00124:
;src/editor/editor.c:974: else if (key == KEY_F11) ToggleBars();
	ld	a, c
	sub	a, $9A
	jp	NZ,.l00177
	jp	.l00178
.l00177:
	jp	.l00121
.l00178:
	call	_ToggleBars
	jp	.l00128
.l00121:
;src/editor/editor.c:975: else if (!(mods & KB_MOD_CTRL)) return 0;
	bit	5, e
	jp	NZ,.l00179
	jp	.l00180
.l00179:
	jp	.l00118
.l00180:
	xor	a, a
	jp	.l00130
.l00118:
;src/editor/editor.c:976: else if (key == 'o' || key == 'O') OpenFile();
	ld	a, c
	sub	a, $6F
	jp	NZ,.l00181
	jp	.l00113
.l00181:
	ld	a, c
	sub	a, $4F
	jp	NZ,.l00182
	jp	.l00183
.l00182:
	jp	.l00114
.l00183:
.l00113:
	call	_OpenFile
	jp	.l00128
.l00114:
;src/editor/editor.c:977: else if (key == 's' || key == 'S') SaveFile(0);
	ld	a, c
	sub	a, $73
	jp	NZ,.l00184
	jp	.l00109
.l00184:
	ld	a, c
	sub	a, $53
	jp	NZ,.l00185
	jp	.l00186
.l00185:
	jp	.l00110
.l00186:
.l00109:
	xor	a, a
	call	_SaveFile
	jp	.l00128
.l00110:
;src/editor/editor.c:978: else if (key == 'n' || key == 'N') NewFile();
	ld	a, c
	sub	a, $6E
	jp	NZ,.l00187
	jp	.l00105
.l00187:
	ld	a, c
	sub	a, $4E
	jp	NZ,.l00188
	jp	.l00189
.l00188:
	jp	.l00106
.l00189:
.l00105:
	call	_NewFile
	jp	.l00128
.l00106:
;src/editor/editor.c:979: else if (key == 'f' || key == 'F') ToggleFont();
	ld	a, c
	sub	a, $66
	jp	NZ,.l00190
	jp	.l00101
.l00190:
	ld	a, c
	sub	a, $46
	jp	NZ,.l00191
	jp	.l00192
.l00191:
	jp	.l00102
.l00192:
.l00101:
	call	_ToggleFont
	jp	.l00128
.l00102:
;src/editor/editor.c:980: else return 0;
	xor	a, a
	jp	.l00130
.l00128:
;src/editor/editor.c:981: dirty = 1;
	ld	hl, _dirty
	ld	[hl], $01
;src/editor/editor.c:982: return 1;
	ld	a, $01
.l00130:
;src/editor/editor.c:983: }
	ret
;src/editor/editor.c:985: static void Render(void) {
;	---------------------------------
; Function Render
; ---------------------------------
_Render:
;src/editor/editor.c:986: tb_find = cursor;
	ld	hl, _cursor
	ld	a, [hl]
	ld	hl, _tb_find
	ld	[hl], a
	ld	hl, _cursor + 1
	ld	a, [hl]
	ld	hl, _tb_find + 1
	ld	[hl], a
;src/editor/editor.c:987: tb_Render(top);
	ld	hl, _top
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	jp	_tb_Render
.l00101:
;src/editor/editor.c:988: }
	ret
;src/editor/editor.c:991: static void Refresh(void) {
;	---------------------------------
; Function Refresh
; ---------------------------------
_Refresh:
	add	sp, -3
;src/editor/editor.c:994: if (top > tb_Length()) top = tb_Length();
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
;src/editor/editor.c:995: top = tb_RowStart(top); // wrapping may have changed
	ld	hl, _top
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_tb_RowStart
	ld	hl, _top
	ld	[hl], c
	inc	hl
	ld	[hl], b
;src/editor/editor.c:996: Render();
	call	_Render
;src/editor/editor.c:997: if (tb_found_row == 0xFF) {
	ld	hl, _tb_found_row
	ld	a, [hl]
	inc	a
	jp	NZ,.l00196
	jp	.l00197
.l00196:
	jp	.l00119
.l00197:
;src/editor/editor.c:998: row = tb_RowStart(cursor);
	ld	hl, _cursor
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_tb_RowStart
;src/editor/editor.c:999: if (cursor < top) {
	ld	de, _cursor
	ld	hl, _top
	ld	a, [de]
	inc	de
	sub	a, [hl]
	inc	hl
	ld	a, [de]
	sbc	a, [hl]
	jp	NC, .l00116
;src/editor/editor.c:1000: if (top && row == tb_RowStart(top - 1)) ScrollRing(0); // one row up
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
	jp	NZ,.l00198
	ld	a, d
	sub	a, b
	jp	NZ,.l00198
	jp	.l00199
.l00198:
	jp	.l00104
.l00199:
	push	bc
	xor	a, a
	call	_ScrollRing
	pop	bc
.l00104:
;src/editor/editor.c:1001: top = row;
	ld	hl, _top
	ld	[hl], c
	inc	hl
	ld	[hl], b
	jp	.l00117
.l00116:
;src/editor/editor.c:1004: bottom = tb_row_starts[tb_rows];
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
;src/editor/editor.c:1005: for (i = tb_rows; i; --i) {
	ld	hl, _tb_rows
	ld	a, [hl]
	ld	hl, sp+2
	ld	[hl], a
.l00121:
	ld	hl, sp+2
	ld	a, [hl]
	or	a, a
	jp	Z, .l00108
;src/editor/editor.c:1006: top = tb_NextRow(top);
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
;src/editor/editor.c:1007: if (bottom == row) break;
	ld	hl, sp+0
	ld	a, [hl]
	sub	a, c
	jp	NZ,.l00200
	inc	hl
	ld	a, [hl]
	sub	a, b
	jp	NZ,.l00200
	jp	.l00108
.l00200:
;src/editor/editor.c:1008: bottom = tb_NextRow(bottom);
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
;src/editor/editor.c:1005: for (i = tb_rows; i; --i) {
	ld	hl, sp+2
	dec	[hl]
	jp	.l00121
.l00108:
;src/editor/editor.c:1010: if (!i) { // the cursor's row goes at the bottom
	ld	hl, sp+2
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00113
;src/editor/editor.c:1011: top = row;
	ld	hl, _top
	ld	[hl], c
	inc	hl
	ld	[hl], b
;src/editor/editor.c:1012: for (i = tb_rows - 1; i && top; --i) top = tb_RowStart(top - 1);
	ld	hl, _tb_rows
	ld	c, [hl]
	dec	c
.l00125:
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
	jp	.l00125
.l00113:
;src/editor/editor.c:1014: else if (i == tb_rows) ScrollRing(1); // one row down
	ld	hl, _tb_rows
	ld	a, [hl]
	ld	hl, sp+2
	sub	a, [hl]
	jp	NZ,.l00201
	jp	.l00202
.l00201:
	jp	.l00117
.l00202:
	ld	a, $01
	call	_ScrollRing
.l00117:
;src/editor/editor.c:1016: Render();
	call	_Render
.l00119:
;src/editor/editor.c:1018: Draw();
	call	_Draw
;src/editor/editor.c:1019: redraw = 0;
	ld	hl, _redraw
	ld	[hl], $00
;src/editor/editor.c:1020: moved = 0;
	ld	hl, _moved
	ld	[hl], $00
;src/editor/editor.c:1021: PlaceCursor();
	call	_PlaceCursor
.l00127:
;src/editor/editor.c:1022: }
	add	sp, 3
	ret
;src/editor/editor.c:1024: void Editor(void) {
;	---------------------------------
; Function Editor
; ---------------------------------
_Editor::
;src/editor/editor.c:1028: EditorSetup();
	call	_EditorSetup
;src/editor/editor.c:1029: for (key = 0; key < BG_MAP_ROWS; ++key) map_blocks[key] = key < TB_ROWS ? key : 0xFF; // set by RenderSetup
	ld	c, $00
.l00162:
	ld	hl, _map_blocks
	ld	b, $00
	add	hl, bc
	ld	a, c
	sub	a, $12
	jp	NC, .l00166
	ld	e, c
	ld	d, $00
	jp	.l00167
.l00166:
	ld	de, $00FF
.l00167:
	ld	[hl], e
	inc	c
	ld	a, c
	sub	a, $20
	jp	C, .l00162
;src/editor/editor.c:1030: everdrive = sd_Detect();
	call	_sd_Detect
	ld	hl, _everdrive
	ld	[hl], a
;src/editor/editor.c:1031: idle_frames = 0;
	ld	hl, _idle_frames
	ld	[hl], $00
;src/editor/editor.c:1032: normalized = 0;
	ld	hl, _normalized
	ld	[hl], $00
;src/editor/editor.c:1033: cursor = 0;
	xor	a, a
	ld	hl, _cursor
	ld	[hl], a
	inc	hl
	ld	[hl], a
;src/editor/editor.c:1034: top = 0;
	xor	a, a
	ld	hl, _top
	ld	[hl], a
	inc	hl
	ld	[hl], a
;src/editor/editor.c:1035: selecting = 0;
	ld	hl, _selecting
	ld	[hl], $00
;src/editor/editor.c:1036: want_x = 0;
	ld	hl, _want_x
	ld	[hl], $00
;src/editor/editor.c:1037: keep_x = 0;
	ld	hl, _keep_x
	ld	[hl], $00
;src/editor/editor.c:1038: moved = 0;
	ld	hl, _moved
	ld	[hl], $00
;src/editor/editor.c:1039: redraw = 0;
	ld	hl, _redraw
	ld	[hl], $00
;src/editor/editor.c:1040: ring_top = 0;
	ld	hl, _ring_top
	ld	[hl], $00
;src/editor/editor.c:1041: ring_pos = 0;
	ld	hl, _ring_pos
	ld	[hl], $00
;src/editor/editor.c:1042: counted_pos = 0;
	xor	a, a
	ld	hl, _counted_pos
	ld	[hl], a
	inc	hl
	ld	[hl], a
;src/editor/editor.c:1043: counted_lines = 0;
	xor	a, a
	ld	hl, _counted_lines
	ld	[hl], a
	inc	hl
	ld	[hl], a
;src/editor/editor.c:1044: bars_changed = 0;
	ld	hl, _bars_changed
	ld	[hl], $00
;src/editor/editor.c:1045: edited = 0;
	ld	hl, _edited
	ld	[hl], $00
;src/editor/editor.c:1046: pad_timer = 0;
	ld	hl, _pad_timer
	ld	[hl], $00
;src/editor/editor.c:1047: modified = 0;
	ld	hl, _modified
	ld	[hl], $00
;src/editor/editor.c:1048: font = FONT_VWF;
	ld	hl, _font
	ld	[hl], $01
;src/editor/editor.c:1049: file_name[0] = 0;
	ld	hl, _file_name
	ld	[hl], $00
;src/editor/editor.c:1050: fs_crlf = 0;
	ld	hl, _fs_crlf
	ld	[hl], $00
;src/editor/editor.c:1051: osk_shown = 0;
	ld	hl, _osk_shown
	ld	[hl], $00
;src/editor/editor.c:1052: osk_layer = OSK_LOWER;
	ld	hl, _osk_layer
	ld	[hl], $00
;src/editor/editor.c:1053: osk_x = 0;
	ld	hl, _osk_x
	ld	[hl], $00
;src/editor/editor.c:1054: osk_y = 0;
	ld	hl, _osk_y
	ld	[hl], $00
;src/editor/editor.c:1055: bars_on = 1;
	ld	hl, _bars_on
	ld	[hl], $01
;src/editor/editor.c:1056: SetRows();
	call	_SetRows
;src/editor/editor.c:1057: Refresh();
	call	_Refresh
;src/editor/editor.c:1059: while (1) {
.l00160:
;src/editor/editor.c:1060: if (bars_changed) { // status bar follows the cursor
	ld	hl, _bars_changed
	ld	a, [hl]
	or	a, a
	jp	Z, .l00105
;src/editor/editor.c:1061: bars_changed = 0;
	ld	[hl], $00
;src/editor/editor.c:1062: if (bars) Draw();
	ld	hl, _bars
	ld	a, [hl]
	or	a, a
	jp	Z, .l00105
	call	_Draw
.l00105:
;src/editor/editor.c:1064: WaitFrame();
	call	_WaitFrame
;src/editor/editor.c:1065: while ((key = (unsigned char)(event = KBPopEvent()))) {
.l00115:
	call	_KBPopEvent
	ld	e, c
	ld	d, b
	ld	a, c
	ld	c, a
	or	a, a
	jp	Z, .l00117
;src/editor/editor.c:1066: if (!HandleFileKey(key, (unsigned char)(event >> 8))) HandleKey(key, (unsigned char)(event >> 8));
	ld	l, d
;	spillPairReg hl
;	spillPairReg hl
	push	hl
	push	bc
	ld	e, l
	ld	a, c
	call	_HandleFileKey
	pop	bc
	pop	hl
	or	a, a
	jp	NZ, .l00107
	ld	e, l
	ld	a, c
	call	_HandleKey
.l00107:
;src/editor/editor.c:1067: if (dirty || edited) break; // text changed, rows need rendering before more keys
	ld	hl, _dirty
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00117
	ld	hl, _edited
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00117
;src/editor/editor.c:1068: if (moved) { // keeps tb_found_row current for the next key
	ld	hl, _moved
	ld	a, [hl]
	or	a, a
	jp	Z, .l00115
;src/editor/editor.c:1069: if (!PlaceCursor()) dirty = 1;
	call	_PlaceCursor
	or	a, a
	jp	NZ, .l00112
	ld	hl, _dirty
	ld	[hl], $01
.l00112:
;src/editor/editor.c:1070: moved = 0;
	ld	hl, _moved
	ld	[hl], $00
	jp	.l00115
.l00117:
;src/editor/editor.c:1073: if ((key = PadKey())) {
	call	_PadKey
	ld	c, a
	or	a, a
	jp	Z, .l00121
;src/editor/editor.c:1074: if (!HandleFileKey(key, 0)) HandleKey(key, 0);
	push	bc
	ld	e, $00
	ld	a, c
	call	_HandleFileKey
	pop	bc
	or	a, a
	jp	NZ, .l00121
	ld	e, $00
	ld	a, c
	call	_HandleKey
.l00121:
;src/editor/editor.c:1076: if (dirty || edited || redraw || moved) idle_frames = 0;
	ld	hl, _dirty
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00122
	ld	hl, _edited
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00122
	ld	hl, _redraw
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00122
	ld	hl, _moved
	ld	a, [hl]
	or	a, a
	jp	Z, .l00123
.l00122:
	ld	hl, _idle_frames
	ld	[hl], $00
.l00123:
;src/editor/editor.c:1077: if (dirty) {
	ld	hl, _dirty
	ld	a, [hl]
	or	a, a
	jp	Z, .l00128
;src/editor/editor.c:1078: Refresh();
	call	_Refresh
;src/editor/editor.c:1079: dirty = 0;
	ld	hl, _dirty
	ld	[hl], $00
;src/editor/editor.c:1080: edited = 0;
	ld	hl, _edited
	ld	[hl], $00
;src/editor/editor.c:1081: normalized = 0;
	ld	hl, _normalized
	ld	[hl], $00
;src/editor/editor.c:1082: continue;
	jp	.l00160
.l00128:
;src/editor/editor.c:1084: if (edited) {
	ld	hl, _edited
	ld	a, [hl]
	or	a, a
	jp	Z, .l00141
;src/editor/editor.c:1085: edited = 0;
	ld	[hl], $00
;src/editor/editor.c:1086: normalized = 0;
	ld	hl, _normalized
	ld	[hl], $00
;src/editor/editor.c:1087: RenderAfterEdit();
	call	_RenderAfterEdit
;src/editor/editor.c:1088: if (!PlaceCursor()) {
	call	_PlaceCursor
	or	a, a
	jp	NZ, .l00141
;src/editor/editor.c:1089: if (cursor >= tb_row_starts[tb_rows] && tb_RowStart(cursor) == tb_row_starts[tb_rows]) ScrollDown();
	ld	hl, _tb_rows
	ld	l, [hl]
;	spillPairReg hl
;	spillPairReg hl
	ld	h, $00
;	spillPairReg hl
;	spillPairReg hl
	add	hl, hl
	ld	de, _tb_row_starts
	add	hl, de
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	ld	hl, _cursor
	ld	a, [hl]
	sub	a, c
	inc	hl
	ld	a, [hl]
	sbc	a, b
	jp	C, .l00135
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_tb_RowStart
	ld	hl, _tb_rows
	ld	l, [hl]
;	spillPairReg hl
;	spillPairReg hl
	ld	h, $00
;	spillPairReg hl
;	spillPairReg hl
	add	hl, hl
	ld	de, _tb_row_starts
	add	hl, de
	ld	a, [hl+]
	ld	h, [hl]
;	spillPairReg hl
	ld	l, a
;	spillPairReg hl
;	spillPairReg hl
	ld	a, l
	sub	a, c
	jp	NZ,.l00339
	ld	a, h
	sub	a, b
	jp	NZ,.l00339
	jp	.l00340
.l00339:
	jp	.l00135
.l00340:
	call	_ScrollDown
	jp	.l00136
.l00135:
;src/editor/editor.c:1090: else if (top && cursor < top && tb_RowStart(cursor) == tb_RowStart(top - 1)) ScrollUp(tb_RowStart(cursor));
	ld	hl, _top + 1
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	jp	Z, .l00130
	ld	de, _cursor
	ld	a, [de]
	inc	de
	sub	a, [hl]
	inc	hl
	ld	a, [de]
	sbc	a, [hl]
	jp	NC, .l00130
	ld	hl, _cursor
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_tb_RowStart
	ld	hl, _top + 1
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
	jp	NZ,.l00341
	ld	a, d
	sub	a, b
	jp	NZ,.l00341
	jp	.l00342
.l00341:
	jp	.l00130
.l00342:
	ld	hl, _cursor
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_tb_RowStart
	ld	e, c
	ld	d, b
	call	_ScrollUp
	jp	.l00136
.l00130:
;src/editor/editor.c:1092: Refresh();
	call	_Refresh
;src/editor/editor.c:1093: continue;
	jp	.l00160
.l00136:
;src/editor/editor.c:1095: PlaceCursor();
	call	_PlaceCursor
.l00141:
;src/editor/editor.c:1098: if (redraw) {
	ld	hl, _redraw
	ld	a, [hl]
	or	a, a
	jp	Z, .l00143
;src/editor/editor.c:1099: Draw();
	call	_Draw
;src/editor/editor.c:1100: redraw = 0;
	ld	hl, _redraw
	ld	[hl], $00
.l00143:
;src/editor/editor.c:1102: if (moved) {
	ld	hl, _moved
	ld	a, [hl]
	or	a, a
	jp	Z, .l00147
;src/editor/editor.c:1103: moved = 0;
	ld	[hl], $00
;src/editor/editor.c:1104: if (!PlaceCursor()) Refresh();
	call	_PlaceCursor
	or	a, a
	jp	NZ, .l00160
	call	_Refresh
;src/editor/editor.c:1105: continue;
	jp	.l00160
.l00147:
;src/editor/editor.c:1107: if (idle_frames < NORMALIZE_DELAY) ++idle_frames;
	ld	hl, _idle_frames
	ld	a, [hl]
	sub	a, $1E
	jp	NC, .l00152
	inc	[hl]
	jp	.l00153
.l00152:
;src/editor/editor.c:1108: else if (!everdrive && !normalized) normalized = tb_NormalizeStep(); // keeps the .sav readable as text
	ld	hl, _everdrive
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00153
	ld	hl, _normalized
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00153
	call	_tb_NormalizeStep
	ld	hl, _normalized
	ld	[hl], a
.l00153:
;src/editor/editor.c:1109: if (++blink_timer == CURSOR_BLINK) EditorShowCursor(0);
	ld	hl, _blink_timer
	inc	[hl]
	ld	a, [hl]
	sub	a, $1E
	jp	NZ,.l00343
	jp	.l00344
.l00343:
	jp	.l00157
.l00344:
	xor	a, a
	call	_EditorShowCursor
	jp	.l00160
.l00157:
;src/editor/editor.c:1110: else if (blink_timer == CURSOR_BLINK + CURSOR_BLINK) {
	ld	hl, _blink_timer
	ld	a, [hl]
	sub	a, $3C
	jp	NZ,.l00345
	jp	.l00346
.l00345:
	jp	.l00160
.l00346:
;src/editor/editor.c:1111: EditorShowCursor(1);
	ld	a, $01
	call	_EditorShowCursor
;src/editor/editor.c:1112: blink_timer = 0;
	ld	hl, _blink_timer
	ld	[hl], $00
	jp	.l00160
.l00164:
;src/editor/editor.c:1115: }
	ret
	SECTION FRAGMENT "src/editor/editor.c_CODE",ROMX
	SECTION FRAGMENT "_INITIALIZER",ROM0
	SECTION FRAGMENT "_CABS (ABS)",ROM0
