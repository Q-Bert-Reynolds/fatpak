
SECTION "Interrupt HRAM", HRAM
busy_frames:: DB ;frames since the main loop waited for one, 0 = it's waiting
rLCDInterrupt:: DW;location of LCD interrupt subroutine
  
SECTION "VBlank", ROM0[$0040]
  jp InGameEntry;our boot points it at VBLInterrupt, GameLaunch back here (src/editor/ingame.asm)
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
;   UpdateBusy                  shows a spinner if the main loop hasn't waited for a frame in BUSY_DELAY frames

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
  call UpdateBusy

  ld a, 1
  ldh [vbl_done], a

  POP_ALL
  reti

UpdateBusy:
  ldh a, [busy_frames]
  and a
  ret z
  inc a
  jr nz, .count
  ld a, BUSY_DELAY;keep turning
.count
  ldh [busy_frames], a
  cp a, BUSY_DELAY
  ret c
  rrca
  rrca
  rrca
  and a, 3;quarter turn every 8 frames
  add a, LOW(BusyFlips)
  ld l, a
  adc a, HIGH(BusyFlips)
  sub a, l
  ld h, a
  ld d, [hl]
  ld c, BUSY_SPRITE
  call gbdk_SetSpriteProp
  ld c, BUSY_SPRITE
  ld d, BUSY_X
  ld e, BUSY_Y
  jp gbdk_MoveSprite

BusyFlips:;clockwise
  DB BUSY_PALETTE, BUSY_PALETTE | OAMF_XFLIP, BUSY_PALETTE | OAMF_XFLIP | OAMF_YFLIP, BUSY_PALETTE | OAMF_YFLIP

;a ring in color 2 with its top left quarter in color 3, shows on the bars and on text
BusyTile::
  DB $30, $3C, $40, $42, $80, $81, $80, $81, $00, $81, $00, $81, $00, $42, $00, $3C
