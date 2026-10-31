;Draws rows of characters from tile_buffer (TB_STRIDE per row) as pixels, so fonts can have
;any width. Every screen cell has its own tile: 360 tiles is more than the background can
;address at once, so an LCD interrupt switches between $8000 and $8800 tile data partway down.
;Rows draw into 18 blocks of 20 tiles kept in a ring, scrolling a row rotates the ring by one
;(SCY moves 8 pixels and only the new row is drawn). Blocks between the $8000 only and $8800
;only blocks use tiles both modes share, so a switch can happen anywhere in them (the PS/2
;interrupt can delay it).
;   blocks 0-5    tiles 2-121     $8000 mode only (tiles 0 and 1 are sprites)
;   blocks 6-8    tiles 128-187   either mode
;   blocks 9-14   tiles 256-375   $8800 mode only
;   blocks 15-17  tiles 188-247   either mode
;Screen row r draws into block (render_block_top + r) % TB_ROWS. Mode switches (at most 2) are
;staged in render_pending_* and applied with SCY at line 144.
;
;C functions (src/editor/editor.h)
;   SetFont                     a = font, sets _font_widths and redraws rows using it
;   EditorDraw                  a = rows drawn with the editor's font, the rest use FONT_MONO
;   EditorRedraw                forgets which rows are drawn so EditorDraw redraws all of them
;   RenderSetMapRow             a = BG map row, e = block, points the map row at the block's tiles


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
render_block: DB
_render_block_top:: DB;block of screen row 0
render_top_mode: DB;LCDCF_BG8000 or 0 at the top of the screen
render_split_count: DB
render_splits: DS 4;LY, mode
render_split_index: DB
_render_pending:: DB;set after staging a scroll, cleared at line 144 when it's applied
_render_pending_scy:: DB
_render_pending_top_mode:: DB
_render_pending_split_count:: DB
_render_pending_splits:: DS 4
render_map_row: DS TB_COLS

DEF render_bitmap EQUS "cmd_buffer";160 bytes, 20 tiles of 8 lines (1bpp), must start a page
DEF RENDER_BURST EQU 4;bytes written to VRAM per HBlank (8 writes)

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

;switches tile data addressing at render_splits, and at line 144 applies a staged scroll and
;sets the mode for the top of the next frame
RenderLCDInterrupt::
  ldh a, [rLYC]
  cp a, SCRN_Y
  jr z, .vblank
  ld a, [render_split_index]
  ld e, a
  inc a
  ld [render_split_index], a
  ld d, 0
  ld hl, render_splits+1
  add hl, de
  add hl, de
  ld b, [hl];mode
  call .setMode
  ld a, [render_split_index]
  ld hl, render_split_count
  cp a, [hl]
  jr nc, .nextVBlank
  ld hl, render_splits
  add a, a
  add a, l
  ld l, a
  ld a, h
  adc a, 0
  ld h, a
  ld a, [hl]
  ldh [rLYC], a
  ret
.nextVBlank
  ld a, SCRN_Y
  ldh [rLYC], a
  ret

.vblank
  ld a, [_render_pending]
  and a
  jr z, .frameStart
  ld a, [_render_pending_scy]
  ldh [rSCY], a
  ld hl, _render_pending_top_mode
  ld de, render_top_mode
  ld b, 2+4;top mode, count, splits
.copySplits
    ld a, [hli]
    ld [de], a
    inc de
    dec b
    jr nz, .copySplits
  xor a
  ld [_render_pending], a
.frameStart
  ld a, [render_top_mode]
  ld b, a
  call .setMode
  xor a
  ld [render_split_index], a
  ld a, [render_split_count]
  and a
  jr z, .nextVBlank
  ld a, [render_splits]
  ldh [rLYC], a
  ret

.setMode;b = LCDCF_BG8000 or 0
  ldh a, [rLCDC]
  and a, ~LCDCF_BG8000
  or a, b
  ldh [rLCDC], a
  ret

_RenderSetMapRow::;a = BG map row, e = block
  push af
  ld d, 0
  ld hl, BlockTileIndex
  add hl, de
  ld a, [hl]
  ld hl, render_map_row
  ld b, TB_COLS
.index
    ld [hli], a
    inc a
    dec b
    jr nz, .index
  pop af
  ld l, a
  ld h, 0
  add hl, hl
  add hl, hl
  add hl, hl
  add hl, hl
  add hl, hl;row * SCRN_VX_B
  ld de, _SCRN0
  add hl, de
  ld d, h
  ld e, l
  ld hl, render_map_row
  ld bc, TB_COLS
  jp mem_CopyVRAM

;display should be off, clears tiles, sets the background map, starts the LCD interrupt
RenderSetup::
  xor a
  ld hl, _VRAM8000
  ld bc, $1800
  call mem_SetVRAM
  ld hl, _SCRN0
  ld de, BlockTileIndex
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
  xor a
  ld [_render_block_top], a
  ld [_render_pending], a
  ld [render_split_index], a
  ldh [rSCY], a
  ld a, LCDCF_BG8000;blocks 0-5 on top
  ld [render_top_mode], a
  ld a, 1
  ld [render_split_count], a
  ld a, 7*8;middle of blocks 6-8
  ld [render_splits], a
  xor a
  ld [render_splits+1], a
  ldh a, [rLCDC]
  or a, LCDCF_BG8000
  ldh [rLCDC], a
  ld a, 7*8
  ldh [rLYC], a
  ld bc, RenderLCDInterrupt
  jp SetLCDInterrupt

