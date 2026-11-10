;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 4.2.0 #13081 (Linux)
;--------------------------------------------------------
	; MODULE loader
	; Generated using the rgbds tokens.

;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	EXPORT _CopyName
	EXPORT _PutNumber
	EXPORT _PutText
	EXPORT _RenderTextWidth
	EXPORT _EditorDraw
	EXPORT _HideBox
	EXPORT _ShowBusy
	EXPORT _tb_Clear
	EXPORT _SettingsSave
	EXPORT _CanDiscard
	EXPORT _FileGameFinish
	EXPORT _FileGameCopy
	EXPORT _FileGameOpen
	EXPORT _FileCloseLarge
	EXPORT _FileSaveSwap
	EXPORT _ToLatin1
	EXPORT _ShowError
	EXPORT _Reboot
	EXPORT _GameLaunch
	EXPORT _GameLoadingEnd
	EXPORT _GameLoadingBegin
	EXPORT _InGameHeader
	EXPORT _IsGame
	EXPORT _LaunchGame
;--------------------------------------------------------
; special function registers
;--------------------------------------------------------
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	SECTION FRAGMENT "src/game/loader.c_DATA",WRAM0
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
	SECTION FRAGMENT "src/game/loader.c_HOME",ROM0
	SECTION FRAGMENT "src/game/loader.c_HOME",ROM0
;--------------------------------------------------------
; code
;--------------------------------------------------------
	SECTION FRAGMENT "src/game/loader.c_CODE",ROMX
;src/game/loader.c:15: unsigned char IsGame(const char* name) {
;	---------------------------------
	SECTION FRAGMENT "Page 6",ROMX,BANK[3]
	LOAD FRAGMENT "Page 6 RAM",SRAM,BANK[6]
; Function IsGame
; ---------------------------------
_IsGame::
;src/game/loader.c:16: const char* dot = 0;
	ld	bc, $0000
;src/game/loader.c:18: return dot && (dot[1] | 0x20) == 'g' && (dot[2] | 0x20) == 'b' && (!dot[3] || ((dot[3] | 0x20) == 'c' && !dot[4]));
.l00105:
;src/game/loader.c:17: for (; *name; ++name) if (*name == '.') dot = name;
	ld	a, [de]
	or	a, a
	jp	Z, .l00103
	sub	a, $2E
	jp	NZ,.l00163
	jp	.l00164
.l00163:
	jp	.l00106
.l00164:
	ld	c, e
	ld	b, d
.l00106:
	inc	de
	jp	.l00105
.l00103:
;src/game/loader.c:18: return dot && (dot[1] | 0x20) == 'g' && (dot[2] | 0x20) == 'b' && (!dot[3] || ((dot[3] | 0x20) == 'c' && !dot[4]));
	ld	a, b
	or	a, c
	jp	Z, .l00109
	ld	e, c
	ld	d, b
	inc	de
	ld	a, [de]
	set	5, a
	sub	a, $67
	jp	NZ,.l00165
	jp	.l00166
.l00165:
	jp	.l00109
.l00166:
	ld	e, c
	ld	d, b
	inc	de
	inc	de
	ld	a, [de]
	set	5, a
	sub	a, $62
	jp	NZ,.l00167
	jp	.l00168
.l00167:
	jp	.l00109
.l00168:
	ld	e, c
	ld	d, b
	inc	de
	inc	de
	inc	de
	ld	a, [de]
	or	a, a
	jp	Z, .l00110
	set	5, a
	sub	a, $63
	jp	NZ,.l00169
	jp	.l00170
.l00169:
	jp	.l00109
.l00170:
	inc	bc
	inc	bc
	inc	bc
	inc	bc
	ld	a, [bc]
	or	a, a
	jp	Z, .l00110
.l00109:
	xor	a, a
	jp	.l00111
.l00110:
	ld	a, $01
.l00111:
.l00107:
;src/game/loader.c:19: }
	ret
