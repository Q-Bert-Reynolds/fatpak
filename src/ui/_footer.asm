;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 4.2.0 #13081 (Linux)
;--------------------------------------------------------
	; MODULE footer
	; Generated using the rgbds tokens.

;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	EXPORT _footer_Tick
	EXPORT _footer_Poll
	EXPORT _ClockRead
	EXPORT _CopyName
	EXPORT _PutNumber2
	EXPORT _PutNumber
	EXPORT _RenderTextWidth
	EXPORT _EditorDraw
	EXPORT _DrawRow
	EXPORT _RowAddress
	EXPORT _footer_x
	EXPORT _footer_time
	EXPORT _FooterCompose
	EXPORT _FooterDraw
;--------------------------------------------------------
; special function registers
;--------------------------------------------------------
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	SECTION FRAGMENT "src/ui/footer.c_DATA",WRAM0
_footer_time:
	DS 8
_footer_x:
	DS 1
_src_ui_footer_c_ready:
	DS 1
_src_ui_footer_c_frames:
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
	SECTION FRAGMENT "src/ui/footer.c_HOME",ROM0
	SECTION FRAGMENT "src/ui/footer.c_HOME",ROM0
;--------------------------------------------------------
; code
;--------------------------------------------------------
	SECTION FRAGMENT "src/ui/footer.c_CODE",ROMX
