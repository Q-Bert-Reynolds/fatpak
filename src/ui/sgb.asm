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
;   sgb_SetPal
;     Directly sets 2 SNES palettes. Packet can only be codes 0-3.
;     Input: a = packet header, bc = paletteA, de = paletteB
;   sgb_VRAMTransfer
;     Copies data to GB VRAM then to SNES.
;     Input: de = packet, hl = graphical data
;   sgb_PacketTransfer
;     Transfers data to SNES.
;     Input: hl = packet address


INCLUDE "src/sgb/commands.asm"

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

  PAGE SGB_PAGE

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
sgb_PalSetDefault:    PAL_SET PALETTE_GREY, PALETTE_SEPIA, PALETTE_UI, PALETTE_DARK
sgb_MltReqTwoPlayers: MLT_REQ 2
sgb_MltReqOnePlayer:  MLT_REQ 1

; Super Game Boy initialization
sgb_Init::
;the EverDrive's loader ran after the boot ROM, so ask for 2 players (MLT_REQ)
  ldh a, [sys_info]
  and a, SYS_INFO_GBC
  ret nz
  di
  call sgb_Check
  ret nc
  ldh a, [sys_info]
  or a, SYS_INFO_SGB
  ldh [sys_info], a
  di
  xor a;WRAM has not been initialized yet (including on a warm return)
  ld [sgb_from_window], a
  DISPLAY_OFF
  call sgb_SendInitPackets

.success
  ld hl, sgb_MaskEnFreeze
  call  _sgb_PacketTransfer       ; Freezes the visualization of the Super Game Boy screen to hide the graphic garbage during the VRAM transfers  

  TRAMPOLINE SGBTransferPalettes  ; Copies custom game palettes to SNES RAM

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
  and a                          ; We lower the carry flag
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
sgb_PalTrn::      PAL_TRN
sgb_MaskEnFreeze: MASK_EN 1
sgb_MaskEnCancel: MASK_EN 0
sgb_PalPriGame:   PAL_RPI 1
sgb_PalPriUser:   PAL_RPI 0

_SGBSetDefaultBorder::
sgb_SetDefaultBorder::;from the data file, if it loaded
  ldh a, [sys_info]
  and a, SYS_INFO_SGB
  ret z
  ld a, [_data_loaded]
  and a
  ret z
  di
  ; The border upload borrows the live renderer's tiles and map. Keep them in
  ; snapshot staging (unused during startup), with every interrupt masked: the
  ; raster handler would otherwise change LCDC during the transfer picture.
  ldh a, [rIE]
  push af
  xor a
  ldh [rIE], a
  ldh a, [rLCDC]
  push af
  ld hl, sgb_MaskEnFreeze
  call _sgb_PacketTransfer
  DISPLAY_OFF
  call sgb_SwapDisplay
  ld de, sgb_ChrTrn1
  ld hl, DATA_BLOCK + DATA_BORDER_TILES
  call sgb_WindowTransfer
  ld de, sgb_ChrTrn2
  ld hl, DATA_BLOCK + DATA_BORDER_TILES + 8
  call sgb_WindowTransfer
  ld de, sgb_PctTrn
  ld hl, DATA_BLOCK + DATA_BORDER_MAP
  call sgb_WindowTransfer
  call sgb_SwapDisplay
  pop af
  ldh [rLCDC], a
  ld hl, sgb_MaskEnCancel
  call _sgb_PacketTransfer
  pop af
  ldh [rIE], a
  reti

; LCD off. Swap $8800-$9FFF with 12 blocks at $3C00 (snapshot staging).
; Swapping twice restores all tile/map bytes without using the UI's WRAM.
sgb_SwapDisplay:
  ld a, [EDX_BLOCK]
  push af
  ld a, [EDX_BLOCK+1]
  push af
  ld a, $3C
  ld [EDX_BLOCK+1], a
  ld hl, $8800
  xor a
.block
  ld [EDX_BLOCK], a
  push af
  ld de, EDX_WINDOW
.byte
    ld b, [hl]
    ld a, [de]
    ld [hli], a
    ld a, b
    ld [de], a
    inc de
    ld a, d
    cp a, HIGH(EDX_WINDOW+512)
    jr nz, .byte
  pop af
  inc a
  cp a, 12
  jr c, .block
  pop af
  ld [EDX_BLOCK+1], a
  pop af
  ld [EDX_BLOCK], a
  ret

sgb_WindowTransfer:;de = packet, hl = first of 8 PSRAM blocks, _sgb_VRAMTransfer from the window
  ld a, 1
  ld [sgb_from_window], a
  call _sgb_VRAMTransfer
  xor a
  ld [sgb_from_window], a
  ret

sgb_CopyWindow:;hl = first block, de = destination, copies 8 blocks (4KB)
  ld a, [EDX_BLOCK];the text buffer's block
  push af
  ld a, [EDX_BLOCK+1]
  push af
  ld a, h
  ld [EDX_BLOCK+1], a
  ld b, 8
.block
    ld a, l
    ld [EDX_BLOCK], a
    push hl
    push bc
    ld hl, EDX_WINDOW
    ld bc, 512
    call mem_Copy
    pop bc
    pop hl
    inc l
    dec b
    jr nz, .block
  pop af
  ld [EDX_BLOCK+1], a
  pop af
  ld [EDX_BLOCK], a
  ret

sgb_SetPal:: ;a = packet header, bc = paletteA, de = paletteB
  ld hl, cmd_buffer
  ld [hli], a

  ldh a, [sys_info]
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
; Copies data from GB VRAM to SNES RAM
; input: DE = Packet data
;        HL = Graphical data address
sgb_VRAMTransfer::
  ldh a, [sys_info]
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
  ld a, [sgb_from_window]
  and a
  jr z, .copy
  call sgb_CopyWindow
  jr .copied
.copy
  ld bc, 4096
  call mem_Copy               ; We copy to the Game Boy VRAM the 4KB data that is going to be transferred to the SNES RAM
.copied

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
  DISPLAY_OFF
  pop af
  ldh [rBGP], a
  pop af
  ldh [rSCY], a
  pop af
  ldh [rSCX], a
  pop af
  ldh [rLCDC], a
  reti

; Super Game Boy packet transfer
; input: HL = Packet address
sgb_PacketTransfer::
  ldh a, [sys_info]
  and a, SYS_INFO_SGB
  ret z
INCLUDE "src/sgb/packet.asm"

; Stop the SNES bridge before replacing its GB driver or handing off a game.
KBDriverStop::
  ld a, [kb_type]
  cp KB_TYPE_SNES_MOUSE
  ret nz
  call SGBInputBegin
  push af
  ld hl, SNESStopPacket
  call sgb_PacketTransfer
  ld hl, SNESPingPacket
  call sgb_PacketTransfer
  pop af
  jp SGBInputEnd
SNESStopPacket:
  DB $79, 0, 8, 0, 3, $4c
  DW $1803; fixed Stop jump in src/sgb/mouse.s
  DS 8
SNESPingPacket:
  DB $c9, 1
  DS 14

SGBInputSync::
  ld a, [kb_type]
  cp KB_TYPE_SNES_MOUSE
  ret nz
INCLUDE "src/sgb/mouse_select.asm"

INCLUDE "src/sgb/input_irq.asm"
