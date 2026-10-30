INCLUDE "src/beisbol.inc"

INCLUDE "src/editor/text_buffer.asm"

SECTION "Editor ROM0", ROM0
;C functions (src/editor/editor.h)
;   EditorSetup
;   WaitFrame                   waits for vblank, updates input
;   EditorDraw                  copies tile_buffer to the screen
;   EditorShowCursor            a = show, uses tb_found_col/row

DEF CURSOR_SPRITE EQU 0

_EditorSetup::
  DISPLAY_OFF
  SET_DEFAULT_PALETTE
  TRAMPOLINE UILoadFontTiles
  CLEAR_SCREEN ' '

  ld a, %10000000;cursor is a 1 pixel vertical line on the left
  ld hl, _VRAM8000
  ld bc, 16
  call mem_SetVRAM
  ld c, CURSOR_SPRITE
  ld d, 0
  call gbdk_SetSpriteTile
  ld c, CURSOR_SPRITE
  ld d, 0
  call gbdk_SetSpriteProp

  ld a, KB_MODE_EDITOR
  TRAMPOLINE SetKeyboardMode
  call _tb_Load

  DISPLAY_ON
  ret

_WaitFrame::
  call gbdk_WaitVBL
  jp UpdateInput

_EditorDraw::
  ld de, 0
  ld hl, (TB_COLS << 8) | TB_ROWS
  ld bc, tile_buffer
  jp gbdk_SetBkgTiles

_EditorShowCursor::;a = show
  and a
  jr z, .hide
  ld a, [_tb_found_row]
  cp a, $FF
  jr z, .hide
  add a, a
  add a, a
  add a, a
  add a, OAM_Y_OFS
  ld e, a;y
  ld a, [_tb_found_col]
  add a, a
  add a, a
  add a, a
  add a, OAM_X_OFS
  ld d, a;x
  ld c, CURSOR_SPRITE
  jp gbdk_MoveSprite
.hide
  ld de, 0
  ld c, CURSOR_SPRITE
  jp gbdk_MoveSprite

INCLUDE "src/editor/_editor.asm";generated from editor.c
