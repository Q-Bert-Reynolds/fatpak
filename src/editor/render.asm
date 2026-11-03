;Draws rows of characters from tile_buffer (TB_STRIDE per row) as pixels, so fonts can have
;any width. Every screen cell has its own tile: 360 tiles is more than the background can
;address at once, so an LCD interrupt switches between $8000 and $8800 tile data partway down.
;Rows draw into 18 blocks of 20 tiles. Text rows use a ring of blocks in the BG map, scrolling a
;row rotates the ring by one (SCY moves 8 pixels and only the new row is drawn). The file name bar,
;the on screen keyboard and the status bar keep their own blocks and are shown by the window, so
;they stay put when the text scrolls (see Layout in editor.c and RenderStage). Blocks between the $8000 only and $8800 only
;blocks use tiles both modes share, so a switch can happen anywhere in them (the PS/2 interrupt
;can delay it).
;   blocks 0-5    tiles 2-121     $8000 mode only (tiles 0 and 1 are sprites)
;   blocks 6-8    tiles 128-187   either mode
;   blocks 9-14   tiles 256-375   $8800 mode only
;   blocks 15-17  tiles 188-247   either mode
;Screen row r draws tile_buffer row render_row_lines[r] into block render_row_blocks[r] with font
;render_row_fonts[r]. Mode switches and window changes are staged by RenderStage and applied
;with SCY at line 144.
;A box (menus) can be drawn over rows: render_box_* set its screen rows, pixel x and width, and
;its text, BOX_STRIDE chars per line in the variable width font, the selected row is highlighted.
;Its first and last rows are half rows with the top and bottom border, text goes in the rows between.
;Glyphs are drawn into render_bitmap (ink), and also into render_dim or render_accent (GBC) for text
;whose style (StyleLooks) has dim or accent ink. RenderEncode makes the 2bpp tiles: ink is color 3 on
;color 0, dim ink color 2, accent ink color 1. DMG inverts selected pixels (both bitplanes, dim ink
;turns light grey), SGB and GBC highlight them: unselected pixels get color 1 and accent ink becomes
;color 3. On GBC a tile with accent ink uses the accent's palette (written to the map attributes with
;the row, RenderWritePalettes), selected tiles palette 0. See EditorSetPalettes.
;
;C functions (src/editor/editor.h)
;   SetFont                     a = font, sets _font_widths and redraws rows using it
;   EditorDraw                  draws the screen rows whose characters, font or selection changed
;   EditorRedraw                forgets which rows are drawn so EditorDraw redraws all of them
;   RenderSetMapRow             a = BG map row (32 and up are window map rows), e = block, points the map row at the block's tiles
;   RenderStage                 stages LCDC changes for render_row_blocks, render_text_top and tb_rows
;   RenderTextWidth             de = text (0 ends it), returns its width in the variable width font in a


DEF RENDER_BLOCKS EQU TB_ROWS+1;block 18 is GBC only, the text ring's spare for smooth scrolling
DEF GBC_BANK1_BLOCK EQU 12;GBC: blocks 0-11 are tiles 128-367 of VRAM bank 0, 12-18 tiles 128-267 of bank 1
DEF SCROLL_STEP EQU 2;GBC: pixels SCY moves a frame
DEF RENDER_EVENTS EQU 6;LCDC changes per frame: 2 for the window, the rest for tile data mode switches

SECTION "Font Widths", WRAM0, ALIGN[8]
_font_widths:: DS 256;current font's widths, used to wrap rows

SECTION "Render Vars", WRAM0
row_font: DS RENDER_BLOCKS;font each block was drawn with, $FF = not drawn
render_row: DB
render_row_font: DB
render_src: DW
render_glyphs: DW
render_widths: DW
render_line: DB;tile_buffer row RenderRow draws
render_styled: DB;1 = a text row, widths and styles come from tile_attrs
render_attr: DB;style of the char RenderGlyph draws
render_head: DB;heading font: 1-4, 0 = none
font_bold:: DB;pixels bold adds to the current font's glyphs
render_look: DB;StyleLooks of the char RenderGlyph draws
render_inked: DB;bit 0: render_dim is used in this row, bit 1: render_accent
render_highlight: DB;1 on SGB and GBC: selected pixels are highlighted, not inverted
_block_map_rows::
block_map_rows: DS RENDER_BLOCKS;map row each block is shown in, $FF = none (used for GBC attributes)
block_accents: DS RENDER_BLOCKS;GBC: the block's map row has accent palettes
_render_text:: DB;1 = rows below tb_rows are TBScanRow's text (styled by tile_attrs), 0 = the file browser and help draw their own
render_x: DB
render_w: DB
render_shift: DB
render_col: DB
draw_row: DB
render_block: DB
_render_row_blocks:: DS TB_ROWS;block each screen row draws into
_render_row_lines:: DS TB_ROWS;tile_buffer row each screen row shows
_render_row_fonts:: DS TB_ROWS;font each screen row uses
_render_text_top:: DB;screen row of text row 0
render_top_lcdc: DB;LCDCF_BG8000 and LCDCF_WINON at the top of the screen
render_event_count: DB
render_events: DS RENDER_EVENTS*2;LY, LCDC bits from there on
render_event_index: DB
_render_pending:: DB;set after staging a scroll, cleared at line 144 when it's applied
_render_pending_scy:: DB
render_pending_wy: DB
render_pending_anim: DB;GBC: scroll to the staged SCY a few pixels a frame
render_target_scy: DB;SCY the screen is scrolling to
_render_gbc:: DB;1 on GBC: no tile data mode switches, smooth scrolling, rows sent with HDMA
render_pending_lcdc: DB;staged render_top_lcdc, render_event_count and render_events, in that order
render_pending_count: DB
render_pending_events: DS RENDER_EVENTS*2
stage_mode: DB;RenderStage
stage_win: DB
stage_shared: DB;first of the rows since the last one that needs a mode, $FF = none
render_map_row: DS TB_COLS
_render_sel:: DS TB_ROWS*2;selected columns of each screen row (first, end), end $FF = right edge, first = end for none
block_sel: DS RENDER_BLOCKS*2;selection each block was drawn with
render_sel_first: DB
render_sel_end: DB
render_sel_x: DB
render_sel_end_x: DB
_render_box_top:: DB;screen row, $FF = no box
_render_box_rows:: DB
_render_box_x:: DB
_render_box_w:: DB;pixels, including the border
_render_box_sel:: DB;selected row of the box
_render_box_gen:: DB;changed for each new box, so blocks drawn with an old one are drawn again
_render_box_text:: DW
render_box_line: DB
render_box_count: DB
render_box_y: DB;lines of the row the box covers
render_box_h: DB
block_box: DS RENDER_BLOCKS;RenderBoxSig each block was drawn with

