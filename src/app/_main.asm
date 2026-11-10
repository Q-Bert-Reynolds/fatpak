;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 4.2.0 #13081 (Linux)
;--------------------------------------------------------
	; MODULE main
	; Generated using the rgbds tokens.

;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	EXPORT _SGBSetDefaultBorder
	EXPORT _ClearScreen
	EXPORT _EditorDraw
	EXPORT _Refresh
	EXPORT _EditorSetup
	EXPORT _Editor
	EXPORT _EditorInit
	EXPORT _OpenFile
	EXPORT _FileBackupSave
	EXPORT _FileLoadSwap
	EXPORT _FileLoadData
	EXPORT _ShowMessage
	EXPORT _AppMain
;--------------------------------------------------------
; special function registers
;--------------------------------------------------------
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	SECTION FRAGMENT "src/app/main.c_DATA",WRAM0
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
	SECTION FRAGMENT "src/app/main.c_HOME",ROM0
	SECTION FRAGMENT "src/app/main.c_HOME",ROM0
;--------------------------------------------------------
; code
;--------------------------------------------------------
	SECTION FRAGMENT "src/app/main.c_CODE",ROMX
;src/app/main.c:13: void AppMain(void) {
;	---------------------------------
	SECTION FRAGMENT "Page 5",ROMX,BANK[2]
	LOAD FRAGMENT "Page 5 RAM",SRAM,BANK[5]
; Function AppMain
; ---------------------------------
_AppMain::
;src/app/main.c:14: FileBackupSave(); // the last game's save RAM, before anything else
	call	_FileBackupSave
;src/app/main.c:15: if (!FileLoadData("/GBCSYS/EDITOR.DAT")) {
	ld	de, _src_app_main_c___str_0
	call	_FileLoadData
	or	a, a
	jp	NZ, .l00102
;src/app/main.c:16: data_loaded = 1;
	ld	hl, _data_loaded
	ld	[hl], $01
;src/app/main.c:17: SGBSetDefaultBorder();
	call	_SGBSetDefaultBorder
.l00102:
;src/app/main.c:19: FileLoadSwap(); // before EditorSetup's tb_Load
	call	_FileLoadSwap
;src/app/main.c:20: EditorSetup();
	call	_EditorSetup
;src/app/main.c:21: EditorInit();
	call	_EditorInit
;src/app/main.c:22: if (backup_skipped) ShowMessage("SAVE NOT BACKED UP");
	ld	hl, _backup_skipped
	ld	a, [hl]
	or	a, a
	jp	Z, .l00104
	ld	de, _src_app_main_c___str_1
	call	_ShowMessage__far
.l00104:
;src/app/main.c:23: if (modified) Refresh();
	ld	hl, _modified
	ld	a, [hl]
	or	a, a
	jp	Z, .l00106
	call	_Refresh
	jp	.l00107
.l00106:
;src/app/main.c:25: ClearScreen();
	call	_ClearScreen__far
;src/app/main.c:26: EditorDraw();
	call	_EditorDraw
;src/app/main.c:27: dirty = 1;
	ld	hl, _dirty
	ld	[hl], $01
;src/app/main.c:28: OpenFile();
	call	_OpenFile__far
.l00107:
;src/app/main.c:31: Editor();
	jp	_Editor
.l00108:
;src/app/main.c:32: }
	ret
	SECTION FRAGMENT "src/app/main.c FIXED",ROMX,BANK[1]
_src_app_main_c___str_0:
	DB "/GBCSYS/EDITOR.DAT"
	DB $00
	SECTION FRAGMENT "src/app/main.c FIXED",ROMX,BANK[1]
_src_app_main_c___str_1:
	DB "SAVE NOT BACKED UP"
	DB $00
	SECTION FRAGMENT "src/app/main.c FIXED",ROMX,BANK[1]
	SECTION FRAGMENT "_INITIALIZER",ROM0
	SECTION FRAGMENT "_CABS (ABS)",ROM0
