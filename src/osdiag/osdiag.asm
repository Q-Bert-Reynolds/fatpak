;EverDrive X SD test that runs in OS mode: copy bin/GBCOS_DIAG.BIN to /GBCSYS/GBCOS.BIN on the card
;(keep the real one to put back). Games can't reach the EverDrive registers, the OS can. 32KB, no
;banking and no cart RAM, because in OS mode only the first 32KB of the image is mapped as ROM.
;Shows register readback locked and unlocked, $BD06-$BD08, the card's init responses and the MBR.
;Every SPI wait times out, so it can't hang.
INCLUDE "src/hardware.inc"

DEF EDX_DATA EQU $BD00
DEF EDX_CTRL EQU $BD01;b7 busy, b2 auto read, b1 slow clock, b0 deselect
DEF EDX_KEY  EQU $BD0A

SECTION "Vars", WRAM0
wScreen: DS SCRN_X_B*SCRN_Y_B
wCursor: DW
wRow: DB
wTimeout: DB;set when the busy bit never cleared
wArg: DS 4;big endian command argument
wTries: DW
wSector: DS 512
wLaunch: DB;1 = B, keep $BD06 = $04, 2 = SELECT, $08

SECTION "Reset", ROM0[$0000]
  jp Start

SECTION "Header", ROM0[$0100]
  nop
  jp Start
  DS $150-@, 0

SECTION "Version", ROM0[$01F0];the OS has 0, 1 here
  DB 0, 1

SECTION "Code", ROM0[$0300]

Font: INCBIN "img/ui_font.tiles"

Start:
  di
  ld sp, $E000
  ldh a, [rLCDC]
  bit 7, a
  jr z, .lcdOff
.waitVBlank
    ldh a, [rLY]
    cp a, SCRN_Y
    jr nz, .waitVBlank
  xor a
  ldh [rLCDC], a
.lcdOff
  xor a
  ldh [rSCX], a
  ldh [rSCY], a
  ldh [rVBK], a
  ld a, %11100100
  ldh [rBGP], a
  ld a, BCPSF_AUTOINC;CGB palette 0: white, light, dark, black
  ldh [rBCPS], a
  ld hl, Palette
  ld b, 8
.palette
    ld a, [hli]
    ldh [rBCPD], a
    dec b
    jr nz, .palette
  ld hl, Font
  ld de, $8000
  ld bc, 4096
.font
    ld a, [hli]
    ld [de], a
    inc de
    dec bc
    ld a, b
    or a, c
    jr nz, .font
  ld hl, $9800
  ld bc, 32*32
.map
    ld a, ' '
    ld [hli], a
    dec bc
    ld a, b
    or a, c
    jr nz, .map
  ld hl, wScreen
  ld bc, SCRN_X_B*SCRN_Y_B
.screen
    ld a, ' '
    ld [hli], a
    dec bc
    ld a, b
    or a, c
    jr nz, .screen
  ld a, LOW(wScreen)
  ld [wCursor], a
  ld a, HIGH(wScreen)
  ld [wCursor+1], a
  xor a
  ld [wRow], a
  ld [wTimeout], a
  ld a, LCDCF_ON | LCDCF_BG8000 | LCDCF_BG9800 | LCDCF_BGON
  ldh [rLCDC], a

  ld hl, TitleText
  ld a, [LaunchMode]
  and a
  jr z, .title
  ld hl, GameModeText;launched by the cart memory test
  call PutStr
  ld a, [LaunchMode]
  call PutHex
  call NewLine
  jr .tests
.title
  call PrintLine
.tests

  xor a;locked readback
  ld [EDX_KEY], a
  ld hl, LockedText
  call PutStr
  call Readback
  call NewLine

  ld a, $A5
  ld [EDX_KEY], a
  ld hl, UnlockText
  call PutStr
  call Readback
  call NewLine

  ld hl, Reg06Text
  call PutStr
  ld a, [$BD06]
  call PutHex
  ld hl, Reg07Text
  call PutStr
  ld a, [$BD07]
  call PutHex
  ld hl, Reg08Text
  call PutStr
  ld a, [$BD08]
  call PutHex
  call NewLine

  ld a, %011;deselected, slow clock
  ld [EDX_CTRL], a
  ld b, 16
