; Keep raster updates alive while P1 belongs to the SNES transport. VBlank
; must wait: its LatchPad routine also writes P1. Return the previous IE in A.
SGBInputBegin::
  di
  ldh a, [rIE]
  push af
  and IEF_STAT | IEF_SERIAL;(a PS/2 byte: its handler doesn't touch P1)
  ldh [rIE], a
  ei
  pop af
  ret
SGBInputEnd::
  di
  ldh [rIE], a
  reti
