
; Macro                                 Arguments
;   SET_BANK
;   TRAMPOLINE                            AddressInAnotherBank
;   BANKED_C                              CFunctionInAnotherBank
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
  DB "TEXT EDITOR",0,0,0,0
ENDM

MACRO CART_DEST
IF DEF(LANG_JA)
  DB CART_DEST_JAPANESE
ELSE
  DB CART_DEST_NON_JAPANESE
ENDC

ENDM

;EverDrive X OS mode (the image is /GBCSYS/GBCOS.BIN): the 128KB image is RAM, $0000-$7FFF is
;always pages 0-3 (ROM0 and ROMX bank 1, writing $2000 would overwrite code there) and $A000-$BFFF
;shows the page in $BD08. $BD00-$BFFF are the EverDrive's registers and its 512 byte window onto
;PSRAM in every page, so a page holds $1D00 bytes. The registers stay unlocked.
DEF EDX_PAGE  EQU $BD08
DEF EDX_BLOCK EQU $BD02;block shown at $BE00, $BD03 is the high byte
DEF EDX_WINDOW EQU $BE00
DEF EDX_CONFIG EQU $BD06;bit 1 picks save RAM (set) or PSRAM (clear) for the window
DEF PAGE_SIZE EQU $1D00
DEF FIRST_PAGE EQU 4
DEF LAST_PAGE EQU 15

MACRO SET_BANK;a = page
  ldh [loaded_bank], a
  ld [EDX_PAGE], a
ENDM

;code and data run from $A000 in page \1 (4-15), the ROM fragment and the LOAD fragment grow
;together so their offsets match, until END_PAGE or the next SECTION
MACRO PAGE;pages.link puts "Page n" at $4000 or $6000 of bank n/2 and "Page n RAM" at $A000 of SRAM bank n
  SECTION FRAGMENT "Page {d:\1}", ROMX, BANK[(\1) >> 1]
  LOAD FRAGMENT "Page {d:\1} RAM", SRAM, BANK[\1]
ENDM

MACRO END_PAGE;a SECTION also ends it
  ENDL
ENDM

;code and data that are always mapped, ROMX bank 1 ($4000-$7FFF)
MACRO FIXED;\1 = section name
  SECTION FRAGMENT "\1", ROMX, BANK[1]
ENDM

;Code and data are always mapped (FIXED) or live in an OS page.
DEF UI_PAGE       EQU 12
DEF KEYWORDS_PAGE EQU 13
DEF SGB_PAGE      EQU 13
DEF COLOR_PAGE    EQU 15
DEF KEYBOARD_PAGE EQU 15
DEF UNDO_PAGE     EQU 15;with undo.c (undo.banks)
DEF DOC_PAGE      EQU 14;with the large file functions in fatfs.c (fatfs.banks)
DEF GAME_PAGE     EQU 12;sd_ReadBlocks, with fs_GameCopy in fatfs.c (fatfs.banks)
DEF LAUNCH_PAGE   EQU 6;GameLaunch and game/loader.c (loader.banks)
MACRO KEYWORDS_SECTION
  PAGE KEYWORDS_PAGE
ENDM
MACRO COLOR_SECTION
  PAGE COLOR_PAGE
ENDM
MACRO KEYBOARD_SECTION
  PAGE KEYBOARD_PAGE
ENDM

MACRO TRAMPOLINE ;\1 = jump address
  ld b, BANK(\1)
  ld hl, \1
  call Trampoline
ENDM

;ROM0 stub body for calling C in another bank from C, keeps a, de, bc args and a, bc returns
;C functions called this way can't take stack args (more than 2 args, or a 32 bit first arg)
MACRO BANKED_C ;\1 = C function
  ld h, a
  ldh a, [loaded_bank]
  push af
  ld a, BANK(\1)
  SET_BANK
  ld a, h
  call \1
  ld h, a
  pop af
  SET_BANK
  ld a, h
  ret
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

;Little-endian words shared by text, drawing and file routines.
MACRO LD_HL_VAR ;\1 = address of little endian word
  ld a, [\1]
  ld l, a
  ld a, [\1+1]
  ld h, a
ENDM

MACRO ST_HL_VAR ;\1 = address of little endian word
  ld a, l
  ld [\1], a
  ld a, h
  ld [\1+1], a
ENDM

MACRO LD_BC_VAR ;\1 = address of little endian word
  ld a, [\1]
  ld c, a
  ld a, [\1+1]
  ld b, a
ENDM

MACRO LD_DE_VAR ;\1 = address of little endian word
  ld a, [\1]
  ld e, a
  ld a, [\1+1]
  ld d, a
ENDM

MACRO ST_DE_VAR ;\1 = address of little endian word
  ld a, e
  ld [\1], a
  ld a, d
  ld [\1+1], a
ENDM
