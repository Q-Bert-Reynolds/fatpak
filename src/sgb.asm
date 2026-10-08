; Super Game Boy
;
;   based on code from Imanol Barriuso (Imanolea) - https://imanoleasgames.blogspot.com/2016/12/games-aside-1-super-game-boy.html
;                    and Martin Ahrnbom (ahrnbom) - https://github.com/ahrnbom/gingerbread
;

INCLUDE "src/hardware.inc"
INCLUDE "src/memory1.asm"

; ROMX Subroutines:
;   sgb_Init
;     Checks to see if game is running on SGB, and updates sys_info.
;     Sends initialization packet to SNES. Sets default palette and border.

; ROM0 Subroutines:
;   sgb_SetDefaultBorder
;     Sets the default Super Game Boy border.
;   sgb_SetBorder
;     Sets the Super Game Boy border.
;     Input: a = bank, hl = tiles, de = tile map
;   sgb_PlaySound
;     Plays a preset sound effect on the SNES
;     Input: a = sound A, b = sound B, c = attributes
;   sgb_SetPal
;     Directly sets 2 SNES palettes. Packet can only be codes 0-3.
;     Input: a = packet header, bc = paletteA, de = paletteB
;   sgb_SetBlock
;     Indirectly sets inside of screen block to palette b, border to palette c.
;     Input: bc = palette indices, de = xy, hl = wh
;   sgb_VRAMTransfer
;     Copies data to GB VRAM then to SNES.
;     Input: de = packet, hl = graphical data
;   sgb_PacketTransfer
;     Transfers data to SNES.
;     Input: hl = packet address
;   sgb_CopyToWRAM
;     Copies data to SNES WRAM using either DATA_SND or DATA_TRN
;     Input: a = SNES bank, bc = byte count, de = SNES address, hl = src data

DEF SGB_CODE_PAL01    EQU $00 ;Set SGB Palette 0,1 Data
DEF SGB_CODE_PAL23    EQU $01 ;Set SGB Palette 2,3 Data
DEF SGB_CODE_PAL03    EQU $02 ;Set SGB Palette 0,3 Data
DEF SGB_CODE_PAL12    EQU $03 ;Set SGB Palette 1,2 Data
DEF SGB_CODE_ATTR_BLK EQU $04 ;Block Area Designation Mode
DEF SGB_CODE_ATTR_LIN EQU $05 ;Line Area Designation Mode
DEF SGB_CODE_ATTR_DIV EQU $06 ;Divide Area Designation Mode
DEF SGB_CODE_ATTR_CHR EQU $07 ;1CHR Area Designation Mode
DEF SGB_CODE_SOUND    EQU $08 ;Sound On/Off
DEF SGB_CODE_SOU_TRN  EQU $09 ;Transfer Sound PRG/DATA
DEF SGB_CODE_PAL_SET  EQU $0A ;Set SGB Palette Indirect
DEF SGB_CODE_PAL_TRN  EQU $0B ;Set System Color Palette Data
DEF SGB_CODE_ATRC_EN  EQU $0C ;Enable/disable Attraction Mode
DEF SGB_CODE_TEST_EN  EQU $0D ;Speed Function (unavailable)
DEF SGB_CODE_ICON_EN  EQU $0E ;SGB Function
DEF SGB_CODE_DATA_SND EQU $0F ;Packet Transfer to SNES WRAM
DEF SGB_CODE_DATA_TRN EQU $10 ;VRAM Transfer to SNES WRAM
DEF SGB_CODE_MLT_REQ  EQU $11 ;Controller 2 Request
DEF SGB_CODE_JUMP     EQU $12 ;Set SNES Program Counter
DEF SGB_CODE_CHR_TRN  EQU $13 ;Transfer Character Font Data
DEF SGB_CODE_PCT_TRN  EQU $14 ;Set Screen Data Color Data
DEF SGB_CODE_ATTR_TRN EQU $15 ;Set Attribute from ATF
DEF SGB_CODE_ATTR_SET EQU $16 ;Set Data to ATF
DEF SGB_CODE_MASK_EN  EQU $17 ;Game Boy Window Mask
DEF SGB_CODE_OBJ_TRN  EQU $18 ;SNES OBJ Mode (unavailable)
DEF SGB_CODE_PAL_PRI  EQU $19 ;System palette priority

