; EverDrive byte-level I2C calendar interface, matching stock GBCOS.
DEF RTC_CONTROL EQU $BD0C
DEF RTC_DATA EQU $BD0D

SECTION "Clock API", ROM0
_ClockRead:: BANKED_C _rtc_Read
_ClockWrite:: BANKED_C _rtc_Write
_ClockFatTime:: BANKED_C _rtc_FatTime
_ClockSeconds:: BANKED_C _rtc_Seconds
_ClockAdvance:: BANKED_C _rtc_Advance

; 0 success, 1 failure. Bounded polling also works on carts without a clock.
RTCWait:
  push bc
  ld b, 0
.wait
  ld a, [RTC_CONTROL]
  bit 7, a
  jr z, .ready
  dec b
  jr nz, .wait
  ld a, 1
  pop bc
  ret
.ready
  xor a
  pop bc
  ret
RTCByte:
  ld [RTC_DATA], a
  call RTCWait
  ret nz
  ld a, [RTC_CONTROL]
  and a, 1
  ret
RTCStart:
  ld a, $20
  ld [RTC_CONTROL], a
  ld [RTC_DATA], a
  call RTCWait
  ret nz
  ld a, $11
  ld [RTC_CONTROL], a
  xor a
  ret
RTCReset:
  ld a, $30
  ld [RTC_CONTROL], a
  ld [RTC_DATA], a
  jp RTCWait
RTCError:
  call RTCReset
  ld a, 1
  ret

; DE = sixteen chip registers. The chip address is $D0/$D1.
_RTCRead::
  ld h, d
  ld l, e
  call RTCStart
  jr nz, RTCError
  ld a, $D0
  call RTCByte
  jr nz, RTCError
  xor a
  call RTCByte
  jr nz, RTCError
  call RTCStart
  jr nz, RTCError
  ld a, $D1
  call RTCByte
  jr nz, RTCError
  ld a, $10
  ld [RTC_CONTROL], a
  ld b, 16
.read
  ld a, $FF
  call RTCByte
  jr nz, RTCError
  ld a, [RTC_DATA]
  ld [hli], a
  dec b
  jr nz, .read
  ld a, $11
  ld [RTC_CONTROL], a
  ld a, $FF
  call RTCByte
  jp RTCReset

_RTCWrite::
  ld h, d
  ld l, e
  call RTCStart
  jr nz, RTCError
  ld a, $D0
  call RTCByte
  jr nz, RTCError
  xor a
  call RTCByte
  jr nz, RTCError
  ld b, 16
.write
  ld a, [hli]
  call RTCByte
  jp nz, RTCError
  dec b
  jr nz, .write
  jp RTCReset

INCLUDE "src/rtc/_rtc.asm"
