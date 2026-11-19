; Four-pixel styled text: three neighboring glyph fragments form each tile
; because the document has a one-pixel left inset. Normal/bold bitmaps stay
; inside their cells; italic and non-four-pixel rows use the original compositor.
; Accepted rows clear their packed output without touching shade scratch.
; Cache: $7E:DC00..DFFF keys (128 * 8), $7E:E000..EFFF tiles (128 * 32).
; This is above snapshot $D100..D87F and separate from the stack/row caches.
; Scratch $1180..11BF; row pointer DP $E4..E5 is shared with DrawGlyphs.
.setcpu "65816"
.macpack longbranch
.export _DrawFixedTiles
.import _glyph_row, _raster, Fonts, StyleFonts, StyleColors, _Capture
.import _fixed_ready, _fixed_hits, _fixed_misses, _fixed_hints, _ClearTiles
.import _fixed_direct, _fixed_slot, _SharedBeginRow, _SharedFixedTile, _SharedFixedEnd, _SharedFixedReuse
.segment "CODE"
.a8
.i8
_DrawFixedTiles:
 php
 rep #$30
.a16
.i16
 lda _glyph_row
 sta $E4
 ldy #0
 lda ($E4),y
 cmp #$0102 ; font fixed, styled flag set
 beq @fixed
@reject:
 plp
.a8
.i8
 lda #0
 rts
@fixed:
.a16
.i16
 ldy #4
 lda ($E4),y
 and #255
 sta $118E ; character count
 ldx #0
@validate:
 cpx $118E
 bcs @eligible
 txa
 clc
 adc #69 ; Row.attrs
 tay
 lda ($E4),y
 and #15
 cmp #4
 bne @reject
 lda ($E4),y
 and #$F0
 cmp #$20 ; italic
 beq @reject
 cmp #$30 ; bold italic
 beq @reject
 inx
 txa
 and #7
 bne @validationPolled
 phx
 sep #$30
.a8
.i8
 jsr _Capture
 rep #$30
.a16
.i16
 plx
@validationPolled:
 bra @validate
@eligible:
 sep #$30
.a8
.i8
 jsr _ClearTiles
 rep #$30
.a16
.i16
.ifdef SHARED_RENDER
 sep #$20
.a8
 lda _fixed_direct
 beq :+
 lda _fixed_slot
 jsr _SharedBeginRow
:
 rep #$20
.a16
.endif
 lda _fixed_ready
 and #255
 bne @initialized
 ldx #0
@clearKeys:
 .repeat 16,I
  stz $DC00+I*2,x
 .endrepeat
 txa
 clc
 adc #32
 tax
 and #127
 bne @clearPolled
 phx
 sep #$30
.a8
.i8
 jsr _Capture
 rep #$30
.a16
.i16
 plx
@clearPolled:
 cpx #1024
 bcc @clearKeys
 sep #$20
.a8
 lda #1
 sta _fixed_ready
 rep #$20
.a16
@initialized:
 stz $1198 ; raster byte offset
 stz $119A ; even character index
 lda $118E
 bne @tile
 jmp @done
@tile:
 ; Build keys for the previous odd, current even and next odd characters.
 lda $119A
 dec
 ldx #0
 jsr FixedKey
 lda $119A
 ldx #2
 jsr FixedKey
 lda $119A
 inc
 ldx #4
 jsr FixedKey
 ; Fold ordered character/style words to a direct-mapped cache index.
 lda $1180
 asl
 eor $1182
 asl
 asl
 eor $1184
 sta $11A0
 xba
 eor $11A0
 and #127
 asl
 asl
 asl
 sta $119C ; key offset = slot * 8
 tax
 lda $DC06,x
 cmp #1
 beq @valid
 jmp @miss
@valid:
 lda $DC00,x
 cmp $1180
.ifdef SHARED_RENDER
 jne @miss
.else
 bne @miss
.endif
 lda $DC02,x
 cmp $1182
.ifdef SHARED_RENDER
 jne @miss
.else
 bne @miss
.endif
 lda $DC04,x
 cmp $1184
.ifdef SHARED_RENDER
 jne @miss
.else
 bne @miss
.endif
 inc _fixed_hits
.ifdef SHARED_RENDER
 lda _fixed_direct
 and #255
 beq :+
 sep #$30
.a8
.i8
 jsr _SharedFixedReuse
 cmp #0
 rep #$30
.a16
.i16
 beq :+
 jmp @published
:
 ldx $119C
.endif
 txa
 asl
 asl
 tax
 ldy $1198
 .repeat 16,I
  lda $E000+I*2,x
  sta _raster+I*2,y
 .endrepeat
 jmp @next
@miss:
 inc _fixed_misses
 ; Glyph pointers and palette-plane masks are constant across eight scanlines.
 ldx #0
 jsr FixedGlyph
 ldx #2
 jsr FixedGlyph
 ldx #4
 jsr FixedGlyph
 stz $119E ; scanline
@line:
 ldx $1188
 lda f:$7F0000+Fonts,x
 and #$10
 asl
 asl
 asl
 sep #$20
.a8
 sta $11A8 ; previous glyph's last pixel
 rep #$20
