;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 4.2.0 #13081 (Linux)
;--------------------------------------------------------
	; MODULE osk
	; Generated using the rgbds tokens.

;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	EXPORT _PadPressed
	EXPORT _DpadRepeat
	EXPORT _SetRows
	EXPORT _UndoRedo
	EXPORT _OSKGetKey
	EXPORT _OSKSelect
	EXPORT _OSKDraw
	EXPORT _pad_mods
	EXPORT _osk_y
	EXPORT _osk_x
	EXPORT _osk_layer
	EXPORT _osk_shown
	EXPORT _osk_blocks
	EXPORT _PadKey
;--------------------------------------------------------
; special function registers
;--------------------------------------------------------
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	SECTION FRAGMENT "src/editor/osk.c_DATA",WRAM0
_osk_blocks:
	DS 5
_osk_shown:
	DS 1
_osk_layer:
	DS 1
_osk_x:
	DS 1
_osk_y:
	DS 1
_pad_mods:
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
	SECTION FRAGMENT "src/editor/osk.c_HOME",ROM0
	SECTION FRAGMENT "src/editor/osk.c_HOME",ROM0
;--------------------------------------------------------
; code
;--------------------------------------------------------
	SECTION FRAGMENT "src/editor/osk.c_CODE",ROMX
;src/editor/osk.c:23: static void PickOSKBlocks(void) {
;	---------------------------------
	SECTION FRAGMENT "Page 5",ROMX,BANK[2]
	LOAD FRAGMENT "Page 5 RAM",SRAM,BANK[5]
; Function PickOSKBlocks
; ---------------------------------
_src_editor_osk_c_PickOSKBlocks:
	add	sp, -6
;src/editor/osk.c:24: unsigned char i, j, row, length = tb_rows + render_gbc, rows = tb_rows - OSK_ROWS, shift = 0;
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
;src/editor/osk.c:25: if (tb_found_row != 0xFF && tb_found_row >= rows) shift = tb_found_row - rows + 1;
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
;src/editor/osk.c:26: row = rows + shift; // hidden: the rows below the ones that stay, then the ones scrolled off the top
	ld	a, c
	ld	hl, sp+1
	add	a, [hl]
	ld	hl, sp+4
	ld	[hl], a
;src/editor/osk.c:27: for (j = 0; j < OSK_ROWS; ++j) {
	inc	hl
	ld	[hl], $00
.l00119:
;src/editor/osk.c:28: if (row == tb_rows) row = 0;
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
;src/editor/osk.c:29: i = ring_pos + row;
	ld	hl, _ring_pos
	ld	a, [hl]
	ld	hl, sp+4
	add	a, [hl]
	ld	c, a
;src/editor/osk.c:30: if (i >= length) i -= length;
	ld	a, c
	ld	hl, sp+0
	sub	a, [hl]
	jp	C, .l00107
	ld	a, c
	sub	a, [hl]
	ld	c, a
.l00107:
;src/editor/osk.c:31: osk_blocks[j] = ring_blocks[i];
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
;src/editor/osk.c:32: if (osk_blocks[j] == HEADER_BLOCK || osk_blocks[j] == STATUS_BLOCK) {
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
;src/editor/osk.c:33: for (j = 0; j < OSK_ROWS; ++j) osk_blocks[j] = OSK_BLOCK + j;
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
;src/editor/osk.c:34: return;
	jp	.l00121
.l00110:
;src/editor/osk.c:36: ++row;
	ld	hl, sp+4
	inc	[hl]
;src/editor/osk.c:27: for (j = 0; j < OSK_ROWS; ++j) {
	inc	hl
	inc	[hl]
	ld	a, [hl]
	sub	a, $05
	jp	C, .l00119
;src/editor/osk.c:38: if (!shift) return;
	ld	hl, sp+1
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00114
	jp	.l00121
.l00114:
;src/editor/osk.c:39: ring_pos += shift;
	ld	hl, _ring_pos
	ld	a, [hl]
	ld	hl, sp+1
	add	a, [hl]
	ld	hl, _ring_pos
	ld	[hl], a
;src/editor/osk.c:40: if (ring_pos >= length) ring_pos -= length;
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
;src/editor/osk.c:41: ring_top = (ring_top + shift) & (BG_MAP_ROWS - 1);
	ld	hl, _ring_top
	ld	a, [hl]
	ld	hl, sp+1
	add	a, [hl]
	and	a, $1F
	ld	hl, _ring_top
	ld	[hl], a
;src/editor/osk.c:42: top = tb_row_starts[shift];
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
;src/editor/osk.c:43: }
	add	sp, 6
	ret
;src/editor/osk.c:45: static void ToggleOSK(void) {
;	---------------------------------
	SECTION FRAGMENT "Page 6",ROMX,BANK[3]
	LOAD FRAGMENT "Page 6 RAM",SRAM,BANK[6]
; Function ToggleOSK
; ---------------------------------
_src_editor_osk_c_ToggleOSK:
;src/editor/osk.c:46: osk_shown = !osk_shown;
	ld	hl, _osk_shown
	ld	a, [hl]
	sub	a,$01
	ld	a, $00
	rla
	ld	[hl], a
;src/editor/osk.c:47: if (osk_shown) PickOSKBlocks();
	ld	a, [hl]
	or	a, a
	jp	Z, .l00102
	call	_src_editor_osk_c_PickOSKBlocks__far
.l00102:
;src/editor/osk.c:48: SetRows();
	jp	_SetRows__far
.l00103:
;src/editor/osk.c:49: }
	ret
;src/editor/osk.c:51: static void SetOSKLayer(unsigned char layer) {
;	---------------------------------
	SECTION FRAGMENT "Page 6",ROMX,BANK[3]
	LOAD FRAGMENT "Page 6 RAM",SRAM,BANK[6]
; Function SetOSKLayer
; ---------------------------------
_src_editor_osk_c_SetOSKLayer:
	ld	c, a
;src/editor/osk.c:52: osk_layer = osk_layer == layer ? OSK_LOWER : layer;
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
;src/editor/osk.c:53: OSKDraw(osk_layer, tb_rows);
	ld	hl, _tb_rows
	ld	e, [hl]
	ld	hl, _osk_layer
	ld	a, [hl]
	call	_OSKDraw
;src/editor/osk.c:54: dirty = 1;
	ld	hl, _dirty
	ld	[hl], $01
.l00101:
;src/editor/osk.c:55: }
	ret
;src/editor/osk.c:57: static unsigned char PressOSKKey(void) {
;	---------------------------------
	SECTION FRAGMENT "Page 6",ROMX,BANK[3]
	LOAD FRAGMENT "Page 6 RAM",SRAM,BANK[6]
; Function PressOSKKey
; ---------------------------------
_src_editor_osk_c_PressOSKKey:
;src/editor/osk.c:59: if (osk_y == OSK_ROWS - 1) {
	ld	hl, _osk_y
	ld	a, [hl]
	sub	a, $04
	jp	NZ,.l00179
	jp	.l00180
.l00179:
	jp	.l00124
.l00180:
;src/editor/osk.c:60: if (osk_x == 0) SetOSKLayer(OSK_SHIFT);
	ld	hl, _osk_x
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00121
	ld	a, $01
	call	_src_editor_osk_c_SetOSKLayer
	jp	.l00122
.l00121:
;src/editor/osk.c:61: else if (osk_x == 1) SetOSKLayer(OSK_SYMBOLS);
	ld	hl, _osk_x
	ld	a, [hl]
	dec	a
	jp	NZ,.l00181
	jp	.l00182
.l00181:
	jp	.l00118
.l00182:
	ld	a, $02
	call	_src_editor_osk_c_SetOSKLayer
	jp	.l00122
.l00118:
;src/editor/osk.c:62: else if (osk_x == 2) return KEY_MENU;
	ld	hl, _osk_x
	ld	a, [hl]
	sub	a, $02
	jp	NZ,.l00183
	jp	.l00184
.l00183:
	jp	.l00115
.l00184:
	ld	a, $89
	jp	.l00127
.l00115:
;src/editor/osk.c:63: else if (osk_x == OSK_COLS - 3) { if (render_text) UndoRedo(0); }
	ld	hl, _osk_x
	ld	a, [hl]
	sub	a, $07
	jp	NZ,.l00185
	jp	.l00186
.l00185:
	jp	.l00112
.l00186:
	ld	hl, _render_text
	ld	a, [hl]
	or	a, a
	jp	Z, .l00122
	xor	a, a
	call	_UndoRedo
	jp	.l00122
.l00112:
;src/editor/osk.c:64: else if (osk_x == OSK_COLS - 2) { if (render_text) UndoRedo(1); }
	ld	hl, _osk_x
	ld	a, [hl]
	sub	a, $08
	jp	NZ,.l00187
	jp	.l00188
.l00187:
	jp	.l00109
.l00188:
	ld	hl, _render_text
	ld	a, [hl]
	or	a, a
	jp	Z, .l00122
	ld	a, $01
	call	_UndoRedo
	jp	.l00122
.l00109:
;src/editor/osk.c:65: else if (osk_x == OSK_COLS - 1) return KEY_ENTER;
	ld	hl, _osk_x
	ld	a, [hl]
	sub	a, $09
	jp	NZ,.l00189
	jp	.l00190
.l00189:
	jp	.l00106
.l00190:
	ld	a, $0A
	jp	.l00127
.l00106:
;src/editor/osk.c:66: else return ' ';
	ld	a, $20
	jp	.l00127
.l00122:
;src/editor/osk.c:67: return KEY_NONE;
	xor	a, a
	jp	.l00127
.l00124:
;src/editor/osk.c:69: key = OSKGetKey(osk_layer, (osk_y << 3) + (osk_y << 1) + osk_x);
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
;src/editor/osk.c:70: if (osk_layer == OSK_SHIFT) SetOSKLayer(OSK_SHIFT); // shift is one shot
	ld	hl, _osk_layer
	ld	a, [hl]
	dec	a
	jp	NZ,.l00191
	jp	.l00192
.l00191:
	jp	.l00126
.l00192:
	push	bc
	ld	a, $01
	call	_src_editor_osk_c_SetOSKLayer
	pop	bc
.l00126:
;src/editor/osk.c:71: return key;
	ld	a, c
.l00127:
;src/editor/osk.c:72: }
	ret
;src/editor/osk.c:74: static void MoveOSKSelection(unsigned char held) {
;	---------------------------------
	SECTION FRAGMENT "Page 6",ROMX,BANK[3]
	LOAD FRAGMENT "Page 6 RAM",SRAM,BANK[6]
; Function MoveOSKSelection
; ---------------------------------
_src_editor_osk_c_MoveOSKSelection:
	ld	c, a
;src/editor/osk.c:75: if (held & PADF_UP) osk_y = osk_y ? osk_y - 1 : OSK_ROWS - 1;
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
;src/editor/osk.c:76: else if (held & PADF_DOWN) osk_y = osk_y == OSK_ROWS - 1 ? 0 : osk_y + 1;
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
;src/editor/osk.c:77: if (held & PADF_LEFT) osk_x = osk_x ? osk_x - 1 : OSK_COLS - 1;
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
;src/editor/osk.c:78: else if (held & PADF_RIGHT) osk_x = osk_x == OSK_COLS - 1 ? 0 : osk_x + 1;
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
;src/editor/osk.c:79: OSKSelect(osk_x, osk_y);
	ld	hl, _osk_y
	ld	e, [hl]
	ld	hl, _osk_x
	ld	a, [hl]
	jp	_OSKSelect
.l00111:
;src/editor/osk.c:80: }
	ret
;src/editor/osk.c:82: unsigned char PadKey(void) {
;	---------------------------------
	SECTION FRAGMENT "Page 6",ROMX,BANK[3]
	LOAD FRAGMENT "Page 6 RAM",SRAM,BANK[6]
; Function PadKey
; ---------------------------------
_PadKey::
;src/editor/osk.c:83: unsigned char pressed = PadPressed();
	call	_PadPressed
	ld	c, a
;src/editor/osk.c:85: pad_mods = 0;
	ld	hl, _pad_mods
	ld	[hl], $00
;src/editor/osk.c:86: if (pressed & PADF_SELECT) ToggleOSK();
	bit	2, c
	jp	NZ,.l00185
	jp	.l00102
.l00185:
	push	bc
	call	_src_editor_osk_c_ToggleOSK
	pop	bc
.l00102:
;src/editor/osk.c:87: if (pressed & PADF_B) return KEY_BACKSPACE;
	bit	1, c
	jp	NZ,.l00186
	jp	.l00104
.l00186:
	ld	a, $08
	jp	.l00123
.l00104:
;src/editor/osk.c:88: if (pressed & PADF_START) return KEY_MENU;
	bit	3, c
	jp	NZ,.l00187
	jp	.l00106
.l00187:
	ld	a, $89
	jp	.l00123
.l00106:
;src/editor/osk.c:89: if (osk_shown && (pressed & PADF_A)) return PressOSKKey();
	ld	hl, _osk_shown
	ld	a, [hl]
	or	a, a
	jp	Z, .l00108
	bit	0, c
	jp	NZ,.l00188
	jp	.l00108
.l00188:
	jp	_src_editor_osk_c_PressOSKKey
	jp	.l00123
.l00108:
;src/editor/osk.c:90: held = DpadRepeat(pressed);
	ld	a, c
	call	_DpadRepeat
	ld	c, a
;src/editor/osk.c:91: if (!held) return KEY_NONE;
	ld	a, c
	or	a, a
	jp	NZ, .l00111
	xor	a, a
	jp	.l00123
.l00111:
;src/editor/osk.c:92: if (!osk_shown && (button_state & PADF_A)) pad_mods = KB_MOD_SHIFT;
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
;src/editor/osk.c:93: if (osk_shown) {
	ld	hl, _osk_shown
	ld	a, [hl]
	or	a, a
	jp	Z, .l00116
;src/editor/osk.c:94: MoveOSKSelection(held);
	ld	a, c
	call	_src_editor_osk_c_MoveOSKSelection
;src/editor/osk.c:95: return KEY_NONE;
	xor	a, a
	jp	.l00123
.l00116:
;src/editor/osk.c:97: if (held & PADF_UP) return KEY_UP;
	bit	6, c
	jp	NZ,.l00190
	jp	.l00118
.l00190:
	ld	a, $82
	jp	.l00123
.l00118:
;src/editor/osk.c:98: if (held & PADF_DOWN) return KEY_DOWN;
	bit	7, c
	jp	NZ,.l00191
	jp	.l00120
.l00191:
	ld	a, $83
	jp	.l00123
.l00120:
;src/editor/osk.c:99: if (held & PADF_LEFT) return KEY_LEFT;
	bit	5, c
	jp	NZ,.l00192
	jp	.l00122
.l00192:
	ld	a, $80
	jp	.l00123
.l00122:
;src/editor/osk.c:100: return KEY_RIGHT;
	ld	a, $81
.l00123:
;src/editor/osk.c:101: }
	ret
	SECTION FRAGMENT "Page 6",ROMX,BANK[3]
	LOAD FRAGMENT "Page 6 RAM",SRAM,BANK[6]
	SECTION FRAGMENT "_INITIALIZER",ROM0
	SECTION FRAGMENT "_CABS (ABS)",ROM0
