INCLUDE "src/fatpak.inc"

SECTION "SD Test", ROMX

SDOKText:         DB "SD OK", 0
SDInitErrorText:  DB "SD INIT ERROR", 0
SDReadErrorText:  DB "SD READ ERROR", 0
SDWriteErrorText: DB "SD WRITE ERROR", 0
SDBadMBRText:     DB "SD BAD MBR", 0
SDBadFATText:     DB "SD NOT FAT32", 0
SDBadWriteText:   DB "SD WRITE MISMATCH", 0
SDFAT32:          DB "FAT32"

;inits card, checks MBR and FAT32 boot sector, writes and reads back sector 1
SDTest::
  DISPLAY_OFF
  TRAMPOLINE UILoadFontTiles
  CLEAR_SCREEN ' '
  DISPLAY_ON

  call _sd_Init
  and a
  ld hl, SDInitErrorText
  jp nz, .show

.readMBR
  xor a
  ld hl, _sd_sector
REPT 4
  ld [hli], a
ENDR
  ld de, tile_buffer
  call _sd_ReadSector
  and a
  ld hl, SDReadErrorText
  jp nz, .show
  ld hl, SDBadMBRText
  ld a, [tile_buffer+510]
  cp a, $55
  jp nz, .show
  ld a, [tile_buffer+511]
  cp a, $AA
  jp nz, .show

.readBootSector;first partition's LBA
  ld hl, tile_buffer+$1C6
  ld de, _sd_sector
  ld bc, 4
  call mem_Copy
  ld de, tile_buffer
  call _sd_ReadSector
  and a
  ld hl, SDReadErrorText
  jp nz, .show
  ld hl, tile_buffer+$52
  ld de, SDFAT32
  ld b, 5
.checkFAT32
    ld a, [de]
    cp a, [hl]
    jr nz, .notFAT32
    inc hl
    inc de
    dec b
    jr nz, .checkFAT32
  jr .writeSector
.notFAT32
  ld hl, SDBadFATText
  jp .show

.writeSector;pattern to sector 1, which is unused before the partition
  ld hl, _sd_sector
  ld a, 1
  ld [hli], a
  xor a
REPT 3
  ld [hli], a
ENDR
  ld hl, tile_buffer
  ld bc, 512
.fillPattern
    ld a, c
    xor a, b
    ld [hli], a
    dec bc
    ld a, b
    or a, c
    jr nz, .fillPattern
  ld de, tile_buffer
  call _sd_WriteSector
  and a
  ld hl, SDWriteErrorText
  jp nz, .show
  ld de, tile_buffer+512
  call _sd_ReadSector
  and a
  ld hl, SDReadErrorText
  jp nz, .show
  ld hl, tile_buffer
  ld de, tile_buffer+512
  ld bc, 512
.compare
    ld a, [de]
    cp a, [hl]
    jr nz, .mismatch
    inc hl
    inc de
    dec bc
    ld a, b
    or a, c
    jr nz, .compare
  ld hl, SDOKText
  jp .show
.mismatch
  ld hl, SDBadWriteText

.show
  push hl
  call str_Length
  ld h, e
  ld l, 1
  ld de, 0
  pop bc
  call gbdk_SetBkgTiles
.wait
    call gbdk_WaitVBL
    call UpdateInput
    ldh a, [button_state]
    and a, PADF_A | PADF_START
    jr z, .wait
  jp WaitPadUp


;read only EverDrive X diagnostics. For each way of reaching the registers (rRAMG while writing the
;key, rRAMG while using them, 0 or $0A) it writes $5A then $A1 to $BD01 and shows what reads back
;(a register keeps only its bits, SRAM echoes both, open bus reads $BD) and $BD06. Where the
;registers respond it inits
;the card and reads the MBR with $BD06 left alone (D-) or set to $04 like the OS's in game code (D4)
DEF EDX_STREAM EQU $BD06
DEF EDX_KEY_REG EQU $BD0A
DEF EDX_CTRL EQU $BD01

