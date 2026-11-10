;Cart-button entry follows stock GBCOS: unlock before reading resident state,
;capture the interrupted registers and mapper, then use a resident OS stack.
;The full-screen VWF menu uses the stock snapshot workspace. After capture,
;OS services may use WRAM/HRAM and the normal stack. Resume restores the full
;image; Return to OS repairs mapper-write bytes and restarts Main without reset.

DEF INGAME_PAGE EQU 4
DEF MENU_GRAPHICS_PAGE EQU 9
DEF MENU_BLOCK EQU $3E3F;metadata, below stock save-state workspace at $3E40
DEF MENU_LCDC EQU LCDCF_ON | LCDCF_BG8000 | LCDCF_BGON
DEF EDX_MAPPER EQU $BD07
DEF EDX_SWITCH EQU $BD09;bit 1 resumes the game, bit 2 selects the OS without reset
DEF menu_header EQU $BE20;160-byte 1bpp filename, prepared before launch

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
  ld a, INGAME_PAGE;the menu runs through the normal OS page window
  ld [EDX_PAGE], a
  ld a, HIGH(MENU_BLOCK);menu metadata in PSRAM, like the stock snapshot workspace
  ld [EDX_BLOCK+1], a
  ld a, LOW(MENU_BLOCK)
  ld [EDX_BLOCK], a

  jp InGameMenu

; Switch pages from resident code, without touching the game's loaded_bank HRAM.
MenuLoadGraphics:
  ld a, MENU_GRAPHICS_PAGE
  ld [EDX_PAGE], a
  call MenuGraphics
  ld a, INGAME_PAGE
  ld [EDX_PAGE], a
  ret

MenuLoadError:
  ld a, MENU_GRAPHICS_PAGE
  ld [EDX_PAGE], a
  call MenuError
  ld a, INGAME_PAGE
  ld [EDX_PAGE], a
  ret

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
  jp MenuWarmExit
InGameEntryEnd:
ASSERT InGameEntryEnd <= $2000, "resuming a game writes $2000, $2100 and $3000"

; Reserve the unused bytes between the reboot stub ($0000-$0008) and RST $20.
; This is writable resident OS memory, like stock GBCOS's $0620/$066e workspace.
; The deepest menu call chain uses six stack bytes; nine leaves three spare.
SECTION "In-Game State", ROM0[$0009]
ingame_sp: DW 0
ingame_mbc: DS 4, 0
_snapshot_model::
menu_cgb: DB 0
menu_lcdc: DB 0
menu_bgp: DB 0
menu_scroll: DS 2, 0
menu_vbk: DB 0
menu_bcps: DB 0
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
  ldh a, [rBGP]
  ld [menu_bgp], a
  ldh a, [rSCX]
  ld [menu_scroll], a
  ldh a, [rSCY]
  ld [menu_scroll+1], a
  call MenuOff

  call SnapshotCaptureGame
  ld sp, stack_bottom;the game RAM/stack is now in the full snapshot
  ld a, [menu_cgb]
  and a
  jr z, .draw
  ld a, 1
  ldh [rVBK], a
  ld hl, $9800
  ld bc, $400
  call MenuClear
  xor a
  ldh [rVBK], a
  ld hl, MenuPalette
  ld a, $80
  ldh [rBCPS], a
  ld b, 8
.palette
  ld a, [hli]
  ldh [rBCPD], a
  dec b
  jr nz, .palette
.draw
  ld hl, $8000
  ld bc, $800
  call MenuClear
  ld hl, $9800
  ld bc, $400
  call MenuClear
  call MenuLoadGraphics
  call MenuDrawHeader
  ld hl, MENU_FOOTER_VRAM
  ld de, MenuBarMasks
  ld b, 20
  call MenuTint
  xor a
  ldh [rSCX], a
  ldh [rSCY], a
  ld [menu_sel], a
  call MenuSelection
  ld a, $E4
  ldh [rBGP], a
  ld a, MENU_LCDC
  ldh [rLCDC], a
.release
  call MenuPad
  and a
  jr nz, .release
.loop
  call MenuPad
  and a
  jr z, .loop
  ld c, a
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
  push bc
  call MenuWait
  call MenuSelection;toggle off the old highlight without blanking the LCD
  pop bc
  ld a, [menu_sel]
  bit PADB_UP, c
  jr z, .down
  dec a
  jr .selection
.down
  inc a
.selection
  and a, 3
  ld [menu_sel], a
  call MenuSelection
  jr .loop
.choose
  ld a, [menu_sel]
  and a
  jr z, .resume
  cp a, 3
  jp z, ExitToOS
  dec a;0 save, 1 load
  push af
  call MenuOff
  pop af
  call _FileSnapshot
  and a
  jr z, .resume
  call MenuLoadError
  ld hl, MENU_FOOTER_VRAM
  ld de, MenuBarMasks
  ld b, 20
  call MenuTint
  ld a, MENU_LCDC
  ldh [rLCDC], a
  jp .loop
.resume
  call MenuOff
  jp SnapshotRestoreGame

MenuSelection:
  ld a, [menu_sel]
  add a, a
  ld e, a
  ld d, 0
  ld hl, MenuChoiceTiles
  add hl, de
  ld a, [hli]
  ld h, [hl]
  ld l, a
  ld de, MenuHighlightMasks
  ld b, MENU_BOX_COLS
  jp MenuTint
MenuChoiceTiles:
  DW MENU_CHOICE0_VRAM,MENU_CHOICE1_VRAM,MENU_CHOICE2_VRAM,MENU_CHOICE3_VRAM

