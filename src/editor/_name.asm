;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 4.2.0 #13081 (Linux)
;--------------------------------------------------------
	; MODULE name
	; Generated using the rgbds tokens.

;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	EXPORT _SetWindowBlock
	EXPORT _CopyName
	EXPORT _PutText
	EXPORT _WaitFrame
	EXPORT _DrawRow
	EXPORT _NoHighlight
	EXPORT _EditorDraw
	EXPORT _KBPopEvent
	EXPORT _PutPath
	EXPORT _ToUtf8
	EXPORT _ToLatin1
	EXPORT _PadKey
	EXPORT _EditorShowCursor
	EXPORT _name_row
	EXPORT _AskName
;--------------------------------------------------------
; special function registers
;--------------------------------------------------------
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	SECTION FRAGMENT "src/editor/name.c_DATA",WRAM0
_name_row:
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
	SECTION FRAGMENT "src/editor/name.c_HOME",ROM0
	SECTION FRAGMENT "src/editor/name.c_HOME",ROM0
;--------------------------------------------------------
; code
;--------------------------------------------------------
	SECTION FRAGMENT "src/editor/name.c_CODE",ROMX
;src/editor/name.c:17: static void NameHistory(char* name, unsigned int index) {
;	---------------------------------
	SECTION FRAGMENT "Page 14",ROMX,BANK[7]
	LOAD FRAGMENT "Page 14 RAM",SRAM,BANK[14]
; Function NameHistory
; ---------------------------------
_src_editor_name_c_NameHistory:
	add	sp, -4
	ld	hl, sp+2
	ld	[hl], e
	inc	hl
	ld	[hl], d
;src/editor/name.c:18: unsigned int saved = WINDOW_BLOCK;
	ld	de, $BD02
	ld	a, [de]
	ld	hl, sp+0
	ld	[hl], a
	inc	de
	ld	a, [de]
	inc	hl
	ld	[hl], a
;src/editor/name.c:19: char* slot = (char*)(0xBE00u + ((index & 3) << 7));
	ld	a, c
	and	a, $03
	ld	e, a
	ld	d, $00
	xor	a, a
	rr	d
	ld	d, e
	rr	d
	rra
	ld	e, a
	ld	a, d
	add	a, $BE
	ld	d, a
;src/editor/name.c:20: SetWindowBlock(NAME_HISTORY_BLOCK + ((index >> 2) & 15));
	ld	l, c
	ld	h, b
	srl	h
	rr	l
	srl	h
	rr	l
	ld	a, l
	and	a, $0F
	ld	h, $00
;	spillPairReg hl
;	spillPairReg hl
	add	a, $4D
	ld	l, a
;	spillPairReg hl
;	spillPairReg hl
	ld	a, h
	adc	a, $02
	ld	h, a
;	spillPairReg hl
;	spillPairReg hl
	push	bc
	push	de
	ld	e, l
	ld	d, h
	call	_SetWindowBlock
	pop	de
	pop	bc
;src/editor/name.c:21: if (index & 0x100) CopyName(name, slot);
	bit	0, b
	jp	NZ,.l00111
	jp	.l00102
.l00111:
	ld	c, e
	ld	b, d
	pop	hl
	pop	de
	push	de
	push	hl
	call	_CopyName__far
	jp	.l00103
.l00102:
;src/editor/name.c:22: else CopyName(slot, name);
	pop	hl
	pop	bc
	push	bc
	push	hl
	call	_CopyName__far
.l00103:
;src/editor/name.c:23: SetWindowBlock(saved);
	pop	de
	push	de
	call	_SetWindowBlock
.l00104:
;src/editor/name.c:24: }
	add	sp, 4
	ret
;src/editor/name.c:26: static unsigned char NameChar(unsigned char c) {
;	---------------------------------
	SECTION FRAGMENT "Page 12",ROMX,BANK[6]
	LOAD FRAGMENT "Page 12 RAM",SRAM,BANK[12]
; Function NameChar
; ---------------------------------
_src_editor_name_c_NameChar:
	ld	c, a
;src/editor/name.c:27: if (c < ' ' || (c >= 0x7F && c < 0xA0)) return 0;
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
;src/editor/name.c:28: return c != '/' && c != 0x5C && c != ':' && c != '*' && c != '?' && c != '"' && c != '<' && c != '>' && c != '|';
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
;src/editor/name.c:29: }
	ret
