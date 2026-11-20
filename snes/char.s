; 512x448 text in character tiles (SGBFS_CMD_TEXT 1): mode 5 + interlace, a character an 8x8 hi-res cell, 64
; columns and 56 rows, nothing drawn. Mode 5 shows an entry's tiles N and N+1 side by side, so BG1 has the even
; columns and BG2 the odd ones (scrolled 8 pixels right): each glyph's tile is followed by a blank one, through
; which the other layer shows. A glyph's tile has it in plane 0 on paper in plane 1, so a palette gives a cell
; its paper (colour 2) and ink (3).
;
; Colours: 8 classes (TEXT, DIM, KEYWORD, STRING, NUMBER, LABEL, SELECTED, INVERSE). BG2's 2bpp palette q is
; class q (CGRAM 4q+2, 4q+3). BG1's 4bpp palettes 0 and 1 share those words with BG2's 0 and 4, so BG1 gives
; classes 0 and 4 palettes 0 and 1, and the rest palettes 2-7: one tile set a layer.
;
; VRAM (words): BG1's tiles at $0000 (262 glyphs, each then a blank: 8384 words), BG2's at $3000 (4192), BG1's
; 32x64 map at $4400, BG2's at $4C00 (to $53FF), the cursor's OBJ tile 1 at $6010. All of it is the raster
; ring's and BG3's tiles in 256x224, which leaving gives back (kernel.c draws every row again).
;
; WRAM ($7E): the 56 rows (kernel.c's Row) at $6000, a row's cells at $7E00, the maps as written at $8000 and
; $9000 (64 rows of 32 words each): the row cache's, unused here. A row composes its text (or a bar), the OSK and
; a box into cells, then into both maps' shadows; the rows waiting go to VRAM a batch a VBlank.
;
; Part of the kernel's extension (segment EXT, see map.s); kernel.c only switches to it with the extension
; there, and nothing rebuilds the 4 px cache over it meanwhile. Called from C with 8-bit A and index.
.setcpu "65816"
.smart + ; REP and SEP set the assembler's sizes too
.export FarCharLayer, FarCharRows, FarCharScroll, FarCharColors, FarCharCursor
.import FarWaitBlank, FarCapture, FarProgress, Fonts
.import _rows, _bars, _bar_lines, _box_lines, _box_x, _box_width, _box_top, _box_rows, _box_hi
.import _osk_rows, _osk_layer, _osk_key, _busy, _screen_rows, _ring_offset, _scroll_pending
.import _dirty, _overlay_dirty, _drawn_rows, _palette, _cursor_row, _cursor_x, _cursor_look

ROW = 133       ; sizeof(Row): font, flags, start, end, n, chars[64], attrs[64]
FLAGS = 1
START = 2
END = 3
COUNT = 4
CHARS = 5
ATTRS = 69
ALIGN_RIGHT = 127 ; the rest of an unstyled row against the right edge
COLUMNS = 64
SH1 = $8000     ; BG1's map as written: 64 rows of 32 words
SH2 = $9000     ; BG2's
GLYPHS = $8000  ; while CharLayer builds the tiles: the mono font, then the frame pieces
CG = $7E00      ; a row's cells: their tile (glyph * 2)
CC = $7E80      ; and colour class
PEND = $7EC0    ; map rows written in the shadows but not in VRAM yet
SPACE = ' ' * 2
HLINE = 512     ; the frame pieces' tiles: glyphs 256-261
VLINE = 514
TOPLEFT = 516
TOPRIGHT = 518
BOTLEFT = 520
BOTRIGHT = 522
GLYPH_COUNT = 262
TEXT = 0
SELECTED = 6
INVERSE = 7
MAP1 = $4400    ; VRAM words
MAP2 = $4C00
TILES2 = $3000
CURSOR = $6010
BATCH = 8       ; map rows a VBlank at most (two 64-byte DMAs each), each only while it lasts
OSK_ROWS = 5
OSK_PANEL = 7   ; its rows with the frame
OSK_LEFT = 11   ; the panel's columns (kernel.c's pixels / 4)
OSK_RIGHT = 52
OSK_KEYS = 13
OSK_CAPS = 3
ICON_CAPS = 25

