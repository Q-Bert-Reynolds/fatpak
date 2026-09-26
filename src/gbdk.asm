; GBDK-like functions
;  Started 30-Dec-19
;
; Initials: NB = Nolan Baker, GBDK = Pascal Felber & Michael Hope
; V1.0 - 30-Dec-19 : Original Release - NB, based on GBDK 2.96
;
; Macros:
;   DISPLAY_ON
;   DISPLAY_OFF
;   SHOW_BKG
;   HIDE_BKG
;   SHOW_WIN
;   HIDE_WIN
;   SHOW_SPRITES
;   HIDE_SPRITES
;   SPRITES_8x16
;   SPRITES_8x8
;   SWITCH_ROM_MBC5
;   SWITCH_RAM_MBC5
;   ENABLE_RAM_MBC5
;   DISABLE_RAM_MBC5
;   CGB_COMPATIBILITY
;   SET_TILES
;
; Library Subroutines:
;   gbdk_MoveSprite       - moves sprite c, de=xy
;   gbdk_SetSpriteTile    - set sprite c to tile d
;   gbdk_SetSpriteProp    - Set properties of sprite c to d
;   gbdk_DisplayOff       - turns off screen
;   gbdk_WaitVBL          - halts until v-blank
;   gbdk_SetWinTiles      - sets window tiles, hl=wh, de=xy, bc=source
;   gbdk_SetBkgTiles      - sets background tiles, hl=wh, de=xy, bc=source
;   gbdk_CopyTilesTo      - jump only, stack=(return,wh), bc=src, hl=dst, de=xy
;   gbdk_GetWinTiles      - gets window tiles, hl=wh, de=xy, bc=source
;   gbdk_GetBkgTiles      - gets background tiles, hl=wh, de=xy, bc=source
;   gbdk_CopyTilesFrom    - jump only, stack=(return,wh), bc=dest, hl=src, de=xy
;   gbdk_Delay            - pauses for de miliseconds
;   gbdk_CPUSlow          - sets GBC CPU speed to DMG 
;   gbdk_CPUFast          - sets GBC CPU speed to 2x
;   gbdk_Random           - returns a random value to DE
;   gbdk_Seed             - seeds Random function
;   gbdk_SetupDMATransfer - loads DMA routine into HRAM

IF !DEF(GBDK_ASM)
DEF GBDK_ASM EQU 1

MACRO rev_Check_GBDK_ASM
  IF \1 > 1
    WARN "Version \1 or later of 'gbdk.asm' is required."
  ENDC
ENDM

INCLUDE "src/memory1.asm"
  rev_Check_memory1_asm 1.2

MACRO DISPLAY_ON
  ld a, [rLCDC]
  or LCDCF_ON
  ld [rLCDC], a
ENDM

MACRO DISPLAY_OFF
  call gbdk_DisplayOff
ENDM

MACRO SHOW_BKG
  ld a, [rLCDC]
  or LCDCF_BGON
  ld [rLCDC], a
ENDM

MACRO HIDE_BKG
  ld a, [rLCDC]
  and ~LCDCF_BGON
  ld [rLCDC], a
ENDM

MACRO SHOW_WIN
  ld a, [rLCDC]
  or LCDCF_WINON
  ld [rLCDC], a
ENDM

MACRO HIDE_WIN
  ld a, [rLCDC]
  and ~LCDCF_WINON
  ld [rLCDC], a
ENDM

MACRO SHOW_SPRITES
  ld a, [rLCDC]
  or LCDCF_OBJON
  ld [rLCDC], a
ENDM

MACRO HIDE_SPRITES
  ld a, [rLCDC]
  and ~LCDCF_OBJON
  ld [rLCDC], a
ENDM

MACRO SPRITES_8x16
  ld a, [rLCDC]
  or LCDCF_OBJ16
  ld [rLCDC], a
ENDM

MACRO SPRITES_8x8
  ld a, [rLCDC]
  and ~LCDCF_OBJ16
  ld [rLCDC], a
ENDM

; MBC5
MACRO SWITCH_ROM_MBC5 ;word \1
  ld hl, rROMB0
  ld [hl], \1 & $FF
  ld hl, rROMB1
  ld [hl], \1 >> 8
ENDM

MACRO SWITCH_RAM_MBC5 ;byte \1
  ld hl, rRAMB
  ld [hl], \1
ENDM

MACRO ENABLE_RAM_MBC5
  ld hl, rRAMG
  ld [hl], $0A
ENDM

MACRO DISABLE_RAM_MBC5
  xor a
  ld [rRAMG], a
ENDM

