;theme: the editor's colours and looks. The theme in use is THEME_SIZE bytes of the settings block
;(TB_BASE + THEME_OFFSET in its window), so the swap file keeps it over a power cut: 8 GBC palettes,
;a look (LOOK_*) per style and one for the header and footer (THEME_BARS), its name. THEME.MOD edits
;it and loads and saves /GBCSYS/THEMES/<name>.json (src/ui/theme.c)
;
;   ThemeApply                  C: the theme on screen: the looks (style_looks), the GBC's palettes,
;                               the SGB's palettes 0 and 1, the DMG's shades (inverted when palette
;                               0's paper is darker than its ink: theme), the SNES's colours in
;                               fullscreen (fs_colors); the built-in light theme first if there's none
;text is color 3 on color 0, dim text color 2, accent text color 1 (see src/ui/render.asm). DMG inverts
;selected pixels (dim text is light grey there), SGB and GBC highlight them with color 1 of the row's
;palette (the text's look's, the header and footer's look's in the bars: the base palette).
;On GBC a tile drawn with a look's palette uses it (one palette a tile: the last char's). The cursor
;and keyboard highlight are sprites: GBC object palette 0 (palette 0's colours: color 1 the
;keyboard highlight, color 3 the cursor; the text's look's palette's colours), DMG OBP1 (cursor, EditorInvertCursor) and OBP0 (highlight).
DEF_RGB EDITOR_PAPER,      29, 29, 27;the built-in theme's palette 0 (the in-game menu's too: src/game/ingame.asm)
DEF_RGB EDITOR_HIGHLIGHT,  20, 25, 31
DEF_RGB EDITOR_DIM,        14, 17, 14
DEF_RGB EDITOR_INK,         2,  2,  3
DEF THEME_BASE EQU TB_BASE + THEME_OFFSET
DEF DMG_PAL_DARK EQU %00011011;every shade inverted (DMG_PAL_WLDB keeps 1 and 2)

SECTION "Theme Vars", WRAMX
_style_looks:: DS 16;the theme's looks, a style's at its STYLE_* (the renderer's), the bars' at THEME_BARS
_fs_colors:: DS 16;SGB fullscreen: paper, selection, dim, text, keyword, string, number, label (src/sgb/display.asm)

SECTION "Theme", ROM0
_ThemeApply::
  call ThemeLoad
  SGB_JUMP 18
  call ThemeWindow
  ldh a, [sys_info]
  and a, SYS_INFO_GBC
  jr z, .notGBC
  ld a, BCPSF_AUTOINC
  ldh [rBCPS], a
  ld hl, THEME_BASE + THEME_PALETTES
  ld bc, 64 << 8 | LOW(rBCPD)
  call .write
  ld a, OCPSF_AUTOINC
  ldh [rOCPS], a
  call TextPalette;object palette 0: the text's palette's colours
  ld bc, 8 << 8 | LOW(rOCPD)
  call .write
  jr .done
.write;hl = colours, b = bytes, c = the data register
    LCD_WAIT_VRAM
    ld a, [hli]
    ldh [c], a
    dec b
    jr nz, .write
  ret
.notGBC
  ldh a, [sys_info]
  and a, SYS_INFO_SGB
  jr z, .done
  call SGBThemePalettes;the SGB keeps the DMG's shades and changes their colours: 4 of the theme's palettes
.done
  call ThemeRestore
  ldh a, [sys_info]
  and a, SYS_INFO_GBC | SYS_INFO_SGB
  ret nz
  ld a, [_theme]
  and a
  ld a, DMG_PAL_BDLW
  jr z, .shades
  ld a, DMG_PAL_DARK
.shades
  ldh [rBGP], a
  ldh [rOBP0], a
  ld a, [cursor_white]
  jp _EditorInvertCursor

;maps the settings block into the window, the window's block saved in theme_window
ThemeWindow:
  ld a, [EDX_BLOCK]
  ld [theme_window], a
  ld a, [EDX_BLOCK+1]
  ld [theme_window+1], a
  ld a, TB_PSRAM_HIGH
  ld [EDX_BLOCK+1], a;high byte first, then low: the low byte write switches the window
  ld a, MAIN_SRAM_BANK
  ld [EDX_BLOCK], a
  ret
ThemeRestore:
  ld a, [theme_window+1]
  ld [EDX_BLOCK+1], a
  ld a, [theme_window]
  ld [EDX_BLOCK], a
  ret

;the theme's looks, dark flag (the text's palette's paper darker than its ink) and SNES colours (the built-in theme first if there's none)
ThemeLoad:
  call ThemeWindow
  ld hl, THEME_BASE + THEME_SIGNATURE
  ld de, ThemeSignature
  ld b, 4