;HL = unique tiles, DE = horizontal masks, B = tile count.
;Toggle the highlight: DMG inverts both planes; CGB toggles the low plane's
;background bits, preserving the high plane's ink. Calling twice restores it.
;Interrupts stay disabled. Each VRAM read/write group fits within the 80 dots
;of mode 2, even if mode 0/1 ends immediately after the STAT read.
MenuTint:
.tile
  ld a, [de]
  inc de
  ld c, a
  push bc
  ld b, 8
  ld a, [menu_cgb]
  and a
  jr z, .dmg
.cgbLine
  ldh a, [rSTAT]
  bit 1, a
  jr nz, .cgbLine
  ld a, [hli]
  xor a, c
  or a, [hl];ink stays color 3; only the paper toggles between 0 and 1
  dec hl
  ld [hli], a
  inc hl
  dec b
  jr nz, .cgbLine
  jr .next
.dmg
  ldh a, [rSTAT]
  bit 1, a
  jr nz, .dmg
  ld a, [hl]
  xor a, c
  ld [hli], a
  ld [hli], a
  dec b
  jr nz, .dmg
.next
  pop bc
  dec b
  jr nz, .tile
  ret

MenuDrawHeader:
  ld hl, menu_header
  ld de, $8600;tiles 96-115 are reserved for the filename
  ld b, 160
.line
  ld a, [menu_cgb]
  and a
  ld a, [hli]
  jr z, .dmg
  ld c, a
  ld a, $FF
  ld [de], a
  inc de
  ld a, c
  jr .high
.dmg
  cpl
  ld [de], a
  inc de
.high
  ld [de], a
  inc de
  dec b
  jr nz, .line
  ret

MenuClear:
  xor a
  ld [hli], a
  dec bc
  ld a, b
  or a, c
  jr nz, MenuClear
  ret

MenuWarmExit:
  ; No game state needs restoring when leaving it. Stop peripherals before
  ; Main clears RAM and installs its own interrupt/display state.
  di
  xor a
  ldh [rIE], a
  ldh [rTAC], a
  ldh [rSC], a
  ldh [rSTAT], a
  ldh [rIF], a
  ld [EDX_SWITCH], a
  ld a, [menu_cgb]
  and a
  jr z, .display
  ldh a, [rHDMA5]
  bit 7, a
  jr nz, .display
  xor a ; bit 7 clear terminates active HBlank DMA
  ldh [rHDMA5], a
.display
  call MenuOff
  xor a
  ldh [rNR52], a
  ldh [rTIMA], a
  ldh [rTMA], a
  ldh [rDIV], a
  ld a, [ingame_os_bytes+0]
  ld [$0000], a
  ld a, [ingame_os_bytes+1]
  ld [$2000], a
  ld a, [ingame_os_bytes+2]
  ld [$2100], a
  ld a, [ingame_os_bytes+3]
  ld [$3000], a
  ld a, [ingame_os_bytes+4]
  ld [$4000], a
  ld a, [ingame_os_bytes+5]
  ld [$6000], a
  jp WarmMain ; no $BD06=$10: preserve hardware mode and cartridge feature controls


;Detect actual CGB mode without depending on game WRAM or boot registers.
MenuCGB:
  ldh a, [rVBK]
  ld [menu_vbk], a
  ldh a, [rBCPS]
  ld [menu_bcps], a
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

;Turn the screen off at VBlank for initial drawing, snapshot I/O and exit.
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

;Labels are composed at build time with the editor's FontVWFGlyphs/Widths.
;This avoids using the editor renderer's game-owned WRAM/HRAM scratch space.
INCLUDE "build/ingame_menu.asm"
MenuPalette:
  EDITOR_PAPER
  EDITOR_HIGHLIGHT
  EDITOR_DIM
  EDITOR_INK
END_PAGE

PAGE LAUNCH_PAGE
;DE = Latin-1 basename. Called by LaunchGame before the game owns WRAM/HRAM.
_InGameHeader::
  ld a, 5;the editor's bar inset: space (4px), plus the initial pixel
  call RenderMenuText
  ld a, $04
  ld [EDX_CONFIG], a
  ld a, HIGH(MENU_BLOCK)
  ld [EDX_BLOCK+1], a
  ld a, LOW(MENU_BLOCK)
  ld [EDX_BLOCK], a
  ld hl, render_bitmap
  ld de, menu_header
  ld bc, TB_WIDTH
.copy
  ld a, [hli]
  ld [de], a
  inc de
  dec bc
  ld a, b
  or a, c
  jr nz, .copy
  ret

RenderMenuText:;a = left inset, de = Latin-1 text, returns its 1bpp row in render_bitmap
  ld [render_x], a
  ld a, e
  ld [render_src], a
  ld a, d
  ld [render_src+1], a
  ld hl, render_bitmap
  ld bc, TB_WIDTH
  xor a
  call mem_Set
  xor a
  ld [render_styled], a
  ld [render_head], a
  ld hl, FontVWFGlyphs
  ST_HL_VAR render_glyphs
  ld hl, FontVWFWidths
  ST_HL_VAR render_widths
.char
  LD_HL_VAR render_src
  ld a, [hli]
  and a
  jr z, .done
  ld c, a
  ST_HL_VAR render_src
  ld a, c
  call RenderGlyph
  ld a, [render_x]
  cp a, TB_WIDTH-4
  jr c, .char
.done
  ret
END_PAGE
