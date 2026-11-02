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
	EXPORT _RenderTextWidth
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
	EXPORT _list_times
	EXPORT _list_dates
	EXPORT _list_sizes
	EXPORT _list_kinds
	EXPORT _list_result
	EXPORT _entry
	EXPORT _file_dir
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
	DS 65
_file_dir:
	DS 128
_entry:
	DS 74
_list_result:
	DS 1
_list_kinds:
	DS 16
_list_sizes:
	DS 64
_list_dates:
	DS 32
_list_times:
	DS 32
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
;src/editor/editor.c:119: static unsigned char FindRow(unsigned int pos) {
;	---------------------------------
; Function FindRow
; ---------------------------------
_FindRow:
	dec	sp
	dec	sp
	ld	c, e
	ld	b, d
;src/editor/editor.c:121: for (row = 0; row < tb_rows; ++row) {
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
;src/editor/editor.c:122: if (pos < tb_row_starts[row]) return 0xFF;
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
;src/editor/editor.c:123: if (pos < tb_row_starts[row + 1]) return row;
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
;src/editor/editor.c:121: for (row = 0; row < tb_rows; ++row) {
	ld	hl, sp+1
	inc	[hl]
	ld	a, [hl]
	dec	hl
	ld	[hl], a
	jp	.l00107
.l00105:
;src/editor/editor.c:125: return pos == tb_Length() ? tb_end_row : 0xFF;
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
;src/editor/editor.c:126: }
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
;src/editor/editor.c:131: static unsigned char PlaceCursor(void) {
;	---------------------------------
; Function PlaceCursor
; ---------------------------------
_PlaceCursor:
	add	sp, -4
;src/editor/editor.c:132: unsigned char row = FindRow(cursor);
	ld	hl, _cursor
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_FindRow
	ld	c, a
;src/editor/editor.c:134: if (row == 0xFF) return 0;
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
;src/editor/editor.c:135: col = cursor - tb_row_starts[row];
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
;src/editor/editor.c:136: if (col > tb_row_counts[row]) col = tb_row_counts[row]; // hanging spaces
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
;src/editor/editor.c:137: tb_found_row = row;
	ld	hl, _tb_found_row
	ld	[hl], c
;src/editor/editor.c:138: tb_found_col = (unsigned char)col;
	ld	hl, _tb_found_col
	ld	[hl], e
;src/editor/editor.c:139: if (!keep_x) want_x = RenderCursorX(tb_found_col);
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
;src/editor/editor.c:140: keep_x = 0;
	ld	hl, _keep_x
	ld	[hl], $00
;src/editor/editor.c:141: blink_timer = 0;
	ld	hl, _blink_timer
	ld	[hl], $00
;src/editor/editor.c:142: EditorInvertCursor(GetSelection() && cursor == sel_start); // the selection starts at the cursor's x
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
;src/editor/editor.c:143: EditorShowCursor(1);
	ld	a, $01
	call	_EditorShowCursor
;src/editor/editor.c:144: bars_changed = 1;
	ld	hl, _bars_changed
	ld	[hl], $01
;src/editor/editor.c:145: return 1;
	ld	a, $01
.l00107:
;src/editor/editor.c:146: }
	add	sp, 4
	ret
;src/editor/editor.c:149: static unsigned int PosAtX(unsigned char row, unsigned char x) {
;	---------------------------------
; Function PosAtX
; ---------------------------------
_PosAtX:
	add	sp, -10
	ld	hl, sp+6
	ld	[hl], a
	dec	hl
	ld	[hl], e
;src/editor/editor.c:150: char* chars = RowAddress(row);
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
;src/editor/editor.c:151: unsigned char count = tb_row_counts[row], col = 0, width;
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
;src/editor/editor.c:153: while (col < count) {
	ld	hl, sp+7
	ld	[hl], $00
.l00103:
	ld	hl, sp+7
	ld	a, [hl]
	ld	hl, sp+4
	sub	a, [hl]
	jp	NC, .l00105
;src/editor/editor.c:154: width = font_widths[(unsigned char)chars[col]];
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
;src/editor/editor.c:155: if (x < ((width + 1) >> 1)) break;
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
;src/editor/editor.c:156: x = x < width ? 0 : x - width;
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
;src/editor/editor.c:157: ++col;
	inc	hl
	inc	hl
	inc	[hl]
	jp	.l00103
.l00105:
;src/editor/editor.c:159: pos = tb_row_starts[row] + col;
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
;src/editor/editor.c:160: if (col == count && pos == tb_row_starts[row + 1] && tb_end_row != row) --pos; // stay on wrapped row
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
;src/editor/editor.c:161: return pos;
	ld	hl, sp+8
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
.l00110:
;src/editor/editor.c:162: }
	add	sp, 10
	ret
;src/editor/editor.c:166: static void StageSplits(void) {
;	---------------------------------
; Function StageSplits
; ---------------------------------
_StageSplits:
	add	sp, -6
;src/editor/editor.c:167: unsigned char row, block, mode, current = 0xFF, shared = 0xFF, count = 0;
	ld	hl, sp+1
	ld	[hl], $FF
	inc	hl
	ld	[hl], $FF
	inc	hl
	ld	[hl], $00
;src/editor/editor.c:168: for (row = 0; row < TB_ROWS; ++row) {
	inc	hl
	inc	hl
	ld	[hl], $00
.l00114:
;src/editor/editor.c:169: block = render_row_blocks[row];
	ld	de, _render_row_blocks
	ld	hl, sp+5
	ld	l, [hl]
	ld	h, $00
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, [bc]
	ld	c, a
;src/editor/editor.c:170: if ((block >= 6 && block < 9) || block >= 15) {
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
;src/editor/editor.c:171: if (shared == 0xFF) shared = row;
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
;src/editor/editor.c:172: continue;
	jp	.l00112
.l00104:
;src/editor/editor.c:174: mode = block < 6 ? LCDC_TILES_8000 : 0;
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
;src/editor/editor.c:175: if (current == 0xFF) render_pending_top_mode = mode;
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
;src/editor/editor.c:176: else if (mode != current) {
	ld	hl, sp+1
	ld	a, [hl]
	ld	hl, sp+4
	sub	a, [hl]
	jp	NZ,.l00159
	jp	.l00111
.l00159:
;src/editor/editor.c:177: render_pending_splits[count++] = ((shared + row - 1) >> 1) << 3;
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
;src/editor/editor.c:178: render_pending_splits[count++] = mode;
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
;src/editor/editor.c:180: current = mode;
	ld	hl, sp+4
	ld	a, [hl]
	ld	hl, sp+1
	ld	[hl], a
;src/editor/editor.c:181: shared = 0xFF;
	inc	hl
	ld	[hl], $FF
.l00112:
;src/editor/editor.c:168: for (row = 0; row < TB_ROWS; ++row) {
	ld	hl, sp+5
	inc	[hl]
	ld	a, [hl]
	sub	a, $12
	jp	C, .l00114
;src/editor/editor.c:183: render_pending_split_count = count >> 1;
	dec	hl
	dec	hl
	ld	a, [hl]
	srl	a
	ld	hl, _render_pending_split_count
	ld	[hl], a
.l00115:
;src/editor/editor.c:184: }
	add	sp, 6
	ret
;src/editor/editor.c:187: static unsigned char RingLength(void) {
;	---------------------------------
; Function RingLength
; ---------------------------------
_RingLength:
;src/editor/editor.c:188: return bars ? TB_ROWS - 2 : TB_ROWS;
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
;src/editor/editor.c:189: }
	ret
;src/editor/editor.c:192: static unsigned char TextRows(void) {
;	---------------------------------
; Function TextRows
; ---------------------------------
_TextRows:
;src/editor/editor.c:193: return RingLength() - (osk_shown ? OSK_ROWS : 0);
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
;src/editor/editor.c:194: }
	ret
;src/editor/editor.c:199: static void Layout(void) {
;	---------------------------------
; Function Layout
; ---------------------------------
_Layout:
	add	sp, -6
;src/editor/editor.c:200: unsigned char row, line, block, map_row, i = ring_pos, length = RingLength();
	ld	hl, _ring_pos
	ld	a, [hl]
	ld	hl, sp+4
	ld	[hl], a
	call	_RingLength
	ld	hl, sp+0
	ld	[hl], a
;src/editor/editor.c:201: render_pending = 0;
	ld	hl, _render_pending
	ld	[hl], $00
;src/editor/editor.c:202: render_text_top = bars;
	ld	hl, _bars
	ld	a, [hl]
	ld	hl, _render_text_top
	ld	[hl], a
;src/editor/editor.c:203: for (row = 0; row < TB_ROWS; ++row) {
	ld	hl, sp+5
	ld	[hl], $00
.l00111:
;src/editor/editor.c:204: if (bars && (!row || row == TB_ROWS - 1)) {
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
;src/editor/editor.c:205: block = row ? STATUS_BLOCK : HEADER_BLOCK;
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
;src/editor/editor.c:206: line = row ? STATUS_LINE : HEADER_LINE;
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
;src/editor/editor.c:207: render_row_fonts[row] = FONT_VWF;
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
;src/editor/editor.c:210: block = bars && i >= HEADER_BLOCK ? i + 1 : i;
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
;src/editor/editor.c:211: if (++i == length) i = 0;
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
;src/editor/editor.c:212: line = row - bars;
	ld	hl, sp+5
	ld	a, [hl]
	ld	hl, _bars
	sub	a, [hl]
	ld	c, a
;src/editor/editor.c:213: render_row_fonts[row] = line < tb_rows ? font : FONT_MONO; // on screen keyboard
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
;src/editor/editor.c:215: render_row_blocks[row] = block;
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
;src/editor/editor.c:216: render_row_lines[row] = line;
	ld	de, _render_row_lines
	ld	hl, sp+5
	ld	l, [hl]
	ld	h, $00
	add	hl, de
	ld	e, l
	ld	d, h
	ld	a, c
	ld	[de], a
;src/editor/editor.c:217: map_row = (ring_top + row) & (BG_MAP_ROWS - 1);
	ld	hl, _ring_top
	ld	a, [hl]
	ld	hl, sp+5
	add	a, [hl]
	and	a, $1F
	ld	d, a
;src/editor/editor.c:218: if (map_blocks[map_row] != block) {
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
;src/editor/editor.c:219: map_blocks[map_row] = block;
	ld	hl, sp+1
	ld	a, [hl]
	ld	[bc], a
;src/editor/editor.c:220: RenderSetMapRow(map_row, block);
	ld	e, [hl]
	ld	a, d
	call	_RenderSetMapRow
.l00112:
;src/editor/editor.c:203: for (row = 0; row < TB_ROWS; ++row) {
	ld	hl, sp+5
	inc	[hl]
	ld	a, [hl]
	sub	a, $12
	jp	C, .l00111
;src/editor/editor.c:223: StageSplits();
	call	_StageSplits
;src/editor/editor.c:224: render_pending_scy = ring_top << 3;
	ld	hl, _ring_top
	ld	a, [hl]
	add	a, a
	add	a, a
	add	a, a
	ld	hl, _render_pending_scy
	ld	[hl], a
;src/editor/editor.c:225: render_pending = 1;
	ld	hl, _render_pending
	ld	[hl], $01
.l00113:
;src/editor/editor.c:226: }
	add	sp, 6
	ret
;src/editor/editor.c:229: static void ScrollRing(unsigned char down) {
;	---------------------------------
; Function ScrollRing
; ---------------------------------
_ScrollRing:
	add	sp, -7
	ld	hl, sp+6
	ld	[hl], a
;src/editor/editor.c:230: unsigned char length = RingLength();
	call	_RingLength
	ld	hl, sp+5
	ld	[hl], a
;src/editor/editor.c:232: ring_pos = ring_pos == length - 1 ? 0 : ring_pos + 1;
	ld	hl, _ring_pos
	ld	a, [hl]
	ld	hl, sp+0
	ld	[hl], a
;src/editor/editor.c:233: ring_top = (ring_top + 1) & (BG_MAP_ROWS - 1);
	ld	hl, _ring_top
	ld	a, [hl]
	ld	hl, sp+1
	ld	[hl], a
;src/editor/editor.c:231: if (down) {
	ld	hl, sp+6
	ld	a, [hl]
	or	a, a
	jp	Z, .l00102
;src/editor/editor.c:232: ring_pos = ring_pos == length - 1 ? 0 : ring_pos + 1;
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
;src/editor/editor.c:233: ring_top = (ring_top + 1) & (BG_MAP_ROWS - 1);
	ld	hl, sp+1
	ld	a, [hl]
	inc	a
	and	a, $1F
	ld	hl, _ring_top
	ld	[hl], a
	jp	.l00103
.l00102:
;src/editor/editor.c:236: ring_pos = ring_pos ? ring_pos - 1 : length - 1;
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
;src/editor/editor.c:237: ring_top = (ring_top - 1) & (BG_MAP_ROWS - 1);
	ld	hl, sp+1
	ld	a, [hl]
	dec	a
	and	a, $1F
	ld	hl, _ring_top
	ld	[hl], a
.l00103:
;src/editor/editor.c:239: Layout();
	call	_Layout
.l00104:
;src/editor/editor.c:240: }
	add	sp, 7
	ret
;src/editor/editor.c:243: static void ScrollDown(void) {
;	---------------------------------
; Function ScrollDown
; ---------------------------------
_ScrollDown:
;src/editor/editor.c:244: ScrollRing(1);
	ld	a, $01
	call	_ScrollRing
;src/editor/editor.c:245: tb_ScrollRows(1);
	ld	a, $01
	call	_tb_ScrollRows
;src/editor/editor.c:246: tb_RenderRows(tb_rows - 1, tb_rows);
	ld	hl, _tb_rows
	ld	c, [hl]
	dec	c
	ld	e, [hl]
	ld	a, c
	call	_tb_RenderRows
;src/editor/editor.c:247: top = tb_row_starts[0];
	ld	de, _tb_row_starts + 0
	ld	a, [de]
	ld	hl, _top
	ld	[hl], a
	inc	de
	ld	a, [de]
	inc	hl
	ld	[hl], a
;src/editor/editor.c:248: redraw = 1;
	ld	hl, _redraw
	ld	[hl], $01
.l00101:
;src/editor/editor.c:249: }
	ret
;src/editor/editor.c:252: static void ScrollUp(unsigned int new_top) {
;	---------------------------------
; Function ScrollUp
; ---------------------------------
_ScrollUp:
	ld	c, e
	ld	b, d
;src/editor/editor.c:253: ScrollRing(0);
	push	bc
	xor	a, a
	call	_ScrollRing
	pop	bc
;src/editor/editor.c:254: tb_ScrollRows(0);
	push	bc
	xor	a, a
	call	_tb_ScrollRows
	pop	bc
;src/editor/editor.c:255: tb_row_starts[0] = new_top;
	ld	hl, _tb_row_starts
	ld	[hl], c
	inc	hl
	ld	[hl], b
;src/editor/editor.c:256: tb_RenderRows(0, 1);
	push	bc
	ld	e, $01
	xor	a, a
	call	_tb_RenderRows
	pop	bc
;src/editor/editor.c:257: top = new_top;
	ld	hl, _top
	ld	[hl], c
	inc	hl
	ld	[hl], b
;src/editor/editor.c:258: redraw = 1;
	ld	hl, _redraw
	ld	[hl], $01
.l00101:
;src/editor/editor.c:259: }
	ret
;src/editor/editor.c:263: static void RenderAfterEdit(void) {
;	---------------------------------
; Function RenderAfterEdit
; ---------------------------------
_RenderAfterEdit:
	add	sp, -12
;src/editor/editor.c:264: unsigned char row = edit_row, end_row = tb_end_row, i;
	ld	hl, _edit_row
	ld	a, [hl]
	ld	hl, sp+10
	ld	[hl], a
	ld	hl, _tb_end_row
	ld	a, [hl]
	ld	hl, sp+0
	ld	[hl], a
;src/editor/editor.c:265: unsigned int old_next, expected, delta = (unsigned int)(int)edit_delta;
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
;src/editor/editor.c:266: if (row) --row; // the previous row's wrapping can change too
	ld	hl, sp+10
	ld	a, [hl]
	or	a, a
	jp	Z, .l00102
	dec	[hl]
.l00102:
;src/editor/editor.c:267: if (end_row != 0xFF && end_row >= row) tb_end_row = 0xFF; // found again while scanning
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
;src/editor/editor.c:268: for (; row < tb_rows; ++row) {
	ld	hl, sp+11
	ld	a, [hl]
	ld	hl, _tb_rows
	sub	a, [hl]
	jp	NC, .l00113
;src/editor/editor.c:269: old_next = tb_row_starts[row + 1];
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
;src/editor/editor.c:270: expected = old_next + delta;
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
;src/editor/editor.c:271: tb_RenderRows(row, row + 1);
	push	bc
	ld	hl, sp+7
	ld	e, [hl]
	ld	hl, sp+13
	ld	a, [hl]
	call	_tb_RenderRows
	pop	bc
;src/editor/editor.c:272: if (old_next > edit_pos && tb_row_starts[row + 1] == expected) {
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
;src/editor/editor.c:273: for (i = row + 2; i <= tb_rows; ++i) tb_row_starts[i] += delta; // rows below just moved
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
;src/editor/editor.c:274: if (end_row != 0xFF && end_row > row) tb_end_row = end_row;
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
;src/editor/editor.c:275: break;
	jp	.l00113
.l00119:
;src/editor/editor.c:268: for (; row < tb_rows; ++row) {
	ld	hl, sp+11
	inc	[hl]
	ld	a, [hl]
	dec	hl
	ld	[hl], a
	jp	.l00118
.l00113:
;src/editor/editor.c:278: redraw = 1;
	ld	hl, _redraw
	ld	[hl], $01
.l00120:
;src/editor/editor.c:279: }
	add	sp, 12
	ret
;src/editor/editor.c:282: static void Edited(unsigned int pos, signed char delta) {
;	---------------------------------
; Function Edited
; ---------------------------------
_Edited:
	ld	c, a
;src/editor/editor.c:283: modified = 1;
	ld	hl, _modified
	ld	[hl], $01
;src/editor/editor.c:284: if (edited) dirty = 1;
	ld	hl, _edited
	ld	a, [hl]
	or	a, a
	jp	Z, .l00102
	ld	hl, _dirty
	ld	[hl], $01
.l00102:
;src/editor/editor.c:285: edited = 1;
	ld	hl, _edited
	ld	[hl], $01
;src/editor/editor.c:286: edit_row = tb_found_row;
	ld	hl, _tb_found_row
	ld	a, [hl]
	ld	hl, _edit_row
	ld	[hl], a
;src/editor/editor.c:287: edit_pos = pos;
	ld	hl, _edit_pos
	ld	[hl], e
	inc	hl
	ld	[hl], d
;src/editor/editor.c:288: edit_delta = delta;
	ld	hl, _edit_delta
	ld	[hl], c
.l00103:
;src/editor/editor.c:289: }
	ret
;src/editor/editor.c:292: static unsigned char GetSelection(void) {
;	---------------------------------
; Function GetSelection
; ---------------------------------
_GetSelection:
;src/editor/editor.c:293: if (!selecting || anchor == cursor) return 0;
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
;src/editor/editor.c:295: sel_start = anchor;
	ld	hl, _anchor
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
;src/editor/editor.c:296: sel_end = cursor;
	ld	hl, _cursor
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
;src/editor/editor.c:294: if (anchor < cursor) {
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
;src/editor/editor.c:295: sel_start = anchor;
	ld	hl, _sel_start
	ld	[hl], c
	inc	hl
	ld	[hl], b
;src/editor/editor.c:296: sel_end = cursor;
	ld	hl, _sel_end
	ld	[hl], e
	inc	hl
	ld	[hl], d
	jp	.l00106
.l00105:
;src/editor/editor.c:299: sel_start = cursor;
	ld	hl, _sel_start
	ld	[hl], e
	inc	hl
	ld	[hl], d
;src/editor/editor.c:300: sel_end = anchor;
	ld	hl, _sel_end
	ld	[hl], c
	inc	hl
	ld	[hl], b
.l00106:
;src/editor/editor.c:302: return 1;
	ld	a, $01
.l00107:
;src/editor/editor.c:303: }
	ret
;src/editor/editor.c:305: static void ClearSelection(void) {
;	---------------------------------
; Function ClearSelection
; ---------------------------------
_ClearSelection:
;src/editor/editor.c:306: if (selecting) redraw = 1;
	ld	hl, _selecting
	ld	a, [hl]
	or	a, a
	jp	Z, .l00102
	ld	hl, _redraw
	ld	[hl], $01
.l00102:
;src/editor/editor.c:307: selecting = 0;
	ld	hl, _selecting
	ld	[hl], $00
.l00103:
;src/editor/editor.c:308: }
	ret
;src/editor/editor.c:311: static void NoHighlight(void) {
;	---------------------------------
; Function NoHighlight
; ---------------------------------
_NoHighlight:
;src/editor/editor.c:313: for (i = 0; i < TB_ROWS * 2; ++i) render_sel[i] = 0;
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
;src/editor/editor.c:314: if (bars) render_sel[1] = render_sel[(TB_ROWS << 1) - 1] = 0xFF;
	ld	hl, _bars
	ld	a, [hl]
	or	a, a
	jp	Z, .l00106
	ld	hl, (_render_sel + 35)
	ld	[hl], $FF
	ld	hl, (_render_sel + 1)
	ld	[hl], $FF
.l00106:
;src/editor/editor.c:315: }
	ret
;src/editor/editor.c:318: static void SetHighlight(void) {
;	---------------------------------
; Function SetHighlight
; ---------------------------------
_SetHighlight:
	add	sp, -10
;src/editor/editor.c:321: NoHighlight();
	call	_NoHighlight
;src/editor/editor.c:322: if (!GetSelection()) return;
	call	_GetSelection
	ld	hl, sp+9
	ld	[hl], a
	ld	hl, sp+9
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00134
	jp	.l00119
;src/editor/editor.c:323: for (row = 0; row < tb_rows; ++row) {
.l00134:
	ld	hl, sp+9
	ld	[hl], $00
.l00118:
	ld	hl, sp+9
	ld	a, [hl]
	ld	hl, _tb_rows
	sub	a, [hl]
	jp	NC, .l00119
;src/editor/editor.c:324: row_start = tb_row_starts[row];
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
;src/editor/editor.c:325: next = tb_row_starts[row + 1];
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
;src/editor/editor.c:326: if (sel_end <= row_start) break;
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
;src/editor/editor.c:327: if (sel_start >= next) continue;
	ld	de, _sel_start
	ld	hl, sp+2
	ld	a, [de]
	inc	de
	sub	a, [hl]
	inc	hl
	ld	a, [de]
	sbc	a, [hl]
	jp	NC, .l00115
;src/editor/editor.c:328: count = tb_row_counts[row];
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
;src/editor/editor.c:329: first = 0;
	inc	hl
	ld	[hl], $00
;src/editor/editor.c:330: if (sel_start > row_start) first = sel_start - row_start > count ? count : (unsigned char)(sel_start - row_start);
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
;src/editor/editor.c:331: if (sel_end < next || row == tb_end_row) { // ends in this row
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
;src/editor/editor.c:332: end = sel_end - row_start > count ? count : (unsigned char)(sel_end - row_start);
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
;src/editor/editor.c:333: if (end <= first) continue;
	ld	hl, sp+5
	ld	a, [hl]
	sub	a, e
	jp	C, .l00113
	jp	.l00115
.l00112:
;src/editor/editor.c:335: else end = 0xFF; // continues, so the line feed or wrap is selected too
	ld	e, $FF
.l00113:
;src/editor/editor.c:336: render_sel[(row + bars) << 1] = first;
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
;src/editor/editor.c:337: render_sel[((row + bars) << 1) + 1] = end;
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
;src/editor/editor.c:323: for (row = 0; row < tb_rows; ++row) {
	ld	hl, sp+9
	inc	[hl]
	jp	.l00118
.l00119:
;src/editor/editor.c:339: }
	add	sp, 10
	ret
;src/editor/editor.c:342: static unsigned int LinesBefore(unsigned int pos) {
;	---------------------------------
; Function LinesBefore
; ---------------------------------
_LinesBefore:
;src/editor/editor.c:343: if (pos >= counted_pos) counted_lines += tb_CountLines(counted_pos, pos);
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
;src/editor/editor.c:344: else if (pos < counted_pos - pos) counted_lines = tb_CountLines(0, pos);
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
;src/editor/editor.c:345: else counted_lines -= tb_CountLines(pos, counted_pos);
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
;src/editor/editor.c:346: counted_pos = pos;
	ld	hl, _counted_pos
	ld	[hl], e
	inc	hl
	ld	[hl], d
;src/editor/editor.c:347: return counted_lines;
	ld	hl, _counted_lines
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
.l00107:
;src/editor/editor.c:348: }
	ret
;src/editor/editor.c:351: static void CountEdit(unsigned int pos, unsigned char c, unsigned char inserted) {
;	---------------------------------
; Function CountEdit
; ---------------------------------
_CountEdit:
	ld	c, a
;src/editor/editor.c:352: if (pos >= counted_pos) return;
	ld	hl, _counted_pos
	ld	a, e
	sub	a, [hl]
	inc	hl
	ld	a, d
	sbc	a, [hl]
	jp	C, .l00102
	jp	.l00110
.l00102:
;src/editor/editor.c:355: if (c == ASCII_LF) ++counted_lines;
	ld	a, c
	sub	a, $0A
	jp	NZ,.l00132
	ld	a,$01
	jp	.l00133
.l00132:
	xor	a,a
.l00133:
	ld	c, a
;src/editor/editor.c:353: if (inserted) {
	ld	hl, sp+2
	ld	a, [hl]
	or	a, a
	jp	Z, .l00108
;src/editor/editor.c:354: ++counted_pos;
	ld	hl, _counted_pos
	inc	[hl]
	jp	NZ, .l00134
	inc	hl
	inc	[hl]
.l00134:
;src/editor/editor.c:355: if (c == ASCII_LF) ++counted_lines;
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
;src/editor/editor.c:358: --counted_pos;
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
;src/editor/editor.c:359: if (c == ASCII_LF) --counted_lines;
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
;src/editor/editor.c:361: }
	pop	hl
	inc	sp
	jp hl 
;src/editor/editor.c:364: static void Uncount(unsigned int pos) {
;	---------------------------------
; Function Uncount
; ---------------------------------
_Uncount:
;src/editor/editor.c:365: if (pos < counted_pos) counted_pos = counted_lines = 0;
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
;src/editor/editor.c:366: }
	ret
;src/editor/editor.c:369: static unsigned char RowEndsLine(unsigned char row) {
;	---------------------------------
; Function RowEndsLine
; ---------------------------------
_RowEndsLine:
	ld	e, a
;src/editor/editor.c:370: return tb_GetChar(tb_row_starts[row + 1] - 1) == ASCII_LF;
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
;src/editor/editor.c:371: }
	ret
;src/editor/editor.c:373: static unsigned int CursorLine(void) {
;	---------------------------------
; Function CursorLine
; ---------------------------------
_CursorLine:
;src/editor/editor.c:374: unsigned int line = LinesBefore(top) + 1;
	ld	hl, _top
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_LinesBefore
	inc	bc
;src/editor/editor.c:376: for (row = 0; row < tb_found_row; ++row) if (RowEndsLine(row)) ++line;
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
;src/editor/editor.c:377: return line;
.l00107:
;src/editor/editor.c:378: }
	ret
;src/editor/editor.c:380: static unsigned int CursorColumn(void) {
;	---------------------------------
; Function CursorColumn
; ---------------------------------
_CursorColumn:
	dec	sp
	dec	sp
;src/editor/editor.c:381: unsigned char row = tb_found_row;
	ld	hl, _tb_found_row
	ld	c, [hl]
;src/editor/editor.c:383: while (row && !RowEndsLine(row - 1)) --row;
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
;src/editor/editor.c:384: start = tb_row_starts[row];
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
;src/editor/editor.c:385: if (!row && start && tb_GetChar(start - 1) != ASCII_LF) start = tb_LineStart(start);
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
;src/editor/editor.c:386: return cursor - start + 1;
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
;src/editor/editor.c:387: }
	inc	sp
	inc	sp
	ret
;src/editor/editor.c:389: static char* PutText(char* dest, const char* text) {
;	---------------------------------
; Function PutText
; ---------------------------------
_PutText:
;src/editor/editor.c:390: while (*text) *dest++ = *text++;
.l00101:
	ld	a, [bc]
	or	a, a
	jp	Z, .l00103
	inc	bc
	ld	[de], a
	inc	de
	jp	.l00101
.l00103:
;src/editor/editor.c:391: return dest;
	ld	c, e
	ld	b, d
.l00104:
;src/editor/editor.c:392: }
	ret
;src/editor/editor.c:396: static char* PutNumber(char* dest, unsigned int n) {
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
;src/editor/editor.c:397: unsigned char i, digit, started = 0;
	ld	hl, sp+0
	ld	[hl], $00
;src/editor/editor.c:398: for (i = 0; i < 4; ++i) {
	ld	hl, sp+6
	ld	[hl], $00
;src/editor/editor.c:400: while (n >= powers_of_ten[i]) {
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
;src/editor/editor.c:401: n -= powers_of_ten[i];
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
;src/editor/editor.c:402: ++digit;
	ld	hl, sp+7
	inc	[hl]
	jp	.l00101
.l00117:
	ld	hl, sp+7
	ld	a, [hl]
	ld	hl, sp+1
	ld	[hl], a
;src/editor/editor.c:404: if (started || digit != '0') {
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
;src/editor/editor.c:405: *dest++ = digit;
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
;src/editor/editor.c:406: started = 1;
	ld	hl, sp+0
	ld	[hl], $01
.l00109:
;src/editor/editor.c:398: for (i = 0; i < 4; ++i) {
	ld	hl, sp+6
	inc	[hl]
	ld	a, [hl]
	sub	a, $04
	jp	C, .l00113
;src/editor/editor.c:409: *dest++ = '0' + (unsigned char)n;
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
;src/editor/editor.c:410: return dest;
.l00110:
;src/editor/editor.c:411: }
	add	sp, 8
	ret
_powers_of_ten:
	DW $2710
	DW $03E8
	DW $0064
	DW $000A
;src/editor/editor.c:414: static char* PutNumber2(char* dest, unsigned int n) {
;	---------------------------------
; Function PutNumber2
; ---------------------------------
_PutNumber2:
;src/editor/editor.c:415: if (n < 10) *dest++ = '0';
	ld	a, c
	sub	a, $0A
	ld	a, b
	sbc	a, $00
	jp	NC, .l00102
	ld	a, $30
	ld	[de], a
	inc	de
.l00102:
;src/editor/editor.c:416: return PutNumber(dest, n);
	jp	_PutNumber
.l00103:
;src/editor/editor.c:417: }
	ret
;src/editor/editor.c:420: static char* ToLatin1(char* dest, const char* text, unsigned char count) {
;	---------------------------------
; Function ToLatin1
; ---------------------------------
_ToLatin1:
	add	sp, -9
	ld	hl, sp+4
	ld	[hl], e
	inc	hl
	ld	[hl], d
;src/editor/editor.c:422: while ((c = *text++) && count--) {
	ld	hl, sp+11
	ld	a, [hl]
	ld	hl, sp+6
	ld	[hl], a
.l00113:
	ld	a, [bc]
	inc	bc
	ld	hl, sp+8
	ld	[hl], a
	or	a, a
	jp	Z, .l00115
	dec	hl
	dec	hl
	ld	e, [hl]
	dec	[hl]
	ld	a, e
	or	a, a
	jp	Z, .l00115
;src/editor/editor.c:423: if (c >= 0x80) {
	inc	hl
	inc	hl
	ld	a, [hl]
	sub	a, $80
	jp	C, .l00111
;src/editor/editor.c:424: next = *text;
	ld	a, [bc]
	ld	e, a
;src/editor/editor.c:425: if ((c & 0xFE) == 0xC2 && (next & 0xC0) == 0x80) { // U+0080-U+00FF
	ld	d, [hl]
	xor	a, a
	res	0, d
	ld	l, $00
;	spillPairReg hl
;	spillPairReg hl
	ld	a, d
	sub	a, $C2
	or	a, l
	jp	NZ,.l00165
	jp	.l00166
.l00165:
	jp	.l00125
.l00166:
	ld	a, e
	ld	d, $00
	and	a, $C0
	ld	l, a
;	spillPairReg hl
;	spillPairReg hl
	ld	d, $00
	ld	a, l
	sub	a, $80
	or	a, d
	jp	NZ,.l00167
	jp	.l00168
.l00167:
	jp	.l00125
.l00168:
;src/editor/editor.c:426: ++text;
	inc	bc
;src/editor/editor.c:427: c = (c << 6) | (next & 0x3F);
	ld	hl, sp+8
	ld	a, [hl]
	rrca
	rrca
	and	a, $C0
	ld	d, a
	ld	a, e
	and	a, $3F
	or	a, d
	ld	[hl], a
;src/editor/editor.c:428: if (c < 0xA0) c = '?';
	ld	a, [hl]
	sub	a, $A0
	jp	NC, .l00111
	ld	[hl], $3F
	jp	.l00111
;src/editor/editor.c:431: while ((*text & 0xC0) == 0x80) ++text;
.l00125:
	ld	hl, sp+7
	ld	[hl], c
	inc	hl
	ld	[hl], b
.l00103:
	ld	hl, sp+8
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	ld	hl, sp+3
	ld	[hl], a
	ld	a, [hl]
	ld	hl, sp+0
	ld	[hl], a
	inc	hl
	ld	[hl], $00
	dec	hl
	ld	a, [hl]
	and	a, $C0
	inc	hl
	inc	hl
	ld	[hl], a
	inc	hl
	ld	[hl], $00
	dec	hl
	ld	a, [hl]
	sub	a, $80
	inc	hl
	or	a, [hl]
	jp	NZ,.l00169
	jp	.l00170
.l00169:
	jp	.l00127
.l00170:
	ld	hl, sp+7
	inc	[hl]
	jp	NZ, .l00171
	inc	hl
	inc	[hl]
.l00171:
	jp	.l00103
.l00127:
	ld	hl, sp+7
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
;src/editor/editor.c:432: c = '?';
	ld	[hl], $3F
.l00111:
;src/editor/editor.c:435: *dest++ = c;
	ld	hl, sp+5
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, sp+8
	ld	a, [hl]
	ld	[de], a
	ld	hl, sp+4
	inc	[hl]
	jp	NZ, .l00172
	inc	hl
	inc	[hl]
.l00172:
	jp	.l00113
.l00115:
;src/editor/editor.c:437: return dest;
	ld	hl, sp+4
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
.l00116:
;src/editor/editor.c:438: }
	add	sp, 9
	pop	hl
	inc	sp
	jp hl 
;src/editor/editor.c:441: static void ToUtf8(char* dest, const char* text) {
;	---------------------------------
; Function ToUtf8
; ---------------------------------
_ToUtf8:
	ld	l, e
;	spillPairReg hl
;	spillPairReg hl
	ld	h, d
;	spillPairReg hl
;	spillPairReg hl
;src/editor/editor.c:443: while ((c = *text++)) {
.l00103:
	ld	a, [bc]
	inc	bc
	ld	e, a
	or	a, a
	jp	Z, .l00105
;src/editor/editor.c:444: if (c >= 0x80) {
	ld	a, e
	sub	a, $80
	jp	C, .l00102
;src/editor/editor.c:445: *dest++ = 0xC0 | (c >> 6);
	ld	a, e
	rlca
	rlca
	and	a, $03
	or	a, $C0
	ld	[hl], a
	inc	hl
;src/editor/editor.c:446: c = 0x80 | (c & 0x3F);
	ld	a, e
	and	a, $3F
	ld	e, a
	set	7, e
.l00102:
;src/editor/editor.c:448: *dest++ = c;
	ld	[hl], e
	inc	hl
	jp	.l00103
.l00105:
;src/editor/editor.c:450: *dest = 0;
	ld	[hl], $00
.l00106:
;src/editor/editor.c:451: }
	ret
;src/editor/editor.c:454: static void PutPath(char* dest, const char* path, unsigned char count) {
;	---------------------------------
; Function PutPath
; ---------------------------------
_PutPath:
	add	sp, -4
	ld	hl, sp+2
	ld	[hl], e
	inc	hl
	ld	[hl], d
	inc	sp
	inc	sp
	push	bc
;src/editor/editor.c:456: while (path[length]) ++length;
	ld	e, $00
.l00101:
	push	de
	ld	d, $00
	ld	hl, sp+2
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	add	hl, de
	pop	de
	ld	c, l
	ld	b, h
	ld	a, [bc]
	or	a, a
	jp	Z, .l00103
	inc	e
	jp	.l00101
.l00103:
;src/editor/editor.c:457: if (!length) path = "/";
	ld	a, e
	or	a, a
	jp	NZ, .l00107
	ld	hl, sp+0
	ld	a, LOW(___str_25)
	ld	[hl], a
	inc	hl
	ld	a, HIGH(___str_25)
	ld	[hl], a
	jp	.l00108
.l00107:
;src/editor/editor.c:458: else if (length > count) {
	ld	hl, sp+6
	ld	a, [hl]
	sub	a, e
	jp	NC, .l00108
;src/editor/editor.c:459: dest = PutText(dest, "...");
	push	de
	ld	bc, ___str_26
	ld	hl, sp+4
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_PutText
	pop	de
	ld	hl, sp+2
	ld	[hl], c
	inc	hl
	ld	[hl], b
;src/editor/editor.c:460: path += length - count;
	ld	a, e
	ld	c, $00
	ld	hl, sp+6
	ld	b, [hl]
	ld	d, $00
	sub	a, b
	ld	e, a
	ld	a, c
	sbc	a, d
	ld	d, a
	pop	hl
	push	hl
	add	hl, de
	inc	sp
	inc	sp
	push	hl
.l00108:
;src/editor/editor.c:462: *ToLatin1(dest, path, count) = 0;
	ld	hl, sp+6
	ld	a, [hl]
	push	af
	inc	sp
	ld	hl, sp+1
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	inc	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_ToLatin1
	xor	a, a
	ld	[bc], a
.l00109:
;src/editor/editor.c:463: }
	add	sp, 4
	pop	hl
	inc	sp
	jp hl 
___str_25:
	DB "/"
	DB $00
___str_26:
	DB "..."
	DB $00
;src/editor/editor.c:466: static unsigned char JoinPath(char* dest, const char* dir, const char* name, unsigned char size) {
;	---------------------------------
; Function JoinPath
; ---------------------------------
_JoinPath:
	add	sp, -6
	inc	sp
	inc	sp
	push	de
;src/editor/editor.c:467: while (*dir) {
	ld	hl, sp+10
	ld	a, [hl]
	ld	hl, sp+5
	ld	[hl], a
	pop	de
	push	de
.l00103:
	ld	a, [bc]
	ld	hl, sp+2
	ld	[hl], a
	ld	a, [hl]
	or	a, a
	jp	Z, .l00105
;src/editor/editor.c:468: if (!--size) return 0;
	ld	hl, sp+5
	dec	[hl]
	ld	a, [hl]
	ld	hl, sp+10
	ld	[hl], a
	ld	hl, sp+5
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00102
	xor	a, a
	jp	.l00113
.l00102:
;src/editor/editor.c:469: *dest++ = *dir++;
	ld	hl, sp+2
	ld	a, [hl]
	inc	bc
	ld	[de], a
	inc	de
	inc	sp
	inc	sp
	push	de
	jp	.l00103
.l00105:
;src/editor/editor.c:471: if (!--size) return 0;
	ld	hl, sp+10
	dec	[hl]
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00107
	xor	a, a
	jp	.l00113
.l00107:
;src/editor/editor.c:472: *dest++ = '/';
	pop	hl
	push	hl
	ld	[hl], $2F
	pop	de
	push	de
	ld	hl, $0001
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+5
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+4
	ld	[hl], a
;src/editor/editor.c:473: while (*name) {
	ld	hl, sp+10
	ld	a, [hl]
	dec	hl
	dec	hl
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	ld	hl, sp+3
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
.l00110:
	push	af
	ld	a, [bc]
	ld	l, a
;	spillPairReg hl
;	spillPairReg hl
	pop	af
	inc	l
	dec	l
	jp	Z, .l00112
;src/editor/editor.c:474: if (!--size) return 0;
	dec	a
	or	a, a
	jp	NZ, .l00109
	xor	a, a
	jp	.l00113
.l00109:
;src/editor/editor.c:475: *dest++ = *name++;
	push	af
	ld	a, l
	ld	hl, sp+7
	ld	[hl], a
	pop	af
	inc	bc
	push	af
	ld	a, [hl]
	ld	[de], a
	pop	af
	inc	de
	dec	hl
	dec	hl
	ld	[hl], e
	inc	hl
	ld	[hl], d
	jp	.l00110
.l00112:
;src/editor/editor.c:477: *dest = 0;
	ld	hl, sp+3
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	ld	[hl], $00
;src/editor/editor.c:478: return 1;
	ld	a, $01
.l00113:
;src/editor/editor.c:479: }
	add	sp, 6
	pop	hl
	add	sp, 3
	jp hl 
;src/editor/editor.c:482: static void UpdateBars(void) {
;	---------------------------------
; Function UpdateBars
; ---------------------------------
_UpdateBars:
	add	sp, -40
;src/editor/editor.c:484: char* end = file_name[0] ? ToLatin1(text, file_name, TB_STRIDE - 3) : PutText(text, "Untitled");
	ld	bc, _file_name+0
	ld	a, [bc]
	ld	e, a
	ld	a, e
	or	a, a
	jp	Z, .l00110
	ld	hl, sp+0
	ld	e, l
	ld	d, h
	ld	a, $25
	push	af
	inc	sp
	call	_ToLatin1
	jp	.l00111
.l00110:
	ld	bc, ___str_27
	ld	hl, 0
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_PutText
.l00111:
;src/editor/editor.c:485: if (modified) *end++ = '*';
	ld	hl, _modified
	ld	a, [hl]
	or	a, a
	jp	Z, .l00102
	ld	a, $2A
	ld	[bc], a
	inc	bc
.l00102:
;src/editor/editor.c:486: *end = 0;
	xor	a, a
	ld	[bc], a
;src/editor/editor.c:487: DrawRow(HEADER_LINE, 1, text);
	ld	hl, 0
	add	hl, sp
	push	hl
	ld	e, $01
	ld	a, $12
	call	_DrawRow
;src/editor/editor.c:488: if (tb_found_row == 0xFF) return; // cursor isn't on screen
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
;src/editor/editor.c:489: if (GetSelection()) {
	call	_GetSelection
	ld	c, a
	ld	a, c
	or	a, a
	jp	Z, .l00106
;src/editor/editor.c:490: end = PutNumber(text, sel_end - sel_start);
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
;src/editor/editor.c:491: end = PutText(end, " selected");
	ld	bc, ___str_28
	call	_PutText
	ld	e, c
	ld	d, b
	jp	.l00107
.l00106:
;src/editor/editor.c:494: end = PutText(text, "Line ");
	ld	bc, ___str_29
	ld	hl, 0
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_PutText
	ld	e, c
	ld	d, b
;src/editor/editor.c:495: end = PutNumber(end, CursorLine());
	push	de
	call	_CursorLine
	pop	de
	call	_PutNumber
	ld	e, c
	ld	d, b
;src/editor/editor.c:496: end = PutText(end, ", Col ");
	ld	bc, ___str_30
	call	_PutText
	ld	e, c
	ld	d, b
;src/editor/editor.c:497: end = PutNumber(end, CursorColumn());
	push	de
	call	_CursorColumn
	pop	de
	call	_PutNumber
	ld	e, c
	ld	d, b
.l00107:
;src/editor/editor.c:499: *end = 0;
	xor	a, a
	ld	[de], a
;src/editor/editor.c:500: DrawRow(STATUS_LINE, 1, text);
	ld	hl, 0
	add	hl, sp
	push	hl
	ld	e, $01
	ld	a, $13
	call	_DrawRow
.l00108:
;src/editor/editor.c:501: }
	add	sp, 40
	ret
___str_27:
	DB "Untitled"
	DB $00
___str_28:
	DB " selected"
	DB $00
___str_29:
	DB "Line "
	DB $00
___str_30:
	DB ", Col "
	DB $00
;src/editor/editor.c:503: static void Draw(void) {
;	---------------------------------
; Function Draw
; ---------------------------------
_Draw:
;src/editor/editor.c:504: SetHighlight();
	call	_SetHighlight
;src/editor/editor.c:505: if (bars) UpdateBars();
	ld	hl, _bars
	ld	a, [hl]
	or	a, a
	jp	Z, .l00102
	call	_UpdateBars
.l00102:
;src/editor/editor.c:506: EditorDraw();
	jp	_EditorDraw
.l00103:
;src/editor/editor.c:507: }
	ret
;src/editor/editor.c:510: static void ScrollTo(unsigned int new_top) {
;	---------------------------------
; Function ScrollTo
; ---------------------------------
_ScrollTo:
	ld	hl, _top
	ld	[hl], e
	inc	hl
	ld	[hl], d
;src/editor/editor.c:512: Render();
	call	_Render
;src/editor/editor.c:513: redraw = 1;
	ld	hl, _redraw
	ld	[hl], $01
.l00101:
;src/editor/editor.c:514: }
	ret
;src/editor/editor.c:516: static void MoveUp(void) {
;	---------------------------------
; Function MoveUp
; ---------------------------------
_MoveUp:
;src/editor/editor.c:517: unsigned char row = tb_found_row;
	ld	hl, _tb_found_row
	ld	a, [hl]
;src/editor/editor.c:518: keep_x = 1;
	ld	hl, _keep_x
	ld	[hl], $01
;src/editor/editor.c:519: if (row) cursor = PosAtX(row - 1, want_x);
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
;src/editor/editor.c:520: else if (!top) cursor = 0;
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
;src/editor/editor.c:522: ScrollUp(tb_RowStart(top - 1));
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
;src/editor/editor.c:523: cursor = PosAtX(0, want_x);
	ld	hl, _want_x
	ld	e, [hl]
	xor	a, a
	call	_PosAtX
	ld	hl, _cursor
	ld	[hl], c
	inc	hl
	ld	[hl], b
.l00107:
;src/editor/editor.c:525: }
	ret
;src/editor/editor.c:527: static void MoveDown(void) {
;	---------------------------------
; Function MoveDown
; ---------------------------------
_MoveDown:
	dec	sp
;src/editor/editor.c:528: unsigned char row = tb_found_row;
	ld	hl, _tb_found_row
	ld	a, [hl]
	ld	hl, sp+0
	ld	[hl], a
;src/editor/editor.c:529: keep_x = 1;
	ld	hl, _keep_x
	ld	[hl], $01
;src/editor/editor.c:530: if (tb_end_row == row) cursor = tb_Length(); // last row
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
;src/editor/editor.c:531: else if (row + 1 < tb_rows) cursor = PosAtX(row + 1, want_x);
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
;src/editor/editor.c:533: ScrollDown();
	call	_ScrollDown
;src/editor/editor.c:534: cursor = PosAtX(row, want_x);
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
;src/editor/editor.c:536: }
	inc	sp
	ret
;src/editor/editor.c:538: static void PageUp(void) {
;	---------------------------------
; Function PageUp
; ---------------------------------
_PageUp:
;src/editor/editor.c:539: unsigned char row = tb_found_row, i;
	ld	hl, _tb_found_row
	ld	c, [hl]
;src/editor/editor.c:540: keep_x = 1;
	ld	hl, _keep_x
	ld	[hl], $01
;src/editor/editor.c:541: if (!top) {
	ld	hl, _top + 1
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	jp	NZ, .l00102
;src/editor/editor.c:542: cursor = 0;
	xor	a, a
	ld	hl, _cursor
	ld	[hl], a
	inc	hl
	ld	[hl], a
;src/editor/editor.c:543: return;
	jp	.l00108
.l00102:
;src/editor/editor.c:545: for (i = tb_rows - 1; i && top; --i) top = tb_RowStart(top - 1);
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
;src/editor/editor.c:546: ScrollTo(top);
	push	bc
	ld	hl, _top
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_ScrollTo
	pop	bc
;src/editor/editor.c:547: cursor = PosAtX(row, want_x);
	ld	hl, _want_x
	ld	e, [hl]
	ld	a, c
	call	_PosAtX
	ld	hl, _cursor
	ld	[hl], c
	inc	hl
	ld	[hl], b
.l00108:
;src/editor/editor.c:548: }
	ret
;src/editor/editor.c:550: static void PageDown(void) {
;	---------------------------------
; Function PageDown
; ---------------------------------
_PageDown:
;src/editor/editor.c:551: unsigned char row = tb_found_row;
	ld	hl, _tb_found_row
	ld	c, [hl]
;src/editor/editor.c:552: keep_x = 1;
	ld	hl, _keep_x
	ld	[hl], $01
;src/editor/editor.c:553: if (tb_end_row != 0xFF) {
	ld	hl, _tb_end_row
	ld	a, [hl]
	inc	a
	jp	NZ,.l00123
	jp	.l00102
.l00123:
;src/editor/editor.c:554: cursor = tb_Length();
	call	_tb_Length
	ld	hl, _cursor
	ld	[hl], c
	inc	hl
	ld	[hl], b
;src/editor/editor.c:555: return;
	jp	.l00106
.l00102:
;src/editor/editor.c:557: ScrollTo(tb_row_starts[tb_rows - 1]);
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
;src/editor/editor.c:558: if (tb_end_row != 0xFF && row > tb_end_row) row = tb_end_row;
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
;src/editor/editor.c:559: cursor = PosAtX(row, want_x);
	ld	hl, _want_x
	ld	e, [hl]
	ld	a, c
	call	_PosAtX
	ld	hl, _cursor
	ld	[hl], c
	inc	hl
	ld	[hl], b
.l00106:
;src/editor/editor.c:560: }
	ret
;src/editor/editor.c:563: static void MoveEnd(void) {
;	---------------------------------
; Function MoveEnd
; ---------------------------------
_MoveEnd:
	add	sp, -4
;src/editor/editor.c:564: unsigned char row = tb_found_row, count = tb_row_counts[row];
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
;src/editor/editor.c:565: cursor = tb_row_starts[row] + count;
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
;src/editor/editor.c:566: if (count && cursor == tb_row_starts[row + 1] && tb_end_row != row && RowAddress(row)[count - 1] == ' ') --cursor;
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
;src/editor/editor.c:567: }
	add	sp, 4
	ret
;src/editor/editor.c:569: static void DeleteSelection(void) {
;	---------------------------------
; Function DeleteSelection
; ---------------------------------
_DeleteSelection:
;src/editor/editor.c:570: Uncount(sel_start);
	ld	hl, _sel_start
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_Uncount
;src/editor/editor.c:571: tb_DeleteRange(sel_start, sel_end - sel_start);
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
;src/editor/editor.c:572: cursor = sel_start;
	ld	hl, _sel_start
	ld	a, [hl]
	ld	hl, _cursor
	ld	[hl], a
	ld	hl, _sel_start + 1
	ld	a, [hl]
	ld	hl, _cursor + 1
	ld	[hl], a
;src/editor/editor.c:573: selecting = 0;
	ld	hl, _selecting
	ld	[hl], $00
;src/editor/editor.c:574: modified = 1;
	ld	hl, _modified
	ld	[hl], $01
;src/editor/editor.c:575: dirty = 1;
	ld	hl, _dirty
	ld	[hl], $01
.l00101:
;src/editor/editor.c:576: }
	ret
;src/editor/editor.c:578: static unsigned char Copy(void) {
;	---------------------------------
; Function Copy
; ---------------------------------
_Copy:
;src/editor/editor.c:579: if (!GetSelection()) return 0;
	call	_GetSelection
	or	a, a
	jp	NZ, .l00102
	xor	a, a
	jp	.l00105
.l00102:
;src/editor/editor.c:580: if (tb_Copy(sel_start, sel_end - sel_start)) return 1;
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
;src/editor/editor.c:581: ShowMessage("TOO BIG TO COPY");
	ld	de, ___str_31
	call	_ShowMessage
;src/editor/editor.c:582: return 0;
	xor	a, a
.l00105:
;src/editor/editor.c:583: }
	ret
___str_31:
	DB "TOO BIG TO COPY"
	DB $00
;src/editor/editor.c:585: static void Paste(void) {
;	---------------------------------
; Function Paste
; ---------------------------------
_Paste:
	add	sp, -4
;src/editor/editor.c:586: unsigned int length = tb_ClipLength(), room = TB_SIZE - tb_Length();
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
;src/editor/editor.c:587: if (!length) return;
	ld	a, b
	or	a, c
	jp	NZ, .l00102
	jp	.l00109
.l00102:
;src/editor/editor.c:588: if (GetSelection()) room += sel_end - sel_start;
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
;src/editor/editor.c:589: if (length > room) {
	ld	hl, sp+2
	ld	a, [hl]
	sub	a, c
	inc	hl
	ld	a, [hl]
	sbc	a, b
	jp	NC, .l00106
;src/editor/editor.c:590: ShowMessage("TEXT FULL");
	ld	de, ___str_32
	call	_ShowMessage
;src/editor/editor.c:591: return;
	jp	.l00109
.l00106:
;src/editor/editor.c:593: if (GetSelection()) DeleteSelection();
	push	bc
	call	_GetSelection
	pop	bc
	or	a, a
	jp	Z, .l00108
	push	bc
	call	_DeleteSelection
	pop	bc
.l00108:
;src/editor/editor.c:594: Uncount(cursor);
	push	bc
	ld	hl, _cursor
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_Uncount
	pop	bc
;src/editor/editor.c:595: tb_Paste(cursor);
	push	bc
	ld	hl, _cursor
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_tb_Paste
	pop	bc
;src/editor/editor.c:596: cursor += length;
	ld	hl, _cursor
	ld	a, [hl]
	add	a, c
	ld	[hl], a
	inc	hl
	ld	a, [hl]
	adc	a, b
	ld	[hl], a
;src/editor/editor.c:597: modified = 1;
	ld	hl, _modified
	ld	[hl], $01
;src/editor/editor.c:598: dirty = 1;
	ld	hl, _dirty
	ld	[hl], $01
.l00109:
;src/editor/editor.c:599: }
	add	sp, 4
	ret
___str_32:
	DB "TEXT FULL"
	DB $00
;src/editor/editor.c:602: static unsigned char CharClass(unsigned char c) {
;	---------------------------------
; Function CharClass
; ---------------------------------
_CharClass:
	ld	c, a
;src/editor/editor.c:603: if (c == ' ' || c == ASCII_TAB || c == ASCII_LF) return 0;
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
;src/editor/editor.c:604: if ((c >= '0' && c <= '9') || (c >= 'A' && c <= 'Z') || (c >= 'a' && c <= 'z') || c == '_' || c >= 0xC0) return 1;
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
;src/editor/editor.c:605: return 2;
	ld	a, $02
.l00114:
;src/editor/editor.c:606: }
	ret
;src/editor/editor.c:609: static void WordRight(void) {
;	---------------------------------
; Function WordRight
; ---------------------------------
_WordRight:
	dec	sp
;src/editor/editor.c:610: unsigned int length = tb_Length();
	call	_tb_Length
;src/editor/editor.c:612: while (cursor < length && !CharClass(tb_GetChar(cursor))) ++cursor;
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
;src/editor/editor.c:613: if (cursor == length) return;
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
;src/editor/editor.c:614: token = CharClass(tb_GetChar(cursor));
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
;src/editor/editor.c:615: do ++cursor;
.l00108:
	ld	hl, _cursor
	inc	[hl]
	jp	NZ, .l00146
	inc	hl
	inc	[hl]
.l00146:
;src/editor/editor.c:616: while (cursor < length && CharClass(tb_GetChar(cursor)) == token);
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
;src/editor/editor.c:617: }
	inc	sp
	ret
;src/editor/editor.c:620: static void WordLeft(void) {
;	---------------------------------
; Function WordLeft
; ---------------------------------
_WordLeft:
;src/editor/editor.c:622: while (cursor && !CharClass(tb_GetChar(cursor - 1))) --cursor;
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
;src/editor/editor.c:623: if (!cursor) return;
	ld	hl, _cursor + 1
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	jp	NZ, .l00106
	jp	.l00111
.l00106:
;src/editor/editor.c:624: token = CharClass(tb_GetChar(cursor - 1));
	call	_tb_GetChar
	ld	c, a
	ld	a, c
	call	_CharClass
	ld	c, a
;src/editor/editor.c:625: do --cursor;
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
;src/editor/editor.c:626: while (cursor && CharClass(tb_GetChar(cursor - 1)) == token);
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
;src/editor/editor.c:627: }
	ret
;src/editor/editor.c:630: static void ScrollLine(unsigned char down) {
;	---------------------------------
; Function ScrollLine
; ---------------------------------
_ScrollLine:
	ld	c, a
;src/editor/editor.c:631: unsigned char row = tb_found_row;
	ld	hl, _tb_found_row
	ld	b, [hl]
;src/editor/editor.c:632: keep_x = 1;
	ld	hl, _keep_x
	ld	[hl], $01
;src/editor/editor.c:633: if (down) {
	ld	a, c
	or	a, a
	jp	Z, .l00110
;src/editor/editor.c:634: if (tb_end_row != 0xFF) return; // the end of the text is on screen
	ld	hl, _tb_end_row
	ld	a, [hl]
	inc	a
	jp	NZ,.l00139
	jp	.l00102
.l00139:
	jp	.l00112
.l00102:
;src/editor/editor.c:635: ScrollDown();
	push	bc
	call	_ScrollDown
	pop	bc
;src/editor/editor.c:636: if (!row) cursor = PosAtX(0, want_x);
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
;src/editor/editor.c:638: else if (top) {
	ld	hl, _top + 1
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	jp	Z, .l00112
;src/editor/editor.c:639: ScrollUp(tb_RowStart(top - 1));
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
;src/editor/editor.c:640: if (row == tb_rows - 1) cursor = PosAtX(row, want_x);
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
;src/editor/editor.c:642: }
	ret
;src/editor/editor.c:645: static void HandleCtrlKey(unsigned char key) {
;	---------------------------------
; Function HandleCtrlKey
; ---------------------------------
_HandleCtrlKey:
	ld	l, a
;	spillPairReg hl
;	spillPairReg hl
;src/editor/editor.c:646: if (key >= 'A' && key <= 'Z') key += 'a' - 'A';
	ld	a, l
	sub	a, $41
	jp	C, .l00102
	ld	a, $5A
	sub	a, l
	jp	C, .l00102
	ld	c, $20
	add	hl, bc
.l00102:
;src/editor/editor.c:647: if (key == 'a') {
	ld	a, l
	sub	a, $61
	jp	NZ,.l00153
	jp	.l00154
.l00153:
	jp	.l00114
.l00154:
;src/editor/editor.c:648: anchor = 0;
	xor	a, a
	ld	hl, _anchor
	ld	[hl], a
	inc	hl
	ld	[hl], a
;src/editor/editor.c:649: cursor = tb_Length();
	call	_tb_Length
	ld	hl, _cursor
	ld	[hl], c
	inc	hl
	ld	[hl], b
;src/editor/editor.c:650: selecting = 1;
	ld	hl, _selecting
	ld	[hl], $01
;src/editor/editor.c:651: moved = 1;
	ld	hl, _moved
	ld	[hl], $01
;src/editor/editor.c:652: redraw = 1;
	ld	hl, _redraw
	ld	[hl], $01
	jp	.l00116
.l00114:
;src/editor/editor.c:654: else if (key == 'c') Copy();
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
;src/editor/editor.c:655: else if (key == 'x' && Copy()) DeleteSelection();
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
;src/editor/editor.c:656: else if (key == 'v') Paste();
	ld	a, l
	sub	a, $76
	jp	NZ,.l00159
	jp	.l00160
.l00159:
	jp	.l00116
.l00160:
	jp	_Paste
.l00116:
;src/editor/editor.c:657: }
	ret
;src/editor/editor.c:660: static void HandleKey(unsigned char key, unsigned char mods) {
;	---------------------------------
; Function HandleKey
; ---------------------------------
_HandleKey:
	add	sp, -3
	ld	hl, sp+2
	ld	[hl], a
	dec	hl
	ld	[hl], e
;src/editor/editor.c:661: unsigned char ctrl = mods & KB_MOD_CTRL, c;
	ld	a, [hl]
	and	a, $20
	dec	hl
	ld	[hl], a
;src/editor/editor.c:662: if (mods & (KB_MOD_ALT | KB_MOD_SUPER)) return;
	inc	hl
	ld	a, [hl]
	and	a, $18
	jp	NZ,.l00342
	jp	.l00102
.l00342:
	jp	.l00168
.l00102:
;src/editor/editor.c:663: if (key < KEY_LEFT || key > KEY_PAGE_DOWN) {
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
;src/editor/editor.c:664: if (ctrl) {
	ld	hl, sp+0
	ld	a, [hl]
	or	a, a
	jp	Z, .l00118
;src/editor/editor.c:665: HandleCtrlKey(key);
	inc	hl
	inc	hl
	ld	a, [hl]
	call	_HandleCtrlKey
;src/editor/editor.c:666: return;
	jp	.l00168
.l00117:
;src/editor/editor.c:669: else if (mods & KB_MOD_SHIFT) { // shift + movement selects
	push	hl
	ld	hl, sp+3
	bit	6, [hl]
	pop	hl
	jp	NZ,.l00343
	jp	.l00114
.l00343:
;src/editor/editor.c:670: if (!selecting) anchor = cursor;
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
;src/editor/editor.c:671: selecting = 1;
	ld	hl, _selecting
	ld	[hl], $01
;src/editor/editor.c:672: redraw = 1;
	ld	hl, _redraw
	ld	[hl], $01
	jp	.l00118
.l00114:
;src/editor/editor.c:674: else if (!ctrl && GetSelection() && (key == KEY_LEFT || key == KEY_RIGHT)) { // to that end of the selection
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
;src/editor/editor.c:675: cursor = key == KEY_LEFT ? sel_start : sel_end;
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
;src/editor/editor.c:676: ClearSelection();
	call	_ClearSelection
;src/editor/editor.c:677: moved = 1;
	ld	hl, _moved
	ld	[hl], $01
;src/editor/editor.c:678: return;
	jp	.l00168
.l00108:
;src/editor/editor.c:680: else ClearSelection();
	push	bc
	call	_ClearSelection
	pop	bc
.l00118:
;src/editor/editor.c:681: moved = 1;
	ld	hl, _moved
	ld	[hl], $01
;src/editor/editor.c:682: if (ctrl) {
	ld	hl, sp+0
	ld	a, [hl]
	or	a, a
	jp	Z, .l00128
;src/editor/editor.c:683: switch (key) {
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
;src/editor/editor.c:684: case KEY_LEFT: WordLeft(); return;
.l00120:
	call	_WordLeft
	jp	.l00168
;src/editor/editor.c:685: case KEY_RIGHT: WordRight(); return;
.l00121:
	call	_WordRight
	jp	.l00168
;src/editor/editor.c:686: case KEY_UP: ScrollLine(0); return;
.l00122:
	xor	a, a
	call	_ScrollLine
	jp	.l00168
;src/editor/editor.c:687: case KEY_DOWN: ScrollLine(1); return;
.l00123:
	ld	a, $01
	call	_ScrollLine
	jp	.l00168
;src/editor/editor.c:688: case KEY_HOME: cursor = 0; return;
.l00124:
	xor	a, a
	ld	hl, _cursor
	ld	[hl], a
	inc	hl
	ld	[hl], a
	jp	.l00168
;src/editor/editor.c:689: case KEY_END: cursor = tb_Length(); return;
.l00125:
	call	_tb_Length
	ld	hl, _cursor
	ld	[hl], c
	inc	hl
	ld	[hl], b
	jp	.l00168
;src/editor/editor.c:690: }
.l00128:
;src/editor/editor.c:692: switch (key) {
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
;src/editor/editor.c:693: case KEY_UP: MoveUp(); return;
.l00129:
	call	_MoveUp
	jp	.l00168
;src/editor/editor.c:694: case KEY_DOWN: MoveDown(); return;
.l00130:
	call	_MoveDown
	jp	.l00168
;src/editor/editor.c:695: case KEY_PAGE_UP: PageUp(); return;
.l00131:
	call	_PageUp
	jp	.l00168
;src/editor/editor.c:696: case KEY_PAGE_DOWN: PageDown(); return;
.l00132:
	call	_PageDown
	jp	.l00168
;src/editor/editor.c:697: case KEY_LEFT: if (cursor) --cursor; return;
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
;src/editor/editor.c:698: case KEY_RIGHT: if (cursor != tb_Length()) ++cursor; return;
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
;src/editor/editor.c:699: case KEY_HOME: cursor = tb_row_starts[tb_found_row]; return;
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
;src/editor/editor.c:700: case KEY_END: MoveEnd(); return;
.l00140:
	call	_MoveEnd
	jp	.l00168
;src/editor/editor.c:701: }
.l00141:
;src/editor/editor.c:702: moved = 0;
	ld	hl, _moved
	ld	[hl], $00
;src/editor/editor.c:703: if (key == KEY_ESCAPE || key == KEY_INSERT) return;
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
;src/editor/editor.c:704: if (GetSelection()) { // typing replaces the selection
	call	_GetSelection
	or	a, a
	jp	Z, .l00149
;src/editor/editor.c:705: DeleteSelection();
	call	_DeleteSelection
;src/editor/editor.c:706: if (key == KEY_BACKSPACE || key == KEY_DELETE) return;
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
;src/editor/editor.c:708: selecting = 0;
	ld	hl, _selecting
	ld	[hl], $00
;src/editor/editor.c:709: switch (key) {
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
;src/editor/editor.c:710: case KEY_BACKSPACE:
.l00150:
;src/editor/editor.c:711: if (cursor && (c = tb_Delete(cursor - 1))) {
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
;src/editor/editor.c:712: CountEdit(cursor - 1, c, 0);
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
;src/editor/editor.c:713: Edited(--cursor, -1);
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
;src/editor/editor.c:715: break;
	jp	.l00168
;src/editor/editor.c:716: case KEY_DELETE:
.l00154:
;src/editor/editor.c:717: if ((c = tb_Delete(cursor))) {
	ld	hl, _cursor
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_tb_Delete
	ld	c, a
	or	a, a
	jp	Z, .l00168
;src/editor/editor.c:718: CountEdit(cursor, c, 0);
	xor	a, a
	push	af
	inc	sp
	ld	a, c
	ld	hl, _cursor
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_CountEdit
;src/editor/editor.c:719: Edited(cursor, -1);
	ld	a, $FF
	ld	hl, _cursor
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_Edited
;src/editor/editor.c:721: break;
	jp	.l00168
;src/editor/editor.c:722: default:
.l00157:
;src/editor/editor.c:723: if (key < ' ' && key != ASCII_TAB && key != ASCII_LF) return;
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
;src/editor/editor.c:724: if (key >= KEY_LEFT && key < 0xA0) return; // unprintable in Latin-1
	ld	hl, sp+2
	ld	a, [hl]
	sub	a, $80
	jp	C, .l00163
	ld	a, [hl]
	sub	a, $A0
	jp	NC, .l00163
	jp	.l00168
.l00163:
;src/editor/editor.c:725: if (tb_Insert(cursor, key)) {
	ld	hl, sp+2
	ld	a, [hl]
	ld	hl, _cursor
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_tb_Insert
	or	a, a
	jp	Z, .l00168
;src/editor/editor.c:726: CountEdit(cursor, key, 1);
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
;src/editor/editor.c:727: Edited(cursor++, 1);
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
;src/editor/editor.c:729: }
.l00168:
;src/editor/editor.c:730: }
	add	sp, 3
	ret
;src/editor/editor.c:733: static unsigned char DpadRepeat(unsigned char pressed) {
;	---------------------------------
; Function DpadRepeat
; ---------------------------------
_DpadRepeat:
	ld	c, a
;src/editor/editor.c:734: unsigned char held = (button_state | pressed) & PADF_DPAD;
	ld	hl, _button_state
	ld	a, [hl]
	or	a, c
	and	a, $F0
	ld	b, a
;src/editor/editor.c:735: if (!held) return 0;
	or	a, a
	jp	NZ, .l00102
	xor	a, a
	jp	.l00109
.l00102:
;src/editor/editor.c:736: if (pressed & PADF_DPAD) pad_timer = PAD_REPEAT_DELAY;
	ld	a, c
	and	a, $F0
	jp	NZ,.l00126
	jp	.l00107
.l00126:
	ld	hl, _pad_timer
	ld	[hl], $14
	jp	.l00108
.l00107:
;src/editor/editor.c:737: else if (--pad_timer) return 0;
	ld	hl, _pad_timer
	dec	[hl]
	ld	a, [hl]
	or	a, a
	jp	Z, .l00104
	xor	a, a
	jp	.l00109
.l00104:
;src/editor/editor.c:738: else pad_timer = PAD_REPEAT_RATE;
	ld	hl, _pad_timer
	ld	[hl], $04
.l00108:
;src/editor/editor.c:739: return held;
	ld	a, b
.l00109:
;src/editor/editor.c:740: }
	ret
;src/editor/editor.c:743: static void SetRows(void) {
;	---------------------------------
; Function SetRows
; ---------------------------------
_SetRows:
;src/editor/editor.c:744: bars = bars_on;
	ld	hl, _bars_on
	ld	a, [hl]
	ld	hl, _bars
	ld	[hl], a
;src/editor/editor.c:745: tb_rows = TextRows();
	call	_TextRows
	ld	hl, _tb_rows
	ld	[hl], a
;src/editor/editor.c:746: Layout();
	call	_Layout
;src/editor/editor.c:747: if (osk_shown) {
	ld	hl, _osk_shown
	ld	a, [hl]
	or	a, a
	jp	Z, .l00102
;src/editor/editor.c:748: OSKDraw(osk_layer, tb_rows);
	ld	hl, _tb_rows
	ld	e, [hl]
	ld	hl, _osk_layer
	ld	a, [hl]
	call	_OSKDraw
;src/editor/editor.c:749: OSKSelect(osk_x, osk_y);
	ld	hl, _osk_y
	ld	e, [hl]
	ld	hl, _osk_x
	ld	a, [hl]
	call	_OSKSelect
.l00102:
;src/editor/editor.c:751: OSKShow(osk_shown);
	ld	hl, _osk_shown
	ld	a, [hl]
	call	_OSKShow
;src/editor/editor.c:752: dirty = 1;
	ld	hl, _dirty
	ld	[hl], $01
.l00103:
;src/editor/editor.c:753: }
	ret
;src/editor/editor.c:755: static void ToggleOSK(void) {
;	---------------------------------
; Function ToggleOSK
; ---------------------------------
_ToggleOSK:
;src/editor/editor.c:756: osk_shown = !osk_shown;
	ld	hl, _osk_shown
	ld	a, [hl]
	sub	a,$01
	ld	a, $00
	rla
	ld	[hl], a
;src/editor/editor.c:757: SetRows();
	jp	_SetRows
.l00101:
;src/editor/editor.c:758: }
	ret
;src/editor/editor.c:761: static void ToggleBars(void) {
;	---------------------------------
; Function ToggleBars
; ---------------------------------
_ToggleBars:
;src/editor/editor.c:762: bars_on = !bars_on;
	ld	hl, _bars_on
	ld	a, [hl]
	sub	a,$01
	ld	a, $00
	rla
	ld	[hl], a
;src/editor/editor.c:763: SetRows();
	jp	_SetRows
.l00101:
;src/editor/editor.c:764: }
	ret
;src/editor/editor.c:766: static void SetOSKLayer(unsigned char layer) {
;	---------------------------------
; Function SetOSKLayer
; ---------------------------------
_SetOSKLayer:
	ld	c, a
;src/editor/editor.c:767: osk_layer = osk_layer == layer ? OSK_LOWER : layer;
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
;src/editor/editor.c:768: OSKDraw(osk_layer, tb_rows);
	ld	hl, _tb_rows
	ld	e, [hl]
	ld	hl, _osk_layer
	ld	a, [hl]
	call	_OSKDraw
;src/editor/editor.c:769: dirty = 1;
	ld	hl, _dirty
	ld	[hl], $01
.l00101:
;src/editor/editor.c:770: }
	ret
;src/editor/editor.c:772: static unsigned char PressOSKKey(void) {
;	---------------------------------
; Function PressOSKKey
; ---------------------------------
_PressOSKKey:
;src/editor/editor.c:774: if (osk_y == OSK_ROWS - 1) {
	ld	hl, _osk_y
	ld	a, [hl]
	sub	a, $04
	jp	NZ,.l00157
	jp	.l00158
.l00157:
	jp	.l00117
.l00158:
;src/editor/editor.c:775: if (osk_x == 0) SetOSKLayer(OSK_SHIFT);
	ld	hl, _osk_x
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00114
	ld	a, $01
	call	_SetOSKLayer
	jp	.l00115
.l00114:
;src/editor/editor.c:776: else if (osk_x == 1) SetOSKLayer(OSK_SYMBOLS);
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
;src/editor/editor.c:777: else if (osk_x == OSK_COLS - 3) return KEY_MENU;
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
;src/editor/editor.c:778: else if (osk_x == OSK_COLS - 2) return KEY_LEFT;
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
;src/editor/editor.c:779: else if (osk_x == OSK_COLS - 1) return KEY_RIGHT;
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
;src/editor/editor.c:780: else return ' ';
	ld	a, $20
	jp	.l00120
.l00115:
;src/editor/editor.c:781: return KEY_NONE;
	xor	a, a
	jp	.l00120
.l00117:
;src/editor/editor.c:783: key = OSKGetKey(osk_layer, (osk_y << 3) + (osk_y << 1) + osk_x);
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
;src/editor/editor.c:784: if (osk_layer == OSK_SHIFT) SetOSKLayer(OSK_SHIFT); // shift is one shot
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
;src/editor/editor.c:785: return key;
	ld	a, c
.l00120:
;src/editor/editor.c:786: }
	ret
;src/editor/editor.c:788: static void MoveOSKSelection(unsigned char held) {
;	---------------------------------
; Function MoveOSKSelection
; ---------------------------------
_MoveOSKSelection:
	ld	c, a
;src/editor/editor.c:789: if (held & PADF_UP) osk_y = osk_y ? osk_y - 1 : OSK_ROWS - 1;
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
;src/editor/editor.c:790: else if (held & PADF_DOWN) osk_y = osk_y == OSK_ROWS - 1 ? 0 : osk_y + 1;
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
;src/editor/editor.c:791: if (held & PADF_LEFT) osk_x = osk_x ? osk_x - 1 : OSK_COLS - 1;
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
;src/editor/editor.c:792: else if (held & PADF_RIGHT) osk_x = osk_x == OSK_COLS - 1 ? 0 : osk_x + 1;
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
;src/editor/editor.c:793: OSKSelect(osk_x, osk_y);
	ld	hl, _osk_y
	ld	e, [hl]
	ld	hl, _osk_x
	ld	a, [hl]
	jp	_OSKSelect
.l00111:
;src/editor/editor.c:794: }
	ret
;src/editor/editor.c:798: static unsigned char PadKey(void) {
;	---------------------------------
; Function PadKey
; ---------------------------------
_PadKey:
;src/editor/editor.c:799: unsigned char pressed = PadPressed();
	call	_PadPressed
	ld	c, a
;src/editor/editor.c:801: if (pressed & PADF_SELECT) ToggleOSK();
	bit	2, c
	jp	NZ,.l00172
	jp	.l00102
.l00172:
	push	bc
	call	_ToggleOSK
	pop	bc
.l00102:
;src/editor/editor.c:802: if (pressed & PADF_B) return KEY_BACKSPACE;
	bit	1, c
	jp	NZ,.l00173
	jp	.l00104
.l00173:
	ld	a, $08
	jp	.l00120
.l00104:
;src/editor/editor.c:803: if (pressed & PADF_START) return KEY_ENTER;
	bit	3, c
	jp	NZ,.l00174
	jp	.l00106
.l00174:
	ld	a, $0A
	jp	.l00120
.l00106:
;src/editor/editor.c:804: if (osk_shown && (pressed & PADF_A)) return PressOSKKey();
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
;src/editor/editor.c:805: held = DpadRepeat(pressed);
	ld	a, c
	call	_DpadRepeat
	ld	c, a
;src/editor/editor.c:806: if (!held) return KEY_NONE;
	ld	a, c
	or	a, a
	jp	NZ, .l00111
	xor	a, a
	jp	.l00120
.l00111:
;src/editor/editor.c:807: if (osk_shown) {
	ld	hl, _osk_shown
	ld	a, [hl]
	or	a, a
	jp	Z, .l00113
;src/editor/editor.c:808: MoveOSKSelection(held);
	ld	a, c
	call	_MoveOSKSelection
;src/editor/editor.c:809: return KEY_NONE;
	xor	a, a
	jp	.l00120
.l00113:
;src/editor/editor.c:811: if (held & PADF_UP) return KEY_UP;
	bit	6, c
	jp	NZ,.l00176
	jp	.l00115
.l00176:
	ld	a, $82
	jp	.l00120
.l00115:
;src/editor/editor.c:812: if (held & PADF_DOWN) return KEY_DOWN;
	bit	7, c
	jp	NZ,.l00177
	jp	.l00117
.l00177:
	ld	a, $83
	jp	.l00120
.l00117:
;src/editor/editor.c:813: if (held & PADF_LEFT) return KEY_LEFT;
	bit	5, c
	jp	NZ,.l00178
	jp	.l00119
.l00178:
	ld	a, $80
	jp	.l00120
.l00119:
;src/editor/editor.c:814: return KEY_RIGHT;
	ld	a, $81
.l00120:
;src/editor/editor.c:815: }
	ret
;src/editor/editor.c:818: static unsigned char MenuKey(void) {
;	---------------------------------
; Function MenuKey
; ---------------------------------
_MenuKey:
;src/editor/editor.c:820: WaitFrame();
	call	_WaitFrame
;src/editor/editor.c:821: if ((key = (unsigned char)KBPopEvent())) return key;
	call	_KBPopEvent
	ld	a, c
	ld	c, a
	or	a, a
	jp	Z, .l00102
	ld	a, c
	jp	.l00115
.l00102:
;src/editor/editor.c:822: pressed = PadPressed();
	call	_PadPressed
	ld	c, a
;src/editor/editor.c:823: if (pressed & (PADF_A | PADF_START)) return KEY_ENTER;
	ld	a, c
	and	a, $09
	jp	NZ,.l00152
	jp	.l00104
.l00152:
	ld	a, $0A
	jp	.l00115
.l00104:
;src/editor/editor.c:824: if (pressed & PADF_B) return KEY_ESCAPE;
	bit	1, c
	jp	NZ,.l00153
	jp	.l00106
.l00153:
	ld	a, $1B
	jp	.l00115
.l00106:
;src/editor/editor.c:825: held = DpadRepeat(pressed);
	ld	a, c
	call	_DpadRepeat
;src/editor/editor.c:826: if (held & PADF_UP) return KEY_UP;
	bit	6, a
	jp	NZ,.l00154
	jp	.l00108
.l00154:
	ld	a, $82
	jp	.l00115
.l00108:
;src/editor/editor.c:827: if (held & PADF_DOWN) return KEY_DOWN;
	bit	7, a
	jp	NZ,.l00155
	jp	.l00110
.l00155:
	ld	a, $83
	jp	.l00115
.l00110:
;src/editor/editor.c:828: if (held & PADF_LEFT) return KEY_LEFT;
	bit	5, a
	jp	NZ,.l00156
	jp	.l00112
.l00156:
	ld	a, $80
	jp	.l00115
.l00112:
;src/editor/editor.c:829: if (held & PADF_RIGHT) return KEY_RIGHT;
	bit	4, a
	jp	NZ,.l00157
	jp	.l00114
.l00157:
	ld	a, $81
	jp	.l00115
.l00114:
;src/editor/editor.c:830: return KEY_NONE;
	xor	a, a
.l00115:
;src/editor/editor.c:831: }
	ret
;src/editor/editor.c:833: static char* RowAddress(unsigned char row) {
;	---------------------------------
; Function RowAddress
; ---------------------------------
_RowAddress:
	ld	e, a
;src/editor/editor.c:834: unsigned int offset = row;
	ld	d, $00
;src/editor/editor.c:835: return (char*)tile_buffer + (offset << 5) + (offset << 3); // row * TB_STRIDE
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
;src/editor/editor.c:836: }
	ret
;src/editor/editor.c:839: static void DrawRow(unsigned char row, unsigned char col, const char* text) {
;	---------------------------------
; Function DrawRow
; ---------------------------------
_DrawRow:
	dec	sp
	dec	sp
	ld	c, a
	ld	hl, sp+1
	ld	[hl], e
;src/editor/editor.c:840: char* dest = RowAddress(row);
	ld	a, c
	call	_RowAddress
;src/editor/editor.c:842: for (i = 0; i < TB_STRIDE; ++i) dest[i] = ' ';
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
;src/editor/editor.c:843: for (dest += col; *text && col < TB_STRIDE; ++col) *dest++ = *text++;
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
;src/editor/editor.c:844: }
	inc	sp
	inc	sp
	pop	hl
	inc	sp
	inc	sp
	jp hl 
;src/editor/editor.c:846: static void ClearScreen(void) {
;	---------------------------------
; Function ClearScreen
; ---------------------------------
_ClearScreen:
;src/editor/editor.c:848: for (row = 0; row < TB_ROWS; ++row) DrawRow(row, 0, "");
	ld	c, $00
.l00102:
	push	bc
	ld	de, ___str_33
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
;src/editor/editor.c:849: }
	ret
___str_33:
	DB $00
;src/editor/editor.c:852: static void BeginFullScreen(void) {
;	---------------------------------
; Function BeginFullScreen
; ---------------------------------
_BeginFullScreen:
;src/editor/editor.c:853: EditorShowCursor(0);
	xor	a, a
	call	_EditorShowCursor
;src/editor/editor.c:854: if (osk_shown) OSKShow(0);
	ld	hl, _osk_shown
	ld	a, [hl]
	or	a, a
	jp	Z, .l00102
	xor	a, a
	call	_OSKShow
.l00102:
;src/editor/editor.c:855: bars = 0;
	ld	hl, _bars
	ld	[hl], $00
;src/editor/editor.c:856: tb_rows = TB_ROWS;
	ld	hl, _tb_rows
	ld	[hl], $12
;src/editor/editor.c:857: Layout();
	call	_Layout
;src/editor/editor.c:858: NoHighlight();
	call	_NoHighlight
;src/editor/editor.c:859: dirty = 1;
	ld	hl, _dirty
	ld	[hl], $01
.l00103:
;src/editor/editor.c:860: }
	ret
;src/editor/editor.c:862: static void EndFullScreen(void) {
;	---------------------------------
; Function EndFullScreen
; ---------------------------------
_EndFullScreen:
;src/editor/editor.c:863: SetRows();
	jp	_SetRows
.l00101:
;src/editor/editor.c:864: }
	ret
;src/editor/editor.c:867: static void OpenBox(unsigned char lines) {
;	---------------------------------
; Function OpenBox
; ---------------------------------
_OpenBox:
	ld	e, a
;src/editor/editor.c:868: char* line = RowAddress(BOX_LINE);
	push	de
	ld	a, $14
	call	_RowAddress
	pop	de
;src/editor/editor.c:869: unsigned char i, width, widest = 0;
	ld	d, $00
;src/editor/editor.c:870: for (i = 0; i < lines; ++i, line += BOX_STRIDE) {
	ld	l, $00
;	spillPairReg hl
;	spillPairReg hl
.l00105:
	ld	a, l
	sub	a, e
	jp	NC, .l00103
;src/editor/editor.c:871: width = RenderTextWidth(line);
	push	hl
	push	bc
	push	de
	ld	e, c
	ld	d, b
	call	_RenderTextWidth
	pop	de
	pop	bc
	pop	hl
	ld	h, a
;	spillPairReg hl
;	spillPairReg hl
;src/editor/editor.c:872: if (width > widest) widest = width;
	ld	a, d
	sub	a, h
	jp	NC, .l00106
	ld	d, h
.l00106:
;src/editor/editor.c:870: for (i = 0; i < lines; ++i, line += BOX_STRIDE) {
	inc	l
	ld	a, c
	add	a, $14
	ld	c, a
	jp	NC, .l00125
	inc	b
.l00125:
	jp	.l00105
.l00103:
;src/editor/editor.c:874: render_box_text = RowAddress(BOX_LINE);
	push	de
	ld	a, $14
	call	_RowAddress
	pop	de
	ld	hl, _render_box_text
	ld	[hl], c
	inc	hl
	ld	[hl], b
;src/editor/editor.c:875: render_box_w = widest + BOX_PADDING;
	ld	a, d
	add	a, $09
	ld	hl, _render_box_w
	ld	[hl], a
;src/editor/editor.c:876: render_box_x = (TB_WIDTH - render_box_w) >> 1;
	ld	c, [hl]
	ld	b, $00
	ld	a, $A0
	sub	a, c
	ld	c, a
	sbc	a, a
	sub	a, b
	ld	b, a
	sra	b
	rr	c
	ld	hl, _render_box_x
	ld	[hl], c
;src/editor/editor.c:877: render_box_rows = lines + 2; // half rows above and below
	ld	a, e
	add	a, $02
	ld	hl, _render_box_rows
	ld	[hl], a
;src/editor/editor.c:878: render_box_top = (TB_ROWS - render_box_rows) >> 1;
	ld	c, [hl]
	ld	b, $00
	ld	a, $12
	sub	a, c
	ld	c, a
	sbc	a, a
	sub	a, b
	ld	b, a
	sra	b
	rr	c
	ld	hl, _render_box_top
	ld	[hl], c
;src/editor/editor.c:879: render_box_sel = 0xFF;
	ld	hl, _render_box_sel
	ld	[hl], $FF
;src/editor/editor.c:880: ++render_box_gen;
	ld	hl, _render_box_gen
	inc	[hl]
.l00107:
;src/editor/editor.c:881: }
	ret
;src/editor/editor.c:884: static void ShowBusy(const char* text) {
;	---------------------------------
; Function ShowBusy
; ---------------------------------
_ShowBusy:
	ld	c, e
	ld	b, d
;src/editor/editor.c:885: CopyName(RowAddress(BOX_LINE), text);
	push	bc
	ld	a, $14
	call	_RowAddress
	ld	e, c
	ld	d, b
	pop	bc
	call	_CopyName
;src/editor/editor.c:886: OpenBox(1);
	ld	a, $01
	call	_OpenBox
;src/editor/editor.c:887: EditorDraw();
	jp	_EditorDraw
.l00101:
;src/editor/editor.c:888: }
	ret
;src/editor/editor.c:890: static void HideBox(void) {
;	---------------------------------
; Function HideBox
; ---------------------------------
_HideBox:
;src/editor/editor.c:891: render_box_top = 0xFF;
	ld	hl, _render_box_top
	ld	[hl], $FF
.l00101:
;src/editor/editor.c:892: }
	ret
;src/editor/editor.c:895: static unsigned char Choose(const char* title, const char* items, unsigned char count) {
;	---------------------------------
; Function Choose
; ---------------------------------
_Choose:
	add	sp, -6
	ld	hl, sp+1
	ld	[hl], e
	inc	hl
	ld	[hl], d
;src/editor/editor.c:896: char* line = RowAddress(BOX_LINE);
	push	bc
	ld	a, $14
	call	_RowAddress
	ld	e, c
	ld	d, b
	pop	bc
;src/editor/editor.c:897: unsigned char i, key, selected = 0;
	ld	hl, sp+0
	ld	[hl], $00
;src/editor/editor.c:898: for (i = 0; i <= count; ++i, line += BOX_STRIDE) {
	ld	hl, sp+3
	ld	[hl], c
	inc	hl
	ld	[hl], b
	inc	hl
	ld	[hl], $00
.l00126:
;src/editor/editor.c:899: if (i) {
	ld	hl, sp+5
	ld	a, [hl]
	or	a, a
	jp	Z, .l00102
;src/editor/editor.c:900: line[0] = ' ';
	ld	a, $20
	ld	[de], a
;src/editor/editor.c:901: CopyName(line + 1, items);
	ld	l, e
;	spillPairReg hl
;	spillPairReg hl
	ld	h, d
;	spillPairReg hl
;	spillPairReg hl
	inc	hl
	push	de
	push	hl
	ld	hl, sp+7
	ld	c, [hl]
	pop	hl
	push	hl
	ld	hl, sp+8
	ld	b, [hl]
	pop	hl
	ld	e, l
	ld	d, h
	call	_CopyName
	pop	de
;src/editor/editor.c:902: items += ITEM_SIZE;
	push	de
	ld	hl, sp+6
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $000D
	add	hl, de
	pop	de
	push	hl
	ld	a, l
	ld	hl, sp+5
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+4
	ld	[hl], a
	jp	.l00127
.l00102:
;src/editor/editor.c:904: else CopyName(line, title);
	push	de
	ld	hl, sp+3
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	call	_CopyName
	pop	de
.l00127:
;src/editor/editor.c:898: for (i = 0; i <= count; ++i, line += BOX_STRIDE) {
	ld	hl, sp+5
	inc	[hl]
	ld	hl, $0014
	add	hl, de
	ld	e, l
	ld	d, h
	ld	hl, sp+8
	ld	a, [hl]
	ld	hl, sp+5
	sub	a, [hl]
	jp	NC, .l00126
;src/editor/editor.c:906: EditorShowCursor(0);
	xor	a, a
	call	_EditorShowCursor
;src/editor/editor.c:907: if (osk_shown) OSKShow(0);
	ld	hl, _osk_shown
	ld	a, [hl]
	or	a, a
	jp	Z, .l00106
	xor	a, a
	call	_OSKShow
.l00106:
;src/editor/editor.c:908: NoHighlight();
	call	_NoHighlight
;src/editor/editor.c:909: OpenBox(count + 1);
	ld	hl, sp+8
	ld	d, [hl]
	ld	c, d
	inc	c
	push	de
	ld	a, c
	call	_OpenBox
	pop	de
;src/editor/editor.c:910: while (1) {
	dec	d
.l00122:
;src/editor/editor.c:911: render_box_sel = selected + 2;
	ld	hl, sp+0
	ld	e, [hl]
	ld	a, e
	add	a, $02
	ld	hl, _render_box_sel
	ld	[hl], a
;src/editor/editor.c:912: EditorDraw();
	push	de
	call	_EditorDraw
	pop	de
;src/editor/editor.c:913: while (!(key = MenuKey()));
.l00107:
	push	de
	call	_MenuKey
	pop	de
	ld	hl, sp+5
	ld	[hl], a
	or	a, a
	jp	Z, .l00107
;src/editor/editor.c:914: if (key == KEY_UP) selected = selected ? selected - 1 : count - 1;
	ld	a, [hl]
	sub	a, $82
	jp	NZ,.l00205
	jp	.l00206
.l00205:
	jp	.l00119
.l00206:
	ld	hl, sp+0
	ld	a, [hl]
	or	a, a
	jp	Z, .l00130
	dec	e
	jp	.l00131
.l00130:
	ld	e, d
.l00131:
	ld	hl, sp+0
	ld	[hl], e
	jp	.l00122
.l00119:
;src/editor/editor.c:915: else if (key == KEY_DOWN) selected = selected == count - 1 ? 0 : selected + 1;
	ld	hl, sp+5
	ld	a, [hl]
	sub	a, $83
	jp	NZ,.l00207
	jp	.l00208
.l00207:
	jp	.l00116
.l00208:
	ld	hl, sp+8
	ld	c, [hl]
	ld	b, $00
	dec	bc
	ld	hl, sp+0
	ld	a, [hl]
	ld	hl, sp+4
	ld	[hl], a
	inc	hl
	ld	[hl], $00
	dec	hl
	ld	a, [hl]
	sub	a, c
	jp	NZ,.l00209
	inc	hl
	ld	a, [hl]
	sub	a, b
	jp	NZ,.l00209
	jp	.l00210
.l00209:
	jp	.l00132
.l00210:
	ld	bc, $0000
	jp	.l00133
.l00132:
	inc	e
	ld	a, e
	ld	c, a
	rlca
	sbc	a, a
	ld	b, a
.l00133:
	ld	hl, sp+0
	ld	[hl], c
	jp	.l00122
.l00116:
;src/editor/editor.c:916: else if (key == KEY_ENTER) break;
	ld	hl, sp+5
	ld	a, [hl]
	sub	a, $0A
	jp	NZ,.l00211
	jp	.l00123
.l00211:
;src/editor/editor.c:917: else if (key == KEY_ESCAPE) {
	ld	hl, sp+5
	ld	a, [hl]
	sub	a, $1B
	jp	NZ,.l00212
	jp	.l00213
.l00212:
	jp	.l00122
.l00213:
;src/editor/editor.c:918: selected = CANCEL;
	ld	hl, sp+0
	ld	[hl], $FF
;src/editor/editor.c:919: break;
.l00123:
;src/editor/editor.c:922: HideBox();
	call	_HideBox
;src/editor/editor.c:923: if (osk_shown) OSKShow(1);
	ld	hl, _osk_shown
	ld	a, [hl]
	or	a, a
	jp	Z, .l00125
	ld	a, $01
	call	_OSKShow
.l00125:
;src/editor/editor.c:924: dirty = 1;
	ld	hl, _dirty
	ld	[hl], $01
;src/editor/editor.c:925: return selected;
	ld	hl, sp+0
	ld	a, [hl]
.l00128:
;src/editor/editor.c:926: }
	add	sp, 6
	pop	hl
	inc	sp
	jp hl 
;src/editor/editor.c:929: static void ShowMessage(const char* text) {
;	---------------------------------
; Function ShowMessage
; ---------------------------------
_ShowMessage:
;src/editor/editor.c:930: HideBox();
	push	de
	call	_HideBox
	pop	de
;src/editor/editor.c:931: Render();
	push	de
	call	_Render
	pop	de
;src/editor/editor.c:932: EditorShowCursor(0);
	push	de
	xor	a, a
	call	_EditorShowCursor
	pop	de
;src/editor/editor.c:933: NoHighlight();
	push	de
	call	_NoHighlight
	pop	de
;src/editor/editor.c:934: if (bars) {
	ld	hl, _bars
	ld	a, [hl]
	or	a, a
	jp	Z, .l00102
;src/editor/editor.c:935: UpdateBars();
	push	de
	call	_UpdateBars
	pop	de
;src/editor/editor.c:936: DrawRow(STATUS_LINE, 1, text);
	push	de
	ld	e, $01
	ld	a, $13
	call	_DrawRow
	jp	.l00103
.l00102:
;src/editor/editor.c:938: else DrawRow(tb_rows - 1, 0, text);
	ld	hl, _tb_rows
	ld	c, [hl]
	dec	c
	push	de
	ld	e, $00
	ld	a, c
	call	_DrawRow
.l00103:
;src/editor/editor.c:939: EditorDraw();
	call	_EditorDraw
;src/editor/editor.c:940: while (!MenuKey());
.l00104:
	call	_MenuKey
	or	a, a
	jp	Z, .l00104
;src/editor/editor.c:941: dirty = 1;
	ld	hl, _dirty
	ld	[hl], $01
.l00107:
;src/editor/editor.c:942: }
	ret
;src/editor/editor.c:944: static void ShowError(unsigned char result, const char* denied) {
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
;src/editor/editor.c:945: char text[12] = "SD ERROR ";
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
;src/editor/editor.c:946: if (result == FR_NOT_READY) ShowMessage("NO SD CARD");
	ld	hl, sp+16
	ld	a, [hl]
	sub	a, $03
	jp	NZ,.l00140
	jp	.l00141
.l00140:
	jp	.l00111
.l00141:
	ld	de, ___str_35
	call	_ShowMessage
	jp	.l00113
.l00111:
;src/editor/editor.c:947: else if (result == FR_NO_FILESYSTEM) ShowMessage("NO FAT VOLUME");
	ld	hl, sp+16
	ld	a, [hl]
	sub	a, $0D
	jp	NZ,.l00142
	jp	.l00143
.l00142:
	jp	.l00108
.l00143:
	ld	de, ___str_36
	call	_ShowMessage
	jp	.l00113
.l00108:
;src/editor/editor.c:948: else if (result == FR_DENIED) ShowMessage(denied);
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
;src/editor/editor.c:950: text[9] = '0';
	ld	hl, sp+9
	ld	[hl], $30
;src/editor/editor.c:951: while (result >= 10) {
.l00101:
;src/editor/editor.c:953: result -= 10;
	ld	hl, sp+16
	ld	a, [hl]
	ld	hl, sp+12
	ld	[hl], a
;src/editor/editor.c:951: while (result >= 10) {
	ld	hl, sp+16
	ld	a, [hl]
	sub	a, $0A
	jp	C, .l00103
;src/editor/editor.c:952: ++text[9];
	ld	hl, sp+9
	ld	a, [hl]
	ld	hl, sp+13
	ld	[hl], a
	ld	a, [hl]
	inc	a
	ld	hl, sp+9
	ld	[hl], a
;src/editor/editor.c:953: result -= 10;
	ld	hl, sp+12
	ld	a, [hl]
	add	a, $F6
	ld	hl, sp+16
	ld	[hl], a
	jp	.l00101
.l00103:
;src/editor/editor.c:955: text[10] = '0' + result;
	ld	hl, sp+12
	ld	a, [hl]
	add	a, $30
	dec	hl
	dec	hl
	ld	[hl], a
;src/editor/editor.c:956: text[11] = 0;
	inc	hl
	ld	[hl], $00
;src/editor/editor.c:957: ShowMessage(text);
	ld	hl, 0
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_ShowMessage
.l00113:
;src/editor/editor.c:959: }
	add	sp, 17
	ret
___str_35:
	DB "NO SD CARD"
	DB $00
___str_36:
	DB "NO FAT VOLUME"
	DB $00
;src/editor/editor.c:961: static void CopyName(char* dest, const char* src) {
;	---------------------------------
; Function CopyName
; ---------------------------------
_CopyName:
;src/editor/editor.c:962: while ((*dest++ = *src++));
.l00101:
	ld	a, [bc]
	inc	bc
	ld	[de], a
	inc	de
	or	a, a
	jp	NZ, .l00101
.l00104:
;src/editor/editor.c:963: }
	ret
;src/editor/editor.c:966: static unsigned char CanDiscard(void) {
;	---------------------------------
; Function CanDiscard
; ---------------------------------
_CanDiscard:
;src/editor/editor.c:967: return !modified || Choose("DISCARD CHANGES?", discard_items[0], 2) == 1;
	ld	hl, _modified
	ld	a, [hl]
	or	a, a
	jp	Z, .l00104
	ld	a, $02
	push	af
	inc	sp
	ld	bc, _discard_items
	ld	de, ___str_37
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
;src/editor/editor.c:968: }
	ret
___str_37:
	DB "DISCARD CHANGES?"
	DB $00
;src/editor/editor.c:970: static void ResetCursor(void) {
;	---------------------------------
; Function ResetCursor
; ---------------------------------
_ResetCursor:
;src/editor/editor.c:971: cursor = 0;
	xor	a, a
	ld	hl, _cursor
	ld	[hl], a
	inc	hl
	ld	[hl], a
;src/editor/editor.c:972: counted_pos = 0;
	xor	a, a
	ld	hl, _counted_pos
	ld	[hl], a
	inc	hl
	ld	[hl], a
;src/editor/editor.c:973: counted_lines = 0;
	xor	a, a
	ld	hl, _counted_lines
	ld	[hl], a
	inc	hl
	ld	[hl], a
;src/editor/editor.c:974: selecting = 0;
	ld	hl, _selecting
	ld	[hl], $00
;src/editor/editor.c:975: top = 0;
	xor	a, a
	ld	hl, _top
	ld	[hl], a
	inc	hl
	ld	[hl], a
;src/editor/editor.c:976: want_x = 0;
	ld	hl, _want_x
	ld	[hl], $00
;src/editor/editor.c:977: modified = 0;
	ld	hl, _modified
	ld	[hl], $00
;src/editor/editor.c:978: dirty = 1;
	ld	hl, _dirty
	ld	[hl], $01
.l00101:
;src/editor/editor.c:979: }
	ret
;src/editor/editor.c:981: static void NewFile(void) {
;	---------------------------------
; Function NewFile
; ---------------------------------
_NewFile:
;src/editor/editor.c:982: if (!CanDiscard()) return;
	call	_CanDiscard
	or	a, a
	jp	NZ, .l00102
	jp	.l00103
.l00102:
;src/editor/editor.c:983: tb_Clear();
	call	_tb_Clear
;src/editor/editor.c:984: file_name[0] = 0;
	ld	hl, _file_name
	ld	[hl], $00
;src/editor/editor.c:985: fs_crlf = 0;
	ld	hl, _fs_crlf
	ld	[hl], $00
;src/editor/editor.c:986: ResetCursor();
	jp	_ResetCursor
.l00103:
;src/editor/editor.c:987: }
	ret
;src/editor/editor.c:990: static void ListRow(unsigned int index, unsigned int first, unsigned char kind, const char* name) {
;	---------------------------------
; Function ListRow
; ---------------------------------
_ListRow:
	add	sp, -7
;src/editor/editor.c:993: if (index < first || index >= first + LIST_ROWS) return;
	ld	a, e
	sub	a, c
	ld	a, d
	sbc	a, b
	jp	C, .l00101
	ld	hl, $0010
	add	hl, bc
	ld	a, e
	sub	a, l
	ld	a, d
	sbc	a, h
	jp	C, .l00102
.l00101:
	jp	.l00106
.l00102:
;src/editor/editor.c:994: row = (unsigned char)(index - first);
	ld	a, e
	sub	a, c
	ld	hl, sp+2
	ld	[hl], a
;src/editor/editor.c:995: list_kinds[row] = kind;
	ld	bc, _list_kinds+0
	ld	l, [hl]
	ld	h, $00
	add	hl, bc
	ld	c, l
	ld	b, h
	ld	hl, sp+9
	ld	a, [hl]
	ld	[bc], a
;src/editor/editor.c:996: list_sizes[row] = entry.size;
	ld	hl, sp+2
	ld	c, [hl]
	ld	b, $00
	ld	e, c
	ld	d, b
	sla	e
	rl	d
	sla	e
	rl	d
	ld	hl, _list_sizes
	add	hl, de
	inc	sp
	inc	sp
	push	hl
	ld	de, (_entry + 65) + 0
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
	pop	de
	push	de
	ld	hl, sp+3
	ld	a, [hl]
	ld	[de], a
	inc	de
	inc	hl
	ld	a, [hl]
	ld	[de], a
	inc	de
	inc	hl
	ld	a, [hl]
	ld	[de], a
	inc	de
	inc	hl
	ld	a, [hl]
	ld	[de], a
;src/editor/editor.c:997: list_dates[row] = entry.date;
	sla	c
	rl	b
	ld	hl, _list_dates
	add	hl, bc
	push	hl
	ld	a, l
	ld	hl, sp+5
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+4
	ld	[hl], a
	ld	de, (_entry + 69) + 0
	ld	a, [de]
	inc	hl
	ld	[hl], a
	inc	de
	ld	a, [de]
	inc	hl
	ld	[hl], a
	dec	hl
	dec	hl
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	inc	hl
	ld	a, [hl]
	ld	[de], a
	inc	de
	inc	hl
	ld	a, [hl]
	ld	[de], a
;src/editor/editor.c:998: list_times[row] = entry.time;
	ld	hl, _list_times
	add	hl, bc
	ld	c, l
	ld	b, h
	ld	de, (_entry + 71) + 0
	ld	a, [de]
	ld	hl, sp+5
	ld	[hl], a
	inc	de
	ld	a, [de]
	inc	hl
	ld	[hl], a
	dec	hl
	ld	a, [hl]
	ld	[bc], a
	inc	bc
	inc	hl
	ld	a, [hl]
	ld	[bc], a
;src/editor/editor.c:999: dest = ToLatin1(RowAddress(row) + 1, name, TB_STRIDE - 3);
	ld	hl, sp+2
	ld	a, [hl]
	call	_RowAddress
	ld	e, c
	ld	d, b
	inc	de
	ld	a, $25
	push	af
	inc	sp
	ld	hl, sp+11
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	call	_ToLatin1
;src/editor/editor.c:1000: if (kind == KIND_FOLDER) *dest = '/';
	ld	hl, sp+9
	ld	a, [hl]
	dec	a
	jp	NZ,.l00120
	jp	.l00121
.l00120:
	jp	.l00106
.l00121:
	ld	a, $2F
	ld	[bc], a
.l00106:
;src/editor/editor.c:1001: }
	add	sp, 7
	pop	hl
	add	sp, 3
	jp hl 
;src/editor/editor.c:1007: static unsigned int ListFolder(const char* path, unsigned int first, unsigned int stop, const char* find) {
;	---------------------------------
; Function ListFolder
; ---------------------------------
_ListFolder:
	add	sp, -9
	ld	hl, sp+4
	ld	[hl], e
	inc	hl
	ld	[hl], d
	ld	hl, sp+2
	ld	[hl], c
	inc	hl
	ld	[hl], b
;src/editor/editor.c:1008: unsigned int index = 0;
	xor	a, a
	ld	hl, sp+0
	ld	[hl], a
	inc	hl
	ld	[hl], a
;src/editor/editor.c:1010: if (first != LIST_ALL) for (pass = 0; pass < LIST_ROWS; ++pass) DrawRow(pass, 0, "");
	inc	hl
	ld	a, [hl]
	inc	hl
	and	a, [hl]
	inc	a
	jp	NZ,.l00241
	jp	.l00103
.l00241:
	ld	c, $00
.l00125:
	push	bc
	ld	de, ___str_38
	push	de
	ld	e, $00
	ld	a, c
	call	_DrawRow
	pop	bc
	inc	c
	ld	a, c
	sub	a, $10
	jp	C, .l00125
.l00103:
;src/editor/editor.c:1011: list_result = 0;
	ld	hl, _list_result
	ld	[hl], $00
;src/editor/editor.c:1012: entry.size = 0;
	ld	hl, (_entry + 65)
	xor	a, a
	ld	[hl], a
	inc	hl
	ld	[hl], a
	inc	hl
	ld	[hl], a
	inc	hl
	ld	[hl], a
;src/editor/editor.c:1013: if (path[0]) {
	ld	hl, sp+5
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	ld	hl, sp+8
	ld	[hl], a
	ld	a, [hl]
	or	a, a
	jp	Z, .l00156
;src/editor/editor.c:1014: if (!stop) return 0;
	ld	hl, sp+12
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	jp	NZ, .l00105
	ld	bc, $0000
	jp	.l00133
.l00105:
;src/editor/editor.c:1015: ListRow(index++, first, KIND_UP, "..");
	ld	hl, sp+0
	ld	[hl], $01
	xor	a, a
	inc	hl
	ld	[hl], a
	ld	de, ___str_39
	push	de
	xor	a, a
	push	af
	inc	sp
	inc	hl
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	ld	de, $0000
	call	_ListRow
;src/editor/editor.c:1017: for (pass = 0; pass < 2; ++pass) {
.l00156:
	ld	hl, sp+6
	ld	[hl], $00
.l00131:
;src/editor/editor.c:1018: if ((list_result = FileOpenDir(path))) return index;
	ld	hl, sp+4
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_FileOpenDir
	ld	hl, _list_result
	ld	[hl], a
	or	a, a
	jp	Z, .l00145
	pop	bc
	push	bc
	jp	.l00133
;src/editor/editor.c:1019: while (FileNext(&entry)) {
.l00145:
	ld	hl, sp+0
	ld	a, [hl]
	ld	hl, sp+7
	ld	[hl], a
	ld	hl, sp+1
	ld	a, [hl]
	ld	hl, sp+8
	ld	[hl], a
.l00121:
	ld	de, _entry
	call	_FileNext
	or	a, a
	jp	Z, .l00132
;src/editor/editor.c:1020: if (entry.dir == pass) continue; // folders on the first pass
	ld	hl, (_entry + 73) + 0
	ld	b, [hl]
	ld	hl, sp+6
	ld	a, [hl]
	sub	a, b
	jp	NZ,.l00242
	jp	.l00121
.l00242:
;src/editor/editor.c:1021: if (index == stop) return index;
	ld	hl, sp+7
	ld	a, [hl]
	ld	hl, sp+11
	sub	a, [hl]
	jp	NZ,.l00243
	ld	hl, sp+8
	ld	a, [hl]
	ld	hl, sp+12
	sub	a, [hl]
	jp	NZ,.l00243
	jp	.l00244
.l00243:
	jp	.l00113
.l00244:
	pop	bc
	push	bc
	jp	.l00133
.l00113:
;src/editor/editor.c:1022: if (find && entry.dir) {
	ld	hl, sp+14
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	jp	Z, .l00119
	ld	a, b
	or	a, a
	jp	Z, .l00119
;src/editor/editor.c:1023: for (i = 0; find[i] && find[i] == entry.name[i]; ++i);
	ld	e, $00
.l00129:
	push	de
	ld	d, $00
	ld	hl, sp+15
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	add	hl, de
	pop	de
	ld	c, l
	ld	b, h
	ld	a, [bc]
	ld	c, a
	ld	hl, _entry
	ld	d, $00
	add	hl, de
	ld	a, c
	or	a, a
	jp	Z, .l00114
	ld	b, [hl]
	ld	a, c
	sub	a, b
	jp	NZ,.l00245
	jp	.l00246
.l00245:
	jp	.l00114
.l00246:
	inc	e
	jp	.l00129
.l00114:
;src/editor/editor.c:1024: if (!find[i] && !entry.name[i]) return index;
	ld	a, c
	or	a, a
	jp	NZ, .l00119
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00119
	pop	bc
	push	bc
	jp	.l00133
.l00119:
;src/editor/editor.c:1026: ListRow(index, first, pass ? KIND_FILE : KIND_FOLDER, entry.name);
	ld	hl, sp+6
	ld	a, [hl]
	or	a, a
	jp	Z, .l00135
	ld	hl, sp+0
	ld	[hl], $02
	xor	a, a
	inc	hl
	ld	[hl], a
	jp	.l00136
.l00135:
	ld	hl, sp+0
	ld	[hl], $01
	xor	a, a
	inc	hl
	ld	[hl], a
.l00136:
	ld	hl, sp+0
	ld	a, [hl]
	inc	hl
	ld	[hl], a
	ld	de, _entry
	push	de
	ld	a, [hl]
	push	af
	inc	sp
	inc	hl
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	ld	hl, sp+10
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_ListRow
;src/editor/editor.c:1027: ++index;
	ld	hl, sp+7
	inc	[hl]
	jp	NZ, .l00247
	inc	hl
	inc	[hl]
.l00247:
	ld	hl, sp+7
	ld	a, [hl]
	ld	hl, sp+0
	ld	[hl], a
	ld	hl, sp+8
	ld	a, [hl]
	ld	hl, sp+1
	ld	[hl], a
	jp	.l00121
.l00132:
;src/editor/editor.c:1017: for (pass = 0; pass < 2; ++pass) {
	ld	hl, sp+6
	inc	[hl]
	ld	a, [hl]
	sub	a, $02
	jp	C, .l00131
;src/editor/editor.c:1030: return find ? 0 : index;
	ld	hl, sp+14
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	jp	Z, .l00137
	xor	a, a
	ld	hl, sp+7
	ld	[hl], a
	inc	hl
	ld	[hl], a
	jp	.l00138
.l00137:
	ld	hl, sp+0
	ld	a, [hl]
	ld	hl, sp+7
	ld	[hl], a
	ld	hl, sp+1
	ld	a, [hl]
	ld	hl, sp+8
	ld	[hl], a
.l00138:
	ld	hl, sp+7
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
.l00133:
;src/editor/editor.c:1031: }
	add	sp, 9
	pop	hl
	add	sp, 4
	jp hl 
___str_38:
	DB $00
___str_39:
	DB ".."
	DB $00
;src/editor/editor.c:1034: static void ListBars(const char* path, unsigned char row, unsigned char count) {
;	---------------------------------
; Function ListBars
; ---------------------------------
_ListBars:
	add	sp, -57
	ld	hl, sp+55
	ld	[hl], e
	inc	hl
	ld	[hl], d
	dec	hl
	dec	hl
	ld	[hl], a
;src/editor/editor.c:1036: char* end = text;
;src/editor/editor.c:1037: unsigned long size = list_sizes[row];
	ld	c, [hl]
	ld	b, $00
	ld	a, c
	ld	d, b
	add	a, a
	rl	d
	add	a, a
	rl	d
	ld	e, a
	ld	hl, _list_sizes
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+54
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+53
	ld	[hl], a
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	ld	hl, sp+40
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
;src/editor/editor.c:1038: unsigned char* bytes = (unsigned char*)&size;
;src/editor/editor.c:1039: unsigned int date = list_dates[row], time = list_times[row];
	sla	c
	rl	b
	ld	hl, _list_dates
	add	hl, bc
	ld	e, l
	ld	d, h
	ld	a, [de]
	ld	hl, sp+44
	ld	[hl], a
	inc	de
	ld	a, [de]
	inc	hl
	ld	[hl], a
	ld	hl, _list_times
	add	hl, bc
	ld	e, l
	ld	d, h
	ld	a, [de]
	ld	hl, sp+46
	ld	[hl], a
	inc	de
	ld	a, [de]
	inc	hl
	ld	[hl], a
;src/editor/editor.c:1040: PutPath(text, path, 30);
	ld	a, $1E
	push	af
	inc	sp
	ld	hl, sp+56
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	ld	hl, 1
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_PutPath
;src/editor/editor.c:1041: DrawRow(HEADER_LINE, 1, text);
	ld	hl, 0
	add	hl, sp
	push	hl
	ld	e, $01
	ld	a, $12
	call	_DrawRow
;src/editor/editor.c:1042: if (!count) end = PutText(end, "Empty folder");
	ld	hl, sp+59
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00116
	ld	bc, ___str_40
	ld	hl, 0
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_PutText
	ld	hl, sp+52
	ld	[hl], c
	inc	hl
	ld	[hl], b
	jp	.l00117
.l00116:
;src/editor/editor.c:1043: else if (list_kinds[row] == KIND_UP) end = PutText(end, "Parent folder");
	ld	de, _list_kinds
	ld	hl, sp+54
	ld	l, [hl]
	ld	h, $00
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, [bc]
	or	a, a
	jp	NZ, .l00113
	ld	bc, ___str_41
	ld	hl, 0
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_PutText
	ld	hl, sp+52
	ld	[hl], c
	inc	hl
	ld	[hl], b
	jp	.l00117
.l00113:
;src/editor/editor.c:1044: else if (list_kinds[row] == KIND_FOLDER) end = PutText(end, "Folder");
	dec	a
	jp	NZ,.l00152
	jp	.l00153
.l00152:
	jp	.l00110
.l00153:
	ld	bc, ___str_42
	ld	hl, 0
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_PutText
	ld	hl, sp+52
	ld	[hl], c
	inc	hl
	ld	[hl], b
	jp	.l00117
.l00110:
;src/editor/editor.c:1046: if (size < 10000) end = PutText(PutNumber(end, (unsigned int)size), " bytes  ");
	ld	hl, sp+40
	ld	a, [hl]
	sub	a, $10
	inc	hl
	ld	a, [hl]
	sbc	a, $27
	inc	hl
	ld	a, [hl]
	sbc	a, $00
	inc	hl
	ld	a, [hl]
	sbc	a, $00
	jp	NC, .l00105
	ld	hl, sp+40
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	ld	hl, 0
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_PutNumber
	ld	e, c
	ld	d, b
	ld	bc, ___str_43
	call	_PutText
	ld	hl, sp+48
	ld	[hl], c
	inc	hl
	ld	[hl], b
	jp	.l00106
.l00105:
;src/editor/editor.c:1047: else if (size < 10485760) end = PutText(PutNumber(end, (bytes[1] >> 2) | (bytes[2] << 6)), " KB  ");
	ld	hl, sp+42
	ld	c, [hl]
	dec	hl
	dec	hl
	ld	a, [hl]
	sub	a, $00
	inc	hl
	ld	a, [hl]
	sbc	a, $00
	inc	hl
	ld	a, [hl]
	sbc	a, $A0
	inc	hl
	ld	a, [hl]
	sbc	a, $00
	jp	NC, .l00102
	dec	hl
	dec	hl
	ld	a, [hl]
	rrca
	rrca
	and	a, $3F
	ld	l, c
;	spillPairReg hl
;	spillPairReg hl
	ld	h, $00
;	spillPairReg hl
;	spillPairReg hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	ld	b, $00
	or	a, l
	ld	c, a
	ld	a, b
	or	a, h
	ld	b, a
	ld	hl, 0
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_PutNumber
	ld	e, c
	ld	d, b
	ld	bc, ___str_44
	call	_PutText
	ld	hl, sp+48
	ld	[hl], c
	inc	hl
	ld	[hl], b
	jp	.l00106
.l00102:
;src/editor/editor.c:1048: else end = PutText(PutNumber(end, (bytes[2] >> 4) | (bytes[3] << 4)), " MB  ");
	ld	a, c
	swap	a
	and	a, $0F
	ld	hl, sp+53
	ld	[hl], a
	ld	hl, sp+43
	ld	a, [hl]
	ld	hl, sp+52
	ld	[hl], a
	ld	a, [hl]
	dec	hl
	ld	[hl], a
	inc	hl
	ld	[hl], $00
	dec	hl
	ld	a, [hl]
	ld	hl, sp+48
	ld	[hl], a
	ld	hl, sp+52
	ld	a, [hl]
	ld	hl, sp+49
	ld	[hl], a
	ld	a, $04
.l00154:
	ld	hl, sp+48
	sla	[hl]
	inc	hl
	rl	[hl]
	dec	a
	jp	NZ, .l00154
	ld	hl, sp+53
	ld	a, [hl]
	ld	hl, sp+50
	ld	[hl], a
	inc	hl
	ld	[hl], $00
	dec	hl
	ld	a, [hl]
	dec	hl
	dec	hl
	or	a, [hl]
	ld	hl, sp+52
	ld	[hl], a
	dec	hl
	ld	a, [hl]
	dec	hl
	dec	hl
	or	a, [hl]
	ld	hl, sp+53
	ld	[hl], a
	dec	hl
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	ld	hl, 0
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_PutNumber
	ld	e, c
	ld	d, b
	ld	bc, ___str_45
	call	_PutText
	ld	hl, sp+48
	ld	[hl], c
	inc	hl
	ld	[hl], b
.l00106:
;src/editor/editor.c:1049: end = PutNumber(end, (date >> 9) + 1980);
	ld	hl, sp+45
	ld	a, [hl]
	srl	a
	ld	hl, sp+50
	ld	[hl], a
	inc	hl
	ld	[hl], $00
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $07BC
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+54
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+53
	ld	[hl], a
	dec	hl
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	ld	hl, sp+48
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_PutNumber
;src/editor/editor.c:1050: *end++ = '-';
	ld	a, $2D
	ld	[bc], a
	ld	e, c
	ld	d, b
	inc	de
;src/editor/editor.c:1051: end = PutNumber2(end, (date >> 5) & 15);
	ld	hl, sp+45
	dec	hl
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	ld	a, $05
.l00155:
	srl	b
	rr	c
	dec	a
	jp	NZ, .l00155
	ld	a, c
	and	a, $0F
	ld	c, a
	ld	b, $00
	call	_PutNumber2
;src/editor/editor.c:1052: *end++ = '-';
	ld	a, $2D
	ld	[bc], a
	ld	e, c
	ld	d, b
	inc	de
;src/editor/editor.c:1053: end = PutNumber2(end, date & 31);
	ld	hl, sp+44
	ld	a, [hl]
	and	a, $1F
	ld	c, a
	ld	b, $00
	call	_PutNumber2
;src/editor/editor.c:1054: *end++ = ' ';
	ld	a, $20
	ld	[bc], a
	ld	e, c
	ld	d, b
	inc	de
;src/editor/editor.c:1055: end = PutNumber2(end, time >> 11);
	ld	hl, sp+47
	ld	a, [hl]
	swap	a
	rlca
	and	a, $1F
	ld	c, a
	ld	b, $00
	call	_PutNumber2
;src/editor/editor.c:1056: *end++ = ':';
	ld	a, $3A
	ld	[bc], a
	ld	e, c
	ld	d, b
	inc	de
;src/editor/editor.c:1057: end = PutNumber2(end, (time >> 5) & 63);
	ld	hl, sp+47
	dec	hl
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	ld	a, $05
.l00156:
	srl	b
	rr	c
	dec	a
	jp	NZ, .l00156
	ld	a, c
	and	a, $3F
	ld	c, a
	ld	b, $00
	call	_PutNumber2
	ld	hl, sp+52
	ld	[hl], c
	inc	hl
	ld	[hl], b
;src/editor/editor.c:1058: if (size > TB_SIZE) end = PutText(end, "  too big");
	ld	hl, sp+40
	ld	a, $D0
	sub	a, [hl]
	inc	hl
	ld	a, $5F
	sbc	a, [hl]
	inc	hl
	ld	a, $00
	sbc	a, [hl]
	inc	hl
	ld	a, $00
	sbc	a, [hl]
	jp	NC, .l00117
	ld	bc, ___str_46
	ld	hl, sp+52
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_PutText
	ld	hl, sp+52
	ld	[hl], c
	inc	hl
	ld	[hl], b
.l00117:
;src/editor/editor.c:1060: *end = 0;
	ld	hl, sp+52
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	ld	[hl], $00
;src/editor/editor.c:1061: DrawRow(STATUS_LINE, 1, text);
	ld	hl, 0
	add	hl, sp
	push	hl
	ld	e, $01
	ld	a, $13
	call	_DrawRow
.l00118:
;src/editor/editor.c:1062: }
	add	sp, 57
	pop	hl
	inc	sp
	jp hl 
___str_40:
	DB "Empty folder"
	DB $00
___str_41:
	DB "Parent folder"
	DB $00
___str_42:
	DB "Folder"
	DB $00
___str_43:
	DB " bytes  "
	DB $00
___str_44:
	DB " KB  "
	DB $00
___str_45:
	DB " MB  "
	DB $00
___str_46:
	DB "  too big"
	DB $00
;src/editor/editor.c:1066: static void ListLoading(const char* path, unsigned char row) {
;	---------------------------------
; Function ListLoading
; ---------------------------------
_ListLoading:
	add	sp, -128
	add	sp, -45
	ld	hl, 171
	add	hl, sp
	ld	[hl], e
	inc	hl
	ld	[hl], d
	dec	hl
	dec	hl
	ld	[hl], a
;src/editor/editor.c:1068: char* end = path[0] ? ToLatin1(text, path, PATH_SIZE - 1) : text;
	inc	hl
	inc	hl
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	ld	hl, 169
	add	hl, sp
	ld	[hl], a
	ld	a, [hl]
	or	a, a
	jp	Z, .l00114
	ld	a, $7F
	push	af
	inc	sp
	inc	hl
	inc	hl
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	ld	hl, 1
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_ToLatin1
	ld	e, c
	ld	d, b
	jp	.l00115
.l00114:
	ld	hl, 0
	add	hl, sp
	ld	e, l
	ld	d, h
.l00115:
	ld	hl, 168
	add	hl, sp
	ld	[hl], e
	inc	hl
	ld	[hl], d
;src/editor/editor.c:1072: *end++ = '/';
	dec	hl
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	inc	bc
;src/editor/editor.c:1071: if (row != 0xFF) {
	inc	hl
	ld	a, [hl]
	inc	a
	jp	NZ,.l00147
	jp	.l00105
.l00147:
;src/editor/editor.c:1072: *end++ = '/';
	ld	hl, 168
	add	hl, sp
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	ld	[hl], $2F
;src/editor/editor.c:1073: for (name = RowAddress(row) + 1; *name != '/'; ++name) *end++ = *name;
	push	bc
	ld	hl, 172
	add	hl, sp
	ld	a, [hl]
	call	_RowAddress
	ld	e, c
	ld	d, b
	pop	bc
	inc	de
.l00110:
	ld	a, [de]
	cp	a, $2F
	jp	NZ,.l00148
	jp	.l00122
.l00148:
	ld	[bc], a
	inc	bc
	inc	de
	jp	.l00110
.l00105:
;src/editor/editor.c:1075: else if (!path[0]) *end++ = '/';
	ld	hl, 172
	add	hl, sp
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	or	a, a
	jp	NZ, .l00106
	ld	hl, 168
	add	hl, sp
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	ld	[hl], $2F
	ld	hl, 168
	add	hl, sp
	ld	[hl], c
	inc	hl
	ld	[hl], b
;src/editor/editor.c:1085: ShowBusy("Loading...");
	jp	.l00106
;src/editor/editor.c:1075: else if (!path[0]) *end++ = '/';
.l00122:
	ld	hl, 168
	add	hl, sp
	ld	[hl], c
	inc	hl
	ld	[hl], b
.l00106:
;src/editor/editor.c:1076: *end = 0;
	ld	hl, 168
	add	hl, sp
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	ld	[hl], $00
;src/editor/editor.c:1077: length = (unsigned char)(end - text);
	ld	hl, sp+0
	ld	c, l
	ld	b, h
	ld	hl, 168
	add	hl, sp
	ld	a, [hl]
	ld	e, c
	sub	a, e
	ld	e, a
;src/editor/editor.c:1078: end = text;
;src/editor/editor.c:1079: if (length > 30) {
	ld	a, $1E
	sub	a, e
	jp	NC, .l00108
;src/editor/editor.c:1080: end += length - 33;
	ld	a, e
	ld	e, $00
	add	a, $DF
	ld	l, a
;	spillPairReg hl
;	spillPairReg hl
	ld	a, e
	adc	a, $FF
	ld	h, a
;	spillPairReg hl
;	spillPairReg hl
	add	hl, bc
	ld	c, l
	ld	b, h
;src/editor/editor.c:1081: end[0] = end[1] = end[2] = '.';
	ld	e, c
	ld	d, b
	inc	de
	ld	l, c
;	spillPairReg hl
;	spillPairReg hl
	ld	h, b
;	spillPairReg hl
;	spillPairReg hl
	inc	hl
	inc	hl
	ld	[hl], $2E
	ld	a, $2E
	ld	[de], a
	ld	a, $2E
	ld	[bc], a
.l00108:
;src/editor/editor.c:1083: DrawRow(HEADER_LINE, 1, end);
	push	bc
	ld	e, $01
	ld	a, $12
	call	_DrawRow
;src/editor/editor.c:1084: DrawRow(STATUS_LINE, 1, "");
	ld	de, ___str_47
	push	de
	ld	e, $01
	ld	a, $13
	call	_DrawRow
;src/editor/editor.c:1085: ShowBusy("Loading...");
	ld	de, ___str_48
	call	_ShowBusy
.l00112:
;src/editor/editor.c:1086: }
	add	sp, 127
	add	sp, 46
	ret
___str_47:
	DB $00
___str_48:
	DB "Loading..."
	DB $00
;src/editor/editor.c:1089: static void ListMessage(const char* text) {
;	---------------------------------
; Function ListMessage
; ---------------------------------
_ListMessage:
;src/editor/editor.c:1090: HideBox();
	push	de
	call	_HideBox
	pop	de
;src/editor/editor.c:1091: DrawRow(STATUS_LINE, 1, text);
	push	de
	ld	e, $01
	ld	a, $13
	call	_DrawRow
;src/editor/editor.c:1092: EditorDraw();
	call	_EditorDraw
;src/editor/editor.c:1093: while (!MenuKey());
.l00101:
	call	_MenuKey
	or	a, a
	jp	Z, .l00101
.l00104:
;src/editor/editor.c:1094: }
	ret
;src/editor/editor.c:1098: static unsigned char Browse(void) {
;	---------------------------------
; Function Browse
; ---------------------------------
_Browse:
	ld	hl, -272
	add	hl, sp
	ld	sp, hl
;src/editor/editor.c:1101: unsigned int count = 0, selected = 0, first = 0, drawn = LIST_ALL;
	xor	a, a
	ld	hl, 258
	add	hl, sp
	ld	[hl], a
	inc	hl
	ld	[hl], a
	xor	a, a
	ld	hl, 270
	add	hl, sp
	ld	[hl], a
	inc	hl
	ld	[hl], a
	xor	a, a
	ld	hl, 260
	add	hl, sp
	ld	[hl], a
	inc	hl
	ld	[hl], a
	inc	hl
	ld	[hl], $FF
	inc	hl
	ld	[hl], $FF
;src/editor/editor.c:1102: unsigned char key, result, row, opened = 0, editor_font = font, length;
	inc	hl
	ld	[hl], $00
	ld	hl, _font
	ld	a, [hl]
	ld	hl, 265
	add	hl, sp
	ld	[hl], a
;src/editor/editor.c:1103: CopyName(path, file_dir);
	ld	bc, _file_dir
	ld	hl, 0
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_CopyName
;src/editor/editor.c:1104: font = FONT_VWF;
	ld	hl, _font
	ld	[hl], $01
;src/editor/editor.c:1105: SetFont(font);
	ld	a, $01
	call	_SetFont
;src/editor/editor.c:1106: EditorShowCursor(0);
	xor	a, a
	call	_EditorShowCursor
;src/editor/editor.c:1107: if (osk_shown) OSKShow(0);
	ld	hl, _osk_shown
	ld	a, [hl]
	or	a, a
	jp	Z, .l00102
	xor	a, a
	call	_OSKShow
.l00102:
;src/editor/editor.c:1108: bars = 1;
	ld	hl, _bars
	ld	[hl], $01
;src/editor/editor.c:1109: tb_rows = LIST_ROWS;
	ld	hl, _tb_rows
	ld	[hl], $10
;src/editor/editor.c:1110: Layout();
	call	_Layout
;src/editor/editor.c:1111: NoHighlight();
	call	_NoHighlight
;src/editor/editor.c:1112: ListLoading(path, 0xFF);
	ld	a, $FF
	ld	hl, 0
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_ListLoading
;src/editor/editor.c:1113: if ((result = FileMount())) {
	call	_FileMount
	ld	c, a
	or	a, a
	jp	Z, .l00209
;src/editor/editor.c:1114: ShowError(result, "");
	ld	de, ___str_49
	ld	a, c
	call	_ShowError
;src/editor/editor.c:1115: selected = 0xFFFF; // skips the list
	ld	hl, 270
	add	hl, sp
	ld	[hl], $FF
	inc	hl
	ld	[hl], $FF
;src/editor/editor.c:1117: while (selected != 0xFFFF) {
.l00209:
.l00184:
	ld	hl, 270
	add	hl, sp
	ld	a, [hl]
	inc	hl
	and	a, [hl]
	inc	a
	jp	NZ,.l00432
	jp	.l00186
.l00432:
;src/editor/editor.c:1118: if (selected < first) first = selected;
	ld	hl, 270
	add	hl, sp
	ld	e, l
	ld	d, h
	ld	hl, 260
	add	hl, sp
	ld	a, [de]
	inc	de
	sub	a, [hl]
	inc	hl
	ld	a, [de]
	sbc	a, [hl]
	jp	NC, .l00108
	ld	hl, 270
	add	hl, sp
	ld	a, [hl]
	ld	hl, 260
	add	hl, sp
	ld	[hl], a
	ld	hl, 271
	add	hl, sp
	ld	a, [hl]
	ld	hl, 261
	add	hl, sp
	ld	[hl], a
	jp	.l00109
.l00108:
;src/editor/editor.c:1119: else if (selected >= first + LIST_ROWS) first = selected - LIST_ROWS + 1;
	ld	hl, 261
	add	hl, sp
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $0010
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, 270
	add	hl, sp
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, 269
	add	hl, sp
	ld	[hl], a
	ld	hl, 270
	add	hl, sp
	ld	e, l
	ld	d, h
	ld	hl, 268
	add	hl, sp
	ld	a, [de]
	inc	de
	sub	a, [hl]
	inc	hl
	ld	a, [de]
	sbc	a, [hl]
	jp	C, .l00109
	ld	hl, 271
	add	hl, sp
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $FFF1
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, 262
	add	hl, sp
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, 261
	add	hl, sp
	ld	[hl], a
.l00109:
;src/editor/editor.c:1120: if (first != drawn) {
	ld	hl, 260
	add	hl, sp
	ld	a, [hl]
	inc	hl
	inc	hl
	sub	a, [hl]
	jp	NZ,.l00433
	dec	hl
	ld	a, [hl]
	inc	hl
	inc	hl
	sub	a, [hl]
	jp	NZ,.l00433
	jp	.l00118
.l00433:
;src/editor/editor.c:1121: if (drawn == LIST_ALL && render_box_top == 0xFF) ListLoading(path, 0xFF); // a new folder
	ld	hl, 262
	add	hl, sp
	ld	a, [hl]
	inc	hl
	and	a, [hl]
	inc	a
	jp	NZ,.l00434
	jp	.l00435
.l00434:
	jp	.l00111
.l00435:
	ld	hl, _render_box_top
	ld	a, [hl]
	inc	a
	jp	NZ,.l00436
	jp	.l00437
.l00436:
	jp	.l00111
.l00437:
	ld	a, $FF
	ld	hl, 0
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_ListLoading
.l00111:
;src/editor/editor.c:1122: count = ListFolder(path, first, LIST_ALL, 0);
	ld	de, $0000
	push	de
	ld	de, $FFFF
	push	de
	ld	hl, 264
	add	hl, sp
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	ld	hl, 4
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_ListFolder
	ld	hl, 258
	add	hl, sp
	ld	[hl], c
	inc	hl
	ld	[hl], b
;src/editor/editor.c:1123: HideBox();
	call	_HideBox
;src/editor/editor.c:1124: drawn = first;
	ld	hl, 260
	add	hl, sp
	ld	a, [hl]
	inc	hl
	inc	hl
	ld	[hl], a
	dec	hl
	ld	a, [hl]
	inc	hl
	inc	hl
	ld	[hl], a
;src/editor/editor.c:1125: if (list_result) {
	ld	hl, _list_result
	ld	a, [hl]
	or	a, a
	jp	Z, .l00118
;src/editor/editor.c:1126: if (!path[0]) { // can't read the card
	ld	hl, sp+0
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00114
;src/editor/editor.c:1127: ShowError(list_result, "");
	ld	de, ___str_49
	ld	hl, _list_result
	ld	a, [hl]
	call	_ShowError
;src/editor/editor.c:1128: break;
	jp	.l00186
.l00114:
;src/editor/editor.c:1130: path[0] = 0; // folder is gone, back to the root
	ld	hl, sp+0
	ld	[hl], $00
;src/editor/editor.c:1131: selected = 0;
	xor	a, a
	ld	hl, 270
	add	hl, sp
	ld	[hl], a
	inc	hl
	ld	[hl], a
;src/editor/editor.c:1132: drawn = LIST_ALL;
	ld	hl, 262
	add	hl, sp
	ld	[hl], $FF
	inc	hl
	ld	[hl], $FF
;src/editor/editor.c:1133: continue;
	jp	.l00184
.l00118:
;src/editor/editor.c:1136: row = (unsigned char)(selected - first);
	ld	hl, 270
	add	hl, sp
	ld	a, [hl]
	ld	hl, 260
	add	hl, sp
	ld	c, [hl]
	sub	a, c
	ld	hl, 266
	add	hl, sp
	ld	[hl], a
;src/editor/editor.c:1137: ListBars(path, row, count);
	ld	hl, 258
	add	hl, sp
	ld	a, [hl]
	push	af
	inc	sp
	ld	hl, 267
	add	hl, sp
	ld	a, [hl]
	ld	hl, 1
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_ListBars
;src/editor/editor.c:1138: NoHighlight();
	call	_NoHighlight
;src/editor/editor.c:1139: if (count) render_sel[(row + 1) << 1] = 0, render_sel[((row + 1) << 1) + 1] = 0xFF;
	ld	hl, 259
	add	hl, sp
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	jp	Z, .l00120
	ld	hl, 266
	add	hl, sp
	ld	a, [hl]
	inc	a
	add	a, a
	ld	c, a
	ld	a, c
	ld	e, a
	rlca
	sbc	a, a
	ld	d, a
	ld	hl, _render_sel
	add	hl, de
	ld	[hl], $00
	inc	c
	ld	a, c
	rlca
	sbc	a, a
	ld	b, a
	ld	hl, _render_sel
	add	hl, bc
	ld	[hl], $FF
.l00120:
;src/editor/editor.c:1140: EditorDraw();
	call	_EditorDraw
;src/editor/editor.c:1141: while (!(key = MenuKey()));
.l00121:
	call	_MenuKey
	ld	hl, 267
	add	hl, sp
	ld	[hl], a
	or	a, a
	jp	Z, .l00121
;src/editor/editor.c:1142: if (key == KEY_UP && selected) --selected;
	ld	a, [hl]
	sub	a, $82
	jp	NZ,.l00438
	jp	.l00439
.l00438:
	jp	.l00181
.l00439:
	ld	hl, 271
	add	hl, sp
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	jp	Z, .l00181
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
	jp	.l00184
.l00181:
;src/editor/editor.c:1143: else if (key == KEY_DOWN && selected + 1 < count) ++selected;
	ld	hl, 267
	add	hl, sp
	ld	a, [hl]
	sub	a, $83
	jp	NZ,.l00440
	jp	.l00441
.l00440:
	jp	.l00177
.l00441:
	ld	hl, 270
	add	hl, sp
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	inc	bc
	ld	hl, 258
	add	hl, sp
	ld	a, c
	sub	a, [hl]
	inc	hl
	ld	a, b
	sbc	a, [hl]
	jp	NC, .l00177
	ld	hl, 270
	add	hl, sp
	ld	[hl], c
	inc	hl
	ld	[hl], b
	jp	.l00184
.l00177:
;src/editor/editor.c:1144: else if (key == KEY_PAGE_UP) selected = selected > LIST_ROWS ? selected - LIST_ROWS : 0;
	ld	hl, 267
	add	hl, sp
	ld	a, [hl]
	sub	a, $86
	jp	NZ,.l00442
	jp	.l00443
.l00442:
	jp	.l00174
.l00443:
	ld	hl, 270
	add	hl, sp
	ld	a, $10
	sub	a, [hl]
	inc	hl
	ld	a, $00
	sbc	a, [hl]
	jp	NC, .l00195
	ld	hl, 271
	add	hl, sp
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $0010
	ld	a, e
	sub	a, l
	ld	e, a
	ld	a, d
	sbc	a, h
	ld	hl, 269
	add	hl, sp
	ld	[hl], a
	dec	hl
	ld	[hl], e
	jp	.l00196
.l00195:
	xor	a, a
	ld	hl, 268
	add	hl, sp
	ld	[hl], a
	inc	hl
	ld	[hl], a
.l00196:
	ld	hl, 268
	add	hl, sp
	ld	a, [hl]
	inc	hl
	inc	hl
	ld	[hl], a
	dec	hl
	ld	a, [hl]
	inc	hl
	inc	hl
	ld	[hl], a
	jp	.l00184
.l00174:
;src/editor/editor.c:1145: else if (key == KEY_PAGE_DOWN && count) selected = selected + LIST_ROWS < count ? selected + LIST_ROWS : count - 1;
	ld	hl, 259
	add	hl, sp
	dec	hl
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	dec	bc
	ld	hl, 267
	add	hl, sp
	ld	a, [hl]
	sub	a, $87
	jp	NZ,.l00444
	jp	.l00445
.l00444:
	jp	.l00170
.l00445:
	ld	hl, 259
	add	hl, sp
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	jp	Z, .l00170
	ld	hl, 271
	add	hl, sp
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $0010
	add	hl, de
	ld	e, l
	ld	d, h
	ld	hl, 258
	add	hl, sp
	ld	a, e
	sub	a, [hl]
	inc	hl
	ld	a, d
	sbc	a, [hl]
	jp	NC, .l00197
	ld	c, e
	ld	b, d
	jp	.l00198
.l00197:
.l00198:
	ld	hl, 270
	add	hl, sp
	ld	[hl], c
	inc	hl
	ld	[hl], b
	jp	.l00184
.l00170:
;src/editor/editor.c:1146: else if (key == KEY_HOME) selected = 0;
	ld	hl, 267
	add	hl, sp
	ld	a, [hl]
	sub	a, $84
	jp	NZ,.l00446
	jp	.l00447
.l00446:
	jp	.l00167
.l00447:
	xor	a, a
	ld	hl, 270
	add	hl, sp
	ld	[hl], a
	inc	hl
	ld	[hl], a
	jp	.l00184
.l00167:
;src/editor/editor.c:1147: else if (key == KEY_END && count) selected = count - 1;
	ld	hl, 267
	add	hl, sp
	ld	a, [hl]
	sub	a, $85
	jp	NZ,.l00448
	jp	.l00449
.l00448:
	jp	.l00163
.l00449:
	ld	hl, 259
	add	hl, sp
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	jp	Z, .l00163
	ld	hl, 270
	add	hl, sp
	ld	[hl], c
	inc	hl
	ld	[hl], b
	jp	.l00184
.l00163:
;src/editor/editor.c:1148: else if ((key == KEY_ENTER || key == KEY_RIGHT) && count && list_kinds[row] != KIND_UP) {
	ld	hl, 267
	add	hl, sp
	ld	a, [hl]
	sub	a, $0A
	jp	NZ,.l00450
	ld	a,$01
	jp	.l00451
.l00450:
	xor	a,a
.l00451:
	ld	hl, 268
	add	hl, sp
	ld	[hl], a
	dec	hl
	ld	a, [hl]
	sub	a, $81
	jp	NZ,.l00452
	ld	a,$01
	jp	.l00453
.l00452:
	xor	a,a
.l00453:
	ld	hl, 269
	add	hl, sp
	ld	[hl], a
	dec	hl
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00160
	inc	hl
	ld	a, [hl]
	or	a, a
	jp	Z, .l00157
.l00160:
	ld	hl, 259
	add	hl, sp
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	jp	Z, .l00157
	ld	de, _list_kinds
	ld	hl, 266
	add	hl, sp
	ld	l, [hl]
	ld	h, $00
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, [bc]
	or	a, a
	jp	Z, .l00157
;src/editor/editor.c:1149: if (list_kinds[row] == KIND_FOLDER) ListLoading(path, row);
	dec	a
	jp	NZ,.l00454
	jp	.l00455
.l00454:
	jp	.l00125
.l00455:
	ld	hl, 266
	add	hl, sp
	ld	a, [hl]
	ld	hl, 0
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_ListLoading
	jp	.l00126
.l00125:
;src/editor/editor.c:1150: else ShowBusy("Loading...");
	ld	de, ___str_50
	call	_ShowBusy
.l00126:
;src/editor/editor.c:1151: ListFolder(path, LIST_ALL, selected, 0);
	ld	de, $0000
	push	de
	ld	hl, 272
	add	hl, sp
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	push	de
	ld	bc, $FFFF
	ld	hl, 4
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_ListFolder
;src/editor/editor.c:1152: for (length = 0; path[length]; ++length);
	ld	c, $00
.l00188:
	push	hl
	ld	hl, 2
	add	hl, sp
	ld	e, l
	ld	d, h
	pop	hl
	ld	l, c
	ld	h, $00
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, 270
	add	hl, sp
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, 269
	add	hl, sp
	ld	[hl], a
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	or	a, a
	jp	Z, .l00127
	inc	c
	jp	.l00188
.l00127:
;src/editor/editor.c:1153: if (entry.dir) {
	ld	a, [(_entry + 73) + 0]
	or	a, a
	jp	Z, .l00138
;src/editor/editor.c:1154: if (JoinPath(path + length, "", entry.name, PATH_SIZE - length)) {
	ld	a, $80
	sub	a, c
	ld	hl, 268
	add	hl, sp
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	push	af
	inc	sp
	ld	bc, _entry
	push	bc
	ld	bc, ___str_49
	call	_JoinPath
	or	a, a
	jp	Z, .l00129
;src/editor/editor.c:1155: selected = 0;
	xor	a, a
	ld	hl, 270
	add	hl, sp
	ld	[hl], a
	inc	hl
	ld	[hl], a
;src/editor/editor.c:1156: drawn = LIST_ALL;
	ld	hl, 262
	add	hl, sp
	ld	[hl], $FF
	inc	hl
	ld	[hl], $FF
	jp	.l00184
.l00129:
;src/editor/editor.c:1159: path[length] = 0;
	ld	hl, 268
	add	hl, sp
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	ld	[hl], $00
;src/editor/editor.c:1160: ListMessage("Path is too long");
	ld	de, ___str_51
	call	_ListMessage
	jp	.l00184
.l00138:
;src/editor/editor.c:1163: else if (entry.size > TB_SIZE) ListMessage("Too big to open");
	ld	hl, (_entry + 65) + 0
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	inc	hl
	inc	hl
	ld	a, [hl]
	dec	hl
	ld	l, [hl]
;	spillPairReg hl
	ld	h, a
;	spillPairReg hl
;	spillPairReg hl
	ld	a, $D0
	cp	a, c
	ld	a, $5F
	sbc	a, b
	ld	a, $00
	sbc	a, l
	ld	a, $00
	sbc	a, h
	jp	NC, .l00135
	ld	de, ___str_52
	call	_ListMessage
	jp	.l00184
.l00135:
;src/editor/editor.c:1165: JoinPath(path + length, "", entry.name, FS_NAME_SIZE + 1);
	ld	hl, 268
	add	hl, sp
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, $42
	push	af
	inc	sp
	ld	bc, _entry
	push	bc
	ld	bc, ___str_49
	call	_JoinPath
;src/editor/editor.c:1166: result = FileLoad(path);
	ld	hl, 0
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_FileLoad
	ld	c, a
;src/editor/editor.c:1167: HideBox();
	push	bc
	call	_HideBox
	pop	bc
;src/editor/editor.c:1168: path[length] = 0;
	ld	hl, 268
	add	hl, sp
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	ld	[hl], $00
;src/editor/editor.c:1169: if (result) {
	ld	a, c
	or	a, a
	jp	Z, .l00132
;src/editor/editor.c:1170: file_name[0] = 0; // the text buffer only has part of it, don't save over the file
	ld	hl, _file_name
	ld	[hl], $00
;src/editor/editor.c:1171: ShowError(result, "TOO BIG");
	ld	de, ___str_53
	ld	a, c
	call	_ShowError
	jp	.l00133
.l00132:
;src/editor/editor.c:1174: CopyName(file_dir, path);
	ld	hl, 0
	add	hl, sp
	ld	c, l
	ld	b, h
	ld	de, _file_dir
	call	_CopyName
;src/editor/editor.c:1175: CopyName(file_name, entry.name);
	ld	bc, _entry
	ld	de, _file_name
	call	_CopyName
.l00133:
;src/editor/editor.c:1177: opened = 1;
	ld	hl, 264
	add	hl, sp
	ld	[hl], $01
;src/editor/editor.c:1178: break;
	jp	.l00186
.l00157:
;src/editor/editor.c:1181: else if (path[0] && (key == KEY_LEFT || key == KEY_BACKSPACE || key == KEY_ESCAPE ||
	ld	hl, sp+0
	ld	c, [hl]
	ld	hl, 267
	add	hl, sp
	ld	a, [hl]
	sub	a, $1B
	jp	NZ,.l00456
	ld	a,$01
	jp	.l00457
.l00456:
	xor	a,a
.l00457:
	ld	b, a
	ld	a, c
	or	a, a
	jp	Z, .l00147
	ld	hl, 267
	add	hl, sp
	ld	a, [hl]
	sub	a, $80
	jp	NZ,.l00458
	jp	.l00242
.l00458:
	ld	hl, 267
	add	hl, sp
	ld	a, [hl]
	sub	a, $08
	jp	NZ,.l00459
	jp	.l00242
.l00459:
	ld	a, b
	or	a, a
	jp	NZ, .l00242
;src/editor/editor.c:1182: ((key == KEY_ENTER || key == KEY_RIGHT) && count && list_kinds[row] == KIND_UP))) {
	ld	hl, 268
	add	hl, sp
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00152
	inc	hl
	ld	a, [hl]
	or	a, a
	jp	Z, .l00147
.l00152:
	ld	hl, 259
	add	hl, sp
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	jp	Z, .l00147
	ld	de, _list_kinds
	ld	hl, 266
	add	hl, sp
	ld	l, [hl]
	ld	h, $00
	add	hl, de
	ld	e, l
	ld	d, h
	ld	a, [de]
	or	a, a
	jp	NZ, .l00147
;src/editor/editor.c:1183: for (length = 0; path[length]; ++length);
.l00242:
	ld	c, $00
.l00191:
	ld	e, c
	ld	d, $00
	ld	hl, 0
	add	hl, sp
	add	hl, de
	ld	a, [hl]
	or	a, a
	jp	Z, .l00243
	inc	c
	jp	.l00191
;src/editor/editor.c:1184: while (path[--length] != '/');
.l00243:
.l00141:
	dec	c
	ld	e, c
	ld	d, $00
	ld	hl, 0
	add	hl, sp
	add	hl, de
	ld	e, l
	ld	d, h
	ld	a, [de]
	sub	a, $2F
	jp	NZ,.l00460
	jp	.l00461
.l00460:
	jp	.l00141
.l00461:
;src/editor/editor.c:1185: CopyName(name, path + length + 1);
	ld	c, e
	ld	b, d
	inc	bc
	push	de
	ld	hl, 195
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_CopyName
	pop	de
;src/editor/editor.c:1186: path[length] = 0;
	xor	a, a
	ld	[de], a
;src/editor/editor.c:1187: ListLoading(path, 0xFF);
	ld	a, $FF
	ld	hl, 0
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_ListLoading
;src/editor/editor.c:1188: selected = ListFolder(path, LIST_ALL, LIST_ALL, name); // back on the folder it came from
	ld	hl, 193
	add	hl, sp
	push	hl
	ld	de, $FFFF
	push	de
	ld	bc, $FFFF
	ld	hl, 4
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_ListFolder
	ld	hl, 270
	add	hl, sp
	ld	[hl], c
	inc	hl
	ld	[hl], b
;src/editor/editor.c:1189: drawn = LIST_ALL;
	ld	hl, 262
	add	hl, sp
	ld	[hl], $FF
	inc	hl
	ld	[hl], $FF
	jp	.l00184
.l00147:
;src/editor/editor.c:1191: else if (key == KEY_ESCAPE) break;
	ld	a, b
	or	a, a
	jp	Z, .l00184
.l00186:
;src/editor/editor.c:1193: font = editor_font;
	ld	hl, 265
	add	hl, sp
	ld	a, [hl]
	ld	hl, _font
	ld	[hl], a
;src/editor/editor.c:1194: SetFont(font);
	ld	a, [hl]
	call	_SetFont
;src/editor/editor.c:1195: SetRows();
	call	_SetRows
;src/editor/editor.c:1196: return opened;
	ld	hl, 264
	add	hl, sp
	ld	a, [hl]
.l00193:
;src/editor/editor.c:1197: }
	ld	hl, 272
	add	hl, sp
	ld	sp, hl
	ret
___str_49:
	DB $00
___str_50:
	DB "Loading..."
	DB $00
___str_51:
	DB "Path is too long"
	DB $00
___str_52:
	DB "Too big to open"
	DB $00
___str_53:
	DB "TOO BIG"
	DB $00
;src/editor/editor.c:1199: static void OpenFile(void) {
;	---------------------------------
; Function OpenFile
; ---------------------------------
_OpenFile:
;src/editor/editor.c:1200: if (!CanDiscard()) return;
	call	_CanDiscard
	or	a, a
	jp	NZ, .l00102
	jp	.l00105
.l00102:
;src/editor/editor.c:1201: if (Browse()) ResetCursor();
	call	_Browse
	or	a, a
	jp	Z, .l00105
	jp	_ResetCursor
.l00105:
;src/editor/editor.c:1202: }
	ret
;src/editor/editor.c:1205: static unsigned char NameChar(unsigned char c) {
;	---------------------------------
; Function NameChar
; ---------------------------------
_NameChar:
	ld	c, a
;src/editor/editor.c:1206: if (c < ' ' || (c >= 0x7F && c < 0xA0)) return 0;
	ld	a, c
	sub	a, $20
	jp	C, .l00101
	ld	a, c
	sub	a, $7F
	jp	C, .l00102
	ld	a, c
	sub	a, $A0
	jp	NC, .l00102
.l00101:
	xor	a, a
	jp	.l00105
.l00102:
;src/editor/editor.c:1207: return c != '/' && c != 0x5C && c != ':' && c != '*' && c != '?' && c != '"' && c != '<' && c != '>' && c != '|';
	ld	a, c
	sub	a, $2F
	jp	NZ,.l00174
	jp	.l00107
.l00174:
	ld	a, c
	sub	a, $5C
	jp	NZ,.l00175
	jp	.l00107
.l00175:
	ld	a, c
	sub	a, $3A
	jp	NZ,.l00176
	jp	.l00107
.l00176:
	ld	a, c
	sub	a, $2A
	jp	NZ,.l00177
	jp	.l00107
.l00177:
	ld	a, c
	sub	a, $3F
	jp	NZ,.l00178
	jp	.l00107
.l00178:
	ld	a, c
	sub	a, $22
	jp	NZ,.l00179
	jp	.l00107
.l00179:
	ld	a, c
	sub	a, $3C
	jp	NZ,.l00180
	jp	.l00107
.l00180:
	ld	a, c
	sub	a, $3E
	jp	NZ,.l00181
	jp	.l00107
.l00181:
	ld	a, c
	sub	a, $7C
	jp	NZ,.l00182
	jp	.l00183
.l00182:
	jp	.l00108
.l00183:
.l00107:
	xor	a, a
	jp	.l00109
.l00108:
	ld	a, $01
.l00109:
.l00105:
;src/editor/editor.c:1208: }
	ret
;src/editor/editor.c:1211: static unsigned char AskFileName(void) {
;	---------------------------------
; Function AskFileName
; ---------------------------------
_AskFileName:
	add	sp, -78
;src/editor/editor.c:1216: length = (unsigned char)(ToLatin1(name, file_name, NAME_CHARS) - name);
	ld	a, $20
	push	af
	inc	sp
	ld	bc, _file_name
	ld	hl, 3
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_ToLatin1
	ld	a, c
	ld	hl, 2
	add	hl, sp
	sub	a, l
	ld	hl, sp+77
	ld	[hl], a
;src/editor/editor.c:1217: Render();
	call	_Render
;src/editor/editor.c:1218: EditorShowCursor(0);
	xor	a, a
	call	_EditorShowCursor
;src/editor/editor.c:1219: NoHighlight();
	call	_NoHighlight
;src/editor/editor.c:1220: while (1) {
.l00124:
;src/editor/editor.c:1221: end = PutText(text, "Save as ");
	ld	bc, ___str_54
	ld	hl, 35
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_PutText
;src/editor/editor.c:1222: for (i = 0; i < length; ++i) *end++ = name[i];
	ld	e, $00
.l00127:
	ld	hl, $0001
	add	hl, bc
	inc	sp
	inc	sp
	push	hl
	ld	a, e
	ld	hl, sp+77
	sub	a, [hl]
	jp	NC, .l00101
	push	de
	ld	d, $00
	ld	hl, 4
	add	hl, sp
	add	hl, de
	pop	de
	ld	a, [hl]
	ld	[bc], a
	pop	bc
	push	bc
	inc	e
	jp	.l00127
.l00101:
;src/editor/editor.c:1223: *end++ = '_';
	ld	a, $5F
	ld	[bc], a
	pop	bc
	push	bc
;src/editor/editor.c:1224: *end = 0;
	xor	a, a
	ld	[bc], a
;src/editor/editor.c:1225: if (bars) {
	ld	hl, _bars
	ld	a, [hl]
	or	a, a
	jp	Z, .l00103
;src/editor/editor.c:1226: DrawRow(HEADER_LINE, 1, text);
	ld	hl, 35
	add	hl, sp
	push	hl
	ld	e, $01
	ld	a, $12
	call	_DrawRow
;src/editor/editor.c:1227: end = PutText(text, "in ");
	ld	bc, ___str_55
	ld	hl, 35
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_PutText
	ld	e, c
	ld	d, b
;src/editor/editor.c:1228: PutPath(end, file_dir, 28);
	ld	a, $1C
	push	af
	inc	sp
	ld	bc, _file_dir
	call	_PutPath
;src/editor/editor.c:1229: DrawRow(STATUS_LINE, 1, text);
	ld	hl, 35
	add	hl, sp
	push	hl
	ld	e, $01
	ld	a, $13
	call	_DrawRow
	jp	.l00104
.l00103:
;src/editor/editor.c:1231: else DrawRow(0, 0, text);
	ld	hl, 35
	add	hl, sp
	push	hl
	ld	e, $00
	xor	a, a
	call	_DrawRow
.l00104:
;src/editor/editor.c:1232: EditorDraw();
	call	_EditorDraw
;src/editor/editor.c:1233: do {
.l00107:
;src/editor/editor.c:1234: WaitFrame();
	call	_WaitFrame
;src/editor/editor.c:1235: key = (unsigned char)KBPopEvent();
	call	_KBPopEvent
	ld	hl, sp+76
	ld	[hl], c
;src/editor/editor.c:1236: if (!key) key = PadKey();
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00108
	call	_PadKey
	ld	hl, sp+76
	ld	[hl], a
.l00108:
;src/editor/editor.c:1237: } while (!key);
	ld	hl, sp+76
	ld	a, [hl]
	or	a, a
	jp	Z, .l00107
;src/editor/editor.c:1238: if (key == KEY_ENTER && length) break;
	ld	a, [hl]
	sub	a, $0A
	jp	NZ,.l00197
	jp	.l00198
.l00197:
	jp	.l00111
.l00198:
	ld	hl, sp+77
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00125
.l00111:
;src/editor/editor.c:1239: if (key == KEY_ESCAPE || (key == KEY_BACKSPACE && !length)) {
	ld	hl, sp+76
	ld	a, [hl]
	sub	a, $1B
	jp	NZ,.l00199
	jp	.l00113
.l00199:
	ld	hl, sp+76
	ld	a, [hl]
	sub	a, $08
	jp	NZ,.l00200
	ld	a,$01
	jp	.l00201
.l00200:
	xor	a,a
.l00201:
	ld	c, a
	ld	a, c
	or	a, a
	jp	Z, .l00114
	ld	hl, sp+77
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00114
.l00113:
;src/editor/editor.c:1240: dirty = 1;
	ld	hl, _dirty
	ld	[hl], $01
;src/editor/editor.c:1241: return 0;
	xor	a, a
	jp	.l00129
.l00114:
;src/editor/editor.c:1243: if (key == KEY_BACKSPACE) --length;
	ld	a, c
	or	a, a
	jp	Z, .l00121
	ld	hl, sp+77
	dec	[hl]
	jp	.l00124
.l00121:
;src/editor/editor.c:1244: else if (length < NAME_CHARS && NameChar(key)) name[length++] = key;
	ld	hl, sp+77
	ld	a, [hl]
	sub	a, $20
	jp	NC, .l00124
	dec	hl
	ld	a, [hl]
	call	_NameChar
	or	a, a
	jp	Z, .l00124
	ld	hl, sp+77
	ld	e, [hl]
	inc	[hl]
	ld	d, $00
	ld	hl, 2
	add	hl, sp
	add	hl, de
	ld	c, l
	ld	b, h
	ld	hl, sp+76
	ld	a, [hl]
	ld	[bc], a
	jp	.l00124
.l00125:
;src/editor/editor.c:1246: name[length] = 0;
	push	hl
	ld	hl, 4
	add	hl, sp
	ld	e, l
	ld	d, h
	pop	hl
	ld	hl, sp+77
	ld	l, [hl]
	ld	h, $00
	add	hl, de
	ld	c, l
	ld	b, h
	xor	a, a
	ld	[bc], a
;src/editor/editor.c:1247: ToUtf8(file_name, name);
	ld	hl, 2
	add	hl, sp
	ld	c, l
	ld	b, h
	ld	de, _file_name
	call	_ToUtf8
;src/editor/editor.c:1248: dirty = 1;
	ld	hl, _dirty
	ld	[hl], $01
;src/editor/editor.c:1249: return 1;
	ld	a, $01
.l00129:
;src/editor/editor.c:1250: }
	add	sp, 78
	ret
___str_54:
	DB "Save as "
	DB $00
___str_55:
	DB "in "
	DB $00
;src/editor/editor.c:1252: static void SaveFile(unsigned char ask) {
;	---------------------------------
; Function SaveFile
; ---------------------------------
_SaveFile:
	add	sp, -128
	add	sp, -65
	ld	c, a
;src/editor/editor.c:1255: if ((ask || !file_name[0]) && !AskFileName()) return;
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
	jp	.l00109
.l00102:
;src/editor/editor.c:1256: JoinPath(path, file_dir, file_name, (unsigned char)(PATH_SIZE + FS_NAME_SIZE));
	ld	a, $C1
	push	af
	inc	sp
	ld	de, _file_name
	push	de
	ld	bc, _file_dir
	ld	hl, 3
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_JoinPath
;src/editor/editor.c:1257: ShowBusy("Saving...");
	ld	de, ___str_56
	call	_ShowBusy
;src/editor/editor.c:1258: result = FileMount();
	call	_FileMount
	ld	c, a
;src/editor/editor.c:1259: if (!result) result = FileSave(path);
	ld	a, c
	or	a, a
	jp	NZ, .l00106
	ld	hl, 0
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_FileSave
	ld	c, a
.l00106:
;src/editor/editor.c:1260: HideBox();
	push	bc
	call	_HideBox
	pop	bc
;src/editor/editor.c:1261: if (result) {
	ld	a, c
	or	a, a
	jp	Z, .l00108
;src/editor/editor.c:1262: ShowError(result, "DISK FULL");
	ld	de, ___str_57
	ld	a, c
	call	_ShowError
;src/editor/editor.c:1263: return;
	jp	.l00109
.l00108:
;src/editor/editor.c:1265: modified = 0;
	ld	hl, _modified
	ld	[hl], $00
;src/editor/editor.c:1266: ShowMessage("SAVED");
	ld	de, ___str_58
	call	_ShowMessage
.l00109:
;src/editor/editor.c:1267: }
	add	sp, 127
	add	sp, 66
	ret
___str_56:
	DB "Saving..."
	DB $00
___str_57:
	DB "DISK FULL"
	DB $00
___str_58:
	DB "SAVED"
	DB $00
;src/editor/editor.c:1270: static void ToggleFont(void) {
;	---------------------------------
; Function ToggleFont
; ---------------------------------
_ToggleFont:
;src/editor/editor.c:1271: font = font == FONT_VWF ? FONT_MONO : FONT_VWF;
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
;src/editor/editor.c:1272: SetFont(font);
	ld	hl, _font
	ld	a, [hl]
	call	_SetFont
;src/editor/editor.c:1273: dirty = 1;
	ld	hl, _dirty
	ld	[hl], $01
.l00101:
;src/editor/editor.c:1274: }
	ret
;src/editor/editor.c:1277: static void ShowHelp(void) {
;	---------------------------------
; Function ShowHelp
; ---------------------------------
_ShowHelp:
	dec	sp
;src/editor/editor.c:1278: unsigned char row, editor_font = font;
	ld	hl, _font
	ld	a, [hl]
	ld	hl, sp+0
	ld	[hl], a
;src/editor/editor.c:1279: font = FONT_VWF;
	ld	hl, _font
	ld	[hl], $01
;src/editor/editor.c:1280: SetFont(font);
	ld	a, $01
	call	_SetFont
;src/editor/editor.c:1281: BeginFullScreen();
	call	_BeginFullScreen
;src/editor/editor.c:1282: for (row = 0; row < HELP_ROWS; ++row) DrawRow(row, 0, help_lines[row]);
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
;src/editor/editor.c:1283: EditorDraw();
	call	_EditorDraw
;src/editor/editor.c:1284: while (!MenuKey());
.l00102:
	call	_MenuKey
	or	a, a
	jp	Z, .l00102
;src/editor/editor.c:1285: font = editor_font;
	ld	hl, sp+0
	ld	a, [hl]
	ld	hl, _font
	ld	[hl], a
;src/editor/editor.c:1286: SetFont(font);
	ld	a, [hl]
	call	_SetFont
;src/editor/editor.c:1287: EndFullScreen();
	inc	sp
	jp	_EndFullScreen
.l00107:
;src/editor/editor.c:1288: }
	inc	sp
	ret
;src/editor/editor.c:1290: static void FileMenu(void) {
;	---------------------------------
; Function FileMenu
; ---------------------------------
_FileMenu:
;src/editor/editor.c:1291: switch (Choose("MENU", menu_items[0], 7)) {
	ld	a, $07
	push	af
	inc	sp
	ld	bc, _menu_items
	ld	de, ___str_59
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
;src/editor/editor.c:1292: case 0: OpenFile(); break;
.l00101:
	jp	_OpenFile
	jp	.l00109
;src/editor/editor.c:1293: case 1: SaveFile(0); break;
.l00102:
	xor	a, a
	jp	_SaveFile
	jp	.l00109
;src/editor/editor.c:1294: case 2: SaveFile(1); break;
.l00103:
	ld	a, $01
	jp	_SaveFile
	jp	.l00109
;src/editor/editor.c:1295: case 3: NewFile(); break;
.l00104:
	jp	_NewFile
	jp	.l00109
;src/editor/editor.c:1296: case 4: ToggleFont(); break;
.l00105:
	jp	_ToggleFont
	jp	.l00109
;src/editor/editor.c:1297: case 5: ToggleBars(); break;
.l00106:
	jp	_ToggleBars
	jp	.l00109
;src/editor/editor.c:1298: case 6: ShowHelp(); break;
.l00107:
	jp	_ShowHelp
;src/editor/editor.c:1299: }
.l00109:
;src/editor/editor.c:1300: }
	ret
___str_59:
	DB "MENU"
	DB $00
;src/editor/editor.c:1303: static unsigned char HandleFileKey(unsigned char key, unsigned char mods) {
;	---------------------------------
; Function HandleFileKey
; ---------------------------------
_HandleFileKey:
	ld	c, a
;src/editor/editor.c:1304: if (key == KEY_MENU || key == KEY_ESCAPE) FileMenu();
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
;src/editor/editor.c:1305: else if (key == KEY_F1) ShowHelp();
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
;src/editor/editor.c:1306: else if (key == KEY_F11) ToggleBars();
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
;src/editor/editor.c:1307: else if (!(mods & KB_MOD_CTRL)) return 0;
	bit	5, e
	jp	NZ,.l00179
	jp	.l00180
.l00179:
	jp	.l00118
.l00180:
	xor	a, a
	jp	.l00130
.l00118:
;src/editor/editor.c:1308: else if (key == 'o' || key == 'O') OpenFile();
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
;src/editor/editor.c:1309: else if (key == 's' || key == 'S') SaveFile(0);
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
;src/editor/editor.c:1310: else if (key == 'n' || key == 'N') NewFile();
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
;src/editor/editor.c:1311: else if (key == 'f' || key == 'F') ToggleFont();
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
;src/editor/editor.c:1312: else return 0;
	xor	a, a
	jp	.l00130
.l00128:
;src/editor/editor.c:1313: dirty = 1;
	ld	hl, _dirty
	ld	[hl], $01
;src/editor/editor.c:1314: return 1;
	ld	a, $01
.l00130:
;src/editor/editor.c:1315: }
	ret
;src/editor/editor.c:1317: static void Render(void) {
;	---------------------------------
; Function Render
; ---------------------------------
_Render:
;src/editor/editor.c:1318: tb_find = cursor;
	ld	hl, _cursor
	ld	a, [hl]
	ld	hl, _tb_find
	ld	[hl], a
	ld	hl, _cursor + 1
	ld	a, [hl]
	ld	hl, _tb_find + 1
	ld	[hl], a
;src/editor/editor.c:1319: tb_Render(top);
	ld	hl, _top
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	jp	_tb_Render
.l00101:
;src/editor/editor.c:1320: }
	ret
;src/editor/editor.c:1323: static void Refresh(void) {
;	---------------------------------
; Function Refresh
; ---------------------------------
_Refresh:
	add	sp, -3
;src/editor/editor.c:1326: if (top > tb_Length()) top = tb_Length();
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
;src/editor/editor.c:1327: top = tb_RowStart(top); // wrapping may have changed
	ld	hl, _top
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_tb_RowStart
	ld	hl, _top
	ld	[hl], c
	inc	hl
	ld	[hl], b
;src/editor/editor.c:1328: Render();
	call	_Render
;src/editor/editor.c:1329: if (tb_found_row == 0xFF) {
	ld	hl, _tb_found_row
	ld	a, [hl]
	inc	a
	jp	NZ,.l00196
	jp	.l00197
.l00196:
	jp	.l00119
.l00197:
;src/editor/editor.c:1330: row = tb_RowStart(cursor);
	ld	hl, _cursor
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_tb_RowStart
;src/editor/editor.c:1331: if (cursor < top) {
	ld	de, _cursor
	ld	hl, _top
	ld	a, [de]
	inc	de
	sub	a, [hl]
	inc	hl
	ld	a, [de]
	sbc	a, [hl]
	jp	NC, .l00116
;src/editor/editor.c:1332: if (top && row == tb_RowStart(top - 1)) ScrollRing(0); // one row up
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
;src/editor/editor.c:1333: top = row;
	ld	hl, _top
	ld	[hl], c
	inc	hl
	ld	[hl], b
	jp	.l00117
.l00116:
;src/editor/editor.c:1336: bottom = tb_row_starts[tb_rows];
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
;src/editor/editor.c:1337: for (i = tb_rows; i; --i) {
	ld	hl, _tb_rows
	ld	a, [hl]
	ld	hl, sp+2
	ld	[hl], a
.l00121:
	ld	hl, sp+2
	ld	a, [hl]
	or	a, a
	jp	Z, .l00108
;src/editor/editor.c:1338: top = tb_NextRow(top);
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
;src/editor/editor.c:1339: if (bottom == row) break;
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
;src/editor/editor.c:1340: bottom = tb_NextRow(bottom);
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
;src/editor/editor.c:1337: for (i = tb_rows; i; --i) {
	ld	hl, sp+2
	dec	[hl]
	jp	.l00121
.l00108:
;src/editor/editor.c:1342: if (!i) { // the cursor's row goes at the bottom
	ld	hl, sp+2
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00113
;src/editor/editor.c:1343: top = row;
	ld	hl, _top
	ld	[hl], c
	inc	hl
	ld	[hl], b
;src/editor/editor.c:1344: for (i = tb_rows - 1; i && top; --i) top = tb_RowStart(top - 1);
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
;src/editor/editor.c:1346: else if (i == tb_rows) ScrollRing(1); // one row down
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
;src/editor/editor.c:1348: Render();
	call	_Render
.l00119:
;src/editor/editor.c:1350: Draw();
	call	_Draw
;src/editor/editor.c:1351: redraw = 0;
	ld	hl, _redraw
	ld	[hl], $00
;src/editor/editor.c:1352: moved = 0;
	ld	hl, _moved
	ld	[hl], $00
;src/editor/editor.c:1353: PlaceCursor();
	call	_PlaceCursor
.l00127:
;src/editor/editor.c:1354: }
	add	sp, 3
	ret
;src/editor/editor.c:1356: void Editor(void) {
;	---------------------------------
; Function Editor
; ---------------------------------
_Editor::
;src/editor/editor.c:1360: EditorSetup();
	call	_EditorSetup
;src/editor/editor.c:1361: for (key = 0; key < BG_MAP_ROWS; ++key) map_blocks[key] = key < TB_ROWS ? key : 0xFF; // set by RenderSetup
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
;src/editor/editor.c:1362: everdrive = sd_Detect();
	call	_sd_Detect
	ld	hl, _everdrive
	ld	[hl], a
;src/editor/editor.c:1363: idle_frames = 0;
	ld	hl, _idle_frames
	ld	[hl], $00
;src/editor/editor.c:1364: normalized = 0;
	ld	hl, _normalized
	ld	[hl], $00
;src/editor/editor.c:1365: cursor = 0;
	xor	a, a
	ld	hl, _cursor
	ld	[hl], a
	inc	hl
	ld	[hl], a
;src/editor/editor.c:1366: top = 0;
	xor	a, a
	ld	hl, _top
	ld	[hl], a
	inc	hl
	ld	[hl], a
;src/editor/editor.c:1367: selecting = 0;
	ld	hl, _selecting
	ld	[hl], $00
;src/editor/editor.c:1368: want_x = 0;
	ld	hl, _want_x
	ld	[hl], $00
;src/editor/editor.c:1369: keep_x = 0;
	ld	hl, _keep_x
	ld	[hl], $00
;src/editor/editor.c:1370: moved = 0;
	ld	hl, _moved
	ld	[hl], $00
;src/editor/editor.c:1371: redraw = 0;
	ld	hl, _redraw
	ld	[hl], $00
;src/editor/editor.c:1372: ring_top = 0;
	ld	hl, _ring_top
	ld	[hl], $00
;src/editor/editor.c:1373: ring_pos = 0;
	ld	hl, _ring_pos
	ld	[hl], $00
;src/editor/editor.c:1374: counted_pos = 0;
	xor	a, a
	ld	hl, _counted_pos
	ld	[hl], a
	inc	hl
	ld	[hl], a
;src/editor/editor.c:1375: counted_lines = 0;
	xor	a, a
	ld	hl, _counted_lines
	ld	[hl], a
	inc	hl
	ld	[hl], a
;src/editor/editor.c:1376: bars_changed = 0;
	ld	hl, _bars_changed
	ld	[hl], $00
;src/editor/editor.c:1377: edited = 0;
	ld	hl, _edited
	ld	[hl], $00
;src/editor/editor.c:1378: pad_timer = 0;
	ld	hl, _pad_timer
	ld	[hl], $00
;src/editor/editor.c:1379: modified = 0;
	ld	hl, _modified
	ld	[hl], $00
;src/editor/editor.c:1380: font = FONT_VWF;
	ld	hl, _font
	ld	[hl], $01
;src/editor/editor.c:1381: file_name[0] = 0;
	ld	hl, _file_name
	ld	[hl], $00
;src/editor/editor.c:1382: file_dir[0] = 0;
	ld	hl, _file_dir
	ld	[hl], $00
;src/editor/editor.c:1383: fs_crlf = 0;
	ld	hl, _fs_crlf
	ld	[hl], $00
;src/editor/editor.c:1384: osk_shown = 0;
	ld	hl, _osk_shown
	ld	[hl], $00
;src/editor/editor.c:1385: osk_layer = OSK_LOWER;
	ld	hl, _osk_layer
	ld	[hl], $00
;src/editor/editor.c:1386: osk_x = 0;
	ld	hl, _osk_x
	ld	[hl], $00
;src/editor/editor.c:1387: osk_y = 0;
	ld	hl, _osk_y
	ld	[hl], $00
;src/editor/editor.c:1388: bars_on = 1;
	ld	hl, _bars_on
	ld	[hl], $01
;src/editor/editor.c:1389: SetRows();
	call	_SetRows
;src/editor/editor.c:1390: Refresh();
	call	_Refresh
;src/editor/editor.c:1392: while (1) {
.l00160:
;src/editor/editor.c:1393: if (bars_changed) { // status bar follows the cursor
	ld	hl, _bars_changed
	ld	a, [hl]
	or	a, a
	jp	Z, .l00105
;src/editor/editor.c:1394: bars_changed = 0;
	ld	[hl], $00
;src/editor/editor.c:1395: if (bars) Draw();
	ld	hl, _bars
	ld	a, [hl]
	or	a, a
	jp	Z, .l00105
	call	_Draw
.l00105:
;src/editor/editor.c:1397: WaitFrame();
	call	_WaitFrame
;src/editor/editor.c:1398: while ((key = (unsigned char)(event = KBPopEvent()))) {
.l00115:
	call	_KBPopEvent
	ld	e, c
	ld	d, b
	ld	a, c
	ld	c, a
	or	a, a
	jp	Z, .l00117
;src/editor/editor.c:1399: if (!HandleFileKey(key, (unsigned char)(event >> 8))) HandleKey(key, (unsigned char)(event >> 8));
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
;src/editor/editor.c:1400: if (dirty || edited) break; // text changed, rows need rendering before more keys
	ld	hl, _dirty
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00117
	ld	hl, _edited
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00117
;src/editor/editor.c:1401: if (moved) { // keeps tb_found_row current for the next key
	ld	hl, _moved
	ld	a, [hl]
	or	a, a
	jp	Z, .l00115
;src/editor/editor.c:1402: if (!PlaceCursor()) dirty = 1;
	call	_PlaceCursor
	or	a, a
	jp	NZ, .l00112
	ld	hl, _dirty
	ld	[hl], $01
.l00112:
;src/editor/editor.c:1403: moved = 0;
	ld	hl, _moved
	ld	[hl], $00
	jp	.l00115
.l00117:
;src/editor/editor.c:1406: if ((key = PadKey())) {
	call	_PadKey
	ld	c, a
	or	a, a
	jp	Z, .l00121
;src/editor/editor.c:1407: if (!HandleFileKey(key, 0)) HandleKey(key, 0);
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
;src/editor/editor.c:1409: if (dirty || edited || redraw || moved) idle_frames = 0;
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
;src/editor/editor.c:1410: if (dirty) {
	ld	hl, _dirty
	ld	a, [hl]
	or	a, a
	jp	Z, .l00128
;src/editor/editor.c:1411: Refresh();
	call	_Refresh
;src/editor/editor.c:1412: dirty = 0;
	ld	hl, _dirty
	ld	[hl], $00
;src/editor/editor.c:1413: edited = 0;
	ld	hl, _edited
	ld	[hl], $00
;src/editor/editor.c:1414: normalized = 0;
	ld	hl, _normalized
	ld	[hl], $00
;src/editor/editor.c:1415: continue;
	jp	.l00160
.l00128:
;src/editor/editor.c:1417: if (edited) {
	ld	hl, _edited
	ld	a, [hl]
	or	a, a
	jp	Z, .l00141
;src/editor/editor.c:1418: edited = 0;
	ld	[hl], $00
;src/editor/editor.c:1419: normalized = 0;
	ld	hl, _normalized
	ld	[hl], $00
;src/editor/editor.c:1420: RenderAfterEdit();
	call	_RenderAfterEdit
;src/editor/editor.c:1421: if (!PlaceCursor()) {
	call	_PlaceCursor
	or	a, a
	jp	NZ, .l00141
;src/editor/editor.c:1422: if (cursor >= tb_row_starts[tb_rows] && tb_RowStart(cursor) == tb_row_starts[tb_rows]) ScrollDown();
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
;src/editor/editor.c:1423: else if (top && cursor < top && tb_RowStart(cursor) == tb_RowStart(top - 1)) ScrollUp(tb_RowStart(cursor));
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
;src/editor/editor.c:1425: Refresh();
	call	_Refresh
;src/editor/editor.c:1426: continue;
	jp	.l00160
.l00136:
;src/editor/editor.c:1428: PlaceCursor();
	call	_PlaceCursor
.l00141:
;src/editor/editor.c:1431: if (redraw) {
	ld	hl, _redraw
	ld	a, [hl]
	or	a, a
	jp	Z, .l00143
;src/editor/editor.c:1432: Draw();
	call	_Draw
;src/editor/editor.c:1433: redraw = 0;
	ld	hl, _redraw
	ld	[hl], $00
.l00143:
;src/editor/editor.c:1435: if (moved) {
	ld	hl, _moved
	ld	a, [hl]
	or	a, a
	jp	Z, .l00147
;src/editor/editor.c:1436: moved = 0;
	ld	[hl], $00
;src/editor/editor.c:1437: if (!PlaceCursor()) Refresh();
	call	_PlaceCursor
	or	a, a
	jp	NZ, .l00160
	call	_Refresh
;src/editor/editor.c:1438: continue;
	jp	.l00160
.l00147:
;src/editor/editor.c:1440: if (idle_frames < NORMALIZE_DELAY) ++idle_frames;
	ld	hl, _idle_frames
	ld	a, [hl]
	sub	a, $1E
	jp	NC, .l00152
	inc	[hl]
	jp	.l00153
.l00152:
;src/editor/editor.c:1441: else if (!everdrive && !normalized) normalized = tb_NormalizeStep(); // keeps the .sav readable as text
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
;src/editor/editor.c:1442: if (++blink_timer == CURSOR_BLINK) EditorShowCursor(0);
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
;src/editor/editor.c:1443: else if (blink_timer == CURSOR_BLINK + CURSOR_BLINK) {
	ld	hl, _blink_timer
	ld	a, [hl]
	sub	a, $3C
	jp	NZ,.l00345
	jp	.l00346
.l00345:
	jp	.l00160
.l00346:
;src/editor/editor.c:1444: EditorShowCursor(1);
	ld	a, $01
	call	_EditorShowCursor
;src/editor/editor.c:1445: blink_timer = 0;
	ld	hl, _blink_timer
	ld	[hl], $00
	jp	.l00160
.l00164:
;src/editor/editor.c:1448: }
	ret
	SECTION FRAGMENT "src/editor/editor.c_CODE",ROMX
	SECTION FRAGMENT "_INITIALIZER",ROM0
	SECTION FRAGMENT "_CABS (ABS)",ROM0
