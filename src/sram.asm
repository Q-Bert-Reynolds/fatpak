;text buffer, see src/editor/text_buffer.asm
SECTION "Text Buffer 0", SRAM, BANK[0]
sram_text_buffer: DS $2000
SECTION "Text Buffer 1", SRAM, BANK[1]
  DS $2000
SECTION "Text Buffer 2", SRAM, BANK[2]
  DS $2000

SECTION "Main Save", SRAM[_SRAM], BANK[MAIN_SRAM_BANK]
sram_tb_signature:: DS 4

sram_main_save:
sram_hours: DW
sram_minutes: DB
sram_seconds: DB
sram_main_save_end:

;editor settings and the open file, kept with the text when the power is off (see SettingsLoad)
DEF SETTINGS_SIZE EQU 5+PATH_SIZE+FS_NAME_SIZE;SettingsTable
SECTION "Settings", SRAM[_SRAM+TB_HOLE+TB_HOLE_SIZE], BANK[MAIN_SRAM_BANK]
sram_settings_signature: DS 4
sram_settings: DS SETTINGS_SIZE;in SettingsTable's order

SECTION "Settings Vars", WRAM0
settings_load: DB;SettingsCopy's direction

SECTION "Clipboard", SRAM[TB_CLIP_ADDR], BANK[MAIN_SRAM_BANK];see tb_Copy
sram_clip_length:: DW
sram_clip_check:: DW;~length, the clipboard is empty if they don't match
sram_clip:: DS TB_CLIP_SIZE
ASSERT sram_main_save_end <= sram_clip_length
ASSERT sram_clip+TB_CLIP_SIZE == _SRAM+TB_HOLE, "the clipboard must end before the EverDrive registers"

SECTION "Settings Code", ROM0

SettingsSignature: DB "SET1"

MACRO SETTING ;\1 = C variable, \2 = size
  DW \1
  DB \2
ENDM

SettingsTable:
  SETTING _font, 1
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

SECTION "Save/Load Code", ROM0
LoadGame::
  di
  ENABLE_RAM_MBC5
  SWITCH_RAM_MBC5 MAIN_SRAM_BANK
  ld hl, sram_main_save
  ld de, main_save
  ld bc, sram_main_save_end - sram_main_save
  call mem_Copy
  DISABLE_RAM_MBC5
  reti

SaveGame::
  di
  ENABLE_RAM_MBC5
  SWITCH_RAM_MBC5 MAIN_SRAM_BANK
  ld hl, main_save
  ld de, sram_main_save
  ld bc, sram_main_save_end - sram_main_save
  call mem_Copy
  DISABLE_RAM_MBC5
  reti
