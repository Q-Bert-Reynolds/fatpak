
SECTION "Interrupt HRAM", HRAM
vbl_timer:: DB ;counts to 60
rLCDInterrupt:: DW;location of LCD interrupt subroutine
  
SECTION "VBlank", ROM0[$0040]
  jp VBLInterrupt
SECTION "LCDC", ROM0[$0048]
  jp LCDInterrupt
SECTION "TimerOverflow", ROM0[$0050]
  reti
SECTION "Serial", ROM0[$0058]
  jp SerialInterrupt
SECTION "p1thru4", ROM0[$0060]
  reti

SECTION "Interrupt Code", ROM0
;serial
;   SerialInterrupt
;
;lcd
;   LCDInterrupt
;   SetLCDInterrupt             bc = interrupt address
;   DisableLCDInterrupt
;
;vblank
;   VBLInterrupt
;   UpdateTime                  updates current game time

SerialInterrupt::;TODO: check serial type (keyboard, link, printer)
  PUSH_ALL
  call PS2KeyboardInterrupt
  POP_ALL
  reti

LCDInterrupt::
  PUSH_ALL
  ld c, LOW(rLCDInterrupt)
  ldh a, [c]
  ld b, a
  inc c
  ldh a, [c]
  ld h, b
  ld l, a
  ld bc, EndLCDInterrupt
  push bc ;put return address on stack before jumping
  jp hl
EndLCDInterrupt::
  POP_ALL
  reti

SetLCDInterrupt::;bc = interrupt address
  di

  ld h, ~IEF_STAT
  ldh a, [rIE]
  and a, h
  ldh [rIE], a

  xor a
  ldh [rSTAT], a

  ld a, b
  ldh [rLCDInterrupt], a
  ld a, c
  ldh [rLCDInterrupt+1], a

  ld h, IEF_STAT
  ldh a, [rIE]
  or a, h
  ldh [rIE], a

  ld a, STATF_LYC
  ldh [rSTAT], a
  
  reti

DisableLCDInterrupt::
  di
    
  ld b, ~IEF_STAT
  ldh a, [rIE]
  and a, b
  ldh [rIE], a

  xor a
  ldh [rSTAT], a

  ld bc, EndLCDInterrupt
  ld a, b
  ldh [rLCDInterrupt], a
  ld a, c
  ldh [rLCDInterrupt+1], a

  reti

VBLInterrupt::
  PUSH_ALL

  call gbdk_DMATransfer
  call LatchPad
  call UpdateTime
  call UpdateAudio

  ld a, 1
  ldh [vbl_done], a

  POP_ALL
  reti

UpdateTime:
  ldh a, [vbl_timer]
  inc a
  ldh [vbl_timer], a
  cp a, 60
  ret c
  xor a
  ldh [vbl_timer], a

.checkGameState
  ld a, [game_state]
  and a, GAME_STATE_CLOCK_STARTED
  ret z

.incrementSeconds
  ld a, [seconds]
  inc a
  ld [seconds], a
  cp a, 60
  ret c

.incrementMinutes
  xor a
  ld [seconds], a
  ld a, [minutes]
  inc a
  ld [minutes], a
  cp a, 60
  ret c

.incrementHours
  xor a
  ld [minutes], a
  ld hl, hours+1 ;low byte
  inc [hl] ;increment low byte inplace
  ret nz ;done if no overflow
  dec hl ;high byte
  inc [hl]
  ret
