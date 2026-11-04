;In-game menu (OS mode): the cart's system button combo makes the game's next VBlank vector fetch ($0040)
;read this image, with the game frozen (the EverDrive's OS jumps to its handler at $0670 from there, we're at
;$0670 too). Like the EverDrive's handler it reads nothing from the image before the registers are unlocked
;(the cart may only give it the code until then), so $0040 is rewritten instead of checking a flag: the file
;has jp InGameEntry, our boot points it at VBLInterrupt and GameLaunch back at InGameEntry.
;The menu is sprites over the game's picture: RESUME and EXIT TO OS in 10x2 boxed characters,
;the selected line inverted. It keeps the game's OAM, the sprite tiles it borrows ($8F60-$8FFF), the sprite
;palettes and LCDC in PSRAM (MENU_BLOCK at the window) and puts them back, on the game's stack like an interrupt
;(on the X7 a stack in the page or the window didn't keep what was pushed), writing them with the screen off.
;The game's WRAM and HRAM aren't touched. RESUME writes the game's mapper registers back (the cart has them at
;$BD14-$BD17), strobes $BD09 bit 1 and jumps to $0040 at the next VBlank, which the cart maps to the game's
;vector. EXIT TO OS writes $BD06 = $10, the cart reboots into the OS (which backs up the
;game's save). Learned from the EverDrive OS's handler at its $0670.

DEF INGAME_PAGE EQU 9;the page at $A000 while a game is paused on the X7 ($BD08 writes don't take, it read 9)
DEF MENU_TILE   EQU $F6;the 10 sprite tiles it borrows
DEF MENU_X      EQU 40+OAM_X_OFS
DEF MENU_Y      EQU 64+OAM_Y_OFS
DEF MENU_COLS   EQU 10
DEF MENU_LINES  EQU 2
DEF MENU_PAL    EQU 6;GBC sprite palettes 6 (normal) and 7 (selected)
DEF EDX_MAPPER  EQU $BD07
DEF EDX_SWITCH  EQU $BD09;bit 1: back to the game at its next $0040, bit 2: reboot into the OS
DEF MENU_BLOCK  EQU $3E3F;PSRAM, past games, below the EverDrive's save states ($3E40 on, the OS image may be at $3F00)

;the menu's variables, in MENU_BLOCK at the window
DEF ig_page EQU $C9F0;INGAME_DIAG: DiagPage's record
DEF ig_trace EQU $C9F8;INGAME_DIAG: "IG", the last step (STEP), in the game's WRAM: nothing written to the window
;survives the return to the OS on the X7, WRAM does until our boot copies it (src/main.asm)
RSSET $BE00
DEF ingame_mbc    RB 4;$BD14-$BD17
DEF menu_cgb      RB 1
DEF menu_lcdc     RB 1
DEF menu_lcdc_on  RB 1;with the menu
DEF menu_obp      RB 2
DEF menu_vbk      RB 1
DEF menu_ocps     RB 1
DEF menu_sel      RB 1
DEF menu_palettes RB 16
DEF menu_tiles    RB MENU_COLS*16
DEF menu_oam      RB OAM_COUNT*4
ASSERT _RS <= $C000

;INGAME_DIAG (make DIAG=1): the background turns a color at each step, for ~0.4s, and STEP records the last
;one in the trace
MACRO STEP
IF DEF(INGAME_DIAG)
  ld a, \1
  ld [ig_trace+2], a
ENDC
ENDM
MACRO DIAG;color (BGR555), off: the X7 showed colors that may not have been these
ENDM
IF DEF(INGAME_DIAG)
SECTION "Diag Color", ROM0[$0000];unused space, $0000 is written by RAMG writes
  nop
;de = color (BGR555) for all background palettes, affects a, b
DiagColor:
  ld a, $80
  ldh [rBCPS], a
  ld b, 32
.palette
    ld a, e
    ldh [rBCPD], a
    ld a, d
    ldh [rBCPD], a
    dec b
    jr nz, .palette
  ret
;~0.4s, affects a, bc
DiagWait:
  ld bc, 0
.wait
    dec bc
    ld a, b
    or a, c
    jr nz, .wait
  ret

;colors that survive a washed-out screen: red = bank 1 code runs, $BD06 = $10, black = still here, mapper 0 and a
;$BD09 bit 2 strobe, white = still here (the entry's own color is too brief to see)
SECTION "In-Game Diag", ROMX, BANK[1]
DiagBoot::;our boot: the game's WRAM $C800-$C9FF (records) to PSRAM $3E3E, before anything uses WRAM
  ld a, $3E
  ld [EDX_BLOCK+1], a
  ld [EDX_BLOCK], a
  ld hl, $C800
  ld de, $BE00
  ld bc, 512
  jp mem_Copy
DiagExit:;the X7 showed no color: "E" then a count of red loops (16 bit) after "H", how long it ran before the cart
  ld a, 'E';went back to the OS
  ld [ig_page+1], a
  ld hl, ig_page+2
  xor a
  ld [hli], a
  ld [hld], a
.loop
    ld de, $001F
    push hl
    call DiagColor
    pop hl
    inc [hl]
    jr nz, .loop
    inc l
    inc [hl]
    dec l
    jr .loop
ENDC

;all of it is below $0700: the cart may only map the start of the image until the registers are unlocked
;(the EverDrive OS's handler stays below $0A88 until then)
SECTION "In-Game Entry", ROM0[$0670]
InGameEntry::
  push af
IF DEF(INGAME_DIAG);"H" in the game's WRAM before anything else: did $0670 run at all?
  ld a, 'H'
  ld [ig_page], a
ENDC
  di
  push bc
  push de
  push hl
IF !DEF(INGAME_DIAG);DiagExit waits before its writes
  ld d, 3;~1s first: on the X7 register writes right after the button were ignored (the page stayed 9, the
.settle;exits froze), $BD06 = $10 after ~0.4s went back to the OS
    ld bc, 0
  .wait
      dec bc
      ld a, b
      or a, c
      jr nz, .wait
    dec d
    jr nz, .settle
ENDC
  ld a, EDX_KEY_UNLOCK
  ld [EDX_KEY], a
  ld a, $04;as the EverDrive's OS: $BD06, $BD01 then the page (a RAMG write here kept the page register at
  ld [EDX_CONFIG], a;its old value on the X7)
  xor a
  ld [$BD01], a
  ld a, INGAME_PAGE;its code is in the page (writes to it may not stick)
  ld [EDX_PAGE], a
  ld a, HIGH(MENU_BLOCK);its variables are in a PSRAM block at the window, like the EverDrive's data
  ld [EDX_BLOCK+1], a
  ld a, LOW(MENU_BLOCK)
  ld [EDX_BLOCK], a
IF DEF(INGAME_DIAG)
  jp DiagExit
ENDC
  jp InGameMenu;on the game's stack, like an interrupt (writes to the page and the window may not stick)

;b = RAMG, c = mode, d = RAM bank, e = ROM bank: the game's mapper registers (these land in
;this image's RAM too), back to the game at its next $0040 (the cart's), then its VBlank
InGameResume:
  ld a, b
  ld [rRAMG], a
  ld a, c
  ld [$6000], a
  srl a
  ld [$3000], a
  ld a, d
  ld [rRAMB], a
  ld a, e
  ld [$2100], a
  ld [$2000], a
  xor a
  ld [EDX_CONFIG], a
  ld a, 2
  ld [EDX_SWITCH], a
  xor a
  ld [EDX_SWITCH], a
  pop hl
  pop de
  pop bc
  ldh a, [rIF]
  and a, ~IEF_VBLANK
  ldh [rIF], a
.waitVBlank
    ldh a, [rIF]
    and a, IEF_VBLANK
    jr z, .waitVBlank
  pop af
  jp $0040

ExitToOS:;the cart reboots into the OS, like the EverDrive's "Back to menu" ($BD06 = $10 at its boot with $01F2 set,
  ld a, $10;then it waits). Mapper 0 and a $BD09 bit 2 strobe froze the X7
  ld [EDX_CONFIG], a
  jr @
InGameEntryEnd:
ASSERT InGameEntryEnd <= $2000, "resuming a game writes $2000, $2100 and $3000"

PAGE INGAME_PAGE
IF DEF(INGAME_DIAG)
InGameProbe:;DiagPage
  ld a, 'X'
  ld [ig_page+15], a
  ret
ENDC
InGameMenu:
  ld hl, $BD14
  DIAG $7FE0;cyan: its code in the page runs
IF DEF(INGAME_DIAG);a trace: "IG", the last step reached (our boot writes it to /GBCSYS/INGAME.DMP)
  push hl
  ld hl, ig_trace
  ld [hl], 'I'
  inc l
  ld [hl], 'G'
  inc l
  ld [hl], 1
  pop hl
ENDC
  STEP 2
  ld de, ingame_mbc
  ld b, 4
.mbc
    ld a, [hli]
    ld [de], a
    inc de
    dec b
    jr nz, .mbc
  call MenuCGB
  STEP 3
  ld [menu_cgb], a
  ldh a, [rLCDC]
  ld [menu_lcdc], a
  ldh a, [rOBP0]
  ld [menu_obp], a
  ldh a, [rOBP1]
  ld [menu_obp+1], a
  call MenuOff
  STEP 4

  ld hl, _OAMRAM;the game's sprites and the tiles the menu uses
  ld de, menu_oam
  ld bc, OAM_COUNT*4
  call MenuCopy
  STEP 5
  ld hl, _VRAM8000+MENU_TILE*16
  ld de, menu_tiles
  ld bc, MENU_COLS*16
  call MenuCopy
  STEP 6
  ld a, [menu_cgb]
  and a
  jr z, .tiles
  ld a, $80 | (MENU_PAL*8);GBC: sprite palettes 6 and 7
  ld hl, menu_palettes
  ld b, 16
.savePalette
    ldh [rOCPS], a
    ld c, a
    ldh a, [rOCPD]
    ld [hli], a
    ld a, c
    inc a
    dec b
    jr nz, .savePalette
  ld hl, MenuPalettes
  ld a, $80 | (MENU_PAL*8)
  ldh [rOCPS], a
  ld b, 16
.palette
    ld a, [hli]
    ldh [rOCPD], a
    dec b
    jr nz, .palette
.tiles
  STEP 7
  ld hl, MenuTiles
  ld de, _VRAM8000+MENU_TILE*16
  ld bc, MENU_COLS*16
  call MenuCopy
  STEP 8
  ld a, $C0;DMG: color 1 white, 3 black, inverted in OBP1
  ldh [rOBP0], a
  ld a, $0C
  ldh [rOBP1], a
  xor a
  ld [menu_sel], a
  call MenuOAM
  STEP 9
  ld a, [menu_lcdc]
  or a, LCDCF_ON | LCDCF_OBJON
  and a, ~LCDCF_OBJ16
  ld b, a
  ld a, [menu_cgb]
  and a
  ld a, b
  jr z, .lcdc
  and a, ~1;GBC: sprites over the background whatever its attributes say
.lcdc
  ld [menu_lcdc_on], a
  ldh [rLCDC], a
  STEP 10
IF DEF(INGAME_DIAG);what the hardware has after the setup, in the game's WRAM at $C800 (our boot writes it to
  ldh a, [rLCDC];/GBCSYS/INGAME.DMP after the EXIT TO OS below): "IGDG", LCDC, the registers below, then at
  push af;+$20 OAM, +$C0 the menu's tiles ($8F60), +$160 sprite palettes 6 and 7 (all read with the screen
  call MenuOff;off), +$170 MenuTiles' first 16 bytes read from the page
  STEP 11
  pop bc
  ld hl, $C800
  ld a, 'I'
  ld [hli], a
  ld a, 'G'
  ld [hli], a
  ld a, 'D'
  ld [hli], a
  ld a, 'G'
  ld [hli], a
  ld a, b
  ld [hli], a
  ldh a, [rSTAT]
  ld [hli], a
  ldh a, [rLY]
  ld [hli], a
  ldh a, [rSCY]
  ld [hli], a
  ldh a, [rSCX]
  ld [hli], a
  ldh a, [rWY]
  ld [hli], a
  ldh a, [rWX]
  ld [hli], a
  ldh a, [rBGP]
  ld [hli], a
  ldh a, [rOBP0]
  ld [hli], a
  ldh a, [rOBP1]
  ld [hli], a
  ldh a, [rVBK]
  ld [hli], a
  ldh a, [rSVBK]
  ld [hli], a
  ldh a, [rKEY1]
  ld [hli], a
  ldh a, [rIE]
  ld [hli], a
  ldh a, [rIF]
  ld [hli], a
  ldh a, [rHDMA5]
  ld [hli], a
  ldh a, [rOPRI]
  ld [hli], a
  ld l, $20
  ld de, _OAMRAM
  ld b, OAM_COUNT*4
