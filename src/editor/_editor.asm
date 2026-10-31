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
	EXPORT _tb_NormalizeStep
	EXPORT _tb_Delete
	EXPORT _tb_Insert
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
	EXPORT _ring_top
	EXPORT _redraw
	EXPORT _moved
	EXPORT _keep_x
	EXPORT _want_x
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
;src/editor/editor.c:68: static unsigned char FindRow(unsigned int pos) {
;	---------------------------------
; Function FindRow
; ---------------------------------
_FindRow:
	dec	sp
	dec	sp
	ld	c, e
	ld	b, d
;src/editor/editor.c:70: for (row = 0; row < tb_rows; ++row) {
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
;src/editor/editor.c:71: if (pos < tb_row_starts[row]) return 0xFF;
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
;src/editor/editor.c:72: if (pos < tb_row_starts[row + 1]) return row;
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
;src/editor/editor.c:70: for (row = 0; row < tb_rows; ++row) {
	ld	hl, sp+1
	inc	[hl]
	ld	a, [hl]
	dec	hl
	ld	[hl], a
	jp	.l00107
.l00105:
;src/editor/editor.c:74: return pos == tb_Length() ? tb_end_row : 0xFF;
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
;src/editor/editor.c:75: }
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
;src/editor/editor.c:78: static unsigned char PlaceCursor(void) {
;	---------------------------------
; Function PlaceCursor
; ---------------------------------
_PlaceCursor:
	add	sp, -4
;src/editor/editor.c:79: unsigned char row = FindRow(cursor);
	ld	hl, _cursor
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_FindRow
	ld	c, a
;src/editor/editor.c:81: if (row == 0xFF) return 0;
	ld	a, c
	inc	a
	jp	NZ,.l00124
	jp	.l00125
.l00124:
	jp	.l00102
.l00125:
	xor	a, a
	jp	.l00107
.l00102:
;src/editor/editor.c:82: col = cursor - tb_row_starts[row];
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
;src/editor/editor.c:83: if (col > tb_row_counts[row]) col = tb_row_counts[row]; // hanging spaces
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
;src/editor/editor.c:84: tb_found_row = row;
	ld	hl, _tb_found_row
	ld	[hl], c
;src/editor/editor.c:85: tb_found_col = (unsigned char)col;
	ld	hl, _tb_found_col
	ld	[hl], e
;src/editor/editor.c:86: if (!keep_x) want_x = RenderCursorX(tb_found_col);
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
;src/editor/editor.c:87: keep_x = 0;
	ld	hl, _keep_x
	ld	[hl], $00
;src/editor/editor.c:88: blink_timer = 0;
	ld	hl, _blink_timer
	ld	[hl], $00
;src/editor/editor.c:89: EditorShowCursor(1);
	ld	a, $01
	call	_EditorShowCursor
;src/editor/editor.c:90: return 1;
	ld	a, $01
.l00107:
;src/editor/editor.c:91: }
	add	sp, 4
	ret
;src/editor/editor.c:94: static unsigned int PosAtX(unsigned char row, unsigned char x) {
;	---------------------------------
; Function PosAtX
; ---------------------------------
_PosAtX:
	add	sp, -10
	ld	hl, sp+6
	ld	[hl], a
	dec	hl
	ld	[hl], e
;src/editor/editor.c:95: char* chars = RowAddress(row);
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
;src/editor/editor.c:96: unsigned char count = tb_row_counts[row], col = 0, width;
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
;src/editor/editor.c:98: while (col < count) {
	ld	hl, sp+7
	ld	[hl], $00
.l00103:
	ld	hl, sp+7
	ld	a, [hl]
	ld	hl, sp+4
	sub	a, [hl]
	jp	NC, .l00105
;src/editor/editor.c:99: width = font_widths[(unsigned char)chars[col]];
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
;src/editor/editor.c:100: if (x < ((width + 1) >> 1)) break;
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
;src/editor/editor.c:101: x = x < width ? 0 : x - width;
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
;src/editor/editor.c:102: ++col;
	inc	hl
	inc	hl
	inc	[hl]
	jp	.l00103
.l00105:
;src/editor/editor.c:104: pos = tb_row_starts[row] + col;
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
;src/editor/editor.c:105: if (col == count && pos == tb_row_starts[row + 1] && tb_end_row != row) --pos; // stay on wrapped row
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
;src/editor/editor.c:106: return pos;
	ld	hl, sp+8
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
.l00110:
;src/editor/editor.c:107: }
	add	sp, 10
	ret
;src/editor/editor.c:111: static void StageSplits(void) {
;	---------------------------------
; Function StageSplits
; ---------------------------------
_StageSplits:
	add	sp, -5
;src/editor/editor.c:112: unsigned char row, block, mode, current = 0xFF, shared = 0xFF, count = 0;
	ld	e, $FF
	ld	hl, sp+0
	ld	[hl], $FF
	ld	c, $00
;src/editor/editor.c:113: for (row = 0; row < TB_ROWS; ++row) {
	ld	hl, sp+4
	ld	[hl], $00
.l00116:
;src/editor/editor.c:114: block = render_block_top + row;
	ld	hl, _render_block_top
	ld	a, [hl]
	ld	hl, sp+4
	add	a, [hl]
	ld	b, a
;src/editor/editor.c:115: if (block >= TB_ROWS) block -= TB_ROWS;
	ld	a, b
	sub	a, $12
	jp	C, .l00102
	ld	a, b
	add	a, $EE
	ld	b, a
.l00102:
;src/editor/editor.c:116: if ((block >= 6 && block < 9) || block >= 15) {
	ld	a, b
	sub	a, $06
	ld	a, $00
	rla
	ld	d, a
	bit	0, d
	jp	NZ, .l00108
	ld	a, b
	sub	a, $09
	jp	C, .l00105
.l00108:
	ld	a, b
	sub	a, $0F
	jp	C, .l00106
.l00105:
;src/editor/editor.c:117: if (shared == 0xFF) shared = row;
	ld	hl, sp+0
	ld	a, [hl]
	inc	a
	jp	NZ,.l00162
	jp	.l00163
.l00162:
	jp	.l00114
.l00163:
	ld	hl, sp+4
	ld	a, [hl]
	ld	hl, sp+0
	ld	[hl], a
;src/editor/editor.c:118: continue;
	jp	.l00114
.l00106:
;src/editor/editor.c:120: mode = block < 6 ? LCDC_TILES_8000 : 0;
	ld	a, d
	or	a, a
	jp	Z, .l00119
	ld	a, $10
	ld	b, $00
	jp	.l00120
.l00119:
	xor	a, a
	ld	b, a
.l00120:
	ld	hl, sp+1
	ld	[hl], a
;src/editor/editor.c:121: if (current == 0xFF) render_pending_top_mode = mode;
	ld	a, e
	inc	a
	jp	NZ,.l00164
	jp	.l00165
.l00164:
	jp	.l00112
.l00165:
	ld	a, [hl]
	ld	hl, _render_pending_top_mode
	ld	[hl], a
	jp	.l00113
.l00112:
;src/editor/editor.c:122: else if (mode != current) {
	ld	a, e
	ld	hl, sp+1
	sub	a, [hl]
	jp	NZ,.l00166
	jp	.l00113
.l00166:
;src/editor/editor.c:123: render_pending_splits[count++] = ((shared + row - 1) >> 1) << 3;
	ld	e, c
	inc	c
	ld	d, $00
	ld	hl, _render_pending_splits
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+4
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+3
	ld	[hl], a
	ld	hl, sp+0
	ld	a, [hl]
	ld	b, $00
	ld	hl, sp+4
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
	ld	hl, sp+2
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	ld	[hl], b
;src/editor/editor.c:124: render_pending_splits[count++] = mode;
	ld	a, c
	inc	c
	add	a, LOW(_render_pending_splits)
	ld	e, a
	ld	a, $00
	adc	a, HIGH(_render_pending_splits)
	ld	d, a
	ld	hl, sp+1
	ld	a, [hl]
	ld	[de], a
.l00113:
;src/editor/editor.c:126: current = mode;
	ld	hl, sp+1
	ld	e, [hl]
;src/editor/editor.c:127: shared = 0xFF;
	dec	hl
	ld	[hl], $FF
.l00114:
;src/editor/editor.c:113: for (row = 0; row < TB_ROWS; ++row) {
	ld	hl, sp+4
	inc	[hl]
	ld	a, [hl]
	sub	a, $12
	jp	C, .l00116
;src/editor/editor.c:129: render_pending_split_count = count >> 1;
	ld	a, c
	srl	a
	ld	hl, _render_pending_split_count
	ld	[hl], a
.l00117:
;src/editor/editor.c:130: }
	add	sp, 5
	ret
;src/editor/editor.c:133: static void ScrollRing(unsigned char down) {
;	---------------------------------
; Function ScrollRing
; ---------------------------------
_ScrollRing:
	ld	c, a
;src/editor/editor.c:135: render_pending = 0;
	ld	hl, _render_pending
	ld	[hl], $00
;src/editor/editor.c:139: ring_top = (ring_top + 1) & (BG_MAP_ROWS - 1);
	ld	hl, _ring_top
	ld	e, [hl]
;src/editor/editor.c:136: if (down) {
	ld	a, c
	or	a, a
	jp	Z, .l00102
;src/editor/editor.c:137: block = render_block_top;
	ld	hl, _render_block_top
	ld	l, [hl]
;	spillPairReg hl
;	spillPairReg hl
;src/editor/editor.c:138: render_block_top = block == TB_ROWS - 1 ? 0 : block + 1;
	ld	a, l
	sub	a, $11
	jp	NZ,.l00125
	jp	.l00126
.l00125:
	jp	.l00106
.l00126:
	ld	bc, $0000
	jp	.l00107
.l00106:
	ld	c, l
	inc	c
	ld	a, c
	rlca
	sbc	a, a
	ld	b, a
.l00107:
	ld	a, c
	ld	[_render_block_top], a
;src/editor/editor.c:139: ring_top = (ring_top + 1) & (BG_MAP_ROWS - 1);
	ld	a, e
	inc	a
	and	a, $1F
	ld	[_ring_top], a
;src/editor/editor.c:140: RenderSetMapRow((ring_top + TB_ROWS - 1) & (BG_MAP_ROWS - 1), block);
	ld	a, [_ring_top]
	ld	h, a
;	spillPairReg hl
;	spillPairReg hl
	ld	a, h
	add	a, $11
	and	a, $1F
	ld	c, a
	ld	e, l
	ld	a, c
	call	_RenderSetMapRow
	jp	.l00103
.l00102:
;src/editor/editor.c:142: render_block_top = render_block_top ? render_block_top - 1 : TB_ROWS - 1;
	ld	hl, _render_block_top
	ld	a, [hl]
	or	a, a
	jp	Z, .l00108
	ld	a, [hl]
	dec	a
	jp	.l00109
.l00108:
	ld	a, $11
.l00109:
	ld	hl, _render_block_top
	ld	[hl], a
;src/editor/editor.c:143: ring_top = (ring_top - 1) & (BG_MAP_ROWS - 1);
	ld	a, e
	dec	a
	and	a, $1F
	ld	hl, _ring_top
	ld	[hl], a
;src/editor/editor.c:144: RenderSetMapRow(ring_top, render_block_top);
	ld	hl, _render_block_top
	ld	e, [hl]
	ld	hl, _ring_top
	ld	a, [hl]
	call	_RenderSetMapRow
.l00103:
;src/editor/editor.c:146: StageSplits();
	call	_StageSplits
;src/editor/editor.c:147: render_pending_scy = ring_top << 3;
	ld	hl, _ring_top
	ld	a, [hl]
	add	a, a
	add	a, a
	add	a, a
	ld	hl, _render_pending_scy
	ld	[hl], a
;src/editor/editor.c:148: render_pending = 1;
	ld	hl, _render_pending
	ld	[hl], $01
.l00104:
;src/editor/editor.c:149: }
	ret
;src/editor/editor.c:152: static void ScrollDown(void) {
;	---------------------------------
; Function ScrollDown
; ---------------------------------
_ScrollDown:
;src/editor/editor.c:153: ScrollRing(1);
	ld	a, $01
	call	_ScrollRing
;src/editor/editor.c:154: tb_ScrollRows(1);
	ld	a, $01
	call	_tb_ScrollRows
;src/editor/editor.c:155: tb_RenderRows(tb_rows - 1, tb_rows);
	ld	hl, _tb_rows
	ld	c, [hl]
	dec	c
	ld	e, [hl]
	ld	a, c
	call	_tb_RenderRows
;src/editor/editor.c:156: top = tb_row_starts[0];
	ld	de, _tb_row_starts + 0
	ld	a, [de]
	ld	hl, _top
	ld	[hl], a
	inc	de
	ld	a, [de]
	inc	hl
	ld	[hl], a
;src/editor/editor.c:157: redraw = 1;
	ld	hl, _redraw
	ld	[hl], $01
.l00101:
;src/editor/editor.c:158: }
	ret
;src/editor/editor.c:161: static void ScrollUp(unsigned int new_top) {
;	---------------------------------
; Function ScrollUp
; ---------------------------------
_ScrollUp:
	ld	c, e
	ld	b, d
;src/editor/editor.c:162: ScrollRing(0);
	push	bc
	xor	a, a
	call	_ScrollRing
	pop	bc
;src/editor/editor.c:163: tb_ScrollRows(0);
	push	bc
	xor	a, a
	call	_tb_ScrollRows
	pop	bc
;src/editor/editor.c:164: tb_row_starts[0] = new_top;
	ld	hl, _tb_row_starts
	ld	[hl], c
	inc	hl
	ld	[hl], b
;src/editor/editor.c:165: tb_RenderRows(0, 1);
	push	bc
	ld	e, $01
	xor	a, a
	call	_tb_RenderRows
	pop	bc
;src/editor/editor.c:166: top = new_top;
	ld	hl, _top
	ld	[hl], c
	inc	hl
	ld	[hl], b
;src/editor/editor.c:167: redraw = 1;
	ld	hl, _redraw
	ld	[hl], $01
.l00101:
;src/editor/editor.c:168: }
	ret
;src/editor/editor.c:172: static void RenderAfterEdit(void) {
;	---------------------------------
; Function RenderAfterEdit
; ---------------------------------
_RenderAfterEdit:
	add	sp, -12
;src/editor/editor.c:173: unsigned char row = edit_row, end_row = tb_end_row, i;
	ld	hl, _edit_row
	ld	a, [hl]
	ld	hl, sp+10
	ld	[hl], a
	ld	hl, _tb_end_row
	ld	a, [hl]
	ld	hl, sp+0
	ld	[hl], a
;src/editor/editor.c:174: unsigned int old_next, expected, delta = (unsigned int)(int)edit_delta;
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
;src/editor/editor.c:175: if (row) --row; // the previous row's wrapping can change too
	ld	hl, sp+10
	ld	a, [hl]
	or	a, a
	jp	Z, .l00102
	dec	[hl]
.l00102:
;src/editor/editor.c:176: if (end_row != 0xFF && end_row >= row) tb_end_row = 0xFF; // found again while scanning
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
;src/editor/editor.c:177: for (; row < tb_rows; ++row) {
	ld	hl, sp+11
	ld	a, [hl]
	ld	hl, _tb_rows
	sub	a, [hl]
	jp	NC, .l00113
;src/editor/editor.c:178: old_next = tb_row_starts[row + 1];
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
;src/editor/editor.c:179: expected = old_next + delta;
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
;src/editor/editor.c:180: tb_RenderRows(row, row + 1);
	push	bc
	ld	hl, sp+7
	ld	e, [hl]
	ld	hl, sp+13
	ld	a, [hl]
	call	_tb_RenderRows
	pop	bc
;src/editor/editor.c:181: if (old_next > edit_pos && tb_row_starts[row + 1] == expected) {
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
;src/editor/editor.c:182: for (i = row + 2; i <= tb_rows; ++i) tb_row_starts[i] += delta; // rows below just moved
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
;src/editor/editor.c:183: if (end_row != 0xFF && end_row > row) tb_end_row = end_row;
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
;src/editor/editor.c:184: break;
	jp	.l00113
.l00119:
;src/editor/editor.c:177: for (; row < tb_rows; ++row) {
	ld	hl, sp+11
	inc	[hl]
	ld	a, [hl]
	dec	hl
	ld	[hl], a
	jp	.l00118
.l00113:
;src/editor/editor.c:187: redraw = 1;
	ld	hl, _redraw
	ld	[hl], $01
.l00120:
;src/editor/editor.c:188: }
	add	sp, 12
	ret
;src/editor/editor.c:191: static void Edited(unsigned int pos, signed char delta) {
;	---------------------------------
; Function Edited
; ---------------------------------
_Edited:
	ld	c, a
;src/editor/editor.c:192: modified = 1;
	ld	hl, _modified
	ld	[hl], $01
;src/editor/editor.c:193: if (edited) dirty = 1;
	ld	hl, _edited
	ld	a, [hl]
	or	a, a
	jp	Z, .l00102
	ld	hl, _dirty
	ld	[hl], $01
.l00102:
;src/editor/editor.c:194: edited = 1;
	ld	hl, _edited
	ld	[hl], $01
;src/editor/editor.c:195: edit_row = tb_found_row;
	ld	hl, _tb_found_row
	ld	a, [hl]
	ld	hl, _edit_row
	ld	[hl], a
;src/editor/editor.c:196: edit_pos = pos;
	ld	hl, _edit_pos
	ld	[hl], e
	inc	hl
	ld	[hl], d
;src/editor/editor.c:197: edit_delta = delta;
	ld	hl, _edit_delta
	ld	[hl], c
.l00103:
;src/editor/editor.c:198: }
	ret
;src/editor/editor.c:201: static void ScrollTo(unsigned int new_top) {
;	---------------------------------
; Function ScrollTo
; ---------------------------------
_ScrollTo:
	ld	hl, _top
	ld	[hl], e
	inc	hl
	ld	[hl], d
;src/editor/editor.c:203: Render();
	call	_Render
;src/editor/editor.c:204: redraw = 1;
	ld	hl, _redraw
	ld	[hl], $01
.l00101:
;src/editor/editor.c:205: }
	ret
;src/editor/editor.c:207: static void MoveUp(void) {
;	---------------------------------
; Function MoveUp
; ---------------------------------
_MoveUp:
;src/editor/editor.c:208: unsigned char row = tb_found_row;
	ld	hl, _tb_found_row
	ld	a, [hl]
;src/editor/editor.c:209: keep_x = 1;
	ld	hl, _keep_x
	ld	[hl], $01
;src/editor/editor.c:210: if (row) cursor = PosAtX(row - 1, want_x);
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
;src/editor/editor.c:211: else if (!top) cursor = 0;
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
;src/editor/editor.c:213: ScrollUp(tb_RowStart(top - 1));
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
;src/editor/editor.c:214: cursor = PosAtX(0, want_x);
	ld	hl, _want_x
	ld	e, [hl]
	xor	a, a
	call	_PosAtX
	ld	hl, _cursor
	ld	[hl], c
	inc	hl
	ld	[hl], b
.l00107:
;src/editor/editor.c:216: }
	ret
;src/editor/editor.c:218: static void MoveDown(void) {
;	---------------------------------
; Function MoveDown
; ---------------------------------
_MoveDown:
	dec	sp
;src/editor/editor.c:219: unsigned char row = tb_found_row;
	ld	hl, _tb_found_row
	ld	a, [hl]
	ld	hl, sp+0
	ld	[hl], a
;src/editor/editor.c:220: keep_x = 1;
	ld	hl, _keep_x
	ld	[hl], $01
;src/editor/editor.c:221: if (tb_end_row == row) cursor = tb_Length(); // last row
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
;src/editor/editor.c:222: else if (row + 1 < tb_rows) cursor = PosAtX(row + 1, want_x);
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
;src/editor/editor.c:224: ScrollDown();
	call	_ScrollDown
;src/editor/editor.c:225: cursor = PosAtX(row, want_x);
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
;src/editor/editor.c:227: }
	inc	sp
	ret
;src/editor/editor.c:229: static void PageUp(void) {
;	---------------------------------
; Function PageUp
; ---------------------------------
_PageUp:
;src/editor/editor.c:230: unsigned char row = tb_found_row, i;
	ld	hl, _tb_found_row
	ld	c, [hl]
;src/editor/editor.c:231: keep_x = 1;
	ld	hl, _keep_x
	ld	[hl], $01
;src/editor/editor.c:232: if (!top) {
	ld	hl, _top + 1
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	jp	NZ, .l00102
;src/editor/editor.c:233: cursor = 0;
	xor	a, a
	ld	hl, _cursor
	ld	[hl], a
	inc	hl
	ld	[hl], a
;src/editor/editor.c:234: return;
	jp	.l00108
.l00102:
;src/editor/editor.c:236: for (i = tb_rows - 1; i && top; --i) top = tb_RowStart(top - 1);
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
;src/editor/editor.c:237: ScrollTo(top);
	push	bc
	ld	hl, _top
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_ScrollTo
	pop	bc
;src/editor/editor.c:238: cursor = PosAtX(row, want_x);
	ld	hl, _want_x
	ld	e, [hl]
	ld	a, c
	call	_PosAtX
	ld	hl, _cursor
	ld	[hl], c
	inc	hl
	ld	[hl], b
.l00108:
;src/editor/editor.c:239: }
	ret
;src/editor/editor.c:241: static void PageDown(void) {
;	---------------------------------
; Function PageDown
; ---------------------------------
_PageDown:
;src/editor/editor.c:242: unsigned char row = tb_found_row;
	ld	hl, _tb_found_row
	ld	c, [hl]
;src/editor/editor.c:243: keep_x = 1;
	ld	hl, _keep_x
	ld	[hl], $01
;src/editor/editor.c:244: if (tb_end_row != 0xFF) {
	ld	hl, _tb_end_row
	ld	a, [hl]
	inc	a
	jp	NZ,.l00123
	jp	.l00102
.l00123:
;src/editor/editor.c:245: cursor = tb_Length();
	call	_tb_Length
	ld	hl, _cursor
	ld	[hl], c
	inc	hl
	ld	[hl], b
;src/editor/editor.c:246: return;
	jp	.l00106
.l00102:
;src/editor/editor.c:248: ScrollTo(tb_row_starts[tb_rows - 1]);
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
;src/editor/editor.c:249: if (tb_end_row != 0xFF && row > tb_end_row) row = tb_end_row;
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
;src/editor/editor.c:250: cursor = PosAtX(row, want_x);
	ld	hl, _want_x
	ld	e, [hl]
	ld	a, c
	call	_PosAtX
	ld	hl, _cursor
	ld	[hl], c
	inc	hl
	ld	[hl], b
.l00106:
;src/editor/editor.c:251: }
	ret
;src/editor/editor.c:254: static void MoveEnd(void) {
;	---------------------------------
; Function MoveEnd
; ---------------------------------
_MoveEnd:
	add	sp, -4
;src/editor/editor.c:255: unsigned char row = tb_found_row, count = tb_row_counts[row];
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
;src/editor/editor.c:256: cursor = tb_row_starts[row] + count;
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
;src/editor/editor.c:257: if (count && cursor == tb_row_starts[row + 1] && tb_end_row != row && RowAddress(row)[count - 1] == ' ') --cursor;
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
;src/editor/editor.c:258: }
	add	sp, 4
	ret
;src/editor/editor.c:260: static void HandleKey(unsigned char key, unsigned char mods) {
;	---------------------------------
; Function HandleKey
; ---------------------------------
_HandleKey:
	ld	c, a
;src/editor/editor.c:261: if (mods & (KB_MOD_CTRL | KB_MOD_ALT | KB_MOD_SUPER)) return; // TODO: shortcuts
	ld	a, e
	and	a, $38
	jp	NZ,.l00228
	jp	.l00102
.l00228:
	jp	.l00136
.l00102:
;src/editor/editor.c:263: moved = 1;
	ld	hl, _moved
	ld	[hl], $01
;src/editor/editor.c:264: switch (key) {
	ld	a, c
	sub	a, $80
	ld	a, $00
	rla
	ld	b, a
;src/editor/editor.c:269: case KEY_LEFT: if (cursor) --cursor; return;
	ld	hl, _cursor + 1
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	dec	de
;src/editor/editor.c:264: switch (key) {
	ld	a, b
	or	a, a
	jp	NZ, .l00115
	ld	a, $87
	sub	a, c
	jp	C, .l00115
	ld	a, c
	add	a, $80
	ld	c, a
	ld	b, $00
	ld	hl, .l00229
	add	hl, bc
	add	hl, bc
	add	hl, bc
	jp	hl
.l00229:
	jp	.l00107
	jp	.l00110
	jp	.l00103
	jp	.l00104
	jp	.l00113
	jp	.l00114
	jp	.l00105
	jp	.l00106
;src/editor/editor.c:265: case KEY_UP: MoveUp(); return;
.l00103:
	jp	_MoveUp
	jp	.l00136
;src/editor/editor.c:266: case KEY_DOWN: MoveDown(); return;
.l00104:
	jp	_MoveDown
	jp	.l00136
;src/editor/editor.c:267: case KEY_PAGE_UP: PageUp(); return;
.l00105:
	jp	_PageUp
	jp	.l00136
;src/editor/editor.c:268: case KEY_PAGE_DOWN: PageDown(); return;
.l00106:
	jp	_PageDown
	jp	.l00136
;src/editor/editor.c:269: case KEY_LEFT: if (cursor) --cursor; return;
.l00107:
	ld	hl, _cursor + 1
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	jp	Z, .l00109
	ld	[hl], e
	inc	hl
	ld	[hl], d
.l00109:
	jp	.l00136
;src/editor/editor.c:270: case KEY_RIGHT: if (cursor != tb_Length()) ++cursor; return;
.l00110:
	call	_tb_Length
	ld	hl, _cursor
	ld	a, [hl]
	sub	a, c
	jp	NZ,.l00230
	inc	hl
	ld	a, [hl]
	sub	a, b
	jp	NZ,.l00230
	jp	.l00112
.l00230:
	ld	hl, _cursor
	inc	[hl]
	jp	NZ, .l00231
	inc	hl
	inc	[hl]
.l00231:
.l00112:
	jp	.l00136
;src/editor/editor.c:271: case KEY_HOME: cursor = tb_row_starts[tb_found_row]; return;
.l00113:
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
	jp	.l00136
;src/editor/editor.c:272: case KEY_END: MoveEnd(); return;
.l00114:
	jp	_MoveEnd
	jp	.l00136
;src/editor/editor.c:273: }
.l00115:
;src/editor/editor.c:274: moved = 0;
	ld	hl, _moved
	ld	[hl], $00
;src/editor/editor.c:275: switch (key) {
	ld	a, c
	sub	a, $08
	jp	NZ,.l00232
	jp	.l00116
.l00232:
	ld	a, c
	sub	a, $1B
	jp	NZ,.l00233
	jp	.l00124
.l00233:
	ld	a, c
	sub	a, $7F
	jp	NZ,.l00234
	jp	.l00120
.l00234:
	ld	a, c
	sub	a, $88
	jp	NZ,.l00235
	jp	.l00124
.l00235:
	jp	.l00125
;src/editor/editor.c:276: case KEY_BACKSPACE:
.l00116:
;src/editor/editor.c:277: if (cursor && tb_Delete(cursor - 1)) Edited(--cursor, -1);
	ld	hl, _cursor + 1
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	jp	Z, .l00136
	call	_tb_Delete
	or	a, a
	jp	Z, .l00136
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
	jp	_Edited
;src/editor/editor.c:278: break;
	jp	.l00136
;src/editor/editor.c:279: case KEY_DELETE:
.l00120:
;src/editor/editor.c:280: if (tb_Delete(cursor)) Edited(cursor, -1);
	ld	hl, _cursor
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_tb_Delete
	or	a, a
	jp	Z, .l00136
	ld	a, $FF
	ld	hl, _cursor
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	jp	_Edited
;src/editor/editor.c:281: break;
	jp	.l00136
;src/editor/editor.c:283: case KEY_INSERT: return;
.l00124:
	jp	.l00136
;src/editor/editor.c:284: default:
.l00125:
;src/editor/editor.c:285: if (key < ' ' && key != ASCII_TAB && key != ASCII_LF) return;
	ld	a, c
	sub	a, $20
	jp	NC, .l00127
	ld	a, c
	sub	a, $09
	jp	NZ,.l00236
	jp	.l00127
.l00236:
	ld	a, c
	sub	a, $0A
	jp	NZ,.l00237
	jp	.l00127
.l00237:
	jp	.l00136
.l00127:
;src/editor/editor.c:286: if (key >= KEY_LEFT && key < 0xA0) return; // unprintable in Latin-1
	bit	0, b
	jp	NZ, .l00131
	ld	a, c
	sub	a, $A0
	jp	NC, .l00131
	jp	.l00136
.l00131:
;src/editor/editor.c:287: if (tb_Insert(cursor, key)) Edited(cursor++, 1);
	ld	a, c
	ld	hl, _cursor
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_tb_Insert
	or	a, a
	jp	Z, .l00136
	ld	hl, _cursor
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	dec	hl
	inc	[hl]
	jp	NZ, .l00238
	inc	hl
	inc	[hl]
.l00238:
	ld	a, $01
	jp	_Edited
;src/editor/editor.c:288: }
.l00136:
;src/editor/editor.c:289: }
	ret
;src/editor/editor.c:292: static unsigned char DpadRepeat(unsigned char pressed) {
;	---------------------------------
; Function DpadRepeat
; ---------------------------------
_DpadRepeat:
	ld	c, a
;src/editor/editor.c:293: unsigned char held = (button_state | pressed) & PADF_DPAD;
	ld	hl, _button_state
	ld	a, [hl]
	or	a, c
	and	a, $F0
	ld	b, a
;src/editor/editor.c:294: if (!held) return 0;
	or	a, a
	jp	NZ, .l00102
	xor	a, a
	jp	.l00109
.l00102:
;src/editor/editor.c:295: if (pressed & PADF_DPAD) pad_timer = PAD_REPEAT_DELAY;
	ld	a, c
	and	a, $F0
	jp	NZ,.l00126
	jp	.l00107
.l00126:
	ld	hl, _pad_timer
	ld	[hl], $14
	jp	.l00108
.l00107:
;src/editor/editor.c:296: else if (--pad_timer) return 0;
	ld	hl, _pad_timer
	dec	[hl]
	ld	a, [hl]
	or	a, a
	jp	Z, .l00104
	xor	a, a
	jp	.l00109
.l00104:
;src/editor/editor.c:297: else pad_timer = PAD_REPEAT_RATE;
	ld	hl, _pad_timer
	ld	[hl], $04
.l00108:
;src/editor/editor.c:298: return held;
	ld	a, b
.l00109:
;src/editor/editor.c:299: }
	ret
;src/editor/editor.c:301: static void ToggleOSK(void) {
;	---------------------------------
; Function ToggleOSK
; ---------------------------------
_ToggleOSK:
;src/editor/editor.c:302: osk_shown = !osk_shown;
	ld	hl, _osk_shown
	ld	a, [hl]
	sub	a,$01
	ld	a, $00
	rla
	ld	[hl], a
;src/editor/editor.c:303: tb_rows = osk_shown ? TB_ROWS - OSK_ROWS : TB_ROWS;
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
;src/editor/editor.c:304: if (osk_shown) {
	ld	hl, _osk_shown
	ld	a, [hl]
	or	a, a
	jp	Z, .l00102
;src/editor/editor.c:305: OSKDraw(osk_layer);
	ld	hl, _osk_layer
	ld	a, [hl]
	call	_OSKDraw
;src/editor/editor.c:306: OSKSelect(osk_x, osk_y);
	ld	hl, _osk_y
	ld	e, [hl]
	ld	hl, _osk_x
	ld	a, [hl]
	call	_OSKSelect
.l00102:
;src/editor/editor.c:308: OSKShow(osk_shown);
	ld	hl, _osk_shown
	ld	a, [hl]
	call	_OSKShow
;src/editor/editor.c:309: dirty = 1;
	ld	hl, _dirty
	ld	[hl], $01
.l00103:
;src/editor/editor.c:310: }
	ret
;src/editor/editor.c:312: static void SetOSKLayer(unsigned char layer) {
;	---------------------------------
; Function SetOSKLayer
; ---------------------------------
_SetOSKLayer:
	ld	c, a
;src/editor/editor.c:313: osk_layer = osk_layer == layer ? OSK_LOWER : layer;
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
;src/editor/editor.c:314: OSKDraw(osk_layer);
	ld	hl, _osk_layer
	ld	a, [hl]
	call	_OSKDraw
;src/editor/editor.c:315: dirty = 1;
	ld	hl, _dirty
	ld	[hl], $01
.l00101:
;src/editor/editor.c:316: }
	ret
;src/editor/editor.c:318: static unsigned char PressOSKKey(void) {
;	---------------------------------
; Function PressOSKKey
; ---------------------------------
_PressOSKKey:
;src/editor/editor.c:320: if (osk_y == OSK_ROWS - 1) {
	ld	hl, _osk_y
	ld	a, [hl]
	sub	a, $04
	jp	NZ,.l00157
	jp	.l00158
.l00157:
	jp	.l00117
.l00158:
;src/editor/editor.c:321: if (osk_x == 0) SetOSKLayer(OSK_SHIFT);
	ld	hl, _osk_x
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00114
	ld	a, $01
	call	_SetOSKLayer
	jp	.l00115
.l00114:
;src/editor/editor.c:322: else if (osk_x == 1) SetOSKLayer(OSK_SYMBOLS);
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
;src/editor/editor.c:323: else if (osk_x == OSK_COLS - 3) return KEY_MENU;
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
;src/editor/editor.c:324: else if (osk_x == OSK_COLS - 2) return KEY_LEFT;
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
;src/editor/editor.c:325: else if (osk_x == OSK_COLS - 1) return KEY_RIGHT;
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
;src/editor/editor.c:326: else return ' ';
	ld	a, $20
	jp	.l00120
.l00115:
;src/editor/editor.c:327: return KEY_NONE;
	xor	a, a
	jp	.l00120
.l00117:
;src/editor/editor.c:329: key = OSKGetKey(osk_layer, (osk_y << 3) + (osk_y << 1) + osk_x);
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
;src/editor/editor.c:330: if (osk_layer == OSK_SHIFT) SetOSKLayer(OSK_SHIFT); // shift is one shot
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
;src/editor/editor.c:331: return key;
	ld	a, c
.l00120:
;src/editor/editor.c:332: }
	ret
;src/editor/editor.c:334: static void MoveOSKSelection(unsigned char held) {
;	---------------------------------
; Function MoveOSKSelection
; ---------------------------------
_MoveOSKSelection:
	ld	c, a
;src/editor/editor.c:335: if (held & PADF_UP) osk_y = osk_y ? osk_y - 1 : OSK_ROWS - 1;
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
;src/editor/editor.c:336: else if (held & PADF_DOWN) osk_y = osk_y == OSK_ROWS - 1 ? 0 : osk_y + 1;
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
;src/editor/editor.c:337: if (held & PADF_LEFT) osk_x = osk_x ? osk_x - 1 : OSK_COLS - 1;
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
;src/editor/editor.c:338: else if (held & PADF_RIGHT) osk_x = osk_x == OSK_COLS - 1 ? 0 : osk_x + 1;
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
;src/editor/editor.c:339: OSKSelect(osk_x, osk_y);
	ld	hl, _osk_y
	ld	e, [hl]
	ld	hl, _osk_x
	ld	a, [hl]
	jp	_OSKSelect
.l00111:
;src/editor/editor.c:340: }
	ret
;src/editor/editor.c:344: static unsigned char PadKey(void) {
;	---------------------------------
; Function PadKey
; ---------------------------------
_PadKey:
;src/editor/editor.c:345: unsigned char pressed = PadPressed();
	call	_PadPressed
	ld	c, a
;src/editor/editor.c:347: if (pressed & PADF_SELECT) ToggleOSK();
	bit	2, c
	jp	NZ,.l00172
	jp	.l00102
.l00172:
	push	bc
	call	_ToggleOSK
	pop	bc
.l00102:
;src/editor/editor.c:348: if (pressed & PADF_B) return KEY_BACKSPACE;
	bit	1, c
	jp	NZ,.l00173
	jp	.l00104
.l00173:
	ld	a, $08
	jp	.l00120
.l00104:
;src/editor/editor.c:349: if (pressed & PADF_START) return KEY_ENTER;
	bit	3, c
	jp	NZ,.l00174
	jp	.l00106
.l00174:
	ld	a, $0A
	jp	.l00120
.l00106:
;src/editor/editor.c:350: if (osk_shown && (pressed & PADF_A)) return PressOSKKey();
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
;src/editor/editor.c:351: held = DpadRepeat(pressed);
	ld	a, c
	call	_DpadRepeat
	ld	c, a
;src/editor/editor.c:352: if (!held) return KEY_NONE;
	ld	a, c
	or	a, a
	jp	NZ, .l00111
	xor	a, a
	jp	.l00120
.l00111:
;src/editor/editor.c:353: if (osk_shown) {
	ld	hl, _osk_shown
	ld	a, [hl]
	or	a, a
	jp	Z, .l00113
;src/editor/editor.c:354: MoveOSKSelection(held);
	ld	a, c
	call	_MoveOSKSelection
;src/editor/editor.c:355: return KEY_NONE;
	xor	a, a
	jp	.l00120
.l00113:
;src/editor/editor.c:357: if (held & PADF_UP) return KEY_UP;
	bit	6, c
	jp	NZ,.l00176
	jp	.l00115
.l00176:
	ld	a, $82
	jp	.l00120
.l00115:
;src/editor/editor.c:358: if (held & PADF_DOWN) return KEY_DOWN;
	bit	7, c
	jp	NZ,.l00177
	jp	.l00117
.l00177:
	ld	a, $83
	jp	.l00120
.l00117:
;src/editor/editor.c:359: if (held & PADF_LEFT) return KEY_LEFT;
	bit	5, c
	jp	NZ,.l00178
	jp	.l00119
.l00178:
	ld	a, $80
	jp	.l00120
.l00119:
;src/editor/editor.c:360: return KEY_RIGHT;
	ld	a, $81
.l00120:
;src/editor/editor.c:361: }
	ret
;src/editor/editor.c:364: static unsigned char MenuKey(void) {
;	---------------------------------
; Function MenuKey
; ---------------------------------
_MenuKey:
;src/editor/editor.c:366: WaitFrame();
	call	_WaitFrame
;src/editor/editor.c:367: if ((key = (unsigned char)KBPopEvent())) return key;
	call	_KBPopEvent
	ld	a, c
	ld	c, a
	or	a, a
	jp	Z, .l00102
	ld	a, c
	jp	.l00111
.l00102:
;src/editor/editor.c:368: pressed = PadPressed();
	call	_PadPressed
	ld	c, a
;src/editor/editor.c:369: if (pressed & (PADF_A | PADF_START)) return KEY_ENTER;
	ld	a, c
	and	a, $09
	jp	NZ,.l00138
	jp	.l00104
.l00138:
	ld	a, $0A
	jp	.l00111
.l00104:
;src/editor/editor.c:370: if (pressed & PADF_B) return KEY_ESCAPE;
	bit	1, c
	jp	NZ,.l00139
	jp	.l00106
.l00139:
	ld	a, $1B
	jp	.l00111
.l00106:
;src/editor/editor.c:371: held = DpadRepeat(pressed);
	ld	a, c
	call	_DpadRepeat
;src/editor/editor.c:372: if (held & PADF_UP) return KEY_UP;
	bit	6, a
	jp	NZ,.l00140
	jp	.l00108
.l00140:
	ld	a, $82
	jp	.l00111
.l00108:
;src/editor/editor.c:373: if (held & PADF_DOWN) return KEY_DOWN;
	rlca
	jp	C,.l00141
	jp	.l00110
.l00141:
	ld	a, $83
	jp	.l00111
.l00110:
;src/editor/editor.c:374: return KEY_NONE;
	xor	a, a
.l00111:
;src/editor/editor.c:375: }
	ret
;src/editor/editor.c:377: static char* RowAddress(unsigned char row) {
;	---------------------------------
; Function RowAddress
; ---------------------------------
_RowAddress:
	ld	e, a
;src/editor/editor.c:378: unsigned int offset = row;
	ld	d, $00
;src/editor/editor.c:379: return (char*)tile_buffer + (offset << 5) + (offset << 3); // row * TB_STRIDE
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
;src/editor/editor.c:380: }
	ret
;src/editor/editor.c:383: static void DrawRow(unsigned char row, unsigned char col, const char* text) {
;	---------------------------------
; Function DrawRow
; ---------------------------------
_DrawRow:
	dec	sp
	dec	sp
	ld	c, a
	ld	hl, sp+1
	ld	[hl], e
;src/editor/editor.c:384: char* dest = RowAddress(row);
	ld	a, c
	call	_RowAddress
;src/editor/editor.c:386: for (i = 0; i < TB_STRIDE; ++i) dest[i] = ' ';
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
;src/editor/editor.c:387: for (dest += col; *text && col < TB_STRIDE; ++col) *dest++ = *text++;
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
;src/editor/editor.c:388: }
	inc	sp
	inc	sp
	pop	hl
	inc	sp
	inc	sp
	jp hl 
;src/editor/editor.c:390: static void ClearScreen(void) {
;	---------------------------------
; Function ClearScreen
; ---------------------------------
_ClearScreen:
;src/editor/editor.c:392: for (row = 0; row < TB_ROWS; ++row) DrawRow(row, 0, "");
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
;src/editor/editor.c:393: }
	ret
___str_7:
	DB $00
;src/editor/editor.c:396: static void BeginFullScreen(void) {
;	---------------------------------
; Function BeginFullScreen
; ---------------------------------
_BeginFullScreen:
;src/editor/editor.c:397: EditorShowCursor(0);
	xor	a, a
	call	_EditorShowCursor
;src/editor/editor.c:398: if (osk_shown) OSKShow(0);
	ld	hl, _osk_shown
	ld	a, [hl]
	or	a, a
	jp	Z, .l00102
	xor	a, a
	call	_OSKShow
.l00102:
;src/editor/editor.c:399: tb_rows = TB_ROWS;
	ld	hl, _tb_rows
	ld	[hl], $12
;src/editor/editor.c:400: dirty = 1;
	ld	hl, _dirty
	ld	[hl], $01
.l00103:
;src/editor/editor.c:401: }
	ret
;src/editor/editor.c:403: static void EndFullScreen(void) {
;	---------------------------------
; Function EndFullScreen
; ---------------------------------
_EndFullScreen:
;src/editor/editor.c:404: if (osk_shown) {
	ld	hl, _osk_shown
	ld	a, [hl]
	or	a, a
	jp	Z, .l00103
;src/editor/editor.c:405: tb_rows = TB_ROWS - OSK_ROWS;
	ld	hl, _tb_rows
	ld	[hl], $0D
;src/editor/editor.c:406: OSKDraw(osk_layer);
	ld	hl, _osk_layer
	ld	a, [hl]
	call	_OSKDraw
;src/editor/editor.c:407: OSKSelect(osk_x, osk_y);
	ld	hl, _osk_y
	ld	e, [hl]
	ld	hl, _osk_x
	ld	a, [hl]
	call	_OSKSelect
;src/editor/editor.c:408: OSKShow(1);
	ld	a, $01
	jp	_OSKShow
.l00103:
;src/editor/editor.c:410: }
	ret
;src/editor/editor.c:413: static unsigned char Choose(const char* title, const char* items, unsigned char count) {
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
;src/editor/editor.c:414: unsigned char i, key, selected = 0;
	ld	hl, sp+0
	ld	[hl], $00
;src/editor/editor.c:415: BeginFullScreen();
	call	_BeginFullScreen
;src/editor/editor.c:416: while (1) {
.l00119:
;src/editor/editor.c:417: ClearScreen();
	call	_ClearScreen
;src/editor/editor.c:418: DrawRow(0, 0, title);
	ld	hl, sp+9
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	push	de
	ld	e, $00
	xor	a, a
	call	_DrawRow
;src/editor/editor.c:419: for (i = 0; i < count; ++i) {
	ld	hl, sp+11
	ld	[hl], $00
.l00122:
	ld	hl, sp+11
	ld	a, [hl]
	ld	hl, sp+14
	sub	a, [hl]
	jp	NC, .l00103
;src/editor/editor.c:420: DrawRow(i + 2, 2, items + (i << 3) + (i << 2) + i); // i * FILE_NAME_SIZE
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
;src/editor/editor.c:421: if (i == selected) RowAddress(i + 2)[1] = MARKER;
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
;src/editor/editor.c:419: for (i = 0; i < count; ++i) {
	ld	hl, sp+11
	inc	[hl]
	jp	.l00122
.l00103:
;src/editor/editor.c:423: EditorDraw(tb_rows);
	ld	hl, _tb_rows
	ld	a, [hl]
	call	_EditorDraw
;src/editor/editor.c:424: while (!(key = MenuKey()));
.l00104:
	call	_MenuKey
	ld	c, a
	or	a, a
	jp	Z, .l00104
;src/editor/editor.c:425: if (key == KEY_UP) selected = selected ? selected - 1 : count - 1;
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
;src/editor/editor.c:426: else if (key == KEY_DOWN) selected = selected == count - 1 ? 0 : selected + 1;
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
;src/editor/editor.c:427: else if (key == KEY_ENTER) break;
	ld	a, c
	sub	a, $0A
	jp	NZ,.l00201
	jp	.l00120
.l00201:
;src/editor/editor.c:428: else if (key == KEY_ESCAPE) {
	ld	a, c
	sub	a, $1B
	jp	NZ,.l00202
	jp	.l00203
.l00202:
	jp	.l00119
.l00203:
;src/editor/editor.c:429: selected = CANCEL;
	ld	hl, sp+0
	ld	[hl], $FF
;src/editor/editor.c:430: break;
.l00120:
;src/editor/editor.c:433: EndFullScreen();
	call	_EndFullScreen
;src/editor/editor.c:434: return selected;
	ld	hl, sp+0
	ld	a, [hl]
.l00124:
;src/editor/editor.c:435: }
	add	sp, 12
	pop	hl
	inc	sp
	jp hl 
;src/editor/editor.c:438: static void ShowMessage(const char* text) {
;	---------------------------------
; Function ShowMessage
; ---------------------------------
_ShowMessage:
;src/editor/editor.c:439: Render();
	push	de
	call	_Render
	pop	de
;src/editor/editor.c:440: EditorShowCursor(0);
	push	de
	xor	a, a
	call	_EditorShowCursor
	pop	de
;src/editor/editor.c:441: DrawRow(tb_rows - 1, 0, text);
	ld	hl, _tb_rows
	ld	c, [hl]
	dec	c
	push	de
	ld	e, $00
	ld	a, c
	call	_DrawRow
;src/editor/editor.c:442: EditorDraw(tb_rows);
	ld	hl, _tb_rows
	ld	a, [hl]
	call	_EditorDraw
;src/editor/editor.c:443: while (!MenuKey());
.l00101:
	call	_MenuKey
	or	a, a
	jp	Z, .l00101
;src/editor/editor.c:444: dirty = 1;
	ld	hl, _dirty
	ld	[hl], $01
.l00104:
;src/editor/editor.c:445: }
	ret
;src/editor/editor.c:447: static void ShowError(unsigned char result, const char* denied) {
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
;src/editor/editor.c:448: char text[12] = "SD ERROR ";
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
;src/editor/editor.c:449: if (result == FR_NOT_READY) ShowMessage("NO SD CARD");
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
;src/editor/editor.c:450: else if (result == FR_NO_FILESYSTEM) ShowMessage("NO FAT VOLUME");
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
;src/editor/editor.c:451: else if (result == FR_DENIED) ShowMessage(denied);
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
;src/editor/editor.c:453: text[9] = '0';
	ld	hl, sp+9
	ld	[hl], $30
;src/editor/editor.c:454: while (result >= 10) {
.l00101:
;src/editor/editor.c:456: result -= 10;
	ld	hl, sp+16
	ld	a, [hl]
	ld	hl, sp+12
	ld	[hl], a
;src/editor/editor.c:454: while (result >= 10) {
	ld	hl, sp+16
	ld	a, [hl]
	sub	a, $0A
	jp	C, .l00103
;src/editor/editor.c:455: ++text[9];
	ld	hl, sp+9
	ld	a, [hl]
	ld	hl, sp+13
	ld	[hl], a
	ld	a, [hl]
	inc	a
	ld	hl, sp+9
	ld	[hl], a
;src/editor/editor.c:456: result -= 10;
	ld	hl, sp+12
	ld	a, [hl]
	add	a, $F6
	ld	hl, sp+16
	ld	[hl], a
	jp	.l00101
.l00103:
;src/editor/editor.c:458: text[10] = '0' + result;
	ld	hl, sp+12
	ld	a, [hl]
	add	a, $30
	dec	hl
	dec	hl
	ld	[hl], a
;src/editor/editor.c:459: text[11] = 0;
	inc	hl
	ld	[hl], $00
;src/editor/editor.c:460: ShowMessage(text);
	ld	hl, 0
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_ShowMessage
.l00113:
;src/editor/editor.c:462: }
	add	sp, 17
	ret
___str_9:
	DB "NO SD CARD"
	DB $00
___str_10:
	DB "NO FAT VOLUME"
	DB $00
;src/editor/editor.c:464: static void CopyName(char* dest, const char* src) {
;	---------------------------------
; Function CopyName
; ---------------------------------
_CopyName:
;src/editor/editor.c:465: while ((*dest++ = *src++));
.l00101:
	ld	a, [bc]
	inc	bc
	ld	[de], a
	inc	de
	or	a, a
	jp	NZ, .l00101
.l00104:
;src/editor/editor.c:466: }
	ret
;src/editor/editor.c:469: static unsigned char CanDiscard(void) {
;	---------------------------------
; Function CanDiscard
; ---------------------------------
_CanDiscard:
;src/editor/editor.c:470: return !modified || Choose("DISCARD CHANGES?", discard_items[0], 2) == 1;
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
;src/editor/editor.c:471: }
	ret
___str_11:
	DB "DISCARD CHANGES?"
	DB $00
;src/editor/editor.c:473: static void ResetCursor(void) {
;	---------------------------------
; Function ResetCursor
; ---------------------------------
_ResetCursor:
;src/editor/editor.c:474: cursor = 0;
	xor	a, a
	ld	hl, _cursor
	ld	[hl], a
	inc	hl
	ld	[hl], a
;src/editor/editor.c:475: top = 0;
	xor	a, a
	ld	hl, _top
	ld	[hl], a
	inc	hl
	ld	[hl], a
;src/editor/editor.c:476: want_x = 0;
	ld	hl, _want_x
	ld	[hl], $00
;src/editor/editor.c:477: modified = 0;
	ld	hl, _modified
	ld	[hl], $00
;src/editor/editor.c:478: dirty = 1;
	ld	hl, _dirty
	ld	[hl], $01
.l00101:
;src/editor/editor.c:479: }
	ret
;src/editor/editor.c:481: static void NewFile(void) {
;	---------------------------------
; Function NewFile
; ---------------------------------
_NewFile:
;src/editor/editor.c:482: if (!CanDiscard()) return;
	call	_CanDiscard
	or	a, a
	jp	NZ, .l00102
	jp	.l00103
.l00102:
;src/editor/editor.c:483: tb_Clear();
	call	_tb_Clear
;src/editor/editor.c:484: file_name[0] = 0;
	ld	hl, _file_name
	ld	[hl], $00
;src/editor/editor.c:485: fs_crlf = 0;
	ld	hl, _fs_crlf
	ld	[hl], $00
;src/editor/editor.c:486: ResetCursor();
	jp	_ResetCursor
.l00103:
;src/editor/editor.c:487: }
	ret
;src/editor/editor.c:489: static void OpenFile(void) {
;	---------------------------------
; Function OpenFile
; ---------------------------------
_OpenFile:
	dec	sp
;src/editor/editor.c:491: if (!CanDiscard()) return;
	call	_CanDiscard
	ld	c, a
	ld	a, c
	or	a, a
	jp	NZ, .l00102
	jp	.l00116
.l00102:
;src/editor/editor.c:492: if ((result = FileMount()) || (result = FileOpenDir())) {
	call	_FileMount
	ld	c, a
	or	a, a
	jp	NZ, .l00103
	call	_FileOpenDir
	ld	c, a
	or	a, a
	jp	Z, .l00122
.l00103:
;src/editor/editor.c:493: ShowError(result, "");
	ld	de, ___str_12
	ld	a, c
	inc	sp
	jp	_ShowError
;src/editor/editor.c:494: return;
	jp	.l00116
;src/editor/editor.c:496: while (count < FILE_LIST_MAX && FileNext(file_list[count])) ++count;
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
;src/editor/editor.c:497: if (!count) {
	ld	a, c
	or	a, a
	jp	NZ, .l00111
;src/editor/editor.c:498: ShowMessage("NO .TXT FILES");
	ld	de, ___str_13
	inc	sp
	jp	_ShowMessage
;src/editor/editor.c:499: return;
	jp	.l00116
.l00111:
;src/editor/editor.c:501: selected = Choose("OPEN", file_list[0], count);
	ld	a, c
	push	af
	inc	sp
	ld	bc, _file_list
	ld	de, ___str_14
	call	_Choose
	ld	c, a
;src/editor/editor.c:502: if (selected == CANCEL) return;
	ld	a, c
	inc	a
	jp	NZ,.l00159
	jp	.l00160
.l00159:
	jp	.l00113
.l00160:
	jp	.l00116
.l00113:
;src/editor/editor.c:503: result = FileLoad(file_list[selected]);
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
;src/editor/editor.c:504: CopyName(file_name, file_list[selected]);
	ld	de, _file_name
	call	_CopyName
;src/editor/editor.c:505: ResetCursor();
	call	_ResetCursor
;src/editor/editor.c:506: if (result) ShowError(result, "FILE TOO BIG");
	ld	hl, sp+0
	ld	a, [hl]
	or	a, a
	jp	Z, .l00116
	ld	de, ___str_15
	ld	a, [hl]
	inc	sp
	jp	_ShowError
.l00116:
;src/editor/editor.c:507: }
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
;src/editor/editor.c:510: static unsigned char AskFileName(void) {
;	---------------------------------
; Function AskFileName
; ---------------------------------
_AskFileName:
	add	sp, -32
;src/editor/editor.c:515: Render();
	ld	c, $00
.l00134:
;src/editor/editor.c:514: for (; file_name[length] && file_name[length] != '.'; ++length) name[length] = file_name[length];
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
;src/editor/editor.c:515: Render();
	call	_Render
;src/editor/editor.c:516: EditorShowCursor(0);
	xor	a, a
	call	_EditorShowCursor
;src/editor/editor.c:517: while (1) {
.l00129:
;src/editor/editor.c:518: CopyName(text, "SAVE AS ");
	ld	bc, ___str_16
	ld	hl, 9
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_CopyName
;src/editor/editor.c:519: for (i = 0; i < length; ++i) text[8 + i] = name[i];
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
;src/editor/editor.c:520: CopyName(text + 8 + length, "_.TXT");
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
;src/editor/editor.c:521: DrawRow(0, 0, text);
	ld	hl, 9
	add	hl, sp
	push	hl
	ld	e, $00
	xor	a, a
	call	_DrawRow
;src/editor/editor.c:522: EditorDraw(tb_rows);
	ld	hl, _tb_rows
	ld	a, [hl]
	call	_EditorDraw
;src/editor/editor.c:523: do {
.l00105:
;src/editor/editor.c:524: WaitFrame();
	call	_WaitFrame
;src/editor/editor.c:525: key = (unsigned char)KBPopEvent();
	call	_KBPopEvent
	ld	hl, sp+30
	ld	[hl], c
;src/editor/editor.c:526: if (!key) key = PadKey();
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00106
	call	_PadKey
	ld	hl, sp+30
	ld	[hl], a
.l00106:
;src/editor/editor.c:527: } while (!key);
	ld	hl, sp+30
	ld	a, [hl]
	or	a, a
	jp	Z, .l00105
;src/editor/editor.c:528: if (key == KEY_ENTER && length) break;
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
;src/editor/editor.c:529: if (key == KEY_ESCAPE || (key == KEY_BACKSPACE && !length)) {
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
;src/editor/editor.c:530: dirty = 1;
	ld	hl, _dirty
	ld	[hl], $01
;src/editor/editor.c:531: return 0;
	xor	a, a
	jp	.l00142
.l00112:
;src/editor/editor.c:533: if (key == KEY_BACKSPACE) --length;
	ld	a, c
	or	a, a
	jp	Z, .l00116
	ld	hl, sp+31
	dec	[hl]
.l00116:
;src/editor/editor.c:534: if (key >= 'a' && key <= 'z') key -= 'a' - 'A';
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
;src/editor/editor.c:535: if (length < BASE_NAME_SIZE && ((key >= 'A' && key <= 'Z') || (key >= '0' && key <= '9') || key == '_' || key == '-')) {
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
;src/editor/editor.c:536: name[length++] = key;
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
;src/editor/editor.c:539: for (i = 0; i < length; ++i) file_name[i] = name[i];
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
;src/editor/editor.c:540: CopyName(file_name + length, ".TXT");
	ld	de, _file_name
	ld	hl, sp+31
	ld	l, [hl]
	ld	h, $00
	add	hl, de
	ld	e, l
	ld	d, h
	ld	bc, ___str_18
	call	_CopyName
;src/editor/editor.c:541: dirty = 1;
	ld	hl, _dirty
	ld	[hl], $01
;src/editor/editor.c:542: return 1;
	ld	a, $01
.l00142:
;src/editor/editor.c:543: }
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
;src/editor/editor.c:545: static void SaveFile(unsigned char ask) {
;	---------------------------------
; Function SaveFile
; ---------------------------------
_SaveFile:
	ld	c, a
;src/editor/editor.c:547: if ((ask || !file_name[0]) && !AskFileName()) return;
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
;src/editor/editor.c:548: if ((result = FileMount()) || (result = FileSave(file_name))) {
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
;src/editor/editor.c:549: ShowError(result, "DISK FULL");
	ld	de, ___str_19
	ld	a, c
	jp	_ShowError
;src/editor/editor.c:550: return;
	jp	.l00108
.l00106:
;src/editor/editor.c:552: modified = 0;
	ld	hl, _modified
	ld	[hl], $00
;src/editor/editor.c:553: ShowMessage("SAVED");
	ld	de, ___str_20
	jp	_ShowMessage
.l00108:
;src/editor/editor.c:554: }
	ret
___str_19:
	DB "DISK FULL"
	DB $00
___str_20:
	DB "SAVED"
	DB $00
;src/editor/editor.c:557: static void ToggleFont(void) {
;	---------------------------------
; Function ToggleFont
; ---------------------------------
_ToggleFont:
;src/editor/editor.c:558: font = font == FONT_VWF ? FONT_MONO : FONT_VWF;
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
;src/editor/editor.c:559: SetFont(font);
	ld	hl, _font
	ld	a, [hl]
	call	_SetFont
;src/editor/editor.c:560: dirty = 1;
	ld	hl, _dirty
	ld	[hl], $01
.l00101:
;src/editor/editor.c:561: }
	ret
;src/editor/editor.c:563: static void FileMenu(void) {
;	---------------------------------
; Function FileMenu
; ---------------------------------
_FileMenu:
;src/editor/editor.c:564: switch (Choose("MENU", menu_items[0], 5)) {
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
;src/editor/editor.c:565: case 0: OpenFile(); break;
.l00101:
	jp	_OpenFile
	jp	.l00107
;src/editor/editor.c:566: case 1: SaveFile(0); break;
.l00102:
	xor	a, a
	jp	_SaveFile
	jp	.l00107
;src/editor/editor.c:567: case 2: SaveFile(1); break;
.l00103:
	ld	a, $01
	jp	_SaveFile
	jp	.l00107
;src/editor/editor.c:568: case 3: NewFile(); break;
.l00104:
	jp	_NewFile
	jp	.l00107
;src/editor/editor.c:569: case 4: ToggleFont(); break;
.l00105:
	jp	_ToggleFont
;src/editor/editor.c:570: }
.l00107:
;src/editor/editor.c:571: }
	ret
___str_21:
	DB "MENU"
	DB $00
;src/editor/editor.c:574: static unsigned char HandleFileKey(unsigned char key, unsigned char mods) {
;	---------------------------------
; Function HandleFileKey
; ---------------------------------
_HandleFileKey:
	ld	c, a
;src/editor/editor.c:575: if (key == KEY_MENU || key == KEY_ESCAPE) FileMenu();
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
;src/editor/editor.c:576: else if (!(mods & KB_MOD_CTRL)) return 0;
	bit	5, e
	jp	NZ,.l00158
	jp	.l00159
.l00158:
	jp	.l00117
.l00159:
	xor	a, a
	jp	.l00123
.l00117:
;src/editor/editor.c:577: else if (key == 'o' || key == 'O') OpenFile();
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
;src/editor/editor.c:578: else if (key == 's' || key == 'S') SaveFile(0);
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
;src/editor/editor.c:579: else if (key == 'n' || key == 'N') NewFile();
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
;src/editor/editor.c:580: else if (key == 'f' || key == 'F') ToggleFont();
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
;src/editor/editor.c:581: dirty = 1;
	ld	hl, _dirty
	ld	[hl], $01
;src/editor/editor.c:582: return 1;
	ld	a, $01
.l00123:
;src/editor/editor.c:583: }
	ret
;src/editor/editor.c:585: static void Render(void) {
;	---------------------------------
; Function Render
; ---------------------------------
_Render:
;src/editor/editor.c:586: tb_find = cursor;
	ld	hl, _cursor
	ld	a, [hl]
	ld	hl, _tb_find
	ld	[hl], a
	ld	hl, _cursor + 1
	ld	a, [hl]
	ld	hl, _tb_find + 1
	ld	[hl], a
;src/editor/editor.c:587: tb_Render(top);
	ld	hl, _top
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	jp	_tb_Render
.l00101:
;src/editor/editor.c:588: }
	ret
;src/editor/editor.c:591: static void Refresh(void) {
;	---------------------------------
; Function Refresh
; ---------------------------------
_Refresh:
	add	sp, -3
;src/editor/editor.c:594: if (top > tb_Length()) top = tb_Length();
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
;src/editor/editor.c:595: top = tb_RowStart(top); // wrapping may have changed
	ld	hl, _top
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_tb_RowStart
	ld	hl, _top
	ld	[hl], c
	inc	hl
	ld	[hl], b
;src/editor/editor.c:596: Render();
	call	_Render
;src/editor/editor.c:597: if (tb_found_row == 0xFF) {
	ld	hl, _tb_found_row
	ld	a, [hl]
	inc	a
	jp	NZ,.l00175
	jp	.l00176
.l00175:
	jp	.l00118
.l00176:
;src/editor/editor.c:598: row = tb_RowStart(cursor);
	ld	hl, _cursor
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_tb_RowStart
;src/editor/editor.c:599: if (cursor < top) {
	ld	de, _cursor
	ld	hl, _top
	ld	a, [de]
	inc	de
	sub	a, [hl]
	inc	hl
	ld	a, [de]
	sbc	a, [hl]
	jp	NC, .l00115
;src/editor/editor.c:600: if (top && row == tb_RowStart(top - 1)) ScrollRing(0); // one row up
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
	jp	NZ,.l00177
	ld	a, d
	sub	a, b
	jp	NZ,.l00177
	jp	.l00178
.l00177:
	jp	.l00104
.l00178:
	push	bc
	xor	a, a
	call	_ScrollRing
	pop	bc
.l00104:
;src/editor/editor.c:601: top = row;
	ld	hl, _top
	ld	[hl], c
	inc	hl
	ld	[hl], b
	jp	.l00116
.l00115:
;src/editor/editor.c:604: bottom = tb_row_starts[tb_rows];
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
;src/editor/editor.c:605: for (i = tb_rows; i; --i) {
	ld	hl, _tb_rows
	ld	a, [hl]
	ld	hl, sp+2
	ld	[hl], a
.l00120:
	ld	hl, sp+2
	ld	a, [hl]
	or	a, a
	jp	Z, .l00108
;src/editor/editor.c:606: top = tb_NextRow(top);
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
;src/editor/editor.c:607: if (bottom == row) break;
	ld	hl, sp+0
	ld	a, [hl]
	sub	a, c
	jp	NZ,.l00179
	inc	hl
	ld	a, [hl]
	sub	a, b
	jp	NZ,.l00179
	jp	.l00108
.l00179:
;src/editor/editor.c:608: bottom = tb_NextRow(bottom);
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
;src/editor/editor.c:605: for (i = tb_rows; i; --i) {
	ld	hl, sp+2
	dec	[hl]
	jp	.l00120
.l00108:
;src/editor/editor.c:610: if (!i) top = row;
	ld	hl, sp+2
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00112
	ld	hl, _top
	ld	[hl], c
	inc	hl
	ld	[hl], b
	jp	.l00116
.l00112:
;src/editor/editor.c:611: else if (i == tb_rows) ScrollRing(1); // one row down
	ld	hl, _tb_rows
	ld	a, [hl]
	ld	hl, sp+2
	sub	a, [hl]
	jp	NZ,.l00180
	jp	.l00181
.l00180:
	jp	.l00116
.l00181:
	ld	a, $01
	call	_ScrollRing
.l00116:
;src/editor/editor.c:613: Render();
	call	_Render
.l00118:
;src/editor/editor.c:615: EditorDraw(tb_rows);
	ld	hl, _tb_rows
	ld	a, [hl]
	call	_EditorDraw
;src/editor/editor.c:616: redraw = 0;
	ld	hl, _redraw
	ld	[hl], $00
;src/editor/editor.c:617: moved = 0;
	ld	hl, _moved
	ld	[hl], $00
;src/editor/editor.c:618: PlaceCursor();
	call	_PlaceCursor
.l00122:
;src/editor/editor.c:619: }
	add	sp, 3
	ret
;src/editor/editor.c:621: void Editor(void) {
;	---------------------------------
; Function Editor
; ---------------------------------
_Editor::
;src/editor/editor.c:625: EditorSetup();
	call	_EditorSetup
;src/editor/editor.c:626: everdrive = sd_Detect();
	call	_sd_Detect
	ld	hl, _everdrive
	ld	[hl], a
;src/editor/editor.c:627: idle_frames = 0;
	ld	hl, _idle_frames
	ld	[hl], $00
;src/editor/editor.c:628: normalized = 0;
	ld	hl, _normalized
	ld	[hl], $00
;src/editor/editor.c:629: cursor = 0;
	xor	a, a
	ld	hl, _cursor
	ld	[hl], a
	inc	hl
	ld	[hl], a
;src/editor/editor.c:630: top = 0;
	xor	a, a
	ld	hl, _top
	ld	[hl], a
	inc	hl
	ld	[hl], a
;src/editor/editor.c:631: want_x = 0;
	ld	hl, _want_x
	ld	[hl], $00
;src/editor/editor.c:632: keep_x = 0;
	ld	hl, _keep_x
	ld	[hl], $00
;src/editor/editor.c:633: moved = 0;
	ld	hl, _moved
	ld	[hl], $00
;src/editor/editor.c:634: redraw = 0;
	ld	hl, _redraw
	ld	[hl], $00
;src/editor/editor.c:635: ring_top = 0;
	ld	hl, _ring_top
	ld	[hl], $00
;src/editor/editor.c:636: edited = 0;
	ld	hl, _edited
	ld	[hl], $00
;src/editor/editor.c:637: pad_timer = 0;
	ld	hl, _pad_timer
	ld	[hl], $00
;src/editor/editor.c:638: modified = 0;
	ld	hl, _modified
	ld	[hl], $00
;src/editor/editor.c:639: font = FONT_VWF;
	ld	hl, _font
	ld	[hl], $01
;src/editor/editor.c:640: file_name[0] = 0;
	ld	hl, _file_name
	ld	[hl], $00
;src/editor/editor.c:641: fs_crlf = 0;
	ld	hl, _fs_crlf
	ld	[hl], $00
;src/editor/editor.c:642: osk_shown = 0;
	ld	hl, _osk_shown
	ld	[hl], $00
;src/editor/editor.c:643: osk_layer = OSK_LOWER;
	ld	hl, _osk_layer
	ld	[hl], $00
;src/editor/editor.c:644: osk_x = 0;
	ld	hl, _osk_x
	ld	[hl], $00
;src/editor/editor.c:645: osk_y = 0;
	ld	hl, _osk_y
	ld	[hl], $00
;src/editor/editor.c:646: tb_rows = TB_ROWS;
	ld	hl, _tb_rows
	ld	[hl], $12
;src/editor/editor.c:647: Refresh();
	call	_Refresh
;src/editor/editor.c:649: while (1) {
.l00155:
;src/editor/editor.c:650: WaitFrame();
	call	_WaitFrame
;src/editor/editor.c:651: while ((key = (unsigned char)(event = KBPopEvent()))) {
.l00110:
	call	_KBPopEvent
	ld	e, c
	ld	d, b
	ld	a, c
	ld	c, a
	or	a, a
	jp	Z, .l00112
;src/editor/editor.c:652: if (!HandleFileKey(key, (unsigned char)(event >> 8))) HandleKey(key, (unsigned char)(event >> 8));
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
	jp	NZ, .l00102
	ld	e, l
	ld	a, c
	call	_HandleKey
.l00102:
;src/editor/editor.c:653: if (dirty || edited) break; // text changed, rows need rendering before more keys
	ld	hl, _dirty
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00112
	ld	hl, _edited
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00112
;src/editor/editor.c:654: if (moved) { // keeps tb_found_row current for the next key
	ld	hl, _moved
	ld	a, [hl]
	or	a, a
	jp	Z, .l00110
;src/editor/editor.c:655: if (!PlaceCursor()) dirty = 1;
	call	_PlaceCursor
	or	a, a
	jp	NZ, .l00107
	ld	hl, _dirty
	ld	[hl], $01
.l00107:
;src/editor/editor.c:656: moved = 0;
	ld	hl, _moved
	ld	[hl], $00
	jp	.l00110
.l00112:
;src/editor/editor.c:659: if ((key = PadKey())) {
	call	_PadKey
	ld	c, a
	or	a, a
	jp	Z, .l00116
;src/editor/editor.c:660: if (!HandleFileKey(key, 0)) HandleKey(key, 0);
	push	bc
	ld	e, $00
	ld	a, c
	call	_HandleFileKey
	pop	bc
	or	a, a
	jp	NZ, .l00116
	ld	e, $00
	ld	a, c
	call	_HandleKey
.l00116:
;src/editor/editor.c:662: if (dirty || edited || redraw || moved) idle_frames = 0;
	ld	hl, _dirty
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00117
	ld	hl, _edited
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00117
	ld	hl, _redraw
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00117
	ld	hl, _moved
	ld	a, [hl]
	or	a, a
	jp	Z, .l00118
.l00117:
	ld	hl, _idle_frames
	ld	[hl], $00
.l00118:
;src/editor/editor.c:663: if (dirty) {
	ld	hl, _dirty
	ld	a, [hl]
	or	a, a
	jp	Z, .l00123
;src/editor/editor.c:664: Refresh();
	call	_Refresh
;src/editor/editor.c:665: dirty = 0;
	ld	hl, _dirty
	ld	[hl], $00
;src/editor/editor.c:666: edited = 0;
	ld	hl, _edited
	ld	[hl], $00
;src/editor/editor.c:667: normalized = 0;
	ld	hl, _normalized
	ld	[hl], $00
;src/editor/editor.c:668: continue;
	jp	.l00155
.l00123:
;src/editor/editor.c:670: if (edited) {
	ld	hl, _edited
	ld	a, [hl]
	or	a, a
	jp	Z, .l00136
;src/editor/editor.c:671: edited = 0;
	ld	[hl], $00
;src/editor/editor.c:672: normalized = 0;
	ld	hl, _normalized
	ld	[hl], $00
;src/editor/editor.c:673: RenderAfterEdit();
	call	_RenderAfterEdit
;src/editor/editor.c:674: if (!PlaceCursor()) {
	call	_PlaceCursor
	or	a, a
	jp	NZ, .l00136
;src/editor/editor.c:675: if (cursor >= tb_row_starts[tb_rows] && tb_RowStart(cursor) == tb_row_starts[tb_rows]) ScrollDown();
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
	jp	C, .l00130
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
	jp	NZ,.l00304
	ld	a, h
	sub	a, b
	jp	NZ,.l00304
	jp	.l00305
.l00304:
	jp	.l00130
.l00305:
	call	_ScrollDown
	jp	.l00131
.l00130:
;src/editor/editor.c:676: else if (top && cursor < top && tb_RowStart(cursor) == tb_RowStart(top - 1)) ScrollUp(tb_RowStart(cursor));
	ld	hl, _top + 1
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	jp	Z, .l00125
	ld	de, _cursor
	ld	a, [de]
	inc	de
	sub	a, [hl]
	inc	hl
	ld	a, [de]
	sbc	a, [hl]
	jp	NC, .l00125
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
	jp	NZ,.l00306
	ld	a, d
	sub	a, b
	jp	NZ,.l00306
	jp	.l00307
.l00306:
	jp	.l00125
.l00307:
	ld	hl, _cursor
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_tb_RowStart
	ld	e, c
	ld	d, b
	call	_ScrollUp
	jp	.l00131
.l00125:
;src/editor/editor.c:678: Refresh();
	call	_Refresh
;src/editor/editor.c:679: continue;
	jp	.l00155
.l00131:
;src/editor/editor.c:681: PlaceCursor();
	call	_PlaceCursor
.l00136:
;src/editor/editor.c:684: if (redraw) {
	ld	hl, _redraw
	ld	a, [hl]
	or	a, a
	jp	Z, .l00138
;src/editor/editor.c:685: EditorDraw(tb_rows);
	ld	hl, _tb_rows
	ld	a, [hl]
	call	_EditorDraw
;src/editor/editor.c:686: redraw = 0;
	ld	hl, _redraw
	ld	[hl], $00
.l00138:
;src/editor/editor.c:688: if (moved) {
	ld	hl, _moved
	ld	a, [hl]
	or	a, a
	jp	Z, .l00142
;src/editor/editor.c:689: moved = 0;
	ld	[hl], $00
;src/editor/editor.c:690: if (!PlaceCursor()) Refresh();
	call	_PlaceCursor
	or	a, a
	jp	NZ, .l00155
	call	_Refresh
;src/editor/editor.c:691: continue;
	jp	.l00155
.l00142:
;src/editor/editor.c:693: if (idle_frames < NORMALIZE_DELAY) ++idle_frames;
	ld	hl, _idle_frames
	ld	a, [hl]
	sub	a, $1E
	jp	NC, .l00147
	inc	[hl]
	jp	.l00148
.l00147:
;src/editor/editor.c:694: else if (!everdrive && !normalized) normalized = tb_NormalizeStep(); // keeps the .sav readable as text
	ld	hl, _everdrive
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00148
	ld	hl, _normalized
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00148
	call	_tb_NormalizeStep
	ld	hl, _normalized
	ld	[hl], a
.l00148:
;src/editor/editor.c:695: if (++blink_timer == CURSOR_BLINK) EditorShowCursor(0);
	ld	hl, _blink_timer
	inc	[hl]
	ld	a, [hl]
	sub	a, $1E
	jp	NZ,.l00308
	jp	.l00309
.l00308:
	jp	.l00152
.l00309:
	xor	a, a
	call	_EditorShowCursor
	jp	.l00155
.l00152:
;src/editor/editor.c:696: else if (blink_timer == CURSOR_BLINK + CURSOR_BLINK) {
	ld	hl, _blink_timer
	ld	a, [hl]
	sub	a, $3C
	jp	NZ,.l00310
	jp	.l00311
.l00310:
	jp	.l00155
.l00311:
;src/editor/editor.c:697: EditorShowCursor(1);
	ld	a, $01
	call	_EditorShowCursor
;src/editor/editor.c:698: blink_timer = 0;
	ld	hl, _blink_timer
	ld	[hl], $00
	jp	.l00155
.l00157:
;src/editor/editor.c:701: }
	ret
	SECTION FRAGMENT "src/editor/editor.c_CODE",ROMX
	SECTION FRAGMENT "_INITIALIZER",ROM0
	SECTION FRAGMENT "_CABS (ABS)",ROM0