;src/ui/footer.c:13: unsigned char footer_Poll(void) {
;	---------------------------------
	SECTION FRAGMENT "Page 4",ROMX,BANK[2]
	LOAD FRAGMENT "Page 4 RAM",SRAM,BANK[4]
; Function footer_Poll
; ---------------------------------
_footer_Poll::
	add	sp, -19
;src/ui/footer.c:16: unsigned char hour, i, changed = !ready;
	ld	hl, _src_ui_footer_c_ready
	ld	a, [hl]
	sub	a,$01
	ld	a, $00
	rla
	ld	hl, sp+14
	ld	[hl], a
;src/ui/footer.c:17: if (ready && ++frames < 60) return 0;
	ld	hl, _src_ui_footer_c_ready
	ld	a, [hl]
	or	a, a
	jp	Z, .l00102
	ld	hl, _src_ui_footer_c_frames
	inc	[hl]
	ld	a, [hl]
	sub	a, $3C
	jp	NC, .l00102
	xor	a, a
	jp	.l00118
.l00102:
;src/ui/footer.c:18: frames = 0;
	ld	hl, _src_ui_footer_c_frames
	ld	[hl], $00
;src/ui/footer.c:19: if (ClockRead(&date)) CopyName(text, "--:--");
	ld	hl, 0
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_ClockRead
	ld	hl, sp+18
	ld	[hl], a
	ld	hl, sp+18
	ld	a, [hl]
	or	a, a
	jp	Z, .l00109
	ld	bc, _src_ui_footer_c___str_0+0
	ld	hl, sp+6
	ld	e, l
	ld	d, h
	call	_CopyName
	jp	.l00130
.l00109:
;src/ui/footer.c:21: hour = date.hour;
	ld	hl, sp+3
	ld	a, [hl]
	ld	hl, sp+18
	ld	[hl], a
;src/ui/footer.c:22: if (hour >= 12) hour -= 12;
	ld	a, [hl]
	sub	a, $0C
	jp	C, .l00105
	ld	a, [hl]
	add	a, $F4
	ld	[hl], a
.l00105:
;src/ui/footer.c:23: if (!hour) hour = 12;
	ld	hl, sp+18
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00107
	ld	[hl], $0C
.l00107:
;src/ui/footer.c:24: end = PutNumber(text, hour);
	ld	hl, sp+18
	ld	a, [hl]
	ld	hl, sp+15
	ld	[hl], a
	xor	a, a
	inc	hl
	ld	[hl], a
	inc	hl
	ld	[hl], a
	inc	hl
	ld	[hl], a
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	push	de
	ld	hl, sp+17
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	push	de
	ld	hl, 10
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_PutNumber
	ld	hl, sp+17
	ld	[hl], c
	inc	hl
	ld	[hl], b
;src/ui/footer.c:25: *end++ = ':';
	dec	hl
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	ld	[hl], $3A
	ld	hl, sp+18
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $0001
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+17
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+16
	ld	[hl], a
;src/ui/footer.c:26: end = PutNumber2(end, date.minute);
	ld	hl, sp+4
	ld	a, [hl]
	ld	hl, sp+18
	ld	[hl], a
	ld	a, [hl]
	dec	hl
	ld	[hl], a
	inc	hl
	ld	[hl], $00
	dec	hl
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	ld	hl, sp+15
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_PutNumber2__far
	ld	hl, sp+17
	ld	[hl], c
	inc	hl
	ld	[hl], b
	ld	hl, sp+17
	ld	a, [hl]
	dec	hl
	dec	hl
	ld	[hl], a
	ld	hl, sp+18
	ld	a, [hl]
	dec	hl
	dec	hl
	ld	[hl], a
;src/ui/footer.c:27: *end++ = date.hour < 12 ? 'a' : 'p';
	dec	hl
	ld	a, [hl]
	inc	hl
	inc	hl
	ld	[hl], a
	dec	hl
	ld	a, [hl]
	inc	hl
	inc	hl
	ld	[hl], a
	ld	hl, sp+15
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	inc	bc
	ld	hl, sp+3
	ld	a, [hl]
	sub	a, $0C
	jp	NC, .l00120
	ld	de, $0061
	jp	.l00121
.l00120:
	ld	de, $0070
.l00121:
	ld	a, e
	ld	hl, sp+17
	push	af
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	pop	af
	ld	[hl], a
;src/ui/footer.c:28: *end++ = 'm';
	ld	a, $6D
	ld	[bc], a
	inc	bc
;src/ui/footer.c:29: *end = 0;
	xor	a, a
	ld	[bc], a
;src/ui/footer.c:31: for (i = 0; text[i] || footer_time[i]; ++i) {
.l00130:
	ld	c, $00
.l00116:
	ld	e, c
	ld	d, $00
	ld	hl, 6
	add	hl, sp
	add	hl, de
	ld	e, [hl]
	ld	a, e
	or	a, a
	jp	NZ, .l00115
	ld	hl, _footer_time
	ld	b, $00
	add	hl, bc
	ld	a, [hl]
	or	a, a
	jp	Z, .l00113
.l00115:
;src/ui/footer.c:32: if (text[i] != footer_time[i]) { changed = 1; break; }
	ld	hl, _footer_time
	ld	b, $00
	add	hl, bc
	ld	b, [hl]
	ld	a, e
	sub	a, b
	jp	NZ,.l00167
	jp	.l00117
.l00167:
	ld	hl, sp+14
	ld	[hl], $01
	jp	.l00113
.l00117:
;src/ui/footer.c:31: for (i = 0; text[i] || footer_time[i]; ++i) {
	inc	c
	jp	.l00116
.l00113:
;src/ui/footer.c:34: CopyName(footer_time, text);
	ld	hl, 6
	add	hl, sp
	ld	c, l
	ld	b, h
	ld	de, _footer_time
	call	_CopyName
;src/ui/footer.c:35: footer_x = TB_WIDTH - 4 - RenderTextWidth(text);
	ld	hl, 6
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_RenderTextWidth
	ld	c, a
	ld	a, $9C
	sub	a, c
	ld	hl, _footer_x
	ld	[hl], a
;src/ui/footer.c:36: ready = 1;
	ld	hl, _src_ui_footer_c_ready
	ld	[hl], $01
;src/ui/footer.c:37: return changed;
	ld	hl, sp+14
	ld	a, [hl]
.l00118:
;src/ui/footer.c:38: }
	add	sp, 19
	ret
	SECTION FRAGMENT "src/ui/footer.c FIXED",ROMX,BANK[1]
_src_ui_footer_c___str_0:
	DB "--:--"
	DB $00
;src/ui/footer.c:42: void FooterCompose(char* line) {
;	---------------------------------
	SECTION FRAGMENT "Page 4",ROMX,BANK[2]
	LOAD FRAGMENT "Page 4 RAM",SRAM,BANK[4]
; Function FooterCompose
; ---------------------------------
_FooterCompose::
	add	sp, -6
	ld	hl, sp+2
	ld	[hl], e
	inc	hl
	ld	[hl], d
;src/ui/footer.c:43: unsigned char i, x = 1, width;
	inc	hl
	ld	[hl], $01
;src/ui/footer.c:45: if (!ready) footer_Poll();
	ld	hl, _src_ui_footer_c_ready
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00102
	call	_footer_Poll
.l00102:
;src/ui/footer.c:46: letter[1] = 0;
	ld	hl, sp+1
	ld	[hl], $00
;src/ui/footer.c:47: for (i = 0; i < 32; ++i) {
	ld	hl, sp+5
	ld	[hl], $00
.l00111:
;src/ui/footer.c:48: if (line[i] == 1) break;
	ld	hl, sp+3
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	inc	hl
	inc	hl
	ld	l, [hl]
	ld	h, $00
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, [bc]
	cp	a, $01
	jp	NZ,.l00177
	jp	.l00128
.l00177:
;src/ui/footer.c:49: letter[0] = line[i];
	ld	hl, sp+0
	ld	[hl], a
;src/ui/footer.c:50: width = RenderTextWidth(letter);
	ld	hl, 0
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_RenderTextWidth
	ld	c, a
;src/ui/footer.c:51: if (x + width > TB_WIDTH - 48) break;
	ld	hl, sp+4
	ld	e, [hl]
	ld	d, $00
	ld	l, c
;	spillPairReg hl
;	spillPairReg hl
	ld	h, $00
;	spillPairReg hl
;	spillPairReg hl
	add	hl, de
	ld	a, h
	ld	e, a
	ld	a, $00
	ld	d, a
	ld	a, $70
	cp	a, l
	ld	a, $00
	sbc	a, h
	bit	7, e
	jp	Z, .l00178
	bit	7, d
	jp	NZ, .l00179
	cp	a, a
	jp	.l00179
.l00178:
	bit	7, d
	jp	Z, .l00179
	scf
.l00179:
	jp	C, .l00128
;src/ui/footer.c:52: x += width;
	ld	hl, sp+4
	ld	a, [hl]
	add	a, c
	ld	[hl], a
;src/ui/footer.c:47: for (i = 0; i < 32; ++i) {
	inc	hl
	inc	[hl]
	ld	a, [hl]
	sub	a, $20
	jp	C, .l00111
.l00128:
	ld	hl, sp+5
	ld	e, [hl]
.l00114:
;src/ui/footer.c:54: for (; i < 32; ++i) line[i] = 1;
	ld	a, e
	sub	a, $20
	jp	NC, .l00108
	push	de
	ld	d, $00
	ld	hl, sp+4
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	add	hl, de
	pop	de
	ld	c, l
	ld	b, h
	ld	a, $01
	ld	[bc], a
	inc	e
	jp	.l00114
.l00108:
;src/ui/footer.c:55: line[32] = 1;
	ld	hl, sp+3
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $0020
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, $01
	ld	[bc], a
;src/ui/footer.c:56: for (i = 0; i < 7; ++i) line[33 + i] = ' ';
	ld	c, $00
.l00116:
	ld	a, c
	ld	d, $00
	add	a, $21
	ld	e, a
	jp	NC, .l00180
	inc	d
.l00180:
	ld	hl, sp+2
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	add	hl, de
	ld	e, l
	ld	d, h
	ld	a, $20
	ld	[de], a
	inc	c
	ld	a, c
	sub	a, $07
	jp	C, .l00116
;src/ui/footer.c:57: for (i = 0; footer_time[i]; ++i) line[33 + i] = footer_time[i];
	ld	c, $00
.l00119:
	ld	hl, _footer_time
	ld	b, $00
	add	hl, bc
	ld	b, [hl]
	ld	a, b
	or	a, a
	jp	Z, .l00121
	ld	a, c
	ld	d, $00
	add	a, $21
	ld	e, a
	jp	NC, .l00181
	inc	d
.l00181:
	ld	hl, sp+2
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	add	hl, de
	ld	e, l
	ld	d, h
	ld	a, b
	ld	[de], a
	inc	c
	jp	.l00119
.l00121:
;src/ui/footer.c:58: }
	add	sp, 6
	ret
;src/ui/footer.c:60: void FooterDraw(unsigned char row, unsigned char col, const char* text) {
;	---------------------------------
	SECTION FRAGMENT "Page 4",ROMX,BANK[2]
	LOAD FRAGMENT "Page 4 RAM",SRAM,BANK[4]
; Function FooterDraw
; ---------------------------------
_FooterDraw::
	ld	d, a
;src/ui/footer.c:61: DrawRow(row, col, text);
	push	de
	ld	hl, sp+4
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	push	bc
	ld	a, d
	call	_DrawRow__far
	pop	de
;src/ui/footer.c:62: FooterCompose(RowAddress(row));
	ld	a, d
	call	_RowAddress__far
	ld	e, c
	ld	d, b
	call	_FooterCompose
.l00101:
;src/ui/footer.c:63: }
	pop	hl
	inc	sp
	inc	sp
	jp hl
;src/ui/footer.c:65: void footer_Tick(void) {
;	---------------------------------
	SECTION FRAGMENT "Page 4",ROMX,BANK[2]
	LOAD FRAGMENT "Page 4 RAM",SRAM,BANK[4]
; Function footer_Tick
; ---------------------------------
_footer_Tick::
	dec	sp
;src/ui/footer.c:66: unsigned char row, line, visible = 0;
	ld	e, $00
;src/ui/footer.c:67: for (row = 0; row < TB_ROWS; ++row) {
	ld	d, $00
.l00114:
;src/ui/footer.c:68: line = render_row_lines[row];
	ld	a, LOW(_render_row_lines)
	add	a, d
	ld	l, a
;	spillPairReg hl
;	spillPairReg hl
	ld	a, HIGH(_render_row_lines)
	adc	a, $00
	ld	h, a
;	spillPairReg hl
;	spillPairReg hl
	ld	c, [hl]
;src/ui/footer.c:69: if (line == STATUS_LINE || (!render_text && RowAddress(line)[32] == 1)) visible = 1;
	ld	a, c
	sub	a, $13
	jp	NZ,.l00167
	jp	.l00101
.l00167:
	ld	hl, _render_text
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00115
	push	de
	ld	a, c
	call	_RowAddress__far
	pop	de
	ld	hl, $0020
	add	hl, bc
	ld	a, [hl]
	dec	a
	jp	NZ,.l00168
	jp	.l00169
.l00168:
	jp	.l00115
.l00169:
.l00101:
	ld	e, $01
.l00115:
;src/ui/footer.c:67: for (row = 0; row < TB_ROWS; ++row) {
	inc	d
	ld	a, d
	sub	a, $12
	jp	C, .l00114
;src/ui/footer.c:71: if (!visible || !footer_Poll()) return;
	ld	a, e
	or	a, a
	jp	Z, .l00106
	call	_footer_Poll
	or	a, a
	jp	NZ, .l00127
.l00106:
	jp	.l00118
;src/ui/footer.c:72: for (row = 0; row < TB_ROWS; ++row) {
.l00127:
	ld	e, $00
.l00116:
;src/ui/footer.c:73: line = render_row_lines[row];
	ld	hl, _render_row_lines
	ld	d, $00
	add	hl, de
	ld	a, [hl]
	ld	hl, sp+0
	ld	[hl], a
;src/ui/footer.c:74: if (line == STATUS_LINE || (!render_text && RowAddress(line)[32] == 1))
	ld	hl, sp+0
	ld	a, [hl]
	sub	a, $13
	jp	NZ,.l00170
	jp	.l00109
.l00170:
	ld	hl, _render_text
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00117
	push	de
	ld	hl, sp+2
	ld	a, [hl]
	call	_RowAddress__far
	pop	de
	ld	hl, $0020
	add	hl, bc
	ld	a, [hl]
	dec	a
	jp	NZ,.l00171
	jp	.l00172
.l00171:
	jp	.l00117
.l00172:
.l00109:
;src/ui/footer.c:75: FooterCompose(RowAddress(line));
	push	de
	ld	hl, sp+2
	ld	a, [hl]
	call	_RowAddress__far
	pop	de
	push	de
	ld	e, c
	ld	d, b
	call	_FooterCompose
	pop	de
.l00117:
;src/ui/footer.c:72: for (row = 0; row < TB_ROWS; ++row) {
	inc	e
	ld	a, e
	sub	a, $12
	jp	C, .l00116
;src/ui/footer.c:77: EditorDraw();
	inc	sp
	jp	_EditorDraw
.l00118:
;src/ui/footer.c:78: }
	inc	sp
	ret
	SECTION FRAGMENT "Page 4",ROMX,BANK[2]
	LOAD FRAGMENT "Page 4 RAM",SRAM,BANK[4]
	SECTION FRAGMENT "_INITIALIZER",ROM0
	SECTION FRAGMENT "_CABS (ABS)",ROM0
