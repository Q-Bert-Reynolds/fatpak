; EverDrive byte-level I2C calendar interface, matching stock GBCOS.
DEF RTC_CONTROL EQU $BD0C
DEF RTC_DATA EQU $BD0D
DEF MAPPER_RTC_CURRENT EQU $BD10
DEF MAPPER_RTC_INDEX EQU $BD13
DEF CART_FEATURES EQU $BD0F
DEF CART_FEATURE_X3 EQU 1
DEF CART_FEATURE_RTC EQU 2
DEF CART_FEATURE_SNAPSHOT EQU 4

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
  or a ; callers test NZ for timeout, not just the returned byte
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
  ; During a read the master supplies ACK; only poll completion, not slave ACK.
  ld a, $FF
  ld [RTC_DATA], a
  call RTCWait
  jr nz, RTCError
  ld a, [RTC_DATA]
  ld [hli], a
  dec b
  jr nz, .read
  ld a, $11
  ld [RTC_CONTROL], a
  ld a, $FF
  ld [RTC_DATA], a
  call RTCWait
  jp nz, RTCError
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

; Stock OS page 6 reads the factory EEPROM at $3F00. Its model ID is
; the high byte of the big-endian word at offset $18: $0D=X3, $0E=X5, $0F=X7.
; Initialize the FPGA's feature mask exactly as stock startup does. Reading
; the calendar is separate from enabling its MBC3 interface for games.
CartConfigureFeatures::
  call RTCStart
  jp nz, RTCError
  ld a, $A0
  call RTCByte
  jp nz, RTCError
  ld a, $3F
  call RTCByte
  jp nz, RTCError
  ld a, $18
  call RTCByte
  jp nz, RTCError
  call RTCStart
  jp nz, RTCError
  ld a, $A1
  call RTCByte
  jp nz, RTCError
  ld a, $10
  ld [RTC_CONTROL], a
  ld a, $FF
  ld [RTC_DATA], a
  call RTCWait
  jp nz, RTCError
  ld a, [RTC_DATA]
  push af
  ld a, $11
  ld [RTC_CONTROL], a
  ld a, $FF
  ld [RTC_DATA], a
  call RTCWait
  jr nz, .readError
  call RTCReset
  jr nz, .readError
  pop af
  cp a, $0D
  jr z, .x3
  cp a, $0E
  jr z, .x5
  cp a, $0F
  ret nz ; an unknown model keeps the bootloader's configuration
  ld a, CART_FEATURE_RTC | CART_FEATURE_SNAPSHOT
  jr .configure
.x3
  ld a, CART_FEATURE_X3
  jr .configure
.x5
  xor a
.configure
  ld [CART_FEATURES], a
  and a, CART_FEATURE_RTC
  ret z
  ; Match CheckAndInitializeRTC before calendar access or game preparation.
  ld a, 6
  ld [MAPPER_RTC_INDEX], a
  xor a
  ld [MAPPER_RTC_CURRENT], a
  ret
.readError
  pop af
  jp RTCError
