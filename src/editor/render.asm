;Draws rows of characters from tile_buffer (TB_STRIDE per row) as pixels, so fonts can have
;any width. Every screen cell has its own tile: 360 tiles is more than the background can
;address at once, so the top of the screen uses $8000 tile data and an LCD interrupt switches
;to $8800 halfway down. Rows 6-11 use tiles both modes share ($8800-$8FFF), so the switch can
;happen anywhere in those rows (the PS/2 interrupt can delay it).
;   rows 0-5    tiles 2-121     $8000 mode only (tiles 0 and 1 are sprites)
;   rows 6-11   tiles 128-247   either mode
;   rows 12-17  tiles 256-375   $8800 mode only
;
;C functions (src/editor/editor.h)
;   SetFont                     a = font, sets _font_widths and redraws rows using it
;   EditorDraw                  a = rows drawn with the editor's font, the rest use FONT_MONO
;   EditorRedraw                forgets which rows are drawn so EditorDraw redraws all of them

DEF RENDER_SPLIT_LY EQU 72;row 9, anywhere in rows 6-11 works

SECTION "Font Widths", WRAM0, ALIGN[8]
_font_widths:: DS 256;current font's widths, used to wrap rows

SECTION "Render Vars", WRAM0
render_font: DB;current font
row_font: DS TB_ROWS;font each row was drawn with, $FF = not drawn
render_row: DB
render_row_font: DB
render_src: DW
render_glyphs: DW
render_widths: DW
render_x: DB
render_w: DB
render_shift: DB
render_col: DB
draw_split: DB
draw_row: DB

DEF render_bitmap EQUS "cmd_buffer";160 bytes, 8 lines of 20 bytes (1bpp)
DEF render_tiles EQUS "(cmd_buffer+TB_WIDTH)";320 bytes, 20 tiles (2bpp)

SECTION "Render ROM0", ROM0

_SetFont::;a = font
  ld [render_font], a
  ld b, a
  ldh a, [loaded_bank]
  push af
  ld a, BANK(FontMonoWidths)
  SET_BANK
  ld hl, FontMonoWidths
  ld a, b
  and a
  jr z, .copy
  ld hl, FontVWFWidths
.copy
  ld de, _font_widths
  ld bc, 256
  call mem_Copy
  pop af
  SET_BANK
  ret

_EditorRedraw::
  ld a, $FF
  ld hl, row_font
  ld bc, TB_ROWS
  jp mem_Set

_EditorDraw::;a = rows drawn with the editor's font, the rest use FONT_MONO
  ld [draw_split], a
  ldh a, [loaded_bank]
  push af
  ld a, BANK(RenderRow)
  SET_BANK
  xor a
.loop
    ld [draw_row], a
    ld hl, draw_split
    cp a, [hl]
    ld e, FONT_MONO
    jr nc, .render
    ld a, [render_font]
    ld e, a
  .render
    ld a, [draw_row]
    call RenderRow
    ld a, [draw_row]
    inc a
    cp a, TB_ROWS
    jr c, .loop
  pop af
  SET_BANK
  ret

;returns x of character a in [_tb_found_row] of tile_buffer in a, using the current font
_RenderCursorX::
RenderCursorX::
  ld c, a;column
  ld a, [_tb_found_row]
  call RenderRowAddress
  ld de, tile_buffer
  add hl, de
  ld b, 0;x
  ld a, c
  and a
  jr z, .done
.sum
    ld a, [hli]
    push hl
    ld h, HIGH(_font_widths)
    ld l, a
    ld a, [hl]
    pop hl
    add a, b
    jr c, .clamp
    ld b, a
    dec c
    jr nz, .sum
.done
  ld a, b
  cp a, TB_WIDTH
  ret c
.clamp
  ld a, TB_WIDTH-1;hanging space or line feed, right edge of the screen
  ret

;a = row, returns row * TB_STRIDE in hl, affects a, de
RenderRowAddress:
  ld l, a
  ld h, 0
  add hl, hl
  add hl, hl
  add hl, hl
  ld d, h
  ld e, l
  add hl, hl
  add hl, hl
  add hl, de
  ret

;switches tile data addressing halfway down the screen and back at VBlank
RenderLCDInterrupt::
  ldh a, [rLYC]
  cp a, RENDER_SPLIT_LY
  ldh a, [rLCDC]
  jr nz, .top
  and a, ~LCDCF_BG8000
  ldh [rLCDC], a
  ld a, SCRN_Y
  ldh [rLYC], a
  ret
.top
  or a, LCDCF_BG8000
  ldh [rLCDC], a
  ld a, RENDER_SPLIT_LY
  ldh [rLYC], a
  ret

;display should be off, clears tiles, sets the background map, starts the LCD interrupt
RenderSetup::
  xor a
  ld hl, _VRAM8000
  ld bc, $1800
  call mem_SetVRAM
  ld hl, _SCRN0
  ld de, RowTileIndex
  ld c, TB_ROWS
.row
    ld a, [de]
    inc de
    ld b, TB_COLS
  .col
      ld [hli], a
      inc a
      dec b
      jr nz, .col
    ld a, l
    add a, SCRN_VX_B-TB_COLS
    ld l, a
    ld a, h
    adc a, 0
    ld h, a
    dec c
    jr nz, .row
  call _EditorRedraw
  HIDE_WIN
  ldh a, [rLCDC]
  or a, LCDCF_BG8000
  ldh [rLCDC], a
  ld a, RENDER_SPLIT_LY
  ldh [rLYC], a
  ld bc, RenderLCDInterrupt
  jp SetLCDInterrupt

