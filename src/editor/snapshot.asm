; Stock 82KiB SAVE image. Capture/restore executes in an OS page and uses only
; the resident stack until the game's WRAM/HRAM has been captured/restored.
DEF SNAPSHOT_PAGE EQU 12
DEF SNAPSHOT_FIRST EQU $3E40
DEF SNAPSHOT_SECTORS EQU $A4
DEF SNAPSHOT_STAGE EQU $3C00

SECTION "Snapshot dispatch", ROM0
SnapshotCaptureGame:
  ld a, SNAPSHOT_PAGE
  ld [EDX_PAGE], a
  jp SnapshotCapture
SnapshotCaptureDone:
  ld a, INGAME_PAGE
  ld [EDX_PAGE], a
  ret
SnapshotRestoreGame:
  di
  ld sp, ingame_stack_end
  ld a, SNAPSHOT_PAGE
  ld [EDX_PAGE], a
  jp SnapshotRestore

SECTION "Snapshot counters", ROM0
snapshot_svbk: DB 0
snapshot_ocps: DB 0
snapshot_sector: DB 0
snapshot_direction: DB 0
snapshot_count: DB 0

PAGE SNAPSHOT_PAGE
SnapshotCapture:
  ldh a, [rSVBK]
  ld [snapshot_svbk], a
  ldh a, [rOCPS]
  ld [snapshot_ocps], a
  ld a, $3E
  ld [EDX_BLOCK+1], a
  ld a, $40
  ld [EDX_BLOCK], a
  ld d, SNAPSHOT_SECTORS
.clear
  ld hl, $BE00
  ld bc, 512
  call SnapshotZero
  call SnapshotNext
  dec d
  jr nz, .clear
  ld a, $40
  ld [EDX_BLOCK], a
  ld hl, $BE00
  ld [hl], 'S'
  inc hl
  ld [hl], 'A'
  inc hl
  ld [hl], 'V'
  inc hl
  ld [hl], 'E'
  inc hl
  ld de, ingame_sp
  ld b, 6;SP, followed by the four mapper bytes
.header
  ld a, [de]
  inc de
  ld [hli], a
  dec b
  jr nz, .header
  ld [hl], 'G';optional extension, ignored by the stock OS
  inc hl
  ld [hl], 'B'
  inc hl
  ld [hl], 1
  inc hl
  ld a, [menu_cgb]
  ld [hl], a
  ld a, 1
  ldh [rSVBK], a
  xor a
  ldh [rVBK], a
  ld a, $41
  ld [EDX_BLOCK], a
  ld hl, $8000
  ld b, 16
  call SnapshotOut
  ld hl, $C000
  ld b, 16
  call SnapshotOut
  ld hl, $FE00
  ld b, 1
  call SnapshotOut
  ld a, $61
  ld [EDX_BLOCK], a
  ld a, [menu_lcdc]
  ld [$BF40], a
  ld a, [menu_vbk]
  ld [$BF4F], a
  ld a, [snapshot_svbk]
  ld [$BF70], a
  ld a, [menu_bcps]
  ld [$BF68], a
  ld a, [snapshot_ocps]
  ld [$BF6A], a
  xor a
  ld [snapshot_direction], a
  call SnapshotCartRAM
  ld a, [menu_cgb]
  and a
  jr z, .services
  ld a, $A2
  ld [EDX_BLOCK], a
  ld hl, $BE00
  ld c, 0
.palette
  ld a, c
  ldh [rBCPS], a
  ldh a, [rBCPD]
  ld [hli], a
  inc c
  bit 6, c
  jr z, .palette
  ld c, 0
.objects
  ld a, c
  ldh [rOCPS], a
  ldh a, [rOCPD]
  ld [hli], a
  inc c
  bit 6, c
  jr z, .objects
  call SnapshotNext
  ld a, 1
  ldh [rVBK], a
  ld hl, $8000
  ld b, 16
  call SnapshotOut
  ld a, 2
