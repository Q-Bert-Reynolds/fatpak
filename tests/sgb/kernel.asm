INCLUDE "src/hardware.inc"
INCLUDE "src/sgb/commands.asm"
INCLUDE "build/sgb/replay.inc"
DEF Stage EQU $C100
DEF Upload EQU $C110
DEF CurrentPage EQU $C111
DEF Event EQU $C112
DEF Ack EQU $C113
DEF Frame EQU $C114
DEF LastLY EQU $C116
DEF Status EQU $C120
DEF Mail EQU $C140
SECTION "Header",ROM0[$100]
 nop
 jp Main
 ds $150-@,0
SECTION "Code",ROM0[$150]
Main:
 di
 ld sp,$DFFF
 xor a
 ldh [rIE],a
 ldh [rIF],a
 ld hl,$C100
 ld bc,256
.zero
 ld [hli],a
 dec bc
 ld a,b
 or c
 jr z,.cleared
 xor a
 jr .zero
.cleared
 ld a,(SGB_CODE_DATA_TRN<<3)|1
 ld [Transfer],a
 ld a,$7F
 ld [Transfer+3],a
 call Off
 ld hl,$8000
 ld bc,$2000
.clear
 xor a
 ld [hli],a
 dec bc
 ld a,b
 or c
 jr nz,.clear
 ld a,$E4
 ldh [rBGP],a
 ld a,$81
 ldh [rLCDC],a
 ld b,8
.settle
 push bc
 ld hl,Ping
 call _sgb_PacketTransfer
 pop bc
 dec b
 jr nz,.settle
 ld hl,Freeze
 call _sgb_PacketTransfer
 ld a,1
 ld [Stage],a
.upload
 call Off
 ld a,[Upload]
 srl a
 srl a
 add 1
 ld [$2000],a
 ld a,[Upload]
 and 3
 swap a
 add $40
 ld h,a
 ld l,0
 ld de,$8800
 ld bc,4096
.copy
 ld a,[hli]
 ld [de],a
 inc de
 dec bc
 ld a,b
 or c
 jr nz,.copy
 ld hl,$9800
 ld de,12
 ld a,$80
 ld c,13
.row
 ld b,20
.col
 ld [hli],a
 inc a
 dec b
 jr nz,.col
 add hl,de
 dec c
 jr nz,.row
 ld a,$81
 ldh [rLCDC],a
 ld hl,Ping
 call _sgb_PacketTransfer
 ld a,[Upload]
 swap a
 and $F0
 ld [Transfer+2],a
 ld hl,Transfer
 call _sgb_PacketTransfer
 ld hl,Upload
 inc [hl]
 ld a,[hl]
 cp UPLOAD_COUNT
 jp c,.upload
 call Off
 ld hl,$8000
 ld bc,$2000
.transportClear
 xor a
 ld [hli],a
 dec bc
 ld a,b
 or c
 jr nz,.transportClear
 ld hl,$9800
 ld bc,1024
.blank
 ld a,$FF
 ld [hli],a
 dec bc
 ld a,b
 or c
 jr nz,.blank
 ld hl,$9800
 xor a
 ld c,12
.trRow
 ld b,20
.trCol
 ld [hli],a
 inc a
 dec b
 jr nz,.trCol
 ld de,12
 add hl,de
 dec c
 jr nz,.trRow
 ld b,16
.status
 ld [hli],a
 inc a
 dec b
 jr nz,.status
 ld a,$91
 ldh [rLCDC],a
 ld hl,Jump
 call _sgb_PacketTransfer
 ld a,2
 ld [Stage],a
.hello
 call Poll
 ld a,[Mail+1]
 cp 5
 jr nz,.hello
 ld a,3
 ld [Stage],a
.send
 ld a,[CurrentPage]
 and 7
 add a
 add a
 add a
 add $40
 ld h,a
 ld l,0
 ld a,[CurrentPage]
 srl a
 srl a
 srl a
 add FIRST_PAGE_BANK
 ld [$2000],a
 ld a,[hl]
 push af
 xor a
 ld de,$8000
 call Store
 inc hl
 inc de
 push hl
 ld a,[hli]
 ld c,a
 ld a,[hl]
 ld b,a
 inc bc
 inc bc
 inc bc
 inc bc
 pop hl
