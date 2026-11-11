;On screen keyboard, drawn into OSK_ROWS rows of tile_buffer below the text (the editor draws
;them with FONT_MONO).
;Keys are 1 tile wide with a 1 tile gap, OSK_COLS keys per row. The last row is
;shift, symbols, menu, space (4 keys), undo, redo, return for every layer.
;
;C functions (src/editor/osk.h)
;   OSKShow                     a = show, the highlight goes back on [_osk_x], [_osk_y]
;   OSKDraw                     a = layer (OSK_CAPS shows ⇪ on shift), e = first tile_buffer row
;   OSKSelect                   a = x, e = y, moves the highlight sprite
;   OSKGetKey                   a = layer, e = key index, returns char in a (0 = no key)

DEF OSK_SPRITE       EQU 1
DEF OSK_SPRITE_TILE  EQU 1
DEF OSK_LAYOUT_SIZE  EQU OSK_COLS*(OSK_ROWS-1)

SECTION "On Screen Keyboard Vars", WRAM0
osk_first_row: DB;tile_buffer row, the screen row is [_render_text_top] rows lower

SECTION "On Screen Keyboard", ROM0

OSKLayouts:
.lower   DB "1234567890qwertyuiopasdfghjkl;zxcvbnm,./"
.shift   DB "!@#$%^&*()QWERTYUIOPASDFGHJKL:ZXCVBNM<>?"
.symbols DB "`~-_=+[]\{\}\\|'\"¡¿áéíóúñü",0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
OSKBottomRow: DB "▲ # ≡ ________↶ ↷ ↵ "
ASSERT @ - OSKBottomRow == SCRN_X_B

_OSKShow::;a = show, hides or shows the highlight
  and a
  jr z, .hide
  ld a, [_osk_y]
  ld e, a
  ld a, [_osk_x]
  jp _OSKSelect
.hide
  ld de, 0
  ld c, OSK_SPRITE
  jp gbdk_MoveSprite

;a = layer, returns layout in hl, affects a, bc
OSKGetLayout:
  cp a, OSK_CAPS
  jr nz, .layer
  ld a, OSK_SHIFT;caps lock types the shift layout
.layer
  ld hl, OSKLayouts
  ld bc, OSK_LAYOUT_SIZE
  and a
  ret z
.loop
    add hl, bc
    dec a
    jr nz, .loop
  ret

_OSKDraw::;a = layer, e = first tile_buffer row
  push af
  ld a, e
  ld [osk_first_row], a
  call RenderRowAddress
  ld de, tile_buffer
  add hl, de
  push hl;first row
  ld a, ' '
  ld bc, OSK_ROWS*TB_STRIDE
  call mem_Set
  pop de;first row
  pop af
  push af;layer, for the shift key's caps lock glyph
  call OSKGetLayout
  ld c, OSK_ROWS-1
.row
    ld b, OSK_COLS
  .key
      ld a, [hli]
      and a
      jr nz, .setKey
      ld a, ' '
    .setKey
      ld [de], a
      inc de
      inc de;gap
      dec b
      jr nz, .key
    ld a, e
    add a, TB_STRIDE-OSK_COLS*2
    ld e, a
    ld a, d
    adc a, 0
    ld d, a
    dec c
    jr nz, .row
  ld hl, OSKBottomRow
  ld bc, SCRN_X_B
  push de;the shift key
  call mem_Copy
  pop hl
  pop af
  cp a, OSK_CAPS
  ret nz
  ld [hl], "⇪"
  ret

_OSKSelect::;a = x, e = y
  swap a;x*16
  add a, OAM_X_OFS+OSK_INSET
  ld d, a
  ld a, [osk_first_row]
  add a, e
  ld hl, _render_text_top
  add a, [hl]
  add a, a
  add a, a
  add a, a
  add a, OAM_Y_OFS
  ld e, a
  ld c, OSK_SPRITE
  jp gbdk_MoveSprite

_OSKGetKey::;a = layer, e = key index, returns char in a
  call OSKGetLayout
  ld d, 0
  add hl, de
  ld a, [hl]
  ret

;sets up highlight sprite, display should be off
OSKSetup:
  ld hl, _VRAM8000+OSK_SPRITE_TILE*16
  ld b, 8
.loop;solid tile using color 1, drawn behind the key
    ld a, $FF
    ld [hli], a
    xor a
    ld [hli], a
    dec b
    jr nz, .loop
  ld c, OSK_SPRITE
  ld d, OSK_SPRITE_TILE
  call gbdk_SetSpriteTile
  ld c, OSK_SPRITE
  ld d, OAMF_PRI
  jp gbdk_SetSpriteProp
