;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 4.2.0 #13081 (Linux)
;--------------------------------------------------------
	; MODULE input
	; Generated using the rgbds tokens.

;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	EXPORT _WaitFrame
	EXPORT _KBPopEvent
	EXPORT _PadPressed
	EXPORT _pad_timer
	EXPORT _DpadRepeat
	EXPORT _MenuKey
;--------------------------------------------------------
; special function registers
;--------------------------------------------------------
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	SECTION FRAGMENT "src/input.c_DATA",WRAM0
_pad_timer:
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
	SECTION FRAGMENT "src/input.c_HOME",ROM0
	SECTION FRAGMENT "src/input.c_HOME",ROM0
;--------------------------------------------------------
; code
;--------------------------------------------------------
	SECTION FRAGMENT "src/input.c_CODE",ROMX
;src/input.c:9: unsigned char DpadRepeat(unsigned char pressed) {
;	---------------------------------
	SECTION FRAGMENT "Page 6",ROMX,BANK[3]
	LOAD FRAGMENT "Page 6 RAM",SRAM,BANK[6]
; Function DpadRepeat
; ---------------------------------
_DpadRepeat::
	ld	c, a
;src/input.c:10: unsigned char held = (button_state | pressed) & PADF_DPAD;
	ld	hl, _button_state
	ld	a, [hl]
	or	a, c
	and	a, $F0
	ld	b, a
;src/input.c:11: if (!held) return 0;
	or	a, a
	jp	NZ, .l00102
	xor	a, a
	jp	.l00109
.l00102:
;src/input.c:12: if (pressed & PADF_DPAD) pad_timer = PAD_REPEAT_DELAY;
	ld	a, c
	and	a, $F0
	jp	NZ,.l00126
	jp	.l00107
.l00126:
	ld	hl, _pad_timer
	ld	[hl], $14
	jp	.l00108
.l00107:
;src/input.c:13: else if (--pad_timer) return 0;
	ld	hl, _pad_timer
	dec	[hl]
	ld	a, [hl]
	or	a, a
	jp	Z, .l00104
	xor	a, a
	jp	.l00109
.l00104:
;src/input.c:14: else pad_timer = PAD_REPEAT_RATE;
	ld	hl, _pad_timer
	ld	[hl], $04
.l00108:
;src/input.c:15: return held;
	ld	a, b
.l00109:
;src/input.c:16: }
	ret
;src/input.c:20: unsigned char MenuKey(void) {
;	---------------------------------
	SECTION FRAGMENT "Page 6",ROMX,BANK[3]
	LOAD FRAGMENT "Page 6 RAM",SRAM,BANK[6]
; Function MenuKey
; ---------------------------------
_MenuKey::
;src/input.c:22: WaitFrame();
	call	_WaitFrame
;src/input.c:23: if ((key = (unsigned char)KBPopEvent())) return key;
	call	_KBPopEvent
	ld	a, c
	ld	c, a
	or	a, a
	jp	Z, .l00102
	ld	a, c
	jp	.l00117
.l00102:
;src/input.c:24: pressed = PadPressed();
	call	_PadPressed
	ld	c, a
;src/input.c:25: if (pressed & PADF_A) return KEY_ENTER;
	bit	0, c
	jp	NZ,.l00159
	jp	.l00104
.l00159:
	ld	a, $0A
	jp	.l00117
.l00104:
;src/input.c:26: if (pressed & PADF_B) return KEY_BACKSPACE;
	bit	1, c
	jp	NZ,.l00160
	jp	.l00106
.l00160:
	ld	a, $08
	jp	.l00117
.l00106:
;src/input.c:27: if (pressed & PADF_START) return KEY_MENU;
	bit	3, c
	jp	NZ,.l00161
	jp	.l00108
.l00161:
	ld	a, $89
	jp	.l00117
.l00108:
;src/input.c:28: held = DpadRepeat(pressed);
	ld	a, c
	call	_DpadRepeat
;src/input.c:29: if (held & PADF_UP) return KEY_UP;
	bit	6, a
	jp	NZ,.l00162
	jp	.l00110
.l00162:
	ld	a, $82
	jp	.l00117
.l00110:
;src/input.c:30: if (held & PADF_DOWN) return KEY_DOWN;
	bit	7, a
	jp	NZ,.l00163
	jp	.l00112
.l00163:
	ld	a, $83
	jp	.l00117
.l00112:
;src/input.c:31: if (held & PADF_LEFT) return KEY_LEFT;
	bit	5, a
	jp	NZ,.l00164
	jp	.l00114
.l00164:
	ld	a, $80
	jp	.l00117
.l00114:
;src/input.c:32: if (held & PADF_RIGHT) return KEY_RIGHT;
	bit	4, a
	jp	NZ,.l00165
	jp	.l00116
.l00165:
	ld	a, $81
	jp	.l00117
.l00116:
;src/input.c:33: return KEY_NONE;
	xor	a, a
.l00117:
;src/input.c:34: }
	ret
	SECTION FRAGMENT "Page 6",ROMX,BANK[3]
	LOAD FRAGMENT "Page 6 RAM",SRAM,BANK[6]
	SECTION FRAGMENT "_INITIALIZER",ROM0
	SECTION FRAGMENT "_CABS (ABS)",ROM0
