; BG3 is 2bpp in mode 1. A high-priority BG2 mask supplies opaque paper
; beneath it, so all four UI colors survive while unopened areas stay transparent.
.setcpu "65816"
.export _OverlayInit,_PresentOverlay
.import _raster,_ui_left,_ui_right,_Capture,_WaitBlank,_palette,MapRow
.segment "CODE"
.a8
.i8
_OverlayInit:
 lda #$80
 sta f:$002100
 lda #$60 ; BG2 tile base $C000; BG1 remains $0000
 sta f:$00210B
 lda #$78 ; BG2 map $F000
 sta f:$002108
 lda #0
 sta f:$00210F
 sta f:$00210F
 sta f:$002111
 sta f:$002111
 lda #$FF
 sta f:$002110
 sta f:$002110
 sta f:$002112
 sta f:$002112
 rep #$30
.a16
.i16
 lda #$7400
 sta f:$002116
 ldx #0
@bg3:
 txa
 ora #$2000 ; BG3 high priority
 sta f:$002118
 inx
 cpx #1024
 bne @bg3
 lda #$7800
 sta f:$002116
 ldx #1024
 lda #$3C40 ; palette 7, priority high, blank tile 64
@bg2:
 sta f:$002118
 dex
 bne @bg2
 ; Paper masks: 64 blank, 65 solid, 66..72 left clipped, 73..79 right.
 lda #$6400
 sta f:$002116
 ldx #0
@pattern:
 txa
 and #15
 tay
 sep #$20
.a8
 phx
 tyx
 lda f:$7F0000+Masks,x
 plx
 rep #$20
.a16
 and #255
 ldy #8
@low:
 sta f:$002118
 dey
 bne @low
 ldy #8
 pha
 lda #0
@high:
 sta f:$002118
 dey
 bne @high
 pla
 inx
 cpx #16
 bne @pattern
 sep #$30
.a8
.i8
 lda #9
 sta f:$002105
 lda #$17 ; BG1+BG2+BG3+OBJ
 sta f:$00212C
 lda #$0F
 sta f:$002100
 rts
Masks: .byte 0,$FF,$7F,$3F,$1F,$0F,7,3,1,$80,$C0,$E0,$F0,$F8,$FC,$FE

; A=logical screen row. Pack the low planes in place and upload during VBlank.
_PresentOverlay:
 sta $1120
 rep #$10
.i16
 ldx #0
 ldy #0
@tile:
 lda #16
 sta $1121
@pack:
 lda _raster,x
 sta _raster,y
 inx
 iny
 dec $1121
 bne @pack
 rep #$20
.a16
 txa
 clc
 adc #16
 tax
 sep #$20
.a8
 cpx #1024
 bcc @tile
 sep #$10
.i8
 jsr _WaitBlank
 rep #$20
.a16
 lda $1120
 and #255
 xba
 clc
 adc #$4000
 sta f:$002116
 lda #_raster
 sta f:$004312
 lda #512
 sta f:$004315
 sep #$20
.a8
 lda #1
 sta f:$004310
 lda #$18
 sta f:$004311
 lda #$7E
 sta f:$004314
 lda #2
 sta f:$00420B
 ; BG2 coverage is tile-aligned except its two clipped edge tiles.
 rep #$30
.a16
.i16
 lda $1120
 and #255
 asl
 asl
 asl
 asl
 asl
 clc
 adc #$7800
 sta f:$002116
 ldx #0
@map:
 txa
 clc
 adc #8
 cmp _ui_left
 bcc @blank
 beq @blank
 txa
 cmp _ui_right
 bcs @blank
 lda #65
 sta $1122
 txa
 cmp _ui_left
 bcs @right
 lda _ui_left
 and #7
 clc
 adc #65 ; left clip 1 -> tile 66
 sta $1122
@right:
 txa
 clc
 adc #8
 cmp _ui_right
 bcc @mask
 beq @mask
 lda _ui_right
 and #7
 clc
 adc #72 ; right clip 1 -> tile 73
 sta $1122
@mask:
 lda $1122
 ora #$3C00
 bra @write
@blank:
 lda #$3C40
@write:
 sta f:$002118
 txa
 clc
 adc #8
 tax
 cpx #256
 bcc @map
 sep #$30
.a8
.i8
 jmp MapRow ; (map.s: 512x448 shows this row's UI in mode 1)