.bank
  ldh [rSVBK], a
  ld hl, $D000
  ld b, 8
  call SnapshotOut
  ldh a, [rSVBK]
  and a, 7
  inc a
  cp a, 8
  jr nz, .bank
.services
  xor a
  ldh [rVBK], a
  ldh [rIE], a
  ldh [rIF], a
  ldh [rTAC], a
  ldh [rSC], a
  ldh [rNR51], a
  ld a, 1
  ldh [rSVBK], a
  ld hl, $C000
  ld bc, $2000
  call SnapshotZero
  ld hl, $FF80
  ld bc, $7F
  call SnapshotZero
  ld a, [menu_cgb]
  add a, a
  ldh [sys_info], a
  ld a, INGAME_PAGE
  ldh [loaded_bank], a
  ld a, LOW(MENU_BLOCK)
  ld [EDX_BLOCK], a
  jp SnapshotCaptureDone

SnapshotRestore:
  xor a
  ldh [rLCDC], a
  ldh [rVBK], a
  ld a, 1
  ldh [rSVBK], a
  ld [snapshot_direction], a
  call SnapshotCartRAM
  ld a, $3E
  ld [EDX_BLOCK+1], a
  ld a, $40
  ld [EDX_BLOCK], a
  ld hl, $BE04
  ld de, ingame_sp
  ld bc, 6
  call SnapshotCopy
  ld a, $41
  ld [EDX_BLOCK], a
  ld de, $8000
  ld b, 16
  call SnapshotIn
  ld de, $C000
  ld b, 16
  call SnapshotIn
  ld a, [menu_cgb]
  and a
  jr z, .io
  ld a, $61
  ld [EDX_BLOCK], a
  ldh a, [rKEY1]
  ld hl, $BF4D
  xor a, [hl]
  and a, $80
  jr z, .speed
  ld a, 1
  ldh [rKEY1], a
  stop
.speed
  ld a, $A2
  ld [EDX_BLOCK], a
  ld hl, $BE00
  ld c, 0
.palette
  ld a, c
  ldh [rBCPS], a
  ld a, [hli]
  ldh [rBCPD], a
  inc c
  bit 6, c
  jr z, .palette
  ld c, 0
.objects
  ld a, c
  ldh [rOCPS], a
  ld a, [hli]
  ldh [rOCPD], a
  inc c
  bit 6, c
  jr z, .objects
  call SnapshotNext
  ld a, 1
  ldh [rVBK], a
  ld de, $8000
  ld b, 16
  call SnapshotIn
  ld a, 2
.bank
  ldh [rSVBK], a
  ld de, $D000
  ld b, 8
  call SnapshotIn
  ldh a, [rSVBK]
  and a, 7
  inc a
  cp a, 8
  jr nz, .bank
.io
  ld a, $61
  ld [EDX_BLOCK], a
  ld hl, $BE00
  ld de, $FE00
  ld bc, 160
  call SnapshotCopy
  ld hl, $BF80
  ld de, $FF80
  ld bc, 127
  call SnapshotCopy
  ld de, SnapshotIORegisters
.register
  ld a, [de]
  inc de
  and a
  jr z, .mapper
  ld c, a
  ld l, a
  ld h, $BF
  ld a, [hl]
  ldh [c], a
  jr .register
.mapper
  ld hl, ingame_mbc
  ld a, [hli]
  ld b, a
  ld a, [hli]
  ld c, a
  ld a, [hli]
  ld d, a
  ld e, [hl]
  jp InGameResume

SnapshotCartRAM:
  xor a
  ld [snapshot_sector], a
  ld a, [os_snapshot_use_32k_ram]
  and a
  ld a, 16
  jr z, .count
  ld a, 64
.count
  ld [snapshot_count], a
