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
	EXPORT ___memcpy
	EXPORT _memset
	EXPORT _memcmp
	EXPORT __mullong
	EXPORT __divulong
	EXPORT _strchr
	EXPORT _disk_status
	EXPORT _disk_initialize
	EXPORT _disk_read
	EXPORT _disk_write
	EXPORT _disk_ioctl
	EXPORT _fs_Mount
	EXPORT _fs_OpenDir
	EXPORT _fs_NextFile
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
_fs:
	DS 560
_file:
	DS 34
_dir:
	DS 40
_info:
	DS 22
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
	SECTION FRAGMENT "src/fatfs/fatfs.c_HOME",ROM0
;--------------------------------------------------------
; code
;--------------------------------------------------------
	SECTION FRAGMENT "src/fatfs/fatfs.c_CODE",ROMX
;src/fatfs/lib/ff.c:622: static WORD ld_16 (const BYTE* ptr)	/*	 Load a 2-byte little-endian word */
;	---------------------------------
	SECTION FRAGMENT "src/fatfs/fatfs.c B",ROMX
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
	SECTION FRAGMENT "src/fatfs/fatfs.c B",ROMX
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
	SECTION FRAGMENT "src/fatfs/fatfs.c B",ROMX
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
	SECTION FRAGMENT "src/fatfs/fatfs.c B",ROMX
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
	SECTION FRAGMENT "src/fatfs/fatfs.c B",ROMX
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
	SECTION FRAGMENT "src/fatfs/fatfs.c B",ROMX
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
	ld	hl, $001C
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
	ld	hl, $0030
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
	ld	hl, $0024
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
	ld	hl, $0018
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
	ld	hl, $001C
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
	ld	hl, $0030
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
	ld	hl, $0030
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
	ld	hl, $0030
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
	ld	hl, $0010
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
	ld	hl, $000C
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
	ld	hl, $001C
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
	ld	hl, $0020
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
	ld	hl, $0014
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
	ld	hl, $002C
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
	ld	hl, $0014
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
	ld	hl, $0024
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
	ld	hl, $0030
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
	call	_ld_16__far
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
	call	_ld_32__far
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
	ld	hl, $0014
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
	ld	hl, $0024
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
	ld	hl, $0030
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
	ld	hl, $0014
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
	ld	hl, $0010
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
	ld	hl, $000C
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
	ld	hl, $0014
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
	ld	hl, $0010
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
	ld	hl, $001C
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
	ld	hl, $0030
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
	ld	hl, $0028
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
	ld	hl, $0030
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
	ld	hl, $0014
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
	ld	hl, $0030
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
;src/fatfs/lib/ff.c:2337: static FRESULT dir_read (
;	---------------------------------
	SECTION FRAGMENT "src/fatfs/fatfs.c A",ROMX
; Function dir_read
; ---------------------------------
_dir_read:
	add	sp, -16
	ld	hl, sp+14
	ld	[hl], e
	inc	hl
	ld	[hl], d
	ld	hl, sp+12
	ld	[hl], c
	inc	hl
	ld	[hl], b
;src/fatfs/lib/ff.c:2342: FRESULT res = FR_NO_FILE;
	ld	hl, sp+4
	ld	[hl], $04
;src/fatfs/lib/ff.c:2343: FATFS *fs = dp->obj.fs;
	ld	hl, sp+15
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
;src/fatfs/lib/ff.c:2349: while (dp->sect) {
	ld	hl, sp+15
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $0016
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
	ld	a, [hl]
	inc	hl
	inc	hl
	ld	[hl], a
	dec	hl
	ld	a, [hl]
	inc	hl
	inc	hl
	ld	[hl], a
.l00112:
	ld	hl, sp+10
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
	jp	Z, .l00114
;src/fatfs/lib/ff.c:2350: res = move_window(fs, dp->sect);
	pop	hl
	pop	de
	push	de
	push	hl
	push	de
	pop	hl
	pop	de
	push	de
	push	hl
	push	de
	ld	hl, sp+9
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_move_window__far
	ld	hl, sp+4
	ld	[hl], a
;src/fatfs/lib/ff.c:2351: if (res != FR_OK) break;
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00114
;src/fatfs/lib/ff.c:2352: et = dp->dir[DIR_Name];	/* Test for the entry type */
	ld	hl, sp+15
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
	ld	a, [bc]
	ld	hl, sp+11
	ld	[hl], a
;src/fatfs/lib/ff.c:2353: if (et == 0) {
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00104
;src/fatfs/lib/ff.c:2354: res = FR_NO_FILE; break; /* Reached to end of the directory */
	ld	hl, sp+4
	ld	[hl], $04
	jp	.l00114
.l00104:
;src/fatfs/lib/ff.c:2373: dp->obj.attr = attr = dp->dir[DIR_Attr] & AM_MASK;	/* Get attribute */
	ld	hl, sp+15
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $0004
	add	hl, de
	ld	e, l
	ld	d, h
	ld	hl, $000B
	add	hl, bc
	ld	a, [hl]
	and	a, $3F
	ld	c, a
	ld	[de], a
;src/fatfs/lib/ff.c:2394: if (et != DDEM && et != '.' && attr != AM_LFN && (int)((attr & ~AM_ARC) == AM_VOL) == vol) {	/* Is it a valid entry? */
	ld	hl, sp+11
	ld	a, [hl]
	sub	a, $E5
	jp	NZ,.l00159
	jp	.l00106
.l00159:
	ld	hl, sp+11
	ld	a, [hl]
	sub	a, $2E
	jp	NZ,.l00160
	jp	.l00106
.l00160:
	ld	a, c
	sub	a, $0F
	jp	NZ,.l00161
	jp	.l00106
.l00161:
	ld	b, $00
	res	5, c
	ld	a, c
	sub	a, $08
	or	a, b
	jp	NZ,.l00162
	ld	a,$01
	jp	.l00163
.l00162:
	xor	a,a
.l00163:
	ld	c, a
	ld	b, $00
	ld	hl, sp+12
	ld	a, [hl]
	sub	a, c
	jp	NZ,.l00164
	inc	hl
	ld	a, [hl]
	sub	a, b
	jp	NZ,.l00164
	jp	.l00114
.l00164:
;src/fatfs/lib/ff.c:2395: break;
.l00106:
;src/fatfs/lib/ff.c:2399: res = dir_next(dp, 0);		/* Next entry */
	ld	bc, $0000
	ld	hl, sp+14
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_dir_next
	ld	hl, sp+4
	ld	[hl], a
;src/fatfs/lib/ff.c:2400: if (res != FR_OK) break;
	ld	a, [hl]
	or	a, a
	jp	Z, .l00112
.l00114:
;src/fatfs/lib/ff.c:2403: if (res != FR_OK) dp->sect = 0;		/* Terminate the read operation on error or EOT */
	ld	hl, sp+4
	ld	a, [hl]
	or	a, a
	jp	Z, .l00116
	ld	hl, sp+7
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
.l00116:
;src/fatfs/lib/ff.c:2404: return res;
	ld	hl, sp+4
	ld	a, [hl]
.l00117:
;src/fatfs/lib/ff.c:2405: }
	add	sp, 16
	ret
;src/fatfs/lib/ff.c:2415: static FRESULT dir_find (	/* FR_OK(0):succeeded, !=0:error */
;	---------------------------------
	SECTION FRAGMENT "src/fatfs/fatfs.c A",ROMX
; Function dir_find
; ---------------------------------
_dir_find:
	add	sp, -15
	ld	hl, sp+13
	ld	[hl], e
	inc	hl
	ld	[hl], d
;src/fatfs/lib/ff.c:2420: FATFS *fs = dp->obj.fs;
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
;src/fatfs/lib/ff.c:2426: res = dir_sdi(dp, 0);			/* Rewind directory object */
	ld	de, $0000
	push	de
	push	de
	ld	hl, sp+17
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_dir_sdi
;src/fatfs/lib/ff.c:2427: if (res != FR_OK) return res;
	or	a, a
	jp	Z, .l00119
	jp	.l00113
;src/fatfs/lib/ff.c:2452: do {
.l00119:
	ld	hl, sp+14
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
	ld	hl, sp+14
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $0016
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+10
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+9
	ld	[hl], a
.l00110:
;src/fatfs/lib/ff.c:2453: res = move_window(fs, dp->sect);
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
	pop	hl
	pop	de
	push	de
	push	hl
	push	de
	pop	hl
	pop	de
	push	de
	push	hl
	push	de
	ld	hl, sp+8
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_move_window__far
	ld	hl, sp+10
	ld	[hl], a
;src/fatfs/lib/ff.c:2454: if (res != FR_OK) break;
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00112
;src/fatfs/lib/ff.c:2455: et = dp->dir[DIR_Name];		/* Entry type */
	ld	hl, sp+14
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $001A
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+13
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+12
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
	ld	a, [bc]
;src/fatfs/lib/ff.c:2456: if (et == 0) { res = FR_NO_FILE; break; }	/* Reached end of directory table */
	or	a, a
	jp	NZ, .l00106
	dec	hl
	dec	hl
	ld	[hl], $04
	jp	.l00112
.l00106:
;src/fatfs/lib/ff.c:2480: dp->obj.attr = dp->dir[DIR_Attr] & AM_MASK;
	ld	hl, sp+14
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $0004
	add	hl, de
	ld	e, l
	ld	d, h
	ld	hl, $000B
	add	hl, bc
	ld	a, [hl]
	and	a, $3F
	ld	[de], a
;src/fatfs/lib/ff.c:2481: if (!(dp->dir[DIR_Attr] & AM_VOL) && !memcmp(dp->dir, dp->fn, 11)) break;	/* Is it a valid entry? */
	ld	hl, sp+12
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	ld	c, a
	inc	de
	ld	a, [de]
	ld	b, a
	ld	hl, $000B
	add	hl, bc
	ld	a, [hl]
	bit	3, a
	jp	NZ,.l00140
	jp	.l00141
.l00140:
	jp	.l00108
.l00141:
	ld	hl, sp+6
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	l, c
;	spillPairReg hl
;	spillPairReg hl
	ld	h, b
;	spillPairReg hl
;	spillPairReg hl
	ld	bc, $000B
	push	bc
	ld	c, e
	ld	b, d
	ld	e, l
	ld	d, h
	call	_memcmp__far
	ld	a, b
	or	a, c
	jp	Z, .l00112
.l00108:
;src/fatfs/lib/ff.c:2483: res = dir_next(dp, 0);	/* Next entry */
	ld	bc, $0000
	ld	hl, sp+13
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_dir_next
	ld	hl, sp+10
	ld	[hl], a
;src/fatfs/lib/ff.c:2484: } while (res == FR_OK);
	ld	a, [hl]
	or	a, a
	jp	Z, .l00110
.l00112:
;src/fatfs/lib/ff.c:2486: return res;
	ld	hl, sp+10
	ld	a, [hl]
.l00113:
;src/fatfs/lib/ff.c:2487: }
	add	sp, 15
	ret
;src/fatfs/lib/ff.c:2497: static FRESULT dir_register (	/* FR_OK:succeeded, FR_DENIED:no free entry or too many SFN collision, FR_DISK_ERR:disk error */
;	---------------------------------
	SECTION FRAGMENT "src/fatfs/fatfs.c B",ROMX
; Function dir_register
; ---------------------------------
_dir_register:
	add	sp, -7
	ld	hl, sp+5
	ld	[hl], e
	inc	hl
	ld	[hl], d
;src/fatfs/lib/ff.c:2502: FATFS *fs = dp->obj.fs;
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
;src/fatfs/lib/ff.c:2581: res = dir_alloc(dp, 1);		/* Allocate an entry for SFN */
	ld	bc, $0001
	ld	hl, sp+5
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_dir_alloc
	ld	hl, sp+2
	ld	[hl], a
;src/fatfs/lib/ff.c:2586: if (res == FR_OK) {
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00104
;src/fatfs/lib/ff.c:2587: res = move_window(fs, dp->sect);
	ld	hl, sp+6
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $0016
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
	ld	hl, sp+2
	ld	[hl], a
;src/fatfs/lib/ff.c:2588: if (res == FR_OK) {
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00104
;src/fatfs/lib/ff.c:2589: memset(dp->dir, 0, SZDIRE);	/* Clean the entry */
	ld	hl, sp+6
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
	ld	hl, sp+6
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $001C
	add	hl, de
	ld	c, l
	ld	b, h
	ld	hl, sp+4
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
	call	___memcpy
;src/fatfs/lib/ff.c:2594: fs->wflag = 1;
	pop	de
	push	de
	ld	hl, $0004
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
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	ld	[hl], $01
.l00104:
;src/fatfs/lib/ff.c:2598: return res;
	ld	hl, sp+2
	ld	a, [hl]
.l00105:
;src/fatfs/lib/ff.c:2599: }
	add	sp, 7
	ret
;src/fatfs/lib/ff.c:2656: static void get_fileinfo (
;	---------------------------------
	SECTION FRAGMENT "src/fatfs/fatfs.c A",ROMX
; Function get_fileinfo
; ---------------------------------
_get_fileinfo:
	add	sp, -15
	ld	hl, sp+11
	ld	[hl], e
	inc	hl
	ld	[hl], d
	ld	hl, sp+9
	ld	[hl], c
	inc	hl
	ld	[hl], b
;src/fatfs/lib/ff.c:2671: fno->fname[0] = 0;
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $0009
	add	hl, de
	ld	c, l
	ld	b, h
	xor	a, a
	ld	[bc], a
;src/fatfs/lib/ff.c:2672: if (dp->sect == 0) return;	/* Exit if read pointer has reached end of directory */
	ld	hl, sp+12
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
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	dec	hl
	or	a, [hl]
	dec	hl
	or	a, [hl]
	jp	NZ, .l00102
	jp	.l00112
.l00102:
;src/fatfs/lib/ff.c:2777: si = di = 0;
	ld	bc, $0000
;src/fatfs/lib/ff.c:2778: while (si < 11) {		/* Copy name body and extension */
	ld	hl, sp+12
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $001A
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+4
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+3
	ld	[hl], a
	ld	hl, sp+10
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $0009
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
	ld	a, [hl]
	inc	hl
	inc	hl
	ld	[hl], a
	dec	hl
	ld	a, [hl]
	inc	hl
	inc	hl
	ld	[hl], a
	xor	a, a
	ld	hl, sp+13
	ld	[hl], a
	inc	hl
	ld	[hl], a
.l00109:
	ld	hl, sp+13
	ld	a, [hl]
	sub	a, $0B
	inc	hl
	ld	a, [hl]
	sbc	a, $00
	jp	NC, .l00111
;src/fatfs/lib/ff.c:2779: c = (TCHAR)dp->dir[si++];
	ld	hl, sp+3
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
	pop	de
	push	de
	ld	hl, sp+13
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	add	hl, de
	ld	e, l
	ld	d, h
	ld	hl, sp+13
	inc	[hl]
	jp	NZ, .l00145
	inc	hl
	inc	[hl]
.l00145:
	ld	a, [de]
	ld	hl, sp+8
	ld	[hl], a
;src/fatfs/lib/ff.c:2780: if (c == ' ') continue;		/* Skip padding spaces */
	ld	a, [hl]
	sub	a, $20
	jp	NZ,.l00146
	jp	.l00109
.l00146:
;src/fatfs/lib/ff.c:2781: if (c == RDDEM) c = DDEM;	/* Restore replaced DDEM character */
	ld	hl, sp+8
	ld	a, [hl]
	sub	a, $05
	jp	NZ,.l00147
	jp	.l00148
.l00147:
	jp	.l00106
.l00148:
	ld	hl, sp+8
	ld	[hl], $E5
.l00106:
;src/fatfs/lib/ff.c:2782: if (si == 9) fno->fname[di++] = '.';/* Insert a . if extension is exist */
	ld	hl, sp+13
	ld	a, [hl]
	sub	a, $09
	inc	hl
	or	a, [hl]
	jp	NZ,.l00149
	jp	.l00150
.l00149:
	jp	.l00108
.l00150:
	ld	e, c
	ld	d, b
	inc	bc
	ld	hl, sp+4
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	add	hl, de
	ld	e, l
	ld	d, h
	ld	a, $2E
	ld	[de], a
.l00108:
;src/fatfs/lib/ff.c:2783: fno->fname[di++] = c;
	ld	e, c
	ld	d, b
	inc	bc
	ld	hl, sp+6
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	add	hl, de
	ld	e, l
	ld	d, h
	ld	hl, sp+8
	ld	a, [hl]
	ld	[de], a
	jp	.l00109
.l00111:
;src/fatfs/lib/ff.c:2785: fno->fname[di] = 0;		/* Terminate the SFN */
	ld	hl, sp+4
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	add	hl, bc
	ld	c, l
	ld	b, h
	xor	a, a
	ld	[bc], a
;src/fatfs/lib/ff.c:2788: fno->fattrib = dp->dir[DIR_Attr] & AM_MASK;		/* Attribute */
	ld	hl, sp+10
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $0008
	add	hl, de
	ld	c, l
	ld	b, h
	ld	hl, sp+3
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
	ld	hl, $001C
	add	hl, bc
	ld	e, l
	ld	d, h
	call	_ld_32__far
	ld	hl, sp+5
	ld	[hl], c
	inc	hl
	ld	[hl], b
	inc	hl
	ld	[hl], e
	inc	hl
	ld	[hl], d
	ld	hl, sp+10
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, sp+5
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
	ld	hl, sp+3
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
	call	_ld_16__far
	ld	e, c
	ld	d, b
	pop	bc
	ld	a, e
	ld	[bc], a
	inc	bc
	ld	a, d
	ld	[bc], a
;src/fatfs/lib/ff.c:2791: fno->fdate = ld_16(dp->dir + DIR_ModTime + 2);	/* Last Modified date */
	ld	hl, sp+10
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $0004
	add	hl, de
	ld	c, l
	ld	b, h
	ld	hl, sp+3
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
	call	_ld_16__far
	ld	e, c
	ld	d, b
	pop	bc
	ld	a, e
	ld	[bc], a
	inc	bc
	ld	a, d
	ld	[bc], a
.l00112:
;src/fatfs/lib/ff.c:2796: }
	add	sp, 15
	ret
;src/fatfs/lib/ff.c:2895: static FRESULT create_name (	/* FR_OK: successful, FR_INVALID_NAME: could not create */
;	---------------------------------
	SECTION FRAGMENT "src/fatfs/fatfs.c A",ROMX
; Function create_name
; ---------------------------------
_create_name:
	add	sp, -18
	ld	hl, sp+14
	ld	[hl], e
	inc	hl
	ld	[hl], d
	ld	hl, sp+12
	ld	[hl], c
	inc	hl
	ld	[hl], b
;src/fatfs/lib/ff.c:3034: p = *path; sfn = dp->fn;
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
	ld	hl, sp+15
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $001C
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+4
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+3
	ld	[hl], a
;src/fatfs/lib/ff.c:3035: memset(sfn, ' ', 11);
	pop	hl
	pop	de
	push	de
	push	hl
	ld	bc, $000B
	push	bc
	ld	bc, $0020
	call	_memset__far
;src/fatfs/lib/ff.c:3036: si = i = 0; ni = 8;
	xor	a, a
	ld	hl, sp+4
	ld	[hl], a
	inc	hl
	ld	[hl], a
	xor	a, a
	ld	hl, sp+16
	ld	[hl], a
	inc	hl
	ld	[hl], a
	ld	hl, sp+6
	ld	[hl], $08
	xor	a, a
	inc	hl
	ld	[hl], a
.l00135:
;src/fatfs/lib/ff.c:3056: c = (BYTE)p[si++];				/* Get a byte */
	ld	hl, sp+16
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	dec	hl
	inc	[hl]
	jp	NZ, .l00225
	inc	hl
	inc	[hl]
.l00225:
	pop	hl
	push	hl
	add	hl, bc
	ld	c, l
	ld	b, h
	ld	a, [bc]
	ld	hl, sp+8
	ld	[hl], a
;src/fatfs/lib/ff.c:3057: if (c <= ' ') break; 			/* Break if end of the path name */
	ld	a, $20
	sub	a, [hl]
	ld	a, $00
	rla
	ld	hl, sp+11
	ld	[hl], a
	bit	0, [hl]
	jp	Z, .l00130
;src/fatfs/lib/ff.c:3058: if (IsSeparator(c)) {			/* Break if a separator is found */
	ld	hl, sp+8
	ld	a, [hl]
	sub	a, $2F
	jp	NZ,.l00226
	jp	.l00146
.l00226:
	ld	hl, sp+8
	ld	a, [hl]
	sub	a, $5C
	jp	NZ,.l00227
	jp	.l00228
.l00227:
	jp	.l00108
.l00228:
;src/fatfs/lib/ff.c:3059: while (IsSeparator(p[si])) si++;	/* Skip duplicated separators */
.l00146:
	ld	hl, sp+16
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
.l00104:
	pop	hl
	push	hl
	add	hl, bc
	ld	e, l
	ld	d, h
	ld	a, [de]
	cp	a, $2F
	jp	NZ,.l00229
	jp	.l00105
.l00229:
	sub	a, $5C
	jp	NZ,.l00230
	jp	.l00231
.l00230:
	jp	.l00160
.l00231:
.l00105:
	inc	bc
	jp	.l00104
;src/fatfs/lib/ff.c:3060: break;
.l00108:
;src/fatfs/lib/ff.c:3062: if (c == '.' || i >= ni) {		/* End of body or field overflow? */
	ld	hl, sp+8
	ld	a, [hl]
	sub	a, $2E
	jp	NZ,.l00232
	ld	a,$01
	jp	.l00233
.l00232:
	xor	a,a
.l00233:
	ld	c, a
	ld	a, c
	or	a, a
	jp	NZ, .l00113
	ld	hl, sp+4
	ld	e, l
	ld	d, h
	ld	hl, sp+6
	ld	a, [de]
	inc	de
	sub	a, [hl]
	inc	hl
	ld	a, [de]
	sbc	a, [hl]
	jp	C, .l00114
.l00113:
;src/fatfs/lib/ff.c:3063: if (ni == 11 || c != '.') return FR_INVALID_NAME;	/* Field overflow or invalid dot? */
	ld	hl, sp+6
	ld	a, [hl]
	sub	a, $0B
	inc	hl
	or	a, [hl]
	jp	NZ,.l00234
	jp	.l00110
.l00234:
	bit	0, c
	jp	NZ, .l00111
.l00110:
	ld	a, $06
	jp	.l00136
.l00111:
;src/fatfs/lib/ff.c:3064: i = 8; ni = 11;				/* Enter file extension field */
	ld	hl, sp+4
	ld	[hl], $08
	xor	a, a
	inc	hl
	ld	[hl], a
	inc	hl
	ld	[hl], $0B
	xor	a, a
	inc	hl
	ld	[hl], a
;src/fatfs/lib/ff.c:3065: continue;
	jp	.l00135
.l00114:
;src/fatfs/lib/ff.c:3072: if (c >= 0x80) {				/* Is SBC extended character? */
	ld	hl, sp+8
	ld	a, [hl]
	sub	a, $80
	jp	C, .l00117
;src/fatfs/lib/ff.c:3073: c = ExCvt[c & 0x7F];		/* To upper SBC extended character */
	ld	c, [hl]
	xor	a, a
	res	7, c
	ld	b, $00
	ld	hl, _ExCvt
	add	hl, bc
	ld	a, [hl]
	ld	hl, sp+8
	ld	[hl], a
.l00117:
;src/fatfs/lib/ff.c:3076: if (dbc_1st(c)) {				/* Check if it is a DBC 1st byte */
	ld	hl, sp+8
	ld	a, [hl]
	call	_dbc_1st__far
;src/fatfs/lib/ff.c:3079: sfn[i++] = c;
	ld	hl, sp+5
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $0001
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+11
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+10
	ld	[hl], a
;src/fatfs/lib/ff.c:3076: if (dbc_1st(c)) {				/* Check if it is a DBC 1st byte */
	ld	a, b
	or	a, c
	jp	Z, .l00127
;src/fatfs/lib/ff.c:3077: d = (BYTE)p[si++];			/* Get 2nd byte */
	ld	hl, sp+16
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	dec	hl
	inc	[hl]
	jp	NZ, .l00235
	inc	hl
	inc	[hl]
.l00235:
	pop	hl
	push	hl
	add	hl, bc
	ld	c, l
	ld	b, h
	ld	a, [bc]
	ld	hl, sp+11
	ld	[hl], a
;src/fatfs/lib/ff.c:3078: if (!dbc_2nd(d) || i >= ni - 1) return FR_INVALID_NAME;	/* Reject invalid DBC */
	ld	a, [hl]
	call	_dbc_2nd__far
	ld	a, b
	or	a, c
	jp	Z, .l00118
	ld	hl, sp+7
	dec	hl
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	dec	bc
	ld	hl, sp+4
	ld	a, [hl]
	sub	a, c
	inc	hl
	ld	a, [hl]
	sbc	a, b
	jp	C, .l00119
.l00118:
	ld	a, $06
	jp	.l00136
.l00119:
;src/fatfs/lib/ff.c:3079: sfn[i++] = c;
	ld	hl, sp+4
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	ld	hl, sp+9
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, sp+2
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	add	hl, bc
	ld	c, l
	ld	b, h
	ld	hl, sp+8
	ld	a, [hl]
	ld	[bc], a
;src/fatfs/lib/ff.c:3080: sfn[i++] = d;
	ld	c, e
	ld	b, d
	inc	de
	ld	hl, sp+4
	ld	[hl], e
	inc	hl
	ld	[hl], d
	ld	hl, sp+2
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	add	hl, bc
	ld	c, l
	ld	b, h
	ld	hl, sp+11
	ld	a, [hl]
	ld	[bc], a
	jp	.l00135
.l00127:
;src/fatfs/lib/ff.c:3082: if (strchr("*+,:;<=>[]|\"\?\x7F", (int)c)) return FR_INVALID_NAME;	/* Reject illegal chrs for SFN */
	ld	hl, sp+8
	ld	c, [hl]
	ld	b, $00
	ld	de, ___str_0
	call	_strchr__far
	ld	a, b
	or	a, c
	jp	Z, .l00122
	ld	a, $06
	jp	.l00136
.l00122:
;src/fatfs/lib/ff.c:3083: if (IsLower(c)) c -= 0x20;	/* To upper */
	ld	hl, sp+8
	ld	a, [hl]
	sub	a, $61
	jp	C, .l00124
	ld	a, $7A
	sub	a, [hl]
	jp	C, .l00124
	ld	a, [hl]
	add	a, $E0
	ld	[hl], a
.l00124:
;src/fatfs/lib/ff.c:3084: sfn[i++] = c;
	ld	hl, sp+4
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	ld	hl, sp+9
	ld	a, [hl]
	ld	hl, sp+4
	ld	[hl], a
	ld	hl, sp+10
	ld	a, [hl]
	ld	hl, sp+5
	ld	[hl], a
	ld	hl, sp+2
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	add	hl, bc
	ld	c, l
	ld	b, h
	ld	hl, sp+8
	ld	a, [hl]
	ld	[bc], a
	jp	.l00135
.l00160:
	ld	hl, sp+16
	ld	[hl], c
	inc	hl
	ld	[hl], b
.l00130:
;src/fatfs/lib/ff.c:3087: *path = &p[si];						/* Return pointer to the next segment */
	pop	de
	push	de
	ld	hl, sp+16
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	add	hl, de
	ld	c, l
	ld	b, h
	ld	hl, sp+12
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	ld	[hl], c
	inc	hl
	ld	[hl], b
;src/fatfs/lib/ff.c:3088: if (i == 0) return FR_INVALID_NAME;	/* Reject nul string */
	ld	hl, sp+5
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	jp	NZ, .l00132
	ld	a, $06
	jp	.l00136
.l00132:
;src/fatfs/lib/ff.c:3090: if (sfn[0] == DDEM) sfn[0] = RDDEM;	/* If the first character collides with DDEM, replace it with RDDEM */
	ld	hl, sp+3
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	sub	a, $E5
	jp	NZ,.l00236
	jp	.l00237
.l00236:
	jp	.l00134
.l00237:
	dec	hl
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	ld	[hl], $05
.l00134:
;src/fatfs/lib/ff.c:3091: sfn[NSFLAG] = (c <= ' ' || p[si] <= ' ') ? NS_LAST : 0;	/* Set last segment flag if end of the path */
	ld	hl, sp+3
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $000B
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+18
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+17
	ld	[hl], a
	ld	hl, sp+11
	bit	0, [hl]
	jp	Z, .l00141
	ld	a, [bc]
	ld	c, a
	ld	a, $20
	sub	a, c
	jp	C, .l00138
.l00141:
	ld	bc, $0004
	jp	.l00139
.l00138:
	ld	bc, $0000
.l00139:
	ld	hl, sp+16
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	ld	[hl], c
;src/fatfs/lib/ff.c:3093: return FR_OK;
	xor	a, a
.l00136:
;src/fatfs/lib/ff.c:3095: }
	add	sp, 18
	ret
	SECTION FRAGMENT "src/fatfs/fatfs.c ROM0",ROM0
___str_0:
	DB "*+,:;<=>[]|"
	DB $22
	DB "?"
	DB $7F
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
	call	_create_name
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
	ld	hl, $0030
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
	sub	a, $21
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
	ld	hl, $001C
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
	ld	hl, $0030
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
	ld	hl, $0030
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
	ld	bc, ___str_1
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
___str_1:
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
	ld	hl, $0030
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
	ld	hl, $001C
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
	ld	hl, $0030
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
	ld	hl, $0018
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
	ld	hl, $0014
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
	ld	hl, $0020
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
	ld	hl, $0024
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
	ld	hl, $002C
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
	ld	hl, $0028
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
	ld	hl, $000C
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
	ld	hl, $0010
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
	ld	hl, $0030
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
	add	sp, -61
	ld	hl, sp+55
	ld	[hl], e
	inc	hl
	ld	[hl], d
	ld	hl, sp+53
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
	ld	hl, sp+63
	ld	a, [hl]
	and	a, $3F
	ld	[hl], a
;src/fatfs/lib/ff.c:3820: res = mount_volume(&path, &fs, mode);
	ld	a, [hl]
	push	af
	inc	sp
	ld	hl, 41
	add	hl, sp
	ld	c, l
	ld	b, h
	ld	hl, 54
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_mount_volume__far
	ld	hl, sp+42
	ld	[hl], a
;src/fatfs/lib/ff.c:3822: if (res == FR_OK) {
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00156
;src/fatfs/lib/ff.c:3823: fp->obj.fs = fs;
	ld	hl, sp+56
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, sp+40
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
	ld	hl, sp+41
	ld	a, [hl]
	ld	hl, sp+1
	ld	[hl], a
;src/fatfs/lib/ff.c:3826: res = follow_path(&dj, path);	/* Follow the file path */
	ld	hl, sp+53
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	ld	hl, 0
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_follow_path
	ld	hl, sp+42
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
	ld	hl, sp+42
	ld	[hl], $06
.l00106:
;src/fatfs/lib/ff.c:3819: mode &= FF_FS_READONLY ? FA_READ : FA_READ | FA_WRITE | FA_CREATE_ALWAYS | FA_CREATE_NEW | FA_OPEN_ALWAYS | FA_OPEN_APPEND;
	ld	hl, sp+63
	ld	a, [hl]
	ld	hl, sp+48
	ld	[hl], a
;src/fatfs/lib/ff.c:3854: if (dj.obj.attr & (AM_RDO | AM_DIR)) res = FR_DENIED;	/* Cannot overwrite it (R/O or DIR) */
;src/fatfs/lib/ff.c:3880: st_32(dj.dir + DIR_CrtTime, tm);	/* Set created time */
;src/fatfs/lib/ff.c:3839: if (mode & (FA_CREATE_ALWAYS | FA_OPEN_ALWAYS | FA_CREATE_NEW)) {
	ld	hl, sp+63
	ld	a, [hl]
	and	a, $1C
	jp	NZ,.l00321
	jp	.l00133
.l00321:
;src/fatfs/lib/ff.c:3840: if (res != FR_OK) {					/* No file, create new */
	ld	hl, sp+42
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
	ld	hl, sp+42
	ld	[hl], a
.l00108:
;src/fatfs/lib/ff.c:3848: mode |= FA_CREATE_ALWAYS;		/* File is created */
	ld	hl, sp+63
	ld	a, [hl]
	or	a, $08
	ld	[hl], a
	jp	.l00116
.l00115:
;src/fatfs/lib/ff.c:3851: if (mode & FA_CREATE_NEW) {
	push	hl
	ld	hl, sp+50
	bit	2, [hl]
	pop	hl
	jp	NZ,.l00324
	jp	.l00112
.l00324:
;src/fatfs/lib/ff.c:3852: res = FR_EXIST;				/* Cannot create as new file */
	ld	hl, sp+42
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
	ld	hl, sp+42
	ld	[hl], $07
.l00116:
;src/fatfs/lib/ff.c:3819: mode &= FF_FS_READONLY ? FA_READ : FA_READ | FA_WRITE | FA_CREATE_ALWAYS | FA_CREATE_NEW | FA_OPEN_ALWAYS | FA_OPEN_APPEND;
	ld	hl, sp+63
	ld	a, [hl]
	ld	hl, sp+48
	ld	[hl], a
;src/fatfs/lib/ff.c:3857: if (res == FR_OK && (mode & FA_CREATE_ALWAYS)) {	/* Truncate the file if overwrite mode */
	ld	hl, sp+42
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00134
	push	hl
	ld	hl, sp+50
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
	call	_st_32__far
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
	call	_st_32__far
;src/fatfs/lib/ff.c:3882: cl = ld_clust(fs, dj.dir);			/* Get current cluster chain */
	ld	hl, sp+26
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	ld	hl, sp+40
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_ld_clust__far
	ld	hl, sp+49
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
	ld	hl, sp+44
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
	call	_st_32__far
;src/fatfs/lib/ff.c:3886: fs->wflag = 1;
	ld	hl, sp+40
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	ld	hl, $0004
	add	hl, bc
	ld	[hl], $01
;src/fatfs/lib/ff.c:3887: if (cl != 0) {						/* Remove the cluster chain if exist */
	ld	hl, sp+52
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	dec	hl
	or	a, [hl]
	dec	hl
	or	a, [hl]
	jp	Z, .l00134
;src/fatfs/lib/ff.c:3888: LBA_t sc = fs->winsect;
	ld	hl, sp+40
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	ld	hl, $001C
	add	hl, bc
	ld	e, l
	ld	d, h
	ld	a, [de]
	ld	hl, sp+57
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
	ld	hl, 8
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_remove_chain__far
	ld	hl, sp+42
	ld	[hl], a
;src/fatfs/lib/ff.c:3891: if (res == FR_OK) {
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00134
;src/fatfs/lib/ff.c:3892: res = move_window(fs, sc);
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
	ld	hl, sp+44
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_move_window__far
	ld	hl, sp+42
	ld	[hl], a
;src/fatfs/lib/ff.c:3893: fs->last_clst = cl - 1;		/* Reuse the cluster hole */
	dec	hl
	dec	hl
	ld	a, [hl]
	inc	hl
	ld	b, [hl]
	add	a, $0C
	ld	c, a
	jp	NC, .l00327
	inc	b
.l00327:
	ld	hl, sp+50
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
	ld	hl, sp+60
	ld	[hl], a
	dec	hl
	ld	[hl], e
	ld	hl, sp+54
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
	ld	hl, sp+60
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
	ld	hl, sp+42
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
	ld	hl, sp+42
	ld	[hl], $04
	jp	.l00134
.l00128:
;src/fatfs/lib/ff.c:3904: if ((mode & FA_WRITE) && (dj.obj.attr & AM_RDO)) { /* Write mode open against R/O file */
	push	hl
	ld	hl, sp+50
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
	ld	hl, sp+42
	ld	[hl], $07
.l00134:
;src/fatfs/lib/ff.c:3910: if (res == FR_OK) {
	ld	hl, sp+42
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00138
;src/fatfs/lib/ff.c:3911: if (mode & FA_CREATE_ALWAYS) mode |= FA_MODIFIED;	/* Set file change flag if created or overwritten */
	push	hl
	ld	hl, sp+50
	bit	3, [hl]
	pop	hl
	jp	NZ,.l00331
	jp	.l00136
.l00331:
	ld	hl, sp+48
	ld	a, [hl]
	or	a, $40
	ld	hl, sp+63
	ld	[hl], a
.l00136:
;src/fatfs/lib/ff.c:3912: fp->dir_sect = fs->winsect;			/* Pointer to the directory entry */
	ld	hl, sp+56
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $001C
	add	hl, de
	ld	c, l
	ld	b, h
	ld	hl, sp+40
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $001C
	add	hl, de
	ld	e, l
	ld	d, h
	ld	a, [de]
	ld	hl, sp+57
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
	ld	hl, sp+57
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
	ld	hl, sp+56
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
	ld	hl, sp+59
	ld	[hl], a
	ld	hl, sp+27
	ld	a, [hl]
	ld	hl, sp+60
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
	ld	hl, sp+42
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00156
;src/fatfs/lib/ff.c:3939: fp->obj.sclust = ld_clust(fs, dj.dir);					/* Get object allocation info */
	ld	hl, sp+56
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $0006
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+59
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+58
	ld	[hl], a
	ld	hl, sp+26
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	ld	hl, sp+40
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_ld_clust__far
	ld	hl, sp+49
	ld	[hl], c
	inc	hl
	ld	[hl], b
	inc	hl
	ld	[hl], e
	inc	hl
	ld	[hl], d
	ld	hl, sp+58
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, sp+49
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
	ld	hl, sp+56
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $000A
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+61
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+60
	ld	[hl], a
	ld	hl, sp+26
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	ld	hl, $001C
	add	hl, bc
	ld	e, l
	ld	d, h
	call	_ld_32__far
	ld	hl, sp+49
	ld	[hl], c
	inc	hl
	ld	[hl], b
	inc	hl
	ld	[hl], e
	inc	hl
	ld	[hl], d
	ld	hl, sp+60
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, sp+49
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
	ld	hl, sp+55
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	inc	bc
	inc	bc
	ld	hl, sp+40
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $0006
	add	hl, de
	ld	e, l
	ld	d, h
	ld	a, [de]
	ld	hl, sp+51
	ld	[hl], a
	inc	de
	ld	a, [de]
	inc	hl
	ld	[hl], a
	ld	hl, sp+51
	ld	a, [hl]
	ld	[bc], a
	inc	bc
	inc	hl
	ld	a, [hl]
	ld	[bc], a
;src/fatfs/lib/ff.c:3946: fp->flag = mode;	/* Set file access mode */
	ld	hl, sp+56
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $000E
	add	hl, de
	ld	c, l
	ld	b, h
	ld	hl, sp+63
	ld	a, [hl]
	ld	[bc], a
;src/fatfs/lib/ff.c:3947: fp->err = 0;		/* Clear error flag */
	ld	hl, sp+56
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
	ld	hl, sp+56
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $0018
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+45
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+44
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
	ld	hl, sp+56
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
	ld	hl, sp+63
	ld	a, [hl]
	bit	5, a
	jp	NZ,.l00332
	jp	.l00156
.l00332:
	ld	hl, sp+60
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	ld	hl, sp+49
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
	ld	hl, sp+40
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
	ld	hl, sp+45
	ld	[hl], c
	inc	hl
	ld	[hl], b
	inc	hl
	ld	[hl], e
	inc	hl
	ld	[hl], d
;src/fatfs/lib/ff.c:3960: clst = fp->obj.sclust;				/* Follow the cluster chain */
	ld	hl, sp+58
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	ld	hl, sp+49
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
	ld	hl, sp+60
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	ld	hl, sp+57
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
	ld	hl, sp+42
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00143
	ld	hl, sp+45
	ld	e, l
	ld	d, h
	ld	hl, sp+57
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
	ld	hl, sp+51
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	push	de
	ld	hl, sp+51
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	push	de
	ld	hl, sp+59
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_get_fat
	ld	hl, sp+49
	ld	[hl], c
	inc	hl
	ld	[hl], b
	inc	hl
	ld	[hl], e
	inc	hl
	ld	[hl], d
;src/fatfs/lib/ff.c:3963: if (clst <= 1) res = FR_INT_ERR;
	ld	hl, sp+49
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
	ld	hl, sp+42
	ld	[hl], $02
.l00140:
;src/fatfs/lib/ff.c:3964: if (clst == 0xFFFFFFFF) res = FR_DISK_ERR;
	ld	hl, sp+49
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
	ld	hl, sp+42
	ld	[hl], $01
.l00162:
;src/fatfs/lib/ff.c:3961: for (ofs = fp->obj.objsize; res == FR_OK && ofs > bcs; ofs -= bcs) {
	ld	hl, sp+58
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, e
	ld	hl, sp+45
	sub	a, [hl]
	ld	e, a
	ld	a, d
	inc	hl
	sbc	a, [hl]
	push	af
	ld	hl, sp+60
	ld	[hl], a
	dec	hl
	ld	[hl], e
	ld	hl, sp+62
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, sp+49
	pop	af
	ld	a, e
	sbc	a, [hl]
	ld	e, a
	ld	a, d
	inc	hl
	sbc	a, [hl]
	ld	hl, sp+60
	ld	[hl], a
	dec	hl
	ld	[hl], e
	jp	.l00161
.l00143:
;src/fatfs/lib/ff.c:3966: fp->clust = clst;
	ld	hl, sp+56
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $0014
	add	hl, de
	ld	c, l
	ld	b, h
	ld	hl, sp+49
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
	ld	hl, sp+42
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00156
	ld	hl, sp+57
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
	ld	hl, sp+51
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	push	de
	ld	hl, sp+51
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	push	de
	ld	hl, sp+44
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_clst2sect
	ld	hl, sp+49
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
	ld	hl, sp+42
	ld	[hl], $02
	jp	.l00156
.l00145:
;src/fatfs/lib/ff.c:3973: fp->sect = sec + (DWORD)(ofs / SS(fs));
	ld	a, $09
.l00338:
	ld	hl, sp+60
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
	ld	hl, sp+50
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, e
	ld	hl, sp+57
	add	a, [hl]
	ld	e, a
	ld	a, d
	inc	hl
	adc	a, [hl]
	push	af
	ld	hl, sp+48
	ld	[hl], a
	dec	hl
	ld	[hl], e
	ld	hl, sp+54
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, sp+61
	pop	af
	ld	a, e
	adc	a, [hl]
	ld	e, a
	ld	a, d
	inc	hl
	adc	a, [hl]
	ld	hl, sp+48
	ld	[hl], a
	dec	hl
	ld	[hl], e
	ld	hl, sp+44
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
	ld	hl, sp+42
	ld	a, [hl]
	or	a, a
	jp	Z, .l00158
	ld	hl, sp+55
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	xor	a, a
	ld	[hl], a
	inc	hl
	ld	[hl], a
.l00158:
;src/fatfs/lib/ff.c:3991: LEAVE_FF(fs, res);
	ld	hl, sp+42
	ld	a, [hl]
.l00163:
;src/fatfs/lib/ff.c:3992: }
	add	sp, 61
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
	ld	hl, $001C
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
	ld	hl, $0030
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
	ld	hl, $0030
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
	ld	hl, $001C
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
	ld	hl, $001C
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
	ld	hl, $0030
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
	add	a, $1C
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
	ld	hl, $0030
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
	ld	hl, $0014
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
	ld	hl, $0009
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
	call	_get_fileinfo
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
;src/fatfs/fatfs.c:31: void* memcpy(void* dest, const void* src, size_t n) {
;	---------------------------------
	SECTION FRAGMENT "src/fatfs/fatfs.c ROM0",ROM0
; Function __memcpy
; ---------------------------------
___memcpy::
	add	sp, -6
	inc	sp
	inc	sp
	push	de
;src/fatfs/fatfs.c:32: BYTE* d = dest;
	ld	hl, sp+0
	ld	a, [hl]
	inc	hl
	inc	hl
	ld	[hl], a
	dec	hl
	ld	a, [hl]
	inc	hl
	inc	hl
	ld	[hl], a
;src/fatfs/fatfs.c:33: const BYTE* s = src;
	inc	hl
	ld	[hl], c
	inc	hl
	ld	[hl], b
;src/fatfs/fatfs.c:34: while (n--) *d++ = *s++;
	ld	hl, sp+8
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
.l00101:
	ld	a, c
	ld	e, b
	dec	bc
	or	a, e
	jp	Z, .l00103
	ld	hl, sp+5
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	dec	hl
	inc	[hl]
	jp	NZ, .l00117
	inc	hl
	inc	[hl]
.l00117:
	ld	hl, sp+2
	push	af
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	pop	af
	ld	[hl], a
	ld	hl, sp+2
	inc	[hl]
	jp	NZ, .l00118
	inc	hl
	inc	[hl]
.l00118:
	jp	.l00101
.l00103:
;src/fatfs/fatfs.c:35: return dest;
	pop	bc
	push	bc
.l00104:
;src/fatfs/fatfs.c:36: }
	add	sp, 6
	pop	hl
	inc	sp
	inc	sp
	jp hl 
;src/fatfs/fatfs.c:38: void* memset(void* dest, int c, size_t n) {
;	---------------------------------
	SECTION FRAGMENT "src/fatfs/fatfs.c B",ROMX
; Function memset
; ---------------------------------
_memset::
	add	sp, -6
	ld	hl, sp+2
	ld	[hl], e
	inc	hl
	ld	[hl], d
	inc	sp
	inc	sp
	push	bc
;src/fatfs/fatfs.c:39: BYTE* d = dest;
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
;src/fatfs/fatfs.c:40: while (n--) *d++ = (BYTE)c;
	ld	hl, sp+8
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
.l00101:
	ld	a, c
	ld	e, b
	dec	bc
	or	a, e
	jp	Z, .l00103
	ld	hl, sp+0
	ld	a, [hl]
	ld	hl, sp+4
	push	af
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	pop	af
	ld	[hl], a
	ld	hl, sp+4
	inc	[hl]
	jp	NZ, .l00117
	inc	hl
	inc	[hl]
.l00117:
	jp	.l00101
.l00103:
;src/fatfs/fatfs.c:41: return dest;
	pop	hl
	pop	bc
	push	bc
	push	hl
.l00104:
;src/fatfs/fatfs.c:42: }
	add	sp, 6
	pop	hl
	inc	sp
	inc	sp
	jp hl 
;src/fatfs/fatfs.c:44: int memcmp(const void* a, const void* b, size_t n) {
;	---------------------------------
	SECTION FRAGMENT "src/fatfs/fatfs.c B",ROMX
; Function memcmp
; ---------------------------------
_memcmp::
	add	sp, -4
	ld	l, e
;	spillPairReg hl
;	spillPairReg hl
	ld	h, d
;	spillPairReg hl
;	spillPairReg hl
	ld	e, c
	ld	d, b
;src/fatfs/fatfs.c:45: const BYTE* x = a;
	ld	c, l
	ld	b, h
;src/fatfs/fatfs.c:46: const BYTE* y = b;
	inc	sp
	inc	sp
	push	de
;src/fatfs/fatfs.c:48: return 0;
	ld	hl, sp+6
	ld	a, [hl]
	ld	hl, sp+2
	ld	[hl], a
	ld	hl, sp+7
	ld	a, [hl]
	ld	hl, sp+3
	ld	[hl], a
.l00105:
;src/fatfs/fatfs.c:47: for (; n; --n, ++x, ++y) if (*x != *y) return *x - *y;
	ld	hl, sp+3
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	jp	Z, .l00103
	ld	a, [bc]
	pop	de
	push	de
	push	af
	ld	a, [de]
	ld	l, a
;	spillPairReg hl
;	spillPairReg hl
	pop	af
	cp	a, l
	jp	NZ,.l00124
	jp	.l00106
.l00124:
	ld	c, a
	ld	b, $00
	ld	e, $00
	ld	a, c
	sub	a, l
	ld	c, a
	ld	a, b
	sbc	a, e
	ld	b, a
	jp	.l00107
.l00106:
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
	inc	bc
	ld	hl, sp+0
	inc	[hl]
	jp	NZ, .l00125
	inc	hl
	inc	[hl]
.l00125:
	jp	.l00105
.l00103:
;src/fatfs/fatfs.c:48: return 0;
	ld	bc, $0000
.l00107:
;src/fatfs/fatfs.c:49: }
	add	sp, 4
	pop	hl
	inc	sp
	inc	sp
	jp hl 
;src/fatfs/fatfs.c:53: char* strchr(const char* s, int c) {
;	---------------------------------
	SECTION FRAGMENT "src/fatfs/fatfs.c B",ROMX
; Function strchr
; ---------------------------------
_strchr::
	add	sp, -7
	ld	hl, sp+3
	ld	[hl], e
	inc	hl
	ld	[hl], d
	ld	hl, sp+1
	ld	[hl], c
	inc	hl
	ld	[hl], b
;src/fatfs/fatfs.c:55: return c ? 0 : (char*)s;
	inc	hl
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
;src/fatfs/fatfs.c:54: for (; *s; ++s) if (*s == (char)c) return (char*)s;
	ld	hl, sp+6
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	ld	hl, sp+0
	ld	[hl], a
	ld	a, [hl]
	or	a, a
	jp	Z, .l00103
	inc	hl
	ld	c, [hl]
	dec	hl
	ld	a, [hl]
	sub	a, c
	jp	NZ,.l00131
	jp	.l00132
.l00131:
	jp	.l00106
.l00132:
	ld	hl, sp+3
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	jp	.l00107
.l00106:
	ld	hl, sp+5
	inc	[hl]
	jp	NZ, .l00133
	inc	hl
	inc	[hl]
.l00133:
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
	jp	.l00105
.l00103:
;src/fatfs/fatfs.c:55: return c ? 0 : (char*)s;
	ld	hl, sp+2
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	jp	Z, .l00109
	xor	a, a
	ld	hl, sp+5
	ld	[hl], a
	inc	hl
	ld	[hl], a
	jp	.l00110
.l00109:
	ld	hl, sp+3
	ld	a, [hl]
	inc	hl
	inc	hl
	ld	[hl], a
	dec	hl
	ld	a, [hl]
	inc	hl
	inc	hl
	ld	[hl], a
.l00110:
	ld	hl, sp+5
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
.l00107:
;src/fatfs/fatfs.c:56: }
	add	sp, 7
	ret
;src/fatfs/fatfs.c:58: DSTATUS disk_status(BYTE pdrv) {
;	---------------------------------
	SECTION FRAGMENT "src/fatfs/fatfs.c B",ROMX
; Function disk_status
; ---------------------------------
_disk_status::
;src/fatfs/fatfs.c:60: return disk_ready ? 0 : STA_NOINIT;
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
;src/fatfs/fatfs.c:61: }
	ret
;src/fatfs/fatfs.c:63: DSTATUS disk_initialize(BYTE pdrv) {
;	---------------------------------
	SECTION FRAGMENT "src/fatfs/fatfs.c B",ROMX
; Function disk_initialize
; ---------------------------------
_disk_initialize::
	ld	l, a
;	spillPairReg hl
;	spillPairReg hl
;src/fatfs/fatfs.c:64: disk_ready = !sd_Init();
	push	hl
	call	_sd_Init
	pop	hl
	sub	a,$01
	ld	a, $00
	rla
	ld	[_disk_ready], a
;src/fatfs/fatfs.c:65: return disk_status(pdrv);
	ld	a, l
	jp	_disk_status
.l00101:
;src/fatfs/fatfs.c:66: }
	ret
;src/fatfs/fatfs.c:68: DRESULT disk_read(BYTE pdrv, BYTE* buff, LBA_t sector, UINT count) {
;	---------------------------------
	SECTION FRAGMENT "src/fatfs/fatfs.c B",ROMX
; Function disk_read
; ---------------------------------
_disk_read::
	add	sp, -6
	inc	sp
	inc	sp
	push	de
;src/fatfs/fatfs.c:69: (void)pdrv;
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
;src/fatfs/fatfs.c:70: for (; count; --count, ++sector, buff += FF_MAX_SS) {
	ld	a, b
	or	a, c
	jp	Z, .l00103
;src/fatfs/fatfs.c:71: sd_sector = sector;
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
;src/fatfs/fatfs.c:72: if (sd_ReadSector(buff)) return RES_ERROR;
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
;src/fatfs/fatfs.c:70: for (; count; --count, ++sector, buff += FF_MAX_SS) {
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
;src/fatfs/fatfs.c:74: return RES_OK;
	xor	a, a
.l00107:
;src/fatfs/fatfs.c:75: }
	add	sp, 6
	pop	hl
	add	sp, 6
	jp hl 
;src/fatfs/fatfs.c:77: DRESULT disk_write(BYTE pdrv, const BYTE* buff, LBA_t sector, UINT count) {
;	---------------------------------
	SECTION FRAGMENT "src/fatfs/fatfs.c B",ROMX
; Function disk_write
; ---------------------------------
_disk_write::
	add	sp, -6
	inc	sp
	inc	sp
	push	de
;src/fatfs/fatfs.c:78: (void)pdrv;
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
;src/fatfs/fatfs.c:79: for (; count; --count, ++sector, buff += FF_MAX_SS) {
	ld	a, b
	or	a, c
	jp	Z, .l00103
;src/fatfs/fatfs.c:80: sd_sector = sector;
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
;src/fatfs/fatfs.c:81: if (sd_WriteSector(buff)) return RES_ERROR;
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
;src/fatfs/fatfs.c:79: for (; count; --count, ++sector, buff += FF_MAX_SS) {
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
;src/fatfs/fatfs.c:83: return RES_OK;
	xor	a, a
.l00107:
;src/fatfs/fatfs.c:84: }
	add	sp, 6
	pop	hl
	add	sp, 6
	jp hl 
;src/fatfs/fatfs.c:86: DRESULT disk_ioctl(BYTE pdrv, BYTE cmd, void* buff) {
;	---------------------------------
	SECTION FRAGMENT "src/fatfs/fatfs.c B",ROMX
; Function disk_ioctl
; ---------------------------------
_disk_ioctl::
;src/fatfs/fatfs.c:89: return cmd == CTRL_SYNC ? RES_OK : RES_PARERR;
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
;src/fatfs/fatfs.c:90: }
	pop	hl
	inc	sp
	inc	sp
	jp hl 
;src/fatfs/fatfs.c:92: unsigned char fs_Mount(void) {
;	---------------------------------
	SECTION FRAGMENT "src/fatfs/fatfs.c A",ROMX
; Function fs_Mount
; ---------------------------------
_fs_Mount::
;src/fatfs/fatfs.c:93: return f_mount(&fs, "", 1);
	ld	a, $01
	push	af
	inc	sp
	ld	bc, ___str_2
	ld	de, _fs
	call	_f_mount__far
.l00101:
;src/fatfs/fatfs.c:94: }
	ret
	SECTION FRAGMENT "src/fatfs/fatfs.c ROM0",ROM0
___str_2:
	DB $00
;src/fatfs/fatfs.c:96: unsigned char fs_OpenDir(void) {
;	---------------------------------
	SECTION FRAGMENT "src/fatfs/fatfs.c A",ROMX
; Function fs_OpenDir
; ---------------------------------
_fs_OpenDir::
;src/fatfs/fatfs.c:97: return f_opendir(&dir, "");
	ld	bc, ___str_3
	ld	de, _dir
	jp	_f_opendir
.l00101:
;src/fatfs/fatfs.c:98: }
	ret
	SECTION FRAGMENT "src/fatfs/fatfs.c ROM0",ROM0
___str_3:
	DB $00
;src/fatfs/fatfs.c:101: unsigned char fs_NextFile(char* name) {
;	---------------------------------
	SECTION FRAGMENT "src/fatfs/fatfs.c A",ROMX
; Function fs_NextFile
; ---------------------------------
_fs_NextFile::
	add	sp, -4
	ld	hl, sp+2
	ld	[hl], e
	inc	hl
	ld	[hl], d
;src/fatfs/fatfs.c:103: while (f_readdir(&dir, &info) == FR_OK && info.fname[0]) {
.l00110:
	ld	bc, _info
	ld	de, _dir
	call	_f_readdir
	ld	hl, sp+1
	ld	[hl], a
	ld	hl, sp+1
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00112
	ld	a, [(_info + 9) + 0]
	or	a, a
	jp	Z, .l00112
;src/fatfs/fatfs.c:104: if (info.fattrib & (AM_DIR | AM_HID | AM_SYS)) continue;
	ld	a, [(_info + 8) + 0]
	and	a, $16
	jp	NZ,.l00160
	jp	.l00161
.l00160:
	jp	.l00110
.l00161:
;src/fatfs/fatfs.c:105: ext = strchr(info.fname, '.');
	ld	bc, $002E
	ld	de, (_info + 9)
	call	_strchr__far
;src/fatfs/fatfs.c:106: if (!ext || ext[1] != 'T' || ext[2] != 'X' || ext[3] != 'T' || ext[4]) continue;
	ld	a, b
	or	a, c
	jp	Z, .l00110
	ld	e, c
	ld	d, b
	inc	de
	ld	a, [de]
	sub	a, $54
	jp	NZ,.l00162
	jp	.l00163
.l00162:
	jp	.l00110
.l00163:
	ld	e, c
	ld	d, b
	inc	de
	inc	de
	ld	a, [de]
	sub	a, $58
	jp	NZ,.l00164
	jp	.l00165
.l00164:
	jp	.l00110
.l00165:
	ld	e, c
	ld	d, b
	inc	de
	inc	de
	inc	de
	ld	a, [de]
	sub	a, $54
	jp	NZ,.l00166
	jp	.l00167
.l00166:
	jp	.l00110
.l00167:
	inc	bc
	inc	bc
	inc	bc
	inc	bc
	ld	a, [bc]
	or	a, a
	jp	NZ, .l00110
;src/fatfs/fatfs.c:107: memcpy(name, info.fname, sizeof info.fname);
	ld	hl, sp+2
	ld	a, [hl]
	dec	hl
	dec	hl
	ld	[hl], a
	ld	hl, sp+3
	ld	a, [hl]
	dec	hl
	dec	hl
	ld	[hl], a
	ld	de, $000D
	push	de
	ld	bc, (_info + 9)
	pop	hl
	pop	de
	push	de
	push	hl
	call	___memcpy
;src/fatfs/fatfs.c:108: return 1;
	ld	a, $01
	jp	.l00113
.l00112:
;src/fatfs/fatfs.c:110: f_closedir(&dir);
	ld	de, _dir
	call	_f_closedir
;src/fatfs/fatfs.c:111: return 0;
	xor	a, a
.l00113:
;src/fatfs/fatfs.c:112: }
	add	sp, 4
	ret
;src/fatfs/fatfs.c:115: static UINT RemoveCR(UINT count) {
;	---------------------------------
	SECTION FRAGMENT "src/fatfs/fatfs.c A",ROMX
; Function RemoveCR
; ---------------------------------
_RemoveCR:
	add	sp, -4
	inc	sp
	inc	sp
	push	de
;src/fatfs/fatfs.c:116: BYTE* src = buffer;
	ld	bc, _buffer
;src/fatfs/fatfs.c:117: BYTE* dest = buffer;
	ld	hl, sp+2
	ld	a, LOW(_buffer)
	ld	[hl], a
	inc	hl
	ld	a, HIGH(_buffer)
	ld	[hl], a
;src/fatfs/fatfs.c:122: return (UINT)(dest - buffer);
.l00106:
;src/fatfs/fatfs.c:118: for (; count; --count, ++src) {
	ld	hl, sp+1
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	jp	Z, .l00104
;src/fatfs/fatfs.c:119: if (*src == '\r') fs_crlf = 1;
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
;src/fatfs/fatfs.c:120: else *dest++ = *src;
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
;src/fatfs/fatfs.c:118: for (; count; --count, ++src) {
	pop	de
	push	de
	dec	de
	inc	sp
	inc	sp
	push	de
	inc	bc
	jp	.l00106
.l00104:
;src/fatfs/fatfs.c:122: return (UINT)(dest - buffer);
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
;src/fatfs/fatfs.c:123: }
	add	sp, 4
	ret
;src/fatfs/fatfs.c:126: unsigned char fs_Load(const char* name) {
;	---------------------------------
	SECTION FRAGMENT "src/fatfs/fatfs.c A",ROMX
; Function fs_Load
; ---------------------------------
_fs_Load::
	add	sp, -5
	ld	c, e
	ld	b, d
;src/fatfs/fatfs.c:128: FRESULT result = f_open(&file, name, FA_READ);
	ld	a, $01
	push	af
	inc	sp
	ld	de, _file
	call	_f_open
;src/fatfs/fatfs.c:129: if (result) return result;
	or	a, a
	jp	Z, .l00102
	jp	.l00110
.l00102:
;src/fatfs/fatfs.c:130: tb_Clear();
	call	_tb_Clear
;src/fatfs/fatfs.c:131: fs_crlf = 0;
	ld	hl, _fs_crlf
	ld	[hl], $00
;src/fatfs/fatfs.c:132: do {
.l00107:
;src/fatfs/fatfs.c:133: result = f_read(&file, buffer, BUFFER_SIZE, &count);
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
;src/fatfs/fatfs.c:134: if (result) break;
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00109
;src/fatfs/fatfs.c:135: if (!tb_Append(buffer, RemoveCR(count))) {
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
;src/fatfs/fatfs.c:136: result = FR_DENIED;
	ld	hl, sp+2
	ld	[hl], $07
;src/fatfs/fatfs.c:137: break;
	jp	.l00109
.l00108:
;src/fatfs/fatfs.c:139: } while (count == BUFFER_SIZE);
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
;src/fatfs/fatfs.c:140: f_close(&file);
	ld	de, _file
	call	_f_close__far
;src/fatfs/fatfs.c:141: return result;
	ld	hl, sp+2
	ld	a, [hl]
.l00110:
;src/fatfs/fatfs.c:142: }
	add	sp, 5
	ret
;src/fatfs/fatfs.c:146: static UINT AddCR(UINT count) {
;	---------------------------------
	SECTION FRAGMENT "src/fatfs/fatfs.c A",ROMX
; Function AddCR
; ---------------------------------
_AddCR:
	add	sp, -4
;src/fatfs/fatfs.c:147: BYTE* src = buffer + BUFFER_SIZE / 2;
;src/fatfs/fatfs.c:148: BYTE* dest = buffer;
	ld	hl, sp+0
	ld	a, LOW(_buffer)
	ld	[hl], a
	inc	hl
	ld	a, HIGH(_buffer)
	ld	[hl], a
;src/fatfs/fatfs.c:149: tb_Read(src, count);
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
;src/fatfs/fatfs.c:150: for (; count; --count) {
	ld	hl, sp+3
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	jp	Z, .l00103
;src/fatfs/fatfs.c:151: if (*src == '\n') *dest++ = '\r';
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
;src/fatfs/fatfs.c:152: *dest++ = *src++;
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
;src/fatfs/fatfs.c:150: for (; count; --count) {
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
;src/fatfs/fatfs.c:154: return (UINT)(dest - buffer);
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
;src/fatfs/fatfs.c:155: }
	add	sp, 4
	ret
;src/fatfs/fatfs.c:158: unsigned char fs_Save(const char* name) {
;	---------------------------------
	SECTION FRAGMENT "src/fatfs/fatfs.c A",ROMX
; Function fs_Save
; ---------------------------------
_fs_Save::
	add	sp, -9
	ld	c, e
	ld	b, d
;src/fatfs/fatfs.c:161: FRESULT result = f_open(&file, name, FA_WRITE | FA_CREATE_ALWAYS);
	ld	a, $0A
	push	af
	inc	sp
	ld	de, _file
	call	_f_open
	ld	hl, sp+6
	ld	[hl], a
;src/fatfs/fatfs.c:162: if (result) return result;
	ld	a, [hl]
	or	a, a
	jp	Z, .l00102
	ld	a, [hl]
	jp	.l00116
.l00102:
;src/fatfs/fatfs.c:163: left = tb_Length();
	call	_tb_Length
	ld	hl, sp+7
	ld	[hl], c
	inc	hl
	ld	[hl], b
;src/fatfs/fatfs.c:164: tb_read_pos = 0;
	xor	a, a
	ld	hl, _tb_read_pos
	ld	[hl], a
	inc	hl
	ld	[hl], a
;src/fatfs/fatfs.c:165: while (left) {
.l00110:
	ld	hl, sp+8
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	jp	Z, .l00112
;src/fatfs/fatfs.c:166: if (fs_crlf) {
	ld	hl, _fs_crlf
	ld	a, [hl]
	or	a, a
	jp	Z, .l00104
;src/fatfs/fatfs.c:167: count = left < BUFFER_SIZE / 2 ? left : BUFFER_SIZE / 2;
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
;src/fatfs/fatfs.c:168: size = AddCR(count);
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
;src/fatfs/fatfs.c:170: count = left < BUFFER_SIZE ? left : BUFFER_SIZE;
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
;src/fatfs/fatfs.c:171: tb_Read(buffer, count);
	pop	hl
	pop	bc
	push	bc
	push	hl
	ld	de, _buffer
	call	_tb_Read
;src/fatfs/fatfs.c:172: size = count;
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
;src/fatfs/fatfs.c:174: result = f_write(&file, buffer, size, &written);
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
;src/fatfs/fatfs.c:175: if (result) break;
	ld	hl, sp+6
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00112
;src/fatfs/fatfs.c:176: if (written != size) {
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
;src/fatfs/fatfs.c:177: result = FR_DENIED; // disk full
	ld	hl, sp+6
	ld	[hl], $07
;src/fatfs/fatfs.c:178: break;
	jp	.l00112
.l00109:
;src/fatfs/fatfs.c:180: left -= count;
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
;src/fatfs/fatfs.c:182: if (f_close(&file) && !result) result = FR_DISK_ERR;
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
;src/fatfs/fatfs.c:183: return result;
	ld	hl, sp+6
	ld	a, [hl]
.l00116:
;src/fatfs/fatfs.c:184: }
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
_create_chain__far:
	ld [far_a], a
	ld a, LOW(_create_chain)
	ld [far_target], a
	ld a, HIGH(_create_chain)
	ld [far_target+1], a
	ld a, BANK(_create_chain)
	jp FarCall
_dbc_1st__far:
	ld [far_a], a
	ld a, LOW(_dbc_1st)
	ld [far_target], a
	ld a, HIGH(_dbc_1st)
	ld [far_target+1], a
	ld a, BANK(_dbc_1st)
	jp FarCall
_dbc_2nd__far:
	ld [far_a], a
	ld a, LOW(_dbc_2nd)
	ld [far_target], a
	ld a, HIGH(_dbc_2nd)
	ld [far_target+1], a
	ld a, BANK(_dbc_2nd)
	jp FarCall
_dir_clear__far:
	ld [far_a], a
	ld a, LOW(_dir_clear)
	ld [far_target], a
	ld a, HIGH(_dir_clear)
	ld [far_target+1], a
	ld a, BANK(_dir_clear)
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
_get_fat__far:
	ld [far_a], a
	ld a, LOW(_get_fat)
	ld [far_target], a
	ld a, HIGH(_get_fat)
	ld [far_target+1], a
	ld a, BANK(_get_fat)
	jp FarCall
_ld_16__far:
	ld [far_a], a
	ld a, LOW(_ld_16)
	ld [far_target], a
	ld a, HIGH(_ld_16)
	ld [far_target+1], a
	ld a, BANK(_ld_16)
	jp FarCall
_ld_32__far:
	ld [far_a], a
	ld a, LOW(_ld_32)
	ld [far_target], a
	ld a, HIGH(_ld_32)
	ld [far_target+1], a
	ld a, BANK(_ld_32)
	jp FarCall
_ld_clust__far:
	ld [far_a], a
	ld a, LOW(_ld_clust)
	ld [far_target], a
	ld a, HIGH(_ld_clust)
	ld [far_target+1], a
	ld a, BANK(_ld_clust)
	jp FarCall
_memcmp__far:
	ld [far_a], a
	ld a, LOW(_memcmp)
	ld [far_target], a
	ld a, HIGH(_memcmp)
	ld [far_target+1], a
	ld a, BANK(_memcmp)
	jp FarCall
_memset__far:
	ld [far_a], a
	ld a, LOW(_memset)
	ld [far_target], a
	ld a, HIGH(_memset)
	ld [far_target+1], a
	ld a, BANK(_memset)
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
_remove_chain__far:
	ld [far_a], a
	ld a, LOW(_remove_chain)
	ld [far_target], a
	ld a, HIGH(_remove_chain)
	ld [far_target+1], a
	ld a, BANK(_remove_chain)
	jp FarCall
_st_32__far:
	ld [far_a], a
	ld a, LOW(_st_32)
	ld [far_target], a
	ld a, HIGH(_st_32)
	ld [far_target+1], a
	ld a, BANK(_st_32)
	jp FarCall
_st_clust__far:
	ld [far_a], a
	ld a, LOW(_st_clust)
	ld [far_target], a
	ld a, HIGH(_st_clust)
	ld [far_target+1], a
	ld a, BANK(_st_clust)
	jp FarCall
_strchr__far:
	ld [far_a], a
	ld a, LOW(_strchr)
	ld [far_target], a
	ld a, HIGH(_strchr)
	ld [far_target+1], a
	ld a, BANK(_strchr)
	jp FarCall
_validate__far:
	ld [far_a], a
	ld a, LOW(_validate)
	ld [far_target], a
	ld a, HIGH(_validate)
	ld [far_target+1], a
	ld a, BANK(_validate)
	jp FarCall