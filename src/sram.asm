SECTION "Main Save", SRAM, BANK[MAIN_SRAM_BANK]
sram_text_speed: DB
sram_animation_style: DB

sram_main_save:
sram_hours: DW
sram_minutes: DB
sram_seconds: DB
sram_map: DB
sram_map_chunk: DB
sram_map_x: DB
sram_map_y: DB
sram_item_flags:: DS ITEM_FLAGS_SIZE
sram_main_save_end:

SECTION "Save/Load Code", ROM0
LoadOptions::
  di
  SWITCH_RAM_MBC5 MAIN_SRAM_BANK
  ENABLE_RAM_MBC5
  ld hl, sram_text_speed
  ld de, text_speed
  ld bc, 2;text_speed and animation_style
  call mem_Copy
  DISABLE_RAM_MBC5
  reti

SaveOptions::
  di
  SWITCH_RAM_MBC5 MAIN_SRAM_BANK
  ENABLE_RAM_MBC5
  ld hl, text_speed
  ld de, sram_text_speed
  ld bc, 2;text_speed and animation_style
  call mem_Copy
  DISABLE_RAM_MBC5
  reti

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