MACRO SGB_HEADER ;\1 = code, \2 = num packets
  DB (\1 << 3) + \2
ENDM

DEF PAL01 EQU 1
DEF PAL23 EQU (1 << 3) | 1
DEF PAL03 EQU (2 << 3) | 1
DEF PAL12 EQU (3 << 3) | 1

MACRO ATTR_BLK ;\1 = num data sets
  SGB_HEADER SGB_CODE_ATTR_BLK, ((\1 * 6)/16) + 1
	DB \1
ENDM

MACRO ATTR_BLK_DATA ;\1 = control code, \2\3\4 = palette(0-3), \5\6 = xy, \7\8 = wh
	DB \1 ;bit 2 = outside block, bit 1 = on border, bit 0 = inisde block
	DB (\2 << 4) + (\3 << 2) + \4 ;\2 = outside, \3 = border, \4 = inside
	DB \5, \6, \5+\7-1, \6+\8-1
ENDM

MACRO ATTR_LIN ;\1 = num data sets
  SGB_HEADER SGB_CODE_ATTR_LIN, \1
	DB \1
ENDM

MACRO ATTR_LINE_DATA ;\1 = mode (0=vertical, 1=horiz), \2 = palette(0-3), \3 = x or y depending on mode
	DB (\1<<7) + (\2<<5) + \3
ENDM

MACRO ATTR_DIV ;\1 = mode (0=vertical, 1=horiz), \2\3\4 = palette(0-3), \5 = x or y
  SGB_HEADER SGB_CODE_ATTR_DIV, 1
	DB (\1<<6) + (\2<<4) + (\3<<2) + \4 ;\2 = line, \3 = above/left, \4 = below/right
  DB \5;x if \1=0, y if \1=1
  DS 13
ENDM

MACRO ATTR_CHR ;\1 = x, \2 = y, \3 = num data sets, \4 sytle
  SGB_HEADER SGB_CODE_ATTR_CHR, (\3/4)+4
	DB \1;x
  DB \2;y
  DW \3;num data sets
  DB \4;0=left to right, 1=right to left
ENDM

MACRO ATTR_CHR_DATA;\1\3\4\4 palette(0-3)
  DB (\1<<6) | (\2<<4) | (\3<<2) | \4
ENDM

MACRO SGB_SOUND;\1 = SFX A, \2 = SFX B, \3 = Attributes \4 = Music Score Code
  SGB_HEADER SGB_CODE_SOUND, 1
  DB \1;Sound Effect A (Port 1) Decrescendo 8-bit Sound Code
  DB \2;Sound Effect B (Port 2) Sustain     8-bit Sound Code
  DB \3;Bit 0-1 - Sound Effect A Pitch (0..3=Low..High)
       ;Bit 2-3 - Sound Effect A Volume (0..2=High..Low, 3=Mute on)
       ;Bit 4-5 - Sound Effect B Pitch (0..3=Low..High)
       ;Bit 6-7 - Sound Effect B Volume (0..2=High..Low, 3=Not used)
  DB \4;Music Score Code (must be zero if not used)
  DS 11
ENDM

MACRO PAL_SET ;\1 = Pal0, \2 = Pal1, \3 = Pal2, \4 = Pal3
  SGB_HEADER SGB_CODE_PAL_SET, 1
  DW \1, \2, \3, \4
  DS 7
ENDM

MACRO PAL_TRN
  SGB_HEADER SGB_CODE_PAL_TRN, 1
  DS 15
ENDM

MACRO MLT_REQ ;\1 = player count
  SGB_HEADER SGB_CODE_MLT_REQ, 1
  DB \1 - 1
  DS 14
ENDM

MACRO CHR_TRN ;\1 = tile table (0=$00-$7F, 1=$80-$FF), \2 = tile type (0=BG, 1=OBJ)
  SGB_HEADER SGB_CODE_CHR_TRN, 1
  DB \1 | (\2 << 1)
  DS 14
ENDM

MACRO PCT_TRN
  SGB_HEADER SGB_CODE_PCT_TRN, 1
  DS 15
ENDM

MACRO ATTR_TRN
  SGB_HEADER SGB_CODE_ATTR_TRN, 1
  DS 15
