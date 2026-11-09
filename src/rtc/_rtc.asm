;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 4.2.0 #13081 (Linux)
;--------------------------------------------------------
	; MODULE rtc
	; Generated using the rgbds tokens.

;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	EXPORT _rtc_Advance
	EXPORT _rtc_FatTime
	EXPORT _rtc_Seconds
	EXPORT _rtc_Write
	EXPORT _rtc_Read
	EXPORT _RTCWrite
	EXPORT _RTCRead
;--------------------------------------------------------
; special function registers
;--------------------------------------------------------
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	SECTION FRAGMENT "src/rtc/rtc.c_DATA",WRAM0
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
	SECTION FRAGMENT "src/rtc/rtc.c_HOME",ROM0
	SECTION FRAGMENT "src/rtc/rtc.c_HOME",ROM0
;--------------------------------------------------------
; code
;--------------------------------------------------------
	SECTION FRAGMENT "src/rtc/rtc.c_CODE",ROMX
;src/rtc/rtc.c:3: static unsigned char Binary(unsigned char bcd) { return (bcd & 15) > 9 || bcd > 0x99 ? 255 : (bcd >> 4) * 10 + (bcd & 15); }
;	---------------------------------
	SECTION FRAGMENT "Page 12",ROMX,BANK[6]
	LOAD FRAGMENT "Page 12 RAM",SRAM,BANK[12]
; Function Binary
; ---------------------------------
_Binary:
	ld	c, a
	ld	a, c
	ld	b, $00
	and	a, $0F
	ld	l, a
;	spillPairReg hl
;	spillPairReg hl
	ld	b, $00
	ld	a, b
	ld	e, a
	ld	a, $00
	ld	d, a
	ld	a, $09
	cp	a, l
	ld	a, $00
	sbc	a, b
	bit	7, e
	jp	Z, .l00114
	bit	7, d
	jp	NZ, .l00115
	cp	a, a
	jp	.l00115
.l00114:
	bit	7, d
	jp	Z, .l00115
	scf
.l00115:
	jp	C, .l00106
	ld	a, $99
	sub	a, c
	jp	NC, .l00103
.l00106:
	ld	bc, $00FF
	jp	.l00104
.l00103:
	ld	a, c
	swap	a
	and	a, $0F
	ld	e, a
	add	a, a
	add	a, a
	add	a, e
	add	a, a
	ld	b, a
	ld	a, c
	and	a, $0F
	add	a, b
	ld	c, a
	rlca
	sbc	a, a
	ld	b, a
.l00104:
	ld	a, c
.l00101:
	ret
;src/rtc/rtc.c:4: static unsigned char BCD(unsigned char value) { unsigned char tens = 0; while (value >= 10) { value -= 10; tens += 16; } return tens | value; }
;	---------------------------------
	SECTION FRAGMENT "Page 12",ROMX,BANK[6]
	LOAD FRAGMENT "Page 12 RAM",SRAM,BANK[12]
; Function BCD
; ---------------------------------
_BCD:
	ld	c, a
	ld	l, $00
;	spillPairReg hl
;	spillPairReg hl
.l00101:
	ld	a, c
	sub	a, $0A
	jp	C, .l00103
	ld	a, c
	add	a, $F6
	ld	c, a
	ld	e, $10
	add	hl, de
	jp	.l00101
.l00103:
	ld	a, l
	or	a, c
.l00104:
	ret
;src/rtc/rtc.c:5: static unsigned char MonthDays(unsigned char year, unsigned char month) {
;	---------------------------------
	SECTION FRAGMENT "Page 12",ROMX,BANK[6]
	LOAD FRAGMENT "Page 12 RAM",SRAM,BANK[12]
; Function MonthDays
; ---------------------------------
_MonthDays:
	ld	d, a
;src/rtc/rtc.c:7: return days[month - 1] + (month == 2 && !(year & 3));
	ld	a, e
	dec	a
	ld	c, a
	rlca
	sbc	a, a
	ld	b, a
	ld	hl, _MonthDays_days_65536_14
	add	hl, bc
	ld	c, [hl]
	ld	a, e
	sub	a, $02
	jp	NZ,.l00111
	jp	.l00112
.l00111:
	jp	.l00103
.l00112:
	ld	a, d
	ld	b, $00
	and	a, $03
	jp	NZ,.l00113
	jp	.l00104
.l00113:
.l00103:
	xor	a, a
	jp	.l00105
.l00104:
	ld	a, $01
.l00105:
	add	a, c
.l00101:
;src/rtc/rtc.c:8: }
	ret
	SECTION FRAGMENT "Page 12",ROMX,BANK[6]
	LOAD FRAGMENT "Page 12 RAM",SRAM,BANK[12]
_MonthDays_days_65536_14:
	DB $1F	; 31
	DB $1C	; 28
	DB $1F	; 31
	DB $1E	; 30
	DB $1F	; 31
	DB $1E	; 30
	DB $1F	; 31
	DB $1F	; 31
	DB $1E	; 30
	DB $1F	; 31
	DB $1E	; 30
	DB $1F	; 31
;src/rtc/rtc.c:9: static unsigned char Valid(const ClockDate* date) {
;	---------------------------------
	SECTION FRAGMENT "Page 12",ROMX,BANK[6]
	LOAD FRAGMENT "Page 12 RAM",SRAM,BANK[12]
; Function Valid
; ---------------------------------
_Valid:
	ld	c, e
	ld	b, d
;src/rtc/rtc.c:10: return date->year < 100 && date->month && date->month <= 12 && date->day &&
	ld	a, [bc]
	ld	l, a
;	spillPairReg hl
;	spillPairReg hl
	ld	a, l
	sub	a, $64
	jp	NC, .l00103
	ld	e, c
	ld	d, b
	inc	de
	ld	a, [de]
	ld	h, a
;	spillPairReg hl
;	spillPairReg hl
	ld	a, h
	or	a, a
	jp	Z, .l00103
	ld	a, $0C
	sub	a, h
	jp	C, .l00103
	ld	e, c
	ld	d, b
	inc	de
	inc	de
	ld	a, [de]
	ld	d, a
	ld	a, d
	or	a, a
	jp	Z, .l00103
;src/rtc/rtc.c:11: date->day <= MonthDays(date->year, date->month) && date->hour < 24 && date->minute < 60 && date->second < 60;
	push	bc
	push	de
	ld	e, h
	ld	a, l
	call	_MonthDays
	ld	l, a
;	spillPairReg hl
;	spillPairReg hl
	pop	de
	pop	bc
	ld	a, l
	sub	a, d
	jp	C, .l00103
	ld	e, c
	ld	d, b
	inc	de
	inc	de
	inc	de
	ld	a, [de]
	sub	a, $18
	jp	NC, .l00103
	ld	hl, $0004
	add	hl, bc
	ld	a, [hl]
	sub	a, $3C
	jp	NC, .l00103
	ld	hl, $0005
	add	hl, bc
	ld	a, [hl]
	sub	a, $3C
	jp	C, .l00104
.l00103:
	xor	a, a
	jp	.l00105
.l00104:
	ld	a, $01
.l00105:
.l00101:
;src/rtc/rtc.c:12: }
	ret
