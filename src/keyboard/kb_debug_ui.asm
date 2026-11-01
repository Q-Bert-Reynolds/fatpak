DrawBinaryNumber::;b = number, hl = screen address
  ld c, 8
.loop
    LCD_WAIT_VRAM
    ld a, '1'
    sla b
    jr c, .setBuffer
    ld a, '0'
  .setBuffer
    ld [hli], a
    dec c
    jr nz, .loop
  ret

HexNumbers: DB "0123456789ABCDEF"
DrawHexNumber::;a = number, bc = screen address
  push af;number to draw
  and $F0;upper nibble only
  swap a;(ie. a/16)
  ld hl, HexNumbers
  ld d, 0
  ld e, a
  add hl, de
  LCD_WAIT_VRAM
  ld a, [hl]
  ld [bc], a;upper nibble in first screen address

  inc bc;lower nibble goes in next screen address

  pop af;number to draw
  and $0F;lower nibble only (ie. a%16)
  ld hl, HexNumbers
  ld d, 0
  ld e, a
  add hl, de
  LCD_WAIT_VRAM
  ld a, [hl]
  ld [bc], a

  inc bc;increment screen address so numbers can be drawn sequentially

  ret

;the buffers are shown KB_DEBUG_ENTRIES at a time, an entry always in the same column
DEF KB_DEBUG_ENTRIES EQU 8;must be a power of 2

;returns the first index of the page holding the last entry written in a
KBDebugPage:
  ld a, [kb_buffer_write]
  dec a
  and a, (KB_SCAN_CODE_COUNT-1) & ~(KB_DEBUG_ENTRIES-1)
  ret

;hl = ring buffer (KB_SCAN_CODE_COUNT bytes), bc = screen address, draws the page holding the
;last entry written in hex
DrawBufferPage:
  call KBDebugPage
  ld e, a;index
  ld d, KB_DEBUG_ENTRIES
.loop
    push hl
    push de
    ld a, e
    add a, l
    ld l, a
    adc a, h
    sub a, l
    ld h, a
    ld a, [hl]
    call DrawHexNumber
    pop de
    pop hl
    inc e
    dec d
    jr nz, .loop
  ret

BlankSpace: DB "  ",0
InterruptsText: DB " int ",0
ErrorsText: DB " err",0
ClearedDashesText: DB "_____",0
ShiftText: DB "shift",0

DrawKeyboardDebugData::
  ld a, [kb_type]
  cp a, KB_TYPE_PS2
  jr nz, .drawIGASCII

.drawPS2ASCII
  ld hl, PS2toASCIIKeymap
  ld a, [kb_scan_code]
  ld b, 0
  ld c, a
  add hl, bc
  LCD_WAIT_VRAM
  ld a, [hl]
  ld [_SCRN1], a
  ld a, 'P'
  ld [_SCRN1+2], a
  jr .drawScanCodeHex

.drawIGASCII
  ld a, [kb_scan_code]
  ld [_SCRN1], a
  ld a, 'I'
  ld [_SCRN1+2], a

.drawScanCodeHex
  ld a, [kb_scan_code]
  ld bc, _SCRN1+5
  call DrawHexNumber


.drawScanCodeDecimal
  ld a, [kb_scan_code]
  ld h, 0
  ld l, a
  ld de, str_buffer
  call str_Number
  ld hl, BlankSpace
  ld de, str_buffer
  call str_Append

  ld a, DRAW_FLAGS_WIN
  ld hl, str_buffer
  ld de, $0800
  ld bc, 1
  call DrawText

.drawScanCodeBinary
  ld hl, _SCRN1+12
  ld a, [kb_scan_code]
  ld b, a
  call DrawBinaryNumber

.drawScanCodeBuffer
  LCD_WAIT_VRAM
  ld a, 'S'
  ld [_SCRN1+32], a
  ld hl, kb_scan_code_buffer
  ld bc, _SCRN1+32+2
  call DrawBufferPage

.drawErrorBuffer
  LCD_WAIT_VRAM
  ld a, 'E'
  ld [_SCRN1+32*2], a
  ld hl, kb_error_buffer
  ld bc, _SCRN1+32*2+2
  call DrawBufferPage

.drawWritePosition;arrow under the next entry written, the page's first index on the right
  ld a, ' '
  ld hl, str_buffer
  ld bc, 18
  call mem_Set
  ld a, [kb_buffer_write]
  and a, KB_DEBUG_ENTRIES-1
  add a, a
  add a, 2
  ld e, a
  ld d, 0
  ld hl, str_buffer
  add hl, de
  ld [hl], '<up arrow>'
  ld hl, str_buffer
  ld de, _SCRN1+32*3
  ld bc, 18
  call mem_CopyVRAM
  call KBDebugPage
  ld bc, _SCRN1+32*3+18
  call DrawHexNumber

.drawInterruptCount
  ld a, [kb_interrupt_count]
  ld h, 0
  ld l, a
  ld de, str_buffer
  call str_Number
  ld hl, InterruptsText
  ld de, str_buffer
  call str_Append

.drawError
  ld a, [kb_error_count]
  ld h, 0
  ld l, a
  ld de, name_buffer
  call str_Number
  ld hl, name_buffer
  ld de, str_buffer
  call str_Append
  ld hl, ErrorsText
  ld de, str_buffer
  call str_Append

  ld a, DRAW_FLAGS_WIN
  ld hl, str_buffer
  ld de, 4
  ld bc, 1
  call DrawText

  ld hl, str_buffer
  ld a, [kb_error]
  ld b, a

.testTimeoutError
  bit 5, b
  ld a, 'T'
  jr nz, .drawTimeoutError
.noTimeoutError
  ld a, '-'
.drawTimeoutError
  ld [hli], a

.testUnknownCodeError
  bit 4, b
  ld a, 'U'
  jr nz, .drawUnknownCodeError
.noUnknownCodeError
  ld a, '-'
.drawUnknownCodeError
  ld [hli], a

.testKeyboardError
  bit 3, b
  ld a, 'K'
  jr nz, .drawKeyboardError
.noKeyboardError
  ld a, '-'
.drawKeyboardError
  ld [hli], a

.testStartBitError
  bit 2, b
  ld a, 'S'
  jr nz, .drawStartBitError
.noStartBitError
  ld a, '-'
.drawStartBitError
  ld [hli], a

.testParityBitError
  bit 1, b
  ld a, 'P'
  jr nz, .drawParityBitError
.noParityBitError
  ld a, '-'
.drawParityBitError
  ld [hli], a

.testFinishBitError
  bit 0, b
  ld a, 'F'
  jr nz, .drawFinishBitError
.noFinishBitError
  ld a, '-'
.drawFinishBitError
  ld [hli], a

  xor a
  ld [hl], a;end string

  ld a, DRAW_FLAGS_WIN
  ld hl, str_buffer
  ld bc, 1
  ld d, 14
  ld e, 4
  call DrawText
  ret