.check
    ld a, [de]
    cp a, [hl]
    jr nz, .default
    inc de
    inc hl
    dec b
    jr nz, .check
  jr .load
.default
  ld hl, DefaultTheme
  ld de, THEME_BASE
  ld bc, THEME_SIZE
  call mem_Copy
.load
  ld hl, THEME_BASE + THEME_LOOKS
  ld de, _style_looks
  ld bc, 16
  call mem_Copy
  call TextPalette;its ink
  ld a, l
  add a, 6
  ld l, a
  call ColorSum
  push af
  call TextPalette;its paper
  call ColorSum
  pop bc
  cp a, b;carry: the paper is darker
  ld a, 0
  rla
  ld [_theme], a
  call TextPalette;the SNES's paper and selection: the text's palette's colours 0 and 1
  ld de, _fs_colors
  ld bc, 4
  call mem_Copy
  ld hl, FsStyles
.fs
    ld a, [hli]
    push hl
    push de
    add a, LOW(_style_looks)
    ld l, a
    ld a, HIGH(_style_looks)
    adc a, 0
    ld h, a
    ld a, [hl]
    call InkAddress
    pop de
    ld a, [hli]
    ld [de], a
    inc de
    ld a, [hl]
    ld [de], a
    inc de
    pop hl
    ld a, e
    cp a, LOW(_fs_colors + 16)
    jr nz, .fs
  jp ThemeRestore

;SGB: its 4 palettes from the theme's 8 (in the window): 0 the text's, 1-3 those the most looks use of the
;ones with its paper (the SGB's colour 0 is all four's); the rest are drawn in the text's. sgb_pal_map: the SGB
;palette of each of the theme's (src/sgb/attributes.asm). Counts in cmd_buffer + 16, the 4 chosen at + 24
SGBThemePalettes:
  ld hl, cmd_buffer + 16
  xor a
  ld b, 8
.zero
    ld [hli], a
    dec b
    jr nz, .zero
  ld hl, sgb_pal_map
  ld b, 8
.unmapped
    ld [hli], a
    dec b
    jr nz, .unmapped
  ld hl, _style_looks
  ld b, 16
.count
    ld a, [hli]
    swap a
    and a, 7
    add a, LOW(cmd_buffer + 16)
    ld e, a
    ld d, HIGH(cmd_buffer + 16)
    ld a, [de]
    inc a
    ld [de], a
    dec b
    jr nz, .count
  ld a, [_style_looks + STYLE_TEXT]
  swap a
  and a, 7
  ld hl, cmd_buffer + 24
  ld [hli], a
  ld [hli], a
  ld [hli], a
  ld [hl], a
  call TextPalette
  ld a, [hli]
  ld c, a
  ld b, [hl];the text's paper
  ld hl, THEME_BASE + THEME_PALETTES
  ld de, cmd_buffer + 16
.paper;a palette with another paper isn't one of the SGB's
    ld a, [hli]
    cp a, c
    jr nz, .other
    ld a, [hl]
    cp a, b
    jr z, .same
  .other
    xor a
    ld [de], a
  .same
    ld a, l
    add a, 7
    ld l, a
    inc e
    ld a, e
    cp a, LOW(cmd_buffer + 24)
    jr nz, .paper
  ld a, [cmd_buffer + 24];the text's: palette 0 already
  add a, LOW(cmd_buffer + 16)
  ld l, a
  ld h, HIGH(cmd_buffer + 16)
  ld [hl], 0
  ld c, 1
