INCLUDE "src/text_editor.inc"

INCLUDE "src/editor/text_buffer.asm"
INCLUDE "src/editor/keywords.asm"
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
  ld hl, BusyTile
  ld de, _VRAM8000+BUSY_TILE*16
  ld bc, 16
  call mem_CopyVRAM
  ld c, BUSY_SPRITE
  ld d, BUSY_TILE
  call gbdk_SetSpriteTile

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

_WaitFrame::;the busy spinner shows if the next one is a while coming
  xor a
  ldh [busy_frames], a
  ld de, 0
  ld c, BUSY_SPRITE
  call gbdk_MoveSprite
  call gbdk_WaitVBL
  ld a, 1
  ldh [busy_frames], a
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

;text is color 3 on color 0, dim text color 2 (see src/editor/render.asm). DMG inverts selected pixels
;(dim text is light grey there), SGB and GBC highlight them with color 1. GBC tiles with accent ink use
;palettes 1-4 (StyleLooks), their color 1 is the accent
EditorSetPalettes:
  ldh a, [sys_info]
  and a, SYS_INFO_GBC
  jr z, .notGBC
  xor a
  ld hl, EditorPalette
  call GBCSetPalette
  ld a, BCPSF_AUTOINC | 8;BG palettes 1 and up
  ldh [rBCPS], a
  ld hl, EditorAccentPalettes
  ld c, EDITOR_ACCENTS*8
.accent
    LCD_WAIT_VRAM
    ld a, [hli]
    ldh [rBCPD], a
    dec c
    jr nz, .accent
  ret
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
  ld a, DMG_PAL_BDLW
  ldh [rBGP], a
  ret

;theme (UI and syntax colors in the settings later)
DEF_RGB EDITOR_PAPER,      29, 29, 27
DEF_RGB EDITOR_HIGHLIGHT,  20, 25, 31
DEF_RGB EDITOR_DIM,        14, 17, 14;grey-green: comments, markdown markers
DEF_RGB EDITOR_INK,         2,  2,  3
DEF EDITOR_ACCENTS EQU 4

EditorPalette:
  EDITOR_PAPER
  EDITOR_HIGHLIGHT
  EDITOR_DIM
  EDITOR_INK

EditorAccentPalettes:;color 1 is the accent
  EDITOR_PAPER
  RGB 4, 9, 24;1 blue: headings, keywords
  EDITOR_DIM
  EDITOR_INK
  EDITOR_PAPER
  RGB 19, 4, 4;2 dark red: code, strings
  EDITOR_DIM
  EDITOR_INK
  EDITOR_PAPER
  RGB 15, 5, 20;3 purple: numbers
  EDITOR_DIM
  EDITOR_INK
  EDITOR_PAPER
  RGB 21, 10, 0;4 brown-orange: preprocessor, directives, labels
  EDITOR_DIM
  EDITOR_INK

INCLUDE "src/editor/_editor.asm";generated from editor.c

INCLUDE "src/editor/undo.asm"
INCLUDE "src/editor/_undo.asm";generated from undo.c
