; Phase 0c's conservative fallback: return to the BIOS before any cart launch.
; Preserve its stack/registers/PPU and use a bank-0 RTS trampoline. No GB reset.
.setcpu "65816"
.segment "CODE"
.export Entry, Nmi
.a8
.i8
Entry:
 php
 rep #$30
.a16
.i16
 pha
 phx
 phy
 phd
 phb
 sep #$20
.a8
 sei
 lda #$60
 sta f:$001800
 lda #$a5
 sta f:$006004
 ldx #120
@frame:
 lda f:$004212
 bmi @frame
@vblank:
 lda f:$004212
 bpl @vblank
 dex
 bne @frame
 lda #$5a
 sta f:$7f1000
 lda #0
 sta f:$006004
 rep #$30
.a16
 plb
 pld
 ply
 plx
 pla
 plp
 jml $001800
.a8
Nmi:
 rti
