;text buffer, see src/editor/text_buffer.asm
DEF SETTINGS_SIZE EQU 4+PATH_SIZE+FS_NAME_SIZE;SettingsTable
IF DEF(EVERDRIVE_OS);PSRAM through the window: the text buffer and undo log are blocks (see constants.asm),
;this is PSRAM block MAIN_SRAM_BANK and the clipboard's text starts at offset $100 of it (TB_CLIP_SIZE)
DEF sram_tb_signature EQU TB_BASE
DEF sram_main_save    EQU TB_BASE+4
DEF sram_hours        EQU TB_BASE+4
DEF sram_minutes      EQU TB_BASE+6
DEF sram_seconds      EQU TB_BASE+7
DEF sram_main_save_end EQU TB_BASE+8
DEF sram_clip_length  EQU TB_BASE+$10
DEF sram_clip_check   EQU TB_BASE+$12
DEF sram_settings_signature EQU TB_BASE+$20
DEF sram_settings     EQU TB_BASE+$24
DEF sram_clip         EQU TB_CLIP_OFFSET;offset from block MAIN_SRAM_BANK's start (TBClipAddr)
ASSERT sram_settings+SETTINGS_SIZE <= TB_BASE+$100, "settings must end before the clipboard"
ELSE
FOR N, TB_BANKS
SECTION "Text Buffer {d:N}", SRAM[_SRAM], BANK[N]
  DS $2000
ENDR
ASSERT TB_SIZE <= $FFFF, "text buffer positions are 16 bit"

;undo log, see src/editor/undo.c
FOR N, UNDO_BANK, UNDO_BANK+UNDO_BANKS
SECTION "Undo Log {d:N}", SRAM[_SRAM], BANK[N]
  DS $2000
ENDR

SECTION "Main Save", SRAM[_SRAM], BANK[MAIN_SRAM_BANK]
sram_tb_signature:: DS 4

sram_main_save:
sram_hours: DW
sram_minutes: DB
sram_seconds: DB
sram_main_save_end:

;editor settings and the open file, kept with the text when the power is off (see SettingsLoad)
SECTION "Settings", SRAM[_SRAM+TB_HOLE+TB_HOLE_SIZE], BANK[MAIN_SRAM_BANK]
sram_settings_signature: DS 4
sram_settings: DS SETTINGS_SIZE;in SettingsTable's order

SECTION "Clipboard", SRAM[TB_CLIP_ADDR], BANK[MAIN_SRAM_BANK];see tb_Copy
sram_clip_length:: DW
sram_clip_check:: DW;~length, the clipboard is empty if they don't match
sram_clip:: DS TB_CLIP_SIZE
ASSERT sram_main_save_end <= sram_clip_length
ASSERT sram_clip+TB_CLIP_SIZE == _SRAM+TB_HOLE, "the clipboard must end before the EverDrive registers"
ENDC

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
IF DEF(EVERDRIVE_OS)
  ld a, 1;the swap file needs writing (src/editor/editor.c)
  ld [_swap_dirty], a
ENDC
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
