;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 4.2.0 #13081 (Linux)
;--------------------------------------------------------
	; MODULE paths
	; Generated using the rgbds tokens.

;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	EXPORT _SettingsSave
	EXPORT _CopyName
	EXPORT _PutText
	EXPORT _ToLatin1
	EXPORT _ToUtf8
	EXPORT _PutPath
	EXPORT _JoinPath
	EXPORT _FileMoved
;--------------------------------------------------------
; special function registers
;--------------------------------------------------------
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	SECTION FRAGMENT "src/browser/paths.c_DATA",WRAM0
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
	SECTION FRAGMENT "src/browser/paths.c_HOME",ROM0
	SECTION FRAGMENT "src/browser/paths.c_HOME",ROM0
;--------------------------------------------------------
; code
;--------------------------------------------------------
	SECTION FRAGMENT "src/browser/paths.c_CODE",ROMX
;src/browser/paths.c:8: char* ToLatin1(char* dest, const char* text, unsigned char count) {
;	---------------------------------
	SECTION FRAGMENT "src/browser/paths.c FIXED",ROMX,BANK[1]
; Function ToLatin1
; ---------------------------------
_ToLatin1::
	add	sp, -9
	ld	hl, sp+4
	ld	[hl], e
	inc	hl
	ld	[hl], d
;src/browser/paths.c:10: while ((c = *text++) && count--) {
	ld	hl, sp+11
	ld	a, [hl]
	ld	hl, sp+6
	ld	[hl], a
.l00113:
	ld	a, [bc]
	inc	bc
	ld	hl, sp+8
	ld	[hl], a
	or	a, a
	jp	Z, .l00115
	dec	hl
	dec	hl
	ld	e, [hl]
	dec	[hl]
	ld	a, e
	or	a, a
	jp	Z, .l00115
;src/browser/paths.c:11: if (c >= 0x80) {
	inc	hl
	inc	hl
	ld	a, [hl]
	sub	a, $80
	jp	C, .l00111
;src/browser/paths.c:12: next = *text;
	ld	a, [bc]
	ld	e, a
;src/browser/paths.c:13: if ((c & 0xFE) == 0xC2 && (next & 0xC0) == 0x80) { // U+0080-U+00FF
	ld	d, [hl]
	xor	a, a
	res	0, d
	ld	l, $00
;	spillPairReg hl
;	spillPairReg hl
	ld	a, d
	sub	a, $C2
	or	a, l
	jp	NZ,.l00165
	jp	.l00166
.l00165:
	jp	.l00125
.l00166:
	ld	a, e
	ld	d, $00
	and	a, $C0
	ld	l, a
;	spillPairReg hl
;	spillPairReg hl
	ld	d, $00
	ld	a, l
	sub	a, $80
	or	a, d
	jp	NZ,.l00167
	jp	.l00168
.l00167:
	jp	.l00125
.l00168:
;src/browser/paths.c:14: ++text;
	inc	bc
;src/browser/paths.c:15: c = (c << 6) | (next & 0x3F);
	ld	hl, sp+8
	ld	a, [hl]
	rrca
	rrca
	and	a, $C0
	ld	d, a
	ld	a, e
	and	a, $3F
	or	a, d
	ld	[hl], a
;src/browser/paths.c:16: if (c < 0xA0) c = '?';
	ld	a, [hl]
	sub	a, $A0
	jp	NC, .l00111
	ld	[hl], $3F
	jp	.l00111
;src/browser/paths.c:19: while ((*text & 0xC0) == 0x80) ++text;
.l00125:
	ld	hl, sp+7
	ld	[hl], c
	inc	hl
	ld	[hl], b
.l00103:
	ld	hl, sp+8
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	ld	hl, sp+3
	ld	[hl], a
	ld	a, [hl]
	ld	hl, sp+0
	ld	[hl], a
	inc	hl
	ld	[hl], $00
	dec	hl
	ld	a, [hl]
	and	a, $C0
	inc	hl
	inc	hl
	ld	[hl], a
	inc	hl
	ld	[hl], $00
	dec	hl
	ld	a, [hl]
	sub	a, $80
	inc	hl
	or	a, [hl]
	jp	NZ,.l00169
	jp	.l00170
.l00169:
	jp	.l00127
.l00170:
	ld	hl, sp+7
	inc	[hl]
	jp	NZ, .l00171
	inc	hl
	inc	[hl]
.l00171:
	jp	.l00103
.l00127:
	ld	hl, sp+7
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
;src/browser/paths.c:20: c = '?';
	ld	[hl], $3F
.l00111:
;src/browser/paths.c:23: *dest++ = c;
	ld	hl, sp+5
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, sp+8
	ld	a, [hl]
	ld	[de], a
	ld	hl, sp+4
	inc	[hl]
	jp	NZ, .l00172
	inc	hl
	inc	[hl]
.l00172:
	jp	.l00113
.l00115:
;src/browser/paths.c:25: return dest;
	ld	hl, sp+4
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
.l00116:
;src/browser/paths.c:26: }
	add	sp, 9
	pop	hl
	inc	sp
	jp hl
;src/browser/paths.c:29: void ToUtf8(char* dest, const char* text) {
;	---------------------------------
	SECTION FRAGMENT "Page 4",ROMX,BANK[2]
	LOAD FRAGMENT "Page 4 RAM",SRAM,BANK[4]
; Function ToUtf8
; ---------------------------------
_ToUtf8::
	ld	l, e
;	spillPairReg hl
;	spillPairReg hl
	ld	h, d
;	spillPairReg hl
;	spillPairReg hl
;src/browser/paths.c:31: while ((c = *text++)) {
.l00103:
	ld	a, [bc]
	inc	bc
	ld	e, a
	or	a, a
	jp	Z, .l00105
;src/browser/paths.c:32: if (c >= 0x80) {
	ld	a, e
	sub	a, $80
	jp	C, .l00102
;src/browser/paths.c:33: *dest++ = 0xC0 | (c >> 6);
	ld	a, e
	rlca
	rlca
	and	a, $03
	or	a, $C0
	ld	[hl], a
	inc	hl
;src/browser/paths.c:34: c = 0x80 | (c & 0x3F);
	ld	a, e
	and	a, $3F
	ld	e, a
	set	7, e
.l00102:
;src/browser/paths.c:36: *dest++ = c;
	ld	[hl], e
	inc	hl
	jp	.l00103
.l00105:
;src/browser/paths.c:38: *dest = 0;
	ld	[hl], $00
.l00106:
;src/browser/paths.c:39: }
	ret
;src/browser/paths.c:42: void PutPath(char* dest, const char* path, unsigned char count) {
;	---------------------------------
	SECTION FRAGMENT "Page 4",ROMX,BANK[2]
	LOAD FRAGMENT "Page 4 RAM",SRAM,BANK[4]
; Function PutPath
; ---------------------------------
_PutPath::
	add	sp, -4
	ld	hl, sp+2
	ld	[hl], e
	inc	hl
	ld	[hl], d
	inc	sp
	inc	sp
	push	bc
;src/browser/paths.c:44: while (path[length]) ++length;
	ld	e, $00
.l00101:
	push	de
	ld	d, $00
	ld	hl, sp+2
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	add	hl, de
	pop	de
	ld	c, l
	ld	b, h
	ld	a, [bc]
	or	a, a
	jp	Z, .l00103
	inc	e
	jp	.l00101
.l00103:
;src/browser/paths.c:45: if (!length) path = "/";
	ld	a, e
	or	a, a
	jp	NZ, .l00107
	ld	hl, sp+0
	ld	a, LOW(_src_browser_paths_c___str_0)
	ld	[hl], a
	inc	hl
	ld	a, HIGH(_src_browser_paths_c___str_0)
	ld	[hl], a
	jp	.l00108
.l00107:
;src/browser/paths.c:46: else if (length > count) {
	ld	hl, sp+6
	ld	a, [hl]
	sub	a, e
	jp	NC, .l00108
;src/browser/paths.c:47: dest = PutText(dest, "...");
	push	de
	ld	bc, _src_browser_paths_c___str_1
	ld	hl, sp+4
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_PutText__far
	pop	de
	ld	hl, sp+2
	ld	[hl], c
	inc	hl
	ld	[hl], b
;src/browser/paths.c:48: path += length - count;
	ld	a, e
	ld	c, $00
	ld	hl, sp+6
	ld	b, [hl]
	ld	d, $00
	sub	a, b
	ld	e, a
	ld	a, c
	sbc	a, d
	ld	d, a
	pop	hl
	push	hl
	add	hl, de
	inc	sp
	inc	sp
	push	hl
.l00108:
;src/browser/paths.c:50: *ToLatin1(dest, path, count) = 0;
	ld	hl, sp+6
	ld	a, [hl]
	push	af
	inc	sp
	ld	hl, sp+1
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	inc	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_ToLatin1
	xor	a, a
	ld	[bc], a
.l00109:
;src/browser/paths.c:51: }
	add	sp, 4
	pop	hl
	inc	sp
	jp hl
	SECTION FRAGMENT "src/browser/paths.c FIXED",ROMX,BANK[1]
_src_browser_paths_c___str_0:
	DB "/"
	DB $00
	SECTION FRAGMENT "src/browser/paths.c FIXED",ROMX,BANK[1]
_src_browser_paths_c___str_1:
	DB "..."
	DB $00
;src/browser/paths.c:54: unsigned char JoinPath(char* dest, const char* dir, const char* name, unsigned char size) {
;	---------------------------------
	SECTION FRAGMENT "Page 4",ROMX,BANK[2]
	LOAD FRAGMENT "Page 4 RAM",SRAM,BANK[4]
; Function JoinPath
; ---------------------------------
_JoinPath::
	add	sp, -6
	inc	sp
	inc	sp
	push	de
;src/browser/paths.c:55: while (*dir) {
	ld	hl, sp+10
	ld	a, [hl]
	ld	hl, sp+5
	ld	[hl], a
	pop	de
	push	de
.l00103:
	ld	a, [bc]
	ld	hl, sp+2
	ld	[hl], a
	ld	a, [hl]
	or	a, a
	jp	Z, .l00105
;src/browser/paths.c:56: if (!--size) return 0;
	ld	hl, sp+5
	dec	[hl]
	ld	a, [hl]
	ld	hl, sp+10
	ld	[hl], a
	ld	hl, sp+5
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00102
	xor	a, a
	jp	.l00113
.l00102:
;src/browser/paths.c:57: *dest++ = *dir++;
	ld	hl, sp+2
	ld	a, [hl]
	inc	bc
	ld	[de], a
	inc	de
	inc	sp
	inc	sp
	push	de
	jp	.l00103
.l00105:
;src/browser/paths.c:59: if (!--size) return 0;
	ld	hl, sp+10
	dec	[hl]
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00107
	xor	a, a
	jp	.l00113
.l00107:
;src/browser/paths.c:60: *dest++ = '/';
	pop	hl
	push	hl
	ld	[hl], $2F
	pop	de
	push	de
	ld	hl, $0001
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+5
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+4
	ld	[hl], a
;src/browser/paths.c:61: while (*name) {
	ld	hl, sp+10
	ld	a, [hl]
	dec	hl
	dec	hl
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	ld	hl, sp+3
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
.l00110:
	push	af
	ld	a, [bc]
	ld	l, a
;	spillPairReg hl
;	spillPairReg hl
	pop	af
	inc	l
	dec	l
	jp	Z, .l00112
;src/browser/paths.c:62: if (!--size) return 0;
	dec	a
	or	a, a
	jp	NZ, .l00109
	xor	a, a
	jp	.l00113
.l00109:
;src/browser/paths.c:63: *dest++ = *name++;
	push	af
	ld	a, l
	ld	hl, sp+7
	ld	[hl], a
	pop	af
	inc	bc
	push	af
	ld	a, [hl]
	ld	[de], a
	pop	af
	inc	de
	dec	hl
	dec	hl
	ld	[hl], e
	inc	hl
	ld	[hl], d
	jp	.l00110
.l00112:
;src/browser/paths.c:65: *dest = 0;
	ld	hl, sp+3
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	ld	[hl], $00
;src/browser/paths.c:66: return 1;
	ld	a, $01
.l00113:
;src/browser/paths.c:67: }
	add	sp, 6
	pop	hl
	add	sp, 3
	jp hl
;src/browser/paths.c:70: void FileMoved(const char* source, const char* destination) {
;	---------------------------------
	SECTION FRAGMENT "src/browser/paths.c FIXED",ROMX,BANK[1]
; Function FileMoved
; ---------------------------------
_FileMoved::
	ld	hl, -397
	add	hl, sp
	ld	sp, hl
	ld	hl, 395
	add	hl, sp
	ld	[hl], e
	inc	hl
	ld	[hl], d
	ld	hl, 393
	add	hl, sp
	ld	[hl], c
	inc	hl
	ld	[hl], b
;src/browser/paths.c:72: unsigned char prefix = 0, size = 0, length = 0, slash = 0;
	ld	hl, 388
	add	hl, sp
	ld	[hl], $00
;src/browser/paths.c:73: JoinPath(old, file_dir, file_name, sizeof(old));
	ld	a, $C1
	push	af
	inc	sp
	ld	de, _file_name
	push	de
	ld	bc, _file_dir
	ld	hl, 5
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_JoinPath__far
;src/browser/paths.c:74: while (source[prefix] && source[prefix] == old[prefix]) ++prefix;
	ld	c, $00
.l00102:
	ld	hl, 396
	add	hl, sp
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	l, c
	ld	h, $00
	add	hl, de
	ld	e, l
	ld	d, h
	ld	a, [de]
	ld	hl, 392
	add	hl, sp
	ld	[hl], a
	push	hl
	ld	hl, 4
	add	hl, sp
	ld	e, l
	ld	d, h
	pop	hl
	ld	l, c
	ld	h, $00
	add	hl, de
	inc	sp
	inc	sp
	push	hl
	ld	hl, 392
	add	hl, sp
	ld	a, [hl]
	or	a, a
	jp	Z, .l00142
	pop	de
	push	de
	ld	a, [de]
	ld	b, a
	ld	a, [hl]
	sub	a, b
	jp	NZ,.l00202
	jp	.l00203
.l00202:
	jp	.l00142
.l00203:
	inc	c
	jp	.l00102
.l00142:
	ld	hl, 389
	add	hl, sp
	ld	[hl], c
;src/browser/paths.c:75: if (source[prefix] || (old[prefix] && old[prefix] != '/')) return;
	ld	hl, 392
	add	hl, sp
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00105
	ld	hl, sp+0
	ld	a, [hl]
	ld	hl, 390
	add	hl, sp
	ld	[hl], a
	ld	hl, sp+1
	ld	a, [hl]
	ld	hl, 391
	add	hl, sp
	ld	[hl], a
	pop	de
	push	de
	ld	a, [de]
	or	a, a
	jp	Z, .l00134
	sub	a, $2F
	jp	NZ,.l00204
	jp	.l00134
.l00204:
.l00105:
	jp	.l00126
;src/browser/paths.c:76: while (destination[size]) ++size;
.l00134:
	ld	e, $00
.l00109:
	push	de
	ld	d, $00
	ld	hl, 395
	add	hl, sp
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	add	hl, de
	pop	de
	ld	c, l
	ld	b, h
	ld	a, [bc]
	or	a, a
	jp	Z, .l00143
	inc	e
	jp	.l00109
;src/browser/paths.c:77: while (old[prefix + length]) ++length;
.l00143:
	ld	hl, 392
	add	hl, sp
	ld	[hl], e
	ld	e, $00
.l00112:
	ld	hl, 389
	add	hl, sp
	ld	a, [hl]
	ld	d, $00
	ld	c, e
	ld	b, $00
	add	a, c
	ld	l, a
;	spillPairReg hl
;	spillPairReg hl
	ld	a, d
	adc	a, b
	ld	d, a
	push	de
	ld	e, l
	ld	hl, 4
	add	hl, sp
	add	hl, de
	pop	de
	ld	a, [hl]
	or	a, a
	jp	Z, .l00114
	inc	e
	jp	.l00112
.l00114:
;src/browser/paths.c:78: if ((unsigned int)size + length >= sizeof(target)) goto unnamed;
	ld	hl, 392
	add	hl, sp
	ld	e, [hl]
	ld	d, $00
	ld	l, c
	ld	h, b
	add	hl, de
	ld	a, l
	sub	a, $C1
	ld	a, h
	sbc	a, $00
	jp	NC, .l00122
;src/browser/paths.c:79: CopyName(PutText(target, destination), old + prefix);
	ld	hl, 390
	add	hl, sp
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	push	de
	inc	hl
	inc	hl
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	ld	hl, 197
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_PutText__far
	ld	l, c
;	spillPairReg hl
;	spillPairReg hl
	ld	h, b
;	spillPairReg hl
;	spillPairReg hl
	pop	de
	ld	c, e
	ld	b, d
	ld	e, l
	ld	d, h
	call	_CopyName__far
;src/browser/paths.c:80: for (length = 0; target[length]; ++length) if (target[length] == '/') slash = length;
	ld	b, $00
.l00124:
	ld	e, b
	ld	d, $00
	ld	hl, 195
	add	hl, sp
	add	hl, de
	ld	a, [hl]
	or	a, a
	jp	Z, .l00119
	sub	a, $2F
	jp	NZ,.l00205
	jp	.l00206
.l00205:
	jp	.l00125
.l00206:
	ld	hl, 388
	add	hl, sp
	ld	[hl], b
.l00125:
	inc	b
	jp	.l00124
.l00119:
;src/browser/paths.c:81: if (slash >= PATH_SIZE) goto unnamed;
	ld	hl, 388
	add	hl, sp
	ld	a, [hl]
	sub	a, $80
	jp	NC, .l00122
;src/browser/paths.c:82: CopyName(file_name, target + slash + 1);
	push	hl
	ld	hl, 197
	add	hl, sp
	ld	e, l
	ld	d, h
	pop	hl
	ld	hl, 388
	add	hl, sp
	ld	l, [hl]
	ld	h, $00
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, 393
	add	hl, sp
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, 392
	add	hl, sp
	ld	[hl], a
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $0001
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, 391
	add	hl, sp
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, 390
	add	hl, sp
	ld	[hl], a
	dec	hl
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	ld	de, _file_name
	call	_CopyName__far
;src/browser/paths.c:83: target[slash] = 0;
	ld	hl, 391
	add	hl, sp
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	ld	[hl], $00
;src/browser/paths.c:84: CopyName(file_dir, target);
	ld	hl, 195
	add	hl, sp
	ld	c, l
	ld	b, h
	ld	de, _file_dir
	call	_CopyName__far
;src/browser/paths.c:85: SettingsSave();
	call	_SettingsSave
;src/browser/paths.c:86: return;
	jp	.l00126
;src/browser/paths.c:87: unnamed:
.l00122:
;src/browser/paths.c:88: file_name[0] = 0; // Save As remains available if the new directory is too long
	ld	hl, _file_name
	ld	[hl], $00
;src/browser/paths.c:89: file_dir[0] = 0;
	ld	hl, _file_dir
	ld	[hl], $00
;src/browser/paths.c:90: SettingsSave();
	call	_SettingsSave
.l00126:
;src/browser/paths.c:91: }
	ld	hl, 397
	add	hl, sp
	ld	sp, hl
	ret
	SECTION FRAGMENT "src/browser/paths.c FIXED",ROMX,BANK[1]
	SECTION FRAGMENT "_INITIALIZER",ROM0
	SECTION FRAGMENT "_CABS (ABS)",ROM0
