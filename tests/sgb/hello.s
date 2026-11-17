; Phase 0a: entered through the actual SGB BIOS JUMP command.
; Own the PPU and show CGRAM color 0 over the entire SNES screen.
.setcpu "65816"
.segment "CODE"
.export Entry, Nmi, Idle
.a8
.i8
Entry:
    sei
    clc
    xce
    rep #$30
.a16
.i16
    lda #$1fff
    tcs
    lda #0
    tcd
    sep #$20
.a8
    sta f:$004200             ; no BIOS NMI, H/V IRQ or auto joypad polling
    sta f:$00420c             ; no BIOS HDMA
    lda #$80
    sta f:$002100             ; forced blank while changing PPU state
    lda #0
    sta f:$00212c             ; no backgrounds or sprites on either screen
    sta f:$00212d
    sta f:$00212e
    sta f:$00212f
    sta f:$002130             ; no window clipping or color math
    sta f:$002131
    sta f:$002133             ; non-interlaced, 224 visible lines
    sta f:$002121             ; CGRAM address 0
    lda #$e0
    sta f:$002122
    lda #$03
    sta f:$002122             ; BGR555 $03E0: green backdrop
    lda #$81
    sta f:$006003             ; GB running, normal SGB1 clock, one player
    lda #$a5
    sta f:$006004             ; recognizable reply to the GB
    lda #$0f
    sta f:$002100             ; full brightness
Idle:
    bra Idle
Nmi:
    rti                       ; valid vector even though NMIs are disabled
