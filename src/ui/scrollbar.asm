;The scroll bar at 160x144 (GB, SGB and GBC) and in the SGB's fullscreen modes: while the mouse pointer shows,
;the text rows' right 4 pixels show its track and a sprite its thumb. The window shows the track: on every
;line then, WX at the track (SCROLL_WX) on the text rows and the screen's left on the bars', so its line
;counter follows the screen and each window map row is its screen row (RenderWindowRows; without the bar
;the window is off over the text and its rows are packed). The text rows' window rows have the track's tile
;in column 0, the rest of them isn't shown.
;A view claims the bar every frame it waits for keys (ScrollBar: its position and how far it scrolls), so
;a menu, a dialog or another screen hides it. A press on the track grabs the thumb, which follows the
;pointer until it's let go (the mouse drivers' reports are the bar's meanwhile: ScrollBarHit), then
;KEY_SCROLL is queued and the view goes there (ScrollTo): one redraw, never one while it's dragged.
;In fullscreen (256x224 and 512x448) the SNES draws it: the fullscreen client sends SCROLLBAR (the track's top
;line, its lines, the thumb's top: scroll_top) and the kernel shows it while its pointer does; the GB's window,
;tiles and sprites are the transport's, and a row is 8 lines (4 in 512x448's text) as the mouse's y has them.
;
;C functions (src/ui/scrollbar.h)
;   ScrollBar                   de = {position, the largest} (unsigned longs): the bar this frame, none for a
;                               largest of 0 (ModScrollBar, ABI 15)
;   ScrollTo                    de = the same: its position where the bar was let go, for KEY_SCROLL (ModScrollTo)
;   scroll_range                a range for the host's views (WRAM0 is full)

DEF SCROLL_PAGE EQU 10;the window's rows (RenderWindowRows), through a thunk
DEF EDITOR_SCROLL_PAGE EQU 9;the editor's claim, through a thunk
DEF EDITOR_SCROLL_TO_PAGE EQU 11
DEF SCROLL_WX EQU 7 + SCRN_X - 4;the window's left at the track: the text rows' right 4 pixels
DEF SCROLL_TRACK_TILE EQU 127;$8000 mode's tile 127 and $8800 mode's 383, the same: free in both on DMG, in GBC's bank 0
DEF SCROLL_THUMB_TILE EQU 123;a sprite tile beside the pointer's (122)
DEF SCROLL_OAM EQU 3*4;its sprite, after the cursor, keyboard highlight and pointer
DEF SCROLL_THUMB_X EQU SCRN_X - 6;the tile's left: its pixels 0-5 drawn, over the track and 2 pixels left of it
DEF SCROLL_THUMB_TOP EQU 0;the thumb's first line in its tile
DEF SCROLL_THUMB_LINES EQU 5
DEF SCROLL_HIT_X EQU SCROLL_THUMB_X;presses from the thumb's left edge rightwards are the bar's
DEF SCROLL_FULL_HIT_X EQU 256 - 6;and fullscreen's (the kernel's thumb, snes/mouse.s)
DEF SCROLL_CLAIM_FRAMES EQU 16;a view's claim lasts this many frames (HEXVIEW's loop takes 2 or 3, a large document's line count a sector)
DEF SCROLL_TRACK_SLOT EQU $FE;a window row's tracking (map_blocks) when it shows the track, not a block
DEF WIN_TRACK EQU 1;render_events: the window at the track (WX), with LCDCF_WINON (RenderLCDInterrupt)
DEF BG_MAP_ROWS EQU 32;then the window's map rows (RenderSetMapRow)
DEF WIN_MAP_ROWS EQU OSK_ROWS + 2;window rows map_blocks tracks (src/ui/screen.h), scroll_win_rows the rest

