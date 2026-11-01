;4 CPU cycles at 4.194304 MHz is 0.953674316 μs
;PS/2 keyboard clock is ~100 μs between clock pulses

DEF PS2_LAST_BITS_MARKER EQU %00010000;SB = 10000 7PF once the last 3 bits are in

PS2KeyboardInterrupt::
  ld a, [kb_type]
  cp a, KB_TYPE_PS2
  ret nz;if not in PS/2 mode, exit early

  ldh a, [rSB]
  ld b, a;store first 8 bits of scan code (S0123456)

.testStartBit
  bit 7, b;test start bit, should always be 0
  jr z, .waitForLastBits
.startBitError
  ld a, PS2_ERROR_START_BIT
  ld [kb_error], a
  jp .checkAllErrors;bail early if start bit not 0

.waitForLastBits;the marker reaches bit 7 after exactly 3 more bits (comparing SB with the
  ;bits expected after the shift could match early, $5B matched before any new bits arrived)
  ld a, PS2_LAST_BITS_MARKER
  ldh [rSB], a
  ld a, SCF_START
  ldh [rSC], a      ;ask for more bits using keyboard clock 
  xor a
  ld [kb_error], a ;reset current error code
  ld e, 255          ;timer
.pollBitsLoop
    ldh a, [rSB]
    ld d, a;actual value
    bit 7, a
    jr nz, .allBitsRead
    dec e
    jr nz, .pollBitsLoop
.timeout
  ld a, [kb_error]
  or a, PS2_ERROR_TIMEOUT
  ld [kb_error], a
  
.allBitsRead
  ld a, d
  and a, %00000111
  ld c, a;xxxxx7PF
  ld a, SCF_SOURCE
  ldh [rSC], a;stop asking for stuff, use internal clock

.testFinishBit
  bit 0, c;test finish bit, should always be 1
  jr nz, .storeParityBit
.finishBitError
  ld a, [kb_error]
  or a, PS2_ERROR_FINISH_BIT
  ld [kb_error], a

.storeParityBit
  ld a, c
  srl a;bit 0 is parity
  and a, %00000001
  ld e, a

.storeDataBits
  sla b  ;0123456x
  ld a, c;xxxxx7PF
  srl a  ;xxxxxx7P
  srl a  ;xxxxxxx7
  or a, b;01234567
  ld d, a;data bits

; ;data (d) is 01234567, needs to be 76543210 in a
; ;we can count bits as we do so to test Parity Bit 
.reverseAndCountDataBits
  ld b, 8;bits left
  ld c, 0;bit sum
.reverseAndCountLoop
    srl d;shift data right out of d into carry
    rl a;rotate data left from carry into a
    bit 0, a
    jr z, .decrementBitsLeft
  .addBit
    inc c;if new bit is 1, increment sum
  .decrementBitsLeft
    dec b;bits left
    jr nz, .reverseAndCountLoop
.storeScanCode
  ld [kb_scan_code], a

.testParityBit
  ld a, c;bit sum
  and a, %00000001
  cp a, e;bit 0 of e is parity, and bit 0 of a is even/odd. These should never be equal.
  jr nz, .writeScanCodeToBuffer
.parityBitError
  ld a, [kb_error]
  or a, PS2_ERROR_PARITY_BIT
  ld [kb_error], a

.writeScanCodeToBuffer
  ld hl, kb_scan_code_buffer
  ld a, [kb_buffer_write]
  ld b, 0
  ld c, a
  add hl, bc
  ld a, [kb_scan_code]
  ld [hl], a

.writeErrorCodeToBuffer
  ld hl, kb_error_buffer
  ld a, [kb_buffer_write]
  ld b, 0
  ld c, a
  add hl, bc
  ld a, [kb_error]
  ld [hl], a

.incrementWriteHead
  ld a, [kb_buffer_write]
  inc a
  and a, KB_SCAN_CODE_COUNT-1
  ld [kb_buffer_write], a

.checkAllErrors
  ld a, [kb_error]
  and a
  jr z, .askForNextBits
  ld a, [kb_error_count]
  inc a
  ld [kb_error_count], a

.askForNextBits
  ld a, [kb_interrupt_count]
  inc a
  ld [kb_interrupt_count], a
  xor a
  ldh [rSB], a;clear serial bits
  ld a, SCF_START
  ldh [rSC], a;start next transfer using external clock
  ret