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
map:: DB
map_chunk:: DB
map_x:: DB
map_y:: DB
game_event_flags::
item_flags:: DS ITEM_FLAGS_SIZE;used by map items
game_event_flags_end::
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

SECTION "Buffers", WRAMX
_tile_buffer::
tile_buffer::       DS BUFFER_SIZE
bkg_buffer::        DS BUFFER_SIZE
win_buffer::        DS BUFFER_SIZE
cmd_buffer::        DS BUFFER_SIZE/2
_str_buffer::
str_buffer::        DS STR_BUFFER_SIZE
_name_buffer::
name_buffer::       DS NAME_BUFFER_SIZE