.clocks
    ld a, $FF
    call Exchange
    dec b
    jr nz, .clocks

  ld hl, Cmd0Text
  call PutStr
  xor a
  ld hl, wArg
  ld [hli], a
  ld [hli], a
  ld [hli], a
  ld [hl], a
  ld a, $40
  ld c, $95
  call Command
  call PutHex
  call NewLine

  ld hl, Cmd8Text
  call PutStr
  ld hl, wArg+2
  ld [hl], $01
  inc hl
  ld [hl], $AA
  ld a, $48
  ld c, $87
  call Command
  call PutHex
  ld b, 4;R7
.r7
    ld a, $FF
    call Exchange
    call PutHex
    dec b
    jr nz, .r7
  call NewLine

  ld hl, Acmd41Text;until it's ready, with HCS
  call PutStr
  ld hl, 2000
.acmd41
    push hl
    xor a
    ld hl, wArg
    ld [hli], a
    ld [hli], a
    ld [hli], a
    ld [hl], a
    ld a, $40+55
    ld c, $01
    call Command
    ld a, $40
    ld [wArg], a
    ld a, $40+41
    ld c, $01
    call Command
    pop hl
    and a
    jr z, .ready
    dec hl
    ld b, a
    ld a, h
    or a, l
    ld a, b
    jr nz, .acmd41
.ready
  push hl
  call PutHex
  pop hl
  ld a, h
  call PutHex
  ld a, l
  call PutHex
  call NewLine

  ld hl, Cmd58Text
  call PutStr
  xor a
  ld hl, wArg
  ld [hli], a
  ld [hli], a
  ld [hli], a
  ld [hl], a
  ld a, $40+58
  ld c, $01
  call Command
  call PutHex
  ld b, 4;OCR, bit 6 of the first byte is CCS (block addressing)
.ocr
    ld a, $FF
    call Exchange
    call PutHex
    dec b
    jr nz, .ocr
  call NewLine

  ld a, [EDX_CTRL];fast clock
  and a, ~%010
  ld [EDX_CTRL], a

  ld hl, Cmd17Text;sector 0 is address 0 for byte and block addressed cards
  call PutStr
  xor a
  ld hl, wArg
  ld [hli], a
  ld [hli], a
  ld [hli], a
  ld [hl], a
  ld a, $40+17
  ld c, $01
  call Command
  call PutHex
  ld hl, 40000
.token
    ld a, $FF
    call Exchange
    cp a, $FF
    jr nz, .gotToken
    dec hl
    ld a, h
    or a, l
    jr nz, .token
  ld a, $FF
.gotToken
  call PutHex
  cp a, $FE
  jr nz, .noData
  ld hl, wSector
  ld bc, 512
.read
    ld a, $FF
    call Exchange
    ld [hli], a
    dec bc
    ld a, b
    or a, c
    jr nz, .read
  ld a, $FF;CRC
  call Exchange
  ld a, $FF
  call Exchange
  call NewLine
  ld hl, MBRText
  call PutStr
  ld a, [wSector+510]
  call PutHex
  ld a, [wSector+511]
  call PutHex
  ld hl, TypeText
  call PutStr
  ld a, [wSector+$1C2]
  call PutHex
.noData
  call NewLine
  call Deselect

  ld hl, TimeoutText
  ld a, [wTimeout]
  and a
  jr nz, .end
  ld hl, DoneText
.end
  call PutStr
  call NewLine
  ld a, [LaunchMode]
  and a
  jr z, .next
.stop
    halt
    jr .stop
.next
  call NewLine
  ld hl, NextText
  call PrintLine
  call WaitA
  jp MemoryMap

;waits for A to be pressed and released
WaitA:
  ld a, P1F_GET_BTN
  ldh [rP1], a
REPT 4
  ldh a, [rP1]
ENDR
  bit 0, a
  jr nz, WaitA
