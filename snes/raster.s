; Bounded pixel conversion. Scratch $1100..111F is outside cc65's ZP/runtime.
.setcpu "65816"
.export _EncodeRow
.import _shade,_raster,_pixel_start,_pixel_end
.a8
.i8
.segment "CODE"
_EncodeRow:
 php
 rep #$10
.i16
 ldx #0
@pixel:
 lda _shade,x
 and #1
 beq @paper
 lda _shade,x
 and #2
 bne @dim
 lda _shade,x
 lsr
 lsr
 beq @ink
 sta $1100
 jsr Selected
 bcc @accent
 lda $1100
 cmp #1
 beq @accent
 bra @ink
@accent:
 lda $1100
 bra @color
@dim:
 lda #2
 bra @color
@ink:
 lda #3
 bra @color
@paper:
 jsr Selected
 lda #0
 bcc @color
 inc
@color:
 sta $1101
 ; x = y*256 + screenX. Tile address = (screenX/8)*32 + y*2.
 rep #$20
.a16
 txa
 and #$00F8
 asl
 asl
 sta $1102
 txa
 xba
 and #7
 asl
 ora $1102
 tay
 txa
 and #7
 sta $1104
 sep #$20
.a8
 phx
 ldx $1104
 lda f:$7F0000+Masks,x
 sta $1106
 plx
 lda $1101
 lsr
 bcc @p1
 lda _raster,y
 ora $1106
 sta _raster,y
@p1:
 lda $1101
 and #2
 beq @p2
 lda _raster+1,y
 ora $1106
 sta _raster+1,y
@p2:
 lda $1101
 and #4
 beq @p3
 lda _raster+16,y
 ora $1106
 sta _raster+16,y
@p3:
 lda $1101
 and #8
 beq @next
 lda _raster+17,y
 ora $1106
 sta _raster+17,y
@next:
 inx
 txa
 and #15
 bne @continue
 phx
 sep #$10
.i8
 jsr _Capture
 rep #$10
.i16
 plx
@continue:
 cpx #2048
 bcs @done
 jmp @pixel
@done:
 plp
 rts
; Carry iff pixel X is in a half-open selection interval (both 16-bit).
Selected:
 rep #$20
.a16
 txa
 and #255
 cmp _pixel_start
 bcc @no
 cmp _pixel_end
 bcs @no
 sep #$20
.a8
 sec
 rts
@no:
 sep #$20
 clc
 rts
Masks: .byte $80,$40,$20,$10,8,4,2,1
.import _Capture

.export _BlitGlyph
.import Fonts,_glyph_offset,_glyph_x,_glyph_color,_glyph_icon,_glyph_right
.a8
.i8
_BlitGlyph:
 php
 lda #0
 sta $1110 ; y
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
@bit:
 lda _glyph_icon+1
 cmp #$FF
 bne @icon
 lda $1111
 and #$80
 beq @skip
 lda _glyph_color
 bra @composite
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
 sta $1112
 lda ($E2),y
 ora #1
 ldx $1112
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
 ; clip at the right edge; glyph_x has no high byte unless off screen.
 rep #$20
.a16
 tya
 and #255
 clc
 adc _glyph_x
 cmp _glyph_right
 sep #$20
.a8
 bcs @rowDone
 cpy #8
 bcc @bit
@rowDone:
 jsr _Capture
 inc $1110
 lda $1110
 cmp #8
 bcs @finished
 jmp @row
@finished:
 plp
 rts
