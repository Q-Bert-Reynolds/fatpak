SECTION "Gloval Vars", WRAM0

; labels that start with an underscore are available in C using extern
; labels without the underscore are not available in C

;game state
_game_state::
game_state:: DB

;UI
list_selection:: DB
inventory_mode:: DB

;options
text_speed:: DB
animation_style:: DB
coaching_style:: DB

;main save data
main_save::
_user_name::
user_name:: DS NAME_LENGTH
_rival_name::
rival_name:: DS NAME_LENGTH
hours:: DW
minutes:: DB
seconds:: DB
inventory:: DS MAX_ITEMS*BYTES_PER_ITEM;each item is 2 bytes
pc_items:: DS MAX_PC_ITEMS*BYTES_PER_ITEM
money:: DS 4;~$4b
players_seen:: DS 151/8+1
players_sign:: DS 151/8+1
current_farm:: DB
map:: DB
map_chunk:: DB
map_x:: DB
map_y:: DB
game_event_flags::
team_flags:: DB ;have you picked a team and which one? 
pc_flags:: DB ;Have you met Bill James? Gotten the Rolédex yet? Beaten the Elite Teams?
pennant_flags:: DB ;which leagues have you won
item_flags:: DS ITEM_FLAGS_SIZE
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

;player base data struct
player_base::
.num::       DB
.type1::     DB
.type2::     DB
.height::    DB
.weight::    DW
.hp::        DB
.bat::       DB
.field::     DB
.speed::     DB
.throw::     DB
.body_id::   DB
.head_id::   DB
.hat_id::    DB
.gb_pal::    DB
.sgb_pal::   DW
.anim::      DS 32
.tm_hm::     DS 7;ceiling((5 HMs + 50 TMs) / 8)
.level_up::  DS 23;learn set (2B * max 11 moves) and evolutions (3B * max 3 evolutions)
.end::

;move data struct
move_data::
.id::           DB
.use::          DB ;pitching=0, batting=1
.type::         DB
.pp::           DB
.power::        DB
.accuracy::     DB
.pitch_path::
.launch_angle:: DB
.end::

;item data
item_data::
.id::    DB
.type::  DB
.cost::  DS 4
.extra:: DS 2
.end::

;baseball
balls_strikes_outs:: DB; XBBBSSOO
_runners_on_base::
runners_on_base:: DW; lineup order of runners on base - SSSSFFFF HHHHTTTT (little-endian to make C code more readable)
_frame::
frame:: DB
current_batter:: DB;upper nibble is opponent, lower nibble is user
_home_team::
home_team:: DB;1 = user is home team
frame_runs:: DS MAX_INNINGS*2
_home_score::
home_score:: DB
home_hits:: DB
_away_score::
away_score:: DB
away_hits:: DB
move_choice:: DB
_pitch_move_id::
pitch_move_id:: DB
swing_move_id:: DB
play_menu_selection:: DB
aim_x:: DB
aim_y:: DB
swing_diff_x:: DB
swing_diff_y:: DB
swing_diff_z:: DB
ball_pos_x:: DW ;used for pitch and sim
ball_pos_y:: DW
pitch_z::
ball_pos_z:: DW
pitch_target_x::;pitch target offset from center of strike zone
ball_vel_x:: DB;same location used for velocity in simulation
pitch_target_y::
ball_vel_y:: DB
ball_vel_z:: DB
_ball_state::
ball_state:: DB;bits... 7 = caught, 6 = landed, 5 = fair, 4 = inPlay, 3..0 = position player holding ball

SECTION "Stack", WRAM0
stack_top: DS STACK_SIZE
stack_bottom:

SECTION "Buffers", WRAMX
_tile_buffer::
tile_buffer::       DS BUFFER_SIZE
_bkg_buffer::
bkg_buffer::        DS BUFFER_SIZE
_win_buffer::
win_buffer::        DS BUFFER_SIZE
_sprite_obj_buffer::
sprite_obj_buffer:: DS SPRITE_OBJ_BUFFER_SIZE; bank, address, x, y, extra
_cmd_buffer::
cmd_buffer::        DS BUFFER_SIZE/2
_str_buffer::
str_buffer::        DS STR_BUFFER_SIZE
_name_buffer::
name_buffer::       DS NAME_BUFFER_SIZE
_palette_buffer:
palette_buffer::    DS 8;4 colors, 2 bytes each