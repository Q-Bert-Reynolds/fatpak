; The kernel's side of its extension (map.s, char.s: segment EXT at $7E:DC00): the stubs C calls, which go there
; far, and the trampolines it calls back through. kernel.c only enters a map with the extension loaded
; (ext_ready: CODE's last part; the 4 px cache's rebuild over it clears it, fixed.s).
.setcpu "65816"
.export _MapLayer, _MapTiles, _MapCells, _MapColors, _MapScroll, _MapGlide, MapRow, FarWaitBlank, FarCapture
.export _CharLayer, _CharRows, _CharScroll, _CharColors, _CharCursor, FarProgress
.import _WaitBlank, _Capture, _ui_right, _map_mode, ui_rows, _progress_width
.import FarMapLayer, FarMapTiles, FarMapCells, FarMapColors, FarMapScroll, FarMapGlide, FarRegions
.import FarCharLayer, FarCharRows, FarCharScroll, FarCharColors, FarCharCursor

HIRES = $10 ; SGBFS_MAP_HIRES

; The extension's first word: its length (the GB sends it from SGB.DAT, whose header the SGB log reuses)
.import __EXT_SIZE__
.segment "EXTHEAD"
 .word __EXT_SIZE__ + 2

.segment "CODE"
.a8
.i8
FarWaitBlank:
 jsr _WaitBlank
 rtl
FarCapture:
 jsr _Capture
 rtl
FarProgress:
 jsr _progress_width
 rtl

_MapLayer:
 jsl $7E0000+FarMapLayer
 rts
_MapTiles:
 jsl $7E0000+FarMapTiles
 rts
_MapCells:
 jsl $7E0000+FarMapCells
 rts
_MapColors:
 jsl $7E0000+FarMapColors
 rts
_MapScroll:
 jsl $7E0000+FarMapScroll
 rts
_MapGlide:
 jsl $7E0000+FarMapGlide
 rts

; character mode's (char.s)
_CharLayer:
 jsl $7E0000+FarCharLayer
 rts
_CharRows:
 jsl $7E0000+FarCharRows
 rts
_CharScroll:
 jsl $7E0000+FarCharScroll
 rts
_CharColors:
 jsl $7E0000+FarCharColors
 rts
_CharCursor:
 jsl $7E0000+FarCharCursor
 rts

; PresentOverlay's row ($1120) done: whether it has the bars, a box or the OSK, which hi-res can't show
MapRow:
 ldx $1120
 lda _ui_right
 ora _ui_right+1
 beq @set
 lda #1
@set:
 sta ui_rows,x
 lda _map_mode
 and #HIRES
 beq @done
 jsl $7E0000+FarRegions
@done:
 rts