ENDM

MACRO ATTR_SET;\1 Attribute File Number ($00-$2C), \2 = screen mask (0=cancel,1=freeze)
  SGB_HEADER SGB_CODE_ATTR_SET, 1
  DB \1 | (\2 << 6)
  DS 14
ENDM

MACRO MASK_EN ;\1 = screen mask (0=cancel,1=freeze)
  SGB_HEADER SGB_CODE_MASK_EN, 1
  DB \1
  DS 14
ENDM

MACRO PAL_RPI ;\1 = priority (0=user,1=game)
  SGB_HEADER SGB_CODE_PAL_PRI, 1
  DB \1
  DS 14
ENDM

SECTION "Super GameBoy Banked", ROMX

IF DEF(_HOME)
INCLUDE "img/home_version/home_version_sgb_border.asm"
ELIF DEF(_AWAY)
INCLUDE "img/away_version/away_version_sgb_border.asm"
ELSE
INCLUDE "img/demo_version/demo_version_sgb_border.asm"
ENDC

; Initialization packets extracted from the official documentation
DataSnd0: DB $79, $5D, $08, $00, $0B, $8C, $D0, $F4, $60, $00, $00, $00, $00, $00, $00, $00
DataSnd1: DB $79, $52, $08, $00, $0B, $A9, $E7, $9F, $01, $C0, $7E, $E8, $E8, $E8, $E8, $E0
DataSnd2: DB $79, $47, $08, $00, $0B, $C4, $D0, $16, $A5, $CB, $C9, $05, $D0, $10, $A2, $28
DataSnd3: DB $79, $3C, $08, $00, $0B, $F0, $12, $A5, $C9, $C9, $C8, $D0, $1C, $A5, $CA, $C9
DataSnd4: DB $79, $31, $08, $00, $0B, $0C, $A5, $CA, $C9, $7E, $D0, $06, $A5, $CB, $C9, $7E
DataSnd5: DB $79, $26, $08, $00, $0B, $39, $CD, $48, $0C, $D0, $34, $A5, $C9, $C9, $80, $D0
DataSnd6: DB $79, $1B, $08, $00, $0B, $EA, $EA, $EA, $EA, $EA, $A9, $01, $CD, $4F, $0C, $D0
DataSnd7: DB $79, $10, $08, $00, $0B, $4C, $20, $08, $EA, $EA, $EA, $EA, $EA, $60, $EA, $EA

; Super Game boy command packets
sgb_PalSetDefault:    PAL_SET PALETTE_CALVIN, PALETTE_GREY, PALETTE_UI, PALETTE_SEPIA
sgb_MltReqTwoPlayers: MLT_REQ 2
sgb_MltReqOnePlayer:  MLT_REQ 1

; Super Game Boy initialization
sgb_Init::
  di
  DISPLAY_OFF
  call sgb_SendInitPackets        ; 8 initialization data packet sending, according to the official documentation
  call sgb_Check                  ; check multiplayer even if register check has passed
  ld a, [sys_info]
  jr nc, .doubleCheck             ; multiplayer fail might be a fluke, check registers
  or a, SYS_INFO_SGB
  ld [sys_info], a
.doubleCheck
  and a, SYS_INFO_SGB
  jr nz, .success
.fail
  reti                            ; both register and multiplayer checks failed

.success
  ld hl, sgb_MaskEnFreeze
  call  _sgb_PacketTransfer       ; Freezes the visualization of the Super Game Boy screen to hide the graphic garbage during the VRAM transfers  

  ld de, sgb_ChrTrn1
  ld hl, VersionSgbBorderTiles
  call _sgb_VRAMTransfer          ; Copies first 128 tiles of the frame (256 Game Boy tiles) to SNES RAM

  ld de, sgb_ChrTrn2
  ld hl, VersionSgbBorderTiles+$1000
  call _sgb_VRAMTransfer          ; Copies second 128 tiles of the frame (256 Game Boy tiles) SNES RAM

  ld de, sgb_PctTrn
  ld hl, VersionSgbBorderTileMap
  call _sgb_VRAMTransfer          ; Copies frame map to SNES RAM 

  ld de, sgb_PalTrn
  ld hl, DefaultPalettes
  call _sgb_VRAMTransfer          ; Copies custom game palettes to SNES RAM

  ld hl, sgb_PalSetDefault               
  call _sgb_PacketTransfer        ; Default game palette set

  ld hl, sgb_PalPriGame
  call _sgb_PacketTransfer        ; override user palettes

  ld hl, sgb_MaskEnCancel
  call _sgb_PacketTransfer        ; Super Game Boy screen visualization unfreezing
  reti

