; Shared completed 4bpp tiles. General glyphs use exact bitmap comparison;
; fixed code text can publish directly while its compositor owns the key.
; Live VRAM IDs are reference counted and never evicted by lookup collisions.
; $7E:A000..A7FF refs, A800..AFFF map, B000..B3FF owners, B400..B4FF index,
; B500..B57F work, B580..B67F fixed IDs, F000..FFFF bitmap lookup cache.
; Software stack: B680..BFFF. Existing unselected row/font caches stay intact.
.setcpu "65816"
.macpack longbranch
.export _SharedInit, _SharedBeginRow, _SharedFixedTile, _SharedFixedEnd, _SharedFixedReuse
.export _PresentRow, _SharedPrepared, _SharedCommitted
.import _raster, _Capture, _WaitBlank
.import _PresentRasterRow
.import _shared_hits, _shared_misses, _shared_hint_hits, _shared_reused_blank
.import _shared_tile_bytes, _shared_map_bytes, _fixed_hints, _fixed_direct
.ifndef SHARED_RENDER
.segment "CODE"
_SharedInit:
_SharedBeginRow:
_SharedFixedTile:
_SharedFixedEnd:
_SharedFixedReuse:
_SharedPrepared:
_SharedCommitted:
 rts
_PresentRow:
 jmp _PresentRasterRow
.else
REFS = $A000
MAP = $A800
OWNER = $B000
INDEX = $B400
CURSOR = $B500
SOURCE = $B502
MAPROW = $B504
HASH = $B506
TILE = $B508
COLUMN = $B50A
TEMP = $B50C
WORK = $B510
BLANK = $B512
FIXED = $B514
MISSES = $B516
UPLOADS = $B540
FIXEDIDS = $B580
BITS = $F000
.segment "CODE"
.a8
.i8
_SharedInit:
 php
 rep #$30
.a16
.i16
 ldx #0
 lda #0
@clear:
 sta REFS,x
 sta MAP,x
 inx
 inx
 cpx #2048
 bne @clear
 lda #1024
 sta REFS
 ldx #0
 lda #$FFFF
@index:
 sta INDEX,x
 sta FIXEDIDS,x
 inx
 inx
 cpx #256
 bne @index
 stz CURSOR
 stz BLANK
 sep #$20
.a8
 stz _fixed_hints
 stz _fixed_direct
 plp
 rts

; A = physical row. Old VRAM remains intact until the atomic VBlank commit.
_SharedBeginRow:
 php
 rep #$30
.a16
.i16
 and #255
 asl
 asl
 asl
 asl
 asl
 asl
 sta MAPROW
 tax
 ldy #32
@release:
 lda MAP,x
 asl
 phx
 tax
 dec REFS,x
 plx
 inx
 inx
 dey
 bne @release
 stz SOURCE
 stz COLUMN
 stz WORK
 stz MISSES
 plp
 rts

; 16-bit internal helpers. Releasing a row guarantees room for all 32 new
; tiles, even when every one of the map's 1024 entries is different.
.a16
.i16
Allocate:
 ldx CURSOR
@free:
 lda REFS,x
 beq @found
 inx
 inx
 txa
 and #2047
 tax
 and #63
 bne @free
 phx
 sep #$30
.a8
.i8
 jsr _Capture
 rep #$30
.a16
.i16
 plx
 bra @free
@found:
 txa
 lsr
 sta TILE
 cmp BLANK
 bne :+
 lda #$FFFF
 sta BLANK
:
 inx
 inx
 txa
 and #2047
 sta CURSOR
 ldx COLUMN
 lda TILE
 sta UPLOADS,x
 inc _shared_misses
 inc MISSES
 lda WORK
 ora #1
 sta WORK
 rts

Retain:
 lda TILE
 asl
 tax
 inc REFS,x
 lda MAPROW
 clc
 adc COLUMN
 tax
 lda TILE
 cmp MAP,x
 beq :+
 pha
 lda WORK
 ora #2
 sta WORK
 pla
:
 sta MAP,x
 lda SOURCE
 clc
 adc #32
 sta SOURCE
 inc COLUMN
 inc COLUMN
 rts

Hit:
 sta TILE
 ldx COLUMN
 lda #$FFFF
 sta UPLOADS,x
 inc _shared_hits
 rts

Paper:
 lda BLANK
 cmp #$FFFF
 beq @new
 jsr Hit
 jmp Retain
@new:
 jsr Allocate
 lda TILE
 sta BLANK
 tax
 sep #$20
.a8
 stz OWNER,x
 rep #$20
.a16
 ; Slot ownership invalidates old fixed keys; invalidate the generic index
 ; too, since paper needs no backup bitmap in the lookup cache.
 lda #$FFFF
 sta INDEX
 jmp Retain

; Called immediately after composing a fixed tile, before another key can
; replace it. This avoids a raster re-hash and a second copy of the key.
.a8
.i8
_SharedFixedTile:
 php
 rep #$30
.a16
.i16
 lda $1180
 ora $1182
 ora $1184
 bne @ink
 jsr Paper
 bra @done
@ink:
 sep #$20
.a8
 jsr _SharedFixedReuse
 cmp #0
 rep #$20
.a16
 bne @done
 jsr Allocate
 ldx FIXED
 lda TILE
 sta FIXEDIDS,x
 tax
 lda FIXED
 lsr
 ora #128
 sep #$20
.a8
 sta OWNER,x
 rep #$20
.a16
 jsr Retain
@done:
 plp
 rts

; A cached glyph needs neither a raster copy nor another bitmap lookup.
.a8
.i8
_SharedFixedReuse:
 php
 rep #$30
