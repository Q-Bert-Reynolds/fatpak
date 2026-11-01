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
sram_map: DB
sram_map_chunk: DB
sram_map_x: DB
sram_map_y: DB
sram_item_flags:: DS ITEM_FLAGS_SIZE
sram_main_save_end:

SECTION "Clipboard", SRAM[TB_CLIP_ADDR], BANK[MAIN_SRAM_BANK];see tb_Copy
sram_clip_length:: DW
sram_clip_check:: DW;~length, the clipboard is empty if they don't match
sram_clip:: DS TB_CLIP_SIZE
ASSERT sram_main_save_end <= sram_clip_length
ASSERT sram_clip+TB_CLIP_SIZE == _SRAM+TB_HOLE, "the clipboard must end before the EverDrive registers"

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
