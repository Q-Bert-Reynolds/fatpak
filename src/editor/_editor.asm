;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 4.2.0 #13081 (Linux)
;--------------------------------------------------------
	; MODULE editor
	; Generated using the rgbds tokens.

;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	EXPORT _WaitFrame
	EXPORT _SetFont
	EXPORT _KBPopEvent
	EXPORT _sd_Detect
	EXPORT _GoEnd
	EXPORT _GoStart
	EXPORT _Slide
	EXPORT _Refresh
	EXPORT _SetRows
	EXPORT _Draw
	EXPORT _Uncount
	EXPORT _CountEdit
	EXPORT _RenderAfterEdit
	EXPORT _ScrollUp
	EXPORT _ScrollDown
	EXPORT _PlaceCursor
	EXPORT _Redo
	EXPORT _Undo
	EXPORT _UndoDeleting
	EXPORT _UndoInserted
	EXPORT _UndoClear
	EXPORT _tb_RowStart
	EXPORT _tb_NormalizeStep
	EXPORT _tb_ClipLength
	EXPORT _tb_Paste
	EXPORT _tb_Copy
	EXPORT _tb_DeleteRange
	EXPORT _tb_Delete
	EXPORT _tb_Insert
	EXPORT _tb_Length
	EXPORT _SettingsSave
	EXPORT _SettingsLoad
	EXPORT _PadKey
	EXPORT _ScrollLine
	EXPORT _WordLeft
	EXPORT _WordRight
	EXPORT _MoveEnd
	EXPORT _PageDown
	EXPORT _PageUp
	EXPORT _MoveDown
	EXPORT _MoveUp
	EXPORT _SetLang
	EXPORT _FileScanStep
	EXPORT _FileSaveSwap
	EXPORT _HandleFileKey
	EXPORT _ShowMessage
	EXPORT _EditorShowCursor
	EXPORT _saved_modified
	EXPORT _normalized
	EXPORT _idle_frames
	EXPORT _everdrive
	EXPORT _modified
	EXPORT _dirty
	EXPORT _blink_timer
	EXPORT _edit_delta
	EXPORT _edit_pos
	EXPORT _edit_row
	EXPORT _edited
	EXPORT _bars_changed
	EXPORT _bars_on
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
	EXPORT _EditorInit
	EXPORT _GetSelection
	EXPORT _Copy
	EXPORT _Paste
	EXPORT _UndoRedo
	EXPORT _SelectAll
	EXPORT _Cut
	EXPORT _ToggleWrap
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
_bars_on:
	DS 1
_bars_changed:
	DS 1
_edited:
	DS 1
_edit_row:
	DS 1
_edit_pos:
	DS 2
_edit_delta:
	DS 1
_blink_timer:
	DS 1
_dirty:
	DS 1
_modified:
	DS 1
_everdrive:
	DS 1
_idle_frames:
	DS 1
_normalized:
	DS 1
_saved_modified:
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
;src/editor/editor.c:51: void EditorInit(void) {
;	---------------------------------
	SECTION FRAGMENT "Page 5",ROMX,BANK[2]
	LOAD FRAGMENT "Page 5 RAM",SRAM,BANK[5]
; Function EditorInit
; ---------------------------------
_EditorInit::
;src/editor/editor.c:53: for (key = 0; key < BG_MAP_ROWS + WIN_MAP_ROWS; ++key) map_blocks[key] = key < TB_ROWS ? key : 0xFF; // set by RenderSetup
	ld	c, $00
.l00102:
	ld	hl, _map_blocks
	ld	b, $00
	add	hl, bc
	ld	a, c
	sub	a, $12
	jp	NC, .l00106
	ld	e, c
	ld	d, $00
	jp	.l00107
.l00106:
	ld	de, $00FF
.l00107:
	ld	[hl], e
	inc	c
	ld	a, c
	sub	a, $27
	jp	C, .l00102
;src/editor/editor.c:54: everdrive = sd_Detect();
	call	_sd_Detect
	ld	hl, _everdrive
	ld	[hl], a
;src/editor/editor.c:55: idle_frames = 0;
	ld	hl, _idle_frames
	ld	[hl], $00
;src/editor/editor.c:56: normalized = 0;
	ld	hl, _normalized
	ld	[hl], $00
;src/editor/editor.c:57: cursor = 0;
	xor	a, a
	ld	hl, _cursor
	ld	[hl], a
	inc	hl
	ld	[hl], a
;src/editor/editor.c:58: top = 0;
	xor	a, a
	ld	hl, _top
	ld	[hl], a
	inc	hl
	ld	[hl], a
;src/editor/editor.c:59: selecting = 0;
	ld	hl, _selecting
	ld	[hl], $00
;src/editor/editor.c:60: want_x = 0;
	ld	hl, _want_x
	ld	[hl], $00
;src/editor/editor.c:61: keep_x = 0;
	ld	hl, _keep_x
	ld	[hl], $00
;src/editor/editor.c:62: moved = 0;
	ld	hl, _moved
	ld	[hl], $00
;src/editor/editor.c:63: redraw = 0;
	ld	hl, _redraw
	ld	[hl], $00
;src/editor/editor.c:64: ring_top = 0;
	ld	hl, _ring_top
	ld	[hl], $00
;src/editor/editor.c:65: ring_pos = 0;
	ld	hl, _ring_pos
	ld	[hl], $00
;src/editor/editor.c:66: counted_pos = 0;
	xor	a, a
	ld	hl, _counted_pos
	ld	[hl], a
	inc	hl
	ld	[hl], a
;src/editor/editor.c:67: counted_lines = 0;
	xor	a, a
	ld	hl, _counted_lines
	ld	[hl], a
	inc	hl
	ld	[hl], a
;src/editor/editor.c:68: bars_changed = 0;
	ld	hl, _bars_changed
	ld	[hl], $00
;src/editor/editor.c:69: edited = 0;
	ld	hl, _edited
	ld	[hl], $00
;src/editor/editor.c:70: pad_timer = 0;
	ld	hl, _pad_timer
	ld	[hl], $00
;src/editor/editor.c:71: modified = 0;
	ld	hl, _modified
	ld	[hl], $00
;src/editor/editor.c:72: font = FONT_VWF; // SetLang
	ld	hl, _font
	ld	[hl], $01
;src/editor/editor.c:73: file_name[0] = 0;
	ld	hl, _file_name
	ld	[hl], $00
;src/editor/editor.c:74: file_dir[0] = 0;
	ld	hl, _file_dir
	ld	[hl], $00
;src/editor/editor.c:75: fs_crlf = 0;
	ld	hl, _fs_crlf
	ld	[hl], $00
;src/editor/editor.c:76: osk_shown = 0;
	ld	hl, _osk_shown
	ld	[hl], $00
;src/editor/editor.c:77: osk_layer = OSK_LOWER;
	ld	hl, _osk_layer
	ld	[hl], $00
;src/editor/editor.c:78: osk_x = 0;
	ld	hl, _osk_x
	ld	[hl], $00
;src/editor/editor.c:79: osk_y = 0;
	ld	hl, _osk_y
	ld	[hl], $00
;src/editor/editor.c:80: bars_on = 1;
	ld	hl, _bars_on
	ld	[hl], $01
;src/editor/editor.c:81: tb_nowrap = 0;
	ld	hl, _tb_nowrap
	ld	[hl], $00
;src/editor/editor.c:82: tb_left = 0;
	xor	a, a
	ld	hl, _tb_left
	ld	[hl], a
	inc	hl
	ld	[hl], a
;src/editor/editor.c:83: tb_lang = LANG_PLAIN;
	ld	hl, _tb_lang
	ld	[hl], $00
;src/editor/editor.c:84: render_text = 1;
	ld	hl, _render_text
	ld	[hl], $01
;src/editor/editor.c:85: SettingsLoad();
	call	_SettingsLoad
;src/editor/editor.c:86: SetLang();
	call	_SetLang__far
;src/editor/editor.c:87: UndoClear(modified);
	ld	hl, _modified
	ld	a, [hl]
	call	_UndoClear
;src/editor/editor.c:88: saved_modified = modified;
	ld	hl, _modified
	ld	a, [hl]
	ld	hl, _saved_modified
	ld	[hl], a
;src/editor/editor.c:89: SetFont(font);
	ld	hl, _font
	ld	a, [hl]
	call	_SetFont
;src/editor/editor.c:90: SetRows();
	call	_SetRows
;src/editor/editor.c:91: swap_dirty = 0; // the swap file has what booting restored
	ld	hl, _swap_dirty
	ld	[hl], $00
;src/editor/editor.c:92: doc_large = 0;
	ld	hl, _doc_large
	ld	[hl], $00
.l00104:
;src/editor/editor.c:93: }
	ret