.segment "BSS"
crow: .res 2    ; the row composing
cend: .res 2    ; Put's: past its last column
prog: .res 2    ; the progress bar's columns
pptr: .res 2
pcls: .res 2
pflags: .res 2
pn: .res 2
pi: .res 2
px: .res 2
pk: .res 2
pc: .res 2
tmp: .res 2
tmp2: .res 2
tmp3: .res 2
rel: .res 2
left: .res 2
right: .res 2
batch: .res 2

.segment "EXT"
.a8
.i8

FarCharLayer:
 jsr CharLayer
 rtl
FarCharRows:
 php
 jsr CharRows
 plp
 rtl
FarCharScroll:
 jsl $7F0000+FarWaitBlank
 jsr Vofs
 rtl
FarCharColors:
 php
 jsr CharColors
 plp
 rtl
FarCharCursor:
 jsr CharCursor
 rtl

; A = 1: mode 5 with the font's tiles, the maps blank (spaces); 0: 256x224's registers again
CharLayer:
 pha
 jsl $7F0000+FarWaitBlank
 pla
 bne @on
 lda #$70 ; BG1's map at byte $E000, BG2's at $F000, its tiles at $C000
 sta f:$002107
 lda #$78
 sta f:$002108
 lda #$60
 sta f:$00210B
 lda #0
 sta f:$002133
 sta f:$00212D
 sta f:$00420C
 sta f:$00210D
 sta f:$00210D
 sta f:$00210F
 sta f:$00210F
 lda #$FF
 sta f:$002110
 sta f:$002110
 lda #9
 sta f:$002105
 lda #$17
 sta f:$00212C
 rts
@on:
 lda #$80
 sta f:$002100 ; forced blank: several frames of tiles
 sta f:$002115
 lda #5
 sta f:$002105
 lda #$30 ; BG1's tiles at word 0, BG2's at $3000
 sta f:$00210B
 lda #(MAP1 >> 8) | 2 ; 32x64
 sta f:$002107
 lda #(MAP2 >> 8) | 2
 sta f:$002108
 lda #1
 sta f:$002133 ; interlace: 448 lines
 lda #$13 ; BG1, BG2, OBJ on both screens (hi-res takes alternate pixels from each)
 sta f:$00212C
 sta f:$00212D
 lda #0
 sta f:$00420C
 sta f:$00210D
 sta f:$00210D
 lda #$FC ; BG2 8 hi-res pixels right
 sta f:$00210F
 lda #3
 sta f:$00210F
 stz _ring_offset
 jsr Vofs
 rep #$30
.a16
.i16
 ldx #Fonts ; the mono font (font 0) and the frame pieces, together
 ldy #GLYPHS
 lda #2047
 mvn #$7F, #$7E
 ldx #Frames
 ldy #GLYPHS + 2048
 lda #(GLYPH_COUNT - 256) * 8 - 1
 mvn #$7E, #$7E
 lda #0
 sta f:$002116
 sep #$20
.a8
 ldx #0
@bg1: ; 4bpp: the glyph on paper, planes 2-3 clear, then the blank tile
 ldy #8
@bg1row:
 lda GLYPHS,x
 sta f:$002118
 lda #$FF
 sta f:$002119
 inx
 dey
 bne @bg1row
 ldy #24
 lda #0
@bg1zero:
 sta f:$002118
 sta f:$002119
 dey
 bne @bg1zero
 jsr Poll
 cpx #GLYPH_COUNT * 8
 bne @bg1
 rep #$20
 lda #TILES2
 sta f:$002116
 sep #$20
 ldx #0
@bg2: ; 2bpp
 ldy #8
@bg2row:
 lda GLYPHS,x
 sta f:$002118
 lda #$FF
 sta f:$002119
 inx
 dey
 bne @bg2row
 ldy #8
 lda #0
