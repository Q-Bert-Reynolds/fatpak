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
	EXPORT _DrawRow
	EXPORT _ScrollRows
	EXPORT _EditorDraw
	EXPORT _SetFont
	EXPORT _MenuKey
	EXPORT _EndFullScreen
	EXPORT _BeginView
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
;src/editor/help.c:17: static void HelpRow(unsigned char row, unsigned char line) {
;	---------------------------------
	SECTION FRAGMENT "Page 6",ROMX,BANK[3]
	LOAD FRAGMENT "Page 6 RAM",SRAM,BANK[6]
; Function HelpRow
; ---------------------------------
_src_editor_help_c_HelpRow:
	dec	sp
	dec	sp
	ld	c, a
	ld	b, e
;src/editor/help.c:18: unsigned int saved = WINDOW_BLOCK;
	ld	de, $BD02
	ld	a, [de]
	ld	hl, sp+0
	ld	[hl], a
	inc	de
	ld	a, [de]
	inc	hl
	ld	[hl], a
;src/editor/help.c:19: if (data_loaded) {
	ld	hl, _data_loaded
	ld	a, [hl]
	or	a, a
	jp	Z, .l00102
;src/editor/help.c:20: SetWindowBlock(DATA_BLOCK + DATA_HELP + (line >> 4));
	ld	a, b
	swap	a
	and	a, $0F
	ld	e, a
	ld	d, $00
	ld	hl, $0245
	add	hl, de
	ld	e, l
	ld	d, h
	push	bc
	call	_SetWindowBlock
	pop	bc
;src/editor/help.c:21: DrawRow(row, 1, (const char*)(0xBE00u + ((line & 15) << 5)));
	ld	e, b
	ld	d, $00
	ld	a, e
	and	a, $0F
	ld	l, a
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
	ld	de, $BE00
	add	hl, de
	push	hl
	ld	e, $01
	ld	a, c
	call	_DrawRow
	jp	.l00103
.l00102:
;src/editor/help.c:23: else DrawRow(row, 1, "");
	ld	de, _src_editor_help_c___str_0
	push	de
	ld	e, $01
	ld	a, c
	call	_DrawRow
.l00103:
;src/editor/help.c:24: SetWindowBlock(saved);
	pop	de
	push	de
	call	_SetWindowBlock
.l00104:
;src/editor/help.c:25: }
	inc	sp
	inc	sp
	ret
	SECTION FRAGMENT "src/editor/help.c FIXED",ROMX,BANK[1]
_src_editor_help_c___str_0:
	DB $00
;src/editor/help.c:27: static void HelpView(unsigned char browser) {
;	---------------------------------
	SECTION FRAGMENT "Page 6",ROMX,BANK[3]
	LOAD FRAGMENT "Page 6 RAM",SRAM,BANK[6]
; Function HelpView
; ---------------------------------
_src_editor_help_c_HelpView:
	add	sp, -7
	ld	c, a
;src/editor/help.c:28: unsigned char row, first = 0, next, down, key, base = browser << 5;
	ld	hl, sp+5
	ld	[hl], $00
	ld	a, c
	swap	a
	rlca
	and	a, $E0
	ld	hl, sp+0
	ld	[hl], a
;src/editor/help.c:29: unsigned char old_font = font, styled = render_text, old_osk = osk_shown;
	ld	hl, _font
	ld	a, [hl]
	ld	hl, sp+1
	ld	[hl], a
	ld	hl, _render_text
	ld	a, [hl]
	ld	hl, sp+2
	ld	[hl], a
	ld	hl, _osk_shown
	ld	a, [hl]
	ld	hl, sp+3
	ld	[hl], a
;src/editor/help.c:30: font = FONT_VWF;
	ld	hl, _font
	ld	[hl], $01
;src/editor/help.c:31: SetFont(font);
	ld	a, $01
	call	_SetFont
;src/editor/help.c:32: render_text = 0;
	ld	hl, _render_text
	ld	[hl], $00
;src/editor/help.c:33: BeginView(1);
	ld	a, $01
	call	_BeginView__far
;src/editor/help.c:34: osk_shown = 0;
	ld	hl, _osk_shown
	ld	[hl], $00
;src/editor/help.c:35: HelpRow(HEADER_LINE, base);
	ld	hl, sp+0
	ld	e, [hl]
	ld	a, $12
	call	_src_editor_help_c_HelpRow
;src/editor/help.c:36: DrawRow(STATUS_LINE, 1, "Up/Down: scroll  B: exit");
	ld	de, _src_editor_help_c___str_1
	push	de
	ld	e, $01
	ld	a, $13
	call	_DrawRow
;src/editor/help.c:37: for (row = 0; row < HELP_ROWS; ++row) HelpRow(row, base + row + 1);
	ld	hl, sp+6
	ld	[hl], $00
.l00127:
	ld	hl, sp+0
	ld	a, [hl]
	ld	hl, sp+6
	add	a, [hl]
	dec	hl
	dec	hl
	ld	[hl], a
	ld	e, [hl]
	inc	e
	inc	hl
	inc	hl
	ld	a, [hl]
	call	_src_editor_help_c_HelpRow
	ld	hl, sp+6
	inc	[hl]
	ld	a, [hl]
	sub	a, $10
	jp	C, .l00127
;src/editor/help.c:38: EditorDraw();
	call	_EditorDraw
;src/editor/help.c:39: while (1) {
.l00125:
;src/editor/help.c:40: key = MenuKey();
	call	_MenuKey
	ld	hl, sp+6
	ld	[hl], a
;src/editor/help.c:41: if (key == KEY_BACKSPACE || key == KEY_ESCAPE) break;
	ld	a, [hl]
	sub	a, $08
	jp	NZ,.l00216
	jp	.l00126
.l00216:
	ld	hl, sp+6
	ld	a, [hl]
	sub	a, $1B
	jp	NZ,.l00217
	jp	.l00126
.l00217:
;src/editor/help.c:42: next = first;
	ld	hl, sp+5
	ld	b, [hl]
;src/editor/help.c:43: if (key == KEY_UP && first) --next;
	inc	hl
	ld	a, [hl]
	sub	a, $82
	jp	NZ,.l00218
	jp	.l00219
.l00218:
	jp	.l00115
.l00219:
	ld	hl, sp+5
	ld	a, [hl]
	or	a, a
	jp	Z, .l00115
	ld	b, [hl]
	dec	b
	jp	.l00121
.l00115:
;src/editor/help.c:44: else if (key == KEY_DOWN && first < HELP_LINES - 1 - HELP_ROWS) ++next;
	ld	hl, sp+6
	ld	a, [hl]
	sub	a, $83
	jp	NZ,.l00220
	jp	.l00221
.l00220:
	jp	.l00111
.l00221:
	ld	hl, sp+5
	ld	a, [hl]
	sub	a, $0F
	jp	NC, .l00111
	inc	b
	jp	.l00121
.l00111:
;src/editor/help.c:45: else if (key == KEY_PAGE_UP) next = 0;
	ld	hl, sp+6
	ld	a, [hl]
	sub	a, $86
	jp	NZ,.l00222
	jp	.l00223
.l00222:
	jp	.l00108
.l00223:
	ld	b, $00
	jp	.l00121
.l00108:
;src/editor/help.c:46: else if (key == KEY_PAGE_DOWN) next = HELP_LINES - 1 - HELP_ROWS;
	ld	hl, sp+6
	ld	a, [hl]
	sub	a, $87
	jp	NZ,.l00224
	jp	.l00225
.l00224:
	jp	.l00121
.l00225:
	ld	b, $0F
;src/editor/help.c:47: while (first != next) {
.l00121:
	ld	hl, sp+5
	ld	a, [hl]
	sub	a, b
	jp	NZ,.l00226
	jp	.l00125
.l00226:
;src/editor/help.c:48: down = next > first;
	ld	hl, sp+5
	ld	a, [hl]
	sub	a, b
	ld	a, $00
	rla
	ld	c, a
;src/editor/help.c:49: if (down) ++first; else --first;
	ld	a, c
	or	a, a
	jp	Z, .l00119
	inc	[hl]
	jp	.l00120
.l00119:
	ld	hl, sp+5
	dec	[hl]
.l00120:
;src/editor/help.c:50: ScrollRows(down);
	push	bc
	ld	a, c
	call	_ScrollRows__far
	pop	bc
;src/editor/help.c:51: HelpRow(down ? HELP_ROWS - 1 : 0, base + first + (down ? HELP_ROWS : 1));
	ld	hl, sp+0
	ld	a, [hl]
	ld	hl, sp+5
	add	a, [hl]
	ld	e, a
	ld	a, c
	or	a, a
	jp	Z, .l00131
	ld	hl, $0010
	jp	.l00132
.l00131:
	ld	hl, $0001
.l00132:
	add	hl, de
	ld	a, c
	or	a, a
	jp	Z, .l00133
	ld	de, $000F
	jp	.l00134
.l00133:
	ld	de, $0000
.l00134:
	ld	c, e
	push	bc
	ld	e, l
	ld	a, c
	call	_src_editor_help_c_HelpRow
	pop	bc
;src/editor/help.c:52: EditorDraw();
	push	bc
	call	_EditorDraw
	pop	bc
	jp	.l00121
.l00126:
;src/editor/help.c:55: font = old_font;
	ld	hl, sp+1
	ld	a, [hl]
	ld	hl, _font
	ld	[hl], a
;src/editor/help.c:56: SetFont(font);
	ld	a, [hl]
	call	_SetFont
;src/editor/help.c:57: render_text = styled;
	ld	hl, sp+2
	ld	a, [hl]
	ld	hl, _render_text
	ld	[hl], a
;src/editor/help.c:58: osk_shown = old_osk;
	ld	hl, sp+3
	ld	a, [hl]
	ld	hl, _osk_shown
	ld	[hl], a
;src/editor/help.c:59: EndFullScreen();
	call	_EndFullScreen
.l00129:
;src/editor/help.c:60: }
	add	sp, 7
	ret
	SECTION FRAGMENT "src/editor/help.c FIXED",ROMX,BANK[1]
_src_editor_help_c___str_1:
	DB "Up/Down: scroll  B: exit"
	DB $00
;src/editor/help.c:62: void ShowHelp(void) { HelpView(0); }
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
;src/editor/help.c:63: void ShowBrowserHelp(void) { HelpView(1); }
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
