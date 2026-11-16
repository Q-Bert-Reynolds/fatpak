INCLUDE "src/hardware.inc"
; Plain 32 KiB ROM: test the production SNES bridge and P1 reader in Mesen.
INCLUDE "build/drivers/mouse_stop.inc"
; Exercise real BIOS packet decoding with LCD interrupts stretching P1 pulses.
SECTION "LCD vector", ROM0[$48]
  jp Raster
SECTION "Header", ROM0[$100]
  nop
  jp Main
  ds $150-@,0
SECTION "Test", ROM0[$150]
Main:
  di
  ld sp,$DFFF
  xor a
  ldh [$FFFF],a
  ld hl,$C100
  ld b,10
.clear
  ld [hli],a
  dec b
  jr nz,.clear
  ld a,$91
  ldh [rLCDC],a
  xor a
  ldh [rLYC],a
  ld a,STATF_LYC
  ldh [rSTAT],a
  ld a,IEF_STAT
  ldh [rIE],a
  ei
  ; Allow the SGB intro to finish before the first meaningful command.
  ld b,8
.settle
  push bc
  ld hl,Ping
  call Send
  pop bc
  dec b
  jr nz,.settle
  ld hl,Upload
  ld b,(UploadEnd-Upload)/16
.upload
  push bc
  call Send
  pop bc
  dec b
  jr nz,.upload
.loop
  ld a,[$C106]
  cp 1
  jr nz,.poll
  ld hl,StopPacket
  call Send
  ld hl,Ping
  call Send
  ld a,2
  ld [$C106],a
  jr .loop
.poll
  ld a,[$C107]
  and a
  jp nz,.loop
  call SNESMouseRead
  ld a,b
  cp e
  jr nz,.loop
  bit 7,a
  jr nz,.loop
  ld hl,$C100
  cp [hl]
  jr z,.pad
  ld a,b
  and 6
  ld hl,$C103
  or [hl]
  ld [hl],a
  ld hl,$C100
  ld a,b
  ld [hli],a
  ld [hl],c
  inc hl
  ld [hl],d
  ld hl,AckPacket
  call FastSend
  call SNESMouseSelectOne
.pad
  ; Pad 1 must remain available between mailbox reads.
  ld a,$20
  ldh [$FF00],a
REPT 6
  ldh a,[$FF00]
ENDR
  and 15
  swap a
  ld b,a
  ld a,$10
  ldh [$FF00],a
REPT 6
  ldh a,[$FF00]
ENDR
  and 15
  or b
  cpl
  ld [$C105],a
  jr .loop
Raster:
  push af
  push bc
  push hl
  ld hl,$C108
  inc [hl]
  jr nz,.counted
  inc hl
  inc [hl]
.counted
  ldh a,[rLYC]
  add 8
  cp 144
  jr c,.next
  xor a
.next
  ldh [rLYC],a
  ld b,20
.wait
  dec b
  jr nz,.wait
  pop hl
  pop bc
  pop af
  reti
INCLUDE "src/sgb/mouse_input.asm"
INCLUDE "src/sgb/mouse_select.asm"
INCLUDE "src/sgb/input_irq.asm"
; Same wire timing as the host's _sgb_PacketTransfer.
Send:
  ld c,1
  jr SendBegin
FastSend:
  ld c,0
SendBegin:
  call SGBInputBegin
  push af
  xor a
  ldh [$FF00],a
  ld a,$30
  ldh [$FF00],a
  ld b,16
.byte
  ld e,8
  ld a,[hli]
  ld d,a
.bit
  bit 0,d
  ld a,$10
  jr nz,.one
  ld a,$20
.one
  ldh [$FF00],a
  ld a,$30
  ldh [$FF00],a
  rr d
  dec e
  jr nz,.bit
  dec b
  jr nz,.byte
  ld a,$20
  ldh [$FF00],a
  ld a,$30
  ldh [$FF00],a
  ld a,c
  and a
  jr z,.done
  ld de,7000
.wait
  nop
  nop
  nop
  dec de
  ld a,d
  or e
  jr nz,.wait
.done
  pop af
  jp SGBInputEnd
AckPacket: DB $79,$f0,$1f,0,1,1
  DS 10
Ping: DB $c9,1
  DS 14
StopPacket: DB $79,0,8,0,3,$4c
  DW SGB_MOUSE_STOP
  DS 8
Upload: INCBIN "build/drivers/mouse.packets"
UploadEnd:
