;text buffer, see src/editor/text_buffer.asm
DEF SETTINGS_SIZE EQU 9+PATH_SIZE+FS_NAME_SIZE;SettingsTable
;PSRAM through the window: the text buffer and undo log are blocks (see constants.asm),
;this is PSRAM block MAIN_SRAM_BANK and the clipboard's text starts at offset $100 of it (TB_CLIP_SIZE)
DEF sram_tb_signature EQU TB_BASE
DEF sram_clip_length  EQU TB_BASE+$10
DEF sram_clip_check   EQU TB_BASE+$12
DEF sram_settings_signature EQU TB_BASE+$20
DEF sram_settings     EQU TB_BASE+$24
DEF sram_clip         EQU TB_CLIP_OFFSET;offset from block MAIN_SRAM_BANK's start (TBClipAddr)
ASSERT sram_settings+SETTINGS_SIZE <= TB_BASE+$100, "settings must end before the clipboard"

SECTION "Settings Vars", WRAM0
settings_load: DB;SettingsCopy's direction
_theme:: DB;0 light, 1 dark (src/ui/theme.asm)
_language:: DB;the UI's language: its column in data/strings/strings.csv, 0 English (src/app/language.c)
_resolution:: DB;SGB: RESOLUTION_256 (fullscreen), RESOLUTION_160 (the BIOS's, no takeover at boot) or RESOLUTION_512 (maps)

SECTION "Settings WRAMX", WRAMX;WRAM0 is full
_font_tiles:: DB;SETTINGS > FONT: 1 for 8x8 tiles (the mono font for the editor and browser, src/app/menu.c)
_show_hidden:: DB;SETTINGS > HIDDEN FILES: 1 lists dotfiles and hidden files (src/fatfs/fatfs.c's NextEntry)

SECTION "Settings Code", ROM0

SettingsSignature: DB "SET8";SET7 is SET8 without hidden files;SET6 is SET7 without the font;SET1 had the font, SET2 is SET3 without the theme, SET3 is SET4 without the language, SET5 is SET6 without the resolution

MACRO SETTING ;\1 = C variable, \2 = size
  DW \1
  DB \2
ENDM

SettingsTable:
  SETTING _tb_nowrap, 1
  SETTING _bars_on, 1
  SETTING _fs_crlf, 1
  SETTING _modified, 1
  SETTING _file_dir, PATH_SIZE
  SETTING _file_name, FS_NAME_SIZE
  SETTING _theme, 1;SET3: keep new settings last, so older tables are a prefix
  SETTING _language, 1;SET4
  SETTING _kb_driver, 1;SET5
  SETTING _resolution, 1;SET6
  SETTING _font_tiles, 1;SET7
  SETTING _show_hidden, 1;SET8
  DW 0

;C functions (src/editor/settings.h)
;   SettingsLoad                sets the variables in SettingsTable from SRAM, returns a = 0 if they were never saved
;   SettingsSave

;a = 0 copies the variables to SRAM, 1 from SRAM
SettingsCopy:
  ld [settings_load], a
  ENABLE_RAM_MBC5
  SWITCH_RAM_MBC5 MAIN_SRAM_BANK
  ld hl, SettingsTable
  ld de, sram_settings
.loop
    ld a, [hli]
    ld c, a
    ld a, [hli]
    ld b, a
    or a, c
    jr z, .done
    ld a, [hli]
    push hl
    push de
    push af
    ld h, b
    ld l, c;variable
    ld a, [settings_load]
    and a
    jr z, .copy
    ld b, d
    ld c, e
    ld d, h
    ld e, l
    ld h, b
    ld l, c;SRAM to variable
  .copy
    pop af
    ld c, a
    ld b, 0
    call mem_Copy
    pop de
    pop hl
    dec hl
    ld a, [hli];size again
    add a, e
    ld e, a
    adc a, d
    sub a, e
    ld d, a
    jr .loop
.done
  DISABLE_RAM_MBC5
  ret

_SettingsSave::
  ld a, 1;the swap file needs writing (src/editor/editor.c)
  ld [_swap_dirty], a
  ld [EDX_BLOCK+1], a;settings are in $01F0, even after a driver/data window read
  ENABLE_RAM_MBC5
  SWITCH_RAM_MBC5 MAIN_SRAM_BANK
  ld hl, SettingsSignature
  ld de, sram_settings_signature
  ld bc, 4
  call mem_Copy
  xor a
  jr SettingsCopy

_SettingsLoad::
  ENABLE_RAM_MBC5
  SWITCH_RAM_MBC5 MAIN_SRAM_BANK
  ld hl, SettingsSignature
  ld de, sram_settings_signature
  ld b, 3
.check
    ld a, [de]
    cp a, [hl]
    jr nz, .never
    inc de
    inc hl
    dec b
    jr nz, .check
  ld a, [de];the version
  cp a, [hl]
  jr z, .load
  cp a, '2'
  jr z, .load
  cp a, '4'
  jr z, .load
  cp a, '5'
  jr z, .load
  cp a, '6'
  jr z, .load
  cp a, '7'
  jr z, .load
  cp a, '3'
  jr nz, .never
.load
  push af
  ld a, 1
  call SettingsCopy
  pop af
  cp a, '8'
  jr z, .loaded
  push af
  xor a;SET7 ended at the font
  ld [_show_hidden], a
  pop af
  cp a, '7'
  jr z, .loaded
  push af
  xor a;SET6 ended at the resolution
  ld [_font_tiles], a
  pop af
  cp a, '6'
  jr z, .loaded
  push af
  xor a;SET5 ended at the keyboard driver
  ld [_resolution], a
  pop af
  cp a, '5'
  jr z, .loaded
  push af
  ld a, 1
  ld [_kb_driver], a
  pop af
  cp a, '4'
  jr z, .loaded
  cp a, '3'
  jr z, .set3
  xor a;SET2 had nothing after the file name: the theme byte is whatever was there
  ld [_theme], a
.set3
  xor a;nor SET3 after the theme
  ld [_language], a
.loaded
  ld a, 1
  ret
.never
  DISABLE_RAM_MBC5
  xor a
  ret
