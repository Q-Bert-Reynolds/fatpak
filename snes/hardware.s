; Native 65816 hardware boundary for a cc65 6502-compatible protocol/model core.
; C runs with M=1, X=1, D=0, DBR=$7E, PBR=$7F. No SNES CPU is emulated here.
.setcpu "65816"
.export Entry, Nmi, Irq, _WaitBlank, Fonts
.export __STARTUP__ : absolute = 1
.export _Capture, _Snapshot, _FontByte, _ClearRaster, _PpuInit
.export _PresentRow, _PresentPalette, _PresentCursor, _SetScroll, _PublishMailbox
.import _main, zerobss
.importzp sp
.import __RODATA_LOAD__, __RODATA_RUN__, __RODATA_SIZE__
.import __DATA_LOAD__, __DATA_RUN__, __DATA_SIZE__
.import _capture_ready, _capture_last, _capture_rows, _capture_missed, _tick
.import _pad_held, _pad_edges, _raster, _shade, _mailbox, _palette
.import _cursor_row, _cursor_x, _cursor_look
.segment "STARTUP"
.a8
.i8
Entry:
 jml $7F0000+Boot
 jml $7F0000+Nmi
 jml $7F0000+Irq
Boot:
 sei
 clc
 xce
 rep #$30
.a16
.i16
 lda #$1FFF
 tcs
 lda #0
 tcd
 sep #$20
.a8
 lda #$7E
 pha
 plb
 lda #0
 sta f:$004200
 sta f:$00420C
 ldx #0
@rodata:
 cpx #__RODATA_SIZE__
 bcs @dataStart
 lda f:$7F0000+__RODATA_LOAD__,x
 sta __RODATA_RUN__,x
 inx
 bra @rodata
@dataStart:
 ldx #0
@data:
 cpx #__DATA_SIZE__
 bcs @copied
 lda f:$7F0000+__DATA_LOAD__,x
 sta __DATA_RUN__,x
 inx
 bra @data
@copied:
 sep #$30
.a8
.i8
 lda #$FF
 sta sp
 lda #$BF
 sta sp+1
 jsr zerobss
 lda #$FF
 sta _capture_last
 lda #0
 sta $1000 ; last VBlank flag
 sta $1001 ; joypad sample pending
 jsr _PpuInit
 lda #$B1
 sta f:$006003
 lda #1
 sta f:$004200 ; automatic joypad polling, no NMI/IRQ/HDMA
 jsr _main
@stop:
 bra @stop
Nmi:
 rti
Irq:
 rti

.segment "CODE"
; Capture is polled between bounded pieces of parsing/raster work. DMA reads
; completed ICD2 rows into $7E:C000..D03F, with no software/emulator replies.
.a8
.i8
_Capture:
 php
 rep #$10
.i16
 sep #$20
.a8
 lda f:$004212
 and #$80
 cmp $1000
 beq @joy
 sta $1000
 beq @joy
 rep #$20
.a16
 inc _tick
 sep #$20
.a8
 lda #1
 sta $1001
@joy:
 lda $1001
 beq @row
 lda f:$004212
 and #1
 bne @row
 stz $1001
 rep #$20
.a16
 lda f:$004218
 pha
 lda _pad_held
 eor #$FFFF
 sta $1002
 pla
 pha
 and $1002
 ora _pad_edges
 sta _pad_edges
 pla
 sta _pad_held
 lda _pad_held+2
 eor #$FFFF
 sta $1002
 lda f:$00421A
 pha
 and $1002
 ora _pad_edges+2
 sta _pad_edges+2
 pla
 sta _pad_held+2
 sep #$20
.a8
@row:
 lda f:$006000
 cmp _capture_last
 bne @changed
 plp
 rts
@changed:
 sta $1012 ; latest ICD2 status, retained until all completed buffers drained
 sta $1011 ; work status, row number plus write-buffer index
 lda #1
 sta $1010 ; number of rows to drain
 lda _capture_last
 cmp #$FF
 beq @drain
 and #$F8
 lsr
 lsr
 lsr
 sta $1013
 lda $1012
 and #$F8
 lsr
 lsr
 lsr
 sec
 sbc $1013
 bcs @distance
 clc
 adc #18
