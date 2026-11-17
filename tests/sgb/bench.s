; Phase 0b. Poll LCD rows, DMA finished buffers to WRAM and validate in small
; slices so checksum work never starves capture. No BIOS or P1 packets remain.
.setcpu "65816"
.segment "CODE"
.export Entry, Nmi
Frames=$1000
Good=$1002
Bad=$1004
Miss=$1006
Rows=$1008
Ready=$100a
Last=$100b
Pending=$100c
Active=$100d
Page=$100e
Ptr=$1010
Sum=$1012
Seq=$1014
LastGood=$1016
HexValue=$1018
.a8
.i8
Entry:
 sei
 clc
 xce
 rep #$30
.a16
.i16
 lda #$1fff
 tcs
 lda #0
 tcd
 sep #$20
.a8
 pha
 plb
 sta $4200
 sta $420c
 lda #$80
 sta $2100
 ldx #$30
 lda #0
@clear:
 sta $1000-1,x
 dex
 bne @clear
 rep #$20
.a16
 ldx #$1000
@ramWrite:
 txa
 eor #$5a5a
 sta f:$7f0000,x
 inx
 inx
 bne @ramWrite
 ldx #$1000
@ramRead:
 txa
 eor #$5a5a
 cmp f:$7f0000,x
 bne @ramBad
 inx
 inx
 bne @ramRead
 bra @ramDone
@ramBad:
 lda #1
 sta $1026
@ramDone:
 sep #$20
.a8
 lda #$ff
 sta Last
 lda #0
 sta $212c
 sta $212d
 sta $212e
 sta $212f
 sta $2130
 sta $2131
 sta $2133
 sta $2105
 sta $210b
 sta $210d
 sta $210d
 lda #$ff
 sta $210e
 sta $210e
 lda #$10
 sta $2107
 lda #$80
 sta $2115
 ldx #0
 stx $2116
 lda #1
 sta $4310
 lda #$18
 sta $4311
 ldx #.loword(Font)
 stx $4312
 lda #$7f
 sta $4314
 ldx #1024
 stx $4315
 lda #2
 sta $420b
 ldx #$1000
 stx $2116
 ldx #1024
 lda #0
@map:
 sta $2118
 sta $2119
 dex
 bne @map
 ldx #$1000
 stx $2116
 ldx #0
@labels:
 lda f:Screen,x
 sta $2118
 lda #0
 sta $2119
 inx
 cpx #26*32
 bne @labels
 lda #0
 sta $2121
 ; Dark paper, two dim shades, white ink (same 2bpp font as GB UI).
 lda #$00
 sta $2122
 lda #$10
 sta $2122
 lda #$10
 sta $2122
 lda #$42
 sta $2122
 lda #$18
 sta $2122
 lda #$63
 sta $2122
 lda #$ff
 sta $2122
 lda #$7f
 sta $2122
 lda #1
 sta $212c
 lda #$b1
 sta $6003
 lda #$a5
 sta $6004
 lda #0
 sta $6005
 sta $6006
 sta $6007
 lda #$0f
 sta $2100
 lda #$80
 sta $4200
Main:
 jsr Capture
 jsr Validate
 bra Main
Capture:
 lda f:$006000
 cmp Last
 bne @changed
 rts
@changed:
 pha
 and #$f8
 sta $1020
 lda $1020
 cmp #8
 bcc @first
 cmp #$70
 bcs @first
 lda Last
 cmp #$ff
 beq @first
 and #$f8
 clc
 adc #8
 cmp #$90
 bcc @expected
 lda #0
@expected:
 cmp $1020
 beq @first
 rep #$20
.a16
 inc Miss
 sep #$20
.a8
@first:
 pla
 sta Last
 pha
 and #$f8
 beq @discard
 cmp #$70
 bcc @capture
@discard:
 pla
 rts
@capture:
 ; Current row 1..13 means a finished transport/status row 0..12.
 lsr
 lsr
 rep #$20
.a16
 and #$00ff                 ; TAX copies hidden B even with 8-bit A
 tax
 jsr AbortCapture
 lda f:RowDest-2,x
 sta $2181
 sep #$20
.a8
 lda #1
 sta $2183
 pla
 dec
 and #3
 sta $6001
 lda #8
 sta $4300
 lda #$80
 sta $4301
 ldy #$7800
 sty $4302
 lda #0
 sta $4304
 ldy #320
 sty $4305
 lda #1
 sta $420b
 rep #$20
.a16
 inc Rows
 sep #$20
.a8
 cpx #12
 beq @pageA
 cpx #24
 beq @pageB
 cpx #26
 bne @done
 lda f:$7f2f00
 cmp #$53
 bne @done
 lda Ready
 bne @done
 inc Ready
 rep #$20
.a16
 lda #0
 sta Miss
 sta Rows
 sep #$20
.a8
 bra @done
@pageA:
 lda Pending
 ora #1
 sta Pending
 bra @done
@pageB:
 lda Pending
 ora #2
 sta Pending
 bra @done
@done:
 rts
; If a validator ever runs into the following capture of its own page,
; abandon it rather than summing two different SNES capture generations.
.a16
AbortCapture:
 lda Active
 and #$00ff
 beq @done
 cpx #2
 bne @b
 lda Page
 and #$00ff
 beq @abort
 rts
@b:
 cpx #14
 bne @done
 lda Page
 and #$00ff
 cmp #1
 bne @done
@abort:
 lda #0
 sep #$20