.dumpOAM
    ld a, [de]
    ld [hli], a
    inc e
    dec b
    jr nz, .dumpOAM
  ld de, _VRAM8000+MENU_TILE*16
  ld b, MENU_COLS*16
.dumpTiles
    ld a, [de]
    ld [hli], a
    inc de
    dec b
    jr nz, .dumpTiles
  ld a, $80 | (MENU_PAL*8)
  ld b, 16
.dumpPalettes
    ldh [rOCPS], a
    ld c, a
    ldh a, [rOCPD]
    ld [hli], a
    ld a, c
    inc a
    dec b
    jr nz, .dumpPalettes
  ld de, MenuTiles
  ld b, 16
.dumpSource
    ld a, [de]
    ld [hli], a
    inc de
    dec b
    jr nz, .dumpSource
  ld a, [menu_lcdc_on]
  ldh [rLCDC], a
  STEP 12
  DIAG $03E0;green, then EXIT TO OS after ~3s (so the record reaches the card)
  DIAG $03E0
  DIAG $03E0
  DIAG $03E0
  DIAG $03E0
  DIAG $03E0
  DIAG $03E0
  STEP 13
  jp ExitToOS
ENDC

  DIAG $03E0;green: the menu is up
.release;the combo is still held
    call MenuPad
    and a
    jr nz, .release
