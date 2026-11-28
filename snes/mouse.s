; The SNES mouse in port 2 (resident part: segment RES, run at $7E:A000, copied there by Boot). Capture calls
; MouseRead each frame once automatic reading is done: the mouse's signature in JOY2, its remaining 16 bits
; (Y then X motion, sign and magnitude) clocked from $4017, a pointer in 256x224 pixels (512x448 text uses the
; same space), and its events at the input queue's tail as the protocol has them: DOWN or UP when buttons change,
; DRAG with a button held, MOVE without; motion coalesced into the tail event of the same kind and buttons.
; A = (buttons << SGBFS_MOUSE_BUTTON_SHIFT) | row (y / 8, or y / 4 in TEXT 1's 56 rows), B = x. PresentCursor
; calls FarPointer in VBlank: the arrow (OBJ tile 2, palette 2: black outline, white) as OAM entry 1, and with it
; the view's scroll bar (SCROLLBAR, kernel.c's scroll_bar): its thumb as entry 2, its track as entries 3 on.
.setcpu "65816"
.include "protocol.inc"
.export MouseRead, FarPointer, FarHide, HdmaMap
.export MouseX, MouseY ; (tests/sgb/mouse.lua)
.import _scroll_bar, _text_mode, _cursor_dirty, _queue, _qhead, _qcount, _active_event, _hw_frames