SECTION "Scroll bar vars", WRAMX;WRAM0 is full
_scroll_range:: DS 8
scroll_win_rows: DS TB_ROWS - WIN_MAP_ROWS;the window rows map_blocks doesn't have: their block or SCROLL_TRACK_SLOT
scroll_shown: DB;1: the window is laid out for the bar (RenderWindowRows, RenderStage)
scroll_able: DB;the view's largest isn't 0
scroll_pos: DB;the thumb's place, 0-255 of the track
scroll_claim: DB;_render_frames' low byte at the view's last claim
scroll_drag: DB;1 while the thumb is held
scroll_grab: DB;where in the thumb it's held (lines from its top)
scroll_drag_at: DB;the held thumb's top, lines from the track's
scroll_target: DB;the fraction (0-255) the thumb was let go at
scroll_top:: DB;the thumb's top line as last placed (fullscreen: the client's SCROLLBAR)
fs_bar_sent:: DS 3;the fullscreen client's SCROLLBAR as last sent: the track's top line, its lines (0: none), the
                  ;thumb's top (not in HRAM: its top is written by something unknown, TODO.md)

SECTION "Scroll bar", ROM0

;C: _WaitFrame, each frame: the bar shown or hidden, its thumb placed, a drag followed and let go
ScrollBarFrame::
  call ScrollWanted
  ld a, [scroll_shown]
  jr nz, .wanted
  and a
  ret z
  call ScrollIdle
  ret nz
  xor a
  ld [scroll_shown], a
  ld [scroll_drag], a
  ld [oam_buffer + SCROLL_OAM], a
  call ScrollFull
  ret nz
  jp _RenderStage;the window over the bars only, its rows packed
.wanted
  and a
  jr nz, .shown
  call ScrollIdle
  ret nz
  ld a, 1
  ld [scroll_shown], a
  call ScrollFull
  jr nz, .shown
  call ScrollTiles
  call _RenderStage;the window on every line, its rows at the screen's
.shown
  call ScrollTrack
  ld a, [scroll_drag]
  and a
  jr z, .thumb
  ld a, [_mouse_buttons]
  rra
  jr nc, .release
  ld a, [scroll_grab];held: its top follows the pointer, within the track
  ld e, a
  ld a, [_mouse_y]
  sub a, e
  jr c, .first
  sub a, b
  jr nc, .inside
.first
  xor a
.inside
  cp a, c
  jr c, .held
  ld a, c
.held
  ld [scroll_drag_at], a
  add a, b
  jr .sprite