;src/rtc/rtc.c:13: unsigned char rtc_Read(ClockDate* date) {
;	---------------------------------
	SECTION FRAGMENT "Page 12",ROMX,BANK[6]
	LOAD FRAGMENT "Page 12 RAM",SRAM,BANK[12]
; Function rtc_Read
; ---------------------------------
_rtc_Read::
	add	sp, -18
	ld	c, e
	ld	b, d
;src/rtc/rtc.c:15: if (RTCRead(raw) || (raw[15] & 0x80) || (raw[5] & 0x80)) return 1; // oscillator-stop flag
	push	bc
	ld	hl, 2
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_RTCRead
	pop	bc
	or	a, a
	jp	NZ, .l00101
	ld	hl, sp+15
	ld	a, [hl]
	rlca
	jp	C,.l00153
	jp	.l00154
.l00153:
	jp	.l00101
.l00154:
	ld	hl, 5
	add	hl, sp
	ld	e, l
	ld	d, h
	ld	a, [de]
	rlca
	jp	C,.l00155
	jp	.l00102
.l00155:
.l00101:
	ld	a, $01
	jp	.l00114
.l00102:
;src/rtc/rtc.c:16: date->year = Binary(raw[6]); date->month = Binary(raw[5] & 0x1F); date->day = Binary(raw[4] & 0x3F);
	ld	hl, 6
	add	hl, sp
	ld	l, [hl]
;	spillPairReg hl
	push	bc
	push	de
	ld	a, l
	call	_Binary
	pop	de
	pop	bc
	ld	[bc], a
	ld	l, c
;	spillPairReg hl
;	spillPairReg hl
	ld	h, b
;	spillPairReg hl
;	spillPairReg hl
	inc	hl
	ld	a, [de]
	and	a, $1F
	ld	e, a
	push	hl
	push	bc
	ld	a, e
	call	_Binary
	pop	bc
	pop	hl
	ld	[hl], a
	ld	e, c
	ld	d, b
	inc	de
	inc	de
	ld	hl, 4
	add	hl, sp
	ld	a, [hl]
	and	a, $3F
	ld	l, a
;	spillPairReg hl
;	spillPairReg hl
	push	bc
	push	de
	ld	a, l
	call	_Binary
	pop	de
	pop	bc
	ld	[de], a
;src/rtc/rtc.c:17: date->hour = Binary(raw[2] & ((raw[2] & 0x40) ? 0x1F : 0x3F));
	ld	hl, $0003
	add	hl, bc
	push	hl
	ld	a, l
	ld	hl, sp+18
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+17
	ld	[hl], a
	ld	hl, sp+2
	ld	a, [hl]
	bit	6, a
	jp	NZ,.l00156
	jp	.l00116
.l00156:
	ld	de, $001F
	jp	.l00117
.l00116:
	ld	de, $003F
.l00117:
	and	a, e
	ld	e, a
	push	bc
	ld	a, e
	call	_Binary
	pop	bc
	ld	hl, sp+16
	push	af
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	pop	af
	ld	[hl], a
;src/rtc/rtc.c:18: if (raw[2] & 0x40) { if (!date->hour || date->hour > 12) return 1; if (date->hour == 12) date->hour = 0; if (raw[2] & 0x20) date->hour += 12; }
	ld	hl, sp+2
	ld	a, [hl]
	bit	6, a
	jp	NZ,.l00157
	jp	.l00113
.l00157:
	ld	hl, sp+17
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	ld	l, a
;	spillPairReg hl
;	spillPairReg hl
	ld	a, l
	or	a, a
	jp	Z, .l00105
	ld	a, $0C
	sub	a, l
	jp	NC, .l00106
.l00105:
	ld	a, $01
	jp	.l00114
.l00106:
	ld	a, l
	sub	a, $0C
	jp	NZ,.l00158
	jp	.l00159
.l00158:
	jp	.l00109
.l00159:
	ld	hl, sp+16
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	ld	[hl], $00
.l00109:
	ld	hl, sp+2
	ld	a, [hl]
	bit	5, a
	jp	NZ,.l00160
	jp	.l00113
.l00160:
	ld	hl, sp+17
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	add	a, $0C
	dec	hl
	push	af
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	pop	af
	ld	[hl], a
.l00113:
;src/rtc/rtc.c:19: date->minute = Binary(raw[1] & 0x7F); date->second = Binary(raw[0] & 0x7F);
	ld	hl, $0004
	add	hl, bc
	ld	e, l
	ld	d, h
	ld	hl, 0
	add	hl, sp
	inc	hl
	ld	l, [hl]
;	spillPairReg hl
	res	7, l
	push	bc
	push	de
	ld	a, l
	call	_Binary
	pop	de
	pop	bc
	ld	[de], a
	ld	hl, $0005
	add	hl, bc
	push	hl
	ld	a, l
	ld	hl, sp+18
	ld	[hl], a
	pop	hl
	ld	a, h
	ld	hl, sp+17
	ld	[hl], a
	ld	hl, sp+0
	ld	l, [hl]
;	spillPairReg hl
;	spillPairReg hl
	res	7, l
	push	bc
	ld	a, l
	call	_Binary
	pop	bc
	ld	hl, sp+16
	push	af
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	pop	af
	ld	[hl], a
;src/rtc/rtc.c:20: return !Valid(date);
	ld	e, c
	ld	d, b
	call	_Valid
	sub	a,$01
	ld	a, $00
	rla
.l00114:
;src/rtc/rtc.c:21: }
	add	sp, 18
	ret
