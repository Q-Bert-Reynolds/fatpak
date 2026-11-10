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
	EXPORT _EditorRedraw
	EXPORT _SetFont
	EXPORT _HideBox
	EXPORT _ShowBusy
	EXPORT _Render
	EXPORT _UndoSaved
	EXPORT _UndoClear
	EXPORT _tb_ResetChecks
	EXPORT _tb_Clear
	EXPORT _SettingsSave
	EXPORT _JoinPath
	EXPORT _Browse
	EXPORT _ShowError
	EXPORT _ShowMessage
	EXPORT _Choose
	EXPORT _AskName
	EXPORT _FileSaveLarge
	EXPORT _FileCloseLarge
	EXPORT _FileLoadLarge
	EXPORT _FileSave
	EXPORT _FileLoad
	EXPORT _FileMount
	EXPORT _file_dir
	EXPORT _file_name
	EXPORT _CanDiscard
	EXPORT _FileLanguage
	EXPORT _SetLang
	EXPORT _NewFile
	EXPORT _OpenFile
	EXPORT _LoadDocument
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
;src/editor/document.c:34: unsigned char FileLanguage(const char* name) {
;	---------------------------------
	SECTION FRAGMENT "Page 4",ROMX,BANK[2]
	LOAD FRAGMENT "Page 4 RAM",SRAM,BANK[4]
; Function FileLanguage
; ---------------------------------
_FileLanguage::
	add	sp, -10
	ld	c, e
	ld	b, d
;src/editor/document.c:35: const char *c, *dot = 0, *e;
	ld	de, $0000
;src/editor/document.c:36: unsigned char lang = LANG_PLAIN, i;
	ld	hl, sp+0
	ld	[hl], $00
;src/editor/document.c:37: for (c = name; *c; ++c) if (*c == '.') dot = c;
.l00112:
	ld	a, [bc]
	or	a, a
	jp	Z, .l00103
	sub	a, $2E
	jp	NZ,.l00175
	jp	.l00176
.l00175:
	jp	.l00113
.l00176:
	ld	e, c
	ld	d, b
.l00113:
	inc	bc
	jp	.l00112
.l00103:
;src/editor/document.c:38: if (dot) for (i = 0; i < sizeof(lang_ids); ++i) {
	ld	a, d
	or	a, e
	jp	Z, .l00110
	inc	de
	ld	hl, sp+1
	ld	[hl], e
	inc	hl
	ld	[hl], d
	ld	hl, sp+5
	ld	[hl], $00
.l00118:
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
.l00116:
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
	jp	NZ,.l00178
	jp	.l00179
.l00178:
	jp	.l00104
.l00179:
	ld	hl, sp+6
	inc	[hl]
	jp	NZ, .l00180
	inc	hl
	inc	[hl]
.l00180:
	ld	hl, sp+8
	inc	[hl]
	jp	NZ, .l00181
	inc	hl
	inc	[hl]
.l00181:
	jp	.l00116
.l00104:
;src/editor/document.c:40: if (!*c && !*e) lang = lang_ids[i];
	ld	hl, sp+4
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00119
	dec	hl
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00119
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
.l00119:
;src/editor/document.c:38: if (dot) for (i = 0; i < sizeof(lang_ids); ++i) {
	ld	hl, sp+5
	inc	[hl]
	ld	a, [hl]
	sub	a, $06
	jp	C, .l00118
.l00110:
;src/editor/document.c:42: return lang;
	ld	hl, sp+0
	ld	a, [hl]
.l00120:
;src/editor/document.c:43: }
	add	sp, 10
	ret
;src/editor/document.c:45: void SetLang(void) {
;	---------------------------------
	SECTION FRAGMENT "Page 6",ROMX,BANK[3]
	LOAD FRAGMENT "Page 6 RAM",SRAM,BANK[6]
; Function SetLang
; ---------------------------------
_SetLang::
	add	sp, -3
;src/editor/document.c:46: unsigned char i, lang = FileLanguage(file_name);
	ld	de, _file_name
	call	_FileLanguage__far
	ld	c, a
;src/editor/document.c:47: font = lang == LANG_C || lang == LANG_ASM ? FONT_FIXED : FONT_VWF;
	ld	a, c
	sub	a, $02
	jp	NZ,.l00150
	jp	.l00115
.l00150:
	ld	a, c
	sub	a, $03
	jp	NZ,.l00151
	jp	.l00152
.l00151:
	jp	.l00112
.l00152:
.l00115:
	ld	de, $0002
	jp	.l00113
.l00112:
	ld	de, $0001
.l00113:
	ld	hl, _font
	ld	[hl], e
;src/editor/document.c:48: if (lang == tb_lang) return;
	ld	hl, _tb_lang
	ld	a, [hl]
	sub	a, c
	jp	NZ,.l00153
	jp	.l00154
.l00153:
	jp	.l00102
.l00154:
	jp	.l00110
.l00102:
;src/editor/document.c:49: tb_lang = lang;
	ld	hl, _tb_lang
	ld	[hl], c
;src/editor/document.c:50: tb_ResetChecks();
	call	_tb_ResetChecks
;src/editor/document.c:51: for (i = 0; i <= TB_ROWS; ++i) tb_row_states[i] = 0; // no markdown headings left in them
	ld	bc, _tb_row_states+0
	ld	e, $00
.l00105:
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
	jp	NC, .l00105
;src/editor/document.c:52: SetFont(font);
	ld	hl, _font
	ld	a, [hl]
	call	_SetFont
;src/editor/document.c:53: for (i = bars; i < bars + tb_rows; ++i) render_row_fonts[i] = font;
	ld	hl, _bars
	ld	a, [hl]
	ld	hl, sp+2
	ld	[hl], a
.l00108:
	ld	hl, _bars
	ld	c, [hl]
	ld	b, $00
	ld	hl, _tb_rows
	ld	l, [hl]
;	spillPairReg hl
;	spillPairReg hl
	ld	h, $00
;	spillPairReg hl
;	spillPairReg hl
	add	hl, bc
	ld	c, l
	ld	b, h
	ld	hl, sp+2
	ld	a, [hl]
	dec	hl
	dec	hl
	ld	[hl], a
	inc	hl
	ld	[hl], $00
	dec	hl
	ld	a, [hl]
	sub	a, c
	inc	hl
	ld	a, [hl]
	sbc	a, b
	ld	d, [hl]
	ld	a, b
	ld	e, a
	bit	7, e
	jp	Z, .l00155
	bit	7, d
	jp	NZ, .l00156
	cp	a, a
	jp	.l00156
.l00155:
	bit	7, d
	jp	Z, .l00156
	scf
.l00156:
	jp	NC, .l00104
	ld	de, _render_row_fonts
	ld	hl, sp+2
	ld	l, [hl]
	ld	h, $00
	add	hl, de
	ld	c, l
	ld	b, h
	ld	hl, _font
	ld	a, [hl]
	ld	[bc], a
	ld	hl, sp+2
	inc	[hl]
	jp	.l00108
.l00104:
;src/editor/document.c:54: EditorRedraw();
	call	_EditorRedraw
;src/editor/document.c:55: dirty = 1;
	ld	hl, _dirty
	ld	[hl], $01
.l00110:
;src/editor/document.c:56: }
	add	sp, 3
	ret
;src/editor/document.c:58: static void ResetCursor(void) {
;	---------------------------------
	SECTION FRAGMENT "Page 5",ROMX,BANK[2]
	LOAD FRAGMENT "Page 5 RAM",SRAM,BANK[5]
; Function ResetCursor
; ---------------------------------
_src_editor_document_c_ResetCursor:
;src/editor/document.c:59: SetLang();
	call	_SetLang__far
;src/editor/document.c:60: cursor = 0;
	xor	a, a
	ld	hl, _cursor
	ld	[hl], a
	inc	hl
	ld	[hl], a
;src/editor/document.c:61: counted_pos = 0;
	xor	a, a
	ld	hl, _counted_pos
	ld	[hl], a
	inc	hl
	ld	[hl], a
;src/editor/document.c:62: counted_lines = 0;
	xor	a, a
	ld	hl, _counted_lines
	ld	[hl], a
	inc	hl
	ld	[hl], a
;src/editor/document.c:63: selecting = 0;
	ld	hl, _selecting
	ld	[hl], $00
;src/editor/document.c:64: top = 0;
	xor	a, a
	ld	hl, _top
	ld	[hl], a
	inc	hl
	ld	[hl], a
;src/editor/document.c:65: tb_left = 0;
	xor	a, a
	ld	hl, _tb_left
	ld	[hl], a
	inc	hl
	ld	[hl], a
;src/editor/document.c:66: want_x = 0;
	ld	hl, _want_x
	ld	[hl], $00
;src/editor/document.c:67: modified = 0;
	ld	hl, _modified
	ld	[hl], $00
;src/editor/document.c:68: dirty = 1;
	ld	hl, _dirty
	ld	[hl], $01
;src/editor/document.c:69: UndoClear(0);
	xor	a, a
	jp	_UndoClear
.l00101:
;src/editor/document.c:70: }
	ret
;src/editor/document.c:72: void NewFile(void) {
;	---------------------------------
	SECTION FRAGMENT "Page 10",ROMX,BANK[5]
	LOAD FRAGMENT "Page 10 RAM",SRAM,BANK[10]
; Function NewFile
; ---------------------------------
_NewFile::
;src/editor/document.c:73: if (!CanDiscard()) return;
	call	_CanDiscard__far
	or	a, a
	jp	NZ, .l00102
	jp	.l00103
.l00102:
;src/editor/document.c:74: FileCloseLarge();
	call	_FileCloseLarge
;src/editor/document.c:75: tb_Clear();
	call	_tb_Clear
;src/editor/document.c:76: file_name[0] = 0;
	ld	hl, _file_name
	ld	[hl], $00
;src/editor/document.c:77: fs_crlf = 0;
	ld	hl, _fs_crlf
	ld	[hl], $00
;src/editor/document.c:78: ResetCursor();
	call	_src_editor_document_c_ResetCursor__far
;src/editor/document.c:79: SettingsSave();
	jp	_SettingsSave
.l00103:
;src/editor/document.c:80: }
	ret
;src/editor/document.c:82: void OpenFile(void) {
;	---------------------------------
	SECTION FRAGMENT "Page 9",ROMX,BANK[4]
	LOAD FRAGMENT "Page 9 RAM",SRAM,BANK[9]
; Function OpenFile
; ---------------------------------
_OpenFile::
;src/editor/document.c:83: if (!CanDiscard()) return;
	call	_CanDiscard__far
	or	a, a
	jp	NZ, .l00102
	jp	.l00105
.l00102:
;src/editor/document.c:84: if (Browse()) {
	call	_Browse__far
	or	a, a
	jp	Z, .l00105
;src/editor/document.c:85: ResetCursor();
	call	_src_editor_document_c_ResetCursor__far
;src/editor/document.c:86: SettingsSave();
	jp	_SettingsSave
.l00105:
;src/editor/document.c:88: }
	ret
;src/editor/document.c:91: void LoadDocument(char* path, unsigned char folder_length, const FileEntry* entry) {
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
;src/editor/document.c:93: if (entry->size > TB_SIZE) result = FileLoadLarge(path);
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
;src/editor/document.c:95: FileCloseLarge();
	call	_FileCloseLarge
;src/editor/document.c:96: result = FileLoad(path);
	ld	hl, sp+7
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_FileLoad
	ld	c, a
.l00103:
;src/editor/document.c:98: HideBox();
	push	bc
	call	_HideBox__far
	pop	bc
;src/editor/document.c:99: path[folder_length] = 0;
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
;src/editor/document.c:100: if (result) {
	ld	a, c
	or	a, a
	jp	Z, .l00105
;src/editor/document.c:101: file_name[0] = 0; // the text buffer only has part of it, don't save over the file
	ld	hl, _file_name
	ld	[hl], $00
;src/editor/document.c:102: ShowError(result, "TOO BIG");
	ld	de, _src_editor_document_c___str_9
	ld	a, c
	call	_ShowError__far
	jp	.l00107
.l00105:
;src/editor/document.c:105: CopyName(file_dir, path);
	ld	hl, sp+7
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	ld	de, _file_dir
	call	_CopyName
;src/editor/document.c:106: CopyName(file_name, entry->name);
	pop	bc
	push	bc
	ld	de, _file_name
	call	_CopyName
.l00107:
;src/editor/document.c:108: }
	add	sp, 9
	pop	hl
	inc	sp
	inc	sp
	jp hl
	SECTION FRAGMENT "src/editor/document.c FIXED",ROMX,BANK[1]
_src_editor_document_c___str_9:
	DB "TOO BIG"
	DB $00
;src/editor/document.c:110: void SaveFile(unsigned char ask) {
;	---------------------------------
	SECTION FRAGMENT "Page 4",ROMX,BANK[2]
	LOAD FRAGMENT "Page 4 RAM",SRAM,BANK[4]
; Function SaveFile
; ---------------------------------
_SaveFile::
	add	sp, -128
	add	sp, -65
	ld	c, a
;src/editor/document.c:113: if (ask || !file_name[0]) {
	ld	a, c
	or	a, a
	jp	NZ, .l00103
	ld	a, [_file_name + 0]
	or	a, a
	jp	NZ, .l00104
.l00103:
;src/editor/document.c:114: Render();
	call	_Render__far
;src/editor/document.c:115: if (!AskName(file_name, "Save as ")) return;
	ld	bc, _src_editor_document_c___str_10
	ld	de, _file_name
	call	_AskName
	or	a, a
	jp	NZ, .l00102
	jp	.l00110
.l00102:
;src/editor/document.c:116: SetLang();
	call	_SetLang__far
.l00104:
;src/editor/document.c:118: JoinPath(path, file_dir, file_name, (unsigned char)(PATH_SIZE + FS_NAME_SIZE));
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
;src/editor/document.c:119: ShowBusy("Saving...");
	ld	de, _src_editor_document_c___str_11
	call	_ShowBusy
;src/editor/document.c:120: result = FileMount();
	call	_FileMount
	ld	c, a
;src/editor/document.c:121: if (!result) result = doc_large ? FileSaveLarge(path) : FileSave(path);
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
;src/editor/document.c:122: HideBox();
	push	bc
	call	_HideBox__far
	pop	bc
;src/editor/document.c:123: SettingsSave(); // save as may have changed the name
	push	bc
	call	_SettingsSave
	pop	bc
;src/editor/document.c:124: if (result) {
	ld	a, c
	or	a, a
	jp	Z, .l00109
;src/editor/document.c:125: ShowError(result, "DISK FULL");
	ld	de, _src_editor_document_c___str_12
	ld	a, c
	call	_ShowError
;src/editor/document.c:126: return;
	jp	.l00110
.l00109:
;src/editor/document.c:128: modified = 0;
	ld	hl, _modified
	ld	[hl], $00
;src/editor/document.c:129: UndoSaved();
	call	_UndoSaved
;src/editor/document.c:130: ShowMessage("SAVED");
	ld	de, _src_editor_document_c___str_13
	call	_ShowMessage__far
.l00110:
;src/editor/document.c:131: }
	add	sp, 127
	add	sp, 66
	ret
	SECTION FRAGMENT "src/editor/document.c FIXED",ROMX,BANK[1]
_src_editor_document_c___str_10:
	DB "Save as "
	DB $00
	SECTION FRAGMENT "src/editor/document.c FIXED",ROMX,BANK[1]
_src_editor_document_c___str_11:
	DB "Saving..."
	DB $00
	SECTION FRAGMENT "src/editor/document.c FIXED",ROMX,BANK[1]
_src_editor_document_c___str_12:
	DB "DISK FULL"
	DB $00
	SECTION FRAGMENT "src/editor/document.c FIXED",ROMX,BANK[1]
_src_editor_document_c___str_13:
	DB "SAVED"
	DB $00
	SECTION FRAGMENT "src/editor/document.c FIXED",ROMX,BANK[1]
	SECTION FRAGMENT "_INITIALIZER",ROM0
	SECTION FRAGMENT "_CABS (ABS)",ROM0