.release;the fraction whose thumb is where it was let go (ScrollThumb's inverse, the bottom 255)
  xor a
  ld [scroll_drag], a
  ld a, [scroll_drag_at]
  cp a, c
  ld e, 255
  jr nc, .fraction
  ld h, a
  ld l, c;rounded up: a * 256 / (c + 1)
  ld de, 0
  inc c
  call math_Divide32
  ld e, l
.fraction
  ld a, e
  ld [scroll_pos], a
  ld [scroll_target], a
  ld a, [kb_event_write];KEY_SCROLL queued (dropped if the queue is full)
  ld c, a
  inc a
  and a, KB_EVENT_COUNT-1
  ld hl, kb_event_read
  cp a, [hl]
  jr z, .shown
  ld [kb_event_write], a
  ld l, c
  ld h, 0
  add hl, hl
  ld bc, kb_event_buffer
  add hl, bc
  ld [hl], KEY_SCROLL
  inc hl
  ld [hl], 0;no modifiers (the editor's HandleFileKey checks them)
  jr .shown
.thumb
  call ScrollThumb
.sprite;a = the thumb's top line
  ld [scroll_top], a;(fullscreen: the GB's sprites are off, the client sends it)
  ld hl, oam_buffer + SCROLL_OAM
  add a, OAM_Y_OFS - SCROLL_THUMB_TOP
  ld [hli], a
  ld a, SCROLL_THUMB_X + OAM_X_OFS
  ld [hli], a
  ld a, SCROLL_THUMB_TILE
  ld [hli], a
  ld [hl], 0;object palette 0: the text's colours on GBC, the pointer's
  ret

;nz if the bar shows: a view claimed it lately with somewhere to scroll, the pointer shows (or the thumb is
;held), on the GB's 160x144 screen without a box over it or a module's background; in fullscreen without
;a box, the OSK or a map, the kernel showing it only with its pointer
ScrollWanted:
  call ScrollFull
  jr z, .gb
  ldh a, [fs_map]
  ld hl, _osk_shown
  or a, [hl]
  jr .layout
.gb
  ld a, [_screen_rows]
  cp a, TB_ROWS
  jr nz, .no
  ldh a, [render_background]
.layout
  and a
  jr nz, .no
  ld a, [_render_box_top]
  inc a
  jr nz, .no
  ld a, [scroll_claim]
  ld b, a
  ld a, [_render_frames]
  sub a, b
  cp a, SCROLL_CLAIM_FRAMES
  jr nc, .no
  ld a, [scroll_able]
  and a
  ret z
  ld a, [scroll_drag]
  and a
  ret nz
  call ScrollFull
  ret nz
  ld a, [oam_buffer + 8];the pointer's sprite (src/keyboard/driver_mouse.asm), 0 when it's hidden
  and a
  ret
.no
  xor a
  ret

;nz in the SGB's fullscreen modes, affects a
ScrollFull:
  ldh a, [sys_info]
  and a, SYS_INFO_SGBFS
  ret

;z if no layout is staged and (GBC) the text isn't scrolling: the bar's window changes only then (always
;in fullscreen, which has no window)
ScrollIdle:
  call ScrollFull
  jr z, .gb
  xor a
  ret
.gb
  ld a, [_render_pending]
  and a
  ret nz
  ld a, [render_target_scy]
  ld b, a
  ldh a, [rSCY]
  cp a, b
  ret

;b = the track's top line, c = how far the thumb's top moves (the track's lines less the thumb's), affects a,
;hl (the fullscreen client's too)
ScrollTrack::
  ld a, [_render_text_top]
  call ScrollLines
  ld b, a
  ld a, [_tb_rows]
  call ScrollLines
  sub a, SCROLL_THUMB_LINES
  ld c, a
  ret
ScrollLines:;a = rows: their lines, 8 a row (4 in 512x448's text: MouseRow's)
  add a, a
  add a, a
  ld hl, _screen_cells
  bit 0, [hl]
  ret nz
  add a, a
  ret

;b, c = ScrollTrack's: returns a = the thumb's top line at scroll_pos, keeps bc
ScrollThumb:
  push bc
  ld d, 0
  ld e, c
  inc e
  ld a, [scroll_pos]
  call math_Multiply;(c + 1) * scroll_pos / 256: 255 is the bottom
  pop bc
  ld a, h
  add a, b
  ret

;C, the mouse drivers' (src/keyboard/driver_mouse.asm, at each report): c = the buttons just pressed. Carry
;if the report is the bar's: a press on its track (the thumb is held from there, or from its middle if it's
;elsewhere on the track) or one while it's held. Keeps bc when it isn't
ScrollBarHit::
  ld a, [scroll_drag]
  and a
  jr nz, .bar
  ld a, [scroll_shown]
  and a
  ret z
  bit 0, c
  ret z
  call ScrollFull
  ld a, SCROLL_HIT_X
  jr z, .left
  ld a, SCROLL_FULL_HIT_X
.left
  ld e, a
  ld a, [_mouse_x]
  cp a, e
  ccf
  ret nc
  push bc
  call ScrollTrack
  call ScrollThumb
  sub a, b
  ld d, a;the thumb's top in the track
  ld a, [_mouse_y]
  sub a, b
  jr c, .text;above the track
  ld e, a
  ld a, c
  add a, SCROLL_THUMB_LINES - 1
  cp a, e
  jr c, .text;below it
  ld a, e
  sub a, d
  jr c, .middle
  cp a, SCROLL_THUMB_LINES
  jr c, .grab
.middle
  ld a, SCROLL_THUMB_LINES / 2
.grab
  ld [scroll_grab], a
  ld a, 1
  ld [scroll_drag], a
  pop bc
.bar
  scf
  ret
.text
  pop bc
  and a
  ret

ScrollThumbTile:
  INCBIN "img/ui_font.tiles", 10*16, 16;the font's tile 10 (img/ui_font.png)
ScrollTrackTile:;a 2 pixel line in color 1, between 1 pixel of paper each side
REPT 8
  DB %01100000, 0
ENDR

;the track's tile and the thumb's, each time the bar shows (a module's background, or fullscreen's
;transport, may have had them)
ScrollTiles:
  call RenderWaitDMA
  xor a
  ldh [rVBK], a
  ld hl, ScrollTrackTile
  ld de, _VRAM8000 + SCROLL_TRACK_TILE*16
  ld bc, 16
  call mem_CopyVRAM
  ld hl, ScrollTrackTile
  ld de, _VRAM8000 + (256 + SCROLL_TRACK_TILE)*16
  ld bc, 16
  call mem_CopyVRAM
  ld hl, ScrollThumbTile
  ld de, _VRAM8000 + SCROLL_THUMB_TILE*16
  ld bc, 16
  jp mem_CopyVRAM

;RenderSetup's and ModBackground's: the bar hidden, and the window rows only it uses unknown (the
;window map is cleared, or the module's)
ScrollForget:
  xor a
  ld [scroll_shown], a
  ld [scroll_drag], a
  ld [oam_buffer + SCROLL_OAM], a
  dec a
  ld hl, scroll_win_rows
  ld bc, TB_ROWS - WIN_MAP_ROWS
  jp mem_Set

RenderWindowRows:
  FAR_THUNK RenderWindowRowsPage
_EditorScrollBar::
  FAR_THUNK EditorScrollBarPage

SECTION "Scroll bar ABI", ROM0;resident: a module passes its own BSS (in its page)

;hl = a range: debc = its value there, hl at its last byte
ScrollLoad:
  ld a, [hli]
  ld c, a
  ld a, [hli]
  ld b, a
  ld a, [hli]
  ld e, a
  ld d, [hl]
  ret

_ScrollBar::
_ModuleAPIScrollBar::;de = range
  ld a, [_render_frames]
  ld [scroll_claim], a
  push de
  ld hl, 4
  add hl, de
  call ScrollLoad;the largest
  ld a, d
  or a, e
  or a, b
  or a, c
  ld [scroll_able], a
  pop hl
  ret z
  push hl
  ld l, 0;both to 8 bits: the fraction is the position's * 256 / the largest's
.largest
    ld a, d
    or a, e
    or a, b
    jr z, .position
    srl d
    rr e
    rr b
    rr c
    inc l
    jr .largest
.position
  ld a, l
  pop hl
  push bc;c = the largest's
  push af
  call ScrollLoad
  pop af
.shift
    and a
    jr z, .divide
    srl d
    rr e
    rr b
    rr c
    dec a
    jr .shift
.divide
  ld a, d
  or a, e
  or a, b
  ld h, c
  pop bc
  ld a, 255
  jr nz, .set;past the largest
  ld a, h
  cp a, c
  ld a, 255
  jr nc, .set
  ld l, 0
  ld de, 0
  call math_Divide32
  ld a, l
.set
  ld [scroll_pos], a
  ret

FIXED "Scroll bar ABI 2";resident too (bank 1)

;C: ScrollBarWord(position, largest), de and bc: ScrollBar's for 16 bit ones, in scroll_range
_ScrollBarWord::
  ld hl, _scroll_range
  ld a, e
  ld [hli], a
  ld a, d
  ld [hli], a
  xor a
  ld [hli], a
  ld [hli], a
  ld a, c
  ld [hli], a
  ld a, b
  ld [hli], a
  xor a
  ld [hli], a
  ld [hl], a
  ld de, _scroll_range
  jp _ScrollBar

;C: ScrollToWord(): ScrollTo's for scroll_range, returns bc = its position (16 bits)
_ScrollToWord::
  ld de, _scroll_range
  call _ScrollTo
  ld hl, _scroll_range
  ld a, [hli]
  ld c, a
  ld b, [hl]
  ret

_ScrollTo::
_ModuleAPIScrollTo::;de = range
  push de
  ld hl, 4
  add hl, de
  call ScrollLoad;the largest
  ld a, [scroll_target]
  inc a
  jr z, .store;the bottom: the largest itself
  ld l, 0;to 16 bits, its fraction (the largest * scroll_target / 255), back
.largest
    ld a, d
    or a, e
    jr z, .multiply
    srl d
    rr e
    rr b
    rr c
    inc l
    jr .largest
.multiply
  ld a, l
  push af
  ld d, b
  ld e, c
  ld a, [scroll_target]
  ld hl, 0
  ld c, l
  ld b, 8;chl = de * a
.bit
    add hl, hl
    rl c
    add a, a
    jr nc, .next
    add hl, de
    jr nc, .next
    inc c
.next
    dec b
    jr nz, .bit
  ld d, 0
  ld e, c
  ld c, 255
  call math_Divide32
  pop af
.back
    and a
    jr z, .done
    add hl, hl
    rl e
    rl d
    dec a
    jr .back
.done
  ld b, h
  ld c, l
.store;debc = the position
  pop hl
  ld a, c
  ld [hli], a
  ld a, b
  ld [hli], a
  ld a, e
  ld [hli], a
  ld [hl], d
  ret

PAGE SCROLL_PAGE
;the window map rows of the rows that aren't text (render_row_blocks: the bars, the keyboard): packed from
;window row 0 (the window is off over the text and carries on below it), or with the bar at their screen
;rows, the text rows' rows showing the track in column 0. Rows already showing them are left alone
RenderWindowRowsPage:
  ld bc, 0;b = the next packed window row, c = screen row
.row
    ld a, [_render_text_top]
    ld e, a
    ld a, c
    sub a, e
    ld e, a
    ld a, [_tb_rows]
    dec a
    cp a, e;carry: not a text row
    ld a, [scroll_shown]
    jr c, .bar
    and a
    jr z, .next
    ld a, c
    call WindowSlot
    ld a, [hl]
    cp a, SCROLL_TRACK_SLOT
    jr z, .next
    ld [hl], SCROLL_TRACK_SLOT
    push bc
    call ScrollTrackCell
    pop bc
    jr .next
.bar
    and a
    ld a, c
    jr nz, .window
    ld a, b
    inc b
.window
    ld e, a;window row
    push bc
    ld hl, _render_row_blocks
    ld b, 0
    add hl, bc
    ld c, [hl];block
    ld a, e
    call WindowSlot
    ld a, [hl]
    cp a, c
    jr nz, .set
    push hl
    ld hl, block_map_rows;(a block can still be listed in a row it left)
    add hl, bc
    ld a, e
    add a, BG_MAP_ROWS
    cp a, [hl]
    pop hl
    jr z, .kept
.set
    ld [hl], c
    ld a, e
    add a, BG_MAP_ROWS
    ld e, c
    call _RenderSetMapRow
.kept
    pop bc
.next
    inc c
    ld a, c
    cp a, TB_ROWS
    jr c, .row
  ret

;a = window row: hl = what it shows (map_blocks's or scroll_win_rows's), keeps bc, de
WindowSlot:
  cp a, WIN_MAP_ROWS
  ld hl, _map_blocks + BG_MAP_ROWS
  jr c, .add
  ld hl, scroll_win_rows - WIN_MAP_ROWS
.add
  add a, l
  ld l, a
  ret nc
  inc h
  ret

;c = window row: column 0 shows the track (GBC: in the text's palette)
ScrollTrackCell:
  ld l, c
  ld h, 0
REPT 5
  add hl, hl
ENDR
  ld de, _SCRN1
  add hl, de
  push hl
  call RenderWaitDMA;VBK stays put while a row is transferred
  xor a
  ldh [rVBK], a
  ld a, SCROLL_TRACK_TILE
  ld bc, 1
  call mem_SetVRAM
  pop hl
  ld a, [_render_gbc]
  and a
  ret z
  ld a, 1
  ldh [rVBK], a
  ld a, [_style_looks + STYLE_TEXT]
  and a, LOOK_PALETTE
  swap a
  ld bc, 1
  call mem_SetVRAM
  xor a
  ldh [rVBK], a
  ret
END_PAGE

PAGE EDITOR_SCROLL_PAGE
;C: the editor's scroll bar (Editor, each frame): its top row's place in the document, of the last top that
;fills the screen (the length less the text on screen). A small document all on screen has nothing to scroll
EditorScrollBarPage:
  call _tb_Length
  push bc
  ld a, [_tb_rows]
  add a, a
  add a, LOW(_tb_row_starts)
  ld l, a
  adc a, HIGH(_tb_row_starts)
  sub a, l
  ld h, a
  ld a, [hli]
  ld b, [hl]
  ld hl, _top
  sub a, [hl]
  ld c, a
  inc hl
  ld a, b
  sbc a, [hl]
  ld b, a;bc = the text on screen: its bottom row's end less its top
  pop hl;the length
  ld de, _scroll_range
  ld a, [_doc_large]
  and a
  jr nz, .large
  ld a, l
  sub a, c
  ld c, a
  ld a, h
  sbc a, b
  ld b, a;the largest top
  ld hl, _top
  ld a, [hli]
  ld e, a
  ld d, [hl]
  or a, d
  jp nz, _ScrollBarWord
  ld a, [_tb_end_row]
  inc a
  jp z, _ScrollBarWord
  ld b, a
  ld c, a;all of it on screen
  jp _ScrollBarWord
.large;the window's start and the top, of the document's length less the text on screen (0 if it's all on it)
  ld hl, _win_start
  ld a, [_top]
  add a, [hl]
  ld [de], a
  inc hl
  inc de
  ld a, [_top+1]
  adc a, [hl]
  ld [de], a
  inc hl
  inc de
REPT 2
  ld a, [hli]
  adc a, 0
  ld [de], a
  inc de
ENDR
  ld hl, _doc_len
  ld a, [hli]
  sub a, c
  ld [de], a
  inc de
  ld a, [hli]
  sbc a, b
  ld [de], a
  inc de
  ld a, [hli]
  sbc a, 0
  ld [de], a
  inc de
  ld a, [hl]
  sbc a, 0
  ld [de], a
  jr nc, .claim
  xor a
REPT 3
  ld [de], a
  dec de
ENDR
  ld [de], a
.claim
  ld de, _scroll_range
  jp _ScrollBar

END_PAGE

PAGE EDITOR_SCROLL_TO_PAGE;with src/editor/window.c's EditorScrollTo (window.banks), which calls it
;C: the editor's KEY_SCROLL, after ScrollTo (src/editor/window.c's EditorScrollTo): returns bc = scroll_range's
;position in the text buffer, $FFFE at the bar's bottom (the text's end), or $FFFF if a large document's window
;hasn't got it: doc_pos is then half a window before it, where one around it starts. Affects scroll_range's largest
_EditorScrollPos::
  ld bc, $FFFE
  ld a, [scroll_target]
  inc a
  ret z
  ld hl, _scroll_range
  ld a, [_doc_large]
  and a
  jr nz, .large
  ld a, [hli]
  ld c, a
  ld b, [hl]
  ret
.large;the position less the window's start: in it if that's 0 to the window's length
  ld de, _win_start
  ld a, [hli]
  ld b, a
  ld a, [de]
  ld c, a
  ld a, b
  sub a, c
  ld c, a
  inc de
  ld a, [de]
  ld b, a
  ld a, [hli]
  sbc a, b
  ld b, a
  inc de
  ld a, [de]
  ld [_scroll_range + 4], a
  ld a, [hli]
  push hl
  ld hl, _scroll_range + 4
  sbc a, [hl]
  ld [hl], a
  pop hl
  inc de
  ld a, [de]
  ld [_scroll_range + 5], a
  ld a, [hl]
  ld hl, _scroll_range + 5
  sbc a, [hl]
  jr c, .outside;before the window
  dec hl
  or a, [hl]
  jr nz, .outside
  push bc
  call _tb_Length
  pop hl
  ld a, c
  sub a, l
  ld a, b
  sbc a, h
  ld b, h
  ld c, l
  ret nc
.outside;doc_pos = the position less half a window, 0 if that's before the start
  ld hl, _scroll_range
  ld de, _doc_pos
  ld a, [hli]
  ld [de], a
  inc de
  ld a, [hli]
  sub a, HIGH(WIN_SIZE / 2)
  ld [de], a
  inc de
REPT 2
  ld a, [hli]
  sbc a, 0
  ld [de], a
  inc de
ENDR
  jr nc, .start
  xor a
  ld hl, _doc_pos
  ld [hli], a
  ld [hli], a
  ld [hli], a
  ld [hl], a
.start
  ld bc, $FFFF
  ret
ASSERT LOW(WIN_SIZE / 2) == 0
END_PAGE