MACRO CGB_COMPATIBILITY
  ld a,$80
  ldh [rBCPS], a ; set default bkg palette
  ld a,$ff  ; white
  ldh [rBCPD], a
  ld a,$7f
  ldh [rBCPD], a
  ld a,$b5  ; light gray
  ldh [rBCPD], a
  ld a,$56
  ldh [rBCPD], a
  ld a,$4a  ; dark gray
  ldh [rBCPD], a
  ld a,$29
  ldh [rBCPD], a
  ld a,$00  ; black
  ldh [rBCPD], a
  ld a,$00
  ldh [rBCPD], a
  ld a,$80
  ldh [rOCPS], a ; set default sprite palette
  ld a,$ff  ; white
  ldh [rOCPD], a
  ld a,$7f
  ldh [rOCPD], a
  ld a,$b5  ; light gray
  ldh [rOCPD], a
  ld a,$56
  ldh [rOCPD], a
  ld a,$4a  ; dark gray
  ldh [rOCPD], a
  ld a,$29
  ldh [rOCPD], a
  ld a,$00  ; black
  ldh [rOCPD], a
  ld a,$00
  ldh [rOCPD], a
ENDM

DEF OP_COPY_TO   EQU 0
DEF OP_COPY_FROM EQU 1
DEF OP_SET_TO    EQU 2
DEF SKIP_VRAM    EQU 0
DEF WAIT_VRAM    EQU 1
;   width, height on stack
;   hl - 32x32 tile table (usually _SCRN0 or _SCRN1)
;   de - x pos, y pos
;   bc - source
MACRO COPY_TILE_BLOCK; \1 = operation, \2 = wait VRAM?
  push bc ;source

  ;y fits in 5 bits and y*32 is the same as y<<5
  ;because of this, we can rotate in place
  ;high nybble of y becomes low byte of y*32 
  ;low nybble of y becomes high byte of y*32 
  swap e;YYYY000Y
  rlc e;YYY000YY
  ld a, e
  and %00000011 ;high byte of y*32
  add a, h
  ld h, a
  ld a, %11100000
  and a, e ;low byte of y*32 
  add a, d ;low byte of y*32+x
  ld l, a

  pop bc ;source
  pop de ;wh
IF \1 == OP_SET_TO
  ld a, b ;tile id
ENDC

.rowLoop\@
    push de ;wh
  .columnLoop\@
IF \2 == WAIT_VRAM
      ldh a,[rSTAT]
      and STATF_BUSY
      jr nz, .columnLoop\@
  IF \1 == OP_SET_TO
      ld a, b ;tile id
  ENDC
ENDC

IF \1 == OP_COPY_TO
      ld a, [bc]
      ld [hli], a
      inc bc
ELIF \1 == OP_COPY_FROM
      ld a, [hli]
      ld [bc], a
      inc bc
ELIF \1 == OP_SET_TO
      ld [hli], a
ENDC

      dec d
      jr nz, .columnLoop\@
      
    pop de ;wh
    dec e
    ret z

    ld a, 32
    sub a, d 
    add a, l
    ld l, a
    jr nc, .rowLoop\@
    inc h
    jr .rowLoop\@
ENDM

SECTION "GBDK WRAM Vars", WRAM0[_RAM]
;ensure OAM buffer starts at $XX00 and is not in switchable WRAM, see SETUP_DMA_TRANSFER macro
oam_buffer:: DS 4*40
rand_hi:: DB
rand_lo:: DB

SECTION "GBDK Code", ROM0
;***************************************************************************
;
; gbdk_MoveSprite - Move sprite number C to XY = DE
;
; input:
;   c - sprite number
;   de - xy
;
;***************************************************************************
gbdk_MoveSprite::
  ld hl, oam_buffer ;calculate origin of sprite info
  sla c ;multiply c by 4
  sla c
  ld b, 0
  add hl, bc
  ld a,e  ;set y
  ld [hl], a
  inc l
  ld a,d  ;set x
  ld [hl], a
  ret

;***************************************************************************
;
; gbdk_SetSpriteTile - Set sprite number C to tile D
;
; input:
;   c - sprite number
;   d - tile
;
;***************************************************************************
gbdk_SetSpriteTile::
  ld hl, oam_buffer+2 ;calculate origin of sprite info
  sla c ;multiply c by 4
  sla c
  ld b, 0
  add hl, bc
  ld a, d ;set sprite number
  ld [hl], a
  ret

;***************************************************************************
;
; gbdk_SetSpriteProp - Set properties of sprite number C to D
;
; input:
;   c - sprite number
;   d - properties
;
;***************************************************************************
gbdk_SetSpriteProp::
  ld hl, oam_buffer+3 ; calculate origin of sprite info
  sla c ;multiply c by 4
  sla c
  ld b, 0
  add hl, bc
  ld a, d ;set sprite properties
  ld [hl], a
  reti