@distance:
 beq @drain
 cmp #5
 bcc @count
 ; Only four row buffers survive. Record the actual number lost.
 sec
 sbc #4
 rep #$20
.a16
 and #255
 clc
 adc _capture_missed
 sta _capture_missed
 sep #$20
.a8
 lda #4
@count:
 sta $1010
@rewind:
 dec
 beq @drain
 pha
 lda $1011
 and #3
 dec
 and #3
 sta $1013
 lda $1011
 and #$F8
 sec
 sbc #8
 bcs @rewound
 lda #$88
@rewound:
 ora $1013
 sta $1011
 pla
 bra @rewind
@drain:
 lda $1011
 and #$F8
 bne @nonzeroRow
 jmp @skipRow
@nonzeroRow:
 cmp #$70
 bcc @validRow
 jmp @skipRow
@validRow:
 lsr
 lsr
 rep #$20
.a16
 and #$00FF
 tax
 lda f:$7F0000+RowDest-2,x
 sta f:$002181
 sep #$20
.a8
 lda #0
 sta f:$002183
 lda $1011
 dec
 and #3
 sta f:$006001

 lda #8
 sta f:$004300
 lda #$80
 sta f:$004301
 ldy #$7800
 sty $1006
 lda #0
 sta f:$004304
 ; STY far is unavailable: use a 16-bit accumulator for DMA pointer/count.
 rep #$20
.a16
 lda #$7800
 sta f:$004302
 lda #320
 sta f:$004305
 sep #$20
.a8
 lda #1
 sta f:$00420B
 rep #$20
.a16
 inc _capture_rows
 sep #$20
.a8
 cpx #12
 bne @b
 lda _capture_ready
 ora #1
 sta _capture_ready
@b:
 cpx #24
 bne @skipRow
 lda _capture_ready
 ora #2
 sta _capture_ready
@skipRow:
 dec $1010
 beq @done
 lda $1011
 and #3
 inc
 and #3
 sta $1013
 lda $1011
 and #$F8
 clc
 adc #8
 cmp #$90
 bcc @advanced
 lda #0
@advanced:
 ora $1013
 sta $1011
 jmp @drain
@done:
 lda $1012
 sta _capture_last
 plp
 rts
RowDest:
 .repeat 13,I
 .word $C000+I*320
 .endrepeat

; Stable snapshot: copy one row at a time and service capture between rows.
.a8
.i8
_Snapshot:
 sta $100A
 php
 rep #$30
.a16
.i16
 ldx #$C000
 lda $100A
 and #$FF
 beq @source
 ldx #$C780
@source:
 ldy #$D100
 sep #$20
.a8
 lda #6
 sta $100B
@part:
 rep #$30
.a16
.i16
 lda #319
 mvn #$7E,#$7E
 phx
 phy
 sep #$30
.a8
.i8
 jsr _Capture
 rep #$10
.i16
 ply
 plx
 dec $100B
 bne @part
 plp
 rts
.a8
.i8
_FontByte:
 sta $E0
 stx $E1
 php
 rep #$10
.i16
 ldx $E0
 lda f:$7F0000+Fonts,x
 plp
 rts

.a8
.i8
_ClearRaster:
 lda #<_raster
 sta $E4
 lda #>_raster
 sta $E5
 lda #4
 sta $1118
 jsr ZeroPages
 lda #<_shade
 sta $E4
 lda #>_shade
 sta $E5
 lda #8
 sta $1118
ZeroPages:
 ldy #0
 lda #0
@byte:
 sta ($E4),y
 iny
 bne @byte
 inc $E5
 jsr _Capture
 dec $1118
 bne ZeroPages
 rts

.a8
.i8
_PpuInit:
 lda #$80
 sta f:$002100
 lda #0
 sta f:$00212C
 sta f:$00212D
 sta f:$00212E
 sta f:$00212F
 sta f:$002130
 sta f:$002131
 sta f:$002133
 lda #1
 sta f:$002105
 lda #$70 ; BG1 map at byte $E000, tile data at $0000
 sta f:$002107
 lda #0
 sta f:$00210B
 lda #4 ; BG3 tile data at byte $8000, its map at byte $E800
 sta f:$00210C
 lda #$74
 sta f:$002109
 lda #3 ; OBJ tile base byte $C000
 sta f:$002101
 lda #0
 sta f:$00210D
 sta f:$00210D
 lda #$FF
 sta f:$00210E
 sta f:$00210E
 lda #$80
 sta f:$002115
 rep #$20
