#ifndef GIRLBOSS_RTC_H
#define GIRLBOSS_RTC_H
// Calendar values are binary, year is 2000-2099. The chip uses BCD internally.
typedef struct { unsigned char year, month, day, hour, minute, second; } ClockDate;
unsigned char ClockRead(ClockDate* date); // 0 = valid clock, 1 = absent/invalid
unsigned char ClockWrite(const ClockDate* date);
unsigned long ClockFatTime(void);
unsigned long ClockSeconds(const ClockDate* date); // seconds since 2000-01-01
unsigned char ClockAdvance(unsigned char* registers); // stock .rtc: current[5], reference[5]
unsigned char RTCRead(unsigned char* registers);
unsigned char RTCWrite(const unsigned char* registers);
#endif
