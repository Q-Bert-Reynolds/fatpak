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
unsigned long rtc_Seconds(const ClockDate* date) {
  unsigned long d = Days(date);
  unsigned int h = date->hour, m = date->minute;
  // No SDCC library multiply/divide: these helpers also run outside FatFs's page.
  return (d << 16) + (d << 14) + (d << 12) + (d << 8) + (d << 7) +
    (h << 11) + (h << 10) + (h << 9) + (h << 4) + (m << 6) - (m << 2) + date->second;
}
unsigned long rtc_FatTime(void) {
  ClockDate date;
  if (rtc_Read(&date)) return (46UL << 25) | (1UL << 21) | (1UL << 16); // 2026-01-01
  return ((unsigned long)(date.year + 20) << 25) | ((unsigned long)date.month << 21) |
    ((unsigned long)date.day << 16) | ((unsigned long)date.hour << 11) | ((unsigned int)date.minute << 5) | (date.second >> 1);
}
static unsigned long GameSeconds(const unsigned char* r) {
  unsigned long d = r[3] | ((unsigned int)(r[4] & 1) << 8);
  unsigned int h = r[2], m = r[1];
  return (d << 16) + (d << 14) + (d << 12) + (d << 8) + (d << 7) +
    (h << 11) + (h << 10) + (h << 9) + (h << 4) + (m << 6) - (m << 2) + r[0];
}
unsigned char rtc_Advance(unsigned char* r) {
  ClockDate date;
  unsigned long now, before, seconds;
  unsigned int days;
  if (rtc_Read(&date)) return 1;
  now = rtc_Seconds(&date);
  while (now >= 44236800UL) now -= 44236800UL; // 512 days
  before = GameSeconds(r + 5);
  if (now < before) before = now + 44236800UL - before; else before = now - before;
  seconds = GameSeconds(r);
  if (!(r[4] & 0x40)) seconds += before;
  if (seconds >= 44236800UL) { seconds -= 44236800UL; r[4] |= 0x80; }
  days = 0;
  while (seconds >= 86400UL) { seconds -= 86400UL; ++days; }
  r[3] = days; r[4] = (r[4] & 0xC0) | (days >> 8);
  r[2] = 0; while (seconds >= 3600) { seconds -= 3600; ++r[2]; }
  r[1] = 0; while (seconds >= 60) { seconds -= 60; ++r[1]; } r[0] = seconds;
  days = Days(&date); r[8] = days; r[9] = (days >> 8) & 1;
  r[5] = date.second; r[6] = date.minute; r[7] = date.hour;
  return 0;
}