.release
  ldh a, [rP1]
  bit 0, a
  jr z, .release
  ret

;clears the screen, the next text goes on the first row
ClearScreen:
  ld hl, wScreen
  ld bc, SCRN_X_B*SCRN_Y_B
.clear
    ld a, ' '
    ld [hli], a
    dec bc
    ld a, b
    or a, c
    jr nz, .clear
  ld a, LOW(wScreen)
  ld [wCursor], a
  ld a, HIGH(wScreen)
  ld [wCursor+1], a
  xor a
  ld [wRow], a
  ret

;hl = address, returns the image chunk of the signature there in a, or $FF if there's none
Signature:
  ld de, SigText
  ld b, 4
.compare
    ld a, [de]
    cp a, [hl]
    jr nz, .none
    inc de
    inc hl
    dec b
    jr nz, .compare
  ld a, [hli]
  ld b, a
  cpl
  cp a, [hl];chunk, then its complement
  ld a, b
  ret z
.none
  ld a, $FF
  ret

;a = chunk or $FF, prints its hex digit or "-"
PutChunk:
  cp a, $FF
  jr nz, .digit
  ld a, '-'
  jp PutChar
.digit
  cp a, 10
  jr c, .number
  add a, 'A'-10-'0'
.number
  add a, '0'
  jp PutChar

;read only map of OS mode memory: what's in the ROM area and in each $BD08 page at $A000, and
;whether they're RAM (only written where our own image's padding is, and put back)
MemoryMap:
  call ClearScreen
  ld a, $A5
  ld [EDX_KEY], a

  ld hl, RomText;signatures at $1C00, $3C00, $5C00, $7C00
  call PutStr
  ld hl, $1C00
  call Signature
  call PutChunk
  ld hl, $3C00
  call Signature
  call PutChunk
  ld hl, $5C00
  call Signature
  call PutChunk
  ld hl, $7C00
  call Signature
  call PutChunk
  call NewLine

  ld hl, BankText;does writing $2000 switch $4000-$7FFF?
  call PutStr
  ld a, 2
  ld [$2000], a
  ld hl, $5C00
  call Signature
  call PutChunk
  ld a, 4
  ld [$2000], a
  ld hl, $5C00
  call Signature
  call PutChunk
  ld a, 1
  ld [$2000], a
  ld hl, $5C00
  call Signature
  call PutChunk
  call NewLine

  ld hl, RomRWText;is the ROM area writable, and is it page 3?
  call PutStr
  ld hl, $7B00
  ld a, [hl]
  ld c, a
  cpl
  ld [hl], a
  ld b, [hl]
  ld [hl], c
  cp a, b
  ld a, 'Y'
  jr z, .romRW
  ld a, 'N'
.romRW
  call PutChar
  ld a, ' '
  call PutChar
  ld hl, AliasText
  call PutStr
  ld a, 3
  ld [$BD08], a
  ld hl, $7B00
  ld a, $5A
  ld [hl], a
  ld a, [$BB00]
  ld b, a
  ld a, $A5
  ld [hl], a
  ld a, [$BB00]
  ld [hl], c;put it back
  cp a, $A5
  jr nz, .noAlias
  ld a, b
  cp a, $5A
  ld a, 'Y'
  jr z, .alias
.noAlias
  ld a, 'N'
.alias
  call PutChar
  call NewLine

  ld hl, BD08Text;which bits of $BD08 stick
  call PutStr
  ld a, $FF
  ld [$BD08], a
  ld a, [$BD08]
  call PutHex
  call NewLine

  ld hl, PageText;pages that hold our padding (chunk 15) are safe to write
  call PutStr
  ld a, 15
  ld [$BD08], a
  ld hl, $BC00
  call Signature
  cp a, 15
  ld a, '-'
  jr nz, .pageRW
  ld hl, $B000
  ld c, [hl]
  ld a, c
  cpl
  ld [hl], a
  ld b, [hl]
  ld [hl], c
  cp a, b
  ld a, 'Y'
  jr z, .pageRW
  ld a, 'N'