.loop
    call MenuPad
    and a
    jr z, .loop
    ld c, a;MenuPad uses b
  .wait
      call MenuPad
      and a
      jr nz, .wait
    ld a, c
    bit PADB_UP, a
    jr nz, .move
    bit PADB_DOWN, a
    jr nz, .move
    bit PADB_SELECT, a
    jr nz, .move
    and a, PADF_A | PADF_START
    jr nz, .choose
    bit PADB_B, c
    jr nz, .resume
    jr .loop
  .move
    ld a, [menu_sel]
    xor a, 1
    ld [menu_sel], a
    call MenuOff
    call MenuOAM
    ld a, [menu_lcdc_on]
    ldh [rLCDC], a
    jr .loop
.choose
  ld a, [menu_sel]
  and a
  jp nz, ExitToOS
.resume
  call MenuOff
  ld hl, menu_oam;the game's screen back
  ld de, _OAMRAM
  ld bc, OAM_COUNT*4
  call MenuCopy
  ld hl, menu_tiles
  ld de, _VRAM8000+MENU_TILE*16
  ld bc, MENU_COLS*16
  call MenuCopy
  ld a, [menu_cgb]
  and a
  jr z, .registers
  ld a, $80 | (MENU_PAL*8)
  ldh [rOCPS], a
  ld hl, menu_palettes
  ld b, 16
