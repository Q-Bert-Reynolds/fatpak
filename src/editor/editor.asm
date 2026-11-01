INCLUDE "src/text_editor.inc"

INCLUDE "src/editor/text_buffer.asm"
INCLUDE "src/editor/osk.asm"
INCLUDE "src/editor/render.asm"
INCLUDE "src/editor/sd.asm"

SECTION "Editor ROM0", ROM0
;C functions (src/editor/editor.h)
;   EditorSetup
;   WaitFrame                   waits for vblank, updates input
;   EditorShowCursor            a = show, uses tb_found_col/row
;   EditorInvertCursor          a = 1 for a white cursor (on selected text on DMG and SGB)

DEF CURSOR_SPRITE EQU 0

_EditorSetup::
  DISPLAY_OFF
  SET_DEFAULT_PALETTE
  TRAMPOLINE EditorSetPalettes
  CLEAR_SCREEN ' '
  call RenderSetup
  ld a, FONT_VWF
  call _SetFont

  ld a, %10000000;cursor is a 1 pixel vertical line on the left
  ld hl, _VRAM8000
  ld bc, 16
  call mem_SetVRAM
  ld c, CURSOR_SPRITE
  ld d, 0
  call gbdk_SetSpriteTile
  ld c, CURSOR_SPRITE
  ld d, OAMF_PAL1
  call gbdk_SetSpriteProp
  call OSKSetup

  ld a, KB_MODE_EDITOR
  TRAMPOLINE SetKeyboardMode
  call _tb_Load
  call PadPressed;clear presses latched before the editor started

  DISPLAY_ON
  ret

_EditorInvertCursor::;a = 1 for a white cursor
  and a
  ld a, DMG_PAL_BDLW
  jr z, .setPalette
  ld a, DMG_PAL_WLDB
.setPalette
  ldh [rOBP1], a
  ret

_WaitFrame::
  call gbdk_WaitVBL
  jp UpdateInput

_EditorShowCursor::;a = show
  and a
  jr z, .hide
  ld a, [_tb_found_row]
  cp a, $FF
  jr z, .hide
  ld hl, _render_text_top
  add a, [hl]
  add a, a
  add a, a
  add a, a
  add a, OAM_Y_OFS
  ld e, a;y
  push de
  ld a, [_tb_found_col]
  call RenderCursorX
  pop de
  add a, OAM_X_OFS
  ld d, a;x
  ld c, CURSOR_SPRITE
  jp gbdk_MoveSprite
.hide
  ld de, 0
  ld c, CURSOR_SPRITE
  jp gbdk_MoveSprite

SECTION FRAGMENT "Color", ROMX;GBCSetPalette and EditorPalette are in this bank

;selected pixels are colors 1 and 2 (see src/editor/render.asm)
EditorSetPalettes:
  ldh a, [sys_info]
  and a, SYS_INFO_GBC
  jr z, .notGBC
  xor a
  ld hl, EditorPalette
  jp GBCSetPalette
.notGBC
  ldh a, [sys_info]
  and a, SYS_INFO_SGB
  jr z, .dmg
  ld a, PAL01
  ld bc, EditorPalette
  ld d, b
  ld e, c
  jp sgb_SetPal
.dmg
  ld a, DMG_PAL_BWBW;inverts selected pixels
  ldh [rBGP], a
  ret

EditorPalette:
  COLOR_OFF_WHITE
  COLOR_BLUE;selection
  COLOR_OFF_WHITE;selected text
  COLOR_BLACK

INCLUDE "src/editor/_editor.asm";generated from editor.c
