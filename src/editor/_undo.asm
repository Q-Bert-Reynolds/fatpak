;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 4.2.0 #13081 (Linux)
;--------------------------------------------------------
	; MODULE undo
	; Generated using the rgbds tokens.

;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	EXPORT _undo_Redo
	EXPORT _undo_Undo
	EXPORT _undo_Saved
	EXPORT _undo_Deleting
	EXPORT _undo_Inserted
	EXPORT _undo_Clear
	EXPORT _log_RestoreText
	EXPORT _log_SaveText
	EXPORT _log_Read
	EXPORT _log_Write
	EXPORT _tb_DeleteRange
	EXPORT _tb_Insert
	EXPORT _tb_GetChar
	EXPORT _rec
	EXPORT _undo_at_save
	EXPORT _undo_cursor
	EXPORT _undo_join
	EXPORT _undo_merge
	EXPORT _undo_last
	EXPORT _undo_saved
	EXPORT _undo_top
	EXPORT _undo_head
	EXPORT _undo_tail
;--------------------------------------------------------
; special function registers
;--------------------------------------------------------
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	SECTION FRAGMENT "src/editor/undo.c_DATA",WRAM0
_undo_tail:
	DS 2
_undo_head:
	DS 2
_undo_top:
	DS 2
_undo_saved:
	DS 2
_undo_last:
	DS 2
_undo_merge:
	DS 1
_undo_join:
	DS 1
_undo_cursor:
	DS 2
_undo_at_save:
	DS 1
_rec:
	DS 5
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
	SECTION FRAGMENT "src/editor/undo.c_HOME",ROM0
	SECTION FRAGMENT "src/editor/undo.c_HOME",ROM0
;--------------------------------------------------------
; code
;--------------------------------------------------------
	SECTION FRAGMENT "src/editor/undo.c_CODE",ROMX
;src/editor/undo.c:41: static unsigned int Forward(unsigned int offset, unsigned int count) {
;	---------------------------------
	SECTION FRAGMENT "Page 15",ROMX,BANK[7]
	LOAD FRAGMENT "Page 15 RAM",SRAM,BANK[15]
; Function Forward
; ---------------------------------
_Forward:
	ld	l, c
;	spillPairReg hl
;	spillPairReg hl
	ld	h, b
;	spillPairReg hl
;	spillPairReg hl
;src/editor/undo.c:42: unsigned int room = UNDO_SIZE - offset;
	xor	a, a
	sub	a, e
	ld	c, a
	ld	a, $E0
	sbc	a, d
	ld	b, a
;src/editor/undo.c:43: return count >= room ? count - room : offset + count;
	ld	a, l
	sub	a, c
	ld	a, h
	sbc	a, b
	jp	C, .l00103
	ld	a, l
	sub	a, c
	ld	c, a
	ld	a, h
	sbc	a, b
	ld	b, a
	jp	.l00104
.l00103:
	add	hl, de
	ld	c, l
	ld	b, h
.l00104:
.l00101:
;src/editor/undo.c:44: }
	ret
;src/editor/undo.c:46: static unsigned int Back(unsigned int offset, unsigned int count) {
;	---------------------------------
	SECTION FRAGMENT "Page 15",ROMX,BANK[7]
	LOAD FRAGMENT "Page 15 RAM",SRAM,BANK[15]
; Function Back
; ---------------------------------
_Back:
;src/editor/undo.c:47: return offset >= count ? offset - count : offset + (UNDO_SIZE - count);
	ld	a, e
	sub	a, c
	ld	a, d
	sbc	a, b
	jp	C, .l00103
	ld	a, e
	sub	a, c
	ld	c, a
	ld	a, d
	sbc	a, b
	ld	b, a
	jp	.l00104
.l00103:
	xor	a, a
	sub	a, c
	ld	l, a
;	spillPairReg hl
;	spillPairReg hl
	ld	a, $E0
	sbc	a, b
	ld	h, a
;	spillPairReg hl
;	spillPairReg hl
	add	hl, de
	ld	c, l
	ld	b, h
.l00104:
.l00101:
;src/editor/undo.c:48: }
	ret
;src/editor/undo.c:51: static unsigned int Used(unsigned int offset) {
;	---------------------------------
	SECTION FRAGMENT "Page 15",ROMX,BANK[7]
	LOAD FRAGMENT "Page 15 RAM",SRAM,BANK[15]
; Function Used
; ---------------------------------
_Used:
;src/editor/undo.c:52: return Back(offset, undo_tail);
	ld	hl, _undo_tail
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	jp	_Back
.l00101:
;src/editor/undo.c:53: }
	ret