.restorePalette
    ld a, [hli]
    ldh [rOCPD], a
    dec b
    jr nz, .restorePalette
.registers
  ld a, [menu_obp]
  ldh [rOBP0], a
  ld a, [menu_obp+1]
  ldh [rOBP1], a
  ld a, [menu_lcdc]
  ldh [rLCDC], a
  ld a, [menu_cgb]
  and a
  jr z, .mapper
  ld a, [menu_vbk]
  ldh [rVBK], a
  ld a, [menu_ocps]
  ldh [rOCPS], a
.mapper;like the EverDrive's OS, from ROM0: the game's cart RAM may be at $A000 again once RAMG is written
  ld hl, ingame_mbc
  ld a, [hli]
  ld b, a
  ld a, [hli]
  ld c, a
  ld a, [hli]
  ld d, a
  ld e, [hl]
  jp InGameResume

;returns a = 1 in GBC mode (VBK works, a DMG game on a GBC is in DMG mode), saves VBK and OCPS
MenuCGB:
  ldh a, [rVBK]
  ld [menu_vbk], a
  ldh a, [rOCPS]
  ld [menu_ocps], a
  ld a, 1
  ldh [rVBK], a
  ldh a, [rVBK]
  and a, 1
  ret z
  xor a
  ldh [rVBK], a
  ldh a, [rVBK]
  and a, 1
  xor a, 1
  ret

