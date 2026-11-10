;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 4.2.0 #13081 (Linux)
;--------------------------------------------------------
	; MODULE window
	; Generated using the rgbds tokens.

;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	EXPORT _Uncount
	EXPORT _UndoClear
	EXPORT _tb_CountLines
	EXPORT _tb_Length
	EXPORT _FileCommitWindow
	EXPORT _DocLineStart
	EXPORT _FileLoadWindow
	EXPORT _ShowMessage
	EXPORT _Slide
	EXPORT _GoStart
	EXPORT _GoEnd
;--------------------------------------------------------
; special function registers
;--------------------------------------------------------
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	SECTION FRAGMENT "src/editor/window.c_DATA",WRAM0
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
	SECTION FRAGMENT "src/editor/window.c_HOME",ROM0
	SECTION FRAGMENT "src/editor/window.c_HOME",ROM0
;--------------------------------------------------------
; code
;--------------------------------------------------------
	SECTION FRAGMENT "src/editor/window.c_CODE",ROMX
;src/editor/window.c:15: static unsigned char Commit(void) {
;	---------------------------------
	SECTION FRAGMENT "Page 6",ROMX,BANK[3]
	LOAD FRAGMENT "Page 6 RAM",SRAM,BANK[6]
; Function Commit
; ---------------------------------
_src_editor_window_c_Commit:
;src/editor/window.c:16: if (FileCommitWindow()) return 1;
	call	_FileCommitWindow
	or	a, a
	jp	Z, .l00102
	ld	a, $01
	jp	.l00103
.l00102:
;src/editor/window.c:17: ShowMessage("TOO MANY EDITS, SAVE FIRST");
	ld	de, _src_editor_window_c___str_0
	call	_ShowMessage
;src/editor/window.c:18: return 0;
	xor	a, a
.l00103:
;src/editor/window.c:19: }
	ret
	SECTION FRAGMENT "src/editor/window.c FIXED",ROMX,BANK[1]
_src_editor_window_c___str_0:
	DB "TOO MANY EDITS, SAVE FIRST"
	DB $00
;src/editor/window.c:22: static void LoadWindow(void) {
;	---------------------------------
	SECTION FRAGMENT "Page 6",ROMX,BANK[3]
	LOAD FRAGMENT "Page 6 RAM",SRAM,BANK[6]
; Function LoadWindow
; ---------------------------------
_src_editor_window_c_LoadWindow:
;src/editor/window.c:23: if (FileLoadWindow()) ShowMessage("SD ERROR");
	call	_FileLoadWindow
	or	a, a
	jp	Z, .l00102
	ld	de, _src_editor_window_c___str_1
	call	_ShowMessage
.l00102:
;src/editor/window.c:24: UndoClear(modified);
	ld	hl, _modified
	ld	a, [hl]
	call	_UndoClear
;src/editor/window.c:25: Uncount(0);
	ld	de, $0000
	call	_Uncount__far
;src/editor/window.c:26: dirty = 1;
	ld	hl, _dirty
	ld	[hl], $01
.l00103:
;src/editor/window.c:27: }
	ret
	SECTION FRAGMENT "src/editor/window.c FIXED",ROMX,BANK[1]
_src_editor_window_c___str_1:
	DB "SD ERROR"
	DB $00
