; A module's background (SGBFS_CMD_MAP*: MAPVIEW's Beisbol map) on BG1 instead of the text. Two kinds:
;
; 256x224 (mode 1): BG1's map moves to word $1000 (byte $2000), 64x32 cells; its 256 tiles are at $0000,
; GB 2bpp tiles as 4bpp with plane 2 set (pixels 4-7: never transparent, GB palette p at CGRAM p*16+4).
;
; 512x448 (SGBFS_MAP_HIRES: mode 5 + interlace): a GB pixel is a hi-res one. Mode 5 draws an entry's tiles
; N and N+1 side by side, so each of BG1's 64x64 entries (word $3000, byte $6000) is a pair of GB cells: a
; cache of pairs (tiles 0-767, pair 0 the blank one) composed from the GB's tiles in WRAM, found by hashing
; both cells, counted by the entries using them and reused once none do. A pair's two cells may have
; different palettes: CGRAM palettes 1-7 each hold 3 GB palettes (slots 1-3: colours 4-15, never the
; transparent 0), and a pair's tiles take its palette's slots in planes 2-3. HDMA switches the rows with
; the bars, a box or the OSK (BG2/BG3 in mode 1) back to mode 1, without BG1.
;
; Leaving, BG1 points at the text's map again ($E000) and every text row is drawn again (kernel.c), the
; row cache too (the 512x448 tables are in its WRAM). Called from C with 8-bit A and index.
.setcpu "65816"
.export _MapLayer, _MapTiles, _MapCells, _MapColors, _MapScroll, _MapGlide, MapRow
.import _WaitBlank, _Capture, _raster, _shade, _ui_right
.import _map_mode, _map_src, _map_colors, _map_x, _map_y, _map_tx, _map_ty

