; Terminal state is separate from geometry/metrics and never overlaps row data.
SECTION "Fullscreen transport", HRAM
fs_ready:: DB
fs_fault:: DB
fs_seq:: DB
fs_committed:: DB
fs_pending:: DB
fs_ack:: DB
fs_write:: DW
fs_row:: DB
fs_count:: DB
fs_font:: DB
fs_styled:: DB
fs_chars:: DW
fs_attrs:: DW
fs_width:: DB
fs_sel_start:: DB
fs_sel_end:: DB
fs_sel_cols:: DS 2
fs_force:: DB
fs_x:: DB
fs_hash:: DW
fs_mb:: DS 4
fs_cursor:: DS 3
fs_status:: DS 16
fs_deferred:: DB
fs_ring:: DB
fs_tick_frame:: DB