.pageRW
  call PutChar
  call NewLine
  call NewLine
  ld hl, MapNextText
  call PrintLine
  call WaitA
  call ClearScreen

  ld hl, MapText
  call PrintLine
  ld c, 0;page
.row
    ld a, c
    call PutHex
.page
      ld a, c
      ld [$BD08], a
      push bc
      ld hl, $BC00
      call Signature
      cp a, $FF
      jr nz, .chunk
      ld hl, _SRAM;all $FF, all $00, or something else
      ld b, 0
      ld a, [hl]
.scan
        cp a, [hl]
        jr nz, .other
        inc hl
        dec b
        jr nz, .scan
      cp a, $FF
      ld a, '.'
      jr z, .put
      and a
      ld a, '0'
      jr z, .put
.other
      ld a, '*'
      jr .put
.chunk
      call PutChunk
      jr .next
.put
      call PutChar
.next
      pop bc
      inc c
      ld a, c
      and a, %1111
      jr nz, .page
    call NewLine
    ld a, c
    and a
    jr nz, .row

  ld a, 4;the OS's page
  ld [$BD08], a
  call WaitA
  jp CartMemory

;bc = 512 byte block, a = $BD06 (bit 1 set = save RAM, clear = PSRAM), shows it at $BE00
SetBlock:
  ld [$BD06], a
  ld a, c
  ld [$BD02], a
  ld a, b
  ld [$BD03], a
  ret

;hl = address, b = count, prints chars, "." for anything that isn't printable
PutChars:
  ld a, [hli]
  cp a, ' '
  jr c, .dot
  cp a, '~'+1
  jr c, .put
.dot
  ld a, '.'
.put
  call PutChar
  dec b
  jr nz, PutChars
  ret

;read only look at cart memory through the $BE00 window, then optionally copies this image to PSRAM
;block 0 (where games are loaded, if the title there is the last game run) and launches it in game
;mode with $BD06 = $04 (B) or $08 like the OS (SELECT)
CartMemory:
  call ClearScreen
  ld hl, CartText
  call PrintLine
  ld bc, 0
  ld a, $04
  call SetBlock
  ld hl, PSRAMText
  call PrintLine
  ld hl, $BE00+$134
  ld b, 16
  call PutChars
  call NewLine
  ld hl, TypeSizesText
  call PutStr
  ld a, [$BE00+$147]
  call PutHex
  ld a, [$BE00+$148]
  call PutHex
  ld a, [$BE00+$149]
  call PutHex
  call NewLine
  ld bc, 0
  ld a, $06
  call SetBlock
  ld hl, SaveRAMText
  call PutStr
  ld hl, $BE00
  ld b, 6
.saveRAM
    ld a, [hli]
    call PutHex
    dec b
    jr nz, .saveRAM
  call NewLine
  ld bc, $3E40
  ld a, $04
  call SetBlock
  ld hl, StateText
  call PutStr
  ld hl, $BE00
  ld b, 4
  call PutChars
  call NewLine
  ld hl, UpperText;did the bootloader load past 128KB? chunk n's signature is at block n*16+14
  call PutStr
  ld e, 16
.upper
    ld a, e
    swap a
    ld c, a
    ld a, e
    swap a
    and a, $0F
    ld b, a
    ld a, c
    and a, $F0
    or a, 14
    ld c, a
    ld a, $04
    call SetBlock
    push de
    ld hl, $BE00
    call Signature
    call PutChunk
    pop de
    inc e
    ld a, e
    cp a, 32
    jr nz, .upper
  call NewLine
  ld hl, LaunchText1
  call PrintLine
  ld hl, LaunchText2
  call PrintLine
  ld hl, LaunchText3
  call PrintLine
  ld hl, LaunchText4
  call PrintLine
  ld hl, LaunchText5
  call PrintLine
.waitButton
    ld a, P1F_GET_BTN
    ldh [rP1], a
REPT 4
    ldh a, [rP1]
ENDR
    ld d, 1
    bit 1, a;B
    jr z, .release
    ld d, 2
    bit 2, a;SELECT
    jr nz, .waitButton
