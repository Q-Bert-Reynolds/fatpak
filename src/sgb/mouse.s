; SNES mouse bridge. Uploaded to the BIOS's documented user RAM at $001800.
; The $0800 command hook installs it once, then restores the hook's RTS.
; BIOS H/V IRQs continue drawing the GB screen; NMI consumes the mouse's
; remaining 16 bits after automatic joypad polling. Controller 1 stays BIOS-owned.
.setcpu "65816"
.segment "CODE"
.a8
.i8
Install:
    jmp BridgeInstall
Stop:
    jmp BridgeStop
BridgeInstall:
    php
    rep #$30
.a16
.i16
    pha
    phx
    phy
    sep #$30
.a8
.i8
    lda #$60
    sta f:$000800
    lda f:$0000bb
    sta f:OldVector
    lda f:$0000bc
    sta f:OldVector+1
    lda f:$0000bd
    sta f:OldVector+2
    lda #<MouseNmi
    sta f:$0000bb
    lda #>MouseNmi
    sta f:$0000bc
    lda #0
    sta f:$0000bd
    sta f:Flags
    sta f:Buttons
    sta f:Connected
    sta f:Head
    sta f:Tail
    sta f:Published
    sta f:$001ff0
    sta f:$006005
    lda #80
    sta f:PosX
    lda #72
    sta f:PosY
    lda #$b1                 ; GB running, clock 1, four input bytes
    sta f:$006003
    lda #$b1                 ; existing H/V IRQ + auto joypad read, add NMI
    sta f:$004200
    rep #$30
.a16
.i16
    ply
    plx
    pla
    plp
    rts
.a8
.i8
BridgeStop:
    php
    pha
    lda #$31
    sta f:$004200
    lda f:OldVector
    sta f:$0000bb
    lda f:OldVector+1
    sta f:$0000bc
    lda f:OldVector+2
    sta f:$0000bd
    lda #$81
    sta f:$006003
    lda #$60
    sta f:$000800
    pla
    plp
    rts
MouseNmi:
    php
    rep #$30
.a16
.i16
    pha
    phx
    phy
    sep #$30
.a8
.i8
    lda f:$001ff0           ; DATA_SND acknowledgement from the GB
    beq NoAck
    lda #0
    sta f:$001ff0
    sta f:Published
    lda f:Head
    cmp f:Tail
    beq NoAck
    clc
    adc #4
    sta f:Head
NoAck:
    lda f:$004210           ; acknowledge NMI
    ldx #32                 ; automatic polling begins shortly after VBlank
Delay:
    dex
    bne Delay
WaitAuto:
    lda f:$004212
    and #1
    bne WaitAuto
    lda f:$00421b           ; first mouse byte must be zero
    beq :+
    jmp Absent
:
    lda f:$00421a
    and #$0f
    cmp #1                  ; mouse signature (ignore sensitivity)
    beq :+
    jmp Absent
:
    lda #1
    sta f:Connected
    lda #0
    sta f:DeltaY
    sta f:DeltaX
    ldx #8
ReadY:
    lda f:$004017
    lsr
    lda f:DeltaY
    rol
    sta f:DeltaY
    dex
    bne ReadY
    ldx #8
ReadX:
    lda f:$004017
    lsr
    lda f:DeltaX
    rol
    sta f:DeltaX
    dex
    bne ReadX
    lda f:$00421a
    asl
    rol                     ; right button into bit 0, left into bit 7
    rol                     ; left into bit 0, right into bit 1
    and #3
    sta f:NewButtons
    cmp f:Buttons
    bne Activity
    lda f:DeltaX
    ora f:DeltaY
    and #$7f                ; sign bits persist even at rest
    bne Activity
    jmp Publish
Activity:
    lda f:NewButtons
    sta f:Buttons
    lda f:PosX
    tay
    lda f:DeltaX
    ldx #159
    jsr Move
    sta f:PosX
    lda f:PosY
    tay
    lda f:DeltaY
    ldx #143
    jsr Move
    sta f:PosY
    lda f:Buttons
    asl
    ora #1
    jmp Enqueue
Absent:
    lda f:Connected
    bne :+
    jmp Publish
:
    lda #0
    sta f:Connected
    sta f:Buttons
Enqueue:
    sta f:ReportFlags
    lda f:Tail
    cmp f:Head
    beq Append
    sec
    sbc #4
    tax
    cmp f:Head
    bne CheckMotion
    lda f:Published
    bne Append             ; never replace the acknowledged/in-flight head
CheckMotion:
    lda f:$001e00,x
    cmp f:ReportFlags
    beq WriteReport        ; coalesce motion, preserve every button edge
Append:
    lda f:Tail
    tax
    txa
    clc
    adc #4
    cmp f:Head
    bne Space
    ; A full queue retains its older edges and replaces the last slot with
    ; the newest state, so a long build cannot leave a button held forever.
    txa
    sec
    sbc #4
    tax
    bra WriteReport
Space:
    sta f:Tail
WriteReport:
    lda f:ReportFlags
    sta f:$001e00,x
    lda f:PosX
    sta f:$001e01,x
    lda f:PosY
    sta f:$001e02,x
Publish:
    lda f:Published
    bne Done
    lda f:Head
    cmp f:Tail
    beq Done
    tax
    lda #$80                ; seqlock: invalidate before publishing position
    sta f:$006005
    lda f:$001e01,x
    sta f:$006006
    lda f:$001e02,x
    sta f:$006007
    jsr Sequence
    lda f:$001e00,x
    ora f:Flags
    sta f:$006005           ; final commit; bit 7 clear
    lda #1
    sta f:Published
Done:
    rep #$30
.a16
.i16
    ply
    plx
    pla
    plp
    rti
.a8
.i8
Sequence:
    lda f:Flags
    clc
    adc #8
    and #$78
    sta f:Flags
    rts
; A = sign/magnitude delta, Y = old coordinate, X = upper bound.
Move:
    sta f:Scratch
    cmp #$80
    bcs Negative
    tya
    clc
    adc f:Scratch
    bcs Maximum
    sta f:Scratch
    txa
    cmp f:Scratch
    bcc Maximum
    lda f:Scratch
    rts
Maximum:
    txa
    rts
Negative:
    and #$7f
    sta f:Scratch
    tya
    sec
    sbc f:Scratch
    bcs Return
    lda #0
Return:
    rts
OldVector: .byte 0,0,0
Flags: .byte 0
Buttons: .byte 0
NewButtons: .byte 0
PosX: .byte 80
PosY: .byte 72
DeltaX: .byte 0
DeltaY: .byte 0
Scratch: .byte 0
Connected: .byte 0
Head: .byte 0
Tail: .byte 0
Published: .byte 0
ReportFlags: .byte 0
.assert * <= $1e00, lderror, "mouse code overlaps report queue"
; $1E00..1EFF: 64 four-byte queue slots (one empty); $1FF0: ack byte.
.export Install, Stop, MouseNmi