@bg2zero:
 sta f:$002118
 sta f:$002119
 dey
 bne @bg2zero
 jsr Poll
 cpx #GLYPH_COUNT * 8
 bne @bg2
 rep #$20
.a16
 lda #CURSOR ; half the raster's: 4 lines (8 hi-res ones) of colour 1 in the left column
 sta f:$002116
 ldx #4
 lda #$0080
@cursor:
 sta f:$002118
 dex
 bne @cursor
 ldx #12
 lda #0
@cursorClear:
 sta f:$002118
 dex
 bne @cursorClear
 lda #MAP1 ; both maps and their shadows (each pair contiguous): spaces in TEXT's palettes
 sta f:$002116
 ldx #0
@maps:
 lda #SPACE
 sta f:$002118
 sta SH1,x
 inx
 inx
 txa
 and #$01FE
 bne @maps1
 jsr Poll
@maps1:
 cpx #$2000
 bne @maps
 ldx #COLUMNS - 2
@pending:
 stz PEND,x
 dex
 dex
 bpl @pending
 sep #$30
.a8
.i8
 jsl $7F0000+FarWaitBlank
 lda #$0F
 sta f:$002100
 rts

; BG1's and BG2's vertical scroll: the ring's first row at the top (interlaced: hi-res lines, the same 2 lines
; above as MapScroll's)
.a8
Vofs:
 rep #$20
.a16
 lda _ring_offset
 and #$003F
 asl
 asl
 asl
 dec
 dec
 and #$03FF
 sep #$20
.a8
 sta f:$00210E
 xba
 sta f:$00210E
 xba
 sta f:$002110
 xba
 sta f:$002110
 rts

; Capture between pieces of work, keeping every register
Poll:
 php
 rep #$30
 pha
 phx
 phy
 jsl $7F0000+FarCapture
 ply
 plx
 pla
 plp
 rts

; Every row marked (dirty or overlay_dirty) composed into the shadows, then to VRAM
.a8
.i8
CharRows:
 jsl $7F0000+FarProgress ; progress_width(): 0-256 pixels
 sta prog
 stx prog + 1
 rep #$30
.a16
.i16
 lsr prog
 lsr prog
 stz crow
 sep #$20
.a8
@row:
 ldx crow
 lda _dirty,x
 ora _overlay_dirty,x
 beq @next
 stz _dirty,x
 stz _overlay_dirty,x
 jsr Compose
 jsr Emit
 rep #$20
 inc _drawn_rows
 sep #$20
 jsr Poll
@next:
 inc crow
 lda crow
 cmp _screen_rows
 bcc @row
 jmp Flush

; crow's cells: its text (or a bar), the OSK over it, a box over that, the busy and progress marks
.a8
.i16
Compose:
 lda #63
 sta cend
 stz cend + 1
 lda crow
 bne @footer
 lda _bars
 lsr
 bcc @text
 ldx #_bar_lines
 bra @bar
@footer:
 inc a
 cmp _screen_rows
 bne @text
 lda _bars
 and #2
 beq @text
 ldx #_bar_lines + ROW
@bar:
 phx
 lda #SELECTED
 jsr Blank
 plx
 lda #SELECTED
 ldy #0
 jsr Put
 bra @ui
@text:
 lda #TEXT
 jsr Blank
 rep #$20
.a16
 lda crow ; rows + crow * 133
 asl
 asl
 sta tmp
 xba
 lsr
 lsr
 lsr
 clc
 adc tmp
 adc crow
 adc _rows
 tax
 sep #$20
.a8
 phx
 lda #TEXT
 ldy #0
 jsr Put
 plx
 jsr Select
@ui:
 jsr Osk
 jsr Box
 lda crow
 bne @progress
 lda _busy
 beq @progress
 lda #INVERSE
 sta CC + 63
 rep #$20
 lda #SPACE
 sta CG + 126
 sep #$20
@progress:
 lda crow
 inc a
 cmp _screen_rows
 bne @done
 ldx #0
