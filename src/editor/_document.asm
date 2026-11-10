;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 4.2.0 #13081 (Linux)
;--------------------------------------------------------
	; MODULE document
	; Generated using the rgbds tokens.

;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	EXPORT _CopyName
	EXPORT _PutText
	EXPORT _WaitFrame
	EXPORT _DrawRow
	EXPORT _NoHighlight
	EXPORT _EditorRedraw
	EXPORT _EditorDraw
	EXPORT _SetFont
	EXPORT _HideBox
	EXPORT _ShowBusy
	EXPORT _KBPopEvent
	EXPORT _Render
	EXPORT _UndoSaved
	EXPORT _UndoClear
	EXPORT _tb_ResetChecks
	EXPORT _tb_Clear
	EXPORT _SettingsSave
	EXPORT _PadKey
	EXPORT _EditorShowCursor
	EXPORT _JoinPath
	EXPORT _PutPath
	EXPORT _ToUtf8
	EXPORT _ToLatin1
	EXPORT _Browse
	EXPORT _ShowError
	EXPORT _ShowMessage
	EXPORT _Choose
	EXPORT _FileSaveLarge
	EXPORT _FileCloseLarge
	EXPORT _FileLoadLarge
	EXPORT _FileSave
	EXPORT _FileLoad
	EXPORT _FileMount
	EXPORT _file_dir
	EXPORT _file_name
	EXPORT _CanDiscard
	EXPORT _SetLang
	EXPORT _NewFile
	EXPORT _OpenFile
	EXPORT _LoadDocument
	EXPORT _AskName
	EXPORT _SaveFile
;--------------------------------------------------------
; special function registers
;--------------------------------------------------------
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	SECTION FRAGMENT "src/editor/document.c_DATA",WRAM0
_file_name:
	DS 65
_file_dir:
	DS 128
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
	SECTION FRAGMENT "src/editor/document.c_HOME",ROM0
	SECTION FRAGMENT "src/editor/document.c_HOME",ROM0
;--------------------------------------------------------
; code
;--------------------------------------------------------
	SECTION FRAGMENT "src/editor/document.c_CODE",ROMX
;src/editor/document.c:30: unsigned char CanDiscard(void) {
;	---------------------------------
	SECTION FRAGMENT "Page 15",ROMX,BANK[7]
	LOAD FRAGMENT "Page 15 RAM",SRAM,BANK[15]
; Function CanDiscard
; ---------------------------------
_CanDiscard::
;src/editor/document.c:31: return !modified || Choose("DISCARD CHANGES?", discard_items[0], 2, 0) == 1;
	ld	hl, _modified
	ld	a, [hl]
	or	a, a
	jp	Z, .l00104
	xor	a, a
	push	af
	inc	sp
	ld	a, $02
	push	af
	inc	sp
	ld	bc, _src_editor_document_c_discard_items
	ld	de, _src_editor_document_c___str_0
	call	_Choose__far
	dec	a
	jp	NZ,.l00116
	jp	.l00104
.l00116:
	xor	a, a
	jp	.l00105
.l00104:
	ld	a, $01
.l00105:
.l00101:
;src/editor/document.c:32: }
	ret
	SECTION FRAGMENT "src/editor/document.c FIXED",ROMX,BANK[1]
_src_editor_document_c_discard_items:
	DB "NO"
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
	DB $00
	DB "YES"
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
	SECTION FRAGMENT "src/editor/document.c FIXED",ROMX,BANK[1]
_src_editor_document_c_lang_exts:
	DW _src_editor_document_c__str_3
	DW _src_editor_document_c__str_4
	DW _src_editor_document_c__str_5
	DW _src_editor_document_c__str_6
	DW _src_editor_document_c__str_7
	DW _src_editor_document_c__str_8
	SECTION FRAGMENT "src/editor/document.c FIXED",ROMX,BANK[1]
_src_editor_document_c_lang_ids:
	DB $01	; 1
	DB $02	; 2
	DB $02	; 2
	DB $03	; 3
	DB $03	; 3
	DB $03	; 3
	SECTION FRAGMENT "src/editor/document.c FIXED",ROMX,BANK[1]
_src_editor_document_c___str_0:
	DB "DISCARD CHANGES?"
	DB $00
	SECTION FRAGMENT "src/editor/document.c FIXED",ROMX,BANK[1]
_src_editor_document_c__str_3:
	DB "md"
	DB $00
	SECTION FRAGMENT "src/editor/document.c FIXED",ROMX,BANK[1]
_src_editor_document_c__str_4:
	DB "c"
	DB $00
	SECTION FRAGMENT "src/editor/document.c FIXED",ROMX,BANK[1]
