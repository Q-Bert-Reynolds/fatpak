;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 4.2.0 #13081 (Linux)
;--------------------------------------------------------
	; MODULE browser
	; Generated using the rgbds tokens.

;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	EXPORT _CopyName
	EXPORT _PutNumber2
	EXPORT _PutNumber
	EXPORT _PutText
	EXPORT _DrawRow
	EXPORT _RowAddress
	EXPORT _NoHighlight
	EXPORT _ScrollRing
	EXPORT _Layout
	EXPORT _EditorDraw
	EXPORT _SetFont
	EXPORT _HideBox
	EXPORT _ShowBusy
	EXPORT _WaitDismiss
	EXPORT _MenuKey
	EXPORT _LaunchGame
	EXPORT _IsGame
	EXPORT _SetRows
	EXPORT _tb_ScrollRows
	EXPORT _OSKShow
	EXPORT _LoadDocument
	EXPORT _FileListEntry
	EXPORT _FileList
	EXPORT _FileMount
	EXPORT _EditorShowCursor
	EXPORT _JoinPath
	EXPORT _PutPath
	EXPORT _ToLatin1
	EXPORT _ShowError
	EXPORT _Browse
;--------------------------------------------------------
; special function registers
;--------------------------------------------------------
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	SECTION FRAGMENT "src/browser/browser.c_DATA",WRAM0
_src_browser_browser_c_entry:
	DS 74
_src_browser_browser_c_list_count:
	DS 2
_src_browser_browser_c_list_result:
	DS 1
_src_browser_browser_c_list_kinds:
	DS 16
_src_browser_browser_c_list_sizes:
	DS 64
_src_browser_browser_c_list_dates:
	DS 32
_src_browser_browser_c_list_times:
	DS 32
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
	SECTION FRAGMENT "src/browser/browser.c_HOME",ROM0
	SECTION FRAGMENT "src/browser/browser.c_HOME",ROM0
;--------------------------------------------------------
; code
;--------------------------------------------------------
	SECTION FRAGMENT "src/browser/browser.c_CODE",ROMX
;src/browser/browser.c:35: static unsigned int ListFolder(const char* path, const char* find) {
;	---------------------------------
	SECTION FRAGMENT "Page 4",ROMX,BANK[2]
	LOAD FRAGMENT "Page 4 RAM",SRAM,BANK[4]
; Function ListFolder
; ---------------------------------
_src_browser_browser_c_ListFolder:
	add	sp, -3
	ld	hl, sp+1
	ld	[hl], c
	inc	hl
	ld	[hl], b
;src/browser/browser.c:36: unsigned char up = path[0] != 0;
	ld	a, [de]
	sub	a,$01
	ld	a, $00
	rla
	xor	a, $01
	dec	hl
	dec	hl
	ld	[hl], a
;src/browser/browser.c:37: list_count = 0;
	xor	a, a
	ld	hl, _src_browser_browser_c_list_count
	ld	[hl], a
	inc	hl
	ld	[hl], a
;src/browser/browser.c:38: if ((list_result = FileList(path, find))) return 0;
	ld	hl, sp+1
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	call	_FileList
	ld	hl, _src_browser_browser_c_list_result
	ld	[hl], a
	or	a, a
	jp	Z, .l00102
	ld	bc, $0000
	jp	.l00103
.l00102:
;src/browser/browser.c:39: list_count = fs_count + up;
	ld	hl, sp+0
	ld	c, [hl]
	ld	b, $00
	ld	hl, _fs_count
	ld	a, [hl]
	add	a, c
	ld	hl, _src_browser_browser_c_list_count
	ld	[hl], a
	ld	hl, _fs_count + 1
	ld	a, [hl]
	adc	a, b
	ld	hl, _src_browser_browser_c_list_count + 1
	ld	[hl], a
;src/browser/browser.c:40: return find && fs_found != 0xFFFF ? fs_found + up : 0;
	ld	hl, sp+2
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	jp	Z, .l00105
	ld	hl, _fs_found
	ld	a, [hl]
	inc	a
	jp	NZ,.l00124
	inc	hl
	ld	a, [hl]
	inc	a
	jp	NZ,.l00124
	jp	.l00105
.l00124:
	ld	a, c
	ld	hl, _fs_found
	add	a, [hl]
	ld	c, a
	ld	a, b
	inc	hl
	adc	a, [hl]
	ld	b, a
	jp	.l00106
.l00105:
	ld	bc, $0000
.l00106:
.l00103:
;src/browser/browser.c:41: }
	add	sp, 3
	ret
