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
fs_box_top:: DB
fs_box_gen:: DB
fs_box_sel:: DB
fs_box_line:: DB
fs_osk_layer:: DB
fs_osk_key:: DB
fs_osk_rows:: DB
fs_busy:: DB
fs_progress_loaded:: DS 2
fs_progress_total:: DS 2
fs_progress_sent:: DS 4
_fs_map::
fs_map:: DB ; ModBackground's map mode on the SNES (FsBackground): 0 off, 1 under the bars, 2 full screen, | SGBFS_MAP_HIRES
fs_map_x:: DW
fs_map_y:: DW
fs_bar_sent:: DS 3 ; SCROLLBAR as last sent: the track's top line, its lines (0: none), the thumb's top
fs_state_end::

SECTION "Fullscreen log state", HRAM
fs_log_size:: DW
fs_log_tick:: DW
fs_log_active:: DB ; 0 off, 2 bootstrap page recording, 1 ordinary input
fs_log_dirty:: DB

SECTION "Terminal progress state", ROM0
_SGBProgress:: ; DE/BC=loaded/total 512-byte sectors; publication is part of FsUI
  ldh a, [sys_info]
  bit 2, a
  ret z
  ld a, e
  ldh [fs_progress_loaded], a
  ld a, d
  ldh [fs_progress_loaded+1], a
  ld a, c
  ldh [fs_progress_total], a
  ld a, b
  ldh [fs_progress_total+1], a
  ret

; The kernel's last mouse event (src/sgb/display.asm) as the SNES mouse driver reads the BIOS bridge's report
; (driver_snes_mouse.asm): commit (1 present, buttons << 1, an activity count << 3), x, y (the row * 8, * 4 in
; 512x448 text: driver_mouse.asm's MouseRow)
SECTION "Fullscreen mouse", WRAMX
fs_mouse:: DS 3
