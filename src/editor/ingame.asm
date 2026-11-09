;In-game menu (OS mode): the cart's system button combo makes the game's next VBlank vector fetch ($0040)
;read this image, with the game frozen (the EverDrive's OS jumps to its handler at $0670 from there, we're at
;$0670 too). Like the EverDrive's handler it reads nothing from the image before the registers are unlocked
;(the cart may only give it the code until then), so $0040 is rewritten instead of checking a flag: the file
;has jp InGameEntry, our boot points it at VBLInterrupt and GameLaunch back at InGameEntry.
;The menu is sprites over the game's picture: RESUME and EXIT TO OS in 10x2 boxed characters,
;the selected line inverted. It keeps the game's OAM, the sprite tiles it borrows ($8F60-$8FFF), the sprite
;palettes in PSRAM (MENU_BLOCK at the window) and puts them back with the screen off.
;After pushing the interrupted registers, it uses a resident OS stack, like stock GBCOS.
;Apart from the interrupt register pushes, the normal menu leaves game WRAM/HRAM alone. RESUME writes the game's mapper registers back (the cart has them at
;$BD14-$BD17), strobes $BD09 bit 1 and jumps to $0040 at the next VBlank, which the cart maps to the game's
;vector. EXIT TO OS writes $BD06 = $10, the cart reboots into the OS (which backs up the
;game's save). Learned from the EverDrive OS's handler at its $0670.

DEF INGAME_PAGE EQU 9;selected explicitly after unlocking and configuring OS mode
DEF MENU_TILE   EQU $F6;the 10 sprite tiles it borrows
DEF MENU_X      EQU 40+OAM_X_OFS
DEF MENU_Y      EQU 64+OAM_Y_OFS
DEF MENU_COLS   EQU 10
DEF MENU_LINES  EQU 2
DEF MENU_PAL    EQU 6;GBC sprite palettes 6 (normal) and 7 (selected)
DEF EDX_MAPPER  EQU $BD07
DEF EDX_SWITCH  EQU $BD09;bit 1: back to the game at its next $0040, bit 2: reboot into the OS
DEF MENU_BLOCK  EQU $3E3F;PSRAM, past games, below the EverDrive's save states ($3E40 on, the OS image may be at $3F00)

;The bulk sprite backup is in MENU_BLOCK at the window. Small variables and
;the menu stack are in the resident context at $0009.
RSSET $BE00
DEF menu_palettes RB 16
DEF menu_tiles    RB MENU_COLS*16
DEF menu_oam      RB OAM_COUNT*4
ASSERT _RS <= $C000

;Entry and resume code are resident and below the mapper write addresses.
;Like stock GBCOS, entry unlocks and configures the cart before reading OS data.
SECTION "In-Game Entry", ROM0[$0670]
InGameEntry::
  push af
  di
  push bc
  push de
  push hl
  ld a, EDX_KEY_UNLOCK
  ld [EDX_KEY], a
  ld a, $04;stock entry order: unlock, OS config, save SP, use a resident stack
  ld [EDX_CONFIG], a
  ld [ingame_sp], sp
  ld sp, ingame_stack_end
  xor a
  ld [$BD01], a
  ld a, INGAME_PAGE;the sprite menu runs through the normal OS page window
  ld [EDX_PAGE], a
  ld a, HIGH(MENU_BLOCK);bulk sprite backup in PSRAM, like the stock snapshot workspace
  ld [EDX_BLOCK+1], a
  ld a, LOW(MENU_BLOCK)
  ld [EDX_BLOCK], a

  jp InGameMenu

;b = RAMG, c = mode, d = RAM bank, e = ROM bank: the game's mapper registers (these land in
;this image's RAM too). Restore its SP, then hand back the pending VBlank at $0040.
InGameResume:
  ; Match the stock restore order: leave OS config before restoring mapper
  ; registers. All PSRAM reads are finished before this point.
  xor a
  ld [EDX_CONFIG], a
  ld hl, ingame_sp
  ld a, [hli]
  ld h, [hl]
  ld l, a
  ld sp, hl
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

ExitToOS:
  ; The OS image is writable and may survive a cart reboot. Stop advertising
  ; the in-game handler before requesting reset, not just when Main runs later.
  ld hl, $0041
  ld [hl], LOW(VBLInterrupt)
  inc l
  ld [hl], HIGH(VBLInterrupt)
  xor a
  ld [EDX_SWITCH], a ; clear any pending resume request
  ld a, $10
  ld [EDX_CONFIG], a ; use the stock reboot request, not a mapper-0/switch-4 pulse
  jr @
InGameEntryEnd:
ASSERT InGameEntryEnd <= $2000, "resuming a game writes $2000, $2100 and $3000"

; Reserve the unused bytes between the reboot stub ($0000-$0008) and RST $20.
; This is writable resident OS memory, like stock GBCOS's $0620/$066e workspace.
; The deepest menu call chain uses four stack bytes; nine leaves five spare.
SECTION "In-Game State", ROM0[$0009]
ingame_sp: DW 0
ingame_mbc: DS 4, 0
menu_cgb: DB 0
menu_lcdc: DB 0
menu_lcdc_on: DB 0
menu_obp: DS 2, 0
menu_vbk: DB 0
menu_ocps: DB 0
menu_sel: DB 0
ingame_stack: DS 9, 0
ingame_stack_end:
ASSERT ingame_stack_end == $0020

PAGE INGAME_PAGE
InGameMenu:
  ld hl, $BD14
  ld de, ingame_mbc
  ld b, 4
.mbc
    ld a, [hli]
    ld [de], a
    inc de
    dec b
    jr nz, .mbc
  call MenuCGB
  ld [menu_cgb], a
  ldh a, [rLCDC]
  ld [menu_lcdc], a
  ldh a, [rOBP0]
  ld [menu_obp], a
  ldh a, [rOBP1]
  ld [menu_obp+1], a
  call MenuOff

  ld hl, _OAMRAM;the game's sprites and the tiles the menu uses
  ld de, menu_oam
  ld bc, OAM_COUNT*4
  call MenuCopy
  ld hl, _VRAM8000+MENU_TILE*16
  ld de, menu_tiles
  ld bc, MENU_COLS*16
  call MenuCopy
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
  ld hl, MenuTiles
  ld de, _VRAM8000+MENU_TILE*16
  ld bc, MENU_COLS*16
  call MenuCopy
  ld a, $C0;DMG: color 1 white, 3 black, inverted in OBP1
  ldh [rOBP0], a
  ld a, $0C
  ldh [rOBP1], a
  xor a
  ld [menu_sel], a
  call MenuOAM
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