;src/rtc/rtc.c:22: static unsigned int Days(const ClockDate* date) {
;	---------------------------------
	SECTION FRAGMENT "Page 12",ROMX,BANK[6]
	LOAD FRAGMENT "Page 12 RAM",SRAM,BANK[12]
; Function Days
; ---------------------------------
_Days:
	add	sp, -6
	ld	hl, sp+3
	ld	[hl], e
	inc	hl
	ld	[hl], d
;src/rtc/rtc.c:23: unsigned int days = 0; unsigned char y, m;
	ld	bc, $0000
;src/rtc/rtc.c:24: for (y = 0; y < date->year; ++y) days += 365 + !(y & 3);
	inc	hl
	ld	[hl], $00
.l00104:
	ld	hl, sp+4
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	dec	hl
	dec	hl
	ld	[hl], a
	ld	hl, sp+5
	ld	a, [hl]
	ld	hl, sp+2
	sub	a, [hl]
	jp	NC, .l00101
	ld	hl, sp+5
	ld	a, [hl]
	ld	e, $00
	and	a, $03
	ld	d, a
	ld	e, $00
	ld	a, e
	or	a, d
	sub	a,$01
	ld	a, $00
	rla
	ld	h, $00
;	spillPairReg hl
;	spillPairReg hl
	ld	l, a
	ld	de, $016D
	add	hl, de
	add	hl, bc
	ld	c, l
	ld	b, h
	ld	hl, sp+5
	inc	[hl]
	jp	.l00104
.l00101:
;src/rtc/rtc.c:25: for (m = 1; m < date->month; ++m) days += MonthDays(date->year, m);
	ld	hl, sp+4
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $0001
	add	hl, de
	inc	sp
	inc	sp
	push	hl
	ld	hl, sp+5
	ld	[hl], $01
.l00107:
	pop	de
	push	de
	ld	a, [de]
	ld	hl, sp+2
	ld	[hl], a
	ld	hl, sp+5
	ld	a, [hl]
	ld	hl, sp+2
	sub	a, [hl]
	jp	NC, .l00102
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
	push	bc
	push	hl
	ld	hl, sp+9
	ld	e, [hl]
	pop	hl
	ld	a, l
	call	_MonthDays
	pop	bc
	ld	l, a
;	spillPairReg hl
;	spillPairReg hl
	ld	h, $00
;	spillPairReg hl
;	spillPairReg hl
	add	hl, bc
	ld	c, l
	ld	b, h
	ld	hl, sp+5
	inc	[hl]
	jp	.l00107
.l00102:
;src/rtc/rtc.c:26: return days + date->day - 1;
	ld	hl, sp+3
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	inc	de
	inc	de
	ld	a, [de]
	ld	h, $00
;	spillPairReg hl
;	spillPairReg hl
	ld	l, a
	add	hl, bc
	ld	c, l
	ld	b, h
	dec	bc
.l00109:
;src/rtc/rtc.c:27: }
	add	sp, 6
	ret
;src/rtc/rtc.c:28: unsigned char rtc_Write(const ClockDate* date) {
;	---------------------------------
	SECTION FRAGMENT "Page 12",ROMX,BANK[6]
	LOAD FRAGMENT "Page 12 RAM",SRAM,BANK[12]
; Function rtc_Write
; ---------------------------------
_rtc_Write::
	add	sp, -16
	ld	c, e
	ld	b, d
;src/rtc/rtc.c:31: if (!Valid(date) || RTCRead(raw)) return 1; // do not invent a device on carts without RTC
	push	bc
	ld	e, c
	ld	d, b
	call	_Valid
	ld	e, a
	pop	bc
	ld	a, e
	or	a, a
	jp	Z, .l00101
	push	bc
	ld	hl, 2
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_RTCRead
	pop	bc
	or	a, a
	jp	Z, .l00102
.l00101:
	ld	a, $01
	jp	.l00107
.l00102:
;src/rtc/rtc.c:32: raw[0] = BCD(date->second); raw[1] = BCD(date->minute); raw[2] = BCD(date->hour);
	ld	hl, $0005
	add	hl, bc
	ld	e, [hl]
	push	bc
	ld	a, e
	call	_BCD
	pop	bc
	ld	hl, sp+0
	ld	[hl], a
	ld	hl, $0004
	add	hl, bc
	ld	e, [hl]
	push	bc
	ld	a, e
	call	_BCD
	pop	bc
	ld	hl, sp+1
	ld	[hl], a
	ld	l, c
;	spillPairReg hl
;	spillPairReg hl
	ld	h, b
;	spillPairReg hl
;	spillPairReg hl
	inc	hl
	inc	hl
	inc	hl
	ld	e, [hl]
	push	bc
	ld	a, e
	call	_BCD
	pop	bc
	ld	hl, sp+2
	ld	[hl], a
;src/rtc/rtc.c:33: weekday = Days(date) + 6; while (weekday >= 7) weekday -= 7;
	push	bc
	ld	e, c
	ld	d, b
	call	_Days
	ld	e, c
	ld	d, b
	pop	bc
	ld	hl, $0006
	add	hl, de
.l00104:
	ld	a, l
	sub	a, $07
	ld	a, h
	sbc	a, $00
	jp	C, .l00106
	ld	a, l
	add	a, $F9
	ld	l, a
;	spillPairReg hl
;	spillPairReg hl
	ld	a, h
	adc	a, $FF
	ld	h, a
;	spillPairReg hl
;	spillPairReg hl
	jp	.l00104
.l00106:
;src/rtc/rtc.c:34: raw[3] = weekday + 1; // 2000-01-01 was Saturday
	ld	a, l
	inc	a
	ld	hl, sp+3
	ld	[hl], a
;src/rtc/rtc.c:35: raw[4] = BCD(date->day); raw[5] = BCD(date->month); raw[6] = BCD(date->year);
	ld	l, c
;	spillPairReg hl
;	spillPairReg hl
	ld	h, b
;	spillPairReg hl
;	spillPairReg hl
	inc	hl
	inc	hl
	ld	e, [hl]
	push	bc
	ld	a, e
	call	_BCD
	pop	bc
	ld	hl, sp+4
	ld	[hl], a
	ld	l, c
;	spillPairReg hl
;	spillPairReg hl
	ld	h, b
;	spillPairReg hl
;	spillPairReg hl
	inc	hl
	ld	e, [hl]
	push	bc
	ld	a, e
	call	_BCD
	pop	bc
	ld	hl, sp+5
	ld	[hl], a
	ld	a, [bc]
	ld	c, a
	ld	a, c
	call	_BCD
	ld	hl, sp+6
	ld	[hl], a
;src/rtc/rtc.c:36: raw[15] &= 0x7F; // clear OSF, preserve alarm/status bits
	ld	hl, sp+15
	ld	a, [hl]
	res	7, a
	ld	[hl], a
;src/rtc/rtc.c:38: i = RTCWrite(raw);
	ld	hl, 0
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_RTCWrite
;src/rtc/rtc.c:39: return i;
.l00107:
;src/rtc/rtc.c:40: }
	add	sp, 16
	ret
