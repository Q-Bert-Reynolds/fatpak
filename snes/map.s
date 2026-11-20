; A module's background (SGBFS_CMD_MAP*: MAPVIEW's Beisbol map) on BG1 instead of the text. BG1's map moves
; to word $1000 (byte $2000), 64x32 cells; its 256 tiles are at $0000, GB 2bpp tiles as 4bpp with plane 2
; set (pixels 4-7: never transparent, GB palette p at CGRAM p*16+4). Leaving it, BG1 points at the text's
; map again ($E000) and every text row is drawn again (kernel.c). Called from C with 8-bit A and index.
.setcpu "65816"
.export _MapLayer, _MapUpload, _MapCells, _MapColors, _MapScroll
.import _WaitBlank, _raster
.import _map_vram, _map_bytes, _map_count, _map_colors, _map_x, _map_y
.segment "CODE"
.a8
.i8

; A = 1: BG1 shows the map (its cells cleared to tile 0), 0: the text's map and no horizontal scroll
_MapLayer:
 pha
 jsr _WaitBlank
 pla
 beq @text
 lda #$80
 sta f:$002100 ; forced blank: 4 KiB of cells is more than a VBlank
 sta f:$002115
 rep #$20
.a16
 lda #$1000
 sta f:$002116
 sep #$20
.a8
 lda #0
 sta f:$00100C
 lda #9 ; fixed source, transfer mode 1
 sta f:$004310
 lda #$18
 sta f:$004311
 rep #$20
.a16
 lda #$100C
 sta f:$004312
 lda #4096
 sta f:$004315
 sep #$20
.a8
 lda #$7E
 sta f:$004314
 lda #2
 sta f:$00420B
 lda #$11 ; BG1 map at word $1000, 64x32
 sta f:$002107
 jsr _WaitBlank
 lda #$0F
 sta f:$002100
 rts
@text:
 lda #$70 ; BG1 map at byte $E000, 32x32
 sta f:$002107
 lda #0
 sta f:$00210D
 sta f:$00210D
 rts

; map_bytes of _raster to VRAM word map_vram (tiles), in a VBlank
_MapUpload:
 jsr _WaitBlank
 lda #$80
 sta f:$002115
 rep #$20
.a16
 lda _map_vram
 sta f:$002116
 lda #_raster
 sta f:$004312
 lda _map_bytes
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
 rts

; map_count cells from _raster, each a VRAM word address and the cell's word, in a VBlank
_MapCells:
 jsr _WaitBlank
 lda #$80
 sta f:$002115
 rep #$30
.a16
.i16
 lda _map_count
 and #$00FF
 tay
 ldx #0
@cell:
 lda _raster,x
 sta f:$002116
 lda _raster+2,x
 sta f:$002118
 inx
 inx
 inx
 inx
 dey
 bne @cell
 sep #$30
.a8
.i8
 rts

; map_colors' 8 palettes of 4 to CGRAM p*16+4, in a VBlank
_MapColors:
 jsr _WaitBlank
 ldx #0
 ldy #0
@palette:
 tya
 asl
 asl
 asl
 asl
 ora #4
 sta f:$002121
@color:
 lda _map_colors,x
 sta f:$002122
 inx
 txa
 and #7
 bne @color
 iny
 cpy #8
 bne @palette
 rts

; BG1's scroll: map_x, map_y (vertical offset by a scanline, like the text's)
_MapScroll:
 jsr _WaitBlank
 lda _map_x
 sta f:$00210D
 lda _map_x+1
 sta f:$00210D
 lda _map_y
 dec
 sta f:$00210E
 lda #0
 sta f:$00210E
 rts
