; P1 packet sender shared by the OS and standalone SGB probes.
; HL = packet; clobbers AF, BC, DE, HL. Caller protects P1 against other users.
; The slow entry waits about four GB frames after each packet.
_sgb_PacketTransfer:
  ld c, 1
  jr sgb_PacketTransferFast.begin
sgb_PacketTransferFast::
  ld c, 0; mailbox ack: the next NMI/BIOS command acknowledges delivery
.begin
  ld a, [hl]
  and %00000111               ; The three lower bits indicate the number of packets to send
  ret z                       ; We return if there are no packets to send
  ld b, a                     ; We store the number of packets to send

  ld a, [hl]
  rra
  rra
  rra
  and %00011111
  cp a, SGB_CODE_PAL_PRI+1        ;last code available
  ret nc
  cp a, SGB_CODE_OBJ_TRN
  ret z
  cp a, SGB_CODE_TEST_EN
  ret z
.sendPacketsLoop
    push bc
    xor a
    ldh [rP1], a               ; Initial pulse (Start write). P14 = LOW and P15 = LOW
    ld a, P1F_4 | P1F_5
    ldh [rP1], a               ; P14 = HIGH and P15 = HIGH between pulses
    ld b, 16                  ; Number of bytes per packet
  .sendBytesLoop
      ld e, 8                 ; Bits per byte
      ld a, [hli]
      ld d, a                 ; Next byte of the packet
    .sendBitsLoop
        bit 0, d
        ld a, P1F_4           ; P14 = HIGH and P15 = LOW (Write 1)
        jr nz, .skip
        ld a, P1F_5           ; P14 = LOW and P15 = HIGH (Write 0)
      .skip
        ldh [rP1], a           ; We send one bit
        ld a, P1F_4 | P1F_5
        ldh [rP1], a           ; P14 = HIGH and P15 = HIGH between pulses
        rr d                  ; We rotate the register so that the next bit goes to position 0
        dec e
        jr nz, .sendBitsLoop  ; We jump while there are bits left to be sent
      dec b
      jr nz, .sendBytesLoop   ; We jump while there are bytes left to be sent
    ld a, P1F_5
    ldh [rP1], a               ; Bit 129, stop bit (Write 0)
    ld a, P1F_4 | P1F_5
    ldh [rP1], a               ; P14 = HIGH and P15 = HIGH between pulses

    ld a, c
    and a
    jr z, .packetDone
    ; 280048 clock cycles are consumed (66.768646240234375 milliseconds) at 4.194304 mhz | 24 cycles
    ld de, 7000               ; 12 cycles
.wait24Cycles
      nop                     ; 4 cycles
      nop                     ; 4 cycles
      nop                     ; 4 cycles
      dec de                  ; 8 cycles
      ld a, d                 ; 4 cycles
      or e                    ; 4 cycles
      jr nz, .wait24Cycles    ; 12 cycles if jumps, 8 if not

  .packetDone
    pop bc
    dec b
    jr nz, .sendPacketsLoop       ; We jump while there are packets left to be sent
  ret

