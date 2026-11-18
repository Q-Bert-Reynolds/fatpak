; Bounded pixel conversion. Scratch $1100..111F is outside cc65's ZP/runtime.
.setcpu "65816"
.export _EncodeRow
.import _shade,_raster,_pixel_start,_pixel_end
.a8
.i8
.segment "CODE"
_EncodeRow:
 php
 ; Mark selected shade pixels once; conversion then uses one 64-entry table.
 ; Shade is scratch for this row and ClearRaster erases it before the next one.
 rep #$30
.a16
.i16
 lda _pixel_start
 cmp _pixel_end
 bcs @unselected
 sta $1106
 lda _pixel_end
 sta $110A
 ldy #8
@selectRow:
 ldx $1106
@selectPixel:
 sep #$20
.a8
 lda _shade,x
 ora #32
 sta _shade,x
 rep #$20
.a16
 inx
 cpx $110A
 bcc @selectPixel
 phy
 sep #$30
.a8
.i8
 jsr _Capture
 rep #$30
.a16
.i16
 ply
 lda $1106
 clc
 adc #256
 sta $1106
 lda $110A
 clc
 adc #256
 sta $110A
 dey
 bne @selectRow
@unselected:
 sep #$20
.a8
 ldx #0
 ldy #0
 stz $1108
 stz $1109
@tile:
 ; Empty tiles dominate browser/editor rows. Leave their cleared raster alone.
 rep #$20
.a16
 lda _shade,x
 ora _shade+2,x
 ora _shade+4,x
 ora _shade+6,x
 beq @emptyTile
 cmp #$2020
 bne @inkTile
 lda _shade,x
 and _shade+2,x
 and _shade+4,x
 and _shade+6,x
 cmp #$2020
 bne @inkTile
 sep #$20
.a8
 lda #$FF
 sta _raster,y ; uniformly highlighted paper, all other planes remain zero
 jmp @capturedTile
@emptyTile:
 sep #$20
.a8
 jmp @capturedTile
@inkTile:
 sep #$20
.a8
 lda #0
 xba ; keep the hidden accumulator byte zero for the 16-bit table index
 stz $1100
 stz $1101
 stz $1102
 ; ShadeColors emits indices 0..7: the cleared fourth plane stays zero.
 sty $110C ; Y becomes a color-table index while packing this tile
 .repeat 8
  lda _shade,x
  tay
  lda ShadeColors,y
  lsr
  rol $1100
  lsr
  rol $1101
  lsr
  rol $1102
  inx
 .endrepeat
 ldy $110C
 lda $1100
 sta _raster,y
 lda $1101
 sta _raster+1,y
 lda $1102
 sta _raster+16,y
 ; Full pixel loop already advanced X. Blank tiles advance it here instead.
 bra @captureTile
@capturedTile:
 rep #$20
.a16
 txa
 clc
 adc #8
 tax
 sep #$20
.a8
@captureTile:
 ; Four tiles are a bounded sub-row chunk. The ICD2 retains four completed
 ; input rows; this services it well before that window can be overwritten.
 rep #$20
.a16
 txa
 and #31
 bne @packed
 phx
 phy
 sep #$30
.a8
.i8
 jsr _Capture
 rep #$30
.a16
.i16
 ply
 plx
@packed:
 rep #$20
.a16
 txa
 and #255
 beq @nextRow
 tya
 clc
 adc #32
 tay
 sep #$20
.a8
 jmp @tile
@nextRow:
 inc $1108
 inc $1108
 ldy $1108
 sep #$20
.a8
 cpx #2048
 bcs @done
 jmp @tile
@done:
 plp
 rts
.segment "RODATA"
ShadeColors:
 .repeat 64,I
  .if !(I & 1)
   .byte (I & 32) >> 5
  .elseif I & 2
   .byte 2
  .elseif !(I & 28)
   .byte 3
  .elseif (I & 32) && ((I & 28) <> 4)
   .byte 3
  .else
   .byte (I & 28) >> 2
  .endif
 .endrepeat

.segment "CODE"
.import _Capture

.export _BlitGlyph
.import Fonts,_glyph_offset,_glyph_x,_glyph_color,_glyph_icon,_glyph_right
.a8
.i8
_BlitGlyph:
 php
 rep #$20
.a16
 lda _glyph_right
 sec
 sbc _glyph_x
 cmp #8
 bcc @width
 lda #8
@width:
 sep #$20
.a8
 sta $1116 ; clip once per glyph, not once per pixel
 ; Normal glyphs share one compositing rule for all their occupied pixels.
 lda #$FF
 sta $1112 ; keep existing shade bits for normal/dim ink
 lda _glyph_color
 cmp #3
 beq @normalInk
 cmp #2
 beq @dimInk
 asl
 asl
 ora #1
 sta $1113
 lda #3
 sta $1112 ; accented ink replaces the old accent, preserving ink/dim
 bra @ready
@normalInk:
 lda #1
 bra @mask
@dimInk:
 lda #3
@mask:
 sta $1113
@ready:
 stz $1110 ; y
@row:
 rep #$30
.a16
.i16
 lda $1110
 and #255
 clc
 adc _glyph_offset
 tax
 sep #$20
.a8
 lda f:$7F0000+Fonts,x
 sta $1111 ; bitmap
 lda _glyph_icon+1
 cmp #$FF
 bne @nonblank
 lda $1111
 bne @nonblank
 jmp @rowDone
@nonblank:
 rep #$20
.a16
 lda $1110
 and #255
 xba
 clc
 adc _glyph_x
 clc
 adc #_shade
 sta $E2
 sep #$30
.a8
.i8
 ldy #0
 lda _glyph_icon+1
 cmp #$FF
 bne @icon
@bitmap:
 asl $1111
 bcc @blankPixel
 lda ($E2),y
 and $1112
 ora $1113
 sta ($E2),y
@blankPixel:
 iny
 cpy $1116
 bcc @bitmap
 bra @rowDone
@icon:
 rep #$30
.a16
.i16
 tya
 and #255
 sta $1114
 lda $1110
 and #255
 asl
 asl
 asl
 clc
 adc _glyph_icon
 clc
 adc $1114
 tax
 sep #$20
.a8
 lda f:$7F0000+Fonts,x
 sep #$10
.i8
 beq @skip
@composite:
 sta $1114
 lda ($E2),y
 ora #1
 ldx $1114
 cpx #2
 bne @accent
 ora #2
 bra @store
@accent:
 cpx #3
 beq @store
 and #3
 sta $1113
 txa
 asl
 asl
 ora $1113
@store:
 sta ($E2),y
@skip:
 asl $1111
 iny
 cpy $1116
 bcc @icon
@rowDone:
 lda $1110
 and #1
 beq @rowPolled
 jsr _Capture
@rowPolled:
 inc $1110
 lda $1110
 cmp #8
 bcs @finished
 jmp @row
@finished:
 plp
 rts
