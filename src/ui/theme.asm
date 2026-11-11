;theme: the editor's palettes, light or dark (_theme, a setting; THEME.MOD changes it)
;
;   ThemeApply                  C: sets every palette for _theme, keeps the cursor's colour
;   EditorSetPalettes           the same, for TRAMPOLINE (EditorSetup)
DEF_RGB EDITOR_PAPER,      29, 29, 27
DEF_RGB EDITOR_HIGHLIGHT,  20, 25, 31
DEF_RGB EDITOR_DIM,        14, 17, 14;grey-green: comments, markdown markers
DEF_RGB EDITOR_INK,         2,  2,  3
DEF_RGB DARK_PAPER,         3,  3,  4
DEF_RGB DARK_HIGHLIGHT,     6, 10, 18
DEF_RGB DARK_DIM,          13, 15, 13
DEF_RGB DARK_INK,          27, 27, 25
DEF EDITOR_ACCENTS EQU 4
DEF THEME_BG_BYTES EQU (1 + EDITOR_ACCENTS) * 8;BG palettes 0-4
DEF DMG_PAL_DARK EQU %00011011;every shade inverted (DMG_PAL_WLDB keeps 1 and 2)

FIXED "Theme"
_ThemeApply::
  TRAMPOLINE EditorSetPalettes
  ret

PAGE THEME_PAGE
;text is color 3 on color 0, dim text color 2 (see src/ui/render.asm). DMG inverts selected pixels
;(dim text is light grey there), SGB and GBC highlight them with color 1. GBC tiles with accent ink use
;palettes 1-4 (StyleLooks), their color 1 is the accent. The cursor and keyboard highlight are
;sprites: GBC object palette 0, DMG OBP1 (cursor, EditorInvertCursor) and OBP0 (highlight).
EditorSetPalettes:
  ldh a, [sys_info]
  and a, SYS_INFO_GBC
  jr z, .notGBC
  ld hl, LightPalettes
  ld de, LightObjectPalette
  ld a, [_theme]
  and a
  jr z, .gbc
  ld hl, DarkPalettes
  ld de, DarkObjectPalette
.gbc
  ld a, BCPSF_AUTOINC
  ldh [rBCPS], a
  ld c, THEME_BG_BYTES
.background
    LCD_WAIT_VRAM
    ld a, [hli]
    ldh [rBCPD], a
    dec c
    jr nz, .background
  ld a, OCPSF_AUTOINC
  ldh [rOCPS], a
  ld c, 8
.object
    LCD_WAIT_VRAM
    ld a, [de]
    ldh [rOCPD], a
    inc de
    dec c
    jr nz, .object
  ret
.notGBC
  ldh a, [sys_info]
  and a, SYS_INFO_SGB
  jr z, .dmg
  ld bc, LightPalettes;the SGB's palette 0 and 1: DMG shades stay, the colours change
  ld a, [_theme]
  and a
  jr z, .sgb
  ld bc, DarkPalettes
.sgb
  ld a, PAL01
  ld d, b
  ld e, c
  jp sgb_SetPal
.dmg
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

;paper, highlight, dim, ink, then the accent palettes: color 1 is the accent
LightPalettes:
  EDITOR_PAPER
  EDITOR_HIGHLIGHT
  EDITOR_DIM
  EDITOR_INK
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
ASSERT @ - LightPalettes == THEME_BG_BYTES

DarkPalettes:;the same roles, brighter accents
  DARK_PAPER
  DARK_HIGHLIGHT
  DARK_DIM
  DARK_INK
  DARK_PAPER
  RGB 13, 19, 31
  DARK_DIM
  DARK_INK
  DARK_PAPER
  RGB 31, 13, 12
  DARK_DIM
  DARK_INK
  DARK_PAPER
  RGB 24, 15, 31
  DARK_DIM
  DARK_INK
  DARK_PAPER
  RGB 31, 21, 9
  DARK_DIM
  DARK_INK
ASSERT @ - DarkPalettes == THEME_BG_BYTES

;object palette 0: color 1 the keyboard highlight (behind light keys in the dark), color 3 the cursor
LightObjectPalette:
  COLOR_OFF_WHITE
  COLOR_LIGHT_GREY
  COLOR_DARK_GREY
  COLOR_BLACK
DarkObjectPalette:
  DARK_PAPER
  RGB 9, 10, 12
  DARK_DIM
  DARK_INK