;***************************************************************************
;
; gbdk_DisplayOff - Waits for VBlank and turns off the LCD
;
;***************************************************************************
gbdk_DisplayOff::
  ldh a, [rLCDC]
  add a
  ret nc
  LCD_WAIT_VRAM  
  ldh a, [rLCDC]
  and %01111111
  ldh [rLCDC], A
  ret

;***************************************************************************
;
; gbdk_WaitVBL - Wait for VBL interrupt to start
;
;***************************************************************************
gbdk_WaitVBL::
  ldh a, [rLCDC]
  and a, LCDCF_ON
  ret z; return if screen is off
  xor a
  ldh [vbl_done], a;clear stale data
.loop
    halt; wait for any interrupt
    nop; halt sometimes skips the next instruction
    ldh a, [vbl_done]  ; was it a vblank interrupt?
    ;; warning: we may lose a vblank interrupt, if it occurs now
    and a
    jr z, .loop; no: back to sleep!
  ret

;***************************************************************************
;
; gbdk_SetWinTiles - Sets window tile table
; width and height >= (1,1); 
;
; input:
;   hl - width, height
;   de - x pos, y pos
;   bc - firstTile
;
;***************************************************************************
gbdk_SetWinTiles::
  push  hl    ; store wh
  ldh  a,[rLCDC]
  bit  6, a
  jr  nz,.innerLoop
  ld  hl, _SCRN0  ; hl = origin
  jr  gbdk_CopyTilesTo
.innerLoop:
  ld  hl,_SCRN1  ; hl = origin
  jr  gbdk_CopyTilesTo


;***************************************************************************
;
; gbdk_SetBkgTiles - Sets background tile table
; width and height >= (1,1); 
;
; input:
;   hl - width, height
;   de - x pos, y pos
;   bc - firstTile
;
;***************************************************************************
gbdk_SetBkgTiles::
  push hl ; store wh
  ldh a,[rLCDC]
  bit 3, a
  jr nz, .skip
  ld hl, _SCRN0 ; hl = origin
  jr gbdk_CopyTilesTo
.skip
  ld hl, _SCRN1 ; hl = origin
  ;falls through to gbdk_CopyTilesTo

;***************************************************************************
;
; gbdk_CopyTilesTo - Copies tiles to address
;   Cannot be called. Must be jumped to.
;
; input:
;   stack:
;     return address
;     width, height
;   hl - 32x32 tile destination (usually _SCRN0 or _SCRN1)
;   de - x pos, y pos
;   bc - source
;
;***************************************************************************
gbdk_CopyTilesTo:
  COPY_TILE_BLOCK OP_COPY_TO, WAIT_VRAM

;***************************************************************************
;
; gbdk_SetTilesTo - Set tiles to a
;
; input:
;   a  - tile id
;   hl - 32x32 tile destination (usually _SCRN0 or _SCRN1)
;   de - x pos, y pos
;   bc - width, height
;
;***************************************************************************
gbdk_SetTilesTo::
  push bc
  ld b, a
  COPY_TILE_BLOCK OP_SET_TO, WAIT_VRAM

;***************************************************************************
;
; gbdk_GetWinTiles - Gets window tile table
; wh >= (1,1)
;
; input:
;   hl - width, height
;   de - x pos, y pos
;   bc - target
;
;***************************************************************************
gbdk_GetWinTiles::
  push hl ; store wh
  ldh a, [rLCDC]
  bit 6, a
  jr nz, .skip
  ld hl, _SCRN0 ; hl = origin
  jr gbdk_CopyTilesFrom
.skip
  ld hl, _SCRN1 ; hl = origin
  jr gbdk_CopyTilesFrom

;***************************************************************************
;
; gbdk_GetBkgTiles - Gets background tile table
; wh >= (1,1)
;
; input:
;   hl - width, height
;   de - x pos, y pos
;   bc - target
;
;***************************************************************************
gbdk_GetBkgTiles::
  push hl  ; store wh
  ldh a, [rLCDC]
  bit 3, a
  jr nz, .skip
  ld hl, _SCRN0 ; hl = origin
  jr gbdk_CopyTilesFrom
.skip
  ld hl, _SCRN1 ; hl = origin
  ;falls through to gbdk_CopyTilesFrom

;***************************************************************************
;
; gbdk_CopyTilesFrom - Gets tiles from address
;   Cannot be called. Must be jumped to.
;
; input:
;   stack:
;     return address
;     width, height
;   hl - 32x32 tile source (usually _SCRN0 or _SCRN1)
;   de - x pos, y pos
;   bc - destination
;
;***************************************************************************
gbdk_CopyTilesFrom::
  COPY_TILE_BLOCK OP_COPY_FROM, WAIT_VRAM

