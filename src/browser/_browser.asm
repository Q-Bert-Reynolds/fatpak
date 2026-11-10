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
	EXPORT _DrawRow
	EXPORT _RowAddress
	EXPORT _NoHighlight
	EXPORT _ScrollRing
	EXPORT _Layout
	EXPORT _EditorDraw
	EXPORT _SetFont
	EXPORT _HideBox
	EXPORT _ShowBusy
	EXPORT _OpenBox
	EXPORT _WaitDismiss
	EXPORT _MenuKey
	EXPORT _RestartDevice
	EXPORT _LaunchGame
	EXPORT _IsGame
	EXPORT _SetRows
	EXPORT _tb_ScrollRows
	EXPORT _tb_Clear
	EXPORT _SettingsSave
	EXPORT _OSKShow
	EXPORT _OpenKeyboard
	EXPORT _ShowBrowserHelp
	EXPORT _AskName
	EXPORT _LoadDocument
	EXPORT _SetLang
	EXPORT _FileCloseLarge
	EXPORT _FileSaveSwap
	EXPORT _FileListEntry
	EXPORT _FileList
	EXPORT _FileCopy
	EXPORT _FileRenameName
	EXPORT _FileRename
	EXPORT _FileMount
	EXPORT _EditorShowCursor
	EXPORT _JoinPath
	EXPORT _PutPath
	EXPORT _ToLatin1
	EXPORT _PreferencesMenu
	EXPORT _ShowError
	EXPORT _Choose
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
_src_browser_browser_c_clipboard_cut:
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
	SECTION FRAGMENT "src/browser/browser.c_HOME",ROM0
	SECTION FRAGMENT "src/browser/browser.c_HOME",ROM0
;--------------------------------------------------------
; code
;--------------------------------------------------------
	SECTION FRAGMENT "src/browser/browser.c_CODE",ROMX
;src/browser/browser.c:40: static unsigned int ListFolder(const char* path, const char* find) {
;	---------------------------------
	SECTION FRAGMENT "src/browser/browser.c FIXED",ROMX,BANK[1]
; Function ListFolder
; ---------------------------------
_src_browser_browser_c_ListFolder:
	add	sp, -3
	ld	hl, sp+1
	ld	[hl], c
	inc	hl
	ld	[hl], b
;src/browser/browser.c:41: unsigned char up = path[0] != 0;
	ld	a, [de]
	sub	a,$01
	ld	a, $00
	rla
	xor	a, $01
	dec	hl
	dec	hl
	ld	[hl], a
;src/browser/browser.c:42: list_count = 0;
	xor	a, a
	ld	hl, _src_browser_browser_c_list_count
	ld	[hl], a
	inc	hl
	ld	[hl], a
;src/browser/browser.c:43: if ((list_result = FileList(path, find))) return 0;
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
;src/browser/browser.c:44: list_count = fs_count + up;
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
;src/browser/browser.c:45: return find && fs_found != 0xFFFF ? fs_found + up : 0;
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
;src/browser/browser.c:46: }
	add	sp, 3
	ret
	SECTION FRAGMENT "src/browser/browser.c FIXED",ROMX,BANK[1]
_src_browser_browser_c_browser_items:
	DB "FILE"
	DB $00
	DB $00
	DB $00
	DB $00
	DB $00
	DB $00
	DB $00
	DB $00
	DB $00
	DB $00
	DB "EDIT"
	DB $00
	DB $00
	DB $00
	DB $00
	DB $00
	DB $00
	DB $00
	DB $00
	DB $00
	DB $00
	DB "SETTINGS"
	DB $00
	DB $00
	DB $00
	DB $00
	DB $00
	DB $00
	DB "HELP"
	DB $00
	DB $00
	DB $00
	DB $00
	DB $00
	DB $00
	DB $00
	DB $00
	DB $00
	DB $00
	DB "RESTART"
	DB $00
	DB $00
	DB $00
	DB $00
	DB $00
	DB $00
	DB $00
	SECTION FRAGMENT "src/browser/browser.c FIXED",ROMX,BANK[1]
_src_browser_browser_c_file_items:
	DB "INFO"
	DB $00
	DB $00
	DB $00
	DB $00
	DB $00
	DB $00
	DB $00
	DB $00
	DB $00
	DB $00
	DB "RENAME"
	DB $00
	DB $00
	DB $00
	DB $00
	DB $00
	DB $00
	DB $00
	DB $00
	SECTION FRAGMENT "src/browser/browser.c FIXED",ROMX,BANK[1]
_src_browser_browser_c_edit_items:
	DB "CUT"
	DB $00
	DB $00
	DB $00
	DB $00
	DB $00
	DB $00
	DB $00
	DB $00
	DB $00
	DB $00
	DB $00
	DB "COPY"
	DB $00
	DB $00
	DB $00
	DB $00
	DB $00
	DB $00
	DB $00
	DB $00
	DB $00
	DB $00
	DB "PASTE"
	DB $00
	DB $00
	DB $00
	DB $00
	DB $00
	DB $00
	DB $00
	DB $00
	DB $00