;src/rtc/rtc.c:41: unsigned long rtc_Seconds(const ClockDate* date) {
;	---------------------------------
	SECTION FRAGMENT "Page 12",ROMX,BANK[6]
	LOAD FRAGMENT "Page 12 RAM",SRAM,BANK[12]
; Function rtc_Seconds
; ---------------------------------
_rtc_Seconds::
	add	sp, -20
	ld	c, e
	ld	b, d
;src/rtc/rtc.c:42: unsigned long d = Days(date);
	push	bc
	ld	e, c
	ld	d, b
	call	_Days
	ld	e, c
	ld	d, b
	pop	bc
	inc	sp
	inc	sp
	push	de
	xor	a, a
	ld	hl, sp+2
	ld	[hl], a
	inc	hl
	ld	[hl], a
;src/rtc/rtc.c:43: unsigned int h = date->hour, m = date->minute;
	ld	e, c
	ld	d, b
	inc	de
	inc	de
	inc	de
	ld	a, [de]
	inc	hl
	ld	[hl], a
	inc	hl
	ld	[hl], $00
	ld	hl, $0004
	add	hl, bc
	ld	a, [hl]
	ld	hl, sp+6
	ld	[hl], a
	inc	hl
	ld	[hl], $00
;src/rtc/rtc.c:45: return (d << 16) + (d << 14) + (d << 12) + (d << 8) + (d << 7) +
	push	af
	ld	hl, sp+2
	ld	a, [hl]
	ld	hl, sp+12
	ld	[hl], a
	ld	hl, sp+3
	ld	a, [hl]
	ld	hl, sp+13
	ld	[hl], a
	pop	af
	ld	hl, sp+8
	ld	[hl], $00
	inc	hl
	ld	[hl], $00
	push	af
	ld	hl, sp+2
	ld	a, [hl]
	ld	hl, sp+19
	ld	[hl], a
	ld	hl, sp+3
	ld	a, [hl]
	ld	hl, sp+20
	ld	[hl], a
	ld	hl, sp+4
	ld	a, [hl]
	ld	hl, sp+21
	ld	[hl], a
	pop	af
	ld	hl, sp+16
	ld	[hl], $00
	ld	a, $06
.l00105:
	ld	hl, sp+17
	sla	[hl]
	inc	hl
	rl	[hl]
	inc	hl
	rl	[hl]
.l00106:
	dec	a
	jr	NZ,.l00105
	ld	hl, sp+9
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, e
	ld	hl, sp+16
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
	dec	hl
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, sp+20
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
	push	af
	ld	hl, sp+2
	ld	a, [hl]
	ld	hl, sp+19
	ld	[hl], a
	ld	hl, sp+3
	ld	a, [hl]
	ld	hl, sp+20
	ld	[hl], a
	ld	hl, sp+4
	ld	a, [hl]
	ld	hl, sp+21
	ld	[hl], a
	pop	af
	ld	hl, sp+16
	ld	[hl], $00
	ld	a, $04
.l00107:
	ld	hl, sp+17
	sla	[hl]
	inc	hl
	rl	[hl]
	inc	hl
	rl	[hl]
.l00108:
	dec	a
	jr	NZ,.l00107
	ld	hl, sp+13
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, e
	ld	hl, sp+16
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
	ld	hl, sp+17
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, sp+20
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
	push	af
	ld	hl, sp+2
	ld	a, [hl]
	ld	hl, sp+15
	ld	[hl], a
	ld	hl, sp+3
	ld	a, [hl]
	ld	hl, sp+16
	ld	[hl], a
	ld	hl, sp+4
	ld	a, [hl]
	ld	hl, sp+17
	ld	[hl], a
	pop	af
	ld	hl, sp+12
	ld	[hl], $00
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
	push	af
	ld	hl, sp+2
	ld	a, [hl]
	ld	hl, sp+14
	ld	[hl], a
	ld	hl, sp+3
	ld	a, [hl]
	ld	hl, sp+15
	ld	[hl], a
	ld	hl, sp+4
	ld	a, [hl]
	ld	hl, sp+16
	ld	[hl], a
	ld	hl, sp+5
	ld	a, [hl]
	ld	hl, sp+17
	ld	[hl], a
	pop	af
	ld	a, $07
.l00111:
	ld	hl, sp+12
	sla	[hl]
	inc	hl
	rl	[hl]
	inc	hl
	rl	[hl]
	inc	hl
	rl	[hl]
.l00112:
	dec	a
	jr	NZ,.l00111
	inc	hl
	inc	hl
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
	ld	hl, sp+11
	ld	[hl], a
	dec	hl
	ld	[hl], e
	ld	hl, sp+21
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
	ld	hl, sp+11
	ld	[hl], a
	dec	hl
	ld	[hl], e
;src/rtc/rtc.c:46: (h << 11) + (h << 10) + (h << 9) + (h << 4) + (m << 6) - (m << 2) + date->second;
	ld	hl, sp+4
	ld	a, [hl]
	add	a, a
	add	a, a
	add	a, a
	ld	e, $00
	ld	hl, sp+12
	ld	[hl], e
	inc	hl
	ld	[hl], a
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
	ld	hl, sp+4
	ld	a, [hl]
	add	a, a
	add	a, a
	ld	e, $00
	ld	hl, sp+12
	ld	[hl], e
	inc	hl
	ld	[hl], a
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
	ld	hl, sp+12
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
	ld	hl, sp+21
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
	ld	hl, sp+11
	ld	[hl], a
	dec	hl
	ld	[hl], e
	ld	hl, sp+4
	ld	a, [hl]
	add	a, a
	ld	e, $00
	ld	hl, sp+12
	ld	[hl], e
	inc	hl
	ld	[hl], a
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
	ld	hl, sp+4
	ld	a, [hl]
	inc	hl
	ld	e, [hl]
	add	a, a
	rl	e
	add	a, a
	rl	e
	add	a, a
	rl	e
	add	a, a
	rl	e
	ld	hl, sp+8
	ld	[hl], a
	inc	hl
	ld	[hl], e
	xor	a, a
	inc	hl
	ld	[hl], a
	inc	hl
	ld	[hl], a
	ld	hl, sp+17
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
	ld	hl, sp+21
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
	ld	hl, sp+6
	ld	a, [hl]
	inc	hl
	ld	e, [hl]
	add	a, a
	rl	e
	add	a, a
	rl	e
	add	a, a
	rl	e
	add	a, a
	rl	e
	add	a, a
	rl	e
	add	a, a
	rl	e
	inc	hl
	ld	[hl], a
	inc	hl
	ld	[hl], e
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
	ld	hl, sp+8
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
	dec	hl
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
	ld	hl, sp+19
	ld	[hl], a
	dec	hl
	ld	[hl], e
	ld	hl, sp+6
	ld	a, [hl]
	inc	hl
	ld	e, [hl]
	add	a, a
	rl	e
	add	a, a
	rl	e
	inc	hl
	ld	[hl], a
	inc	hl
	ld	[hl], e
	xor	a, a
	inc	hl
	ld	[hl], a
	inc	hl
	ld	[hl], a
	ld	hl, sp+17
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
	ld	hl, sp+15
	ld	[hl], a
	dec	hl
	ld	[hl], e
	ld	hl, sp+21
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
	ld	hl, sp+15
	ld	[hl], a
	dec	hl
	ld	[hl], e
	ld	hl, $0005
	add	hl, bc
	ld	a, [hl]
	ld	hl, sp+8
	ld	[hl], a
	xor	a, a
	inc	hl
	ld	[hl], a
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
	ld	hl, sp+8
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
	dec	hl
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
	ld	hl, sp+19
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
.l00101:
;src/rtc/rtc.c:47: }
	add	sp, 20
	ret