.pick;the most used of the rest (the first of equals) for SGB palette c
    ld hl, cmd_buffer + 16
    ld b, 0
    ld de, 8;d: a palette, e: the most used, 8 none
  .find
      ld a, [hli]
      cp a, b
      jr c, .fewer
      jr z, .fewer
      ld b, a
      ld e, d
    .fewer
      inc d
      ld a, d
      cp a, 8
      jr nz, .find
    ld a, e
    cp a, 8
    jr z, .send
    add a, LOW(cmd_buffer + 16)
    ld l, a
    ld h, HIGH(cmd_buffer + 16)
    ld [hl], 0
    ld a, e
    add a, LOW(sgb_pal_map)
    ld l, a
    ld h, HIGH(sgb_pal_map)
    ld [hl], c
    ld a, c
    add a, LOW(cmd_buffer + 24)
    ld l, a
    ld h, HIGH(cmd_buffer + 24)
    ld [hl], e
    inc c
    ld a, c
    cp a, 4
    jr nz, .pick
.send
  ldh a, [rIE];no VBlank meanwhile (its pad latch writes P1), whatever IME is
  push af
  and a, ~IEF_VBLANK
  ldh [rIE], a
  ld a, [cmd_buffer + 25]
  call .address
  ld d, h
  ld e, l
  ld a, [cmd_buffer + 24]
  call .address
  ld b, h
  ld c, l
  ld a, PAL01
  call sgb_SetPal
  ld a, [cmd_buffer + 27]
  call .address
  ld d, h
  ld e, l
  ld a, [cmd_buffer + 26]
  call .address
  ld b, h
  ld c, l
  ld a, PAL23;(its colour 0, all four's, the same paper)
  call sgb_SetPal
  pop af
  ldh [rIE], a
  ret
.address;a = a theme palette, returns hl = its colours
  add a, a
  add a, a
  add a, a
  add a, LOW(THEME_BASE + THEME_PALETTES)
  ld l, a
  ld h, HIGH(THEME_BASE + THEME_PALETTES)
  ret

;returns hl = the text's look's palette in the theme (in the window), affects a
TextPalette:
  ld a, [_style_looks + STYLE_TEXT]
  and a, LOOK_PALETTE
  rrca;palette * 8
  add a, LOW(THEME_BASE + THEME_PALETTES)
  ld l, a
  ld h, HIGH(THEME_BASE + THEME_PALETTES)
  ret

;a = look, returns hl = its ink colour in the theme (in the window): its palette's color 3, 2 (dim)
;or 1 (accent)
InkAddress:
  ld b, a
  and a, LOOK_PALETTE
  rrca;palette * 8
  ld c, a
  ld a, b
  ld d, 6
  bit 2, a;LOOK_DIM
  jr z, .notDim
  ld d, 4
.notDim
  bit 3, a;LOOK_ACCENT
  jr z, .ink
  ld d, 2
.ink
  ld a, c
  add a, d
  add a, LOW(THEME_BASE + THEME_PALETTES)
  ld l, a
  ld h, HIGH(THEME_BASE + THEME_PALETTES)
  ret

;hl = an RGB555 colour, returns a = red + green + blue (0-93), affects bc, de, hl
ColorSum:
  ld a, [hli]
  ld c, a;gggrrrrr
  ld b, [hl];0bbbbbgg
  and a, 31
  ld e, a
  ld a, b
  rrca
  rrca
  and a, 31
  add a, e
  ld e, a
  ld a, b
  and a, 3
  add a, a
  add a, a
  add a, a
  ld d, a
  ld a, c
  rlca
  rlca
  rlca
  and a, 7
  or a, d
  add a, e
  ret

;C: c's width in style's look (e = STYLE_* << 4) in the font (_font): a module's text rows (ModStyle)
_ThemeWidth::
  ld c, a
  ld a, [_screen_cells];512x448: a 4-pixel column each
  and a
  ld a, 4
  ret nz
  ld a, [_font]
  and a
  ld a, 8
  ret z;the mono font: 8 pixels for everything
  ld a, e
  swap a
  and a, $0F
  add a, LOW(_style_looks)
  ld l, a
  ld a, HIGH(_style_looks)
  adc a, 0
  ld h, a
  bit 7, [hl];LOOK_CODE
  ld a, 4;the code font's (CODE_WIDTH)
  ret nz
  bit 0, [hl];LOOK_BOLD
  jr z, .plain
  ld a, [font_bold_widths]
  jp StyledWidth
.plain
  ld h, HIGH(_font_widths)
  ld l, c
  ld a, [hl]
  ret

;the SNES's dim, text, keyword, string, number and label colours: these styles' ink
FsStyles:
  DB STYLE_COMMENT, STYLE_TEXT, STYLE_KEYWORD, STYLE_STRING, STYLE_NUMBER, STYLE_LABEL

ThemeSignature: DB "THM1"

;the built-in theme (data/themes/Light.json): palettes, looks, name, signature, not edited
DefaultTheme:
  RGB 29, 29, 27;0: paper, selection, dim, ink
  RGB 20, 25, 31
  RGB 14, 17, 14
  RGB 2, 2, 3
  RGB 29, 29, 27;1 blue: headings, keywords, types
  RGB 4, 9, 24
  RGB 14, 17, 14
  RGB 2, 2, 3
  RGB 29, 29, 27;2 dark red: code, strings
  RGB 19, 4, 4
  RGB 14, 17, 14
  RGB 2, 2, 3
  RGB 29, 29, 27;3 purple: numbers
  RGB 15, 5, 20
  RGB 14, 17, 14
  RGB 2, 2, 3
  RGB 29, 29, 27;4 brown-orange: directives, labels
  RGB 21, 10, 0
  RGB 14, 17, 14
  RGB 2, 2, 3
  RGB 29, 29, 27;5 green
  RGB 3, 15, 5
  RGB 14, 17, 14
  RGB 2, 2, 3
  RGB 29, 29, 27;6 teal
  RGB 0, 14, 16
  RGB 14, 17, 14
  RGB 2, 2, 3
  RGB 29, 29, 27;7 grey
  RGB 11, 11, 12
  RGB 14, 17, 14
  RGB 2, 2, 3
ASSERT @ - DefaultTheme == THEME_LOOKS
  DB 0;STYLE_TEXT
  DB LOOK_BOLD
  DB LOOK_ITALIC
  DB LOOK_BOLD | LOOK_ITALIC
  DB LOOK_DIM;STYLE_MARK
  DB LOOK_CODE | LOOK_ACCENT | 2 << 4;STYLE_CODE
  DB LOOK_ACCENT | 1 << 4;STYLE_HEAD
  DB LOOK_BOLD | LOOK_ACCENT | 1 << 4;STYLE_HEAD_BOLD
  DB LOOK_DIM;STYLE_COMMENT
  DB LOOK_ACCENT | 1 << 4;STYLE_KEYWORD
  DB LOOK_ACCENT | 1 << 4;STYLE_TYPE
  DB LOOK_ACCENT | 2 << 4;STYLE_STRING
  DB LOOK_ACCENT | 3 << 4;STYLE_NUMBER
  DB LOOK_BOLD | LOOK_ACCENT | 4 << 4;STYLE_PREPROC
  DB LOOK_ACCENT | 4 << 4;STYLE_LABEL
  DB 0;THEME_BARS
ASSERT @ - DefaultTheme == THEME_NAME
  DB "Light"
  DS THEME_SIGNATURE - THEME_NAME - 5, 0
  DB "THM1"
  DS THEME_SIZE - THEME_SIGNATURE - 4, 0
ASSERT @ - DefaultTheme == THEME_SIZE

SECTION "Theme Window", WRAMX
theme_window: DS 2