_src_editor_document_c__str_5:
	DB "h"
	DB $00
	SECTION FRAGMENT "src/editor/document.c FIXED",ROMX,BANK[1]
_src_editor_document_c__str_6:
	DB "asm"
	DB $00
	SECTION FRAGMENT "src/editor/document.c FIXED",ROMX,BANK[1]
_src_editor_document_c__str_7:
	DB "inc"
	DB $00
	SECTION FRAGMENT "src/editor/document.c FIXED",ROMX,BANK[1]
_src_editor_document_c__str_8:
	DB "s"
	DB $00
;src/editor/document.c:34: void SetLang(void) {
;	---------------------------------
	SECTION FRAGMENT "Page 6",ROMX,BANK[3]
	LOAD FRAGMENT "Page 6 RAM",SRAM,BANK[6]
; Function SetLang
; ---------------------------------
_SetLang::
	add	sp, -10
;src/editor/document.c:35: const char *c, *dot = 0, *e;
	xor	a, a
	ld	hl, sp+6
	ld	[hl], a
	inc	hl
	ld	[hl], a
;src/editor/document.c:36: unsigned char lang = LANG_PLAIN, i;
	ld	hl, sp+0
	ld	[hl], $00
;src/editor/document.c:37: for (c = file_name; *c; ++c) if (*c == '.') dot = c;
	ld	hl, sp+8
	ld	a, LOW(_file_name)
	ld	[hl], a
	inc	hl
	ld	a, HIGH(_file_name)
	ld	[hl], a
.l00116:
	ld	hl, sp+9
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	or	a, a
	jp	Z, .l00103
	sub	a, $2E
	jp	NZ,.l00222
	jp	.l00223
.l00222:
	jp	.l00117
.l00223:
	dec	hl
	ld	a, [hl]
	dec	hl
	dec	hl
	ld	[hl], a
	ld	hl, sp+9
	ld	a, [hl]
	dec	hl
	dec	hl
	ld	[hl], a
.l00117:
	ld	hl, sp+8
	inc	[hl]
	jp	NZ, .l00224
	inc	hl
	inc	[hl]
.l00224:
	jp	.l00116
.l00103:
;src/editor/document.c:38: if (dot) for (i = 0; i < sizeof(lang_ids); ++i) {
	ld	hl, sp+7
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	jp	Z, .l00110
	inc	hl
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $0001
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+3
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+2
	ld	[hl], a
	ld	hl, sp+5
	ld	[hl], $00
.l00122:
;src/editor/document.c:39: for (c = dot + 1, e = lang_exts[i]; *e && (*c | 0x20) == *e; ++c, ++e);
	ld	hl, sp+1
	ld	a, [hl]
	ld	hl, sp+6
	ld	[hl], a
	ld	hl, sp+2
	ld	a, [hl]
	ld	hl, sp+7
	ld	[hl], a
	dec	hl
	dec	hl
	ld	a, [hl]
	ld	hl, sp+8
	ld	[hl], a
	inc	hl
	ld	[hl], $00
	dec	hl
	ld	a, [hl]
	ld	hl, sp+3
	ld	[hl], a
	ld	hl, sp+9
	ld	a, [hl]
	ld	hl, sp+4
	ld	[hl], a
	dec	hl
	sla	[hl]
	inc	hl
	rl	[hl]
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, _src_editor_document_c_lang_exts
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+10
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+9
	ld	[hl], a
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	dec	hl
	ld	[hl], a
	inc	de
	ld	a, [de]
	inc	hl
	ld	[hl], a
.l00120:
	ld	hl, sp+9
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	ld	hl, sp+3
	ld	[hl], a
	ld	hl, sp+7
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	ld	hl, sp+4
	ld	[hl], a
	dec	hl
	ld	a, [hl]
	or	a, a
	jp	Z, .l00104
	inc	hl
	ld	b, [hl]
	set	5, b
	dec	hl
	ld	a, [hl]
	sub	a, b
	jp	NZ,.l00226
	jp	.l00227
.l00226:
	jp	.l00104
.l00227:
	ld	hl, sp+6
	inc	[hl]
	jp	NZ, .l00228
	inc	hl
	inc	[hl]
.l00228:
	ld	hl, sp+8
	inc	[hl]
	jp	NZ, .l00229
	inc	hl
	inc	[hl]
.l00229:
	jp	.l00120
.l00104:
;src/editor/document.c:40: if (!*c && !*e) lang = lang_ids[i];
	ld	hl, sp+4
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00123
	dec	hl
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00123
	ld	de, _src_editor_document_c_lang_ids
	inc	hl
	inc	hl
	ld	l, [hl]
	ld	h, $00
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+10
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+9
	ld	[hl], a
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	ld	hl, sp+0
	ld	[hl], a
.l00123:
;src/editor/document.c:38: if (dot) for (i = 0; i < sizeof(lang_ids); ++i) {
	ld	hl, sp+5
	inc	[hl]
	ld	a, [hl]
	sub	a, $06
	jp	C, .l00122
.l00110:
;src/editor/document.c:42: font = lang == LANG_C || lang == LANG_ASM ? FONT_FIXED : FONT_VWF;
	ld	hl, sp+0
	ld	a, [hl]
	sub	a, $02
	jp	NZ,.l00230
	jp	.l00134
.l00230:
	ld	hl, sp+0
	ld	a, [hl]
	sub	a, $03
	jp	NZ,.l00231
	jp	.l00232
.l00231:
	jp	.l00131
.l00232:
.l00134:
	ld	bc, $0002
	jp	.l00132
.l00131:
	ld	bc, $0001
.l00132:
	ld	hl, _font
	ld	[hl], c
;src/editor/document.c:43: if (lang == tb_lang) return;
	ld	hl, _tb_lang
	ld	a, [hl]
	ld	hl, sp+0
	sub	a, [hl]
	jp	NZ,.l00233
	jp	.l00234
.l00233:
	jp	.l00112
.l00234:
	jp	.l00129
.l00112:
;src/editor/document.c:44: tb_lang = lang;
	ld	hl, sp+0
	ld	a, [hl]
	ld	hl, _tb_lang
	ld	[hl], a
;src/editor/document.c:45: tb_ResetChecks();
	call	_tb_ResetChecks
;src/editor/document.c:46: for (i = 0; i <= TB_ROWS; ++i) tb_row_states[i] = 0; // no markdown headings left in them
	ld	bc, _tb_row_states+0
	ld	e, $00
.l00124:
	ld	l, e
;	spillPairReg hl
;	spillPairReg hl
	ld	h, $00
;	spillPairReg hl
;	spillPairReg hl
	add	hl, hl
	add	hl, bc
	xor	a, a
	ld	[hl], a
	inc	hl
	ld	[hl], a
	inc	e
	ld	a, $12
	sub	a, e
	jp	NC, .l00124
;src/editor/document.c:47: SetFont(font);
	ld	hl, _font
	ld	a, [hl]
	call	_SetFont
;src/editor/document.c:48: for (i = bars; i < bars + tb_rows; ++i) render_row_fonts[i] = font;
	ld	hl, _bars
	ld	c, [hl]
.l00127:
	ld	hl, _bars
	ld	a, [hl]
	ld	b, $00
	ld	hl, _tb_rows
	ld	e, [hl]
	ld	d, $00
	ld	l, a
;	spillPairReg hl
;	spillPairReg hl
	ld	h, b
;	spillPairReg hl
;	spillPairReg hl
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+8
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+7
	ld	[hl], a
	inc	hl
	ld	[hl], c
	inc	hl
	ld	[hl], $00
	ld	hl, sp+8
	ld	e, l
	ld	d, h
	ld	hl, sp+6
	ld	a, [de]
	inc	de
	sub	a, [hl]
	inc	hl
	ld	a, [de]
	sbc	a, [hl]
	ld	a, [de]
	ld	d, a
	ld	e, [hl]
	bit	7, e
	jp	Z, .l00235
	bit	7, d
	jp	NZ, .l00236
	cp	a, a
	jp	.l00236
.l00235:
	bit	7, d
	jp	Z, .l00236
	scf
.l00236:
	jp	NC, .l00114
	ld	a, LOW(_render_row_fonts)
	add	a, c
	ld	e, a
	ld	a, HIGH(_render_row_fonts)
	adc	a, $00
	ld	d, a
	ld	hl, _font
	ld	a, [hl]
	ld	[de], a
	inc	c
	jp	.l00127
.l00114:
;src/editor/document.c:49: EditorRedraw();
	call	_EditorRedraw
;src/editor/document.c:50: dirty = 1;
	ld	hl, _dirty
	ld	[hl], $01
.l00129:
;src/editor/document.c:51: }
	add	sp, 10
	ret
;src/editor/document.c:53: static void ResetCursor(void) {
;	---------------------------------
	SECTION FRAGMENT "Page 5",ROMX,BANK[2]
	LOAD FRAGMENT "Page 5 RAM",SRAM,BANK[5]
; Function ResetCursor
; ---------------------------------
_src_editor_document_c_ResetCursor:
;src/editor/document.c:54: SetLang();
	call	_SetLang__far
;src/editor/document.c:55: cursor = 0;
	xor	a, a
	ld	hl, _cursor
	ld	[hl], a
	inc	hl
	ld	[hl], a
;src/editor/document.c:56: counted_pos = 0;
	xor	a, a
	ld	hl, _counted_pos
	ld	[hl], a
	inc	hl
	ld	[hl], a
;src/editor/document.c:57: counted_lines = 0;
	xor	a, a
	ld	hl, _counted_lines
	ld	[hl], a
	inc	hl
	ld	[hl], a
;src/editor/document.c:58: selecting = 0;
	ld	hl, _selecting
	ld	[hl], $00
;src/editor/document.c:59: top = 0;
	xor	a, a
	ld	hl, _top
	ld	[hl], a
	inc	hl
	ld	[hl], a
;src/editor/document.c:60: tb_left = 0;
	xor	a, a
	ld	hl, _tb_left
	ld	[hl], a
	inc	hl
	ld	[hl], a
;src/editor/document.c:61: want_x = 0;
	ld	hl, _want_x
	ld	[hl], $00
;src/editor/document.c:62: modified = 0;
	ld	hl, _modified
	ld	[hl], $00
;src/editor/document.c:63: dirty = 1;
	ld	hl, _dirty
	ld	[hl], $01
;src/editor/document.c:64: UndoClear(0);
	xor	a, a
	jp	_UndoClear
.l00101:
;src/editor/document.c:65: }
	ret
;src/editor/document.c:67: void NewFile(void) {
;	---------------------------------
	SECTION FRAGMENT "Page 4",ROMX,BANK[2]
	LOAD FRAGMENT "Page 4 RAM",SRAM,BANK[4]
; Function NewFile
; ---------------------------------
_NewFile::
;src/editor/document.c:68: if (!CanDiscard()) return;
	call	_CanDiscard__far
	or	a, a
	jp	NZ, .l00102
	jp	.l00103
.l00102:
;src/editor/document.c:69: FileCloseLarge();
	call	_FileCloseLarge
;src/editor/document.c:70: tb_Clear();
	call	_tb_Clear
;src/editor/document.c:71: file_name[0] = 0;
	ld	hl, _file_name
	ld	[hl], $00
;src/editor/document.c:72: fs_crlf = 0;
	ld	hl, _fs_crlf
	ld	[hl], $00
;src/editor/document.c:73: ResetCursor();
	call	_src_editor_document_c_ResetCursor__far
;src/editor/document.c:74: SettingsSave();
	jp	_SettingsSave
.l00103:
;src/editor/document.c:75: }
	ret
;src/editor/document.c:77: void OpenFile(void) {
;	---------------------------------
	SECTION FRAGMENT "Page 4",ROMX,BANK[2]
	LOAD FRAGMENT "Page 4 RAM",SRAM,BANK[4]
; Function OpenFile
; ---------------------------------
_OpenFile::
;src/editor/document.c:78: if (!CanDiscard()) return;
	call	_CanDiscard__far
	or	a, a
	jp	NZ, .l00102
	jp	.l00105
.l00102:
;src/editor/document.c:79: if (Browse()) {
	call	_Browse
	or	a, a
	jp	Z, .l00105
;src/editor/document.c:80: ResetCursor();
	call	_src_editor_document_c_ResetCursor__far
;src/editor/document.c:81: SettingsSave();
	jp	_SettingsSave
.l00105:
;src/editor/document.c:83: }
	ret
;src/editor/document.c:86: void LoadDocument(char* path, unsigned char folder_length, const FileEntry* entry) {
;	---------------------------------
	SECTION FRAGMENT "Page 15",ROMX,BANK[7]
	LOAD FRAGMENT "Page 15 RAM",SRAM,BANK[15]
; Function LoadDocument
; ---------------------------------
_LoadDocument::
	add	sp, -9
	ld	hl, sp+7
	ld	[hl], e
	inc	hl
	ld	[hl], d
	dec	hl
	dec	hl
	ld	[hl], a
;src/editor/document.c:88: if (entry->size > TB_SIZE) result = FileLoadLarge(path);
	ld	hl, sp+11
	ld	a, [hl]
	ld	hl, sp+0
	ld	[hl], a
	ld	hl, sp+12
	ld	a, [hl]
	ld	hl, sp+1
	ld	[hl], a
	pop	de
	push	de
	ld	hl, $0041
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+6
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+5
	ld	[hl], a
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
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
	ld	hl, sp+2
	ld	a, $00
	sub	a, [hl]
	inc	hl
	ld	a, $FE
	sbc	a, [hl]
	inc	hl
	ld	a, $00
	sbc	a, [hl]
	inc	hl
	ld	a, $00
	sbc	a, [hl]
	jp	NC, .l00102
	ld	hl, sp+7
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_FileLoadLarge
	ld	c, a
	jp	.l00103
.l00102:
;src/editor/document.c:90: FileCloseLarge();
	call	_FileCloseLarge
;src/editor/document.c:91: result = FileLoad(path);
	ld	hl, sp+7
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_FileLoad
	ld	c, a
.l00103:
;src/editor/document.c:93: HideBox();
	push	bc
	call	_HideBox__far
	pop	bc
;src/editor/document.c:94: path[folder_length] = 0;
	ld	hl, sp+8
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	dec	hl
	dec	hl
	ld	l, [hl]
	ld	h, $00
	add	hl, de
	ld	e, l
	ld	d, h
	xor	a, a
	ld	[de], a
;src/editor/document.c:95: if (result) {
	ld	a, c
	or	a, a
	jp	Z, .l00105
;src/editor/document.c:96: file_name[0] = 0; // the text buffer only has part of it, don't save over the file
	ld	hl, _file_name
	ld	[hl], $00
;src/editor/document.c:97: ShowError(result, "TOO BIG");
	ld	de, _src_editor_document_c___str_9
	ld	a, c
	call	_ShowError__far
	jp	.l00107
.l00105:
;src/editor/document.c:100: CopyName(file_dir, path);
	ld	hl, sp+7
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	ld	de, _file_dir
	call	_CopyName__far
;src/editor/document.c:101: CopyName(file_name, entry->name);
	pop	bc
	push	bc
	ld	de, _file_name
	call	_CopyName__far
.l00107:
;src/editor/document.c:103: }
	add	sp, 9
	pop	hl
	inc	sp
	inc	sp
	jp hl
	SECTION FRAGMENT "src/editor/document.c FIXED",ROMX,BANK[1]
_src_editor_document_c___str_9:
	DB "TOO BIG"
	DB $00
;src/editor/document.c:106: static unsigned char NameChar(unsigned char c) {
;	---------------------------------
	SECTION FRAGMENT "Page 12",ROMX,BANK[6]
	LOAD FRAGMENT "Page 12 RAM",SRAM,BANK[12]
; Function NameChar
; ---------------------------------
_src_editor_document_c_NameChar:
	ld	c, a
;src/editor/document.c:107: if (c < ' ' || (c >= 0x7F && c < 0xA0)) return 0;
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
;src/editor/document.c:108: return c != '/' && c != 0x5C && c != ':' && c != '*' && c != '?' && c != '"' && c != '<' && c != '>' && c != '|';
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
;src/editor/document.c:109: }
	ret
;src/editor/document.c:112: unsigned char AskName(char* value, const char* prompt) {
;	---------------------------------
	SECTION FRAGMENT "Page 4",ROMX,BANK[2]
	LOAD FRAGMENT "Page 4 RAM",SRAM,BANK[4]
; Function AskName
; ---------------------------------
_AskName::
	add	sp, -118
	ld	hl, sp+115
	ld	[hl], e
	inc	hl
	ld	[hl], d
	ld	hl, sp+113
	ld	[hl], c
	inc	hl
	ld	[hl], b
;src/editor/document.c:115: unsigned char length, key, i, bytes = 0, changed = 0;
	ld	hl, sp+108
	ld	[hl], $00
	inc	hl
	ld	[hl], $00
;src/editor/document.c:117: length = (unsigned char)(ToLatin1(name, value, NAME_CHARS) - name);
	ld	a, $40
	push	af
	inc	sp
	ld	hl, sp+116
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	ld	hl, 3
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_ToLatin1
	ld	a, c
	ld	hl, 2
	add	hl, sp
	sub	a, l
	ld	hl, sp+117
	ld	[hl], a
;src/editor/document.c:118: for (i = 0; i < length; ++i) bytes += (unsigned char)name[i] >= 0x80 ? 2 : 1;
	ld	c, $00
.l00133:
	ld	a, c
	ld	hl, sp+117
	sub	a, [hl]
	jp	NC, .l00101
	ld	e, c
	ld	d, $00
	ld	hl, 2
	add	hl, sp
	add	hl, de
	ld	a, [hl]
	sub	a, $80
	jp	C, .l00140
	ld	de, $0002
	jp	.l00141
.l00140:
	ld	de, $0001
.l00141:
	ld	hl, sp+108
	ld	a, [hl]
	add	a, e
	ld	[hl], a
	inc	c
	jp	.l00133
.l00101:
;src/editor/document.c:119: EditorShowCursor(0);
	xor	a, a
	call	_EditorShowCursor
;src/editor/document.c:120: NoHighlight();
	call	_NoHighlight__far
;src/editor/document.c:121: while (1) {
.l00128:
;src/editor/document.c:122: end = PutText(text, prompt);
	ld	hl, sp+113
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	ld	hl, 67
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_PutText__far
	pop	hl
	push	bc
;src/editor/document.c:123: for (i = length > 31 ? length - 31 : 0; i < length; ++i) *end++ = name[i];
	ld	a, $1F
	ld	hl, sp+117
	sub	a, [hl]
	jp	NC, .l00142
	ld	a, [hl]
	add	a, $E1
	ld	hl, sp+111
	ld	[hl], a
	rlca
	sbc	a, a
	inc	hl
	ld	[hl], a
	jp	.l00143
.l00142:
	xor	a, a
	ld	hl, sp+111
	ld	[hl], a
	inc	hl
	ld	[hl], a
.l00143:
	ld	hl, sp+111
	ld	e, [hl]
	pop	bc
	push	bc
.l00136:
	ld	hl, $0001
	add	hl, bc
	push	hl
	ld	a, l
	ld	hl, sp+113
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+112
	ld	[hl], a
	ld	a, e
	ld	hl, sp+117
	sub	a, [hl]
	jp	NC, .l00102
	push	de
	ld	d, $00
	ld	hl, 4
	add	hl, sp
	add	hl, de
	pop	de
	ld	a, [hl]
	ld	[bc], a
	ld	hl, sp+111
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	inc	e
	jp	.l00136
.l00102:
;src/editor/document.c:124: *end++ = '_';
	ld	a, $5F
	ld	[bc], a
	ld	hl, sp+111
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
;src/editor/document.c:125: *end = 0;
	xor	a, a
	ld	[bc], a
;src/editor/document.c:126: if (bars) {
	ld	hl, _bars
	ld	a, [hl]
	or	a, a
	jp	Z, .l00106
;src/editor/document.c:127: DrawRow(HEADER_LINE, 1, text);
	ld	hl, 67
	add	hl, sp
	push	hl
	ld	e, $01
	ld	a, $12
	call	_DrawRow__far
;src/editor/document.c:128: if (render_text) {
	ld	hl, _render_text
	ld	a, [hl]
	or	a, a
	jp	Z, .l00107
;src/editor/document.c:129: PutPath(PutText(text, "in "), file_dir, 28);
	ld	bc, _src_editor_document_c___str_10
	ld	hl, 67
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
;src/editor/document.c:130: DrawRow(STATUS_LINE, 1, text);
	ld	hl, 67
	add	hl, sp
	push	hl
	ld	e, $01
	ld	a, $13
	call	_DrawRow__far
	jp	.l00107
.l00106:
;src/editor/document.c:133: else DrawRow(0, 0, text);
	ld	hl, 67
	add	hl, sp
	push	hl
	ld	e, $00
	xor	a, a
	call	_DrawRow__far
.l00107:
;src/editor/document.c:134: EditorDraw();
	call	_EditorDraw
;src/editor/document.c:135: do {
.l00110:
;src/editor/document.c:136: WaitFrame();
	call	_WaitFrame
;src/editor/document.c:137: key = (unsigned char)KBPopEvent();
	call	_KBPopEvent
	ld	hl, sp+110
	ld	[hl], c
;src/editor/document.c:138: if (!key) key = PadKey();
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00111
	call	_PadKey__far
	ld	hl, sp+110
	ld	[hl], a
.l00111:
;src/editor/document.c:139: } while (!key);
	ld	hl, sp+110
	ld	a, [hl]
	or	a, a
	jp	Z, .l00110
;src/editor/document.c:140: if (key == KEY_ENTER && length) break;
	ld	a, [hl]
	sub	a, $0A
	jp	NZ,.l00267
	jp	.l00268
.l00267:
	jp	.l00114
.l00268:
	ld	hl, sp+117
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00129
.l00114:
;src/editor/document.c:141: if (key == KEY_ESCAPE || key == KEY_MENU || (key == KEY_BACKSPACE && !length)) {
	ld	hl, sp+110
	ld	a, [hl]
	sub	a, $1B
	jp	NZ,.l00269
	jp	.l00116
.l00269:
	ld	hl, sp+110
	ld	a, [hl]
	sub	a, $89
	jp	NZ,.l00270
	jp	.l00116
.l00270:
	ld	hl, sp+110
	ld	a, [hl]
	sub	a, $08
	jp	NZ,.l00271
	ld	a,$01
	jp	.l00272
.l00271:
	xor	a,a
.l00272:
	ld	c, a
	ld	a, c
	or	a, a
	jp	Z, .l00117
	ld	hl, sp+117
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00117
.l00116:
;src/editor/document.c:142: dirty = 1;
	ld	hl, _dirty
	ld	[hl], $01
;src/editor/document.c:143: return 0;
	xor	a, a
	jp	.l00138
.l00117:
;src/editor/document.c:118: for (i = 0; i < length; ++i) bytes += (unsigned char)name[i] >= 0x80 ? 2 : 1;
	ld	hl, sp+108
	ld	a, [hl]
	ld	hl, sp+111
	ld	[hl], a
;src/editor/document.c:145: if (key == KEY_BACKSPACE) {
	ld	a, c
	or	a, a
	jp	Z, .l00125
;src/editor/document.c:146: --length;
	ld	hl, sp+117
	dec	[hl]
;src/editor/document.c:147: bytes -= (unsigned char)name[length] >= 0x80 ? 2 : 1;
	push	hl
	ld	hl, 4
	add	hl, sp
	ld	e, l
	ld	d, h
	pop	hl
	ld	hl, sp+117
	ld	l, [hl]
	ld	h, $00
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, [bc]
	sub	a, $80
	jp	C, .l00144
	ld	bc, $0002
	jp	.l00145
.l00144:
	ld	bc, $0001
.l00145:
	ld	hl, sp+111
	ld	a, [hl]
	sub	a, c
	ld	hl, sp+108
	ld	[hl], a
;src/editor/document.c:148: changed = 1;
	inc	hl
	ld	[hl], $01
	jp	.l00128
.l00125:
;src/editor/document.c:150: else if (bytes + (key >= 0x80 ? 2 : 1) <= NAME_CHARS && NameChar(key)) {
	ld	hl, sp+108
	ld	c, [hl]
	ld	b, $00
	inc	hl
	inc	hl
	ld	a, [hl]
	sub	a, $80
	ld	a, $00
	rla
	inc	hl
	inc	hl
	ld	[hl], a
	bit	0, [hl]
	jp	NZ, .l00146
	ld	de, $0002
	jp	.l00147
.l00146:
	ld	de, $0001
.l00147:
	ld	l, c
	ld	h, b
	add	hl, de
	ld	a, h
	ld	e, a
	ld	a, $00
	ld	d, a
	ld	a, $40
	cp	a, l
	ld	a, $00
	sbc	a, h
	bit	7, e
	jp	Z, .l00273
	bit	7, d
	jp	NZ, .l00274
	cp	a, a
	jp	.l00274
.l00273:
	bit	7, d
	jp	Z, .l00274
	scf
.l00274:
	jp	C, .l00128
	ld	hl, sp+110
	ld	a, [hl]
	call	_src_editor_document_c_NameChar__far
	or	a, a
	jp	Z, .l00128
;src/editor/document.c:151: name[length++] = key;
	ld	hl, sp+117
	ld	e, [hl]
	inc	[hl]
	ld	d, $00
	ld	hl, 2
	add	hl, sp
	add	hl, de
	ld	c, l
	ld	b, h
	ld	hl, sp+110
	ld	a, [hl]
	ld	[bc], a
;src/editor/document.c:152: bytes += key >= 0x80 ? 2 : 1;
	inc	hl
	inc	hl
	bit	0, [hl]
	jp	NZ, .l00148
	ld	bc, $0002
	jp	.l00149
.l00148:
	ld	bc, $0001
.l00149:
	ld	a, c
	ld	hl, sp+111
	add	a, [hl]
	ld	hl, sp+108
	ld	[hl], a
;src/editor/document.c:153: changed = 1;
	inc	hl
	ld	[hl], $01
	jp	.l00128
.l00129:
;src/editor/document.c:156: if (!changed) return 2;
	ld	hl, sp+109
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00131
	ld	a, $02
	jp	.l00138
.l00131:
;src/editor/document.c:157: name[length] = 0;
	push	hl
	ld	hl, 4
	add	hl, sp
	ld	e, l
	ld	d, h
	pop	hl
	ld	hl, sp+117
	ld	l, [hl]
	ld	h, $00
	add	hl, de
	ld	c, l
	ld	b, h
	xor	a, a
	ld	[bc], a
;src/editor/document.c:158: ToUtf8(value, name);
	ld	hl, 2
	add	hl, sp
	ld	c, l
	ld	b, h
	ld	hl, sp+115
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_ToUtf8
;src/editor/document.c:159: dirty = 1;
	ld	hl, _dirty
	ld	[hl], $01
;src/editor/document.c:160: return 1;
	ld	a, $01
.l00138:
;src/editor/document.c:161: }
	add	sp, 118
	ret
	SECTION FRAGMENT "src/editor/document.c FIXED",ROMX,BANK[1]
_src_editor_document_c___str_10:
	DB "in "
	DB $00
;src/editor/document.c:163: void SaveFile(unsigned char ask) {
;	---------------------------------
	SECTION FRAGMENT "Page 4",ROMX,BANK[2]
	LOAD FRAGMENT "Page 4 RAM",SRAM,BANK[4]
; Function SaveFile
; ---------------------------------
_SaveFile::
	add	sp, -128
	add	sp, -65
	ld	c, a
;src/editor/document.c:166: if (ask || !file_name[0]) {
	ld	a, c
	or	a, a
	jp	NZ, .l00103
	ld	a, [_file_name + 0]
	or	a, a
	jp	NZ, .l00104
.l00103:
;src/editor/document.c:167: Render();
	call	_Render__far
;src/editor/document.c:168: if (!AskName(file_name, "Save as ")) return;
	ld	bc, _src_editor_document_c___str_11
	ld	de, _file_name
	call	_AskName
	or	a, a
	jp	NZ, .l00102
	jp	.l00110
.l00102:
;src/editor/document.c:169: SetLang();
	call	_SetLang__far
.l00104:
;src/editor/document.c:171: JoinPath(path, file_dir, file_name, (unsigned char)(PATH_SIZE + FS_NAME_SIZE));
	ld	a, $C1
	push	af
	inc	sp
	ld	de, _file_name
	push	de
	ld	bc, _file_dir
	ld	hl, 3
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_JoinPath
;src/editor/document.c:172: ShowBusy("Saving...");
	ld	de, _src_editor_document_c___str_12
	call	_ShowBusy
;src/editor/document.c:173: result = FileMount();
	call	_FileMount
	ld	c, a
;src/editor/document.c:174: if (!result) result = doc_large ? FileSaveLarge(path) : FileSave(path);
	ld	a, c
	or	a, a
	jp	NZ, .l00107
	ld	hl, _doc_large
	ld	a, [hl]
	or	a, a
	jp	Z, .l00112
	ld	hl, 0
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_FileSaveLarge
	jp	.l00113
.l00112:
	ld	hl, 0
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_FileSave
.l00113:
	ld	c, a
.l00107:
;src/editor/document.c:175: HideBox();
	push	bc
	call	_HideBox__far
	pop	bc
;src/editor/document.c:176: SettingsSave(); // save as may have changed the name
	push	bc
	call	_SettingsSave
	pop	bc
;src/editor/document.c:177: if (result) {
	ld	a, c
	or	a, a
	jp	Z, .l00109
;src/editor/document.c:178: ShowError(result, "DISK FULL");
	ld	de, _src_editor_document_c___str_13
	ld	a, c
	call	_ShowError
;src/editor/document.c:179: return;
	jp	.l00110
.l00109:
;src/editor/document.c:181: modified = 0;
	ld	hl, _modified
	ld	[hl], $00
;src/editor/document.c:182: UndoSaved();
	call	_UndoSaved
;src/editor/document.c:183: ShowMessage("SAVED");
	ld	de, _src_editor_document_c___str_14
	call	_ShowMessage__far
.l00110:
;src/editor/document.c:184: }
	add	sp, 127
	add	sp, 66
	ret
	SECTION FRAGMENT "src/editor/document.c FIXED",ROMX,BANK[1]
_src_editor_document_c___str_11:
	DB "Save as "
	DB $00
	SECTION FRAGMENT "src/editor/document.c FIXED",ROMX,BANK[1]
_src_editor_document_c___str_12:
	DB "Saving..."
	DB $00
	SECTION FRAGMENT "src/editor/document.c FIXED",ROMX,BANK[1]
_src_editor_document_c___str_13:
	DB "DISK FULL"
	DB $00
	SECTION FRAGMENT "src/editor/document.c FIXED",ROMX,BANK[1]
_src_editor_document_c___str_14:
	DB "SAVED"
	DB $00
	SECTION FRAGMENT "src/editor/document.c FIXED",ROMX,BANK[1]
	SECTION FRAGMENT "_INITIALIZER",ROM0
	SECTION FRAGMENT "_CABS (ABS)",ROM0
