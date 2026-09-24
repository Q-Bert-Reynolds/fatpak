; Memory Manipulation Code
;  Started 16-Aug-97
;
; Initials: JF = Jeff Frohwein, CS = Carsten Sorensen, NB = Nolan Baker
; V1.0 - 16-Aug-97 : Original Release - JF, most code from CS
; V1.1 - 29-Nov-97 : Added monochrome font copy. - JF
;                    Fixed bug in mem_SetVRAM. - JF
; V1.2 - 30-Dec-19 : Adds tile data copy that loops from 9800 to 8800 - NB
;
; Macros:
;   LCD_WAIT_VRAM
;     Macro that pauses until VRAM available.
; 
; Library Subroutines:
;   mem_Set
;     Set a memory region.
;     Entry: a = value, hl = src address, bc = length
;   mem_Copy
;     Copy a memory region.
;     Entry: hl = src address, de = dst address, bc = length
;   mem_CopyMono (unused, commented out for space)
;     Copy a monochrome font from ROM to RAM
;     Entry: hl = src address, de = dst address, bc = src length
;   mem_SetVRAM
;     Set a memory region in VRAM.
;     Entry: a = value, hl = dst address, bc = length
;   mem_CopyVRAM
;     Copy a memory region to or from VRAM.
;     Entry: hl = src address, de = dst address, bc = length
;   mem_CopyToTileData
;     Copy a memory region to Tile Data (loops from 9800 to 8800)
;     Entry: hl = src address, de = dst tiledata, bc = length
;

IF !DEF(MEMORY1_ASM)
DEF MEMORY1_ASM EQU 1

DEF MEM_UNROLL_STEPS EQU 3
DEF MEM_UNROLL_POW EQU 1 << MEM_UNROLL_STEPS
DEF MEM_UNROLL_MASK EQU MEM_UNROLL_POW-1

MACRO rev_Check_memory1_asm
  IF \1 > 1.2
    WARN "Version \1 or later of 'memory1.asm' is required."
  ENDC
ENDM

INCLUDE "src/hardware.inc"
  rev_Check_hardware_inc 4

; Macro that pauses until VRAM available.
MACRO LCD_WAIT_VRAM
.loop\@
  ldh a, [rSTAT]
  and STATF_BUSY
  jr nz, .loop\@
ENDM

MACRO MEM_SET
  ld [hli],a
ENDM

MACRO MEM_SET_VRAM
  di
  push af
  LCD_WAIT_VRAM
  pop  af
  MEM_SET
  ei
ENDM

MACRO MEM_COPY
  ld a, [hli]
  ld [de], a
  inc de
ENDM

MACRO MEM_COPY_VRAM
  di
  LCD_WAIT_VRAM
  MEM_COPY
  ei
ENDM

MACRO MEM_LOOP; \1 = set/copy macro
  inc b
  inc c
  jr .skip\@
.loop\@
  \1
  .skip\@
    dec c
    jr nz, .loop\@
    dec b
    jr nz, .loop\@
  ret
ENDM

MACRO MEM_UNROLL; \1 = set/copy macro
  ld a, b
  or a, c
  ret z;no bytes to copy
  ld a, c
  and a, MEM_UNROLL_MASK
  jr z, .chunks\@
.remainder\@
  \1;set/copy macro
  dec bc
  ld a, c
  and a, MEM_UNROLL_MASK
  jr nz, .remainder\@
.chunks\@
  ld a, b
  or a, c
  ret z
.loop\@
  REPT MEM_UNROLL_POW
    \1;set/copy macro
    dec bc
  ENDR
    ld a, b
    or a, c
  IF MEM_UNROLL_STEPS > 3
    jp nz, .loop\@
  ELSE
    jr nz, .loop\@
  ENDC
  ret
ENDM

SECTION "Memory1 Code", ROM0
;***************************************************************************
;
; mem_Set - "Set" a memory region
;
; input:
;   a - value
;   hl - pMem
;   bc - bytecount
;
;***************************************************************************
mem_Set::
IF MEM_UNROLL_STEPS == 0;use basic mem_Set
  MEM_LOOP MEM_SET
ELSE;use unrolled mem_Set if MEM_UNROLL_STEPS > 0
  ld d, a;value to set
  ld a, c
  and a, MEM_UNROLL_MASK
  jr z, .calc
  
.remainder:
  ld a, d
  ld [hli], a
  dec c
  ld a, c
  and MEM_UNROLL_MASK
  jr nz, .remainder

.calc:
REPT MEM_UNROLL_STEPS
  srl b
  rr c
ENDR
  ld a, b
  or a, c
  ret z
  
  ld a, d;value to set
  inc b
  inc c
  jr .skip
.loop:
REPT MEM_UNROLL_POW
    ld [hli], a
ENDR
  .skip:
    dec c
    jr nz, .loop
    dec b
    jr nz, .loop
  ret

ENDC

;***************************************************************************
;
; mem_Copy - "Copy" a memory region
;
; input:
;   hl - pSource
;   de - pDest
;   bc - bytecount
;
;***************************************************************************
mem_Copy::
IF MEM_UNROLL_STEPS == 0
  MEM_LOOP MEM_COPY  
ELSE
  MEM_UNROLL MEM_COPY
ENDC

;***************************************************************************
;
; mem_CopyMono - "Copy" a monochrome font from ROM to RAM
;
; input:
;   hl - pSource
;   de - pDest
;   bc - bytecount of Source
;
;***************************************************************************
; mem_CopyMono::
;   inc  b
;   inc  c
;   jr   .skip
; .loop  
;   ld   a,[hl+]
;   ld   [de],a
;   inc  de
;   ld   [de],a
;   inc  de
; .skip 
;   dec  c
;   jr   nz, .loop
;   dec  b
;   jr   nz, .loop
;   ret


;***************************************************************************
;
; mem_SetVRAM - "Set" a memory region in VRAM
;
; input:
;   a - value
;   hl - pMem
;   bc - bytecount
;
;***************************************************************************
mem_SetVRAM::
  MEM_LOOP MEM_SET_VRAM

;***************************************************************************
;
; mem_CopyVRAM - "Copy" a memory region to or from VRAM
;
; input:
;   hl - pSource
;   de - pDest
;   bc - bytecount
;
;***************************************************************************
mem_CopyVRAM::
IF MEM_UNROLL_STEPS == 0
  MEM_LOOP MEM_COPY_VRAM  
ELSE
  MEM_UNROLL MEM_COPY_VRAM
ENDC

;***************************************************************************
;
; mem_CopyToTileData - "Copy" a memory region to Tile Data
;   loops the tilemap data from $9800 to $8800
;
; input:
;   hl - pSource
;   de - tile data dest
;   bc - bytecount
;
;***************************************************************************
mem_CopyToTileData::
  inc b
  inc c
  jr  .skip
.loop
    ld a, $98
    cp a, d
    jr nz, .noWrap
    sub $10
    ld d, a
  .noWrap
    di
    LCD_WAIT_VRAM
    ld  a,[hl+]
    ld  [de],a
    ei
    inc de
  .skip
    dec c
    jr  nz,.loop
    dec b
    jr  nz,.loop
  ret

ENDC ;MEMORY1_ASM