;src/game/loader.c:22: static void ShowGameProgress(char* text) {
;	---------------------------------
	SECTION FRAGMENT "Page 12",ROMX,BANK[6]
	LOAD FRAGMENT "Page 12 RAM",SRAM,BANK[12]
; Function ShowGameProgress
; ---------------------------------
_src_game_loader_c_ShowGameProgress:
	dec	sp
	dec	sp
	inc	sp
	inc	sp
	push	de
;src/game/loader.c:23: char* end = PutText(text, "Loading ");
	ld	bc, _src_game_loader_c___str_0
	pop	de
	push	de
	call	_PutText__far
;src/game/loader.c:24: end = PutNumber(end, game_block >> 1);
	ld	hl, _game_block + 1
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	srl	d
	rr	e
	ld	hl, $0000
	push	hl
	push	de
	ld	e, c
	ld	d, b
	call	_PutNumber__far
;src/game/loader.c:25: *end++ = '/';
	ld	a, $2F
	ld	[bc], a
	inc	bc
;src/game/loader.c:26: end = PutText(PutNumber(end, game_blocks >> 1), " KB");
	ld	hl, _game_blocks + 1
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	srl	d
	rr	e
	ld	hl, $0000
	push	hl
	push	de
	ld	e, c
	ld	d, b
	call	_PutNumber__far
	ld	e, c
	ld	d, b
	ld	bc, _src_game_loader_c___str_1
	call	_PutText__far
;src/game/loader.c:27: *end = 0;
	xor	a, a
	ld	[bc], a
;src/game/loader.c:28: CopyName(render_box_text, text);
	pop	bc
	push	bc
	ld	hl, _render_box_text
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_CopyName__far
;src/game/loader.c:29: ++render_box_gen;
	ld	hl, _render_box_gen
	inc	[hl]
;src/game/loader.c:30: EditorDraw();
	call	_EditorDraw
.l00101:
;src/game/loader.c:31: }
	inc	sp
	inc	sp
	ret
	SECTION FRAGMENT "src/game/loader.c FIXED",ROMX,BANK[1]
_src_game_loader_c___str_0:
	DB "Loading "
	DB $00
	SECTION FRAGMENT "src/game/loader.c FIXED",ROMX,BANK[1]
_src_game_loader_c___str_1:
	DB " KB"
	DB $00
