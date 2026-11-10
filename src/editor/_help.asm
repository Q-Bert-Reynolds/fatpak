;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 4.2.0 #13081 (Linux)
;--------------------------------------------------------
	; MODULE help
	; Generated using the rgbds tokens.

;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	EXPORT _SetWindowBlock
	EXPORT _CopyName
	EXPORT _FooterDraw
	EXPORT _DrawRow
	EXPORT _RowAddress
	EXPORT _EditorDraw
	EXPORT _SetFont
	EXPORT _MenuKey
	EXPORT _EndFullScreen
	EXPORT _BeginFullScreen
	EXPORT _ShowHelp
	EXPORT _ShowBrowserHelp
;--------------------------------------------------------
; special function registers
;--------------------------------------------------------
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	SECTION FRAGMENT "src/editor/help.c_DATA",WRAM0
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
	SECTION FRAGMENT "src/editor/help.c_HOME",ROM0
	SECTION FRAGMENT "src/editor/help.c_HOME",ROM0
;--------------------------------------------------------
; code
;--------------------------------------------------------
	SECTION FRAGMENT "src/editor/help.c_CODE",ROMX
;src/editor/help.c:15: static void HelpView(unsigned char browser) {
;	---------------------------------
	SECTION FRAGMENT "Page 6",ROMX,BANK[3]
	LOAD FRAGMENT "Page 6 RAM",SRAM,BANK[6]
; Function HelpView
; ---------------------------------
_src_editor_help_c_HelpView:
	add	sp, -7
	ld	hl, sp+4
	ld	[hl], a
;src/editor/help.c:16: unsigned char row, line, first = 0, key, old_font = font, styled = render_text;
	inc	hl
	ld	[hl], $00
	ld	hl, _font
	ld	a, [hl]
	ld	hl, sp+0
	ld	[hl], a
	ld	hl, _render_text
	ld	a, [hl]
	ld	hl, sp+1
	ld	[hl], a
;src/editor/help.c:18: font = FONT_VWF;
	ld	hl, _font
	ld	[hl], $01
;src/editor/help.c:19: SetFont(font);
	ld	a, $01
	call	_SetFont
;src/editor/help.c:20: render_text = 0;
	ld	hl, _render_text
	ld	[hl], $00
;src/editor/help.c:21: BeginFullScreen();
	call	_BeginFullScreen
;src/editor/help.c:22: while (1) {
.l00124:
;src/editor/help.c:23: saved = WINDOW_BLOCK;
	ld	de, $BD02
	ld	a, [de]
	ld	hl, sp+2
	ld	[hl], a
	inc	de
	ld	a, [de]
	inc	hl
	ld	[hl], a
;src/editor/help.c:24: for (row = 0; row < HELP_ROWS; ++row) {
	ld	hl, sp+6
	ld	[hl], $00
.l00126:
;src/editor/help.c:25: DrawRow(row, 0, "");
	ld	de, _src_editor_help_c___str_0
	push	de
	ld	e, $00
	ld	hl, sp+8
	ld	a, [hl]
	call	_DrawRow
;src/editor/help.c:26: line = first + row;
	ld	hl, sp+5
	ld	a, [hl]
	inc	hl
	add	a, [hl]
	ld	c, a
;src/editor/help.c:27: if (data_loaded) {
	ld	hl, _data_loaded
	ld	a, [hl]
	or	a, a
	jp	Z, .l00127
;src/editor/help.c:28: SetWindowBlock(DATA_BLOCK + DATA_HELP + (browser << 1) + (line >> 4));
	ld	hl, sp+4
	ld	a, [hl]
	ld	b, $00
	ld	l, a
	ld	h, b
	add	hl, hl
	ld	de, $0245
	add	hl, de
	ld	a, c
	swap	a
	and	a, $0F
	ld	d, $00
	ld	e, a
	add	hl, de
	ld	e, l
	ld	d, h
	push	bc
	call	_SetWindowBlock
	pop	bc
;src/editor/help.c:29: CopyName(RowAddress(row), (const char*)(0xBE00u + ((line & 15) << 5)));
	ld	a, c
	ld	c, $00
	and	a, $0F
	ld	h, $00
;	spillPairReg hl
;	spillPairReg hl
	ld	l, a
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	ld	c, l
	ld	a, h
	add	a, $BE
	ld	b, a
	push	bc
	ld	hl, sp+8
	ld	a, [hl]
	call	_RowAddress
	ld	e, c
	ld	d, b
	pop	bc
	call	_CopyName__far
.l00127:
;src/editor/help.c:24: for (row = 0; row < HELP_ROWS; ++row) {
	ld	hl, sp+6
	inc	[hl]
	ld	a, [hl]
	sub	a, $11
	jp	C, .l00126
;src/editor/help.c:32: SetWindowBlock(saved);
	pop	hl
	pop	de
	push	de
	push	hl
	call	_SetWindowBlock
;src/editor/help.c:33: FooterDraw(HELP_ROWS, 0, "Up/Down: scroll  B: exit");
	ld	de, _src_editor_help_c___str_1
	push	de
	ld	e, $00
	ld	a, $11
	call	_FooterDraw__far
;src/editor/help.c:34: EditorDraw();
	call	_EditorDraw
;src/editor/help.c:35: do { key = MenuKey(); } while (!key);
.l00104:
	call	_MenuKey
	ld	c, a
	ld	a, c
	or	a, a
	jp	Z, .l00104
;src/editor/help.c:36: if (key == KEY_BACKSPACE || key == KEY_ESCAPE) break;
	ld	a, c
	sub	a, $08
	jp	NZ,.l00201
	jp	.l00125
.l00201:
	ld	a, c
	sub	a, $1B
	jp	NZ,.l00202
	jp	.l00125
.l00202:
;src/editor/help.c:37: if (key == KEY_UP && first) --first;
	ld	a, c
	sub	a, $82
	jp	NZ,.l00203
	jp	.l00204
.l00203:
	jp	.l00120
.l00204:
	ld	hl, sp+5
	ld	a, [hl]
	or	a, a
	jp	Z, .l00120
	dec	[hl]
	jp	.l00124
.l00120:
;src/editor/help.c:38: else if (key == KEY_DOWN && first < HELP_LINES - HELP_ROWS) ++first;
	ld	a, c
	sub	a, $83
	jp	NZ,.l00205
	jp	.l00206
.l00205:
	jp	.l00116
.l00206:
	ld	hl, sp+5
	ld	a, [hl]
	sub	a, $0F
	jp	NC, .l00116
	inc	[hl]
	jp	.l00124
.l00116:
;src/editor/help.c:39: else if (key == KEY_PAGE_UP) first = 0;
	ld	a, c
	sub	a, $86
	jp	NZ,.l00207
	jp	.l00208
.l00207:
	jp	.l00113
.l00208:
	ld	hl, sp+5
	ld	[hl], $00
	jp	.l00124
.l00113:
;src/editor/help.c:40: else if (key == KEY_PAGE_DOWN) first = HELP_LINES - HELP_ROWS;
	ld	a, c
	sub	a, $87
	jp	NZ,.l00209
	jp	.l00210
.l00209:
	jp	.l00124
.l00210:
	ld	hl, sp+5
	ld	[hl], $0F
	jp	.l00124
.l00125:
;src/editor/help.c:42: font = old_font;
	ld	hl, sp+0
	ld	a, [hl]
	ld	hl, _font
	ld	[hl], a
;src/editor/help.c:43: SetFont(font);
	ld	a, [hl]
	call	_SetFont
;src/editor/help.c:44: render_text = styled;
	ld	hl, sp+1
	ld	a, [hl]
	ld	hl, _render_text
	ld	[hl], a
;src/editor/help.c:45: EndFullScreen();
	call	_EndFullScreen
.l00128:
;src/editor/help.c:46: }
	add	sp, 7
	ret
	SECTION FRAGMENT "src/editor/help.c FIXED",ROMX,BANK[1]
_src_editor_help_c___str_0:
	DB $00
	SECTION FRAGMENT "src/editor/help.c FIXED",ROMX,BANK[1]
_src_editor_help_c___str_1:
	DB "Up/Down: scroll  B: exit"
	DB $00
;src/editor/help.c:48: void ShowHelp(void) { HelpView(0); }
;	---------------------------------
	SECTION FRAGMENT "Page 6",ROMX,BANK[3]
	LOAD FRAGMENT "Page 6 RAM",SRAM,BANK[6]
; Function ShowHelp
; ---------------------------------
_ShowHelp::
	xor	a, a
	jp	_src_editor_help_c_HelpView
.l00101:
	ret
;src/editor/help.c:49: void ShowBrowserHelp(void) { HelpView(1); }
;	---------------------------------
	SECTION FRAGMENT "Page 6",ROMX,BANK[3]
	LOAD FRAGMENT "Page 6 RAM",SRAM,BANK[6]
; Function ShowBrowserHelp
; ---------------------------------
_ShowBrowserHelp::
	ld	a, $01
	jp	_src_editor_help_c_HelpView
.l00101:
	ret
	SECTION FRAGMENT "Page 6",ROMX,BANK[3]
	LOAD FRAGMENT "Page 6 RAM",SRAM,BANK[6]
	SECTION FRAGMENT "_INITIALIZER",ROM0
	SECTION FRAGMENT "_CABS (ABS)",ROM0