.page
 ld a,[hli]
 call Store
 inc de
 dec bc
 ld a,b
 or c
 jr nz,.page
 pop af
 ld de,$8000
 call Store
 ld [Ack],a
.waitAck
 call Poll
 ld a,[Mail+1]
 cp 6
 jr nz,.waitAck
 ld a,[Mail+3]
 ld hl,Ack
 cp [hl]
 jr nz,.waitAck
 ld hl,CurrentPage
 inc [hl]
 ld a,[hl]
IF DEF(UI_REPLAY)
 cp 102
 jr c,.noPause
 ld a,[Frame]
 ld b,a
.pause
 push bc
 call Poll
 pop bc
 ld a,[Frame]
 sub b
 cp 200
 jr c,.pause
.noPause
 ld a,[CurrentPage]
ENDC
 cp PAGE_COUNT
 jr c,.send
 ld a,6
 ld [Stage],a
.done
 call Poll
 jr .done
Off:
 ldh a,[rLCDC]
 bit 7,a
 ret z
.wait
 ldh a,[rLY]
 cp 144
 jr c,.wait
 xor a
 ldh [rLCDC],a
 ret
Store:
 push af
.wait
 ldh a,[rSTAT]
 and 3
 cp 2
 jr nc,.wait
 pop af
 ld [de],a
 ret
; CRC status publication and stable four-player mailbox read.
Poll:
 ldh a,[rLY]
 cp 144
 jr c,.mail
 ld a,[LastLY]
 and a
 jr nz,.mail
 ld a,1
 ld [LastLY],a
 ld hl,Frame
 inc [hl]
 jr nz,.frame
 inc hl
 inc [hl]
.frame
 ld hl,Status
 ld a,83
 ld [hli],a
 ld a,1
 ld [hli],a
 ld a,[Frame]
 ld [hli],a
 ld a,[Frame+1]
 ld [hli],a
 ld a,[Event]
 ld [hli],a
 xor a
 ld b,9
.zero
 ld [hli],a
 dec b
 jr nz,.zero
 ld hl,Status
 ld de,$FFFF
 ld c,14
.crcByte
 ld a,[hli]
 xor d
 ld d,a
 ld b,8
.crcBit
 sla e
 rl d
 jr nc,.noXor
 ld a,d
 xor $10
 ld d,a
 ld a,e
 xor $21
 ld e,a
.noXor
 dec b
 jr nz,.crcBit
 dec c
 jr nz,.crcByte
 ld a,e
 ld [hli],a
 ld [hl],d
 ld hl,Status
 ld de,$8F00
 ld b,16
.publish
 ld a,[hli]
 call Store
 inc de
 dec b
 jr nz,.publish
.mail
 ldh a,[rLY]
 cp 144
 jr nc,.select
 xor a
 ld [LastLY],a
.select
 ld a,$30
 ldh [rP1],a
 ld b,4
.find
 ldh a,[rP1]
 and 15
 cp 15
 jr z,.read
 ld a,$10
 ldh [rP1],a
 ld a,$30
 ldh [rP1],a
 dec b
 jr nz,.find
 ret
.read
 call Read
 ld c,a
 ld hl,Mail
 ld b,4
.bytes
 ld [hli],a
 ld a,$30
 ldh [rP1],a
 call Read
 dec b
 jr nz,.bytes
 cp c
 ret nz
 and a
 ret z
 bit 7,a
 ret nz
 ld [Event],a
 ret
Read:
 ld a,$20
 ldh [rP1],a
 REPT 6
 ldh a,[rP1]
 ENDR
 and 15
 ld e,a
 ld a,$10
 ldh [rP1],a
 REPT 6
 ldh a,[rP1]
 ENDR
 and 15
 swap a
 or e
 ret
INCLUDE "src/sgb/packet.asm"
Ping: db (SGB_CODE_PAL_PRI<<3)|1,1
 ds 14
Freeze: db (SGB_CODE_MASK_EN<<3)|1,1
 ds 14
Jump: db (SGB_CODE_JUMP<<3)|1,0,0,$7F,4,0,$7F,8,0,$7F
 ds 6
SECTION "Transfer packet",WRAM0[$C180]
Transfer: ds 16
