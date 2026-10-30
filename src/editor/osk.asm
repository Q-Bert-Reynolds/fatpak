;On screen keyboard, drawn on the window below the text.
;Keys are 1 tile wide with a 1 tile gap, OSK_COLS keys per row. The last row is
;shift, symbols, space, cursor left, cursor right for every layer.
;
;C functions (src/editor/editor.h)
;   OSKShow                     a = show
;   OSKDraw                     a = layer
;   OSKSelect                   a = x, e = y, moves the highlight sprite
;   OSKGetKey                   a = layer, e = key index, returns char in a (0 = no key)

DEF OSK_SPRITE       EQU 1
DEF OSK_SPRITE_TILE  EQU 1
DEF OSK_LAYOUT_SIZE  EQU OSK_COLS*(OSK_ROWS-1)
DEF OSK_Y            EQU SCRN_Y-OSK_ROWS*8

SECTION "On Screen Keyboard", ROM0

OSKLayouts:
.lower   DB "1234567890qwertyuiopasdfghjkl;zxcvbnm,./"
.shift   DB "!@#$%^&*()QWERTYUIOPASDFGHJKL:ZXCVBNM<>?"
.symbols DB "`~-_=+[]\{\}\\|'\"¡¿áéíóúñü",0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
OSKBottomRow: DB "▲ # ____________◀ ▶ "

_OSKShow::;a = show
  and a
  jr z, .hide
  ld a, WX_OFS
  ldh [rWX], a
  ld a, OSK_Y
  ldh [rWY], a
  SHOW_WIN
  ret
.hide
  HIDE_WIN
  ld de, 0
  ld c, OSK_SPRITE
  jp gbdk_MoveSprite

;a = layer, returns layout in hl, affects a, bc
OSKGetLayout:
  ld hl, OSKLayouts
  ld bc, OSK_LAYOUT_SIZE
  and a
  ret z
.loop
    add hl, bc
    dec a
    jr nz, .loop
  ret

_OSKDraw::;a = layer
  call OSKGetLayout
  ld de, win_buffer
  ld b, OSK_LAYOUT_SIZE
.loop
    ld a, [hli]
    and a
    jr nz, .key
    ld a, ' '
  .key
    ld [de], a
    inc de
    ld a, ' '
    ld [de], a
    inc de
    dec b
    jr nz, .loop
  ld hl, OSKBottomRow
  ld bc, SCRN_X_B
  call mem_Copy
  ld de, 0
  ld hl, (SCRN_X_B << 8) | OSK_ROWS
  ld bc, win_buffer
  jp gbdk_SetWinTiles

_OSKSelect::;a = x, e = y
  swap a;x*16
  add a, OAM_X_OFS
  ld d, a
  ld a, e
  add a, a
  add a, a
  add a, a
  add a, OSK_Y+OAM_Y_OFS
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