;src/game/loader.c:35: void LaunchGame(const char* path) {
;	---------------------------------
	SECTION FRAGMENT "Page 6",ROMX,BANK[3]
	LOAD FRAGMENT "Page 6 RAM",SRAM,BANK[6]
; Function LaunchGame
; ---------------------------------
_LaunchGame::
	add	sp, -42
	ld	hl, sp+40
	ld	[hl], e
	inc	hl
	ld	[hl], d
;src/game/loader.c:39: if (doc_large) {
	ld	hl, _doc_large
	ld	a, [hl]
	or	a, a
	jp	Z, .l00104
;src/game/loader.c:40: if (!CanDiscard()) return;
	call	_CanDiscard__far
	or	a, a
	jp	NZ, .l00102
	jp	.l00127
.l00102:
;src/game/loader.c:41: FileCloseLarge();
	call	_FileCloseLarge
;src/game/loader.c:42: tb_Clear();
	call	_tb_Clear
;src/game/loader.c:43: file_name[0] = 0;
	ld	hl, _file_name
	ld	[hl], $00
;src/game/loader.c:44: modified = 0;
	ld	hl, _modified
	ld	[hl], $00
;src/game/loader.c:45: SettingsSave();
	call	_SettingsSave
.l00104:
;src/game/loader.c:47: render_cpu_copy = 1; // keep CGB layout/palettes, draw loading tiles without HDMA
	ld	hl, _render_cpu_copy
	ld	[hl], $01
;src/game/loader.c:48: ShowBusy("Loading...");
	ld	de, _src_game_loader_c___str_2
	call	_ShowBusy
;src/game/loader.c:49: if ((result = FileSaveSwap())) {
	call	_FileSaveSwap
	ld	c, a
	or	a, a
	jp	Z, .l00106
;src/game/loader.c:50: render_cpu_copy = 0;
	ld	hl, _render_cpu_copy
	ld	[hl], $00
;src/game/loader.c:51: HideBox();
	push	bc
	call	_HideBox
	pop	bc
;src/game/loader.c:52: ShowError(result, "DISK FULL");
	ld	de, _src_game_loader_c___str_3
	ld	a, c
	call	_ShowError__far
;src/game/loader.c:53: return;
	jp	.l00127
.l00106:
;src/game/loader.c:55: result = FileGameOpen(path);
	ld	hl, sp+40
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_FileGameOpen
	ld	c, a
;src/game/loader.c:56: if (!result) {
	ld	a, c
	or	a, a
	jp	NZ, .l00118
;src/game/loader.c:57: GameLoadingBegin();
	push	bc
	call	_GameLoadingBegin
	pop	bc
;src/game/loader.c:59: render_box_w = RenderTextWidth("Loading 8888/8888 KB") + BOX_PADDING;
	push	bc
	ld	de, _src_game_loader_c___str_4
	call	_RenderTextWidth
	pop	bc
	add	a, $09
	ld	hl, _render_box_w
	ld	[hl], a
;src/game/loader.c:60: render_box_x = (TB_WIDTH - render_box_w) >> 1;
	ld	e, [hl]
	ld	d, $00
	ld	a, $A0
	sub	a, e
	ld	e, a
	sbc	a, a
	sub	a, d
	ld	b, a
	sra	b
	rr	e
	ld	hl, _render_box_x
	ld	[hl], e
;src/game/loader.c:61: ShowGameProgress(text);
	push	bc
	ld	hl, 2
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_src_game_loader_c_ShowGameProgress__far
	pop	bc
;src/game/loader.c:62: while (!result && game_block != game_blocks) {
.l00110:
	ld	a, c
	or	a, a
	jp	NZ, .l00112
	ld	hl, _game_block
	ld	a, [hl]
	ld	hl, _game_blocks
	sub	a, [hl]
	jp	NZ,.l00200
	ld	hl, _game_block + 1
	ld	a, [hl]
	ld	hl, _game_blocks + 1
	sub	a, [hl]
	jp	NZ,.l00200
	jp	.l00112
.l00200:
;src/game/loader.c:63: result = FileGameCopy();
	call	_FileGameCopy
	ld	c, a
;src/game/loader.c:64: if (!result) ShowGameProgress(text);
	ld	a, c
	or	a, a
	jp	NZ, .l00110
	push	bc
	ld	hl, 2
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_src_game_loader_c_ShowGameProgress__far
	pop	bc
	jp	.l00110
.l00112:
;src/game/loader.c:66: if (!result) result = FileGameFinish(path);
	ld	a, c
	or	a, a
	jp	NZ, .l00114
	ld	hl, sp+40
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_FileGameFinish
	ld	c, a
.l00114:
;src/game/loader.c:67: if (result) GameLoadingEnd();
	ld	a, c
	or	a, a
	jp	Z, .l00118
	push	bc
	call	_GameLoadingEnd
	pop	bc
.l00118:
;src/game/loader.c:69: if (result) {
	ld	a, c
	or	a, a
	jp	Z, .l00120
;src/game/loader.c:70: render_cpu_copy = 0;
	ld	hl, _render_cpu_copy
	ld	[hl], $00
;src/game/loader.c:71: HideBox();
	push	bc
	call	_HideBox
	pop	bc
;src/game/loader.c:72: ShowError(result, "TOO BIG");
	ld	de, _src_game_loader_c___str_5
	ld	a, c
	call	_ShowError__far
;src/game/loader.c:73: Reboot(); // PSRAM's text may be overwritten, booting restores it from the swap file
	call	_Reboot
.l00120:
;src/game/loader.c:76: basename = path;
	ld	hl, sp+40
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
;src/game/loader.c:77: for (scan = path; *scan; ++scan) if (*scan == '/') basename = scan + 1;
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
.l00125:
	ld	a, [de]
	or	a, a
	jp	Z, .l00123
	inc	de
	sub	a, $2F
	jp	NZ,.l00201
	jp	.l00202
.l00201:
	jp	.l00126
.l00202:
	ld	c, e
	ld	b, d
.l00126:
	jp	.l00125
.l00123:
;src/game/loader.c:78: *ToLatin1(text, basename, sizeof(text) - 1) = 0;
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
	ld	a, $27
	push	af
	inc	sp
	ld	e, l
	ld	d, h
	call	_ToLatin1
	pop	de
	xor	a, a
	ld	[bc], a
;src/game/loader.c:79: InGameHeader(text);
	call	_InGameHeader
;src/game/loader.c:80: GameLaunch();
	call	_GameLaunch
.l00127:
;src/game/loader.c:81: }
	add	sp, 42
	ret
	SECTION FRAGMENT "src/game/loader.c FIXED",ROMX,BANK[1]
_src_game_loader_c___str_2:
	DB "Loading..."
	DB $00
	SECTION FRAGMENT "src/game/loader.c FIXED",ROMX,BANK[1]
_src_game_loader_c___str_3:
	DB "DISK FULL"
	DB $00
	SECTION FRAGMENT "src/game/loader.c FIXED",ROMX,BANK[1]
_src_game_loader_c___str_4:
	DB "Loading 8888/8888 KB"
	DB $00
	SECTION FRAGMENT "src/game/loader.c FIXED",ROMX,BANK[1]
_src_game_loader_c___str_5:
	DB "TOO BIG"
	DB $00
	SECTION FRAGMENT "src/game/loader.c FIXED",ROMX,BANK[1]
	SECTION FRAGMENT "_INITIALIZER",ROM0
	SECTION FRAGMENT "_CABS (ABS)",ROM0
