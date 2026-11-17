; Plain ROM: no EverDrive registers, OS pages, overlays or external data files.
INCLUDE "src/hardware.inc"
INCLUDE "src/sgb/commands.asm"
INCLUDE "build/sgb/hello.inc"

DEF PHASE EQU $C100
DEF REPLY EQU $C101

SECTION "Header", ROM0[$100]
  nop
  jp Main
  ds $150-@, 0

SECTION "Probe", ROM0[$150]
Main:
  di
  ld sp, $DFFF
  xor a
  ldh [rIE], a
  ldh [rIF], a
  ld [PHASE], a
  ld [REPLY], a
  call LCDOff
  ; A checkerboard is the pending/not-SGB picture, frozen during the upload.
  ld hl, $8800
  ld b, 8
.checker
  ld a, $AA
  ld [hli], a
  cpl
  ld [hli], a
  dec b
  jr nz, .checker
  ld hl, $9800
  ld bc, 1024
.map
  ld a, $80
  ld [hli], a
  dec bc
  ld a, b
  or c
  jr nz, .map
  xor a
  ldh [rSCX], a
  ldh [rSCY], a
  ld a, $E4
  ldh [rBGP], a
  ld a, LCDCF_ON | LCDCF_BGON
  ldh [rLCDC], a
  ; BIOS intro must finish before meaningful commands. Each packet waits four
  ; GB frames; repeated pings are harmless when launched from an already-live OS.
  ld b, 8
.settle
  push bc
  ld hl, Ping
  call _sgb_PacketTransfer
  pop bc
  dec b
  jr nz, .settle
  ld hl, TwoPlayers
  call _sgb_PacketTransfer
  ld a, $30
  ldh [rP1], a
REPT 6
  ldh a, [rP1]
ENDR
  ld b, a
  ld a, $10
  ldh [rP1], a
  ld a, $30
  ldh [rP1], a
REPT 6
  ldh a, [rP1]
ENDR
  cp b
  jr nz, .detected
  ld a, $E0                 ; no SGB: retain checkerboard
  ld [PHASE], a
.unsupported
  jr .unsupported
.detected
  ld a, 1
  ld [PHASE], a
  ld hl, OnePlayer
  call _sgb_PacketTransfer
  ld hl, Freeze
  call _sgb_PacketTransfer
  call LCDOff
  ld hl, Payload
  ld de, $8800
  ld bc, 4096
.copy
  ld a, [hli]
  ld [de], a
  inc de
  dec bc
  ld a, b
  or c
  jr nz, .copy
  ld hl, $9800
  ld de, 12
  ld a, $80
  ld c, 13
.row
  ld b, 20
.column
  ld [hli], a
  inc a
  dec b
  jr nz, .column
  add hl, de
  dec c
  jr nz, .row
  ld a, LCDCF_ON | LCDCF_BGON
  ldh [rLCDC], a
  ld a, 2
  ld [PHASE], a
  ; Let capture finish a complete LCD frame before requesting the 4 KiB copy.
  ld hl, Ping
  call _sgb_PacketTransfer
  ld hl, Transfer
  call _sgb_PacketTransfer
  ld a, 3
  ld [PHASE], a
  ld hl, Jump
  call _sgb_PacketTransfer
  ld a, 4
  ld [PHASE], a
.reply
  ld a, $20
  ldh [rP1], a
REPT 6
  ldh a, [rP1]
ENDR
  and 15
  ld b, a
  ld a, $10
  ldh [rP1], a
REPT 6
  ldh a, [rP1]
ENDR
  and 15
  swap a
  or b
  ld [REPLY], a
  cp $A5
  jr nz, .reply
  ld a, 5
  ld [PHASE], a
.done
  jr .done

LCDOff:
  ldh a, [rLCDC]
  bit 7, a
  ret z
.wait
  ldh a, [rLY]
  cp 144
  jr c, .wait
  xor a
  ldh [rLCDC], a
  ret

INCLUDE "src/sgb/packet.asm"
Ping: DB (SGB_CODE_PAL_PRI << 3) | 1, 1
  DS 14
TwoPlayers: DB (SGB_CODE_MLT_REQ << 3) | 1, 1
  DS 14
OnePlayer: DB (SGB_CODE_MLT_REQ << 3) | 1, 0
  DS 14
Freeze: DB (SGB_CODE_MASK_EN << 3) | 1, 1
  DS 14
Transfer: DB (SGB_CODE_DATA_TRN << 3) | 1, 0, 0, $7F
  DS 12
Jump: DB (SGB_CODE_JUMP << 3) | 1
  DW HELLO_ENTRY & $FFFF
  DB HELLO_ENTRY >> 16
  DW HELLO_NMI & $FFFF
  DB HELLO_NMI >> 16
  DS 9
Payload: INCBIN "build/sgb/hello.bin"
ASSERT @-Payload == 4096
