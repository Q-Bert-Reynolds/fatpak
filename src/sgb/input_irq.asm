; Keep raster updates alive while P1 belongs to the SNES transport. VBlank
; must wait: its LatchPad routine also writes P1. Return the previous IE in A.
SGBInputBegin::
  di
  ldh a, [rIE]
  push af
  and IEF_STAT
  ldh [rIE], a
  ei
  pop af
  ret
SGBInputEnd::
  di
  ldh [rIE], a
  reti