.a16
 lda #0
 sta f:$002116
 sep #$20
.a8
 stz $100C
 lda #9 ; fixed source, transfer mode 1
 sta f:$004310
 lda #$18
 sta f:$004311
 rep #$20
.a16
 lda #$100C
 sta f:$004312
 lda #0
 sta f:$004315 ; 65536 bytes clear VRAM
 sep #$20
.a8
 lda #$7E
 sta f:$004314
 lda #2
 sta f:$00420B
 ; Identity BG1 map: each physical ring row has its own 32 tiles.
 rep #$30
.a16
.i16
 lda #$7000
 sta f:$002116
 ldx #0
@map:
 txa
 sta f:$002118
 inx
 cpx #1024
 bne @map
 ; One cursor tile: color 1 in the left column.
 lda #$6000
 sta f:$002116
 ldx #0
 lda #$0080
@cursorLow:
 sta f:$002118
 inx
 cpx #8
 bne @cursorLow
 ldx #0
 lda #0
@cursorHigh:
 sta f:$002118
 inx
 cpx #8
 bne @cursorHigh
 sep #$30
.a8
.i8
 jsr _PresentPalette
 jsr _PresentCursor
 lda #$11
 sta f:$00212C
 lda #$0F
 sta f:$002100
 rts

.a8
.i8
_WaitBlank:
 jsr _Capture
 lda f:$004212
 bmi _WaitBlank
@next:
 jsr _Capture
 lda f:$004212
 bpl @next
 rts

; Wait for VBlank while servicing ICD2, then DMA one 1KiB ring row.
.a8
.i8
_PresentRow:
 sta $100D
 jsr _WaitBlank
 lda #$80
 sta f:$002115
 rep #$20
.a16
 lda $100D
 and #$00FF
 xba
 asl
 sta f:$002116
 lda #_raster
 sta f:$004312
 lda #1024
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
.a8
.i8
_PresentPalette:
 lda #0
 sta f:$002121
 lda #0
 sta f:$004310
 lda #$22
 sta f:$004311
 rep #$20
.a16
 lda #_palette
 sta f:$004312
 lda #32
 sta f:$004315
 sep #$20
.a8
 lda #$7E
 sta f:$004314
 lda #2
 sta f:$00420B
 lda #129
 sta f:$002121
 lda _palette+6
 sta f:$002122
 lda _palette+7
 sta f:$002122
 lda #113
 sta f:$002121
 lda _palette
 sta f:$002122
 lda _palette+1
 sta f:$002122
 lda #145
 sta f:$002121
 lda #$FF
 sta f:$002122
 lda #$7F
 sta f:$002122
 rts
.a8
.i8
_PresentCursor:
 lda #0
 sta f:$002102
 sta f:$002103
 ldx #0
@hide:
 lda #0
 sta f:$002104
 lda #$F0
 sta f:$002104
 lda #0
 sta f:$002104
 sta f:$002104
 inx
 cpx #128
 bne @hide
 ldx #32
@high:
 sta f:$002104
 dex
 bne @high
 lda #0
 sta f:$002102
 sta f:$002103
 lda _cursor_x
 sta f:$002104
 lda _cursor_row
 asl
 asl
 asl
 ldx _cursor_look
 bne @visible
 lda #$F0
@visible:
 sta f:$002104
 lda #0
 sta f:$002104
 lda #$30
 cpx #2
 bne @normal
 ora #2
@normal:
 sta f:$002104
 rts
.a8
.i8
_SetScroll:
 sta f:$00210E
 txa
 sta f:$00210E
 rts
.a8
.i8
_PublishMailbox:
 lda _mailbox
 ora #$80
 sta f:$006004
 lda _mailbox+1
 sta f:$006005
 lda _mailbox+2
 sta f:$006006
 lda _mailbox+3
 sta f:$006007
 lda _mailbox
 sta f:$006004
 rts

.segment "FONTS"
Fonts:
 .incbin "build/sgb/fonts.bin"
