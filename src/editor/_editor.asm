;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 4.2.0 #13081 (Linux)
;--------------------------------------------------------
	; MODULE editor
	; Generated using the rgbds tokens.

;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	EXPORT _Redo
	EXPORT _Undo
	EXPORT _UndoSaved
	EXPORT _UndoDeleting
	EXPORT _UndoInserted
	EXPORT _UndoClear
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
	EXPORT _FileListEntry
	EXPORT _FileList
	EXPORT _FileMount
	EXPORT _sd_Detect
	EXPORT _OSKGetKey
	EXPORT _OSKSelect
	EXPORT _OSKDraw
	EXPORT _OSKShow
	EXPORT _SettingsSave
	EXPORT _SettingsLoad
	EXPORT _RenderStage
	EXPORT _RenderTextWidth
	EXPORT _RenderSetMapRow
	EXPORT _RenderCursorX
	EXPORT _EditorRedraw
	EXPORT _EditorDraw
	EXPORT _SetFont
	EXPORT _EditorInvertCursor
	EXPORT _EditorShowCursor
	EXPORT _WaitFrame
	EXPORT _EditorSetup
	EXPORT _KBPopEvent
	EXPORT _PadPressed
	EXPORT _head_width
	EXPORT _list_times
	EXPORT _list_dates
	EXPORT _list_sizes
	EXPORT _list_kinds
	EXPORT _list_result
	EXPORT _list_count
	EXPORT _entry
	EXPORT _file_dir
	EXPORT _file_name
	EXPORT _saved_modified
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
	EXPORT _ring_blocks
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
_ring_blocks:
	DS 19
_map_blocks:
	DS 39
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
_saved_modified:
	DS 1
_file_name:
	DS 65
_file_dir:
	DS 128
_entry:
	DS 74