;src/browser/browser.c:44: static unsigned char ListEntry(const char* path, unsigned int index) {
;	---------------------------------
	SECTION FRAGMENT "Page 4",ROMX,BANK[2]
	LOAD FRAGMENT "Page 4 RAM",SRAM,BANK[4]
; Function ListEntry
; ---------------------------------
_src_browser_browser_c_ListEntry:
	dec	sp
	dec	sp
	inc	sp
	inc	sp
	push	bc
;src/browser/browser.c:45: if (path[0] && !index--) {
	ld	a, [de]
	or	a, a
	jp	Z, .l00102
	pop	bc
	push	bc
	pop	de
	push	de
	dec	de
	inc	sp
	inc	sp
	push	de
	ld	a, b
	or	a, c
	jp	NZ, .l00102
;src/browser/browser.c:46: entry.name[0] = '.';
	ld	hl, _src_browser_browser_c_entry
	ld	[hl], $2E
;src/browser/browser.c:47: entry.name[1] = '.';
	ld	hl, (_src_browser_browser_c_entry + 1)
	ld	[hl], $2E
;src/browser/browser.c:48: entry.name[2] = 0;
	ld	hl, (_src_browser_browser_c_entry + 2)
	ld	[hl], $00
;src/browser/browser.c:49: return KIND_UP;
	xor	a, a
	jp	.l00106
.l00102:
;src/browser/browser.c:51: if ((list_result = FileListEntry(index, &entry))) return 0xFF;
	ld	bc, _src_browser_browser_c_entry
	pop	de
	push	de
	call	_FileListEntry
	ld	hl, _src_browser_browser_c_list_result
	ld	[hl], a
	or	a, a
	jp	Z, .l00105
	ld	a, $FF
	jp	.l00106
.l00105:
;src/browser/browser.c:52: return entry.dir ? KIND_FOLDER : KIND_FILE;
	ld	a, [(_src_browser_browser_c_entry + 73) + 0]
	or	a, a
	jp	Z, .l00108
	ld	bc, $0001
	jp	.l00109
.l00108:
	ld	bc, $0002
.l00109:
	ld	a, c
.l00106:
;src/browser/browser.c:53: }
	inc	sp
	inc	sp
	ret
;src/browser/browser.c:56: static void ListRows(const char* path, unsigned int first, unsigned char row, unsigned char end) {
;	---------------------------------
	SECTION FRAGMENT "Page 4",ROMX,BANK[2]
	LOAD FRAGMENT "Page 4 RAM",SRAM,BANK[4]
; Function ListRows
; ---------------------------------
_src_browser_browser_c_ListRows:
	add	sp, -12
	ld	hl, sp+9
	ld	[hl], e
	inc	hl
	ld	[hl], d
	ld	hl, sp+7
	ld	[hl], c
	inc	hl
	ld	[hl], b
	ld	hl, sp+14
	ld	a, [hl]
	ld	hl, sp+11
	ld	[hl], a
.l00110:
;src/browser/browser.c:59: for (; row < end; ++row) {
	ld	hl, sp+11
	ld	a, [hl]
	ld	hl, sp+15
	sub	a, [hl]
	jp	NC, .l00111
;src/browser/browser.c:60: DrawRow(row, 0, "");
	ld	de, _src_browser_browser_c___str_0
	push	de
	ld	e, $00
	ld	hl, sp+13
	ld	a, [hl]
	call	_DrawRow__far
;src/browser/browser.c:61: if (first + row >= list_count) continue;
	ld	hl, sp+11
	ld	a, [hl]
	ld	hl, sp+0
	ld	[hl], a
	inc	hl
	ld	[hl], $00
	pop	bc
	push	bc
	ld	hl, sp+7
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	add	hl, bc
	ld	c, l
	ld	b, h
	ld	hl, _src_browser_browser_c_list_count
	ld	a, c
	sub	a, [hl]
	inc	hl
	ld	a, b
	sbc	a, [hl]
	jp	NC, .l00107
;src/browser/browser.c:62: if ((kind = ListEntry(path, first + row)) == 0xFF) return;
	ld	hl, sp+9
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_src_browser_browser_c_ListEntry
	ld	hl, sp+2
	ld	[hl], a
	inc	a
	jp	NZ,.l00138
	jp	.l00139
.l00138:
	jp	.l00104
.l00139:
	jp	.l00111
.l00104:
;src/browser/browser.c:63: list_kinds[row] = kind;
	ld	de, _src_browser_browser_c_list_kinds
	ld	hl, sp+11
	ld	l, [hl]
	ld	h, $00
	add	hl, de
	ld	c, l
	ld	b, h
	ld	hl, sp+2
	ld	a, [hl]
	ld	[bc], a
;src/browser/browser.c:64: list_sizes[row] = entry.size;
	dec	hl
	dec	hl
	ld	a, [hl]
	inc	hl
	ld	b, [hl]
	add	a, a
	rl	b
	add	a, a
	rl	b
	add	a, LOW(_src_browser_browser_c_list_sizes)
	ld	c, a
	ld	a, b
	adc	a, HIGH(_src_browser_browser_c_list_sizes)
	ld	b, a
	ld	de, (_src_browser_browser_c_entry + 65) + 0
	ld	a, [de]
	inc	hl
	inc	hl
	ld	[hl], a
	inc	de
	ld	a, [de]
	inc	hl
	ld	[hl], a
	inc	de
	ld	a, [de]
	inc	hl
	ld	[hl], a
	inc	de
	ld	a, [de]
	inc	hl
	ld	[hl], a
	ld	hl, sp+3
	ld	a, [hl]
	ld	[bc], a
	inc	bc
	inc	hl
	ld	a, [hl]
	ld	[bc], a
	inc	bc
	inc	hl
	ld	a, [hl]
	ld	[bc], a
	inc	bc
	inc	hl
	ld	a, [hl]
	ld	[bc], a
;src/browser/browser.c:65: list_dates[row] = entry.date;
	pop	bc
	push	bc
	sla	c
	rl	b
	ld	hl, _src_browser_browser_c_list_dates
	add	hl, bc
	push	hl
	ld	a, l
	ld	hl, sp+5
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+4
	ld	[hl], a
	ld	de, (_src_browser_browser_c_entry + 69) + 0
	ld	a, [de]
	inc	hl
	ld	[hl], a
	inc	de
	ld	a, [de]
	inc	hl
	ld	[hl], a
	dec	hl
	dec	hl
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	inc	hl
	ld	a, [hl]
	ld	[de], a
	inc	de
	inc	hl
	ld	a, [hl]
	ld	[de], a
;src/browser/browser.c:66: list_times[row] = entry.time;
	ld	hl, _src_browser_browser_c_list_times
	add	hl, bc
	push	hl
	ld	a, l
	ld	hl, sp+7
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+6
	ld	[hl], a
	ld	hl, (_src_browser_browser_c_entry + 71) + 0
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	ld	hl, sp+5
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	ld	[hl], c
	inc	hl
	ld	[hl], b
;src/browser/browser.c:67: dest = ToLatin1(RowAddress(row) + 1, entry.name, TB_STRIDE - 3);
	ld	hl, sp+11
	ld	a, [hl]
	call	_RowAddress__far
	ld	e, c
	ld	d, b
	inc	de
	ld	a, $25
	push	af
	inc	sp
	ld	bc, _src_browser_browser_c_entry
	call	_ToLatin1
	ld	hl, sp+5
	ld	[hl], c
	inc	hl
	ld	[hl], b
;src/browser/browser.c:68: if (kind == KIND_FOLDER) *dest = '/';
	ld	hl, sp+2
	ld	a, [hl]
	dec	a
	jp	NZ,.l00142
	jp	.l00143
.l00142:
	jp	.l00107
.l00143:
	ld	hl, sp+5
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	ld	[hl], $2F
.l00107:
;src/browser/browser.c:59: for (; row < end; ++row) {
	ld	hl, sp+11
	inc	[hl]
	jp	.l00110
.l00111:
;src/browser/browser.c:70: }
	add	sp, 12
	pop	hl
	inc	sp
	inc	sp
	jp hl
	SECTION FRAGMENT "src/browser/browser.c FIXED",ROMX,BANK[1]
_src_browser_browser_c___str_0:
	DB $00
;src/browser/browser.c:73: static void ScrollList(const char* path, unsigned int first, unsigned char down) {
;	---------------------------------
	SECTION FRAGMENT "Page 4",ROMX,BANK[2]
	LOAD FRAGMENT "Page 4 RAM",SRAM,BANK[4]
; Function ScrollList
; ---------------------------------
_src_browser_browser_c_ScrollList:
	add	sp, -13
	ld	hl, sp+10
	ld	[hl], e
	inc	hl
	ld	[hl], d
	ld	hl, sp+8
	ld	[hl], c
	inc	hl
	ld	[hl], b
;src/browser/browser.c:75: ScrollRing(down);
	ld	hl, sp+15
	ld	a, [hl]
	call	_ScrollRing__far
;src/browser/browser.c:76: tb_ScrollRows(down);
	ld	hl, sp+15
	ld	a, [hl]
	call	_tb_ScrollRows
;src/browser/browser.c:77: for (i = 1; i < LIST_ROWS; ++i) {
	ld	hl, sp+12
	ld	[hl], $01
.l00102:
;src/browser/browser.c:78: to = down ? i - 1 : LIST_ROWS - i;
	ld	hl, sp+12
	ld	a, [hl]
	ld	hl, sp+7
	ld	[hl], a
	ld	hl, sp+15
	ld	a, [hl]
	or	a, a
	jp	Z, .l00106
	ld	hl, sp+7
	ld	a, [hl]
	dec	a
	jp	.l00107
.l00106:
	ld	a, $10
	ld	hl, sp+7
	sub	a, [hl]
.l00107:
	ld	b, a
;src/browser/browser.c:79: from = down ? i : to - 1;
	ld	hl, sp+15
	ld	a, [hl]
	or	a, a
	jp	Z, .l00108
	ld	hl, sp+12
	ld	c, [hl]
	jp	.l00109
.l00108:
	ld	c, b
	dec	c
.l00109:
;src/browser/browser.c:80: list_kinds[to] = list_kinds[from];
	ld	a, LOW(_src_browser_browser_c_list_kinds)
	add	a, b
	ld	e, a
	ld	a, HIGH(_src_browser_browser_c_list_kinds)
	adc	a, $00
	ld	d, a
	ld	a, LOW(_src_browser_browser_c_list_kinds)
	add	a, c
	ld	l, a
;	spillPairReg hl
;	spillPairReg hl
	ld	a, HIGH(_src_browser_browser_c_list_kinds)
	adc	a, $00
	ld	h, a
;	spillPairReg hl
;	spillPairReg hl
	ld	a, [hl]
	ld	[de], a
;src/browser/browser.c:81: list_sizes[to] = list_sizes[from];
	ld	hl, sp+6
	ld	[hl], b
	inc	hl
	ld	[hl], $00
	dec	hl
	ld	a, [hl]
	inc	hl
	ld	d, [hl]
	add	a, a
	rl	d
	add	a, a
	rl	d
	ld	e, a
	ld	hl, _src_browser_browser_c_list_sizes
	add	hl, de
	inc	sp
	inc	sp
	push	hl
	ld	b, $00
	ld	l, c
	ld	h, b
	add	hl, hl
	add	hl, hl
	ld	de, _src_browser_browser_c_list_sizes
	add	hl, de
	ld	e, l
	ld	d, h
	ld	a, [de]
	ld	hl, sp+2
	ld	[hl], a
	inc	de
	ld	a, [de]
	inc	hl
	ld	[hl], a
	inc	de
	ld	a, [de]
	inc	hl
	ld	[hl], a
	inc	de
	ld	a, [de]
	inc	hl
	ld	[hl], a
	pop	de
	push	de
	ld	hl, sp+2
	ld	a, [hl]
	ld	[de], a
	inc	de
	inc	hl
	ld	a, [hl]
	ld	[de], a
	inc	de
	inc	hl
	ld	a, [hl]
	ld	[de], a
	inc	de
	inc	hl
	ld	a, [hl]
	ld	[de], a
;src/browser/browser.c:82: list_dates[to] = list_dates[from];
	inc	hl
	ld	a, [hl]
	ld	hl, sp+2
	ld	[hl], a
	ld	hl, sp+7
	ld	a, [hl]
	ld	hl, sp+3
	ld	[hl], a
	dec	hl
	sla	[hl]
	inc	hl
	rl	[hl]
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, _src_browser_browser_c_list_dates
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+6
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+5
	ld	[hl], a
	sla	c
	rl	b
	ld	hl, _src_browser_browser_c_list_dates
	add	hl, bc
	ld	e, l
	ld	d, h
	ld	a, [de]
	ld	hl, sp+6
	ld	[hl], a
	inc	de
	ld	a, [de]
	inc	hl
	ld	[hl], a
	ld	hl, sp+5
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	inc	hl
	ld	a, [hl]
	ld	[de], a
	inc	de
	inc	hl
	ld	a, [hl]
	ld	[de], a
;src/browser/browser.c:83: list_times[to] = list_times[from];
	ld	hl, sp+3
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, _src_browser_browser_c_list_times
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+8
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+7
	ld	[hl], a
	ld	hl, _src_browser_browser_c_list_times
	add	hl, bc
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	ld	hl, sp+6
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	ld	[hl], c
	inc	hl
	ld	[hl], b
;src/browser/browser.c:77: for (i = 1; i < LIST_ROWS; ++i) {
	ld	hl, sp+12
	inc	[hl]
	ld	a, [hl]
	sub	a, $10
	jp	C, .l00102
;src/browser/browser.c:85: i = down ? LIST_ROWS - 1 : 0;
	ld	hl, sp+15
	ld	a, [hl]
	or	a, a
	jp	Z, .l00110
	ld	de, $000F
	jp	.l00111
.l00110:
	ld	de, $0000
.l00111:
	ld	a, e
;src/browser/browser.c:86: ListRows(path, first, i, i + 1);
	ld	b, a
	inc	b
	push	bc
	inc	sp
	push	af
	inc	sp
	ld	hl, sp+10
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	inc	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_src_browser_browser_c_ListRows
.l00104:
;src/browser/browser.c:87: }
	add	sp, 13
	pop	hl
	inc	sp
	jp hl
;src/browser/browser.c:90: static void ListBars(const char* path, unsigned char row, unsigned int count) {
;	---------------------------------
	SECTION FRAGMENT "Page 4",ROMX,BANK[2]
	LOAD FRAGMENT "Page 4 RAM",SRAM,BANK[4]
; Function ListBars
; ---------------------------------
_src_browser_browser_c_ListBars:
	add	sp, -51
	ld	hl, sp+49
	ld	[hl], e
	inc	hl
	ld	[hl], d
	dec	hl
	dec	hl
	ld	[hl], a
;src/browser/browser.c:92: char* end = text;
;src/browser/browser.c:93: unsigned long size = list_sizes[row];
	ld	c, [hl]
	ld	b, $00
	ld	a, c
	ld	d, b
	add	a, a
	rl	d
	add	a, a
	rl	d
	ld	e, a
	ld	hl, _src_browser_browser_c_list_sizes
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+48
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+47
	ld	[hl], a
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	ld	hl, sp+40
	ld	[hl], a
	inc	de
	ld	a, [de]
	inc	hl
	ld	[hl], a
	inc	de
	ld	a, [de]
	inc	hl
	ld	[hl], a
	inc	de
	ld	a, [de]
	inc	hl
	ld	[hl], a
;src/browser/browser.c:94: unsigned char* bytes = (unsigned char*)&size;
;src/browser/browser.c:95: unsigned int date = list_dates[row], time = list_times[row];
	sla	c
	rl	b
	ld	hl, _src_browser_browser_c_list_dates
	add	hl, bc
	ld	e, l
	ld	d, h
	ld	a, [de]
	ld	hl, sp+44
	ld	[hl], a
	inc	de
	ld	a, [de]
	inc	hl
	ld	[hl], a
	ld	hl, _src_browser_browser_c_list_times
	add	hl, bc
	ld	e, l
	ld	d, h
	ld	a, [de]
	ld	hl, sp+46
	ld	[hl], a
	inc	de
	ld	a, [de]
	inc	hl
	ld	[hl], a
;src/browser/browser.c:96: PutPath(text, path, 30);
	ld	a, $1E
	push	af
	inc	sp
	ld	hl, sp+50
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	ld	hl, 1
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_PutPath
;src/browser/browser.c:97: DrawRow(HEADER_LINE, 1, text);
	ld	hl, 0
	add	hl, sp
	push	hl
	ld	e, $01
	ld	a, $12
	call	_DrawRow__far
;src/browser/browser.c:98: if (!count) end = PutText(end, "Empty folder");
	ld	hl, sp+54
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	jp	NZ, .l00114
	ld	bc, _src_browser_browser_c___str_1
	ld	hl, 0
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_PutText__far
	ld	hl, sp+46
	ld	[hl], c
	inc	hl
	ld	[hl], b
	jp	.l00115
.l00114:
;src/browser/browser.c:99: else if (list_kinds[row] == KIND_UP) end = PutText(end, "Parent folder");
	ld	de, _src_browser_browser_c_list_kinds
	ld	hl, sp+48
	ld	l, [hl]
	ld	h, $00
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, [bc]
	or	a, a
	jp	NZ, .l00111
	ld	bc, _src_browser_browser_c___str_2
	ld	hl, 0
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_PutText__far
	ld	hl, sp+46
	ld	[hl], c
	inc	hl
	ld	[hl], b
	jp	.l00115
.l00111:
;src/browser/browser.c:100: else if (list_kinds[row] == KIND_FOLDER) end = PutText(end, "Folder");
	dec	a
	jp	NZ,.l00145
	jp	.l00146
.l00145:
	jp	.l00108
.l00146:
	ld	bc, _src_browser_browser_c___str_3
	ld	hl, 0
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_PutText__far
	ld	hl, sp+46
	ld	[hl], c
	inc	hl
	ld	[hl], b
	jp	.l00115
.l00108:
;src/browser/browser.c:102: if (size < 10000) end = PutText(PutNumber(end, (unsigned int)size), " bytes  ");
	ld	hl, sp+40
	ld	a, [hl]
	sub	a, $10
	inc	hl
	ld	a, [hl]
	sbc	a, $27
	inc	hl
	ld	a, [hl]
	sbc	a, $00
	inc	hl
	ld	a, [hl]
	sbc	a, $00
	jp	NC, .l00105
	ld	hl, sp+40
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	ld	de, $0000
	push	de
	push	bc
	ld	hl, 4
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_PutNumber
	ld	e, c
	ld	d, b
	ld	bc, _src_browser_browser_c___str_4
	call	_PutText__far
	jp	.l00106
.l00105:
;src/browser/browser.c:103: else if (size < 10485760) end = PutText(PutNumber(end, (bytes[1] >> 2) | (bytes[2] << 6)), " KB  ");
	ld	hl, sp+42
	ld	c, [hl]
	dec	hl
	dec	hl
	ld	a, [hl]
	sub	a, $00
	inc	hl
	ld	a, [hl]
	sbc	a, $00
	inc	hl
	ld	a, [hl]
	sbc	a, $A0
	inc	hl
	ld	a, [hl]
	sbc	a, $00
	jp	NC, .l00102
	dec	hl
	dec	hl
	ld	a, [hl]
	rrca
	rrca
	and	a, $3F
	ld	l, c
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
	add	hl, hl
	ld	c, a
	ld	b, $00
	ld	a, c
	or	a, l
	ld	c, a
	ld	a, b
	or	a, h
	ld	b, a
	ld	a, b
	rlca
	sbc	a, a
	ld	d, a
	ld	e, a
	push	de
	push	bc
	ld	hl, 4
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_PutNumber
	ld	e, c
	ld	d, b
	ld	bc, _src_browser_browser_c___str_5
	call	_PutText__far
	jp	.l00106
.l00102:
;src/browser/browser.c:104: else end = PutText(PutNumber(end, (bytes[2] >> 4) | (bytes[3] << 4)), " MB  ");
	srl	c
	srl	c
	srl	c
	srl	c
	ld	hl, sp+43
	ld	l, [hl]
;	spillPairReg hl
;	spillPairReg hl
	ld	h, $00
;	spillPairReg hl
;	spillPairReg hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	ld	b, $00
	ld	a, c
	or	a, l
	ld	c, a
	ld	a, b
	or	a, h
	ld	b, a
	ld	a, b
	rlca
	sbc	a, a
	ld	d, a
	ld	e, a
	push	de
	push	bc
	ld	hl, 4
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_PutNumber
	ld	e, c
	ld	d, b
	ld	bc, _src_browser_browser_c___str_6
	call	_PutText__far
.l00106:
;src/browser/browser.c:105: end = PutNumber(end, (date >> 9) + 1980);
	ld	hl, sp+45
	ld	a, [hl]
	srl	a
	ld	e, a
	ld	d, $00
	ld	hl, $07BC
	add	hl, de
	ld	e, l
	ld	d, h
	ld	hl, $0000
	push	hl
	push	de
	ld	e, c
	ld	d, b
	call	_PutNumber
;src/browser/browser.c:106: *end++ = '-';
	ld	a, $2D
	ld	[bc], a
	ld	e, c
	ld	d, b
	inc	de
;src/browser/browser.c:107: end = PutNumber2(end, (date >> 5) & 15);
	ld	hl, sp+45
	dec	hl
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	ld	a, $05
.l00147:
	srl	b
	rr	c
	dec	a
	jp	NZ, .l00147
	ld	a, c
	and	a, $0F
	ld	c, a
	ld	b, $00
	call	_PutNumber2
;src/browser/browser.c:108: *end++ = '-';
	ld	a, $2D
	ld	[bc], a
	ld	e, c
	ld	d, b
	inc	de
;src/browser/browser.c:109: end = PutNumber2(end, date & 31);
	ld	hl, sp+44
	ld	a, [hl]
	and	a, $1F
	ld	c, a
	ld	b, $00
	call	_PutNumber2
;src/browser/browser.c:110: *end++ = ' ';
	ld	a, $20
	ld	[bc], a
	ld	e, c
	ld	d, b
	inc	de
;src/browser/browser.c:111: end = PutNumber2(end, time >> 11);
	ld	hl, sp+47
	ld	a, [hl]
	swap	a
	rlca
	and	a, $1F
	ld	c, a
	ld	b, $00
	call	_PutNumber2
;src/browser/browser.c:112: *end++ = ':';
	ld	a, $3A
	ld	[bc], a
	ld	e, c
	ld	d, b
	inc	de
;src/browser/browser.c:113: end = PutNumber2(end, (time >> 5) & 63);
	ld	hl, sp+47
	dec	hl
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	ld	a, $05
.l00148:
	srl	b
	rr	c
	dec	a
	jp	NZ, .l00148
	ld	a, c
	and	a, $3F
	ld	c, a
	ld	b, $00
	call	_PutNumber2
	ld	hl, sp+46
	ld	[hl], c
	inc	hl
	ld	[hl], b
.l00115:
;src/browser/browser.c:115: *end = 0;
	ld	hl, sp+46
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	ld	[hl], $00
;src/browser/browser.c:116: DrawRow(STATUS_LINE, 1, text);
	ld	hl, 0
	add	hl, sp
	push	hl
	ld	e, $01
	ld	a, $13
	call	_DrawRow__far
.l00116:
;src/browser/browser.c:117: }
	add	sp, 51
	pop	hl
	inc	sp
	inc	sp
	jp hl
	SECTION FRAGMENT "src/browser/browser.c FIXED",ROMX,BANK[1]
_src_browser_browser_c___str_1:
	DB "Empty folder"
	DB $00
	SECTION FRAGMENT "src/browser/browser.c FIXED",ROMX,BANK[1]
_src_browser_browser_c___str_2:
	DB "Parent folder"
	DB $00
	SECTION FRAGMENT "src/browser/browser.c FIXED",ROMX,BANK[1]
_src_browser_browser_c___str_3:
	DB "Folder"
	DB $00
	SECTION FRAGMENT "src/browser/browser.c FIXED",ROMX,BANK[1]
_src_browser_browser_c___str_4:
	DB " bytes  "
	DB $00
	SECTION FRAGMENT "src/browser/browser.c FIXED",ROMX,BANK[1]
_src_browser_browser_c___str_5:
	DB " KB  "
	DB $00
	SECTION FRAGMENT "src/browser/browser.c FIXED",ROMX,BANK[1]
_src_browser_browser_c___str_6:
	DB " MB  "
	DB $00
;src/browser/browser.c:121: static void ListLoading(const char* path, unsigned char row) {
;	---------------------------------
	SECTION FRAGMENT "Page 4",ROMX,BANK[2]
	LOAD FRAGMENT "Page 4 RAM",SRAM,BANK[4]
; Function ListLoading
; ---------------------------------
_src_browser_browser_c_ListLoading:
	add	sp, -128
	add	sp, -45
	ld	hl, 171
	add	hl, sp
	ld	[hl], e
	inc	hl
	ld	[hl], d
	dec	hl
	dec	hl
	ld	[hl], a
;src/browser/browser.c:123: char* end = path[0] ? ToLatin1(text, path, PATH_SIZE - 1) : text;
	inc	hl
	inc	hl
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	ld	hl, 169
	add	hl, sp
	ld	[hl], a
	ld	a, [hl]
	or	a, a
	jp	Z, .l00114
	ld	a, $7F
	push	af
	inc	sp
	inc	hl
	inc	hl
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	ld	hl, 1
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_ToLatin1
	ld	e, c
	ld	d, b
	jp	.l00115
.l00114:
	ld	hl, 0
	add	hl, sp
	ld	e, l
	ld	d, h
.l00115:
	ld	hl, 168
	add	hl, sp
	ld	[hl], e
	inc	hl
	ld	[hl], d
;src/browser/browser.c:127: *end++ = '/';
	dec	hl
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	inc	bc
;src/browser/browser.c:126: if (row != 0xFF) {
	inc	hl
	ld	a, [hl]
	inc	a
	jp	NZ,.l00147
	jp	.l00105
.l00147:
;src/browser/browser.c:127: *end++ = '/';
	ld	hl, 168
	add	hl, sp
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	ld	[hl], $2F
;src/browser/browser.c:128: for (name = RowAddress(row) + 1; *name != '/'; ++name) *end++ = *name;
	push	bc
	ld	hl, 172
	add	hl, sp
	ld	a, [hl]
	call	_RowAddress__far
	ld	e, c
	ld	d, b
	pop	bc
	inc	de
.l00110:
	ld	a, [de]
	cp	a, $2F
	jp	NZ,.l00148
	jp	.l00122
.l00148:
	ld	[bc], a
	inc	bc
	inc	de
	jp	.l00110
.l00105:
;src/browser/browser.c:130: else if (!path[0]) *end++ = '/';
	ld	hl, 172
	add	hl, sp
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	or	a, a
	jp	NZ, .l00106
	ld	hl, 168
	add	hl, sp
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	ld	[hl], $2F
	ld	hl, 168
	add	hl, sp
	ld	[hl], c
	inc	hl
	ld	[hl], b
;src/browser/browser.c:140: ShowBusy("Loading...");
	jp	.l00106
;src/browser/browser.c:130: else if (!path[0]) *end++ = '/';
.l00122:
	ld	hl, 168
	add	hl, sp
	ld	[hl], c
	inc	hl
	ld	[hl], b
.l00106:
;src/browser/browser.c:131: *end = 0;
	ld	hl, 168
	add	hl, sp
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	ld	[hl], $00
;src/browser/browser.c:132: length = (unsigned char)(end - text);
	ld	hl, sp+0
	ld	c, l
	ld	b, h
	ld	hl, 168
	add	hl, sp
	ld	a, [hl]
	ld	e, c
	sub	a, e
	ld	e, a
;src/browser/browser.c:133: end = text;
;src/browser/browser.c:134: if (length > 30) {
	ld	a, $1E
	sub	a, e
	jp	NC, .l00108
;src/browser/browser.c:135: end += length - 33;
	ld	a, e
	ld	e, $00
	add	a, $DF
	ld	l, a
;	spillPairReg hl
;	spillPairReg hl
	ld	a, e
	adc	a, $FF
	ld	h, a
;	spillPairReg hl
;	spillPairReg hl
	add	hl, bc
	ld	c, l
	ld	b, h
;src/browser/browser.c:136: end[0] = end[1] = end[2] = '.';
	ld	e, c
	ld	d, b
	inc	de
	ld	l, c
;	spillPairReg hl
;	spillPairReg hl
	ld	h, b
;	spillPairReg hl
;	spillPairReg hl
	inc	hl
	inc	hl
	ld	[hl], $2E
	ld	a, $2E
	ld	[de], a
	ld	a, $2E
	ld	[bc], a
.l00108:
;src/browser/browser.c:138: DrawRow(HEADER_LINE, 1, end);
	push	bc
	ld	e, $01
	ld	a, $12
	call	_DrawRow__far
;src/browser/browser.c:139: DrawRow(STATUS_LINE, 1, "");
	ld	de, _src_browser_browser_c___str_7
	push	de
	ld	e, $01
	ld	a, $13
	call	_DrawRow__far
;src/browser/browser.c:140: ShowBusy("Loading...");
	ld	de, _src_browser_browser_c___str_8
	call	_ShowBusy
.l00112:
;src/browser/browser.c:141: }
	add	sp, 127
	add	sp, 46
	ret
	SECTION FRAGMENT "src/browser/browser.c FIXED",ROMX,BANK[1]
_src_browser_browser_c___str_7:
	DB $00
	SECTION FRAGMENT "src/browser/browser.c FIXED",ROMX,BANK[1]
_src_browser_browser_c___str_8:
	DB "Loading..."
	DB $00
;src/browser/browser.c:144: static void ListMessage(const char* text) {
;	---------------------------------
	SECTION FRAGMENT "Page 4",ROMX,BANK[2]
	LOAD FRAGMENT "Page 4 RAM",SRAM,BANK[4]
; Function ListMessage
; ---------------------------------
_src_browser_browser_c_ListMessage:
;src/browser/browser.c:145: HideBox();
	push	de
	call	_HideBox__far
	pop	de
;src/browser/browser.c:146: DrawRow(STATUS_LINE, 1, text);
	push	de
	ld	e, $01
	ld	a, $13
	call	_DrawRow__far
;src/browser/browser.c:147: EditorDraw();
	call	_EditorDraw
;src/browser/browser.c:148: WaitDismiss();
	jp	_WaitDismiss__far
.l00101:
;src/browser/browser.c:149: }
	ret
;src/browser/browser.c:154: unsigned char Browse(void) {
;	---------------------------------
	SECTION FRAGMENT "Page 4",ROMX,BANK[2]
	LOAD FRAGMENT "Page 4 RAM",SRAM,BANK[4]
; Function Browse
; ---------------------------------
_Browse::
	ld	hl, -272
	add	hl, sp
	ld	sp, hl
;src/browser/browser.c:157: unsigned int selected = 0, first = 0, drawn = LIST_ALL;
	xor	a, a
	ld	hl, 270
	add	hl, sp
	ld	[hl], a
	inc	hl
	ld	[hl], a
	xor	a, a
	ld	hl, 258
	add	hl, sp
	ld	[hl], a
	inc	hl
	ld	[hl], a
	inc	hl
	ld	[hl], $FF
	inc	hl
	ld	[hl], $FF
;src/browser/browser.c:158: unsigned char key, result, row, opened = 0, editor_font = font, length;
	inc	hl
	ld	[hl], $00
	ld	hl, _font
	ld	a, [hl]
	ld	hl, 263
	add	hl, sp
	ld	[hl], a
;src/browser/browser.c:159: CopyName(path, file_dir);
	ld	bc, _file_dir
	ld	hl, 0
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_CopyName
;src/browser/browser.c:160: font = FONT_VWF;
	ld	hl, _font
	ld	[hl], $01
;src/browser/browser.c:161: SetFont(font);
	ld	a, $01
	call	_SetFont
;src/browser/browser.c:162: render_text = 0;
	ld	hl, _render_text
	ld	[hl], $00
;src/browser/browser.c:163: EditorShowCursor(0);
	xor	a, a
	call	_EditorShowCursor
;src/browser/browser.c:164: if (osk_shown) OSKShow(0);
	ld	hl, _osk_shown
	ld	a, [hl]
	or	a, a
	jp	Z, .l00102
	xor	a, a
	call	_OSKShow
.l00102:
;src/browser/browser.c:165: bars = 1;
	ld	hl, _bars
	ld	[hl], $01
;src/browser/browser.c:166: tb_rows = LIST_ROWS;
	ld	hl, _tb_rows
	ld	[hl], $10
;src/browser/browser.c:167: Layout();
	call	_Layout__far
;src/browser/browser.c:168: NoHighlight();
	call	_NoHighlight__far
;src/browser/browser.c:169: ListLoading(path, 0xFF);
	ld	a, $FF
	ld	hl, 0
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_src_browser_browser_c_ListLoading
;src/browser/browser.c:170: if ((result = FileMount())) {
	call	_FileMount
	ld	hl, 269
	add	hl, sp
	ld	[hl], a
	or	a, a
	jp	Z, .l00104
;src/browser/browser.c:171: ShowError(result, "");
	ld	de, _src_browser_browser_c___str_9
	ld	a, [hl]
	call	_ShowError
;src/browser/browser.c:172: selected = LIST_ALL; // skips the list
	ld	hl, 270
	add	hl, sp
	ld	[hl], $FF
	inc	hl
	ld	[hl], $FF
	jp	.l00218
.l00104:
;src/browser/browser.c:174: else ListFolder(path, 0);
	ld	bc, $0000
	ld	hl, 0
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_src_browser_browser_c_ListFolder
;src/browser/browser.c:175: while (selected != LIST_ALL) {
.l00218:
.l00190:
	ld	hl, 270
	add	hl, sp
	ld	a, [hl]
	inc	hl
	and	a, [hl]
	inc	a
	jp	NZ,.l00458
	jp	.l00192
.l00458:
;src/browser/browser.c:176: if (selected < first) first = selected;
	ld	hl, 270
	add	hl, sp
	ld	e, l
	ld	d, h
	ld	hl, 258
	add	hl, sp
	ld	a, [de]
	inc	de
	sub	a, [hl]
	inc	hl
	ld	a, [de]
	sbc	a, [hl]
	jp	NC, .l00109
	ld	hl, 270
	add	hl, sp
	ld	a, [hl]
	ld	hl, 258
	add	hl, sp
	ld	[hl], a
	ld	hl, 271
	add	hl, sp
	ld	a, [hl]
	ld	hl, 259
	add	hl, sp
	ld	[hl], a
	jp	.l00110
.l00109:
;src/browser/browser.c:177: else if (selected >= first + LIST_ROWS) first = selected - LIST_ROWS + 1;
	ld	hl, 259
	add	hl, sp
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $0010
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, 270
	add	hl, sp
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, 269
	add	hl, sp
	ld	[hl], a
	ld	hl, 270
	add	hl, sp
	ld	e, l
	ld	d, h
	ld	hl, 268
	add	hl, sp
	ld	a, [de]
	inc	de
	sub	a, [hl]
	inc	hl
	ld	a, [de]
	sbc	a, [hl]
	jp	C, .l00110
	ld	hl, 271
	add	hl, sp
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $FFF1
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, 260
	add	hl, sp
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, 259
	add	hl, sp
	ld	[hl], a
.l00110:
;src/browser/browser.c:178: if (!list_result && first != drawn) {
	ld	hl, _src_browser_browser_c_list_result
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00120
	ld	hl, 258
	add	hl, sp
	ld	a, [hl]
	inc	hl
	inc	hl
	sub	a, [hl]
	jp	NZ,.l00459
	dec	hl
	ld	a, [hl]
	inc	hl
	inc	hl
	sub	a, [hl]
	jp	NZ,.l00459
	jp	.l00120
.l00459:
;src/browser/browser.c:179: if (drawn != LIST_ALL && first == drawn + 1) ScrollList(path, first, 1);
	ld	hl, 260
	add	hl, sp
	ld	a, [hl]
	inc	hl
	and	a, [hl]
	inc	a
	jp	NZ,.l00460
	ld	a,$01
	jp	.l00461
.l00460:
	xor	a,a
.l00461:
	ld	hl, 267
	add	hl, sp
	ld	[hl], a
	bit	0, [hl]
	jp	NZ, .l00116
	ld	hl, 261
	add	hl, sp
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $0001
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, 270
	add	hl, sp
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, 269
	add	hl, sp
	ld	[hl], a
	dec	hl
	ld	a, [hl]
	ld	hl, 258
	add	hl, sp
	sub	a, [hl]
	jp	NZ,.l00462
	ld	hl, 269
	add	hl, sp
	ld	a, [hl]
	ld	hl, 259
	add	hl, sp
	sub	a, [hl]
	jp	NZ,.l00462
	jp	.l00463
.l00462:
	jp	.l00116
.l00463:
	ld	a, $01
	push	af
	inc	sp
	ld	hl, 259
	add	hl, sp
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	ld	hl, 1
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_src_browser_browser_c_ScrollList
	jp	.l00117
.l00116:
;src/browser/browser.c:180: else if (drawn != LIST_ALL && first + 1 == drawn) ScrollList(path, first, 0);
	ld	hl, 267
	add	hl, sp
	bit	0, [hl]
	jp	NZ, .l00112
	ld	hl, 258
	add	hl, sp
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	inc	bc
	inc	hl
	ld	a, [hl]
	sub	a, c
	jp	NZ,.l00464
	inc	hl
	ld	a, [hl]
	sub	a, b
	jp	NZ,.l00464
	jp	.l00465
.l00464:
	jp	.l00112
.l00465:
	xor	a, a
	push	af
	inc	sp
	ld	hl, 259
	add	hl, sp
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	ld	hl, 1
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_src_browser_browser_c_ScrollList
	jp	.l00117
.l00112:
;src/browser/browser.c:181: else ListRows(path, first, 0, LIST_ROWS);
	ld	a, $10
	push	af
	inc	sp
	xor	a, a
	push	af
	inc	sp
	ld	hl, 260
	add	hl, sp
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	ld	hl, 2
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_src_browser_browser_c_ListRows
.l00117:
;src/browser/browser.c:182: HideBox();
	call	_HideBox__far
;src/browser/browser.c:183: drawn = first;
	ld	hl, 258
	add	hl, sp
	ld	a, [hl]
	inc	hl
	inc	hl
	ld	[hl], a
	dec	hl
	ld	a, [hl]
	inc	hl
	inc	hl
	ld	[hl], a
.l00120:
;src/browser/browser.c:185: if (list_result) {
	ld	hl, _src_browser_browser_c_list_result
	ld	a, [hl]
	or	a, a
	jp	Z, .l00125
;src/browser/browser.c:186: if (!path[0]) { // can't read the card
	ld	hl, sp+0
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00123
;src/browser/browser.c:187: ShowError(list_result, "");
	ld	de, _src_browser_browser_c___str_9
	ld	hl, _src_browser_browser_c_list_result
	ld	a, [hl]
	call	_ShowError
;src/browser/browser.c:188: break;
	jp	.l00192
.l00123:
;src/browser/browser.c:190: path[0] = 0; // folder is gone, back to the root
	ld	hl, sp+0
	ld	[hl], $00
;src/browser/browser.c:191: ListLoading(path, 0xFF);
	ld	a, $FF
	ld	hl, 0
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_src_browser_browser_c_ListLoading
;src/browser/browser.c:192: selected = ListFolder(path, 0);
	ld	bc, $0000
	ld	hl, 0
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_src_browser_browser_c_ListFolder
	ld	hl, 270
	add	hl, sp
	ld	[hl], c
	inc	hl
	ld	[hl], b
;src/browser/browser.c:193: drawn = LIST_ALL;
	ld	hl, 260
	add	hl, sp
	ld	[hl], $FF
	inc	hl
	ld	[hl], $FF
;src/browser/browser.c:194: continue;
	jp	.l00190
.l00125:
;src/browser/browser.c:196: row = (unsigned char)(selected - first);
	ld	hl, 270
	add	hl, sp
	ld	a, [hl]
	ld	hl, 258
	add	hl, sp
	ld	c, [hl]
	sub	a, c
	ld	hl, 264
	add	hl, sp
	ld	[hl], a
;src/browser/browser.c:197: ListBars(path, row, list_count);
	ld	hl, _src_browser_browser_c_list_count
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	push	de
	ld	hl, 266
	add	hl, sp
	ld	a, [hl]
	ld	hl, 2
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_src_browser_browser_c_ListBars
;src/browser/browser.c:198: NoHighlight();
	call	_NoHighlight__far
;src/browser/browser.c:199: if (list_count) render_sel[(row + 1) << 1] = 0, render_sel[((row + 1) << 1) + 1] = 0xFF;
	ld	hl, _src_browser_browser_c_list_count + 1
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	jp	Z, .l00127
	ld	hl, 264
	add	hl, sp
	ld	a, [hl]
	inc	a
	add	a, a
	ld	c, a
	ld	a, c
	ld	e, a
	rlca
	sbc	a, a
	ld	d, a
	ld	hl, _render_sel
	add	hl, de
	ld	[hl], $00
	inc	c
	ld	a, c
	rlca
	sbc	a, a
	ld	b, a
	ld	hl, _render_sel
	add	hl, bc
	ld	[hl], $FF
.l00127:
;src/browser/browser.c:200: EditorDraw();
	call	_EditorDraw
;src/browser/browser.c:201: while (!(key = MenuKey()));
.l00128:
	call	_MenuKey__far
	ld	hl, 265
	add	hl, sp
	ld	[hl], a
	or	a, a
	jp	Z, .l00128
;src/browser/browser.c:202: if (key == KEY_UP && selected) --selected;
	ld	a, [hl]
	sub	a, $82
	jp	NZ,.l00466
	jp	.l00467
.l00466:
	jp	.l00187
.l00467:
	ld	hl, 271
	add	hl, sp
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	jp	Z, .l00187
	inc	hl
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	dec	de
	dec	hl
	ld	[hl], e
	inc	hl
	ld	[hl], d
	jp	.l00190
.l00187:
;src/browser/browser.c:203: else if (key == KEY_DOWN && selected + 1 < list_count) ++selected;
	ld	hl, 265
	add	hl, sp
	ld	a, [hl]
	sub	a, $83
	jp	NZ,.l00468
	jp	.l00469
.l00468:
	jp	.l00183
.l00469:
	ld	hl, 270
	add	hl, sp
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	inc	bc
	ld	hl, _src_browser_browser_c_list_count
	ld	a, c
	sub	a, [hl]
	inc	hl
	ld	a, b
	sbc	a, [hl]
	jp	NC, .l00183
	ld	hl, 270
	add	hl, sp
	ld	[hl], c
	inc	hl
	ld	[hl], b
	jp	.l00190
.l00183:
;src/browser/browser.c:204: else if (key == KEY_PAGE_UP) selected = selected > LIST_ROWS ? selected - LIST_ROWS : 0;
	ld	hl, 265
	add	hl, sp
	ld	a, [hl]
	sub	a, $86
	jp	NZ,.l00470
	jp	.l00471
.l00470:
	jp	.l00180
.l00471:
	ld	hl, 270
	add	hl, sp
	ld	a, $10
	sub	a, [hl]
	inc	hl
	ld	a, $00
	sbc	a, [hl]
	jp	NC, .l00201
	ld	hl, 271
	add	hl, sp
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $0010
	ld	a, e
	sub	a, l
	ld	e, a
	ld	a, d
	sbc	a, h
	ld	c, e
	jp	.l00202
.l00201:
	ld	c, $00
	xor	a, a
.l00202:
	ld	hl, 270
	add	hl, sp
	ld	[hl], c
	inc	hl
	ld	[hl], a
	jp	.l00190
.l00180:
;src/browser/browser.c:205: else if (key == KEY_PAGE_DOWN && list_count) selected = selected + LIST_ROWS < list_count ? selected + LIST_ROWS : list_count - 1;
	ld	hl, _src_browser_browser_c_list_count + 1
	dec	hl
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	dec	bc
	ld	hl, 265
	add	hl, sp
	ld	a, [hl]
	sub	a, $87
	jp	NZ,.l00472
	jp	.l00473
.l00472:
	jp	.l00176
.l00473:
	ld	hl, _src_browser_browser_c_list_count + 1
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	jp	Z, .l00176
	ld	hl, 271
	add	hl, sp
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $0010
	add	hl, de
	ld	e, l
	ld	d, h
	ld	hl, _src_browser_browser_c_list_count
	ld	a, e
	sub	a, [hl]
	inc	hl
	ld	a, d
	sbc	a, [hl]
	jp	NC, .l00203
	ld	c, e
	ld	b, d
	jp	.l00204
.l00203:
.l00204:
	ld	hl, 270
	add	hl, sp
	ld	[hl], c
	inc	hl
	ld	[hl], b
	jp	.l00190
.l00176:
;src/browser/browser.c:206: else if (key == KEY_HOME) selected = 0;
	ld	hl, 265
	add	hl, sp
	ld	a, [hl]
	sub	a, $84
	jp	NZ,.l00474
	jp	.l00475
.l00474:
	jp	.l00173
.l00475:
	xor	a, a
	ld	hl, 270
	add	hl, sp
	ld	[hl], a
	inc	hl
	ld	[hl], a
	jp	.l00190
.l00173:
;src/browser/browser.c:207: else if (key == KEY_END && list_count) selected = list_count - 1;
	ld	hl, 265
	add	hl, sp
	ld	a, [hl]
	sub	a, $85
	jp	NZ,.l00476
	jp	.l00477
.l00476:
	jp	.l00169
.l00477:
	ld	hl, _src_browser_browser_c_list_count + 1
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	jp	Z, .l00169
	ld	hl, 270
	add	hl, sp
	ld	[hl], c
	inc	hl
	ld	[hl], b
	jp	.l00190
.l00169:
;src/browser/browser.c:208: else if ((key == KEY_ENTER || key == KEY_RIGHT) && list_count && list_kinds[row] != KIND_UP) {
	ld	hl, 265
	add	hl, sp
	ld	a, [hl]
	sub	a, $0A
	jp	NZ,.l00478
	ld	a,$01
	jp	.l00479
.l00478:
	xor	a,a
.l00479:
	ld	hl, 266
	add	hl, sp
	ld	[hl], a
	dec	hl
	ld	a, [hl]
	sub	a, $81
	jp	NZ,.l00480
	ld	a,$01
	jp	.l00481
.l00480:
	xor	a,a
.l00481:
	ld	hl, 267
	add	hl, sp
	ld	[hl], a
	dec	hl
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00166
	inc	hl
	ld	a, [hl]
	or	a, a
	jp	Z, .l00163
.l00166:
	ld	hl, _src_browser_browser_c_list_count + 1
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	jp	Z, .l00163
	ld	de, _src_browser_browser_c_list_kinds
	ld	hl, 264
	add	hl, sp
	ld	l, [hl]
	ld	h, $00
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, [bc]
	or	a, a
	jp	Z, .l00163
;src/browser/browser.c:209: if (list_kinds[row] == KIND_FOLDER) ListLoading(path, row);
	dec	a
	jp	NZ,.l00482
	jp	.l00483
.l00482:
	jp	.l00132
.l00483:
	ld	hl, 264
	add	hl, sp
	ld	a, [hl]
	ld	hl, 0
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_src_browser_browser_c_ListLoading
	jp	.l00133
.l00132:
;src/browser/browser.c:210: else ShowBusy("Loading...");
	ld	de, _src_browser_browser_c___str_10
	call	_ShowBusy
.l00133:
;src/browser/browser.c:211: if (ListEntry(path, selected) == 0xFF) continue; // its full name
	ld	hl, 270
	add	hl, sp
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	ld	hl, 0
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_src_browser_browser_c_ListEntry
	inc	a
	jp	NZ,.l00484
	jp	.l00190
.l00484:
;src/browser/browser.c:212: for (length = 0; path[length]; ++length);
	ld	hl, 269
	add	hl, sp
	ld	[hl], $00
.l00194:
	push	hl
	ld	hl, 2
	add	hl, sp
	ld	e, l
	ld	d, h
	pop	hl
	ld	hl, 269
	add	hl, sp
	ld	l, [hl]
	ld	h, $00
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, 269
	add	hl, sp
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, 268
	add	hl, sp
	ld	[hl], a
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	or	a, a
	jp	Z, .l00136
	inc	hl
	inc	[hl]
	jp	.l00194
.l00136:
;src/browser/browser.c:213: if (entry.dir) {
	ld	a, [(_src_browser_browser_c_entry + 73) + 0]
	or	a, a
	jp	Z, .l00143
;src/browser/browser.c:214: if (JoinPath(path + length, "", entry.name, PATH_SIZE - length)) {
	ld	hl, 269
	add	hl, sp
	ld	c, [hl]
	ld	a, $80
	sub	a, c
	dec	hl
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	push	af
	inc	sp
	ld	bc, _src_browser_browser_c_entry
	push	bc
	ld	bc, _src_browser_browser_c___str_9
	call	_JoinPath
	or	a, a
	jp	Z, .l00138
;src/browser/browser.c:215: selected = ListFolder(path, 0);
	ld	bc, $0000
	ld	hl, 0
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_src_browser_browser_c_ListFolder
	ld	hl, 270
	add	hl, sp
	ld	[hl], c
	inc	hl
	ld	[hl], b
;src/browser/browser.c:216: drawn = LIST_ALL;
	ld	hl, 260
	add	hl, sp
	ld	[hl], $FF
	inc	hl
	ld	[hl], $FF
	jp	.l00190
.l00138:
;src/browser/browser.c:219: path[length] = 0;
	ld	hl, 267
	add	hl, sp
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	ld	[hl], $00
;src/browser/browser.c:220: ListMessage("Path is too long");
	ld	de, _src_browser_browser_c___str_11
	call	_src_browser_browser_c_ListMessage
	jp	.l00190
.l00143:
;src/browser/browser.c:224: JoinPath(path + length, "", entry.name, FS_NAME_SIZE + 1);
	ld	hl, 267
	add	hl, sp
	ld	a, [hl]
	dec	hl
	dec	hl
	ld	[hl], a
	ld	hl, 268
	add	hl, sp
	ld	a, [hl]
	dec	hl
	dec	hl
	ld	[hl], a
	ld	a, $42
	push	af
	inc	sp
	ld	de, _src_browser_browser_c_entry
	push	de
	ld	bc, _src_browser_browser_c___str_9
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_JoinPath
;src/browser/browser.c:225: if (IsGame(entry.name)) {
	ld	de, _src_browser_browser_c_entry
	call	_IsGame__far
	ld	b, a
	ld	a, b
	or	a, a
	jp	Z, .l00141
;src/browser/browser.c:226: LaunchGame(path); // returns if it doesn't launch
	ld	hl, 0
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_LaunchGame__far
;src/browser/browser.c:227: path[length] = 0;
	ld	hl, 267
	add	hl, sp
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	ld	[hl], $00
;src/browser/browser.c:228: drawn = LIST_ALL;
	ld	hl, 260
	add	hl, sp
	ld	[hl], $FF
	inc	hl
	ld	[hl], $FF
;src/browser/browser.c:229: continue;
	jp	.l00190
.l00141:
;src/browser/browser.c:231: LoadDocument(path, length, &entry);
	ld	de, _src_browser_browser_c_entry
	push	de
	ld	hl, 271
	add	hl, sp
	ld	a, [hl]
	ld	hl, 2
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_LoadDocument__far
;src/browser/browser.c:232: opened = 1;
	ld	hl, 262
	add	hl, sp
	ld	[hl], $01
;src/browser/browser.c:233: break;
	jp	.l00192
.l00163:
;src/browser/browser.c:236: else if (path[0] && (key == KEY_LEFT || key == KEY_BACKSPACE ||
	ld	hl, sp+0
	ld	a, [hl]
	ld	hl, 268
	add	hl, sp
	ld	[hl], a
	ld	hl, 265
	add	hl, sp
	ld	a, [hl]
	sub	a, $08
	jp	NZ,.l00485
	ld	a,$01
	jp	.l00486
.l00485:
	xor	a,a
.l00486:
	ld	hl, 269
	add	hl, sp
	ld	[hl], a
	dec	hl
	ld	a, [hl]
	or	a, a
	jp	Z, .l00154
	ld	hl, 265
	add	hl, sp
	ld	a, [hl]
	sub	a, $80
	jp	NZ,.l00487
	jp	.l00250
.l00487:
	ld	hl, 269
	add	hl, sp
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00250
;src/browser/browser.c:237: ((key == KEY_ENTER || key == KEY_RIGHT) && list_count && list_kinds[row] == KIND_UP))) {
	ld	hl, 266
	add	hl, sp
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00158
	inc	hl
	ld	a, [hl]
	or	a, a
	jp	Z, .l00154
.l00158:
	ld	hl, _src_browser_browser_c_list_count + 1
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	jp	Z, .l00154
	ld	de, _src_browser_browser_c_list_kinds
	ld	hl, 264
	add	hl, sp
	ld	l, [hl]
	ld	h, $00
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, 269
	add	hl, sp
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, 268
	add	hl, sp
	ld	[hl], a
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	or	a, a
	jp	NZ, .l00154
;src/browser/browser.c:238: for (length = 0; path[length]; ++length);
.l00250:
	ld	hl, 271
	add	hl, sp
	ld	[hl], $00
.l00197:
	push	hl
	ld	hl, 2
	add	hl, sp
	ld	e, l
	ld	d, h
	pop	hl
	ld	hl, 271
	add	hl, sp
	ld	l, [hl]
	ld	h, $00
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, 271
	add	hl, sp
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, 270
	add	hl, sp
	ld	[hl], a
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	or	a, a
	jp	Z, .l00251
	inc	hl
	inc	[hl]
	jp	.l00197
;src/browser/browser.c:239: while (path[--length] != '/');
.l00251:
.l00146:
	ld	hl, 271
	add	hl, sp
	dec	[hl]
	push	hl
	ld	hl, 2
	add	hl, sp
	ld	e, l
	ld	d, h
	pop	hl
	ld	hl, 271
	add	hl, sp
	ld	l, [hl]
	ld	h, $00
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, 270
	add	hl, sp
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, 269
	add	hl, sp
	ld	[hl], a
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	sub	a, $2F
	jp	NZ,.l00488
	jp	.l00489
.l00488:
	jp	.l00146
.l00489:
;src/browser/browser.c:240: CopyName(name, path + length + 1);
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $0001
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, 272
	add	hl, sp
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, 271
	add	hl, sp
	ld	[hl], a
	dec	hl
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	ld	hl, 193
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_CopyName
;src/browser/browser.c:241: path[length] = 0;
	ld	hl, 268
	add	hl, sp
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	ld	[hl], $00
;src/browser/browser.c:242: ListLoading(path, 0xFF);
	ld	a, $FF
	ld	hl, 0
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_src_browser_browser_c_ListLoading
;src/browser/browser.c:243: selected = ListFolder(path, name); // back on the folder it came from
	ld	hl, 193
	add	hl, sp
	ld	c, l
	ld	b, h
	ld	hl, 0
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_src_browser_browser_c_ListFolder
	ld	hl, 270
	add	hl, sp
	ld	[hl], c
	inc	hl
	ld	[hl], b
;src/browser/browser.c:244: drawn = LIST_ALL;
	ld	hl, 260
	add	hl, sp
	ld	[hl], $FF
	inc	hl
	ld	[hl], $FF
	jp	.l00190
.l00154:
;src/browser/browser.c:246: else if (key == KEY_ESCAPE || key == KEY_BACKSPACE || key == KEY_MENU) break;
	ld	hl, 265
	add	hl, sp
	ld	a, [hl]
	sub	a, $1B
	jp	NZ,.l00490
	jp	.l00192
.l00490:
	ld	hl, 269
	add	hl, sp
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00192
	ld	hl, 265
	add	hl, sp
	ld	a, [hl]
	sub	a, $89
	jp	NZ,.l00491
	jp	.l00492
.l00491:
	jp	.l00190
.l00492:
.l00192:
;src/browser/browser.c:248: font = editor_font;
	ld	hl, 263
	add	hl, sp
	ld	a, [hl]
	ld	hl, _font
	ld	[hl], a
;src/browser/browser.c:249: SetFont(font);
	ld	a, [hl]
	call	_SetFont
;src/browser/browser.c:250: render_text = 1;
	ld	hl, _render_text
	ld	[hl], $01
;src/browser/browser.c:251: SetRows();
	call	_SetRows__far
;src/browser/browser.c:252: return opened;
	ld	hl, 262
	add	hl, sp
	ld	a, [hl]
.l00199:
;src/browser/browser.c:253: }
	ld	hl, 272
	add	hl, sp
	ld	sp, hl
	ret
	SECTION FRAGMENT "src/browser/browser.c FIXED",ROMX,BANK[1]
_src_browser_browser_c___str_9:
	DB $00
	SECTION FRAGMENT "src/browser/browser.c FIXED",ROMX,BANK[1]
_src_browser_browser_c___str_10:
	DB "Loading..."
	DB $00
	SECTION FRAGMENT "src/browser/browser.c FIXED",ROMX,BANK[1]
_src_browser_browser_c___str_11:
	DB "Path is too long"
	DB $00
	SECTION FRAGMENT "src/browser/browser.c FIXED",ROMX,BANK[1]
	SECTION FRAGMENT "_INITIALIZER",ROM0
	SECTION FRAGMENT "_CABS (ABS)",ROM0