HIRES = $10 ; SGBFS_MAP_HIRES
ROWS = 28
CELLS = $7FC000 ; 512x448: the GB's cells (tile, palette << 8), 128x64, a row 256 bytes (the row cache's)
ENTRY = $6000   ; $7E: BG1's 64x64 words as last written (the row cache's, to $9FFF)
REF = $8000     ; a pair's entries (each table indexed by its first tile's number, 2-766)
K0 = $8300      ; its left cell, $FFFF unused
BUCKET = $8600  ; 128 hash chains' first pair, $FFFF none
K1 = $8700      ; its right cell
NEXT = $8A00    ; the next pair in its chain
PCG = $8D00     ; its CGRAM palette << 10 (its map word's bits)
GBT = $9000     ; the GB's 256 tiles, 2bpp
PAIRS = 768     ; past the last pair's tile number
STAGE = 16      ; pairs composed in the raster before they go to VRAM
QUEUE = 256     ; bytes of entry writes (address, word) in shade before they go: 64 fit a VBlank with 16 pairs

.segment "BSS"
cgs: .res 32    ; CGRAM palette c's slot s (c * 4 + s, 1-3): its GB palette, $FF free
cgref: .res 16  ; pairs in use with palette c (c * 2)
cgdirty: .res 1
hand: .res 2    ; where the search for a free pair goes on from
staged: .res 2  ; their tile numbers' bytes in stage
stage: .res STAGE * 2
queued: .res 2
k0: .res 2      ; Update's cells
k1: .res 2
hk: .res 2      ; Hash's left cell
ht: .res 2
cx: .res 2      ; MapCells': x, y, the cell's address
cy: .res 2
cn: .res 2
src: .res 2
step: .res 2
pl: .res 2      ; PaletteFor's: the GB palettes, their slots, the pass's need, palette c
pr: .res 2
sl: .res 2
sr: .res 2
want: .res 2
need: .res 2
free: .res 2
ui_rows: .res ROWS ; rows with the bars, a box or the OSK (PresentOverlay)
hdma_mode: .res ROWS * 2 + 1
hdma_tm: .res ROWS * 2 + 1
tmp: .res 2

.segment "CODE"
.a8
.i8

; A = 1: BG1 shows the map (its cells cleared: tile 0, or the blank pair), 0: the text's map again
_MapLayer:
 pha
 jsr _WaitBlank
 pla
 bne @map
 lda #$70 ; BG1 map at byte $E000, 32x32
 sta f:$002107
 lda #0
 sta f:$00420C
 sta f:$00212D
 sta f:$002133
 sta f:$00210D
 sta f:$00210D
 lda #9
 sta f:$002105
 lda #$17
 sta f:$00212C
 rts
@map:
 lda #$80
 sta f:$002100 ; forced blank: more than a VBlank of clearing
 sta f:$002115
 lda #0
 sta f:$00100C
 lda #9 ; fixed source, transfer mode 1
 sta f:$004310
 lda #$18
 sta f:$004311
 lda #$7E
 sta f:$004314
 rep #$30
.a16
.i16
 lda #$100C
 sta f:$004312
 lda _map_mode
 and #HIRES
 bne @hires
 lda #$1000 ; the 64x32 map
 sta f:$002116
 lda #4096
 sta f:$004315
 sep #$30
.a8
.i8
 lda #2
 sta f:$00420B
 lda #$11 ; BG1 map at word $1000, 64x32
 sta f:$002107
 jmp @on
@hires:
.a16
.i16
 lda #0 ; tiles and map: the blank pair everywhere
 sta f:$002116
 lda #$8000
 sta f:$004315
 sep #$20
.a8
 lda #2
 sta f:$00420B
 rep #$20
.a16
 lda #0
 tax
@cells:
 sta f:CELLS,x
 inx
 inx
 cpx #$4000
 bne @cells
 ldx #ENTRY
@zero: ; ENTRY, REF
 sta a:0,x
 inx
 inx
 cpx #K0
 bne @zero
 dec a
@none: ; K0, BUCKET
 sta a:0,x
 inx
 inx
 cpx #K1
 bne @none
 ldx #30
@palettes:
 sta cgs,x
 dex
 dex
 bpl @palettes
 ldx #14
@counts:
 stz cgref,x
 dex
 dex
 bpl @counts
 stz staged
 stz queued
 lda #2
 sta hand
 sep #$30
.a8
.i8
 lda #$33 ; BG1 map at word $3000, 64x64
 sta f:$002107
 lda #1
 sta f:$002133 ; interlace: 448 lines in mode 5
 sta f:$00212D ; hi-res takes BG1 from both screens
 lda #0 ; HDMA 6: BGMODE, 7: TM, a byte a run of lines
 sta f:$004360
 sta f:$004370
 lda #$05
 sta f:$004361
 lda #$2C
 sta f:$004371
 lda #$7E
 sta f:$004364
 sta f:$004374
 rep #$20
.a16
 lda #hdma_mode
 sta f:$004362
 lda #hdma_tm
 sta f:$004372
 sep #$20
.a8
 jsr Regions
 lda #$C0
 sta f:$00420C
@on:
 jsr _WaitBlank
 lda #$0F
 sta f:$002100
 rts

; the bars' rows (and a box's, the OSK's): mode 1 with BG2/BG3 and no BG1; the rest mode 5's BG1. Each run
; of rows is a table entry of its lines; the first entry also has line 0, before the first shown
Regions:
 ldx #0
 ldy #0
 stz tmp
@run:
 lda ui_rows,x
 sta tmp+1
 lda tmp
@row:
 clc
 adc #8
 sta ht
 inx
 cpx #ROWS
 beq @emit
 cmp #8 * 15
 bcs @emit
 lda ui_rows,x
 cmp tmp+1
 bne @emit
 lda ht
 bra @row
@emit:
 lda ht
 sta hdma_mode,y
 sta hdma_tm,y
 iny
 lda tmp+1
 beq @map
 lda #9
 sta hdma_mode,y
 lda #$16
 bra @put
@map:
 lda #5
 sta hdma_mode,y
 lda #$11
@put:
 sta hdma_tm,y
 iny
 stz tmp
 cpx #ROWS
 bne @run
 lda #0
 sta hdma_mode,y
 sta hdma_tm,y
 rts

; PresentOverlay's row ($1120) done: whether it has the bars, a box or the OSK, which hi-res can't show
MapRow:
 ldx $1120
 lda _ui_right
 ora _ui_right+1
 beq @set
 lda #1
@set:
 sta ui_rows,x
 lda _map_mode
 and #HIRES
 bne Regions
 rts

; MAP_TILES at map_src: first, count, the GB's 2bpp tiles, kept to compose from: 512x448's pairs, and
; 256x224's own tiles at once (each a pair's half in slot 1: plane 2 set)
_MapTiles:
 rep #$30