@bar1:
 cpx prog
 bcs @done
 lda #INVERSE
 sta CC,x
 inx
 bra @bar1
@done:
 rts

; every cell a space in class A
Blank:
 ldx #COLUMNS - 1
@class:
 sta CC,x
 dex
 bpl @class
 rep #$20
.a16
 lda #SPACE
 ldx #COLUMNS * 2 - 2
@tile:
 sta CG,x
 dex
 dex
 bpl @tile
 sep #$20
.a8
 rts

; Row X's characters from column Y up to cend, a character a column, in class A (a styled row: its styles'):
; ALIGN_RIGHT in an unstyled row puts what follows it, less trailing spaces, against cend
Put:
 sta pcls
 stx pptr
 sty px
 lda a:COUNT,x
 sta pn
 stz pn + 1
 lda a:FLAGS,x
 sta pflags
 stz pi
 stz pi + 1
 stz pc + 1
@loop:
 ldy pi
 cpy pn
 bcs @done
 ldy px
 cpy cend
 bcs @done
 rep #$20
.a16
 lda pptr
 clc
 adc pi
 tax
 sep #$20
.a8
 lda a:CHARS,x
 sta pc
 lda pflags
 bne @styled
 lda pc
 cmp #ALIGN_RIGHT
 beq @right
 lda pcls
 bra @put
@styled:
 lda a:ATTRS,x
 lsr
 lsr
 lsr
 lsr
 rep #$20
.a16
 and #$000F
 tax
 sep #$20
.a8
 lda StyleClass,x
@put:
 ldy px
 sta CC,y
 rep #$20
.a16
 tya
 asl
 tax
 lda pc
 asl
 sta CG,x
 inc px
 inc pi
 sep #$20
.a8
 bra @loop
@done:
 rts
.a8
@right: ; past a run of them, then count the rest less trailing spaces
 ldy pi
 iny
 cpy pn
 bcs @counted
 lda a:CHARS + 1,x
 cmp #ALIGN_RIGHT
 bne @counted
 inx
 sty pi
 bra @right
@counted:
 rep #$20
.a16
 lda pn
 sta pk
@trim:
 ldy pk
 dey
 cpy pi ; k - 1 > i
 beq @trimmed
 bcc @trimmed
 tya
 clc
 adc pptr
 tax
 sep #$20
.a8
 lda a:CHARS,x
 cmp #' '
 rep #$20
.a16
 bne @trimmed
 sty pk
 bra @trim
@trimmed:
 lda pk ; cend - (k - i - 1), not left of px
 sec
 sbc pi
 dec
 sta tmp
 lda cend
 sec
 sbc tmp
 bmi @clamp
 cmp px
 bcs @x
@clamp:
 lda px
@x:
 sta px
 inc pi
 sep #$20
.a8
 jmp @loop

; row X's selection: its columns (end 255: to the right edge) in SELECTED
Select:
 lda a:START,x
 cmp a:END,x
 beq @none
 sta tmp
 stz tmp + 1
 lda a:END,x
 cmp #255
 bne @end
 lda #COLUMNS
@end:
 sta tmp2
 stz tmp2 + 1
 ldx tmp
 lda #SELECTED
@cell:
 cpx tmp2
 bcs @none
 sta CC,x
 inx
 bra @cell
@none:
 rts

; columns X up to Y (past the last) spaces in class TEXT, X kept
Clear:
 phx
@cell:
 lda #TEXT
 sta CC,x
 rep #$20
.a16
 txa
 asl
 tax
 lda #SPACE
 sta CG,x
 txa
 lsr
 tax
 inx
 sep #$20
.a8
 sty tmp3
 cpx tmp3
 bcc @cell
 plx
 rts

; a frame row from column left to right: corners A (left, its right one + 2), lines between where the cell is a
; space
FrameRow:
 rep #$20
