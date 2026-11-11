INCLUDE "src/fatpak.inc"

;   ModuleSwap                  copies a borrowed page to/from PSRAM and reads it back
;   ModuleSwapRAM               the same for a wide module's BSS region (the editor's WRAMX buffers)
;   ModuleEnter                 calls the installed module with module_context in de
;   ModuleAPIFar                the far call behind a wide module's cross-page thunks
;   ModuleABI                   the jump table modules call (build/modules/table.inc)

DEF MODULE_SECTORS EQU 15;14 full blocks and 256 bytes: PAGE_SIZE never reaches $BD00
ASSERT ADD_BLOCK + (ADD_MAX + 511) / 512 <= DATA_BLOCK
ASSERT $3C00 + $A4 <= DATA_BLOCK
ASSERT NAME_HISTORY_BLOCK + 16 <= MODULE_STAGE
ASSERT MODULE_STAGE + MODULE_SECTORS <= MODULE_BACKUP
ASSERT MODULE_STAGE2 == MODULE_STAGE + $20 && MODULE_BACKUP2 == MODULE_BACKUP + $20
ASSERT MODULE_STAGE3 == MODULE_STAGE + $40 && MODULE_BACKUP3 == MODULE_BACKUP + $40
ASSERT MODULE_BACKUP3 + MODULE_SECTORS <= MODULE_BSS_BACKUP
ASSERT MODULE_BSS_BACKUP + MODULE_BSS_SIZE / 512 <= MODULE_FAIL_BLOCK && MODULE_FAIL_BLOCK < $3E2F;game metadata (src/fatfs/fatfs.c GAME_META)
ASSERT HIGH(MODULE_STAGE) == HIGH(MODULE_BACKUP3 + MODULE_SECTORS - 1)
ASSERT MODULE_BSS_SIZE % 512 == 0 && LOW(MODULE_BSS) == 0
ASSERT MODULE_TABLE + 3 * MODULE_SLOTS <= $8000

SECTION "Module transfer state", WRAM0
module_operation: DB
module_sector: DB
module_pointer: DW
module_mismatch: DB
module_tries: DB
_module_fail:: DW;the first block that never read back: operation, sector (ShowModuleError)
_module_context:: DW;passed to the module's ModuleMain, 0 if its host gives none

FIXED "Module loader"
; A = 0 backup (page to MODULE_BACKUP), 1 install (MODULE_STAGE to page),
; 2 restore (MODULE_BACKUP to page); + 4 for the second page (MODULE_PAGE2, the
; blocks $20 higher), + 8 for the third (MODULE_PAGE3, $40 higher). Each block is
; compared after it's copied.
; Returns A=0 when everything read back, nonzero on a mismatch.
; Only resident LCD handling runs during transfer; no HDMA is initiated here.
_ModuleSwap::
  ld [module_operation], a
  call ModuleSwapBegin
  and 12
  rrca
  rrca
  add LOW(ModulePages)
  ld l, a
  adc HIGH(ModulePages)
  sub l
  ld h, a
  ld a, [hl]
  SET_BANK
  ei
  ld hl, $A000
  ST_HL_VAR module_pointer
.loop
  ld a, [module_operation]
  and 3
  cp 1
  ld a, LOW(MODULE_BACKUP)
  jr nz, .block
  ld a, LOW(MODULE_STAGE)
.block
  ld b, a
  ld a, [module_operation]
  and 12
  add a, a
  add a, a
  add a, a;$20 per page after the first
  add b
  ld b, a
  ld a, [module_sector]
  add b
  ld [EDX_BLOCK], a
  ld a, HIGH(MODULE_STAGE)
  ld [EDX_BLOCK+1], a
  ld bc, 512
  ld a, [module_sector]
  cp MODULE_SECTORS - 1
  jr nz, .count
  ld bc, PAGE_SIZE - (MODULE_SECTORS - 1) * 512
.count
  call ModuleSwapBlock
  cp MODULE_SECTORS
  jr c, .loop
  jp ModuleSwapEnd

; A = 0 saves the BSS region (MODULE_BSS) to MODULE_BSS_BACKUP and zeroes it for the
; module, 2 restores it. Returns A=0 when the copy read back.
_ModuleSwapRAM::
  or 16;so a failure reads 16 (save) or 18 (restore), apart from the pages
  ld [module_operation], a
  call ModuleSwapBegin
  ei
  ld hl, MODULE_BSS
  ST_HL_VAR module_pointer
.loop
  ld a, [module_sector]
  add LOW(MODULE_BSS_BACKUP)
  ld [EDX_BLOCK], a
  ld a, HIGH(MODULE_BSS_BACKUP)
  ld [EDX_BLOCK+1], a
  ld bc, 512
  call ModuleSwapBlock
  cp MODULE_BSS_SIZE / 512
  jr c, .loop
  ld a, [module_operation]
  and 3
  jp nz, ModuleSwapEnd
  ld a, [module_mismatch]
  or a
  jp nz, ModuleSwapEnd;the editor's buffers stay as they are
  ld hl, MODULE_BSS
  ld bc, MODULE_BSS_SIZE
  xor a
  call mem_Set
  jp ModuleSwapEnd

