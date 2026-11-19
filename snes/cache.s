; Unselected 4bpp rows, indexed by the physical BG1 ring slot.
; Slots 0..15: $7E:6000..9FFF; slots 16..31: $7F:C000..FFFF.
; kernel.cfg reserves both intervals. Scratch $1160..1170 and DP $E6..E8
; are separate from the raster, glyph, ICD2 and cc65 runtime scratch.
.setcpu "65816"
.export _CacheRaster, _RestoreRaster, _SelectRaster
.import _raster, _pixel_start, _pixel_end, _Capture
.segment "CODE"
.a8
.i8

; A=slot. Called with 16-bit A/X/Y; returns 16-bit A/X/Y.
.a16
.i16
CacheAddress:
 and #255
 cmp #16
 bcc @low
 and #15
 xba
 asl
 asl
 clc
 adc #$C000
 sta $E6
 sep #$20
.a8
 lda #$7F
 bra @bank
@low:
.a16
 xba
 asl
 asl
 clc
 adc #$6000
 sta $E6
 sep #$20
.a8
 lda #$7E
@bank:
 sta $E8
 rep #$20
.a16
 ldy #0
 rts

; Long indirect addressing reaches both cache banks without changing DBR.
.macro CopyRaster Name, Store
.a8
.i8
Name:
 php
 rep #$30
.a16
.i16
 jsr CacheAddress
@chunk:
 .repeat 16
  .if Store
   lda _raster,y
   sta [$E6],y
  .else
   lda [$E6],y
   sta _raster,y
  .endif
  iny
  iny
 .endrepeat
 tya
 and #255
 bne @copied
 phy
 sep #$30
.a8
.i8
 jsr _Capture
 rep #$30
.a16
.i16
 ply
@copied:
 cpy #1024
 bcs @done
 jmp @chunk
@done:
 plp
 rts
.endmacro
CopyRaster _CacheRaster, 1
CopyRaster _RestoreRaster, 0

; Recolor selected pixels directly in the cached row's working bitplanes.
; ShadeColors maps selected paper 0->1, preserves 1/2/3, and maps accents 4..7->3.
; For selection mask m: p0 |= m & (~p1 | p2), p1 |= m & p2, p2 &= ~m.
; Color 2 is always dim ink (BlitGlyph never emits accent color 2).
; This preserves dim glyphs, icons, clipping and italic overlaps exactly.
.a8
.i8
_SelectRaster:
 php
 rep #$30
.a16
.i16
 lda _pixel_start
 cmp _pixel_end
 bcc @range
 plp
 rts
@range:
 and #$FFF8
 asl
 asl
 sta $1160 ; first tile's byte offset
 lda _pixel_end
 dec
 and #$FFF8
 asl
 asl
 sta $1162 ; last tile's byte offset
 ldx $1160
@tile:
 sep #$20
.a8
 lda #$FF
 sta $1164
 rep #$20
.a16
 cpx $1160
 bne @right
 lda _pixel_start
 and #7
 tay
 sep #$20
.a8
 lda LeftMasks,y
 sta $1164
@right:
 rep #$20
.a16
 cpx $1162
 bne @maskReady
 lda _pixel_end
 and #7
 tay
 sep #$20
.a8
 lda RightMasks,y
 and $1164
 sta $1164
@maskReady:
 sep #$20
.a8
 ldy #8
@scanline:
 lda _raster+16,x
 sta $1165 ; original plane 2
 lda _raster+1,x
 eor #$FF
 ora $1165
 and $1164
 ora _raster,x
 sta _raster,x
 lda $1165
 and $1164
 ora _raster+1,x
 sta _raster+1,x
 lda $1164
 eor #$FF
 and $1165
 sta _raster+16,x
 inx
 inx
 dey
 bne @scanline
 ; X now points halfway through this tile; advance over planes 2/3.
 rep #$20
.a16
 txa
 clc
 adc #16
 tax
 phx
 sep #$30
.a8
.i8
 jsr _Capture
 rep #$30
.a16
.i16
 plx
 cpx $1162
 bcc @more
 beq @more
 plp
 rts
@more:
 jmp @tile
.segment "RODATA"
LeftMasks: .byte $FF,$7F,$3F,$1F,$0F,7,3,1
RightMasks: .byte $FF,$80,$C0,$E0,$F0,$F8,$FC,$FE