;src/editor/name.c:33: unsigned char AskName(char* value, const char* prompt) {
;	---------------------------------
	SECTION FRAGMENT "Page 4",ROMX,BANK[2]
	LOAD FRAGMENT "Page 4 RAM",SRAM,BANK[4]
; Function AskName
; ---------------------------------
_AskName::
	add	sp, -122
	ld	hl, sp+120
	ld	[hl], e
	inc	hl
	ld	[hl], d
	ld	hl, sp+118
	ld	[hl], c
	inc	hl
	ld	[hl], b
;src/editor/name.c:37: unsigned char length, bytes, i, key, current = 0, first = 0, last = 0, changed = 0;
	ld	hl, sp+106
	ld	[hl], $00
	inc	hl
	ld	[hl], $00
	inc	hl
	ld	[hl], $00
	inc	hl
	ld	[hl], $00
;src/editor/name.c:38: length = (unsigned char)(ToLatin1(name, value, FS_NAME_SIZE - 1) - name);
	ld	a, $40
	push	af
	inc	sp
	ld	hl, sp+121
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	ld	hl, 1
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_ToLatin1
	ld	a, c
	ld	hl, 0
	add	hl, sp
	sub	a, l
	ld	e, a
;src/editor/name.c:39: name[length] = 0;
	ld	d, $00
	ld	hl, 0
	add	hl, sp
	add	hl, de
	ld	[hl], $00
;src/editor/name.c:40: NameHistory(name, 0);
	ld	bc, $0000
	ld	hl, 0
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_src_editor_name_c_NameHistory__far
;src/editor/name.c:41: EditorShowCursor(0);
	xor	a, a
	call	_EditorShowCursor
;src/editor/name.c:42: NoHighlight();
	call	_NoHighlight__far
;src/editor/name.c:43: while (1) {
.l00148:
;src/editor/name.c:44: for (length = bytes = 0; name[length]; ++length) bytes += (unsigned char)name[length] >= 0x80 ? 2 : 1;
	ld	hl, sp+110
	ld	[hl], $00
	ld	c, $00
.l00153:
	ld	e, c
	ld	d, $00
	ld	hl, 0
	add	hl, sp
	add	hl, de
	ld	a, [hl]
	or	a, a
	jp	Z, .l00212
	sub	a, $80
	jp	C, .l00160
	ld	de, $0002
	jp	.l00161
.l00160:
	ld	de, $0001
.l00161:
	ld	hl, sp+110
	ld	a, [hl]
	add	a, e
	ld	[hl], a
	inc	c
	jp	.l00153
.l00212:
	ld	hl, sp+111
	ld	[hl], c
;src/editor/name.c:45: end = prompt ? PutText(text, prompt) : text;
	ld	hl, sp+119
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	jp	Z, .l00162
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	ld	hl, 65
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_PutText__far
	ld	hl, sp+116
	ld	[hl], c
	inc	hl
	ld	[hl], b
	jp	.l00163
.l00162:
	ld	hl, 65
	add	hl, sp
	push	hl
	ld	a, l
	ld	hl, sp+118
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+117
	ld	[hl], a
.l00163:
	ld	hl, sp+116
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
;src/editor/name.c:46: for (i = length > 31 ? length - 31 : 0; i < length; ++i) *end++ = name[i];
	ld	a, $1F
	ld	hl, sp+111
	sub	a, [hl]
	jp	NC, .l00164
	ld	a, [hl]
	add	a, $E1
	ld	e, a
	rlca
	sbc	a, a
	jp	.l00165
.l00164:
	ld	e, $00
	xor	a, a
.l00165:
.l00156:
	ld	hl, $0001
	add	hl, bc
	push	hl
	ld	a, l
	ld	hl, sp+118
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+117
	ld	[hl], a
	ld	a, e
	ld	hl, sp+111
	sub	a, [hl]
	jp	NC, .l00102
	push	de
	ld	d, $00
	ld	hl, 2
	add	hl, sp
	add	hl, de
	pop	de
	ld	a, [hl]
	ld	[bc], a
	ld	hl, sp+116
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	inc	e
	jp	.l00156
.l00102:
;src/editor/name.c:47: *end++ = '_';
	ld	a, $5F
	ld	[bc], a
	ld	hl, sp+116
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
;src/editor/name.c:48: *end = 0;
	xor	a, a
	ld	[bc], a
;src/editor/name.c:49: if (!prompt) DrawRow(name_row, 1, text);
	inc	hl
	inc	hl
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	jp	NZ, .l00107
	ld	hl, 65
	add	hl, sp
	push	hl
	ld	e, $01
	ld	hl, _name_row
	ld	a, [hl]
	call	_DrawRow__far
	jp	.l00108
.l00107:
;src/editor/name.c:51: DrawRow(bars ? HEADER_LINE : 0, bars, text);
	ld	hl, _bars
	ld	a, [hl]
	or	a, a
	jp	Z, .l00166
	ld	de, $0012
	jp	.l00167
.l00166:
	ld	de, $0000
.l00167:
	ld	c, e
	ld	hl, 65
	add	hl, sp
	ld	e, l
	ld	d, h
	push	de
	ld	hl, _bars
	ld	e, [hl]
	ld	a, c
	call	_DrawRow__far
;src/editor/name.c:52: if (bars && render_text) {
	ld	hl, _bars
	ld	a, [hl]
	or	a, a
	jp	Z, .l00108
	ld	hl, _render_text
	ld	a, [hl]
	or	a, a
	jp	Z, .l00108
;src/editor/name.c:53: PutPath(PutText(text, "in "), file_dir, 28);
	ld	bc, _src_editor_name_c___str_0
	ld	hl, 65
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_PutText__far
	ld	e, c
	ld	d, b
	ld	a, $1C
	push	af
	inc	sp
	ld	bc, _file_dir
	call	_PutPath
;src/editor/name.c:54: DrawRow(STATUS_LINE, 1, text);
	ld	hl, 65
	add	hl, sp
	push	hl
	ld	e, $01
	ld	a, $13
	call	_DrawRow__far
.l00108:
;src/editor/name.c:57: EditorDraw();
	call	_EditorDraw
;src/editor/name.c:58: do {
.l00117:
;src/editor/name.c:59: WaitFrame();
	call	_WaitFrame
;src/editor/name.c:60: event = KBPopEvent();
	call	_KBPopEvent
;src/editor/name.c:61: key = (unsigned char)event;
	ld	hl, sp+112
	ld	[hl], c
;src/editor/name.c:62: if (event & ((unsigned int)KB_MOD_CTRL << 8)) {
	bit	5, b
	jp	NZ,.l00350
	jp	.l00114
.l00350:
;src/editor/name.c:63: if (key == 'z' || key == 'Z') key = event & ((unsigned int)KB_MOD_SHIFT << 8) ? KEY_REDO : KEY_UNDO;
	ld	hl, sp+112
	ld	a, [hl]
	sub	a, $7A
	jp	NZ,.l00351
	jp	.l00109
.l00351:
	ld	hl, sp+112
	ld	a, [hl]
	sub	a, $5A
	jp	NZ,.l00352
	jp	.l00353
.l00352:
	jp	.l00110
.l00353:
.l00109:
	bit	6, b
	jp	NZ,.l00354
	jp	.l00168
.l00354:
	ld	de, $008B
	jp	.l00169
.l00168:
	ld	de, $008A
.l00169:
	ld	hl, sp+112
	ld	[hl], e
	jp	.l00114
.l00110:
;src/editor/name.c:64: else key = key == 'y' || key == 'Y' ? KEY_REDO : 0;
	ld	hl, sp+112
	ld	a, [hl]
	sub	a, $79
	jp	NZ,.l00355
	jp	.l00173
.l00355:
	ld	hl, sp+112
	ld	a, [hl]
	sub	a, $59
	jp	NZ,.l00356
	jp	.l00357
.l00356:
	jp	.l00170
.l00357:
.l00173:
	ld	de, $008B
	jp	.l00171
.l00170:
	ld	de, $0000
.l00171:
	ld	hl, sp+112
	ld	[hl], e
.l00114:
;src/editor/name.c:66: if (!event) key = PadKey();
	ld	a, b
	or	a, c
	jp	NZ, .l00118
	call	_PadKey__far
	ld	hl, sp+112
	ld	[hl], a
.l00118:
;src/editor/name.c:67: } while (!key);
	ld	hl, sp+112
	ld	a, [hl]
	or	a, a
	jp	Z, .l00117
;src/editor/name.c:68: if (key == KEY_ENTER && length) break;
	ld	a, [hl]
	sub	a, $0A
	jp	NZ,.l00358
	jp	.l00359
.l00358:
	jp	.l00121
.l00359:
	ld	hl, sp+111
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00149
.l00121:
;src/editor/name.c:69: if (key == KEY_ESCAPE || key == KEY_MENU || (key == KEY_BACKSPACE && !length)) return 0;
	ld	hl, sp+112
	ld	a, [hl]
	sub	a, $1B
	jp	NZ,.l00360
	jp	.l00123
.l00360:
	ld	hl, sp+112
	ld	a, [hl]
	sub	a, $89
	jp	NZ,.l00361
	jp	.l00123
.l00361:
	ld	hl, sp+112
	ld	a, [hl]
	sub	a, $08
	jp	NZ,.l00362
	ld	a,$01
	jp	.l00363
.l00362:
	xor	a,a
.l00363:
	ld	hl, sp+113
	ld	[hl], a
	ld	a, [hl]
	or	a, a
	jp	Z, .l00124
	dec	hl
	dec	hl
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00124
.l00123:
	xor	a, a
	jp	.l00158
.l00124:
;src/editor/name.c:70: if (key == KEY_UNDO || key == KEY_REDO) {
	ld	hl, sp+112
	ld	a, [hl]
	sub	a, $8A
	jp	NZ,.l00364
	ld	a,$01
	jp	.l00365
.l00364:
	xor	a,a
.l00365:
	ld	hl, sp+114
	ld	[hl], a
	dec	hl
	dec	hl
	ld	a, [hl]
	sub	a, $8B
	jp	NZ,.l00366
	ld	a,$01
	jp	.l00367
.l00366:
	xor	a,a
.l00367:
	ld	hl, sp+115
	ld	[hl], a
;src/editor/name.c:71: if (key == KEY_UNDO && current != first) current = (current - 1) & 63;
	ld	hl, sp+106
	ld	a, [hl]
	ld	hl, sp+116
	ld	[hl], a
;src/editor/name.c:72: else if (key == KEY_REDO && current != last) current = (current + 1) & 63;
	ld	a, [hl]
	inc	a
	inc	hl
	ld	[hl], a
	ld	a, [hl]
	and	a, $3F
	ld	[hl], a
;src/editor/name.c:70: if (key == KEY_UNDO || key == KEY_REDO) {
	ld	hl, sp+114
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00135
	inc	hl
	ld	a, [hl]
	or	a, a
	jp	Z, .l00136
.l00135:
;src/editor/name.c:71: if (key == KEY_UNDO && current != first) current = (current - 1) & 63;
	ld	hl, sp+114
	ld	a, [hl]
	or	a, a
	jp	Z, .l00132
	ld	hl, sp+106
	ld	a, [hl]
	inc	hl
	sub	a, [hl]
	jp	NZ,.l00368
	jp	.l00132
.l00368:
	ld	hl, sp+116
	ld	a, [hl]
	dec	a
	and	a, $3F
	ld	hl, sp+106
	ld	[hl], a
	jp	.l00133
.l00132:
;src/editor/name.c:72: else if (key == KEY_REDO && current != last) current = (current + 1) & 63;
	ld	hl, sp+115
	ld	a, [hl]
	or	a, a
	jp	Z, .l00133
	ld	hl, sp+106
	ld	a, [hl]
	inc	hl
	inc	hl
	sub	a, [hl]
	jp	NZ,.l00369
	jp	.l00133
.l00369:
	ld	hl, sp+117
	ld	a, [hl]
	ld	hl, sp+106
	ld	[hl], a
.l00133:
;src/editor/name.c:73: NameHistory(name, 0x100u | current);
	ld	hl, sp+106
	ld	c, [hl]
	ld	b, $00
	set	0, b
	ld	hl, 0
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_src_editor_name_c_NameHistory__far
;src/editor/name.c:74: continue;
	jp	.l00148
.l00136:
;src/editor/name.c:76: if (key == KEY_BACKSPACE) --length;
	ld	hl, sp+113
	ld	a, [hl]
	or	a, a
	jp	Z, .l00143
	dec	hl
	dec	hl
	ld	c, [hl]
	dec	c
	jp	.l00144
.l00143:
;src/editor/name.c:77: else if (bytes + (key >= 0x80 ? 2 : 1) <= FS_NAME_SIZE - 1 && NameChar(key)) name[length++] = key;
	ld	hl, sp+110
	ld	a, [hl]
	ld	hl, sp+115
	ld	[hl], a
	inc	hl
	ld	[hl], $00
	ld	hl, sp+112
	ld	a, [hl]
	sub	a, $80
	jp	C, .l00175
	ld	de, $0002
	jp	.l00176
.l00175:
	ld	de, $0001
.l00176:
	ld	hl, sp+115
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, b
	ld	e, a
	ld	a, $00
	ld	d, a
	ld	a, $40
	cp	a, c
	ld	a, $00
	sbc	a, b
	bit	7, e
	jp	Z, .l00370
	bit	7, d
	jp	NZ, .l00371
	cp	a, a
	jp	.l00371
.l00370:
	bit	7, d
	jp	Z, .l00371
	scf
.l00371:
	jp	C, .l00148
	ld	hl, sp+112
	ld	a, [hl]
	call	_src_editor_name_c_NameChar__far
	or	a, a
	jp	Z, .l00148
	ld	hl, sp+111
	ld	e, [hl]
	ld	c, [hl]
	inc	c
	ld	d, $00
	ld	hl, 0
	add	hl, sp
	add	hl, de
	ld	e, l
	ld	d, h
	ld	hl, sp+112
	ld	a, [hl]
	ld	[de], a
;src/editor/name.c:78: else continue;
.l00144:
;src/editor/name.c:79: name[length] = 0;
	ld	e, c
	ld	d, $00
	ld	hl, 0
	add	hl, sp
	add	hl, de
	ld	[hl], $00
;src/editor/name.c:80: current = (current + 1) & 63;
	ld	hl, sp+117
	ld	a, [hl]
	ld	hl, sp+106
	ld	[hl], a
;src/editor/name.c:81: if (current == first) first = (first + 1) & 63;
	ld	a, [hl]
	inc	hl
	sub	a, [hl]
	jp	NZ,.l00372
	jp	.l00373
.l00372:
	jp	.l00146
.l00373:
	ld	hl, sp+107
	ld	a, [hl]
	inc	a
	and	a, $3F
	ld	[hl], a
.l00146:
;src/editor/name.c:82: last = current;
	ld	hl, sp+106
	ld	a, [hl]
	inc	hl
	inc	hl
	ld	[hl], a
;src/editor/name.c:83: NameHistory(name, current);
	dec	hl
	dec	hl
	ld	c, [hl]
	ld	b, $00
	ld	hl, 0
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_src_editor_name_c_NameHistory__far
;src/editor/name.c:84: changed = 1;
	ld	hl, sp+109
	ld	[hl], $01
	jp	.l00148
.l00149:
;src/editor/name.c:86: if (!changed) return 2;
	ld	hl, sp+109
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00151
	ld	a, $02
	jp	.l00158
.l00151:
;src/editor/name.c:87: ToUtf8(value, name);
	ld	hl, 0
	add	hl, sp
	ld	c, l
	ld	b, h
	ld	hl, sp+120
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_ToUtf8
;src/editor/name.c:88: dirty = 1;
	ld	hl, _dirty
	ld	[hl], $01
;src/editor/name.c:89: return 1;
	ld	a, $01
.l00158:
;src/editor/name.c:90: }
	add	sp, 122
	ret
	SECTION FRAGMENT "src/editor/name.c FIXED",ROMX,BANK[1]
_src_editor_name_c___str_0:
	DB "in "
	DB $00
	SECTION FRAGMENT "src/editor/name.c FIXED",ROMX,BANK[1]
	SECTION FRAGMENT "_INITIALIZER",ROM0
	SECTION FRAGMENT "_CABS (ABS)",ROM0