;disables everything but the LCD interrupt, saves the bank, $BD06 and the window block on
;the stack (under its return address) and starts the sector count, returns [module_operation] in a
ModuleSwapBegin:
  pop hl
  call RenderWaitDMA
  di
  ldh a, [rIE]
  push af
  and IEF_STAT
  ldh [rIE], a
  ldh a, [rIF]
  push af
  ldh a, [loaded_bank]
  push af
  ld a, [EDX_CONFIG]
  push af
  and ~2
  ld [EDX_CONFIG], a
  ld a, [EDX_BLOCK]
  push af
  ld a, [EDX_BLOCK+1]
  push af
  xor a
  ld [module_sector], a
  ld [module_mismatch], a
  ld a, [module_operation]
  jp hl

;copies bc bytes between [module_pointer] and the window (the window is the destination for
;operation 0), compares them, advances module_pointer and the sector, returns it in a
ModuleSwapBlock:
  ld a, 3;tries: a block that reads back wrong is copied again
  ld [module_tries], a
.again
  LD_HL_VAR module_pointer;source: the page when backing up
  ld de, EDX_WINDOW
  ld a, [module_operation]
  and 3
  jr z, .copy
  ld d, h;otherwise the window is the source
  ld e, l
  ld hl, EDX_WINDOW
.copy
  push bc
  push de
  push hl
  call mem_Copy
  pop hl
  pop de
  pop bc
  push bc
  call ModuleCompare
  pop bc
  jr z, .next
  ld hl, module_tries
  dec [hl]
  jr nz, .again
  ld a, [module_mismatch]
  and a
  jr nz, .next;keep the first failure
  inc a
  ld [module_mismatch], a
  ld a, [module_operation]
  ld [_module_fail], a
  ld a, [module_sector]
  ld [_module_fail+1], a
.next
  LD_HL_VAR module_pointer
  add hl, bc
  ST_HL_VAR module_pointer
  ld hl, module_sector
  inc [hl]
  ld a, [hl]
  ret

ModuleSwapEnd:
  di
  pop af
  ld [EDX_BLOCK+1], a
  pop af
  ld [EDX_BLOCK], a
  pop af
  ld [EDX_CONFIG], a
  pop af
  SET_BANK
  pop af
  ldh [rIF], a
  pop af
  ldh [rIE], a
  ei
  ld a, [module_mismatch]
  ret

;hl, de = 256-byte aligned data (the page and the window), b = 256-byte chunks > 0,
;returns z if they're the same. Only the low bytes step inside a chunk.
ASSERT LOW(EDX_WINDOW) == 0 && (PAGE_SIZE - (MODULE_SECTORS - 1) * 512) % 256 == 0
ModuleCompare:
  ld c, 256 / 8
.eight
REPT 8
  ld a, [de]
  inc e
  cp [hl]
  ret nz
  inc l
ENDR
  dec c
  jr nz, .eight
  inc d
  inc h
  dec b
  jr nz, ModuleCompare
  ret

;CRC-16/CCITT (polynomial $1021, as Python's binascii.crc_hqx), a byte at a time without a table:
;x = high ^ byte, x ^= x >> 4, crc = crc << 8 ^ x << 12 ^ x << 5 ^ x
;de = data, bc = count > 0, stack: crc; returns bc = crc and removes its stack argument
_ModuleCRC::
  ld hl, sp+2
  ld a, [hl+]
  ld h, [hl]
  ld l, a
.byte
  ld a, [de]
  inc de
  push de
  xor h
  ld d, a
  swap a
  and $0F
  xor d
  ld d, a;x
  swap a
  and $F0
  xor l
  ld e, a;low ^ x << 4
  ld a, d
  rrca
  rrca
  rrca
  ld l, a;x rotated right 3
  and $1F
  xor e
  ld h, a;high = low ^ x << 4 ^ x >> 3
  ld a, l
  and $E0
  xor d
  ld l, a;low = x << 5 ^ x
  pop de
  dec bc
  ld a, b
  or c
  jr nz, .byte
  ld b, h
  ld c, l
  pop hl
  add sp, 2
  jp hl

;calls [_module_entry] with de = [_module_context], returns its A
_ModuleEnter::
  ldh a, [loaded_bank]
  push af
  ld a, MODULE_PAGE
  SET_BANK
  LD_HL_VAR _module_context
  ld d, h
  ld e, l
  LD_HL_VAR _module_entry
  call .enter
  ld h, a
  pop af
  SET_BANK
  ld a, h
  ret
.enter
  jp hl

ModulePages: DB MODULE_PAGE, MODULE_PAGE2, MODULE_PAGE3

;a wide module's thunks: call _ModFar, DB page, DW target (module_build.py), like bank_split's
_ModuleAPIFar::
  jp FarCallInline

INCLUDE "build/modules/table.inc"
