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

FIXED "Geometry dispatch"
_GeometryGB::
  call FarCallInline
  DB BANK(GeometryGB)
  DW GeometryGB
_GeometryWide::
  call FarCallInline
  DB BANK(GeometryWide)
  DW GeometryWide
DEF GEOMETRY_PAGE EQU 6
PAGE GEOMETRY_PAGE
GeometryGB:
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
GeometryWide:
  xor a
  ld [_render_gbc], a
  ld a, MAX_SCREEN_ROWS
  ld [_screen_rows], a
  ld a, 248
  ld [_screen_width], a
  ld a, MAX_SCREEN_ROWS-2
  ld [_screen_header], a
  ld hl, wide_row_offsets
  ld de, wide_tile_attrs
  ld bc, wide_scratch
  ld a, MAX_ROW_STRIDE
  call GeometrySet
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
FIXED "Row address"
; A=row -> HL=byte offset, preserves BC; DE/A destroyed. Includes the
; one-past-end offset used by range clearing and scrolling.
RenderRowAddress::
  ld l, a
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