;hl = source, de = destination, bc = count (> 0), the screen off (MenuOff)
MenuCopy:
  ld a, [hli]
  ld [de], a
  inc de
  dec bc
  ld a, b
  or a, c
  jr nz, MenuCopy
  ret

;turns the screen off at the start of VBlank: VRAM, OAM and the palettes can be written at any time (it's
;off for about a frame each time the menu changes, the hardware's timing can't get in the way)
MenuOff:
  call MenuWait
  ldh a, [rLCDC]
  and a, ~LCDCF_ON
  ldh [rLCDC], a
  ret

;waits for the start of VBlank (not if the screen is off)
MenuWait:
  ldh a, [rLCDC]
  and a, LCDCF_ON
  ret z
.wait
    ldh a, [rLY]
    cp a, SCRN_Y
    jr nz, .wait
  ret

;returns the pressed buttons in a (PADF_*: d-pad in the high nibble), once a frame
MenuPad:
  call MenuWait
.leave;past line 144, so the next MenuWait waits a frame
    ldh a, [rLCDC]
    and a, LCDCF_ON
    jr z, .read
    ldh a, [rLY]
    cp a, SCRN_Y
    jr z, .leave
.read
  ld a, P1F_GET_DPAD
  ldh [rP1], a
REPT 4
  ldh a, [rP1]
ENDR
  cpl
  and a, $0F
  swap a
  ld b, a
  ld a, P1F_GET_BTN
  ldh [rP1], a
REPT 6
  ldh a, [rP1]
ENDR
  cpl
  and a, $0F
  or a, b
  ld b, a
  ld a, $30;neither
  ldh [rP1], a
  ld a, b
  ret

;OAM = the menu's sprites (the selected line inverted), the rest hidden, the screen off (MenuOff)
MenuOAM:
  ld hl, _OAMRAM
  ld de, MenuText
  ld c, 0;line
.line
    ld b, MENU_COLS
    ld a, c
    add a, a
    add a, a
    add a, a
    add a, MENU_Y
    push af;y
  .char
      pop af
      ld [hli], a
      push af
      ld a, MENU_COLS
      sub a, b
      add a, a
      add a, a
      add a, a
      add a, MENU_X
      ld [hli], a;x
      ld a, [de]
      inc de
      ld [hli], a;tile
      ld a, [menu_sel]
      cp a, c
      ld a, MENU_PAL
      jr nz, .attributes
      ld a, OAMF_PAL1 | (MENU_PAL+1)
  .attributes
      ld [hli], a
      dec b
      jr nz, .char
    pop af
    inc c
    ld a, c
    cp a, MENU_LINES
    jr nz, .line
  ld b, (OAM_COUNT-MENU_COLS*MENU_LINES)*4
  xor a
.hide
    ld [hli], a
    dec b
    jr nz, .hide
  ret

;the menu's characters as the tiles MENU_TILE on, the font's glyphs as ink (color 3) on color 1
DEF MENU_CHARS EQUS "\"RESUMXITO \""
MenuTiles:
FOR CHAR, STRLEN(MENU_CHARS)
  FOR ROW, 8
    DB $FF
    INCBIN "img/ui_font.tiles", CHARVAL(STRSLICE(MENU_CHARS, CHAR, CHAR+1))*16+ROW*2, 1
  ENDR
ENDR
MenuText:
  FOR CHAR, STRLEN("RESUME    EXIT TO OS")
    DB MENU_TILE + STRFIND(MENU_CHARS, STRSLICE("RESUME    EXIT TO OS", CHAR, CHAR+1))
  ENDR
ASSERT @ - MenuText == MENU_COLS*MENU_LINES
MenuPalettes:;GBC sprite palettes 6 (white, black) and 7 (inverted), colors 0 and 2 unused
  DW $7FFF, $7FFF, $7FFF, $0000
  DW $0000, $0000, $0000, $7FFF
END_PAGE
