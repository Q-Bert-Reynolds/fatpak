;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 4.2.0 #13081 (Linux)
;--------------------------------------------------------
	; MODULE editor
	; Generated using the rgbds tokens.

;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	EXPORT _ClockWrite
	EXPORT _ClockRead
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
	EXPORT _tb_ResetChecks
	EXPORT _tb_ClipLength
	EXPORT _tb_Paste
	EXPORT _tb_Copy
	EXPORT _tb_DeleteRange
	EXPORT _tb_Delete
	EXPORT _tb_Insert
	EXPORT _tb_GetChar
	EXPORT _tb_Length
	EXPORT _tb_Clear
	EXPORT _Reboot
	EXPORT _GameLaunch
	EXPORT _InGameHeader
	EXPORT _FileGameFinish
	EXPORT _FileGameCopy
	EXPORT _FileGameOpen
	EXPORT _FileBackupSave
	EXPORT _FileSaveLarge
	EXPORT _FileCommitWindow
	EXPORT _FileScanStep
	EXPORT _DocLineStart
	EXPORT _FileCloseLarge
	EXPORT _FileLoadWindow
	EXPORT _FileLoadLarge
	EXPORT _FileLoadSwap
	EXPORT _FileSaveSwap
	EXPORT _SGBSetDefaultBorder
	EXPORT _FileLoadData
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
	EXPORT _HeadingCharWidth
	EXPORT _EditorInvertCursor
	EXPORT _EditorShowCursor
	EXPORT _WaitFrame
	EXPORT _EditorSetup
	EXPORT _KBListen
	EXPORT _KBPopEvent
	EXPORT _KBPeekKey
	EXPORT _PadPressed
	EXPORT _code_line
	EXPORT _head_level
	EXPORT _pad_mods
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
	EXPORT _osk_blocks
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
_osk_blocks:
	DS 5
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
_pad_mods:
	DS 1
_head_level:
	DS 1
