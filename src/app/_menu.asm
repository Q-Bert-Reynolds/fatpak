;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 4.2.0 #13081 (Linux)
;--------------------------------------------------------
	; MODULE menu
	; Generated using the rgbds tokens.

;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	EXPORT _ClockSetup
	EXPORT _KeyboardTest
	EXPORT _ToggleBars
	EXPORT _ShowHelp
	EXPORT _ToggleWrap
	EXPORT _Cut
	EXPORT _SelectAll
	EXPORT _UndoRedo
	EXPORT _Paste
	EXPORT _Copy
	EXPORT _SaveFile
	EXPORT _OpenFile
	EXPORT _NewFile
	EXPORT _Choose
	EXPORT _PreferencesMenu
	EXPORT _HandleFileKey
;--------------------------------------------------------
; special function registers
;--------------------------------------------------------
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	SECTION FRAGMENT "src/app/menu.c_DATA",WRAM0
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
	SECTION FRAGMENT "src/app/menu.c_HOME",ROM0
	SECTION FRAGMENT "src/app/menu.c_HOME",ROM0
;--------------------------------------------------------
; code
;--------------------------------------------------------
	SECTION FRAGMENT "src/app/menu.c_CODE",ROMX
;src/app/menu.c:21: unsigned char PreferencesMenu(unsigned char browser) {
;	---------------------------------
	SECTION FRAGMENT "Page 15",ROMX,BANK[7]
	LOAD FRAGMENT "Page 15 RAM",SRAM,BANK[15]
; Function PreferencesMenu
; ---------------------------------
_PreferencesMenu::
	ld	c, a
;src/app/menu.c:22: unsigned char item = Choose(0, submenu_items[browser ? 12 : 10], 2, 0);
	ld	a, c
	or	a, a
	jp	Z, .l00114
	ld	hl, $000C
	jp	.l00115
.l00114:
	ld	hl, $000A
.l00115:
	ld	e, l
	ld	d, h
	add	hl, hl
	add	hl, de
	add	hl, hl
	add	hl, de
	add	hl, hl
	ld	de, _src_app_menu_c_submenu_items
	add	hl, de
	push	bc
	xor	a, a
	push	af
	inc	sp
	ld	a, $02
	push	af
	inc	sp
	ld	c, l
	ld	b, h
	ld	de, $0000
	call	_Choose__far
	pop	bc
	ld	b, a
;src/app/menu.c:23: if (item >= BACK) return item;
	ld	a, b
	sub	a, $FE
	jp	C, .l00102
	ld	a, b
	jp	.l00112
.l00102:
;src/app/menu.c:24: if (browser) {
	ld	a, c
	or	a, a
	jp	Z, .l00110
;src/app/menu.c:25: if (item) KeyboardTest(); else ClockSetup();
	ld	a, b
	or	a, a
	jp	Z, .l00104
	push	bc
	call	_KeyboardTest__far
	pop	bc
	jp	.l00111
.l00104:
	push	bc
	call	_ClockSetup__far
	pop	bc
	jp	.l00111
.l00110:
;src/app/menu.c:27: else if (!item) ToggleWrap();
	ld	a, b
	or	a, a
	jp	NZ, .l00107
	push	bc
	call	_ToggleWrap__far
	pop	bc
	jp	.l00111
.l00107:
;src/app/menu.c:28: else ToggleBars();
	push	bc
	call	_ToggleBars__far
	pop	bc
.l00111:
;src/app/menu.c:29: return item;
	ld	a, b
.l00112:
;src/app/menu.c:30: }
	ret
	SECTION FRAGMENT "src/app/menu.c FIXED",ROMX,BANK[1]
_src_app_menu_c_menu_items:
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
	DB "CLOSE"
	DB $00
	DB $00
	DB $00
	DB $00
	DB $00
	DB $00
	DB $00
	DB $00
	DB $00
	SECTION FRAGMENT "src/app/menu.c FIXED",ROMX,BANK[1]
_src_app_menu_c_submenu_items:
	DB "OPEN"
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
	DB "SAVE"
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
	DB "SAVE AS"
	DB $00
	DB $00
	DB $00
	DB $00
	DB $00
	DB $00
	DB $00
	DB "NEW"
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
	DB "UNDO"
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
	DB "REDO"
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
	DB "SELECT ALL"
	DB $00
	DB $00
	DB $00
	DB $00
	DB "LINE WRAP"
	DB $00
	DB $00
	DB $00
	DB $00
	DB $00
	DB "FULL SCREEN"
	DB $00
	DB $00
	DB $00
	DB "CLOCK"
	DB $00
	DB $00
	DB $00
	DB $00
	DB $00
	DB $00
	DB $00
	DB $00
	DB $00
	DB "KEYBOARD TEST"
	DB $00
	SECTION FRAGMENT "src/app/menu.c FIXED",ROMX,BANK[1]
_src_app_menu_c_submenu_starts:
	DB $00	; 0
	DB $04	; 4
	DB $0A	; 10
;src/app/menu.c:32: static void FileMenu(void) {
;	---------------------------------
	SECTION FRAGMENT "Page 4",ROMX,BANK[2]
	LOAD FRAGMENT "Page 4 RAM",SRAM,BANK[4]
; Function FileMenu
; ---------------------------------
_src_app_menu_c_FileMenu:
;src/app/menu.c:33: unsigned char menu = 0, item;
	ld	c, $00
;src/app/menu.c:34: while (1) {
.l00116:
;src/app/menu.c:35: if ((menu = Choose(0, menu_items[0], 5, menu)) >= BACK) return;
	ld	a, c
	push	af
	inc	sp
	ld	a, $05
	push	af
	inc	sp
	ld	bc, _src_app_menu_c_menu_items
	ld	de, $0000
	call	_Choose
	ld	c, a
	sub	a, $FE
	jp	C, .l00102
	jp	.l00129
.l00102:
;src/app/menu.c:36: if (menu == 4) {
	ld	a, c
	sub	a, $04
	jp	NZ,.l00181
	jp	.l00182
.l00181:
	jp	.l00104
.l00182:
;src/app/menu.c:37: OpenFile();
	jp	_OpenFile__far
;src/app/menu.c:38: return;
	jp	.l00129
.l00104:
;src/app/menu.c:40: if (menu == 3) { ShowHelp(); return; }
	ld	a, c
	sub	a, $03
	jp	NZ,.l00183
	jp	.l00184
.l00183:
	jp	.l00106
.l00184:
	jp	_ShowHelp__far
	jp	.l00129
.l00106:
;src/app/menu.c:41: if (menu == 2) {
	ld	a, c
	sub	a, $02
	jp	NZ,.l00185
	jp	.l00186
.l00185:
	jp	.l00110
.l00186:
;src/app/menu.c:42: if (PreferencesMenu(0) == BACK) continue;
	push	bc
	xor	a, a
	call	_PreferencesMenu__far
	pop	bc
	sub	a, $FE
	jp	NZ,.l00187
	jp	.l00116
.l00187:
;src/app/menu.c:43: return;
	jp	.l00129
.l00110:
;src/app/menu.c:45: item = submenu_starts[menu];
	ld	hl, _src_app_menu_c_submenu_starts
	ld	b, $00
	add	hl, bc
	ld	l, [hl]
;	spillPairReg hl
;src/app/menu.c:46: if ((item = Choose(0, submenu_items[item], submenu_starts[menu + 1] - item, 0)) == CANCEL) return;
	ld	a, c
	inc	a
	push	af
	rlca
	sbc	a, a
	ld	b, a
	pop	af
	add	a, LOW(_src_app_menu_c_submenu_starts)
	ld	e, a
	ld	a, b
	adc	a, HIGH(_src_app_menu_c_submenu_starts)
	ld	d, a
	ld	a, [de]
	sub	a, l
	ld	b, a
	ld	e, l
	ld	d, $00
	ld	l, e
	ld	h, d
	add	hl, hl
	add	hl, de
	add	hl, hl
	add	hl, de
	add	hl, hl
	ld	de, _src_app_menu_c_submenu_items
	add	hl, de
	push	bc
	xor	a, a
	push	af
	inc	sp
	push	bc
	inc	sp
	ld	c, l
	ld	b, h
	ld	de, $0000
	call	_Choose
	pop	bc
	ld	e, a
	inc	a
	jp	NZ,.l00188
	jp	.l00189
.l00188:
	jp	.l00112
.l00189:
	jp	.l00129
.l00112:
;src/app/menu.c:47: if (item != BACK) break;
	ld	a, e
	sub	a, $FE
	jp	NZ,.l00190
	jp	.l00116
.l00190:
;src/app/menu.c:49: switch ((menu << 3) | item) {
	ld	l, c
;	spillPairReg hl
;	spillPairReg hl
	ld	h, $00
;	spillPairReg hl
;	spillPairReg hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	ld	a, l
	ld	d, $00
	or	a, e
	ld	c, a
	ld	a, h
	or	a, d
	ld	b, a
	bit	7, b
	jp	NZ, .l00129
	ld	a, b
	ld	e, a
	ld	a, $00
	ld	d, a
	ld	a, $0D
	cp	a, c
	ld	a, $00
	sbc	a, b
	bit	7, e
	jp	Z, .l00191
	bit	7, d
	jp	NZ, .l00192
	cp	a, a
	jp	.l00192
.l00191:
	bit	7, d
	jp	Z, .l00192
	scf
.l00192:
	jp	C, .l00129
	ld	b, $00
	ld	hl, .l00193
	add	hl, bc
	add	hl, bc
	add	hl, bc
	jp	hl
.l00193:
	jp	.l00118
	jp	.l00119
	jp	.l00120
	jp	.l00121
	jp	.l00129
	jp	.l00129
	jp	.l00129
	jp	.l00129
	jp	.l00122
	jp	.l00123
	jp	.l00124
	jp	.l00125
	jp	.l00126
	jp	.l00127
;src/app/menu.c:50: case 0: OpenFile(); break;
.l00118:
	jp	_OpenFile__far
	jp	.l00129
;src/app/menu.c:51: case 1: SaveFile(0); break;
.l00119:
	xor	a, a
	jp	_SaveFile
	jp	.l00129
;src/app/menu.c:52: case 2: SaveFile(1); break;
.l00120:
	ld	a, $01
	jp	_SaveFile
	jp	.l00129
;src/app/menu.c:53: case 3: NewFile(); break;
.l00121:
	jp	_NewFile__far
	jp	.l00129
;src/app/menu.c:54: case 8: UndoRedo(0); break;
.l00122:
	xor	a, a
	jp	_UndoRedo__far
	jp	.l00129
;src/app/menu.c:55: case 9: UndoRedo(1); break;
.l00123:
	ld	a, $01
	jp	_UndoRedo__far
	jp	.l00129
;src/app/menu.c:56: case 10: Cut(); break;
.l00124:
	jp	_Cut__far
	jp	.l00129
;src/app/menu.c:57: case 11: Copy(); break;
.l00125:
	jp	_Copy__far
	jp	.l00129
;src/app/menu.c:58: case 12: Paste(); break;
.l00126:
	jp	_Paste__far
	jp	.l00129
;src/app/menu.c:59: case 13: SelectAll(); break;
.l00127:
	jp	_SelectAll__far
;src/app/menu.c:60: }
.l00129:
;src/app/menu.c:61: }
	ret
;src/app/menu.c:64: unsigned char HandleFileKey(unsigned char key, unsigned char mods) {
;	---------------------------------
	SECTION FRAGMENT "Page 4",ROMX,BANK[2]
	LOAD FRAGMENT "Page 4 RAM",SRAM,BANK[4]
; Function HandleFileKey
; ---------------------------------
_HandleFileKey::
	ld	c, a
;src/app/menu.c:65: if (key == KEY_MENU || key == KEY_ESCAPE) FileMenu();
	ld	a, c
	sub	a, $89
	jp	NZ,.l00178
	jp	.l00127
.l00178:
	ld	a, c
	sub	a, $1B
	jp	NZ,.l00179
	jp	.l00180
.l00179:
	jp	.l00128
.l00180:
.l00127:
	call	_src_app_menu_c_FileMenu
	jp	.l00129
.l00128:
;src/app/menu.c:66: else if (key == KEY_F1) ShowHelp();
	ld	a, c
	sub	a, $90
	jp	NZ,.l00181
	jp	.l00182
.l00181:
	jp	.l00125
.l00182:
	call	_ShowHelp__far
	jp	.l00129
.l00125:
;src/app/menu.c:67: else if (key == KEY_F11) ToggleBars();
	ld	a, c
	sub	a, $9A
	jp	NZ,.l00183
	jp	.l00184
.l00183:
	jp	.l00122
.l00184:
	call	_ToggleBars__far
	jp	.l00129
.l00122:
;src/app/menu.c:68: else if ((mods & KB_MOD_ALT) && (key == 'z' || key == 'Z')) ToggleWrap();
	bit	4, e
	jp	NZ,.l00185
	jp	.l00117
.l00185:
	ld	a, c
	sub	a, $7A
	jp	NZ,.l00186
	jp	.l00116
.l00186:
	ld	a, c
	sub	a, $5A
	jp	NZ,.l00187
	jp	.l00188
.l00187:
	jp	.l00117
.l00188:
.l00116:
	call	_ToggleWrap__far
	jp	.l00129
.l00117:
;src/app/menu.c:69: else if (!(mods & KB_MOD_CTRL)) return 0;
	bit	5, e
	jp	NZ,.l00189
	jp	.l00190
.l00189:
	jp	.l00114
.l00190:
	xor	a, a
	jp	.l00131
.l00114:
;src/app/menu.c:70: else if (key == 'o' || key == 'O') OpenFile();
	ld	a, c
	sub	a, $6F
	jp	NZ,.l00191
	jp	.l00109
.l00191:
	ld	a, c
	sub	a, $4F
	jp	NZ,.l00192
	jp	.l00193
.l00192:
	jp	.l00110
.l00193:
.l00109:
	call	_OpenFile__far
	jp	.l00129
.l00110:
;src/app/menu.c:71: else if (key == 's' || key == 'S') SaveFile(0);
	ld	a, c
	sub	a, $73
	jp	NZ,.l00194
	jp	.l00105
.l00194:
	ld	a, c
	sub	a, $53
	jp	NZ,.l00195
	jp	.l00196
.l00195:
	jp	.l00106
.l00196:
.l00105:
	xor	a, a
	call	_SaveFile
	jp	.l00129
.l00106:
;src/app/menu.c:72: else if (key == 'n' || key == 'N') NewFile();
	ld	a, c
	sub	a, $6E
	jp	NZ,.l00197
	jp	.l00101
.l00197:
	ld	a, c
	sub	a, $4E
	jp	NZ,.l00198
	jp	.l00199
.l00198:
	jp	.l00102
.l00199:
.l00101:
	call	_NewFile__far
	jp	.l00129
.l00102:
;src/app/menu.c:73: else return 0;
	xor	a, a
	jp	.l00131
.l00129:
;src/app/menu.c:74: dirty = 1;
	ld	hl, _dirty
	ld	[hl], $01
;src/app/menu.c:75: return 1;
	ld	a, $01
.l00131:
;src/app/menu.c:76: }
	ret
	SECTION FRAGMENT "Page 4",ROMX,BANK[2]
	LOAD FRAGMENT "Page 4 RAM",SRAM,BANK[4]
	SECTION FRAGMENT "_INITIALIZER",ROM0
	SECTION FRAGMENT "_CABS (ABS)",ROM0