.a16
.i16
 lda $119C
 lsr
 lsr
 sta FIXED
 tax
 lda FIXEDIDS,x
 cmp #$FFFF
 beq @miss
 sta TILE
 tax
 lda FIXED
 lsr
 ora #128
 sep #$20
.a8
 cmp OWNER,x
 rep #$20
.a16
 bne @miss
 lda TILE
 jsr Hit
 inc _shared_hint_hits
 jsr Retain
 plp
.a8
 lda #1
 rts
@miss:
.a16
 plp
.a8
 lda #0
 rts

.a8
.i8
_SharedFixedEnd:
 php
 rep #$30
.a16
.i16
@tail:
 lda COLUMN
 cmp #64
 bcs @done
 jsr Paper
 sep #$30
.a8
.i8
 jsr _Capture
 rep #$30
.a16
.i16
 bra @tail
@done:
 sep #$20
.a8
 lda #2
 sta _fixed_hints
 stz _fixed_direct
 plp
 rts

.a16
.i16
HashTile:
 ldx SOURCE
 lda #$1234
 .repeat 16,I
 asl
 adc _raster+I*2,x
 .endrepeat
 sta TEMP
 xba
 eor TEMP
 and #127
 sta HASH
 asl
 tax
 rts

.a8
.i8
_PresentRow:
.ifndef SHARED_RENDER
 jmp _PresentRasterRow
.endif
 php
 rep #$30
.a16
.i16
 pha
 lda _fixed_hints
 and #255
 cmp #2
 bne @general
 pla
 sep #$20
.a8
 stz _fixed_hints
 jmp _SharedPrepared
@general:
.a16
 pla
 jsr _SharedBeginRow
@tile:
 ldx SOURCE
 lda _raster,x
 .repeat 3,I
 ora _raster+2+I*2,x
 .endrepeat
 bne @hashed
 .repeat 12,I
 ora _raster+8+I*2,x
 .endrepeat
 bne @hashed
 jsr Paper
 jmp @next
@hashed:
 jsr HashTile
 lda INDEX,x
 cmp #$FFFF
 jeq @miss
 sta TILE
 tax
 sep #$20
.a8
 lda OWNER,x
 cmp HASH
 rep #$20
.a16
 jne @miss
 lda HASH
 asl
 asl
 asl
 asl
 asl
 tay
 ldx SOURCE
 .repeat 16,I
 lda _raster+I*2,x
 cmp BITS+I*2,y
 jne @miss
 .endrepeat
 lda TILE
 jsr Hit
 jmp @retain
@miss:
 jsr Allocate
 lda HASH
 asl
 tax
 lda TILE
 sta INDEX,x
 tax
 sep #$20
.a8
 lda HASH
 sta OWNER,x
 rep #$20
.a16
 lda HASH
 asl
 asl
 asl
 asl
 asl
 tay
 ldx SOURCE
 .repeat 16,I
 lda _raster+I*2,x
 sta BITS+I*2,y
 .endrepeat
@retain:
 jsr Retain
@next:
 sep #$30
.a8
.i8
 jsr _Capture
 rep #$30
.a16
.i16
 lda COLUMN
 cmp #64
 beq _SharedPrepared
 jmp @tile
_SharedPrepared:
 sep #$30
.a8
.i8
 lda WORK
 bne :+
 jmp _SharedCommitted
:
 ; Only map-only commits reuse blank. Any tile uploads get a fresh VBlank;
 ; even a full 32-tile replacement then fits comfortably in its DMA budget.
 lda MISSES
 bne @wait
 lda f:$004212
 bpl @wait
 lda f:$004213
 and #$80
 beq @wait
 lda f:$00213F
 lda f:$002137
 lda f:$00213D
 sta TEMP
 lda f:$00213D
 and #1
 bne @wait
 lda TEMP
 cmp #225 ; blank may have ended between HVBJOY and the counter latch
 bcc @wait
 ; A map-only DMA needs under two scanlines. Reject counters >=256,
 ; leaving at least six NTSC blank lines; no tile-loop work is needed.
 inc _shared_reused_blank
 bra @blank
@wait:
 jsr _WaitBlank
@blank:
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
 stz SOURCE
 ldx #0
 lda MISSES
 jeq @map
@upload:
 lda UPLOADS,x
 cmp #$FFFF
 beq @next
 asl
 asl
 asl
 asl
 sta f:$002116
 lda SOURCE
 clc
 adc #_raster
 sta f:$004312
 lda #32
 sta f:$004315
 clc
 adc _shared_tile_bytes
 sta _shared_tile_bytes
 bcc :+
 inc _shared_tile_bytes+2
:
 sep #$20
.a8
 lda #2
 sta f:$00420B
 rep #$20
.a16
@next:
 lda SOURCE
 clc
 adc #32
 sta SOURCE
 inx
 inx
 cpx #64
 bne @upload
@map:
 lda WORK
 and #2
 bne :+
 sep #$30
.a8
.i8
 jmp _SharedCommitted
:
.a16
.i16
 lda MAPROW
 lsr
 clc
 adc #$7000
 sta f:$002116
 lda MAPROW
 clc
 adc #MAP
 sta f:$004312
 lda #64
 sta f:$004315
 clc
 adc _shared_map_bytes
 sta _shared_map_bytes
 bcc :+
 inc _shared_map_bytes+2
:
 sep #$20
.a8
 lda #2
 sta f:$00420B
 nop ; DMA completes before the readback checkpoint
_SharedCommitted:
 plp
 rts
.endif