; Carry Flag raised if the system in which the game is running is a Super Game Boy
sgb_Check:
  di
  ld hl, sgb_MltReqTwoPlayers     ; Two player mode selection
  call _sgb_PacketTransfer
  ei
  ld a, P1F_4 | P1F_5
  ldh [rP1], a                    ; We disable key and pad reading to read the joypad id
  ldh a, [rP1]
  ldh a, [rP1]
  ldh a, [rP1]
  ldh a, [rP1]                    ; Many readings to avoid the "bouncing" of values
  ld b, a                         ; We store the id of the first joypad
  
  ; Joypad reading simulation
  ld a, P1F_5
  ldh [rP1], a                    ; Pad reading activated
  ld a, P1F_4
  ldh [rP1], a                    ; Key reading activated
  ld a, P1F_4 | P1F_5
  ldh [rP1], a                    ; We disable key and pad reading to read the next joypad id
  ldh a, [rP1]
  ldh a, [rP1]
  ldh a, [rP1]
  ldh a, [rP1]
  cp b                           ; If the id is the same then there has not been reply to the two-
  jr nz, .restore1P              ; player mode request, and therefore we are not in a Super Game Boy
  ccf                            ; We lower the carry flag
  ret                            ; We are not in a Super Game Boy
.restore1P
  ld hl, sgb_MltReqOnePlayer
  call _sgb_PacketTransfer       ; We return to one player mode
  scf                            ; We raise the carry flag
  ret                            ; We are in a Super Game Boy

; We send the 8 default initialization data packets specified in the official documentation
sgb_SendInitPackets:
  ld hl, DataSnd0
  call _sgb_PacketTransfer
  ld hl, DataSnd1
  call _sgb_PacketTransfer
  ld hl, DataSnd2
  call _sgb_PacketTransfer
  ld hl, DataSnd3
  call _sgb_PacketTransfer
  ld hl, DataSnd4
  call _sgb_PacketTransfer
  ld hl, DataSnd5
  call _sgb_PacketTransfer
  ld hl, DataSnd6
  call _sgb_PacketTransfer
  ld hl, DataSnd7
  call _sgb_PacketTransfer
  ret

SECTION "Super GameBoy Main", ROM0

; Super Game boy command packets
sgb_ChrTrn1:      CHR_TRN 0, 0 ; First 128 tile block transfer
sgb_ChrTrn2:      CHR_TRN 1, 0 ; Second 128 tile block transfer
sgb_PctTrn:       PCT_TRN
sgb_PalTrn:       PAL_TRN
sgb_MaskEnFreeze: MASK_EN 1
sgb_MaskEnCancel: MASK_EN 0
sgb_PalPriGame:   PAL_RPI 1
sgb_PalPriUser:   PAL_RPI 0

sgb_SetDefaultBorder::
  ld a, BANK(VersionSgbBorderTiles)
  ld hl, VersionSgbBorderTiles
  ld de, VersionSgbBorderTileMap
sgb_SetBorder:: ;a = bank, hl = tiles, de = tile map
  ld b, a;bank
  ld a, [sys_info]
  and a, SYS_INFO_SGB
  ret z

  di
  ldh a, [loaded_bank]
  push af;old bank
  ld a, b;new bank
  push de;tile map
  push hl;tiles
  SET_BANK

  ld hl, sgb_MaskEnFreeze
  call  _sgb_PacketTransfer      ; Freezes the visualization of the Super Game Boy screen to hide the graphic garbage during the VRAM transfers

  pop hl;tiles
  push hl;tiles
  ld de, sgb_ChrTrn1
  call _sgb_VRAMTransfer          ; Copies first 128 tiles of the frame (256 Game Boy tiles) to SNES RAM

  ld de, sgb_ChrTrn2
  pop hl;tiles
  ld bc, $1000
  add hl, bc
  call _sgb_VRAMTransfer          ; Copies second 128 tiles of the frame (256 Game Boy tiles) SNES RAM

  ld de, sgb_PctTrn
  pop hl;tile map
  call _sgb_VRAMTransfer          ; Copies frame map to SNES RAM 

  ld hl, sgb_MaskEnCancel
  call _sgb_PacketTransfer       ; Super Game Boy screen visualization unfreezing

  pop af;old bank
  SET_BANK
  reti