SECTION "SD Diag Vars", WRAM0
sd_diag_row: DB
sd_diag_set: DB
sd_diag_bd06: DB
sd_diag_ok: DS 4;1 if the registers responded for that variant

SECTION "SD Diag", ROMX

SDDiagTitle:   DB "SD DIAGNOSTIC 2", 0
SDDiagLegend1: DB "KEY USE 5A A1 06", 0
SDDiagLegend2: DB "KEY USE D  I C0 C8 M", 0
SDDiagNone:    DB "NO REGISTERS", 0
SDDiagDone:    DB "A: CONTINUE", 0
SDDiagVariants: DB 0, 0, $0A, $0A, $0A, 0, 0, $0A;sd_ramg_key, sd_ramg

;hl = text, copies it to str_buffer, returns hl after it
SDDiagText:
  ld de, str_buffer
.copy
    ld a, [hli]
    and a
    jr z, .done
    ld [de], a
    inc de
    jr .copy
.done
  ld h, d
  ld l, e
  ret

;a = byte, writes 2 hex digits at hl and a space
SDDiagHex:
  push af
  swap a
  call .digit
  pop af
  call .digit
  ld [hl], ' '
  inc hl
  ret
.digit
  and a, $0F
  add a, '0'
  cp a, '9'+1
  jr c, .put
  add a, 'A'-'9'-1
.put
  ld [hli], a
  ret

;hl = end of text in str_buffer, draws str_buffer on the next row
SDDiagLine:
  ld [hl], 0
  ld hl, str_buffer
  call str_Length
  ld h, e
  ld l, 1
  ld a, [sd_diag_row]
  ld e, a
  inc a
  ld [sd_diag_row], a
  ld d, 0
  ld bc, str_buffer
  jp gbdk_SetBkgTiles

;writes "G0  " or "GA  " for a = rRAMG value at hl
SDDiagRAMG:
  ld [hl], 'G'
  inc hl
  and a
  ld a, '0'
  jr z, .put
  ld a, 'A'
.put
  ld [hli], a
  ld [hl], ' '
  inc hl
  ld [hl], ' '
  inc hl
  ret

;hl = str_buffer, writes the variant's key and use rRAMG values
SDDiagVariantName:
  ld a, [sd_ramg_key]
  call SDDiagRAMG
  ld a, [sd_ramg]
  jp SDDiagRAMG

SDDiagLock:
  ld a, $0A
  ld [rRAMG], a
  xor a
  ld [EDX_KEY_REG], a
  ld [rRAMG], a
  ld [EDX_KEY_REG], a
  ret

;readback test for the variant in sd_ramg_key/sd_ramg, returns nz if the registers responded
SDDiagReadback:
  call SDDiagLock
  ld hl, str_buffer
  call SDDiagVariantName
  call SDRegsOn
  ld a, $5A
  ld [EDX_CTRL], a
  ld a, [EDX_CTRL]
  ld b, a
  call SDDiagHex
  ld a, $A1
  ld [EDX_CTRL], a
  ld a, [EDX_CTRL]
  ld c, a
  call SDDiagHex
  ld a, [EDX_STREAM]
  ld [sd_diag_bd06], a
  call SDDiagHex
  ld a, $03;deselected, slow
  ld [EDX_CTRL], a
  call SDDiagLock
  push bc
  call SDDiagLine
  pop bc
  ld a, b;register: bits 0-2 of $5A and $A1 read back, but not both whole bytes (SRAM)
  and a, %111
  cp a, $02
  jr nz, .no
  ld a, c
  and a, %111
  cp a, $01
  jr nz, .no
  ld a, b
  cp a, $5A
  jr nz, .yes
  ld a, c
  cp a, $A1
  jr z, .no
.yes
  ld a, 1
  and a
  ret
.no
  xor a
  ret

;init and MBR read for the variant, b = 1 to set $BD06 to $04 first
SDDiagInit:
  ld a, b
  ld [sd_diag_set], a
  and a
  jr z, .init
  call SDRegsOn
  ld a, [EDX_STREAM]
  ld [sd_diag_bd06], a
  ld a, $04
  ld [EDX_STREAM], a
  call SDDiagLock
