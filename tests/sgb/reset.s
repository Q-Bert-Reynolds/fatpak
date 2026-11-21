; Phase 0c follow-up: leave a JUMP by soft-resetting the BIOS (its reset code at $00:8104) instead of
; returning to it. The BIOS reinitialises the PPU, WRAM it owns, its SPC driver and the GB (held in reset
; through $6003, then released), so nothing the program clobbered matters. reset.lua checks the GB boots
; again and reaches a second JUMP.
.setcpu "65816"
.segment "CODE"
.export Entry, Nmi
.a8
.i8
Entry:
 sei
 sep #$30
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
 lda #0
 sta f:$006004
 ; leave the PPU, DMA and ICD2 as the kernel might: 512x448 (mode 5, interlace), every layer, windows and
 ; colour math, NMI and auto-read on, HDMA running, four players
 lda #$05
 sta f:$002105
 lda #$01
 sta f:$002133
 lda #$1f
 sta f:$00212c
 sta f:$00212d
 lda #$ff
 sta f:$002123
 sta f:$002124
 sta f:$002125
 lda #$02
 sta f:$002130
 lda #$3f
 sta f:$002131
 lda #$0f
 sta f:$002100
 lda #$b1
 sta f:$006003
 lda #$81
 sta f:$004200
 lda #$01
 sta f:$00420c
 ; the SPC still runs the BIOS's sound driver; $FF on port 0 sends it back to the IPL ROM (as SOU_TRN
 ; does at $00:C573), whose $BBAA the reset code's driver upload waits for
 lda #$ff
 sta f:$002140
@ipl:
 lda f:$002140
 cmp #$aa
 bne @ipl
 lda f:$002141
 cmp #$bb
 bne @ipl
 jml $008104
Nmi:
 rti
