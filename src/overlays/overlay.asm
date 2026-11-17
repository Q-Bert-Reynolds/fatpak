SECTION "Overlay state", WRAMX
_overlay_request:: DS 12
_overlay_saved:: DS 6 ; target, length, original CRC
_overlay_entry:: DW
_overlay_live:: DB

ASSERT ADD_BLOCK + (ADD_MAX >> 9) == SGB_FILE_BLOCK
ASSERT SGB_FILE_BLOCK + SGB_FILE_BLOCKS == OVERLAY_BACKUP
ASSERT OVERLAY_BACKUP + 16 <= $3C00

FIXED "Overlay dispatch"
_OverlayInstall::
  call FarCallInline
  DB BANK(_OverlayInstallBody)
  DW _OverlayInstallBody
_OverlayRestore::
  call FarCallInline
  DB BANK(_OverlayRestoreBody)
  DW _OverlayRestoreBody

; ABI 12: 0 request pointer, 1 install, 2 restore, 3 entry, 4 live, 5 enter.
FIXED "Overlay module API"
_ModuleAPIOverlay::
  and a
  ld bc, _overlay_request
  ret z
  dec a
  jr z, .install
  dec a
  jr z, .restore
  dec a
  jr z, .entry
  dec a
  jr z, .live
  dec a
  jr z, .enter
  ld a, $FF
  jr .result
.live
  ld a, [_overlay_live]
  jr .result
.install
  call _OverlayInstall
  jr .result
.restore
  call _OverlayRestore
.result
  ld c, a
  ld b, 0
  ret
.entry
  ld a, [_overlay_entry]
  ld c, a
  ld a, [_overlay_entry+1]
  ld b, a
  ret

.enter
  ld a, [_overlay_live]
  and a
  ld a, $FF
  jr z, .result
  LD_HL_VAR _overlay_entry
  ld bc, .returned
  push bc
  jp hl
.returned
  jr .result