DEF render_bitmap EQUS "cmd_buffer";160 bytes, 20 tiles of 8 lines (1bpp), must start a page
DEF render_mask EQUS "(cmd_buffer+TB_WIDTH)";selected pixels of each tile, in the same page
DEF render_box_mask EQUS "(cmd_buffer+TB_WIDTH+TB_COLS)";the box's pixels of each tile
DEF render_pals EQUS "(cmd_buffer+TB_WIDTH+TB_COLS*2)";GBC: accent palette of each tile, in the same page
DEF render_dim EQUS "(cmd_buffer+$100)";pixels of dim ink, the page after render_bitmap
DEF render_accent EQUS "win_buffer";GBC: pixels of accent ink (win_buffer is only used between renders)
DEF RENDER_BURST EQU 8;bytes written to VRAM per HBlank

SECTION "Render ROM0", ROM0

RenderFarGlyph:;a = bank, hl = glyph, copies it to render_glyph, returns render_glyph in bc, affects a, de, hl
  ld b, a
  ldh a, [loaded_bank]
  ld c, a
  ld a, b
  SET_BANK
  ld de, render_glyph
REPT 8
  ld a, [hli]
  ld [de], a
  inc de
ENDR
  ld a, c
  SET_BANK
  ld bc, render_glyph
  ret

_SetFont::;a = font
  ld b, a
  cp a, FONT_FIXED
  ld a, 1
  jr nz, .setBold
  inc a;the fixed font's bold glyphs are stretched
.setBold
  ld [font_bold], a
  ldh a, [loaded_bank]
  push af
  ld a, BANK(FontMonoWidths)
  SET_BANK
  ld hl, FontMonoWidths
  ld a, b
  and a
  jr z, .copy
  ld hl, FontVWFWidths
  dec a
  jr z, .copy
  ld hl, FontFixedWidths
.copy
  ld de, _font_widths
  ld bc, 256
  call mem_Copy
  pop af
  SET_BANK
  ret

_RenderTextWidth::;de = text (0 ends it), returns its width in the variable width font in a
  ldh a, [loaded_bank]
  push af
  ld a, BANK(FontVWFWidths)
  SET_BANK
  ld b, 0
.loop
    ld a, [de]
    and a
    jr z, .done
    inc de
    push de
    ld e, a
    ld d, 0
    ld hl, FontVWFWidths
    add hl, de
    ld a, [hl]
    pop de
    add a, b
    ld b, a
    jr .loop
.done
  pop af
  SET_BANK
  ld a, b
  ret

_EditorRedraw::
  ld a, $FF
  ld hl, row_font
  ld bc, RENDER_BLOCKS
  jp mem_Set

_EditorDraw::
  ld a, [_render_pending]
  cp a, 2
  jr nz, .waitScroll
.waitSettled;GBC one row scroll: the new row's block is the one the last scroll left, wait until it's off screen
    ldh a, [rSCY]
    ld hl, render_target_scy
    cp a, [hl]
    jr nz, .waitSettled
  jr .draw
.waitScroll;a block that left the screen isn't drawn into until the scroll is applied
    ld a, [_render_pending]
    and a
    jr nz, .waitScroll
.draw
  ldh a, [loaded_bank]
  push af
  ld a, BANK(RenderRow)
  SET_BANK
  xor a
.loop
    ld [draw_row], a
    ld c, a
    ld b, 0
    ld hl, _render_row_fonts
    add hl, bc
    ld e, [hl]
    ld hl, _render_row_lines
    add hl, bc
    ld a, [hl]
    ld d, a
    call RenderLineStyled
    jr nc, .font
    ld a, d
    add a, a;markdown headings 1-4 have their own fonts
    add a, LOW(tb_row_states+1)
    ld l, a
    ld a, HIGH(tb_row_states+1)
    adc a, 0
    ld h, a
    ld a, [hl]
    and a, MD_HEADING
    jr z, .font
    cp a, 5
    jr nc, .font
    add a, FONT_H1-1
    ld e, a
.font
    ld a, [draw_row]
    call RenderRow
    ld a, [draw_row]
    inc a
    cp a, TB_ROWS
    jr c, .loop
  pop af
  SET_BANK
  ld hl, _render_pending
  ld a, [hl]
  cp a, 2
  ret nz
  dec [hl];drawn, the scroll starts once the rows are transferred
  ret

;returns x of character a in [_tb_found_row] of tile_buffer in a, from its styled widths
;a = tile_buffer row, returns carry if it's text scanned by TBScanRow (its widths and styles are in
;tile_attrs), not the on screen keyboard, bars, browser or help, only affects a
RenderLineStyled:
  push hl
  ld hl, _tb_rows
  cp a, [hl]
  pop hl
  ret nc
  ld a, [_render_text]
  add a, $FF
  ret

_RenderCursorX::
RenderCursorX::
  ld c, a;column
  ld a, [_tb_found_row]
  call RenderRowAddress
  ld de, tile_attrs
  add hl, de
  ld b, 0;x
  ld a, c
  and a
  jr z, .done
.sum
    ld a, [hli]
    and a, STYLE_WIDTH
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

;LCD interrupt: changes LCDC at render_events (tile data mode and window), and at line 144 applies
;a staged scroll and sets LCDC for the top of the next frame
RenderLCDInterrupt::
  ldh a, [rLYC]
  cp a, SCRN_Y
  jr z, .vblank
  ld a, [render_event_index]
  ld e, a
  inc a
  ld [render_event_index], a
  ld d, 0
  ld hl, render_events
  add hl, de
  add hl, de
  ld a, [hli]
  ld d, a;LY
  ld b, [hl];LCDC bits