.a16
.i16
 ldx _map_src
 lda a:0,x
 pha
 and #$00FF
 sta cx ; the first
 asl
 asl
 asl
 asl
 adc #GBT
 tay
 pla
 xba
 and #$00FF
 clc
 adc cx
 sta cn ; past the last
 sec
 sbc cx
 asl
 asl
 asl
 asl
 dec
 inx
 inx
 mvn #$7E, #$7E
 lda _map_mode
 and #HIRES
 bne @done
 lda #2
 sta sl
 sta sr
 lda cx
 and #$FFFE
 tax
@pair:
 stx k0
 txa
 inc
 sta k1
 jsr Stage
 inx
 inx
 cpx cn
 bcc @pair
@done:
 jmp Done

; MAP_CELLS at map_src: x, y, vertical, count, then (tile, palette) cells
_MapCells:
 rep #$30
.a16
.i16
 ldx _map_src
 lda a:0,x
 pha
 and #$00FF
 sta cx
 pla
 xba
 and #$00FF
 sta cy
 lda a:2,x
 pha
 and #$00FF
 sta step ; vertical
 pla
 xba
 and #$00FF
 sta cn
 txa
 clc
 adc #4
 sta src
@cell:
 ldx src
 lda a:0,x
 inx
 inx
 stx src
 tay
 lda _map_mode
 and #HIRES
 bne @hires
 ; 256x224: the cell's VRAM word, its address in the 64x32 map
 lda cy
 and #31
 asl
 asl
 asl
 asl
 asl
 sta ht
 lda cx
 and #32
 beq @first
 lda #$400
@first:
 ora ht
 sta ht
 lda cx
 and #31
 ora ht
 ora #$1000
 sta ht
 tya
 and #$FF00
 asl
 asl
 sta tmp ; palette << 10
 tya
 and #$00FF
 ora tmp
 jsr Queue
 bra @next
@hires: ; the GB's cell, then its entry unless the next cell is the other half of it
 lda cx
 asl
 sta tmp
 lda cy
 xba
 ora tmp
 tax
 tya
 sta f:CELLS,x
 lda cn
 dec
 beq @update
 lda step
 bne @update
 lda cx
 lsr
 bcc @next
@update:
 jsr Update
 jsr Poll
@next:
 lda step
 beq @east
 lda cy
 inc
 and #63
 sta cy
 bra @count
@east:
 lda cx
 inc
 and #127
 sta cx
@count:
 dec cn
 beq Done
 jmp @cell
Done:
 jsr Flush
 sep #$30
.a8
.i8
 rts

.a16
.i16
Poll: ; Capture between cells, keeping the registers
 pha
 phx
 phy
 jsr _Capture
 ply
 plx
 pla
 rts

; hi-res entry (cx >> 1, cy) from its two cells: the pair they make, found or made, its entries counted
Update:
 lda cy
 xba
 sta tmp
 lda cx
 and #$7E
 asl
 ora tmp
 tax ; the left cell
 lda f:CELLS,x
 sta k0
 lda f:CELLS+2,x
 sta k1
 lda cy
 xba
 lsr
 sta tmp
 lda cx
 and #$7E
 ora tmp
 tax ; the entry
 phx
 lda ENTRY,x
 and #$03FF
 beq @found_old
 tax
 dec REF,x
 bne @found_old
 jsr PaletteOf
 dec cgref,x