.a16
 ldx $118A
 lda f:$7F0000+Fonts,x
 and #$F0
 lsr
 sep #$20
.a8
 sta $11A9 ; four pixels starting at x=1
 rep #$20
.a16
 ldx $118C
 lda f:$7F0000+Fonts,x
 and #$F0
 lsr
 lsr
 lsr
 lsr
 lsr
 sep #$20
.a8
 sta $11AA ; first three pixels starting at x=5
 rep #$20
.a16
 lda $1198
 clc
 adc $119E
 tay
 sep #$20
.a8
 .repeat 3,Plane
  lda $11A8
  and $11B0+Plane
  sta $11AB
  lda $11A9
  and $11B3+Plane
  ora $11AB
  sta $11AB
  lda $11AA
  and $11B6+Plane
  ora $11AB
  .if Plane = 0
   sta _raster,y
  .elseif Plane = 1
   sta _raster+1,y
  .else
   sta _raster+16,y
  .endif
 .endrepeat
 rep #$20
.a16
 inc $1188
 inc $118A
 inc $118C
 inc $119E
 inc $119E
 ; Raster scanlines advance by two bytes; font bitmaps advance by one.
 lda $119E
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
 lda $119E
 cmp #16
 bcs @store
 jmp @line
@store:
 ; The final tile is clipped at document x=249 (only its first pixel survives).
 lda $1198
 cmp #31*32
 bne @key
 ldy #0
@clip:
 lda _raster+31*32,y
 and #$8080
 sta _raster+31*32,y
 lda _raster+31*32+16,y
 and #$8080
 sta _raster+31*32+16,y
 iny
 iny
 cpy #16
 bcc @clip
@key:
.ifdef SHARED_RENDER
 ldx $119C
 txa
 lsr
 lsr
 tax
 lda #$FFFF
 sta $B580,x ; replacement invalidates this fixed key's VRAM association
.endif
 ldx $119C
 lda $1180
 sta $DC00,x
 lda $1182
 sta $DC02,x
 lda $1184
 sta $DC04,x
 lda #1
 sta $DC06,x
 txa
 asl
 asl
 tax
 ldy $1198
 .repeat 16,I
  lda _raster+I*2,y
  sta $E000+I*2,x
 .endrepeat
@next:
.ifdef SHARED_RENDER
 lda _fixed_direct
 and #255
 beq :+
 sep #$30
.a8
.i8
 jsr _SharedFixedTile
 rep #$30
.a16
.i16
:
.endif
@published:
 sep #$30
.a8
.i8
 jsr _Capture
 rep #$30
.a16
.i16
 lda $1198
 clc
 adc #32
 sta $1198
 cmp #1024
 bcs @done
 lda $119A
 clc
 adc #2
 sta $119A
 ; An even-length row may leave one pixel from its last odd character.
 cmp $118E
 bcc @more
 beq @more
@done:
.ifdef SHARED_RENDER
 sep #$30
.a8
.i8
 lda _fixed_direct
 beq :+
 jsr _SharedFixedEnd
:
.endif
 plp
.a8
.i8
 lda #1
 rts
@more:
.a16
.i16
 jmp @tile

; A=character index, X=key word offset (0/2/4). Outside the row is blank.
; Character 62 begins at x=249, outside the document clip.
.a16
.i16
FixedKey:
 cmp $118E
 bcs @space
 cmp #62
 bcs @space
 sta $11A0
 clc
 adc #5
 tay
 lda ($E4),y
 and #255
 cmp #32
 beq @space
 sta $11A2
 lda $11A0
 clc
 adc #69
 tay
 lda ($E4),y
 and #$F0
 asl
 asl
 asl
 asl
 ora $11A2
 sta $1180,x
 rts
@space:
 lda #32
 sta $1180,x
 rts

; X=key word offset. Prepare font pointers and three 0/FF plane masks.
FixedGlyph:
 stx $11A4
 lda $1180,x
 xba
 and #15
 sta $11A6
 tax
 sep #$20
.a8
 lda f:$7F0000+StyleFonts+32,x ; font 2's style row
 rep #$20
.a16
 and #255
 xba
 asl
 asl
 asl
 sta $11AC
 ldx $11A4
 lda $1180,x
 and #255
 asl
 asl
 asl
 clc
 adc $11AC
 sta $1188,x
 ldx $11A6
 sep #$20
.a8
 lda f:$7F0000+StyleColors,x
 rep #$20
.a16
 and #255
 sta $11AC
 asl
 clc
 adc $11AC
 tax
 lda $11A4
 lsr
 sta $11AC
 asl
 clc
 adc $11AC
 tay ; source glyph 0/1/2 -> plane mask offset 0/3/6
 sep #$20
.a8
 lda ColorPlanes,x
 sta $11B0,y
 lda ColorPlanes+1,x
 sta $11B1,y
 lda ColorPlanes+2,x
 sta $11B2,y
 rep #$20
.a16
 rts
.segment "RODATA"
ColorPlanes:
 .repeat 8,Color
  .repeat 3,Plane
   .if Color & (1 << Plane)
    .byte $FF
   .else
    .byte 0
   .endif
  .endrepeat
 .endrepeat
