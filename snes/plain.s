; Pack ordinary text directly from its one-bit font into planes 0/1 (ink 3).
; Glyphs may straddle tiles and overlap; OR composition matches the shade path.
; Accepted rows clear their packed output without touching shade scratch.
; Icons, clock alignment and non-text styles fall back before changing output.
; Scratch $11C0..11DF and the shared row pointer $E4..E5; DBR remains $7E.
.setcpu "65816"
.export _DrawPlainTiles
.import _glyph_row, _raster, Fonts, _ClearTiles, _Capture, _plain_rows
.segment "CODE"
.a8
.i8
_DrawPlainTiles:
 php
 rep #$30
.a16
.i16
 lda _glyph_row
 sta $E4
 ldy #0
 lda ($E4),y
 and #255
 cmp #7
 bcc @font
@reject:
 plp
.a8
.i8
 lda #0
 rts
@font:
.a16
.i16
 sta $11CC ; font
 xba
 asl
 asl
 asl
 sta $11C6 ; font bitmap offset
 iny
 lda ($E4),y
 and #255
 sta $11CE ; styled flag
 ldy #4
 lda ($E4),y
 and #255
 sta $11CA ; character count
 ldx #0
@validate:
 cpx $11CA
 bcs @eligible
 lda $11CE
 beq @unstructured
 txa
 clc
 adc #69 ; Row.attrs
 tay
 lda ($E4),y
 and #$F0
 bne @reject
 bra @validated
@unstructured:
 txa
 clc
 adc #5 ; Row.chars
 tay
 lda ($E4),y
 and #255
 beq @validated
 cmp #9
 bcc @reject
 cmp #127
 beq @reject
 cmp #129
 bcc @validated
 cmp #132
 bcc @reject
@validated:
 inx
 txa
 and #7
 bne @validate
 phx
 sep #$30
.a8
.i8
 jsr _Capture
 rep #$30
.a16
.i16
 plx
 bra @validate
@eligible:
 sep #$30
.a8
.i8
 jsr _ClearTiles
 rep #$30
.a16
.i16
 inc _plain_rows
 stz $11C8 ; character index
 lda #0
 ldx $11CC
 beq @mono
 inc
@mono:
 sta $11C4 ; text x, including the inset for non-mono fonts
 clc
 adc #248
 sta $11D2 ; exclusive right edge
@next:
 lda $11C8
 cmp $11CA
 bcc @inRange
 jmp @done
@inRange:
 lda $11C4
 cmp $11D2
 bcc @character
 jmp @done
@character:
 lda $11C8
 clc
 adc #5
 tay
 lda ($E4),y
 and #255
 sta $11C0 ; character
 asl
 asl
 asl
 clc
 adc $11C6
 sta $11D0 ; bitmap offset
 lda $11CE
 beq @fontWidth
 lda $11C8
 clc
 adc #69
 tay
 lda ($E4),y
 and #15
 bra @width
@fontWidth:
 lda $11CC
 beq @eight
 cmp #1
 beq @variable
 cmp #2
 beq @four
 eor #$FFFF
 clc
 adc #12 ; 11-font for headings
 bra @width
@four:
 lda #4
 bra @width
@eight:
 lda #8
 bra @width
@variable:
 ldx $11C0
 lda f:$7F0000+Fonts+13*2048,x
 and #255
@width:
 sta $11DC
 lda $11C0
 cmp #32
 bne @bitmap
 jmp @advance
@bitmap:
 lda $11D2
 sec
 sbc $11C4
 cmp #8
 bcc @clip
 lda #8
@clip:
 tax
 stz $11D6
 sep #$20
.a8
 lda ClipMasks,x
 sta $11D6
 rep #$20
.a16
 lda $11C4
 and #7
 sta $11D4 ; bit shift inside the current tile
 lda $11C4
 and #$FFF8
 asl
 asl
 sta $11D8 ; raster tile offset
 stz $11DA ; scanline byte offset
@line:
 ldx $11D0
 lda f:$7F0000+Fonts,x
 and #255
 and $11D6 ; clip mask high byte must be zero
 xba
 ldx $11D4
 beq @shifted
@shift:
 lsr
 dex
 bne @shift
@shifted:
 sta $11DE ; high byte in this tile, low byte in its neighbor
 lda $11D8
 clc
 adc $11DA
 tay
 sep #$20
.a8
 lda $11DF
 ora _raster,y
 sta _raster,y
 sta _raster+1,y ; planes 0 and 1 remain identical (normal ink only)
 lda $11DE
 beq @noSpill
 ora _raster+32,y
 sta _raster+32,y
 sta _raster+33,y
@noSpill:
 rep #$20
.a16
 inc $11D0
 inc $11DA
 inc $11DA
 lda $11DA
 and #3
 bne @polled
 sep #$30
.a8
.i8
 jsr _Capture
 rep #$30
.a16
.i16
@polled:
 lda $11DA
 cmp #16
 bcc @line
@advance:
 lda $11C4
 clc
 adc $11DC
 sta $11C4
 inc $11C8
 sep #$30
.a8
.i8
 jsr _Capture
 rep #$30
.a16
.i16
 jmp @next
@done:
 plp
.a8
.i8
 lda #1
 rts
.segment "RODATA"
ClipMasks: .byte 0,$80,$C0,$E0,$F0,$F8,$FC,$FE,$FF