sgb_PlaySound:: ;a = sound A, b = sound B, c = attributes
  push bc
  push af
  ld a, [sys_info]
  and a, SYS_INFO_SGB
  jr z, .isSGB
  pop af
  pop bc
  ret
.isSGB
  ld hl, cmd_buffer
  ld a, ($08<<3)+1
  ld [hli], a
  pop af;sound a
  ld [hli], a
  pop bc
  ld a, b
  ld [hli], a
  ld a, c
  ld [hli], a
  xor a
  ld bc, 11
  call mem_Set
  ld hl, cmd_buffer
  call _sgb_PacketTransfer
  ret

sgb_SetPal:: ;a = packet header, bc = paletteA, de = paletteB
  ld hl, cmd_buffer
  ld [hli], a

  ld a, [sys_info]
  and a, SYS_INFO_SGB
  ret z

  push de;paletteB
  push bc;paletteA
  pop hl;paletteA
  ld de, cmd_buffer+1
  ld bc, 8
  call mem_Copy

  pop hl;paletteB
  inc hl
  inc hl
  ld de, cmd_buffer+9
  ld bc, 6
  call mem_Copy

  xor a
  ld [hli], a

  ld hl, cmd_buffer
  call _sgb_PacketTransfer

  ret

; Indirectly sets inside of screen block to palette b, border to palette c.
; Input: bc = palettes, de = xy, hl = wh
sgb_SetBlock::
  ld a, [sys_info]
  and a, SYS_INFO_SGB
  ret z

  push hl;wh
  push de;xy
  push bc;palettes

  ld hl, cmd_buffer

  ld a, ($4 << 3) + 1;ATTR_BLK
  ld [hli], a

  ld a, 1;num blocks
  ld [hli], a

  ld a, %011;control code
  ld [hli], a

  pop bc;palettes
  sla c
  sla c
  ld a, b
  add a, c;palA + palB<<2
  sla c
  sla c
  add a, c;palA + palB<<2 + palB<<4
  ld [hli], a

  pop de;xy
  pop bc;wh

  ld a, d
  ld [hli], a;x
  add a, b;x+w
  ld d, a;x+w

  ld a, e
  ld [hli], a;y
  add a, c;y+h
  ld e, a;y+h

  ld a, d;x+w
  ld [hli], a

  ld a, e;y+h
  ld [hl], a
  
  ld hl, cmd_buffer
  jp _sgb_PacketTransfer

; Copies data from GB VRAM to SNES RAM
; input: DE = Packet data
;        HL = Graphical data address
sgb_VRAMTransfer::
  ld a, [sys_info]
  and a, SYS_INFO_SGB
  ret z
_sgb_VRAMTransfer:
  ; store screen state
  di
  ldh a, [rLCDC]
  push af
  ldh a, [rSCX]
  push af
  ldh a, [rSCY]
  push af
  ldh a, [rBGP]
  push af

  push de                     ; packet data
  DISPLAY_OFF                 ; We disble interruptions and turn off the LCD because we are going to modify the VRAM data
  xor a
  ldh [rSCX], a
  ldh [rSCY], a
  ld a, %11100100
  ldh [rBGP], a                ; VRAM-transfer background palette value
  ld de, _VRAM + 2048
  ld bc, 4096
  call mem_Copy               ; We copy to the Game Boy VRAM the 4KB data that is going to be transferred to the SNES RAM

  ; We copy to the visible _SCRN0 background the 4KB data that is going to be transferred to the SNES RAM by VRAM-transfer
  ld hl, _SCRN0
  ld de, 12                   ; Background additional width
  ld a, $80                   ; VRAM address of the first tile
  ld c, 13                    ; Rows of data to be copied
