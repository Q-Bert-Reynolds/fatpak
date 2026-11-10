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
;src/app/menu.c:21: static void FileMenu(void) {
;	---------------------------------
	SECTION FRAGMENT "Page 4",ROMX,BANK[2]
	LOAD FRAGMENT "Page 4 RAM",SRAM,BANK[4]
; Function FileMenu
; ---------------------------------
_src_app_menu_c_FileMenu:
;src/app/menu.c:22: unsigned char menu = 0, item;
	ld	c, $00
;src/app/menu.c:23: while (1) {
.l00110:
;src/app/menu.c:24: if ((menu = Choose(0, menu_items[0], 5, menu)) >= BACK) return;
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
	jp	.l00128
.l00102:
;src/app/menu.c:25: if (menu == 4) {
	ld	a, c
	sub	a, $04
	jp	NZ,.l00165
	jp	.l00166
.l00165:
	jp	.l00104
.l00166:
;src/app/menu.c:26: OpenFile();
	jp	_OpenFile
;src/app/menu.c:27: return;
	jp	.l00128
.l00104:
;src/app/menu.c:29: item = submenu_starts[menu];
	ld	hl, _src_app_menu_c_submenu_starts
	ld	b, $00
	add	hl, bc
	ld	l, [hl]
;	spillPairReg hl
;src/app/menu.c:30: if ((item = Choose(0, submenu_items[item], submenu_starts[menu + 1] - item, 0)) == CANCEL) return;
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
	jp	NZ,.l00167
	jp	.l00168
.l00167:
	jp	.l00106
.l00168:
	jp	.l00128
.l00106:
;src/app/menu.c:31: if (item != BACK) break;
	ld	a, e
	sub	a, $FE
	jp	NZ,.l00169
	jp	.l00110
.l00169:
;src/app/menu.c:33: switch ((menu << 3) | item) {
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
	jp	NZ, .l00128
	ld	a, b
	ld	e, a
	ld	a, $00
	ld	d, a
	ld	a, $19
	cp	a, c
	ld	a, $00
	sbc	a, b
	bit	7, e
	jp	Z, .l00170
	bit	7, d
	jp	NZ, .l00171
	cp	a, a
	jp	.l00171
.l00170:
	bit	7, d
	jp	Z, .l00171
	scf
.l00171:
	jp	C, .l00128
	ld	b, $00
	ld	hl, .l00172
	add	hl, bc
	add	hl, bc
	add	hl, bc
	jp	hl
.l00172:
	jp	.l00112
	jp	.l00113
	jp	.l00114
	jp	.l00115
	jp	.l00128
	jp	.l00128
	jp	.l00128
	jp	.l00128
	jp	.l00116
	jp	.l00117
	jp	.l00118
	jp	.l00119
	jp	.l00120
	jp	.l00121
	jp	.l00128
	jp	.l00128
	jp	.l00122
	jp	.l00123
	jp	.l00124
	jp	.l00128
	jp	.l00128
	jp	.l00128
	jp	.l00128
	jp	.l00128
	jp	.l00125
	jp	.l00126
;src/app/menu.c:34: case 0: OpenFile(); break;
.l00112:
	jp	_OpenFile
	jp	.l00128
;src/app/menu.c:35: case 1: SaveFile(0); break;
.l00113:
	xor	a, a
	jp	_SaveFile
	jp	.l00128
;src/app/menu.c:36: case 2: SaveFile(1); break;
.l00114:
	ld	a, $01
	jp	_SaveFile
	jp	.l00128
;src/app/menu.c:37: case 3: NewFile(); break;
.l00115:
	jp	_NewFile
	jp	.l00128
;src/app/menu.c:38: case 8: UndoRedo(0); break;
.l00116:
	xor	a, a
	jp	_UndoRedo__far
	jp	.l00128
;src/app/menu.c:39: case 9: UndoRedo(1); break;
.l00117:
	ld	a, $01
	jp	_UndoRedo__far
	jp	.l00128
;src/app/menu.c:40: case 10: Cut(); break;
.l00118:
	jp	_Cut__far
	jp	.l00128
;src/app/menu.c:41: case 11: Copy(); break;
.l00119:
	jp	_Copy__far
	jp	.l00128
;src/app/menu.c:42: case 12: Paste(); break;
.l00120:
	jp	_Paste__far
	jp	.l00128
;src/app/menu.c:43: case 13: SelectAll(); break;
.l00121:
	jp	_SelectAll__far
	jp	.l00128
;src/app/menu.c:44: case 16: ToggleWrap(); break;
.l00122:
	jp	_ToggleWrap__far
	jp	.l00128
;src/app/menu.c:45: case 17: ToggleBars(); break;
.l00123:
	jp	_ToggleBars__far
	jp	.l00128
;src/app/menu.c:46: case 18: ClockSetup(); break;
.l00124:
	jp	_ClockSetup__far
	jp	.l00128
;src/app/menu.c:47: case 24: ShowHelp(); break;
.l00125:
	jp	_ShowHelp__far
	jp	.l00128
;src/app/menu.c:48: case 25: KeyboardTest(); break;
.l00126:
	jp	_KeyboardTest__far
;src/app/menu.c:49: }
.l00128:
;src/app/menu.c:50: }
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
	DB "CONTROLS"
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
	DB $0D	; 13
	DB $0F	; 15
;src/app/menu.c:53: unsigned char HandleFileKey(unsigned char key, unsigned char mods) {
;	---------------------------------
	SECTION FRAGMENT "Page 4",ROMX,BANK[2]
	LOAD FRAGMENT "Page 4 RAM",SRAM,BANK[4]
; Function HandleFileKey
; ---------------------------------
_HandleFileKey::
	ld	c, a
;src/app/menu.c:54: if (key == KEY_MENU || key == KEY_ESCAPE) FileMenu();
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
;src/app/menu.c:55: else if (key == KEY_F1) ShowHelp();
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
;src/app/menu.c:56: else if (key == KEY_F11) ToggleBars();
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
;src/app/menu.c:57: else if ((mods & KB_MOD_ALT) && (key == 'z' || key == 'Z')) ToggleWrap();
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
;src/app/menu.c:58: else if (!(mods & KB_MOD_CTRL)) return 0;
	bit	5, e
	jp	NZ,.l00189
	jp	.l00190
.l00189:
	jp	.l00114
.l00190:
	xor	a, a
	jp	.l00131
.l00114:
;src/app/menu.c:59: else if (key == 'o' || key == 'O') OpenFile();
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
	call	_OpenFile
	jp	.l00129
.l00110:
;src/app/menu.c:60: else if (key == 's' || key == 'S') SaveFile(0);
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
;src/app/menu.c:61: else if (key == 'n' || key == 'N') NewFile();
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
	call	_NewFile
	jp	.l00129
.l00102:
;src/app/menu.c:62: else return 0;
	xor	a, a
	jp	.l00131
.l00129:
;src/app/menu.c:63: dirty = 1;
	ld	hl, _dirty
	ld	[hl], $01
;src/app/menu.c:64: return 1;
	ld	a, $01
.l00131:
;src/app/menu.c:65: }
	ret
	SECTION FRAGMENT "Page 4",ROMX,BANK[2]
	LOAD FRAGMENT "Page 4 RAM",SRAM,BANK[4]
	SECTION FRAGMENT "_INITIALIZER",ROM0
	SECTION FRAGMENT "_CABS (ABS)",ROM0