;src/rtc/rtc.c:48: unsigned long rtc_FatTime(void) {
;	---------------------------------
	SECTION FRAGMENT "Page 12",ROMX,BANK[6]
	LOAD FRAGMENT "Page 12 RAM",SRAM,BANK[12]
; Function rtc_FatTime
; ---------------------------------
_rtc_FatTime::
	add	sp, -14
;src/rtc/rtc.c:50: if (rtc_Read(&date)) return (46UL << 25) | (1UL << 21) | (1UL << 16); // 2026-01-01
	ld	hl, 0
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_rtc_Read
	or	a, a
	jp	Z, .l00102
	ld	bc, $0000
	ld	de, $5C21
	jp	.l00103
.l00102:
;src/rtc/rtc.c:51: return ((unsigned long)(date.year + 20) << 25) | ((unsigned long)date.month << 21) |
	ld	hl, sp+0
	ld	c, [hl]
	ld	b, $00
	ld	hl, $0014
	add	hl, bc
	ld	c, l
	ld	b, h
	ld	a, b
	rlca
	sbc	a, a
	ld	e, a
	ld	d, a
	ld	d, c
	ld	bc, $0000
	ld	e, $00
	sla	d
	ld	hl, sp+6
	ld	[hl], c
	inc	hl
	ld	[hl], b
	inc	hl
	ld	[hl], e
	inc	hl
	ld	[hl], d
	ld	hl, sp+1
	ld	c, [hl]
	ld	b, $00
	ld	de, $0000
	ld	de, $0000
	ld	a, $05
.l00112:
	sla	c
	rl	b
.l00113:
	dec	a
	jr	NZ,.l00112
	ld	hl, sp+6
	ld	a, [hl]
	or	a, e
	ld	hl, sp+10
	ld	[hl], a
	ld	hl, sp+7
	ld	a, [hl]
	or	a, d
	ld	hl, sp+11
	ld	[hl], a
	ld	hl, sp+8
	ld	a, [hl]
	or	a, c
	ld	hl, sp+12
	ld	[hl], a
	ld	hl, sp+9
	ld	a, [hl]
	or	a, b
	ld	hl, sp+13
	ld	[hl], a
;src/rtc/rtc.c:52: ((unsigned long)date.day << 16) | ((unsigned long)date.hour << 11) | ((unsigned int)date.minute << 5) | (date.second >> 1);
	ld	hl, sp+2
	ld	c, [hl]
	ld	b, $00
	ld	de, $0000
	ld	de, $0000
	ld	hl, sp+10
	ld	a, [hl]
	or	a, e
	ld	hl, sp+6
	ld	[hl], a
	ld	hl, sp+11
	ld	a, [hl]
	or	a, d
	ld	hl, sp+7
	ld	[hl], a
	ld	hl, sp+12
	ld	a, [hl]
	or	a, c
	ld	hl, sp+8
	ld	[hl], a
	ld	hl, sp+13
	ld	a, [hl]
	or	a, b
	ld	hl, sp+9
	ld	[hl], a
	ld	hl, sp+3
	ld	c, [hl]
	ld	b, $00
	ld	de, $0000
	ld	d, e
	ld	e, b
	ld	b, c
	ld	c, $00
	ld	a, $03
.l00116:
	sla	b
	rl	e
	rl	d
.l00117:
	dec	a
	jr	NZ,.l00116
	ld	hl, sp+6
	ld	a, [hl]
	or	a, c
	ld	hl, sp+10
	ld	[hl], a
	ld	hl, sp+7
	ld	a, [hl]
	or	a, b
	ld	hl, sp+11
	ld	[hl], a
	ld	hl, sp+8
	ld	a, [hl]
	or	a, e
	ld	hl, sp+12
	ld	[hl], a
	ld	hl, sp+9
	ld	a, [hl]
	or	a, d
	ld	hl, sp+13
	ld	[hl], a
	ld	hl, sp+4
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
	add	hl, hl
	ld	c, l
	ld	b, h
	ld	de, $0000
	ld	hl, sp+10
	ld	a, [hl]
	or	a, c
	ld	hl, sp+6
	ld	[hl], a
	ld	hl, sp+11
	ld	a, [hl]
	or	a, b
	ld	hl, sp+7
	ld	[hl], a
	ld	hl, sp+12
	ld	a, [hl]
	or	a, e
	ld	hl, sp+8
	ld	[hl], a
	ld	hl, sp+13
	ld	a, [hl]
	or	a, d
	ld	hl, sp+9
	ld	[hl], a
	ld	hl, sp+5
	ld	c, [hl]
	srl	c
	ld	b, $00
	ld	de, $0000
	inc	hl
	ld	a, [hl]
	or	a, c
	ld	hl, sp+10
	ld	[hl], a
	ld	hl, sp+7
	ld	a, [hl]
	or	a, b
	ld	hl, sp+11
	ld	[hl], a
	ld	hl, sp+8
	ld	a, [hl]
	or	a, e
	ld	hl, sp+12
	ld	[hl], a
	ld	hl, sp+9
	ld	a, [hl]
	or	a, d
	ld	hl, sp+13
	ld	[hl], a
	ld	hl, sp+10
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	inc	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
.l00103:
;src/rtc/rtc.c:53: }
	add	sp, 14
	ret