_list_count:
	DS 2
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
_head_width:
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
;src/editor/editor.c:120: static unsigned char FindRow(unsigned int pos) {
;	---------------------------------
; Function FindRow
; ---------------------------------
_FindRow:
	dec	sp
	dec	sp
	ld	c, e
	ld	b, d
;src/editor/editor.c:122: for (row = 0; row < tb_rows; ++row) {
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
;src/editor/editor.c:123: if (pos < tb_row_starts[row]) return 0xFF;
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
;src/editor/editor.c:124: if (pos < tb_row_starts[row + 1]) return row;
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
;src/editor/editor.c:122: for (row = 0; row < tb_rows; ++row) {
	ld	hl, sp+1
	inc	[hl]
	ld	a, [hl]
	dec	hl
	ld	[hl], a
	jp	.l00107
.l00105:
;src/editor/editor.c:126: return pos == tb_Length() ? tb_end_row : 0xFF;
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
;src/editor/editor.c:127: }
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
	DB "UNDO"
	DB $00
	DB $00
	DB $00
	DB $00
	DB $00
	DB $00
	DB $00
	DB $00
	DB $00
	DB "REDO"
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
	DB "LINE WRAP"
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
	DB "Ctrl+F  font    Alt+Z  line wrap"
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
	DB "Ctrl+Z, Y  undo, redo"
	DB $00
	DB $00
	DB $00
	DB $00
	DB $00
	DB $00
	DB $00
	DB $00
	DB $00
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
;src/editor/editor.c:133: static unsigned int LineEnd(unsigned char row) {
;	---------------------------------
; Function LineEnd
; ---------------------------------
_LineEnd:
	ld	c, a
;src/editor/editor.c:134: return row == tb_end_row ? tb_Length() : tb_row_starts[row + 1] - 1;
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
;src/editor/editor.c:135: }
	ret
;src/editor/editor.c:138: static unsigned char PlaceCursor(void) {
;	---------------------------------
; Function PlaceCursor
; ---------------------------------
_PlaceCursor:
	dec	sp
;src/editor/editor.c:139: unsigned char row = FindRow(cursor), count;
	ld	hl, _cursor
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_FindRow
	ld	hl, sp+0
	ld	[hl], a
;src/editor/editor.c:141: if (row == 0xFF) return 0;
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
;src/editor/editor.c:142: col = cursor - tb_row_starts[row];
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
;src/editor/editor.c:143: count = tb_row_counts[row];
	ld	bc, _tb_row_counts+0
	ld	hl, sp+0
	ld	l, [hl]
	ld	h, $00
	add	hl, bc
	ld	c, l
	ld	b, h
	ld	a, [bc]
;src/editor/editor.c:147: if (col > count || (col == count && cursor != LineEnd(row))) return 0;
	ld	c, a
	ld	b, $00
;src/editor/editor.c:144: if (tb_nowrap) { // its character is drawn, or it's after the line's last one
	ld	hl, _tb_nowrap
	ld	a, [hl]
	or	a, a
	jp	Z, .l00112
;src/editor/editor.c:145: if (col < tb_left) return 0;
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
;src/editor/editor.c:146: col -= tb_left;
	ld	a, e
	ld	hl, _tb_left
	sub	a, [hl]
	ld	e, a
	ld	a, d
	inc	hl
	sbc	a, [hl]
	ld	d, a
;src/editor/editor.c:147: if (col > count || (col == count && cursor != LineEnd(row))) return 0;
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
;src/editor/editor.c:149: else if (col > count) col = count; // hanging spaces
	ld	a, c
	sub	a, e
	ld	a, b
	sbc	a, d
	jp	NC, .l00113
	ld	e, c
	ld	d, b
.l00113:
;src/editor/editor.c:150: tb_found_row = row;
	ld	hl, sp+0
	ld	a, [hl]
	ld	hl, _tb_found_row
	ld	[hl], a
;src/editor/editor.c:151: tb_found_col = (unsigned char)col;
	ld	hl, _tb_found_col
	ld	[hl], e
;src/editor/editor.c:152: if (!keep_x) want_x = RenderCursorX(tb_found_col);
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
;src/editor/editor.c:153: keep_x = 0;
	ld	hl, _keep_x
	ld	[hl], $00
;src/editor/editor.c:154: blink_timer = 0;
	ld	hl, _blink_timer
	ld	[hl], $00
;src/editor/editor.c:155: EditorInvertCursor(GetSelection() && cursor == sel_start); // the selection starts at the cursor's x
	call	_GetSelection
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
;src/editor/editor.c:156: EditorShowCursor(1);
	ld	a, $01
	call	_EditorShowCursor
;src/editor/editor.c:157: bars_changed = 1;
	ld	hl, _bars_changed
	ld	[hl], $01
;src/editor/editor.c:158: return 1;
	ld	a, $01
.l00116:
;src/editor/editor.c:159: }
	inc	sp
	ret
;src/editor/editor.c:162: static unsigned int PosAtX(unsigned char row, unsigned char x) {
;	---------------------------------
; Function PosAtX
; ---------------------------------
_PosAtX:
	add	sp, -9
	ld	hl, sp+7
	ld	[hl], a
	dec	hl
	ld	[hl], e
;src/editor/editor.c:163: unsigned char* attrs = (unsigned char*)RowAddress(row) + (tile_attrs - tile_buffer);
	inc	hl
	ld	a, [hl]
	call	_RowAddress
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
;src/editor/editor.c:164: unsigned char count = tb_row_counts[row], col = 0, width;
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
;src/editor/editor.c:166: while (col < count) {
	ld	hl, sp+8
	ld	[hl], $00
.l00103:
	ld	hl, sp+8
	ld	a, [hl]
	ld	hl, sp+2
	sub	a, [hl]
	jp	NC, .l00105
;src/editor/editor.c:167: width = attrs[col] & STYLE_WIDTH;
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
;src/editor/editor.c:168: if (x < ((width + 1) >> 1)) break;
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
;src/editor/editor.c:169: x = x < width ? 0 : x - width;
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
;src/editor/editor.c:170: ++col;
	inc	hl
	inc	hl
	inc	[hl]
	jp	.l00103
.l00105:
;src/editor/editor.c:172: pos = tb_row_starts[row] + col;
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
;src/editor/editor.c:173: if (tb_nowrap) {
	ld	hl, _tb_nowrap
	ld	a, [hl]
	or	a, a
	jp	Z, .l00107
;src/editor/editor.c:174: pos += tb_left;
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
;src/editor/editor.c:175: return pos > LineEnd(row) ? LineEnd(row) : pos;
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
;src/editor/editor.c:177: if (col == count && pos == tb_row_starts[row + 1] && tb_end_row != row) --pos; // stay on wrapped row
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
;src/editor/editor.c:178: return pos;
	ld	hl, sp+4
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
.l00112:
;src/editor/editor.c:179: }
	add	sp, 9
	ret
;src/editor/editor.c:182: static unsigned char TextRows(void) {
;	---------------------------------
; Function TextRows
; ---------------------------------
_TextRows:
;src/editor/editor.c:183: return TB_ROWS - (bars << 1) - (osk_shown ? OSK_ROWS : 0);
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
;src/editor/editor.c:184: }
	ret
;src/editor/editor.c:192: static void Layout(void) {
;	---------------------------------
; Function Layout
; ---------------------------------
_Layout:
	add	sp, -8
;src/editor/editor.c:193: unsigned char row, line, block, map_row, i = 0, win_row = BG_MAP_ROWS, osk = TB_ROWS - (bars << 1) - tb_rows;
	ld	hl, _bars
	ld	a, [hl]
	add	a, a
	ld	c, a
	ld	a, $12
	sub	a, c
	ld	hl, _tb_rows
	ld	c, [hl]
	sub	a, c
	ld	c, a
;src/editor/editor.c:194: unsigned char length = tb_rows + render_gbc;
	ld	a, [hl]
	ld	hl, _render_gbc
	add	a, [hl]
	ld	hl, sp+0
	ld	[hl], a
;src/editor/editor.c:195: for (block = 0; block < TB_ROWS + render_gbc; ++block) {
	ld	hl, sp+7
	ld	[hl], $00
	ld	b, $00
.l00128:
	ld	hl, _render_gbc
	ld	e, [hl]
	ld	d, $00
	ld	hl, $0012
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+5
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+4
	ld	[hl], a
	inc	hl
	ld	[hl], b
	inc	hl
	ld	[hl], $00
	ld	hl, sp+5
	ld	e, l
	ld	d, h
	ld	hl, sp+3
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
	jp	Z, .l00219
	bit	7, d
	jp	NZ, .l00220
	cp	a, a
	jp	.l00220
.l00219:
	bit	7, d
	jp	Z, .l00220
	scf
.l00220:
	jp	NC, .l00110
;src/editor/editor.c:196: if (bars && (block == HEADER_BLOCK || block == STATUS_BLOCK)) continue;
	ld	hl, _bars
	ld	a, [hl]
	or	a, a
	jp	Z, .l00102
	ld	a, b
	sub	a, $08
	jp	NZ,.l00221
	jp	.l00109
.l00221:
	ld	a, b
	sub	a, $11
	jp	NZ,.l00222
	jp	.l00109
.l00222:
.l00102:
;src/editor/editor.c:197: if (osk && block >= OSK_BLOCK && block < OSK_BLOCK + OSK_ROWS) continue;
	ld	a, c
	or	a, a
	jp	Z, .l00106
	ld	a, b
	sub	a, $09
	jp	C, .l00106
	ld	a, b
	sub	a, $0E
	jp	C, .l00109
.l00106:
;src/editor/editor.c:198: ring_blocks[i++] = block;
	ld	de, _ring_blocks
	ld	hl, sp+7
	ld	l, [hl]
	ld	h, $00
	add	hl, de
	ld	e, l
	ld	d, h
	ld	hl, sp+7
	inc	[hl]
	ld	a, b
	ld	[de], a
.l00109:
;src/editor/editor.c:195: for (block = 0; block < TB_ROWS + render_gbc; ++block) {
	inc	b
	jp	.l00128
.l00110:
;src/editor/editor.c:200: if (ring_pos >= length) ring_pos = 0;
	ld	hl, _ring_pos
	ld	a, [hl]
	ld	hl, sp+0
	sub	a, [hl]
	jp	C, .l00112
	ld	hl, _ring_pos
	ld	[hl], $00
.l00112:
;src/editor/editor.c:201: i = ring_pos;
	ld	hl, _ring_pos
	ld	a, [hl]
	ld	hl, sp+5
	ld	[hl], a
;src/editor/editor.c:202: render_pending = 0;
	ld	hl, _render_pending
	ld	[hl], $00
;src/editor/editor.c:203: render_text_top = bars;
	ld	hl, _bars
	ld	a, [hl]
	ld	hl, _render_text_top
	ld	[hl], a
;src/editor/editor.c:204: for (row = 0; row < TB_ROWS; ++row) {
	ld	hl, sp+6
	ld	[hl], $20
	inc	hl
	ld	[hl], $00
.l00129:
;src/editor/editor.c:205: line = row - bars;
	ld	hl, sp+7
	ld	a, [hl]
	ld	hl, _bars
	sub	a, [hl]
	ld	hl, sp+4
	ld	[hl], a
;src/editor/editor.c:206: if (line < tb_rows) {
	ld	a, [hl]
	ld	hl, _tb_rows
	sub	a, [hl]
	jp	NC, .l00121
;src/editor/editor.c:207: block = ring_blocks[i];
	ld	de, _ring_blocks
	ld	hl, sp+5
	ld	l, [hl]
	ld	h, $00
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, [bc]
	ld	hl, sp+1
	ld	[hl], a
;src/editor/editor.c:208: if (++i == length) i = 0;
	ld	hl, sp+5
	inc	[hl]
	ld	hl, sp+0
	ld	a, [hl]
	ld	hl, sp+5
	sub	a, [hl]
	jp	NZ,.l00223
	jp	.l00224
.l00223:
	jp	.l00114
.l00224:
	ld	hl, sp+5
	ld	[hl], $00
.l00114:
;src/editor/editor.c:209: map_row = (ring_top + line) & (BG_MAP_ROWS - 1);
	ld	hl, _ring_top
	ld	a, [hl]
	ld	hl, sp+4
	add	a, [hl]
	and	a, $1F
	dec	hl
	dec	hl
	ld	[hl], a
;src/editor/editor.c:210: render_row_fonts[row] = font;
	ld	de, _render_row_fonts
	ld	hl, sp+7
	ld	l, [hl]
	ld	h, $00
	add	hl, de
	ld	c, l
	ld	b, h
	ld	hl, _font
	ld	a, [hl]
	ld	[bc], a
	jp	.l00122
.l00121:
;src/editor/editor.c:213: map_row = win_row++;
	ld	hl, sp+6
	ld	a, [hl]
	ld	hl, sp+2
	ld	[hl], a
	ld	hl, sp+6
	inc	[hl]
;src/editor/editor.c:214: if (bars && (!row || row == TB_ROWS - 1)) {
	ld	hl, _bars
	ld	a, [hl]
	or	a, a
	jp	Z, .l00116
	ld	hl, sp+7
	ld	a, [hl]
	or	a, a
	jp	Z, .l00115
	ld	a, [hl]
	sub	a, $11
	jp	NZ,.l00225
	jp	.l00226
.l00225:
	jp	.l00116
.l00226:
.l00115:
;src/editor/editor.c:215: block = row ? STATUS_BLOCK : HEADER_BLOCK;
	ld	hl, sp+7
	ld	a, [hl]
	or	a, a
	jp	Z, .l00133
	ld	bc, $0011
	jp	.l00134
.l00133:
	ld	bc, $0008
.l00134:
	ld	hl, sp+1
	ld	[hl], c
;src/editor/editor.c:216: line = row ? STATUS_LINE : HEADER_LINE;
	ld	hl, sp+7
	ld	a, [hl]
	or	a, a
	jp	Z, .l00135
	ld	hl, sp+3
	ld	[hl], $13
	xor	a, a
	inc	hl
	ld	[hl], a
	jp	.l00136
.l00135:
	ld	hl, sp+3
	ld	[hl], $12
	xor	a, a
	inc	hl
	ld	[hl], a
.l00136:
	ld	hl, sp+3
	ld	a, [hl]
	inc	hl
	ld	[hl], a
;src/editor/editor.c:217: render_row_fonts[row] = FONT_VWF;
	ld	de, _render_row_fonts
	ld	hl, sp+7
	ld	l, [hl]
	ld	h, $00
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, $01
	ld	[bc], a
	jp	.l00122
.l00116:
;src/editor/editor.c:220: block = OSK_BLOCK + line - tb_rows;
	ld	hl, sp+4
	ld	a, [hl]
	add	a, $09
	ld	hl, _tb_rows
	ld	c, [hl]
	sub	a, c
	ld	hl, sp+1
	ld	[hl], a
;src/editor/editor.c:221: render_row_fonts[row] = FONT_MONO;
	ld	de, _render_row_fonts
	ld	hl, sp+7
	ld	l, [hl]
	ld	h, $00
	add	hl, de
	ld	c, l
	ld	b, h
	xor	a, a
	ld	[bc], a
.l00122:
;src/editor/editor.c:224: render_row_blocks[row] = block;
	ld	de, _render_row_blocks
	ld	hl, sp+7
	ld	l, [hl]
	ld	h, $00
	add	hl, de
	ld	c, l
	ld	b, h
	ld	hl, sp+1
	ld	a, [hl]
	ld	[bc], a
;src/editor/editor.c:225: render_row_lines[row] = line;
	ld	de, _render_row_lines
	ld	hl, sp+7
	ld	l, [hl]
	ld	h, $00
	add	hl, de
	ld	c, l
	ld	b, h
	ld	hl, sp+4
	ld	a, [hl]
	ld	[bc], a
;src/editor/editor.c:226: if (map_blocks[map_row] != block || block_map_rows[block] != map_row) { // a block can still be listed in a map row it left
	ld	de, _map_blocks
	dec	hl
	dec	hl
	ld	l, [hl]
	ld	h, $00
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, [bc]
	ld	d, a
	ld	hl, sp+1
	ld	a, [hl]
	sub	a, d
	jp	NZ,.l00227
	jp	.l00228
.l00227:
	jp	.l00123
.l00228:
	ld	de, _block_map_rows
	ld	hl, sp+1
	ld	l, [hl]
	ld	h, $00
	add	hl, de
	ld	e, l
	ld	d, h
	ld	a, [de]
	ld	e, a
	ld	hl, sp+2
	ld	a, [hl]
	sub	a, e
	jp	NZ,.l00229
	jp	.l00130
.l00229:
.l00123:
;src/editor/editor.c:227: map_blocks[map_row] = block;
	ld	hl, sp+1
	ld	a, [hl]
	ld	[bc], a
;src/editor/editor.c:228: RenderSetMapRow(map_row, block);
	ld	e, [hl]
	inc	hl
	ld	a, [hl]
	call	_RenderSetMapRow
.l00130:
;src/editor/editor.c:204: for (row = 0; row < TB_ROWS; ++row) {
	ld	hl, sp+7
	inc	[hl]
	ld	a, [hl]
	sub	a, $12
	jp	C, .l00129
;src/editor/editor.c:231: render_pending_scy = (ring_top - bars) << 3;
	ld	hl, _ring_top
	ld	a, [hl]
	ld	hl, _bars
	sub	a, [hl]
	add	a, a
	add	a, a
	add	a, a
	ld	hl, _render_pending_scy
	ld	[hl], a
;src/editor/editor.c:232: RenderStage();
	call	_RenderStage
.l00131:
;src/editor/editor.c:233: }
	add	sp, 8
	ret
;src/editor/editor.c:236: static void ScrollRing(unsigned char down) {
;	---------------------------------
; Function ScrollRing
; ---------------------------------
_ScrollRing:
	add	sp, -7
	ld	hl, sp+6
	ld	[hl], a
;src/editor/editor.c:237: unsigned char length = tb_rows + render_gbc;
	ld	hl, _tb_rows
	ld	a, [hl]
	ld	hl, _render_gbc
	add	a, [hl]
	ld	hl, sp+5
	ld	[hl], a
;src/editor/editor.c:239: ring_pos = ring_pos == length - 1 ? 0 : ring_pos + 1;
	ld	hl, _ring_pos
	ld	a, [hl]
	ld	hl, sp+0
	ld	[hl], a
;src/editor/editor.c:240: ring_top = (ring_top + 1) & (BG_MAP_ROWS - 1);
	ld	hl, _ring_top
	ld	a, [hl]
	ld	hl, sp+1
	ld	[hl], a
;src/editor/editor.c:238: if (down) {
	ld	hl, sp+6
	ld	a, [hl]
	or	a, a
	jp	Z, .l00102
;src/editor/editor.c:239: ring_pos = ring_pos == length - 1 ? 0 : ring_pos + 1;
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
;src/editor/editor.c:240: ring_top = (ring_top + 1) & (BG_MAP_ROWS - 1);
	ld	hl, sp+1
	ld	a, [hl]
	inc	a
	and	a, $1F
	ld	hl, _ring_top
	ld	[hl], a
	jp	.l00103
.l00102:
;src/editor/editor.c:243: ring_pos = ring_pos ? ring_pos - 1 : length - 1;
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
;src/editor/editor.c:244: ring_top = (ring_top - 1) & (BG_MAP_ROWS - 1);
	ld	hl, sp+1
	ld	a, [hl]
	dec	a
	and	a, $1F
	ld	hl, _ring_top
	ld	[hl], a
.l00103:
;src/editor/editor.c:246: Layout();
	call	_Layout
.l00104:
;src/editor/editor.c:247: }
	add	sp, 7
	ret
;src/editor/editor.c:250: static void ScrollDown(void) {
;	---------------------------------
; Function ScrollDown
; ---------------------------------
_ScrollDown:
;src/editor/editor.c:251: ScrollRing(1);
	ld	a, $01
	call	_ScrollRing
;src/editor/editor.c:252: tb_ScrollRows(1);
	ld	a, $01
	call	_tb_ScrollRows
;src/editor/editor.c:253: tb_RenderRows(tb_rows - 1, tb_rows);
	ld	hl, _tb_rows
	ld	c, [hl]
	dec	c
	ld	e, [hl]
	ld	a, c
	call	_tb_RenderRows
;src/editor/editor.c:254: top = tb_row_starts[0];
	ld	de, _tb_row_starts + 0
	ld	a, [de]
	ld	hl, _top
	ld	[hl], a
	inc	de
	ld	a, [de]
	inc	hl
	ld	[hl], a
;src/editor/editor.c:255: redraw = 1;
	ld	hl, _redraw
	ld	[hl], $01
.l00101:
;src/editor/editor.c:256: }
	ret
;src/editor/editor.c:259: static void ScrollUp(unsigned int new_top) {
;	---------------------------------
; Function ScrollUp
; ---------------------------------
_ScrollUp:
	ld	c, e
	ld	b, d
;src/editor/editor.c:260: ScrollRing(0);
	push	bc
	xor	a, a
	call	_ScrollRing
	pop	bc
;src/editor/editor.c:261: tb_ScrollRows(0);
	push	bc
	xor	a, a
	call	_tb_ScrollRows
	pop	bc
;src/editor/editor.c:262: tb_row_starts[0] = new_top;
	ld	hl, _tb_row_starts
	ld	[hl], c
	inc	hl
	ld	[hl], b
;src/editor/editor.c:263: tb_RenderRows(0, 1);
	push	bc
	ld	e, $01
	xor	a, a
	call	_tb_RenderRows
	pop	bc
;src/editor/editor.c:264: top = new_top;
	ld	hl, _top
	ld	[hl], c
	inc	hl
	ld	[hl], b
;src/editor/editor.c:265: redraw = 1;
	ld	hl, _redraw
	ld	[hl], $01
.l00101:
;src/editor/editor.c:266: }
	ret
;src/editor/editor.c:270: static void RenderAfterEdit(void) {
;	---------------------------------
; Function RenderAfterEdit
; ---------------------------------
_RenderAfterEdit:
	add	sp, -16
;src/editor/editor.c:271: unsigned char row = edit_row, end_row = tb_end_row, i;
	ld	hl, _edit_row
	ld	a, [hl]
	ld	hl, sp+14
	ld	[hl], a
	ld	hl, _tb_end_row
	ld	a, [hl]
	ld	hl, sp+0
	ld	[hl], a
;src/editor/editor.c:272: unsigned int old_next, old_state, expected, delta = (unsigned int)(int)edit_delta;
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
;src/editor/editor.c:273: if (row) --row; // the previous row's wrapping can change too
	ld	hl, sp+14
	ld	a, [hl]
	or	a, a
	jp	Z, .l00102
	dec	[hl]
.l00102:
;src/editor/editor.c:274: if (end_row != 0xFF && end_row >= row) tb_end_row = 0xFF; // found again while scanning
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
;src/editor/editor.c:275: for (; row < tb_rows; ++row) {
	ld	hl, sp+15
	ld	a, [hl]
	ld	hl, _tb_rows
	sub	a, [hl]
	jp	NC, .l00114
;src/editor/editor.c:276: old_next = tb_row_starts[row + 1];
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
;src/editor/editor.c:277: old_state = tb_row_states[row + 1];
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
;src/editor/editor.c:278: expected = old_next + delta;
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
;src/editor/editor.c:279: tb_RenderRows(row, row + 1);
	push	bc
	ld	hl, sp+7
	ld	e, [hl]
	ld	hl, sp+17
	ld	a, [hl]
	call	_tb_RenderRows
	pop	bc
;src/editor/editor.c:280: if (old_next > edit_pos && tb_row_starts[row + 1] == expected && tb_row_states[row + 1] == old_state) {
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
;src/editor/editor.c:281: for (i = row + 2; i <= tb_rows; ++i) tb_row_starts[i] += delta; // rows below just moved
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
;src/editor/editor.c:282: if (end_row != 0xFF && end_row > row) tb_end_row = end_row;
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
;src/editor/editor.c:283: break;
	jp	.l00114
.l00120:
;src/editor/editor.c:275: for (; row < tb_rows; ++row) {
	ld	hl, sp+15
	inc	[hl]
	ld	a, [hl]
	dec	hl
	ld	[hl], a
	jp	.l00119
.l00114:
;src/editor/editor.c:286: redraw = 1;
	ld	hl, _redraw
	ld	[hl], $01
.l00121:
;src/editor/editor.c:287: }
	add	sp, 16
	ret
;src/editor/editor.c:290: static void Edited(unsigned int pos, signed char delta) {
;	---------------------------------
; Function Edited
; ---------------------------------
_Edited:
	ld	c, a
;src/editor/editor.c:291: modified = 1;
	ld	hl, _modified
	ld	[hl], $01
;src/editor/editor.c:292: if (edited) dirty = 1;
	ld	hl, _edited
	ld	a, [hl]
	or	a, a
	jp	Z, .l00102
	ld	hl, _dirty
	ld	[hl], $01
.l00102:
;src/editor/editor.c:293: edited = 1;
	ld	hl, _edited
	ld	[hl], $01
;src/editor/editor.c:294: edit_row = tb_found_row;
	ld	hl, _tb_found_row
	ld	a, [hl]
	ld	hl, _edit_row
	ld	[hl], a
;src/editor/editor.c:295: edit_pos = pos;
	ld	hl, _edit_pos
	ld	[hl], e
	inc	hl
	ld	[hl], d
;src/editor/editor.c:296: edit_delta = delta;
	ld	hl, _edit_delta
	ld	[hl], c
.l00103:
;src/editor/editor.c:297: }
	ret
;src/editor/editor.c:300: static unsigned char GetSelection(void) {
;	---------------------------------
; Function GetSelection
; ---------------------------------
_GetSelection:
;src/editor/editor.c:301: if (!selecting || anchor == cursor) return 0;
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
;src/editor/editor.c:303: sel_start = anchor;
	ld	hl, _anchor
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
;src/editor/editor.c:304: sel_end = cursor;
	ld	hl, _cursor
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
;src/editor/editor.c:302: if (anchor < cursor) {
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
;src/editor/editor.c:303: sel_start = anchor;
	ld	hl, _sel_start
	ld	[hl], c
	inc	hl
	ld	[hl], b
;src/editor/editor.c:304: sel_end = cursor;
	ld	hl, _sel_end
	ld	[hl], e
	inc	hl
	ld	[hl], d
	jp	.l00106
.l00105:
;src/editor/editor.c:307: sel_start = cursor;
	ld	hl, _sel_start
	ld	[hl], e
	inc	hl
	ld	[hl], d
;src/editor/editor.c:308: sel_end = anchor;
	ld	hl, _sel_end
	ld	[hl], c
	inc	hl
	ld	[hl], b
.l00106:
;src/editor/editor.c:310: return 1;
	ld	a, $01
.l00107:
;src/editor/editor.c:311: }
	ret
;src/editor/editor.c:313: static void ClearSelection(void) {
;	---------------------------------
; Function ClearSelection
; ---------------------------------
_ClearSelection:
;src/editor/editor.c:314: if (selecting) redraw = 1;
	ld	hl, _selecting
	ld	a, [hl]
	or	a, a
	jp	Z, .l00102
	ld	hl, _redraw
	ld	[hl], $01
.l00102:
;src/editor/editor.c:315: selecting = 0;
	ld	hl, _selecting
	ld	[hl], $00
.l00103:
;src/editor/editor.c:316: }
	ret
;src/editor/editor.c:319: static void NoHighlight(void) {
;	---------------------------------
; Function NoHighlight
; ---------------------------------
_NoHighlight:
;src/editor/editor.c:321: for (i = 0; i < TB_ROWS * 2; ++i) render_sel[i] = 0;
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
;src/editor/editor.c:322: if (bars) render_sel[1] = render_sel[(TB_ROWS << 1) - 1] = 0xFF;
	ld	hl, _bars
	ld	a, [hl]
	or	a, a
	jp	Z, .l00106
	ld	hl, (_render_sel + 35)
	ld	[hl], $FF
	ld	hl, (_render_sel + 1)
	ld	[hl], $FF
.l00106:
;src/editor/editor.c:323: }
	ret
;src/editor/editor.c:326: static void SetHighlight(void) {
;	---------------------------------
; Function SetHighlight
; ---------------------------------
_SetHighlight:
	add	sp, -12
;src/editor/editor.c:329: NoHighlight();
	call	_NoHighlight
;src/editor/editor.c:330: if (!GetSelection()) return;
	call	_GetSelection
	ld	c, a
	ld	a, c
	or	a, a
	jp	NZ, .l00140
	jp	.l00119
;src/editor/editor.c:331: for (row = 0; row < tb_rows; ++row) {
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
;src/editor/editor.c:332: row_start = tb_row_starts[row];
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
;src/editor/editor.c:333: next = tb_row_starts[row + 1];
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
;src/editor/editor.c:334: if (sel_end <= row_start) break;
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
;src/editor/editor.c:335: if (sel_start >= next) continue;
	ld	de, _sel_start
	ld	hl, sp+9
	ld	a, [de]
	inc	de
	sub	a, [hl]
	inc	hl
	ld	a, [de]
	sbc	a, [hl]
	jp	NC, .l00115
;src/editor/editor.c:336: count = tb_row_counts[row];
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
;src/editor/editor.c:337: base = row_start + (tb_nowrap ? tb_left : 0); // first drawn character
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
;src/editor/editor.c:338: first = 0;
	inc	hl
	ld	[hl], $00
;src/editor/editor.c:339: if (sel_start > base) first = sel_start - base > count ? count : (unsigned char)(sel_start - base);
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
;src/editor/editor.c:340: if (sel_end < next || row == tb_end_row) { // ends in this row
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
;src/editor/editor.c:341: end = sel_end <= base ? 0 : sel_end - base > count ? count : (unsigned char)(sel_end - base);
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
;src/editor/editor.c:342: if (end <= first) continue;
	ld	hl, sp+5
	ld	a, [hl]
	ld	hl, sp+10
	sub	a, [hl]
	jp	C, .l00113
	jp	.l00115
.l00112:
;src/editor/editor.c:344: else end = 0xFF; // continues, so the line feed or wrap is selected too
	ld	hl, sp+10
	ld	[hl], $FF
.l00113:
;src/editor/editor.c:345: render_sel[(row + bars) << 1] = first;
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
;src/editor/editor.c:346: render_sel[((row + bars) << 1) + 1] = end;
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
;src/editor/editor.c:331: for (row = 0; row < tb_rows; ++row) {
	ld	hl, sp+11
	inc	[hl]
	jp	.l00118
.l00119:
;src/editor/editor.c:348: }
	add	sp, 12
	ret
;src/editor/editor.c:351: static unsigned int LinesBefore(unsigned int pos) {
;	---------------------------------
; Function LinesBefore
; ---------------------------------
_LinesBefore:
;src/editor/editor.c:352: if (pos >= counted_pos) counted_lines += tb_CountLines(counted_pos, pos);
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
;src/editor/editor.c:353: else if (pos < counted_pos - pos) counted_lines = tb_CountLines(0, pos);
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
;src/editor/editor.c:354: else counted_lines -= tb_CountLines(pos, counted_pos);
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
;src/editor/editor.c:355: counted_pos = pos;
	ld	hl, _counted_pos
	ld	[hl], e
	inc	hl
	ld	[hl], d
;src/editor/editor.c:356: return counted_lines;
	ld	hl, _counted_lines
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
.l00107:
;src/editor/editor.c:357: }
	ret
;src/editor/editor.c:360: static void CountEdit(unsigned int pos, unsigned char c, unsigned char inserted) {
;	---------------------------------
; Function CountEdit
; ---------------------------------
_CountEdit:
	ld	c, a
;src/editor/editor.c:361: if (pos >= counted_pos) return;
	ld	hl, _counted_pos
	ld	a, e
	sub	a, [hl]
	inc	hl
	ld	a, d
	sbc	a, [hl]
	jp	C, .l00102
	jp	.l00110
.l00102:
;src/editor/editor.c:364: if (c == ASCII_LF) ++counted_lines;
	ld	a, c
	sub	a, $0A
	jp	NZ,.l00132
	ld	a,$01
	jp	.l00133
.l00132:
	xor	a,a
.l00133:
	ld	c, a
;src/editor/editor.c:362: if (inserted) {
	ld	hl, sp+2
	ld	a, [hl]
	or	a, a
	jp	Z, .l00108
;src/editor/editor.c:363: ++counted_pos;
	ld	hl, _counted_pos
	inc	[hl]
	jp	NZ, .l00134
	inc	hl
	inc	[hl]
.l00134:
;src/editor/editor.c:364: if (c == ASCII_LF) ++counted_lines;
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
;src/editor/editor.c:367: --counted_pos;
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
;src/editor/editor.c:368: if (c == ASCII_LF) --counted_lines;
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
;src/editor/editor.c:370: }
	pop	hl
	inc	sp
	jp hl 
;src/editor/editor.c:373: static void Uncount(unsigned int pos) {
;	---------------------------------
; Function Uncount
; ---------------------------------
_Uncount:
;src/editor/editor.c:374: if (pos < counted_pos) counted_pos = counted_lines = 0;
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
;src/editor/editor.c:375: }
	ret
;src/editor/editor.c:378: static unsigned char RowEndsLine(unsigned char row) {
;	---------------------------------
; Function RowEndsLine
; ---------------------------------
_RowEndsLine:
	ld	e, a
;src/editor/editor.c:379: return tb_GetChar(tb_row_starts[row + 1] - 1) == ASCII_LF;
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
;src/editor/editor.c:380: }
	ret
;src/editor/editor.c:382: static unsigned int CursorLine(void) {
;	---------------------------------
; Function CursorLine
; ---------------------------------
_CursorLine:
;src/editor/editor.c:383: unsigned int line = LinesBefore(top) + 1;
	ld	hl, _top
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_LinesBefore
	inc	bc
;src/editor/editor.c:385: for (row = 0; row < tb_found_row; ++row) if (RowEndsLine(row)) ++line;
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
;src/editor/editor.c:386: return line;
.l00107:
;src/editor/editor.c:387: }
	ret
;src/editor/editor.c:389: static unsigned int CursorColumn(void) {
;	---------------------------------
; Function CursorColumn
; ---------------------------------
_CursorColumn:
	dec	sp
	dec	sp
;src/editor/editor.c:390: unsigned char row = tb_found_row;
	ld	hl, _tb_found_row
	ld	c, [hl]
;src/editor/editor.c:392: while (row && !RowEndsLine(row - 1)) --row;
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
;src/editor/editor.c:393: start = tb_row_starts[row];
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
;src/editor/editor.c:394: if (!row && start && tb_GetChar(start - 1) != ASCII_LF) start = tb_LineStart(start);
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
;src/editor/editor.c:395: return cursor - start + 1;
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
;src/editor/editor.c:396: }
	inc	sp
	inc	sp
	ret
;src/editor/editor.c:398: static char* PutText(char* dest, const char* text) {
;	---------------------------------
; Function PutText
; ---------------------------------
_PutText:
;src/editor/editor.c:399: while (*text) *dest++ = *text++;
.l00101:
	ld	a, [bc]
	or	a, a
	jp	Z, .l00103
	inc	bc
	ld	[de], a
	inc	de
	jp	.l00101
.l00103:
;src/editor/editor.c:400: return dest;
	ld	c, e
	ld	b, d
.l00104:
;src/editor/editor.c:401: }
	ret
;src/editor/editor.c:405: static char* PutNumber(char* dest, unsigned int n) {
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
;src/editor/editor.c:406: unsigned char i, digit, started = 0;
	ld	hl, sp+0
	ld	[hl], $00
;src/editor/editor.c:407: for (i = 0; i < 4; ++i) {
	ld	hl, sp+6
	ld	[hl], $00
;src/editor/editor.c:409: while (n >= powers_of_ten[i]) {
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
;src/editor/editor.c:410: n -= powers_of_ten[i];
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
;src/editor/editor.c:411: ++digit;
	ld	hl, sp+7
	inc	[hl]
	jp	.l00101
.l00117:
	ld	hl, sp+7
	ld	a, [hl]
	ld	hl, sp+1
	ld	[hl], a
;src/editor/editor.c:413: if (started || digit != '0') {
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
;src/editor/editor.c:414: *dest++ = digit;
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
;src/editor/editor.c:415: started = 1;
	ld	hl, sp+0
	ld	[hl], $01
.l00109:
;src/editor/editor.c:407: for (i = 0; i < 4; ++i) {
	ld	hl, sp+6
	inc	[hl]
	ld	a, [hl]
	sub	a, $04
	jp	C, .l00113
;src/editor/editor.c:418: *dest++ = '0' + (unsigned char)n;
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
;src/editor/editor.c:419: return dest;
.l00110:
;src/editor/editor.c:420: }
	add	sp, 8
	ret
_powers_of_ten:
	DW $2710
	DW $03E8
	DW $0064
	DW $000A
;src/editor/editor.c:423: static char* PutNumber2(char* dest, unsigned int n) {
;	---------------------------------
; Function PutNumber2
; ---------------------------------
_PutNumber2:
;src/editor/editor.c:424: if (n < 10) *dest++ = '0';
	ld	a, c
	sub	a, $0A
	ld	a, b
	sbc	a, $00
	jp	NC, .l00102
	ld	a, $30
	ld	[de], a
	inc	de
.l00102:
;src/editor/editor.c:425: return PutNumber(dest, n);
	jp	_PutNumber
.l00103:
;src/editor/editor.c:426: }
	ret
;src/editor/editor.c:429: static char* ToLatin1(char* dest, const char* text, unsigned char count) {
;	---------------------------------
; Function ToLatin1
; ---------------------------------
_ToLatin1:
	add	sp, -9
	ld	hl, sp+4
	ld	[hl], e
	inc	hl
	ld	[hl], d
;src/editor/editor.c:431: while ((c = *text++) && count--) {
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
;src/editor/editor.c:432: if (c >= 0x80) {
	inc	hl
	inc	hl
	ld	a, [hl]
	sub	a, $80
	jp	C, .l00111
;src/editor/editor.c:433: next = *text;
	ld	a, [bc]
	ld	e, a
;src/editor/editor.c:434: if ((c & 0xFE) == 0xC2 && (next & 0xC0) == 0x80) { // U+0080-U+00FF
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
;src/editor/editor.c:435: ++text;
	inc	bc
;src/editor/editor.c:436: c = (c << 6) | (next & 0x3F);
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
;src/editor/editor.c:437: if (c < 0xA0) c = '?';
	ld	a, [hl]
	sub	a, $A0
	jp	NC, .l00111
	ld	[hl], $3F
	jp	.l00111
;src/editor/editor.c:440: while ((*text & 0xC0) == 0x80) ++text;
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
;src/editor/editor.c:441: c = '?';
	ld	[hl], $3F
.l00111:
;src/editor/editor.c:444: *dest++ = c;
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
;src/editor/editor.c:446: return dest;
	ld	hl, sp+4
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
.l00116:
;src/editor/editor.c:447: }
	add	sp, 9
	pop	hl
	inc	sp
	jp hl 
;src/editor/editor.c:450: static void ToUtf8(char* dest, const char* text) {
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
;src/editor/editor.c:452: while ((c = *text++)) {
.l00103:
	ld	a, [bc]
	inc	bc
	ld	e, a
	or	a, a
	jp	Z, .l00105
;src/editor/editor.c:453: if (c >= 0x80) {
	ld	a, e
	sub	a, $80
	jp	C, .l00102
;src/editor/editor.c:454: *dest++ = 0xC0 | (c >> 6);
	ld	a, e
	rlca
	rlca
	and	a, $03
	or	a, $C0
	ld	[hl], a
	inc	hl
;src/editor/editor.c:455: c = 0x80 | (c & 0x3F);
	ld	a, e
	and	a, $3F
	ld	e, a
	set	7, e
.l00102:
;src/editor/editor.c:457: *dest++ = c;
	ld	[hl], e
	inc	hl
	jp	.l00103
.l00105:
;src/editor/editor.c:459: *dest = 0;
	ld	[hl], $00
.l00106:
;src/editor/editor.c:460: }
	ret
;src/editor/editor.c:463: static void PutPath(char* dest, const char* path, unsigned char count) {
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
;src/editor/editor.c:465: while (path[length]) ++length;
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
;src/editor/editor.c:466: if (!length) path = "/";
	ld	a, e
	or	a, a
	jp	NZ, .l00107
	ld	hl, sp+0
	ld	a, LOW(___str_29)
	ld	[hl], a
	inc	hl
	ld	a, HIGH(___str_29)
	ld	[hl], a
	jp	.l00108
.l00107:
;src/editor/editor.c:467: else if (length > count) {
	ld	hl, sp+6
	ld	a, [hl]
	sub	a, e
	jp	NC, .l00108
;src/editor/editor.c:468: dest = PutText(dest, "...");
	push	de
	ld	bc, ___str_30
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
;src/editor/editor.c:469: path += length - count;
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
;src/editor/editor.c:471: *ToLatin1(dest, path, count) = 0;
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
;src/editor/editor.c:472: }
	add	sp, 4
	pop	hl
	inc	sp
	jp hl 
___str_29:
	DB "/"
	DB $00
___str_30:
	DB "..."
	DB $00
;src/editor/editor.c:475: static unsigned char JoinPath(char* dest, const char* dir, const char* name, unsigned char size) {
;	---------------------------------
; Function JoinPath
; ---------------------------------
_JoinPath:
	add	sp, -6
	inc	sp
	inc	sp
	push	de
;src/editor/editor.c:476: while (*dir) {
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
;src/editor/editor.c:477: if (!--size) return 0;
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
;src/editor/editor.c:478: *dest++ = *dir++;
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
;src/editor/editor.c:480: if (!--size) return 0;
	ld	hl, sp+10
	dec	[hl]
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00107
	xor	a, a
	jp	.l00113
.l00107:
;src/editor/editor.c:481: *dest++ = '/';
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
;src/editor/editor.c:482: while (*name) {
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
;src/editor/editor.c:483: if (!--size) return 0;
	dec	a
	or	a, a
	jp	NZ, .l00109
	xor	a, a
	jp	.l00113
.l00109:
;src/editor/editor.c:484: *dest++ = *name++;
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
;src/editor/editor.c:486: *dest = 0;
	ld	hl, sp+3
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	ld	[hl], $00
;src/editor/editor.c:487: return 1;
	ld	a, $01
.l00113:
;src/editor/editor.c:488: }
	add	sp, 6
	pop	hl
	add	sp, 3
	jp hl 
;src/editor/editor.c:491: static void UpdateBars(void) {
;	---------------------------------
; Function UpdateBars
; ---------------------------------
_UpdateBars:
	add	sp, -40
;src/editor/editor.c:493: char* end = file_name[0] ? ToLatin1(text, file_name, TB_STRIDE - 3) : PutText(text, "Untitled");
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
	ld	bc, ___str_31
	ld	hl, 0
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_PutText
.l00111:
;src/editor/editor.c:494: if (modified) *end++ = '*';
	ld	hl, _modified
	ld	a, [hl]
	or	a, a
	jp	Z, .l00102
	ld	a, $2A
	ld	[bc], a
	inc	bc
.l00102:
;src/editor/editor.c:495: *end = 0;
	xor	a, a
	ld	[bc], a
;src/editor/editor.c:496: DrawRow(HEADER_LINE, 1, text);
	ld	hl, 0
	add	hl, sp
	push	hl
	ld	e, $01
	ld	a, $12
	call	_DrawRow
;src/editor/editor.c:497: if (tb_found_row == 0xFF) return; // cursor isn't on screen
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
;src/editor/editor.c:498: if (GetSelection()) {
	call	_GetSelection
	ld	c, a
	ld	a, c
	or	a, a
	jp	Z, .l00106
;src/editor/editor.c:499: end = PutNumber(text, sel_end - sel_start);
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
;src/editor/editor.c:500: end = PutText(end, " selected");
	ld	bc, ___str_32
	call	_PutText
	ld	e, c
	ld	d, b
	jp	.l00107
.l00106:
;src/editor/editor.c:503: end = PutText(text, "Line ");
	ld	bc, ___str_33
	ld	hl, 0
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_PutText
	ld	e, c
	ld	d, b
;src/editor/editor.c:504: end = PutNumber(end, CursorLine());
	push	de
	call	_CursorLine
	pop	de
	call	_PutNumber
	ld	e, c
	ld	d, b
;src/editor/editor.c:505: end = PutText(end, ", Col ");
	ld	bc, ___str_34
	call	_PutText
	ld	e, c
	ld	d, b
;src/editor/editor.c:506: end = PutNumber(end, CursorColumn());
	push	de
	call	_CursorColumn
	pop	de
	call	_PutNumber
	ld	e, c
	ld	d, b
.l00107:
;src/editor/editor.c:508: *end = 0;
	xor	a, a
	ld	[de], a
;src/editor/editor.c:509: DrawRow(STATUS_LINE, 1, text);
	ld	hl, 0
	add	hl, sp
	push	hl
	ld	e, $01
	ld	a, $13
	call	_DrawRow
.l00108:
;src/editor/editor.c:510: }
	add	sp, 40
	ret
___str_31:
	DB "Untitled"
	DB $00
___str_32:
	DB " selected"
	DB $00
___str_33:
	DB "Line "
	DB $00
___str_34:
	DB ", Col "
	DB $00
;src/editor/editor.c:512: static void Draw(void) {
;	---------------------------------
; Function Draw
; ---------------------------------
_Draw:
;src/editor/editor.c:513: SetHighlight();
	call	_SetHighlight
;src/editor/editor.c:514: if (bars) UpdateBars();
	ld	hl, _bars
	ld	a, [hl]
	or	a, a
	jp	Z, .l00102
	call	_UpdateBars
.l00102:
;src/editor/editor.c:515: EditorDraw();
	jp	_EditorDraw
.l00103:
;src/editor/editor.c:516: }
	ret
;src/editor/editor.c:519: static void ScrollTo(unsigned int new_top) {
;	---------------------------------
; Function ScrollTo
; ---------------------------------
_ScrollTo:
	ld	hl, _top
	ld	[hl], e
	inc	hl
	ld	[hl], d
;src/editor/editor.c:521: Render();
	call	_Render
;src/editor/editor.c:522: redraw = 1;
	ld	hl, _redraw
	ld	[hl], $01
.l00101:
;src/editor/editor.c:523: }
	ret
;src/editor/editor.c:525: static void MoveUp(void) {
;	---------------------------------
; Function MoveUp
; ---------------------------------
_MoveUp:
;src/editor/editor.c:526: unsigned char row = tb_found_row;
	ld	hl, _tb_found_row
	ld	a, [hl]
;src/editor/editor.c:527: keep_x = 1;
	ld	hl, _keep_x
	ld	[hl], $01
;src/editor/editor.c:528: if (row) cursor = PosAtX(row - 1, want_x);
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
;src/editor/editor.c:529: else if (!top) cursor = 0;
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
;src/editor/editor.c:531: ScrollUp(tb_RowStart(top - 1));
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
;src/editor/editor.c:532: cursor = PosAtX(0, want_x);
	ld	hl, _want_x
	ld	e, [hl]
	xor	a, a
	call	_PosAtX
	ld	hl, _cursor
	ld	[hl], c
	inc	hl
	ld	[hl], b
.l00107:
;src/editor/editor.c:534: }
	ret
;src/editor/editor.c:536: static void MoveDown(void) {
;	---------------------------------
; Function MoveDown
; ---------------------------------
_MoveDown:
	dec	sp
;src/editor/editor.c:537: unsigned char row = tb_found_row;
	ld	hl, _tb_found_row
	ld	a, [hl]
	ld	hl, sp+0
	ld	[hl], a
;src/editor/editor.c:538: keep_x = 1;
	ld	hl, _keep_x
	ld	[hl], $01
;src/editor/editor.c:539: if (tb_end_row == row) cursor = tb_Length(); // last row
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
;src/editor/editor.c:540: else if (row + 1 < tb_rows) cursor = PosAtX(row + 1, want_x);
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
;src/editor/editor.c:542: ScrollDown();
	call	_ScrollDown
;src/editor/editor.c:543: cursor = PosAtX(row, want_x);
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
;src/editor/editor.c:545: }
	inc	sp
	ret
;src/editor/editor.c:547: static void PageUp(void) {
;	---------------------------------
; Function PageUp
; ---------------------------------
_PageUp:
;src/editor/editor.c:548: unsigned char row = tb_found_row, i;
	ld	hl, _tb_found_row
	ld	c, [hl]
;src/editor/editor.c:549: keep_x = 1;
	ld	hl, _keep_x
	ld	[hl], $01
;src/editor/editor.c:550: if (!top) {
	ld	hl, _top + 1
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	jp	NZ, .l00102
;src/editor/editor.c:551: cursor = 0;
	xor	a, a
	ld	hl, _cursor
	ld	[hl], a
	inc	hl
	ld	[hl], a
;src/editor/editor.c:552: return;
	jp	.l00108
.l00102:
;src/editor/editor.c:554: for (i = tb_rows - 1; i && top; --i) top = tb_RowStart(top - 1);
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
;src/editor/editor.c:555: ScrollTo(top);
	push	bc
	ld	hl, _top
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_ScrollTo
	pop	bc
;src/editor/editor.c:556: cursor = PosAtX(row, want_x);
	ld	hl, _want_x
	ld	e, [hl]
	ld	a, c
	call	_PosAtX
	ld	hl, _cursor
	ld	[hl], c
	inc	hl
	ld	[hl], b
.l00108:
;src/editor/editor.c:557: }
	ret
;src/editor/editor.c:559: static void PageDown(void) {
;	---------------------------------
; Function PageDown
; ---------------------------------
_PageDown:
;src/editor/editor.c:560: unsigned char row = tb_found_row;
	ld	hl, _tb_found_row
	ld	c, [hl]
;src/editor/editor.c:561: keep_x = 1;
	ld	hl, _keep_x
	ld	[hl], $01
;src/editor/editor.c:562: if (tb_end_row != 0xFF) {
	ld	hl, _tb_end_row
	ld	a, [hl]
	inc	a
	jp	NZ,.l00123
	jp	.l00102
.l00123:
;src/editor/editor.c:563: cursor = tb_Length();
	call	_tb_Length
	ld	hl, _cursor
	ld	[hl], c
	inc	hl
	ld	[hl], b
;src/editor/editor.c:564: return;
	jp	.l00106
.l00102:
;src/editor/editor.c:566: ScrollTo(tb_row_starts[tb_rows - 1]);
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
;src/editor/editor.c:567: if (tb_end_row != 0xFF && row > tb_end_row) row = tb_end_row;
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
;src/editor/editor.c:568: cursor = PosAtX(row, want_x);
	ld	hl, _want_x
	ld	e, [hl]
	ld	a, c
	call	_PosAtX
	ld	hl, _cursor
	ld	[hl], c
	inc	hl
	ld	[hl], b
.l00106:
;src/editor/editor.c:569: }
	ret
;src/editor/editor.c:572: static void MoveEnd(void) {
;	---------------------------------
; Function MoveEnd
; ---------------------------------
_MoveEnd:
	add	sp, -4
;src/editor/editor.c:573: unsigned char row = tb_found_row, count = tb_row_counts[row];
	ld	hl, _tb_found_row
	ld	c, [hl]
	ld	hl, _tb_row_counts
	ld	b, $00
	add	hl, bc
	ld	b, [hl]
;src/editor/editor.c:574: if (tb_nowrap) {
	ld	hl, _tb_nowrap
	ld	a, [hl]
	or	a, a
	jp	Z, .l00102
;src/editor/editor.c:575: cursor = LineEnd(row);
	ld	a, c
	call	_LineEnd
	ld	hl, _cursor
	ld	[hl], c
	inc	hl
	ld	[hl], b
;src/editor/editor.c:576: return;
	jp	.l00108
.l00102:
;src/editor/editor.c:578: cursor = tb_row_starts[row] + count;
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
	ld	hl, sp+2
	ld	[hl], a
	inc	de
	ld	a, [de]
	inc	hl
	ld	[hl], a
	ld	hl, sp+0
	ld	[hl], b
	inc	hl
	ld	[hl], $00
	pop	de
	push	de
	inc	hl
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	add	hl, de
	ld	e, l
	ld	d, h
	ld	hl, _cursor
	ld	[hl], e
	inc	hl
	ld	[hl], d
;src/editor/editor.c:579: if (count && cursor == tb_row_starts[row + 1] && tb_end_row != row && RowAddress(row)[count - 1] == ' ') --cursor;
	ld	a, b
	or	a, a
	jp	Z, .l00108
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
	ld	e, l
	ld	d, h
	ld	a, [de]
	ld	hl, sp+2
	ld	[hl], a
	inc	de
	ld	a, [de]
	inc	hl
	ld	[hl], a
	ld	hl, _cursor
	ld	a, [hl]
	ld	hl, sp+2
	sub	a, [hl]
	jp	NZ,.l00135
	ld	hl, _cursor + 1
	ld	a, [hl]
	ld	hl, sp+3
	sub	a, [hl]
	jp	NZ,.l00135
	jp	.l00136
.l00135:
	jp	.l00108
.l00136:
	ld	hl, _tb_end_row
	ld	a, [hl]
	sub	a, c
	jp	NZ,.l00137
	jp	.l00108
.l00137:
	ld	a, c
	call	_RowAddress
	ld	hl, sp+2
	ld	[hl], c
	inc	hl
	ld	[hl], b
	pop	bc
	push	bc
	dec	bc
	ld	hl, sp+2
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	add	hl, bc
	ld	c, l
	ld	b, h
	ld	a, [bc]
	sub	a, $20
	jp	NZ,.l00138
	jp	.l00139
.l00138:
	jp	.l00108
.l00139:
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
.l00108:
;src/editor/editor.c:580: }
	add	sp, 4
	ret
;src/editor/editor.c:582: static void DeleteSelection(void) {
;	---------------------------------
; Function DeleteSelection
; ---------------------------------
_DeleteSelection:
;src/editor/editor.c:583: UndoDeleting(sel_start, sel_end - sel_start);
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
	call	_UndoDeleting
;src/editor/editor.c:584: Uncount(sel_start);
	ld	hl, _sel_start
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_Uncount
;src/editor/editor.c:585: tb_DeleteRange(sel_start, sel_end - sel_start);
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
;src/editor/editor.c:586: cursor = sel_start;
	ld	hl, _sel_start
	ld	a, [hl]
	ld	hl, _cursor
	ld	[hl], a
	ld	hl, _sel_start + 1
	ld	a, [hl]
	ld	hl, _cursor + 1
	ld	[hl], a
;src/editor/editor.c:587: selecting = 0;
	ld	hl, _selecting
	ld	[hl], $00
;src/editor/editor.c:588: modified = 1;
	ld	hl, _modified
	ld	[hl], $01
;src/editor/editor.c:589: dirty = 1;
	ld	hl, _dirty
	ld	[hl], $01
.l00101:
;src/editor/editor.c:590: }
	ret
;src/editor/editor.c:592: static unsigned char Copy(void) {
;	---------------------------------
; Function Copy
; ---------------------------------
_Copy:
;src/editor/editor.c:593: if (!GetSelection()) return 0;
	call	_GetSelection
	or	a, a
	jp	NZ, .l00102
	xor	a, a
	jp	.l00105
.l00102:
;src/editor/editor.c:594: if (tb_Copy(sel_start, sel_end - sel_start)) return 1;
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
;src/editor/editor.c:595: ShowMessage("TOO BIG TO COPY");
	ld	de, ___str_35
	call	_ShowMessage
;src/editor/editor.c:596: return 0;
	xor	a, a
.l00105:
;src/editor/editor.c:597: }
	ret
___str_35:
	DB "TOO BIG TO COPY"
	DB $00
;src/editor/editor.c:599: static void Paste(void) {
;	---------------------------------
; Function Paste
; ---------------------------------
_Paste:
	add	sp, -6
;src/editor/editor.c:600: unsigned int length = tb_ClipLength(), room = TB_SIZE - tb_Length();
	call	_tb_ClipLength
	ld	hl, sp+4
	ld	[hl], c
	inc	hl
	ld	[hl], b
	ld	hl, sp+4
	ld	a, [hl]
	ld	hl, sp+0
	ld	[hl], a
	ld	hl, sp+5
	ld	a, [hl]
	ld	hl, sp+1
	ld	[hl], a
	call	_tb_Length
	ld	hl, sp+2
	ld	[hl], c
	inc	hl
	ld	[hl], b
	ld	de, $FF80
	ld	hl, sp+2
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	ld	a, e
	sub	a, l
	ld	e, a
	ld	a, d
	sbc	a, h
	ld	hl, sp+5
	ld	[hl], a
	dec	hl
	ld	[hl], e
;src/editor/editor.c:601: if (!length) return;
	ld	hl, sp+1
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	jp	NZ, .l00102
	jp	.l00109
.l00102:
;src/editor/editor.c:602: if (GetSelection()) room += sel_end - sel_start;
	call	_GetSelection
	or	a, a
	jp	Z, .l00104
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
	ld	hl, sp+4
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	add	hl, bc
	push	hl
	ld	a, l
	ld	hl, sp+6
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+5
	ld	[hl], a
.l00104:
;src/editor/editor.c:603: if (length > room) {
	ld	hl, sp+4
	ld	e, l
	ld	d, h
	ld	hl, sp+0
	ld	a, [de]
	inc	de
	sub	a, [hl]
	inc	hl
	ld	a, [de]
	sbc	a, [hl]
	jp	NC, .l00106
;src/editor/editor.c:604: ShowMessage("TEXT FULL");
	ld	de, ___str_36
	call	_ShowMessage
;src/editor/editor.c:605: return;
	jp	.l00109
.l00106:
;src/editor/editor.c:607: undo_join = GetSelection();
	call	_GetSelection
	ld	hl, _undo_join
	ld	[hl], a
;src/editor/editor.c:608: if (undo_join) DeleteSelection();
	ld	a, [hl]
	or	a, a
	jp	Z, .l00108
	call	_DeleteSelection
.l00108:
;src/editor/editor.c:609: Uncount(cursor);
	ld	hl, _cursor
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_Uncount
;src/editor/editor.c:610: tb_Paste(cursor);
	ld	hl, _cursor
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_tb_Paste
;src/editor/editor.c:611: UndoInserted(cursor, length);
	pop	bc
	push	bc
	ld	hl, _cursor
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_UndoInserted
;src/editor/editor.c:612: cursor += length;
	ld	hl, _cursor + 1
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	pop	hl
	push	hl
	add	hl, de
	ld	e, l
	ld	d, h
	ld	hl, _cursor
	ld	[hl], e
	inc	hl
	ld	[hl], d
;src/editor/editor.c:613: modified = 1;
	ld	hl, _modified
	ld	[hl], $01
;src/editor/editor.c:614: dirty = 1;
	ld	hl, _dirty
	ld	[hl], $01
.l00109:
;src/editor/editor.c:615: }
	add	sp, 6
	ret
___str_36:
	DB "TEXT FULL"
	DB $00
;src/editor/editor.c:618: static unsigned char CharClass(unsigned char c) {
;	---------------------------------
; Function CharClass
; ---------------------------------
_CharClass:
	ld	c, a
;src/editor/editor.c:619: if (c == ' ' || c == ASCII_TAB || c == ASCII_LF) return 0;
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
;src/editor/editor.c:620: if ((c >= '0' && c <= '9') || (c >= 'A' && c <= 'Z') || (c >= 'a' && c <= 'z') || c == '_' || c >= 0xC0) return 1;
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
;src/editor/editor.c:621: return 2;
	ld	a, $02
.l00114:
;src/editor/editor.c:622: }
	ret
;src/editor/editor.c:625: static void WordRight(void) {
;	---------------------------------
; Function WordRight
; ---------------------------------
_WordRight:
	dec	sp
;src/editor/editor.c:626: unsigned int length = tb_Length();
	call	_tb_Length
;src/editor/editor.c:628: while (cursor < length && !CharClass(tb_GetChar(cursor))) ++cursor;
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
;src/editor/editor.c:629: if (cursor == length) return;
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
;src/editor/editor.c:630: token = CharClass(tb_GetChar(cursor));
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
;src/editor/editor.c:631: do ++cursor;
.l00108:
	ld	hl, _cursor
	inc	[hl]
	jp	NZ, .l00146
	inc	hl
	inc	[hl]
.l00146:
;src/editor/editor.c:632: while (cursor < length && CharClass(tb_GetChar(cursor)) == token);
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
;src/editor/editor.c:633: }
	inc	sp
	ret
;src/editor/editor.c:636: static void WordLeft(void) {
;	---------------------------------
; Function WordLeft
; ---------------------------------
_WordLeft:
;src/editor/editor.c:638: while (cursor && !CharClass(tb_GetChar(cursor - 1))) --cursor;
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
;src/editor/editor.c:639: if (!cursor) return;
	ld	hl, _cursor + 1
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	jp	NZ, .l00106
	jp	.l00111
.l00106:
;src/editor/editor.c:640: token = CharClass(tb_GetChar(cursor - 1));
	call	_tb_GetChar
	ld	c, a
	ld	a, c
	call	_CharClass
	ld	c, a
;src/editor/editor.c:641: do --cursor;
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
;src/editor/editor.c:642: while (cursor && CharClass(tb_GetChar(cursor - 1)) == token);
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
;src/editor/editor.c:643: }
	ret
;src/editor/editor.c:646: static void ScrollLine(unsigned char down) {
;	---------------------------------
; Function ScrollLine
; ---------------------------------
_ScrollLine:
	ld	c, a
;src/editor/editor.c:647: unsigned char row = tb_found_row;
	ld	hl, _tb_found_row
	ld	b, [hl]
;src/editor/editor.c:648: keep_x = 1;
	ld	hl, _keep_x
	ld	[hl], $01
;src/editor/editor.c:649: if (down) {
	ld	a, c
	or	a, a
	jp	Z, .l00110
;src/editor/editor.c:650: if (tb_end_row != 0xFF) return; // the end of the text is on screen
	ld	hl, _tb_end_row
	ld	a, [hl]
	inc	a
	jp	NZ,.l00139
	jp	.l00102
.l00139:
	jp	.l00112
.l00102:
;src/editor/editor.c:651: ScrollDown();
	push	bc
	call	_ScrollDown
	pop	bc
;src/editor/editor.c:652: if (!row) cursor = PosAtX(0, want_x);
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
;src/editor/editor.c:654: else if (top) {
	ld	hl, _top + 1
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	jp	Z, .l00112
;src/editor/editor.c:655: ScrollUp(tb_RowStart(top - 1));
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
;src/editor/editor.c:656: if (row == tb_rows - 1) cursor = PosAtX(row, want_x);
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
;src/editor/editor.c:658: }
	ret
;src/editor/editor.c:661: static void UndoRedo(unsigned char redo) {
;	---------------------------------
; Function UndoRedo
; ---------------------------------
_UndoRedo:
	ld	c, a
;src/editor/editor.c:662: if (!(redo ? Redo() : Undo())) return;
	ld	a, c
	or	a, a
	jp	Z, .l00105
	call	_Redo
	jp	.l00106
.l00105:
	call	_Undo
.l00106:
	or	a, a
	jp	NZ, .l00102
	jp	.l00103
.l00102:
;src/editor/editor.c:663: cursor = undo_cursor;
	ld	hl, _undo_cursor
	ld	a, [hl]
	ld	hl, _cursor
	ld	[hl], a
	ld	hl, _undo_cursor + 1
	ld	a, [hl]
	ld	hl, _cursor + 1
	ld	[hl], a
;src/editor/editor.c:664: selecting = 0;
	ld	hl, _selecting
	ld	[hl], $00
;src/editor/editor.c:665: Uncount(0);
	ld	de, $0000
	call	_Uncount
;src/editor/editor.c:666: modified = !undo_at_save;
	ld	hl, _undo_at_save
	ld	a, [hl]
	sub	a,$01
	ld	a, $00
	rla
	ld	hl, _modified
	ld	[hl], a
;src/editor/editor.c:667: dirty = 1;
	ld	hl, _dirty
	ld	[hl], $01
.l00103:
;src/editor/editor.c:668: }
	ret
;src/editor/editor.c:671: static void HandleCtrlKey(unsigned char key, unsigned char mods) {
;	---------------------------------
; Function HandleCtrlKey
; ---------------------------------
_HandleCtrlKey:
	ld	l, a
;	spillPairReg hl
;	spillPairReg hl
;src/editor/editor.c:672: if (key >= 'A' && key <= 'Z') key += 'a' - 'A';
	ld	a, l
	sub	a, $41
	jp	C, .l00102
	ld	a, $5A
	sub	a, l
	jp	C, .l00102
	ld	c, $20
	add	hl, bc
.l00102:
;src/editor/editor.c:673: if (key == 'z') UndoRedo(mods & KB_MOD_SHIFT);
	ld	a, l
	sub	a, $7A
	jp	NZ,.l00168
	jp	.l00169
.l00168:
	jp	.l00107
.l00169:
	ld	a, e
	and	a, $40
	ld	c, a
	push	hl
	ld	a, c
	call	_UndoRedo
	pop	hl
	jp	.l00108
.l00107:
;src/editor/editor.c:674: else if (key == 'y') UndoRedo(1);
	ld	a, l
	sub	a, $79
	jp	NZ,.l00170
	jp	.l00171
.l00170:
	jp	.l00108
.l00171:
	push	hl
	ld	a, $01
	call	_UndoRedo
	pop	hl
.l00108:
;src/editor/editor.c:675: if (key == 'a') {
	ld	a, l
	sub	a, $61
	jp	NZ,.l00172
	jp	.l00173
.l00172:
	jp	.l00119
.l00173:
;src/editor/editor.c:676: anchor = 0;
	xor	a, a
	ld	hl, _anchor
	ld	[hl], a
	inc	hl
	ld	[hl], a
;src/editor/editor.c:677: cursor = tb_Length();
	call	_tb_Length
	ld	hl, _cursor
	ld	[hl], c
	inc	hl
	ld	[hl], b
;src/editor/editor.c:678: selecting = 1;
	ld	hl, _selecting
	ld	[hl], $01
;src/editor/editor.c:679: moved = 1;
	ld	hl, _moved
	ld	[hl], $01
;src/editor/editor.c:680: redraw = 1;
	ld	hl, _redraw
	ld	[hl], $01
	jp	.l00121
.l00119:
;src/editor/editor.c:682: else if (key == 'c') Copy();
	ld	a, l
	sub	a, $63
	jp	NZ,.l00174
	jp	.l00175
.l00174:
	jp	.l00116
.l00175:
	jp	_Copy
	jp	.l00121
.l00116:
;src/editor/editor.c:683: else if (key == 'x' && Copy()) DeleteSelection();
	ld	a, l
	sub	a, $78
	jp	NZ,.l00176
	jp	.l00177
.l00176:
	jp	.l00112
.l00177:
	push	hl
	call	_Copy
	pop	hl
	or	a, a
	jp	Z, .l00112
	jp	_DeleteSelection
	jp	.l00121
.l00112:
;src/editor/editor.c:684: else if (key == 'v') Paste();
	ld	a, l
	sub	a, $76
	jp	NZ,.l00178
	jp	.l00179
.l00178:
	jp	.l00121
.l00179:
	jp	_Paste
.l00121:
;src/editor/editor.c:685: }
	ret
;src/editor/editor.c:688: static void HandleKey(unsigned char key, unsigned char mods) {
;	---------------------------------
; Function HandleKey
; ---------------------------------
_HandleKey:
	add	sp, -6
	ld	hl, sp+5
	ld	[hl], a
	dec	hl
	ld	[hl], e
;src/editor/editor.c:689: unsigned char ctrl = mods & KB_MOD_CTRL, join = 0;
	ld	a, [hl]
	and	a, $20
	ld	hl, sp+0
	ld	[hl], a
	inc	hl
	ld	[hl], $00
;src/editor/editor.c:690: if (mods & (KB_MOD_ALT | KB_MOD_SUPER)) return;
	ld	hl, sp+4
	ld	a, [hl]
	and	a, $18
	jp	NZ,.l00349
	jp	.l00102
.l00349:
	jp	.l00170
.l00102:
;src/editor/editor.c:691: if (key >= KEY_LEFT && key <= KEY_PAGE_DOWN) undo_merge = 0; // moving starts a new undo step
	ld	hl, sp+5
	ld	a, [hl]
	sub	a, $80
	jp	C, .l00104
	ld	a, $87
	sub	a, [hl]
	jp	C, .l00104
	ld	hl, _undo_merge
	ld	[hl], $00
.l00104:
;src/editor/editor.c:692: if (key < KEY_LEFT || key > KEY_PAGE_DOWN) {
	ld	hl, sp+5
	ld	a, [hl]
	sub	a, $80
	ld	a, $00
	rla
	ld	hl, sp+2
	ld	[hl], a
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00119
	ld	a, $87
	ld	hl, sp+5
	sub	a, [hl]
	jp	NC, .l00120
.l00119:
;src/editor/editor.c:693: if (ctrl) {
	ld	hl, sp+0
	ld	a, [hl]
	or	a, a
	jp	Z, .l00121
;src/editor/editor.c:694: HandleCtrlKey(key, mods);
	ld	hl, sp+4
	ld	e, [hl]
	inc	hl
	ld	a, [hl]
	call	_HandleCtrlKey
;src/editor/editor.c:695: return;
	jp	.l00170
.l00120:
;src/editor/editor.c:698: else if (mods & KB_MOD_SHIFT) { // shift + movement selects
	push	hl
	ld	hl, sp+6
	bit	6, [hl]
	pop	hl
	jp	NZ,.l00350
	jp	.l00117
.l00350:
;src/editor/editor.c:699: if (!selecting) anchor = cursor;
	ld	hl, _selecting
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00109
	ld	hl, _cursor
	ld	a, [hl]
	ld	hl, _anchor
	ld	[hl], a
	ld	hl, _cursor + 1
	ld	a, [hl]
	ld	hl, _anchor + 1
	ld	[hl], a
.l00109:
;src/editor/editor.c:700: selecting = 1;
	ld	hl, _selecting
	ld	[hl], $01
;src/editor/editor.c:701: redraw = 1;
	ld	hl, _redraw
	ld	[hl], $01
	jp	.l00121
.l00117:
;src/editor/editor.c:703: else if (!ctrl && GetSelection() && (key == KEY_LEFT || key == KEY_RIGHT)) { // to that end of the selection
	ld	hl, sp+0
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00111
	call	_GetSelection
	or	a, a
	jp	Z, .l00111
	ld	hl, sp+5
	ld	a, [hl]
	sub	a, $80
	jp	NZ,.l00351
	ld	a,$01
	jp	.l00352
.l00351:
	xor	a,a
.l00352:
	ld	hl, sp+3
	ld	[hl], a
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00110
	inc	hl
	inc	hl
	ld	a, [hl]
	sub	a, $81
	jp	NZ,.l00353
	jp	.l00354
.l00353:
	jp	.l00111
.l00354:
.l00110:
;src/editor/editor.c:704: cursor = key == KEY_LEFT ? sel_start : sel_end;
	ld	hl, sp+3
	ld	a, [hl]
	or	a, a
	jp	Z, .l00172
	ld	hl, _sel_start
	ld	a, [hl]
	ld	hl, sp+2
	ld	[hl], a
	ld	hl, _sel_start + 1
	ld	a, [hl]
	ld	hl, sp+3
	ld	[hl], a
	jp	.l00173
.l00172:
	ld	hl, _sel_end
	ld	a, [hl]
	ld	hl, sp+2
	ld	[hl], a
	ld	hl, _sel_end + 1
	ld	a, [hl]
	ld	hl, sp+3
	ld	[hl], a
.l00173:
	ld	hl, sp+2
	ld	a, [hl]
	ld	hl, _cursor
	ld	[hl], a
	ld	hl, sp+3
	ld	a, [hl]
	ld	hl, _cursor + 1
	ld	[hl], a
;src/editor/editor.c:705: ClearSelection();
	call	_ClearSelection
;src/editor/editor.c:706: moved = 1;
	ld	hl, _moved
	ld	[hl], $01
;src/editor/editor.c:707: return;
	jp	.l00170
.l00111:
;src/editor/editor.c:709: else ClearSelection();
	call	_ClearSelection
.l00121:
;src/editor/editor.c:710: moved = 1;
	ld	hl, _moved
	ld	[hl], $01
;src/editor/editor.c:711: if (ctrl) {
	ld	hl, sp+0
	ld	a, [hl]
	or	a, a
	jp	Z, .l00131
;src/editor/editor.c:712: switch (key) {
	ld	hl, sp+5
	ld	a, [hl]
	sub	a, $80
	jp	NZ,.l00355
	jp	.l00123
.l00355:
	ld	hl, sp+5
	ld	a, [hl]
	sub	a, $81
	jp	NZ,.l00356
	jp	.l00124
.l00356:
	ld	hl, sp+5
	ld	a, [hl]
	sub	a, $82
	jp	NZ,.l00357
	jp	.l00125
.l00357:
	ld	hl, sp+5
	ld	a, [hl]
	sub	a, $83
	jp	NZ,.l00358
	jp	.l00126
.l00358:
	ld	hl, sp+5
	ld	a, [hl]
	sub	a, $84
	jp	NZ,.l00359
	jp	.l00127
.l00359:
	ld	hl, sp+5
	ld	a, [hl]
	sub	a, $85
	jp	NZ,.l00360
	jp	.l00128
.l00360:
	jp	.l00131
;src/editor/editor.c:713: case KEY_LEFT: WordLeft(); return;
.l00123:
	call	_WordLeft
	jp	.l00170
;src/editor/editor.c:714: case KEY_RIGHT: WordRight(); return;
.l00124:
	call	_WordRight
	jp	.l00170
;src/editor/editor.c:715: case KEY_UP: ScrollLine(0); return;
.l00125:
	xor	a, a
	call	_ScrollLine
	jp	.l00170
;src/editor/editor.c:716: case KEY_DOWN: ScrollLine(1); return;
.l00126:
	ld	a, $01
	call	_ScrollLine
	jp	.l00170
;src/editor/editor.c:717: case KEY_HOME: cursor = 0; return;
.l00127:
	xor	a, a
	ld	hl, _cursor
	ld	[hl], a
	inc	hl
	ld	[hl], a
	jp	.l00170
;src/editor/editor.c:718: case KEY_END: cursor = tb_Length(); return;
.l00128:
	call	_tb_Length
	ld	hl, _cursor
	ld	[hl], c
	inc	hl
	ld	[hl], b
	jp	.l00170
;src/editor/editor.c:719: }
.l00131:
;src/editor/editor.c:721: switch (key) {
	ld	hl, sp+2
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00144
	ld	a, $87
	ld	hl, sp+5
	sub	a, [hl]
	jp	C, .l00144
	ld	a, [hl]
	add	a, $80
	ld	c, a
	ld	b, $00
	ld	hl, .l00361
	add	hl, bc
	add	hl, bc
	add	hl, bc
	jp	hl
.l00361:
	jp	.l00136
	jp	.l00139
	jp	.l00132
	jp	.l00133
	jp	.l00142
	jp	.l00143
	jp	.l00134
	jp	.l00135
;src/editor/editor.c:722: case KEY_UP: MoveUp(); return;
.l00132:
	call	_MoveUp
	jp	.l00170
;src/editor/editor.c:723: case KEY_DOWN: MoveDown(); return;
.l00133:
	call	_MoveDown
	jp	.l00170
;src/editor/editor.c:724: case KEY_PAGE_UP: PageUp(); return;
.l00134:
	call	_PageUp
	jp	.l00170
;src/editor/editor.c:725: case KEY_PAGE_DOWN: PageDown(); return;
.l00135:
	call	_PageDown
	jp	.l00170
;src/editor/editor.c:726: case KEY_LEFT: if (cursor) --cursor; return;
.l00136:
	ld	hl, _cursor + 1
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	jp	Z, .l00138
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
.l00138:
	jp	.l00170
;src/editor/editor.c:727: case KEY_RIGHT: if (cursor != tb_Length()) ++cursor; return;
.l00139:
	call	_tb_Length
	ld	hl, _cursor
	ld	a, [hl]
	sub	a, c
	jp	NZ,.l00362
	inc	hl
	ld	a, [hl]
	sub	a, b
	jp	NZ,.l00362
	jp	.l00141
.l00362:
	ld	hl, _cursor
	inc	[hl]
	jp	NZ, .l00363
	inc	hl
	inc	[hl]
.l00363:
.l00141:
	jp	.l00170
;src/editor/editor.c:728: case KEY_HOME: cursor = tb_row_starts[tb_found_row]; return;
.l00142:
	ld	hl, _tb_found_row
	ld	a, [hl]
	ld	hl, sp+2
	ld	[hl], a
	inc	hl
	ld	[hl], $00
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
	ld	de, _tb_row_starts
	pop	hl
	push	hl
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
	ld	hl, _cursor
	ld	[hl], a
	inc	de
	ld	a, [de]
	inc	hl
	ld	[hl], a
	jp	.l00170
;src/editor/editor.c:729: case KEY_END: MoveEnd(); return;
.l00143:
	call	_MoveEnd
	jp	.l00170
;src/editor/editor.c:730: }
.l00144:
;src/editor/editor.c:731: moved = 0;
	ld	hl, _moved
	ld	[hl], $00
;src/editor/editor.c:732: if (key == KEY_ESCAPE || key == KEY_INSERT) return;
	ld	hl, sp+5
	ld	a, [hl]
	sub	a, $1B
	jp	NZ,.l00365
	jp	.l00145
.l00365:
	ld	hl, sp+5
	ld	a, [hl]
	sub	a, $88
	jp	NZ,.l00366
	jp	.l00367
.l00366:
	jp	.l00146
.l00367:
.l00145:
	jp	.l00170
.l00146:
;src/editor/editor.c:733: if (GetSelection()) { // typing replaces the selection
	call	_GetSelection
	or	a, a
	jp	Z, .l00152
;src/editor/editor.c:734: DeleteSelection();
	call	_DeleteSelection
;src/editor/editor.c:735: if (key == KEY_BACKSPACE || key == KEY_DELETE) return;
	ld	hl, sp+5
	ld	a, [hl]
	sub	a, $08
	jp	NZ,.l00368
	jp	.l00148
.l00368:
	ld	hl, sp+5
	ld	a, [hl]
	sub	a, $7F
	jp	NZ,.l00369
	jp	.l00370
.l00369:
	jp	.l00149
.l00370:
.l00148:
	jp	.l00170
.l00149:
;src/editor/editor.c:736: join = 1;
	ld	hl, sp+1
	ld	[hl], $01
.l00152:
;src/editor/editor.c:738: selecting = 0;
	ld	hl, _selecting
	ld	[hl], $00
;src/editor/editor.c:739: switch (key) {
	ld	hl, sp+5
	ld	a, [hl]
	sub	a, $08
	jp	NZ,.l00371
	jp	.l00153
.l00371:
	ld	hl, sp+5
	ld	a, [hl]
	sub	a, $7F
	jp	NZ,.l00372
	jp	.l00156
.l00372:
	jp	.l00159
;src/editor/editor.c:740: case KEY_BACKSPACE:
.l00153:
;src/editor/editor.c:741: if (!cursor) break;
	ld	hl, _cursor + 1
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	jp	Z, .l00170
;src/editor/editor.c:742: --cursor;
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
;src/editor/editor.c:744: case KEY_DELETE:
.l00156:
;src/editor/editor.c:745: if (cursor < tb_Length()) {
	call	_tb_Length
	ld	hl, _cursor
	ld	a, [hl]
	sub	a, c
	inc	hl
	ld	a, [hl]
	sbc	a, b
	jp	NC, .l00170
;src/editor/editor.c:746: UndoDeleting(cursor, 1);
	ld	bc, $0001
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_UndoDeleting
;src/editor/editor.c:747: CountEdit(cursor, tb_Delete(cursor), 0);
	ld	hl, _cursor
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_tb_Delete
	ld	c, a
	xor	a, a
	push	af
	inc	sp
	ld	a, c
	ld	hl, _cursor
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_CountEdit
;src/editor/editor.c:748: Edited(cursor, -1);
	ld	a, $FF
	ld	hl, _cursor
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_Edited
;src/editor/editor.c:750: break;
	jp	.l00170
;src/editor/editor.c:751: default:
.l00159:
;src/editor/editor.c:752: if (key < ' ' && key != ASCII_TAB && key != ASCII_LF) return;
	ld	hl, sp+5
	ld	a, [hl]
	sub	a, $20
	jp	NC, .l00161
	ld	a, [hl]
	sub	a, $09
	jp	NZ,.l00373
	jp	.l00161
.l00373:
	ld	hl, sp+5
	ld	a, [hl]
	sub	a, $0A
	jp	NZ,.l00374
	jp	.l00161
.l00374:
	jp	.l00170
.l00161:
;src/editor/editor.c:753: if (key >= KEY_LEFT && key < 0xA0) return; // unprintable in Latin-1
	ld	hl, sp+5
	ld	a, [hl]
	sub	a, $80
	jp	C, .l00165
	ld	a, [hl]
	sub	a, $A0
	jp	NC, .l00165
	jp	.l00170
.l00165:
;src/editor/editor.c:754: if (tb_Insert(cursor, key)) {
	ld	hl, sp+5
	ld	a, [hl]
	ld	hl, _cursor
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_tb_Insert
	or	a, a
	jp	Z, .l00170
;src/editor/editor.c:755: undo_join = join;
	ld	hl, sp+1
	ld	a, [hl]
	ld	hl, _undo_join
	ld	[hl], a
;src/editor/editor.c:756: UndoInserted(cursor, 1);
	ld	bc, $0001
	ld	hl, _cursor
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_UndoInserted
;src/editor/editor.c:757: CountEdit(cursor, key, 1);
	ld	a, $01
	push	af
	inc	sp
	ld	hl, sp+6
	ld	a, [hl]
	ld	hl, _cursor
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_CountEdit
;src/editor/editor.c:758: Edited(cursor++, 1);
	ld	hl, _cursor
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	dec	hl
	inc	[hl]
	jp	NZ, .l00375
	inc	hl
	inc	[hl]
.l00375:
	ld	a, $01
	call	_Edited
;src/editor/editor.c:760: }
.l00170:
;src/editor/editor.c:761: }
	add	sp, 6
	ret
;src/editor/editor.c:764: static unsigned char DpadRepeat(unsigned char pressed) {
;	---------------------------------
; Function DpadRepeat
; ---------------------------------
_DpadRepeat:
	ld	c, a
;src/editor/editor.c:765: unsigned char held = (button_state | pressed) & PADF_DPAD;
	ld	hl, _button_state
	ld	a, [hl]
	or	a, c
	and	a, $F0
	ld	b, a
;src/editor/editor.c:766: if (!held) return 0;
	or	a, a
	jp	NZ, .l00102
	xor	a, a
	jp	.l00109
.l00102:
;src/editor/editor.c:767: if (pressed & PADF_DPAD) pad_timer = PAD_REPEAT_DELAY;
	ld	a, c
	and	a, $F0
	jp	NZ,.l00126
	jp	.l00107
.l00126:
	ld	hl, _pad_timer
	ld	[hl], $14
	jp	.l00108
.l00107:
;src/editor/editor.c:768: else if (--pad_timer) return 0;
	ld	hl, _pad_timer
	dec	[hl]
	ld	a, [hl]
	or	a, a
	jp	Z, .l00104
	xor	a, a
	jp	.l00109
.l00104:
;src/editor/editor.c:769: else pad_timer = PAD_REPEAT_RATE;
	ld	hl, _pad_timer
	ld	[hl], $04
.l00108:
;src/editor/editor.c:770: return held;
	ld	a, b
.l00109:
;src/editor/editor.c:771: }
	ret
;src/editor/editor.c:774: static void SetRows(void) {
;	---------------------------------
; Function SetRows
; ---------------------------------
_SetRows:
;src/editor/editor.c:775: bars = bars_on;
	ld	hl, _bars_on
	ld	a, [hl]
	ld	hl, _bars
	ld	[hl], a
;src/editor/editor.c:776: tb_rows = TextRows();
	call	_TextRows
	ld	hl, _tb_rows
	ld	[hl], a
;src/editor/editor.c:777: Layout();
	call	_Layout
;src/editor/editor.c:778: if (osk_shown) {
	ld	hl, _osk_shown
	ld	a, [hl]
	or	a, a
	jp	Z, .l00102
;src/editor/editor.c:779: OSKDraw(osk_layer, tb_rows);
	ld	hl, _tb_rows
	ld	e, [hl]
	ld	hl, _osk_layer
	ld	a, [hl]
	call	_OSKDraw
;src/editor/editor.c:780: OSKSelect(osk_x, osk_y);
	ld	hl, _osk_y
	ld	e, [hl]
	ld	hl, _osk_x
	ld	a, [hl]
	call	_OSKSelect
.l00102:
;src/editor/editor.c:782: OSKShow(osk_shown);
	ld	hl, _osk_shown
	ld	a, [hl]
	call	_OSKShow
;src/editor/editor.c:783: dirty = 1;
	ld	hl, _dirty
	ld	[hl], $01
.l00103:
;src/editor/editor.c:784: }
	ret
;src/editor/editor.c:786: static void ToggleOSK(void) {
;	---------------------------------
; Function ToggleOSK
; ---------------------------------
_ToggleOSK:
;src/editor/editor.c:787: osk_shown = !osk_shown;
	ld	hl, _osk_shown
	ld	a, [hl]
	sub	a,$01
	ld	a, $00
	rla
	ld	[hl], a
;src/editor/editor.c:788: SetRows();
	jp	_SetRows
.l00101:
;src/editor/editor.c:789: }
	ret
;src/editor/editor.c:792: static void ToggleBars(void) {
;	---------------------------------
; Function ToggleBars
; ---------------------------------
_ToggleBars:
;src/editor/editor.c:793: bars_on = !bars_on;
	ld	hl, _bars_on
	ld	a, [hl]
	sub	a,$01
	ld	a, $00
	rla
	ld	[hl], a
;src/editor/editor.c:794: SetRows();
	call	_SetRows
;src/editor/editor.c:795: SettingsSave();
	jp	_SettingsSave
.l00101:
;src/editor/editor.c:796: }
	ret
;src/editor/editor.c:798: static void SetOSKLayer(unsigned char layer) {
;	---------------------------------
; Function SetOSKLayer
; ---------------------------------
_SetOSKLayer:
	ld	c, a
;src/editor/editor.c:799: osk_layer = osk_layer == layer ? OSK_LOWER : layer;
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
;src/editor/editor.c:800: OSKDraw(osk_layer, tb_rows);
	ld	hl, _tb_rows
	ld	e, [hl]
	ld	hl, _osk_layer
	ld	a, [hl]
	call	_OSKDraw
;src/editor/editor.c:801: dirty = 1;
	ld	hl, _dirty
	ld	[hl], $01
.l00101:
;src/editor/editor.c:802: }
	ret
;src/editor/editor.c:804: static unsigned char PressOSKKey(void) {
;	---------------------------------
; Function PressOSKKey
; ---------------------------------
_PressOSKKey:
;src/editor/editor.c:806: if (osk_y == OSK_ROWS - 1) {
	ld	hl, _osk_y
	ld	a, [hl]
	sub	a, $04
	jp	NZ,.l00157
	jp	.l00158
.l00157:
	jp	.l00117
.l00158:
;src/editor/editor.c:807: if (osk_x == 0) SetOSKLayer(OSK_SHIFT);
	ld	hl, _osk_x
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00114
	ld	a, $01
	call	_SetOSKLayer
	jp	.l00115
.l00114:
;src/editor/editor.c:808: else if (osk_x == 1) SetOSKLayer(OSK_SYMBOLS);
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
;src/editor/editor.c:809: else if (osk_x == OSK_COLS - 3) return KEY_MENU;
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
;src/editor/editor.c:810: else if (osk_x == OSK_COLS - 2) return KEY_LEFT;
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
;src/editor/editor.c:811: else if (osk_x == OSK_COLS - 1) return KEY_RIGHT;
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
;src/editor/editor.c:812: else return ' ';
	ld	a, $20
	jp	.l00120
.l00115:
;src/editor/editor.c:813: return KEY_NONE;
	xor	a, a
	jp	.l00120
.l00117:
;src/editor/editor.c:815: key = OSKGetKey(osk_layer, (osk_y << 3) + (osk_y << 1) + osk_x);
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
;src/editor/editor.c:816: if (osk_layer == OSK_SHIFT) SetOSKLayer(OSK_SHIFT); // shift is one shot
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
;src/editor/editor.c:817: return key;
	ld	a, c
.l00120:
;src/editor/editor.c:818: }
	ret
;src/editor/editor.c:820: static void MoveOSKSelection(unsigned char held) {
;	---------------------------------
; Function MoveOSKSelection
; ---------------------------------
_MoveOSKSelection:
	ld	c, a
;src/editor/editor.c:821: if (held & PADF_UP) osk_y = osk_y ? osk_y - 1 : OSK_ROWS - 1;
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
;src/editor/editor.c:822: else if (held & PADF_DOWN) osk_y = osk_y == OSK_ROWS - 1 ? 0 : osk_y + 1;
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
;src/editor/editor.c:823: if (held & PADF_LEFT) osk_x = osk_x ? osk_x - 1 : OSK_COLS - 1;
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
;src/editor/editor.c:824: else if (held & PADF_RIGHT) osk_x = osk_x == OSK_COLS - 1 ? 0 : osk_x + 1;
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
;src/editor/editor.c:825: OSKSelect(osk_x, osk_y);
	ld	hl, _osk_y
	ld	e, [hl]
	ld	hl, _osk_x
	ld	a, [hl]
	jp	_OSKSelect
.l00111:
;src/editor/editor.c:826: }
	ret
;src/editor/editor.c:830: static unsigned char PadKey(void) {
;	---------------------------------
; Function PadKey
; ---------------------------------
_PadKey:
;src/editor/editor.c:831: unsigned char pressed = PadPressed();
	call	_PadPressed
	ld	c, a
;src/editor/editor.c:833: if (pressed & PADF_SELECT) ToggleOSK();
	bit	2, c
	jp	NZ,.l00172
	jp	.l00102
.l00172:
	push	bc
	call	_ToggleOSK
	pop	bc
.l00102:
;src/editor/editor.c:834: if (pressed & PADF_B) return KEY_BACKSPACE;
	bit	1, c
	jp	NZ,.l00173
	jp	.l00104
.l00173:
	ld	a, $08
	jp	.l00120
.l00104:
;src/editor/editor.c:835: if (pressed & PADF_START) return KEY_ENTER;
	bit	3, c
	jp	NZ,.l00174
	jp	.l00106
.l00174:
	ld	a, $0A
	jp	.l00120
.l00106:
;src/editor/editor.c:836: if (osk_shown && (pressed & PADF_A)) return PressOSKKey();
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
;src/editor/editor.c:837: held = DpadRepeat(pressed);
	ld	a, c
	call	_DpadRepeat
	ld	c, a
;src/editor/editor.c:838: if (!held) return KEY_NONE;
	ld	a, c
	or	a, a
	jp	NZ, .l00111
	xor	a, a
	jp	.l00120
.l00111:
;src/editor/editor.c:839: if (osk_shown) {
	ld	hl, _osk_shown
	ld	a, [hl]
	or	a, a
	jp	Z, .l00113
;src/editor/editor.c:840: MoveOSKSelection(held);
	ld	a, c
	call	_MoveOSKSelection
;src/editor/editor.c:841: return KEY_NONE;
	xor	a, a
	jp	.l00120
.l00113:
;src/editor/editor.c:843: if (held & PADF_UP) return KEY_UP;
	bit	6, c
	jp	NZ,.l00176
	jp	.l00115
.l00176:
	ld	a, $82
	jp	.l00120
.l00115:
;src/editor/editor.c:844: if (held & PADF_DOWN) return KEY_DOWN;
	bit	7, c
	jp	NZ,.l00177
	jp	.l00117
.l00177:
	ld	a, $83
	jp	.l00120
.l00117:
;src/editor/editor.c:845: if (held & PADF_LEFT) return KEY_LEFT;
	bit	5, c
	jp	NZ,.l00178
	jp	.l00119
.l00178:
	ld	a, $80
	jp	.l00120
.l00119:
;src/editor/editor.c:846: return KEY_RIGHT;
	ld	a, $81
.l00120:
;src/editor/editor.c:847: }
	ret
;src/editor/editor.c:850: static unsigned char MenuKey(void) {
;	---------------------------------
; Function MenuKey
; ---------------------------------
_MenuKey:
;src/editor/editor.c:852: WaitFrame();
	call	_WaitFrame
;src/editor/editor.c:853: if ((key = (unsigned char)KBPopEvent())) return key;
	call	_KBPopEvent
	ld	a, c
	ld	c, a
	or	a, a
	jp	Z, .l00102
	ld	a, c
	jp	.l00115
.l00102:
;src/editor/editor.c:854: pressed = PadPressed();
	call	_PadPressed
	ld	c, a
;src/editor/editor.c:855: if (pressed & (PADF_A | PADF_START)) return KEY_ENTER;
	ld	a, c
	and	a, $09
	jp	NZ,.l00152
	jp	.l00104
.l00152:
	ld	a, $0A
	jp	.l00115
.l00104:
;src/editor/editor.c:856: if (pressed & PADF_B) return KEY_BACKSPACE;
	bit	1, c
	jp	NZ,.l00153
	jp	.l00106
.l00153:
	ld	a, $08
	jp	.l00115
.l00106:
;src/editor/editor.c:857: held = DpadRepeat(pressed);
	ld	a, c
	call	_DpadRepeat
;src/editor/editor.c:858: if (held & PADF_UP) return KEY_UP;
	bit	6, a
	jp	NZ,.l00154
	jp	.l00108
.l00154:
	ld	a, $82
	jp	.l00115
.l00108:
;src/editor/editor.c:859: if (held & PADF_DOWN) return KEY_DOWN;
	bit	7, a
	jp	NZ,.l00155
	jp	.l00110
.l00155:
	ld	a, $83
	jp	.l00115
.l00110:
;src/editor/editor.c:860: if (held & PADF_LEFT) return KEY_LEFT;
	bit	5, a
	jp	NZ,.l00156
	jp	.l00112
.l00156:
	ld	a, $80
	jp	.l00115
.l00112:
;src/editor/editor.c:861: if (held & PADF_RIGHT) return KEY_RIGHT;
	bit	4, a
	jp	NZ,.l00157
	jp	.l00114
.l00157:
	ld	a, $81
	jp	.l00115
.l00114:
;src/editor/editor.c:862: return KEY_NONE;
	xor	a, a
.l00115:
;src/editor/editor.c:863: }
	ret
;src/editor/editor.c:865: static char* RowAddress(unsigned char row) {
;	---------------------------------
; Function RowAddress
; ---------------------------------
_RowAddress:
	ld	e, a
;src/editor/editor.c:866: unsigned int offset = row;
	ld	d, $00
;src/editor/editor.c:867: return (char*)tile_buffer + (offset << 5) + (offset << 3); // row * TB_STRIDE
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
;src/editor/editor.c:868: }
	ret
;src/editor/editor.c:871: static void DrawRow(unsigned char row, unsigned char col, const char* text) {
;	---------------------------------
; Function DrawRow
; ---------------------------------
_DrawRow:
	dec	sp
	dec	sp
	ld	c, a
	ld	hl, sp+1
	ld	[hl], e
;src/editor/editor.c:872: char* dest = RowAddress(row);
	ld	a, c
	call	_RowAddress
;src/editor/editor.c:874: for (i = 0; i < TB_STRIDE; ++i) dest[i] = ' ';
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
;src/editor/editor.c:875: for (dest += col; *text && col < TB_STRIDE; ++col) *dest++ = *text++;
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
;src/editor/editor.c:876: }
	inc	sp
	inc	sp
	pop	hl
	inc	sp
	inc	sp
	jp hl 
;src/editor/editor.c:878: static void ClearScreen(void) {
;	---------------------------------
; Function ClearScreen
; ---------------------------------
_ClearScreen:
;src/editor/editor.c:880: for (row = 0; row < TB_ROWS; ++row) DrawRow(row, 0, "");
	ld	c, $00
.l00102:
	push	bc
	ld	de, ___str_37
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
;src/editor/editor.c:881: }
	ret
___str_37:
	DB $00
;src/editor/editor.c:884: static void BeginFullScreen(void) {
;	---------------------------------
; Function BeginFullScreen
; ---------------------------------
_BeginFullScreen:
;src/editor/editor.c:885: EditorShowCursor(0);
	xor	a, a
	call	_EditorShowCursor
;src/editor/editor.c:886: if (osk_shown) OSKShow(0);
	ld	hl, _osk_shown
	ld	a, [hl]
	or	a, a
	jp	Z, .l00102
	xor	a, a
	call	_OSKShow
.l00102:
;src/editor/editor.c:887: bars = 0;
	ld	hl, _bars
	ld	[hl], $00
;src/editor/editor.c:888: tb_rows = TB_ROWS;
	ld	hl, _tb_rows
	ld	[hl], $12
;src/editor/editor.c:889: Layout();
	call	_Layout
;src/editor/editor.c:890: NoHighlight();
	call	_NoHighlight
;src/editor/editor.c:891: dirty = 1;
	ld	hl, _dirty
	ld	[hl], $01
.l00103:
;src/editor/editor.c:892: }
	ret
;src/editor/editor.c:894: static void EndFullScreen(void) {
;	---------------------------------
; Function EndFullScreen
; ---------------------------------
_EndFullScreen:
;src/editor/editor.c:895: SetRows();
	jp	_SetRows
.l00101:
;src/editor/editor.c:896: }
	ret
;src/editor/editor.c:899: static void OpenBox(unsigned char lines) {
;	---------------------------------
; Function OpenBox
; ---------------------------------
_OpenBox:
	ld	e, a
;src/editor/editor.c:900: char* line = RowAddress(BOX_LINE);
	push	de
	ld	a, $14
	call	_RowAddress
	pop	de
;src/editor/editor.c:901: unsigned char i, width, widest = 0;
	ld	d, $00
;src/editor/editor.c:902: for (i = 0; i < lines; ++i, line += BOX_STRIDE) {
	ld	l, $00
;	spillPairReg hl
;	spillPairReg hl
.l00105:
	ld	a, l
	sub	a, e
	jp	NC, .l00103
;src/editor/editor.c:903: width = RenderTextWidth(line);
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
;src/editor/editor.c:904: if (width > widest) widest = width;
	ld	a, d
	sub	a, h
	jp	NC, .l00106
	ld	d, h
.l00106:
;src/editor/editor.c:902: for (i = 0; i < lines; ++i, line += BOX_STRIDE) {
	inc	l
	ld	a, c
	add	a, $14
	ld	c, a
	jp	NC, .l00125
	inc	b
.l00125:
	jp	.l00105
.l00103:
;src/editor/editor.c:906: render_box_text = RowAddress(BOX_LINE);
	push	de
	ld	a, $14
	call	_RowAddress
	pop	de
	ld	hl, _render_box_text
	ld	[hl], c
	inc	hl
	ld	[hl], b
;src/editor/editor.c:907: render_box_w = widest + BOX_PADDING;
	ld	a, d
	add	a, $09
	ld	hl, _render_box_w
	ld	[hl], a
;src/editor/editor.c:908: render_box_x = (TB_WIDTH - render_box_w) >> 1;
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
;src/editor/editor.c:909: render_box_rows = lines + 2; // half rows above and below
	ld	a, e
	add	a, $02
	ld	hl, _render_box_rows
	ld	[hl], a
;src/editor/editor.c:910: render_box_top = (TB_ROWS - render_box_rows) >> 1;
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
;src/editor/editor.c:911: render_box_sel = 0xFF;
	ld	hl, _render_box_sel
	ld	[hl], $FF
;src/editor/editor.c:912: ++render_box_gen;
	ld	hl, _render_box_gen
	inc	[hl]
.l00107:
;src/editor/editor.c:913: }
	ret
;src/editor/editor.c:916: static void ShowBusy(const char* text) {
;	---------------------------------
; Function ShowBusy
; ---------------------------------
_ShowBusy:
	ld	c, e
	ld	b, d
;src/editor/editor.c:917: CopyName(RowAddress(BOX_LINE), text);
	push	bc
	ld	a, $14
	call	_RowAddress
	ld	e, c
	ld	d, b
	pop	bc
	call	_CopyName
;src/editor/editor.c:918: OpenBox(1);
	ld	a, $01
	call	_OpenBox
;src/editor/editor.c:919: EditorDraw();
	jp	_EditorDraw
.l00101:
;src/editor/editor.c:920: }
	ret
;src/editor/editor.c:922: static void HideBox(void) {
;	---------------------------------
; Function HideBox
; ---------------------------------
_HideBox:
;src/editor/editor.c:923: render_box_top = 0xFF;
	ld	hl, _render_box_top
	ld	[hl], $FF
.l00101:
;src/editor/editor.c:924: }
	ret
;src/editor/editor.c:927: static unsigned char Choose(const char* title, const char* items, unsigned char count) {
;	---------------------------------
; Function Choose
; ---------------------------------
_Choose:
	add	sp, -6
	ld	hl, sp+1
	ld	[hl], e
	inc	hl
	ld	[hl], d
;src/editor/editor.c:928: char* line = RowAddress(BOX_LINE);
	push	bc
	ld	a, $14
	call	_RowAddress
	ld	e, c
	ld	d, b
	pop	bc
;src/editor/editor.c:929: unsigned char i, key, selected = 0;
	ld	hl, sp+0
	ld	[hl], $00
;src/editor/editor.c:930: for (i = 0; i <= count; ++i, line += BOX_STRIDE) {
	ld	hl, sp+3
	ld	[hl], c
	inc	hl
	ld	[hl], b
	inc	hl
	ld	[hl], $00
.l00127:
;src/editor/editor.c:931: if (i) {
	ld	hl, sp+5
	ld	a, [hl]
	or	a, a
	jp	Z, .l00102
;src/editor/editor.c:932: line[0] = ' ';
	ld	a, $20
	ld	[de], a
;src/editor/editor.c:933: CopyName(line + 1, items);
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
;src/editor/editor.c:934: items += ITEM_SIZE;
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
	jp	.l00128
.l00102:
;src/editor/editor.c:936: else CopyName(line, title);
	push	de
	ld	hl, sp+3
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	call	_CopyName
	pop	de
.l00128:
;src/editor/editor.c:930: for (i = 0; i <= count; ++i, line += BOX_STRIDE) {
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
	jp	NC, .l00127
;src/editor/editor.c:938: EditorShowCursor(0);
	xor	a, a
	call	_EditorShowCursor
;src/editor/editor.c:939: if (osk_shown) OSKShow(0);
	ld	hl, _osk_shown
	ld	a, [hl]
	or	a, a
	jp	Z, .l00106
	xor	a, a
	call	_OSKShow
.l00106:
;src/editor/editor.c:940: NoHighlight();
	call	_NoHighlight
;src/editor/editor.c:941: OpenBox(count + 1);
	ld	hl, sp+8
	ld	d, [hl]
	ld	c, d
	inc	c
	push	de
	ld	a, c
	call	_OpenBox
	pop	de
;src/editor/editor.c:942: while (1) {
	dec	d
.l00123:
;src/editor/editor.c:943: render_box_sel = selected + 2;
	ld	hl, sp+0
	ld	e, [hl]
	ld	a, e
	add	a, $02
	ld	hl, _render_box_sel
	ld	[hl], a
;src/editor/editor.c:944: EditorDraw();
	push	de
	call	_EditorDraw
	pop	de
;src/editor/editor.c:945: while (!(key = MenuKey()));
.l00107:
	push	de
	call	_MenuKey
	pop	de
	ld	hl, sp+5
	ld	[hl], a
	or	a, a
	jp	Z, .l00107
;src/editor/editor.c:946: if (key == KEY_UP) selected = selected ? selected - 1 : count - 1;
	ld	a, [hl]
	sub	a, $82
	jp	NZ,.l00206
	jp	.l00207
.l00206:
	jp	.l00120
.l00207:
	ld	hl, sp+0
	ld	a, [hl]
	or	a, a
	jp	Z, .l00131
	dec	e
	jp	.l00132
.l00131:
	ld	e, d
.l00132:
	ld	hl, sp+0
	ld	[hl], e
	jp	.l00123
.l00120:
;src/editor/editor.c:947: else if (key == KEY_DOWN) selected = selected == count - 1 ? 0 : selected + 1;
	ld	hl, sp+5
	ld	a, [hl]
	sub	a, $83
	jp	NZ,.l00208
	jp	.l00209
.l00208:
	jp	.l00117
.l00209:
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
	jp	NZ,.l00210
	inc	hl
	ld	a, [hl]
	sub	a, b
	jp	NZ,.l00210
	jp	.l00211
.l00210:
	jp	.l00133
.l00211:
	ld	bc, $0000
	jp	.l00134
.l00133:
	inc	e
	ld	a, e
	ld	c, a
	rlca
	sbc	a, a
	ld	b, a
.l00134:
	ld	hl, sp+0
	ld	[hl], c
	jp	.l00123
.l00117:
;src/editor/editor.c:948: else if (key == KEY_ENTER) break;
	ld	hl, sp+5
	ld	a, [hl]
	sub	a, $0A
	jp	NZ,.l00212
	jp	.l00124
.l00212:
;src/editor/editor.c:949: else if (key == KEY_ESCAPE || key == KEY_BACKSPACE) {
	ld	hl, sp+5
	ld	a, [hl]
	sub	a, $1B
	jp	NZ,.l00213
	jp	.l00110
.l00213:
	ld	hl, sp+5
	ld	a, [hl]
	sub	a, $08
	jp	NZ,.l00214
	jp	.l00215
.l00214:
	jp	.l00123
.l00215:
.l00110:
;src/editor/editor.c:950: selected = CANCEL;
	ld	hl, sp+0
	ld	[hl], $FF
;src/editor/editor.c:951: break;
.l00124:
;src/editor/editor.c:954: HideBox();
	call	_HideBox
;src/editor/editor.c:955: if (osk_shown) OSKShow(1);
	ld	hl, _osk_shown
	ld	a, [hl]
	or	a, a
	jp	Z, .l00126
	ld	a, $01
	call	_OSKShow
.l00126:
;src/editor/editor.c:956: dirty = 1;
	ld	hl, _dirty
	ld	[hl], $01
;src/editor/editor.c:957: return selected;
	ld	hl, sp+0
	ld	a, [hl]
.l00129:
;src/editor/editor.c:958: }
	add	sp, 6
	pop	hl
	inc	sp
	jp hl 
;src/editor/editor.c:961: static void ShowMessage(const char* text) {
;	---------------------------------
; Function ShowMessage
; ---------------------------------
_ShowMessage:
;src/editor/editor.c:962: HideBox();
	push	de
	call	_HideBox
	pop	de
;src/editor/editor.c:963: Render();
	push	de
	call	_Render
	pop	de
;src/editor/editor.c:964: EditorShowCursor(0);
	push	de
	xor	a, a
	call	_EditorShowCursor
	pop	de
;src/editor/editor.c:965: NoHighlight();
	push	de
	call	_NoHighlight
	pop	de
;src/editor/editor.c:966: if (bars) {
	ld	hl, _bars
	ld	a, [hl]
	or	a, a
	jp	Z, .l00102
;src/editor/editor.c:967: UpdateBars();
	push	de
	call	_UpdateBars
	pop	de
;src/editor/editor.c:968: DrawRow(STATUS_LINE, 1, text);
	push	de
	ld	e, $01
	ld	a, $13
	call	_DrawRow
	jp	.l00103
.l00102:
;src/editor/editor.c:970: else DrawRow(tb_rows - 1, 0, text);
	ld	hl, _tb_rows
	ld	c, [hl]
	dec	c
	push	de
	ld	e, $00
	ld	a, c
	call	_DrawRow
.l00103:
;src/editor/editor.c:971: EditorDraw();
	call	_EditorDraw
;src/editor/editor.c:972: while (!MenuKey());
.l00104:
	call	_MenuKey
	or	a, a
	jp	Z, .l00104
;src/editor/editor.c:973: dirty = 1;
	ld	hl, _dirty
	ld	[hl], $01
.l00107:
;src/editor/editor.c:974: }
	ret
;src/editor/editor.c:976: static void ShowError(unsigned char result, const char* denied) {
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
;src/editor/editor.c:977: char text[12] = "SD ERROR ";
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
;src/editor/editor.c:978: if (result == FR_NOT_READY) ShowMessage("NO SD CARD");
	ld	hl, sp+16
	ld	a, [hl]
	sub	a, $03
	jp	NZ,.l00140
	jp	.l00141
.l00140:
	jp	.l00111
.l00141:
	ld	de, ___str_39
	call	_ShowMessage
	jp	.l00113
.l00111:
;src/editor/editor.c:979: else if (result == FR_NO_FILESYSTEM) ShowMessage("NO FAT VOLUME");
	ld	hl, sp+16
	ld	a, [hl]
	sub	a, $0D
	jp	NZ,.l00142
	jp	.l00143
.l00142:
	jp	.l00108
.l00143:
	ld	de, ___str_40
	call	_ShowMessage
	jp	.l00113
.l00108:
;src/editor/editor.c:980: else if (result == FR_DENIED) ShowMessage(denied);
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
;src/editor/editor.c:982: text[9] = '0';
	ld	hl, sp+9
	ld	[hl], $30
;src/editor/editor.c:983: while (result >= 10) {
.l00101:
;src/editor/editor.c:985: result -= 10;
	ld	hl, sp+16
	ld	a, [hl]
	ld	hl, sp+12
	ld	[hl], a
;src/editor/editor.c:983: while (result >= 10) {
	ld	hl, sp+16
	ld	a, [hl]
	sub	a, $0A
	jp	C, .l00103
;src/editor/editor.c:984: ++text[9];
	ld	hl, sp+9
	ld	a, [hl]
	ld	hl, sp+13
	ld	[hl], a
	ld	a, [hl]
	inc	a
	ld	hl, sp+9
	ld	[hl], a
;src/editor/editor.c:985: result -= 10;
	ld	hl, sp+12
	ld	a, [hl]
	add	a, $F6
	ld	hl, sp+16
	ld	[hl], a
	jp	.l00101
.l00103:
;src/editor/editor.c:987: text[10] = '0' + result;
	ld	hl, sp+12
	ld	a, [hl]
	add	a, $30
	dec	hl
	dec	hl
	ld	[hl], a
;src/editor/editor.c:988: text[11] = 0;
	inc	hl
	ld	[hl], $00
;src/editor/editor.c:989: ShowMessage(text);
	ld	hl, 0
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_ShowMessage
.l00113:
;src/editor/editor.c:991: }
	add	sp, 17
	ret
___str_39:
	DB "NO SD CARD"
	DB $00
___str_40:
	DB "NO FAT VOLUME"
	DB $00
;src/editor/editor.c:993: static void CopyName(char* dest, const char* src) {
;	---------------------------------
; Function CopyName
; ---------------------------------
_CopyName:
;src/editor/editor.c:994: while ((*dest++ = *src++));
.l00101:
	ld	a, [bc]
	inc	bc
	ld	[de], a
	inc	de
	or	a, a
	jp	NZ, .l00101
.l00104:
;src/editor/editor.c:995: }
	ret
;src/editor/editor.c:998: static unsigned char CanDiscard(void) {
;	---------------------------------
; Function CanDiscard
; ---------------------------------
_CanDiscard:
;src/editor/editor.c:999: return !modified || Choose("DISCARD CHANGES?", discard_items[0], 2) == 1;
	ld	hl, _modified
	ld	a, [hl]
	or	a, a
	jp	Z, .l00104
	ld	a, $02
	push	af
	inc	sp
	ld	bc, _discard_items
	ld	de, ___str_41
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
;src/editor/editor.c:1000: }
	ret
___str_41:
	DB "DISCARD CHANGES?"
	DB $00
;src/editor/editor.c:1007: static void SetLang(void) {
;	---------------------------------
; Function SetLang
; ---------------------------------
_SetLang:
	add	sp, -10
;src/editor/editor.c:1008: const char *c, *dot = 0, *e;
	ld	bc, $0000
;src/editor/editor.c:1009: unsigned char lang = LANG_PLAIN, i;
	ld	hl, sp+0
	ld	[hl], $00
;src/editor/editor.c:1010: for (c = file_name; *c; ++c) if (*c == '.') dot = c;
	ld	de, _file_name+0
.l00115:
	ld	a, [de]
	or	a, a
	jp	Z, .l00103
	sub	a, $2E
	jp	NZ,.l00196
	jp	.l00197
.l00196:
	jp	.l00116
.l00197:
	ld	c, e
	ld	b, d
.l00116:
	inc	de
	jp	.l00115
.l00103:
;src/editor/editor.c:1011: if (dot) for (i = 0; i < sizeof(lang_ids); ++i) {
	ld	a, b
	or	a, c
	jp	Z, .l00110
	inc	bc
	ld	hl, sp+1
	ld	[hl], c
	inc	hl
	ld	[hl], b
	ld	hl, sp+5
	ld	[hl], $00
.l00121:
;src/editor/editor.c:1012: for (c = dot + 1, e = lang_exts[i]; *e && (*c | 0x20) == *e; ++c, ++e);
	ld	hl, sp+1
	ld	a, [hl]
	ld	hl, sp+6
	ld	[hl], a
	ld	hl, sp+2
	ld	a, [hl]
	ld	hl, sp+7
	ld	[hl], a
	dec	hl
	dec	hl
	ld	a, [hl]
	ld	hl, sp+8
	ld	[hl], a
	inc	hl
	ld	[hl], $00
	dec	hl
	ld	a, [hl]
	ld	hl, sp+3
	ld	[hl], a
	ld	hl, sp+9
	ld	a, [hl]
	ld	hl, sp+4
	ld	[hl], a
	dec	hl
	sla	[hl]
	inc	hl
	rl	[hl]
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, _lang_exts
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
	dec	hl
	ld	[hl], a
	inc	de
	ld	a, [de]
	inc	hl
	ld	[hl], a
.l00119:
	ld	hl, sp+9
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	ld	hl, sp+3
	ld	[hl], a
	ld	hl, sp+7
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	ld	hl, sp+4
	ld	[hl], a
	dec	hl
	ld	a, [hl]
	or	a, a
	jp	Z, .l00104
	inc	hl
	ld	b, [hl]
	set	5, b
	dec	hl
	ld	a, [hl]
	sub	a, b
	jp	NZ,.l00199
	jp	.l00200
.l00199:
	jp	.l00104
.l00200:
	ld	hl, sp+6
	inc	[hl]
	jp	NZ, .l00201
	inc	hl
	inc	[hl]
.l00201:
	ld	hl, sp+8
	inc	[hl]
	jp	NZ, .l00202
	inc	hl
	inc	[hl]
.l00202:
	jp	.l00119
.l00104:
;src/editor/editor.c:1013: if (!*c && !*e) lang = lang_ids[i];
	ld	hl, sp+4
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00122
	dec	hl
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00122
	ld	de, _lang_ids
	inc	hl
	inc	hl
	ld	l, [hl]
	ld	h, $00
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
.l00122:
;src/editor/editor.c:1011: if (dot) for (i = 0; i < sizeof(lang_ids); ++i) {
	ld	hl, sp+5
	inc	[hl]
	ld	a, [hl]
	sub	a, $06
	jp	C, .l00121
.l00110:
;src/editor/editor.c:1015: if (lang == tb_lang) return;
	ld	hl, _tb_lang
	ld	a, [hl]
	ld	hl, sp+0
	sub	a, [hl]
	jp	NZ,.l00203
	jp	.l00204
.l00203:
	jp	.l00112
.l00204:
	jp	.l00125
.l00112:
;src/editor/editor.c:1016: tb_lang = lang;
	ld	hl, sp+0
	ld	a, [hl]
	ld	hl, _tb_lang
	ld	[hl], a
;src/editor/editor.c:1017: for (i = 0; i <= TB_ROWS; ++i) tb_row_states[i] = 0; // no markdown headings left in them
	ld	bc, _tb_row_states+0
	ld	e, $00
.l00123:
	ld	l, e
;	spillPairReg hl
;	spillPairReg hl
	ld	h, $00
;	spillPairReg hl
;	spillPairReg hl
	add	hl, hl
	add	hl, bc
	xor	a, a
	ld	[hl], a
	inc	hl
	ld	[hl], a
	inc	e
	ld	a, $12
	sub	a, e
	jp	NC, .l00123
;src/editor/editor.c:1018: EditorRedraw();
	call	_EditorRedraw
;src/editor/editor.c:1019: dirty = 1;
	ld	hl, _dirty
	ld	[hl], $01
.l00125:
;src/editor/editor.c:1020: }
	add	sp, 10
	ret
_lang_exts:
	DW __str_42
	DW __str_43
	DW __str_44
	DW __str_45
	DW __str_46
	DW __str_47
_lang_ids:
	DB $01	; 1
	DB $02	; 2
	DB $02	; 2
	DB $03	; 3
	DB $03	; 3
	DB $03	; 3
__str_42:
	DB "md"
	DB $00
__str_43:
	DB "c"
	DB $00
__str_44:
	DB "h"
	DB $00
__str_45:
	DB "asm"
	DB $00
__str_46:
	DB "inc"
	DB $00
__str_47:
	DB "s"
	DB $00
;src/editor/editor.c:1022: static void ResetCursor(void) {
;	---------------------------------
; Function ResetCursor
; ---------------------------------
_ResetCursor:
;src/editor/editor.c:1023: SetLang();
	call	_SetLang
;src/editor/editor.c:1024: cursor = 0;
	xor	a, a
	ld	hl, _cursor
	ld	[hl], a
	inc	hl
	ld	[hl], a
;src/editor/editor.c:1025: counted_pos = 0;
	xor	a, a
	ld	hl, _counted_pos
	ld	[hl], a
	inc	hl
	ld	[hl], a
;src/editor/editor.c:1026: counted_lines = 0;
	xor	a, a
	ld	hl, _counted_lines
	ld	[hl], a
	inc	hl
	ld	[hl], a
;src/editor/editor.c:1027: selecting = 0;
	ld	hl, _selecting
	ld	[hl], $00
;src/editor/editor.c:1028: top = 0;
	xor	a, a
	ld	hl, _top
	ld	[hl], a
	inc	hl
	ld	[hl], a
;src/editor/editor.c:1029: tb_left = 0;
	xor	a, a
	ld	hl, _tb_left
	ld	[hl], a
	inc	hl
	ld	[hl], a
;src/editor/editor.c:1030: want_x = 0;
	ld	hl, _want_x
	ld	[hl], $00
;src/editor/editor.c:1031: modified = 0;
	ld	hl, _modified
	ld	[hl], $00
;src/editor/editor.c:1032: dirty = 1;
	ld	hl, _dirty
	ld	[hl], $01
;src/editor/editor.c:1033: UndoClear(0);
	xor	a, a
	jp	_UndoClear
.l00101:
;src/editor/editor.c:1034: }
	ret
;src/editor/editor.c:1036: static void NewFile(void) {
;	---------------------------------
; Function NewFile
; ---------------------------------
_NewFile:
;src/editor/editor.c:1037: if (!CanDiscard()) return;
	call	_CanDiscard
	or	a, a
	jp	NZ, .l00102
	jp	.l00103
.l00102:
;src/editor/editor.c:1038: tb_Clear();
	call	_tb_Clear
;src/editor/editor.c:1039: file_name[0] = 0;
	ld	hl, _file_name
	ld	[hl], $00
;src/editor/editor.c:1040: fs_crlf = 0;
	ld	hl, _fs_crlf
	ld	[hl], $00
;src/editor/editor.c:1041: ResetCursor();
	call	_ResetCursor
;src/editor/editor.c:1042: SettingsSave();
	jp	_SettingsSave
.l00103:
;src/editor/editor.c:1043: }
	ret
;src/editor/editor.c:1047: static unsigned int ListFolder(const char* path, const char* find) {
;	---------------------------------
; Function ListFolder
; ---------------------------------
_ListFolder:
	add	sp, -3
	ld	hl, sp+1
	ld	[hl], c
	inc	hl
	ld	[hl], b
;src/editor/editor.c:1048: unsigned char up = path[0] != 0;
	ld	a, [de]
	sub	a,$01
	ld	a, $00
	rla
	xor	a, $01
	dec	hl
	dec	hl
	ld	[hl], a
;src/editor/editor.c:1049: list_count = 0;
	xor	a, a
	ld	hl, _list_count
	ld	[hl], a
	inc	hl
	ld	[hl], a
;src/editor/editor.c:1050: if ((list_result = FileList(path, find))) return 0;
	ld	hl, sp+1
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	call	_FileList
	ld	hl, _list_result
	ld	[hl], a
	or	a, a
	jp	Z, .l00102
	ld	bc, $0000
	jp	.l00103
.l00102:
;src/editor/editor.c:1051: list_count = fs_count + up;
	ld	hl, sp+0
	ld	c, [hl]
	ld	b, $00
	ld	hl, _fs_count
	ld	a, [hl]
	add	a, c
	ld	hl, _list_count
	ld	[hl], a
	ld	hl, _fs_count + 1
	ld	a, [hl]
	adc	a, b
	ld	hl, _list_count + 1
	ld	[hl], a
;src/editor/editor.c:1052: return find && fs_found != 0xFFFF ? fs_found + up : 0;
	ld	hl, sp+2
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	jp	Z, .l00105
	ld	hl, _fs_found
	ld	a, [hl]
	inc	a
	jp	NZ,.l00124
	inc	hl
	ld	a, [hl]
	inc	a
	jp	NZ,.l00124
	jp	.l00105
.l00124:
	ld	a, c
	ld	hl, _fs_found
	add	a, [hl]
	ld	c, a
	ld	a, b
	inc	hl
	adc	a, [hl]
	ld	b, a
	jp	.l00106
.l00105:
	ld	bc, $0000
.l00106:
.l00103:
;src/editor/editor.c:1053: }
	add	sp, 3
	ret
;src/editor/editor.c:1056: static unsigned char ListEntry(const char* path, unsigned int index) {
;	---------------------------------
; Function ListEntry
; ---------------------------------
_ListEntry:
	dec	sp
	dec	sp
	inc	sp
	inc	sp
	push	bc
;src/editor/editor.c:1057: if (path[0] && !index--) {
	ld	a, [de]
	or	a, a
	jp	Z, .l00102
	pop	bc
	push	bc
	pop	de
	push	de
	dec	de
	inc	sp
	inc	sp
	push	de
	ld	a, b
	or	a, c
	jp	NZ, .l00102
;src/editor/editor.c:1058: entry.name[0] = '.';
	ld	hl, _entry
	ld	[hl], $2E
;src/editor/editor.c:1059: entry.name[1] = '.';
	ld	hl, (_entry + 1)
	ld	[hl], $2E
;src/editor/editor.c:1060: entry.name[2] = 0;
	ld	hl, (_entry + 2)
	ld	[hl], $00
;src/editor/editor.c:1061: return KIND_UP;
	xor	a, a
	jp	.l00106
.l00102:
;src/editor/editor.c:1063: if ((list_result = FileListEntry(index, &entry))) return 0xFF;
	ld	bc, _entry
	pop	de
	push	de
	call	_FileListEntry
	ld	hl, _list_result
	ld	[hl], a
	or	a, a
	jp	Z, .l00105
	ld	a, $FF
	jp	.l00106
.l00105:
;src/editor/editor.c:1064: return entry.dir ? KIND_FOLDER : KIND_FILE;
	ld	a, [(_entry + 73) + 0]
	or	a, a
	jp	Z, .l00108
	ld	bc, $0001
	jp	.l00109
.l00108:
	ld	bc, $0002
.l00109:
	ld	a, c
.l00106:
;src/editor/editor.c:1065: }
	inc	sp
	inc	sp
	ret
;src/editor/editor.c:1068: static void ListRows(const char* path, unsigned int first, unsigned char row, unsigned char end) {
;	---------------------------------
; Function ListRows
; ---------------------------------
_ListRows:
	add	sp, -12
	ld	hl, sp+9
	ld	[hl], e
	inc	hl
	ld	[hl], d
	ld	hl, sp+7
	ld	[hl], c
	inc	hl
	ld	[hl], b
	ld	hl, sp+14
	ld	a, [hl]
	ld	hl, sp+11
	ld	[hl], a
.l00110:
;src/editor/editor.c:1071: for (; row < end; ++row) {
	ld	hl, sp+11
	ld	a, [hl]
	ld	hl, sp+15
	sub	a, [hl]
	jp	NC, .l00111
;src/editor/editor.c:1072: DrawRow(row, 0, "");
	ld	de, ___str_48
	push	de
	ld	e, $00
	ld	hl, sp+13
	ld	a, [hl]
	call	_DrawRow
;src/editor/editor.c:1073: if (first + row >= list_count) continue;
	ld	hl, sp+11
	ld	a, [hl]
	ld	hl, sp+0
	ld	[hl], a
	inc	hl
	ld	[hl], $00
	pop	bc
	push	bc
	ld	hl, sp+7
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	add	hl, bc
	ld	c, l
	ld	b, h
	ld	hl, _list_count
	ld	a, c
	sub	a, [hl]
	inc	hl
	ld	a, b
	sbc	a, [hl]
	jp	NC, .l00107
;src/editor/editor.c:1074: if ((kind = ListEntry(path, first + row)) == 0xFF) return;
	ld	hl, sp+9
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_ListEntry
	ld	hl, sp+2
	ld	[hl], a
	inc	a
	jp	NZ,.l00138
	jp	.l00139
.l00138:
	jp	.l00104
.l00139:
	jp	.l00111
.l00104:
;src/editor/editor.c:1075: list_kinds[row] = kind;
	ld	de, _list_kinds
	ld	hl, sp+11
	ld	l, [hl]
	ld	h, $00
	add	hl, de
	ld	c, l
	ld	b, h
	ld	hl, sp+2
	ld	a, [hl]
	ld	[bc], a
;src/editor/editor.c:1076: list_sizes[row] = entry.size;
	dec	hl
	dec	hl
	ld	a, [hl]
	inc	hl
	ld	b, [hl]
	add	a, a
	rl	b
	add	a, a
	rl	b
	add	a, LOW(_list_sizes)
	ld	c, a
	ld	a, b
	adc	a, HIGH(_list_sizes)
	ld	b, a
	ld	de, (_entry + 65) + 0
	ld	a, [de]
	inc	hl
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
	inc	de
	ld	a, [de]
	inc	hl
	ld	[hl], a
	ld	hl, sp+3
	ld	a, [hl]
	ld	[bc], a
	inc	bc
	inc	hl
	ld	a, [hl]
	ld	[bc], a
	inc	bc
	inc	hl
	ld	a, [hl]
	ld	[bc], a
	inc	bc
	inc	hl
	ld	a, [hl]
	ld	[bc], a
;src/editor/editor.c:1077: list_dates[row] = entry.date;
	pop	bc
	push	bc
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
;src/editor/editor.c:1078: list_times[row] = entry.time;
	ld	hl, _list_times
	add	hl, bc
	push	hl
	ld	a, l
	ld	hl, sp+7
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+6
	ld	[hl], a
	ld	hl, (_entry + 71) + 0
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	ld	hl, sp+5
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	ld	[hl], c
	inc	hl
	ld	[hl], b
;src/editor/editor.c:1079: dest = ToLatin1(RowAddress(row) + 1, entry.name, TB_STRIDE - 3);
	ld	hl, sp+11
	ld	a, [hl]
	call	_RowAddress
	ld	e, c
	ld	d, b
	inc	de
	ld	a, $25
	push	af
	inc	sp
	ld	bc, _entry
	call	_ToLatin1
	ld	hl, sp+5
	ld	[hl], c
	inc	hl
	ld	[hl], b
;src/editor/editor.c:1080: if (kind == KIND_FOLDER) *dest = '/';
	ld	hl, sp+2
	ld	a, [hl]
	dec	a
	jp	NZ,.l00142
	jp	.l00143
.l00142:
	jp	.l00107
.l00143:
	ld	hl, sp+5
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	ld	[hl], $2F
.l00107:
;src/editor/editor.c:1071: for (; row < end; ++row) {
	ld	hl, sp+11
	inc	[hl]
	jp	.l00110
.l00111:
;src/editor/editor.c:1082: }
	add	sp, 12
	pop	hl
	inc	sp
	inc	sp
	jp hl 
___str_48:
	DB $00
;src/editor/editor.c:1085: static void ScrollList(const char* path, unsigned int first, unsigned char down) {
;	---------------------------------
; Function ScrollList
; ---------------------------------
_ScrollList:
	add	sp, -13
	ld	hl, sp+10
	ld	[hl], e
	inc	hl
	ld	[hl], d
	ld	hl, sp+8
	ld	[hl], c
	inc	hl
	ld	[hl], b
;src/editor/editor.c:1087: ScrollRing(down);
	ld	hl, sp+15
	ld	a, [hl]
	call	_ScrollRing
;src/editor/editor.c:1088: tb_ScrollRows(down);
	ld	hl, sp+15
	ld	a, [hl]
	call	_tb_ScrollRows
;src/editor/editor.c:1089: for (i = 1; i < LIST_ROWS; ++i) {
	ld	hl, sp+12
	ld	[hl], $01
.l00102:
;src/editor/editor.c:1090: to = down ? i - 1 : LIST_ROWS - i;
	ld	hl, sp+12
	ld	a, [hl]
	ld	hl, sp+7
	ld	[hl], a
	ld	hl, sp+15
	ld	a, [hl]
	or	a, a
	jp	Z, .l00106
	ld	hl, sp+7
	ld	a, [hl]
	dec	a
	jp	.l00107
.l00106:
	ld	a, $10
	ld	hl, sp+7
	sub	a, [hl]
.l00107:
	ld	b, a
;src/editor/editor.c:1091: from = down ? i : to - 1;
	ld	hl, sp+15
	ld	a, [hl]
	or	a, a
	jp	Z, .l00108
	ld	hl, sp+12
	ld	c, [hl]
	jp	.l00109
.l00108:
	ld	c, b
	dec	c
.l00109:
;src/editor/editor.c:1092: list_kinds[to] = list_kinds[from];
	ld	a, LOW(_list_kinds)
	add	a, b
	ld	e, a
	ld	a, HIGH(_list_kinds)
	adc	a, $00
	ld	d, a
	ld	a, LOW(_list_kinds)
	add	a, c
	ld	l, a
;	spillPairReg hl
;	spillPairReg hl
	ld	a, HIGH(_list_kinds)
	adc	a, $00
	ld	h, a
;	spillPairReg hl
;	spillPairReg hl
	ld	a, [hl]
	ld	[de], a
;src/editor/editor.c:1093: list_sizes[to] = list_sizes[from];
	ld	hl, sp+6
	ld	[hl], b
	inc	hl
	ld	[hl], $00
	dec	hl
	ld	a, [hl]
	inc	hl
	ld	d, [hl]
	add	a, a
	rl	d
	add	a, a
	rl	d
	ld	e, a
	ld	hl, _list_sizes
	add	hl, de
	inc	sp
	inc	sp
	push	hl
	ld	b, $00
	ld	l, c
	ld	h, b
	add	hl, hl
	add	hl, hl
	ld	de, _list_sizes
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
	ld	hl, sp+2
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
;src/editor/editor.c:1094: list_dates[to] = list_dates[from];
	inc	hl
	ld	a, [hl]
	ld	hl, sp+2
	ld	[hl], a
	ld	hl, sp+7
	ld	a, [hl]
	ld	hl, sp+3
	ld	[hl], a
	dec	hl
	sla	[hl]
	inc	hl
	rl	[hl]
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, _list_dates
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+6
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+5
	ld	[hl], a
	sla	c
	rl	b
	ld	hl, _list_dates
	add	hl, bc
	ld	e, l
	ld	d, h
	ld	a, [de]
	ld	hl, sp+6
	ld	[hl], a
	inc	de
	ld	a, [de]
	inc	hl
	ld	[hl], a
	ld	hl, sp+5
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
;src/editor/editor.c:1095: list_times[to] = list_times[from];
	ld	hl, sp+3
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, _list_times
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+8
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+7
	ld	[hl], a
	ld	hl, _list_times
	add	hl, bc
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	ld	hl, sp+6
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	ld	[hl], c
	inc	hl
	ld	[hl], b
;src/editor/editor.c:1089: for (i = 1; i < LIST_ROWS; ++i) {
	ld	hl, sp+12
	inc	[hl]
	ld	a, [hl]
	sub	a, $10
	jp	C, .l00102
;src/editor/editor.c:1097: i = down ? LIST_ROWS - 1 : 0;
	ld	hl, sp+15
	ld	a, [hl]
	or	a, a
	jp	Z, .l00110
	ld	de, $000F
	jp	.l00111
.l00110:
	ld	de, $0000
.l00111:
	ld	a, e
;src/editor/editor.c:1098: ListRows(path, first, i, i + 1);
	ld	b, a
	inc	b
	push	bc
	inc	sp
	push	af
	inc	sp
	ld	hl, sp+10
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	inc	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_ListRows
.l00104:
;src/editor/editor.c:1099: }
	add	sp, 13
	pop	hl
	inc	sp
	jp hl 
;src/editor/editor.c:1102: static void ListBars(const char* path, unsigned char row, unsigned int count) {
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
;src/editor/editor.c:1104: char* end = text;
;src/editor/editor.c:1105: unsigned long size = list_sizes[row];
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
;src/editor/editor.c:1106: unsigned char* bytes = (unsigned char*)&size;
;src/editor/editor.c:1107: unsigned int date = list_dates[row], time = list_times[row];
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
;src/editor/editor.c:1108: PutPath(text, path, 30);
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
;src/editor/editor.c:1109: DrawRow(HEADER_LINE, 1, text);
	ld	hl, 0
	add	hl, sp
	push	hl
	ld	e, $01
	ld	a, $12
	call	_DrawRow
;src/editor/editor.c:1110: if (!count) end = PutText(end, "Empty folder");
	ld	hl, sp+60
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	jp	NZ, .l00116
	ld	bc, ___str_49
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
;src/editor/editor.c:1111: else if (list_kinds[row] == KIND_UP) end = PutText(end, "Parent folder");
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
	ld	bc, ___str_50
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
;src/editor/editor.c:1112: else if (list_kinds[row] == KIND_FOLDER) end = PutText(end, "Folder");
	dec	a
	jp	NZ,.l00152
	jp	.l00153
.l00152:
	jp	.l00110
.l00153:
	ld	bc, ___str_51
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
;src/editor/editor.c:1114: if (size < 10000) end = PutText(PutNumber(end, (unsigned int)size), " bytes  ");
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
	ld	bc, ___str_52
	call	_PutText
	ld	hl, sp+48
	ld	[hl], c
	inc	hl
	ld	[hl], b
	jp	.l00106
.l00105:
;src/editor/editor.c:1115: else if (size < 10485760) end = PutText(PutNumber(end, (bytes[1] >> 2) | (bytes[2] << 6)), " KB  ");
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
	ld	bc, ___str_53
	call	_PutText
	ld	hl, sp+48
	ld	[hl], c
	inc	hl
	ld	[hl], b
	jp	.l00106
.l00102:
;src/editor/editor.c:1116: else end = PutText(PutNumber(end, (bytes[2] >> 4) | (bytes[3] << 4)), " MB  ");
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
	ld	bc, ___str_54
	call	_PutText
	ld	hl, sp+48
	ld	[hl], c
	inc	hl
	ld	[hl], b
.l00106:
;src/editor/editor.c:1117: end = PutNumber(end, (date >> 9) + 1980);
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
;src/editor/editor.c:1118: *end++ = '-';
	ld	a, $2D
	ld	[bc], a
	ld	e, c
	ld	d, b
	inc	de
;src/editor/editor.c:1119: end = PutNumber2(end, (date >> 5) & 15);
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
;src/editor/editor.c:1120: *end++ = '-';
	ld	a, $2D
	ld	[bc], a
	ld	e, c
	ld	d, b
	inc	de
;src/editor/editor.c:1121: end = PutNumber2(end, date & 31);
	ld	hl, sp+44
	ld	a, [hl]
	and	a, $1F
	ld	c, a
	ld	b, $00
	call	_PutNumber2
;src/editor/editor.c:1122: *end++ = ' ';
	ld	a, $20
	ld	[bc], a
	ld	e, c
	ld	d, b
	inc	de
;src/editor/editor.c:1123: end = PutNumber2(end, time >> 11);
	ld	hl, sp+47
	ld	a, [hl]
	swap	a
	rlca
	and	a, $1F
	ld	c, a
	ld	b, $00
	call	_PutNumber2
;src/editor/editor.c:1124: *end++ = ':';
	ld	a, $3A
	ld	[bc], a
	ld	e, c
	ld	d, b
	inc	de
;src/editor/editor.c:1125: end = PutNumber2(end, (time >> 5) & 63);
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
;src/editor/editor.c:1126: if (size > TB_SIZE) end = PutText(end, "  too big");
	ld	hl, sp+40
	ld	a, $80
	sub	a, [hl]
	inc	hl
	ld	a, $FF
	sbc	a, [hl]
	inc	hl
	ld	a, $00
	sbc	a, [hl]
	inc	hl
	ld	a, $00
	sbc	a, [hl]
	jp	NC, .l00117
	ld	bc, ___str_55
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
;src/editor/editor.c:1128: *end = 0;
	ld	hl, sp+52
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	ld	[hl], $00
;src/editor/editor.c:1129: DrawRow(STATUS_LINE, 1, text);
	ld	hl, 0
	add	hl, sp
	push	hl
	ld	e, $01
	ld	a, $13
	call	_DrawRow
.l00118:
;src/editor/editor.c:1130: }
	add	sp, 57
	pop	hl
	inc	sp
	inc	sp
	jp hl 
___str_49:
	DB "Empty folder"
	DB $00
___str_50:
	DB "Parent folder"
	DB $00
___str_51:
	DB "Folder"
	DB $00
___str_52:
	DB " bytes  "
	DB $00
___str_53:
	DB " KB  "
	DB $00
___str_54:
	DB " MB  "
	DB $00
___str_55:
	DB "  too big"
	DB $00
;src/editor/editor.c:1134: static void ListLoading(const char* path, unsigned char row) {
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
;src/editor/editor.c:1136: char* end = path[0] ? ToLatin1(text, path, PATH_SIZE - 1) : text;
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
;src/editor/editor.c:1140: *end++ = '/';
	dec	hl
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	inc	bc
;src/editor/editor.c:1139: if (row != 0xFF) {
	inc	hl
	ld	a, [hl]
	inc	a
	jp	NZ,.l00147
	jp	.l00105
.l00147:
;src/editor/editor.c:1140: *end++ = '/';
	ld	hl, 168
	add	hl, sp
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	ld	[hl], $2F
;src/editor/editor.c:1141: for (name = RowAddress(row) + 1; *name != '/'; ++name) *end++ = *name;
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
;src/editor/editor.c:1143: else if (!path[0]) *end++ = '/';
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
;src/editor/editor.c:1153: ShowBusy("Loading...");
	jp	.l00106
;src/editor/editor.c:1143: else if (!path[0]) *end++ = '/';
.l00122:
	ld	hl, 168
	add	hl, sp
	ld	[hl], c
	inc	hl
	ld	[hl], b
.l00106:
;src/editor/editor.c:1144: *end = 0;
	ld	hl, 168
	add	hl, sp
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	ld	[hl], $00
;src/editor/editor.c:1145: length = (unsigned char)(end - text);
	ld	hl, sp+0
	ld	c, l
	ld	b, h
	ld	hl, 168
	add	hl, sp
	ld	a, [hl]
	ld	e, c
	sub	a, e
	ld	e, a
;src/editor/editor.c:1146: end = text;
;src/editor/editor.c:1147: if (length > 30) {
	ld	a, $1E
	sub	a, e
	jp	NC, .l00108
;src/editor/editor.c:1148: end += length - 33;
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
;src/editor/editor.c:1149: end[0] = end[1] = end[2] = '.';
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
;src/editor/editor.c:1151: DrawRow(HEADER_LINE, 1, end);
	push	bc
	ld	e, $01
	ld	a, $12
	call	_DrawRow
;src/editor/editor.c:1152: DrawRow(STATUS_LINE, 1, "");
	ld	de, ___str_56
	push	de
	ld	e, $01
	ld	a, $13
	call	_DrawRow
;src/editor/editor.c:1153: ShowBusy("Loading...");
	ld	de, ___str_57
	call	_ShowBusy
.l00112:
;src/editor/editor.c:1154: }
	add	sp, 127
	add	sp, 46
	ret
___str_56:
	DB $00
___str_57:
	DB "Loading..."
	DB $00
;src/editor/editor.c:1157: static void ListMessage(const char* text) {
;	---------------------------------
; Function ListMessage
; ---------------------------------
_ListMessage:
;src/editor/editor.c:1158: HideBox();
	push	de
	call	_HideBox
	pop	de
;src/editor/editor.c:1159: DrawRow(STATUS_LINE, 1, text);
	push	de
	ld	e, $01
	ld	a, $13
	call	_DrawRow
;src/editor/editor.c:1160: EditorDraw();
	call	_EditorDraw
;src/editor/editor.c:1161: while (!MenuKey());
.l00101:
	call	_MenuKey
	or	a, a
	jp	Z, .l00101
.l00104:
;src/editor/editor.c:1162: }
	ret
;src/editor/editor.c:1167: static unsigned char Browse(void) {
;	---------------------------------
; Function Browse
; ---------------------------------
_Browse:
	ld	hl, -270
	add	hl, sp
	ld	sp, hl
;src/editor/editor.c:1170: unsigned int selected = 0, first = 0, drawn = LIST_ALL;
	xor	a, a
	ld	hl, 268
	add	hl, sp
	ld	[hl], a
	inc	hl
	ld	[hl], a
	xor	a, a
	ld	hl, 258
	add	hl, sp
	ld	[hl], a
	inc	hl
	ld	[hl], a
	inc	hl
	ld	[hl], $FF
	inc	hl
	ld	[hl], $FF
;src/editor/editor.c:1171: unsigned char key, result, row, opened = 0, editor_font = font, length;
	inc	hl
	ld	[hl], $00
	ld	hl, _font
	ld	a, [hl]
	ld	hl, 263
	add	hl, sp
	ld	[hl], a
;src/editor/editor.c:1172: CopyName(path, file_dir);
	ld	bc, _file_dir
	ld	hl, 0
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_CopyName
;src/editor/editor.c:1173: font = FONT_VWF;
	ld	hl, _font
	ld	[hl], $01
;src/editor/editor.c:1174: SetFont(font);
	ld	a, $01
	call	_SetFont
;src/editor/editor.c:1175: render_text = 0;
	ld	hl, _render_text
	ld	[hl], $00
;src/editor/editor.c:1176: EditorShowCursor(0);
	xor	a, a
	call	_EditorShowCursor
;src/editor/editor.c:1177: if (osk_shown) OSKShow(0);
	ld	hl, _osk_shown
	ld	a, [hl]
	or	a, a
	jp	Z, .l00102
	xor	a, a
	call	_OSKShow
.l00102:
;src/editor/editor.c:1178: bars = 1;
	ld	hl, _bars
	ld	[hl], $01
;src/editor/editor.c:1179: tb_rows = LIST_ROWS;
	ld	hl, _tb_rows
	ld	[hl], $10
;src/editor/editor.c:1180: Layout();
	call	_Layout
;src/editor/editor.c:1181: NoHighlight();
	call	_NoHighlight
;src/editor/editor.c:1182: ListLoading(path, 0xFF);
	ld	a, $FF
	ld	hl, 0
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_ListLoading
;src/editor/editor.c:1183: if ((result = FileMount())) {
	call	_FileMount
	ld	hl, 267
	add	hl, sp
	ld	[hl], a
	or	a, a
	jp	Z, .l00104
;src/editor/editor.c:1184: ShowError(result, "");
	ld	de, ___str_58
	ld	a, [hl]
	call	_ShowError
;src/editor/editor.c:1185: selected = LIST_ALL; // skips the list
	ld	hl, 268
	add	hl, sp
	ld	[hl], $FF
	inc	hl
	ld	[hl], $FF
	jp	.l00221
.l00104:
;src/editor/editor.c:1187: else ListFolder(path, 0);
	ld	bc, $0000
	ld	hl, 0
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_ListFolder
;src/editor/editor.c:1188: while (selected != LIST_ALL) {
.l00221:
.l00193:
	ld	hl, 268
	add	hl, sp
	ld	a, [hl]
	inc	hl
	and	a, [hl]
	inc	a
	jp	NZ,.l00461
	jp	.l00195
.l00461:
;src/editor/editor.c:1189: if (selected < first) first = selected;
	ld	hl, 268
	add	hl, sp
	ld	e, l
	ld	d, h
	ld	hl, 258
	add	hl, sp
	ld	a, [de]
	inc	de
	sub	a, [hl]
	inc	hl
	ld	a, [de]
	sbc	a, [hl]
	jp	NC, .l00109
	ld	hl, 268
	add	hl, sp
	ld	a, [hl]
	ld	hl, 258
	add	hl, sp
	ld	[hl], a
	ld	hl, 269
	add	hl, sp
	ld	a, [hl]
	ld	hl, 259
	add	hl, sp
	ld	[hl], a
	jp	.l00110
.l00109:
;src/editor/editor.c:1190: else if (selected >= first + LIST_ROWS) first = selected - LIST_ROWS + 1;
	ld	hl, 259
	add	hl, sp
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $0010
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, 268
	add	hl, sp
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, 267
	add	hl, sp
	ld	[hl], a
	ld	hl, 268
	add	hl, sp
	ld	e, l
	ld	d, h
	ld	hl, 266
	add	hl, sp
	ld	a, [de]
	inc	de
	sub	a, [hl]
	inc	hl
	ld	a, [de]
	sbc	a, [hl]
	jp	C, .l00110
	ld	hl, 269
	add	hl, sp
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $FFF1
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, 260
	add	hl, sp
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, 259
	add	hl, sp
	ld	[hl], a
.l00110:
;src/editor/editor.c:1191: if (!list_result && first != drawn) {
	ld	hl, _list_result
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00120
	ld	hl, 258
	add	hl, sp
	ld	a, [hl]
	inc	hl
	inc	hl
	sub	a, [hl]
	jp	NZ,.l00462
	dec	hl
	ld	a, [hl]
	inc	hl
	inc	hl
	sub	a, [hl]
	jp	NZ,.l00462
	jp	.l00120
.l00462:
;src/editor/editor.c:1192: if (drawn != LIST_ALL && first == drawn + 1) ScrollList(path, first, 1);
	ld	hl, 260
	add	hl, sp
	ld	a, [hl]
	inc	hl
	and	a, [hl]
	inc	a
	jp	NZ,.l00463
	ld	a,$01
	jp	.l00464
.l00463:
	xor	a,a
.l00464:
	ld	hl, 265
	add	hl, sp
	ld	[hl], a
	bit	0, [hl]
	jp	NZ, .l00116
	ld	hl, 261
	add	hl, sp
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $0001
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, 268
	add	hl, sp
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, 267
	add	hl, sp
	ld	[hl], a
	dec	hl
	ld	a, [hl]
	ld	hl, 258
	add	hl, sp
	sub	a, [hl]
	jp	NZ,.l00465
	ld	hl, 267
	add	hl, sp
	ld	a, [hl]
	ld	hl, 259
	add	hl, sp
	sub	a, [hl]
	jp	NZ,.l00465
	jp	.l00466
.l00465:
	jp	.l00116
.l00466:
	ld	a, $01
	push	af
	inc	sp
	ld	hl, 259
	add	hl, sp
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	ld	hl, 1
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_ScrollList
	jp	.l00117
.l00116:
;src/editor/editor.c:1193: else if (drawn != LIST_ALL && first + 1 == drawn) ScrollList(path, first, 0);
	ld	hl, 265
	add	hl, sp
	bit	0, [hl]
	jp	NZ, .l00112
	ld	hl, 258
	add	hl, sp
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	inc	bc
	inc	hl
	ld	a, [hl]
	sub	a, c
	jp	NZ,.l00467
	inc	hl
	ld	a, [hl]
	sub	a, b
	jp	NZ,.l00467
	jp	.l00468
.l00467:
	jp	.l00112
.l00468:
	xor	a, a
	push	af
	inc	sp
	ld	hl, 259
	add	hl, sp
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	ld	hl, 1
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_ScrollList
	jp	.l00117
.l00112:
;src/editor/editor.c:1194: else ListRows(path, first, 0, LIST_ROWS);
	ld	a, $10
	push	af
	inc	sp
	xor	a, a
	push	af
	inc	sp
	ld	hl, 260
	add	hl, sp
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	ld	hl, 2
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_ListRows
.l00117:
;src/editor/editor.c:1195: HideBox();
	call	_HideBox
;src/editor/editor.c:1196: drawn = first;
	ld	hl, 258
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
.l00120:
;src/editor/editor.c:1198: if (list_result) {
	ld	hl, _list_result
	ld	a, [hl]
	or	a, a
	jp	Z, .l00125
;src/editor/editor.c:1199: if (!path[0]) { // can't read the card
	ld	hl, sp+0
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00123
;src/editor/editor.c:1200: ShowError(list_result, "");
	ld	de, ___str_58
	ld	hl, _list_result
	ld	a, [hl]
	call	_ShowError
;src/editor/editor.c:1201: break;
	jp	.l00195
.l00123:
;src/editor/editor.c:1203: path[0] = 0; // folder is gone, back to the root
	ld	hl, sp+0
	ld	[hl], $00
;src/editor/editor.c:1204: ListLoading(path, 0xFF);
	ld	a, $FF
	ld	hl, 0
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_ListLoading
;src/editor/editor.c:1205: selected = ListFolder(path, 0);
	ld	bc, $0000
	ld	hl, 0
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_ListFolder
	ld	hl, 268
	add	hl, sp
	ld	[hl], c
	inc	hl
	ld	[hl], b
;src/editor/editor.c:1206: drawn = LIST_ALL;
	ld	hl, 260
	add	hl, sp
	ld	[hl], $FF
	inc	hl
	ld	[hl], $FF
;src/editor/editor.c:1207: continue;
	jp	.l00193
.l00125:
;src/editor/editor.c:1209: row = (unsigned char)(selected - first);
	ld	hl, 268
	add	hl, sp
	ld	a, [hl]
	ld	hl, 258
	add	hl, sp
	ld	c, [hl]
	sub	a, c
	ld	hl, 264
	add	hl, sp
	ld	[hl], a
;src/editor/editor.c:1210: ListBars(path, row, list_count);
	ld	hl, _list_count
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	push	de
	ld	hl, 266
	add	hl, sp
	ld	a, [hl]
	ld	hl, 2
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_ListBars
;src/editor/editor.c:1211: NoHighlight();
	call	_NoHighlight
;src/editor/editor.c:1212: if (list_count) render_sel[(row + 1) << 1] = 0, render_sel[((row + 1) << 1) + 1] = 0xFF;
	ld	hl, _list_count + 1
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	jp	Z, .l00127
	ld	hl, 264
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
.l00127:
;src/editor/editor.c:1213: EditorDraw();
	call	_EditorDraw
;src/editor/editor.c:1214: while (!(key = MenuKey()));
.l00128:
	call	_MenuKey
	ld	hl, 265
	add	hl, sp
	ld	[hl], a
	or	a, a
	jp	Z, .l00128
;src/editor/editor.c:1215: if (key == KEY_UP && selected) --selected;
	ld	a, [hl]
	sub	a, $82
	jp	NZ,.l00469
	jp	.l00470
.l00469:
	jp	.l00190
.l00470:
	ld	hl, 269
	add	hl, sp
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	jp	Z, .l00190
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
	jp	.l00193
.l00190:
;src/editor/editor.c:1216: else if (key == KEY_DOWN && selected + 1 < list_count) ++selected;
	ld	hl, 265
	add	hl, sp
	ld	a, [hl]
	sub	a, $83
	jp	NZ,.l00471
	jp	.l00472
.l00471:
	jp	.l00186
.l00472:
	ld	hl, 268
	add	hl, sp
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	inc	bc
	ld	hl, _list_count
	ld	a, c
	sub	a, [hl]
	inc	hl
	ld	a, b
	sbc	a, [hl]
	jp	NC, .l00186
	ld	hl, 268
	add	hl, sp
	ld	[hl], c
	inc	hl
	ld	[hl], b
	jp	.l00193
.l00186:
;src/editor/editor.c:1217: else if (key == KEY_PAGE_UP) selected = selected > LIST_ROWS ? selected - LIST_ROWS : 0;
	ld	hl, 265
	add	hl, sp
	ld	a, [hl]
	sub	a, $86
	jp	NZ,.l00473
	jp	.l00474
.l00473:
	jp	.l00183
.l00474:
	ld	hl, 268
	add	hl, sp
	ld	a, $10
	sub	a, [hl]
	inc	hl
	ld	a, $00
	sbc	a, [hl]
	jp	NC, .l00204
	ld	hl, 269
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
	ld	c, e
	jp	.l00205
.l00204:
	ld	c, $00
	xor	a, a
.l00205:
	ld	hl, 268
	add	hl, sp
	ld	[hl], c
	inc	hl
	ld	[hl], a
	jp	.l00193
.l00183:
;src/editor/editor.c:1218: else if (key == KEY_PAGE_DOWN && list_count) selected = selected + LIST_ROWS < list_count ? selected + LIST_ROWS : list_count - 1;
	ld	hl, _list_count + 1
	dec	hl
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	dec	bc
	ld	hl, 265
	add	hl, sp
	ld	a, [hl]
	sub	a, $87
	jp	NZ,.l00475
	jp	.l00476
.l00475:
	jp	.l00179
.l00476:
	ld	hl, _list_count + 1
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	jp	Z, .l00179
	ld	hl, 269
	add	hl, sp
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $0010
	add	hl, de
	ld	e, l
	ld	d, h
	ld	hl, _list_count
	ld	a, e
	sub	a, [hl]
	inc	hl
	ld	a, d
	sbc	a, [hl]
	jp	NC, .l00206
	ld	c, e
	ld	b, d
	jp	.l00207
.l00206:
.l00207:
	ld	hl, 268
	add	hl, sp
	ld	[hl], c
	inc	hl
	ld	[hl], b
	jp	.l00193
.l00179:
;src/editor/editor.c:1219: else if (key == KEY_HOME) selected = 0;
	ld	hl, 265
	add	hl, sp
	ld	a, [hl]
	sub	a, $84
	jp	NZ,.l00477
	jp	.l00478
.l00477:
	jp	.l00176
.l00478:
	xor	a, a
	ld	hl, 268
	add	hl, sp
	ld	[hl], a
	inc	hl
	ld	[hl], a
	jp	.l00193
.l00176:
;src/editor/editor.c:1220: else if (key == KEY_END && list_count) selected = list_count - 1;
	ld	hl, 265
	add	hl, sp
	ld	a, [hl]
	sub	a, $85
	jp	NZ,.l00479
	jp	.l00480
.l00479:
	jp	.l00172
.l00480:
	ld	hl, _list_count + 1
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	jp	Z, .l00172
	ld	hl, 268
	add	hl, sp
	ld	[hl], c
	inc	hl
	ld	[hl], b
	jp	.l00193
.l00172:
;src/editor/editor.c:1221: else if ((key == KEY_ENTER || key == KEY_RIGHT) && list_count && list_kinds[row] != KIND_UP) {
	ld	hl, 265
	add	hl, sp
	ld	a, [hl]
	sub	a, $0A
	jp	NZ,.l00481
	ld	a,$01
	jp	.l00482
.l00481:
	xor	a,a
.l00482:
	ld	hl, 266
	add	hl, sp
	ld	[hl], a
	dec	hl
	ld	a, [hl]
	sub	a, $81
	jp	NZ,.l00483
	ld	a,$01
	jp	.l00484
.l00483:
	xor	a,a
.l00484:
	ld	hl, 267
	add	hl, sp
	ld	[hl], a
	dec	hl
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00169
	inc	hl
	ld	a, [hl]
	or	a, a
	jp	Z, .l00166
.l00169:
	ld	hl, _list_count + 1
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	jp	Z, .l00166
	ld	de, _list_kinds
	ld	hl, 264
	add	hl, sp
	ld	l, [hl]
	ld	h, $00
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, [bc]
	or	a, a
	jp	Z, .l00166
;src/editor/editor.c:1222: if (list_kinds[row] == KIND_FOLDER) ListLoading(path, row);
	dec	a
	jp	NZ,.l00485
	jp	.l00486
.l00485:
	jp	.l00132
.l00486:
	ld	hl, 264
	add	hl, sp
	ld	a, [hl]
	ld	hl, 0
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_ListLoading
	jp	.l00133
.l00132:
;src/editor/editor.c:1223: else ShowBusy("Loading...");
	ld	de, ___str_59
	call	_ShowBusy
.l00133:
;src/editor/editor.c:1224: if (ListEntry(path, selected) == 0xFF) continue; // its full name
	ld	hl, 268
	add	hl, sp
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	ld	hl, 0
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_ListEntry
	inc	a
	jp	NZ,.l00487
	jp	.l00193
.l00487:
;src/editor/editor.c:1225: for (length = 0; path[length]; ++length);
	ld	c, $00
.l00197:
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
	ld	hl, 268
	add	hl, sp
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, 267
	add	hl, sp
	ld	[hl], a
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	or	a, a
	jp	Z, .l00136
	inc	c
	jp	.l00197
.l00136:
;src/editor/editor.c:1226: if (entry.dir) {
	ld	a, [(_entry + 73) + 0]
	or	a, a
	jp	Z, .l00147
;src/editor/editor.c:1227: if (JoinPath(path + length, "", entry.name, PATH_SIZE - length)) {
	ld	a, $80
	sub	a, c
	ld	hl, 266
	add	hl, sp
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	push	af
	inc	sp
	ld	bc, _entry
	push	bc
	ld	bc, ___str_58
	call	_JoinPath
	or	a, a
	jp	Z, .l00138
;src/editor/editor.c:1228: selected = ListFolder(path, 0);
	ld	bc, $0000
	ld	hl, 0
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_ListFolder
	ld	hl, 268
	add	hl, sp
	ld	[hl], c
	inc	hl
	ld	[hl], b
;src/editor/editor.c:1229: drawn = LIST_ALL;
	ld	hl, 260
	add	hl, sp
	ld	[hl], $FF
	inc	hl
	ld	[hl], $FF
	jp	.l00193
.l00138:
;src/editor/editor.c:1232: path[length] = 0;
	ld	hl, 266
	add	hl, sp
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	ld	[hl], $00
;src/editor/editor.c:1233: ListMessage("Path is too long");
	ld	de, ___str_60
	call	_ListMessage
	jp	.l00193
.l00147:
;src/editor/editor.c:1236: else if (entry.size > TB_SIZE) ListMessage("Too big to open");
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
	ld	a, $80
	cp	a, c
	ld	a, $FF
	sbc	a, b
	ld	a, $00
	sbc	a, l
	ld	a, $00
	sbc	a, h
	jp	NC, .l00144
	ld	de, ___str_61
	call	_ListMessage
	jp	.l00193
.l00144:
;src/editor/editor.c:1238: JoinPath(path + length, "", entry.name, FS_NAME_SIZE + 1);
	ld	hl, 266
	add	hl, sp
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, $42
	push	af
	inc	sp
	ld	bc, _entry
	push	bc
	ld	bc, ___str_58
	call	_JoinPath
;src/editor/editor.c:1239: result = FileLoad(path);
	ld	hl, 0
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_FileLoad
	ld	c, a
;src/editor/editor.c:1240: HideBox();
	push	bc
	call	_HideBox
	pop	bc
;src/editor/editor.c:1241: path[length] = 0;
	ld	hl, 266
	add	hl, sp
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	ld	[hl], $00
;src/editor/editor.c:1242: if (result) {
	ld	a, c
	or	a, a
	jp	Z, .l00141
;src/editor/editor.c:1243: file_name[0] = 0; // the text buffer only has part of it, don't save over the file
	ld	hl, _file_name
	ld	[hl], $00
;src/editor/editor.c:1244: ShowError(result, "TOO BIG");
	ld	de, ___str_62
	ld	a, c
	call	_ShowError
	jp	.l00142
.l00141:
;src/editor/editor.c:1247: CopyName(file_dir, path);
	ld	hl, 0
	add	hl, sp
	ld	c, l
	ld	b, h
	ld	de, _file_dir
	call	_CopyName
;src/editor/editor.c:1248: CopyName(file_name, entry.name);
	ld	bc, _entry
	ld	de, _file_name
	call	_CopyName
.l00142:
;src/editor/editor.c:1250: opened = 1;
	ld	hl, 262
	add	hl, sp
	ld	[hl], $01
;src/editor/editor.c:1251: break;
	jp	.l00195
.l00166:
;src/editor/editor.c:1254: else if (path[0] && (key == KEY_LEFT || key == KEY_BACKSPACE ||
	ld	hl, sp+0
	ld	c, [hl]
	ld	hl, 265
	add	hl, sp
	ld	a, [hl]
	sub	a, $08
	jp	NZ,.l00488
	ld	a,$01
	jp	.l00489
.l00488:
	xor	a,a
.l00489:
	ld	e, a
	ld	a, c
	or	a, a
	jp	Z, .l00157
	ld	hl, 265
	add	hl, sp
	ld	a, [hl]
	sub	a, $80
	jp	NZ,.l00490
	jp	.l00254
.l00490:
	ld	a, e
	or	a, a
	jp	NZ, .l00254
;src/editor/editor.c:1255: ((key == KEY_ENTER || key == KEY_RIGHT) && list_count && list_kinds[row] == KIND_UP))) {
	ld	hl, 266
	add	hl, sp
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00161
	inc	hl
	ld	a, [hl]
	or	a, a
	jp	Z, .l00157
.l00161:
	ld	hl, _list_count + 1
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	jp	Z, .l00157
	push	de
	ld	de, _list_kinds
	ld	hl, 266
	add	hl, sp
	ld	l, [hl]
	ld	h, $00
	add	hl, de
	pop	de
	ld	c, l
	ld	b, h
	ld	a, [bc]
	or	a, a
	jp	NZ, .l00157
;src/editor/editor.c:1256: for (length = 0; path[length]; ++length);
.l00254:
	ld	c, $00
.l00200:
	ld	e, c
	ld	d, $00
	ld	hl, 0
	add	hl, sp
	add	hl, de
	ld	a, [hl]
	or	a, a
	jp	Z, .l00255
	inc	c
	jp	.l00200
;src/editor/editor.c:1257: while (path[--length] != '/');
.l00255:
.l00150:
	dec	c
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
	sub	a, $2F
	jp	NZ,.l00491
	jp	.l00492
.l00491:
	jp	.l00150
.l00492:
;src/editor/editor.c:1258: CopyName(name, path + length + 1);
	dec	hl
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	inc	bc
	ld	hl, 193
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_CopyName
;src/editor/editor.c:1259: path[length] = 0;
	ld	hl, 268
	add	hl, sp
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	ld	[hl], $00
;src/editor/editor.c:1260: ListLoading(path, 0xFF);
	ld	a, $FF
	ld	hl, 0
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_ListLoading
;src/editor/editor.c:1261: selected = ListFolder(path, name); // back on the folder it came from
	ld	hl, 193
	add	hl, sp
	ld	c, l
	ld	b, h
	ld	hl, 0
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_ListFolder
	ld	hl, 268
	add	hl, sp
	ld	[hl], c
	inc	hl
	ld	[hl], b
;src/editor/editor.c:1262: drawn = LIST_ALL;
	ld	hl, 260
	add	hl, sp
	ld	[hl], $FF
	inc	hl
	ld	[hl], $FF
	jp	.l00193
.l00157:
;src/editor/editor.c:1264: else if (key == KEY_ESCAPE || key == KEY_BACKSPACE) break;
	ld	hl, 265
	add	hl, sp
	ld	a, [hl]
	sub	a, $1B
	jp	NZ,.l00493
	jp	.l00195
.l00493:
	ld	a, e
	or	a, a
	jp	Z, .l00193
.l00195:
;src/editor/editor.c:1266: font = editor_font;
	ld	hl, 263
	add	hl, sp
	ld	a, [hl]
	ld	hl, _font
	ld	[hl], a
;src/editor/editor.c:1267: SetFont(font);
	ld	a, [hl]
	call	_SetFont
;src/editor/editor.c:1268: render_text = 1;
	ld	hl, _render_text
	ld	[hl], $01
;src/editor/editor.c:1269: SetRows();
	call	_SetRows
;src/editor/editor.c:1270: return opened;
	ld	hl, 262
	add	hl, sp
	ld	a, [hl]
.l00202:
;src/editor/editor.c:1271: }
	ld	hl, 270
	add	hl, sp
	ld	sp, hl
	ret
___str_58:
	DB $00
___str_59:
	DB "Loading..."
	DB $00
___str_60:
	DB "Path is too long"
	DB $00
___str_61:
	DB "Too big to open"
	DB $00
___str_62:
	DB "TOO BIG"
	DB $00
;src/editor/editor.c:1273: static void OpenFile(void) {
;	---------------------------------
; Function OpenFile
; ---------------------------------
_OpenFile:
;src/editor/editor.c:1274: if (!CanDiscard()) return;
	call	_CanDiscard
	or	a, a
	jp	NZ, .l00102
	jp	.l00105
.l00102:
;src/editor/editor.c:1275: if (Browse()) {
	call	_Browse
	or	a, a
	jp	Z, .l00105
;src/editor/editor.c:1276: ResetCursor();
	call	_ResetCursor
;src/editor/editor.c:1277: SettingsSave();
	jp	_SettingsSave
.l00105:
;src/editor/editor.c:1279: }
	ret
;src/editor/editor.c:1282: static unsigned char NameChar(unsigned char c) {
;	---------------------------------
; Function NameChar
; ---------------------------------
_NameChar:
	ld	c, a
;src/editor/editor.c:1283: if (c < ' ' || (c >= 0x7F && c < 0xA0)) return 0;
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
;src/editor/editor.c:1284: return c != '/' && c != 0x5C && c != ':' && c != '*' && c != '?' && c != '"' && c != '<' && c != '>' && c != '|';
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
;src/editor/editor.c:1285: }
	ret
;src/editor/editor.c:1288: static unsigned char AskFileName(void) {
;	---------------------------------
; Function AskFileName
; ---------------------------------
_AskFileName:
	add	sp, -78
;src/editor/editor.c:1293: length = (unsigned char)(ToLatin1(name, file_name, NAME_CHARS) - name);
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
;src/editor/editor.c:1294: Render();
	call	_Render
;src/editor/editor.c:1295: EditorShowCursor(0);
	xor	a, a
	call	_EditorShowCursor
;src/editor/editor.c:1296: NoHighlight();
	call	_NoHighlight
;src/editor/editor.c:1297: while (1) {
.l00124:
;src/editor/editor.c:1298: end = PutText(text, "Save as ");
	ld	bc, ___str_63
	ld	hl, 35
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_PutText
;src/editor/editor.c:1299: for (i = 0; i < length; ++i) *end++ = name[i];
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
;src/editor/editor.c:1300: *end++ = '_';
	ld	a, $5F
	ld	[bc], a
	pop	bc
	push	bc
;src/editor/editor.c:1301: *end = 0;
	xor	a, a
	ld	[bc], a
;src/editor/editor.c:1302: if (bars) {
	ld	hl, _bars
	ld	a, [hl]
	or	a, a
	jp	Z, .l00103
;src/editor/editor.c:1303: DrawRow(HEADER_LINE, 1, text);
	ld	hl, 35
	add	hl, sp
	push	hl
	ld	e, $01
	ld	a, $12
	call	_DrawRow
;src/editor/editor.c:1304: end = PutText(text, "in ");
	ld	bc, ___str_64
	ld	hl, 35
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_PutText
	ld	e, c
	ld	d, b
;src/editor/editor.c:1305: PutPath(end, file_dir, 28);
	ld	a, $1C
	push	af
	inc	sp
	ld	bc, _file_dir
	call	_PutPath
;src/editor/editor.c:1306: DrawRow(STATUS_LINE, 1, text);
	ld	hl, 35
	add	hl, sp
	push	hl
	ld	e, $01
	ld	a, $13
	call	_DrawRow
	jp	.l00104
.l00103:
;src/editor/editor.c:1308: else DrawRow(0, 0, text);
	ld	hl, 35
	add	hl, sp
	push	hl
	ld	e, $00
	xor	a, a
	call	_DrawRow
.l00104:
;src/editor/editor.c:1309: EditorDraw();
	call	_EditorDraw
;src/editor/editor.c:1310: do {
.l00107:
;src/editor/editor.c:1311: WaitFrame();
	call	_WaitFrame
;src/editor/editor.c:1312: key = (unsigned char)KBPopEvent();
	call	_KBPopEvent
	ld	hl, sp+76
	ld	[hl], c
;src/editor/editor.c:1313: if (!key) key = PadKey();
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00108
	call	_PadKey
	ld	hl, sp+76
	ld	[hl], a
.l00108:
;src/editor/editor.c:1314: } while (!key);
	ld	hl, sp+76
	ld	a, [hl]
	or	a, a
	jp	Z, .l00107
;src/editor/editor.c:1315: if (key == KEY_ENTER && length) break;
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
;src/editor/editor.c:1316: if (key == KEY_ESCAPE || (key == KEY_BACKSPACE && !length)) {
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
;src/editor/editor.c:1317: dirty = 1;
	ld	hl, _dirty
	ld	[hl], $01
;src/editor/editor.c:1318: return 0;
	xor	a, a
	jp	.l00129
.l00114:
;src/editor/editor.c:1320: if (key == KEY_BACKSPACE) --length;
	ld	a, c
	or	a, a
	jp	Z, .l00121
	ld	hl, sp+77
	dec	[hl]
	jp	.l00124
.l00121:
;src/editor/editor.c:1321: else if (length < NAME_CHARS && NameChar(key)) name[length++] = key;
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
;src/editor/editor.c:1323: name[length] = 0;
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
;src/editor/editor.c:1324: ToUtf8(file_name, name);
	ld	hl, 2
	add	hl, sp
	ld	c, l
	ld	b, h
	ld	de, _file_name
	call	_ToUtf8
;src/editor/editor.c:1325: SetLang();
	call	_SetLang
;src/editor/editor.c:1326: dirty = 1;
	ld	hl, _dirty
	ld	[hl], $01
;src/editor/editor.c:1327: return 1;
	ld	a, $01
.l00129:
;src/editor/editor.c:1328: }
	add	sp, 78
	ret
___str_63:
	DB "Save as "
	DB $00
___str_64:
	DB "in "
	DB $00
;src/editor/editor.c:1330: static void SaveFile(unsigned char ask) {
;	---------------------------------
; Function SaveFile
; ---------------------------------
_SaveFile:
	add	sp, -128
	add	sp, -65
	ld	c, a
;src/editor/editor.c:1333: if ((ask || !file_name[0]) && !AskFileName()) return;
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
;src/editor/editor.c:1334: JoinPath(path, file_dir, file_name, (unsigned char)(PATH_SIZE + FS_NAME_SIZE));
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
;src/editor/editor.c:1335: ShowBusy("Saving...");
	ld	de, ___str_65
	call	_ShowBusy
;src/editor/editor.c:1336: result = FileMount();
	call	_FileMount
	ld	c, a
;src/editor/editor.c:1337: if (!result) result = FileSave(path);
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
;src/editor/editor.c:1338: HideBox();
	push	bc
	call	_HideBox
	pop	bc
;src/editor/editor.c:1339: SettingsSave(); // save as may have changed the name
	push	bc
	call	_SettingsSave
	pop	bc
;src/editor/editor.c:1340: if (result) {
	ld	a, c
	or	a, a
	jp	Z, .l00108
;src/editor/editor.c:1341: ShowError(result, "DISK FULL");
	ld	de, ___str_66
	ld	a, c
	call	_ShowError
;src/editor/editor.c:1342: return;
	jp	.l00109
.l00108:
;src/editor/editor.c:1344: modified = 0;
	ld	hl, _modified
	ld	[hl], $00
;src/editor/editor.c:1345: UndoSaved();
	call	_UndoSaved
;src/editor/editor.c:1346: ShowMessage("SAVED");
	ld	de, ___str_67
	call	_ShowMessage
.l00109:
;src/editor/editor.c:1347: }
	add	sp, 127
	add	sp, 66
	ret
___str_65:
	DB "Saving..."
	DB $00
___str_66:
	DB "DISK FULL"
	DB $00
___str_67:
	DB "SAVED"
	DB $00
;src/editor/editor.c:1350: static void ToggleWrap(void) {
;	---------------------------------
; Function ToggleWrap
; ---------------------------------
_ToggleWrap:
;src/editor/editor.c:1351: tb_nowrap = !tb_nowrap;
	ld	hl, _tb_nowrap
	ld	a, [hl]
	sub	a,$01
	ld	a, $00
	rla
	ld	[hl], a
;src/editor/editor.c:1352: tb_left = 0;
	xor	a, a
	ld	hl, _tb_left
	ld	[hl], a
	inc	hl
	ld	[hl], a
;src/editor/editor.c:1353: dirty = 1;
	ld	hl, _dirty
	ld	[hl], $01
;src/editor/editor.c:1354: SettingsSave();
	jp	_SettingsSave
.l00101:
;src/editor/editor.c:1355: }
	ret
;src/editor/editor.c:1358: static void ToggleFont(void) {
;	---------------------------------
; Function ToggleFont
; ---------------------------------
_ToggleFont:
;src/editor/editor.c:1359: font = font == FONT_VWF ? FONT_FIXED : FONT_VWF;
	ld	hl, _font
	ld	a, [hl]
	dec	a
	jp	NZ,.l00110
	jp	.l00111
.l00110:
	jp	.l00103
.l00111:
	ld	bc, $0002
	jp	.l00104
.l00103:
	ld	bc, $0001
.l00104:
	ld	hl, _font
	ld	[hl], c
;src/editor/editor.c:1360: SetFont(font);
	ld	a, [hl]
	call	_SetFont
;src/editor/editor.c:1361: Layout(); // the rows' fonts
	call	_Layout
;src/editor/editor.c:1362: dirty = 1;
	ld	hl, _dirty
	ld	[hl], $01
;src/editor/editor.c:1363: SettingsSave();
	jp	_SettingsSave
.l00101:
;src/editor/editor.c:1364: }
	ret
;src/editor/editor.c:1367: static void ShowHelp(void) {
;	---------------------------------
; Function ShowHelp
; ---------------------------------
_ShowHelp:
	dec	sp
;src/editor/editor.c:1368: unsigned char row, editor_font = font;
	ld	hl, _font
	ld	a, [hl]
	ld	hl, sp+0
	ld	[hl], a
;src/editor/editor.c:1369: font = FONT_VWF;
	ld	hl, _font
	ld	[hl], $01
;src/editor/editor.c:1370: SetFont(font);
	ld	a, $01
	call	_SetFont
;src/editor/editor.c:1371: render_text = 0;
	ld	hl, _render_text
	ld	[hl], $00
;src/editor/editor.c:1372: BeginFullScreen();
	call	_BeginFullScreen
;src/editor/editor.c:1373: for (row = 0; row < HELP_ROWS; ++row) DrawRow(row, 0, help_lines[row]);
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
;src/editor/editor.c:1374: EditorDraw();
	call	_EditorDraw
;src/editor/editor.c:1375: while (!MenuKey());
.l00102:
	call	_MenuKey
	or	a, a
	jp	Z, .l00102
;src/editor/editor.c:1376: font = editor_font;
	ld	hl, sp+0
	ld	a, [hl]
	ld	hl, _font
	ld	[hl], a
;src/editor/editor.c:1377: SetFont(font);
	ld	a, [hl]
	call	_SetFont
;src/editor/editor.c:1378: render_text = 1;
	ld	hl, _render_text
	ld	[hl], $01
;src/editor/editor.c:1379: EndFullScreen();
	inc	sp
	jp	_EndFullScreen
.l00107:
;src/editor/editor.c:1380: }
	inc	sp
	ret
;src/editor/editor.c:1382: static void FileMenu(void) {
;	---------------------------------
; Function FileMenu
; ---------------------------------
_FileMenu:
;src/editor/editor.c:1383: switch (Choose("MENU", menu_items[0], 10)) {
	ld	a, $0A
	push	af
	inc	sp
	ld	bc, _menu_items
	ld	de, ___str_68
	call	_Choose
	ld	c, a
	ld	a, $09
	sub	a, c
	jp	C, .l00112
	ld	b, $00
	ld	hl, .l00119
	add	hl, bc
	add	hl, bc
	add	hl, bc
	jp	hl
.l00119:
	jp	.l00101
	jp	.l00102
	jp	.l00103
	jp	.l00104
	jp	.l00105
	jp	.l00106
	jp	.l00107
	jp	.l00108
	jp	.l00109
	jp	.l00110
;src/editor/editor.c:1384: case 0: OpenFile(); break;
.l00101:
	jp	_OpenFile
	jp	.l00112
;src/editor/editor.c:1385: case 1: SaveFile(0); break;
.l00102:
	xor	a, a
	jp	_SaveFile
	jp	.l00112
;src/editor/editor.c:1386: case 2: SaveFile(1); break;
.l00103:
	ld	a, $01
	jp	_SaveFile
	jp	.l00112
;src/editor/editor.c:1387: case 3: NewFile(); break;
.l00104:
	jp	_NewFile
	jp	.l00112
;src/editor/editor.c:1388: case 4: UndoRedo(0); break;
.l00105:
	xor	a, a
	jp	_UndoRedo
	jp	.l00112
;src/editor/editor.c:1389: case 5: UndoRedo(1); break;
.l00106:
	ld	a, $01
	jp	_UndoRedo
	jp	.l00112
;src/editor/editor.c:1390: case 6: ToggleFont(); break;
.l00107:
	jp	_ToggleFont
	jp	.l00112
;src/editor/editor.c:1391: case 7: ToggleWrap(); break;
.l00108:
	jp	_ToggleWrap
	jp	.l00112
;src/editor/editor.c:1392: case 8: ToggleBars(); break;
.l00109:
	jp	_ToggleBars
	jp	.l00112
;src/editor/editor.c:1393: case 9: ShowHelp(); break;
.l00110:
	jp	_ShowHelp
;src/editor/editor.c:1394: }
.l00112:
;src/editor/editor.c:1395: }
	ret
___str_68:
	DB "MENU"
	DB $00
;src/editor/editor.c:1398: static unsigned char HandleFileKey(unsigned char key, unsigned char mods) {
;	---------------------------------
; Function HandleFileKey
; ---------------------------------
_HandleFileKey:
	ld	c, a
;src/editor/editor.c:1399: if (key == KEY_MENU || key == KEY_ESCAPE) FileMenu();
	ld	a, c
	sub	a, $89
	jp	NZ,.l00187
	jp	.l00131
.l00187:
	ld	a, c
	sub	a, $1B
	jp	NZ,.l00188
	jp	.l00189
.l00188:
	jp	.l00132
.l00189:
.l00131:
	call	_FileMenu
	jp	.l00133
.l00132:
;src/editor/editor.c:1400: else if (key == KEY_F1) ShowHelp();
	ld	a, c
	sub	a, $90
	jp	NZ,.l00190
	jp	.l00191
.l00190:
	jp	.l00129
.l00191:
	call	_ShowHelp
	jp	.l00133
.l00129:
;src/editor/editor.c:1401: else if (key == KEY_F11) ToggleBars();
	ld	a, c
	sub	a, $9A
	jp	NZ,.l00192
	jp	.l00193
.l00192:
	jp	.l00126
.l00193:
	call	_ToggleBars
	jp	.l00133
.l00126:
;src/editor/editor.c:1402: else if ((mods & KB_MOD_ALT) && (key == 'z' || key == 'Z')) ToggleWrap();
	bit	4, e
	jp	NZ,.l00194
	jp	.l00121
.l00194:
	ld	a, c
	sub	a, $7A
	jp	NZ,.l00195
	jp	.l00120
.l00195:
	ld	a, c
	sub	a, $5A
	jp	NZ,.l00196
	jp	.l00197
.l00196:
	jp	.l00121
.l00197:
.l00120:
	call	_ToggleWrap
	jp	.l00133
.l00121:
;src/editor/editor.c:1403: else if (!(mods & KB_MOD_CTRL)) return 0;
	bit	5, e
	jp	NZ,.l00198
	jp	.l00199
.l00198:
	jp	.l00118
.l00199:
	xor	a, a
	jp	.l00135
.l00118:
;src/editor/editor.c:1404: else if (key == 'o' || key == 'O') OpenFile();
	ld	a, c
	sub	a, $6F
	jp	NZ,.l00200
	jp	.l00113
.l00200:
	ld	a, c
	sub	a, $4F
	jp	NZ,.l00201
	jp	.l00202
.l00201:
	jp	.l00114
.l00202:
.l00113:
	call	_OpenFile
	jp	.l00133
.l00114:
;src/editor/editor.c:1405: else if (key == 's' || key == 'S') SaveFile(0);
	ld	a, c
	sub	a, $73
	jp	NZ,.l00203
	jp	.l00109
.l00203:
	ld	a, c
	sub	a, $53
	jp	NZ,.l00204
	jp	.l00205
.l00204:
	jp	.l00110
.l00205:
.l00109:
	xor	a, a
	call	_SaveFile
	jp	.l00133
.l00110:
;src/editor/editor.c:1406: else if (key == 'n' || key == 'N') NewFile();
	ld	a, c
	sub	a, $6E
	jp	NZ,.l00206
	jp	.l00105
.l00206:
	ld	a, c
	sub	a, $4E
	jp	NZ,.l00207
	jp	.l00208
.l00207:
	jp	.l00106
.l00208:
.l00105:
	call	_NewFile
	jp	.l00133
.l00106:
;src/editor/editor.c:1407: else if (key == 'f' || key == 'F') ToggleFont();
	ld	a, c
	sub	a, $66
	jp	NZ,.l00209
	jp	.l00101
.l00209:
	ld	a, c
	sub	a, $46
	jp	NZ,.l00210
	jp	.l00211
.l00210:
	jp	.l00102
.l00211:
.l00101:
	call	_ToggleFont
	jp	.l00133
.l00102:
;src/editor/editor.c:1408: else return 0;
	xor	a, a
	jp	.l00135
.l00133:
;src/editor/editor.c:1409: dirty = 1;
	ld	hl, _dirty
	ld	[hl], $01
;src/editor/editor.c:1410: return 1;
	ld	a, $01
.l00135:
;src/editor/editor.c:1411: }
	ret
;src/editor/editor.c:1413: static void Render(void) {
;	---------------------------------
; Function Render
; ---------------------------------
_Render:
;src/editor/editor.c:1414: tb_find = cursor;
	ld	hl, _cursor
	ld	a, [hl]
	ld	hl, _tb_find
	ld	[hl], a
	ld	hl, _cursor + 1
	ld	a, [hl]
	ld	hl, _tb_find + 1
	ld	[hl], a
;src/editor/editor.c:1415: tb_Render(top);
	ld	hl, _top
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	jp	_tb_Render
.l00101:
;src/editor/editor.c:1416: }
	ret
;src/editor/editor.c:1423: static unsigned char CharWidth(unsigned char c) {
;	---------------------------------
; Function CharWidth
; ---------------------------------
_CharWidth:
	ld	c, a
;src/editor/editor.c:1424: return head_width ? head_width : font_widths[c < ' ' ? ' ' : c]; // control characters are drawn as spaces
	ld	hl, _head_width
	ld	a, [hl]
	or	a, a
	jp	Z, .l00103
	ld	a, [hl]
	jp	.l00104
.l00103:
	ld	de, _font_widths+0
	ld	a, c
	sub	a, $20
	jp	NC, .l00105
	ld	hl, $0020
	jp	.l00106
.l00105:
	ld	l, c
;	spillPairReg hl
;	spillPairReg hl
	ld	h, $00
;	spillPairReg hl
;	spillPairReg hl
.l00106:
	add	hl, de
	ld	a, [hl]
.l00104:
.l00101:
;src/editor/editor.c:1425: }
	ret
;src/editor/editor.c:1428: static void LineHeading(unsigned int start) {
;	---------------------------------
; Function LineHeading
; ---------------------------------
_LineHeading:
	add	sp, -8
	ld	hl, sp+4
	ld	[hl], e
	inc	hl
	ld	[hl], d
;src/editor/editor.c:1429: unsigned int pos = start, length = tb_Length();
	call	_tb_Length
	pop	hl
	push	bc
;src/editor/editor.c:1430: head_width = 0;
	ld	hl, _head_width
	ld	[hl], $00
;src/editor/editor.c:1431: if (tb_lang != LANG_MD) return;
	ld	hl, _tb_lang
	ld	a, [hl]
	dec	a
	jp	NZ,.l00156
	jp	.l00119
.l00156:
	jp	.l00113
;src/editor/editor.c:1432: while (pos < length && pos - start < 7 && tb_GetChar(pos) == '#') ++pos;
.l00119:
	ld	hl, sp+4
	ld	a, [hl]
	inc	hl
	inc	hl
	ld	[hl], a
	dec	hl
	ld	a, [hl]
	inc	hl
	inc	hl
	ld	[hl], a
.l00105:
	ld	hl, sp+7
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, sp+4
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	ld	a, e
	sub	a, l
	ld	e, a
	ld	a, d
	sbc	a, h
	ld	hl, sp+3
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
	jp	NC, .l00107
	ld	hl, sp+2
	ld	a, [hl]
	sub	a, $07
	inc	hl
	ld	a, [hl]
	sbc	a, $00
	jp	NC, .l00107
	ld	hl, sp+6
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_tb_GetChar
	sub	a, $23
	jp	NZ,.l00157
	jp	.l00158
.l00157:
	jp	.l00107
.l00158:
	ld	hl, sp+6
	inc	[hl]
	jp	NZ, .l00159
	inc	hl
	inc	[hl]
.l00159:
	jp	.l00105
.l00107:
;src/editor/editor.c:1433: if (pos == start || pos - start > 4 || pos == length || tb_GetChar(pos) != ' ') return;
	ld	hl, sp+4
	ld	a, [hl]
	inc	hl
	inc	hl
	sub	a, [hl]
	jp	NZ,.l00160
	dec	hl
	ld	a, [hl]
	inc	hl
	inc	hl
	sub	a, [hl]
	jp	NZ,.l00160
	jp	.l00108
.l00160:
	ld	hl, sp+2
	ld	a, $04
	sub	a, [hl]
	inc	hl
	ld	a, $00
	sbc	a, [hl]
	jp	C, .l00108
	ld	hl, sp+0
	ld	a, [hl]
	ld	hl, sp+6
	sub	a, [hl]
	jp	NZ,.l00161
	ld	hl, sp+1
	ld	a, [hl]
	ld	hl, sp+7
	sub	a, [hl]
	jp	NZ,.l00161
	jp	.l00108
.l00161:
	ld	hl, sp+6
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_tb_GetChar
	sub	a, $20
	jp	NZ,.l00162
	jp	.l00109
.l00162:
.l00108:
	jp	.l00113
.l00109:
;src/editor/editor.c:1434: head_width = 9 - (unsigned char)(pos - start);
	ld	hl, sp+6
	ld	a, [hl]
	inc	hl
	ld	[hl], a
	ld	hl, sp+4
	ld	c, [hl]
	ld	hl, sp+7
	ld	a, [hl]
	sub	a, c
	ld	[hl], a
	ld	a, $09
	sub	a, [hl]
	ld	hl, _head_width
	ld	[hl], a
.l00113:
;src/editor/editor.c:1435: }
	add	sp, 8
	ret
;src/editor/editor.c:1439: static unsigned char ScrollX(void) {
;	---------------------------------
; Function ScrollX
; ---------------------------------
_ScrollX:
	add	sp, -9
;src/editor/editor.c:1440: unsigned char row = tb_found_row, count;
	ld	hl, _tb_found_row
	ld	a, [hl]
	ld	hl, sp+0
	ld	[hl], a
;src/editor/editor.c:1441: unsigned int start = row == 0xFF ? tb_LineStart(cursor) : tb_row_starts[row];
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
;src/editor/editor.c:1442: unsigned int col = cursor - start, length = tb_Length(), pos, x = 0, left;
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
;src/editor/editor.c:1443: unsigned char c, keep = KEEP_LEFT;
	inc	hl
	ld	[hl], $28
;src/editor/editor.c:1444: if (col < tb_left) keep = KEEP_RIGHT;
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
;src/editor/editor.c:1445: else if (row != 0xFF) { // its char is drawn, or it's the line's end right of its last one
	ld	hl, sp+8
	ld	e, [hl]
	bit	0, e
	jp	NZ, .l00111
;src/editor/editor.c:1446: count = tb_row_counts[row];
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
;src/editor/editor.c:1447: if (col - tb_left < count) return 0;
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
;src/editor/editor.c:1448: if (col - tb_left == count && cursor == LineEnd(row) && RenderCursorX(count) < TB_WIDTH - 1) return 0;
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
;src/editor/editor.c:1450: LineHeading(start);
	push	bc
	ld	hl, sp+3
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_LineHeading
	pop	bc
;src/editor/editor.c:1451: if (keep == KEEP_LEFT) { // more if the line ends sooner, so the screen isn't left empty
	ld	hl, sp+5
	ld	a, [hl]
	sub	a, $28
	jp	NZ,.l00227
	jp	.l00228
.l00227:
	jp	.l00116
.l00228:
;src/editor/editor.c:1452: for (pos = cursor, x = 0; pos < length && (c = tb_GetChar(pos)) != ASCII_LF && x <= TB_WIDTH; ++pos) x += CharWidth(c);
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
	call	_CharWidth
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
;src/editor/editor.c:1453: if (x < TB_WIDTH - 1 - KEEP_LEFT) keep = TB_WIDTH - 1 - x;
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
;src/editor/editor.c:1455: for (left = col, x = 0; left; --left) {
	xor	a, a
	ld	hl, sp+3
	ld	[hl], a
	inc	hl
	ld	[hl], a
.l00128:
	ld	a, b
	or	a, c
	jp	Z, .l00119
;src/editor/editor.c:1456: if ((x += CharWidth(tb_GetChar(start + left - 1))) > keep) break;
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
	call	_CharWidth
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
;src/editor/editor.c:1455: for (left = col, x = 0; left; --left) {
	dec	bc
	jp	.l00128
.l00119:
;src/editor/editor.c:1458: if (left == tb_left) return 0;
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
;src/editor/editor.c:1459: tb_left = left;
	ld	hl, _tb_left
	ld	[hl], c
	inc	hl
	ld	[hl], b
;src/editor/editor.c:1460: return 1;
	ld	a, $01
.l00130:
;src/editor/editor.c:1461: }
	add	sp, 9
	ret
;src/editor/editor.c:1464: static void Refresh(void) {
;	---------------------------------
; Function Refresh
; ---------------------------------
_Refresh:
	add	sp, -3
;src/editor/editor.c:1467: if (top > tb_Length()) top = tb_Length();
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
;src/editor/editor.c:1468: top = tb_RowStart(top); // wrapping may have changed
	ld	hl, _top
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_tb_RowStart
	ld	hl, _top
	ld	[hl], c
	inc	hl
	ld	[hl], b
;src/editor/editor.c:1469: Render();
	call	_Render
;src/editor/editor.c:1470: if (tb_found_row == 0xFF) {
	ld	hl, _tb_found_row
	ld	a, [hl]
	inc	a
	jp	NZ,.l00209
	jp	.l00210
.l00209:
	jp	.l00119
.l00210:
;src/editor/editor.c:1471: row = tb_RowStart(cursor);
	ld	hl, _cursor
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_tb_RowStart
;src/editor/editor.c:1472: if (cursor < top) {
	ld	de, _cursor
	ld	hl, _top
	ld	a, [de]
	inc	de
	sub	a, [hl]
	inc	hl
	ld	a, [de]
	sbc	a, [hl]
	jp	NC, .l00116
;src/editor/editor.c:1473: if (top && row == tb_RowStart(top - 1)) ScrollRing(0); // one row up
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
;src/editor/editor.c:1474: top = row;
	ld	hl, _top
	ld	[hl], c
	inc	hl
	ld	[hl], b
	jp	.l00117
.l00116:
;src/editor/editor.c:1477: bottom = tb_row_starts[tb_rows];
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
;src/editor/editor.c:1478: for (i = tb_rows; i; --i) {
	ld	hl, _tb_rows
	ld	a, [hl]
	ld	hl, sp+2
	ld	[hl], a
.l00124:
	ld	hl, sp+2
	ld	a, [hl]
	or	a, a
	jp	Z, .l00108
;src/editor/editor.c:1479: top = tb_NextRow(top);
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
;src/editor/editor.c:1480: if (bottom == row) break;
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
;src/editor/editor.c:1481: bottom = tb_NextRow(bottom);
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
;src/editor/editor.c:1478: for (i = tb_rows; i; --i) {
	ld	hl, sp+2
	dec	[hl]
	jp	.l00124
.l00108:
;src/editor/editor.c:1483: if (!i) { // the cursor's row goes at the bottom
	ld	hl, sp+2
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00113
;src/editor/editor.c:1484: top = row;
	ld	hl, _top
	ld	[hl], c
	inc	hl
	ld	[hl], b
;src/editor/editor.c:1485: for (i = tb_rows - 1; i && top; --i) top = tb_RowStart(top - 1);
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
;src/editor/editor.c:1487: else if (i == tb_rows) ScrollRing(1); // one row down
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
;src/editor/editor.c:1489: Render();
	call	_Render
.l00119:
;src/editor/editor.c:1491: if (tb_nowrap && ScrollX()) Render();
	ld	hl, _tb_nowrap
	ld	a, [hl]
	or	a, a
	jp	Z, .l00121
	call	_ScrollX
	or	a, a
	jp	Z, .l00121
	call	_Render
.l00121:
;src/editor/editor.c:1492: Draw();
	call	_Draw
;src/editor/editor.c:1493: redraw = 0;
	ld	hl, _redraw
	ld	[hl], $00
;src/editor/editor.c:1494: moved = 0;
	ld	hl, _moved
	ld	[hl], $00
;src/editor/editor.c:1495: PlaceCursor();
	call	_PlaceCursor
.l00130:
;src/editor/editor.c:1496: }
	add	sp, 3
	ret
;src/editor/editor.c:1498: void Editor(void) {
;	---------------------------------
; Function Editor
; ---------------------------------
_Editor::
;src/editor/editor.c:1502: EditorSetup();
	call	_EditorSetup
;src/editor/editor.c:1503: for (key = 0; key < BG_MAP_ROWS + WIN_MAP_ROWS; ++key) map_blocks[key] = key < TB_ROWS ? key : 0xFF; // set by RenderSetup
	ld	c, $00
.l00166:
	ld	hl, _map_blocks
	ld	b, $00
	add	hl, bc
	ld	a, c
	sub	a, $12
	jp	NC, .l00170
	ld	e, c
	ld	d, $00
	jp	.l00171
.l00170:
	ld	de, $00FF
.l00171:
	ld	[hl], e
	inc	c
	ld	a, c
	sub	a, $27
	jp	C, .l00166
;src/editor/editor.c:1504: everdrive = sd_Detect();
	call	_sd_Detect
	ld	hl, _everdrive
	ld	[hl], a
;src/editor/editor.c:1505: idle_frames = 0;
	ld	hl, _idle_frames
	ld	[hl], $00
;src/editor/editor.c:1506: normalized = 0;
	ld	hl, _normalized
	ld	[hl], $00
;src/editor/editor.c:1507: cursor = 0;
	xor	a, a
	ld	hl, _cursor
	ld	[hl], a
	inc	hl
	ld	[hl], a
;src/editor/editor.c:1508: top = 0;
	xor	a, a
	ld	hl, _top
	ld	[hl], a
	inc	hl
	ld	[hl], a
;src/editor/editor.c:1509: selecting = 0;
	ld	hl, _selecting
	ld	[hl], $00
;src/editor/editor.c:1510: want_x = 0;
	ld	hl, _want_x
	ld	[hl], $00
;src/editor/editor.c:1511: keep_x = 0;
	ld	hl, _keep_x
	ld	[hl], $00
;src/editor/editor.c:1512: moved = 0;
	ld	hl, _moved
	ld	[hl], $00
;src/editor/editor.c:1513: redraw = 0;
	ld	hl, _redraw
	ld	[hl], $00
;src/editor/editor.c:1514: ring_top = 0;
	ld	hl, _ring_top
	ld	[hl], $00
;src/editor/editor.c:1515: ring_pos = 0;
	ld	hl, _ring_pos
	ld	[hl], $00
;src/editor/editor.c:1516: counted_pos = 0;
	xor	a, a
	ld	hl, _counted_pos
	ld	[hl], a
	inc	hl
	ld	[hl], a
;src/editor/editor.c:1517: counted_lines = 0;
	xor	a, a
	ld	hl, _counted_lines
	ld	[hl], a
	inc	hl
	ld	[hl], a
;src/editor/editor.c:1518: bars_changed = 0;
	ld	hl, _bars_changed
	ld	[hl], $00
;src/editor/editor.c:1519: edited = 0;
	ld	hl, _edited
	ld	[hl], $00
;src/editor/editor.c:1520: pad_timer = 0;
	ld	hl, _pad_timer
	ld	[hl], $00
;src/editor/editor.c:1521: modified = 0;
	ld	hl, _modified
	ld	[hl], $00
;src/editor/editor.c:1522: font = FONT_FIXED; // until SettingsLoad
	ld	hl, _font
	ld	[hl], $02
;src/editor/editor.c:1523: file_name[0] = 0;
	ld	hl, _file_name
	ld	[hl], $00
;src/editor/editor.c:1524: file_dir[0] = 0;
	ld	hl, _file_dir
	ld	[hl], $00
;src/editor/editor.c:1525: fs_crlf = 0;
	ld	hl, _fs_crlf
	ld	[hl], $00
;src/editor/editor.c:1526: osk_shown = 0;
	ld	hl, _osk_shown
	ld	[hl], $00
;src/editor/editor.c:1527: osk_layer = OSK_LOWER;
	ld	hl, _osk_layer
	ld	[hl], $00
;src/editor/editor.c:1528: osk_x = 0;
	ld	hl, _osk_x
	ld	[hl], $00
;src/editor/editor.c:1529: osk_y = 0;
	ld	hl, _osk_y
	ld	[hl], $00
;src/editor/editor.c:1530: bars_on = 1;
	ld	hl, _bars_on
	ld	[hl], $01
;src/editor/editor.c:1531: tb_nowrap = 0;
	ld	hl, _tb_nowrap
	ld	[hl], $00
;src/editor/editor.c:1532: tb_left = 0;
	xor	a, a
	ld	hl, _tb_left
	ld	[hl], a
	inc	hl
	ld	[hl], a
;src/editor/editor.c:1533: tb_lang = LANG_PLAIN;
	ld	hl, _tb_lang
	ld	[hl], $00
;src/editor/editor.c:1534: render_text = 1;
	ld	hl, _render_text
	ld	[hl], $01
;src/editor/editor.c:1535: SettingsLoad();
	call	_SettingsLoad
;src/editor/editor.c:1536: SetLang();
	call	_SetLang
;src/editor/editor.c:1537: UndoClear(modified);
	ld	hl, _modified
	ld	a, [hl]
	call	_UndoClear
;src/editor/editor.c:1538: saved_modified = modified;
	ld	hl, _modified
	ld	a, [hl]
	ld	hl, _saved_modified
	ld	[hl], a
;src/editor/editor.c:1539: SetFont(font);
	ld	hl, _font
	ld	a, [hl]
	call	_SetFont
;src/editor/editor.c:1540: SetRows();
	call	_SetRows
;src/editor/editor.c:1541: Refresh();
	call	_Refresh
;src/editor/editor.c:1543: while (1) {
.l00164:
;src/editor/editor.c:1544: if (modified != saved_modified) {
	ld	hl, _modified
	ld	a, [hl]
	ld	hl, _saved_modified
	sub	a, [hl]
	jp	NZ,.l00353
	jp	.l00103
.l00353:
;src/editor/editor.c:1545: saved_modified = modified;
	ld	hl, _modified
	ld	a, [hl]
	ld	hl, _saved_modified
	ld	[hl], a
;src/editor/editor.c:1546: SettingsSave();
	call	_SettingsSave
.l00103:
;src/editor/editor.c:1548: if (bars_changed) { // status bar follows the cursor
	ld	hl, _bars_changed
	ld	a, [hl]
	or	a, a
	jp	Z, .l00107
;src/editor/editor.c:1549: bars_changed = 0;
	ld	[hl], $00
;src/editor/editor.c:1550: if (bars) Draw();
	ld	hl, _bars
	ld	a, [hl]
	or	a, a
	jp	Z, .l00107
	call	_Draw
.l00107:
;src/editor/editor.c:1552: WaitFrame();
	call	_WaitFrame
;src/editor/editor.c:1553: while ((key = (unsigned char)(event = KBPopEvent()))) {
.l00117:
	call	_KBPopEvent
	ld	e, c
	ld	d, b
	ld	a, c
	ld	c, a
	or	a, a
	jp	Z, .l00119
;src/editor/editor.c:1554: if (!HandleFileKey(key, (unsigned char)(event >> 8))) HandleKey(key, (unsigned char)(event >> 8));
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
	jp	NZ, .l00109
	ld	e, l
	ld	a, c
	call	_HandleKey
.l00109:
;src/editor/editor.c:1555: if (dirty || edited) break; // text changed, rows need rendering before more keys
	ld	hl, _dirty
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00119
	ld	hl, _edited
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00119
;src/editor/editor.c:1556: if (moved) { // keeps tb_found_row current for the next key
	ld	hl, _moved
	ld	a, [hl]
	or	a, a
	jp	Z, .l00117
;src/editor/editor.c:1557: if (!PlaceCursor()) dirty = 1;
	call	_PlaceCursor
	or	a, a
	jp	NZ, .l00114
	ld	hl, _dirty
	ld	[hl], $01
.l00114:
;src/editor/editor.c:1558: moved = 0;
	ld	hl, _moved
	ld	[hl], $00
	jp	.l00117
.l00119:
;src/editor/editor.c:1561: if ((key = PadKey())) {
	call	_PadKey
	ld	c, a
	or	a, a
	jp	Z, .l00123
;src/editor/editor.c:1562: if (!HandleFileKey(key, 0)) HandleKey(key, 0);
	push	bc
	ld	e, $00
	ld	a, c
	call	_HandleFileKey
	pop	bc
	or	a, a
	jp	NZ, .l00123
	ld	e, $00
	ld	a, c
	call	_HandleKey
.l00123:
;src/editor/editor.c:1564: if (dirty || edited || redraw || moved) idle_frames = 0;
	ld	hl, _dirty
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00124
	ld	hl, _edited
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00124
	ld	hl, _redraw
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00124
	ld	hl, _moved
	ld	a, [hl]
	or	a, a
	jp	Z, .l00125
.l00124:
	ld	hl, _idle_frames
	ld	[hl], $00
.l00125:
;src/editor/editor.c:1565: if (dirty) {
	ld	hl, _dirty
	ld	a, [hl]
	or	a, a
	jp	Z, .l00130
;src/editor/editor.c:1566: Refresh();
	call	_Refresh
;src/editor/editor.c:1567: dirty = 0;
	ld	hl, _dirty
	ld	[hl], $00
;src/editor/editor.c:1568: edited = 0;
	ld	hl, _edited
	ld	[hl], $00
;src/editor/editor.c:1569: normalized = 0;
	ld	hl, _normalized
	ld	[hl], $00
;src/editor/editor.c:1570: continue;
	jp	.l00164
.l00130:
;src/editor/editor.c:1572: if (edited) {
	ld	hl, _edited
	ld	a, [hl]
	or	a, a
	jp	Z, .l00145
;src/editor/editor.c:1573: edited = 0;
	ld	[hl], $00
;src/editor/editor.c:1574: normalized = 0;
	ld	hl, _normalized
	ld	[hl], $00
;src/editor/editor.c:1575: RenderAfterEdit();
	call	_RenderAfterEdit
;src/editor/editor.c:1576: if (!PlaceCursor()) {
	call	_PlaceCursor
	or	a, a
	jp	NZ, .l00145
;src/editor/editor.c:1577: if (cursor >= tb_row_starts[tb_rows] && tb_RowStart(cursor) == tb_row_starts[tb_rows]) ScrollDown();
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
	jp	C, .l00137
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
	jp	NZ,.l00354
	ld	a, h
	sub	a, b
	jp	NZ,.l00354
	jp	.l00355
.l00354:
	jp	.l00137
.l00355:
	call	_ScrollDown
	jp	.l00138
.l00137:
;src/editor/editor.c:1578: else if (top && cursor < top && tb_RowStart(cursor) == tb_RowStart(top - 1)) ScrollUp(tb_RowStart(cursor));
	ld	hl, _top + 1
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	jp	Z, .l00132
	ld	de, _cursor
	ld	a, [de]
	inc	de
	sub	a, [hl]
	inc	hl
	ld	a, [de]
	sbc	a, [hl]
	jp	NC, .l00132
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
	jp	NZ,.l00356
	ld	a, d
	sub	a, b
	jp	NZ,.l00356
	jp	.l00357
.l00356:
	jp	.l00132
.l00357:
	ld	hl, _cursor
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_tb_RowStart
	ld	e, c
	ld	d, b
	call	_ScrollUp
	jp	.l00138
.l00132:
;src/editor/editor.c:1580: Refresh();
	call	_Refresh
;src/editor/editor.c:1581: continue;
	jp	.l00164
.l00138:
;src/editor/editor.c:1583: if (!PlaceCursor()) { // off the side
	call	_PlaceCursor
	or	a, a
	jp	NZ, .l00145
;src/editor/editor.c:1584: Refresh();
	call	_Refresh
;src/editor/editor.c:1585: continue;
	jp	.l00164
.l00145:
;src/editor/editor.c:1589: if (redraw) {
	ld	hl, _redraw
	ld	a, [hl]
	or	a, a
	jp	Z, .l00147
;src/editor/editor.c:1590: Draw();
	call	_Draw
;src/editor/editor.c:1591: redraw = 0;
	ld	hl, _redraw
	ld	[hl], $00
.l00147:
;src/editor/editor.c:1593: if (moved) {
	ld	hl, _moved
	ld	a, [hl]
	or	a, a
	jp	Z, .l00151
;src/editor/editor.c:1594: moved = 0;
	ld	[hl], $00
;src/editor/editor.c:1595: if (!PlaceCursor()) Refresh();
	call	_PlaceCursor
	or	a, a
	jp	NZ, .l00164
	call	_Refresh
;src/editor/editor.c:1596: continue;
	jp	.l00164
.l00151:
;src/editor/editor.c:1598: if (idle_frames < NORMALIZE_DELAY) ++idle_frames;
	ld	hl, _idle_frames
	ld	a, [hl]
	sub	a, $1E
	jp	NC, .l00156
	inc	[hl]
	jp	.l00157
.l00156:
;src/editor/editor.c:1599: else if (!everdrive && !normalized) normalized = tb_NormalizeStep(); // keeps the .sav readable as text
	ld	hl, _everdrive
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00157
	ld	hl, _normalized
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00157
	call	_tb_NormalizeStep
	ld	hl, _normalized
	ld	[hl], a
.l00157:
;src/editor/editor.c:1600: if (++blink_timer == CURSOR_BLINK) EditorShowCursor(0);
	ld	hl, _blink_timer
	inc	[hl]
	ld	a, [hl]
	sub	a, $1E
	jp	NZ,.l00358
	jp	.l00359
.l00358:
	jp	.l00161
.l00359:
	xor	a, a
	call	_EditorShowCursor
	jp	.l00164
.l00161:
;src/editor/editor.c:1601: else if (blink_timer == CURSOR_BLINK + CURSOR_BLINK) {
	ld	hl, _blink_timer
	ld	a, [hl]
	sub	a, $3C
	jp	NZ,.l00360
	jp	.l00361
.l00360:
	jp	.l00164
.l00361:
;src/editor/editor.c:1602: EditorShowCursor(1);
	ld	a, $01
	call	_EditorShowCursor
;src/editor/editor.c:1603: blink_timer = 0;
	ld	hl, _blink_timer
	ld	[hl], $00
	jp	.l00164
.l00168:
;src/editor/editor.c:1606: }
	ret
	SECTION FRAGMENT "src/editor/editor.c_CODE",ROMX
	SECTION FRAGMENT "_INITIALIZER",ROM0
	SECTION FRAGMENT "_CABS (ABS)",ROM0