@found_old:
 jsr Lookup
 bpl @have
 jsr Alloc
 txa
 beq @word
@have:
 lda REF,x
 bne @counted
 phx
 jsr PaletteOf
 inc cgref,x
 plx
@counted:
 inc REF,x
 txa
 ora PCG,x
@word:
 plx
 cmp ENTRY,x
 beq @same
 sta ENTRY,x
 pha
 txa ; the entry's VRAM word: $3000, (x & 32) << 5, (y & 32) << 6, (y & 31) << 5, x & 31
 lsr
 sta tmp
 and #$001F
 sta ht
 lda tmp
 and #$0020
 asl
 asl
 asl
 asl
 asl
 ora ht
 sta ht
 lda tmp
 and #$07C0
 lsr
 ora ht
 sta ht
 lda tmp
 and #$0800
 ora ht
 ora #$3000
 sta ht
 pla
 jmp Queue
@same:
 rts

; A a VRAM word for address ht: queued for the next Flush
Queue:
 pha
 lda queued
 cmp #QUEUE
 bcc @room
 jsr Flush
@room:
 ldy queued
 lda ht
 sta _shade,y
 pla
 sta _shade+2,y
 iny
 iny
 iny
 iny
 sty queued
 rts

PaletteOf: ; X = a pair: X = its palette's cgref offset
 lda PCG,x
 xba
 and #$00FF
 lsr
 tax
 rts

; k0, k1's pair: X, else negative
Lookup:
 lda k0
 sta hk
 lda k1
 jsr Hash
 ldx BUCKET,y
@chain:
 bmi @done
 lda K0,x
 cmp k0
 bne @next
 lda K1,x
 cmp k1
 beq @done
@next:
 lda NEXT,x
 tax
 bra @chain
@done:
 txa
 rts

; hk the left cell, A the right: Y its chain
Hash:
 asl
 eor hk
 sta ht
 xba
 and #$00FF
 asl
 asl
 asl
 eor ht
 and #$007F
 asl
 tay
 rts

; X a pair to forget: out of its chain, unused
Unlink:
 lda K0,x
 sta hk
 lda K1,x
 jsr Hash
 txa
 cmp BUCKET,y
 bne @find
 lda NEXT,x
 sta BUCKET,y
 bra @gone
@find:
 lda BUCKET,y
@walk:
 tay
 txa
 cmp NEXT,y
 beq @link
 lda NEXT,y
 bra @walk
@link:
 lda NEXT,x
 sta NEXT,y
@gone:
 lda #$FFFF
 sta K0,x
 rts