_code_line:
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
;src/editor/editor.c:132: static unsigned char FindRow(unsigned int pos) {
;	---------------------------------
	SECTION FRAGMENT "Page 5",ROMX,BANK[2]
	LOAD FRAGMENT "Page 5 RAM",SRAM,BANK[5]
; Function FindRow
; ---------------------------------
_FindRow:
	dec	sp
	dec	sp
	ld	c, e
	ld	b, d
;src/editor/editor.c:134: for (row = 0; row < tb_rows; ++row) {
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
;src/editor/editor.c:135: if (pos < tb_row_starts[row]) return 0xFF;
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
;src/editor/editor.c:136: if (pos < tb_row_starts[row + 1]) return row;
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
;src/editor/editor.c:134: for (row = 0; row < tb_rows; ++row) {
	ld	hl, sp+1
	inc	[hl]
	ld	a, [hl]
	dec	hl
	ld	[hl], a
	jp	.l00107
.l00105:
;src/editor/editor.c:138: return pos == tb_Length() ? tb_end_row : 0xFF;
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
;src/editor/editor.c:139: }
	inc	sp
	inc	sp
	ret
	SECTION FRAGMENT "src/editor/editor.c FIXED",ROMX,BANK[1]
_menu_items:
	DB "FILE"
	DB $00
	DB $00
	DB $00
	DB $00
	DB $00
	DB $00
	DB $00
	DB $00
	DB $00
	DB $00
	DB "EDIT"
	DB $00
	DB $00
	DB $00
	DB $00
	DB $00
	DB $00
	DB $00
	DB $00
	DB $00
	DB $00
	DB "SETTINGS"
	DB $00
	DB $00
	DB $00
	DB $00
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
	DB $00
	DB "CLOSE"
	DB $00
	DB $00
	DB $00
	DB $00
	DB $00
	DB $00
	DB $00
	DB $00
	DB $00
	SECTION FRAGMENT "src/editor/editor.c FIXED",ROMX,BANK[1]
_submenu_items:
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
	DB $00
	DB "SAVE AS"
	DB $00
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
	DB $00
	DB "CUT"
	DB $00
	DB $00
	DB $00
	DB $00
	DB $00
	DB $00
	DB $00
	DB $00
	DB $00
	DB $00
	DB $00
	DB "COPY"
	DB $00
	DB $00
	DB $00
	DB $00
	DB $00
	DB $00
	DB $00
	DB $00
	DB $00
	DB $00
	DB "PASTE"
	DB $00
	DB $00
	DB $00
	DB $00
	DB $00
	DB $00
	DB $00
	DB $00
	DB $00
	DB "SELECT ALL"
	DB $00
	DB $00
	DB $00
	DB $00
	DB "LINE WRAP"
	DB $00
	DB $00
	DB $00
	DB $00
	DB $00
	DB "FULL SCREEN"
	DB $00
	DB $00
	DB $00
	DB "CLOCK"
	DB $00
	DB $00
	DB $00
	DB $00
	DB $00
	DB $00
	DB $00
	DB $00
	DB $00
	DB "CONTROLS"
	DB $00
	DB $00
	DB $00
	DB $00
	DB $00
	DB $00
	DB "KEYBOARD TEST"
	DB $00
	SECTION FRAGMENT "src/editor/editor.c FIXED",ROMX,BANK[1]
_submenu_starts:
	DB $00	; 0
	DB $04	; 4
	DB $0A	; 10
	DB $0D	; 13
	DB $0F	; 15
	SECTION FRAGMENT "src/editor/editor.c FIXED",ROMX,BANK[1]
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
	DB $00
	SECTION FRAGMENT "Page 6",ROMX,BANK[3]
	LOAD FRAGMENT "Page 6 RAM",SRAM,BANK[6]
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
	DB "Alt+Z  line wrap"
	DB $00
	DB $00
	DB $00
	DB $00
	DB $00
	DB $00
	DB $00
	DB $00
	DB $00
	DB $00
	DB $00
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
	DB "B  backspace    Start  menu"
	DB $00
	DB $00
	DB $00
	DB $00
	DB $00
	DB $00
	DB $00
	DB $00
	DB $00
	DB "D-pad  move    A + D-pad  select"
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
;src/editor/editor.c:145: static unsigned int LineEnd(unsigned char row) {
;	---------------------------------
	SECTION FRAGMENT "Page 5",ROMX,BANK[2]
	LOAD FRAGMENT "Page 5 RAM",SRAM,BANK[5]
; Function LineEnd
; ---------------------------------
_LineEnd:
	ld	c, a
;src/editor/editor.c:146: return row == tb_end_row ? tb_Length() : tb_row_starts[row + 1] - 1;
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
;src/editor/editor.c:147: }
	ret
;src/editor/editor.c:150: static unsigned char PlaceCursor(void) {
;	---------------------------------
	SECTION FRAGMENT "Page 5",ROMX,BANK[2]
	LOAD FRAGMENT "Page 5 RAM",SRAM,BANK[5]
; Function PlaceCursor
; ---------------------------------
_PlaceCursor:
	dec	sp
;src/editor/editor.c:151: unsigned char row = FindRow(cursor), count;
	ld	hl, _cursor
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_FindRow
	ld	hl, sp+0
	ld	[hl], a
;src/editor/editor.c:153: if (row == 0xFF) return 0;
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
;src/editor/editor.c:154: col = cursor - tb_row_starts[row];
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
;src/editor/editor.c:155: count = tb_row_counts[row];
	ld	bc, _tb_row_counts+0
	ld	hl, sp+0
	ld	l, [hl]
	ld	h, $00
	add	hl, bc
	ld	c, l
	ld	b, h
	ld	a, [bc]
;src/editor/editor.c:159: if (col > count || (col == count && cursor != LineEnd(row))) return 0;
	ld	c, a
	ld	b, $00
;src/editor/editor.c:156: if (tb_nowrap) { // its character is drawn, or it's after the line's last one
	ld	hl, _tb_nowrap
	ld	a, [hl]
	or	a, a
	jp	Z, .l00112
;src/editor/editor.c:157: if (col < tb_left) return 0;
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
;src/editor/editor.c:158: col -= tb_left;
	ld	a, e
	ld	hl, _tb_left
	sub	a, [hl]
	ld	e, a
	ld	a, d
	inc	hl
	sbc	a, [hl]
	ld	d, a
;src/editor/editor.c:159: if (col > count || (col == count && cursor != LineEnd(row))) return 0;
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
;src/editor/editor.c:161: else if (col > count) col = count; // hanging spaces
	ld	a, c
	sub	a, e
	ld	a, b
	sbc	a, d
	jp	NC, .l00113
	ld	e, c
	ld	d, b
.l00113:
;src/editor/editor.c:162: tb_found_row = row;
	ld	hl, sp+0
	ld	a, [hl]
	ld	hl, _tb_found_row
	ld	[hl], a
;src/editor/editor.c:163: tb_found_col = (unsigned char)col;
	ld	hl, _tb_found_col
	ld	[hl], e
;src/editor/editor.c:164: if (!keep_x) want_x = RenderCursorX(tb_found_col);
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
;src/editor/editor.c:165: keep_x = 0;
	ld	hl, _keep_x
	ld	[hl], $00
;src/editor/editor.c:166: blink_timer = 0;
	ld	hl, _blink_timer
	ld	[hl], $00
;src/editor/editor.c:167: EditorInvertCursor(GetSelection() && cursor == sel_start); // the selection starts at the cursor's x
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
;src/editor/editor.c:168: EditorShowCursor(1);
	ld	a, $01
	call	_EditorShowCursor
;src/editor/editor.c:169: bars_changed = 1;
	ld	hl, _bars_changed
	ld	[hl], $01
;src/editor/editor.c:170: return 1;
	ld	a, $01
.l00116:
;src/editor/editor.c:171: }
	inc	sp
	ret
;src/editor/editor.c:174: static unsigned int PosAtX(unsigned char row, unsigned char x) {
;	---------------------------------
	SECTION FRAGMENT "Page 5",ROMX,BANK[2]
	LOAD FRAGMENT "Page 5 RAM",SRAM,BANK[5]
; Function PosAtX
; ---------------------------------
_PosAtX:
	add	sp, -9
	ld	hl, sp+7
	ld	[hl], a
	dec	hl
	ld	[hl], e
;src/editor/editor.c:175: unsigned char* attrs = (unsigned char*)RowAddress(row) + (tile_attrs - tile_buffer);
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
;src/editor/editor.c:176: unsigned char count = tb_row_counts[row], col = 0, width;
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
;src/editor/editor.c:178: while (col < count) {
	ld	hl, sp+8
	ld	[hl], $00
.l00103:
	ld	hl, sp+8
	ld	a, [hl]
	ld	hl, sp+2
	sub	a, [hl]
	jp	NC, .l00105
;src/editor/editor.c:179: width = attrs[col] & STYLE_WIDTH;
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
;src/editor/editor.c:180: if (x < ((width + 1) >> 1)) break;
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
;src/editor/editor.c:181: x = x < width ? 0 : x - width;
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
;src/editor/editor.c:182: ++col;
	inc	hl
	inc	hl
	inc	[hl]
	jp	.l00103
.l00105:
;src/editor/editor.c:184: pos = tb_row_starts[row] + col;
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
;src/editor/editor.c:185: if (tb_nowrap) {
	ld	hl, _tb_nowrap
	ld	a, [hl]
	or	a, a
	jp	Z, .l00107
;src/editor/editor.c:186: pos += tb_left;
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
;src/editor/editor.c:187: return pos > LineEnd(row) ? LineEnd(row) : pos;
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
;src/editor/editor.c:189: if (col == count && pos == tb_row_starts[row + 1] && tb_end_row != row) --pos; // stay on wrapped row
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
;src/editor/editor.c:190: return pos;
	ld	hl, sp+4
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
.l00112:
;src/editor/editor.c:191: }
	add	sp, 9
	ret
;src/editor/editor.c:194: static unsigned char TextRows(void) {
;	---------------------------------
	SECTION FRAGMENT "Page 5",ROMX,BANK[2]
	LOAD FRAGMENT "Page 5 RAM",SRAM,BANK[5]
; Function TextRows
; ---------------------------------
_TextRows:
;src/editor/editor.c:195: return TB_ROWS - (bars << 1) - (osk_shown ? OSK_ROWS : 0);
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
;src/editor/editor.c:196: }
	ret
;src/editor/editor.c:205: static unsigned char IsOSKBlock(unsigned char block) {
;	---------------------------------
	SECTION FRAGMENT "Page 5",ROMX,BANK[2]
	LOAD FRAGMENT "Page 5 RAM",SRAM,BANK[5]
; Function IsOSKBlock
; ---------------------------------
_IsOSKBlock:
	ld	c, a
;src/editor/editor.c:207: for (i = 0; i < OSK_ROWS; ++i) if (osk_blocks[i] == block) return 1;
	ld	d, $00
.l00104:
	ld	a, LOW(_osk_blocks)
	add	a, d
	ld	l, a
;	spillPairReg hl
;	spillPairReg hl
	ld	a, HIGH(_osk_blocks)
	adc	a, $00
	ld	h, a
;	spillPairReg hl
;	spillPairReg hl
	ld	a, [hl]
	sub	a, c
	jp	NZ,.l00123
	jp	.l00124
.l00123:
	jp	.l00105
.l00124:
	ld	a, $01
	jp	.l00106
.l00105:
	inc	d
	ld	a, d
	sub	a, $05
	jp	C, .l00104
;src/editor/editor.c:208: return 0;
	xor	a, a
.l00106:
;src/editor/editor.c:209: }
	ret
;src/editor/editor.c:211: static void Layout(void) {
;	---------------------------------
	SECTION FRAGMENT "Page 5",ROMX,BANK[2]
	LOAD FRAGMENT "Page 5 RAM",SRAM,BANK[5]
; Function Layout
; ---------------------------------
_Layout:
	add	sp, -8
;src/editor/editor.c:212: unsigned char row, line, block, map_row, i = 0, win_row = BG_MAP_ROWS, osk = TB_ROWS - (bars << 1) - tb_rows;
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
;src/editor/editor.c:213: unsigned char length = tb_rows + render_gbc, first = ring_blocks[ring_pos];
	ld	a, [hl]
	ld	hl, _render_gbc
	add	a, [hl]
	ld	hl, sp+0
	ld	[hl], a
	ld	a, LOW(_ring_blocks)
	ld	hl, _ring_pos
	add	a, [hl]
	ld	e, a
	ld	a, HIGH(_ring_blocks)
	adc	a, $00
	ld	d, a
	ld	a, [de]
	ld	hl, sp+2
	ld	[hl], a
;src/editor/editor.c:214: for (block = 0; block < TB_ROWS + render_gbc; ++block) {
	ld	hl, sp+7
	ld	[hl], $00
	ld	b, $00
.l00129:
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
	jp	Z, .l00220
	bit	7, d
	jp	NZ, .l00221
	cp	a, a
	jp	.l00221
.l00220:
	bit	7, d
	jp	Z, .l00221
	scf
.l00221:
	jp	NC, .l00111
;src/editor/editor.c:215: if (bars && (block == HEADER_BLOCK || block == STATUS_BLOCK)) continue;
	ld	hl, _bars
	ld	a, [hl]
	or	a, a
	jp	Z, .l00102
	ld	a, b
	sub	a, $08
	jp	NZ,.l00222
	jp	.l00110
.l00222:
	ld	a, b
	sub	a, $11
	jp	NZ,.l00223
	jp	.l00110
.l00223:
.l00102:
;src/editor/editor.c:216: if (osk && IsOSKBlock(block)) continue;
	ld	a, c
	or	a, a
	jp	Z, .l00106
	push	bc
	ld	a, b
	call	_IsOSKBlock
	pop	bc
	or	a, a
	jp	NZ, .l00110
.l00106:
;src/editor/editor.c:217: if (block == first) ring_pos = i;
	ld	hl, sp+2
	ld	a, [hl]
	sub	a, b
	jp	NZ,.l00224
	jp	.l00225
.l00224:
	jp	.l00109
.l00225:
	ld	hl, sp+7
	ld	a, [hl]
	ld	hl, _ring_pos
	ld	[hl], a
.l00109:
;src/editor/editor.c:218: ring_blocks[i++] = block;
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
.l00110:
;src/editor/editor.c:214: for (block = 0; block < TB_ROWS + render_gbc; ++block) {
	inc	b
	jp	.l00129
.l00111:
;src/editor/editor.c:220: if (ring_pos >= length) ring_pos = 0;
	ld	hl, _ring_pos
	ld	a, [hl]
	ld	hl, sp+0
	sub	a, [hl]
	jp	C, .l00113
	ld	hl, _ring_pos
	ld	[hl], $00
.l00113:
;src/editor/editor.c:221: i = ring_pos;
	ld	hl, _ring_pos
	ld	a, [hl]
	ld	hl, sp+5
	ld	[hl], a
;src/editor/editor.c:222: render_pending = 0;
	ld	hl, _render_pending
	ld	[hl], $00
;src/editor/editor.c:223: render_text_top = bars;
	ld	hl, _bars
	ld	a, [hl]
	ld	hl, _render_text_top
	ld	[hl], a
;src/editor/editor.c:224: for (row = 0; row < TB_ROWS; ++row) {
	ld	hl, sp+6
	ld	[hl], $20
	inc	hl
	ld	[hl], $00
.l00130:
;src/editor/editor.c:225: line = row - bars;
	ld	hl, sp+7
	ld	a, [hl]
	ld	hl, _bars
	sub	a, [hl]
	ld	hl, sp+4
	ld	[hl], a
;src/editor/editor.c:226: if (line < tb_rows) {
	ld	a, [hl]
	ld	hl, _tb_rows
	sub	a, [hl]
	jp	NC, .l00122
;src/editor/editor.c:227: block = ring_blocks[i];
	ld	de, _ring_blocks
	ld	hl, sp+5
	ld	l, [hl]
	ld	h, $00
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
	dec	hl
	ld	[hl], a
;src/editor/editor.c:228: if (++i == length) i = 0;
	ld	hl, sp+5
	inc	[hl]
	ld	hl, sp+0
	ld	a, [hl]
	ld	hl, sp+5
	sub	a, [hl]
	jp	NZ,.l00226
	jp	.l00227
.l00226:
	jp	.l00115
.l00227:
	ld	hl, sp+5
	ld	[hl], $00
.l00115:
;src/editor/editor.c:229: map_row = (ring_top + line) & (BG_MAP_ROWS - 1);
	ld	hl, _ring_top
	ld	a, [hl]
	ld	hl, sp+4
	add	a, [hl]
	and	a, $1F
	dec	hl
	dec	hl
	ld	[hl], a
;src/editor/editor.c:230: render_row_fonts[row] = font;
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
	jp	.l00123
.l00122:
;src/editor/editor.c:233: map_row = win_row++;
	ld	hl, sp+6
	ld	a, [hl]
	ld	hl, sp+2
	ld	[hl], a
	ld	hl, sp+6
	inc	[hl]
;src/editor/editor.c:234: if (bars && (!row || row == TB_ROWS - 1)) {
	ld	hl, _bars
	ld	a, [hl]
	or	a, a
	jp	Z, .l00117
	ld	hl, sp+7
	ld	a, [hl]
	or	a, a
	jp	Z, .l00116
	ld	a, [hl]
	sub	a, $11
	jp	NZ,.l00228
	jp	.l00229
.l00228:
	jp	.l00117
.l00229:
.l00116:
;src/editor/editor.c:235: block = row ? STATUS_BLOCK : HEADER_BLOCK;
	ld	hl, sp+7
	ld	a, [hl]
	or	a, a
	jp	Z, .l00134
	ld	bc, $0011
	jp	.l00135
.l00134:
	ld	bc, $0008
.l00135:
	ld	hl, sp+1
	ld	[hl], c
;src/editor/editor.c:236: line = row ? STATUS_LINE : HEADER_LINE;
	ld	hl, sp+7
	ld	a, [hl]
	or	a, a
	jp	Z, .l00136
	ld	hl, sp+3
	ld	[hl], $13
	xor	a, a
	inc	hl
	ld	[hl], a
	jp	.l00137
.l00136:
	ld	hl, sp+3
	ld	[hl], $12
	xor	a, a
	inc	hl
	ld	[hl], a
.l00137:
	ld	hl, sp+3
	ld	a, [hl]
	inc	hl
	ld	[hl], a
;src/editor/editor.c:237: render_row_fonts[row] = FONT_VWF;
	ld	de, _render_row_fonts
	ld	hl, sp+7
	ld	l, [hl]
	ld	h, $00
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, $01
	ld	[bc], a
	jp	.l00123
.l00117:
;src/editor/editor.c:240: block = osk_blocks[line - tb_rows];
	ld	hl, sp+4
	ld	a, [hl]
	ld	hl, _tb_rows
	sub	a, [hl]
	ld	c, a
	ld	hl, _osk_blocks
	ld	b, $00
	add	hl, bc
	ld	a, [hl]
	ld	hl, sp+1
	ld	[hl], a
;src/editor/editor.c:241: render_row_fonts[row] = FONT_MONO;
	ld	de, _render_row_fonts
	ld	hl, sp+7
	ld	l, [hl]
	ld	h, $00
	add	hl, de
	ld	c, l
	ld	b, h
	xor	a, a
	ld	[bc], a
.l00123:
;src/editor/editor.c:244: render_row_blocks[row] = block;
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
;src/editor/editor.c:245: render_row_lines[row] = line;
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
;src/editor/editor.c:246: if (map_blocks[map_row] != block || block_map_rows[block] != map_row) { // a block can still be listed in a map row it left
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
	jp	NZ,.l00230
	jp	.l00231
.l00230:
	jp	.l00124
.l00231:
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
	jp	NZ,.l00232
	jp	.l00131
.l00232:
.l00124:
;src/editor/editor.c:247: map_blocks[map_row] = block;
	ld	hl, sp+1
	ld	a, [hl]
	ld	[bc], a
;src/editor/editor.c:248: RenderSetMapRow(map_row, block);
	ld	e, [hl]
	inc	hl
	ld	a, [hl]
	call	_RenderSetMapRow
.l00131:
;src/editor/editor.c:224: for (row = 0; row < TB_ROWS; ++row) {
	ld	hl, sp+7
	inc	[hl]
	ld	a, [hl]
	sub	a, $12
	jp	C, .l00130
;src/editor/editor.c:251: render_pending_scy = (ring_top - bars) << 3;
	ld	hl, _ring_top
	ld	a, [hl]
	ld	hl, _bars
	sub	a, [hl]
	add	a, a
	add	a, a
	add	a, a
	ld	hl, _render_pending_scy
	ld	[hl], a
;src/editor/editor.c:252: RenderStage();
	call	_RenderStage
.l00132:
;src/editor/editor.c:253: }
	add	sp, 8
	ret
;src/editor/editor.c:256: static void ScrollRing(unsigned char down) {
;	---------------------------------
	SECTION FRAGMENT "Page 5",ROMX,BANK[2]
	LOAD FRAGMENT "Page 5 RAM",SRAM,BANK[5]
; Function ScrollRing
; ---------------------------------
_ScrollRing:
	add	sp, -7
	ld	hl, sp+6
	ld	[hl], a
;src/editor/editor.c:257: unsigned char length = tb_rows + render_gbc;
	ld	hl, _tb_rows
	ld	a, [hl]
	ld	hl, _render_gbc
	add	a, [hl]
	ld	hl, sp+5
	ld	[hl], a
;src/editor/editor.c:259: ring_pos = ring_pos == length - 1 ? 0 : ring_pos + 1;
	ld	hl, _ring_pos
	ld	a, [hl]
	ld	hl, sp+0
	ld	[hl], a
;src/editor/editor.c:260: ring_top = (ring_top + 1) & (BG_MAP_ROWS - 1);
	ld	hl, _ring_top
	ld	a, [hl]
	ld	hl, sp+1
	ld	[hl], a
;src/editor/editor.c:258: if (down) {
	ld	hl, sp+6
	ld	a, [hl]
	or	a, a
	jp	Z, .l00102
;src/editor/editor.c:259: ring_pos = ring_pos == length - 1 ? 0 : ring_pos + 1;
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
;src/editor/editor.c:260: ring_top = (ring_top + 1) & (BG_MAP_ROWS - 1);
	ld	hl, sp+1
	ld	a, [hl]
	inc	a
	and	a, $1F
	ld	hl, _ring_top
	ld	[hl], a
	jp	.l00103
.l00102:
;src/editor/editor.c:263: ring_pos = ring_pos ? ring_pos - 1 : length - 1;
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
;src/editor/editor.c:264: ring_top = (ring_top - 1) & (BG_MAP_ROWS - 1);
	ld	hl, sp+1
	ld	a, [hl]
	dec	a
	and	a, $1F
	ld	hl, _ring_top
	ld	[hl], a
.l00103:
;src/editor/editor.c:266: Layout();
	call	_Layout
.l00104:
;src/editor/editor.c:267: }
	add	sp, 7
	ret
;src/editor/editor.c:270: static void ScrollDown(void) {
;	---------------------------------
	SECTION FRAGMENT "Page 5",ROMX,BANK[2]
	LOAD FRAGMENT "Page 5 RAM",SRAM,BANK[5]
; Function ScrollDown
; ---------------------------------
_ScrollDown:
;src/editor/editor.c:271: ScrollRing(1);
	ld	a, $01
	call	_ScrollRing
;src/editor/editor.c:272: tb_ScrollRows(1);
	ld	a, $01
	call	_tb_ScrollRows
;src/editor/editor.c:273: tb_RenderRows(tb_rows - 1, tb_rows);
	ld	hl, _tb_rows
	ld	c, [hl]
	dec	c
	ld	e, [hl]
	ld	a, c
	call	_tb_RenderRows
;src/editor/editor.c:274: top = tb_row_starts[0];
	ld	de, _tb_row_starts + 0
	ld	a, [de]
	ld	hl, _top
	ld	[hl], a
	inc	de
	ld	a, [de]
	inc	hl
	ld	[hl], a
;src/editor/editor.c:275: redraw = 1;
	ld	hl, _redraw
	ld	[hl], $01
.l00101:
;src/editor/editor.c:276: }
	ret
;src/editor/editor.c:279: static void ScrollUp(unsigned int new_top) {
;	---------------------------------
	SECTION FRAGMENT "Page 5",ROMX,BANK[2]
	LOAD FRAGMENT "Page 5 RAM",SRAM,BANK[5]
; Function ScrollUp
; ---------------------------------
_ScrollUp:
	ld	c, e
	ld	b, d
;src/editor/editor.c:280: ScrollRing(0);
	push	bc
	xor	a, a
	call	_ScrollRing
	pop	bc
;src/editor/editor.c:281: tb_ScrollRows(0);
	push	bc
	xor	a, a
	call	_tb_ScrollRows
	pop	bc
;src/editor/editor.c:282: tb_row_starts[0] = new_top;
	ld	hl, _tb_row_starts
	ld	[hl], c
	inc	hl
	ld	[hl], b
;src/editor/editor.c:283: tb_RenderRows(0, 1);
	push	bc
	ld	e, $01
	xor	a, a
	call	_tb_RenderRows
	pop	bc
;src/editor/editor.c:284: top = new_top;
	ld	hl, _top
	ld	[hl], c
	inc	hl
	ld	[hl], b
;src/editor/editor.c:285: redraw = 1;
	ld	hl, _redraw
	ld	[hl], $01
.l00101:
;src/editor/editor.c:286: }
	ret
;src/editor/editor.c:290: static void RenderAfterEdit(void) {
;	---------------------------------
	SECTION FRAGMENT "Page 5",ROMX,BANK[2]
	LOAD FRAGMENT "Page 5 RAM",SRAM,BANK[5]
; Function RenderAfterEdit
; ---------------------------------
_RenderAfterEdit:
	add	sp, -16
;src/editor/editor.c:291: unsigned char row = edit_row, end_row = tb_end_row, i;
	ld	hl, _edit_row
	ld	a, [hl]
	ld	hl, sp+14
	ld	[hl], a
	ld	hl, _tb_end_row
	ld	a, [hl]
	ld	hl, sp+0
	ld	[hl], a
;src/editor/editor.c:292: unsigned int old_next, old_state, expected, delta = (unsigned int)(int)edit_delta;
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
;src/editor/editor.c:293: if (row) --row; // the previous row's wrapping can change too
	ld	hl, sp+14
	ld	a, [hl]
	or	a, a
	jp	Z, .l00102
	dec	[hl]
.l00102:
;src/editor/editor.c:294: if (end_row != 0xFF && end_row >= row) tb_end_row = 0xFF; // found again while scanning
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
;src/editor/editor.c:295: for (; row < tb_rows; ++row) {
	ld	hl, sp+15
	ld	a, [hl]
	ld	hl, _tb_rows
	sub	a, [hl]
	jp	NC, .l00114
;src/editor/editor.c:296: old_next = tb_row_starts[row + 1];
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
;src/editor/editor.c:297: old_state = tb_row_states[row + 1];
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
;src/editor/editor.c:298: expected = old_next + delta;
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
;src/editor/editor.c:299: tb_RenderRows(row, row + 1);
	push	bc
	ld	hl, sp+7
	ld	e, [hl]
	ld	hl, sp+17
	ld	a, [hl]
	call	_tb_RenderRows
	pop	bc
;src/editor/editor.c:300: if (old_next > edit_pos && tb_row_starts[row + 1] == expected && tb_row_states[row + 1] == old_state) {
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
;src/editor/editor.c:301: for (i = row + 2; i <= tb_rows; ++i) tb_row_starts[i] += delta; // rows below just moved
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
;src/editor/editor.c:302: if (end_row != 0xFF && end_row > row) tb_end_row = end_row;
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
;src/editor/editor.c:303: break;
	jp	.l00114
.l00120:
;src/editor/editor.c:295: for (; row < tb_rows; ++row) {
	ld	hl, sp+15
	inc	[hl]
	ld	a, [hl]
	dec	hl
	ld	[hl], a
	jp	.l00119
.l00114:
;src/editor/editor.c:306: redraw = 1;
	ld	hl, _redraw
	ld	[hl], $01
.l00121:
;src/editor/editor.c:307: }
	add	sp, 16
	ret
;src/editor/editor.c:310: static void Edited(unsigned int pos, signed char delta) {
;	---------------------------------
	SECTION FRAGMENT "Page 5",ROMX,BANK[2]
	LOAD FRAGMENT "Page 5 RAM",SRAM,BANK[5]
; Function Edited
; ---------------------------------
_Edited:
	ld	c, a
;src/editor/editor.c:311: modified = 1;
	ld	hl, _modified
	ld	[hl], $01
;src/editor/editor.c:312: if (edited) dirty = 1;
	ld	hl, _edited
	ld	a, [hl]
	or	a, a
	jp	Z, .l00102
	ld	hl, _dirty
	ld	[hl], $01
.l00102:
;src/editor/editor.c:313: edited = 1;
	ld	hl, _edited
	ld	[hl], $01
;src/editor/editor.c:314: edit_row = tb_found_row;
	ld	hl, _tb_found_row
	ld	a, [hl]
	ld	hl, _edit_row
	ld	[hl], a
;src/editor/editor.c:315: edit_pos = pos;
	ld	hl, _edit_pos
	ld	[hl], e
	inc	hl
	ld	[hl], d
;src/editor/editor.c:316: edit_delta = delta;
	ld	hl, _edit_delta
	ld	[hl], c
.l00103:
;src/editor/editor.c:317: }
	ret
;src/editor/editor.c:320: static unsigned char GetSelection(void) {
;	---------------------------------
	SECTION FRAGMENT "Page 6",ROMX,BANK[3]
	LOAD FRAGMENT "Page 6 RAM",SRAM,BANK[6]
; Function GetSelection
; ---------------------------------
_GetSelection:
;src/editor/editor.c:321: if (!selecting || anchor == cursor) return 0;
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
;src/editor/editor.c:323: sel_start = anchor;
	ld	hl, _anchor
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
;src/editor/editor.c:324: sel_end = cursor;
	ld	hl, _cursor
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
;src/editor/editor.c:322: if (anchor < cursor) {
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
;src/editor/editor.c:323: sel_start = anchor;
	ld	hl, _sel_start
	ld	[hl], c
	inc	hl
	ld	[hl], b
;src/editor/editor.c:324: sel_end = cursor;
	ld	hl, _sel_end
	ld	[hl], e
	inc	hl
	ld	[hl], d
	jp	.l00106
.l00105:
;src/editor/editor.c:327: sel_start = cursor;
	ld	hl, _sel_start
	ld	[hl], e
	inc	hl
	ld	[hl], d
;src/editor/editor.c:328: sel_end = anchor;
	ld	hl, _sel_end
	ld	[hl], c
	inc	hl
	ld	[hl], b
.l00106:
;src/editor/editor.c:330: return 1;
	ld	a, $01
.l00107:
;src/editor/editor.c:331: }
	ret
;src/editor/editor.c:333: static void ClearSelection(void) {
;	---------------------------------
	SECTION FRAGMENT "Page 5",ROMX,BANK[2]
	LOAD FRAGMENT "Page 5 RAM",SRAM,BANK[5]
; Function ClearSelection
; ---------------------------------
_ClearSelection:
;src/editor/editor.c:334: if (selecting) redraw = 1;
	ld	hl, _selecting
	ld	a, [hl]
	or	a, a
	jp	Z, .l00102
	ld	hl, _redraw
	ld	[hl], $01
.l00102:
;src/editor/editor.c:335: selecting = 0;
	ld	hl, _selecting
	ld	[hl], $00
.l00103:
;src/editor/editor.c:336: }
	ret
;src/editor/editor.c:339: static void NoHighlight(void) {
;	---------------------------------
	SECTION FRAGMENT "Page 5",ROMX,BANK[2]
	LOAD FRAGMENT "Page 5 RAM",SRAM,BANK[5]
; Function NoHighlight
; ---------------------------------
_NoHighlight:
;src/editor/editor.c:341: for (i = 0; i < TB_ROWS * 2; ++i) render_sel[i] = 0;
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
;src/editor/editor.c:342: if (bars) render_sel[1] = render_sel[(TB_ROWS << 1) - 1] = 0xFF;
	ld	hl, _bars
	ld	a, [hl]
	or	a, a
	jp	Z, .l00106
	ld	hl, (_render_sel + 35)
	ld	[hl], $FF
	ld	hl, (_render_sel + 1)
	ld	[hl], $FF
.l00106:
;src/editor/editor.c:343: }
	ret
;src/editor/editor.c:346: static void SetHighlight(void) {
;	---------------------------------
	SECTION FRAGMENT "Page 5",ROMX,BANK[2]
	LOAD FRAGMENT "Page 5 RAM",SRAM,BANK[5]
; Function SetHighlight
; ---------------------------------
_SetHighlight:
	add	sp, -12
;src/editor/editor.c:349: NoHighlight();
	call	_NoHighlight
;src/editor/editor.c:350: if (!GetSelection()) return;
	call	_GetSelection__far
	ld	c, a
	ld	a, c
	or	a, a
	jp	NZ, .l00140
	jp	.l00119
;src/editor/editor.c:351: for (row = 0; row < tb_rows; ++row) {
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
;src/editor/editor.c:352: row_start = tb_row_starts[row];
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
;src/editor/editor.c:353: next = tb_row_starts[row + 1];
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
;src/editor/editor.c:354: if (sel_end <= row_start) break;
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
;src/editor/editor.c:355: if (sel_start >= next) continue;
	ld	de, _sel_start
	ld	hl, sp+9
	ld	a, [de]
	inc	de
	sub	a, [hl]
	inc	hl
	ld	a, [de]
	sbc	a, [hl]
	jp	NC, .l00115
;src/editor/editor.c:356: count = tb_row_counts[row];
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
;src/editor/editor.c:357: base = row_start + (tb_nowrap ? tb_left : 0); // first drawn character
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
;src/editor/editor.c:358: first = 0;
	inc	hl
	ld	[hl], $00
;src/editor/editor.c:359: if (sel_start > base) first = sel_start - base > count ? count : (unsigned char)(sel_start - base);
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
;src/editor/editor.c:360: if (sel_end < next || row == tb_end_row) { // ends in this row
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
;src/editor/editor.c:361: end = sel_end <= base ? 0 : sel_end - base > count ? count : (unsigned char)(sel_end - base);
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
;src/editor/editor.c:362: if (end <= first) continue;
	ld	hl, sp+5
	ld	a, [hl]
	ld	hl, sp+10
	sub	a, [hl]
	jp	C, .l00113
	jp	.l00115
.l00112:
;src/editor/editor.c:364: else end = 0xFF; // continues, so the line feed or wrap is selected too
	ld	hl, sp+10
	ld	[hl], $FF
.l00113:
;src/editor/editor.c:365: render_sel[(row + bars) << 1] = first;
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
;src/editor/editor.c:366: render_sel[((row + bars) << 1) + 1] = end;
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
;src/editor/editor.c:351: for (row = 0; row < tb_rows; ++row) {
	ld	hl, sp+11
	inc	[hl]
	jp	.l00118
.l00119:
;src/editor/editor.c:368: }
	add	sp, 12
	ret
;src/editor/editor.c:371: static unsigned int LinesBefore(unsigned int pos) {
;	---------------------------------
	SECTION FRAGMENT "Page 5",ROMX,BANK[2]
	LOAD FRAGMENT "Page 5 RAM",SRAM,BANK[5]
; Function LinesBefore
; ---------------------------------
_LinesBefore:
;src/editor/editor.c:372: if (pos >= counted_pos) counted_lines += tb_CountLines(counted_pos, pos);
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
;src/editor/editor.c:373: else if (pos < counted_pos - pos) counted_lines = tb_CountLines(0, pos);
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
;src/editor/editor.c:374: else counted_lines -= tb_CountLines(pos, counted_pos);
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
;src/editor/editor.c:375: counted_pos = pos;
	ld	hl, _counted_pos
	ld	[hl], e
	inc	hl
	ld	[hl], d
;src/editor/editor.c:376: return counted_lines;
	ld	hl, _counted_lines
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
.l00107:
;src/editor/editor.c:377: }
	ret
;src/editor/editor.c:380: static void CountEdit(unsigned int pos, unsigned char c, unsigned char inserted) {
;	---------------------------------
	SECTION FRAGMENT "Page 5",ROMX,BANK[2]
	LOAD FRAGMENT "Page 5 RAM",SRAM,BANK[5]
; Function CountEdit
; ---------------------------------
_CountEdit:
	ld	c, a
;src/editor/editor.c:381: if (pos >= counted_pos) return;
	ld	hl, _counted_pos
	ld	a, e
	sub	a, [hl]
	inc	hl
	ld	a, d
	sbc	a, [hl]
	jp	C, .l00102
	jp	.l00110
.l00102:
;src/editor/editor.c:384: if (c == ASCII_LF) ++counted_lines;
	ld	a, c
	sub	a, $0A
	jp	NZ,.l00132
	ld	a,$01
	jp	.l00133
.l00132:
	xor	a,a
.l00133:
	ld	c, a
;src/editor/editor.c:382: if (inserted) {
	ld	hl, sp+2
	ld	a, [hl]
	or	a, a
	jp	Z, .l00108
;src/editor/editor.c:383: ++counted_pos;
	ld	hl, _counted_pos
	inc	[hl]
	jp	NZ, .l00134
	inc	hl
	inc	[hl]
.l00134:
;src/editor/editor.c:384: if (c == ASCII_LF) ++counted_lines;
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
;src/editor/editor.c:387: --counted_pos;
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
;src/editor/editor.c:388: if (c == ASCII_LF) --counted_lines;
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
;src/editor/editor.c:390: }
	pop	hl
	inc	sp
	jp hl
;src/editor/editor.c:393: static void Uncount(unsigned int pos) {
;	---------------------------------
	SECTION FRAGMENT "Page 5",ROMX,BANK[2]
	LOAD FRAGMENT "Page 5 RAM",SRAM,BANK[5]
; Function Uncount
; ---------------------------------
_Uncount:
;src/editor/editor.c:394: if (pos < counted_pos) counted_pos = counted_lines = 0;
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
;src/editor/editor.c:395: }
	ret
;src/editor/editor.c:398: static unsigned char RowEndsLine(unsigned char row) {
;	---------------------------------
	SECTION FRAGMENT "Page 5",ROMX,BANK[2]
	LOAD FRAGMENT "Page 5 RAM",SRAM,BANK[5]
; Function RowEndsLine
; ---------------------------------
_RowEndsLine:
	ld	e, a
;src/editor/editor.c:399: return tb_GetChar(tb_row_starts[row + 1] - 1) == ASCII_LF;
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
;src/editor/editor.c:400: }
	ret
;src/editor/editor.c:402: static unsigned int CursorLine(void) {
;	---------------------------------
	SECTION FRAGMENT "Page 5",ROMX,BANK[2]
	LOAD FRAGMENT "Page 5 RAM",SRAM,BANK[5]
; Function CursorLine
; ---------------------------------
_CursorLine:
;src/editor/editor.c:403: unsigned int line = LinesBefore(top) + 1;
	ld	hl, _top
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_LinesBefore
	inc	bc
;src/editor/editor.c:405: for (row = 0; row < tb_found_row; ++row) if (RowEndsLine(row)) ++line;
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
;src/editor/editor.c:406: return line;
.l00107:
;src/editor/editor.c:407: }
	ret
;src/editor/editor.c:409: static unsigned int CursorColumn(void) {
;	---------------------------------
	SECTION FRAGMENT "Page 5",ROMX,BANK[2]
	LOAD FRAGMENT "Page 5 RAM",SRAM,BANK[5]
; Function CursorColumn
; ---------------------------------
_CursorColumn:
	dec	sp
	dec	sp
;src/editor/editor.c:410: unsigned char row = tb_found_row;
	ld	hl, _tb_found_row
	ld	c, [hl]
;src/editor/editor.c:412: while (row && !RowEndsLine(row - 1)) --row;
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
;src/editor/editor.c:413: start = tb_row_starts[row];
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
;src/editor/editor.c:414: if (!row && start && tb_GetChar(start - 1) != ASCII_LF) start = tb_LineStart(start);
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
;src/editor/editor.c:415: return cursor - start + 1;
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
;src/editor/editor.c:416: }
	inc	sp
	inc	sp
	ret
;src/editor/editor.c:418: static char* PutText(char* dest, const char* text) {
;	---------------------------------
	SECTION FRAGMENT "Page 5",ROMX,BANK[2]
	LOAD FRAGMENT "Page 5 RAM",SRAM,BANK[5]
; Function PutText
; ---------------------------------
_PutText:
;src/editor/editor.c:419: while (*text) *dest++ = *text++;
.l00101:
	ld	a, [bc]
	or	a, a
	jp	Z, .l00103
	inc	bc
	ld	[de], a
	inc	de
	jp	.l00101
.l00103:
;src/editor/editor.c:420: return dest;
	ld	c, e
	ld	b, d
.l00104:
;src/editor/editor.c:421: }
	ret
;src/editor/editor.c:425: static char* PutNumber(char* dest, unsigned long n) {
;	---------------------------------
	SECTION FRAGMENT "Page 4",ROMX,BANK[2]
	LOAD FRAGMENT "Page 4 RAM",SRAM,BANK[4]
; Function PutNumber
; ---------------------------------
_PutNumber:
	add	sp, -10
	ld	hl, sp+6
	ld	[hl], e
	inc	hl
	ld	[hl], d
;src/editor/editor.c:426: unsigned char i, digit, started = 0;
	ld	hl, sp+4
	ld	[hl], $00
;src/editor/editor.c:427: for (i = 0; i < 6; ++i) {
	ld	hl, sp+8
	ld	[hl], $00
;src/editor/editor.c:429: while (n >= powers_of_ten[i]) {
.l00113:
	ld	hl, sp+9
	ld	[hl], $30
.l00101:
	ld	hl, sp+8
	ld	a, [hl]
	ld	c, $00
	ld	l, a
	ld	h, c
	add	hl, hl
	add	hl, hl
	ld	de, _powers_of_ten
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
	inc	de
	ld	a, [de]
	inc	hl
	ld	[hl], a
	inc	de
	ld	a, [de]
	inc	hl
	ld	[hl], a
	ld	hl, sp+12
	ld	e, l
	ld	d, h
	ld	hl, sp+0
	ld	a, [de]
	inc	de
	sub	a, [hl]
	inc	hl
	ld	a, [de]
	inc	de
	sbc	a, [hl]
	inc	hl
	ld	a, [de]
	inc	de
	sbc	a, [hl]
	inc	hl
	ld	a, [de]
	sbc	a, [hl]
	jp	C, .l00117
;src/editor/editor.c:430: n -= powers_of_ten[i];
	ld	hl, sp+13
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, e
	ld	hl, sp+0
	sub	a, [hl]
	ld	e, a
	ld	a, d
	inc	hl
	sbc	a, [hl]
	push	af
	ld	hl, sp+15
	ld	[hl], a
	dec	hl
	ld	[hl], e
	ld	hl, sp+17
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, sp+4
	pop	af
	ld	a, e
	sbc	a, [hl]
	ld	e, a
	ld	a, d
	inc	hl
	sbc	a, [hl]
	ld	hl, sp+15
	ld	[hl], a
	dec	hl
	ld	[hl], e
;src/editor/editor.c:431: ++digit;
	ld	hl, sp+9
	inc	[hl]
	jp	.l00101
.l00117:
	ld	hl, sp+9
	ld	a, [hl]
	ld	hl, sp+5
	ld	[hl], a
;src/editor/editor.c:433: if (started || digit != '0') {
	dec	hl
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00104
	ld	hl, sp+9
	ld	a, [hl]
	sub	a, $30
	jp	NZ,.l00139
	jp	.l00109
.l00139:
.l00104:
;src/editor/editor.c:434: *dest++ = digit;
	ld	hl, sp+7
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	dec	hl
	dec	hl
	ld	a, [hl]
	ld	[de], a
	inc	hl
	inc	[hl]
	jp	NZ, .l00140
	inc	hl
	inc	[hl]
.l00140:
;src/editor/editor.c:435: started = 1;
	ld	hl, sp+4
	ld	[hl], $01
.l00109:
;src/editor/editor.c:427: for (i = 0; i < 6; ++i) {
	ld	hl, sp+8
	inc	[hl]
	ld	a, [hl]
	sub	a, $06
	jp	C, .l00113
;src/editor/editor.c:438: *dest++ = '0' + (unsigned char)n;
	ld	hl, sp+12
	ld	a, [hl]
	add	a, $30
	ld	c, a
	ld	hl, sp+6
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	ld	[hl], c
	ld	hl, sp+6
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	inc	bc
;src/editor/editor.c:439: return dest;
.l00110:
;src/editor/editor.c:440: }
	add	sp, 10
	pop	hl
	add	sp, 4
	jp hl
	SECTION FRAGMENT "src/editor/editor.c FIXED",ROMX,BANK[1]
_powers_of_ten:
	DB $40, $42, $0F, $00	; 1000000
	DB $A0, $86, $01, $00	; 100000
	DB $10, $27, $00, $00	; 10000
	DB $E8, $03, $00, $00	; 1000
	DB $64, $00, $00, $00	; 100
	DB $0A, $00, $00, $00	; 10
;src/editor/editor.c:443: static char* PutNumber2(char* dest, unsigned int n) {
;	---------------------------------
	SECTION FRAGMENT "Page 4",ROMX,BANK[2]
	LOAD FRAGMENT "Page 4 RAM",SRAM,BANK[4]
; Function PutNumber2
; ---------------------------------
_PutNumber2:
;src/editor/editor.c:444: if (n < 10) *dest++ = '0';
	ld	a, c
	sub	a, $0A
	ld	a, b
	sbc	a, $00
	jp	NC, .l00102
	ld	a, $30
	ld	[de], a
	inc	de
.l00102:
;src/editor/editor.c:445: return PutNumber(dest, n);
	ld	hl, $0000
	push	hl
	push	bc
	call	_PutNumber
.l00103:
;src/editor/editor.c:446: }
	ret
;src/editor/editor.c:449: static char* ToLatin1(char* dest, const char* text, unsigned char count) {
;	---------------------------------
	SECTION FRAGMENT "Page 4",ROMX,BANK[2]
	LOAD FRAGMENT "Page 4 RAM",SRAM,BANK[4]
; Function ToLatin1
; ---------------------------------
_ToLatin1:
	add	sp, -9
	ld	hl, sp+4
	ld	[hl], e
	inc	hl
	ld	[hl], d
;src/editor/editor.c:451: while ((c = *text++) && count--) {
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
;src/editor/editor.c:452: if (c >= 0x80) {
	inc	hl
	inc	hl
	ld	a, [hl]
	sub	a, $80
	jp	C, .l00111
;src/editor/editor.c:453: next = *text;
	ld	a, [bc]
	ld	e, a
;src/editor/editor.c:454: if ((c & 0xFE) == 0xC2 && (next & 0xC0) == 0x80) { // U+0080-U+00FF
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
;src/editor/editor.c:455: ++text;
	inc	bc
;src/editor/editor.c:456: c = (c << 6) | (next & 0x3F);
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
;src/editor/editor.c:457: if (c < 0xA0) c = '?';
	ld	a, [hl]
	sub	a, $A0
	jp	NC, .l00111
	ld	[hl], $3F
	jp	.l00111
;src/editor/editor.c:460: while ((*text & 0xC0) == 0x80) ++text;
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
;src/editor/editor.c:461: c = '?';
	ld	[hl], $3F
.l00111:
;src/editor/editor.c:464: *dest++ = c;
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
;src/editor/editor.c:466: return dest;
	ld	hl, sp+4
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
.l00116:
;src/editor/editor.c:467: }
	add	sp, 9
	pop	hl
	inc	sp
	jp hl
;src/editor/editor.c:470: static void ToUtf8(char* dest, const char* text) {
;	---------------------------------
	SECTION FRAGMENT "Page 4",ROMX,BANK[2]
	LOAD FRAGMENT "Page 4 RAM",SRAM,BANK[4]
; Function ToUtf8
; ---------------------------------
_ToUtf8:
	ld	l, e
;	spillPairReg hl
;	spillPairReg hl
	ld	h, d
;	spillPairReg hl
;	spillPairReg hl
;src/editor/editor.c:472: while ((c = *text++)) {
.l00103:
	ld	a, [bc]
	inc	bc
	ld	e, a
	or	a, a
	jp	Z, .l00105
;src/editor/editor.c:473: if (c >= 0x80) {
	ld	a, e
	sub	a, $80
	jp	C, .l00102
;src/editor/editor.c:474: *dest++ = 0xC0 | (c >> 6);
	ld	a, e
	rlca
	rlca
	and	a, $03
	or	a, $C0
	ld	[hl], a
	inc	hl
;src/editor/editor.c:475: c = 0x80 | (c & 0x3F);
	ld	a, e
	and	a, $3F
	ld	e, a
	set	7, e
.l00102:
;src/editor/editor.c:477: *dest++ = c;
	ld	[hl], e
	inc	hl
	jp	.l00103
.l00105:
;src/editor/editor.c:479: *dest = 0;
	ld	[hl], $00
.l00106:
;src/editor/editor.c:480: }
	ret
;src/editor/editor.c:483: static void PutPath(char* dest, const char* path, unsigned char count) {
;	---------------------------------
	SECTION FRAGMENT "Page 4",ROMX,BANK[2]
	LOAD FRAGMENT "Page 4 RAM",SRAM,BANK[4]
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
;src/editor/editor.c:485: while (path[length]) ++length;
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
;src/editor/editor.c:486: if (!length) path = "/";
	ld	a, e
	or	a, a
	jp	NZ, .l00107
	ld	hl, sp+0
	ld	a, LOW(___src_editor_editor_c_str_39)
	ld	[hl], a
	inc	hl
	ld	a, HIGH(___src_editor_editor_c_str_39)
	ld	[hl], a
	jp	.l00108
.l00107:
;src/editor/editor.c:487: else if (length > count) {
	ld	hl, sp+6
	ld	a, [hl]
	sub	a, e
	jp	NC, .l00108
;src/editor/editor.c:488: dest = PutText(dest, "...");
	push	de
	ld	bc, ___src_editor_editor_c_str_40
	ld	hl, sp+4
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_PutText__far
	pop	de
	ld	hl, sp+2
	ld	[hl], c
	inc	hl
	ld	[hl], b
;src/editor/editor.c:489: path += length - count;
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
;src/editor/editor.c:491: *ToLatin1(dest, path, count) = 0;
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
;src/editor/editor.c:492: }
	add	sp, 4
	pop	hl
	inc	sp
	jp hl
	SECTION FRAGMENT "src/editor/editor.c FIXED",ROMX,BANK[1]
___src_editor_editor_c_str_39:
	DB "/"
	DB $00
	SECTION FRAGMENT "src/editor/editor.c FIXED",ROMX,BANK[1]
___src_editor_editor_c_str_40:
	DB "..."
	DB $00
;src/editor/editor.c:495: static unsigned char JoinPath(char* dest, const char* dir, const char* name, unsigned char size) {
;	---------------------------------
	SECTION FRAGMENT "Page 4",ROMX,BANK[2]
	LOAD FRAGMENT "Page 4 RAM",SRAM,BANK[4]
; Function JoinPath
; ---------------------------------
_JoinPath:
	add	sp, -6
	inc	sp
	inc	sp
	push	de
;src/editor/editor.c:496: while (*dir) {
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
;src/editor/editor.c:497: if (!--size) return 0;
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
;src/editor/editor.c:498: *dest++ = *dir++;
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
;src/editor/editor.c:500: if (!--size) return 0;
	ld	hl, sp+10
	dec	[hl]
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00107
	xor	a, a
	jp	.l00113
.l00107:
;src/editor/editor.c:501: *dest++ = '/';
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
;src/editor/editor.c:502: while (*name) {
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
;src/editor/editor.c:503: if (!--size) return 0;
	dec	a
	or	a, a
	jp	NZ, .l00109
	xor	a, a
	jp	.l00113
.l00109:
;src/editor/editor.c:504: *dest++ = *name++;
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
;src/editor/editor.c:506: *dest = 0;
	ld	hl, sp+3
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	ld	[hl], $00
;src/editor/editor.c:507: return 1;
	ld	a, $01
.l00113:
;src/editor/editor.c:508: }
	add	sp, 6
	pop	hl
	add	sp, 3
	jp hl
;src/editor/editor.c:511: static void UpdateBars(void) {
;	---------------------------------
	SECTION FRAGMENT "Page 5",ROMX,BANK[2]
	LOAD FRAGMENT "Page 5 RAM",SRAM,BANK[5]
; Function UpdateBars
; ---------------------------------
_UpdateBars:
	add	sp, -48
;src/editor/editor.c:513: char* end = file_name[0] ? ToLatin1(text, file_name, TB_STRIDE - 3) : PutText(text, "Untitled");
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
	ld	bc, ___src_editor_editor_c_str_41
	ld	hl, 0
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_PutText
.l00117:
;src/editor/editor.c:514: if (modified) *end++ = '*';
	ld	hl, _modified
	ld	a, [hl]
	or	a, a
	jp	Z, .l00102
	ld	a, $2A
	ld	[bc], a
	inc	bc
.l00102:
;src/editor/editor.c:515: *end = 0;
	xor	a, a
	ld	[bc], a
;src/editor/editor.c:516: DrawRow(HEADER_LINE, 1, text);
	ld	hl, 0
	add	hl, sp
	push	hl
	ld	e, $01
	ld	a, $12
	call	_DrawRow__far
;src/editor/editor.c:517: if (tb_found_row == 0xFF) return; // cursor isn't on screen
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
;src/editor/editor.c:518: if (GetSelection()) {
	call	_GetSelection__far
	ld	c, a
	ld	a, c
	or	a, a
	jp	Z, .l00112
;src/editor/editor.c:519: end = PutNumber(text, sel_end - sel_start);
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
;src/editor/editor.c:520: end = PutText(end, " selected");
	ld	bc, ___src_editor_editor_c_str_42
	call	_PutText
	ld	e, c
	ld	d, b
	jp	.l00113
.l00112:
;src/editor/editor.c:523: end = PutText(text, "Line ");
	ld	bc, ___src_editor_editor_c_str_43
	ld	hl, 0
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_PutText
;src/editor/editor.c:524: if (!doc_large) end = PutNumber(end, CursorLine());
	ld	hl, _doc_large
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00109
	push	bc
	call	_CursorLine
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
;src/editor/editor.c:525: else if (lines_known) end = PutNumber(end, CursorLine() + win_lines);
	ld	hl, _lines_known
	ld	a, [hl]
	or	a, a
	jp	Z, .l00106
	push	bc
	call	_CursorLine
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
;src/editor/editor.c:526: else *end++ = '?';
	ld	a, $3F
	ld	[bc], a
	ld	e, c
	ld	d, b
	inc	de
.l00110:
;src/editor/editor.c:527: end = PutText(end, ", Col ");
	ld	bc, ___src_editor_editor_c_str_44
	call	_PutText
	ld	e, c
	ld	d, b
;src/editor/editor.c:528: end = PutNumber(end, CursorColumn());
	push	de
	call	_CursorColumn
	pop	de
	ld	hl, $0000
	push	hl
	push	bc
	call	_PutNumber__far
	ld	e, c
	ld	d, b
.l00113:
;src/editor/editor.c:530: *end = 0;
	xor	a, a
	ld	[de], a
;src/editor/editor.c:531: DrawRow(STATUS_LINE, 1, text);
	ld	hl, 0
	add	hl, sp
	push	hl
	ld	e, $01
	ld	a, $13
	call	_DrawRow__far
.l00114:
;src/editor/editor.c:532: }
	add	sp, 48
	ret
	SECTION FRAGMENT "src/editor/editor.c FIXED",ROMX,BANK[1]
___src_editor_editor_c_str_41:
	DB "Untitled"
	DB $00
	SECTION FRAGMENT "src/editor/editor.c FIXED",ROMX,BANK[1]
___src_editor_editor_c_str_42:
	DB " selected"
	DB $00
	SECTION FRAGMENT "src/editor/editor.c FIXED",ROMX,BANK[1]
___src_editor_editor_c_str_43:
	DB "Line "
	DB $00
	SECTION FRAGMENT "src/editor/editor.c FIXED",ROMX,BANK[1]
___src_editor_editor_c_str_44:
	DB ", Col "
	DB $00
;src/editor/editor.c:534: static void Draw(void) {
;	---------------------------------
	SECTION FRAGMENT "Page 5",ROMX,BANK[2]
	LOAD FRAGMENT "Page 5 RAM",SRAM,BANK[5]
; Function Draw
; ---------------------------------
_Draw:
;src/editor/editor.c:535: SetHighlight();
	call	_SetHighlight
;src/editor/editor.c:536: if (bars) UpdateBars();
	ld	hl, _bars
	ld	a, [hl]
	or	a, a
	jp	Z, .l00102
	call	_UpdateBars
.l00102:
;src/editor/editor.c:537: EditorDraw();
	jp	_EditorDraw
.l00103:
;src/editor/editor.c:538: }
	ret
;src/editor/editor.c:541: static void ScrollTo(unsigned int new_top) {
;	---------------------------------
	SECTION FRAGMENT "Page 5",ROMX,BANK[2]
	LOAD FRAGMENT "Page 5 RAM",SRAM,BANK[5]
; Function ScrollTo
; ---------------------------------
_ScrollTo:
	ld	hl, _top
	ld	[hl], e
	inc	hl
	ld	[hl], d
;src/editor/editor.c:543: Render();
	call	_Render
;src/editor/editor.c:544: redraw = 1;
	ld	hl, _redraw
	ld	[hl], $01
.l00101:
;src/editor/editor.c:545: }
	ret
;src/editor/editor.c:547: static void MoveUp(void) {
;	---------------------------------
	SECTION FRAGMENT "Page 6",ROMX,BANK[3]
	LOAD FRAGMENT "Page 6 RAM",SRAM,BANK[6]
; Function MoveUp
; ---------------------------------
_MoveUp:
;src/editor/editor.c:548: unsigned char row = tb_found_row;
	ld	hl, _tb_found_row
	ld	a, [hl]
;src/editor/editor.c:549: keep_x = 1;
	ld	hl, _keep_x
	ld	[hl], $01
;src/editor/editor.c:550: if (row) cursor = PosAtX(row - 1, want_x);
	or	a, a
	jp	Z, .l00105
	ld	c, a
	dec	c
	ld	hl, _want_x
	ld	e, [hl]
	ld	a, c
	call	_PosAtX__far
	ld	hl, _cursor
	ld	[hl], c
	inc	hl
	ld	[hl], b
	jp	.l00107
.l00105:
;src/editor/editor.c:551: else if (!top) cursor = 0;
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
;src/editor/editor.c:553: ScrollUp(tb_RowStart(top - 1));
	ld	hl, _top + 1
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	dec	de
	call	_tb_RowStart
	ld	e, c
	ld	d, b
	call	_ScrollUp__far
;src/editor/editor.c:554: cursor = PosAtX(0, want_x);
	ld	hl, _want_x
	ld	e, [hl]
	xor	a, a
	call	_PosAtX__far
	ld	hl, _cursor
	ld	[hl], c
	inc	hl
	ld	[hl], b
.l00107:
;src/editor/editor.c:556: }
	ret
;src/editor/editor.c:558: static void MoveDown(void) {
;	---------------------------------
	SECTION FRAGMENT "Page 6",ROMX,BANK[3]
	LOAD FRAGMENT "Page 6 RAM",SRAM,BANK[6]
; Function MoveDown
; ---------------------------------
_MoveDown:
	dec	sp
;src/editor/editor.c:559: unsigned char row = tb_found_row;
	ld	hl, _tb_found_row
	ld	a, [hl]
	ld	hl, sp+0
	ld	[hl], a
;src/editor/editor.c:560: keep_x = 1;
	ld	hl, _keep_x
	ld	[hl], $01
;src/editor/editor.c:561: if (tb_end_row == row) cursor = tb_Length(); // last row
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
;src/editor/editor.c:562: else if (row + 1 < tb_rows) cursor = PosAtX(row + 1, want_x);
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
	call	_PosAtX__far
	ld	hl, _cursor
	ld	[hl], c
	inc	hl
	ld	[hl], b
	jp	.l00107
.l00102:
;src/editor/editor.c:564: ScrollDown();
	call	_ScrollDown__far
;src/editor/editor.c:565: cursor = PosAtX(row, want_x);
	ld	hl, _want_x
	ld	e, [hl]
	ld	hl, sp+0
	ld	a, [hl]
	call	_PosAtX__far
	ld	hl, _cursor
	ld	[hl], c
	inc	hl
	ld	[hl], b
.l00107:
;src/editor/editor.c:567: }
	inc	sp
	ret
;src/editor/editor.c:569: static void PageUp(void) {
;	---------------------------------
	SECTION FRAGMENT "Page 6",ROMX,BANK[3]
	LOAD FRAGMENT "Page 6 RAM",SRAM,BANK[6]
; Function PageUp
; ---------------------------------
_PageUp:
;src/editor/editor.c:570: unsigned char row = tb_found_row, i;
	ld	hl, _tb_found_row
	ld	c, [hl]
;src/editor/editor.c:571: keep_x = 1;
	ld	hl, _keep_x
	ld	[hl], $01
;src/editor/editor.c:572: if (!top) {
	ld	hl, _top + 1
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	jp	NZ, .l00102
;src/editor/editor.c:573: cursor = 0;
	xor	a, a
	ld	hl, _cursor
	ld	[hl], a
	inc	hl
	ld	[hl], a
;src/editor/editor.c:574: return;
	jp	.l00108
.l00102:
;src/editor/editor.c:576: for (i = tb_rows - 1; i && top; --i) top = tb_RowStart(top - 1);
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
;src/editor/editor.c:577: ScrollTo(top);
	push	bc
	ld	hl, _top
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_ScrollTo__far
	pop	bc
;src/editor/editor.c:578: cursor = PosAtX(row, want_x);
	ld	hl, _want_x
	ld	e, [hl]
	ld	a, c
	call	_PosAtX__far
	ld	hl, _cursor
	ld	[hl], c
	inc	hl
	ld	[hl], b
.l00108:
;src/editor/editor.c:579: }
	ret
;src/editor/editor.c:581: static void PageDown(void) {
;	---------------------------------
	SECTION FRAGMENT "Page 6",ROMX,BANK[3]
	LOAD FRAGMENT "Page 6 RAM",SRAM,BANK[6]
; Function PageDown
; ---------------------------------
_PageDown:
;src/editor/editor.c:582: unsigned char row = tb_found_row;
	ld	hl, _tb_found_row
	ld	c, [hl]
;src/editor/editor.c:583: keep_x = 1;
	ld	hl, _keep_x
	ld	[hl], $01
;src/editor/editor.c:584: if (tb_end_row != 0xFF) {
	ld	hl, _tb_end_row
	ld	a, [hl]
	inc	a
	jp	NZ,.l00123
	jp	.l00102
.l00123:
;src/editor/editor.c:585: cursor = tb_Length();
	call	_tb_Length
	ld	hl, _cursor
	ld	[hl], c
	inc	hl
	ld	[hl], b
;src/editor/editor.c:586: return;
	jp	.l00106
.l00102:
;src/editor/editor.c:588: ScrollTo(tb_row_starts[tb_rows - 1]);
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
	call	_ScrollTo__far
	pop	bc
;src/editor/editor.c:589: if (tb_end_row != 0xFF && row > tb_end_row) row = tb_end_row;
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
;src/editor/editor.c:590: cursor = PosAtX(row, want_x);
	ld	hl, _want_x
	ld	e, [hl]
	ld	a, c
	call	_PosAtX__far
	ld	hl, _cursor
	ld	[hl], c
	inc	hl
	ld	[hl], b
.l00106:
;src/editor/editor.c:591: }
	ret
;src/editor/editor.c:594: static void MoveEnd(void) {
;	---------------------------------
	SECTION FRAGMENT "Page 6",ROMX,BANK[3]
	LOAD FRAGMENT "Page 6 RAM",SRAM,BANK[6]
; Function MoveEnd
; ---------------------------------
_MoveEnd:
	add	sp, -4
;src/editor/editor.c:595: unsigned char row = tb_found_row, count = tb_row_counts[row];
	ld	hl, _tb_found_row
	ld	c, [hl]
	ld	hl, _tb_row_counts
	ld	b, $00
	add	hl, bc
	ld	b, [hl]
;src/editor/editor.c:596: if (tb_nowrap) {
	ld	hl, _tb_nowrap
	ld	a, [hl]
	or	a, a
	jp	Z, .l00102
;src/editor/editor.c:597: cursor = LineEnd(row);
	ld	a, c
	call	_LineEnd__far
	ld	hl, _cursor
	ld	[hl], c
	inc	hl
	ld	[hl], b
;src/editor/editor.c:598: return;
	jp	.l00108
.l00102:
;src/editor/editor.c:600: cursor = tb_row_starts[row] + count;
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
;src/editor/editor.c:601: if (count && cursor == tb_row_starts[row + 1] && tb_end_row != row && RowAddress(row)[count - 1] == ' ') --cursor;
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
;src/editor/editor.c:602: }
	add	sp, 4
	ret
;src/editor/editor.c:604: static void DeleteSelection(void) {
;	---------------------------------
	SECTION FRAGMENT "Page 6",ROMX,BANK[3]
	LOAD FRAGMENT "Page 6 RAM",SRAM,BANK[6]
; Function DeleteSelection
; ---------------------------------
_DeleteSelection:
;src/editor/editor.c:605: UndoDeleting(sel_start, sel_end - sel_start);
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
;src/editor/editor.c:606: Uncount(sel_start);
	ld	hl, _sel_start
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_Uncount__far
;src/editor/editor.c:607: tb_DeleteRange(sel_start, sel_end - sel_start);
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
;src/editor/editor.c:608: cursor = sel_start;
	ld	hl, _sel_start
	ld	a, [hl]
	ld	hl, _cursor
	ld	[hl], a
	ld	hl, _sel_start + 1
	ld	a, [hl]
	ld	hl, _cursor + 1
	ld	[hl], a
;src/editor/editor.c:609: selecting = 0;
	ld	hl, _selecting
	ld	[hl], $00
;src/editor/editor.c:610: modified = 1;
	ld	hl, _modified
	ld	[hl], $01
;src/editor/editor.c:611: dirty = 1;
	ld	hl, _dirty
	ld	[hl], $01
.l00101:
;src/editor/editor.c:612: }
	ret
;src/editor/editor.c:614: static unsigned char Copy(void) {
;	---------------------------------
	SECTION FRAGMENT "Page 6",ROMX,BANK[3]
	LOAD FRAGMENT "Page 6 RAM",SRAM,BANK[6]
; Function Copy
; ---------------------------------
_Copy:
;src/editor/editor.c:615: if (!GetSelection()) return 0;
	call	_GetSelection
	or	a, a
	jp	NZ, .l00102
	xor	a, a
	jp	.l00105
.l00102:
;src/editor/editor.c:616: if (tb_Copy(sel_start, sel_end - sel_start)) return 1;
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
;src/editor/editor.c:617: ShowMessage("TOO BIG TO COPY");
	ld	de, ___src_editor_editor_c_str_45
	call	_ShowMessage
;src/editor/editor.c:618: return 0;
	xor	a, a
.l00105:
;src/editor/editor.c:619: }
	ret
	SECTION FRAGMENT "src/editor/editor.c FIXED",ROMX,BANK[1]
___src_editor_editor_c_str_45:
	DB "TOO BIG TO COPY"
	DB $00
;src/editor/editor.c:621: static void Paste(void) {
;	---------------------------------
	SECTION FRAGMENT "Page 6",ROMX,BANK[3]
	LOAD FRAGMENT "Page 6 RAM",SRAM,BANK[6]
; Function Paste
; ---------------------------------
_Paste:
	add	sp, -6
;src/editor/editor.c:622: unsigned int length = tb_ClipLength(), room = TB_SIZE - tb_Length();
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
	ld	de, $FE00
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
;src/editor/editor.c:623: if (!length) return;
	ld	hl, sp+1
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	jp	NZ, .l00102
	jp	.l00109
.l00102:
;src/editor/editor.c:624: if (GetSelection()) room += sel_end - sel_start;
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
;src/editor/editor.c:625: if (length > room) {
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
;src/editor/editor.c:626: ShowMessage("TEXT FULL");
	ld	de, ___src_editor_editor_c_str_46
	call	_ShowMessage
;src/editor/editor.c:627: return;
	jp	.l00109
.l00106:
;src/editor/editor.c:629: undo_join = GetSelection();
	call	_GetSelection
	ld	hl, _undo_join
	ld	[hl], a
;src/editor/editor.c:630: if (undo_join) DeleteSelection();
	ld	a, [hl]
	or	a, a
	jp	Z, .l00108
	call	_DeleteSelection
.l00108:
;src/editor/editor.c:631: Uncount(cursor);
	ld	hl, _cursor
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_Uncount__far
;src/editor/editor.c:632: tb_Paste(cursor);
	ld	hl, _cursor
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_tb_Paste
;src/editor/editor.c:633: UndoInserted(cursor, length);
	pop	bc
	push	bc
	ld	hl, _cursor
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_UndoInserted
;src/editor/editor.c:634: cursor += length;
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
;src/editor/editor.c:635: modified = 1;
	ld	hl, _modified
	ld	[hl], $01
;src/editor/editor.c:636: dirty = 1;
	ld	hl, _dirty
	ld	[hl], $01
.l00109:
;src/editor/editor.c:637: }
	add	sp, 6
	ret
	SECTION FRAGMENT "src/editor/editor.c FIXED",ROMX,BANK[1]
___src_editor_editor_c_str_46:
	DB "TEXT FULL"
	DB $00
;src/editor/editor.c:640: static unsigned char CharClass(unsigned char c) {
;	---------------------------------
	SECTION FRAGMENT "Page 6",ROMX,BANK[3]
	LOAD FRAGMENT "Page 6 RAM",SRAM,BANK[6]
; Function CharClass
; ---------------------------------
_CharClass:
	ld	c, a
;src/editor/editor.c:641: if (c == ' ' || c == ASCII_TAB || c == ASCII_LF) return 0;
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
;src/editor/editor.c:642: if ((c >= '0' && c <= '9') || (c >= 'A' && c <= 'Z') || (c >= 'a' && c <= 'z') || c == '_' || c >= 0xC0) return 1;
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
;src/editor/editor.c:643: return 2;
	ld	a, $02
.l00114:
;src/editor/editor.c:644: }
	ret
;src/editor/editor.c:647: static void WordRight(void) {
;	---------------------------------
	SECTION FRAGMENT "Page 6",ROMX,BANK[3]
	LOAD FRAGMENT "Page 6 RAM",SRAM,BANK[6]
; Function WordRight
; ---------------------------------
_WordRight:
	dec	sp
;src/editor/editor.c:648: unsigned int length = tb_Length();
	call	_tb_Length
;src/editor/editor.c:650: while (cursor < length && !CharClass(tb_GetChar(cursor))) ++cursor;
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
;src/editor/editor.c:651: if (cursor == length) return;
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
;src/editor/editor.c:652: token = CharClass(tb_GetChar(cursor));
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
;src/editor/editor.c:653: do ++cursor;
.l00108:
	ld	hl, _cursor
	inc	[hl]
	jp	NZ, .l00146
	inc	hl
	inc	[hl]
.l00146:
;src/editor/editor.c:654: while (cursor < length && CharClass(tb_GetChar(cursor)) == token);
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
;src/editor/editor.c:655: }
	inc	sp
	ret
;src/editor/editor.c:658: static void WordLeft(void) {
;	---------------------------------
	SECTION FRAGMENT "Page 6",ROMX,BANK[3]
	LOAD FRAGMENT "Page 6 RAM",SRAM,BANK[6]
; Function WordLeft
; ---------------------------------
_WordLeft:
;src/editor/editor.c:660: while (cursor && !CharClass(tb_GetChar(cursor - 1))) --cursor;
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
;src/editor/editor.c:661: if (!cursor) return;
	ld	hl, _cursor + 1
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	jp	NZ, .l00106
	jp	.l00111
.l00106:
;src/editor/editor.c:662: token = CharClass(tb_GetChar(cursor - 1));
	call	_tb_GetChar
	ld	c, a
	ld	a, c
	call	_CharClass
	ld	c, a
;src/editor/editor.c:663: do --cursor;
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
;src/editor/editor.c:664: while (cursor && CharClass(tb_GetChar(cursor - 1)) == token);
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
;src/editor/editor.c:665: }
	ret
;src/editor/editor.c:668: static void ScrollLine(unsigned char down) {
;	---------------------------------
	SECTION FRAGMENT "Page 5",ROMX,BANK[2]
	LOAD FRAGMENT "Page 5 RAM",SRAM,BANK[5]
; Function ScrollLine
; ---------------------------------
_ScrollLine:
	ld	c, a
;src/editor/editor.c:669: unsigned char row = tb_found_row;
	ld	hl, _tb_found_row
	ld	b, [hl]
;src/editor/editor.c:670: keep_x = 1;
	ld	hl, _keep_x
	ld	[hl], $01
;src/editor/editor.c:671: if (down) {
	ld	a, c
	or	a, a
	jp	Z, .l00110
;src/editor/editor.c:672: if (tb_end_row != 0xFF) return; // the end of the text is on screen
	ld	hl, _tb_end_row
	ld	a, [hl]
	inc	a
	jp	NZ,.l00139
	jp	.l00102
.l00139:
	jp	.l00112
.l00102:
;src/editor/editor.c:673: ScrollDown();
	push	bc
	call	_ScrollDown
	pop	bc
;src/editor/editor.c:674: if (!row) cursor = PosAtX(0, want_x);
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
;src/editor/editor.c:676: else if (top) {
	ld	hl, _top + 1
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	jp	Z, .l00112
;src/editor/editor.c:677: ScrollUp(tb_RowStart(top - 1));
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
;src/editor/editor.c:678: if (row == tb_rows - 1) cursor = PosAtX(row, want_x);
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
;src/editor/editor.c:680: }
	ret
;src/editor/editor.c:683: static void UndoRedo(unsigned char redo) {
;	---------------------------------
	SECTION FRAGMENT "Page 6",ROMX,BANK[3]
	LOAD FRAGMENT "Page 6 RAM",SRAM,BANK[6]
; Function UndoRedo
; ---------------------------------
_UndoRedo:
	ld	c, a
;src/editor/editor.c:684: if (!(redo ? Redo() : Undo())) return;
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
;src/editor/editor.c:685: cursor = undo_cursor;
	ld	hl, _undo_cursor
	ld	a, [hl]
	ld	hl, _cursor
	ld	[hl], a
	ld	hl, _undo_cursor + 1
	ld	a, [hl]
	ld	hl, _cursor + 1
	ld	[hl], a
;src/editor/editor.c:686: selecting = 0;
	ld	hl, _selecting
	ld	[hl], $00
;src/editor/editor.c:687: Uncount(0);
	ld	de, $0000
	call	_Uncount__far
;src/editor/editor.c:688: modified = !undo_at_save;
	ld	hl, _undo_at_save
	ld	a, [hl]
	sub	a,$01
	ld	a, $00
	rla
	ld	hl, _modified
	ld	[hl], a
;src/editor/editor.c:689: dirty = 1;
	ld	hl, _dirty
	ld	[hl], $01
.l00103:
;src/editor/editor.c:690: }
	ret
;src/editor/editor.c:692: static void SelectAll(void) {
;	---------------------------------
	SECTION FRAGMENT "Page 6",ROMX,BANK[3]
	LOAD FRAGMENT "Page 6 RAM",SRAM,BANK[6]
; Function SelectAll
; ---------------------------------
_SelectAll:
;src/editor/editor.c:693: anchor = 0;
	xor	a, a
	ld	hl, _anchor
	ld	[hl], a
	inc	hl
	ld	[hl], a
;src/editor/editor.c:694: cursor = tb_Length();
	call	_tb_Length
	ld	hl, _cursor
	ld	[hl], c
	inc	hl
	ld	[hl], b
;src/editor/editor.c:695: selecting = 1;
	ld	hl, _selecting
	ld	[hl], $01
;src/editor/editor.c:696: moved = 1;
	ld	hl, _moved
	ld	[hl], $01
;src/editor/editor.c:697: redraw = 1;
	ld	hl, _redraw
	ld	[hl], $01
.l00101:
;src/editor/editor.c:698: }
	ret
;src/editor/editor.c:700: static void Cut(void) {
;	---------------------------------
	SECTION FRAGMENT "Page 6",ROMX,BANK[3]
	LOAD FRAGMENT "Page 6 RAM",SRAM,BANK[6]
; Function Cut
; ---------------------------------
_Cut:
;src/editor/editor.c:701: if (Copy()) DeleteSelection();
	call	_Copy
	or	a, a
	jp	Z, .l00103
	jp	_DeleteSelection
.l00103:
;src/editor/editor.c:702: }
	ret
;src/editor/editor.c:708: static unsigned char Commit(void) {
;	---------------------------------
	SECTION FRAGMENT "Page 6",ROMX,BANK[3]
	LOAD FRAGMENT "Page 6 RAM",SRAM,BANK[6]
; Function Commit
; ---------------------------------
_Commit:
;src/editor/editor.c:709: if (FileCommitWindow()) return 1;
	call	_FileCommitWindow
	or	a, a
	jp	Z, .l00102
	ld	a, $01
	jp	.l00103
.l00102:
;src/editor/editor.c:710: ShowMessage("TOO MANY EDITS, SAVE FIRST");
	ld	de, ___src_editor_editor_c_str_47
	call	_ShowMessage
;src/editor/editor.c:711: return 0;
	xor	a, a
.l00103:
;src/editor/editor.c:712: }
	ret
	SECTION FRAGMENT "src/editor/editor.c FIXED",ROMX,BANK[1]
___src_editor_editor_c_str_47:
	DB "TOO MANY EDITS, SAVE FIRST"
	DB $00
;src/editor/editor.c:715: static void LoadWindow(void) {
;	---------------------------------
	SECTION FRAGMENT "Page 6",ROMX,BANK[3]
	LOAD FRAGMENT "Page 6 RAM",SRAM,BANK[6]
; Function LoadWindow
; ---------------------------------
_LoadWindow:
;src/editor/editor.c:716: if (FileLoadWindow()) ShowMessage("SD ERROR");
	call	_FileLoadWindow
	or	a, a
	jp	Z, .l00102
	ld	de, ___src_editor_editor_c_str_48
	call	_ShowMessage
.l00102:
;src/editor/editor.c:717: UndoClear(modified);
	ld	hl, _modified
	ld	a, [hl]
	call	_UndoClear
;src/editor/editor.c:718: Uncount(0);
	ld	de, $0000
	call	_Uncount__far
;src/editor/editor.c:719: dirty = 1;
	ld	hl, _dirty
	ld	[hl], $01
.l00103:
;src/editor/editor.c:720: }
	ret
	SECTION FRAGMENT "src/editor/editor.c FIXED",ROMX,BANK[1]
___src_editor_editor_c_str_48:
	DB "SD ERROR"
	DB $00
;src/editor/editor.c:724: static void ShiftPositions(unsigned int shift, unsigned char down) {
;	---------------------------------
	SECTION FRAGMENT "Page 6",ROMX,BANK[3]
	LOAD FRAGMENT "Page 6 RAM",SRAM,BANK[6]
; Function ShiftPositions
; ---------------------------------
_ShiftPositions:
	add	sp, -3
	ld	c, e
	ld	b, d
	ld	hl, sp+2
	ld	[hl], a
;src/editor/editor.c:725: unsigned int length = tb_Length();
	push	bc
	call	_tb_Length
	ld	e, c
	ld	d, b
	pop	bc
	inc	sp
	inc	sp
	push	de
;src/editor/editor.c:726: if (down) {
	ld	hl, sp+2
	ld	a, [hl]
	or	a, a
	jp	Z, .l00108
;src/editor/editor.c:727: cursor = cursor > shift ? cursor - shift : 0;
	ld	hl, _cursor
	ld	a, c
	sub	a, [hl]
	inc	hl
	ld	a, b
	sbc	a, [hl]
	jp	NC, .l00116
	ld	hl, _cursor
	ld	a, [hl]
	sub	a, c
	ld	e, a
	inc	hl
	ld	a, [hl]
	sbc	a, b
	ld	d, a
	jp	.l00117
.l00116:
	ld	de, $0000
.l00117:
	ld	hl, _cursor
	ld	[hl], e
	inc	hl
	ld	[hl], d
;src/editor/editor.c:728: top = top > shift ? top - shift : 0;
	ld	hl, _top
	ld	a, c
	sub	a, [hl]
	inc	hl
	ld	a, b
	sbc	a, [hl]
	jp	NC, .l00118
	ld	hl, _top
	ld	a, [hl]
	sub	a, c
	ld	e, a
	inc	hl
	ld	a, [hl]
	sbc	a, b
	ld	d, a
	jp	.l00119
.l00118:
	ld	de, $0000
.l00119:
	ld	hl, _top
	ld	[hl], e
	inc	hl
	ld	[hl], d
;src/editor/editor.c:729: if (anchor < shift) selecting = 0;
	ld	hl, _anchor
	ld	a, [hl]
	sub	a, c
	inc	hl
	ld	a, [hl]
	sbc	a, b
	jp	NC, .l00102
	ld	hl, _selecting
	ld	[hl], $00
	jp	.l00109
.l00102:
;src/editor/editor.c:730: else anchor -= shift;
	ld	hl, _anchor
	ld	a, [hl]
	sub	a, c
	ld	[hl], a
	inc	hl
	ld	a, [hl]
	sbc	a, b
	ld	[hl], a
	jp	.l00109
.l00108:
;src/editor/editor.c:733: cursor += shift;
	ld	hl, _cursor
	ld	a, [hl]
	add	a, c
	ld	[hl], a
	inc	hl
	ld	a, [hl]
	adc	a, b
	ld	[hl], a
;src/editor/editor.c:734: top += shift;
	ld	hl, _top
	ld	a, [hl]
	add	a, c
	ld	[hl], a
	inc	hl
	ld	a, [hl]
	adc	a, b
	ld	[hl], a
;src/editor/editor.c:735: if (anchor + shift > length) selecting = 0;
	ld	a, c
	ld	hl, _anchor
	add	a, [hl]
	ld	c, a
	ld	a, b
	inc	hl
	adc	a, [hl]
	ld	b, a
	ld	hl, sp+0
	ld	a, [hl]
	sub	a, c
	inc	hl
	ld	a, [hl]
	sbc	a, b
	jp	NC, .l00105
	ld	hl, _selecting
	ld	[hl], $00
	jp	.l00109
.l00105:
;src/editor/editor.c:736: else anchor += shift;
	ld	hl, _anchor
	ld	[hl], c
	inc	hl
	ld	[hl], b
.l00109:
;src/editor/editor.c:738: if (cursor > length) cursor = length;
	ld	hl, sp+0
	ld	e, l
	ld	d, h
	ld	hl, _cursor
	ld	a, [de]
	inc	de
	sub	a, [hl]
	inc	hl
	ld	a, [de]
	sbc	a, [hl]
	jp	NC, .l00111
	ld	hl, sp+0
	ld	a, [hl]
	ld	hl, _cursor
	ld	[hl], a
	ld	hl, sp+1
	ld	a, [hl]
	ld	hl, _cursor + 1
	ld	[hl], a
.l00111:
;src/editor/editor.c:739: if (top > length) top = length;
	ld	hl, sp+0
	ld	e, l
	ld	d, h
	ld	hl, _top
	ld	a, [de]
	inc	de
	sub	a, [hl]
	inc	hl
	ld	a, [de]
	sbc	a, [hl]
	jp	NC, .l00113
	ld	hl, sp+0
	ld	a, [hl]
	ld	hl, _top
	ld	[hl], a
	ld	hl, sp+1
	ld	a, [hl]
	ld	hl, _top + 1
	ld	[hl], a
.l00113:
;src/editor/editor.c:740: Uncount(0);
	ld	de, $0000
	call	_Uncount__far
;src/editor/editor.c:741: dirty = 1;
	ld	hl, _dirty
	ld	[hl], $01
.l00114:
;src/editor/editor.c:742: }
	add	sp, 3
	ret
;src/editor/editor.c:746: static void LinesUnknown(void) {
;	---------------------------------
	SECTION FRAGMENT "Page 6",ROMX,BANK[3]
	LOAD FRAGMENT "Page 6 RAM",SRAM,BANK[6]
; Function LinesUnknown
; ---------------------------------
_LinesUnknown:
;src/editor/editor.c:747: lines_known = 0;
	ld	hl, _lines_known
	ld	[hl], $00
;src/editor/editor.c:748: win_lines = 0;
	xor	a, a
	ld	hl, _win_lines
	ld	[hl], a
	inc	hl
	ld	[hl], a
	inc	hl
	ld	[hl], a
	inc	hl
	ld	[hl], a
;src/editor/editor.c:749: scan_target = win_start;
	ld	hl, _win_start
	ld	d, h
	ld	e, l
	ld	hl, _scan_target
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
;src/editor/editor.c:750: scan_pos = 0;
	xor	a, a
	ld	hl, _scan_pos
	ld	[hl], a
	inc	hl
	ld	[hl], a
	inc	hl
	ld	[hl], a
	inc	hl
	ld	[hl], a
;src/editor/editor.c:751: scan_lines = 0;
	xor	a, a
	ld	hl, _scan_lines
	ld	[hl], a
	inc	hl
	ld	[hl], a
	inc	hl
	ld	[hl], a
	inc	hl
	ld	[hl], a
.l00101:
;src/editor/editor.c:752: }
	ret
;src/editor/editor.c:756: static void Slide(void) {
;	---------------------------------
	SECTION FRAGMENT "Page 6",ROMX,BANK[3]
	LOAD FRAGMENT "Page 6 RAM",SRAM,BANK[6]
; Function Slide
; ---------------------------------
_Slide:
	add	sp, -11
;src/editor/editor.c:757: unsigned int length = tb_Length(), shift, target;
	call	_tb_Length
;src/editor/editor.c:759: if (cursor < WIN_MARGIN ? !win_start : (cursor + WIN_MARGIN <= length || win_end == doc_len)) return;
	ld	hl, _cursor
	ld	a, [hl]
	sub	a, $00
	inc	hl
	ld	a, [hl]
	sbc	a, $20
	jp	NC, .l00117
	ld	hl, _win_start + 3
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	dec	hl
	or	a, [hl]
	dec	hl
	or	a, [hl]
	sub	a,$01
	ld	a, $00
	rla
	ld	c, a
	jp	.l00118
.l00117:
	ld	hl, _cursor
	ld	e, [hl]
	inc	hl
	ld	a, [hl]
	add	a, $20
	ld	d, a
	ld	a, c
	sub	a, e
	ld	a, b
	sbc	a, d
	jp	NC, .l00120
	ld	hl, _win_end
	ld	a, [hl]
	ld	hl, _doc_len
	sub	a, [hl]
	jp	NZ,.l00187
	ld	hl, _win_end + 1
	ld	a, [hl]
	ld	hl, _doc_len + 1
	sub	a, [hl]
	jp	NZ,.l00187
	ld	hl, _win_end + 2
	ld	a, [hl]
	ld	hl, _doc_len + 2
	sub	a, [hl]
	jp	NZ,.l00187
	ld	hl, _win_end + 3
	ld	a, [hl]
	ld	hl, _doc_len + 3
	sub	a, [hl]
	jp	NZ,.l00187
	jp	.l00120
.l00187:
	ld	c, $00
	jp	.l00121
.l00120:
	ld	c, $01
.l00121:
.l00118:
	ld	a, c
	or	a, a
	jp	Z, .l00102
	jp	.l00115
.l00102:
;src/editor/editor.c:760: if (!Commit()) return;
	call	_Commit
	or	a, a
	jp	NZ, .l00104
	jp	.l00115
.l00104:
;src/editor/editor.c:761: win_mark = NO_MARK;
	ld	hl, _win_mark
	ld	[hl], $FF
	inc	hl
	ld	[hl], $FF
	inc	hl
	ld	[hl], $FF
	inc	hl
	ld	[hl], $FF
;src/editor/editor.c:762: if (cursor >= WIN_MARGIN) { // from a sector boundary half a window before the cursor
	ld	hl, _cursor
	ld	a, [hl]
	sub	a, $00
	inc	hl
	ld	a, [hl]
	sbc	a, $20
	jp	C, .l00109
;src/editor/editor.c:763: target = cursor - WIN_SIZE / 2;
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $6000
	ld	a, e
	sub	a, l
	ld	e, a
	ld	a, d
	sbc	a, h
	ld	hl, sp+7
	ld	[hl], a
	dec	hl
	ld	[hl], e
;src/editor/editor.c:764: for (i = win_chunks - 1; i && win_kept[i] > target; --i);
	ld	hl, _win_chunks
	ld	a, [hl]
	add	a, $FF
	ld	hl, sp+10
	ld	[hl], a
.l00113:
	ld	hl, sp+10
	ld	a, [hl]
	dec	hl
	dec	hl
	ld	[hl], a
	inc	hl
	ld	[hl], $00
	dec	hl
	sla	[hl]
	inc	hl
	rl	[hl]
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, _win_kept
	add	hl, de
	inc	sp
	inc	sp
	push	hl
	ld	hl, sp+10
	ld	a, [hl]
	or	a, a
	jp	Z, .l00105
	pop	de
	push	de
	ld	a, [de]
	ld	c, a
	inc	de
	ld	a, [de]
	ld	b, a
	ld	hl, sp+6
	ld	a, [hl]
	sub	a, c
	inc	hl
	ld	a, [hl]
	sbc	a, b
	jp	NC, .l00105
	ld	hl, sp+10
	dec	[hl]
	jp	.l00113
.l00105:
;src/editor/editor.c:765: if (!i) return;
	ld	hl, sp+10
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00107
	jp	.l00115
.l00107:
;src/editor/editor.c:766: doc_pos = ((win_start + 511) & ~511UL) + ((unsigned long)i << 9);
	ld	hl, _win_start + 1
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, e
	add	a, $FF
	ld	e, a
	ld	a, d
	adc	a, $01
	push	af
	ld	hl, sp+5
	ld	[hl], a
	dec	hl
	ld	[hl], e
	ld	hl, _win_start + 3
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	pop	af
	ld	a, e
	adc	a, $00
	ld	e, a
	ld	a, d
	adc	a, $00
	ld	hl, sp+5
	ld	[hl], a
	dec	hl
	ld	[hl], e
	inc	hl
	inc	hl
	ld	[hl], $00
	ld	hl, sp+3
	ld	a, [hl]
	and	a, $FE
	ld	hl, sp+7
	ld	[hl], a
	ld	hl, sp+4
	ld	a, [hl]
	ld	hl, sp+8
	ld	[hl], a
	ld	hl, sp+5
	ld	a, [hl]
	ld	hl, sp+9
	ld	[hl], a
	inc	hl
	ld	c, [hl]
	ld	b, $00
	ld	de, $0000
	ld	d, e
	ld	e, b
	ld	b, c
	ld	c, $00
	sla	b
	rl	e
	rl	d
	ld	hl, sp+2
	ld	[hl], c
	inc	hl
	ld	[hl], b
	inc	hl
	ld	[hl], e
	inc	hl
	ld	[hl], d
	inc	hl
	inc	hl
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, e
	ld	hl, sp+2
	add	a, [hl]
	ld	e, a
	ld	a, d
	inc	hl
	adc	a, [hl]
	push	af
	ld	hl, _doc_pos + 1
	ld	[hl], a
	dec	hl
	ld	[hl], e
	ld	hl, sp+11
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, sp+6
	pop	af
	ld	a, e
	adc	a, [hl]
	ld	e, a
	ld	a, d
	inc	hl
	adc	a, [hl]
	ld	hl, _doc_pos + 3
	ld	[hl], a
	dec	hl
	ld	[hl], e
;src/editor/editor.c:767: DocLineStart();
	call	_DocLineStart
;src/editor/editor.c:768: shift = win_kept[i] - doc_back;
	pop	de
	push	de
	ld	a, [de]
	ld	c, a
	inc	de
	ld	a, [de]
	ld	b, a
	ld	a, c
	ld	hl, _doc_back
	sub	a, [hl]
	ld	c, a
	ld	a, b
	inc	hl
	sbc	a, [hl]
	ld	b, a
;src/editor/editor.c:769: win_lines += tb_CountLines(0, shift);
	push	bc
	ld	de, $0000
	call	_tb_CountLines
	ld	e, c
	ld	d, b
	pop	bc
	ld	hl, sp+7
	ld	[hl], e
	inc	hl
	ld	[hl], d
	xor	a, a
	inc	hl
	ld	[hl], a
	inc	hl
	ld	[hl], a
	ld	hl, _win_lines + 1
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, e
	ld	hl, sp+7
	add	a, [hl]
	ld	e, a
	ld	a, d
	inc	hl
	adc	a, [hl]
	push	af
	ld	hl, _win_lines + 1
	ld	[hl], a
	dec	hl
	ld	[hl], e
	ld	hl, _win_lines + 3
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, sp+11
	pop	af
	ld	a, e
	adc	a, [hl]
	ld	e, a
	ld	a, d
	inc	hl
	adc	a, [hl]
	ld	hl, _win_lines + 3
	ld	[hl], a
	dec	hl
	ld	[hl], e
;src/editor/editor.c:770: win_start = doc_pos;
	ld	hl, _doc_pos
	ld	d, h
	ld	e, l
	ld	hl, _win_start
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
;src/editor/editor.c:771: LoadWindow();
	push	bc
	call	_LoadWindow
	pop	bc
;src/editor/editor.c:772: ShiftPositions(shift, 1);
	ld	a, $01
	ld	e, c
	ld	d, b
	call	_ShiftPositions
	jp	.l00115
.l00109:
;src/editor/editor.c:775: doc_pos = win_start > WIN_SIZE / 2 ? win_start - WIN_SIZE / 2 : 0;
	ld	hl, _win_start
	ld	a, $00
	sub	a, [hl]
	inc	hl
	ld	a, $60
	sbc	a, [hl]
	inc	hl
	ld	a, $00
	sbc	a, [hl]
	inc	hl
	ld	a, $00
	sbc	a, [hl]
	jp	NC, .l00122
	ld	hl, _win_start + 1
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, e
	sub	a, $00
	ld	e, a
	ld	a, d
	sbc	a, $60
	push	af
	ld	hl, sp+10
	ld	[hl], a
	dec	hl
	ld	[hl], e
	ld	hl, _win_start + 3
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	pop	af
	ld	a, e
	sbc	a, $00
	ld	e, a
	ld	a, d
	sbc	a, $00
	ld	hl, sp+10
	ld	[hl], a
	dec	hl
	ld	[hl], e
	jp	.l00123
.l00122:
	xor	a, a
	ld	hl, sp+7
	ld	[hl], a
	inc	hl
	ld	[hl], a
	inc	hl
	ld	[hl], a
	inc	hl
	ld	[hl], a
.l00123:
	ld	hl, sp+7
	ld	d, h
	ld	e, l
	ld	hl, _doc_pos
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
;src/editor/editor.c:776: DocLineStart();
	call	_DocLineStart
;src/editor/editor.c:777: win_mark = win_start;
	ld	hl, _win_start
	ld	d, h
	ld	e, l
	ld	hl, _win_mark
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
;src/editor/editor.c:778: win_start = doc_pos;
	ld	hl, _doc_pos
	ld	d, h
	ld	e, l
	ld	hl, _win_start
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
;src/editor/editor.c:779: LoadWindow();
	call	_LoadWindow
;src/editor/editor.c:780: shift = win_mark_pos == 0xFFFF ? 0 : win_mark_pos;
	ld	hl, _win_mark_pos
	ld	a, [hl]
	inc	a
	jp	NZ,.l00191
	inc	hl
	ld	a, [hl]
	inc	a
	jp	NZ,.l00191
	jp	.l00192
.l00191:
	jp	.l00124
.l00192:
	ld	bc, $0000
	jp	.l00125
.l00124:
	ld	hl, _win_mark_pos
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
.l00125:
;src/editor/editor.c:781: win_lines -= tb_CountLines(0, shift);
	push	bc
	ld	de, $0000
	call	_tb_CountLines
	ld	e, c
	ld	d, b
	pop	bc
	ld	hl, sp+7
	ld	[hl], e
	inc	hl
	ld	[hl], d
	xor	a, a
	inc	hl
	ld	[hl], a
	inc	hl
	ld	[hl], a
	ld	hl, _win_lines + 1
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, e
	ld	hl, sp+7
	sub	a, [hl]
	ld	e, a
	ld	a, d
	inc	hl
	sbc	a, [hl]
	push	af
	ld	hl, _win_lines + 1
	ld	[hl], a
	dec	hl
	ld	[hl], e
	ld	hl, _win_lines + 3
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, sp+11
	pop	af
	ld	a, e
	sbc	a, [hl]
	ld	e, a
	ld	a, d
	inc	hl
	sbc	a, [hl]
	ld	hl, _win_lines + 3
	ld	[hl], a
	dec	hl
	ld	[hl], e
;src/editor/editor.c:782: ShiftPositions(shift, 0);
	xor	a, a
	ld	e, c
	ld	d, b
	call	_ShiftPositions
.l00115:
;src/editor/editor.c:784: }
	add	sp, 11
	ret
;src/editor/editor.c:787: static void GoStart(void) {
;	---------------------------------
	SECTION FRAGMENT "Page 6",ROMX,BANK[3]
	LOAD FRAGMENT "Page 6 RAM",SRAM,BANK[6]
; Function GoStart
; ---------------------------------
_GoStart:
;src/editor/editor.c:788: if (doc_large && win_start && Commit()) {
	ld	hl, _doc_large
	ld	a, [hl]
	or	a, a
	jp	Z, .l00102
	ld	hl, _win_start + 3
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	dec	hl
	or	a, [hl]
	dec	hl
	or	a, [hl]
	jp	Z, .l00102
	call	_Commit
	or	a, a
	jp	Z, .l00102
;src/editor/editor.c:789: selecting = 0;
	ld	hl, _selecting
	ld	[hl], $00
;src/editor/editor.c:790: win_start = win_lines = 0;
	xor	a, a
	ld	hl, _win_lines
	ld	[hl], a
	inc	hl
	ld	[hl], a
	inc	hl
	ld	[hl], a
	inc	hl
	ld	[hl], a
	xor	a, a
	ld	hl, _win_start
	ld	[hl], a
	inc	hl
	ld	[hl], a
	inc	hl
	ld	[hl], a
	inc	hl
	ld	[hl], a
;src/editor/editor.c:791: win_mark = NO_MARK;
	ld	hl, _win_mark
	ld	[hl], $FF
	inc	hl
	ld	[hl], $FF
	inc	hl
	ld	[hl], $FF
	inc	hl
	ld	[hl], $FF
;src/editor/editor.c:792: lines_known = 1;
	ld	hl, _lines_known
	ld	[hl], $01
;src/editor/editor.c:793: LoadWindow();
	call	_LoadWindow
.l00102:
;src/editor/editor.c:795: cursor = 0;
	xor	a, a
	ld	hl, _cursor
	ld	[hl], a
	inc	hl
	ld	[hl], a
.l00105:
;src/editor/editor.c:796: }
	ret
;src/editor/editor.c:799: static void GoEnd(void) {
;	---------------------------------
	SECTION FRAGMENT "Page 6",ROMX,BANK[3]
	LOAD FRAGMENT "Page 6 RAM",SRAM,BANK[6]
; Function GoEnd
; ---------------------------------
_GoEnd:
;src/editor/editor.c:800: if (doc_large && win_end != doc_len && Commit()) {
	ld	hl, _doc_large
	ld	a, [hl]
	or	a, a
	jp	Z, .l00102
	ld	hl, _win_end
	ld	a, [hl]
	ld	hl, _doc_len
	sub	a, [hl]
	jp	NZ,.l00122
	ld	hl, _win_end + 1
	ld	a, [hl]
	ld	hl, _doc_len + 1
	sub	a, [hl]
	jp	NZ,.l00122
	ld	hl, _win_end + 2
	ld	a, [hl]
	ld	hl, _doc_len + 2
	sub	a, [hl]
	jp	NZ,.l00122
	ld	hl, _win_end + 3
	ld	a, [hl]
	ld	hl, _doc_len + 3
	sub	a, [hl]
	jp	NZ,.l00122
	jp	.l00102
.l00122:
	call	_Commit
	or	a, a
	jp	Z, .l00102
;src/editor/editor.c:801: selecting = 0;
	ld	hl, _selecting
	ld	[hl], $00
;src/editor/editor.c:802: doc_pos = doc_len - WIN_SIZE / 2; // the window isn't the whole file, so it's longer than this
	ld	hl, _doc_len + 1
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, e
	sub	a, $00
	ld	e, a
	ld	a, d
	sbc	a, $60
	push	af
	ld	hl, _doc_pos + 1
	ld	[hl], a
	dec	hl
	ld	[hl], e
	ld	hl, _doc_len + 3
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	pop	af
	ld	a, e
	sbc	a, $00
	ld	e, a
	ld	a, d
	sbc	a, $00
	ld	hl, _doc_pos + 3
	ld	[hl], a
	dec	hl
	ld	[hl], e
;src/editor/editor.c:803: DocLineStart();
	call	_DocLineStart
;src/editor/editor.c:804: win_start = doc_pos;
	ld	hl, _doc_pos
	ld	d, h
	ld	e, l
	ld	hl, _win_start
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
;src/editor/editor.c:805: win_mark = NO_MARK;
	ld	hl, _win_mark
	ld	[hl], $FF
	inc	hl
	ld	[hl], $FF
	inc	hl
	ld	[hl], $FF
	inc	hl
	ld	[hl], $FF
;src/editor/editor.c:806: LoadWindow();
	call	_LoadWindow
;src/editor/editor.c:807: LinesUnknown();
	call	_LinesUnknown
.l00102:
;src/editor/editor.c:809: cursor = tb_Length();
	call	_tb_Length
	ld	hl, _cursor
	ld	[hl], c
	inc	hl
	ld	[hl], b
.l00105:
;src/editor/editor.c:810: }
	ret
;src/editor/editor.c:813: static void HandleCtrlKey(unsigned char key, unsigned char mods) {
;	---------------------------------
	SECTION FRAGMENT "Page 6",ROMX,BANK[3]
	LOAD FRAGMENT "Page 6 RAM",SRAM,BANK[6]
; Function HandleCtrlKey
; ---------------------------------
_HandleCtrlKey:
	ld	l, a
;	spillPairReg hl
;	spillPairReg hl
;src/editor/editor.c:814: if (key >= 'A' && key <= 'Z') key += 'a' - 'A';
	ld	a, l
	sub	a, $41
	jp	C, .l00102
	ld	a, $5A
	sub	a, l
	jp	C, .l00102
	ld	c, $20
	add	hl, bc
.l00102:
;src/editor/editor.c:815: if (key == 'z') UndoRedo(mods & KB_MOD_SHIFT);
	ld	a, l
	sub	a, $7A
	jp	NZ,.l00162
	jp	.l00163
.l00162:
	jp	.l00107
.l00163:
	ld	a, e
	and	a, $40
	ld	c, a
	push	hl
	ld	a, c
	call	_UndoRedo
	pop	hl
	jp	.l00108
.l00107:
;src/editor/editor.c:816: else if (key == 'y') UndoRedo(1);
	ld	a, l
	sub	a, $79
	jp	NZ,.l00164
	jp	.l00165
.l00164:
	jp	.l00108
.l00165:
	push	hl
	ld	a, $01
	call	_UndoRedo
	pop	hl
.l00108:
;src/editor/editor.c:817: if (key == 'a') SelectAll();
	ld	a, l
	sub	a, $61
	jp	NZ,.l00166
	jp	.l00167
.l00166:
	jp	.l00118
.l00167:
	jp	_SelectAll
	jp	.l00120
.l00118:
;src/editor/editor.c:818: else if (key == 'c') Copy();
	ld	a, l
	sub	a, $63
	jp	NZ,.l00168
	jp	.l00169
.l00168:
	jp	.l00115
.l00169:
	jp	_Copy
	jp	.l00120
.l00115:
;src/editor/editor.c:819: else if (key == 'x') Cut();
	ld	a, l
	sub	a, $78
	jp	NZ,.l00170
	jp	.l00171
.l00170:
	jp	.l00112
.l00171:
	jp	_Cut
	jp	.l00120
.l00112:
;src/editor/editor.c:820: else if (key == 'v') Paste();
	ld	a, l
	sub	a, $76
	jp	NZ,.l00172
	jp	.l00173
.l00172:
	jp	.l00120
.l00173:
	jp	_Paste
.l00120:
;src/editor/editor.c:821: }
	ret
;src/editor/editor.c:824: static void HandleKey(unsigned char key, unsigned char mods) {
;	---------------------------------
	SECTION FRAGMENT "Page 5",ROMX,BANK[2]
	LOAD FRAGMENT "Page 5 RAM",SRAM,BANK[5]
; Function HandleKey
; ---------------------------------
_HandleKey:
	add	sp, -6
	ld	hl, sp+5
	ld	[hl], a
	dec	hl
	ld	[hl], e
;src/editor/editor.c:825: unsigned char ctrl = mods & KB_MOD_CTRL, join = 0;
	ld	a, [hl]
	and	a, $20
	ld	hl, sp+0
	ld	[hl], a
	inc	hl
	ld	[hl], $00
;src/editor/editor.c:826: if (mods & (KB_MOD_ALT | KB_MOD_SUPER)) return;
	ld	hl, sp+4
	ld	a, [hl]
	and	a, $18
	jp	NZ,.l00349
	jp	.l00102
.l00349:
	jp	.l00170
.l00102:
;src/editor/editor.c:827: if (key >= KEY_LEFT && key <= KEY_PAGE_DOWN) undo_merge = 0; // moving starts a new undo step
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
;src/editor/editor.c:828: if (key < KEY_LEFT || key > KEY_PAGE_DOWN) {
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
;src/editor/editor.c:829: if (ctrl) {
	ld	hl, sp+0
	ld	a, [hl]
	or	a, a
	jp	Z, .l00121
;src/editor/editor.c:830: HandleCtrlKey(key, mods);
	ld	hl, sp+4
	ld	e, [hl]
	inc	hl
	ld	a, [hl]
	call	_HandleCtrlKey__far
;src/editor/editor.c:831: return;
	jp	.l00170
.l00120:
;src/editor/editor.c:834: else if (mods & KB_MOD_SHIFT) { // shift + movement selects
	push	hl
	ld	hl, sp+6
	bit	6, [hl]
	pop	hl
	jp	NZ,.l00350
	jp	.l00117
.l00350:
;src/editor/editor.c:835: if (!selecting) anchor = cursor;
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
;src/editor/editor.c:836: selecting = 1;
	ld	hl, _selecting
	ld	[hl], $01
;src/editor/editor.c:837: redraw = 1;
	ld	hl, _redraw
	ld	[hl], $01
	jp	.l00121
.l00117:
;src/editor/editor.c:839: else if (!ctrl && GetSelection() && (key == KEY_LEFT || key == KEY_RIGHT)) { // to that end of the selection
	ld	hl, sp+0
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00111
	call	_GetSelection__far
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
;src/editor/editor.c:840: cursor = key == KEY_LEFT ? sel_start : sel_end;
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
;src/editor/editor.c:841: ClearSelection();
	call	_ClearSelection
;src/editor/editor.c:842: moved = 1;
	ld	hl, _moved
	ld	[hl], $01
;src/editor/editor.c:843: return;
	jp	.l00170
.l00111:
;src/editor/editor.c:845: else ClearSelection();
	call	_ClearSelection
.l00121:
;src/editor/editor.c:846: moved = 1;
	ld	hl, _moved
	ld	[hl], $01
;src/editor/editor.c:847: if (ctrl) {
	ld	hl, sp+0
	ld	a, [hl]
	or	a, a
	jp	Z, .l00131
;src/editor/editor.c:848: switch (key) {
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
;src/editor/editor.c:849: case KEY_LEFT: WordLeft(); return;
.l00123:
	call	_WordLeft__far
	jp	.l00170
;src/editor/editor.c:850: case KEY_RIGHT: WordRight(); return;
.l00124:
	call	_WordRight__far
	jp	.l00170
;src/editor/editor.c:851: case KEY_UP: ScrollLine(0); return;
.l00125:
	xor	a, a
	call	_ScrollLine
	jp	.l00170
;src/editor/editor.c:852: case KEY_DOWN: ScrollLine(1); return;
.l00126:
	ld	a, $01
	call	_ScrollLine
	jp	.l00170
;src/editor/editor.c:853: case KEY_HOME: GoStart(); return;
.l00127:
	call	_GoStart__far
	jp	.l00170
;src/editor/editor.c:854: case KEY_END: GoEnd(); return;
.l00128:
	call	_GoEnd__far
	jp	.l00170
;src/editor/editor.c:855: }
.l00131:
;src/editor/editor.c:857: switch (key) {
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
;src/editor/editor.c:858: case KEY_UP: MoveUp(); return;
.l00132:
	call	_MoveUp__far
	jp	.l00170
;src/editor/editor.c:859: case KEY_DOWN: MoveDown(); return;
.l00133:
	call	_MoveDown__far
	jp	.l00170
;src/editor/editor.c:860: case KEY_PAGE_UP: PageUp(); return;
.l00134:
	call	_PageUp__far
	jp	.l00170
;src/editor/editor.c:861: case KEY_PAGE_DOWN: PageDown(); return;
.l00135:
	call	_PageDown__far
	jp	.l00170
;src/editor/editor.c:862: case KEY_LEFT: if (cursor) --cursor; return;
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
;src/editor/editor.c:863: case KEY_RIGHT: if (cursor != tb_Length()) ++cursor; return;
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
;src/editor/editor.c:864: case KEY_HOME: cursor = tb_row_starts[tb_found_row]; return;
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
;src/editor/editor.c:865: case KEY_END: MoveEnd(); return;
.l00143:
	call	_MoveEnd__far
	jp	.l00170
;src/editor/editor.c:866: }
.l00144:
;src/editor/editor.c:867: moved = 0;
	ld	hl, _moved
	ld	[hl], $00
;src/editor/editor.c:868: if (key == KEY_ESCAPE || key == KEY_INSERT) return;
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
;src/editor/editor.c:869: if (GetSelection()) { // typing replaces the selection
	call	_GetSelection__far
	or	a, a
	jp	Z, .l00152
;src/editor/editor.c:870: DeleteSelection();
	call	_DeleteSelection__far
;src/editor/editor.c:871: if (key == KEY_BACKSPACE || key == KEY_DELETE) return;
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
;src/editor/editor.c:872: join = 1;
	ld	hl, sp+1
	ld	[hl], $01
.l00152:
;src/editor/editor.c:874: selecting = 0;
	ld	hl, _selecting
	ld	[hl], $00
;src/editor/editor.c:875: switch (key) {
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
;src/editor/editor.c:876: case KEY_BACKSPACE:
.l00153:
;src/editor/editor.c:877: if (!cursor) break;
	ld	hl, _cursor + 1
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	jp	Z, .l00170
;src/editor/editor.c:878: --cursor;
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
;src/editor/editor.c:880: case KEY_DELETE:
.l00156:
;src/editor/editor.c:881: if (cursor < tb_Length()) {
	call	_tb_Length
	ld	hl, _cursor
	ld	a, [hl]
	sub	a, c
	inc	hl
	ld	a, [hl]
	sbc	a, b
	jp	NC, .l00170
;src/editor/editor.c:882: UndoDeleting(cursor, 1);
	ld	bc, $0001
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_UndoDeleting
;src/editor/editor.c:883: CountEdit(cursor, tb_Delete(cursor), 0);
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
;src/editor/editor.c:884: Edited(cursor, -1);
	ld	a, $FF
	ld	hl, _cursor
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_Edited
;src/editor/editor.c:886: break;
	jp	.l00170
;src/editor/editor.c:887: default:
.l00159:
;src/editor/editor.c:888: if (key < ' ' && key != ASCII_TAB && key != ASCII_LF) return;
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
;src/editor/editor.c:889: if (key >= KEY_LEFT && key < 0xA0) return; // unprintable in Latin-1
	ld	hl, sp+5
	ld	a, [hl]
	sub	a, $80
	jp	C, .l00165
	ld	a, [hl]
	sub	a, $A0
	jp	NC, .l00165
	jp	.l00170
.l00165:
;src/editor/editor.c:890: if (tb_Insert(cursor, key)) {
	ld	hl, sp+5
	ld	a, [hl]
	ld	hl, _cursor
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_tb_Insert
	or	a, a
	jp	Z, .l00170
;src/editor/editor.c:891: undo_join = join;
	ld	hl, sp+1
	ld	a, [hl]
	ld	hl, _undo_join
	ld	[hl], a
;src/editor/editor.c:892: UndoInserted(cursor, 1);
	ld	bc, $0001
	ld	hl, _cursor
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_UndoInserted
;src/editor/editor.c:893: CountEdit(cursor, key, 1);
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
;src/editor/editor.c:894: Edited(cursor++, 1);
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
;src/editor/editor.c:896: }
.l00170:
;src/editor/editor.c:897: }
	add	sp, 6
	ret
;src/editor/editor.c:900: static unsigned char DpadRepeat(unsigned char pressed) {
;	---------------------------------
	SECTION FRAGMENT "Page 6",ROMX,BANK[3]
	LOAD FRAGMENT "Page 6 RAM",SRAM,BANK[6]
; Function DpadRepeat
; ---------------------------------
_DpadRepeat:
	ld	c, a
;src/editor/editor.c:901: unsigned char held = (button_state | pressed) & PADF_DPAD;
	ld	hl, _button_state
	ld	a, [hl]
	or	a, c
	and	a, $F0
	ld	b, a
;src/editor/editor.c:902: if (!held) return 0;
	or	a, a
	jp	NZ, .l00102
	xor	a, a
	jp	.l00109
.l00102:
;src/editor/editor.c:903: if (pressed & PADF_DPAD) pad_timer = PAD_REPEAT_DELAY;
	ld	a, c
	and	a, $F0
	jp	NZ,.l00126
	jp	.l00107
.l00126:
	ld	hl, _pad_timer
	ld	[hl], $14
	jp	.l00108
.l00107:
;src/editor/editor.c:904: else if (--pad_timer) return 0;
	ld	hl, _pad_timer
	dec	[hl]
	ld	a, [hl]
	or	a, a
	jp	Z, .l00104
	xor	a, a
	jp	.l00109
.l00104:
;src/editor/editor.c:905: else pad_timer = PAD_REPEAT_RATE;
	ld	hl, _pad_timer
	ld	[hl], $04
.l00108:
;src/editor/editor.c:906: return held;
	ld	a, b
.l00109:
;src/editor/editor.c:907: }
	ret
;src/editor/editor.c:910: static void SetRows(void) {
;	---------------------------------
	SECTION FRAGMENT "Page 5",ROMX,BANK[2]
	LOAD FRAGMENT "Page 5 RAM",SRAM,BANK[5]
; Function SetRows
; ---------------------------------
_SetRows:
;src/editor/editor.c:911: bars = bars_on;
	ld	hl, _bars_on
	ld	a, [hl]
	ld	hl, _bars
	ld	[hl], a
;src/editor/editor.c:912: tb_rows = TextRows();
	call	_TextRows
	ld	hl, _tb_rows
	ld	[hl], a
;src/editor/editor.c:913: Layout();
	call	_Layout
;src/editor/editor.c:914: if (osk_shown) {
	ld	hl, _osk_shown
	ld	a, [hl]
	or	a, a
	jp	Z, .l00102
;src/editor/editor.c:915: OSKDraw(osk_layer, tb_rows);
	ld	hl, _tb_rows
	ld	e, [hl]
	ld	hl, _osk_layer
	ld	a, [hl]
	call	_OSKDraw
;src/editor/editor.c:916: OSKSelect(osk_x, osk_y);
	ld	hl, _osk_y
	ld	e, [hl]
	ld	hl, _osk_x
	ld	a, [hl]
	call	_OSKSelect
.l00102:
;src/editor/editor.c:918: OSKShow(osk_shown);
	ld	hl, _osk_shown
	ld	a, [hl]
	call	_OSKShow
;src/editor/editor.c:919: dirty = 1;
	ld	hl, _dirty
	ld	[hl], $01
.l00103:
;src/editor/editor.c:920: }
	ret
;src/editor/editor.c:925: static void PickOSKBlocks(void) {
;	---------------------------------
	SECTION FRAGMENT "Page 5",ROMX,BANK[2]
	LOAD FRAGMENT "Page 5 RAM",SRAM,BANK[5]
; Function PickOSKBlocks
; ---------------------------------
_PickOSKBlocks:
	add	sp, -6
;src/editor/editor.c:926: unsigned char i, j, row, length = tb_rows + render_gbc, rows = tb_rows - OSK_ROWS, shift = 0;
	ld	hl, _tb_rows
	ld	a, [hl]
	ld	hl, _render_gbc
	add	a, [hl]
	ld	hl, sp+0
	ld	[hl], a
	ld	hl, _tb_rows
	ld	a, [hl]
	add	a, $FB
	ld	c, a
	ld	hl, sp+1
	ld	[hl], $00
;src/editor/editor.c:927: if (tb_found_row != 0xFF && tb_found_row >= rows) shift = tb_found_row - rows + 1;
	ld	hl, _tb_found_row
	ld	a, [hl]
	inc	a
	jp	NZ,.l00179
	jp	.l00102
.l00179:
	ld	hl, _tb_found_row
	ld	a, [hl]
	sub	a, c
	jp	C, .l00102
	ld	a, [hl]
	sub	a, c
	inc	a
	ld	hl, sp+1
	ld	[hl], a
.l00102:
;src/editor/editor.c:928: row = rows + shift; // hidden: the rows below the ones that stay, then the ones scrolled off the top
	ld	a, c
	ld	hl, sp+1
	add	a, [hl]
	ld	hl, sp+4
	ld	[hl], a
;src/editor/editor.c:929: for (j = 0; j < OSK_ROWS; ++j) {
	inc	hl
	ld	[hl], $00
.l00119:
;src/editor/editor.c:930: if (row == tb_rows) row = 0;
	ld	hl, _tb_rows
	ld	a, [hl]
	ld	hl, sp+4
	sub	a, [hl]
	jp	NZ,.l00180
	jp	.l00181
.l00180:
	jp	.l00105
.l00181:
	ld	hl, sp+4
	ld	[hl], $00
.l00105:
;src/editor/editor.c:931: i = ring_pos + row;
	ld	hl, _ring_pos
	ld	a, [hl]
	ld	hl, sp+4
	add	a, [hl]
	ld	c, a
;src/editor/editor.c:932: if (i >= length) i -= length;
	ld	a, c
	ld	hl, sp+0
	sub	a, [hl]
	jp	C, .l00107
	ld	a, c
	sub	a, [hl]
	ld	c, a
.l00107:
;src/editor/editor.c:933: osk_blocks[j] = ring_blocks[i];
	ld	de, _osk_blocks
	ld	hl, sp+5
	ld	l, [hl]
	ld	h, $00
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+4
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+3
	ld	[hl], a
	ld	hl, _ring_blocks
	ld	b, $00
	add	hl, bc
	ld	c, [hl]
	ld	hl, sp+2
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	ld	[hl], c
;src/editor/editor.c:934: if (osk_blocks[j] == HEADER_BLOCK || osk_blocks[j] == STATUS_BLOCK) {
	ld	a, c
	sub	a, $08
	jp	NZ,.l00182
	jp	.l00128
.l00182:
	ld	hl, sp+3
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	sub	a, $11
	jp	NZ,.l00183
	jp	.l00184
.l00183:
	jp	.l00110
.l00184:
;src/editor/editor.c:935: for (j = 0; j < OSK_ROWS; ++j) osk_blocks[j] = OSK_BLOCK + j;
.l00128:
	ld	c, $00
.l00117:
	ld	hl, _osk_blocks
	ld	b, $00
	add	hl, bc
	ld	a, c
	add	a, $09
	ld	[hl], a
	inc	c
	ld	a, c
	sub	a, $05
	jp	C, .l00117
;src/editor/editor.c:936: return;
	jp	.l00121
.l00110:
;src/editor/editor.c:938: ++row;
	ld	hl, sp+4
	inc	[hl]
;src/editor/editor.c:929: for (j = 0; j < OSK_ROWS; ++j) {
	inc	hl
	inc	[hl]
	ld	a, [hl]
	sub	a, $05
	jp	C, .l00119
;src/editor/editor.c:940: if (!shift) return;
	ld	hl, sp+1
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00114
	jp	.l00121
.l00114:
;src/editor/editor.c:941: ring_pos += shift;
	ld	hl, _ring_pos
	ld	a, [hl]
	ld	hl, sp+1
	add	a, [hl]
	ld	hl, _ring_pos
	ld	[hl], a
;src/editor/editor.c:942: if (ring_pos >= length) ring_pos -= length;
	ld	a, [hl]
	ld	hl, sp+0
	sub	a, [hl]
	jp	C, .l00116
	ld	hl, _ring_pos
	ld	a, [hl]
	ld	hl, sp+0
	sub	a, [hl]
	ld	hl, _ring_pos
	ld	[hl], a
.l00116:
;src/editor/editor.c:943: ring_top = (ring_top + shift) & (BG_MAP_ROWS - 1);
	ld	hl, _ring_top
	ld	a, [hl]
	ld	hl, sp+1
	add	a, [hl]
	and	a, $1F
	ld	hl, _ring_top
	ld	[hl], a
;src/editor/editor.c:944: top = tb_row_starts[shift];
	ld	hl, sp+1
	ld	a, [hl]
	ld	hl, sp+4
	ld	[hl], a
	inc	hl
	ld	[hl], $00
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
	ld	hl, _top
	ld	[hl], a
	inc	de
	ld	a, [de]
	inc	hl
	ld	[hl], a
.l00121:
;src/editor/editor.c:945: }
	add	sp, 6
	ret
;src/editor/editor.c:947: static void ToggleOSK(void) {
;	---------------------------------
	SECTION FRAGMENT "Page 6",ROMX,BANK[3]
	LOAD FRAGMENT "Page 6 RAM",SRAM,BANK[6]
; Function ToggleOSK
; ---------------------------------
_ToggleOSK:
;src/editor/editor.c:948: osk_shown = !osk_shown;
	ld	hl, _osk_shown
	ld	a, [hl]
	sub	a,$01
	ld	a, $00
	rla
	ld	[hl], a
;src/editor/editor.c:949: if (osk_shown) PickOSKBlocks();
	ld	a, [hl]
	or	a, a
	jp	Z, .l00102
	call	_PickOSKBlocks__far
.l00102:
;src/editor/editor.c:950: SetRows();
	jp	_SetRows__far
.l00103:
;src/editor/editor.c:951: }
	ret
;src/editor/editor.c:954: static void ToggleBars(void) {
;	---------------------------------
	SECTION FRAGMENT "Page 6",ROMX,BANK[3]
	LOAD FRAGMENT "Page 6 RAM",SRAM,BANK[6]
; Function ToggleBars
; ---------------------------------
_ToggleBars:
;src/editor/editor.c:955: bars_on = !bars_on;
	ld	hl, _bars_on
	ld	a, [hl]
	sub	a,$01
	ld	a, $00
	rla
	ld	[hl], a
;src/editor/editor.c:956: SetRows();
	call	_SetRows__far
;src/editor/editor.c:957: SettingsSave();
	jp	_SettingsSave
.l00101:
;src/editor/editor.c:958: }
	ret
;src/editor/editor.c:960: static void SetOSKLayer(unsigned char layer) {
;	---------------------------------
	SECTION FRAGMENT "Page 6",ROMX,BANK[3]
	LOAD FRAGMENT "Page 6 RAM",SRAM,BANK[6]
; Function SetOSKLayer
; ---------------------------------
_SetOSKLayer:
	ld	c, a
;src/editor/editor.c:961: osk_layer = osk_layer == layer ? OSK_LOWER : layer;
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
;src/editor/editor.c:962: OSKDraw(osk_layer, tb_rows);
	ld	hl, _tb_rows
	ld	e, [hl]
	ld	hl, _osk_layer
	ld	a, [hl]
	call	_OSKDraw
;src/editor/editor.c:963: dirty = 1;
	ld	hl, _dirty
	ld	[hl], $01
.l00101:
;src/editor/editor.c:964: }
	ret
;src/editor/editor.c:966: static unsigned char PressOSKKey(void) {
;	---------------------------------
	SECTION FRAGMENT "Page 6",ROMX,BANK[3]
	LOAD FRAGMENT "Page 6 RAM",SRAM,BANK[6]
; Function PressOSKKey
; ---------------------------------
_PressOSKKey:
;src/editor/editor.c:968: if (osk_y == OSK_ROWS - 1) {
	ld	hl, _osk_y
	ld	a, [hl]
	sub	a, $04
	jp	NZ,.l00165
	jp	.l00166
.l00165:
	jp	.l00120
.l00166:
;src/editor/editor.c:969: if (osk_x == 0) SetOSKLayer(OSK_SHIFT);
	ld	hl, _osk_x
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00117
	ld	a, $01
	call	_SetOSKLayer
	jp	.l00118
.l00117:
;src/editor/editor.c:970: else if (osk_x == 1) SetOSKLayer(OSK_SYMBOLS);
	ld	hl, _osk_x
	ld	a, [hl]
	dec	a
	jp	NZ,.l00167
	jp	.l00168
.l00167:
	jp	.l00114
.l00168:
	ld	a, $02
	call	_SetOSKLayer
	jp	.l00118
.l00114:
;src/editor/editor.c:971: else if (osk_x == 2) return KEY_MENU;
	ld	hl, _osk_x
	ld	a, [hl]
	sub	a, $02
	jp	NZ,.l00169
	jp	.l00170
.l00169:
	jp	.l00111
.l00170:
	ld	a, $89
	jp	.l00123
.l00111:
;src/editor/editor.c:972: else if (osk_x == OSK_COLS - 3) UndoRedo(0);
	ld	hl, _osk_x
	ld	a, [hl]
	sub	a, $07
	jp	NZ,.l00171
	jp	.l00172
.l00171:
	jp	.l00108
.l00172:
	xor	a, a
	call	_UndoRedo
	jp	.l00118
.l00108:
;src/editor/editor.c:973: else if (osk_x == OSK_COLS - 2) UndoRedo(1);
	ld	hl, _osk_x
	ld	a, [hl]
	sub	a, $08
	jp	NZ,.l00173
	jp	.l00174
.l00173:
	jp	.l00105
.l00174:
	ld	a, $01
	call	_UndoRedo
	jp	.l00118
.l00105:
;src/editor/editor.c:974: else if (osk_x == OSK_COLS - 1) return KEY_ENTER;
	ld	hl, _osk_x
	ld	a, [hl]
	sub	a, $09
	jp	NZ,.l00175
	jp	.l00176
.l00175:
	jp	.l00102
.l00176:
	ld	a, $0A
	jp	.l00123
.l00102:
;src/editor/editor.c:975: else return ' ';
	ld	a, $20
	jp	.l00123
.l00118:
;src/editor/editor.c:976: return KEY_NONE;
	xor	a, a
	jp	.l00123
.l00120:
;src/editor/editor.c:978: key = OSKGetKey(osk_layer, (osk_y << 3) + (osk_y << 1) + osk_x);
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
;src/editor/editor.c:979: if (osk_layer == OSK_SHIFT) SetOSKLayer(OSK_SHIFT); // shift is one shot
	ld	hl, _osk_layer
	ld	a, [hl]
	dec	a
	jp	NZ,.l00177
	jp	.l00178
.l00177:
	jp	.l00122
.l00178:
	push	bc
	ld	a, $01
	call	_SetOSKLayer
	pop	bc
.l00122:
;src/editor/editor.c:980: return key;
	ld	a, c
.l00123:
;src/editor/editor.c:981: }
	ret
;src/editor/editor.c:983: static void MoveOSKSelection(unsigned char held) {
;	---------------------------------
	SECTION FRAGMENT "Page 6",ROMX,BANK[3]
	LOAD FRAGMENT "Page 6 RAM",SRAM,BANK[6]
; Function MoveOSKSelection
; ---------------------------------
_MoveOSKSelection:
	ld	c, a
;src/editor/editor.c:984: if (held & PADF_UP) osk_y = osk_y ? osk_y - 1 : OSK_ROWS - 1;
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
;src/editor/editor.c:985: else if (held & PADF_DOWN) osk_y = osk_y == OSK_ROWS - 1 ? 0 : osk_y + 1;
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
;src/editor/editor.c:986: if (held & PADF_LEFT) osk_x = osk_x ? osk_x - 1 : OSK_COLS - 1;
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
;src/editor/editor.c:987: else if (held & PADF_RIGHT) osk_x = osk_x == OSK_COLS - 1 ? 0 : osk_x + 1;
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
;src/editor/editor.c:988: OSKSelect(osk_x, osk_y);
	ld	hl, _osk_y
	ld	e, [hl]
	ld	hl, _osk_x
	ld	a, [hl]
	jp	_OSKSelect
.l00111:
;src/editor/editor.c:989: }
	ret
;src/editor/editor.c:995: static unsigned char PadKey(void) {
;	---------------------------------
	SECTION FRAGMENT "Page 6",ROMX,BANK[3]
	LOAD FRAGMENT "Page 6 RAM",SRAM,BANK[6]
; Function PadKey
; ---------------------------------
_PadKey:
;src/editor/editor.c:996: unsigned char pressed = PadPressed();
	call	_PadPressed
	ld	c, a
;src/editor/editor.c:998: pad_mods = 0;
	ld	hl, _pad_mods
	ld	[hl], $00
;src/editor/editor.c:999: if (pressed & PADF_SELECT) ToggleOSK();
	bit	2, c
	jp	NZ,.l00185
	jp	.l00102
.l00185:
	push	bc
	call	_ToggleOSK
	pop	bc
.l00102:
;src/editor/editor.c:1000: if (pressed & PADF_B) return KEY_BACKSPACE;
	bit	1, c
	jp	NZ,.l00186
	jp	.l00104
.l00186:
	ld	a, $08
	jp	.l00123
.l00104:
;src/editor/editor.c:1001: if (pressed & PADF_START) return KEY_MENU;
	bit	3, c
	jp	NZ,.l00187
	jp	.l00106
.l00187:
	ld	a, $89
	jp	.l00123
.l00106:
;src/editor/editor.c:1002: if (osk_shown && (pressed & PADF_A)) return PressOSKKey();
	ld	hl, _osk_shown
	ld	a, [hl]
	or	a, a
	jp	Z, .l00108
	bit	0, c
	jp	NZ,.l00188
	jp	.l00108
.l00188:
	jp	_PressOSKKey
	jp	.l00123
.l00108:
;src/editor/editor.c:1003: held = DpadRepeat(pressed);
	ld	a, c
	call	_DpadRepeat
	ld	c, a
;src/editor/editor.c:1004: if (!held) return KEY_NONE;
	ld	a, c
	or	a, a
	jp	NZ, .l00111
	xor	a, a
	jp	.l00123
.l00111:
;src/editor/editor.c:1005: if (!osk_shown && (button_state & PADF_A)) pad_mods = KB_MOD_SHIFT;
	ld	hl, _osk_shown
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00113
	ld	hl, _button_state
	ld	a, [hl]
	rrca
	jp	C,.l00189
	jp	.l00113
.l00189:
	ld	hl, _pad_mods
	ld	[hl], $40
.l00113:
;src/editor/editor.c:1006: if (osk_shown) {
	ld	hl, _osk_shown
	ld	a, [hl]
	or	a, a
	jp	Z, .l00116
;src/editor/editor.c:1007: MoveOSKSelection(held);
	ld	a, c
	call	_MoveOSKSelection
;src/editor/editor.c:1008: return KEY_NONE;
	xor	a, a
	jp	.l00123
.l00116:
;src/editor/editor.c:1010: if (held & PADF_UP) return KEY_UP;
	bit	6, c
	jp	NZ,.l00190
	jp	.l00118
.l00190:
	ld	a, $82
	jp	.l00123
.l00118:
;src/editor/editor.c:1011: if (held & PADF_DOWN) return KEY_DOWN;
	bit	7, c
	jp	NZ,.l00191
	jp	.l00120
.l00191:
	ld	a, $83
	jp	.l00123
.l00120:
;src/editor/editor.c:1012: if (held & PADF_LEFT) return KEY_LEFT;
	bit	5, c
	jp	NZ,.l00192
	jp	.l00122
.l00192:
	ld	a, $80
	jp	.l00123
.l00122:
;src/editor/editor.c:1013: return KEY_RIGHT;
	ld	a, $81
.l00123:
;src/editor/editor.c:1014: }
	ret
;src/editor/editor.c:1018: static unsigned char MenuKey(void) {
;	---------------------------------
	SECTION FRAGMENT "Page 6",ROMX,BANK[3]
	LOAD FRAGMENT "Page 6 RAM",SRAM,BANK[6]
; Function MenuKey
; ---------------------------------
_MenuKey:
;src/editor/editor.c:1020: WaitFrame();
	call	_WaitFrame
;src/editor/editor.c:1021: if ((key = (unsigned char)KBPopEvent())) return key;
	call	_KBPopEvent
	ld	a, c
	ld	c, a
	or	a, a
	jp	Z, .l00102
	ld	a, c
	jp	.l00117
.l00102:
;src/editor/editor.c:1022: pressed = PadPressed();
	call	_PadPressed
	ld	c, a
;src/editor/editor.c:1023: if (pressed & PADF_A) return KEY_ENTER;
	bit	0, c
	jp	NZ,.l00159
	jp	.l00104
.l00159:
	ld	a, $0A
	jp	.l00117
.l00104:
;src/editor/editor.c:1024: if (pressed & PADF_B) return KEY_BACKSPACE;
	bit	1, c
	jp	NZ,.l00160
	jp	.l00106
.l00160:
	ld	a, $08
	jp	.l00117
.l00106:
;src/editor/editor.c:1025: if (pressed & PADF_START) return KEY_MENU;
	bit	3, c
	jp	NZ,.l00161
	jp	.l00108
.l00161:
	ld	a, $89
	jp	.l00117
.l00108:
;src/editor/editor.c:1026: held = DpadRepeat(pressed);
	ld	a, c
	call	_DpadRepeat
;src/editor/editor.c:1027: if (held & PADF_UP) return KEY_UP;
	bit	6, a
	jp	NZ,.l00162
	jp	.l00110
.l00162:
	ld	a, $82
	jp	.l00117
.l00110:
;src/editor/editor.c:1028: if (held & PADF_DOWN) return KEY_DOWN;
	bit	7, a
	jp	NZ,.l00163
	jp	.l00112
.l00163:
	ld	a, $83
	jp	.l00117
.l00112:
;src/editor/editor.c:1029: if (held & PADF_LEFT) return KEY_LEFT;
	bit	5, a
	jp	NZ,.l00164
	jp	.l00114
.l00164:
	ld	a, $80
	jp	.l00117
.l00114:
;src/editor/editor.c:1030: if (held & PADF_RIGHT) return KEY_RIGHT;
	bit	4, a
	jp	NZ,.l00165
	jp	.l00116
.l00165:
	ld	a, $81
	jp	.l00117
.l00116:
;src/editor/editor.c:1031: return KEY_NONE;
	xor	a, a
.l00117:
;src/editor/editor.c:1032: }
	ret
;src/editor/editor.c:1036: static void WaitDismiss(void) {
;	---------------------------------
	SECTION FRAGMENT "Page 6",ROMX,BANK[3]
	LOAD FRAGMENT "Page 6 RAM",SRAM,BANK[6]
; Function WaitDismiss
; ---------------------------------
_WaitDismiss:
;src/editor/editor.c:1038: while (1) {
.l00109:
;src/editor/editor.c:1039: WaitFrame();
	call	_WaitFrame
;src/editor/editor.c:1040: if ((key = KBPeekKey())) {
	call	_KBPeekKey
	ld	c, a
	or	a, a
	jp	Z, .l00105
;src/editor/editor.c:1041: if (key == KEY_ESCAPE || key == KEY_ENTER) KBPopEvent();
	ld	a, c
	sub	a, $1B
	jp	NZ,.l00133
	jp	.l00101
.l00133:
	ld	a, c
	sub	a, $0A
	jp	NZ,.l00134
	jp	.l00135
.l00134:
	jp	.l00102
.l00135:
.l00101:
	jp	_KBPopEvent
.l00102:
;src/editor/editor.c:1042: return;
	jp	.l00111
.l00105:
;src/editor/editor.c:1044: if (PadPressed()) return;
	call	_PadPressed
	or	a, a
	jp	Z, .l00109
.l00111:
;src/editor/editor.c:1046: }
	ret
;src/editor/editor.c:1048: static char* RowAddress(unsigned char row) {
;	---------------------------------
	SECTION FRAGMENT "Page 6",ROMX,BANK[3]
	LOAD FRAGMENT "Page 6 RAM",SRAM,BANK[6]
; Function RowAddress
; ---------------------------------
_RowAddress:
	ld	e, a
;src/editor/editor.c:1049: unsigned int offset = row;
	ld	d, $00
;src/editor/editor.c:1050: return (char*)tile_buffer + (offset << 5) + (offset << 3); // row * TB_STRIDE
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
;src/editor/editor.c:1051: }
	ret
;src/editor/editor.c:1054: static void DrawRow(unsigned char row, unsigned char col, const char* text) {
;	---------------------------------
	SECTION FRAGMENT "Page 6",ROMX,BANK[3]
	LOAD FRAGMENT "Page 6 RAM",SRAM,BANK[6]
; Function DrawRow
; ---------------------------------
_DrawRow:
	dec	sp
	dec	sp
	ld	c, a
	ld	hl, sp+1
	ld	[hl], e
;src/editor/editor.c:1055: char* dest = RowAddress(row);
	ld	a, c
	call	_RowAddress
;src/editor/editor.c:1057: for (i = 0; i < TB_STRIDE; ++i) dest[i] = ' ';
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
;src/editor/editor.c:1058: for (dest += col; *text && col < TB_STRIDE; ++col) *dest++ = *text++;
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
;src/editor/editor.c:1059: }
	inc	sp
	inc	sp
	pop	hl
	inc	sp
	inc	sp
	jp hl
;src/editor/editor.c:1061: static void ClearScreen(void) {
;	---------------------------------
	SECTION FRAGMENT "Page 6",ROMX,BANK[3]
	LOAD FRAGMENT "Page 6 RAM",SRAM,BANK[6]
; Function ClearScreen
; ---------------------------------
_ClearScreen:
;src/editor/editor.c:1063: for (row = 0; row < TB_ROWS; ++row) DrawRow(row, 0, "");
	ld	c, $00
.l00102:
	push	bc
	ld	de, ___src_editor_editor_c_str_49
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
;src/editor/editor.c:1064: }
	ret
	SECTION FRAGMENT "src/editor/editor.c FIXED",ROMX,BANK[1]
___src_editor_editor_c_str_49:
	DB $00
;src/editor/editor.c:1067: static void BeginFullScreen(void) {
;	---------------------------------
	SECTION FRAGMENT "Page 6",ROMX,BANK[3]
	LOAD FRAGMENT "Page 6 RAM",SRAM,BANK[6]
; Function BeginFullScreen
; ---------------------------------
_BeginFullScreen:
;src/editor/editor.c:1068: EditorShowCursor(0);
	xor	a, a
	call	_EditorShowCursor
;src/editor/editor.c:1069: if (osk_shown) OSKShow(0);
	ld	hl, _osk_shown
	ld	a, [hl]
	or	a, a
	jp	Z, .l00102
	xor	a, a
	call	_OSKShow
.l00102:
;src/editor/editor.c:1070: bars = 0;
	ld	hl, _bars
	ld	[hl], $00
;src/editor/editor.c:1071: tb_rows = TB_ROWS;
	ld	hl, _tb_rows
	ld	[hl], $12
;src/editor/editor.c:1072: Layout();
	call	_Layout__far
;src/editor/editor.c:1073: NoHighlight();
	call	_NoHighlight__far
;src/editor/editor.c:1074: dirty = 1;
	ld	hl, _dirty
	ld	[hl], $01
.l00103:
;src/editor/editor.c:1075: }
	ret
;src/editor/editor.c:1077: static void EndFullScreen(void) {
;	---------------------------------
	SECTION FRAGMENT "Page 6",ROMX,BANK[3]
	LOAD FRAGMENT "Page 6 RAM",SRAM,BANK[6]
; Function EndFullScreen
; ---------------------------------
_EndFullScreen:
;src/editor/editor.c:1078: SetRows();
	jp	_SetRows__far
.l00101:
;src/editor/editor.c:1079: }
	ret
;src/editor/editor.c:1082: static void OpenBox(unsigned char lines) {
;	---------------------------------
	SECTION FRAGMENT "Page 6",ROMX,BANK[3]
	LOAD FRAGMENT "Page 6 RAM",SRAM,BANK[6]
; Function OpenBox
; ---------------------------------
_OpenBox:
	ld	e, a
;src/editor/editor.c:1083: char* line = RowAddress(BOX_LINE);
	push	de
	ld	a, $14
	call	_RowAddress
	pop	de
;src/editor/editor.c:1084: unsigned char i, width, widest = 0;
	ld	d, $00
;src/editor/editor.c:1085: for (i = 0; i < lines; ++i, line += BOX_STRIDE) {
	ld	l, $00
;	spillPairReg hl
;	spillPairReg hl
.l00105:
	ld	a, l
	sub	a, e
	jp	NC, .l00103
;src/editor/editor.c:1086: width = RenderTextWidth(line);
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
;src/editor/editor.c:1087: if (width > widest) widest = width;
	ld	a, d
	sub	a, h
	jp	NC, .l00106
	ld	d, h
.l00106:
;src/editor/editor.c:1085: for (i = 0; i < lines; ++i, line += BOX_STRIDE) {
	inc	l
	ld	a, c
	add	a, $14
	ld	c, a
	jp	NC, .l00125
	inc	b
.l00125:
	jp	.l00105
.l00103:
;src/editor/editor.c:1089: render_box_text = RowAddress(BOX_LINE);
	push	de
	ld	a, $14
	call	_RowAddress
	pop	de
	ld	hl, _render_box_text
	ld	[hl], c
	inc	hl
	ld	[hl], b
;src/editor/editor.c:1090: render_box_w = widest + BOX_PADDING;
	ld	a, d
	add	a, $09
	ld	hl, _render_box_w
	ld	[hl], a
;src/editor/editor.c:1091: render_box_x = (TB_WIDTH - render_box_w) >> 1;
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
;src/editor/editor.c:1092: render_box_rows = lines + 2; // half rows above and below
	ld	a, e
	add	a, $02
	ld	hl, _render_box_rows
	ld	[hl], a
;src/editor/editor.c:1093: render_box_top = (TB_ROWS - render_box_rows) >> 1;
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
;src/editor/editor.c:1094: render_box_sel = 0xFF;
	ld	hl, _render_box_sel
	ld	[hl], $FF
;src/editor/editor.c:1095: ++render_box_gen;
	ld	hl, _render_box_gen
	inc	[hl]
.l00107:
;src/editor/editor.c:1096: }
	ret
;src/editor/editor.c:1099: static void ShowBusy(const char* text) {
;	---------------------------------
	SECTION FRAGMENT "Page 4",ROMX,BANK[2]
	LOAD FRAGMENT "Page 4 RAM",SRAM,BANK[4]
; Function ShowBusy
; ---------------------------------
_ShowBusy:
	ld	c, e
	ld	b, d
;src/editor/editor.c:1100: CopyName(RowAddress(BOX_LINE), text);
	push	bc
	ld	a, $14
	call	_RowAddress__far
	ld	e, c
	ld	d, b
	pop	bc
	call	_CopyName
;src/editor/editor.c:1101: OpenBox(1);
	ld	a, $01
	call	_OpenBox__far
;src/editor/editor.c:1102: EditorDraw();
	jp	_EditorDraw
.l00101:
;src/editor/editor.c:1103: }
	ret
;src/editor/editor.c:1105: static void HideBox(void) {
;	---------------------------------
	SECTION FRAGMENT "Page 6",ROMX,BANK[3]
	LOAD FRAGMENT "Page 6 RAM",SRAM,BANK[6]
; Function HideBox
; ---------------------------------
_HideBox:
;src/editor/editor.c:1106: render_box_top = 0xFF;
	ld	hl, _render_box_top
	ld	[hl], $FF
.l00101:
;src/editor/editor.c:1107: }
	ret
;src/editor/editor.c:1111: static unsigned char Choose(const char* title, const char* items, unsigned char count, unsigned char selected) {
;	---------------------------------
	SECTION FRAGMENT "Page 4",ROMX,BANK[2]
	LOAD FRAGMENT "Page 4 RAM",SRAM,BANK[4]
; Function Choose
; ---------------------------------
_Choose:
	add	sp, -6
	ld	hl, sp+1
	ld	[hl], c
	inc	hl
	ld	[hl], b
;src/editor/editor.c:1112: char* line = RowAddress(BOX_LINE);
	push	de
	ld	a, $14
	call	_RowAddress__far
	pop	de
	ld	hl, sp+4
	ld	[hl], c
	inc	hl
	ld	[hl], b
;src/editor/editor.c:1113: unsigned char i, key, first = title ? 1 : 0;
	ld	a, d
	or	a, e
	jp	Z, .l00134
	ld	bc, $0001
	jp	.l00135
.l00134:
	ld	bc, $0000
.l00135:
	ld	hl, sp+0
	ld	[hl], c
;src/editor/editor.c:1114: if (title) CopyName(line, title), line += BOX_STRIDE;
	ld	a, d
	or	a, e
	jp	Z, .l00143
	ld	c, e
	ld	b, d
	ld	hl, sp+4
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_CopyName
	ld	hl, sp+5
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $0014
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+6
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+5
	ld	[hl], a
;src/editor/editor.c:1115: for (i = 0; i < count; ++i, line += BOX_STRIDE, items += ITEM_SIZE) {
.l00143:
	ld	hl, sp+3
	ld	[hl], $00
	inc	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, sp+1
	ld	a, [hl]
	ld	hl, sp+4
	ld	[hl], a
	dec	hl
	dec	hl
	ld	a, [hl]
	ld	hl, sp+5
	ld	[hl], a
.l00130:
	ld	hl, sp+3
	ld	a, [hl]
	ld	hl, sp+8
	sub	a, [hl]
	jp	NC, .l00103
;src/editor/editor.c:1116: line[0] = ' ';
	ld	a, $20
	ld	[de], a
;src/editor/editor.c:1117: CopyName(line + 1, items);
	ld	l, e
;	spillPairReg hl
;	spillPairReg hl
	ld	h, d
;	spillPairReg hl
;	spillPairReg hl
	inc	hl
	push	de
	push	hl
	ld	hl, sp+8
	ld	c, [hl]
	pop	hl
	push	hl
	ld	hl, sp+9
	ld	b, [hl]
	pop	hl
	ld	e, l
	ld	d, h
	call	_CopyName
	pop	de
;src/editor/editor.c:1115: for (i = 0; i < count; ++i, line += BOX_STRIDE, items += ITEM_SIZE) {
	ld	hl, sp+3
	inc	[hl]
	ld	hl, $0014
	add	hl, de
	ld	e, l
	ld	d, h
	push	de
	ld	hl, sp+7
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $000E
	add	hl, de
	pop	de
	push	hl
	ld	a, l
	ld	hl, sp+6
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+5
	ld	[hl], a
	jp	.l00130
.l00103:
;src/editor/editor.c:1119: EditorShowCursor(0);
	xor	a, a
	call	_EditorShowCursor
;src/editor/editor.c:1120: if (osk_shown) OSKShow(0);
	ld	hl, _osk_shown
	ld	a, [hl]
	or	a, a
	jp	Z, .l00105
	xor	a, a
	call	_OSKShow
.l00105:
;src/editor/editor.c:1121: OpenBox(count + first);
	ld	hl, sp+8
	ld	a, [hl]
	ld	hl, sp+0
	add	a, [hl]
	ld	c, a
	ld	a, c
	call	_OpenBox__far
;src/editor/editor.c:1122: while (1) {
.l00125:
;src/editor/editor.c:1123: render_box_sel = selected + first + 1;
	ld	hl, sp+9
	ld	a, [hl]
	ld	hl, sp+0
	add	a, [hl]
	inc	a
	ld	hl, _render_box_sel
	ld	[hl], a
;src/editor/editor.c:1124: EditorDraw();
	call	_EditorDraw
;src/editor/editor.c:1125: while (!(key = MenuKey()));
.l00106:
	call	_MenuKey__far
	ld	hl, sp+5
	ld	[hl], a
	or	a, a
	jp	Z, .l00106
;src/editor/editor.c:1126: if (key == KEY_UP) selected = selected ? selected - 1 : count - 1;
	ld	hl, sp+9
	ld	e, [hl]
	ld	hl, sp+5
	ld	a, [hl]
	sub	a, $82
	jp	NZ,.l00221
	jp	.l00222
.l00221:
	jp	.l00122
.l00222:
	ld	hl, sp+9
	ld	a, [hl]
	or	a, a
	jp	Z, .l00136
	dec	e
	jp	.l00137
.l00136:
	ld	hl, sp+8
	ld	e, [hl]
	dec	e
.l00137:
	ld	hl, sp+9
	ld	[hl], e
	jp	.l00125
.l00122:
;src/editor/editor.c:1127: else if (key == KEY_DOWN) selected = selected == count - 1 ? 0 : selected + 1;
	ld	hl, sp+5
	ld	a, [hl]
	sub	a, $83
	jp	NZ,.l00223
	jp	.l00224
.l00223:
	jp	.l00119
.l00224:
	ld	hl, sp+8
	ld	c, [hl]
	ld	b, $00
	dec	bc
	inc	hl
	ld	a, [hl]
	ld	hl, sp+4
	ld	[hl], a
	inc	hl
	ld	[hl], $00
	dec	hl
	ld	a, [hl]
	sub	a, c
	jp	NZ,.l00225
	inc	hl
	ld	a, [hl]
	sub	a, b
	jp	NZ,.l00225
	jp	.l00226
.l00225:
	jp	.l00138
.l00226:
	ld	e, $00
	xor	a, a
	jp	.l00139
.l00138:
	inc	e
	ld	a, e
	rlca
	sbc	a, a
.l00139:
	ld	hl, sp+9
	ld	[hl], e
	jp	.l00125
.l00119:
;src/editor/editor.c:1128: else if (key == KEY_ENTER) break;
	ld	hl, sp+5
	ld	a, [hl]
	sub	a, $0A
	jp	NZ,.l00227
	jp	.l00126
.l00227:
;src/editor/editor.c:1129: else if (key == KEY_ESCAPE || key == KEY_MENU) {
	ld	hl, sp+5
	ld	a, [hl]
	sub	a, $1B
	jp	NZ,.l00228
	jp	.l00111
.l00228:
	ld	hl, sp+5
	ld	a, [hl]
	sub	a, $89
	jp	NZ,.l00229
	jp	.l00230
.l00229:
	jp	.l00112
.l00230:
.l00111:
;src/editor/editor.c:1130: selected = CANCEL;
	ld	hl, sp+9
	ld	[hl], $FF
;src/editor/editor.c:1131: break;
	jp	.l00126
.l00112:
;src/editor/editor.c:1133: else if (key == KEY_BACKSPACE) {
	ld	hl, sp+5
	ld	a, [hl]
	sub	a, $08
	jp	NZ,.l00231
	jp	.l00232
.l00231:
	jp	.l00125
.l00232:
;src/editor/editor.c:1134: selected = BACK;
	ld	hl, sp+9
	ld	[hl], $FE
;src/editor/editor.c:1135: break;
.l00126:
;src/editor/editor.c:1138: HideBox();
	call	_HideBox__far
;src/editor/editor.c:1139: if (osk_shown) OSKShow(1);
	ld	hl, _osk_shown
	ld	a, [hl]
	or	a, a
	jp	Z, .l00128
	ld	a, $01
	call	_OSKShow
.l00128:
;src/editor/editor.c:1140: dirty = 1;
	ld	hl, _dirty
	ld	[hl], $01
;src/editor/editor.c:1141: return selected;
	ld	hl, sp+9
	ld	a, [hl]
.l00132:
;src/editor/editor.c:1142: }
	add	sp, 6
	pop	hl
	inc	sp
	inc	sp
	jp hl
;src/editor/editor.c:1145: static void ShowMessage(const char* text) {
;	---------------------------------
	SECTION FRAGMENT "Page 6",ROMX,BANK[3]
	LOAD FRAGMENT "Page 6 RAM",SRAM,BANK[6]
; Function ShowMessage
; ---------------------------------
_ShowMessage:
;src/editor/editor.c:1146: HideBox();
	push	de
	call	_HideBox
	pop	de
;src/editor/editor.c:1147: Render();
	push	de
	call	_Render__far
	pop	de
;src/editor/editor.c:1148: EditorShowCursor(0);
	push	de
	xor	a, a
	call	_EditorShowCursor
	pop	de
;src/editor/editor.c:1149: NoHighlight();
	push	de
	call	_NoHighlight__far
	pop	de
;src/editor/editor.c:1150: if (bars) {
	ld	hl, _bars
	ld	a, [hl]
	or	a, a
	jp	Z, .l00102
;src/editor/editor.c:1151: UpdateBars();
	push	de
	call	_UpdateBars__far
	pop	de
;src/editor/editor.c:1152: DrawRow(STATUS_LINE, 1, text);
	push	de
	ld	e, $01
	ld	a, $13
	call	_DrawRow
	jp	.l00103
.l00102:
;src/editor/editor.c:1154: else DrawRow(tb_rows - 1, 0, text);
	ld	hl, _tb_rows
	ld	c, [hl]
	dec	c
	push	de
	ld	e, $00
	ld	a, c
	call	_DrawRow
.l00103:
;src/editor/editor.c:1155: EditorDraw();
	call	_EditorDraw
;src/editor/editor.c:1156: WaitDismiss();
	call	_WaitDismiss
;src/editor/editor.c:1157: dirty = 1;
	ld	hl, _dirty
	ld	[hl], $01
.l00104:
;src/editor/editor.c:1158: }
	ret
;src/editor/editor.c:1160: static void ShowError(unsigned char result, const char* denied) {
;	---------------------------------
	SECTION FRAGMENT "Page 4",ROMX,BANK[2]
	LOAD FRAGMENT "Page 4 RAM",SRAM,BANK[4]
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
;src/editor/editor.c:1161: char text[12] = "SD ERROR ";
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
;src/editor/editor.c:1162: if (result == FR_NOT_READY) ShowMessage("NO SD CARD");
	ld	hl, sp+16
	ld	a, [hl]
	sub	a, $03
	jp	NZ,.l00140
	jp	.l00141
.l00140:
	jp	.l00111
.l00141:
	ld	de, ___src_editor_editor_c_str_51
	call	_ShowMessage__far
	jp	.l00113
.l00111:
;src/editor/editor.c:1163: else if (result == FR_NO_FILESYSTEM) ShowMessage("NO FAT VOLUME");
	ld	hl, sp+16
	ld	a, [hl]
	sub	a, $0D
	jp	NZ,.l00142
	jp	.l00143
.l00142:
	jp	.l00108
.l00143:
	ld	de, ___src_editor_editor_c_str_52
	call	_ShowMessage__far
	jp	.l00113
.l00108:
;src/editor/editor.c:1164: else if (result == FR_DENIED) ShowMessage(denied);
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
	call	_ShowMessage__far
	jp	.l00113
.l00105:
;src/editor/editor.c:1166: text[9] = '0';
	ld	hl, sp+9
	ld	[hl], $30
;src/editor/editor.c:1167: while (result >= 10) {
.l00101:
;src/editor/editor.c:1169: result -= 10;
	ld	hl, sp+16
	ld	a, [hl]
	ld	hl, sp+12
	ld	[hl], a
;src/editor/editor.c:1167: while (result >= 10) {
	ld	hl, sp+16
	ld	a, [hl]
	sub	a, $0A
	jp	C, .l00103
;src/editor/editor.c:1168: ++text[9];
	ld	hl, sp+9
	ld	a, [hl]
	ld	hl, sp+13
	ld	[hl], a
	ld	a, [hl]
	inc	a
	ld	hl, sp+9
	ld	[hl], a
;src/editor/editor.c:1169: result -= 10;
	ld	hl, sp+12
	ld	a, [hl]
	add	a, $F6
	ld	hl, sp+16
	ld	[hl], a
	jp	.l00101
.l00103:
;src/editor/editor.c:1171: text[10] = '0' + result;
	ld	hl, sp+12
	ld	a, [hl]
	add	a, $30
	dec	hl
	dec	hl
	ld	[hl], a
;src/editor/editor.c:1172: text[11] = 0;
	inc	hl
	ld	[hl], $00
;src/editor/editor.c:1173: ShowMessage(text);
	ld	hl, 0
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_ShowMessage__far
.l00113:
;src/editor/editor.c:1175: }
	add	sp, 17
	ret
	SECTION FRAGMENT "src/editor/editor.c FIXED",ROMX,BANK[1]
___src_editor_editor_c_str_51:
	DB "NO SD CARD"
	DB $00
	SECTION FRAGMENT "src/editor/editor.c FIXED",ROMX,BANK[1]
___src_editor_editor_c_str_52:
	DB "NO FAT VOLUME"
	DB $00
;src/editor/editor.c:1177: static void CopyName(char* dest, const char* src) {
;	---------------------------------
	SECTION FRAGMENT "Page 4",ROMX,BANK[2]
	LOAD FRAGMENT "Page 4 RAM",SRAM,BANK[4]
; Function CopyName
; ---------------------------------
_CopyName:
;src/editor/editor.c:1178: while ((*dest++ = *src++));
.l00101:
	ld	a, [bc]
	inc	bc
	ld	[de], a
	inc	de
	or	a, a
	jp	NZ, .l00101
.l00104:
;src/editor/editor.c:1179: }
	ret
;src/editor/editor.c:1182: static unsigned char CanDiscard(void) {
;	---------------------------------
	SECTION FRAGMENT "Page 4",ROMX,BANK[2]
	LOAD FRAGMENT "Page 4 RAM",SRAM,BANK[4]
; Function CanDiscard
; ---------------------------------
_CanDiscard:
;src/editor/editor.c:1183: return !modified || Choose("DISCARD CHANGES?", discard_items[0], 2, 0) == 1;
	ld	hl, _modified
	ld	a, [hl]
	or	a, a
	jp	Z, .l00104
	xor	a, a
	push	af
	inc	sp
	ld	a, $02
	push	af
	inc	sp
	ld	bc, _discard_items
	ld	de, ___src_editor_editor_c_str_53
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
;src/editor/editor.c:1184: }
	ret
	SECTION FRAGMENT "src/editor/editor.c FIXED",ROMX,BANK[1]
___src_editor_editor_c_str_53:
	DB "DISCARD CHANGES?"
	DB $00
;src/editor/editor.c:1191: static void SetLang(void) {
;	---------------------------------
	SECTION FRAGMENT "Page 6",ROMX,BANK[3]
	LOAD FRAGMENT "Page 6 RAM",SRAM,BANK[6]
; Function SetLang
; ---------------------------------
_SetLang:
	add	sp, -10
;src/editor/editor.c:1192: const char *c, *dot = 0, *e;
	xor	a, a
	ld	hl, sp+6
	ld	[hl], a
	inc	hl
	ld	[hl], a
;src/editor/editor.c:1193: unsigned char lang = LANG_PLAIN, i;
	ld	hl, sp+0
	ld	[hl], $00
;src/editor/editor.c:1194: for (c = file_name; *c; ++c) if (*c == '.') dot = c;
	ld	hl, sp+8
	ld	a, LOW(_file_name)
	ld	[hl], a
	inc	hl
	ld	a, HIGH(_file_name)
	ld	[hl], a
.l00116:
	ld	hl, sp+9
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	or	a, a
	jp	Z, .l00103
	sub	a, $2E
	jp	NZ,.l00222
	jp	.l00223
.l00222:
	jp	.l00117
.l00223:
	dec	hl
	ld	a, [hl]
	dec	hl
	dec	hl
	ld	[hl], a
	ld	hl, sp+9
	ld	a, [hl]
	dec	hl
	dec	hl
	ld	[hl], a
.l00117:
	ld	hl, sp+8
	inc	[hl]
	jp	NZ, .l00224
	inc	hl
	inc	[hl]
.l00224:
	jp	.l00116
.l00103:
;src/editor/editor.c:1195: if (dot) for (i = 0; i < sizeof(lang_ids); ++i) {
	ld	hl, sp+7
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	jp	Z, .l00110
	inc	hl
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $0001
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
	ld	[hl], $00
.l00122:
;src/editor/editor.c:1196: for (c = dot + 1, e = lang_exts[i]; *e && (*c | 0x20) == *e; ++c, ++e);
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
.l00120:
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
	jp	NZ,.l00226
	jp	.l00227
.l00226:
	jp	.l00104
.l00227:
	ld	hl, sp+6
	inc	[hl]
	jp	NZ, .l00228
	inc	hl
	inc	[hl]
.l00228:
	ld	hl, sp+8
	inc	[hl]
	jp	NZ, .l00229
	inc	hl
	inc	[hl]
.l00229:
	jp	.l00120
.l00104:
;src/editor/editor.c:1197: if (!*c && !*e) lang = lang_ids[i];
	ld	hl, sp+4
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00123
	dec	hl
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00123
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
.l00123:
;src/editor/editor.c:1195: if (dot) for (i = 0; i < sizeof(lang_ids); ++i) {
	ld	hl, sp+5
	inc	[hl]
	ld	a, [hl]
	sub	a, $06
	jp	C, .l00122
.l00110:
;src/editor/editor.c:1199: font = lang == LANG_C || lang == LANG_ASM ? FONT_FIXED : FONT_VWF;
	ld	hl, sp+0
	ld	a, [hl]
	sub	a, $02
	jp	NZ,.l00230
	jp	.l00134
.l00230:
	ld	hl, sp+0
	ld	a, [hl]
	sub	a, $03
	jp	NZ,.l00231
	jp	.l00232
.l00231:
	jp	.l00131
.l00232:
.l00134:
	ld	bc, $0002
	jp	.l00132
.l00131:
	ld	bc, $0001
.l00132:
	ld	hl, _font
	ld	[hl], c
;src/editor/editor.c:1200: if (lang == tb_lang) return;
	ld	hl, _tb_lang
	ld	a, [hl]
	ld	hl, sp+0
	sub	a, [hl]
	jp	NZ,.l00233
	jp	.l00234
.l00233:
	jp	.l00112
.l00234:
	jp	.l00129
.l00112:
;src/editor/editor.c:1201: tb_lang = lang;
	ld	hl, sp+0
	ld	a, [hl]
	ld	hl, _tb_lang
	ld	[hl], a
;src/editor/editor.c:1202: tb_ResetChecks();
	call	_tb_ResetChecks
;src/editor/editor.c:1203: for (i = 0; i <= TB_ROWS; ++i) tb_row_states[i] = 0; // no markdown headings left in them
	ld	bc, _tb_row_states+0
	ld	e, $00
.l00124:
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
	jp	NC, .l00124
;src/editor/editor.c:1204: SetFont(font);
	ld	hl, _font
	ld	a, [hl]
	call	_SetFont
;src/editor/editor.c:1205: for (i = bars; i < bars + tb_rows; ++i) render_row_fonts[i] = font;
	ld	hl, _bars
	ld	c, [hl]
.l00127:
	ld	hl, _bars
	ld	a, [hl]
	ld	b, $00
	ld	hl, _tb_rows
	ld	e, [hl]
	ld	d, $00
	ld	l, a
;	spillPairReg hl
;	spillPairReg hl
	ld	h, b
;	spillPairReg hl
;	spillPairReg hl
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+8
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+7
	ld	[hl], a
	inc	hl
	ld	[hl], c
	inc	hl
	ld	[hl], $00
	ld	hl, sp+8
	ld	e, l
	ld	d, h
	ld	hl, sp+6
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
	jp	Z, .l00235
	bit	7, d
	jp	NZ, .l00236
	cp	a, a
	jp	.l00236
.l00235:
	bit	7, d
	jp	Z, .l00236
	scf
.l00236:
	jp	NC, .l00114
	ld	a, LOW(_render_row_fonts)
	add	a, c
	ld	e, a
	ld	a, HIGH(_render_row_fonts)
	adc	a, $00
	ld	d, a
	ld	hl, _font
	ld	a, [hl]
	ld	[de], a
	inc	c
	jp	.l00127
.l00114:
;src/editor/editor.c:1206: EditorRedraw();
	call	_EditorRedraw
;src/editor/editor.c:1207: dirty = 1;
	ld	hl, _dirty
	ld	[hl], $01
.l00129:
;src/editor/editor.c:1208: }
	add	sp, 10
	ret
	SECTION FRAGMENT "src/editor/editor.c FIXED",ROMX,BANK[1]
_lang_exts:
	DW __str_54
	DW __str_55
	DW __str_56
	DW __str_57
	DW __str_58
	DW __str_59
	SECTION FRAGMENT "src/editor/editor.c FIXED",ROMX,BANK[1]
_lang_ids:
	DB $01	; 1
	DB $02	; 2
	DB $02	; 2
	DB $03	; 3
	DB $03	; 3
	DB $03	; 3
	SECTION FRAGMENT "src/editor/editor.c FIXED",ROMX,BANK[1]
__str_54:
	DB "md"
	DB $00
	SECTION FRAGMENT "src/editor/editor.c FIXED",ROMX,BANK[1]
__str_55:
	DB "c"
	DB $00
	SECTION FRAGMENT "src/editor/editor.c FIXED",ROMX,BANK[1]
__str_56:
	DB "h"
	DB $00
	SECTION FRAGMENT "src/editor/editor.c FIXED",ROMX,BANK[1]
__str_57:
	DB "asm"
	DB $00
	SECTION FRAGMENT "src/editor/editor.c FIXED",ROMX,BANK[1]
__str_58:
	DB "inc"
	DB $00
	SECTION FRAGMENT "src/editor/editor.c FIXED",ROMX,BANK[1]
__str_59:
	DB "s"
	DB $00
;src/editor/editor.c:1210: static void ResetCursor(void) {
;	---------------------------------
	SECTION FRAGMENT "Page 5",ROMX,BANK[2]
	LOAD FRAGMENT "Page 5 RAM",SRAM,BANK[5]
; Function ResetCursor
; ---------------------------------
_ResetCursor:
;src/editor/editor.c:1211: SetLang();
	call	_SetLang__far
;src/editor/editor.c:1212: cursor = 0;
	xor	a, a
	ld	hl, _cursor
	ld	[hl], a
	inc	hl
	ld	[hl], a
;src/editor/editor.c:1213: counted_pos = 0;
	xor	a, a
	ld	hl, _counted_pos
	ld	[hl], a
	inc	hl
	ld	[hl], a
;src/editor/editor.c:1214: counted_lines = 0;
	xor	a, a
	ld	hl, _counted_lines
	ld	[hl], a
	inc	hl
	ld	[hl], a
;src/editor/editor.c:1215: selecting = 0;
	ld	hl, _selecting
	ld	[hl], $00
;src/editor/editor.c:1216: top = 0;
	xor	a, a
	ld	hl, _top
	ld	[hl], a
	inc	hl
	ld	[hl], a
;src/editor/editor.c:1217: tb_left = 0;
	xor	a, a
	ld	hl, _tb_left
	ld	[hl], a
	inc	hl
	ld	[hl], a
;src/editor/editor.c:1218: want_x = 0;
	ld	hl, _want_x
	ld	[hl], $00
;src/editor/editor.c:1219: modified = 0;
	ld	hl, _modified
	ld	[hl], $00
;src/editor/editor.c:1220: dirty = 1;
	ld	hl, _dirty
	ld	[hl], $01
;src/editor/editor.c:1221: UndoClear(0);
	xor	a, a
	jp	_UndoClear
.l00101:
;src/editor/editor.c:1222: }
	ret
;src/editor/editor.c:1224: static void NewFile(void) {
;	---------------------------------
	SECTION FRAGMENT "Page 4",ROMX,BANK[2]
	LOAD FRAGMENT "Page 4 RAM",SRAM,BANK[4]
; Function NewFile
; ---------------------------------
_NewFile:
;src/editor/editor.c:1225: if (!CanDiscard()) return;
	call	_CanDiscard
	or	a, a
	jp	NZ, .l00102
	jp	.l00103
.l00102:
;src/editor/editor.c:1226: FileCloseLarge();
	call	_FileCloseLarge
;src/editor/editor.c:1227: tb_Clear();
	call	_tb_Clear
;src/editor/editor.c:1228: file_name[0] = 0;
	ld	hl, _file_name
	ld	[hl], $00
;src/editor/editor.c:1229: fs_crlf = 0;
	ld	hl, _fs_crlf
	ld	[hl], $00
;src/editor/editor.c:1230: ResetCursor();
	call	_ResetCursor__far
;src/editor/editor.c:1231: SettingsSave();
	jp	_SettingsSave
.l00103:
;src/editor/editor.c:1232: }
	ret
;src/editor/editor.c:1236: static unsigned int ListFolder(const char* path, const char* find) {
;	---------------------------------
	SECTION FRAGMENT "Page 4",ROMX,BANK[2]
	LOAD FRAGMENT "Page 4 RAM",SRAM,BANK[4]
; Function ListFolder
; ---------------------------------
_ListFolder:
	add	sp, -3
	ld	hl, sp+1
	ld	[hl], c
	inc	hl
	ld	[hl], b
;src/editor/editor.c:1237: unsigned char up = path[0] != 0;
	ld	a, [de]
	sub	a,$01
	ld	a, $00
	rla
	xor	a, $01
	dec	hl
	dec	hl
	ld	[hl], a
;src/editor/editor.c:1238: list_count = 0;
	xor	a, a
	ld	hl, _list_count
	ld	[hl], a
	inc	hl
	ld	[hl], a
;src/editor/editor.c:1239: if ((list_result = FileList(path, find))) return 0;
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
;src/editor/editor.c:1240: list_count = fs_count + up;
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
;src/editor/editor.c:1241: return find && fs_found != 0xFFFF ? fs_found + up : 0;
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
;src/editor/editor.c:1242: }
	add	sp, 3
	ret
;src/editor/editor.c:1245: static unsigned char ListEntry(const char* path, unsigned int index) {
;	---------------------------------
	SECTION FRAGMENT "Page 4",ROMX,BANK[2]
	LOAD FRAGMENT "Page 4 RAM",SRAM,BANK[4]
; Function ListEntry
; ---------------------------------
_ListEntry:
	dec	sp
	dec	sp
	inc	sp
	inc	sp
	push	bc
;src/editor/editor.c:1246: if (path[0] && !index--) {
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
;src/editor/editor.c:1247: entry.name[0] = '.';
	ld	hl, _entry
	ld	[hl], $2E
;src/editor/editor.c:1248: entry.name[1] = '.';
	ld	hl, (_entry + 1)
	ld	[hl], $2E
;src/editor/editor.c:1249: entry.name[2] = 0;
	ld	hl, (_entry + 2)
	ld	[hl], $00
;src/editor/editor.c:1250: return KIND_UP;
	xor	a, a
	jp	.l00106
.l00102:
;src/editor/editor.c:1252: if ((list_result = FileListEntry(index, &entry))) return 0xFF;
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
;src/editor/editor.c:1253: return entry.dir ? KIND_FOLDER : KIND_FILE;
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
;src/editor/editor.c:1254: }
	inc	sp
	inc	sp
	ret
;src/editor/editor.c:1257: static void ListRows(const char* path, unsigned int first, unsigned char row, unsigned char end) {
;	---------------------------------
	SECTION FRAGMENT "Page 4",ROMX,BANK[2]
	LOAD FRAGMENT "Page 4 RAM",SRAM,BANK[4]
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
;src/editor/editor.c:1260: for (; row < end; ++row) {
	ld	hl, sp+11
	ld	a, [hl]
	ld	hl, sp+15
	sub	a, [hl]
	jp	NC, .l00111
;src/editor/editor.c:1261: DrawRow(row, 0, "");
	ld	de, ___src_editor_editor_c_str_60
	push	de
	ld	e, $00
	ld	hl, sp+13
	ld	a, [hl]
	call	_DrawRow__far
;src/editor/editor.c:1262: if (first + row >= list_count) continue;
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
;src/editor/editor.c:1263: if ((kind = ListEntry(path, first + row)) == 0xFF) return;
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
;src/editor/editor.c:1264: list_kinds[row] = kind;
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
;src/editor/editor.c:1265: list_sizes[row] = entry.size;
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
;src/editor/editor.c:1266: list_dates[row] = entry.date;
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
;src/editor/editor.c:1267: list_times[row] = entry.time;
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
;src/editor/editor.c:1268: dest = ToLatin1(RowAddress(row) + 1, entry.name, TB_STRIDE - 3);
	ld	hl, sp+11
	ld	a, [hl]
	call	_RowAddress__far
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
;src/editor/editor.c:1269: if (kind == KIND_FOLDER) *dest = '/';
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
;src/editor/editor.c:1260: for (; row < end; ++row) {
	ld	hl, sp+11
	inc	[hl]
	jp	.l00110
.l00111:
;src/editor/editor.c:1271: }
	add	sp, 12
	pop	hl
	inc	sp
	inc	sp
	jp hl
	SECTION FRAGMENT "src/editor/editor.c FIXED",ROMX,BANK[1]
___src_editor_editor_c_str_60:
	DB $00
;src/editor/editor.c:1274: static void ScrollList(const char* path, unsigned int first, unsigned char down) {
;	---------------------------------
	SECTION FRAGMENT "Page 4",ROMX,BANK[2]
	LOAD FRAGMENT "Page 4 RAM",SRAM,BANK[4]
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
;src/editor/editor.c:1276: ScrollRing(down);
	ld	hl, sp+15
	ld	a, [hl]
	call	_ScrollRing__far
;src/editor/editor.c:1277: tb_ScrollRows(down);
	ld	hl, sp+15
	ld	a, [hl]
	call	_tb_ScrollRows
;src/editor/editor.c:1278: for (i = 1; i < LIST_ROWS; ++i) {
	ld	hl, sp+12
	ld	[hl], $01
.l00102:
;src/editor/editor.c:1279: to = down ? i - 1 : LIST_ROWS - i;
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
;src/editor/editor.c:1280: from = down ? i : to - 1;
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
;src/editor/editor.c:1281: list_kinds[to] = list_kinds[from];
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
;src/editor/editor.c:1282: list_sizes[to] = list_sizes[from];
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
;src/editor/editor.c:1283: list_dates[to] = list_dates[from];
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
;src/editor/editor.c:1284: list_times[to] = list_times[from];
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
;src/editor/editor.c:1278: for (i = 1; i < LIST_ROWS; ++i) {
	ld	hl, sp+12
	inc	[hl]
	ld	a, [hl]
	sub	a, $10
	jp	C, .l00102
;src/editor/editor.c:1286: i = down ? LIST_ROWS - 1 : 0;
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
;src/editor/editor.c:1287: ListRows(path, first, i, i + 1);
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
;src/editor/editor.c:1288: }
	add	sp, 13
	pop	hl
	inc	sp
	jp hl
;src/editor/editor.c:1291: static void ListBars(const char* path, unsigned char row, unsigned int count) {
;	---------------------------------
	SECTION FRAGMENT "Page 4",ROMX,BANK[2]
	LOAD FRAGMENT "Page 4 RAM",SRAM,BANK[4]
; Function ListBars
; ---------------------------------
_ListBars:
	add	sp, -51
	ld	hl, sp+49
	ld	[hl], e
	inc	hl
	ld	[hl], d
	dec	hl
	dec	hl
	ld	[hl], a
;src/editor/editor.c:1293: char* end = text;
;src/editor/editor.c:1294: unsigned long size = list_sizes[row];
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
	ld	hl, sp+48
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+47
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
;src/editor/editor.c:1295: unsigned char* bytes = (unsigned char*)&size;
;src/editor/editor.c:1296: unsigned int date = list_dates[row], time = list_times[row];
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
;src/editor/editor.c:1297: PutPath(text, path, 30);
	ld	a, $1E
	push	af
	inc	sp
	ld	hl, sp+50
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	ld	hl, 1
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_PutPath
;src/editor/editor.c:1298: DrawRow(HEADER_LINE, 1, text);
	ld	hl, 0
	add	hl, sp
	push	hl
	ld	e, $01
	ld	a, $12
	call	_DrawRow__far
;src/editor/editor.c:1299: if (!count) end = PutText(end, "Empty folder");
	ld	hl, sp+54
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	jp	NZ, .l00114
	ld	bc, ___src_editor_editor_c_str_61
	ld	hl, 0
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_PutText__far
	ld	hl, sp+46
	ld	[hl], c
	inc	hl
	ld	[hl], b
	jp	.l00115
.l00114:
;src/editor/editor.c:1300: else if (list_kinds[row] == KIND_UP) end = PutText(end, "Parent folder");
	ld	de, _list_kinds
	ld	hl, sp+48
	ld	l, [hl]
	ld	h, $00
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, [bc]
	or	a, a
	jp	NZ, .l00111
	ld	bc, ___src_editor_editor_c_str_62
	ld	hl, 0
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_PutText__far
	ld	hl, sp+46
	ld	[hl], c
	inc	hl
	ld	[hl], b
	jp	.l00115
.l00111:
;src/editor/editor.c:1301: else if (list_kinds[row] == KIND_FOLDER) end = PutText(end, "Folder");
	dec	a
	jp	NZ,.l00145
	jp	.l00146
.l00145:
	jp	.l00108
.l00146:
	ld	bc, ___src_editor_editor_c_str_63
	ld	hl, 0
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_PutText__far
	ld	hl, sp+46
	ld	[hl], c
	inc	hl
	ld	[hl], b
	jp	.l00115
.l00108:
;src/editor/editor.c:1303: if (size < 10000) end = PutText(PutNumber(end, (unsigned int)size), " bytes  ");
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
	ld	de, $0000
	push	de
	push	bc
	ld	hl, 4
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_PutNumber
	ld	e, c
	ld	d, b
	ld	bc, ___src_editor_editor_c_str_64
	call	_PutText__far
	jp	.l00106
.l00105:
;src/editor/editor.c:1304: else if (size < 10485760) end = PutText(PutNumber(end, (bytes[1] >> 2) | (bytes[2] << 6)), " KB  ");
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
	ld	c, a
	ld	b, $00
	ld	a, c
	or	a, l
	ld	c, a
	ld	a, b
	or	a, h
	ld	b, a
	ld	a, b
	rlca
	sbc	a, a
	ld	d, a
	ld	e, a
	push	de
	push	bc
	ld	hl, 4
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_PutNumber
	ld	e, c
	ld	d, b
	ld	bc, ___src_editor_editor_c_str_65
	call	_PutText__far
	jp	.l00106
.l00102:
;src/editor/editor.c:1305: else end = PutText(PutNumber(end, (bytes[2] >> 4) | (bytes[3] << 4)), " MB  ");
	srl	c
	srl	c
	srl	c
	srl	c
	ld	hl, sp+43
	ld	l, [hl]
;	spillPairReg hl
;	spillPairReg hl
	ld	h, $00
;	spillPairReg hl
;	spillPairReg hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	ld	b, $00
	ld	a, c
	or	a, l
	ld	c, a
	ld	a, b
	or	a, h
	ld	b, a
	ld	a, b
	rlca
	sbc	a, a
	ld	d, a
	ld	e, a
	push	de
	push	bc
	ld	hl, 4
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_PutNumber
	ld	e, c
	ld	d, b
	ld	bc, ___src_editor_editor_c_str_66
	call	_PutText__far
.l00106:
;src/editor/editor.c:1306: end = PutNumber(end, (date >> 9) + 1980);
	ld	hl, sp+45
	ld	a, [hl]
	srl	a
	ld	e, a
	ld	d, $00
	ld	hl, $07BC
	add	hl, de
	ld	e, l
	ld	d, h
	ld	hl, $0000
	push	hl
	push	de
	ld	e, c
	ld	d, b
	call	_PutNumber
;src/editor/editor.c:1307: *end++ = '-';
	ld	a, $2D
	ld	[bc], a
	ld	e, c
	ld	d, b
	inc	de
;src/editor/editor.c:1308: end = PutNumber2(end, (date >> 5) & 15);
	ld	hl, sp+45
	dec	hl
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	ld	a, $05
.l00147:
	srl	b
	rr	c
	dec	a
	jp	NZ, .l00147
	ld	a, c
	and	a, $0F
	ld	c, a
	ld	b, $00
	call	_PutNumber2
;src/editor/editor.c:1309: *end++ = '-';
	ld	a, $2D
	ld	[bc], a
	ld	e, c
	ld	d, b
	inc	de
;src/editor/editor.c:1310: end = PutNumber2(end, date & 31);
	ld	hl, sp+44
	ld	a, [hl]
	and	a, $1F
	ld	c, a
	ld	b, $00
	call	_PutNumber2
;src/editor/editor.c:1311: *end++ = ' ';
	ld	a, $20
	ld	[bc], a
	ld	e, c
	ld	d, b
	inc	de
;src/editor/editor.c:1312: end = PutNumber2(end, time >> 11);
	ld	hl, sp+47
	ld	a, [hl]
	swap	a
	rlca
	and	a, $1F
	ld	c, a
	ld	b, $00
	call	_PutNumber2
;src/editor/editor.c:1313: *end++ = ':';
	ld	a, $3A
	ld	[bc], a
	ld	e, c
	ld	d, b
	inc	de
;src/editor/editor.c:1314: end = PutNumber2(end, (time >> 5) & 63);
	ld	hl, sp+47
	dec	hl
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	ld	a, $05
.l00148:
	srl	b
	rr	c
	dec	a
	jp	NZ, .l00148
	ld	a, c
	and	a, $3F
	ld	c, a
	ld	b, $00
	call	_PutNumber2
	ld	hl, sp+46
	ld	[hl], c
	inc	hl
	ld	[hl], b
.l00115:
;src/editor/editor.c:1316: *end = 0;
	ld	hl, sp+46
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	ld	[hl], $00
;src/editor/editor.c:1317: DrawRow(STATUS_LINE, 1, text);
	ld	hl, 0
	add	hl, sp
	push	hl
	ld	e, $01
	ld	a, $13
	call	_DrawRow__far
.l00116:
;src/editor/editor.c:1318: }
	add	sp, 51
	pop	hl
	inc	sp
	inc	sp
	jp hl
	SECTION FRAGMENT "src/editor/editor.c FIXED",ROMX,BANK[1]
___src_editor_editor_c_str_61:
	DB "Empty folder"
	DB $00
	SECTION FRAGMENT "src/editor/editor.c FIXED",ROMX,BANK[1]
___src_editor_editor_c_str_62:
	DB "Parent folder"
	DB $00
	SECTION FRAGMENT "src/editor/editor.c FIXED",ROMX,BANK[1]
___src_editor_editor_c_str_63:
	DB "Folder"
	DB $00
	SECTION FRAGMENT "src/editor/editor.c FIXED",ROMX,BANK[1]
___src_editor_editor_c_str_64:
	DB " bytes  "
	DB $00
	SECTION FRAGMENT "src/editor/editor.c FIXED",ROMX,BANK[1]
___src_editor_editor_c_str_65:
	DB " KB  "
	DB $00
	SECTION FRAGMENT "src/editor/editor.c FIXED",ROMX,BANK[1]
___src_editor_editor_c_str_66:
	DB " MB  "
	DB $00
;src/editor/editor.c:1322: static void ListLoading(const char* path, unsigned char row) {
;	---------------------------------
	SECTION FRAGMENT "Page 4",ROMX,BANK[2]
	LOAD FRAGMENT "Page 4 RAM",SRAM,BANK[4]
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
;src/editor/editor.c:1324: char* end = path[0] ? ToLatin1(text, path, PATH_SIZE - 1) : text;
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
;src/editor/editor.c:1328: *end++ = '/';
	dec	hl
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	inc	bc
;src/editor/editor.c:1327: if (row != 0xFF) {
	inc	hl
	ld	a, [hl]
	inc	a
	jp	NZ,.l00147
	jp	.l00105
.l00147:
;src/editor/editor.c:1328: *end++ = '/';
	ld	hl, 168
	add	hl, sp
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	ld	[hl], $2F
;src/editor/editor.c:1329: for (name = RowAddress(row) + 1; *name != '/'; ++name) *end++ = *name;
	push	bc
	ld	hl, 172
	add	hl, sp
	ld	a, [hl]
	call	_RowAddress__far
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
;src/editor/editor.c:1331: else if (!path[0]) *end++ = '/';
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
;src/editor/editor.c:1341: ShowBusy("Loading...");
	jp	.l00106
;src/editor/editor.c:1331: else if (!path[0]) *end++ = '/';
.l00122:
	ld	hl, 168
	add	hl, sp
	ld	[hl], c
	inc	hl
	ld	[hl], b
.l00106:
;src/editor/editor.c:1332: *end = 0;
	ld	hl, 168
	add	hl, sp
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	ld	[hl], $00
;src/editor/editor.c:1333: length = (unsigned char)(end - text);
	ld	hl, sp+0
	ld	c, l
	ld	b, h
	ld	hl, 168
	add	hl, sp
	ld	a, [hl]
	ld	e, c
	sub	a, e
	ld	e, a
;src/editor/editor.c:1334: end = text;
;src/editor/editor.c:1335: if (length > 30) {
	ld	a, $1E
	sub	a, e
	jp	NC, .l00108
;src/editor/editor.c:1336: end += length - 33;
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
;src/editor/editor.c:1337: end[0] = end[1] = end[2] = '.';
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
;src/editor/editor.c:1339: DrawRow(HEADER_LINE, 1, end);
	push	bc
	ld	e, $01
	ld	a, $12
	call	_DrawRow__far
;src/editor/editor.c:1340: DrawRow(STATUS_LINE, 1, "");
	ld	de, ___src_editor_editor_c_str_67
	push	de
	ld	e, $01
	ld	a, $13
	call	_DrawRow__far
;src/editor/editor.c:1341: ShowBusy("Loading...");
	ld	de, ___src_editor_editor_c_str_68
	call	_ShowBusy
.l00112:
;src/editor/editor.c:1342: }
	add	sp, 127
	add	sp, 46
	ret
	SECTION FRAGMENT "src/editor/editor.c FIXED",ROMX,BANK[1]
___src_editor_editor_c_str_67:
	DB $00
	SECTION FRAGMENT "src/editor/editor.c FIXED",ROMX,BANK[1]
___src_editor_editor_c_str_68:
	DB "Loading..."
	DB $00
;src/editor/editor.c:1345: static void ListMessage(const char* text) {
;	---------------------------------
	SECTION FRAGMENT "Page 4",ROMX,BANK[2]
	LOAD FRAGMENT "Page 4 RAM",SRAM,BANK[4]
; Function ListMessage
; ---------------------------------
_ListMessage:
;src/editor/editor.c:1346: HideBox();
	push	de
	call	_HideBox__far
	pop	de
;src/editor/editor.c:1347: DrawRow(STATUS_LINE, 1, text);
	push	de
	ld	e, $01
	ld	a, $13
	call	_DrawRow__far
;src/editor/editor.c:1348: EditorDraw();
	call	_EditorDraw
;src/editor/editor.c:1349: WaitDismiss();
	jp	_WaitDismiss__far
.l00101:
;src/editor/editor.c:1350: }
	ret
;src/editor/editor.c:1355: static unsigned char Browse(void) {
;	---------------------------------
	SECTION FRAGMENT "Page 4",ROMX,BANK[2]
	LOAD FRAGMENT "Page 4 RAM",SRAM,BANK[4]
; Function Browse
; ---------------------------------
_Browse:
	ld	hl, -270
	add	hl, sp
	ld	sp, hl
;src/editor/editor.c:1358: unsigned int selected = 0, first = 0, drawn = LIST_ALL;
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
;src/editor/editor.c:1359: unsigned char key, result, row, opened = 0, editor_font = font, length;
	inc	hl
	ld	[hl], $00
	ld	hl, _font
	ld	a, [hl]
	ld	hl, 263
	add	hl, sp
	ld	[hl], a
;src/editor/editor.c:1360: CopyName(path, file_dir);
	ld	bc, _file_dir
	ld	hl, 0
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_CopyName
;src/editor/editor.c:1361: font = FONT_VWF;
	ld	hl, _font
	ld	[hl], $01
;src/editor/editor.c:1362: SetFont(font);
	ld	a, $01
	call	_SetFont
;src/editor/editor.c:1363: render_text = 0;
	ld	hl, _render_text
	ld	[hl], $00
;src/editor/editor.c:1364: EditorShowCursor(0);
	xor	a, a
	call	_EditorShowCursor
;src/editor/editor.c:1365: if (osk_shown) OSKShow(0);
	ld	hl, _osk_shown
	ld	a, [hl]
	or	a, a
	jp	Z, .l00102
	xor	a, a
	call	_OSKShow
.l00102:
;src/editor/editor.c:1366: bars = 1;
	ld	hl, _bars
	ld	[hl], $01
;src/editor/editor.c:1367: tb_rows = LIST_ROWS;
	ld	hl, _tb_rows
	ld	[hl], $10
;src/editor/editor.c:1368: Layout();
	call	_Layout__far
;src/editor/editor.c:1369: NoHighlight();
	call	_NoHighlight__far
;src/editor/editor.c:1370: ListLoading(path, 0xFF);
	ld	a, $FF
	ld	hl, 0
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_ListLoading
;src/editor/editor.c:1371: if ((result = FileMount())) {
	call	_FileMount
	ld	hl, 267
	add	hl, sp
	ld	[hl], a
	or	a, a
	jp	Z, .l00104
;src/editor/editor.c:1372: ShowError(result, "");
	ld	de, ___src_editor_editor_c_str_69
	ld	a, [hl]
	call	_ShowError
;src/editor/editor.c:1373: selected = LIST_ALL; // skips the list
	ld	hl, 268
	add	hl, sp
	ld	[hl], $FF
	inc	hl
	ld	[hl], $FF
	jp	.l00224
.l00104:
;src/editor/editor.c:1375: else ListFolder(path, 0);
	ld	bc, $0000
	ld	hl, 0
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_ListFolder
;src/editor/editor.c:1376: while (selected != LIST_ALL) {
.l00224:
.l00196:
	ld	hl, 268
	add	hl, sp
	ld	a, [hl]
	inc	hl
	and	a, [hl]
	inc	a
	jp	NZ,.l00474
	jp	.l00198
.l00474:
;src/editor/editor.c:1377: if (selected < first) first = selected;
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
;src/editor/editor.c:1378: else if (selected >= first + LIST_ROWS) first = selected - LIST_ROWS + 1;
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
;src/editor/editor.c:1379: if (!list_result && first != drawn) {
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
	jp	NZ,.l00475
	dec	hl
	ld	a, [hl]
	inc	hl
	inc	hl
	sub	a, [hl]
	jp	NZ,.l00475
	jp	.l00120
.l00475:
;src/editor/editor.c:1380: if (drawn != LIST_ALL && first == drawn + 1) ScrollList(path, first, 1);
	ld	hl, 260
	add	hl, sp
	ld	a, [hl]
	inc	hl
	and	a, [hl]
	inc	a
	jp	NZ,.l00476
	ld	a,$01
	jp	.l00477
.l00476:
	xor	a,a
.l00477:
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
	jp	NZ,.l00478
	ld	hl, 267
	add	hl, sp
	ld	a, [hl]
	ld	hl, 259
	add	hl, sp
	sub	a, [hl]
	jp	NZ,.l00478
	jp	.l00479
.l00478:
	jp	.l00116
.l00479:
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
;src/editor/editor.c:1381: else if (drawn != LIST_ALL && first + 1 == drawn) ScrollList(path, first, 0);
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
	jp	NZ,.l00480
	inc	hl
	ld	a, [hl]
	sub	a, b
	jp	NZ,.l00480
	jp	.l00481
.l00480:
	jp	.l00112
.l00481:
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
;src/editor/editor.c:1382: else ListRows(path, first, 0, LIST_ROWS);
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
;src/editor/editor.c:1383: HideBox();
	call	_HideBox__far
;src/editor/editor.c:1384: drawn = first;
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
;src/editor/editor.c:1386: if (list_result) {
	ld	hl, _list_result
	ld	a, [hl]
	or	a, a
	jp	Z, .l00125
;src/editor/editor.c:1387: if (!path[0]) { // can't read the card
	ld	hl, sp+0
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00123
;src/editor/editor.c:1388: ShowError(list_result, "");
	ld	de, ___src_editor_editor_c_str_69
	ld	hl, _list_result
	ld	a, [hl]
	call	_ShowError
;src/editor/editor.c:1389: break;
	jp	.l00198
.l00123:
;src/editor/editor.c:1391: path[0] = 0; // folder is gone, back to the root
	ld	hl, sp+0
	ld	[hl], $00
;src/editor/editor.c:1392: ListLoading(path, 0xFF);
	ld	a, $FF
	ld	hl, 0
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_ListLoading
;src/editor/editor.c:1393: selected = ListFolder(path, 0);
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
;src/editor/editor.c:1394: drawn = LIST_ALL;
	ld	hl, 260
	add	hl, sp
	ld	[hl], $FF
	inc	hl
	ld	[hl], $FF
;src/editor/editor.c:1395: continue;
	jp	.l00196
.l00125:
;src/editor/editor.c:1397: row = (unsigned char)(selected - first);
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
;src/editor/editor.c:1398: ListBars(path, row, list_count);
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
;src/editor/editor.c:1399: NoHighlight();
	call	_NoHighlight__far
;src/editor/editor.c:1400: if (list_count) render_sel[(row + 1) << 1] = 0, render_sel[((row + 1) << 1) + 1] = 0xFF;
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
;src/editor/editor.c:1401: EditorDraw();
	call	_EditorDraw
;src/editor/editor.c:1402: while (!(key = MenuKey()));
.l00128:
	call	_MenuKey__far
	ld	hl, 265
	add	hl, sp
	ld	[hl], a
	or	a, a
	jp	Z, .l00128
;src/editor/editor.c:1403: if (key == KEY_UP && selected) --selected;
	ld	a, [hl]
	sub	a, $82
	jp	NZ,.l00482
	jp	.l00483
.l00482:
	jp	.l00193
.l00483:
	ld	hl, 269
	add	hl, sp
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	jp	Z, .l00193
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
	jp	.l00196
.l00193:
;src/editor/editor.c:1404: else if (key == KEY_DOWN && selected + 1 < list_count) ++selected;
	ld	hl, 265
	add	hl, sp
	ld	a, [hl]
	sub	a, $83
	jp	NZ,.l00484
	jp	.l00485
.l00484:
	jp	.l00189
.l00485:
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
	jp	NC, .l00189
	ld	hl, 268
	add	hl, sp
	ld	[hl], c
	inc	hl
	ld	[hl], b
	jp	.l00196
.l00189:
;src/editor/editor.c:1405: else if (key == KEY_PAGE_UP) selected = selected > LIST_ROWS ? selected - LIST_ROWS : 0;
	ld	hl, 265
	add	hl, sp
	ld	a, [hl]
	sub	a, $86
	jp	NZ,.l00486
	jp	.l00487
.l00486:
	jp	.l00186
.l00487:
	ld	hl, 268
	add	hl, sp
	ld	a, $10
	sub	a, [hl]
	inc	hl
	ld	a, $00
	sbc	a, [hl]
	jp	NC, .l00207
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
	jp	.l00208
.l00207:
	ld	c, $00
	xor	a, a
.l00208:
	ld	hl, 268
	add	hl, sp
	ld	[hl], c
	inc	hl
	ld	[hl], a
	jp	.l00196
.l00186:
;src/editor/editor.c:1406: else if (key == KEY_PAGE_DOWN && list_count) selected = selected + LIST_ROWS < list_count ? selected + LIST_ROWS : list_count - 1;
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
	jp	NZ,.l00488
	jp	.l00489
.l00488:
	jp	.l00182
.l00489:
	ld	hl, _list_count + 1
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	jp	Z, .l00182
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
	jp	NC, .l00209
	ld	c, e
	ld	b, d
	jp	.l00210
.l00209:
.l00210:
	ld	hl, 268
	add	hl, sp
	ld	[hl], c
	inc	hl
	ld	[hl], b
	jp	.l00196
.l00182:
;src/editor/editor.c:1407: else if (key == KEY_HOME) selected = 0;
	ld	hl, 265
	add	hl, sp
	ld	a, [hl]
	sub	a, $84
	jp	NZ,.l00490
	jp	.l00491
.l00490:
	jp	.l00179
.l00491:
	xor	a, a
	ld	hl, 268
	add	hl, sp
	ld	[hl], a
	inc	hl
	ld	[hl], a
	jp	.l00196
.l00179:
;src/editor/editor.c:1408: else if (key == KEY_END && list_count) selected = list_count - 1;
	ld	hl, 265
	add	hl, sp
	ld	a, [hl]
	sub	a, $85
	jp	NZ,.l00492
	jp	.l00493
.l00492:
	jp	.l00175
.l00493:
	ld	hl, _list_count + 1
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	jp	Z, .l00175
	ld	hl, 268
	add	hl, sp
	ld	[hl], c
	inc	hl
	ld	[hl], b
	jp	.l00196
.l00175:
;src/editor/editor.c:1409: else if ((key == KEY_ENTER || key == KEY_RIGHT) && list_count && list_kinds[row] != KIND_UP) {
	ld	hl, 265
	add	hl, sp
	ld	a, [hl]
	sub	a, $0A
	jp	NZ,.l00494
	ld	a,$01
	jp	.l00495
.l00494:
	xor	a,a
.l00495:
	ld	hl, 266
	add	hl, sp
	ld	[hl], a
	dec	hl
	ld	a, [hl]
	sub	a, $81
	jp	NZ,.l00496
	ld	a,$01
	jp	.l00497
.l00496:
	xor	a,a
.l00497:
	ld	hl, 267
	add	hl, sp
	ld	[hl], a
	dec	hl
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00172
	inc	hl
	ld	a, [hl]
	or	a, a
	jp	Z, .l00169
.l00172:
	ld	hl, _list_count + 1
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	jp	Z, .l00169
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
	jp	Z, .l00169
;src/editor/editor.c:1410: if (list_kinds[row] == KIND_FOLDER) ListLoading(path, row);
	dec	a
	jp	NZ,.l00498
	jp	.l00499
.l00498:
	jp	.l00132
.l00499:
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
;src/editor/editor.c:1411: else ShowBusy("Loading...");
	ld	de, ___src_editor_editor_c_str_70
	call	_ShowBusy
.l00133:
;src/editor/editor.c:1412: if (ListEntry(path, selected) == 0xFF) continue; // its full name
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
	jp	NZ,.l00500
	jp	.l00196
.l00500:
;src/editor/editor.c:1413: for (length = 0; path[length]; ++length);
	ld	c, $00
.l00200:
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
	ld	hl, 267
	add	hl, sp
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, 266
	add	hl, sp
	ld	[hl], a
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	or	a, a
	jp	Z, .l00263
	inc	c
	jp	.l00200
.l00263:
	ld	hl, 267
	add	hl, sp
	ld	[hl], c
;src/editor/editor.c:1414: if (entry.dir) {
	ld	a, [(_entry + 73) + 0]
	or	a, a
	jp	Z, .l00149
;src/editor/editor.c:1415: if (JoinPath(path + length, "", entry.name, PATH_SIZE - length)) {
	ld	a, $80
	sub	a, c
	dec	hl
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	push	af
	inc	sp
	ld	bc, _entry
	push	bc
	ld	bc, ___src_editor_editor_c_str_69
	call	_JoinPath
	or	a, a
	jp	Z, .l00138
;src/editor/editor.c:1416: selected = ListFolder(path, 0);
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
;src/editor/editor.c:1417: drawn = LIST_ALL;
	ld	hl, 260
	add	hl, sp
	ld	[hl], $FF
	inc	hl
	ld	[hl], $FF
	jp	.l00196
.l00138:
;src/editor/editor.c:1420: path[length] = 0;
	ld	hl, 265
	add	hl, sp
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	ld	[hl], $00
;src/editor/editor.c:1421: ListMessage("Path is too long");
	ld	de, ___src_editor_editor_c_str_71
	call	_ListMessage
	jp	.l00196
.l00149:
;src/editor/editor.c:1425: JoinPath(path + length, "", entry.name, FS_NAME_SIZE + 1);
	ld	hl, 265
	add	hl, sp
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, $42
	push	af
	inc	sp
	ld	bc, _entry
	push	bc
	ld	bc, ___src_editor_editor_c_str_69
	call	_JoinPath
;src/editor/editor.c:1426: if (IsGame(entry.name)) {
	ld	de, _entry
	call	_IsGame__far
	or	a, a
	jp	Z, .l00141
;src/editor/editor.c:1427: LaunchGame(path); // returns if it doesn't launch
	ld	hl, 0
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_LaunchGame__far
;src/editor/editor.c:1428: path[length] = 0;
	ld	hl, 265
	add	hl, sp
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	ld	[hl], $00
;src/editor/editor.c:1429: drawn = LIST_ALL;
	ld	hl, 260
	add	hl, sp
	ld	[hl], $FF
	inc	hl
	ld	[hl], $FF
;src/editor/editor.c:1430: continue;
	jp	.l00196
.l00141:
;src/editor/editor.c:1432: if (entry.size > TB_SIZE) result = FileLoadLarge(path);
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
	xor	a, a
	cp	a, c
	ld	a, $FE
	sbc	a, b
	ld	a, $00
	sbc	a, l
	ld	a, $00
	sbc	a, h
	jp	NC, .l00143
	ld	hl, 0
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_FileLoadLarge
	ld	c, a
	jp	.l00144
.l00143:
;src/editor/editor.c:1434: FileCloseLarge();
	call	_FileCloseLarge
;src/editor/editor.c:1435: result = FileLoad(path);
	ld	hl, 0
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_FileLoad
	ld	c, a
.l00144:
;src/editor/editor.c:1437: HideBox();
	push	bc
	call	_HideBox__far
	pop	bc
;src/editor/editor.c:1438: path[length] = 0;
	push	hl
	ld	hl, 2
	add	hl, sp
	ld	e, l
	ld	d, h
	pop	hl
	ld	hl, 267
	add	hl, sp
	ld	l, [hl]
	ld	h, $00
	add	hl, de
	ld	e, l
	ld	d, h
	xor	a, a
	ld	[de], a
;src/editor/editor.c:1439: if (result) {
	ld	a, c
	or	a, a
	jp	Z, .l00146
;src/editor/editor.c:1440: file_name[0] = 0; // the text buffer only has part of it, don't save over the file
	ld	hl, _file_name
	ld	[hl], $00
;src/editor/editor.c:1441: ShowError(result, "TOO BIG");
	ld	de, ___src_editor_editor_c_str_72
	ld	a, c
	call	_ShowError
	jp	.l00147
.l00146:
;src/editor/editor.c:1444: CopyName(file_dir, path);
	ld	hl, 0
	add	hl, sp
	ld	c, l
	ld	b, h
	ld	de, _file_dir
	call	_CopyName
;src/editor/editor.c:1445: CopyName(file_name, entry.name);
	ld	bc, _entry
	ld	de, _file_name
	call	_CopyName
.l00147:
;src/editor/editor.c:1447: opened = 1;
	ld	hl, 262
	add	hl, sp
	ld	[hl], $01
;src/editor/editor.c:1448: break;
	jp	.l00198
.l00169:
;src/editor/editor.c:1451: else if (path[0] && (key == KEY_LEFT || key == KEY_BACKSPACE ||
	ld	hl, sp+0
	ld	c, [hl]
	ld	hl, 265
	add	hl, sp
	ld	a, [hl]
	sub	a, $08
	jp	NZ,.l00501
	ld	a,$01
	jp	.l00502
.l00501:
	xor	a,a
.l00502:
	ld	e, a
	ld	a, c
	or	a, a
	jp	Z, .l00160
	ld	hl, 265
	add	hl, sp
	ld	a, [hl]
	sub	a, $80
	jp	NZ,.l00503
	jp	.l00258
.l00503:
	ld	a, e
	or	a, a
	jp	NZ, .l00258
;src/editor/editor.c:1452: ((key == KEY_ENTER || key == KEY_RIGHT) && list_count && list_kinds[row] == KIND_UP))) {
	ld	hl, 266
	add	hl, sp
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00164
	inc	hl
	ld	a, [hl]
	or	a, a
	jp	Z, .l00160
.l00164:
	ld	hl, _list_count + 1
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	jp	Z, .l00160
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
	jp	NZ, .l00160
;src/editor/editor.c:1453: for (length = 0; path[length]; ++length);
.l00258:
	ld	c, $00
.l00203:
	ld	e, c
	ld	d, $00
	ld	hl, 0
	add	hl, sp
	add	hl, de
	ld	a, [hl]
	or	a, a
	jp	Z, .l00259
	inc	c
	jp	.l00203
;src/editor/editor.c:1454: while (path[--length] != '/');
.l00259:
.l00152:
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
	jp	NZ,.l00504
	jp	.l00505
.l00504:
	jp	.l00152
.l00505:
;src/editor/editor.c:1455: CopyName(name, path + length + 1);
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
;src/editor/editor.c:1456: path[length] = 0;
	ld	hl, 268
	add	hl, sp
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	ld	[hl], $00
;src/editor/editor.c:1457: ListLoading(path, 0xFF);
	ld	a, $FF
	ld	hl, 0
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_ListLoading
;src/editor/editor.c:1458: selected = ListFolder(path, name); // back on the folder it came from
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
;src/editor/editor.c:1459: drawn = LIST_ALL;
	ld	hl, 260
	add	hl, sp
	ld	[hl], $FF
	inc	hl
	ld	[hl], $FF
	jp	.l00196
.l00160:
;src/editor/editor.c:1461: else if (key == KEY_ESCAPE || key == KEY_BACKSPACE || key == KEY_MENU) break;
	ld	hl, 265
	add	hl, sp
	ld	a, [hl]
	sub	a, $1B
	jp	NZ,.l00506
	jp	.l00198
.l00506:
	ld	a, e
	or	a, a
	jp	NZ, .l00198
	ld	hl, 265
	add	hl, sp
	ld	a, [hl]
	sub	a, $89
	jp	NZ,.l00507
	jp	.l00508
.l00507:
	jp	.l00196
.l00508:
.l00198:
;src/editor/editor.c:1463: font = editor_font;
	ld	hl, 263
	add	hl, sp
	ld	a, [hl]
	ld	hl, _font
	ld	[hl], a
;src/editor/editor.c:1464: SetFont(font);
	ld	a, [hl]
	call	_SetFont
;src/editor/editor.c:1465: render_text = 1;
	ld	hl, _render_text
	ld	[hl], $01
;src/editor/editor.c:1466: SetRows();
	call	_SetRows__far
;src/editor/editor.c:1467: return opened;
	ld	hl, 262
	add	hl, sp
	ld	a, [hl]
.l00205:
;src/editor/editor.c:1468: }
	ld	hl, 270
	add	hl, sp
	ld	sp, hl
	ret
	SECTION FRAGMENT "src/editor/editor.c FIXED",ROMX,BANK[1]
___src_editor_editor_c_str_69:
	DB $00
	SECTION FRAGMENT "src/editor/editor.c FIXED",ROMX,BANK[1]
___src_editor_editor_c_str_70:
	DB "Loading..."
	DB $00
	SECTION FRAGMENT "src/editor/editor.c FIXED",ROMX,BANK[1]
___src_editor_editor_c_str_71:
	DB "Path is too long"
	DB $00
	SECTION FRAGMENT "src/editor/editor.c FIXED",ROMX,BANK[1]
___src_editor_editor_c_str_72:
	DB "TOO BIG"
	DB $00
;src/editor/editor.c:1471: static unsigned char IsGame(const char* name) {
;	---------------------------------
	SECTION FRAGMENT "Page 6",ROMX,BANK[3]
	LOAD FRAGMENT "Page 6 RAM",SRAM,BANK[6]
; Function IsGame
; ---------------------------------
_IsGame:
;src/editor/editor.c:1472: const char* dot = 0;
	ld	bc, $0000
;src/editor/editor.c:1474: return dot && (dot[1] | 0x20) == 'g' && (dot[2] | 0x20) == 'b' && (!dot[3] || ((dot[3] | 0x20) == 'c' && !dot[4]));
.l00105:
;src/editor/editor.c:1473: for (; *name; ++name) if (*name == '.') dot = name;
	ld	a, [de]
	or	a, a
	jp	Z, .l00103
	sub	a, $2E
	jp	NZ,.l00163
	jp	.l00164
.l00163:
	jp	.l00106
.l00164:
	ld	c, e
	ld	b, d
.l00106:
	inc	de
	jp	.l00105
.l00103:
;src/editor/editor.c:1474: return dot && (dot[1] | 0x20) == 'g' && (dot[2] | 0x20) == 'b' && (!dot[3] || ((dot[3] | 0x20) == 'c' && !dot[4]));
	ld	a, b
	or	a, c
	jp	Z, .l00109
	ld	e, c
	ld	d, b
	inc	de
	ld	a, [de]
	set	5, a
	sub	a, $67
	jp	NZ,.l00165
	jp	.l00166
.l00165:
	jp	.l00109
.l00166:
	ld	e, c
	ld	d, b
	inc	de
	inc	de
	ld	a, [de]
	set	5, a
	sub	a, $62
	jp	NZ,.l00167
	jp	.l00168
.l00167:
	jp	.l00109
.l00168:
	ld	e, c
	ld	d, b
	inc	de
	inc	de
	inc	de
	ld	a, [de]
	or	a, a
	jp	Z, .l00110
	set	5, a
	sub	a, $63
	jp	NZ,.l00169
	jp	.l00170
.l00169:
	jp	.l00109
.l00170:
	inc	bc
	inc	bc
	inc	bc
	inc	bc
	ld	a, [bc]
	or	a, a
	jp	Z, .l00110
.l00109:
	xor	a, a
	jp	.l00111
.l00110:
	ld	a, $01
.l00111:
.l00107:
;src/editor/editor.c:1475: }
	ret
;src/editor/editor.c:1479: static void LaunchGame(const char* path) {
;	---------------------------------
	SECTION FRAGMENT "Page 6",ROMX,BANK[3]
	LOAD FRAGMENT "Page 6 RAM",SRAM,BANK[6]
; Function LaunchGame
; ---------------------------------
_LaunchGame:
	add	sp, -42
	ld	hl, sp+40
	ld	[hl], e
	inc	hl
	ld	[hl], d
;src/editor/editor.c:1483: if (doc_large) {
	ld	hl, _doc_large
	ld	a, [hl]
	or	a, a
	jp	Z, .l00104
;src/editor/editor.c:1484: if (!CanDiscard()) return;
	call	_CanDiscard__far
	or	a, a
	jp	NZ, .l00102
	jp	.l00121
.l00102:
;src/editor/editor.c:1485: FileCloseLarge();
	call	_FileCloseLarge
;src/editor/editor.c:1486: tb_Clear();
	call	_tb_Clear
;src/editor/editor.c:1487: file_name[0] = 0;
	ld	hl, _file_name
	ld	[hl], $00
;src/editor/editor.c:1488: modified = 0;
	ld	hl, _modified
	ld	[hl], $00
;src/editor/editor.c:1489: SettingsSave();
	call	_SettingsSave
.l00104:
;src/editor/editor.c:1491: ShowBusy("Loading...");
	ld	de, ___src_editor_editor_c_str_73
	call	_ShowBusy__far
;src/editor/editor.c:1492: if ((result = FileSaveSwap())) {
	call	_FileSaveSwap
	ld	c, a
	or	a, a
	jp	Z, .l00106
;src/editor/editor.c:1493: HideBox();
	push	bc
	call	_HideBox
	pop	bc
;src/editor/editor.c:1494: ShowError(result, "DISK FULL");
	ld	de, ___src_editor_editor_c_str_74
	ld	a, c
	call	_ShowError__far
;src/editor/editor.c:1495: return;
	jp	.l00121
.l00106:
;src/editor/editor.c:1497: result = FileGameOpen(path);
	ld	hl, sp+40
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_FileGameOpen
	ld	c, a
;src/editor/editor.c:1498: while (!result && game_block != game_blocks) { // "Loading 512/2048 KB"
.l00108:
	ld	a, c
	or	a, a
	jp	NZ, .l00110
	ld	hl, _game_block
	ld	a, [hl]
	ld	hl, _game_blocks
	sub	a, [hl]
	jp	NZ,.l00179
	ld	hl, _game_block + 1
	ld	a, [hl]
	ld	hl, _game_blocks + 1
	sub	a, [hl]
	jp	NZ,.l00179
	jp	.l00110
.l00179:
;src/editor/editor.c:1499: end = PutText(text, "Loading ");
	ld	bc, ___src_editor_editor_c_str_75
	ld	hl, 0
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_PutText__far
;src/editor/editor.c:1500: end = PutNumber(end, game_block >> 1);
	ld	hl, _game_block + 1
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	srl	d
	rr	e
	ld	hl, $0000
	push	hl
	push	de
	ld	e, c
	ld	d, b
	call	_PutNumber__far
;src/editor/editor.c:1501: *end++ = '/';
	ld	a, $2F
	ld	[bc], a
	inc	bc
;src/editor/editor.c:1502: end = PutText(PutNumber(end, game_blocks >> 1), " KB");
	ld	hl, _game_blocks + 1
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	srl	d
	rr	e
	ld	hl, $0000
	push	hl
	push	de
	ld	e, c
	ld	d, b
	call	_PutNumber__far
	ld	e, c
	ld	d, b
	ld	bc, ___src_editor_editor_c_str_76
	call	_PutText__far
;src/editor/editor.c:1503: *end = 0;
	xor	a, a
	ld	[bc], a
;src/editor/editor.c:1504: ShowBusy(text);
	ld	hl, 0
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_ShowBusy__far
;src/editor/editor.c:1505: result = FileGameCopy();
	call	_FileGameCopy
	ld	c, a
	jp	.l00108
.l00110:
;src/editor/editor.c:1507: if (!result) result = FileGameFinish(path);
	ld	a, c
	or	a, a
	jp	NZ, .l00112
	ld	hl, sp+40
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_FileGameFinish
	ld	c, a
.l00112:
;src/editor/editor.c:1508: if (result) {
	ld	a, c
	or	a, a
	jp	Z, .l00114
;src/editor/editor.c:1509: HideBox();
	push	bc
	call	_HideBox
	pop	bc
;src/editor/editor.c:1510: ShowError(result, "TOO BIG");
	ld	de, ___src_editor_editor_c_str_77
	ld	a, c
	call	_ShowError__far
;src/editor/editor.c:1511: Reboot(); // PSRAM's text may be overwritten, booting restores it from the swap file
	call	_Reboot
.l00114:
;src/editor/editor.c:1514: basename = path;
	ld	hl, sp+40
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
;src/editor/editor.c:1515: for (scan = path; *scan; ++scan) if (*scan == '/') basename = scan + 1;
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
.l00119:
	ld	a, [de]
	or	a, a
	jp	Z, .l00117
	inc	de
	sub	a, $2F
	jp	NZ,.l00180
	jp	.l00181
.l00180:
	jp	.l00120
.l00181:
	ld	c, e
	ld	b, d
.l00120:
	jp	.l00119
.l00117:
;src/editor/editor.c:1516: *ToLatin1(text, basename, sizeof(text) - 1) = 0;
	ld	a, $27
	push	af
	inc	sp
	ld	hl, 1
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_ToLatin1__far
	xor	a, a
	ld	[bc], a
;src/editor/editor.c:1517: InGameHeader(text);
	ld	hl, 0
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_InGameHeader
;src/editor/editor.c:1518: GameLaunch();
	call	_GameLaunch
.l00121:
;src/editor/editor.c:1519: }
	add	sp, 42
	ret
	SECTION FRAGMENT "src/editor/editor.c FIXED",ROMX,BANK[1]
___src_editor_editor_c_str_73:
	DB "Loading..."
	DB $00
	SECTION FRAGMENT "src/editor/editor.c FIXED",ROMX,BANK[1]
___src_editor_editor_c_str_74:
	DB "DISK FULL"
	DB $00
	SECTION FRAGMENT "src/editor/editor.c FIXED",ROMX,BANK[1]
___src_editor_editor_c_str_75:
	DB "Loading "
	DB $00
	SECTION FRAGMENT "src/editor/editor.c FIXED",ROMX,BANK[1]
___src_editor_editor_c_str_76:
	DB " KB"
	DB $00
	SECTION FRAGMENT "src/editor/editor.c FIXED",ROMX,BANK[1]
___src_editor_editor_c_str_77:
	DB "TOO BIG"
	DB $00
;src/editor/editor.c:1521: static void OpenFile(void) {
;	---------------------------------
	SECTION FRAGMENT "Page 4",ROMX,BANK[2]
	LOAD FRAGMENT "Page 4 RAM",SRAM,BANK[4]
; Function OpenFile
; ---------------------------------
_OpenFile:
;src/editor/editor.c:1522: if (!CanDiscard()) return;
	call	_CanDiscard
	or	a, a
	jp	NZ, .l00102
	jp	.l00105
.l00102:
;src/editor/editor.c:1523: if (Browse()) {
	call	_Browse
	or	a, a
	jp	Z, .l00105
;src/editor/editor.c:1524: ResetCursor();
	call	_ResetCursor__far
;src/editor/editor.c:1525: SettingsSave();
	jp	_SettingsSave
.l00105:
;src/editor/editor.c:1527: }
	ret
;src/editor/editor.c:1530: static unsigned char NameChar(unsigned char c) {
;	---------------------------------
	SECTION FRAGMENT "Page 4",ROMX,BANK[2]
	LOAD FRAGMENT "Page 4 RAM",SRAM,BANK[4]
; Function NameChar
; ---------------------------------
_NameChar:
	ld	c, a
;src/editor/editor.c:1531: if (c < ' ' || (c >= 0x7F && c < 0xA0)) return 0;
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
;src/editor/editor.c:1532: return c != '/' && c != 0x5C && c != ':' && c != '*' && c != '?' && c != '"' && c != '<' && c != '>' && c != '|';
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
;src/editor/editor.c:1533: }
	ret
;src/editor/editor.c:1536: static unsigned char AskFileName(void) {
;	---------------------------------
	SECTION FRAGMENT "Page 4",ROMX,BANK[2]
	LOAD FRAGMENT "Page 4 RAM",SRAM,BANK[4]
; Function AskFileName
; ---------------------------------
_AskFileName:
	add	sp, -78
;src/editor/editor.c:1541: length = (unsigned char)(ToLatin1(name, file_name, NAME_CHARS) - name);
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
;src/editor/editor.c:1542: Render();
	call	_Render__far
;src/editor/editor.c:1543: EditorShowCursor(0);
	xor	a, a
	call	_EditorShowCursor
;src/editor/editor.c:1544: NoHighlight();
	call	_NoHighlight__far
;src/editor/editor.c:1545: while (1) {
.l00125:
;src/editor/editor.c:1546: end = PutText(text, "Save as ");
	ld	bc, ___src_editor_editor_c_str_78
	ld	hl, 35
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_PutText__far
;src/editor/editor.c:1547: for (i = 0; i < length; ++i) *end++ = name[i];
	ld	e, $00
.l00128:
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
	jp	.l00128
.l00101:
;src/editor/editor.c:1548: *end++ = '_';
	ld	a, $5F
	ld	[bc], a
	pop	bc
	push	bc
;src/editor/editor.c:1549: *end = 0;
	xor	a, a
	ld	[bc], a
;src/editor/editor.c:1550: if (bars) {
	ld	hl, _bars
	ld	a, [hl]
	or	a, a
	jp	Z, .l00103
;src/editor/editor.c:1551: DrawRow(HEADER_LINE, 1, text);
	ld	hl, 35
	add	hl, sp
	push	hl
	ld	e, $01
	ld	a, $12
	call	_DrawRow__far
;src/editor/editor.c:1552: end = PutText(text, "in ");
	ld	bc, ___src_editor_editor_c_str_79
	ld	hl, 35
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_PutText__far
	ld	e, c
	ld	d, b
;src/editor/editor.c:1553: PutPath(end, file_dir, 28);
	ld	a, $1C
	push	af
	inc	sp
	ld	bc, _file_dir
	call	_PutPath
;src/editor/editor.c:1554: DrawRow(STATUS_LINE, 1, text);
	ld	hl, 35
	add	hl, sp
	push	hl
	ld	e, $01
	ld	a, $13
	call	_DrawRow__far
	jp	.l00104
.l00103:
;src/editor/editor.c:1556: else DrawRow(0, 0, text);
	ld	hl, 35
	add	hl, sp
	push	hl
	ld	e, $00
	xor	a, a
	call	_DrawRow__far
.l00104:
;src/editor/editor.c:1557: EditorDraw();
	call	_EditorDraw
;src/editor/editor.c:1558: do {
.l00107:
;src/editor/editor.c:1559: WaitFrame();
	call	_WaitFrame
;src/editor/editor.c:1560: key = (unsigned char)KBPopEvent();
	call	_KBPopEvent
	ld	hl, sp+76
	ld	[hl], c
;src/editor/editor.c:1561: if (!key) key = PadKey();
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00108
	call	_PadKey__far
	ld	hl, sp+76
	ld	[hl], a
.l00108:
;src/editor/editor.c:1562: } while (!key);
	ld	hl, sp+76
	ld	a, [hl]
	or	a, a
	jp	Z, .l00107
;src/editor/editor.c:1563: if (key == KEY_ENTER && length) break;
	ld	a, [hl]
	sub	a, $0A
	jp	NZ,.l00203
	jp	.l00204
.l00203:
	jp	.l00111
.l00204:
	ld	hl, sp+77
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00126
.l00111:
;src/editor/editor.c:1564: if (key == KEY_ESCAPE || key == KEY_MENU || (key == KEY_BACKSPACE && !length)) {
	ld	hl, sp+76
	ld	a, [hl]
	sub	a, $1B
	jp	NZ,.l00205
	jp	.l00113
.l00205:
	ld	hl, sp+76
	ld	a, [hl]
	sub	a, $89
	jp	NZ,.l00206
	jp	.l00113
.l00206:
	ld	hl, sp+76
	ld	a, [hl]
	sub	a, $08
	jp	NZ,.l00207
	ld	a,$01
	jp	.l00208
.l00207:
	xor	a,a
.l00208:
	ld	c, a
	ld	a, c
	or	a, a
	jp	Z, .l00114
	ld	hl, sp+77
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00114
.l00113:
;src/editor/editor.c:1565: dirty = 1;
	ld	hl, _dirty
	ld	[hl], $01
;src/editor/editor.c:1566: return 0;
	xor	a, a
	jp	.l00130
.l00114:
;src/editor/editor.c:1568: if (key == KEY_BACKSPACE) --length;
	ld	a, c
	or	a, a
	jp	Z, .l00122
	ld	hl, sp+77
	dec	[hl]
	jp	.l00125
.l00122:
;src/editor/editor.c:1569: else if (length < NAME_CHARS && NameChar(key)) name[length++] = key;
	ld	hl, sp+77
	ld	a, [hl]
	sub	a, $20
	jp	NC, .l00125
	dec	hl
	ld	a, [hl]
	call	_NameChar
	or	a, a
	jp	Z, .l00125
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
	jp	.l00125
.l00126:
;src/editor/editor.c:1571: name[length] = 0;
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
;src/editor/editor.c:1572: ToUtf8(file_name, name);
	ld	hl, 2
	add	hl, sp
	ld	c, l
	ld	b, h
	ld	de, _file_name
	call	_ToUtf8
;src/editor/editor.c:1573: SetLang();
	call	_SetLang__far
;src/editor/editor.c:1574: dirty = 1;
	ld	hl, _dirty
	ld	[hl], $01
;src/editor/editor.c:1575: return 1;
	ld	a, $01
.l00130:
;src/editor/editor.c:1576: }
	add	sp, 78
	ret
	SECTION FRAGMENT "src/editor/editor.c FIXED",ROMX,BANK[1]
___src_editor_editor_c_str_78:
	DB "Save as "
	DB $00
	SECTION FRAGMENT "src/editor/editor.c FIXED",ROMX,BANK[1]
___src_editor_editor_c_str_79:
	DB "in "
	DB $00
;src/editor/editor.c:1578: static void SaveFile(unsigned char ask) {
;	---------------------------------
	SECTION FRAGMENT "Page 4",ROMX,BANK[2]
	LOAD FRAGMENT "Page 4 RAM",SRAM,BANK[4]
; Function SaveFile
; ---------------------------------
_SaveFile:
	add	sp, -128
	add	sp, -65
	ld	c, a
;src/editor/editor.c:1581: if ((ask || !file_name[0]) && !AskFileName()) return;
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
;src/editor/editor.c:1582: JoinPath(path, file_dir, file_name, (unsigned char)(PATH_SIZE + FS_NAME_SIZE));
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
;src/editor/editor.c:1583: ShowBusy("Saving...");
	ld	de, ___src_editor_editor_c_str_80
	call	_ShowBusy
;src/editor/editor.c:1584: result = FileMount();
	call	_FileMount
	ld	c, a
;src/editor/editor.c:1585: if (!result) result = doc_large ? FileSaveLarge(path) : FileSave(path);
	ld	a, c
	or	a, a
	jp	NZ, .l00106
	ld	hl, _doc_large
	ld	a, [hl]
	or	a, a
	jp	Z, .l00111
	ld	hl, 0
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_FileSaveLarge
	jp	.l00112
.l00111:
	ld	hl, 0
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_FileSave
.l00112:
	ld	c, a
.l00106:
;src/editor/editor.c:1586: HideBox();
	push	bc
	call	_HideBox__far
	pop	bc
;src/editor/editor.c:1587: SettingsSave(); // save as may have changed the name
	push	bc
	call	_SettingsSave
	pop	bc
;src/editor/editor.c:1588: if (result) {
	ld	a, c
	or	a, a
	jp	Z, .l00108
;src/editor/editor.c:1589: ShowError(result, "DISK FULL");
	ld	de, ___src_editor_editor_c_str_81
	ld	a, c
	call	_ShowError
;src/editor/editor.c:1590: return;
	jp	.l00109
.l00108:
;src/editor/editor.c:1592: modified = 0;
	ld	hl, _modified
	ld	[hl], $00
;src/editor/editor.c:1593: UndoSaved();
	call	_UndoSaved
;src/editor/editor.c:1594: ShowMessage("SAVED");
	ld	de, ___src_editor_editor_c_str_82
	call	_ShowMessage__far
.l00109:
;src/editor/editor.c:1595: }
	add	sp, 127
	add	sp, 66
	ret
	SECTION FRAGMENT "src/editor/editor.c FIXED",ROMX,BANK[1]
___src_editor_editor_c_str_80:
	DB "Saving..."
	DB $00
	SECTION FRAGMENT "src/editor/editor.c FIXED",ROMX,BANK[1]
___src_editor_editor_c_str_81:
	DB "DISK FULL"
	DB $00
	SECTION FRAGMENT "src/editor/editor.c FIXED",ROMX,BANK[1]
___src_editor_editor_c_str_82:
	DB "SAVED"
	DB $00
;src/editor/editor.c:1598: static void ToggleWrap(void) {
;	---------------------------------
	SECTION FRAGMENT "Page 6",ROMX,BANK[3]
	LOAD FRAGMENT "Page 6 RAM",SRAM,BANK[6]
; Function ToggleWrap
; ---------------------------------
_ToggleWrap:
;src/editor/editor.c:1599: tb_nowrap = !tb_nowrap;
	ld	hl, _tb_nowrap
	ld	a, [hl]
	sub	a,$01
	ld	a, $00
	rla
	ld	[hl], a
;src/editor/editor.c:1600: tb_left = 0;
	xor	a, a
	ld	hl, _tb_left
	ld	[hl], a
	inc	hl
	ld	[hl], a
;src/editor/editor.c:1601: dirty = 1;
	ld	hl, _dirty
	ld	[hl], $01
;src/editor/editor.c:1602: SettingsSave();
	jp	_SettingsSave
.l00101:
;src/editor/editor.c:1603: }
	ret
;src/editor/editor.c:1606: static void ShowHelp(void) {
;	---------------------------------
	SECTION FRAGMENT "Page 6",ROMX,BANK[3]
	LOAD FRAGMENT "Page 6 RAM",SRAM,BANK[6]
; Function ShowHelp
; ---------------------------------
_ShowHelp:
	dec	sp
;src/editor/editor.c:1607: unsigned char row, editor_font = font;
	ld	hl, _font
	ld	a, [hl]
	ld	hl, sp+0
	ld	[hl], a
;src/editor/editor.c:1608: font = FONT_VWF;
	ld	hl, _font
	ld	[hl], $01
;src/editor/editor.c:1609: SetFont(font);
	ld	a, $01
	call	_SetFont
;src/editor/editor.c:1610: render_text = 0;
	ld	hl, _render_text
	ld	[hl], $00
;src/editor/editor.c:1611: BeginFullScreen();
	call	_BeginFullScreen
;src/editor/editor.c:1612: for (row = 0; row < HELP_ROWS; ++row) DrawRow(row, 0, help_lines[row]);
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
;src/editor/editor.c:1613: EditorDraw();
	call	_EditorDraw
;src/editor/editor.c:1614: while (!MenuKey());
.l00102:
	call	_MenuKey
	or	a, a
	jp	Z, .l00102
;src/editor/editor.c:1615: font = editor_font;
	ld	hl, sp+0
	ld	a, [hl]
	ld	hl, _font
	ld	[hl], a
;src/editor/editor.c:1616: SetFont(font);
	ld	a, [hl]
	call	_SetFont
;src/editor/editor.c:1617: render_text = 1;
	ld	hl, _render_text
	ld	[hl], $01
;src/editor/editor.c:1618: EndFullScreen();
	inc	sp
	jp	_EndFullScreen
.l00107:
;src/editor/editor.c:1619: }
	inc	sp
	ret
;src/editor/editor.c:1623: static char* PutHex(char* dest, unsigned char n) {
;	---------------------------------
	SECTION FRAGMENT "Page 13",ROMX,BANK[6]
	LOAD FRAGMENT "Page 13 RAM",SRAM,BANK[13]
; Function PutHex
; ---------------------------------
_PutHex:
	dec	sp
	ld	c, e
	ld	b, d
	ld	hl, sp+0
	ld	[hl], a
;src/editor/editor.c:1624: unsigned char digit = n >> 4;
	ld	a, [hl]
	swap	a
	and	a, $0F
;src/editor/editor.c:1625: *dest++ = digit < 10 ? '0' + digit : 'A' - 10 + digit;
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
;src/editor/editor.c:1626: digit = n & 15;
	ld	hl, sp+0
	ld	a, [hl]
	and	a, $0F
;src/editor/editor.c:1627: *dest++ = digit < 10 ? '0' + digit : 'A' - 10 + digit;
	ld	e, c
	ld	d, b
	inc	bc
;src/editor/editor.c:1625: *dest++ = digit < 10 ? '0' + digit : 'A' - 10 + digit;
	ld	l, a
;	spillPairReg hl
;	spillPairReg hl
;src/editor/editor.c:1627: *dest++ = digit < 10 ? '0' + digit : 'A' - 10 + digit;
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
;src/editor/editor.c:1628: return dest;
.l00101:
;src/editor/editor.c:1629: }
	inc	sp
	ret
;src/editor/editor.c:1638: static void KeyboardTest(void) {
;	---------------------------------
	SECTION FRAGMENT "Page 13",ROMX,BANK[6]
	LOAD FRAGMENT "Page 13 RAM",SRAM,BANK[13]
; Function KeyboardTest
; ---------------------------------
_KeyboardTest:
	add	sp, -79
;src/editor/editor.c:1639: unsigned char codes[TEST_CODES], errors[TEST_CODES], read = kb_buffer_write, count = 0, boot = kb_type;
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
;src/editor/editor.c:1640: unsigned char row, i, bit, editor_font = font, bytes = kb_interrupt_count, errors_seen = kb_error_count;
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
;src/editor/editor.c:1643: font = FONT_VWF;
	ld	hl, _font
	ld	[hl], $01
;src/editor/editor.c:1644: SetFont(font);
	ld	a, $01
	call	_SetFont
;src/editor/editor.c:1645: render_text = 0;
	ld	hl, _render_text
	ld	[hl], $00
;src/editor/editor.c:1646: BeginFullScreen();
	call	_BeginFullScreen__far
;src/editor/editor.c:1647: ClearScreen();
	call	_ClearScreen__far
;src/editor/editor.c:1648: KBListen();
	call	_KBListen
;src/editor/editor.c:1649: DrawRow(0, 0, "KEYBOARD TEST");
	ld	de, ___src_editor_editor_c_str_83
	push	de
	ld	e, $00
	xor	a, a
	call	_DrawRow__far
;src/editor/editor.c:1650: DrawRow(1, 0, boot == 1 ? "Found at boot: PS/2" : boot ? "Found at boot: iGKB" : "Found at boot: none, listening anyway");
	ld	hl, sp+78
	ld	a, [hl]
	dec	a
	jp	NZ,.l00262
	jp	.l00263
.l00262:
	jp	.l00137
.l00263:
	ld	de, ___src_editor_editor_c_str_84+0
	jp	.l00138
.l00137:
	ld	hl, sp+78
	ld	a, [hl]
	or	a, a
	jp	Z, .l00139
	ld	de, ___src_editor_editor_c_str_85+0
	dec	hl
	ld	[hl], e
	inc	hl
	ld	[hl], d
	jp	.l00140
.l00139:
	ld	de, ___src_editor_editor_c_str_86+0
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
;src/editor/editor.c:1651: DrawRow(4, 0, "Scan codes (newest last):");
	ld	de, ___src_editor_editor_c_str_87
	push	de
	ld	e, $00
	ld	a, $04
	call	_DrawRow__far
;src/editor/editor.c:1652: DrawRow(TB_ROWS - 1, 0, "B or Start  back");
	ld	de, ___src_editor_editor_c_str_88
	push	de
	ld	e, $00
	ld	a, $11
	call	_DrawRow__far
;src/editor/editor.c:1653: while (1) {
.l00124:
;src/editor/editor.c:1654: end = PutText(text, "Bytes ");
	ld	bc, ___src_editor_editor_c_str_89
	ld	hl, 22
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_PutText__far
;src/editor/editor.c:1655: end = PutNumber(end, (unsigned char)(kb_interrupt_count - bytes));
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
;src/editor/editor.c:1656: end = PutText(end, "   with errors ");
	ld	bc, ___src_editor_editor_c_str_90
	call	_PutText__far
;src/editor/editor.c:1657: end = PutNumber(end, (unsigned char)(kb_error_count - errors_seen));
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
;src/editor/editor.c:1658: *end = 0;
	xor	a, a
	ld	[bc], a
;src/editor/editor.c:1659: DrawRow(2, 0, text);
	ld	hl, 22
	add	hl, sp
	push	hl
	ld	e, $00
	ld	a, $02
	call	_DrawRow__far
;src/editor/editor.c:1660: if (read != kb_buffer_write) {
	ld	hl, sp+62
	ld	a, [hl]
	ld	hl, _kb_buffer_write
	sub	a, [hl]
	jp	NZ,.l00264
	jp	.l00162
.l00264:
;src/editor/editor.c:1661: while (read != kb_buffer_write) {
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
;src/editor/editor.c:1662: for (i = 1; i < TEST_CODES; ++i) codes[i - 1] = codes[i], errors[i - 1] = errors[i];
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
;src/editor/editor.c:1663: codes[TEST_CODES - 1] = kb_scan_code_buffer[read];
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
;src/editor/editor.c:1664: errors[TEST_CODES - 1] = kb_error_buffer[read];
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
;src/editor/editor.c:1665: read = (read + 1) & 63;
	ld	hl, sp+62
	ld	a, [hl]
	inc	a
	and	a, $3F
	ld	[hl], a
;src/editor/editor.c:1666: if (count < TEST_CODES) ++count;
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
;src/editor/editor.c:1668: for (i = 0; i < count; ++i) {
	ld	hl, sp+77
	ld	[hl], $00
.l00133:
	ld	hl, sp+77
	ld	a, [hl]
	ld	hl, sp+63
	sub	a, [hl]
	jp	NC, .l00162
;src/editor/editor.c:1669: row = TEST_CODES - count + i;
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
;src/editor/editor.c:1670: end = PutHex(text, codes[row]);
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
	call	_PutHex
	pop	de
;src/editor/editor.c:1671: *end++ = ' ';
	ld	a, $20
	ld	[bc], a
	inc	bc
;src/editor/editor.c:1672: for (bit = 0x80; bit; bit >>= 1) *end++ = codes[row] & bit ? '1' : '0';
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
;src/editor/editor.c:1673: for (bit = 0; bit < 6; ++bit) if (errors[row] & (1 << bit) && test_errors[bit][0]) *end++ = ' ', end = PutText(end, test_errors[bit]);
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
	ld	hl, _test_errors
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
;src/editor/editor.c:1674: *end = 0;
	ld	hl, sp+69
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	ld	[hl], $00
;src/editor/editor.c:1675: DrawRow(TEST_FIRST + TEST_CODES - count + i, 0, text);
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
;src/editor/editor.c:1668: for (i = 0; i < count; ++i) {
	ld	hl, sp+77
	inc	[hl]
	jp	.l00133
;src/editor/editor.c:1678: while ((event = KBPopEvent())) {
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
;src/editor/editor.c:1679: end = PutText(text, "Key ");
	ld	bc, ___src_editor_editor_c_str_91
	ld	hl, 22
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_PutText__far
;src/editor/editor.c:1680: end = PutHex(end, (unsigned char)event);
	ld	hl, sp+74
	ld	a, [hl]
	inc	hl
	inc	hl
	ld	[hl], a
	ld	a, [hl]
	ld	e, c
	ld	d, b
	call	_PutHex
	ld	hl, sp+77
	ld	[hl], c
	inc	hl
	ld	[hl], b
;src/editor/editor.c:1681: if ((unsigned char)event >= ' ' && (unsigned char)event < KEY_LEFT) *end++ = ' ', *end++ = (unsigned char)event;
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
;src/editor/editor.c:1682: end = PutText(end, "   modifiers ");
	ld	bc, ___src_editor_editor_c_str_92
	ld	hl, sp+77
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_PutText__far
;src/editor/editor.c:1683: end = PutHex(end, event >> 8);
	ld	hl, sp+75
	ld	e, [hl]
	ld	a, e
	ld	e, c
	ld	d, b
	call	_PutHex
;src/editor/editor.c:1684: *end = 0;
	xor	a, a
	ld	[bc], a
;src/editor/editor.c:1685: DrawRow(3, 0, text);
	ld	hl, 22
	add	hl, sp
	push	hl
	ld	e, $00
	ld	a, $03
	call	_DrawRow__far
	jp	.l00118
.l00120:
;src/editor/editor.c:1687: EditorDraw();
	call	_EditorDraw
;src/editor/editor.c:1688: WaitFrame();
	call	_WaitFrame
;src/editor/editor.c:1689: if (PadPressed() & (PADF_B | PADF_START)) break;
	call	_PadPressed
	and	a, $0A
	jp	NZ,.l00268
	jp	.l00124
.l00268:
;src/editor/editor.c:1691: font = editor_font;
	ld	hl, sp+64
	ld	a, [hl]
	ld	hl, _font
	ld	[hl], a
;src/editor/editor.c:1692: SetFont(font);
	ld	a, [hl]
	call	_SetFont
;src/editor/editor.c:1693: render_text = 1;
	ld	hl, _render_text
	ld	[hl], $01
;src/editor/editor.c:1694: EndFullScreen();
	call	_EndFullScreen__far
.l00135:
;src/editor/editor.c:1695: }
	add	sp, 79
	ret
	SECTION FRAGMENT "Page 13",ROMX,BANK[6]
	LOAD FRAGMENT "Page 13 RAM",SRAM,BANK[13]
_test_errors:
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
	SECTION FRAGMENT "src/editor/editor.c FIXED",ROMX,BANK[1]
___src_editor_editor_c_str_83:
	DB "KEYBOARD TEST"
	DB $00
	SECTION FRAGMENT "src/editor/editor.c FIXED",ROMX,BANK[1]
___src_editor_editor_c_str_84:
	DB "Found at boot: PS/2"
	DB $00
	SECTION FRAGMENT "src/editor/editor.c FIXED",ROMX,BANK[1]
___src_editor_editor_c_str_85:
	DB "Found at boot: iGKB"
	DB $00
	SECTION FRAGMENT "src/editor/editor.c FIXED",ROMX,BANK[1]
___src_editor_editor_c_str_86:
	DB "Found at boot: none, listening anyway"
	DB $00
	SECTION FRAGMENT "src/editor/editor.c FIXED",ROMX,BANK[1]
___src_editor_editor_c_str_87:
	DB "Scan codes (newest last):"
	DB $00
	SECTION FRAGMENT "src/editor/editor.c FIXED",ROMX,BANK[1]
___src_editor_editor_c_str_88:
	DB "B or Start  back"
	DB $00
	SECTION FRAGMENT "src/editor/editor.c FIXED",ROMX,BANK[1]
___src_editor_editor_c_str_89:
	DB "Bytes "
	DB $00
	SECTION FRAGMENT "src/editor/editor.c FIXED",ROMX,BANK[1]
___src_editor_editor_c_str_90:
	DB "   with errors "
	DB $00
	SECTION FRAGMENT "src/editor/editor.c FIXED",ROMX,BANK[1]
___src_editor_editor_c_str_91:
	DB "Key "
	DB $00
	SECTION FRAGMENT "src/editor/editor.c FIXED",ROMX,BANK[1]
___src_editor_editor_c_str_92:
	DB "   modifiers "
	DB $00
;src/editor/editor.c:1698: static void ClockSetup(void) {
;	---------------------------------
	SECTION FRAGMENT "Page 6",ROMX,BANK[3]
	LOAD FRAGMENT "Page 6 RAM",SRAM,BANK[6]
; Function ClockSetup
; ---------------------------------
_ClockSetup:
	add	sp, -16
;src/editor/editor.c:1700: unsigned char selected = 0, i, key, *value = (unsigned char*)&date;
	ld	hl, sp+8
	ld	[hl], $00
;src/editor/editor.c:1702: if (ClockRead(&date)) { date.year = 26; date.month = date.day = 1; date.hour = date.minute = date.second = 0; }
	ld	hl, 2
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_ClockRead
	or	a, a
	jp	Z, .l00102
	ld	hl, sp+2
	ld	[hl], $1A
	inc	hl
	inc	hl
	ld	[hl], $01
	dec	hl
	ld	[hl], $01
	ld	hl, sp+7
	ld	[hl], $00
	dec	hl
	ld	[hl], $00
	dec	hl
	ld	[hl], $00
.l00102:
;src/editor/editor.c:1703: DrawRow(STATUS_LINE, 1, "Left/right: adjust  A: set  B: cancel");
	ld	de, ___src_editor_editor_c_str_98
	push	de
	ld	e, $01
	ld	a, $13
	call	_DrawRow
;src/editor/editor.c:1704: while (1) {
.l00131:
;src/editor/editor.c:1705: line = RowAddress(BOX_LINE);
	ld	a, $14
	call	_RowAddress
	ld	hl, sp+13
	ld	[hl], c
	inc	hl
	ld	[hl], b
;src/editor/editor.c:1706: for (i = 0; i < 6; ++i, line += BOX_STRIDE) {
	inc	hl
	ld	[hl], $00
.l00133:
;src/editor/editor.c:1707: end = PutText(line, " ");
	ld	bc, ___src_editor_editor_c_str_99
	ld	hl, sp+13
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_PutText__far
	ld	hl, sp+11
	ld	[hl], c
	inc	hl
	ld	[hl], b
	ld	hl, sp+11
	ld	a, [hl]
	dec	hl
	dec	hl
	ld	[hl], a
	ld	hl, sp+12
	ld	a, [hl]
	dec	hl
	dec	hl
	ld	[hl], a
;src/editor/editor.c:1708: end = PutText(end, clock_fields[i]); *end++ = ' ';
	ld	hl, sp+15
	ld	a, [hl]
	ld	hl, sp+11
	ld	[hl], a
	inc	hl
	ld	[hl], $00
	dec	hl
	ld	a, [hl]
	ld	hl, sp+0
	ld	[hl], a
	ld	hl, sp+12
	ld	a, [hl]
	ld	hl, sp+1
	ld	[hl], a
	ld	a, $03
.l00280:
	ld	hl, sp+0
	sla	[hl]
	inc	hl
	rl	[hl]
	dec	a
	jp	NZ, .l00280
	pop	de
	push	de
	ld	hl, _clock_fields
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+13
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+12
	ld	[hl], a
	dec	hl
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	ld	hl, sp+9
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_PutText__far
	ld	a, $20
	ld	[bc], a
	inc	bc
	ld	hl, sp+9
	ld	[hl], c
	inc	hl
	ld	[hl], b
;src/editor/editor.c:1709: if (!i) end = PutNumber(end, 2000 + value[i]); else end = PutNumber2(end, value[i]);
	push	hl
	ld	hl, 4
	add	hl, sp
	ld	e, l
	ld	d, h
	pop	hl
	ld	hl, sp+15
	ld	l, [hl]
	ld	h, $00
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, [bc]
	ld	hl, sp+12
	ld	[hl], a
	ld	hl, sp+15
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00104
	ld	hl, sp+12
	ld	c, [hl]
	ld	b, $00
	ld	hl, $07D0
	add	hl, bc
	ld	a, h
	rlca
	sbc	a, a
	ld	c, a
	ld	b, a
	push	bc
	push	hl
	ld	hl, sp+13
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_PutNumber__far
	jp	.l00105
.l00104:
	ld	hl, sp+12
	ld	a, [hl]
	dec	hl
	ld	[hl], a
	inc	hl
	ld	[hl], $00
	dec	hl
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	ld	hl, sp+9
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_PutNumber2__far
.l00105:
;src/editor/editor.c:1710: *end = 0;
	xor	a, a
	ld	[bc], a
;src/editor/editor.c:1706: for (i = 0; i < 6; ++i, line += BOX_STRIDE) {
	ld	hl, sp+15
	inc	[hl]
	dec	hl
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $0014
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+15
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+14
	ld	[hl], a
	inc	hl
	ld	a, [hl]
	sub	a, $06
	jp	C, .l00133
;src/editor/editor.c:1712: OpenBox(6); render_box_sel = selected + 1; EditorDraw();
	ld	a, $06
	call	_OpenBox
	ld	hl, sp+8
	ld	e, [hl]
	ld	a, e
	inc	a
	ld	hl, sp+15
	ld	[hl], a
	ld	a, [hl]
	ld	hl, _render_box_sel
	ld	[hl], a
	push	de
	call	_EditorDraw
	pop	de
;src/editor/editor.c:1713: while (!(key = MenuKey()));
.l00107:
	push	de
	call	_MenuKey
	pop	de
	ld	c, a
	or	a, a
	jp	Z, .l00107
;src/editor/editor.c:1714: if (key == KEY_ESCAPE || key == KEY_MENU) break;
	ld	a, c
	sub	a, $1B
	jp	NZ,.l00281
	jp	.l00132
.l00281:
	ld	a, c
	sub	a, $89
	jp	NZ,.l00282
	jp	.l00132
.l00282:
;src/editor/editor.c:1715: if (key == KEY_UP) selected = selected ? selected - 1 : 5;
	ld	a, c
	sub	a, $82
	jp	NZ,.l00283
	jp	.l00284
.l00283:
	jp	.l00128
.l00284:
	ld	hl, sp+8
	ld	a, [hl]
	or	a, a
	jp	Z, .l00137
	ld	a, e
	dec	a
	ld	c, a
	rlca
	sbc	a, a
	ld	b, a
	jp	.l00138
.l00137:
	ld	bc, $0005
.l00138:
	ld	hl, sp+8
	ld	[hl], c
	jp	.l00131
.l00128:
;src/editor/editor.c:1716: else if (key == KEY_DOWN) selected = selected == 5 ? 0 : selected + 1;
	ld	a, c
	sub	a, $83
	jp	NZ,.l00285
	jp	.l00286
.l00285:
	jp	.l00125
.l00286:
	ld	hl, sp+8
	ld	a, [hl]
	sub	a, $05
	jp	NZ,.l00287
	jp	.l00288
.l00287:
	jp	.l00139
.l00288:
	ld	c, $00
	xor	a, a
	jp	.l00140
.l00139:
	ld	hl, sp+15
	ld	a, [hl]
	ld	c, a
	rlca
	sbc	a, a
.l00140:
	ld	hl, sp+8
	ld	[hl], c
	jp	.l00131
.l00125:
;src/editor/editor.c:1717: else if (key == KEY_LEFT || key == KEY_RIGHT) {
	ld	a, c
	sub	a, $80
	jp	NZ,.l00289
	ld	a,$01
	jp	.l00290
.l00289:
	xor	a,a
.l00290:
	ld	hl, sp+13
	ld	[hl], a
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00120
	ld	a, c
	sub	a, $81
	jp	NZ,.l00291
	jp	.l00292
.l00291:
	jp	.l00121
.l00292:
.l00120:
;src/editor/editor.c:1718: unsigned char low = selected == 1 || selected == 2 ? 1 : 0;
	ld	hl, sp+8
	ld	a, [hl]
	dec	a
	jp	NZ,.l00293
	ld	a,$01
	jp	.l00294
.l00293:
	xor	a,a
.l00294:
	ld	b, a
	ld	hl, sp+8
	ld	a, [hl]
	sub	a, $02
	jp	NZ,.l00295
	ld	a,$01
	jp	.l00296
.l00295:
	xor	a,a
.l00296:
	ld	c, a
	bit	0, b
	jp	NZ, .l00144
	bit	0, c
	jp	Z, .l00141
.l00144:
	ld	de, $0001
	jp	.l00142
.l00141:
	ld	de, $0000
.l00142:
	ld	hl, sp+14
	ld	[hl], e
;src/editor/editor.c:1719: unsigned char high = !selected ? 99 : selected == 1 ? 12 : selected == 2 ? 31 : selected == 3 ? 23 : 59;
	ld	hl, sp+8
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00146
	ld	bc, $0063
	jp	.l00147
.l00146:
	ld	a, b
	or	a, a
	jp	Z, .l00148
	ld	bc, $000C
	jp	.l00149
.l00148:
	ld	a, c
	or	a, a
	jp	Z, .l00150
	ld	bc, $001F
	jp	.l00151
.l00150:
	ld	hl, sp+8
	ld	a, [hl]
	sub	a, $03
	jp	NZ,.l00297
	jp	.l00298
.l00297:
	jp	.l00152
.l00298:
	ld	hl, sp+11
	ld	[hl], $17
	xor	a, a
	inc	hl
	ld	[hl], a
	jp	.l00153
.l00152:
	ld	hl, sp+11
	ld	[hl], $3B
	xor	a, a
	inc	hl
	ld	[hl], a
.l00153:
	ld	hl, sp+11
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
.l00151:
.l00149:
.l00147:
;src/editor/editor.c:1720: if (key == KEY_LEFT) value[selected] = value[selected] == low ? high : value[selected] - 1;
	push	hl
	ld	hl, 4
	add	hl, sp
	ld	e, l
	ld	d, h
	pop	hl
	ld	hl, sp+8
	ld	l, [hl]
	ld	h, $00
	add	hl, de
	ld	e, l
	ld	d, h
	ld	a, [de]
	ld	b, a
	ld	hl, sp+15
	ld	[hl], b
	dec	hl
	dec	hl
	ld	a, [hl]
	or	a, a
	jp	Z, .l00114
	inc	hl
	ld	a, [hl]
	sub	a, b
	jp	NZ,.l00299
	jp	.l00300
.l00299:
	jp	.l00154
.l00300:
	ld	a, c
	jp	.l00155
.l00154:
	ld	hl, sp+15
	ld	a, [hl]
	dec	a
.l00155:
	ld	[de], a
	jp	.l00131
.l00114:
;src/editor/editor.c:1721: else value[selected] = value[selected] == high ? low : value[selected] + 1;
	ld	a, c
	sub	a, b
	jp	NZ,.l00301
	jp	.l00302
.l00301:
	jp	.l00156
.l00302:
	ld	hl, sp+14
	ld	a, [hl]
	jp	.l00157
.l00156:
	ld	hl, sp+15
	ld	a, [hl]
	inc	a
.l00157:
	ld	[de], a
	jp	.l00131
.l00121:
;src/editor/editor.c:1723: else if (key == KEY_ENTER) {
	ld	a, c
	sub	a, $0A
	jp	NZ,.l00303
	jp	.l00304
.l00303:
	jp	.l00131
.l00304:
;src/editor/editor.c:1724: if (!ClockWrite(&date)) break;
	ld	hl, 2
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_ClockWrite
	or	a, a
	jp	Z, .l00132
;src/editor/editor.c:1725: ShowMessage("Invalid date or clock unavailable");
	ld	de, ___src_editor_editor_c_str_100
	call	_ShowMessage
	jp	.l00131
.l00132:
;src/editor/editor.c:1728: HideBox(); bars_changed = 1; dirty = 1;
	call	_HideBox
	ld	hl, _bars_changed
	ld	[hl], $01
	ld	hl, _dirty
	ld	[hl], $01
.l00135:
;src/editor/editor.c:1729: }
	add	sp, 16
	ret
	SECTION FRAGMENT "src/editor/editor.c FIXED",ROMX,BANK[1]
_clock_fields:
	DB "Year"
	DB $00
	DB $00
	DB $00
	DB $00
	DB "Month"
	DB $00
	DB $00
	DB $00
	DB "Day"
	DB $00
	DB $00
	DB $00
	DB $00
	DB $00
	DB "Hour"
	DB $00
	DB $00
	DB $00
	DB $00
	DB "Minute"
	DB $00
	DB $00
	DB "Second"
	DB $00
	DB $00
	SECTION FRAGMENT "src/editor/editor.c FIXED",ROMX,BANK[1]
___src_editor_editor_c_str_98:
	DB "Left/right: adjust  A: set  B: cancel"
	DB $00
	SECTION FRAGMENT "src/editor/editor.c FIXED",ROMX,BANK[1]
___src_editor_editor_c_str_99:
	DB " "
	DB $00
	SECTION FRAGMENT "src/editor/editor.c FIXED",ROMX,BANK[1]
___src_editor_editor_c_str_100:
	DB "Invalid date or clock unavailable"
	DB $00
;src/editor/editor.c:1731: static void FileMenu(void) {
;	---------------------------------
	SECTION FRAGMENT "Page 4",ROMX,BANK[2]
	LOAD FRAGMENT "Page 4 RAM",SRAM,BANK[4]
; Function FileMenu
; ---------------------------------
_FileMenu:
;src/editor/editor.c:1732: unsigned char menu = 0, item;
	ld	c, $00
;src/editor/editor.c:1733: while (1) {
.l00110:
;src/editor/editor.c:1734: if ((menu = Choose(0, menu_items[0], 5, menu)) >= BACK) return;
	ld	a, c
	push	af
	inc	sp
	ld	a, $05
	push	af
	inc	sp
	ld	bc, _menu_items
	ld	de, $0000
	call	_Choose
	ld	c, a
	sub	a, $FE
	jp	C, .l00102
	jp	.l00128
.l00102:
;src/editor/editor.c:1735: if (menu == 4) {
	ld	a, c
	sub	a, $04
	jp	NZ,.l00165
	jp	.l00166
.l00165:
	jp	.l00104
.l00166:
;src/editor/editor.c:1736: OpenFile();
	jp	_OpenFile
;src/editor/editor.c:1737: return;
	jp	.l00128
.l00104:
;src/editor/editor.c:1739: item = submenu_starts[menu];
	ld	hl, _submenu_starts
	ld	b, $00
	add	hl, bc
	ld	l, [hl]
;	spillPairReg hl
;src/editor/editor.c:1740: if ((item = Choose(0, submenu_items[item], submenu_starts[menu + 1] - item, 0)) == CANCEL) return;
	ld	a, c
	inc	a
	push	af
	rlca
	sbc	a, a
	ld	b, a
	pop	af
	add	a, LOW(_submenu_starts)
	ld	e, a
	ld	a, b
	adc	a, HIGH(_submenu_starts)
	ld	d, a
	ld	a, [de]
	sub	a, l
	ld	b, a
	ld	e, l
	ld	d, $00
	ld	l, e
	ld	h, d
	add	hl, hl
	add	hl, de
	add	hl, hl
	add	hl, de
	add	hl, hl
	ld	de, _submenu_items
	add	hl, de
	push	bc
	xor	a, a
	push	af
	inc	sp
	push	bc
	inc	sp
	ld	c, l
	ld	b, h
	ld	de, $0000
	call	_Choose
	pop	bc
	ld	e, a
	inc	a
	jp	NZ,.l00167
	jp	.l00168
.l00167:
	jp	.l00106
.l00168:
	jp	.l00128
.l00106:
;src/editor/editor.c:1741: if (item != BACK) break;
	ld	a, e
	sub	a, $FE
	jp	NZ,.l00169
	jp	.l00110
.l00169:
;src/editor/editor.c:1743: switch ((menu << 3) | item) {
	ld	l, c
;	spillPairReg hl
;	spillPairReg hl
	ld	h, $00
;	spillPairReg hl
;	spillPairReg hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	ld	a, l
	ld	d, $00
	or	a, e
	ld	c, a
	ld	a, h
	or	a, d
	ld	b, a
	bit	7, b
	jp	NZ, .l00128
	ld	a, b
	ld	e, a
	ld	a, $00
	ld	d, a
	ld	a, $19
	cp	a, c
	ld	a, $00
	sbc	a, b
	bit	7, e
	jp	Z, .l00170
	bit	7, d
	jp	NZ, .l00171
	cp	a, a
	jp	.l00171
.l00170:
	bit	7, d
	jp	Z, .l00171
	scf
.l00171:
	jp	C, .l00128
	ld	b, $00
	ld	hl, .l00172
	add	hl, bc
	add	hl, bc
	add	hl, bc
	jp	hl
.l00172:
	jp	.l00112
	jp	.l00113
	jp	.l00114
	jp	.l00115
	jp	.l00128
	jp	.l00128
	jp	.l00128
	jp	.l00128
	jp	.l00116
	jp	.l00117
	jp	.l00118
	jp	.l00119
	jp	.l00120
	jp	.l00121
	jp	.l00128
	jp	.l00128
	jp	.l00122
	jp	.l00123
	jp	.l00124
	jp	.l00128
	jp	.l00128
	jp	.l00128
	jp	.l00128
	jp	.l00128
	jp	.l00125
	jp	.l00126
;src/editor/editor.c:1744: case 0: OpenFile(); break;
.l00112:
	jp	_OpenFile
	jp	.l00128
;src/editor/editor.c:1745: case 1: SaveFile(0); break;
.l00113:
	xor	a, a
	jp	_SaveFile
	jp	.l00128
;src/editor/editor.c:1746: case 2: SaveFile(1); break;
.l00114:
	ld	a, $01
	jp	_SaveFile
	jp	.l00128
;src/editor/editor.c:1747: case 3: NewFile(); break;
.l00115:
	jp	_NewFile
	jp	.l00128
;src/editor/editor.c:1748: case 8: UndoRedo(0); break;
.l00116:
	xor	a, a
	jp	_UndoRedo__far
	jp	.l00128
;src/editor/editor.c:1749: case 9: UndoRedo(1); break;
.l00117:
	ld	a, $01
	jp	_UndoRedo__far
	jp	.l00128
;src/editor/editor.c:1750: case 10: Cut(); break;
.l00118:
	jp	_Cut__far
	jp	.l00128
;src/editor/editor.c:1751: case 11: Copy(); break;
.l00119:
	jp	_Copy__far
	jp	.l00128
;src/editor/editor.c:1752: case 12: Paste(); break;
.l00120:
	jp	_Paste__far
	jp	.l00128
;src/editor/editor.c:1753: case 13: SelectAll(); break;
.l00121:
	jp	_SelectAll__far
	jp	.l00128
;src/editor/editor.c:1754: case 16: ToggleWrap(); break;
.l00122:
	jp	_ToggleWrap__far
	jp	.l00128
;src/editor/editor.c:1755: case 17: ToggleBars(); break;
.l00123:
	jp	_ToggleBars__far
	jp	.l00128
;src/editor/editor.c:1756: case 18: ClockSetup(); break;
.l00124:
	jp	_ClockSetup__far
	jp	.l00128
;src/editor/editor.c:1757: case 24: ShowHelp(); break;
.l00125:
	jp	_ShowHelp__far
	jp	.l00128
;src/editor/editor.c:1758: case 25: KeyboardTest(); break;
.l00126:
	jp	_KeyboardTest__far
;src/editor/editor.c:1759: }
.l00128:
;src/editor/editor.c:1760: }
	ret
;src/editor/editor.c:1763: static unsigned char HandleFileKey(unsigned char key, unsigned char mods) {
;	---------------------------------
	SECTION FRAGMENT "Page 4",ROMX,BANK[2]
	LOAD FRAGMENT "Page 4 RAM",SRAM,BANK[4]
; Function HandleFileKey
; ---------------------------------
_HandleFileKey:
	ld	c, a
;src/editor/editor.c:1764: if (key == KEY_MENU || key == KEY_ESCAPE) FileMenu();
	ld	a, c
	sub	a, $89
	jp	NZ,.l00178
	jp	.l00127
.l00178:
	ld	a, c
	sub	a, $1B
	jp	NZ,.l00179
	jp	.l00180
.l00179:
	jp	.l00128
.l00180:
.l00127:
	call	_FileMenu
	jp	.l00129
.l00128:
;src/editor/editor.c:1765: else if (key == KEY_F1) ShowHelp();
	ld	a, c
	sub	a, $90
	jp	NZ,.l00181
	jp	.l00182
.l00181:
	jp	.l00125
.l00182:
	call	_ShowHelp__far
	jp	.l00129
.l00125:
;src/editor/editor.c:1766: else if (key == KEY_F11) ToggleBars();
	ld	a, c
	sub	a, $9A
	jp	NZ,.l00183
	jp	.l00184
.l00183:
	jp	.l00122
.l00184:
	call	_ToggleBars__far
	jp	.l00129
.l00122:
;src/editor/editor.c:1767: else if ((mods & KB_MOD_ALT) && (key == 'z' || key == 'Z')) ToggleWrap();
	bit	4, e
	jp	NZ,.l00185
	jp	.l00117
.l00185:
	ld	a, c
	sub	a, $7A
	jp	NZ,.l00186
	jp	.l00116
.l00186:
	ld	a, c
	sub	a, $5A
	jp	NZ,.l00187
	jp	.l00188
.l00187:
	jp	.l00117
.l00188:
.l00116:
	call	_ToggleWrap__far
	jp	.l00129
.l00117:
;src/editor/editor.c:1768: else if (!(mods & KB_MOD_CTRL)) return 0;
	bit	5, e
	jp	NZ,.l00189
	jp	.l00190
.l00189:
	jp	.l00114
.l00190:
	xor	a, a
	jp	.l00131
.l00114:
;src/editor/editor.c:1769: else if (key == 'o' || key == 'O') OpenFile();
	ld	a, c
	sub	a, $6F
	jp	NZ,.l00191
	jp	.l00109
.l00191:
	ld	a, c
	sub	a, $4F
	jp	NZ,.l00192
	jp	.l00193
.l00192:
	jp	.l00110
.l00193:
.l00109:
	call	_OpenFile
	jp	.l00129
.l00110:
;src/editor/editor.c:1770: else if (key == 's' || key == 'S') SaveFile(0);
	ld	a, c
	sub	a, $73
	jp	NZ,.l00194
	jp	.l00105
.l00194:
	ld	a, c
	sub	a, $53
	jp	NZ,.l00195
	jp	.l00196
.l00195:
	jp	.l00106
.l00196:
.l00105:
	xor	a, a
	call	_SaveFile
	jp	.l00129
.l00106:
;src/editor/editor.c:1771: else if (key == 'n' || key == 'N') NewFile();
	ld	a, c
	sub	a, $6E
	jp	NZ,.l00197
	jp	.l00101
.l00197:
	ld	a, c
	sub	a, $4E
	jp	NZ,.l00198
	jp	.l00199
.l00198:
	jp	.l00102
.l00199:
.l00101:
	call	_NewFile
	jp	.l00129
.l00102:
;src/editor/editor.c:1772: else return 0;
	xor	a, a
	jp	.l00131
.l00129:
;src/editor/editor.c:1773: dirty = 1;
	ld	hl, _dirty
	ld	[hl], $01
;src/editor/editor.c:1774: return 1;
	ld	a, $01
.l00131:
;src/editor/editor.c:1775: }
	ret
;src/editor/editor.c:1777: static void Render(void) {
;	---------------------------------
	SECTION FRAGMENT "Page 5",ROMX,BANK[2]
	LOAD FRAGMENT "Page 5 RAM",SRAM,BANK[5]
; Function Render
; ---------------------------------
_Render:
;src/editor/editor.c:1778: tb_find = cursor;
	ld	hl, _cursor
	ld	a, [hl]
	ld	hl, _tb_find
	ld	[hl], a
	ld	hl, _cursor + 1
	ld	a, [hl]
	ld	hl, _tb_find + 1
	ld	[hl], a
;src/editor/editor.c:1779: tb_Render(top);
	ld	hl, _top
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	jp	_tb_Render
.l00101:
;src/editor/editor.c:1780: }
	ret
;src/editor/editor.c:1791: static unsigned char CharWidth(unsigned char c) {
;	---------------------------------
	SECTION FRAGMENT "Page 5",ROMX,BANK[2]
	LOAD FRAGMENT "Page 5 RAM",SRAM,BANK[5]
; Function CharWidth
; ---------------------------------
_CharWidth:
	ld	e, a
;src/editor/editor.c:1792: if (c < ' ') c = ' '; // control characters are drawn as spaces
	ld	a, e
	sub	a, $20
	jp	NC, .l00102
	ld	e, $20
.l00102:
;src/editor/editor.c:1793: if (code_line) return CODE_WIDTH;
	ld	hl, _code_line
	ld	a, [hl]
	or	a, a
	jp	Z, .l00104
	ld	a, $04
	jp	.l00105
.l00104:
;src/editor/editor.c:1794: return head_level ? HeadingCharWidth(head_level, c) : font_widths[c];
	ld	hl, _head_level
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
;src/editor/editor.c:1795: }
	ret
;src/editor/editor.c:1799: static void LineHeading(unsigned int start, unsigned char row) {
;	---------------------------------
	SECTION FRAGMENT "Page 5",ROMX,BANK[2]
	LOAD FRAGMENT "Page 5 RAM",SRAM,BANK[5]
; Function LineHeading
; ---------------------------------
_LineHeading:
	add	sp, -7
	ld	hl, sp+5
	ld	[hl], e
	inc	hl
	ld	[hl], d
	dec	hl
	dec	hl
	ld	[hl], a
;src/editor/editor.c:1800: unsigned int pos = start, length = tb_Length();
	call	_tb_Length
	pop	hl
	push	bc
;src/editor/editor.c:1801: head_level = 0;
	ld	hl, _head_level
	ld	[hl], $00
;src/editor/editor.c:1802: code_line = 0;
	ld	hl, _code_line
	ld	[hl], $00
;src/editor/editor.c:1803: if (tb_lang != LANG_MD) return;
	ld	hl, _tb_lang
	ld	a, [hl]
	dec	a
	jp	NZ,.l00196
	jp	.l00128
.l00196:
	jp	.l00122
;src/editor/editor.c:1804: while (pos < length && pos - start < 3 && tb_GetChar(pos) == '`') ++pos;
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
;src/editor/editor.c:1805: if (pos - start == 3 || (row != 0xFF && (tb_row_states[row] & MD_FENCE_STATE))) { code_line = 1; return; }
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
	ld	hl, _code_line
	ld	[hl], $01
	jp	.l00122
;src/editor/editor.c:1807: while (pos < length && pos - start < 7 && tb_GetChar(pos) == '#') ++pos;
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
;src/editor/editor.c:1808: if (pos == start || pos - start > 4 || pos == length || tb_GetChar(pos) != ' ') return;
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
;src/editor/editor.c:1809: head_level = (unsigned char)(pos - start);
	ld	a, c
	ld	hl, sp+5
	ld	c, [hl]
	sub	a, c
	ld	hl, _head_level
	ld	[hl], a
.l00122:
;src/editor/editor.c:1810: }
	add	sp, 7
	ret
;src/editor/editor.c:1814: static unsigned char ScrollX(void) {
;	---------------------------------
	SECTION FRAGMENT "Page 5",ROMX,BANK[2]
	LOAD FRAGMENT "Page 5 RAM",SRAM,BANK[5]
; Function ScrollX
; ---------------------------------
_ScrollX:
	add	sp, -9
;src/editor/editor.c:1815: unsigned char row = tb_found_row, count;
	ld	hl, _tb_found_row
	ld	a, [hl]
	ld	hl, sp+0
	ld	[hl], a
;src/editor/editor.c:1816: unsigned int start = row == 0xFF ? tb_LineStart(cursor) : tb_row_starts[row];
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
;src/editor/editor.c:1817: unsigned int col = cursor - start, length = tb_Length(), pos, x = 0, left;
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
;src/editor/editor.c:1818: unsigned char c, keep = KEEP_LEFT;
	inc	hl
	ld	[hl], $28
;src/editor/editor.c:1819: if (col < tb_left) keep = KEEP_RIGHT;
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
;src/editor/editor.c:1820: else if (row != 0xFF) { // its char is drawn, or it's the line's end right of its last one
	ld	hl, sp+8
	ld	e, [hl]
	bit	0, e
	jp	NZ, .l00111
;src/editor/editor.c:1821: count = tb_row_counts[row];
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
;src/editor/editor.c:1822: if (col - tb_left < count) return 0;
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
;src/editor/editor.c:1823: if (col - tb_left == count && cursor == LineEnd(row) && RenderCursorX(count) < TB_WIDTH - 1) return 0;
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
;src/editor/editor.c:1825: LineHeading(start, row);
	push	bc
	ld	hl, sp+2
	ld	a, [hl]
	inc	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_LineHeading
	pop	bc
;src/editor/editor.c:1826: if (keep == KEEP_LEFT) { // more if the line ends sooner, so the screen isn't left empty
	ld	hl, sp+5
	ld	a, [hl]
	sub	a, $28
	jp	NZ,.l00227
	jp	.l00228
.l00227:
	jp	.l00116
.l00228:
;src/editor/editor.c:1827: for (pos = cursor, x = 0; pos < length && (c = tb_GetChar(pos)) != ASCII_LF && x <= TB_WIDTH; ++pos) x += CharWidth(c);
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
;src/editor/editor.c:1828: if (x < TB_WIDTH - 1 - KEEP_LEFT) keep = TB_WIDTH - 1 - x;
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
;src/editor/editor.c:1830: for (left = col, x = 0; left; --left) {
	xor	a, a
	ld	hl, sp+3
	ld	[hl], a
	inc	hl
	ld	[hl], a
.l00128:
	ld	a, b
	or	a, c
	jp	Z, .l00119
;src/editor/editor.c:1831: if ((x += CharWidth(tb_GetChar(start + left - 1))) > keep) break;
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
;src/editor/editor.c:1830: for (left = col, x = 0; left; --left) {
	dec	bc
	jp	.l00128
.l00119:
;src/editor/editor.c:1833: if (left == tb_left) return 0;
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
;src/editor/editor.c:1834: tb_left = left;
	ld	hl, _tb_left
	ld	[hl], c
	inc	hl
	ld	[hl], b
;src/editor/editor.c:1835: return 1;
	ld	a, $01
.l00130:
;src/editor/editor.c:1836: }
	add	sp, 9
	ret
;src/editor/editor.c:1839: static void Refresh(void) {
;	---------------------------------
	SECTION FRAGMENT "Page 5",ROMX,BANK[2]
	LOAD FRAGMENT "Page 5 RAM",SRAM,BANK[5]
; Function Refresh
; ---------------------------------
_Refresh:
	add	sp, -3
;src/editor/editor.c:1842: if (top > tb_Length()) top = tb_Length();
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
;src/editor/editor.c:1843: top = tb_RowStart(top); // wrapping may have changed
	ld	hl, _top
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_tb_RowStart
	ld	hl, _top
	ld	[hl], c
	inc	hl
	ld	[hl], b
;src/editor/editor.c:1844: Render();
	call	_Render
;src/editor/editor.c:1845: if (tb_found_row == 0xFF) {
	ld	hl, _tb_found_row
	ld	a, [hl]
	inc	a
	jp	NZ,.l00209
	jp	.l00210
.l00209:
	jp	.l00119
.l00210:
;src/editor/editor.c:1846: row = tb_RowStart(cursor);
	ld	hl, _cursor
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_tb_RowStart
;src/editor/editor.c:1847: if (cursor < top) {
	ld	de, _cursor
	ld	hl, _top
	ld	a, [de]
	inc	de
	sub	a, [hl]
	inc	hl
	ld	a, [de]
	sbc	a, [hl]
	jp	NC, .l00116
;src/editor/editor.c:1848: if (top && row == tb_RowStart(top - 1)) ScrollRing(0); // one row up
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
;src/editor/editor.c:1849: top = row;
	ld	hl, _top
	ld	[hl], c
	inc	hl
	ld	[hl], b
	jp	.l00117
.l00116:
;src/editor/editor.c:1852: bottom = tb_row_starts[tb_rows];
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
;src/editor/editor.c:1853: for (i = tb_rows; i; --i) {
	ld	hl, _tb_rows
	ld	a, [hl]
	ld	hl, sp+2
	ld	[hl], a
.l00124:
	ld	hl, sp+2
	ld	a, [hl]
	or	a, a
	jp	Z, .l00108
;src/editor/editor.c:1854: top = tb_NextRow(top);
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
;src/editor/editor.c:1855: if (bottom == row) break;
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
;src/editor/editor.c:1856: bottom = tb_NextRow(bottom);
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
;src/editor/editor.c:1853: for (i = tb_rows; i; --i) {
	ld	hl, sp+2
	dec	[hl]
	jp	.l00124
.l00108:
;src/editor/editor.c:1858: if (!i) { // the cursor's row goes at the bottom
	ld	hl, sp+2
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00113
;src/editor/editor.c:1859: top = row;
	ld	hl, _top
	ld	[hl], c
	inc	hl
	ld	[hl], b
;src/editor/editor.c:1860: for (i = tb_rows - 1; i && top; --i) top = tb_RowStart(top - 1);
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
;src/editor/editor.c:1862: else if (i == tb_rows) ScrollRing(1); // one row down
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
;src/editor/editor.c:1864: Render();
	call	_Render
.l00119:
;src/editor/editor.c:1866: if (tb_nowrap && ScrollX()) Render();
	ld	hl, _tb_nowrap
	ld	a, [hl]
	or	a, a
	jp	Z, .l00121
	call	_ScrollX
	or	a, a
	jp	Z, .l00121
	call	_Render
.l00121:
;src/editor/editor.c:1867: Draw();
	call	_Draw
;src/editor/editor.c:1868: redraw = 0;
	ld	hl, _redraw
	ld	[hl], $00
;src/editor/editor.c:1869: moved = 0;
	ld	hl, _moved
	ld	[hl], $00
;src/editor/editor.c:1870: PlaceCursor();
	call	_PlaceCursor
.l00130:
;src/editor/editor.c:1871: }
	add	sp, 3
	ret
;src/editor/editor.c:1873: void Editor(void) {
;	---------------------------------
	SECTION FRAGMENT "Page 5",ROMX,BANK[2]
	LOAD FRAGMENT "Page 5 RAM",SRAM,BANK[5]
; Function Editor
; ---------------------------------
_Editor::
	add	sp, -4
;src/editor/editor.c:1877: FileBackupSave(); // the last game's save RAM, before anything else
	call	_FileBackupSave
;src/editor/editor.c:1878: if (!FileLoadData("/GBCSYS/EDITOR.DAT")) {
	ld	de, ___src_editor_editor_c_str_107
	call	_FileLoadData
	or	a, a
	jp	NZ, .l00102
;src/editor/editor.c:1879: data_loaded = 1;
	ld	hl, _data_loaded
	ld	[hl], $01
;src/editor/editor.c:1880: SGBSetDefaultBorder();
	call	_SGBSetDefaultBorder
.l00102:
;src/editor/editor.c:1882: FileLoadSwap(); // before EditorSetup's tb_Load
	call	_FileLoadSwap
;src/editor/editor.c:1883: EditorSetup();
	call	_EditorSetup
;src/editor/editor.c:1884: for (key = 0; key < BG_MAP_ROWS + WIN_MAP_ROWS; ++key) map_blocks[key] = key < TB_ROWS ? key : 0xFF; // set by RenderSetup
	ld	c, $00
.l00185:
	ld	hl, _map_blocks
	ld	b, $00
	add	hl, bc
	ld	a, c
	sub	a, $12
	jp	NC, .l00189
	ld	e, c
	ld	d, $00
	jp	.l00190
.l00189:
	ld	de, $00FF
.l00190:
	ld	[hl], e
	inc	c
	ld	a, c
	sub	a, $27
	jp	C, .l00185
;src/editor/editor.c:1885: everdrive = sd_Detect();
	call	_sd_Detect
	ld	hl, _everdrive
	ld	[hl], a
;src/editor/editor.c:1886: idle_frames = 0;
	ld	hl, _idle_frames
	ld	[hl], $00
;src/editor/editor.c:1887: normalized = 0;
	ld	hl, _normalized
	ld	[hl], $00
;src/editor/editor.c:1888: cursor = 0;
	xor	a, a
	ld	hl, _cursor
	ld	[hl], a
	inc	hl
	ld	[hl], a
;src/editor/editor.c:1889: top = 0;
	xor	a, a
	ld	hl, _top
	ld	[hl], a
	inc	hl
	ld	[hl], a
;src/editor/editor.c:1890: selecting = 0;
	ld	hl, _selecting
	ld	[hl], $00
;src/editor/editor.c:1891: want_x = 0;
	ld	hl, _want_x
	ld	[hl], $00
;src/editor/editor.c:1892: keep_x = 0;
	ld	hl, _keep_x
	ld	[hl], $00
;src/editor/editor.c:1893: moved = 0;
	ld	hl, _moved
	ld	[hl], $00
;src/editor/editor.c:1894: redraw = 0;
	ld	hl, _redraw
	ld	[hl], $00
;src/editor/editor.c:1895: ring_top = 0;
	ld	hl, _ring_top
	ld	[hl], $00
;src/editor/editor.c:1896: ring_pos = 0;
	ld	hl, _ring_pos
	ld	[hl], $00
;src/editor/editor.c:1897: counted_pos = 0;
	xor	a, a
	ld	hl, _counted_pos
	ld	[hl], a
	inc	hl
	ld	[hl], a
;src/editor/editor.c:1898: counted_lines = 0;
	xor	a, a
	ld	hl, _counted_lines
	ld	[hl], a
	inc	hl
	ld	[hl], a
;src/editor/editor.c:1899: bars_changed = 0;
	ld	hl, _bars_changed
	ld	[hl], $00
;src/editor/editor.c:1900: edited = 0;
	ld	hl, _edited
	ld	[hl], $00
;src/editor/editor.c:1901: pad_timer = 0;
	ld	hl, _pad_timer
	ld	[hl], $00
;src/editor/editor.c:1902: modified = 0;
	ld	hl, _modified
	ld	[hl], $00
;src/editor/editor.c:1903: font = FONT_VWF; // SetLang
	ld	hl, _font
	ld	[hl], $01
;src/editor/editor.c:1904: file_name[0] = 0;
	ld	hl, _file_name
	ld	[hl], $00
;src/editor/editor.c:1905: file_dir[0] = 0;
	ld	hl, _file_dir
	ld	[hl], $00
;src/editor/editor.c:1906: fs_crlf = 0;
	ld	hl, _fs_crlf
	ld	[hl], $00
;src/editor/editor.c:1907: osk_shown = 0;
	ld	hl, _osk_shown
	ld	[hl], $00
;src/editor/editor.c:1908: osk_layer = OSK_LOWER;
	ld	hl, _osk_layer
	ld	[hl], $00
;src/editor/editor.c:1909: osk_x = 0;
	ld	hl, _osk_x
	ld	[hl], $00
;src/editor/editor.c:1910: osk_y = 0;
	ld	hl, _osk_y
	ld	[hl], $00
;src/editor/editor.c:1911: bars_on = 1;
	ld	hl, _bars_on
	ld	[hl], $01
;src/editor/editor.c:1912: tb_nowrap = 0;
	ld	hl, _tb_nowrap
	ld	[hl], $00
;src/editor/editor.c:1913: tb_left = 0;
	xor	a, a
	ld	hl, _tb_left
	ld	[hl], a
	inc	hl
	ld	[hl], a
;src/editor/editor.c:1914: tb_lang = LANG_PLAIN;
	ld	hl, _tb_lang
	ld	[hl], $00
;src/editor/editor.c:1915: render_text = 1;
	ld	hl, _render_text
	ld	[hl], $01
;src/editor/editor.c:1916: SettingsLoad();
	call	_SettingsLoad
;src/editor/editor.c:1917: SetLang();
	call	_SetLang__far
;src/editor/editor.c:1918: UndoClear(modified);
	ld	hl, _modified
	ld	a, [hl]
	call	_UndoClear
;src/editor/editor.c:1919: saved_modified = modified;
	ld	hl, _modified
	ld	a, [hl]
	ld	hl, _saved_modified
	ld	[hl], a
;src/editor/editor.c:1920: SetFont(font);
	ld	hl, _font
	ld	a, [hl]
	call	_SetFont
;src/editor/editor.c:1921: SetRows();
	call	_SetRows
;src/editor/editor.c:1922: swap_dirty = 0; // the swap file has what booting restored
	ld	hl, _swap_dirty
	ld	[hl], $00
;src/editor/editor.c:1923: doc_large = 0;
	ld	hl, _doc_large
	ld	[hl], $00
;src/editor/editor.c:1924: if (backup_skipped) ShowMessage("SAVE NOT BACKED UP");
	ld	hl, _backup_skipped
	ld	a, [hl]
	or	a, a
	jp	Z, .l00105
	ld	de, ___src_editor_editor_c_str_108
	call	_ShowMessage__far
.l00105:
;src/editor/editor.c:1925: if (modified) Refresh();
	ld	hl, _modified
	ld	a, [hl]
	or	a, a
	jp	Z, .l00107
	call	_Refresh
	jp	.l00183
.l00107:
;src/editor/editor.c:1927: ClearScreen();
	call	_ClearScreen__far
;src/editor/editor.c:1928: EditorDraw();
	call	_EditorDraw
;src/editor/editor.c:1929: dirty = 1;
	ld	hl, _dirty
	ld	[hl], $01
;src/editor/editor.c:1930: OpenFile();
	call	_OpenFile__far
;src/editor/editor.c:1933: while (1) {
.l00183:
;src/editor/editor.c:1934: if (modified != saved_modified) {
	ld	hl, _modified
	ld	a, [hl]
	ld	hl, _saved_modified
	sub	a, [hl]
	jp	NZ,.l00432
	jp	.l00110
.l00432:
;src/editor/editor.c:1935: saved_modified = modified;
	ld	hl, _modified
	ld	a, [hl]
	ld	hl, _saved_modified
	ld	[hl], a
;src/editor/editor.c:1936: SettingsSave();
	call	_SettingsSave
.l00110:
;src/editor/editor.c:1938: if (bars_changed) { // status bar follows the cursor
	ld	hl, _bars_changed
	ld	a, [hl]
	or	a, a
	jp	Z, .l00114
;src/editor/editor.c:1939: bars_changed = 0;
	ld	[hl], $00
;src/editor/editor.c:1940: if (bars) Draw();
	ld	hl, _bars
	ld	a, [hl]
	or	a, a
	jp	Z, .l00114
	call	_Draw
.l00114:
;src/editor/editor.c:1942: WaitFrame();
	call	_WaitFrame
;src/editor/editor.c:1943: while ((key = (unsigned char)(event = KBPopEvent()))) {
.l00126:
	call	_KBPopEvent
	ld	e, c
	ld	d, b
	ld	a, c
	ld	c, a
	or	a, a
	jp	Z, .l00128
;src/editor/editor.c:1944: if (!HandleFileKey(key, (unsigned char)(event >> 8))) HandleKey(key, (unsigned char)(event >> 8));
	ld	l, d
;	spillPairReg hl
;	spillPairReg hl
	push	hl
	push	bc
	ld	e, l
	ld	a, c
	call	_HandleFileKey__far
	pop	bc
	pop	hl
	or	a, a
	jp	NZ, .l00116
	ld	e, l
	ld	a, c
	call	_HandleKey
.l00116:
;src/editor/editor.c:1945: if (doc_large) Slide(); // before the next key, which could reach the window's end
	ld	hl, _doc_large
	ld	a, [hl]
	or	a, a
	jp	Z, .l00118
	call	_Slide__far
.l00118:
;src/editor/editor.c:1946: if (dirty || edited) break; // text changed, rows need rendering before more keys
	ld	hl, _dirty
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00128
	ld	hl, _edited
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00128
;src/editor/editor.c:1947: if (moved) { // keeps tb_found_row current for the next key
	ld	hl, _moved
	ld	a, [hl]
	or	a, a
	jp	Z, .l00126
;src/editor/editor.c:1948: if (!PlaceCursor()) dirty = 1;
	call	_PlaceCursor
	or	a, a
	jp	NZ, .l00123
	ld	hl, _dirty
	ld	[hl], $01
.l00123:
;src/editor/editor.c:1949: moved = 0;
	ld	hl, _moved
	ld	[hl], $00
	jp	.l00126
.l00128:
;src/editor/editor.c:1952: if ((key = PadKey())) {
	call	_PadKey__far
	ld	c, a
	or	a, a
	jp	Z, .l00132
;src/editor/editor.c:1953: if (!HandleFileKey(key, pad_mods)) HandleKey(key, pad_mods);
	push	bc
	ld	hl, _pad_mods
	ld	e, [hl]
	ld	a, c
	call	_HandleFileKey__far
	pop	bc
	or	a, a
	jp	NZ, .l00132
	ld	hl, _pad_mods
	ld	e, [hl]
	ld	a, c
	call	_HandleKey
.l00132:
;src/editor/editor.c:1955: if (doc_large) Slide(); // near the window's edge (sets dirty)
	ld	hl, _doc_large
	ld	a, [hl]
	or	a, a
	jp	Z, .l00134
	call	_Slide__far
.l00134:
;src/editor/editor.c:1956: if (dirty || edited || redraw || moved) idle_frames = 0;
	ld	hl, _dirty
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00135
	ld	hl, _edited
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00135
	ld	hl, _redraw
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00135
	ld	hl, _moved
	ld	a, [hl]
	or	a, a
	jp	Z, .l00136
.l00135:
	ld	hl, _idle_frames
	ld	[hl], $00
.l00136:
;src/editor/editor.c:1957: if (dirty) {
	ld	hl, _dirty
	ld	a, [hl]
	or	a, a
	jp	Z, .l00141
;src/editor/editor.c:1958: Refresh();
	call	_Refresh
;src/editor/editor.c:1959: dirty = 0;
	ld	hl, _dirty
	ld	[hl], $00
;src/editor/editor.c:1960: edited = 0;
	ld	hl, _edited
	ld	[hl], $00
;src/editor/editor.c:1961: normalized = 0;
	ld	hl, _normalized
	ld	[hl], $00
;src/editor/editor.c:1962: continue;
	jp	.l00183
.l00141:
;src/editor/editor.c:1964: if (edited) {
	ld	hl, _edited
	ld	a, [hl]
	or	a, a
	jp	Z, .l00156
;src/editor/editor.c:1965: edited = 0;
	ld	[hl], $00
;src/editor/editor.c:1966: normalized = 0;
	ld	hl, _normalized
	ld	[hl], $00
;src/editor/editor.c:1967: RenderAfterEdit();
	call	_RenderAfterEdit
;src/editor/editor.c:1968: if (!PlaceCursor()) {
	call	_PlaceCursor
	or	a, a
	jp	NZ, .l00156
;src/editor/editor.c:1969: if (cursor >= tb_row_starts[tb_rows] && tb_RowStart(cursor) == tb_row_starts[tb_rows]) ScrollDown();
	ld	hl, _tb_rows
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
	ld	de, _cursor
	dec	hl
	ld	a, [de]
	inc	de
	sub	a, [hl]
	inc	hl
	ld	a, [de]
	sbc	a, [hl]
	jp	C, .l00148
	ld	hl, _cursor
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
	jp	NZ,.l00434
	ld	a, h
	sub	a, b
	jp	NZ,.l00434
	jp	.l00435
.l00434:
	jp	.l00148
.l00435:
	call	_ScrollDown
	jp	.l00149
.l00148:
;src/editor/editor.c:1970: else if (top && cursor < top && tb_RowStart(cursor) == tb_RowStart(top - 1)) ScrollUp(tb_RowStart(cursor));
	ld	hl, _top + 1
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	jp	Z, .l00143
	ld	de, _cursor
	ld	a, [de]
	inc	de
	sub	a, [hl]
	inc	hl
	ld	a, [de]
	sbc	a, [hl]
	jp	NC, .l00143
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
	jp	NZ,.l00436
	ld	a, d
	sub	a, b
	jp	NZ,.l00436
	jp	.l00437
.l00436:
	jp	.l00143
.l00437:
	ld	hl, _cursor
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_tb_RowStart
	ld	e, c
	ld	d, b
	call	_ScrollUp
	jp	.l00149
.l00143:
;src/editor/editor.c:1972: Refresh();
	call	_Refresh
;src/editor/editor.c:1973: continue;
	jp	.l00183
.l00149:
;src/editor/editor.c:1975: if (!PlaceCursor()) { // off the side
	call	_PlaceCursor
	or	a, a
	jp	NZ, .l00156
;src/editor/editor.c:1976: Refresh();
	call	_Refresh
;src/editor/editor.c:1977: continue;
	jp	.l00183
.l00156:
;src/editor/editor.c:1981: if (redraw) {
	ld	hl, _redraw
	ld	a, [hl]
	or	a, a
	jp	Z, .l00158
;src/editor/editor.c:1982: Draw();
	call	_Draw
;src/editor/editor.c:1983: redraw = 0;
	ld	hl, _redraw
	ld	[hl], $00
.l00158:
;src/editor/editor.c:1985: if (moved) {
	ld	hl, _moved
	ld	a, [hl]
	or	a, a
	jp	Z, .l00162
;src/editor/editor.c:1986: moved = 0;
	ld	[hl], $00
;src/editor/editor.c:1987: if (!PlaceCursor()) Refresh();
	call	_PlaceCursor
	or	a, a
	jp	NZ, .l00183
	call	_Refresh
;src/editor/editor.c:1988: continue;
	jp	.l00183
.l00162:
;src/editor/editor.c:1990: if (idle_frames < SWAP_DELAY) ++idle_frames;
	ld	hl, _idle_frames
	ld	a, [hl]
	sub	a, $78
	jp	NC, .l00164
	inc	[hl]
.l00164:
;src/editor/editor.c:1991: if (doc_large && !lines_known && FileScanStep()) { // a sector a frame while idle
	ld	hl, _doc_large
	ld	a, [hl]
	or	a, a
	jp	Z, .l00166
	ld	hl, _lines_known
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00166
	call	_FileScanStep
	or	a, a
	jp	Z, .l00166
;src/editor/editor.c:1992: win_lines += scan_lines;
	ld	hl, _win_lines + 1
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, e
	ld	hl, _scan_lines
	add	a, [hl]
	ld	e, a
	ld	a, d
	inc	hl
	adc	a, [hl]
	push	af
	ld	hl, _win_lines + 1
	ld	[hl], a
	dec	hl
	ld	[hl], e
	ld	hl, _win_lines + 3
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, _scan_lines + 2
	pop	af
	ld	a, e
	adc	a, [hl]
	ld	e, a
	ld	a, d
	inc	hl
	adc	a, [hl]
	ld	hl, _win_lines + 3
	ld	[hl], a
	dec	hl
	ld	[hl], e
;src/editor/editor.c:1993: lines_known = 1;
	ld	hl, _lines_known
	ld	[hl], $01
;src/editor/editor.c:1994: bars_changed = 1;
	ld	hl, _bars_changed
	ld	[hl], $01
.l00166:
;src/editor/editor.c:1996: if (idle_frames >= NORMALIZE_DELAY && !everdrive && !normalized) normalized = tb_NormalizeStep(); // keeps the .sav readable as text
	ld	hl, _idle_frames
	ld	a, [hl]
	sub	a, $1E
	jp	C, .l00170
	ld	hl, _everdrive
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00170
	ld	hl, _normalized
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00170
	call	_tb_NormalizeStep
	ld	hl, _normalized
	ld	[hl], a
.l00170:
;src/editor/editor.c:1997: if (idle_frames >= SWAP_DELAY && swap_dirty && !doc_large) {
	ld	hl, _idle_frames
	ld	a, [hl]
	sub	a, $78
	jp	C, .l00174
	ld	hl, _swap_dirty
	ld	a, [hl]
	or	a, a
	jp	Z, .l00174
	ld	hl, _doc_large
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00174
;src/editor/editor.c:1998: swap_dirty = 0;
	ld	hl, _swap_dirty
	ld	[hl], $00
;src/editor/editor.c:1999: FileSaveSwap();
	call	_FileSaveSwap
.l00174:
;src/editor/editor.c:2001: if (++blink_timer == CURSOR_BLINK) EditorShowCursor(0);
	ld	hl, _blink_timer
	inc	[hl]
	ld	a, [hl]
	sub	a, $1E
	jp	NZ,.l00438
	jp	.l00439
.l00438:
	jp	.l00180
.l00439:
	xor	a, a
	call	_EditorShowCursor
	jp	.l00183
.l00180:
;src/editor/editor.c:2002: else if (blink_timer == CURSOR_BLINK + CURSOR_BLINK) {
	ld	hl, _blink_timer
	ld	a, [hl]
	sub	a, $3C
	jp	NZ,.l00440
	jp	.l00441
.l00440:
	jp	.l00183
.l00441:
;src/editor/editor.c:2003: EditorShowCursor(1);
	ld	a, $01
	call	_EditorShowCursor
;src/editor/editor.c:2004: blink_timer = 0;
	ld	hl, _blink_timer
	ld	[hl], $00
	jp	.l00183
.l00187:
;src/editor/editor.c:2007: }
	add	sp, 4
	ret
	SECTION FRAGMENT "src/editor/editor.c FIXED",ROMX,BANK[1]
___src_editor_editor_c_str_107:
	DB "/GBCSYS/EDITOR.DAT"
	DB $00
	SECTION FRAGMENT "src/editor/editor.c FIXED",ROMX,BANK[1]
___src_editor_editor_c_str_108:
	DB "SAVE NOT BACKED UP"
	DB $00
	SECTION FRAGMENT "src/editor/editor.c FIXED",ROMX,BANK[1]
	SECTION FRAGMENT "_INITIALIZER",ROM0
	SECTION FRAGMENT "_CABS (ABS)",ROM0

;far call thunks generated by bank_split.py
	SECTION FRAGMENT "src/editor/editor.c FIXED",ROMX,BANK[1]
_BeginFullScreen__far:
	call FarCallInline
	DB BANK(_BeginFullScreen)
	DW _BeginFullScreen
_CanDiscard__far:
	call FarCallInline
	DB BANK(_CanDiscard)
	DW _CanDiscard
_ClearScreen__far:
	call FarCallInline
	DB BANK(_ClearScreen)
	DW _ClearScreen
_ClockSetup__far:
	call FarCallInline
	DB BANK(_ClockSetup)
	DW _ClockSetup
_Copy__far:
	call FarCallInline
	DB BANK(_Copy)
	DW _Copy
_Cut__far:
	call FarCallInline
	DB BANK(_Cut)
	DW _Cut
_DeleteSelection__far:
	call FarCallInline
	DB BANK(_DeleteSelection)
	DW _DeleteSelection
_DrawRow__far:
	call FarCallInline
	DB BANK(_DrawRow)
	DW _DrawRow
_EndFullScreen__far:
	call FarCallInline
	DB BANK(_EndFullScreen)
	DW _EndFullScreen
_GetSelection__far:
	call FarCallInline
	DB BANK(_GetSelection)
	DW _GetSelection
_GoEnd__far:
	call FarCallInline
	DB BANK(_GoEnd)
	DW _GoEnd
_GoStart__far:
	call FarCallInline
	DB BANK(_GoStart)
	DW _GoStart
_HandleCtrlKey__far:
	call FarCallInline
	DB BANK(_HandleCtrlKey)
	DW _HandleCtrlKey
_HandleFileKey__far:
	call FarCallInline
	DB BANK(_HandleFileKey)
	DW _HandleFileKey
_HideBox__far:
	call FarCallInline
	DB BANK(_HideBox)
	DW _HideBox
_IsGame__far:
	call FarCallInline
	DB BANK(_IsGame)
	DW _IsGame
_KeyboardTest__far:
	call FarCallInline
	DB BANK(_KeyboardTest)
	DW _KeyboardTest
_LaunchGame__far:
	call FarCallInline
	DB BANK(_LaunchGame)
	DW _LaunchGame
_Layout__far:
	call FarCallInline
	DB BANK(_Layout)
	DW _Layout
_LineEnd__far:
	call FarCallInline
	DB BANK(_LineEnd)
	DW _LineEnd
_MenuKey__far:
	call FarCallInline
	DB BANK(_MenuKey)
	DW _MenuKey
_MoveDown__far:
	call FarCallInline
	DB BANK(_MoveDown)
	DW _MoveDown
_MoveEnd__far:
	call FarCallInline
	DB BANK(_MoveEnd)
	DW _MoveEnd
_MoveUp__far:
	call FarCallInline
	DB BANK(_MoveUp)
	DW _MoveUp
_NoHighlight__far:
	call FarCallInline
	DB BANK(_NoHighlight)
	DW _NoHighlight
_OpenBox__far:
	call FarCallInline
	DB BANK(_OpenBox)
	DW _OpenBox
_OpenFile__far:
	call FarCallInline
	DB BANK(_OpenFile)
	DW _OpenFile
_PadKey__far:
	call FarCallInline
	DB BANK(_PadKey)
	DW _PadKey
_PageDown__far:
	call FarCallInline
	DB BANK(_PageDown)
	DW _PageDown
_PageUp__far:
	call FarCallInline
	DB BANK(_PageUp)
	DW _PageUp
_Paste__far:
	call FarCallInline
	DB BANK(_Paste)
	DW _Paste
_PickOSKBlocks__far:
	call FarCallInline
	DB BANK(_PickOSKBlocks)
	DW _PickOSKBlocks
_PosAtX__far:
	call FarCallInline
	DB BANK(_PosAtX)
	DW _PosAtX
_PutNumber__far:
	call FarCallInline
	DB BANK(_PutNumber)
	DW _PutNumber
_PutNumber2__far:
	call FarCallInline
	DB BANK(_PutNumber2)
	DW _PutNumber2
_PutText__far:
	call FarCallInline
	DB BANK(_PutText)
	DW _PutText
_Render__far:
	call FarCallInline
	DB BANK(_Render)
	DW _Render
_ResetCursor__far:
	call FarCallInline
	DB BANK(_ResetCursor)
	DW _ResetCursor
_RowAddress__far:
	call FarCallInline
	DB BANK(_RowAddress)
	DW _RowAddress
_ScrollDown__far:
	call FarCallInline
	DB BANK(_ScrollDown)
	DW _ScrollDown
_ScrollRing__far:
	call FarCallInline
	DB BANK(_ScrollRing)
	DW _ScrollRing
_ScrollTo__far:
	call FarCallInline
	DB BANK(_ScrollTo)
	DW _ScrollTo
_ScrollUp__far:
	call FarCallInline
	DB BANK(_ScrollUp)
	DW _ScrollUp
_SelectAll__far:
	call FarCallInline
	DB BANK(_SelectAll)
	DW _SelectAll
_SetLang__far:
	call FarCallInline
	DB BANK(_SetLang)
	DW _SetLang
_SetRows__far:
	call FarCallInline
	DB BANK(_SetRows)
	DW _SetRows
_ShowBusy__far:
	call FarCallInline
	DB BANK(_ShowBusy)
	DW _ShowBusy
_ShowError__far:
	call FarCallInline
	DB BANK(_ShowError)
	DW _ShowError
_ShowHelp__far:
	call FarCallInline
	DB BANK(_ShowHelp)
	DW _ShowHelp
_ShowMessage__far:
	call FarCallInline
	DB BANK(_ShowMessage)
	DW _ShowMessage
_Slide__far:
	call FarCallInline
	DB BANK(_Slide)
	DW _Slide
_ToLatin1__far:
	call FarCallInline
	DB BANK(_ToLatin1)
	DW _ToLatin1
_ToggleBars__far:
	call FarCallInline
	DB BANK(_ToggleBars)
	DW _ToggleBars
_ToggleWrap__far:
	call FarCallInline
	DB BANK(_ToggleWrap)
	DW _ToggleWrap
_Uncount__far:
	call FarCallInline
	DB BANK(_Uncount)
	DW _Uncount
_UndoRedo__far:
	call FarCallInline
	DB BANK(_UndoRedo)
	DW _UndoRedo
_UpdateBars__far:
	call FarCallInline
	DB BANK(_UpdateBars)
	DW _UpdateBars
_WaitDismiss__far:
	call FarCallInline
	DB BANK(_WaitDismiss)
	DW _WaitDismiss
_WordLeft__far:
	call FarCallInline
	DB BANK(_WordLeft)
	DW _WordLeft
_WordRight__far:
	call FarCallInline
	DB BANK(_WordRight)
	DW _WordRight