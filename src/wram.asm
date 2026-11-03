SECTION "Gloval Vars", WRAM0

; labels that start with an underscore are available in C using extern
; labels without the underscore are not available in C

;game state
_game_state::
game_state:: DB

;UI
list_selection:: DB

;text
text_speed:: DB;0 = fast, 1 = medium, 2 = slow (UIRevealText)

;main save data
main_save::
hours:: DW
minutes:: DB
seconds:: DB
main_save_end::

;drawing
sprite_props:: DB
sprite_offset:: DB
sprite_flags:: DB ;0 = skip
sprite_skip_id:: DB
sprite_first_tile:: DB

;temp vars
_a:: DB
_b:: DB
_c:: DB
_d:: DB
_i:: DB
_j:: DB
_k:: DB
_l:: DB
_s:: DB
_t:: DB
_u:: DB
_v:: DB
_w:: DW
_x:: DW
_y:: DW
_z:: DW

SECTION "Stack", WRAM0
stack_top: DS STACK_SIZE
stack_bottom:

SECTION "Buffers", WRAMX[$D000];cmd_buffer must start a page
_tile_buffer::
tile_buffer::       DS BUFFER_SIZE
bkg_buffer::        DS (TB_ROWS+1)*TB_STRIDE;the editor's row cache (a block's characters), 20x18 tiles for the engine
win_buffer::        DS SCRN_X_B*SCRN_Y_B;20x18 tiles, the editor moves text through it TB_CHUNK bytes at a time
_tile_attrs::
tile_attrs::        DS TB_ROWS*TB_STRIDE;style of each character in tile_buffer's text rows (see TBLex)
_tb_row_states::
tb_row_states::     DS (TB_ROWS+1)*2;lexer state at the start of each rendered row, then at _tb_bottom
block_states::      DS (TB_ROWS+1)*2;lexer state each render block was drawn with
render_glyph::      DS 8;a styled glyph
tb_state::          DS 2;lexer state (see TBLex)
tb_next_state::     DS 2;after the character TBLex looked at
tb_space_state::    DS 2;after the last space, a wrapped word starts there
tb_sync_end::       DS 2
tb_attr::           DB
tb_row_head::       DB;heading level of the row TBScanRow scanned
_tb_lang::          DB;LANG_*, how text is styled
                    DS 3*BUFFER_SIZE - (@ - tile_buffer)
cmd_buffer::        DS BUFFER_SIZE/2
_str_buffer::
str_buffer::        DS STR_BUFFER_SIZE
_name_buffer::
name_buffer::       DS NAME_BUFFER_SIZE
_render_dma_buffer::
render_dma_buffer:: DS TB_WIDTH*2;GBC: a row's tiles for HDMA, 16 byte aligned (see RenderRowDMA)
ASSERT render_dma_buffer % 16 == 0