.a16
 and #$00FF
 ora #$0200
 sta tmp
 lda left
 asl
 tax
 lda tmp
 sta CG,x
 lda right
 asl
 tay
 lda tmp
 inc
 inc
 sta CG,y
@line:
 inx
 inx
 stx tmp
 cpy tmp
 beq @done
 lda CG,x
 cmp #SPACE
 bne @line
 lda #HLINE
 sta CG,x
 bra @line
@done:
 sep #$20
.a8
 rts

; the on-screen keyboard's panel: columns 11-52 of its 7 rows above the footer
Osk:
 lda _osk_rows
 beq @none
 lda _bars
 and #2
 beq @footer
 lda #1
@footer:
 eor #$FF ; screen_rows - footer - 7
 sec
 adc _screen_rows
 sec
 sbc #OSK_PANEL
 sta tmp
 lda crow
 sec
 sbc tmp
 bcc @none
 cmp #OSK_PANEL
 bcc @mine
@none:
 rts
@mine:
 sta rel
 stz rel + 1
 lda #OSK_LEFT
 sta left
 stz left + 1
 lda #OSK_RIGHT
 sta right
 stz right + 1
 ldx #OSK_LEFT
 ldy #OSK_RIGHT + 1
 jsr Clear
 lda rel
 bne @notTop
 lda #<TOPLEFT
 jmp FrameRow
@notTop:
 cmp #OSK_PANEL - 1
 bne @keys
 lda #<BOTLEFT
 jmp FrameRow
@keys:
 rep #$20
.a16
 lda #VLINE
 sta CG + OSK_LEFT * 2
 sta CG + OSK_RIGHT * 2
 sep #$20
.a8
 lda rel
 dec a
 sta rel
 cmp #OSK_ROWS - 1
 beq @bottom
 lda _osk_layer ; caps lock shows the shift layer
 cmp #OSK_CAPS
 bne @layer
 lda #1
@layer:
 asl ; layer * 40 + row * 10
 asl
 asl
 sta tmp
 asl
 asl
 clc
 adc tmp
 sta tmp
 lda rel
 asl
 sta tmp2
 asl
 asl
 clc
 adc tmp2
 clc
 adc tmp
 rep #$20
.a16
 and #$00FF
 tax
 ldy #OSK_KEYS * 2
@key:
 lda Keys,x
 and #$00FF
 beq @skip
 asl
 sta CG,y
@skip:
 inx
 tya
 clc
 adc #8 ; 4 columns a key
 tay
 cpy #(OSK_KEYS + 40) * 2
 bcc @key
 sep #$20
.a8
 bra @hi
@bottom:
 rep #$20
.a16
 ldx #0
 ldy #OSK_KEYS * 2
@icon:
 lda Bottom,x
 and #$00FF
 asl
 sta CG,y
 iny
 iny
 iny
 iny
 inx
 cpx #20
 bne @icon
 sep #$20
.a8
 lda _osk_layer
 cmp #OSK_CAPS
 bne @hi
 rep #$20
 lda #ICON_CAPS * 2
 sta CG + OSK_KEYS * 2
 sep #$20
@hi: ; the chosen key: its cell and the next in SELECTED
 lda _osk_key
 cmp #255
 beq @done
 ldx #0
@tens:
 cmp #10
 bcc @row
 sbc #10
 inx
 bra @tens
@row:
 cpx rel
 bne @done
 asl
 asl
 clc
 adc #OSK_KEYS
 rep #$20
.a16
 and #$00FF
 tax
 sep #$20
.a8
 lda #SELECTED
 sta CC,x
 sta CC + 1,x
@done:
 rts

; the box: its frame in cells, its line from the column after the left one up to the right one
Box:
 rep #$20
.a16
 lda _box_width
 sep #$20
.a8
 beq @none
 lda crow
 sec
 sbc _box_top
 bcc @none
 cmp _box_rows
 bcc @mine
@none:
 rts
@mine:
 sta rel
 stz rel + 1
 lda _box_x
 lsr
 lsr
 sta left
 stz left + 1
 rep #$20