; a new pair for k0, k1: X (0 if there's no palette or pair for it: the blank one)
Alloc:
 jsr PaletteFor
 bcs @none
 ldx hand
 ldy #PAIRS / 2
@search:
 inx
 inx
 cpx #PAIRS
 bcc @in
 ldx #2
@in:
 lda REF,x
 beq @free
 dey
 bne @search
@none:
 ldx #0
 rts
@free:
 stx hand
 lda K0,x
 bmi @unused
 jsr Unlink
@unused:
 lda want ; PaletteFor's palette
 xba
 asl
 asl
 sta PCG,x
 lda k0
 sta K0,x
 sta hk
 lda k1
 sta K1,x
 jsr Hash
 lda BUCKET,y
 sta NEXT,x
 txa
 sta BUCKET,y
 ; its tiles: the GB's planes 0-1, its palette's slot in planes 2-3
; X a pair's first tile: its tiles from k0's and k1's in the raster (slots sl, sr), for the next Flush
Stage:
 lda staged
 cmp #STAGE * 2
 bcc @stage
 phx
 jsr Flush
 plx
@stage:
 ldy staged
 txa
 sta stage,y
 iny
 iny
 sty staged
 dey
 dey
 tya
 asl
 asl
 asl
 asl
 asl
 tay ; 64 bytes a pair
 phx
 lda k0
 ldx sl
 jsr Tile
 lda k1
 ldx sr
 jsr Tile
 plx
 rts

; A a cell, X its slot: 32 bytes to the raster at Y
Tile:
 phx
 and #$00FF
 asl
 asl
 asl
 asl
 tax
 lda #8
 sta tmp
@low:
 lda GBT,x
 sta _raster,y
 inx
 inx
 iny
 iny
 dec tmp
 bne @low
 plx
 lda f:$7F0000+Slots,x
 ldx #8
@high:
 sta _raster,y
 iny
 iny
 dex
 bne @high
 rts
Slots: .word 0, $00FF, $FF00, $FFFF ; planes 2-3 for slots 0-3 (by slot * 2)

; a CGRAM palette with k0's and k1's GB palettes: want, their slots (* 2) sl and sr; carry if none. The
; fewest new slots first; else a palette no pair uses, emptied (the pairs keeping it forgotten)
PaletteFor:
 lda k0
 xba
 and #$00FF
 sta pl
 lda k1
 xba
 and #$00FF
 sta pr
 stz need
@pass:
 ldx #7
@palette:
 jsr Fit
 lda tmp ; new slots
 cmp need
 bne @next
 cmp free
 beq @take
 bcc @take
@next:
 dex
 bne @palette
 inc need
 lda need
 cmp #3
 bne @pass
 ldx #7 ; none fits: empty one no pair uses
@unused:
 txa
 asl
 tay
 lda cgref,y
 beq @empty
 dex
 bne @unused
 sec
 rts
@empty:
 stx want
 txa
 asl
 asl
 tay
 lda #$FFFF
 sta cgs+1,y ; (slots 1-3; byte 0 is unused)
 sta cgs+2,y
 lda want
 xba
 asl
 asl
 sta tmp
 ldx #2
@forget:
 lda K0,x
 bmi @kept
 lda PCG,x
 cmp tmp
 bne @kept
 jsr Unlink
@kept:
 inx
 inx
 cpx #PAIRS
 bne @forget
 ldx want
 jsr Fit
@take:
 stx want
 lda sl
 bne @left
 lda pl
 jsr Add
 sta sl
@left:
 lda sr
 bne @done
 lda pr
 cmp pl
 bne @right
 lda sl
 bra @same
@right:
 jsr Add
@same:
 sta sr
@done:
 clc
 rts

; palette X: sl, sr (slot * 2, 0 if not there), free slots, tmp the slots pl and pr would need
Fit:
 stz sl
 stz sr
 stz free
 txa
 asl
 asl
 tay
 lda #2
 sta tmp
@slot:
 iny
 lda cgs,y
 and #$00FF
 cmp #$00FF
 bne @used
 inc free
@used:
 cmp pl
 bne @l
 pha
 lda tmp
 sta sl
 pla
@l:
 cmp pr
 bne @r
 lda tmp
 sta sr
@r:
 inc tmp
 inc tmp
 lda tmp
 cmp #8
 bne @slot
 lda #0
 ldy sl
 bne @hasl
 inc a
@hasl:
 ldy sr
 bne @need
 ldy pr
 cpy pl
 beq @need
 inc a
@need:
 sta tmp
 rts

; palette want: A's GB palette in its first free slot: A = the slot (* 2)
Add:
 pha
 lda want
 asl
 asl
 tay
 ldx #2
@slot:
 iny
 lda cgs,y
 and #$00FF
 cmp #$00FF
 beq @put
 inx
 inx
 cpx #8
 bne @slot
@put:
 sep #$20
.a8
 pla
 sta cgs,y
 pla
 lda #1
 sta cgdirty
 rep #$20
.a16
 txa
 rts

; the staged pairs, the palettes, the queued entries: to VRAM and CGRAM in a VBlank
Flush:
 lda staged
 ora queued
 beq @done
 sep #$30
.a8
.i8
 jsr _WaitBlank
 lda #$80
 sta f:$002115
 lda #1
 sta f:$004310
 lda #$18
 sta f:$004311
 lda #$7E
 sta f:$004314
 rep #$30
.a16
.i16
 ldy #0
 lda #_raster
 sta f:$004312
@pair:
 cpy staged
 beq @colors
 lda stage,y
 asl
 asl
 asl
 asl
 sta f:$002116
 lda #64
 sta f:$004315
 sep #$20
.a8
 lda #2
 sta f:$00420B ; (the source address goes on to the next pair's)
 rep #$20
.a16
 iny
 iny
 bra @pair
@colors:
 sep #$30
.a8
.i8
 lda cgdirty
 beq @entries
 jsr Colors5
@entries:
 rep #$30
.a16
.i16
 ldx #0
@entry:
 cpx queued
 beq @flushed
 lda _shade,x
 sta f:$002116
 lda _shade+2,x
 sta f:$002118
 inx
 inx
 inx
 inx
 bra @entry
@flushed:
 stz staged
 stz queued
@done:
 rts

.a8
.i8
; the map's palettes to CGRAM, in a VBlank: 256x224 GB palette p at p*16+4; 512x448 each slot's
_MapColors:
 jsr _WaitBlank
 lda _map_mode
 and #HIRES
 bne Colors5
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
Colors5: ; slot s of palette c (cgs[c * 4 + s]) at CGRAM (c * 4 + s) * 4
 stz cgdirty
 ldx #4
@slot:
 txa
 and #3
 beq @next
 lda cgs,x
 cmp #$FF
 beq @next
 asl
 asl
 asl
 tay
 txa
 asl
 asl
 sta f:$002121
 lda #8
 sta tmp
@color:
 lda _map_colors,y
 sta f:$002122
 iny
 dec tmp
 bne @color
@next:
 inx
 cpx #32
 bne @slot
 rts

; a frame of the scroll: half the way to the latest MAP_SCROLL (the last pixel whole), in the map's
; wrap (256x224: 512x256 pixels, 512x448: 1024x512)
_MapGlide:
 rep #$30
.a16
.i16
 ldx #0
 lda _map_mode
 and #HIRES
 beq @lo
 ldx #4
@lo:
 lda _map_tx
 sec
 sbc _map_x
 jsr Half
 clc
 adc _map_x
 and f:$7F0000+Wraps,x
 sta _map_x
 inx
 inx
 lda _map_ty
 sec
 sbc _map_y
 jsr Half
 clc
 adc _map_y
 and f:$7F0000+Wraps,x
 sta _map_y
 sep #$30
.a8
.i8
 bra _MapScroll
.a16
Half: ; A the way in the wrap X: signed half of it, or all of it under 2
 and f:$7F0000+Wraps,x
 sta tmp
 lda f:$7F0000+Wraps,x
 lsr
 cmp tmp
 lda tmp
 bcs @ahead
 sec
 sbc f:$7F0000+Wraps,x
 dec
@ahead:
 cmp #$8000
 ror
 bne @half
 lda tmp
@half:
 rts
Wraps: .word 511, 255, 1023, 511

.a8
; BG1's scroll: map_x, map_y (vertical by a line, 512x448 two: like the text's); 512x448's horizontal
; scroll counts 2 pixels
_MapScroll:
 jsr _WaitBlank
 rep #$20
.a16
 lda _map_mode
 and #HIRES
 beq @lo
 lda _map_x
 lsr
 sta tmp
 lda _map_y
 dec
 bra @set
@lo:
 lda _map_x
 sta tmp
 lda _map_y
@set:
 dec
 sep #$20
.a8
 sta f:$00210E
 xba
 sta f:$00210E
 lda tmp
 sta f:$00210D
 lda tmp+1
 sta f:$00210D
 rts
