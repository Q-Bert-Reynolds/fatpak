
; Macro                                 Arguments
;   SET_BANK
;   TRAMPOLINE                            AddressInAnotherBank
;   PUSH_VAR                              WRAMAddressToStore
;   POP_VAR                               WRAMAddressToRestore
;   DEBUG_LOG_STRING                      "string"
;   DEBUG_LOG_ADDRESS                     address16 bank8
;   DEBUG_LOG_LABEL                       LabeledAddress
;   SET_LCD_INTERRUPT                     InterruptAddress
;   DISABLE_LCD_INTERRUPT
;   HIDE_ALL_SPRITES
;   CLEAR_SCREEN                          tile8
;   CLEAR_BKG_AREA                        x8, y8, w8, h8, tile8
;   CLEAR_WIN_AREA                        x8, y8, w8, h8, tile8
;   COPY_BKG_TO_BUFFER                    x8, y8, w8, h8
;   COPY_BUFFER_TO_BKG                    x8, y8, w8, h8
;   COPY_WIN_TO_BUFFER                    x8, y8, w8, h8
;   COPY_BUFFER_TO_WIN                    x8, y8, w8, h8
;   COPY_SCREEN_TO_FROM_BUFFER            x8, y8, w8, h8, _buffer, gbdk_Func
;   UPDATE_INPUT_AND_JUMP_TO_IF_BUTTONS   JumpAddress, buttons8
;   JUMP_TO_IF_BUTTONS                    JumpAddress, buttons8
;   EXITABLE_DELAY                        JumpAddress, buttons8, frames8
;   WAITPAD_UP                                    
;   WAITPAD_UP_OR_FRAMES                  frames8
;   SET_DEFAULT_PALETTE                                   
;   RGB                                   red5, green5, blue5
;   D24                                   num24
;   BETWEEN                               n8, n8
;   ADD_USER_PLAYER_DATA                  PlayerAddress, "nickname", pay24 

MACRO SET_BANK
  ldh [loaded_bank], a
  ld [rROMB0], a
ENDM

MACRO TRAMPOLINE ;\1 = jump address
  ld b, BANK(\1)
  ld hl, \1
  call Trampoline
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

MACRO SET_LCD_INTERRUPT ;\1 = interrupt address
  di

  ld b, ~IEF_STAT
  ldh a, [rIE]
  and a, b
  ldh [rIE], a

  xor a
  ldh [rSTAT], a

  ld hl, rLCDInterrupt
  ld bc, \1
  ld a, b
  ld [hli], a
  ld a, c
  ld [hl], a

  ld b, IEF_STAT
  ldh a, [rIE]
  or a, b
  ldh [rIE], a

  ld a, STATF_LYC
  ldh [rSTAT], a
  
  ei
ENDM

MACRO DISABLE_LCD_INTERRUPT
  di
    
  ld b, ~IEF_STAT
  ldh a, [rIE]
  and a, b
  ldh [rIE], a

  xor a
  ldh [rSTAT], a

  ld hl, rLCDInterrupt
  ld bc, EndLCDInterrupt
  ld a, b
  ld [hli], a
  ld a, c
  ld [hl], a

  ei
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
  ld d, \1;x
  ld e, \2;y
  ld h, \3;w
  ld l, \4;h
  ld bc, tile_buffer
  call gbdk_SetBkgTiles
ENDM

MACRO CLEAR_WIN_AREA ;x, y, w, h, tile
  ld a, \5;tile
  ld bc, \3 * \4;width * height
  ld hl, tile_buffer
  call mem_Set
  ld d, \1;x
  ld e, \2;y
  ld h, \3;w
  ld l, \4;h
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
  ld d, \1;x
  ld e, \2;y
  ld h, \3;w
  ld l, \4;h
  ld bc, \5;buffer
  call \6

  ld a, [sys_info]
  and a, SYS_INFO_GBC
  jr z, .skip\@

  ld a, 1
  ldh [rVBK], a
  ld d, \1;x
  ld e, \2;y
  ld h, \3;w
  ld l, \4;h
  ld bc, \3*\4+\5
  call \6
  xor a
  ldh [rVBK], a
.skip\@
ENDM

MACRO UPDATE_INPUT_AND_JUMP_TO_IF_BUTTONS ; \1=address, \2=buttons
  call UpdateInput
  JUMP_TO_IF_BUTTONS \1, \2
ENDM

MACRO JUMP_TO_IF_BUTTONS ; \1=address, \2=buttons
  ld a, [last_button_state]
  and a
  jr nz, .skip\@
  ld a, [button_state]
  and \2
  jp nz, \1
.skip\@
ENDM

MACRO EXITABLE_DELAY ; \1=address, \2=buttons, \3=frames
  ld a, \3
.loop\@
    push af
    UPDATE_INPUT_AND_JUMP_TO_IF_BUTTONS .jump\@, \2
    call gbdk_WaitVBL
    pop af
    dec a
    jr nz, .loop\@
  jr .exit\@
.jump\@
  pop af
  jp \1
.exit\@
ENDM

MACRO WAITPAD_UP
.loop\@
  call gbdk_WaitVBL
  call UpdateInput
  ld a, [last_button_state]
  and a
  jr nz, .loop\@
ENDM

MACRO WAITPAD_UP_OR_FRAMES ; \1=frames
  ld a, \1
.loop\@
    push af;frames
    call gbdk_WaitVBL
    call UpdateInput
    ld a, [last_button_state]
    and a
    jr z, .exit\@
    pop af;frames
    dec a
    jr nz, .loop\@
  push af;frames
.exit\@
  pop af;frames
ENDM

MACRO SET_DEFAULT_PALETTE
  ld hl, rBGP
  ld [hl], DMG_PAL_BDLW
  ld hl, rOBP0
  ld [hl], DMG_PAL_BDLW
  ld hl, rOBP1
  ld [hl], DMG_PAL_DLWW
ENDM

MACRO RGB ;\1 = red, \2 = green, \3 = blue
  DW (\3 << 10 | \2 << 5 | \1)
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

MACRO CLEAR_USER_PLAYER_DATA ;\1 = player address, \2 = pay 
  ld b, (\2 & $FF0000) >> 16
  ld c, (\2 & $00FF00) >> 8
  ld d, (\2 & $0000FF)
  ld hl, \1
  call ClearUserPlayerData
ENDM

MACRO ADD_USER_PLAYER_DATA ;\1 = player address, \2 = nickname, \3 = pay 
  jr .copyNickname\@
.nickname\@ 
  DB \2
  DS NICKNAME_LENGTH - STRLEN(\2)
.copyNickname\@
  ld hl, \1
  ld de, .nickname\@
  call SetUserPlayerName
  ld b, (\3 & $FF0000) >> 16
  ld c, (\3 & $00FF00) >> 8
  ld d, (\3 & $0000FF)
  ld hl, \1
  call SetUserPlayerPay
  ld a, [\1.age]
  call GetXPForAge
  ld hl, \1.xp
  ld a, c
  ld [hli], a
  ld a, d
  ld [hli], a
  ld a, e
  ld [hli], a
  ld hl, \1
  call GetPlayerMaxHP
  push hl;max hp
  call gbdk_Random
  pop hl;max hp
  ld a, d
  and a, h
  ld d, a
  ld a, e
  and a, l
  or a, 1
  ld e, a
  ld hl, \1
  call SetPlayerHP
ENDM
