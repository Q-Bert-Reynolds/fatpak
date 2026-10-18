
; Macro                                 Arguments
;   SET_BANK
;   TRAMPOLINE                            AddressInAnotherBank
;   PUSH_VAR                              WRAMAddressToStore
;   POP_VAR                               WRAMAddressToRestore
;   DEBUG_LOG_STRING                      "string"
;   DEBUG_LOG_ADDRESS                     address16 bank8
;   DEBUG_LOG_LABEL                       LabeledAddress
;   LOAD_TILES                            tileAddress16, index8, count8
;   HIDE_ALL_SPRITES
;   CLEAR_SCREEN                          tile8
;   CLEAR_BKG_AREA                        x8, y8, w8, h8, tile8
;   CLEAR_WIN_AREA                        x8, y8, w8, h8, tile8
;   COPY_BKG_TO_BUFFER                    x8, y8, w8, h8
;   COPY_BUFFER_TO_BKG                    x8, y8, w8, h8
;   COPY_WIN_TO_BUFFER                    x8, y8, w8, h8
;   COPY_BUFFER_TO_WIN                    x8, y8, w8, h8
;   COPY_SCREEN_TO_FROM_BUFFER            x8, y8, w8, h8, _buffer, gbdk_Func
;   D24                                   num24
;   BETWEEN                               n8, n8

MACRO GAME_NAME
IF DEF(_HOME)
  DB "BEISBOL HOME",0,0,0
ELIF DEF(_AWAY)
  DB "BEISBOL AWAY",0,0,0
ELSE
  DB "BEISBOL DEMO",0,0,0
ENDC
ENDM

MACRO CART_DEST
IF DEF(LANG_JA)
  DB CART_DEST_JAPANESE
ELSE
  DB CART_DEST_NON_JAPANESE
ENDC
ENDM

MACRO SET_BANK
  ldh [loaded_bank], a
  ld [rROMB0], a
ENDM

MACRO TRAMPOLINE ;\1 = jump address
  ld b, BANK(\1)
  ld hl, \1
  rst Trampoline
ENDM

MACRO PUSH_VAR ;\1 = WRAM address
  ld a, [\1]
  push af
ENDM

MACRO POP_VAR ;\1 = WRAM address
  pop af
  ld [\1], a
ENDM

MACRO PUSH_ALL
  push af
  push bc
  push de
  push hl
ENDM

MACRO POP_ALL
  pop hl
  pop de
  pop bc
  pop af
ENDM

;Debug messages can contain expressions between %%. 
;When enabled in the settings, whenever a debug message is encountered in the code, it will be logged to the debug messages window or log file.
;Debug messages also support ternary operators in the form: "%boolean expression%text if true;text if false;".
MACRO DEBUG_LOG_STRING; \1 = string
  ld  d, d
  jr .end\@
  dw $6464
  dw $0000
  db \1,0
.end\@:
ENDM

MACRO DEBUG_LOG_ADDRESS; \1 = address, \2 = bank
  ld  d, d
  jr .end\@
  dw $6464
  dw $0001
  db \1
  dw \2
.end\@:
ENDM

MACRO DEBUG_LOG_LABEL; \1 = label
  DEBUG_LOG_ADDRESS \1, BANK(\1)
ENDM

MACRO LOAD_TILES ;\1 = tile address, \2 = vram address, \3 = index, \4 = count
  ld hl, \1
  ld de, \2 + \3*16
  ld bc, \4*16
IF (\2 + \3*16 + \4*16) > $9800
  call mem_CopyToTileData
ELSE
  call mem_CopyVRAM
ENDC
ENDM

MACRO CLEAR_SCREEN ;\1 = tile
  ld a, \1;tile
  call ClearScreen
ENDM

MACRO CLEAR_BKG_AREA ;x, y, w, h, tile
  ld a, \5;tile
  ld bc, \3 * \4;width * height
  ld hl, tile_buffer
  call mem_Set
  ld de, ((\1<<8)|\2);xy
  ld hl, ((\3<<8)|\4);wh
  ld bc, tile_buffer
  call gbdk_SetBkgTiles
ENDM

MACRO CLEAR_WIN_AREA ;x, y, w, h, tile
  ld a, \5;tile
  ld bc, \3 * \4;width * height
  ld hl, tile_buffer
  call mem_Set
  ld de, ((\1<<8)|\2);xy
  ld hl, ((\3<<8)|\4);wh
  ld bc, tile_buffer
  call gbdk_SetWinTiles
ENDM

MACRO COPY_BKG_TO_BUFFER ;x, y, w, h
  COPY_SCREEN_TO_FROM_BUFFER \1, \2, \3, \4, bkg_buffer, gbdk_GetBkgTiles
ENDM

MACRO COPY_BUFFER_TO_BKG ;x, y, w, h
  COPY_SCREEN_TO_FROM_BUFFER \1, \2, \3, \4, bkg_buffer, gbdk_SetBkgTiles
ENDM

MACRO COPY_WIN_TO_BUFFER ;x, y, w, h
  COPY_SCREEN_TO_FROM_BUFFER \1, \2, \3, \4, win_buffer, gbdk_GetWinTiles
ENDM

MACRO COPY_BUFFER_TO_WIN ;x, y, w, h
  COPY_SCREEN_TO_FROM_BUFFER \1, \2, \3, \4, win_buffer, gbdk_SetWinTiles
ENDM

MACRO COPY_SCREEN_TO_FROM_BUFFER ;x, y, w, h, buffer, function
  ld de, ((\1<<8)|\2);xy
  ld hl, ((\3<<8)|\4);wh
  ld bc, \5;buffer
  call \6

  ldh a, [sys_info]
  and a, SYS_INFO_GBC
  jr z, .skip\@

  ld a, 1
  ldh [rVBK], a
  ld de, ((\1<<8)|\2);xy
  ld hl, ((\3<<8)|\4);wh
  ld bc, \3*\4+\5
  call \6
  xor a
  ldh [rVBK], a
.skip\@
ENDM

MACRO D24 ;\1 = 24 bit number 
  DB (\1 & $FF0000) >> 16
  DB (\1 & $00FF00) >> 8
  DB (\1 & $0000FF)
ENDM

MACRO D32 ;\1 = 32 bit number 
  DB (\1 & $FF000000) >> 24
  DB (\1 & $00FF0000) >> 16
  DB (\1 & $0000FF00) >> 8
  DB (\1 & $000000FF)
ENDM

MACRO BETWEEN; if \1 <= a < \2
IF \1 > \2
  FAIL "ERROR: LOWER BOUND CAN'T BE HIGHER THAN UPPER BOUND."
ELIF \1 < 0 && \2 >= 0
  cp 128
  jr c, .positive\@
  cp \1
  jr nc, .true\@
  jr .false\@
.positive\@
  cp \2
  jr c, .true\@
  jr .false\@
ELSE
  cp \1
  jr c, .false\@
  cp \2
  jr nc, .false\@
  jr .true\@
ENDC
.false\@
  xor a
  jr .end\@
.true\@
  ld a, 1
  and a
.end\@
ENDM