;src/rtc/rtc.c:54: static unsigned long GameSeconds(const unsigned char* r) {
;	---------------------------------
	SECTION FRAGMENT "Page 12",ROMX,BANK[6]
	LOAD FRAGMENT "Page 12 RAM",SRAM,BANK[12]
; Function GameSeconds
; ---------------------------------
_GameSeconds:
	add	sp, -20
	ld	c, e
	ld	b, d
;src/rtc/rtc.c:55: unsigned long d = r[3] | ((unsigned int)(r[4] & 1) << 8);
	ld	l, c
;	spillPairReg hl
;	spillPairReg hl
	ld	h, b
;	spillPairReg hl
;	spillPairReg hl
	inc	hl
	inc	hl
	inc	hl
	ld	e, [hl]
	ld	hl, $0004
	add	hl, bc
	ld	a, [hl]
	ld	d, $00
	and	a, $01
	ld	l, a
;	spillPairReg hl
;	spillPairReg hl
	ld	h, $00
;	spillPairReg hl
;	spillPairReg hl
	ld	a, $00
	ld	d, $00
	or	a, e
	ld	e, a
	ld	a, l
	or	a, d
	ld	d, a
	inc	sp
	inc	sp
	push	de
	xor	a, a
	ld	hl, sp+2
	ld	[hl], a
	inc	hl
	ld	[hl], a
;src/rtc/rtc.c:56: unsigned int h = r[2], m = r[1];
	ld	e, c
	ld	d, b
	inc	de
	inc	de
	ld	a, [de]
	inc	hl
	ld	[hl], a
	inc	hl
	ld	[hl], $00
	ld	e, c
	ld	d, b
	inc	de
	ld	a, [de]
	inc	hl
	ld	[hl], a
	inc	hl
	ld	[hl], $00
;src/rtc/rtc.c:57: return (d << 16) + (d << 14) + (d << 12) + (d << 8) + (d << 7) +
	push	af
	ld	hl, sp+2
	ld	a, [hl]
	ld	hl, sp+12
	ld	[hl], a
	ld	hl, sp+3
	ld	a, [hl]
	ld	hl, sp+13
	ld	[hl], a
	pop	af
	ld	hl, sp+8
	ld	[hl], $00
	inc	hl
	ld	[hl], $00
	push	af
	ld	hl, sp+2
	ld	a, [hl]
	ld	hl, sp+19
	ld	[hl], a
	ld	hl, sp+3
	ld	a, [hl]
	ld	hl, sp+20
	ld	[hl], a
	ld	hl, sp+4
	ld	a, [hl]
	ld	hl, sp+21
	ld	[hl], a
	pop	af
	ld	hl, sp+16
	ld	[hl], $00
	ld	a, $06
.l00105:
	ld	hl, sp+17
	sla	[hl]
	inc	hl
	rl	[hl]
	inc	hl
	rl	[hl]
.l00106:
	dec	a
	jr	NZ,.l00105
	ld	hl, sp+9
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, e
	ld	hl, sp+16
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
	dec	hl
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, sp+20
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
	push	af
	ld	hl, sp+2
	ld	a, [hl]
	ld	hl, sp+19
	ld	[hl], a
	ld	hl, sp+3
	ld	a, [hl]
	ld	hl, sp+20
	ld	[hl], a
	ld	hl, sp+4
	ld	a, [hl]
	ld	hl, sp+21
	ld	[hl], a
	pop	af
	ld	hl, sp+16
	ld	[hl], $00
	ld	a, $04
.l00107:
	ld	hl, sp+17
	sla	[hl]
	inc	hl
	rl	[hl]
	inc	hl
	rl	[hl]
.l00108:
	dec	a
	jr	NZ,.l00107
	ld	hl, sp+13
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, e
	ld	hl, sp+16
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
	ld	hl, sp+17
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, sp+20
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
	push	af
	ld	hl, sp+2
	ld	a, [hl]
	ld	hl, sp+15
	ld	[hl], a
	ld	hl, sp+3
	ld	a, [hl]
	ld	hl, sp+16
	ld	[hl], a
	ld	hl, sp+4
	ld	a, [hl]
	ld	hl, sp+17
	ld	[hl], a
	pop	af
	ld	hl, sp+12
	ld	[hl], $00
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
	push	af
	ld	hl, sp+2
	ld	a, [hl]
	ld	hl, sp+14
	ld	[hl], a
	ld	hl, sp+3
	ld	a, [hl]
	ld	hl, sp+15
	ld	[hl], a
	ld	hl, sp+4
	ld	a, [hl]
	ld	hl, sp+16
	ld	[hl], a
	ld	hl, sp+5
	ld	a, [hl]
	ld	hl, sp+17
	ld	[hl], a
	pop	af
	ld	a, $07
.l00111:
	ld	hl, sp+12
	sla	[hl]
	inc	hl
	rl	[hl]
	inc	hl
	rl	[hl]
	inc	hl
	rl	[hl]
.l00112:
	dec	a
	jr	NZ,.l00111
	inc	hl
	inc	hl
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
	ld	hl, sp+11
	ld	[hl], a
	dec	hl
	ld	[hl], e
	ld	hl, sp+21
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
	ld	hl, sp+11
	ld	[hl], a
	dec	hl
	ld	[hl], e
;src/rtc/rtc.c:58: (h << 11) + (h << 10) + (h << 9) + (h << 4) + (m << 6) - (m << 2) + r[0];
	ld	hl, sp+4
	ld	a, [hl]
	add	a, a
	add	a, a
	add	a, a
	ld	e, $00
	ld	hl, sp+12
	ld	[hl], e
	inc	hl
	ld	[hl], a
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
	ld	hl, sp+4
	ld	a, [hl]
	add	a, a
	add	a, a
	ld	e, $00
	ld	hl, sp+12
	ld	[hl], e
	inc	hl
	ld	[hl], a
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
	ld	hl, sp+12
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
	ld	hl, sp+21
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
	ld	hl, sp+11
	ld	[hl], a
	dec	hl
	ld	[hl], e
	ld	hl, sp+4
	ld	a, [hl]
	add	a, a
	ld	e, $00
	ld	hl, sp+12
	ld	[hl], e
	inc	hl
	ld	[hl], a
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
	ld	hl, sp+4
	ld	a, [hl]
	inc	hl
	ld	e, [hl]
	add	a, a
	rl	e
	add	a, a
	rl	e
	add	a, a
	rl	e
	add	a, a
	rl	e
	ld	hl, sp+8
	ld	[hl], a
	inc	hl
	ld	[hl], e
	xor	a, a
	inc	hl
	ld	[hl], a
	inc	hl
	ld	[hl], a
	ld	hl, sp+17
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
	ld	hl, sp+21
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
	ld	hl, sp+6
	ld	a, [hl]
	inc	hl
	ld	e, [hl]
	add	a, a
	rl	e
	add	a, a
	rl	e
	add	a, a
	rl	e
	add	a, a
	rl	e
	add	a, a
	rl	e
	add	a, a
	rl	e
	inc	hl
	ld	[hl], a
	inc	hl
	ld	[hl], e
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
	ld	hl, sp+8
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
	dec	hl
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
	ld	hl, sp+19
	ld	[hl], a
	dec	hl
	ld	[hl], e
	ld	hl, sp+6
	ld	a, [hl]
	inc	hl
	ld	e, [hl]
	add	a, a
	rl	e
	add	a, a
	rl	e
	inc	hl
	ld	[hl], a
	inc	hl
	ld	[hl], e
	xor	a, a
	inc	hl
	ld	[hl], a
	inc	hl
	ld	[hl], a
	ld	hl, sp+17
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
	ld	hl, sp+15
	ld	[hl], a
	dec	hl
	ld	[hl], e
	ld	hl, sp+21
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
	ld	hl, sp+15
	ld	[hl], a
	dec	hl
	ld	[hl], e
	ld	a, [bc]
	ld	hl, sp+8
	ld	[hl], a
	xor	a, a
	inc	hl
	ld	[hl], a
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
	ld	hl, sp+8
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
	dec	hl
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
	ld	hl, sp+19
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
.l00101:
;src/rtc/rtc.c:59: }
	add	sp, 20
	ret