;src/browser/browser.c:49: static unsigned char ListEntry(const char* path, unsigned int index) {
;	---------------------------------
	SECTION FRAGMENT "Page 6",ROMX,BANK[3]
	LOAD FRAGMENT "Page 6 RAM",SRAM,BANK[6]
; Function ListEntry
; ---------------------------------
_src_browser_browser_c_ListEntry:
	dec	sp
	dec	sp
	inc	sp
	inc	sp
	push	bc
;src/browser/browser.c:50: if (path[0] && !index--) {
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
;src/browser/browser.c:51: entry.name[0] = '.';
	ld	hl, _src_browser_browser_c_entry
	ld	[hl], $2E
;src/browser/browser.c:52: entry.name[1] = '.';
	ld	hl, (_src_browser_browser_c_entry + 1)
	ld	[hl], $2E
;src/browser/browser.c:53: entry.name[2] = 0;
	ld	hl, (_src_browser_browser_c_entry + 2)
	ld	[hl], $00
;src/browser/browser.c:54: return KIND_UP;
	xor	a, a
	jp	.l00106
.l00102:
;src/browser/browser.c:56: if ((list_result = FileListEntry(index, &entry))) return 0xFF;
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
;src/browser/browser.c:57: return entry.dir ? KIND_FOLDER : KIND_FILE;
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
;src/browser/browser.c:58: }
	inc	sp
	inc	sp
	ret
;src/browser/browser.c:61: static void ListRows(const char* path, unsigned int first, unsigned char row, unsigned char end) {
;	---------------------------------
	SECTION FRAGMENT "Page 11",ROMX,BANK[5]
	LOAD FRAGMENT "Page 11 RAM",SRAM,BANK[11]
; Function ListRows
; ---------------------------------
_src_browser_browser_c_ListRows:
	add	sp, -8
	ld	hl, sp+5
	ld	[hl], e
	inc	hl
	ld	[hl], d
	ld	hl, sp+3
	ld	[hl], c
	inc	hl
	ld	[hl], b
	ld	hl, sp+10
	ld	a, [hl]
	ld	hl, sp+7
	ld	[hl], a
.l00110:
;src/browser/browser.c:64: for (; row < end; ++row) {
	ld	hl, sp+7
	ld	a, [hl]
	ld	hl, sp+11
	sub	a, [hl]
	jp	NC, .l00111
;src/browser/browser.c:65: DrawRow(row, 0, "");
	ld	de, _src_browser_browser_c___str_10
	push	de
	ld	e, $00
	ld	hl, sp+9
	ld	a, [hl]
	call	_DrawRow__far
;src/browser/browser.c:66: if (first + row >= list_count) continue;
	ld	hl, sp+7
	ld	c, [hl]
	ld	b, $00
	ld	hl, sp+3
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
;src/browser/browser.c:67: if ((kind = ListEntry(path, first + row)) == 0xFF) return;
	ld	hl, sp+5
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_src_browser_browser_c_ListEntry__far
	ld	hl, sp+0
	ld	[hl], a
	inc	a
	jp	NZ,.l00138
	jp	.l00139
.l00138:
	jp	.l00104
.l00139:
	jp	.l00111
.l00104:
;src/browser/browser.c:68: list_kinds[row] = kind;
	ld	de, _src_browser_browser_c_list_kinds
	ld	hl, sp+7
	ld	l, [hl]
	ld	h, $00
	add	hl, de
	ld	c, l
	ld	b, h
	ld	hl, sp+0
	ld	a, [hl]
	ld	[bc], a
;src/browser/browser.c:69: dest = ToLatin1(RowAddress(row) + 1, entry.name, TB_STRIDE - 3);
	ld	hl, sp+7
	ld	a, [hl]
	call	_RowAddress__far
	ld	e, c
	ld	d, b
	inc	de
	ld	a, $25
	push	af
	inc	sp
	ld	bc, _src_browser_browser_c_entry
	call	_ToLatin1__far
	ld	hl, sp+1
	ld	[hl], c
	inc	hl
	ld	[hl], b
;src/browser/browser.c:70: if (kind == KIND_FOLDER) *dest = '/';
	dec	hl
	dec	hl
	ld	a, [hl]
	dec	a
	jp	NZ,.l00140
	jp	.l00141
.l00140:
	jp	.l00107
.l00141:
	ld	hl, sp+1
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	ld	[hl], $2F
.l00107:
;src/browser/browser.c:64: for (; row < end; ++row) {
	ld	hl, sp+7
	inc	[hl]
	jp	.l00110
.l00111:
;src/browser/browser.c:72: }
	add	sp, 8
	pop	hl
	inc	sp
	inc	sp
	jp hl
	SECTION FRAGMENT "src/browser/browser.c FIXED",ROMX,BANK[1]
_src_browser_browser_c___str_10:
	DB $00
;src/browser/browser.c:75: static void ScrollList(const char* path, unsigned int first, unsigned char down) {
;	---------------------------------
	SECTION FRAGMENT "src/browser/browser.c FIXED",ROMX,BANK[1]
; Function ScrollList
; ---------------------------------
_src_browser_browser_c_ScrollList:
	add	sp, -4
	ld	hl, sp+2
	ld	[hl], e
	inc	hl
	ld	[hl], d
	inc	sp
	inc	sp
	push	bc
;src/browser/browser.c:77: ScrollRing(down);
	ld	hl, sp+6
	ld	a, [hl]
	call	_ScrollRing__far
;src/browser/browser.c:78: tb_ScrollRows(down);
	ld	hl, sp+6
	ld	a, [hl]
	call	_tb_ScrollRows
;src/browser/browser.c:79: for (i = 1; i < LIST_ROWS; ++i) {
	ld	c, $01
.l00102:
;src/browser/browser.c:80: to = down ? i - 1 : LIST_ROWS - i;
	ld	e, c
	ld	hl, sp+6
	ld	a, [hl]
	or	a, a
	jp	Z, .l00106
	dec	e
	jp	.l00107
.l00106:
	ld	a, $10
	sub	a, e
	ld	e, a
.l00107:
;src/browser/browser.c:81: from = down ? i : to - 1;
	ld	hl, sp+6
	ld	a, [hl]
	or	a, a
	jp	Z, .l00108
	ld	b, c
	jp	.l00109
.l00108:
	ld	b, e
	dec	b
.l00109:
;src/browser/browser.c:82: list_kinds[to] = list_kinds[from];
	ld	hl, _src_browser_browser_c_list_kinds
	ld	d, $00
	add	hl, de
	ld	a, b
	add	a, LOW(_src_browser_browser_c_list_kinds)
	ld	e, a
	ld	a, $00
	adc	a, HIGH(_src_browser_browser_c_list_kinds)
	ld	d, a
	ld	a, [de]
	ld	[hl], a
;src/browser/browser.c:79: for (i = 1; i < LIST_ROWS; ++i) {
	inc	c
	ld	a, c
	sub	a, $10
	jp	C, .l00102
;src/browser/browser.c:84: i = down ? LIST_ROWS - 1 : 0;
	ld	hl, sp+6
	ld	a, [hl]
	or	a, a
	jp	Z, .l00110
	ld	de, $000F
	jp	.l00111
.l00110:
	ld	de, $0000
.l00111:
	ld	a, e
;src/browser/browser.c:85: ListRows(path, first, i, i + 1);
	ld	b, a
	inc	b
	push	bc
	inc	sp
	push	af
	inc	sp
	pop	hl
	pop	bc
	push	bc
	push	hl
	ld	hl, sp+4
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_src_browser_browser_c_ListRows__far
.l00104:
;src/browser/browser.c:86: }
	add	sp, 4
	pop	hl
	inc	sp
	jp hl
;src/browser/browser.c:89: static void ListBars(const char* path) {
;	---------------------------------
	SECTION FRAGMENT "Page 4",ROMX,BANK[2]
	LOAD FRAGMENT "Page 4 RAM",SRAM,BANK[4]
; Function ListBars
; ---------------------------------
_src_browser_browser_c_ListBars:
	add	sp, -40
	ld	c, e
	ld	b, d
;src/browser/browser.c:91: PutPath(text, path, 30);
	ld	hl, sp+0
	ld	e, l
	ld	d, h
	ld	l, e
;	spillPairReg hl
;	spillPairReg hl
	ld	h, d
;	spillPairReg hl
;	spillPairReg hl
	push	de
	ld	a, $1E
	push	af
	inc	sp
	ld	e, l
	ld	d, h
	call	_PutPath
	pop	de
;src/browser/browser.c:92: DrawRow(HEADER_LINE, 1, text);
	push	de
	ld	e, $01
	ld	a, $12
	call	_DrawRow__far
;src/browser/browser.c:93: DrawRow(STATUS_LINE, 1, "");
	ld	de, _src_browser_browser_c___str_11
	push	de
	ld	e, $01
	ld	a, $13
	call	_DrawRow__far
.l00101:
;src/browser/browser.c:94: }
	add	sp, 40
	ret
	SECTION FRAGMENT "src/browser/browser.c FIXED",ROMX,BANK[1]
_src_browser_browser_c___str_11:
	DB $00
;src/browser/browser.c:98: static void ListLoading(const char* path, unsigned char row) {
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
;src/browser/browser.c:100: char* end = path[0] ? ToLatin1(text, path, PATH_SIZE - 1) : text;
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
;src/browser/browser.c:104: *end++ = '/';
	dec	hl
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	inc	bc
;src/browser/browser.c:103: if (row != 0xFF) {
	inc	hl
	ld	a, [hl]
	inc	a
	jp	NZ,.l00147
	jp	.l00105
.l00147:
;src/browser/browser.c:104: *end++ = '/';
	ld	hl, 168
	add	hl, sp
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	ld	[hl], $2F
;src/browser/browser.c:105: for (name = RowAddress(row) + 1; *name != '/'; ++name) *end++ = *name;
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
;src/browser/browser.c:107: else if (!path[0]) *end++ = '/';
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
;src/browser/browser.c:117: ShowBusy("Loading...");
	jp	.l00106
;src/browser/browser.c:107: else if (!path[0]) *end++ = '/';
.l00122:
	ld	hl, 168
	add	hl, sp
	ld	[hl], c
	inc	hl
	ld	[hl], b
.l00106:
;src/browser/browser.c:108: *end = 0;
	ld	hl, 168
	add	hl, sp
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	ld	[hl], $00
;src/browser/browser.c:109: length = (unsigned char)(end - text);
	ld	hl, sp+0
	ld	c, l
	ld	b, h
	ld	hl, 168
	add	hl, sp
	ld	a, [hl]
	ld	e, c
	sub	a, e
	ld	e, a
;src/browser/browser.c:110: end = text;
;src/browser/browser.c:111: if (length > 30) {
	ld	a, $1E
	sub	a, e
	jp	NC, .l00108
;src/browser/browser.c:112: end += length - 33;
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
;src/browser/browser.c:113: end[0] = end[1] = end[2] = '.';
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
;src/browser/browser.c:115: DrawRow(HEADER_LINE, 1, end);
	push	bc
	ld	e, $01
	ld	a, $12
	call	_DrawRow__far
;src/browser/browser.c:116: DrawRow(STATUS_LINE, 1, "");
	ld	de, _src_browser_browser_c___str_12
	push	de
	ld	e, $01
	ld	a, $13
	call	_DrawRow__far
;src/browser/browser.c:117: ShowBusy("Loading...");
	ld	de, _src_browser_browser_c___str_13
	call	_ShowBusy
.l00112:
;src/browser/browser.c:118: }
	add	sp, 127
	add	sp, 46
	ret
	SECTION FRAGMENT "src/browser/browser.c FIXED",ROMX,BANK[1]
_src_browser_browser_c___str_12:
	DB $00
	SECTION FRAGMENT "src/browser/browser.c FIXED",ROMX,BANK[1]
_src_browser_browser_c___str_13:
	DB "Loading..."
	DB $00
;src/browser/browser.c:121: static void ListMessage(const char* text) {
;	---------------------------------
	SECTION FRAGMENT "Page 8",ROMX,BANK[4]
	LOAD FRAGMENT "Page 8 RAM",SRAM,BANK[8]
; Function ListMessage
; ---------------------------------
_src_browser_browser_c_ListMessage:
;src/browser/browser.c:122: HideBox();
	push	de
	call	_HideBox__far
	pop	de
;src/browser/browser.c:123: DrawRow(STATUS_LINE, 1, text);
	push	de
	ld	e, $01
	ld	a, $13
	call	_DrawRow__far
;src/browser/browser.c:124: EditorDraw();
	call	_EditorDraw
;src/browser/browser.c:125: WaitDismiss();
	jp	_WaitDismiss__far
.l00101:
;src/browser/browser.c:126: }
	ret
;src/browser/browser.c:128: static void BrowserError(unsigned char result) {
;	---------------------------------
	SECTION FRAGMENT "src/browser/browser.c FIXED",ROMX,BANK[1]
; Function BrowserError
; ---------------------------------
_src_browser_browser_c_BrowserError:
	ld	c, a
;src/browser/browser.c:129: if (!result) return;
	ld	a, c
	or	a, a
	jp	NZ, .l00102
	jp	.l00112
.l00102:
;src/browser/browser.c:130: if (result == 8) ListMessage("Name already exists");
	ld	a, c
	sub	a, $08
	jp	NZ,.l00134
	jp	.l00135
.l00134:
	jp	.l00110
.l00135:
	ld	de, _src_browser_browser_c___str_14
	jp	_src_browser_browser_c_ListMessage__far
	jp	.l00112
.l00110:
;src/browser/browser.c:131: else if (result == 7) ListMessage("Can't paste here");
	ld	a, c
	sub	a, $07
	jp	NZ,.l00136
	jp	.l00137
.l00136:
	jp	.l00107
.l00137:
	ld	de, _src_browser_browser_c___str_15
	jp	_src_browser_browser_c_ListMessage__far
	jp	.l00112
.l00107:
;src/browser/browser.c:132: else if (result == 6) ListMessage("Invalid name/path");
	ld	a, c
	sub	a, $06
	jp	NZ,.l00138
	jp	.l00139
.l00138:
	jp	.l00104
.l00139:
	ld	de, _src_browser_browser_c___str_16
	jp	_src_browser_browser_c_ListMessage__far
	jp	.l00112
.l00104:
;src/browser/browser.c:133: else ListMessage("SD operation failed");
	ld	de, _src_browser_browser_c___str_17
	jp	_src_browser_browser_c_ListMessage__far
.l00112:
;src/browser/browser.c:134: }
	ret
	SECTION FRAGMENT "src/browser/browser.c FIXED",ROMX,BANK[1]
_src_browser_browser_c___str_14:
	DB "Name already exists"
	DB $00
	SECTION FRAGMENT "src/browser/browser.c FIXED",ROMX,BANK[1]
_src_browser_browser_c___str_15:
	DB "Can't paste here"
	DB $00
	SECTION FRAGMENT "src/browser/browser.c FIXED",ROMX,BANK[1]
_src_browser_browser_c___str_16:
	DB "Invalid name/path"
	DB $00
	SECTION FRAGMENT "src/browser/browser.c FIXED",ROMX,BANK[1]
_src_browser_browser_c___str_17:
	DB "SD operation failed"
	DB $00
;src/browser/browser.c:136: static void FileInfo(void) {
;	---------------------------------
	SECTION FRAGMENT "src/browser/browser.c FIXED",ROMX,BANK[1]
; Function FileInfo
; ---------------------------------
_src_browser_browser_c_FileInfo:
	add	sp, -74
;src/browser/browser.c:137: char* line = RowAddress(BOX_LINE);
	ld	a, $14
	call	_RowAddress__far
	ld	e, c
	ld	d, b
;src/browser/browser.c:140: unsigned char i = 0, n = 0, rows = 0;
	ld	hl, sp+73
	ld	[hl], $00
;src/browser/browser.c:141: *ToLatin1(name, entry.name, FS_NAME_SIZE - 1) = 0;
	push	de
	ld	a, $40
	push	af
	inc	sp
	ld	bc, _src_browser_browser_c_entry
	ld	hl, 3
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_ToLatin1__far
	pop	de
	xor	a, a
	ld	[bc], a
;src/browser/browser.c:142: do {
	ld	hl, sp+69
	ld	[hl], e
	inc	hl
	ld	[hl], d
	inc	hl
	ld	[hl], $00
;src/browser/browser.c:143: for (n = 0; n < BOX_STRIDE - 1 && name[i]; ++n) line[n] = name[i++];
.l00120:
	ld	hl, sp+73
	ld	a, [hl]
	dec	hl
	ld	[hl], a
	inc	hl
	ld	[hl], $00
.l00110:
	push	hl
	ld	hl, 2
	add	hl, sp
	ld	e, l
	ld	d, h
	pop	hl
	ld	hl, sp+72
	ld	l, [hl]
	ld	h, $00
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+67
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+66
	ld	[hl], a
	ld	hl, sp+70
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, sp+73
	ld	l, [hl]
	ld	h, $00
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+69
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+68
	ld	[hl], a
	ld	hl, sp+73
	ld	a, [hl]
	sub	a, $13
	jp	NC, .l00126
	ld	hl, sp+66
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	or	a, a
	jp	Z, .l00126
	ld	hl, sp+72
	inc	[hl]
	ld	hl, sp+67
	push	af
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	pop	af
	ld	[hl], a
	ld	hl, sp+73
	inc	[hl]
	jp	.l00110
.l00126:
	ld	hl, sp+72
	ld	a, [hl]
	inc	hl
	ld	[hl], a
;src/browser/browser.c:144: line[n] = 0;
	ld	hl, sp+67
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	ld	[hl], $00
;src/browser/browser.c:145: line += BOX_STRIDE;
	ld	hl, sp+70
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $0014
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+71
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+70
	ld	[hl], a
;src/browser/browser.c:146: ++rows;
	inc	hl
	inc	[hl]
;src/browser/browser.c:147: } while (name[i]);
	ld	hl, sp+66
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	or	a, a
	jp	NZ, .l00120
;src/browser/browser.c:148: if (entry.dir) CopyName(line, "Folder");
	ld	hl, sp+69
	ld	a, [hl]
	dec	hl
	dec	hl
	ld	[hl], a
	ld	hl, sp+70
	ld	a, [hl]
	dec	hl
	dec	hl
	ld	[hl], a
	ld	hl, sp+71
	ld	a, [hl]
	inc	hl
	inc	hl
	ld	[hl], a
	ld	a, [(_src_browser_browser_c_entry + 73) + 0]
	or	a, a
	jp	Z, .l00106
	ld	bc, _src_browser_browser_c___str_18
	ld	hl, sp+69
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_CopyName__far
	jp	.l00107
.l00106:
;src/browser/browser.c:150: end = PutNumber(line, entry.size < 1000000 ? entry.size : entry.size >> 10);
	ld	de, (_src_browser_browser_c_entry + 65) + 0
	ld	a, [de]
	ld	hl, sp+69
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
	ld	hl, sp+69
	ld	a, [hl]
	sub	a, $40
	inc	hl
	ld	a, [hl]
	sbc	a, $42
	inc	hl
	ld	a, [hl]
	sbc	a, $0F
	inc	hl
	ld	a, [hl]
	sbc	a, $00
	jp	NC, .l00114
	ld	hl, sp+69
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	inc	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	jp	.l00115
.l00114:
	ld	hl, sp+70
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	inc	hl
	ld	e, [hl]
	ld	d, $00
	ld	a, $02
.l00160:
	srl	e
	rr	b
	rr	c
.l00161:
	dec	a
	jr	NZ, .l00160
.l00115:
	push	de
	push	bc
	ld	hl, sp+71
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_PutNumber__far
	ld	hl, sp+69
	ld	[hl], c
	inc	hl
	ld	[hl], b
;src/browser/browser.c:151: CopyName(end, entry.size < 1000000 ? " bytes" : " KiB");
	ld	hl, (_src_browser_browser_c_entry + 65) + 0
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	inc	hl
	inc	hl
	ld	a, [hl]
	dec	hl
	ld	l, [hl]
;	spillPairReg hl
	ld	h, a
;	spillPairReg hl
;	spillPairReg hl
	ld	a, c
	sub	a, $40
	ld	a, b
	sbc	a, $42
	ld	a, l
	sbc	a, $0F
	ld	a, h
	sbc	a, $00
	jp	NC, .l00116
	ld	de, _src_browser_browser_c___str_19+0
	ld	hl, sp+71
	ld	[hl], e
	inc	hl
	ld	[hl], d
	jp	.l00117
.l00116:
	ld	de, _src_browser_browser_c___str_20+0
	ld	hl, sp+71
	ld	[hl], e
	inc	hl
	ld	[hl], d
.l00117:
	ld	hl, sp+71
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	ld	hl, sp+69
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_CopyName__far
.l00107:
;src/browser/browser.c:153: line += BOX_STRIDE;
	ld	hl, sp+68
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $0014
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+73
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+72
	ld	[hl], a
;src/browser/browser.c:154: end = PutNumber(line, 1980 + (entry.date >> 9));
	ld	hl, (_src_browser_browser_c_entry + 69) + 0
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	ld	a, b
	srl	a
	ld	c, a
	ld	b, $00
	ld	hl, $07BC
	add	hl, bc
	ld	bc, $0000
	push	bc
	push	hl
	ld	hl, sp+75
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_PutNumber__far
;src/browser/browser.c:155: *end++ = '-';
	ld	a, $2D
	ld	[bc], a
	inc	bc
	ld	hl, sp+69
	ld	[hl], c
	inc	hl
	ld	[hl], b
;src/browser/browser.c:156: end = PutNumber2(end, (entry.date >> 5) & 15);
	ld	hl, (_src_browser_browser_c_entry + 69) + 0
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	ld	a, $05
.l00162:
	srl	b
	rr	c
	dec	a
	jp	NZ, .l00162
	ld	a, c
	and	a, $0F
	ld	c, a
	ld	b, $00
	ld	hl, sp+69
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_PutNumber2__far
;src/browser/browser.c:157: *end++ = '-';
	ld	a, $2D
	ld	[bc], a
	inc	bc
	ld	hl, sp+69
	ld	[hl], c
	inc	hl
	ld	[hl], b
;src/browser/browser.c:158: *PutNumber2(end, entry.date & 31) = 0;
	ld	hl, (_src_browser_browser_c_entry + 69) + 0
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	ld	a, c
	and	a, $1F
	ld	c, a
	ld	b, $00
	ld	hl, sp+69
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_PutNumber2__far
	xor	a, a
	ld	[bc], a
;src/browser/browser.c:159: line += BOX_STRIDE;
	ld	hl, sp+72
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $0014
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+71
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+70
	ld	[hl], a
;src/browser/browser.c:160: end = PutNumber2(line, entry.time >> 11);
	ld	hl, (_src_browser_browser_c_entry + 71) + 0
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	ld	a, b
	swap	a
	rlca
	and	a, $1F
	ld	c, a
	ld	b, $00
	ld	hl, sp+69
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_PutNumber2__far
;src/browser/browser.c:161: *end++ = ':';
	ld	a, $3A
	ld	[bc], a
	inc	bc
	ld	hl, sp+71
	ld	[hl], c
	inc	hl
	ld	[hl], b
;src/browser/browser.c:162: *PutNumber2(end, (entry.time >> 5) & 63) = 0;
	ld	hl, (_src_browser_browser_c_entry + 71) + 0
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	ld	a, $05
.l00163:
	srl	b
	rr	c
	dec	a
	jp	NZ, .l00163
	ld	a, c
	and	a, $3F
	ld	c, a
	ld	b, $00
	ld	hl, sp+71
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_PutNumber2__far
	xor	a, a
	ld	[bc], a
;src/browser/browser.c:163: OpenBox(rows + 3);
	ld	hl, sp+73
	ld	a, [hl]
	add	a, $03
	ld	c, a
	ld	a, c
	call	_OpenBox__far
;src/browser/browser.c:164: EditorDraw();
	call	_EditorDraw
;src/browser/browser.c:165: WaitDismiss();
	call	_WaitDismiss__far
;src/browser/browser.c:166: HideBox();
	call	_HideBox__far
.l00112:
;src/browser/browser.c:167: }
	add	sp, 74
	ret
	SECTION FRAGMENT "src/browser/browser.c FIXED",ROMX,BANK[1]
_src_browser_browser_c___str_18:
	DB "Folder"
	DB $00
	SECTION FRAGMENT "src/browser/browser.c FIXED",ROMX,BANK[1]
_src_browser_browser_c___str_19:
	DB " bytes"
	DB $00
	SECTION FRAGMENT "src/browser/browser.c FIXED",ROMX,BANK[1]
_src_browser_browser_c___str_20:
	DB " KiB"
	DB $00
;src/browser/browser.c:171: static unsigned char BrowserMenu(char* path, char* clipboard) {
;	---------------------------------
	SECTION FRAGMENT "src/browser/browser.c FIXED",ROMX,BANK[1]
; Function BrowserMenu
; ---------------------------------
_src_browser_browser_c_BrowserMenu:
	add	sp, -9
	ld	hl, sp+7
	ld	[hl], e
	inc	hl
	ld	[hl], d
	ld	hl, sp+5
	ld	[hl], c
	inc	hl
	ld	[hl], b
;src/browser/browser.c:172: unsigned char menu = 0, item, length = 0, result;
	ld	hl, sp+1
	ld	[hl], $00
;src/browser/browser.c:174: while (path[length]) ++length;
	ld	e, $00
.l00101:
	push	de
	ld	d, $00
	ld	hl, sp+9
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	add	hl, de
	pop	de
	ld	c, l
	ld	b, h
	ld	a, [bc]
	or	a, a
	jp	Z, .l00186
	inc	e
	jp	.l00101
;src/browser/browser.c:175: while (1) {
.l00186:
	ld	hl, sp+4
	ld	[hl], e
.l00123:
;src/browser/browser.c:176: menu = Choose(0, browser_items[0], 5, menu);
	ld	hl, sp+1
	ld	a, [hl]
	push	af
	inc	sp
	ld	a, $05
	push	af
	inc	sp
	ld	bc, _src_browser_browser_c_browser_items
	ld	de, $0000
	call	_Choose__far
	ld	hl, sp+1
	ld	[hl], a
;src/browser/browser.c:177: if (menu >= BACK) return 0;
	ld	a, [hl]
	sub	a, $FE
	jp	C, .l00105
	xor	a, a
	jp	.l00148
.l00105:
;src/browser/browser.c:178: if (menu == 4) {
	ld	hl, sp+1
	ld	a, [hl]
	sub	a, $04
	jp	NZ,.l00300
	jp	.l00301
.l00300:
	jp	.l00111
.l00301:
;src/browser/browser.c:179: if (doc_large) {
	ld	hl, _doc_large
	ld	a, [hl]
	or	a, a
	jp	Z, .l00107
;src/browser/browser.c:180: FileCloseLarge();
	call	_FileCloseLarge
;src/browser/browser.c:181: tb_Clear();
	call	_tb_Clear
;src/browser/browser.c:182: file_name[0] = 0;
	ld	hl, _file_name
	ld	[hl], $00
;src/browser/browser.c:183: modified = 0;
	ld	hl, _modified
	ld	[hl], $00
.l00107:
;src/browser/browser.c:185: SettingsSave();
	call	_SettingsSave
;src/browser/browser.c:186: ShowBusy("Restarting...");
	ld	de, _src_browser_browser_c___str_21
	call	_ShowBusy__far
;src/browser/browser.c:187: result = FileSaveSwap();
	call	_FileSaveSwap
	ld	c, a
;src/browser/browser.c:188: if (!result) RestartDevice();
	ld	a, c
	or	a, a
	jp	NZ, .l00109
	push	bc
	call	_RestartDevice
	pop	bc
.l00109:
;src/browser/browser.c:189: BrowserError(result);
	ld	a, c
	call	_src_browser_browser_c_BrowserError
;src/browser/browser.c:190: return 0;
	xor	a, a
	jp	.l00148
.l00111:
;src/browser/browser.c:192: if (menu == 3) { ShowBrowserHelp(); return 0; }
	ld	hl, sp+1
	ld	a, [hl]
	sub	a, $03
	jp	NZ,.l00302
	jp	.l00303
.l00302:
	jp	.l00113
.l00303:
	call	_ShowBrowserHelp__far
	xor	a, a
	jp	.l00148
.l00113:
;src/browser/browser.c:193: if (menu == 2) {
	ld	hl, sp+1
	ld	a, [hl]
	sub	a, $02
	jp	NZ,.l00304
	jp	.l00305
.l00304:
	jp	.l00117
.l00305:
;src/browser/browser.c:194: if (PreferencesMenu(1) == BACK) continue;
	ld	a, $01
	call	_PreferencesMenu__far
	sub	a, $FE
	jp	NZ,.l00306
	jp	.l00123
.l00306:
;src/browser/browser.c:195: return 0;
	xor	a, a
	jp	.l00148
.l00117:
;src/browser/browser.c:197: item = Choose(0, menu ? edit_items[0] : file_items[0], menu ? 3 : 2, 0);
	ld	hl, sp+1
	ld	a, [hl]
	or	a, a
	jp	Z, .l00150
	ld	de, $0003
	jp	.l00151
.l00150:
	ld	de, $0002
.l00151:
	ld	hl, sp+1
	ld	a, [hl]
	or	a, a
	jp	Z, .l00152
	ld	bc, _src_browser_browser_c_edit_items
	jp	.l00153
.l00152:
	ld	bc, _src_browser_browser_c_file_items
.l00153:
	xor	a, a
	push	af
	inc	sp
	ld	a, e
	push	af
	inc	sp
	ld	de, $0000
	call	_Choose__far
	ld	hl, sp+2
	ld	[hl], a
;src/browser/browser.c:198: if (item == BACK) continue;
	ld	a, [hl]
	sub	a, $FE
	jp	NZ,.l00307
	jp	.l00123
.l00307:
;src/browser/browser.c:199: if (item == CANCEL) return 0;
	ld	hl, sp+2
	ld	a, [hl]
	inc	a
	jp	NZ,.l00308
	jp	.l00309
.l00308:
	jp	.l00124
.l00309:
	xor	a, a
	jp	.l00148
;src/browser/browser.c:200: break;
.l00124:
;src/browser/browser.c:206: if (!JoinPath(path + length, "", name, FS_NAME_SIZE + 1)) return 0;
	ld	hl, sp+8
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, sp+4
	ld	l, [hl]
	ld	h, $00
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+5
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+4
	ld	[hl], a
;src/browser/browser.c:202: if (menu && item == 2) {
	ld	hl, sp+1
	ld	a, [hl]
	or	a, a
	jp	Z, .l00142
	inc	hl
	ld	a, [hl]
	sub	a, $02
	jp	NZ,.l00310
	jp	.l00311
.l00310:
	jp	.l00142
.l00311:
;src/browser/browser.c:203: if (!clipboard[0]) { ListMessage("Clipboard empty"); return 0; }
	ld	hl, sp+6
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	or	a, a
	jp	NZ, .l00126
	ld	de, _src_browser_browser_c___str_22
	call	_src_browser_browser_c_ListMessage__far
	xor	a, a
	jp	.l00148
.l00126:
;src/browser/browser.c:204: name = clipboard;
	ld	hl, sp+5
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
;src/browser/browser.c:205: for (item = 0; clipboard[item]; ++item) if (clipboard[item] == '/') name = clipboard + item + 1;
	ld	hl, sp+2
	ld	[hl], $00
.l00146:
	ld	hl, sp+6
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, sp+2
	ld	l, [hl]
	ld	h, $00
	add	hl, de
	inc	sp
	inc	sp
	push	hl
	pop	de
	push	de
	ld	a, [de]
	or	a, a
	jp	Z, .l00129
	sub	a, $2F
	jp	NZ,.l00312
	jp	.l00313
.l00312:
	jp	.l00147
.l00313:
	pop	bc
	push	bc
	inc	bc
.l00147:
	ld	hl, sp+2
	inc	[hl]
	jp	.l00146
.l00129:
;src/browser/browser.c:206: if (!JoinPath(path + length, "", name, FS_NAME_SIZE + 1)) return 0;
	ld	a, $42
	push	af
	inc	sp
	push	bc
	ld	bc, _src_browser_browser_c___str_23
	ld	hl, sp+6
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_JoinPath__far
	or	a, a
	jp	NZ, .l00131
	xor	a, a
	jp	.l00148
.l00131:
;src/browser/browser.c:207: ShowBusy(clipboard_cut ? "Moving..." : "Copying...");
	ld	hl, _src_browser_browser_c_clipboard_cut
	ld	a, [hl]
	or	a, a
	jp	Z, .l00154
	ld	de, _src_browser_browser_c___str_24+0
	jp	.l00155
.l00154:
	ld	de, _src_browser_browser_c___str_25+0
.l00155:
	call	_ShowBusy__far
;src/browser/browser.c:208: result = clipboard_cut ? FileRename(clipboard, path) : FileCopy(clipboard, path);
	ld	hl, _src_browser_browser_c_clipboard_cut
	ld	a, [hl]
	or	a, a
	jp	Z, .l00156
	ld	hl, sp+7
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	ld	hl, sp+5
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_FileRename
	jp	.l00157
.l00156:
	ld	hl, sp+7
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	ld	hl, sp+5
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_FileCopy
.l00157:
	ld	hl, sp+2
	ld	[hl], a
;src/browser/browser.c:209: if (!result && clipboard_cut) clipboard[0] = 0;
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00143
	ld	hl, _src_browser_browser_c_clipboard_cut
	ld	a, [hl]
	or	a, a
	jp	Z, .l00143
	ld	hl, sp+5
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	ld	[hl], $00
	jp	.l00143
.l00142:
;src/browser/browser.c:212: if (!entry.name[0]) { ListMessage("Select file/folder"); return 0; }
	ld	a, [_src_browser_browser_c_entry + 0]
	or	a, a
	jp	NZ, .l00136
	ld	de, _src_browser_browser_c___str_26
	call	_src_browser_browser_c_ListMessage__far
	xor	a, a
	jp	.l00148
.l00136:
;src/browser/browser.c:213: if (!menu) {
	ld	hl, sp+1
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00140
;src/browser/browser.c:214: if (!item) { FileInfo(); return 0; }
	inc	hl
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00138
	call	_src_browser_browser_c_FileInfo
	xor	a, a
	jp	.l00148
.l00138:
;src/browser/browser.c:215: return 1;
	ld	a, $01
	jp	.l00148
.l00140:
;src/browser/browser.c:217: JoinPath(path + length, "", entry.name, FS_NAME_SIZE + 1);
	ld	a, $42
	push	af
	inc	sp
	ld	de, _src_browser_browser_c_entry
	push	de
	ld	bc, _src_browser_browser_c___str_23
	ld	hl, sp+6
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_JoinPath__far
;src/browser/browser.c:218: CopyName(clipboard, path);
	ld	hl, sp+7
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	ld	hl, sp+5
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_CopyName__far
;src/browser/browser.c:219: clipboard_cut = !item;
	ld	hl, sp+2
	ld	a, [hl]
	sub	a,$01
	ld	a, $00
	rla
	ld	[hl], a
	ld	a, [hl]
	ld	hl, _src_browser_browser_c_clipboard_cut
	ld	[hl], a
;src/browser/browser.c:220: path[length] = 0;
	ld	hl, sp+3
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	ld	[hl], $00
;src/browser/browser.c:221: return 0;
	xor	a, a
	jp	.l00148
.l00143:
;src/browser/browser.c:223: path[length] = 0;
	ld	hl, sp+3
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	ld	[hl], $00
;src/browser/browser.c:224: BrowserError(result);
	ld	hl, sp+2
	ld	a, [hl]
	call	_src_browser_browser_c_BrowserError
;src/browser/browser.c:225: return 0;
	xor	a, a
.l00148:
;src/browser/browser.c:226: }
	add	sp, 9
	ret
	SECTION FRAGMENT "src/browser/browser.c FIXED",ROMX,BANK[1]
_src_browser_browser_c___str_21:
	DB "Restarting..."
	DB $00
	SECTION FRAGMENT "src/browser/browser.c FIXED",ROMX,BANK[1]
_src_browser_browser_c___str_22:
	DB "Clipboard empty"
	DB $00
	SECTION FRAGMENT "src/browser/browser.c FIXED",ROMX,BANK[1]
_src_browser_browser_c___str_23:
	DB $00
	SECTION FRAGMENT "src/browser/browser.c FIXED",ROMX,BANK[1]
_src_browser_browser_c___str_24:
	DB "Moving..."
	DB $00
	SECTION FRAGMENT "src/browser/browser.c FIXED",ROMX,BANK[1]
_src_browser_browser_c___str_25:
	DB "Copying..."
	DB $00
	SECTION FRAGMENT "src/browser/browser.c FIXED",ROMX,BANK[1]
_src_browser_browser_c___str_26:
	DB "Select file/folder"
	DB $00
;src/browser/browser.c:228: static void RenameSelected(char* path, unsigned int selected) {
;	---------------------------------
	SECTION FRAGMENT "Page 6",ROMX,BANK[3]
	LOAD FRAGMENT "Page 6 RAM",SRAM,BANK[6]
; Function RenameSelected
; ---------------------------------
_src_browser_browser_c_RenameSelected:
	add	sp, -8
	ld	hl, sp+6
	ld	[hl], e
	inc	hl
	ld	[hl], d
	ld	hl, sp+4
	ld	[hl], c
	inc	hl
	ld	[hl], b
;src/browser/browser.c:229: unsigned int first = selected - name_row;
	ld	hl, _name_row
	ld	a, [hl]
	ld	hl, sp+2
	ld	[hl], a
	inc	hl
	ld	[hl], $00
	dec	hl
	ld	a, [hl]
	dec	hl
	dec	hl
	ld	[hl], a
	ld	hl, sp+3
	ld	a, [hl]
	dec	hl
	dec	hl
	ld	[hl], a
	ld	hl, sp+5
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	pop	hl
	push	hl
	ld	a, e
	sub	a, l
	ld	e, a
	ld	a, d
	sbc	a, h
	ld	hl, sp+3
	ld	[hl], a
	dec	hl
	ld	[hl], e
	pop	hl
	pop	bc
	push	bc
	push	hl
;src/browser/browser.c:230: unsigned char length = 0, result, old_bars = bars_on;
	ld	hl, _bars_on
	ld	a, [hl]
	ld	hl, sp+0
	ld	[hl], a
;src/browser/browser.c:231: if (name_row >= LIST_ROWS - OSK_ROWS) {
	ld	hl, _name_row
	ld	a, [hl]
	sub	a, $0B
	jp	C, .l00102
;src/browser/browser.c:232: first = selected - (LIST_ROWS - OSK_ROWS - 1);
	ld	hl, sp+5
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $000A
	ld	a, e
	sub	a, l
	ld	e, a
	ld	a, d
	sbc	a, h
	ld	b, a
	ld	c, e
;src/browser/browser.c:233: name_row = LIST_ROWS - OSK_ROWS - 1;
	ld	hl, _name_row
	ld	[hl], $0A
.l00102:
;src/browser/browser.c:235: bars_on = 1;
	ld	hl, _bars_on
	ld	[hl], $01
;src/browser/browser.c:236: OpenKeyboard();
	push	bc
	call	_OpenKeyboard__far
	pop	bc
;src/browser/browser.c:237: ListRows(path, first, 0, tb_rows);
	ld	hl, _tb_rows
	ld	a, [hl]
	push	af
	inc	sp
	xor	a, a
	push	af
	inc	sp
	ld	hl, sp+8
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_src_browser_browser_c_ListRows__far
;src/browser/browser.c:238: ListBars(path);
	ld	hl, sp+6
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_src_browser_browser_c_ListBars__far
;src/browser/browser.c:239: if (ListEntry(path, selected) != 0xFF) {
	ld	hl, sp+4
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	inc	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_src_browser_browser_c_ListEntry
	inc	a
	jp	NZ,.l00137
	jp	.l00109
.l00137:
;src/browser/browser.c:240: while (path[length]) ++length;
	ld	c, $00
.l00103:
	ld	hl, sp+7
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	l, c
	ld	h, $00
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+3
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+2
	ld	[hl], a
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	or	a, a
	jp	Z, .l00116
	inc	c
	jp	.l00103
.l00116:
	ld	hl, sp+3
	ld	[hl], c
;src/browser/browser.c:241: JoinPath(path + length, "", entry.name, FS_NAME_SIZE + 1);
	ld	a, $42
	push	af
	inc	sp
	ld	de, _src_browser_browser_c_entry
	push	de
	ld	bc, _src_browser_browser_c___str_27
	dec	hl
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_JoinPath__far
;src/browser/browser.c:242: result = AskName(entry.name, 0);
	ld	bc, $0000
	ld	de, _src_browser_browser_c_entry
	call	_AskName__far
;src/browser/browser.c:243: if (result == 1) {
	dec	a
	jp	NZ,.l00138
	jp	.l00139
.l00138:
	jp	.l00107
.l00139:
;src/browser/browser.c:244: ShowBusy("Renaming...");
	ld	de, _src_browser_browser_c___str_28
	call	_ShowBusy__far
;src/browser/browser.c:245: BrowserError(FileRenameName(path, entry.name));
	ld	bc, _src_browser_browser_c_entry
	ld	hl, sp+6
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_FileRenameName
	ld	c, a
	ld	a, c
	call	_src_browser_browser_c_BrowserError
.l00107:
;src/browser/browser.c:247: path[length] = 0;
	ld	hl, sp+3
	ld	e, [hl]
	ld	d, $00
	ld	hl, sp+6
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	add	hl, de
	ld	c, l
	ld	b, h
	xor	a, a
	ld	[bc], a
.l00109:
;src/browser/browser.c:249: bars_on = old_bars;
	ld	hl, sp+0
	ld	a, [hl]
	ld	hl, _bars_on
	ld	[hl], a
.l00110:
;src/browser/browser.c:250: }
	add	sp, 8
	ret
	SECTION FRAGMENT "src/browser/browser.c FIXED",ROMX,BANK[1]
_src_browser_browser_c___str_27:
	DB $00
	SECTION FRAGMENT "src/browser/browser.c FIXED",ROMX,BANK[1]
_src_browser_browser_c___str_28:
	DB "Renaming..."
	DB $00
;src/browser/browser.c:255: unsigned char Browse(void) {
;	---------------------------------
	SECTION FRAGMENT "Page 4",ROMX,BANK[2]
	LOAD FRAGMENT "Page 4 RAM",SRAM,BANK[4]
; Function Browse
; ---------------------------------
_Browse::
	ld	hl, -465
	add	hl, sp
	ld	sp, hl
;src/browser/browser.c:259: unsigned int selected = 0, first = 0, drawn = LIST_ALL;
	xor	a, a
	ld	hl, 463
	add	hl, sp
	ld	[hl], a
	inc	hl
	ld	[hl], a
	xor	a, a
	ld	hl, 451
	add	hl, sp
	ld	[hl], a
	inc	hl
	ld	[hl], a
	inc	hl
	ld	[hl], $FF
	inc	hl
	ld	[hl], $FF
;src/browser/browser.c:260: unsigned char key, result, row, opened = 0, editor_font = font, length, editor_osk = osk_shown;
	inc	hl
	ld	[hl], $00
	ld	hl, _font
	ld	a, [hl]
	ld	hl, 456
	add	hl, sp
	ld	[hl], a
	ld	hl, _osk_shown
	ld	a, [hl]
	ld	hl, 457
	add	hl, sp
	ld	[hl], a
;src/browser/browser.c:261: clipboard[0] = 0;
	ld	hl, 258
	add	hl, sp
	ld	[hl], $00
;src/browser/browser.c:262: CopyName(path, file_dir);
	ld	bc, _file_dir
	ld	hl, 0
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_CopyName__far
;src/browser/browser.c:263: font = FONT_VWF;
	ld	hl, _font
	ld	[hl], $01
;src/browser/browser.c:264: SetFont(font);
	ld	a, $01
	call	_SetFont
;src/browser/browser.c:265: render_text = 0;
	ld	hl, _render_text
	ld	[hl], $00
;src/browser/browser.c:266: EditorShowCursor(0);
	xor	a, a
	call	_EditorShowCursor
;src/browser/browser.c:267: if (osk_shown) OSKShow(0);
	ld	hl, _osk_shown
	ld	a, [hl]
	or	a, a
	jp	Z, .l00102
	xor	a, a
	call	_OSKShow
.l00102:
;src/browser/browser.c:268: osk_shown = 0;
	ld	hl, _osk_shown
	ld	[hl], $00
;src/browser/browser.c:269: bars = 1;
	ld	hl, _bars
	ld	[hl], $01
;src/browser/browser.c:270: tb_rows = LIST_ROWS;
	ld	hl, _tb_rows
	ld	[hl], $10
;src/browser/browser.c:271: Layout();
	call	_Layout__far
;src/browser/browser.c:272: NoHighlight();
	call	_NoHighlight__far
;src/browser/browser.c:273: ListLoading(path, 0xFF);
	ld	a, $FF
	ld	hl, 0
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_src_browser_browser_c_ListLoading
;src/browser/browser.c:274: if ((result = FileMount())) {
	call	_FileMount
	ld	hl, 462
	add	hl, sp
	ld	[hl], a
	or	a, a
	jp	Z, .l00104
;src/browser/browser.c:275: ShowError(result, "");
	ld	de, _src_browser_browser_c___str_29
	ld	a, [hl]
	call	_ShowError
;src/browser/browser.c:276: selected = LIST_ALL; // skips the list
	ld	hl, 463
	add	hl, sp
	ld	[hl], $FF
	inc	hl
	ld	[hl], $FF
	jp	.l00238
.l00104:
;src/browser/browser.c:278: else ListFolder(path, 0);
	ld	bc, $0000
	ld	hl, 0
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_src_browser_browser_c_ListFolder
;src/browser/browser.c:279: while (selected != LIST_ALL) {
.l00238:
.l00206:
	ld	hl, 463
	add	hl, sp
	ld	a, [hl]
	inc	hl
	and	a, [hl]
	inc	a
	jp	NZ,.l00518
	jp	.l00208
.l00518:
;src/browser/browser.c:280: if (selected < first) first = selected;
	ld	hl, 463
	add	hl, sp
	ld	e, l
	ld	d, h
	ld	hl, 451
	add	hl, sp
	ld	a, [de]
	inc	de
	sub	a, [hl]
	inc	hl
	ld	a, [de]
	sbc	a, [hl]
	jp	NC, .l00109
	ld	hl, 463
	add	hl, sp
	ld	a, [hl]
	ld	hl, 451
	add	hl, sp
	ld	[hl], a
	ld	hl, 464
	add	hl, sp
	ld	a, [hl]
	ld	hl, 452
	add	hl, sp
	ld	[hl], a
	jp	.l00110
.l00109:
;src/browser/browser.c:281: else if (selected >= first + LIST_ROWS) first = selected - LIST_ROWS + 1;
	ld	hl, 452
	add	hl, sp
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $0010
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, 463
	add	hl, sp
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, 462
	add	hl, sp
	ld	[hl], a
	ld	hl, 463
	add	hl, sp
	ld	e, l
	ld	d, h
	ld	hl, 461
	add	hl, sp
	ld	a, [de]
	inc	de
	sub	a, [hl]
	inc	hl
	ld	a, [de]
	sbc	a, [hl]
	jp	C, .l00110
	ld	hl, 464
	add	hl, sp
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $FFF1
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, 453
	add	hl, sp
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, 452
	add	hl, sp
	ld	[hl], a
.l00110:
;src/browser/browser.c:282: if (!list_result && first != drawn) {
	ld	hl, _src_browser_browser_c_list_result
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00120
	ld	hl, 451
	add	hl, sp
	ld	a, [hl]
	inc	hl
	inc	hl
	sub	a, [hl]
	jp	NZ,.l00519
	dec	hl
	ld	a, [hl]
	inc	hl
	inc	hl
	sub	a, [hl]
	jp	NZ,.l00519
	jp	.l00120
.l00519:
;src/browser/browser.c:283: if (drawn != LIST_ALL && first == drawn + 1) ScrollList(path, first, 1);
	ld	hl, 453
	add	hl, sp
	ld	a, [hl]
	inc	hl
	and	a, [hl]
	inc	a
	jp	NZ,.l00520
	ld	a,$01
	jp	.l00521
.l00520:
	xor	a,a
.l00521:
	ld	hl, 460
	add	hl, sp
	ld	[hl], a
	bit	0, [hl]
	jp	NZ, .l00116
	ld	hl, 454
	add	hl, sp
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $0001
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, 463
	add	hl, sp
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, 462
	add	hl, sp
	ld	[hl], a
	dec	hl
	ld	a, [hl]
	ld	hl, 451
	add	hl, sp
	sub	a, [hl]
	jp	NZ,.l00522
	ld	hl, 462
	add	hl, sp
	ld	a, [hl]
	ld	hl, 452
	add	hl, sp
	sub	a, [hl]
	jp	NZ,.l00522
	jp	.l00523
.l00522:
	jp	.l00116
.l00523:
	ld	a, $01
	push	af
	inc	sp
	ld	hl, 452
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
;src/browser/browser.c:284: else if (drawn != LIST_ALL && first + 1 == drawn) ScrollList(path, first, 0);
	ld	hl, 460
	add	hl, sp
	bit	0, [hl]
	jp	NZ, .l00112
	ld	hl, 451
	add	hl, sp
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	inc	bc
	inc	hl
	ld	a, [hl]
	sub	a, c
	jp	NZ,.l00524
	inc	hl
	ld	a, [hl]
	sub	a, b
	jp	NZ,.l00524
	jp	.l00525
.l00524:
	jp	.l00112
.l00525:
	xor	a, a
	push	af
	inc	sp
	ld	hl, 452
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
;src/browser/browser.c:285: else ListRows(path, first, 0, LIST_ROWS);
	ld	a, $10
	push	af
	inc	sp
	xor	a, a
	push	af
	inc	sp
	ld	hl, 453
	add	hl, sp
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	ld	hl, 2
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_src_browser_browser_c_ListRows__far
.l00117:
;src/browser/browser.c:286: HideBox();
	call	_HideBox__far
;src/browser/browser.c:287: drawn = first;
	ld	hl, 451
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
;src/browser/browser.c:289: if (list_result) {
	ld	hl, _src_browser_browser_c_list_result
	ld	a, [hl]
	or	a, a
	jp	Z, .l00125
;src/browser/browser.c:290: if (!path[0]) { // can't read the card
	ld	hl, sp+0
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00123
;src/browser/browser.c:291: ShowError(list_result, "");
	ld	de, _src_browser_browser_c___str_29
	ld	hl, _src_browser_browser_c_list_result
	ld	a, [hl]
	call	_ShowError
;src/browser/browser.c:292: break;
	jp	.l00208
.l00123:
;src/browser/browser.c:294: path[0] = 0; // folder is gone, back to the root
	ld	hl, sp+0
	ld	[hl], $00
;src/browser/browser.c:295: ListLoading(path, 0xFF);
	ld	a, $FF
	ld	hl, 0
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_src_browser_browser_c_ListLoading
;src/browser/browser.c:296: selected = ListFolder(path, 0);
	ld	bc, $0000
	ld	hl, 0
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_src_browser_browser_c_ListFolder
	ld	hl, 463
	add	hl, sp
	ld	[hl], c
	inc	hl
	ld	[hl], b
;src/browser/browser.c:297: drawn = LIST_ALL;
	ld	hl, 453
	add	hl, sp
	ld	[hl], $FF
	inc	hl
	ld	[hl], $FF
;src/browser/browser.c:298: continue;
	jp	.l00206
.l00125:
;src/browser/browser.c:300: row = (unsigned char)(selected - first);
	ld	hl, 463
	add	hl, sp
	ld	a, [hl]
	ld	hl, 451
	add	hl, sp
	ld	c, [hl]
	sub	a, c
	ld	hl, 458
	add	hl, sp
	ld	[hl], a
;src/browser/browser.c:301: ListBars(path);
	ld	hl, 0
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_src_browser_browser_c_ListBars
;src/browser/browser.c:302: NoHighlight();
	call	_NoHighlight__far
;src/browser/browser.c:303: if (list_count) render_sel[(row + 1) << 1] = 0, render_sel[((row + 1) << 1) + 1] = 0xFF;
	ld	hl, _src_browser_browser_c_list_count + 1
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	jp	Z, .l00127
	ld	hl, 458
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
;src/browser/browser.c:304: EditorDraw();
	call	_EditorDraw
;src/browser/browser.c:305: while (!(key = MenuKey()));
.l00128:
	call	_MenuKey__far
	ld	hl, 459
	add	hl, sp
	ld	[hl], a
	or	a, a
	jp	Z, .l00128
;src/browser/browser.c:306: if (key == KEY_UP && selected) --selected;
	ld	a, [hl]
	sub	a, $82
	jp	NZ,.l00526
	jp	.l00527
.l00526:
	jp	.l00203
.l00527:
	ld	hl, 464
	add	hl, sp
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	jp	Z, .l00203
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
	jp	.l00206
.l00203:
;src/browser/browser.c:307: else if (key == KEY_DOWN && selected + 1 < list_count) ++selected;
	ld	hl, 459
	add	hl, sp
	ld	a, [hl]
	sub	a, $83
	jp	NZ,.l00528
	jp	.l00529
.l00528:
	jp	.l00199
.l00529:
	ld	hl, 464
	add	hl, sp
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $0001
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, 463
	add	hl, sp
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, 462
	add	hl, sp
	ld	[hl], a
	ld	hl, 461
	add	hl, sp
	ld	e, l
	ld	d, h
	ld	hl, _src_browser_browser_c_list_count
	ld	a, [de]
	inc	de
	sub	a, [hl]
	inc	hl
	ld	a, [de]
	sbc	a, [hl]
	jp	NC, .l00199
	ld	hl, 461
	add	hl, sp
	ld	a, [hl]
	inc	hl
	ld	c, [hl]
	inc	hl
	ld	[hl], a
	inc	hl
	ld	[hl], c
	jp	.l00206
.l00199:
;src/browser/browser.c:308: else if (key == KEY_PAGE_UP) selected = selected > LIST_ROWS ? selected - LIST_ROWS : 0;
	ld	hl, 459
	add	hl, sp
	ld	a, [hl]
	sub	a, $86
	jp	NZ,.l00530
	jp	.l00531
.l00530:
	jp	.l00196
.l00531:
	ld	hl, 463
	add	hl, sp
	ld	a, $10
	sub	a, [hl]
	inc	hl
	ld	a, $00
	sbc	a, [hl]
	jp	NC, .l00219
	ld	hl, 464
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
	jp	.l00220
.l00219:
	ld	c, $00
	xor	a, a
.l00220:
	ld	hl, 463
	add	hl, sp
	ld	[hl], c
	inc	hl
	ld	[hl], a
	jp	.l00206
.l00196:
;src/browser/browser.c:309: else if (key == KEY_PAGE_DOWN && list_count) selected = selected + LIST_ROWS < list_count ? selected + LIST_ROWS : list_count - 1;
	ld	hl, _src_browser_browser_c_list_count + 1
	dec	hl
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	dec	bc
	ld	hl, 459
	add	hl, sp
	ld	a, [hl]
	sub	a, $87
	jp	NZ,.l00532
	jp	.l00533
.l00532:
	jp	.l00192
.l00533:
	ld	hl, _src_browser_browser_c_list_count + 1
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	jp	Z, .l00192
	ld	hl, 464
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
	jp	NC, .l00221
	ld	c, e
	ld	b, d
	jp	.l00222
.l00221:
.l00222:
	ld	hl, 463
	add	hl, sp
	ld	[hl], c
	inc	hl
	ld	[hl], b
	jp	.l00206
.l00192:
;src/browser/browser.c:310: else if (key == KEY_HOME) selected = 0;
	ld	hl, 459
	add	hl, sp
	ld	a, [hl]
	sub	a, $84
	jp	NZ,.l00534
	jp	.l00535
.l00534:
	jp	.l00189
.l00535:
	xor	a, a
	ld	hl, 463
	add	hl, sp
	ld	[hl], a
	inc	hl
	ld	[hl], a
	jp	.l00206
.l00189:
;src/browser/browser.c:311: else if (key == KEY_END && list_count) selected = list_count - 1;
	ld	hl, 459
	add	hl, sp
	ld	a, [hl]
	sub	a, $85
	jp	NZ,.l00536
	jp	.l00537
.l00536:
	jp	.l00185
.l00537:
	ld	hl, _src_browser_browser_c_list_count + 1
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	jp	Z, .l00185
	ld	hl, 463
	add	hl, sp
	ld	[hl], c
	inc	hl
	ld	[hl], b
	jp	.l00206
.l00185:
;src/browser/browser.c:312: else if ((key == KEY_ENTER || key == KEY_RIGHT) && list_count && list_kinds[row] != KIND_UP) {
	ld	hl, 459
	add	hl, sp
	ld	a, [hl]
	sub	a, $0A
	jp	NZ,.l00538
	ld	a,$01
	jp	.l00539
.l00538:
	xor	a,a
.l00539:
	ld	hl, 460
	add	hl, sp
	ld	[hl], a
	dec	hl
	ld	a, [hl]
	sub	a, $81
	jp	NZ,.l00540
	ld	a,$01
	jp	.l00541
.l00540:
	xor	a,a
.l00541:
	ld	hl, 461
	add	hl, sp
	ld	[hl], a
	dec	hl
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00182
	inc	hl
	ld	a, [hl]
	or	a, a
	jp	Z, .l00179
.l00182:
	ld	hl, _src_browser_browser_c_list_count + 1
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	jp	Z, .l00179
	ld	de, _src_browser_browser_c_list_kinds
	ld	hl, 458
	add	hl, sp
	ld	l, [hl]
	ld	h, $00
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, [bc]
	or	a, a
	jp	Z, .l00179
;src/browser/browser.c:313: if (list_kinds[row] == KIND_FOLDER) ListLoading(path, row);
	dec	a
	jp	NZ,.l00542
	jp	.l00543
.l00542:
	jp	.l00132
.l00543:
	ld	hl, 458
	add	hl, sp
	ld	a, [hl]
	ld	hl, 0
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_src_browser_browser_c_ListLoading
	jp	.l00133
.l00132:
;src/browser/browser.c:314: else ShowBusy("Loading...");
	ld	de, _src_browser_browser_c___str_30
	call	_ShowBusy
.l00133:
;src/browser/browser.c:315: if (ListEntry(path, selected) == 0xFF) continue; // its full name
	ld	hl, 463
	add	hl, sp
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	ld	hl, 0
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_src_browser_browser_c_ListEntry__far
	inc	a
	jp	NZ,.l00544
	jp	.l00206
.l00544:
;src/browser/browser.c:316: for (length = 0; path[length]; ++length);
	ld	hl, 462
	add	hl, sp
	ld	[hl], $00
.l00212:
	push	hl
	ld	hl, 2
	add	hl, sp
	ld	e, l
	ld	d, h
	pop	hl
	ld	hl, 462
	add	hl, sp
	ld	l, [hl]
	ld	h, $00
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, 462
	add	hl, sp
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, 461
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
	jp	.l00212
.l00136:
;src/browser/browser.c:317: if (entry.dir) {
	ld	a, [(_src_browser_browser_c_entry + 73) + 0]
	or	a, a
	jp	Z, .l00143
;src/browser/browser.c:318: if (JoinPath(path + length, "", entry.name, PATH_SIZE - length)) {
	ld	hl, 462
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
	ld	bc, _src_browser_browser_c___str_29
	call	_JoinPath
	or	a, a
	jp	Z, .l00138
;src/browser/browser.c:319: selected = ListFolder(path, 0);
	ld	bc, $0000
	ld	hl, 0
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_src_browser_browser_c_ListFolder
	ld	hl, 463
	add	hl, sp
	ld	[hl], c
	inc	hl
	ld	[hl], b
;src/browser/browser.c:320: drawn = LIST_ALL;
	ld	hl, 453
	add	hl, sp
	ld	[hl], $FF
	inc	hl
	ld	[hl], $FF
	jp	.l00206
.l00138:
;src/browser/browser.c:323: path[length] = 0;
	ld	hl, 460
	add	hl, sp
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	ld	[hl], $00
;src/browser/browser.c:324: ListMessage("Path is too long");
	ld	de, _src_browser_browser_c___str_31
	call	_src_browser_browser_c_ListMessage__far
	jp	.l00206
.l00143:
;src/browser/browser.c:328: JoinPath(path + length, "", entry.name, FS_NAME_SIZE + 1);
	ld	hl, 460
	add	hl, sp
	ld	a, [hl]
	dec	hl
	dec	hl
	ld	[hl], a
	ld	hl, 461
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
	ld	bc, _src_browser_browser_c___str_29
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_JoinPath
;src/browser/browser.c:329: if (IsGame(entry.name)) {
	ld	de, _src_browser_browser_c_entry
	call	_IsGame__far
	or	a, a
	jp	Z, .l00141
;src/browser/browser.c:330: LaunchGame(path); // returns if it doesn't launch
	ld	hl, 0
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_LaunchGame__far
;src/browser/browser.c:331: path[length] = 0;
	ld	hl, 460
	add	hl, sp
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	ld	[hl], $00
;src/browser/browser.c:332: drawn = LIST_ALL;
	ld	hl, 453
	add	hl, sp
	ld	[hl], $FF
	inc	hl
	ld	[hl], $FF
;src/browser/browser.c:333: continue;
	jp	.l00206
.l00141:
;src/browser/browser.c:335: LoadDocument(path, length, &entry);
	ld	de, _src_browser_browser_c_entry
	push	de
	ld	hl, 464
	add	hl, sp
	ld	a, [hl]
	ld	hl, 2
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_LoadDocument__far
;src/browser/browser.c:336: opened = 1;
	ld	hl, 455
	add	hl, sp
	ld	[hl], $01
;src/browser/browser.c:337: break;
	jp	.l00208
.l00179:
;src/browser/browser.c:340: else if (path[0] && (key == KEY_LEFT || key == KEY_BACKSPACE ||
	ld	hl, sp+0
	ld	c, [hl]
	ld	hl, 459
	add	hl, sp
	ld	a, [hl]
	sub	a, $08
	jp	NZ,.l00545
	ld	a,$01
	jp	.l00546
.l00545:
	xor	a,a
.l00546:
	ld	hl, 462
	add	hl, sp
	ld	[hl], a
	ld	a, c
	or	a, a
	jp	Z, .l00170
	ld	hl, 459
	add	hl, sp
	ld	a, [hl]
	sub	a, $80
	jp	NZ,.l00547
	jp	.l00270
.l00547:
	ld	hl, 462
	add	hl, sp
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00270
;src/browser/browser.c:341: ((key == KEY_ENTER || key == KEY_RIGHT) && list_count && list_kinds[row] == KIND_UP))) {
	dec	hl
	dec	hl
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00174
	inc	hl
	ld	a, [hl]
	or	a, a
	jp	Z, .l00170
.l00174:
	ld	hl, _src_browser_browser_c_list_count + 1
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	jp	Z, .l00170
	ld	de, _src_browser_browser_c_list_kinds
	ld	hl, 458
	add	hl, sp
	ld	l, [hl]
	ld	h, $00
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, [bc]
	or	a, a
	jp	NZ, .l00170
;src/browser/browser.c:342: for (length = 0; path[length]; ++length);
.l00270:
	ld	e, $00
.l00215:
	push	de
	ld	d, $00
	ld	hl, 2
	add	hl, sp
	add	hl, de
	pop	de
	ld	a, [hl]
	or	a, a
	jp	Z, .l00271
	inc	e
	jp	.l00215
;src/browser/browser.c:343: while (path[--length] != '/');
.l00271:
	ld	c, e
.l00146:
	dec	c
	push	hl
	ld	hl, 2
	add	hl, sp
	ld	e, l
	ld	d, h
	pop	hl
	ld	l, c
	ld	h, $00
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, 465
	add	hl, sp
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, 464
	add	hl, sp
	ld	[hl], a
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	sub	a, $2F
	jp	NZ,.l00548
	jp	.l00549
.l00548:
	jp	.l00146
.l00549:
;src/browser/browser.c:344: CopyName(name, path + length + 1);
	dec	hl
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	inc	bc
	ld	hl, 193
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_CopyName__far
;src/browser/browser.c:345: path[length] = 0;
	ld	hl, 463
	add	hl, sp
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	ld	[hl], $00
;src/browser/browser.c:346: ListLoading(path, 0xFF);
	ld	a, $FF
	ld	hl, 0
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_src_browser_browser_c_ListLoading
;src/browser/browser.c:347: selected = ListFolder(path, name); // back on the folder it came from
	ld	hl, 193
	add	hl, sp
	ld	c, l
	ld	b, h
	ld	hl, 0
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_src_browser_browser_c_ListFolder
	ld	hl, 463
	add	hl, sp
	ld	[hl], c
	inc	hl
	ld	[hl], b
;src/browser/browser.c:348: drawn = LIST_ALL;
	ld	hl, 453
	add	hl, sp
	ld	[hl], $FF
	inc	hl
	ld	[hl], $FF
	jp	.l00206
.l00170:
;src/browser/browser.c:350: else if (key == KEY_MENU || key == KEY_F1) {
	ld	hl, 459
	add	hl, sp
	ld	a, [hl]
	sub	a, $90
	jp	NZ,.l00550
	ld	a,$01
	jp	.l00551
.l00550:
	xor	a,a
.l00551:
	ld	hl, 461
	add	hl, sp
	ld	[hl], a
	dec	hl
	dec	hl
	ld	a, [hl]
	sub	a, $89
	jp	NZ,.l00552
	jp	.l00165
.l00552:
	ld	hl, 461
	add	hl, sp
	ld	a, [hl]
	or	a, a
	jp	Z, .l00166
.l00165:
;src/browser/browser.c:351: entry.name[0] = 0;
	ld	hl, _src_browser_browser_c_entry
	ld	[hl], $00
;src/browser/browser.c:352: if (list_count && list_kinds[row] != KIND_UP && ListEntry(path, selected) == 0xFF) continue;
	ld	hl, _src_browser_browser_c_list_count + 1
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	jp	Z, .l00150
	ld	de, _src_browser_browser_c_list_kinds
	ld	hl, 458
	add	hl, sp
	ld	l, [hl]
	ld	h, $00
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, 461
	add	hl, sp
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, 460
	add	hl, sp
	ld	[hl], a
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	or	a, a
	jp	Z, .l00150
	ld	hl, 463
	add	hl, sp
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	ld	hl, 0
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_src_browser_browser_c_ListEntry__far
	inc	a
	jp	NZ,.l00553
	jp	.l00206
.l00553:
.l00150:
;src/browser/browser.c:353: name_row = row;
	ld	hl, 458
	add	hl, sp
	ld	a, [hl]
	ld	hl, _name_row
	ld	[hl], a
;src/browser/browser.c:354: if (key == KEY_F1) ShowBrowserHelp();
	ld	hl, 461
	add	hl, sp
	ld	a, [hl]
	or	a, a
	jp	Z, .l00156
	call	_ShowBrowserHelp__far
	jp	.l00157
.l00156:
;src/browser/browser.c:355: else if (BrowserMenu(path, clipboard)) RenameSelected(path, selected);
	ld	hl, 258
	add	hl, sp
	ld	c, l
	ld	b, h
	ld	hl, 0
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_src_browser_browser_c_BrowserMenu
	or	a, a
	jp	Z, .l00157
	ld	hl, 463
	add	hl, sp
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	ld	hl, 0
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_src_browser_browser_c_RenameSelected__far
.l00157:
;src/browser/browser.c:356: if (osk_shown) OSKShow(0);
	ld	hl, _osk_shown
	ld	a, [hl]
	or	a, a
	jp	Z, .l00159
	xor	a, a
	call	_OSKShow
.l00159:
;src/browser/browser.c:357: osk_shown = 0;
	ld	hl, _osk_shown
	ld	[hl], $00
;src/browser/browser.c:358: font = FONT_VWF;
	ld	hl, _font
	ld	[hl], $01
;src/browser/browser.c:359: SetFont(font);
	ld	a, $01
	call	_SetFont
;src/browser/browser.c:360: render_text = 0;
	ld	hl, _render_text
	ld	[hl], $00
;src/browser/browser.c:361: bars = 1;
	ld	hl, _bars
	ld	[hl], $01
;src/browser/browser.c:362: tb_rows = LIST_ROWS;
	ld	hl, _tb_rows
	ld	[hl], $10
;src/browser/browser.c:363: Layout();
	call	_Layout__far
;src/browser/browser.c:364: ListLoading(path, 0xFF);
	ld	a, $FF
	ld	hl, 0
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_src_browser_browser_c_ListLoading
;src/browser/browser.c:365: ListFolder(path, 0);
	ld	bc, $0000
	ld	hl, 0
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_src_browser_browser_c_ListFolder
;src/browser/browser.c:366: if (selected >= list_count) selected = list_count ? list_count - 1 : 0;
	ld	hl, 463
	add	hl, sp
	ld	e, l
	ld	d, h
	ld	hl, _src_browser_browser_c_list_count
	ld	a, [de]
	inc	de
	sub	a, [hl]
	inc	hl
	ld	a, [de]
	sbc	a, [hl]
	jp	C, .l00161
	ld	hl, _src_browser_browser_c_list_count + 1
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	jp	Z, .l00223
	inc	hl
	dec	hl
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	dec	bc
	jp	.l00224
.l00223:
	ld	bc, $0000
.l00224:
	ld	hl, 463
	add	hl, sp
	ld	[hl], c
	inc	hl
	ld	[hl], b
.l00161:
;src/browser/browser.c:367: drawn = LIST_ALL;
	ld	hl, 453
	add	hl, sp
	ld	[hl], $FF
	inc	hl
	ld	[hl], $FF
	jp	.l00206
.l00166:
;src/browser/browser.c:369: else if (key == KEY_ESCAPE || key == KEY_BACKSPACE) break;
	ld	hl, 459
	add	hl, sp
	ld	a, [hl]
	sub	a, $1B
	jp	NZ,.l00554
	jp	.l00208
.l00554:
	ld	hl, 462
	add	hl, sp
	ld	a, [hl]
	or	a, a
	jp	Z, .l00206
.l00208:
;src/browser/browser.c:371: font = editor_font;
	ld	hl, 456
	add	hl, sp
	ld	a, [hl]
	ld	hl, _font
	ld	[hl], a
;src/browser/browser.c:372: SetFont(font);
	ld	a, [hl]
	call	_SetFont
;src/browser/browser.c:373: if (!opened) SetLang();
	ld	hl, 455
	add	hl, sp
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00210
	call	_SetLang__far
.l00210:
;src/browser/browser.c:374: render_text = 1;
	ld	hl, _render_text
	ld	[hl], $01
;src/browser/browser.c:375: osk_shown = editor_osk;
	ld	hl, 457
	add	hl, sp
	ld	a, [hl]
	ld	hl, _osk_shown
	ld	[hl], a
;src/browser/browser.c:376: SetRows();
	call	_SetRows__far
;src/browser/browser.c:377: return opened;
	ld	hl, 455
	add	hl, sp
	ld	a, [hl]
.l00217:
;src/browser/browser.c:378: }
	ld	hl, 465
	add	hl, sp
	ld	sp, hl
	ret
	SECTION FRAGMENT "src/browser/browser.c FIXED",ROMX,BANK[1]
_src_browser_browser_c___str_29:
	DB $00
	SECTION FRAGMENT "src/browser/browser.c FIXED",ROMX,BANK[1]
_src_browser_browser_c___str_30:
	DB "Loading..."
	DB $00
	SECTION FRAGMENT "src/browser/browser.c FIXED",ROMX,BANK[1]
_src_browser_browser_c___str_31:
	DB "Path is too long"
	DB $00
	SECTION FRAGMENT "src/browser/browser.c FIXED",ROMX,BANK[1]
	SECTION FRAGMENT "_INITIALIZER",ROM0
	SECTION FRAGMENT "_CABS (ABS)",ROM0