;src/editor/undo.c:56: static unsigned char Reserve(unsigned int count) {
;	---------------------------------
	SECTION FRAGMENT "Page 15",ROMX,BANK[7]
	LOAD FRAGMENT "Page 15 RAM",SRAM,BANK[15]
; Function Reserve
; ---------------------------------
_Reserve:
	dec	sp
	dec	sp
;src/editor/undo.c:58: if (count >= UNDO_SIZE) return 0;
	ld	a, d
	sub	a, $E0
	jp	C, .l00107
	xor	a, a
	jp	.l00110
;src/editor/undo.c:59: while (count >= UNDO_SIZE - Used(undo_head)) {
.l00107:
	push	de
	ld	hl, _undo_head
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_Used
	pop	de
	xor	a, a
	sub	a, c
	ld	c, a
	ld	a, $E0
	sbc	a, b
	ld	b, a
	ld	a, e
	sub	a, c
	ld	a, d
	sbc	a, b
	jp	C, .l00109
;src/editor/undo.c:60: if (undo_tail == undo_saved) undo_saved = UNDO_NONE;
	ld	hl, _undo_tail
	ld	a, [hl]
	ld	hl, _undo_saved
	sub	a, [hl]
	jp	NZ,.l00137
	ld	hl, _undo_tail + 1
	ld	a, [hl]
	ld	hl, _undo_saved + 1
	sub	a, [hl]
	jp	NZ,.l00137
	jp	.l00138
.l00137:
	jp	.l00104
.l00138:
	ld	hl, _undo_saved
	ld	[hl], $FF
	inc	hl
	ld	[hl], $FF
.l00104:
;src/editor/undo.c:61: if (undo_tail == undo_last) undo_merge = 0;
	ld	hl, _undo_tail
	ld	a, [hl]
	ld	hl, _undo_last
	sub	a, [hl]
	jp	NZ,.l00139
	ld	hl, _undo_tail + 1
	ld	a, [hl]
	ld	hl, _undo_last + 1
	sub	a, [hl]
	jp	NZ,.l00139
	jp	.l00140
.l00139:
	jp	.l00106
.l00140:
	ld	hl, _undo_merge
	ld	[hl], $00
.l00106:
;src/editor/undo.c:62: log_ptr = undo_tail;
	ld	hl, _undo_tail
	ld	a, [hl]
	ld	hl, _log_ptr
	ld	[hl], a
	ld	hl, _undo_tail + 1
	ld	a, [hl]
	ld	hl, _log_ptr + 1
	ld	[hl], a
;src/editor/undo.c:63: log_Read(&length, 2);
	push	de
	ld	bc, $0002
	ld	hl, 2
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_log_Read
	pop	de
;src/editor/undo.c:64: undo_tail = Forward(undo_tail, length + UNDO_EXTRA);
	push	de
	ld	hl, sp+3
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $0007
	add	hl, de
	pop	de
	ld	c, l
	ld	b, h
	push	de
	ld	hl, _undo_tail
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_Forward
	pop	de
	ld	hl, _undo_tail
	ld	[hl], c
	inc	hl
	ld	[hl], b
	jp	.l00107
.l00109:
;src/editor/undo.c:66: return 1;
	ld	a, $01
.l00110:
;src/editor/undo.c:67: }
	inc	sp
	inc	sp
	ret
;src/editor/undo.c:70: static void Push(unsigned char type, unsigned int pos, unsigned int count) {
;	---------------------------------
	SECTION FRAGMENT "Page 15",ROMX,BANK[7]
	LOAD FRAGMENT "Page 15 RAM",SRAM,BANK[15]
; Function Push
; ---------------------------------
_Push:
	dec	sp
	ld	hl, sp+0
	ld	[hl], a
;src/editor/undo.c:71: if (Used(undo_saved) > Used(undo_head)) undo_saved = UNDO_NONE; // it was undone, redo is lost
	push	de
	ld	hl, _undo_saved
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_Used
	pop	de
	push	bc
	push	de
	ld	hl, _undo_head
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_Used
	ld	l, c
;	spillPairReg hl
;	spillPairReg hl
	ld	h, b
;	spillPairReg hl
;	spillPairReg hl
	pop	de
	pop	bc
	ld	a, l
	sub	a, c
	ld	a, h
	sbc	a, b
	jp	NC, .l00102
	ld	hl, _undo_saved
	ld	[hl], $FF
	inc	hl
	ld	[hl], $FF
.l00102:
;src/editor/undo.c:72: undo_top = undo_head;
	ld	hl, _undo_head
	ld	a, [hl]
	ld	hl, _undo_top
	ld	[hl], a
	ld	hl, _undo_head + 1
	ld	a, [hl]
	ld	hl, _undo_top + 1
	ld	[hl], a
;src/editor/undo.c:73: if (!Reserve(count + UNDO_EXTRA)) { // too big, older records can't be undone past it
	push	de
	ld	hl, sp+6
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $0007
	add	hl, de
	pop	de
	ld	c, l
	ld	b, h
	push	de
	ld	e, c
	ld	d, b
	call	_Reserve
	pop	de
	or	a, a
	jp	NZ, .l00104
;src/editor/undo.c:74: undo_tail = undo_top = undo_head;
	ld	hl, _undo_head
	ld	a, [hl]
	inc	hl
	ld	c, [hl]
	ld	hl, _undo_top
	ld	[hl], a
	inc	hl
	ld	[hl], c
	ld	hl, _undo_tail
	ld	[hl], a
	inc	hl
	ld	[hl], c
;src/editor/undo.c:75: undo_saved = UNDO_NONE;
	ld	hl, _undo_saved
	ld	[hl], $FF
	inc	hl
	ld	[hl], $FF
;src/editor/undo.c:76: undo_merge = 0;
	ld	hl, _undo_merge
	ld	[hl], $00
;src/editor/undo.c:77: return;
	jp	.l00105
.l00104:
;src/editor/undo.c:79: rec.length = count;
	ld	bc, _rec+0
	ld	hl, sp+3
	ld	a, [hl]
	ld	[bc], a
	inc	bc
	inc	hl
	ld	a, [hl]
	ld	[bc], a
;src/editor/undo.c:80: rec.type = type | (undo_join ? UNDO_JOIN : 0);
	ld	bc, _rec + 2
	ld	hl, _undo_join
	ld	a, [hl]
	or	a, a
	jp	Z, .l00107
	ld	a, $80
	ld	l, $00
;	spillPairReg hl
;	spillPairReg hl
	jp	.l00108
.l00107:
	xor	a, a
	ld	l, a
;	spillPairReg hl
;	spillPairReg hl
.l00108:
	ld	hl, sp+0
	or	a, [hl]
	ld	[bc], a
;src/editor/undo.c:81: rec.pos = pos;
	ld	hl, _rec + 3
	ld	[hl], e
	inc	hl
	ld	[hl], d
;src/editor/undo.c:82: undo_last = log_ptr = undo_head;
	ld	hl, _undo_head
	ld	a, [hl]
	inc	hl
	ld	c, [hl]
	ld	hl, _log_ptr
	ld	[hl], a
	inc	hl
	ld	[hl], c
	ld	hl, _undo_last
	ld	[hl], a
	inc	hl
	ld	[hl], c
;src/editor/undo.c:83: log_Write(&rec, UNDO_HEADER);
	push	de
	ld	bc, $0005
	ld	de, _rec
	call	_log_Write
	pop	de
;src/editor/undo.c:84: log_SaveText(pos, count);
	ld	hl, sp+3
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	call	_log_SaveText
;src/editor/undo.c:85: log_Write(&count, 2);
	ld	hl, sp+3
	ld	e, l
	ld	d, h
	ld	bc, $0002
	call	_log_Write
;src/editor/undo.c:86: undo_head = undo_top = log_ptr;
	ld	hl, _log_ptr
	ld	a, [hl]
	inc	hl
	ld	c, [hl]
	ld	hl, _undo_top
	ld	[hl], a
	inc	hl
	ld	[hl], c
	ld	hl, _undo_head
	ld	[hl], a
	inc	hl
	ld	[hl], c
;src/editor/undo.c:87: undo_join = 0;
	ld	hl, _undo_join
	ld	[hl], $00
;src/editor/undo.c:88: undo_merge = count == 1;
	ld	hl, sp+3
	ld	a, [hl]
	dec	a
	inc	hl
	or	a, [hl]
	jp	NZ,.l00124
	ld	a,$01
	jp	.l00125
.l00124:
	xor	a,a
.l00125:
	ld	hl, _undo_merge
	ld	[hl], a
.l00105:
;src/editor/undo.c:89: }
	inc	sp
	pop	hl
	inc	sp
	inc	sp
	jp hl
;src/editor/undo.c:92: static unsigned char CanMerge(unsigned char ok) {
;	---------------------------------
	SECTION FRAGMENT "Page 15",ROMX,BANK[7]
	LOAD FRAGMENT "Page 15 RAM",SRAM,BANK[15]
; Function CanMerge
; ---------------------------------
_CanMerge:
	ld	c, a
;src/editor/undo.c:93: return ok && undo_merge && Reserve(1) && undo_merge;
	ld	a, c
	or	a, a
	jp	Z, .l00103
	ld	hl, _undo_merge
	ld	a, [hl]
	or	a, a
	jp	Z, .l00103
	ld	de, $0001
	call	_Reserve
	or	a, a
	jp	Z, .l00103
	ld	hl, _undo_merge
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00104
.l00103:
	xor	a, a
	jp	.l00105
.l00104:
	ld	a, $01
.l00105:
.l00101:
;src/editor/undo.c:94: }
	ret
;src/editor/undo.c:97: static void Merge(unsigned int pos) {
;	---------------------------------
	SECTION FRAGMENT "Page 15",ROMX,BANK[7]
	LOAD FRAGMENT "Page 15 RAM",SRAM,BANK[15]
; Function Merge
; ---------------------------------
_Merge:
;src/editor/undo.c:98: log_ptr = Back(undo_head, 2);
	push	de
	ld	bc, $0002
	ld	hl, _undo_head
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_Back
	pop	de
	ld	hl, _log_ptr
	ld	[hl], c
	inc	hl
	ld	[hl], b
;src/editor/undo.c:99: log_SaveText(pos, 1);
	ld	bc, $0001
	call	_log_SaveText
;src/editor/undo.c:100: ++rec.length;
	ld	hl, _rec + 0
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	inc	bc
	ld	hl, _rec
	ld	[hl], c
	inc	hl
	ld	[hl], b
;src/editor/undo.c:101: log_Write(&rec.length, 2);
	ld	bc, $0002
	ld	de, _rec
	call	_log_Write
;src/editor/undo.c:102: undo_head = undo_top = log_ptr;
	ld	hl, _log_ptr
	ld	a, [hl]
	inc	hl
	ld	c, [hl]
	ld	hl, _undo_top
	ld	[hl], a
	inc	hl
	ld	[hl], c
	ld	hl, _undo_head
	ld	[hl], a
	inc	hl
	ld	[hl], c
;src/editor/undo.c:103: log_ptr = undo_last;
	ld	hl, _undo_last
	ld	a, [hl]
	ld	hl, _log_ptr
	ld	[hl], a
	ld	hl, _undo_last + 1
	ld	a, [hl]
	ld	hl, _log_ptr + 1
	ld	[hl], a
;src/editor/undo.c:104: log_Write(&rec, UNDO_HEADER);
	ld	bc, $0005
	ld	de, _rec
	jp	_log_Write
.l00101:
;src/editor/undo.c:105: }
	ret
;src/editor/undo.c:107: static unsigned char IsSpace(unsigned char c) {
;	---------------------------------
	SECTION FRAGMENT "Page 15",ROMX,BANK[7]
	LOAD FRAGMENT "Page 15 RAM",SRAM,BANK[15]
; Function IsSpace
; ---------------------------------
_IsSpace:
	ld	c, a
;src/editor/undo.c:108: return c == ' ' || c == ASCII_LF || c == ASCII_TAB;
	ld	a, c
	sub	a, $20
	jp	NZ,.l00124
	jp	.l00104
.l00124:
	ld	a, c
	sub	a, $0A
	jp	NZ,.l00125
	jp	.l00104
.l00125:
	ld	a, c
	sub	a, $09
	jp	NZ,.l00126
	jp	.l00104
.l00126:
	xor	a, a
	jp	.l00105
.l00104:
	ld	a, $01
.l00105:
.l00101:
;src/editor/undo.c:109: }
	ret
;src/editor/undo.c:111: void undo_Clear(unsigned char modified) {
;	---------------------------------
	SECTION FRAGMENT "Page 15",ROMX,BANK[7]
	LOAD FRAGMENT "Page 15 RAM",SRAM,BANK[15]
; Function undo_Clear
; ---------------------------------
_undo_Clear::
	ld	l, a
;	spillPairReg hl
;	spillPairReg hl
;src/editor/undo.c:112: undo_tail = undo_head = undo_top = undo_last = 0;
	xor	a, a
	ld	[_undo_last], a
	ld	[_undo_last + 1], a
	xor	a, a
	ld	[_undo_top], a
	ld	[_undo_top + 1], a
	xor	a, a
	ld	[_undo_head], a
	ld	[_undo_head + 1], a
	xor	a, a
	ld	[_undo_tail], a
	ld	[_undo_tail + 1], a
;src/editor/undo.c:113: undo_saved = modified ? UNDO_NONE : 0;
	ld	a, l
	or	a, a
	jp	Z, .l00103
	ld	bc, $FFFF
	jp	.l00104
.l00103:
	ld	bc, $0000
.l00104:
	ld	hl, _undo_saved
	ld	[hl], c
	inc	hl
	ld	[hl], b
;src/editor/undo.c:114: undo_merge = 0;
	ld	hl, _undo_merge
	ld	[hl], $00
;src/editor/undo.c:115: undo_join = 0;
	ld	hl, _undo_join
	ld	[hl], $00
.l00101:
;src/editor/undo.c:116: }
	ret
;src/editor/undo.c:119: void undo_Inserted(unsigned int pos, unsigned int count) {
;	---------------------------------
	SECTION FRAGMENT "Page 15",ROMX,BANK[7]
	LOAD FRAGMENT "Page 15 RAM",SRAM,BANK[15]
; Function undo_Inserted
; ---------------------------------
_undo_Inserted::
	add	sp, -4
	ld	hl, sp+2
	ld	[hl], e
	inc	hl
	ld	[hl], d
	inc	sp
	inc	sp
	push	bc
;src/editor/undo.c:120: if (CanMerge(count == 1 && !(rec.type & ~UNDO_JOIN) && pos == rec.pos + rec.length &&
	ld	hl, sp+0
	ld	a, [hl]
	dec	a
	inc	hl
	or	a, [hl]
	jp	NZ,.l00148
	jp	.l00149
.l00148:
	jp	.l00106
.l00149:
	ld	a, [(_rec + 2) + 0]
	ld	c, $00
	and	a, $7F
	jp	NZ,.l00150
	ld	a, c
	or	a, a
	jp	NZ,.l00150
	jp	.l00151
.l00150:
	jp	.l00106
.l00151:
	ld	hl, _rec + 3
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	ld	hl, _rec + 0
	ld	a, [hl+]
	ld	h, [hl]
;	spillPairReg hl
	ld	l, a
;	spillPairReg hl
;	spillPairReg hl
	add	hl, bc
	ld	c, l
	ld	b, h
	ld	hl, sp+2
	ld	a, [hl]
	sub	a, c
	jp	NZ,.l00152
	inc	hl
	ld	a, [hl]
	sub	a, b
	jp	NZ,.l00152
	jp	.l00153
.l00152:
	jp	.l00106
.l00153:
;src/editor/undo.c:121: !(pos && IsSpace(tb_GetChar(pos - 1)) && !IsSpace(tb_GetChar(pos))))) Merge(pos); // a word and the spaces after it
	ld	hl, sp+3
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	jp	Z, .l00107
	inc	hl
	dec	hl
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	dec	bc
	ld	e, c
	ld	d, b
	call	_tb_GetChar
	ld	c, a
	ld	a, c
	call	_IsSpace
	or	a, a
	jp	Z, .l00107
	pop	hl
	pop	de
	push	de
	push	hl
	call	_tb_GetChar
	ld	c, a
	ld	a, c
	call	_IsSpace
	or	a, a
	jp	NZ, .l00107
.l00106:
	ld	c, $00
	jp	.l00108
.l00107:
	ld	c, $01
.l00108:
	ld	a, c
	call	_CanMerge
	or	a, a
	jp	Z, .l00102
	pop	hl
	pop	de
	push	de
	push	hl
	call	_Merge
	jp	.l00104
.l00102:
;src/editor/undo.c:122: else Push(UNDO_INS, pos, count);
	pop	de
	push	de
	push	de
	ld	hl, sp+4
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	xor	a, a
	call	_Push
.l00104:
;src/editor/undo.c:123: }
	add	sp, 4
	ret
;src/editor/undo.c:126: void undo_Deleting(unsigned int pos, unsigned int count) {
;	---------------------------------
	SECTION FRAGMENT "Page 15",ROMX,BANK[7]
	LOAD FRAGMENT "Page 15 RAM",SRAM,BANK[15]
; Function undo_Deleting
; ---------------------------------
_undo_Deleting::
	add	sp, -11
	ld	hl, sp+9
	ld	[hl], e
	inc	hl
	ld	[hl], d
	ld	hl, sp+7
	ld	[hl], c
	inc	hl
	ld	[hl], b
;src/editor/undo.c:127: unsigned char type = rec.type & ~UNDO_JOIN;
	ld	a, [(_rec + 2) + 0]
	and	a, $7F
	ld	hl, sp+0
	ld	[hl], a
;src/editor/undo.c:128: if (CanMerge(count == 1 && rec.pos == pos + 1 && (type == UNDO_BACK || (type == UNDO_DEL && rec.length == 1)))) {
	ld	hl, sp+7
	ld	a, [hl]
	dec	a
	inc	hl
	or	a, [hl]
	jp	NZ,.l00165
	ld	a,$01
	jp	.l00166
.l00165:
	xor	a,a
.l00166:
	ld	hl, sp+1
	ld	[hl], a
	dec	hl
	ld	a, [hl]
	dec	a
	jp	NZ,.l00167
	ld	a,$01
	jp	.l00168
.l00167:
	xor	a,a
.l00168:
	ld	hl, sp+2
	ld	[hl], a
	dec	hl
	bit	0, [hl]
	jp	Z, .l00109
	ld	de, (_rec + 3) + 0
	ld	a, [de]
	inc	hl
	inc	hl
	ld	[hl], a
	inc	de
	ld	a, [de]
	inc	hl
	ld	[hl], a
	ld	hl, sp+10
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $0001
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+7
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+6
	ld	[hl], a
	ld	hl, sp+3
	ld	a, [hl]
	inc	hl
	inc	hl
	sub	a, [hl]
	jp	NZ,.l00169
	dec	hl
	ld	a, [hl]
	inc	hl
	inc	hl
	sub	a, [hl]
	jp	NZ,.l00169
	jp	.l00170
.l00169:
	jp	.l00109
.l00170:
	ld	hl, sp+0
	ld	a, [hl]
	sub	a, $02
	jp	NZ,.l00171
	jp	.l00110
.l00171:
	ld	hl, sp+2
	bit	0, [hl]
	jp	Z, .l00109
	ld	hl, _rec + 0
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	ld	a, c
	dec	a
	or	a, b
	jp	NZ,.l00172
	jp	.l00110
.l00172:
.l00109:
	ld	c, $00
	jp	.l00111
.l00110:
	ld	c, $01
.l00111:
	ld	a, c
	call	_CanMerge
	ld	hl, sp+6
	ld	[hl], a
	ld	hl, sp+6
	ld	a, [hl]
	or	a, a
	jp	Z, .l00105
;src/editor/undo.c:129: rec.type = (rec.type & UNDO_JOIN) | UNDO_BACK;
	ld	hl, (_rec + 2) + 0
	ld	a, [hl]
	ld	hl, sp+6
	ld	[hl], a
	ld	hl, sp+6
	ld	a, [hl]
	and	a, $80
	ld	[hl], a
	ld	a, [hl]
	set	1, a
	ld	hl, (_rec + 2)
	ld	[hl], a
;src/editor/undo.c:130: rec.pos = pos;
	ld	de, (_rec + 3)
	ld	hl, sp+9
	ld	a, [hl]
	ld	[de], a
	inc	de
	inc	hl
	ld	a, [hl]
	ld	[de], a
;src/editor/undo.c:131: Merge(pos);
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_Merge
	jp	.l00107
.l00105:
;src/editor/undo.c:133: else if (CanMerge(count == 1 && type == UNDO_DEL && rec.pos == pos)) Merge(pos);
	ld	hl, sp+1
	bit	0, [hl]
	jp	Z, .l00121
	inc	hl
	bit	0, [hl]
	jp	Z, .l00121
	ld	hl, (_rec + 3) + 0
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	ld	hl, sp+9
	ld	a, [hl]
	sub	a, c
	jp	NZ,.l00173
	inc	hl
	ld	a, [hl]
	sub	a, b
	jp	NZ,.l00173
	jp	.l00122
.l00173:
.l00121:
	ld	hl, sp+6
	ld	[hl], $00
	jp	.l00123
.l00122:
	ld	hl, sp+6
	ld	[hl], $01
.l00123:
	ld	hl, sp+6
	ld	a, [hl]
	call	_CanMerge
	or	a, a
	jp	Z, .l00102
	ld	hl, sp+9
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_Merge
	jp	.l00107
.l00102:
;src/editor/undo.c:134: else Push(UNDO_DEL, pos, count);
	ld	hl, sp+7
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	push	de
	inc	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, $01
	call	_Push
.l00107:
;src/editor/undo.c:135: }
	add	sp, 11
	ret
;src/editor/undo.c:137: void undo_Saved(void) {
;	---------------------------------
	SECTION FRAGMENT "Page 15",ROMX,BANK[7]
	LOAD FRAGMENT "Page 15 RAM",SRAM,BANK[15]
; Function undo_Saved
; ---------------------------------
_undo_Saved::
;src/editor/undo.c:138: undo_saved = undo_head;
	ld	hl, _undo_head
	ld	a, [hl]
	ld	hl, _undo_saved
	ld	[hl], a
	ld	hl, _undo_head + 1
	ld	a, [hl]
	ld	hl, _undo_saved + 1
	ld	[hl], a
;src/editor/undo.c:139: undo_merge = 0;
	ld	hl, _undo_merge
	ld	[hl], $00
.l00101:
;src/editor/undo.c:140: }
	ret
;src/editor/undo.c:143: static void Restore(void) {
;	---------------------------------
	SECTION FRAGMENT "Page 15",ROMX,BANK[7]
	LOAD FRAGMENT "Page 15 RAM",SRAM,BANK[15]
; Function Restore
; ---------------------------------
_Restore:
	add	sp, -3
;src/editor/undo.c:146: if (rec.type & UNDO_BACK) {
	ld	hl, (_rec + 2) + 0
	ld	a, [hl]
	ld	hl, sp+2
	ld	[hl], a
;src/editor/undo.c:147: for (i = rec.length; i; --i) {
	ld	hl, _rec + 0
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
;src/editor/undo.c:146: if (rec.type & UNDO_BACK) {
	push	hl
	ld	hl, sp+4
	bit	1, [hl]
	pop	hl
	jp	NZ,.l00126
	jp	.l00103
.l00126:
;src/editor/undo.c:147: for (i = rec.length; i; --i) {
	ld	hl, sp+1
	ld	[hl], c
	inc	hl
	ld	[hl], b
.l00106:
	ld	hl, sp+2
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	jp	Z, .l00108
;src/editor/undo.c:148: log_Read(&c, 1);
	ld	hl, sp+0
	ld	e, l
	ld	d, h
	ld	bc, $0001
	call	_log_Read
;src/editor/undo.c:149: tb_Insert(rec.pos, c);
	ld	hl, (_rec + 3) + 0
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	ld	hl, sp+0
	ld	a, [hl]
	ld	e, c
	ld	d, b
	call	_tb_Insert
;src/editor/undo.c:147: for (i = rec.length; i; --i) {
	ld	hl, sp+2
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	dec	de
	dec	hl
	ld	[hl], e
	inc	hl
	ld	[hl], d
	jp	.l00106
.l00103:
;src/editor/undo.c:152: else log_RestoreText(rec.pos, rec.length);
	ld	hl, (_rec + 3) + 0
	ld	a, [hl+]
	ld	h, [hl]
;	spillPairReg hl
	ld	l, a
;	spillPairReg hl
;	spillPairReg hl
	ld	e, l
	ld	d, h
	call	_log_RestoreText
.l00108:
;src/editor/undo.c:153: }
	add	sp, 3
	ret
;src/editor/undo.c:155: static void Done(void) {
;	---------------------------------
	SECTION FRAGMENT "Page 15",ROMX,BANK[7]
	LOAD FRAGMENT "Page 15 RAM",SRAM,BANK[15]
; Function Done
; ---------------------------------
_Done:
;src/editor/undo.c:156: undo_merge = 0;
	ld	hl, _undo_merge
	ld	[hl], $00
;src/editor/undo.c:157: undo_at_save = undo_head == undo_saved;
	ld	hl, _undo_head
	ld	a, [hl]
	ld	hl, _undo_saved
	sub	a, [hl]
	jp	NZ,.l00103
	ld	hl, _undo_head + 1
	ld	a, [hl]
	ld	hl, _undo_saved + 1
	sub	a, [hl]
	jp	NZ,.l00103
	ld	a,$01
	jp	.l00104
.l00103:
	xor	a,a
.l00104:
	ld	hl, _undo_at_save
	ld	[hl], a
.l00101:
;src/editor/undo.c:158: }
	ret
;src/editor/undo.c:161: unsigned char undo_Undo(void) {
;	---------------------------------
	SECTION FRAGMENT "Page 15",ROMX,BANK[7]
	LOAD FRAGMENT "Page 15 RAM",SRAM,BANK[15]
; Function undo_Undo
; ---------------------------------
_undo_Undo::
;src/editor/undo.c:162: if (undo_head == undo_tail) return 0;
	ld	hl, _undo_head
	ld	a, [hl]
	ld	hl, _undo_tail
	sub	a, [hl]
	jp	NZ,.l00139
	ld	hl, _undo_head + 1
	ld	a, [hl]
	ld	hl, _undo_tail + 1
	sub	a, [hl]
	jp	NZ,.l00139
	jp	.l00140
.l00139:
	jp	.l00118
.l00140:
	xor	a, a
	jp	.l00112
;src/editor/undo.c:163: do {
.l00118:
.l00109:
;src/editor/undo.c:164: log_ptr = Back(undo_head, 2);
	ld	bc, $0002
	ld	hl, _undo_head
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_Back
	ld	hl, _log_ptr
	ld	[hl], c
	inc	hl
	ld	[hl], b
;src/editor/undo.c:165: log_Read(&rec.length, 2);
	ld	bc, $0002
	ld	de, _rec
	call	_log_Read
;src/editor/undo.c:166: log_ptr = undo_head = Back(undo_head, rec.length + UNDO_EXTRA);
	ld	hl, _rec + 0
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	ld	hl, $0007
	add	hl, bc
	ld	c, l
	ld	b, h
	ld	hl, _undo_head
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_Back
	ld	hl, _undo_head
	ld	[hl], c
	inc	hl
	ld	[hl], b
	ld	hl, _log_ptr
	ld	[hl], c
	inc	hl
	ld	[hl], b
;src/editor/undo.c:167: log_Read(&rec, UNDO_HEADER);
	ld	bc, $0005
	ld	de, _rec
	call	_log_Read
;src/editor/undo.c:168: undo_cursor = rec.pos;
	ld	de, (_rec + 3) + 0
	ld	a, [de]
	ld	hl, _undo_cursor
	ld	[hl], a
	inc	de
	ld	a, [de]
	inc	hl
	ld	[hl], a
;src/editor/undo.c:169: if (!(rec.type & (UNDO_DEL | UNDO_BACK))) tb_DeleteRange(rec.pos, rec.length);
	ld	a, [(_rec + 2) + 0]
	and	a, $03
	jp	NZ,.l00141
	jp	.l00142
.l00141:
	jp	.l00106
.l00142:
	ld	hl, _rec + 0
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	ld	hl, (_rec + 3) + 0
	ld	a, [hl+]
	ld	h, [hl]
;	spillPairReg hl
	ld	l, a
;	spillPairReg hl
;	spillPairReg hl
	ld	e, l
	ld	d, h
	call	_tb_DeleteRange
	jp	.l00110
.l00106:
;src/editor/undo.c:171: Restore();
	call	_Restore
;src/editor/undo.c:172: if (rec.type & UNDO_BACK) undo_cursor += rec.length;
	ld	a, [(_rec + 2) + 0]
	bit	1, a
	jp	NZ,.l00143
	jp	.l00110
.l00143:
	ld	hl, _rec + 0
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	ld	hl, _undo_cursor
	ld	a, [hl]
	add	a, c
	ld	[hl], a
	inc	hl
	ld	a, [hl]
	adc	a, b
	ld	[hl], a
.l00110:
;src/editor/undo.c:174: } while ((rec.type & UNDO_JOIN) && undo_head != undo_tail);
	ld	a, [(_rec + 2) + 0]
	rlca
	jp	C,.l00144
	jp	.l00111
.l00144:
	ld	hl, _undo_head
	ld	a, [hl]
	ld	hl, _undo_tail
	sub	a, [hl]
	jp	NZ,.l00145
	ld	hl, _undo_head + 1
	ld	a, [hl]
	ld	hl, _undo_tail + 1
	sub	a, [hl]
	jp	NZ,.l00145
	jp	.l00146
.l00145:
	jp	.l00109
.l00146:
.l00111:
;src/editor/undo.c:175: Done();
	call	_Done
;src/editor/undo.c:176: return 1;
	ld	a, $01
.l00112:
;src/editor/undo.c:177: }
	ret
;src/editor/undo.c:180: unsigned char undo_Redo(void) {
;	---------------------------------
	SECTION FRAGMENT "Page 15",ROMX,BANK[7]
	LOAD FRAGMENT "Page 15 RAM",SRAM,BANK[15]
; Function undo_Redo
; ---------------------------------
_undo_Redo::
	add	sp, -4
;src/editor/undo.c:181: if (undo_head == undo_top) return 0;
	ld	hl, _undo_head
	ld	a, [hl]
	ld	hl, _undo_top
	sub	a, [hl]
	jp	NZ,.l00133
	ld	hl, _undo_head + 1
	ld	a, [hl]
	ld	hl, _undo_top + 1
	sub	a, [hl]
	jp	NZ,.l00133
	jp	.l00134
.l00133:
	jp	.l00116
.l00134:
	xor	a, a
	jp	.l00111
;src/editor/undo.c:182: do {
.l00116:
.l00108:
;src/editor/undo.c:183: log_ptr = undo_head;
	ld	hl, _undo_head
	ld	a, [hl]
	ld	hl, _log_ptr
	ld	[hl], a
	ld	hl, _undo_head + 1
	ld	a, [hl]
	ld	hl, _log_ptr + 1
	ld	[hl], a
;src/editor/undo.c:184: log_Read(&rec, UNDO_HEADER);
	ld	bc, $0005
	ld	de, _rec
	call	_log_Read
;src/editor/undo.c:185: undo_cursor = rec.pos;
	ld	de, (_rec + 3) + 0
	ld	a, [de]
	ld	hl, _undo_cursor
	ld	[hl], a
	inc	de
	ld	a, [de]
	inc	hl
	ld	[hl], a
;src/editor/undo.c:186: if (rec.type & (UNDO_DEL | UNDO_BACK)) tb_DeleteRange(rec.pos, rec.length);
	ld	hl, (_rec + 2) + 0
	ld	c, [hl]
;src/editor/undo.c:185: undo_cursor = rec.pos;
	ld	de, (_rec + 3) + 0
	ld	a, [de]
	ld	hl, sp+0
	ld	[hl], a
	inc	de
	ld	a, [de]
	inc	hl
	ld	[hl], a
;src/editor/undo.c:186: if (rec.type & (UNDO_DEL | UNDO_BACK)) tb_DeleteRange(rec.pos, rec.length);
	ld	de, _rec + 0
	ld	a, [de]
	inc	hl
	ld	[hl], a
	inc	de
	ld	a, [de]
	inc	hl
	ld	[hl], a
	ld	a, c
	and	a, $03
	jp	NZ,.l00135
	jp	.l00104
.l00135:
	pop	hl
	pop	bc
	push	bc
	push	hl
	pop	de
	push	de
	call	_tb_DeleteRange
	jp	.l00105
.l00104:
;src/editor/undo.c:188: log_RestoreText(rec.pos, rec.length);
	pop	hl
	pop	bc
	push	bc
	push	hl
	pop	de
	push	de
	call	_log_RestoreText
;src/editor/undo.c:189: undo_cursor += rec.length;
	ld	hl, _rec + 0
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	ld	hl, _undo_cursor
	ld	a, [hl]
	add	a, c
	ld	[hl], a
	inc	hl
	ld	a, [hl]
	adc	a, b
	ld	[hl], a
.l00105:
;src/editor/undo.c:191: undo_head = Forward(undo_head, rec.length + UNDO_EXTRA);
	ld	hl, _rec + 0
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	ld	hl, $0007
	add	hl, bc
	ld	c, l
	ld	b, h
	ld	hl, _undo_head
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_Forward
	ld	hl, _undo_head
	ld	[hl], c
	inc	hl
	ld	[hl], b
;src/editor/undo.c:192: if (undo_head == undo_top) break;
	dec	hl
	ld	a, [hl]
	ld	hl, _undo_top
	sub	a, [hl]
	jp	NZ,.l00136
	ld	hl, _undo_head + 1
	ld	a, [hl]
	ld	hl, _undo_top + 1
	sub	a, [hl]
	jp	NZ,.l00136
	jp	.l00110
.l00136:
;src/editor/undo.c:193: log_ptr = undo_head;
	ld	hl, _undo_head
	ld	a, [hl]
	ld	hl, _log_ptr
	ld	[hl], a
	ld	hl, _undo_head + 1
	ld	a, [hl]
	ld	hl, _log_ptr + 1
	ld	[hl], a
;src/editor/undo.c:194: log_Read(&rec, UNDO_HEADER);
	ld	bc, $0005
	ld	de, _rec
	call	_log_Read
;src/editor/undo.c:195: } while (rec.type & UNDO_JOIN);
	ld	a, [(_rec + 2) + 0]
	rlca
	jp	C,.l00137
	jp	.l00138
.l00137:
	jp	.l00108
.l00138:
.l00110:
;src/editor/undo.c:196: Done();
	call	_Done
;src/editor/undo.c:197: return 1;
	ld	a, $01
.l00111:
;src/editor/undo.c:198: }
	add	sp, 4
	ret
	SECTION FRAGMENT "Page 15",ROMX,BANK[7]
	LOAD FRAGMENT "Page 15 RAM",SRAM,BANK[15]
	SECTION FRAGMENT "_INITIALIZER",ROM0
	SECTION FRAGMENT "_CABS (ABS)",ROM0

;far call thunks generated by bank_split.py
	SECTION FRAGMENT "src/editor/undo.c FIXED",ROMX,BANK[1]