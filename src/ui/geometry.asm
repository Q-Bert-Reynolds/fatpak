; Logical geometry is independent of the LCD's fixed tile dimensions.
SECTION "Geometry Vars", WRAM0
_screen_rows:: DB
_screen_width:: DB
_screen_stride:: DB
_screen_header:: DB
_screen_offsets:: DW
_tile_attrs:: DW
screen_attr_delta:: DW
screen_scratch:: DW
screen_chunk:: DW

SECTION "Row stage vars", WRAMX;WRAM0 is full (not HRAM: its top isn't free)
screen_psram:: DB;wide (SGB fullscreen) rows are in PSRAM (SGB_ROWS_BLOCK), staged one at a time
_screen_cells:: DB;512x448 character text (SGB fullscreen, RESOLUTION 512x448 and 8X8 TILES): 56 rows, 4 px a column
_cells_held:: DB;a module's map is open: 512x448 text gave way to 256x224's (src/sgb/client.c)
_cells_map:: DB;_SGBCellsMap's A
staged_row: DB;the row wide_staging holds, $FF none
staged_dirty: DB;and it may have been written: it goes back to PSRAM before another row is staged
row_write: DB;RowStage's caller may write the row
row_touched: DS MAX_SCREEN_ROWS/8;a bit a row: written since the fullscreen client hashed it (RowHashCached)

FIXED "Geometry dispatch"
_GeometryGB::
  call FarCallInline
  DB BANK(GeometryGB)
  DW GeometryGB
_GeometryWide::
  call FarCallInline
  DB BANK(GeometryWide)
  DW GeometryWide
_SGBCellsMap::;A = a map opens (1) or the text is back (0): the fullscreen client's (FsBackground)
  ld [_cells_map], a
  call FarCallInline
  DB BANK(_SGBCellsMapC)
  DW _SGBCellsMapC
_SGBText::;A = TEXT's mode: the fullscreen client sends it (the extension before 1) and every row again
  jp _RenderOverlayStart+21
_RowsClear::
  jp RowsClear
DEF GEOMETRY_PAGE EQU 6
PAGE GEOMETRY_PAGE
GeometryGB:
  xor a
  ld [screen_psram], a
  ld [_screen_cells], a
  ld a, TB_ROWS
  ld [_screen_rows], a
  ld a, TB_WIDTH
  ld [_screen_width], a
  ld a, TB_ROWS
  ld [_screen_header], a
  ld hl, gb_row_offsets
  ld de, tile_attrs
  ld bc, win_buffer
  ld a, TB_STRIDE
  call GeometrySet
  ld hl, 256
  jr GeometryChunk
GeometryWide:;256x224's 28 rows of 248 pixels, or 512x448's 56 of 62 4-pixel columns (the settings')
  xor a
  ld [_render_gbc], a
  ld a, [_resolution];(whatever the font: 512x448 text is the mono font's characters)
  cp RESOLUTION_512
  jr nz, .cells
  ld a, [_cells_held]
  xor 1
.cells
  ld [_screen_cells], a
  and a;(248 pixels in either: the cursor's sprite x, 8 on, fits a byte)
  ld a, WIDE_ROWS
  jr z, .size
  ld a, MAX_SCREEN_ROWS
.size
  ld [_screen_rows], a
  sub 2
  ld [_screen_header], a
  ld a, 248
  ld [_screen_width], a
  ld hl, wide_row_offsets
  ld de, tile_buffer+MAX_ROW_STRIDE
  ld bc, wide_scratch
  ld a, MAX_ROW_STRIDE
  call GeometrySet
  ld a, 1;rows in PSRAM: every row is the staging row (RowStage), its styles 64 bytes on
  ld [screen_psram], a
  ld a, $FF
  ld [staged_row], a
  xor a
  ld [staged_dirty], a
  call RowsTouchAll;(the hash block's from another session)
  ld hl, tile_buffer+MAX_ROW_STRIDE
  ld a, l
  ld [_tile_attrs], a
  ld a, h
  ld [_tile_attrs+1], a
  ld a, MAX_ROW_STRIDE
  ld [screen_attr_delta], a
  xor a
  ld [screen_attr_delta+1], a
  ld hl, 32
GeometryChunk:
  ST_HL_VAR screen_chunk
  ret
GeometrySet:
  ld [_screen_stride], a
  ST_HL_VAR _screen_offsets
  ST_DE_VAR _tile_attrs
  ld a, e
  ld [screen_attr_delta], a
  ld a, d
  sub HIGH(tile_buffer)
  ld [screen_attr_delta+1], a
  ld a, c
  ld [screen_scratch], a
  ld a, b
  ld [screen_scratch+1], a
  ld a, [_screen_stride]
  ld e, a
  ld d, 0
  ld bc, 0
  ld a, 32
.offset
  ld [hl], c
  inc hl
  ld [hl], b
  inc hl
  push hl
  ld h, b
  ld l, c
  add hl, de
  ld b, h
  ld c, l
  pop hl
  dec a
  jr nz, .offset
  ret

END_PAGE
SECTION FRAGMENT "Row address", ROM0;(not FIXED: bank 1 is full)
; A=row -> HL=byte offset, preserves BC; DE/A destroyed. Includes the
; one-past-end offset used by range clearing and scrolling.
RenderRowAddress::
  ld l, a
  ld a, [screen_psram]
  and a
  jr nz, RowStageWrite
  ld a, l
  ld h, 0
  add hl, hl
  LD_DE_VAR _screen_offsets
  add hl, de
  ld a, [hli]
  ld h, [hl]
  ld l, a
  ret
_RowAddress::
  call RenderRowAddress
  ld de, tile_buffer
  jr GeometryAddress
_AttrAddress::
  call RenderRowAddress
  LD_DE_VAR _tile_attrs
GeometryAddress:
  add hl, de
  ld b, h
  ld c, l
  ret

; Wide rows in PSRAM: row A in wide_staging, HL its offset from tile_buffer (RenderRowAddress's), BC kept.
; The row staged before goes back to PSRAM first if it may have been written. Every access restores the
; window, but RenderRowRead's: a row for reading only (the fullscreen client's FsDraw, which puts the window
; and its config back after its rows) is read where it is, the window on it, unless it's the staged row
; (whose copy is newer). HL is then the window's address less tile_buffer
RenderRowRead::
  ld l, a
  ld a, [screen_psram]
  and a
  ld a, l
  jp z, RenderRowAddress
  ld a, [staged_row]
  cp l
  ld a, 0
  jr z, RowStage
  ld a, [EDX_CONFIG];the window on PSRAM, not save RAM
  and ~2
  ld [EDX_CONFIG], a
  ld a, l
  call RowWindow
  ld a, l
  sub LOW(tile_buffer)
  ld l, a
  ld a, h
  sbc HIGH(tile_buffer)
  ld h, a
  ret
RowStageWrite:
  ld a, 1
RowStage:;l = the row, a = row_write
  ld [row_write], a
  ld a, [staged_row]
  cp l
  jr z, .staged
  push bc
  push hl
  ld a, [EDX_CONFIG];the window on PSRAM, not save RAM
  push af
  and ~2
  ld [EDX_CONFIG], a
  ld a, [EDX_BLOCK]
  ld c, a
  ld a, [EDX_BLOCK+1]
  ld b, a
  push bc
  ld a, [staged_dirty]
  and a
  jr z, .fetch
  ld a, [staged_row]
  push af
  call RowTouch;(again: it may have been hashed, then written, while it was staged)
  pop af
  call RowWindow
  ld d, h
  ld e, l
  ld hl, wide_staging
  call RowCopy
.fetch
  pop bc
  pop af
  pop hl
  push af
  push bc
  ld a, l
  ld [staged_row], a
  call RowWindow
  ld de, wide_staging
  call RowCopy
  pop de
  call _SetWindowBlock
  pop af
  ld [EDX_CONFIG], a
  pop bc
  xor a
  ld [staged_dirty], a
.staged
  ld a, [row_write]
  and a
  jr z, .read
  ld [staged_dirty], a
  ld a, [staged_row]
  call RowTouch
.read
  ld hl, wide_staging-tile_buffer
  ret

; The fullscreen client's content hash of each wide row (FsEncodeRow), kept in SGB_HASH_BLOCK until the
; row is written: hashing all 56 rows cost 5 frames a draw at 512x448 (2026-11-25). Every row written
; is given out by RowStage (or moved by RowsShift, or cleared by RowsClear), which mark it in row_touched.
; A = row -> carry if it must be hashed, else DE = its hash. The window is left where it was, its config
; on PSRAM (FsDraw puts it back)
RowHashCached::
  ld e, a
  ld a, [staged_row];(the staged row may still be written, through the pointer its caller kept)
  cp e
  jr nz, .bit
  ld a, [staged_dirty]
  and a
  scf
  ret nz
.bit
  ld a, e
  call RowBit
  and [hl]
  scf
  ret nz
  ld a, e
  call RowHashWindow
  ld a, [hli]
  ld e, a
  ld d, [hl]
  call RowWindowBack
  and a
  ret
; A = row, DE = its hash (kept): stored, and the row unmarked
RowHashStore::
  push af
  call RowBit
  cpl
  and [hl]
  ld [hl], a
  pop af
  call RowHashWindow
  ld a, e
  ld [hli], a
  ld [hl], d
RowWindowBack:;bc = the block the window showed
  ld a, b
  ld [EDX_BLOCK+1], a
  ld a, c
  ld [EDX_BLOCK], a
  ret
RowHashWindow:;a = row -> hl = its hash, the window on SGB_HASH_BLOCK; bc = the block it showed
  add a
  ld l, a
  ld h, HIGH(TB_BASE)
  ld a, [EDX_CONFIG]
  and ~2
  ld [EDX_CONFIG], a
  ld a, [EDX_BLOCK]
  ld c, a
  ld a, [EDX_BLOCK+1]
  ld b, a
  ld a, HIGH(SGB_HASH_BLOCK)
  ld [EDX_BLOCK+1], a
  ld a, LOW(SGB_HASH_BLOCK)
  ld [EDX_BLOCK], a
  ret
RowBit:;a = row -> hl = its byte in row_touched, a = its bit; keeps bc and de
  push bc
  ld b, a
  rrca
  rrca
  rrca
  and $1F
  add LOW(row_touched)
  ld l, a
  adc HIGH(row_touched)
  sub l
  ld h, a
  ld a, b
  and 7
  ld b, a
  ld a, 1
  jr z, .bit
.shift
  add a
  dec b
  jr nz, .shift
.bit
  pop bc
  ret
RowTouch:;a = row, keeps bc
  call RowBit
  or [hl]
  ld [hl], a
  ret
RowsTouchAll::
  ld hl, row_touched
  ld a, $FF
REPT MAX_SCREEN_ROWS/8
  ld [hli], a
ENDR
  ret
ASSERT MAX_SCREEN_ROWS % 8 == 0 && LOW(TB_BASE) == 0
ASSERT SGB_ROWS_BLOCK + SGB_ROWS_BLOCKS <= SGB_HASH_BLOCK && SGB_HASH_BLOCK < $3C00
RowCopy:;hl to de, a row's 128 bytes
  ld b, MAX_ROW_STRIDE*2
.copy
  ld a, [hli]
  ld [de], a
  inc de
  dec b
  jr nz, .copy
  ret
RowWindow:;a = row: the window shows its block, hl = its 128 bytes there
  ld e, a
  srl a
  srl a
  add LOW(SGB_ROWS_BLOCK)
  ld l, a
  ld a, HIGH(SGB_ROWS_BLOCK)
  ld [EDX_BLOCK+1], a
  ld a, l
  ld [EDX_BLOCK], a
  ld a, e
  and 2
  rrca
  add HIGH(TB_BASE)
  ld h, a
  ld a, e
  rrca
  and $80
  ld l, a
  ret

; the PSRAM rows blank: spaces, style 4 (plain, 4 px: as the fullscreen client clears them)
RowsClear::
  ld hl, wide_staging
  ld b, MAX_ROW_STRIDE
  ld a, ' '
.chars
  ld [hli], a
  dec b
  jr nz, .chars
  ld b, MAX_ROW_STRIDE
  ld a, 4
.attrs
  ld [hli], a
  dec b
  jr nz, .attrs
  ld a, [EDX_BLOCK]
  ld c, a
  ld a, [EDX_BLOCK+1]
  ld b, a
  push bc
  xor a
.row
  push af
  call RowWindow
  ld d, h
  ld e, l
  ld hl, wide_staging
  call RowCopy
  pop af
  inc a
  cp SGB_ROWS_BLOCKS*4
  jr nz, .row
  pop de
  call _SetWindowBlock
  ld a, $FF
  ld [staged_row], a
  xor a
  ld [staged_dirty], a
  jp RowsTouchAll

; tb_ScrollRows' rows: a = 1 moves rows 1 to [_tb_rows] - 1 up a row, 0 moves rows 0 to [_tb_rows] - 2
; down. Wide PSRAM rows move through the staging row: each is staged, then named the row it moves
; to and left dirty, to go back there. Returns carry if it moved them (else tile_buffer's are moved)
RowsShift::
  ld b, a
  ld a, [screen_psram]
  and a
  ret z
  ld a, [_tb_rows]
  dec a
  ld c, a;rows to move
  ret z
  ld a, b
  and a
  ld a, 1;up: row 1 to 0, 2 to 1, ...
  ld b, 1
  jr nz, .move
  ld a, [_tb_rows]
  sub 2;down: rows - 2 to rows - 1, ...
  ld b, $FF
.move
  push af
  push bc
  ld l, a
  call RowStageWrite
  pop bc
  pop af
  push af
  sub b
  ld [staged_row], a
  call RowTouch;(the row it moves to: its cached hash is what it held before)
  ld a, 1
  ld [staged_dirty], a
  pop af
  add a, b
  dec c
  jr nz, .move
  scf
  ret

FIXED "Draw row dispatch"
_DrawRow::
  call FarCallInline
  DB BANK(DrawRow)
  DW DrawRow
PAGE GEOMETRY_PAGE
; SDCC: row=A, column=E, text on stack; callee removes the text pointer.
DrawRow:
  push af
  push de
  call RenderRowAddress
  ld de, tile_buffer
  add hl, de
  push hl
  ld a, [_screen_stride]
  ld c, a
  ld b, 0
  ld a, ' '
  call mem_Set
  pop hl
  pop de
  push hl
  ld a, [_screen_stride]
  sub e
  jr c, .done
  jr z, .done
  ld b, a
  ld d, 0
  add hl, de
  ld d, h
  ld e, l
  ld hl, sp+6
  ld a, [hli]
  ld h, [hl]
  ld l, a
.copy
  ld a, [hli]
  and a
  jr z, .done
  ld [de], a
  inc de
  dec b
  jr nz, .copy
.done
  pop de
  pop af
  ld b, a
  ld a, [_screen_header]
  inc a
  cp b
  call z, _FooterCompose
  pop hl
  inc sp
  inc sp
  jp hl

END_PAGE

; Menu lines live in protected PSRAM in wide mode, rather than aliasing visible
; text rows. Only one line is staged at a time; every access restores the window.
FIXED "Box row storage"
_BoxLine:: ; A=line -> BC/HL=20-byte editable line; call BoxCommit after writing
  push af
  ld a, [_screen_rows]
  cp TB_ROWS
  jr z, .gb
  pop af
  call BoxMap
  push de
  ld de, wide_scratch
  ld b, BOX_STRIDE
.read
  ld a, [hli]
  ld [de], a
  inc de
  dec b
  jr nz, .read
  pop de
  call _SetWindowBlock
  ld hl, wide_scratch
  ld bc, wide_scratch
  ret
.gb
  pop af
  call BoxOffset
  ld de, tile_buffer+(TB_ROWS+2)*TB_STRIDE
  add hl, de
  ld b, h
  ld c, l
  ret
_BoxCommit:: ; A=line, wide_scratch contains the complete fixed-stride line
  push af
  ld a, [_screen_rows]
  cp TB_ROWS
  jr nz, .wide
  pop af
  ret
.wide
  pop af
  call BoxMap
  push de
  ld de, wide_scratch
  ld b, BOX_STRIDE
.write
  ld a, [de]
  inc de
  ld [hli], a
  dec b
  jr nz, .write
  dec hl
  ld [hl], 0 ; strings cannot cross their fixed stride
  pop de
  jp _SetWindowBlock
BoxOffset:
  cp 19
  jr c, .bounded
  ld a, 18
.bounded
  ld l, a
  ld h, 0
  add hl, hl
  add hl, hl
  ld d, h
  ld e, l
  add hl, hl
  add hl, hl
  add hl, de
  ret
BoxMap:
  call BoxOffset
  ld a, [EDX_BLOCK]
  ld c, a
  ld a, [EDX_BLOCK+1]
  ld b, a
  ld de, SGB_BOX_BLOCK
  call _SetWindowBlock
  ld de, TB_BASE
  add hl, de
  ld d, b
  ld e, c
  ret

; tb_RenderRows' rows [tb_row, tb_end) blank before they're drawn, or (wide PSRAM rows) none: RowBegin
; stages and blanks each as it starts
FIXED "Row blanking"
RowsBlank::
  ld a, [screen_psram]
  and a
  ret nz
  ld a, [tb_row]
  call RenderRowAddress
  ld de, tile_buffer
  add hl, de
  push hl
  ld a, [tb_row]
  ld b, a
  ld a, [tb_end]
  sub a, b
  call RenderRowAddress
  ld b, h
  ld c, l;rows * screen_stride
  pop hl
  push hl
  push bc
  ld a, ' '
  call mem_Set
  pop bc
  pop hl
  LD_DE_VAR screen_attr_delta
  add hl, de
  xor a
  jp mem_Set
RowBegin::;keeps BC and DE (the text's place)
  ld a, [screen_psram]
  and a
  ret z
  push bc
  push de
  ld a, [tb_row]
  call RenderRowAddress
  ld de, tile_buffer
  add hl, de
  ST_HL_VAR tb_row_ptr
  ld b, MAX_ROW_STRIDE
  ld a, ' '
.chars
  ld [hli], a
  dec b
  jr nz, .chars
  ld b, MAX_ROW_STRIDE
  xor a
.attrs
  ld [hli], a
  dec b
  jr nz, .attrs
  pop de
  pop bc
  ret
