INCLUDE "src/text_editor.inc"

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
