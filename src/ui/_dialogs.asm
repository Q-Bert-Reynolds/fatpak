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
	EXPORT _WaitFrame
	EXPORT _RowAddress
	EXPORT _RenderTextWidth
	EXPORT _EditorDraw
	EXPORT _KBPopEvent
	EXPORT _KBPeekKey
	EXPORT _PadPressed
	EXPORT _WaitDismiss
	EXPORT _OpenBox
	EXPORT _ShowBusy
	EXPORT _HideBox
;--------------------------------------------------------
; special function registers
;--------------------------------------------------------
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	SECTION FRAGMENT "src/ui/dialogs.c_DATA",WRAM0
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
	SECTION FRAGMENT "src/ui/dialogs.c_HOME",ROM0
	SECTION FRAGMENT "src/ui/dialogs.c_HOME",ROM0
;--------------------------------------------------------
; code
;--------------------------------------------------------
	SECTION FRAGMENT "src/ui/dialogs.c_CODE",ROMX
;src/ui/dialogs.c:11: void WaitDismiss(void) {
;	---------------------------------
	SECTION FRAGMENT "Page 6",ROMX,BANK[3]
	LOAD FRAGMENT "Page 6 RAM",SRAM,BANK[6]
; Function WaitDismiss
; ---------------------------------
_WaitDismiss::
;src/ui/dialogs.c:13: while (1) {
.l00109:
;src/ui/dialogs.c:14: WaitFrame();
	call	_WaitFrame
;src/ui/dialogs.c:15: if ((key = KBPeekKey())) {
	call	_KBPeekKey
	ld	c, a
	or	a, a
	jp	Z, .l00105
;src/ui/dialogs.c:16: if (key == KEY_ESCAPE || key == KEY_ENTER) KBPopEvent();
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
;src/ui/dialogs.c:17: return;
	jp	.l00111
.l00105:
;src/ui/dialogs.c:19: if (PadPressed()) return;
	call	_PadPressed
	or	a, a
	jp	Z, .l00109
.l00111:
;src/ui/dialogs.c:21: }
	ret
;src/ui/dialogs.c:24: void OpenBox(unsigned char lines) {
;	---------------------------------
	SECTION FRAGMENT "Page 6",ROMX,BANK[3]
	LOAD FRAGMENT "Page 6 RAM",SRAM,BANK[6]
; Function OpenBox
; ---------------------------------
_OpenBox::
	ld	e, a
;src/ui/dialogs.c:25: char* line = RowAddress(BOX_LINE);
	push	de
	ld	a, $14
	call	_RowAddress
	pop	de
;src/ui/dialogs.c:26: unsigned char i, width, widest = 0;
	ld	d, $00
;src/ui/dialogs.c:27: for (i = 0; i < lines; ++i, line += BOX_STRIDE) {
	ld	l, $00
;	spillPairReg hl
;	spillPairReg hl
.l00105:
	ld	a, l
	sub	a, e
	jp	NC, .l00103
;src/ui/dialogs.c:28: width = RenderTextWidth(line);
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
;src/ui/dialogs.c:29: if (width > widest) widest = width;
	ld	a, d
	sub	a, h
	jp	NC, .l00106
	ld	d, h
.l00106:
;src/ui/dialogs.c:27: for (i = 0; i < lines; ++i, line += BOX_STRIDE) {
	inc	l
	ld	a, c
	add	a, $14
	ld	c, a
	jp	NC, .l00125
	inc	b
.l00125:
	jp	.l00105
.l00103:
;src/ui/dialogs.c:31: render_box_text = RowAddress(BOX_LINE);
	push	de
	ld	a, $14
	call	_RowAddress
	pop	de
	ld	hl, _render_box_text
	ld	[hl], c
	inc	hl
	ld	[hl], b
;src/ui/dialogs.c:32: render_box_w = widest + BOX_PADDING;
	ld	a, d
	add	a, $09
	ld	hl, _render_box_w
	ld	[hl], a
;src/ui/dialogs.c:33: render_box_x = (TB_WIDTH - render_box_w) >> 1;
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
;src/ui/dialogs.c:34: render_box_rows = lines + 2; // half rows above and below
	ld	a, e
	add	a, $02
	ld	hl, _render_box_rows
	ld	[hl], a
;src/ui/dialogs.c:35: render_box_top = (TB_ROWS - render_box_rows) >> 1;
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
;src/ui/dialogs.c:36: render_box_sel = 0xFF;
	ld	hl, _render_box_sel
	ld	[hl], $FF
;src/ui/dialogs.c:37: ++render_box_gen;
	ld	hl, _render_box_gen
	inc	[hl]
.l00107:
;src/ui/dialogs.c:38: }
	ret
;src/ui/dialogs.c:41: void ShowBusy(const char* text) {
;	---------------------------------
	SECTION FRAGMENT "Page 4",ROMX,BANK[2]
	LOAD FRAGMENT "Page 4 RAM",SRAM,BANK[4]
; Function ShowBusy
; ---------------------------------
_ShowBusy::
	ld	c, e
	ld	b, d
;src/ui/dialogs.c:42: CopyName(RowAddress(BOX_LINE), text);
	push	bc
	ld	a, $14
	call	_RowAddress__far
	ld	e, c
	ld	d, b
	pop	bc
	call	_CopyName__far
;src/ui/dialogs.c:43: OpenBox(1);
	ld	a, $01
	call	_OpenBox__far
;src/ui/dialogs.c:44: EditorDraw();
	jp	_EditorDraw
.l00101:
;src/ui/dialogs.c:45: }
	ret
;src/ui/dialogs.c:47: void HideBox(void) {
;	---------------------------------
	SECTION FRAGMENT "Page 6",ROMX,BANK[3]
	LOAD FRAGMENT "Page 6 RAM",SRAM,BANK[6]
; Function HideBox
; ---------------------------------
_HideBox::
;src/ui/dialogs.c:48: render_box_top = 0xFF;
	ld	hl, _render_box_top
	ld	[hl], $FF
.l00101:
;src/ui/dialogs.c:49: }
	ret
	SECTION FRAGMENT "Page 6",ROMX,BANK[3]
	LOAD FRAGMENT "Page 6 RAM",SRAM,BANK[6]
	SECTION FRAGMENT "_INITIALIZER",ROM0
	SECTION FRAGMENT "_CABS (ABS)",ROM0