.wait;the interrupt is on the line before, change LCDC in its HBlank (or right away if it's late)
    ldh a, [rLY]
    cp a, d
    jr nc, .change
    ldh a, [rSTAT]
    and a, STATF_LCD
    jr nz, .wait
.change
  call .setLCDC
  ld a, [render_event_index]
  ld hl, render_event_count
  cp a, [hl]
  jr nc, .nextVBlank
  ld hl, render_events
  add a, a
  add a, l
  ld l, a
  adc a, h
  sub a, l
  ld h, a
  ld a, [hl]
  dec a
  ldh [rLYC], a
  ret
.nextVBlank
  ld a, SCRN_Y
  ldh [rLYC], a
  ret

.vblank
  ld a, [_render_pending]
  cp a, 1
  jr nz, .animate
  ldh a, [rHDMA5]
  inc a
  jr nz, .animate;a row is still being transferred ($FF on DMG)
  ld a, [_render_pending_scy]
  ld [render_target_scy], a
  ld a, [render_pending_anim]
  and a
  jr nz, .staged
  ld a, [_render_pending_scy]
  ldh [rSCY], a
.staged
  ld a, [render_pending_wy]
  ldh [rWY], a
  ld hl, render_pending_lcdc
  ld de, render_top_lcdc
  ld b, 2+RENDER_EVENTS*2;top LCDC, count, events
.copyEvents
    ld a, [hli]
    ld [de], a
    inc de
    dec b
    jr nz, .copyEvents
  xor a
  ld [_render_pending], a
  ld [render_pending_anim], a
.animate;GBC: SCY moves SCROLL_STEP pixels toward render_target_scy
  ld a, [render_target_scy]
  ld b, a
  ldh a, [rSCY]
  ld c, a
  ld a, b
  sub a, c
  jr z, .frameStart
  bit 7, a
  jr nz, .back
  cp a, SCROLL_STEP+1
  jr c, .arrive
  ld a, c
  add a, SCROLL_STEP
  jr .setSCY
.back
  cp a, LOW(-SCROLL_STEP)
  jr nc, .arrive
  ld a, c
  sub a, SCROLL_STEP
  jr .setSCY
.arrive
  ld a, b
.setSCY
  ldh [rSCY], a
.frameStart
  ld a, [render_top_lcdc]
  ld b, a
  call .setLCDC
  xor a
  ld [render_event_index], a
  ld a, [render_event_count]
  and a
  jr z, .nextVBlank
  ld a, [render_events]
  dec a
  ldh [rLYC], a
  ret

.setLCDC;b = LCDCF_BG8000 and LCDCF_WINON bits
  ldh a, [rLCDC]
  and a, ~(LCDCF_BG8000 | LCDCF_WINON)
  or a, b
  ldh [rLCDC], a
  ret

;stages LCDC for render_row_blocks, applied with SCY at line 144: tile data mode switches (blocks
;0-5 need $8000 mode, 9-14 $8800, the rest work in either, so switches go in the middle of them),
;and the window, which shows the rows above and below the text rows (file name bar, on screen
;keyboard, status bar). The window is turned off after the top bar and back on for the bottom rows,
;where it carries on from its next line (window map row 1). Without the top bar WY is the first
;bottom row, the window only starts where LY reaches WY while it's on
_RenderStage::
  ld a, [_render_text_top]
  and a
  ld a, 0
  jr nz, .setWY
  ld a, [_tb_rows]
  add a, a
  add a, a
  add a, a
.setWY
  ld [render_pending_wy], a
  ld hl, _render_row_blocks
  ld c, TB_ROWS
.findTopMode;of the first block that needs one
    ld a, [hli]
    call RenderBlockMode
    cp a, $FF
    jr nz, .topMode
    dec c
    jr nz, .findTopMode
  ld a, LCDCF_BG8000
.topMode
  ld [stage_mode], a
  ld a, $FF
  ld [stage_shared], a
  xor a
  ld [render_pending_count], a
  call RenderRowWindow
  ld [stage_win], a
  ld hl, stage_mode
  or a, [hl]
  ld [render_pending_lcdc], a
  ld c, 0;row
.row
    ld a, c
    call RenderRowWindow
    ld hl, stage_win
    cp a, [hl]
    jr z, .block
    ld [hl], a
    ld a, c
    add a, a
    add a, a
    add a, a
    call StageEvent
.block
    ld hl, _render_row_blocks
    ld b, 0
    add hl, bc
    ld a, [hl]
    call RenderBlockMode
    cp a, $FF
    jr nz, .needsMode
    ld a, [stage_shared]
    cp a, $FF
    jr nz, .next
    ld a, c
    ld [stage_shared], a
    jr .next
.needsMode
    ld hl, stage_mode
    cp a, [hl]
    jr z, .sameMode
    ld [hl], a
    ld a, [stage_shared]
    cp a, $FF
    ld a, c
    jr z, .switchLY;no shared rows before it, switch at the row
    ld a, [stage_shared]
    add a, c
    dec a
    srl a;middle of the shared rows
.switchLY
    add a, a
    add a, a
    add a, a
    call StageEvent
.sameMode
    ld a, $FF
    ld [stage_shared], a
.next
    inc c
    ld a, c
    cp a, TB_ROWS
    jr c, .row
  ld a, [_render_gbc]
  and a
  ld a, 1
  jr z, .setPending
  ld a, [_render_pending_scy]
  ld hl, render_target_scy
  sub a, [hl]
  cp a, 8
  jr z, .animate
  cp a, LOW(-8)
  jr z, .animate
  xor a
  ld [render_pending_anim], a
  inc a
  jr .setPending
.animate;one row: EditorDraw draws the new row into the ring's spare block, then it scrolls in
  ld a, 1
  ld [render_pending_anim], a
  inc a
.setPending
  ld [_render_pending], a
  ret

;a = block, returns LCDCF_BG8000 or 0 for the tile data mode it needs, $FF if either works, affects e
RenderBlockMode:
  ld e, a
  ld a, [_render_gbc]
  and a
  ld a, e
  jr z, .dmg
  xor a;GBC blocks are all $8800 tiles
  ret
.dmg
  cp a, 6
  jr c, .mode8000
  cp a, 9
  jr c, .either
  cp a, 15
  jr c, .mode8800
.either
  ld a, $FF
  ret
.mode8000
  ld a, LCDCF_BG8000
  ret
.mode8800
  xor a
  ret

;a = screen row, returns LCDCF_WINON if the window shows it (it isn't a text row), 0 if not, affects b, hl
RenderRowWindow:
  ld hl, _render_text_top
  sub a, [hl]
  jr c, .window
  ld b, a
  ld a, [_tb_rows]
  dec a
  cp a, b
  jr c, .window
  xor a
  ret
.window
  ld a, LCDCF_WINON
  ret

;a = LY, stages a change to stage_mode and stage_win there, merged into the last one if it's at the same
;LY or later (a mode switch in shared rows can move down to a window change), keeps bc
StageEvent:
  ld d, a
  ld a, [stage_win]
  ld hl, stage_mode
  or a, [hl]
  ld e, a;LCDC bits
  ld a, [render_pending_count]
  and a
  jr z, .add
  dec a
  add a, a
  ld hl, render_pending_events
  add a, l
  ld l, a
  adc a, h
  sub a, l
  ld h, a
  ld a, [hli];last LY
  cp a, d
  jr c, .add
  ld [hl], e
  ret
.add
  ld a, [render_pending_count]
  cp a, RENDER_EVENTS
  ret nc
  inc a
  ld [render_pending_count], a
  dec a
  add a, a
  ld hl, render_pending_events
  add a, l
  ld l, a
  adc a, h
  sub a, l
  ld h, a
  ld [hl], d
  inc hl
  ld [hl], e
  ret

_RenderSetMapRow::;a = BG map row, e = block
  ld hl, block_map_rows
  ld d, 0
  add hl, de
  ld [hl], a
  ld hl, block_accents;the new map row's attributes have no accent palettes, draw it again
  add hl, de
  ld b, [hl]
  ld [hl], d
  inc b
  dec b
  jr z, .mapRow
  ld hl, row_font
  add hl, de
  ld [hl], $FF
.mapRow
  push af
  push de
  call RenderWaitDMA;VBK stays put while a row is transferred
  xor a
  ldh [rVBK], a;the last row may have gone to bank 1
  ld d, 0
  ld hl, BlockTileIndex
  ld a, [_render_gbc]
  and a
  jr z, .tileIndex
  ld hl, BlockTileIndexGBC
.tileIndex
  add hl, de
  ld a, [hl]
  ld hl, render_map_row
  ld b, TB_COLS
.index
    ld [hli], a
    inc a
    dec b
    jr nz, .index
  pop bc;block in c
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
  push de
  push bc
  ld hl, render_map_row
  ld bc, TB_COLS
  call mem_CopyVRAM
  pop bc
  pop de
  ld a, [_render_gbc]
  and a
  ret z
  ld a, c;GBC attributes: tiles from VRAM bank 1 for blocks 12 and up
  cp a, GBC_BANK1_BLOCK
  ld a, 0
  jr c, .attributes
  ld a, %00001000
.attributes
  ld hl, render_map_row
  ld b, TB_COLS
.attribute
    ld [hli], a
    dec b
    jr nz, .attribute
  ld a, 1
  ldh [rVBK], a
  ld hl, render_map_row
  ld bc, TB_COLS
  call mem_CopyVRAM
  xor a
  ldh [rVBK], a
  ret

;waits for a row's HDMA transfer to finish (HDMA5 reads $FF when it's idle, and on DMG)
RenderWaitDMA:
  ldh a, [rHDMA5]
  inc a
  jr nz, RenderWaitDMA
  ret

;display should be off, clears tiles, sets the background map, starts the LCD interrupt
RenderSetup::
  ldh a, [sys_info]
  and a, SYS_INFO_GBC
  jr z, .setGBC
  ld a, 1
.setGBC
  ld [_render_gbc], a
  ld b, a
  ldh a, [sys_info]
  and a, SYS_INFO_SGB
  or a, b
  jr z, .setHighlight
  ld a, 1
.setHighlight
  ld [render_highlight], a
  ld a, $FF
  ld hl, block_map_rows
  ld bc, RENDER_BLOCKS
  call mem_Set
  xor a
  ld hl, block_accents
  ld bc, RENDER_BLOCKS
  call mem_Set
  xor a
  ld hl, _VRAM8000
  ld bc, $1800
  call mem_SetVRAM
  ld a, [_render_gbc]
  and a
  jr z, .mapRows
  ld a, 1;VRAM bank 1: tiles and map attributes
  ldh [rVBK], a
  xor a
  ld hl, _VRAM8000
  ld bc, $2000
  call mem_SetVRAM
  xor a
  ldh [rVBK], a
.mapRows;screen row r shows block r
  xor a
.mapRow
    push af
    ld e, a
    call _RenderSetMapRow
    pop af
    inc a
    cp a, TB_ROWS
    jr c, .mapRow
  call _EditorRedraw
  HIDE_WIN
  ld a, $FF
  ld [_render_box_top], a
  xor a
  ld [_render_pending], a
  ld [render_pending_anim], a
  ld [render_target_scy], a
  ld [render_event_index], a
  ld [render_event_count], a
  ldh [rSCY], a
  ldh [rWY], a
  ld a, 7
  ldh [rWX], a
  ld a, [_render_gbc]
  and a
  ld a, LCDCF_BG8000;DMG: blocks 0-5 on top, until the editor's first Layout
  jr z, .topLCDC
  xor a
.topLCDC
  ld [render_top_lcdc], a
  ld b, a
  ldh a, [rLCDC]
  and a, ~LCDCF_BG8000
  or a, b
  or a, LCDCF_WIN9C00
  ldh [rLCDC], a
  ld a, SCRN_Y
  ldh [rLYC], a
  ld bc, RenderLCDInterrupt
  jp SetLCDInterrupt

;first tile index of each block on GBC
BlockTileIndexGBC:
FOR BLOCK, RENDER_BLOCKS
IF BLOCK < GBC_BANK1_BLOCK
  DB LOW(128 + BLOCK*TB_COLS)
ELSE
  DB LOW(128 + (BLOCK-GBC_BANK1_BLOCK)*TB_COLS)
ENDC
ENDR

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

;the styled fonts (fonts.py): headings 1-4, then the fixed and VWF fonts' bold, italic, bold italic
MACRO FONT_STYLE;\1 = glyphs
  DB BANK(\1)
  DW \1
ENDM
FontStyles:
  FONT_STYLE FontH1Glyphs
  FONT_STYLE FontH2Glyphs
  FONT_STYLE FontH3Glyphs
  FONT_STYLE FontH4Glyphs
  FONT_STYLE FontFixedBoldGlyphs
  FONT_STYLE FontFixedItalicGlyphs
  FONT_STYLE FontFixedBoldItalicGlyphs
  FONT_STYLE FontVWFBoldGlyphs
  FONT_STYLE FontVWFItalicGlyphs
  FONT_STYLE FontVWFBoldItalicGlyphs

;bc = glyph, returns the glyph styled by [render_look] and [render_head] in bc (render_glyph if it
;changed, copied from its styled font)
RenderStyleGlyph:
  ld a, [render_head]
  and a
  jr nz, .font
  ld a, [render_look]
  and a, LOOK_BOLD | LOOK_ITALIC
  ret z
  add a, 4
  ld e, a
  ld a, [render_row_font]
  cp a, FONT_FIXED
  ld a, e
  jr z, .font
  add a, 3;VWF
.font;a = styled font + 1
  dec a
  ld e, a
  add a, a
  add a, e
  add a, LOW(FontStyles)
  ld l, a
  adc a, HIGH(FontStyles)
  sub a, l
  ld h, a
  ld a, [hli];bank
  push af
  ld a, [hli]
  ld e, a
  ld d, [hl]
  ld a, [render_glyphs];the glyph's offset in its font
  ld l, a
  ld a, c
  sub a, l
  ld l, a
  ld a, [render_glyphs+1]
  ld h, a
  ld a, b
  sbc a, h
  ld h, a
  add hl, de
  pop af
  jp RenderFarGlyph

INCLUDE "img/fonts/font_mono.asm"
INCLUDE "img/fonts/font_vwf.asm"
INCLUDE "img/fonts/font_fixed.asm"

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

;a = screen row, e = font, draws the row's characters into its block if they, the font or the
;selection changed
RenderRow:
  ld [render_row], a
  ld c, a
  ld b, 0
  ld a, e
  ld [render_row_font], a
  ld hl, _render_row_blocks
  add hl, bc
  ld a, [hl]
  ld [render_block], a
  ld hl, _render_row_lines
  add hl, bc
  ld a, [hl]
  ld [render_line], a
  call RenderLineStyled
  ld a, 0
  adc a, 0
  ld [render_styled], a
  ld a, [render_line]
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

.checkSelection;a change makes the font check fail
  ld a, [render_row]
  add a, a
  ld c, a
  ld b, 0
  ld hl, _render_sel
  add hl, bc
  ld a, [hli]
  ld [render_sel_first], a
  ld a, [hl]
  ld [render_sel_end], a
  ld a, [render_block]
  add a, a
  ld c, a
  ld hl, block_sel
  add hl, bc
  ld a, [render_sel_first]
  cp a, [hl]
  jr nz, .selectionChanged
  inc hl
  ld a, [render_sel_end]
  cp a, [hl]
  jr z, .checkBox
  dec hl
.selectionChanged
  ld a, [render_sel_first]
  ld [hli], a
  ld a, [render_sel_end]
  ld [hl], a
  ld a, [render_block]
  ld c, a
  ld hl, row_font
  add hl, bc
  ld [hl], $FF

.checkBox;a change makes the font check fail
  push de
  call RenderBoxSig
  ld d, a
  ld a, [render_block]
  ld c, a
  ld b, 0
  ld hl, block_box
  add hl, bc
  ld a, d
  cp a, [hl]
  ld [hl], a
  pop de
  jr z, .checkState
  ld hl, row_font
  add hl, bc
  ld [hl], $FF

.checkState;the lexer state at the row's start, a change makes the font check fail
  push de
  ld bc, 0
  ld a, [render_styled]
  and a
  jr z, .compareState
  ld a, [render_line]
  add a, a
  add a, LOW(tb_row_states)
  ld l, a
  ld a, HIGH(tb_row_states)
  adc a, 0
  ld h, a
  ld a, [hli]
  ld c, a
  ld b, [hl]
.compareState
  ld a, [render_block]
  add a, a
  ld e, a
  ld d, 0
  ld hl, block_states
  add hl, de
  ld a, [hl]
  cp a, c
  jr nz, .stateChanged
  inc hl
  ld a, [hl]
  cp a, b
  jr z, .stateSame
  dec hl
.stateChanged
  ld a, c
  ld [hli], a
  ld [hl], b
  ld a, [render_block]
  ld e, a
  ld hl, row_font
  add hl, de
  ld [hl], $FF
.stateSame
  pop de

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
  xor a
  ld [render_inked], a
  ld hl, render_pals
  ld bc, TB_COLS
  call mem_Set

  ld hl, FontMonoGlyphs
  ld de, FontMonoWidths
  ld a, [render_row_font]
  and a
  jr z, .setFont
  ld hl, FontVWFGlyphs
  ld de, FontVWFWidths
  dec a
  jr z, .setFont
  ld hl, FontFixedGlyphs
  ld de, FontFixedWidths
  dec a
  jr z, .setFont
  ld [render_head], a;headings: the fixed font's glyphs, their own fonts are styled fonts
  jr .setGlyphs
.setFont
  xor a
  ld [render_head], a
.setGlyphs
  ld a, l
  ld [render_glyphs], a
  ld a, h
  ld [render_glyphs+1], a
  ld a, e
  ld [render_widths], a
  ld a, d
  ld [render_widths+1], a
  call RenderSelectionMask

  ld a, [render_row_font]
  and a
  jr z, .startX;the on screen keyboard's keys line up with its highlight
  ld a, 1;glyphs end with their gap, so the cursor (at x) sits in the gap before a character
.startX
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
    ld de, tile_attrs - tile_buffer - 1
    add hl, de
    ld a, [hl]
    ld [render_attr], a
    swap a
    and a, $0F
    add a, LOW(StyleLooks)
    ld l, a
    ld a, HIGH(StyleLooks)
    adc a, 0
    ld h, a
    ld a, [hl]
    ld [render_look], a
    ld a, c
    push bc
    call RenderGlyph
    pop bc
    dec b
    jr nz, .char

.toVRAM
  call RenderBox
  call RenderWaitDMA;GBC: the last row's transfer reads render_dma_buffer
  call RenderEncode
  ld a, [_render_gbc]
  and a
  jp nz, RenderRowDMA
  ld a, [render_block]
  add a, a
  ld c, a
  ld b, 0
  ld hl, BlockTileAddress
  add hl, bc
  ld a, [hli]
  ld e, a
  ld d, [hl]
  ld hl, render_dma_buffer
  ld c, TB_WIDTH*2/RENDER_BURST
.burst
    ldh a, [rLY]
    cp a, SCRN_Y
    jr c, .waitForHBlank
    cp a, SCRN_Y+8
    jr c, .write;VBlank with time left
  .waitForHBlank;start of mode 0, then mode 0 and 2 last at least ~260 dots with one sprite on the line
      ldh a, [rSTAT]
      and a, STATF_BUSY
      jr z, .waitForHBlank
  .waitForNotBusy
      ldh a, [rSTAT]
      and a, STATF_BUSY
      jr nz, .waitForNotBusy
  .write
    di
REPT RENDER_BURST;40 cycles, tiles are 16 byte aligned so a burst never crosses a page
    ld a, [hli]
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

;GBC: writes the row's palettes, starts an HBlank DMA of render_dma_buffer to the block, which runs
;while the CPU carries on (VBK stays on the block's bank until it's done, see RenderWaitDMA)
RenderRowDMA:
  call RenderWritePalettes
  ld a, [render_block]
  ld e, a
  cp a, GBC_BANK1_BLOCK
  ld a, 0
  jr c, .bank
  inc a
.bank
  ldh [rVBK], a
  ld d, 0
  ld hl, BlockTileAddressGBC
  add hl, de
  add hl, de
  ld a, HIGH(render_dma_buffer)
  ldh [rHDMA1], a
  ld a, LOW(render_dma_buffer)
  ldh [rHDMA2], a
  ld a, [hli]
  ld e, a
  ld a, [hl]
  ldh [rHDMA3], a
  ld a, e
  ldh [rHDMA4], a
  ld a, $80 | (TB_WIDTH*2/16-1);HBlank DMA, 16 bytes per HBlank
  ldh [rHDMA5], a
  ret

;VRAM address of the first tile of each block on GBC (blocks 12 and up are in bank 1)
BlockTileAddressGBC:
FOR BLOCK, RENDER_BLOCKS
IF BLOCK < GBC_BANK1_BLOCK
  DW _VRAM8000 + (128 + BLOCK*TB_COLS)*16
ELSE
  DW _VRAM8000 + (128 + (BLOCK-GBC_BANK1_BLOCK)*TB_COLS)*16
ENDC
ENDR

;sets render_mask to the pixels from column [render_sel_first] to [render_sel_end]
RenderSelectionMask:
  ld a, [render_sel_first]
  ld hl, render_sel_end
  cp a, [hl]
  jr nz, .selected
  xor a
  ld hl, render_mask
  ld bc, TB_COLS
  jp mem_Set
.selected
  call RenderColumnX
  ld [render_sel_x], a
  ld a, [render_sel_end]
  cp a, $FF
  ld a, TB_WIDTH
  jr z, .setEnd
  ld a, [render_sel_end]
  call RenderColumnX
.setEnd
  ld [render_sel_end_x], a
  ld hl, render_mask
  ;fall through

;hl = 20 bytes, sets the bits of each tile from [render_sel_x] to [render_sel_end_x]
RenderMask:
  ld c, 0;tile's x
.tile
    ld a, [render_sel_x]
    call .clampToTile
    ld e, a;selected pixels start
    ld a, [render_sel_end_x]
    call .clampToTile;and end
    push hl
    ld hl, RenderMaskBits
    ld d, 0
    add hl, de
    ld d, [hl]
    ld hl, RenderMaskBits
    add a, l
    ld l, a
    adc a, h
    sub a, l
    ld h, a
    ld a, [hl]
    xor a, d
    pop hl
    ld [hli], a
    ld a, c
    add a, 8
    ld c, a
    cp a, TB_WIDTH
    jr c, .tile
  ret
.clampToTile;a = x, returns a - c clamped to 0-8
  sub a, c
  jr nc, .notBefore
  xor a
  ret
.notBefore
  cp a, 8
  ret c
  ld a, 8
  ret

;$FF >> n, so pixels n to m of a tile are RenderMaskBits[n] ^ RenderMaskBits[m]
RenderMaskBits: DB $FF, $7F, $3F, $1F, $0F, $07, $03, $01, $00

;a = column, returns its x in the row at [render_src] (styled widths in text rows), at most TB_WIDTH
RenderColumnX:
  and a
  ret z
  ld c, a
  ld b, 0;x
  LD_HL_VAR render_src
  ld a, [render_styled]
  and a
  jr z, .sum
  ld de, tile_attrs - tile_buffer
  add hl, de
.sumStyled
    ld a, [hli]
    and a, STYLE_WIDTH
    add a, b
    jr c, .clamp
    ld b, a
    dec c
    jr nz, .sumStyled
  jr .done
.sum
    ld a, [hli]
    push hl
    ld e, a
    ld d, 0
    LD_HL_VAR render_widths
    add hl, de
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
  ld a, TB_WIDTH
  ret

;returns the box line on [render_row] + 1 in a, $80 set if it's selected and the box's generation
;in bits 4-6, 0 if the box doesn't cover the row
RenderBoxSig:
  ld a, [_render_box_top]
  ld b, a
  ld a, [render_row]
  sub a, b
  jr c, .none
  ld hl, _render_box_rows
  cp a, [hl]
  jr nc, .none
  ld b, a
  ld a, [_render_box_sel]
  cp a, b
  ld a, b
  jr nz, .notSelected
  or a, $80
.notSelected
  inc a
  ld b, a
  ld a, [_render_box_gen]
  and a, 7
  swap a
  or a, b
  ret
.none
  xor a
  ret

;draws the box over render_bitmap if it covers [render_row]: clears the box, draws the text
;and the border, highlights the selected row (replacing the row's selection)
RenderBox:
  call RenderBoxSig
  and a
  ret z
  ld b, a
  and a, $0F
  dec a
  ld [render_box_line], a
  xor a
  bit 7, b
  push af;z = not selected
  ld hl, render_mask
  ld bc, TB_COLS
  call mem_Set

  ld bc, $0008;all 8 lines
  ld a, [render_box_line]
  and a
  jr nz, .notFirst
  ld bc, $0404;lower half
.notFirst
  inc a
  ld hl, _render_box_rows
  cp a, [hl]
  jr nz, .setLines
  ld bc, $0004;upper half
.setLines
  ld a, b
  ld [render_box_y], a
  ld a, c
  ld [render_box_h], a

  ld a, [_render_box_x]
  ld [render_sel_x], a
  ld b, a
  ld a, [_render_box_w]
  add a, b
  ld [render_sel_end_x], a
  ld hl, render_box_mask
  call RenderMask
  ld h, HIGH(render_bitmap)
  call .clear
  ld a, [render_inked]
  bit 0, a
  ld h, HIGH(render_dim)
  call nz, .clear
  ld a, [render_inked]
  bit 1, a
  ld h, HIGH(render_accent)
  call nz, .clear
  jr .cleared
.clear;h = plane's page, clears the box's pixels
  ld a, [render_box_y]
  ld l, a
  ld de, render_box_mask
  ld c, TB_COLS
.clearTile
    ld a, [de]
    inc de
    cpl
    push de
    push hl
    ld d, a
    ld a, [render_box_h]
    ld b, a
  .clearLine
      ld a, [hl]
      and a, d
      ld [hli], a
      dec b
      jr nz, .clearLine
    pop hl
    ld a, l
    add a, 8
    ld l, a
    pop de
    dec c
    jr nz, .clearTile
  ret
.cleared
  ld a, [render_box_h]
  cp a, 8
  jr nz, .border;half rows don't have text

.text
  ld a, [render_box_line]
  dec a;text line
  add a, a
  add a, a
  ld c, a;*4
  add a, a
  add a, a
  add a, c;*20
  ld e, a
  ld d, 0
  LD_HL_VAR _render_box_text
  add hl, de
  ST_HL_VAR render_src
  ld hl, FontVWFGlyphs
  ST_HL_VAR render_glyphs
  ld hl, FontVWFWidths
  ST_HL_VAR render_widths
  xor a
  ld [render_styled], a
  ld [render_head], a
  ld a, [_render_box_x]
  add a, 4
  ld [render_x], a
  ld a, BOX_STRIDE
  ld [render_box_count], a
.char
    LD_HL_VAR render_src
    ld a, [hli]
    and a
    jr z, .border
    ld c, a
    ST_HL_VAR render_src
    ld a, c
    call RenderGlyph
    ld hl, render_box_count
    dec [hl]
    jr nz, .char

.border;sides, the top on the first line, the bottom on the last
  ld a, [_render_box_x]
  call .column
  ld a, [_render_box_x]
  ld b, a
  ld a, [_render_box_w]
  add a, b
  dec a
  call .column
  ld a, [render_box_line]
  and a
  ld e, 4
  call z, .across
  ld a, [render_box_line]
  inc a
  ld hl, _render_box_rows
  cp a, [hl]
  ld e, 3
  call z, .across

  pop af
  ret z
  ld a, [_render_box_x]
  inc a
  ld [render_sel_x], a
  ld b, a
  ld a, [_render_box_w]
  add a, b
  sub a, 2
  ld [render_sel_end_x], a
  ld hl, render_mask
  jp RenderMask

.column;a = x, sets that pixel on the lines the box covers
  ld b, a
  and a, %11111000
  ld hl, render_box_y
  add a, [hl]
  ld l, a
  ld h, HIGH(render_bitmap)
  ld a, b
  and a, 7
  add a, LOW(RenderMaskBits)
  ld e, a
  adc a, HIGH(RenderMaskBits)
  sub a, e
  ld d, a
  ld a, [de]
  inc de
  ld b, a
  ld a, [de]
  xor a, b;just the pixel
  ld b, a
  ld a, [render_box_h]
  ld c, a
.columnLine
    ld a, [hl]
    or a, b
    ld [hli], a
    dec c
    jr nz, .columnLine
  ret

.across;e = line, sets the box's pixels on it
  ld hl, render_bitmap
  ld d, 0
  add hl, de
  ld de, render_box_mask
  ld c, TB_COLS
.acrossTile
    ld a, [de]
    inc de
    or a, [hl]
    ld [hl], a
    ld a, l
    add a, 8
    ld l, a
    dec c
    jr nz, .acrossTile
  ret

;a = character, ORs its glyph into render_bitmap at [render_x] and advances it, in text rows
;[render_attr] is its style and width
RenderGlyph:
  ld c, a
  ld b, 0
  ld a, [render_styled]
  and a
  jr z, .fontWidth
  ld a, [render_attr]
  and a, STYLE_WIDTH
  jr .setWidth
.fontWidth
  LD_HL_VAR render_widths
  add hl, bc
  ld a, [hl]
.setWidth
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
  ld a, [render_styled]
  and a
  call nz, RenderStyleGlyph
  push bc
  ld d, HIGH(render_bitmap)
  call RenderGlyphPlane
  pop bc
  ld a, [render_styled]
  and a
  jr z, .advance
  ld a, [render_look]
  bit 2, a;LOOK_DIM
  jr z, .accent
  ld a, 1
  ld d, HIGH(render_dim)
  call RenderUsePlane
  call RenderGlyphPlane
  jr .advance
.accent
  bit 3, a;LOOK_ACCENT
  jr z, .advance
  ld a, [_render_gbc]
  and a
  jr z, .advance;the ink on DMG and SGB
  ld a, 2
  ld d, HIGH(render_accent)
  call RenderUsePlane
  call RenderGlyphPlane
  call RenderSetPalettes
.advance
  ld a, [render_x]
  ld b, a
  ld a, [render_w]
  add a, b
  ld [render_x], a
  ret

;bc = glyph, d = plane's page, ORs the glyph into the plane at [render_x], affects a, bc, e, hl
RenderGlyphPlane:
  ld a, [render_x]
  and a, %11111000;tile * 8, planes start a page
  ld e, a
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
  ret
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
  ret

;a = render_inked bit, d = the plane's page, clears the plane the first time a row uses it,
;preserves bc, d
RenderUsePlane:
  ld hl, render_inked
  ld e, a
  and a, [hl]
  ret nz
  ld a, e
  or a, [hl]
  ld [hl], a
  ld h, d
  ld l, 0
  xor a
  ld e, TB_WIDTH
.clear
    ld [hli], a
    dec e
    jr nz, .clear
  ret

;GBC: tiles the char at [render_x] covers use its accent's palette
RenderSetPalettes:
  ld a, [render_w]
  and a
  ret z
  ld b, a
  ld a, [render_x]
  ld c, a
  add a, b
  dec a
  cp a, TB_WIDTH
  jr c, .lastTile
  ld a, TB_WIDTH-1
.lastTile
  rrca
  rrca
  rrca
  and a, %00011111
  ld e, a
  ld a, c
  rrca
  rrca
  rrca
  and a, %00011111
  ld d, a
  add a, LOW(render_pals)
  ld l, a
  ld h, HIGH(render_pals)
  ld a, [render_look]
  swap a
  and a, %00000111
  ld b, a
.set
    ld [hl], b
    ld a, d
    cp a, e
    ret nc
    inc d
    inc l
    jr .set

;makes the row's 2bpp tiles in render_dma_buffer from render_bitmap (ink), render_dim, render_accent
;and render_mask (selected pixels), see the top of this file
RenderEncode:
  ld a, [render_inked]
  and a
  jr z, .plain
  ld a, 1;the general case reads both planes
  ld d, HIGH(render_dim)
  call RenderUsePlane
  ld a, 2
  ld d, HIGH(render_accent)
  call RenderUsePlane
  ld de, render_dma_buffer
  ld l, 0
.tile
    call .mask
    and a
    jr z, .clear
    ld a, [render_highlight]
    and a
    jr nz, .selected
  .inverted;DMG: bitplane 0 = (ink & ~dim) ^ mask, bitplane 1 = ink ^ mask
      ld h, HIGH(render_bitmap)
      ld a, [hl]
      ld c, a
      inc h
      ld a, [hl]
      cpl
      and a, c
      xor a, b
      ld [de], a
      inc de
      ld a, c
      xor a, b
      ld [de], a
      inc de
      inc l
      ld a, l
      and a, 7
      jr nz, .inverted
    jr .next
  .selected;bitplane 0 = (ink & ~dim) | (mask & ~ink), bitplane 1 = ink (accent ink is ink)
      ld h, HIGH(render_bitmap)
      ld a, [hl]
      ld c, a
      inc h
      ld a, [hl]
      cpl
      and a, c
      ld h, a
      ld a, c
      cpl
      and a, b
      or a, h
      ld [de], a
      inc de
      ld a, c
      ld [de], a
      inc de
      inc l
      ld a, l
      and a, 7
      jr nz, .selected
    jr .next
  .clear;bitplane 0 = ink & ~dim, bitplane 1 = ink & ~accent
      ld h, HIGH(render_bitmap)
      ld a, [hl]
      ld c, a
      inc h
      ld a, [hl]
      cpl
      and a, c
      ld [de], a
      inc de
      ld h, HIGH(render_accent)
      ld a, [hl]
      cpl
      and a, c
      ld [de], a
      inc de
      inc l
      ld a, l
      and a, 7
      jr nz, .clear
  .next
    ld a, l
    cp a, TB_WIDTH
    jr c, .tile
  ret

.plain;only ink, both bitplanes start as the ink
  ld de, render_dma_buffer
  ld l, 0
.plainTile
    call .mask
    ld h, HIGH(render_bitmap)
    and a
    jr z, .plainClear
    ld a, [render_highlight]
    and a
    jr nz, .plainSelected
  .plainInverted
      ld a, [hli]
      xor a, b
      ld [de], a
      inc de
      ld [de], a
      inc de
      ld a, l
      and a, 7
      jr nz, .plainInverted
    jr .plainNext
  .plainSelected
      ld a, [hli]
      ld c, a
      or a, b
      ld [de], a
      inc de
      ld a, c
      ld [de], a
      inc de
      ld a, l
      and a, 7
      jr nz, .plainSelected
    jr .plainNext
  .plainClear
      ld a, [hli]
      ld [de], a
      inc de
      ld [de], a
      inc de
      ld a, l
      and a, 7
      jr nz, .plainClear
  .plainNext
    ld a, l
    cp a, TB_WIDTH
    jr c, .plainTile
  ret

.mask;l = byte in render_bitmap, returns the tile's mask in a and b, affects h
  ld a, l
  rrca
  rrca
  rrca
  and a, %00011111
  add a, LOW(render_mask)
  push hl
  ld l, a
  ld h, HIGH(render_mask)
  ld a, [hl]
  pop hl
  ld b, a
  ret

;GBC: writes the palette of each of the row's tiles (its accent's, 0 if it has selected pixels) to
;its map row's attributes, if it or the block's last row used accents
RenderWritePalettes:
  ld a, [render_block]
  ld c, a
  ld b, 0
  ld hl, block_accents
  add hl, bc
  ld a, [render_inked]
  and a, 2
  ld d, a
  or a, [hl]
  ld [hl], d
  ret z
  ld hl, block_map_rows
  add hl, bc
  ld a, [hl]
  cp a, $FF
  ret z
  push af
  ld a, c
  cp a, GBC_BANK1_BLOCK
  ld e, 0
  jr c, .bank
  ld e, %00001000
.bank
  ld bc, render_mask
  ld hl, render_map_row
  ld d, TB_COLS
.attribute
    ld a, [bc]
    and a
    ld a, e
    jr nz, .setAttribute
    push hl
    ld a, c
    add a, render_pals - render_mask
    ld l, a
    ld h, b
    ld a, [hl]
    or a, e
    pop hl
  .setAttribute
    ld [hli], a
    inc c
    dec d
    jr nz, .attribute
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
  ld a, 1
  ldh [rVBK], a
  ld hl, render_map_row
  ld bc, TB_COLS
  call mem_CopyVRAM
  xor a
  ldh [rVBK], a
  ret

;the styled fonts, each in its own bank's section (RenderStyleGlyph)
MACRO STYLED_FONT;\1 = file
SECTION "Styled Font \1", ROMX
INCLUDE "img/fonts/\1.asm"
ENDM
  STYLED_FONT font_h1
  STYLED_FONT font_h2
  STYLED_FONT font_h3
  STYLED_FONT font_h4
  STYLED_FONT font_fixed_bold
  STYLED_FONT font_fixed_italic
  STYLED_FONT font_fixed_bold_italic
  STYLED_FONT font_vwf_bold
  STYLED_FONT font_vwf_italic
  STYLED_FONT font_vwf_bold_italic
