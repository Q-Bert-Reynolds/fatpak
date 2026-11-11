;EverDrive GB X-series SD card over SPI. Based on TXTReaderGB's diskio
;(MIT, Toxa and RodrigoCard, after ChaN's AVR example).
;Registers live in SRAM space and only respond after unlocking, SRAM is
;disabled while they're in use.
;
;C functions (src/fatfs/sd.h)
;   sd_Init                     returns a = 0 if a card is ready
;   sd_ReadSector               de = 512 byte buffer, [_sd_sector] = LBA, returns a = 0 if successful
;   sd_WriteSector              de = 512 byte buffer, [_sd_sector] = LBA, returns a = 0 if successful

DEF EDX_SPI_DATA       EQU $BD00
DEF EDX_SPI_CTRL       EQU $BD01
DEF EDX_KEY            EQU $BD0A
DEF EDX_KEY_UNLOCK     EQU $A5
DEF EDX_SPI_SS         EQU %00000001;1 = deselected
DEF EDX_SPI_LOW_SPEED  EQU %00000010
DEF EDX_SPI_BUSY       EQU 7
DEF EDX_SPI_AUTO_READ  EQU %00000100;with EDX_CONFIG bit 0 (OS mode): reading the data register returns the
;byte received and clocks the next one, no busy wait (like the EverDrive's OS, see _sd_ReadSector)

DEF SD_CMD0   EQU $40+0 ;GO_IDLE_STATE
DEF SD_CMD8   EQU $40+8 ;SEND_IF_COND
DEF SD_CMD16  EQU $40+16;SET_BLOCKLEN
DEF SD_CMD17  EQU $40+17;READ_SINGLE_BLOCK
DEF SD_CMD24  EQU $40+24;WRITE_BLOCK
DEF SD_CMD55  EQU $40+55;APP_CMD
DEF SD_CMD58  EQU $40+58;READ_OCR
DEF SD_ACMD41 EQU $C0+41;SEND_OP_COND (SDC)

;sd_type
DEF SD_TYPE_SD1   EQU %0010
DEF SD_TYPE_SD2   EQU %0100
DEF SD_TYPE_BLOCK EQU %1000;block addressing

;unlocked at boot and kept that way, the window and pages need them
MACRO SD_REGS_ON
ENDM

MACRO SD_REGS_OFF
ENDM

MACRO SD_RECEIVE
  ld a, $FF
  call SDExchange
ENDM

MACRO SD_ARG ;\1-\4 = big endian argument bytes
  ld hl, sd_arg
  ld [hl], \1
  inc hl
  ld [hl], \2
  inc hl
  ld [hl], \3
  inc hl
  ld [hl], \4
ENDM

SECTION "SD Vars", WRAM0
_sd_sector:: DS 4;little endian LBA
sd_arg: DS 4;big endian command argument
sd_ocr: DS 4
sd_type: DB
sd_timer: DW
sd_count: DB
sd_ramg:: DB;written to rRAMG while the registers are in use, 0 (the SD test changes it)
sd_ramg_key:: DB;written to rRAMG while unlocking, 0 (the SD test changes it)
sd_r1:: DS 2;CMD0 and CMD8 responses from the last sd_Init, for the SD test

SECTION "SD Code", ROM0

;unlocks the registers, only affects a
SDRegsOn:
  ld a, [sd_ramg_key]
  ld [rRAMG], a;SRAM off (0) so register accesses can't reach it, the SD test tries it on
  ld a, EDX_KEY_UNLOCK
  ld [EDX_KEY], a
  ld a, [sd_ramg]
  ld [rRAMG], a
  ret

;a = byte to send, returns received byte in a, only affects a
SDExchange:
  ld [EDX_SPI_DATA], a
.wait
    ld a, [EDX_SPI_CTRL]
    bit EDX_SPI_BUSY, a
    jr nz, .wait
  ld a, [EDX_SPI_DATA]
  ret

;only affects a
SDSelect:
  ld a, [EDX_SPI_CTRL]
  and a, ~EDX_SPI_SS
  ld [EDX_SPI_CTRL], a
  ret

;only affects a
SDDeselect:
  ld a, [EDX_SPI_CTRL]
  or a, EDX_SPI_SS
  ld [EDX_SPI_CTRL], a
  ret

;a = command (bit 7 = app command), [sd_arg] = argument, returns R1 in a, affects bc, hl
SDCommand:
  bit 7, a
  jr z, SDSendCommand
  push af
  ld a, SD_CMD55
  call SDSendCommand
  ld b, a
  pop af
  and a, $7F
  ld c, a
  ld a, b
  cp a, 2
  ret nc;CMD55 failed
  ld a, c
  ;fall through

;a = command, [sd_arg] = argument, returns R1 in a, affects bc, hl
SDSendCommand:
  ld c, a
  call SDDeselect
  SD_RECEIVE
  call SDSelect
  SD_RECEIVE
  ld a, c
  call SDExchange
  ld hl, sd_arg
REPT 4
  ld a, [hli]
  call SDExchange
ENDR
  ld a, c
  ld b, $95;valid CRC for CMD0
  cp a, SD_CMD0
  jr z, .crc
  ld b, $87;valid CRC for CMD8 $1AA
  cp a, SD_CMD8
  jr z, .crc
  ld b, $01;dummy CRC and stop bit
.crc
  ld a, b
  call SDExchange
  ld b, 10
.waitForResponse
    SD_RECEIVE
    bit 7, a
    ret z
    dec b
    jr nz, .waitForResponse
  ret

;a = command, retries until it returns 0 for up to ~1 second, returns R1 in a
SDWaitForCommand:
  ld hl, 1000
.loop
    push hl
    push af;command
    call SDCommand
    and a
    jr z, .done
    ld de, 1
    call gbdk_Delay
    pop af;command
    pop hl
    dec hl
    ld a, h
    or a, l
    jr nz, .loop
  inc a
  ret
.done
  pop hl;discard command
  pop hl
  ret

_sd_Init::;returns a = 0 if a card is ready
  SD_REGS_ON
  ld a, EDX_SPI_SS | EDX_SPI_LOW_SPEED
  ld [EDX_SPI_CTRL], a
  ld b, 10
.dummyClocks;80 clocks with card deselected
    SD_RECEIVE
    dec b
    jr nz, .dummyClocks
  xor a
  ld [sd_type], a

  SD_ARG 0, 0, 0, 0
  ld a, SD_CMD0
  call SDCommand
  ld [sd_r1], a
  cp a, 1
  jp nz, .done;no card

  SD_ARG 0, 0, 1, $AA
  ld a, SD_CMD8
  call SDCommand
  ld [sd_r1+1], a
  cp a, 1
  jp nz, .sdv1

.sdv2
  ld hl, sd_ocr
  ld b, 4
.readR7
    SD_RECEIVE
    ld [hli], a
    dec b
    jr nz, .readR7
  ld a, [sd_ocr+2]
  cp a, 1
  jp nz, .done;voltage not accepted
  ld a, [sd_ocr+3]
  cp a, $AA
  jp nz, .done
  SD_ARG $40, 0, 0, 0;HCS
  ld a, SD_ACMD41
  call SDWaitForCommand
  and a
  jp nz, .done
  SD_ARG 0, 0, 0, 0
  ld a, SD_CMD58
  call SDCommand
  and a
  jp nz, .done
  SD_RECEIVE
  and a, $40;CCS
  ld a, SD_TYPE_SD2
  jr z, .setType
  ld a, SD_TYPE_SD2 | SD_TYPE_BLOCK
.setType
  ld [sd_type], a
REPT 3
  SD_RECEIVE
ENDR
  jp .done

.sdv1;SD v1, MMC isn't supported
  SD_ARG 0, 0, 0, 0
  ld a, SD_ACMD41
  call SDWaitForCommand
  and a
  jr nz, .done
  SD_ARG 0, 0, 2, 0;512 byte blocks
  ld a, SD_CMD16
  call SDCommand
  and a
  jr nz, .done
  ld a, SD_TYPE_SD1
  ld [sd_type], a

.done
  call SDDeselect
  SD_RECEIVE
  ld a, [sd_type]
  and a
  jr z, .finish
  ld a, [EDX_SPI_CTRL]
  and a, ~EDX_SPI_LOW_SPEED
  ld [EDX_SPI_CTRL], a
.finish
  SD_REGS_OFF
  ld a, [sd_type]
  and a
  ld a, 0
  ret nz
  inc a
  ret

;sets [sd_arg] to [_sd_sector], in bytes for byte addressed cards
SDSetSectorArg:
  ld a, [sd_type]
  and a, SD_TYPE_BLOCK
  jr z, .bytes
  ld hl, _sd_sector+3
  ld de, sd_arg
REPT 4
  ld a, [hld]
  ld [de], a
  inc de
ENDR
  ret
.bytes;sector << 9
  ld a, [_sd_sector]
  add a, a
  ld [sd_arg+2], a
  ld a, [_sd_sector+1]
  rla
  ld [sd_arg+1], a
  ld a, [_sd_sector+2]
  rla
  ld [sd_arg], a
  xor a
  ld [sd_arg+3], a
  ret

;a = result, deselects card and locks registers, returns result in a
SDFinish:
  push af
  call SDDeselect
  SD_RECEIVE
  SD_REGS_OFF
  pop af
  ret

_sd_ReadSector::;de = 512 byte buffer, [_sd_sector] = LBA, returns a = 0 if successful
  push de
  SD_REGS_ON
  call SDSetSectorArg
  ld a, SD_CMD17
  call SDCommand
  pop de
  and a
  jp nz, .error
  ld hl, 40000
.waitForToken
    SD_RECEIVE
    cp a, $FF
    jr nz, .token
    dec hl
    ld a, h
    or a, l
    jr nz, .waitForToken
  jp .error
.token
  cp a, $FE
  jp nz, .error
  ld h, d
  ld l, e
  ld bc, EDX_SPI_CTRL
  ld de, EDX_SPI_DATA
  ld a, 512/8
  ld [sd_count], a
.read8;SDExchange inlined
REPT 8
    ld a, $FF
    ld [de], a
.wait\@
      ld a, [bc]
      add a, a;busy bit to carry
      jr c, .wait\@
    ld a, [de]
    ld [hli], a
ENDR
    ld a, [sd_count]
    dec a
    ld [sd_count], a
    jr nz, .read8
  SD_RECEIVE;CRC
  SD_RECEIVE
  xor a
  jp SDFinish
.error
  ld a, 1
  jp SDFinish

_sd_WriteSector::;de = 512 byte buffer, [_sd_sector] = LBA, returns a = 0 if successful
  push de
  SD_REGS_ON
  call SDSetSectorArg
  ld a, SD_CMD24
  call SDCommand
  pop de
  and a
  jp nz, .error
  SD_RECEIVE
  ld a, $FE;data token
  call SDExchange
  ld h, d
  ld l, e
  ld bc, EDX_SPI_CTRL
  ld de, EDX_SPI_DATA
  ld a, 512/8
  ld [sd_count], a
.write8;SDExchange inlined, without reading back
REPT 8
    ld a, [hli]
    ld [de], a
.wait\@
      ld a, [bc]
      add a, a;busy bit to carry
      jr c, .wait\@
ENDR
    ld a, [sd_count]
    dec a
    ld [sd_count], a
    jr nz, .write8
  xor a;CRC
  call SDExchange
  xor a
  call SDExchange
  SD_RECEIVE
  and a, $1F
  cp a, $05;data accepted
  jr nz, .error
  ld hl, 50000
.waitWhileBusy
    SD_RECEIVE
    cp a, $FF
    jr z, .done
    dec hl
    ld a, h
    or a, l
    jr nz, .waitWhileBusy
  jr .error
.done
  xor a
  jp SDFinish
.error
  ld a, 1
  jp SDFinish

DEF SD_CMD12 EQU $40+12;STOP_TRANSMISSION
DEF SD_CMD18 EQU $40+18;READ_MULTIPLE_BLOCK

SECTION "SD Stream Writes", ROM0
;Execute the eight-write inner loop from resident memory, as stock does. The
;caller has stopped DMA. Retain the caller's CPU speed, including CGB double speed.
;Only the resident LCD handler may interrupt; it never starts DMA or touches SPI.
SDStreamSector:
  ld hl, EDX_WINDOW
  ld b, 512/8
.write8
REPT 8
    ld [hli], a
ENDR
  dec b
  jr nz, .write8
  ret

PAGE GAME_PAGE
;de = first PSRAM sector, bc = sector count (> 0), [_sd_sector] = LBA.
;CMD18 auto-read streams bytes directly into the window. Keep every transfer
;without VBlank/OAM DMA or pending HBlank DMA. CPU speed is unchanged.
;Restore IE and IF on all exits; IME is unchanged. Ordinary file IO
;still uses the busy-polled single-sector reader.
_sd_ReadBlocks::
  ldh a, [rIE]
  push af
  and a, IEF_STAT;keep the browser's window/tile addressing, exclude all DMA handlers
  ldh [rIE], a
  call RenderWaitDMA
  ldh a, [rIF]
  push af
  push bc
  push de
  call SDSetSectorArg
  ld a, SD_CMD18
  call SDCommand
  pop de
  pop bc
  and a
  jr nz, .commandError
  call SDAutoRead
.block
  ld a, e
  ld [EDX_BLOCK], a
  ld a, d
  ld [EDX_BLOCK+1], a
  push bc
  push de
  ld de, EDX_SPI_DATA
  ld a, [de];prime the token/CRC pipeline before each sector, as stock does
  ld hl, 40000
.waitForToken
    ld a, [de]
    cp a, $FE
    jr z, .token
    dec hl
    ld a, h
    or a, l
    jr nz, .waitForToken
  pop de
  pop bc
  call SDAutoReadOff
  call SDStop
.commandError
  ld a, 1
  jr ReadBlocksFinish
.token
  call SDStreamSector
  ld a, [de];CRC
  pop de
  pop bc
  inc de
  dec bc
  ld a, b
  or a, c
  jr nz, .block
  call SDAutoReadOff
  call SDStop
ReadBlocksFinish:
  call SDFinish
  ld b, a
  pop af
  ldh [rIF], a
  pop af
  ldh [rIE], a
  ld a, b
  and a
  ret

SDAutoRead:
  ld a, [EDX_SPI_CTRL]
  or a, EDX_SPI_AUTO_READ
  ld [EDX_SPI_CTRL], a
  ld a, [EDX_CONFIG]
  or a, 1
  ld [EDX_CONFIG], a
  ret

SDAutoReadOff:
  ld a, [EDX_SPI_CTRL]
  and a, ~EDX_SPI_AUTO_READ
  ld [EDX_SPI_CTRL], a
  ld a, [EDX_CONFIG]
  and a, ~1
  ld [EDX_CONFIG], a
  ret

;ends a READ_MULTIPLE_BLOCK without deselecting the card: STOP_TRANSMISSION, a stuff byte, R1, then the busy
;wait, returns a = 0 if it worked, affects b, hl
SDStop:
  ld a, SD_CMD12
  call SDExchange
  ld b, 4
.argument
    xor a
    call SDExchange
    dec b
    jr nz, .argument
  ld a, $01;dummy CRC and stop bit
  call SDExchange
  SD_RECEIVE;stuff byte
  ld b, 10
.response
    SD_RECEIVE
    bit 7, a
    jr z, .busy
    dec b
    jr nz, .response
  ld a, 1
  ret
.busy
  ld hl, 50000
.waitWhileBusy
    SD_RECEIVE
    cp a, $FF
    ld a, 0
    ret z
    dec hl
    ld a, h
    or a, l
    jr nz, .waitWhileBusy
  ld a, 1
  ret

END_PAGE