;first tile index of each block, see the top of this file
BlockTileIndex:
FOR BLOCK, TB_ROWS
IF BLOCK < 6
  DB 2 + BLOCK*TB_COLS
ELIF BLOCK < 9
  DB 128 + (BLOCK-6)*TB_COLS
ELIF BLOCK < 15
  DB (BLOCK-9)*TB_COLS
ELSE
  DB 128 + (BLOCK-12)*TB_COLS
ENDC
ENDR

SECTION "Render", ROMX, ALIGN[12];shift tables must be 4KB aligned and in this bank
ASSERT LOW(render_bitmap) == 0, "render_bitmap must be page aligned"

;RenderShiftRight + s * 256 + byte = byte >> s, 8 pages later is the bits shifted out (byte << (8 - s))
RenderShiftRight:
FOR RS_SHIFT, 8
FOR RS_BYTE, 256
  DB RS_BYTE >> RS_SHIFT
ENDR
ENDR
RenderShiftLeft:
FOR RS_SHIFT, 8
FOR RS_BYTE, 256
  DB (RS_BYTE << (8 - RS_SHIFT)) & $FF
ENDR
ENDR

INCLUDE "img/fonts/font_mono.asm"
INCLUDE "img/fonts/font_vwf.asm"

;VRAM address of the first tile of each block
BlockTileAddress:
FOR BLOCK, TB_ROWS
IF BLOCK < 6
  DW _VRAM8000 + (2 + BLOCK*TB_COLS)*16
ELIF BLOCK < 9
  DW _VRAM8000 + (128 + (BLOCK-6)*TB_COLS)*16
ELIF BLOCK < 15
  DW _VRAM8000 + (256 + (BLOCK-9)*TB_COLS)*16
ELSE
  DW _VRAM8000 + (128 + (BLOCK-12)*TB_COLS)*16
ENDC
ENDR

;a = screen row, e = font, draws the row's characters into its block if they or the font changed
RenderRow:
  ld [render_row], a
  ld a, e
  ld [render_row_font], a
  ld a, [_render_block_top]
  ld hl, render_row
  add a, [hl]
  cp a, TB_ROWS
  jr c, .setBlock
  sub a, TB_ROWS
.setBlock
  ld [render_block], a
  ld a, [render_row]
  call RenderRowAddress
  ld de, tile_buffer
  add hl, de
  ld a, l
  ld [render_src], a
  ld a, h
  ld [render_src+1], a
  ld a, [render_block]
  call RenderRowAddress
  ld de, bkg_buffer;characters the block shows
  add hl, de
  ld d, h
  ld e, l

.checkFont
  ld a, [render_block]
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
  ld a, [render_block]
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
    jr nc, .toVRAM
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

.toVRAM;both bitplanes are the 1bpp byte, drawn pixels are color 3
  ld a, [render_block]
  add a, a
  ld c, a
  ld b, 0
  ld hl, BlockTileAddress
  add hl, bc
  ld a, [hli]
  ld e, a
  ld d, [hl]
  ld hl, render_bitmap
  ld c, TB_WIDTH/RENDER_BURST
.burst
    ldh a, [rLY]
    cp a, SCRN_Y
    jr c, .waitForHBlank
    cp a, SCRN_Y+8
    jr c, .write;VBlank with time left
  .waitForHBlank;start of mode 0, then mode 0 and 2 leave at least ~160 cycles
      ldh a, [rSTAT]
      and a, STATF_BUSY
      jr z, .waitForHBlank
  .waitForNotBusy
      ldh a, [rSTAT]
      and a, STATF_BUSY
      jr nz, .waitForNotBusy
  .write
    di
REPT RENDER_BURST;tiles are 16 byte aligned, so a burst never crosses a page
    ld a, [hli]
    ld [de], a
    inc e
    ld [de], a
    inc e
ENDR
    ei
    ld a, e
    and a
    jr nz, .nextBurst
    inc d
.nextBurst
    dec c
    jr nz, .burst
  ret

;a = character, ORs its glyph into render_bitmap at [render_x] and advances it
RenderGlyph:
  ld c, a
  ld b, 0
  LD_HL_VAR render_widths
  add hl, bc
  ld a, [hl]
  ld [render_w], a
  ld l, c
  ld h, b
  add hl, hl
  add hl, hl
  add hl, hl
  ld a, [render_glyphs]
  ld c, a
  ld a, [render_glyphs+1]
  ld b, a
  add hl, bc
  ld b, h
  ld c, l;glyph
  ld a, [render_x]
  and a, %11111000;tile * 8
  add a, LOW(render_bitmap)
  ld e, a
  ld d, HIGH(render_bitmap)
  ld a, [render_x]
  and a, %00000111
  add a, HIGH(RenderShiftRight)
  ld h, a;shift table page, set 3 for the left shift table
  ld a, [render_x]
  cp a, TB_WIDTH-8
  jp nc, .lastTile
REPT 8;glyph line spans this tile and the next
  ld a, [bc]
  inc bc
  ld l, a
  ld a, [de]
  or a, [hl]
  ld [de], a
  set 3, h
  ld a, e
  add a, 8
  ld e, a
  ld a, [de]
  or a, [hl]
  ld [de], a
  res 3, h
  ld a, e
  sub a, 7
  ld e, a
ENDR
  jr .advance
.lastTile
REPT 8
  ld a, [bc]
  inc bc
  ld l, a
  ld a, [de]
  or a, [hl]
  ld [de], a
  inc e
ENDR
.advance
  ld a, [render_x]
  ld b, a
  ld a, [render_w]
  add a, b
  ld [render_x], a
  ret