;src/editor/editor.c:96: static void Edited(unsigned int pos, signed char delta) {
;	---------------------------------
	SECTION FRAGMENT "Page 5",ROMX,BANK[2]
	LOAD FRAGMENT "Page 5 RAM",SRAM,BANK[5]
; Function Edited
; ---------------------------------
_src_editor_editor_c_Edited:
	ld	c, a
;src/editor/editor.c:97: modified = 1;
	ld	hl, _modified
	ld	[hl], $01
;src/editor/editor.c:98: if (edited) dirty = 1;
	ld	hl, _edited
	ld	a, [hl]
	or	a, a
	jp	Z, .l00102
	ld	hl, _dirty
	ld	[hl], $01
.l00102:
;src/editor/editor.c:99: edited = 1;
	ld	hl, _edited
	ld	[hl], $01
;src/editor/editor.c:100: edit_row = tb_found_row;
	ld	hl, _tb_found_row
	ld	a, [hl]
	ld	hl, _edit_row
	ld	[hl], a
;src/editor/editor.c:101: edit_pos = pos;
	ld	hl, _edit_pos
	ld	[hl], e
	inc	hl
	ld	[hl], d
;src/editor/editor.c:102: edit_delta = delta;
	ld	hl, _edit_delta
	ld	[hl], c
.l00103:
;src/editor/editor.c:103: }
	ret