;***************************************************************************
;
; gbdk_Delay - delay de milliseconds
; 
; input:
;   de - number of milliseconds to delay (1 to 65536, 0 = 65536)
;
; registers used: af, bc, de
;***************************************************************************
DEF _CPMS EQU 4194/4  ; 4.194304 MHz
gbdk_Delay::
  ld bc, _CPMS/7         ; 3 cycles
.loop
    dec bc                 ; 2 cycles
    ld a, b                ; 1 cycle
    or c                   ; 1 cycle
    jr nz, .loop           ; 3 cycles (2 when false)

  dec de                 ; 2 cycles
  ld a, d                ; 1 cycle
  or e                   ; 1 cycle
  jr nz, gbdk_Delay      ; 3 cycles
  ret                    ; 4 cycles

;***************************************************************************
;
; gbdk_CPUSlow - Sets GameBoy Color to DMG speed
;
;***************************************************************************
gbdk_CPUSlow::
  ldh a,[rKEY1]
  and $80  ; is gbc in double speed mode?
  ret z  ; no, already in single speed

shift_speed:
  ldh a,[rIE]
  push af

  xor a  ; a = 0
  ldh [rIE], a  ; disable interrupts
  ldh [rIF], a

  ld a,$30
  ldh [rP1], a

  ld a,$01
  ldh [rKEY1], a

  nop

  pop af
  ldh [rIE], a

  ret

;***************************************************************************
;
; gbdk_CPUFast - Sets GameBoy Color to double speed mode
;
;***************************************************************************
gbdk_CPUFast::
  ldh a,[rKEY1]
  and $80  ; is gbc in double speed mode?
  ret nz  ; yes, exit
  jr shift_speed


;***************************************************************************
;
; gbdk_Random - generates a random number
;
; Random number generator using the linear congruential method
;    X(n+1) = (a*X(n)+c) mod m
; with a = 17, m = 16 and c = $5C93 (arbitrarily)
; The seed value is also chosen arbitrarily as $a27e
;
; Ref : D. E. Knuth, "The Art of Computer Programming" , Volume 2
;
; Note D is the low byte, E the high byte. This is intentional because
; the high byte can be slightly 'more random' than the low byte, and I presume
; most will cast the return value to a UBYTE. As if someone will use this, tha!
;
; output: de - random number (word)
; registers used: a, hl, de
;***************************************************************************
gbdk_Random::
  ld a, [rand_lo]
  ld l, a
  ld e, a  ; Save rand_lo
  ld a, [rand_hi]
  ld d, a  ; Save rand_hi

  add hl, hl;rand * 2
  add hl, hl;rand * 4
  add hl, hl;rand * 8
  add hl, hl;rand * 16
  add hl, de;rand * 17

  ld de, $5C93
  add hl, de;rand = (17 * rand) + $5C93

  ld a, l  ; rand_lo*17 + $93
  ld [rand_lo], a
  ld d, a  ; Return register
  ld a, h  ; rand_hi*17 + $5C
  ld [rand_hi], a
  ld e, a  ; Return register

  ret

;***************************************************************************
; gbdk_Seed - sets the random seed value to hl
;
; input: hl
; registers used: a, hl
;***************************************************************************
gbdk_Seed::
 ld a, h
 ld [rand_lo], a
 ld a, l
 ld [rand_hi], a
 ret


;***************************************************************************
;
; gbdk_SetupDMATransfer - loads DMA routine into HRAM
;
;***************************************************************************
gbdk_SetupDMATransfer::
  ld c, _HRAM % $100
  ld b, .DMATransferEnd - .DMATransfer
  ld hl, .DMATransfer
.copy
  ld a, [hli]
  ld [$ff00+c], a
  inc c
  dec b
  jr nz, .copy
  ret

.DMATransfer
  ld a, oam_buffer / $100
  ld [rDMA], a
  ld a, $28
.wait
  dec a
  jr nz, .wait
  ret
.DMATransferEnd

SECTION "GBDK HRAM Vars", HRAM[_HRAM]
DMATransfer:: DS (gbdk_SetupDMATransfer.DMATransferEnd - gbdk_SetupDMATransfer.DMATransfer)
vbl_done:: DB
_HRAMEnd:

DEF HRAM_LEFT EQU ($FFFE - _HRAMEnd)
PRINT "\n{d:HRAM_LEFT} bytes of HRAM left.\n"

ENDC ;GBDK_ASM