.init
  ld a, $EE
  ld [sd_r1], a
  ld [sd_r1+1], a
  call _sd_Init
  ld b, a;0 = ready
  ld c, '-';MBR: - not read, R read error, N no signature, K ok
  and a
  jr nz, .show
  ld hl, _sd_sector
  xor a
REPT 4
  ld [hli], a
ENDR
  push bc
  ld de, tile_buffer
  call _sd_ReadSector
  pop bc
  ld c, 'R'
  and a
  jr nz, .show
  ld c, 'N'
  ld a, [tile_buffer+510]
  cp a, $55
  jr nz, .show
  ld a, [tile_buffer+511]
  cp a, $AA
  jr nz, .show
  ld c, 'K'
.show
  push bc
  ld a, [sd_diag_set];put $BD06 back
  and a
  jr z, .print
  call SDRegsOn
  ld a, [sd_diag_bd06]
  ld [EDX_STREAM], a
.print
  call SDDiagLock
  ld hl, str_buffer
  call SDDiagVariantName
  ld [hl], 'D'
  inc hl
  ld a, [sd_diag_set]
  and a
  ld a, '-'
  jr z, .d
  ld a, '4'
.d
  ld [hli], a
  ld [hl], ' '
  inc hl
  pop bc
  ld a, b
  and a
  ld a, 'Y'
  jr z, .i
  ld a, 'N'
.i
  ld [hli], a
  ld [hl], ' '
  inc hl
  ld a, [sd_r1]
  call SDDiagHex
  ld a, [sd_r1+1]
  call SDDiagHex
  ld [hl], c
  inc hl
  jp SDDiagLine

;a = variant 0-3, sets sd_ramg_key and sd_ramg
SDDiagSetVariant:
  add a, a
  ld hl, SDDiagVariants
  add a, l
  ld l, a
  adc a, h
  sub a, l
  ld h, a
  ld a, [hli]
  ld [sd_ramg_key], a
  ld a, [hl]
  ld [sd_ramg], a
  ret

SDDiag::
  DISPLAY_OFF
  TRAMPOLINE UILoadFontTiles
  CLEAR_SCREEN ' '
  DISPLAY_ON
  xor a
  ld [sd_diag_row], a
  ld hl, SDDiagTitle
  call SDDiagText
  call SDDiagLine
  ld hl, SDDiagLegend1
  call SDDiagText
  call SDDiagLine

  ld c, 0
.readback
    push bc
    ld a, c
    call SDDiagSetVariant
    call SDDiagReadback
    pop bc
    ld hl, sd_diag_ok
    ld b, 0
    add hl, bc
    ld [hl], a
    inc c
    ld a, c
    cp a, 4
    jr nz, .readback

  ld hl, SDDiagLegend2
  call SDDiagText
  call SDDiagLine
  ld e, 0;any variant responded
  ld c, 0
.inits
    ld hl, sd_diag_ok
    ld b, 0
    add hl, bc
    ld a, [hl]
    and a
    jr z, .next
    inc e
    push bc
    push de
    ld a, c
    call SDDiagSetVariant
    ld b, 0
    call SDDiagInit
    pop de
    pop bc
    push bc
    push de
    ld a, c
    call SDDiagSetVariant
    ld b, 1
    call SDDiagInit
    pop de
    pop bc
.next
    inc c
    ld a, c
    cp a, 4
    jr nz, .inits
  ld a, e
  and a
  jr nz, .done
  ld hl, SDDiagNone
  call SDDiagText
  call SDDiagLine

.done
  xor a
  ld [sd_ramg], a
  ld [sd_ramg_key], a
  ld [rRAMG], a
  ld a, [sd_diag_row]
  inc a
  ld [sd_diag_row], a
  ld hl, SDDiagDone
  call SDDiagText
  call SDDiagLine
.wait
    call gbdk_WaitVBL
    call UpdateInput
    ldh a, [button_state]
    and a, PADF_A | PADF_START
    jr z, .wait
  jp WaitPadUp
