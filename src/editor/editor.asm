INCLUDE "src/fatpak.inc"

SECTION "Editor cursor vars", WRAM0
cursor_white:: DB;EditorInvertCursor's last argument, for theme changes

SECTION FRAGMENT "Editor ROM0", ROM0
;C functions (src/editor/editor.h)
;   EditorSetup
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
  call PadPressed;clear presses latched before the editor started

  DISPLAY_ON
  ret

_EditorInvertCursor::;a = 1 for a white cursor (0 black), as on a light theme
  ld [cursor_white], a
  ld b, a
  ld a, [_theme];DMG's dark theme inverts every shade, so the cursor's colour flips too
  and a
  jr z, .shade
  ldh a, [sys_info]
  and a, SYS_INFO_GBC | SYS_INFO_SGB;they keep DMG shades and change colours
  jr nz, .shade
  ld a, b
  xor a, 1
  ld b, a
.shade
  ld a, b
  and a
  ld a, DMG_PAL_BDLW
  jr z, .setPalette
  ld a, DMG_PAL_WLDB
.setPalette
  ldh [rOBP1], a
  ret

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
