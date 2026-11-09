;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 4.2.0 #13081 (Linux)
;--------------------------------------------------------
	; MODULE fatfs
	; Generated using the rgbds tokens.

;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	EXPORT _tb_ClipLength
	EXPORT _tb_Length
	EXPORT _fs_GameFinish
	EXPORT _fs_Snapshot
	EXPORT _fs_GameCopy
	EXPORT _fs_GameOpen
	EXPORT _sd_ReadBlocks
	EXPORT _fs_BackupSave
	EXPORT _ByteSum
	EXPORT _fs_SaveLarge
	EXPORT _fs_CommitWindow
	EXPORT _fs_ScanStep
	EXPORT _fs_DocLineStart
	EXPORT _fs_LoadLarge
	EXPORT _fs_CloseLarge
	EXPORT _tb_Empty
	EXPORT _tb_Clear
	EXPORT _CountLF
	EXPORT _SetWindowBlock
	EXPORT _tb_ReadLines
	EXPORT _tb_Read
	EXPORT _tb_Append
	EXPORT _sd_WriteSector
	EXPORT _sd_ReadSector
	EXPORT _sd_Init
	EXPORT ___memcpy
	EXPORT _memset
	EXPORT _strchr
	EXPORT _memcmp
	EXPORT _ClockAdvance
	EXPORT _ClockFatTime
	EXPORT _ClockRead
	EXPORT _swap_sum
	EXPORT _list_error
	EXPORT _mark_shift
	EXPORT _read_kind
	EXPORT _read_next
	EXPORT _mark_mask
	EXPORT _list_start
	EXPORT _list_slot
	EXPORT _list_counts
	EXPORT _fs_found
	EXPORT _fs_count
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
	EXPORT _f_stat
	EXPORT _f_getfree
	EXPORT _f_truncate
	EXPORT _f_unlink
	EXPORT _f_mkdir
	EXPORT _f_rename
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
	EXPORT _fs_List
	EXPORT _fs_ListEntry
	EXPORT _fs_Load
	EXPORT _fs_LoadData
	EXPORT _fs_LoadWindow
	EXPORT _fs_SaveSwap
	EXPORT _fs_LoadSwap
	EXPORT _fs_Save
	EXPORT _get_fattime
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
_fs_count:
	DS 2
_fs_found:
	DS 2
_list_counts:
	DS 4
_list_slot:
	DS 2
_list_start:
	DS 2
_mark_mask:
	DS 2
_read_next:
	DS 2
_read_kind:
	DS 1
_mark_shift:
	DS 1
_list_error:
	DS 1
_swap_sum:
	DS 2
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
	SECTION FRAGMENT "Page 11",ROMX,BANK[5]
	LOAD FRAGMENT "Page 11 RAM",SRAM,BANK[11]
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
	SECTION FRAGMENT "Page 11",ROMX,BANK[5]
	LOAD FRAGMENT "Page 11 RAM",SRAM,BANK[11]
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
	SECTION FRAGMENT "Page 10",ROMX,BANK[5]
	LOAD FRAGMENT "Page 10 RAM",SRAM,BANK[10]
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
	call	_disk_write__far
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
	call	_disk_write__far
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
	SECTION FRAGMENT "Page 10",ROMX,BANK[5]
	LOAD FRAGMENT "Page 10 RAM",SRAM,BANK[10]
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
	call	_disk_read__far
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
	SECTION FRAGMENT "Page 9",ROMX,BANK[4]
	LOAD FRAGMENT "Page 9 RAM",SRAM,BANK[9]
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
	call	_sync_window__far
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
	SECTION FRAGMENT "Page 8",ROMX,BANK[4]
	LOAD FRAGMENT "Page 8 RAM",SRAM,BANK[8]
; Function clst2sect
; ---------------------------------
_clst2sect:
	add	sp, -8
	ld	c, e
	ld	b, d
;src/fatfs/lib/ff.c:1167: clst -= 2;		/* Cluster number is origin from 2 */
	ld	hl, sp+11
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
	ld	hl, sp+15
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
	pop	de
	push	de
	ld	a, e
	sub	a, $02
	ld	e, a
	ld	a, d
	sbc	a, $00
	push	af
	ld	hl, sp+7
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
	ld	hl, sp+7
	ld	[hl], a
	dec	hl
	ld	[hl], e
	ld	hl, sp+10
	ld	e, l
	ld	d, h
	ld	hl, sp+4
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
	jp	.l00107
.l00102:
;src/fatfs/lib/ff.c:1169: for (BYTE c = (BYTE)fs->csize; c > 1; c >>= 1) clst <<= 1;	/* clst *= csize, a power of 2 (no _mullong) */
	ld	hl, $000A
	add	hl, bc
	ld	e, [hl]
.l00105:
	ld	a, $01
	sub	a, e
	jp	NC, .l00103
	ld	hl, sp+10
	sla	[hl]
	inc	hl
	rl	[hl]
	inc	hl
	rl	[hl]
	inc	hl
	rl	[hl]
	srl	e
	jp	.l00105
.l00103:
;src/fatfs/lib/ff.c:1170: return fs->database + clst;	/* Start sector number of the cluster */
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
	pop	de
	push	de
	ld	a, e
	ld	hl, sp+10
	add	a, [hl]
	ld	e, a
	ld	a, d
	inc	hl
	adc	a, [hl]
	push	af
	ld	hl, sp+7
	ld	[hl], a
	dec	hl
	ld	[hl], e
	dec	hl
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
	ld	hl, sp+7
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
.l00107:
;src/fatfs/lib/ff.c:1171: }
	add	sp, 8
	pop	hl
	add	sp, 4
	jp hl
;src/fatfs/lib/ff.c:1180: static DWORD get_fat (		/* 0xFFFFFFFF:Disk error, 1:Internal error, 2..0x7FFFFFFF:Cluster status */
;	---------------------------------
	SECTION FRAGMENT "Page 7",ROMX,BANK[3]
	LOAD FRAGMENT "Page 7 RAM",SRAM,BANK[7]
; Function get_fat
; ---------------------------------
_get_fat:
	add	sp, -22
	ld	c, e
	ld	b, d
;src/fatfs/lib/ff.c:1187: FATFS *fs = obj->fs;
	ld	e, c
	ld	d, b
	ld	a, [de]
	ld	hl, sp+0
	ld	[hl], a
	inc	de
	ld	a, [de]
	inc	hl
	ld	[hl], a
;src/fatfs/lib/ff.c:1190: if (clst < 2 || clst >= fs->n_fatent) {	/* Check if in valid range */
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
;src/fatfs/lib/ff.c:1191: val = 1;	/* Internal error */
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
;src/fatfs/lib/ff.c:1194: val = 0xFFFFFFFF;	/* Default value falls on disk error */
	ld	hl, sp+2
	ld	[hl], $FF
	inc	hl
	ld	[hl], $FF
	inc	hl
	ld	[hl], $FF
	inc	hl
	ld	[hl], $FF
;src/fatfs/lib/ff.c:1196: switch (fs->fs_type) {
	pop	de
	push	de
	ld	a, [de]
	ld	c, a
;src/fatfs/lib/ff.c:1199: if (move_window(fs, fs->fatbase + (bc / SS(fs))) != FR_OK) break;
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
;src/fatfs/lib/ff.c:1200: wc = fs->win[bc++ % SS(fs)];		/* Get 1st byte of the entry */
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
;src/fatfs/lib/ff.c:1196: switch (fs->fs_type) {
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
;src/fatfs/lib/ff.c:1197: case FS_FAT12 :
.l00101:
;src/fatfs/lib/ff.c:1198: bc = (UINT)clst; bc += bc / 2;
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
;src/fatfs/lib/ff.c:1199: if (move_window(fs, fs->fatbase + (bc / SS(fs))) != FR_OK) break;
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
;src/fatfs/lib/ff.c:1200: wc = fs->win[bc++ % SS(fs)];		/* Get 1st byte of the entry */
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
;src/fatfs/lib/ff.c:1201: if (move_window(fs, fs->fatbase + (bc / SS(fs))) != FR_OK) break;
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
;src/fatfs/lib/ff.c:1202: wc |= fs->win[bc % SS(fs)] << 8;	/* Merge 2nd byte of the entry */
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
;src/fatfs/lib/ff.c:1203: val = (clst & 1) ? (wc >> 4) : (wc & 0xFFF);	/* Adjust bit position */
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
;src/fatfs/lib/ff.c:1204: break;
	jp	.l00116
;src/fatfs/lib/ff.c:1206: case FS_FAT16 :
.l00106:
;src/fatfs/lib/ff.c:1207: if (move_window(fs, fs->fatbase + (clst / (SS(fs) / 2))) != FR_OK) break;
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
;src/fatfs/lib/ff.c:1208: val = ld_16(fs->win + clst * 2 % SS(fs));		/* Simple WORD array */
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
;src/fatfs/lib/ff.c:1209: break;
	jp	.l00116
;src/fatfs/lib/ff.c:1211: case FS_FAT32 :
.l00109:
;src/fatfs/lib/ff.c:1212: if (move_window(fs, fs->fatbase + (clst / (SS(fs) / 4))) != FR_OK) break;
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
;src/fatfs/lib/ff.c:1213: val = ld_32(fs->win + clst * 4 % SS(fs)) & 0x0FFFFFFF;	/* Simple DWORD array but mask out upper 4 bits */
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
;src/fatfs/lib/ff.c:1214: break;
	jp	.l00116
;src/fatfs/lib/ff.c:1242: default:
.l00112:
;src/fatfs/lib/ff.c:1243: val = 1;	/* Internal error */
	ld	hl, sp+2
	ld	[hl], $01
	xor	a, a
	inc	hl
	ld	[hl], a
	inc	hl
	ld	[hl], a
	inc	hl
	ld	[hl], a
;src/fatfs/lib/ff.c:1244: }
.l00116:
;src/fatfs/lib/ff.c:1247: return val;
	pop	hl
	pop	bc
	push	bc
	push	hl
	ld	hl, sp+4
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
.l00118:
;src/fatfs/lib/ff.c:1248: }
	add	sp, 22
	pop	hl
	add	sp, 4
	jp hl
;src/fatfs/lib/ff.c:1258: static FRESULT put_fat (	/* FR_OK(0):succeeded, !=0:error */
;	---------------------------------
	SECTION FRAGMENT "Page 10",ROMX,BANK[5]
	LOAD FRAGMENT "Page 10 RAM",SRAM,BANK[10]
; Function put_fat
; ---------------------------------
_put_fat:
	add	sp, -24
	ld	hl, sp+22
	ld	[hl], e
	inc	hl
	ld	[hl], d
;src/fatfs/lib/ff.c:1266: FRESULT res = FR_INT_ERR;
	ld	hl, sp+19
	ld	[hl], $02
;src/fatfs/lib/ff.c:1269: if (clst >= 2 && clst < fs->n_fatent) {	/* Check if in valid range */
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
;src/fatfs/lib/ff.c:1270: switch (fs->fs_type) {
	ld	hl, sp+23
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	ld	c, a
;src/fatfs/lib/ff.c:1273: res = move_window(fs, fs->fatbase + (bc / SS(fs)));
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
;src/fatfs/lib/ff.c:1275: p = fs->win + bc++ % SS(fs);
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
;src/fatfs/lib/ff.c:1277: fs->wflag = 1;
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
;src/fatfs/lib/ff.c:1270: switch (fs->fs_type) {
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
;src/fatfs/lib/ff.c:1271: case FS_FAT12:
.l00101:
;src/fatfs/lib/ff.c:1272: bc = (UINT)clst; bc += bc / 2;	/* bc: byte offset of the entry */
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
;src/fatfs/lib/ff.c:1273: res = move_window(fs, fs->fatbase + (bc / SS(fs)));
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
;src/fatfs/lib/ff.c:1274: if (res != FR_OK) break;
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00117
;src/fatfs/lib/ff.c:1275: p = fs->win + bc++ % SS(fs);
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
;src/fatfs/lib/ff.c:1276: *p = (clst & 1) ? ((*p & 0x0F) | ((BYTE)val << 4)) : (BYTE)val;	/* Update 1st byte */
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
;src/fatfs/lib/ff.c:1277: fs->wflag = 1;
	pop	bc
	pop	hl
	push	hl
	push	bc
	ld	[hl], $01
;src/fatfs/lib/ff.c:1278: res = move_window(fs, fs->fatbase + (bc / SS(fs)));
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
;src/fatfs/lib/ff.c:1279: if (res != FR_OK) break;
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00117
;src/fatfs/lib/ff.c:1280: p = fs->win + bc % SS(fs);
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
;src/fatfs/lib/ff.c:1281: *p = (clst & 1) ? (BYTE)(val >> 4) : ((*p & 0xF0) | ((BYTE)(val >> 8) & 0x0F));	/* Update 2nd byte */
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
;src/fatfs/lib/ff.c:1282: fs->wflag = 1;
	pop	bc
	pop	hl
	push	hl
	push	bc
	ld	[hl], $01
;src/fatfs/lib/ff.c:1283: break;
	jp	.l00117
;src/fatfs/lib/ff.c:1285: case FS_FAT16:
.l00106:
;src/fatfs/lib/ff.c:1286: res = move_window(fs, fs->fatbase + (clst / (SS(fs) / 2)));
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
;src/fatfs/lib/ff.c:1287: if (res != FR_OK) break;
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00117
;src/fatfs/lib/ff.c:1288: st_16(fs->win + clst * 2 % SS(fs), (WORD)val);	/* Simple WORD array */
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
;src/fatfs/lib/ff.c:1289: fs->wflag = 1;
	pop	bc
	pop	hl
	push	hl
	push	bc
	ld	[hl], $01
;src/fatfs/lib/ff.c:1290: break;
	jp	.l00117
;src/fatfs/lib/ff.c:1292: case FS_FAT32:
.l00109:
;src/fatfs/lib/ff.c:1296: res = move_window(fs, fs->fatbase + (clst / (SS(fs) / 4)));
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
;src/fatfs/lib/ff.c:1297: if (res != FR_OK) break;
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00117
;src/fatfs/lib/ff.c:1299: val = (val & 0x0FFFFFFF) | (ld_32(fs->win + clst * 4 % SS(fs)) & 0xF0000000);
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
;src/fatfs/lib/ff.c:1301: st_32(fs->win + clst * 4 % SS(fs), val);
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
;src/fatfs/lib/ff.c:1302: fs->wflag = 1;
	pop	bc
	pop	hl
	push	hl
	push	bc
	ld	[hl], $01
;src/fatfs/lib/ff.c:1304: }
.l00117:
;src/fatfs/lib/ff.c:1306: return res;
	ld	hl, sp+19
	ld	a, [hl]
.l00119:
;src/fatfs/lib/ff.c:1307: }
	add	sp, 24
	pop	hl
	add	sp, 8
	jp hl
;src/fatfs/lib/ff.c:1448: static FRESULT remove_chain (	/* FR_OK(0):succeeded, !=0:error */
;	---------------------------------
	SECTION FRAGMENT "Page 10",ROMX,BANK[5]
	LOAD FRAGMENT "Page 10 RAM",SRAM,BANK[10]
; Function remove_chain
; ---------------------------------
_remove_chain:
	add	sp, -22
	ld	hl, sp+20
	ld	[hl], e
	inc	hl
	ld	[hl], d
;src/fatfs/lib/ff.c:1456: FATFS *fs = obj->fs;
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
;src/fatfs/lib/ff.c:1464: if (clst < 2 || clst >= fs->n_fatent) return FR_INT_ERR;	/* Check if in valid range */
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
;src/fatfs/lib/ff.c:1467: if (pclst != 0 && (!FF_FS_EXFAT || fs->fs_type != FS_EXFAT || obj->stat != 2)) {
	ld	hl, sp+31
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	dec	hl
	or	a, [hl]
	dec	hl
	or	a, [hl]
	jp	Z, .l00137
;src/fatfs/lib/ff.c:1468: res = put_fat(fs, pclst, 0xFFFFFFFF);
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
;src/fatfs/lib/ff.c:1469: if (res != FR_OK) return res;
	or	a, a
	jp	Z, .l00137
	jp	.l00127
;src/fatfs/lib/ff.c:1473: do {
.l00137:
	ld	hl, sp+2
	ld	[hl], c
	inc	hl
	ld	[hl], b
.l00124:
;src/fatfs/lib/ff.c:1474: nxt = get_fat(obj, clst);			/* Get cluster status */
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
;src/fatfs/lib/ff.c:1475: if (nxt == 0) break;				/* Empty cluster? */
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	dec	hl
	or	a, [hl]
	dec	hl
	or	a, [hl]
	jp	Z, .l00126
;src/fatfs/lib/ff.c:1476: if (nxt == 1) return FR_INT_ERR;	/* Internal error? */
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
;src/fatfs/lib/ff.c:1477: if (nxt == 0xFFFFFFFF) return FR_DISK_ERR;	/* Disk error? */
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
;src/fatfs/lib/ff.c:1478: if (!FF_FS_EXFAT || fs->fs_type != FS_EXFAT) {
.l00119:
;src/fatfs/lib/ff.c:1479: res = put_fat(fs, clst, 0);		/* Mark the cluster 'free' on the FAT */
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
;src/fatfs/lib/ff.c:1480: if (res != FR_OK) return res;
	or	a, a
	jp	Z, .l00120
	jp	.l00127
.l00120:
;src/fatfs/lib/ff.c:1482: if (fs->free_clst < fs->n_fatent - 2) {	/* Update allocation information if it is valid */
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
;src/fatfs/lib/ff.c:1483: fs->free_clst++;
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
;src/fatfs/lib/ff.c:1484: fs->fsi_flag |= 1;
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
;src/fatfs/lib/ff.c:1504: clst = nxt;					/* Next cluster */
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
;src/fatfs/lib/ff.c:1505: } while (clst < fs->n_fatent);	/* Repeat until the last link */
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
;src/fatfs/lib/ff.c:1533: return FR_OK;
	xor	a, a
.l00127:
;src/fatfs/lib/ff.c:1534: }
	add	sp, 22
	pop	hl
	add	sp, 8
	jp hl
;src/fatfs/lib/ff.c:1543: static DWORD create_chain (	/* 0:No free cluster, 1:Internal error, 0xFFFFFFFF:Disk error, >=2:New cluster# */
;	---------------------------------
	SECTION FRAGMENT "Page 10",ROMX,BANK[5]
	LOAD FRAGMENT "Page 10 RAM",SRAM,BANK[10]
; Function create_chain
; ---------------------------------
_create_chain:
	add	sp, -25
	ld	hl, sp+19
	ld	[hl], e
	inc	hl
	ld	[hl], d
;src/fatfs/lib/ff.c:1550: FATFS *fs = obj->fs;
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
;src/fatfs/lib/ff.c:1554: scl = fs->last_clst;				/* Suggested cluster to start to find */
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
;src/fatfs/lib/ff.c:1555: if (scl == 0 || scl >= fs->n_fatent) scl = 1;
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
;src/fatfs/lib/ff.c:1553: if (clst == 0) {	/* Create a new chain */
	ld	hl, sp+30
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	dec	hl
	or	a, [hl]
	dec	hl
	or	a, [hl]
	jp	NZ, .l00111
;src/fatfs/lib/ff.c:1554: scl = fs->last_clst;				/* Suggested cluster to start to find */
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
;src/fatfs/lib/ff.c:1555: if (scl == 0 || scl >= fs->n_fatent) scl = 1;
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
;src/fatfs/lib/ff.c:1558: cs = get_fat(obj, clst);			/* Check the cluster status */
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
;src/fatfs/lib/ff.c:1559: if (cs < 2) return 1;				/* Test for insanity */
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
;src/fatfs/lib/ff.c:1560: if (cs == 0xFFFFFFFF) return cs;	/* Test for disk error */
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
;src/fatfs/lib/ff.c:1561: if (cs < fs->n_fatent) return cs;	/* It is already followed by next cluster */
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
;src/fatfs/lib/ff.c:1562: scl = clst;							/* Cluster to start to find */
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
;src/fatfs/lib/ff.c:1564: if (fs->free_clst == 0) return 0;		/* No free cluster */
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
;src/fatfs/lib/ff.c:1593: ncl = 0;
	xor	a, a
	ld	hl, sp+21
	ld	[hl], a
	inc	hl
	ld	[hl], a
	inc	hl
	ld	[hl], a
	inc	hl
	ld	[hl], a
;src/fatfs/lib/ff.c:1594: if (scl == clst) {						/* Stretching an existing chain? */
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
;src/fatfs/lib/ff.c:1595: ncl = scl + 1;						/* Test if next cluster is free */
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
;src/fatfs/lib/ff.c:1596: if (ncl >= fs->n_fatent) ncl = 2;
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
;src/fatfs/lib/ff.c:1597: cs = get_fat(obj, ncl);				/* Get next cluster status */
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
;src/fatfs/lib/ff.c:1598: if (cs == 1 || cs == 0xFFFFFFFF) return cs;	/* Test for error */
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
;src/fatfs/lib/ff.c:1599: if (cs != 0) {						/* Not free? */
	ld	a, d
	or	a, e
	or	a, b
	or	a, c
	jp	Z, .l00126
;src/fatfs/lib/ff.c:1600: cs = fs->last_clst;				/* Start at suggested cluster if it is valid */
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
;src/fatfs/lib/ff.c:1601: if (cs >= 2 && cs < fs->n_fatent) scl = cs;
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
;src/fatfs/lib/ff.c:1602: ncl = 0;
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
;src/fatfs/lib/ff.c:1605: if (ncl == 0) {	/* The new cluster cannot be contiguous and find another fragment */
	ld	hl, sp+24
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	dec	hl
	or	a, [hl]
	dec	hl
	or	a, [hl]
	jp	NZ, .l00140
;src/fatfs/lib/ff.c:1606: ncl = scl;	/* Start cluster */
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
;src/fatfs/lib/ff.c:1608: ncl++;							/* Next cluster */
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
;src/fatfs/lib/ff.c:1609: if (ncl >= fs->n_fatent) {		/* Check wrap-around */
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
;src/fatfs/lib/ff.c:1610: ncl = 2;
	ld	hl, sp+21
	ld	[hl], $02
	xor	a, a
	inc	hl
	ld	[hl], a
	inc	hl
	ld	[hl], a
	inc	hl
	ld	[hl], a
;src/fatfs/lib/ff.c:1611: if (ncl > scl) return 0;	/* No free cluster found? */
	ld	hl, sp+12
	ld	a, [hl]
	or	a, a
	jp	Z, .l00130
	ld	bc, $0000
	ld	de, $0000
	jp	.l00152
.l00130:
;src/fatfs/lib/ff.c:1613: cs = get_fat(obj, ncl);			/* Get the cluster status */
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
;src/fatfs/lib/ff.c:1614: if (cs == 0) break;				/* Found a free cluster? */
	ld	a, d
	or	a, e
	or	a, b
	or	a, c
	jp	Z, .l00140
;src/fatfs/lib/ff.c:1615: if (cs == 1 || cs == 0xFFFFFFFF) return cs;	/* Test for error */
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
;src/fatfs/lib/ff.c:1616: if (ncl == scl) return 0;		/* No free cluster found? */
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
;src/fatfs/lib/ff.c:1619: res = put_fat(fs, ncl, 0xFFFFFFFF);		/* Mark the new cluster 'EOC' */
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
;src/fatfs/lib/ff.c:1620: if (res == FR_OK && clst != 0) {
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
;src/fatfs/lib/ff.c:1621: res = put_fat(fs, clst, ncl);		/* Link it from the previous one if needed */
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
;src/fatfs/lib/ff.c:1625: if (res == FR_OK) {			/* Update allocation information if the function succeeded */
	ld	a, c
	or	a, a
	jp	NZ, .l00148
;src/fatfs/lib/ff.c:1626: fs->last_clst = ncl;
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
;src/fatfs/lib/ff.c:1627: if (fs->free_clst > 0 && fs->free_clst <= fs->n_fatent - 2) {
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
;src/fatfs/lib/ff.c:1628: fs->free_clst--;
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
;src/fatfs/lib/ff.c:1629: fs->fsi_flag |= 1;
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
;src/fatfs/lib/ff.c:1632: ncl = (res == FR_DISK_ERR) ? 0xFFFFFFFF : 1;	/* Failed. Generate error status */
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
;src/fatfs/lib/ff.c:1635: return ncl;		/* Return new cluster number or error status */
	ld	hl, sp+21
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	inc	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
.l00152:
;src/fatfs/lib/ff.c:1636: }
	add	sp, 25
	pop	hl
	add	sp, 4
	jp hl
;src/fatfs/lib/ff.c:1679: static FRESULT dir_clear (	/* Returns FR_OK or FR_DISK_ERR */
;	---------------------------------
	SECTION FRAGMENT "Page 10",ROMX,BANK[5]
	LOAD FRAGMENT "Page 10 RAM",SRAM,BANK[10]
; Function dir_clear
; ---------------------------------
_dir_clear:
	add	sp, -24
	ld	hl, sp+20
	ld	[hl], e
	inc	hl
	ld	[hl], d
;src/fatfs/lib/ff.c:1689: if (sync_window(fs) != FR_OK) return FR_DISK_ERR;	/* Flush disk access window */
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
;src/fatfs/lib/ff.c:1690: sect = clst2sect(fs, clst);		/* Top of the cluster */
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
;src/fatfs/lib/ff.c:1691: fs->winsect = sect;				/* Set window to top of the cluster */
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
;src/fatfs/lib/ff.c:1692: memset(fs->win, 0, sizeof fs->win);	/* Clear window buffer */
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
;src/fatfs/lib/ff.c:1704: ibuf = fs->win; szb = 1;	/* Use window buffer (many single-sector writes may take a time) */
	ld	hl, sp+4
	ld	[hl], e
	inc	hl
	ld	[hl], d
;src/fatfs/lib/ff.c:1705: for (n = 0; n < fs->csize && disk_write(fs->pdrv, ibuf, sect + n, szb) == RES_OK; n += szb) ;	/* Fill the cluster with 0 */
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
	call	_disk_write__far
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
;src/fatfs/lib/ff.c:1707: return (n == fs->csize) ? FR_OK : FR_DISK_ERR;
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
;src/fatfs/lib/ff.c:1708: }
	add	sp, 24
	pop	hl
	add	sp, 4
	jp hl
;src/fatfs/lib/ff.c:1718: static FRESULT dir_sdi (	/* FR_OK(0):succeeded, !=0:error */
;	---------------------------------
	SECTION FRAGMENT "Page 7",ROMX,BANK[3]
	LOAD FRAGMENT "Page 7 RAM",SRAM,BANK[7]
; Function dir_sdi
; ---------------------------------
_dir_sdi:
	add	sp, -20
	ld	hl, sp+18
	ld	[hl], e
	inc	hl
	ld	[hl], d
;src/fatfs/lib/ff.c:1724: FATFS *fs = dp->obj.fs;
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
;src/fatfs/lib/ff.c:1727: if (ofs >= (DWORD)((FF_FS_EXFAT && fs->fs_type == FS_EXFAT) ? MAX_DIR_EX : MAX_DIR) || ofs % SZDIRE) {	/* Check range of offset and alignment */
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
;src/fatfs/lib/ff.c:1728: return FR_INT_ERR;
	ld	a, $02
	jp	.l00124
.l00102:
;src/fatfs/lib/ff.c:1730: dp->dptr = ofs;				/* Set current offset */
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
;src/fatfs/lib/ff.c:1731: clst = dp->obj.sclust;		/* Table start cluster (0:root) */
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
;src/fatfs/lib/ff.c:1733: clst = (DWORD)fs->dirbase;
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
;src/fatfs/lib/ff.c:1732: if (clst == 0 && fs->fs_type >= FS_FAT32) {	/* Replace cluster# 0 with root cluster# */
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
;src/fatfs/lib/ff.c:1733: clst = (DWORD)fs->dirbase;
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
;src/fatfs/lib/ff.c:1734: if (FF_FS_EXFAT) dp->obj.stat = 0;	/* exFAT: Root dir has an FAT chain */
.l00107:
;src/fatfs/lib/ff.c:1739: dp->sect = fs->dirbase;
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
;src/fatfs/lib/ff.c:1737: if (clst == 0) {	/* Static table (root-directory on the FAT volume) */
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
;src/fatfs/lib/ff.c:1738: if (ofs / SZDIRE >= fs->n_rootdir) return FR_INT_ERR;	/* Is index out of range? */
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
;src/fatfs/lib/ff.c:1739: dp->sect = fs->dirbase;
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
;src/fatfs/lib/ff.c:1742: csz = (DWORD)fs->csize * SS(fs);	/* Bytes per cluster */
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
;src/fatfs/lib/ff.c:1743: while (ofs >= csz) {				/* Follow cluster chain */
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
;src/fatfs/lib/ff.c:1744: clst = get_fat(&dp->obj, clst);				/* Get next cluster */
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
;src/fatfs/lib/ff.c:1745: if (clst == 0xFFFFFFFF) return FR_DISK_ERR;	/* Disk error */
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
;src/fatfs/lib/ff.c:1746: if (clst < 2 || clst >= fs->n_fatent) return FR_INT_ERR;	/* Reached to end of table or internal error */
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
;src/fatfs/lib/ff.c:1747: ofs -= csz;
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
;src/fatfs/lib/ff.c:1749: dp->sect = clst2sect(fs, clst);
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
	call	_clst2sect__far
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
;src/fatfs/lib/ff.c:1751: dp->clust = clst;					/* Current cluster# */
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
;src/fatfs/lib/ff.c:1752: if (dp->sect == 0) return FR_INT_ERR;
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
;src/fatfs/lib/ff.c:1753: dp->sect += ofs / SS(fs);			/* Sector# of the directory entry */
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
;src/fatfs/lib/ff.c:1754: dp->dir = fs->win + (ofs % SS(fs));	/* Pointer to the entry in the win[] */
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
;src/fatfs/lib/ff.c:1756: return FR_OK;
	xor	a, a
.l00124:
;src/fatfs/lib/ff.c:1757: }
	add	sp, 20
	pop	hl
	add	sp, 4
	jp hl
;src/fatfs/lib/ff.c:1766: static FRESULT dir_next (	/* FR_OK(0):succeeded, FR_NO_FILE:End of table, FR_DENIED:Could not stretch */
;	---------------------------------
	SECTION FRAGMENT "Page 7",ROMX,BANK[3]
	LOAD FRAGMENT "Page 7 RAM",SRAM,BANK[7]
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
;src/fatfs/lib/ff.c:1772: FATFS *fs = dp->obj.fs;
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
;src/fatfs/lib/ff.c:1775: ofs = dp->dptr + SZDIRE;	/* Next entry */
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
;src/fatfs/lib/ff.c:1776: if (ofs >= (DWORD)((FF_FS_EXFAT && fs->fs_type == FS_EXFAT) ? MAX_DIR_EX : MAX_DIR)) dp->sect = 0;	/* Disable it if the offset reached the max value */
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
;src/fatfs/lib/ff.c:1777: if (dp->sect == 0) return FR_NO_FILE;	/* Report EOT if it has been disabled */
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
;src/fatfs/lib/ff.c:1779: if (ofs % SS(fs) == 0) {	/* Sector changed? */
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
;src/fatfs/lib/ff.c:1780: dp->sect++;				/* Next sector */
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
;src/fatfs/lib/ff.c:1782: if (dp->clust == 0) {	/* Static table */
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
;src/fatfs/lib/ff.c:1783: if (ofs / SZDIRE >= fs->n_rootdir) {	/* Report EOT if it reached end of static table */
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
;src/fatfs/lib/ff.c:1784: dp->sect = 0; return FR_NO_FILE;
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
;src/fatfs/lib/ff.c:1788: if ((ofs / SS(fs) & (fs->csize - 1)) == 0) {	/* Cluster changed? */
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
;src/fatfs/lib/ff.c:1789: clst = get_fat(&dp->obj, dp->clust);		/* Get next cluster */
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
;src/fatfs/lib/ff.c:1790: if (clst <= 1) return FR_INT_ERR;			/* Internal error */
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
;src/fatfs/lib/ff.c:1791: if (clst == 0xFFFFFFFF) return FR_DISK_ERR;	/* Disk error */
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
;src/fatfs/lib/ff.c:1792: if (clst >= fs->n_fatent) {					/* It reached end of dynamic table */
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
;src/fatfs/lib/ff.c:1794: if (!stretch) {								/* If no stretch, report EOT */
	ld	hl, sp+27
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	jp	NZ, .l00112
;src/fatfs/lib/ff.c:1795: dp->sect = 0; return FR_NO_FILE;
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
;src/fatfs/lib/ff.c:1797: clst = create_chain(&dp->obj, dp->clust);	/* Allocate a cluster */
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
;src/fatfs/lib/ff.c:1798: if (clst == 0) return FR_DENIED;			/* No free cluster */
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
;src/fatfs/lib/ff.c:1799: if (clst == 1) return FR_INT_ERR;			/* Internal error */
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
;src/fatfs/lib/ff.c:1800: if (clst == 0xFFFFFFFF) return FR_DISK_ERR;	/* Disk error */
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
;src/fatfs/lib/ff.c:1801: if (dir_clear(fs, clst) != FR_OK) return FR_DISK_ERR;	/* Clean up the stretched table */
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
;src/fatfs/lib/ff.c:1802: if (FF_FS_EXFAT) dp->obj.stat |= 4;			/* exFAT: The directory has been stretched */
.l00124:
;src/fatfs/lib/ff.c:1808: dp->clust = clst;		/* Initialize data for new cluster */
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
;src/fatfs/lib/ff.c:1809: dp->sect = clst2sect(fs, clst);
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
	call	_clst2sect__far
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
;src/fatfs/lib/ff.c:1813: dp->dptr = ofs;						/* Current entry */
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
;src/fatfs/lib/ff.c:1814: dp->dir = fs->win + ofs % SS(fs);	/* Pointer to the entry in the win[] */
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
;src/fatfs/lib/ff.c:1816: return FR_OK;
	xor	a, a
.l00132:
;src/fatfs/lib/ff.c:1817: }
	add	sp, 30
	ret
;src/fatfs/lib/ff.c:1827: static FRESULT dir_alloc (	/* FR_OK(0):succeeded, !=0:error */
;	---------------------------------
	SECTION FRAGMENT "Page 10",ROMX,BANK[5]
	LOAD FRAGMENT "Page 10 RAM",SRAM,BANK[10]
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
;src/fatfs/lib/ff.c:1834: FATFS *fs = dp->obj.fs;
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
;src/fatfs/lib/ff.c:1837: res = dir_sdi(dp, 0);
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
;src/fatfs/lib/ff.c:1838: if (res == FR_OK) {
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00113
;src/fatfs/lib/ff.c:1839: n = 0;
	xor	a, a
	ld	hl, sp+11
	ld	[hl], a
	inc	hl
	ld	[hl], a
;src/fatfs/lib/ff.c:1840: do {
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
;src/fatfs/lib/ff.c:1841: res = move_window(fs, dp->sect);
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
;src/fatfs/lib/ff.c:1842: if (res != FR_OK) break;
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00113
;src/fatfs/lib/ff.c:1846: if (dp->dir[DIR_Name] == DDEM || dp->dir[DIR_Name] == 0) {	/* Is the entry free? */
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
;src/fatfs/lib/ff.c:1848: if (++n == n_ent) break;	/* Is a block of contiguous free entries found? */
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
;src/fatfs/lib/ff.c:1850: n = 0;				/* Not a free entry, restart to search */
	xor	a, a
	ld	hl, sp+11
	ld	[hl], a
	inc	hl
	ld	[hl], a
.l00107:
;src/fatfs/lib/ff.c:1852: res = dir_next(dp, 1);	/* Next entry with table stretch enabled */
	ld	bc, $0001
	ld	hl, sp+9
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_dir_next__far
	ld	hl, sp+2
	ld	[hl], a
;src/fatfs/lib/ff.c:1853: } while (res == FR_OK);
	ld	a, [hl]
	or	a, a
	jp	Z, .l00109
.l00113:
;src/fatfs/lib/ff.c:1856: if (res == FR_NO_FILE) res = FR_DENIED;	/* No directory entry to allocate */
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
;src/fatfs/lib/ff.c:1857: return res;
	ld	hl, sp+2
	ld	a, [hl]
.l00116:
;src/fatfs/lib/ff.c:1858: }
	add	sp, 13
	ret
;src/fatfs/lib/ff.c:1869: static DWORD ld_clust (	/* Returns the top cluster value of the SFN entry */
;	---------------------------------
	SECTION FRAGMENT "Page 10",ROMX,BANK[5]
	LOAD FRAGMENT "Page 10 RAM",SRAM,BANK[10]
; Function ld_clust
; ---------------------------------
_ld_clust:
	add	sp, -6
	inc	sp
	inc	sp
	push	de
;src/fatfs/lib/ff.c:1876: cl = ld_16(dir + DIR_FstClusLO);
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
;src/fatfs/lib/ff.c:1877: if (fs->fs_type == FS_FAT32) {
	pop	de
	push	de
	ld	a, [de]
	sub	a, $03
	jp	NZ,.l00110
	jp	.l00111
.l00110:
	jp	.l00102
.l00111:
;src/fatfs/lib/ff.c:1878: cl |= (DWORD)ld_16(dir + DIR_FstClusHI) << 16;
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
;src/fatfs/lib/ff.c:1881: return cl;
	pop	hl
	pop	bc
	push	bc
	push	hl
	ld	hl, sp+4
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
.l00103:
;src/fatfs/lib/ff.c:1882: }
	add	sp, 6
	ret
;src/fatfs/lib/ff.c:1886: static void st_clust (
;	---------------------------------
	SECTION FRAGMENT "Page 10",ROMX,BANK[5]
	LOAD FRAGMENT "Page 10 RAM",SRAM,BANK[10]
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
;src/fatfs/lib/ff.c:1892: st_16(dir + DIR_FstClusLO, (WORD)cl);
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
;src/fatfs/lib/ff.c:1893: if (fs->fs_type == FS_FAT32) {
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
;src/fatfs/lib/ff.c:1894: st_16(dir + DIR_FstClusHI, (WORD)(cl >> 16));
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
;src/fatfs/lib/ff.c:1896: }
	add	sp, 4
	pop	hl
	add	sp, 4
	jp hl
;src/fatfs/lib/ff.c:1906: static int cmp_lfn (		/* 1:matched, 0:not matched */
;	---------------------------------
	SECTION FRAGMENT "Page 11",ROMX,BANK[5]
	LOAD FRAGMENT "Page 11 RAM",SRAM,BANK[11]
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
;src/fatfs/lib/ff.c:1915: if (ld_16(dir + LDIR_FstClusLO) != 0) return 0;	/* Check if LDIR_FstClusLO is 0 */
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
;src/fatfs/lib/ff.c:1917: ni = (UINT)((dir[LDIR_Ord] & 0x3F) - 1) * 13;	/* Offset in the name to be compared */
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
;src/fatfs/lib/ff.c:1919: for (pchr = 1, di = 0; di < 13; di++) {	/* Process all characters in the entry */
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
;src/fatfs/lib/ff.c:1920: chr = ld_16(dir + LfnOfs[di]);		/* Pick a character from the entry */
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
;src/fatfs/lib/ff.c:1921: if (pchr != 0) {
	ld	hl, sp+9
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	jp	Z, .l00109
;src/fatfs/lib/ff.c:1922: if (ni >= FF_MAX_LFN + 1 || ff_wtoupper(chr) != ff_wtoupper(lfnbuf[ni++])) {	/* Compare it with name */
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
;src/fatfs/lib/ff.c:1923: return 0;					/* Not matched */
	ld	bc, $0000
	jp	.l00119
.l00104:
;src/fatfs/lib/ff.c:1925: pchr = chr;
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
;src/fatfs/lib/ff.c:1927: if (chr != 0xFFFF) return 0;	/* Check filler */
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
;src/fatfs/lib/ff.c:1919: for (pchr = 1, di = 0; di < 13; di++) {	/* Process all characters in the entry */
	ld	hl, sp+16
	inc	[hl]
	jp	NZ, .l00170
	inc	hl
	inc	[hl]
.l00170:
	jp	.l00117
.l00111:
;src/fatfs/lib/ff.c:1931: if ((dir[LDIR_Ord] & LLEF) && pchr && lfnbuf[ni]) return 0;	/* Last name segment matched but different length */
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
;src/fatfs/lib/ff.c:1933: return 1;		/* The part of LFN matched */
	ld	bc, $0001
.l00119:
;src/fatfs/lib/ff.c:1934: }
	add	sp, 18
	ret
;src/fatfs/lib/ff.c:1942: static int pick_lfn (	/* 1:succeeded, 0:buffer overflow or invalid LFN entry */
;	---------------------------------
	SECTION FRAGMENT "Page 7",ROMX,BANK[3]
	LOAD FRAGMENT "Page 7 RAM",SRAM,BANK[7]
; Function pick_lfn
; ---------------------------------
_pick_lfn:
	add	sp, -12
	ld	hl, sp+6
	ld	[hl], e
	inc	hl
	ld	[hl], d
;src/fatfs/lib/ff.c:1951: if (ld_16(dir + LDIR_FstClusLO) != 0) return 0;	/* Check if LDIR_FstClusLO is 0 */
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
;src/fatfs/lib/ff.c:1953: ni = (UINT)((dir[LDIR_Ord] & ~LLEF) - 1) * 13;	/* Offset in the name buffer */
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
;src/fatfs/lib/ff.c:1955: for (pchr = 1, di = 0; di < 13; di++) {		/* Process all characters in the entry */
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
;src/fatfs/lib/ff.c:1956: chr = ld_16(dir + LfnOfs[di]);			/* Pick a character from the entry */
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
;src/fatfs/lib/ff.c:1957: if (pchr != 0) {
	dec	hl
	dec	hl
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	jp	Z, .l00108
;src/fatfs/lib/ff.c:1958: if (ni >= FF_MAX_LFN + 1) return 0;	/* Buffer overflow? */
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
;src/fatfs/lib/ff.c:1959: lfnbuf[ni++] = pchr = chr;			/* Store it */
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
;src/fatfs/lib/ff.c:1961: if (chr != 0xFFFF) return 0;		/* Check filler */
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
;src/fatfs/lib/ff.c:1955: for (pchr = 1, di = 0; di < 13; di++) {		/* Process all characters in the entry */
	ld	hl, sp+10
	inc	[hl]
	jp	NZ, .l00169
	inc	hl
	inc	[hl]
.l00169:
	jp	.l00117
.l00110:
;src/fatfs/lib/ff.c:1965: if (dir[LDIR_Ord] & LLEF && pchr != 0) {	/* Put terminator if it is the last LFN part and not terminated */
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
;src/fatfs/lib/ff.c:1966: if (ni >= FF_MAX_LFN + 1) return 0;		/* Buffer overflow? */
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
;src/fatfs/lib/ff.c:1967: lfnbuf[ni] = 0;
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
;src/fatfs/lib/ff.c:1970: return 1;		/* The part of LFN is valid */
	ld	bc, $0001
.l00119:
;src/fatfs/lib/ff.c:1971: }
	add	sp, 12
	ret
;src/fatfs/lib/ff.c:1980: static void put_lfn (
;	---------------------------------
	SECTION FRAGMENT "Page 11",ROMX,BANK[5]
	LOAD FRAGMENT "Page 11 RAM",SRAM,BANK[11]
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
;src/fatfs/lib/ff.c:1991: dir[LDIR_Chksum] = sum;			/* Set checksum */
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
;src/fatfs/lib/ff.c:1992: dir[LDIR_Attr] = AM_LFN;		/* Set attribute */
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
;src/fatfs/lib/ff.c:1993: dir[LDIR_Type] = 0;
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
;src/fatfs/lib/ff.c:1994: st_16(dir + LDIR_FstClusLO, 0);
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
;src/fatfs/lib/ff.c:1996: ni = (UINT)(ord - 1) * 13;		/* Offset in the name */
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
;src/fatfs/lib/ff.c:1997: di = chr = 0;
	xor	a, a
	ld	hl, sp+2
	ld	[hl], a
	inc	hl
	ld	[hl], a
;src/fatfs/lib/ff.c:1998: do {	/* Fill the directory entry */
	xor	a, a
	ld	hl, sp+10
	ld	[hl], a
	inc	hl
	ld	[hl], a
.l00105:
;src/fatfs/lib/ff.c:1999: if (chr != 0xFFFF) chr = lfn[ni++];	/* Get an effective character */
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
;src/fatfs/lib/ff.c:2000: st_16(dir + LfnOfs[di], chr);	/* Set it */
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
;src/fatfs/lib/ff.c:2001: if (chr == 0) chr = 0xFFFF;		/* Padding characters after the terminator */
	ld	hl, sp+3
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	jp	NZ, .l00106
	ld	[hl], $FF
	inc	hl
	ld	[hl], $FF
.l00106:
;src/fatfs/lib/ff.c:2002: } while (++di < 13);
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
;src/fatfs/lib/ff.c:2003: if (chr == 0xFFFF || !lfn[ni]) ord |= LLEF;	/* Last LFN part is the start of an enrty set */
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
;src/fatfs/lib/ff.c:2004: dir[LDIR_Ord] = ord;			/* Set order in the entry set */
	ld	hl, sp+5
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, sp+14
	ld	a, [hl]
	ld	[de], a
.l00111:
;src/fatfs/lib/ff.c:2005: }
	add	sp, 12
	pop	hl
	inc	sp
	inc	sp
	jp hl
;src/fatfs/lib/ff.c:2017: static void gen_numname (
;	---------------------------------
	SECTION FRAGMENT "Page 11",ROMX,BANK[5]
	LOAD FRAGMENT "Page 11 RAM",SRAM,BANK[11]
; Function gen_numname
; ---------------------------------
_gen_numname:
	add	sp, -26
	ld	hl, sp+16
	ld	[hl], e
	inc	hl
	ld	[hl], d
;src/fatfs/lib/ff.c:2028: memcpy(dst, src, 11);	/* Prepare the SFN to be modified */
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $000B
	push	hl
	call	___memcpy
;src/fatfs/lib/ff.c:2030: if (seq > 5) {	/* In case of many collisions, generate a hash number instead of sequential number */
	ld	hl, sp+30
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	ld	a, $05
	cp	a, c
	ld	a, $00
	sbc	a, b
	jp	NC, .l00142
;src/fatfs/lib/ff.c:2032: DWORD crc_sreg = seq;
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
;src/fatfs/lib/ff.c:2034: while (*lfn) {	/* Create a CRC value as a hash of LFN */
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
;src/fatfs/lib/ff.c:2035: wc = *lfn++;
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
;src/fatfs/lib/ff.c:2036: for (i = 0; i < 16; i++) {
	inc	hl
	ld	[hl], $10
	xor	a, a
	inc	hl
	ld	[hl], a
.l00125:
;src/fatfs/lib/ff.c:2037: crc_sreg = (crc_sreg << 1) + (wc & 1);
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
;src/fatfs/lib/ff.c:2038: wc >>= 1;
	srl	b
	rr	c
;src/fatfs/lib/ff.c:2039: if (crc_sreg & 0x10000) crc_sreg ^= 0x11021;
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
;src/fatfs/lib/ff.c:2036: for (i = 0; i < 16; i++) {
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	jp	NZ, .l00125
	jp	.l00104
.l00106:
;src/fatfs/lib/ff.c:2042: seq = (WORD)crc_sreg;
	ld	hl, sp+18
	ld	a, [hl]
	ld	hl, sp+30
	ld	[hl], a
	ld	hl, sp+19
	ld	a, [hl]
	ld	hl, sp+31
	ld	[hl], a
;src/fatfs/lib/ff.c:2047: do {
.l00142:
	ld	bc, $0007
.l00112:
;src/fatfs/lib/ff.c:2048: c = (BYTE)((seq % 16) + '0'); seq /= 16;
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
;src/fatfs/lib/ff.c:2049: if (c > '9') c += 7;
	ld	a, $39
	ld	hl, sp+25
	sub	a, [hl]
	jp	NC, .l00110
	ld	a, [hl]
	add	a, $07
	ld	[hl], a
.l00110:
;src/fatfs/lib/ff.c:2050: ns[i--] = c;
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
;src/fatfs/lib/ff.c:2051: } while (i && seq);
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
;src/fatfs/lib/ff.c:2052: ns[i] = '~';
	ld	hl, 4
	add	hl, sp
	add	hl, bc
	ld	[hl], $7E
;src/fatfs/lib/ff.c:2055: for (j = 0; j < i && dst[j] != ' '; j++) {	/* Find the offset to append */
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
;src/fatfs/lib/ff.c:2056: if (dbc_1st(dst[j])) {	/* To avoid DBC break up */
	ld	a, c
	call	_dbc_1st
	ld	a, b
	or	a, c
	jp	Z, .l00129
;src/fatfs/lib/ff.c:2057: if (j == i - 1) break;
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
;src/fatfs/lib/ff.c:2058: j++;
	ld	hl, sp+24
	inc	[hl]
	jp	NZ, .l00224
	inc	hl
	inc	[hl]
.l00224:
.l00129:
;src/fatfs/lib/ff.c:2055: for (j = 0; j < i && dst[j] != ' '; j++) {	/* Find the offset to append */
	ld	hl, sp+24
	inc	[hl]
	jp	NZ, .l00225
	inc	hl
	inc	[hl]
.l00225:
	jp	.l00128
;src/fatfs/lib/ff.c:2061: do {	/* Append the suffix */
.l00149:
.l00120:
;src/fatfs/lib/ff.c:2062: dst[j++] = (i < 8) ? ns[i++] : ' ';
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
;src/fatfs/lib/ff.c:2063: } while (j < 8);
	ld	hl, sp+24
	ld	a, [hl]
	sub	a, $08
	inc	hl
	ld	a, [hl]
	sbc	a, $00
	jp	C, .l00120
.l00130:
;src/fatfs/lib/ff.c:2064: }
	add	sp, 26
	pop	hl
	add	sp, 4
	jp hl
;src/fatfs/lib/ff.c:2074: static BYTE sum_sfn (
;	---------------------------------
	SECTION FRAGMENT "src/fatfs/fatfs.c ROM0",ROM0
; Function sum_sfn
; ---------------------------------
_sum_sfn:
;src/fatfs/lib/ff.c:2078: BYTE sum = 0;
	ld	l, $00
;	spillPairReg hl
;	spillPairReg hl
;src/fatfs/lib/ff.c:2081: do {
	ld	bc, $000B
.l00101:
;src/fatfs/lib/ff.c:2082: sum = (sum >> 1) + (sum << 7) + *dir++;
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
;src/fatfs/lib/ff.c:2083: } while (--n);
	dec	bc
	ld	a, b
	or	a, c
	jp	NZ, .l00101
;src/fatfs/lib/ff.c:2084: return sum;
	ld	a, l
.l00104:
;src/fatfs/lib/ff.c:2085: }
	ret
;src/fatfs/lib/ff.c:2338: static FRESULT dir_read (
;	---------------------------------
	SECTION FRAGMENT "Page 8",ROMX,BANK[4]
	LOAD FRAGMENT "Page 8 RAM",SRAM,BANK[8]
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
;src/fatfs/lib/ff.c:2343: FRESULT res = FR_NO_FILE;
	ld	hl, sp+3
	ld	[hl], $04
;src/fatfs/lib/ff.c:2344: FATFS *fs = dp->obj.fs;
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
;src/fatfs/lib/ff.c:2347: BYTE ord = 0xFF, sum = 0xFF;
	inc	hl
	ld	[hl], $FF
	inc	hl
	ld	[hl], $FF
;src/fatfs/lib/ff.c:2350: while (dp->sect) {
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
;src/fatfs/lib/ff.c:2351: res = move_window(fs, dp->sect);
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
;src/fatfs/lib/ff.c:2352: if (res != FR_OK) break;
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00122
;src/fatfs/lib/ff.c:2353: et = dp->dir[DIR_Name];	/* Test for the entry type */
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
;src/fatfs/lib/ff.c:2354: if (et == 0) {
	ld	a, b
	or	a, a
	jp	NZ, .l00104
;src/fatfs/lib/ff.c:2355: res = FR_NO_FILE; break; /* Reached to end of the directory */
	ld	hl, sp+3
	ld	[hl], $04
	jp	.l00122
.l00104:
;src/fatfs/lib/ff.c:2374: dp->obj.attr = attr = dp->dir[DIR_Attr] & AM_MASK;	/* Get attribute */
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
;src/fatfs/lib/ff.c:2376: if (et == DDEM || et == '.' || (int)((attr & ~AM_ARC) == AM_VOL) != vol) {	/* An entry without valid data */
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
;src/fatfs/lib/ff.c:2377: ord = 0xFF;
	ld	hl, sp+6
	ld	[hl], $FF
	jp	.l00115
.l00114:
;src/fatfs/lib/ff.c:2383: dp->blk_ofs = dp->dptr;
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
;src/fatfs/lib/ff.c:2379: if (attr == AM_LFN) {	/* An LFN entry is found */
	ld	a, c
	sub	a, $0F
	jp	NZ,.l00203
	jp	.l00204
.l00203:
	jp	.l00111
.l00204:
;src/fatfs/lib/ff.c:2380: if (et & LLEF) {		/* Is it start of an LFN sequence? */
	bit	6, b
	jp	NZ,.l00205
	jp	.l00106
.l00205:
;src/fatfs/lib/ff.c:2381: sum = dp->dir[LDIR_Chksum];
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
;src/fatfs/lib/ff.c:2382: et &= (BYTE)~LLEF; ord = et;
	res	6, b
	ld	hl, sp+6
	ld	[hl], b
;src/fatfs/lib/ff.c:2383: dp->blk_ofs = dp->dptr;
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
;src/fatfs/lib/ff.c:2386: ord = (et == ord && sum == dp->dir[LDIR_Chksum] && pick_lfn(fs->lfnbuf, dp->dir)) ? ord - 1 : 0xFF;
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
;src/fatfs/lib/ff.c:2388: if (ord != 0 || sum != sum_sfn(dp->dir)) {	/* Is there a valid LFN? */
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
	call	_sum_sfn
	ld	c, a
	ld	hl, sp+7
	ld	a, [hl]
	sub	a, c
	jp	NZ,.l00210
	jp	.l00122
.l00210:
.l00107:
;src/fatfs/lib/ff.c:2389: dp->blk_ofs = 0xFFFFFFFF;	/* It has no LFN. */
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
;src/fatfs/lib/ff.c:2391: break;
	jp	.l00122
.l00115:
;src/fatfs/lib/ff.c:2400: res = dir_next(dp, 0);		/* Next entry */
	ld	bc, $0000
	ld	hl, sp+26
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_dir_next__far
	ld	hl, sp+3
	ld	[hl], a
;src/fatfs/lib/ff.c:2401: if (res != FR_OK) break;
	ld	a, [hl]
	or	a, a
	jp	Z, .l00120
.l00122:
;src/fatfs/lib/ff.c:2404: if (res != FR_OK) dp->sect = 0;		/* Terminate the read operation on error or EOT */
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
;src/fatfs/lib/ff.c:2405: return res;
	ld	hl, sp+3
	ld	a, [hl]
.l00125:
;src/fatfs/lib/ff.c:2406: }
	add	sp, 28
	ret
;src/fatfs/lib/ff.c:2416: static FRESULT dir_find (	/* FR_OK(0):succeeded, !=0:error */
;	---------------------------------
	SECTION FRAGMENT "Page 7",ROMX,BANK[3]
	LOAD FRAGMENT "Page 7 RAM",SRAM,BANK[7]
; Function dir_find
; ---------------------------------
_dir_find:
	add	sp, -35
	ld	hl, sp+33
	ld	[hl], e
	inc	hl
	ld	[hl], d
;src/fatfs/lib/ff.c:2421: FATFS *fs = dp->obj.fs;
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
;src/fatfs/lib/ff.c:2427: res = dir_sdi(dp, 0);			/* Rewind directory object */
	ld	de, $0000
	push	de
	push	de
	ld	hl, sp+37
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_dir_sdi
;src/fatfs/lib/ff.c:2428: if (res != FR_OK) return res;
	or	a, a
	jp	Z, .l00102
	jp	.l00128
.l00102:
;src/fatfs/lib/ff.c:2451: ord = sum = 0xFF; dp->blk_ofs = 0xFFFFFFFF;	/* Reset LFN sequence */
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
;src/fatfs/lib/ff.c:2453: do {
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
;src/fatfs/lib/ff.c:2454: res = move_window(fs, dp->sect);
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
;src/fatfs/lib/ff.c:2455: if (res != FR_OK) break;
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00127
;src/fatfs/lib/ff.c:2456: et = dp->dir[DIR_Name];		/* Entry type */
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
;src/fatfs/lib/ff.c:2457: if (et == 0) { res = FR_NO_FILE; break; }	/* Reached end of directory table */
	ld	a, c
	or	a, a
	jp	NZ, .l00106
	dec	hl
	dec	hl
	ld	[hl], $04
	jp	.l00127
.l00106:
;src/fatfs/lib/ff.c:2459: dp->obj.attr = attr = dp->dir[DIR_Attr] & AM_MASK;
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
;src/fatfs/lib/ff.c:2460: if (et == DDEM || ((attr & AM_VOL) && attr != AM_LFN)) {	/* An entry without valid data */
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
;src/fatfs/lib/ff.c:2461: ord = 0xFF; dp->blk_ofs = 0xFFFFFFFF;	/* Reset LFN sequence */
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
;src/fatfs/lib/ff.c:2463: if (attr == AM_LFN) {			/* Is it an LFN entry? */
	or	a, a
	jp	Z, .l00118
;src/fatfs/lib/ff.c:2464: if (!(dp->fn[NSFLAG] & NS_NOLFN)) {
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
;src/fatfs/lib/ff.c:2465: if (et & LLEF) {		/* Is it start of an entry set? */
	bit	6, c
	jp	NZ,.l00212
	jp	.l00108
.l00212:
;src/fatfs/lib/ff.c:2466: et &= (BYTE)~LLEF;
	res	6, c
;src/fatfs/lib/ff.c:2467: ord = et;					/* Number of LFN entries */
	ld	hl, sp+3
	ld	[hl], c
;src/fatfs/lib/ff.c:2468: dp->blk_ofs = dp->dptr;		/* Start offset of LFN */
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
;src/fatfs/lib/ff.c:2469: sum = dp->dir[LDIR_Chksum];	/* Sum of the SFN */
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
;src/fatfs/lib/ff.c:2472: ord = (et == ord && sum == dp->dir[LDIR_Chksum] && cmp_lfn(fs->lfnbuf, dp->dir)) ? ord - 1 : 0xFF;
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
;src/fatfs/lib/ff.c:2475: if (ord == 0 && sum == sum_sfn(dp->dir)) break;	/* LFN matched? */
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
	call	_sum_sfn
	ld	c, a
	ld	hl, sp+2
	ld	a, [hl]
	sub	a, c
	jp	NZ,.l00217
	jp	.l00127
.l00217:
.l00112:
;src/fatfs/lib/ff.c:2476: if (!(dp->fn[NSFLAG] & NS_LOSS) && !memcmp(dp->dir, dp->fn, 11)) break;	/* SFN matched? */
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
;src/fatfs/lib/ff.c:2477: ord = 0xFF; dp->blk_ofs = 0xFFFFFFFF;	/* Not matched, reset LFN sequence */
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
;src/fatfs/lib/ff.c:2484: res = dir_next(dp, 0);	/* Next entry */
	ld	bc, $0000
	ld	hl, sp+33
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_dir_next
	ld	hl, sp+28
	ld	[hl], a
;src/fatfs/lib/ff.c:2485: } while (res == FR_OK);
	ld	a, [hl]
	or	a, a
	jp	Z, .l00125
.l00127:
;src/fatfs/lib/ff.c:2487: return res;
	ld	hl, sp+28
	ld	a, [hl]
.l00128:
;src/fatfs/lib/ff.c:2488: }
	add	sp, 35
	ret
;src/fatfs/lib/ff.c:2498: static FRESULT dir_register (	/* FR_OK:succeeded, FR_DENIED:no free entry or too many SFN collision, FR_DISK_ERR:disk error */
;	---------------------------------
	SECTION FRAGMENT "Page 10",ROMX,BANK[5]
	LOAD FRAGMENT "Page 10 RAM",SRAM,BANK[10]
; Function dir_register
; ---------------------------------
_dir_register:
	add	sp, -48
	ld	hl, sp+44
	ld	[hl], e
	inc	hl
	ld	[hl], d
;src/fatfs/lib/ff.c:2503: FATFS *fs = dp->obj.fs;
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
;src/fatfs/lib/ff.c:2509: if (dp->fn[NSFLAG] & (NS_DOT | NS_NONAME)) return FR_INVALID_NAME;	/* Check name validity */
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
;src/fatfs/lib/ff.c:2510: for (len = 0; fs->lfnbuf[len]; len++) ;	/* Get lfn length */
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
;src/fatfs/lib/ff.c:2550: memcpy(sn, dp->fn, 12);
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
;src/fatfs/lib/ff.c:2551: if (sn[NSFLAG] & NS_LOSS) {			/* When LFN is out of 8.3 format, generate a numbered name */
	ld	hl, sp+23
	ld	c, [hl]
;src/fatfs/lib/ff.c:2552: dp->fn[NSFLAG] = NS_NOLFN;		/* Find only SFN */
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
;src/fatfs/lib/ff.c:2551: if (sn[NSFLAG] & NS_LOSS) {			/* When LFN is out of 8.3 format, generate a numbered name */
	bit	0, c
	jp	NZ,.l00227
	jp	.l00112
.l00227:
;src/fatfs/lib/ff.c:2552: dp->fn[NSFLAG] = NS_NOLFN;		/* Find only SFN */
	ld	hl, sp+28
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	ld	[hl], $40
;src/fatfs/lib/ff.c:2553: for (n = 1; n < 100; n++) {
	ld	hl, sp+46
	ld	[hl], $01
	xor	a, a
	inc	hl
	ld	[hl], a
.l00131:
;src/fatfs/lib/ff.c:2554: gen_numname(dp->fn, sn, fs->lfnbuf, (WORD)n);	/* Generate a numbered name */
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
;src/fatfs/lib/ff.c:2555: res = dir_find(dp);				/* Check if the name collides with existing SFN */
	ld	hl, sp+44
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_dir_find__far
	ld	c, a
;src/fatfs/lib/ff.c:2556: if (res != FR_OK) break;
	ld	a, c
	or	a, a
	jp	NZ, .l00106
;src/fatfs/lib/ff.c:2553: for (n = 1; n < 100; n++) {
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
;src/fatfs/lib/ff.c:2558: if (n == 100) return FR_DENIED;		/* Abort if too many collisions */
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
;src/fatfs/lib/ff.c:2559: if (res != FR_NO_FILE) return res;	/* Abort if the result is other than 'not collided' */
	ld	a, c
	sub	a, $04
	jp	NZ,.l00231
	jp	.l00110
.l00231:
	ld	a, c
	jp	.l00133
.l00110:
;src/fatfs/lib/ff.c:2560: dp->fn[NSFLAG] = sn[NSFLAG];
	ld	hl, sp+23
	ld	c, [hl]
	ld	hl, sp+35
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	ld	[hl], c
.l00112:
;src/fatfs/lib/ff.c:2564: n_ent = (sn[NSFLAG] & NS_LFN) ? (len + 12) / 13 + 1 : 1;	/* Number of entries to allocate */
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
;src/fatfs/lib/ff.c:2565: res = dir_alloc(dp, n_ent);		/* Allocate entries */
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
;src/fatfs/lib/ff.c:2571: do {					/* Store LFN entries in bottom first */
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
;src/fatfs/lib/ff.c:2574: put_lfn(fs->lfnbuf, dp->dir, (BYTE)n_ent, sum);
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
;src/fatfs/lib/ff.c:2575: fs->wflag = 1;
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
;src/fatfs/lib/ff.c:2566: if (res == FR_OK && --n_ent) {	/* Set LFN entry if needed */
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
;src/fatfs/lib/ff.c:2567: res = dir_sdi(dp, dp->dptr - n_ent * SZDIRE);
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
;src/fatfs/lib/ff.c:2568: if (res == FR_OK) {
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00122
;src/fatfs/lib/ff.c:2569: BYTE sum = sum_sfn(dp->fn);	/* Checksum value of the SFN tied to the LFN */
	ld	hl, sp+39
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_sum_sfn
	ld	hl, sp+36
	ld	[hl], a
;src/fatfs/lib/ff.c:2571: do {					/* Store LFN entries in bottom first */
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
;src/fatfs/lib/ff.c:2572: res = move_window(fs, dp->sect);
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
;src/fatfs/lib/ff.c:2573: if (res != FR_OK) break;
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00122
;src/fatfs/lib/ff.c:2574: put_lfn(fs->lfnbuf, dp->dir, (BYTE)n_ent, sum);
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
;src/fatfs/lib/ff.c:2575: fs->wflag = 1;
	ld	hl, sp+34
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	ld	[hl], $01
;src/fatfs/lib/ff.c:2576: res = dir_next(dp, 0);	/* Next entry */
	ld	bc, $0000
	ld	hl, sp+44
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_dir_next__far
	ld	hl, sp+43
	ld	[hl], a
;src/fatfs/lib/ff.c:2577: } while (res == FR_OK && --n_ent);
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
;src/fatfs/lib/ff.c:2587: if (res == FR_OK) {
	ld	hl, sp+43
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00127
;src/fatfs/lib/ff.c:2588: res = move_window(fs, dp->sect);
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
;src/fatfs/lib/ff.c:2589: if (res == FR_OK) {
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00127
;src/fatfs/lib/ff.c:2590: memset(dp->dir, 0, SZDIRE);	/* Clean the entry */
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
;src/fatfs/lib/ff.c:2591: memcpy(dp->dir + DIR_Name, dp->fn, 11);	/* Put SFN */
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
;src/fatfs/lib/ff.c:2593: dp->dir[DIR_NTres] = dp->fn[NSFLAG] & (NS_BODY | NS_EXT);	/* Put low-case flags */
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
;src/fatfs/lib/ff.c:2595: fs->wflag = 1;
	ld	hl, sp+34
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	ld	[hl], $01
.l00127:
;src/fatfs/lib/ff.c:2599: return res;
	ld	hl, sp+43
	ld	a, [hl]
.l00133:
;src/fatfs/lib/ff.c:2600: }
	add	sp, 48
	ret
;src/fatfs/lib/ff.c:2611: static FRESULT dir_remove (	/* FR_OK:Succeeded, FR_DISK_ERR:A disk error */
;	---------------------------------
	SECTION FRAGMENT "Page 13",ROMX,BANK[6]
	LOAD FRAGMENT "Page 13 RAM",SRAM,BANK[13]
; Function dir_remove
; ---------------------------------
_dir_remove:
	add	sp, -19
	ld	hl, sp+17
	ld	[hl], e
	inc	hl
	ld	[hl], d
;src/fatfs/lib/ff.c:2616: FATFS *fs = dp->obj.fs;
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
;src/fatfs/lib/ff.c:2618: DWORD last = dp->dptr;
	ld	hl, sp+18
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $000E
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+17
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+16
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
;src/fatfs/lib/ff.c:2620: res = (dp->blk_ofs == 0xFFFFFFFF) ? FR_OK : dir_sdi(dp, dp->blk_ofs);	/* Goto top of the entry block if LFN is exist */
	ld	hl, sp+18
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
	ld	hl, sp+11
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
	inc	hl
	and	a, [hl]
	inc	hl
	and	a, [hl]
	inc	hl
	and	a, [hl]
	inc	a
	jp	NZ,.l00149
	jp	.l00150
.l00149:
	jp	.l00118
.l00150:
	xor	a, a
	ld	c, a
	jp	.l00119
.l00118:
	ld	hl, sp+13
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	push	de
	ld	hl, sp+13
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	push	de
	ld	hl, sp+21
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_dir_sdi__far
	ld	c, $00
.l00119:
	ld	hl, sp+6
	ld	[hl], a
;src/fatfs/lib/ff.c:2621: if (res == FR_OK) {
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00115
;src/fatfs/lib/ff.c:2622: do {
	ld	hl, sp+18
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $001A
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+9
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+8
	ld	[hl], a
	ld	hl, sp+15
	ld	a, [hl]
	ld	hl, sp+9
	ld	[hl], a
	ld	hl, sp+16
	ld	a, [hl]
	ld	hl, sp+10
	ld	[hl], a
	ld	hl, sp+18
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $0016
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+13
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+12
	ld	[hl], a
.l00109:
;src/fatfs/lib/ff.c:2623: res = move_window(fs, dp->sect);
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
	ld	hl, sp+6
	ld	[hl], a
;src/fatfs/lib/ff.c:2624: if (res != FR_OK) break;
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00111
;src/fatfs/lib/ff.c:2628: dp->dir[DIR_Name] = DDEM;	/* Mark the entry 'deleted'. */
	inc	hl
	inc	hl
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
	dec	hl
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	ld	[hl], $E5
;src/fatfs/lib/ff.c:2630: fs->wflag = 1;
	pop	de
	push	de
	ld	hl, $0004
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+17
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+16
	ld	[hl], a
	dec	hl
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	ld	[hl], $01
;src/fatfs/lib/ff.c:2631: if (dp->dptr >= last) break;	/* If reached last entry then all entries of the object has been deleted. */
	ld	hl, sp+10
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	ld	hl, sp+13
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
	ld	hl, sp+2
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
	jp	NC, .l00111
;src/fatfs/lib/ff.c:2632: res = dir_next(dp, 0);	/* Next entry */
	ld	bc, $0000
	ld	hl, sp+17
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_dir_next__far
	ld	hl, sp+6
	ld	[hl], a
;src/fatfs/lib/ff.c:2633: } while (res == FR_OK);
	ld	a, [hl]
	or	a, a
	jp	Z, .l00109
.l00111:
;src/fatfs/lib/ff.c:2634: if (res == FR_NO_FILE) res = FR_INT_ERR;
	ld	hl, sp+6
	ld	a, [hl]
	sub	a, $04
	jp	NZ,.l00151
	jp	.l00152
.l00151:
	jp	.l00115
.l00152:
	ld	hl, sp+6
	ld	[hl], $02
.l00115:
;src/fatfs/lib/ff.c:2645: return res;
	ld	hl, sp+6
	ld	a, [hl]
.l00116:
;src/fatfs/lib/ff.c:2646: }
	add	sp, 19
	ret
;src/fatfs/lib/ff.c:2657: static void get_fileinfo (
;	---------------------------------
	SECTION FRAGMENT "Page 11",ROMX,BANK[5]
	LOAD FRAGMENT "Page 11 RAM",SRAM,BANK[11]
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
;src/fatfs/lib/ff.c:2665: FATFS *fs = dp->obj.fs;
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
;src/fatfs/lib/ff.c:2672: fno->fname[0] = 0;
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
;src/fatfs/lib/ff.c:2673: if (dp->sect == 0) return;	/* Exit if read pointer has reached end of directory */
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
;src/fatfs/lib/ff.c:2715: if (dp->blk_ofs != 0xFFFFFFFF) {	/* Get LFN if available */
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
;src/fatfs/lib/ff.c:2718: while (fs->lfnbuf[si] != 0) {
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
;src/fatfs/lib/ff.c:2715: if (dp->blk_ofs != 0xFFFFFFFF) {	/* Get LFN if available */
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
;src/fatfs/lib/ff.c:2716: si = di = 0;
	ld	bc, $0000
;src/fatfs/lib/ff.c:2717: hs = 0;
	xor	a, a
	ld	hl, sp+4
	ld	[hl], a
	inc	hl
	ld	[hl], a
;src/fatfs/lib/ff.c:2718: while (fs->lfnbuf[si] != 0) {
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
;src/fatfs/lib/ff.c:2719: wc = fs->lfnbuf[si++];		/* Get an LFN character (UTF-16) */
	ld	hl, sp+30
	inc	[hl]
	jp	NZ, .l00307
	inc	hl
	inc	[hl]
.l00307:
;src/fatfs/lib/ff.c:2720: if (hs == 0 && IsSurrogate(wc)) {	/* Is it a surrogate? */
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
;src/fatfs/lib/ff.c:2721: hs = wc; continue;		/* Get low surrogate */
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
;src/fatfs/lib/ff.c:2723: nw = put_utf((DWORD)hs << 16 | wc, &fno->fname[di], FF_LFN_BUF - di);	/* Store it in API encoding */
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
;src/fatfs/lib/ff.c:2724: if (nw == 0) {				/* Buffer overflow or wrong char? */
	ld	a, h
	or	a, l
	jp	NZ, .l00108
;src/fatfs/lib/ff.c:2725: di = 0; break;
	ld	bc, $0000
	jp	.l00111
.l00108:
;src/fatfs/lib/ff.c:2727: di += nw;
	add	hl, bc
	ld	c, l
	ld	b, h
;src/fatfs/lib/ff.c:2728: hs = 0;
	xor	a, a
	ld	hl, sp+4
	ld	[hl], a
	inc	hl
	ld	[hl], a
	jp	.l00109
.l00111:
;src/fatfs/lib/ff.c:2730: if (hs != 0) di = 0;	/* Broken surrogate pair? */
	ld	hl, sp+5
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	jp	Z, .l00113
	ld	bc, $0000
.l00113:
;src/fatfs/lib/ff.c:2731: fno->fname[di] = 0;		/* Terminate the LFN (null string means LFN is invalid) */
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
;src/fatfs/lib/ff.c:2735: si = di = 0;
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
;src/fatfs/lib/ff.c:2736: while (si < 11) {		/* Get SFN from SFN entry */
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
;src/fatfs/lib/ff.c:2737: wc = dp->dir[si++];			/* Get a char */
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
;src/fatfs/lib/ff.c:2738: if (wc == ' ') continue;	/* Skip padding spaces */
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
;src/fatfs/lib/ff.c:2739: if (wc == RDDEM) wc = DDEM;	/* Restore replaced DDEM character */
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
;src/fatfs/lib/ff.c:2740: if (si == 9 && di < FF_SFN_BUF) fno->altname[di++] = '.';	/* Insert a . if extension is exist */
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
;src/fatfs/lib/ff.c:2742: if (dbc_1st((BYTE)wc) && si != 8 && si != 11 && dbc_2nd(dp->dir[si])) {	/* Make a DBC if needed */
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
;src/fatfs/lib/ff.c:2743: wc = wc << 8 | dp->dir[si++];
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
;src/fatfs/lib/ff.c:2745: wc = ff_oem2uni(wc, CODEPAGE);		/* ANSI/OEM -> Unicode */
	ld	bc, $01B5
	ld	hl, sp+14
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_ff_oem2uni
;src/fatfs/lib/ff.c:2746: if (wc == 0) {				/* Wrong char in the current code page? */
	ld	a, b
	or	a, c
	jp	NZ, .l00129
;src/fatfs/lib/ff.c:2747: di = 0; break;
	xor	a, a
	ld	hl, sp+30
	ld	[hl], a
	inc	hl
	ld	[hl], a
	jp	.l00134
.l00129:
;src/fatfs/lib/ff.c:2749: nw = put_utf(wc, &fno->altname[di], FF_SFN_BUF - di);	/* Store it in API encoding */
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
;src/fatfs/lib/ff.c:2750: if (nw == 0) {				/* Buffer overflow? */
	ld	a, b
	or	a, c
	jp	NZ, .l00131
;src/fatfs/lib/ff.c:2751: di = 0; break;
	xor	a, a
	ld	hl, sp+30
	ld	[hl], a
	inc	hl
	ld	[hl], a
	jp	.l00134
.l00131:
;src/fatfs/lib/ff.c:2753: di += nw;
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
;src/fatfs/lib/ff.c:2758: fno->altname[di] = 0;	/* Terminate the SFN  (null string means SFN is invalid) */
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
;src/fatfs/lib/ff.c:2760: if (!fno->fname[0]) {	/* If LFN is invalid, altname[] needs to be copied to fname[] */
	pop	de
	push	de
	ld	a, [de]
	ld	hl, sp+25
	ld	[hl], a
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00148
;src/fatfs/lib/ff.c:2761: if (di == 0) {		/* If LFN and SFN both are invalid, */
	ld	hl, sp+31
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	jp	NZ, .l00143
;src/fatfs/lib/ff.c:2762: fno->fname[di++] = '\?';	/* This object is inaccessible due to wrong buffer or locale settings */
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
;src/fatfs/lib/ff.c:2764: BYTE lcflg = NS_BODY;
	ld	hl, sp+11
	ld	[hl], $08
;src/fatfs/lib/ff.c:2766: for (si = di = 0; fno->altname[si]; si++, di++) {	/* Copy altname[] to fname[] with case information */
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
;src/fatfs/lib/ff.c:2767: wc = (WCHAR)fno->altname[si];
	ld	hl, sp+16
	ld	[hl], a
	inc	hl
	ld	[hl], $00
;src/fatfs/lib/ff.c:2720: if (hs == 0 && IsSurrogate(wc)) {	/* Is it a surrogate? */
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
;src/fatfs/lib/ff.c:2768: if (wc == '.') lcflg = NS_EXT;
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
;src/fatfs/lib/ff.c:2769: if (IsUpper(wc) && (dp->dir[DIR_NTres] & lcflg)) wc += 0x20;
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
;src/fatfs/lib/ff.c:2770: fno->fname[di] = (TCHAR)wc;
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
;src/fatfs/lib/ff.c:2766: for (si = di = 0; fno->altname[si]; si++, di++) {	/* Copy altname[] to fname[] with case information */
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
;src/fatfs/lib/ff.c:2773: fno->fname[di] = 0;	/* Terminate the LFN */
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
;src/fatfs/lib/ff.c:2774: if (!dp->dir[DIR_NTres]) fno->altname[0] = 0;	/* Altname is not needed if neither LFN nor case info is exist. */
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
;src/fatfs/lib/ff.c:2789: fno->fattrib = dp->dir[DIR_Attr] & AM_MASK;		/* Attribute */
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
;src/fatfs/lib/ff.c:2790: fno->fsize = ld_32(dp->dir + DIR_FileSize);		/* Size */
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
;src/fatfs/lib/ff.c:2791: fno->ftime = ld_16(dp->dir + DIR_ModTime + 0);	/* Last modified time */
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
;src/fatfs/lib/ff.c:2792: fno->fdate = ld_16(dp->dir + DIR_ModTime + 2);	/* Last Modified date */
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
;src/fatfs/lib/ff.c:2797: }
	add	sp, 32
	ret
;src/fatfs/lib/ff.c:2896: static FRESULT create_name (	/* FR_OK: successful, FR_INVALID_NAME: could not create */
;	---------------------------------
	SECTION FRAGMENT "Page 11",ROMX,BANK[5]
	LOAD FRAGMENT "Page 11 RAM",SRAM,BANK[11]
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
;src/fatfs/lib/ff.c:2911: p = *path; lfn = dp->obj.fs->lfnbuf; di = 0;
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
;src/fatfs/lib/ff.c:2913: uc = tchar2uni(&p);			/* Get a character */
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
;src/fatfs/lib/ff.c:2914: if (uc == 0xFFFFFFFF) return FR_INVALID_NAME;		/* Invalid code or UTF decode error */
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
;src/fatfs/lib/ff.c:2915: if (uc >= 0x10000) lfn[di++] = (WCHAR)(uc >> 16);	/* Store high surrogate if needed */
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
;src/fatfs/lib/ff.c:2916: wc = (WCHAR)uc;
	ld	hl, sp+19
	ld	a, [hl]
	ld	hl, sp+13
	ld	[hl], a
	ld	hl, sp+20
	ld	a, [hl]
	ld	hl, sp+14
	ld	[hl], a
;src/fatfs/lib/ff.c:2917: if (wc < ' ' || IsSeparator(wc)) break;	/* Break if end of the path or a separator is found */
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
;src/fatfs/lib/ff.c:2918: if (wc < 0x80 && strchr("*:<>|\"\?\x7F", (int)wc)) return FR_INVALID_NAME;	/* Reject illegal characters for LFN */
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
	ld	de, ___src_fatfs_fatfs_c_str_0
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
;src/fatfs/lib/ff.c:2919: if (di >= FF_MAX_LFN) return FR_INVALID_NAME;	/* Reject too long name */
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
;src/fatfs/lib/ff.c:2920: lfn[di++] = wc;				/* Store the Unicode character */
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
;src/fatfs/lib/ff.c:2922: if (wc < ' ') {				/* Stopped at end of the path? */
	ld	hl, sp+22
	ld	a, [hl]
	or	a, a
	jp	Z, .l00208
;src/fatfs/lib/ff.c:2923: cf = NS_LAST;			/* Last segment */
	ld	hl, sp+19
	ld	[hl], $04
	jp	.l00123
;src/fatfs/lib/ff.c:2925: while (IsSeparator(*p)) p++;	/* Skip duplicated separators if exist */
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
;src/fatfs/lib/ff.c:2926: cf = 0;					/* Next segment may follow */
	ld	hl, sp+19
	ld	[hl], $00
;src/fatfs/lib/ff.c:2927: if (IsTerminator(*p)) cf = NS_LAST;	/* Ignore terminating separator */
	ld	c, a
	ld	b, $00
	ld	a, c
	sub	a, $20
	ld	a, b
	sbc	a, $00
	jp	NC, .l00123
	ld	[hl], $04
.l00123:
;src/fatfs/lib/ff.c:2929: *path = p;					/* Return pointer to the next segment */
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
;src/fatfs/lib/ff.c:2942: while (di) {					/* Snip off trailing spaces and dots if exist */
	ld	hl, sp+23
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
.l00127:
	ld	a, b
	or	a, c
	jp	Z, .l00244
;src/fatfs/lib/ff.c:2943: wc = lfn[di - 1];
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
;src/fatfs/lib/ff.c:2944: if (wc != ' ' && wc != '.') break;
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
;src/fatfs/lib/ff.c:2945: di--;
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
;src/fatfs/lib/ff.c:2947: lfn[di] = 0;							/* LFN is created into the working buffer */
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
;src/fatfs/lib/ff.c:2948: if (di == 0) return FR_INVALID_NAME;	/* Reject null name */
	ld	a, b
	or	a, c
	jp	NZ, .l00131
	ld	a, $06
	jp	.l00195
.l00131:
;src/fatfs/lib/ff.c:2951: for (si = 0; lfn[si] == ' '; si++) ;	/* Remove leading spaces */
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
;src/fatfs/lib/ff.c:2952: if (si > 0 || lfn[si] == '.') cf |= NS_LOSS | NS_LFN;	/* Is there any leading space or dot? */
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
;src/fatfs/lib/ff.c:2953: while (di > 0 && lfn[di - 1] != '.') di--;	/* Find last dot (di<=si: no extension) */
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
;src/fatfs/lib/ff.c:2955: memset(dp->fn, ' ', 11);
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
;src/fatfs/lib/ff.c:2956: i = b = 0; ni = 8;
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
;src/fatfs/lib/ff.c:2958: wc = lfn[si++];					/* Get an LFN character */
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
;src/fatfs/lib/ff.c:2972: si = di; i = 8; ni = 11; b <<= 2;		/* Enter name extension */
	ld	hl, sp+22
	ld	a, [hl]
	add	a, a
	add	a, a
	ld	hl, sp+14
	ld	[hl], a
;src/fatfs/lib/ff.c:2959: if (wc == 0) break;				/* Break on end of the LFN */
	ld	hl, sp+11
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	jp	Z, .l00175
;src/fatfs/lib/ff.c:2917: if (wc < ' ' || IsSeparator(wc)) break;	/* Break if end of the path or a separator is found */
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
;src/fatfs/lib/ff.c:2952: if (si > 0 || lfn[si] == '.') cf |= NS_LOSS | NS_LFN;	/* Is there any leading space or dot? */
	ld	hl, sp+19
	ld	d, [hl]
	ld	a, d
	or	a, $03
	ld	d, a
;src/fatfs/lib/ff.c:2960: if (wc == ' ' || (wc == '.' && si != di)) {	/* Remove embedded spaces and dots */
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
;src/fatfs/lib/ff.c:2961: cf |= NS_LOSS | NS_LFN;
	ld	hl, sp+19
	ld	[hl], d
;src/fatfs/lib/ff.c:2962: continue;
	jp	.l00194
.l00143:
;src/fatfs/lib/ff.c:2965: if (i >= ni || si == di) {		/* End of field? */
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
;src/fatfs/lib/ff.c:2966: if (ni == 11) {				/* Name extension overflow? */
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
;src/fatfs/lib/ff.c:2967: cf |= NS_LOSS | NS_LFN;
	ld	hl, sp+19
	ld	[hl], d
;src/fatfs/lib/ff.c:2968: break;
	jp	.l00175
.l00147:
;src/fatfs/lib/ff.c:2970: if (si != di) cf |= NS_LOSS | NS_LFN;	/* Name body overflow? */
	bit	0, e
	jp	NZ, .l00149
	ld	hl, sp+19
	ld	[hl], d
.l00149:
;src/fatfs/lib/ff.c:2971: if (si > di) break;						/* No name extension? */
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
;src/fatfs/lib/ff.c:2972: si = di; i = 8; ni = 11; b <<= 2;		/* Enter name extension */
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
;src/fatfs/lib/ff.c:2973: continue;
	jp	.l00194
.l00153:
;src/fatfs/lib/ff.c:2976: if (wc >= 0x80) {	/* Is this an extended character? */
	ld	a, c
	sub	a, $80
	ld	a, b
	sbc	a, $00
	jp	C, .l00158
;src/fatfs/lib/ff.c:2977: cf |= NS_LFN;	/* LFN entry needs to be created */
	ld	hl, sp+19
	ld	a, [hl]
	or	a, $02
	ld	[hl], a
;src/fatfs/lib/ff.c:2986: wc = ff_uni2oem(wc, CODEPAGE);			/* Unicode ==> ANSI/OEM code */
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
;src/fatfs/lib/ff.c:2987: if (wc & 0x80) wc = ExCvt[wc & 0x7F];	/* Convert extended character to upper (SBCS) */
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
;src/fatfs/lib/ff.c:2917: if (wc < ' ' || IsSeparator(wc)) break;	/* Break if end of the path or a separator is found */
	ld	hl, sp+10
	ld	a, [hl]
	ld	hl, sp+13
	ld	[hl], a
	dec	hl
	dec	hl
	ld	a, [hl]
	ld	hl, sp+14
	ld	[hl], a
;src/fatfs/lib/ff.c:2952: if (si > 0 || lfn[si] == '.') cf |= NS_LOSS | NS_LFN;	/* Is there any leading space or dot? */
	ld	hl, sp+19
	ld	a, [hl]
	or	a, $03
	ld	hl, sp+12
	ld	[hl], a
;src/fatfs/lib/ff.c:2993: if (wc >= 0x100) {				/* Is this a DBC? */
	inc	hl
	ld	a, [hl]
	sub	a, $00
	inc	hl
	ld	a, [hl]
	sbc	a, $01
	jp	C, .l00172
;src/fatfs/lib/ff.c:2994: if (i >= ni - 1) {			/* Field overflow? */
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
;src/fatfs/lib/ff.c:2995: cf |= NS_LOSS | NS_LFN;
	ld	hl, sp+12
	ld	a, [hl]
	ld	hl, sp+19
	ld	[hl], a
;src/fatfs/lib/ff.c:2996: i = ni; continue;		/* Next field */
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
;src/fatfs/lib/ff.c:2998: dp->fn[i++] = (BYTE)(wc >> 8);	/* Put 1st byte */
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
;src/fatfs/lib/ff.c:3000: if (wc == 0 || strchr("+,;=[]", (int)wc)) {	/* Replace illegal characters for SFN */
	ld	hl, sp+11
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	jp	Z, .l00167
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	ld	de, ___src_fatfs_fatfs_c_str_1
	call	_strchr
	ld	a, b
	or	a, c
	jp	Z, .l00168
.l00167:
;src/fatfs/lib/ff.c:3001: wc = '_'; cf |= NS_LOSS | NS_LFN;/* Lossy conversion */
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
;src/fatfs/lib/ff.c:3003: if (IsUpper(wc)) {		/* ASCII upper case? */
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
;src/fatfs/lib/ff.c:3004: b |= 2;
	ld	hl, sp+22
	ld	a, [hl]
	or	a, $02
	ld	[hl], a
.l00162:
;src/fatfs/lib/ff.c:3006: if (IsLower(wc)) {		/* ASCII lower case? */
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
;src/fatfs/lib/ff.c:3007: b |= 1; wc -= 0x20;
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
;src/fatfs/lib/ff.c:3011: dp->fn[i++] = (BYTE)wc;
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
;src/fatfs/lib/ff.c:3014: if (dp->fn[0] == DDEM) dp->fn[0] = RDDEM;	/* If the first character collides with DDEM, replace it with RDDEM */
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
;src/fatfs/lib/ff.c:3016: if (ni == 8) b <<= 2;				/* Shift capital flags if no extension */
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
;src/fatfs/lib/ff.c:3017: if ((b & 0x0C) == 0x0C || (b & 0x03) == 0x03) cf |= NS_LFN;	/* LFN entry needs to be created if composite capitals */
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
;src/fatfs/lib/ff.c:3018: if (!(cf & NS_LFN)) {				/* When LFN is in 8.3 format without extended character, NT flags are created */
	push	hl
	ld	hl, sp+21
	bit	1, [hl]
	pop	hl
	jp	NZ,.l00473
	jp	.l00474
.l00473:
	jp	.l00188
.l00474:
;src/fatfs/lib/ff.c:3019: if (b & 0x01) cf |= NS_EXT;		/* NT flag (Extension has small capital letters only) */
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
;src/fatfs/lib/ff.c:3020: if (b & 0x04) cf |= NS_BODY;	/* NT flag (Body has small capital letters only) */
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
;src/fatfs/lib/ff.c:3023: dp->fn[NSFLAG] = cf;	/* SFN is created into dp->fn[] */
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
;src/fatfs/lib/ff.c:3025: return FR_OK;
	xor	a, a
.l00195:
;src/fatfs/lib/ff.c:3096: }
	add	sp, 25
	ret
	SECTION FRAGMENT "src/fatfs/fatfs.c ROM0",ROM0
___src_fatfs_fatfs_c_str_0:
	DB "*:<>|"
	DB $22
	DB "?"
	DB $7F
	DB $00
	SECTION FRAGMENT "src/fatfs/fatfs.c ROM0",ROM0
___src_fatfs_fatfs_c_str_1:
	DB "+,;=[]"
	DB $00
;src/fatfs/lib/ff.c:3105: static FRESULT follow_path (	/* FR_OK(0): successful, !=0: error code */
;	---------------------------------
	SECTION FRAGMENT "Page 7",ROMX,BANK[3]
	LOAD FRAGMENT "Page 7 RAM",SRAM,BANK[7]
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
;src/fatfs/lib/ff.c:3112: FATFS *fs = dp->obj.fs;
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
;src/fatfs/lib/ff.c:3122: while (IsSeparator(*path)) path++;	/* Strip heading separators */
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
;src/fatfs/lib/ff.c:3123: dp->obj.sclust = 0;					/* Start at the root directory */
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
;src/fatfs/lib/ff.c:3146: if ((UINT)*path < ' ') {				/* Null path name is the origin directory itself */
	ld	hl, sp+14
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	ld	a, [bc]
	ld	c, a
	ld	b, $00
;src/fatfs/lib/ff.c:3147: dp->fn[NSFLAG] = NS_NONAME;
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
;src/fatfs/lib/ff.c:3146: if ((UINT)*path < ' ') {				/* Null path name is the origin directory itself */
	ld	a, c
	sub	a, $20
	ld	a, b
	sbc	a, $00
	jp	NC, .l00140
;src/fatfs/lib/ff.c:3147: dp->fn[NSFLAG] = NS_NONAME;
	dec	hl
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	ld	[hl], $80
;src/fatfs/lib/ff.c:3148: res = dir_sdi(dp, 0);
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
;src/fatfs/lib/ff.c:3152: res = create_name(dp, &path);	/* Get a segment name of the path */
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
;src/fatfs/lib/ff.c:3153: if (res != FR_OK) break;
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00127
;src/fatfs/lib/ff.c:3154: ns = dp->fn[NSFLAG];
	ld	hl, sp+5
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	ld	c, a
;src/fatfs/lib/ff.c:3175: res = dir_find(dp);				/* Find an object with the segment name */
	push	bc
	ld	hl, sp+18
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_dir_find
	pop	bc
	ld	hl, sp+13
	ld	[hl], a
;src/fatfs/lib/ff.c:3183: if (!(ns & NS_LAST)) res = FR_NO_PATH;	/* Adjust error code if not last segment */
	ld	a, c
	and	a, $04
	ld	c, a
	ld	b, $00
;src/fatfs/lib/ff.c:3176: if (res != FR_OK) {				/* Failed to find the object */
	ld	a, [hl]
	or	a, a
	jp	Z, .l00118
;src/fatfs/lib/ff.c:3177: if (res == FR_NO_FILE) {	/* Object is not found */
	ld	a, [hl]
	sub	a, $04
	jp	NZ,.l00185
	jp	.l00186
.l00185:
	jp	.l00127
.l00186:
;src/fatfs/lib/ff.c:3183: if (!(ns & NS_LAST)) res = FR_NO_PATH;	/* Adjust error code if not last segment */
	ld	a, b
	or	a, c
	jp	NZ, .l00127
	ld	hl, sp+13
	ld	[hl], $05
;src/fatfs/lib/ff.c:3186: break;
	jp	.l00127
.l00118:
;src/fatfs/lib/ff.c:3198: if (ns & NS_LAST) break;		/* If last segment matched, the function completed */
	ld	a, b
	or	a, c
	jp	NZ, .l00127
;src/fatfs/lib/ff.c:3200: if (!(dp->obj.attr & AM_DIR)) {
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
;src/fatfs/lib/ff.c:3201: res = FR_NO_PATH; break;	/* It is not a sub-directory and cannot follow the path */
	ld	hl, sp+13
	ld	[hl], $05
	jp	.l00127
.l00122:
;src/fatfs/lib/ff.c:3209: dp->obj.sclust = ld_clust(fs, fs->win + dp->dptr % SS(fs));	/* Open next directory */
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
;src/fatfs/lib/ff.c:3214: return res;
	ld	hl, sp+13
	ld	a, [hl]
.l00129:
;src/fatfs/lib/ff.c:3215: }
	add	sp, 18
	ret
;src/fatfs/lib/ff.c:3224: static int get_ldnumber (	/* Returns logical drive number (-1:invalid drive number or null pointer) */
;	---------------------------------
	SECTION FRAGMENT "Page 9",ROMX,BANK[4]
	LOAD FRAGMENT "Page 9 RAM",SRAM,BANK[9]
; Function get_ldnumber
; ---------------------------------
_get_ldnumber:
	add	sp, -9
	ld	hl, sp+7
	ld	[hl], e
	inc	hl
	ld	[hl], d
;src/fatfs/lib/ff.c:3237: tt = tp = *path;
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
;src/fatfs/lib/ff.c:3238: if (!tp) return -1;		/* Invalid path name? */
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	jp	NZ, .l00119
	ld	bc, $FFFF
	jp	.l00115
;src/fatfs/lib/ff.c:3239: do {					/* Find a colon in the path */
.l00119:
	ld	hl, sp+5
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
.l00104:
;src/fatfs/lib/ff.c:3240: chr = *tt++;
	ld	a, [bc]
	inc	bc
;src/fatfs/lib/ff.c:3241: } while (!IsTerminator(chr) && chr != ':');
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
;src/fatfs/lib/ff.c:3243: if (chr == ':') {	/* Is there a DOS/Windows style volume ID? */
	ld	a, e
	or	a, a
	jp	Z, .l00114
;src/fatfs/lib/ff.c:3244: i = FF_VOLUMES;
	inc	hl
	ld	[hl], $01
	xor	a, a
	inc	hl
	ld	[hl], a
;src/fatfs/lib/ff.c:3245: if (IsDigit(*tp) && tp + 2 == tt) {	/* Is it a numeric volume ID + colon? */
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
;src/fatfs/lib/ff.c:3246: i = (int)*tp - '0';	/* Get the logical drive number */
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
;src/fatfs/lib/ff.c:3261: if (i >= FF_VOLUMES) return -1;	/* Not found or invalid volume ID */
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
;src/fatfs/lib/ff.c:3262: *path = tt;		/* Snip the drive prefix off */
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
;src/fatfs/lib/ff.c:3263: return i;		/* Return the found drive number */
	inc	hl
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	jp	.l00115
.l00114:
;src/fatfs/lib/ff.c:3286: return 0;				/* Default drive is 0 */
	ld	bc, $0000
.l00115:
;src/fatfs/lib/ff.c:3288: }
	add	sp, 9
	ret
;src/fatfs/lib/ff.c:3371: static UINT check_fs (	/* 0:FAT/FAT32 VBR, 1:exFAT VBR, 2:Not FAT and valid BS, 3:Not FAT and invalid BS, 4:Disk error */
;	---------------------------------
	SECTION FRAGMENT "Page 9",ROMX,BANK[4]
	LOAD FRAGMENT "Page 9 RAM",SRAM,BANK[9]
; Function check_fs
; ---------------------------------
_check_fs:
	add	sp, -4
	ld	hl, sp+2
	ld	[hl], e
	inc	hl
	ld	[hl], d
;src/fatfs/lib/ff.c:3380: fs->wflag = 0; fs->winsect = (LBA_t)0 - 1;		/* Invaidate window */
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
;src/fatfs/lib/ff.c:3381: if (move_window(fs, sect) != FR_OK) return 4;	/* Load the boot sector */
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
	call	_move_window__far
	or	a, a
	jp	Z, .l00102
	ld	bc, $0004
	jp	.l00122
.l00102:
;src/fatfs/lib/ff.c:3382: sign = ld_16(fs->win + BS_55AA);
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
;src/fatfs/lib/ff.c:3386: b = fs->win[BS_JmpBoot];
	ld	a, [de]
	ld	e, a
;src/fatfs/lib/ff.c:3388: if (sign == 0xAA55 && !memcmp(fs->win + BS_FilSysType32, "FAT32   ", 8)) {
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
;src/fatfs/lib/ff.c:3387: if (b == 0xEB || b == 0xE9 || b == 0xE8) {	/* Valid JumpBoot code? (short jump, near jump or near call) */
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
;src/fatfs/lib/ff.c:3388: if (sign == 0xAA55 && !memcmp(fs->win + BS_FilSysType32, "FAT32   ", 8)) {
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
	ld	bc, ___src_fatfs_fatfs_c_str_2
	ld	e, l
	ld	d, h
	call	_memcmp
	pop	de
	ld	a, b
	or	a, c
	jp	NZ, .l00104
;src/fatfs/lib/ff.c:3389: return 0;	/* It is an FAT32 VBR */
	ld	bc, $0000
	jp	.l00122
.l00104:
;src/fatfs/lib/ff.c:3392: w = ld_16(fs->win + BPB_BytsPerSec);
	ld	hl, $000B
	add	hl, de
	push	de
	ld	e, l
	ld	d, h
	call	_ld_16
	pop	de
;src/fatfs/lib/ff.c:3393: b = fs->win[BPB_SecPerClus];
	ld	hl, $000D
	add	hl, de
	ld	a, [hl]
	ld	hl, sp+1
	ld	[hl], a
;src/fatfs/lib/ff.c:3394: if ((w & (w - 1)) == 0 && w >= FF_MIN_SS && w <= FF_MAX_SS	/* Properness of sector size (512-4096 and 2^n) */
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
;src/fatfs/lib/ff.c:3395: && b != 0 && (b & (b - 1)) == 0				/* Properness of cluster size (2^n) */
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
;src/fatfs/lib/ff.c:3396: && ld_16(fs->win + BPB_RsvdSecCnt) != 0		/* Properness of number of reserved sectors (MNBZ) */
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
;src/fatfs/lib/ff.c:3397: && (UINT)fs->win[BPB_NumFATs] - 1 <= 1		/* Properness of number of FATs (1 or 2) */
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
;src/fatfs/lib/ff.c:3398: && ld_16(fs->win + BPB_RootEntCnt) != 0		/* Properness of root dir size (MNBZ) */
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
;src/fatfs/lib/ff.c:3399: && (ld_16(fs->win + BPB_TotSec16) >= MIN_VOLUME || ld_32(fs->win + BPB_TotSec32) >= 0x10000)	/* Properness of volume size (>=128) */
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
;src/fatfs/lib/ff.c:3400: && ld_16(fs->win + BPB_FATSz16) != 0) {		/* Properness of FAT size (MNBZ) */
	ld	hl, $0016
	add	hl, de
	ld	e, l
	ld	d, h
	call	_ld_16
	ld	a, b
	or	a, c
	jp	Z, .l00119
;src/fatfs/lib/ff.c:3401: return 0;	/* It can be presumed an FAT VBR */
	ld	bc, $0000
	jp	.l00122
.l00119:
;src/fatfs/lib/ff.c:3404: return sign == 0xAA55 ? 2 : 3;	/* Not an FAT VBR (with valid or invalid BS) */
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
;src/fatfs/lib/ff.c:3405: }
	add	sp, 4
	pop	hl
	add	sp, 4
	jp hl
	SECTION FRAGMENT "src/fatfs/fatfs.c ROM0",ROM0
___src_fatfs_fatfs_c_str_2:
	DB "FAT32   "
	DB $00
;src/fatfs/lib/ff.c:3411: static UINT find_volume (	/* Returns BS status found in the hosting drive */
;	---------------------------------
	SECTION FRAGMENT "Page 9",ROMX,BANK[4]
	LOAD FRAGMENT "Page 9 RAM",SRAM,BANK[9]
; Function find_volume
; ---------------------------------
_find_volume:
	add	sp, -28
	ld	hl, sp+24
	ld	[hl], e
	inc	hl
	ld	[hl], d
;src/fatfs/lib/ff.c:3420: fmt = check_fs(fs, 0);				/* Load sector 0 and check if it is an FAT VBR as SFD format */
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
;src/fatfs/lib/ff.c:3421: if (fmt != 2 && (fmt >= 3 || part == 0)) return fmt;	/* Returns if it is an FAT VBR as auto scan, not a BS or disk error */
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
;src/fatfs/lib/ff.c:3448: for (i = 0; i < 4; i++) {		/* Load partition offset in the MBR */
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
;src/fatfs/lib/ff.c:3449: mbr_pt[i] = ld_32(fs->win + MBR_Table + i * SZ_PTE + PTE_StLba);
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
;src/fatfs/lib/ff.c:3448: for (i = 0; i < 4; i++) {		/* Load partition offset in the MBR */
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
;src/fatfs/lib/ff.c:3451: i = part ? part - 1 : 0;		/* Table index to find first */
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
;src/fatfs/lib/ff.c:3452: do {							/* Find an FAT volume */
.l00111:
;src/fatfs/lib/ff.c:3453: fmt = mbr_pt[i] ? check_fs(fs, mbr_pt[i]) : 3;	/* Check if the partition is FAT */
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
;src/fatfs/lib/ff.c:3454: } while (part == 0 && fmt >= 2 && ++i < 4);
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
;src/fatfs/lib/ff.c:3455: return fmt;
	ld	c, e
	ld	b, d
.l00116:
;src/fatfs/lib/ff.c:3456: }
	add	sp, 28
	ret
;src/fatfs/lib/ff.c:3465: static FRESULT mount_volume (	/* FR_OK(0): successful, !=0: an error occurred */
;	---------------------------------
	SECTION FRAGMENT "Page 9",ROMX,BANK[4]
	LOAD FRAGMENT "Page 9 RAM",SRAM,BANK[9]
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
;src/fatfs/lib/ff.c:3479: *rfs = 0;
	dec	hl
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	xor	a, a
	ld	[hl], a
	inc	hl
	ld	[hl], a
;src/fatfs/lib/ff.c:3480: vol = get_ldnumber(path);
	ld	hl, sp+40
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_get_ldnumber
	ld	hl, sp+36
	ld	[hl], c
	inc	hl
	ld	[hl], b
;src/fatfs/lib/ff.c:3481: if (vol < 0) return FR_INVALID_DRIVE;
	ld	a, [hl]
	bit	7, a
	jp	Z, .l00102
	ld	a, $0B
	jp	.l00174
.l00102:
;src/fatfs/lib/ff.c:3484: fs = FatFs[vol];					/* Get pointer to the filesystem object */
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
;src/fatfs/lib/ff.c:3485: if (!fs) return FR_NOT_ENABLED;		/* Is the filesystem object available? */
	ld	hl, sp+5
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	jp	NZ, .l00104
	ld	a, $0C
	jp	.l00174
.l00104:
;src/fatfs/lib/ff.c:3489: *rfs = fs;							/* Return pointer to the filesystem object */
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
;src/fatfs/lib/ff.c:3491: mode &= (BYTE)~FA_READ;				/* Desired access mode, write access or not */
	ld	hl, sp+44
	ld	a, [hl]
	and	a, $FE
	ld	[hl], a
;src/fatfs/lib/ff.c:3492: if (fs->fs_type != 0) {				/* If the volume has been mounted */
	ld	hl, sp+5
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
;src/fatfs/lib/ff.c:3493: stat = disk_status(fs->pdrv);
	dec	hl
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	inc	bc
;src/fatfs/lib/ff.c:3492: if (fs->fs_type != 0) {				/* If the volume has been mounted */
	or	a, a
	jp	Z, .l00112
;src/fatfs/lib/ff.c:3493: stat = disk_status(fs->pdrv);
	ld	a, [bc]
	ld	e, a
	push	bc
	ld	a, e
	call	_disk_status
	pop	bc
	ld	e, a
;src/fatfs/lib/ff.c:3494: if (!(stat & STA_NOINIT)) {		/* and the physical drive is kept initialized */
	bit	0, e
	jp	NZ,.l00374
	jp	.l00375
.l00374:
	jp	.l00112
.l00375:
;src/fatfs/lib/ff.c:3495: if (!FF_FS_READONLY && mode && (stat & STA_PROTECT)) {	/* Check write protection if needed */
	ld	hl, sp+44
	ld	a, [hl]
	or	a, a
	jp	Z, .l00106
	bit	2, e
	jp	NZ,.l00376
	jp	.l00106
.l00376:
;src/fatfs/lib/ff.c:3496: return FR_WRITE_PROTECTED;
	ld	a, $0A
	jp	.l00174
.l00106:
;src/fatfs/lib/ff.c:3498: return FR_OK;				/* The filesystem object is already valid */
	xor	a, a
	jp	.l00174
.l00112:
;src/fatfs/lib/ff.c:3505: fs->fs_type = 0;					/* Invalidate the filesystem object */
	ld	hl, sp+4
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	ld	[hl], $00
;src/fatfs/lib/ff.c:3506: stat = disk_initialize(fs->pdrv);	/* Initialize the volume hosting physical drive */
	ld	a, [bc]
	ld	c, a
	ld	a, c
	call	_disk_initialize
	ld	c, a
;src/fatfs/lib/ff.c:3507: if (stat & STA_NOINIT) { 			/* Check if the initialization succeeded */
	bit	0, c
	jp	NZ,.l00377
	jp	.l00117
.l00377:
;src/fatfs/lib/ff.c:3508: return FR_NOT_READY;			/* Failed to initialize due to no medium or hard error */
	ld	a, $03
	jp	.l00174
;src/fatfs/lib/ff.c:3510: if (!FF_FS_READONLY && mode && (stat & STA_PROTECT)) { /* Check disk write protection if needed */
.l00117:
	ld	hl, sp+44
	ld	a, [hl]
	or	a, a
	jp	Z, .l00116
	bit	2, c
	jp	NZ,.l00378
	jp	.l00116
.l00378:
;src/fatfs/lib/ff.c:3511: return FR_WRITE_PROTECTED;
	ld	a, $0A
	jp	.l00174
.l00116:
;src/fatfs/lib/ff.c:3519: fmt = find_volume(fs, LD2PT(vol));
	ld	bc, $0000
	ld	hl, sp+4
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_find_volume
;src/fatfs/lib/ff.c:3520: if (fmt == 4) return FR_DISK_ERR;		/* An error occurred in the disk I/O layer */
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
;src/fatfs/lib/ff.c:3521: if (fmt >= 2) return FR_NO_FILESYSTEM;	/* No FAT volume is found */
	ld	a, c
	sub	a, $02
	ld	a, b
	sbc	a, $00
	jp	C, .l00122
	ld	a, $0D
	jp	.l00174
.l00122:
;src/fatfs/lib/ff.c:3522: bsect = fs->winsect;					/* Volume offset in the hosting physical drive */
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
;src/fatfs/lib/ff.c:3593: if (ld_16(fs->win + BPB_BytsPerSec) != SS(fs)) return FR_NO_FILESYSTEM;	/* (BPB_BytsPerSec must be equal to the physical sector size) */
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
;src/fatfs/lib/ff.c:3595: fasize = ld_16(fs->win + BPB_FATSz16);		/* Number of sectors per FAT */
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
;src/fatfs/lib/ff.c:3596: if (fasize == 0) fasize = ld_32(fs->win + BPB_FATSz32);
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
;src/fatfs/lib/ff.c:3597: if (fasize >= 0x200000) return FR_NO_FILESYSTEM;	/* (Must be smaller than max FAT size) */
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
;src/fatfs/lib/ff.c:3598: fs->fsize = fasize;
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
;src/fatfs/lib/ff.c:3600: fs->n_fats = fs->win[BPB_NumFATs];				/* Number of FATs */
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
;src/fatfs/lib/ff.c:3601: if (fs->n_fats != 1 && fs->n_fats != 2) return FR_NO_FILESYSTEM;	/* (Must be 1 or 2) */
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
;src/fatfs/lib/ff.c:3602: fasize *= fs->n_fats;							/* Number of sectors for FAT area */
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
;src/fatfs/lib/ff.c:3604: fs->csize = fs->win[BPB_SecPerClus];			/* Cluster size */
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
;src/fatfs/lib/ff.c:3605: if (fs->csize == 0 || (fs->csize & (fs->csize - 1))) return FR_NO_FILESYSTEM;	/* (Must be power of 2) */
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
;src/fatfs/lib/ff.c:3607: fs->n_rootdir = ld_16(fs->win + BPB_RootEntCnt);	/* Number of root directory entries */
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
;src/fatfs/lib/ff.c:3608: if (fs->n_rootdir % (SS(fs) / SZDIRE)) return FR_NO_FILESYSTEM;	/* (Must be sector aligned) */
	ld	a, c
	and	a, $0F
	jp	NZ,.l00384
	jp	.l00136
.l00384:
	ld	a, $0D
	jp	.l00174
.l00136:
;src/fatfs/lib/ff.c:3610: tsect = ld_16(fs->win + BPB_TotSec16);			/* Number of sectors on the volume */
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
;src/fatfs/lib/ff.c:3611: if (tsect == 0) tsect = ld_32(fs->win + BPB_TotSec32);
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
;src/fatfs/lib/ff.c:3613: nrsv = ld_16(fs->win + BPB_RsvdSecCnt);			/* Number of reserved sectors */
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
;src/fatfs/lib/ff.c:3614: if (nrsv == 0) return FR_NO_FILESYSTEM;			/* (Must not be 0) */
	ld	a, b
	or	a, c
	jp	NZ, .l00140
	ld	a, $0D
	jp	.l00174
.l00140:
;src/fatfs/lib/ff.c:3617: sysect = nrsv + fasize + fs->n_rootdir / (SS(fs) / SZDIRE);	/* RSV + FAT + DIR */
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
;src/fatfs/lib/ff.c:3618: if (tsect < sysect) return FR_NO_FILESYSTEM;	/* (Invalid volume size) */
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
;src/fatfs/lib/ff.c:3619: nclst = (tsect - sysect) / fs->csize;			/* Number of clusters */
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
;src/fatfs/lib/ff.c:3620: if (nclst == 0) return FR_NO_FILESYSTEM;		/* (Invalid volume size) */
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
;src/fatfs/lib/ff.c:3621: fmt = 0;
	xor	a, a
	ld	hl, sp+28
	ld	[hl], a
	inc	hl
	ld	[hl], a
;src/fatfs/lib/ff.c:3622: if (nclst <= MAX_FAT32) fmt = FS_FAT32;
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
;src/fatfs/lib/ff.c:3623: if (nclst <= MAX_FAT16) fmt = FS_FAT16;
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
;src/fatfs/lib/ff.c:3624: if (nclst <= MAX_FAT12) fmt = FS_FAT12;
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
;src/fatfs/lib/ff.c:3625: if (nclst <= MIN_FAT12) fmt = 0;
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
;src/fatfs/lib/ff.c:3626: if (fmt == 0) return FR_NO_FILESYSTEM;
	ld	hl, sp+29
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	jp	NZ, .l00154
	ld	a, $0D
	jp	.l00174
.l00154:
;src/fatfs/lib/ff.c:3629: fs->n_fatent = nclst + 2;						/* Number of FAT entries */
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
;src/fatfs/lib/ff.c:3630: fs->volbase = bsect;							/* Volume start sector */
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
;src/fatfs/lib/ff.c:3631: fs->fatbase = bsect + nrsv; 					/* FAT start sector */
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
;src/fatfs/lib/ff.c:3632: fs->database = bsect + sysect;					/* Data start sector */
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
;src/fatfs/lib/ff.c:3633: if (fmt == FS_FAT32) {
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
;src/fatfs/lib/ff.c:3636: fs->dirbase = ld_32(fs->win + BPB_RootClus32);	/* Root directory start cluster */
	ld	hl, sp+5
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $002A
	add	hl, de
	ld	c, l
	ld	b, h
;src/fatfs/lib/ff.c:3633: if (fmt == FS_FAT32) {
	ld	hl, sp+37
	ld	a, [hl]
	or	a, a
	jp	Z, .l00162
;src/fatfs/lib/ff.c:3634: if (ld_16(fs->win + BPB_FSVer32) != 0) return FR_NO_FILESYSTEM;	/* (Must be FAT32 revision 0.0) */
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
;src/fatfs/lib/ff.c:3635: if (fs->n_rootdir != 0) return FR_NO_FILESYSTEM;	/* (BPB_RootEntCnt must be 0) */
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
;src/fatfs/lib/ff.c:3636: fs->dirbase = ld_32(fs->win + BPB_RootClus32);	/* Root directory start cluster */
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
;src/fatfs/lib/ff.c:3637: szbfat = fs->n_fatent * 4;					/* (Needed FAT size) */
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
;src/fatfs/lib/ff.c:3639: if (fs->n_rootdir == 0)	return FR_NO_FILESYSTEM;	/* (BPB_RootEntCnt must not be 0) */
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
;src/fatfs/lib/ff.c:3640: fs->dirbase = fs->fatbase + fasize;			/* Root directory start sector */
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
;src/fatfs/lib/ff.c:3637: szbfat = fs->n_fatent * 4;					/* (Needed FAT size) */
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
;src/fatfs/lib/ff.c:3641: szbfat = (fmt == FS_FAT16) ?				/* (Needed FAT size) */
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
;src/fatfs/lib/ff.c:3642: fs->n_fatent * 2 : fs->n_fatent * 3 / 2 + (fs->n_fatent & 1);
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
;src/fatfs/lib/ff.c:3644: if (fs->fsize < (szbfat + (SS(fs) - 1)) / SS(fs)) return FR_NO_FILESYSTEM;	/* (BPB_FATSz must not be less than the size needed) */
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
;src/fatfs/lib/ff.c:3648: fs->last_clst = fs->free_clst = 0xFFFFFFFF;		/* Invalidate cluster allocation information */
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
;src/fatfs/lib/ff.c:3649: fs->fsi_flag = 0x80;	/* Disable FSInfo by default */
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
;src/fatfs/lib/ff.c:3651: && ld_16(fs->win + BPB_FSInfo32) == 1	/* FAT32: Enable FSInfo feature only if FSInfo sector is next to VBR */
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
;src/fatfs/lib/ff.c:3652: && move_window(fs, bsect + 1) == FR_OK)
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
	call	_move_window__far
	pop	bc
	or	a, a
	jp	NZ, .l00171
;src/fatfs/lib/ff.c:3654: fs->fsi_flag = 0;
	xor	a, a
	ld	[bc], a
;src/fatfs/lib/ff.c:3655: if (   ld_32(fs->win + FSI_LeadSig) == 0x41615252	/* Load FSInfo data if available */
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
;src/fatfs/lib/ff.c:3656: && ld_32(fs->win + FSI_StrucSig) == 0x61417272
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
;src/fatfs/lib/ff.c:3657: && ld_32(fs->win + FSI_TrailSig) == 0xAA550000)
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
;src/fatfs/lib/ff.c:3660: fs->free_clst = ld_32(fs->win + FSI_Free_Count);
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
;src/fatfs/lib/ff.c:3663: fs->last_clst = ld_32(fs->win + FSI_Nxt_Free);
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
;src/fatfs/lib/ff.c:3670: fs->fs_type = (BYTE)fmt;/* FAT sub-type (the filesystem object gets valid) */
	ld	hl, sp+28
	ld	c, [hl]
	ld	hl, sp+4
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	ld	[hl], c
;src/fatfs/lib/ff.c:3671: fs->id = ++Fsid;		/* Volume mount ID */
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
;src/fatfs/lib/ff.c:3674: fs->lfnbuf = LfnBuf;	/* LFN working buffer */
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
;src/fatfs/lib/ff.c:3691: return FR_OK;
	xor	a, a
.l00174:
;src/fatfs/lib/ff.c:3692: }
	add	sp, 42
	pop	hl
	inc	sp
	jp hl
;src/fatfs/lib/ff.c:3701: static FRESULT validate (	/* Returns FR_OK or FR_INVALID_OBJECT */
;	---------------------------------
	SECTION FRAGMENT "Page 7",ROMX,BANK[3]
	LOAD FRAGMENT "Page 7 RAM",SRAM,BANK[7]
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
;src/fatfs/lib/ff.c:3706: FRESULT res = FR_INVALID_OBJECT;
	ld	hl, sp+0
	ld	[hl], $09
;src/fatfs/lib/ff.c:3709: if (obj && obj->fs && obj->fs->fs_type && obj->id == obj->fs->id) {	/* Test if the object is valid */
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
;src/fatfs/lib/ff.c:3721: if (!(disk_status(obj->fs->pdrv) & STA_NOINIT)) { /* Test if the hosting physical drive is kept initialized */
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
;src/fatfs/lib/ff.c:3722: res = FR_OK;
	ld	hl, sp+0
	ld	[hl], $00
.l00104:
;src/fatfs/lib/ff.c:3726: *rfs = (res == FR_OK) ? obj->fs : 0;	/* Return corresponding filesystem object if it is valid */
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
;src/fatfs/lib/ff.c:3727: return res;
	ld	hl, sp+0
	ld	a, [hl]
.l00108:
;src/fatfs/lib/ff.c:3728: }
	add	sp, 9
	ret
;src/fatfs/lib/ff.c:3745: FRESULT f_mount (
;	---------------------------------
	SECTION FRAGMENT "Page 9",ROMX,BANK[4]
	LOAD FRAGMENT "Page 9 RAM",SRAM,BANK[9]
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
;src/fatfs/lib/ff.c:3754: const TCHAR *rp = path;
	dec	hl
	ld	a, [hl]
	ld	hl, sp+0
	ld	[hl], a
	ld	hl, sp+7
	ld	a, [hl]
	ld	hl, sp+1
	ld	[hl], a
;src/fatfs/lib/ff.c:3758: vol = get_ldnumber(&rp);
	ld	hl, sp+0
	ld	e, l
	ld	d, h
	call	_get_ldnumber
	ld	hl, sp+2
	ld	[hl], c
	inc	hl
	ld	[hl], b
;src/fatfs/lib/ff.c:3759: if (vol < 0) return FR_INVALID_DRIVE;
	ld	a, [hl]
	bit	7, a
	jp	Z, .l00102
	ld	a, $0B
	jp	.l00109
.l00102:
;src/fatfs/lib/ff.c:3761: cfs = FatFs[vol];			/* Pointer to the filesystem object of the volume */
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
;src/fatfs/lib/ff.c:3762: if (cfs) {					/* Unregister current filesystem object */
	or	a, l
	jp	Z, .l00104
;src/fatfs/lib/ff.c:3763: FatFs[vol] = 0;
	ld	hl, sp+4
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	xor	a, a
	ld	[hl], a
	inc	hl
	ld	[hl], a
;src/fatfs/lib/ff.c:3770: cfs->fs_type = 0;		/* Invalidate the filesystem object to be unregistered */
	xor	a, a
	ld	[bc], a
.l00104:
;src/fatfs/lib/ff.c:3773: if (fs) {					/* Register new filesystem object */
	ld	hl, sp+9
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	jp	Z, .l00106
;src/fatfs/lib/ff.c:3774: fs->pdrv = LD2PD(vol);	/* Volume hosting physical drive */
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	inc	bc
	ld	hl, sp+2
	ld	a, [hl]
	ld	[bc], a
;src/fatfs/lib/ff.c:3788: fs->fs_type = 0;		/* Invalidate the new filesystem object */
	ld	hl, sp+8
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	xor	a, a
	ld	[bc], a
;src/fatfs/lib/ff.c:3789: FatFs[vol] = fs;		/* Register it */
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
;src/fatfs/lib/ff.c:3792: if (opt == 0) return FR_OK;	/* Do not mount now, it will be mounted in subsequent file functions */
	ld	hl, sp+12
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00108
	xor	a, a
	jp	.l00109
.l00108:
;src/fatfs/lib/ff.c:3794: res = mount_volume(&path, &fs, 0);	/* Force mounted the volume in this function */
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
;src/fatfs/lib/ff.c:3795: LEAVE_FF(fs, res);
.l00109:
;src/fatfs/lib/ff.c:3796: }
	add	sp, 10
	pop	hl
	inc	sp
	jp hl
;src/fatfs/lib/ff.c:3805: FRESULT f_open (
;	---------------------------------
	SECTION FRAGMENT "Page 7",ROMX,BANK[3]
	LOAD FRAGMENT "Page 7 RAM",SRAM,BANK[7]
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
;src/fatfs/lib/ff.c:3817: if (!fp) return FR_INVALID_OBJECT;	/* Reject null pointer */
	inc	hl
	inc	hl
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	jp	NZ, .l00102
	ld	a, $09
	jp	.l00163
.l00102:
;src/fatfs/lib/ff.c:3820: mode &= FF_FS_READONLY ? FA_READ : FA_READ | FA_WRITE | FA_CREATE_ALWAYS | FA_CREATE_NEW | FA_OPEN_ALWAYS | FA_OPEN_APPEND;
	ld	hl, sp+67
	ld	a, [hl]
	and	a, $3F
	ld	[hl], a
;src/fatfs/lib/ff.c:3821: res = mount_volume(&path, &fs, mode);
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
;src/fatfs/lib/ff.c:3823: if (res == FR_OK) {
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00156
;src/fatfs/lib/ff.c:3824: fp->obj.fs = fs;
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
;src/fatfs/lib/ff.c:3825: dj.obj.fs = fs;
	dec	hl
	ld	a, [hl]
	ld	hl, sp+0
	ld	[hl], a
	ld	hl, sp+45
	ld	a, [hl]
	ld	hl, sp+1
	ld	[hl], a
;src/fatfs/lib/ff.c:3827: res = follow_path(&dj, path);	/* Follow the file path */
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
;src/fatfs/lib/ff.c:3829: if (res == FR_OK) {
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00106
;src/fatfs/lib/ff.c:3830: if (dj.fn[NSFLAG] & NS_NONAME) {	/* Origin directory itself? */
	ld	hl, sp+39
	ld	a, [hl]
	rlca
	jp	C,.l00320
	jp	.l00106
.l00320:
;src/fatfs/lib/ff.c:3831: res = FR_INVALID_NAME;
	ld	hl, sp+46
	ld	[hl], $06
.l00106:
;src/fatfs/lib/ff.c:3820: mode &= FF_FS_READONLY ? FA_READ : FA_READ | FA_WRITE | FA_CREATE_ALWAYS | FA_CREATE_NEW | FA_OPEN_ALWAYS | FA_OPEN_APPEND;
	ld	hl, sp+67
	ld	a, [hl]
	ld	hl, sp+52
	ld	[hl], a
;src/fatfs/lib/ff.c:3855: if (dj.obj.attr & (AM_RDO | AM_DIR)) res = FR_DENIED;	/* Cannot overwrite it (R/O or DIR) */
;src/fatfs/lib/ff.c:3881: st_32(dj.dir + DIR_CrtTime, tm);	/* Set created time */
;src/fatfs/lib/ff.c:3840: if (mode & (FA_CREATE_ALWAYS | FA_OPEN_ALWAYS | FA_CREATE_NEW)) {
	ld	hl, sp+67
	ld	a, [hl]
	and	a, $1C
	jp	NZ,.l00321
	jp	.l00133
.l00321:
;src/fatfs/lib/ff.c:3841: if (res != FR_OK) {					/* No file, create new */
	ld	hl, sp+46
	ld	a, [hl]
	or	a, a
	jp	Z, .l00115
;src/fatfs/lib/ff.c:3842: if (res == FR_NO_FILE) {		/* There is no file to open, create a new entry */
	ld	a, [hl]
	sub	a, $04
	jp	NZ,.l00322
	jp	.l00323
.l00322:
	jp	.l00108
.l00323:
;src/fatfs/lib/ff.c:3846: res = dir_register(&dj);
	ld	hl, 0
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_dir_register__far
	ld	hl, sp+46
	ld	[hl], a
.l00108:
;src/fatfs/lib/ff.c:3849: mode |= FA_CREATE_ALWAYS;		/* File is created */
	ld	hl, sp+67
	ld	a, [hl]
	or	a, $08
	ld	[hl], a
	jp	.l00116
.l00115:
;src/fatfs/lib/ff.c:3852: if (mode & FA_CREATE_NEW) {
	push	hl
	ld	hl, sp+54
	bit	2, [hl]
	pop	hl
	jp	NZ,.l00324
	jp	.l00112
.l00324:
;src/fatfs/lib/ff.c:3853: res = FR_EXIST;				/* Cannot create as new file */
	ld	hl, sp+46
	ld	[hl], $08
	jp	.l00116
.l00112:
;src/fatfs/lib/ff.c:3855: if (dj.obj.attr & (AM_RDO | AM_DIR)) res = FR_DENIED;	/* Cannot overwrite it (R/O or DIR) */
	ld	hl, sp+4
	ld	a, [hl]
	and	a, $11
	jp	NZ,.l00325
	jp	.l00116
.l00325:
	ld	hl, sp+46
	ld	[hl], $07
.l00116:
;src/fatfs/lib/ff.c:3820: mode &= FF_FS_READONLY ? FA_READ : FA_READ | FA_WRITE | FA_CREATE_ALWAYS | FA_CREATE_NEW | FA_OPEN_ALWAYS | FA_OPEN_APPEND;
	ld	hl, sp+67
	ld	a, [hl]
	ld	hl, sp+52
	ld	[hl], a
;src/fatfs/lib/ff.c:3858: if (res == FR_OK && (mode & FA_CREATE_ALWAYS)) {	/* Truncate the file if overwrite mode */
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
;src/fatfs/lib/ff.c:3859: DWORD tm = GET_FATTIME();
	call	_get_fattime__far
	ld	hl, sp+61
	ld	[hl], c
	inc	hl
	ld	[hl], b
	inc	hl
	ld	[hl], e
	inc	hl
	ld	[hl], d
;src/fatfs/lib/ff.c:3881: st_32(dj.dir + DIR_CrtTime, tm);	/* Set created time */
	ld	hl, sp+26
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	ld	hl, $000E
	add	hl, bc
	ld	e, l
	ld	d, h
	ld	hl, sp+63
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	push	bc
	ld	hl, sp+63
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	push	bc
	call	_st_32
;src/fatfs/lib/ff.c:3882: st_32(dj.dir + DIR_ModTime, tm);	/* Set modified time (tmp setting) */
	ld	hl, sp+26
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	ld	hl, $0016
	add	hl, bc
	ld	e, l
	ld	d, h
	ld	hl, sp+63
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	push	bc
	ld	hl, sp+63
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	push	bc
	call	_st_32
;src/fatfs/lib/ff.c:3883: cl = ld_clust(fs, dj.dir);			/* Get current cluster chain */
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
;src/fatfs/lib/ff.c:3884: dj.dir[DIR_Attr] = AM_ARC;			/* Reset attribute */
	ld	hl, sp+26
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	ld	hl, $000B
	add	hl, bc
	ld	[hl], $20
;src/fatfs/lib/ff.c:3885: st_clust(fs, dj.dir, 0);			/* Reset file allocation info */
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
;src/fatfs/lib/ff.c:3886: st_32(dj.dir + DIR_FileSize, 0);
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
;src/fatfs/lib/ff.c:3887: fs->wflag = 1;
	ld	hl, sp+44
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	ld	hl, $0004
	add	hl, bc
	ld	[hl], $01
;src/fatfs/lib/ff.c:3888: if (cl != 0) {						/* Remove the cluster chain if exist */
	ld	hl, sp+56
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	dec	hl
	or	a, [hl]
	dec	hl
	or	a, [hl]
	jp	Z, .l00134
;src/fatfs/lib/ff.c:3889: LBA_t sc = fs->winsect;
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
;src/fatfs/lib/ff.c:3891: res = remove_chain(&dj.obj, cl, 0);
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
;src/fatfs/lib/ff.c:3892: if (res == FR_OK) {
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00134
;src/fatfs/lib/ff.c:3893: res = move_window(fs, sc);
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
;src/fatfs/lib/ff.c:3894: fs->last_clst = cl - 1;		/* Reuse the cluster hole */
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
;src/fatfs/lib/ff.c:3901: if (res == FR_OK) {					/* Is the object exsiting? */
	ld	hl, sp+46
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00134
;src/fatfs/lib/ff.c:3902: if (dj.obj.attr & AM_DIR) {		/* File open against a directory */
	ld	hl, sp+4
	ld	a, [hl]
	bit	4, a
	jp	NZ,.l00328
	jp	.l00128
.l00328:
;src/fatfs/lib/ff.c:3903: res = FR_NO_FILE;
	ld	hl, sp+46
	ld	[hl], $04
	jp	.l00134
.l00128:
;src/fatfs/lib/ff.c:3905: if ((mode & FA_WRITE) && (dj.obj.attr & AM_RDO)) { /* Write mode open against R/O file */
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
;src/fatfs/lib/ff.c:3906: res = FR_DENIED;
	ld	hl, sp+46
	ld	[hl], $07
.l00134:
;src/fatfs/lib/ff.c:3911: if (res == FR_OK) {
	ld	hl, sp+46
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00138
;src/fatfs/lib/ff.c:3912: if (mode & FA_CREATE_ALWAYS) mode |= FA_MODIFIED;	/* Set file change flag if created or overwritten */
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
;src/fatfs/lib/ff.c:3913: fp->dir_sect = fs->winsect;			/* Pointer to the directory entry */
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
;src/fatfs/lib/ff.c:3914: fp->dir_ptr = dj.dir;
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
;src/fatfs/lib/ff.c:3933: if (res == FR_OK) {
	ld	hl, sp+46
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00156
;src/fatfs/lib/ff.c:3940: fp->obj.sclust = ld_clust(fs, dj.dir);					/* Get object allocation info */
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
;src/fatfs/lib/ff.c:3941: fp->obj.objsize = ld_32(dj.dir + DIR_FileSize);
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
;src/fatfs/lib/ff.c:3946: fp->obj.id = fs->id;	/* Set current volume mount ID */
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
;src/fatfs/lib/ff.c:3947: fp->flag = mode;	/* Set file access mode */
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
;src/fatfs/lib/ff.c:3948: fp->err = 0;		/* Clear error flag */
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
;src/fatfs/lib/ff.c:3949: fp->sect = 0;		/* Invalidate current data sector */
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
;src/fatfs/lib/ff.c:3950: fp->fptr = 0;		/* Set file pointer top of the file */
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
;src/fatfs/lib/ff.c:3955: if ((mode & FA_SEEKEND) && fp->obj.objsize > 0) {	/* Seek to end of file if FA_OPEN_APPEND is specified */
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
;src/fatfs/lib/ff.c:3959: fp->fptr = fp->obj.objsize;			/* Offset to seek */
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
;src/fatfs/lib/ff.c:3960: bcs = (DWORD)fs->csize * SS(fs);	/* Cluster size in byte */
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
;src/fatfs/lib/ff.c:3961: clst = fp->obj.sclust;				/* Follow the cluster chain */
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
;src/fatfs/lib/ff.c:3962: for (ofs = fp->obj.objsize; res == FR_OK && ofs > bcs; ofs -= bcs) {
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
;src/fatfs/lib/ff.c:3963: clst = get_fat(&fp->obj, clst);
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
;src/fatfs/lib/ff.c:3964: if (clst <= 1) res = FR_INT_ERR;
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
;src/fatfs/lib/ff.c:3965: if (clst == 0xFFFFFFFF) res = FR_DISK_ERR;
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
;src/fatfs/lib/ff.c:3962: for (ofs = fp->obj.objsize; res == FR_OK && ofs > bcs; ofs -= bcs) {
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
;src/fatfs/lib/ff.c:3967: fp->clust = clst;
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
;src/fatfs/lib/ff.c:3968: if (res == FR_OK && ofs % SS(fs)) {	/* Fill sector buffer if not on the sector boundary */
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
;src/fatfs/lib/ff.c:3969: LBA_t sec = clst2sect(fs, clst);
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
	call	_clst2sect__far
	ld	hl, sp+53
	ld	[hl], c
	inc	hl
	ld	[hl], b
	inc	hl
	ld	[hl], e
	inc	hl
	ld	[hl], d
;src/fatfs/lib/ff.c:3971: if (sec == 0) {
	ld	a, d
	or	a, e
	or	a, b
	or	a, c
	jp	NZ, .l00145
;src/fatfs/lib/ff.c:3972: res = FR_INT_ERR;
	ld	hl, sp+46
	ld	[hl], $02
	jp	.l00156
.l00145:
;src/fatfs/lib/ff.c:3974: fp->sect = sec + (DWORD)(ofs / SS(fs));
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
;src/fatfs/lib/ff.c:3990: if (res != FR_OK) fp->obj.fs = 0;	/* Invalidate file object on error */
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
;src/fatfs/lib/ff.c:3992: LEAVE_FF(fs, res);
	ld	hl, sp+46
	ld	a, [hl]
.l00163:
;src/fatfs/lib/ff.c:3993: }
	add	sp, 65
	pop	hl
	inc	sp
	jp hl
;src/fatfs/lib/ff.c:4002: FRESULT f_read (
;	---------------------------------
	SECTION FRAGMENT "Page 7",ROMX,BANK[3]
	LOAD FRAGMENT "Page 7 RAM",SRAM,BANK[7]
; Function f_read
; ---------------------------------
_f_read::
	add	sp, -42
	ld	hl, sp+38
	ld	[hl], e
	inc	hl
	ld	[hl], d
;src/fatfs/lib/ff.c:4014: BYTE *rbuff = (BYTE*)buff;
	inc	hl
	ld	[hl], c
	inc	hl
	ld	[hl], b
;src/fatfs/lib/ff.c:4017: *br = 0;	/* Clear read byte counter */
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
;src/fatfs/lib/ff.c:4018: res = validate(&fp->obj, &fs);				/* Check validity of the file object */
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
;src/fatfs/lib/ff.c:4019: if (res != FR_OK || (res = (FRESULT)fp->err) != FR_OK) LEAVE_FF(fs, res);	/* Check validity */
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
;src/fatfs/lib/ff.c:4020: if (!(fp->flag & FA_READ)) LEAVE_FF(fs, FR_DENIED); /* Check access mode */
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
;src/fatfs/lib/ff.c:4021: remain = fp->obj.objsize - fp->fptr;
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
;src/fatfs/lib/ff.c:4022: if (btr > remain) btr = (UINT)remain;		/* Truncate btr by remaining bytes */
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
;src/fatfs/lib/ff.c:4039: clst = get_fat(&fp->obj, fp->clust);	/* Follow cluster chain on the FAT */
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
;src/fatfs/lib/ff.c:4022: if (btr > remain) btr = (UINT)remain;		/* Truncate btr by remaining bytes */
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
;src/fatfs/lib/ff.c:4024: for ( ; btr > 0; btr -= rcnt, *br += rcnt, rbuff += rcnt, fp->fptr += rcnt) {	/* Repeat until btr bytes read */
	ld	hl, sp+45
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	jp	Z, .l00135
;src/fatfs/lib/ff.c:4025: if (fp->fptr % SS(fs) == 0) {			/* On the sector boundary? */
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
;src/fatfs/lib/ff.c:4026: csect = (UINT)(fp->fptr / SS(fs) & (fs->csize - 1));	/* Sector offset in the cluster */
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
;src/fatfs/lib/ff.c:4027: if (csect == 0) {					/* On the cluster boundary? */
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	jp	NZ, .l00116
;src/fatfs/lib/ff.c:4030: if (fp->fptr == 0) {			/* On the top of the file? */
	dec	hl
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	dec	hl
	or	a, [hl]
	dec	hl
	or	a, [hl]
	jp	NZ, .l00109
;src/fatfs/lib/ff.c:4031: clst = fp->obj.sclust;		/* Follow cluster chain from the origin */
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
;src/fatfs/lib/ff.c:4039: clst = get_fat(&fp->obj, fp->clust);	/* Follow cluster chain on the FAT */
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
;src/fatfs/lib/ff.c:4042: if (clst < 2) ABORT(fs, FR_INT_ERR);
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
;src/fatfs/lib/ff.c:4043: if (clst == 0xFFFFFFFF) ABORT(fs, FR_DISK_ERR);
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
;src/fatfs/lib/ff.c:4044: fp->clust = clst;				/* Update current cluster */
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
;src/fatfs/lib/ff.c:4046: sect = clst2sect(fs, fp->clust);	/* Get current sector */
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
	call	_clst2sect__far
	ld	hl, sp+22
	ld	[hl], c
	inc	hl
	ld	[hl], b
	inc	hl
	ld	[hl], e
	inc	hl
	ld	[hl], d
;src/fatfs/lib/ff.c:4047: if (sect == 0) ABORT(fs, FR_INT_ERR);
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
;src/fatfs/lib/ff.c:4048: sect += csect;
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
;src/fatfs/lib/ff.c:4049: cc = btr / SS(fs);					/* When remaining bytes >= sector size, */
	ld	hl, sp+45
	ld	a, [hl]
	srl	a
	ld	hl, sp+24
	ld	[hl], a
	inc	hl
	ld	[hl], $00
;src/fatfs/lib/ff.c:4050: if (cc > 0) {						/* Read maximum contiguous sectors directly */
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	jp	Z, .l00127
;src/fatfs/lib/ff.c:4051: if (csect + cc > fs->csize) {	/* Clip at cluster boundary */
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
;src/fatfs/lib/ff.c:4026: csect = (UINT)(fp->fptr / SS(fs) & (fs->csize - 1));	/* Sector offset in the cluster */
	pop	bc
	push	bc
;src/fatfs/lib/ff.c:4051: if (csect + cc > fs->csize) {	/* Clip at cluster boundary */
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
;src/fatfs/lib/ff.c:4052: cc = fs->csize - csect;
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
;src/fatfs/lib/ff.c:4054: if (disk_read(fs->pdrv, rbuff, sect, cc) != RES_OK) ABORT(fs, FR_DISK_ERR);
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
;src/fatfs/lib/ff.c:4057: if (fs->wflag && fs->winsect - sect < cc) {
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
;src/fatfs/lib/ff.c:4058: memcpy(rbuff + ((fs->winsect - sect) * SS(fs)), fs->win, SS(fs));
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
;src/fatfs/lib/ff.c:4066: rcnt = SS(fs) * cc;				/* Number of bytes transferred */
	ld	hl, sp+24
	ld	a, [hl]
	add	a, a
	ld	hl, sp+37
	ld	[hl], a
	dec	hl
	ld	[hl], $00
;src/fatfs/lib/ff.c:4067: continue;
	jp	.l00134
.l00127:
;src/fatfs/lib/ff.c:4080: fp->sect = sect;
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
;src/fatfs/lib/ff.c:4082: rcnt = SS(fs) - (UINT)fp->fptr % SS(fs);	/* Number of bytes remains in the sector */
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
;src/fatfs/lib/ff.c:4083: if (rcnt > btr) rcnt = btr;					/* Clip it by btr if needed */
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
;src/fatfs/lib/ff.c:4085: if (move_window(fs, fp->sect) != FR_OK) ABORT(fs, FR_DISK_ERR);	/* Move sector window */
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
;src/fatfs/lib/ff.c:4086: memcpy(rbuff, fs->win + fp->fptr % SS(fs), rcnt);	/* Extract partial sector */
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
;src/fatfs/lib/ff.c:4024: for ( ; btr > 0; btr -= rcnt, *br += rcnt, rbuff += rcnt, fp->fptr += rcnt) {	/* Repeat until btr bytes read */
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
;src/fatfs/lib/ff.c:4092: LEAVE_FF(fs, FR_OK);
	xor	a, a
.l00138:
;src/fatfs/lib/ff.c:4093: }
	add	sp, 42
	pop	hl
	add	sp, 4
	jp hl
;src/fatfs/lib/ff.c:4103: FRESULT f_write (
;	---------------------------------
	SECTION FRAGMENT "Page 10",ROMX,BANK[5]
	LOAD FRAGMENT "Page 10 RAM",SRAM,BANK[10]
; Function f_write
; ---------------------------------
_f_write::
	add	sp, -50
	ld	hl, sp+46
	ld	[hl], e
	inc	hl
	ld	[hl], d
;src/fatfs/lib/ff.c:4115: const BYTE *wbuff = (const BYTE*)buff;
	inc	hl
	ld	[hl], c
	inc	hl
	ld	[hl], b
;src/fatfs/lib/ff.c:4118: *bw = 0;	/* Clear write byte counter */
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
;src/fatfs/lib/ff.c:4119: res = validate(&fp->obj, &fs);			/* Check validity of the file object */
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
;src/fatfs/lib/ff.c:4120: if (res != FR_OK || (res = (FRESULT)fp->err) != FR_OK) LEAVE_FF(fs, res);	/* Check validity */
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
;src/fatfs/lib/ff.c:4121: if (!(fp->flag & FA_WRITE)) LEAVE_FF(fs, FR_DENIED);	/* Check access mode */
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
;src/fatfs/lib/ff.c:4124: if ((!FF_FS_EXFAT || fs->fs_type != FS_EXFAT) && (DWORD)(fp->fptr + btw) < (DWORD)fp->fptr) {
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
;src/fatfs/lib/ff.c:4125: btw = (UINT)(0xFFFFFFFF - (DWORD)fp->fptr);
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
;src/fatfs/lib/ff.c:4144: clst = create_chain(&fp->obj, fp->clust);	/* Follow or stretch cluster chain on the FAT */
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
;src/fatfs/lib/ff.c:4125: btw = (UINT)(0xFFFFFFFF - (DWORD)fp->fptr);
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
;src/fatfs/lib/ff.c:4128: for ( ; btw > 0; btw -= wcnt, *bw += wcnt, wbuff += wcnt, fp->fptr += wcnt, fp->obj.objsize = (fp->fptr > fp->obj.objsize) ? fp->fptr : fp->obj.objsize) {	/* Repeat until all data written */
	ld	hl, sp+53
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	jp	Z, .l00149
;src/fatfs/lib/ff.c:4129: if (fp->fptr % SS(fs) == 0) {		/* On the sector boundary? */
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
;src/fatfs/lib/ff.c:4130: csect = (UINT)(fp->fptr / SS(fs)) & (fs->csize - 1);	/* Sector offset in the cluster */
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
;src/fatfs/lib/ff.c:4131: if (csect == 0) {				/* On the cluster boundary? */
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	jp	NZ, .l00124
;src/fatfs/lib/ff.c:4132: if (fp->fptr == 0) {		/* On the top of the file? */
	dec	hl
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	dec	hl
	or	a, [hl]
	dec	hl
	or	a, [hl]
	jp	NZ, .l00113
;src/fatfs/lib/ff.c:4133: clst = fp->obj.sclust;	/* Follow from the origin */
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
;src/fatfs/lib/ff.c:4134: if (clst == 0) {		/* If no cluster is allocated, */
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	dec	hl
	or	a, [hl]
	dec	hl
	or	a, [hl]
	jp	NZ, .l00114
;src/fatfs/lib/ff.c:4135: clst = create_chain(&fp->obj, 0);	/* create a new cluster chain */
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
;src/fatfs/lib/ff.c:4144: clst = create_chain(&fp->obj, fp->clust);	/* Follow or stretch cluster chain on the FAT */
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
;src/fatfs/lib/ff.c:4147: if (clst == 0) break;		/* Could not allocate a new cluster (disk full) */
	ld	hl, sp+37
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	dec	hl
	or	a, [hl]
	dec	hl
	or	a, [hl]
	jp	Z, .l00149
;src/fatfs/lib/ff.c:4148: if (clst == 1) ABORT(fs, FR_INT_ERR);
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
;src/fatfs/lib/ff.c:4149: if (clst == 0xFFFFFFFF) ABORT(fs, FR_DISK_ERR);
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
;src/fatfs/lib/ff.c:4150: fp->clust = clst;			/* Update current cluster */
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
;src/fatfs/lib/ff.c:4151: if (fp->obj.sclust == 0) fp->obj.sclust = clst;	/* Set start cluster if the first write */
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
;src/fatfs/lib/ff.c:4154: if (fs->winsect == fp->sect && sync_window(fs) != FR_OK) ABORT(fs, FR_DISK_ERR);	/* Write-back sector cache */
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
;src/fatfs/lib/ff.c:4161: sect = clst2sect(fs, fp->clust);	/* Get current sector */
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
;src/fatfs/lib/ff.c:4162: if (sect == 0) ABORT(fs, FR_INT_ERR);
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
;src/fatfs/lib/ff.c:4163: sect += csect;
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
;src/fatfs/lib/ff.c:4164: cc = btw / SS(fs);				/* When remaining bytes >= sector size, */
	ld	hl, sp+53
	ld	a, [hl]
	srl	a
	ld	hl, sp+34
	ld	[hl], a
	inc	hl
	ld	[hl], $00
;src/fatfs/lib/ff.c:4165: if (cc > 0) {					/* Write maximum contiguous sectors directly */
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	jp	Z, .l00137
;src/fatfs/lib/ff.c:4166: if (csect + cc > fs->csize) {	/* Clip at cluster boundary */
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
;src/fatfs/lib/ff.c:4130: csect = (UINT)(fp->fptr / SS(fs)) & (fs->csize - 1);	/* Sector offset in the cluster */
	pop	bc
	push	bc
;src/fatfs/lib/ff.c:4166: if (csect + cc > fs->csize) {	/* Clip at cluster boundary */
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
;src/fatfs/lib/ff.c:4167: cc = fs->csize - csect;
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
;src/fatfs/lib/ff.c:4169: if (disk_write(fs->pdrv, wbuff, sect, cc) != RES_OK) ABORT(fs, FR_DISK_ERR);
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
	call	_disk_write__far
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
;src/fatfs/lib/ff.c:4172: if (fs->winsect - sect < cc) {	/* Refill sector cache if it gets invalidated by the direct write */
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
;src/fatfs/lib/ff.c:4173: memcpy(fs->win, wbuff + ((fs->winsect - sect) * SS(fs)), SS(fs));
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
;src/fatfs/lib/ff.c:4174: fs->wflag = 0;
	pop	bc
	push	bc
	inc	bc
	inc	bc
	inc	bc
	inc	bc
	xor	a, a
	ld	[bc], a
.l00135:
;src/fatfs/lib/ff.c:4183: wcnt = SS(fs) * cc;		/* Number of bytes transferred */
	ld	hl, sp+34
	ld	a, [hl]
	add	a, a
	ld	hl, sp+45
	ld	[hl], a
	dec	hl
	ld	[hl], $00
;src/fatfs/lib/ff.c:4184: continue;
	jp	.l00148
.l00137:
;src/fatfs/lib/ff.c:4187: if (fp->fptr >= fp->obj.objsize) {	/* Avoid silly cache filling on the growing edge */
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
;src/fatfs/lib/ff.c:4188: if (sync_window(fs) != FR_OK) ABORT(fs, FR_DISK_ERR);
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
;src/fatfs/lib/ff.c:4189: fs->winsect = sect;
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
;src/fatfs/lib/ff.c:4198: fp->sect = sect;
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
;src/fatfs/lib/ff.c:4200: wcnt = SS(fs) - (UINT)fp->fptr % SS(fs);	/* Number of bytes remains in the sector */
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
;src/fatfs/lib/ff.c:4201: if (wcnt > btw) wcnt = btw;					/* Clip it by btw if needed */
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
;src/fatfs/lib/ff.c:4203: if (move_window(fs, fp->sect) != FR_OK) ABORT(fs, FR_DISK_ERR);	/* Move sector window */
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
;src/fatfs/lib/ff.c:4204: memcpy(fs->win + fp->fptr % SS(fs), wbuff, wcnt);	/* Fit data to the sector */
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
;src/fatfs/lib/ff.c:4205: fs->wflag = 1;
	pop	bc
	push	bc
	ld	hl, $0004
	add	hl, bc
	ld	[hl], $01
.l00148:
;src/fatfs/lib/ff.c:4128: for ( ; btw > 0; btw -= wcnt, *bw += wcnt, wbuff += wcnt, fp->fptr += wcnt, fp->obj.objsize = (fp->fptr > fp->obj.objsize) ? fp->fptr : fp->obj.objsize) {	/* Repeat until all data written */
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
;src/fatfs/lib/ff.c:4212: fp->flag |= FA_MODIFIED;				/* Set file change flag */
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
;src/fatfs/lib/ff.c:4214: LEAVE_FF(fs, FR_OK);
	xor	a, a
.l00152:
;src/fatfs/lib/ff.c:4215: }
	add	sp, 50
	pop	hl
	add	sp, 4
	jp hl
;src/fatfs/lib/ff.c:4224: FRESULT f_sync (
;	---------------------------------
	SECTION FRAGMENT "Page 9",ROMX,BANK[4]
	LOAD FRAGMENT "Page 9 RAM",SRAM,BANK[9]
; Function f_sync
; ---------------------------------
_f_sync::
	add	sp, -14
	ld	hl, sp+12
	ld	[hl], e
	inc	hl
	ld	[hl], d
;src/fatfs/lib/ff.c:4232: res = validate(&fp->obj, &fs);	/* Check validity of the file object */
	ld	hl, sp+0
	ld	c, l
	ld	b, h
	ld	hl, sp+12
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_validate__far
	ld	c, a
;src/fatfs/lib/ff.c:4233: if (res == FR_OK) {
	ld	a, c
	or	a, a
	jp	NZ, .l00106
;src/fatfs/lib/ff.c:4234: if (fp->flag & FA_MODIFIED) {	/* Is there any change to the file? */
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
;src/fatfs/lib/ff.c:4276: res = move_window(fs, fp->dir_sect);
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
	call	_move_window__far
	ld	c, a
;src/fatfs/lib/ff.c:4277: if (res == FR_OK) {
	ld	a, c
	or	a, a
	jp	NZ, .l00106
;src/fatfs/lib/ff.c:4278: BYTE *dir = fp->dir_ptr;
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
;src/fatfs/lib/ff.c:4280: dir[DIR_Attr] |= AM_ARC;					/* Set archive attribute to indicate that the file has been changed */
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
;src/fatfs/lib/ff.c:4281: st_clust(fp->obj.fs, dir, fp->obj.sclust);	/* Update file allocation information  */
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
	call	_st_clust__far
;src/fatfs/lib/ff.c:4282: st_32(dir + DIR_FileSize, (DWORD)fp->obj.objsize);	/* Update file size */
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
;src/fatfs/lib/ff.c:4283: st_32(dir + DIR_ModTime, GET_FATTIME());	/* Update modified time */
	call	_get_fattime__far
	ld	hl, sp+8
	ld	[hl], c
	inc	hl
	ld	[hl], b
	inc	hl
	ld	[hl], e
	inc	hl
	ld	[hl], d
	ld	hl, sp+5
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $0016
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
;src/fatfs/lib/ff.c:4284: st_16(dir + DIR_LstAccDate, 0);				/* Invalidate last access date */
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
;src/fatfs/lib/ff.c:4285: fs->wflag = 1;
	pop	bc
	push	bc
	inc	bc
	inc	bc
	inc	bc
	inc	bc
	ld	a, $01
	ld	[bc], a
;src/fatfs/lib/ff.c:4286: res = sync_fs(fs);							/* Restore it to the directory */
	pop	de
	push	de
	call	_sync_fs
	ld	c, a
;src/fatfs/lib/ff.c:4287: fp->flag &= (BYTE)~FA_MODIFIED;
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
;src/fatfs/lib/ff.c:4293: LEAVE_FF(fs, res);
	ld	a, c
.l00107:
;src/fatfs/lib/ff.c:4294: }
	add	sp, 14
	ret
;src/fatfs/lib/ff.c:4305: FRESULT f_close (
;	---------------------------------
	SECTION FRAGMENT "Page 9",ROMX,BANK[4]
	LOAD FRAGMENT "Page 9 RAM",SRAM,BANK[9]
; Function f_close
; ---------------------------------
_f_close::
	dec	sp
	dec	sp
;src/fatfs/lib/ff.c:4313: res = f_sync(fp);					/* Flush cached data */
	push	de
	call	_f_sync
	pop	de
;src/fatfs/lib/ff.c:4314: if (res == FR_OK)
	or	a, a
	jp	NZ, .l00104
;src/fatfs/lib/ff.c:4317: res = validate(&fp->obj, &fs);	/* Lock volume */
	ld	hl, sp+0
	ld	c, l
	ld	b, h
	push	de
	call	_validate__far
	pop	de
;src/fatfs/lib/ff.c:4318: if (res == FR_OK) {
	or	a, a
	jp	NZ, .l00104
;src/fatfs/lib/ff.c:4323: fp->obj.fs = 0;	/* Invalidate file object */
	push	af
	ld	a, $00
	ld	[de], a
	inc	de
	ld	a, $00
	ld	[de], a
	pop	af
.l00104:
;src/fatfs/lib/ff.c:4330: return res;
.l00105:
;src/fatfs/lib/ff.c:4331: }
	inc	sp
	inc	sp
	ret
;src/fatfs/lib/ff.c:4561: FRESULT f_lseek (
;	---------------------------------
	SECTION FRAGMENT "Page 9",ROMX,BANK[4]
	LOAD FRAGMENT "Page 9 RAM",SRAM,BANK[9]
; Function f_lseek
; ---------------------------------
_f_lseek::
	add	sp, -37
	ld	hl, sp+35
	ld	[hl], e
	inc	hl
	ld	[hl], d
;src/fatfs/lib/ff.c:4573: res = validate(&fp->obj, &fs);		/* Check validity of the file object */
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
;src/fatfs/lib/ff.c:4574: if (res == FR_OK) res = (FRESULT)fp->err;
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
;src/fatfs/lib/ff.c:4580: if (res != FR_OK) LEAVE_FF(fs, res);
	ld	hl, sp+2
	ld	a, [hl]
	or	a, a
	jp	Z, .l00104
	ld	a, [hl]
	jp	.l00149
.l00104:
;src/fatfs/lib/ff.c:4643: if (ofs > fp->obj.objsize && (FF_FS_READONLY || !(fp->flag & FA_WRITE))) {	/* In read-only mode, clip offset with the file size */
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
;src/fatfs/lib/ff.c:4644: ofs = fp->obj.objsize;
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
;src/fatfs/lib/ff.c:4646: ifptr = fp->fptr;
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
;src/fatfs/lib/ff.c:4647: fp->fptr = nsect = 0;
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
;src/fatfs/lib/ff.c:4648: if (ofs > 0) {
	ld	hl, sp+42
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	dec	hl
	or	a, [hl]
	dec	hl
	or	a, [hl]
	jp	Z, .l00145
;src/fatfs/lib/ff.c:4649: bcs = (DWORD)fs->csize * SS(fs);	/* Cluster size (byte) */
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
;src/fatfs/lib/ff.c:4654: clst = fp->clust;
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
;src/fatfs/lib/ff.c:4650: if (ifptr > 0 &&
	ld	hl, sp+26
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	dec	hl
	or	a, [hl]
	dec	hl
	or	a, [hl]
	jp	Z, .l00116
;src/fatfs/lib/ff.c:4651: (ofs - 1) / bcs >= (ifptr - 1) / bcs) {	/* When seek to same or following cluster, */
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
;src/fatfs/lib/ff.c:4652: fp->fptr = (ifptr - 1) & ~(FSIZE_t)(bcs - 1);	/* start from the current cluster */
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
;src/fatfs/lib/ff.c:4653: ofs -= fp->fptr;
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
;src/fatfs/lib/ff.c:4654: clst = fp->clust;
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
;src/fatfs/lib/ff.c:4656: clst = fp->obj.sclust;					/* start from the first cluster */
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
;src/fatfs/lib/ff.c:4658: if (clst == 0) {						/* If no cluster chain, create a new chain */
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	dec	hl
	or	a, [hl]
	dec	hl
	or	a, [hl]
	jp	NZ, .l00114
;src/fatfs/lib/ff.c:4659: clst = create_chain(&fp->obj, 0);
	ld	de, $0000
	push	de
	push	de
	ld	hl, sp+39
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_create_chain__far
	ld	hl, sp+21
	ld	[hl], c
	inc	hl
	ld	[hl], b
	inc	hl
	ld	[hl], e
	inc	hl
	ld	[hl], d
;src/fatfs/lib/ff.c:4660: if (clst == 1) ABORT(fs, FR_INT_ERR);
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
;src/fatfs/lib/ff.c:4661: if (clst == 0xFFFFFFFF) ABORT(fs, FR_DISK_ERR);
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
;src/fatfs/lib/ff.c:4662: fp->obj.sclust = clst;
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
;src/fatfs/lib/ff.c:4665: fp->clust = clst;
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
;src/fatfs/lib/ff.c:4667: if (clst != 0) {
	ld	hl, sp+24
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	dec	hl
	or	a, [hl]
	dec	hl
	or	a, [hl]
	jp	Z, .l00145
;src/fatfs/lib/ff.c:4668: while (ofs > bcs) {						/* Cluster following loop */
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
;src/fatfs/lib/ff.c:4669: ofs -= bcs; fp->fptr += bcs;
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
;src/fatfs/lib/ff.c:4671: if (fp->flag & FA_WRITE) {			/* Check if in write mode or not */
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
;src/fatfs/lib/ff.c:4676: clst = create_chain(&fp->obj, clst);	/* Follow chain with forceed stretch */
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
	call	_create_chain__far
	ld	hl, sp+21
	ld	[hl], c
	inc	hl
	ld	[hl], b
	inc	hl
	ld	[hl], e
	inc	hl
	ld	[hl], d
;src/fatfs/lib/ff.c:4677: if (clst == 0) {				/* Clip file size in case of disk full */
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	dec	hl
	or	a, [hl]
	dec	hl
	or	a, [hl]
	jp	NZ, .l00126
;src/fatfs/lib/ff.c:4678: ofs = 0; break;
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
;src/fatfs/lib/ff.c:4683: clst = get_fat(&fp->obj, clst);	/* Follow cluster chain if not in write mode */
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
;src/fatfs/lib/ff.c:4685: if (clst == 0xFFFFFFFF) ABORT(fs, FR_DISK_ERR);
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
;src/fatfs/lib/ff.c:4686: if (clst <= 1 || clst >= fs->n_fatent) ABORT(fs, FR_INT_ERR);
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
;src/fatfs/lib/ff.c:4687: fp->clust = clst;
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
;src/fatfs/lib/ff.c:4689: fp->fptr += ofs;
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
;src/fatfs/lib/ff.c:4690: if (ofs % SS(fs)) {
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
;src/fatfs/lib/ff.c:4691: nsect = clst2sect(fs, clst);	/* Current sector */
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
;src/fatfs/lib/ff.c:4692: if (nsect == 0) ABORT(fs, FR_INT_ERR);
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
;src/fatfs/lib/ff.c:4693: nsect += (DWORD)(ofs / SS(fs));
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
;src/fatfs/lib/ff.c:4697: if (!FF_FS_READONLY && fp->fptr > fp->obj.objsize) {	/* Set file change flag if the file size is extended */
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
;src/fatfs/lib/ff.c:4698: fp->obj.objsize = fp->fptr;
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
;src/fatfs/lib/ff.c:4699: fp->flag |= FA_MODIFIED;
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
;src/fatfs/lib/ff.c:4701: if (fp->fptr % SS(fs) && nsect != fp->sect) {	/* Fill sector cache if needed */
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
;src/fatfs/lib/ff.c:4711: fp->sect = nsect;
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
;src/fatfs/lib/ff.c:4715: LEAVE_FF(fs, res);
	ld	hl, sp+2
	ld	a, [hl]
.l00149:
;src/fatfs/lib/ff.c:4716: }
	add	sp, 37
	pop	hl
	add	sp, 4
	jp hl
;src/fatfs/lib/ff.c:4725: FRESULT f_opendir (
;	---------------------------------
	SECTION FRAGMENT "Page 8",ROMX,BANK[4]
	LOAD FRAGMENT "Page 8 RAM",SRAM,BANK[8]
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
;src/fatfs/lib/ff.c:4735: if (!dp) return FR_INVALID_OBJECT;	/* Reject null pointer */
	inc	hl
	inc	hl
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	jp	NZ, .l00102
	ld	a, $09
	jp	.l00118
.l00102:
;src/fatfs/lib/ff.c:4737: res = mount_volume(&path, &fs, 0);	/* Get logical drive and mount the volume if needed */
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
;src/fatfs/lib/ff.c:4738: if (res == FR_OK) {
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00115
;src/fatfs/lib/ff.c:4739: dp->obj.fs = fs;
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
;src/fatfs/lib/ff.c:4741: res = follow_path(dp, path);			/* Follow the path to the directory */
	ld	hl, sp+9
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	inc	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_follow_path__far
	ld	hl, sp+2
	ld	[hl], a
;src/fatfs/lib/ff.c:4742: if (res == FR_OK) {						/* Follow completed */
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00111
;src/fatfs/lib/ff.c:4743: if (!(dp->fn[NSFLAG] & NS_NONAME)) {	/* It is neither the origin directory itself nor dot name in exFAT */
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
;src/fatfs/lib/ff.c:4744: if (dp->obj.attr & AM_DIR) {		/* This object is a sub-directory */
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
;src/fatfs/lib/ff.c:4751: dp->obj.sclust = ld_clust(fs, dp->dir);	/* Get object allocation info */
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
;src/fatfs/lib/ff.c:4754: res = FR_NO_PATH;
	ld	hl, sp+2
	ld	[hl], $05
.l00107:
;src/fatfs/lib/ff.c:4757: if (res == FR_OK) {
	ld	hl, sp+2
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00111
;src/fatfs/lib/ff.c:4758: dp->obj.id = fs->id;		/* Set current volume mount ID */
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
;src/fatfs/lib/ff.c:4759: res = dir_sdi(dp, 0);		/* Rewind directory */
	ld	de, $0000
	push	de
	push	de
	ld	hl, sp+15
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_dir_sdi__far
	ld	hl, sp+2
	ld	[hl], a
.l00111:
;src/fatfs/lib/ff.c:4773: if (res == FR_NO_FILE) res = FR_NO_PATH;
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
;src/fatfs/lib/ff.c:4775: if (res != FR_OK) dp->obj.fs = 0;		/* Invalidate the directory object if function failed */
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
;src/fatfs/lib/ff.c:4777: LEAVE_FF(fs, res);
	ld	hl, sp+2
	ld	a, [hl]
.l00118:
;src/fatfs/lib/ff.c:4778: }
	add	sp, 13
	ret
;src/fatfs/lib/ff.c:4787: FRESULT f_closedir (
;	---------------------------------
	SECTION FRAGMENT "Page 8",ROMX,BANK[4]
	LOAD FRAGMENT "Page 8 RAM",SRAM,BANK[8]
; Function f_closedir
; ---------------------------------
_f_closedir::
	dec	sp
	dec	sp
;src/fatfs/lib/ff.c:4795: res = validate(&dp->obj, &fs);	/* Check validity of the file object */
	ld	hl, sp+0
	ld	c, l
	ld	b, h
	push	de
	call	_validate__far
	pop	de
	ld	c, a
;src/fatfs/lib/ff.c:4796: if (res == FR_OK) {
	or	a, a
	jp	NZ, .l00102
;src/fatfs/lib/ff.c:4801: dp->obj.fs = 0;	/* Invalidate directory object */
	xor	a, a
	ld	[de], a
	inc	de
	ld	[de], a
.l00102:
;src/fatfs/lib/ff.c:4807: return res;
	ld	a, c
.l00103:
;src/fatfs/lib/ff.c:4808: }
	inc	sp
	inc	sp
	ret
;src/fatfs/lib/ff.c:4817: FRESULT f_readdir (
;	---------------------------------
	SECTION FRAGMENT "Page 8",ROMX,BANK[4]
	LOAD FRAGMENT "Page 8 RAM",SRAM,BANK[8]
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
;src/fatfs/lib/ff.c:4827: res = validate(&dp->obj, &fs);	/* Check validity of the directory object */
	ld	hl, sp+0
	ld	c, l
	ld	b, h
	push	de
	ld	hl, sp+4
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_validate__far
	pop	de
	ld	c, a
;src/fatfs/lib/ff.c:4833: fno->fname[0] = 0;				/* Clear file information */
	ld	hl, $0016
	add	hl, de
;src/fatfs/lib/ff.c:4828: if (res == FR_OK) {
	ld	a, c
	or	a, a
	jp	NZ, .l00111
;src/fatfs/lib/ff.c:4829: if (!fno) {
	ld	a, d
	or	a, e
	jp	NZ, .l00108
;src/fatfs/lib/ff.c:4830: res = dir_sdi(dp, 0);		/* Rewind the directory object */
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
	call	_dir_sdi__far
	pop	de
	pop	hl
	ld	c, a
	jp	.l00111
.l00108:
;src/fatfs/lib/ff.c:4833: fno->fname[0] = 0;				/* Clear file information */
	ld	[hl], $00
;src/fatfs/lib/ff.c:4834: res = DIR_READ_FILE(dp);		/* Read an item */
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
;src/fatfs/lib/ff.c:4835: if (res == FR_NO_FILE) res = FR_OK;	/* Ignore end of directory */
	ld	a, c
	sub	a, $04
	jp	NZ,.l00152
	jp	.l00153
.l00152:
	jp	.l00102
.l00153:
	ld	c, $00
.l00102:
;src/fatfs/lib/ff.c:4836: if (res == FR_OK) {				/* A valid entry is found */
	ld	a, c
	or	a, a
	jp	NZ, .l00111
;src/fatfs/lib/ff.c:4837: get_fileinfo(dp, fno);		/* Get the object information */
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
;src/fatfs/lib/ff.c:4838: res = dir_next(dp, 0);		/* Increment index for next */
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
	call	_dir_next__far
	pop	de
	pop	hl
	ld	c, a
;src/fatfs/lib/ff.c:4839: if (res == FR_NO_FILE) res = FR_OK;	/* Ignore end of directory now */
	ld	a, c
	sub	a, $04
	jp	NZ,.l00154
	jp	.l00155
.l00154:
	jp	.l00111
.l00155:
	ld	c, $00
.l00111:
;src/fatfs/lib/ff.c:4845: if (fno && res != FR_OK) fno->fname[0] = 0;	/* Clear the file information if any error occured */
	ld	a, d
	or	a, e
	jp	Z, .l00113
	ld	a, c
	or	a, a
	jp	Z, .l00113
	ld	[hl], $00
.l00113:
;src/fatfs/lib/ff.c:4846: LEAVE_FF(fs, res);
	ld	a, c
.l00115:
;src/fatfs/lib/ff.c:4847: }
	add	sp, 4
	ret
;src/fatfs/lib/ff.c:4908: FRESULT f_stat (
;	---------------------------------
	SECTION FRAGMENT "Page 13",ROMX,BANK[6]
	LOAD FRAGMENT "Page 13 RAM",SRAM,BANK[13]
; Function f_stat
; ---------------------------------
_f_stat::
	add	sp, -47
	ld	hl, sp+45
	ld	[hl], e
	inc	hl
	ld	[hl], d
	ld	e, c
	ld	d, b
;src/fatfs/lib/ff.c:4919: res = mount_volume(&path, &dj.obj.fs, 0);
	ld	hl, sp+0
	ld	c, l
	ld	b, h
	push	de
	xor	a, a
	push	af
	inc	sp
	ld	hl, 48
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_mount_volume__far
	pop	de
	ld	hl, sp+44
	ld	[hl], a
;src/fatfs/lib/ff.c:4921: if (res == FR_OK) {
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00109
;src/fatfs/lib/ff.c:4923: res = follow_path(&dj, path);	/* Follow the file path */
	push	de
	inc	hl
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	ld	hl, 2
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_follow_path__far
	pop	de
	ld	hl, sp+44
	ld	[hl], a
;src/fatfs/lib/ff.c:4924: if (res == FR_OK) {				/* Follow completed */
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00109
;src/fatfs/lib/ff.c:4925: if (dj.fn[NSFLAG] & NS_NONAME) {	/* It is origin directory */
	ld	hl, 39
	add	hl, sp
	ld	c, l
	ld	b, h
	ld	a, [bc]
	rlca
	jp	C,.l00145
	jp	.l00104
.l00145:
;src/fatfs/lib/ff.c:4926: res = FR_INVALID_NAME;
	ld	hl, sp+44
	ld	[hl], $06
	jp	.l00109
.l00104:
;src/fatfs/lib/ff.c:4928: if (fno) get_fileinfo(&dj, fno);
	ld	a, d
	or	a, e
	jp	Z, .l00109
	push	de
	ld	c, e
	ld	b, d
	ld	hl, 2
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_get_fileinfo__far
	pop	de
.l00109:
;src/fatfs/lib/ff.c:4934: if (fno && res != FR_OK) fno->fname[0] = 0;	/* Invalidate the file information if an error occured */
	ld	a, d
	or	a, e
	jp	Z, .l00111
	ld	hl, sp+44
	ld	a, [hl]
	or	a, a
	jp	Z, .l00111
	ld	hl, $0016
	add	hl, de
	ld	[hl], $00
.l00111:
;src/fatfs/lib/ff.c:4935: LEAVE_FF(dj.obj.fs, res);
	ld	hl, sp+44
	ld	a, [hl]
.l00113:
;src/fatfs/lib/ff.c:4936: }
	add	sp, 47
	ret
;src/fatfs/lib/ff.c:4945: FRESULT f_getfree (
;	---------------------------------
	SECTION FRAGMENT "Page 13",ROMX,BANK[6]
	LOAD FRAGMENT "Page 13 RAM",SRAM,BANK[13]
; Function f_getfree
; ---------------------------------
_f_getfree::
	add	sp, -40
	ld	hl, sp+30
	ld	[hl], e
	inc	hl
	ld	[hl], d
	ld	hl, sp+28
	ld	[hl], c
	inc	hl
	ld	[hl], b
;src/fatfs/lib/ff.c:4960: res = mount_volume(&path, &fs, 0);
	ld	hl, sp+0
	ld	c, l
	ld	b, h
	ld	hl, sp+30
	ld	e, l
	ld	d, h
	xor	a, a
	push	af
	inc	sp
	call	_mount_volume__far
	ld	hl, sp+16
	ld	[hl], a
;src/fatfs/lib/ff.c:4962: if (res == FR_OK) {
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00133
;src/fatfs/lib/ff.c:4963: *fatfs = fs;				/* Return ptr to the fs object */
	ld	hl, sp+42
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	ld	hl, sp+0
	ld	a, [hl]
	ld	[bc], a
	inc	bc
	inc	hl
	ld	a, [hl]
	ld	[bc], a
;src/fatfs/lib/ff.c:4965: if (fs->free_clst <= fs->n_fatent - 2) {
	dec	hl
	ld	a, [hl]
	ld	hl, sp+26
	ld	[hl], a
	ld	hl, sp+1
	ld	a, [hl]
	ld	hl, sp+27
	ld	[hl], a
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
	inc	hl
	inc	hl
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
	ld	hl, sp+36
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
	ld	hl, sp+35
	ld	[hl], a
	dec	hl
	ld	[hl], e
	ld	hl, sp+41
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
	ld	hl, sp+35
	ld	[hl], a
	dec	hl
	ld	[hl], e
	ld	hl, sp+32
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
	jp	C, .l00130
;src/fatfs/lib/ff.c:4966: *nclst = fs->free_clst;
	ld	hl, sp+29
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
	jp	.l00133
.l00130:
;src/fatfs/lib/ff.c:4969: nfree = 0;
	xor	a, a
	ld	hl, sp+17
	ld	[hl], a
	inc	hl
	ld	[hl], a
	inc	hl
	ld	[hl], a
	inc	hl
	ld	[hl], a
;src/fatfs/lib/ff.c:4970: if (fs->fs_type == FS_FAT12) {	/* FAT12: Scan bit field FAT entries */
	ld	hl, sp+27
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	dec	a
	jp	NZ,.l00207
	jp	.l00208
.l00207:
	jp	.l00125
.l00208:
;src/fatfs/lib/ff.c:4971: clst = 2; obj.fs = fs;
	dec	hl
	ld	a, [hl]
	ld	hl, sp+2
	ld	[hl], a
	ld	hl, sp+27
	ld	a, [hl]
	ld	hl, sp+3
	ld	[hl], a
;src/fatfs/lib/ff.c:4972: do {
	xor	a, a
	ld	hl, sp+32
	ld	[hl], a
	inc	hl
	ld	[hl], a
	inc	hl
	ld	[hl], a
	inc	hl
	ld	[hl], a
	inc	hl
	ld	[hl], $02
	xor	a, a
	inc	hl
	ld	[hl], a
	inc	hl
	ld	[hl], a
	inc	hl
	ld	[hl], a
.l00107:
;src/fatfs/lib/ff.c:4973: stat = get_fat(&obj, clst);
	ld	hl, sp+38
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	push	de
	ld	hl, sp+38
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	push	de
	ld	hl, 6
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_get_fat__far
	ld	hl, sp+24
	ld	[hl], c
	inc	hl
	ld	[hl], b
	inc	hl
	ld	[hl], e
	inc	hl
	ld	[hl], d
;src/fatfs/lib/ff.c:4974: if (stat == 0xFFFFFFFF) {
	ld	hl, sp+24
	ld	a, [hl]
	inc	hl
	and	a, [hl]
	inc	hl
	and	a, [hl]
	inc	hl
	and	a, [hl]
	inc	a
	jp	NZ,.l00209
	jp	.l00210
.l00209:
	jp	.l00102
.l00210:
;src/fatfs/lib/ff.c:4975: res = FR_DISK_ERR; break;
	ld	hl, sp+16
	ld	[hl], $01
	jp	.l00126
.l00102:
;src/fatfs/lib/ff.c:4977: if (stat == 1) {
	ld	hl, sp+24
	ld	a, [hl]
	dec	a
	inc	hl
	or	a, [hl]
	inc	hl
	or	a, [hl]
	inc	hl
	or	a, [hl]
	jp	NZ,.l00211
	jp	.l00212
.l00211:
	jp	.l00104
.l00212:
;src/fatfs/lib/ff.c:4978: res = FR_INT_ERR; break;
	ld	hl, sp+16
	ld	[hl], $02
	jp	.l00126
.l00104:
;src/fatfs/lib/ff.c:4980: if (stat == 0) nfree++;
	ld	hl, sp+27
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	dec	hl
	or	a, [hl]
	dec	hl
	or	a, [hl]
	jp	NZ, .l00108
	ld	hl, sp+32
	inc	[hl]
	jp	NZ, .l00213
	inc	hl
	inc	[hl]
	jp	NZ, .l00213
	inc	hl
	inc	[hl]
	jp	NZ, .l00213
	inc	hl
	inc	[hl]
.l00213:
	ld	hl, sp+32
	ld	d, h
	ld	e, l
	ld	hl, sp+17
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
.l00108:
;src/fatfs/lib/ff.c:4981: } while (++clst < fs->n_fatent);
	ld	hl, sp+36
	inc	[hl]
	jp	NZ, .l00214
	inc	hl
	inc	[hl]
	jp	NZ, .l00214
	inc	hl
	inc	[hl]
	jp	NZ, .l00214
	inc	hl
	inc	[hl]
.l00214:
	ld	hl, sp+0
	ld	a, [hl]
	ld	hl, sp+24
	ld	[hl], a
	ld	hl, sp+1
	ld	a, [hl]
	ld	hl, sp+25
	ld	[hl], a
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
	ld	hl, sp+36
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
	jp	C, .l00107
	jp	.l00126
.l00125:
;src/fatfs/lib/ff.c:5005: clst = fs->n_fatent;	/* Number of entries */
	ld	hl, sp+36
	ld	d, h
	ld	e, l
	ld	hl, sp+32
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
;src/fatfs/lib/ff.c:5006: sect = fs->fatbase;		/* Top of the FAT */
	ld	hl, sp+27
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
	ld	hl, sp+36
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
;src/fatfs/lib/ff.c:5007: i = 0;					/* Offset in the sector */
	xor	a, a
	ld	hl, sp+21
	ld	[hl], a
	inc	hl
	ld	[hl], a
;src/fatfs/lib/ff.c:5008: do {	/* Counts numbuer of entries with zero in the FAT */
.l00121:
;src/fatfs/lib/ff.c:5009: if (i == 0) {	/* New sector? */
	ld	hl, sp+22
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	jp	NZ, .l00113
;src/fatfs/lib/ff.c:5010: res = move_window(fs, sect++);
	ld	hl, sp+36
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
	ld	hl, sp+36
	inc	[hl]
	jp	NZ, .l00215
	inc	hl
	inc	[hl]
	jp	NZ, .l00215
	inc	hl
	inc	[hl]
	jp	NZ, .l00215
	inc	hl
	inc	[hl]
.l00215:
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
	ld	hl, sp+4
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_move_window__far
	ld	hl, sp+16
	ld	[hl], a
;src/fatfs/lib/ff.c:5011: if (res != FR_OK) break;
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00126
.l00113:
;src/fatfs/lib/ff.c:5013: if (fs->fs_type == FS_FAT16) {
	pop	bc
	push	bc
	ld	a, [bc]
	ld	hl, sp+23
	ld	[hl], a
;src/fatfs/lib/ff.c:5014: if (ld_16(fs->win + i) == 0) nfree++;	/* FAT16: Is this cluster free? */
	ld	hl, $0032
	add	hl, bc
	ld	c, l
	ld	b, h
	ld	hl, sp+18
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
	ld	hl, sp+22
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
	ld	hl, sp+21
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	add	hl, bc
	ld	e, l
	ld	d, h
;src/fatfs/lib/ff.c:5013: if (fs->fs_type == FS_FAT16) {
	ld	hl, sp+23
	ld	a, [hl]
	sub	a, $02
	jp	NZ,.l00216
	jp	.l00217
.l00216:
	jp	.l00119
.l00217:
;src/fatfs/lib/ff.c:5014: if (ld_16(fs->win + i) == 0) nfree++;	/* FAT16: Is this cluster free? */
	call	_ld_16
	ld	a, b
	or	a, c
	jp	NZ, .l00115
	ld	hl, sp+24
	ld	d, h
	ld	e, l
	ld	hl, sp+17
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
.l00115:
;src/fatfs/lib/ff.c:5015: i += 2;	/* Next entry */
	ld	hl, sp+21
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	inc	bc
	inc	bc
	jp	.l00120
.l00119:
;src/fatfs/lib/ff.c:5017: if ((ld_32(fs->win + i) & 0x0FFFFFFF) == 0) nfree++;	/* FAT32: Is this cluster free? */
	call	_ld_32
	ld	a, c
	or	a, a
	jp	NZ,.l00218
	ld	a, b
	or	a, a
	jp	NZ,.l00218
	ld	a, e
	or	a, a
	jp	NZ,.l00218
	ld	a, d
	and	a, $0F
	jp	NZ,.l00218
	jp	.l00219
.l00218:
	jp	.l00117
.l00219:
	ld	hl, sp+24
	ld	d, h
	ld	e, l
	ld	hl, sp+17
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
.l00117:
;src/fatfs/lib/ff.c:5018: i += 4;	/* Next entry */
	ld	hl, sp+22
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $0004
	add	hl, de
	ld	c, l
	ld	b, h
.l00120:
;src/fatfs/lib/ff.c:5020: i %= SS(fs);
	ld	hl, sp+21
	ld	[hl], c
	ld	a, b
	and	a, $01
	inc	hl
	ld	[hl], a
;src/fatfs/lib/ff.c:5021: } while (--clst);
	ld	hl, sp+33
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
	ld	[hl], a
	dec	hl
	ld	[hl], e
	ld	hl, sp+37
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
	inc	hl
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	dec	hl
	or	a, [hl]
	dec	hl
	or	a, [hl]
	jp	NZ, .l00121
.l00126:
;src/fatfs/lib/ff.c:5024: if (res == FR_OK) {		/* Update parameters if succeeded */
	ld	hl, sp+16
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00133
;src/fatfs/lib/ff.c:5025: *nclst = nfree;			/* Return the free clusters */
	ld	hl, sp+29
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, sp+17
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
;src/fatfs/lib/ff.c:5026: fs->free_clst = nfree;	/* Now free cluster count is valid */
	ld	hl, sp+0
	ld	a, [hl]
	inc	hl
	ld	b, [hl]
	add	a, $12
	ld	c, a
	jp	NC, .l00220
	inc	b
.l00220:
	ld	hl, sp+17
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
;src/fatfs/lib/ff.c:5027: fs->fsi_flag |= 1;		/* FAT32/exfAT : Allocation information is to be updated */
	pop	bc
	push	bc
	ld	hl, $0005
	add	hl, bc
	ld	a, [hl]
	set	0, a
	ld	[hl], a
.l00133:
;src/fatfs/lib/ff.c:5032: LEAVE_FF(fs, res);
	ld	hl, sp+16
	ld	a, [hl]
.l00134:
;src/fatfs/lib/ff.c:5033: }
	add	sp, 40
	pop	hl
	inc	sp
	inc	sp
	jp hl
;src/fatfs/lib/ff.c:5042: FRESULT f_truncate (
;	---------------------------------
	SECTION FRAGMENT "Page 13",ROMX,BANK[6]
	LOAD FRAGMENT "Page 13 RAM",SRAM,BANK[13]
; Function f_truncate
; ---------------------------------
_f_truncate::
	add	sp, -23
	ld	hl, sp+21
	ld	[hl], e
	inc	hl
	ld	[hl], d
;src/fatfs/lib/ff.c:5052: res = validate(&fp->obj, &fs);
	ld	hl, sp+0
	ld	c, l
	ld	b, h
	ld	hl, sp+21
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_validate__far
	ld	hl, sp+2
	ld	[hl], a
;src/fatfs/lib/ff.c:5053: if (res != FR_OK || (res = (FRESULT)fp->err) != FR_OK) LEAVE_FF(fs, res);
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00101
	ld	hl, sp+22
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
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	dec	hl
	dec	hl
	ld	[hl], a
	or	a, a
	jp	Z, .l00102
.l00101:
	ld	hl, sp+2
	ld	a, [hl]
	jp	.l00120
.l00102:
;src/fatfs/lib/ff.c:5054: if (!(fp->flag & FA_WRITE)) LEAVE_FF(fs, FR_DENIED);	/* Check access mode */
	ld	hl, sp+22
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $000E
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
	bit	1, a
	jp	NZ,.l00167
	jp	.l00168
.l00167:
	jp	.l00105
.l00168:
	ld	a, $07
	jp	.l00120
.l00105:
;src/fatfs/lib/ff.c:5056: if (fp->fptr < fp->obj.objsize) {	/* Process when fptr is not on the eof */
	ld	hl, sp+22
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $0010
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
	ld	a, [de]
	ld	hl, sp+13
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
	ld	hl, sp+22
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $000A
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
	ld	hl, sp+17
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
	ld	hl, sp+17
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
	jp	NC, .l00119
;src/fatfs/lib/ff.c:5057: if (fp->fptr == 0) {	/* When set file size to zero, remove entire cluster chain */
	ld	hl, sp+16
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	dec	hl
	or	a, [hl]
	dec	hl
	or	a, [hl]
	jp	NZ, .l00114
;src/fatfs/lib/ff.c:5058: res = remove_chain(&fp->obj, fp->obj.sclust, 0);
	ld	hl, sp+22
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $0006
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+21
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+20
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
	ld	de, $0000
	push	de
	push	de
	push	hl
	push	bc
	ld	hl, sp+29
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_remove_chain__far
	ld	hl, sp+2
	ld	[hl], a
;src/fatfs/lib/ff.c:5059: fp->obj.sclust = 0;
	ld	hl, sp+19
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
	jp	.l00115
.l00114:
;src/fatfs/lib/ff.c:5061: ncl = get_fat(&fp->obj, fp->clust);
	ld	hl, sp+22
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $0014
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
	ld	hl, sp+17
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
	ld	hl, sp+19
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	push	de
	ld	hl, sp+25
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_get_fat__far
	ld	hl, sp+17
	ld	[hl], c
	inc	hl
	ld	[hl], b
	inc	hl
	ld	[hl], e
	inc	hl
	ld	[hl], d
	ld	hl, sp+17
	ld	d, h
	ld	e, l
	ld	hl, sp+13
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
;src/fatfs/lib/ff.c:5062: res = FR_OK;
	ld	hl, sp+2
	ld	[hl], $00
;src/fatfs/lib/ff.c:5063: if (ncl == 0xFFFFFFFF) res = FR_DISK_ERR;
	ld	hl, sp+13
	ld	a, [hl]
	inc	hl
	and	a, [hl]
	inc	hl
	and	a, [hl]
	inc	hl
	and	a, [hl]
	inc	a
	jp	NZ,.l00169
	jp	.l00170
.l00169:
	jp	.l00107
.l00170:
	ld	hl, sp+2
	ld	[hl], $01
.l00107:
;src/fatfs/lib/ff.c:5064: if (ncl == 1) res = FR_INT_ERR;
	ld	hl, sp+13
	ld	a, [hl]
	dec	a
	inc	hl
	or	a, [hl]
	inc	hl
	or	a, [hl]
	inc	hl
	or	a, [hl]
	jp	NZ,.l00171
	jp	.l00172
.l00171:
	jp	.l00109
.l00172:
	ld	hl, sp+2
	ld	[hl], $02
.l00109:
;src/fatfs/lib/ff.c:5065: if (res == FR_OK && ncl < fs->n_fatent) {
	ld	hl, sp+2
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00115
	pop	bc
	push	bc
	ld	hl, $0016
	add	hl, bc
	ld	e, l
	ld	d, h
	ld	a, [de]
	ld	hl, sp+17
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
	ld	hl, sp+17
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
	jp	NC, .l00115
;src/fatfs/lib/ff.c:5066: res = remove_chain(&fp->obj, ncl, fp->clust);
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
	ld	hl, sp+19
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	push	de
	ld	hl, sp+19
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	push	de
	ld	hl, sp+29
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_remove_chain__far
	ld	hl, sp+2
	ld	[hl], a
.l00115:
;src/fatfs/lib/ff.c:5069: fp->obj.objsize = fp->fptr;	/* Set file size to current read/write point */
	ld	hl, sp+8
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	ld	hl, sp+17
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
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, sp+17
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
;src/fatfs/lib/ff.c:5070: fp->flag |= FA_MODIFIED;
	ld	hl, sp+6
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	ld	hl, sp+20
	ld	[hl], a
	ld	c, [hl]
	set	6, c
	ld	hl, sp+5
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	ld	[hl], c
;src/fatfs/lib/ff.c:5080: if (res != FR_OK) ABORT(fs, res);
	ld	hl, sp+2
	ld	a, [hl]
	or	a, a
	jp	Z, .l00119
	inc	hl
	inc	hl
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	dec	hl
	dec	hl
	ld	a, [hl]
	ld	[de], a
	ld	a, [hl]
	jp	.l00120
.l00119:
;src/fatfs/lib/ff.c:5083: LEAVE_FF(fs, res);
	ld	hl, sp+2
	ld	a, [hl]
.l00120:
;src/fatfs/lib/ff.c:5084: }
	add	sp, 23
	ret
;src/fatfs/lib/ff.c:5093: FRESULT f_unlink (
;	---------------------------------
	SECTION FRAGMENT "Page 13",ROMX,BANK[6]
	LOAD FRAGMENT "Page 13 RAM",SRAM,BANK[13]
; Function f_unlink
; ---------------------------------
_f_unlink::
	add	sp, -97
	ld	hl, sp+95
	ld	[hl], e
	inc	hl
	ld	[hl], d
;src/fatfs/lib/ff.c:5100: DWORD dclst = 0;
	xor	a, a
	ld	hl, sp+91
	ld	[hl], a
	inc	hl
	ld	[hl], a
	inc	hl
	ld	[hl], a
	inc	hl
	ld	[hl], a
;src/fatfs/lib/ff.c:5107: res = mount_volume(&path, &fs, FA_WRITE);
	ld	hl, sp+0
	ld	c, l
	ld	b, h
	ld	hl, sp+95
	ld	e, l
	ld	d, h
	ld	a, $02
	push	af
	inc	sp
	call	_mount_volume__far
	ld	hl, sp+90
	ld	[hl], a
;src/fatfs/lib/ff.c:5108: if (res == FR_OK) {
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00126
;src/fatfs/lib/ff.c:5109: dj.obj.fs = fs;
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
;src/fatfs/lib/ff.c:5111: res = follow_path(&dj, path);	/* Follow the path to the object */
	ld	hl, sp+95
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	ld	hl, 2
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_follow_path__far
	ld	hl, sp+90
	ld	[hl], a
;src/fatfs/lib/ff.c:5115: } else if (dj.obj.attr & AM_RDO) {
;src/fatfs/lib/ff.c:5112: if (res == FR_OK) {
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00107
;src/fatfs/lib/ff.c:5113: if (dj.fn[NSFLAG] & (NS_DOT | NS_NONAME)) {
	ld	hl, sp+41
	ld	a, [hl]
	and	a, $A0
	jp	NZ,.l00194
	jp	.l00104
.l00194:
;src/fatfs/lib/ff.c:5114: res = FR_INVALID_NAME;	/* It must be a real object */
	ld	hl, sp+90
	ld	[hl], $06
	jp	.l00107
.l00104:
;src/fatfs/lib/ff.c:5115: } else if (dj.obj.attr & AM_RDO) {
	ld	hl, sp+6
	ld	a, [hl]
	rrca
	jp	C,.l00195
	jp	.l00107
.l00195:
;src/fatfs/lib/ff.c:5116: res = FR_DENIED;		/* The object must not be read-only */
	ld	hl, sp+90
	ld	[hl], $07
.l00107:
;src/fatfs/lib/ff.c:5123: if (res == FR_OK) {		/* The object is accessible */
	ld	hl, sp+90
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00117
;src/fatfs/lib/ff.c:5132: dclst = ld_clust(fs, dj.dir);
	ld	hl, sp+28
	ld	a, [hl]
	ld	hl, sp+93
	ld	[hl], a
	ld	hl, sp+29
	ld	a, [hl]
	ld	hl, sp+94
	ld	[hl], a
	dec	hl
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	pop	de
	push	de
	call	_ld_clust__far
	ld	hl, sp+91
	ld	[hl], c
	inc	hl
	ld	[hl], b
	inc	hl
	ld	[hl], e
	inc	hl
	ld	[hl], d
;src/fatfs/lib/ff.c:5134: if (dj.obj.attr & AM_DIR) {		/* Is the object a sub-directory? */
	ld	hl, sp+6
	ld	a, [hl]
	bit	4, a
	jp	NZ,.l00196
	jp	.l00117
.l00196:
;src/fatfs/lib/ff.c:5141: sdj.obj.fs = fs;		/* Open the sub-directory */
	ld	hl, sp+0
	ld	a, [hl]
	ld	hl, sp+46
	ld	[hl], a
	ld	hl, sp+1
	ld	a, [hl]
	ld	hl, sp+47
	ld	[hl], a
;src/fatfs/lib/ff.c:5142: sdj.obj.sclust = dclst;
	ld	hl, sp+91
	ld	a, [hl]
	ld	hl, sp+52
	ld	[hl], a
	ld	hl, sp+92
	ld	a, [hl]
	ld	hl, sp+53
	ld	[hl], a
	ld	hl, sp+93
	ld	a, [hl]
	ld	hl, sp+54
	ld	[hl], a
	ld	hl, sp+94
	ld	a, [hl]
	ld	hl, sp+55
	ld	[hl], a
;src/fatfs/lib/ff.c:5149: res = dir_sdi(&sdj, 0);
	ld	hl, sp+46
	ld	c, l
	ld	b, h
	ld	e, c
	ld	d, b
	push	bc
	ld	hl, $0000
	push	hl
	push	hl
	call	_dir_sdi__far
	pop	bc
	ld	hl, sp+90
	ld	[hl], a
;src/fatfs/lib/ff.c:5150: if (res == FR_OK) {
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00117
;src/fatfs/lib/ff.c:5151: res = DIR_READ_FILE(&sdj);			/* Check if the sub-directory is empty */
	ld	e, c
	ld	d, b
	ld	bc, $0000
	call	_dir_read__far
	ld	hl, sp+90
	ld	[hl], a
;src/fatfs/lib/ff.c:5152: if (res == FR_OK) res = FR_DENIED;	/* Not empty? */
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00109
	ld	[hl], $07
.l00109:
;src/fatfs/lib/ff.c:5153: if (res == FR_NO_FILE) res = FR_OK;	/* Empty? */
	ld	hl, sp+90
	ld	a, [hl]
	sub	a, $04
	jp	NZ,.l00197
	jp	.l00198
.l00197:
	jp	.l00117
.l00198:
	ld	hl, sp+90
	ld	[hl], $00
.l00117:
;src/fatfs/lib/ff.c:5158: if (res == FR_OK) {		/* It is ready to remove the object */
	ld	hl, sp+90
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00126
;src/fatfs/lib/ff.c:5159: res = dir_remove(&dj);				/* Remove the directory entry */
	ld	hl, 2
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_dir_remove
	ld	hl, sp+90
	ld	[hl], a
;src/fatfs/lib/ff.c:5160: if (res == FR_OK && dclst != 0) {	/* Remove the cluster chain if exist */
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00119
	ld	hl, sp+94
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	dec	hl
	or	a, [hl]
	dec	hl
	or	a, [hl]
	jp	Z, .l00119
;src/fatfs/lib/ff.c:5164: res = remove_chain(&dj.obj, dclst, 0);
	ld	de, $0000
	push	de
	push	de
	inc	hl
	inc	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	push	de
	ld	hl, sp+97
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	push	de
	ld	hl, 10
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_remove_chain__far
	ld	hl, sp+90
	ld	[hl], a
.l00119:
;src/fatfs/lib/ff.c:5167: if (res == FR_OK) res = sync_fs(fs);
	ld	hl, sp+90
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00126
	pop	de
	push	de
	call	_sync_fs__far
	ld	hl, sp+90
	ld	[hl], a
.l00126:
;src/fatfs/lib/ff.c:5172: LEAVE_FF(fs, res);
	ld	hl, sp+90
	ld	a, [hl]
.l00127:
;src/fatfs/lib/ff.c:5173: }
	add	sp, 97
	ret
;src/fatfs/lib/ff.c:5182: FRESULT f_mkdir (
;	---------------------------------
	SECTION FRAGMENT "Page 13",ROMX,BANK[6]
	LOAD FRAGMENT "Page 13 RAM",SRAM,BANK[13]
; Function f_mkdir
; ---------------------------------
_f_mkdir::
	add	sp, -75
	ld	hl, sp+73
	ld	[hl], e
	inc	hl
	ld	[hl], d
;src/fatfs/lib/ff.c:5194: res = mount_volume(&path, &fs, FA_WRITE);	/* Get logical drive and mount the volume if needed */
	ld	hl, sp+4
	ld	c, l
	ld	b, h
	ld	hl, sp+73
	ld	e, l
	ld	d, h
	ld	a, $02
	push	af
	inc	sp
	call	_mount_volume__far
	ld	hl, sp+64
	ld	[hl], a
;src/fatfs/lib/ff.c:5195: if (res == FR_OK) {
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00124
;src/fatfs/lib/ff.c:5196: dj.obj.fs = fs;
	ld	hl, sp+4
	ld	a, [hl]
	inc	hl
	inc	hl
	ld	[hl], a
	dec	hl
	ld	a, [hl]
	inc	hl
	inc	hl
	ld	[hl], a
;src/fatfs/lib/ff.c:5198: res = follow_path(&dj, path);			/* Follow the file path */
	ld	hl, sp+73
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	ld	hl, 6
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_follow_path__far
	ld	hl, sp+64
	ld	[hl], a
;src/fatfs/lib/ff.c:5199: if (res == FR_OK) {						/* Invalid name or name collision */
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00102
;src/fatfs/lib/ff.c:5200: res = (dj.fn[NSFLAG] & (NS_DOT | NS_NONAME)) ? FR_INVALID_NAME : FR_EXIST;
	ld	hl, sp+45
	ld	a, [hl]
	and	a, $A0
	jp	NZ,.l00184
	jp	.l00127
.l00184:
	ld	a, $06
	jp	.l00128
.l00127:
	ld	a, $08
.l00128:
	ld	hl, sp+64
	ld	[hl], a
.l00102:
;src/fatfs/lib/ff.c:5202: if (res == FR_NO_FILE) {				/* It is clear to create a new directory */
	ld	hl, sp+64
	ld	a, [hl]
	sub	a, $04
	jp	NZ,.l00185
	jp	.l00186
.l00185:
	jp	.l00124
.l00186:
;src/fatfs/lib/ff.c:5203: sobj.fs = fs;						/* New object ID to create a new chain */
	ld	hl, sp+4
	ld	a, [hl]
	ld	hl, sp+50
	ld	[hl], a
	ld	hl, sp+5
	ld	a, [hl]
	ld	hl, sp+51
	ld	[hl], a
;src/fatfs/lib/ff.c:5204: dcl = create_chain(&sobj, 0);		/* Allocate a cluster for the new directory */
	ld	de, $0000
	push	de
	push	de
	ld	hl, 54
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_create_chain__far
	ld	hl, sp+69
	ld	[hl], c
	inc	hl
	ld	[hl], b
	inc	hl
	ld	[hl], e
	inc	hl
	ld	[hl], d
	ld	hl, sp+69
	ld	d, h
	ld	e, l
	ld	hl, sp+65
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
;src/fatfs/lib/ff.c:5205: res = FR_OK;
	ld	hl, sp+64
	ld	[hl], $00
;src/fatfs/lib/ff.c:5206: if (dcl == 0) res = FR_DENIED;		/* No space to allocate a new cluster? */
	ld	hl, sp+68
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	dec	hl
	or	a, [hl]
	dec	hl
	or	a, [hl]
	jp	NZ, .l00104
	dec	hl
	ld	[hl], $07
.l00104:
;src/fatfs/lib/ff.c:5207: if (dcl == 1) res = FR_INT_ERR;		/* Any insanity? */
	ld	hl, sp+65
	ld	a, [hl]
	dec	a
	inc	hl
	or	a, [hl]
	inc	hl
	or	a, [hl]
	inc	hl
	or	a, [hl]
	jp	NZ,.l00187
	jp	.l00188
.l00187:
	jp	.l00106
.l00188:
	ld	hl, sp+64
	ld	[hl], $02
.l00106:
;src/fatfs/lib/ff.c:5208: if (dcl == 0xFFFFFFFF) res = FR_DISK_ERR;	/* Disk error? */
	ld	hl, sp+65
	ld	a, [hl]
	inc	hl
	and	a, [hl]
	inc	hl
	and	a, [hl]
	inc	hl
	and	a, [hl]
	inc	a
	jp	NZ,.l00189
	jp	.l00190
.l00189:
	jp	.l00108
.l00190:
	ld	hl, sp+64
	ld	[hl], $01
.l00108:
;src/fatfs/lib/ff.c:5209: tm = GET_FATTIME();
	call	_get_fattime__far
	ld	hl, sp+69
	ld	[hl], c
	inc	hl
	ld	[hl], b
	inc	hl
	ld	[hl], e
	inc	hl
	ld	[hl], d
;src/fatfs/lib/ff.c:5210: if (res == FR_OK) {
	ld	hl, sp+64
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00115
;src/fatfs/lib/ff.c:5211: res = dir_clear(fs, dcl);		/* Clear the allocated cluster as new direcotry table */
	ld	hl, sp+67
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	push	de
	ld	hl, sp+67
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	push	de
	ld	hl, sp+8
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_dir_clear__far
	ld	hl, sp+64
	ld	[hl], a
;src/fatfs/lib/ff.c:5212: if (res == FR_OK) {
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00115
;src/fatfs/lib/ff.c:5214: memset(fs->win + DIR_Name, ' ', 11);	/* Create "." entry */
	ld	hl, sp+4
	ld	a, [hl]
	inc	hl
	ld	d, [hl]
	add	a, $32
	ld	e, a
	jp	NC, .l00191
	inc	d
.l00191:
	ld	bc, $000B
	push	bc
	ld	bc, $0020
	call	_memset
;src/fatfs/lib/ff.c:5215: fs->win[DIR_Name] = '.';
	ld	hl, sp+4
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	ld	hl, $0032
	add	hl, bc
	ld	[hl], $2E
;src/fatfs/lib/ff.c:5216: fs->win[DIR_Attr] = AM_DIR;
	ld	hl, sp+4
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	ld	hl, $003D
	add	hl, bc
	ld	[hl], $10
;src/fatfs/lib/ff.c:5217: st_32(fs->win + DIR_ModTime, tm);
	ld	hl, sp+4
	ld	a, [hl]
	inc	hl
	ld	d, [hl]
	add	a, $48
	ld	e, a
	jp	NC, .l00192
	inc	d
.l00192:
	ld	hl, sp+71
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	push	bc
	ld	hl, sp+71
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	push	bc
	call	_st_32
;src/fatfs/lib/ff.c:5218: st_clust(fs, fs->win, dcl);
	ld	hl, sp+4
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $0032
	add	hl, de
	ld	c, l
	ld	b, h
	ld	hl, sp+67
	ld	a, [hl]
	inc	hl
	ld	h, [hl]
;	spillPairReg hl
;	spillPairReg hl
	ld	l, a
;	spillPairReg hl
;	spillPairReg hl
	push	hl
	ld	hl, sp+67
	ld	a, [hl]
	inc	hl
	ld	h, [hl]
;	spillPairReg hl
;	spillPairReg hl
	ld	l, a
;	spillPairReg hl
;	spillPairReg hl
	push	hl
	call	_st_clust__far
;src/fatfs/lib/ff.c:5219: memcpy(fs->win + SZDIRE, fs->win, SZDIRE);	/* Create ".." entry */
	ld	hl, sp+4
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $0032
	add	hl, de
	ld	c, l
	ld	b, h
	ld	hl, $0052
	add	hl, de
	ld	e, l
	ld	d, h
	ld	hl, $0020
	push	hl
	call	___memcpy
;src/fatfs/lib/ff.c:5220: fs->win[SZDIRE + 1] = '.'; pcl = dj.obj.sclust;
	ld	hl, sp+4
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	ld	hl, $0053
	add	hl, bc
	ld	[hl], $2E
	ld	hl, sp+12
	ld	a, [hl]
	ld	hl, sp+0
	ld	[hl], a
	ld	hl, sp+13
	ld	a, [hl]
	ld	hl, sp+1
	ld	[hl], a
	ld	hl, sp+14
	ld	a, [hl]
	ld	hl, sp+2
	ld	[hl], a
	ld	hl, sp+15
	ld	a, [hl]
	ld	hl, sp+3
	ld	[hl], a
;src/fatfs/lib/ff.c:5221: st_clust(fs, fs->win + SZDIRE, pcl);
	inc	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $0052
	add	hl, de
	ld	c, l
	ld	b, h
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
	call	_st_clust__far
;src/fatfs/lib/ff.c:5222: fs->wflag = 1;
	ld	hl, sp+4
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	ld	hl, $0004
	add	hl, bc
	ld	[hl], $01
;src/fatfs/lib/ff.c:5224: res = dir_register(&dj);	/* Register the object to the parent directory */
	ld	hl, 6
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_dir_register__far
	ld	hl, sp+64
	ld	[hl], a
.l00115:
;src/fatfs/lib/ff.c:5227: if (res == FR_OK) {
	ld	hl, sp+64
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00119
;src/fatfs/lib/ff.c:5241: st_32(dj.dir + DIR_CrtTime, tm);	/* Created time */
	ld	hl, sp+32
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	ld	hl, $000E
	add	hl, bc
	ld	e, l
	ld	d, h
	ld	hl, sp+71
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	push	bc
	ld	hl, sp+71
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	push	bc
	call	_st_32
;src/fatfs/lib/ff.c:5242: st_32(dj.dir + DIR_ModTime, tm);
	ld	hl, sp+32
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	ld	hl, $0016
	add	hl, bc
	ld	e, l
	ld	d, h
	ld	hl, sp+71
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	push	bc
	ld	hl, sp+71
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	push	bc
	call	_st_32
;src/fatfs/lib/ff.c:5243: st_clust(fs, dj.dir, dcl);			/* Table start cluster */
	ld	hl, sp+32
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	ld	hl, sp+67
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	push	de
	ld	hl, sp+67
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	push	de
	ld	hl, sp+8
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_st_clust__far
;src/fatfs/lib/ff.c:5244: dj.dir[DIR_Attr] = AM_DIR;			/* Attribute */
	ld	hl, sp+32
	ld	a, [hl]
	ld	hl, sp+69
	ld	[hl], a
	ld	hl, sp+33
	ld	a, [hl]
	ld	hl, sp+70
	ld	[hl], a
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $000B
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+73
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+72
	ld	[hl], a
	dec	hl
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	ld	[hl], $10
;src/fatfs/lib/ff.c:5245: fs->wflag = 1;
	ld	hl, sp+4
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	ld	hl, $0004
	add	hl, bc
	ld	[hl], $01
;src/fatfs/lib/ff.c:5247: if (res == FR_OK) {
	ld	hl, sp+64
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00124
;src/fatfs/lib/ff.c:5248: res = sync_fs(fs);
	ld	hl, sp+4
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_sync_fs__far
	ld	hl, sp+64
	ld	[hl], a
	jp	.l00124
.l00119:
;src/fatfs/lib/ff.c:5251: remove_chain(&sobj, dcl, 0);		/* Could not register, remove the allocated cluster */
	ld	de, $0000
	push	de
	push	de
	ld	hl, sp+71
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	push	de
	ld	hl, sp+71
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	push	de
	ld	hl, 58
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_remove_chain__far
.l00124:
;src/fatfs/lib/ff.c:5257: LEAVE_FF(fs, res);
	ld	hl, sp+64
	ld	a, [hl]
.l00125:
;src/fatfs/lib/ff.c:5258: }
	add	sp, 75
	ret
;src/fatfs/lib/ff.c:5267: FRESULT f_rename (
;	---------------------------------
	SECTION FRAGMENT "Page 13",ROMX,BANK[6]
	LOAD FRAGMENT "Page 13 RAM",SRAM,BANK[13]
; Function f_rename
; ---------------------------------
_f_rename::
	add	sp, -128
	add	sp, -9
	ld	hl, 135
	add	hl, sp
	ld	[hl], e
	inc	hl
	ld	[hl], d
	ld	hl, 133
	add	hl, sp
	ld	[hl], c
	inc	hl
	ld	[hl], b
;src/fatfs/lib/ff.c:5279: get_ldnumber(&path_new);	/* Snip the drive number of new name off */
	ld	hl, 133
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_get_ldnumber__far
;src/fatfs/lib/ff.c:5280: res = mount_volume(&path_old, &fs, FA_WRITE);	/* Get logical drive of the old object */
	ld	hl, sp+2
	ld	c, l
	ld	b, h
	ld	hl, 135
	add	hl, sp
	ld	e, l
	ld	d, h
	ld	a, $02
	push	af
	inc	sp
	call	_mount_volume__far
	ld	hl, sp+124
	ld	[hl], a
;src/fatfs/lib/ff.c:5281: if (res == FR_OK) {
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00129
;src/fatfs/lib/ff.c:5282: djo.obj.fs = fs;
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
;src/fatfs/lib/ff.c:5284: res = follow_path(&djo, path_old);	/* Check old object */
	ld	hl, 135
	add	hl, sp
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	ld	hl, 4
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_follow_path__far
	ld	hl, sp+124
	ld	[hl], a
;src/fatfs/lib/ff.c:5285: if (res == FR_OK) {
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00104
;src/fatfs/lib/ff.c:5286: if (djo.fn[NSFLAG] & (NS_DOT | NS_NONAME)) {
	ld	hl, sp+43
	ld	a, [hl]
	and	a, $A0
	jp	NZ,.l00221
	jp	.l00104
.l00221:
;src/fatfs/lib/ff.c:5287: res = FR_INVALID_NAME;		/* Object must not be a dot name or blank name */
	ld	hl, sp+124
	ld	[hl], $06
.l00104:
;src/fatfs/lib/ff.c:5294: if (res == FR_OK) {					/* It is ready to rename the object */
	ld	hl, sp+124
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00129
;src/fatfs/lib/ff.c:5333: memcpy(buf, djo.dir, SZDIRE);			/* Save directory entry of the object */
	ld	hl, sp+30
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	ld	de, $0020
	push	de
	ld	hl, 94
	add	hl, sp
	ld	e, l
	ld	d, h
	call	___memcpy
;src/fatfs/lib/ff.c:5334: memcpy(&djn, &djo, sizeof djn);			/* Duplicate the directory object */
	ld	de, $002C
	push	de
	ld	hl, 6
	add	hl, sp
	ld	c, l
	ld	b, h
	ld	hl, 50
	add	hl, sp
	ld	e, l
	ld	d, h
	call	___memcpy
;src/fatfs/lib/ff.c:5335: res = follow_path(&djn, path_new);		/* Make sure if new object name is not in use */
	ld	hl, 133
	add	hl, sp
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	ld	hl, 48
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_follow_path__far
	ld	hl, sp+124
	ld	[hl], a
;src/fatfs/lib/ff.c:5337: res = (djn.obj.sclust == djo.obj.sclust && djn.dptr == djo.dptr) ? FR_NO_FILE : FR_EXIST;
;src/fatfs/lib/ff.c:5336: if (res == FR_OK) {						/* Is new name already in use by another object? */
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00106
;src/fatfs/lib/ff.c:5337: res = (djn.obj.sclust == djo.obj.sclust && djn.dptr == djo.dptr) ? FR_NO_FILE : FR_EXIST;
	ld	hl, sp+54
	ld	a, [hl]
	ld	hl, sp+125
	ld	[hl], a
	ld	hl, sp+55
	ld	a, [hl]
	ld	hl, sp+126
	ld	[hl], a
	ld	hl, sp+56
	ld	a, [hl]
	ld	hl, sp+127
	ld	[hl], a
	ld	hl, sp+57
	ld	a, [hl]
	ld	hl, 128
	add	hl, sp
	ld	[hl], a
	ld	hl, sp+10
	ld	a, [hl]
	ld	hl, 129
	add	hl, sp
	ld	[hl], a
	ld	hl, sp+11
	ld	a, [hl]
	ld	hl, 130
	add	hl, sp
	ld	[hl], a
	ld	hl, sp+12
	ld	a, [hl]
	ld	hl, 131
	add	hl, sp
	ld	[hl], a
	ld	hl, sp+13
	ld	a, [hl]
	ld	hl, 132
	add	hl, sp
	ld	[hl], a
	ld	hl, sp+125
	ld	a, [hl]
	ld	hl, 129
	add	hl, sp
	sub	a, [hl]
	jp	NZ,.l00222
	ld	hl, sp+126
	ld	a, [hl]
	ld	hl, 130
	add	hl, sp
	sub	a, [hl]
	jp	NZ,.l00222
	ld	hl, sp+127
	ld	a, [hl]
	ld	hl, 131
	add	hl, sp
	sub	a, [hl]
	jp	NZ,.l00222
	ld	hl, 128
	add	hl, sp
	ld	a, [hl]
	ld	hl, 132
	add	hl, sp
	sub	a, [hl]
	jp	NZ,.l00222
	jp	.l00223
.l00222:
	jp	.l00132
.l00223:
	ld	hl, sp+62
	ld	a, [hl]
	ld	hl, sp+125
	ld	[hl], a
	ld	hl, sp+63
	ld	a, [hl]
	ld	hl, sp+126
	ld	[hl], a
	ld	hl, sp+64
	ld	a, [hl]
	ld	hl, sp+127
	ld	[hl], a
	ld	hl, sp+65
	ld	a, [hl]
	ld	hl, 128
	add	hl, sp
	ld	[hl], a
	ld	hl, sp+18
	ld	a, [hl]
	ld	hl, 129
	add	hl, sp
	ld	[hl], a
	ld	hl, sp+19
	ld	a, [hl]
	ld	hl, 130
	add	hl, sp
	ld	[hl], a
	ld	hl, sp+20
	ld	a, [hl]
	ld	hl, 131
	add	hl, sp
	ld	[hl], a
	ld	hl, sp+21
	ld	a, [hl]
	ld	hl, 132
	add	hl, sp
	ld	[hl], a
	ld	hl, sp+125
	ld	a, [hl]
	ld	hl, 129
	add	hl, sp
	sub	a, [hl]
	jp	NZ,.l00224
	ld	hl, sp+126
	ld	a, [hl]
	ld	hl, 130
	add	hl, sp
	sub	a, [hl]
	jp	NZ,.l00224
	ld	hl, sp+127
	ld	a, [hl]
	ld	hl, 131
	add	hl, sp
	sub	a, [hl]
	jp	NZ,.l00224
	ld	hl, 128
	add	hl, sp
	ld	a, [hl]
	ld	hl, 132
	add	hl, sp
	sub	a, [hl]
	jp	NZ,.l00224
	jp	.l00225
.l00224:
	jp	.l00132
.l00225:
	ld	a, $04
	jp	.l00133
.l00132:
	ld	a, $08
.l00133:
	ld	hl, sp+124
	ld	[hl], a
.l00106:
;src/fatfs/lib/ff.c:5339: if (res == FR_NO_FILE) { 				/* It is a valid path and no name collision */
	ld	hl, sp+124
	ld	a, [hl]
	sub	a, $04
	jp	NZ,.l00226
	jp	.l00227
.l00226:
	jp	.l00121
.l00227:
;src/fatfs/lib/ff.c:5340: res = dir_register(&djn);			/* Register the new entry */
	ld	hl, 48
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_dir_register__far
	ld	hl, sp+124
	ld	[hl], a
;src/fatfs/lib/ff.c:5341: if (res == FR_OK) {
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00121
;src/fatfs/lib/ff.c:5342: dir = djn.dir;					/* Copy directory entry of the object except name */
	ld	hl, sp+74
	ld	a, [hl]
	ld	hl, sp+0
	ld	[hl], a
	ld	hl, sp+75
	ld	a, [hl]
	ld	hl, sp+1
	ld	[hl], a
;src/fatfs/lib/ff.c:5343: memcpy(dir + 13, buf + 13, SZDIRE - 13);
	pop	de
	push	de
	ld	hl, $000D
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, 133
	add	hl, sp
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, 132
	add	hl, sp
	ld	[hl], a
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	bc, $0013
	push	bc
	ld	hl, 107
	add	hl, sp
	ld	c, l
	ld	b, h
	call	___memcpy
;src/fatfs/lib/ff.c:5344: dir[DIR_Attr] = buf[DIR_Attr];
	pop	de
	push	de
	ld	hl, $000B
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, 133
	add	hl, sp
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, 132
	add	hl, sp
	ld	[hl], a
	ld	hl, sp+103
	ld	c, [hl]
	ld	hl, 131
	add	hl, sp
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	ld	[hl], c
;src/fatfs/lib/ff.c:5345: if (!(dir[DIR_Attr] & AM_DIR)) dir[DIR_Attr] |= AM_ARC;	/* Set archive attribute if it is a file */
	ld	hl, 132
	add	hl, sp
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	bit	4, c
	jp	NZ,.l00228
	jp	.l00229
.l00228:
	jp	.l00108
.l00229:
	ld	c, a
	set	5, c
	ld	hl, 131
	add	hl, sp
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	ld	[hl], c
.l00108:
;src/fatfs/lib/ff.c:5346: fs->wflag = 1;
	pop	hl
	pop	bc
	push	bc
	push	hl
	ld	hl, $0004
	add	hl, bc
	ld	[hl], $01
;src/fatfs/lib/ff.c:5347: if ((dir[DIR_Attr] & AM_DIR) && djo.obj.sclust != djn.obj.sclust) {	/* Update .. entry in the sub-directory being moved if needed */
	ld	hl, 132
	add	hl, sp
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	bit	4, a
	jp	NZ,.l00230
	jp	.l00121
.l00230:
	ld	hl, sp+10
	ld	a, [hl]
	ld	hl, sp+125
	ld	[hl], a
	ld	hl, sp+11
	ld	a, [hl]
	ld	hl, sp+126
	ld	[hl], a
	ld	hl, sp+12
	ld	a, [hl]
	ld	hl, sp+127
	ld	[hl], a
	ld	hl, sp+13
	ld	a, [hl]
	ld	hl, 128
	add	hl, sp
	ld	[hl], a
	ld	hl, sp+54
	ld	a, [hl]
	ld	hl, 129
	add	hl, sp
	ld	[hl], a
	ld	hl, sp+55
	ld	a, [hl]
	ld	hl, 130
	add	hl, sp
	ld	[hl], a
	ld	hl, sp+56
	ld	a, [hl]
	ld	hl, 131
	add	hl, sp
	ld	[hl], a
	ld	hl, sp+57
	ld	a, [hl]
	ld	hl, 132
	add	hl, sp
	ld	[hl], a
	ld	hl, sp+125
	ld	a, [hl]
	ld	hl, 129
	add	hl, sp
	sub	a, [hl]
	jp	NZ,.l00231
	ld	hl, sp+126
	ld	a, [hl]
	ld	hl, 130
	add	hl, sp
	sub	a, [hl]
	jp	NZ,.l00231
	ld	hl, sp+127
	ld	a, [hl]
	ld	hl, 131
	add	hl, sp
	sub	a, [hl]
	jp	NZ,.l00231
	ld	hl, 128
	add	hl, sp
	ld	a, [hl]
	ld	hl, 132
	add	hl, sp
	sub	a, [hl]
	jp	NZ,.l00231
	jp	.l00121
.l00231:
;src/fatfs/lib/ff.c:5348: LBA_t sect = clst2sect(fs, ld_clust(fs, dir));
	pop	bc
	push	bc
	pop	hl
	pop	de
	push	de
	push	hl
	call	_ld_clust__far
	push	de
	push	bc
	ld	hl, sp+6
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_clst2sect__far
	ld	hl, sp+125
	ld	[hl], c
	inc	hl
	ld	[hl], b
	inc	hl
	ld	[hl], e
	inc	hl
	ld	[hl], d
	ld	hl, sp+125
	ld	d, h
	ld	e, l
	ld	hl, 129
	add	hl, sp
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
;src/fatfs/lib/ff.c:5350: if (sect == 0) {
	ld	hl, 128
	add	hl, sp
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	dec	hl
	or	a, [hl]
	dec	hl
	or	a, [hl]
	jp	NZ, .l00113
;src/fatfs/lib/ff.c:5351: res = FR_INT_ERR;
	dec	hl
	ld	[hl], $02
	jp	.l00121
.l00113:
;src/fatfs/lib/ff.c:5354: res = move_window(fs, sect);
	ld	hl, 131
	add	hl, sp
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	push	de
	ld	hl, 131
	add	hl, sp
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	push	de
	ld	hl, sp+6
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_move_window__far
	ld	hl, sp+124
	ld	[hl], a
;src/fatfs/lib/ff.c:5355: dir = fs->win + SZDIRE * 1;	/* Pointer to .. entry */
	ld	hl, sp+2
	ld	a, [hl]
	ld	hl, sp+125
	ld	[hl], a
	ld	hl, sp+3
	ld	a, [hl]
	ld	hl, sp+126
	ld	[hl], a
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $0052
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, 129
	add	hl, sp
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, 128
	add	hl, sp
	ld	[hl], a
;src/fatfs/lib/ff.c:5356: if (res == FR_OK && dir[1] == '.') {
	ld	hl, sp+124
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00121
	ld	hl, sp+127
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	inc	bc
	ld	a, [bc]
	sub	a, $2E
	jp	NZ,.l00232
	jp	.l00233
.l00232:
	jp	.l00121
.l00233:
;src/fatfs/lib/ff.c:5357: st_clust(fs, dir, djn.obj.sclust);
	ld	hl, sp+54
	ld	a, [hl]
	ld	hl, 129
	add	hl, sp
	ld	[hl], a
	ld	hl, sp+55
	ld	a, [hl]
	ld	hl, 130
	add	hl, sp
	ld	[hl], a
	ld	hl, sp+56
	ld	a, [hl]
	ld	hl, 131
	add	hl, sp
	ld	[hl], a
	ld	hl, sp+57
	ld	a, [hl]
	ld	hl, 132
	add	hl, sp
	ld	[hl], a
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	push	de
	ld	hl, 131
	add	hl, sp
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	push	de
	ld	hl, 131
	add	hl, sp
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	ld	hl, 129
	add	hl, sp
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_st_clust__far
;src/fatfs/lib/ff.c:5358: fs->wflag = 1;
	pop	hl
	pop	bc
	push	bc
	push	hl
	ld	hl, $0004
	add	hl, bc
	ld	[hl], $01
.l00121:
;src/fatfs/lib/ff.c:5365: if (res == FR_OK) {		/* New entry has been created */
	ld	hl, sp+124
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00129
;src/fatfs/lib/ff.c:5366: res = dir_remove(&djo);	/* Remove old entry */
	ld	hl, 4
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_dir_remove
	ld	hl, sp+124
	ld	[hl], a
;src/fatfs/lib/ff.c:5367: if (res == FR_OK) {
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00129
;src/fatfs/lib/ff.c:5368: res = sync_fs(fs);
	pop	hl
	pop	de
	push	de
	push	hl
	call	_sync_fs__far
	ld	hl, sp+124
	ld	[hl], a
.l00129:
;src/fatfs/lib/ff.c:5376: LEAVE_FF(fs, res);
	ld	hl, sp+124
	ld	a, [hl]
.l00130:
;src/fatfs/lib/ff.c:5377: }
	add	sp, 127
	add	sp, 10
	ret
;src/fatfs/lib/ffunicode.c:10447: static WCHAR oem2uni_sbcs (	/* Returns Unicode character in UTF-16, zero on error */
;	---------------------------------
	SECTION FRAGMENT "Page 8",ROMX,BANK[4]
	LOAD FRAGMENT "Page 8 RAM",SRAM,BANK[8]
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
	SECTION FRAGMENT "Page 8",ROMX,BANK[4]
	LOAD FRAGMENT "Page 8 RAM",SRAM,BANK[8]
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
	SECTION FRAGMENT "Page 11",ROMX,BANK[5]
	LOAD FRAGMENT "Page 11 RAM",SRAM,BANK[11]
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
	SECTION FRAGMENT "Page 11",ROMX,BANK[5]
	LOAD FRAGMENT "Page 11 RAM",SRAM,BANK[11]
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
	SECTION FRAGMENT "Page 11",ROMX,BANK[5]
	LOAD FRAGMENT "Page 11 RAM",SRAM,BANK[11]
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
	ld	de, _ff_wtoupper_cvt1_65536_546+0
	jp	.l00126
.l00125:
	ld	de, _ff_wtoupper_cvt2_65536_546+0
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
_ff_wtoupper_cvt1_65536_546:
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
_ff_wtoupper_cvt2_65536_546:
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
;src/fatfs/fatfs.c:40: DSTATUS disk_status(BYTE pdrv) {
;	---------------------------------
	SECTION FRAGMENT "Page 9",ROMX,BANK[4]
	LOAD FRAGMENT "Page 9 RAM",SRAM,BANK[9]
; Function disk_status
; ---------------------------------
_disk_status::
;src/fatfs/fatfs.c:42: return disk_ready ? 0 : STA_NOINIT;
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
;src/fatfs/fatfs.c:43: }
	ret
;src/fatfs/fatfs.c:45: DSTATUS disk_initialize(BYTE pdrv) {
;	---------------------------------
	SECTION FRAGMENT "Page 9",ROMX,BANK[4]
	LOAD FRAGMENT "Page 9 RAM",SRAM,BANK[9]
; Function disk_initialize
; ---------------------------------
_disk_initialize::
	ld	l, a
;	spillPairReg hl
;	spillPairReg hl
;src/fatfs/fatfs.c:46: disk_ready = !sd_Init();
	push	hl
	call	_sd_Init
	pop	hl
	sub	a,$01
	ld	a, $00
	rla
	ld	[_disk_ready], a
;src/fatfs/fatfs.c:47: return disk_status(pdrv);
	ld	a, l
	jp	_disk_status
.l00101:
;src/fatfs/fatfs.c:48: }
	ret
;src/fatfs/fatfs.c:52: DRESULT disk_read(BYTE pdrv, BYTE* buff, LBA_t sector, UINT count) {
;	---------------------------------
	SECTION FRAGMENT "Page 14",ROMX,BANK[7]
	LOAD FRAGMENT "Page 14 RAM",SRAM,BANK[14]
; Function disk_read
; ---------------------------------
_disk_read::
	add	sp, -6
	inc	sp
	inc	sp
	push	de
;src/fatfs/fatfs.c:53: (void)pdrv;
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
;src/fatfs/fatfs.c:54: for (; count; --count, ++sector, buff += FF_MAX_SS) {
	ld	a, b
	or	a, c
	jp	Z, .l00103
;src/fatfs/fatfs.c:55: sd_sector = sector;
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
;src/fatfs/fatfs.c:56: if (sd_ReadSector(buff)) {
	push	bc
	pop	hl
	pop	de
	push	de
	push	hl
	call	_sd_ReadSector
	pop	bc
	or	a, a
	jp	Z, .l00106
;src/fatfs/fatfs.c:57: disk_ready = 0;
	ld	hl, _disk_ready
	ld	[hl], $00
;src/fatfs/fatfs.c:58: return RES_ERROR;
	ld	a, $01
	jp	.l00107
.l00106:
;src/fatfs/fatfs.c:54: for (; count; --count, ++sector, buff += FF_MAX_SS) {
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
;src/fatfs/fatfs.c:61: return RES_OK;
	xor	a, a
.l00107:
;src/fatfs/fatfs.c:62: }
	add	sp, 6
	pop	hl
	add	sp, 6
	jp hl
;src/fatfs/fatfs.c:64: DRESULT disk_write(BYTE pdrv, const BYTE* buff, LBA_t sector, UINT count) {
;	---------------------------------
	SECTION FRAGMENT "Page 9",ROMX,BANK[4]
	LOAD FRAGMENT "Page 9 RAM",SRAM,BANK[9]
; Function disk_write
; ---------------------------------
_disk_write::
	add	sp, -6
	inc	sp
	inc	sp
	push	de
;src/fatfs/fatfs.c:65: (void)pdrv;
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
;src/fatfs/fatfs.c:66: for (; count; --count, ++sector, buff += FF_MAX_SS) {
	ld	a, b
	or	a, c
	jp	Z, .l00103
;src/fatfs/fatfs.c:67: sd_sector = sector;
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
;src/fatfs/fatfs.c:68: if (sd_WriteSector(buff)) {
	push	bc
	pop	hl
	pop	de
	push	de
	push	hl
	call	_sd_WriteSector
	pop	bc
	or	a, a
	jp	Z, .l00106
;src/fatfs/fatfs.c:69: disk_ready = 0;
	ld	hl, _disk_ready
	ld	[hl], $00
;src/fatfs/fatfs.c:70: return RES_ERROR;
	ld	a, $01
	jp	.l00107
.l00106:
;src/fatfs/fatfs.c:66: for (; count; --count, ++sector, buff += FF_MAX_SS) {
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
;src/fatfs/fatfs.c:73: return RES_OK;
	xor	a, a
.l00107:
;src/fatfs/fatfs.c:74: }
	add	sp, 6
	pop	hl
	add	sp, 6
	jp hl
;src/fatfs/fatfs.c:76: DRESULT disk_ioctl(BYTE pdrv, BYTE cmd, void* buff) {
;	---------------------------------
	SECTION FRAGMENT "Page 9",ROMX,BANK[4]
	LOAD FRAGMENT "Page 9 RAM",SRAM,BANK[9]
; Function disk_ioctl
; ---------------------------------
_disk_ioctl::
;src/fatfs/fatfs.c:79: return cmd == CTRL_SYNC ? RES_OK : RES_PARERR;
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
;src/fatfs/fatfs.c:80: }
	pop	hl
	inc	sp
	inc	sp
	jp hl
;src/fatfs/fatfs.c:83: unsigned char fs_Mount(void) {
;	---------------------------------
	SECTION FRAGMENT "Page 8",ROMX,BANK[4]
	LOAD FRAGMENT "Page 8 RAM",SRAM,BANK[8]
; Function fs_Mount
; ---------------------------------
_fs_Mount::
;src/fatfs/fatfs.c:84: if (fs.fs_type && disk_ready) return FR_OK;
	ld	a, [_fs + 0]
	or	a, a
	jp	Z, .l00102
	ld	hl, _disk_ready
	ld	a, [hl]
	or	a, a
	jp	Z, .l00102
	xor	a, a
	jp	.l00104
.l00102:
;src/fatfs/fatfs.c:85: return f_mount(&fs, "", 1);
	ld	a, $01
	push	af
	inc	sp
	ld	bc, ___src_fatfs_fatfs_c_str_3
	ld	de, _fs
	call	_f_mount__far
.l00104:
;src/fatfs/fatfs.c:86: }
	ret
	SECTION FRAGMENT "src/fatfs/fatfs.c ROM0",ROM0
___src_fatfs_fatfs_c_str_3:
	DB $00
;src/fatfs/fatfs.c:106: static FRESULT Seek(WORD slot) {
;	---------------------------------
	SECTION FRAGMENT "Page 8",ROMX,BANK[4]
	LOAD FRAGMENT "Page 8 RAM",SRAM,BANK[8]
; Function Seek
; ---------------------------------
_Seek:
;src/fatfs/fatfs.c:107: list_slot = slot;
	ld	hl, _list_slot
	ld	[hl], e
	inc	hl
	ld	[hl], d
;src/fatfs/fatfs.c:108: return dir_sdi(&dir, (DWORD)slot << 5);
	ld	bc, $0000
	ld	a, $05
.l00103:
	sla	e
	rl	d
	rl	c
	rl	b
.l00104:
	dec	a
	jr	NZ,.l00103
	push	bc
	push	de
	ld	de, _dir
	call	_dir_sdi__far
.l00101:
;src/fatfs/fatfs.c:109: }
	ret
;src/fatfs/fatfs.c:113: static BYTE NextSlot(void) {
;	---------------------------------
	SECTION FRAGMENT "Page 8",ROMX,BANK[4]
	LOAD FRAGMENT "Page 8 RAM",SRAM,BANK[8]
; Function NextSlot
; ---------------------------------
_NextSlot:
	add	sp, -8
;src/fatfs/fatfs.c:115: if (((BYTE)list_slot++ & (SS(&fs) / SZDIRE - 1)) != SS(&fs) / SZDIRE - 1) { // same sector
	ld	hl, _list_slot
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	dec	hl
	inc	[hl]
	jp	NZ, .l00130
	inc	hl
	inc	[hl]
.l00130:
	ld	a, c
	ld	b, $00
	and	a, $0F
	ld	c, a
	ld	b, $00
	ld	a, c
	sub	a, $0F
	or	a, b
	jp	NZ,.l00131
	jp	.l00102
.l00131:
;src/fatfs/fatfs.c:116: dir.dptr += SZDIRE;
	ld	bc, _dir + 14
	ld	e, c
	ld	d, b
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
	pop	de
	push	de
	ld	a, e
	add	a, $20
	ld	e, a
	ld	a, d
	adc	a, $00
	push	af
	inc	hl
	inc	hl
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
	ld	hl, sp+7
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
;src/fatfs/fatfs.c:117: dir.dir += SZDIRE;
	ld	hl, (_dir + 26) + 0
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	ld	hl, $0020
	add	hl, bc
	ld	c, l
	ld	b, h
	ld	hl, (_dir + 26)
	ld	[hl], c
	inc	hl
	ld	[hl], b
;src/fatfs/fatfs.c:118: return 1;
	ld	a, $01
	jp	.l00108
.l00102:
;src/fatfs/fatfs.c:120: if (!(result = dir_next(&dir, 0)) && !(result = move_window(&fs, dir.sect))) return 1;
	ld	bc, $0000
	ld	de, _dir
	call	_dir_next__far
	ld	e, a
	ld	c, e
	ld	a, e
	or	a, a
	jp	NZ, .l00104
	ld	de, (_dir + 22) + 0
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
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	push	de
	ld	hl, sp+6
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	push	de
	ld	de, _fs
	call	_move_window__far
	ld	c, a
	or	a, a
	jp	NZ, .l00104
	ld	a, $01
	jp	.l00108
.l00104:
;src/fatfs/fatfs.c:121: if (result != FR_NO_FILE) list_error = result;
	ld	a, c
	sub	a, $04
	jp	NZ,.l00132
	jp	.l00107
.l00132:
	ld	hl, _list_error
	ld	[hl], c
.l00107:
;src/fatfs/fatfs.c:122: dir.sect = 0;
	ld	hl, (_dir + 22)
	xor	a, a
	ld	[hl], a
	inc	hl
	ld	[hl], a
	inc	hl
	ld	[hl], a
	inc	hl
	ld	[hl], a
;src/fatfs/fatfs.c:123: return 0;
	xor	a, a
.l00108:
;src/fatfs/fatfs.c:124: }
	add	sp, 8
	ret
;src/fatfs/fatfs.c:129: static BYTE NextEntry(BYTE name) {
;	---------------------------------
	SECTION FRAGMENT "Page 8",ROMX,BANK[4]
	LOAD FRAGMENT "Page 8 RAM",SRAM,BANK[8]
; Function NextEntry
; ---------------------------------
_NextEntry:
	add	sp, -13
	ld	hl, sp+11
	ld	[hl], a
;src/fatfs/fatfs.c:130: BYTE c, attr, ord = 0xFF, sum = 0, dot = 0, named = 0, lfn;
	inc	hl
	ld	[hl], $FF
	ld	hl, sp+4
	ld	[hl], $00
	inc	hl
	ld	[hl], $00
	inc	hl
	ld	[hl], $00
;src/fatfs/fatfs.c:133: if (!dir.sect) return 0;
	ld	de, (_dir + 22) + 0
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
	jp	NZ, .l00102
	xor	a, a
	jp	.l00138
.l00102:
;src/fatfs/fatfs.c:134: if (dir.sect != fs.winsect && (result = move_window(&fs, dir.sect))) { // after a seek
	ld	de, (_fs + 30) + 0
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
	ld	hl, sp+0
	ld	a, [hl]
	ld	hl, sp+7
	sub	a, [hl]
	jp	NZ,.l00272
	ld	hl, sp+1
	ld	a, [hl]
	ld	hl, sp+8
	sub	a, [hl]
	jp	NZ,.l00272
	ld	hl, sp+2
	ld	a, [hl]
	ld	hl, sp+9
	sub	a, [hl]
	jp	NZ,.l00272
	ld	hl, sp+3
	ld	a, [hl]
	ld	hl, sp+10
	sub	a, [hl]
	jp	NZ,.l00272
	jp	.l00175
.l00272:
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
	ld	de, _fs
	call	_move_window__far
	ld	c, a
	or	a, a
	jp	Z, .l00175
;src/fatfs/fatfs.c:135: list_error = result;
	ld	hl, _list_error
	ld	[hl], c
;src/fatfs/fatfs.c:136: return 0;
	xor	a, a
	jp	.l00138
;src/fatfs/fatfs.c:138: do {
.l00175:
.l00135:
;src/fatfs/fatfs.c:139: entry = dir.dir;
	ld	de, (_dir + 26) + 0
	ld	a, [de]
	ld	hl, sp+7
	ld	[hl], a
	inc	de
	ld	a, [de]
	inc	hl
	ld	[hl], a
;src/fatfs/fatfs.c:140: if (!(c = entry[DIR_Name])) break; // end of the folder
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	inc	hl
	ld	[hl], a
	ld	a, [hl]
	inc	hl
	ld	[hl], a
	dec	hl
	ld	a, [hl]
	or	a, a
	jp	Z, .l00137
;src/fatfs/fatfs.c:141: attr = entry[DIR_Attr] & AM_MASK;
	dec	hl
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $000B
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
	and	a, $3F
	ld	hl, sp+9
	ld	[hl], a
;src/fatfs/fatfs.c:142: if (c == DDEM || c == '.' || (BYTE)(attr & ~AM_ARC) == AM_VOL) ord = 0xFF;
	inc	hl
	ld	a, [hl]
	sub	a, $E5
	jp	NZ,.l00273
	jp	.l00130
.l00273:
	ld	hl, sp+10
	ld	a, [hl]
	sub	a, $2E
	jp	NZ,.l00274
	jp	.l00130
.l00274:
	ld	hl, sp+9
	ld	a, [hl]
	res	5, a
	sub	a, $08
	jp	NZ,.l00275
	jp	.l00276
.l00275:
	jp	.l00131
.l00276:
.l00130:
	ld	hl, sp+12
	ld	[hl], $FF
	jp	.l00136
.l00131:
;src/fatfs/fatfs.c:143: else if (attr == AM_LFN) {
	ld	hl, sp+9
	ld	a, [hl]
	sub	a, $0F
	jp	NZ,.l00277
	jp	.l00278
.l00277:
	jp	.l00128
.l00278:
;src/fatfs/fatfs.c:147: sum = entry[LDIR_Chksum];
	ld	hl, sp+8
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $000D
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+4
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+3
	ld	[hl], a
;src/fatfs/fatfs.c:144: if (c & LLEF) { // first slot of an LFN (its last part)
	push	hl
	ld	hl, sp+12
	bit	6, [hl]
	pop	hl
	jp	NZ,.l00279
	jp	.l00109
.l00279:
;src/fatfs/fatfs.c:145: c &= (BYTE)~LLEF;
	ld	hl, sp+10
	ld	a, [hl]
	and	a, $BF
	ld	[hl], a
;src/fatfs/fatfs.c:146: ord = c;
	ld	a, [hl]
	inc	hl
	inc	hl
	ld	[hl], a
;src/fatfs/fatfs.c:147: sum = entry[LDIR_Chksum];
	ld	hl, sp+3
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	inc	hl
	ld	[hl], a
;src/fatfs/fatfs.c:148: named = name;
	ld	hl, sp+11
	ld	a, [hl]
	ld	hl, sp+6
	ld	[hl], a
;src/fatfs/fatfs.c:149: list_start = list_slot;
	ld	hl, _list_slot
	ld	a, [hl]
	ld	hl, _list_start
	ld	[hl], a
	ld	hl, _list_slot + 1
	ld	a, [hl]
	ld	hl, _list_start + 1
	ld	[hl], a
.l00109:
;src/fatfs/fatfs.c:151: if (c == ord && sum == entry[LDIR_Chksum] && !entry[LDIR_FstClusLO] && !entry[LDIR_FstClusLO + 1]) {
	ld	hl, sp+10
	ld	a, [hl]
	inc	hl
	inc	hl
	sub	a, [hl]
	jp	NZ,.l00280
	jp	.l00281
.l00280:
	jp	.l00116
.l00281:
	ld	hl, sp+3
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	ld	c, a
	inc	hl
	ld	a, [hl]
	sub	a, c
	jp	NZ,.l00282
	jp	.l00283
.l00282:
	jp	.l00116
.l00283:
	ld	hl, sp+8
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $001A
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
	ld	[hl], a
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00116
	dec	hl
	dec	hl
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $001B
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
	or	a, a
	jp	NZ, .l00116
;src/fatfs/fatfs.c:152: if (named && !pick_lfn(fs.lfnbuf, entry)) named = 0; // too long, the SFN is shown
	ld	hl, sp+6
	ld	a, [hl]
	or	a, a
	jp	Z, .l00111
	ld	hl, (_fs + 12) + 0
	ld	a, [hl+]
	ld	h, [hl]
;	spillPairReg hl
	ld	l, a
;	spillPairReg hl
;	spillPairReg hl
	push	hl
	ld	hl, sp+9
	ld	c, [hl]
	pop	hl
	push	hl
	ld	hl, sp+10
	ld	b, [hl]
	pop	hl
	ld	e, l
	ld	d, h
	call	_pick_lfn__far
	ld	a, b
	or	a, c
	jp	NZ, .l00111
	ld	hl, sp+6
	ld	[hl], $00
.l00111:
;src/fatfs/fatfs.c:153: if (!--ord) dot = entry[1] == '.' && !entry[2]; // first character
	ld	hl, sp+12
	dec	[hl]
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00136
	ld	hl, sp+7
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	inc	bc
	ld	a, [bc]
	sub	a, $2E
	jp	NZ,.l00284
	jp	.l00285
.l00284:
	jp	.l00140
.l00285:
	dec	hl
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	inc	bc
	inc	bc
	ld	a, [bc]
	or	a, a
	jp	Z, .l00141
.l00140:
	ld	hl, sp+10
	ld	[hl], $00
	jp	.l00142
.l00141:
	ld	hl, sp+10
	ld	[hl], $01
.l00142:
	ld	hl, sp+10
	ld	a, [hl]
	ld	hl, sp+5
	ld	[hl], a
	jp	.l00136
.l00116:
;src/fatfs/fatfs.c:155: else ord = 0xFF;
	ld	hl, sp+12
	ld	[hl], $FF
	jp	.l00136
.l00128:
;src/fatfs/fatfs.c:158: lfn = !ord && sum == sum_sfn(entry);
	ld	hl, sp+12
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00143
	ld	hl, sp+7
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_sum_sfn
	ld	c, a
	ld	hl, sp+4
	ld	a, [hl]
	sub	a, c
	jp	NZ,.l00286
	jp	.l00144
.l00286:
.l00143:
	ld	e, $00
	jp	.l00145
.l00144:
	ld	e, $01
.l00145:
	ld	hl, sp+12
	ld	[hl], e
;src/fatfs/fatfs.c:159: if (!lfn) list_start = list_slot;
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00122
	ld	hl, _list_slot
	ld	a, [hl]
	ld	hl, _list_start
	ld	[hl], a
	ld	hl, _list_slot + 1
	ld	a, [hl]
	ld	hl, _list_start + 1
	ld	[hl], a
.l00122:
;src/fatfs/fatfs.c:160: if (!(attr & (AM_HID | AM_SYS)) && !(lfn && dot)) {
	ld	hl, sp+9
	ld	a, [hl]
	and	a, $06
	jp	NZ,.l00287
	jp	.l00288
.l00287:
	jp	.l00124
.l00288:
	ld	hl, sp+12
	ld	a, [hl]
	or	a, a
	jp	Z, .l00123
	ld	hl, sp+5
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00124
.l00123:
;src/fatfs/fatfs.c:161: dir.blk_ofs = lfn && named ? (DWORD)list_start << 5 : 0xFFFFFFFF;
	ld	hl, sp+12
	ld	a, [hl]
	or	a, a
	jp	Z, .l00146
	ld	hl, sp+6
	ld	a, [hl]
	or	a, a
	jp	Z, .l00146
	ld	hl, _list_start
	ld	a, [hl]
	ld	hl, sp+5
	ld	[hl], a
	ld	hl, _list_start + 1
	ld	a, [hl]
	ld	hl, sp+6
	ld	[hl], a
	xor	a, a
	inc	hl
	ld	[hl], a
	inc	hl
	ld	[hl], a
	ld	a, $05
.l00289:
	ld	hl, sp+5
	sla	[hl]
	inc	hl
	rl	[hl]
	inc	hl
	rl	[hl]
	inc	hl
	rl	[hl]
.l00290:
	dec	a
	jr	NZ,.l00289
	jp	.l00147
.l00146:
	ld	hl, sp+5
	ld	[hl], $FF
	inc	hl
	ld	[hl], $FF
	inc	hl
	ld	[hl], $FF
	inc	hl
	ld	[hl], $FF
.l00147:
	ld	de, (_dir + 40)
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
;src/fatfs/fatfs.c:162: return attr & AM_DIR ? 1 : 2;
	push	hl
	inc	hl
	bit	4, [hl]
	pop	hl
	jp	NZ,.l00291
	jp	.l00151
.l00291:
	ld	bc, $0001
	jp	.l00152
.l00151:
	ld	bc, $0002
.l00152:
	ld	a, c
	jp	.l00138
.l00124:
;src/fatfs/fatfs.c:164: ord = 0xFF;
	ld	hl, sp+12
	ld	[hl], $FF
.l00136:
;src/fatfs/fatfs.c:166: } while (NextSlot());
	call	_NextSlot
	ld	hl, sp+10
	ld	[hl], a
	ld	hl, sp+10
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00135
.l00137:
;src/fatfs/fatfs.c:167: return 0;
	xor	a, a
.l00138:
;src/fatfs/fatfs.c:168: }
	add	sp, 13
	ret
;src/fatfs/fatfs.c:171: static void HalveMarks(void) {
;	---------------------------------
	SECTION FRAGMENT "Page 8",ROMX,BANK[4]
	LOAD FRAGMENT "Page 8 RAM",SRAM,BANK[8]
; Function HalveMarks
; ---------------------------------
_HalveMarks:
	add	sp, -5
;src/fatfs/fatfs.c:173: for (i = 0; i < MARKS / 2; ++i) {
	ld	hl, sp+4
	ld	[hl], $00
.l00102:
;src/fatfs/fatfs.c:174: MARK(0)[i] = MARK(0)[i << 1];
	ld	hl, sp+4
	ld	c, [hl]
	ld	b, $00
	sla	c
	rl	b
	ld	hl, _buffer
	add	hl, bc
	inc	sp
	inc	sp
	push	hl
	ld	de, _buffer
	ld	l, c
;	spillPairReg hl
;	spillPairReg hl
	ld	h, b
;	spillPairReg hl
;	spillPairReg hl
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
	pop	de
	push	de
	ld	hl, sp+2
	ld	a, [hl]
	ld	[de], a
	inc	de
	inc	hl
	ld	a, [hl]
	ld	[de], a
;src/fatfs/fatfs.c:175: MARK(1)[i] = MARK(1)[i << 1];
	ld	hl, (_buffer + 256)
	add	hl, bc
	push	hl
	ld	a, l
	ld	hl, sp+4
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+3
	ld	[hl], a
	ld	de, _buffer + 256
	ld	l, c
	ld	h, b
	add	hl, hl
	add	hl, de
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	ld	hl, sp+2
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	ld	[hl], c
	inc	hl
	ld	[hl], b
;src/fatfs/fatfs.c:173: for (i = 0; i < MARKS / 2; ++i) {
	ld	hl, sp+4
	inc	[hl]
	ld	a, [hl]
	sub	a, $40
	jp	C, .l00102
;src/fatfs/fatfs.c:177: ++mark_shift;
	ld	hl, _mark_shift
	inc	[hl]
;src/fatfs/fatfs.c:178: mark_mask = mark_mask << 1 | 1;
	ld	hl, _mark_mask
	ld	a, [hl]
	inc	hl
	ld	c, [hl]
	add	a, a
	rl	c
	set	0, a
	dec	hl
	ld	[hl], a
	inc	hl
	ld	[hl], c
.l00104:
;src/fatfs/fatfs.c:179: }
	add	sp, 5
	ret
;src/fatfs/fatfs.c:181: static FRESULT List(const char* path, const char* find) {
;	---------------------------------
	SECTION FRAGMENT "Page 8",ROMX,BANK[4]
	LOAD FRAGMENT "Page 8 RAM",SRAM,BANK[8]
; Function List
; ---------------------------------
_List:
	add	sp, -7
	ld	hl, sp+5
	ld	[hl], c
	inc	hl
	ld	[hl], b
;src/fatfs/fatfs.c:182: WORD find_slot = 0xFFFF, n;
	ld	hl, sp+0
	ld	[hl], $FF
	inc	hl
	ld	[hl], $FF
;src/fatfs/fatfs.c:184: FRESULT result = f_opendir(&dir, path);
	ld	c, e
	ld	b, d
	ld	de, _dir
	call	_f_opendir
	ld	c, a
;src/fatfs/fatfs.c:185: if (result) return result;
	ld	a, c
	or	a, a
	jp	Z, .l00102
	ld	a, c
	jp	.l00118
.l00102:
;src/fatfs/fatfs.c:186: if (find && !create_name(&dir, &find) && !dir_find(&dir)) find_slot = (WORD)(dir.dptr >> 5);
	ld	hl, sp+6
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	jp	Z, .l00104
	ld	hl, sp+5
	ld	c, l
	ld	b, h
	ld	de, _dir
	call	_create_name__far
	or	a, a
	jp	NZ, .l00104
	ld	de, _dir
	call	_dir_find__far
	or	a, a
	jp	NZ, .l00104
	ld	hl, _dir + 14
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
	ld	e, l
	ld	d, h
	ld	a, $05
.l00177:
	srl	d
	rr	e
	rr	b
	rr	c
.l00178:
	dec	a
	jr	NZ, .l00177
	inc	sp
	inc	sp
	push	bc
.l00104:
;src/fatfs/fatfs.c:187: if ((result = Seek(0))) return result;
	ld	de, $0000
	call	_Seek
	ld	c, a
	or	a, a
	jp	Z, .l00108
	ld	a, c
	jp	.l00118
.l00108:
;src/fatfs/fatfs.c:188: list_counts[0] = list_counts[1] = 0;
	ld	hl, (_list_counts + 2)
	xor	a, a
	ld	[hl], a
	inc	hl
	ld	[hl], a
	ld	hl, _list_counts
	xor	a, a
	ld	[hl], a
	inc	hl
	ld	[hl], a
;src/fatfs/fatfs.c:189: read_kind = 0xFF;
	ld	hl, _read_kind
	ld	[hl], $FF
;src/fatfs/fatfs.c:190: mark_shift = 4;
	ld	hl, _mark_shift
	ld	[hl], $04
;src/fatfs/fatfs.c:191: mark_mask = 15;
	ld	hl, _mark_mask
	ld	[hl], $0F
	xor	a, a
	inc	hl
	ld	[hl], a
;src/fatfs/fatfs.c:192: list_error = FR_OK;
	ld	hl, _list_error
	ld	[hl], $00
;src/fatfs/fatfs.c:193: fs_found = 0xFFFF;
	ld	hl, _fs_found
	ld	[hl], $FF
	inc	hl
	ld	[hl], $FF
;src/fatfs/fatfs.c:194: while ((kind = NextEntry(0))) {
.l00115:
	xor	a, a
	call	_NextEntry
	ld	c, a
	ld	hl, sp+4
	ld	[hl], c
	ld	a, c
	or	a, a
	jp	Z, .l00117
;src/fatfs/fatfs.c:195: n = list_counts[--kind]++;
	ld	a, [hl]
	add	a, $FF
	dec	hl
	dec	hl
	ld	[hl], a
	ld	a, [hl]
	ld	b, $00
	add	a, a
	rl	b
	add	a, LOW(_list_counts)
	ld	c, a
	ld	a, b
	adc	a, HIGH(_list_counts)
	ld	b, a
	ld	e, c
	ld	d, b
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
	inc	de
	ld	a, e
	ld	[bc], a
	inc	bc
	ld	a, d
	ld	[bc], a
;src/fatfs/fatfs.c:196: if (list_slot == find_slot) fs_found = n; // a folder, so n is its index
	ld	hl, _list_slot
	ld	a, [hl]
	ld	hl, sp+0
	sub	a, [hl]
	jp	NZ,.l00180
	ld	hl, _list_slot + 1
	ld	a, [hl]
	ld	hl, sp+1
	sub	a, [hl]
	jp	NZ,.l00180
	jp	.l00181
.l00180:
	jp	.l00110
.l00181:
	ld	hl, sp+3
	ld	a, [hl]
	ld	hl, _fs_found
	ld	[hl], a
	ld	hl, sp+4
	ld	a, [hl]
	ld	hl, _fs_found + 1
	ld	[hl], a
.l00110:
;src/fatfs/fatfs.c:197: if (!(n & mark_mask)) {
	ld	hl, sp+3
	ld	a, [hl]
	ld	hl, _mark_mask
	and	a, [hl]
	ld	c, a
	ld	hl, sp+4
	ld	a, [hl]
	ld	hl, _mark_mask + 1
	and	a, [hl]
	ld	b, a
	ld	a, b
	or	a, c
	jp	NZ, .l00114
;src/fatfs/fatfs.c:198: if (n >> mark_shift == MARKS) HalveMarks();
	ld	hl, _mark_shift
	ld	a, [hl]
	push	af
	ld	hl, sp+5
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	pop	af
	inc	a
	jp	.l00183
.l00182:
	srl	b
	rr	c
.l00183:
	dec	a
	jr	NZ, .l00182
	ld	a, c
	sub	a, $80
	or	a, b
	jp	NZ,.l00184
	jp	.l00185
.l00184:
	jp	.l00112
.l00185:
	call	_HalveMarks
.l00112:
;src/fatfs/fatfs.c:199: MARK(kind)[n >> mark_shift] = list_start;
	ld	bc, _buffer
	ld	hl, sp+2
	ld	a, [hl]
	or	a, a
	jp	Z, .l00120
	ld	hl, $0080
	jp	.l00121
.l00120:
	ld	hl, $0000
.l00121:
	add	hl, hl
	add	hl, bc
	ld	c, l
	ld	b, h
	ld	hl, _mark_shift
	ld	a, [hl]
	push	af
	ld	hl, sp+5
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	pop	af
	inc	a
	jp	.l00187
.l00186:
	srl	d
	rr	e
.l00187:
	dec	a
	jr	NZ, .l00186
	ld	l, e
	ld	h, d
	add	hl, hl
	add	hl, bc
	ld	c, l
	ld	b, h
	ld	hl, _list_start
	ld	a, [hl]
	ld	[bc], a
	inc	bc
	inc	hl
	ld	a, [hl]
	ld	[bc], a
.l00114:
;src/fatfs/fatfs.c:201: NextSlot();
	call	_NextSlot
	jp	.l00115
.l00117:
;src/fatfs/fatfs.c:203: fs_count = list_counts[0] + list_counts[1];
	ld	hl, _list_counts + 0
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	ld	hl, (_list_counts + 2) + 0
	ld	a, [hl+]
	ld	h, [hl]
;	spillPairReg hl
	ld	l, a
;	spillPairReg hl
;	spillPairReg hl
	add	hl, bc
	ld	c, l
	ld	a, h
	ld	hl, _fs_count
	ld	[hl], c
	inc	hl
	ld	[hl], a
;src/fatfs/fatfs.c:204: return list_error;
	ld	hl, _list_error
	ld	a, [hl]
.l00118:
;src/fatfs/fatfs.c:205: }
	add	sp, 7
	ret
;src/fatfs/fatfs.c:209: unsigned char fs_List(const char* path, const char* find) {
;	---------------------------------
	SECTION FRAGMENT "Page 8",ROMX,BANK[4]
	LOAD FRAGMENT "Page 8 RAM",SRAM,BANK[8]
; Function fs_List
; ---------------------------------
_fs_List::
	ld	l, c
;	spillPairReg hl
;	spillPairReg hl
	ld	h, b
;	spillPairReg hl
;	spillPairReg hl
;src/fatfs/fatfs.c:210: FRESULT result = List(path, find);
	push	hl
	push	de
	ld	c, l
	ld	b, h
	call	_List
	pop	de
	pop	hl
;src/fatfs/fatfs.c:211: if (result == FR_DISK_ERR) result = List(path, find); // mounts the card again (it may have been swapped)
	cp	a, $01
	jp	NZ,.l00110
	jp	.l00111
.l00110:
	jp	.l00102
.l00111:
	ld	c, l
	ld	b, h
	call	_List
.l00102:
;src/fatfs/fatfs.c:212: return result;
.l00103:
;src/fatfs/fatfs.c:213: }
	ret
;src/fatfs/fatfs.c:218: static BYTE GetName(char* name) {
;	---------------------------------
	SECTION FRAGMENT "Page 8",ROMX,BANK[4]
	LOAD FRAGMENT "Page 8 RAM",SRAM,BANK[8]
; Function GetName
; ---------------------------------
_GetName:
	add	sp, -16
	ld	hl, sp+12
	ld	[hl], e
	inc	hl
	ld	[hl], d
;src/fatfs/fatfs.c:219: char* start = name;
	dec	hl
	ld	a, [hl]
	ld	hl, sp+0
	ld	[hl], a
	ld	hl, sp+13
	ld	a, [hl]
	ld	hl, sp+1
	ld	[hl], a
;src/fatfs/fatfs.c:220: char* end = name + FF_LFN_BUF;
	ld	hl, sp+13
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $0040
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+4
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+3
	ld	[hl], a
;src/fatfs/fatfs.c:221: WCHAR* lfn = fs.lfnbuf;
	ld	de, (_fs + 12) + 0
	ld	a, [de]
	ld	hl, sp+10
	ld	[hl], a
	inc	de
	ld	a, [de]
	inc	hl
	ld	[hl], a
;src/fatfs/fatfs.c:223: BYTE i, lower = NS_BODY;
	ld	hl, sp+14
	ld	[hl], $08
;src/fatfs/fatfs.c:224: if (dir.blk_ofs != 0xFFFFFFFF) {
	ld	hl, _dir + 40
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
	ld	a, c
	and	a, b
	and	a, l
	and	a, h
	inc	a
	jp	NZ,.l00226
	jp	.l00150
.l00226:
;src/fatfs/fatfs.c:225: while ((c = *lfn++)) {
	ld	hl, sp+10
	ld	a, [hl]
	ld	hl, sp+14
	ld	[hl], a
	ld	hl, sp+11
	ld	a, [hl]
	ld	hl, sp+15
	ld	[hl], a
.l00115:
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
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $0002
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+16
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+15
	ld	[hl], a
	ld	hl, sp+4
	ld	[hl], c
	inc	hl
	ld	[hl], b
	ld	a, b
	or	a, c
	jp	Z, .l00133
;src/fatfs/fatfs.c:226: if (c < 0x80) {
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
;src/fatfs/fatfs.c:228: *name++ = (char)c;
	ld	hl, sp+13
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $0001
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+10
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+9
	ld	[hl], a
;src/fatfs/fatfs.c:226: if (c < 0x80) {
	ld	hl, sp+6
	ld	a, [hl]
	sub	a, $80
	inc	hl
	ld	a, [hl]
	sbc	a, $00
	jp	NC, .l00113
;src/fatfs/fatfs.c:227: if (name == end) return 0;
	ld	hl, sp+12
	ld	a, [hl]
	ld	hl, sp+2
	sub	a, [hl]
	jp	NZ,.l00227
	ld	hl, sp+13
	ld	a, [hl]
	ld	hl, sp+3
	sub	a, [hl]
	jp	NZ,.l00227
	jp	.l00228
.l00227:
	jp	.l00102
.l00228:
	xor	a, a
	jp	.l00135
.l00102:
;src/fatfs/fatfs.c:228: *name++ = (char)c;
	ld	hl, sp+4
	ld	c, [hl]
	ld	hl, sp+12
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	ld	[hl], c
	ld	hl, sp+8
	ld	a, [hl]
	ld	hl, sp+12
	ld	[hl], a
	ld	hl, sp+9
	ld	a, [hl]
	ld	hl, sp+13
	ld	[hl], a
	jp	.l00115
.l00113:
;src/fatfs/fatfs.c:231: if (end - name < 2) return 0;
	ld	hl, sp+3
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, sp+12
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	ld	a, e
	sub	a, l
	ld	e, a
	ld	a, d
	sbc	a, h
	ld	b, a
	ld	c, e
;src/fatfs/fatfs.c:232: *name++ = (char)(0xC0 | (c >> 6));
	ld	hl, sp+5
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, $06
.l00229:
	srl	d
	rr	e
	dec	a
	jp	NZ, .l00229
;src/fatfs/fatfs.c:233: *name++ = (char)(0x80 | (c & 0x3F));
	dec	hl
	ld	a, [hl]
;src/fatfs/fatfs.c:232: *name++ = (char)(0xC0 | (c >> 6));
	ld	hl, sp+10
	ld	[hl], e
;src/fatfs/fatfs.c:233: *name++ = (char)(0x80 | (c & 0x3F));
	and	a, $3F
	or	a, $80
	inc	hl
	ld	[hl], a
;src/fatfs/fatfs.c:230: else if (c < 0x800) {
	ld	hl, sp+6
	ld	a, [hl]
	sub	a, $00
	inc	hl
	ld	a, [hl]
	sbc	a, $08
	jp	NC, .l00110
;src/fatfs/fatfs.c:231: if (end - name < 2) return 0;
	ld	a, c
	sub	a, $02
	ld	a, b
	rla
	ccf
	rra
	sbc	a, $80
	jp	NC, .l00104
	xor	a, a
	jp	.l00135
.l00104:
;src/fatfs/fatfs.c:232: *name++ = (char)(0xC0 | (c >> 6));
	ld	hl, sp+10
	ld	a, [hl]
	or	a, $C0
	inc	hl
	inc	hl
	push	af
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	pop	af
	ld	[hl], a
	ld	hl, sp+8
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
;src/fatfs/fatfs.c:233: *name++ = (char)(0x80 | (c & 0x3F));
	inc	hl
	inc	hl
	ld	a, [hl]
	ld	[bc], a
	inc	bc
	inc	hl
	ld	[hl], c
	inc	hl
	ld	[hl], b
	jp	.l00115
.l00110:
;src/fatfs/fatfs.c:236: if (IsSurrogate(c) || end - name < 3) return 0;
	ld	hl, sp+6
	ld	a, [hl]
	sub	a, $00
	inc	hl
	ld	a, [hl]
	sbc	a, $D8
	jp	C, .l00108
	dec	hl
	ld	a, $FF
	sub	a, [hl]
	inc	hl
	ld	a, $DF
	sbc	a, [hl]
	jp	NC, .l00105
.l00108:
	ld	a, c
	sub	a, $03
	ld	a, b
	rla
	ccf
	rra
	sbc	a, $80
	jp	NC, .l00106
.l00105:
	xor	a, a
	jp	.l00135
.l00106:
;src/fatfs/fatfs.c:237: *name++ = (char)(0xE0 | (c >> 12));
	ld	hl, sp+5
	ld	a, [hl]
	swap	a
	and	a, $0F
	ld	c, a
	ld	b, $00
	ld	a, c
	or	a, $E0
	ld	c, a
	ld	hl, sp+12
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	ld	[hl], c
	ld	hl, sp+8
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
;src/fatfs/fatfs.c:238: *name++ = (char)(0x80 | ((c >> 6) & 0x3F));
	inc	hl
	ld	a, [hl]
	and	a, $3F
	set	7, a
	ld	[bc], a
	inc	bc
;src/fatfs/fatfs.c:239: *name++ = (char)(0x80 | (c & 0x3F));
	inc	hl
	ld	a, [hl]
	ld	[bc], a
	inc	bc
	inc	hl
	ld	[hl], c
	inc	hl
	ld	[hl], b
	jp	.l00115
;src/fatfs/fatfs.c:244: for (i = 0; i < 11; ++i) {
.l00150:
	ld	hl, sp+15
	ld	[hl], $00
.l00134:
;src/fatfs/fatfs.c:245: c = dir.dir[i];
	ld	hl, (_dir + 26) + 0
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	ld	hl, sp+15
	ld	l, [hl]
	ld	h, $00
	add	hl, bc
	ld	c, l
	ld	b, h
	ld	a, [bc]
	ld	hl, sp+8
	ld	[hl], a
	inc	hl
	ld	[hl], $00
;src/fatfs/fatfs.c:226: if (c < 0x80) {
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
;src/fatfs/fatfs.c:246: if (c == ' ') continue;
	dec	hl
	ld	a, [hl]
	sub	a, $20
	inc	hl
	or	a, [hl]
	jp	NZ,.l00230
	jp	.l00129
.l00230:
;src/fatfs/fatfs.c:247: if (c >= 0x80 || c == RDDEM) return 0;
	ld	hl, sp+10
	ld	a, [hl]
	sub	a, $80
	inc	hl
	ld	a, [hl]
	sbc	a, $00
	jp	NC, .l00120
	dec	hl
	ld	a, [hl]
	sub	a, $05
	inc	hl
	or	a, [hl]
	jp	NZ,.l00231
	jp	.l00232
.l00231:
	jp	.l00121
.l00232:
.l00120:
	xor	a, a
	jp	.l00135
.l00121:
;src/fatfs/fatfs.c:248: if (i == 8) {
	ld	hl, sp+15
	ld	a, [hl]
	sub	a, $08
	jp	NZ,.l00233
	jp	.l00234
.l00233:
	jp	.l00124
.l00234:
;src/fatfs/fatfs.c:249: *name++ = '.';
	ld	hl, sp+12
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	ld	[hl], $2E
	ld	hl, sp+12
	inc	[hl]
	jp	NZ, .l00235
	inc	hl
	inc	[hl]
.l00235:
;src/fatfs/fatfs.c:250: lower = NS_EXT;
	ld	hl, sp+14
	ld	[hl], $10
.l00124:
;src/fatfs/fatfs.c:252: if (IsUpper(c) && (dir.dir[DIR_NTres] & lower)) c += 0x20;
	ld	hl, sp+10
	ld	a, [hl]
	sub	a, $41
	inc	hl
	ld	a, [hl]
	sbc	a, $00
	jp	C, .l00126
	dec	hl
	ld	a, $5A
	sub	a, [hl]
	inc	hl
	ld	a, $00
	sbc	a, [hl]
	jp	C, .l00126
	ld	hl, (_dir + 26) + 0
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	ld	hl, $000C
	add	hl, bc
	ld	a, [hl]
	ld	hl, sp+14
	and	a, [hl]
	or	a, a
	jp	Z, .l00126
	ld	hl, sp+11
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $0020
	add	hl, de
	ld	c, l
	ld	a, h
	ld	hl, sp+8
	ld	[hl], c
	inc	hl
	ld	[hl], a
.l00126:
;src/fatfs/fatfs.c:253: *name++ = (char)c;
	ld	hl, sp+8
	ld	c, [hl]
	ld	hl, sp+12
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	ld	[hl], c
	ld	hl, sp+12
	inc	[hl]
	jp	NZ, .l00236
	inc	hl
	inc	[hl]
.l00236:
.l00129:
;src/fatfs/fatfs.c:244: for (i = 0; i < 11; ++i) {
	ld	hl, sp+15
	inc	[hl]
	ld	a, [hl]
	sub	a, $0B
	jp	C, .l00134
.l00133:
;src/fatfs/fatfs.c:256: *name = 0;
	ld	hl, sp+12
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	ld	[hl], $00
;src/fatfs/fatfs.c:257: return name != start;
	ld	hl, sp+12
	ld	a, [hl]
	ld	hl, sp+0
	sub	a, [hl]
	jp	NZ,.l00237
	ld	hl, sp+13
	ld	a, [hl]
	ld	hl, sp+1
	sub	a, [hl]
	jp	NZ,.l00237
	ld	a,$01
	jp	.l00238
.l00237:
	xor	a,a
.l00238:
	xor	a, $01
.l00135:
;src/fatfs/fatfs.c:258: }
	add	sp, 16
	ret
;src/fatfs/fatfs.c:261: unsigned char fs_ListEntry(unsigned int index, FileEntry* entry) {
;	---------------------------------
	SECTION FRAGMENT "Page 8",ROMX,BANK[4]
	LOAD FRAGMENT "Page 8 RAM",SRAM,BANK[8]
; Function fs_ListEntry
; ---------------------------------
_fs_ListEntry::
	add	sp, -13
	ld	hl, sp+11
	ld	[hl], e
	inc	hl
	ld	[hl], d
	ld	hl, sp+9
	ld	[hl], c
	inc	hl
	ld	[hl], b
;src/fatfs/fatfs.c:262: BYTE kind = index >= list_counts[0], found;
	ld	de, _list_counts + 0
	ld	a, [de]
	ld	hl, sp+3
	ld	[hl], a
	inc	de
	ld	a, [de]
	inc	hl
	ld	[hl], a
	ld	hl, sp+11
	ld	a, [hl]
	ld	hl, sp+5
	ld	[hl], a
	ld	hl, sp+12
	ld	a, [hl]
	ld	hl, sp+6
	ld	[hl], a
	ld	hl, sp+5
	ld	e, l
	ld	d, h
	ld	hl, sp+3
	ld	a, [de]
	inc	de
	sub	a, [hl]
	inc	hl
	ld	a, [de]
	sbc	a, [hl]
	ld	a, $00
	rla
	xor	a, $01
	ld	hl, sp+0
	ld	[hl], a
;src/fatfs/fatfs.c:264: if (!fs.fs_type || dir.obj.id != fs.id || index >= fs_count) return FR_INVALID_OBJECT;
	ld	hl, _fs + 0
	ld	a, [hl]
	ld	hl, sp+8
	ld	[hl], a
	ld	hl, sp+8
	ld	a, [hl]
	or	a, a
	jp	Z, .l00101
	ld	de, (_dir + 2) + 0
	ld	a, [de]
	dec	hl
	ld	[hl], a
	inc	de
	ld	a, [de]
	inc	hl
	ld	[hl], a
	ld	hl, (_fs + 6) + 0
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	ld	hl, sp+7
	ld	a, [hl]
	sub	a, c
	jp	NZ,.l00194
	inc	hl
	ld	a, [hl]
	sub	a, b
	jp	NZ,.l00194
	jp	.l00195
.l00194:
	jp	.l00101
.l00195:
	ld	hl, sp+11
	ld	e, l
	ld	d, h
	ld	hl, _fs_count
	ld	a, [de]
	inc	de
	sub	a, [hl]
	inc	hl
	ld	a, [de]
	sbc	a, [hl]
	jp	C, .l00102
.l00101:
	ld	a, $09
	jp	.l00123
.l00102:
;src/fatfs/fatfs.c:265: if (kind) index -= list_counts[0];
	ld	hl, sp+0
	ld	a, [hl]
	or	a, a
	jp	Z, .l00106
	ld	hl, sp+6
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, sp+3
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	ld	a, e
	sub	a, l
	ld	e, a
	ld	a, d
	sbc	a, h
	ld	c, e
	ld	hl, sp+11
	ld	[hl], c
	inc	hl
	ld	[hl], a
.l00106:
;src/fatfs/fatfs.c:262: BYTE kind = index >= list_counts[0], found;
	ld	hl, sp+11
	ld	a, [hl]
	ld	hl, sp+1
	ld	[hl], a
	ld	hl, sp+12
	ld	a, [hl]
	ld	hl, sp+2
	ld	[hl], a
;src/fatfs/fatfs.c:266: if (kind != read_kind || index < read_next || (index ^ read_next) > mark_mask) { // from the mark before it
	dec	hl
	dec	hl
	ld	a, [hl]
	ld	hl, _read_kind
	sub	a, [hl]
	jp	NZ,.l00196
	jp	.l00197
.l00196:
	jp	.l00109
.l00197:
	ld	hl, sp+1
	ld	e, l
	ld	d, h
	ld	hl, _read_next
	ld	a, [de]
	inc	de
	sub	a, [hl]
	inc	hl
	ld	a, [de]
	sbc	a, [hl]
	jp	C, .l00109
	ld	hl, sp+1
	ld	a, [hl]
	ld	hl, _read_next
	xor	a, [hl]
	ld	c, a
	ld	hl, sp+2
	ld	a, [hl]
	ld	hl, _read_next + 1
	xor	a, [hl]
	ld	b, a
	ld	hl, _mark_mask
	ld	a, [hl]
	sub	a, c
	inc	hl
	ld	a, [hl]
	sbc	a, b
	jp	NC, .l00110
.l00109:
;src/fatfs/fatfs.c:267: if ((result = Seek(MARK(kind)[index >> mark_shift]))) return result;
	ld	hl, sp+0
	ld	a, [hl]
	or	a, a
	jp	Z, .l00125
	ld	hl, sp+7
	ld	[hl], $80
	xor	a, a
	inc	hl
	ld	[hl], a
	jp	.l00126
.l00125:
	xor	a, a
	ld	hl, sp+7
	ld	[hl], a
	inc	hl
	ld	[hl], a
.l00126:
	ld	hl, sp+7
	sla	[hl]
	inc	hl
	rl	[hl]
	ld	de, _buffer
	dec	hl
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+5
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+4
	ld	[hl], a
	ld	hl, _mark_shift
	ld	a, [hl]
	push	af
	ld	hl, sp+13
	ld	a, [hl]
	ld	hl, sp+9
	ld	[hl], a
	ld	hl, sp+14
	ld	a, [hl]
	ld	hl, sp+10
	ld	[hl], a
	pop	af
	inc	a
	jp	.l00200
.l00199:
	ld	hl, sp+8
	srl	[hl]
	dec	hl
	rr	[hl]
.l00200:
	dec	a
	jr	NZ, .l00199
	ld	hl, sp+7
	ld	a, [hl]
	dec	hl
	dec	hl
	ld	[hl], a
	ld	hl, sp+8
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
	ld	hl, sp+3
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
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
	ld	a, [de]
	dec	hl
	ld	[hl], a
	inc	de
	ld	a, [de]
	inc	hl
	ld	[hl], a
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_Seek
	ld	hl, sp+8
	ld	[hl], a
	ld	hl, sp+8
	ld	c, [hl]
	ld	a, [hl]
	or	a, a
	jp	Z, .l00108
	ld	a, c
	jp	.l00123
.l00108:
;src/fatfs/fatfs.c:268: read_kind = kind;
	ld	hl, sp+0
	ld	a, [hl]
	ld	hl, _read_kind
	ld	[hl], a
;src/fatfs/fatfs.c:269: read_next = index & ~mark_mask;
	ld	hl, _mark_mask
	ld	a, [hl]
	cpl
	ld	c, a
	inc	hl
	ld	a, [hl]
	cpl
	ld	b, a
	ld	hl, sp+1
	ld	a, [hl]
	and	a, c
	ld	hl, _read_next
	ld	[hl], a
	ld	hl, sp+2
	ld	a, [hl]
	and	a, b
	ld	hl, _read_next + 1
	ld	[hl], a
.l00110:
;src/fatfs/fatfs.c:271: list_error = FR_OK;
	ld	hl, _list_error
	ld	[hl], $00
;src/fatfs/fatfs.c:272: while ((found = NextEntry(read_next == index))) {
.l00116:
	ld	hl, _read_next
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	ld	hl, sp+11
	ld	a, [hl]
	sub	a, c
	jp	NZ,.l00202
	inc	hl
	ld	a, [hl]
	sub	a, b
	jp	NZ,.l00202
	ld	a,$01
	jp	.l00203
.l00202:
	xor	a,a
.l00203:
	ld	c, a
	ld	a, c
	call	_NextEntry
	ld	c, a
	or	a, a
	jp	Z, .l00118
;src/fatfs/fatfs.c:273: if (found - 1 == kind && read_next++ == index) break;
	ld	e, c
	ld	d, $00
	dec	de
	ld	hl, sp+0
	ld	a, [hl]
	ld	hl, sp+7
	ld	[hl], a
	inc	hl
	ld	[hl], $00
	dec	hl
	ld	a, [hl]
	sub	a, e
	jp	NZ,.l00204
	inc	hl
	ld	a, [hl]
	sub	a, d
	jp	NZ,.l00204
	jp	.l00205
.l00204:
	jp	.l00114
.l00205:
	ld	hl, _read_next
	ld	b, [hl]
	inc	hl
	ld	d, [hl]
	dec	hl
	inc	[hl]
	jp	NZ, .l00206
	inc	hl
	inc	[hl]
.l00206:
	ld	hl, sp+11
	ld	a, [hl]
	sub	a, b
	jp	NZ,.l00207
	inc	hl
	ld	a, [hl]
	sub	a, d
	jp	NZ,.l00207
	jp	.l00118
.l00207:
.l00114:
;src/fatfs/fatfs.c:274: NextSlot();
	call	_NextSlot
	jp	.l00116
.l00118:
;src/fatfs/fatfs.c:276: if (!found) {
	ld	a, c
	or	a, a
	jp	NZ, .l00120
;src/fatfs/fatfs.c:277: read_kind = 0xFF;
	ld	hl, _read_kind
	ld	[hl], $FF
;src/fatfs/fatfs.c:278: return list_error ? list_error : FR_NO_FILE; // the folder changed
	ld	hl, _list_error
	ld	a, [hl]
	or	a, a
	jp	Z, .l00127
	ld	a, [hl]
	ld	hl, sp+8
	ld	[hl], a
	jp	.l00128
.l00127:
	ld	hl, sp+8
	ld	[hl], $04
.l00128:
	ld	hl, sp+8
	ld	a, [hl]
	jp	.l00123
.l00120:
;src/fatfs/fatfs.c:280: if (!GetName(entry->name)) {
	ld	hl, sp+9
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_GetName
	ld	hl, sp+8
	ld	[hl], a
	ld	hl, sp+8
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00122
;src/fatfs/fatfs.c:281: get_fileinfo(&dir, &info);
	ld	bc, _info
	ld	de, _dir
	call	_get_fileinfo__far
;src/fatfs/fatfs.c:282: memcpy(entry->name, info.fname, FS_NAME_SIZE);
	ld	hl, sp+9
	ld	a, [hl]
	dec	hl
	dec	hl
	ld	[hl], a
	ld	hl, sp+10
	ld	a, [hl]
	dec	hl
	dec	hl
	ld	[hl], a
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	bc, $0041
	push	bc
	ld	bc, (_info + 22)
	call	___memcpy
.l00122:
;src/fatfs/fatfs.c:284: entry->size = ld_32(dir.dir + DIR_FileSize);
	ld	hl, sp+10
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $0041
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+5
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+4
	ld	[hl], a
	ld	de, (_dir + 26) + 0
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
	ld	hl, $001C
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
	call	_ld_32
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
;src/fatfs/fatfs.c:285: entry->time = ld_16(dir.dir + DIR_ModTime);
	inc	hl
	inc	hl
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $0047
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+7
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+6
	ld	[hl], a
	ld	de, (_dir + 26) + 0
	ld	a, [de]
	ld	hl, sp+3
	ld	[hl], a
	inc	de
	ld	a, [de]
	inc	hl
	ld	[hl], a
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
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_ld_16
	ld	hl, sp+7
	ld	[hl], c
	inc	hl
	ld	[hl], b
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
;src/fatfs/fatfs.c:286: entry->date = ld_16(dir.dir + DIR_ModTime + 2);
	inc	hl
	inc	hl
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $0045
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+7
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+6
	ld	[hl], a
	ld	de, (_dir + 26) + 0
	ld	a, [de]
	ld	hl, sp+3
	ld	[hl], a
	inc	de
	ld	a, [de]
	inc	hl
	ld	[hl], a
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $0018
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
	call	_ld_16
	ld	hl, sp+7
	ld	[hl], c
	inc	hl
	ld	[hl], b
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
;src/fatfs/fatfs.c:287: entry->dir = kind == 0;
	inc	hl
	inc	hl
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $0049
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+9
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+8
	ld	[hl], a
	ld	hl, sp+0
	ld	a, [hl]
	or	a, a
	jp	NZ,.l00208
	ld	a,$01
	jp	.l00209
.l00208:
	xor	a,a
.l00209:
	ld	c, a
	ld	hl, sp+7
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	ld	[hl], c
;src/fatfs/fatfs.c:288: NextSlot();
	call	_NextSlot
;src/fatfs/fatfs.c:289: return FR_OK;
	xor	a, a
.l00123:
;src/fatfs/fatfs.c:290: }
	add	sp, 13
	ret
;src/fatfs/fatfs.c:293: static FRESULT Open(const char* path, BYTE mode) {
;	---------------------------------
	SECTION FRAGMENT "Page 8",ROMX,BANK[4]
	LOAD FRAGMENT "Page 8 RAM",SRAM,BANK[8]
; Function Open
; ---------------------------------
_Open:
	dec	sp
	ld	hl, sp+0
	ld	[hl], a
;src/fatfs/fatfs.c:294: FRESULT result = f_open(&file, path, mode);
	push	de
	ld	a, [hl]
	push	af
	inc	sp
	ld	c, e
	ld	b, d
	ld	de, _file
	call	_f_open__far
	pop	de
;src/fatfs/fatfs.c:295: return result == FR_DISK_ERR ? f_open(&file, path, mode) : result;
	cp	a, $01
	jp	NZ,.l00110
	jp	.l00111
.l00110:
	jp	.l00103
.l00111:
	ld	hl, sp+0
	ld	a, [hl]
	push	af
	inc	sp
	ld	c, e
	ld	b, d
	ld	de, _file
	call	_f_open__far
	jp	.l00104
.l00103:
.l00104:
.l00101:
;src/fatfs/fatfs.c:296: }
	inc	sp
	ret
;src/fatfs/fatfs.c:299: unsigned char fs_Load(const char* path) {
;	---------------------------------
	SECTION FRAGMENT "Page 8",ROMX,BANK[4]
	LOAD FRAGMENT "Page 8 RAM",SRAM,BANK[8]
; Function fs_Load
; ---------------------------------
_fs_Load::
	dec	sp
	dec	sp
;src/fatfs/fatfs.c:301: FRESULT result = Open(path, FA_READ);
	ld	a, $01
	call	_Open
;src/fatfs/fatfs.c:302: if (result) return result;
	or	a, a
	jp	Z, .l00102
	jp	.l00110
.l00102:
;src/fatfs/fatfs.c:303: tb_Clear();
	call	_tb_Clear
;src/fatfs/fatfs.c:304: tb_cr = 0;
	ld	hl, _tb_cr
	ld	[hl], $00
;src/fatfs/fatfs.c:305: do {
.l00107:
;src/fatfs/fatfs.c:306: result = f_read(&file, buffer, FS_BUFFER_SIZE, &count);
	ld	hl, 0
	add	hl, sp
	ld	e, l
	ld	d, h
	push	de
	ld	de, $0200
	push	de
	ld	bc, _buffer
	ld	de, _file
	call	_f_read__far
	ld	e, a
;src/fatfs/fatfs.c:307: if (result) break;
	ld	a, e
	or	a, a
	jp	NZ, .l00109
;src/fatfs/fatfs.c:308: if (!tb_Append(buffer, count)) {
	push	de
	pop	hl
	pop	bc
	push	bc
	push	hl
	ld	de, _buffer
	call	_tb_Append
	pop	de
	or	a, a
	jp	NZ, .l00108
;src/fatfs/fatfs.c:309: result = FR_DENIED;
	ld	e, $07
;src/fatfs/fatfs.c:310: break;
	jp	.l00109
.l00108:
;src/fatfs/fatfs.c:312: } while (count == FS_BUFFER_SIZE);
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
;src/fatfs/fatfs.c:313: fs_crlf = tb_cr;
	ld	hl, _tb_cr
	ld	a, [hl]
	ld	hl, _fs_crlf
	ld	[hl], a
;src/fatfs/fatfs.c:314: f_close(&file);
	push	de
	ld	de, _file
	call	_f_close__far
	pop	de
;src/fatfs/fatfs.c:315: return result;
	ld	a, e
.l00110:
;src/fatfs/fatfs.c:316: }
	inc	sp
	inc	sp
	ret
;src/fatfs/fatfs.c:323: unsigned char fs_LoadData(const char* path) {
;	---------------------------------
	SECTION FRAGMENT "Page 8",ROMX,BANK[4]
	LOAD FRAGMENT "Page 8 RAM",SRAM,BANK[8]
; Function fs_LoadData
; ---------------------------------
_fs_LoadData::
	add	sp, -6
;src/fatfs/fatfs.c:326: FRESULT result = fs_Mount();
	push	de
	call	_fs_Mount
	pop	de
	ld	c, a
;src/fatfs/fatfs.c:327: if (!result) result = Open(path, FA_READ);
	ld	a, c
	or	a, a
	jp	NZ, .l00102
	ld	a, $01
	call	_Open
	ld	c, a
.l00102:
;src/fatfs/fatfs.c:328: if (result) return result;
	ld	a, c
	or	a, a
	jp	Z, .l00104
	ld	a, c
	jp	.l00115
.l00104:
;src/fatfs/fatfs.c:329: if (f_size(&file) != DATA_BLOCKS * 512UL) result = FR_INVALID_OBJECT;
	ld	de, (_file + 10) + 0
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
	ld	a, [hl]
	or	a, a
	jp	NZ,.l00158
	inc	hl
	ld	a, [hl]
	sub	a, $82
	inc	hl
	or	a, [hl]
	inc	hl
	or	a, [hl]
	jp	NZ,.l00158
	jp	.l00122
.l00158:
	ld	c, $09
;src/fatfs/fatfs.c:330: while (!result && block != DATA_BLOCK + DATA_BLOCKS) {
.l00122:
	ld	de, $0200
.l00108:
	ld	a, c
	or	a, a
	jp	NZ, .l00110
	ld	a, e
	sub	a, $41
	jp	NZ,.l00159
	ld	a, d
	sub	a, $02
	jp	NZ,.l00159
	jp	.l00110
.l00159:
;src/fatfs/fatfs.c:331: SetWindowBlock(block++);
	ld	c, e
	ld	b, d
	inc	de
	push	de
	ld	e, c
	ld	d, b
	call	_SetWindowBlock
	pop	de
;src/fatfs/fatfs.c:332: result = f_read(&file, WINDOW, 512, &count);
	ld	hl, sp+0
	ld	c, l
	ld	b, h
	push	de
	push	bc
	ld	bc, $0200
	push	bc
	ld	bc, $BE00
	ld	de, _file
	call	_f_read__far
	pop	de
	ld	c, a
	jp	.l00108
.l00110:
;src/fatfs/fatfs.c:334: f_close(&file);
	push	bc
	ld	de, _file
	call	_f_close__far
	pop	bc
;src/fatfs/fatfs.c:335: SetWindowBlock(DATA_BLOCK);
	push	bc
	ld	de, $0200
	call	_SetWindowBlock
	pop	bc
;src/fatfs/fatfs.c:336: if (!result && (memcmp(WINDOW, "EDITOR.DAT", 10) || WINDOW[10] != DATA_VERSION)) result = FR_INVALID_OBJECT;
	ld	a, c
	or	a, a
	jp	NZ, .l00112
	push	bc
	ld	de, $000A
	push	de
	ld	bc, ___src_fatfs_fatfs_c_str_4
	ld	de, $BE00
	call	_memcmp
	ld	e, c
	ld	d, b
	pop	bc
	ld	a, d
	or	a, e
	jp	NZ, .l00111
	ld	a, [$BE0A]
	dec	a
	jp	NZ,.l00160
	jp	.l00112
.l00160:
.l00111:
	ld	c, $09
.l00112:
;src/fatfs/fatfs.c:337: SetWindowBlock(TB_PSRAM_HIGH << 8);
	push	bc
	ld	de, $0100
	call	_SetWindowBlock
	pop	bc
;src/fatfs/fatfs.c:338: return result;
	ld	a, c
.l00115:
;src/fatfs/fatfs.c:339: }
	add	sp, 6
	ret
	SECTION FRAGMENT "src/fatfs/fatfs.c ROM0",ROM0
___src_fatfs_fatfs_c_str_4:
	DB "EDITOR.DAT"
	DB $00
;src/fatfs/fatfs.c:373: static void Signature(const char* signature) {
;	---------------------------------
	SECTION FRAGMENT "Page 13",ROMX,BANK[6]
	LOAD FRAGMENT "Page 13 RAM",SRAM,BANK[13]
; Function Signature
; ---------------------------------
_Signature:
	ld	c, e
	ld	b, d
;src/fatfs/fatfs.c:374: SetWindowBlock((TB_PSRAM_HIGH << 8) | MAIN_SRAM_BANK);
	push	bc
	ld	de, $01F0
	call	_SetWindowBlock
	pop	bc
;src/fatfs/fatfs.c:375: if (signature) memcpy(WINDOW, signature, 4);
	ld	a, b
	or	a, c
	jp	Z, .l00102
	ld	de, $0004
	push	de
	ld	de, $BE00
	call	___memcpy
	jp	.l00103
.l00102:
;src/fatfs/fatfs.c:376: else memset(WINDOW, 0, 4);
	ld	de, $0004
	push	de
	ld	bc, $0000
	ld	de, $BE00
	call	_memset
.l00103:
;src/fatfs/fatfs.c:377: SetWindowBlock(TB_PSRAM_HIGH << 8);
	ld	de, $0100
	jp	_SetWindowBlock
.l00104:
;src/fatfs/fatfs.c:378: }
	ret
;src/fatfs/fatfs.c:381: static void AddCopy(BYTE* data, unsigned long pos, UINT count, BYTE write) {
;	---------------------------------
	SECTION FRAGMENT "Page 14",ROMX,BANK[7]
	LOAD FRAGMENT "Page 14 RAM",SRAM,BANK[14]
; Function AddCopy
; ---------------------------------
_AddCopy:
	add	sp, -10
	ld	hl, sp+8
	ld	[hl], e
	inc	hl
	ld	[hl], d
;src/fatfs/fatfs.c:383: while (count) {
.l00106:
	ld	hl, sp+17
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	jp	Z, .l00108
;src/fatfs/fatfs.c:384: at = (UINT)pos & 511;
	ld	hl, sp+12
	ld	a, [hl]
	ld	hl, sp+6
	ld	[hl], a
	ld	hl, sp+13
	ld	a, [hl]
	ld	hl, sp+7
	ld	[hl], a
	dec	hl
	ld	a, [hl]
	ld	hl, sp+2
	ld	[hl], a
	ld	hl, sp+7
	ld	a, [hl]
	and	a, $01
	ld	hl, sp+3
	ld	[hl], a
;src/fatfs/fatfs.c:385: size = 512 - at;
	ld	de, $0200
	dec	hl
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	ld	a, e
	sub	a, l
	ld	e, a
	ld	a, d
	sbc	a, h
	ld	hl, sp+5
	ld	[hl], a
	dec	hl
	ld	[hl], e
;src/fatfs/fatfs.c:386: if (size > count) size = count;
	ld	hl, sp+16
	ld	e, l
	ld	d, h
	ld	hl, sp+4
	ld	a, [de]
	inc	de
	sub	a, [hl]
	inc	hl
	ld	a, [de]
	sbc	a, [hl]
	jp	NC, .l00102
	ld	hl, sp+16
	ld	a, [hl]
	ld	hl, sp+4
	ld	[hl], a
	ld	hl, sp+17
	ld	a, [hl]
	ld	hl, sp+5
	ld	[hl], a
.l00102:
;src/fatfs/fatfs.c:387: SetWindowBlock(ADD_BLOCK + (UINT)(pos >> 9));
	ld	hl, sp+13
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	inc	hl
	ld	c, [hl]
	ld	b, $00
	srl	c
	rr	d
	rr	e
	ld	c, d
	ld	a, c
	add	a, $04
	ld	d, a
	call	_SetWindowBlock
;src/fatfs/fatfs.c:388: if (write) memcpy(WINDOW + at, data, size);
	ld	hl, sp+8
	ld	a, [hl]
	dec	hl
	dec	hl
	ld	[hl], a
	ld	hl, sp+9
	ld	a, [hl]
	dec	hl
	dec	hl
	ld	[hl], a
	ld	hl, sp+3
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $BE00
	add	hl, de
	ld	e, l
	ld	d, h
	ld	hl, sp+18
	ld	a, [hl]
	or	a, a
	jp	Z, .l00104
	ld	hl, sp+4
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	push	bc
	inc	hl
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	call	___memcpy
	jp	.l00105
.l00104:
;src/fatfs/fatfs.c:389: else memcpy(data, WINDOW + at, size);
	ld	hl, sp+4
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	push	bc
	ld	c, e
	ld	b, d
	inc	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	___memcpy
.l00105:
;src/fatfs/fatfs.c:390: data += size;
	ld	hl, sp+5
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, sp+8
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
;src/fatfs/fatfs.c:391: pos += size;
	ld	hl, sp+4
	ld	a, [hl]
	ld	hl, sp+0
	ld	[hl], a
	ld	hl, sp+5
	ld	a, [hl]
	ld	hl, sp+1
	ld	[hl], a
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
	ld	hl, sp+15
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
	ld	hl, sp+15
	ld	[hl], a
	dec	hl
	ld	[hl], e
;src/fatfs/fatfs.c:392: count -= size;
	ld	hl, sp+17
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, sp+4
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	ld	a, e
	sub	a, l
	ld	e, a
	ld	a, d
	sbc	a, h
	ld	hl, sp+17
	ld	[hl], a
	dec	hl
	ld	[hl], e
	jp	.l00106
.l00108:
;src/fatfs/fatfs.c:394: SetWindowBlock(TB_PSRAM_HIGH << 8);
	ld	de, $0100
	call	_SetWindowBlock
.l00109:
;src/fatfs/fatfs.c:395: }
	add	sp, 10
	pop	hl
	add	sp, 7
	jp hl
;src/fatfs/fatfs.c:398: static Piece* DocPiece(unsigned long pos) {
;	---------------------------------
	SECTION FRAGMENT "Page 14",ROMX,BANK[7]
	LOAD FRAGMENT "Page 14 RAM",SRAM,BANK[14]
; Function DocPiece
; ---------------------------------
_DocPiece:
	add	sp, -12
	ld	hl, sp+8
	ld	[hl], c
	inc	hl
	ld	[hl], b
	inc	hl
	ld	[hl], e
	inc	hl
	ld	[hl], d
;src/fatfs/fatfs.c:399: if (pos < piece_start) {
	ld	hl, sp+8
	ld	e, l
	ld	d, h
	ld	hl, _piece_start
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
	jp	NC, .l00104
;src/fatfs/fatfs.c:400: piece_i = 0;
	ld	hl, _piece_i
	ld	[hl], $00
;src/fatfs/fatfs.c:401: piece_start = 0;
	xor	a, a
	ld	hl, _piece_start
	ld	[hl], a
	inc	hl
	ld	[hl], a
	inc	hl
	ld	[hl], a
	inc	hl
	ld	[hl], a
;src/fatfs/fatfs.c:403: while (piece_i < piece_count && pos >= piece_start + pieces[piece_i].len) piece_start += pieces[piece_i++].len;
.l00104:
	ld	hl, _piece_i
	ld	c, [hl]
	ld	b, $00
	ld	l, c
	ld	h, b
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, bc
	ld	c, l
	ld	b, h
	ld	hl, _piece_i
	ld	a, [hl]
	ld	hl, _piece_count
	sub	a, [hl]
	jp	NC, .l00106
	ld	hl, _pieces
	add	hl, bc
	inc	hl
	inc	hl
	inc	hl
	inc	hl
	inc	hl
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
	ld	hl, _piece_start + 1
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
	ld	hl, sp+7
	ld	[hl], a
	dec	hl
	ld	[hl], e
	ld	hl, _piece_start + 3
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
	ld	hl, sp+7
	ld	[hl], a
	dec	hl
	ld	[hl], e
	ld	hl, sp+8
	ld	e, l
	ld	d, h
	ld	hl, sp+4
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
	jp	C, .l00106
	ld	hl, _piece_i
	ld	c, [hl]
	inc	[hl]
	ld	b, $00
	ld	l, c
	ld	h, b
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, bc
	ld	de, _pieces
	add	hl, de
	ld	bc, $0005
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
	ld	hl, _piece_start + 1
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, e
	ld	hl, sp+4
	add	a, [hl]
	ld	e, a
	ld	a, d
	inc	hl
	adc	a, [hl]
	push	af
	ld	hl, _piece_start + 1
	ld	[hl], a
	dec	hl
	ld	[hl], e
	ld	hl, _piece_start + 3
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
	ld	hl, _piece_start + 3
	ld	[hl], a
	dec	hl
	ld	[hl], e
	jp	.l00104
.l00106:
;src/fatfs/fatfs.c:404: return piece_i == piece_count ? 0 : &pieces[piece_i];
	ld	hl, _piece_i
	ld	a, [hl]
	ld	hl, _piece_count
	sub	a, [hl]
	jp	NZ,.l00136
	jp	.l00137
.l00136:
	jp	.l00109
.l00137:
	ld	bc, $0000
	jp	.l00110
.l00109:
	ld	hl, _pieces
	add	hl, bc
	ld	c, l
	ld	b, h
.l00110:
.l00107:
;src/fatfs/fatfs.c:405: }
	add	sp, 12
	ret
;src/fatfs/fatfs.c:409: static UINT DocRead(BYTE* dest, unsigned long pos, UINT count) {
;	---------------------------------
	SECTION FRAGMENT "Page 14",ROMX,BANK[7]
	LOAD FRAGMENT "Page 14 RAM",SRAM,BANK[14]
; Function DocRead
; ---------------------------------
_DocRead:
	add	sp, -18
	ld	hl, sp+16
	ld	[hl], e
	inc	hl
	ld	[hl], d
;src/fatfs/fatfs.c:410: Piece* piece = DocPiece(pos);
	ld	hl, sp+20
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	inc	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_DocPiece
	ld	hl, sp+2
	ld	[hl], c
	inc	hl
	ld	[hl], b
;src/fatfs/fatfs.c:413: if (!piece) return 0;
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	jp	NZ, .l00102
	ld	bc, $0000
	jp	.l00112
.l00102:
;src/fatfs/fatfs.c:414: in = pos - piece_start;
	ld	hl, sp+21
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, e
	ld	hl, _piece_start
	sub	a, [hl]
	ld	e, a
	ld	a, d
	inc	hl
	sbc	a, [hl]
	push	af
	ld	hl, sp+7
	ld	[hl], a
	dec	hl
	ld	[hl], e
	ld	hl, sp+25
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, _piece_start + 2
	pop	af
	ld	a, e
	sbc	a, [hl]
	ld	e, a
	ld	a, d
	inc	hl
	sbc	a, [hl]
	ld	hl, sp+7
	ld	[hl], a
	dec	hl
	ld	[hl], e
;src/fatfs/fatfs.c:415: if (piece->len - in < count) count = (UINT)(piece->len - in);
	ld	hl, sp+3
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $0005
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
	dec	hl
	dec	hl
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, e
	ld	hl, sp+4
	sub	a, [hl]
	ld	e, a
	ld	a, d
	inc	hl
	sbc	a, [hl]
	push	af
	ld	hl, sp+15
	ld	[hl], a
	dec	hl
	ld	[hl], e
	dec	hl
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
	ld	hl, sp+15
	ld	[hl], a
	dec	hl
	ld	[hl], e
	ld	hl, sp+24
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	ld	de, $0000
	ld	hl, sp+12
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
	jp	NC, .l00104
	ld	hl, sp+8
	ld	a, [hl]
	inc	hl
	ld	c, [hl]
	ld	hl, sp+4
	ld	e, [hl]
	inc	hl
	ld	b, [hl]
	sub	a, e
	ld	e, a
	ld	a, c
	sbc	a, b
	ld	d, a
	ld	hl, sp+24
	ld	[hl], e
	inc	hl
	ld	[hl], d
.l00104:
;src/fatfs/fatfs.c:416: in += piece->off;
	pop	hl
	pop	bc
	push	bc
	push	hl
	inc	bc
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
	ld	a, e
	ld	hl, sp+8
	add	a, [hl]
	ld	e, a
	ld	a, d
	inc	hl
	adc	a, [hl]
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
	ld	hl, sp+12
	pop	af
	ld	a, e
	adc	a, [hl]
	ld	e, a
	ld	a, d
	inc	hl
	adc	a, [hl]
	ld	hl, sp+15
	ld	[hl], a
	dec	hl
	ld	[hl], e
;src/fatfs/fatfs.c:417: if (piece->src == SRC_ADD) {
	ld	hl, sp+3
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	dec	a
	jp	NZ,.l00139
	jp	.l00140
.l00139:
	jp	.l00106
.l00140:
;src/fatfs/fatfs.c:418: AddCopy(dest, in, count, 0);
	xor	a, a
	push	af
	inc	sp
	ld	hl, sp+25
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
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
	ld	hl, sp+23
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_AddCopy
;src/fatfs/fatfs.c:419: return count;
	ld	hl, sp+24
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	jp	.l00112
.l00106:
;src/fatfs/fatfs.c:421: if ((f_tell(&file) != in && f_lseek(&file, in)) || f_read(&file, dest, count, &done) || done != count) return 0;
	ld	de, (_file + 16) + 0
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
	inc	hl
	ld	a, [hl]
	ld	hl, sp+8
	sub	a, [hl]
	jp	NZ,.l00141
	ld	hl, sp+13
	ld	a, [hl]
	ld	hl, sp+9
	sub	a, [hl]
	jp	NZ,.l00141
	ld	hl, sp+14
	ld	a, [hl]
	ld	hl, sp+10
	sub	a, [hl]
	jp	NZ,.l00141
	ld	hl, sp+15
	ld	a, [hl]
	ld	hl, sp+11
	sub	a, [hl]
	jp	NZ,.l00141
	jp	.l00110
.l00141:
	ld	hl, sp+14
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	push	de
	ld	hl, sp+14
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	push	de
	ld	de, _file
	call	_f_lseek__far
	or	a, a
	jp	NZ, .l00107
.l00110:
	ld	hl, sp+16
	ld	a, [hl]
	dec	hl
	dec	hl
	ld	[hl], a
	ld	hl, sp+17
	ld	a, [hl]
	dec	hl
	dec	hl
	ld	[hl], a
	ld	hl, 0
	add	hl, sp
	ld	e, l
	ld	d, h
	push	de
	ld	hl, sp+26
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	push	de
	ld	hl, sp+18
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	ld	de, _file
	call	_f_read__far
	ld	hl, sp+15
	ld	[hl], a
	ld	hl, sp+15
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00107
	ld	hl, sp+0
	ld	a, [hl]
	ld	hl, sp+24
	sub	a, [hl]
	jp	NZ,.l00142
	ld	hl, sp+1
	ld	a, [hl]
	ld	hl, sp+25
	sub	a, [hl]
	jp	NZ,.l00142
	jp	.l00108
.l00142:
.l00107:
	ld	bc, $0000
	jp	.l00112
.l00108:
;src/fatfs/fatfs.c:422: return count;
	ld	hl, sp+24
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
.l00112:
;src/fatfs/fatfs.c:423: }
	add	sp, 18
	pop	hl
	add	sp, 6
	jp hl
;src/fatfs/fatfs.c:426: static UINT DocReadAll(BYTE* dest, unsigned long pos, UINT count) {
;	---------------------------------
	SECTION FRAGMENT "Page 14",ROMX,BANK[7]
	LOAD FRAGMENT "Page 14 RAM",SRAM,BANK[14]
; Function DocReadAll
; ---------------------------------
_DocReadAll:
	add	sp, -12
	ld	hl, sp+10
	ld	[hl], e
	inc	hl
	ld	[hl], d
;src/fatfs/fatfs.c:427: UINT done = 0, size;
	ld	bc, $0000
;src/fatfs/fatfs.c:428: while (done != count) {
.l00103:
	ld	hl, sp+18
	ld	a, [hl]
	sub	a, c
	jp	NZ,.l00123
	inc	hl
	ld	a, [hl]
	sub	a, b
	jp	NZ,.l00123
	jp	.l00105
.l00123:
;src/fatfs/fatfs.c:429: if (!(size = DocRead(dest + done, pos + done, count - done))) return 0;
	ld	hl, sp+19
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, e
	sub	a, c
	ld	e, a
	ld	a, d
	sbc	a, b
	ld	hl, sp+1
	ld	[hl], a
	dec	hl
	ld	[hl], e
	inc	hl
	inc	hl
	ld	[hl], c
	inc	hl
	ld	[hl], b
	xor	a, a
	inc	hl
	ld	[hl], a
	inc	hl
	ld	[hl], a
	ld	hl, sp+15
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, e
	ld	hl, sp+2
	add	a, [hl]
	ld	e, a
	ld	a, d
	inc	hl
	adc	a, [hl]
	push	af
	ld	hl, sp+9
	ld	[hl], a
	dec	hl
	ld	[hl], e
	ld	hl, sp+19
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, sp+6
	pop	af
	ld	a, e
	adc	a, [hl]
	ld	e, a
	ld	a, d
	inc	hl
	adc	a, [hl]
	ld	hl, sp+9
	ld	[hl], a
	dec	hl
	ld	[hl], e
	inc	hl
	inc	hl
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	add	hl, bc
	ld	e, l
	ld	d, h
	push	bc
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
	ld	hl, sp+12
	ld	a, [hl]
	inc	hl
	ld	h, [hl]
;	spillPairReg hl
;	spillPairReg hl
	ld	l, a
;	spillPairReg hl
;	spillPairReg hl
	push	hl
	ld	hl, sp+12
	ld	a, [hl]
	inc	hl
	ld	h, [hl]
;	spillPairReg hl
;	spillPairReg hl
	ld	l, a
;	spillPairReg hl
;	spillPairReg hl
	push	hl
	call	_DocRead
	ld	e, c
	ld	d, b
	pop	bc
	ld	l, e
;	spillPairReg hl
;	spillPairReg hl
	ld	h, d
;	spillPairReg hl
;	spillPairReg hl
	ld	a, d
	or	a, e
	jp	NZ, .l00102
	ld	bc, $0000
	jp	.l00106
.l00102:
;src/fatfs/fatfs.c:430: done += size;
	add	hl, bc
	ld	c, l
	ld	b, h
	jp	.l00103
.l00105:
;src/fatfs/fatfs.c:432: return count;
	ld	hl, sp+18
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
.l00106:
;src/fatfs/fatfs.c:433: }
	add	sp, 12
	pop	hl
	add	sp, 6
	jp hl
;src/fatfs/fatfs.c:436: void fs_CloseLarge(void) {
;	---------------------------------
	SECTION FRAGMENT "Page 13",ROMX,BANK[6]
	LOAD FRAGMENT "Page 13 RAM",SRAM,BANK[13]
; Function fs_CloseLarge
; ---------------------------------
_fs_CloseLarge::
;src/fatfs/fatfs.c:437: if (!doc_large) return;
	ld	hl, _doc_large
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00102
	jp	.l00103
.l00102:
;src/fatfs/fatfs.c:438: doc_large = 0;
	ld	hl, _doc_large
	ld	[hl], $00
;src/fatfs/fatfs.c:439: f_close(&file);
	ld	de, _file
	call	_f_close__far
;src/fatfs/fatfs.c:440: Signature(TBSignature);
	ld	de, _TBSignature
	jp	_Signature
.l00103:
;src/fatfs/fatfs.c:441: }
	ret
;src/fatfs/fatfs.c:444: static void OneFilePiece(void) {
;	---------------------------------
	SECTION FRAGMENT "Page 14",ROMX,BANK[7]
	LOAD FRAGMENT "Page 14 RAM",SRAM,BANK[14]
; Function OneFilePiece
; ---------------------------------
_OneFilePiece:
;src/fatfs/fatfs.c:445: doc_len = f_size(&file);
	ld	de, (_file + 10) + 0
	ld	a, [de]
	ld	hl, _doc_len
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
;src/fatfs/fatfs.c:446: pieces[0].src = SRC_FILE;
	ld	hl, _pieces
	ld	[hl], $00
;src/fatfs/fatfs.c:447: pieces[0].off = 0;
	ld	hl, (_pieces + 1)
	xor	a, a
	ld	[hl], a
	inc	hl
	ld	[hl], a
	inc	hl
	ld	[hl], a
	inc	hl
	ld	[hl], a
;src/fatfs/fatfs.c:448: pieces[0].len = doc_len;
	ld	de, (_pieces + 5)
	ld	hl, _doc_len
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
;src/fatfs/fatfs.c:449: piece_count = 1;
	ld	hl, _piece_count
	ld	[hl], $01
;src/fatfs/fatfs.c:450: piece_i = 0;
	ld	hl, _piece_i
	ld	[hl], $00
;src/fatfs/fatfs.c:451: piece_start = 0;
	xor	a, a
	ld	hl, _piece_start
	ld	[hl], a
	inc	hl
	ld	[hl], a
	inc	hl
	ld	[hl], a
	inc	hl
	ld	[hl], a
;src/fatfs/fatfs.c:452: add_len = 0;
	xor	a, a
	ld	hl, _add_len
	ld	[hl], a
	inc	hl
	ld	[hl], a
	inc	hl
	ld	[hl], a
	inc	hl
	ld	[hl], a
.l00101:
;src/fatfs/fatfs.c:453: }
	ret
;src/fatfs/fatfs.c:456: unsigned char fs_LoadLarge(const char* path) {
;	---------------------------------
	SECTION FRAGMENT "Page 14",ROMX,BANK[7]
	LOAD FRAGMENT "Page 14 RAM",SRAM,BANK[14]
; Function fs_LoadLarge
; ---------------------------------
_fs_LoadLarge::
;src/fatfs/fatfs.c:458: fs_CloseLarge();
	push	de
	call	_fs_CloseLarge__far
	pop	de
;src/fatfs/fatfs.c:459: if ((result = Open(path, FA_READ))) return result;
	ld	a, $01
	call	_Open__far
	ld	c, a
	or	a, a
	jp	Z, .l00102
	ld	a, c
	jp	.l00105
.l00102:
;src/fatfs/fatfs.c:460: OneFilePiece();
	call	_OneFilePiece
;src/fatfs/fatfs.c:461: doc_large = 1;
	ld	hl, _doc_large
	ld	[hl], $01
;src/fatfs/fatfs.c:462: Signature(0);
	ld	de, $0000
	call	_Signature__far
;src/fatfs/fatfs.c:463: win_start = 0;
	xor	a, a
	ld	hl, _win_start
	ld	[hl], a
	inc	hl
	ld	[hl], a
	inc	hl
	ld	[hl], a
	inc	hl
	ld	[hl], a
;src/fatfs/fatfs.c:464: win_mark = NO_MARK;
	ld	hl, _win_mark
	ld	[hl], $FF
	inc	hl
	ld	[hl], $FF
	inc	hl
	ld	[hl], $FF
	inc	hl
	ld	[hl], $FF
;src/fatfs/fatfs.c:465: tb_cr = 0;
	ld	hl, _tb_cr
	ld	[hl], $00
;src/fatfs/fatfs.c:466: if ((result = fs_LoadWindow())) {
	call	_fs_LoadWindow
	ld	l, a
;	spillPairReg hl
;	spillPairReg hl
	or	a, a
	jp	Z, .l00104
;src/fatfs/fatfs.c:467: fs_CloseLarge();
	push	hl
	call	_fs_CloseLarge__far
	pop	hl
;src/fatfs/fatfs.c:468: tb_Clear();
	push	hl
	call	_tb_Clear
	pop	hl
.l00104:
;src/fatfs/fatfs.c:470: fs_crlf = tb_cr;
	ld	a, [_tb_cr]
	ld	[_fs_crlf], a
;src/fatfs/fatfs.c:471: return result;
	ld	a, l
.l00105:
;src/fatfs/fatfs.c:472: }
	ret
;src/fatfs/fatfs.c:477: unsigned char fs_LoadWindow(void) {
;	---------------------------------
	SECTION FRAGMENT "Page 14",ROMX,BANK[7]
	LOAD FRAGMENT "Page 14 RAM",SRAM,BANK[14]
; Function fs_LoadWindow
; ---------------------------------
_fs_LoadWindow::
	add	sp, -19
;src/fatfs/fatfs.c:478: unsigned long pos = win_start, end = win_start + WIN_SIZE, next;
	ld	hl, _win_start
	ld	d, h
	ld	e, l
	ld	hl, sp+15
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
	ld	hl, _win_start + 1
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, e
	add	a, $00
	ld	e, a
	ld	a, d
	adc	a, $C0
	push	af
	ld	hl, sp+3
	ld	[hl], a
	dec	hl
	ld	[hl], e
	ld	hl, _win_start + 3
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
	ld	hl, sp+3
	ld	[hl], a
	dec	hl
	ld	[hl], e
;src/fatfs/fatfs.c:480: FRESULT result = FR_OK;
	inc	hl
	inc	hl
	ld	[hl], $00
;src/fatfs/fatfs.c:481: if (end > doc_len) end = doc_len;
	ld	de, _doc_len
	ld	hl, sp+0
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
	jp	NC, .l00102
	ld	hl, _doc_len
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
.l00102:
;src/fatfs/fatfs.c:482: tb_Empty();
	call	_tb_Empty
;src/fatfs/fatfs.c:483: win_chunks = 0;
	ld	hl, _win_chunks
	ld	[hl], $00
;src/fatfs/fatfs.c:484: win_mark_pos = 0xFFFF;
	ld	hl, _win_mark_pos
	ld	[hl], $FF
	inc	hl
	ld	[hl], $FF
;src/fatfs/fatfs.c:485: while (1) {
.l00117:
;src/fatfs/fatfs.c:486: if (!((UINT)pos & 511)) win_kept[win_chunks++] = tb_Length();
	ld	hl, sp+15
	ld	a, [hl]
	ld	hl, sp+5
	ld	[hl], a
	ld	hl, sp+16
	ld	a, [hl]
	ld	hl, sp+6
	ld	[hl], a
	dec	hl
	ld	a, [hl]
	or	a, a
	jp	NZ,.l00166
	push	hl
	inc	hl
	bit	0, [hl]
	pop	hl
	jp	NZ,.l00166
	jp	.l00167
.l00166:
	jp	.l00104
.l00167:
	ld	hl, _win_chunks
	ld	c, [hl]
	inc	[hl]
	ld	l, c
;	spillPairReg hl
;	spillPairReg hl
	ld	h, $00
;	spillPairReg hl
;	spillPairReg hl
	add	hl, hl
	ld	de, _win_kept
	add	hl, de
	push	hl
	call	_tb_Length
	pop	hl
	ld	[hl], c
	inc	hl
	ld	[hl], b
.l00104:
;src/fatfs/fatfs.c:487: if (pos == win_mark) win_mark_pos = tb_Length();
	ld	hl, sp+15
	ld	a, [hl]
	ld	hl, _win_mark
	sub	a, [hl]
	jp	NZ,.l00168
	ld	hl, sp+16
	ld	a, [hl]
	ld	hl, _win_mark + 1
	sub	a, [hl]
	jp	NZ,.l00168
	ld	hl, sp+17
	ld	a, [hl]
	ld	hl, _win_mark + 2
	sub	a, [hl]
	jp	NZ,.l00168
	ld	hl, sp+18
	ld	a, [hl]
	ld	hl, _win_mark + 3
	sub	a, [hl]
	jp	NZ,.l00168
	jp	.l00169
.l00168:
	jp	.l00106
.l00169:
	call	_tb_Length
	ld	hl, _win_mark_pos
	ld	[hl], c
	inc	hl
	ld	[hl], b
.l00106:
;src/fatfs/fatfs.c:488: if (pos == end) break;
	ld	hl, sp+15
	ld	a, [hl]
	ld	hl, sp+0
	sub	a, [hl]
	jp	NZ,.l00170
	ld	hl, sp+16
	ld	a, [hl]
	ld	hl, sp+1
	sub	a, [hl]
	jp	NZ,.l00170
	ld	hl, sp+17
	ld	a, [hl]
	ld	hl, sp+2
	sub	a, [hl]
	jp	NZ,.l00170
	ld	hl, sp+18
	ld	a, [hl]
	ld	hl, sp+3
	sub	a, [hl]
	jp	NZ,.l00170
	jp	.l00118
.l00170:
;src/fatfs/fatfs.c:489: next = (pos | 511) + 1;
	ld	hl, sp+7
	ld	[hl], $FF
	ld	hl, sp+16
	ld	a, [hl]
	or	a, $01
	ld	hl, sp+8
	ld	[hl], a
	ld	hl, sp+17
	ld	a, [hl]
	ld	hl, sp+9
	ld	[hl], a
	ld	hl, sp+18
	ld	a, [hl]
	ld	hl, sp+10
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
;src/fatfs/fatfs.c:490: if (next > end) next = end;
	ld	hl, sp+0
	ld	e, l
	ld	d, h
	ld	hl, sp+11
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
	jp	NC, .l00110
	ld	hl, sp+0
	ld	d, h
	ld	e, l
	ld	hl, sp+11
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
.l00110:
;src/fatfs/fatfs.c:491: if (win_mark > pos && win_mark < next) next = win_mark;
	ld	hl, sp+15
	ld	e, l
	ld	d, h
	ld	hl, _win_mark
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
	jp	NC, .l00112
	ld	de, _win_mark
	ld	hl, sp+11
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
	jp	NC, .l00112
	ld	hl, _win_mark
	ld	d, h
	ld	e, l
	ld	hl, sp+11
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
;src/fatfs/fatfs.c:492: if (!(count = DocRead(buffer, pos, (UINT)(next - pos)))) {
	ld	hl, sp+11
	ld	a, [hl]
	inc	hl
	ld	b, [hl]
	ld	e, a
	ld	d, b
	ld	hl, sp+5
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	ld	a, e
	sub	a, l
	ld	e, a
	ld	a, d
	sbc	a, h
	ld	b, a
	ld	c, e
	push	bc
	ld	hl, sp+19
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	push	de
	ld	hl, sp+19
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	push	de
	ld	de, _buffer
	call	_DocRead
	ld	e, c
	ld	d, b
	ld	a, b
	or	a, c
	jp	NZ, .l00115
;src/fatfs/fatfs.c:493: result = FR_INT_ERR;
	ld	hl, sp+4
	ld	[hl], $02
;src/fatfs/fatfs.c:494: break;
	jp	.l00118
.l00115:
;src/fatfs/fatfs.c:496: tb_Append(buffer, count);
	push	de
	ld	c, e
	ld	b, d
	ld	de, _buffer
	call	_tb_Append
	pop	de
;src/fatfs/fatfs.c:497: pos += count;
	ld	hl, sp+11
	ld	[hl], e
	inc	hl
	ld	[hl], d
	xor	a, a
	inc	hl
	ld	[hl], a
	inc	hl
	ld	[hl], a
	inc	hl
	inc	hl
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, e
	ld	hl, sp+11
	add	a, [hl]
	ld	e, a
	ld	a, d
	inc	hl
	adc	a, [hl]
	push	af
	ld	hl, sp+18
	ld	[hl], a
	dec	hl
	ld	[hl], e
	ld	hl, sp+20
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, sp+15
	pop	af
	ld	a, e
	adc	a, [hl]
	ld	e, a
	ld	a, d
	inc	hl
	adc	a, [hl]
	ld	hl, sp+18
	ld	[hl], a
	dec	hl
	ld	[hl], e
	jp	.l00117
.l00118:
;src/fatfs/fatfs.c:499: win_end = pos;
	ld	hl, sp+15
	ld	d, h
	ld	e, l
	ld	hl, _win_end
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
;src/fatfs/fatfs.c:500: win_edited = 0;
	ld	hl, _win_edited
	ld	[hl], $00
;src/fatfs/fatfs.c:501: return result;
	ld	hl, sp+4
	ld	a, [hl]
.l00119:
;src/fatfs/fatfs.c:502: }
	add	sp, 19
	ret
;src/fatfs/fatfs.c:506: void fs_DocLineStart(void) {
;	---------------------------------
	SECTION FRAGMENT "Page 14",ROMX,BANK[7]
	LOAD FRAGMENT "Page 14 RAM",SRAM,BANK[14]
; Function fs_DocLineStart
; ---------------------------------
_fs_DocLineStart::
	add	sp, -18
;src/fatfs/fatfs.c:507: unsigned long pos = doc_pos;
	ld	hl, _doc_pos
	ld	d, h
	ld	e, l
	ld	hl, sp+10
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
;src/fatfs/fatfs.c:508: UINT count, i, kept = 0, scanned = 0;
	xor	a, a
	ld	hl, sp+4
	ld	[hl], a
	inc	hl
	ld	[hl], a
	xor	a, a
	ld	hl, sp+14
	ld	[hl], a
	inc	hl
	ld	[hl], a
;src/fatfs/fatfs.c:510: doc_back = 0;
	xor	a, a
	ld	hl, _doc_back
	ld	[hl], a
	inc	hl
	ld	[hl], a
;src/fatfs/fatfs.c:511: while (pos && scanned < LINE_SCAN) {
.l00112:
	ld	hl, sp+13
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	dec	hl
	or	a, [hl]
	dec	hl
	or	a, [hl]
	jp	Z, .l00114
	ld	hl, sp+14
	ld	a, [hl]
	sub	a, $00
	inc	hl
	ld	a, [hl]
	sbc	a, $10
	jp	NC, .l00114
;src/fatfs/fatfs.c:512: count = (UINT)pos & 511;
	ld	hl, sp+10
	ld	c, [hl]
	inc	hl
	ld	a, [hl]
	ld	hl, sp+6
	ld	[hl], c
	and	a, $01
	inc	hl
	ld	[hl], a
;src/fatfs/fatfs.c:513: if (!count) count = 512;
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	jp	NZ, .l00102
	ld	[hl], $00
	inc	hl
	ld	[hl], $02
.l00102:
;src/fatfs/fatfs.c:514: pos -= count;
	ld	hl, sp+6
	ld	a, [hl]
	ld	hl, sp+0
	ld	[hl], a
	ld	hl, sp+7
	ld	a, [hl]
	ld	hl, sp+1
	ld	[hl], a
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
	ld	hl, sp+0
	sub	a, [hl]
	ld	e, a
	ld	a, d
	inc	hl
	sbc	a, [hl]
	push	af
	ld	hl, sp+13
	ld	[hl], a
	dec	hl
	ld	[hl], e
	ld	hl, sp+15
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, sp+4
	pop	af
	ld	a, e
	sbc	a, [hl]
	ld	e, a
	ld	a, d
	inc	hl
	sbc	a, [hl]
	ld	hl, sp+13
	ld	[hl], a
	dec	hl
	ld	[hl], e
;src/fatfs/fatfs.c:515: if (!DocReadAll(buffer, pos, count)) return;
	ld	hl, sp+6
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	push	de
	ld	hl, sp+14
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	push	de
	ld	hl, sp+14
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	push	de
	ld	de, _buffer
	call	_DocReadAll
	ld	a, b
	or	a, c
	jp	NZ, .l00104
	jp	.l00120
.l00104:
;src/fatfs/fatfs.c:516: for (i = count; i; --i) {
	ld	hl, sp+6
	ld	a, [hl]
	inc	hl
	inc	hl
	ld	[hl], a
	dec	hl
	ld	a, [hl]
	inc	hl
	inc	hl
	ld	[hl], a
	ld	hl, sp+4
	ld	a, [hl]
	ld	hl, sp+16
	ld	[hl], a
	ld	hl, sp+5
	ld	a, [hl]
	ld	hl, sp+17
	ld	[hl], a
	ld	hl, sp+6
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
.l00118:
	ld	a, d
	or	a, e
	jp	Z, .l00110
;src/fatfs/fatfs.c:517: c = buffer[i - 1];
	ld	c, e
	ld	b, d
	dec	bc
	ld	hl, _buffer
	add	hl, bc
	ld	a, [hl]
;src/fatfs/fatfs.c:518: if (c == ASCII_LF) {
	cp	a, $0A
	jp	NZ,.l00177
	jp	.l00178
.l00177:
	jp	.l00106
.l00178:
;src/fatfs/fatfs.c:519: doc_pos = pos + i;
	ld	hl, sp+8
	ld	a, [hl]
	ld	hl, sp+14
	ld	[hl], a
	ld	hl, sp+9
	ld	a, [hl]
	ld	hl, sp+15
	ld	[hl], a
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
	ld	hl, _doc_pos + 1
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
	ld	hl, _doc_pos + 3
	ld	[hl], a
	dec	hl
	ld	[hl], e
;src/fatfs/fatfs.c:520: doc_back = kept;
	ld	hl, sp+4
	ld	a, [hl]
	ld	hl, _doc_back
	ld	[hl], a
	ld	hl, sp+5
	ld	a, [hl]
	ld	hl, _doc_back + 1
	ld	[hl], a
;src/fatfs/fatfs.c:521: return;
	jp	.l00120
.l00106:
;src/fatfs/fatfs.c:523: if (c != ASCII_CR && c) ++kept;
	cp	a, $0D
	jp	NZ,.l00179
	jp	.l00119
.l00179:
	or	a, a
	jp	Z, .l00119
	ld	hl, sp+16
	inc	[hl]
	jp	NZ, .l00180
	inc	hl
	inc	[hl]
.l00180:
	ld	hl, sp+16
	ld	a, [hl]
	ld	hl, sp+4
	ld	[hl], a
	ld	hl, sp+17
	ld	a, [hl]
	ld	hl, sp+5
	ld	[hl], a
.l00119:
;src/fatfs/fatfs.c:516: for (i = count; i; --i) {
	ld	e, c
	ld	d, b
	ld	hl, sp+8
	ld	[hl], c
	inc	hl
	ld	[hl], b
	jp	.l00118
.l00110:
;src/fatfs/fatfs.c:525: scanned += count;
	ld	hl, sp+7
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, sp+14
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+16
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+15
	ld	[hl], a
	jp	.l00112
.l00114:
;src/fatfs/fatfs.c:527: if (!pos) {
	ld	hl, sp+13
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	dec	hl
	or	a, [hl]
	dec	hl
	or	a, [hl]
	jp	NZ, .l00120
;src/fatfs/fatfs.c:528: doc_pos = 0;
	xor	a, a
	ld	hl, _doc_pos
	ld	[hl], a
	inc	hl
	ld	[hl], a
	inc	hl
	ld	[hl], a
	inc	hl
	ld	[hl], a
;src/fatfs/fatfs.c:529: doc_back = kept;
	ld	hl, sp+4
	ld	a, [hl]
	ld	hl, _doc_back
	ld	[hl], a
	ld	hl, sp+5
	ld	a, [hl]
	ld	hl, _doc_back + 1
	ld	[hl], a
.l00120:
;src/fatfs/fatfs.c:531: }
	add	sp, 18
	ret
;src/fatfs/fatfs.c:539: unsigned char fs_ScanStep(void) {
;	---------------------------------
	SECTION FRAGMENT "Page 14",ROMX,BANK[7]
	LOAD FRAGMENT "Page 14 RAM",SRAM,BANK[14]
; Function fs_ScanStep
; ---------------------------------
_fs_ScanStep::
	add	sp, -9
;src/fatfs/fatfs.c:542: for (i = 0; i < SCAN_SECTORS && scan_pos != scan_target; ++i) {
	ld	hl, sp+8
	ld	[hl], $00
.l00111:
	ld	hl, _scan_pos
	ld	a, [hl]
	ld	hl, _scan_target
	sub	a, [hl]
	jp	NZ,.l00152
	ld	hl, _scan_pos + 1
	ld	a, [hl]
	ld	hl, _scan_target + 1
	sub	a, [hl]
	jp	NZ,.l00152
	ld	hl, _scan_pos + 2
	ld	a, [hl]
	ld	hl, _scan_target + 2
	sub	a, [hl]
	jp	NZ,.l00152
	ld	hl, _scan_pos + 3
	ld	a, [hl]
	ld	hl, _scan_target + 3
	sub	a, [hl]
	jp	NZ,.l00152
	ld	a,$01
	jp	.l00153
.l00152:
	xor	a,a
.l00153:
	ld	hl, sp+3
	ld	[hl], a
	ld	hl, sp+8
	ld	a, [hl]
	sub	a, $04
	jp	NC, .l00108
	ld	hl, sp+3
	bit	0, [hl]
	jp	NZ, .l00108
;src/fatfs/fatfs.c:543: if (i && (rLY >= 144 ? rLY - 144 : rLY + 10) > SCAN_LAST_LINE) break;
	ld	hl, sp+8
	ld	a, [hl]
	or	a, a
	jp	Z, .l00102
	ldh	a, [$FF44]
	ld	hl, $FF44
	ld	c, [hl]
	ld	hl, sp+4
	ld	[hl], c
	inc	hl
	ld	[hl], $00
	sub	a, $90
	jp	C, .l00115
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $0090
	ld	a, e
	sub	a, l
	ld	e, a
	ld	a, d
	sbc	a, h
	ld	hl, sp+7
	ld	[hl], a
	dec	hl
	ld	[hl], e
	jp	.l00116
.l00115:
	ld	hl, sp+5
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $000A
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+8
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+7
	ld	[hl], a
.l00116:
	ld	hl, sp+6
	ld	a, $5A
	sub	a, [hl]
	inc	hl
	ld	a, $00
	sbc	a, [hl]
	ld	a, $00
	ld	d, a
	ld	e, [hl]
	bit	7, e
	jp	Z, .l00154
	bit	7, d
	jp	NZ, .l00155
	cp	a, a
	jp	.l00155
.l00154:
	bit	7, d
	jp	Z, .l00155
	scf
.l00155:
	jp	C, .l00108
.l00102:
;src/fatfs/fatfs.c:544: count = 512 - ((UINT)scan_pos & 511);
	ld	hl, _scan_pos
	ld	a, [hl]
	ld	hl, sp+0
	ld	[hl], a
	ld	hl, _scan_pos + 1
	ld	a, [hl]
	ld	hl, sp+1
	ld	[hl], a
	dec	hl
	ld	a, [hl]
	ld	hl, sp+6
	ld	[hl], a
	ld	hl, sp+1
	ld	a, [hl]
	and	a, $01
	ld	hl, sp+7
	ld	[hl], a
	ld	de, $0200
	dec	hl
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	ld	a, e
	sub	a, l
	ld	e, a
	ld	a, d
	sbc	a, h
	ld	hl, sp+3
	ld	[hl], a
	dec	hl
	ld	[hl], e
;src/fatfs/fatfs.c:545: if (scan_target - scan_pos < count) count = (UINT)(scan_target - scan_pos);
	ld	hl, _scan_target + 1
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, e
	ld	hl, _scan_pos
	sub	a, [hl]
	ld	e, a
	ld	a, d
	inc	hl
	sbc	a, [hl]
	push	af
	ld	hl, sp+7
	ld	[hl], a
	dec	hl
	ld	[hl], e
	ld	hl, _scan_target + 3
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, _scan_pos + 2
	pop	af
	ld	a, e
	sbc	a, [hl]
	ld	e, a
	ld	a, d
	inc	hl
	sbc	a, [hl]
	ld	hl, sp+7
	ld	[hl], a
	dec	hl
	ld	[hl], e
	pop	hl
	pop	bc
	push	bc
	push	hl
	ld	de, $0000
	ld	hl, sp+4
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
	jp	NC, .l00105
	ld	hl, _scan_target
	ld	a, [hl]
	inc	hl
	ld	c, [hl]
	ld	e, a
	ld	d, c
	pop	hl
	push	hl
	ld	a, e
	sub	a, l
	ld	e, a
	ld	a, d
	sbc	a, h
	ld	b, e
	ld	hl, sp+2
	ld	[hl], b
	inc	hl
	ld	[hl], a
.l00105:
;src/fatfs/fatfs.c:546: if (!DocReadAll(buffer, scan_pos, count)) return 1;
	pop	hl
	pop	de
	push	de
	push	hl
	push	de
	ld	hl, _scan_pos + 2
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	push	de
	ld	hl, _scan_pos
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	push	de
	ld	de, _buffer
	call	_DocReadAll
	ld	hl, sp+6
	ld	[hl], c
	inc	hl
	ld	[hl], b
	ld	hl, sp+7
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	jp	NZ, .l00107
	ld	a, $01
	jp	.l00113
.l00107:
;src/fatfs/fatfs.c:547: scan_lines += CountLF(buffer, count);
	pop	hl
	pop	bc
	push	bc
	push	hl
	ld	de, _buffer
	call	_CountLF
	ld	hl, sp+4
	ld	[hl], c
	inc	hl
	ld	[hl], b
	xor	a, a
	inc	hl
	ld	[hl], a
	inc	hl
	ld	[hl], a
	ld	hl, _scan_lines + 1
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, e
	ld	hl, sp+4
	add	a, [hl]
	ld	e, a
	ld	a, d
	inc	hl
	adc	a, [hl]
	push	af
	ld	hl, _scan_lines + 1
	ld	[hl], a
	dec	hl
	ld	[hl], e
	ld	hl, _scan_lines + 3
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
	ld	hl, _scan_lines + 3
	ld	[hl], a
	dec	hl
	ld	[hl], e
;src/fatfs/fatfs.c:548: scan_pos += count;
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
	xor	a, a
	inc	hl
	ld	[hl], a
	inc	hl
	ld	[hl], a
	ld	hl, _scan_pos + 1
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, e
	ld	hl, sp+4
	add	a, [hl]
	ld	e, a
	ld	a, d
	inc	hl
	adc	a, [hl]
	push	af
	ld	hl, _scan_pos + 1
	ld	[hl], a
	dec	hl
	ld	[hl], e
	ld	hl, _scan_pos + 3
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
	ld	hl, _scan_pos + 3
	ld	[hl], a
	dec	hl
	ld	[hl], e
;src/fatfs/fatfs.c:542: for (i = 0; i < SCAN_SECTORS && scan_pos != scan_target; ++i) {
	ld	hl, sp+8
	inc	[hl]
	jp	.l00111
.l00108:
;src/fatfs/fatfs.c:550: return scan_pos == scan_target;
	ld	hl, sp+3
	ld	a, [hl]
.l00113:
;src/fatfs/fatfs.c:551: }
	add	sp, 9
	ret
;src/fatfs/fatfs.c:555: static unsigned char Split(unsigned long pos) {
;	---------------------------------
	SECTION FRAGMENT "Page 14",ROMX,BANK[7]
	LOAD FRAGMENT "Page 14 RAM",SRAM,BANK[14]
; Function Split
; ---------------------------------
_Split:
	add	sp, -19
	ld	hl, sp+11
	ld	[hl], c
	inc	hl
	ld	[hl], b
	inc	hl
	ld	[hl], e
	inc	hl
	ld	[hl], d
;src/fatfs/fatfs.c:556: unsigned long start = 0;
	xor	a, a
	inc	hl
	ld	[hl], a
	inc	hl
	ld	[hl], a
	inc	hl
	ld	[hl], a
	inc	hl
	ld	[hl], a
;src/fatfs/fatfs.c:558: for (i = 0; i < piece_count; start += pieces[i++].len) {
	ld	hl, sp+0
	ld	[hl], $00
	ld	c, $00
.l00113:
	ld	a, c
	ld	hl, _piece_count
	sub	a, [hl]
	jp	NC, .l00108
;src/fatfs/fatfs.c:559: if (pos == start) return i;
	ld	hl, sp+11
	ld	a, [hl]
	ld	hl, sp+15
	sub	a, [hl]
	jp	NZ,.l00153
	ld	hl, sp+12
	ld	a, [hl]
	ld	hl, sp+16
	sub	a, [hl]
	jp	NZ,.l00153
	ld	hl, sp+13
	ld	a, [hl]
	ld	hl, sp+17
	sub	a, [hl]
	jp	NZ,.l00153
	ld	hl, sp+14
	ld	a, [hl]
	ld	hl, sp+18
	sub	a, [hl]
	jp	NZ,.l00153
	jp	.l00154
.l00153:
	jp	.l00102
.l00154:
	ld	hl, sp+0
	ld	a, [hl]
	jp	.l00115
.l00102:
;src/fatfs/fatfs.c:560: if (pos < start + pieces[i].len) {
	ld	b, $00
	ld	l, c
	ld	h, b
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, bc
	ld	de, _pieces
	add	hl, de
	inc	hl
	inc	hl
	inc	hl
	inc	hl
	inc	hl
	ld	e, l
	ld	d, h
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
	ld	hl, sp+16
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, e
	ld	hl, sp+3
	add	a, [hl]
	ld	e, a
	ld	a, d
	inc	hl
	adc	a, [hl]
	push	af
	ld	hl, sp+10
	ld	[hl], a
	dec	hl
	ld	[hl], e
	ld	hl, sp+20
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, sp+7
	pop	af
	ld	a, e
	adc	a, [hl]
	ld	e, a
	ld	a, d
	inc	hl
	adc	a, [hl]
	ld	hl, sp+10
	ld	[hl], a
	dec	hl
	ld	[hl], e
	ld	hl, sp+11
	ld	e, l
	ld	d, h
	ld	hl, sp+7
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
	jp	NC, .l00114
;src/fatfs/fatfs.c:561: if (piece_count == MAX_PIECES) return 0xFF;
	ld	hl, _piece_count
	ld	a, [hl]
	sub	a, $60
	jp	NZ,.l00155
	jp	.l00156
.l00155:
	jp	.l00104
.l00156:
	ld	a, $FF
	jp	.l00115
.l00104:
;src/fatfs/fatfs.c:562: for (j = piece_count; j > i; --j) pieces[j] = pieces[j - 1];
	ld	hl, _piece_count
	ld	a, [hl]
	ld	hl, sp+10
	ld	[hl], a
.l00110:
	ld	hl, sp+0
	ld	a, [hl]
	ld	hl, sp+10
	sub	a, [hl]
	jp	NC, .l00105
	ld	c, [hl]
	ld	b, $00
	dec	bc
	ld	l, c
	ld	h, b
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, bc
	ld	de, _pieces
	add	hl, de
	ld	c, l
	ld	b, h
	ld	hl, sp+10
	ld	e, [hl]
	ld	d, $00
	ld	l, e
	ld	h, d
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, de
	ld	de, _pieces
	add	hl, de
	ld	e, l
	ld	d, h
	ld	hl, $0009
	push	hl
	call	___memcpy
	ld	hl, sp+10
	dec	[hl]
	jp	.l00110
.l00105:
;src/fatfs/fatfs.c:563: ++piece_count;
	ld	hl, _piece_count
	inc	[hl]
;src/fatfs/fatfs.c:564: pieces[i + 1].off += pos - start;
	ld	hl, sp+0
	ld	c, [hl]
	ld	b, $00
	inc	bc
	ld	l, c
	ld	h, b
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, bc
	ld	c, l
	ld	b, h
	ld	hl, _pieces
	add	hl, bc
	push	hl
	ld	a, l
	ld	hl, sp+3
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+2
	ld	[hl], a
	dec	hl
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	inc	bc
	ld	e, c
	ld	d, b
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
	ld	hl, sp+12
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
	ld	hl, sp+10
	ld	[hl], a
	dec	hl
	ld	[hl], e
	ld	hl, sp+16
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
	ld	hl, sp+10
	ld	[hl], a
	dec	hl
	ld	[hl], e
	ld	hl, sp+4
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, e
	ld	hl, sp+7
	add	a, [hl]
	ld	e, a
	ld	a, d
	inc	hl
	adc	a, [hl]
	push	af
	ld	hl, sp+18
	ld	[hl], a
	dec	hl
	ld	[hl], e
	ld	hl, sp+8
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, sp+11
	pop	af
	ld	a, e
	adc	a, [hl]
	ld	e, a
	ld	a, d
	inc	hl
	adc	a, [hl]
	ld	hl, sp+18
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
;src/fatfs/fatfs.c:565: pieces[i + 1].len -= pos - start;
	ld	hl, sp+2
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $0005
	add	hl, de
	ld	c, l
	ld	b, h
	ld	e, c
	ld	d, b
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
	dec	hl
	dec	hl
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, e
	ld	hl, sp+7
	sub	a, [hl]
	ld	e, a
	ld	a, d
	inc	hl
	sbc	a, [hl]
	push	af
	ld	hl, sp+18
	ld	[hl], a
	dec	hl
	ld	[hl], e
	ld	hl, sp+8
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, sp+11
	pop	af
	ld	a, e
	sbc	a, [hl]
	ld	e, a
	ld	a, d
	inc	hl
	sbc	a, [hl]
	ld	hl, sp+18
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
;src/fatfs/fatfs.c:566: pieces[i].len = pos - start;
	ld	hl, sp+0
	ld	c, [hl]
	ld	b, $00
	ld	l, c
	ld	h, b
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, bc
	ld	de, _pieces
	add	hl, de
	ld	a, l
	add	a, $05
	ld	c, a
	ld	a, h
	adc	a, $00
	ld	b, a
	ld	hl, sp+7
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
;src/fatfs/fatfs.c:567: return i + 1;
	ld	hl, sp+0
	ld	a, [hl]
	inc	a
	jp	.l00115
.l00114:
;src/fatfs/fatfs.c:558: for (i = 0; i < piece_count; start += pieces[i++].len) {
	ld	a, c
	inc	c
	ld	hl, sp+0
	ld	[hl], c
	ld	e, a
	ld	d, $00
	ld	l, e
	ld	h, d
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, de
	ld	de, _pieces
	add	hl, de
	inc	hl
	inc	hl
	inc	hl
	inc	hl
	inc	hl
	ld	e, l
	ld	d, h
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
	ld	hl, sp+16
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, e
	ld	hl, sp+7
	add	a, [hl]
	ld	e, a
	ld	a, d
	inc	hl
	adc	a, [hl]
	push	af
	ld	hl, sp+18
	ld	[hl], a
	dec	hl
	ld	[hl], e
	ld	hl, sp+20
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, sp+11
	pop	af
	ld	a, e
	adc	a, [hl]
	ld	e, a
	ld	a, d
	inc	hl
	adc	a, [hl]
	ld	hl, sp+18
	ld	[hl], a
	dec	hl
	ld	[hl], e
	jp	.l00113
.l00108:
;src/fatfs/fatfs.c:570: return i;
	ld	hl, sp+0
	ld	a, [hl]
.l00115:
;src/fatfs/fatfs.c:571: }
	add	sp, 19
	ret
;src/fatfs/fatfs.c:575: unsigned char fs_CommitWindow(void) {
;	---------------------------------
	SECTION FRAGMENT "Page 14",ROMX,BANK[7]
	LOAD FRAGMENT "Page 14 RAM",SRAM,BANK[14]
; Function fs_CommitWindow
; ---------------------------------
_fs_CommitWindow::
	add	sp, -18
;src/fatfs/fatfs.c:576: UINT length = tb_Length(), count;
	call	_tb_Length
	pop	hl
	push	bc
;src/fatfs/fatfs.c:577: unsigned long pos = add_len;
	ld	hl, _add_len
	ld	d, h
	ld	e, l
	ld	hl, sp+13
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
;src/fatfs/fatfs.c:579: if (!win_edited) return 1;
	ld	hl, _win_edited
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00102
	ld	a, $01
	jp	.l00129
.l00102:
;src/fatfs/fatfs.c:580: if (add_len + length > ADD_MAX || piece_count > MAX_PIECES - 3) return 0;
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
	xor	a, a
	inc	hl
	ld	[hl], a
	inc	hl
	ld	[hl], a
	ld	hl, _add_len + 1
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, e
	ld	hl, sp+2
	add	a, [hl]
	ld	e, a
	ld	a, d
	inc	hl
	adc	a, [hl]
	push	af
	ld	hl, sp+12
	ld	[hl], a
	dec	hl
	ld	[hl], e
	ld	hl, _add_len + 3
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, sp+6
	pop	af
	ld	a, e
	adc	a, [hl]
	ld	e, a
	ld	a, d
	inc	hl
	adc	a, [hl]
	ld	hl, sp+12
	ld	[hl], a
	dec	hl
	ld	[hl], e
	dec	hl
	dec	hl
	ld	a, $00
	sub	a, [hl]
	inc	hl
	ld	a, $00
	sbc	a, [hl]
	inc	hl
	ld	a, $7A
	sbc	a, [hl]
	inc	hl
	ld	a, $00
	sbc	a, [hl]
	jp	C, .l00103
	ld	a, $5D
	ld	hl, _piece_count
	sub	a, [hl]
	jp	NC, .l00104
.l00103:
	xor	a, a
	jp	.l00129
.l00104:
;src/fatfs/fatfs.c:581: tb_read_pos = 0;
	xor	a, a
	ld	hl, _tb_read_pos
	ld	[hl], a
	inc	hl
	ld	[hl], a
;src/fatfs/fatfs.c:582: while ((count = tb_Read(buffer, FS_BUFFER_SIZE))) {
.l00106:
	ld	bc, $0200
	ld	de, _buffer
	call	_tb_Read
	ld	e, c
	ld	d, b
	ld	a, b
	or	a, c
	jp	Z, .l00108
;src/fatfs/fatfs.c:583: AddCopy(buffer, pos, count, 1);
	push	de
	ld	a, $01
	push	af
	inc	sp
	push	de
	ld	hl, sp+20
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	push	bc
	ld	hl, sp+20
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	push	bc
	ld	de, _buffer
	call	_AddCopy
	pop	de
;src/fatfs/fatfs.c:584: pos += count;
	ld	hl, sp+9
	ld	[hl], e
	inc	hl
	ld	[hl], d
	xor	a, a
	inc	hl
	ld	[hl], a
	inc	hl
	ld	[hl], a
	inc	hl
	inc	hl
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
	ld	hl, sp+18
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
	jp	.l00106
.l00108:
;src/fatfs/fatfs.c:586: a = Split(win_start);
	ld	hl, _win_start
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	inc	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_Split
	ld	hl, sp+6
	ld	[hl], a
;src/fatfs/fatfs.c:587: b = Split(win_end);
	ld	hl, _win_end
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	inc	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_Split
	ld	hl, sp+7
	ld	[hl], a
;src/fatfs/fatfs.c:588: i = a + (length ? 1 : 0); // where piece b goes
	ld	hl, sp+1
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	jp	Z, .l00131
	ld	bc, $0001
	jp	.l00132
.l00131:
	ld	bc, $0000
.l00132:
	ld	hl, sp+6
	ld	a, [hl]
	add	a, c
	inc	hl
	inc	hl
	ld	[hl], a
;src/fatfs/fatfs.c:589: if (i < b) for (j = b; j < piece_count; ++j) pieces[i + j - b] = pieces[j];
	ld	a, [hl]
	dec	hl
	sub	a, [hl]
	jp	NC, .l00114
	ld	a, [hl]
	ld	hl, sp+17
	ld	[hl], a
.l00120:
	ld	hl, sp+17
	ld	a, [hl]
	ld	hl, _piece_count
	sub	a, [hl]
	jp	NC, .l00115
	ld	hl, sp+17
	ld	c, [hl]
	ld	b, $00
	ld	l, c
	ld	h, b
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, bc
	ld	c, l
	ld	b, h
	ld	hl, _pieces
	add	hl, bc
	push	hl
	ld	a, l
	ld	hl, sp+13
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+12
	ld	[hl], a
	dec	hl
	ld	a, [hl]
	dec	hl
	dec	hl
	ld	[hl], a
	ld	hl, sp+12
	ld	a, [hl]
	dec	hl
	dec	hl
	ld	[hl], a
	dec	hl
	dec	hl
	ld	a, [hl]
	ld	hl, sp+11
	ld	[hl], a
	inc	hl
	ld	[hl], $00
	ld	hl, sp+17
	ld	c, [hl]
	ld	b, $00
	ld	hl, sp+11
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	add	hl, bc
	ld	c, l
	ld	b, h
	ld	hl, sp+7
	ld	e, [hl]
	ld	d, $00
	ld	a, c
	sub	a, e
	ld	c, a
	ld	a, b
	sbc	a, d
	ld	b, a
	ld	l, c
	ld	h, b
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, bc
	ld	de, _pieces
	add	hl, de
	ld	e, l
	ld	d, h
	ld	bc, $0009
	push	bc
	ld	hl, sp+11
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	call	___memcpy
	ld	hl, sp+17
	inc	[hl]
	jp	.l00120
.l00114:
;src/fatfs/fatfs.c:590: else if (i > b) for (j = piece_count; j > b; --j) pieces[j] = pieces[j - 1];
	ld	hl, sp+7
	ld	a, [hl]
	inc	hl
	sub	a, [hl]
	jp	NC, .l00115
	ld	hl, _piece_count
	ld	a, [hl]
	ld	hl, sp+17
	ld	[hl], a
.l00123:
	ld	hl, sp+7
	ld	a, [hl]
	ld	hl, sp+17
	sub	a, [hl]
	jp	NC, .l00115
	ld	c, [hl]
	ld	b, $00
	dec	bc
	ld	l, c
	ld	h, b
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, bc
	ld	de, _pieces
	add	hl, de
	ld	c, l
	ld	b, h
	ld	hl, sp+17
	ld	e, [hl]
	ld	d, $00
	ld	l, e
	ld	h, d
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, de
	ld	de, _pieces
	add	hl, de
	ld	e, l
	ld	d, h
	ld	hl, $0009
	push	hl
	call	___memcpy
	ld	hl, sp+17
	dec	[hl]
	jp	.l00123
.l00115:
;src/fatfs/fatfs.c:591: piece_count = piece_count + i - b;
	ld	hl, sp+8
	ld	a, [hl]
	ld	hl, _piece_count
	add	a, [hl]
	ld	hl, sp+7
	sub	a, [hl]
	ld	hl, _piece_count
	ld	[hl], a
;src/fatfs/fatfs.c:592: if (length) {
	ld	hl, sp+1
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	jp	Z, .l00117
;src/fatfs/fatfs.c:593: pieces[a].src = SRC_ADD;
	ld	bc, _pieces+0
	ld	hl, sp+6
	ld	e, [hl]
	ld	d, $00
	ld	l, e
	ld	h, d
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, de
	add	hl, bc
	ld	c, l
	ld	b, h
	ld	a, $01
	ld	[bc], a
;src/fatfs/fatfs.c:594: pieces[a].off = add_len;
	ld	e, c
	ld	d, b
	inc	de
	ld	hl, _add_len
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
;src/fatfs/fatfs.c:595: pieces[a].len = length;
	inc	bc
	inc	bc
	inc	bc
	inc	bc
	inc	bc
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
.l00117:
;src/fatfs/fatfs.c:597: piece_i = 0;
	ld	hl, _piece_i
	ld	[hl], $00
;src/fatfs/fatfs.c:598: piece_start = 0;
	xor	a, a
	ld	hl, _piece_start
	ld	[hl], a
	inc	hl
	ld	[hl], a
	inc	hl
	ld	[hl], a
	inc	hl
	ld	[hl], a
;src/fatfs/fatfs.c:599: add_len = pos;
	ld	hl, sp+13
	ld	d, h
	ld	e, l
	ld	hl, _add_len
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
;src/fatfs/fatfs.c:600: doc_len = doc_len - (win_end - win_start) + length;
	ld	hl, _win_end + 1
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, e
	ld	hl, _win_start
	sub	a, [hl]
	ld	e, a
	ld	a, d
	inc	hl
	sbc	a, [hl]
	push	af
	ld	hl, sp+13
	ld	[hl], a
	dec	hl
	ld	[hl], e
	ld	hl, _win_end + 3
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, _win_start + 2
	pop	af
	ld	a, e
	sbc	a, [hl]
	ld	e, a
	ld	a, d
	inc	hl
	sbc	a, [hl]
	ld	hl, sp+13
	ld	[hl], a
	dec	hl
	ld	[hl], e
	ld	hl, _doc_len + 1
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, e
	ld	hl, sp+10
	sub	a, [hl]
	ld	e, a
	ld	a, d
	inc	hl
	sbc	a, [hl]
	push	af
	ld	hl, sp+17
	ld	[hl], a
	dec	hl
	ld	[hl], e
	ld	hl, _doc_len + 3
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, sp+14
	pop	af
	ld	a, e
	sbc	a, [hl]
	ld	e, a
	ld	a, d
	inc	hl
	sbc	a, [hl]
	ld	hl, sp+17
	ld	[hl], a
	dec	hl
	ld	[hl], e
	dec	hl
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, e
	ld	hl, sp+2
	add	a, [hl]
	ld	e, a
	ld	a, d
	inc	hl
	adc	a, [hl]
	push	af
	ld	hl, _doc_len + 1
	ld	[hl], a
	dec	hl
	ld	[hl], e
	ld	hl, sp+19
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, sp+6
	pop	af
	ld	a, e
	adc	a, [hl]
	ld	e, a
	ld	a, d
	inc	hl
	adc	a, [hl]
	ld	hl, _doc_len + 3
	ld	[hl], a
	dec	hl
	ld	[hl], e
;src/fatfs/fatfs.c:601: win_end = win_start + length;
	ld	hl, _win_start + 1
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, e
	ld	hl, sp+2
	add	a, [hl]
	ld	e, a
	ld	a, d
	inc	hl
	adc	a, [hl]
	push	af
	ld	hl, _win_end + 1
	ld	[hl], a
	dec	hl
	ld	[hl], e
	ld	hl, _win_start + 3
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, sp+6
	pop	af
	ld	a, e
	adc	a, [hl]
	ld	e, a
	ld	a, d
	inc	hl
	adc	a, [hl]
	ld	hl, _win_end + 3
	ld	[hl], a
	dec	hl
	ld	[hl], e
;src/fatfs/fatfs.c:602: win_chunks = 0; // window positions are document offsets - win_start now
	ld	hl, _win_chunks
	ld	[hl], $00
;src/fatfs/fatfs.c:603: for (pos = (win_start + 511) & ~511UL; pos <= win_end && win_chunks < WIN_CHUNKS; pos += 512) win_kept[win_chunks++] = (UINT)(pos - win_start);
	ld	hl, _win_start + 1
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
	ld	hl, sp+13
	ld	[hl], a
	dec	hl
	ld	[hl], e
	ld	hl, _win_start + 3
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
	ld	hl, sp+13
	ld	[hl], a
	dec	hl
	ld	[hl], e
	inc	hl
	inc	hl
	ld	[hl], $00
	ld	hl, sp+11
	ld	a, [hl]
	and	a, $FE
	ld	hl, sp+15
	ld	[hl], a
	ld	hl, sp+12
	ld	a, [hl]
	ld	hl, sp+16
	ld	[hl], a
	ld	hl, sp+13
	ld	a, [hl]
	ld	hl, sp+17
	ld	[hl], a
.l00127:
	ld	de, _win_end
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
	jp	C, .l00118
	ld	hl, _win_chunks
	ld	a, [hl]
	sub	a, $61
	jp	NC, .l00118
	ld	c, [hl]
	inc	[hl]
	ld	l, c
;	spillPairReg hl
;	spillPairReg hl
	ld	h, $00
;	spillPairReg hl
;	spillPairReg hl
	add	hl, hl
	ld	a, l
	add	a, LOW(_win_kept)
	ld	c, a
	ld	a, h
	adc	a, HIGH(_win_kept)
	ld	b, a
	ld	hl, sp+14
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, _win_start
	ld	l, [hl]
;	spillPairReg hl
;	spillPairReg hl
	ld	a, [_win_start + 1]
	ld	h, a
;	spillPairReg hl
;	spillPairReg hl
	ld	a, e
	sub	a, l
	ld	e, a
	ld	a, d
	sbc	a, h
	ld	d, a
	ld	a, e
	ld	[bc], a
	inc	bc
	ld	a, d
	ld	[bc], a
	ld	hl, sp+15
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, e
	add	a, $00
	ld	e, a
	ld	a, d
	adc	a, $02
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
	adc	a, $00
	ld	e, a
	ld	a, d
	adc	a, $00
	ld	[hl], a
	dec	hl
	ld	[hl], e
	jp	.l00127
.l00118:
;src/fatfs/fatfs.c:604: win_edited = 0;
	ld	hl, _win_edited
	ld	[hl], $00
;src/fatfs/fatfs.c:605: return 1;
	ld	a, $01
.l00129:
;src/fatfs/fatfs.c:606: }
	add	sp, 18
	ret
;src/fatfs/fatfs.c:612: static FRESULT SaveOut(const BYTE* data, UINT count, UINT* fill) {
;	---------------------------------
	SECTION FRAGMENT "Page 14",ROMX,BANK[7]
	LOAD FRAGMENT "Page 14 RAM",SRAM,BANK[14]
; Function SaveOut
; ---------------------------------
_SaveOut:
	add	sp, -13
	ld	hl, sp+11
	ld	[hl], e
	inc	hl
	ld	[hl], d
	ld	hl, sp+9
	ld	[hl], c
	inc	hl
	ld	[hl], b
;src/fatfs/fatfs.c:614: FRESULT result = FR_OK;
	ld	hl, sp+2
	ld	[hl], $00
;src/fatfs/fatfs.c:615: SetWindowBlock(SAVE_BLOCK);
	ld	de, $03FF
	call	_SetWindowBlock
;src/fatfs/fatfs.c:616: while (count) {
.l00109:
	ld	hl, sp+10
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	jp	Z, .l00111
;src/fatfs/fatfs.c:617: size = 512 - *fill;
	ld	hl, sp+15
	ld	a, [hl]
	ld	hl, sp+3
	ld	[hl], a
	ld	hl, sp+16
	ld	a, [hl]
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
	ld	b, a
	ld	de, $0200
	ld	a, e
	sub	a, c
	ld	e, a
	ld	a, d
	sbc	a, b
	inc	hl
	inc	hl
	ld	[hl], a
	dec	hl
	ld	[hl], e
;src/fatfs/fatfs.c:618: if (size > count) size = count;
	ld	hl, sp+9
	ld	e, l
	ld	d, h
	ld	hl, sp+5
	ld	a, [de]
	inc	de
	sub	a, [hl]
	inc	hl
	ld	a, [de]
	sbc	a, [hl]
	jp	NC, .l00102
	ld	hl, sp+9
	ld	a, [hl]
	ld	hl, sp+5
	ld	[hl], a
	ld	hl, sp+10
	ld	a, [hl]
	ld	hl, sp+6
	ld	[hl], a
.l00102:
;src/fatfs/fatfs.c:619: memcpy(WINDOW + *fill, data, size);
	ld	hl, sp+11
	ld	a, [hl]
	ld	hl, sp+7
	ld	[hl], a
	ld	hl, sp+12
	ld	a, [hl]
	ld	hl, sp+8
	ld	[hl], a
	ld	hl, $BE00
	add	hl, bc
	ld	e, l
	ld	d, h
	ld	hl, sp+5
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	push	bc
	inc	hl
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	call	___memcpy
;src/fatfs/fatfs.c:620: *fill += size;
	ld	hl, sp+4
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
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	add	hl, bc
	ld	c, l
	ld	b, h
	ld	hl, sp+3
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	ld	[hl], c
	inc	hl
	ld	[hl], b
;src/fatfs/fatfs.c:621: data += size;
	ld	hl, sp+6
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, sp+11
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+13
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+12
	ld	[hl], a
;src/fatfs/fatfs.c:622: count -= size;
	dec	hl
	dec	hl
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, sp+5
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	ld	a, e
	sub	a, l
	ld	e, a
	ld	a, d
	sbc	a, h
	ld	hl, sp+10
	ld	[hl], a
	dec	hl
	ld	[hl], e
;src/fatfs/fatfs.c:623: if (*fill == 512) { // the window still shows the block while FatFs writes it
	ld	a, c
	or	a, a
	jp	NZ,.l00144
	ld	a, b
	sub	a, $02
	jp	NZ,.l00144
	jp	.l00145
.l00144:
	jp	.l00109
.l00145:
;src/fatfs/fatfs.c:624: *fill = 0;
	ld	hl, sp+3
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	xor	a, a
	ld	[hl], a
	inc	hl
	ld	[hl], a
;src/fatfs/fatfs.c:625: if ((result = f_write(&save_file, WINDOW, 512, &done)) || (done != 512 && (result = FR_DENIED))) break;
	ld	hl, 0
	add	hl, sp
	ld	e, l
	ld	d, h
	push	de
	ld	de, $0200
	push	de
	ld	bc, $BE00
	ld	de, _save_file
	call	_f_write__far
	ld	hl, sp+2
	ld	[hl], a
	or	a, a
	jp	NZ, .l00111
	dec	hl
	dec	hl
	ld	a, [hl]
	or	a, a
	jp	NZ,.l00146
	inc	hl
	ld	a, [hl]
	sub	a, $02
	jp	NZ,.l00146
	jp	.l00109
.l00146:
	ld	hl, sp+2
	ld	[hl], $07
.l00111:
;src/fatfs/fatfs.c:628: SetWindowBlock(TB_PSRAM_HIGH << 8);
	ld	de, $0100
	call	_SetWindowBlock
;src/fatfs/fatfs.c:629: return result;
	ld	hl, sp+2
	ld	a, [hl]
.l00112:
;src/fatfs/fatfs.c:630: }
	add	sp, 13
	pop	hl
	inc	sp
	inc	sp
	jp hl
;src/fatfs/fatfs.c:636: unsigned char fs_SaveLarge(const char* path) {
;	---------------------------------
	SECTION FRAGMENT "Page 14",ROMX,BANK[7]
	LOAD FRAGMENT "Page 14 RAM",SRAM,BANK[14]
; Function fs_SaveLarge
; ---------------------------------
_fs_SaveLarge::
	add	sp, -128
	add	sp, -98
	ld	hl, 214
	add	hl, sp
	ld	[hl], e
	inc	hl
	ld	[hl], d
;src/fatfs/fatfs.c:638: unsigned long pos = 0, out = 0, start = 0;
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
	xor	a, a
	ld	hl, 201
	add	hl, sp
	ld	[hl], a
	inc	hl
	ld	[hl], a
	inc	hl
	ld	[hl], a
	inc	hl
	ld	[hl], a
;src/fatfs/fatfs.c:639: UINT count, done, i, end = 0, fill = 0;
	xor	a, a
	ld	hl, 224
	add	hl, sp
	ld	[hl], a
	inc	hl
	ld	[hl], a
	xor	a, a
	ld	hl, 199
	add	hl, sp
	ld	[hl], a
	inc	hl
	ld	[hl], a
;src/fatfs/fatfs.c:643: if (!fs_CommitWindow()) return FR_DENIED;
	call	_fs_CommitWindow
	ld	c, a
	ld	a, c
	or	a, a
	jp	NZ, .l00164
	ld	a, $07
	jp	.l00152
;src/fatfs/fatfs.c:644: for (i = 0; path[i]; ++i) if (path[i] == '/') end = i + 1;
.l00164:
	ld	bc, $0000
.l00147:
	ld	hl, 214
	add	hl, sp
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	add	hl, bc
	ld	e, l
	ld	d, h
	ld	a, [de]
	or	a, a
	jp	Z, .l00105
	inc	bc
	sub	a, $2F
	jp	NZ,.l00313
	jp	.l00314
.l00313:
	jp	.l00148
.l00314:
	ld	hl, 224
	add	hl, sp
	ld	[hl], c
	inc	hl
	ld	[hl], b
.l00148:
	jp	.l00147
.l00105:
;src/fatfs/fatfs.c:645: memcpy(temp, path, end);
	ld	hl, 214
	add	hl, sp
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	ld	hl, 224
	add	hl, sp
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	push	de
	ld	hl, 6
	add	hl, sp
	ld	e, l
	ld	d, h
	call	___memcpy
;src/fatfs/fatfs.c:646: memcpy(temp + end, TEMP_NAME, sizeof(TEMP_NAME));
	ld	bc, ___src_fatfs_fatfs_c_str_5+0
	push	hl
	ld	hl, 6
	add	hl, sp
	ld	e, l
	ld	d, h
	pop	hl
	ld	hl, 224
	add	hl, sp
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	add	hl, de
	ld	e, l
	ld	d, h
	ld	hl, $000C
	push	hl
	call	___memcpy
;src/fatfs/fatfs.c:647: if ((result = f_open(&save_file, temp, FA_WRITE | FA_CREATE_ALWAYS))) return result;
	ld	a, $0A
	push	af
	inc	sp
	ld	hl, 5
	add	hl, sp
	ld	c, l
	ld	b, h
	ld	de, _save_file
	call	_f_open__far
	ld	hl, 225
	add	hl, sp
	ld	[hl], a
	or	a, a
	jp	Z, .l00180
	ld	a, [hl]
	jp	.l00152
;src/fatfs/fatfs.c:648: while (pos != doc_len) {
.l00180:
.l00124:
	ld	hl, 216
	add	hl, sp
	ld	a, [hl]
	ld	hl, _doc_len
	sub	a, [hl]
	jp	NZ,.l00315
	ld	hl, 217
	add	hl, sp
	ld	a, [hl]
	ld	hl, _doc_len + 1
	sub	a, [hl]
	jp	NZ,.l00315
	ld	hl, 218
	add	hl, sp
	ld	a, [hl]
	ld	hl, _doc_len + 2
	sub	a, [hl]
	jp	NZ,.l00315
	ld	hl, 219
	add	hl, sp
	ld	a, [hl]
	ld	hl, _doc_len + 3
	sub	a, [hl]
	jp	NZ,.l00315
	jp	.l00126
.l00315:
;src/fatfs/fatfs.c:649: if (pos == win_start) start = out;
	ld	hl, 216
	add	hl, sp
	ld	a, [hl]
	ld	hl, _win_start
	sub	a, [hl]
	jp	NZ,.l00316
	ld	hl, 217
	add	hl, sp
	ld	a, [hl]
	ld	hl, _win_start + 1
	sub	a, [hl]
	jp	NZ,.l00316
	ld	hl, 218
	add	hl, sp
	ld	a, [hl]
	ld	hl, _win_start + 2
	sub	a, [hl]
	jp	NZ,.l00316
	ld	hl, 219
	add	hl, sp
	ld	a, [hl]
	ld	hl, _win_start + 3
	sub	a, [hl]
	jp	NZ,.l00316
	jp	.l00317
.l00316:
	jp	.l00109
.l00317:
	ld	hl, 220
	add	hl, sp
	ld	d, h
	ld	e, l
	ld	hl, 201
	add	hl, sp
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
.l00109:
;src/fatfs/fatfs.c:650: piece = DocPiece(pos);
	ld	hl, 216
	add	hl, sp
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	inc	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_DocPiece
	ld	hl, 205
	add	hl, sp
	ld	[hl], c
	inc	hl
	ld	[hl], b
;src/fatfs/fatfs.c:651: crlf = fs_crlf && piece->src == SRC_ADD; // added text gets CRs, it's read into the second half
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	ld	hl, 213
	add	hl, sp
	ld	[hl], a
	ld	hl, _fs_crlf
	ld	a, [hl]
	or	a, a
	jp	Z, .l00154
	ld	hl, 213
	add	hl, sp
	ld	a, [hl]
	dec	a
	jp	NZ,.l00318
	jp	.l00155
.l00318:
.l00154:
	xor	a, a
	jp	.l00156
.l00155:
	ld	a, $01
.l00156:
	ld	hl, 207
	add	hl, sp
	ld	[hl], a
;src/fatfs/fatfs.c:652: count = crlf ? 256 : 512;
	ld	a, [hl]
	or	a, a
	jp	Z, .l00157
	ld	hl, 224
	add	hl, sp
	ld	[hl], $00
	inc	hl
	ld	[hl], $01
	jp	.l00158
.l00157:
	ld	hl, 224
	add	hl, sp
	ld	[hl], $00
	inc	hl
	ld	[hl], $02
.l00158:
;src/fatfs/fatfs.c:653: if (piece->src == SRC_FILE) count -= (UINT)(pos - piece_start + piece->off) & 511; // whole sectors skip FatFs's copy
	ld	hl, 216
	add	hl, sp
	ld	a, [hl]
	ld	hl, 208
	add	hl, sp
	ld	[hl], a
	ld	hl, 217
	add	hl, sp
	ld	a, [hl]
	ld	hl, 209
	add	hl, sp
	ld	[hl], a
	ld	hl, 213
	add	hl, sp
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00111
	ld	hl, _piece_start
	ld	a, [hl]
	ld	hl, 210
	add	hl, sp
	ld	[hl], a
	ld	hl, _piece_start + 1
	ld	a, [hl]
	ld	hl, 211
	add	hl, sp
	ld	[hl], a
	dec	hl
	dec	hl
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
	ld	hl, 213
	add	hl, sp
	ld	[hl], a
	dec	hl
	ld	[hl], e
	ld	hl, 205
	add	hl, sp
	ld	a, [hl]
	inc	hl
	ld	h, [hl]
;	spillPairReg hl
;	spillPairReg hl
	ld	l, a
;	spillPairReg hl
;	spillPairReg hl
	inc	hl
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	ld	hl, 212
	add	hl, sp
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	add	hl, bc
	ld	c, l
	ld	a, h
	and	a, $01
	ld	b, a
	ld	hl, 225
	add	hl, sp
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, e
	sub	a, c
	ld	e, a
	ld	a, d
	sbc	a, b
	ld	[hl], a
	dec	hl
	ld	[hl], e
.l00111:
;src/fatfs/fatfs.c:654: if (pos < win_start && win_start - pos < count) count = (UINT)(win_start - pos);
	ld	hl, 216
	add	hl, sp
	ld	e, l
	ld	d, h
	ld	hl, _win_start
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
	jp	NC, .l00113
	ld	hl, _win_start + 1
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, e
	ld	hl, 216
	add	hl, sp
	sub	a, [hl]
	ld	e, a
	ld	a, d
	inc	hl
	sbc	a, [hl]
	push	af
	ld	hl, 213
	add	hl, sp
	ld	[hl], a
	dec	hl
	ld	[hl], e
	ld	hl, _win_start + 3
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, 220
	add	hl, sp
	pop	af
	ld	a, e
	sbc	a, [hl]
	ld	e, a
	ld	a, d
	inc	hl
	sbc	a, [hl]
	ld	hl, 213
	add	hl, sp
	ld	[hl], a
	dec	hl
	ld	[hl], e
	ld	hl, 224
	add	hl, sp
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	ld	de, $0000
	ld	hl, 210
	add	hl, sp
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
	jp	NC, .l00113
	ld	hl, _win_start
	ld	a, [hl]
	inc	hl
	ld	c, [hl]
	ld	e, a
	ld	d, c
	ld	hl, 208
	add	hl, sp
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	ld	a, e
	sub	a, l
	ld	e, a
	ld	a, d
	sbc	a, h
	ld	hl, 225
	add	hl, sp
	ld	[hl], a
	dec	hl
	ld	[hl], e
.l00113:
;src/fatfs/fatfs.c:655: src = crlf ? buffer + 256 : buffer;
	ld	hl, 207
	add	hl, sp
	ld	a, [hl]
	or	a, a
	jp	Z, .l00159
	ld	de, (_buffer + 256)
	jp	.l00160
.l00159:
	ld	de, _buffer
.l00160:
	ld	hl, 212
	add	hl, sp
	ld	[hl], e
	inc	hl
	ld	[hl], d
;src/fatfs/fatfs.c:656: if (!(count = DocRead(src, pos, count))) {
	ld	hl, 224
	add	hl, sp
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	push	de
	ld	hl, 220
	add	hl, sp
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	push	de
	ld	hl, 220
	add	hl, sp
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	push	de
	ld	hl, 218
	add	hl, sp
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_DocRead
	ld	hl, 208
	add	hl, sp
	ld	[hl], c
	inc	hl
	ld	[hl], b
	ld	a, b
	or	a, c
	jp	NZ, .l00116
;src/fatfs/fatfs.c:657: result = FR_INT_ERR;
	ld	hl, 225
	add	hl, sp
	ld	[hl], $02
;src/fatfs/fatfs.c:658: break;
	jp	.l00126
.l00116:
;src/fatfs/fatfs.c:660: pos += count;
	ld	hl, 208
	add	hl, sp
	ld	a, [hl]
	ld	hl, sp+0
	ld	[hl], a
	ld	hl, 209
	add	hl, sp
	ld	a, [hl]
	ld	hl, sp+1
	ld	[hl], a
	xor	a, a
	inc	hl
	ld	[hl], a
	inc	hl
	ld	[hl], a
	ld	hl, 217
	add	hl, sp
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
	ld	hl, 219
	add	hl, sp
	ld	[hl], a
	dec	hl
	ld	[hl], e
	ld	hl, 221
	add	hl, sp
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
	ld	hl, 219
	add	hl, sp
	ld	[hl], a
	dec	hl
	ld	[hl], e
;src/fatfs/fatfs.c:661: if (crlf) { // in place: each line feed's CR is written before it's read
	ld	hl, 207
	add	hl, sp
	ld	a, [hl]
	or	a, a
	jp	Z, .l00121
;src/fatfs/fatfs.c:662: for (dest = buffer, i = 0; i < count; ++i) {
	ld	hl, 210
	add	hl, sp
	ld	a, LOW(_buffer)
	ld	[hl], a
	inc	hl
	ld	a, HIGH(_buffer)
	ld	[hl], a
	xor	a, a
	ld	hl, 224
	add	hl, sp
	ld	[hl], a
	inc	hl
	ld	[hl], a
.l00150:
	ld	hl, 224
	add	hl, sp
	ld	e, l
	ld	d, h
	ld	hl, 208
	add	hl, sp
	ld	a, [de]
	inc	de
	sub	a, [hl]
	inc	hl
	ld	a, [de]
	sbc	a, [hl]
	jp	NC, .l00119
;src/fatfs/fatfs.c:663: if ((c = src[i]) == ASCII_LF) *dest++ = ASCII_CR;
	ld	hl, 213
	add	hl, sp
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, 224
	add	hl, sp
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, 208
	add	hl, sp
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, 207
	add	hl, sp
	ld	[hl], a
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	ld	c, a
	sub	a, $0A
	jp	NZ,.l00319
	jp	.l00320
.l00319:
	jp	.l00118
.l00320:
	ld	hl, 210
	add	hl, sp
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	ld	[hl], $0D
	ld	hl, 210
	add	hl, sp
	inc	[hl]
	jp	NZ, .l00321
	inc	hl
	inc	[hl]
.l00321:
.l00118:
;src/fatfs/fatfs.c:664: *dest++ = c;
	ld	hl, 210
	add	hl, sp
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	ld	[hl], c
	ld	hl, 210
	add	hl, sp
	inc	[hl]
	jp	NZ, .l00322
	inc	hl
	inc	[hl]
.l00322:
;src/fatfs/fatfs.c:662: for (dest = buffer, i = 0; i < count; ++i) {
	ld	hl, 224
	add	hl, sp
	inc	[hl]
	jp	NZ, .l00323
	inc	hl
	inc	[hl]
.l00323:
	jp	.l00150
.l00119:
;src/fatfs/fatfs.c:666: src = buffer;
	ld	hl, 212
	add	hl, sp
	ld	a, LOW(_buffer)
	ld	[hl], a
	inc	hl
	ld	a, HIGH(_buffer)
	ld	[hl], a
;src/fatfs/fatfs.c:667: count = (UINT)(dest - buffer);
	dec	hl
	dec	hl
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
	ld	hl, 208
	add	hl, sp
	ld	[hl], c
	inc	hl
	ld	[hl], a
.l00121:
;src/fatfs/fatfs.c:669: if ((result = SaveOut(src, count, &fill))) break;
	ld	hl, 199
	add	hl, sp
	push	hl
	ld	hl, 210
	add	hl, sp
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	ld	hl, 214
	add	hl, sp
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_SaveOut
	ld	hl, 225
	add	hl, sp
	ld	[hl], a
	or	a, a
	jp	NZ, .l00126
;src/fatfs/fatfs.c:670: out += count;
	ld	hl, 208
	add	hl, sp
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
	inc	hl
	ld	[hl], a
	inc	hl
	ld	[hl], a
	ld	hl, 221
	add	hl, sp
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, e
	ld	hl, 210
	add	hl, sp
	add	a, [hl]
	ld	e, a
	ld	a, d
	inc	hl
	adc	a, [hl]
	push	af
	ld	hl, 223
	add	hl, sp
	ld	[hl], a
	dec	hl
	ld	[hl], e
	ld	hl, 225
	add	hl, sp
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, 214
	add	hl, sp
	pop	af
	ld	a, e
	adc	a, [hl]
	ld	e, a
	ld	a, d
	inc	hl
	adc	a, [hl]
	ld	hl, 223
	add	hl, sp
	ld	[hl], a
	dec	hl
	ld	[hl], e
	jp	.l00124
.l00126:
;src/fatfs/fatfs.c:672: if (pos == win_start) start = out;
	ld	hl, 216
	add	hl, sp
	ld	a, [hl]
	ld	hl, _win_start
	sub	a, [hl]
	jp	NZ,.l00324
	ld	hl, 217
	add	hl, sp
	ld	a, [hl]
	ld	hl, _win_start + 1
	sub	a, [hl]
	jp	NZ,.l00324
	ld	hl, 218
	add	hl, sp
	ld	a, [hl]
	ld	hl, _win_start + 2
	sub	a, [hl]
	jp	NZ,.l00324
	ld	hl, 219
	add	hl, sp
	ld	a, [hl]
	ld	hl, _win_start + 3
	sub	a, [hl]
	jp	NZ,.l00324
	jp	.l00325
.l00324:
	jp	.l00128
.l00325:
	ld	hl, 220
	add	hl, sp
	ld	d, h
	ld	e, l
	ld	hl, 201
	add	hl, sp
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
.l00128:
;src/fatfs/fatfs.c:673: if (!result && fill) { // the last part of a sector
	ld	hl, 225
	add	hl, sp
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00133
	ld	hl, 200
	add	hl, sp
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	jp	Z, .l00133
;src/fatfs/fatfs.c:674: SetWindowBlock(SAVE_BLOCK);
	ld	de, $03FF
	call	_SetWindowBlock
;src/fatfs/fatfs.c:675: if (!(result = f_write(&save_file, WINDOW, fill, &done)) && done != fill) result = FR_DENIED;
	ld	hl, 197
	add	hl, sp
	ld	e, l
	ld	d, h
	push	de
	ld	hl, 201
	add	hl, sp
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	push	de
	ld	bc, $BE00
	ld	de, _save_file
	call	_f_write__far
	ld	hl, 225
	add	hl, sp
	ld	[hl], a
	or	a, a
	jp	NZ, .l00130
	ld	hl, 197
	add	hl, sp
	ld	a, [hl]
	inc	hl
	inc	hl
	sub	a, [hl]
	jp	NZ,.l00326
	dec	hl
	ld	a, [hl]
	inc	hl
	inc	hl
	sub	a, [hl]
	jp	NZ,.l00326
	jp	.l00130
.l00326:
	ld	hl, 225
	add	hl, sp
	ld	[hl], $07
.l00130:
;src/fatfs/fatfs.c:676: SetWindowBlock(TB_PSRAM_HIGH << 8);
	ld	de, $0100
	call	_SetWindowBlock
.l00133:
;src/fatfs/fatfs.c:678: if (!result) result = f_close(&save_file);
	ld	hl, 225
	add	hl, sp
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00136
	ld	de, _save_file
	call	_f_close__far
	ld	hl, 225
	add	hl, sp
	ld	[hl], a
	jp	.l00137
.l00136:
;src/fatfs/fatfs.c:679: else f_close(&save_file);
	ld	de, _save_file
	call	_f_close__far
.l00137:
;src/fatfs/fatfs.c:680: if (result) return result;
	ld	hl, 225
	add	hl, sp
	ld	a, [hl]
	or	a, a
	jp	Z, .l00139
	ld	a, [hl]
	jp	.l00152
.l00139:
;src/fatfs/fatfs.c:681: f_close(&file);
	ld	de, _file
	call	_f_close__far
;src/fatfs/fatfs.c:682: result = f_unlink(path);
	ld	hl, 214
	add	hl, sp
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_f_unlink__far
;src/fatfs/fatfs.c:683: if (result && result != FR_NO_FILE) return result;
	or	a, a
	jp	Z, .l00141
	cp	a, $04
	jp	NZ,.l00327
	jp	.l00141
.l00327:
	jp	.l00152
.l00141:
;src/fatfs/fatfs.c:684: if ((result = f_rename(temp, path)) || (result = Open(path, FA_READ))) return result;
	ld	hl, 214
	add	hl, sp
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	ld	hl, 4
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_f_rename__far
	ld	c, a
	or	a, a
	jp	NZ, .l00143
	ld	a, $01
	ld	hl, 214
	add	hl, sp
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_Open__far
	ld	c, a
	or	a, a
	jp	Z, .l00144
.l00143:
	ld	a, c
	jp	.l00152
.l00144:
;src/fatfs/fatfs.c:685: OneFilePiece();
	call	_OneFilePiece
;src/fatfs/fatfs.c:686: win_start = start;
	ld	hl, 201
	add	hl, sp
	ld	d, h
	ld	e, l
	ld	hl, _win_start
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
;src/fatfs/fatfs.c:687: win_mark = NO_MARK;
	ld	hl, _win_mark
	ld	[hl], $FF
	inc	hl
	ld	[hl], $FF
	inc	hl
	ld	[hl], $FF
	inc	hl
	ld	[hl], $FF
;src/fatfs/fatfs.c:688: return fs_LoadWindow();
	call	_fs_LoadWindow
.l00152:
;src/fatfs/fatfs.c:689: }
	add	sp, 127
	add	sp, 99
	ret
	SECTION FRAGMENT "src/fatfs/fatfs.c ROM0",ROM0
___src_fatfs_fatfs_c_str_5:
	DB "~EDITOR.TMP"
	DB $00
;src/fatfs/fatfs.c:711: static UINT RegistrySum(void) {
;	---------------------------------
	SECTION FRAGMENT "Page 12",ROMX,BANK[6]
	LOAD FRAGMENT "Page 12 RAM",SRAM,BANK[12]
; Function RegistrySum
; ---------------------------------
_RegistrySum:
	add	sp, -3
;src/fatfs/fatfs.c:712: UINT done = 0;
	xor	a, a
	ld	hl, sp+0
	ld	[hl], a
	inc	hl
	ld	[hl], a
;src/fatfs/fatfs.c:713: if (!f_open(&save_file, REGISTRY, FA_READ)) {
	ld	a, $01
	push	af
	inc	sp
	ld	bc, ___src_fatfs_fatfs_c_str_6
	ld	de, _save_file
	call	_f_open__far
	ld	hl, sp+2
	ld	[hl], a
	ld	hl, sp+2
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00104
;src/fatfs/fatfs.c:714: if (f_read(&save_file, buffer, FS_BUFFER_SIZE, &done)) done = 0;
	ld	hl, 0
	add	hl, sp
	ld	e, l
	ld	d, h
	push	de
	ld	de, $0200
	push	de
	ld	bc, _buffer
	ld	de, _save_file
	call	_f_read__far
	or	a, a
	jp	Z, .l00102
	xor	a, a
	ld	hl, sp+0
	ld	[hl], a
	inc	hl
	ld	[hl], a
.l00102:
;src/fatfs/fatfs.c:715: f_close(&save_file);
	ld	de, _save_file
	call	_f_close__far
.l00104:
;src/fatfs/fatfs.c:717: game_cheats = done > 2 ? buffer[2] : 1;
	ld	hl, sp+0
	ld	a, $02
	sub	a, [hl]
	inc	hl
	ld	a, $00
	sbc	a, [hl]
	jp	NC, .l00107
	ld	a, [(_buffer + 2) + 0]
	ld	l, $00
;	spillPairReg hl
;	spillPairReg hl
	jp	.l00108
.l00107:
	ld	a, $01
	ld	l, $00
;	spillPairReg hl
;	spillPairReg hl
.l00108:
	ld	[_game_cheats], a
;src/fatfs/fatfs.c:718: game_config = done > 6 && !buffer[5] ? 0x28 : 0x08;
	ld	hl, sp+0
	ld	a, $06
	sub	a, [hl]
	inc	hl
	ld	a, $00
	sbc	a, [hl]
	ld	a, $00
	rla
	ld	c, a
	bit	0, c
	jp	Z, .l00109
	ld	a, [(_buffer + 5) + 0]
	or	a, a
	jp	NZ, .l00109
	ld	de, $0028
	jp	.l00110
.l00109:
	ld	de, $0008
.l00110:
	ld	hl, _game_config
	ld	[hl], e
;src/fatfs/fatfs.c:719: game_bd20 = done > 6 && buffer[6] ? 0 : 3;
	bit	0, c
	jp	Z, .l00114
	ld	a, [(_buffer + 6) + 0]
	or	a, a
	jp	Z, .l00114
	xor	a, a
	ld	l, a
;	spillPairReg hl
;	spillPairReg hl
	jp	.l00115
.l00114:
	ld	a, $03
	ld	l, $00
;	spillPairReg hl
;	spillPairReg hl
.l00115:
	ld	[_game_bd20], a
;src/fatfs/fatfs.c:720: return done ? ByteSum(buffer, done) + done : 0;
	ld	hl, sp+1
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	jp	Z, .l00119
	pop	bc
	push	bc
	ld	de, _buffer
	call	_ByteSum
	pop	hl
	push	hl
	add	hl, bc
	ld	c, l
	ld	b, h
	jp	.l00120
.l00119:
	ld	bc, $0000
.l00120:
.l00105:
;src/fatfs/fatfs.c:721: }
	add	sp, 3
	ret
	SECTION FRAGMENT "src/fatfs/fatfs.c ROM0",ROM0
___src_fatfs_fatfs_c_str_6:
	DB "/GBCSYS/REGISTRY.BIN"
	DB $00
;src/fatfs/fatfs.c:725: static void SaveRamBlock(UINT block, BYTE on) {
;	---------------------------------
	SECTION FRAGMENT "Page 15",ROMX,BANK[7]
	LOAD FRAGMENT "Page 15 RAM",SRAM,BANK[15]
; Function SaveRamBlock
; ---------------------------------
_SaveRamBlock:
	ld	c, a
;src/fatfs/fatfs.c:726: SetWindowBlock(block);
	push	bc
	call	_SetWindowBlock
	pop	bc
;src/fatfs/fatfs.c:727: if (on) rEDX_CONFIG |= 2;
	ld	hl, $BD06
	ld	b, [hl]
	ld	a, c
	or	a, a
	jp	Z, .l00102
	set	1, b
	ld	hl, $BD06
	ld	[hl], b
	jp	.l00104
.l00102:
;src/fatfs/fatfs.c:728: else rEDX_CONFIG &= ~2;
	res	1, b
	ld	hl, $BD06
	ld	[hl], b
.l00104:
;src/fatfs/fatfs.c:729: }
	ret
	SECTION FRAGMENT "Page 15",ROMX,BANK[7]
	LOAD FRAGMENT "Page 15 RAM",SRAM,BANK[15]
_battery_types:
	DB $03	; 3
	DB $06	; 6
	DB $09	; 9
	DB $0D	; 13
	DB $0F	; 15
	DB $10	; 16
	DB $13	; 19
	DB $17	; 23
	DB $1B	; 27
	DB $1E	; 30
	DB $22	; 34
	DB $FF	; 255
	DB $00	; 0
;src/fatfs/fatfs.c:732: static FRESULT SaveRamFile(UINT sectors, BYTE write) {
;	---------------------------------
	SECTION FRAGMENT "Page 15",ROMX,BANK[7]
	LOAD FRAGMENT "Page 15 RAM",SRAM,BANK[15]
; Function SaveRamFile
; ---------------------------------
_SaveRamFile:
	add	sp, -8
	ld	hl, sp+4
	ld	[hl], e
	inc	hl
	ld	[hl], d
	dec	hl
	dec	hl
	ld	[hl], a
;src/fatfs/fatfs.c:734: FRESULT result = FR_OK;
	dec	hl
	ld	[hl], $00
;src/fatfs/fatfs.c:735: for (block = 0; !result && block < sectors; ++block) {
	xor	a, a
	ld	hl, sp+6
	ld	[hl], a
	inc	hl
	ld	[hl], a
.l00112:
	ld	hl, sp+2
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00109
	ld	hl, sp+6
	ld	e, l
	ld	d, h
	ld	hl, sp+4
	ld	a, [de]
	inc	de
	sub	a, [hl]
	inc	hl
	ld	a, [de]
	sbc	a, [hl]
	jp	NC, .l00109
;src/fatfs/fatfs.c:736: if (write) {
	ld	hl, sp+3
	ld	a, [hl]
	or	a, a
	jp	Z, .l00107
;src/fatfs/fatfs.c:737: SaveRamBlock(block, 1);
	ld	a, $01
	ld	hl, sp+6
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_SaveRamBlock
;src/fatfs/fatfs.c:738: if (!(result = f_write(&save_file, WINDOW, 512, &done)) && done != 512) result = FR_DENIED;
	ld	hl, 0
	add	hl, sp
	ld	e, l
	ld	d, h
	push	de
	ld	de, $0200
	push	de
	ld	bc, $BE00
	ld	de, _save_file
	call	_f_write__far
	ld	hl, sp+2
	ld	[hl], a
	or	a, a
	jp	NZ, .l00108
	dec	hl
	dec	hl
	ld	a, [hl]
	or	a, a
	jp	NZ,.l00152
	inc	hl
	ld	a, [hl]
	sub	a, $02
	jp	NZ,.l00152
	jp	.l00108
.l00152:
	ld	hl, sp+2
	ld	[hl], $07
	jp	.l00108
.l00107:
;src/fatfs/fatfs.c:741: if (!(result = f_read(&save_file, buffer, 512, &done))) memset(buffer + done, 0xFF, 512 - done);
	ld	hl, 0
	add	hl, sp
	ld	e, l
	ld	d, h
	push	de
	ld	de, $0200
	push	de
	ld	bc, _buffer
	ld	de, _save_file
	call	_f_read__far
	ld	hl, sp+2
	ld	[hl], a
	or	a, a
	jp	NZ, .l00105
	ld	de, $0200
	pop	hl
	push	hl
	ld	a, e
	sub	a, l
	ld	e, a
	ld	a, d
	sbc	a, h
	ld	b, a
	ld	c, e
	ld	de, _buffer
	pop	hl
	push	hl
	add	hl, de
	ld	e, l
	ld	d, h
	push	bc
	ld	bc, $00FF
	call	_memset
.l00105:
;src/fatfs/fatfs.c:742: SaveRamBlock(block, 1);
	ld	a, $01
	ld	hl, sp+6
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_SaveRamBlock
;src/fatfs/fatfs.c:743: memcpy(WINDOW, buffer, 512);
	ld	de, $0200
	push	de
	ld	bc, _buffer
	ld	de, $BE00
	call	___memcpy
.l00108:
;src/fatfs/fatfs.c:745: SaveRamBlock(TB_PSRAM_HIGH << 8, 0);
	xor	a, a
	ld	de, $0100
	call	_SaveRamBlock
;src/fatfs/fatfs.c:735: for (block = 0; !result && block < sectors; ++block) {
	ld	hl, sp+6
	inc	[hl]
	jp	NZ, .l00153
	inc	hl
	inc	[hl]
.l00153:
	jp	.l00112
.l00109:
;src/fatfs/fatfs.c:747: return result;
	ld	hl, sp+2
	ld	a, [hl]
.l00114:
;src/fatfs/fatfs.c:748: }
	add	sp, 8
	ret
;src/fatfs/fatfs.c:756: unsigned char fs_BackupSave(void) {
;	---------------------------------
	SECTION FRAGMENT "Page 15",ROMX,BANK[7]
	LOAD FRAGMENT "Page 15 RAM",SRAM,BANK[15]
; Function fs_BackupSave
; ---------------------------------
_fs_BackupSave::
	add	sp, -128
	add	sp, -52
;src/fatfs/fatfs.c:758: BYTE path = 7, rtc = 0;
	ld	hl, 171
	add	hl, sp
	ld	[hl], $07
	inc	hl
	ld	[hl], $00
;src/fatfs/fatfs.c:760: FRESULT result = fs_Mount();
	call	_fs_Mount__far
	ld	hl, 179
	add	hl, sp
	ld	[hl], a
;src/fatfs/fatfs.c:761: backup_skipped = 0;
	ld	hl, _backup_skipped
	ld	[hl], $00
;src/fatfs/fatfs.c:762: if (result) return result;
	ld	hl, 179
	add	hl, sp
	ld	a, [hl]
	or	a, a
	jp	Z, .l00102
	ld	a, [hl]
	jp	.l00150
.l00102:
;src/fatfs/fatfs.c:763: sum = RegistrySum();
	call	_RegistrySum__far
	ld	hl, 173
	add	hl, sp
	ld	[hl], c
	inc	hl
	ld	[hl], b
;src/fatfs/fatfs.c:764: if (f_open(&save_file, GAME_RECORD, FA_READ)) return BackupRegistry(sum);
	ld	a, $01
	push	af
	inc	sp
	ld	bc, ___src_fatfs_fatfs_c_str_8
	ld	de, _save_file
	call	_f_open__far
	or	a, a
	jp	Z, .l00104
	ld	hl, 173
	add	hl, sp
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_BackupRegistry__far
	jp	.l00150
.l00104:
;src/fatfs/fatfs.c:765: result = f_read(&save_file, buffer, 255, &done); f_close(&save_file);
	ld	hl, 2
	add	hl, sp
	ld	e, l
	ld	d, h
	push	de
	ld	de, $00FF
	push	de
	ld	bc, _buffer
	ld	de, _save_file
	call	_f_read__far
	ld	hl, 179
	add	hl, sp
	ld	[hl], a
	ld	de, _save_file
	call	_f_close__far
;src/fatfs/fatfs.c:766: if (result) return result;
	ld	hl, 179
	add	hl, sp
	ld	a, [hl]
	or	a, a
	jp	Z, .l00106
	ld	a, [hl]
	jp	.l00150
.l00106:
;src/fatfs/fatfs.c:767: if (done < 8) return FR_INT_ERR;
	ld	hl, sp+2
	ld	a, [hl]
	sub	a, $08
	inc	hl
	ld	a, [hl]
	sbc	a, $00
	jp	NC, .l00108
	ld	a, $02
	jp	.l00150
.l00108:
;src/fatfs/fatfs.c:768: if (!buffer[4]) return ld_16(buffer + 5) == sum ? FR_OK : BackupRegistry(sum);
	ld	hl, (_buffer + 4) + 0
	ld	c, [hl]
	ld	a, c
	or	a, a
	jp	NZ, .l00110
	ld	de, (_buffer + 5)
	call	_ld_16
	ld	hl, 173
	add	hl, sp
	ld	a, [hl]
	sub	a, c
	jp	NZ,.l00287
	inc	hl
	ld	a, [hl]
	sub	a, b
	jp	NZ,.l00287
	jp	.l00288
.l00287:
	jp	.l00152
.l00288:
	xor	a, a
	ld	hl, 178
	add	hl, sp
	ld	[hl], a
	inc	hl
	ld	[hl], a
	jp	.l00153
.l00152:
	ld	hl, 173
	add	hl, sp
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_BackupRegistry__far
	ld	hl, 178
	add	hl, sp
	ld	[hl], a
	inc	hl
	ld	[hl], $00
.l00153:
	ld	hl, 178
	add	hl, sp
	ld	a, [hl]
	jp	.l00150
.l00110:
;src/fatfs/fatfs.c:769: if (!memcmp(buffer, "GAM1", 4)) path = 5;
	ld	de, $0004
	push	de
	ld	bc, ___src_fatfs_fatfs_c_str_9
	ld	de, _buffer
	call	_memcmp
	ld	a, b
	or	a, c
	jp	NZ, .l00119
	ld	hl, 171
	add	hl, sp
	ld	[hl], $05
	jp	.l00120
.l00119:
;src/fatfs/fatfs.c:770: else if (!memcmp(buffer, "GAM3", 4)) { if (done < 11) return FR_INT_ERR; path = 10; rtc = buffer[7]; }
	ld	de, $0004
	push	de
	ld	bc, ___src_fatfs_fatfs_c_str_10
	ld	de, _buffer
	call	_memcmp
	ld	a, b
	or	a, c
	jp	NZ, .l00116
	ld	hl, sp+2
	ld	a, [hl]
	sub	a, $0B
	inc	hl
	ld	a, [hl]
	sbc	a, $00
	jp	NC, .l00112
	ld	a, $02
	jp	.l00150
.l00112:
	ld	hl, 171
	add	hl, sp
	ld	[hl], $0A
	ld	hl, (_buffer + 7) + 0
	ld	a, [hl]
	ld	hl, 172
	add	hl, sp
	ld	[hl], a
	jp	.l00120
.l00116:
;src/fatfs/fatfs.c:771: else if (memcmp(buffer, "GAM2", 4)) return FR_INT_ERR;
	ld	de, $0004
	push	de
	ld	bc, ___src_fatfs_fatfs_c_str_11
	ld	de, _buffer
	call	_memcmp
	ld	a, b
	or	a, c
	jp	Z, .l00120
	ld	a, $02
	jp	.l00150
.l00120:
;src/fatfs/fatfs.c:772: sectors = path == 10 ? buffer[8] | ((UINT)buffer[9] << 8) : (UINT)buffer[4] << 4;
	ld	hl, 171
	add	hl, sp
	ld	a, [hl]
	sub	a, $0A
	jp	NZ,.l00289
	ld	a,$01
	jp	.l00290
.l00289:
	xor	a,a
.l00290:
	ld	hl, 175
	add	hl, sp
	ld	[hl], a
	ld	a, [hl]
	or	a, a
	jp	Z, .l00154
	ld	hl, (_buffer + 8) + 0
	ld	a, [hl]
	ld	hl, 179
	add	hl, sp
	ld	[hl], a
	ld	hl, (_buffer + 9) + 0
	ld	a, [hl]
	ld	hl, 178
	add	hl, sp
	ld	[hl], a
	ld	hl, 178
	add	hl, sp
	ld	a, [hl]
	dec	hl
	ld	[hl], a
	inc	hl
	ld	[hl], $00
	dec	hl
	ld	a, [hl]
	ld	hl, sp+1
	ld	[hl], a
	dec	hl
	ld	[hl], $00
	ld	hl, 179
	add	hl, sp
	ld	a, [hl]
	ld	hl, 176
	add	hl, sp
	ld	[hl], a
	inc	hl
	ld	[hl], $00
	dec	hl
	ld	a, [hl]
	ld	hl, sp+0
	or	a, [hl]
	ld	hl, 178
	add	hl, sp
	ld	[hl], a
	dec	hl
	ld	a, [hl]
	ld	hl, sp+1
	or	a, [hl]
	ld	hl, 179
	add	hl, sp
	ld	[hl], a
	jp	.l00155
.l00154:
	ld	a, [(_buffer + 4) + 0]
	ld	c, a
	ld	b, $00
	sla	c
	rl	b
	sla	c
	rl	b
	sla	c
	rl	b
	sla	c
	rl	b
	ld	hl, 178
	add	hl, sp
	ld	[hl], c
	inc	hl
	ld	[hl], b
.l00155:
	ld	hl, 178
	add	hl, sp
	ld	a, [hl]
	dec	hl
	dec	hl
	ld	[hl], a
	ld	hl, 179
	add	hl, sp
	ld	a, [hl]
	dec	hl
	dec	hl
	ld	[hl], a
;src/fatfs/fatfs.c:773: if (path != 5 && ld_16(buffer + 5) != sum) { backup_skipped = 1; return BackupRegistry(sum); }
	ld	hl, 171
	add	hl, sp
	ld	a, [hl]
	sub	a, $05
	jp	NZ,.l00292
	jp	.l00139
.l00292:
	ld	de, (_buffer + 5)
	call	_ld_16
	ld	hl, 178
	add	hl, sp
	ld	[hl], c
	inc	hl
	ld	[hl], b
	ld	hl, 173
	add	hl, sp
	ld	a, [hl]
	ld	hl, 178
	add	hl, sp
	sub	a, [hl]
	jp	NZ,.l00293
	ld	hl, 174
	add	hl, sp
	ld	a, [hl]
	ld	hl, 179
	add	hl, sp
	sub	a, [hl]
	jp	NZ,.l00293
	jp	.l00139
.l00293:
	ld	hl, _backup_skipped
	ld	[hl], $01
	ld	hl, 173
	add	hl, sp
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_BackupRegistry__far
	jp	.l00150
.l00139:
;src/fatfs/fatfs.c:775: buffer[254] = 0;
	ld	hl, (_buffer + 254)
	ld	[hl], $00
;src/fatfs/fatfs.c:776: for (i = 0; i < sizeof(saved) - 1 && (saved[i] = buffer[path + i]); ++i);
	xor	a, a
	ld	hl, 173
	add	hl, sp
	ld	[hl], a
	inc	hl
	ld	[hl], a
.l00148:
	ld	hl, 174
	add	hl, sp
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $0001
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, 180
	add	hl, sp
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, 179
	add	hl, sp
	ld	[hl], a
	ld	hl, 173
	add	hl, sp
	ld	a, [hl]
	sub	a, $52
	inc	hl
	ld	a, [hl]
	sbc	a, $00
	jp	NC, .l00182
	push	hl
	ld	hl, 6
	add	hl, sp
	ld	e, l
	ld	d, h
	pop	hl
	ld	hl, 173
	add	hl, sp
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	add	hl, de
	ld	c, l
	ld	b, h
	ld	hl, 171
	add	hl, sp
	ld	e, [hl]
	ld	d, $00
	inc	hl
	inc	hl
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	add	hl, de
	ld	e, l
	ld	d, h
	ld	hl, _buffer
	add	hl, de
	ld	a, [hl]
	ld	[bc], a
	or	a, a
	jp	Z, .l00182
	ld	hl, 178
	add	hl, sp
	ld	a, [hl]
	ld	hl, 173
	add	hl, sp
	ld	[hl], a
	ld	hl, 179
	add	hl, sp
	ld	a, [hl]
	ld	hl, 174
	add	hl, sp
	ld	[hl], a
	jp	.l00148
.l00182:
	ld	hl, 173
	add	hl, sp
	ld	a, [hl]
	ld	hl, sp+0
	ld	[hl], a
	ld	hl, 174
	add	hl, sp
	ld	a, [hl]
	ld	hl, sp+1
	ld	[hl], a
;src/fatfs/fatfs.c:777: if (i == sizeof(saved) - 1 || i < 4) return FR_INT_ERR;
	ld	hl, 173
	add	hl, sp
	ld	a, [hl]
	sub	a, $52
	inc	hl
	or	a, [hl]
	jp	NZ,.l00294
	jp	.l00122
.l00294:
	ld	hl, 173
	add	hl, sp
	ld	a, [hl]
	sub	a, $04
	inc	hl
	ld	a, [hl]
	sbc	a, $00
	jp	NC, .l00123
.l00122:
	ld	a, $02
	jp	.l00150
.l00123:
;src/fatfs/fatfs.c:778: memcpy(bak, saved, i + 1); memcpy(bak + i - 3, "bak", 3);
	ld	hl, 178
	add	hl, sp
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	push	de
	ld	hl, 6
	add	hl, sp
	ld	c, l
	ld	b, h
	ld	hl, 89
	add	hl, sp
	ld	e, l
	ld	d, h
	call	___memcpy
	push	hl
	ld	hl, 89
	add	hl, sp
	ld	e, l
	ld	d, h
	pop	hl
	ld	hl, 173
	add	hl, sp
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, 180
	add	hl, sp
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, 179
	add	hl, sp
	ld	[hl], a
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $0003
	ld	a, e
	sub	a, l
	ld	e, a
	ld	a, d
	sbc	a, h
	ld	hl, 174
	add	hl, sp
	ld	[hl], a
	dec	hl
	ld	[hl], e
	ld	a, [hl]
	ld	hl, 178
	add	hl, sp
	ld	[hl], a
	ld	hl, 174
	add	hl, sp
	ld	a, [hl]
	ld	hl, 179
	add	hl, sp
	ld	[hl], a
	ld	de, $0003
	push	de
	ld	bc, ___src_fatfs_fatfs_c_str_12
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	___memcpy
;src/fatfs/fatfs.c:779: if (sectors) {
	ld	hl, 177
	add	hl, sp
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	jp	Z, .l00130
;src/fatfs/fatfs.c:780: f_unlink(bak); f_rename(saved, bak);
	ld	hl, 87
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_f_unlink__far
	ld	hl, 87
	add	hl, sp
	ld	c, l
	ld	b, h
	ld	hl, 4
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_f_rename__far
;src/fatfs/fatfs.c:781: if ((result = f_open(&save_file, saved, FA_WRITE | FA_CREATE_ALWAYS))) return result;
	ld	a, $0A
	push	af
	inc	sp
	ld	hl, 5
	add	hl, sp
	ld	c, l
	ld	b, h
	ld	de, _save_file
	call	_f_open__far
	ld	c, a
	or	a, a
	jp	Z, .l00126
	ld	a, c
	jp	.l00150
.l00126:
;src/fatfs/fatfs.c:782: result = SaveRamFile(sectors, 1); f_close(&save_file); if (result) return result;
	ld	a, $01
	ld	hl, 176
	add	hl, sp
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_SaveRamFile
	ld	hl, 179
	add	hl, sp
	ld	[hl], a
	ld	de, _save_file
	call	_f_close__far
	ld	hl, 179
	add	hl, sp
	ld	a, [hl]
	or	a, a
	jp	Z, .l00130
	ld	a, [hl]
	jp	.l00150
.l00130:
;src/fatfs/fatfs.c:784: if (rtc) { memcpy(saved + i - 3, "rtc", 3); if ((result = WriteGameRTC(saved))) return result; }
	ld	hl, 172
	add	hl, sp
	ld	a, [hl]
	or	a, a
	jp	Z, .l00134
	push	hl
	ld	hl, 6
	add	hl, sp
	ld	e, l
	ld	d, h
	pop	hl
	pop	hl
	push	hl
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, 180
	add	hl, sp
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, 179
	add	hl, sp
	ld	[hl], a
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $0003
	ld	a, e
	sub	a, l
	ld	e, a
	ld	a, d
	sbc	a, h
	ld	hl, 174
	add	hl, sp
	ld	[hl], a
	dec	hl
	ld	[hl], e
	ld	a, [hl]
	ld	hl, 178
	add	hl, sp
	ld	[hl], a
	ld	hl, 174
	add	hl, sp
	ld	a, [hl]
	ld	hl, 179
	add	hl, sp
	ld	[hl], a
	ld	de, $0003
	push	de
	ld	bc, ___src_fatfs_fatfs_c_str_13
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	___memcpy
	ld	hl, 4
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_WriteGameRTC__far
	ld	hl, 178
	add	hl, sp
	ld	[hl], a
	ld	hl, 178
	add	hl, sp
	ld	a, [hl]
	inc	hl
	ld	[hl], a
	dec	hl
	ld	a, [hl]
	or	a, a
	jp	Z, .l00134
	inc	hl
	ld	a, [hl]
	jp	.l00150
.l00134:
;src/fatfs/fatfs.c:786: if (path == 10 && (result = BackupSnapshot(saved, sectors))) return result;
	ld	hl, 175
	add	hl, sp
	ld	a, [hl]
	or	a, a
	jp	Z, .l00140
	inc	hl
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	ld	hl, 4
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_BackupSnapshot__far
	ld	c, a
	or	a, a
	jp	Z, .l00140
	ld	a, c
	jp	.l00150
.l00140:
;src/fatfs/fatfs.c:788: if (!(result = f_open(&save_file, GAME_RECORD, FA_WRITE))) {
	ld	a, $02
	push	af
	inc	sp
	ld	bc, ___src_fatfs_fatfs_c_str_8
	ld	de, _save_file
	call	_f_open__far
	ld	c, a
	or	a, a
	jp	NZ, .l00145
;src/fatfs/fatfs.c:789: const BYTE finished = 0;
	ld	hl, 170
	add	hl, sp
	ld	[hl], $00
;src/fatfs/fatfs.c:790: result = f_lseek(&save_file, 4);
	ld	de, $0000
	push	de
	ld	e, $04
	push	de
	ld	de, _save_file
	call	_f_lseek__far
	ld	c, a
;src/fatfs/fatfs.c:791: if (!result) result = f_write(&save_file, &finished, 1, &done);
	ld	a, c
	or	a, a
	jp	NZ, .l00143
	ld	hl, 170
	add	hl, sp
	ld	c, l
	ld	b, h
	ld	de, _save_file
	ld	hl, 2
	add	hl, sp
	push	hl
	ld	hl, $0001
	push	hl
	call	_f_write__far
	ld	c, a
.l00143:
;src/fatfs/fatfs.c:792: f_close(&save_file);
	push	bc
	ld	de, _save_file
	call	_f_close__far
	pop	bc
.l00145:
;src/fatfs/fatfs.c:794: return result;
	ld	a, c
.l00150:
;src/fatfs/fatfs.c:795: }
	add	sp, 127
	add	sp, 53
	ret
	SECTION FRAGMENT "src/fatfs/fatfs.c ROM0",ROM0
__str_7:
	DB "/GBCSYS/SAVE/"
	DB $00
	SECTION FRAGMENT "src/fatfs/fatfs.c ROM0",ROM0
___src_fatfs_fatfs_c_str_8:
	DB "/GBCSYS/EDITOR.GAM"
	DB $00
	SECTION FRAGMENT "src/fatfs/fatfs.c ROM0",ROM0
___src_fatfs_fatfs_c_str_9:
	DB "GAM1"
	DB $00
	SECTION FRAGMENT "src/fatfs/fatfs.c ROM0",ROM0
___src_fatfs_fatfs_c_str_10:
	DB "GAM3"
	DB $00
	SECTION FRAGMENT "src/fatfs/fatfs.c ROM0",ROM0
___src_fatfs_fatfs_c_str_11:
	DB "GAM2"
	DB $00
	SECTION FRAGMENT "src/fatfs/fatfs.c ROM0",ROM0
___src_fatfs_fatfs_c_str_12:
	DB "bak"
	DB $00
	SECTION FRAGMENT "src/fatfs/fatfs.c ROM0",ROM0
___src_fatfs_fatfs_c_str_13:
	DB "rtc"
	DB $00
;src/fatfs/fatfs.c:807: unsigned char fs_GameOpen(const char* path) {
;	---------------------------------
	SECTION FRAGMENT "Page 15",ROMX,BANK[7]
	LOAD FRAGMENT "Page 15 RAM",SRAM,BANK[15]
; Function fs_GameOpen
; ---------------------------------
_fs_GameOpen::
	add	sp, -17
	ld	hl, sp+15
	ld	[hl], e
	inc	hl
	ld	[hl], d
;src/fatfs/fatfs.c:812: if ((result = fs_BackupSave())) return result; // an earlier game's save first, or its progress is lost
	call	_fs_BackupSave
	ld	hl, sp+13
	ld	[hl], a
	ld	hl, sp+13
	ld	a, [hl]
	inc	hl
	ld	[hl], a
	dec	hl
	ld	a, [hl]
	or	a, a
	jp	Z, .l00102
	inc	hl
	ld	a, [hl]
	jp	.l00120
.l00102:
;src/fatfs/fatfs.c:813: if ((result = Open(path, FA_READ))) return result;
	ld	a, $01
	ld	hl, sp+15
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_Open__far
	ld	hl, sp+10
	ld	[hl], a
	or	a, a
	jp	Z, .l00104
	ld	a, [hl]
	jp	.l00120
.l00104:
;src/fatfs/fatfs.c:814: length = f_size(&file);
	ld	de, (_file + 10) + 0
	ld	a, [de]
	ld	hl, sp+11
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
;src/fatfs/fatfs.c:815: if (length > (unsigned long)GAME_BLOCKS << 9 || (result = f_read(&file, buffer, FS_BUFFER_SIZE, &done)) || done < 0x150) {
	ld	hl, sp+11
	ld	a, $00
	sub	a, [hl]
	inc	hl
	ld	a, $00
	sbc	a, [hl]
	inc	hl
	ld	a, $78
	sbc	a, [hl]
	inc	hl
	ld	a, $00
	sbc	a, [hl]
	jp	C, .l00105
	ld	hl, sp+4
	ld	c, l
	ld	b, h
	push	bc
	ld	de, $0200
	push	de
	ld	bc, _buffer
	ld	de, _file
	call	_f_read__far
	ld	hl, sp+10
	ld	[hl], a
	or	a, a
	jp	NZ, .l00105
	ld	hl, sp+4
	ld	a, [hl]
	sub	a, $50
	inc	hl
	ld	a, [hl]
	sbc	a, $01
	jp	NC, .l00106
.l00105:
;src/fatfs/fatfs.c:816: f_close(&file);
	ld	de, _file
	call	_f_close__far
;src/fatfs/fatfs.c:817: return result ? result : FR_DENIED;
	ld	hl, sp+10
	ld	a, [hl]
	or	a, a
	jp	Z, .l00122
	ld	a, [hl]
	ld	hl, sp+14
	ld	[hl], a
	jp	.l00123
.l00122:
	ld	hl, sp+14
	ld	[hl], $07
.l00123:
	ld	hl, sp+14
	ld	a, [hl]
	jp	.l00120
.l00106:
;src/fatfs/fatfs.c:819: memcpy(game_header, buffer + 0x134, 32);
	ld	de, $0020
	push	de
	ld	bc, (_buffer + 308)
	ld	de, _game_header
	call	___memcpy
;src/fatfs/fatfs.c:820: type = buffer[0x147];
	ld	hl, (_buffer + 327) + 0
	ld	a, [hl]
	ld	hl, sp+6
	ld	[hl], a
;src/fatfs/fatfs.c:821: game_has_rtc = type == 0x0F || type == 0x10;
	ld	hl, sp+6
	ld	a, [hl]
	sub	a, $0F
	jp	NZ,.l00307
	jp	.l00125
.l00307:
	ld	hl, sp+6
	ld	a, [hl]
	sub	a, $10
	jp	NZ,.l00308
	jp	.l00125
.l00308:
	xor	a, a
	jp	.l00126
.l00125:
	ld	a, $01
.l00126:
	ld	hl, _game_has_rtc
	ld	[hl], a
;src/fatfs/fatfs.c:822: game_mapper = !type || type == 8 || type == 9 ? 4 : type <= 3 ? 1 : type <= 6 ? 2 : type >= 0x0F && type <= 0x13 ? 3 : 5;
	ld	hl, sp+6
	ld	a, [hl]
	or	a, a
	jp	Z, .l00130
	ld	a, [hl]
	sub	a, $08
	jp	NZ,.l00309
	jp	.l00130
.l00309:
	ld	hl, sp+6
	ld	a, [hl]
	sub	a, $09
	jp	NZ,.l00310
	jp	.l00311
.l00310:
	jp	.l00127
.l00311:
.l00130:
	ld	hl, sp+9
	ld	[hl], $04
	xor	a, a
	inc	hl
	ld	[hl], a
	jp	.l00128
.l00127:
	ld	a, $03
	ld	hl, sp+6
	sub	a, [hl]
	jp	C, .l00135
	ld	de, $0001
	jp	.l00136
.l00135:
	ld	a, $06
	ld	hl, sp+6
	sub	a, [hl]
	jp	C, .l00137
	ld	de, $0002
	jp	.l00138
.l00137:
	ld	hl, sp+6
	ld	a, [hl]
	sub	a, $0F
	jp	C, .l00139
	ld	a, $13
	sub	a, [hl]
	jp	C, .l00139
	ld	de, $0003
	jp	.l00140
.l00139:
	ld	de, $0005
.l00140:
.l00138:
.l00136:
	ld	hl, sp+9
	ld	[hl], e
	inc	hl
	ld	[hl], d
.l00128:
	ld	hl, sp+9
	ld	a, [hl]
	ld	hl, _game_mapper
	ld	[hl], a
;src/fatfs/fatfs.c:823: size = buffer[0x149];
	ld	hl, (_buffer + 329) + 0
	ld	a, [hl]
	ld	hl, sp+7
	ld	[hl], a
;src/fatfs/fatfs.c:824: game_banks = size == 3 ? 4 : size == 4 ? 16 : size == 5 ? 8 : 1;
	ld	hl, sp+7
	ld	a, [hl]
	sub	a, $03
	jp	NZ,.l00312
	jp	.l00313
.l00312:
	jp	.l00144
.l00313:
	ld	hl, sp+9
	ld	[hl], $04
	xor	a, a
	inc	hl
	ld	[hl], a
	jp	.l00145
.l00144:
	ld	hl, sp+7
	ld	a, [hl]
	sub	a, $04
	jp	NZ,.l00314
	jp	.l00315
.l00314:
	jp	.l00146
.l00315:
	ld	hl, sp+9
	ld	[hl], $10
	xor	a, a
	inc	hl
	ld	[hl], a
	jp	.l00147
.l00146:
	ld	hl, sp+7
	ld	a, [hl]
	sub	a, $05
	jp	NZ,.l00316
	jp	.l00317
.l00316:
	jp	.l00148
.l00317:
	ld	hl, sp+9
	ld	[hl], $08
	xor	a, a
	inc	hl
	ld	[hl], a
	jp	.l00149
.l00148:
	ld	hl, sp+9
	ld	[hl], $01
	xor	a, a
	inc	hl
	ld	[hl], a
.l00149:
.l00147:
.l00145:
	ld	hl, sp+9
	ld	a, [hl]
	ld	hl, _game_banks
	ld	[hl], a
;src/fatfs/fatfs.c:825: game_ram_mask = game_mapper == 2 ? 0 : size == 1 || size == 2 ? 0 : game_banks - 1;
	ld	hl, _game_mapper
	ld	a, [hl]
	sub	a, $02
	jp	NZ,.l00318
	ld	a,$01
	jp	.l00319
.l00318:
	xor	a,a
.l00319:
	ld	hl, sp+8
	ld	[hl], a
	dec	hl
	ld	a, [hl]
	dec	a
	jp	NZ,.l00320
	ld	a,$01
	jp	.l00321
.l00320:
	xor	a,a
.l00321:
	ld	hl, sp+9
	ld	[hl], a
	dec	hl
	ld	a, [hl]
	or	a, a
	jp	Z, .l00150
	xor	a, a
	ld	hl, sp+2
	ld	[hl], a
	inc	hl
	ld	[hl], a
	jp	.l00151
.l00150:
	ld	hl, sp+9
	bit	0, [hl]
	jp	NZ, .l00155
	dec	hl
	dec	hl
	ld	a, [hl]
	sub	a, $02
	jp	NZ,.l00322
	jp	.l00323
.l00322:
	jp	.l00152
.l00323:
.l00155:
	xor	a, a
	ld	hl, sp+2
	ld	[hl], a
	inc	hl
	ld	[hl], a
	jp	.l00153
.l00152:
	ld	hl, _game_banks
	ld	a, [hl]
	ld	hl, sp+10
	ld	[hl], a
	ld	a, [hl]
	dec	a
	ld	hl, sp+2
	ld	[hl], a
	rlca
	sbc	a, a
	inc	hl
	ld	[hl], a
.l00153:
.l00151:
	ld	hl, sp+2
	ld	a, [hl]
	ld	hl, _game_ram_mask
	ld	[hl], a
;src/fatfs/fatfs.c:826: for (game_rom_mask = 0, length = (length + 0x7FFF) >> 15; length > 1; length = (length + 1) >> 1) game_rom_mask = (game_rom_mask << 1) | 1; // 32KB units
	ld	hl, _game_rom_mask
	ld	[hl], $00
	ld	hl, sp+12
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, e
	add	a, $FF
	ld	e, a
	ld	a, d
	adc	a, $7F
	push	af
	ld	hl, sp+3
	ld	[hl], a
	dec	hl
	ld	[hl], e
	ld	hl, sp+16
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
	ld	hl, sp+3
	ld	[hl], a
	dec	hl
	ld	[hl], e
	dec	hl
	ld	a, [hl]
	ld	hl, sp+10
	ld	[hl], a
	ld	hl, sp+2
	ld	a, [hl]
	ld	hl, sp+11
	ld	[hl], a
	ld	hl, sp+3
	ld	a, [hl]
	ld	hl, sp+12
	ld	[hl], a
	inc	hl
	ld	[hl], $00
	ld	a, $07
.l00324:
	ld	hl, sp+12
	srl	[hl]
	dec	hl
	rr	[hl]
	dec	hl
	rr	[hl]
.l00325:
	dec	a
	jr	NZ, .l00324
.l00114:
	ld	hl, sp+10
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
	jp	NC, .l00188
	ld	hl, _game_rom_mask
	ld	a, [hl]
	ld	hl, sp+14
	ld	[hl], a
	sla	[hl]
	ld	a, [hl]
	or	a, $01
	ld	hl, _game_rom_mask
	ld	[hl], a
	ld	hl, sp+11
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
	ld	hl, sp+3
	ld	[hl], a
	dec	hl
	ld	[hl], e
	ld	hl, sp+15
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
	ld	hl, sp+3
	ld	[hl], a
	dec	hl
	ld	[hl], e
	dec	hl
	dec	hl
	ld	a, [hl]
	ld	hl, sp+10
	ld	[hl], a
	ld	hl, sp+1
	ld	a, [hl]
	ld	hl, sp+11
	ld	[hl], a
	ld	hl, sp+2
	ld	a, [hl]
	ld	hl, sp+12
	ld	[hl], a
	ld	hl, sp+3
	ld	a, [hl]
	ld	hl, sp+13
	ld	[hl], a
	srl	[hl]
	dec	hl
	rr	[hl]
	dec	hl
	rr	[hl]
	dec	hl
	rr	[hl]
	jp	.l00114
;src/fatfs/fatfs.c:827: for (i = 0; battery_types[i] && battery_types[i] != type; ++i);
.l00188:
	ld	de, $0000
.l00118:
	ld	hl, _battery_types
	add	hl, de
	ld	b, [hl]
	ld	a, b
	or	a, a
	jp	Z, .l00110
	ld	hl, sp+6
	ld	a, [hl]
	sub	a, b
	jp	NZ,.l00328
	jp	.l00110
.l00328:
	inc	de
	jp	.l00118
.l00110:
;src/fatfs/fatfs.c:828: if (!battery_types[i]) game_banks = 0;
	ld	a, b
	or	a, a
	jp	NZ, .l00112
	ld	hl, _game_banks
	ld	[hl], $00
.l00112:
;src/fatfs/fatfs.c:829: game_save_sectors = !game_banks ? 0 : game_mapper == 2 ? 1 : !size ? 0 : size == 1 ? 4 : (UINT)game_banks << 4;
	ld	hl, _game_banks
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00157
	ld	bc, $0000
	jp	.l00158
.l00157:
	ld	hl, sp+8
	ld	a, [hl]
	or	a, a
	jp	Z, .l00159
	ld	bc, $0001
	jp	.l00160
.l00159:
	ld	hl, sp+7
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00161
	ld	bc, $0000
	jp	.l00162
.l00161:
	ld	hl, sp+9
	ld	a, [hl]
	or	a, a
	jp	Z, .l00163
	ld	bc, $0004
	jp	.l00164
.l00163:
	ld	hl, _game_banks
	ld	l, [hl]
;	spillPairReg hl
;	spillPairReg hl
	ld	h, $00
;	spillPairReg hl
;	spillPairReg hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	ld	c, l
	ld	b, h
.l00164:
.l00162:
.l00160:
.l00158:
	ld	hl, _game_save_sectors
	ld	[hl], c
	inc	hl
	ld	[hl], b
;src/fatfs/fatfs.c:830: game_blocks = (UINT)((f_size(&file) + 511) >> 9);
	ld	de, (_file + 10) + 0
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
	add	a, $FF
	ld	e, a
	ld	a, d
	adc	a, $01
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
	ld	a, $09
.l00329:
	ld	hl, sp+14
	srl	[hl]
	dec	hl
	rr	[hl]
	dec	hl
	rr	[hl]
	dec	hl
	rr	[hl]
.l00330:
	dec	a
	jr	NZ, .l00329
	ld	a, [hl]
	ld	hl, _game_blocks
	ld	[hl], a
	ld	hl, sp+12
	ld	a, [hl]
	ld	hl, _game_blocks + 1
	ld	[hl], a
;src/fatfs/fatfs.c:831: game_block = 0;
	xor	a, a
	ld	hl, _game_block
	ld	[hl], a
	inc	hl
	ld	[hl], a
;src/fatfs/fatfs.c:832: game_clst = file.obj.sclust;
	ld	de, (_file + 6) + 0
	ld	a, [de]
	ld	hl, _game_clst
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
;src/fatfs/fatfs.c:833: sd_fast = 1;
	ld	hl, _sd_fast
	ld	[hl], $01
;src/fatfs/fatfs.c:834: Signature(0); // the text in PSRAM gets overwritten, the next boot restores the swap file
	ld	de, $0000
	call	_Signature__far
;src/fatfs/fatfs.c:835: return FR_OK;
	xor	a, a
.l00120:
;src/fatfs/fatfs.c:836: }
	add	sp, 17
	ret
;src/fatfs/fatfs.c:839: static void GameSlow(void) {
;	---------------------------------
	SECTION FRAGMENT "Page 12",ROMX,BANK[6]
	LOAD FRAGMENT "Page 12 RAM",SRAM,BANK[12]
; Function GameSlow
; ---------------------------------
_GameSlow:
;src/fatfs/fatfs.c:840: sd_fast = 0;
	ld	hl, _sd_fast
	ld	[hl], $00
;src/fatfs/fatfs.c:841: game_block = 0;
	xor	a, a
	ld	hl, _game_block
	ld	[hl], a
	inc	hl
	ld	[hl], a
;src/fatfs/fatfs.c:842: game_clst = file.obj.sclust;
	ld	de, (_file + 6) + 0
	ld	a, [de]
	ld	hl, _game_clst
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
.l00101:
;src/fatfs/fatfs.c:843: }
	ret
;src/fatfs/fatfs.c:845: unsigned char fs_GameCopy(void) {
;	---------------------------------
	SECTION FRAGMENT "Page 12",ROMX,BANK[6]
	LOAD FRAGMENT "Page 12 RAM",SRAM,BANK[12]
; Function fs_GameCopy
; ---------------------------------
_fs_GameCopy::
	add	sp, -22
;src/fatfs/fatfs.c:846: FATFS* fs = file.obj.fs;
	ld	de, _file + 0
	ld	a, [de]
	ld	hl, sp+0
	ld	[hl], a
	inc	de
	ld	a, [de]
	inc	hl
	ld	[hl], a
;src/fatfs/fatfs.c:847: unsigned long next = game_clst, last;
	ld	hl, _game_clst
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
;src/fatfs/fatfs.c:848: UINT count = fs->csize, i;
	pop	de
	push	de
	ld	hl, $000A
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
	ld	c, a
	inc	de
	ld	a, [de]
	inc	hl
	ld	[hl], c
	inc	hl
	ld	[hl], a
;src/fatfs/fatfs.c:850: while (count < GAME_CHUNK && game_block + count < game_blocks) { // consecutive clusters
.l00104:
	ld	hl, sp+8
	ld	a, [hl]
	sub	a, $00
	inc	hl
	ld	a, [hl]
	sbc	a, $01
	jp	NC, .l00106
	ld	hl, _game_block + 1
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, sp+8
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	add	hl, de
	ld	c, l
	ld	b, h
	ld	hl, _game_blocks
	ld	a, c
	sub	a, [hl]
	inc	hl
	ld	a, b
	sbc	a, [hl]
	jp	NC, .l00106
;src/fatfs/fatfs.c:851: if ((last = get_fat(&file.obj, next)) != next + 1) break;
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
	ld	de, _file
	call	_get_fat__far
	ld	hl, sp+10
	ld	[hl], c
	inc	hl
	ld	[hl], b
	inc	hl
	ld	[hl], e
	inc	hl
	ld	[hl], d
	ld	hl, sp+10
	ld	d, h
	ld	e, l
	ld	hl, sp+14
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
	ld	hl, sp+3
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
	ld	hl, sp+21
	ld	[hl], a
	dec	hl
	ld	[hl], e
	ld	hl, sp+7
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
	ld	hl, sp+21
	ld	[hl], a
	dec	hl
	ld	[hl], e
	ld	hl, sp+10
	ld	a, [hl]
	ld	hl, sp+18
	sub	a, [hl]
	jp	NZ,.l00206
	ld	hl, sp+11
	ld	a, [hl]
	ld	hl, sp+19
	sub	a, [hl]
	jp	NZ,.l00206
	ld	hl, sp+12
	ld	a, [hl]
	ld	hl, sp+20
	sub	a, [hl]
	jp	NZ,.l00206
	ld	hl, sp+13
	ld	a, [hl]
	ld	hl, sp+21
	sub	a, [hl]
	jp	NZ,.l00206
	jp	.l00207
.l00206:
	jp	.l00106
.l00207:
;src/fatfs/fatfs.c:852: next = last;
	ld	hl, sp+14
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
;src/fatfs/fatfs.c:853: count += fs->csize;
	ld	hl, sp+7
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
	inc	hl
	ld	e, [hl]
	add	a, c
	ld	c, a
	ld	a, e
	adc	a, b
	ld	b, a
	dec	hl
	ld	[hl], c
	inc	hl
	ld	[hl], b
	jp	.l00104
.l00106:
;src/fatfs/fatfs.c:855: if (count > game_blocks - game_block) count = game_blocks - game_block;
	ld	hl, _game_blocks
	ld	a, [hl]
	ld	hl, _game_block
	sub	a, [hl]
	ld	c, a
	ld	hl, _game_blocks + 1
	ld	a, [hl]
	ld	hl, _game_block + 1
	sbc	a, [hl]
	ld	b, a
	ld	hl, sp+8
	ld	a, c
	sub	a, [hl]
	inc	hl
	ld	a, b
	sbc	a, [hl]
	jp	NC, .l00108
	ld	hl, sp+8
	ld	[hl], c
	inc	hl
	ld	[hl], b
.l00108:
;src/fatfs/fatfs.c:856: if (!(sd_sector = clst2sect(fs, game_clst)) || sd_ReadBlocks(game_block, count)) {
	ld	hl, _game_clst + 2
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	push	de
	ld	hl, _game_clst
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	push	de
	ld	hl, sp+4
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_clst2sect__far
	ld	hl, sp+18
	ld	[hl], c
	inc	hl
	ld	[hl], b
	inc	hl
	ld	[hl], e
	inc	hl
	ld	[hl], d
	ld	hl, sp+18
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
	ld	hl, sp+21
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	dec	hl
	or	a, [hl]
	dec	hl
	or	a, [hl]
	jp	Z, .l00111
	ld	hl, sp+8
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	ld	hl, _game_block
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_sd_ReadBlocks
	or	a, a
	jp	Z, .l00112
.l00111:
;src/fatfs/fatfs.c:857: SetWindowBlock(TB_PSRAM_HIGH << 8);
	ld	de, $0100
	call	_SetWindowBlock
;src/fatfs/fatfs.c:858: if (!sd_fast) return FR_DISK_ERR;
	ld	hl, _sd_fast
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00110
	ld	a, $01
	jp	.l00128
.l00110:
;src/fatfs/fatfs.c:859: GameSlow();
	call	_GameSlow
;src/fatfs/fatfs.c:860: return FR_OK;
	xor	a, a
	jp	.l00128
.l00112:
;src/fatfs/fatfs.c:862: game_block += count;
	ld	hl, _game_block + 1
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, sp+8
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	add	hl, de
	ld	e, l
	ld	d, h
	ld	hl, _game_block
	ld	[hl], e
	inc	hl
	ld	[hl], d
;src/fatfs/fatfs.c:863: if (game_block == game_blocks && sd_fast) { // the header checksum (a byte off before $14D breaks it)
	dec	hl
	ld	a, [hl]
	ld	hl, _game_blocks
	sub	a, [hl]
	jp	NZ,.l00208
	ld	hl, _game_block + 1
	ld	a, [hl]
	ld	hl, _game_blocks + 1
	sub	a, [hl]
	jp	NZ,.l00208
	jp	.l00209
.l00208:
	jp	.l00119
.l00209:
	ld	hl, _sd_fast
	ld	a, [hl]
	or	a, a
	jp	Z, .l00119
;src/fatfs/fatfs.c:864: SetWindowBlock(0);
	ld	de, $0000
	call	_SetWindowBlock
;src/fatfs/fatfs.c:865: for (check = 0, i = 0x134; i < 0x14D; ++i) check = check - WINDOW[i] - 1;
	ld	hl, sp+17
	ld	[hl], $00
	ld	hl, sp+20
	ld	[hl], $34
	inc	hl
	ld	[hl], $01
.l00126:
	ld	hl, sp+20
	ld	a, [hl]
	sub	a, $4D
	inc	hl
	ld	a, [hl]
	sbc	a, $01
	jp	NC, .l00114
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $BE00
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+20
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+19
	ld	[hl], a
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	ld	c, a
	dec	hl
	dec	hl
	ld	a, [hl]
	sub	a, c
	add	a, $FF
	ld	[hl], a
	ld	hl, sp+20
	inc	[hl]
	jp	NZ, .l00210
	inc	hl
	inc	[hl]
.l00210:
	jp	.l00126
.l00114:
;src/fatfs/fatfs.c:866: if ((BYTE)check != WINDOW[0x14D] || memcmp(WINDOW + 0x134, buffer + 0x134, 0x1C)) GameSlow(); // the header fs_GameOpen read
	ld	hl, $BF4D
	ld	c, [hl]
	ld	hl, sp+17
	ld	a, [hl]
	sub	a, c
	jp	NZ,.l00211
	jp	.l00212
.l00211:
	jp	.l00115
.l00212:
	ld	de, $001C
	push	de
	ld	bc, (_buffer + 308)
	ld	de, $BF34
	call	_memcmp
	ld	a, b
	or	a, c
	jp	Z, .l00119
.l00115:
	call	_GameSlow
.l00119:
;src/fatfs/fatfs.c:868: SetWindowBlock(TB_PSRAM_HIGH << 8);
	ld	de, $0100
	call	_SetWindowBlock
;src/fatfs/fatfs.c:869: if (game_block && game_block != game_blocks && (game_clst = get_fat(&file.obj, next)) < 2) return FR_INT_ERR;
	ld	hl, _game_block + 1
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	jp	Z, .l00122
	ld	a, [hl]
	ld	hl, _game_blocks
	sub	a, [hl]
	jp	NZ,.l00213
	ld	hl, _game_block + 1
	ld	a, [hl]
	ld	hl, _game_blocks + 1
	sub	a, [hl]
	jp	NZ,.l00213
	jp	.l00122
.l00213:
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
	ld	de, _file
	call	_get_fat__far
	ld	hl, sp+18
	ld	[hl], c
	inc	hl
	ld	[hl], b
	inc	hl
	ld	[hl], e
	inc	hl
	ld	[hl], d
	ld	hl, sp+18
	ld	d, h
	ld	e, l
	ld	hl, _game_clst
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
	ld	hl, sp+18
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
	jp	NC, .l00122
	ld	a, $02
	jp	.l00128
.l00122:
;src/fatfs/fatfs.c:870: return FR_OK;
	xor	a, a
.l00128:
;src/fatfs/fatfs.c:871: }
	add	sp, 22
	ret
;src/fatfs/fatfs.c:873: static void GamePath(char* out, const char* path, const char* extension) {
;	---------------------------------
	SECTION FRAGMENT "Page 6",ROMX,BANK[3]
	LOAD FRAGMENT "Page 6 RAM",SRAM,BANK[6]
; Function GamePath
; ---------------------------------
_GamePath:
	add	sp, -16
	ld	hl, sp+14
	ld	[hl], e
	inc	hl
	ld	[hl], d
	ld	hl, sp+12
	ld	[hl], c
	inc	hl
	ld	[hl], b
;src/fatfs/fatfs.c:874: UINT i, base = 0, dot = 0;
	xor	a, a
	ld	hl, sp+0
	ld	[hl], a
	inc	hl
	ld	[hl], a
	xor	a, a
	inc	hl
	ld	[hl], a
	inc	hl
	ld	[hl], a
;src/fatfs/fatfs.c:875: for (i = 0; path[i]; ++i) if (path[i] == '/') base = i + 1;
	ld	bc, $0000
.l00110:
	ld	hl, sp+12
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	add	hl, bc
	ld	e, l
	ld	d, h
	ld	a, [de]
	or	a, a
	jp	Z, .l00103
	inc	bc
	sub	a, $2F
	jp	NZ,.l00154
	jp	.l00155
.l00154:
	jp	.l00111
.l00155:
	inc	sp
	inc	sp
	push	bc
.l00111:
	jp	.l00110
.l00103:
;src/fatfs/fatfs.c:876: for (i = base; path[i]; ++i) if (path[i] == '.') dot = i;
	ld	hl, sp+0
	ld	a, [hl]
	ld	hl, sp+10
	ld	[hl], a
	ld	hl, sp+1
	ld	a, [hl]
	ld	hl, sp+11
	ld	[hl], a
.l00113:
	ld	hl, sp+13
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, sp+10
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, [bc]
	or	a, a
	jp	Z, .l00106
	sub	a, $2E
	jp	NZ,.l00156
	jp	.l00157
.l00156:
	jp	.l00114
.l00157:
	ld	hl, sp+10
	ld	a, [hl]
	ld	hl, sp+2
	ld	[hl], a
	ld	hl, sp+11
	ld	a, [hl]
	ld	hl, sp+3
	ld	[hl], a
.l00114:
	ld	hl, sp+10
	inc	[hl]
	jp	NZ, .l00158
	inc	hl
	inc	[hl]
.l00158:
	jp	.l00113
.l00106:
;src/fatfs/fatfs.c:877: if (!dot) dot = i;
	ld	hl, sp+3
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	jp	NZ, .l00108
	ld	hl, sp+10
	ld	a, [hl]
	ld	hl, sp+2
	ld	[hl], a
	ld	hl, sp+11
	ld	a, [hl]
	ld	hl, sp+3
	ld	[hl], a
.l00108:
;src/fatfs/fatfs.c:878: memcpy(out, SAVE_FOLDER, sizeof(SAVE_FOLDER) - 1);
	ld	hl, sp+14
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	bc, $000D
	push	bc
	ld	bc, ___src_fatfs_fatfs_c_str_14
	call	___memcpy
;src/fatfs/fatfs.c:879: memcpy(out + sizeof(SAVE_FOLDER) - 1, path + base, dot - base);
	ld	hl, sp+3
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	pop	hl
	push	hl
	ld	a, e
	sub	a, l
	ld	e, a
	ld	a, d
	sbc	a, h
	ld	hl, sp+5
	ld	[hl], a
	dec	hl
	ld	[hl], e
	ld	hl, sp+13
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	pop	hl
	push	hl
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
	ld	hl, sp+6
	ld	[hl], a
	ld	hl, sp+11
	ld	a, [hl]
	ld	hl, sp+7
	ld	[hl], a
	ld	hl, sp+15
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $000D
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
	ld	hl, sp+4
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	push	de
	inc	hl
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	ld	hl, sp+12
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	___memcpy
;src/fatfs/fatfs.c:880: memcpy(out + sizeof(SAVE_FOLDER) - 1 + dot - base, extension, 5);
	ld	hl, sp+18
	ld	a, [hl]
	ld	hl, sp+6
	ld	[hl], a
	ld	hl, sp+19
	ld	a, [hl]
	ld	hl, sp+7
	ld	[hl], a
	ld	hl, sp+3
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, sp+8
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
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
	pop	hl
	push	hl
	ld	a, e
	sub	a, l
	ld	e, a
	ld	a, d
	sbc	a, h
	ld	hl, sp+9
	ld	[hl], a
	dec	hl
	ld	[hl], e
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	bc, $0005
	push	bc
	ld	hl, sp+8
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	call	___memcpy
.l00115:
;src/fatfs/fatfs.c:881: }
	add	sp, 16
	pop	hl
	inc	sp
	inc	sp
	jp hl
	SECTION FRAGMENT "src/fatfs/fatfs.c ROM0",ROM0
___src_fatfs_fatfs_c_str_14:
	DB "/GBCSYS/SAVE/"
	DB $00
;src/fatfs/fatfs.c:882: static FRESULT ReadGameRTC(const char* path) {
;	---------------------------------
	SECTION FRAGMENT "Page 12",ROMX,BANK[6]
	LOAD FRAGMENT "Page 12 RAM",SRAM,BANK[12]
; Function ReadGameRTC
; ---------------------------------
_ReadGameRTC:
	add	sp, -20
;src/fatfs/fatfs.c:886: memset(rtc, 0, sizeof(rtc));
	push	de
	ld	bc, $000A
	push	bc
	ld	bc, $0000
	ld	hl, 4
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_memset
	pop	de
;src/fatfs/fatfs.c:887: if (!(result = f_open(&save_file, path, FA_READ))) {
	ld	a, $01
	push	af
	inc	sp
	ld	c, e
	ld	b, d
	ld	de, _save_file
	call	_f_open__far
	ld	hl, sp+18
	ld	[hl], a
	ld	hl, sp+18
	ld	a, [hl]
	inc	hl
	ld	[hl], a
	dec	hl
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00110
;src/fatfs/fatfs.c:888: result = f_read(&save_file, rtc, sizeof(rtc), &done);
	ld	hl, 10
	add	hl, sp
	ld	e, l
	ld	d, h
	push	de
	ld	de, $000A
	push	de
	ld	hl, 4
	add	hl, sp
	ld	c, l
	ld	b, h
	ld	de, _save_file
	call	_f_read__far
	ld	hl, sp+19
	ld	[hl], a
;src/fatfs/fatfs.c:889: f_close(&save_file);
	ld	de, _save_file
	call	_f_close__far
;src/fatfs/fatfs.c:890: if (!result && done != sizeof(rtc)) result = FR_INT_ERR;
	ld	hl, sp+19
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00102
	ld	hl, sp+10
	ld	a, [hl]
	sub	a, $0A
	inc	hl
	or	a, [hl]
	jp	NZ,.l00219
	jp	.l00102
.l00219:
	ld	hl, sp+19
	ld	[hl], $02
.l00102:
;src/fatfs/fatfs.c:891: if (result) return result;
	ld	hl, sp+19
	ld	a, [hl]
	or	a, a
	jp	Z, .l00111
	ld	a, [hl]
	jp	.l00131
.l00110:
;src/fatfs/fatfs.c:893: else if (result != FR_NO_FILE && result != FR_NO_PATH) return result;
	ld	hl, sp+19
	ld	a, [hl]
	sub	a, $04
	jp	NZ,.l00220
	jp	.l00111
.l00220:
	ld	hl, sp+19
	ld	a, [hl]
	sub	a, $05
	jp	NZ,.l00221
	jp	.l00111
.l00221:
	ld	hl, sp+19
	ld	a, [hl]
	jp	.l00131
.l00111:
;src/fatfs/fatfs.c:895: if ((rtc[4] & 0x40) && (rtc[9] & 0x40)) { memset(rtc, 0, sizeof(rtc)); result = FR_NO_FILE; }
	ld	hl, sp+4
	ld	a, [hl]
	bit	6, a
	jp	NZ,.l00222
	jp	.l00144
.l00222:
	ld	hl, sp+9
	ld	a, [hl]
	bit	6, a
	jp	NZ,.l00223
	jp	.l00144
.l00223:
	ld	de, $000A
	push	de
	ld	bc, $0000
	ld	hl, 2
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_memset
	ld	hl, sp+19
	ld	[hl], $04
;src/fatfs/fatfs.c:896: for (i = 0; i < 2; ++i) if (rtc[i*5] >= 60 || rtc[i*5+1] >= 60 || rtc[i*5+2] >= 24 || (rtc[i*5+4] & 0x3E)) return FR_INT_ERR;
.l00144:
	ld	c, $00
.l00127:
	ld	l, c
;	spillPairReg hl
;	spillPairReg hl
	ld	h, $00
;	spillPairReg hl
;	spillPairReg hl
	ld	e, l
	ld	d, h
	add	hl, hl
	add	hl, hl
	add	hl, de
	ld	b, h
	ld	e, l
	ld	d, b
	ld	hl, 0
	add	hl, sp
	add	hl, de
	ld	a, [hl]
	sub	a, $3C
	jp	NC, .l00115
	ld	a, c
	ld	e, a
	add	a, a
	add	a, a
	add	a, e
	ld	b, a
	ld	a, b
	inc	a
	ld	e, a
	rlca
	sbc	a, a
	ld	d, a
	ld	hl, 0
	add	hl, sp
	add	hl, de
	ld	a, [hl]
	sub	a, $3C
	jp	NC, .l00115
	ld	a, b
	inc	a
	inc	a
	ld	e, a
	rlca
	sbc	a, a
	ld	d, a
	ld	hl, 0
	add	hl, sp
	add	hl, de
	ld	a, [hl]
	sub	a, $18
	jp	NC, .l00115
	ld	a, b
	inc	a
	inc	a
	inc	a
	inc	a
	ld	e, a
	rlca
	sbc	a, a
	ld	d, a
	ld	hl, 0
	add	hl, sp
	add	hl, de
	ld	a, [hl]
	and	a, $3E
	jp	NZ,.l00224
	jp	.l00128
.l00224:
.l00115:
	ld	a, $02
	jp	.l00131
.l00128:
	inc	c
	ld	a, c
	sub	a, $02
	jp	C, .l00127
;src/fatfs/fatfs.c:897: if (result) { ClockDate date; if (!ClockRead(&date)) { rtc[4] = 0x40; ClockAdvance(rtc); rtc[4] = 0; } }
	ld	hl, sp+19
	ld	a, [hl]
	or	a, a
	jp	Z, .l00124
	ld	hl, sp+12
	ld	e, l
	ld	d, h
	call	_ClockRead
	or	a, a
	jp	NZ, .l00125
	ld	hl, sp+4
	ld	[hl], $40
	ld	hl, 0
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_ClockAdvance
	ld	hl, sp+4
	ld	[hl], $00
	jp	.l00125
.l00124:
;src/fatfs/fatfs.c:898: else ClockAdvance(rtc); // clock-less carts keep the stored registers
	ld	hl, 0
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_ClockAdvance
.l00125:
;src/fatfs/fatfs.c:899: *(volatile BYTE*)0xBD13 = 6; *(volatile BYTE*)0xBD10 = 1;
	ld	hl, $BD13
	ld	[hl], $06
	ld	l, $10
	ld	[hl], $01
;src/fatfs/fatfs.c:900: for (i = 0; i < 5; ++i) {
	ld	c, $00
.l00129:
;src/fatfs/fatfs.c:901: *(volatile BYTE*)0xBD13 = i;
	ld	hl, $BD13
	ld	[hl], c
;src/fatfs/fatfs.c:902: *(volatile BYTE*)0xBD10 = rtc[i]; *(volatile BYTE*)0xBD11 = rtc[i + 5];
	ld	e, c
	ld	d, $00
	ld	hl, 0
	add	hl, sp
	add	hl, de
	ld	a, [hl]
	ld	hl, $BD10
	ld	[hl], a
	ld	a, c
	add	a, $05
	ld	e, a
	rlca
	sbc	a, a
	ld	d, a
	ld	hl, 0
	add	hl, sp
	add	hl, de
	ld	a, [hl]
	ld	hl, $BD11
	ld	[hl], a
;src/fatfs/fatfs.c:900: for (i = 0; i < 5; ++i) {
	inc	c
	ld	a, c
	sub	a, $05
	jp	C, .l00129
;src/fatfs/fatfs.c:904: *(volatile BYTE*)0xBD13 = 6; *(volatile BYTE*)0xBD10 = 0;
	ld	l, $13
	ld	[hl], $06
	ld	l, $10
	ld	[hl], $00
;src/fatfs/fatfs.c:905: return FR_OK;
	xor	a, a
.l00131:
;src/fatfs/fatfs.c:906: }
	add	sp, 20
	ret
;src/fatfs/fatfs.c:907: static FRESULT WriteGameRTC(const char* path) {
;	---------------------------------
	SECTION FRAGMENT "Page 12",ROMX,BANK[6]
	LOAD FRAGMENT "Page 12 RAM",SRAM,BANK[12]
; Function WriteGameRTC
; ---------------------------------
_WriteGameRTC:
	add	sp, -15
	ld	hl, sp+12
	ld	[hl], e
	inc	hl
	ld	[hl], d
;src/fatfs/fatfs.c:911: SaveRamBlock(255, 1);
	ld	a, $01
	ld	de, $00FF
	call	_SaveRamBlock__far
;src/fatfs/fatfs.c:912: for (i = 0; i < 5; ++i) { rtc[i] = WINDOW[496 + i * 2]; rtc[i + 5] = WINDOW[497 + i * 2]; }
	ld	hl, sp+14
	ld	[hl], $00
.l00110:
	push	hl
	ld	hl, 2
	add	hl, sp
	ld	e, l
	ld	d, h
	pop	hl
	ld	hl, sp+14
	ld	l, [hl]
	ld	h, $00
	add	hl, de
	ld	c, l
	ld	b, h
	ld	hl, sp+14
	ld	e, [hl]
	ld	d, $00
	sla	e
	rl	d
	ld	hl, $01F0
	add	hl, de
	ld	a, h
	add	a, $BE
	ld	h, a
;	spillPairReg hl
;	spillPairReg hl
	ld	a, [hl]
	ld	[bc], a
	ld	hl, sp+14
	ld	a, [hl]
	add	a, $05
	ld	c, a
	rlca
	sbc	a, a
	ld	b, a
	ld	hl, 0
	add	hl, sp
	add	hl, bc
	ld	c, l
	ld	b, h
	ld	hl, $01F1
	add	hl, de
	ld	a, h
	add	a, $BE
	ld	h, a
	ld	a, [hl]
	ld	[bc], a
	ld	hl, sp+14
	inc	[hl]
	ld	a, [hl]
	sub	a, $05
	jp	C, .l00110
;src/fatfs/fatfs.c:913: SaveRamBlock(TB_PSRAM_HIGH << 8, 0);
	xor	a, a
	ld	de, $0100
	call	_SaveRamBlock__far
;src/fatfs/fatfs.c:914: if (rtc[4] == 0x40 && rtc[9] == 0x40) return FR_OK;
	ld	hl, sp+4
	ld	a, [hl]
	sub	a, $40
	jp	NZ,.l00151
	jp	.l00152
.l00151:
	jp	.l00103
.l00152:
	ld	hl, sp+9
	ld	a, [hl]
	sub	a, $40
	jp	NZ,.l00153
	jp	.l00154
.l00153:
	jp	.l00103
.l00154:
	xor	a, a
	jp	.l00112
.l00103:
;src/fatfs/fatfs.c:915: memset(buffer, 0, 512); memcpy(buffer, rtc, sizeof(rtc));
	ld	de, $0200
	push	de
	ld	bc, $0000
	ld	de, _buffer
	call	_memset
	ld	de, $000A
	push	de
	ld	hl, 2
	add	hl, sp
	ld	c, l
	ld	b, h
	ld	de, _buffer
	call	___memcpy
;src/fatfs/fatfs.c:916: result = f_open(&save_file, path, FA_WRITE | FA_CREATE_ALWAYS);
	ld	a, $0A
	push	af
	inc	sp
	ld	hl, sp+13
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	ld	de, _save_file
	call	_f_open__far
;src/fatfs/fatfs.c:917: if (result) return result;
	or	a, a
	jp	Z, .l00106
	jp	.l00112
.l00106:
;src/fatfs/fatfs.c:918: result = f_write(&save_file, buffer, 512, &done);
	ld	hl, 10
	add	hl, sp
	ld	e, l
	ld	d, h
	push	de
	ld	de, $0200
	push	de
	ld	bc, _buffer
	ld	de, _save_file
	call	_f_write__far
	ld	c, a
;src/fatfs/fatfs.c:919: if (!result && done != 512) result = FR_DENIED;
	ld	a, c
	or	a, a
	jp	NZ, .l00108
	ld	hl, sp+10
	ld	a, [hl]
	or	a, a
	jp	NZ,.l00155
	inc	hl
	ld	a, [hl]
	sub	a, $02
	jp	NZ,.l00155
	jp	.l00108
.l00155:
	ld	c, $07
.l00108:
;src/fatfs/fatfs.c:920: f_close(&save_file);
	push	bc
	ld	de, _save_file
	call	_f_close__far
	pop	bc
;src/fatfs/fatfs.c:921: return result;
	ld	a, c
.l00112:
;src/fatfs/fatfs.c:922: }
	add	sp, 15
	ret
;src/fatfs/fatfs.c:926: static FRESULT RegistryGame(const char* path) {
;	---------------------------------
	SECTION FRAGMENT "Page 8",ROMX,BANK[4]
	LOAD FRAGMENT "Page 8 RAM",SRAM,BANK[8]
; Function RegistryGame
; ---------------------------------
_RegistryGame:
	add	sp, -33
	ld	hl, sp+29
	ld	[hl], e
	inc	hl
	ld	[hl], d
;src/fatfs/fatfs.c:927: UINT done, i, base = 0, length = 0, sum;
	xor	a, a
	inc	hl
	ld	[hl], a
	inc	hl
	ld	[hl], a
;src/fatfs/fatfs.c:928: DWORD cluster = file.obj.sclust, size = f_size(&file), id = (file.dir_sect << 4) | ((file.dir_ptr - fs.win) >> 5);
	ld	de, (_file + 6) + 0
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
	ld	de, (_file + 10) + 0
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
	ld	de, (_file + 28) + 0
	ld	a, [de]
	ld	hl, sp+25
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
	ld	a, $04
.l00301:
	ld	hl, sp+25
	sla	[hl]
	inc	hl
	rl	[hl]
	inc	hl
	rl	[hl]
	inc	hl
	rl	[hl]
.l00302:
	dec	a
	jr	NZ,.l00301
	ld	hl, _file + 32
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	ld	a, c
	sub	a, LOW((_fs + 50))
	ld	c, a
	ld	a, b
	sbc	a, HIGH((_fs + 50))
	ld	b, a
	ld	a, $05
.l00303:
	sra	b
	rr	c
	dec	a
	jp	NZ, .l00303
	ld	a, b
	rlca
	sbc	a, a
	ld	e, a
	ld	d, a
	ld	hl, sp+25
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
	ld	hl, sp+22
	ld	[hl], c
	inc	hl
	ld	[hl], b
	inc	hl
	ld	[hl], e
	inc	hl
	ld	[hl], a
;src/fatfs/fatfs.c:930: for (i = 0; path[i]; ++i) if (path[i] == '/') base = i + 1;
	ld	bc, $0000
.l00142:
	ld	hl, sp+29
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	add	hl, bc
	ld	e, l
	ld	d, h
	ld	a, [de]
	or	a, a
	jp	Z, .l00103
	inc	bc
	sub	a, $2F
	jp	NZ,.l00304
	jp	.l00305
.l00304:
	jp	.l00143
.l00305:
	ld	hl, sp+31
	ld	[hl], c
	inc	hl
	ld	[hl], b
.l00143:
	jp	.l00142
.l00103:
;src/fatfs/fatfs.c:931: memset(buffer, 0, 512);
	ld	de, $0200
	push	de
	ld	bc, $0000
	ld	de, _buffer
	call	_memset
;src/fatfs/fatfs.c:932: result = f_open(&save_file, REGISTRY, FA_READ);
	ld	a, $01
	push	af
	inc	sp
	ld	bc, ___src_fatfs_fatfs_c_str_15
	ld	de, _save_file
	call	_f_open__far
	ld	c, a
;src/fatfs/fatfs.c:936: if (done < 266 || buffer[0] != 0x34 || buffer[1] != 0x12 || ByteSum(buffer, 264) != ld_16(buffer + 264)) return FR_INT_ERR;
;src/fatfs/fatfs.c:933: if (!result) {
	ld	a, c
	or	a, a
	jp	NZ, .l00116
;src/fatfs/fatfs.c:934: result = f_read(&save_file, buffer, 512, &done); f_close(&save_file);
	ld	hl, sp+0
	ld	c, l
	ld	b, h
	push	bc
	ld	de, $0200
	push	de
	ld	bc, _buffer
	ld	de, _save_file
	call	_f_read__far
	ld	c, a
	push	bc
	ld	de, _save_file
	call	_f_close__far
	pop	bc
;src/fatfs/fatfs.c:935: if (result) return result;
	ld	a, c
	or	a, a
	jp	Z, .l00105
	ld	a, c
	jp	.l00151
.l00105:
;src/fatfs/fatfs.c:936: if (done < 266 || buffer[0] != 0x34 || buffer[1] != 0x12 || ByteSum(buffer, 264) != ld_16(buffer + 264)) return FR_INT_ERR;
	ld	hl, sp+0
	ld	a, [hl]
	sub	a, $0A
	inc	hl
	ld	a, [hl]
	sbc	a, $01
	jp	C, .l00106
	ld	a, [_buffer + 0]
	sub	a, $34
	jp	NZ,.l00306
	jp	.l00307
.l00306:
	jp	.l00106
.l00307:
	ld	a, [(_buffer + 1) + 0]
	sub	a, $12
	jp	NZ,.l00308
	jp	.l00309
.l00308:
	jp	.l00106
.l00309:
	ld	bc, $0108
	ld	de, _buffer
	call	_ByteSum
	ld	e, c
	ld	d, b
	push	de
	ld	de, (_buffer + 264)
	call	_ld_16
	pop	de
	ld	a, e
	sub	a, c
	jp	NZ,.l00310
	ld	a, d
	sub	a, b
	jp	NZ,.l00310
	jp	.l00117
.l00310:
.l00106:
	ld	a, $02
	jp	.l00151
.l00116:
;src/fatfs/fatfs.c:938: else if (result == FR_NO_FILE || result == FR_NO_PATH) { buffer[0] = 0x34; buffer[1] = 0x12; buffer[2] = buffer[5] = 1; }
	ld	a, c
	sub	a, $04
	jp	NZ,.l00311
	jp	.l00111
.l00311:
	ld	a, c
	sub	a, $05
	jp	NZ,.l00312
	jp	.l00313
.l00312:
	jp	.l00112
.l00313:
.l00111:
	ld	hl, _buffer
	ld	[hl], $34
	ld	hl, (_buffer + 1)
	ld	[hl], $12
	ld	hl, (_buffer + 5)
	ld	[hl], $01
	ld	hl, (_buffer + 2)
	ld	[hl], $01
	jp	.l00117
.l00112:
;src/fatfs/fatfs.c:939: else return result;
	ld	a, c
	jp	.l00151
.l00117:
;src/fatfs/fatfs.c:940: memset(buffer + 7, 0, 257);
	ld	de, $0101
	push	de
	ld	bc, $0000
	ld	de, (_buffer + 7)
	call	_memset
;src/fatfs/fatfs.c:941: buffer[7] = game_mapper; buffer[8] = game_rom_mask; buffer[9] = game_ram_mask;
	ld	de, (_buffer + 7)
	ld	hl, _game_mapper
	ld	a, [hl]
	ld	[de], a
	ld	de, (_buffer + 8)
	ld	hl, _game_rom_mask
	ld	a, [hl]
	ld	[de], a
	ld	de, (_buffer + 9)
	ld	hl, _game_ram_mask
	ld	a, [hl]
	ld	[de], a
;src/fatfs/fatfs.c:942: buffer[10] = game_has_rtc || game_save_sectors; buffer[11] = game_header[18] == 3; buffer[12] = game_header[15] & 0x80 ? 1 : 0;
	ld	hl, _game_has_rtc
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00154
	ld	hl, _game_save_sectors + 1
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	jp	NZ, .l00154
	xor	a, a
	jp	.l00155
.l00154:
	ld	a, $01
.l00155:
	ld	hl, (_buffer + 10)
	ld	[hl], a
	ld	bc, _buffer + 11
	ld	a, [(_game_header + 18) + 0]
	sub	a, $03
	jp	NZ,.l00314
	ld	a,$01
	jp	.l00315
.l00314:
	xor	a,a
.l00315:
	ld	[bc], a
	ld	a, [(_game_header + 15) + 0]
	rlca
	jp	C,.l00316
	jp	.l00156
.l00316:
	ld	bc, $0001
	jp	.l00157
.l00156:
	ld	bc, $0000
.l00157:
	ld	hl, (_buffer + 12)
	ld	[hl], c
;src/fatfs/fatfs.c:943: buffer[13] = game_has_rtc; st_16(buffer + 14, game_blocks); st_16(buffer + 16, game_save_sectors);
	ld	de, (_buffer + 13)
	ld	hl, _game_has_rtc
	ld	a, [hl]
	ld	[de], a
	ld	hl, _game_blocks
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	ld	de, (_buffer + 14)
	call	_st_16
	ld	hl, _game_save_sectors
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	ld	de, (_buffer + 16)
	call	_st_16
;src/fatfs/fatfs.c:944: memcpy(buffer + 18, game_header, 16);
	ld	de, $0010
	push	de
	ld	bc, _game_header
	ld	de, (_buffer + 18)
	call	___memcpy
;src/fatfs/fatfs.c:945: for (i = base; path[i] && length < 207; ++i) {
	ld	bc, $0000
.l00146:
	ld	hl, sp+30
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	inc	hl
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	add	hl, de
	ld	e, l
	ld	d, h
	ld	a, [de]
	ld	e, a
	ld	a, e
	or	a, a
	jp	Z, .l00187
	ld	a, c
	sub	a, $CF
	ld	a, b
	sbc	a, $00
	jp	NC, .l00187
;src/fatfs/fatfs.c:946: BYTE c = path[i];
	ld	hl, sp+26
	ld	[hl], e
;src/fatfs/fatfs.c:947: if (c == 0xC2 || c == 0xC3) { BYTE next = path[i + 1]; if ((next & 0xC0) == 0x80) { c = ((c & 3) << 6) | (next & 63); ++i; } }
	ld	a, [hl]
	sub	a, $C2
	jp	NZ,.l00317
	jp	.l00120
.l00317:
	ld	hl, sp+26
	ld	a, [hl]
	sub	a, $C3
	jp	NZ,.l00318
	jp	.l00319
.l00318:
	jp	.l00121
.l00319:
.l00120:
	ld	hl, sp+32
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $0001
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+29
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+28
	ld	[hl], a
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	inc	hl
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	add	hl, de
	ld	e, l
	ld	d, h
	ld	a, [de]
	ld	d, a
	ld	a, d
	ld	l, $00
;	spillPairReg hl
;	spillPairReg hl
	and	a, $C0
	ld	e, a
	ld	l, $00
;	spillPairReg hl
;	spillPairReg hl
	ld	a, e
	sub	a, $80
	or	a, l
	jp	NZ,.l00320
	jp	.l00321
.l00320:
	jp	.l00121
.l00321:
	ld	hl, sp+26
	ld	a, [hl]
	and	a, $03
	rrca
	rrca
	and	a, $C0
	ld	e, a
	ld	a, d
	and	a, $3F
	or	a, e
	ld	[hl], a
	inc	hl
	ld	a, [hl]
	inc	hl
	ld	e, [hl]
	ld	hl, sp+31
	ld	[hl], a
	inc	hl
	ld	[hl], e
.l00121:
;src/fatfs/fatfs.c:948: buffer[34 + length++] = c;
	ld	a, c
	ld	d, b
	inc	bc
	add	a, $22
	ld	e, a
	jp	NC, .l00322
	inc	d
.l00322:
	ld	hl, _buffer
	add	hl, de
	ld	e, l
	ld	d, h
	ld	hl, sp+26
	ld	a, [hl]
	ld	[de], a
;src/fatfs/fatfs.c:945: for (i = base; path[i] && length < 207; ++i) {
	ld	hl, sp+31
	inc	[hl]
	jp	NZ, .l00323
	inc	hl
	inc	[hl]
.l00323:
	jp	.l00146
.l00187:
	ld	hl, sp+26
	ld	[hl], c
	inc	hl
	ld	[hl], b
;src/fatfs/fatfs.c:951: if (length == 11) {
	ld	a, c
	sub	a, $0B
	or	a, b
	jp	NZ,.l00324
	jp	.l00325
.l00324:
	jp	.l00132
.l00325:
;src/fatfs/fatfs.c:952: BYTE dot = 0;
	inc	hl
	ld	[hl], $00
;src/fatfs/fatfs.c:953: for (i = 0; i < length; ++i) if (buffer[34 + i] == '.') dot = i;
	xor	a, a
	ld	hl, sp+31
	ld	[hl], a
	inc	hl
	ld	[hl], a
.l00149:
	ld	hl, sp+31
	ld	e, l
	ld	d, h
	ld	hl, sp+26
	ld	a, [de]
	inc	de
	sub	a, [hl]
	inc	hl
	ld	a, [de]
	sbc	a, [hl]
	jp	NC, .l00126
	ld	hl, sp+32
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $0022
	add	hl, de
	ld	c, l
	ld	b, h
	ld	hl, _buffer
	add	hl, bc
	ld	a, [hl]
	sub	a, $2E
	jp	NZ,.l00326
	jp	.l00327
.l00326:
	jp	.l00150
.l00327:
	ld	hl, sp+31
	ld	a, [hl]
	ld	hl, sp+28
	ld	[hl], a
.l00150:
	ld	hl, sp+31
	inc	[hl]
	jp	NZ, .l00328
	inc	hl
	inc	[hl]
.l00328:
	jp	.l00149
.l00126:
;src/fatfs/fatfs.c:954: if (dot && dot <= 8 && length - dot - 1 <= 3) {
	ld	hl, sp+28
	ld	a, [hl]
	or	a, a
	jp	Z, .l00132
	ld	a, $08
	sub	a, [hl]
	jp	C, .l00132
	ld	c, [hl]
	ld	b, $00
	dec	hl
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, e
	sub	a, c
	ld	e, a
	ld	a, d
	sbc	a, b
	ld	c, e
	ld	e, c
	ld	d, a
	dec	de
	ld	a, $03
	cp	a, e
	ld	a, $00
	sbc	a, d
	jp	C, .l00132
;src/fatfs/fatfs.c:955: BYTE short_name[12]; memset(short_name, ' ', 11); short_name[11] = 0;
	push	de
	ld	bc, $000B
	push	bc
	ld	bc, $0020
	ld	hl, 6
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_memset
	pop	de
	ld	hl, 13
	add	hl, sp
	ld	c, l
	ld	b, h
	xor	a, a
	ld	[bc], a
;src/fatfs/fatfs.c:956: memcpy(short_name, buffer + 34, dot); memcpy(short_name + 8, buffer + 35 + dot, length - dot - 1);
	ld	hl, sp+28
	ld	c, [hl]
	ld	b, $00
	push	de
	push	bc
	ld	bc, (_buffer + 34)
	ld	hl, 6
	add	hl, sp
	ld	e, l
	ld	d, h
	call	___memcpy
	pop	de
	ld	bc, _buffer + 35
	ld	hl, sp+28
	ld	l, [hl]
	ld	h, $00
	add	hl, bc
	ld	c, l
	ld	b, h
	push	de
	ld	hl, 12
	add	hl, sp
	ld	e, l
	ld	d, h
	call	___memcpy
;src/fatfs/fatfs.c:957: memcpy(buffer + 34, short_name, 12);
	ld	de, $000C
	push	de
	ld	hl, 4
	add	hl, sp
	ld	c, l
	ld	b, h
	ld	de, (_buffer + 34)
	call	___memcpy
.l00132:
;src/fatfs/fatfs.c:960: st_32(buffer + 34 + 216, id); st_32(buffer + 34 + 220, cluster); st_32(buffer + 34 + 224, size);
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
	ld	de, (_buffer + 250)
	call	_st_32
	ld	hl, sp+16
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	push	de
	ld	hl, sp+16
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	push	de
	ld	de, (_buffer + 254)
	call	_st_32
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
	ld	de, (_buffer + 258)
	call	_st_32
;src/fatfs/fatfs.c:961: buffer[263] = 1; sum = ByteSum(buffer, 264); st_16(buffer + 264, sum);
	ld	hl, (_buffer + 263)
	ld	[hl], $01
	ld	bc, $0108
	ld	de, _buffer
	call	_ByteSum
	ld	de, (_buffer + 264)
	call	_st_16
;src/fatfs/fatfs.c:962: result = f_open(&save_file, REGISTRY, FA_WRITE | FA_CREATE_ALWAYS);
	ld	a, $0A
	push	af
	inc	sp
	ld	bc, ___src_fatfs_fatfs_c_str_15
	ld	de, _save_file
	call	_f_open__far
;src/fatfs/fatfs.c:963: if (result) return result;
	or	a, a
	jp	Z, .l00134
	jp	.l00151
.l00134:
;src/fatfs/fatfs.c:964: result = f_write(&save_file, buffer, 512, &done);
	ld	bc, _buffer
	ld	de, _save_file
	ld	hl, 0
	add	hl, sp
	push	hl
	ld	hl, $0200
	push	hl
	call	_f_write__far
	ld	c, a
;src/fatfs/fatfs.c:965: if (!result && done != 512) result = FR_DENIED;
	ld	a, c
	or	a, a
	jp	NZ, .l00136
	ld	hl, sp+0
	ld	a, [hl]
	or	a, a
	jp	NZ,.l00329
	inc	hl
	ld	a, [hl]
	sub	a, $02
	jp	NZ,.l00329
	jp	.l00136
.l00329:
	ld	c, $07
.l00136:
;src/fatfs/fatfs.c:966: if (result) f_close(&save_file); else result = f_close(&save_file);
	ld	a, c
	or	a, a
	jp	Z, .l00139
	push	bc
	ld	de, _save_file
	call	_f_close__far
	pop	bc
	jp	.l00140
.l00139:
	ld	de, _save_file
	call	_f_close__far
	ld	c, a
.l00140:
;src/fatfs/fatfs.c:967: return result;
	ld	a, c
.l00151:
;src/fatfs/fatfs.c:968: }
	add	sp, 33
	ret
	SECTION FRAGMENT "src/fatfs/fatfs.c ROM0",ROM0
___src_fatfs_fatfs_c_str_15:
	DB "/GBCSYS/REGISTRY.BIN"
	DB $00
;src/fatfs/fatfs.c:973: static BYTE CheatHex(BYTE c) {
;	---------------------------------
	SECTION FRAGMENT "Page 13",ROMX,BANK[6]
	LOAD FRAGMENT "Page 13 RAM",SRAM,BANK[13]
; Function CheatHex
; ---------------------------------
_CheatHex:
	ld	c, a
;src/fatfs/fatfs.c:974: if (c >= '0' && c <= '9') return c-'0';
	ld	a, c
	sub	a, $30
	jp	C, .l00102
	ld	a, $39
	sub	a, c
	jp	C, .l00102
	ld	a, c
	add	a, $D0
	jp	.l00104
.l00102:
;src/fatfs/fatfs.c:975: c |= 32; return c >= 'a' && c <= 'f' ? c-'a'+10 : 0xFF;
	set	5, c
	ld	a, c
	sub	a, $61
	jp	C, .l00106
	ld	a, $66
	sub	a, c
	jp	C, .l00106
	ld	a, c
	add	a, $A9
	ld	c, a
	rlca
	sbc	a, a
	jp	.l00107
.l00106:
	ld	c, $FF
	xor	a, a
.l00107:
	ld	a, c
.l00104:
;src/fatfs/fatfs.c:976: }
	ret
;src/fatfs/fatfs.c:977: static void CheatApply(const BYTE* code) {
;	---------------------------------
	SECTION FRAGMENT "Page 5",ROMX,BANK[2]
	LOAD FRAGMENT "Page 5 RAM",SRAM,BANK[5]
; Function CheatApply
; ---------------------------------
_CheatApply:
	add	sp, -11
	ld	hl, sp+9
	ld	[hl], e
	inc	hl
	ld	[hl], d
;src/fatfs/fatfs.c:980: if (code[0]>15 || code[1]>15 || code[2]>15 || code[3]>15 || code[4]>15 || code[5]<8 || code[5]>15) return;
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	ld	hl, sp+7
	ld	[hl], a
	ld	a, $0F
	sub	a, [hl]
	jp	C, .l00101
	inc	hl
	inc	hl
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	inc	bc
	ld	a, [bc]
	dec	hl
	dec	hl
	ld	[hl], a
	ld	a, $0F
	sub	a, [hl]
	jp	C, .l00101
	inc	hl
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	inc	bc
	inc	bc
	ld	a, [bc]
	ld	b, a
	ld	a, $0F
	sub	a, b
	jp	C, .l00101
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	inc	de
	inc	de
	inc	de
	ld	a, [de]
	ld	c, a
	ld	a, $0F
	sub	a, c
	jp	C, .l00101
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $0004
	add	hl, de
	ld	e, l
	ld	d, h
	ld	a, [de]
	ld	hl, sp+6
	ld	[hl], a
	ld	a, $0F
	sub	a, [hl]
	jp	C, .l00101
	ld	hl, sp+10
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $0005
	add	hl, de
	ld	e, l
	ld	d, h
	ld	a, [de]
	ld	e, a
	ld	a, e
	sub	a, $08
	jp	C, .l00101
	ld	a, $0F
	sub	a, e
	jp	NC, .l00102
.l00101:
	jp	.l00116
.l00102:
;src/fatfs/fatfs.c:981: address=((UINT)(code[5]^15)<<12)|((UINT)code[2]<<8)|((UINT)code[3]<<4)|code[4];
	ld	a, e
	xor	a, $0F
	ld	e, a
	ld	d, $00
	ld	a, e
	swap	a
	and	a, $F0
	ld	d, a
	ld	e, $00
	ld	l, b
;	spillPairReg hl
;	spillPairReg hl
	ld	h, $00
;	spillPairReg hl
;	spillPairReg hl
	ld	a, $00
	or	a, e
	ld	e, a
	ld	a, l
	or	a, d
	ld	d, a
	ld	l, c
;	spillPairReg hl
;	spillPairReg hl
	ld	h, $00
;	spillPairReg hl
;	spillPairReg hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	ld	a, l
	or	a, e
	ld	c, a
	ld	a, h
	or	a, d
	ld	b, a
	ld	hl, sp+6
	ld	a, [hl]
	ld	e, $00
	or	a, c
	ld	c, a
	ld	a, e
	or	a, b
	ld	hl, sp+0
	ld	[hl], c
	inc	hl
	ld	[hl], a
;src/fatfs/fatfs.c:982: value=(code[0]<<4)|code[1];
	ld	hl, sp+7
	ld	a, [hl]
	swap	a
	and	a, $F0
	inc	hl
	or	a, [hl]
	ld	hl, sp+2
	ld	[hl], a
;src/fatfs/fatfs.c:983: check=code[6]<16 && code[8]<16;
	ld	hl, sp+10
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $0006
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, [bc]
	ld	b, a
	ld	hl, sp+10
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $0008
	add	hl, de
	ld	e, l
	ld	d, h
	ld	a, [de]
	ld	c, a
	ld	a, b
	sub	a, $10
	jp	NC, .l00118
	ld	a, c
	sub	a, $10
	jp	C, .l00119
.l00118:
	xor	a, a
	jp	.l00120
.l00119:
	ld	a, $01
.l00120:
	ld	hl, sp+3
	ld	[hl], a
;src/fatfs/fatfs.c:984: hi=((code[6]<<4)|code[8])^255;
	ld	a, b
	swap	a
	and	a, $F0
	or	a, c
	cpl
;src/fatfs/fatfs.c:985: compare=((hi>>2)|(hi<<6))^0x45;
	push	af
	rrca
	rrca
	and	a, $3F
	ld	c, a
	pop	af
	rrca
	rrca
	and	a, $C0
	or	a, c
	xor	a, $45
	inc	hl
	ld	[hl], a
;src/fatfs/fatfs.c:988: block=(address & 0x3FFF)>>9; last=check ? game_blocks : block+1;
	ld	hl, sp+0
	ld	c, [hl]
	inc	hl
	ld	a, [hl]
	and	a, $3F
	ld	b, a
	ld	a, b
	srl	a
	ld	hl, sp+5
	ld	[hl], a
	inc	hl
	ld	[hl], $00
	ld	hl, sp+3
	ld	a, [hl]
	or	a, a
	jp	Z, .l00121
	ld	hl, _game_blocks
	ld	a, [hl]
	ld	hl, sp+7
	ld	[hl], a
	ld	hl, _game_blocks + 1
	ld	a, [hl]
	ld	hl, sp+8
	ld	[hl], a
	jp	.l00122
.l00121:
	ld	hl, sp+6
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $0001
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+9
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+8
	ld	[hl], a
.l00122:
	ld	hl, sp+0
	ld	c, [hl]
	inc	hl
	ld	a, [hl]
	and	a, $01
	ld	b, a
	ld	hl, $BE00
	add	hl, bc
	ld	c, l
	ld	b, h
	ld	hl, sp+5
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
.l00114:
;src/fatfs/fatfs.c:989: for (; block<last; block+=32) {
	ld	hl, sp+7
	ld	a, e
	sub	a, [hl]
	inc	hl
	ld	a, d
	sbc	a, [hl]
	jp	NC, .l00116
;src/fatfs/fatfs.c:990: SetWindowBlock(block);
	push	bc
	push	de
	call	_SetWindowBlock
	pop	de
	pop	bc
;src/fatfs/fatfs.c:991: if (!check || WINDOW[address&511]==compare) WINDOW[address&511]=value;
	ld	hl, sp+3
	ld	a, [hl]
	or	a, a
	jp	Z, .l00109
	ld	a, [bc]
	ld	hl, sp+6
	ld	[hl], a
	dec	hl
	dec	hl
	ld	a, [hl]
	inc	hl
	inc	hl
	sub	a, [hl]
	jp	NZ,.l00179
	jp	.l00180
.l00179:
	jp	.l00115
.l00180:
.l00109:
	ld	hl, sp+2
	ld	a, [hl]
	ld	[bc], a
.l00115:
;src/fatfs/fatfs.c:989: for (; block<last; block+=32) {
	ld	hl, $0020
	add	hl, de
	ld	e, l
	ld	d, h
	jp	.l00114
.l00116:
;src/fatfs/fatfs.c:993: }
	add	sp, 11
	ret
;src/fatfs/fatfs.c:994: static FRESULT GameCheats(const char* path) {
;	---------------------------------
	SECTION FRAGMENT "Page 13",ROMX,BANK[6]
	LOAD FRAGMENT "Page 13 RAM",SRAM,BANK[13]
; Function GameCheats
; ---------------------------------
_GameCheats:
	add	sp, -128
	add	sp, -112
	ld	hl, 233
	add	hl, sp
	ld	[hl], e
	inc	hl
	ld	[hl], d
;src/fatfs/fatfs.c:996: BYTE codes[144], digit=0, row=0, c, column=0;
	inc	hl
	ld	[hl], $00
	inc	hl
	ld	[hl], $00
;src/fatfs/fatfs.c:998: if (!game_cheats) return FR_OK;
	ld	hl, _game_cheats
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00102
	xor	a, a
	jp	.l00137
.l00102:
;src/fatfs/fatfs.c:999: GamePath(name,path,".txt");
	ld	de, ___src_fatfs_fatfs_c_str_17
	push	de
	ld	hl, 235
	add	hl, sp
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	ld	hl, 2
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_GamePath__far
;src/fatfs/fatfs.c:1000: for (i=0; name[i]; ++i);
	ld	de, $0000
.l00130:
	ld	hl, 0
	add	hl, sp
	add	hl, de
	ld	a, [hl]
	or	a, a
	jp	Z, .l00142
	inc	de
	jp	.l00130
;src/fatfs/fatfs.c:1001: do { name[i+2]=name[i]; } while (i-- > sizeof(SAVE_FOLDER)-1);
.l00142:
.l00104:
	ld	a, e
	add	a, $02
	ld	c, a
	rlca
	sbc	a, a
	ld	b, a
	ld	hl, 0
	add	hl, sp
	add	hl, bc
	ld	c, l
	ld	b, h
	ld	hl, 0
	add	hl, sp
	add	hl, de
	ld	a, [hl]
	ld	[bc], a
	ld	c, e
	ld	b, d
	dec	de
	ld	a, $0D
	cp	a, c
	ld	a, $00
	sbc	a, b
	jp	C, .l00104
;src/fatfs/fatfs.c:1002: memcpy(name,CHEAT_FOLDER,sizeof(CHEAT_FOLDER)-1);
	ld	de, $000F
	push	de
	ld	bc, __str_16
	ld	hl, 2
	add	hl, sp
	ld	e, l
	ld	d, h
	call	___memcpy
;src/fatfs/fatfs.c:1003: result=f_open(&save_file,name,FA_READ);
	ld	a, $01
	push	af
	inc	sp
	ld	hl, 1
	add	hl, sp
	ld	c, l
	ld	b, h
	ld	de, _save_file
	call	_f_open__far
;src/fatfs/fatfs.c:1004: if (result==FR_NO_FILE || result==FR_NO_PATH) return FR_OK;
	cp	a, $04
	jp	NZ,.l00243
	jp	.l00107
.l00243:
	cp	a, $05
	jp	NZ,.l00244
	jp	.l00245
.l00244:
	jp	.l00108
.l00245:
.l00107:
	xor	a, a
	jp	.l00137
.l00108:
;src/fatfs/fatfs.c:1005: if (result) return result;
	or	a, a
	jp	Z, .l00111
	jp	.l00137
.l00111:
;src/fatfs/fatfs.c:1006: result=f_read(&save_file,buffer,512,&done); f_close(&save_file); if (result) return result;
	ld	bc, _buffer
	ld	de, _save_file
	ld	hl, 229
	add	hl, sp
	push	hl
	ld	hl, $0200
	push	hl
	call	_f_read__far
	ld	c, a
	push	bc
	ld	de, _save_file
	call	_f_close__far
	pop	bc
	ld	a, c
	or	a, a
	jp	Z, .l00113
	ld	a, c
	jp	.l00137
.l00113:
;src/fatfs/fatfs.c:1007: memset(codes,0xFF,sizeof(codes));
	ld	de, $0090
	push	de
	ld	bc, $00FF
	ld	hl, 87
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_memset
;src/fatfs/fatfs.c:1008: for (i=0; i<done && row<16; ++i) {
	ld	hl, 237
	add	hl, sp
	ld	[hl], $00
	xor	a, a
	inc	hl
	ld	[hl], a
	inc	hl
	ld	[hl], a
.l00134:
	ld	hl, 238
	add	hl, sp
	ld	e, l
	ld	d, h
	ld	hl, 229
	add	hl, sp
	ld	a, [de]
	inc	de
	sub	a, [hl]
	inc	hl
	ld	a, [de]
	sbc	a, [hl]
	jp	NC, .l00127
	ld	hl, 237
	add	hl, sp
	ld	a, [hl]
	sub	a, $10
	jp	NC, .l00127
;src/fatfs/fatfs.c:1009: c=buffer[i];
	inc	hl
	inc	hl
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, _buffer
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, 233
	add	hl, sp
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, 232
	add	hl, sp
	ld	[hl], a
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	ld	c, a
;src/fatfs/fatfs.c:1010: if (c=='\r') continue;
	ld	a, c
	sub	a, $0D
	jp	NZ,.l00246
	jp	.l00126
.l00246:
;src/fatfs/fatfs.c:1011: if (c=='\n') { if (column) ++row; digit=column=0; continue; }
	ld	a, c
	sub	a, $0A
	jp	NZ,.l00247
	jp	.l00248
.l00247:
	jp	.l00119
.l00248:
	ld	hl, 236
	add	hl, sp
	ld	a, [hl]
	or	a, a
	jp	Z, .l00117
	inc	hl
	inc	[hl]
.l00117:
	ld	hl, 236
	add	hl, sp
	ld	[hl], $00
	dec	hl
	ld	[hl], $00
	jp	.l00126
.l00119:
;src/fatfs/fatfs.c:1012: if (c=='-' || c==' ' || c=='\t') continue;
	ld	a, c
	sub	a, $2D
	jp	NZ,.l00249
	jp	.l00126
.l00249:
	ld	a, c
	sub	a, $20
	jp	NZ,.l00250
	jp	.l00126
.l00250:
	ld	a, c
	sub	a, $09
	jp	NZ,.l00251
	jp	.l00126
.l00251:
;src/fatfs/fatfs.c:1013: if (digit<9) codes[row*9+digit++]=CheatHex(c);
	ld	hl, 235
	add	hl, sp
	ld	a, [hl]
	sub	a, $09
	jp	NC, .l00125
	inc	hl
	inc	hl
	ld	a, [hl]
	ld	hl, 231
	add	hl, sp
	ld	[hl], a
	inc	hl
	ld	[hl], $00
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	l, e
	ld	h, d
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, 233
	add	hl, sp
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, 232
	add	hl, sp
	ld	[hl], a
	ld	hl, 235
	add	hl, sp
	ld	e, [hl]
	inc	[hl]
	ld	d, $00
	ld	hl, 231
	add	hl, sp
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	add	hl, de
	ld	e, l
	ld	d, h
	ld	hl, 85
	add	hl, sp
	add	hl, de
	push	hl
	ld	a, c
	call	_CheatHex
	pop	hl
	ld	[hl], a
.l00125:
;src/fatfs/fatfs.c:1014: ++column;
	ld	hl, 236
	add	hl, sp
	inc	[hl]
.l00126:
;src/fatfs/fatfs.c:1008: for (i=0; i<done && row<16; ++i) {
	ld	hl, 238
	add	hl, sp
	inc	[hl]
	jp	NZ, .l00252
	inc	hl
	inc	[hl]
.l00252:
	jp	.l00134
.l00127:
;src/fatfs/fatfs.c:1016: for (i=0; i<16; ++i) CheatApply(codes+i*9);
	ld	bc, $0000
.l00135:
	ld	l, c
	ld	h, b
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, bc
	push	hl
	ld	hl, 87
	add	hl, sp
	ld	e, l
	ld	d, h
	pop	hl
	add	hl, de
	ld	e, l
	ld	d, h
	push	bc
	call	_CheatApply__far
	pop	bc
	inc	bc
	ld	a, c
	sub	a, $10
	ld	a, b
	sbc	a, $00
	jp	C, .l00135
;src/fatfs/fatfs.c:1017: SetWindowBlock(TB_PSRAM_HIGH << 8);
	ld	de, $0100
	call	_SetWindowBlock
;src/fatfs/fatfs.c:1018: return FR_OK;
	xor	a, a
.l00137:
;src/fatfs/fatfs.c:1019: }
	add	sp, 127
	add	sp, 113
	ret
	SECTION FRAGMENT "src/fatfs/fatfs.c ROM0",ROM0
__str_16:
	DB "/GBCSYS/CHEATS/"
	DB $00
	SECTION FRAGMENT "src/fatfs/fatfs.c ROM0",ROM0
___src_fatfs_fatfs_c_str_17:
	DB ".txt"
	DB $00
	SECTION FRAGMENT "src/fatfs/fatfs.c ROM0",ROM0
__str_18:
	DB "/GBCSYS/SAVE/"
	DB $00
;src/fatfs/fatfs.c:1029: static void SnapshotPath(char* out, const char* path) {
;	---------------------------------
	SECTION FRAGMENT "Page 13",ROMX,BANK[6]
	LOAD FRAGMENT "Page 13 RAM",SRAM,BANK[13]
; Function SnapshotPath
; ---------------------------------
_SnapshotPath:
;src/fatfs/fatfs.c:1030: GamePath(out, path, ".sav"); memcpy(out, SNAP_FOLDER, sizeof(SNAP_FOLDER) - 1);
	push	de
	ld	hl, ___src_fatfs_fatfs_c_str_19
	push	hl
	call	_GamePath__far
	pop	de
	ld	bc, ___src_fatfs_fatfs_c_str_20+0
	ld	hl, $000D
	push	hl
	call	___memcpy
.l00101:
;src/fatfs/fatfs.c:1031: }
	ret
	SECTION FRAGMENT "src/fatfs/fatfs.c ROM0",ROM0
___src_fatfs_fatfs_c_str_19:
	DB ".sav"
	DB $00
	SECTION FRAGMENT "src/fatfs/fatfs.c ROM0",ROM0
___src_fatfs_fatfs_c_str_20:
	DB "/GBCSYS/SNAP/"
	DB $00
;src/fatfs/fatfs.c:1032: static FRESULT SnapshotFile(const char* path, BYTE write, UINT first) {
;	---------------------------------
	SECTION FRAGMENT "Page 6",ROMX,BANK[3]
	LOAD FRAGMENT "Page 6 RAM",SRAM,BANK[6]
; Function SnapshotFile
; ---------------------------------
_SnapshotFile:
	add	sp, -7
	ld	c, e
	ld	b, d
	ld	hl, sp+6
	ld	[hl], a
;src/fatfs/fatfs.c:1034: result = f_open(&save_file, path, write ? FA_WRITE | FA_CREATE_ALWAYS : FA_READ);
	ld	a, [hl]
	or	a, a
	jp	Z, .l00121
	ld	de, $000A
	jp	.l00122
.l00121:
	ld	de, $0001
.l00122:
	ld	a, e
	push	af
	inc	sp
	ld	de, _save_file
	call	_f_open__far
	ld	c, a
;src/fatfs/fatfs.c:1035: if (result) return result;
	ld	a, c
	or	a, a
	jp	Z, .l00102
	ld	a, c
	jp	.l00119
.l00102:
;src/fatfs/fatfs.c:1036: if (!write && f_size(&save_file) != 83968UL) result = FR_INT_ERR;
	ld	hl, sp+6
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00140
	ld	de, (_save_file + 10) + 0
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
	ld	a, [hl]
	or	a, a
	jp	NZ,.l00203
	inc	hl
	ld	a, [hl]
	sub	a, $48
	jp	NZ,.l00203
	inc	hl
	ld	a, [hl]
	dec	a
	inc	hl
	or	a, [hl]
	jp	NZ,.l00203
	jp	.l00140
.l00203:
	ld	c, $02
;src/fatfs/fatfs.c:1037: for (n = 0; !result && n < SNAP_SECTORS; ++n) {
.l00140:
	ld	de, $0000
.l00117:
	ld	a, c
	or	a, a
	jp	NZ, .l00114
	ld	a, e
	sub	a, $A4
	ld	a, d
	sbc	a, $00
	jp	NC, .l00114
;src/fatfs/fatfs.c:1038: SetWindowBlock(first + n);
	push	de
	ld	hl, sp+11
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	add	hl, de
	pop	de
	ld	c, l
	ld	b, h
	push	de
	ld	e, c
	ld	d, b
	call	_SetWindowBlock
	pop	de
;src/fatfs/fatfs.c:1039: result = write ? f_write(&save_file, WINDOW, 512, &done) : f_read(&save_file, WINDOW, 512, &done);
	ld	hl, sp+6
	ld	a, [hl]
	or	a, a
	jp	Z, .l00123
	ld	hl, sp+0
	ld	c, l
	ld	b, h
	push	de
	push	bc
	ld	bc, $0200
	push	bc
	ld	bc, $BE00
	ld	de, _save_file
	call	_f_write__far
	pop	de
	jp	.l00124
.l00123:
	ld	hl, sp+0
	ld	c, l
	ld	b, h
	push	de
	push	bc
	ld	bc, $0200
	push	bc
	ld	bc, $BE00
	ld	de, _save_file
	call	_f_read__far
	pop	de
.l00124:
	ld	c, a
;src/fatfs/fatfs.c:1040: if (!result && done != 512) result = FR_DENIED;
	ld	a, c
	or	a, a
	jp	NZ, .l00107
	ld	hl, sp+0
	ld	a, [hl]
	or	a, a
	jp	NZ,.l00204
	inc	hl
	ld	a, [hl]
	sub	a, $02
	jp	NZ,.l00204
	jp	.l00107
.l00204:
	ld	c, $07
.l00107:
;src/fatfs/fatfs.c:1041: if (!result && !write && !n && memcmp(WINDOW, "SAVE", 4)) result = FR_INT_ERR;
	ld	a, c
	or	a, a
	jp	NZ, .l00118
	ld	hl, sp+6
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00118
	ld	a, d
	or	a, e
	jp	NZ, .l00118
	push	bc
	push	de
	ld	hl, $0004
	push	hl
	ld	bc, ___src_fatfs_fatfs_c_str_21
	ld	de, $BE00
	call	_memcmp
	ld	l, c
;	spillPairReg hl
;	spillPairReg hl
	ld	h, b
;	spillPairReg hl
;	spillPairReg hl
	pop	de
	pop	bc
	ld	a, h
	or	a, l
	jp	Z, .l00118
	ld	c, $02
.l00118:
;src/fatfs/fatfs.c:1037: for (n = 0; !result && n < SNAP_SECTORS; ++n) {
	inc	de
	jp	.l00117
.l00114:
;src/fatfs/fatfs.c:1043: SetWindowBlock(TB_PSRAM_HIGH << 8);
	push	bc
	ld	de, $0100
	call	_SetWindowBlock
	pop	bc
;src/fatfs/fatfs.c:1044: closed = f_close(&save_file); return result ? result : closed;
	push	bc
	ld	de, _save_file
	call	_f_close__far
	pop	bc
	ld	e, a
	ld	a, c
	or	a, a
	jp	Z, .l00125
	ld	a, c
	jp	.l00126
.l00125:
	ld	a, e
.l00126:
.l00119:
;src/fatfs/fatfs.c:1045: }
	add	sp, 7
	pop	hl
	inc	sp
	inc	sp
	jp hl
	SECTION FRAGMENT "src/fatfs/fatfs.c ROM0",ROM0
___src_fatfs_fatfs_c_str_21:
	DB "SAVE"
	DB $00
;src/fatfs/fatfs.c:1047: static void SnapshotCopy(BYTE kind) {
;	---------------------------------
	SECTION FRAGMENT "Page 4",ROMX,BANK[2]
	LOAD FRAGMENT "Page 4 RAM",SRAM,BANK[4]
; Function SnapshotCopy
; ---------------------------------
_SnapshotCopy:
	add	sp, -9
	ld	hl, sp+6
	ld	[hl], a
;src/fatfs/fatfs.c:1049: for (n = 0; n < SNAP_SECTORS; ++n) {
	ld	a, [hl]
	dec	a
	jp	NZ,.l00158
	ld	a,$01
	jp	.l00159
.l00158:
	xor	a,a
.l00159:
	ld	c, a
	ld	hl, sp+0
	ld	[hl], c
	ld	hl, sp+6
	ld	a, [hl]
	sub	a, $02
	jp	NZ,.l00160
	ld	a,$01
	jp	.l00161
.l00160:
	xor	a,a
.l00161:
	ld	hl, sp+1
	ld	[hl], a
	inc	hl
	ld	[hl], c
	ld	hl, sp+6
	ld	a, [hl]
	sub	a, $03
	jp	NZ,.l00162
	ld	a,$01
	jp	.l00163
.l00162:
	xor	a,a
.l00163:
	ld	hl, sp+3
	ld	[hl], a
	xor	a, a
	ld	hl, sp+7
	ld	[hl], a
	inc	hl
	ld	[hl], a
.l00102:
;src/fatfs/fatfs.c:1050: SaveRamBlock((kind == 3 ? 64 : kind == 1 ? SNAP_FIRST : SNAP_STAGE) + n, kind == 3);
	ld	hl, sp+3
	ld	a, [hl]
	or	a, a
	jp	Z, .l00106
	ld	bc, $0040
	jp	.l00107
.l00106:
	ld	hl, sp+0
	ld	a, [hl]
	or	a, a
	jp	Z, .l00108
	ld	hl, sp+4
	ld	[hl], $40
	inc	hl
	ld	[hl], $3E
	jp	.l00109
.l00108:
	ld	hl, sp+4
	ld	[hl], $00
	inc	hl
	ld	[hl], $3C
.l00109:
	ld	hl, sp+4
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
.l00107:
	ld	hl, sp+7
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	add	hl, bc
	ld	e, l
	ld	d, h
	ld	hl, sp+3
	ld	a, [hl]
	call	_SaveRamBlock__far
;src/fatfs/fatfs.c:1051: memcpy(buffer, WINDOW, 512);
	ld	de, $0200
	push	de
	ld	bc, $BE00
	ld	de, _buffer
	call	___memcpy
;src/fatfs/fatfs.c:1052: SaveRamBlock((kind == 3 ? SNAP_STAGE : kind ? 64 : SNAP_FIRST) + n, kind == 1 || kind == 2);
	ld	hl, sp+2
	bit	0, [hl]
	jp	NZ, .l00111
	dec	hl
	bit	0, [hl]
	jp	NZ, .l00111
	ld	c, $00
	jp	.l00112
.l00111:
	ld	c, $01
.l00112:
	ld	hl, sp+3
	ld	a, [hl]
	or	a, a
	jp	Z, .l00113
	ld	de, $3C00
	jp	.l00114
.l00113:
	ld	hl, sp+6
	ld	a, [hl]
	or	a, a
	jp	Z, .l00115
	ld	de, $0040
	jp	.l00116
.l00115:
	ld	de, $3E40
.l00116:
.l00114:
	ld	hl, sp+7
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	add	hl, de
	ld	e, l
	ld	d, h
	ld	a, c
	call	_SaveRamBlock__far
;src/fatfs/fatfs.c:1053: memcpy(WINDOW, buffer, 512);
	ld	de, $0200
	push	de
	ld	bc, _buffer
	ld	de, $BE00
	call	___memcpy
;src/fatfs/fatfs.c:1049: for (n = 0; n < SNAP_SECTORS; ++n) {
	ld	hl, sp+7
	inc	[hl]
	jp	NZ, .l00164
	inc	hl
	inc	[hl]
.l00164:
	ld	hl, sp+7
	ld	a, [hl]
	sub	a, $A4
	inc	hl
	ld	a, [hl]
	sbc	a, $00
	jp	C, .l00102
;src/fatfs/fatfs.c:1055: SaveRamBlock(TB_PSRAM_HIGH << 8, 0);
	xor	a, a
	ld	de, $0100
	call	_SaveRamBlock__far
.l00104:
;src/fatfs/fatfs.c:1056: }
	add	sp, 9
	ret
;src/fatfs/fatfs.c:1057: static FRESULT SnapshotStore(char* path, UINT first) {
;	---------------------------------
	SECTION FRAGMENT "Page 4",ROMX,BANK[2]
	LOAD FRAGMENT "Page 4 RAM",SRAM,BANK[4]
; Function SnapshotStore
; ---------------------------------
_SnapshotStore:
	add	sp, -95
	ld	hl, sp+91
	ld	[hl], e
	inc	hl
	ld	[hl], d
	ld	hl, sp+89
	ld	[hl], c
	inc	hl
	ld	[hl], b
;src/fatfs/fatfs.c:1060: result = f_mkdir("/GBCSYS/SNAP"); if (result && result != FR_EXIST) return result;
	ld	de, ___src_fatfs_fatfs_c_str_23
	call	_f_mkdir__far
	ld	hl, sp+94
	ld	[hl], a
	ld	a, [hl]
	or	a, a
	jp	Z, .l00102
	ld	a, [hl]
	sub	a, $08
	jp	NZ,.l00151
	jp	.l00102
.l00151:
	ld	hl, sp+94
	ld	a, [hl]
	jp	.l00113
.l00102:
;src/fatfs/fatfs.c:1061: memcpy(temp, path, sizeof(temp));
	ld	hl, sp+91
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	ld	de, $0053
	push	de
	ld	hl, 2
	add	hl, sp
	ld	e, l
	ld	d, h
	call	___memcpy
;src/fatfs/fatfs.c:1062: for (n = 0; temp[n]; ++n); memcpy(temp + n - 3, "tmp", 3);
	xor	a, a
	ld	hl, sp+93
	ld	[hl], a
	inc	hl
	ld	[hl], a
.l00111:
	push	hl
	ld	hl, 2
	add	hl, sp
	ld	e, l
	ld	d, h
	pop	hl
	ld	hl, sp+93
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+89
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+88
	ld	[hl], a
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	or	a, a
	jp	Z, .l00122
	ld	hl, sp+93
	inc	[hl]
	jp	NZ, .l00152
	inc	hl
	inc	[hl]
.l00152:
	jp	.l00111
.l00122:
	ld	hl, sp+93
	ld	a, [hl]
	ld	hl, sp+83
	ld	[hl], a
	ld	hl, sp+94
	ld	a, [hl]
	ld	hl, sp+84
	ld	[hl], a
	ld	hl, sp+88
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $0003
	ld	a, e
	sub	a, l
	ld	e, a
	ld	a, d
	sbc	a, h
	ld	hl, sp+86
	ld	[hl], a
	dec	hl
	ld	[hl], e
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	bc, $0003
	push	bc
	ld	bc, ___src_fatfs_fatfs_c_str_24
	call	___memcpy
;src/fatfs/fatfs.c:1063: if ((result = SnapshotFile(temp, 1, first))) return result;
	ld	hl, sp+89
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	push	de
	ld	a, $01
	ld	hl, 2
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_SnapshotFile__far
	ld	c, a
	or	a, a
	jp	Z, .l00106
	ld	a, c
	jp	.l00113
.l00106:
;src/fatfs/fatfs.c:1065: memcpy(path + n - 3, "bak", 3); f_unlink(path);
	ld	hl, sp+94
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, sp+91
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+89
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+88
	ld	[hl], a
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $0003
	ld	a, e
	sub	a, l
	ld	e, a
	ld	a, d
	sbc	a, h
	ld	hl, sp+94
	ld	[hl], a
	dec	hl
	ld	[hl], e
	ld	de, $0003
	push	de
	ld	bc, ___src_fatfs_fatfs_c_str_25
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	___memcpy
	ld	hl, sp+91
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_f_unlink__far
;src/fatfs/fatfs.c:1066: memcpy(temp + n - 3, "sav", 3); result = f_rename(temp, path);
	ld	hl, sp+85
	ld	a, [hl]
	ld	hl, sp+93
	ld	[hl], a
	ld	hl, sp+86
	ld	a, [hl]
	ld	hl, sp+94
	ld	[hl], a
	ld	de, $0003
	push	de
	ld	bc, ___src_fatfs_fatfs_c_str_26
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	___memcpy
	ld	hl, sp+91
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	ld	hl, 0
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_f_rename__far
;src/fatfs/fatfs.c:1067: if (result && result != FR_NO_FILE) return result;
	or	a, a
	jp	Z, .l00108
	cp	a, $04
	jp	NZ,.l00153
	jp	.l00108
.l00153:
	jp	.l00113
.l00108:
;src/fatfs/fatfs.c:1068: memcpy(temp + n - 3, "tmp", 3); memcpy(path + n - 3, "sav", 3);
	push	hl
	ld	hl, 2
	add	hl, sp
	ld	e, l
	ld	d, h
	pop	hl
	ld	hl, sp+83
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+89
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+88
	ld	[hl], a
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $0003
	ld	a, e
	sub	a, l
	ld	e, a
	ld	a, d
	sbc	a, h
	ld	hl, sp+94
	ld	[hl], a
	dec	hl
	ld	[hl], e
	ld	de, $0003
	push	de
	ld	bc, ___src_fatfs_fatfs_c_str_24
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	___memcpy
	ld	hl, sp+84
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, sp+91
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+95
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+94
	ld	[hl], a
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $0003
	ld	a, e
	sub	a, l
	ld	e, a
	ld	a, d
	sbc	a, h
	ld	hl, sp+88
	ld	[hl], a
	dec	hl
	ld	[hl], e
	ld	a, [hl]
	ld	hl, sp+93
	ld	[hl], a
	ld	hl, sp+88
	ld	a, [hl]
	ld	hl, sp+94
	ld	[hl], a
	ld	de, $0003
	push	de
	ld	bc, ___src_fatfs_fatfs_c_str_26
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	___memcpy
;src/fatfs/fatfs.c:1069: result = f_rename(temp, path);
	ld	hl, sp+91
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	ld	hl, 0
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_f_rename__far
	ld	hl, sp+94
	ld	[hl], a
;src/fatfs/fatfs.c:1070: return result;
	ld	hl, sp+94
	ld	a, [hl]
.l00113:
;src/fatfs/fatfs.c:1071: }
	add	sp, 95
	ret
	SECTION FRAGMENT "src/fatfs/fatfs.c ROM0",ROM0
__str_22:
	DB "/GBCSYS/SAVE/"
	DB $00
	SECTION FRAGMENT "src/fatfs/fatfs.c ROM0",ROM0
___src_fatfs_fatfs_c_str_23:
	DB "/GBCSYS/SNAP"
	DB $00
	SECTION FRAGMENT "src/fatfs/fatfs.c ROM0",ROM0
___src_fatfs_fatfs_c_str_24:
	DB "tmp"
	DB $00
	SECTION FRAGMENT "src/fatfs/fatfs.c ROM0",ROM0
___src_fatfs_fatfs_c_str_25:
	DB "bak"
	DB $00
	SECTION FRAGMENT "src/fatfs/fatfs.c ROM0",ROM0
___src_fatfs_fatfs_c_str_26:
	DB "sav"
	DB $00
;src/fatfs/fatfs.c:1074: static FRESULT BackupSnapshot(char* path, UINT sectors) {
;	---------------------------------
	SECTION FRAGMENT "Page 14",ROMX,BANK[7]
	LOAD FRAGMENT "Page 14 RAM",SRAM,BANK[14]
; Function BackupSnapshot
; ---------------------------------
_BackupSnapshot:
	add	sp, -4
	ld	hl, sp+2
	ld	[hl], e
	inc	hl
	ld	[hl], d
;src/fatfs/fatfs.c:1076: if (sectors > 64) return FR_OK;
	ld	a, $40
	cp	a, c
	ld	a, $00
	sbc	a, b
	jp	NC, .l00102
	xor	a, a
	jp	.l00109
.l00102:
;src/fatfs/fatfs.c:1077: SaveRamBlock(64, 1); n = memcmp(WINDOW, "SAVE", 4);
	ld	a, $01
	ld	de, $0040
	call	_SaveRamBlock__far
	ld	de, $0004
	push	de
	ld	bc, ___src_fatfs_fatfs_c_str_27
	ld	de, $BE00
	call	_memcmp
;src/fatfs/fatfs.c:1078: SaveRamBlock(TB_PSRAM_HIGH << 8, 0);
	push	bc
	xor	a, a
	ld	de, $0100
	call	_SaveRamBlock__far
	pop	bc
;src/fatfs/fatfs.c:1079: if (n) return FR_OK;
	ld	a, b
	or	a, c
	jp	Z, .l00104
	xor	a, a
	jp	.l00109
.l00104:
;src/fatfs/fatfs.c:1080: SnapshotCopy(3);
	ld	a, $03
	call	_SnapshotCopy__far
;src/fatfs/fatfs.c:1081: memcpy(path, SNAP_FOLDER, sizeof(SNAP_FOLDER)-1);
	ld	bc, ___src_fatfs_fatfs_c_str_28+0
	pop	hl
	pop	de
	push	de
	push	hl
	ld	hl, $000D
	push	hl
	call	___memcpy
;src/fatfs/fatfs.c:1082: for (n = 0; path[n]; ++n); memcpy(path+n-3, "sav", 3);
	ld	bc, $0000
.l00107:
	ld	hl, sp+2
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	add	hl, bc
	inc	sp
	inc	sp
	push	hl
	pop	de
	push	de
	ld	a, [de]
	or	a, a
	jp	Z, .l00105
	inc	bc
	jp	.l00107
.l00105:
	pop	de
	push	de
	ld	hl, $0003
	ld	a, e
	sub	a, l
	ld	e, a
	ld	a, d
	sbc	a, h
	ld	c, e
	ld	e, c
	ld	d, a
	ld	bc, $0003
	push	bc
	ld	bc, ___src_fatfs_fatfs_c_str_29
	call	___memcpy
;src/fatfs/fatfs.c:1083: return SnapshotStore(path, SNAP_STAGE);
	ld	bc, $3C00
	pop	hl
	pop	de
	push	de
	push	hl
	call	_SnapshotStore__far
.l00109:
;src/fatfs/fatfs.c:1084: }
	add	sp, 4
	ret
	SECTION FRAGMENT "src/fatfs/fatfs.c ROM0",ROM0
___src_fatfs_fatfs_c_str_27:
	DB "SAVE"
	DB $00
	SECTION FRAGMENT "src/fatfs/fatfs.c ROM0",ROM0
___src_fatfs_fatfs_c_str_28:
	DB "/GBCSYS/SNAP/"
	DB $00
	SECTION FRAGMENT "src/fatfs/fatfs.c ROM0",ROM0
___src_fatfs_fatfs_c_str_29:
	DB "sav"
	DB $00
;src/fatfs/fatfs.c:1087: static FRESULT BackupRegistry(UINT sum) {
;	---------------------------------
	SECTION FRAGMENT "Page 12",ROMX,BANK[6]
	LOAD FRAGMENT "Page 12 RAM",SRAM,BANK[12]
; Function BackupRegistry
; ---------------------------------
_BackupRegistry:
	add	sp, -108
	ld	hl, sp+103
	ld	[hl], e
	inc	hl
	ld	[hl], d
;src/fatfs/fatfs.c:1089: char* path = (char*)record + 10;
;src/fatfs/fatfs.c:1092: if ((result = f_open(&save_file, REGISTRY, FA_READ))) return result == FR_NO_FILE ? FR_OK : result;
	ld	a, $01
	push	af
	inc	sp
	ld	bc, ___src_fatfs_fatfs_c_str_31
	ld	de, _save_file
	call	_f_open__far
	ld	hl, sp+106
	ld	[hl], a
	ld	hl, sp+106
	ld	a, [hl]
	inc	hl
	ld	[hl], a
	dec	hl
	ld	a, [hl]
	or	a, a
	jp	Z, .l00102
	inc	hl
	ld	a, [hl]
	sub	a, $04
	jp	NZ,.l00356
	jp	.l00357
.l00356:
	jp	.l00164
.l00357:
	xor	a, a
	ld	c, a
	jp	.l00165
.l00164:
	ld	hl, sp+107
	ld	a, [hl]
	ld	c, $00
.l00165:
	jp	.l00162
.l00102:
;src/fatfs/fatfs.c:1093: result = f_read(&save_file, buffer, 512, &done); f_close(&save_file);
	ld	hl, 93
	add	hl, sp
	ld	e, l
	ld	d, h
	push	de
	ld	de, $0200
	push	de
	ld	bc, _buffer
	ld	de, _save_file
	call	_f_read__far
	ld	hl, sp+107
	ld	[hl], a
	ld	de, _save_file
	call	_f_close__far
;src/fatfs/fatfs.c:1094: if (result) return result;
	ld	hl, sp+107
	ld	a, [hl]
	or	a, a
	jp	Z, .l00104
	ld	a, [hl]
	jp	.l00162
.l00104:
;src/fatfs/fatfs.c:1095: if (done < 266 || ld_16(buffer) != 0x1234 || ByteSum(buffer,264) != ld_16(buffer+264) || !buffer[263]) return FR_OK;
	ld	hl, sp+93
	ld	a, [hl]
	sub	a, $0A
	inc	hl
	ld	a, [hl]
	sbc	a, $01
	jp	C, .l00105
	ld	de, _buffer
	call	_ld_16
	ld	a, c
	sub	a, $34
	jp	NZ,.l00358
	ld	a, b
	sub	a, $12
	jp	NZ,.l00358
	jp	.l00359
.l00358:
	jp	.l00105
.l00359:
	ld	bc, $0108
	ld	de, _buffer
	call	_ByteSum
	ld	e, c
	ld	d, b
	push	de
	ld	de, (_buffer + 264)
	call	_ld_16
	pop	de
	ld	a, e
	sub	a, c
	jp	NZ,.l00360
	ld	a, d
	sub	a, b
	jp	NZ,.l00360
	jp	.l00361
.l00360:
	jp	.l00105
.l00361:
	ld	a, [(_buffer + 263) + 0]
	or	a, a
	jp	NZ, .l00106
.l00105:
	xor	a, a
	jp	.l00162
.l00106:
;src/fatfs/fatfs.c:1096: sectors = ld_16(buffer+16); rtc = buffer[13];
	ld	de, (_buffer + 16)
	call	_ld_16
	ld	hl, sp+95
	ld	[hl], c
	inc	hl
	ld	[hl], b
	ld	hl, (_buffer + 13) + 0
	ld	a, [hl]
	ld	hl, sp+97
	ld	[hl], a
;src/fatfs/fatfs.c:1097: if (sectors > 256) return FR_INT_ERR;
	ld	hl, sp+95
	ld	a, $00
	sub	a, [hl]
	inc	hl
	ld	a, $01
	sbc	a, [hl]
	jp	NC, .l00111
	ld	a, $02
	jp	.l00162
.l00111:
;src/fatfs/fatfs.c:1098: memcpy(path,SAVE_FOLDER,sizeof(SAVE_FOLDER)-1);
	ld	de, $000D
	push	de
	ld	bc, __str_30
	ld	hl, 12
	add	hl, sp
	ld	e, l
	ld	d, h
	call	___memcpy
;src/fatfs/fatfs.c:1099: for (i=0; i<208 && buffer[34+i]; ++i);
	xor	a, a
	ld	hl, sp+106
	ld	[hl], a
	inc	hl
	ld	[hl], a
.l00148:
	ld	hl, sp+106
	ld	a, [hl]
	sub	a, $D0
	inc	hl
	ld	a, [hl]
	sbc	a, $00
	jp	NC, .l00112
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $0022
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+101
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+100
	ld	[hl], a
	ld	de, _buffer
	dec	hl
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+103
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+102
	ld	[hl], a
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	or	a, a
	jp	Z, .l00112
	ld	hl, sp+106
	inc	[hl]
	jp	NZ, .l00362
	inc	hl
	inc	[hl]
.l00362:
	jp	.l00148
.l00112:
;src/fatfs/fatfs.c:1100: if (!i || i >= FS_NAME_SIZE) { backup_skipped=1; return FR_OK; }
	ld	hl, sp+107
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	jp	Z, .l00113
	ld	a, [hl]
	sub	a, $41
	inc	hl
	ld	a, [hl]
	sbc	a, $00
	jp	C, .l00114
.l00113:
	ld	hl, _backup_skipped
	ld	[hl], $01
	xor	a, a
	jp	.l00162
.l00114:
;src/fatfs/fatfs.c:1101: raw = i == 11; n = sizeof(SAVE_FOLDER)-1;
	ld	hl, sp+106
	ld	a, [hl]
	sub	a, $0B
	inc	hl
	or	a, [hl]
	jp	NZ,.l00363
	ld	a,$01
	jp	.l00364
.l00363:
	xor	a,a
.l00364:
	ld	hl, sp+98
	ld	[hl], a
	ld	hl, sp+105
	ld	[hl], $0D
;src/fatfs/fatfs.c:1102: for (i=0; buffer[34+i] && i<208; ++i) {
	xor	a, a
	inc	hl
	ld	[hl], a
	inc	hl
	ld	[hl], a
.l00152:
	ld	hl, sp+107
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $0022
	add	hl, de
	ld	c, l
	ld	b, h
	ld	hl, _buffer
	add	hl, bc
	push	hl
	ld	a, l
	ld	hl, sp+101
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+100
	ld	[hl], a
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	or	a, a
	jp	Z, .l00122
	ld	hl, sp+106
	ld	a, [hl]
	sub	a, $D0
	inc	hl
	ld	a, [hl]
	sbc	a, $00
	jp	NC, .l00122
;src/fatfs/fatfs.c:1103: if (raw && i==8) path[n++]='.';
	ld	hl, sp+98
	ld	a, [hl]
	or	a, a
	jp	Z, .l00117
	ld	hl, sp+106
	ld	a, [hl]
	sub	a, $08
	inc	hl
	or	a, [hl]
	jp	NZ,.l00365
	jp	.l00366
.l00365:
	jp	.l00117
.l00366:
	ld	hl, sp+105
	ld	a, [hl]
	ld	hl, sp+102
	ld	[hl], a
	ld	hl, sp+105
	inc	[hl]
	push	hl
	ld	hl, 12
	add	hl, sp
	ld	e, l
	ld	d, h
	pop	hl
	ld	hl, sp+102
	ld	l, [hl]
	ld	h, $00
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+103
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+102
	ld	[hl], a
	dec	hl
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	ld	[hl], $2E
.l00117:
;src/fatfs/fatfs.c:1102: for (i=0; buffer[34+i] && i<208; ++i) {
	ld	hl, sp+100
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	ld	c, a
;src/fatfs/fatfs.c:1104: if (!raw || buffer[34+i]!=' ') path[n++]=buffer[34+i];
	dec	hl
	dec	hl
	ld	a, [hl]
	or	a, a
	jp	Z, .l00119
	ld	a, c
	sub	a, $20
	jp	NZ,.l00367
	jp	.l00153
.l00367:
.l00119:
	ld	hl, sp+105
	ld	e, [hl]
	inc	[hl]
	ld	d, $00
	ld	hl, 10
	add	hl, sp
	add	hl, de
	ld	[hl], c
.l00153:
;src/fatfs/fatfs.c:1102: for (i=0; buffer[34+i] && i<208; ++i) {
	ld	hl, sp+106
	inc	[hl]
	jp	NZ, .l00368
	inc	hl
	inc	[hl]
.l00368:
	jp	.l00152
.l00122:
;src/fatfs/fatfs.c:1106: path[n]=0;
	push	hl
	ld	hl, 12
	add	hl, sp
	ld	e, l
	ld	d, h
	pop	hl
	ld	hl, sp+105
	ld	l, [hl]
	ld	h, $00
	add	hl, de
	ld	c, l
	ld	b, h
	xor	a, a
	ld	[bc], a
;src/fatfs/fatfs.c:1107: for (i=n; i>sizeof(SAVE_FOLDER)-1 && path[i]!='.'; --i);
	ld	hl, sp+105
	ld	a, [hl]
	ld	hl, sp+101
	ld	[hl], a
	inc	hl
	ld	[hl], $00
	dec	hl
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
.l00156:
	ld	a, $0D
	cp	a, c
	ld	a, $00
	sbc	a, b
	jp	NC, .l00210
	ld	hl, 10
	add	hl, sp
	add	hl, bc
	ld	a, [hl]
	sub	a, $2E
	jp	NZ,.l00369
	jp	.l00210
.l00369:
	dec	bc
	jp	.l00156
.l00210:
	ld	hl, sp+106
	ld	[hl], c
	inc	hl
	ld	[hl], b
;src/fatfs/fatfs.c:1108: if (i==sizeof(SAVE_FOLDER)-1) i=n;
	ld	a, c
	sub	a, $0D
	or	a, b
	jp	NZ,.l00370
	jp	.l00371
.l00370:
	jp	.l00125
.l00371:
	ld	hl, sp+101
	ld	a, [hl]
	ld	hl, sp+106
	ld	[hl], a
	ld	hl, sp+102
	ld	a, [hl]
	ld	hl, sp+107
	ld	[hl], a
.l00125:
;src/fatfs/fatfs.c:1109: memcpy(path+i,".srm",5);
	push	hl
	ld	hl, 12
	add	hl, sp
	ld	e, l
	ld	d, h
	pop	hl
	ld	hl, sp+106
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+103
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+102
	ld	[hl], a
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	bc, $0005
	push	bc
	ld	bc, ___src_fatfs_fatfs_c_str_32
	call	___memcpy
;src/fatfs/fatfs.c:1110: if (sectors<256) {
	ld	hl, sp+95
	ld	a, [hl]
	sub	a, $00
	inc	hl
	ld	a, [hl]
	sbc	a, $01
	jp	NC, .l00130
;src/fatfs/fatfs.c:1111: SaveRamBlock(255,1);
	ld	a, $01
	ld	de, $00FF
	call	_SaveRamBlock__far
;src/fatfs/fatfs.c:1112: for (n=0; n<16 && WINDOW[480+n]==n; ++n);
	ld	hl, sp+107
	ld	[hl], $00
.l00160:
	ld	hl, sp+107
	ld	a, [hl]
	sub	a, $10
	jp	NC, .l00126
	ld	c, [hl]
	ld	b, $00
	ld	hl, $01E0
	add	hl, bc
	ld	a, h
	add	a, $BE
	ld	h, a
	ld	c, [hl]
	ld	hl, sp+107
	ld	a, [hl]
	sub	a, c
	jp	NZ,.l00372
	jp	.l00373
.l00372:
	jp	.l00126
.l00373:
	ld	hl, sp+107
	inc	[hl]
	jp	.l00160
.l00126:
;src/fatfs/fatfs.c:1113: SaveRamBlock(TB_PSRAM_HIGH << 8,0);
	xor	a, a
	ld	de, $0100
	call	_SaveRamBlock__far
;src/fatfs/fatfs.c:1114: if (n!=16) { backup_skipped=1; return FR_OK; }
	ld	hl, sp+107
	ld	a, [hl]
	sub	a, $10
	jp	NZ,.l00374
	jp	.l00130
.l00374:
	ld	hl, _backup_skipped
	ld	[hl], $01
	xor	a, a
	jp	.l00162
.l00130:
;src/fatfs/fatfs.c:1116: f_mkdir("/GBCSYS/SAVE");
	ld	de, ___src_fatfs_fatfs_c_str_33
	call	_f_mkdir__far
;src/fatfs/fatfs.c:1117: if (sectors) {
	ld	hl, sp+96
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	jp	Z, .l00137
;src/fatfs/fatfs.c:1118: if ((result=f_open(&save_file,path,FA_WRITE|FA_CREATE_ALWAYS))) return result;
	ld	a, $0A
	push	af
	inc	sp
	ld	hl, 11
	add	hl, sp
	ld	c, l
	ld	b, h
	ld	de, _save_file
	call	_f_open__far
	ld	c, a
	or	a, a
	jp	Z, .l00132
	ld	a, c
	jp	.l00162
.l00132:
;src/fatfs/fatfs.c:1119: result=SaveRamFile(sectors,1); closed=f_close(&save_file); if (result || closed) return result ? result : closed;
	ld	a, $01
	ld	hl, sp+95
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_SaveRamFile__far
	ld	hl, sp+106
	ld	[hl], a
	ld	de, _save_file
	call	_f_close__far
	ld	hl, sp+107
	ld	[hl], a
	dec	hl
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00133
	inc	hl
	ld	a, [hl]
	or	a, a
	jp	Z, .l00137
.l00133:
	ld	hl, sp+106
	ld	a, [hl]
	or	a, a
	jp	Z, .l00166
	ld	a, [hl]
	inc	hl
	ld	[hl], a
	jp	.l00167
.l00166:
.l00167:
	ld	hl, sp+107
	ld	a, [hl]
	jp	.l00162
.l00137:
;src/fatfs/fatfs.c:1121: if (rtc) { memcpy(path+i+1,"rtc",3); if ((result=WriteGameRTC(path))) return result; }
	ld	hl, sp+97
	ld	a, [hl]
	or	a, a
	jp	Z, .l00141
	ld	hl, sp+102
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $0001
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, sp+108
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+107
	ld	[hl], a
	ld	de, $0003
	push	de
	ld	bc, ___src_fatfs_fatfs_c_str_34
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	___memcpy
	ld	hl, 10
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_WriteGameRTC
	ld	c, a
	or	a, a
	jp	Z, .l00141
	ld	a, c
	jp	.l00162
.l00141:
;src/fatfs/fatfs.c:1122: if ((result=BackupSnapshot(path,sectors))) return result;
	ld	hl, sp+95
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	ld	hl, 10
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_BackupSnapshot__far
	ld	c, a
	or	a, a
	jp	Z, .l00143
	ld	a, c
	jp	.l00162
.l00143:
;src/fatfs/fatfs.c:1123: memcpy(record,"GAM3",4); record[4]=0; st_16(record+5,sum); record[7]=rtc; st_16(record+8,sectors);
	ld	de, $0004
	push	de
	ld	bc, ___src_fatfs_fatfs_c_str_35
	ld	hl, 2
	add	hl, sp
	ld	e, l
	ld	d, h
	call	___memcpy
	ld	hl, sp+4
	ld	[hl], $00
	ld	hl, sp+103
	ld	a, [hl]
	ld	hl, sp+106
	ld	[hl], a
	dec	hl
	dec	hl
	ld	a, [hl]
	ld	hl, sp+107
	ld	[hl], a
	dec	hl
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	ld	hl, 5
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_st_16
	ld	hl, sp+97
	ld	a, [hl]
	ld	hl, sp+7
	ld	[hl], a
	ld	hl, sp+95
	ld	a, [hl]
	ld	hl, sp+106
	ld	[hl], a
	ld	hl, sp+96
	ld	a, [hl]
	ld	hl, sp+107
	ld	[hl], a
	dec	hl
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	ld	hl, 8
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_st_16
;src/fatfs/fatfs.c:1125: if ((result=f_open(&save_file,GAME_RECORD,FA_WRITE|FA_CREATE_ALWAYS))) return result;
	ld	a, $0A
	push	af
	inc	sp
	ld	bc, ___src_fatfs_fatfs_c_str_36
	ld	de, _save_file
	call	_f_open__far
	ld	c, a
	or	a, a
	jp	Z, .l00145
	ld	a, c
	jp	.l00162
.l00145:
;src/fatfs/fatfs.c:1126: result=f_write(&save_file,record,10,&done); closed=f_close(&save_file);
	ld	hl, 93
	add	hl, sp
	ld	e, l
	ld	d, h
	push	de
	ld	de, $000A
	push	de
	ld	hl, 4
	add	hl, sp
	ld	c, l
	ld	b, h
	ld	de, _save_file
	call	_f_write__far
	ld	hl, sp+106
	ld	[hl], a
	ld	de, _save_file
	call	_f_close__far
	ld	hl, sp+107
	ld	[hl], a
;src/fatfs/fatfs.c:1127: return result ? result : done!=10 ? FR_DENIED : closed;
	ld	hl, sp+106
	ld	a, [hl]
	or	a, a
	jp	Z, .l00168
	ld	a, [hl]
	inc	hl
	ld	[hl], a
	jp	.l00169
.l00168:
	ld	hl, sp+93
	ld	a, [hl]
	sub	a, $0A
	inc	hl
	or	a, [hl]
	jp	NZ,.l00375
	jp	.l00170
.l00375:
	ld	a, $07
	jp	.l00171
.l00170:
	ld	hl, sp+107
	ld	a, [hl]
.l00171:
	ld	hl, sp+107
	ld	[hl], a
.l00169:
	ld	hl, sp+107
	ld	a, [hl]
.l00162:
;src/fatfs/fatfs.c:1128: }
	add	sp, 108
	ret
	SECTION FRAGMENT "src/fatfs/fatfs.c ROM0",ROM0
__str_30:
	DB "/GBCSYS/SAVE/"
	DB $00
	SECTION FRAGMENT "src/fatfs/fatfs.c ROM0",ROM0
___src_fatfs_fatfs_c_str_31:
	DB "/GBCSYS/REGISTRY.BIN"
	DB $00
	SECTION FRAGMENT "src/fatfs/fatfs.c ROM0",ROM0
___src_fatfs_fatfs_c_str_32:
	DB ".srm"
	DB $00
	SECTION FRAGMENT "src/fatfs/fatfs.c ROM0",ROM0
___src_fatfs_fatfs_c_str_33:
	DB "/GBCSYS/SAVE"
	DB $00
	SECTION FRAGMENT "src/fatfs/fatfs.c ROM0",ROM0
___src_fatfs_fatfs_c_str_34:
	DB "rtc"
	DB $00
	SECTION FRAGMENT "src/fatfs/fatfs.c ROM0",ROM0
___src_fatfs_fatfs_c_str_35:
	DB "GAM3"
	DB $00
	SECTION FRAGMENT "src/fatfs/fatfs.c ROM0",ROM0
___src_fatfs_fatfs_c_str_36:
	DB "/GBCSYS/EDITOR.GAM"
	DB $00
;src/fatfs/fatfs.c:1131: unsigned char fs_Snapshot(BYTE action) {
;	---------------------------------
	SECTION FRAGMENT "Page 4",ROMX,BANK[2]
	LOAD FRAGMENT "Page 4 RAM",SRAM,BANK[4]
; Function fs_Snapshot
; ---------------------------------
_fs_Snapshot::
	add	sp, -84
	ld	hl, sp+83
	ld	[hl], a
;src/fatfs/fatfs.c:1134: SetWindowBlock(GAME_META);
	ld	de, $3E2F
	call	_SetWindowBlock
;src/fatfs/fatfs.c:1135: if (WINDOW[128] > 64 || WINDOW[129]) { SetWindowBlock(TB_PSRAM_HIGH << 8); return FR_DENIED; }
	ld	hl, $BE80
	ld	c, [hl]
	ld	a, $40
	sub	a, c
	jp	C, .l00101
	ld	a, [$BE81]
	or	a, a
	jp	Z, .l00102
.l00101:
	ld	de, $0100
	call	_SetWindowBlock
	ld	a, $07
	jp	.l00116
.l00102:
;src/fatfs/fatfs.c:1136: memcpy(path, WINDOW, sizeof(path)); path[sizeof(path)-1] = 0;
	ld	de, $0053
	push	de
	ld	bc, $BE00
	ld	hl, 2
	add	hl, sp
	ld	e, l
	ld	d, h
	call	___memcpy
	ld	hl, sp+82
	ld	[hl], $00
;src/fatfs/fatfs.c:1137: SetWindowBlock(TB_PSRAM_HIGH << 8);
	ld	de, $0100
	call	_SetWindowBlock
;src/fatfs/fatfs.c:1138: if (!path[0]) return FR_NO_FILE;
	ld	hl, sp+0
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00105
	ld	a, $04
	jp	.l00116
.l00105:
;src/fatfs/fatfs.c:1139: if ((result = fs_Mount())) return result;
	call	_fs_Mount__far
	ld	c, a
	or	a, a
	jp	Z, .l00107
	ld	a, c
	jp	.l00116
.l00107:
;src/fatfs/fatfs.c:1140: if (action) {
	ld	hl, sp+83
	ld	a, [hl]
	or	a, a
	jp	Z, .l00113
;src/fatfs/fatfs.c:1141: if ((result = SnapshotFile(path, 0, SNAP_STAGE))) return result;
	ld	de, $3C00
	push	de
	xor	a, a
	ld	hl, 2
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_SnapshotFile__far
	ld	c, a
	or	a, a
	jp	Z, .l00109
	ld	a, c
	jp	.l00116
.l00109:
;src/fatfs/fatfs.c:1142: SetWindowBlock(SNAP_STAGE);
	ld	de, $3C00
	call	_SetWindowBlock
;src/fatfs/fatfs.c:1143: result = !memcmp(WINDOW + 10, "GB\1", 3) && WINDOW[13] != snapshot_model ? FR_DENIED : FR_OK;
	ld	de, $0003
	push	de
	ld	bc, ___src_fatfs_fatfs_c_str_38
	ld	de, $BE0A
	call	_memcmp
	ld	a, b
	or	a, c
	jp	NZ, .l00118
	ld	hl, $BE0D
	ld	c, [hl]
	ld	hl, _snapshot_model
	ld	a, [hl]
	sub	a, c
	jp	NZ,.l00167
	jp	.l00118
.l00167:
	ld	bc, $0007
	jp	.l00119
.l00118:
	ld	bc, $0000
.l00119:
;src/fatfs/fatfs.c:1144: SetWindowBlock(TB_PSRAM_HIGH << 8);
	push	bc
	ld	de, $0100
	call	_SetWindowBlock
	pop	bc
;src/fatfs/fatfs.c:1145: if (result) return result;
	ld	a, c
	or	a, a
	jp	Z, .l00111
	ld	a, c
	jp	.l00116
.l00111:
;src/fatfs/fatfs.c:1146: SnapshotCopy(0); SnapshotCopy(1); return FR_OK;
	xor	a, a
	call	_SnapshotCopy
	ld	a, $01
	call	_SnapshotCopy
	xor	a, a
	jp	.l00116
.l00113:
;src/fatfs/fatfs.c:1148: result = SnapshotStore(path, SNAP_FIRST);
	ld	bc, $3E40
	ld	hl, 0
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_SnapshotStore
	ld	c, a
;src/fatfs/fatfs.c:1149: if (!result) SnapshotCopy(1);
	ld	a, c
	or	a, a
	jp	NZ, .l00115
	push	bc
	ld	a, $01
	call	_SnapshotCopy
	pop	bc
.l00115:
;src/fatfs/fatfs.c:1150: return result;
	ld	a, c
.l00116:
;src/fatfs/fatfs.c:1151: }
	add	sp, 84
	ret
	SECTION FRAGMENT "src/fatfs/fatfs.c ROM0",ROM0
__str_37:
	DB "/GBCSYS/SAVE/"
	DB $00
	SECTION FRAGMENT "src/fatfs/fatfs.c ROM0",ROM0
___src_fatfs_fatfs_c_str_38:
	DB "GB"
	DB $01
	DB $00
;src/fatfs/fatfs.c:1153: unsigned char fs_GameFinish(const char* path) {
;	---------------------------------
	SECTION FRAGMENT "Page 11",ROMX,BANK[5]
	LOAD FRAGMENT "Page 11 RAM",SRAM,BANK[11]
; Function fs_GameFinish
; ---------------------------------
_fs_GameFinish::
	add	sp, -128
	add	sp, -55
	ld	hl, 179
	add	hl, sp
	ld	[hl], e
	inc	hl
	ld	[hl], d
;src/fatfs/fatfs.c:1158: if (game_save_sectors < 256) {
	ld	hl, _game_save_sectors
	ld	a, [hl]
	sub	a, $00
	inc	hl
	ld	a, [hl]
	sbc	a, $01
	jp	NC, .l00102
;src/fatfs/fatfs.c:1159: SaveRamBlock(255, 1); memset(WINDOW + 480, 0, 16); SaveRamBlock(TB_PSRAM_HIGH << 8, 0);
	ld	a, $01
	ld	de, $00FF
	call	_SaveRamBlock__far
	ld	de, $0010
	push	de
	ld	bc, $0000
	ld	de, $BFE0
	call	_memset
	xor	a, a
	ld	de, $0100
	call	_SaveRamBlock__far
.l00102:
;src/fatfs/fatfs.c:1161: result = f_mkdir("/GBCSYS/SAVE"); if (result && result != FR_EXIST) return result;
	ld	de, ___src_fatfs_fatfs_c_str_40
	call	_f_mkdir__far
	ld	hl, 182
	add	hl, sp
	ld	[hl], a
	ld	a, [hl]
	or	a, a
	jp	Z, .l00104
	ld	a, [hl]
	sub	a, $08
	jp	NZ,.l00320
	jp	.l00104
.l00320:
	ld	hl, 182
	add	hl, sp
	ld	a, [hl]
	jp	.l00158
.l00104:
;src/fatfs/fatfs.c:1162: GamePath((char*)record + 10, path, ".srm");
	ld	de, ___src_fatfs_fatfs_c_str_41
	push	de
	ld	hl, 181
	add	hl, sp
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	ld	hl, 14
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_GamePath__far
;src/fatfs/fatfs.c:1163: GamePath(rtc_path, path, ".rtc");
	ld	de, ___src_fatfs_fatfs_c_str_42
	push	de
	ld	hl, 181
	add	hl, sp
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	ld	hl, 97
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_GamePath__far
;src/fatfs/fatfs.c:1164: if (game_save_sectors) {
	ld	hl, _game_save_sectors + 1
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	jp	Z, .l00117
;src/fatfs/fatfs.c:1165: result = f_open(&save_file, (const char*)record + 10, FA_READ);
	ld	a, $01
	push	af
	inc	sp
	ld	hl, 13
	add	hl, sp
	ld	c, l
	ld	b, h
	ld	de, _save_file
	call	_f_open__far
	ld	hl, 182
	add	hl, sp
	ld	[hl], a
;src/fatfs/fatfs.c:1166: if (!result) {
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00112
;src/fatfs/fatfs.c:1167: result = SaveRamFile(game_save_sectors, 0); f_close(&save_file);
	xor	a, a
	ld	hl, _game_save_sectors
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_SaveRamFile__far
	ld	hl, 178
	add	hl, sp
	ld	[hl], a
	ld	de, _save_file
	call	_f_close__far
	jp	.l00113
.l00112:
;src/fatfs/fatfs.c:1169: else if (result == FR_NO_FILE || result == FR_NO_PATH) {
	ld	hl, 182
	add	hl, sp
	ld	a, [hl]
	sub	a, $04
	jp	NZ,.l00321
	jp	.l00107
.l00321:
	ld	hl, 182
	add	hl, sp
	ld	a, [hl]
	sub	a, $05
	jp	NZ,.l00322
	jp	.l00323
.l00322:
	jp	.l00108
.l00323:
.l00107:
;src/fatfs/fatfs.c:1170: result = FR_OK;
	ld	hl, 178
	add	hl, sp
	ld	[hl], $00
;src/fatfs/fatfs.c:1171: f_mkdir("/GBCSYS/SAVE");
	ld	de, ___src_fatfs_fatfs_c_str_40
	call	_f_mkdir__far
;src/fatfs/fatfs.c:1172: for (block = 0; block < game_save_sectors; ++block) { SaveRamBlock(block, 1); memset(WINDOW, 0xFF, 512); }
	xor	a, a
	ld	hl, sp+0
	ld	[hl], a
	inc	hl
	ld	[hl], a
	xor	a, a
	ld	hl, 181
	add	hl, sp
	ld	[hl], a
	inc	hl
	ld	[hl], a
.l00151:
	ld	hl, 181
	add	hl, sp
	ld	e, l
	ld	d, h
	ld	hl, _game_save_sectors
	ld	a, [de]
	inc	de
	sub	a, [hl]
	inc	hl
	ld	a, [de]
	sbc	a, [hl]
	jp	NC, .l00193
	ld	a, $01
	ld	hl, 181
	add	hl, sp
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_SaveRamBlock__far
	ld	de, $0200
	push	de
	ld	bc, $00FF
	ld	de, $BE00
	call	_memset
	ld	hl, 181
	add	hl, sp
	inc	[hl]
	jp	NZ, .l00324
	inc	hl
	inc	[hl]
.l00324:
	ld	hl, 181
	add	hl, sp
	ld	a, [hl]
	ld	hl, sp+0
	ld	[hl], a
	ld	hl, 182
	add	hl, sp
	ld	a, [hl]
	ld	hl, sp+1
	ld	[hl], a
	jp	.l00151
.l00193:
	ld	hl, 181
	add	hl, sp
	ld	a, [hl]
	ld	hl, sp+0
	ld	[hl], a
	ld	hl, 182
	add	hl, sp
	ld	a, [hl]
	ld	hl, sp+1
	ld	[hl], a
;src/fatfs/fatfs.c:1173: SaveRamBlock(TB_PSRAM_HIGH << 8, 0);
	xor	a, a
	ld	de, $0100
	call	_SaveRamBlock__far
	jp	.l00113
.l00108:
;src/fatfs/fatfs.c:1175: else return result;
	ld	hl, 182
	add	hl, sp
	ld	a, [hl]
	jp	.l00158
.l00113:
;src/fatfs/fatfs.c:1176: if (result) return result;
	ld	hl, 178
	add	hl, sp
	ld	a, [hl]
	or	a, a
	jp	Z, .l00117
	ld	a, [hl]
	jp	.l00158
.l00117:
;src/fatfs/fatfs.c:1178: if (game_save_sectors <= 64) { SaveRamBlock(64, 1); memset(WINDOW, 0, 4); SaveRamBlock(TB_PSRAM_HIGH << 8, 0); }
	ld	hl, _game_save_sectors
	ld	a, $40
	sub	a, [hl]
	inc	hl
	ld	a, $00
	sbc	a, [hl]
	jp	C, .l00119
	ld	a, $01
	ld	de, $0040
	call	_SaveRamBlock__far
	ld	de, $0004
	push	de
	ld	bc, $0000
	ld	de, $BE00
	call	_memset
	xor	a, a
	ld	de, $0100
	call	_SaveRamBlock__far
.l00119:
;src/fatfs/fatfs.c:1179: if (game_has_rtc && (result = ReadGameRTC(rtc_path))) return result;
	ld	hl, _game_has_rtc
	ld	a, [hl]
	or	a, a
	jp	Z, .l00121
	ld	hl, 95
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_ReadGameRTC__far
	ld	c, a
	or	a, a
	jp	Z, .l00121
	ld	a, c
	jp	.l00158
.l00121:
;src/fatfs/fatfs.c:1180: SnapshotPath(rtc_path, path);
	ld	hl, 179
	add	hl, sp
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	ld	hl, 95
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_SnapshotPath__far
;src/fatfs/fatfs.c:1181: SetWindowBlock(GAME_META); memset(WINDOW, 0, 512);
	ld	de, $3E2F
	call	_SetWindowBlock
	ld	de, $0200
	push	de
	ld	bc, $0000
	ld	de, $BE00
	call	_memset
;src/fatfs/fatfs.c:1182: memcpy(WINDOW, rtc_path, sizeof(rtc_path)); WINDOW[128] = game_ram_mask > 3 ? 255 : game_save_sectors; WINDOW[129] = game_save_sectors >> 8;
	ld	de, $0053
	push	de
	ld	hl, 97
	add	hl, sp
	ld	c, l
	ld	b, h
	ld	de, $BE00
	call	___memcpy
	ld	a, $03
	ld	hl, _game_ram_mask
	sub	a, [hl]
	jp	NC, .l00160
	ld	bc, $00FF
	jp	.l00161
.l00160:
	ld	hl, _game_save_sectors
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
.l00161:
	ld	hl, $BE80
	ld	[hl], c
	ld	hl, _game_save_sectors + 1
	ld	a, [hl]
	ld	hl, $BE81
	ld	[hl], a
;src/fatfs/fatfs.c:1183: SetWindowBlock(TB_PSRAM_HIGH << 8);
	ld	de, $0100
	call	_SetWindowBlock
;src/fatfs/fatfs.c:1184: if (game_save_sectors <= 64) {
	ld	hl, _game_save_sectors
	ld	a, $40
	sub	a, [hl]
	inc	hl
	ld	a, $00
	sbc	a, [hl]
	jp	C, .l00131
;src/fatfs/fatfs.c:1185: result = SnapshotFile(rtc_path, 0, SNAP_STAGE);
	ld	de, $3C00
	push	de
	xor	a, a
	ld	hl, 97
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_SnapshotFile__far
;src/fatfs/fatfs.c:1186: if (!result) SnapshotCopy(2);
	or	a, a
	jp	NZ, .l00128
	ld	a, $02
	call	_SnapshotCopy__far
	jp	.l00131
.l00128:
;src/fatfs/fatfs.c:1187: else if (result != FR_NO_FILE && result != FR_NO_PATH && result != FR_INT_ERR) return result;
	cp	a, $04
	jp	NZ,.l00325
	jp	.l00131
.l00325:
	cp	a, $05
	jp	NZ,.l00326
	jp	.l00131
.l00326:
	cp	a, $02
	jp	NZ,.l00327
	jp	.l00131
.l00327:
	jp	.l00158
.l00131:
;src/fatfs/fatfs.c:1189: result = GameCheats(path);
	ld	hl, 179
	add	hl, sp
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_GameCheats__far
	ld	c, a
;src/fatfs/fatfs.c:1190: if (!result) result = RegistryGame(path);
	ld	a, c
	or	a, a
	jp	NZ, .l00133
	ld	hl, 179
	add	hl, sp
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_RegistryGame__far
	ld	c, a
.l00133:
;src/fatfs/fatfs.c:1191: { FRESULT closed = f_close(&file); if (!result) result = closed; }
	push	bc
	ld	de, _file
	call	_f_close__far
	pop	bc
	ld	b, a
	ld	a, c
	or	a, a
	jp	NZ, .l00135
	ld	c, b
.l00135:
;src/fatfs/fatfs.c:1192: if (result) return result;
	ld	a, c
	or	a, a
	jp	Z, .l00137
	ld	a, c
	jp	.l00158
.l00137:
;src/fatfs/fatfs.c:1193: sum = RegistrySum();
	call	_RegistrySum__far
	ld	hl, 181
	add	hl, sp
	ld	[hl], c
	inc	hl
	ld	[hl], b
;src/fatfs/fatfs.c:1194: memcpy(record, "GAM3", 4); record[4] = 1;
	ld	de, $0004
	push	de
	ld	bc, ___src_fatfs_fatfs_c_str_43
	ld	hl, 4
	add	hl, sp
	ld	e, l
	ld	d, h
	call	___memcpy
	ld	hl, sp+6
	ld	[hl], $01
;src/fatfs/fatfs.c:1195: record[5] = sum; record[6] = sum >> 8; record[7] = game_has_rtc;
	ld	hl, 181
	add	hl, sp
	ld	a, [hl]
	ld	hl, sp+7
	ld	[hl], a
	ld	hl, 182
	add	hl, sp
	ld	a, [hl]
	ld	hl, sp+8
	ld	[hl], a
	ld	hl, _game_has_rtc
	ld	a, [hl]
	ld	hl, sp+9
	ld	[hl], a
;src/fatfs/fatfs.c:1196: record[8] = game_save_sectors; record[9] = game_save_sectors >> 8;
	ld	hl, _game_save_sectors
	ld	a, [hl]
	ld	hl, sp+10
	ld	[hl], a
	ld	hl, _game_save_sectors + 1
	ld	a, [hl]
	ld	hl, sp+11
	ld	[hl], a
;src/fatfs/fatfs.c:1197: if (!(result = f_open(&save_file, GAME_RECORD, FA_WRITE | FA_CREATE_ALWAYS))) {
	ld	a, $0A
	push	af
	inc	sp
	ld	bc, ___src_fatfs_fatfs_c_str_44
	ld	de, _save_file
	call	_f_open__far
	ld	c, a
	ld	b, c
	ld	a, c
	or	a, a
	jp	NZ, .l00145
;src/fatfs/fatfs.c:1198: for (done = 10; record[done]; ++done);
	ld	de, $000A
.l00154:
	ld	hl, 2
	add	hl, sp
	add	hl, de
	ld	a, [hl]
	inc	de
	or	a, a
	jp	Z, .l00138
	jp	.l00154
.l00138:
;src/fatfs/fatfs.c:1199: ++done;
;src/fatfs/fatfs.c:1200: result = f_write(&save_file, record, done, &block);
	ld	hl, 2
	add	hl, sp
	ld	c, l
	ld	b, h
	push	de
	ld	hl, 2
	add	hl, sp
	push	hl
	push	de
	ld	de, _save_file
	call	_f_write__far
	pop	de
	ld	b, a
;src/fatfs/fatfs.c:1201: if (!result && block != done) result = FR_DENIED;
	ld	a, b
	or	a, a
	jp	NZ, .l00140
	ld	hl, sp+0
	ld	a, [hl]
	sub	a, e
	jp	NZ,.l00328
	inc	hl
	ld	a, [hl]
	sub	a, d
	jp	NZ,.l00328
	jp	.l00140
.l00328:
	ld	b, $07
.l00140:
;src/fatfs/fatfs.c:1202: { FRESULT closed = f_close(&save_file); if (!result) result = closed; }
	push	bc
	ld	de, _save_file
	call	_f_close__far
	pop	bc
	ld	c, a
	ld	a, b
	or	a, a
	jp	NZ, .l00145
	ld	b, c
.l00145:
;src/fatfs/fatfs.c:1204: if (!result && game_save_sectors < 256) {
	ld	a, b
	or	a, a
	jp	NZ, .l00148
	ld	hl, _game_save_sectors
	ld	a, [hl]
	sub	a, $00
	inc	hl
	ld	a, [hl]
	sbc	a, $01
	jp	NC, .l00148
;src/fatfs/fatfs.c:1205: SaveRamBlock(255, 1); for (done = 0; done < 16; ++done) WINDOW[480 + done] = done;
	push	bc
	ld	a, $01
	ld	de, $00FF
	call	_SaveRamBlock__far
	pop	bc
	ld	de, $0000
.l00156:
	ld	hl, $01E0
	add	hl, de
	ld	a, h
	add	a, $BE
	ld	h, a
;	spillPairReg hl
;	spillPairReg hl
	ld	a, e
	ld	[hl], a
	inc	de
	ld	a, e
	sub	a, $10
	ld	a, d
	sbc	a, $00
	jp	C, .l00156
;src/fatfs/fatfs.c:1206: SaveRamBlock(TB_PSRAM_HIGH << 8, 0);
	push	bc
	xor	a, a
	ld	de, $0100
	call	_SaveRamBlock__far
	pop	bc
.l00148:
;src/fatfs/fatfs.c:1208: return result;
	ld	a, b
.l00158:
;src/fatfs/fatfs.c:1209: }
	add	sp, 127
	add	sp, 56
	ret
	SECTION FRAGMENT "src/fatfs/fatfs.c ROM0",ROM0
__str_39:
	DB "/GBCSYS/SAVE/"
	DB $00
	SECTION FRAGMENT "src/fatfs/fatfs.c ROM0",ROM0
___src_fatfs_fatfs_c_str_40:
	DB "/GBCSYS/SAVE"
	DB $00
	SECTION FRAGMENT "src/fatfs/fatfs.c ROM0",ROM0
___src_fatfs_fatfs_c_str_41:
	DB ".srm"
	DB $00
	SECTION FRAGMENT "src/fatfs/fatfs.c ROM0",ROM0
___src_fatfs_fatfs_c_str_42:
	DB ".rtc"
	DB $00
	SECTION FRAGMENT "src/fatfs/fatfs.c ROM0",ROM0
___src_fatfs_fatfs_c_str_43:
	DB "GAM3"
	DB $00
	SECTION FRAGMENT "src/fatfs/fatfs.c ROM0",ROM0
___src_fatfs_fatfs_c_str_44:
	DB "/GBCSYS/EDITOR.GAM"
	DB $00
;src/fatfs/fatfs.c:1225: static FRESULT SwapBlocks(BYTE write, WORD block, WORD offset, WORD count) {
;	---------------------------------
	SECTION FRAGMENT "Page 8",ROMX,BANK[4]
	LOAD FRAGMENT "Page 8 RAM",SRAM,BANK[8]
; Function SwapBlocks
; ---------------------------------
_SwapBlocks:
	add	sp, -16
	ld	hl, sp+13
	ld	[hl], a
	inc	hl
	ld	[hl], e
	inc	hl
	ld	[hl], d
;src/fatfs/fatfs.c:1227: FRESULT result = FR_OK;
	ld	hl, sp+2
	ld	[hl], $00
;src/fatfs/fatfs.c:1228: while (count && !result) {
.l00107:
	ld	hl, sp+21
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	jp	Z, .l00109
	ld	hl, sp+2
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00109
;src/fatfs/fatfs.c:1229: size = 512 - offset;
	ld	de, $0200
	ld	hl, sp+18
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	ld	a, e
	sub	a, l
	ld	e, a
	ld	a, d
	sbc	a, h
	ld	c, e
	ld	hl, sp+3
	ld	[hl], c
	inc	hl
	ld	[hl], a
;src/fatfs/fatfs.c:1230: if (size > count) size = count;
	dec	hl
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	ld	hl, sp+20
	ld	a, [hl]
	ld	hl, sp+5
	ld	[hl], a
	ld	hl, sp+21
	ld	a, [hl]
	ld	hl, sp+6
	ld	[hl], a
	ld	hl, sp+20
	ld	a, [hl]
	sub	a, c
	inc	hl
	ld	a, [hl]
	sbc	a, b
	jp	NC, .l00102
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
.l00102:
;src/fatfs/fatfs.c:1231: SetWindowBlock(block++);
	ld	hl, sp+14
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	dec	hl
	inc	[hl]
	jp	NZ, .l00150
	inc	hl
	inc	[hl]
.l00150:
	call	_SetWindowBlock
;src/fatfs/fatfs.c:1232: result = write ? f_write(&file, WINDOW + offset, size, &done) : f_read(&file, WINDOW + offset, size, &done);
	ld	hl, sp+19
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $BE00
	add	hl, de
	ld	e, l
	ld	d, h
	ld	c, e
	ld	b, d
	ld	hl, sp+13
	ld	a, [hl]
	or	a, a
	jp	Z, .l00112
	push	de
	ld	hl, 2
	add	hl, sp
	push	hl
	ld	hl, sp+7
	ld	a, [hl]
	inc	hl
	ld	h, [hl]
;	spillPairReg hl
;	spillPairReg hl
	ld	l, a
;	spillPairReg hl
;	spillPairReg hl
	push	hl
	ld	de, _file
	call	_f_write__far
	pop	de
	jp	.l00113
.l00112:
	push	de
	ld	hl, 2
	add	hl, sp
	push	hl
	ld	hl, sp+7
	ld	a, [hl]
	inc	hl
	ld	h, [hl]
;	spillPairReg hl
;	spillPairReg hl
	ld	l, a
;	spillPairReg hl
;	spillPairReg hl
	push	hl
	ld	de, _file
	call	_f_read__far
	pop	de
.l00113:
	ld	hl, sp+2
	ld	[hl], a
;src/fatfs/fatfs.c:1233: if (!result && done != size) result = FR_DENIED;
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00104
	dec	hl
	dec	hl
	ld	a, [hl]
	ld	hl, sp+3
	sub	a, [hl]
	jp	NZ,.l00151
	dec	hl
	dec	hl
	ld	a, [hl]
	ld	hl, sp+4
	sub	a, [hl]
	jp	NZ,.l00151
	jp	.l00104
.l00151:
	ld	hl, sp+2
	ld	[hl], $07
.l00104:
;src/fatfs/fatfs.c:1234: swap_sum += ByteSum(WINDOW + offset, size);
	ld	hl, sp+3
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	call	_ByteSum
	ld	hl, sp+7
	ld	[hl], c
	inc	hl
	ld	[hl], b
	ld	hl, _swap_sum
	ld	a, [hl]
	ld	hl, sp+9
	ld	[hl], a
	ld	hl, _swap_sum + 1
	ld	a, [hl]
	ld	hl, sp+10
	ld	[hl], a
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, sp+7
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
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
	ld	a, [hl]
	ld	hl, _swap_sum
	ld	[hl], a
	ld	hl, sp+12
	ld	a, [hl]
	ld	hl, _swap_sum + 1
	ld	[hl], a
;src/fatfs/fatfs.c:1235: count -= size;
	ld	hl, sp+6
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, sp+3
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	ld	a, e
	sub	a, l
	ld	e, a
	ld	a, d
	sbc	a, h
	ld	c, e
	ld	hl, sp+20
	ld	[hl], c
	inc	hl
	ld	[hl], a
;src/fatfs/fatfs.c:1236: offset = 0;
	xor	a, a
	ld	hl, sp+18
	ld	[hl], a
	inc	hl
	ld	[hl], a
	jp	.l00107
.l00109:
;src/fatfs/fatfs.c:1238: SetWindowBlock(TB_PSRAM_HIGH << 8);
	ld	de, $0100
	call	_SetWindowBlock
;src/fatfs/fatfs.c:1239: return result;
	ld	hl, sp+2
	ld	a, [hl]
.l00110:
;src/fatfs/fatfs.c:1240: }
	add	sp, 16
	pop	hl
	add	sp, 4
	jp hl
;src/fatfs/fatfs.c:1243: unsigned char fs_SaveSwap(void) {
;	---------------------------------
	SECTION FRAGMENT "Page 8",ROMX,BANK[4]
	LOAD FRAGMENT "Page 8 RAM",SRAM,BANK[8]
; Function fs_SaveSwap
; ---------------------------------
_fs_SaveSwap::
	add	sp, -9
;src/fatfs/fatfs.c:1245: WORD clip = tb_ClipLength(), length = tb_Length();
	call	_tb_ClipLength
	ld	hl, sp+7
	ld	[hl], c
	inc	hl
	ld	[hl], b
	ld	hl, sp+7
	ld	a, [hl]
	ld	hl, sp+4
	ld	[hl], a
	ld	hl, sp+8
	ld	a, [hl]
	ld	hl, sp+5
	ld	[hl], a
	call	_tb_Length
	pop	hl
	push	bc
	ld	hl, sp+0
	ld	a, [hl]
	ld	hl, sp+6
	ld	[hl], a
	ld	hl, sp+1
	ld	a, [hl]
	ld	hl, sp+7
	ld	[hl], a
;src/fatfs/fatfs.c:1246: FRESULT result = fs_Mount();
	call	_fs_Mount
	ld	hl, sp+8
	ld	[hl], a
;src/fatfs/fatfs.c:1247: if (!result) result = Open(SWAP_PATH, FA_WRITE | FA_OPEN_ALWAYS);
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00102
	ld	a, $12
	ld	de, ___src_fatfs_fatfs_c_str_45
	call	_Open
	ld	hl, sp+8
	ld	[hl], a
.l00102:
;src/fatfs/fatfs.c:1248: if (result) return result;
	ld	hl, sp+8
	ld	a, [hl]
	or	a, a
	jp	Z, .l00104
	ld	a, [hl]
	jp	.l00121
.l00104:
;src/fatfs/fatfs.c:1249: swap_sum = 0;
	xor	a, a
	ld	hl, _swap_sum
	ld	[hl], a
	inc	hl
	ld	[hl], a
;src/fatfs/fatfs.c:1250: result = f_lseek(&file, SWAP_DATA);
	ld	de, $0000
	push	de
	ld	d, $02
	push	de
	ld	de, _file
	call	_f_lseek__far
	ld	hl, sp+8
	ld	[hl], a
;src/fatfs/fatfs.c:1251: if (!result) result = SwapBlocks(1, MAIN_BLOCK, TB_CLIP_OFFSET, clip);
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00106
	ld	hl, sp+4
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	push	de
	ld	de, $0100
	push	de
	ld	de, $01F0
	ld	a, $01
	call	_SwapBlocks
	ld	hl, sp+8
	ld	[hl], a
.l00106:
;src/fatfs/fatfs.c:1252: tb_read_pos = 0;
	xor	a, a
	ld	hl, _tb_read_pos
	ld	[hl], a
	inc	hl
	ld	[hl], a
;src/fatfs/fatfs.c:1253: while (!result && (size = tb_Read(buffer, FS_BUFFER_SIZE))) {
.l00111:
	ld	hl, sp+8
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00113
	ld	bc, $0200
	ld	de, _buffer
	call	_tb_Read
	ld	e, c
	ld	d, b
	ld	a, b
	or	a, c
	jp	Z, .l00113
;src/fatfs/fatfs.c:1254: swap_sum += ByteSum(buffer, size);
	push	de
	ld	c, e
	ld	b, d
	ld	de, _buffer
	call	_ByteSum
	pop	de
	ld	hl, _swap_sum
	ld	l, [hl]
;	spillPairReg hl
;	spillPairReg hl
	ld	a, [_swap_sum + 1]
	ld	h, a
;	spillPairReg hl
;	spillPairReg hl
	add	hl, bc
	ld	a, l
	ld	[_swap_sum], a
	ld	a, h
	ld	[_swap_sum + 1], a
;src/fatfs/fatfs.c:1255: result = f_write(&file, buffer, size, &done);
	ld	bc, _buffer
	push	de
	ld	hl, 4
	add	hl, sp
	push	hl
	push	de
	ld	de, _file
	call	_f_write__far
	pop	de
	ld	hl, sp+8
	ld	[hl], a
;src/fatfs/fatfs.c:1256: if (!result && done != size) result = FR_DENIED;
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00111
	ld	hl, sp+2
	ld	a, [hl]
	sub	a, e
	jp	NZ,.l00183
	inc	hl
	ld	a, [hl]
	sub	a, d
	jp	NZ,.l00183
	jp	.l00111
.l00183:
	ld	hl, sp+8
	ld	[hl], $07
	jp	.l00111
.l00113:
;src/fatfs/fatfs.c:1258: if (!result) result = f_lseek(&file, 0); // the header goes last, a write cut short leaves a bad sum
	ld	hl, sp+8
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00115
	ld	de, $0000
	push	de
	push	de
	ld	de, _file
	call	_f_lseek__far
	ld	hl, sp+8
	ld	[hl], a
.l00115:
;src/fatfs/fatfs.c:1259: if (!result) {
	ld	hl, sp+8
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00117
;src/fatfs/fatfs.c:1260: SetWindowBlock(MAIN_BLOCK);
	ld	de, $01F0
	call	_SetWindowBlock
;src/fatfs/fatfs.c:1261: memcpy(buffer, WINDOW, SWAP_INFO);
	ld	de, $0100
	push	de
	ld	bc, $BE00
	ld	de, _buffer
	call	___memcpy
;src/fatfs/fatfs.c:1262: SetWindowBlock(TB_PSRAM_HIGH << 8);
	ld	de, $0100
	call	_SetWindowBlock
;src/fatfs/fatfs.c:1263: memset(buffer + SWAP_INFO, 0, SWAP_DATA - SWAP_INFO);
	ld	de, $0100
	push	de
	ld	bc, $0000
	ld	de, (_buffer + 256)
	call	_memset
;src/fatfs/fatfs.c:1264: memcpy(buffer + SWAP_INFO, "SWP1", 4);
	ld	de, $0004
	push	de
	ld	bc, ___src_fatfs_fatfs_c_str_46
	ld	de, (_buffer + 256)
	call	___memcpy
;src/fatfs/fatfs.c:1265: ((WORD*)(buffer + SWAP_INFO))[2] = length;
	ld	de, (_buffer + 260)
	ld	hl, sp+6
	ld	a, [hl]
	ld	[de], a
	inc	de
	inc	hl
	ld	a, [hl]
	ld	[de], a
;src/fatfs/fatfs.c:1266: ((WORD*)(buffer + SWAP_INFO))[3] = swap_sum;
	ld	de, (_buffer + 262)
	ld	hl, _swap_sum
	ld	a, [hl]
	ld	[de], a
	inc	de
	inc	hl
	ld	a, [hl]
	ld	[de], a
;src/fatfs/fatfs.c:1267: ((WORD*)(buffer + SWAP_INFO))[4] = clip;
	ld	de, (_buffer + 264)
	ld	hl, sp+4
	ld	a, [hl]
	ld	[de], a
	inc	de
	inc	hl
	ld	a, [hl]
	ld	[de], a
;src/fatfs/fatfs.c:1268: result = f_write(&file, buffer, SWAP_DATA, &done);
	ld	hl, sp+2
	ld	c, l
	ld	b, h
	push	bc
	ld	de, $0200
	push	de
	ld	bc, _buffer
	ld	de, _file
	call	_f_write__far
	ld	hl, sp+8
	ld	[hl], a
.l00117:
;src/fatfs/fatfs.c:1270: if (f_close(&file) && !result) result = FR_DISK_ERR;
	ld	de, _file
	call	_f_close__far
	ld	hl, sp+7
	ld	[hl], a
	ld	hl, sp+7
	ld	a, [hl]
	or	a, a
	jp	Z, .l00119
	inc	hl
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00119
	ld	[hl], $01
.l00119:
;src/fatfs/fatfs.c:1271: return result;
	ld	hl, sp+8
	ld	a, [hl]
.l00121:
;src/fatfs/fatfs.c:1272: }
	add	sp, 9
	ret
	SECTION FRAGMENT "src/fatfs/fatfs.c ROM0",ROM0
___src_fatfs_fatfs_c_str_45:
	DB "/GBCSYS/EDITOR.SWP"
	DB $00
	SECTION FRAGMENT "src/fatfs/fatfs.c ROM0",ROM0
___src_fatfs_fatfs_c_str_46:
	DB "SWP1"
	DB $00
;src/fatfs/fatfs.c:1276: unsigned char fs_LoadSwap(void) {
;	---------------------------------
	SECTION FRAGMENT "Page 8",ROMX,BANK[4]
	LOAD FRAGMENT "Page 8 RAM",SRAM,BANK[8]
; Function fs_LoadSwap
; ---------------------------------
_fs_LoadSwap::
	add	sp, -7
;src/fatfs/fatfs.c:1280: SetWindowBlock(MAIN_BLOCK);
	ld	de, $01F0
	call	_SetWindowBlock
;src/fatfs/fatfs.c:1281: result = memcmp(WINDOW, TBSignature, 4) ? FR_OK : FR_EXIST; // PSRAM kept it (a reset), it's newer
	ld	de, $0004
	push	de
	ld	bc, _TBSignature
	ld	de, $BE00
	call	_memcmp
	ld	a, b
	or	a, c
	jp	Z, .l00130
	ld	bc, $0000
	jp	.l00131
.l00130:
	ld	bc, $0008
.l00131:
;src/fatfs/fatfs.c:1282: SetWindowBlock(TB_PSRAM_HIGH << 8);
	push	bc
	ld	de, $0100
	call	_SetWindowBlock
	pop	bc
;src/fatfs/fatfs.c:1283: if (!result) result = fs_Mount();
	ld	a, c
	or	a, a
	jp	NZ, .l00102
	call	_fs_Mount
	ld	c, a
.l00102:
;src/fatfs/fatfs.c:1284: if (!result) result = Open(SWAP_PATH, FA_READ);
	ld	a, c
	or	a, a
	jp	NZ, .l00104
	ld	a, $01
	ld	de, ___src_fatfs_fatfs_c_str_47
	call	_Open
	ld	c, a
.l00104:
;src/fatfs/fatfs.c:1285: if (result) return result;
	ld	a, c
	or	a, a
	jp	Z, .l00106
	ld	a, c
	jp	.l00128
.l00106:
;src/fatfs/fatfs.c:1286: result = f_read(&file, buffer, SWAP_DATA, &done);
	ld	bc, _buffer
	ld	de, _file
	ld	hl, 0
	add	hl, sp
	push	hl
	ld	hl, $0200
	push	hl
	call	_f_read__far
	ld	hl, sp+6
	ld	[hl], a
;src/fatfs/fatfs.c:1287: if (!result && (done != SWAP_DATA || memcmp(buffer + SWAP_INFO, "SWP1", 4))) result = FR_INVALID_OBJECT;
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00108
	ld	hl, sp+0
	ld	a, [hl]
	or	a, a
	jp	NZ,.l00219
	inc	hl
	ld	a, [hl]
	sub	a, $02
	jp	NZ,.l00219
	jp	.l00220
.l00219:
	jp	.l00107
.l00220:
	ld	de, $0004
	push	de
	ld	bc, ___src_fatfs_fatfs_c_str_48
	ld	de, (_buffer + 256)
	call	_memcmp
	ld	a, b
	or	a, c
	jp	Z, .l00108
.l00107:
	ld	hl, sp+6
	ld	[hl], $09
.l00108:
;src/fatfs/fatfs.c:1288: if (result) {
	ld	hl, sp+6
	ld	a, [hl]
	or	a, a
	jp	Z, .l00112
;src/fatfs/fatfs.c:1289: f_close(&file);
	ld	de, _file
	call	_f_close__far
;src/fatfs/fatfs.c:1290: return result;
	ld	hl, sp+6
	ld	a, [hl]
	jp	.l00128
.l00112:
;src/fatfs/fatfs.c:1292: length = ((WORD*)(buffer + SWAP_INFO))[2];
	ld	hl, (_buffer + 256) + 4
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
;src/fatfs/fatfs.c:1293: sum = ((WORD*)(buffer + SWAP_INFO))[3];
	ld	de, (_buffer + 262) + 0
	ld	a, [de]
	ld	hl, sp+2
	ld	[hl], a
	inc	de
	ld	a, [de]
	inc	hl
	ld	[hl], a
;src/fatfs/fatfs.c:1294: clip = ((WORD*)(buffer + SWAP_INFO))[4];
	ld	hl, (_buffer + 256) + 8
	ld	a, [hl+]
	ld	h, [hl]
;	spillPairReg hl
	ld	l, a
;	spillPairReg hl
;	spillPairReg hl
;src/fatfs/fatfs.c:1295: SetWindowBlock(MAIN_BLOCK); // the header, without the signature until the sum checks out
	push	hl
	push	bc
	ld	de, $01F0
	call	_SetWindowBlock
	pop	bc
	pop	hl
;src/fatfs/fatfs.c:1296: memcpy(WINDOW + 4, buffer + 4, SWAP_INFO - 4);
	push	hl
	push	bc
	ld	de, $00FC
	push	de
	ld	bc, (_buffer + 4)
	ld	de, $BE04
	call	___memcpy
	pop	bc
	pop	hl
;src/fatfs/fatfs.c:1297: swap_sum = 0;
	xor	a, a
	ld	[_swap_sum], a
	ld	[_swap_sum + 1], a
;src/fatfs/fatfs.c:1298: result = SwapBlocks(0, MAIN_BLOCK, TB_CLIP_OFFSET, clip);
	push	bc
	push	hl
	ld	de, $0100
	push	de
	ld	de, $01F0
	xor	a, a
	call	_SwapBlocks
	pop	bc
	ld	hl, sp+4
	ld	[hl], a
;src/fatfs/fatfs.c:1299: tb_Clear();
	push	bc
	call	_tb_Clear
	pop	bc
;src/fatfs/fatfs.c:1300: while (!result && length) {
.l00119:
	ld	hl, sp+4
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00121
	ld	a, b
	or	a, c
	jp	Z, .l00121
;src/fatfs/fatfs.c:1301: result = f_read(&file, buffer, length < FS_BUFFER_SIZE ? length : FS_BUFFER_SIZE, &done);
	inc	hl
	ld	[hl], c
	inc	hl
	ld	[hl], b
	dec	hl
	ld	a, [hl]
	sub	a, $00
	inc	hl
	ld	a, [hl]
	sbc	a, $02
	jp	NC, .l00132
	dec	hl
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	jp	.l00133
.l00132:
	ld	bc, $0200
.l00133:
	ld	de, _file
	ld	hl, 0
	add	hl, sp
	push	hl
	push	bc
	ld	bc, _buffer
	call	_f_read__far
	ld	hl, sp+4
	ld	[hl], a
;src/fatfs/fatfs.c:1302: if (!result && !done) result = FR_INVALID_OBJECT;
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00114
	ld	hl, sp+1
	ld	a, [hl]
	dec	hl
	or	a, [hl]
	jp	NZ, .l00114
	ld	hl, sp+4
	ld	[hl], $09
.l00114:
;src/fatfs/fatfs.c:1303: if (result) break;
	ld	hl, sp+4
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00121
;src/fatfs/fatfs.c:1304: swap_sum += ByteSum(buffer, done);
	pop	bc
	push	bc
	ld	de, _buffer
	call	_ByteSum
	ld	hl, _swap_sum
	ld	l, [hl]
;	spillPairReg hl
;	spillPairReg hl
	ld	a, [_swap_sum + 1]
	ld	h, a
;	spillPairReg hl
;	spillPairReg hl
	add	hl, bc
	ld	c, l
	ld	a, h
	ld	hl, _swap_sum
	ld	[hl], c
	inc	hl
	ld	[hl], a
;src/fatfs/fatfs.c:1305: tb_Append(buffer, done);
	pop	bc
	push	bc
	ld	de, _buffer
	call	_tb_Append
;src/fatfs/fatfs.c:1306: length -= done;
	ld	hl, sp+6
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	pop	hl
	push	hl
	ld	a, e
	sub	a, l
	ld	e, a
	ld	a, d
	sbc	a, h
	ld	c, e
	ld	b, a
	jp	.l00119
.l00121:
;src/fatfs/fatfs.c:1308: f_close(&file);
	ld	de, _file
	call	_f_close__far
;src/fatfs/fatfs.c:1309: if (!result && swap_sum != sum) result = FR_INVALID_OBJECT;
	ld	hl, sp+4
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00123
	ld	hl, _swap_sum
	ld	a, [hl]
	ld	hl, sp+2
	sub	a, [hl]
	jp	NZ,.l00221
	ld	hl, _swap_sum + 1
	ld	a, [hl]
	ld	hl, sp+3
	sub	a, [hl]
	jp	NZ,.l00221
	jp	.l00123
.l00221:
	ld	hl, sp+4
	ld	[hl], $09
.l00123:
;src/fatfs/fatfs.c:1310: if (result) {
	ld	hl, sp+4
	ld	a, [hl]
	or	a, a
	jp	Z, .l00126
;src/fatfs/fatfs.c:1311: tb_Clear();
	call	_tb_Clear
;src/fatfs/fatfs.c:1312: SetWindowBlock(MAIN_BLOCK); // and the settings
	ld	de, $01F0
	call	_SetWindowBlock
;src/fatfs/fatfs.c:1313: memset(WINDOW, 0, SWAP_INFO);
	ld	de, $0100
	push	de
	ld	bc, $0000
	ld	de, $BE00
	call	_memset
	jp	.l00127
.l00126:
;src/fatfs/fatfs.c:1315: SetWindowBlock(MAIN_BLOCK);
	ld	de, $01F0
	call	_SetWindowBlock
;src/fatfs/fatfs.c:1316: memcpy(WINDOW, TBSignature, 4);
	ld	de, $0004
	push	de
	ld	bc, _TBSignature
	ld	de, $BE00
	call	___memcpy
.l00127:
;src/fatfs/fatfs.c:1318: SetWindowBlock(TB_PSRAM_HIGH << 8);
	ld	de, $0100
	call	_SetWindowBlock
;src/fatfs/fatfs.c:1319: return result;
	ld	hl, sp+4
	ld	a, [hl]
.l00128:
;src/fatfs/fatfs.c:1320: }
	add	sp, 7
	ret
	SECTION FRAGMENT "src/fatfs/fatfs.c ROM0",ROM0
___src_fatfs_fatfs_c_str_47:
	DB "/GBCSYS/EDITOR.SWP"
	DB $00
	SECTION FRAGMENT "src/fatfs/fatfs.c ROM0",ROM0
___src_fatfs_fatfs_c_str_48:
	DB "SWP1"
	DB $00
;src/fatfs/fatfs.c:1323: unsigned char fs_Save(const char* path) {
;	---------------------------------
	SECTION FRAGMENT "Page 8",ROMX,BANK[4]
	LOAD FRAGMENT "Page 8 RAM",SRAM,BANK[8]
; Function fs_Save
; ---------------------------------
_fs_Save::
	add	sp, -3
;src/fatfs/fatfs.c:1325: FRESULT result = Open(path, FA_WRITE | FA_CREATE_ALWAYS);
	ld	a, $0A
	call	_Open
	ld	hl, sp+2
	ld	[hl], a
;src/fatfs/fatfs.c:1326: if (result) return result;
	ld	a, [hl]
	or	a, a
	jp	Z, .l00102
	ld	a, [hl]
	jp	.l00113
.l00102:
;src/fatfs/fatfs.c:1327: tb_read_pos = 0;
	xor	a, a
	ld	hl, _tb_read_pos
	ld	[hl], a
	inc	hl
	ld	[hl], a
;src/fatfs/fatfs.c:1328: while ((size = fs_crlf ? tb_ReadLines(buffer, FS_BUFFER_SIZE) : tb_Read(buffer, FS_BUFFER_SIZE))) {
.l00107:
	ld	hl, _fs_crlf
	ld	a, [hl]
	or	a, a
	jp	Z, .l00115
	ld	bc, $0200
	ld	de, _buffer
	call	_tb_ReadLines
	jp	.l00116
.l00115:
	ld	bc, $0200
	ld	de, _buffer
	call	_tb_Read
.l00116:
	ld	e, c
	ld	d, b
	ld	a, b
	or	a, c
	jp	Z, .l00109
;src/fatfs/fatfs.c:1329: if ((result = f_write(&file, buffer, size, &written))) break;
	ld	bc, _buffer
	push	de
	ld	hl, 2
	add	hl, sp
	push	hl
	push	de
	ld	de, _file
	call	_f_write__far
	pop	de
	ld	hl, sp+2
	ld	[hl], a
	or	a, a
	jp	NZ, .l00109
;src/fatfs/fatfs.c:1330: if (written != size) {
	dec	hl
	dec	hl
	ld	a, [hl]
	sub	a, e
	jp	NZ,.l00157
	inc	hl
	ld	a, [hl]
	sub	a, d
	jp	NZ,.l00157
	jp	.l00107
.l00157:
;src/fatfs/fatfs.c:1331: result = FR_DENIED; // disk full
	ld	hl, sp+2
	ld	[hl], $07
;src/fatfs/fatfs.c:1332: break;
.l00109:
;src/fatfs/fatfs.c:1335: if (f_close(&file) && !result) result = FR_DISK_ERR;
	ld	de, _file
	call	_f_close__far
	or	a, a
	jp	Z, .l00111
	ld	hl, sp+2
	ld	a, [hl]
	or	a, a
	jp	NZ, .l00111
	ld	[hl], $01
.l00111:
;src/fatfs/fatfs.c:1336: return result;
	ld	hl, sp+2
	ld	a, [hl]
.l00113:
;src/fatfs/fatfs.c:1337: }
	add	sp, 3
	ret
;src/fatfs/fatfs.c:1339: DWORD get_fattime(void) { return ClockFatTime(); }
;	---------------------------------
	SECTION FRAGMENT "Page 12",ROMX,BANK[6]
	LOAD FRAGMENT "Page 12 RAM",SRAM,BANK[12]
; Function get_fattime
; ---------------------------------
_get_fattime::
	jp	_ClockFatTime
.l00101:
	ret
	SECTION FRAGMENT "Page 12",ROMX,BANK[6]
	LOAD FRAGMENT "Page 12 RAM",SRAM,BANK[12]
	SECTION FRAGMENT "_INITIALIZER",ROM0
	SECTION FRAGMENT "_CABS (ABS)",ROM0

;far call thunks generated by bank_split.py
	SECTION FRAGMENT "src/fatfs/fatfs.c ROM0",ROM0
_BackupRegistry__far:
	call FarCallInline
	DB BANK(_BackupRegistry)
	DW _BackupRegistry
_BackupSnapshot__far:
	call FarCallInline
	DB BANK(_BackupSnapshot)
	DW _BackupSnapshot
_CheatApply__far:
	call FarCallInline
	DB BANK(_CheatApply)
	DW _CheatApply
_GameCheats__far:
	call FarCallInline
	DB BANK(_GameCheats)
	DW _GameCheats
_GamePath__far:
	call FarCallInline
	DB BANK(_GamePath)
	DW _GamePath
_Open__far:
	call FarCallInline
	DB BANK(_Open)
	DW _Open
_ReadGameRTC__far:
	call FarCallInline
	DB BANK(_ReadGameRTC)
	DW _ReadGameRTC
_RegistryGame__far:
	call FarCallInline
	DB BANK(_RegistryGame)
	DW _RegistryGame
_RegistrySum__far:
	call FarCallInline
	DB BANK(_RegistrySum)
	DW _RegistrySum
_SaveRamBlock__far:
	call FarCallInline
	DB BANK(_SaveRamBlock)
	DW _SaveRamBlock
_SaveRamFile__far:
	call FarCallInline
	DB BANK(_SaveRamFile)
	DW _SaveRamFile
_Signature__far:
	call FarCallInline
	DB BANK(_Signature)
	DW _Signature
_SnapshotCopy__far:
	call FarCallInline
	DB BANK(_SnapshotCopy)
	DW _SnapshotCopy
_SnapshotFile__far:
	call FarCallInline
	DB BANK(_SnapshotFile)
	DW _SnapshotFile
_SnapshotPath__far:
	call FarCallInline
	DB BANK(_SnapshotPath)
	DW _SnapshotPath
_SnapshotStore__far:
	call FarCallInline
	DB BANK(_SnapshotStore)
	DW _SnapshotStore
_WriteGameRTC__far:
	call FarCallInline
	DB BANK(_WriteGameRTC)
	DW _WriteGameRTC
_clst2sect__far:
	call FarCallInline
	DB BANK(_clst2sect)
	DW _clst2sect
_cmp_lfn__far:
	call FarCallInline
	DB BANK(_cmp_lfn)
	DW _cmp_lfn
_create_chain__far:
	call FarCallInline
	DB BANK(_create_chain)
	DW _create_chain
_create_name__far:
	call FarCallInline
	DB BANK(_create_name)
	DW _create_name
_dir_clear__far:
	call FarCallInline
	DB BANK(_dir_clear)
	DW _dir_clear
_dir_find__far:
	call FarCallInline
	DB BANK(_dir_find)
	DW _dir_find
_dir_next__far:
	call FarCallInline
	DB BANK(_dir_next)
	DW _dir_next
_dir_read__far:
	call FarCallInline
	DB BANK(_dir_read)
	DW _dir_read
_dir_register__far:
	call FarCallInline
	DB BANK(_dir_register)
	DW _dir_register
_dir_sdi__far:
	call FarCallInline
	DB BANK(_dir_sdi)
	DW _dir_sdi
_disk_read__far:
	call FarCallInline
	DB BANK(_disk_read)
	DW _disk_read
_disk_status__far:
	call FarCallInline
	DB BANK(_disk_status)
	DW _disk_status
_disk_write__far:
	call FarCallInline
	DB BANK(_disk_write)
	DW _disk_write
_f_close__far:
	call FarCallInline
	DB BANK(_f_close)
	DW _f_close
_f_lseek__far:
	call FarCallInline
	DB BANK(_f_lseek)
	DW _f_lseek
_f_mkdir__far:
	call FarCallInline
	DB BANK(_f_mkdir)
	DW _f_mkdir
_f_mount__far:
	call FarCallInline
	DB BANK(_f_mount)
	DW _f_mount
_f_open__far:
	call FarCallInline
	DB BANK(_f_open)
	DW _f_open
_f_read__far:
	call FarCallInline
	DB BANK(_f_read)
	DW _f_read
_f_rename__far:
	call FarCallInline
	DB BANK(_f_rename)
	DW _f_rename
_f_unlink__far:
	call FarCallInline
	DB BANK(_f_unlink)
	DW _f_unlink
_f_write__far:
	call FarCallInline
	DB BANK(_f_write)
	DW _f_write
_follow_path__far:
	call FarCallInline
	DB BANK(_follow_path)
	DW _follow_path
_fs_CloseLarge__far:
	call FarCallInline
	DB BANK(_fs_CloseLarge)
	DW _fs_CloseLarge
_fs_Mount__far:
	call FarCallInline
	DB BANK(_fs_Mount)
	DW _fs_Mount
_gen_numname__far:
	call FarCallInline
	DB BANK(_gen_numname)
	DW _gen_numname
_get_fat__far:
	call FarCallInline
	DB BANK(_get_fat)
	DW _get_fat
_get_fattime__far:
	call FarCallInline
	DB BANK(_get_fattime)
	DW _get_fattime
_get_fileinfo__far:
	call FarCallInline
	DB BANK(_get_fileinfo)
	DW _get_fileinfo
_get_ldnumber__far:
	call FarCallInline
	DB BANK(_get_ldnumber)
	DW _get_ldnumber
_ld_clust__far:
	call FarCallInline
	DB BANK(_ld_clust)
	DW _ld_clust
_mount_volume__far:
	call FarCallInline
	DB BANK(_mount_volume)
	DW _mount_volume
_move_window__far:
	call FarCallInline
	DB BANK(_move_window)
	DW _move_window
_oem2uni_sbcs__far:
	call FarCallInline
	DB BANK(_oem2uni_sbcs)
	DW _oem2uni_sbcs
_pick_lfn__far:
	call FarCallInline
	DB BANK(_pick_lfn)
	DW _pick_lfn
_put_lfn__far:
	call FarCallInline
	DB BANK(_put_lfn)
	DW _put_lfn
_remove_chain__far:
	call FarCallInline
	DB BANK(_remove_chain)
	DW _remove_chain
_st_clust__far:
	call FarCallInline
	DB BANK(_st_clust)
	DW _st_clust
_sync_fs__far:
	call FarCallInline
	DB BANK(_sync_fs)
	DW _sync_fs
_sync_window__far:
	call FarCallInline
	DB BANK(_sync_window)
	DW _sync_window
_uni2oem_sbcs__far:
	call FarCallInline
	DB BANK(_uni2oem_sbcs)
	DW _uni2oem_sbcs
_validate__far:
	call FarCallInline
	DB BANK(_validate)
	DW _validate