QUEUE_MASK = SGBFS_INPUT_QUEUE - 1
RESERVE = 4 ; (kernel.c's PAD_QUEUE_RESERVE: room kept for pad releases)
POINTER_TILE = $6020 ; VRAM word: OBJ tile 2 (the cursor's is 0, 512x448's 1)

.segment "RES"
MouseX: .byte 128
MouseY: .byte 112
Buttons: .byte 0
Shown: .byte 0 ; 1 once the mouse has moved or clicked, 0 when it's gone
Motion: .word 0 ; Y motion (high byte), X (low)
Limit: .byte 0
Read: .word $FFFF ; the NMI frame (_hw_frames) of the last read: a latch's 16 extra bits are there once
Magnitude: .byte 0
Changed: .byte 0
EventType: .byte 0
EventA: .byte 0
New: .byte 0
HdmaMap: .byte 0 ; the HDMA channels map.s has on ($420C is write-only): FarPointer adds its own
Window: .res 3 * 12 ; HDMA 5's table: window 1's left and right a line at a time (FarPointer)
BarY: .byte 0 ; (Bar's) the next track OBJ's top line
BarLeft: .byte 0 ; and the track's lines from there

.a8
.i16
; A: motion (bit 7 negative, bits 0-6 magnitude) onto the coordinate at X, kept to 0-Limit. Changed: nonzero if it moved
Step:
 pha
 and #$7F
 beq @none
 sta Magnitude
 inc Changed
 pla
 bmi @negative
 lda a:0, x
 clc
 adc Magnitude
 bcs @limit
 cmp Limit
 bcc @store
 beq @store
@limit:
 lda Limit
@store:
 sta a:0, x
 rts
@negative:
 lda a:0, x
 sec
 sbc Magnitude
 bcs @store
 lda #0
 bra @store
@none:
 pla
 rts

; From Capture (A8, I16, DBR $7E), JOY2 just read
MouseRead:
 php
 phb ; (Capture is reached with other data banks too: the extension's FarCapture)
 lda #$7E
 pha
 plb
 rep #$20
.a16
 lda _hw_frames
 cmp Read
 sta Read
 sep #$20
.a8
 beq @done ; (Capture's pad sample can come twice a frame; the second would clock past the report)
 lda f:$00421B
 bne @gone
 lda f:$00421A
 and #$0F
 cmp #1 ; the mouse's signature
 beq @mouse
@gone:
 lda Shown
 beq @done
 stz Shown
 lda #1
 sta _cursor_dirty
@done:
 plb
 plp
 rtl
@mouse:
 rep #$20
.a16
 ldy #16
@bit:
 lda f:$004017
 lsr a
 rol Motion
 dey
 bne @bit
 sep #$20
.a8
 stz Changed
 lda #255
 sta Limit
 ldx #MouseX
 lda Motion
 jsr Step
 lda #223
 sta Limit
 ldx #MouseY
 lda Motion + 1
 jsr Step
 ; buttons: JOY2 bit 6 left, 7 right -> left 1, right 2
 lda f:$00421A
 and #$C0
 lsr a
 lsr a
 lsr a
 lsr a
 lsr a
 lsr a
 sta New
 cmp Buttons
 beq @motion
 lda Buttons
 eor #$FF
 and New ; newly pressed: DOWN; else a release: UP
 beq @released
 lda #SGBFS_EVENT_MOUSE_DOWN
 bra @button
@released:
 lda #SGBFS_EVENT_MOUSE_UP
@button:
 sta EventType
 lda New
 sta Buttons
 clc ; (a button's event is never merged)
 bra @event
@motion:
 lda Changed
 beq @done
 lda Buttons
 beq @hover
 lda #SGBFS_EVENT_MOUSE_DRAG
 bra @kind
@hover:
 lda #SGBFS_EVENT_MOUSE_MOVE
@kind:
 sta EventType
 sec
@event:
 php
 lda _text_mode
 bne @cells
 lda MouseY
 lsr a
 lsr a
 lsr a
 bra @row
@cells:
 lda MouseY
 lsr a
 lsr a
@row:
 sta EventA
 lda Buttons
 asl a
 asl a
 asl a
 asl a
 asl a
 asl a
 ora EventA
 sta EventA
 plp
 jsr Queue
 lda #1
 sta Shown
 sta _cursor_dirty
 plb
 plp
 rtl

; The event (EventType, EventA, MouseX) at the queue's tail. Carry: motion, merged into the tail event if it has
; the same kind and buttons and isn't the one being published (the queue's head while active_event)
Queue:
 php
 lda _qcount
 cmp #SGBFS_INPUT_QUEUE - RESERVE
 bcs @full
 plp
 bcc @append
 lda _qcount
 cmp _active_event
 beq @append
 bcc @append
 lda _qhead
 clc
 adc _qcount
 dec a
 and #QUEUE_MASK
 jsr Entry
 lda _queue, x
 cmp EventType
 bne @append
 lda _queue + 1, x
 eor EventA
 and #$C0
 bne @append
 lda EventA
 sta _queue + 1, x
 lda MouseX
 sta _queue + 2, x
 rts
@full:
 plp
 rts
@append:
 lda _qhead
 clc
 adc _qcount
 and #QUEUE_MASK
 jsr Entry
 lda EventType
 sta _queue, x
 lda EventA
 sta _queue + 1, x
 lda MouseX
 sta _queue + 2, x
 inc _qcount
 rts
; A: a queue index; X: its first byte's offset (index * 3)
Entry:
 rep #$20
.a16
 and #$00FF
 sta Motion ; (scratch)
 asl a
 adc Motion
 tax
 sep #$20
.a8
 rts

; From PresentCursor (A8, I8, in VBlank, the OAM address 0): the whole OAM hidden (y 240) and small, x below 256, by
; DMA (channel 1, as PresentPalette's): a CPU loop's 640 writes took a dozen lines of VBlank, the bar's sprites none
FarHide:
 lda #$00 ; one register, $2104
 sta f:$004310
 lda #$04
 sta f:$004311
 lda #$7E
 sta f:$004314
 rep #$20
.a16
 lda #Hidden
 sta f:$004312
 lda #544
 sta f:$004315
 sep #$20
.a8
 lda #2
 sta f:$00420B
 rtl
Hidden:
 .repeat 128
 .byte 0, $F0, 0, 0
 .endrepeat
 .res 32, 0

; From PresentCursor (A8, I8, DBR $7E, in VBlank, after it rewrote the OAM): the pointer, if shown
.i8
FarPointer:
 php
 phb
 lda #$7E
 pha
 plb
 lda Shown
 bne @shown
 jmp @hidden
@shown:
 rep #$10
.i16
 lda #$80
 sta f:$002115
 rep #$20
.a16
 lda #POINTER_TILE
 sta f:$002116
 sep #$20
.a8
 ldx #0
@tile:
 lda Arrow, x
 sta f:$002118
 lda Arrow + 1, x
 sta f:$002119
 inx
 inx
 cpx #32
 bne @tile
 lda #161 ; OBJ palette 2, colours 1 and 2
 sta f:$002121
 lda #0
 sta f:$002122
 sta f:$002122
 lda #$FF
 sta f:$002122
 lda #$7F
 sta f:$002122
 lda #2 ; OAM entry 1
 sta f:$002102
 lda #0
 sta f:$002103
 lda MouseX
 sta f:$002104
 lda MouseY
 dec a ; (an OBJ shows a line below its Y)
 sta f:$002104
 lda #2
 sta f:$002104
 lda #$34 ; priority 3, palette 2
 sta f:$002104
 lda _scroll_bar + 1
 beq @bar
 jsr Bar
@bar:
 ; 256x224's BG3 (menus, boxes, the OSK) is in front of every OBJ (mode 1 with its priority bit): window 1
 ; takes it away under the arrow's pixels, a line at a time (HDMA 5), so the pointer shows over it
 lda _text_mode
 beq @window
 jmp @hidden ; (512x448's text has no BG3)
@window:
 ldx #0
 lda MouseY
@above: ; the lines above the arrow, 127 at most an entry
 beq @arrow
 cmp #128
 bcc @last
 sbc #127
 pha
 lda #127
 jsr Unmasked
 pla
 bra @above
@last:
 jsr Unmasked
@arrow:
 ldy #0
@line:
 lda #1
 sta Window, x
 lda MouseX
 sta Window + 1, x
 clc
 adc Widths, y
 bcc @right
 lda #$FF
@right:
 sta Window + 2, x
 inx
 inx
 inx
 iny
 cpy #8
 bne @line
 lda #1
 jsr Unmasked
 stz Window, x ; the end
 lda #$01 ; HDMA 5: two registers once a line, $2126 and $2127
 sta f:$004350
 lda #$26
 sta f:$004351
 lda #$7E
 sta f:$004354
 rep #$20
.a16
 lda #Window
 sta f:$004352
 sep #$20
.a8
 lda #$02 ; BG3 in window 1
 sta f:$002124
 lda #$04 ; masked on the main screen
 sta f:$00212E
 lda HdmaMap
 ora #$20
 sta f:$00420C
 plb
 plp
 rtl
@hidden:
 lda #0
 sta f:$00212E
 lda HdmaMap
 sta f:$00420C
 plb
 plp
 rtl

; (A8, I16, DBR $7E, the OAM address at entry 2) the scroll bar at the screen's right edge, as the GB's at 160x144
; (src/ui/scrollbar.asm): the thumb (OBJ tile 3, the pointer's palette) 6 pixels wide over the track's 2 pixel line
; (palette 0's colour 1, the cursor's). The track is 32x32 OBJs whose first column alone is on screen (tiles 4,
; 20, 36 and 52), 32 lines apart, the last ending at the track's end: 7 at most, not 28 8x8 ones (VBlank is short)
Bar:
 lda #$01 ; the tiles by DMA (channel 1, as PresentPalette's): VMAIN is the pointer's
 sta f:$004310
 lda #$18
 sta f:$004311
 lda #$7E
 sta f:$004314
 ldx #0
@tile:
 rep #$20
.a16
 lda BarVram, x
 sta f:$002116
 lda BarSource, x
 sta f:$004312
 lda #32
 sta f:$004315
 sep #$20
.a8
 lda #2
 sta f:$00420B
 inx
 inx
 cpx #10
 bne @tile
 lda #256 - 6 ; the thumb
 sta f:$002104
 lda _scroll_bar + 2
 dec a
 sta f:$002104
 lda #3
 sta f:$002104
 lda #$34
 sta f:$002104
 ldy #0 ; the track's OBJs
 lda _scroll_bar
 sta BarY
 lda _scroll_bar + 1
 sta BarLeft
@track:
 lda #256 - 4
 sta f:$002104
 lda BarLeft
 cmp #32
 lda BarY
 bcs @y
 cpy #0
 beq @y
 clc ; the last: 32 lines up from the end
 adc BarLeft
 sec
 sbc #32
@y:
 dec a
 sta f:$002104
 lda #4
 sta f:$002104
 lda #$30 ; priority 3, palette 0
 sta f:$002104
 iny
 lda BarY
 clc
 adc #32
 sta BarY
 lda BarLeft
 sec
 sbc #32
 sta BarLeft
 beq @high
 bcs @track
@high: ; their size bits (large) in the high table, every other entry small as PresentCursor left it
 lda #0
 sta f:$002102
 lda #1
 sta f:$002103
 lda High0, y
 sta f:$002104
 lda High1, y
 sta f:$002104
 lda High2, y
 sta f:$002104
 rts

; by the track's OBJ count (entries 3 on): the high table's bytes for entries 0-3, 4-7 and 8-11
High0: .byte 0, $80, $80, $80, $80, $80, $80, $80
High1: .byte 0, 0, $02, $0A, $2A, $AA, $AA, $AA
High2: .byte 0, 0, 0, 0, 0, 0, $02, $0A
BarVram: .word $6030, $6040, $6140, $6240, $6340 ; OBJ tiles 3, 4, 20, 36, 52
BarSource: .word Thumb, Track, Track, Track, Track

; 4bpp. The thumb: the GB's (the UI font's tile 10), its colours 3 and 1 black (1), 2 white (2)
Thumb:
 .byte %11111100, %00000000
 .byte %10000100, %01111000
 .byte %01111000, %10000100
 .byte %10000100, %01111000
 .byte %11111100, %00000000
 .res 6, 0
 .res 16, 0
; the track's line: pixels 1 and 2 of the 4 on screen, colour 1
Track:
 .repeat 8
 .byte %01100000, 0
 .endrepeat
 .res 16, 0

; A = lines without the window (left 255, right 0: no pixels) at Window + X, X past it
Unmasked:
 sta Window, x
 lda #$FF
 sta Window + 1, x
 stz Window + 2, x
 inx
 inx
 inx
 rts

; the arrow's pixels on each line, less one (Arrow below)
Widths: .byte 0, 1, 2, 3, 4, 5, 3, 1

; 8x8, 4bpp: plane 0 the outline (colour 1), plane 1 the fill (colour 2); hot spot at the top left
Arrow:
 .byte %10000000, %00000000
 .byte %11000000, %00000000
 .byte %10100000, %01000000
 .byte %10010000, %01100000
 .byte %10001000, %01110000
 .byte %10000100, %01111000
 .byte %10110000, %01000000
 .byte %11000000, %00000000
 .res 16, 0