.rowLoop:
    ld b, 20                  ; Visible background width
  .columnLoop:
      ld [hli], a             ; Tile set
      inc a
      dec b
      jr nz, .columnLoop
    add hl, de                ; Next visible background tile row
    dec c
    jr nz, .rowLoop

  ld a, LCDCF_ON | LCDCF_BGON
  ldh [rLCDC], a

  pop hl                      ; Packet data
  call _sgb_PacketTransfer    ; We send the packet that will produce the transfer

  ;restore screen state
  pop af
  ldh [rBGP], a
  pop af
  ldh [rSCX], a
  pop af
  ldh [rSCY], a
  pop af
  ldh [rLCDC], a
  reti

; Super Game Boy packet transfer
; input: HL = Packet address
sgb_PacketTransfer::
  ld a, [sys_info]
  and a, SYS_INFO_SGB
  ret z
_sgb_PacketTransfer:
  ld a, [hl]
  and %00000111               ; The three lower bits indicate the number of packets to send
  ret z                       ; We return if there are no packets to send
  ld b, a                     ; We store the number of packets to send

  ld a, [hl]
  rra
  rra
  rra
  and %00011111
  cp a, SGB_CODE_PAL_PRI+1        ;last code available
  ret nc
  cp a, SGB_CODE_OBJ_TRN
  ret z
  cp a, SGB_CODE_TEST_EN
  ret z
.sendPacketsLoop
    push bc
    xor a
    ldh [rP1], a               ; Initial pulse (Start write). P14 = LOW and P15 = LOW
    ld a, P1F_4 | P1F_5
    ldh [rP1], a               ; P14 = HIGH and P15 = HIGH between pulses
    ld b, 16                  ; Number of bytes per packet
  .sendBytesLoop
      ld e, 8                 ; Bits per byte
      ld a, [hli]
      ld d, a                 ; Next byte of the packet
    .sendBitsLoop
        bit 0, d
        ld a, P1F_4           ; P14 = HIGH and P15 = LOW (Write 1)
        jr nz, .skip
        ld a, P1F_5           ; P14 = LOW and P15 = HIGH (Write 0)
      .skip
        ldh [rP1], a           ; We send one bit
        ld a, P1F_4 | P1F_5
        ldh [rP1], a           ; P14 = HIGH and P15 = HIGH between pulses
        rr d                  ; We rotate the register so that the next bit goes to position 0
        dec e
        jr nz, .sendBitsLoop  ; We jump while there are bits left to be sent
      dec b
      jr nz, .sendBytesLoop   ; We jump while there are bytes left to be sent
    ld a, P1F_5
    ldh [rP1], a               ; Bit 129, stop bit (Write 0)
    ld a, P1F_4 | P1F_5
    ldh [rP1], a               ; P14 = HIGH and P15 = HIGH between pulses

    ; 280048 clock cycles are consumed (66.768646240234375 milliseconds) at 4.194304 mhz | 24 cycles
    ld de, 7000               ; 12 cycles
.wait24Cycles
      nop                     ; 4 cycles
      nop                     ; 4 cycles
      nop                     ; 4 cycles
      dec de                  ; 8 cycles
      ld a, d                 ; 4 cycles
      or e                    ; 4 cycles
      jr nz, .wait24Cycles    ; 12 cycles if jumps, 8 if not

    pop bc
    dec b
    jr nz, .sendPacketsLoop       ; We jump while there are packets left to be sent
  ret

sgb_CopyToWRAM::;a = SNES bank, bc = byte count, de = SNES address, hl = src data
  ld [cmd_buffer+3], a;SNES bank
  ld a, d
  ld [cmd_buffer+1], a;SNES address low
  ld a, e
  ld [cmd_buffer+2], a;SNES address high
  ld a, b
  and a
  jr nz, .useDataTransfer
  ld a, c
  cp a, 11
  jr nc, .useDataTransfer
.useDataSend
  ld [cmd_buffer+4], a;byte count
  ld a, SGB_CODE_DATA_SND
  ld [cmd_buffer], a
  ld de, cmd_buffer+5
  call mem_Copy
  ld hl, cmd_buffer
  jp _sgb_PacketTransfer
.useDataTransfer
  ld a, SGB_CODE_DATA_TRN
  ld [cmd_buffer], a
  ld de, cmd_buffer
  jp _sgb_VRAMTransfer
