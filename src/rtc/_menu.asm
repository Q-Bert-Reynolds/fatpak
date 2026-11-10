;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 4.2.0 #13081 (Linux)
;--------------------------------------------------------
	; MODULE menu
	; Generated using the rgbds tokens.

;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	EXPORT _PutNumber2
	EXPORT _PutNumber
	EXPORT _PutText
	EXPORT _DrawRow
	EXPORT _RowAddress
	EXPORT _EditorDraw
	EXPORT _HideBox
	EXPORT _OpenBox
	EXPORT _MenuKey
	EXPORT _ClockWrite
	EXPORT _ClockRead
	EXPORT _ShowMessage
	EXPORT _ClockSetup
;--------------------------------------------------------
; special function registers
;--------------------------------------------------------
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	SECTION FRAGMENT "src/rtc/menu.c_DATA",WRAM0
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
	SECTION FRAGMENT "src/rtc/menu.c_HOME",ROM0
	SECTION FRAGMENT "src/rtc/menu.c_HOME",ROM0
;--------------------------------------------------------
; code
;--------------------------------------------------------
	SECTION FRAGMENT "src/rtc/menu.c_CODE",ROMX
;src/rtc/menu.c:14: void ClockSetup(void) {
;	---------------------------------
	SECTION FRAGMENT "Page 6",ROMX,BANK[3]
	LOAD FRAGMENT "Page 6 RAM",SRAM,BANK[6]
; Function ClockSetup
; ---------------------------------
_ClockSetup::
	add	sp, -16
;src/rtc/menu.c:16: unsigned char selected = 0, i, key, *value = (unsigned char*)&date;
	ld	hl, sp+8
	ld	[hl], $00
;src/rtc/menu.c:18: if (ClockRead(&date)) { date.year = 26; date.month = date.day = 1; date.hour = date.minute = date.second = 0; }
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
;src/rtc/menu.c:19: DrawRow(STATUS_LINE, 1, "Left/right: adjust  A: set  B: cancel");
	ld	de, _src_rtc_menu_c___str_0
	push	de
	ld	e, $01
	ld	a, $13
	call	_DrawRow
;src/rtc/menu.c:20: while (1) {
.l00131:
;src/rtc/menu.c:21: line = RowAddress(BOX_LINE);
	ld	a, $14
	call	_RowAddress
	ld	hl, sp+13
	ld	[hl], c
	inc	hl
	ld	[hl], b
;src/rtc/menu.c:22: for (i = 0; i < 6; ++i, line += BOX_STRIDE) {
	inc	hl
	ld	[hl], $00
.l00133:
;src/rtc/menu.c:23: end = PutText(line, " ");
	ld	bc, _src_rtc_menu_c___str_1
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
;src/rtc/menu.c:24: end = PutText(end, clock_fields[i]); *end++ = ' ';
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
	ld	hl, _src_rtc_menu_c_clock_fields
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
;src/rtc/menu.c:25: if (!i) end = PutNumber(end, 2000 + value[i]); else end = PutNumber2(end, value[i]);
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
;src/rtc/menu.c:26: *end = 0;
	xor	a, a
	ld	[bc], a
;src/rtc/menu.c:22: for (i = 0; i < 6; ++i, line += BOX_STRIDE) {
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
;src/rtc/menu.c:28: OpenBox(6); render_box_sel = selected + 1; EditorDraw();
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
;src/rtc/menu.c:29: while (!(key = MenuKey()));
.l00107:
	push	de
	call	_MenuKey
	pop	de
	ld	c, a
	or	a, a
	jp	Z, .l00107
;src/rtc/menu.c:30: if (key == KEY_ESCAPE || key == KEY_MENU) break;
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
;src/rtc/menu.c:31: if (key == KEY_UP) selected = selected ? selected - 1 : 5;
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
;src/rtc/menu.c:32: else if (key == KEY_DOWN) selected = selected == 5 ? 0 : selected + 1;
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
;src/rtc/menu.c:33: else if (key == KEY_LEFT || key == KEY_RIGHT) {
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
;src/rtc/menu.c:34: unsigned char low = selected == 1 || selected == 2 ? 1 : 0;
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
;src/rtc/menu.c:35: unsigned char high = !selected ? 99 : selected == 1 ? 12 : selected == 2 ? 31 : selected == 3 ? 23 : 59;
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
;src/rtc/menu.c:36: if (key == KEY_LEFT) value[selected] = value[selected] == low ? high : value[selected] - 1;
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
;src/rtc/menu.c:37: else value[selected] = value[selected] == high ? low : value[selected] + 1;
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
;src/rtc/menu.c:39: else if (key == KEY_ENTER) {
	ld	a, c
	sub	a, $0A
	jp	NZ,.l00303
	jp	.l00304
.l00303:
	jp	.l00131
.l00304:
;src/rtc/menu.c:40: if (!ClockWrite(&date)) break;
	ld	hl, 2
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_ClockWrite
	or	a, a
	jp	Z, .l00132
;src/rtc/menu.c:41: ShowMessage("Invalid date or clock unavailable");
	ld	de, _src_rtc_menu_c___str_2
	call	_ShowMessage
	jp	.l00131
.l00132:
;src/rtc/menu.c:44: HideBox(); bars_changed = 1; dirty = 1;
	call	_HideBox
	ld	hl, _bars_changed
	ld	[hl], $01
	ld	hl, _dirty
	ld	[hl], $01
.l00135:
;src/rtc/menu.c:45: }
	add	sp, 16
	ret
	SECTION FRAGMENT "src/rtc/menu.c FIXED",ROMX,BANK[1]
_src_rtc_menu_c_clock_fields:
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
	SECTION FRAGMENT "src/rtc/menu.c FIXED",ROMX,BANK[1]
_src_rtc_menu_c___str_0:
	DB "Left/right: adjust  A: set  B: cancel"
	DB $00
	SECTION FRAGMENT "src/rtc/menu.c FIXED",ROMX,BANK[1]
_src_rtc_menu_c___str_1:
	DB " "
	DB $00
	SECTION FRAGMENT "src/rtc/menu.c FIXED",ROMX,BANK[1]
_src_rtc_menu_c___str_2:
	DB "Invalid date or clock unavailable"
	DB $00
	SECTION FRAGMENT "src/rtc/menu.c FIXED",ROMX,BANK[1]
	SECTION FRAGMENT "_INITIALIZER",ROM0
	SECTION FRAGMENT "_CABS (ABS)",ROM0