.loop
  ld a, [snapshot_sector]
  ld c, a
  ld a, [snapshot_direction]
  and a
  ld a, c
  jr z, .readCart
  add a, $62
  ld [EDX_BLOCK], a
  ld a, $3E
  ld [EDX_BLOCK+1], a
  ld a, 4
  jr .read
.readCart
  ld [EDX_BLOCK], a
  xor a
  ld [EDX_BLOCK+1], a
  ld a, 6
.read
  ld [EDX_CONFIG], a
  ld hl, $BE00
  ld de, $C000
  ld bc, 512
  call SnapshotCopy
  ld a, [snapshot_sector]
  ld c, a
  ld a, [snapshot_direction]
  and a
  ld a, c
  jr z, .writeSnapshot
  ld [EDX_BLOCK], a
  xor a
  ld [EDX_BLOCK+1], a
  ld a, 6
  jr .write
.writeSnapshot
  add a, $62
  ld [EDX_BLOCK], a
  ld a, $3E
  ld [EDX_BLOCK+1], a
  ld a, 4
.write
  ld [EDX_CONFIG], a
  ld hl, $C000
  ld de, $BE00
  ld bc, 512
  call SnapshotCopy
  ld hl, snapshot_sector
  inc [hl]
  ld a, [hl]
  ld hl, snapshot_count
  cp a, [hl]
  jr nz, .loop
  ld a, 4
  ld [EDX_CONFIG], a
  ld a, $3E
  ld [EDX_BLOCK+1], a
  ret

;B sectors, HL source / DE destination. Maximum capture stack use: 8 bytes.
SnapshotOut:
  push bc
  ld de, $BE00
  ld bc, 512
  call SnapshotCopy
  pop bc
  call SnapshotNext
  dec b
  jr nz, SnapshotOut
  ret
SnapshotIn:
  push bc
  ld hl, $BE00
  ld bc, 512
  call SnapshotCopy
  pop bc
  call SnapshotNext
  dec b
  jr nz, SnapshotIn
  ret
SnapshotNext:
  ld a, [EDX_BLOCK]
  inc a
  ld [EDX_BLOCK], a
  ret
SnapshotCopy:
  ld a, [hli]
  ld [de], a
  inc de
  dec bc
  ld a, b
  or a, c
  jr nz, SnapshotCopy
  ret
SnapshotZero:
  xor a
  ld [hli], a
  dec bc
  ld a, b
  or a, c
  jr nz, SnapshotZero
  ret

;Stock restore list: preserve write-only sound frequency state on the chip.
;LCD and bank selectors go last, after VRAM, OAM and HRAM are restored.
SnapshotIORegisters:
  DB LOW(rAUDENA)
  DB LOW(rAUDTERM)
  DB LOW(rDIV)
  DB LOW(rTIMA)
  DB LOW(rTMA)
  DB LOW(rTAC)
  DB LOW(rAUD1SWEEP)
  DB LOW(rAUD1LEN)
  DB LOW(rAUD1ENV)
  DB LOW(rAUD2LEN)
  DB LOW(rAUD2ENV)
  DB LOW(rAUD3ENA)
  DB LOW(rAUD3LEN)
  DB LOW(rAUD3LEVEL)
  DB LOW(rAUD4LEN)
  DB LOW(rAUD4ENV)
  DB LOW(rAUD4POLY)
  DB LOW(rAUD4GO)
  DB LOW(rAUDVOL)
  DB LOW(rSTAT)
  DB LOW(rSCY)
  DB LOW(rSCX)
  DB LOW(rLYC)
  DB LOW(rBGP)
  DB LOW(rOBP0)
  DB LOW(rOBP1)
  DB LOW(rWY)
  DB LOW(rWX)
FOR N, 16
  DB LOW(_AUD3WAVERAM+N)
ENDR
  DB LOW(rBCPS)
  DB LOW(rOCPS)
  DB LOW(rVBK)
  DB LOW(rSVBK)
  DB LOW(rLCDC)
  DB LOW(rIE)
  DB LOW(rIF)
  DB 0
END_PAGE
