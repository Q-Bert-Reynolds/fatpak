;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 4.2.0 #13081 (Linux)
;--------------------------------------------------------
	; MODULE dialogs
	; Generated using the rgbds tokens.

;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	EXPORT _CopyName
	EXPORT _DrawRow
	EXPORT _RowAddress
	EXPORT _NoHighlight
	EXPORT _EditorDraw
	EXPORT _HideBox
	EXPORT _OpenBox
	EXPORT _WaitDismiss
	EXPORT _MenuKey
	EXPORT _Render
	EXPORT _UpdateBars
	EXPORT _OSKShow
	EXPORT _EditorShowCursor
	EXPORT _Choose
	EXPORT _ShowMessage
	EXPORT _ShowError
;--------------------------------------------------------
; special function registers
;--------------------------------------------------------
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	SECTION FRAGMENT "src/app/dialogs.c_DATA",WRAM0
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
	SECTION FRAGMENT "src/app/dialogs.c_HOME",ROM0
	SECTION FRAGMENT "src/app/dialogs.c_HOME",ROM0
;--------------------------------------------------------
; code
;--------------------------------------------------------
	SECTION FRAGMENT "src/app/dialogs.c_CODE",ROMX
;src/app/dialogs.c:22: unsigned char Choose(const char* title, const char* items, unsigned char count, unsigned char selected) {
;	---------------------------------
	SECTION FRAGMENT "Page 4",ROMX,BANK[2]
	LOAD FRAGMENT "Page 4 RAM",SRAM,BANK[4]
; Function Choose
; ---------------------------------
_Choose::
	add	sp, -6
	ld	hl, sp+1
	ld	[hl], c
	inc	hl
	ld	[hl], b
;src/app/dialogs.c:23: char* line = RowAddress(BOX_LINE);
	push	de
	ld	a, $14
	call	_RowAddress__far
	pop	de
	ld	hl, sp+4
	ld	[hl], c
	inc	hl
	ld	[hl], b
;src/app/dialogs.c:24: unsigned char i, key, first = title ? 1 : 0;
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
;src/app/dialogs.c:25: if (title) CopyName(line, title), line += BOX_STRIDE;
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
;src/app/dialogs.c:26: for (i = 0; i < count; ++i, line += BOX_STRIDE, items += ITEM_SIZE) {
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
;src/app/dialogs.c:27: line[0] = ' ';
	ld	a, $20
	ld	[de], a
;src/app/dialogs.c:28: CopyName(line + 1, items);
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
;src/app/dialogs.c:26: for (i = 0; i < count; ++i, line += BOX_STRIDE, items += ITEM_SIZE) {
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
;src/app/dialogs.c:30: EditorShowCursor(0);
	xor	a, a
	call	_EditorShowCursor
;src/app/dialogs.c:31: if (osk_shown) OSKShow(0);
	ld	hl, _osk_shown
	ld	a, [hl]
	or	a, a
	jp	Z, .l00105
	xor	a, a
	call	_OSKShow
.l00105:
;src/app/dialogs.c:32: OpenBox(count + first);
	ld	hl, sp+8
	ld	a, [hl]
	ld	hl, sp+0
	add	a, [hl]
	ld	c, a
	ld	a, c
	call	_OpenBox__far
;src/app/dialogs.c:33: while (1) {
.l00125:
;src/app/dialogs.c:34: render_box_sel = selected + first + 1;
	ld	hl, sp+9
	ld	a, [hl]
	ld	hl, sp+0
	add	a, [hl]
	inc	a
	ld	hl, _render_box_sel
	ld	[hl], a
;src/app/dialogs.c:35: EditorDraw();
	call	_EditorDraw
;src/app/dialogs.c:36: while (!(key = MenuKey()));
.l00106:
	call	_MenuKey__far
	ld	hl, sp+5
	ld	[hl], a
	or	a, a
	jp	Z, .l00106
;src/app/dialogs.c:37: if (key == KEY_UP) selected = selected ? selected - 1 : count - 1;
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
;src/app/dialogs.c:38: else if (key == KEY_DOWN) selected = selected == count - 1 ? 0 : selected + 1;
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
;src/app/dialogs.c:39: else if (key == KEY_ENTER) break;
	ld	hl, sp+5
	ld	a, [hl]
	sub	a, $0A
	jp	NZ,.l00227
	jp	.l00126
.l00227:
;src/app/dialogs.c:40: else if (key == KEY_ESCAPE || key == KEY_MENU) {
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
;src/app/dialogs.c:41: selected = CANCEL;
	ld	hl, sp+9
	ld	[hl], $FF
;src/app/dialogs.c:42: break;
	jp	.l00126
.l00112:
;src/app/dialogs.c:44: else if (key == KEY_BACKSPACE) {
	ld	hl, sp+5
	ld	a, [hl]
	sub	a, $08
	jp	NZ,.l00231
	jp	.l00232
.l00231:
	jp	.l00125
.l00232:
;src/app/dialogs.c:45: selected = BACK;
	ld	hl, sp+9
	ld	[hl], $FE
;src/app/dialogs.c:46: break;
.l00126:
;src/app/dialogs.c:49: HideBox();
	call	_HideBox__far
;src/app/dialogs.c:50: if (osk_shown) OSKShow(1);
	ld	hl, _osk_shown
	ld	a, [hl]
	or	a, a
	jp	Z, .l00128
	ld	a, $01
	call	_OSKShow
.l00128:
;src/app/dialogs.c:51: dirty = 1;
	ld	hl, _dirty
	ld	[hl], $01
;src/app/dialogs.c:52: return selected;
	ld	hl, sp+9
	ld	a, [hl]
.l00132:
;src/app/dialogs.c:53: }
	add	sp, 6
	pop	hl
	inc	sp
	inc	sp
	jp hl
;src/app/dialogs.c:56: void ShowMessage(const char* text) {
;	---------------------------------
	SECTION FRAGMENT "Page 6",ROMX,BANK[3]
	LOAD FRAGMENT "Page 6 RAM",SRAM,BANK[6]
; Function ShowMessage
; ---------------------------------
_ShowMessage::
;src/app/dialogs.c:57: HideBox();
	push	de
	call	_HideBox
	pop	de
;src/app/dialogs.c:58: Render();
	push	de
	call	_Render__far
	pop	de
;src/app/dialogs.c:59: EditorShowCursor(0);
	push	de
	xor	a, a
	call	_EditorShowCursor
	pop	de
;src/app/dialogs.c:60: NoHighlight();
	push	de
	call	_NoHighlight__far
	pop	de
;src/app/dialogs.c:61: if (bars) {
	ld	hl, _bars
	ld	a, [hl]
	or	a, a
	jp	Z, .l00102
;src/app/dialogs.c:62: UpdateBars();
	push	de
	call	_UpdateBars__far
	pop	de
;src/app/dialogs.c:63: DrawRow(STATUS_LINE, 1, text);
	push	de
	ld	e, $01
	ld	a, $13
	call	_DrawRow
	jp	.l00103
.l00102:
;src/app/dialogs.c:65: else DrawRow(tb_rows - 1, 0, text);
	ld	hl, _tb_rows
	ld	c, [hl]
	dec	c
	push	de
	ld	e, $00
	ld	a, c
	call	_DrawRow
.l00103:
;src/app/dialogs.c:66: EditorDraw();
	call	_EditorDraw
;src/app/dialogs.c:67: WaitDismiss();
	call	_WaitDismiss
;src/app/dialogs.c:68: dirty = 1;
	ld	hl, _dirty
	ld	[hl], $01
.l00104:
;src/app/dialogs.c:69: }
	ret
;src/app/dialogs.c:71: void ShowError(unsigned char result, const char* denied) {
;	---------------------------------
	SECTION FRAGMENT "Page 4",ROMX,BANK[2]
	LOAD FRAGMENT "Page 4 RAM",SRAM,BANK[4]
; Function ShowError
; ---------------------------------
_ShowError::
	add	sp, -17
	ld	hl, sp+16
	ld	[hl], a
	dec	hl
	dec	hl
	ld	[hl], e
	inc	hl
	ld	[hl], d
;src/app/dialogs.c:72: char text[12] = "SD ERROR ";
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
;src/app/dialogs.c:73: if (result == FR_NOT_READY) ShowMessage("NO SD CARD");
	ld	hl, sp+16
	ld	a, [hl]
	sub	a, $03
	jp	NZ,.l00140
	jp	.l00141
.l00140:
	jp	.l00111
.l00141:
	ld	de, _src_app_dialogs_c___str_1
	call	_ShowMessage__far
	jp	.l00113
.l00111:
;src/app/dialogs.c:74: else if (result == FR_NO_FILESYSTEM) ShowMessage("NO FAT VOLUME");
	ld	hl, sp+16
	ld	a, [hl]
	sub	a, $0D
	jp	NZ,.l00142
	jp	.l00143
.l00142:
	jp	.l00108
.l00143:
	ld	de, _src_app_dialogs_c___str_2
	call	_ShowMessage__far
	jp	.l00113
.l00108:
;src/app/dialogs.c:75: else if (result == FR_DENIED) ShowMessage(denied);
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
;src/app/dialogs.c:77: text[9] = '0';
	ld	hl, sp+9
	ld	[hl], $30
;src/app/dialogs.c:78: while (result >= 10) {
.l00101:
;src/app/dialogs.c:80: result -= 10;
	ld	hl, sp+16
	ld	a, [hl]
	ld	hl, sp+12
	ld	[hl], a
;src/app/dialogs.c:78: while (result >= 10) {
	ld	hl, sp+16
	ld	a, [hl]
	sub	a, $0A
	jp	C, .l00103
;src/app/dialogs.c:79: ++text[9];
	ld	hl, sp+9
	ld	a, [hl]
	ld	hl, sp+13
	ld	[hl], a
	ld	a, [hl]
	inc	a
	ld	hl, sp+9
	ld	[hl], a
;src/app/dialogs.c:80: result -= 10;
	ld	hl, sp+12
	ld	a, [hl]
	add	a, $F6
	ld	hl, sp+16
	ld	[hl], a
	jp	.l00101
.l00103:
;src/app/dialogs.c:82: text[10] = '0' + result;
	ld	hl, sp+12
	ld	a, [hl]
	add	a, $30
	dec	hl
	dec	hl
	ld	[hl], a
;src/app/dialogs.c:83: text[11] = 0;
	inc	hl
	ld	[hl], $00
;src/app/dialogs.c:84: ShowMessage(text);
	ld	hl, 0
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_ShowMessage__far
.l00113:
;src/app/dialogs.c:86: }
	add	sp, 17
	ret
	SECTION FRAGMENT "src/app/dialogs.c FIXED",ROMX,BANK[1]
_src_app_dialogs_c___str_1:
	DB "NO SD CARD"
	DB $00
	SECTION FRAGMENT "src/app/dialogs.c FIXED",ROMX,BANK[1]
_src_app_dialogs_c___str_2:
	DB "NO FAT VOLUME"
	DB $00
	SECTION FRAGMENT "src/app/dialogs.c FIXED",ROMX,BANK[1]
	SECTION FRAGMENT "_INITIALIZER",ROM0
	SECTION FRAGMENT "_CABS (ABS)",ROM0