;src/editor/editor.c:106: unsigned char GetSelection(void) {
;	---------------------------------
	SECTION FRAGMENT "Page 6",ROMX,BANK[3]
	LOAD FRAGMENT "Page 6 RAM",SRAM,BANK[6]
; Function GetSelection
; ---------------------------------
_GetSelection::
;src/editor/editor.c:107: if (!selecting || anchor == cursor) return 0;
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
;src/editor/editor.c:109: sel_start = anchor;
	ld	hl, _anchor
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
;src/editor/editor.c:110: sel_end = cursor;
	ld	hl, _cursor
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
;src/editor/editor.c:108: if (anchor < cursor) {
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
;src/editor/editor.c:109: sel_start = anchor;
	ld	hl, _sel_start
	ld	[hl], c
	inc	hl
	ld	[hl], b
;src/editor/editor.c:110: sel_end = cursor;
	ld	hl, _sel_end
	ld	[hl], e
	inc	hl
	ld	[hl], d
	jp	.l00106
.l00105:
;src/editor/editor.c:113: sel_start = cursor;
	ld	hl, _sel_start
	ld	[hl], e
	inc	hl
	ld	[hl], d
;src/editor/editor.c:114: sel_end = anchor;
	ld	hl, _sel_end
	ld	[hl], c
	inc	hl
	ld	[hl], b
.l00106:
;src/editor/editor.c:116: return 1;
	ld	a, $01
.l00107:
;src/editor/editor.c:117: }
	ret
;src/editor/editor.c:119: static void ClearSelection(void) {
;	---------------------------------
	SECTION FRAGMENT "Page 5",ROMX,BANK[2]
	LOAD FRAGMENT "Page 5 RAM",SRAM,BANK[5]
; Function ClearSelection
; ---------------------------------
_src_editor_editor_c_ClearSelection:
;src/editor/editor.c:120: if (selecting) redraw = 1;
	ld	hl, _selecting
	ld	a, [hl]
	or	a, a
	jp	Z, .l00102
	ld	hl, _redraw
	ld	[hl], $01
.l00102:
;src/editor/editor.c:121: selecting = 0;
	ld	hl, _selecting
	ld	[hl], $00
.l00103:
;src/editor/editor.c:122: }
	ret
;src/editor/editor.c:124: static void DeleteSelection(void) {
;	---------------------------------
	SECTION FRAGMENT "Page 6",ROMX,BANK[3]
	LOAD FRAGMENT "Page 6 RAM",SRAM,BANK[6]
; Function DeleteSelection
; ---------------------------------
_src_editor_editor_c_DeleteSelection:
;src/editor/editor.c:125: UndoDeleting(sel_start, sel_end - sel_start);
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
;src/editor/editor.c:126: Uncount(sel_start);
	ld	hl, _sel_start
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_Uncount__far
;src/editor/editor.c:127: tb_DeleteRange(sel_start, sel_end - sel_start);
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
;src/editor/editor.c:128: cursor = sel_start;
	ld	hl, _sel_start
	ld	a, [hl]
	ld	hl, _cursor
	ld	[hl], a
	ld	hl, _sel_start + 1
	ld	a, [hl]
	ld	hl, _cursor + 1
	ld	[hl], a
;src/editor/editor.c:129: selecting = 0;
	ld	hl, _selecting
	ld	[hl], $00
;src/editor/editor.c:130: modified = 1;
	ld	hl, _modified
	ld	[hl], $01
;src/editor/editor.c:131: dirty = 1;
	ld	hl, _dirty
	ld	[hl], $01
.l00101:
;src/editor/editor.c:132: }
	ret
;src/editor/editor.c:134: unsigned char Copy(void) {
;	---------------------------------
	SECTION FRAGMENT "Page 6",ROMX,BANK[3]
	LOAD FRAGMENT "Page 6 RAM",SRAM,BANK[6]
; Function Copy
; ---------------------------------
_Copy::
;src/editor/editor.c:135: if (!GetSelection()) return 0;
	call	_GetSelection
	or	a, a
	jp	NZ, .l00102
	xor	a, a
	jp	.l00105
.l00102:
;src/editor/editor.c:136: if (tb_Copy(sel_start, sel_end - sel_start)) return 1;
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
;src/editor/editor.c:137: ShowMessage("TOO BIG TO COPY");
	ld	de, _src_editor_editor_c___str_0
	call	_ShowMessage
;src/editor/editor.c:138: return 0;
	xor	a, a
.l00105:
;src/editor/editor.c:139: }
	ret
	SECTION FRAGMENT "src/editor/editor.c FIXED",ROMX,BANK[1]
_src_editor_editor_c___str_0:
	DB "TOO BIG TO COPY"
	DB $00
;src/editor/editor.c:141: void Paste(void) {
;	---------------------------------
	SECTION FRAGMENT "Page 6",ROMX,BANK[3]
	LOAD FRAGMENT "Page 6 RAM",SRAM,BANK[6]
; Function Paste
; ---------------------------------
_Paste::
	add	sp, -6
;src/editor/editor.c:142: unsigned int length = tb_ClipLength(), room = TB_SIZE - tb_Length();
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
;src/editor/editor.c:143: if (!length) return;
	ld	hl, sp+1
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	jp	NZ, .l00102
	jp	.l00109
.l00102:
;src/editor/editor.c:144: if (GetSelection()) room += sel_end - sel_start;
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
;src/editor/editor.c:145: if (length > room) {
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
;src/editor/editor.c:146: ShowMessage("TEXT FULL");
	ld	de, _src_editor_editor_c___str_1
	call	_ShowMessage
;src/editor/editor.c:147: return;
	jp	.l00109
.l00106:
;src/editor/editor.c:149: undo_join = GetSelection();
	call	_GetSelection
	ld	hl, _undo_join
	ld	[hl], a
;src/editor/editor.c:150: if (undo_join) DeleteSelection();
	ld	a, [hl]
	or	a, a
	jp	Z, .l00108
	call	_src_editor_editor_c_DeleteSelection
.l00108:
;src/editor/editor.c:151: Uncount(cursor);
	ld	hl, _cursor
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_Uncount__far
;src/editor/editor.c:152: tb_Paste(cursor);
	ld	hl, _cursor
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_tb_Paste
;src/editor/editor.c:153: UndoInserted(cursor, length);
	pop	bc
	push	bc
	ld	hl, _cursor
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_UndoInserted
;src/editor/editor.c:154: cursor += length;
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
;src/editor/editor.c:155: modified = 1;
	ld	hl, _modified
	ld	[hl], $01
;src/editor/editor.c:156: dirty = 1;
	ld	hl, _dirty
	ld	[hl], $01
.l00109:
;src/editor/editor.c:157: }
	add	sp, 6
	ret
	SECTION FRAGMENT "src/editor/editor.c FIXED",ROMX,BANK[1]
_src_editor_editor_c___str_1:
	DB "TEXT FULL"
	DB $00
;src/editor/editor.c:160: void UndoRedo(unsigned char redo) {
;	---------------------------------
	SECTION FRAGMENT "Page 6",ROMX,BANK[3]
	LOAD FRAGMENT "Page 6 RAM",SRAM,BANK[6]
; Function UndoRedo
; ---------------------------------
_UndoRedo::
	ld	c, a
;src/editor/editor.c:161: if (!(redo ? Redo() : Undo())) return;
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
;src/editor/editor.c:162: cursor = undo_cursor;
	ld	hl, _undo_cursor
	ld	a, [hl]
	ld	hl, _cursor
	ld	[hl], a
	ld	hl, _undo_cursor + 1
	ld	a, [hl]
	ld	hl, _cursor + 1
	ld	[hl], a
;src/editor/editor.c:163: selecting = 0;
	ld	hl, _selecting
	ld	[hl], $00
;src/editor/editor.c:164: Uncount(0);
	ld	de, $0000
	call	_Uncount__far
;src/editor/editor.c:165: modified = !undo_at_save;
	ld	hl, _undo_at_save
	ld	a, [hl]
	sub	a,$01
	ld	a, $00
	rla
	ld	hl, _modified
	ld	[hl], a
;src/editor/editor.c:166: dirty = 1;
	ld	hl, _dirty
	ld	[hl], $01
.l00103:
;src/editor/editor.c:167: }
	ret
;src/editor/editor.c:169: void SelectAll(void) {
;	---------------------------------
	SECTION FRAGMENT "Page 6",ROMX,BANK[3]
	LOAD FRAGMENT "Page 6 RAM",SRAM,BANK[6]
; Function SelectAll
; ---------------------------------
_SelectAll::
;src/editor/editor.c:170: anchor = 0;
	xor	a, a
	ld	hl, _anchor
	ld	[hl], a
	inc	hl
	ld	[hl], a
;src/editor/editor.c:171: cursor = tb_Length();
	call	_tb_Length
	ld	hl, _cursor
	ld	[hl], c
	inc	hl
	ld	[hl], b
;src/editor/editor.c:172: selecting = 1;
	ld	hl, _selecting
	ld	[hl], $01
;src/editor/editor.c:173: moved = 1;
	ld	hl, _moved
	ld	[hl], $01
;src/editor/editor.c:174: redraw = 1;
	ld	hl, _redraw
	ld	[hl], $01
.l00101:
;src/editor/editor.c:175: }
	ret
;src/editor/editor.c:177: void Cut(void) {
;	---------------------------------
	SECTION FRAGMENT "Page 6",ROMX,BANK[3]
	LOAD FRAGMENT "Page 6 RAM",SRAM,BANK[6]
; Function Cut
; ---------------------------------
_Cut::
;src/editor/editor.c:178: if (Copy()) DeleteSelection();
	call	_Copy
	or	a, a
	jp	Z, .l00103
	jp	_src_editor_editor_c_DeleteSelection
.l00103:
;src/editor/editor.c:179: }
	ret
;src/editor/editor.c:182: static void HandleCtrlKey(unsigned char key, unsigned char mods) {
;	---------------------------------
	SECTION FRAGMENT "Page 6",ROMX,BANK[3]
	LOAD FRAGMENT "Page 6 RAM",SRAM,BANK[6]
; Function HandleCtrlKey
; ---------------------------------
_src_editor_editor_c_HandleCtrlKey:
	ld	l, a
;	spillPairReg hl
;	spillPairReg hl
;src/editor/editor.c:183: if (key >= 'A' && key <= 'Z') key += 'a' - 'A';
	ld	a, l
	sub	a, $41
	jp	C, .l00102
	ld	a, $5A
	sub	a, l
	jp	C, .l00102
	ld	c, $20
	add	hl, bc
.l00102:
;src/editor/editor.c:184: if (key == 'z') UndoRedo(mods & KB_MOD_SHIFT);
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
;src/editor/editor.c:185: else if (key == 'y') UndoRedo(1);
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
;src/editor/editor.c:186: if (key == 'a') SelectAll();
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
;src/editor/editor.c:187: else if (key == 'c') Copy();
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
;src/editor/editor.c:188: else if (key == 'x') Cut();
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
;src/editor/editor.c:189: else if (key == 'v') Paste();
	ld	a, l
	sub	a, $76
	jp	NZ,.l00172
	jp	.l00173
.l00172:
	jp	.l00120
.l00173:
	jp	_Paste
.l00120:
;src/editor/editor.c:190: }
	ret
;src/editor/editor.c:193: static void HandleKey(unsigned char key, unsigned char mods) {
;	---------------------------------
	SECTION FRAGMENT "Page 5",ROMX,BANK[2]
	LOAD FRAGMENT "Page 5 RAM",SRAM,BANK[5]
; Function HandleKey
; ---------------------------------
_src_editor_editor_c_HandleKey:
	add	sp, -6
	ld	hl, sp+5
	ld	[hl], a
	dec	hl
	ld	[hl], e
;src/editor/editor.c:194: unsigned char ctrl = mods & KB_MOD_CTRL, join = 0;
	ld	a, [hl]
	and	a, $20
	ld	hl, sp+0
	ld	[hl], a
	inc	hl
	ld	[hl], $00
;src/editor/editor.c:195: if (key == KEY_UNDO || key == KEY_REDO) { UndoRedo(key == KEY_REDO); return; }
	ld	hl, sp+5
	ld	a, [hl]
	sub	a, $8A
	jp	NZ,.l00357
	jp	.l00101
.l00357:
	ld	hl, sp+5
	ld	a, [hl]
	sub	a, $8B
	jp	NZ,.l00358
	jp	.l00359
.l00358:
	jp	.l00102
.l00359:
.l00101:
	ld	hl, sp+5
	ld	a, [hl]
	sub	a, $8B
	jp	NZ,.l00360
	ld	a,$01
	jp	.l00361
.l00360:
	xor	a,a
.l00361:
	ld	c, a
	ld	a, c
	call	_UndoRedo__far
	jp	.l00173
.l00102:
;src/editor/editor.c:196: if (mods & (KB_MOD_ALT | KB_MOD_SUPER)) return;
	ld	hl, sp+4
	ld	a, [hl]
	and	a, $18
	jp	NZ,.l00362
	jp	.l00105
.l00362:
	jp	.l00173
.l00105:
;src/editor/editor.c:197: if (key >= KEY_LEFT && key <= KEY_PAGE_DOWN) undo_merge = 0; // moving starts a new undo step
	ld	hl, sp+5
	ld	a, [hl]
	sub	a, $80
	jp	C, .l00107
	ld	a, $87
	sub	a, [hl]
	jp	C, .l00107
	ld	hl, _undo_merge
	ld	[hl], $00
.l00107:
;src/editor/editor.c:198: if (key < KEY_LEFT || key > KEY_PAGE_DOWN) {
	ld	hl, sp+5
	ld	a, [hl]
	sub	a, $80
	ld	a, $00
	rla
	ld	hl, sp+2
	ld	[hl], a
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00122
	ld	a, $87
	ld	hl, sp+5
	sub	a, [hl]
	jp	NC, .l00123
.l00122:
;src/editor/editor.c:199: if (ctrl) {
	ld	hl, sp+0
	ld	a, [hl]
	or	a, a
	jp	Z, .l00124
;src/editor/editor.c:200: HandleCtrlKey(key, mods);
	ld	hl, sp+4
	ld	e, [hl]
	inc	hl
	ld	a, [hl]
	call	_src_editor_editor_c_HandleCtrlKey__far
;src/editor/editor.c:201: return;
	jp	.l00173
.l00123:
;src/editor/editor.c:204: else if (mods & KB_MOD_SHIFT) { // shift + movement selects
	push	hl
	ld	hl, sp+6
	bit	6, [hl]
	pop	hl
	jp	NZ,.l00363
	jp	.l00120
.l00363:
;src/editor/editor.c:205: if (!selecting) anchor = cursor;
	ld	hl, _selecting
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00112
	ld	hl, _cursor
	ld	a, [hl]
	ld	hl, _anchor
	ld	[hl], a
	ld	hl, _cursor + 1
	ld	a, [hl]
	ld	hl, _anchor + 1
	ld	[hl], a
.l00112:
;src/editor/editor.c:206: selecting = 1;
	ld	hl, _selecting
	ld	[hl], $01
;src/editor/editor.c:207: redraw = 1;
	ld	hl, _redraw
	ld	[hl], $01
	jp	.l00124
.l00120:
;src/editor/editor.c:209: else if (!ctrl && GetSelection() && (key == KEY_LEFT || key == KEY_RIGHT)) { // to that end of the selection
	ld	hl, sp+0
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00114
	call	_GetSelection__far
	or	a, a
	jp	Z, .l00114
	ld	hl, sp+5
	ld	a, [hl]
	sub	a, $80
	jp	NZ,.l00364
	ld	a,$01
	jp	.l00365
.l00364:
	xor	a,a
.l00365:
	ld	hl, sp+3
	ld	[hl], a
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00113
	inc	hl
	inc	hl
	ld	a, [hl]
	sub	a, $81
	jp	NZ,.l00366
	jp	.l00367
.l00366:
	jp	.l00114
.l00367:
.l00113:
;src/editor/editor.c:210: cursor = key == KEY_LEFT ? sel_start : sel_end;
	ld	hl, sp+3
	ld	a, [hl]
	or	a, a
	jp	Z, .l00175
	ld	hl, _sel_start
	ld	a, [hl]
	ld	hl, sp+2
	ld	[hl], a
	ld	hl, _sel_start + 1
	ld	a, [hl]
	ld	hl, sp+3
	ld	[hl], a
	jp	.l00176
.l00175:
	ld	hl, _sel_end
	ld	a, [hl]
	ld	hl, sp+2
	ld	[hl], a
	ld	hl, _sel_end + 1
	ld	a, [hl]
	ld	hl, sp+3
	ld	[hl], a
.l00176:
	ld	hl, sp+2
	ld	a, [hl]
	ld	hl, _cursor
	ld	[hl], a
	ld	hl, sp+3
	ld	a, [hl]
	ld	hl, _cursor + 1
	ld	[hl], a
;src/editor/editor.c:211: ClearSelection();
	call	_src_editor_editor_c_ClearSelection
;src/editor/editor.c:212: moved = 1;
	ld	hl, _moved
	ld	[hl], $01
;src/editor/editor.c:213: return;
	jp	.l00173
.l00114:
;src/editor/editor.c:215: else ClearSelection();
	call	_src_editor_editor_c_ClearSelection
.l00124:
;src/editor/editor.c:216: moved = 1;
	ld	hl, _moved
	ld	[hl], $01
;src/editor/editor.c:217: if (ctrl) {
	ld	hl, sp+0
	ld	a, [hl]
	or	a, a
	jp	Z, .l00134
;src/editor/editor.c:218: switch (key) {
	ld	hl, sp+5
	ld	a, [hl]
	sub	a, $80
	jp	NZ,.l00368
	jp	.l00126
.l00368:
	ld	hl, sp+5
	ld	a, [hl]
	sub	a, $81
	jp	NZ,.l00369
	jp	.l00127
.l00369:
	ld	hl, sp+5
	ld	a, [hl]
	sub	a, $82
	jp	NZ,.l00370
	jp	.l00128
.l00370:
	ld	hl, sp+5
	ld	a, [hl]
	sub	a, $83
	jp	NZ,.l00371
	jp	.l00129
.l00371:
	ld	hl, sp+5
	ld	a, [hl]
	sub	a, $84
	jp	NZ,.l00372
	jp	.l00130
.l00372:
	ld	hl, sp+5
	ld	a, [hl]
	sub	a, $85
	jp	NZ,.l00373
	jp	.l00131
.l00373:
	jp	.l00134
;src/editor/editor.c:219: case KEY_LEFT: WordLeft(); return;
.l00126:
	call	_WordLeft__far
	jp	.l00173
;src/editor/editor.c:220: case KEY_RIGHT: WordRight(); return;
.l00127:
	call	_WordRight__far
	jp	.l00173
;src/editor/editor.c:221: case KEY_UP: ScrollLine(0); return;
.l00128:
	xor	a, a
	call	_ScrollLine
	jp	.l00173
;src/editor/editor.c:222: case KEY_DOWN: ScrollLine(1); return;
.l00129:
	ld	a, $01
	call	_ScrollLine
	jp	.l00173
;src/editor/editor.c:223: case KEY_HOME: GoStart(); return;
.l00130:
	call	_GoStart__far
	jp	.l00173
;src/editor/editor.c:224: case KEY_END: GoEnd(); return;
.l00131:
	call	_GoEnd__far
	jp	.l00173
;src/editor/editor.c:225: }
.l00134:
;src/editor/editor.c:227: switch (key) {
	ld	hl, sp+2
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00147
	ld	a, $87
	ld	hl, sp+5
	sub	a, [hl]
	jp	C, .l00147
	ld	a, [hl]
	add	a, $80
	ld	c, a
	ld	b, $00
	ld	hl, .l00374
	add	hl, bc
	add	hl, bc
	add	hl, bc
	jp	hl
.l00374:
	jp	.l00139
	jp	.l00142
	jp	.l00135
	jp	.l00136
	jp	.l00145
	jp	.l00146
	jp	.l00137
	jp	.l00138
;src/editor/editor.c:228: case KEY_UP: MoveUp(); return;
.l00135:
	call	_MoveUp__far
	jp	.l00173
;src/editor/editor.c:229: case KEY_DOWN: MoveDown(); return;
.l00136:
	call	_MoveDown__far
	jp	.l00173
;src/editor/editor.c:230: case KEY_PAGE_UP: PageUp(); return;
.l00137:
	call	_PageUp__far
	jp	.l00173
;src/editor/editor.c:231: case KEY_PAGE_DOWN: PageDown(); return;
.l00138:
	call	_PageDown__far
	jp	.l00173
;src/editor/editor.c:232: case KEY_LEFT: if (cursor) --cursor; return;
.l00139:
	ld	hl, _cursor + 1
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	jp	Z, .l00141
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
.l00141:
	jp	.l00173
;src/editor/editor.c:233: case KEY_RIGHT: if (cursor != tb_Length()) ++cursor; return;
.l00142:
	call	_tb_Length
	ld	hl, _cursor
	ld	a, [hl]
	sub	a, c
	jp	NZ,.l00375
	inc	hl
	ld	a, [hl]
	sub	a, b
	jp	NZ,.l00375
	jp	.l00144
.l00375:
	ld	hl, _cursor
	inc	[hl]
	jp	NZ, .l00376
	inc	hl
	inc	[hl]
.l00376:
.l00144:
	jp	.l00173
;src/editor/editor.c:234: case KEY_HOME: cursor = tb_row_starts[tb_found_row]; return;
.l00145:
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
	jp	.l00173
;src/editor/editor.c:235: case KEY_END: MoveEnd(); return;
.l00146:
	call	_MoveEnd__far
	jp	.l00173
;src/editor/editor.c:236: }
.l00147:
;src/editor/editor.c:237: moved = 0;
	ld	hl, _moved
	ld	[hl], $00
;src/editor/editor.c:238: if (key == KEY_ESCAPE || key == KEY_INSERT) return;
	ld	hl, sp+5
	ld	a, [hl]
	sub	a, $1B
	jp	NZ,.l00378
	jp	.l00148
.l00378:
	ld	hl, sp+5
	ld	a, [hl]
	sub	a, $88
	jp	NZ,.l00379
	jp	.l00380
.l00379:
	jp	.l00149
.l00380:
.l00148:
	jp	.l00173
.l00149:
;src/editor/editor.c:239: if (GetSelection()) { // typing replaces the selection
	call	_GetSelection__far
	or	a, a
	jp	Z, .l00155
;src/editor/editor.c:240: DeleteSelection();
	call	_src_editor_editor_c_DeleteSelection__far
;src/editor/editor.c:241: if (key == KEY_BACKSPACE || key == KEY_DELETE) return;
	ld	hl, sp+5
	ld	a, [hl]
	sub	a, $08
	jp	NZ,.l00381
	jp	.l00151
.l00381:
	ld	hl, sp+5
	ld	a, [hl]
	sub	a, $7F
	jp	NZ,.l00382
	jp	.l00383
.l00382:
	jp	.l00152
.l00383:
.l00151:
	jp	.l00173
.l00152:
;src/editor/editor.c:242: join = 1;
	ld	hl, sp+1
	ld	[hl], $01
.l00155:
;src/editor/editor.c:244: selecting = 0;
	ld	hl, _selecting
	ld	[hl], $00
;src/editor/editor.c:245: switch (key) {
	ld	hl, sp+5
	ld	a, [hl]
	sub	a, $08
	jp	NZ,.l00384
	jp	.l00156
.l00384:
	ld	hl, sp+5
	ld	a, [hl]
	sub	a, $7F
	jp	NZ,.l00385
	jp	.l00159
.l00385:
	jp	.l00162
;src/editor/editor.c:246: case KEY_BACKSPACE:
.l00156:
;src/editor/editor.c:247: if (!cursor) break;
	ld	hl, _cursor + 1
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	jp	Z, .l00173
;src/editor/editor.c:248: --cursor;
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
;src/editor/editor.c:250: case KEY_DELETE:
.l00159:
;src/editor/editor.c:251: if (cursor < tb_Length()) {
	call	_tb_Length
	ld	hl, _cursor
	ld	a, [hl]
	sub	a, c
	inc	hl
	ld	a, [hl]
	sbc	a, b
	jp	NC, .l00173
;src/editor/editor.c:252: UndoDeleting(cursor, 1);
	ld	bc, $0001
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_UndoDeleting
;src/editor/editor.c:253: CountEdit(cursor, tb_Delete(cursor), 0);
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
;src/editor/editor.c:254: Edited(cursor, -1);
	ld	a, $FF
	ld	hl, _cursor
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_src_editor_editor_c_Edited
;src/editor/editor.c:256: break;
	jp	.l00173
;src/editor/editor.c:257: default:
.l00162:
;src/editor/editor.c:258: if (key < ' ' && key != ASCII_TAB && key != ASCII_LF) return;
	ld	hl, sp+5
	ld	a, [hl]
	sub	a, $20
	jp	NC, .l00164
	ld	a, [hl]
	sub	a, $09
	jp	NZ,.l00386
	jp	.l00164
.l00386:
	ld	hl, sp+5
	ld	a, [hl]
	sub	a, $0A
	jp	NZ,.l00387
	jp	.l00164
.l00387:
	jp	.l00173
.l00164:
;src/editor/editor.c:259: if (key >= KEY_LEFT && key < 0xA0) return; // unprintable in Latin-1
	ld	hl, sp+5
	ld	a, [hl]
	sub	a, $80
	jp	C, .l00168
	ld	a, [hl]
	sub	a, $A0
	jp	NC, .l00168
	jp	.l00173
.l00168:
;src/editor/editor.c:260: if (tb_Insert(cursor, key)) {
	ld	hl, sp+5
	ld	a, [hl]
	ld	hl, _cursor
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_tb_Insert
	or	a, a
	jp	Z, .l00173
;src/editor/editor.c:261: undo_join = join;
	ld	hl, sp+1
	ld	a, [hl]
	ld	hl, _undo_join
	ld	[hl], a
;src/editor/editor.c:262: UndoInserted(cursor, 1);
	ld	bc, $0001
	ld	hl, _cursor
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_UndoInserted
;src/editor/editor.c:263: CountEdit(cursor, key, 1);
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
;src/editor/editor.c:264: Edited(cursor++, 1);
	ld	hl, _cursor
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	dec	hl
	inc	[hl]
	jp	NZ, .l00388
	inc	hl
	inc	[hl]
.l00388:
	ld	a, $01
	call	_src_editor_editor_c_Edited
;src/editor/editor.c:266: }
.l00173:
;src/editor/editor.c:267: }
	add	sp, 6
	ret
;src/editor/editor.c:270: void ToggleWrap(void) {
;	---------------------------------
	SECTION FRAGMENT "Page 6",ROMX,BANK[3]
	LOAD FRAGMENT "Page 6 RAM",SRAM,BANK[6]
; Function ToggleWrap
; ---------------------------------
_ToggleWrap::
;src/editor/editor.c:271: tb_nowrap = !tb_nowrap;
	ld	hl, _tb_nowrap
	ld	a, [hl]
	sub	a,$01
	ld	a, $00
	rla
	ld	[hl], a
;src/editor/editor.c:272: tb_left = 0;
	xor	a, a
	ld	hl, _tb_left
	ld	[hl], a
	inc	hl
	ld	[hl], a
;src/editor/editor.c:273: dirty = 1;
	ld	hl, _dirty
	ld	[hl], $01
;src/editor/editor.c:274: SettingsSave();
	jp	_SettingsSave
.l00101:
;src/editor/editor.c:275: }
	ret
;src/editor/editor.c:277: void Editor(void) {
;	---------------------------------
	SECTION FRAGMENT "Page 5",ROMX,BANK[2]
	LOAD FRAGMENT "Page 5 RAM",SRAM,BANK[5]
; Function Editor
; ---------------------------------
_Editor::
;src/editor/editor.c:281: while (1) {
.l00175:
;src/editor/editor.c:282: if (modified != saved_modified) {
	ld	hl, _modified
	ld	a, [hl]
	ld	hl, _saved_modified
	sub	a, [hl]
	jp	NZ,.l00389
	jp	.l00102
.l00389:
;src/editor/editor.c:283: saved_modified = modified;
	ld	hl, _modified
	ld	a, [hl]
	ld	hl, _saved_modified
	ld	[hl], a
;src/editor/editor.c:284: SettingsSave();
	call	_SettingsSave
.l00102:
;src/editor/editor.c:286: if (bars_changed) { // status bar follows the cursor
	ld	hl, _bars_changed
	ld	a, [hl]
	or	a, a
	jp	Z, .l00106
;src/editor/editor.c:287: bars_changed = 0;
	ld	[hl], $00
;src/editor/editor.c:288: if (bars) Draw();
	ld	hl, _bars
	ld	a, [hl]
	or	a, a
	jp	Z, .l00106
	call	_Draw
.l00106:
;src/editor/editor.c:290: WaitFrame();
	call	_WaitFrame
;src/editor/editor.c:291: while ((key = (unsigned char)(event = KBPopEvent()))) {
.l00118:
	call	_KBPopEvent
	ld	e, c
	ld	d, b
	ld	a, c
	ld	c, a
	or	a, a
	jp	Z, .l00120
;src/editor/editor.c:292: if (!HandleFileKey(key, (unsigned char)(event >> 8))) HandleKey(key, (unsigned char)(event >> 8));
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
	jp	NZ, .l00108
	ld	e, l
	ld	a, c
	call	_src_editor_editor_c_HandleKey
.l00108:
;src/editor/editor.c:293: if (doc_large) Slide(); // before the next key, which could reach the window's end
	ld	hl, _doc_large
	ld	a, [hl]
	or	a, a
	jp	Z, .l00110
	call	_Slide__far
.l00110:
;src/editor/editor.c:294: if (dirty || edited) break; // text changed, rows need rendering before more keys
	ld	hl, _dirty
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00120
	ld	hl, _edited
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00120
;src/editor/editor.c:295: if (moved) { // keeps tb_found_row current for the next key
	ld	hl, _moved
	ld	a, [hl]
	or	a, a
	jp	Z, .l00118
;src/editor/editor.c:296: if (!PlaceCursor()) dirty = 1;
	call	_PlaceCursor
	or	a, a
	jp	NZ, .l00115
	ld	hl, _dirty
	ld	[hl], $01
.l00115:
;src/editor/editor.c:297: moved = 0;
	ld	hl, _moved
	ld	[hl], $00
	jp	.l00118
.l00120:
;src/editor/editor.c:300: if ((key = PadKey())) {
	call	_PadKey__far
	ld	c, a
	or	a, a
	jp	Z, .l00124
;src/editor/editor.c:301: if (!HandleFileKey(key, pad_mods)) HandleKey(key, pad_mods);
	push	bc
	ld	hl, _pad_mods
	ld	e, [hl]
	ld	a, c
	call	_HandleFileKey__far
	pop	bc
	or	a, a
	jp	NZ, .l00124
	ld	hl, _pad_mods
	ld	e, [hl]
	ld	a, c
	call	_src_editor_editor_c_HandleKey
.l00124:
;src/editor/editor.c:303: if (doc_large) Slide(); // near the window's edge (sets dirty)
	ld	hl, _doc_large
	ld	a, [hl]
	or	a, a
	jp	Z, .l00126
	call	_Slide__far
.l00126:
;src/editor/editor.c:304: if (dirty || edited || redraw || moved) idle_frames = 0;
	ld	hl, _dirty
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00127
	ld	hl, _edited
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00127
	ld	hl, _redraw
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00127
	ld	hl, _moved
	ld	a, [hl]
	or	a, a
	jp	Z, .l00128
.l00127:
	ld	hl, _idle_frames
	ld	[hl], $00
.l00128:
;src/editor/editor.c:305: if (dirty) {
	ld	hl, _dirty
	ld	a, [hl]
	or	a, a
	jp	Z, .l00133
;src/editor/editor.c:306: Refresh();
	call	_Refresh
;src/editor/editor.c:307: dirty = 0;
	ld	hl, _dirty
	ld	[hl], $00
;src/editor/editor.c:308: edited = 0;
	ld	hl, _edited
	ld	[hl], $00
;src/editor/editor.c:309: normalized = 0;
	ld	hl, _normalized
	ld	[hl], $00
;src/editor/editor.c:310: continue;
	jp	.l00175
.l00133:
;src/editor/editor.c:312: if (edited) {
	ld	hl, _edited
	ld	a, [hl]
	or	a, a
	jp	Z, .l00148
;src/editor/editor.c:313: edited = 0;
	ld	[hl], $00
;src/editor/editor.c:314: normalized = 0;
	ld	hl, _normalized
	ld	[hl], $00
;src/editor/editor.c:315: RenderAfterEdit();
	call	_RenderAfterEdit
;src/editor/editor.c:316: if (!PlaceCursor()) {
	call	_PlaceCursor
	or	a, a
	jp	NZ, .l00148
;src/editor/editor.c:317: if (cursor >= tb_row_starts[tb_rows] && tb_RowStart(cursor) == tb_row_starts[tb_rows]) ScrollDown();
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
	jp	C, .l00140
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
	jp	NZ,.l00390
	ld	a, h
	sub	a, b
	jp	NZ,.l00390
	jp	.l00391
.l00390:
	jp	.l00140
.l00391:
	call	_ScrollDown
	jp	.l00141
.l00140:
;src/editor/editor.c:318: else if (top && cursor < top && tb_RowStart(cursor) == tb_RowStart(top - 1)) ScrollUp(tb_RowStart(cursor));
	ld	hl, _top + 1
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	jp	Z, .l00135
	ld	de, _cursor
	ld	a, [de]
	inc	de
	sub	a, [hl]
	inc	hl
	ld	a, [de]
	sbc	a, [hl]
	jp	NC, .l00135
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
	jp	NZ,.l00392
	ld	a, d
	sub	a, b
	jp	NZ,.l00392
	jp	.l00393
.l00392:
	jp	.l00135
.l00393:
	ld	hl, _cursor
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_tb_RowStart
	ld	e, c
	ld	d, b
	call	_ScrollUp
	jp	.l00141
.l00135:
;src/editor/editor.c:320: Refresh();
	call	_Refresh
;src/editor/editor.c:321: continue;
	jp	.l00175
.l00141:
;src/editor/editor.c:323: if (!PlaceCursor()) { // off the side
	call	_PlaceCursor
	or	a, a
	jp	NZ, .l00148
;src/editor/editor.c:324: Refresh();
	call	_Refresh
;src/editor/editor.c:325: continue;
	jp	.l00175
.l00148:
;src/editor/editor.c:329: if (redraw) {
	ld	hl, _redraw
	ld	a, [hl]
	or	a, a
	jp	Z, .l00150
;src/editor/editor.c:330: Draw();
	call	_Draw
;src/editor/editor.c:331: redraw = 0;
	ld	hl, _redraw
	ld	[hl], $00
.l00150:
;src/editor/editor.c:333: if (moved) {
	ld	hl, _moved
	ld	a, [hl]
	or	a, a
	jp	Z, .l00154
;src/editor/editor.c:334: moved = 0;
	ld	[hl], $00
;src/editor/editor.c:335: if (!PlaceCursor()) Refresh();
	call	_PlaceCursor
	or	a, a
	jp	NZ, .l00175
	call	_Refresh
;src/editor/editor.c:336: continue;
	jp	.l00175
.l00154:
;src/editor/editor.c:338: if (idle_frames < SWAP_DELAY) ++idle_frames;
	ld	hl, _idle_frames
	ld	a, [hl]
	sub	a, $78
	jp	NC, .l00156
	inc	[hl]
.l00156:
;src/editor/editor.c:339: if (doc_large && !lines_known && FileScanStep()) { // a sector a frame while idle
	ld	hl, _doc_large
	ld	a, [hl]
	or	a, a
	jp	Z, .l00158
	ld	hl, _lines_known
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00158
	call	_FileScanStep
	or	a, a
	jp	Z, .l00158
;src/editor/editor.c:340: win_lines += scan_lines;
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
;src/editor/editor.c:341: lines_known = 1;
	ld	hl, _lines_known
	ld	[hl], $01
;src/editor/editor.c:342: bars_changed = 1;
	ld	hl, _bars_changed
	ld	[hl], $01
.l00158:
;src/editor/editor.c:344: if (idle_frames >= NORMALIZE_DELAY && !everdrive && !normalized) normalized = tb_NormalizeStep(); // keeps the .sav readable as text
	ld	hl, _idle_frames
	ld	a, [hl]
	sub	a, $1E
	jp	C, .l00162
	ld	hl, _everdrive
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00162
	ld	hl, _normalized
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00162
	call	_tb_NormalizeStep
	ld	hl, _normalized
	ld	[hl], a
.l00162:
;src/editor/editor.c:345: if (idle_frames >= SWAP_DELAY && swap_dirty && !doc_large) {
	ld	hl, _idle_frames
	ld	a, [hl]
	sub	a, $78
	jp	C, .l00166
	ld	hl, _swap_dirty
	ld	a, [hl]
	or	a, a
	jp	Z, .l00166
	ld	hl, _doc_large
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00166
;src/editor/editor.c:346: swap_dirty = 0;
	ld	hl, _swap_dirty
	ld	[hl], $00
;src/editor/editor.c:347: FileSaveSwap();
	call	_FileSaveSwap
.l00166:
;src/editor/editor.c:349: if (++blink_timer == CURSOR_BLINK) EditorShowCursor(0);
	ld	hl, _blink_timer
	inc	[hl]
	ld	a, [hl]
	sub	a, $1E
	jp	NZ,.l00394
	jp	.l00395
.l00394:
	jp	.l00172
.l00395:
	xor	a, a
	call	_EditorShowCursor
	jp	.l00175
.l00172:
;src/editor/editor.c:350: else if (blink_timer == CURSOR_BLINK + CURSOR_BLINK) {
	ld	hl, _blink_timer
	ld	a, [hl]
	sub	a, $3C
	jp	NZ,.l00396
	jp	.l00397
.l00396:
	jp	.l00175
.l00397:
;src/editor/editor.c:351: EditorShowCursor(1);
	ld	a, $01
	call	_EditorShowCursor
;src/editor/editor.c:352: blink_timer = 0;
	ld	hl, _blink_timer
	ld	[hl], $00
	jp	.l00175
.l00177:
;src/editor/editor.c:355: }
	ret
	SECTION FRAGMENT "Page 5",ROMX,BANK[2]
	LOAD FRAGMENT "Page 5 RAM",SRAM,BANK[5]
	SECTION FRAGMENT "_INITIALIZER",ROM0
	SECTION FRAGMENT "_CABS (ABS)",ROM0