;src/rtc/rtc.c:60: unsigned char rtc_Advance(unsigned char* r) {
;	---------------------------------
	SECTION FRAGMENT "Page 12",ROMX,BANK[6]
	LOAD FRAGMENT "Page 12 RAM",SRAM,BANK[12]
; Function rtc_Advance
; ---------------------------------
_rtc_Advance::
	add	sp, -28
	ld	hl, sp+22
	ld	[hl], e
	inc	hl
	ld	[hl], d
;src/rtc/rtc.c:64: if (rtc_Read(&date)) return 1;
	ld	hl, 12
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_rtc_Read
	ld	c, a
	ld	a, c
	or	a, a
	jp	Z, .l00102
	ld	a, $01
	jp	.l00122
.l00102:
;src/rtc/rtc.c:65: now = rtc_Seconds(&date);
	ld	hl, 12
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_rtc_Seconds
	ld	hl, sp+8
	ld	[hl], c
	inc	hl
	ld	[hl], b
	inc	hl
	ld	[hl], e
	inc	hl
	ld	[hl], d
;src/rtc/rtc.c:66: while (now >= 44236800UL) now -= 44236800UL; // 512 days
.l00103:
	ld	hl, sp+8
	ld	a, [hl]
	sub	a, $00
	inc	hl
	ld	a, [hl]
	sbc	a, $00
	inc	hl
	ld	a, [hl]
	sbc	a, $A3
	inc	hl
	ld	a, [hl]
	sbc	a, $02
	jp	C, .l00105
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
	sbc	a, $A3
	ld	e, a
	ld	a, d
	sbc	a, $02
	ld	[hl], a
	dec	hl
	ld	[hl], e
	jp	.l00103
.l00105:
;src/rtc/rtc.c:67: before = GameSeconds(r + 5);
	ld	hl, sp+23
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $0005
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
	call	_GameSeconds
	ld	hl, sp+4
	ld	[hl], c
	inc	hl
	ld	[hl], b
	inc	hl
	ld	[hl], e
	inc	hl
	ld	[hl], d
;src/rtc/rtc.c:68: if (now < before) before = now + 44236800UL - before; else before = now - before;
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
	jp	NC, .l00107
	ld	hl, sp+9
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
	ld	hl, sp+3
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
	adc	a, $A3
	ld	e, a
	ld	a, d
	adc	a, $02
	ld	hl, sp+3
	ld	[hl], a
	dec	hl
	ld	[hl], e
	pop	de
	push	de
	ld	a, e
	inc	hl
	inc	hl
	sub	a, [hl]
	ld	e, a
	ld	a, d
	inc	hl
	sbc	a, [hl]
	push	af
	ld	hl, sp+27
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
	ld	hl, sp+27
	ld	[hl], a
	dec	hl
	ld	[hl], e
	dec	hl
	dec	hl
	ld	d, h
	ld	e, l
	ld	hl, sp+7
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
	jp	.l00108
.l00107:
	ld	hl, sp+9
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
	ld	hl, sp+27
	ld	[hl], a
	dec	hl
	ld	[hl], e
	ld	hl, sp+13
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
	ld	hl, sp+27
	ld	[hl], a
	dec	hl
	ld	[hl], e
	dec	hl
	dec	hl
	ld	d, h
	ld	e, l
	ld	hl, sp+7
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
;src/rtc/rtc.c:69: seconds = GameSeconds(r);
	ld	hl, sp+22
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	call	_GameSeconds
	ld	hl, sp+24
	ld	[hl], c
	inc	hl
	ld	[hl], b
	inc	hl
	ld	[hl], e
	inc	hl
	ld	[hl], d
;src/rtc/rtc.c:70: if (!(r[4] & 0x40)) seconds += before;
	ld	hl, sp+23
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $0004
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
	ld	hl, sp+11
	ld	[hl], a
	push	hl
	bit	6, [hl]
	pop	hl
	jp	NZ,.l00188
	jp	.l00189
.l00188:
	jp	.l00110
.l00189:
	ld	hl, sp+25
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
	ld	hl, sp+27
	ld	[hl], a
	dec	hl
	ld	[hl], e
	ld	hl, sp+29
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
	ld	hl, sp+27
	ld	[hl], a
	dec	hl
	ld	[hl], e
.l00110:
;src/rtc/rtc.c:71: if (seconds >= 44236800UL) { seconds -= 44236800UL; r[4] |= 0x80; }
	ld	hl, sp+24
	ld	a, [hl]
	sub	a, $00
	inc	hl
	ld	a, [hl]
	sbc	a, $00
	inc	hl
	ld	a, [hl]
	sbc	a, $A3
	inc	hl
	ld	a, [hl]
	sbc	a, $02
	jp	C, .l00131
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
	ld	[hl], a
	dec	hl
	ld	[hl], e
	ld	hl, sp+29
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	pop	af
	ld	a, e
	sbc	a, $A3
	ld	e, a
	ld	a, d
	sbc	a, $02
	ld	[hl], a
	dec	hl
	ld	[hl], e
	ld	hl, sp+11
	ld	c, [hl]
	set	7, c
	ld	hl, sp+20
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	ld	[hl], c
;src/rtc/rtc.c:73: while (seconds >= 86400UL) { seconds -= 86400UL; ++days; }
.l00131:
	ld	bc, $0000
.l00113:
	ld	hl, sp+24
	ld	a, [hl]
	sub	a, $80
	inc	hl
	ld	a, [hl]
	sbc	a, $51
	inc	hl
	ld	a, [hl]
	sbc	a, $01
	inc	hl
	ld	a, [hl]
	sbc	a, $00
	jp	C, .l00115
	dec	hl
	dec	hl
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, e
	sub	a, $80
	ld	e, a
	ld	a, d
	sbc	a, $51
	push	af
	ld	[hl], a
	dec	hl
	ld	[hl], e
	ld	hl, sp+29
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
	ld	[hl], a
	dec	hl
	ld	[hl], e
	inc	bc
	jp	.l00113
.l00115:
;src/rtc/rtc.c:74: r[3] = days; r[4] = (r[4] & 0xC0) | (days >> 8);
	ld	hl, sp+22
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	inc	de
	inc	de
	inc	de
	ld	a, c
	ld	[de], a
	dec	hl
	dec	hl
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	and	a, $C0
	ld	c, b
	or	a, c
	ld	c, a
	dec	hl
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	ld	[hl], c
;src/rtc/rtc.c:75: r[2] = 0; while (seconds >= 3600) { seconds -= 3600; ++r[2]; }
	ld	hl, sp+22
	ld	c, [hl]
	inc	hl
	ld	b, [hl]
	inc	bc
	inc	bc
	xor	a, a
	ld	[bc], a
.l00116:
	ld	hl, sp+24
	ld	a, [hl]
	sub	a, $10
	inc	hl
	ld	a, [hl]
	sbc	a, $0E
	inc	hl
	ld	a, [hl]
	sbc	a, $00
	inc	hl
	ld	a, [hl]
	sbc	a, $00
	jp	C, .l00118
	dec	hl
	dec	hl
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, e
	sub	a, $10
	ld	e, a
	ld	a, d
	sbc	a, $0E
	push	af
	ld	[hl], a
	dec	hl
	ld	[hl], e
	ld	hl, sp+29
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
	ld	a, [bc]
	inc	a
	ld	[bc], a
	jp	.l00116
.l00118:
;src/rtc/rtc.c:76: r[1] = 0; while (seconds >= 60) { seconds -= 60; ++r[1]; } r[0] = seconds;
	ld	hl, sp+23
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $0001
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
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	ld	[hl], $00
.l00119:
	ld	hl, sp+24
	ld	a, [hl]
	sub	a, $3C
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
	dec	hl
	dec	hl
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, e
	sub	a, $3C
	ld	e, a
	ld	a, d
	sbc	a, $00
	push	af
	ld	[hl], a
	dec	hl
	ld	[hl], e
	ld	hl, sp+29
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
	ld	hl, sp+21
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	a, [de]
	ld	c, a
	inc	c
	dec	hl
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	ld	[hl], c
	jp	.l00119
.l00121:
	ld	hl, sp+24
	ld	c, [hl]
	dec	hl
	dec	hl
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	ld	[hl], c
;src/rtc/rtc.c:77: days = Days(&date); r[8] = days; r[9] = (days >> 8) & 1;
	ld	hl, 12
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_Days
	ld	hl, sp+23
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $0008
	add	hl, de
	ld	e, l
	ld	d, h
	ld	a, c
	ld	[de], a
	ld	hl, sp+23
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $0009
	add	hl, de
	ld	e, l
	ld	d, h
	ld	a, b
	and	a, $01
	ld	[de], a
;src/rtc/rtc.c:78: r[5] = date.second; r[6] = date.minute; r[7] = date.hour;
	ld	hl, sp+17
	ld	c, [hl]
	inc	hl
	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	ld	[hl], c
	ld	hl, sp+23
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $0006
	add	hl, de
	ld	c, l
	ld	b, h
	ld	hl, sp+16
	ld	a, [hl]
	ld	[bc], a
	ld	hl, sp+23
	dec	hl
	ld	e, [hl]
	inc	hl
	ld	d, [hl]
	ld	hl, $0007
	add	hl, de
	ld	c, l
	ld	b, h
	ld	hl, sp+15
	ld	a, [hl]
	ld	[bc], a
;src/rtc/rtc.c:79: return 0;
	xor	a, a
.l00122:
;src/rtc/rtc.c:80: }
	add	sp, 28
	ret
	SECTION FRAGMENT "Page 12",ROMX,BANK[6]
	LOAD FRAGMENT "Page 12 RAM",SRAM,BANK[12]
	SECTION FRAGMENT "_INITIALIZER",ROM0
	SECTION FRAGMENT "_CABS (ABS)",ROM0

;far call thunks generated by bank_split.py
	SECTION FRAGMENT "src/rtc/rtc.c ROM0",ROM0