.release
    ld a, d
    ld [wLaunch], a
    ldh a, [rP1]
    and a, %0110
    cp a, %0110
    jr nz, .release
  ld hl, CopyingText
  call PrintLine

  ld hl, $0000;copy 32KB, 64 blocks, to PSRAM block 0
  ld bc, 0
.copy
    ld a, $04
    call SetBlock
    ld de, $BE00
.copyByte
      ld a, [hli]
      ld [de], a
      inc de
      ld a, d
      cp a, $C0
      jr nz, .copyByte
    inc c
    ld a, c
    cp a, 64
    jr nz, .copy
  ld bc, 0;the copy knows how it was launched
  ld a, $04
  call SetBlock
  ld a, [wLaunch]
  ld [$BE00+LaunchMode], a

  ld a, [wLaunch];launch like Cart_LaunchGame, ROM only, no RAM
  cp a, 1
  ld a, $04
  jr z, .bd06
  ld a, $08
.bd06
  ld [$BD06], a
  xor a
  ld [$BD04], a
  ld [$BD05], a
  ld [$BD09], a
  ld [rRAMG], a
  ld [$3000], a
  ld [rRAMB], a
  ld [$6000], a
  inc a
  ld [$2100], a
  ld [$2000], a
  ld a, 4;ROM only mapper
  ld [$BD07], a
  jp $0100;if the FPGA doesn't reset the Game Boy, the copy is mapped here now

;writes $5A and $A1 to $BD01 and shows what reads back
Readback:
  ld a, $5A
  ld [EDX_CTRL], a
  ld a, [EDX_CTRL]
  call PutHex
  ld a, $A1
  ld [EDX_CTRL], a
  ld a, [EDX_CTRL]
  call PutHex
  ld a, %011
  ld [EDX_CTRL], a
  ret

;a = byte to send, returns the received byte in a, affects nothing else (waits up to ~256 reads)
Exchange:
  push bc
  ld [EDX_DATA], a
  ld a, [wTimeout];after one timeout, don't wait any more
  and a
  jr nz, .done
  ld b, 0
.wait
    ld a, [EDX_CTRL]
    bit 7, a
    jr z, .done
    dec b
    jr nz, .wait
  ld a, 1
  ld [wTimeout], a
.done
  ld a, [EDX_DATA]
  pop bc
  ret

Select:
  ld a, [EDX_CTRL]
  and a, ~1
  ld [EDX_CTRL], a
  ret

Deselect:
  ld a, [EDX_CTRL]
  or a, 1
  ld [EDX_CTRL], a
  ld a, $FF
  jp Exchange

;a = command byte, c = CRC byte, [wArg] = argument, returns R1 in a ($FF if none), affects bc, hl
Command:
  push af
  call Deselect
  call Select
  ld a, $FF
  call Exchange
  pop af
  call Exchange
  ld hl, wArg
REPT 4
  ld a, [hli]
  call Exchange
ENDR
  ld a, c
  call Exchange
  ld b, 10
.response
    ld a, $FF
    call Exchange
    bit 7, a
    ret z
    dec b
    jr nz, .response
  ret

;hl = text
PrintLine:
  call PutStr
  jp NewLine

;hl = text
PutStr:
  ld a, [hli]
  and a
  ret z
  call PutChar
  jr PutStr

;a = byte, prints 2 hex digits and a space
PutHex:
  push af
  swap a
  call .digit
  pop af
  push af
  call .digit
  ld a, ' '
  call PutChar
  pop af
  ret
.digit
  and a, $0F
  add a, '0'
  cp a, '9'+1
  jr c, PutChar
  add a, 'A'-'9'-1
  ;fall through

;a = char, only affects a
PutChar:
  push hl
  push af
  ld a, [wCursor]
  ld l, a
  ld a, [wCursor+1]
  ld h, a
  pop af
  ld [hli], a
  ld a, l
  ld [wCursor], a
  ld a, h
  ld [wCursor+1], a
  pop hl
  ret

