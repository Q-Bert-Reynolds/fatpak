INCLUDE "src/fatpak.inc"

DEF MODULE_PAGE EQU 13
DEF MODULE_STAGE EQU $3D80
DEF MODULE_BACKUP EQU $3D90
ASSERT ADD_BLOCK + (ADD_MAX + 511) / 512 <= DATA_BLOCK
ASSERT $3C00 + $A4 <= DATA_BLOCK
ASSERT NAME_HISTORY_BLOCK + 16 <= MODULE_STAGE
ASSERT MODULE_STAGE + 15 <= MODULE_BACKUP
ASSERT MODULE_BACKUP + 15 < $3E2F

SECTION "Module transfer state", WRAM0
module_operation: DB
module_sector: DB
module_pointer: DW

FIXED "Module loader"
_FileLoadModule:: BANKED_C _fs_LoadModule

; A=0 backup, 1 install, 2 restore. Return BC=sum of mapped page.
; Only resident LCD handling runs during transfer; no HDMA is initiated here.
_ModuleSwap::
  ld [module_operation], a
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
  ld a, MODULE_PAGE
  SET_BANK
  ei
  ld hl, $A000
  ST_HL_VAR module_pointer
  xor a
  ld [module_sector], a
.loop
  ld a, [module_operation]
  cp 1
  ld a, LOW(MODULE_BACKUP)
  jr nz, .block
  ld a, LOW(MODULE_STAGE)
.block
  ld b, a
  ld a, [module_sector]
  add b
  ld [EDX_BLOCK], a
  ld a, HIGH(MODULE_STAGE)
  ld [EDX_BLOCK+1], a
  ld bc, 512
  ld a, [module_sector]
  cp 14
  jr nz, .count
  ld bc, 256
.count
  LD_HL_VAR module_pointer
  ld de, EDX_WINDOW
  ld a, [module_operation]
  and a
  jr z, .copy
  ld d, h
  ld e, l
  ld hl, EDX_WINDOW
.copy
  call mem_Copy
  ld a, [module_operation]
  and a
  jr z, .pointer
  ld h, d
  ld l, e
.pointer
  ST_HL_VAR module_pointer
  ld hl, module_sector
  inc [hl]
  ld a, [hl]
  cp 15
  jr c, .loop
  ld de, $A000
  ld bc, PAGE_SIZE
  call _ByteSum
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
  ret

_ModuleEnter::
  ldh a, [loaded_bank]
  push af
  ld a, MODULE_PAGE
  SET_BANK
  LD_HL_VAR _module_entry
  call .enter
  ld h, a
  pop af
  SET_BANK
  ld a, h
  ret
.enter
  jp hl

INCLUDE "build/modules/table.inc"
