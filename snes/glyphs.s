; Native row layout. Row ABI is asserted in kernel.c; scratch $1140..1153
; is separate from raster.s, ICD2 scratch and cc65's direct-page runtime.
.setcpu "65816"
.export _DrawGlyphs
.import _glyph_row,_glyph_x,_glyph_right,_glyph_offset,_glyph_color,_glyph_icon
.import _Capture,_FontWidth,_BlitGlyph
.segment "CODE"
.a8
.i8
_DrawGlyphs:
 php
 rep #$30
.a16
.i16
 lda _glyph_row
 sta $E4
 ldy #0
 lda ($E4),y
 and #255
 sta $1142 ; original font
 iny
 lda ($E4),y
 and #255
 sta $1144 ; styled
 ldy #4
 lda ($E4),y
 and #255
 sta $1146 ; character count
 stz $1140 ; character index
@next:
 lda $1140
 cmp $1146
 bcc @inRange
 jmp @done
@inRange:
 lda _glyph_x
 cmp _glyph_right
 bcc @character
 jmp @done
@character:
 ; All paths, including runs of spaces, service the ICD2 between characters.
 sep #$30
.a8
.i8
 jsr _Capture
 rep #$30
.a16
.i16
 lda $1140
 clc
 adc #5
 tay
 lda ($E4),y
 and #255
 sta $1148 ; character
 cmp #127
 bne @ordinary
 lda $1144
 bne @ordinary
 jmp @clock
@ordinary:
 lda $1144
 beq @fontWidth
 lda $1140
 clc
 adc #69
 tay
 lda ($E4),y
 and #255
 sta $114C ; width/style attribute
 and #15
 sta $114E
 bra @haveWidth
@fontWidth:
 lda $1148
 ldx $1142
 sep #$30
.a8
.i8
 jsr _FontWidth
 rep #$30
.a16
.i16
 and #255
 sta $114E
 stz $114C
@haveWidth:
 lda $1148
 cmp #32
 bne @ink
 jmp @advance
@ink:
 lda $114C
 lsr
 lsr
 lsr
 lsr
 sta $1150 ; style
 lda $1142
 asl
 asl
 asl
 asl
 ora $1150
 tax
 sep #$20
.a8
 lda f:$7F0000+StyleFonts,x
 rep #$20
.a16
 and #255
 xba
 asl
 asl
 asl
 sta _glyph_offset
 lda $1148
 asl
 asl
 asl
 clc
 adc _glyph_offset
 sta _glyph_offset
 ldx $1150
 sep #$20
.a8
 lda f:$7F0000+StyleColors,x
 sta _glyph_color
 rep #$20
.a16
 lda #$FFFF
 sta _glyph_icon
 lda $1144
 bne @draw
 lda $1148
 beq @draw
 cmp #9
 bcc @smallIcon
 cmp #129
 bcc @draw
 cmp #132
 bcs @draw
 sec
 sbc #121
 bra @icon
@smallIcon:
 dec
@icon:
 asl
 asl
 asl
 asl
 asl
 asl
 clc
 adc #13*2048+256
 sta _glyph_icon
@draw:
 sep #$30
.a8
.i8
 jsr _BlitGlyph
 rep #$30
.a16
.i16
@advance:
 lda _glyph_x
 clc
 adc $114E
 sta _glyph_x
@continue:
 inc $1140
 jmp @next
@done:
 plp
 rts
@clock:
 ; Skip the repeated right-alignment marker, trim the trailing spaces, then
 ; subtract the suffix's widths from X=252. The normal loop draws the suffix.
 lda $1140
 inc
@marker:
 cmp $1146
 bcs @clockStart
 clc
 adc #5
 tay
 lda ($E4),y
 and #255
 cmp #127
 bne @clockStart
 inc $1140
 lda $1140
 inc
 bra @marker
@clockStart:
 lda #252
 sta _glyph_x
 lda $1146
 sta $1152 ; suffix end
@trim:
 lda $1140
 inc
 cmp $1152
 bcs @continue
 lda $1152
 clc
 adc #4 ; chars[k-1]
 tay
 lda ($E4),y
 and #255
 cmp #32
 bne @suffix
 dec $1152
 bra @trim
@suffix:
 lda $1140
 inc
 cmp $1152
 bcs @continue
 lda $1152
 clc
 adc #4
 tay
 lda ($E4),y
 and #255
 ldx $1142
 sep #$30
.a8
.i8
 jsr _FontWidth
 rep #$30
.a16
.i16
 and #255
 sta $1150
 lda _glyph_x
 sec
 sbc $1150
 sta _glyph_x
 dec $1152
 sep #$30
.a8
.i8
 jsr _Capture
 rep #$30
.a16
.i16
 bra @suffix
StyleColors:
 .byte 3,3,3,3,2,5,4,4,2,4,4,5,6,7,7,3
StyleFonts:
 .repeat 7,FontIndex
  .repeat 16,StyleIndex
   .if FontIndex >= 3
    .byte FontIndex
   .elseif StyleIndex = 5
    .byte 2
   .elseif (StyleIndex = 1) || (StyleIndex = 2) || (StyleIndex = 3) || (StyleIndex = 7) || (StyleIndex = 13)
    .if FontIndex = 2
     .byte 7 + (StyleIndex = 2) + 2*(StyleIndex = 3)
    .else
     .byte 10 + (StyleIndex = 2) + 2*(StyleIndex = 3)
    .endif
   .else
    .byte FontIndex
   .endif
  .endrepeat
 .endrepeat