.a8
 sta Active
 rep #$20
.a16
 inc Miss
@done:
 rts
.a8
Validate:
 lda Active
 bne @slice
 lda Pending
 bne @pending
 rts
@pending:
 and #1
 bne @a
 lda #1
 sta Page
 lda Pending
 and #$fd
 sta Pending
 ldx #1920
 ldy #3838
 sty $101e
 bra @start
@a:
 lda #0
 sta Page
 lda Pending
 and #$fe
 sta Pending
 ldx #0
 ldy #1918
 sty $101e
@start:
 lda f:$7f2000,x
 beq @done
 sta Seq
 ldy Page
 cmp LastGood,y
 beq @done
 rep #$20
.a16
 lda f:$7f2002,x
 cmp #1914
 bne @invalid
 stx Ptr
 lda #0
 sta Sum
 sep #$20
.a8
 lda #1
 sta Active
@slice:
 rep #$20
.a16
 ldx Ptr
 ldy #32
 lda Sum
@word:
 clc
 adc f:$7f2000,x
 inx
 inx
 cpx $101e
 beq @check
 dey
 bne @word
 stx Ptr
 sta Sum
 sep #$20
.a8
@done:
 rts
@invalid:
 sep #$20
.a8
 rts
@check:
 cmp f:$7f2000,x
 sep #$20
.a8
 bne @bad
 rep #$20
.a16
 inc Good
 sep #$20
.a8
 ldy Page
 lda Seq
 sta LastGood,y
 lda #1
 bra @publish
@bad:
 rep #$20
.a16
 inc Bad
 sep #$20
.a8
 lda #2
@publish:
 sta $1028
 lda Seq
 sta $1029
 lda $1028
 pha
 lda Seq
 ora #$80
 sta $6005
 lda Page
 sta $6006
 pla
 sta $6007
 lda Seq
 sta $6005
 lda #0
 sta Active
 rts
Nmi:
 php
 rep #$30
.a16
.i16
 pha
 phx
 phy
 inc Frames
 ; Keep metric drawing out of the transport rows. Polling continues during
 ; active rows; the unused tail gives this occasional display update slack.
 sep #$20
.a8
 lda f:$006000
 and #$f8
 cmp #$68
 bcc @skipDraw
 cmp #$80
 bcc @draw
@skipDraw:
 jmp @exit
@draw:
 rep #$20
.a16
 ; Draw only short numeric fields during VBlank. Capture DMA uses channel 0,
 ; WRAM port $2180; these VRAM writes cannot disturb it.
 lda f:$7f2f00
 and #$00ff
 cmp #$53
 beq @status
 jmp @noStatus
@status:
 lda f:$7f2f00
 xba
 and #$00ff
 ldx #$1074
 jsr Hex
 lda f:$7f2f02
 ldx #$1114
 jsr Hex
 lda f:$7f2f0a
 ldx #$1134
 jsr Hex
 lda f:$7f2f0c
 ldx #$1154
 jsr Hex
 lda f:$7f2f08
 ldx #$1174
 jsr Hex
 lda f:$7f2f06
 ldx #$1194
 jsr Hex
 lda f:$7f2f0e
 xba
 and #$00ff
 ldx #$11b4
 jsr Hex
 lda f:$7f2f10
 xba
 ldx #$11f4
 jsr Hex
 lda f:$7f2f12
 and #$00ff
 ldx #$1214
 jsr Hex
 lda f:$7f2f13
 xba
 ldx #$1234
 jsr Hex
 lda f:$7f2f15
 xba
 ldx #$1254
 jsr Hex
 ; The slow scan runs only after a bounded timeout; it must not affect the
 ; throughput measurements or turn the failed ACK into a successful reply.
 lda f:$7f2f00
 xba
 and #$00ff
 cmp #$e1
 bcc @noStatus
 lda f:$7f2f18
 xba
 ldx #$12d4
 jsr Hex
 lda f:$7f2f1a
 xba
 ldx #$12f4
 jsr Hex
 lda f:$7f2f1c
 xba
 ldx #$1314
 jsr Hex
 lda f:$7f2f1e
 xba
 ldx #$1334
 jsr Hex
@noStatus:
 lda $1028
 ldx #$1274
 jsr Hex
 lda $1026
 ldx #$11d4
 jsr Hex
 lda Good
 ldx #$1094
 jsr Hex
 lda Bad
 ldx #$10b4
 jsr Hex
 lda Miss
 ldx #$10d4
 jsr Hex
 lda Rows
 ldx #$10f4
 jsr Hex
@exit:
 rep #$30
 ply
 plx
 pla
 plp
 rti
.a16
Hex:
 sta HexValue
 stx $2116
 sep #$20
.a8
 lda HexValue+1
 lsr
 lsr
 lsr
 lsr
 jsr Digit
 lda HexValue+1
 jsr Digit
 lda HexValue
 lsr
 lsr
 lsr
 lsr
 jsr Digit
 lda HexValue
 jsr Digit
 rep #$20
.a16
 rts
.a8
Digit:
 and #15
 cmp #10
 bcc @decimal
 clc
 adc #7
@decimal:
 clc
 adc #16
 sta $2118
 lda #0
 sta $2119
 rts
RowDest:
 .repeat 13,I
 .word $2000+320*I
 .endrepeat
Font: .incbin "img/ui_font.tiles",512,1024
Screen: .incbin "build/sgb/bench.screen"