.a16
 lda _box_x
 and #$00FF
 clc
 adc _box_width
 lsr
 lsr
 dec
 sta right
 sep #$20
.a8
 ldx left
 ldy right
 iny
 jsr Clear
 rep #$20
.a16
 lda left
 asl
 tax
 lda #VLINE
 sta CG,x
 lda right
 sta cend
 asl
 tax
 lda #VLINE
 sta CG,x
 lda rel ; the line: box_lines + rel * 133
 asl
 asl
 sta tmp
 xba
 lsr
 lsr
 lsr
 clc
 adc tmp
 adc rel
 adc #_box_lines
 tax
 ldy left
 iny
 sep #$20
.a8
 lda #TEXT
 jsr Put
 lda rel
 bne @notTop
 lda #<TOPLEFT
 jsr FrameRow
 lda rel
@notTop:
 inc a
 cmp _box_rows
 bne @hi
 lda #<BOTLEFT
 jsr FrameRow
@hi:
 lda rel
 cmp _box_hi
 bne @done
 ldx left
 lda #SELECTED
@sel:
 sta CC,x
 inx
 cpx right
 bcc @sel
 beq @sel
@done:
 rts

; crow's cells into both shadows at its ring row, which then waits for VRAM
.a8
.i16
Emit:
 lda crow
 clc
 adc _ring_offset
 and #63
 rep #$20
.a16
 and #$00FF
 tax
 sep #$20
.a8
 lda #1
 sta PEND,x
 rep #$20
.a16
 txa
 xba
 lsr
 lsr
 tay ; the shadow row's offset: m * 64
 ldx #0
@pair: ; X = the even column's class index
 phx
 lda CC,x ; low: the even column's class, high: the odd one's
 sta tmp
 and #$00FF
 asl
 tax
 lda Bg1Palette,x
 sta tmp2
 lda tmp
 xba
 and #$00FF
 asl
 tax
 lda Bg2Palette,x
 sta tmp3
 plx
 phx
 txa
 asl
 tax
 lda CG,x
 ora tmp2
 sta SH1,y
 lda CG + 2,x
 ora tmp3
 sta SH2,y
 plx
 iny
 iny
 inx
 inx
 cpx #COLUMNS
 bne @pair
 sep #$20
.a8
 rts

; the map rows waiting, up to BATCH a VBlank, then a SCROLL's new position in the last
Flush:
 lda #$80
 sta f:$002115
@batch:
 ldx #COLUMNS - 1
@any:
 lda PEND,x
 bne @wait
 dex
 bpl @any
 lda _scroll_pending
 beq @end
 jsl $7F0000+FarWaitBlank
 bra @scroll
@wait:
 jsl $7F0000+FarWaitBlank
 lda #BATCH
 sta batch
 ldx #0
