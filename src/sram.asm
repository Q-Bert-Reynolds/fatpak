;text buffer, see src/editor/text_buffer.asm
DEF SETTINGS_SIZE EQU 4+PATH_SIZE+FS_NAME_SIZE;SettingsTable
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

SECTION "Settings Code", ROM0

SettingsSignature: DB "SET2";SET1 had the font

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
  DW 0

;C functions (src/editor/editor.h)
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
  ld b, 4
.check
    ld a, [de]
    cp a, [hl]
    jr nz, .never
    inc de
    inc hl
    dec b
    jr nz, .check
  ld a, 1
  call SettingsCopy
  ld a, 1
  ret
.never
  DISABLE_RAM_MBC5
  xor a
  ret
