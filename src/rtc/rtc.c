#include "rtc.h"

static unsigned char Binary(unsigned char bcd) { return (bcd & 15) > 9 || bcd > 0x99 ? 255 : (bcd >> 4) * 10 + (bcd & 15); }
static unsigned char BCD(unsigned char value) { unsigned char tens = 0; while (value >= 10) { value -= 10; tens += 16; } return tens | value; }
static unsigned char MonthDays(unsigned char year, unsigned char month) {
  static const unsigned char days[] = {31,28,31,30,31,30,31,31,30,31,30,31};
  return days[month - 1] + (month == 2 && !(year & 3));
}
static unsigned char Valid(const ClockDate* date) {
  return date->year < 100 && date->month && date->month <= 12 && date->day &&
    date->day <= MonthDays(date->year, date->month) && date->hour < 24 && date->minute < 60 && date->second < 60;
}
unsigned char rtc_Read(ClockDate* date) {
  unsigned char raw[16];
  if (RTCRead(raw) || (raw[15] & 0x80) || (raw[5] & 0x80)) return 1; // oscillator-stop flag
  date->year = Binary(raw[6]); date->month = Binary(raw[5] & 0x1F); date->day = Binary(raw[4] & 0x3F);
  date->hour = Binary(raw[2] & ((raw[2] & 0x40) ? 0x1F : 0x3F));
  if (raw[2] & 0x40) { if (!date->hour || date->hour > 12) return 1; if (date->hour == 12) date->hour = 0; if (raw[2] & 0x20) date->hour += 12; }
  date->minute = Binary(raw[1] & 0x7F); date->second = Binary(raw[0] & 0x7F);
  return !Valid(date);
}
static unsigned int Days(const ClockDate* date) {
  unsigned int days = 0; unsigned char y, m;
  for (y = 0; y < date->year; ++y) days += 365 + !(y & 3);
  for (m = 1; m < date->month; ++m) days += MonthDays(date->year, m);
  return days + date->day - 1;
}
unsigned char rtc_Write(const ClockDate* date) {
  unsigned char raw[16], i;
  unsigned int weekday;
  if (!Valid(date) || RTCRead(raw)) return 1; // do not invent a device on carts without RTC
  raw[0] = BCD(date->second); raw[1] = BCD(date->minute); raw[2] = BCD(date->hour);
  weekday = Days(date) + 6; while (weekday >= 7) weekday -= 7;
  raw[3] = weekday + 1; // 2000-01-01 was Saturday
  raw[4] = BCD(date->day); raw[5] = BCD(date->month); raw[6] = BCD(date->year);
  raw[15] &= 0x7F; // clear OSF, preserve alarm/status bits
  // Alarms and control bytes are preserved from the device.
  i = RTCWrite(raw);
  return i;
}
// The 32-bit arithmetic is assembly: SDCC's C for it was 1.3 KB (2026-11-22).
// tests/test_footer_clock.cpp checks it against that C. Helpers, all on this page:
//   RtcMul24, RtcMul60: DEHL = DEHL * 24 (or 60) + A; RtcSeconds: DEHL = ((HL * 24 + B) * 60 + C) * 60 + A
//   RtcGameSeconds: DEHL = a stock .rtc register set's time (DE: seconds, minutes, hours, days, days' bit 8)
//   RtcSub, RtcAdd: [HL] (32 bits) -= or += DEBC; RtcSubCount: [HL] mod DEBC, counting in [HL + 4]
static void RtcMath(void) __naked {
  __asm
RtcMul60:
    push af
    add hl, hl
    rl e
    rl d
    add hl, hl
    rl e
    rl d                    ;// x * 4
    push de
    push hl
    ld b, 4
.shift:
    add hl, hl
    rl e
    rl d
    dec b
    jr nz, .shift           ;// x * 64
    pop bc
    ld a, l
    sub a, c
    ld l, a
    ld a, h
    sbc a, b
    ld h, a
    pop bc
    ld a, e
    sbc a, c
    ld e, a
    ld a, d
    sbc a, b
    ld d, a                 ;// x * 60
    pop af
RtcAddA:                    ;// DEHL += A
    add a, l
    ld l, a
    ret nc
    inc h
    ret nz
    inc de
    ret
RtcMul24:
    push af
    ld b, 3
.shift:
    add hl, hl
    rl e
    rl d
    dec b
    jr nz, .shift           ;// x * 8
    push de
    push hl
    add hl, hl
    rl e
    rl d                    ;// x * 16
    pop bc
    add hl, bc
    pop bc
    ld a, e
    adc a, c
    ld e, a
    ld a, d
    adc a, b
    ld d, a                 ;// x * 24
    pop af
    jr RtcAddA
RtcSeconds:
    push af
    push bc
    ld de, 0
    ld a, b
    call RtcMul24
    pop bc
    push bc
    ld a, c
    call RtcMul60
    pop bc
    pop af
    jr RtcMul60
RtcGameSeconds:
    ld h, d
    ld l, e
    ld a, [hl+]             ;// seconds
    push af
    ld c, [hl]              ;// minutes
    inc hl
    ld b, [hl]              ;// hours
    inc hl
    ld a, [hl+]             ;// days
    ld h, [hl]
    ld l, a
    ld a, h
    and a, 1
    ld h, a
    pop af
    jr RtcSeconds
RtcSub:
    ld a, [hl]
    sub a, c
    ld [hl+], a
    ld a, [hl]
    sbc a, b
    ld [hl+], a
    ld a, [hl]
    sbc a, e
    ld [hl+], a
    ld a, [hl]
    sbc a, d
    ld [hl], a
    ret
RtcAdd:
    ld a, [hl]
    add a, c
    ld [hl+], a
    ld a, [hl]
    adc a, b
    ld [hl+], a
    ld a, [hl]
    adc a, e
    ld [hl+], a
    ld a, [hl]
    adc a, d
    ld [hl], a
    ret
RtcSubCount:
    push hl
    call RtcSub
    pop hl
    jr c, .back             ;// below DEBC: add it back
    push hl
    inc hl
    inc hl
    inc hl
    inc hl
    inc [hl]
    jr nz, .counted
    inc hl
    inc [hl]
.counted:
    pop hl
    jr RtcSubCount
.back:
    jr RtcAdd
  __endasm;
}
// seconds since 2000-01-01
unsigned long rtc_Seconds(const ClockDate* date) __naked {
  date;
  __asm
    push de
    call _Days              ;// BC = days
    pop hl
    inc hl
    inc hl
    inc hl                  ;// the hour
    ld a, [hl+]
    ld d, a
    ld e, [hl]              ;// the minute
    inc hl
    ld a, [hl]              ;// the second
    ld h, b
    ld l, c
    ld b, d
    ld c, e
    call RtcSeconds
    ld b, h
    ld c, l
    ret
  __endasm;
}
// FatFs's timestamp: (year - 1980) << 25 | month << 21 | day << 16 | hour << 11 | minute << 5 | second / 2;
// 2026-01-01 without a clock
unsigned long rtc_FatTime(void) __naked {
  __asm
    add sp, -6              ;// a ClockDate
    ld hl, sp + 0
    ld d, h
    ld e, l
    call _rtc_Read
    pop bc                  ;// C year, B month
    pop de                  ;// E day, D hour
    pop hl                  ;// L minute, H second
    or a, a
    jr z, .read
    ld de, $5C21            ;// (46 << 9) | (1 << 5) | 1
    ld bc, 0
    ret
.read:
    push hl
    push de
    ld a, c
    add a, 20
    ld l, a
    ld h, 0
    add hl, hl
    add hl, hl
    add hl, hl
    add hl, hl
    ld a, l
    or a, b
    ld l, a                 ;// (year + 20) << 4 | month
    add hl, hl
    add hl, hl
    add hl, hl
    add hl, hl
    add hl, hl
    pop de
    ld a, l
    or a, e
    ld l, a                 ;// ... << 5 | day
    pop bc                  ;// C minute, B second
    push hl
    ld l, d
    ld h, 0
    add hl, hl
    add hl, hl
    add hl, hl
    add hl, hl
    add hl, hl
    add hl, hl
    ld a, l
    or a, c
    ld l, a                 ;// hour << 6 | minute
    add hl, hl
    add hl, hl
    add hl, hl
    add hl, hl
    add hl, hl
    ld a, b
    srl a
    or a, l
    ld c, a
    ld b, h                 ;// ... << 5 | second / 2
    pop de
    ret
  __endasm;
}
// A stock .rtc's registers (r: current seconds, minutes, hours, days, flags; then the clock's time
// when they were saved, as seconds, minutes, hours, days, days' bit 8) brought up to now: the game's
// clock moves by what the calendar moved since (wrapping at 512 days, unless halted: flags bit 6),
// carrying past 512 days (bit 7). Returns 1 without a clock.
// Frame: sp+0 the date, sp+6 the time since the reference (+10 a count), sp+12 the game's time
// (+16 its count), sp+18 r. RtcFrameR and RtcCountS are called from it: their offsets are 2 more.
unsigned char rtc_Advance(unsigned char* r) __naked {
  r;
  __asm
    add sp, -20
    ld hl, sp + 18
    ld [hl], e
    inc hl
    ld [hl], d
    ld hl, sp + 0
    ld d, h
    ld e, l
    call _rtc_Read
    or a, a
    jr z, .read
    add sp, 20
    ld a, 1
    ret
.read:
    ld hl, sp + 0
    ld d, h
    ld e, l
    call _rtc_Seconds       ;// DEBC = now
    ld hl, sp + 6
    ld [hl], c
    inc hl
    ld [hl], b
    inc hl
    ld [hl], e
    inc hl
    ld [hl], d
    inc hl
    xor a, a
    ld [hl+], a
    ld [hl], a
    ld hl, sp + 6
    ld de, $02A3            ;// 512 days: 44,236,800 seconds
    ld bc, 0
    call RtcSubCount        ;// now, wrapped
    call RtcFrameR
    ld de, 5
    add hl, de
    ld d, h
    ld e, l
    call RtcGameSeconds     ;// the reference
    ld b, h
    ld c, l
    ld hl, sp + 6
    call RtcSub             ;// since then
    jr nc, .ahead
    ld hl, sp + 6
    ld de, $02A3
    ld bc, 0
    call RtcAdd
.ahead:
    call RtcFrameR
    ld d, h
    ld e, l
    call RtcGameSeconds     ;// the game's time
    ld b, h
    ld c, l
    ld hl, sp + 12
    ld [hl], c
    inc hl
    ld [hl], b
    inc hl
    ld [hl], e
    inc hl
    ld [hl], d
    call RtcFrameR
    inc hl
    inc hl
    inc hl
    inc hl
    bit 6, [hl]
    jr nz, .halted
    ld hl, sp + 6
    ld a, [hl+]
    ld c, a
    ld a, [hl+]
    ld b, a
    ld a, [hl+]
    ld e, a
    ld d, [hl]
    ld hl, sp + 12
    call RtcAdd             ;// plus the time since the reference
.halted:
    ld de, $02A3
    ld bc, 0
    call RtcCountS
    or a, a
    jr z, .days
    call RtcFrameR
    ld de, 4
    add hl, de
    set 7, [hl]             ;// past 512 days
.days:
    ld de, $0001            ;// 86,400
    ld bc, $5180
    call RtcCountS
    ld c, a
    ld hl, sp + 17
    ld b, [hl]              ;// BC = days
    call RtcFrameR
    inc hl
    inc hl
    inc hl
    ld [hl], c
    inc hl
    ld a, [hl]
    and a, $C0
    or a, b
    ld [hl], a
    ld de, 0
    ld bc, 3600
    call RtcCountS
    ld b, a
    call RtcFrameR
    inc hl
    inc hl
    ld [hl], b              ;// hours
    ld de, 0
    ld bc, 60
    call RtcCountS
    ld b, a
    call RtcFrameR
    inc hl
    ld [hl], b              ;// minutes
    ld hl, sp + 12
    ld b, [hl]
    call RtcFrameR
    ld [hl], b              ;// seconds
    ld hl, sp + 0
    ld d, h
    ld e, l
    call _Days              ;// BC: the reference, now
    call RtcFrameR
    ld de, 5
    add hl, de
    ld d, h
    ld e, l
    ld hl, sp + 5
    ld a, [hl-]
    ld [de], a              ;// second
    inc de
    ld a, [hl-]
    ld [de], a              ;// minute
    inc de
    ld a, [hl]
    ld [de], a              ;// hour
    inc de
    ld a, c
    ld [de], a
    inc de
    ld a, b
    and a, 1
    ld [de], a              ;// days
    add sp, 20
    xor a, a
    ret
RtcFrameR:                  ;// HL = r
    ld hl, sp + 20
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    ret
RtcCountS:                  ;// the game's time mod DEBC; A = the count's low byte (its high at frame + 17)
    ld hl, sp + 18
    xor a, a
    ld [hl+], a
    ld [hl], a
    ld hl, sp + 14
    call RtcSubCount
    ld hl, sp + 18
    ld a, [hl]
    ret
  __endasm;
}