@scan:
 lda PEND,x
 beq @skip
 lda f:$004212 ; still in the VBlank? (WaitBlank's Capture can take some of it)
 bpl @batch
 stz PEND,x
 jsr Dma
 dec batch
 beq @batch
@skip:
 inx
 cpx #COLUMNS
 bne @scan
 lda _scroll_pending
 beq @end
 lda f:$004212
 bmi @scroll
 jsl $7F0000+FarWaitBlank
@scroll:
 stz _scroll_pending
 jsr Vofs
@end:
 rts

; map row X from both shadows to VRAM
Dma:
 lda #1
 sta f:$004310
 lda #$18
 sta f:$004311
 lda #$7E
 sta f:$004314
 rep #$20
.a16
 txa
 asl
 asl
 asl
 asl
 asl
 sta tmp ; m * 32: the row's first word in either map
 clc
 adc #MAP1
 sta f:$002116
 lda tmp
 asl
 clc
 adc #SH1
 sta f:$004312
 lda #64
 sta f:$004315
 sep #$20
.a8
 lda #2
 sta f:$00420B
 rep #$20
.a16
 lda tmp
 clc
 adc #MAP2
 sta f:$002116
 lda tmp
 asl
 clc
 adc #SH2
 sta f:$004312
 lda #64
 sta f:$004315
 sep #$20
.a8
 lda #2
 sta f:$00420B
 rts

; the classes' paper and ink (palette entries) into CGRAM: BG2's palettes and BG1's (in a VBlank)
.a8
CharColors:
 rep #$10
.i16
 ldx #0
@class:
 txa
 asl
 asl
 ora #2
 sta f:$002121
 jsr Pair
 lda Bg1Number,x
 asl
 asl
 asl
 asl
 ora #2
 sta f:$002121
 jsr Pair
 inx
 cpx #8
 bne @class
 rts
Pair: ; class X's paper and ink
 phx
 lda Paper,x
 jsr Color
 plx
 phx
 lda Ink,x
 jsr Color
 plx
 rts
Color: ; palette entry A
 asl
 rep #$20
.a16
 and #$00FF
 tax
 sep #$20
.a8
 lda _palette,x
 sta f:$002122
 lda _palette + 1,x
 sta f:$002122
 rts

; after PresentCursor: OAM entry 0 again, a row 4 lines (8 hi-res ones) and its 4-line tile
.a8
.i8
CharCursor:
 lda #0
 sta f:$002102
 sta f:$002103
 lda _cursor_x
 sta f:$002104
 lda _cursor_look
 beq @hide
 lda _cursor_row
 asl
 asl
 bra @y
@hide:
 lda #$F0
@y:
 sta f:$002104
 lda #1
 sta f:$002104
 lda _cursor_look
 cmp #2
 lda #$30
 bcc @look
 ora #2 ; white: OBJ palette 1
@look:
 sta f:$002104
 rts

; the frame pieces (glyphs 256-261): horizontal, vertical, the corners top left, top right, bottom left, right
Frames:
 .byte 0, 0, 0, $FF, 0, 0, 0, 0
 .byte $10, $10, $10, $10, $10, $10, $10, $10
 .byte 0, 0, 0, $1F, $10, $10, $10, $10
 .byte 0, 0, 0, $F0, $10, $10, $10, $10
 .byte $10, $10, $10, $1F, 0, 0, 0, 0
 .byte $10, $10, $10, $F0, 0, 0, 0, 0
; a style's class (constants.h's STYLE_*): bold and italics plain, headings, keywords and types KEYWORD
StyleClass:
 .byte 0, 0, 0, 0, 1, 3, 2, 2, 1, 2, 2, 3, 4, 5, 5, 0
; a class's BG1 palette (0 and 4 the ones BG2 shares), as map bits; BG2's is the class
Bg1Number:
 .byte 0, 2, 3, 4, 1, 5, 6, 7
Bg1Palette:
 .word 0 << 10, 2 << 10, 3 << 10, 4 << 10, 1 << 10, 5 << 10, 6 << 10, 7 << 10
Bg2Palette:
 .word 0 << 10, 1 << 10, 2 << 10, 3 << 10, 4 << 10, 5 << 10, 6 << 10, 7 << 10
; a class's paper and ink: palette entries (kernel.c's: paper, selection, dim, text, keyword, string, number,
; label)
Paper:
 .byte 0, 0, 0, 0, 0, 0, 1, 3
Ink:
 .byte 3, 2, 4, 5, 6, 7, 3, 0
; the keyboard's layers (kernel.c's draw_ui: plain, shift, symbols), 4 rows of 10, and its bottom row
Keys:
 .byte "1234567890qwertyuiopasdfghjkl;zxcvbnm,./"
 .byte "!@#$%^&*()QWERTYUIOPASDFGHJKL:ZXCVBNM<>?"
 .byte "`~-_=+[]{}", $5C, "|'", $22, $A1, $BF, $E1, $E9, $ED, $F3, $FA, $F1, $FC
 .res 17
Bottom:
 .byte 29, ' ', '#', ' ', 31, ' ', '_', '_', '_', '_', '_', '_', '_', '_', 15, ' ', 16, ' ', 30, ' '