;src/editor/window.c:31: static void ShiftPositions(unsigned int shift, unsigned char down) {
;	---------------------------------
	SECTION FRAGMENT "Page 6",ROMX,BANK[3]
	LOAD FRAGMENT "Page 6 RAM",SRAM,BANK[6]
; Function ShiftPositions
; ---------------------------------
_src_editor_window_c_ShiftPositions:
	add	sp, -3
	ld	c, e
	ld	b, d
	ld	hl, sp+2
	ld	[hl], a
;src/editor/window.c:32: unsigned int length = tb_Length();
	push	bc
	call	_tb_Length
	ld	e, c
	ld	d, b
	pop	bc
	inc	sp
	inc	sp
	push	de
;src/editor/window.c:33: if (down) {
	ld	hl, sp+2
	ld	a, [hl]
	or	a, a
	jp	Z, .l00108
;src/editor/window.c:34: cursor = cursor > shift ? cursor - shift : 0;
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
;src/editor/window.c:35: top = top > shift ? top - shift : 0;
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
;src/editor/window.c:36: if (anchor < shift) selecting = 0;
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
;src/editor/window.c:37: else anchor -= shift;
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
;src/editor/window.c:40: cursor += shift;
	ld	hl, _cursor
	ld	a, [hl]
	add	a, c
	ld	[hl], a
	inc	hl
	ld	a, [hl]
	adc	a, b
	ld	[hl], a
;src/editor/window.c:41: top += shift;
	ld	hl, _top
	ld	a, [hl]
	add	a, c
	ld	[hl], a
	inc	hl
	ld	a, [hl]
	adc	a, b
	ld	[hl], a
;src/editor/window.c:42: if (anchor + shift > length) selecting = 0;
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
;src/editor/window.c:43: else anchor += shift;
	ld	hl, _anchor
	ld	[hl], c
	inc	hl
	ld	[hl], b
.l00109:
;src/editor/window.c:45: if (cursor > length) cursor = length;
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
;src/editor/window.c:46: if (top > length) top = length;
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
;src/editor/window.c:47: Uncount(0);
	ld	de, $0000
	call	_Uncount__far
;src/editor/window.c:48: dirty = 1;
	ld	hl, _dirty
	ld	[hl], $01
.l00114:
;src/editor/window.c:49: }
	add	sp, 3
	ret
;src/editor/window.c:53: static void LinesUnknown(void) {
;	---------------------------------
	SECTION FRAGMENT "Page 6",ROMX,BANK[3]
	LOAD FRAGMENT "Page 6 RAM",SRAM,BANK[6]
; Function LinesUnknown
; ---------------------------------
_src_editor_window_c_LinesUnknown:
;src/editor/window.c:54: lines_known = 0;
	ld	hl, _lines_known
	ld	[hl], $00
;src/editor/window.c:55: win_lines = 0;
	xor	a, a
	ld	hl, _win_lines
	ld	[hl], a
	inc	hl
	ld	[hl], a
	inc	hl
	ld	[hl], a
	inc	hl
	ld	[hl], a
;src/editor/window.c:56: scan_target = win_start;
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
;src/editor/window.c:57: scan_pos = 0;
	xor	a, a
	ld	hl, _scan_pos
	ld	[hl], a
	inc	hl
	ld	[hl], a
	inc	hl
	ld	[hl], a
	inc	hl
	ld	[hl], a
;src/editor/window.c:58: scan_lines = 0;
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
;src/editor/window.c:59: }
	ret
;src/editor/window.c:63: void Slide(void) {
;	---------------------------------
	SECTION FRAGMENT "Page 6",ROMX,BANK[3]
	LOAD FRAGMENT "Page 6 RAM",SRAM,BANK[6]
; Function Slide
; ---------------------------------
_Slide::
	add	sp, -11
;src/editor/window.c:64: unsigned int length = tb_Length(), shift, target;
	call	_tb_Length
;src/editor/window.c:66: if (cursor < WIN_MARGIN ? !win_start : (cursor + WIN_MARGIN <= length || win_end == doc_len)) return;
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
;src/editor/window.c:67: if (!Commit()) return;
	call	_src_editor_window_c_Commit
	or	a, a
	jp	NZ, .l00104
	jp	.l00115
.l00104:
;src/editor/window.c:68: win_mark = NO_MARK;
	ld	hl, _win_mark
	ld	[hl], $FF
	inc	hl
	ld	[hl], $FF
	inc	hl
	ld	[hl], $FF
	inc	hl
	ld	[hl], $FF
;src/editor/window.c:69: if (cursor >= WIN_MARGIN) { // from a sector boundary half a window before the cursor
	ld	hl, _cursor
	ld	a, [hl]
	sub	a, $00
	inc	hl
	ld	a, [hl]
	sbc	a, $20
	jp	C, .l00109
;src/editor/window.c:70: target = cursor - WIN_SIZE / 2;
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
;src/editor/window.c:71: for (i = win_chunks - 1; i && win_kept[i] > target; --i);
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
;src/editor/window.c:72: if (!i) return;
	ld	hl, sp+10
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00107
	jp	.l00115
.l00107:
;src/editor/window.c:73: doc_pos = ((win_start + 511) & ~511UL) + ((unsigned long)i << 9);
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
;src/editor/window.c:74: DocLineStart();
	call	_DocLineStart
;src/editor/window.c:75: shift = win_kept[i] - doc_back;
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
;src/editor/window.c:76: win_lines += tb_CountLines(0, shift);
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
;src/editor/window.c:77: win_start = doc_pos;
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
;src/editor/window.c:78: LoadWindow();
	push	bc
	call	_src_editor_window_c_LoadWindow
	pop	bc
;src/editor/window.c:79: ShiftPositions(shift, 1);
	ld	a, $01
	ld	e, c
	ld	d, b
	call	_src_editor_window_c_ShiftPositions
	jp	.l00115
.l00109:
;src/editor/window.c:82: doc_pos = win_start > WIN_SIZE / 2 ? win_start - WIN_SIZE / 2 : 0;
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
;src/editor/window.c:83: DocLineStart();
	call	_DocLineStart
;src/editor/window.c:84: win_mark = win_start;
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
;src/editor/window.c:85: win_start = doc_pos;
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
;src/editor/window.c:86: LoadWindow();
	call	_src_editor_window_c_LoadWindow
;src/editor/window.c:87: shift = win_mark_pos == 0xFFFF ? 0 : win_mark_pos;
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
;src/editor/window.c:88: win_lines -= tb_CountLines(0, shift);
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
;src/editor/window.c:89: ShiftPositions(shift, 0);
	xor	a, a
	ld	e, c
	ld	d, b
	call	_src_editor_window_c_ShiftPositions
.l00115:
;src/editor/window.c:91: }
	add	sp, 11
	ret
;src/editor/window.c:94: void GoStart(void) {
;	---------------------------------
	SECTION FRAGMENT "Page 6",ROMX,BANK[3]
	LOAD FRAGMENT "Page 6 RAM",SRAM,BANK[6]
; Function GoStart
; ---------------------------------
_GoStart::
;src/editor/window.c:95: if (doc_large && win_start && Commit()) {
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
	call	_src_editor_window_c_Commit
	or	a, a
	jp	Z, .l00102
;src/editor/window.c:96: selecting = 0;
	ld	hl, _selecting
	ld	[hl], $00
;src/editor/window.c:97: win_start = win_lines = 0;
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
;src/editor/window.c:98: win_mark = NO_MARK;
	ld	hl, _win_mark
	ld	[hl], $FF
	inc	hl
	ld	[hl], $FF
	inc	hl
	ld	[hl], $FF
	inc	hl
	ld	[hl], $FF
;src/editor/window.c:99: lines_known = 1;
	ld	hl, _lines_known
	ld	[hl], $01
;src/editor/window.c:100: LoadWindow();
	call	_src_editor_window_c_LoadWindow
.l00102:
;src/editor/window.c:102: cursor = 0;
	xor	a, a
	ld	hl, _cursor
	ld	[hl], a
	inc	hl
	ld	[hl], a
.l00105:
;src/editor/window.c:103: }
	ret
;src/editor/window.c:106: void GoEnd(void) {
;	---------------------------------
	SECTION FRAGMENT "Page 6",ROMX,BANK[3]
	LOAD FRAGMENT "Page 6 RAM",SRAM,BANK[6]
; Function GoEnd
; ---------------------------------
_GoEnd::
;src/editor/window.c:107: if (doc_large && win_end != doc_len && Commit()) {
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
	call	_src_editor_window_c_Commit
	or	a, a
	jp	Z, .l00102
;src/editor/window.c:108: selecting = 0;
	ld	hl, _selecting
	ld	[hl], $00
;src/editor/window.c:109: doc_pos = doc_len - WIN_SIZE / 2; // the window isn't the whole file, so it's longer than this
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
;src/editor/window.c:110: DocLineStart();
	call	_DocLineStart
;src/editor/window.c:111: win_start = doc_pos;
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
;src/editor/window.c:112: win_mark = NO_MARK;
	ld	hl, _win_mark
	ld	[hl], $FF
	inc	hl
	ld	[hl], $FF
	inc	hl
	ld	[hl], $FF
	inc	hl
	ld	[hl], $FF
;src/editor/window.c:113: LoadWindow();
	call	_src_editor_window_c_LoadWindow
;src/editor/window.c:114: LinesUnknown();
	call	_src_editor_window_c_LinesUnknown
.l00102:
;src/editor/window.c:116: cursor = tb_Length();
	call	_tb_Length
	ld	hl, _cursor
	ld	[hl], c
	inc	hl
	ld	[hl], b
.l00105:
;src/editor/window.c:117: }
	ret
	SECTION FRAGMENT "Page 6",ROMX,BANK[3]
	LOAD FRAGMENT "Page 6 RAM",SRAM,BANK[6]
	SECTION FRAGMENT "_INITIALIZER",ROM0
	SECTION FRAGMENT "_CABS (ABS)",ROM0