;shows the screen and starts the next row, preserves a
NewLine:
  push af
  push bc
  push de
  push hl
  ld a, [wRow]
  inc a
  cp a, SCRN_Y_B
  jr c, .row
  dec a
.row
  ld [wRow], a
  ld l, a;cursor = wScreen + row * 20
  ld h, 0
  add hl, hl
  add hl, hl
  ld d, h
  ld e, l
  add hl, hl
  add hl, hl
  add hl, de
  ld de, wScreen
  add hl, de
  ld a, l
  ld [wCursor], a
  ld a, h
  ld [wCursor+1], a
.waitVBlank
    ldh a, [rLY]
    cp a, SCRN_Y
    jr nz, .waitVBlank
  xor a
  ldh [rLCDC], a
  ld hl, wScreen
  ld de, $9800
  ld c, SCRN_Y_B
.copyRow
    ld b, SCRN_X_B
.copyChar
      ld a, [hli]
      ld [de], a
      inc de
      dec b
      jr nz, .copyChar
    ld a, e
    add a, 32-SCRN_X_B
    ld e, a
    adc a, d
    sub a, e
    ld d, a
    dec c
    jr nz, .copyRow
  ld a, LCDCF_ON | LCDCF_BG8000 | LCDCF_BG9800 | LCDCF_BGON
  ldh [rLCDC], a
  pop hl
  pop de
  pop bc
  pop af
  ret

Palette: DW $7FFF, $56B5, $294A, $0000
TitleText:   DB "OS MODE SD TEST", 0
LockedText:  DB "LOCKED ", 0
UnlockText:  DB "UNLOCK ", 0
Reg06Text:   DB "06 ", 0
Reg07Text:   DB "07 ", 0
Reg08Text:   DB "08 ", 0
Cmd0Text:    DB "CMD0 ", 0
Cmd8Text:    DB "CMD8 ", 0
Acmd41Text:  DB "ACMD41 ", 0
Cmd58Text:   DB "CMD58 ", 0
Cmd17Text:   DB "CMD17 ", 0
MBRText:     DB "MBR ", 0
TypeText:    DB "TYPE ", 0
TimeoutText: DB "BUSY TIMEOUT", 0
DoneText:    DB "DONE", 0
NextText:    DB "A: MEMORY MAP", 0
RomText:     DB "ROM ", 0
BankText:    DB "2000=2,4,1 ", 0
RomRWText:   DB "ROM RW ", 0
AliasText:   DB "=PAGE3 ", 0
BD08Text:    DB "BD08 FF->", 0
PageText:    DB "PAGE 15 RW ", 0
MapText:     DB "PG 0123456789ABCDEF", 0
MapNextText: DB "A: PAGE MAP", 0
GameModeText: DB "GAME MODE TEST ", 0
CartText:    DB "CART MEMORY", 0
PSRAMText:   DB "PSRAM 0 TITLE:", 0
TypeSizesText: DB "147-149 ", 0
SaveRAMText: DB "SAVE ", 0
StateText:   DB "3E40 ", 0
LaunchText1: DB "IF THE TITLE IS THE", 0
LaunchText2: DB "LAST GAME YOU RAN:", 0
LaunchText3: DB "B: LAUNCH A COPY", 0
LaunchText4: DB "   KEEPING BD06=04", 0
LaunchText5: DB "SEL: BD06=08 LIKE OS", 0
CopyingText: DB "COPYING...", 0
UpperText:   DB "16+ ", 0
SigText:     DB "OSDG"

;each 8KB chunk of the image has "OSDG", chunk, ~chunk at $1C00 (Makefile writes them)
SECTION "Signature 0", ROM0[$1C00]
  DS 6
SECTION "Signature 1", ROM0[$3C00]
  DS 6
SECTION "Signature 2", ROM0[$5C00]
  DS 6
SECTION "Signature 3", ROM0[$7C00]
  DS 6
SECTION "Scratch", ROM0[$7B00];written by the ROM RW test
  DB 0
SECTION "Launch Mode", ROM0[$0150];0 in OS mode, 1 or 2 in the copy the cart memory test launches
LaunchMode: DB 0
