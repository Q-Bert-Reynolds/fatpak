;theme (UI and syntax colors in the settings later)
DEF_RGB EDITOR_PAPER,      29, 29, 27
DEF_RGB EDITOR_HIGHLIGHT,  20, 25, 31
DEF_RGB EDITOR_DIM,        14, 17, 14;grey-green: comments, markdown markers
DEF_RGB EDITOR_INK,         2,  2,  3
DEF EDITOR_ACCENTS EQU 4

  COLOR_SECTION;GBCSetPalette and EditorPalette are in this bank

;text is color 3 on color 0, dim text color 2 (see src/ui/render.asm). DMG inverts selected pixels
;(dim text is light grey there), SGB and GBC highlight them with color 1. GBC tiles with accent ink use
;palettes 1-4 (StyleLooks), their color 1 is the accent
EditorSetPalettes:
  ldh a, [sys_info]
  and a, SYS_INFO_GBC
  jr z, .notGBC
  xor a
  ld hl, EditorPalette
  call GBCSetPalette
  ld a, BCPSF_AUTOINC | 8;BG palettes 1 and up
  ldh [rBCPS], a
  ld hl, EditorAccentPalettes
  ld c, EDITOR_ACCENTS*8
.accent
    LCD_WAIT_VRAM
    ld a, [hli]
    ldh [rBCPD], a
    dec c
    jr nz, .accent
  ret
.notGBC
  ldh a, [sys_info]
  and a, SYS_INFO_SGB
  jr z, .dmg
  ld a, PAL01
  ld bc, EditorPalette
  ld d, b
  ld e, c
  jp sgb_SetPal
.dmg
  ld a, DMG_PAL_BDLW
  ldh [rBGP], a
  ret

EditorPalette:
  EDITOR_PAPER
  EDITOR_HIGHLIGHT
  EDITOR_DIM
  EDITOR_INK

EditorAccentPalettes:;color 1 is the accent
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


