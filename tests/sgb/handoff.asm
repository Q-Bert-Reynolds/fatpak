SECTION "Handoff GB", ROM0
Handoff:
  call LCDOff
  ld hl, $9800
  ld bc, 1024
.map
  ld a, $80
  ld [hli], a
  dec bc
  ld a, b
  or c
  jr nz, .map
  ld hl, $8800
  ld b, 8
.tile
  ld a, $55
  ld [hli], a
  cpl
  ld [hli], a
  dec b
  jr nz, .tile
  ld a, LCDCF_ON | LCDCF_BGON
  ldh [rLCDC], a
  ; This packet waits in ICD2 until the stub returns to the BIOS.
  ld hl, Cancel
  call _sgb_PacketTransfer
.poll
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
  ld [$C102], a
  jr .poll
Cancel: DB (SGB_CODE_MASK_EN << 3) | 1, 0
  DS 14