;first tile index of each row, see the top of this file
RowTileIndex:
FOR ROW, TB_ROWS
IF ROW < 6
  DB 2 + ROW*TB_COLS
ELIF ROW < 12
  DB 128 + (ROW-6)*TB_COLS
ELSE
  DB (ROW-12)*TB_COLS
ENDC
ENDR

SECTION "Render", ROMX

INCLUDE "img/fonts/font_mono.asm"
INCLUDE "img/fonts/font_vwf.asm"

;VRAM address of the first tile of each row
RowTileAddress:
FOR ROW, TB_ROWS
IF ROW < 6
  DW _VRAM8000 + (2 + ROW*TB_COLS)*16
ELIF ROW < 12
  DW _VRAM8000 + (128 + (ROW-6)*TB_COLS)*16
ELSE
  DW _VRAM8000 + (256 + (ROW-12)*TB_COLS)*16
ENDC
ENDR

;a = row, e = font, draws the row's characters if they or the font changed
RenderRow:
  ld [render_row], a
  ld a, e
  ld [render_row_font], a
  ld a, [render_row]
  call RenderRowAddress
  push hl
  ld de, tile_buffer
  add hl, de
  ld a, l
  ld [render_src], a
  ld a, h
  ld [render_src+1], a
  pop hl
  ld de, bkg_buffer;characters drawn last time
  add hl, de
  ld d, h
  ld e, l

.checkFont
  ld a, [render_row]
  ld c, a
  ld b, 0
  ld hl, row_font
  add hl, bc
  ld a, [render_row_font]
  cp a, [hl]
  ld [hl], a
  jr nz, .changed
.checkChars
  LD_HL_VAR render_src
  ld b, TB_STRIDE
.compare
    ld a, [de]
    cp a, [hl]
    jr nz, .changed
    inc hl
    inc de
    dec b
    jr nz, .compare
  ret

.changed
  ld a, [render_row]
  call RenderRowAddress
  ld de, bkg_buffer
  add hl, de
  ld d, h
  ld e, l
  LD_HL_VAR render_src
  ld bc, TB_STRIDE
  call mem_Copy

  xor a
  ld hl, render_bitmap
  ld bc, TB_WIDTH
  call mem_Set

  ld hl, FontMonoGlyphs
  ld de, FontMonoWidths
  ld a, [render_row_font]
  and a
  jr z, .setFont
  ld hl, FontVWFGlyphs
  ld de, FontVWFWidths
.setFont
  ld a, l
  ld [render_glyphs], a
  ld a, h
  ld [render_glyphs+1], a
  ld a, e
  ld [render_widths], a
  ld a, d
  ld [render_widths+1], a

  xor a
  ld [render_x], a
  ld b, TB_STRIDE
.char
    ld a, [render_x]
    cp a, TB_WIDTH
    jr nc, .toTiles
    LD_HL_VAR render_src
    ld a, [hli]
    ld c, a
    ST_HL_VAR render_src
    ld a, c
    push bc
    call RenderGlyph
    pop bc
    dec b
    jr nz, .char

.toTiles;both bitplanes are the 1bpp line, drawn pixels are color 3
  ld hl, render_bitmap
  ld de, render_tiles
  ld c, TB_COLS
.tile
    push hl
    ld b, 8
  .line
      ld a, [hl]
      ld [de], a
      inc de
      ld [de], a
      inc de
      ld a, l
      add a, TB_COLS
      ld l, a
      ld a, h
      adc a, 0
      ld h, a
      dec b
      jr nz, .line
    pop hl
    inc hl
    dec c
    jr nz, .tile

  ld a, [render_row]
  add a, a
  ld c, a
  ld b, 0
  ld hl, RowTileAddress
  add hl, bc
  ld a, [hli]
  ld e, a
  ld d, [hl]
  ld hl, render_tiles
  ld bc, TB_COLS*16
  jp mem_CopyVRAM

;a = character, ORs its glyph into render_bitmap at [render_x] and advances it
RenderGlyph:
  ld c, a
  LD_HL_VAR render_widths
  ld b, 0
  add hl, bc
  ld a, [hl]
  ld [render_w], a
  ld l, c
  ld h, 0
  add hl, hl
  add hl, hl
  add hl, hl
  ld a, [render_glyphs]
  ld e, a
  ld a, [render_glyphs+1]
  ld d, a
  add hl, de;glyph
  ld a, [render_x]
  and a, %00000111
  ld [render_shift], a
  ld a, [render_x]
  srl a
  srl a
  srl a
  ld [render_col], a
  ld e, a
  ld d, 0
  push hl
  ld hl, render_bitmap
  add hl, de
  ld d, h
  ld e, l;bitmap byte
  pop hl
  ld c, 8
.line
    ld a, [hli]
    push hl
    ld h, a
    ld l, 0
    ld a, [render_shift]
    and a
    jr z, .write
    ld b, a
  .shift
      srl h
      rr l
      dec b
      jr nz, .shift
  .write
    ld a, [de]
    or a, h
    ld [de], a
    ld a, [render_col]
    cp a, TB_COLS-1
    jr nc, .nextLine
    inc de
    ld a, [de]
    or a, l
    ld [de], a
    dec de
  .nextLine
    ld a, e
    add a, TB_COLS
    ld e, a
    ld a, d
    adc a, 0
    ld d, a
    pop hl
    dec c
    jr nz, .line
  ld a, [render_x]
  ld b, a
  ld a, [render_w]
  add a, b
  ld [render_x], a
  ret
