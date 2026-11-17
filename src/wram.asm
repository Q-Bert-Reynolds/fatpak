SECTION "Gloval Vars", WRAM0

; labels that start with an underscore are available in C using extern
; labels without the underscore are not available in C

_data_loaded:: DB;the data file is in PSRAM (DATA_BLOCK)
sgb_from_window:: DB;_sgb_VRAMTransfer's source is PSRAM blocks
_swap_dirty:: DB;the text, clipboard or settings changed since the swap file was written

SECTION "Stack", WRAM0
stack_top: DS STACK_SIZE
stack_bottom:

SECTION "Buffers", WRAMX[$D000]
; The GB renderer and wide logical rows are mutually exclusive. Keep the first
; 3072 bytes available to wide-module BSS save/restore in either layout.
UNION
_tile_buffer::
tile_buffer::       DS BUFFER_SIZE
win_buffer::        DS 256;PSRAM staging, and the GBC accent plane
bkg_buffer::        DS (TB_ROWS+1)*TB_STRIDE
tile_attrs::        DS TB_ROWS*TB_STRIDE
                    DS (-@) & 15
_render_dma_buffer::
render_dma_buffer:: DS TB_WIDTH*2
block_states::      DS (TB_ROWS+1)*2
render_glyph::      DS 8
row_font::          DS TB_ROWS+1
_block_map_rows::
block_map_rows::    DS TB_ROWS+1
block_accents::     DS TB_ROWS+1
block_sel::         DS (TB_ROWS+1)*2
block_box::         DS TB_ROWS+1
gb_row_offsets::    DS 32*2
                    DS $DD00-@
cmd_buffer::        DS $1A0;bitmap/masks/palettes and dim plane, both page-aligned
NEXTU
wide_tile_buffer:: DS MAX_SCREEN_ROWS*MAX_ROW_STRIDE
wide_tile_attrs::  DS MAX_SCREEN_ROWS*MAX_ROW_STRIDE
wide_row_offsets:: DS 32*2
wide_row_hashes::  DS MAX_SCREEN_ROWS*2
wide_scratch::     DS 32;PSRAM staging while the GB bitmap renderer is absent
                    DS $DEA0-@
ENDU
_tb_row_states::
tb_row_states::     DS (MAX_SCREEN_ROWS+1)*2
tb_state::          DS 2;lexer state (see TBLex)
tb_next_state::     DS 2;after the character TBLex looked at
tb_space_state::    DS 2;after the last space, a wrapped word starts there
tb_sync_end::       DS 2
tb_attr::           DB
tb_row_head::       DB;heading level of the row TBScanRow scanned
_tb_lang::          DB;LANG_*, how text is styled
tb_lex_pos::        DW;the char TBLexCode is at
tb_word::           DS KEYWORD_MAX;the word TBPeekWord looks up
tb_word_len::       DB
tb_checks::         DS 64;C comment state every 1KB (TBCheckState)
tb_checks_last::    DB
tb_check_end::      DW
tb_check_pos::      DW
tb_check_state::    DB
_str_buffer::
str_buffer::        DS STR_BUFFER_SIZE
_name_buffer::
name_buffer::       DS NAME_BUFFER_SIZE
ASSERT tile_buffer == MODULE_BSS
ASSERT wide_tile_buffer == MODULE_BSS
ASSERT gb_row_offsets >= MODULE_BSS+MODULE_BSS_SIZE
ASSERT wide_row_offsets >= MODULE_BSS+MODULE_BSS_SIZE
ASSERT wide_tile_attrs-wide_tile_buffer == MAX_SCREEN_ROWS*MAX_ROW_STRIDE
ASSERT LOW(win_buffer) == 0
ASSERT LOW(cmd_buffer) == 0
ASSERT render_dma_buffer % 16 == 0
ASSERT @ <= $DF90, "buffers must leave room for strings, mouse and module state"
