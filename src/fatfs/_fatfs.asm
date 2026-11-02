;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 4.2.0 #13081 (Linux)
;--------------------------------------------------------
	; MODULE fatfs
	; Generated using the rgbds tokens.

;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	EXPORT _tb_Read
	EXPORT _tb_Append
	EXPORT _tb_Length
	EXPORT _tb_Clear
	EXPORT _sd_WriteSector
	EXPORT _sd_ReadSector
	EXPORT _sd_Init
	EXPORT ___memcpy
	EXPORT _memset
	EXPORT _strchr
	EXPORT _memcmp
	EXPORT _fs_crlf
	EXPORT _buffer
	EXPORT _disk_ready
	EXPORT _info
	EXPORT _dir
	EXPORT _file
	EXPORT _fs
	EXPORT _f_mount
	EXPORT _f_open
	EXPORT _f_read
	EXPORT _f_write
	EXPORT _f_sync
	EXPORT _f_close
	EXPORT _f_lseek
	EXPORT _f_opendir
	EXPORT _f_closedir
	EXPORT _f_readdir
	EXPORT _ff_uni2oem
	EXPORT _ff_oem2uni
	EXPORT _ff_wtoupper
	EXPORT __mullong
	EXPORT __divulong
	EXPORT __divuint
	EXPORT _disk_status
	EXPORT _disk_initialize
	EXPORT _disk_read
	EXPORT _disk_write
	EXPORT _disk_ioctl
	EXPORT _fs_Mount
	EXPORT _fs_OpenDir
	EXPORT _fs_NextEntry
	EXPORT _fs_Load
	EXPORT _fs_Save
;--------------------------------------------------------
; special function registers
;--------------------------------------------------------
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	SECTION FRAGMENT "src/fatfs/fatfs.c_DATA",WRAM0
_FatFs:
	DS 2
_Fsid:
	DS 2
_LfnBuf:
	DS 130
_fs:
	DS 562
_file:
	DS 34
_dir:
	DS 44
_info:
	DS 87
_disk_ready:
	DS 1
_buffer:
	DS 512
_fs_crlf:
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
	SECTION FRAGMENT "src/fatfs/fatfs.c_HOME",ROM0
;src/fatfs/lib/runtime.c:5: long _mullong(long a, long b) {
;	---------------------------------
; Function _mullong
; ---------------------------------
__mullong::
	add	sp, -12
;src/fatfs/lib/runtime.c:6: unsigned long x = a, y = b, result = 0;
	inc	sp
	inc	sp
	push	bc
	ld	hl, sp+2
	ld	[hl], e
	inc	hl
	ld	[hl], d
	ld	hl, sp+14
	ld	d, h
	ld	e, l
	ld	hl, sp+4
	ld	a, [de]
	ld	[hl+], a
	inc	de
	ld	a, [de]
	ld	[hl+], a
	inc	de
	ld	a, [de]
	ld	[hl+], a
	inc	de
	ld	a, [de]
	ld	[hl], a
	xor	a, a
	ld	hl, sp+8
	ld	[hl], a
	inc	hl
	ld	[hl], a
	inc	hl
	ld	[hl], a
	inc	hl
	ld	[hl], a
;src/fatfs/lib/runtime.c:7: while (y) {
.l00103:
	ld	hl, sp+7
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	dec	hl
	or	a, [hl]
	dec	hl
	or	a, [hl]
	jp	Z, .l00105
;src/fatfs/lib/runtime.c:8: if (y & 1) result += x;
	push	hl
	bit	0, [hl]
	pop	hl
	jp	NZ,.l00123
	jp	.l00102
.l00123:
	ld	hl, sp+9
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, e
	ld	hl, sp+0
	add	a, [hl]
	ld	e, a
	ld	a, d
	inc	hl
	adc	a, [hl]
	push	af
	ld	hl, sp+11
	ld	[hl], a
	dec	hl
	ld	[hl], e
	ld	hl, sp+13
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, sp+4
	pop	af
	ld	a, e
	adc	a, [hl]
	ld	e, a
	ld	a, d
	inc	hl
	adc	a, [hl]
	ld	hl, sp+11
	ld	[hl], a
	dec	hl
	ld	[hl], e
.l00102:
;src/fatfs/lib/runtime.c:9: x <<= 1;
	ld	hl, sp+0
	sla	[hl]
	inc	hl
	rl	[hl]
	inc	hl
	rl	[hl]
	inc	hl
	rl	[hl]
;src/fatfs/lib/runtime.c:10: y >>= 1;
	ld	hl, sp+7
	srl	[hl]
	dec	hl
	rr	[hl]
	dec	hl
	rr	[hl]
	dec	hl
	rr	[hl]
	jp	.l00103
.l00105:
;src/fatfs/lib/runtime.c:12: return result;
	ld	hl, sp+8
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	inc	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
.l00106:
;src/fatfs/lib/runtime.c:13: }
	add	sp, 12
	pop	hl
	add	sp, 4
	jp hl 
;src/fatfs/lib/runtime.c:15: unsigned long _divulong(unsigned long x, unsigned long y) {
;	---------------------------------
; Function _divulong
; ---------------------------------
__divulong::
	add	sp, -21
	ld	hl, sp+8
	ld	[hl], c
	inc	hl
	ld	[hl], b
	inc	hl
	ld	[hl], e
	inc	hl
	ld	[hl], d
;src/fatfs/lib/runtime.c:16: unsigned long quotient = 0, remainder = 0;
	xor	a, a
	inc	hl
	ld	[hl], a
	inc	hl
	ld	[hl], a
	inc	hl
	ld	[hl], a
	inc	hl
	ld	[hl], a
	xor	a, a
	inc	hl
	ld	[hl], a
	inc	hl
	ld	[hl], a
	inc	hl
	ld	[hl], a
	inc	hl
	ld	[hl], a
;src/fatfs/lib/runtime.c:18: for (i = 32; i; --i) {
	inc	hl
	ld	[hl], $20
.l00104:
;src/fatfs/lib/runtime.c:19: remainder = (remainder << 1) | (x >> 31);
	push	af
	ld	hl, sp+18
	ld	a, [hl]
	ld	hl, sp+6
	ld	[hl], a
	ld	hl, sp+19
	ld	a, [hl]
	ld	hl, sp+7
	ld	[hl], a
	ld	hl, sp+20
	ld	a, [hl]
	ld	hl, sp+8
	ld	[hl], a
	ld	hl, sp+21
	ld	a, [hl]
	ld	hl, sp+9
	ld	[hl], a
	pop	af
	ld	hl, sp+4
	sla	[hl]
	inc	hl
	rl	[hl]
	inc	hl
	rl	[hl]
	inc	hl
	rl	[hl]
	ld	hl, sp+11
	ld	a, [hl]
	ld	hl, sp+0
	ld	[hl], a
	xor	a, a
	inc	hl
	ld	[hl], a
	inc	hl
	ld	[hl], a
	inc	hl
	ld	[hl], a
	ld	a, $07
.l00126:
	ld	hl, sp+0
	srl	[hl]
.l00127:
	dec	a
	jr	NZ, .l00126
	ld	hl, sp+4
	ld	a, [hl]
	ld	hl, sp+0
	or	a, [hl]
	ld	hl, sp+16
	ld	[hl], a
	ld	hl, sp+5
	ld	a, [hl]
	ld	hl, sp+1
	or	a, [hl]
	ld	hl, sp+17
	ld	[hl], a
	ld	hl, sp+6
	ld	a, [hl]
	ld	hl, sp+2
	or	a, [hl]
	ld	hl, sp+18
	ld	[hl], a
	ld	hl, sp+7
	ld	a, [hl]
	ld	hl, sp+3
	or	a, [hl]
	ld	hl, sp+19
	ld	[hl], a
;src/fatfs/lib/runtime.c:20: x <<= 1;
	ld	hl, sp+8
	sla	[hl]
	inc	hl
	rl	[hl]
	inc	hl
	rl	[hl]
	inc	hl
	rl	[hl]
;src/fatfs/lib/runtime.c:21: quotient <<= 1;
	inc	hl
	sla	[hl]
	inc	hl
	rl	[hl]
	inc	hl
	rl	[hl]
	inc	hl
	rl	[hl]
;src/fatfs/lib/runtime.c:22: if (remainder >= y) {
	ld	hl, sp+16
	ld	e, l
	ld	d, h
	ld	hl, sp+23
	ld	a, [de]
	inc	de
	sub	a, [hl]
	inc	hl
	ld	a, [de]
	inc	de
	sbc	a, [hl]
	inc	hl
	ld	a, [de]
	inc	de
	sbc	a, [hl]
	inc	hl
	ld	a, [de]
	sbc	a, [hl]
	jp	C, .l00105
;src/fatfs/lib/runtime.c:23: remainder -= y;
	ld	hl, sp+17
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, e
	ld	hl, sp+23
	sub	a, [hl]
	ld	e, a
	ld	a, d
	inc	hl
	sbc	a, [hl]
	push	af
	ld	hl, sp+19
	ld	[hl], a
	dec	hl
	ld	[hl], e
	ld	hl, sp+21
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, sp+27
	pop	af
	ld	a, e
	sbc	a, [hl]
	ld	e, a
	ld	a, d
	inc	hl
	sbc	a, [hl]
	ld	hl, sp+19
	ld	[hl], a
	dec	hl
	ld	[hl], e
;src/fatfs/lib/runtime.c:24: quotient |= 1;
	ld	hl, sp+12
	ld	a, [hl]
	or	a, $01
	ld	[hl], a
.l00105:
;src/fatfs/lib/runtime.c:18: for (i = 32; i; --i) {
	ld	hl, sp+20
	dec	[hl]
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00104
;src/fatfs/lib/runtime.c:27: return quotient;
	ld	hl, sp+12
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	inc	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
.l00106:
;src/fatfs/lib/runtime.c:28: }
	add	sp, 21
	pop	hl
	add	sp, 4
	jp hl 
;src/fatfs/lib/runtime.c:30: unsigned int _divuint(unsigned int x, unsigned int y) {
;	---------------------------------
; Function _divuint
; ---------------------------------
__divuint::
	add	sp, -11
	ld	hl, sp+4
	ld	[hl], e
	inc	hl
	ld	[hl], d
	ld	hl, sp+2
	ld	[hl], c
	inc	hl
	ld	[hl], b
;src/fatfs/lib/runtime.c:31: unsigned int quotient = 0, remainder = 0;
	xor	a, a
	ld	hl, sp+6
	ld	[hl], a
	inc	hl
	ld	[hl], a
	xor	a, a
	inc	hl
	ld	[hl], a
	inc	hl
	ld	[hl], a
;src/fatfs/lib/runtime.c:33: for (i = 16; i; --i) {
	inc	hl
	ld	[hl], $10
.l00104:
;src/fatfs/lib/runtime.c:34: remainder = (remainder << 1) | (x >> 15);
	ld	hl, sp+8
	sla	[hl]
	inc	hl
	rl	[hl]
	ld	hl, sp+5
	ld	a, [hl]
	rlca
	and	a, $01
	ld	hl, sp+0
	ld	[hl], a
	inc	hl
	ld	[hl], $00
	ld	hl, sp+8
	ld	a, [hl]
	inc	hl
	ld	c, [hl]
	ld	hl, sp+0
	or	a, [hl]
	push	af
	ld	a, c
	inc	hl
	or	a, [hl]
	ld	c, a
	pop	af
	ld	hl, sp+8
	ld	[hl], a
	inc	hl
	ld	[hl], c
;src/fatfs/lib/runtime.c:35: x <<= 1;
	ld	hl, sp+4
	sla	[hl]
	inc	hl
	rl	[hl]
;src/fatfs/lib/runtime.c:36: quotient <<= 1;
	inc	hl
	sla	[hl]
	inc	hl
	rl	[hl]
;src/fatfs/lib/runtime.c:37: if (remainder >= y) {
	ld	hl, sp+8
	ld	e, l
	ld	d, h
	ld	hl, sp+2
	ld	a, [de]
	inc	de
	sub	a, [hl]
	inc	hl
	ld	a, [de]
	sbc	a, [hl]
	jp	C, .l00105
;src/fatfs/lib/runtime.c:38: remainder -= y;
	ld	hl, sp+9
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, sp+2
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	ld	a, e
	sub	a, l
	ld	e, a
	ld	a, d
	sbc	a, h
	ld	hl, sp+9
	ld	[hl], a
	dec	hl
	ld	[hl], e
;src/fatfs/lib/runtime.c:39: quotient |= 1;
	dec	hl
	dec	hl
	ld	a, [hl]
	or	a, $01
	ld	[hl], a
.l00105:
;src/fatfs/lib/runtime.c:33: for (i = 16; i; --i) {
	ld	hl, sp+10
	dec	[hl]
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00104
;src/fatfs/lib/runtime.c:42: return quotient;
	ld	hl, sp+6
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
.l00106:
;src/fatfs/lib/runtime.c:43: }
	add	sp, 11
	ret
	SECTION FRAGMENT "src/fatfs/fatfs.c_HOME",ROM0
;--------------------------------------------------------
; code
;--------------------------------------------------------
	SECTION FRAGMENT "src/fatfs/fatfs.c_CODE",ROMX
;src/fatfs/lib/ff.c:622: static WORD ld_16 (const BYTE* ptr)	/*	 Load a 2-byte little-endian word */
;	---------------------------------
	SECTION FRAGMENT "src/fatfs/fatfs.c ROM0",ROM0
; Function ld_16
; ---------------------------------
_ld_16:
;src/fatfs/lib/ff.c:626: rv = ptr[1];
	ld	c, e
	ld	b, d
	inc	bc
	ld	a, [bc]
	ld	c, $00
;src/fatfs/lib/ff.c:627: rv = rv << 8 | ptr[0];
	ld	b, a
	ld	c, $00
	ld	a, [de]
	ld	e, $00
	or	a, c
	ld	c, a
	ld	a, e
	or	a, b
	ld	b, a
;src/fatfs/lib/ff.c:628: return rv;
.l00101:
;src/fatfs/lib/ff.c:629: }
	ret
	SECTION FRAGMENT "src/fatfs/fatfs.c ROM0",ROM0
_LfnOfs:
	DB $01	; 1
	DB $03	; 3
	DB $05	; 5
	DB $07	; 7
	DB $09	; 9
	DB $0E	; 14
	DB $10	; 16
	DB $12	; 18
	DB $14	; 20
	DB $16	; 22
	DB $18	; 24
	DB $1C	; 28
	DB $1E	; 30
	SECTION FRAGMENT "src/fatfs/fatfs.c ROM0",ROM0
_ExCvt:
	DB $80	; 128
	DB $9A	; 154
	DB $45	; 69	'E'
	DB $41	; 65	'A'
	DB $8E	; 142
	DB $41	; 65	'A'
	DB $8F	; 143
	DB $80	; 128
	DB $45	; 69	'E'
	DB $45	; 69	'E'
	DB $45	; 69	'E'
	DB $49	; 73	'I'
	DB $49	; 73	'I'
	DB $49	; 73	'I'
	DB $8E	; 142
	DB $8F	; 143
	DB $90	; 144
	DB $92	; 146
	DB $92	; 146
	DB $4F	; 79	'O'
	DB $99	; 153
	DB $4F	; 79	'O'
	DB $55	; 85	'U'
	DB $55	; 85	'U'
	DB $59	; 89	'Y'
	DB $99	; 153
	DB $9A	; 154
	DB $9B	; 155
	DB $9C	; 156
	DB $9D	; 157
	DB $9E	; 158
	DB $9F	; 159
	DB $41	; 65	'A'
	DB $49	; 73	'I'
	DB $4F	; 79	'O'
	DB $55	; 85	'U'
	DB $A5	; 165
	DB $A5	; 165
	DB $A6	; 166
	DB $A7	; 167
	DB $A8	; 168
	DB $A9	; 169
	DB $AA	; 170
	DB $AB	; 171
	DB $AC	; 172
	DB $AD	; 173
	DB $AE	; 174
	DB $AF	; 175
	DB $B0	; 176
	DB $B1	; 177
	DB $B2	; 178
	DB $B3	; 179
	DB $B4	; 180
	DB $B5	; 181
	DB $B6	; 182
	DB $B7	; 183
	DB $B8	; 184
	DB $B9	; 185
	DB $BA	; 186
	DB $BB	; 187
	DB $BC	; 188
	DB $BD	; 189
	DB $BE	; 190
	DB $BF	; 191
	DB $C0	; 192
	DB $C1	; 193
	DB $C2	; 194
	DB $C3	; 195
	DB $C4	; 196
	DB $C5	; 197
	DB $C6	; 198
	DB $C7	; 199
	DB $C8	; 200
	DB $C9	; 201
	DB $CA	; 202
	DB $CB	; 203
	DB $CC	; 204
	DB $CD	; 205
	DB $CE	; 206
	DB $CF	; 207
	DB $D0	; 208
	DB $D1	; 209
	DB $D2	; 210
	DB $D3	; 211
	DB $D4	; 212
	DB $D5	; 213
	DB $D6	; 214
	DB $D7	; 215
	DB $D8	; 216
	DB $D9	; 217
	DB $DA	; 218
	DB $DB	; 219
	DB $DC	; 220
	DB $DD	; 221
	DB $DE	; 222
	DB $DF	; 223
	DB $E0	; 224
	DB $E1	; 225
	DB $E2	; 226
	DB $E3	; 227
	DB $E4	; 228
	DB $E5	; 229
	DB $E6	; 230
	DB $E7	; 231
	DB $E8	; 232
	DB $E9	; 233
	DB $EA	; 234
	DB $EB	; 235
	DB $EC	; 236
	DB $ED	; 237
	DB $EE	; 238
	DB $EF	; 239
	DB $F0	; 240
	DB $F1	; 241
	DB $F2	; 242
	DB $F3	; 243
	DB $F4	; 244
	DB $F5	; 245
	DB $F6	; 246
	DB $F7	; 247
	DB $F8	; 248
	DB $F9	; 249
	DB $FA	; 250
	DB $FB	; 251
	DB $FC	; 252
	DB $FD	; 253
	DB $FE	; 254
	DB $FF	; 255
;src/fatfs/lib/ff.c:631: static DWORD ld_32 (const BYTE* ptr)	/* Load a 4-byte little-endian word */
;	---------------------------------
	SECTION FRAGMENT "src/fatfs/fatfs.c ROM0",ROM0
; Function ld_32
; ---------------------------------
_ld_32:
	add	sp, -6
	ld	hl, sp+4
	ld	[hl], e
	inc	hl
	ld	[hl], d
;src/fatfs/lib/ff.c:635: rv = ptr[3];
	dec	hl
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	inc	bc
	inc	bc
	inc	bc
	ld	a, [bc]
	ld	c, a
	ld	b, $00
	ld	de, $0000
;src/fatfs/lib/ff.c:636: rv = rv << 8 | ptr[2];
	ld	d, e
	ld	e, b
	ld	b, c
	ld	c, $00
	inc	sp
	inc	sp
	push	bc
	ld	hl, sp+2
	ld	[hl], e
	inc	hl
	ld	[hl], d
	inc	hl
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	inc	bc
	inc	bc
	ld	a, [bc]
	ld	e, a
	ld	d, $00
	ld	bc, $0000
	ld	hl, sp+0
	ld	a, [hl]
	or	a, e
	ld	e, a
	inc	hl
	ld	a, [hl]
	or	a, d
	ld	d, a
	inc	hl
	ld	a, [hl]
	or	a, c
	ld	c, a
	inc	hl
	ld	a, [hl]
	or	a, b
;src/fatfs/lib/ff.c:637: rv = rv << 8 | ptr[1];
	ld	a, c
	ld	c, d
	ld	d, e
	ld	e, $00
	inc	sp
	inc	sp
	push	de
	dec	hl
	ld	[hl], c
	inc	hl
	ld	[hl], a
	inc	hl
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	inc	bc
	ld	a, [bc]
	ld	c, a
	ld	b, $00
	ld	de, $0000
	ld	hl, sp+0
	ld	a, [hl]
	or	a, c
	ld	c, a
	inc	hl
	ld	a, [hl]
	or	a, b
	ld	b, a
	inc	hl
	ld	a, [hl]
	or	a, e
	ld	e, a
	inc	hl
	ld	a, [hl]
	or	a, d
	ld	d, a
;src/fatfs/lib/ff.c:638: rv = rv << 8 | ptr[0];
	ld	d, e
	ld	e, b
	ld	b, c
	ld	c, $00
	inc	sp
	inc	sp
	push	bc
	dec	hl
	ld	[hl], e
	inc	hl
	ld	[hl], d
	inc	hl
	inc	hl
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	ld	c, a
	ld	b, $00
	ld	de, $0000
	ld	hl, sp+0
	ld	a, [hl]
	or	a, c
	ld	c, a
	inc	hl
	ld	a, [hl]
	or	a, b
	ld	b, a
	inc	hl
	ld	a, [hl]
	or	a, e
	ld	e, a
	inc	hl
	ld	a, [hl]
	or	a, d
	ld	l, a
;	spillPairReg hl
;	spillPairReg hl
;src/fatfs/lib/ff.c:639: return rv;
	ld	d, l
.l00101:
;src/fatfs/lib/ff.c:640: }
	add	sp, 6
	ret
;src/fatfs/lib/ff.c:660: static void st_16 (BYTE* ptr, WORD val)	/* Store a 2-byte word in little-endian */
;	---------------------------------
	SECTION FRAGMENT "src/fatfs/fatfs.c ROM0",ROM0
; Function st_16
; ---------------------------------
_st_16:
;src/fatfs/lib/ff.c:662: *ptr++ = (BYTE)val; val >>= 8;
	ld	a, c
	ld	[de], a
	inc	de
	ld	c, $00
;src/fatfs/lib/ff.c:663: *ptr++ = (BYTE)val;
	ld	a, b
	ld	[de], a
.l00101:
;src/fatfs/lib/ff.c:664: }
	ret
;src/fatfs/lib/ff.c:666: static void st_32 (BYTE* ptr, DWORD val)	/* Store a 4-byte word in little-endian */
;	---------------------------------
	SECTION FRAGMENT "src/fatfs/fatfs.c ROM0",ROM0
; Function st_32
; ---------------------------------
_st_32:
;src/fatfs/lib/ff.c:668: *ptr++ = (BYTE)val; val >>= 8;
	ld	hl, sp+2
	ld	a, [hl]
	ld	[de], a
	inc	de
	ld	a, $08
.l00103:
	ld	hl, sp+5
	srl	[hl]
	dec	hl
	rr	[hl]
	dec	hl
	rr	[hl]
	dec	hl
	rr	[hl]
.l00104:
	dec	a
	jr	NZ, .l00103
;src/fatfs/lib/ff.c:669: *ptr++ = (BYTE)val; val >>= 8;
	ld	a, [hl]
	ld	[de], a
	inc	de
	ld	a, $08
.l00105:
	ld	hl, sp+5
	srl	[hl]
	dec	hl
	rr	[hl]
	dec	hl
	rr	[hl]
	dec	hl
	rr	[hl]
.l00106:
	dec	a
	jr	NZ, .l00105
;src/fatfs/lib/ff.c:670: *ptr++ = (BYTE)val; val >>= 8;
	ld	a, [hl]
	ld	[de], a
	inc	de
	ld	a, $08
.l00107:
	ld	hl, sp+5
	srl	[hl]
	dec	hl
	rr	[hl]
	dec	hl
	rr	[hl]
	dec	hl
	rr	[hl]
.l00108:
	dec	a
	jr	NZ, .l00107
;src/fatfs/lib/ff.c:671: *ptr++ = (BYTE)val;
	ld	a, [hl]
	ld	[de], a
.l00101:
;src/fatfs/lib/ff.c:672: }
	pop	hl
	add	sp, 4
	jp hl 
;src/fatfs/lib/ff.c:696: static int dbc_1st (BYTE c)
;	---------------------------------
	SECTION FRAGMENT "src/fatfs/fatfs.c ROM0",ROM0
; Function dbc_1st
; ---------------------------------
_dbc_1st:
	ld	c, a
;src/fatfs/lib/ff.c:709: if (c != 0) return 0;	/* Always false */
	ld	a, c
	or	a, a
	jp	Z, .l00102
	ld	bc, $0000
	jp	.l00103
.l00102:
;src/fatfs/lib/ff.c:711: return 0;
	ld	bc, $0000
.l00103:
;src/fatfs/lib/ff.c:712: }
	ret
;src/fatfs/lib/ff.c:716: static int dbc_2nd (BYTE c)
;	---------------------------------
	SECTION FRAGMENT "src/fatfs/fatfs.c ROM0",ROM0
; Function dbc_2nd
; ---------------------------------
_dbc_2nd:
	ld	c, a
;src/fatfs/lib/ff.c:731: if (c != 0) return 0;	/* Always false */
	ld	a, c
	or	a, a
	jp	Z, .l00102
	ld	bc, $0000
	jp	.l00103
.l00102:
;src/fatfs/lib/ff.c:733: return 0;
	ld	bc, $0000
.l00103:
;src/fatfs/lib/ff.c:734: }
	ret
;src/fatfs/lib/ff.c:740: static DWORD tchar2uni (	/* Returns a character in UTF-16 encoding (>=0x10000 on surrogate pair, 0xFFFFFFFF on decode error) */
;	---------------------------------
	SECTION FRAGMENT "src/fatfs/fatfs.c C",ROMX
; Function tchar2uni
; ---------------------------------
_tchar2uni:
	add	sp, -14
	ld	hl, sp+6
	ld	[hl], e
	inc	hl
	ld	[hl], d
;src/fatfs/lib/ff.c:745: const TCHAR *p = *str;
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	ld	c, a
	inc	de
	ld	a, [de]
	ld	b, a
;src/fatfs/lib/ff.c:761: uc = (BYTE)*p++;	/* Get an encoding unit */
	ld	a, [bc]
	ld	e, a
	inc	bc
	inc	sp
	inc	sp
	push	bc
	inc	hl
	ld	[hl], e
	xor	a, a
	inc	hl
	ld	[hl], a
	inc	hl
	ld	[hl], a
	inc	hl
	ld	[hl], a
;src/fatfs/lib/ff.c:762: if (uc & 0x80) {	/* Multiple byte code? */
	push	hl
	ld	hl, sp+10
	bit	7, [hl]
	pop	hl
	jp	NZ,.l00176
	jp	.l00123
.l00176:
;src/fatfs/lib/ff.c:763: if        ((uc & 0xE0) == 0xC0) {	/* 2-byte sequence? */
	ld	hl, sp+8
	ld	a, [hl]
	and	a, $E0
	ld	c, a
	ld	b, $00
	ld	de, $0000
	ld	a, c
	sub	a, $C0
	or	a, b
	or	a, e
	or	a, d
	jp	NZ,.l00177
	jp	.l00178
.l00177:
	jp	.l00108
.l00178:
;src/fatfs/lib/ff.c:764: uc &= 0x1F; nf = 1;
	ld	a, [hl]
	and	a, $1F
	ld	[hl], a
	xor	a, a
	inc	hl
	ld	[hl], a
	inc	hl
	ld	[hl], a
	inc	hl
	ld	[hl], a
	ld	bc, $0001
	jp	.l00131
.l00108:
;src/fatfs/lib/ff.c:765: } else if ((uc & 0xF0) == 0xE0) {	/* 3-byte sequence? */
	ld	hl, sp+8
	ld	a, [hl]
	and	a, $F0
	ld	c, a
	ld	b, $00
	ld	de, $0000
	ld	a, c
	sub	a, $E0
	or	a, b
	or	a, e
	or	a, d
	jp	NZ,.l00179
	jp	.l00180
.l00179:
	jp	.l00105
.l00180:
;src/fatfs/lib/ff.c:766: uc &= 0x0F; nf = 2;
	ld	a, [hl]
	and	a, $0F
	ld	[hl], a
	xor	a, a
	inc	hl
	ld	[hl], a
	inc	hl
	ld	[hl], a
	inc	hl
	ld	[hl], a
	ld	bc, $0002
	jp	.l00131
.l00105:
;src/fatfs/lib/ff.c:767: } else if ((uc & 0xF8) == 0xF0) {	/* 4-byte sequence? */
	ld	hl, sp+8
	ld	a, [hl]
	and	a, $F8
	ld	c, a
	ld	b, $00
	ld	de, $0000
	ld	a, c
	sub	a, $F0
	or	a, b
	or	a, e
	or	a, d
	jp	NZ,.l00181
	jp	.l00182
.l00181:
	jp	.l00102
.l00182:
;src/fatfs/lib/ff.c:768: uc &= 0x07; nf = 3;
	ld	a, [hl]
	and	a, $07
	ld	[hl], a
	xor	a, a
	inc	hl
	ld	[hl], a
	inc	hl
	ld	[hl], a
	inc	hl
	ld	[hl], a
	ld	bc, $0003
	jp	.l00131
.l00102:
;src/fatfs/lib/ff.c:770: return 0xFFFFFFFF;
	ld	bc, $FFFF
	ld	de, $FFFF
	jp	.l00124
;src/fatfs/lib/ff.c:772: do {	/* Get and merge trailing bytes */
.l00131:
	ld	hl, sp+12
	ld	[hl], c
	inc	hl
	ld	[hl], b
	pop	bc
	push	bc
.l00112:
;src/fatfs/lib/ff.c:773: tb = (BYTE)*p++;
	ld	a, [bc]
	inc	bc
	inc	sp
	inc	sp
	push	bc
;src/fatfs/lib/ff.c:774: if ((tb & 0xC0) != 0x80) return 0xFFFFFFFF;	/* Wrong sequence? */
	ld	e, a
	ld	d, $00
	ld	a, e
	and	a, $C0
	ld	l, a
;	spillPairReg hl
;	spillPairReg hl
	ld	h, $00
;	spillPairReg hl
;	spillPairReg hl
	ld	a, l
	sub	a, $80
	or	a, h
	jp	NZ,.l00183
	jp	.l00111
.l00183:
	ld	bc, $FFFF
	ld	de, $FFFF
	jp	.l00124
.l00111:
;src/fatfs/lib/ff.c:775: uc = uc << 6 | (tb & 0x3F);
	push	af
	ld	hl, sp+10
	ld	a, [hl]
	ld	hl, sp+4
	ld	[hl], a
	ld	hl, sp+11
	ld	a, [hl]
	ld	hl, sp+5
	ld	[hl], a
	ld	hl, sp+12
	ld	a, [hl]
	ld	hl, sp+6
	ld	[hl], a
	ld	hl, sp+13
	ld	a, [hl]
	ld	hl, sp+7
	ld	[hl], a
	pop	af
	ld	a, $06
.l00184:
	ld	hl, sp+2
	sla	[hl]
	inc	hl
	rl	[hl]
	inc	hl
	rl	[hl]
	inc	hl
	rl	[hl]
.l00185:
	dec	a
	jr	NZ,.l00184
	ld	a, e
	and	a, $3F
	ld	e, a
	ld	d, $00
	ld	l, e
;	spillPairReg hl
;	spillPairReg hl
	ld	a, d
	ld	h, a
;	spillPairReg hl
;	spillPairReg hl
	rlca
	sbc	a, a
	ld	e, a
	ld	d, a
	push	hl
	ld	hl, sp+4
	ld	a, [hl]
	pop	hl
	or	a, l
	push	hl
	ld	hl, sp+10
	ld	[hl], a
	pop	hl
	push	hl
	ld	hl, sp+5
	ld	a, [hl]
	pop	hl
	or	a, h
	ld	hl, sp+9
	ld	[hl], a
	ld	hl, sp+4
	ld	a, [hl]
	or	a, e
	ld	hl, sp+10
	ld	[hl], a
	ld	hl, sp+5
	ld	a, [hl]
	or	a, d
	ld	hl, sp+11
	ld	[hl], a
;src/fatfs/lib/ff.c:776: } while (--nf != 0);
	inc	hl
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
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	jp	NZ, .l00112
;src/fatfs/lib/ff.c:777: if (uc < 0x80 || IsSurrogate(uc) || uc >= 0x110000) return 0xFFFFFFFF;	/* Wrong code? */
	ld	hl, sp+8
	ld	a, [hl]
	sub	a, $80
	inc	hl
	ld	a, [hl]
	sbc	a, $00
	inc	hl
	ld	a, [hl]
	sbc	a, $00
	inc	hl
	ld	a, [hl]
	sbc	a, $00
	jp	C, .l00115
	ld	hl, sp+8
	ld	a, [hl]
	sub	a, $00
	inc	hl
	ld	a, [hl]
	sbc	a, $D8
	inc	hl
	ld	a, [hl]
	sbc	a, $00
	inc	hl
	ld	a, [hl]
	sbc	a, $00
	jp	C, .l00119
	ld	hl, sp+8
	ld	a, $FF
	sub	a, [hl]
	inc	hl
	ld	a, $DF
	sbc	a, [hl]
	inc	hl
	ld	a, $00
	sbc	a, [hl]
	inc	hl
	ld	a, $00
	sbc	a, [hl]
	jp	NC, .l00115
.l00119:
	ld	hl, sp+8
	ld	a, [hl]
	sub	a, $00
	inc	hl
	ld	a, [hl]
	sbc	a, $00
	inc	hl
	ld	a, [hl]
	sbc	a, $11
	inc	hl
	ld	a, [hl]
	sbc	a, $00
	jp	C, .l00116
.l00115:
	ld	bc, $FFFF
	ld	de, $FFFF
	jp	.l00124
.l00116:
;src/fatfs/lib/ff.c:778: if (uc >= 0x010000) uc = 0xD800DC00 | ((uc - 0x10000) << 6 & 0x3FF0000) | (uc & 0x3FF);	/* Make a surrogate pair if needed */
	ld	hl, sp+8
	ld	a, [hl]
	sub	a, $00
	inc	hl
	ld	a, [hl]
	sbc	a, $00
	inc	hl
	ld	a, [hl]
	sbc	a, $01
	inc	hl
	ld	a, [hl]
	sbc	a, $00
	jp	C, .l00123
	dec	hl
	dec	hl
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, e
	sub	a, $00
	ld	e, a
	ld	a, d
	sbc	a, $00
	push	af
	ld	hl, sp+5
	ld	[hl], a
	dec	hl
	ld	[hl], e
	ld	hl, sp+13
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	pop	af
	ld	a, e
	sbc	a, $01
	ld	e, a
	ld	a, d
	sbc	a, $00
	ld	hl, sp+5
	ld	[hl], a
	dec	hl
	ld	[hl], e
	pop	hl
	pop	bc
	push	bc
	push	hl
	ld	hl, sp+4
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, $06
.l00186:
	sla	c
	rl	b
	rl	e
	rl	d
.l00187:
	dec	a
	jr	NZ,.l00186
	ld	bc, $0000
	ld	a, d
	and	a, $03
	ld	d, a
	ld	hl, sp+2
	ld	[hl], c
	ld	a, b
	or	a, $DC
	inc	hl
	ld	[hl], a
	inc	hl
	ld	[hl], e
	ld	a, d
	or	a, $D8
	inc	hl
	ld	[hl], a
	ld	hl, sp+8
	ld	l, [hl]
;	spillPairReg hl
;	spillPairReg hl
	push	hl
	ld	hl, sp+11
	ld	a, [hl]
	pop	hl
	and	a, $03
	ld	h, a
;	spillPairReg hl
;	spillPairReg hl
	ld	bc, $0000
	push	hl
	ld	hl, sp+4
	ld	a, [hl]
	pop	hl
	or	a, l
	ld	e, a
	push	hl
	ld	hl, sp+5
	ld	a, [hl]
	pop	hl
	or	a, h
	ld	d, a
	ld	hl, sp+4
	ld	a, [hl]
	or	a, c
	ld	c, a
	inc	hl
	ld	a, [hl]
	or	a, b
	ld	b, a
	ld	hl, sp+8
	ld	[hl], e
	inc	hl
	ld	[hl], d
	inc	hl
	ld	[hl], c
	inc	hl
	ld	[hl], b
.l00123:
;src/fatfs/lib/ff.c:803: *str = p;	/* Next read pointer */
	ld	hl, sp+7
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, sp+0
	ld	a, [hl]
	ld	[de], a
	inc	de
	inc	hl
	ld	a, [hl]
	ld	[de], a
;src/fatfs/lib/ff.c:804: return uc;
	ld	hl, sp+8
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	inc	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
.l00124:
;src/fatfs/lib/ff.c:805: }
	add	sp, 14
	ret
;src/fatfs/lib/ff.c:809: static UINT put_utf (	/* Returns number of encoding units written (0:buffer overflow or wrong encoding) */
;	---------------------------------
	SECTION FRAGMENT "src/fatfs/fatfs.c C",ROMX
; Function put_utf
; ---------------------------------
_put_utf:
	add	sp, -21
	inc	sp
	inc	sp
	push	bc
	ld	hl, sp+2
	ld	[hl], e
	inc	hl
	ld	[hl], d
;src/fatfs/lib/ff.c:835: *buf = (TCHAR)chr;
	ld	hl, sp+23
	ld	a, [hl]
	ld	hl, sp+8
	ld	[hl], a
	ld	hl, sp+24
	ld	a, [hl]
	ld	hl, sp+9
	ld	[hl], a
;src/fatfs/lib/ff.c:833: if (chr < 0x80) {	/* Single byte code? */
	ld	hl, sp+0
	ld	a, [hl]
	sub	a, $80
	inc	hl
	ld	a, [hl]
	sbc	a, $00
	inc	hl
	ld	a, [hl]
	sbc	a, $00
	inc	hl
	ld	a, [hl]
	sbc	a, $00
	jp	NC, .l00104
;src/fatfs/lib/ff.c:834: if (szb < 1) return 0;	/* Buffer overflow? */
	ld	hl, sp+25
	ld	a, [hl]
	sub	a, $01
	inc	hl
	ld	a, [hl]
	sbc	a, $00
	jp	NC, .l00102
	ld	bc, $0000
	jp	.l00120
.l00102:
;src/fatfs/lib/ff.c:835: *buf = (TCHAR)chr;
	ld	hl, sp+0
	ld	c, [hl]
	ld	hl, sp+8
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	ld	[hl], c
;src/fatfs/lib/ff.c:836: return 1;
	ld	bc, $0001
	jp	.l00120
.l00104:
;src/fatfs/lib/ff.c:840: *buf++ = (TCHAR)(0xC0 | (chr >> 6 & 0x1F));
	pop	bc
	push	bc
	ld	hl, sp+9
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $0001
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+12
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+11
	ld	[hl], a
	ld	a, $06
.l00167:
	srl	b
	rr	c
	dec	a
	jp	NZ, .l00167
	ld	hl, sp+16
	ld	[hl], c
;src/fatfs/lib/ff.c:838: if (chr < 0x800) {	/* 2-byte sequence? */
	ld	hl, sp+0
	ld	a, [hl]
	sub	a, $00
	inc	hl
	ld	a, [hl]
	sbc	a, $08
	inc	hl
	ld	a, [hl]
	sbc	a, $00
	inc	hl
	ld	a, [hl]
	sbc	a, $00
	jp	NC, .l00108
;src/fatfs/lib/ff.c:839: if (szb < 2) return 0;	/* Buffer overflow? */
	ld	hl, sp+25
	ld	a, [hl]
	sub	a, $02
	inc	hl
	ld	a, [hl]
	sbc	a, $00
	jp	NC, .l00106
	ld	bc, $0000
	jp	.l00120
.l00106:
;src/fatfs/lib/ff.c:840: *buf++ = (TCHAR)(0xC0 | (chr >> 6 & 0x1F));
	ld	hl, sp+16
	ld	a, [hl]
	and	a, $1F
	or	a, $C0
	ld	c, a
	ld	hl, sp+8
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	ld	[hl], c
	ld	hl, sp+10
	ld	a, [hl]
	ld	hl, sp+23
	ld	[hl], a
	ld	hl, sp+11
	ld	a, [hl]
	ld	hl, sp+24
	ld	[hl], a
;src/fatfs/lib/ff.c:841: *buf++ = (TCHAR)(0x80 | (chr >> 0 & 0x3F));
	dec	hl
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	ld	hl, sp+0
	ld	a, [hl]
	and	a, $3F
	set	7, a
	ld	[bc], a
;src/fatfs/lib/ff.c:842: return 2;
	ld	bc, $0002
	jp	.l00120
.l00108:
;src/fatfs/lib/ff.c:844: if (chr < 0x10000) {	/* 3-byte sequence? */
	ld	hl, sp+0
	ld	a, [hl]
	sub	a, $00
	inc	hl
	ld	a, [hl]
	sbc	a, $00
	inc	hl
	ld	a, [hl]
	sbc	a, $01
	inc	hl
	ld	a, [hl]
	sbc	a, $00
	jp	NC, .l00114
;src/fatfs/lib/ff.c:845: if (szb < 3 || IsSurrogate(chr)) return 0;	/* Buffer overflow or wrong code? */
	ld	hl, sp+25
	ld	a, [hl]
	sub	a, $03
	inc	hl
	ld	a, [hl]
	sbc	a, $00
	jp	C, .l00109
	ld	hl, sp+0
	ld	a, [hl]
	sub	a, $00
	inc	hl
	ld	a, [hl]
	sbc	a, $D8
	inc	hl
	ld	a, [hl]
	sbc	a, $00
	inc	hl
	ld	a, [hl]
	sbc	a, $00
	jp	C, .l00110
	ld	hl, sp+0
	ld	a, $FF
	sub	a, [hl]
	inc	hl
	ld	a, $DF
	sbc	a, [hl]
	inc	hl
	ld	a, $00
	sbc	a, [hl]
	inc	hl
	ld	a, $00
	sbc	a, [hl]
	jp	C, .l00110
.l00109:
	ld	bc, $0000
	jp	.l00120
.l00110:
;src/fatfs/lib/ff.c:846: *buf++ = (TCHAR)(0xE0 | (chr >> 12 & 0x0F));
	ld	hl, sp+1
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	inc	hl
	ld	e, [hl]
	ld	d, $00
	ld	a, $04
.l00168:
	srl	e
	rr	b
	rr	c
.l00169:
	dec	a
	jr	NZ, .l00168
	ld	a, c
	and	a, $0F
	or	a, $E0
	ld	c, a
	ld	hl, sp+8
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	ld	[hl], c
	ld	hl, sp+10
	ld	a, [hl]
	ld	hl, sp+23
	ld	[hl], a
	ld	hl, sp+11
	ld	a, [hl]
	ld	hl, sp+24
	ld	[hl], a
;src/fatfs/lib/ff.c:847: *buf++ = (TCHAR)(0x80 | (chr >> 6 & 0x3F));
	dec	hl
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	ld	hl, sp+16
	ld	a, [hl]
	and	a, $3F
	set	7, a
	ld	[bc], a
	inc	bc
	ld	hl, sp+23
	ld	[hl], c
	inc	hl
	ld	[hl], b
;src/fatfs/lib/ff.c:848: *buf++ = (TCHAR)(0x80 | (chr >> 0 & 0x3F));
	dec	hl
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	ld	hl, sp+0
	ld	a, [hl]
	and	a, $3F
	set	7, a
	ld	[bc], a
;src/fatfs/lib/ff.c:849: return 3;
	ld	bc, $0003
	jp	.l00120
.l00114:
;src/fatfs/lib/ff.c:852: if (szb < 4) return 0;	/* Buffer overflow? */
	ld	hl, sp+25
	ld	a, [hl]
	sub	a, $04
	inc	hl
	ld	a, [hl]
	sbc	a, $00
	jp	NC, .l00116
	ld	bc, $0000
	jp	.l00120
.l00116:
;src/fatfs/lib/ff.c:853: hc = ((chr & 0xFFFF0000) - 0xD8000000) >> 6;	/* Get high 10 bits */
	xor	a, a
	ld	hl, sp+4
	ld	[hl], a
	inc	hl
	ld	[hl], a
	ld	hl, sp+2
	ld	a, [hl]
	ld	hl, sp+6
	ld	[hl], a
	ld	hl, sp+3
	ld	a, [hl]
	ld	hl, sp+7
	ld	[hl], a
	dec	hl
	dec	hl
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, e
	sub	a, $00
	ld	e, a
	ld	a, d
	sbc	a, $00
	push	af
	ld	hl, sp+16
	ld	[hl], a
	dec	hl
	ld	[hl], e
	ld	hl, sp+9
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	pop	af
	ld	a, e
	sbc	a, $00
	ld	e, a
	ld	a, d
	sbc	a, $D8
	ld	hl, sp+16
	ld	[hl], a
	dec	hl
	ld	[hl], e
	ld	a, $06
.l00170:
	ld	hl, sp+16
	srl	[hl]
	dec	hl
	rr	[hl]
	dec	hl
	rr	[hl]
	dec	hl
	rr	[hl]
.l00171:
	dec	a
	jr	NZ, .l00170
;src/fatfs/lib/ff.c:854: chr = (chr & 0xFFFF) - 0xDC00;					/* Get low 10 bits */
	ld	hl, sp+0
	ld	a, [hl]
	ld	hl, sp+4
	ld	[hl], a
	ld	hl, sp+1
	ld	a, [hl]
	ld	hl, sp+5
	ld	[hl], a
	xor	a, a
	inc	hl
	ld	[hl], a
	inc	hl
	ld	[hl], a
	dec	hl
	dec	hl
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, e
	sub	a, $00
	ld	e, a
	ld	a, d
	sbc	a, $DC
	push	af
	ld	hl, sp+20
	ld	[hl], a
	dec	hl
	ld	[hl], e
	ld	hl, sp+9
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	pop	af
	ld	a, e
	sbc	a, $00
	ld	e, a
	ld	a, d
	sbc	a, $00
	ld	hl, sp+20
	ld	[hl], a
	dec	hl
	ld	[hl], e
;src/fatfs/lib/ff.c:855: if (hc >= 0x100000 || chr >= 0x400) return 0;	/* Wrong surrogate? */
	ld	hl, sp+13
	ld	a, [hl]
	sub	a, $00
	inc	hl
	ld	a, [hl]
	sbc	a, $00
	inc	hl
	ld	a, [hl]
	sbc	a, $10
	inc	hl
	ld	a, [hl]
	sbc	a, $00
	jp	NC, .l00117
	inc	hl
	ld	a, [hl]
	sub	a, $00
	inc	hl
	ld	a, [hl]
	sbc	a, $04
	inc	hl
	ld	a, [hl]
	sbc	a, $00
	inc	hl
	ld	a, [hl]
	sbc	a, $00
	jp	C, .l00118
.l00117:
	ld	bc, $0000
	jp	.l00120
.l00118:
;src/fatfs/lib/ff.c:856: chr = (hc | chr) + 0x10000;
	ld	hl, sp+13
	ld	a, [hl]
	ld	hl, sp+17
	or	a, [hl]
	ld	hl, sp+4
	ld	[hl], a
	ld	hl, sp+14
	ld	a, [hl]
	ld	hl, sp+18
	or	a, [hl]
	ld	hl, sp+5
	ld	[hl], a
	ld	hl, sp+15
	ld	a, [hl]
	ld	hl, sp+19
	or	a, [hl]
	ld	hl, sp+6
	ld	[hl], a
	ld	hl, sp+16
	ld	a, [hl]
	ld	hl, sp+20
	or	a, [hl]
	ld	hl, sp+7
	ld	[hl], a
	dec	hl
	dec	hl
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, e
	add	a, $00
	ld	e, a
	ld	a, d
	adc	a, $00
	push	af
	ld	hl, sp+15
	ld	[hl], a
	dec	hl
	ld	[hl], e
	ld	hl, sp+9
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	pop	af
	ld	a, e
	adc	a, $01
	ld	e, a
	ld	a, d
	adc	a, $00
	ld	hl, sp+15
	ld	[hl], a
	dec	hl
	ld	[hl], e
;src/fatfs/lib/ff.c:857: *buf++ = (TCHAR)(0xF0 | (chr >> 18 & 0x07));
	ld	a, [hl]
	ld	hl, sp+4
	ld	[hl], a
	ld	hl, sp+15
	ld	a, [hl]
	ld	hl, sp+5
	ld	[hl], a
	xor	a, a
	inc	hl
	ld	[hl], a
	inc	hl
	ld	[hl], a
	ld	a, $02
.l00172:
	ld	hl, sp+5
	srl	[hl]
	dec	hl
	rr	[hl]
.l00173:
	dec	a
	jr	NZ, .l00172
	ld	a, [hl]
	ld	hl, sp+16
	ld	[hl], a
	ld	a, [hl]
	and	a, $07
	ld	[hl], a
	ld	a, [hl]
	or	a, $F0
	ld	hl, sp+8
	push	af
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	pop	af
	ld	[hl], a
	ld	hl, sp+10
	ld	a, [hl]
	ld	hl, sp+23
	ld	[hl], a
	ld	hl, sp+11
	ld	a, [hl]
	ld	hl, sp+24
	ld	[hl], a
;src/fatfs/lib/ff.c:858: *buf++ = (TCHAR)(0x80 | (chr >> 12 & 0x3F));
	dec	hl
	ld	a, [hl]
	ld	hl, sp+10
	ld	[hl], a
	ld	hl, sp+24
	ld	a, [hl]
	ld	hl, sp+11
	ld	[hl], a
	inc	hl
	inc	hl
	ld	a, [hl]
	ld	hl, sp+6
	ld	[hl], a
	ld	hl, sp+14
	ld	a, [hl]
	ld	hl, sp+7
	ld	[hl], a
	ld	hl, sp+15
	ld	a, [hl]
	ld	hl, sp+8
	ld	[hl], a
	inc	hl
	ld	[hl], $00
	ld	a, $04
.l00174:
	ld	hl, sp+8
	srl	[hl]
	dec	hl
	rr	[hl]
	dec	hl
	rr	[hl]
.l00175:
	dec	a
	jr	NZ, .l00174
	ld	a, [hl]
	ld	hl, sp+16
	ld	[hl], a
	ld	a, [hl]
	and	a, $3F
	ld	[hl], a
	ld	c, [hl]
	set	7, c
	ld	hl, sp+10
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	ld	[hl], c
	ld	hl, sp+11
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $0001
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+25
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+24
	ld	[hl], a
;src/fatfs/lib/ff.c:859: *buf++ = (TCHAR)(0x80 | (chr >> 6 & 0x3F));
	dec	hl
	ld	a, [hl]
	ld	hl, sp+10
	ld	[hl], a
	ld	hl, sp+24
	ld	a, [hl]
	ld	hl, sp+11
	ld	[hl], a
	inc	hl
	ld	a, [hl]
	ld	hl, sp+8
	ld	[hl], a
	ld	hl, sp+13
	ld	a, [hl]
	ld	hl, sp+9
	ld	[hl], a
	ld	a, $06
.l00176:
	ld	hl, sp+9
	srl	[hl]
	dec	hl
	rr	[hl]
	dec	a
	jp	NZ, .l00176
	ld	a, [hl]
	ld	hl, sp+16
	ld	[hl], a
	ld	a, [hl]
	and	a, $3F
	ld	[hl], a
	ld	c, [hl]
	set	7, c
	ld	hl, sp+10
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	ld	[hl], c
	ld	hl, sp+11
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $0001
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+25
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+24
	ld	[hl], a
;src/fatfs/lib/ff.c:860: *buf++ = (TCHAR)(0x80 | (chr >> 0 & 0x3F));
	dec	hl
	ld	a, [hl]
	ld	hl, sp+10
	ld	[hl], a
	ld	hl, sp+24
	ld	a, [hl]
	ld	hl, sp+11
	ld	[hl], a
	inc	hl
	ld	a, [hl]
	ld	hl, sp+16
	ld	[hl], a
	ld	a, [hl]
	and	a, $3F
	ld	[hl], a
	ld	a, [hl]
	or	a, $80
	ld	[hl], a
	ld	hl, sp+11
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, sp+16
	ld	a, [hl]
	ld	[de], a
;src/fatfs/lib/ff.c:861: return 4;
	ld	bc, $0004
.l00120:
;src/fatfs/lib/ff.c:890: }
	add	sp, 21
	pop	hl
	add	sp, 4
	jp hl 
;src/fatfs/lib/ff.c:1060: static FRESULT sync_window (	/* Returns FR_OK or FR_DISK_ERR */
;	---------------------------------
	SECTION FRAGMENT "src/fatfs/fatfs.c B",ROMX
; Function sync_window
; ---------------------------------
_sync_window:
	add	sp, -19
	ld	hl, sp+17
	ld	[hl], e
	inc	hl
	ld	[hl], d
;src/fatfs/lib/ff.c:1064: FRESULT res = FR_OK;
	ld	hl, sp+0
	ld	[hl], $00
;src/fatfs/lib/ff.c:1067: if (fs->wflag) {	/* Is the disk access window dirty? */
	ld	hl, sp+18
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $0004
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+12
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+11
	ld	[hl], a
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	ld	hl, sp+16
	ld	[hl], a
	ld	a, [hl]
	or	a, a
	jp	Z, .l00109
;src/fatfs/lib/ff.c:1068: if (disk_write(fs->pdrv, fs->win, fs->winsect, 1) == RES_OK) {	/* Write it back into the volume */
	inc	hl
	inc	hl
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $001E
	add	hl, de
	ld	c, l
	ld	b, h
	ld	e, c
	ld	d, b
	ld	a, [de]
	ld	hl, sp+12
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
	ld	hl, sp+18
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $0032
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+3
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+2
	ld	[hl], a
	ld	hl, sp+18
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
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
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	ld	hl, sp+16
	ld	[hl], a
	push	bc
	ld	de, $0001
	push	de
	dec	hl
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	push	de
	ld	hl, sp+18
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	push	de
	ld	hl, sp+9
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, sp+24
	ld	a, [hl]
	call	_disk_write
	pop	bc
	or	a, a
	jp	NZ, .l00106
;src/fatfs/lib/ff.c:1069: fs->wflag = 0;	/* Clear window dirty flag */
	ld	hl, sp+10
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	ld	[hl], $00
;src/fatfs/lib/ff.c:1070: if (fs->winsect - fs->fatbase < fs->fsize) {	/* Is it in the 1st FAT? */
	ld	e, c
	ld	d, b
	ld	a, [de]
	ld	hl, sp+5
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
	ld	hl, sp+18
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $0026
	add	hl, de
	ld	c, l
	ld	b, h
	ld	e, c
	ld	d, b
	ld	a, [de]
	ld	hl, sp+9
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
	ld	hl, sp+6
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, e
	ld	hl, sp+9
	sub	a, [hl]
	ld	e, a
	ld	a, d
	inc	hl
	sbc	a, [hl]
	push	af
	ld	hl, sp+16
	ld	[hl], a
	dec	hl
	ld	[hl], e
	ld	hl, sp+10
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, sp+13
	pop	af
	ld	a, e
	sbc	a, [hl]
	ld	e, a
	ld	a, d
	inc	hl
	sbc	a, [hl]
	ld	hl, sp+16
	ld	[hl], a
	dec	hl
	ld	[hl], e
	ld	hl, sp+18
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $001A
	add	hl, de
	ld	c, l
	ld	b, h
	ld	e, c
	ld	d, b
	ld	a, [de]
	ld	hl, sp+9
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
	ld	hl, sp+13
	ld	e, l
	ld	d, h
	ld	hl, sp+9
	ld	a, [de]
	inc	de
	sub	a, [hl]
	inc	hl
	ld	a, [de]
	inc	de
	sbc	a, [hl]
	inc	hl
	ld	a, [de]
	inc	de
	sbc	a, [hl]
	inc	hl
	ld	a, [de]
	sbc	a, [hl]
	jp	NC, .l00109
;src/fatfs/lib/ff.c:1071: if (fs->n_fats == 2) disk_write(fs->pdrv, fs->win, fs->winsect + fs->fsize, 1);	/* Reflect it to 2nd FAT if needed */
	ld	hl, sp+17
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	inc	bc
	inc	bc
	inc	bc
	ld	a, [bc]
	sub	a, $02
	jp	NZ,.l00132
	jp	.l00133
.l00132:
	jp	.l00109
.l00133:
	ld	hl, sp+6
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, e
	ld	hl, sp+9
	add	a, [hl]
	ld	e, a
	ld	a, d
	inc	hl
	adc	a, [hl]
	push	af
	ld	hl, sp+16
	ld	[hl], a
	dec	hl
	ld	[hl], e
	ld	hl, sp+10
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, sp+13
	pop	af
	ld	a, e
	adc	a, [hl]
	ld	e, a
	ld	a, d
	inc	hl
	adc	a, [hl]
	ld	hl, sp+16
	ld	[hl], a
	dec	hl
	ld	[hl], e
	ld	hl, sp+4
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	ld	hl, sp+12
	ld	[hl], a
	ld	de, $0001
	push	de
	ld	hl, sp+17
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	push	de
	ld	hl, sp+17
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	push	de
	ld	hl, sp+7
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, sp+18
	ld	a, [hl]
	call	_disk_write
	jp	.l00109
.l00106:
;src/fatfs/lib/ff.c:1074: res = FR_DISK_ERR;
	ld	hl, sp+0
	ld	[hl], $01
.l00109:
;src/fatfs/lib/ff.c:1077: return res;
	ld	hl, sp+0
	ld	a, [hl]
.l00110:
;src/fatfs/lib/ff.c:1078: }
	add	sp, 19
	ret
;src/fatfs/lib/ff.c:1082: static FRESULT move_window (	/* Returns FR_OK or FR_DISK_ERR */
;	---------------------------------
	SECTION FRAGMENT "src/fatfs/fatfs.c B",ROMX
; Function move_window
; ---------------------------------
_move_window:
	add	sp, -8
	ld	c, e
	ld	b, d
;src/fatfs/lib/ff.c:1087: FRESULT res = FR_OK;
	ld	hl, sp+4
	ld	[hl], $00
;src/fatfs/lib/ff.c:1090: if (sect != fs->winsect) {	/* Window offset changed? */
	ld	hl, $001E
	add	hl, bc
	push	hl
	ld	a, l
	ld	hl, sp+7
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+6
	ld	[hl], a
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	ld	hl, sp+0
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
	ld	hl, sp+10
	ld	a, [hl]
	ld	hl, sp+0
	sub	a, [hl]
	jp	NZ,.l00124
	ld	hl, sp+11
	ld	a, [hl]
	ld	hl, sp+1
	sub	a, [hl]
	jp	NZ,.l00124
	ld	hl, sp+12
	ld	a, [hl]
	ld	hl, sp+2
	sub	a, [hl]
	jp	NZ,.l00124
	ld	hl, sp+13
	ld	a, [hl]
	ld	hl, sp+3
	sub	a, [hl]
	jp	NZ,.l00124
	jp	.l00106
.l00124:
;src/fatfs/lib/ff.c:1092: res = sync_window(fs);		/* Flush the window */
	push	bc
	ld	e, c
	ld	d, b
	call	_sync_window
	pop	bc
	ld	hl, sp+4
	ld	[hl], a
;src/fatfs/lib/ff.c:1094: if (res == FR_OK) {			/* Fill sector window with new data */
	or	a, a
	jp	NZ, .l00106
;src/fatfs/lib/ff.c:1095: if (disk_read(fs->pdrv, fs->win, sect, 1) != RES_OK) {
	ld	hl, $0032
	add	hl, bc
	ld	e, l
	ld	d, h
	inc	bc
	ld	a, [bc]
	ld	hl, sp+7
	ld	[hl], a
	ld	bc, $0001
	push	bc
	ld	hl, sp+14
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	push	bc
	ld	hl, sp+14
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	push	bc
	ld	hl, sp+13
	ld	a, [hl]
	call	_disk_read
	or	a, a
	jp	Z, .l00102
;src/fatfs/lib/ff.c:1096: sect = (LBA_t)0 - 1;	/* Invalidate window if read data is not valid */
	ld	hl, sp+10
	ld	[hl], $FF
	inc	hl
	ld	[hl], $FF
	inc	hl
	ld	[hl], $FF
	inc	hl
	ld	[hl], $FF
;src/fatfs/lib/ff.c:1097: res = FR_DISK_ERR;
	ld	hl, sp+4
	ld	[hl], $01
.l00102:
;src/fatfs/lib/ff.c:1099: fs->winsect = sect;
	ld	hl, sp+6
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, sp+10
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
.l00106:
;src/fatfs/lib/ff.c:1102: return res;
	ld	hl, sp+4
	ld	a, [hl]
.l00107:
;src/fatfs/lib/ff.c:1103: }
	add	sp, 8
	pop	hl
	add	sp, 4
	jp hl 
;src/fatfs/lib/ff.c:1113: static FRESULT sync_fs (	/* Returns FR_OK or FR_DISK_ERR */
;	---------------------------------
	SECTION FRAGMENT "src/fatfs/fatfs.c B",ROMX
; Function sync_fs
; ---------------------------------
_sync_fs:
	add	sp, -17
	ld	hl, sp+15
	ld	[hl], e
	inc	hl
	ld	[hl], d
;src/fatfs/lib/ff.c:1120: res = sync_window(fs);
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_sync_window
	ld	hl, sp+14
	ld	[hl], a
	ld	hl, sp+14
	ld	a, [hl]
	ld	hl, sp+0
	ld	[hl], a
;src/fatfs/lib/ff.c:1121: if (res == FR_OK) {
	ld	hl, sp+14
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00108
;src/fatfs/lib/ff.c:1122: if (fs->fsi_flag == 1) {	/* Allocation changed? */
	inc	hl
	inc	hl
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $0005
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+14
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+13
	ld	[hl], a
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	inc	hl
	ld	[hl], a
;src/fatfs/lib/ff.c:1132: disk_write(fs->pdrv, fs->win, fs->winsect = fs->volbase + 1, 1);	/* Write it into the FSInfo sector (Next to VBR) */
	inc	hl
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
;src/fatfs/lib/ff.c:1122: if (fs->fsi_flag == 1) {	/* Allocation changed? */
	ld	hl, sp+14
	ld	a, [hl]
	dec	a
	jp	NZ,.l00131
	jp	.l00132
.l00131:
	jp	.l00104
.l00132:
;src/fatfs/lib/ff.c:1123: fs->fsi_flag = 0;
	ld	hl, sp+12
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	ld	[hl], $00
;src/fatfs/lib/ff.c:1124: if (fs->fs_type == FS_FAT32) {	/* FAT32: Update FSInfo sector */
	ld	hl, sp+16
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	sub	a, $03
	jp	NZ,.l00133
	jp	.l00134
.l00133:
	jp	.l00104
.l00134:
;src/fatfs/lib/ff.c:1126: memset(fs->win, 0, sizeof fs->win);
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $0032
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+5
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+4
	ld	[hl], a
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	bc, $0200
	push	bc
	ld	bc, $0000
	call	_memset
;src/fatfs/lib/ff.c:1127: st_32(fs->win + FSI_LeadSig, 0x41615252);		/* Leading signature */
	ld	de, $4161
	push	de
	ld	de, $5252
	push	de
	ld	hl, sp+7
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_st_32
;src/fatfs/lib/ff.c:1128: st_32(fs->win + FSI_StrucSig, 0x61417272);		/* Structure signature */
	ld	hl, sp+16
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $0032
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+9
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+8
	ld	[hl], a
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $01E4
	add	hl, de
	ld	e, l
	ld	d, h
	ld	bc, $6141
	push	bc
	ld	bc, $7272
	push	bc
	call	_st_32
;src/fatfs/lib/ff.c:1129: st_32(fs->win + FSI_Free_Count, fs->free_clst);	/* Number of free clusters */
	ld	hl, sp+16
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $0012
	add	hl, de
	ld	c, l
	ld	b, h
	ld	e, c
	ld	d, b
	ld	a, [de]
	ld	hl, sp+9
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
	ld	hl, sp+8
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $01E8
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+15
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+14
	ld	[hl], a
	ld	hl, sp+11
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	push	de
	ld	hl, sp+11
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	push	de
	ld	hl, sp+17
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_st_32
;src/fatfs/lib/ff.c:1130: st_32(fs->win + FSI_Nxt_Free, fs->last_clst);	/* Last allocated culuster */
	ld	hl, sp+16
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $000E
	add	hl, de
	ld	c, l
	ld	b, h
	ld	e, c
	ld	d, b
	ld	a, [de]
	ld	hl, sp+9
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
	ld	hl, sp+8
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $01EC
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+15
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+14
	ld	[hl], a
	ld	hl, sp+11
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	push	de
	ld	hl, sp+11
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	push	de
	ld	hl, sp+17
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_st_32
;src/fatfs/lib/ff.c:1131: st_32(fs->win + FSI_TrailSig, 0xAA550000);		/* Trailing signature */
	ld	hl, sp+8
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $01FC
	add	hl, de
	ld	e, l
	ld	d, h
	ld	bc, $AA55
	push	bc
	ld	bc, $0000
	push	bc
	call	_st_32
;src/fatfs/lib/ff.c:1132: disk_write(fs->pdrv, fs->win, fs->winsect = fs->volbase + 1, 1);	/* Write it into the FSInfo sector (Next to VBR) */
	ld	hl, sp+16
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $001E
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+7
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+6
	ld	[hl], a
	ld	hl, sp+16
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $0022
	add	hl, de
	ld	c, l
	ld	b, h
	ld	e, c
	ld	d, b
	ld	a, [de]
	ld	hl, sp+7
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
	dec	hl
	dec	hl
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, e
	add	a, $01
	ld	e, a
	ld	a, d
	adc	a, $00
	push	af
	ld	hl, sp+14
	ld	[hl], a
	dec	hl
	ld	[hl], e
	dec	hl
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	pop	af
	ld	a, e
	adc	a, $00
	ld	e, a
	ld	a, d
	adc	a, $00
	ld	hl, sp+14
	ld	[hl], a
	dec	hl
	ld	[hl], e
	ld	hl, sp+6
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, sp+11
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
	ld	hl, sp+2
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	ld	hl, sp+10
	ld	[hl], a
	ld	de, $0001
	push	de
	ld	hl, sp+15
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	push	de
	ld	hl, sp+15
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	push	de
	ld	hl, sp+9
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, sp+16
	ld	a, [hl]
	call	_disk_write
.l00104:
;src/fatfs/lib/ff.c:1148: if (disk_ioctl(fs->pdrv, CTRL_SYNC, 0) != RES_OK) res = FR_DISK_ERR;
	ld	hl, sp+2
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	ld	hl, sp+14
	ld	[hl], a
	ld	de, $0000
	push	de
	ld	e, $00
	ld	a, [hl]
	call	_disk_ioctl
	ld	hl, sp+14
	ld	[hl], a
	ld	hl, sp+14
	ld	a, [hl]
	or	a, a
	jp	Z, .l00108
	ld	hl, sp+0
	ld	[hl], $01
.l00108:
;src/fatfs/lib/ff.c:1151: return res;
	ld	hl, sp+0
	ld	a, [hl]
.l00109:
;src/fatfs/lib/ff.c:1152: }
	add	sp, 17
	ret
;src/fatfs/lib/ff.c:1162: static LBA_t clst2sect (	/* !=0:Sector number, 0:Failed (invalid cluster#) */
;	---------------------------------
	SECTION FRAGMENT "src/fatfs/fatfs.c A",ROMX
; Function clst2sect
; ---------------------------------
_clst2sect:
	add	sp, -12
	ld	c, e
	ld	b, d
;src/fatfs/lib/ff.c:1167: clst -= 2;		/* Cluster number is origin from 2 */
	ld	hl, sp+15
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, e
	sub	a, $02
	ld	e, a
	ld	a, d
	sbc	a, $00
	push	af
	ld	[hl], a
	dec	hl
	ld	[hl], e
	ld	hl, sp+19
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	pop	af
	ld	a, e
	sbc	a, $00
	ld	e, a
	ld	a, d
	sbc	a, $00
	ld	[hl], a
	dec	hl
	ld	[hl], e
;src/fatfs/lib/ff.c:1168: if (clst >= fs->n_fatent - 2) return 0;		/* Is it invalid cluster number? */
	ld	hl, $0016
	add	hl, bc
	ld	e, l
	ld	d, h
	ld	a, [de]
	ld	hl, sp+4
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
	ld	hl, sp+5
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, e
	sub	a, $02
	ld	e, a
	ld	a, d
	sbc	a, $00
	push	af
	ld	hl, sp+11
	ld	[hl], a
	dec	hl
	ld	[hl], e
	dec	hl
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	pop	af
	ld	a, e
	sbc	a, $00
	ld	e, a
	ld	a, d
	sbc	a, $00
	ld	hl, sp+11
	ld	[hl], a
	dec	hl
	ld	[hl], e
	ld	hl, sp+14
	ld	e, l
	ld	d, h
	ld	hl, sp+8
	ld	a, [de]
	inc	de
	sub	a, [hl]
	inc	hl
	ld	a, [de]
	inc	de
	sbc	a, [hl]
	inc	hl
	ld	a, [de]
	inc	de
	sbc	a, [hl]
	inc	hl
	ld	a, [de]
	sbc	a, [hl]
	jp	C, .l00102
	ld	bc, $0000
	ld	de, $0000
	jp	.l00103
.l00102:
;src/fatfs/lib/ff.c:1169: return fs->database + (LBA_t)fs->csize * clst;	/* Start sector number of the cluster */
	ld	hl, $002E
	add	hl, bc
	ld	e, l
	ld	d, h
	ld	a, [de]
	ld	hl, sp+0
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
	ld	hl, $000A
	add	hl, bc
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	ld	de, $0000
	ld	hl, sp+16
	ld	a, [hl]
	inc	hl
	ld	h, [hl]
;	spillPairReg hl
;	spillPairReg hl
	ld	l, a
;	spillPairReg hl
;	spillPairReg hl
	push	hl
	ld	hl, sp+16
	ld	a, [hl]
	inc	hl
	ld	h, [hl]
;	spillPairReg hl
;	spillPairReg hl
	ld	l, a
;	spillPairReg hl
;	spillPairReg hl
	push	hl
	call	__mullong
	ld	hl, sp+4
	ld	[hl], c
	inc	hl
	ld	[hl], b
	inc	hl
	ld	[hl], e
	inc	hl
	ld	[hl], d
	pop	de
	push	de
	ld	a, e
	ld	hl, sp+4
	add	a, [hl]
	ld	e, a
	ld	a, d
	inc	hl
	adc	a, [hl]
	push	af
	ld	hl, sp+11
	ld	[hl], a
	dec	hl
	ld	[hl], e
	ld	hl, sp+5
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, sp+8
	pop	af
	ld	a, e
	adc	a, [hl]
	ld	e, a
	ld	a, d
	inc	hl
	adc	a, [hl]
	ld	hl, sp+11
	ld	[hl], a
	dec	hl
	ld	[hl], e
	dec	hl
	dec	hl
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	inc	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
.l00103:
;src/fatfs/lib/ff.c:1170: }
	add	sp, 12
	pop	hl
	add	sp, 4
	jp hl 
;src/fatfs/lib/ff.c:1179: static DWORD get_fat (		/* 0xFFFFFFFF:Disk error, 1:Internal error, 2..0x7FFFFFFF:Cluster status */
;	---------------------------------
	SECTION FRAGMENT "src/fatfs/fatfs.c A",ROMX
; Function get_fat
; ---------------------------------
_get_fat:
	add	sp, -22
	ld	c, e
	ld	b, d
;src/fatfs/lib/ff.c:1186: FATFS *fs = obj->fs;
	ld	e, c
	ld	d, b
	ld	a, [de]
	ld	hl, sp+0
	ld	[hl], a
	inc	de
	ld	a, [de]
	inc	hl
	ld	[hl], a
;src/fatfs/lib/ff.c:1189: if (clst < 2 || clst >= fs->n_fatent) {	/* Check if in valid range */
	ld	hl, sp+24
	ld	a, [hl]
	sub	a, $02
	inc	hl
	ld	a, [hl]
	sbc	a, $00
	inc	hl
	ld	a, [hl]
	sbc	a, $00
	inc	hl
	ld	a, [hl]
	sbc	a, $00
	jp	C, .l00114
	pop	de
	push	de
	ld	hl, $0016
	add	hl, de
	ld	c, l
	ld	b, h
	ld	e, c
	ld	d, b
	ld	a, [de]
	ld	hl, sp+18
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
	ld	hl, sp+24
	ld	e, l
	ld	d, h
	ld	hl, sp+18
	ld	a, [de]
	inc	de
	sub	a, [hl]
	inc	hl
	ld	a, [de]
	inc	de
	sbc	a, [hl]
	inc	hl
	ld	a, [de]
	inc	de
	sbc	a, [hl]
	inc	hl
	ld	a, [de]
	sbc	a, [hl]
	jp	C, .l00115
.l00114:
;src/fatfs/lib/ff.c:1190: val = 1;	/* Internal error */
	ld	hl, sp+2
	ld	[hl], $01
	xor	a, a
	inc	hl
	ld	[hl], a
	inc	hl
	ld	[hl], a
	inc	hl
	ld	[hl], a
	jp	.l00116
.l00115:
;src/fatfs/lib/ff.c:1193: val = 0xFFFFFFFF;	/* Default value falls on disk error */
	ld	hl, sp+2
	ld	[hl], $FF
	inc	hl
	ld	[hl], $FF
	inc	hl
	ld	[hl], $FF
	inc	hl
	ld	[hl], $FF
;src/fatfs/lib/ff.c:1195: switch (fs->fs_type) {
	pop	de
	push	de
	ld	a, [de]
	ld	c, a
;src/fatfs/lib/ff.c:1198: if (move_window(fs, fs->fatbase + (bc / SS(fs))) != FR_OK) break;
	pop	de
	push	de
	ld	hl, $0026
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+22
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+21
	ld	[hl], a
;src/fatfs/lib/ff.c:1199: wc = fs->win[bc++ % SS(fs)];		/* Get 1st byte of the entry */
	pop	de
	push	de
	ld	hl, $0032
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+8
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+7
	ld	[hl], a
;src/fatfs/lib/ff.c:1195: switch (fs->fs_type) {
	ld	a, c
	dec	a
	jp	NZ,.l00167
	jp	.l00101
.l00167:
	ld	a, c
	sub	a, $02
	jp	NZ,.l00168
	jp	.l00106
.l00168:
	ld	a, c
	sub	a, $03
	jp	NZ,.l00169
	jp	.l00109
.l00169:
	jp	.l00112
;src/fatfs/lib/ff.c:1196: case FS_FAT12 :
.l00101:
;src/fatfs/lib/ff.c:1197: bc = (UINT)clst; bc += bc / 2;
	ld	hl, sp+24
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	ld	l, c
	ld	h, b
	srl	h
	rr	l
	add	hl, bc
	ld	c, l
	ld	b, h
;src/fatfs/lib/ff.c:1198: if (move_window(fs, fs->fatbase + (bc / SS(fs))) != FR_OK) break;
	ld	hl, sp+21
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	ld	hl, sp+8
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
	ld	a, b
	srl	a
	ld	e, a
	ld	d, $00
	inc	hl
	ld	[hl], e
	inc	hl
	ld	[hl], d
	xor	a, a
	inc	hl
	ld	[hl], a
	inc	hl
	ld	[hl], a
	ld	hl, sp+9
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, e
	ld	hl, sp+12
	add	a, [hl]
	ld	e, a
	ld	a, d
	inc	hl
	adc	a, [hl]
	push	af
	ld	hl, sp+19
	ld	[hl], a
	dec	hl
	ld	[hl], e
	ld	hl, sp+13
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, sp+16
	pop	af
	ld	a, e
	adc	a, [hl]
	ld	e, a
	ld	a, d
	inc	hl
	adc	a, [hl]
	ld	hl, sp+19
	ld	[hl], a
	dec	hl
	ld	[hl], e
	push	bc
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	push	de
	ld	hl, sp+20
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	push	de
	ld	hl, sp+6
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_move_window__far
	pop	bc
	or	a, a
	jp	NZ, .l00116
;src/fatfs/lib/ff.c:1199: wc = fs->win[bc++ % SS(fs)];		/* Get 1st byte of the entry */
	ld	e, c
	ld	a, b
	inc	bc
	and	a, $01
	ld	d, a
	ld	hl, sp+6
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	add	hl, de
	ld	e, l
	ld	d, h
	ld	a, [de]
	ld	hl, sp+8
	ld	[hl], a
	inc	hl
	ld	[hl], $00
;src/fatfs/lib/ff.c:1200: if (move_window(fs, fs->fatbase + (bc / SS(fs))) != FR_OK) break;
	ld	hl, sp+21
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	ld	hl, sp+10
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
	ld	a, b
	srl	a
	ld	e, a
	ld	d, $00
	inc	hl
	ld	[hl], e
	inc	hl
	ld	[hl], d
	xor	a, a
	inc	hl
	ld	[hl], a
	inc	hl
	ld	[hl], a
	ld	hl, sp+11
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, e
	ld	hl, sp+14
	add	a, [hl]
	ld	e, a
	ld	a, d
	inc	hl
	adc	a, [hl]
	push	af
	ld	hl, sp+21
	ld	[hl], a
	dec	hl
	ld	[hl], e
	ld	hl, sp+15
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, sp+18
	pop	af
	ld	a, e
	adc	a, [hl]
	ld	e, a
	ld	a, d
	inc	hl
	adc	a, [hl]
	ld	hl, sp+21
	ld	[hl], a
	dec	hl
	ld	[hl], e
	push	bc
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	push	de
	ld	hl, sp+22
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	push	de
	ld	hl, sp+6
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_move_window__far
	pop	bc
	or	a, a
	jp	NZ, .l00116
;src/fatfs/lib/ff.c:1201: wc |= fs->win[bc % SS(fs)] << 8;	/* Merge 2nd byte of the entry */
	ld	a, b
	and	a, $01
	ld	b, a
	ld	hl, sp+6
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	add	hl, bc
	ld	c, l
	ld	b, h
	ld	a, [bc]
	ld	c, $00
	ld	hl, sp+19
	ld	[hl], a
	dec	hl
	ld	[hl], $00
	ld	hl, sp+8
	ld	a, [hl]
	ld	hl, sp+18
	or	a, [hl]
	inc	hl
	inc	hl
	ld	[hl], a
	ld	hl, sp+9
	ld	a, [hl]
	ld	hl, sp+19
	or	a, [hl]
	inc	hl
	inc	hl
	ld	[hl], a
	dec	hl
	ld	a, [hl]
	dec	hl
	dec	hl
	ld	[hl], a
	ld	hl, sp+21
	ld	a, [hl]
	dec	hl
	dec	hl
	ld	[hl], a
;src/fatfs/lib/ff.c:1202: val = (clst & 1) ? (wc >> 4) : (wc & 0xFFF);	/* Adjust bit position */
	push	hl
	ld	hl, sp+26
	bit	0, [hl]
	pop	hl
	jp	NZ,.l00170
	jp	.l00120
.l00170:
	ld	hl, sp+18
	ld	a, [hl]
	inc	hl
	inc	hl
	ld	[hl], a
	dec	hl
	ld	a, [hl]
	inc	hl
	inc	hl
	ld	[hl], a
	ld	a, $04
.l00171:
	ld	hl, sp+21
	srl	[hl]
	dec	hl
	rr	[hl]
	dec	a
	jp	NZ, .l00171
	jp	.l00121
.l00120:
	ld	hl, sp+18
	ld	a, [hl]
	inc	hl
	inc	hl
	ld	[hl], a
	dec	hl
	ld	a, [hl]
	and	a, $0F
	inc	hl
	inc	hl
	ld	[hl], a
.l00121:
	ld	hl, sp+20
	ld	a, [hl]
	ld	hl, sp+2
	ld	[hl], a
	ld	hl, sp+21
	ld	a, [hl]
	ld	hl, sp+3
	ld	[hl], a
	xor	a, a
	inc	hl
	ld	[hl], a
	inc	hl
	ld	[hl], a
;src/fatfs/lib/ff.c:1203: break;
	jp	.l00116
;src/fatfs/lib/ff.c:1205: case FS_FAT16 :
.l00106:
;src/fatfs/lib/ff.c:1206: if (move_window(fs, fs->fatbase + (clst / (SS(fs) / 2))) != FR_OK) break;
	ld	hl, sp+21
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	ld	hl, sp+18
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
	ld	hl, sp+25
	ld	a, [hl]
	ld	hl, sp+10
	ld	[hl], a
	ld	hl, sp+26
	ld	a, [hl]
	ld	hl, sp+11
	ld	[hl], a
	ld	hl, sp+27
	ld	a, [hl]
	ld	hl, sp+12
	ld	[hl], a
	inc	hl
	ld	[hl], $00
	ld	hl, sp+19
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, e
	ld	hl, sp+10
	add	a, [hl]
	ld	e, a
	ld	a, d
	inc	hl
	adc	a, [hl]
	push	af
	ld	hl, sp+17
	ld	[hl], a
	dec	hl
	ld	[hl], e
	ld	hl, sp+23
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, sp+14
	pop	af
	ld	a, e
	adc	a, [hl]
	ld	e, a
	ld	a, d
	inc	hl
	adc	a, [hl]
	ld	hl, sp+17
	ld	[hl], a
	dec	hl
	ld	[hl], e
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	push	de
	ld	hl, sp+16
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	push	de
	ld	hl, sp+4
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_move_window__far
	or	a, a
	jp	NZ, .l00116
;src/fatfs/lib/ff.c:1207: val = ld_16(fs->win + clst * 2 % SS(fs));		/* Simple WORD array */
	ld	hl, sp+24
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	inc	hl
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	sla	e
	rl	d
	rl	c
	rl	b
	ld	a, d
	and	a, $01
	ld	d, a
	ld	bc, $0000
	ld	hl, sp+6
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	add	hl, de
	ld	e, l
	ld	d, h
	call	_ld_16
	ld	hl, sp+2
	ld	[hl], c
	inc	hl
	ld	[hl], b
	xor	a, a
	inc	hl
	ld	[hl], a
	inc	hl
	ld	[hl], a
;src/fatfs/lib/ff.c:1208: break;
	jp	.l00116
;src/fatfs/lib/ff.c:1210: case FS_FAT32 :
.l00109:
;src/fatfs/lib/ff.c:1211: if (move_window(fs, fs->fatbase + (clst / (SS(fs) / 4))) != FR_OK) break;
	ld	hl, sp+21
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	ld	hl, sp+18
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
	ld	hl, sp+24
	ld	a, [hl]
	ld	hl, sp+10
	ld	[hl], a
	ld	hl, sp+25
	ld	a, [hl]
	ld	hl, sp+11
	ld	[hl], a
	ld	hl, sp+26
	ld	a, [hl]
	ld	hl, sp+12
	ld	[hl], a
	ld	hl, sp+27
	ld	a, [hl]
	ld	hl, sp+13
	ld	[hl], a
	ld	a, $07
.l00176:
	ld	hl, sp+13
	srl	[hl]
	dec	hl
	rr	[hl]
	dec	hl
	rr	[hl]
	dec	hl
	rr	[hl]
.l00177:
	dec	a
	jr	NZ, .l00176
	ld	hl, sp+19
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, e
	ld	hl, sp+10
	add	a, [hl]
	ld	e, a
	ld	a, d
	inc	hl
	adc	a, [hl]
	push	af
	ld	hl, sp+17
	ld	[hl], a
	dec	hl
	ld	[hl], e
	ld	hl, sp+23
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, sp+14
	pop	af
	ld	a, e
	adc	a, [hl]
	ld	e, a
	ld	a, d
	inc	hl
	adc	a, [hl]
	ld	hl, sp+17
	ld	[hl], a
	dec	hl
	ld	[hl], e
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	push	de
	ld	hl, sp+16
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	push	de
	ld	hl, sp+4
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_move_window__far
	or	a, a
	jp	NZ, .l00116
;src/fatfs/lib/ff.c:1212: val = ld_32(fs->win + clst * 4 % SS(fs)) & 0x0FFFFFFF;	/* Simple DWORD array but mask out upper 4 bits */
	ld	hl, sp+24
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	inc	hl
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	ld	a, $02
.l00178:
	sla	e
	rl	d
	rl	c
	rl	b
.l00179:
	dec	a
	jr	NZ,.l00178
	ld	a, d
	and	a, $01
	ld	d, a
	ld	bc, $0000
	ld	hl, sp+6
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	add	hl, de
	ld	e, l
	ld	d, h
	call	_ld_32
	ld	hl, sp+2
	ld	[hl], c
	inc	hl
	ld	[hl], b
	inc	hl
	ld	[hl], e
	ld	a, d
	and	a, $0F
	inc	hl
	ld	[hl], a
;src/fatfs/lib/ff.c:1213: break;
	jp	.l00116
;src/fatfs/lib/ff.c:1241: default:
.l00112:
;src/fatfs/lib/ff.c:1242: val = 1;	/* Internal error */
	ld	hl, sp+2
	ld	[hl], $01
	xor	a, a
	inc	hl
	ld	[hl], a
	inc	hl
	ld	[hl], a
	inc	hl
	ld	[hl], a
;src/fatfs/lib/ff.c:1243: }
.l00116:
;src/fatfs/lib/ff.c:1246: return val;
	pop	hl
	pop	bc
	push	bc
	push	hl
	ld	hl, sp+4
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
.l00118:
;src/fatfs/lib/ff.c:1247: }
	add	sp, 22
	pop	hl
	add	sp, 4
	jp hl 
;src/fatfs/lib/ff.c:1257: static FRESULT put_fat (	/* FR_OK(0):succeeded, !=0:error */
;	---------------------------------
	SECTION FRAGMENT "src/fatfs/fatfs.c B",ROMX
; Function put_fat
; ---------------------------------
_put_fat:
	add	sp, -24
	ld	hl, sp+22
	ld	[hl], e
	inc	hl
	ld	[hl], d
;src/fatfs/lib/ff.c:1265: FRESULT res = FR_INT_ERR;
	ld	hl, sp+19
	ld	[hl], $02
;src/fatfs/lib/ff.c:1268: if (clst >= 2 && clst < fs->n_fatent) {	/* Check if in valid range */
	ld	hl, sp+26
	ld	a, [hl]
	sub	a, $02
	inc	hl
	ld	a, [hl]
	sbc	a, $00
	inc	hl
	ld	a, [hl]
	sbc	a, $00
	inc	hl
	ld	a, [hl]
	sbc	a, $00
	jp	C, .l00117
	ld	hl, sp+23
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $0016
	add	hl, de
	ld	c, l
	ld	b, h
	ld	e, c
	ld	d, b
	ld	a, [de]
	ld	hl, sp+15
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
	ld	hl, sp+26
	ld	e, l
	ld	d, h
	ld	hl, sp+15
	ld	a, [de]
	inc	de
	sub	a, [hl]
	inc	hl
	ld	a, [de]
	inc	de
	sbc	a, [hl]
	inc	hl
	ld	a, [de]
	inc	de
	sbc	a, [hl]
	inc	hl
	ld	a, [de]
	sbc	a, [hl]
	jp	NC, .l00117
;src/fatfs/lib/ff.c:1269: switch (fs->fs_type) {
	ld	hl, sp+23
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	ld	c, a
;src/fatfs/lib/ff.c:1272: res = move_window(fs, fs->fatbase + (bc / SS(fs)));
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $0026
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+22
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+21
	ld	[hl], a
;src/fatfs/lib/ff.c:1274: p = fs->win + bc++ % SS(fs);
	inc	hl
	inc	hl
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $0032
	add	hl, de
	inc	sp
	inc	sp
	push	hl
;src/fatfs/lib/ff.c:1276: fs->wflag = 1;
	ld	hl, sp+23
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $0004
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+4
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+3
	ld	[hl], a
;src/fatfs/lib/ff.c:1269: switch (fs->fs_type) {
	ld	a, c
	dec	a
	jp	NZ,.l00180
	jp	.l00101
.l00180:
	ld	a, c
	sub	a, $02
	jp	NZ,.l00181
	jp	.l00106
.l00181:
	ld	a, c
	sub	a, $03
	jp	NZ,.l00182
	jp	.l00109
.l00182:
	jp	.l00117
;src/fatfs/lib/ff.c:1270: case FS_FAT12:
.l00101:
;src/fatfs/lib/ff.c:1271: bc = (UINT)clst; bc += bc / 2;	/* bc: byte offset of the entry */
	ld	hl, sp+26
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	ld	l, c
	ld	h, b
	srl	h
	rr	l
	add	hl, bc
	ld	c, l
	ld	b, h
;src/fatfs/lib/ff.c:1272: res = move_window(fs, fs->fatbase + (bc / SS(fs)));
	ld	hl, sp+21
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	ld	hl, sp+8
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
	ld	a, b
	srl	a
	ld	e, a
	ld	d, $00
	inc	hl
	ld	[hl], e
	inc	hl
	ld	[hl], d
	xor	a, a
	inc	hl
	ld	[hl], a
	inc	hl
	ld	[hl], a
	ld	hl, sp+9
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, e
	ld	hl, sp+12
	add	a, [hl]
	ld	e, a
	ld	a, d
	inc	hl
	adc	a, [hl]
	push	af
	ld	hl, sp+19
	ld	[hl], a
	dec	hl
	ld	[hl], e
	ld	hl, sp+13
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, sp+16
	pop	af
	ld	a, e
	adc	a, [hl]
	ld	e, a
	ld	a, d
	inc	hl
	adc	a, [hl]
	ld	hl, sp+19
	ld	[hl], a
	dec	hl
	ld	[hl], e
	push	bc
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	push	de
	ld	hl, sp+20
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	push	de
	ld	hl, sp+28
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_move_window
	pop	bc
	ld	hl, sp+19
	ld	[hl], a
;src/fatfs/lib/ff.c:1273: if (res != FR_OK) break;
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00117
;src/fatfs/lib/ff.c:1274: p = fs->win + bc++ % SS(fs);
	ld	e, c
	ld	d, b
	inc	bc
	ld	hl, sp+4
	ld	[hl], c
	inc	hl
	ld	[hl], b
	ld	a, d
	and	a, $01
	ld	d, a
	pop	hl
	push	hl
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+19
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+18
	ld	[hl], a
;src/fatfs/lib/ff.c:1275: *p = (clst & 1) ? ((*p & 0x0F) | ((BYTE)val << 4)) : (BYTE)val;	/* Update 1st byte */
	dec	hl
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	ld	hl, sp+26
	ld	a, [hl]
	and	a, $01
	ld	hl, sp+6
	ld	[hl], a
	xor	a, a
	inc	hl
	ld	[hl], a
	inc	hl
	ld	[hl], a
	inc	hl
	ld	[hl], a
	ld	hl, sp+30
	ld	a, [hl]
	ld	hl, sp+19
	ld	[hl], a
	ld	hl, sp+9
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	dec	hl
	or	a, [hl]
	dec	hl
	or	a, [hl]
	jp	Z, .l00121
	ld	hl, sp+18
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	ld	d, $00
	and	a, $0F
	ld	e, a
	ld	d, $00
	inc	hl
	ld	a, [hl]
	swap	a
	and	a, $F0
	push	af
	rlca
	sbc	a, a
	ld	l, a
;	spillPairReg hl
;	spillPairReg hl
	pop	af
	or	a, e
	ld	e, a
	ld	a, l
	or	a, d
	jp	.l00122
.l00121:
	ld	hl, sp+19
	ld	e, [hl]
	xor	a, a
.l00122:
	ld	a, e
	ld	[bc], a
;src/fatfs/lib/ff.c:1276: fs->wflag = 1;
	pop	bc
	pop	hl
	push	hl
	push	bc
	ld	[hl], $01
;src/fatfs/lib/ff.c:1277: res = move_window(fs, fs->fatbase + (bc / SS(fs)));
	ld	hl, sp+21
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	ld	hl, sp+10
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
	ld	hl, sp+5
	ld	a, [hl]
	srl	a
	ld	c, a
	ld	b, $00
	ld	hl, sp+14
	ld	[hl], c
	inc	hl
	ld	[hl], b
	xor	a, a
	inc	hl
	ld	[hl], a
	inc	hl
	ld	[hl], a
	ld	hl, sp+11
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, e
	ld	hl, sp+14
	add	a, [hl]
	ld	e, a
	ld	a, d
	inc	hl
	adc	a, [hl]
	push	af
	ld	hl, sp+21
	ld	[hl], a
	dec	hl
	ld	[hl], e
	ld	hl, sp+15
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, sp+18
	pop	af
	ld	a, e
	adc	a, [hl]
	ld	e, a
	ld	a, d
	inc	hl
	adc	a, [hl]
	ld	hl, sp+21
	ld	[hl], a
	dec	hl
	ld	[hl], e
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	push	de
	ld	hl, sp+20
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	push	de
	ld	hl, sp+26
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_move_window
	ld	hl, sp+19
	ld	[hl], a
;src/fatfs/lib/ff.c:1278: if (res != FR_OK) break;
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00117
;src/fatfs/lib/ff.c:1279: p = fs->win + bc % SS(fs);
	ld	hl, sp+4
	ld	c, [hl]
	inc	hl
	ld	a, [hl]
	and	a, $01
	ld	b, a
	pop	hl
	push	hl
	add	hl, bc
	ld	c, l
	ld	a, h
	ld	hl, sp+17
	ld	[hl], c
	inc	hl
	ld	[hl], a
;src/fatfs/lib/ff.c:1280: *p = (clst & 1) ? (BYTE)(val >> 4) : ((*p & 0xF0) | ((BYTE)(val >> 8) & 0x0F));	/* Update 2nd byte */
	dec	hl
	ld	a, [hl]
	ld	hl, sp+20
	ld	[hl], a
	dec	hl
	dec	hl
	ld	a, [hl]
	ld	hl, sp+21
	ld	[hl], a
	ld	hl, sp+9
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	dec	hl
	or	a, [hl]
	dec	hl
	or	a, [hl]
	jp	Z, .l00123
	ld	hl, sp+30
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	ld	a, $04
.l00183:
	srl	b
	rr	c
	dec	a
	jp	NZ, .l00183
	ld	hl, sp+15
	ld	[hl], c
	inc	hl
	ld	[hl], $00
	jp	.l00124
.l00123:
	ld	hl, sp+18
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	ld	[hl], a
	ld	a, [hl]
	dec	hl
	ld	[hl], a
	inc	hl
	ld	[hl], $00
	dec	hl
	ld	a, [hl]
	and	a, $F0
	ld	hl, sp+13
	ld	[hl], a
	inc	hl
	ld	[hl], $00
	ld	hl, sp+31
	ld	a, [hl]
	ld	hl, sp+18
	ld	[hl], a
	ld	a, [hl]
	ld	hl, sp+15
	ld	[hl], a
	inc	hl
	ld	[hl], $00
	dec	hl
	ld	a, [hl]
	and	a, $0F
	inc	hl
	inc	hl
	ld	[hl], a
	inc	hl
	ld	[hl], $00
	ld	hl, sp+13
	ld	a, [hl]
	ld	hl, sp+17
	or	a, [hl]
	dec	hl
	dec	hl
	ld	[hl], a
	dec	hl
	ld	a, [hl]
	ld	hl, sp+18
	or	a, [hl]
	dec	hl
	dec	hl
	ld	[hl], a
.l00124:
	ld	hl, sp+15
	ld	c, [hl]
	ld	hl, sp+20
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	ld	[hl], c
;src/fatfs/lib/ff.c:1281: fs->wflag = 1;
	pop	bc
	pop	hl
	push	hl
	push	bc
	ld	[hl], $01
;src/fatfs/lib/ff.c:1282: break;
	jp	.l00117
;src/fatfs/lib/ff.c:1284: case FS_FAT16:
.l00106:
;src/fatfs/lib/ff.c:1285: res = move_window(fs, fs->fatbase + (clst / (SS(fs) / 2)));
	ld	hl, sp+21
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	ld	hl, sp+18
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
	ld	hl, sp+27
	ld	a, [hl]
	ld	hl, sp+10
	ld	[hl], a
	ld	hl, sp+28
	ld	a, [hl]
	ld	hl, sp+11
	ld	[hl], a
	ld	hl, sp+29
	ld	a, [hl]
	ld	hl, sp+12
	ld	[hl], a
	inc	hl
	ld	[hl], $00
	ld	hl, sp+19
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, e
	ld	hl, sp+10
	add	a, [hl]
	ld	e, a
	ld	a, d
	inc	hl
	adc	a, [hl]
	push	af
	ld	hl, sp+17
	ld	[hl], a
	dec	hl
	ld	[hl], e
	ld	hl, sp+23
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, sp+14
	pop	af
	ld	a, e
	adc	a, [hl]
	ld	e, a
	ld	a, d
	inc	hl
	adc	a, [hl]
	ld	hl, sp+17
	ld	[hl], a
	dec	hl
	ld	[hl], e
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	push	de
	ld	hl, sp+16
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	push	de
	ld	hl, sp+26
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_move_window
	ld	hl, sp+19
	ld	[hl], a
;src/fatfs/lib/ff.c:1286: if (res != FR_OK) break;
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00117
;src/fatfs/lib/ff.c:1287: st_16(fs->win + clst * 2 % SS(fs), (WORD)val);	/* Simple WORD array */
	ld	hl, sp+30
	ld	a, [hl]
	ld	hl, sp+20
	ld	[hl], a
	ld	hl, sp+31
	ld	a, [hl]
	ld	hl, sp+21
	ld	[hl], a
	ld	hl, sp+26
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	inc	hl
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	sla	e
	rl	d
	rl	c
	rl	b
	ld	a, d
	and	a, $01
	ld	d, a
	ld	bc, $0000
	pop	hl
	push	hl
	add	hl, de
	ld	e, l
	ld	d, h
	ld	hl, sp+20
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	call	_st_16
;src/fatfs/lib/ff.c:1288: fs->wflag = 1;
	pop	bc
	pop	hl
	push	hl
	push	bc
	ld	[hl], $01
;src/fatfs/lib/ff.c:1289: break;
	jp	.l00117
;src/fatfs/lib/ff.c:1291: case FS_FAT32:
.l00109:
;src/fatfs/lib/ff.c:1295: res = move_window(fs, fs->fatbase + (clst / (SS(fs) / 4)));
	ld	hl, sp+21
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	ld	hl, sp+18
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
	ld	hl, sp+26
	ld	a, [hl]
	ld	hl, sp+10
	ld	[hl], a
	ld	hl, sp+27
	ld	a, [hl]
	ld	hl, sp+11
	ld	[hl], a
	ld	hl, sp+28
	ld	a, [hl]
	ld	hl, sp+12
	ld	[hl], a
	ld	hl, sp+29
	ld	a, [hl]
	ld	hl, sp+13
	ld	[hl], a
	ld	a, $07
.l00188:
	ld	hl, sp+13
	srl	[hl]
	dec	hl
	rr	[hl]
	dec	hl
	rr	[hl]
	dec	hl
	rr	[hl]
.l00189:
	dec	a
	jr	NZ, .l00188
	ld	hl, sp+19
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, e
	ld	hl, sp+10
	add	a, [hl]
	ld	e, a
	ld	a, d
	inc	hl
	adc	a, [hl]
	push	af
	ld	hl, sp+17
	ld	[hl], a
	dec	hl
	ld	[hl], e
	ld	hl, sp+23
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, sp+14
	pop	af
	ld	a, e
	adc	a, [hl]
	ld	e, a
	ld	a, d
	inc	hl
	adc	a, [hl]
	ld	hl, sp+17
	ld	[hl], a
	dec	hl
	ld	[hl], e
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	push	de
	ld	hl, sp+16
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	push	de
	ld	hl, sp+26
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_move_window
	ld	hl, sp+19
	ld	[hl], a
;src/fatfs/lib/ff.c:1296: if (res != FR_OK) break;
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00117
;src/fatfs/lib/ff.c:1298: val = (val & 0x0FFFFFFF) | (ld_32(fs->win + clst * 4 % SS(fs)) & 0xF0000000);
	ld	hl, sp+30
	ld	a, [hl]
	ld	hl, sp+15
	ld	[hl], a
	ld	hl, sp+31
	ld	a, [hl]
	ld	hl, sp+16
	ld	[hl], a
	ld	hl, sp+32
	ld	a, [hl]
	ld	hl, sp+17
	ld	[hl], a
	ld	hl, sp+33
	ld	a, [hl]
	and	a, $0F
	ld	hl, sp+18
	ld	[hl], a
	ld	hl, sp+26
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	inc	hl
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	ld	a, $02
.l00190:
	sla	e
	rl	d
	rl	c
	rl	b
.l00191:
	dec	a
	jr	NZ,.l00190
	ld	a, d
	and	a, $01
	ld	d, a
	ld	bc, $0000
	pop	hl
	push	hl
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+22
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+21
	ld	[hl], a
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_ld_32
	ld	hl, $0000
	ld	c, $00
	ld	a, d
	and	a, $F0
	ld	b, a
	push	hl
	ld	hl, sp+17
	ld	a, [hl]
	pop	hl
	or	a, l
	ld	e, a
	push	hl
	ld	hl, sp+18
	ld	a, [hl]
	pop	hl
	or	a, h
	ld	d, a
	ld	hl, sp+17
	ld	a, [hl]
	or	a, c
	ld	c, a
	inc	hl
	ld	a, [hl]
	or	a, b
	ld	b, a
	ld	hl, sp+30
	ld	[hl], e
	inc	hl
	ld	[hl], d
	inc	hl
	ld	[hl], c
	inc	hl
	ld	[hl], b
;src/fatfs/lib/ff.c:1300: st_32(fs->win + clst * 4 % SS(fs), val);
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	push	de
	ld	hl, sp+32
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	push	de
	ld	hl, sp+24
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_st_32
;src/fatfs/lib/ff.c:1301: fs->wflag = 1;
	pop	bc
	pop	hl
	push	hl
	push	bc
	ld	[hl], $01
;src/fatfs/lib/ff.c:1303: }
.l00117:
;src/fatfs/lib/ff.c:1305: return res;
	ld	hl, sp+19
	ld	a, [hl]
.l00119:
;src/fatfs/lib/ff.c:1306: }
	add	sp, 24
	pop	hl
	add	sp, 8
	jp hl 
;src/fatfs/lib/ff.c:1447: static FRESULT remove_chain (	/* FR_OK(0):succeeded, !=0:error */
;	---------------------------------
	SECTION FRAGMENT "src/fatfs/fatfs.c B",ROMX
; Function remove_chain
; ---------------------------------
_remove_chain:
	add	sp, -22
	ld	hl, sp+20
	ld	[hl], e
	inc	hl
	ld	[hl], d
;src/fatfs/lib/ff.c:1455: FATFS *fs = obj->fs;
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	ld	hl, sp+0
	ld	[hl], a
	inc	de
	ld	a, [de]
	inc	hl
	ld	[hl], a
;src/fatfs/lib/ff.c:1463: if (clst < 2 || clst >= fs->n_fatent) return FR_INT_ERR;	/* Check if in valid range */
	ld	hl, sp+24
	ld	a, [hl]
	sub	a, $02
	inc	hl
	ld	a, [hl]
	sbc	a, $00
	inc	hl
	ld	a, [hl]
	sbc	a, $00
	inc	hl
	ld	a, [hl]
	sbc	a, $00
	jp	C, .l00101
	pop	de
	push	de
	ld	hl, $0016
	add	hl, de
	ld	c, l
	ld	b, h
	ld	e, c
	ld	d, b
	ld	a, [de]
	ld	hl, sp+16
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
	ld	hl, sp+24
	ld	e, l
	ld	d, h
	ld	hl, sp+16
	ld	a, [de]
	inc	de
	sub	a, [hl]
	inc	hl
	ld	a, [de]
	inc	de
	sbc	a, [hl]
	inc	hl
	ld	a, [de]
	inc	de
	sbc	a, [hl]
	inc	hl
	ld	a, [de]
	sbc	a, [hl]
	jp	C, .l00102
.l00101:
	ld	a, $02
	jp	.l00127
.l00102:
;src/fatfs/lib/ff.c:1466: if (pclst != 0 && (!FF_FS_EXFAT || fs->fs_type != FS_EXFAT || obj->stat != 2)) {
	ld	hl, sp+31
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	dec	hl
	or	a, [hl]
	dec	hl
	or	a, [hl]
	jp	Z, .l00137
;src/fatfs/lib/ff.c:1467: res = put_fat(fs, pclst, 0xFFFFFFFF);
	push	bc
	ld	de, $FFFF
	push	de
	push	de
	inc	hl
	inc	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	push	de
	ld	hl, sp+36
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	push	de
	ld	hl, sp+10
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_put_fat
	pop	bc
;src/fatfs/lib/ff.c:1468: if (res != FR_OK) return res;
	or	a, a
	jp	Z, .l00137
	jp	.l00127
;src/fatfs/lib/ff.c:1472: do {
.l00137:
	ld	hl, sp+2
	ld	[hl], c
	inc	hl
	ld	[hl], b
.l00124:
;src/fatfs/lib/ff.c:1473: nxt = get_fat(obj, clst);			/* Get cluster status */
	ld	hl, sp+26
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	push	de
	ld	hl, sp+26
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	push	de
	ld	hl, sp+24
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_get_fat__far
	ld	hl, sp+4
	ld	[hl], c
	inc	hl
	ld	[hl], b
	inc	hl
	ld	[hl], e
	inc	hl
	ld	[hl], d
;src/fatfs/lib/ff.c:1474: if (nxt == 0) break;				/* Empty cluster? */
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	dec	hl
	or	a, [hl]
	dec	hl
	or	a, [hl]
	jp	Z, .l00126
;src/fatfs/lib/ff.c:1475: if (nxt == 1) return FR_INT_ERR;	/* Internal error? */
	ld	a, [hl]
	dec	a
	inc	hl
	or	a, [hl]
	inc	hl
	or	a, [hl]
	inc	hl
	or	a, [hl]
	jp	NZ,.l00174
	jp	.l00175
.l00174:
	jp	.l00114
.l00175:
	ld	a, $02
	jp	.l00127
.l00114:
;src/fatfs/lib/ff.c:1476: if (nxt == 0xFFFFFFFF) return FR_DISK_ERR;	/* Disk error? */
	ld	hl, sp+4
	ld	a, [hl]
	inc	hl
	and	a, [hl]
	inc	hl
	and	a, [hl]
	inc	hl
	and	a, [hl]
	inc	a
	jp	NZ,.l00176
	jp	.l00177
.l00176:
	jp	.l00119
.l00177:
	ld	a, $01
	jp	.l00127
;src/fatfs/lib/ff.c:1477: if (!FF_FS_EXFAT || fs->fs_type != FS_EXFAT) {
.l00119:
;src/fatfs/lib/ff.c:1478: res = put_fat(fs, clst, 0);		/* Mark the cluster 'free' on the FAT */
	ld	de, $0000
	push	de
	push	de
	ld	hl, sp+30
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	push	de
	ld	hl, sp+30
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	push	de
	ld	hl, sp+8
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_put_fat
;src/fatfs/lib/ff.c:1479: if (res != FR_OK) return res;
	or	a, a
	jp	Z, .l00120
	jp	.l00127
.l00120:
;src/fatfs/lib/ff.c:1481: if (fs->free_clst < fs->n_fatent - 2) {	/* Update allocation information if it is valid */
	pop	de
	push	de
	ld	hl, $0012
	add	hl, de
	ld	c, l
	ld	b, h
	ld	e, c
	ld	d, b
	ld	a, [de]
	ld	hl, sp+8
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
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	ld	hl, sp+12
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
	dec	hl
	dec	hl
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, e
	sub	a, $02
	ld	e, a
	ld	a, d
	sbc	a, $00
	push	af
	ld	hl, sp+19
	ld	[hl], a
	dec	hl
	ld	[hl], e
	dec	hl
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	pop	af
	ld	a, e
	sbc	a, $00
	ld	e, a
	ld	a, d
	sbc	a, $00
	ld	hl, sp+19
	ld	[hl], a
	dec	hl
	ld	[hl], e
	ld	hl, sp+8
	ld	e, l
	ld	d, h
	ld	hl, sp+16
	ld	a, [de]
	inc	de
	sub	a, [hl]
	inc	hl
	ld	a, [de]
	inc	de
	sbc	a, [hl]
	inc	hl
	ld	a, [de]
	inc	de
	sbc	a, [hl]
	inc	hl
	ld	a, [de]
	sbc	a, [hl]
	jp	NC, .l00123
;src/fatfs/lib/ff.c:1482: fs->free_clst++;
	ld	hl, sp+9
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, e
	add	a, $01
	ld	e, a
	ld	a, d
	adc	a, $00
	push	af
	ld	hl, sp+19
	ld	[hl], a
	dec	hl
	ld	[hl], e
	ld	hl, sp+13
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	pop	af
	ld	a, e
	adc	a, $00
	ld	e, a
	ld	a, d
	adc	a, $00
	ld	hl, sp+19
	ld	[hl], a
	dec	hl
	ld	[hl], e
	dec	hl
	dec	hl
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
;src/fatfs/lib/ff.c:1483: fs->fsi_flag |= 1;
	pop	de
	push	de
	ld	hl, $0005
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, [bc]
	set	0, a
	ld	[bc], a
.l00123:
;src/fatfs/lib/ff.c:1503: clst = nxt;					/* Next cluster */
	ld	hl, sp+4
	ld	d, h
	ld	e, l
	ld	hl, sp+24
	ld	a, [de]
	ld	[hl+], a
	inc	de
	ld	a, [de]
	ld	[hl+], a
	inc	de
	ld	a, [de]
	ld	[hl+], a
	inc	de
	ld	a, [de]
	ld	[hl], a
;src/fatfs/lib/ff.c:1504: } while (clst < fs->n_fatent);	/* Repeat until the last link */
	ld	hl, sp+3
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	ld	hl, sp+16
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
	ld	hl, sp+4
	ld	e, l
	ld	d, h
	ld	hl, sp+16
	ld	a, [de]
	inc	de
	sub	a, [hl]
	inc	hl
	ld	a, [de]
	inc	de
	sbc	a, [hl]
	inc	hl
	ld	a, [de]
	inc	de
	sbc	a, [hl]
	inc	hl
	ld	a, [de]
	sbc	a, [hl]
	jp	C, .l00124
.l00126:
;src/fatfs/lib/ff.c:1532: return FR_OK;
	xor	a, a
.l00127:
;src/fatfs/lib/ff.c:1533: }
	add	sp, 22
	pop	hl
	add	sp, 8
	jp hl 
;src/fatfs/lib/ff.c:1542: static DWORD create_chain (	/* 0:No free cluster, 1:Internal error, 0xFFFFFFFF:Disk error, >=2:New cluster# */
;	---------------------------------
	SECTION FRAGMENT "src/fatfs/fatfs.c B",ROMX
; Function create_chain
; ---------------------------------
_create_chain:
	add	sp, -25
	ld	hl, sp+19
	ld	[hl], e
	inc	hl
	ld	[hl], d
;src/fatfs/lib/ff.c:1549: FATFS *fs = obj->fs;
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	ld	hl, sp+0
	ld	[hl], a
	inc	de
	ld	a, [de]
	inc	hl
	ld	[hl], a
;src/fatfs/lib/ff.c:1553: scl = fs->last_clst;				/* Suggested cluster to start to find */
	pop	de
	push	de
	ld	hl, $000E
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+4
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+3
	ld	[hl], a
;src/fatfs/lib/ff.c:1554: if (scl == 0 || scl >= fs->n_fatent) scl = 1;
	pop	de
	push	de
	ld	hl, $0016
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+6
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+5
	ld	[hl], a
;src/fatfs/lib/ff.c:1552: if (clst == 0) {	/* Create a new chain */
	ld	hl, sp+30
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	dec	hl
	or	a, [hl]
	dec	hl
	or	a, [hl]
	jp	NZ, .l00111
;src/fatfs/lib/ff.c:1553: scl = fs->last_clst;				/* Suggested cluster to start to find */
	ld	hl, sp+3
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	ld	hl, sp+6
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
;src/fatfs/lib/ff.c:1554: if (scl == 0 || scl >= fs->n_fatent) scl = 1;
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	dec	hl
	or	a, [hl]
	dec	hl
	or	a, [hl]
	jp	Z, .l00101
	dec	hl
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	ld	hl, sp+21
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
	ld	hl, sp+6
	ld	e, l
	ld	d, h
	ld	hl, sp+21
	ld	a, [de]
	inc	de
	sub	a, [hl]
	inc	hl
	ld	a, [de]
	inc	de
	sbc	a, [hl]
	inc	hl
	ld	a, [de]
	inc	de
	sbc	a, [hl]
	inc	hl
	ld	a, [de]
	sbc	a, [hl]
	jp	C, .l00112
.l00101:
	ld	hl, sp+6
	ld	[hl], $01
	xor	a, a
	inc	hl
	ld	[hl], a
	inc	hl
	ld	[hl], a
	inc	hl
	ld	[hl], a
	jp	.l00112
.l00111:
;src/fatfs/lib/ff.c:1557: cs = get_fat(obj, clst);			/* Check the cluster status */
	ld	hl, sp+29
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	push	de
	ld	hl, sp+29
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	push	de
	ld	hl, sp+23
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_get_fat__far
	ld	hl, sp+15
	ld	[hl], c
	inc	hl
	ld	[hl], b
	inc	hl
	ld	[hl], e
	inc	hl
	ld	[hl], d
;src/fatfs/lib/ff.c:1558: if (cs < 2) return 1;				/* Test for insanity */
	ld	hl, sp+15
	ld	a, [hl]
	sub	a, $02
	inc	hl
	ld	a, [hl]
	sbc	a, $00
	inc	hl
	ld	a, [hl]
	sbc	a, $00
	inc	hl
	ld	a, [hl]
	sbc	a, $00
	jp	NC, .l00105
	ld	bc, $0001
	ld	de, $0000
	jp	.l00152
.l00105:
;src/fatfs/lib/ff.c:1559: if (cs == 0xFFFFFFFF) return cs;	/* Test for disk error */
	ld	hl, sp+15
	ld	a, [hl]
	inc	hl
	and	a, [hl]
	inc	hl
	and	a, [hl]
	inc	hl
	and	a, [hl]
	inc	a
	jp	NZ,.l00281
	jp	.l00282
.l00281:
	jp	.l00107
.l00282:
	ld	hl, sp+15
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	inc	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	jp	.l00152
.l00107:
;src/fatfs/lib/ff.c:1560: if (cs < fs->n_fatent) return cs;	/* It is already followed by next cluster */
	ld	hl, sp+5
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	ld	hl, sp+21
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
	ld	hl, sp+15
	ld	e, l
	ld	d, h
	ld	hl, sp+21
	ld	a, [de]
	inc	de
	sub	a, [hl]
	inc	hl
	ld	a, [de]
	inc	de
	sbc	a, [hl]
	inc	hl
	ld	a, [de]
	inc	de
	sbc	a, [hl]
	inc	hl
	ld	a, [de]
	sbc	a, [hl]
	jp	NC, .l00109
	ld	hl, sp+15
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	inc	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	jp	.l00152
.l00109:
;src/fatfs/lib/ff.c:1561: scl = clst;							/* Cluster to start to find */
	ld	hl, sp+27
	ld	d, h
	ld	e, l
	ld	hl, sp+6
	ld	a, [de]
	ld	[hl+], a
	inc	de
	ld	a, [de]
	ld	[hl+], a
	inc	de
	ld	a, [de]
	ld	[hl+], a
	inc	de
	ld	a, [de]
	ld	[hl], a
.l00112:
;src/fatfs/lib/ff.c:1563: if (fs->free_clst == 0) return 0;		/* No free cluster */
	pop	de
	push	de
	ld	hl, $0012
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+12
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+11
	ld	[hl], a
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	ld	c, a
	inc	de
	ld	a, [de]
	ld	b, a
	inc	de
	ld	a, [de]
	ld	l, a
;	spillPairReg hl
;	spillPairReg hl
	inc	de
	ld	a, [de]
	ld	h, a
;	spillPairReg hl
;	spillPairReg hl
	ld	a, h
	or	a, l
	or	a, b
	or	a, c
	jp	NZ, .l00114
	ld	bc, $0000
	ld	de, $0000
	jp	.l00152
.l00114:
;src/fatfs/lib/ff.c:1592: ncl = 0;
	xor	a, a
	ld	hl, sp+21
	ld	[hl], a
	inc	hl
	ld	[hl], a
	inc	hl
	ld	[hl], a
	inc	hl
	ld	[hl], a
;src/fatfs/lib/ff.c:1593: if (scl == clst) {						/* Stretching an existing chain? */
	ld	hl, sp+6
	ld	a, [hl]
	ld	hl, sp+27
	sub	a, [hl]
	jp	NZ,.l00283
	ld	hl, sp+7
	ld	a, [hl]
	ld	hl, sp+28
	sub	a, [hl]
	jp	NZ,.l00283
	ld	hl, sp+8
	ld	a, [hl]
	ld	hl, sp+29
	sub	a, [hl]
	jp	NZ,.l00283
	ld	hl, sp+9
	ld	a, [hl]
	ld	hl, sp+30
	sub	a, [hl]
	jp	NZ,.l00283
	jp	.l00284
.l00283:
	jp	.l00126
.l00284:
;src/fatfs/lib/ff.c:1594: ncl = scl + 1;						/* Test if next cluster is free */
	ld	hl, sp+7
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, e
	add	a, $01
	ld	e, a
	ld	a, d
	adc	a, $00
	push	af
	ld	hl, sp+24
	ld	[hl], a
	dec	hl
	ld	[hl], e
	ld	hl, sp+11
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	pop	af
	ld	a, e
	adc	a, $00
	ld	e, a
	ld	a, d
	adc	a, $00
	ld	hl, sp+24
	ld	[hl], a
	dec	hl
	ld	[hl], e
;src/fatfs/lib/ff.c:1595: if (ncl >= fs->n_fatent) ncl = 2;
	ld	hl, sp+5
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	ld	hl, sp+15
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
	ld	hl, sp+21
	ld	e, l
	ld	d, h
	ld	hl, sp+15
	ld	a, [de]
	inc	de
	sub	a, [hl]
	inc	hl
	ld	a, [de]
	inc	de
	sbc	a, [hl]
	inc	hl
	ld	a, [de]
	inc	de
	sbc	a, [hl]
	inc	hl
	ld	a, [de]
	sbc	a, [hl]
	jp	C, .l00116
	ld	hl, sp+21
	ld	[hl], $02
	xor	a, a
	inc	hl
	ld	[hl], a
	inc	hl
	ld	[hl], a
	inc	hl
	ld	[hl], a
.l00116:
;src/fatfs/lib/ff.c:1596: cs = get_fat(obj, ncl);				/* Get next cluster status */
	ld	hl, sp+23
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	push	de
	ld	hl, sp+23
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	push	de
	ld	hl, sp+23
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_get_fat__far
;src/fatfs/lib/ff.c:1597: if (cs == 1 || cs == 0xFFFFFFFF) return cs;	/* Test for error */
	ld	a, c
	dec	a
	or	a, b
	or	a, e
	or	a, d
	jp	NZ,.l00285
	jp	.l00117
.l00285:
	ld	a, c
	and	a, b
	and	a, e
	and	a, d
	inc	a
	jp	NZ,.l00286
	jp	.l00287
.l00286:
	jp	.l00118
.l00287:
.l00117:
	jp	.l00152
.l00118:
;src/fatfs/lib/ff.c:1598: if (cs != 0) {						/* Not free? */
	ld	a, d
	or	a, e
	or	a, b
	or	a, c
	jp	Z, .l00126
;src/fatfs/lib/ff.c:1599: cs = fs->last_clst;				/* Start at suggested cluster if it is valid */
	ld	hl, sp+3
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	ld	hl, sp+15
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
;src/fatfs/lib/ff.c:1600: if (cs >= 2 && cs < fs->n_fatent) scl = cs;
	ld	hl, sp+15
	ld	a, [hl]
	sub	a, $02
	inc	hl
	ld	a, [hl]
	sbc	a, $00
	inc	hl
	ld	a, [hl]
	sbc	a, $00
	inc	hl
	ld	a, [hl]
	sbc	a, $00
	jp	C, .l00121
	ld	hl, sp+5
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	ld	hl, sp+21
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
	ld	hl, sp+15
	ld	e, l
	ld	d, h
	ld	hl, sp+21
	ld	a, [de]
	inc	de
	sub	a, [hl]
	inc	hl
	ld	a, [de]
	inc	de
	sbc	a, [hl]
	inc	hl
	ld	a, [de]
	inc	de
	sbc	a, [hl]
	inc	hl
	ld	a, [de]
	sbc	a, [hl]
	jp	NC, .l00121
	ld	hl, sp+15
	ld	d, h
	ld	e, l
	ld	hl, sp+6
	ld	a, [de]
	ld	[hl+], a
	inc	de
	ld	a, [de]
	ld	[hl+], a
	inc	de
	ld	a, [de]
	ld	[hl+], a
	inc	de
	ld	a, [de]
	ld	[hl], a
.l00121:
;src/fatfs/lib/ff.c:1601: ncl = 0;
	xor	a, a
	ld	hl, sp+21
	ld	[hl], a
	inc	hl
	ld	[hl], a
	inc	hl
	ld	[hl], a
	inc	hl
	ld	[hl], a
.l00126:
;src/fatfs/lib/ff.c:1604: if (ncl == 0) {	/* The new cluster cannot be contiguous and find another fragment */
	ld	hl, sp+24
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	dec	hl
	or	a, [hl]
	dec	hl
	or	a, [hl]
	jp	NZ, .l00140
;src/fatfs/lib/ff.c:1605: ncl = scl;	/* Start cluster */
	ld	hl, sp+6
	ld	d, h
	ld	e, l
	ld	hl, sp+21
	ld	a, [de]
	ld	[hl+], a
	inc	de
	ld	a, [de]
	ld	[hl+], a
	inc	de
	ld	a, [de]
	ld	[hl+], a
	inc	de
	ld	a, [de]
	ld	[hl], a
	ld	hl, sp+6
	ld	a, [hl]
	sub	a, $02
	inc	hl
	ld	a, [hl]
	sbc	a, $00
	inc	hl
	ld	a, [hl]
	sbc	a, $00
	inc	hl
	ld	a, [hl]
	sbc	a, $00
	ld	a, $00
	rla
	ld	hl, sp+12
	ld	[hl], a
	ld	hl, sp+4
	ld	a, [hl]
	ld	hl, sp+13
	ld	[hl], a
	ld	hl, sp+5
	ld	a, [hl]
	ld	hl, sp+14
	ld	[hl], a
.l00150:
;src/fatfs/lib/ff.c:1607: ncl++;							/* Next cluster */
	ld	hl, sp+21
	inc	[hl]
	jp	NZ, .l00288
	inc	hl
	inc	[hl]
	jp	NZ, .l00288
	inc	hl
	inc	[hl]
	jp	NZ, .l00288
	inc	hl
	inc	[hl]
.l00288:
;src/fatfs/lib/ff.c:1608: if (ncl >= fs->n_fatent) {		/* Check wrap-around */
	ld	hl, sp+14
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
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
	inc	de
	ld	a, [de]
	inc	hl
	ld	[hl], a
	ld	hl, sp+21
	ld	e, l
	ld	d, h
	ld	hl, sp+15
	ld	a, [de]
	inc	de
	sub	a, [hl]
	inc	hl
	ld	a, [de]
	inc	de
	sbc	a, [hl]
	inc	hl
	ld	a, [de]
	inc	de
	sbc	a, [hl]
	inc	hl
	ld	a, [de]
	sbc	a, [hl]
	jp	C, .l00130
;src/fatfs/lib/ff.c:1609: ncl = 2;
	ld	hl, sp+21
	ld	[hl], $02
	xor	a, a
	inc	hl
	ld	[hl], a
	inc	hl
	ld	[hl], a
	inc	hl
	ld	[hl], a
;src/fatfs/lib/ff.c:1610: if (ncl > scl) return 0;	/* No free cluster found? */
	ld	hl, sp+12
	ld	a, [hl]
	or	a, a
	jp	Z, .l00130
	ld	bc, $0000
	ld	de, $0000
	jp	.l00152
.l00130:
;src/fatfs/lib/ff.c:1612: cs = get_fat(obj, ncl);			/* Get the cluster status */
	ld	hl, sp+23
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	push	de
	ld	hl, sp+23
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	push	de
	ld	hl, sp+23
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_get_fat__far
;src/fatfs/lib/ff.c:1613: if (cs == 0) break;				/* Found a free cluster? */
	ld	a, d
	or	a, e
	or	a, b
	or	a, c
	jp	Z, .l00140
;src/fatfs/lib/ff.c:1614: if (cs == 1 || cs == 0xFFFFFFFF) return cs;	/* Test for error */
	ld	a, c
	dec	a
	or	a, b
	or	a, e
	or	a, d
	jp	NZ,.l00289
	jp	.l00133
.l00289:
	ld	a, c
	and	a, b
	and	a, e
	and	a, d
	inc	a
	jp	NZ,.l00290
	jp	.l00291
.l00290:
	jp	.l00134
.l00291:
.l00133:
	jp	.l00152
.l00134:
;src/fatfs/lib/ff.c:1615: if (ncl == scl) return 0;		/* No free cluster found? */
	ld	hl, sp+21
	ld	a, [hl]
	ld	hl, sp+6
	sub	a, [hl]
	jp	NZ,.l00292
	ld	hl, sp+22
	ld	a, [hl]
	ld	hl, sp+7
	sub	a, [hl]
	jp	NZ,.l00292
	ld	hl, sp+23
	ld	a, [hl]
	ld	hl, sp+8
	sub	a, [hl]
	jp	NZ,.l00292
	ld	hl, sp+24
	ld	a, [hl]
	ld	hl, sp+9
	sub	a, [hl]
	jp	NZ,.l00292
	jp	.l00293
.l00292:
	jp	.l00150
.l00293:
	ld	bc, $0000
	ld	de, $0000
	jp	.l00152
.l00140:
;src/fatfs/lib/ff.c:1618: res = put_fat(fs, ncl, 0xFFFFFFFF);		/* Mark the new cluster 'EOC' */
	ld	de, $FFFF
	push	de
	push	de
	ld	hl, sp+27
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	push	de
	ld	hl, sp+27
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	push	de
	ld	hl, sp+8
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_put_fat
	ld	c, a
;src/fatfs/lib/ff.c:1619: if (res == FR_OK && clst != 0) {
	ld	a, c
	or	a, a
	jp	NZ, .l00142
	ld	hl, sp+30
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	dec	hl
	or	a, [hl]
	dec	hl
	or	a, [hl]
	jp	Z, .l00142
;src/fatfs/lib/ff.c:1620: res = put_fat(fs, clst, ncl);		/* Link it from the previous one if needed */
	ld	hl, sp+23
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	push	de
	ld	hl, sp+23
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	push	de
	ld	hl, sp+33
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	push	de
	ld	hl, sp+33
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	push	de
	ld	hl, sp+8
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_put_fat
	ld	c, a
.l00142:
;src/fatfs/lib/ff.c:1624: if (res == FR_OK) {			/* Update allocation information if the function succeeded */
	ld	a, c
	or	a, a
	jp	NZ, .l00148
;src/fatfs/lib/ff.c:1625: fs->last_clst = ncl;
	pop	bc
	pop	de
	push	de
	push	bc
	ld	hl, sp+21
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
;src/fatfs/lib/ff.c:1626: if (fs->free_clst > 0 && fs->free_clst <= fs->n_fatent - 2) {
	ld	hl, sp+11
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	ld	hl, sp+6
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
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	dec	hl
	or	a, [hl]
	dec	hl
	or	a, [hl]
	jp	Z, .l00149
	dec	hl
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	ld	hl, sp+15
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
	dec	hl
	dec	hl
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, e
	sub	a, $02
	ld	e, a
	ld	a, d
	sbc	a, $00
	push	af
	ld	hl, sp+5
	ld	[hl], a
	dec	hl
	ld	[hl], e
	ld	hl, sp+20
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	pop	af
	ld	a, e
	sbc	a, $00
	ld	e, a
	ld	a, d
	sbc	a, $00
	ld	hl, sp+5
	ld	[hl], a
	dec	hl
	ld	[hl], e
	ld	hl, sp+2
	ld	e, l
	ld	d, h
	ld	hl, sp+6
	ld	a, [de]
	inc	de
	sub	a, [hl]
	inc	hl
	ld	a, [de]
	inc	de
	sbc	a, [hl]
	inc	hl
	ld	a, [de]
	inc	de
	sbc	a, [hl]
	inc	hl
	ld	a, [de]
	sbc	a, [hl]
	jp	C, .l00149
;src/fatfs/lib/ff.c:1627: fs->free_clst--;
	ld	hl, sp+7
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, e
	sub	a, $01
	ld	e, a
	ld	a, d
	sbc	a, $00
	push	af
	ld	hl, sp+18
	ld	[hl], a
	dec	hl
	ld	[hl], e
	ld	hl, sp+11
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	pop	af
	ld	a, e
	sbc	a, $00
	ld	e, a
	ld	a, d
	sbc	a, $00
	ld	hl, sp+18
	ld	[hl], a
	dec	hl
	ld	[hl], e
	ld	hl, sp+11
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, sp+15
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
;src/fatfs/lib/ff.c:1628: fs->fsi_flag |= 1;
	pop	de
	push	de
	ld	hl, $0005
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, [bc]
	set	0, a
	ld	[bc], a
	jp	.l00149
.l00148:
;src/fatfs/lib/ff.c:1631: ncl = (res == FR_DISK_ERR) ? 0xFFFFFFFF : 1;	/* Failed. Generate error status */
	dec	c
	jp	NZ,.l00294
	jp	.l00295
.l00294:
	jp	.l00154
.l00295:
	ld	bc, $FFFF
	ld	de, $FFFF
	jp	.l00155
.l00154:
	ld	bc, $0001
	ld	de, $0000
.l00155:
	ld	hl, sp+21
	ld	[hl], c
	inc	hl
	ld	[hl], b
	inc	hl
	ld	[hl], e
	inc	hl
	ld	[hl], d
.l00149:
;src/fatfs/lib/ff.c:1634: return ncl;		/* Return new cluster number or error status */
	ld	hl, sp+21
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	inc	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
.l00152:
;src/fatfs/lib/ff.c:1635: }
	add	sp, 25
	pop	hl
	add	sp, 4
	jp hl 
;src/fatfs/lib/ff.c:1678: static FRESULT dir_clear (	/* Returns FR_OK or FR_DISK_ERR */
;	---------------------------------
	SECTION FRAGMENT "src/fatfs/fatfs.c B",ROMX
; Function dir_clear
; ---------------------------------
_dir_clear:
	add	sp, -24
	ld	hl, sp+20
	ld	[hl], e
	inc	hl
	ld	[hl], d
;src/fatfs/lib/ff.c:1688: if (sync_window(fs) != FR_OK) return FR_DISK_ERR;	/* Flush disk access window */
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_sync_window
	ld	hl, sp+23
	ld	[hl], a
	ld	hl, sp+23
	ld	a, [hl]
	or	a, a
	jp	Z, .l00102
	ld	a, $01
	jp	.l00108
.l00102:
;src/fatfs/lib/ff.c:1689: sect = clst2sect(fs, clst);		/* Top of the cluster */
	ld	hl, sp+28
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	push	de
	ld	hl, sp+28
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	push	de
	ld	hl, sp+24
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_clst2sect__far
	ld	hl, sp+16
	ld	[hl], c
	inc	hl
	ld	[hl], b
	inc	hl
	ld	[hl], e
	inc	hl
	ld	[hl], d
	ld	hl, sp+16
	ld	d, h
	ld	e, l
	ld	hl, sp+0
	ld	a, [de]
	ld	[hl+], a
	inc	de
	ld	a, [de]
	ld	[hl+], a
	inc	de
	ld	a, [de]
	ld	[hl+], a
	inc	de
	ld	a, [de]
	ld	[hl], a
;src/fatfs/lib/ff.c:1690: fs->winsect = sect;				/* Set window to top of the cluster */
	ld	hl, sp+21
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $001E
	add	hl, de
	ld	c, l
	ld	b, h
	ld	hl, sp+0
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
;src/fatfs/lib/ff.c:1691: memset(fs->win, 0, sizeof fs->win);	/* Clear window buffer */
	ld	hl, sp+21
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $0032
	add	hl, de
	ld	e, l
	ld	d, h
	ld	l, e
;	spillPairReg hl
;	spillPairReg hl
	ld	h, d
;	spillPairReg hl
;	spillPairReg hl
	push	de
	ld	bc, $0200
	push	bc
	ld	bc, $0000
	ld	e, l
	ld	d, h
	call	_memset
	pop	de
;src/fatfs/lib/ff.c:1703: ibuf = fs->win; szb = 1;	/* Use window buffer (many single-sector writes may take a time) */
	ld	hl, sp+4
	ld	[hl], e
	inc	hl
	ld	[hl], d
;src/fatfs/lib/ff.c:1704: for (n = 0; n < fs->csize && disk_write(fs->pdrv, ibuf, sect + n, szb) == RES_OK; n += szb) ;	/* Fill the cluster with 0 */
	ld	hl, sp+21
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $0001
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+8
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+7
	ld	[hl], a
	ld	hl, sp+21
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $000A
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+10
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+9
	ld	[hl], a
	xor	a, a
	ld	hl, sp+22
	ld	[hl], a
	inc	hl
	ld	[hl], a
.l00106:
	ld	hl, sp+9
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	ld	c, a
	inc	de
	ld	a, [de]
	ld	b, a
	ld	hl, sp+22
	ld	a, [hl]
	ld	hl, sp+10
	ld	[hl], a
	ld	hl, sp+23
	ld	a, [hl]
	ld	hl, sp+11
	ld	[hl], a
	dec	hl
	ld	a, [hl]
	sub	a, c
	inc	hl
	ld	a, [hl]
	sbc	a, b
	jp	NC, .l00103
	ld	hl, sp+22
	ld	a, [hl]
	ld	hl, sp+12
	ld	[hl], a
	ld	hl, sp+23
	ld	a, [hl]
	ld	hl, sp+13
	ld	[hl], a
	xor	a, a
	inc	hl
	ld	[hl], a
	inc	hl
	ld	[hl], a
	pop	de
	push	de
	ld	a, e
	ld	hl, sp+12
	add	a, [hl]
	ld	e, a
	ld	a, d
	inc	hl
	adc	a, [hl]
	push	af
	ld	hl, sp+19
	ld	[hl], a
	dec	hl
	ld	[hl], e
	ld	hl, sp+5
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, sp+16
	pop	af
	ld	a, e
	adc	a, [hl]
	ld	e, a
	ld	a, d
	inc	hl
	adc	a, [hl]
	ld	hl, sp+19
	ld	[hl], a
	dec	hl
	ld	[hl], e
	ld	hl, sp+7
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	ld	c, a
	ld	de, $0001
	push	de
	ld	hl, sp+20
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	push	de
	ld	hl, sp+20
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	push	de
	ld	hl, sp+10
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, c
	call	_disk_write
	or	a, a
	jp	NZ, .l00103
	ld	hl, sp+22
	inc	[hl]
	jp	NZ, .l00138
	inc	hl
	inc	[hl]
.l00138:
	jp	.l00106
.l00103:
;src/fatfs/lib/ff.c:1706: return (n == fs->csize) ? FR_OK : FR_DISK_ERR;
	ld	hl, sp+9
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	ld	c, a
	inc	de
	ld	a, [de]
	ld	b, a
	inc	hl
	ld	a, [hl]
	sub	a, c
	jp	NZ,.l00139
	inc	hl
	ld	a, [hl]
	sub	a, b
	jp	NZ,.l00139
	jp	.l00140
.l00139:
	jp	.l00110
.l00140:
	xor	a, a
	ld	c, a
	jp	.l00111
.l00110:
	ld	a, $01
	ld	c, $00
.l00111:
.l00108:
;src/fatfs/lib/ff.c:1707: }
	add	sp, 24
	pop	hl
	add	sp, 4
	jp hl 
;src/fatfs/lib/ff.c:1717: static FRESULT dir_sdi (	/* FR_OK(0):succeeded, !=0:error */
;	---------------------------------
	SECTION FRAGMENT "src/fatfs/fatfs.c A",ROMX
; Function dir_sdi
; ---------------------------------
_dir_sdi:
	add	sp, -20
	ld	hl, sp+18
	ld	[hl], e
	inc	hl
	ld	[hl], d
;src/fatfs/lib/ff.c:1723: FATFS *fs = dp->obj.fs;
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	ld	hl, sp+0
	ld	[hl], a
	inc	de
	ld	a, [de]
	inc	hl
	ld	[hl], a
;src/fatfs/lib/ff.c:1726: if (ofs >= (DWORD)((FF_FS_EXFAT && fs->fs_type == FS_EXFAT) ? MAX_DIR_EX : MAX_DIR) || ofs % SZDIRE) {	/* Check range of offset and alignment */
	ld	hl, sp+22
	ld	a, [hl]
	sub	a, $00
	inc	hl
	ld	a, [hl]
	sbc	a, $00
	inc	hl
	ld	a, [hl]
	sbc	a, $20
	inc	hl
	ld	a, [hl]
	sbc	a, $00
	jp	NC, .l00101
	ld	hl, sp+22
	ld	a, [hl]
	and	a, $1F
	jp	NZ,.l00182
	jp	.l00102
.l00182:
.l00101:
;src/fatfs/lib/ff.c:1727: return FR_INT_ERR;
	ld	a, $02
	jp	.l00124
.l00102:
;src/fatfs/lib/ff.c:1729: dp->dptr = ofs;				/* Set current offset */
	ld	hl, sp+19
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $000E
	add	hl, de
	ld	c, l
	ld	b, h
	ld	hl, sp+22
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
;src/fatfs/lib/ff.c:1730: clst = dp->obj.sclust;		/* Table start cluster (0:root) */
	ld	hl, sp+19
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $0006
	add	hl, de
	ld	c, l
	ld	b, h
	ld	e, c
	ld	d, b
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
;src/fatfs/lib/ff.c:1732: clst = (DWORD)fs->dirbase;
	pop	de
	push	de
	ld	hl, $002A
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+10
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+9
	ld	[hl], a
;src/fatfs/lib/ff.c:1731: if (clst == 0 && fs->fs_type >= FS_FAT32) {	/* Replace cluster# 0 with root cluster# */
	ld	hl, sp+5
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	dec	hl
	or	a, [hl]
	dec	hl
	or	a, [hl]
	jp	NZ, .l00107
	pop	de
	push	de
	ld	a, [de]
	sub	a, $03
	jp	C, .l00107
;src/fatfs/lib/ff.c:1732: clst = (DWORD)fs->dirbase;
	ld	hl, sp+9
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
;src/fatfs/lib/ff.c:1733: if (FF_FS_EXFAT) dp->obj.stat = 0;	/* exFAT: Root dir has an FAT chain */
.l00107:
;src/fatfs/lib/ff.c:1738: dp->sect = fs->dirbase;
	ld	hl, sp+19
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $0016
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+8
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+7
	ld	[hl], a
;src/fatfs/lib/ff.c:1736: if (clst == 0) {	/* Static table (root-directory on the FAT volume) */
	dec	hl
	dec	hl
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	dec	hl
	or	a, [hl]
	dec	hl
	or	a, [hl]
	jp	NZ, .l00120
;src/fatfs/lib/ff.c:1737: if (ofs / SZDIRE >= fs->n_rootdir) return FR_INT_ERR;	/* Is index out of range? */
	ld	hl, sp+22
	ld	a, [hl]
	ld	hl, sp+10
	ld	[hl], a
	ld	hl, sp+23
	ld	a, [hl]
	ld	hl, sp+11
	ld	[hl], a
	ld	hl, sp+24
	ld	a, [hl]
	ld	hl, sp+12
	ld	[hl], a
	ld	hl, sp+25
	ld	a, [hl]
	ld	hl, sp+13
	ld	[hl], a
	ld	a, $05
.l00183:
	ld	hl, sp+13
	srl	[hl]
	dec	hl
	rr	[hl]
	dec	hl
	rr	[hl]
	dec	hl
	rr	[hl]
.l00184:
	dec	a
	jr	NZ, .l00183
	pop	de
	push	de
	ld	hl, $0008
	add	hl, de
	ld	c, l
	ld	a, h
	ld	l, c
	ld	h, a
	ld	c, [hl]
	inc	hl
	ld	a, [hl]
	ld	hl, sp+14
	ld	[hl], c
	inc	hl
	ld	[hl], a
	xor	a, a
	inc	hl
	ld	[hl], a
	inc	hl
	ld	[hl], a
	ld	hl, sp+10
	ld	e, l
	ld	d, h
	ld	hl, sp+14
	ld	a, [de]
	inc	de
	sub	a, [hl]
	inc	hl
	ld	a, [de]
	inc	de
	sbc	a, [hl]
	inc	hl
	ld	a, [de]
	inc	de
	sbc	a, [hl]
	inc	hl
	ld	a, [de]
	sbc	a, [hl]
	jp	C, .l00110
	ld	a, $02
	jp	.l00124
.l00110:
;src/fatfs/lib/ff.c:1738: dp->sect = fs->dirbase;
	ld	hl, sp+9
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	ld	hl, sp+14
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
	ld	hl, sp+7
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, sp+14
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
	jp	.l00121
.l00120:
;src/fatfs/lib/ff.c:1741: csz = (DWORD)fs->csize * SS(fs);	/* Bytes per cluster */
	pop	de
	push	de
	ld	hl, $000A
	add	hl, de
	ld	c, l
	ld	a, h
	ld	l, c
	ld	h, a
	ld	c, [hl]
	inc	hl
	ld	a, [hl]
	ld	de, $0000
	ld	d, e
	ld	e, a
	ld	a, c
	ld	c, $00
	add	a, a
	rl	e
	rl	d
	ld	hl, sp+8
	ld	[hl], c
	inc	hl
	ld	[hl], a
	inc	hl
	ld	[hl], e
	inc	hl
	ld	[hl], d
;src/fatfs/lib/ff.c:1742: while (ofs >= csz) {				/* Follow cluster chain */
	pop	de
	push	de
	ld	hl, $0016
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+14
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+13
	ld	[hl], a
.l00116:
	ld	hl, sp+22
	ld	e, l
	ld	d, h
	ld	hl, sp+8
	ld	a, [de]
	inc	de
	sub	a, [hl]
	inc	hl
	ld	a, [de]
	inc	de
	sbc	a, [hl]
	inc	hl
	ld	a, [de]
	inc	de
	sbc	a, [hl]
	inc	hl
	ld	a, [de]
	sbc	a, [hl]
	jp	C, .l00118
;src/fatfs/lib/ff.c:1743: clst = get_fat(&dp->obj, clst);				/* Get next cluster */
	ld	hl, sp+4
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	push	de
	ld	hl, sp+4
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	push	de
	ld	hl, sp+22
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_get_fat
	ld	hl, sp+2
	ld	[hl], c
	inc	hl
	ld	[hl], b
	inc	hl
	ld	[hl], e
	inc	hl
	ld	[hl], d
;src/fatfs/lib/ff.c:1744: if (clst == 0xFFFFFFFF) return FR_DISK_ERR;	/* Disk error */
	ld	hl, sp+2
	ld	a, [hl]
	inc	hl
	and	a, [hl]
	inc	hl
	and	a, [hl]
	inc	hl
	and	a, [hl]
	inc	a
	jp	NZ,.l00187
	jp	.l00188
.l00187:
	jp	.l00112
.l00188:
	ld	a, $01
	jp	.l00124
.l00112:
;src/fatfs/lib/ff.c:1745: if (clst < 2 || clst >= fs->n_fatent) return FR_INT_ERR;	/* Reached to end of table or internal error */
	ld	hl, sp+2
	ld	a, [hl]
	sub	a, $02
	inc	hl
	ld	a, [hl]
	sbc	a, $00
	inc	hl
	ld	a, [hl]
	sbc	a, $00
	inc	hl
	ld	a, [hl]
	sbc	a, $00
	jp	C, .l00113
	ld	hl, sp+13
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
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
	inc	de
	ld	a, [de]
	inc	hl
	ld	[hl], a
	ld	hl, sp+2
	ld	e, l
	ld	d, h
	ld	hl, sp+14
	ld	a, [de]
	inc	de
	sub	a, [hl]
	inc	hl
	ld	a, [de]
	inc	de
	sbc	a, [hl]
	inc	hl
	ld	a, [de]
	inc	de
	sbc	a, [hl]
	inc	hl
	ld	a, [de]
	sbc	a, [hl]
	jp	C, .l00114
.l00113:
	ld	a, $02
	jp	.l00124
.l00114:
;src/fatfs/lib/ff.c:1746: ofs -= csz;
	ld	hl, sp+23
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, e
	ld	hl, sp+8
	sub	a, [hl]
	ld	e, a
	ld	a, d
	inc	hl
	sbc	a, [hl]
	push	af
	ld	hl, sp+25
	ld	[hl], a
	dec	hl
	ld	[hl], e
	ld	hl, sp+27
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, sp+12
	pop	af
	ld	a, e
	sbc	a, [hl]
	ld	e, a
	ld	a, d
	inc	hl
	sbc	a, [hl]
	ld	hl, sp+25
	ld	[hl], a
	dec	hl
	ld	[hl], e
	jp	.l00116
.l00118:
;src/fatfs/lib/ff.c:1748: dp->sect = clst2sect(fs, clst);
	ld	hl, sp+4
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	push	de
	ld	hl, sp+4
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	push	de
	ld	hl, sp+4
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_clst2sect
	ld	hl, sp+14
	ld	[hl], c
	inc	hl
	ld	[hl], b
	inc	hl
	ld	[hl], e
	inc	hl
	ld	[hl], d
	ld	hl, sp+7
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, sp+14
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
.l00121:
;src/fatfs/lib/ff.c:1750: dp->clust = clst;					/* Current cluster# */
	ld	hl, sp+19
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $0012
	add	hl, de
	ld	c, l
	ld	b, h
	ld	hl, sp+2
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
;src/fatfs/lib/ff.c:1751: if (dp->sect == 0) return FR_INT_ERR;
	inc	hl
	inc	hl
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
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	dec	hl
	or	a, [hl]
	dec	hl
	or	a, [hl]
	jp	NZ, .l00123
	ld	a, $02
	jp	.l00124
.l00123:
;src/fatfs/lib/ff.c:1752: dp->sect += ofs / SS(fs);			/* Sector# of the directory entry */
	ld	hl, sp+23
	ld	a, [hl]
	ld	hl, sp+10
	ld	[hl], a
	ld	hl, sp+24
	ld	a, [hl]
	ld	hl, sp+11
	ld	[hl], a
	ld	hl, sp+25
	ld	a, [hl]
	ld	hl, sp+12
	ld	[hl], a
	inc	hl
	ld	[hl], $00
	dec	hl
	srl	[hl]
	dec	hl
	rr	[hl]
	dec	hl
	rr	[hl]
	ld	hl, sp+3
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, e
	ld	hl, sp+10
	add	a, [hl]
	ld	e, a
	ld	a, d
	inc	hl
	adc	a, [hl]
	push	af
	ld	hl, sp+17
	ld	[hl], a
	dec	hl
	ld	[hl], e
	ld	hl, sp+7
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, sp+14
	pop	af
	ld	a, e
	adc	a, [hl]
	ld	e, a
	ld	a, d
	inc	hl
	adc	a, [hl]
	ld	hl, sp+17
	ld	[hl], a
	dec	hl
	ld	[hl], e
	ld	hl, sp+7
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, sp+14
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
;src/fatfs/lib/ff.c:1753: dp->dir = fs->win + (ofs % SS(fs));	/* Pointer to the entry in the win[] */
	inc	hl
	inc	hl
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $001A
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+16
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+15
	ld	[hl], a
	pop	de
	push	de
	ld	hl, $0032
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+18
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+17
	ld	[hl], a
	ld	hl, sp+22
	ld	a, [hl]
	ld	hl, sp+8
	ld	[hl], a
	ld	hl, sp+23
	ld	a, [hl]
	and	a, $01
	ld	hl, sp+9
	ld	[hl], a
	xor	a, a
	inc	hl
	ld	[hl], a
	inc	hl
	ld	[hl], a
	dec	hl
	dec	hl
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, sp+16
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+14
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+13
	ld	[hl], a
	inc	hl
	inc	hl
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, sp+12
	ld	a, [hl]
	ld	[de], a
	inc	de
	inc	hl
	ld	a, [hl]
	ld	[de], a
;src/fatfs/lib/ff.c:1755: return FR_OK;
	xor	a, a
.l00124:
;src/fatfs/lib/ff.c:1756: }
	add	sp, 20
	pop	hl
	add	sp, 4
	jp hl 
;src/fatfs/lib/ff.c:1765: static FRESULT dir_next (	/* FR_OK(0):succeeded, FR_NO_FILE:End of table, FR_DENIED:Could not stretch */
;	---------------------------------
	SECTION FRAGMENT "src/fatfs/fatfs.c A",ROMX
; Function dir_next
; ---------------------------------
_dir_next:
	add	sp, -30
	ld	hl, sp+28
	ld	[hl], e
	inc	hl
	ld	[hl], d
	ld	hl, sp+26
	ld	[hl], c
	inc	hl
	ld	[hl], b
;src/fatfs/lib/ff.c:1771: FATFS *fs = dp->obj.fs;
	inc	hl
	inc	hl
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	ld	hl, sp+4
	ld	[hl], a
	inc	de
	ld	a, [de]
	inc	hl
	ld	[hl], a
;src/fatfs/lib/ff.c:1774: ofs = dp->dptr + SZDIRE;	/* Next entry */
	ld	hl, sp+29
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $000E
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+8
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+7
	ld	[hl], a
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	ld	hl, sp+22
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
	dec	hl
	dec	hl
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, e
	add	a, $20
	ld	e, a
	ld	a, d
	adc	a, $00
	push	af
	ld	hl, sp+11
	ld	[hl], a
	dec	hl
	ld	[hl], e
	ld	hl, sp+27
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	pop	af
	ld	a, e
	adc	a, $00
	ld	e, a
	ld	a, d
	adc	a, $00
	ld	hl, sp+11
	ld	[hl], a
	dec	hl
	ld	[hl], e
;src/fatfs/lib/ff.c:1775: if (ofs >= (DWORD)((FF_FS_EXFAT && fs->fs_type == FS_EXFAT) ? MAX_DIR_EX : MAX_DIR)) dp->sect = 0;	/* Disable it if the offset reached the max value */
	ld	hl, sp+29
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $0016
	add	hl, de
	ld	c, l
	ld	b, h
	ld	hl, sp+8
	ld	a, [hl]
	sub	a, $00
	inc	hl
	ld	a, [hl]
	sbc	a, $00
	inc	hl
	ld	a, [hl]
	sbc	a, $20
	inc	hl
	ld	a, [hl]
	sbc	a, $00
	jp	C, .l00102
	ld	l, c
	ld	h, b
	xor	a, a
	ld	[hl], a
	inc	hl
	ld	[hl], a
	inc	hl
	ld	[hl], a
	inc	hl
	ld	[hl], a
.l00102:
;src/fatfs/lib/ff.c:1776: if (dp->sect == 0) return FR_NO_FILE;	/* Report EOT if it has been disabled */
	ld	e, c
	ld	d, b
	ld	a, [de]
	ld	hl, sp+18
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
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	dec	hl
	or	a, [hl]
	dec	hl
	or	a, [hl]
	jp	NZ, .l00104
	ld	a, $04
	jp	.l00132
.l00104:
;src/fatfs/lib/ff.c:1778: if (ofs % SS(fs) == 0) {	/* Sector changed? */
	ld	hl, sp+8
	ld	a, [hl]
	ld	hl, sp+12
	ld	[hl], a
	ld	hl, sp+9
	ld	a, [hl]
	and	a, $01
	ld	hl, sp+13
	ld	[hl], a
	xor	a, a
	inc	hl
	ld	[hl], a
	inc	hl
	ld	[hl], a
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	dec	hl
	or	a, [hl]
	dec	hl
	or	a, [hl]
	jp	NZ, .l00131
;src/fatfs/lib/ff.c:1779: dp->sect++;				/* Next sector */
	ld	hl, sp+19
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, e
	add	a, $01
	ld	e, a
	ld	a, d
	adc	a, $00
	push	af
	ld	hl, sp+25
	ld	[hl], a
	dec	hl
	ld	[hl], e
	dec	hl
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	pop	af
	ld	a, e
	adc	a, $00
	ld	e, a
	ld	a, d
	adc	a, $00
	ld	hl, sp+25
	ld	[hl], a
	dec	hl
	ld	[hl], e
	ld	e, c
	ld	d, b
	dec	hl
	dec	hl
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
;src/fatfs/lib/ff.c:1781: if (dp->clust == 0) {	/* Static table */
	ld	hl, sp+29
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $0012
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+18
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+17
	ld	[hl], a
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	ld	hl, sp+0
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
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	dec	hl
	or	a, [hl]
	dec	hl
	or	a, [hl]
	jp	NZ, .l00128
;src/fatfs/lib/ff.c:1782: if (ofs / SZDIRE >= fs->n_rootdir) {	/* Report EOT if it reached end of static table */
	ld	hl, sp+8
	ld	a, [hl]
	ld	hl, sp+18
	ld	[hl], a
	ld	hl, sp+9
	ld	a, [hl]
	ld	hl, sp+19
	ld	[hl], a
	ld	hl, sp+10
	ld	a, [hl]
	ld	hl, sp+20
	ld	[hl], a
	ld	hl, sp+11
	ld	a, [hl]
	ld	hl, sp+21
	ld	[hl], a
	ld	a, $05
.l00210:
	ld	hl, sp+21
	srl	[hl]
	dec	hl
	rr	[hl]
	dec	hl
	rr	[hl]
	dec	hl
	rr	[hl]
.l00211:
	dec	a
	jr	NZ, .l00210
	ld	hl, sp+5
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $0008
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+26
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+25
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
	dec	hl
	ld	a, [hl]
	dec	hl
	dec	hl
	ld	[hl], a
	ld	hl, sp+25
	ld	a, [hl]
	dec	hl
	dec	hl
	ld	[hl], a
	xor	a, a
	inc	hl
	ld	[hl], a
	inc	hl
	ld	[hl], a
	ld	hl, sp+18
	ld	e, l
	ld	d, h
	ld	hl, sp+22
	ld	a, [de]
	inc	de
	sub	a, [hl]
	inc	hl
	ld	a, [de]
	inc	de
	sbc	a, [hl]
	inc	hl
	ld	a, [de]
	inc	de
	sbc	a, [hl]
	inc	hl
	ld	a, [de]
	sbc	a, [hl]
	jp	C, .l00131
;src/fatfs/lib/ff.c:1783: dp->sect = 0; return FR_NO_FILE;
	xor	a, a
	ld	[bc], a
	inc	bc
	ld	[bc], a
	inc	bc
	ld	[bc], a
	inc	bc
	ld	[bc], a
	ld	a, $04
	jp	.l00132
.l00128:
;src/fatfs/lib/ff.c:1787: if ((ofs / SS(fs) & (fs->csize - 1)) == 0) {	/* Cluster changed? */
	ld	hl, sp+9
	ld	a, [hl]
	ld	hl, sp+20
	ld	[hl], a
	ld	hl, sp+10
	ld	a, [hl]
	ld	hl, sp+21
	ld	[hl], a
	ld	hl, sp+11
	ld	a, [hl]
	ld	hl, sp+22
	ld	[hl], a
	inc	hl
	ld	[hl], $00
	dec	hl
	srl	[hl]
	dec	hl
	rr	[hl]
	dec	hl
	rr	[hl]
	ld	hl, sp+5
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $000A
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+26
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+25
	ld	[hl], a
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	ld	l, a
;	spillPairReg hl
;	spillPairReg hl
	inc	de
	ld	a, [de]
	ld	e, l
	ld	d, a
	dec	de
	ld	hl, $0000
	push	hl
	ld	hl, sp+22
	ld	a, [hl]
	pop	hl
	and	a, e
	push	af
	push	hl
	ld	hl, sp+25
	ld	a, [hl]
	pop	hl
	and	a, d
	ld	e, a
	push	hl
	ld	hl, sp+26
	ld	a, [hl]
	pop	hl
	and	a, l
	ld	l, a
;	spillPairReg hl
;	spillPairReg hl
	push	hl
	ld	hl, sp+27
	ld	a, [hl]
	pop	hl
	and	a, h
	ld	h, a
;	spillPairReg hl
;	spillPairReg hl
	pop	af
	or	a, h
	or	a, l
	or	a, e
	jp	NZ, .l00131
;src/fatfs/lib/ff.c:1788: clst = get_fat(&dp->obj, dp->clust);		/* Get next cluster */
	push	bc
	ld	hl, sp+4
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	push	de
	ld	hl, sp+4
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	push	de
	ld	hl, sp+34
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_get_fat
	ld	hl, sp+24
	ld	[hl], c
	inc	hl
	ld	[hl], b
	inc	hl
	ld	[hl], e
	inc	hl
	ld	[hl], d
	pop	bc
	ld	hl, sp+22
	ld	d, h
	ld	e, l
	ld	hl, sp+18
	ld	a, [de]
	ld	[hl+], a
	inc	de
	ld	a, [de]
	ld	[hl+], a
	inc	de
	ld	a, [de]
	ld	[hl+], a
	inc	de
	ld	a, [de]
	ld	[hl], a
;src/fatfs/lib/ff.c:1789: if (clst <= 1) return FR_INT_ERR;			/* Internal error */
	ld	hl, sp+18
	ld	a, $01
	sub	a, [hl]
	inc	hl
	ld	a, $00
	sbc	a, [hl]
	inc	hl
	ld	a, $00
	sbc	a, [hl]
	inc	hl
	ld	a, $00
	sbc	a, [hl]
	jp	C, .l00108
	ld	a, $02
	jp	.l00132
.l00108:
;src/fatfs/lib/ff.c:1790: if (clst == 0xFFFFFFFF) return FR_DISK_ERR;	/* Disk error */
	ld	hl, sp+18
	ld	a, [hl]
	inc	hl
	and	a, [hl]
	inc	hl
	and	a, [hl]
	inc	hl
	and	a, [hl]
	inc	a
	jp	NZ,.l00214
	jp	.l00215
.l00214:
	jp	.l00110
.l00215:
	ld	a, $01
	jp	.l00132
.l00110:
;src/fatfs/lib/ff.c:1791: if (clst >= fs->n_fatent) {					/* It reached end of dynamic table */
	ld	hl, sp+5
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $0016
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+26
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+25
	ld	[hl], a
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	ld	hl, sp+22
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
	ld	hl, sp+18
	ld	e, l
	ld	d, h
	ld	hl, sp+22
	ld	a, [de]
	inc	de
	sub	a, [hl]
	inc	hl
	ld	a, [de]
	inc	de
	sbc	a, [hl]
	inc	hl
	ld	a, [de]
	inc	de
	sbc	a, [hl]
	inc	hl
	ld	a, [de]
	sbc	a, [hl]
	jp	C, .l00124
;src/fatfs/lib/ff.c:1793: if (!stretch) {								/* If no stretch, report EOT */
	ld	hl, sp+27
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	jp	NZ, .l00112
;src/fatfs/lib/ff.c:1794: dp->sect = 0; return FR_NO_FILE;
	xor	a, a
	ld	[bc], a
	inc	bc
	ld	[bc], a
	inc	bc
	ld	[bc], a
	inc	bc
	ld	[bc], a
	ld	a, $04
	jp	.l00132
.l00112:
;src/fatfs/lib/ff.c:1796: clst = create_chain(&dp->obj, dp->clust);	/* Allocate a cluster */
	ld	hl, sp+17
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	ld	hl, sp+22
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
	push	bc
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	push	de
	ld	hl, sp+26
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	push	de
	ld	hl, sp+34
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_create_chain__far
	ld	hl, sp+24
	ld	[hl], c
	inc	hl
	ld	[hl], b
	inc	hl
	ld	[hl], e
	inc	hl
	ld	[hl], d
	pop	bc
	ld	hl, sp+22
	ld	d, h
	ld	e, l
	ld	hl, sp+18
	ld	a, [de]
	ld	[hl+], a
	inc	de
	ld	a, [de]
	ld	[hl+], a
	inc	de
	ld	a, [de]
	ld	[hl+], a
	inc	de
	ld	a, [de]
	ld	[hl], a
;src/fatfs/lib/ff.c:1797: if (clst == 0) return FR_DENIED;			/* No free cluster */
	ld	hl, sp+21
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	dec	hl
	or	a, [hl]
	dec	hl
	or	a, [hl]
	jp	NZ, .l00114
	ld	a, $07
	jp	.l00132
.l00114:
;src/fatfs/lib/ff.c:1798: if (clst == 1) return FR_INT_ERR;			/* Internal error */
	ld	hl, sp+18
	ld	a, [hl]
	dec	a
	inc	hl
	or	a, [hl]
	inc	hl
	or	a, [hl]
	inc	hl
	or	a, [hl]
	jp	NZ,.l00216
	jp	.l00217
.l00216:
	jp	.l00116
.l00217:
	ld	a, $02
	jp	.l00132
.l00116:
;src/fatfs/lib/ff.c:1799: if (clst == 0xFFFFFFFF) return FR_DISK_ERR;	/* Disk error */
	ld	hl, sp+18
	ld	a, [hl]
	inc	hl
	and	a, [hl]
	inc	hl
	and	a, [hl]
	inc	hl
	and	a, [hl]
	inc	a
	jp	NZ,.l00218
	jp	.l00219
.l00218:
	jp	.l00118
.l00219:
	ld	a, $01
	jp	.l00132
.l00118:
;src/fatfs/lib/ff.c:1800: if (dir_clear(fs, clst) != FR_OK) return FR_DISK_ERR;	/* Clean up the stretched table */
	push	bc
	ld	hl, sp+22
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	push	de
	ld	hl, sp+22
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	push	de
	ld	hl, sp+10
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_dir_clear__far
	pop	bc
	or	a, a
	jp	Z, .l00124
	ld	a, $01
	jp	.l00132
;src/fatfs/lib/ff.c:1801: if (FF_FS_EXFAT) dp->obj.stat |= 4;			/* exFAT: The directory has been stretched */
.l00124:
;src/fatfs/lib/ff.c:1807: dp->clust = clst;		/* Initialize data for new cluster */
	ld	hl, sp+17
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
	inc	de
	inc	hl
	ld	a, [hl]
	ld	[de], a
	inc	de
	inc	hl
	ld	a, [hl]
	ld	[de], a
;src/fatfs/lib/ff.c:1808: dp->sect = clst2sect(fs, clst);
	push	bc
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	push	de
	ld	hl, sp+22
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	push	de
	ld	hl, sp+10
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_clst2sect
	ld	hl, sp+24
	ld	[hl], c
	inc	hl
	ld	[hl], b
	inc	hl
	ld	[hl], e
	inc	hl
	ld	[hl], d
	pop	bc
	ld	hl, sp+22
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
.l00131:
;src/fatfs/lib/ff.c:1812: dp->dptr = ofs;						/* Current entry */
	ld	hl, sp+7
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
	inc	de
	inc	hl
	ld	a, [hl]
	ld	[de], a
	inc	de
	inc	hl
	ld	a, [hl]
	ld	[de], a
;src/fatfs/lib/ff.c:1813: dp->dir = fs->win + ofs % SS(fs);	/* Pointer to the entry in the win[] */
	ld	hl, sp+29
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $001A
	add	hl, de
	ld	c, l
	ld	b, h
	ld	hl, sp+5
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $0032
	add	hl, de
	ld	e, l
	ld	d, h
	ld	hl, sp+12
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	add	hl, de
	ld	e, l
	ld	d, h
	ld	a, e
	ld	[bc], a
	inc	bc
	ld	a, d
	ld	[bc], a
;src/fatfs/lib/ff.c:1815: return FR_OK;
	xor	a, a
.l00132:
;src/fatfs/lib/ff.c:1816: }
	add	sp, 30
	ret
;src/fatfs/lib/ff.c:1826: static FRESULT dir_alloc (	/* FR_OK(0):succeeded, !=0:error */
;	---------------------------------
	SECTION FRAGMENT "src/fatfs/fatfs.c B",ROMX
; Function dir_alloc
; ---------------------------------
_dir_alloc:
	add	sp, -13
	ld	hl, sp+9
	ld	[hl], e
	inc	hl
	ld	[hl], d
	ld	hl, sp+7
	ld	[hl], c
	inc	hl
	ld	[hl], b
;src/fatfs/lib/ff.c:1833: FATFS *fs = dp->obj.fs;
	inc	hl
	inc	hl
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	ld	hl, sp+0
	ld	[hl], a
	inc	de
	ld	a, [de]
	inc	hl
	ld	[hl], a
;src/fatfs/lib/ff.c:1836: res = dir_sdi(dp, 0);
	ld	de, $0000
	push	de
	push	de
	ld	hl, sp+13
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_dir_sdi__far
	ld	hl, sp+2
	ld	[hl], a
;src/fatfs/lib/ff.c:1837: if (res == FR_OK) {
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00113
;src/fatfs/lib/ff.c:1838: n = 0;
	xor	a, a
	ld	hl, sp+11
	ld	[hl], a
	inc	hl
	ld	[hl], a
;src/fatfs/lib/ff.c:1839: do {
	dec	hl
	dec	hl
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $001A
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+5
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+4
	ld	[hl], a
	ld	hl, sp+10
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $0016
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+7
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+6
	ld	[hl], a
.l00109:
;src/fatfs/lib/ff.c:1840: res = move_window(fs, dp->sect);
	ld	hl, sp+6
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	ld	c, a
	inc	de
	ld	a, [de]
	ld	b, a
	inc	de
	ld	a, [de]
	ld	l, a
;	spillPairReg hl
;	spillPairReg hl
	inc	de
	ld	a, [de]
	ld	h, a
;	spillPairReg hl
;	spillPairReg hl
	push	hl
	push	bc
	ld	hl, sp+4
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_move_window
	ld	hl, sp+2
	ld	[hl], a
;src/fatfs/lib/ff.c:1841: if (res != FR_OK) break;
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00113
;src/fatfs/lib/ff.c:1845: if (dp->dir[DIR_Name] == DDEM || dp->dir[DIR_Name] == 0) {	/* Is the entry free? */
	inc	hl
	inc	hl
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	ld	c, a
	inc	de
	ld	a, [de]
	ld	b, a
	ld	a, [bc]
	cp	a, $E5
	jp	NZ,.l00148
	jp	.l00105
.l00148:
	or	a, a
	jp	NZ, .l00106
.l00105:
;src/fatfs/lib/ff.c:1847: if (++n == n_ent) break;	/* Is a block of contiguous free entries found? */
	ld	hl, sp+11
	inc	[hl]
	jp	NZ, .l00149
	inc	hl
	inc	[hl]
.l00149:
	ld	hl, sp+11
	ld	a, [hl]
	ld	hl, sp+7
	sub	a, [hl]
	jp	NZ,.l00150
	ld	hl, sp+12
	ld	a, [hl]
	ld	hl, sp+8
	sub	a, [hl]
	jp	NZ,.l00150
	jp	.l00151
.l00150:
	jp	.l00107
.l00151:
	jp	.l00113
.l00106:
;src/fatfs/lib/ff.c:1849: n = 0;				/* Not a free entry, restart to search */
	xor	a, a
	ld	hl, sp+11
	ld	[hl], a
	inc	hl
	ld	[hl], a
.l00107:
;src/fatfs/lib/ff.c:1851: res = dir_next(dp, 1);	/* Next entry with table stretch enabled */
	ld	bc, $0001
	ld	hl, sp+9
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_dir_next__far
	ld	hl, sp+2
	ld	[hl], a
;src/fatfs/lib/ff.c:1852: } while (res == FR_OK);
	ld	a, [hl]
	or	a, a
	jp	Z, .l00109
.l00113:
;src/fatfs/lib/ff.c:1855: if (res == FR_NO_FILE) res = FR_DENIED;	/* No directory entry to allocate */
	ld	hl, sp+2
	ld	a, [hl]
	sub	a, $04
	jp	NZ,.l00152
	jp	.l00153
.l00152:
	jp	.l00115
.l00153:
	ld	hl, sp+2
	ld	[hl], $07
.l00115:
;src/fatfs/lib/ff.c:1856: return res;
	ld	hl, sp+2
	ld	a, [hl]
.l00116:
;src/fatfs/lib/ff.c:1857: }
	add	sp, 13
	ret
;src/fatfs/lib/ff.c:1868: static DWORD ld_clust (	/* Returns the top cluster value of the SFN entry */
;	---------------------------------
	SECTION FRAGMENT "src/fatfs/fatfs.c B",ROMX
; Function ld_clust
; ---------------------------------
_ld_clust:
	add	sp, -6
	inc	sp
	inc	sp
	push	de
;src/fatfs/lib/ff.c:1875: cl = ld_16(dir + DIR_FstClusLO);
	ld	hl, $001A
	add	hl, bc
	ld	e, l
	ld	d, h
	push	bc
	call	_ld_16
	ld	e, c
	ld	d, b
	pop	bc
	ld	hl, sp+2
	ld	[hl], e
	inc	hl
	ld	[hl], d
	xor	a, a
	inc	hl
	ld	[hl], a
	inc	hl
	ld	[hl], a
;src/fatfs/lib/ff.c:1876: if (fs->fs_type == FS_FAT32) {
	pop	de
	push	de
	ld	a, [de]
	sub	a, $03
	jp	NZ,.l00110
	jp	.l00111
.l00110:
	jp	.l00102
.l00111:
;src/fatfs/lib/ff.c:1877: cl |= (DWORD)ld_16(dir + DIR_FstClusHI) << 16;
	ld	hl, $0014
	add	hl, bc
	ld	e, l
	ld	d, h
	call	_ld_16
	ld	de, $0000
	ld	de, $0000
	ld	hl, sp+2
	ld	a, [hl]
	or	a, e
	ld	[hl], a
	inc	hl
	ld	a, [hl]
	or	a, d
	ld	[hl], a
	inc	hl
	ld	a, [hl]
	or	a, c
	ld	[hl], a
	inc	hl
	ld	a, [hl]
	or	a, b
	ld	[hl], a
.l00102:
;src/fatfs/lib/ff.c:1880: return cl;
	pop	hl
	pop	bc
	push	bc
	push	hl
	ld	hl, sp+4
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
.l00103:
;src/fatfs/lib/ff.c:1881: }
	add	sp, 6
	ret
;src/fatfs/lib/ff.c:1885: static void st_clust (
;	---------------------------------
	SECTION FRAGMENT "src/fatfs/fatfs.c B",ROMX
; Function st_clust
; ---------------------------------
_st_clust:
	add	sp, -4
	ld	hl, sp+2
	ld	[hl], e
	inc	hl
	ld	[hl], d
	inc	sp
	inc	sp
	push	bc
;src/fatfs/lib/ff.c:1891: st_16(dir + DIR_FstClusLO, (WORD)cl);
	ld	hl, sp+6
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	pop	de
	push	de
	ld	hl, $001A
	add	hl, de
	ld	e, l
	ld	d, h
	call	_st_16
;src/fatfs/lib/ff.c:1892: if (fs->fs_type == FS_FAT32) {
	ld	hl, sp+3
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	sub	a, $03
	jp	NZ,.l00110
	jp	.l00111
.l00110:
	jp	.l00103
.l00111:
;src/fatfs/lib/ff.c:1893: st_16(dir + DIR_FstClusHI, (WORD)(cl >> 16));
	ld	hl, sp+8
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	pop	de
	push	de
	ld	hl, $0014
	add	hl, de
	ld	e, l
	ld	d, h
	call	_st_16
.l00103:
;src/fatfs/lib/ff.c:1895: }
	add	sp, 4
	pop	hl
	add	sp, 4
	jp hl 
;src/fatfs/lib/ff.c:1905: static int cmp_lfn (		/* 1:matched, 0:not matched */
;	---------------------------------
	SECTION FRAGMENT "src/fatfs/fatfs.c C",ROMX
; Function cmp_lfn
; ---------------------------------
_cmp_lfn:
	add	sp, -18
	ld	hl, sp+12
	ld	[hl], e
	inc	hl
	ld	[hl], d
	ld	hl, sp+10
	ld	[hl], c
	inc	hl
	ld	[hl], b
;src/fatfs/lib/ff.c:1914: if (ld_16(dir + LDIR_FstClusLO) != 0) return 0;	/* Check if LDIR_FstClusLO is 0 */
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $001A
	add	hl, de
	ld	e, l
	ld	d, h
	call	_ld_16
	ld	a, b
	or	a, c
	jp	Z, .l00102
	ld	bc, $0000
	jp	.l00119
.l00102:
;src/fatfs/lib/ff.c:1916: ni = (UINT)((dir[LDIR_Ord] & 0x3F) - 1) * 13;	/* Offset in the name to be compared */
	ld	hl, sp+11
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	ld	c, a
	ld	b, $00
	ld	a, c
	and	a, $3F
	ld	hl, sp+16
	ld	[hl], a
	inc	hl
	ld	[hl], $00
	dec	hl
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	dec	bc
	ld	l, c
	ld	h, b
	add	hl, hl
	add	hl, bc
	add	hl, hl
	add	hl, hl
	add	hl, bc
	ld	c, l
	ld	b, h
;src/fatfs/lib/ff.c:1918: for (pchr = 1, di = 0; di < 13; di++) {	/* Process all characters in the entry */
	ld	hl, sp+8
	ld	[hl], $01
	xor	a, a
	inc	hl
	ld	[hl], a
	ld	hl, sp+14
	ld	[hl], c
	inc	hl
	ld	[hl], b
	xor	a, a
	inc	hl
	ld	[hl], a
	inc	hl
	ld	[hl], a
.l00117:
	ld	hl, sp+16
	ld	a, [hl]
	sub	a, $0D
	inc	hl
	ld	a, [hl]
	sbc	a, $00
	jp	NC, .l00111
;src/fatfs/lib/ff.c:1919: chr = ld_16(dir + LfnOfs[di]);		/* Pick a character from the entry */
	ld	de, _LfnOfs
	dec	hl
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	add	hl, de
	ld	e, l
	ld	d, h
	ld	a, [de]
	ld	e, a
	ld	d, $00
	ld	hl, sp+10
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	add	hl, de
	ld	e, l
	ld	d, h
	push	bc
	call	_ld_16
	ld	e, c
	ld	d, b
	pop	bc
	inc	sp
	inc	sp
	push	de
;src/fatfs/lib/ff.c:1920: if (pchr != 0) {
	ld	hl, sp+9
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	jp	Z, .l00109
;src/fatfs/lib/ff.c:1921: if (ni >= FF_MAX_LFN + 1 || ff_wtoupper(chr) != ff_wtoupper(lfnbuf[ni++])) {	/* Compare it with name */
	ld	hl, sp+14
	ld	a, [hl]
	sub	a, $41
	inc	hl
	ld	a, [hl]
	sbc	a, $00
	jp	NC, .l00103
	pop	bc
	push	bc
	ld	de, $0000
	call	_ff_wtoupper
	ld	hl, sp+2
	ld	[hl], c
	inc	hl
	ld	[hl], b
	inc	hl
	ld	[hl], e
	inc	hl
	ld	[hl], d
	ld	hl, sp+14
	ld	a, [hl]
	inc	hl
	ld	d, [hl]
	dec	hl
	inc	[hl]
	jp	NZ, .l00166
	inc	hl
	inc	[hl]
.l00166:
	ld	hl, sp+14
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	add	a, a
	rl	d
	ld	e, a
	ld	hl, sp+12
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
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
	xor	a, a
	inc	hl
	ld	[hl], a
	inc	hl
	ld	[hl], a
	push	bc
	ld	hl, sp+8
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	inc	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_ff_wtoupper
	ld	hl, sp+8
	ld	[hl], c
	inc	hl
	ld	[hl], b
	inc	hl
	ld	[hl], e
	inc	hl
	ld	[hl], d
	pop	bc
	ld	hl, sp+2
	ld	a, [hl]
	ld	hl, sp+6
	sub	a, [hl]
	jp	NZ,.l00168
	ld	hl, sp+3
	ld	a, [hl]
	ld	hl, sp+7
	sub	a, [hl]
	jp	NZ,.l00168
	ld	hl, sp+4
	ld	a, [hl]
	ld	hl, sp+8
	sub	a, [hl]
	jp	NZ,.l00168
	ld	hl, sp+5
	ld	a, [hl]
	ld	hl, sp+9
	sub	a, [hl]
	jp	NZ,.l00168
	jp	.l00104
.l00168:
.l00103:
;src/fatfs/lib/ff.c:1922: return 0;					/* Not matched */
	ld	bc, $0000
	jp	.l00119
.l00104:
;src/fatfs/lib/ff.c:1924: pchr = chr;
	ld	hl, sp+0
	ld	a, [hl]
	ld	hl, sp+8
	ld	[hl], a
	ld	hl, sp+1
	ld	a, [hl]
	ld	hl, sp+9
	ld	[hl], a
	jp	.l00118
.l00109:
;src/fatfs/lib/ff.c:1926: if (chr != 0xFFFF) return 0;	/* Check filler */
	pop	de
	push	de
	ld	a, e
	and	a, d
	inc	a
	jp	NZ,.l00169
	jp	.l00118
.l00169:
	ld	bc, $0000
	jp	.l00119
.l00118:
;src/fatfs/lib/ff.c:1918: for (pchr = 1, di = 0; di < 13; di++) {	/* Process all characters in the entry */
	ld	hl, sp+16
	inc	[hl]
	jp	NZ, .l00170
	inc	hl
	inc	[hl]
.l00170:
	jp	.l00117
.l00111:
;src/fatfs/lib/ff.c:1930: if ((dir[LDIR_Ord] & LLEF) && pchr && lfnbuf[ni]) return 0;	/* Last name segment matched but different length */
	ld	hl, sp+11
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	bit	6, a
	jp	NZ,.l00171
	jp	.l00113
.l00171:
	ld	hl, sp+9
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	jp	Z, .l00113
	sla	c
	rl	b
	ld	hl, sp+12
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	add	hl, bc
	ld	c, l
	ld	a, h
	ld	l, c
	ld	h, a
	ld	c, [hl]
	inc	hl
	ld	a, [hl]
	or	a, c
	jp	Z, .l00113
	ld	bc, $0000
	jp	.l00119
.l00113:
;src/fatfs/lib/ff.c:1932: return 1;		/* The part of LFN matched */
	ld	bc, $0001
.l00119:
;src/fatfs/lib/ff.c:1933: }
	add	sp, 18
	ret
;src/fatfs/lib/ff.c:1941: static int pick_lfn (	/* 1:succeeded, 0:buffer overflow or invalid LFN entry */
;	---------------------------------
	SECTION FRAGMENT "src/fatfs/fatfs.c C",ROMX
; Function pick_lfn
; ---------------------------------
_pick_lfn:
	add	sp, -12
	ld	hl, sp+6
	ld	[hl], e
	inc	hl
	ld	[hl], d
;src/fatfs/lib/ff.c:1950: if (ld_16(dir + LDIR_FstClusLO) != 0) return 0;	/* Check if LDIR_FstClusLO is 0 */
	ld	hl, $001A
	add	hl, bc
	ld	e, l
	ld	d, h
	push	bc
	call	_ld_16
	ld	e, c
	ld	d, b
	pop	bc
	ld	a, d
	or	a, e
	jp	Z, .l00102
	ld	bc, $0000
	jp	.l00119
.l00102:
;src/fatfs/lib/ff.c:1952: ni = (UINT)((dir[LDIR_Ord] & ~LLEF) - 1) * 13;	/* Offset in the name buffer */
	ld	a, [bc]
	ld	l, a
;	spillPairReg hl
;	spillPairReg hl
	ld	h, $00
;	spillPairReg hl
;	spillPairReg hl
	res	6, l
	dec	hl
	ld	e, l
	ld	d, h
	add	hl, hl
	add	hl, de
	add	hl, hl
	add	hl, hl
	add	hl, de
	inc	sp
	inc	sp
	push	hl
;src/fatfs/lib/ff.c:1954: for (pchr = 1, di = 0; di < 13; di++) {		/* Process all characters in the entry */
	ld	hl, sp+2
	ld	[hl], $01
	xor	a, a
	inc	hl
	ld	[hl], a
	ld	hl, sp+0
	ld	a, [hl]
	ld	hl, sp+8
	ld	[hl], a
	ld	hl, sp+1
	ld	a, [hl]
	ld	hl, sp+9
	ld	[hl], a
	xor	a, a
	inc	hl
	ld	[hl], a
	inc	hl
	ld	[hl], a
.l00117:
	ld	hl, sp+10
	ld	a, [hl]
	sub	a, $0D
	inc	hl
	ld	a, [hl]
	sbc	a, $00
	jp	NC, .l00110
;src/fatfs/lib/ff.c:1955: chr = ld_16(dir + LfnOfs[di]);			/* Pick a character from the entry */
	ld	de, _LfnOfs
	dec	hl
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	add	hl, de
	ld	e, l
	ld	d, h
	ld	a, [de]
	add	a, c
	ld	e, a
	ld	a, $00
	adc	a, b
	ld	d, a
	push	bc
	call	_ld_16
	ld	e, c
	ld	d, b
	pop	bc
	ld	hl, sp+4
	ld	[hl], e
	inc	hl
	ld	[hl], d
;src/fatfs/lib/ff.c:1956: if (pchr != 0) {
	dec	hl
	dec	hl
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	jp	Z, .l00108
;src/fatfs/lib/ff.c:1957: if (ni >= FF_MAX_LFN + 1) return 0;	/* Buffer overflow? */
	ld	hl, sp+8
	ld	a, [hl]
	sub	a, $41
	inc	hl
	ld	a, [hl]
	sbc	a, $00
	jp	C, .l00104
	ld	bc, $0000
	jp	.l00119
.l00104:
;src/fatfs/lib/ff.c:1958: lfnbuf[ni++] = pchr = chr;			/* Store it */
	ld	hl, sp+8
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	dec	hl
	inc	[hl]
	jp	NZ, .l00166
	inc	hl
	inc	[hl]
.l00166:
	ld	hl, sp+8
	ld	a, [hl]
	ld	hl, sp+0
	ld	[hl], a
	ld	hl, sp+9
	ld	a, [hl]
	ld	hl, sp+1
	ld	[hl], a
	sla	e
	rl	d
	ld	hl, sp+6
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	add	hl, de
	ld	e, l
	ld	d, h
	ld	hl, sp+4
	ld	a, [hl]
	dec	hl
	dec	hl
	ld	[hl], a
	ld	hl, sp+5
	ld	a, [hl]
	dec	hl
	dec	hl
	ld	[hl], a
	inc	hl
	ld	a, [hl]
	ld	[de], a
	inc	de
	inc	hl
	ld	a, [hl]
	ld	[de], a
	jp	.l00118
.l00108:
;src/fatfs/lib/ff.c:1960: if (chr != 0xFFFF) return 0;		/* Check filler */
	ld	hl, sp+4
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, e
	and	a, d
	inc	a
	jp	NZ,.l00168
	jp	.l00118
.l00168:
	ld	bc, $0000
	jp	.l00119
.l00118:
;src/fatfs/lib/ff.c:1954: for (pchr = 1, di = 0; di < 13; di++) {		/* Process all characters in the entry */
	ld	hl, sp+10
	inc	[hl]
	jp	NZ, .l00169
	inc	hl
	inc	[hl]
.l00169:
	jp	.l00117
.l00110:
;src/fatfs/lib/ff.c:1964: if (dir[LDIR_Ord] & LLEF && pchr != 0) {	/* Put terminator if it is the last LFN part and not terminated */
	ld	a, [bc]
	bit	6, a
	jp	NZ,.l00170
	jp	.l00114
.l00170:
	ld	hl, sp+3
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	jp	Z, .l00114
;src/fatfs/lib/ff.c:1965: if (ni >= FF_MAX_LFN + 1) return 0;		/* Buffer overflow? */
	dec	hl
	dec	hl
	ld	a, [hl]
	sub	a, $41
	inc	hl
	ld	a, [hl]
	sbc	a, $00
	jp	C, .l00112
	ld	bc, $0000
	jp	.l00119
.l00112:
;src/fatfs/lib/ff.c:1966: lfnbuf[ni] = 0;
	ld	hl, sp+0
	ld	a, [hl]
	inc	hl
	ld	d, [hl]
	add	a, a
	rl	d
	ld	e, a
	ld	hl, sp+6
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	add	hl, de
	ld	c, l
	ld	b, h
	xor	a, a
	ld	[bc], a
	inc	bc
	ld	[bc], a
.l00114:
;src/fatfs/lib/ff.c:1969: return 1;		/* The part of LFN is valid */
	ld	bc, $0001
.l00119:
;src/fatfs/lib/ff.c:1970: }
	add	sp, 12
	ret
;src/fatfs/lib/ff.c:1979: static void put_lfn (
;	---------------------------------
	SECTION FRAGMENT "src/fatfs/fatfs.c C",ROMX
; Function put_lfn
; ---------------------------------
_put_lfn:
	add	sp, -12
	ld	hl, sp+6
	ld	[hl], e
	inc	hl
	ld	[hl], d
	ld	hl, sp+4
	ld	[hl], c
	inc	hl
	ld	[hl], b
;src/fatfs/lib/ff.c:1990: dir[LDIR_Chksum] = sum;			/* Set checksum */
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $000D
	add	hl, de
	ld	c, l
	ld	b, h
	ld	hl, sp+15
	ld	a, [hl]
	ld	[bc], a
;src/fatfs/lib/ff.c:1991: dir[LDIR_Attr] = AM_LFN;		/* Set attribute */
	ld	hl, sp+5
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $000B
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, $0F
	ld	[bc], a
;src/fatfs/lib/ff.c:1992: dir[LDIR_Type] = 0;
	ld	hl, sp+5
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $000C
	add	hl, de
	ld	c, l
	ld	b, h
	xor	a, a
	ld	[bc], a
;src/fatfs/lib/ff.c:1993: st_16(dir + LDIR_FstClusLO, 0);
	ld	hl, sp+5
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $001A
	add	hl, de
	ld	e, l
	ld	d, h
	ld	bc, $0000
	call	_st_16
;src/fatfs/lib/ff.c:1995: ni = (UINT)(ord - 1) * 13;		/* Offset in the name */
	ld	hl, sp+14
	ld	c, [hl]
	ld	b, $00
	dec	bc
	ld	l, c
	ld	h, b
	add	hl, hl
	add	hl, bc
	add	hl, hl
	add	hl, hl
	add	hl, bc
	push	hl
	ld	a, l
	ld	hl, sp+10
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+9
	ld	[hl], a
;src/fatfs/lib/ff.c:1996: di = chr = 0;
	xor	a, a
	ld	hl, sp+2
	ld	[hl], a
	inc	hl
	ld	[hl], a
;src/fatfs/lib/ff.c:1997: do {	/* Fill the directory entry */
	xor	a, a
	ld	hl, sp+10
	ld	[hl], a
	inc	hl
	ld	[hl], a
.l00105:
;src/fatfs/lib/ff.c:1998: if (chr != 0xFFFF) chr = lfn[ni++];	/* Get an effective character */
	pop	hl
	pop	bc
	push	bc
	push	hl
	ld	a, c
	and	a, b
	inc	a
	jp	NZ,.l00139
	jp	.l00102
.l00139:
	ld	hl, sp+8
	ld	a, [hl]
	ld	hl, sp+0
	ld	[hl], a
	ld	hl, sp+9
	ld	a, [hl]
	ld	hl, sp+1
	ld	[hl], a
	dec	hl
	sla	[hl]
	inc	hl
	rl	[hl]
	ld	hl, sp+8
	inc	[hl]
	jp	NZ, .l00141
	inc	hl
	inc	[hl]
.l00141:
	ld	hl, sp+7
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	pop	hl
	push	hl
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+4
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+3
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
.l00102:
;src/fatfs/lib/ff.c:1999: st_16(dir + LfnOfs[di], chr);	/* Set it */
	ld	de, _LfnOfs
	ld	hl, sp+10
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, [bc]
	ld	e, a
	ld	d, $00
	ld	hl, sp+4
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	add	hl, de
	ld	e, l
	ld	d, h
	pop	hl
	pop	bc
	push	bc
	push	hl
	call	_st_16
;src/fatfs/lib/ff.c:2000: if (chr == 0) chr = 0xFFFF;		/* Padding characters after the terminator */
	ld	hl, sp+3
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	jp	NZ, .l00106
	ld	[hl], $FF
	inc	hl
	ld	[hl], $FF
.l00106:
;src/fatfs/lib/ff.c:2001: } while (++di < 13);
	ld	hl, sp+10
	inc	[hl]
	jp	NZ, .l00142
	inc	hl
	inc	[hl]
.l00142:
	ld	hl, sp+10
	ld	a, [hl]
	sub	a, $0D
	inc	hl
	ld	a, [hl]
	sbc	a, $00
	jp	C, .l00105
;src/fatfs/lib/ff.c:2002: if (chr == 0xFFFF || !lfn[ni]) ord |= LLEF;	/* Last LFN part is the start of an enrty set */
	pop	hl
	pop	bc
	push	bc
	push	hl
	ld	a, c
	and	a, b
	inc	a
	jp	NZ,.l00143
	jp	.l00108
.l00143:
	ld	hl, sp+8
	ld	a, [hl]
	inc	hl
	ld	d, [hl]
	add	a, a
	rl	d
	ld	e, a
	ld	hl, sp+6
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	add	hl, de
	ld	c, l
	ld	a, h
	ld	l, c
	ld	h, a
	ld	c, [hl]
	inc	hl
	ld	a, [hl]
	or	a, c
	jp	NZ, .l00109
.l00108:
	ld	hl, sp+14
	ld	a, [hl]
	or	a, $40
	ld	[hl], a
.l00109:
;src/fatfs/lib/ff.c:2003: dir[LDIR_Ord] = ord;			/* Set order in the entry set */
	ld	hl, sp+5
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, sp+14
	ld	a, [hl]
	ld	[de], a
.l00111:
;src/fatfs/lib/ff.c:2004: }
	add	sp, 12
	pop	hl
	inc	sp
	inc	sp
	jp hl 
;src/fatfs/lib/ff.c:2016: static void gen_numname (
;	---------------------------------
	SECTION FRAGMENT "src/fatfs/fatfs.c C",ROMX
; Function gen_numname
; ---------------------------------
_gen_numname:
	add	sp, -26
	ld	hl, sp+16
	ld	[hl], e
	inc	hl
	ld	[hl], d
;src/fatfs/lib/ff.c:2027: memcpy(dst, src, 11);	/* Prepare the SFN to be modified */
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $000B
	push	hl
	call	___memcpy
;src/fatfs/lib/ff.c:2029: if (seq > 5) {	/* In case of many collisions, generate a hash number instead of sequential number */
	ld	hl, sp+30
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	ld	a, $05
	cp	a, c
	ld	a, $00
	sbc	a, b
	jp	NC, .l00142
;src/fatfs/lib/ff.c:2031: DWORD crc_sreg = seq;
	dec	hl
	ld	a, [hl]
	ld	hl, sp+18
	ld	[hl], a
	ld	hl, sp+31
	ld	a, [hl]
	ld	hl, sp+19
	ld	[hl], a
	xor	a, a
	inc	hl
	ld	[hl], a
	inc	hl
	ld	[hl], a
;src/fatfs/lib/ff.c:2033: while (*lfn) {	/* Create a CRC value as a hash of LFN */
	ld	hl, sp+28
	ld	a, [hl]
	ld	hl, sp+22
	ld	[hl], a
	ld	hl, sp+29
	ld	a, [hl]
	ld	hl, sp+23
	ld	[hl], a
.l00104:
	ld	hl, sp+23
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	inc	hl
	ld	[hl], a
	inc	de
	ld	a, [de]
	inc	hl
	ld	[hl], a
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	jp	Z, .l00106
;src/fatfs/lib/ff.c:2034: wc = *lfn++;
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	dec	hl
	dec	hl
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $0002
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+24
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+23
	ld	[hl], a
;src/fatfs/lib/ff.c:2035: for (i = 0; i < 16; i++) {
	inc	hl
	ld	[hl], $10
	xor	a, a
	inc	hl
	ld	[hl], a
.l00125:
;src/fatfs/lib/ff.c:2036: crc_sreg = (crc_sreg << 1) + (wc & 1);
	push	af
	ld	hl, sp+20
	ld	a, [hl]
	ld	hl, sp+14
	ld	[hl], a
	ld	hl, sp+21
	ld	a, [hl]
	ld	hl, sp+15
	ld	[hl], a
	ld	hl, sp+22
	ld	a, [hl]
	ld	hl, sp+16
	ld	[hl], a
	ld	hl, sp+23
	ld	a, [hl]
	ld	hl, sp+17
	ld	[hl], a
	pop	af
	ld	hl, sp+12
	sla	[hl]
	inc	hl
	rl	[hl]
	inc	hl
	rl	[hl]
	inc	hl
	rl	[hl]
	ld	a, c
	ld	e, b
	and	a, $01
	ld	e, $00
	ld	hl, sp+0
	ld	[hl], a
	inc	hl
	ld	[hl], e
	xor	a, a
	inc	hl
	ld	[hl], a
	inc	hl
	ld	[hl], a
	ld	hl, sp+13
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, e
	ld	hl, sp+0
	add	a, [hl]
	ld	e, a
	ld	a, d
	inc	hl
	adc	a, [hl]
	push	af
	ld	hl, sp+21
	ld	[hl], a
	dec	hl
	ld	[hl], e
	ld	hl, sp+17
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, sp+4
	pop	af
	ld	a, e
	adc	a, [hl]
	ld	e, a
	ld	a, d
	inc	hl
	adc	a, [hl]
	ld	hl, sp+21
	ld	[hl], a
	dec	hl
	ld	[hl], e
;src/fatfs/lib/ff.c:2037: wc >>= 1;
	srl	b
	rr	c
;src/fatfs/lib/ff.c:2038: if (crc_sreg & 0x10000) crc_sreg ^= 0x11021;
	push	hl
	bit	0, [hl]
	pop	hl
	jp	NZ,.l00220
	jp	.l00102
.l00220:
	ld	hl, sp+18
	ld	a, [hl]
	xor	a, $21
	ld	[hl], a
	inc	hl
	ld	a, [hl]
	xor	a, $10
	ld	[hl], a
	inc	hl
	ld	a, [hl]
	xor	a, $01
	ld	[hl], a
.l00102:
	ld	hl, sp+25
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	dec	de
	dec	hl
	ld	[hl], e
	inc	hl
	ld	[hl], d
;src/fatfs/lib/ff.c:2035: for (i = 0; i < 16; i++) {
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	jp	NZ, .l00125
	jp	.l00104
.l00106:
;src/fatfs/lib/ff.c:2041: seq = (WORD)crc_sreg;
	ld	hl, sp+18
	ld	a, [hl]
	ld	hl, sp+30
	ld	[hl], a
	ld	hl, sp+19
	ld	a, [hl]
	ld	hl, sp+31
	ld	[hl], a
;src/fatfs/lib/ff.c:2046: do {
.l00142:
	ld	bc, $0007
.l00112:
;src/fatfs/lib/ff.c:2047: c = (BYTE)((seq % 16) + '0'); seq /= 16;
	ld	hl, sp+30
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, e
	and	a, $0F
	ld	l, $00
;	spillPairReg hl
;	spillPairReg hl
	add	a, $30
	ld	hl, sp+25
	ld	[hl], a
	ld	a, $04
.l00221:
	srl	d
	rr	e
	dec	a
	jp	NZ, .l00221
	ld	hl, sp+30
	ld	[hl], e
	inc	hl
	ld	[hl], d
;src/fatfs/lib/ff.c:2048: if (c > '9') c += 7;
	ld	a, $39
	ld	hl, sp+25
	sub	a, [hl]
	jp	NC, .l00110
	ld	a, [hl]
	add	a, $07
	ld	[hl], a
.l00110:
;src/fatfs/lib/ff.c:2049: ns[i--] = c;
	ld	e, c
	ld	d, b
	dec	bc
	push	de
	ld	hl, 6
	add	hl, sp
	add	hl, de
	pop	de
	ld	e, l
	ld	d, h
	ld	hl, sp+25
	ld	a, [hl]
	ld	[de], a
;src/fatfs/lib/ff.c:2050: } while (i && seq);
	ld	a, b
	or	a, c
	jp	Z, .l00151
	ld	hl, sp+31
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	jp	NZ, .l00112
.l00151:
	ld	hl, sp+22
	ld	[hl], c
	inc	hl
	ld	[hl], b
;src/fatfs/lib/ff.c:2051: ns[i] = '~';
	ld	hl, 4
	add	hl, sp
	add	hl, bc
	ld	[hl], $7E
;src/fatfs/lib/ff.c:2054: for (j = 0; j < i && dst[j] != ' '; j++) {	/* Find the offset to append */
	xor	a, a
	ld	hl, sp+24
	ld	[hl], a
	inc	hl
	ld	[hl], a
	ld	de, $0001
	ld	a, c
	sub	a, e
	ld	e, a
	ld	a, b
	sbc	a, d
	ld	hl, sp+19
	ld	[hl], a
	dec	hl
	ld	[hl], e
.l00128:
	ld	hl, sp+24
	ld	e, l
	ld	d, h
	ld	hl, sp+22
	ld	a, [de]
	inc	de
	sub	a, [hl]
	inc	hl
	ld	a, [de]
	sbc	a, [hl]
	jp	NC, .l00149
	ld	hl, sp+25
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, sp+16
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+22
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+21
	ld	[hl], a
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	ld	c, a
	ld	a, c
	sub	a, $20
	jp	NZ,.l00222
	jp	.l00149
.l00222:
;src/fatfs/lib/ff.c:2055: if (dbc_1st(dst[j])) {	/* To avoid DBC break up */
	ld	a, c
	call	_dbc_1st
	ld	a, b
	or	a, c
	jp	Z, .l00129
;src/fatfs/lib/ff.c:2056: if (j == i - 1) break;
	ld	hl, sp+18
	ld	a, [hl]
	ld	hl, sp+24
	sub	a, [hl]
	jp	NZ,.l00223
	ld	hl, sp+19
	ld	a, [hl]
	ld	hl, sp+25
	sub	a, [hl]
	jp	NZ,.l00223
	jp	.l00149
.l00223:
;src/fatfs/lib/ff.c:2057: j++;
	ld	hl, sp+24
	inc	[hl]
	jp	NZ, .l00224
	inc	hl
	inc	[hl]
.l00224:
.l00129:
;src/fatfs/lib/ff.c:2054: for (j = 0; j < i && dst[j] != ' '; j++) {	/* Find the offset to append */
	ld	hl, sp+24
	inc	[hl]
	jp	NZ, .l00225
	inc	hl
	inc	[hl]
.l00225:
	jp	.l00128
;src/fatfs/lib/ff.c:2060: do {	/* Append the suffix */
.l00149:
.l00120:
;src/fatfs/lib/ff.c:2061: dst[j++] = (i < 8) ? ns[i++] : ' ';
	ld	hl, sp+17
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, sp+24
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+20
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+19
	ld	[hl], a
	ld	hl, sp+24
	inc	[hl]
	jp	NZ, .l00226
	inc	hl
	inc	[hl]
.l00226:
	ld	hl, sp+22
	ld	a, [hl]
	sub	a, $08
	inc	hl
	ld	a, [hl]
	sbc	a, $00
	jp	NC, .l00132
	push	hl
	ld	hl, 6
	add	hl, sp
	ld	e, l
	ld	d, h
	pop	hl
	ld	hl, sp+22
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	add	hl, de
	ld	c, l
	ld	b, h
	ld	hl, sp+22
	inc	[hl]
	jp	NZ, .l00227
	inc	hl
	inc	[hl]
.l00227:
	ld	a, [bc]
	ld	hl, sp+20
	ld	[hl], a
	inc	hl
	ld	[hl], $00
	jp	.l00133
.l00132:
	ld	hl, sp+20
	ld	[hl], $20
	xor	a, a
	inc	hl
	ld	[hl], a
.l00133:
	ld	hl, sp+20
	ld	c, [hl]
	dec	hl
	dec	hl
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	ld	[hl], c
;src/fatfs/lib/ff.c:2062: } while (j < 8);
	ld	hl, sp+24
	ld	a, [hl]
	sub	a, $08
	inc	hl
	ld	a, [hl]
	sbc	a, $00
	jp	C, .l00120
.l00130:
;src/fatfs/lib/ff.c:2063: }
	add	sp, 26
	pop	hl
	add	sp, 4
	jp hl 
;src/fatfs/lib/ff.c:2073: static BYTE sum_sfn (
;	---------------------------------
	SECTION FRAGMENT "src/fatfs/fatfs.c C",ROMX
; Function sum_sfn
; ---------------------------------
_sum_sfn:
;src/fatfs/lib/ff.c:2077: BYTE sum = 0;
	ld	l, $00
;	spillPairReg hl
;	spillPairReg hl
;src/fatfs/lib/ff.c:2080: do {
	ld	bc, $000B
.l00101:
;src/fatfs/lib/ff.c:2081: sum = (sum >> 1) + (sum << 7) + *dir++;
	ld	h, l
;	spillPairReg hl
;	spillPairReg hl
	srl	h
	ld	a, l
	rrca
	and	a, $80
	add	a, h
	ld	l, a
;	spillPairReg hl
;	spillPairReg hl
	ld	a, [de]
	inc	de
	add	a, l
	ld	l, a
;	spillPairReg hl
;	spillPairReg hl
;src/fatfs/lib/ff.c:2082: } while (--n);
	dec	bc
	ld	a, b
	or	a, c
	jp	NZ, .l00101
;src/fatfs/lib/ff.c:2083: return sum;
	ld	a, l
.l00104:
;src/fatfs/lib/ff.c:2084: }
	ret
;src/fatfs/lib/ff.c:2337: static FRESULT dir_read (
;	---------------------------------
	SECTION FRAGMENT "src/fatfs/fatfs.c A",ROMX
; Function dir_read
; ---------------------------------
_dir_read:
	add	sp, -28
	ld	hl, sp+26
	ld	[hl], e
	inc	hl
	ld	[hl], d
	ld	hl, sp+24
	ld	[hl], c
	inc	hl
	ld	[hl], b
;src/fatfs/lib/ff.c:2342: FRESULT res = FR_NO_FILE;
	ld	hl, sp+3
	ld	[hl], $04
;src/fatfs/lib/ff.c:2343: FATFS *fs = dp->obj.fs;
	ld	hl, sp+27
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	ld	hl, sp+4
	ld	[hl], a
	inc	de
	ld	a, [de]
	inc	hl
	ld	[hl], a
;src/fatfs/lib/ff.c:2346: BYTE ord = 0xFF, sum = 0xFF;
	inc	hl
	ld	[hl], $FF
	inc	hl
	ld	[hl], $FF
;src/fatfs/lib/ff.c:2349: while (dp->sect) {
	ld	hl, sp+27
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $000E
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+10
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+9
	ld	[hl], a
	ld	hl, sp+27
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $001A
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+12
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+11
	ld	[hl], a
	dec	hl
	ld	a, [hl]
	inc	hl
	inc	hl
	ld	[hl], a
	dec	hl
	ld	a, [hl]
	inc	hl
	inc	hl
	ld	[hl], a
	ld	hl, sp+5
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $000C
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+16
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+15
	ld	[hl], a
	ld	hl, sp+27
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $0016
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+18
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+17
	ld	[hl], a
	dec	hl
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
	ld	hl, sp+19
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
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
	inc	de
	ld	a, [de]
	inc	hl
	ld	[hl], a
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	dec	hl
	or	a, [hl]
	dec	hl
	or	a, [hl]
	jp	Z, .l00122
;src/fatfs/lib/ff.c:2350: res = move_window(fs, dp->sect);
	inc	hl
	inc	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	push	de
	ld	hl, sp+22
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	push	de
	ld	hl, sp+8
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_move_window__far
	ld	hl, sp+3
	ld	[hl], a
;src/fatfs/lib/ff.c:2351: if (res != FR_OK) break;
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00122
;src/fatfs/lib/ff.c:2352: et = dp->dir[DIR_Name];	/* Test for the entry type */
	ld	hl, sp+11
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	ld	hl, sp+20
	ld	[hl], a
	inc	de
	ld	a, [de]
	inc	hl
	ld	[hl], a
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	ld	b, a
;src/fatfs/lib/ff.c:2353: if (et == 0) {
	ld	a, b
	or	a, a
	jp	NZ, .l00104
;src/fatfs/lib/ff.c:2354: res = FR_NO_FILE; break; /* Reached to end of the directory */
	ld	hl, sp+3
	ld	[hl], $04
	jp	.l00122
.l00104:
;src/fatfs/lib/ff.c:2373: dp->obj.attr = attr = dp->dir[DIR_Attr] & AM_MASK;	/* Get attribute */
	ld	hl, sp+27
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $0004
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+24
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+23
	ld	[hl], a
	dec	hl
	dec	hl
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $000B
	add	hl, de
	ld	e, l
	ld	d, h
	ld	a, [de]
	and	a, $3F
	ld	c, a
	ld	hl, sp+22
	push	af
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	pop	af
	ld	[hl], a
;src/fatfs/lib/ff.c:2375: if (et == DDEM || et == '.' || (int)((attr & ~AM_ARC) == AM_VOL) != vol) {	/* An entry without valid data */
	ld	a, b
	sub	a, $E5
	jp	NZ,.l00198
	jp	.l00113
.l00198:
	ld	a, b
	sub	a, $2E
	jp	NZ,.l00199
	jp	.l00113
.l00199:
	ld	e, c
	ld	d, $00
	res	5, e
	ld	a, e
	sub	a, $08
	or	a, d
	jp	NZ,.l00200
	ld	a,$01
	jp	.l00201
.l00200:
	xor	a,a
.l00201:
	ld	e, a
	ld	d, $00
	ld	hl, sp+24
	ld	a, [hl]
	sub	a, e
	jp	NZ,.l00202
	inc	hl
	ld	a, [hl]
	sub	a, d
	jp	NZ,.l00202
	jp	.l00114
.l00202:
.l00113:
;src/fatfs/lib/ff.c:2376: ord = 0xFF;
	ld	hl, sp+6
	ld	[hl], $FF
	jp	.l00115
.l00114:
;src/fatfs/lib/ff.c:2382: dp->blk_ofs = dp->dptr;
	ld	hl, sp+27
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $0028
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+24
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+23
	ld	[hl], a
;src/fatfs/lib/ff.c:2378: if (attr == AM_LFN) {	/* An LFN entry is found */
	ld	a, c
	sub	a, $0F
	jp	NZ,.l00203
	jp	.l00204
.l00203:
	jp	.l00111
.l00204:
;src/fatfs/lib/ff.c:2379: if (et & LLEF) {		/* Is it start of an LFN sequence? */
	bit	6, b
	jp	NZ,.l00205
	jp	.l00106
.l00205:
;src/fatfs/lib/ff.c:2380: sum = dp->dir[LDIR_Chksum];
	ld	hl, sp+11
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	ld	l, a
;	spillPairReg hl
;	spillPairReg hl
	inc	de
	ld	a, [de]
	ld	h, a
;	spillPairReg hl
;	spillPairReg hl
	ld	de, $000D
	add	hl, de
	ld	a, [hl]
	ld	hl, sp+7
	ld	[hl], a
;src/fatfs/lib/ff.c:2381: et &= (BYTE)~LLEF; ord = et;
	res	6, b
	ld	hl, sp+6
	ld	[hl], b
;src/fatfs/lib/ff.c:2382: dp->blk_ofs = dp->dptr;
	ld	hl, sp+9
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	ld	hl, sp+0
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
	ld	hl, sp+23
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, sp+0
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
.l00106:
;src/fatfs/lib/ff.c:2385: ord = (et == ord && sum == dp->dir[LDIR_Chksum] && pick_lfn(fs->lfnbuf, dp->dir)) ? ord - 1 : 0xFF;
	ld	hl, sp+6
	ld	a, [hl]
	sub	a, b
	jp	NZ,.l00206
	jp	.l00207
.l00206:
	jp	.l00127
.l00207:
	ld	hl, sp+13
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	ld	c, a
	inc	de
	ld	a, [de]
	ld	b, a
	ld	hl, $000D
	add	hl, bc
	ld	e, [hl]
	ld	hl, sp+7
	ld	a, [hl]
	sub	a, e
	jp	NZ,.l00208
	jp	.l00209
.l00208:
	jp	.l00127
.l00209:
	ld	hl, sp+15
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	ld	l, a
;	spillPairReg hl
;	spillPairReg hl
	inc	de
	ld	a, [de]
	ld	h, a
;	spillPairReg hl
;	spillPairReg hl
	ld	e, l
	ld	d, h
	call	_pick_lfn__far
	ld	a, b
	or	a, c
	jp	Z, .l00127
	ld	hl, sp+6
	ld	a, [hl]
	dec	a
	ld	c, a
	rlca
	sbc	a, a
	ld	b, a
	jp	.l00128
.l00127:
	ld	bc, $00FF
.l00128:
	ld	hl, sp+6
	ld	[hl], c
	jp	.l00115
.l00111:
;src/fatfs/lib/ff.c:2387: if (ord != 0 || sum != sum_sfn(dp->dir)) {	/* Is there a valid LFN? */
	ld	hl, sp+6
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00107
	ld	hl, sp+11
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	ld	c, a
	inc	de
	ld	a, [de]
	ld	b, a
	ld	e, c
	ld	d, b
	call	_sum_sfn__far
	ld	c, a
	ld	hl, sp+7
	ld	a, [hl]
	sub	a, c
	jp	NZ,.l00210
	jp	.l00122
.l00210:
.l00107:
;src/fatfs/lib/ff.c:2388: dp->blk_ofs = 0xFFFFFFFF;	/* It has no LFN. */
	ld	hl, sp+22
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	ld	[hl], $FF
	inc	hl
	ld	[hl], $FF
	inc	hl
	ld	[hl], $FF
	inc	hl
	ld	[hl], $FF
;src/fatfs/lib/ff.c:2390: break;
	jp	.l00122
.l00115:
;src/fatfs/lib/ff.c:2399: res = dir_next(dp, 0);		/* Next entry */
	ld	bc, $0000
	ld	hl, sp+26
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_dir_next
	ld	hl, sp+3
	ld	[hl], a
;src/fatfs/lib/ff.c:2400: if (res != FR_OK) break;
	ld	a, [hl]
	or	a, a
	jp	Z, .l00120
.l00122:
;src/fatfs/lib/ff.c:2403: if (res != FR_OK) dp->sect = 0;		/* Terminate the read operation on error or EOT */
	ld	hl, sp+3
	ld	a, [hl]
	or	a, a
	jp	Z, .l00124
	ld	hl, sp+16
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	xor	a, a
	ld	[hl], a
	inc	hl
	ld	[hl], a
	inc	hl
	ld	[hl], a
	inc	hl
	ld	[hl], a
.l00124:
;src/fatfs/lib/ff.c:2404: return res;
	ld	hl, sp+3
	ld	a, [hl]
.l00125:
;src/fatfs/lib/ff.c:2405: }
	add	sp, 28
	ret
;src/fatfs/lib/ff.c:2415: static FRESULT dir_find (	/* FR_OK(0):succeeded, !=0:error */
;	---------------------------------
	SECTION FRAGMENT "src/fatfs/fatfs.c A",ROMX
; Function dir_find
; ---------------------------------
_dir_find:
	add	sp, -35
	ld	hl, sp+33
	ld	[hl], e
	inc	hl
	ld	[hl], d
;src/fatfs/lib/ff.c:2420: FATFS *fs = dp->obj.fs;
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	ld	hl, sp+0
	ld	[hl], a
	inc	de
	ld	a, [de]
	inc	hl
	ld	[hl], a
;src/fatfs/lib/ff.c:2426: res = dir_sdi(dp, 0);			/* Rewind directory object */
	ld	de, $0000
	push	de
	push	de
	ld	hl, sp+37
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_dir_sdi
;src/fatfs/lib/ff.c:2427: if (res != FR_OK) return res;
	or	a, a
	jp	Z, .l00102
	jp	.l00128
.l00102:
;src/fatfs/lib/ff.c:2450: ord = sum = 0xFF; dp->blk_ofs = 0xFFFFFFFF;	/* Reset LFN sequence */
	ld	hl, sp+2
	ld	[hl], $FF
	inc	hl
	ld	[hl], $FF
	ld	hl, sp+34
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $0028
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
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	ld	[hl], $FF
	inc	hl
	ld	[hl], $FF
	inc	hl
	ld	[hl], $FF
	inc	hl
	ld	[hl], $FF
;src/fatfs/lib/ff.c:2452: do {
	ld	hl, sp+34
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $000E
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+8
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+7
	ld	[hl], a
	ld	hl, sp+34
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $001A
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
	ld	a, [hl]
	inc	hl
	inc	hl
	ld	[hl], a
	dec	hl
	ld	a, [hl]
	inc	hl
	inc	hl
	ld	[hl], a
	pop	de
	push	de
	ld	hl, $000C
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+14
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+13
	ld	[hl], a
	ld	hl, sp+8
	ld	a, [hl]
	ld	hl, sp+14
	ld	[hl], a
	ld	hl, sp+9
	ld	a, [hl]
	ld	hl, sp+15
	ld	[hl], a
	ld	hl, sp+8
	ld	a, [hl]
	ld	hl, sp+16
	ld	[hl], a
	ld	hl, sp+9
	ld	a, [hl]
	ld	hl, sp+17
	ld	[hl], a
	ld	hl, sp+34
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $001C
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+20
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+19
	ld	[hl], a
	ld	hl, sp+8
	ld	a, [hl]
	ld	hl, sp+20
	ld	[hl], a
	ld	hl, sp+9
	ld	a, [hl]
	ld	hl, sp+21
	ld	[hl], a
	dec	hl
	dec	hl
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $000B
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+24
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+23
	ld	[hl], a
	dec	hl
	ld	a, [hl]
	inc	hl
	inc	hl
	ld	[hl], a
	dec	hl
	ld	a, [hl]
	inc	hl
	inc	hl
	ld	[hl], a
	ld	hl, sp+34
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $0016
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+28
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+27
	ld	[hl], a
.l00125:
;src/fatfs/lib/ff.c:2453: res = move_window(fs, dp->sect);
	ld	hl, sp+27
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
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
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	push	de
	ld	hl, sp+31
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	push	de
	ld	hl, sp+4
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_move_window__far
	ld	hl, sp+28
	ld	[hl], a
;src/fatfs/lib/ff.c:2454: if (res != FR_OK) break;
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00127
;src/fatfs/lib/ff.c:2455: et = dp->dir[DIR_Name];		/* Entry type */
	ld	hl, sp+15
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	ld	hl, sp+29
	ld	[hl], a
	inc	de
	ld	a, [de]
	inc	hl
	ld	[hl], a
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	ld	c, a
;src/fatfs/lib/ff.c:2456: if (et == 0) { res = FR_NO_FILE; break; }	/* Reached end of directory table */
	ld	a, c
	or	a, a
	jp	NZ, .l00106
	dec	hl
	dec	hl
	ld	[hl], $04
	jp	.l00127
.l00106:
;src/fatfs/lib/ff.c:2458: dp->obj.attr = attr = dp->dir[DIR_Attr] & AM_MASK;
	ld	hl, sp+34
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $0004
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+33
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+32
	ld	[hl], a
	dec	hl
	dec	hl
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $000B
	add	hl, de
	ld	e, l
	ld	d, h
	ld	a, [de]
	and	a, $3F
	ld	b, a
	ld	hl, sp+31
	push	af
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	pop	af
	ld	[hl], a
;src/fatfs/lib/ff.c:2459: if (et == DDEM || ((attr & AM_VOL) && attr != AM_LFN)) {	/* An entry without valid data */
	ld	a, c
	sub	a, $E5
	jp	NZ,.l00206
	jp	.l00120
.l00206:
	ld	a, b
	sub	a, $0F
	jp	NZ,.l00207
	ld	a,$01
	jp	.l00208
.l00207:
	xor	a,a
.l00208:
	bit	3, b
	jp	NZ,.l00209
	jp	.l00121
.l00209:
	or	a, a
	jp	NZ, .l00121
.l00120:
;src/fatfs/lib/ff.c:2460: ord = 0xFF; dp->blk_ofs = 0xFFFFFFFF;	/* Reset LFN sequence */
	ld	hl, sp+3
	ld	[hl], $FF
	inc	hl
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	ld	[hl], $FF
	inc	hl
	ld	[hl], $FF
	inc	hl
	ld	[hl], $FF
	inc	hl
	ld	[hl], $FF
	jp	.l00122
.l00121:
;src/fatfs/lib/ff.c:2462: if (attr == AM_LFN) {			/* Is it an LFN entry? */
	or	a, a
	jp	Z, .l00118
;src/fatfs/lib/ff.c:2463: if (!(dp->fn[NSFLAG] & NS_NOLFN)) {
	ld	hl, sp+25
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	bit	6, a
	jp	NZ,.l00210
	jp	.l00211
.l00210:
	jp	.l00122
.l00211:
;src/fatfs/lib/ff.c:2464: if (et & LLEF) {		/* Is it start of an entry set? */
	bit	6, c
	jp	NZ,.l00212
	jp	.l00108
.l00212:
;src/fatfs/lib/ff.c:2465: et &= (BYTE)~LLEF;
	res	6, c
;src/fatfs/lib/ff.c:2466: ord = et;					/* Number of LFN entries */
	ld	hl, sp+3
	ld	[hl], c
;src/fatfs/lib/ff.c:2467: dp->blk_ofs = dp->dptr;		/* Start offset of LFN */
	ld	hl, sp+7
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	ld	hl, sp+29
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
	ld	hl, sp+5
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, sp+29
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
;src/fatfs/lib/ff.c:2468: sum = dp->dir[LDIR_Chksum];	/* Sum of the SFN */
	ld	hl, sp+9
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	ld	l, a
;	spillPairReg hl
;	spillPairReg hl
	inc	de
	ld	a, [de]
	ld	h, a
;	spillPairReg hl
;	spillPairReg hl
	ld	de, $000D
	add	hl, de
	ld	a, [hl]
	ld	hl, sp+2
	ld	[hl], a
.l00108:
;src/fatfs/lib/ff.c:2471: ord = (et == ord && sum == dp->dir[LDIR_Chksum] && cmp_lfn(fs->lfnbuf, dp->dir)) ? ord - 1 : 0xFF;
	ld	hl, sp+3
	ld	a, [hl]
	sub	a, c
	jp	NZ,.l00213
	jp	.l00214
.l00213:
	jp	.l00130
.l00214:
	ld	hl, sp+11
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	ld	c, a
	inc	de
	ld	a, [de]
	ld	b, a
	ld	hl, $000D
	add	hl, bc
	ld	e, [hl]
	ld	hl, sp+2
	ld	a, [hl]
	sub	a, e
	jp	NZ,.l00215
	jp	.l00216
.l00215:
	jp	.l00130
.l00216:
	ld	hl, sp+13
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	ld	l, a
;	spillPairReg hl
;	spillPairReg hl
	inc	de
	ld	a, [de]
	ld	h, a
;	spillPairReg hl
;	spillPairReg hl
	ld	e, l
	ld	d, h
	call	_cmp_lfn__far
	ld	a, b
	or	a, c
	jp	Z, .l00130
	ld	hl, sp+3
	ld	a, [hl]
	dec	a
	ld	c, a
	rlca
	sbc	a, a
	jp	.l00131
.l00130:
	ld	c, $FF
	xor	a, a
.l00131:
	ld	hl, sp+3
	ld	[hl], c
	jp	.l00122
.l00118:
;src/fatfs/lib/ff.c:2474: if (ord == 0 && sum == sum_sfn(dp->dir)) break;	/* LFN matched? */
	ld	hl, sp+3
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00112
	ld	hl, sp+17
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	ld	c, a
	inc	de
	ld	a, [de]
	ld	b, a
	ld	e, c
	ld	d, b
	call	_sum_sfn__far
	ld	c, a
	ld	hl, sp+2
	ld	a, [hl]
	sub	a, c
	jp	NZ,.l00217
	jp	.l00127
.l00217:
.l00112:
;src/fatfs/lib/ff.c:2475: if (!(dp->fn[NSFLAG] & NS_LOSS) && !memcmp(dp->dir, dp->fn, 11)) break;	/* SFN matched? */
	ld	hl, sp+23
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	rrca
	jp	C,.l00218
	jp	.l00219
.l00218:
	jp	.l00115
.l00219:
	ld	hl, sp+18
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	inc	hl
	inc	hl
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	ld	l, a
;	spillPairReg hl
;	spillPairReg hl
	inc	de
	ld	a, [de]
	ld	e, l
	ld	d, a
	ld	hl, $000B
	push	hl
	call	_memcmp
	ld	a, b
	or	a, c
	jp	Z, .l00127
.l00115:
;src/fatfs/lib/ff.c:2476: ord = 0xFF; dp->blk_ofs = 0xFFFFFFFF;	/* Not matched, reset LFN sequence */
	ld	hl, sp+3
	ld	[hl], $FF
	inc	hl
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	ld	[hl], $FF
	inc	hl
	ld	[hl], $FF
	inc	hl
	ld	[hl], $FF
	inc	hl
	ld	[hl], $FF
.l00122:
;src/fatfs/lib/ff.c:2483: res = dir_next(dp, 0);	/* Next entry */
	ld	bc, $0000
	ld	hl, sp+33
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_dir_next
	ld	hl, sp+28
	ld	[hl], a
;src/fatfs/lib/ff.c:2484: } while (res == FR_OK);
	ld	a, [hl]
	or	a, a
	jp	Z, .l00125
.l00127:
;src/fatfs/lib/ff.c:2486: return res;
	ld	hl, sp+28
	ld	a, [hl]
.l00128:
;src/fatfs/lib/ff.c:2487: }
	add	sp, 35
	ret
;src/fatfs/lib/ff.c:2497: static FRESULT dir_register (	/* FR_OK:succeeded, FR_DENIED:no free entry or too many SFN collision, FR_DISK_ERR:disk error */
;	---------------------------------
	SECTION FRAGMENT "src/fatfs/fatfs.c B",ROMX
; Function dir_register
; ---------------------------------
_dir_register:
	add	sp, -48
	ld	hl, sp+44
	ld	[hl], e
	inc	hl
	ld	[hl], d
;src/fatfs/lib/ff.c:2502: FATFS *fs = dp->obj.fs;
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	ld	hl, sp+24
	ld	[hl], a
	inc	de
	ld	a, [de]
	inc	hl
	ld	[hl], a
;src/fatfs/lib/ff.c:2508: if (dp->fn[NSFLAG] & (NS_DOT | NS_NONAME)) return FR_INVALID_NAME;	/* Check name validity */
	ld	hl, sp+45
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $001C
	add	hl, de
	ld	c, l
	ld	b, h
	ld	hl, $000B
	add	hl, bc
	push	hl
	ld	a, l
	ld	hl, sp+37
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+36
	ld	[hl], a
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	and	a, $A0
	jp	NZ,.l00225
	jp	.l00102
.l00225:
	ld	a, $06
	jp	.l00133
.l00102:
;src/fatfs/lib/ff.c:2509: for (len = 0; fs->lfnbuf[len]; len++) ;	/* Get lfn length */
	ld	hl, sp+25
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $000C
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+43
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+42
	ld	[hl], a
	ld	bc, $0000
.l00129:
	ld	hl, sp+42
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	ld	l, a
;	spillPairReg hl
;	spillPairReg hl
	inc	de
	ld	a, [de]
	ld	h, a
;	spillPairReg hl
;	spillPairReg hl
	ld	a, c
	ld	d, b
	add	a, a
	rl	d
	ld	e, a
	add	hl, de
	ld	a, [hl]
	inc	hl
	ld	l, [hl]
;	spillPairReg hl
	or	a, l
	jp	Z, .l00154
	inc	bc
	jp	.l00129
.l00154:
	ld	hl, sp+37
	ld	[hl], c
	inc	hl
	ld	[hl], b
;src/fatfs/lib/ff.c:2549: memcpy(sn, dp->fn, 12);
	ld	hl, sp+45
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $001C
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+41
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+40
	ld	[hl], a
	dec	hl
	ld	a, [hl]
	ld	hl, sp+26
	ld	[hl], a
	ld	hl, sp+40
	ld	a, [hl]
	ld	hl, sp+27
	ld	[hl], a
	ld	de, $000C
	push	de
	dec	hl
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	ld	hl, 14
	add	hl, sp
	ld	e, l
	ld	d, h
	call	___memcpy
;src/fatfs/lib/ff.c:2550: if (sn[NSFLAG] & NS_LOSS) {			/* When LFN is out of 8.3 format, generate a numbered name */
	ld	hl, sp+23
	ld	c, [hl]
;src/fatfs/lib/ff.c:2551: dp->fn[NSFLAG] = NS_NOLFN;		/* Find only SFN */
	ld	hl, sp+40
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $000B
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+30
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+29
	ld	[hl], a
;src/fatfs/lib/ff.c:2550: if (sn[NSFLAG] & NS_LOSS) {			/* When LFN is out of 8.3 format, generate a numbered name */
	bit	0, c
	jp	NZ,.l00227
	jp	.l00112
.l00227:
;src/fatfs/lib/ff.c:2551: dp->fn[NSFLAG] = NS_NOLFN;		/* Find only SFN */
	ld	hl, sp+28
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	ld	[hl], $40
;src/fatfs/lib/ff.c:2552: for (n = 1; n < 100; n++) {
	ld	hl, sp+46
	ld	[hl], $01
	xor	a, a
	inc	hl
	ld	[hl], a
.l00131:
;src/fatfs/lib/ff.c:2553: gen_numname(dp->fn, sn, fs->lfnbuf, (WORD)n);	/* Generate a numbered name */
	ld	hl, sp+46
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	ld	hl, sp+42
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	ld	l, a
;	spillPairReg hl
;	spillPairReg hl
	inc	de
	ld	a, [de]
	ld	h, a
;	spillPairReg hl
;	spillPairReg hl
	push	bc
	push	hl
	ld	hl, 16
	add	hl, sp
	ld	c, l
	ld	b, h
	ld	hl, sp+43
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_gen_numname__far
;src/fatfs/lib/ff.c:2554: res = dir_find(dp);				/* Check if the name collides with existing SFN */
	ld	hl, sp+44
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_dir_find__far
	ld	c, a
;src/fatfs/lib/ff.c:2555: if (res != FR_OK) break;
	ld	a, c
	or	a, a
	jp	NZ, .l00106
;src/fatfs/lib/ff.c:2552: for (n = 1; n < 100; n++) {
	ld	hl, sp+46
	inc	[hl]
	jp	NZ, .l00228
	inc	hl
	inc	[hl]
.l00228:
	ld	hl, sp+46
	ld	a, [hl]
	sub	a, $64
	inc	hl
	ld	a, [hl]
	sbc	a, $00
	jp	C, .l00131
.l00106:
;src/fatfs/lib/ff.c:2557: if (n == 100) return FR_DENIED;		/* Abort if too many collisions */
	ld	hl, sp+46
	ld	a, [hl]
	sub	a, $64
	inc	hl
	or	a, [hl]
	jp	NZ,.l00229
	jp	.l00230
.l00229:
	jp	.l00108
.l00230:
	ld	a, $07
	jp	.l00133
.l00108:
;src/fatfs/lib/ff.c:2558: if (res != FR_NO_FILE) return res;	/* Abort if the result is other than 'not collided' */
	ld	a, c
	sub	a, $04
	jp	NZ,.l00231
	jp	.l00110
.l00231:
	ld	a, c
	jp	.l00133
.l00110:
;src/fatfs/lib/ff.c:2559: dp->fn[NSFLAG] = sn[NSFLAG];
	ld	hl, sp+23
	ld	c, [hl]
	ld	hl, sp+35
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	ld	[hl], c
.l00112:
;src/fatfs/lib/ff.c:2563: n_ent = (sn[NSFLAG] & NS_LFN) ? (len + 12) / 13 + 1 : 1;	/* Number of entries to allocate */
	ld	hl, sp+23
	ld	a, [hl]
	bit	1, a
	jp	NZ,.l00232
	jp	.l00135
.l00232:
	ld	hl, sp+38
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $000C
	add	hl, de
	ld	e, l
	ld	d, h
	ld	bc, $000D
	call	__divuint
	inc	bc
	ld	hl, sp+46
	ld	[hl], c
	inc	hl
	ld	[hl], b
	jp	.l00136
.l00135:
	ld	hl, sp+46
	ld	[hl], $01
	xor	a, a
	inc	hl
	ld	[hl], a
.l00136:
	ld	hl, sp+46
	ld	a, [hl]
	ld	hl, sp+37
	ld	[hl], a
	ld	hl, sp+47
	ld	a, [hl]
	ld	hl, sp+38
	ld	[hl], a
;src/fatfs/lib/ff.c:2564: res = dir_alloc(dp, n_ent);		/* Allocate entries */
	dec	hl
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	ld	hl, sp+44
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_dir_alloc
	ld	hl, sp+43
	ld	[hl], a
;src/fatfs/lib/ff.c:2570: do {					/* Store LFN entries in bottom first */
	inc	hl
	inc	hl
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $0016
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+32
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+31
	ld	[hl], a
;src/fatfs/lib/ff.c:2573: put_lfn(fs->lfnbuf, dp->dir, (BYTE)n_ent, sum);
	ld	hl, sp+45
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $001A
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+34
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+33
	ld	[hl], a
;src/fatfs/lib/ff.c:2574: fs->wflag = 1;
	ld	hl, sp+25
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $0004
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+36
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+35
	ld	[hl], a
;src/fatfs/lib/ff.c:2565: if (res == FR_OK && --n_ent) {	/* Set LFN entry if needed */
	ld	hl, sp+43
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00122
	ld	hl, sp+38
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $0001
	ld	a, e
	sub	a, l
	ld	e, a
	ld	a, d
	sbc	a, h
	ld	hl, sp+47
	ld	[hl], a
	dec	hl
	ld	[hl], e
	inc	hl
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	jp	Z, .l00122
;src/fatfs/lib/ff.c:2566: res = dir_sdi(dp, dp->dptr - n_ent * SZDIRE);
	dec	hl
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $000E
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+39
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+38
	ld	[hl], a
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	ld	hl, sp+0
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
	ld	hl, sp+46
	ld	a, [hl]
	ld	hl, sp+37
	ld	[hl], a
	ld	hl, sp+47
	ld	a, [hl]
	ld	hl, sp+38
	ld	[hl], a
	ld	a, $05
.l00233:
	ld	hl, sp+37
	sla	[hl]
	inc	hl
	rl	[hl]
	dec	a
	jp	NZ, .l00233
	dec	hl
	ld	a, [hl]
	ld	hl, sp+4
	ld	[hl], a
	ld	hl, sp+38
	ld	a, [hl]
	ld	hl, sp+5
	ld	[hl], a
	xor	a, a
	inc	hl
	ld	[hl], a
	inc	hl
	ld	[hl], a
	pop	de
	push	de
	ld	a, e
	ld	hl, sp+4
	sub	a, [hl]
	ld	e, a
	ld	a, d
	inc	hl
	sbc	a, [hl]
	push	af
	ld	hl, sp+11
	ld	[hl], a
	dec	hl
	ld	[hl], e
	ld	hl, sp+5
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, sp+8
	pop	af
	ld	a, e
	sbc	a, [hl]
	ld	e, a
	ld	a, d
	inc	hl
	sbc	a, [hl]
	ld	hl, sp+11
	ld	[hl], a
	dec	hl
	ld	[hl], e
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	push	de
	ld	hl, sp+10
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	push	de
	ld	hl, sp+48
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_dir_sdi__far
	ld	hl, sp+43
	ld	[hl], a
;src/fatfs/lib/ff.c:2567: if (res == FR_OK) {
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00122
;src/fatfs/lib/ff.c:2568: BYTE sum = sum_sfn(dp->fn);	/* Checksum value of the SFN tied to the LFN */
	ld	hl, sp+39
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_sum_sfn__far
	ld	hl, sp+36
	ld	[hl], a
;src/fatfs/lib/ff.c:2570: do {					/* Store LFN entries in bottom first */
	ld	hl, sp+41
	ld	a, [hl]
	ld	hl, sp+37
	ld	[hl], a
	ld	hl, sp+42
	ld	a, [hl]
	ld	hl, sp+38
	ld	[hl], a
	ld	hl, sp+30
	ld	a, [hl]
	ld	hl, sp+39
	ld	[hl], a
	ld	hl, sp+31
	ld	a, [hl]
	ld	hl, sp+40
	ld	[hl], a
.l00116:
;src/fatfs/lib/ff.c:2571: res = move_window(fs, dp->sect);
	ld	hl, sp+40
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	ld	hl, sp+8
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
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	push	de
	ld	hl, sp+10
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	push	de
	ld	hl, sp+28
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_move_window
	ld	hl, sp+43
	ld	[hl], a
;src/fatfs/lib/ff.c:2572: if (res != FR_OK) break;
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00122
;src/fatfs/lib/ff.c:2573: put_lfn(fs->lfnbuf, dp->dir, (BYTE)n_ent, sum);
	ld	hl, sp+46
	ld	a, [hl]
	ld	hl, sp+41
	ld	[hl], a
	ld	hl, sp+33
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	ld	c, a
	inc	de
	ld	a, [de]
	ld	b, a
	ld	hl, sp+38
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	ld	hl, sp+42
	ld	[hl], a
	inc	de
	ld	a, [de]
	inc	hl
	ld	[hl], a
	ld	hl, sp+36
	ld	a, [hl]
	push	af
	inc	sp
	ld	hl, sp+42
	ld	a, [hl]
	push	af
	inc	sp
	inc	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_put_lfn__far
;src/fatfs/lib/ff.c:2574: fs->wflag = 1;
	ld	hl, sp+34
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	ld	[hl], $01
;src/fatfs/lib/ff.c:2575: res = dir_next(dp, 0);	/* Next entry */
	ld	bc, $0000
	ld	hl, sp+44
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_dir_next__far
	ld	hl, sp+43
	ld	[hl], a
;src/fatfs/lib/ff.c:2576: } while (res == FR_OK && --n_ent);
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00122
	ld	hl, sp+47
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	dec	de
	dec	hl
	ld	[hl], e
	inc	hl
	ld	[hl], d
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	jp	NZ, .l00116
.l00122:
;src/fatfs/lib/ff.c:2586: if (res == FR_OK) {
	ld	hl, sp+43
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00127
;src/fatfs/lib/ff.c:2587: res = move_window(fs, dp->sect);
	ld	hl, sp+31
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	ld	c, a
	inc	de
	ld	a, [de]
	ld	b, a
	inc	de
	ld	a, [de]
	ld	l, a
;	spillPairReg hl
;	spillPairReg hl
	inc	de
	ld	a, [de]
	ld	h, a
;	spillPairReg hl
;	spillPairReg hl
	push	hl
	push	bc
	ld	hl, sp+28
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_move_window
	ld	hl, sp+43
	ld	[hl], a
;src/fatfs/lib/ff.c:2588: if (res == FR_OK) {
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00127
;src/fatfs/lib/ff.c:2589: memset(dp->dir, 0, SZDIRE);	/* Clean the entry */
	ld	hl, sp+33
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	ld	c, a
	inc	de
	ld	a, [de]
	ld	e, c
	ld	d, a
	ld	bc, $0020
	push	bc
	ld	bc, $0000
	call	_memset
;src/fatfs/lib/ff.c:2590: memcpy(dp->dir + DIR_Name, dp->fn, 11);	/* Put SFN */
	ld	hl, sp+33
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	ld	c, a
	inc	de
	ld	a, [de]
	ld	e, c
	ld	d, a
	ld	bc, $000B
	push	bc
	ld	hl, sp+28
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	call	___memcpy
;src/fatfs/lib/ff.c:2592: dp->dir[DIR_NTres] = dp->fn[NSFLAG] & (NS_BODY | NS_EXT);	/* Put low-case flags */
	ld	hl, sp+33
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	ld	c, a
	inc	de
	ld	a, [de]
	ld	b, a
	ld	hl, $000C
	add	hl, bc
	ld	c, l
	ld	b, h
	ld	hl, sp+29
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	and	a, $18
	ld	[bc], a
;src/fatfs/lib/ff.c:2594: fs->wflag = 1;
	ld	hl, sp+34
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	ld	[hl], $01
.l00127:
;src/fatfs/lib/ff.c:2598: return res;
	ld	hl, sp+43
	ld	a, [hl]
.l00133:
;src/fatfs/lib/ff.c:2599: }
	add	sp, 48
	ret
;src/fatfs/lib/ff.c:2656: static void get_fileinfo (
;	---------------------------------
	SECTION FRAGMENT "src/fatfs/fatfs.c C",ROMX
; Function get_fileinfo
; ---------------------------------
_get_fileinfo:
	add	sp, -32
	ld	hl, sp+28
	ld	[hl], e
	inc	hl
	ld	[hl], d
	ld	hl, sp+26
	ld	[hl], c
	inc	hl
	ld	[hl], b
;src/fatfs/lib/ff.c:2664: FATFS *fs = dp->obj.fs;
	inc	hl
	inc	hl
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	inc	hl
	ld	[hl], a
	inc	de
	ld	a, [de]
	inc	hl
	ld	[hl], a
;src/fatfs/lib/ff.c:2671: fno->fname[0] = 0;
	ld	hl, sp+27
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $0016
	add	hl, de
	inc	sp
	inc	sp
	push	hl
	pop	hl
	push	hl
	ld	[hl], $00
;src/fatfs/lib/ff.c:2672: if (dp->sect == 0) return;	/* Exit if read pointer has reached end of directory */
	ld	hl, sp+29
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $0016
	add	hl, de
	ld	c, l
	ld	b, h
	ld	e, c
	ld	d, b
	ld	a, [de]
	ld	hl, sp+22
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
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	dec	hl
	or	a, [hl]
	dec	hl
	or	a, [hl]
	jp	NZ, .l00102
	jp	.l00152
.l00102:
;src/fatfs/lib/ff.c:2714: if (dp->blk_ofs != 0xFFFFFFFF) {	/* Get LFN if available */
	ld	hl, sp+29
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $0028
	add	hl, de
	ld	c, l
	ld	b, h
	ld	e, c
	ld	d, b
	ld	a, [de]
	ld	hl, sp+22
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
;src/fatfs/lib/ff.c:2717: while (fs->lfnbuf[si] != 0) {
	inc	hl
	inc	hl
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $0016
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+4
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+3
	ld	[hl], a
;src/fatfs/lib/ff.c:2714: if (dp->blk_ofs != 0xFFFFFFFF) {	/* Get LFN if available */
	ld	hl, sp+22
	ld	a, [hl]
	inc	hl
	and	a, [hl]
	inc	hl
	and	a, [hl]
	inc	hl
	and	a, [hl]
	inc	a
	jp	NZ,.l00305
	jp	.l00115
.l00305:
;src/fatfs/lib/ff.c:2715: si = di = 0;
	ld	bc, $0000
;src/fatfs/lib/ff.c:2716: hs = 0;
	xor	a, a
	ld	hl, sp+4
	ld	[hl], a
	inc	hl
	ld	[hl], a
;src/fatfs/lib/ff.c:2717: while (fs->lfnbuf[si] != 0) {
	ld	hl, sp+31
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $000C
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+8
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+7
	ld	[hl], a
	ld	hl, sp+2
	ld	a, [hl]
	ld	hl, sp+8
	ld	[hl], a
	ld	hl, sp+3
	ld	a, [hl]
	ld	hl, sp+9
	ld	[hl], a
	xor	a, a
	ld	hl, sp+30
	ld	[hl], a
	inc	hl
	ld	[hl], a
.l00109:
	ld	hl, sp+7
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	ld	hl, sp+22
	ld	[hl], a
	inc	de
	ld	a, [de]
	inc	hl
	ld	[hl], a
	ld	hl, sp+30
	ld	a, [hl]
	inc	hl
	ld	d, [hl]
	add	a, a
	rl	d
	ld	e, a
	ld	hl, sp+22
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+26
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+25
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
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	jp	Z, .l00111
;src/fatfs/lib/ff.c:2718: wc = fs->lfnbuf[si++];		/* Get an LFN character (UTF-16) */
	ld	hl, sp+30
	inc	[hl]
	jp	NZ, .l00307
	inc	hl
	inc	[hl]
.l00307:
;src/fatfs/lib/ff.c:2719: if (hs == 0 && IsSurrogate(wc)) {	/* Is it a surrogate? */
	ld	hl, sp+5
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	jp	NZ, .l00104
	ld	hl, sp+24
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, d
	sub	a, $D8
	jp	C, .l00104
	ld	a, $FF
	cp	a, e
	ld	a, $DF
	sbc	a, d
	jp	C, .l00104
;src/fatfs/lib/ff.c:2720: hs = wc; continue;		/* Get low surrogate */
	dec	hl
	ld	a, [hl]
	ld	hl, sp+4
	ld	[hl], a
	ld	hl, sp+25
	ld	a, [hl]
	ld	hl, sp+5
	ld	[hl], a
	jp	.l00109
.l00104:
;src/fatfs/lib/ff.c:2722: nw = put_utf((DWORD)hs << 16 | wc, &fno->fname[di], FF_LFN_BUF - di);	/* Store it in API encoding */
	ld	de, $0040
	ld	a, e
	sub	a, c
	ld	e, a
	ld	a, d
	sbc	a, b
	ld	hl, sp+11
	ld	[hl], a
	dec	hl
	ld	[hl], e
	dec	hl
	dec	hl
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	add	hl, bc
	push	hl
	ld	a, l
	ld	hl, sp+14
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+13
	ld	[hl], a
	ld	hl, sp+4
	ld	a, [hl]
	ld	hl, sp+20
	ld	[hl], a
	ld	hl, sp+5
	ld	a, [hl]
	ld	hl, sp+21
	ld	[hl], a
	xor	a, a
	inc	hl
	ld	[hl], a
	inc	hl
	ld	[hl], a
	push	af
	ld	hl, sp+22
	ld	a, [hl]
	ld	hl, sp+18
	ld	[hl], a
	ld	hl, sp+23
	ld	a, [hl]
	ld	hl, sp+19
	ld	[hl], a
	pop	af
	ld	hl, sp+14
	ld	[hl], $00
	inc	hl
	ld	[hl], $00
	ld	hl, sp+24
	ld	a, [hl]
	ld	hl, sp+18
	ld	[hl], a
	ld	hl, sp+25
	ld	a, [hl]
	ld	hl, sp+19
	ld	[hl], a
	xor	a, a
	inc	hl
	ld	[hl], a
	inc	hl
	ld	[hl], a
	ld	hl, sp+14
	ld	a, [hl]
	ld	hl, sp+18
	or	a, [hl]
	ld	hl, sp+22
	ld	[hl], a
	ld	hl, sp+15
	ld	a, [hl]
	ld	hl, sp+19
	or	a, [hl]
	ld	hl, sp+23
	ld	[hl], a
	ld	hl, sp+16
	ld	a, [hl]
	ld	hl, sp+20
	or	a, [hl]
	ld	hl, sp+24
	ld	[hl], a
	ld	hl, sp+17
	ld	a, [hl]
	ld	hl, sp+21
	or	a, [hl]
	ld	hl, sp+25
	ld	[hl], a
	push	bc
	ld	hl, sp+12
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	push	de
	inc	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	push	de
	ld	hl, sp+28
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	inc	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_put_utf
	ld	l, c
;	spillPairReg hl
;	spillPairReg hl
	ld	h, b
;	spillPairReg hl
;	spillPairReg hl
	pop	bc
;src/fatfs/lib/ff.c:2723: if (nw == 0) {				/* Buffer overflow or wrong char? */
	ld	a, h
	or	a, l
	jp	NZ, .l00108
;src/fatfs/lib/ff.c:2724: di = 0; break;
	ld	bc, $0000
	jp	.l00111
.l00108:
;src/fatfs/lib/ff.c:2726: di += nw;
	add	hl, bc
	ld	c, l
	ld	b, h
;src/fatfs/lib/ff.c:2727: hs = 0;
	xor	a, a
	ld	hl, sp+4
	ld	[hl], a
	inc	hl
	ld	[hl], a
	jp	.l00109
.l00111:
;src/fatfs/lib/ff.c:2729: if (hs != 0) di = 0;	/* Broken surrogate pair? */
	ld	hl, sp+5
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	jp	Z, .l00113
	ld	bc, $0000
.l00113:
;src/fatfs/lib/ff.c:2730: fno->fname[di] = 0;		/* Terminate the LFN (null string means LFN is invalid) */
	ld	hl, sp+8
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	add	hl, bc
	ld	c, l
	ld	b, h
	xor	a, a
	ld	[bc], a
.l00115:
;src/fatfs/lib/ff.c:2734: si = di = 0;
	xor	a, a
	ld	hl, sp+30
	ld	[hl], a
	inc	hl
	ld	[hl], a
	xor	a, a
	ld	hl, sp+24
	ld	[hl], a
	inc	hl
	ld	[hl], a
;src/fatfs/lib/ff.c:2735: while (si < 11) {		/* Get SFN from SFN entry */
	ld	hl, sp+29
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $001A
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+22
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+21
	ld	[hl], a
	ld	hl, sp+27
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $0009
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+18
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+17
	ld	[hl], a
.l00132:
	ld	hl, sp+24
	ld	a, [hl]
	sub	a, $0B
	inc	hl
	ld	a, [hl]
	sbc	a, $00
	jp	NC, .l00134
;src/fatfs/lib/ff.c:2736: wc = dp->dir[si++];			/* Get a char */
	ld	hl, sp+21
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	ld	hl, sp+18
	ld	[hl], a
	inc	de
	ld	a, [de]
	inc	hl
	ld	[hl], a
	ld	hl, sp+24
	ld	a, [hl]
	dec	hl
	dec	hl
	ld	[hl], a
	ld	hl, sp+25
	ld	a, [hl]
	dec	hl
	dec	hl
	ld	[hl], a
	inc	hl
	inc	[hl]
	jp	NZ, .l00310
	inc	hl
	inc	[hl]
.l00310:
	ld	hl, sp+23
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, sp+18
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, [bc]
	ld	hl, sp+23
	ld	[hl], a
	ld	a, [hl]
	ld	hl, sp+14
	ld	[hl], a
	inc	hl
	ld	[hl], $00
;src/fatfs/lib/ff.c:2737: if (wc == ' ') continue;	/* Skip padding spaces */
	dec	hl
	ld	a, [hl]
	ld	hl, sp+22
	ld	[hl], a
	ld	hl, sp+15
	ld	a, [hl]
	ld	hl, sp+23
	ld	[hl], a
	dec	hl
	ld	a, [hl]
	sub	a, $20
	inc	hl
	or	a, [hl]
	jp	NZ,.l00311
	jp	.l00132
.l00311:
;src/fatfs/lib/ff.c:2738: if (wc == RDDEM) wc = DDEM;	/* Restore replaced DDEM character */
	ld	hl, sp+22
	ld	a, [hl]
	sub	a, $05
	inc	hl
	or	a, [hl]
	jp	NZ,.l00312
	jp	.l00313
.l00312:
	jp	.l00119
.l00313:
	ld	hl, sp+14
	ld	[hl], $E5
	xor	a, a
	inc	hl
	ld	[hl], a
.l00119:
;src/fatfs/lib/ff.c:2739: if (si == 9 && di < FF_SFN_BUF) fno->altname[di++] = '.';	/* Insert a . if extension is exist */
	ld	hl, sp+24
	ld	a, [hl]
	sub	a, $09
	inc	hl
	or	a, [hl]
	jp	NZ,.l00314
	jp	.l00315
.l00314:
	jp	.l00121
.l00315:
	ld	hl, sp+30
	ld	a, [hl]
	sub	a, $0C
	inc	hl
	ld	a, [hl]
	sbc	a, $00
	jp	NC, .l00121
	dec	hl
	ld	a, [hl]
	ld	hl, sp+18
	ld	[hl], a
	ld	hl, sp+31
	ld	a, [hl]
	ld	hl, sp+19
	ld	[hl], a
	ld	hl, sp+30
	inc	[hl]
	jp	NZ, .l00316
	inc	hl
	inc	[hl]
.l00316:
	ld	hl, sp+19
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, sp+16
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+24
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+23
	ld	[hl], a
	dec	hl
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	ld	[hl], $2E
.l00121:
;src/fatfs/lib/ff.c:2741: if (dbc_1st((BYTE)wc) && si != 8 && si != 11 && dbc_2nd(dp->dir[si])) {	/* Make a DBC if needed */
	ld	hl, sp+14
	ld	c, [hl]
	ld	a, c
	call	_dbc_1st
	ld	hl, sp+22
	ld	[hl], c
	inc	hl
	ld	[hl], b
	ld	hl, sp+23
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	jp	Z, .l00124
	inc	hl
	inc	hl
	ld	a, [hl]
	sub	a, $08
	inc	hl
	or	a, [hl]
	jp	NZ,.l00317
	jp	.l00124
.l00317:
	ld	hl, sp+24
	ld	a, [hl]
	sub	a, $0B
	inc	hl
	or	a, [hl]
	jp	NZ,.l00318
	jp	.l00124
.l00318:
	ld	hl, sp+21
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	ld	hl, sp+18
	ld	[hl], a
	inc	de
	ld	a, [de]
	inc	hl
	ld	[hl], a
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, sp+24
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+24
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+23
	ld	[hl], a
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	ld	[hl], a
	ld	a, [hl]
	call	_dbc_2nd
	ld	hl, sp+22
	ld	[hl], c
	inc	hl
	ld	[hl], b
	ld	hl, sp+23
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	jp	Z, .l00124
;src/fatfs/lib/ff.c:2742: wc = wc << 8 | dp->dir[si++];
	ld	hl, sp+14
	ld	a, [hl]
	ld	hl, sp+19
	ld	[hl], a
	dec	hl
	ld	[hl], $00
	ld	hl, sp+21
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	ld	c, a
	inc	de
	ld	a, [de]
	ld	b, a
	ld	hl, sp+24
	ld	a, [hl]
	inc	hl
	ld	e, [hl]
	dec	hl
	inc	[hl]
	jp	NZ, .l00319
	inc	hl
	inc	[hl]
.l00319:
	ld	l, a
	ld	h, e
	add	hl, bc
	push	hl
	ld	a, l
	ld	hl, sp+24
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+23
	ld	[hl], a
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	ld	[hl], a
	ld	a, [hl]
	dec	hl
	ld	[hl], a
	inc	hl
	ld	[hl], $00
	ld	hl, sp+18
	ld	a, [hl]
	ld	hl, sp+22
	or	a, [hl]
	ld	hl, sp+14
	ld	[hl], a
	ld	hl, sp+19
	ld	a, [hl]
	ld	hl, sp+23
	or	a, [hl]
	ld	hl, sp+15
	ld	[hl], a
.l00124:
;src/fatfs/lib/ff.c:2744: wc = ff_oem2uni(wc, CODEPAGE);		/* ANSI/OEM -> Unicode */
	ld	bc, $01B5
	ld	hl, sp+14
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_ff_oem2uni
;src/fatfs/lib/ff.c:2745: if (wc == 0) {				/* Wrong char in the current code page? */
	ld	a, b
	or	a, c
	jp	NZ, .l00129
;src/fatfs/lib/ff.c:2746: di = 0; break;
	xor	a, a
	ld	hl, sp+30
	ld	[hl], a
	inc	hl
	ld	[hl], a
	jp	.l00134
.l00129:
;src/fatfs/lib/ff.c:2748: nw = put_utf(wc, &fno->altname[di], FF_SFN_BUF - di);	/* Store it in API encoding */
	ld	de, $000C
	ld	hl, sp+30
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	ld	a, e
	sub	a, l
	ld	e, a
	ld	a, d
	sbc	a, h
	ld	hl, sp+19
	ld	[hl], a
	dec	hl
	ld	[hl], e
	ld	hl, sp+31
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, sp+16
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+24
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+23
	ld	[hl], a
	ld	de, $0000
	ld	hl, sp+18
	ld	a, [hl]
	inc	hl
	ld	h, [hl]
;	spillPairReg hl
;	spillPairReg hl
	ld	l, a
;	spillPairReg hl
;	spillPairReg hl
	push	hl
	ld	hl, sp+24
	ld	a, [hl]
	inc	hl
	ld	h, [hl]
;	spillPairReg hl
;	spillPairReg hl
	ld	l, a
;	spillPairReg hl
;	spillPairReg hl
	push	hl
	call	_put_utf
;src/fatfs/lib/ff.c:2749: if (nw == 0) {				/* Buffer overflow? */
	ld	a, b
	or	a, c
	jp	NZ, .l00131
;src/fatfs/lib/ff.c:2750: di = 0; break;
	xor	a, a
	ld	hl, sp+30
	ld	[hl], a
	inc	hl
	ld	[hl], a
	jp	.l00134
.l00131:
;src/fatfs/lib/ff.c:2752: di += nw;
	ld	hl, sp+30
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	add	hl, bc
	push	hl
	ld	a, l
	ld	hl, sp+32
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+31
	ld	[hl], a
	jp	.l00132
.l00134:
;src/fatfs/lib/ff.c:2757: fno->altname[di] = 0;	/* Terminate the SFN  (null string means SFN is invalid) */
	ld	hl, sp+27
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $0009
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+24
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+23
	ld	[hl], a
	ld	hl, sp+31
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, sp+22
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	add	hl, de
	ld	c, l
	ld	b, h
	xor	a, a
	ld	[bc], a
;src/fatfs/lib/ff.c:2759: if (!fno->fname[0]) {	/* If LFN is invalid, altname[] needs to be copied to fname[] */
	pop	de
	push	de
	ld	a, [de]
	ld	hl, sp+25
	ld	[hl], a
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00148
;src/fatfs/lib/ff.c:2760: if (di == 0) {		/* If LFN and SFN both are invalid, */
	ld	hl, sp+31
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	jp	NZ, .l00143
;src/fatfs/lib/ff.c:2761: fno->fname[di++] = '\?';	/* This object is inaccessible due to wrong buffer or locale settings */
	ld	a, [hl]
	ld	hl, sp+18
	ld	[hl], a
	ld	hl, sp+31
	ld	a, [hl]
	ld	hl, sp+19
	ld	[hl], a
	ld	hl, sp+31
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $0001
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+26
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+25
	ld	[hl], a
	ld	hl, sp+19
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, sp+2
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+32
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+31
	ld	[hl], a
	dec	hl
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	ld	[hl], $3F
	jp	.l00144
.l00143:
;src/fatfs/lib/ff.c:2763: BYTE lcflg = NS_BODY;
	ld	hl, sp+11
	ld	[hl], $08
;src/fatfs/lib/ff.c:2765: for (si = di = 0; fno->altname[si]; si++, di++) {	/* Copy altname[] to fname[] with case information */
	ld	hl, sp+20
	ld	a, [hl]
	ld	hl, sp+12
	ld	[hl], a
	ld	hl, sp+21
	ld	a, [hl]
	ld	hl, sp+13
	ld	[hl], a
	ld	hl, sp+2
	ld	a, [hl]
	ld	hl, sp+14
	ld	[hl], a
	ld	hl, sp+3
	ld	a, [hl]
	ld	hl, sp+15
	ld	[hl], a
	xor	a, a
	ld	hl, sp+24
	ld	[hl], a
	inc	hl
	ld	[hl], a
	xor	a, a
	ld	hl, sp+30
	ld	[hl], a
	inc	hl
	ld	[hl], a
.l00150:
	ld	hl, sp+23
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	inc	hl
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, [bc]
	or	a, a
	jp	Z, .l00184
;src/fatfs/lib/ff.c:2766: wc = (WCHAR)fno->altname[si];
	ld	hl, sp+16
	ld	[hl], a
	inc	hl
	ld	[hl], $00
;src/fatfs/lib/ff.c:2719: if (hs == 0 && IsSurrogate(wc)) {	/* Is it a surrogate? */
	dec	hl
	ld	a, [hl]
	inc	hl
	inc	hl
	ld	[hl], a
	dec	hl
	ld	a, [hl]
	inc	hl
	inc	hl
	ld	[hl], a
;src/fatfs/lib/ff.c:2767: if (wc == '.') lcflg = NS_EXT;
	dec	hl
	ld	a, [hl]
	sub	a, $2E
	inc	hl
	or	a, [hl]
	jp	NZ,.l00320
	jp	.l00321
.l00320:
	jp	.l00136
.l00321:
	ld	hl, sp+11
	ld	[hl], $10
.l00136:
;src/fatfs/lib/ff.c:2768: if (IsUpper(wc) && (dp->dir[DIR_NTres] & lcflg)) wc += 0x20;
	ld	hl, sp+18
	ld	a, [hl]
	sub	a, $41
	inc	hl
	ld	a, [hl]
	sbc	a, $00
	jp	C, .l00138
	dec	hl
	ld	a, $5A
	sub	a, [hl]
	inc	hl
	ld	a, $00
	sbc	a, [hl]
	jp	C, .l00138
	ld	hl, sp+13
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	ld	c, a
	inc	de
	ld	a, [de]
	ld	b, a
	ld	hl, $000C
	add	hl, bc
	ld	a, [hl]
	ld	hl, sp+11
	and	a, [hl]
	or	a, a
	jp	Z, .l00138
	ld	hl, sp+19
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $0020
	add	hl, de
	ld	c, l
	ld	a, h
	ld	hl, sp+16
	ld	[hl], c
	inc	hl
	ld	[hl], a
.l00138:
;src/fatfs/lib/ff.c:2769: fno->fname[di] = (TCHAR)wc;
	ld	hl, sp+15
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, sp+30
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	add	hl, de
	ld	c, l
	ld	b, h
	ld	hl, sp+16
	ld	a, [hl]
	ld	[bc], a
;src/fatfs/lib/ff.c:2765: for (si = di = 0; fno->altname[si]; si++, di++) {	/* Copy altname[] to fname[] with case information */
	ld	hl, sp+24
	inc	[hl]
	jp	NZ, .l00322
	inc	hl
	inc	[hl]
.l00322:
	ld	hl, sp+30
	inc	[hl]
	jp	NZ, .l00323
	inc	hl
	inc	[hl]
.l00323:
	jp	.l00150
.l00184:
	ld	hl, sp+30
	ld	a, [hl]
	ld	hl, sp+24
	ld	[hl], a
	ld	hl, sp+31
	ld	a, [hl]
	ld	hl, sp+25
	ld	[hl], a
.l00144:
;src/fatfs/lib/ff.c:2772: fno->fname[di] = 0;	/* Terminate the LFN */
	ld	hl, sp+25
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, sp+2
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+32
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+31
	ld	[hl], a
	dec	hl
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	ld	[hl], $00
;src/fatfs/lib/ff.c:2773: if (!dp->dir[DIR_NTres]) fno->altname[0] = 0;	/* Altname is not needed if neither LFN nor case info is exist. */
	ld	hl, sp+21
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	ld	hl, sp+24
	ld	[hl], a
	inc	de
	ld	a, [de]
	inc	hl
	ld	[hl], a
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $000C
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+32
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+31
	ld	[hl], a
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	or	a, a
	jp	NZ, .l00148
	ld	hl, sp+22
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	ld	[hl], $00
.l00148:
;src/fatfs/lib/ff.c:2788: fno->fattrib = dp->dir[DIR_Attr] & AM_MASK;		/* Attribute */
	ld	hl, sp+27
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $0008
	add	hl, de
	ld	c, l
	ld	b, h
	ld	hl, sp+21
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	ld	l, a
;	spillPairReg hl
;	spillPairReg hl
	inc	de
	ld	a, [de]
	ld	h, a
;	spillPairReg hl
;	spillPairReg hl
	ld	de, $000B
	add	hl, de
	ld	a, [hl]
	and	a, $3F
	ld	[bc], a
;src/fatfs/lib/ff.c:2789: fno->fsize = ld_32(dp->dir + DIR_FileSize);		/* Size */
	ld	hl, sp+21
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	ld	c, a
	inc	de
	ld	a, [de]
	ld	b, a
	ld	hl, $001C
	add	hl, bc
	ld	e, l
	ld	d, h
	call	_ld_32
	ld	hl, sp+22
	ld	[hl], c
	inc	hl
	ld	[hl], b
	inc	hl
	ld	[hl], e
	inc	hl
	ld	[hl], d
	ld	hl, sp+27
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, sp+22
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
;src/fatfs/lib/ff.c:2790: fno->ftime = ld_16(dp->dir + DIR_ModTime + 0);	/* Last modified time */
	inc	hl
	inc	hl
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $0006
	add	hl, de
	ld	c, l
	ld	b, h
	ld	hl, sp+21
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	ld	l, a
;	spillPairReg hl
;	spillPairReg hl
	inc	de
	ld	a, [de]
	ld	h, a
;	spillPairReg hl
;	spillPairReg hl
	ld	de, $0016
	add	hl, de
	push	bc
	ld	e, l
	ld	d, h
	call	_ld_16
	ld	e, c
	ld	d, b
	pop	bc
	ld	a, e
	ld	[bc], a
	inc	bc
	ld	a, d
	ld	[bc], a
;src/fatfs/lib/ff.c:2791: fno->fdate = ld_16(dp->dir + DIR_ModTime + 2);	/* Last Modified date */
	ld	hl, sp+27
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $0004
	add	hl, de
	ld	c, l
	ld	b, h
	ld	hl, sp+21
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	ld	l, a
;	spillPairReg hl
;	spillPairReg hl
	inc	de
	ld	a, [de]
	ld	h, a
;	spillPairReg hl
;	spillPairReg hl
	ld	de, $0018
	add	hl, de
	push	bc
	ld	e, l
	ld	d, h
	call	_ld_16
	ld	e, c
	ld	d, b
	pop	bc
	ld	a, e
	ld	[bc], a
	inc	bc
	ld	a, d
	ld	[bc], a
.l00152:
;src/fatfs/lib/ff.c:2796: }
	add	sp, 32
	ret
;src/fatfs/lib/ff.c:2895: static FRESULT create_name (	/* FR_OK: successful, FR_INVALID_NAME: could not create */
;	---------------------------------
	SECTION FRAGMENT "src/fatfs/fatfs.c C",ROMX
; Function create_name
; ---------------------------------
_create_name:
	add	sp, -25
	ld	hl, sp+17
	ld	[hl], e
	inc	hl
	ld	[hl], d
	ld	hl, sp+15
	ld	[hl], c
	inc	hl
	ld	[hl], b
;src/fatfs/lib/ff.c:2910: p = *path; lfn = dp->obj.fs->lfnbuf; di = 0;
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	ld	hl, sp+0
	ld	[hl], a
	inc	de
	ld	a, [de]
	inc	hl
	ld	[hl], a
	ld	hl, sp+18
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	ld	c, a
	inc	de
	ld	a, [de]
	ld	b, a
	ld	hl, $000C
	add	hl, bc
	ld	e, l
	ld	d, h
	ld	a, [de]
	ld	hl, sp+2
	ld	[hl], a
	inc	de
	ld	a, [de]
	inc	hl
	ld	[hl], a
	xor	a, a
	ld	hl, sp+23
	ld	[hl], a
	inc	hl
	ld	[hl], a
.l00189:
;src/fatfs/lib/ff.c:2912: uc = tchar2uni(&p);			/* Get a character */
	ld	hl, sp+0
	ld	e, l
	ld	d, h
	call	_tchar2uni
	ld	hl, sp+19
	ld	[hl], c
	inc	hl
	ld	[hl], b
	inc	hl
	ld	[hl], e
	inc	hl
	ld	[hl], d
;src/fatfs/lib/ff.c:2913: if (uc == 0xFFFFFFFF) return FR_INVALID_NAME;		/* Invalid code or UTF decode error */
	ld	hl, sp+19
	ld	a, [hl]
	inc	hl
	and	a, [hl]
	inc	hl
	and	a, [hl]
	inc	hl
	and	a, [hl]
	inc	a
	jp	NZ,.l00430
	jp	.l00431
.l00430:
	jp	.l00102
.l00431:
	ld	a, $06
	jp	.l00195
.l00102:
;src/fatfs/lib/ff.c:2914: if (uc >= 0x10000) lfn[di++] = (WCHAR)(uc >> 16);	/* Store high surrogate if needed */
	ld	hl, sp+19
	ld	a, [hl]
	sub	a, $00
	inc	hl
	ld	a, [hl]
	sbc	a, $00
	inc	hl
	ld	a, [hl]
	sbc	a, $01
	inc	hl
	ld	a, [hl]
	sbc	a, $00
	jp	C, .l00104
	inc	hl
	ld	a, [hl]
	ld	hl, sp+13
	ld	[hl], a
	ld	hl, sp+24
	ld	a, [hl]
	ld	hl, sp+14
	ld	[hl], a
	ld	hl, sp+23
	inc	[hl]
	jp	NZ, .l00432
	inc	hl
	inc	[hl]
.l00432:
	ld	hl, sp+13
	ld	a, [hl]
	dec	hl
	dec	hl
	ld	[hl], a
	ld	hl, sp+14
	ld	a, [hl]
	dec	hl
	dec	hl
	ld	[hl], a
	dec	hl
	sla	[hl]
	inc	hl
	rl	[hl]
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, sp+2
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+15
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+14
	ld	[hl], a
	ld	hl, sp+21
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	ld	hl, sp+13
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	ld	[hl], c
	inc	hl
	ld	[hl], b
.l00104:
;src/fatfs/lib/ff.c:2915: wc = (WCHAR)uc;
	ld	hl, sp+19
	ld	a, [hl]
	ld	hl, sp+13
	ld	[hl], a
	ld	hl, sp+20
	ld	a, [hl]
	ld	hl, sp+14
	ld	[hl], a
;src/fatfs/lib/ff.c:2916: if (wc < ' ' || IsSeparator(wc)) break;	/* Break if end of the path or a separator is found */
	dec	hl
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	ld	a, c
	sub	a, $20
	ld	a, b
	sbc	a, $00
	ld	a, $00
	rla
	ld	hl, sp+22
	ld	[hl], a
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00114
	ld	a, c
	sub	a, $2F
	or	a, b
	jp	NZ,.l00434
	jp	.l00114
.l00434:
	ld	a, c
	sub	a, $5C
	or	a, b
	jp	NZ,.l00435
	jp	.l00114
.l00435:
;src/fatfs/lib/ff.c:2917: if (wc < 0x80 && strchr("*:<>|\"\?\x7F", (int)wc)) return FR_INVALID_NAME;	/* Reject illegal characters for LFN */
	ld	a, c
	sub	a, $80
	ld	a, b
	sbc	a, $00
	jp	NC, .l00110
	ld	hl, sp+13
	ld	a, [hl]
	ld	hl, sp+21
	ld	[hl], a
	ld	hl, sp+14
	ld	a, [hl]
	ld	hl, sp+22
	ld	[hl], a
	dec	hl
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	ld	de, ___str_0
	call	_strchr
	ld	hl, sp+21
	ld	[hl], c
	inc	hl
	ld	[hl], b
	ld	hl, sp+22
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	jp	Z, .l00110
	ld	a, $06
	jp	.l00195
.l00110:
;src/fatfs/lib/ff.c:2918: if (di >= FF_MAX_LFN) return FR_INVALID_NAME;	/* Reject too long name */
	ld	hl, sp+23
	ld	a, [hl]
	sub	a, $40
	inc	hl
	ld	a, [hl]
	sbc	a, $00
	jp	C, .l00113
	ld	a, $06
	jp	.l00195
.l00113:
;src/fatfs/lib/ff.c:2919: lfn[di++] = wc;				/* Store the Unicode character */
	ld	hl, sp+23
	ld	a, [hl]
	dec	hl
	dec	hl
	ld	[hl], a
	ld	hl, sp+24
	ld	a, [hl]
	dec	hl
	dec	hl
	ld	[hl], a
	inc	hl
	inc	[hl]
	jp	NZ, .l00436
	inc	hl
	inc	[hl]
.l00436:
	ld	hl, sp+21
	ld	a, [hl]
	dec	hl
	dec	hl
	ld	[hl], a
	ld	hl, sp+22
	ld	a, [hl]
	dec	hl
	dec	hl
	ld	[hl], a
	dec	hl
	sla	[hl]
	inc	hl
	rl	[hl]
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, sp+2
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+23
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+22
	ld	[hl], a
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, sp+13
	ld	a, [hl]
	ld	[de], a
	inc	de
	inc	hl
	ld	a, [hl]
	ld	[de], a
	jp	.l00189
.l00114:
;src/fatfs/lib/ff.c:2921: if (wc < ' ') {				/* Stopped at end of the path? */
	ld	hl, sp+22
	ld	a, [hl]
	or	a, a
	jp	Z, .l00208
;src/fatfs/lib/ff.c:2922: cf = NS_LAST;			/* Last segment */
	ld	hl, sp+19
	ld	[hl], $04
	jp	.l00123
;src/fatfs/lib/ff.c:2924: while (IsSeparator(*p)) p++;	/* Skip duplicated separators if exist */
.l00208:
	ld	hl, sp+0
	ld	a, [hl]
	ld	hl, sp+21
	ld	[hl], a
	ld	hl, sp+1
	ld	a, [hl]
	ld	hl, sp+22
	ld	[hl], a
.l00116:
	ld	hl, sp+22
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	cp	a, $2F
	jp	NZ,.l00438
	jp	.l00117
.l00438:
	cp	a, $5C
	jp	NZ,.l00439
	jp	.l00440
.l00439:
	jp	.l00243
.l00440:
.l00117:
	ld	hl, sp+21
	inc	[hl]
	jp	NZ, .l00441
	inc	hl
	inc	[hl]
.l00441:
	ld	hl, sp+21
	ld	a, [hl]
	ld	hl, sp+0
	ld	[hl], a
	ld	hl, sp+22
	ld	a, [hl]
	ld	hl, sp+1
	ld	[hl], a
	jp	.l00116
.l00243:
	push	af
	ld	hl, sp+23
	ld	a, [hl]
	ld	hl, sp+2
	ld	[hl], a
	ld	hl, sp+24
	ld	a, [hl]
	ld	hl, sp+3
	ld	[hl], a
	pop	af
;src/fatfs/lib/ff.c:2925: cf = 0;					/* Next segment may follow */
	ld	hl, sp+19
	ld	[hl], $00
;src/fatfs/lib/ff.c:2926: if (IsTerminator(*p)) cf = NS_LAST;	/* Ignore terminating separator */
	ld	c, a
	ld	b, $00
	ld	a, c
	sub	a, $20
	ld	a, b
	sbc	a, $00
	jp	NC, .l00123
	ld	[hl], $04
.l00123:
;src/fatfs/lib/ff.c:2928: *path = p;					/* Return pointer to the next segment */
	ld	hl, sp+16
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, sp+0
	ld	a, [hl]
	ld	[de], a
	inc	de
	inc	hl
	ld	a, [hl]
	ld	[de], a
;src/fatfs/lib/ff.c:2941: while (di) {					/* Snip off trailing spaces and dots if exist */
	ld	hl, sp+23
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
.l00127:
	ld	a, b
	or	a, c
	jp	Z, .l00244
;src/fatfs/lib/ff.c:2942: wc = lfn[di - 1];
	ld	de, $0001
	ld	a, c
	sub	a, e
	ld	e, a
	ld	a, b
	sbc	a, d
	ld	hl, sp+22
	ld	[hl], a
	dec	hl
	ld	[hl], e
	ld	a, [hl]
	inc	hl
	ld	d, [hl]
	add	a, a
	rl	d
	ld	e, a
	ld	hl, sp+2
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+25
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+24
	ld	[hl], a
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	ld	l, a
;	spillPairReg hl
;	spillPairReg hl
	inc	de
	ld	a, [de]
;src/fatfs/lib/ff.c:2943: if (wc != ' ' && wc != '.') break;
	ld	e, a
	ld	a, l
	sub	a, $20
	or	a, e
	jp	NZ,.l00443
	jp	.l00125
.l00443:
	ld	a, l
	sub	a, $2E
	or	a, e
	jp	NZ,.l00444
	jp	.l00445
.l00444:
	jp	.l00244
.l00445:
.l00125:
;src/fatfs/lib/ff.c:2944: di--;
	ld	hl, sp+21
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	jp	.l00127
.l00244:
	ld	hl, sp+4
	ld	[hl], c
	inc	hl
	ld	[hl], b
;src/fatfs/lib/ff.c:2946: lfn[di] = 0;							/* LFN is created into the working buffer */
	ld	a, c
	ld	d, b
	add	a, a
	rl	d
	ld	e, a
	ld	hl, sp+2
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	add	hl, de
	ld	e, l
	ld	d, h
	xor	a, a
	ld	[de], a
	inc	de
	ld	[de], a
;src/fatfs/lib/ff.c:2947: if (di == 0) return FR_INVALID_NAME;	/* Reject null name */
	ld	a, b
	or	a, c
	jp	NZ, .l00131
	ld	a, $06
	jp	.l00195
.l00131:
;src/fatfs/lib/ff.c:2950: for (si = 0; lfn[si] == ' '; si++) ;	/* Remove leading spaces */
	ld	bc, $0000
.l00192:
	ld	e, c
	ld	d, b
	sla	e
	rl	d
	ld	hl, sp+2
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+25
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+24
	ld	[hl], a
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	ld	l, a
;	spillPairReg hl
;	spillPairReg hl
	inc	de
	ld	a, [de]
	ld	e, l
	ld	d, a
	ld	a, e
	sub	a, $20
	or	a, d
	jp	NZ,.l00448
	jp	.l00449
.l00448:
	jp	.l00245
.l00449:
	inc	bc
	jp	.l00192
.l00245:
	ld	hl, sp+20
	ld	[hl], c
	inc	hl
	ld	[hl], b
;src/fatfs/lib/ff.c:2951: if (si > 0 || lfn[si] == '.') cf |= NS_LOSS | NS_LFN;	/* Is there any leading space or dot? */
	ld	a, b
	or	a, c
	jp	NZ, .l00133
	ld	a, e
	sub	a, $2E
	or	a, d
	jp	NZ,.l00450
	jp	.l00451
.l00450:
	jp	.l00137
.l00451:
.l00133:
	ld	hl, sp+19
	ld	a, [hl]
	or	a, $03
	ld	[hl], a
;src/fatfs/lib/ff.c:2952: while (di > 0 && lfn[di - 1] != '.') di--;	/* Find last dot (di<=si: no extension) */
.l00137:
	ld	hl, sp+5
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	jp	Z, .l00139
	inc	hl
	dec	hl
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	dec	bc
	ld	a, c
	ld	d, b
	add	a, a
	rl	d
	ld	e, a
	ld	hl, sp+2
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+25
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+24
	ld	[hl], a
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	ld	l, a
;	spillPairReg hl
;	spillPairReg hl
	inc	de
	ld	a, [de]
	ld	e, a
	ld	a, l
	sub	a, $2E
	or	a, e
	jp	NZ,.l00453
	jp	.l00139
.l00453:
	ld	hl, sp+4
	ld	[hl], c
	inc	hl
	ld	[hl], b
	jp	.l00137
.l00139:
;src/fatfs/lib/ff.c:2954: memset(dp->fn, ' ', 11);
	ld	hl, sp+18
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $001C
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+8
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+7
	ld	[hl], a
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	bc, $000B
	push	bc
	ld	bc, $0020
	call	_memset
;src/fatfs/lib/ff.c:2955: i = b = 0; ni = 8;
	ld	hl, sp+22
	ld	[hl], $00
	xor	a, a
	inc	hl
	ld	[hl], a
	inc	hl
	ld	[hl], a
	ld	hl, sp+8
	ld	[hl], $08
	xor	a, a
	inc	hl
	ld	[hl], a
.l00194:
;src/fatfs/lib/ff.c:2957: wc = lfn[si++];					/* Get an LFN character */
	ld	hl, sp+20
	ld	a, [hl]
	inc	hl
	ld	d, [hl]
	dec	hl
	inc	[hl]
	jp	NZ, .l00454
	inc	hl
	inc	[hl]
.l00454:
	add	a, a
	rl	d
	ld	e, a
	ld	hl, sp+2
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	add	hl, de
	ld	c, l
	ld	b, h
	ld	e, c
	ld	d, b
	ld	a, [de]
	ld	hl, sp+10
	ld	[hl], a
	inc	de
	ld	a, [de]
	inc	hl
	ld	[hl], a
;src/fatfs/lib/ff.c:2971: si = di; i = 8; ni = 11; b <<= 2;		/* Enter name extension */
	ld	hl, sp+22
	ld	a, [hl]
	add	a, a
	add	a, a
	ld	hl, sp+14
	ld	[hl], a
;src/fatfs/lib/ff.c:2958: if (wc == 0) break;				/* Break on end of the LFN */
	ld	hl, sp+11
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	jp	Z, .l00175
;src/fatfs/lib/ff.c:2916: if (wc < ' ' || IsSeparator(wc)) break;	/* Break if end of the path or a separator is found */
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
;src/fatfs/lib/ff.c:2951: if (si > 0 || lfn[si] == '.') cf |= NS_LOSS | NS_LFN;	/* Is there any leading space or dot? */
	ld	hl, sp+19
	ld	d, [hl]
	ld	a, d
	or	a, $03
	ld	d, a
;src/fatfs/lib/ff.c:2959: if (wc == ' ' || (wc == '.' && si != di)) {	/* Remove embedded spaces and dots */
	ld	a, c
	sub	a, $20
	or	a, b
	jp	NZ,.l00456
	jp	.l00142
.l00456:
	inc	hl
	ld	a, [hl]
	ld	hl, sp+4
	sub	a, [hl]
	jp	NZ,.l00457
	ld	hl, sp+21
	ld	a, [hl]
	ld	hl, sp+5
	sub	a, [hl]
	jp	NZ,.l00457
	ld	a,$01
	jp	.l00458
.l00457:
	xor	a,a
.l00458:
	ld	e, a
	ld	a, c
	sub	a, $2E
	or	a, b
	jp	NZ,.l00459
	jp	.l00460
.l00459:
	jp	.l00143
.l00460:
	bit	0, e
	jp	NZ, .l00143
.l00142:
;src/fatfs/lib/ff.c:2960: cf |= NS_LOSS | NS_LFN;
	ld	hl, sp+19
	ld	[hl], d
;src/fatfs/lib/ff.c:2961: continue;
	jp	.l00194
.l00143:
;src/fatfs/lib/ff.c:2964: if (i >= ni || si == di) {		/* End of field? */
	push	de
	ld	hl, sp+25
	ld	e, l
	ld	d, h
	ld	hl, sp+10
	ld	a, [de]
	inc	de
	sub	a, [hl]
	inc	hl
	ld	a, [de]
	sbc	a, [hl]
	pop	de
	jp	NC, .l00152
	ld	a, e
	or	a, a
	jp	Z, .l00153
.l00152:
;src/fatfs/lib/ff.c:2965: if (ni == 11) {				/* Name extension overflow? */
	ld	hl, sp+8
	ld	a, [hl]
	sub	a, $0B
	inc	hl
	or	a, [hl]
	jp	NZ,.l00461
	jp	.l00462
.l00461:
	jp	.l00147
.l00462:
;src/fatfs/lib/ff.c:2966: cf |= NS_LOSS | NS_LFN;
	ld	hl, sp+19
	ld	[hl], d
;src/fatfs/lib/ff.c:2967: break;
	jp	.l00175
.l00147:
;src/fatfs/lib/ff.c:2969: if (si != di) cf |= NS_LOSS | NS_LFN;	/* Name body overflow? */
	bit	0, e
	jp	NZ, .l00149
	ld	hl, sp+19
	ld	[hl], d
.l00149:
;src/fatfs/lib/ff.c:2970: if (si > di) break;						/* No name extension? */
	ld	hl, sp+4
	ld	e, l
	ld	d, h
	ld	hl, sp+20
	ld	a, [de]
	inc	de
	sub	a, [hl]
	inc	hl
	ld	a, [de]
	sbc	a, [hl]
	jp	C, .l00175
;src/fatfs/lib/ff.c:2971: si = di; i = 8; ni = 11; b <<= 2;		/* Enter name extension */
	ld	hl, sp+4
	ld	a, [hl]
	ld	hl, sp+20
	ld	[hl], a
	ld	hl, sp+5
	ld	a, [hl]
	ld	hl, sp+21
	ld	[hl], a
	inc	hl
	inc	hl
	ld	[hl], $08
	xor	a, a
	inc	hl
	ld	[hl], a
	ld	hl, sp+8
	ld	[hl], $0B
	xor	a, a
	inc	hl
	ld	[hl], a
	ld	hl, sp+14
	ld	a, [hl]
	ld	hl, sp+22
	ld	[hl], a
;src/fatfs/lib/ff.c:2972: continue;
	jp	.l00194
.l00153:
;src/fatfs/lib/ff.c:2975: if (wc >= 0x80) {	/* Is this an extended character? */
	ld	a, c
	sub	a, $80
	ld	a, b
	sbc	a, $00
	jp	C, .l00158
;src/fatfs/lib/ff.c:2976: cf |= NS_LFN;	/* LFN entry needs to be created */
	ld	hl, sp+19
	ld	a, [hl]
	or	a, $02
	ld	[hl], a
;src/fatfs/lib/ff.c:2985: wc = ff_uni2oem(wc, CODEPAGE);			/* Unicode ==> ANSI/OEM code */
	ld	hl, sp+10
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	ld	de, $0000
	ld	hl, $01B5
	push	hl
	call	_ff_uni2oem
	ld	hl, sp+10
	ld	[hl], c
	inc	hl
	ld	[hl], b
;src/fatfs/lib/ff.c:2986: if (wc & 0x80) wc = ExCvt[wc & 0x7F];	/* Convert extended character to upper (SBCS) */
	push	hl
	dec	hl
	bit	7, [hl]
	pop	hl
	jp	NZ,.l00463
	jp	.l00158
.l00463:
	ld	hl, sp+10
	ld	c, [hl]
	inc	hl
	ld	a, [hl]
	res	7, c
	ld	b, $00
	ld	hl, _ExCvt
	add	hl, bc
	ld	a, [hl]
	ld	hl, sp+10
	ld	[hl], a
	inc	hl
	ld	[hl], $00
.l00158:
;src/fatfs/lib/ff.c:2916: if (wc < ' ' || IsSeparator(wc)) break;	/* Break if end of the path or a separator is found */
	ld	hl, sp+10
	ld	a, [hl]
	ld	hl, sp+13
	ld	[hl], a
	dec	hl
	dec	hl
	ld	a, [hl]
	ld	hl, sp+14
	ld	[hl], a
;src/fatfs/lib/ff.c:2951: if (si > 0 || lfn[si] == '.') cf |= NS_LOSS | NS_LFN;	/* Is there any leading space or dot? */
	ld	hl, sp+19
	ld	a, [hl]
	or	a, $03
	ld	hl, sp+12
	ld	[hl], a
;src/fatfs/lib/ff.c:2992: if (wc >= 0x100) {				/* Is this a DBC? */
	inc	hl
	ld	a, [hl]
	sub	a, $00
	inc	hl
	ld	a, [hl]
	sbc	a, $01
	jp	C, .l00172
;src/fatfs/lib/ff.c:2993: if (i >= ni - 1) {			/* Field overflow? */
	ld	hl, sp+9
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $0001
	ld	a, e
	sub	a, l
	ld	e, a
	ld	a, d
	sbc	a, h
	ld	hl, sp+14
	ld	[hl], a
	dec	hl
	ld	[hl], e
	ld	hl, sp+23
	ld	e, l
	ld	d, h
	ld	hl, sp+13
	ld	a, [de]
	inc	de
	sub	a, [hl]
	inc	hl
	ld	a, [de]
	sbc	a, [hl]
	jp	C, .l00160
;src/fatfs/lib/ff.c:2994: cf |= NS_LOSS | NS_LFN;
	ld	hl, sp+12
	ld	a, [hl]
	ld	hl, sp+19
	ld	[hl], a
;src/fatfs/lib/ff.c:2995: i = ni; continue;		/* Next field */
	ld	hl, sp+8
	ld	a, [hl]
	ld	hl, sp+23
	ld	[hl], a
	ld	hl, sp+9
	ld	a, [hl]
	ld	hl, sp+24
	ld	[hl], a
	jp	.l00194
.l00160:
;src/fatfs/lib/ff.c:2997: dp->fn[i++] = (BYTE)(wc >> 8);	/* Put 1st byte */
	ld	hl, sp+23
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	dec	hl
	inc	[hl]
	jp	NZ, .l00464
	inc	hl
	inc	[hl]
.l00464:
	ld	hl, sp+6
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	add	hl, bc
	ld	c, l
	ld	b, h
	ld	hl, sp+11
	ld	a, [hl]
	ld	[bc], a
	jp	.l00173
.l00172:
;src/fatfs/lib/ff.c:2999: if (wc == 0 || strchr("+,;=[]", (int)wc)) {	/* Replace illegal characters for SFN */
	ld	hl, sp+11
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	jp	Z, .l00167
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	ld	de, ___str_1
	call	_strchr
	ld	a, b
	or	a, c
	jp	Z, .l00168
.l00167:
;src/fatfs/lib/ff.c:3000: wc = '_'; cf |= NS_LOSS | NS_LFN;/* Lossy conversion */
	ld	hl, sp+10
	ld	[hl], $5F
	xor	a, a
	inc	hl
	ld	[hl], a
	inc	hl
	ld	a, [hl]
	ld	hl, sp+19
	ld	[hl], a
	jp	.l00173
.l00168:
;src/fatfs/lib/ff.c:3002: if (IsUpper(wc)) {		/* ASCII upper case? */
	ld	hl, sp+13
	ld	a, [hl]
	sub	a, $41
	inc	hl
	ld	a, [hl]
	sbc	a, $00
	jp	C, .l00162
	dec	hl
	ld	a, $5A
	sub	a, [hl]
	inc	hl
	ld	a, $00
	sbc	a, [hl]
	jp	C, .l00162
;src/fatfs/lib/ff.c:3003: b |= 2;
	ld	hl, sp+22
	ld	a, [hl]
	or	a, $02
	ld	[hl], a
.l00162:
;src/fatfs/lib/ff.c:3005: if (IsLower(wc)) {		/* ASCII lower case? */
	ld	hl, sp+13
	ld	a, [hl]
	sub	a, $61
	inc	hl
	ld	a, [hl]
	sbc	a, $00
	jp	C, .l00173
	dec	hl
	ld	a, $7A
	sub	a, [hl]
	inc	hl
	ld	a, $00
	sbc	a, [hl]
	jp	C, .l00173
;src/fatfs/lib/ff.c:3006: b |= 1; wc -= 0x20;
	ld	hl, sp+22
	ld	a, [hl]
	or	a, $01
	ld	[hl], a
	ld	hl, sp+14
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $0020
	ld	a, e
	sub	a, l
	ld	e, a
	ld	a, d
	sbc	a, h
	ld	c, e
	ld	hl, sp+10
	ld	[hl], c
	inc	hl
	ld	[hl], a
.l00173:
;src/fatfs/lib/ff.c:3010: dp->fn[i++] = (BYTE)wc;
	ld	hl, sp+23
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	dec	hl
	inc	[hl]
	jp	NZ, .l00465
	inc	hl
	inc	[hl]
.l00465:
	ld	hl, sp+6
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	add	hl, bc
	ld	c, l
	ld	b, h
	ld	hl, sp+10
	ld	a, [hl]
	ld	[bc], a
	jp	.l00194
.l00175:
;src/fatfs/lib/ff.c:3013: if (dp->fn[0] == DDEM) dp->fn[0] = RDDEM;	/* If the first character collides with DDEM, replace it with RDDEM */
	ld	hl, sp+7
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	sub	a, $E5
	jp	NZ,.l00466
	jp	.l00467
.l00466:
	jp	.l00177
.l00467:
	dec	hl
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	ld	[hl], $05
.l00177:
;src/fatfs/lib/ff.c:3015: if (ni == 8) b <<= 2;				/* Shift capital flags if no extension */
	ld	hl, sp+8
	ld	a, [hl]
	sub	a, $08
	inc	hl
	or	a, [hl]
	jp	NZ,.l00468
	jp	.l00469
.l00468:
	jp	.l00179
.l00469:
	ld	hl, sp+14
	ld	a, [hl]
	ld	hl, sp+22
	ld	[hl], a
.l00179:
;src/fatfs/lib/ff.c:3016: if ((b & 0x0C) == 0x0C || (b & 0x03) == 0x03) cf |= NS_LFN;	/* LFN entry needs to be created if composite capitals */
	ld	hl, sp+22
	ld	a, [hl]
	dec	hl
	dec	hl
	ld	[hl], a
	inc	hl
	ld	[hl], $00
	dec	hl
	ld	a, [hl]
	and	a, $0C
	ld	c, a
	ld	b, $00
	ld	a, c
	sub	a, $0C
	or	a, b
	jp	NZ,.l00470
	jp	.l00180
.l00470:
	ld	a, [hl]
	and	a, $03
	ld	hl, sp+23
	ld	[hl], a
	inc	hl
	ld	[hl], $00
	dec	hl
	ld	a, [hl]
	sub	a, $03
	inc	hl
	or	a, [hl]
	jp	NZ,.l00471
	jp	.l00472
.l00471:
	jp	.l00181
.l00472:
.l00180:
	ld	hl, sp+19
	ld	a, [hl]
	or	a, $02
	ld	[hl], a
.l00181:
;src/fatfs/lib/ff.c:3017: if (!(cf & NS_LFN)) {				/* When LFN is in 8.3 format without extended character, NT flags are created */
	push	hl
	ld	hl, sp+21
	bit	1, [hl]
	pop	hl
	jp	NZ,.l00473
	jp	.l00474
.l00473:
	jp	.l00188
.l00474:
;src/fatfs/lib/ff.c:3018: if (b & 0x01) cf |= NS_EXT;		/* NT flag (Extension has small capital letters only) */
	push	hl
	ld	hl, sp+24
	bit	0, [hl]
	pop	hl
	jp	NZ,.l00475
	jp	.l00184
.l00475:
	ld	hl, sp+19
	ld	a, [hl]
	or	a, $10
	ld	[hl], a
.l00184:
;src/fatfs/lib/ff.c:3019: if (b & 0x04) cf |= NS_BODY;	/* NT flag (Body has small capital letters only) */
	push	hl
	ld	hl, sp+24
	bit	2, [hl]
	pop	hl
	jp	NZ,.l00476
	jp	.l00188
.l00476:
	ld	hl, sp+19
	ld	a, [hl]
	or	a, $08
	ld	[hl], a
.l00188:
;src/fatfs/lib/ff.c:3022: dp->fn[NSFLAG] = cf;	/* SFN is created into dp->fn[] */
	ld	hl, sp+7
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $000B
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+25
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+24
	ld	[hl], a
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, sp+19
	ld	a, [hl]
	ld	[de], a
;src/fatfs/lib/ff.c:3024: return FR_OK;
	xor	a, a
.l00195:
;src/fatfs/lib/ff.c:3095: }
	add	sp, 25
	ret
	SECTION FRAGMENT "src/fatfs/fatfs.c ROM0",ROM0
___str_0:
	DB "*:<>|"
	DB $22
	DB "?"
	DB $7F
	DB $00
	SECTION FRAGMENT "src/fatfs/fatfs.c ROM0",ROM0
___str_1:
	DB "+,;=[]"
	DB $00
;src/fatfs/lib/ff.c:3104: static FRESULT follow_path (	/* FR_OK(0): successful, !=0: error code */
;	---------------------------------
	SECTION FRAGMENT "src/fatfs/fatfs.c A",ROMX
; Function follow_path
; ---------------------------------
_follow_path:
	add	sp, -18
	ld	hl, sp+16
	ld	[hl], e
	inc	hl
	ld	[hl], d
	ld	hl, sp+14
	ld	[hl], c
	inc	hl
	ld	[hl], b
;src/fatfs/lib/ff.c:3111: FATFS *fs = dp->obj.fs;
	inc	hl
	inc	hl
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	ld	hl, sp+0
	ld	[hl], a
	inc	de
	ld	a, [de]
	inc	hl
	ld	[hl], a
;src/fatfs/lib/ff.c:3121: while (IsSeparator(*path)) path++;	/* Strip heading separators */
	ld	hl, sp+14
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
.l00102:
	ld	a, [bc]
	cp	a, $2F
	jp	NZ,.l00182
	jp	.l00103
.l00182:
	sub	a, $5C
	jp	NZ,.l00183
	jp	.l00184
.l00183:
	jp	.l00141
.l00184:
.l00103:
	inc	bc
	ld	hl, sp+14
	ld	[hl], c
	inc	hl
	ld	[hl], b
	jp	.l00102
.l00141:
	ld	hl, sp+14
	ld	[hl], c
	inc	hl
	ld	[hl], b
;src/fatfs/lib/ff.c:3122: dp->obj.sclust = 0;					/* Start at the root directory */
	inc	hl
	inc	hl
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $0006
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+4
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+3
	ld	[hl], a
	pop	bc
	pop	hl
	push	hl
	push	bc
	xor	a, a
	ld	[hl], a
	inc	hl
	ld	[hl], a
	inc	hl
	ld	[hl], a
	inc	hl
	ld	[hl], a
;src/fatfs/lib/ff.c:3145: if ((UINT)*path < ' ') {				/* Null path name is the origin directory itself */
	ld	hl, sp+14
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	ld	a, [bc]
	ld	c, a
	ld	b, $00
;src/fatfs/lib/ff.c:3146: dp->fn[NSFLAG] = NS_NONAME;
	inc	hl
	inc	hl
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $001C
	add	hl, de
	ld	e, l
	ld	d, h
	ld	hl, $000B
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+6
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+5
	ld	[hl], a
;src/fatfs/lib/ff.c:3145: if ((UINT)*path < ' ') {				/* Null path name is the origin directory itself */
	ld	a, c
	sub	a, $20
	ld	a, b
	sbc	a, $00
	jp	NC, .l00140
;src/fatfs/lib/ff.c:3146: dp->fn[NSFLAG] = NS_NONAME;
	dec	hl
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	ld	[hl], $80
;src/fatfs/lib/ff.c:3147: res = dir_sdi(dp, 0);
	ld	de, $0000
	push	de
	push	de
	ld	hl, sp+20
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_dir_sdi
	ld	hl, sp+13
	ld	[hl], a
	jp	.l00127
.l00140:
	ld	hl, sp+17
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $0004
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+8
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+7
	ld	[hl], a
	ld	hl, sp+17
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $000E
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+10
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+9
	ld	[hl], a
.l00128:
;src/fatfs/lib/ff.c:3151: res = create_name(dp, &path);	/* Get a segment name of the path */
	ld	hl, sp+14
	ld	c, l
	ld	b, h
	ld	hl, sp+16
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_create_name__far
	ld	hl, sp+13
	ld	[hl], a
;src/fatfs/lib/ff.c:3152: if (res != FR_OK) break;
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00127
;src/fatfs/lib/ff.c:3153: ns = dp->fn[NSFLAG];
	ld	hl, sp+5
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	ld	c, a
;src/fatfs/lib/ff.c:3174: res = dir_find(dp);				/* Find an object with the segment name */
	push	bc
	ld	hl, sp+18
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_dir_find
	pop	bc
	ld	hl, sp+13
	ld	[hl], a
;src/fatfs/lib/ff.c:3182: if (!(ns & NS_LAST)) res = FR_NO_PATH;	/* Adjust error code if not last segment */
	ld	a, c
	and	a, $04
	ld	c, a
	ld	b, $00
;src/fatfs/lib/ff.c:3175: if (res != FR_OK) {				/* Failed to find the object */
	ld	a, [hl]
	or	a, a
	jp	Z, .l00118
;src/fatfs/lib/ff.c:3176: if (res == FR_NO_FILE) {	/* Object is not found */
	ld	a, [hl]
	sub	a, $04
	jp	NZ,.l00185
	jp	.l00186
.l00185:
	jp	.l00127
.l00186:
;src/fatfs/lib/ff.c:3182: if (!(ns & NS_LAST)) res = FR_NO_PATH;	/* Adjust error code if not last segment */
	ld	a, b
	or	a, c
	jp	NZ, .l00127
	ld	hl, sp+13
	ld	[hl], $05
;src/fatfs/lib/ff.c:3185: break;
	jp	.l00127
.l00118:
;src/fatfs/lib/ff.c:3197: if (ns & NS_LAST) break;		/* If last segment matched, the function completed */
	ld	a, b
	or	a, c
	jp	NZ, .l00127
;src/fatfs/lib/ff.c:3199: if (!(dp->obj.attr & AM_DIR)) {
	ld	hl, sp+7
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	bit	4, a
	jp	NZ,.l00187
	jp	.l00188
.l00187:
	jp	.l00122
.l00188:
;src/fatfs/lib/ff.c:3200: res = FR_NO_PATH; break;	/* It is not a sub-directory and cannot follow the path */
	ld	hl, sp+13
	ld	[hl], $05
	jp	.l00127
.l00122:
;src/fatfs/lib/ff.c:3208: dp->obj.sclust = ld_clust(fs, fs->win + dp->dptr % SS(fs));	/* Open next directory */
	pop	de
	push	de
	ld	hl, $0032
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+14
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+13
	ld	[hl], a
	ld	hl, sp+9
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	ld	c, a
	inc	de
	ld	a, [de]
	ld	b, a
	inc	de
	ld	a, [de]
	ld	l, a
;	spillPairReg hl
;	spillPairReg hl
	inc	de
	ld	a, [de]
	ld	h, a
;	spillPairReg hl
;	spillPairReg hl
	ld	e, c
	ld	a, b
	and	a, $01
	ld	d, a
	ld	bc, $0000
	ld	hl, sp+12
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	add	hl, de
	ld	e, l
	ld	d, h
	ld	c, e
	ld	b, d
	pop	de
	push	de
	call	_ld_clust__far
	ld	hl, sp+10
	ld	[hl], c
	inc	hl
	ld	[hl], b
	inc	hl
	ld	[hl], e
	inc	hl
	ld	[hl], d
	pop	bc
	pop	de
	push	de
	push	bc
	ld	hl, sp+10
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
	jp	.l00128
.l00127:
;src/fatfs/lib/ff.c:3213: return res;
	ld	hl, sp+13
	ld	a, [hl]
.l00129:
;src/fatfs/lib/ff.c:3214: }
	add	sp, 18
	ret
;src/fatfs/lib/ff.c:3223: static int get_ldnumber (	/* Returns logical drive number (-1:invalid drive number or null pointer) */
;	---------------------------------
	SECTION FRAGMENT "src/fatfs/fatfs.c B",ROMX
; Function get_ldnumber
; ---------------------------------
_get_ldnumber:
	add	sp, -9
	ld	hl, sp+7
	ld	[hl], e
	inc	hl
	ld	[hl], d
;src/fatfs/lib/ff.c:3236: tt = tp = *path;
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	ld	hl, sp+5
	ld	[hl], a
	inc	de
	ld	a, [de]
	inc	hl
	ld	[hl], a
	dec	hl
	ld	a, [hl]
	ld	hl, sp+0
	ld	[hl], a
	ld	hl, sp+6
	ld	a, [hl]
	ld	hl, sp+1
	ld	[hl], a
;src/fatfs/lib/ff.c:3237: if (!tp) return -1;		/* Invalid path name? */
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	jp	NZ, .l00119
	ld	bc, $FFFF
	jp	.l00115
;src/fatfs/lib/ff.c:3238: do {					/* Find a colon in the path */
.l00119:
	ld	hl, sp+5
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
.l00104:
;src/fatfs/lib/ff.c:3239: chr = *tt++;
	ld	a, [bc]
	inc	bc
;src/fatfs/lib/ff.c:3240: } while (!IsTerminator(chr) && chr != ':');
	ld	l, a
;	spillPairReg hl
;	spillPairReg hl
	ld	d, $00
	sub	a, $3A
	jp	NZ,.l00158
	ld	a,$01
	jp	.l00159
.l00158:
	xor	a,a
.l00159:
	ld	e, a
	ld	a, l
	sub	a, $20
	ld	a, d
	sbc	a, $00
	jp	C, .l00125
	bit	0, e
	jp	Z, .l00104
.l00125:
	ld	hl, sp+2
	ld	[hl], c
	inc	hl
	ld	[hl], b
;src/fatfs/lib/ff.c:3242: if (chr == ':') {	/* Is there a DOS/Windows style volume ID? */
	ld	a, e
	or	a, a
	jp	Z, .l00114
;src/fatfs/lib/ff.c:3243: i = FF_VOLUMES;
	inc	hl
	ld	[hl], $01
	xor	a, a
	inc	hl
	ld	[hl], a
;src/fatfs/lib/ff.c:3244: if (IsDigit(*tp) && tp + 2 == tt) {	/* Is it a numeric volume ID + colon? */
	pop	de
	push	de
	ld	a, [de]
	inc	hl
	ld	[hl], a
	ld	a, [hl]
	sub	a, $30
	jp	C, .l00108
	ld	a, $39
	sub	a, [hl]
	jp	C, .l00108
	pop	de
	push	de
	inc	de
	inc	de
	ld	a, e
	sub	a, c
	jp	NZ,.l00160
	ld	a, d
	sub	a, b
	jp	NZ,.l00160
	jp	.l00161
.l00160:
	jp	.l00108
.l00161:
;src/fatfs/lib/ff.c:3245: i = (int)*tp - '0';	/* Get the logical drive number */
	ld	c, [hl]
	ld	b, $00
	ld	de, $0030
	ld	a, c
	sub	a, e
	ld	e, a
	ld	a, b
	sbc	a, d
	dec	hl
	ld	[hl], a
	dec	hl
	ld	[hl], e
.l00108:
;src/fatfs/lib/ff.c:3260: if (i >= FF_VOLUMES) return -1;	/* Not found or invalid volume ID */
	ld	hl, sp+4
	ld	a, [hl]
	sub	a, $01
	inc	hl
	ld	a, [hl]
	sbc	a, $00
	ld	d, [hl]
	ld	a, $00
	ld	e, a
	bit	7, e
	jp	Z, .l00162
	bit	7, d
	jp	NZ, .l00163
	cp	a, a
	jp	.l00163
.l00162:
	bit	7, d
	jp	Z, .l00163
	scf
.l00163:
	jp	C, .l00112
	ld	bc, $FFFF
	jp	.l00115
.l00112:
;src/fatfs/lib/ff.c:3261: *path = tt;		/* Snip the drive prefix off */
	ld	hl, sp+8
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, sp+2
	ld	a, [hl]
	ld	[de], a
	inc	de
	inc	hl
	ld	a, [hl]
	ld	[de], a
;src/fatfs/lib/ff.c:3262: return i;		/* Return the found drive number */
	inc	hl
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	jp	.l00115
.l00114:
;src/fatfs/lib/ff.c:3285: return 0;				/* Default drive is 0 */
	ld	bc, $0000
.l00115:
;src/fatfs/lib/ff.c:3287: }
	add	sp, 9
	ret
;src/fatfs/lib/ff.c:3370: static UINT check_fs (	/* 0:FAT/FAT32 VBR, 1:exFAT VBR, 2:Not FAT and valid BS, 3:Not FAT and invalid BS, 4:Disk error */
;	---------------------------------
	SECTION FRAGMENT "src/fatfs/fatfs.c B",ROMX
; Function check_fs
; ---------------------------------
_check_fs:
	add	sp, -4
	ld	hl, sp+2
	ld	[hl], e
	inc	hl
	ld	[hl], d
;src/fatfs/lib/ff.c:3379: fs->wflag = 0; fs->winsect = (LBA_t)0 - 1;		/* Invaidate window */
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $0004
	add	hl, de
	ld	c, l
	ld	b, h
	xor	a, a
	ld	[bc], a
	ld	hl, sp+3
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $001E
	add	hl, de
	ld	b, l
	ld	c, h
	ld	l, b
	ld	h, c
	ld	[hl], $FF
	inc	hl
	ld	[hl], $FF
	inc	hl
	ld	[hl], $FF
	inc	hl
	ld	[hl], $FF
;src/fatfs/lib/ff.c:3380: if (move_window(fs, sect) != FR_OK) return 4;	/* Load the boot sector */
	ld	hl, sp+8
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	push	de
	ld	hl, sp+8
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	push	de
	ld	hl, sp+6
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_move_window
	or	a, a
	jp	Z, .l00102
	ld	bc, $0004
	jp	.l00122
.l00102:
;src/fatfs/lib/ff.c:3381: sign = ld_16(fs->win + BS_55AA);
	ld	hl, sp+3
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $0032
	add	hl, de
	ld	e, l
	ld	d, h
	ld	hl, $01FE
	add	hl, de
	push	de
	ld	e, l
	ld	d, h
	call	_ld_16
	pop	de
;src/fatfs/lib/ff.c:3385: b = fs->win[BS_JmpBoot];
	ld	a, [de]
	ld	e, a
;src/fatfs/lib/ff.c:3387: if (sign == 0xAA55 && !memcmp(fs->win + BS_FilSysType32, "FAT32   ", 8)) {
	ld	a, c
	sub	a, $55
	jp	NZ,.l00206
	ld	a, b
	sub	a, $AA
	jp	NZ,.l00206
	ld	a,$01
	jp	.l00207
.l00206:
	xor	a,a
.l00207:
	ld	hl, sp+0
	ld	[hl], a
;src/fatfs/lib/ff.c:3386: if (b == 0xEB || b == 0xE9 || b == 0xE8) {	/* Valid JumpBoot code? (short jump, near jump or near call) */
	ld	a, e
	sub	a, $EB
	jp	NZ,.l00208
	jp	.l00118
.l00208:
	ld	a, e
	sub	a, $E9
	jp	NZ,.l00209
	jp	.l00118
.l00209:
	ld	a, e
	sub	a, $E8
	jp	NZ,.l00210
	jp	.l00211
.l00210:
	jp	.l00119
.l00211:
.l00118:
;src/fatfs/lib/ff.c:3387: if (sign == 0xAA55 && !memcmp(fs->win + BS_FilSysType32, "FAT32   ", 8)) {
	ld	hl, sp+3
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $0032
	add	hl, de
	ld	e, l
	ld	d, h
	ld	hl, sp+0
	ld	a, [hl]
	or	a, a
	jp	Z, .l00104
	ld	hl, $0052
	add	hl, de
	push	de
	ld	bc, $0008
	push	bc
	ld	bc, ___str_2
	ld	e, l
	ld	d, h
	call	_memcmp
	pop	de
	ld	a, b
	or	a, c
	jp	NZ, .l00104
;src/fatfs/lib/ff.c:3388: return 0;	/* It is an FAT32 VBR */
	ld	bc, $0000
	jp	.l00122
.l00104:
;src/fatfs/lib/ff.c:3391: w = ld_16(fs->win + BPB_BytsPerSec);
	ld	hl, $000B
	add	hl, de
	push	de
	ld	e, l
	ld	d, h
	call	_ld_16
	pop	de
;src/fatfs/lib/ff.c:3392: b = fs->win[BPB_SecPerClus];
	ld	hl, $000D
	add	hl, de
	ld	a, [hl]
	ld	hl, sp+1
	ld	[hl], a
;src/fatfs/lib/ff.c:3393: if ((w & (w - 1)) == 0 && w >= FF_MIN_SS && w <= FF_MAX_SS	/* Properness of sector size (512-4096 and 2^n) */
	ld	l, c
	ld	h, b
	dec	hl
	ld	a, l
	and	a, c
	ld	l, a
;	spillPairReg hl
;	spillPairReg hl
	ld	a, h
	and	a, b
	ld	h, a
;	spillPairReg hl
;	spillPairReg hl
	ld	a, h
	or	a, l
	jp	NZ, .l00119
	ld	a, b
	sub	a, $02
	jp	C, .l00119
;src/fatfs/lib/ff.c:3394: && b != 0 && (b & (b - 1)) == 0				/* Properness of cluster size (2^n) */
	xor	a, a
	cp	a, c
	ld	a, $02
	sbc	a, b
	jp	C, .l00119
	ld	hl, sp+1
	ld	a, [hl]
	or	a, a
	jp	Z, .l00119
	ld	c, [hl]
	ld	b, $00
	ld	l, c
	ld	h, b
	dec	hl
	ld	a, l
	and	a, c
	ld	c, a
	ld	a, h
	and	a, b
	ld	b, a
	ld	a, b
	or	a, c
	jp	NZ, .l00119
;src/fatfs/lib/ff.c:3395: && ld_16(fs->win + BPB_RsvdSecCnt) != 0		/* Properness of number of reserved sectors (MNBZ) */
	ld	hl, $000E
	add	hl, de
	push	de
	ld	e, l
	ld	d, h
	call	_ld_16
	pop	de
	ld	a, b
	or	a, c
	jp	Z, .l00119
;src/fatfs/lib/ff.c:3396: && (UINT)fs->win[BPB_NumFATs] - 1 <= 1		/* Properness of number of FATs (1 or 2) */
	ld	hl, $0010
	add	hl, de
	ld	c, [hl]
	ld	b, $00
	dec	bc
	ld	a, $01
	cp	a, c
	ld	a, $00
	sbc	a, b
	jp	C, .l00119
;src/fatfs/lib/ff.c:3397: && ld_16(fs->win + BPB_RootEntCnt) != 0		/* Properness of root dir size (MNBZ) */
	ld	hl, $0011
	add	hl, de
	push	de
	ld	e, l
	ld	d, h
	call	_ld_16
	pop	de
	ld	a, b
	or	a, c
	jp	Z, .l00119
;src/fatfs/lib/ff.c:3398: && (ld_16(fs->win + BPB_TotSec16) >= MIN_VOLUME || ld_32(fs->win + BPB_TotSec32) >= 0x10000)	/* Properness of volume size (>=128) */
	ld	hl, $0013
	add	hl, de
	push	de
	ld	e, l
	ld	d, h
	call	_ld_16
	pop	de
	ld	a, c
	sub	a, $40
	ld	a, b
	sbc	a, $00
	jp	NC, .l00117
	ld	hl, $0020
	add	hl, de
	push	de
	ld	e, l
	ld	d, h
	call	_ld_32
	ld	l, e
;	spillPairReg hl
;	spillPairReg hl
	ld	h, d
;	spillPairReg hl
;	spillPairReg hl
	pop	de
	ld	a, l
	sub	a, $01
	ld	a, h
	sbc	a, $00
	jp	C, .l00119
.l00117:
;src/fatfs/lib/ff.c:3399: && ld_16(fs->win + BPB_FATSz16) != 0) {		/* Properness of FAT size (MNBZ) */
	ld	hl, $0016
	add	hl, de
	ld	e, l
	ld	d, h
	call	_ld_16
	ld	a, b
	or	a, c
	jp	Z, .l00119
;src/fatfs/lib/ff.c:3400: return 0;	/* It can be presumed an FAT VBR */
	ld	bc, $0000
	jp	.l00122
.l00119:
;src/fatfs/lib/ff.c:3403: return sign == 0xAA55 ? 2 : 3;	/* Not an FAT VBR (with valid or invalid BS) */
	ld	hl, sp+0
	ld	a, [hl]
	or	a, a
	jp	Z, .l00124
	ld	bc, $0002
	jp	.l00125
.l00124:
	ld	bc, $0003
.l00125:
.l00122:
;src/fatfs/lib/ff.c:3404: }
	add	sp, 4
	pop	hl
	add	sp, 4
	jp hl 
	SECTION FRAGMENT "src/fatfs/fatfs.c ROM0",ROM0
___str_2:
	DB "FAT32   "
	DB $00
;src/fatfs/lib/ff.c:3410: static UINT find_volume (	/* Returns BS status found in the hosting drive */
;	---------------------------------
	SECTION FRAGMENT "src/fatfs/fatfs.c B",ROMX
; Function find_volume
; ---------------------------------
_find_volume:
	add	sp, -28
	ld	hl, sp+24
	ld	[hl], e
	inc	hl
	ld	[hl], d
;src/fatfs/lib/ff.c:3419: fmt = check_fs(fs, 0);				/* Load sector 0 and check if it is an FAT VBR as SFD format */
	push	bc
	ld	de, $0000
	push	de
	push	de
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_check_fs
	ld	e, c
	ld	d, b
	pop	bc
;src/fatfs/lib/ff.c:3420: if (fmt != 2 && (fmt >= 3 || part == 0)) return fmt;	/* Returns if it is an FAT VBR as auto scan, not a BS or disk error */
	ld	a, e
	sub	a, $02
	or	a, d
	jp	NZ,.l00169
	jp	.l00124
.l00169:
	ld	a, e
	sub	a, $03
	ld	a, d
	sbc	a, $00
	jp	NC, .l00101
	ld	a, b
	or	a, c
	jp	NZ, .l00124
.l00101:
	ld	c, e
	ld	b, d
	jp	.l00116
;src/fatfs/lib/ff.c:3447: for (i = 0; i < 4; i++) {		/* Load partition offset in the MBR */
.l00124:
	ld	hl, sp+25
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $0032
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+18
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+17
	ld	[hl], a
	xor	a, a
	ld	hl, sp+26
	ld	[hl], a
	inc	hl
	ld	[hl], a
.l00114:
;src/fatfs/lib/ff.c:3448: mbr_pt[i] = ld_32(fs->win + MBR_Table + i * SZ_PTE + PTE_StLba);
	ld	hl, sp+26
	ld	a, [hl]
	inc	hl
	ld	d, [hl]
	add	a, a
	rl	d
	add	a, a
	rl	d
	ld	e, a
	ld	hl, 0
	add	hl, sp
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+20
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+19
	ld	[hl], a
	ld	hl, sp+26
	ld	a, [hl]
	inc	hl
	ld	d, [hl]
	add	a, a
	rl	d
	add	a, a
	rl	d
	add	a, a
	rl	d
	add	a, a
	rl	d
	add	a, $C6
	ld	e, a
	ld	a, d
	adc	a, $01
	ld	d, a
	ld	hl, sp+16
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	add	hl, de
	ld	e, l
	ld	d, h
	push	bc
	call	_ld_32
	ld	hl, sp+22
	ld	[hl], c
	inc	hl
	ld	[hl], b
	inc	hl
	ld	[hl], e
	inc	hl
	ld	[hl], d
	pop	bc
	ld	hl, sp+19
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
	inc	de
	inc	hl
	ld	a, [hl]
	ld	[de], a
	inc	de
	inc	hl
	ld	a, [hl]
	ld	[de], a
;src/fatfs/lib/ff.c:3447: for (i = 0; i < 4; i++) {		/* Load partition offset in the MBR */
	ld	hl, sp+26
	inc	[hl]
	jp	NZ, .l00172
	inc	hl
	inc	[hl]
.l00172:
	ld	hl, sp+26
	ld	a, [hl]
	sub	a, $04
	inc	hl
	ld	a, [hl]
	sbc	a, $00
	jp	C, .l00114
;src/fatfs/lib/ff.c:3450: i = part ? part - 1 : 0;		/* Table index to find first */
	ld	a, b
	or	a, c
	jp	Z, .l00118
	ld	e, c
	ld	d, b
	dec	de
	jp	.l00119
.l00118:
	ld	de, $0000
.l00119:
	ld	hl, sp+26
	ld	[hl], e
	inc	hl
	ld	[hl], d
;src/fatfs/lib/ff.c:3451: do {							/* Find an FAT volume */
.l00111:
;src/fatfs/lib/ff.c:3452: fmt = mbr_pt[i] ? check_fs(fs, mbr_pt[i]) : 3;	/* Check if the partition is FAT */
	ld	hl, sp+27
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	sla	e
	rl	d
	sla	e
	rl	d
	ld	hl, 0
	add	hl, sp
	add	hl, de
	ld	e, l
	ld	d, h
	ld	a, [de]
	ld	hl, sp+20
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
	ld	hl, sp+23
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	dec	hl
	or	a, [hl]
	dec	hl
	or	a, [hl]
	jp	Z, .l00120
	push	bc
	inc	hl
	inc	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	push	de
	ld	hl, sp+24
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	push	de
	ld	hl, sp+30
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_check_fs
	ld	e, c
	ld	d, b
	pop	bc
	jp	.l00121
.l00120:
	ld	de, $0003
.l00121:
;src/fatfs/lib/ff.c:3453: } while (part == 0 && fmt >= 2 && ++i < 4);
	ld	a, b
	or	a, c
	jp	NZ, .l00113
	ld	a, e
	sub	a, $02
	ld	a, d
	sbc	a, $00
	jp	C, .l00113
	ld	hl, sp+26
	inc	[hl]
	jp	NZ, .l00174
	inc	hl
	inc	[hl]
.l00174:
	ld	hl, sp+26
	ld	a, [hl]
	sub	a, $04
	inc	hl
	ld	a, [hl]
	sbc	a, $00
	jp	C, .l00111
.l00113:
;src/fatfs/lib/ff.c:3454: return fmt;
	ld	c, e
	ld	b, d
.l00116:
;src/fatfs/lib/ff.c:3455: }
	add	sp, 28
	ret
;src/fatfs/lib/ff.c:3464: static FRESULT mount_volume (	/* FR_OK(0): successful, !=0: an error occurred */
;	---------------------------------
	SECTION FRAGMENT "src/fatfs/fatfs.c B",ROMX
; Function mount_volume
; ---------------------------------
_mount_volume:
	add	sp, -42
	ld	hl, sp+40
	ld	[hl], e
	inc	hl
	ld	[hl], d
	ld	hl, sp+38
	ld	[hl], c
	inc	hl
	ld	[hl], b
;src/fatfs/lib/ff.c:3478: *rfs = 0;
	dec	hl
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	xor	a, a
	ld	[hl], a
	inc	hl
	ld	[hl], a
;src/fatfs/lib/ff.c:3479: vol = get_ldnumber(path);
	ld	hl, sp+40
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_get_ldnumber
	ld	hl, sp+36
	ld	[hl], c
	inc	hl
	ld	[hl], b
;src/fatfs/lib/ff.c:3480: if (vol < 0) return FR_INVALID_DRIVE;
	ld	a, [hl]
	bit	7, a
	jp	Z, .l00102
	ld	a, $0B
	jp	.l00174
.l00102:
;src/fatfs/lib/ff.c:3483: fs = FatFs[vol];					/* Get pointer to the filesystem object */
	ld	hl, sp+37
	dec	hl
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	sla	c
	rl	b
	ld	hl, _FatFs
	add	hl, bc
	ld	e, l
	ld	d, h
	ld	a, [de]
	ld	hl, sp+4
	ld	[hl], a
	inc	de
	ld	a, [de]
	inc	hl
	ld	[hl], a
;src/fatfs/lib/ff.c:3484: if (!fs) return FR_NOT_ENABLED;		/* Is the filesystem object available? */
	ld	hl, sp+5
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	jp	NZ, .l00104
	ld	a, $0C
	jp	.l00174
.l00104:
;src/fatfs/lib/ff.c:3488: *rfs = fs;							/* Return pointer to the filesystem object */
	ld	hl, sp+39
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, sp+4
	ld	a, [hl]
	ld	[de], a
	inc	de
	inc	hl
	ld	a, [hl]
	ld	[de], a
;src/fatfs/lib/ff.c:3490: mode &= (BYTE)~FA_READ;				/* Desired access mode, write access or not */
	ld	hl, sp+44
	ld	a, [hl]
	and	a, $FE
	ld	[hl], a
;src/fatfs/lib/ff.c:3491: if (fs->fs_type != 0) {				/* If the volume has been mounted */
	ld	hl, sp+5
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
;src/fatfs/lib/ff.c:3492: stat = disk_status(fs->pdrv);
	dec	hl
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	inc	bc
;src/fatfs/lib/ff.c:3491: if (fs->fs_type != 0) {				/* If the volume has been mounted */
	or	a, a
	jp	Z, .l00112
;src/fatfs/lib/ff.c:3492: stat = disk_status(fs->pdrv);
	ld	a, [bc]
	ld	e, a
	push	bc
	ld	a, e
	call	_disk_status
	pop	bc
	ld	e, a
;src/fatfs/lib/ff.c:3493: if (!(stat & STA_NOINIT)) {		/* and the physical drive is kept initialized */
	bit	0, e
	jp	NZ,.l00374
	jp	.l00375
.l00374:
	jp	.l00112
.l00375:
;src/fatfs/lib/ff.c:3494: if (!FF_FS_READONLY && mode && (stat & STA_PROTECT)) {	/* Check write protection if needed */
	ld	hl, sp+44
	ld	a, [hl]
	or	a, a
	jp	Z, .l00106
	bit	2, e
	jp	NZ,.l00376
	jp	.l00106
.l00376:
;src/fatfs/lib/ff.c:3495: return FR_WRITE_PROTECTED;
	ld	a, $0A
	jp	.l00174
.l00106:
;src/fatfs/lib/ff.c:3497: return FR_OK;				/* The filesystem object is already valid */
	xor	a, a
	jp	.l00174
.l00112:
;src/fatfs/lib/ff.c:3504: fs->fs_type = 0;					/* Invalidate the filesystem object */
	ld	hl, sp+4
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	ld	[hl], $00
;src/fatfs/lib/ff.c:3505: stat = disk_initialize(fs->pdrv);	/* Initialize the volume hosting physical drive */
	ld	a, [bc]
	ld	c, a
	ld	a, c
	call	_disk_initialize
	ld	c, a
;src/fatfs/lib/ff.c:3506: if (stat & STA_NOINIT) { 			/* Check if the initialization succeeded */
	bit	0, c
	jp	NZ,.l00377
	jp	.l00117
.l00377:
;src/fatfs/lib/ff.c:3507: return FR_NOT_READY;			/* Failed to initialize due to no medium or hard error */
	ld	a, $03
	jp	.l00174
;src/fatfs/lib/ff.c:3509: if (!FF_FS_READONLY && mode && (stat & STA_PROTECT)) { /* Check disk write protection if needed */
.l00117:
	ld	hl, sp+44
	ld	a, [hl]
	or	a, a
	jp	Z, .l00116
	bit	2, c
	jp	NZ,.l00378
	jp	.l00116
.l00378:
;src/fatfs/lib/ff.c:3510: return FR_WRITE_PROTECTED;
	ld	a, $0A
	jp	.l00174
.l00116:
;src/fatfs/lib/ff.c:3518: fmt = find_volume(fs, LD2PT(vol));
	ld	bc, $0000
	ld	hl, sp+4
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_find_volume
;src/fatfs/lib/ff.c:3519: if (fmt == 4) return FR_DISK_ERR;		/* An error occurred in the disk I/O layer */
	ld	a, c
	sub	a, $04
	or	a, b
	jp	NZ,.l00379
	jp	.l00380
.l00379:
	jp	.l00120
.l00380:
	ld	a, $01
	jp	.l00174
.l00120:
;src/fatfs/lib/ff.c:3520: if (fmt >= 2) return FR_NO_FILESYSTEM;	/* No FAT volume is found */
	ld	a, c
	sub	a, $02
	ld	a, b
	sbc	a, $00
	jp	C, .l00122
	ld	a, $0D
	jp	.l00174
.l00122:
;src/fatfs/lib/ff.c:3521: bsect = fs->winsect;					/* Volume offset in the hosting physical drive */
	ld	hl, sp+5
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $001E
	add	hl, de
	ld	c, l
	ld	b, h
	ld	e, c
	ld	d, b
	ld	a, [de]
	ld	hl, sp+6
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
;src/fatfs/lib/ff.c:3592: if (ld_16(fs->win + BPB_BytsPerSec) != SS(fs)) return FR_NO_FILESYSTEM;	/* (BPB_BytsPerSec must be equal to the physical sector size) */
	ld	hl, sp+5
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $0032
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+12
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+11
	ld	[hl], a
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $000B
	add	hl, de
	ld	e, l
	ld	d, h
	call	_ld_16
	ld	a, c
	or	a, a
	jp	NZ,.l00381
	ld	a, b
	sub	a, $02
	jp	NZ,.l00381
	jp	.l00124
.l00381:
	ld	a, $0D
	jp	.l00174
.l00124:
;src/fatfs/lib/ff.c:3594: fasize = ld_16(fs->win + BPB_FATSz16);		/* Number of sectors per FAT */
	ld	hl, sp+11
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $0016
	add	hl, de
	ld	e, l
	ld	d, h
	call	_ld_16
	ld	hl, sp+34
	ld	[hl], c
	inc	hl
	ld	[hl], b
	xor	a, a
	inc	hl
	ld	[hl], a
	inc	hl
	ld	[hl], a
;src/fatfs/lib/ff.c:3595: if (fasize == 0) fasize = ld_32(fs->win + BPB_FATSz32);
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	dec	hl
	or	a, [hl]
	dec	hl
	or	a, [hl]
	jp	NZ, .l00126
	ld	hl, sp+11
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $0024
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+38
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+37
	ld	[hl], a
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_ld_32
	ld	hl, sp+34
	ld	[hl], c
	inc	hl
	ld	[hl], b
	inc	hl
	ld	[hl], e
	inc	hl
	ld	[hl], d
.l00126:
;src/fatfs/lib/ff.c:3596: if (fasize >= 0x200000) return FR_NO_FILESYSTEM;	/* (Must be smaller than max FAT size) */
	ld	hl, sp+34
	ld	a, [hl]
	sub	a, $00
	inc	hl
	ld	a, [hl]
	sbc	a, $00
	inc	hl
	ld	a, [hl]
	sbc	a, $20
	inc	hl
	ld	a, [hl]
	sbc	a, $00
	jp	C, .l00128
	ld	a, $0D
	jp	.l00174
.l00128:
;src/fatfs/lib/ff.c:3597: fs->fsize = fasize;
	ld	hl, sp+5
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $001A
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+14
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+13
	ld	[hl], a
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, sp+34
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
;src/fatfs/lib/ff.c:3599: fs->n_fats = fs->win[BPB_NumFATs];				/* Number of FATs */
	ld	hl, sp+4
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	inc	bc
	inc	bc
	inc	bc
	ld	hl, sp+11
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $0010
	add	hl, de
	ld	e, l
	ld	d, h
	ld	a, [de]
	ld	[bc], a
;src/fatfs/lib/ff.c:3600: if (fs->n_fats != 1 && fs->n_fats != 2) return FR_NO_FILESYSTEM;	/* (Must be 1 or 2) */
	push	af
	ld	a, [bc]
	ld	c, a
	pop	af
	dec	a
	jp	NZ,.l00382
	jp	.l00130
.l00382:
	ld	a, c
	sub	a, $02
	jp	NZ,.l00383
	jp	.l00130
.l00383:
	ld	a, $0D
	jp	.l00174
.l00130:
;src/fatfs/lib/ff.c:3601: fasize *= fs->n_fats;							/* Number of sectors for FAT area */
	xor	a, a
	ld	e, a
	ld	d, a
	push	de
	ld	b, a
	push	bc
	ld	hl, sp+38
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	inc	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	__mullong
	ld	hl, sp+14
	ld	[hl], c
	inc	hl
	ld	[hl], b
	inc	hl
	ld	[hl], e
	inc	hl
	ld	[hl], d
;src/fatfs/lib/ff.c:3603: fs->csize = fs->win[BPB_SecPerClus];			/* Cluster size */
	ld	hl, sp+5
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $000A
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+30
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+29
	ld	[hl], a
	ld	hl, sp+11
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $000D
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, [bc]
	ld	c, a
	ld	b, $00
	ld	hl, sp+28
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	ld	[hl], c
	inc	hl
	ld	[hl], b
;src/fatfs/lib/ff.c:3604: if (fs->csize == 0 || (fs->csize & (fs->csize - 1))) return FR_NO_FILESYSTEM;	/* (Must be power of 2) */
	ld	hl, sp+29
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	ld	h, a
;	spillPairReg hl
;	spillPairReg hl
	inc	de
	ld	a, [de]
	ld	l, a
;	spillPairReg hl
;	spillPairReg hl
	ld	a, b
	or	a, c
	jp	Z, .l00132
	ld	a, h
	ld	c, a
	ld	b, l
	dec	bc
	and	a, c
	ld	c, a
	ld	a, l
	and	a, b
	or	a, c
	jp	Z, .l00133
.l00132:
	ld	a, $0D
	jp	.l00174
.l00133:
;src/fatfs/lib/ff.c:3606: fs->n_rootdir = ld_16(fs->win + BPB_RootEntCnt);	/* Number of root directory entries */
	ld	hl, sp+5
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $0008
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+20
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+19
	ld	[hl], a
	ld	hl, sp+11
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $0011
	add	hl, de
	ld	e, l
	ld	d, h
	call	_ld_16
	ld	hl, sp+18
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	ld	[hl], c
	inc	hl
	ld	[hl], b
;src/fatfs/lib/ff.c:3607: if (fs->n_rootdir % (SS(fs) / SZDIRE)) return FR_NO_FILESYSTEM;	/* (Must be sector aligned) */
	ld	a, c
	and	a, $0F
	jp	NZ,.l00384
	jp	.l00136
.l00384:
	ld	a, $0D
	jp	.l00174
.l00136:
;src/fatfs/lib/ff.c:3609: tsect = ld_16(fs->win + BPB_TotSec16);			/* Number of sectors on the volume */
	ld	hl, sp+11
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $0013
	add	hl, de
	ld	e, l
	ld	d, h
	call	_ld_16
	ld	hl, sp+30
	ld	[hl], c
	inc	hl
	ld	[hl], b
	xor	a, a
	inc	hl
	ld	[hl], a
	inc	hl
	ld	[hl], a
;src/fatfs/lib/ff.c:3610: if (tsect == 0) tsect = ld_32(fs->win + BPB_TotSec32);
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	dec	hl
	or	a, [hl]
	dec	hl
	or	a, [hl]
	jp	NZ, .l00138
	ld	hl, sp+11
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $0020
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+38
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+37
	ld	[hl], a
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_ld_32
	ld	hl, sp+34
	ld	[hl], c
	inc	hl
	ld	[hl], b
	inc	hl
	ld	[hl], e
	inc	hl
	ld	[hl], d
	ld	hl, sp+34
	ld	d, h
	ld	e, l
	ld	hl, sp+30
	ld	a, [de]
	ld	[hl+], a
	inc	de
	ld	a, [de]
	ld	[hl+], a
	inc	de
	ld	a, [de]
	ld	[hl+], a
	inc	de
	ld	a, [de]
	ld	[hl], a
.l00138:
;src/fatfs/lib/ff.c:3612: nrsv = ld_16(fs->win + BPB_RsvdSecCnt);			/* Number of reserved sectors */
	ld	hl, sp+11
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $000E
	add	hl, de
	ld	e, l
	ld	d, h
	call	_ld_16
	ld	e, c
	ld	d, b
;src/fatfs/lib/ff.c:3613: if (nrsv == 0) return FR_NO_FILESYSTEM;			/* (Must not be 0) */
	ld	a, b
	or	a, c
	jp	NZ, .l00140
	ld	a, $0D
	jp	.l00174
.l00140:
;src/fatfs/lib/ff.c:3616: sysect = nrsv + fasize + fs->n_rootdir / (SS(fs) / SZDIRE);	/* RSV + FAT + DIR */
	ld	hl, sp+20
	ld	[hl], e
	inc	hl
	ld	[hl], d
	xor	a, a
	inc	hl
	ld	[hl], a
	inc	hl
	ld	[hl], a
	dec	hl
	dec	hl
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, e
	ld	hl, sp+14
	add	a, [hl]
	ld	e, a
	ld	a, d
	inc	hl
	adc	a, [hl]
	push	af
	ld	hl, sp+3
	ld	[hl], a
	dec	hl
	ld	[hl], e
	ld	hl, sp+25
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, sp+18
	pop	af
	ld	a, e
	adc	a, [hl]
	ld	e, a
	ld	a, d
	inc	hl
	adc	a, [hl]
	ld	hl, sp+3
	ld	[hl], a
	dec	hl
	ld	[hl], e
	ld	hl, sp+19
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	ld	c, a
	inc	de
	ld	a, [de]
	ld	b, a
	ld	a, $04
.l00385:
	srl	b
	rr	c
	dec	a
	jp	NZ, .l00385
	ld	hl, sp+24
	ld	[hl], c
	inc	hl
	ld	[hl], b
	xor	a, a
	inc	hl
	ld	[hl], a
	inc	hl
	ld	[hl], a
	pop	de
	push	de
	ld	a, e
	ld	hl, sp+24
	add	a, [hl]
	ld	e, a
	ld	a, d
	inc	hl
	adc	a, [hl]
	push	af
	ld	hl, sp+37
	ld	[hl], a
	dec	hl
	ld	[hl], e
	ld	hl, sp+5
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, sp+28
	pop	af
	ld	a, e
	adc	a, [hl]
	ld	e, a
	ld	a, d
	inc	hl
	adc	a, [hl]
	ld	hl, sp+37
	ld	[hl], a
	dec	hl
	ld	[hl], e
	dec	hl
	dec	hl
	ld	d, h
	ld	e, l
	ld	hl, sp+24
	ld	a, [de]
	ld	[hl+], a
	inc	de
	ld	a, [de]
	ld	[hl+], a
	inc	de
	ld	a, [de]
	ld	[hl+], a
	inc	de
	ld	a, [de]
	ld	[hl], a
;src/fatfs/lib/ff.c:3617: if (tsect < sysect) return FR_NO_FILESYSTEM;	/* (Invalid volume size) */
	ld	hl, sp+30
	ld	e, l
	ld	d, h
	ld	hl, sp+24
	ld	a, [de]
	inc	de
	sub	a, [hl]
	inc	hl
	ld	a, [de]
	inc	de
	sbc	a, [hl]
	inc	hl
	ld	a, [de]
	inc	de
	sbc	a, [hl]
	inc	hl
	ld	a, [de]
	sbc	a, [hl]
	jp	NC, .l00142
	ld	a, $0D
	jp	.l00174
.l00142:
;src/fatfs/lib/ff.c:3618: nclst = (tsect - sysect) / fs->csize;			/* Number of clusters */
	ld	hl, sp+31
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, e
	ld	hl, sp+24
	sub	a, [hl]
	ld	e, a
	ld	a, d
	inc	hl
	sbc	a, [hl]
	push	af
	ld	hl, sp+37
	ld	[hl], a
	dec	hl
	ld	[hl], e
	dec	hl
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, sp+28
	pop	af
	ld	a, e
	sbc	a, [hl]
	ld	e, a
	ld	a, d
	inc	hl
	sbc	a, [hl]
	ld	hl, sp+37
	ld	[hl], a
	dec	hl
	ld	[hl], e
	ld	hl, sp+29
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	ld	c, a
	inc	de
	ld	a, [de]
	ld	de, $0000
	push	de
	ld	b, a
	push	bc
	ld	hl, sp+38
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	inc	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	__divulong
	pop	hl
	push	bc
	ld	hl, sp+2
	ld	[hl], e
	inc	hl
	ld	[hl], d
;src/fatfs/lib/ff.c:3619: if (nclst == 0) return FR_NO_FILESYSTEM;		/* (Invalid volume size) */
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	dec	hl
	or	a, [hl]
	dec	hl
	or	a, [hl]
	jp	NZ, .l00144
	ld	a, $0D
	jp	.l00174
.l00144:
;src/fatfs/lib/ff.c:3620: fmt = 0;
	xor	a, a
	ld	hl, sp+28
	ld	[hl], a
	inc	hl
	ld	[hl], a
;src/fatfs/lib/ff.c:3621: if (nclst <= MAX_FAT32) fmt = FS_FAT32;
	ld	hl, sp+0
	ld	a, $F5
	sub	a, [hl]
	inc	hl
	ld	a, $FF
	sbc	a, [hl]
	inc	hl
	ld	a, $FF
	sbc	a, [hl]
	inc	hl
	ld	a, $0F
	sbc	a, [hl]
	jp	C, .l00146
	ld	hl, sp+28
	ld	[hl], $03
	xor	a, a
	inc	hl
	ld	[hl], a
.l00146:
;src/fatfs/lib/ff.c:3622: if (nclst <= MAX_FAT16) fmt = FS_FAT16;
	ld	hl, sp+0
	ld	a, $F5
	sub	a, [hl]
	inc	hl
	ld	a, $FF
	sbc	a, [hl]
	inc	hl
	ld	a, $00
	sbc	a, [hl]
	inc	hl
	ld	a, $00
	sbc	a, [hl]
	jp	C, .l00148
	ld	hl, sp+28
	ld	[hl], $02
	xor	a, a
	inc	hl
	ld	[hl], a
.l00148:
;src/fatfs/lib/ff.c:3623: if (nclst <= MAX_FAT12) fmt = FS_FAT12;
	ld	hl, sp+0
	ld	a, $F5
	sub	a, [hl]
	inc	hl
	ld	a, $0F
	sbc	a, [hl]
	inc	hl
	ld	a, $00
	sbc	a, [hl]
	inc	hl
	ld	a, $00
	sbc	a, [hl]
	jp	C, .l00150
	ld	hl, sp+28
	ld	[hl], $01
	xor	a, a
	inc	hl
	ld	[hl], a
.l00150:
;src/fatfs/lib/ff.c:3624: if (nclst <= MIN_FAT12) fmt = 0;
	ld	hl, sp+0
	ld	a, $20
	sub	a, [hl]
	inc	hl
	ld	a, $00
	sbc	a, [hl]
	inc	hl
	ld	a, $00
	sbc	a, [hl]
	inc	hl
	ld	a, $00
	sbc	a, [hl]
	jp	C, .l00152
	xor	a, a
	ld	hl, sp+28
	ld	[hl], a
	inc	hl
	ld	[hl], a
.l00152:
;src/fatfs/lib/ff.c:3625: if (fmt == 0) return FR_NO_FILESYSTEM;
	ld	hl, sp+29
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	jp	NZ, .l00154
	ld	a, $0D
	jp	.l00174
.l00154:
;src/fatfs/lib/ff.c:3628: fs->n_fatent = nclst + 2;						/* Number of FAT entries */
	ld	hl, sp+5
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $0016
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+32
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+31
	ld	[hl], a
	pop	de
	push	de
	ld	a, e
	add	a, $02
	ld	e, a
	ld	a, d
	adc	a, $00
	push	af
	ld	hl, sp+37
	ld	[hl], a
	dec	hl
	ld	[hl], e
	ld	hl, sp+5
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	pop	af
	ld	a, e
	adc	a, $00
	ld	e, a
	ld	a, d
	adc	a, $00
	ld	hl, sp+37
	ld	[hl], a
	dec	hl
	ld	[hl], e
	ld	hl, sp+31
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, sp+34
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
;src/fatfs/lib/ff.c:3629: fs->volbase = bsect;							/* Volume start sector */
	ld	hl, sp+5
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $0022
	add	hl, de
	ld	c, l
	ld	b, h
	ld	hl, sp+6
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
;src/fatfs/lib/ff.c:3630: fs->fatbase = bsect + nrsv; 					/* FAT start sector */
	ld	hl, sp+5
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $0026
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+34
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+33
	ld	[hl], a
	ld	hl, sp+7
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, e
	ld	hl, sp+20
	add	a, [hl]
	ld	e, a
	ld	a, d
	inc	hl
	adc	a, [hl]
	push	af
	ld	hl, sp+37
	ld	[hl], a
	dec	hl
	ld	[hl], e
	ld	hl, sp+11
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, sp+24
	pop	af
	ld	a, e
	adc	a, [hl]
	ld	e, a
	ld	a, d
	inc	hl
	adc	a, [hl]
	ld	hl, sp+37
	ld	[hl], a
	dec	hl
	ld	[hl], e
	ld	hl, sp+33
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
	inc	de
	inc	hl
	ld	a, [hl]
	ld	[de], a
	inc	de
	inc	hl
	ld	a, [hl]
	ld	[de], a
;src/fatfs/lib/ff.c:3631: fs->database = bsect + sysect;					/* Data start sector */
	ld	hl, sp+5
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $002E
	add	hl, de
	ld	c, l
	ld	b, h
	ld	hl, sp+7
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, e
	ld	hl, sp+24
	add	a, [hl]
	ld	e, a
	ld	a, d
	inc	hl
	adc	a, [hl]
	push	af
	ld	hl, sp+37
	ld	[hl], a
	dec	hl
	ld	[hl], e
	ld	hl, sp+11
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, sp+28
	pop	af
	ld	a, e
	adc	a, [hl]
	ld	e, a
	ld	a, d
	inc	hl
	adc	a, [hl]
	ld	hl, sp+37
	ld	[hl], a
	dec	hl
	ld	[hl], e
	dec	hl
	dec	hl
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
;src/fatfs/lib/ff.c:3632: if (fmt == FS_FAT32) {
	ld	hl, sp+28
	ld	a, [hl]
	sub	a, $03
	inc	hl
	or	a, [hl]
	jp	NZ,.l00386
	ld	a,$01
	jp	.l00387
.l00386:
	xor	a,a
.l00387:
	ld	hl, sp+37
	ld	[hl], a
;src/fatfs/lib/ff.c:3635: fs->dirbase = ld_32(fs->win + BPB_RootClus32);	/* Root directory start cluster */
	ld	hl, sp+5
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $002A
	add	hl, de
	ld	c, l
	ld	b, h
;src/fatfs/lib/ff.c:3632: if (fmt == FS_FAT32) {
	ld	hl, sp+37
	ld	a, [hl]
	or	a, a
	jp	Z, .l00162
;src/fatfs/lib/ff.c:3633: if (ld_16(fs->win + BPB_FSVer32) != 0) return FR_NO_FILESYSTEM;	/* (Must be FAT32 revision 0.0) */
	ld	hl, sp+11
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $002A
	add	hl, de
	ld	e, l
	ld	d, h
	push	bc
	call	_ld_16
	ld	e, c
	ld	d, b
	pop	bc
	ld	a, d
	or	a, e
	jp	Z, .l00156
	ld	a, $0D
	jp	.l00174
.l00156:
;src/fatfs/lib/ff.c:3634: if (fs->n_rootdir != 0) return FR_NO_FILESYSTEM;	/* (BPB_RootEntCnt must be 0) */
	ld	hl, sp+19
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	ld	l, a
;	spillPairReg hl
;	spillPairReg hl
	inc	de
	ld	a, [de]
	or	a, l
	jp	Z, .l00158
	ld	a, $0D
	jp	.l00174
.l00158:
;src/fatfs/lib/ff.c:3635: fs->dirbase = ld_32(fs->win + BPB_RootClus32);	/* Root directory start cluster */
	ld	hl, sp+11
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $002C
	add	hl, de
	ld	e, l
	ld	d, h
	push	bc
	call	_ld_32
	ld	hl, sp+35
	ld	[hl], c
	inc	hl
	ld	[hl], b
	inc	hl
	ld	[hl], e
	inc	hl
	ld	[hl], d
	pop	bc
	ld	hl, sp+33
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
;src/fatfs/lib/ff.c:3636: szbfat = fs->n_fatent * 4;					/* (Needed FAT size) */
	ld	hl, sp+31
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
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
	ld	a, $02
.l00388:
	ld	hl, sp+33
	sla	[hl]
	inc	hl
	rl	[hl]
	inc	hl
	rl	[hl]
	inc	hl
	rl	[hl]
.l00389:
	dec	a
	jr	NZ,.l00388
	jp	.l00163
.l00162:
;src/fatfs/lib/ff.c:3638: if (fs->n_rootdir == 0)	return FR_NO_FILESYSTEM;	/* (BPB_RootEntCnt must not be 0) */
	ld	hl, sp+19
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	ld	l, a
;	spillPairReg hl
;	spillPairReg hl
	inc	de
	ld	a, [de]
	or	a, l
	jp	NZ, .l00160
	ld	a, $0D
	jp	.l00174
.l00160:
;src/fatfs/lib/ff.c:3639: fs->dirbase = fs->fatbase + fasize;			/* Root directory start sector */
	ld	hl, sp+33
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	ld	hl, sp+24
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
	dec	hl
	dec	hl
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, e
	ld	hl, sp+14
	add	a, [hl]
	ld	e, a
	ld	a, d
	inc	hl
	adc	a, [hl]
	push	af
	ld	hl, sp+36
	ld	[hl], a
	dec	hl
	ld	[hl], e
	ld	hl, sp+29
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, sp+18
	pop	af
	ld	a, e
	adc	a, [hl]
	ld	e, a
	ld	a, d
	inc	hl
	adc	a, [hl]
	ld	hl, sp+36
	ld	[hl], a
	dec	hl
	ld	[hl], e
	dec	hl
	dec	hl
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
;src/fatfs/lib/ff.c:3636: szbfat = fs->n_fatent * 4;					/* (Needed FAT size) */
	ld	hl, sp+31
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
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
;src/fatfs/lib/ff.c:3640: szbfat = (fmt == FS_FAT16) ?				/* (Needed FAT size) */
	ld	hl, sp+28
	ld	a, [hl]
	sub	a, $02
	inc	hl
	or	a, [hl]
	jp	NZ,.l00390
	jp	.l00391
.l00390:
	jp	.l00176
.l00391:
;src/fatfs/lib/ff.c:3641: fs->n_fatent * 2 : fs->n_fatent * 3 / 2 + (fs->n_fatent & 1);
	ld	hl, sp+33
	sla	[hl]
	inc	hl
	rl	[hl]
	inc	hl
	rl	[hl]
	inc	hl
	rl	[hl]
	jp	.l00177
.l00176:
	ld	hl, sp+35
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	push	de
	ld	hl, sp+35
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	push	de
	ld	bc, $0003
	ld	de, $0000
	call	__mullong
	srl	d
	rr	e
	rr	b
	rr	c
	ld	hl, sp+20
	ld	[hl], c
	inc	hl
	ld	[hl], b
	inc	hl
	ld	[hl], e
	inc	hl
	ld	[hl], d
	ld	hl, sp+33
	ld	a, [hl]
	and	a, $01
	ld	hl, sp+24
	ld	[hl], a
	xor	a, a
	inc	hl
	ld	[hl], a
	inc	hl
	ld	[hl], a
	inc	hl
	ld	[hl], a
	ld	hl, sp+21
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, e
	ld	hl, sp+24
	add	a, [hl]
	ld	e, a
	ld	a, d
	inc	hl
	adc	a, [hl]
	push	af
	ld	hl, sp+36
	ld	[hl], a
	dec	hl
	ld	[hl], e
	ld	hl, sp+25
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, sp+28
	pop	af
	ld	a, e
	adc	a, [hl]
	ld	e, a
	ld	a, d
	inc	hl
	adc	a, [hl]
	ld	hl, sp+36
	ld	[hl], a
	dec	hl
	ld	[hl], e
.l00177:
.l00163:
;src/fatfs/lib/ff.c:3643: if (fs->fsize < (szbfat + (SS(fs) - 1)) / SS(fs)) return FR_NO_FILESYSTEM;	/* (BPB_FATSz must not be less than the size needed) */
	ld	hl, sp+13
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	ld	hl, sp+24
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
	ld	hl, sp+34
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, e
	add	a, $FF
	ld	e, a
	ld	a, d
	adc	a, $01
	push	af
	ld	hl, sp+23
	ld	[hl], a
	dec	hl
	ld	[hl], e
	ld	hl, sp+38
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	pop	af
	ld	a, e
	adc	a, $00
	ld	e, a
	ld	a, d
	adc	a, $00
	ld	hl, sp+23
	ld	[hl], a
	dec	hl
	ld	[hl], e
	dec	hl
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	inc	hl
	ld	e, [hl]
	ld	d, $00
	srl	e
	rr	b
	rr	c
	inc	hl
	ld	a, [hl]
	sub	a, c
	inc	hl
	ld	a, [hl]
	sbc	a, b
	inc	hl
	ld	a, [hl]
	sbc	a, e
	inc	hl
	ld	a, [hl]
	sbc	a, d
	jp	NC, .l00165
	ld	a, $0D
	jp	.l00174
.l00165:
;src/fatfs/lib/ff.c:3647: fs->last_clst = fs->free_clst = 0xFFFFFFFF;		/* Invalidate cluster allocation information */
	ld	hl, sp+5
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $000E
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+35
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+34
	ld	[hl], a
	ld	hl, sp+5
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $0012
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+37
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+36
	ld	[hl], a
	dec	hl
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	ld	[hl], $FF
	inc	hl
	ld	[hl], $FF
	inc	hl
	ld	[hl], $FF
	inc	hl
	ld	[hl], $FF
	ld	hl, sp+33
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	ld	[hl], $FF
	inc	hl
	ld	[hl], $FF
	inc	hl
	ld	[hl], $FF
	inc	hl
	ld	[hl], $FF
;src/fatfs/lib/ff.c:3648: fs->fsi_flag = 0x80;	/* Disable FSInfo by default */
	ld	hl, sp+5
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $0005
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, $80
	ld	[bc], a
;src/fatfs/lib/ff.c:3650: && ld_16(fs->win + BPB_FSInfo32) == 1	/* FAT32: Enable FSInfo feature only if FSInfo sector is next to VBR */
	ld	hl, sp+37
	ld	a, [hl]
	or	a, a
	jp	Z, .l00171
	ld	hl, sp+11
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $0030
	add	hl, de
	ld	e, l
	ld	d, h
	push	bc
	call	_ld_16
	ld	e, c
	ld	d, b
	pop	bc
	ld	a, e
	dec	a
	or	a, d
	jp	NZ,.l00398
	jp	.l00399
.l00398:
	jp	.l00171
.l00399:
;src/fatfs/lib/ff.c:3651: && move_window(fs, bsect + 1) == FR_OK)
	ld	hl, sp+7
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, e
	add	a, $01
	ld	e, a
	ld	a, d
	adc	a, $00
	push	af
	ld	hl, sp+27
	ld	[hl], a
	dec	hl
	ld	[hl], e
	ld	hl, sp+11
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	pop	af
	ld	a, e
	adc	a, $00
	ld	e, a
	ld	a, d
	adc	a, $00
	ld	hl, sp+27
	ld	[hl], a
	dec	hl
	ld	[hl], e
	push	bc
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	push	de
	ld	hl, sp+28
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	push	de
	ld	hl, sp+10
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_move_window
	pop	bc
	or	a, a
	jp	NZ, .l00171
;src/fatfs/lib/ff.c:3653: fs->fsi_flag = 0;
	xor	a, a
	ld	[bc], a
;src/fatfs/lib/ff.c:3654: if (   ld_32(fs->win + FSI_LeadSig) == 0x41615252	/* Load FSInfo data if available */
	ld	hl, sp+5
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $0032
	add	hl, de
	ld	e, l
	ld	d, h
	call	_ld_32
	ld	a, c
	sub	a, $52
	jp	NZ,.l00400
	ld	a, b
	sub	a, $52
	jp	NZ,.l00400
	ld	a, e
	sub	a, $61
	jp	NZ,.l00400
	ld	a, d
	sub	a, $41
	jp	NZ,.l00400
	jp	.l00401
.l00400:
	jp	.l00171
.l00401:
;src/fatfs/lib/ff.c:3655: && ld_32(fs->win + FSI_StrucSig) == 0x61417272
	ld	hl, sp+11
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $01E4
	add	hl, de
	ld	e, l
	ld	d, h
	call	_ld_32
	ld	a, c
	sub	a, $72
	jp	NZ,.l00402
	ld	a, b
	sub	a, $72
	jp	NZ,.l00402
	ld	a, e
	sub	a, $41
	jp	NZ,.l00402
	ld	a, d
	sub	a, $61
	jp	NZ,.l00402
	jp	.l00403
.l00402:
	jp	.l00171
.l00403:
;src/fatfs/lib/ff.c:3656: && ld_32(fs->win + FSI_TrailSig) == 0xAA550000)
	ld	hl, sp+11
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $01FC
	add	hl, de
	ld	e, l
	ld	d, h
	call	_ld_32
	ld	a, c
	or	a, a
	or	a, b
	jp	NZ,.l00404
	ld	a, e
	sub	a, $55
	jp	NZ,.l00404
	ld	a, d
	sub	a, $AA
	jp	NZ,.l00404
	jp	.l00405
.l00404:
	jp	.l00171
.l00405:
;src/fatfs/lib/ff.c:3659: fs->free_clst = ld_32(fs->win + FSI_Free_Count);
	ld	hl, sp+11
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $01E8
	add	hl, de
	ld	e, l
	ld	d, h
	call	_ld_32
	ld	hl, sp+24
	ld	[hl], c
	inc	hl
	ld	[hl], b
	inc	hl
	ld	[hl], e
	inc	hl
	ld	[hl], d
	ld	hl, sp+36
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, sp+24
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
;src/fatfs/lib/ff.c:3662: fs->last_clst = ld_32(fs->win + FSI_Nxt_Free);
	ld	hl, sp+11
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $01EC
	add	hl, de
	ld	e, l
	ld	d, h
	call	_ld_32
	ld	hl, sp+24
	ld	[hl], c
	inc	hl
	ld	[hl], b
	inc	hl
	ld	[hl], e
	inc	hl
	ld	[hl], d
	ld	hl, sp+34
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, sp+24
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
.l00171:
;src/fatfs/lib/ff.c:3669: fs->fs_type = (BYTE)fmt;/* FAT sub-type (the filesystem object gets valid) */
	ld	hl, sp+28
	ld	c, [hl]
	ld	hl, sp+4
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	ld	[hl], c
;src/fatfs/lib/ff.c:3670: fs->id = ++Fsid;		/* Volume mount ID */
	ld	hl, sp+5
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $0006
	add	hl, de
	ld	c, l
	ld	b, h
	ld	hl, _Fsid
	inc	[hl]
	jp	NZ, .l00406
	inc	hl
	inc	[hl]
.l00406:
	ld	hl, _Fsid
	ld	a, [hl]
	ld	[bc], a
	inc	bc
	inc	hl
	ld	a, [hl]
	ld	[bc], a
;src/fatfs/lib/ff.c:3673: fs->lfnbuf = LfnBuf;	/* LFN working buffer */
	ld	hl, sp+5
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $000C
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, LOW(_LfnBuf)
	ld	[bc], a
	inc	bc
	ld	a, HIGH(_LfnBuf)
	ld	[bc], a
;src/fatfs/lib/ff.c:3690: return FR_OK;
	xor	a, a
.l00174:
;src/fatfs/lib/ff.c:3691: }
	add	sp, 42
	pop	hl
	inc	sp
	jp hl 
;src/fatfs/lib/ff.c:3700: static FRESULT validate (	/* Returns FR_OK or FR_INVALID_OBJECT */
;	---------------------------------
	SECTION FRAGMENT "src/fatfs/fatfs.c A",ROMX
; Function validate
; ---------------------------------
_validate:
	add	sp, -9
	ld	hl, sp+7
	ld	[hl], e
	inc	hl
	ld	[hl], d
	ld	hl, sp+5
	ld	[hl], c
	inc	hl
	ld	[hl], b
;src/fatfs/lib/ff.c:3705: FRESULT res = FR_INVALID_OBJECT;
	ld	hl, sp+0
	ld	[hl], $09
;src/fatfs/lib/ff.c:3708: if (obj && obj->fs && obj->fs->fs_type && obj->id == obj->fs->id) {	/* Test if the object is valid */
	ld	hl, sp+8
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	jp	Z, .l00104
	inc	hl
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	ld	c, a
	inc	de
	ld	a, [de]
	ld	b, a
	ld	a, b
	or	a, c
	jp	Z, .l00104
	ld	a, [bc]
	or	a, a
	jp	Z, .l00104
	dec	hl
	ld	a, [hl]
	inc	hl
	ld	h, [hl]
;	spillPairReg hl
;	spillPairReg hl
	ld	l, a
;	spillPairReg hl
;	spillPairReg hl
	inc	hl
	inc	hl
	ld	e, l
	ld	d, h
	ld	a, [de]
	ld	hl, sp+1
	ld	[hl], a
	inc	de
	ld	a, [de]
	inc	hl
	ld	[hl], a
	ld	hl, $0006
	add	hl, bc
	ld	e, l
	ld	d, h
	ld	a, [de]
	ld	hl, sp+3
	ld	[hl], a
	inc	de
	ld	a, [de]
	inc	hl
	ld	[hl], a
	ld	hl, sp+1
	ld	a, [hl]
	inc	hl
	inc	hl
	sub	a, [hl]
	jp	NZ,.l00142
	dec	hl
	ld	a, [hl]
	inc	hl
	inc	hl
	sub	a, [hl]
	jp	NZ,.l00142
	jp	.l00143
.l00142:
	jp	.l00104
.l00143:
;src/fatfs/lib/ff.c:3720: if (!(disk_status(obj->fs->pdrv) & STA_NOINIT)) { /* Test if the hosting physical drive is kept initialized */
	inc	bc
	ld	a, [bc]
	ld	c, a
	ld	a, c
	call	_disk_status__far
	rrca
	jp	C,.l00144
	jp	.l00145
.l00144:
	jp	.l00104
.l00145:
;src/fatfs/lib/ff.c:3721: res = FR_OK;
	ld	hl, sp+0
	ld	[hl], $00
.l00104:
;src/fatfs/lib/ff.c:3725: *rfs = (res == FR_OK) ? obj->fs : 0;	/* Return corresponding filesystem object if it is valid */
	ld	hl, sp+5
	ld	a, [hl]
	dec	hl
	dec	hl
	ld	[hl], a
	ld	hl, sp+6
	ld	a, [hl]
	dec	hl
	dec	hl
	ld	[hl], a
	ld	hl, sp+0
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00110
	ld	hl, sp+8
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	ld	c, a
	inc	de
	ld	a, [de]
	ld	b, a
	jp	.l00111
.l00110:
	ld	bc, $0000
.l00111:
	ld	hl, sp+3
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	ld	[hl], c
	inc	hl
	ld	[hl], b
;src/fatfs/lib/ff.c:3726: return res;
	ld	hl, sp+0
	ld	a, [hl]
.l00108:
;src/fatfs/lib/ff.c:3727: }
	add	sp, 9
	ret
;src/fatfs/lib/ff.c:3744: FRESULT f_mount (
;	---------------------------------
	SECTION FRAGMENT "src/fatfs/fatfs.c B",ROMX
; Function f_mount
; ---------------------------------
_f_mount::
	add	sp, -10
	ld	hl, sp+8
	ld	[hl], e
	inc	hl
	ld	[hl], d
	ld	hl, sp+6
	ld	[hl], c
	inc	hl
	ld	[hl], b
;src/fatfs/lib/ff.c:3753: const TCHAR *rp = path;
	dec	hl
	ld	a, [hl]
	ld	hl, sp+0
	ld	[hl], a
	ld	hl, sp+7
	ld	a, [hl]
	ld	hl, sp+1
	ld	[hl], a
;src/fatfs/lib/ff.c:3757: vol = get_ldnumber(&rp);
	ld	hl, sp+0
	ld	e, l
	ld	d, h
	call	_get_ldnumber
	ld	hl, sp+2
	ld	[hl], c
	inc	hl
	ld	[hl], b
;src/fatfs/lib/ff.c:3758: if (vol < 0) return FR_INVALID_DRIVE;
	ld	a, [hl]
	bit	7, a
	jp	Z, .l00102
	ld	a, $0B
	jp	.l00109
.l00102:
;src/fatfs/lib/ff.c:3760: cfs = FatFs[vol];			/* Pointer to the filesystem object of the volume */
	ld	hl, sp+2
	ld	a, [hl]
	inc	hl
	ld	d, [hl]
	add	a, a
	rl	d
	ld	e, a
	ld	hl, _FatFs
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
	ld	l, a
;	spillPairReg hl
;	spillPairReg hl
	inc	de
	ld	a, [de]
	ld	c, l
	ld	b, a
;src/fatfs/lib/ff.c:3761: if (cfs) {					/* Unregister current filesystem object */
	or	a, l
	jp	Z, .l00104
;src/fatfs/lib/ff.c:3762: FatFs[vol] = 0;
	ld	hl, sp+4
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	xor	a, a
	ld	[hl], a
	inc	hl
	ld	[hl], a
;src/fatfs/lib/ff.c:3769: cfs->fs_type = 0;		/* Invalidate the filesystem object to be unregistered */
	xor	a, a
	ld	[bc], a
.l00104:
;src/fatfs/lib/ff.c:3772: if (fs) {					/* Register new filesystem object */
	ld	hl, sp+9
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	jp	Z, .l00106
;src/fatfs/lib/ff.c:3773: fs->pdrv = LD2PD(vol);	/* Volume hosting physical drive */
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	inc	bc
	ld	hl, sp+2
	ld	a, [hl]
	ld	[bc], a
;src/fatfs/lib/ff.c:3787: fs->fs_type = 0;		/* Invalidate the new filesystem object */
	ld	hl, sp+8
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	xor	a, a
	ld	[bc], a
;src/fatfs/lib/ff.c:3788: FatFs[vol] = fs;		/* Register it */
	ld	hl, sp+5
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, sp+8
	ld	a, [hl]
	ld	[de], a
	inc	de
	inc	hl
	ld	a, [hl]
	ld	[de], a
.l00106:
;src/fatfs/lib/ff.c:3791: if (opt == 0) return FR_OK;	/* Do not mount now, it will be mounted in subsequent file functions */
	ld	hl, sp+12
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00108
	xor	a, a
	jp	.l00109
.l00108:
;src/fatfs/lib/ff.c:3793: res = mount_volume(&path, &fs, 0);	/* Force mounted the volume in this function */
	xor	a, a
	push	af
	inc	sp
	ld	hl, 9
	add	hl, sp
	ld	c, l
	ld	b, h
	ld	hl, 7
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_mount_volume
	ld	hl, sp+5
	ld	[hl], a
	ld	hl, sp+5
	ld	a, [hl]
;src/fatfs/lib/ff.c:3794: LEAVE_FF(fs, res);
.l00109:
;src/fatfs/lib/ff.c:3795: }
	add	sp, 10
	pop	hl
	inc	sp
	jp hl 
;src/fatfs/lib/ff.c:3804: FRESULT f_open (
;	---------------------------------
	SECTION FRAGMENT "src/fatfs/fatfs.c A",ROMX
; Function f_open
; ---------------------------------
_f_open::
	add	sp, -65
	ld	hl, sp+59
	ld	[hl], e
	inc	hl
	ld	[hl], d
	ld	hl, sp+57
	ld	[hl], c
	inc	hl
	ld	[hl], b
;src/fatfs/lib/ff.c:3816: if (!fp) return FR_INVALID_OBJECT;	/* Reject null pointer */
	inc	hl
	inc	hl
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	jp	NZ, .l00102
	ld	a, $09
	jp	.l00163
.l00102:
;src/fatfs/lib/ff.c:3819: mode &= FF_FS_READONLY ? FA_READ : FA_READ | FA_WRITE | FA_CREATE_ALWAYS | FA_CREATE_NEW | FA_OPEN_ALWAYS | FA_OPEN_APPEND;
	ld	hl, sp+67
	ld	a, [hl]
	and	a, $3F
	ld	[hl], a
;src/fatfs/lib/ff.c:3820: res = mount_volume(&path, &fs, mode);
	ld	a, [hl]
	push	af
	inc	sp
	ld	hl, 45
	add	hl, sp
	ld	c, l
	ld	b, h
	ld	hl, 58
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_mount_volume__far
	ld	hl, sp+46
	ld	[hl], a
;src/fatfs/lib/ff.c:3822: if (res == FR_OK) {
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00156
;src/fatfs/lib/ff.c:3823: fp->obj.fs = fs;
	ld	hl, sp+60
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, sp+44
	ld	a, [hl]
	ld	[de], a
	inc	de
	inc	hl
	ld	a, [hl]
	ld	[de], a
;src/fatfs/lib/ff.c:3824: dj.obj.fs = fs;
	dec	hl
	ld	a, [hl]
	ld	hl, sp+0
	ld	[hl], a
	ld	hl, sp+45
	ld	a, [hl]
	ld	hl, sp+1
	ld	[hl], a
;src/fatfs/lib/ff.c:3826: res = follow_path(&dj, path);	/* Follow the file path */
	ld	hl, sp+57
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	ld	hl, 0
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_follow_path
	ld	hl, sp+46
	ld	[hl], a
;src/fatfs/lib/ff.c:3828: if (res == FR_OK) {
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00106
;src/fatfs/lib/ff.c:3829: if (dj.fn[NSFLAG] & NS_NONAME) {	/* Origin directory itself? */
	ld	hl, sp+39
	ld	a, [hl]
	rlca
	jp	C,.l00320
	jp	.l00106
.l00320:
;src/fatfs/lib/ff.c:3830: res = FR_INVALID_NAME;
	ld	hl, sp+46
	ld	[hl], $06
.l00106:
;src/fatfs/lib/ff.c:3819: mode &= FF_FS_READONLY ? FA_READ : FA_READ | FA_WRITE | FA_CREATE_ALWAYS | FA_CREATE_NEW | FA_OPEN_ALWAYS | FA_OPEN_APPEND;
	ld	hl, sp+67
	ld	a, [hl]
	ld	hl, sp+52
	ld	[hl], a
;src/fatfs/lib/ff.c:3854: if (dj.obj.attr & (AM_RDO | AM_DIR)) res = FR_DENIED;	/* Cannot overwrite it (R/O or DIR) */
;src/fatfs/lib/ff.c:3880: st_32(dj.dir + DIR_CrtTime, tm);	/* Set created time */
;src/fatfs/lib/ff.c:3839: if (mode & (FA_CREATE_ALWAYS | FA_OPEN_ALWAYS | FA_CREATE_NEW)) {
	ld	hl, sp+67
	ld	a, [hl]
	and	a, $1C
	jp	NZ,.l00321
	jp	.l00133
.l00321:
;src/fatfs/lib/ff.c:3840: if (res != FR_OK) {					/* No file, create new */
	ld	hl, sp+46
	ld	a, [hl]
	or	a, a
	jp	Z, .l00115
;src/fatfs/lib/ff.c:3841: if (res == FR_NO_FILE) {		/* There is no file to open, create a new entry */
	ld	a, [hl]
	sub	a, $04
	jp	NZ,.l00322
	jp	.l00323
.l00322:
	jp	.l00108
.l00323:
;src/fatfs/lib/ff.c:3845: res = dir_register(&dj);
	ld	hl, 0
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_dir_register__far
	ld	hl, sp+46
	ld	[hl], a
.l00108:
;src/fatfs/lib/ff.c:3848: mode |= FA_CREATE_ALWAYS;		/* File is created */
	ld	hl, sp+67
	ld	a, [hl]
	or	a, $08
	ld	[hl], a
	jp	.l00116
.l00115:
;src/fatfs/lib/ff.c:3851: if (mode & FA_CREATE_NEW) {
	push	hl
	ld	hl, sp+54
	bit	2, [hl]
	pop	hl
	jp	NZ,.l00324
	jp	.l00112
.l00324:
;src/fatfs/lib/ff.c:3852: res = FR_EXIST;				/* Cannot create as new file */
	ld	hl, sp+46
	ld	[hl], $08
	jp	.l00116
.l00112:
;src/fatfs/lib/ff.c:3854: if (dj.obj.attr & (AM_RDO | AM_DIR)) res = FR_DENIED;	/* Cannot overwrite it (R/O or DIR) */
	ld	hl, sp+4
	ld	a, [hl]
	and	a, $11
	jp	NZ,.l00325
	jp	.l00116
.l00325:
	ld	hl, sp+46
	ld	[hl], $07
.l00116:
;src/fatfs/lib/ff.c:3819: mode &= FF_FS_READONLY ? FA_READ : FA_READ | FA_WRITE | FA_CREATE_ALWAYS | FA_CREATE_NEW | FA_OPEN_ALWAYS | FA_OPEN_APPEND;
	ld	hl, sp+67
	ld	a, [hl]
	ld	hl, sp+52
	ld	[hl], a
;src/fatfs/lib/ff.c:3857: if (res == FR_OK && (mode & FA_CREATE_ALWAYS)) {	/* Truncate the file if overwrite mode */
	ld	hl, sp+46
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00134
	push	hl
	ld	hl, sp+54
	bit	3, [hl]
	pop	hl
	jp	NZ,.l00326
	jp	.l00134
.l00326:
;src/fatfs/lib/ff.c:3880: st_32(dj.dir + DIR_CrtTime, tm);	/* Set created time */
	ld	hl, sp+26
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	ld	hl, $000E
	add	hl, bc
	ld	e, l
	ld	d, h
	ld	bc, $5C21
	push	bc
	ld	bc, $0000
	push	bc
	call	_st_32
;src/fatfs/lib/ff.c:3881: st_32(dj.dir + DIR_ModTime, tm);	/* Set modified time (tmp setting) */
	ld	hl, sp+26
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	ld	hl, $0016
	add	hl, bc
	ld	e, l
	ld	d, h
	ld	bc, $5C21
	push	bc
	ld	bc, $0000
	push	bc
	call	_st_32
;src/fatfs/lib/ff.c:3882: cl = ld_clust(fs, dj.dir);			/* Get current cluster chain */
	ld	hl, sp+26
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	ld	hl, sp+44
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_ld_clust__far
	ld	hl, sp+53
	ld	[hl], c
	inc	hl
	ld	[hl], b
	inc	hl
	ld	[hl], e
	inc	hl
	ld	[hl], d
;src/fatfs/lib/ff.c:3883: dj.dir[DIR_Attr] = AM_ARC;			/* Reset attribute */
	ld	hl, sp+26
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	ld	hl, $000B
	add	hl, bc
	ld	[hl], $20
;src/fatfs/lib/ff.c:3884: st_clust(fs, dj.dir, 0);			/* Reset file allocation info */
	ld	hl, sp+26
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	ld	de, $0000
	push	de
	push	de
	ld	hl, sp+48
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_st_clust__far
;src/fatfs/lib/ff.c:3885: st_32(dj.dir + DIR_FileSize, 0);
	ld	hl, sp+26
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	ld	hl, $001C
	add	hl, bc
	ld	e, l
	ld	d, h
	ld	bc, $0000
	push	bc
	push	bc
	call	_st_32
;src/fatfs/lib/ff.c:3886: fs->wflag = 1;
	ld	hl, sp+44
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	ld	hl, $0004
	add	hl, bc
	ld	[hl], $01
;src/fatfs/lib/ff.c:3887: if (cl != 0) {						/* Remove the cluster chain if exist */
	ld	hl, sp+56
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	dec	hl
	or	a, [hl]
	dec	hl
	or	a, [hl]
	jp	Z, .l00134
;src/fatfs/lib/ff.c:3888: LBA_t sc = fs->winsect;
	ld	hl, sp+44
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	ld	hl, $001E
	add	hl, bc
	ld	e, l
	ld	d, h
	ld	a, [de]
	ld	hl, sp+61
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
;src/fatfs/lib/ff.c:3890: res = remove_chain(&dj.obj, cl, 0);
	ld	de, $0000
	push	de
	push	de
	ld	hl, sp+59
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	push	de
	ld	hl, sp+59
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	push	de
	ld	hl, 8
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_remove_chain__far
	ld	hl, sp+46
	ld	[hl], a
;src/fatfs/lib/ff.c:3891: if (res == FR_OK) {
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00134
;src/fatfs/lib/ff.c:3892: res = move_window(fs, sc);
	ld	hl, sp+63
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	push	de
	ld	hl, sp+63
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	push	de
	ld	hl, sp+48
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_move_window__far
	ld	hl, sp+46
	ld	[hl], a
;src/fatfs/lib/ff.c:3893: fs->last_clst = cl - 1;		/* Reuse the cluster hole */
	dec	hl
	dec	hl
	ld	a, [hl]
	inc	hl
	ld	b, [hl]
	add	a, $0E
	ld	c, a
	jp	NC, .l00327
	inc	b
.l00327:
	ld	hl, sp+54
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, e
	sub	a, $01
	ld	e, a
	ld	a, d
	sbc	a, $00
	push	af
	ld	hl, sp+64
	ld	[hl], a
	dec	hl
	ld	[hl], e
	ld	hl, sp+58
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	pop	af
	ld	a, e
	sbc	a, $00
	ld	e, a
	ld	a, d
	sbc	a, $00
	ld	hl, sp+64
	ld	[hl], a
	dec	hl
	ld	[hl], e
	dec	hl
	dec	hl
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
	jp	.l00134
.l00133:
;src/fatfs/lib/ff.c:3900: if (res == FR_OK) {					/* Is the object exsiting? */
	ld	hl, sp+46
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00134
;src/fatfs/lib/ff.c:3901: if (dj.obj.attr & AM_DIR) {		/* File open against a directory */
	ld	hl, sp+4
	ld	a, [hl]
	bit	4, a
	jp	NZ,.l00328
	jp	.l00128
.l00328:
;src/fatfs/lib/ff.c:3902: res = FR_NO_FILE;
	ld	hl, sp+46
	ld	[hl], $04
	jp	.l00134
.l00128:
;src/fatfs/lib/ff.c:3904: if ((mode & FA_WRITE) && (dj.obj.attr & AM_RDO)) { /* Write mode open against R/O file */
	push	hl
	ld	hl, sp+54
	bit	1, [hl]
	pop	hl
	jp	NZ,.l00329
	jp	.l00134
.l00329:
	rrca
	jp	C,.l00330
	jp	.l00134
.l00330:
;src/fatfs/lib/ff.c:3905: res = FR_DENIED;
	ld	hl, sp+46
	ld	[hl], $07
.l00134:
;src/fatfs/lib/ff.c:3910: if (res == FR_OK) {
	ld	hl, sp+46
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00138
;src/fatfs/lib/ff.c:3911: if (mode & FA_CREATE_ALWAYS) mode |= FA_MODIFIED;	/* Set file change flag if created or overwritten */
	push	hl
	ld	hl, sp+54
	bit	3, [hl]
	pop	hl
	jp	NZ,.l00331
	jp	.l00136
.l00331:
	ld	hl, sp+52
	ld	a, [hl]
	or	a, $40
	ld	hl, sp+67
	ld	[hl], a
.l00136:
;src/fatfs/lib/ff.c:3912: fp->dir_sect = fs->winsect;			/* Pointer to the directory entry */
	ld	hl, sp+60
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $001C
	add	hl, de
	ld	c, l
	ld	b, h
	ld	hl, sp+44
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $001E
	add	hl, de
	ld	e, l
	ld	d, h
	ld	a, [de]
	ld	hl, sp+61
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
	ld	hl, sp+61
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
;src/fatfs/lib/ff.c:3913: fp->dir_ptr = dj.dir;
	ld	hl, sp+60
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $0020
	add	hl, de
	ld	c, l
	ld	b, h
	ld	hl, sp+26
	ld	a, [hl]
	ld	hl, sp+63
	ld	[hl], a
	ld	hl, sp+27
	ld	a, [hl]
	ld	hl, sp+64
	ld	[hl], a
	dec	hl
	ld	a, [hl]
	ld	[bc], a
	inc	bc
	inc	hl
	ld	a, [hl]
	ld	[bc], a
.l00138:
;src/fatfs/lib/ff.c:3932: if (res == FR_OK) {
	ld	hl, sp+46
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00156
;src/fatfs/lib/ff.c:3939: fp->obj.sclust = ld_clust(fs, dj.dir);					/* Get object allocation info */
	ld	hl, sp+60
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $0006
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+63
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+62
	ld	[hl], a
	ld	hl, sp+26
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	ld	hl, sp+44
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_ld_clust__far
	ld	hl, sp+53
	ld	[hl], c
	inc	hl
	ld	[hl], b
	inc	hl
	ld	[hl], e
	inc	hl
	ld	[hl], d
	ld	hl, sp+62
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, sp+53
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
;src/fatfs/lib/ff.c:3940: fp->obj.objsize = ld_32(dj.dir + DIR_FileSize);
	ld	hl, sp+60
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $000A
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+65
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+64
	ld	[hl], a
	ld	hl, sp+26
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	ld	hl, $001C
	add	hl, bc
	ld	e, l
	ld	d, h
	call	_ld_32
	ld	hl, sp+53
	ld	[hl], c
	inc	hl
	ld	[hl], b
	inc	hl
	ld	[hl], e
	inc	hl
	ld	[hl], d
	ld	hl, sp+64
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, sp+53
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
;src/fatfs/lib/ff.c:3945: fp->obj.id = fs->id;	/* Set current volume mount ID */
	ld	hl, sp+59
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	inc	bc
	inc	bc
	ld	hl, sp+44
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $0006
	add	hl, de
	ld	e, l
	ld	d, h
	ld	a, [de]
	ld	hl, sp+55
	ld	[hl], a
	inc	de
	ld	a, [de]
	inc	hl
	ld	[hl], a
	ld	hl, sp+55
	ld	a, [hl]
	ld	[bc], a
	inc	bc
	inc	hl
	ld	a, [hl]
	ld	[bc], a
;src/fatfs/lib/ff.c:3946: fp->flag = mode;	/* Set file access mode */
	ld	hl, sp+60
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $000E
	add	hl, de
	ld	c, l
	ld	b, h
	ld	hl, sp+67
	ld	a, [hl]
	ld	[bc], a
;src/fatfs/lib/ff.c:3947: fp->err = 0;		/* Clear error flag */
	ld	hl, sp+60
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $000F
	add	hl, de
	ld	c, l
	ld	b, h
	xor	a, a
	ld	[bc], a
;src/fatfs/lib/ff.c:3948: fp->sect = 0;		/* Invalidate current data sector */
	ld	hl, sp+60
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $0018
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+49
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+48
	ld	[hl], a
	dec	hl
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	xor	a, a
	ld	[hl], a
	inc	hl
	ld	[hl], a
	inc	hl
	ld	[hl], a
	inc	hl
	ld	[hl], a
;src/fatfs/lib/ff.c:3949: fp->fptr = 0;		/* Set file pointer top of the file */
	ld	hl, sp+60
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $0010
	add	hl, de
	ld	c, l
	ld	b, h
	ld	l, c
	ld	h, b
	xor	a, a
	ld	[hl], a
	inc	hl
	ld	[hl], a
	inc	hl
	ld	[hl], a
	inc	hl
	ld	[hl], a
;src/fatfs/lib/ff.c:3954: if ((mode & FA_SEEKEND) && fp->obj.objsize > 0) {	/* Seek to end of file if FA_OPEN_APPEND is specified */
	ld	hl, sp+67
	ld	a, [hl]
	bit	5, a
	jp	NZ,.l00332
	jp	.l00156
.l00332:
	ld	hl, sp+64
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	ld	hl, sp+53
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
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	dec	hl
	or	a, [hl]
	dec	hl
	or	a, [hl]
	jp	Z, .l00156
;src/fatfs/lib/ff.c:3958: fp->fptr = fp->obj.objsize;			/* Offset to seek */
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
;src/fatfs/lib/ff.c:3959: bcs = (DWORD)fs->csize * SS(fs);	/* Cluster size in byte */
	ld	hl, sp+44
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	ld	hl, $000A
	add	hl, bc
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	ld	de, $0000
	ld	d, e
	ld	e, b
	ld	b, c
	ld	c, $00
	sla	b
	rl	e
	rl	d
	ld	hl, sp+49
	ld	[hl], c
	inc	hl
	ld	[hl], b
	inc	hl
	ld	[hl], e
	inc	hl
	ld	[hl], d
;src/fatfs/lib/ff.c:3960: clst = fp->obj.sclust;				/* Follow the cluster chain */
	ld	hl, sp+62
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	ld	hl, sp+53
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
;src/fatfs/lib/ff.c:3961: for (ofs = fp->obj.objsize; res == FR_OK && ofs > bcs; ofs -= bcs) {
	ld	hl, sp+64
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	ld	hl, sp+61
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
.l00161:
	ld	hl, sp+46
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00143
	ld	hl, sp+49
	ld	e, l
	ld	d, h
	ld	hl, sp+61
	ld	a, [de]
	inc	de
	sub	a, [hl]
	inc	hl
	ld	a, [de]
	inc	de
	sbc	a, [hl]
	inc	hl
	ld	a, [de]
	inc	de
	sbc	a, [hl]
	inc	hl
	ld	a, [de]
	sbc	a, [hl]
	jp	NC, .l00143
;src/fatfs/lib/ff.c:3962: clst = get_fat(&fp->obj, clst);
	ld	hl, sp+55
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	push	de
	ld	hl, sp+55
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	push	de
	ld	hl, sp+63
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_get_fat
	ld	hl, sp+53
	ld	[hl], c
	inc	hl
	ld	[hl], b
	inc	hl
	ld	[hl], e
	inc	hl
	ld	[hl], d
;src/fatfs/lib/ff.c:3963: if (clst <= 1) res = FR_INT_ERR;
	ld	hl, sp+53
	ld	a, $01
	sub	a, [hl]
	inc	hl
	ld	a, $00
	sbc	a, [hl]
	inc	hl
	ld	a, $00
	sbc	a, [hl]
	inc	hl
	ld	a, $00
	sbc	a, [hl]
	jp	C, .l00140
	ld	hl, sp+46
	ld	[hl], $02
.l00140:
;src/fatfs/lib/ff.c:3964: if (clst == 0xFFFFFFFF) res = FR_DISK_ERR;
	ld	hl, sp+53
	ld	a, [hl]
	inc	hl
	and	a, [hl]
	inc	hl
	and	a, [hl]
	inc	hl
	and	a, [hl]
	inc	a
	jp	NZ,.l00335
	jp	.l00336
.l00335:
	jp	.l00162
.l00336:
	ld	hl, sp+46
	ld	[hl], $01
.l00162:
;src/fatfs/lib/ff.c:3961: for (ofs = fp->obj.objsize; res == FR_OK && ofs > bcs; ofs -= bcs) {
	ld	hl, sp+62
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, e
	ld	hl, sp+49
	sub	a, [hl]
	ld	e, a
	ld	a, d
	inc	hl
	sbc	a, [hl]
	push	af
	ld	hl, sp+64
	ld	[hl], a
	dec	hl
	ld	[hl], e
	ld	hl, sp+66
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, sp+53
	pop	af
	ld	a, e
	sbc	a, [hl]
	ld	e, a
	ld	a, d
	inc	hl
	sbc	a, [hl]
	ld	hl, sp+64
	ld	[hl], a
	dec	hl
	ld	[hl], e
	jp	.l00161
.l00143:
;src/fatfs/lib/ff.c:3966: fp->clust = clst;
	ld	hl, sp+60
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $0014
	add	hl, de
	ld	c, l
	ld	b, h
	ld	hl, sp+53
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
;src/fatfs/lib/ff.c:3967: if (res == FR_OK && ofs % SS(fs)) {	/* Fill sector buffer if not on the sector boundary */
	ld	hl, sp+46
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00156
	ld	hl, sp+61
	ld	a, [hl]
	or	a, a
	jp	NZ,.l00337
	push	hl
	inc	hl
	bit	0, [hl]
	pop	hl
	jp	NZ,.l00337
	jp	.l00156
.l00337:
;src/fatfs/lib/ff.c:3968: LBA_t sec = clst2sect(fs, clst);
	ld	hl, sp+55
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	push	de
	ld	hl, sp+55
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	push	de
	ld	hl, sp+48
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_clst2sect
	ld	hl, sp+53
	ld	[hl], c
	inc	hl
	ld	[hl], b
	inc	hl
	ld	[hl], e
	inc	hl
	ld	[hl], d
;src/fatfs/lib/ff.c:3970: if (sec == 0) {
	ld	a, d
	or	a, e
	or	a, b
	or	a, c
	jp	NZ, .l00145
;src/fatfs/lib/ff.c:3971: res = FR_INT_ERR;
	ld	hl, sp+46
	ld	[hl], $02
	jp	.l00156
.l00145:
;src/fatfs/lib/ff.c:3973: fp->sect = sec + (DWORD)(ofs / SS(fs));
	ld	a, $09
.l00338:
	ld	hl, sp+64
	srl	[hl]
	dec	hl
	rr	[hl]
	dec	hl
	rr	[hl]
	dec	hl
	rr	[hl]
.l00339:
	dec	a
	jr	NZ, .l00338
	ld	hl, sp+54
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, e
	ld	hl, sp+61
	add	a, [hl]
	ld	e, a
	ld	a, d
	inc	hl
	adc	a, [hl]
	push	af
	ld	hl, sp+52
	ld	[hl], a
	dec	hl
	ld	[hl], e
	ld	hl, sp+58
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, sp+65
	pop	af
	ld	a, e
	adc	a, [hl]
	ld	e, a
	ld	a, d
	inc	hl
	adc	a, [hl]
	ld	hl, sp+52
	ld	[hl], a
	dec	hl
	ld	[hl], e
	ld	hl, sp+48
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
	inc	de
	inc	hl
	ld	a, [hl]
	ld	[de], a
	inc	de
	inc	hl
	ld	a, [hl]
	ld	[de], a
.l00156:
;src/fatfs/lib/ff.c:3989: if (res != FR_OK) fp->obj.fs = 0;	/* Invalidate file object on error */
	ld	hl, sp+46
	ld	a, [hl]
	or	a, a
	jp	Z, .l00158
	ld	hl, sp+59
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	xor	a, a
	ld	[hl], a
	inc	hl
	ld	[hl], a
.l00158:
;src/fatfs/lib/ff.c:3991: LEAVE_FF(fs, res);
	ld	hl, sp+46
	ld	a, [hl]
.l00163:
;src/fatfs/lib/ff.c:3992: }
	add	sp, 65
	pop	hl
	inc	sp
	jp hl 
;src/fatfs/lib/ff.c:4001: FRESULT f_read (
;	---------------------------------
	SECTION FRAGMENT "src/fatfs/fatfs.c A",ROMX
; Function f_read
; ---------------------------------
_f_read::
	add	sp, -42
	ld	hl, sp+38
	ld	[hl], e
	inc	hl
	ld	[hl], d
;src/fatfs/lib/ff.c:4013: BYTE *rbuff = (BYTE*)buff;
	inc	hl
	ld	[hl], c
	inc	hl
	ld	[hl], b
;src/fatfs/lib/ff.c:4016: *br = 0;	/* Clear read byte counter */
	ld	hl, sp+46
	ld	a, [hl]
	ld	hl, sp+2
	ld	[hl], a
	ld	hl, sp+47
	ld	a, [hl]
	ld	hl, sp+3
	ld	[hl], a
	pop	bc
	pop	hl
	push	hl
	push	bc
	xor	a, a
	ld	[hl], a
	inc	hl
	ld	[hl], a
;src/fatfs/lib/ff.c:4017: res = validate(&fp->obj, &fs);				/* Check validity of the file object */
	ld	hl, sp+0
	ld	c, l
	ld	b, h
	ld	hl, sp+38
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_validate
	ld	hl, sp+36
	ld	[hl], a
	ld	hl, sp+36
	ld	a, [hl]
	inc	hl
	ld	[hl], a
;src/fatfs/lib/ff.c:4018: if (res != FR_OK || (res = (FRESULT)fp->err) != FR_OK) LEAVE_FF(fs, res);	/* Check validity */
	dec	hl
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00101
	ld	hl, sp+39
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $000F
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
	ld	hl, sp+37
	ld	[hl], a
	or	a, a
	jp	Z, .l00102
.l00101:
	ld	hl, sp+37
	ld	a, [hl]
	jp	.l00138
.l00102:
;src/fatfs/lib/ff.c:4019: if (!(fp->flag & FA_READ)) LEAVE_FF(fs, FR_DENIED); /* Check access mode */
	ld	hl, sp+39
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $000E
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, [bc]
	rrca
	jp	C,.l00232
	jp	.l00233
.l00232:
	jp	.l00105
.l00233:
	ld	a, $07
	jp	.l00138
.l00105:
;src/fatfs/lib/ff.c:4020: remain = fp->obj.objsize - fp->fptr;
	ld	hl, sp+39
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $000A
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+38
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+37
	ld	[hl], a
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	ld	hl, sp+26
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
	ld	hl, sp+39
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $0010
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+8
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+7
	ld	[hl], a
	dec	hl
	ld	a, [hl]
	inc	hl
	inc	hl
	ld	[hl], a
	dec	hl
	ld	a, [hl]
	inc	hl
	inc	hl
	ld	[hl], a
	dec	hl
	dec	hl
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	ld	hl, sp+30
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
	ld	hl, sp+27
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, e
	ld	hl, sp+30
	sub	a, [hl]
	ld	e, a
	ld	a, d
	inc	hl
	sbc	a, [hl]
	push	af
	ld	hl, sp+37
	ld	[hl], a
	dec	hl
	ld	[hl], e
	ld	hl, sp+31
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, sp+34
	pop	af
	ld	a, e
	sbc	a, [hl]
	ld	e, a
	ld	a, d
	inc	hl
	sbc	a, [hl]
	ld	hl, sp+37
	ld	[hl], a
	dec	hl
	ld	[hl], e
;src/fatfs/lib/ff.c:4021: if (btr > remain) btr = (UINT)remain;		/* Truncate btr by remaining bytes */
	ld	hl, sp+44
	ld	a, [hl]
	ld	hl, sp+30
	ld	[hl], a
	ld	hl, sp+45
	ld	a, [hl]
	ld	hl, sp+31
	ld	[hl], a
	xor	a, a
	inc	hl
	ld	[hl], a
	inc	hl
	ld	[hl], a
	ld	hl, sp+34
	ld	e, l
	ld	d, h
	ld	hl, sp+30
	ld	a, [de]
	inc	de
	sub	a, [hl]
	inc	hl
	ld	a, [de]
	inc	de
	sbc	a, [hl]
	inc	hl
	ld	a, [de]
	inc	de
	sbc	a, [hl]
	inc	hl
	ld	a, [de]
	sbc	a, [hl]
	jp	NC, .l00159
	ld	hl, sp+34
	ld	a, [hl]
	ld	hl, sp+44
	ld	[hl], a
	ld	hl, sp+35
	ld	a, [hl]
	ld	hl, sp+45
	ld	[hl], a
.l00159:
	ld	hl, sp+39
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $0006
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+12
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+11
	ld	[hl], a
;src/fatfs/lib/ff.c:4038: clst = get_fat(&fp->obj, fp->clust);	/* Follow cluster chain on the FAT */
	ld	hl, sp+39
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $0014
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+14
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+13
	ld	[hl], a
;src/fatfs/lib/ff.c:4021: if (btr > remain) btr = (UINT)remain;		/* Truncate btr by remaining bytes */
	dec	hl
	ld	a, [hl]
	inc	hl
	inc	hl
	ld	[hl], a
	dec	hl
	ld	a, [hl]
	inc	hl
	inc	hl
	ld	[hl], a
	ld	hl, sp+39
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $0018
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+18
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+17
	ld	[hl], a
	dec	hl
	ld	a, [hl]
	inc	hl
	inc	hl
	ld	[hl], a
	dec	hl
	ld	a, [hl]
	inc	hl
	inc	hl
	ld	[hl], a
.l00137:
;src/fatfs/lib/ff.c:4023: for ( ; btr > 0; btr -= rcnt, *br += rcnt, rbuff += rcnt, fp->fptr += rcnt) {	/* Repeat until btr bytes read */
	ld	hl, sp+45
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	jp	Z, .l00135
;src/fatfs/lib/ff.c:4024: if (fp->fptr % SS(fs) == 0) {			/* On the sector boundary? */
	ld	hl, sp+9
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	ld	hl, sp+30
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
	ld	hl, sp+30
	ld	a, [hl]
	or	a, a
	jp	NZ,.l00234
	push	hl
	inc	hl
	bit	0, [hl]
	pop	hl
	jp	NZ,.l00234
	jp	.l00235
.l00234:
	jp	.l00129
.l00235:
;src/fatfs/lib/ff.c:4025: csect = (UINT)(fp->fptr / SS(fs) & (fs->csize - 1));	/* Sector offset in the cluster */
	ld	hl, sp+31
	ld	a, [hl]
	ld	hl, sp+34
	ld	[hl], a
	dec	hl
	dec	hl
	ld	a, [hl]
	ld	hl, sp+35
	ld	[hl], a
	dec	hl
	dec	hl
	ld	a, [hl]
	ld	hl, sp+36
	ld	[hl], a
	inc	hl
	ld	[hl], $00
	dec	hl
	srl	[hl]
	dec	hl
	rr	[hl]
	dec	hl
	rr	[hl]
	pop	bc
	push	bc
	ld	hl, $000A
	add	hl, bc
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	dec	bc
	ld	hl, sp+34
	ld	a, [hl]
	inc	hl
	ld	e, [hl]
	and	a, c
	ld	c, a
	ld	a, e
	and	a, b
	dec	hl
	ld	[hl], c
	inc	hl
	ld	[hl], a
;src/fatfs/lib/ff.c:4026: if (csect == 0) {					/* On the cluster boundary? */
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	jp	NZ, .l00116
;src/fatfs/lib/ff.c:4029: if (fp->fptr == 0) {			/* On the top of the file? */
	dec	hl
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	dec	hl
	or	a, [hl]
	dec	hl
	or	a, [hl]
	jp	NZ, .l00109
;src/fatfs/lib/ff.c:4030: clst = fp->obj.sclust;		/* Follow cluster chain from the origin */
	ld	hl, sp+11
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	ld	hl, sp+30
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
	jp	.l00110
.l00109:
;src/fatfs/lib/ff.c:4038: clst = get_fat(&fp->obj, fp->clust);	/* Follow cluster chain on the FAT */
	ld	hl, sp+13
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	ld	hl, sp+30
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
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	push	de
	ld	hl, sp+32
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	push	de
	ld	hl, sp+42
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_get_fat
	ld	hl, sp+30
	ld	[hl], c
	inc	hl
	ld	[hl], b
	inc	hl
	ld	[hl], e
	inc	hl
	ld	[hl], d
.l00110:
;src/fatfs/lib/ff.c:4041: if (clst < 2) ABORT(fs, FR_INT_ERR);
	ld	hl, sp+30
	ld	a, [hl]
	sub	a, $02
	inc	hl
	ld	a, [hl]
	sbc	a, $00
	inc	hl
	ld	a, [hl]
	sbc	a, $00
	inc	hl
	ld	a, [hl]
	sbc	a, $00
	jp	NC, .l00112
	ld	hl, sp+4
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	ld	[hl], $02
	ld	a, $02
	jp	.l00138
.l00112:
;src/fatfs/lib/ff.c:4042: if (clst == 0xFFFFFFFF) ABORT(fs, FR_DISK_ERR);
	ld	hl, sp+30
	ld	a, [hl]
	inc	hl
	and	a, [hl]
	inc	hl
	and	a, [hl]
	inc	hl
	and	a, [hl]
	inc	a
	jp	NZ,.l00238
	jp	.l00239
.l00238:
	jp	.l00114
.l00239:
	ld	hl, sp+4
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	ld	[hl], $01
	ld	a, $01
	jp	.l00138
.l00114:
;src/fatfs/lib/ff.c:4043: fp->clust = clst;				/* Update current cluster */
	ld	hl, sp+13
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, sp+30
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
.l00116:
;src/fatfs/lib/ff.c:4045: sect = clst2sect(fs, fp->clust);	/* Get current sector */
	ld	hl, sp+15
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	ld	c, a
	inc	de
	ld	a, [de]
	ld	b, a
	inc	de
	ld	a, [de]
	ld	l, a
;	spillPairReg hl
;	spillPairReg hl
	inc	de
	ld	a, [de]
	ld	h, a
;	spillPairReg hl
;	spillPairReg hl
	push	hl
	push	bc
	ld	hl, sp+4
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_clst2sect
	ld	hl, sp+22
	ld	[hl], c
	inc	hl
	ld	[hl], b
	inc	hl
	ld	[hl], e
	inc	hl
	ld	[hl], d
;src/fatfs/lib/ff.c:4046: if (sect == 0) ABORT(fs, FR_INT_ERR);
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	dec	hl
	or	a, [hl]
	dec	hl
	or	a, [hl]
	jp	NZ, .l00118
	ld	hl, sp+4
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	ld	[hl], $02
	ld	a, $02
	jp	.l00138
.l00118:
;src/fatfs/lib/ff.c:4047: sect += csect;
	ld	hl, sp+34
	ld	a, [hl]
	ld	hl, sp+26
	ld	[hl], a
	ld	hl, sp+35
	ld	a, [hl]
	ld	hl, sp+27
	ld	[hl], a
	xor	a, a
	inc	hl
	ld	[hl], a
	inc	hl
	ld	[hl], a
	ld	hl, sp+23
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, e
	ld	hl, sp+26
	add	a, [hl]
	ld	e, a
	ld	a, d
	inc	hl
	adc	a, [hl]
	push	af
	ld	hl, sp+33
	ld	[hl], a
	dec	hl
	ld	[hl], e
	ld	hl, sp+27
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, sp+30
	pop	af
	ld	a, e
	adc	a, [hl]
	ld	e, a
	ld	a, d
	inc	hl
	adc	a, [hl]
	ld	hl, sp+33
	ld	[hl], a
	dec	hl
	ld	[hl], e
	dec	hl
	dec	hl
	ld	d, h
	ld	e, l
	ld	hl, sp+20
	ld	a, [de]
	ld	[hl+], a
	inc	de
	ld	a, [de]
	ld	[hl+], a
	inc	de
	ld	a, [de]
	ld	[hl+], a
	inc	de
	ld	a, [de]
	ld	[hl], a
;src/fatfs/lib/ff.c:4048: cc = btr / SS(fs);					/* When remaining bytes >= sector size, */
	ld	hl, sp+45
	ld	a, [hl]
	srl	a
	ld	hl, sp+24
	ld	[hl], a
	inc	hl
	ld	[hl], $00
;src/fatfs/lib/ff.c:4049: if (cc > 0) {						/* Read maximum contiguous sectors directly */
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	jp	Z, .l00127
;src/fatfs/lib/ff.c:4050: if (csect + cc > fs->csize) {	/* Clip at cluster boundary */
	inc	hl
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, sp+34
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+34
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+33
	ld	[hl], a
;src/fatfs/lib/ff.c:4025: csect = (UINT)(fp->fptr / SS(fs) & (fs->csize - 1));	/* Sector offset in the cluster */
	pop	bc
	push	bc
;src/fatfs/lib/ff.c:4050: if (csect + cc > fs->csize) {	/* Clip at cluster boundary */
	ld	hl, $000A
	add	hl, bc
	ld	e, l
	ld	d, h
	ld	a, [de]
	ld	hl, sp+36
	ld	[hl], a
	inc	de
	ld	a, [de]
	inc	hl
	ld	[hl], a
	ld	hl, sp+32
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, sp+36
	ld	a, [hl]
	sub	a, e
	inc	hl
	ld	a, [hl]
	sbc	a, d
	jp	NC, .l00120
;src/fatfs/lib/ff.c:4051: cc = fs->csize - csect;
	dec	hl
	ld	a, [hl]
	ld	hl, sp+32
	ld	[hl], a
	ld	hl, sp+37
	ld	a, [hl]
	ld	hl, sp+33
	ld	[hl], a
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	inc	hl
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	ld	a, e
	sub	a, l
	ld	e, a
	ld	a, d
	sbc	a, h
	ld	hl, sp+37
	ld	[hl], a
	dec	hl
	ld	[hl], e
	ld	a, [hl]
	ld	hl, sp+24
	ld	[hl], a
	ld	hl, sp+37
	ld	a, [hl]
	ld	hl, sp+25
	ld	[hl], a
.l00120:
;src/fatfs/lib/ff.c:4053: if (disk_read(fs->pdrv, rbuff, sect, cc) != RES_OK) ABORT(fs, FR_DISK_ERR);
	inc	bc
	ld	a, [bc]
	ld	c, a
	ld	hl, sp+24
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	push	de
	ld	hl, sp+24
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	push	de
	ld	hl, sp+24
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	push	de
	ld	hl, sp+46
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, c
	call	_disk_read__far
	or	a, a
	jp	Z, .l00122
	ld	hl, sp+4
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	ld	[hl], $01
	ld	a, $01
	jp	.l00138
.l00122:
;src/fatfs/lib/ff.c:4056: if (fs->wflag && fs->winsect - sect < cc) {
	pop	bc
	push	bc
	ld	hl, $0004
	add	hl, bc
	ld	a, [hl]
	or	a, a
	jp	Z, .l00124
	ld	hl, $001E
	add	hl, bc
	ld	e, l
	ld	d, h
	ld	a, [de]
	ld	hl, sp+26
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
	ld	hl, sp+27
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, e
	ld	hl, sp+20
	sub	a, [hl]
	ld	e, a
	ld	a, d
	inc	hl
	sbc	a, [hl]
	push	af
	ld	hl, sp+33
	ld	[hl], a
	dec	hl
	ld	[hl], e
	dec	hl
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, sp+24
	pop	af
	ld	a, e
	sbc	a, [hl]
	ld	e, a
	ld	a, d
	inc	hl
	sbc	a, [hl]
	ld	hl, sp+33
	ld	[hl], a
	dec	hl
	ld	[hl], e
	ld	hl, sp+24
	ld	a, [hl]
	ld	hl, sp+34
	ld	[hl], a
	ld	hl, sp+25
	ld	a, [hl]
	ld	hl, sp+35
	ld	[hl], a
	xor	a, a
	inc	hl
	ld	[hl], a
	inc	hl
	ld	[hl], a
	ld	hl, sp+30
	ld	e, l
	ld	d, h
	ld	hl, sp+34
	ld	a, [de]
	inc	de
	sub	a, [hl]
	inc	hl
	ld	a, [de]
	inc	de
	sbc	a, [hl]
	inc	hl
	ld	a, [de]
	inc	de
	sbc	a, [hl]
	inc	hl
	ld	a, [de]
	sbc	a, [hl]
	jp	NC, .l00124
;src/fatfs/lib/ff.c:4057: memcpy(rbuff + ((fs->winsect - sect) * SS(fs)), fs->win, SS(fs));
	ld	hl, $0032
	add	hl, bc
	ld	c, l
	ld	a, h
	ld	hl, sp+36
	ld	[hl], c
	inc	hl
	ld	[hl], a
	ld	hl, sp+26
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	ld	hl, sp+20
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, c
	sub	a, e
	ld	c, a
	ld	a, b
	sbc	a, d
	ld	b, a
	ld	a, c
	add	a, a
	ld	b, a
	ld	c, $00
	ld	hl, sp+40
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	add	hl, bc
	ld	e, l
	ld	d, h
	ld	bc, $0200
	push	bc
	ld	hl, sp+38
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	call	___memcpy
.l00124:
;src/fatfs/lib/ff.c:4065: rcnt = SS(fs) * cc;				/* Number of bytes transferred */
	ld	hl, sp+24
	ld	a, [hl]
	add	a, a
	ld	hl, sp+37
	ld	[hl], a
	dec	hl
	ld	[hl], $00
;src/fatfs/lib/ff.c:4066: continue;
	jp	.l00134
.l00127:
;src/fatfs/lib/ff.c:4079: fp->sect = sect;
	ld	hl, sp+17
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, sp+20
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
.l00129:
;src/fatfs/lib/ff.c:4081: rcnt = SS(fs) - (UINT)fp->fptr % SS(fs);	/* Number of bytes remains in the sector */
	ld	hl, sp+7
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	ld	c, a
	inc	de
	ld	a, [de]
	and	a, $01
	ld	b, a
	ld	de, $0200
	ld	a, e
	sub	a, c
	ld	e, a
	ld	a, d
	sbc	a, b
	ld	hl, sp+37
	ld	[hl], a
	dec	hl
	ld	[hl], e
;src/fatfs/lib/ff.c:4082: if (rcnt > btr) rcnt = btr;					/* Clip it by btr if needed */
	ld	hl, sp+44
	ld	e, l
	ld	d, h
	ld	hl, sp+36
	ld	a, [de]
	inc	de
	sub	a, [hl]
	inc	hl
	ld	a, [de]
	sbc	a, [hl]
	jp	NC, .l00131
	ld	hl, sp+44
	ld	a, [hl]
	ld	hl, sp+36
	ld	[hl], a
	ld	hl, sp+45
	ld	a, [hl]
	ld	hl, sp+37
	ld	[hl], a
.l00131:
;src/fatfs/lib/ff.c:4084: if (move_window(fs, fp->sect) != FR_OK) ABORT(fs, FR_DISK_ERR);	/* Move sector window */
	ld	hl, sp+19
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	ld	c, a
	inc	de
	ld	a, [de]
	ld	b, a
	inc	de
	ld	a, [de]
	ld	l, a
;	spillPairReg hl
;	spillPairReg hl
	inc	de
	ld	a, [de]
	ld	h, a
;	spillPairReg hl
;	spillPairReg hl
	push	hl
	push	bc
	ld	hl, sp+4
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_move_window__far
	or	a, a
	jp	Z, .l00133
	ld	hl, sp+4
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	ld	[hl], $01
	ld	a, $01
	jp	.l00138
.l00133:
;src/fatfs/lib/ff.c:4085: memcpy(rbuff, fs->win + fp->fptr % SS(fs), rcnt);	/* Extract partial sector */
	pop	bc
	push	bc
	ld	hl, $0032
	add	hl, bc
	push	hl
	ld	a, l
	ld	hl, sp+30
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+29
	ld	[hl], a
	ld	hl, sp+7
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	ld	hl, sp+24
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
	ld	hl, sp+24
	ld	a, [hl]
	ld	hl, sp+30
	ld	[hl], a
	ld	hl, sp+25
	ld	a, [hl]
	and	a, $01
	ld	hl, sp+31
	ld	[hl], a
	xor	a, a
	inc	hl
	ld	[hl], a
	inc	hl
	ld	[hl], a
	ld	hl, sp+29
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	inc	hl
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+36
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+35
	ld	[hl], a
	ld	hl, sp+40
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, sp+36
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	push	bc
	ld	hl, sp+36
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	call	___memcpy
.l00134:
;src/fatfs/lib/ff.c:4023: for ( ; btr > 0; btr -= rcnt, *br += rcnt, rbuff += rcnt, fp->fptr += rcnt) {	/* Repeat until btr bytes read */
	ld	hl, sp+45
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, sp+36
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	ld	a, e
	sub	a, l
	ld	e, a
	ld	a, d
	sbc	a, h
	ld	hl, sp+45
	ld	[hl], a
	dec	hl
	ld	[hl], e
	ld	hl, sp+3
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	ld	c, a
	inc	de
	ld	a, [de]
	ld	b, a
	ld	hl, sp+36
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	add	hl, bc
	ld	c, l
	ld	b, h
	ld	hl, sp+2
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	ld	[hl], c
	inc	hl
	ld	[hl], b
	ld	hl, sp+37
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, sp+40
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+42
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+41
	ld	[hl], a
	ld	hl, sp+7
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	ld	hl, sp+30
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
	ld	hl, sp+36
	ld	a, [hl]
	dec	hl
	dec	hl
	ld	[hl], a
	ld	hl, sp+37
	ld	a, [hl]
	dec	hl
	dec	hl
	ld	[hl], a
	xor	a, a
	inc	hl
	ld	[hl], a
	inc	hl
	ld	[hl], a
	ld	hl, sp+31
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, e
	ld	hl, sp+34
	add	a, [hl]
	ld	e, a
	ld	a, d
	inc	hl
	adc	a, [hl]
	push	af
	ld	hl, sp+29
	ld	[hl], a
	dec	hl
	ld	[hl], e
	ld	hl, sp+35
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, sp+38
	pop	af
	ld	a, e
	adc	a, [hl]
	ld	e, a
	ld	a, d
	inc	hl
	adc	a, [hl]
	ld	hl, sp+29
	ld	[hl], a
	dec	hl
	ld	[hl], e
	ld	hl, sp+7
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, sp+26
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
	jp	.l00137
.l00135:
;src/fatfs/lib/ff.c:4091: LEAVE_FF(fs, FR_OK);
	xor	a, a
.l00138:
;src/fatfs/lib/ff.c:4092: }
	add	sp, 42
	pop	hl
	add	sp, 4
	jp hl 
;src/fatfs/lib/ff.c:4102: FRESULT f_write (
;	---------------------------------
	SECTION FRAGMENT "src/fatfs/fatfs.c B",ROMX
; Function f_write
; ---------------------------------
_f_write::
	add	sp, -50
	ld	hl, sp+46
	ld	[hl], e
	inc	hl
	ld	[hl], d
;src/fatfs/lib/ff.c:4114: const BYTE *wbuff = (const BYTE*)buff;
	inc	hl
	ld	[hl], c
	inc	hl
	ld	[hl], b
;src/fatfs/lib/ff.c:4117: *bw = 0;	/* Clear write byte counter */
	ld	hl, sp+54
	ld	a, [hl]
	ld	hl, sp+2
	ld	[hl], a
	ld	hl, sp+55
	ld	a, [hl]
	ld	hl, sp+3
	ld	[hl], a
	pop	bc
	pop	hl
	push	hl
	push	bc
	xor	a, a
	ld	[hl], a
	inc	hl
	ld	[hl], a
;src/fatfs/lib/ff.c:4118: res = validate(&fp->obj, &fs);			/* Check validity of the file object */
	ld	hl, sp+0
	ld	c, l
	ld	b, h
	ld	hl, sp+46
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_validate__far
	ld	hl, sp+44
	ld	[hl], a
	ld	hl, sp+44
	ld	a, [hl]
	inc	hl
	ld	[hl], a
;src/fatfs/lib/ff.c:4119: if (res != FR_OK || (res = (FRESULT)fp->err) != FR_OK) LEAVE_FF(fs, res);	/* Check validity */
	dec	hl
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00101
	ld	hl, sp+47
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $000F
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
	ld	hl, sp+45
	ld	[hl], a
	or	a, a
	jp	Z, .l00102
.l00101:
	ld	hl, sp+45
	ld	a, [hl]
	jp	.l00152
.l00102:
;src/fatfs/lib/ff.c:4120: if (!(fp->flag & FA_WRITE)) LEAVE_FF(fs, FR_DENIED);	/* Check access mode */
	ld	hl, sp+47
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $000E
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+8
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+7
	ld	[hl], a
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	bit	1, a
	jp	NZ,.l00283
	jp	.l00284
.l00283:
	jp	.l00109
.l00284:
	ld	a, $07
	jp	.l00152
;src/fatfs/lib/ff.c:4123: if ((!FF_FS_EXFAT || fs->fs_type != FS_EXFAT) && (DWORD)(fp->fptr + btw) < (DWORD)fp->fptr) {
.l00109:
	ld	hl, sp+47
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $0010
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
	ld	a, [hl]
	inc	hl
	inc	hl
	ld	[hl], a
	dec	hl
	ld	a, [hl]
	inc	hl
	inc	hl
	ld	[hl], a
	dec	hl
	dec	hl
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	ld	hl, sp+34
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
	ld	hl, sp+52
	ld	a, [hl]
	ld	hl, sp+38
	ld	[hl], a
	ld	hl, sp+53
	ld	a, [hl]
	ld	hl, sp+39
	ld	[hl], a
	xor	a, a
	inc	hl
	ld	[hl], a
	inc	hl
	ld	[hl], a
	ld	hl, sp+35
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, e
	ld	hl, sp+38
	add	a, [hl]
	ld	e, a
	ld	a, d
	inc	hl
	adc	a, [hl]
	push	af
	ld	hl, sp+45
	ld	[hl], a
	dec	hl
	ld	[hl], e
	ld	hl, sp+39
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, sp+42
	pop	af
	ld	a, e
	adc	a, [hl]
	ld	e, a
	ld	a, d
	inc	hl
	adc	a, [hl]
	ld	hl, sp+45
	ld	[hl], a
	dec	hl
	ld	[hl], e
	ld	hl, sp+42
	ld	e, l
	ld	d, h
	ld	hl, sp+34
	ld	a, [de]
	inc	de
	sub	a, [hl]
	inc	hl
	ld	a, [de]
	inc	de
	sbc	a, [hl]
	inc	hl
	ld	a, [de]
	inc	de
	sbc	a, [hl]
	inc	hl
	ld	a, [de]
	sbc	a, [hl]
	jp	NC, .l00182
;src/fatfs/lib/ff.c:4124: btw = (UINT)(0xFFFFFFFF - (DWORD)fp->fptr);
	ld	hl, sp+34
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	ld	de, $FFFF
	ld	a, e
	sub	a, c
	ld	e, a
	ld	a, d
	sbc	a, b
	ld	hl, sp+53
	ld	[hl], a
	dec	hl
	ld	[hl], e
.l00182:
	ld	hl, sp+47
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $0006
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+14
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+13
	ld	[hl], a
	dec	hl
	ld	a, [hl]
	inc	hl
	inc	hl
	ld	[hl], a
	dec	hl
	ld	a, [hl]
	inc	hl
	inc	hl
	ld	[hl], a
;src/fatfs/lib/ff.c:4143: clst = create_chain(&fp->obj, fp->clust);	/* Follow or stretch cluster chain on the FAT */
	ld	hl, sp+47
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $0014
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+18
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+17
	ld	[hl], a
;src/fatfs/lib/ff.c:4124: btw = (UINT)(0xFFFFFFFF - (DWORD)fp->fptr);
	dec	hl
	ld	a, [hl]
	inc	hl
	inc	hl
	ld	[hl], a
	dec	hl
	ld	a, [hl]
	inc	hl
	inc	hl
	ld	[hl], a
	ld	hl, sp+8
	ld	a, [hl]
	ld	hl, sp+20
	ld	[hl], a
	ld	hl, sp+9
	ld	a, [hl]
	ld	hl, sp+21
	ld	[hl], a
	ld	hl, sp+47
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $000A
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+24
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+23
	ld	[hl], a
	dec	hl
	ld	a, [hl]
	inc	hl
	inc	hl
	ld	[hl], a
	dec	hl
	ld	a, [hl]
	inc	hl
	inc	hl
	ld	[hl], a
	ld	hl, sp+47
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $0018
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+28
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+27
	ld	[hl], a
	dec	hl
	ld	a, [hl]
	inc	hl
	inc	hl
	ld	[hl], a
	dec	hl
	ld	a, [hl]
	inc	hl
	inc	hl
	ld	[hl], a
.l00151:
;src/fatfs/lib/ff.c:4127: for ( ; btw > 0; btw -= wcnt, *bw += wcnt, wbuff += wcnt, fp->fptr += wcnt, fp->obj.objsize = (fp->fptr > fp->obj.objsize) ? fp->fptr : fp->obj.objsize) {	/* Repeat until all data written */
	ld	hl, sp+53
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	jp	Z, .l00149
;src/fatfs/lib/ff.c:4128: if (fp->fptr % SS(fs) == 0) {		/* On the sector boundary? */
	ld	hl, sp+11
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	ld	hl, sp+38
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
	ld	hl, sp+38
	ld	a, [hl]
	or	a, a
	jp	NZ,.l00285
	push	hl
	inc	hl
	bit	0, [hl]
	pop	hl
	jp	NZ,.l00285
	jp	.l00286
.l00285:
	jp	.l00143
.l00286:
;src/fatfs/lib/ff.c:4129: csect = (UINT)(fp->fptr / SS(fs)) & (fs->csize - 1);	/* Sector offset in the cluster */
	ld	hl, sp+39
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	inc	hl
	ld	e, [hl]
	ld	d, $00
	srl	e
	rr	b
	rr	c
	pop	de
	push	de
	ld	hl, $000A
	add	hl, de
	ld	a, [hl]
	inc	hl
	ld	h, [hl]
;	spillPairReg hl
	ld	l, a
;	spillPairReg hl
;	spillPairReg hl
	dec	hl
	ld	a, l
	and	a, c
	ld	c, a
	ld	a, h
	and	a, b
	ld	hl, sp+42
	ld	[hl], c
	inc	hl
	ld	[hl], a
;src/fatfs/lib/ff.c:4130: if (csect == 0) {				/* On the cluster boundary? */
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	jp	NZ, .l00124
;src/fatfs/lib/ff.c:4131: if (fp->fptr == 0) {		/* On the top of the file? */
	dec	hl
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	dec	hl
	or	a, [hl]
	dec	hl
	or	a, [hl]
	jp	NZ, .l00113
;src/fatfs/lib/ff.c:4132: clst = fp->obj.sclust;	/* Follow from the origin */
	ld	hl, sp+15
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	ld	hl, sp+34
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
;src/fatfs/lib/ff.c:4133: if (clst == 0) {		/* If no cluster is allocated, */
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	dec	hl
	or	a, [hl]
	dec	hl
	or	a, [hl]
	jp	NZ, .l00114
;src/fatfs/lib/ff.c:4134: clst = create_chain(&fp->obj, 0);	/* create a new cluster chain */
	ld	de, $0000
	push	de
	push	de
	ld	hl, sp+50
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_create_chain
	ld	hl, sp+38
	ld	[hl], c
	inc	hl
	ld	[hl], b
	inc	hl
	ld	[hl], e
	inc	hl
	ld	[hl], d
	ld	hl, sp+38
	ld	d, h
	ld	e, l
	ld	hl, sp+34
	ld	a, [de]
	ld	[hl+], a
	inc	de
	ld	a, [de]
	ld	[hl+], a
	inc	de
	ld	a, [de]
	ld	[hl+], a
	inc	de
	ld	a, [de]
	ld	[hl], a
	jp	.l00114
.l00113:
;src/fatfs/lib/ff.c:4143: clst = create_chain(&fp->obj, fp->clust);	/* Follow or stretch cluster chain on the FAT */
	ld	hl, sp+17
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	ld	hl, sp+38
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
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	push	de
	ld	hl, sp+40
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	push	de
	ld	hl, sp+50
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_create_chain
	ld	hl, sp+38
	ld	[hl], c
	inc	hl
	ld	[hl], b
	inc	hl
	ld	[hl], e
	inc	hl
	ld	[hl], d
	ld	hl, sp+38
	ld	d, h
	ld	e, l
	ld	hl, sp+34
	ld	a, [de]
	ld	[hl+], a
	inc	de
	ld	a, [de]
	ld	[hl+], a
	inc	de
	ld	a, [de]
	ld	[hl+], a
	inc	de
	ld	a, [de]
	ld	[hl], a
.l00114:
;src/fatfs/lib/ff.c:4146: if (clst == 0) break;		/* Could not allocate a new cluster (disk full) */
	ld	hl, sp+37
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	dec	hl
	or	a, [hl]
	dec	hl
	or	a, [hl]
	jp	Z, .l00149
;src/fatfs/lib/ff.c:4147: if (clst == 1) ABORT(fs, FR_INT_ERR);
	ld	a, [hl]
	dec	a
	inc	hl
	or	a, [hl]
	inc	hl
	or	a, [hl]
	inc	hl
	or	a, [hl]
	jp	NZ,.l00289
	jp	.l00290
.l00289:
	jp	.l00118
.l00290:
	ld	hl, sp+4
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	ld	[hl], $02
	ld	a, $02
	jp	.l00152
.l00118:
;src/fatfs/lib/ff.c:4148: if (clst == 0xFFFFFFFF) ABORT(fs, FR_DISK_ERR);
	ld	hl, sp+34
	ld	a, [hl]
	inc	hl
	and	a, [hl]
	inc	hl
	and	a, [hl]
	inc	hl
	and	a, [hl]
	inc	a
	jp	NZ,.l00291
	jp	.l00292
.l00291:
	jp	.l00120
.l00292:
	ld	hl, sp+4
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	ld	[hl], $01
	ld	a, $01
	jp	.l00152
.l00120:
;src/fatfs/lib/ff.c:4149: fp->clust = clst;			/* Update current cluster */
	ld	hl, sp+17
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, sp+34
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
;src/fatfs/lib/ff.c:4150: if (fp->obj.sclust == 0) fp->obj.sclust = clst;	/* Set start cluster if the first write */
	ld	hl, sp+13
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	ld	hl, sp+38
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
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	dec	hl
	or	a, [hl]
	dec	hl
	or	a, [hl]
	jp	NZ, .l00124
	ld	hl, sp+13
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, sp+34
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
.l00124:
;src/fatfs/lib/ff.c:4153: if (fs->winsect == fp->sect && sync_window(fs) != FR_OK) ABORT(fs, FR_DISK_ERR);	/* Write-back sector cache */
	pop	bc
	push	bc
	ld	hl, $001E
	add	hl, bc
	ld	e, l
	ld	d, h
	ld	a, [de]
	ld	hl, sp+34
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
	ld	hl, sp+27
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	ld	hl, sp+38
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
	ld	hl, sp+34
	ld	a, [hl]
	ld	hl, sp+38
	sub	a, [hl]
	jp	NZ,.l00293
	ld	hl, sp+35
	ld	a, [hl]
	ld	hl, sp+39
	sub	a, [hl]
	jp	NZ,.l00293
	ld	hl, sp+36
	ld	a, [hl]
	ld	hl, sp+40
	sub	a, [hl]
	jp	NZ,.l00293
	ld	hl, sp+37
	ld	a, [hl]
	ld	hl, sp+41
	sub	a, [hl]
	jp	NZ,.l00293
	jp	.l00294
.l00293:
	jp	.l00126
.l00294:
	ld	e, c
	ld	d, b
	call	_sync_window
	or	a, a
	jp	Z, .l00126
	ld	hl, sp+4
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	ld	[hl], $01
	ld	a, $01
	jp	.l00152
.l00126:
;src/fatfs/lib/ff.c:4160: sect = clst2sect(fs, fp->clust);	/* Get current sector */
	ld	hl, sp+19
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	ld	c, a
	inc	de
	ld	a, [de]
	ld	b, a
	inc	de
	ld	a, [de]
	ld	l, a
;	spillPairReg hl
;	spillPairReg hl
	inc	de
	ld	a, [de]
	ld	h, a
;	spillPairReg hl
;	spillPairReg hl
	push	hl
	push	bc
	ld	hl, sp+4
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_clst2sect__far
	ld	hl, sp+30
	ld	[hl], c
	inc	hl
	ld	[hl], b
	inc	hl
	ld	[hl], e
	inc	hl
	ld	[hl], d
;src/fatfs/lib/ff.c:4161: if (sect == 0) ABORT(fs, FR_INT_ERR);
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	dec	hl
	or	a, [hl]
	dec	hl
	or	a, [hl]
	jp	NZ, .l00129
	ld	hl, sp+4
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	ld	[hl], $02
	ld	a, $02
	jp	.l00152
.l00129:
;src/fatfs/lib/ff.c:4162: sect += csect;
	ld	hl, sp+42
	ld	a, [hl]
	ld	hl, sp+34
	ld	[hl], a
	ld	hl, sp+43
	ld	a, [hl]
	ld	hl, sp+35
	ld	[hl], a
	xor	a, a
	inc	hl
	ld	[hl], a
	inc	hl
	ld	[hl], a
	ld	hl, sp+31
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, e
	ld	hl, sp+34
	add	a, [hl]
	ld	e, a
	ld	a, d
	inc	hl
	adc	a, [hl]
	push	af
	ld	hl, sp+41
	ld	[hl], a
	dec	hl
	ld	[hl], e
	ld	hl, sp+35
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, sp+38
	pop	af
	ld	a, e
	adc	a, [hl]
	ld	e, a
	ld	a, d
	inc	hl
	adc	a, [hl]
	ld	hl, sp+41
	ld	[hl], a
	dec	hl
	ld	[hl], e
	dec	hl
	dec	hl
	ld	d, h
	ld	e, l
	ld	hl, sp+30
	ld	a, [de]
	ld	[hl+], a
	inc	de
	ld	a, [de]
	ld	[hl+], a
	inc	de
	ld	a, [de]
	ld	[hl+], a
	inc	de
	ld	a, [de]
	ld	[hl], a
;src/fatfs/lib/ff.c:4163: cc = btw / SS(fs);				/* When remaining bytes >= sector size, */
	ld	hl, sp+53
	ld	a, [hl]
	srl	a
	ld	hl, sp+34
	ld	[hl], a
	inc	hl
	ld	[hl], $00
;src/fatfs/lib/ff.c:4164: if (cc > 0) {					/* Write maximum contiguous sectors directly */
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	jp	Z, .l00137
;src/fatfs/lib/ff.c:4165: if (csect + cc > fs->csize) {	/* Clip at cluster boundary */
	inc	hl
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, sp+42
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+42
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+41
	ld	[hl], a
;src/fatfs/lib/ff.c:4129: csect = (UINT)(fp->fptr / SS(fs)) & (fs->csize - 1);	/* Sector offset in the cluster */
	pop	bc
	push	bc
;src/fatfs/lib/ff.c:4165: if (csect + cc > fs->csize) {	/* Clip at cluster boundary */
	ld	hl, $000A
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
	ld	hl, sp+40
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, sp+44
	ld	a, [hl]
	sub	a, e
	inc	hl
	ld	a, [hl]
	sbc	a, d
	jp	NC, .l00131
;src/fatfs/lib/ff.c:4166: cc = fs->csize - csect;
	dec	hl
	ld	a, [hl]
	ld	hl, sp+40
	ld	[hl], a
	ld	hl, sp+45
	ld	a, [hl]
	ld	hl, sp+41
	ld	[hl], a
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	inc	hl
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	ld	a, e
	sub	a, l
	ld	e, a
	ld	a, d
	sbc	a, h
	ld	hl, sp+45
	ld	[hl], a
	dec	hl
	ld	[hl], e
	ld	a, [hl]
	ld	hl, sp+34
	ld	[hl], a
	ld	hl, sp+45
	ld	a, [hl]
	ld	hl, sp+35
	ld	[hl], a
.l00131:
;src/fatfs/lib/ff.c:4168: if (disk_write(fs->pdrv, wbuff, sect, cc) != RES_OK) ABORT(fs, FR_DISK_ERR);
	inc	bc
	ld	a, [bc]
	ld	c, a
	ld	hl, sp+34
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	push	de
	ld	hl, sp+34
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	push	de
	ld	hl, sp+34
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	push	de
	ld	hl, sp+54
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, c
	call	_disk_write
	or	a, a
	jp	Z, .l00133
	ld	hl, sp+4
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	ld	[hl], $01
	ld	a, $01
	jp	.l00152
.l00133:
;src/fatfs/lib/ff.c:4171: if (fs->winsect - sect < cc) {	/* Refill sector cache if it gets invalidated by the direct write */
	ld	hl, sp+0
	ld	a, [hl]
	ld	hl, sp+36
	ld	[hl], a
	ld	hl, sp+1
	ld	a, [hl]
	ld	hl, sp+37
	ld	[hl], a
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $001E
	add	hl, de
	ld	c, l
	ld	b, h
	ld	e, c
	ld	d, b
	ld	a, [de]
	ld	hl, sp+38
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
	dec	hl
	dec	hl
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, e
	ld	hl, sp+30
	sub	a, [hl]
	ld	e, a
	ld	a, d
	inc	hl
	sbc	a, [hl]
	push	af
	ld	hl, sp+45
	ld	[hl], a
	dec	hl
	ld	[hl], e
	dec	hl
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, sp+34
	pop	af
	ld	a, e
	sbc	a, [hl]
	ld	e, a
	ld	a, d
	inc	hl
	sbc	a, [hl]
	ld	hl, sp+45
	ld	[hl], a
	dec	hl
	ld	[hl], e
	ld	hl, sp+34
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	ld	de, $0000
	ld	hl, sp+42
	ld	a, [hl]
	sub	a, c
	inc	hl
	ld	a, [hl]
	sbc	a, b
	inc	hl
	ld	a, [hl]
	sbc	a, e
	inc	hl
	ld	a, [hl]
	sbc	a, d
	jp	NC, .l00135
;src/fatfs/lib/ff.c:4172: memcpy(fs->win, wbuff + ((fs->winsect - sect) * SS(fs)), SS(fs));
	ld	hl, sp+38
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	ld	hl, sp+30
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, c
	sub	a, e
	ld	c, a
	ld	a, b
	sbc	a, d
	ld	b, a
	ld	a, c
	add	a, a
	ld	b, a
	ld	c, $00
	ld	hl, sp+48
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	add	hl, bc
	ld	c, l
	ld	b, h
	ld	hl, sp+37
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $0032
	add	hl, de
	ld	e, l
	ld	d, h
	ld	hl, $0200
	push	hl
	call	___memcpy
;src/fatfs/lib/ff.c:4173: fs->wflag = 0;
	pop	bc
	push	bc
	inc	bc
	inc	bc
	inc	bc
	inc	bc
	xor	a, a
	ld	[bc], a
.l00135:
;src/fatfs/lib/ff.c:4182: wcnt = SS(fs) * cc;		/* Number of bytes transferred */
	ld	hl, sp+34
	ld	a, [hl]
	add	a, a
	ld	hl, sp+45
	ld	[hl], a
	dec	hl
	ld	[hl], $00
;src/fatfs/lib/ff.c:4183: continue;
	jp	.l00148
.l00137:
;src/fatfs/lib/ff.c:4186: if (fp->fptr >= fp->obj.objsize) {	/* Avoid silly cache filling on the growing edge */
	ld	hl, sp+21
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	ld	hl, sp+38
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
	ld	hl, sp+25
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	ld	hl, sp+42
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
	ld	hl, sp+38
	ld	e, l
	ld	d, h
	ld	hl, sp+42
	ld	a, [de]
	inc	de
	sub	a, [hl]
	inc	hl
	ld	a, [de]
	inc	de
	sbc	a, [hl]
	inc	hl
	ld	a, [de]
	inc	de
	sbc	a, [hl]
	inc	hl
	ld	a, [de]
	sbc	a, [hl]
	jp	C, .l00141
;src/fatfs/lib/ff.c:4187: if (sync_window(fs) != FR_OK) ABORT(fs, FR_DISK_ERR);
	pop	de
	push	de
	call	_sync_window
	or	a, a
	jp	Z, .l00139
	ld	hl, sp+4
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	ld	[hl], $01
	ld	a, $01
	jp	.l00152
.l00139:
;src/fatfs/lib/ff.c:4188: fs->winsect = sect;
	ld	hl, sp+0
	ld	a, [hl]
	inc	hl
	ld	b, [hl]
	add	a, $1E
	ld	c, a
	jp	NC, .l00295
	inc	b
.l00295:
	ld	hl, sp+30
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
.l00141:
;src/fatfs/lib/ff.c:4197: fp->sect = sect;
	ld	hl, sp+27
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, sp+30
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
.l00143:
;src/fatfs/lib/ff.c:4199: wcnt = SS(fs) - (UINT)fp->fptr % SS(fs);	/* Number of bytes remains in the sector */
	ld	hl, sp+9
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	ld	c, a
	inc	de
	ld	a, [de]
	and	a, $01
	ld	b, a
	ld	de, $0200
	ld	a, e
	sub	a, c
	ld	e, a
	ld	a, d
	sbc	a, b
	ld	hl, sp+45
	ld	[hl], a
	dec	hl
	ld	[hl], e
;src/fatfs/lib/ff.c:4200: if (wcnt > btw) wcnt = btw;					/* Clip it by btw if needed */
	ld	hl, sp+52
	ld	e, l
	ld	d, h
	ld	hl, sp+44
	ld	a, [de]
	inc	de
	sub	a, [hl]
	inc	hl
	ld	a, [de]
	sbc	a, [hl]
	jp	NC, .l00145
	ld	hl, sp+52
	ld	a, [hl]
	ld	hl, sp+44
	ld	[hl], a
	ld	hl, sp+53
	ld	a, [hl]
	ld	hl, sp+45
	ld	[hl], a
.l00145:
;src/fatfs/lib/ff.c:4202: if (move_window(fs, fp->sect) != FR_OK) ABORT(fs, FR_DISK_ERR);	/* Move sector window */
	ld	hl, sp+29
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	ld	c, a
	inc	de
	ld	a, [de]
	ld	b, a
	inc	de
	ld	a, [de]
	ld	l, a
;	spillPairReg hl
;	spillPairReg hl
	inc	de
	ld	a, [de]
	ld	h, a
;	spillPairReg hl
;	spillPairReg hl
	push	hl
	push	bc
	ld	hl, sp+4
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_move_window
	or	a, a
	jp	Z, .l00147
	ld	hl, sp+4
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	ld	[hl], $01
	ld	a, $01
	jp	.l00152
.l00147:
;src/fatfs/lib/ff.c:4203: memcpy(fs->win + fp->fptr % SS(fs), wbuff, wcnt);	/* Fit data to the sector */
	ld	hl, sp+48
	ld	a, [hl]
	ld	hl, sp+40
	ld	[hl], a
	ld	hl, sp+49
	ld	a, [hl]
	ld	hl, sp+41
	ld	[hl], a
	pop	bc
	push	bc
	ld	hl, $0032
	add	hl, bc
	push	hl
	ld	a, l
	ld	hl, sp+44
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+43
	ld	[hl], a
	ld	hl, sp+9
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	ld	c, a
	inc	de
	ld	a, [de]
	ld	b, a
	inc	de
	ld	a, [de]
	ld	l, a
;	spillPairReg hl
;	spillPairReg hl
	inc	de
	ld	a, [de]
	ld	h, a
;	spillPairReg hl
;	spillPairReg hl
	ld	e, c
	ld	a, b
	and	a, $01
	ld	d, a
	ld	bc, $0000
	ld	hl, sp+42
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	add	hl, de
	ld	e, l
	ld	d, h
	ld	hl, sp+44
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	push	bc
	ld	hl, sp+42
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	call	___memcpy
;src/fatfs/lib/ff.c:4204: fs->wflag = 1;
	pop	bc
	push	bc
	ld	hl, $0004
	add	hl, bc
	ld	[hl], $01
.l00148:
;src/fatfs/lib/ff.c:4127: for ( ; btw > 0; btw -= wcnt, *bw += wcnt, wbuff += wcnt, fp->fptr += wcnt, fp->obj.objsize = (fp->fptr > fp->obj.objsize) ? fp->fptr : fp->obj.objsize) {	/* Repeat until all data written */
	ld	hl, sp+53
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, sp+44
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	ld	a, e
	sub	a, l
	ld	e, a
	ld	a, d
	sbc	a, h
	ld	hl, sp+53
	ld	[hl], a
	dec	hl
	ld	[hl], e
	ld	hl, sp+3
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	ld	c, a
	inc	de
	ld	a, [de]
	ld	b, a
	ld	hl, sp+44
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	add	hl, bc
	ld	c, l
	ld	b, h
	ld	hl, sp+2
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	ld	[hl], c
	inc	hl
	ld	[hl], b
	ld	hl, sp+45
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, sp+48
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+50
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+49
	ld	[hl], a
	ld	hl, sp+9
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	ld	hl, sp+38
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
	ld	hl, sp+44
	ld	a, [hl]
	dec	hl
	dec	hl
	ld	[hl], a
	ld	hl, sp+45
	ld	a, [hl]
	dec	hl
	dec	hl
	ld	[hl], a
	xor	a, a
	inc	hl
	ld	[hl], a
	inc	hl
	ld	[hl], a
	ld	hl, sp+39
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, e
	ld	hl, sp+42
	add	a, [hl]
	ld	e, a
	ld	a, d
	inc	hl
	adc	a, [hl]
	push	af
	ld	hl, sp+37
	ld	[hl], a
	dec	hl
	ld	[hl], e
	ld	hl, sp+43
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, sp+46
	pop	af
	ld	a, e
	adc	a, [hl]
	ld	e, a
	ld	a, d
	inc	hl
	adc	a, [hl]
	ld	hl, sp+37
	ld	[hl], a
	dec	hl
	ld	[hl], e
	ld	hl, sp+9
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, sp+34
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
	ld	hl, sp+23
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	ld	hl, sp+42
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
	ld	hl, sp+42
	ld	e, l
	ld	d, h
	ld	hl, sp+34
	ld	a, [de]
	inc	de
	sub	a, [hl]
	inc	hl
	ld	a, [de]
	inc	de
	sbc	a, [hl]
	inc	hl
	ld	a, [de]
	inc	de
	sbc	a, [hl]
	inc	hl
	ld	a, [de]
	sbc	a, [hl]
	jp	NC, .l00156
	ld	hl, sp+9
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	ld	hl, sp+42
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
	jp	.l00157
.l00156:
.l00157:
	ld	hl, sp+23
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, sp+42
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
	jp	.l00151
.l00149:
;src/fatfs/lib/ff.c:4211: fp->flag |= FA_MODIFIED;				/* Set file change flag */
	ld	hl, sp+7
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	ld	c, a
	set	6, c
	dec	hl
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	ld	[hl], c
;src/fatfs/lib/ff.c:4213: LEAVE_FF(fs, FR_OK);
	xor	a, a
.l00152:
;src/fatfs/lib/ff.c:4214: }
	add	sp, 50
	pop	hl
	add	sp, 4
	jp hl 
;src/fatfs/lib/ff.c:4223: FRESULT f_sync (
;	---------------------------------
	SECTION FRAGMENT "src/fatfs/fatfs.c B",ROMX
; Function f_sync
; ---------------------------------
_f_sync::
	add	sp, -14
	ld	hl, sp+12
	ld	[hl], e
	inc	hl
	ld	[hl], d
;src/fatfs/lib/ff.c:4231: res = validate(&fp->obj, &fs);	/* Check validity of the file object */
	ld	hl, sp+0
	ld	c, l
	ld	b, h
	ld	hl, sp+12
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_validate__far
	ld	c, a
;src/fatfs/lib/ff.c:4232: if (res == FR_OK) {
	ld	a, c
	or	a, a
	jp	NZ, .l00106
;src/fatfs/lib/ff.c:4233: if (fp->flag & FA_MODIFIED) {	/* Is there any change to the file? */
	ld	hl, sp+13
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $000E
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+4
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+3
	ld	[hl], a
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	bit	6, a
	jp	NZ,.l00124
	jp	.l00106
.l00124:
;src/fatfs/lib/ff.c:4275: res = move_window(fs, fp->dir_sect);
	ld	hl, sp+13
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $001C
	add	hl, de
	ld	c, l
	ld	b, h
	ld	l, c
	ld	h, b
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
	push	hl
	push	bc
	ld	hl, sp+4
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_move_window
	ld	c, a
;src/fatfs/lib/ff.c:4276: if (res == FR_OK) {
	ld	a, c
	or	a, a
	jp	NZ, .l00106
;src/fatfs/lib/ff.c:4277: BYTE *dir = fp->dir_ptr;
	ld	hl, sp+13
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $0020
	add	hl, de
	ld	c, l
	ld	b, h
	ld	e, c
	ld	d, b
	ld	a, [de]
	ld	hl, sp+4
	ld	[hl], a
	inc	de
	ld	a, [de]
	inc	hl
	ld	[hl], a
;src/fatfs/lib/ff.c:4279: dir[DIR_Attr] |= AM_ARC;					/* Set archive attribute to indicate that the file has been changed */
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $000B
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, [bc]
	set	5, a
	ld	[bc], a
;src/fatfs/lib/ff.c:4280: st_clust(fp->obj.fs, dir, fp->obj.sclust);	/* Update file allocation information  */
	ld	hl, sp+13
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $0006
	add	hl, de
	ld	c, l
	ld	b, h
	ld	e, c
	ld	d, b
	ld	a, [de]
	ld	hl, sp+6
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
	ld	hl, sp+13
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	ld	hl, sp+10
	ld	[hl], a
	inc	de
	ld	a, [de]
	inc	hl
	ld	[hl], a
	ld	hl, sp+8
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	push	de
	ld	hl, sp+8
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	push	de
	ld	hl, sp+8
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	ld	hl, sp+14
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_st_clust
;src/fatfs/lib/ff.c:4281: st_32(dir + DIR_FileSize, (DWORD)fp->obj.objsize);	/* Update file size */
	ld	hl, sp+13
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $000A
	add	hl, de
	ld	c, l
	ld	b, h
	ld	e, c
	ld	d, b
	ld	a, [de]
	ld	hl, sp+8
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
	ld	hl, sp+5
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $001C
	add	hl, de
	ld	e, l
	ld	d, h
	ld	hl, sp+10
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	push	bc
	ld	hl, sp+10
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	push	bc
	call	_st_32
;src/fatfs/lib/ff.c:4282: st_32(dir + DIR_ModTime, GET_FATTIME());	/* Update modified time */
	ld	hl, sp+5
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $0016
	add	hl, de
	ld	e, l
	ld	d, h
	ld	bc, $5C21
	push	bc
	ld	bc, $0000
	push	bc
	call	_st_32
;src/fatfs/lib/ff.c:4283: st_16(dir + DIR_LstAccDate, 0);				/* Invalidate last access date */
	ld	hl, sp+5
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $0012
	add	hl, de
	ld	e, l
	ld	d, h
	ld	bc, $0000
	call	_st_16
;src/fatfs/lib/ff.c:4284: fs->wflag = 1;
	pop	bc
	push	bc
	inc	bc
	inc	bc
	inc	bc
	inc	bc
	ld	a, $01
	ld	[bc], a
;src/fatfs/lib/ff.c:4285: res = sync_fs(fs);							/* Restore it to the directory */
	pop	de
	push	de
	call	_sync_fs
	ld	c, a
;src/fatfs/lib/ff.c:4286: fp->flag &= (BYTE)~FA_MODIFIED;
	ld	hl, sp+3
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	ld	b, a
	res	6, b
	dec	hl
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	ld	[hl], b
.l00106:
;src/fatfs/lib/ff.c:4292: LEAVE_FF(fs, res);
	ld	a, c
.l00107:
;src/fatfs/lib/ff.c:4293: }
	add	sp, 14
	ret
;src/fatfs/lib/ff.c:4304: FRESULT f_close (
;	---------------------------------
	SECTION FRAGMENT "src/fatfs/fatfs.c B",ROMX
; Function f_close
; ---------------------------------
_f_close::
	dec	sp
	dec	sp
;src/fatfs/lib/ff.c:4312: res = f_sync(fp);					/* Flush cached data */
	push	de
	call	_f_sync
	pop	de
;src/fatfs/lib/ff.c:4313: if (res == FR_OK)
	or	a, a
	jp	NZ, .l00104
;src/fatfs/lib/ff.c:4316: res = validate(&fp->obj, &fs);	/* Lock volume */
	ld	hl, sp+0
	ld	c, l
	ld	b, h
	push	de
	call	_validate__far
	pop	de
;src/fatfs/lib/ff.c:4317: if (res == FR_OK) {
	or	a, a
	jp	NZ, .l00104
;src/fatfs/lib/ff.c:4322: fp->obj.fs = 0;	/* Invalidate file object */
	push	af
	ld	a, $00
	ld	[de], a
	inc	de
	ld	a, $00
	ld	[de], a
	pop	af
.l00104:
;src/fatfs/lib/ff.c:4329: return res;
.l00105:
;src/fatfs/lib/ff.c:4330: }
	inc	sp
	inc	sp
	ret
;src/fatfs/lib/ff.c:4560: FRESULT f_lseek (
;	---------------------------------
	SECTION FRAGMENT "src/fatfs/fatfs.c B",ROMX
; Function f_lseek
; ---------------------------------
_f_lseek::
	add	sp, -37
	ld	hl, sp+35
	ld	[hl], e
	inc	hl
	ld	[hl], d
;src/fatfs/lib/ff.c:4572: res = validate(&fp->obj, &fs);		/* Check validity of the file object */
	ld	hl, sp+0
	ld	c, l
	ld	b, h
	ld	hl, sp+35
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_validate__far
	ld	hl, sp+2
	ld	[hl], a
;src/fatfs/lib/ff.c:4573: if (res == FR_OK) res = (FRESULT)fp->err;
	ld	hl, sp+36
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $000F
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+5
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+4
	ld	[hl], a
	dec	hl
	dec	hl
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00102
	inc	hl
	inc	hl
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	dec	hl
	dec	hl
	ld	[hl], a
.l00102:
;src/fatfs/lib/ff.c:4579: if (res != FR_OK) LEAVE_FF(fs, res);
	ld	hl, sp+2
	ld	a, [hl]
	or	a, a
	jp	Z, .l00104
	ld	a, [hl]
	jp	.l00149
.l00104:
;src/fatfs/lib/ff.c:4642: if (ofs > fp->obj.objsize && (FF_FS_READONLY || !(fp->flag & FA_WRITE))) {	/* In read-only mode, clip offset with the file size */
	ld	hl, sp+36
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $000A
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+7
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+6
	ld	[hl], a
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	ld	hl, sp+31
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
	inc	hl
	inc	hl
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $000E
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+9
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+8
	ld	[hl], a
	ld	hl, sp+31
	ld	e, l
	ld	d, h
	ld	hl, sp+39
	ld	a, [de]
	inc	de
	sub	a, [hl]
	inc	hl
	ld	a, [de]
	inc	de
	sbc	a, [hl]
	inc	hl
	ld	a, [de]
	inc	de
	sbc	a, [hl]
	inc	hl
	ld	a, [de]
	sbc	a, [hl]
	jp	NC, .l00106
	ld	hl, sp+8
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	bit	1, a
	jp	NZ,.l00260
	jp	.l00261
.l00260:
	jp	.l00106
.l00261:
;src/fatfs/lib/ff.c:4643: ofs = fp->obj.objsize;
	ld	hl, sp+31
	ld	d, h
	ld	e, l
	ld	hl, sp+39
	ld	a, [de]
	ld	[hl+], a
	inc	de
	ld	a, [de]
	ld	[hl+], a
	inc	de
	ld	a, [de]
	ld	[hl+], a
	inc	de
	ld	a, [de]
	ld	[hl], a
.l00106:
;src/fatfs/lib/ff.c:4645: ifptr = fp->fptr;
	ld	hl, sp+36
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $0010
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+11
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+10
	ld	[hl], a
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	ld	hl, sp+23
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
;src/fatfs/lib/ff.c:4646: fp->fptr = nsect = 0;
	xor	a, a
	ld	hl, sp+11
	ld	[hl], a
	inc	hl
	ld	[hl], a
	inc	hl
	ld	[hl], a
	inc	hl
	ld	[hl], a
	ld	hl, sp+9
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	xor	a, a
	ld	[hl], a
	inc	hl
	ld	[hl], a
	inc	hl
	ld	[hl], a
	inc	hl
	ld	[hl], a
;src/fatfs/lib/ff.c:4647: if (ofs > 0) {
	ld	hl, sp+42
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	dec	hl
	or	a, [hl]
	dec	hl
	or	a, [hl]
	jp	Z, .l00145
;src/fatfs/lib/ff.c:4648: bcs = (DWORD)fs->csize * SS(fs);	/* Cluster size (byte) */
	pop	bc
	push	bc
	ld	hl, $000A
	add	hl, bc
	ld	c, [hl]
	inc	hl
	ld	a, [hl]
	ld	de, $0000
	ld	d, e
	ld	e, a
	ld	a, c
	ld	c, $00
	add	a, a
	rl	e
	rl	d
	ld	hl, sp+15
	ld	[hl], c
	inc	hl
	ld	[hl], a
	inc	hl
	ld	[hl], e
	inc	hl
	ld	[hl], d
;src/fatfs/lib/ff.c:4653: clst = fp->clust;
	ld	hl, sp+36
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $0014
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+21
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+20
	ld	[hl], a
;src/fatfs/lib/ff.c:4649: if (ifptr > 0 &&
	ld	hl, sp+26
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	dec	hl
	or	a, [hl]
	dec	hl
	or	a, [hl]
	jp	Z, .l00116
;src/fatfs/lib/ff.c:4650: (ofs - 1) / bcs >= (ifptr - 1) / bcs) {	/* When seek to same or following cluster, */
	ld	hl, sp+40
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, e
	sub	a, $01
	ld	e, a
	ld	a, d
	sbc	a, $00
	push	af
	ld	hl, sp+34
	ld	[hl], a
	dec	hl
	ld	[hl], e
	ld	hl, sp+44
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	pop	af
	ld	a, e
	sbc	a, $00
	ld	e, a
	ld	a, d
	sbc	a, $00
	ld	hl, sp+34
	ld	[hl], a
	dec	hl
	ld	[hl], e
	ld	hl, sp+17
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	push	de
	ld	hl, sp+17
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	push	de
	ld	hl, sp+35
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	inc	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	__divulong
	ld	hl, sp+27
	ld	[hl], c
	inc	hl
	ld	[hl], b
	inc	hl
	ld	[hl], e
	inc	hl
	ld	[hl], d
	ld	hl, sp+24
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, e
	sub	a, $01
	ld	e, a
	ld	a, d
	sbc	a, $00
	push	af
	ld	hl, sp+34
	ld	[hl], a
	dec	hl
	ld	[hl], e
	ld	hl, sp+28
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	pop	af
	ld	a, e
	sbc	a, $00
	ld	e, a
	ld	a, d
	sbc	a, $00
	ld	hl, sp+34
	ld	[hl], a
	dec	hl
	ld	[hl], e
	ld	hl, sp+17
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	push	de
	ld	hl, sp+17
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	push	de
	ld	hl, sp+35
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	inc	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	__divulong
	ld	hl, sp+27
	ld	a, [hl]
	sub	a, c
	inc	hl
	ld	a, [hl]
	sbc	a, b
	inc	hl
	ld	a, [hl]
	sbc	a, e
	inc	hl
	ld	a, [hl]
	sbc	a, d
	jp	C, .l00116
;src/fatfs/lib/ff.c:4651: fp->fptr = (ifptr - 1) & ~(FSIZE_t)(bcs - 1);	/* start from the current cluster */
	ld	hl, sp+16
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, e
	sub	a, $01
	ld	e, a
	ld	a, d
	sbc	a, $00
	push	af
	ld	hl, sp+30
	ld	[hl], a
	dec	hl
	ld	[hl], e
	ld	hl, sp+20
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	pop	af
	ld	a, e
	sbc	a, $00
	ld	e, a
	ld	a, d
	sbc	a, $00
	ld	hl, sp+30
	ld	[hl], a
	dec	hl
	ld	[hl], e
	dec	hl
	dec	hl
	ld	a, [hl]
	cpl
	ld	c, a
	inc	hl
	ld	a, [hl]
	cpl
	ld	b, a
	inc	hl
	ld	a, [hl]
	cpl
	ld	e, a
	inc	hl
	ld	a, [hl]
	cpl
	ld	d, a
	inc	hl
	ld	a, [hl]
	and	a, c
	ld	hl, sp+27
	ld	[hl], a
	ld	hl, sp+32
	ld	a, [hl]
	and	a, b
	ld	hl, sp+28
	ld	[hl], a
	ld	hl, sp+33
	ld	a, [hl]
	and	a, e
	ld	hl, sp+29
	ld	[hl], a
	ld	hl, sp+34
	ld	a, [hl]
	and	a, d
	ld	hl, sp+30
	ld	[hl], a
	ld	hl, sp+10
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, sp+27
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
;src/fatfs/lib/ff.c:4652: ofs -= fp->fptr;
	ld	hl, sp+40
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, e
	ld	hl, sp+27
	sub	a, [hl]
	ld	e, a
	ld	a, d
	inc	hl
	sbc	a, [hl]
	push	af
	ld	hl, sp+42
	ld	[hl], a
	dec	hl
	ld	[hl], e
	ld	hl, sp+44
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, sp+31
	pop	af
	ld	a, e
	sbc	a, [hl]
	ld	e, a
	ld	a, d
	inc	hl
	sbc	a, [hl]
	ld	hl, sp+42
	ld	[hl], a
	dec	hl
	ld	[hl], e
;src/fatfs/lib/ff.c:4653: clst = fp->clust;
	ld	hl, sp+20
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
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
	inc	de
	ld	a, [de]
	inc	hl
	ld	[hl], a
	jp	.l00117
.l00116:
;src/fatfs/lib/ff.c:4655: clst = fp->obj.sclust;					/* start from the first cluster */
	ld	hl, sp+36
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $0006
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+35
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+34
	ld	[hl], a
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	ld	hl, sp+21
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
;src/fatfs/lib/ff.c:4657: if (clst == 0) {						/* If no cluster chain, create a new chain */
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	dec	hl
	or	a, [hl]
	dec	hl
	or	a, [hl]
	jp	NZ, .l00114
;src/fatfs/lib/ff.c:4658: clst = create_chain(&fp->obj, 0);
	ld	de, $0000
	push	de
	push	de
	ld	hl, sp+39
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_create_chain
	ld	hl, sp+21
	ld	[hl], c
	inc	hl
	ld	[hl], b
	inc	hl
	ld	[hl], e
	inc	hl
	ld	[hl], d
;src/fatfs/lib/ff.c:4659: if (clst == 1) ABORT(fs, FR_INT_ERR);
	ld	hl, sp+21
	ld	a, [hl]
	dec	a
	inc	hl
	or	a, [hl]
	inc	hl
	or	a, [hl]
	inc	hl
	or	a, [hl]
	jp	NZ,.l00264
	jp	.l00265
.l00264:
	jp	.l00110
.l00265:
	ld	hl, sp+3
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	ld	[hl], $02
	ld	a, $02
	jp	.l00149
.l00110:
;src/fatfs/lib/ff.c:4660: if (clst == 0xFFFFFFFF) ABORT(fs, FR_DISK_ERR);
	ld	hl, sp+21
	ld	a, [hl]
	inc	hl
	and	a, [hl]
	inc	hl
	and	a, [hl]
	inc	hl
	and	a, [hl]
	inc	a
	jp	NZ,.l00266
	jp	.l00267
.l00266:
	jp	.l00112
.l00267:
	ld	hl, sp+3
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	ld	[hl], $01
	ld	a, $01
	jp	.l00149
.l00112:
;src/fatfs/lib/ff.c:4661: fp->obj.sclust = clst;
	ld	hl, sp+34
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, sp+21
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
.l00114:
;src/fatfs/lib/ff.c:4664: fp->clust = clst;
	ld	hl, sp+20
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
	inc	de
	inc	hl
	ld	a, [hl]
	ld	[de], a
	inc	de
	inc	hl
	ld	a, [hl]
	ld	[de], a
.l00117:
;src/fatfs/lib/ff.c:4666: if (clst != 0) {
	ld	hl, sp+24
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	dec	hl
	or	a, [hl]
	dec	hl
	or	a, [hl]
	jp	Z, .l00145
;src/fatfs/lib/ff.c:4667: while (ofs > bcs) {						/* Cluster following loop */
	ld	hl, sp+7
	ld	a, [hl]
	ld	hl, sp+25
	ld	[hl], a
	ld	hl, sp+8
	ld	a, [hl]
	ld	hl, sp+26
	ld	[hl], a
.l00132:
	ld	hl, sp+15
	ld	e, l
	ld	d, h
	ld	hl, sp+39
	ld	a, [de]
	inc	de
	sub	a, [hl]
	inc	hl
	ld	a, [de]
	inc	de
	sbc	a, [hl]
	inc	hl
	ld	a, [de]
	inc	de
	sbc	a, [hl]
	inc	hl
	ld	a, [de]
	sbc	a, [hl]
	jp	NC, .l00134
;src/fatfs/lib/ff.c:4668: ofs -= bcs; fp->fptr += bcs;
	ld	hl, sp+40
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, e
	ld	hl, sp+15
	sub	a, [hl]
	ld	e, a
	ld	a, d
	inc	hl
	sbc	a, [hl]
	push	af
	ld	hl, sp+42
	ld	[hl], a
	dec	hl
	ld	[hl], e
	ld	hl, sp+44
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, sp+19
	pop	af
	ld	a, e
	sbc	a, [hl]
	ld	e, a
	ld	a, d
	inc	hl
	sbc	a, [hl]
	ld	hl, sp+42
	ld	[hl], a
	dec	hl
	ld	[hl], e
	ld	hl, sp+10
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	ld	hl, sp+27
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
	dec	hl
	dec	hl
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, e
	ld	hl, sp+15
	add	a, [hl]
	ld	e, a
	ld	a, d
	inc	hl
	adc	a, [hl]
	push	af
	ld	hl, sp+34
	ld	[hl], a
	dec	hl
	ld	[hl], e
	dec	hl
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, sp+19
	pop	af
	ld	a, e
	adc	a, [hl]
	ld	e, a
	ld	a, d
	inc	hl
	adc	a, [hl]
	ld	hl, sp+34
	ld	[hl], a
	dec	hl
	ld	[hl], e
	ld	hl, sp+10
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, sp+31
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
;src/fatfs/lib/ff.c:4670: if (fp->flag & FA_WRITE) {			/* Check if in write mode or not */
	ld	hl, sp+26
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	bit	1, a
	jp	NZ,.l00268
	jp	.l00125
.l00268:
;src/fatfs/lib/ff.c:4675: clst = create_chain(&fp->obj, clst);	/* Follow chain with forceed stretch */
	ld	hl, sp+23
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	push	de
	ld	hl, sp+23
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	push	de
	ld	hl, sp+39
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_create_chain
	ld	hl, sp+21
	ld	[hl], c
	inc	hl
	ld	[hl], b
	inc	hl
	ld	[hl], e
	inc	hl
	ld	[hl], d
;src/fatfs/lib/ff.c:4676: if (clst == 0) {				/* Clip file size in case of disk full */
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	dec	hl
	or	a, [hl]
	dec	hl
	or	a, [hl]
	jp	NZ, .l00126
;src/fatfs/lib/ff.c:4677: ofs = 0; break;
	xor	a, a
	ld	hl, sp+39
	ld	[hl], a
	inc	hl
	ld	[hl], a
	inc	hl
	ld	[hl], a
	inc	hl
	ld	[hl], a
	jp	.l00134
.l00125:
;src/fatfs/lib/ff.c:4682: clst = get_fat(&fp->obj, clst);	/* Follow cluster chain if not in write mode */
	ld	hl, sp+23
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	push	de
	ld	hl, sp+23
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	push	de
	ld	hl, sp+39
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_get_fat__far
	ld	hl, sp+21
	ld	[hl], c
	inc	hl
	ld	[hl], b
	inc	hl
	ld	[hl], e
	inc	hl
	ld	[hl], d
.l00126:
;src/fatfs/lib/ff.c:4684: if (clst == 0xFFFFFFFF) ABORT(fs, FR_DISK_ERR);
	ld	hl, sp+21
	ld	a, [hl]
	inc	hl
	and	a, [hl]
	inc	hl
	and	a, [hl]
	inc	hl
	and	a, [hl]
	inc	a
	jp	NZ,.l00269
	jp	.l00270
.l00269:
	jp	.l00128
.l00270:
	ld	hl, sp+3
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	ld	[hl], $01
	ld	a, $01
	jp	.l00149
.l00128:
;src/fatfs/lib/ff.c:4685: if (clst <= 1 || clst >= fs->n_fatent) ABORT(fs, FR_INT_ERR);
	ld	hl, sp+21
	ld	a, $01
	sub	a, [hl]
	inc	hl
	ld	a, $00
	sbc	a, [hl]
	inc	hl
	ld	a, $00
	sbc	a, [hl]
	inc	hl
	ld	a, $00
	sbc	a, [hl]
	jp	NC, .l00129
	pop	bc
	push	bc
	ld	hl, $0016
	add	hl, bc
	ld	e, l
	ld	d, h
	ld	a, [de]
	ld	hl, sp+31
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
	ld	hl, sp+21
	ld	e, l
	ld	d, h
	ld	hl, sp+31
	ld	a, [de]
	inc	de
	sub	a, [hl]
	inc	hl
	ld	a, [de]
	inc	de
	sbc	a, [hl]
	inc	hl
	ld	a, [de]
	inc	de
	sbc	a, [hl]
	inc	hl
	ld	a, [de]
	sbc	a, [hl]
	jp	C, .l00130
.l00129:
	ld	hl, sp+3
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	ld	[hl], $02
	ld	a, $02
	jp	.l00149
.l00130:
;src/fatfs/lib/ff.c:4686: fp->clust = clst;
	ld	hl, sp+20
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
	inc	de
	inc	hl
	ld	a, [hl]
	ld	[de], a
	inc	de
	inc	hl
	ld	a, [hl]
	ld	[de], a
	jp	.l00132
.l00134:
;src/fatfs/lib/ff.c:4688: fp->fptr += ofs;
	ld	hl, sp+10
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	ld	hl, sp+27
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
	dec	hl
	dec	hl
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, e
	ld	hl, sp+39
	add	a, [hl]
	ld	e, a
	ld	a, d
	inc	hl
	adc	a, [hl]
	push	af
	ld	hl, sp+34
	ld	[hl], a
	dec	hl
	ld	[hl], e
	dec	hl
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, sp+43
	pop	af
	ld	a, e
	adc	a, [hl]
	ld	e, a
	ld	a, d
	inc	hl
	adc	a, [hl]
	ld	hl, sp+34
	ld	[hl], a
	dec	hl
	ld	[hl], e
	ld	hl, sp+10
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, sp+31
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
;src/fatfs/lib/ff.c:4689: if (ofs % SS(fs)) {
	ld	hl, sp+39
	ld	a, [hl]
	or	a, a
	jp	NZ,.l00271
	push	hl
	inc	hl
	bit	0, [hl]
	pop	hl
	jp	NZ,.l00271
	jp	.l00145
.l00271:
;src/fatfs/lib/ff.c:4690: nsect = clst2sect(fs, clst);	/* Current sector */
	ld	hl, sp+23
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	push	de
	ld	hl, sp+23
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	push	de
	ld	hl, sp+4
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_clst2sect__far
	ld	hl, sp+31
	ld	[hl], c
	inc	hl
	ld	[hl], b
	inc	hl
	ld	[hl], e
	inc	hl
	ld	[hl], d
;src/fatfs/lib/ff.c:4691: if (nsect == 0) ABORT(fs, FR_INT_ERR);
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	dec	hl
	or	a, [hl]
	dec	hl
	or	a, [hl]
	jp	NZ, .l00136
	ld	hl, sp+3
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	ld	[hl], $02
	ld	a, $02
	jp	.l00149
.l00136:
;src/fatfs/lib/ff.c:4692: nsect += (DWORD)(ofs / SS(fs));
	ld	hl, sp+40
	ld	a, [hl]
	ld	hl, sp+27
	ld	[hl], a
	ld	hl, sp+41
	ld	a, [hl]
	ld	hl, sp+28
	ld	[hl], a
	ld	hl, sp+42
	ld	a, [hl]
	ld	hl, sp+29
	ld	[hl], a
	inc	hl
	ld	[hl], $00
	dec	hl
	srl	[hl]
	dec	hl
	rr	[hl]
	dec	hl
	rr	[hl]
	ld	hl, sp+32
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, e
	ld	hl, sp+27
	add	a, [hl]
	ld	e, a
	ld	a, d
	inc	hl
	adc	a, [hl]
	push	af
	ld	hl, sp+14
	ld	[hl], a
	dec	hl
	ld	[hl], e
	ld	hl, sp+36
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, sp+31
	pop	af
	ld	a, e
	adc	a, [hl]
	ld	e, a
	ld	a, d
	inc	hl
	adc	a, [hl]
	ld	hl, sp+14
	ld	[hl], a
	dec	hl
	ld	[hl], e
;src/fatfs/lib/ff.c:4696: if (!FF_FS_READONLY && fp->fptr > fp->obj.objsize) {	/* Set file change flag if the file size is extended */
.l00145:
	ld	hl, sp+10
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	ld	hl, sp+27
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
	ld	hl, sp+6
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	ld	hl, sp+31
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
	ld	hl, sp+31
	ld	e, l
	ld	d, h
	ld	hl, sp+27
	ld	a, [de]
	inc	de
	sub	a, [hl]
	inc	hl
	ld	a, [de]
	inc	de
	sbc	a, [hl]
	inc	hl
	ld	a, [de]
	inc	de
	sbc	a, [hl]
	inc	hl
	ld	a, [de]
	sbc	a, [hl]
	jp	NC, .l00144
;src/fatfs/lib/ff.c:4697: fp->obj.objsize = fp->fptr;
	ld	hl, sp+6
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, sp+27
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
;src/fatfs/lib/ff.c:4698: fp->flag |= FA_MODIFIED;
	ld	hl, sp+8
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	ld	c, a
	set	6, c
	dec	hl
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	ld	[hl], c
.l00144:
;src/fatfs/lib/ff.c:4700: if (fp->fptr % SS(fs) && nsect != fp->sect) {	/* Fill sector cache if needed */
	ld	hl, sp+10
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	ld	c, a
	inc	de
	ld	a, [de]
	ld	b, a
	inc	de
	ld	a, [de]
	ld	l, a
;	spillPairReg hl
;	spillPairReg hl
	inc	de
	ld	a, [de]
	ld	h, a
;	spillPairReg hl
;	spillPairReg hl
	ld	a, c
	or	a, a
	jp	NZ,.l00274
	bit	0, b
	jp	NZ,.l00274
	jp	.l00147
.l00274:
	ld	hl, sp+36
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $0018
	add	hl, de
	ld	c, l
	ld	b, h
	ld	e, c
	ld	d, b
	ld	a, [de]
	ld	hl, sp+31
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
	ld	hl, sp+11
	ld	a, [hl]
	ld	hl, sp+31
	sub	a, [hl]
	jp	NZ,.l00275
	ld	hl, sp+12
	ld	a, [hl]
	ld	hl, sp+32
	sub	a, [hl]
	jp	NZ,.l00275
	ld	hl, sp+13
	ld	a, [hl]
	ld	hl, sp+33
	sub	a, [hl]
	jp	NZ,.l00275
	ld	hl, sp+14
	ld	a, [hl]
	ld	hl, sp+34
	sub	a, [hl]
	jp	NZ,.l00275
	jp	.l00147
.l00275:
;src/fatfs/lib/ff.c:4710: fp->sect = nsect;
	ld	hl, sp+11
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
.l00147:
;src/fatfs/lib/ff.c:4714: LEAVE_FF(fs, res);
	ld	hl, sp+2
	ld	a, [hl]
.l00149:
;src/fatfs/lib/ff.c:4715: }
	add	sp, 37
	pop	hl
	add	sp, 4
	jp hl 
;src/fatfs/lib/ff.c:4724: FRESULT f_opendir (
;	---------------------------------
	SECTION FRAGMENT "src/fatfs/fatfs.c A",ROMX
; Function f_opendir
; ---------------------------------
_f_opendir::
	add	sp, -13
	ld	hl, sp+11
	ld	[hl], e
	inc	hl
	ld	[hl], d
	ld	hl, sp+9
	ld	[hl], c
	inc	hl
	ld	[hl], b
;src/fatfs/lib/ff.c:4734: if (!dp) return FR_INVALID_OBJECT;	/* Reject null pointer */
	inc	hl
	inc	hl
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	jp	NZ, .l00102
	ld	a, $09
	jp	.l00118
.l00102:
;src/fatfs/lib/ff.c:4736: res = mount_volume(&path, &fs, 0);	/* Get logical drive and mount the volume if needed */
	xor	a, a
	push	af
	inc	sp
	ld	hl, 1
	add	hl, sp
	ld	c, l
	ld	b, h
	ld	hl, 10
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_mount_volume__far
	ld	hl, sp+2
	ld	[hl], a
;src/fatfs/lib/ff.c:4737: if (res == FR_OK) {
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00115
;src/fatfs/lib/ff.c:4738: dp->obj.fs = fs;
	ld	hl, sp+12
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, sp+0
	ld	a, [hl]
	ld	[de], a
	inc	de
	inc	hl
	ld	a, [hl]
	ld	[de], a
;src/fatfs/lib/ff.c:4740: res = follow_path(dp, path);			/* Follow the path to the directory */
	ld	hl, sp+9
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	inc	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_follow_path
	ld	hl, sp+2
	ld	[hl], a
;src/fatfs/lib/ff.c:4741: if (res == FR_OK) {						/* Follow completed */
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00111
;src/fatfs/lib/ff.c:4742: if (!(dp->fn[NSFLAG] & NS_NONAME)) {	/* It is neither the origin directory itself nor dot name in exFAT */
	ld	hl, sp+12
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $001C
	add	hl, de
	ld	c, l
	ld	b, h
	ld	hl, $000B
	add	hl, bc
	ld	a, [hl]
	rlca
	jp	C,.l00160
	jp	.l00161
.l00160:
	jp	.l00107
.l00161:
;src/fatfs/lib/ff.c:4743: if (dp->obj.attr & AM_DIR) {		/* This object is a sub-directory */
	ld	hl, sp+12
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $0004
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, [bc]
	bit	4, a
	jp	NZ,.l00162
	jp	.l00104
.l00162:
;src/fatfs/lib/ff.c:4750: dp->obj.sclust = ld_clust(fs, dp->dir);	/* Get object allocation info */
	ld	hl, sp+12
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $0006
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+5
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+4
	ld	[hl], a
	ld	hl, sp+12
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $001A
	add	hl, de
	ld	c, l
	ld	b, h
	ld	l, c
	ld	h, b
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	pop	de
	push	de
	call	_ld_clust__far
	ld	hl, sp+5
	ld	[hl], c
	inc	hl
	ld	[hl], b
	inc	hl
	ld	[hl], e
	inc	hl
	ld	[hl], d
	ld	hl, sp+4
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
	inc	de
	inc	hl
	ld	a, [hl]
	ld	[de], a
	inc	de
	inc	hl
	ld	a, [hl]
	ld	[de], a
	jp	.l00107
.l00104:
;src/fatfs/lib/ff.c:4753: res = FR_NO_PATH;
	ld	hl, sp+2
	ld	[hl], $05
.l00107:
;src/fatfs/lib/ff.c:4756: if (res == FR_OK) {
	ld	hl, sp+2
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00111
;src/fatfs/lib/ff.c:4757: dp->obj.id = fs->id;		/* Set current volume mount ID */
	ld	hl, sp+12
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $0002
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+7
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+6
	ld	[hl], a
	pop	bc
	push	bc
	ld	hl, $0006
	add	hl, bc
	ld	e, l
	ld	d, h
	ld	a, [de]
	ld	hl, sp+7
	ld	[hl], a
	inc	de
	ld	a, [de]
	inc	hl
	ld	[hl], a
	ld	hl, sp+6
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
;src/fatfs/lib/ff.c:4758: res = dir_sdi(dp, 0);		/* Rewind directory */
	ld	de, $0000
	push	de
	push	de
	ld	hl, sp+15
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_dir_sdi
	ld	hl, sp+2
	ld	[hl], a
.l00111:
;src/fatfs/lib/ff.c:4772: if (res == FR_NO_FILE) res = FR_NO_PATH;
	ld	hl, sp+2
	ld	a, [hl]
	sub	a, $04
	jp	NZ,.l00163
	jp	.l00164
.l00163:
	jp	.l00115
.l00164:
	ld	hl, sp+2
	ld	[hl], $05
.l00115:
;src/fatfs/lib/ff.c:4774: if (res != FR_OK) dp->obj.fs = 0;		/* Invalidate the directory object if function failed */
	ld	hl, sp+2
	ld	a, [hl]
	or	a, a
	jp	Z, .l00117
	ld	hl, sp+11
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	xor	a, a
	ld	[hl], a
	inc	hl
	ld	[hl], a
.l00117:
;src/fatfs/lib/ff.c:4776: LEAVE_FF(fs, res);
	ld	hl, sp+2
	ld	a, [hl]
.l00118:
;src/fatfs/lib/ff.c:4777: }
	add	sp, 13
	ret
;src/fatfs/lib/ff.c:4786: FRESULT f_closedir (
;	---------------------------------
	SECTION FRAGMENT "src/fatfs/fatfs.c A",ROMX
; Function f_closedir
; ---------------------------------
_f_closedir::
	dec	sp
	dec	sp
;src/fatfs/lib/ff.c:4794: res = validate(&dp->obj, &fs);	/* Check validity of the file object */
	ld	hl, sp+0
	ld	c, l
	ld	b, h
	push	de
	call	_validate
	pop	de
	ld	c, a
;src/fatfs/lib/ff.c:4795: if (res == FR_OK) {
	or	a, a
	jp	NZ, .l00102
;src/fatfs/lib/ff.c:4800: dp->obj.fs = 0;	/* Invalidate directory object */
	xor	a, a
	ld	[de], a
	inc	de
	ld	[de], a
.l00102:
;src/fatfs/lib/ff.c:4806: return res;
	ld	a, c
.l00103:
;src/fatfs/lib/ff.c:4807: }
	inc	sp
	inc	sp
	ret
;src/fatfs/lib/ff.c:4816: FRESULT f_readdir (
;	---------------------------------
	SECTION FRAGMENT "src/fatfs/fatfs.c A",ROMX
; Function f_readdir
; ---------------------------------
_f_readdir::
	add	sp, -4
	ld	hl, sp+2
	ld	[hl], e
	inc	hl
	ld	[hl], d
	ld	e, c
	ld	d, b
;src/fatfs/lib/ff.c:4826: res = validate(&dp->obj, &fs);	/* Check validity of the directory object */
	ld	hl, sp+0
	ld	c, l
	ld	b, h
	push	de
	ld	hl, sp+4
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_validate
	pop	de
	ld	c, a
;src/fatfs/lib/ff.c:4832: fno->fname[0] = 0;				/* Clear file information */
	ld	hl, $0016
	add	hl, de
;src/fatfs/lib/ff.c:4827: if (res == FR_OK) {
	ld	a, c
	or	a, a
	jp	NZ, .l00111
;src/fatfs/lib/ff.c:4828: if (!fno) {
	ld	a, d
	or	a, e
	jp	NZ, .l00108
;src/fatfs/lib/ff.c:4829: res = dir_sdi(dp, 0);		/* Rewind the directory object */
	push	hl
	push	de
	ld	bc, $0000
	push	bc
	push	bc
	push	hl
	ld	hl, sp+12
	ld	e, [hl]
	pop	hl
	push	hl
	ld	hl, sp+13
	ld	d, [hl]
	pop	hl
	call	_dir_sdi
	pop	de
	pop	hl
	ld	c, a
	jp	.l00111
.l00108:
;src/fatfs/lib/ff.c:4832: fno->fname[0] = 0;				/* Clear file information */
	ld	[hl], $00
;src/fatfs/lib/ff.c:4833: res = DIR_READ_FILE(dp);		/* Read an item */
	push	hl
	push	de
	ld	bc, $0000
	push	hl
	ld	hl, sp+8
	ld	e, [hl]
	pop	hl
	push	hl
	ld	hl, sp+9
	ld	d, [hl]
	pop	hl
	call	_dir_read
	pop	de
	pop	hl
	ld	c, a
;src/fatfs/lib/ff.c:4834: if (res == FR_NO_FILE) res = FR_OK;	/* Ignore end of directory */
	ld	a, c
	sub	a, $04
	jp	NZ,.l00152
	jp	.l00153
.l00152:
	jp	.l00102
.l00153:
	ld	c, $00
.l00102:
;src/fatfs/lib/ff.c:4835: if (res == FR_OK) {				/* A valid entry is found */
	ld	a, c
	or	a, a
	jp	NZ, .l00111
;src/fatfs/lib/ff.c:4836: get_fileinfo(dp, fno);		/* Get the object information */
	push	hl
	push	de
	ld	c, e
	ld	b, d
	push	hl
	ld	hl, sp+8
	ld	e, [hl]
	pop	hl
	push	hl
	ld	hl, sp+9
	ld	d, [hl]
	pop	hl
	call	_get_fileinfo__far
	pop	de
	pop	hl
;src/fatfs/lib/ff.c:4837: res = dir_next(dp, 0);		/* Increment index for next */
	push	hl
	push	de
	ld	bc, $0000
	push	hl
	ld	hl, sp+8
	ld	e, [hl]
	pop	hl
	push	hl
	ld	hl, sp+9
	ld	d, [hl]
	pop	hl
	call	_dir_next
	pop	de
	pop	hl
	ld	c, a
;src/fatfs/lib/ff.c:4838: if (res == FR_NO_FILE) res = FR_OK;	/* Ignore end of directory now */
	ld	a, c
	sub	a, $04
	jp	NZ,.l00154
	jp	.l00155
.l00154:
	jp	.l00111
.l00155:
	ld	c, $00
.l00111:
;src/fatfs/lib/ff.c:4844: if (fno && res != FR_OK) fno->fname[0] = 0;	/* Clear the file information if any error occured */
	ld	a, d
	or	a, e
	jp	Z, .l00113
	ld	a, c
	or	a, a
	jp	Z, .l00113
	ld	[hl], $00
.l00113:
;src/fatfs/lib/ff.c:4845: LEAVE_FF(fs, res);
	ld	a, c
.l00115:
;src/fatfs/lib/ff.c:4846: }
	add	sp, 4
	ret
;src/fatfs/lib/ffunicode.c:10447: static WCHAR oem2uni_sbcs (	/* Returns Unicode character in UTF-16, zero on error */
;	---------------------------------
	SECTION FRAGMENT "src/fatfs/fatfs.c A",ROMX
; Function oem2uni_sbcs
; ---------------------------------
_oem2uni_sbcs:
	add	sp, -4
	inc	sp
	inc	sp
	push	de
;src/fatfs/lib/ffunicode.c:10452: const WCHAR* tbl = 0;
	ld	de, $0000
;src/fatfs/lib/ffunicode.c:10453: WCHAR uni = 0;
	xor	a, a
	ld	hl, sp+2
	ld	[hl], a
	inc	hl
	ld	[hl], a
;src/fatfs/lib/ffunicode.c:10460: if (cp == FF_CODE_PAGE) tbl = CVTBL(uc, FF_CODE_PAGE);	/* Conversion table */
	ld	a, c
	sub	a, $B5
	jp	NZ,.l00123
	dec	b
	jp	NZ,.l00123
	jp	.l00124
.l00123:
	jp	.l00102
.l00124:
	ld	de, _uc437
.l00102:
;src/fatfs/lib/ffunicode.c:10462: oem -= 0x80;
	ld	hl, sp+0
	ld	a, [hl]
	inc	hl
	ld	c, [hl]
	add	a, $80
	ld	l, a
;	spillPairReg hl
;	spillPairReg hl
	ld	a, c
	adc	a, $FF
	ld	h, a
;	spillPairReg hl
;	spillPairReg hl
;src/fatfs/lib/ffunicode.c:10463: if (tbl && oem < 0x80) uni = tbl[oem];	/* Table conversion */
	ld	a, d
	or	a, e
	jp	Z, .l00104
	ld	c, l
	ld	b, h
	ld	a, c
	sub	a, $80
	ld	a, b
	sbc	a, $00
	jp	NC, .l00104
	add	hl, hl
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
.l00104:
;src/fatfs/lib/ffunicode.c:10464: return uni;
	pop	hl
	pop	bc
	push	bc
	push	hl
.l00106:
;src/fatfs/lib/ffunicode.c:10465: }
	add	sp, 4
	ret
	SECTION FRAGMENT "src/fatfs/fatfs.c ROM0",ROM0
_uc437:
	DW $00C7
	DW $00FC
	DW $00E9
	DW $00E2
	DW $00E4
	DW $00E0
	DW $00E5
	DW $00E7
	DW $00EA
	DW $00EB
	DW $00E8
	DW $00EF
	DW $00EE
	DW $00EC
	DW $00C4
	DW $00C5
	DW $00C9
	DW $00E6
	DW $00C6
	DW $00F4
	DW $00F6
	DW $00F2
	DW $00FB
	DW $00F9
	DW $00FF
	DW $00D6
	DW $00DC
	DW $00A2
	DW $00A3
	DW $00A5
	DW $20A7
	DW $0192
	DW $00E1
	DW $00ED
	DW $00F3
	DW $00FA
	DW $00F1
	DW $00D1
	DW $00AA
	DW $00BA
	DW $00BF
	DW $2310
	DW $00AC
	DW $00BD
	DW $00BC
	DW $00A1
	DW $00AB
	DW $00BB
	DW $2591
	DW $2592
	DW $2593
	DW $2502
	DW $2524
	DW $2561
	DW $2562
	DW $2556
	DW $2555
	DW $2563
	DW $2551
	DW $2557
	DW $255D
	DW $255C
	DW $255B
	DW $2510
	DW $2514
	DW $2534
	DW $252C
	DW $251C
	DW $2500
	DW $253C
	DW $255E
	DW $255F
	DW $255A
	DW $2554
	DW $2569
	DW $2566
	DW $2560
	DW $2550
	DW $256C
	DW $2567
	DW $2568
	DW $2564
	DW $2565
	DW $2559
	DW $2558
	DW $2552
	DW $2553
	DW $256B
	DW $256A
	DW $2518
	DW $250C
	DW $2588
	DW $2584
	DW $258C
	DW $2590
	DW $2580
	DW $03B1
	DW $00DF
	DW $0393
	DW $03C0
	DW $03A3
	DW $03C3
	DW $00B5
	DW $03C4
	DW $03A6
	DW $0398
	DW $03A9
	DW $03B4
	DW $221E
	DW $03C6
	DW $03B5
	DW $2229
	DW $2261
	DW $00B1
	DW $2265
	DW $2264
	DW $2320
	DW $2321
	DW $00F7
	DW $2248
	DW $00B0
	DW $2219
	DW $00B7
	DW $221A
	DW $207F
	DW $00B2
	DW $25A0
	DW $00A0
;src/fatfs/lib/ffunicode.c:10470: static WCHAR uni2oem_sbcs (	/* Returns OEM code character, zero on error */
;	---------------------------------
	SECTION FRAGMENT "src/fatfs/fatfs.c A",ROMX
; Function uni2oem_sbcs
; ---------------------------------
_uni2oem_sbcs:
	add	sp, -8
	ld	hl, sp+2
	ld	[hl], c
	inc	hl
	ld	[hl], b
	inc	hl
	ld	[hl], e
	inc	hl
	ld	[hl], d
;src/fatfs/lib/ffunicode.c:10475: const WCHAR* tbl = 0;
	xor	a, a
	ld	hl, sp+0
	ld	[hl], a
	inc	hl
	ld	[hl], a
;src/fatfs/lib/ffunicode.c:10476: WCHAR oem = 0;
	xor	a, a
	ld	hl, sp+6
	ld	[hl], a
	inc	hl
	ld	[hl], a
;src/fatfs/lib/ffunicode.c:10484: if (cp == FF_CODE_PAGE) tbl = CVTBL(uc, FF_CODE_PAGE);	/* Conversion table */
	ld	hl, sp+10
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	ld	a, c
	sub	a, $B5
	jp	NZ,.l00138
	dec	b
	jp	NZ,.l00138
	jp	.l00139
.l00138:
	jp	.l00102
.l00139:
	ld	hl, sp+0
	ld	a, LOW(_uc437)
	ld	[hl], a
	inc	hl
	ld	a, HIGH(_uc437)
	ld	[hl], a
.l00102:
;src/fatfs/lib/ffunicode.c:10486: if (tbl) {	/* Is it a valid code page? */
	ld	hl, sp+1
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	jp	Z, .l00105
;src/fatfs/lib/ffunicode.c:10487: for (i = 0; i < 0x80 && uni != tbl[i]; i++) ;	/* Incremental search */
	xor	a, a
	ld	hl, sp+6
	ld	[hl], a
	inc	hl
	ld	[hl], a
.l00108:
	ld	hl, sp+6
	ld	a, [hl]
	sub	a, $80
	inc	hl
	ld	a, [hl]
	sbc	a, $00
	jp	NC, .l00103
	dec	hl
	ld	a, [hl]
	inc	hl
	ld	d, [hl]
	add	a, a
	rl	d
	ld	e, a
	pop	hl
	push	hl
	add	hl, de
	ld	c, l
	ld	b, h
	ld	l, c
	ld	h, b
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	ld	de, $0000
	ld	hl, sp+2
	ld	a, [hl]
	sub	a, c
	jp	NZ,.l00141
	inc	hl
	ld	a, [hl]
	sub	a, b
	jp	NZ,.l00141
	inc	hl
	ld	a, [hl]
	sub	a, e
	jp	NZ,.l00141
	inc	hl
	ld	a, [hl]
	sub	a, d
	jp	NZ,.l00141
	jp	.l00103
.l00141:
	ld	hl, sp+6
	inc	[hl]
	jp	NZ, .l00142
	inc	hl
	inc	[hl]
.l00142:
	jp	.l00108
.l00103:
;src/fatfs/lib/ffunicode.c:10488: oem = (i + 0x80) & 0xFF;
	ld	hl, sp+7
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $0080
	add	hl, de
	inc	sp
	inc	sp
	push	hl
	ld	hl, sp+0
	ld	a, [hl]
	ld	hl, sp+6
	ld	[hl], a
	inc	hl
	ld	[hl], $00
.l00105:
;src/fatfs/lib/ffunicode.c:10490: return oem;
	ld	hl, sp+6
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
.l00110:
;src/fatfs/lib/ffunicode.c:10491: }
	add	sp, 8
	pop	hl
	inc	sp
	inc	sp
	jp hl 
;src/fatfs/lib/ffunicode.c:10735: WCHAR ff_uni2oem (	/* Returns OEM code character, zero on error */
;	---------------------------------
	SECTION FRAGMENT "src/fatfs/fatfs.c C",ROMX
; Function ff_uni2oem
; ---------------------------------
_ff_uni2oem::
;src/fatfs/lib/ffunicode.c:10740: if (uni < 0x80) return (WCHAR)uni;	/* ASCII: pass-through */
	ld	a, c
	sub	a, $80
	ld	a, b
	sbc	a, $00
	ld	a, e
	sbc	a, $00
	ld	a, d
	sbc	a, $00
	jp	NC, .l00102
	jp	.l00105
.l00102:
;src/fatfs/lib/ffunicode.c:10741: if (uni >= 0x10000) return 0;		/* Surrogate pair: error */
	ld	a, e
	sub	a, $01
	ld	a, d
	sbc	a, $00
	jp	C, .l00104
	ld	bc, $0000
	jp	.l00105
.l00104:
;src/fatfs/lib/ffunicode.c:10745: return uni2oem_sbcs(uni, cp);
	ld	hl, sp+2
	ld	a, [hl]
	inc	hl
	ld	h, [hl]
;	spillPairReg hl
;	spillPairReg hl
	ld	l, a
;	spillPairReg hl
;	spillPairReg hl
	push	hl
	call	_uni2oem_sbcs__far
.l00105:
;src/fatfs/lib/ffunicode.c:10749: }
	pop	hl
	inc	sp
	inc	sp
	jp hl 
;src/fatfs/lib/ffunicode.c:10758: WCHAR ff_oem2uni (	/* Returns Unicode character in UTF-16, zero on error */
;	---------------------------------
	SECTION FRAGMENT "src/fatfs/fatfs.c C",ROMX
; Function ff_oem2uni
; ---------------------------------
_ff_oem2uni::
;src/fatfs/lib/ffunicode.c:10763: if (oem < 0x80) return oem;	/* ASCII: pass-through */
	ld	l, e
;	spillPairReg hl
;	spillPairReg hl
	ld	h, d
;	spillPairReg hl
;	spillPairReg hl
	ld	a, l
	sub	a, $80
	ld	a, h
	sbc	a, $00
	jp	NC, .l00102
	ld	c, e
	ld	b, d
	jp	.l00103
.l00102:
;src/fatfs/lib/ffunicode.c:10767: return oem2uni_sbcs(oem, cp);
	jp	_oem2uni_sbcs__far
.l00103:
;src/fatfs/lib/ffunicode.c:10771: }
	ret
;src/fatfs/lib/ffunicode.c:10780: DWORD ff_wtoupper (	/* Returns up-converted code point */
;	---------------------------------
	SECTION FRAGMENT "src/fatfs/fatfs.c C",ROMX
; Function ff_wtoupper
; ---------------------------------
_ff_wtoupper::
	add	sp, -10
;src/fatfs/lib/ffunicode.c:10879: if (uni < 0x10000) {	/* Is it in BMP? */
	ld	a, e
	sub	a, $01
	ld	a, d
	sbc	a, $00
	jp	NC, .l00120
;src/fatfs/lib/ffunicode.c:10880: uc = (WORD)uni;
;src/fatfs/lib/ffunicode.c:10881: p = uc < 0x1000 ? cvt1 : cvt2;
	inc	sp
	inc	sp
	push	bc
	ld	hl, sp+0
	ld	a, [hl]
	sub	a, $00
	inc	hl
	ld	a, [hl]
	sbc	a, $10
	jp	NC, .l00125
	ld	de, _ff_wtoupper_cvt1_65536_458+0
	jp	.l00126
.l00125:
	ld	de, _ff_wtoupper_cvt2_65536_458+0
.l00126:
	ld	hl, sp+8
	ld	[hl], e
	inc	hl
	ld	[hl], d
.l00121:
;src/fatfs/lib/ffunicode.c:10883: bc = *p++;								/* Get the block base */
	ld	hl, sp+9
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
	ld	hl, sp+9
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $0002
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+6
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+5
	ld	[hl], a
;src/fatfs/lib/ffunicode.c:10884: if (bc == 0 || uc < bc) break;			/* Not matched? */
	dec	hl
	dec	hl
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	jp	Z, .l00118
	ld	a, c
	sub	a, [hl]
	inc	hl
	ld	a, b
	sbc	a, [hl]
	jp	C, .l00118
;src/fatfs/lib/ffunicode.c:10885: nc = *p++; cmd = nc >> 8; nc &= 0xFF;	/* Get processing command and block size */
	ld	hl, sp+5
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
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
	ld	hl, $0002
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
	dec	hl
	ld	a, [hl]
	ld	hl, sp+4
	ld	[hl], a
	inc	hl
	ld	[hl], $00
	inc	hl
	ld	a, [hl]
	inc	hl
	ld	e, [hl]
	ld	e, $00
	dec	hl
	ld	[hl], a
	inc	hl
	ld	[hl], e
;src/fatfs/lib/ffunicode.c:10886: if (uc < bc + nc) {	/* In the block? */
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, sp+2
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	add	hl, de
	ld	e, l
	ld	d, h
	ld	a, c
	sub	a, e
	ld	a, b
	sbc	a, d
	jp	NC, .l00115
;src/fatfs/lib/ffunicode.c:10887: switch (cmd) {
	ld	hl, sp+4
	ld	a, $08
	sub	a, [hl]
	inc	hl
	ld	a, $00
	sbc	a, [hl]
	jp	C, .l00118
	ld	hl, sp+4
	ld	e, [hl]
	ld	d, $00
	ld	hl, .l00167
	add	hl, de
	add	hl, de
	add	hl, de
	jp	hl
.l00167:
	jp	.l00104
	jp	.l00105
	jp	.l00106
	jp	.l00107
	jp	.l00108
	jp	.l00109
	jp	.l00110
	jp	.l00111
	jp	.l00112
;src/fatfs/lib/ffunicode.c:10888: case 0:	uc = p[uc - bc]; break;		/* Table conversion */
.l00104:
	ld	hl, sp+3
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, c
	sub	a, e
	ld	e, a
	ld	a, b
	sbc	a, d
	ld	c, e
	ld	b, a
	sla	c
	rl	b
	ld	hl, sp+8
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	add	hl, bc
	ld	c, l
	ld	b, h
	ld	l, c
	ld	h, b
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	jp	.l00118
;src/fatfs/lib/ffunicode.c:10889: case 1:	uc -= (uc - bc) & 1; break;	/* Case pairs */
.l00105:
	ld	hl, sp+3
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, c
	sub	a, e
	ld	e, a
	ld	a, b
	sbc	a, d
	ld	c, e
	ld	b, a
	ld	a, c
	and	a, $01
	ld	c, a
	ld	b, $00
	pop	de
	push	de
	ld	a, e
	sub	a, c
	ld	e, a
	ld	a, d
	sbc	a, b
	ld	c, e
	ld	b, a
	jp	.l00118
;src/fatfs/lib/ffunicode.c:10890: case 2: uc -= 16; break;			/* Shift -16 */
.l00106:
	pop	de
	push	de
	ld	hl, $0010
	ld	a, e
	sub	a, l
	ld	e, a
	ld	a, d
	sbc	a, h
	ld	c, e
	ld	b, a
	jp	.l00118
;src/fatfs/lib/ffunicode.c:10891: case 3:	uc -= 32; break;			/* Shift -32 */
.l00107:
	pop	de
	push	de
	ld	hl, $0020
	ld	a, e
	sub	a, l
	ld	e, a
	ld	a, d
	sbc	a, h
	ld	c, e
	ld	b, a
	jp	.l00118
;src/fatfs/lib/ffunicode.c:10892: case 4:	uc -= 48; break;			/* Shift -48 */
.l00108:
	pop	de
	push	de
	ld	hl, $0030
	ld	a, e
	sub	a, l
	ld	e, a
	ld	a, d
	sbc	a, h
	ld	c, e
	ld	b, a
	jp	.l00118
;src/fatfs/lib/ffunicode.c:10893: case 5:	uc -= 26; break;			/* Shift -26 */
.l00109:
	pop	de
	push	de
	ld	hl, $001A
	ld	a, e
	sub	a, l
	ld	e, a
	ld	a, d
	sbc	a, h
	ld	c, e
	ld	b, a
	jp	.l00118
;src/fatfs/lib/ffunicode.c:10894: case 6:	uc += 8; break;				/* Shift +8 */
.l00110:
	pop	de
	push	de
	ld	hl, $0008
	add	hl, de
	ld	c, l
	ld	b, h
	jp	.l00118
;src/fatfs/lib/ffunicode.c:10895: case 7: uc -= 80; break;			/* Shift -80 */
.l00111:
	pop	de
	push	de
	ld	hl, $0050
	ld	a, e
	sub	a, l
	ld	e, a
	ld	a, d
	sbc	a, h
	ld	c, e
	ld	b, a
	jp	.l00118
;src/fatfs/lib/ffunicode.c:10896: case 8:	uc -= 0x1C60; break;		/* Shift -0x1C60 */
.l00112:
	pop	de
	push	de
	ld	hl, $1C60
	ld	a, e
	sub	a, l
	ld	e, a
	ld	a, d
	sbc	a, h
	ld	c, e
	ld	b, a
;src/fatfs/lib/ffunicode.c:10898: break;
	jp	.l00118
.l00115:
;src/fatfs/lib/ffunicode.c:10900: if (cmd == 0) p += nc;	/* Skip table if needed */
	ld	hl, sp+5
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	jp	NZ, .l00121
	inc	hl
	inc	hl
	ld	a, [hl]
	inc	hl
	ld	d, [hl]
	add	a, a
	rl	d
	ld	e, a
	inc	hl
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+10
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+9
	ld	[hl], a
	jp	.l00121
.l00118:
;src/fatfs/lib/ffunicode.c:10902: uni = uc;
	ld	de, $0000
.l00120:
;src/fatfs/lib/ffunicode.c:10905: return uni;
.l00123:
;src/fatfs/lib/ffunicode.c:10906: }
	add	sp, 10
	ret
	SECTION FRAGMENT "src/fatfs/fatfs.c ROM0",ROM0
_ff_wtoupper_cvt1_65536_458:
	DW $0061
	DW $031A
	DW $00E0
	DW $0317
	DW $00F8
	DW $0307
	DW $00FF
	DW $0001
	DW $0178
	DW $0100
	DW $0130
	DW $0132
	DW $0106
	DW $0139
	DW $0110
	DW $014A
	DW $012E
	DW $0179
	DW $0106
	DW $0180
	DW $004D
	DW $0243
	DW $0181
	DW $0182
	DW $0182
	DW $0184
	DW $0184
	DW $0186
	DW $0187
	DW $0187
	DW $0189
	DW $018A
	DW $018B
	DW $018B
	DW $018D
	DW $018E
	DW $018F
	DW $0190
	DW $0191
	DW $0191
	DW $0193
	DW $0194
	DW $01F6
	DW $0196
	DW $0197
	DW $0198
	DW $0198
	DW $023D
	DW $019B
	DW $019C
	DW $019D
	DW $0220
	DW $019F
	DW $01A0
	DW $01A0
	DW $01A2
	DW $01A2
	DW $01A4
	DW $01A4
	DW $01A6
	DW $01A7
	DW $01A7
	DW $01A9
	DW $01AA
	DW $01AB
	DW $01AC
	DW $01AC
	DW $01AE
	DW $01AF
	DW $01AF
	DW $01B1
	DW $01B2
	DW $01B3
	DW $01B3
	DW $01B5
	DW $01B5
	DW $01B7
	DW $01B8
	DW $01B8
	DW $01BA
	DW $01BB
	DW $01BC
	DW $01BC
	DW $01BE
	DW $01F7
	DW $01C0
	DW $01C1
	DW $01C2
	DW $01C3
	DW $01C4
	DW $01C5
	DW $01C4
	DW $01C7
	DW $01C8
	DW $01C7
	DW $01CA
	DW $01CB
	DW $01CA
	DW $01CD
	DW $0110
	DW $01DD
	DW $0001
	DW $018E
	DW $01DE
	DW $0112
	DW $01F3
	DW $0003
	DW $01F1
	DW $01F4
	DW $01F4
	DW $01F8
	DW $0128
	DW $0222
	DW $0112
	DW $023A
	DW $0009
	DW $2C65
	DW $023B
	DW $023B
	DW $023D
	DW $2C66
	DW $023F
	DW $0240
	DW $0241
	DW $0241
	DW $0246
	DW $010A
	DW $0253
	DW $0040
	DW $0181
	DW $0186
	DW $0255
	DW $0189
	DW $018A
	DW $0258
	DW $018F
	DW $025A
	DW $0190
	DW $025C
	DW $025D
	DW $025E
	DW $025F
	DW $0193
	DW $0261
	DW $0262
	DW $0194
	DW $0264
	DW $0265
	DW $0266
	DW $0267
	DW $0197
	DW $0196
	DW $026A
	DW $2C62
	DW $026C
	DW $026D
	DW $026E
	DW $019C
	DW $0270
	DW $0271
	DW $019D
	DW $0273
	DW $0274
	DW $019F
	DW $0276
	DW $0277
	DW $0278
	DW $0279
	DW $027A
	DW $027B
	DW $027C
	DW $2C64
	DW $027E
	DW $027F
	DW $01A6
	DW $0281
	DW $0282
	DW $01A9
	DW $0284
	DW $0285
	DW $0286
	DW $0287
	DW $01AE
	DW $0244
	DW $01B1
	DW $01B2
	DW $0245
	DW $028D
	DW $028E
	DW $028F
	DW $0290
	DW $0291
	DW $01B7
	DW $037B
	DW $0003
	DW $03FD
	DW $03FE
	DW $03FF
	DW $03AC
	DW $0004
	DW $0386
	DW $0388
	DW $0389
	DW $038A
	DW $03B1
	DW $0311
	DW $03C2
	DW $0002
	DW $03A3
	DW $03A3
	DW $03C4
	DW $0308
	DW $03CC
	DW $0003
	DW $038C
	DW $038E
	DW $038F
	DW $03D8
	DW $0118
	DW $03F2
	DW $000A
	DW $03F9
	DW $03F3
	DW $03F4
	DW $03F5
	DW $03F6
	DW $03F7
	DW $03F7
	DW $03F9
	DW $03FA
	DW $03FA
	DW $0430
	DW $0320
	DW $0450
	DW $0710
	DW $0460
	DW $0122
	DW $048A
	DW $0136
	DW $04C1
	DW $010E
	DW $04CF
	DW $0001
	DW $04C0
	DW $04D0
	DW $0144
	DW $0561
	DW $0426
	DW $0000
	SECTION FRAGMENT "src/fatfs/fatfs.c ROM0",ROM0
_ff_wtoupper_cvt2_65536_458:
	DW $1D7D
	DW $0001
	DW $2C63
	DW $1E00
	DW $0196
	DW $1EA0
	DW $015A
	DW $1F00
	DW $0608
	DW $1F10
	DW $0606
	DW $1F20
	DW $0608
	DW $1F30
	DW $0608
	DW $1F40
	DW $0606
	DW $1F51
	DW $0007
	DW $1F59
	DW $1F52
	DW $1F5B
	DW $1F54
	DW $1F5D
	DW $1F56
	DW $1F5F
	DW $1F60
	DW $0608
	DW $1F70
	DW $000E
	DW $1FBA
	DW $1FBB
	DW $1FC8
	DW $1FC9
	DW $1FCA
	DW $1FCB
	DW $1FDA
	DW $1FDB
	DW $1FF8
	DW $1FF9
	DW $1FEA
	DW $1FEB
	DW $1FFA
	DW $1FFB
	DW $1F80
	DW $0608
	DW $1F90
	DW $0608
	DW $1FA0
	DW $0608
	DW $1FB0
	DW $0004
	DW $1FB8
	DW $1FB9
	DW $1FB2
	DW $1FBC
	DW $1FCC
	DW $0001
	DW $1FC3
	DW $1FD0
	DW $0602
	DW $1FE0
	DW $0602
	DW $1FE5
	DW $0001
	DW $1FEC
	DW $1FF3
	DW $0001
	DW $1FFC
	DW $214E
	DW $0001
	DW $2132
	DW $2170
	DW $0210
	DW $2184
	DW $0001
	DW $2183
	DW $24D0
	DW $051A
	DW $2C30
	DW $042F
	DW $2C60
	DW $0102
	DW $2C67
	DW $0106
	DW $2C75
	DW $0102
	DW $2C80
	DW $0164
	DW $2D00
	DW $0826
	DW $FF41
	DW $031A
	DW $0000
;src/fatfs/fatfs.c:37: DSTATUS disk_status(BYTE pdrv) {
;	---------------------------------
	SECTION FRAGMENT "src/fatfs/fatfs.c B",ROMX
; Function disk_status
; ---------------------------------
_disk_status::
;src/fatfs/fatfs.c:39: return disk_ready ? 0 : STA_NOINIT;
	ld	hl, _disk_ready
	ld	a, [hl]
	or	a, a
	jp	Z, .l00103
	xor	a, a
	ld	c, a
	jp	.l00104
.l00103:
	ld	a, $01
	ld	c, $00
.l00104:
.l00101:
;src/fatfs/fatfs.c:40: }
	ret
;src/fatfs/fatfs.c:42: DSTATUS disk_initialize(BYTE pdrv) {
;	---------------------------------
	SECTION FRAGMENT "src/fatfs/fatfs.c B",ROMX
; Function disk_initialize
; ---------------------------------
_disk_initialize::
	ld	l, a
;	spillPairReg hl
;	spillPairReg hl
;src/fatfs/fatfs.c:43: disk_ready = !sd_Init();
	push	hl
	call	_sd_Init
	pop	hl
	sub	a,$01
	ld	a, $00
	rla
	ld	[_disk_ready], a
;src/fatfs/fatfs.c:44: return disk_status(pdrv);
	ld	a, l
	jp	_disk_status
.l00101:
;src/fatfs/fatfs.c:45: }
	ret
;src/fatfs/fatfs.c:47: DRESULT disk_read(BYTE pdrv, BYTE* buff, LBA_t sector, UINT count) {
;	---------------------------------
	SECTION FRAGMENT "src/fatfs/fatfs.c B",ROMX
; Function disk_read
; ---------------------------------
_disk_read::
	add	sp, -6
	inc	sp
	inc	sp
	push	de
;src/fatfs/fatfs.c:48: (void)pdrv;
	ld	hl, sp+12
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	ld	hl, sp+8
	ld	d, h
	ld	e, l
	ld	hl, sp+2
	ld	a, [de]
	ld	[hl+], a
	inc	de
	ld	a, [de]
	ld	[hl+], a
	inc	de
	ld	a, [de]
	ld	[hl+], a
	inc	de
	ld	a, [de]
	ld	[hl], a
.l00105:
;src/fatfs/fatfs.c:49: for (; count; --count, ++sector, buff += FF_MAX_SS) {
	ld	a, b
	or	a, c
	jp	Z, .l00103
;src/fatfs/fatfs.c:50: sd_sector = sector;
	ld	hl, sp+2
	ld	d, h
	ld	e, l
	ld	hl, _sd_sector
	ld	a, [de]
	ld	[hl+], a
	inc	de
	ld	a, [de]
	ld	[hl+], a
	inc	de
	ld	a, [de]
	ld	[hl+], a
	inc	de
	ld	a, [de]
	ld	[hl], a
;src/fatfs/fatfs.c:51: if (sd_ReadSector(buff)) return RES_ERROR;
	push	bc
	pop	hl
	pop	de
	push	de
	push	hl
	call	_sd_ReadSector
	pop	bc
	or	a, a
	jp	Z, .l00106
	ld	a, $01
	jp	.l00107
.l00106:
;src/fatfs/fatfs.c:49: for (; count; --count, ++sector, buff += FF_MAX_SS) {
	dec	bc
	ld	hl, sp+2
	inc	[hl]
	jp	NZ, .l00124
	inc	hl
	inc	[hl]
	jp	NZ, .l00124
	inc	hl
	inc	[hl]
	jp	NZ, .l00124
	inc	hl
	inc	[hl]
.l00124:
	pop	de
	push	de
	ld	hl, $0200
	add	hl, de
	inc	sp
	inc	sp
	push	hl
	jp	.l00105
.l00103:
;src/fatfs/fatfs.c:53: return RES_OK;
	xor	a, a
.l00107:
;src/fatfs/fatfs.c:54: }
	add	sp, 6
	pop	hl
	add	sp, 6
	jp hl 
;src/fatfs/fatfs.c:56: DRESULT disk_write(BYTE pdrv, const BYTE* buff, LBA_t sector, UINT count) {
;	---------------------------------
	SECTION FRAGMENT "src/fatfs/fatfs.c B",ROMX
; Function disk_write
; ---------------------------------
_disk_write::
	add	sp, -6
	inc	sp
	inc	sp
	push	de
;src/fatfs/fatfs.c:57: (void)pdrv;
	ld	hl, sp+12
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	ld	hl, sp+8
	ld	d, h
	ld	e, l
	ld	hl, sp+2
	ld	a, [de]
	ld	[hl+], a
	inc	de
	ld	a, [de]
	ld	[hl+], a
	inc	de
	ld	a, [de]
	ld	[hl+], a
	inc	de
	ld	a, [de]
	ld	[hl], a
.l00105:
;src/fatfs/fatfs.c:58: for (; count; --count, ++sector, buff += FF_MAX_SS) {
	ld	a, b
	or	a, c
	jp	Z, .l00103
;src/fatfs/fatfs.c:59: sd_sector = sector;
	ld	hl, sp+2
	ld	d, h
	ld	e, l
	ld	hl, _sd_sector
	ld	a, [de]
	ld	[hl+], a
	inc	de
	ld	a, [de]
	ld	[hl+], a
	inc	de
	ld	a, [de]
	ld	[hl+], a
	inc	de
	ld	a, [de]
	ld	[hl], a
;src/fatfs/fatfs.c:60: if (sd_WriteSector(buff)) return RES_ERROR;
	push	bc
	pop	hl
	pop	de
	push	de
	push	hl
	call	_sd_WriteSector
	pop	bc
	or	a, a
	jp	Z, .l00106
	ld	a, $01
	jp	.l00107
.l00106:
;src/fatfs/fatfs.c:58: for (; count; --count, ++sector, buff += FF_MAX_SS) {
	dec	bc
	ld	hl, sp+2
	inc	[hl]
	jp	NZ, .l00124
	inc	hl
	inc	[hl]
	jp	NZ, .l00124
	inc	hl
	inc	[hl]
	jp	NZ, .l00124
	inc	hl
	inc	[hl]
.l00124:
	pop	de
	push	de
	ld	hl, $0200
	add	hl, de
	inc	sp
	inc	sp
	push	hl
	jp	.l00105
.l00103:
;src/fatfs/fatfs.c:62: return RES_OK;
	xor	a, a
.l00107:
;src/fatfs/fatfs.c:63: }
	add	sp, 6
	pop	hl
	add	sp, 6
	jp hl 
;src/fatfs/fatfs.c:65: DRESULT disk_ioctl(BYTE pdrv, BYTE cmd, void* buff) {
;	---------------------------------
	SECTION FRAGMENT "src/fatfs/fatfs.c B",ROMX
; Function disk_ioctl
; ---------------------------------
_disk_ioctl::
;src/fatfs/fatfs.c:68: return cmd == CTRL_SYNC ? RES_OK : RES_PARERR;
	ld	a, e
	or	a, a
	jp	NZ, .l00103
	xor	a, a
	ld	c, a
	jp	.l00104
.l00103:
	ld	a, $04
	ld	c, $00
.l00104:
.l00101:
;src/fatfs/fatfs.c:69: }
	pop	hl
	inc	sp
	inc	sp
	jp hl 
;src/fatfs/fatfs.c:71: unsigned char fs_Mount(void) {
;	---------------------------------
	SECTION FRAGMENT "src/fatfs/fatfs.c A",ROMX
; Function fs_Mount
; ---------------------------------
_fs_Mount::
;src/fatfs/fatfs.c:72: return f_mount(&fs, "", 1);
	ld	a, $01
	push	af
	inc	sp
	ld	bc, ___str_3
	ld	de, _fs
	call	_f_mount__far
.l00101:
;src/fatfs/fatfs.c:73: }
	ret
	SECTION FRAGMENT "src/fatfs/fatfs.c ROM0",ROM0
___str_3:
	DB $00
;src/fatfs/fatfs.c:76: unsigned char fs_OpenDir(const char* path) {
;	---------------------------------
	SECTION FRAGMENT "src/fatfs/fatfs.c A",ROMX
; Function fs_OpenDir
; ---------------------------------
_fs_OpenDir::
	ld	c, e
	ld	b, d
;src/fatfs/fatfs.c:77: return f_opendir(&dir, path);
	ld	de, _dir
	jp	_f_opendir
.l00101:
;src/fatfs/fatfs.c:78: }
	ret
;src/fatfs/fatfs.c:81: unsigned char fs_NextEntry(FileEntry* entry) {
;	---------------------------------
	SECTION FRAGMENT "src/fatfs/fatfs.c A",ROMX
; Function fs_NextEntry
; ---------------------------------
_fs_NextEntry::
	add	sp, -9
	ld	hl, sp+7
	ld	[hl], e
	inc	hl
	ld	[hl], d
;src/fatfs/fatfs.c:82: while (f_readdir(&dir, &info) == FR_OK && info.fname[0]) {
.l00105:
	ld	bc, _info
	ld	de, _dir
	call	_f_readdir
	ld	hl, sp+6
	ld	[hl], a
	ld	hl, sp+6
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00107
	ld	hl, (_info + 22) + 0
	ld	a, [hl]
	ld	hl, sp+6
	ld	[hl], a
	ld	hl, sp+6
	ld	a, [hl]
	or	a, a
	jp	Z, .l00107
;src/fatfs/fatfs.c:83: if ((info.fattrib & (AM_HID | AM_SYS)) || info.fname[0] == '.') continue;
	ld	a, [(_info + 8) + 0]
	and	a, $06
	jp	NZ,.l00135
	jp	.l00136
.l00135:
	jp	.l00105
.l00136:
	ld	hl, sp+6
	ld	a, [hl]
	sub	a, $2E
	jp	NZ,.l00137
	jp	.l00105
.l00137:
;src/fatfs/fatfs.c:84: memcpy(entry->name, info.fname, FS_NAME_SIZE);
	ld	hl, sp+7
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	bc, $0041
	push	bc
	ld	bc, (_info + 22)
	call	___memcpy
;src/fatfs/fatfs.c:85: entry->size = info.fsize;
	ld	hl, sp+8
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $0041
	add	hl, de
	ld	c, l
	ld	b, h
	ld	de, _info + 0
	ld	a, [de]
	ld	hl, sp+3
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
;src/fatfs/fatfs.c:86: entry->date = info.fdate;
	inc	hl
	inc	hl
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $0045
	add	hl, de
	ld	c, l
	ld	b, h
	ld	hl, _info + 4
	ld	a, [hl]
	inc	hl
	ld	l, [hl]
;	spillPairReg hl
	ld	e, a
	ld	d, l
	ld	a, e
	ld	[bc], a
	inc	bc
	ld	a, d
	ld	[bc], a
;src/fatfs/fatfs.c:87: entry->time = info.ftime;
	ld	hl, sp+8
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $0047
	add	hl, de
	ld	c, l
	ld	b, h
	ld	hl, _info + 6
	ld	a, [hl]
	inc	hl
	ld	l, [hl]
;	spillPairReg hl
	ld	e, a
	ld	d, l
	ld	a, e
	ld	[bc], a
	inc	bc
	ld	a, d
	ld	[bc], a
;src/fatfs/fatfs.c:88: entry->dir = (info.fattrib & AM_DIR) != 0;
	ld	hl, sp+8
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $0049
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+6
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+5
	ld	[hl], a
	ld	hl, (_info + 8) + 0
	ld	a, [hl]
	ld	hl, sp+6
	ld	[hl], a
	ld	hl, sp+6
	ld	a, [hl]
	ld	hl, sp+0
	ld	[hl], a
	inc	hl
	ld	[hl], $00
	dec	hl
	ld	a, [hl]
	and	a, $10
	inc	hl
	inc	hl
	ld	[hl], a
	inc	hl
	ld	[hl], $00
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	sub	a,$01
	ld	a, $00
	rla
	ld	hl, sp+6
	ld	[hl], a
	ld	a, [hl]
	xor	a, $01
	ld	[hl], a
	dec	hl
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	inc	hl
	ld	a, [hl]
	ld	[de], a
;src/fatfs/fatfs.c:89: return 1;
	ld	a, $01
	jp	.l00108
.l00107:
;src/fatfs/fatfs.c:91: f_closedir(&dir);
	ld	de, _dir
	call	_f_closedir
;src/fatfs/fatfs.c:92: return 0;
	xor	a, a
.l00108:
;src/fatfs/fatfs.c:93: }
	add	sp, 9
	ret
;src/fatfs/fatfs.c:96: static UINT RemoveCR(UINT count) {
;	---------------------------------
	SECTION FRAGMENT "src/fatfs/fatfs.c A",ROMX
; Function RemoveCR
; ---------------------------------
_RemoveCR:
	add	sp, -4
	inc	sp
	inc	sp
	push	de
;src/fatfs/fatfs.c:97: BYTE* src = buffer;
	ld	bc, _buffer
;src/fatfs/fatfs.c:98: BYTE* dest = buffer;
	ld	hl, sp+2
	ld	a, LOW(_buffer)
	ld	[hl], a
	inc	hl
	ld	a, HIGH(_buffer)
	ld	[hl], a
;src/fatfs/fatfs.c:103: return (UINT)(dest - buffer);
.l00106:
;src/fatfs/fatfs.c:99: for (; count; --count, ++src) {
	ld	hl, sp+1
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	jp	Z, .l00104
;src/fatfs/fatfs.c:100: if (*src == '\r') fs_crlf = 1;
	ld	a, [bc]
	cp	a, $0D
	jp	NZ,.l00126
	jp	.l00127
.l00126:
	jp	.l00102
.l00127:
	ld	hl, _fs_crlf
	ld	[hl], $01
	jp	.l00107
.l00102:
;src/fatfs/fatfs.c:101: else *dest++ = *src;
	ld	hl, sp+2
	push	af
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	pop	af
	ld	[hl], a
	ld	hl, sp+2
	inc	[hl]
	jp	NZ, .l00128
	inc	hl
	inc	[hl]
.l00128:
.l00107:
;src/fatfs/fatfs.c:99: for (; count; --count, ++src) {
	pop	de
	push	de
	dec	de
	inc	sp
	inc	sp
	push	de
	inc	bc
	jp	.l00106
.l00104:
;src/fatfs/fatfs.c:103: return (UINT)(dest - buffer);
	ld	hl, sp+3
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, _buffer
	ld	a, e
	sub	a, l
	ld	e, a
	ld	a, d
	sbc	a, h
	ld	c, e
	ld	b, a
.l00108:
;src/fatfs/fatfs.c:104: }
	add	sp, 4
	ret
;src/fatfs/fatfs.c:107: unsigned char fs_Load(const char* path) {
;	---------------------------------
	SECTION FRAGMENT "src/fatfs/fatfs.c A",ROMX
; Function fs_Load
; ---------------------------------
_fs_Load::
	add	sp, -5
	ld	c, e
	ld	b, d
;src/fatfs/fatfs.c:109: FRESULT result = f_open(&file, path, FA_READ);
	ld	a, $01
	push	af
	inc	sp
	ld	de, _file
	call	_f_open
;src/fatfs/fatfs.c:110: if (result) return result;
	or	a, a
	jp	Z, .l00102
	jp	.l00110
.l00102:
;src/fatfs/fatfs.c:111: tb_Clear();
	call	_tb_Clear
;src/fatfs/fatfs.c:112: fs_crlf = 0;
	ld	hl, _fs_crlf
	ld	[hl], $00
;src/fatfs/fatfs.c:113: do {
.l00107:
;src/fatfs/fatfs.c:114: result = f_read(&file, buffer, BUFFER_SIZE, &count);
	ld	bc, _buffer
	ld	de, _file
	ld	hl, 0
	add	hl, sp
	push	hl
	ld	hl, $0200
	push	hl
	call	_f_read
	ld	hl, sp+2
	ld	[hl], a
;src/fatfs/fatfs.c:115: if (result) break;
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00109
;src/fatfs/fatfs.c:116: if (!tb_Append(buffer, RemoveCR(count))) {
	pop	de
	push	de
	call	_RemoveCR
	ld	hl, sp+3
	ld	[hl], c
	inc	hl
	ld	[hl], b
	ld	hl, sp+3
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	ld	de, _buffer
	call	_tb_Append
	or	a, a
	jp	NZ, .l00108
;src/fatfs/fatfs.c:117: result = FR_DENIED;
	ld	hl, sp+2
	ld	[hl], $07
;src/fatfs/fatfs.c:118: break;
	jp	.l00109
.l00108:
;src/fatfs/fatfs.c:120: } while (count == BUFFER_SIZE);
	ld	hl, sp+0
	ld	a, [hl]
	or	a, a
	jp	NZ,.l00132
	inc	hl
	ld	a, [hl]
	sub	a, $02
	jp	NZ,.l00132
	jp	.l00107
.l00132:
.l00109:
;src/fatfs/fatfs.c:121: f_close(&file);
	ld	de, _file
	call	_f_close__far
;src/fatfs/fatfs.c:122: return result;
	ld	hl, sp+2
	ld	a, [hl]
.l00110:
;src/fatfs/fatfs.c:123: }
	add	sp, 5
	ret
;src/fatfs/fatfs.c:127: static UINT AddCR(UINT count) {
;	---------------------------------
	SECTION FRAGMENT "src/fatfs/fatfs.c A",ROMX
; Function AddCR
; ---------------------------------
_AddCR:
	add	sp, -4
;src/fatfs/fatfs.c:128: BYTE* src = buffer + BUFFER_SIZE / 2;
;src/fatfs/fatfs.c:129: BYTE* dest = buffer;
	ld	hl, sp+0
	ld	a, LOW(_buffer)
	ld	[hl], a
	inc	hl
	ld	a, HIGH(_buffer)
	ld	[hl], a
;src/fatfs/fatfs.c:130: tb_Read(src, count);
	push	de
	ld	c, e
	ld	b, d
	ld	de, (_buffer + 256)
	call	_tb_Read
	pop	de
	ld	bc, (_buffer + 256)
	ld	hl, sp+2
	ld	[hl], e
	inc	hl
	ld	[hl], d
.l00105:
;src/fatfs/fatfs.c:131: for (; count; --count) {
	ld	hl, sp+3
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	jp	Z, .l00103
;src/fatfs/fatfs.c:132: if (*src == '\n') *dest++ = '\r';
	ld	a, [bc]
	sub	a, $0A
	jp	NZ,.l00125
	jp	.l00126
.l00125:
	jp	.l00102
.l00126:
	pop	hl
	push	hl
	ld	[hl], $0D
	ld	hl, sp+0
	inc	[hl]
	jp	NZ, .l00127
	inc	hl
	inc	[hl]
.l00127:
.l00102:
;src/fatfs/fatfs.c:133: *dest++ = *src++;
	ld	a, [bc]
	inc	bc
	pop	hl
	push	hl
	ld	[hl], a
	ld	hl, sp+0
	inc	[hl]
	jp	NZ, .l00128
	inc	hl
	inc	[hl]
.l00128:
;src/fatfs/fatfs.c:131: for (; count; --count) {
	ld	hl, sp+3
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	dec	de
	dec	hl
	ld	[hl], e
	inc	hl
	ld	[hl], d
	jp	.l00105
.l00103:
;src/fatfs/fatfs.c:135: return (UINT)(dest - buffer);
	pop	de
	push	de
	ld	hl, _buffer
	ld	a, e
	sub	a, l
	ld	e, a
	ld	a, d
	sbc	a, h
	ld	c, e
	ld	b, a
.l00107:
;src/fatfs/fatfs.c:136: }
	add	sp, 4
	ret
;src/fatfs/fatfs.c:139: unsigned char fs_Save(const char* path) {
;	---------------------------------
	SECTION FRAGMENT "src/fatfs/fatfs.c A",ROMX
; Function fs_Save
; ---------------------------------
_fs_Save::
	add	sp, -9
	ld	c, e
	ld	b, d
;src/fatfs/fatfs.c:142: FRESULT result = f_open(&file, path, FA_WRITE | FA_CREATE_ALWAYS);
	ld	a, $0A
	push	af
	inc	sp
	ld	de, _file
	call	_f_open
	ld	hl, sp+6
	ld	[hl], a
;src/fatfs/fatfs.c:143: if (result) return result;
	ld	a, [hl]
	or	a, a
	jp	Z, .l00102
	ld	a, [hl]
	jp	.l00116
.l00102:
;src/fatfs/fatfs.c:144: left = tb_Length();
	call	_tb_Length
	ld	hl, sp+7
	ld	[hl], c
	inc	hl
	ld	[hl], b
;src/fatfs/fatfs.c:145: tb_read_pos = 0;
	xor	a, a
	ld	hl, _tb_read_pos
	ld	[hl], a
	inc	hl
	ld	[hl], a
;src/fatfs/fatfs.c:146: while (left) {
.l00110:
	ld	hl, sp+8
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	jp	Z, .l00112
;src/fatfs/fatfs.c:147: if (fs_crlf) {
	ld	hl, _fs_crlf
	ld	a, [hl]
	or	a, a
	jp	Z, .l00104
;src/fatfs/fatfs.c:148: count = left < BUFFER_SIZE / 2 ? left : BUFFER_SIZE / 2;
	ld	hl, sp+7
	ld	a, [hl]
	sub	a, $00
	inc	hl
	ld	a, [hl]
	sbc	a, $01
	jp	NC, .l00118
	dec	hl
	ld	a, [hl]
	dec	hl
	dec	hl
	ld	[hl], a
	ld	hl, sp+8
	ld	a, [hl]
	dec	hl
	dec	hl
	ld	[hl], a
	jp	.l00119
.l00118:
	ld	hl, sp+5
	ld	[hl], $00
	inc	hl
	ld	[hl], $01
.l00119:
	ld	hl, sp+5
	ld	a, [hl]
	ld	hl, sp+2
	ld	[hl], a
	ld	hl, sp+6
	ld	a, [hl]
	ld	hl, sp+3
	ld	[hl], a
;src/fatfs/fatfs.c:149: size = AddCR(count);
	pop	hl
	pop	de
	push	de
	push	hl
	call	_AddCR
	ld	hl, sp+4
	ld	[hl], c
	inc	hl
	ld	[hl], b
	jp	.l00105
.l00104:
;src/fatfs/fatfs.c:151: count = left < BUFFER_SIZE ? left : BUFFER_SIZE;
	ld	hl, sp+7
	ld	a, [hl]
	sub	a, $00
	inc	hl
	ld	a, [hl]
	sbc	a, $02
	jp	NC, .l00120
	dec	hl
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	jp	.l00121
.l00120:
	ld	bc, $0200
.l00121:
	ld	hl, sp+2
	ld	[hl], c
	inc	hl
	ld	[hl], b
;src/fatfs/fatfs.c:152: tb_Read(buffer, count);
	pop	hl
	pop	bc
	push	bc
	push	hl
	ld	de, _buffer
	call	_tb_Read
;src/fatfs/fatfs.c:153: size = count;
	ld	hl, sp+2
	ld	a, [hl]
	inc	hl
	inc	hl
	ld	[hl], a
	dec	hl
	ld	a, [hl]
	inc	hl
	inc	hl
	ld	[hl], a
.l00105:
;src/fatfs/fatfs.c:155: result = f_write(&file, buffer, size, &written);
	ld	hl, 0
	add	hl, sp
	ld	e, l
	ld	d, h
	push	de
	ld	hl, sp+6
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	push	de
	ld	bc, _buffer
	ld	de, _file
	call	_f_write__far
	ld	hl, sp+6
	ld	[hl], a
;src/fatfs/fatfs.c:156: if (result) break;
	ld	hl, sp+6
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00112
;src/fatfs/fatfs.c:157: if (written != size) {
	ld	hl, sp+0
	ld	a, [hl]
	ld	hl, sp+4
	sub	a, [hl]
	jp	NZ,.l00172
	ld	hl, sp+1
	ld	a, [hl]
	ld	hl, sp+5
	sub	a, [hl]
	jp	NZ,.l00172
	jp	.l00109
.l00172:
;src/fatfs/fatfs.c:158: result = FR_DENIED; // disk full
	ld	hl, sp+6
	ld	[hl], $07
;src/fatfs/fatfs.c:159: break;
	jp	.l00112
.l00109:
;src/fatfs/fatfs.c:161: left -= count;
	ld	hl, sp+8
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, sp+2
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	ld	a, e
	sub	a, l
	ld	e, a
	ld	a, d
	sbc	a, h
	ld	hl, sp+8
	ld	[hl], a
	dec	hl
	ld	[hl], e
	jp	.l00110
.l00112:
;src/fatfs/fatfs.c:163: if (f_close(&file) && !result) result = FR_DISK_ERR;
	ld	de, _file
	call	_f_close__far
	or	a, a
	jp	Z, .l00114
	ld	hl, sp+6
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00114
	ld	[hl], $01
.l00114:
;src/fatfs/fatfs.c:164: return result;
	ld	hl, sp+6
	ld	a, [hl]
.l00116:
;src/fatfs/fatfs.c:165: }
	add	sp, 9
	ret
	SECTION FRAGMENT "src/fatfs/fatfs.c A",ROMX
	SECTION FRAGMENT "_INITIALIZER",ROM0
	SECTION FRAGMENT "_CABS (ABS)",ROM0

;far call thunks generated by bank_split.py
	SECTION FRAGMENT "src/fatfs/fatfs.c ROM0",ROM0
_clst2sect__far:
	ld [far_a], a
	ld a, LOW(_clst2sect)
	ld [far_target], a
	ld a, HIGH(_clst2sect)
	ld [far_target+1], a
	ld a, BANK(_clst2sect)
	jp FarCall
_cmp_lfn__far:
	ld [far_a], a
	ld a, LOW(_cmp_lfn)
	ld [far_target], a
	ld a, HIGH(_cmp_lfn)
	ld [far_target+1], a
	ld a, BANK(_cmp_lfn)
	jp FarCall
_create_chain__far:
	ld [far_a], a
	ld a, LOW(_create_chain)
	ld [far_target], a
	ld a, HIGH(_create_chain)
	ld [far_target+1], a
	ld a, BANK(_create_chain)
	jp FarCall
_create_name__far:
	ld [far_a], a
	ld a, LOW(_create_name)
	ld [far_target], a
	ld a, HIGH(_create_name)
	ld [far_target+1], a
	ld a, BANK(_create_name)
	jp FarCall
_dir_clear__far:
	ld [far_a], a
	ld a, LOW(_dir_clear)
	ld [far_target], a
	ld a, HIGH(_dir_clear)
	ld [far_target+1], a
	ld a, BANK(_dir_clear)
	jp FarCall
_dir_find__far:
	ld [far_a], a
	ld a, LOW(_dir_find)
	ld [far_target], a
	ld a, HIGH(_dir_find)
	ld [far_target+1], a
	ld a, BANK(_dir_find)
	jp FarCall
_dir_next__far:
	ld [far_a], a
	ld a, LOW(_dir_next)
	ld [far_target], a
	ld a, HIGH(_dir_next)
	ld [far_target+1], a
	ld a, BANK(_dir_next)
	jp FarCall
_dir_register__far:
	ld [far_a], a
	ld a, LOW(_dir_register)
	ld [far_target], a
	ld a, HIGH(_dir_register)
	ld [far_target+1], a
	ld a, BANK(_dir_register)
	jp FarCall
_dir_sdi__far:
	ld [far_a], a
	ld a, LOW(_dir_sdi)
	ld [far_target], a
	ld a, HIGH(_dir_sdi)
	ld [far_target+1], a
	ld a, BANK(_dir_sdi)
	jp FarCall
_disk_read__far:
	ld [far_a], a
	ld a, LOW(_disk_read)
	ld [far_target], a
	ld a, HIGH(_disk_read)
	ld [far_target+1], a
	ld a, BANK(_disk_read)
	jp FarCall
_disk_status__far:
	ld [far_a], a
	ld a, LOW(_disk_status)
	ld [far_target], a
	ld a, HIGH(_disk_status)
	ld [far_target+1], a
	ld a, BANK(_disk_status)
	jp FarCall
_f_close__far:
	ld [far_a], a
	ld a, LOW(_f_close)
	ld [far_target], a
	ld a, HIGH(_f_close)
	ld [far_target+1], a
	ld a, BANK(_f_close)
	jp FarCall
_f_mount__far:
	ld [far_a], a
	ld a, LOW(_f_mount)
	ld [far_target], a
	ld a, HIGH(_f_mount)
	ld [far_target+1], a
	ld a, BANK(_f_mount)
	jp FarCall
_f_write__far:
	ld [far_a], a
	ld a, LOW(_f_write)
	ld [far_target], a
	ld a, HIGH(_f_write)
	ld [far_target+1], a
	ld a, BANK(_f_write)
	jp FarCall
_gen_numname__far:
	ld [far_a], a
	ld a, LOW(_gen_numname)
	ld [far_target], a
	ld a, HIGH(_gen_numname)
	ld [far_target+1], a
	ld a, BANK(_gen_numname)
	jp FarCall
_get_fat__far:
	ld [far_a], a
	ld a, LOW(_get_fat)
	ld [far_target], a
	ld a, HIGH(_get_fat)
	ld [far_target+1], a
	ld a, BANK(_get_fat)
	jp FarCall
_get_fileinfo__far:
	ld [far_a], a
	ld a, LOW(_get_fileinfo)
	ld [far_target], a
	ld a, HIGH(_get_fileinfo)
	ld [far_target+1], a
	ld a, BANK(_get_fileinfo)
	jp FarCall
_ld_clust__far:
	ld [far_a], a
	ld a, LOW(_ld_clust)
	ld [far_target], a
	ld a, HIGH(_ld_clust)
	ld [far_target+1], a
	ld a, BANK(_ld_clust)
	jp FarCall
_mount_volume__far:
	ld [far_a], a
	ld a, LOW(_mount_volume)
	ld [far_target], a
	ld a, HIGH(_mount_volume)
	ld [far_target+1], a
	ld a, BANK(_mount_volume)
	jp FarCall
_move_window__far:
	ld [far_a], a
	ld a, LOW(_move_window)
	ld [far_target], a
	ld a, HIGH(_move_window)
	ld [far_target+1], a
	ld a, BANK(_move_window)
	jp FarCall
_oem2uni_sbcs__far:
	ld [far_a], a
	ld a, LOW(_oem2uni_sbcs)
	ld [far_target], a
	ld a, HIGH(_oem2uni_sbcs)
	ld [far_target+1], a
	ld a, BANK(_oem2uni_sbcs)
	jp FarCall
_pick_lfn__far:
	ld [far_a], a
	ld a, LOW(_pick_lfn)
	ld [far_target], a
	ld a, HIGH(_pick_lfn)
	ld [far_target+1], a
	ld a, BANK(_pick_lfn)
	jp FarCall
_put_lfn__far:
	ld [far_a], a
	ld a, LOW(_put_lfn)
	ld [far_target], a
	ld a, HIGH(_put_lfn)
	ld [far_target+1], a
	ld a, BANK(_put_lfn)
	jp FarCall
_remove_chain__far:
	ld [far_a], a
	ld a, LOW(_remove_chain)
	ld [far_target], a
	ld a, HIGH(_remove_chain)
	ld [far_target+1], a
	ld a, BANK(_remove_chain)
	jp FarCall
_st_clust__far:
	ld [far_a], a
	ld a, LOW(_st_clust)
	ld [far_target], a
	ld a, HIGH(_st_clust)
	ld [far_target+1], a
	ld a, BANK(_st_clust)
	jp FarCall
_sum_sfn__far:
	ld [far_a], a
	ld a, LOW(_sum_sfn)
	ld [far_target], a
	ld a, HIGH(_sum_sfn)
	ld [far_target+1], a
	ld a, BANK(_sum_sfn)
	jp FarCall
_uni2oem_sbcs__far:
	ld [far_a], a
	ld a, LOW(_uni2oem_sbcs)
	ld [far_target], a
	ld a, HIGH(_uni2oem_sbcs)
	ld [far_target+1], a
	ld a, BANK(_uni2oem_sbcs)
	jp FarCall
_validate__far:
	ld [far_a], a
	ld a, LOW(_validate)
	ld [far_target], a
	ld a, HIGH(_validate)
	ld [far_target+1], a
	ld a, BANK(_validate)
	jp FarCall