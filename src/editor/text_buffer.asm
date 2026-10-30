;Gap buffer stored in SRAM banks 0-2. Positions are logical (gap excluded),
;physical offsets include the gap. The gap is always zeroed and text never
;contains 0, so the buffer can be recovered from SRAM without metadata:
;text before the gap, zeros, text after the gap up to TB_SIZE.
;
;C functions (src/editor/editor.h)
;   tb_Load                     recovers buffer from SRAM, clears it if the signature is missing
;   tb_Clear
;   tb_Length                   returns length in bc
;   tb_GetChar                  de = pos, returns char in a
;   tb_Insert                   de = pos, a = char, returns a = 0 if buffer is full
;   tb_Delete                   de = pos, returns deleted char in a (0 = nothing deleted)
;   tb_Normalize                moves gap to the end so SRAM reads as plain text
;   tb_RowStart                 de = pos, returns start of the visual row containing pos in bc
;   tb_NextRow                  de = row start, returns start of the next visual row in bc
;   tb_Render                   de = top, draws TB_ROWS rows to tile_buffer, finds tb_find

MACRO SRAM_ON
  ld a, CART_SRAM_ENABLE
  ld [rRAMG], a
ENDM

MACRO SRAM_OFF
  xor a
  ld [rRAMG], a
ENDM

MACRO LD_HL_VAR ;\1 = address of little endian word
  ld a, [\1]
  ld l, a
  ld a, [\1+1]
  ld h, a
ENDM

MACRO ST_HL_VAR ;\1 = address of little endian word
  ld a, l
  ld [\1], a
  ld a, h
  ld [\1+1], a
ENDM

MACRO ST_DE_VAR ;\1 = address of little endian word
  ld a, e
  ld [\1], a
  ld a, d
  ld [\1+1], a
ENDM

SECTION "Text Buffer Vars", WRAM0
tb_gap_start: DW
tb_gap_end: DW
tb_len: DW
tb_row_start: DW
tb_row_ptr: DW;0 = don't draw
tb_row: DB
tb_char: DB
_tb_find:: DW;position to find while scanning rows
_tb_found_col:: DB;$FF = not found
_tb_found_row:: DB;$FF = not found
_tb_bottom:: DW;start of the row after the last rendered row

SECTION "Text Buffer Code", ROM0

TBSignature: DB "TXT1"

_tb_Load::
  SRAM_ON
  SWITCH_RAM_MBC5 MAIN_SRAM_BANK
  ld hl, sram_tb_signature
  ld de, TBSignature
  ld b, 4
.checkSignature
    ld a, [de]
    cp a, [hl]
    jr nz, .clear
    inc de
    inc hl
    dec b
    jr nz, .checkSignature

.findGapStart;first 0
  ld de, 0
.gapStartLoop
    ld h, d
    ld l, e
    call TBPhysAddr
    ld a, [hl]
    and a
    jr z, .foundGapStart
    inc de
    ld a, d
    cp a, HIGH(TB_SIZE)
    jr nz, .gapStartLoop
.foundGapStart
  ST_DE_VAR tb_gap_start

.findGapEnd;first non 0 after gap start
    ld a, d
    cp a, HIGH(TB_SIZE)
    jr z, .foundGapEnd
    ld h, d
    ld l, e
    call TBPhysAddr
    ld a, [hl]
    and a
    jr nz, .foundGapEnd
    inc de
    jr .findGapEnd
.foundGapEnd
  ST_DE_VAR tb_gap_end
  SRAM_OFF
  ret

.clear
  SWITCH_RAM_MBC5 MAIN_SRAM_BANK
  ld hl, TBSignature
  ld de, sram_tb_signature
  ld bc, 4
  call mem_Copy
  ;fall through

_tb_Clear::
  SRAM_ON
  xor a
.clearBankLoop
    push af;bank
    ld [rRAMB], a
    xor a
    ld hl, _SRAM
    ld bc, $2000
    call mem_Set
    pop af;bank
    inc a
    cp a, HIGH(TB_SIZE)/$20
    jr nz, .clearBankLoop
  ld hl, 0
  ST_HL_VAR tb_gap_start
  ld hl, TB_SIZE
  ST_HL_VAR tb_gap_end
  SRAM_OFF
  ret

;hl = physical offset, selects SRAM bank, returns SRAM address in hl, only affects a
TBPhysAddr:
  ld a, h
  swap a
  rrca;bank = h >> 5
  and a, %00000111
  ld [rRAMB], a
  ld a, h
  and a, %00011111
  or a, HIGH(_SRAM)
  ld h, a
  ret

;returns gap length in bc, only affects a
TBGapLength:
  ld a, [tb_gap_start]
  ld c, a
  ld a, [tb_gap_end]
  sub a, c
  ld c, a
  ld a, [tb_gap_start+1]
  ld b, a
  ld a, [tb_gap_end+1]
  sbc a, b
  ld b, a
  ret

;returns length in hl, affects a, bc
TBLength:
  call TBGapLength
  ld hl, TB_SIZE
  ld a, l
  sub a, c
  ld l, a
  ld a, h
  sbc a, b
  ld h, a
  ret

_tb_Length::;returns length in bc
  call TBLength
  ld b, h
  ld c, l
  ret

;de = logical position, returns physical offset in hl, affects a, bc
TBLogToPhys:
  ld h, d
  ld l, e
  ld a, [tb_gap_start]
  ld c, a
  ld a, [tb_gap_start+1]
  ld b, a;bc = gap start
  ld a, e
  sub a, c
  ld a, d
  sbc a, b
  ret c;before gap
  call TBGapLength
  add hl, bc
  ret

;de = logical position, selects bank, returns SRAM address in hl, affects a, bc
TBReadSeek:
  call TBLogToPhys
  jp TBPhysAddr

;hl = SRAM address, de = logical position, returns char in a, advances hl and de, affects bc
TBReadNext:
  ld a, [hli]
  inc de
  push af;char
  ld a, h
  cp a, HIGH(_SRAM)+$20
  jr z, .seek;crossed into next bank
  ld a, [tb_gap_start]
  cp a, e
  jr nz, .done
  ld a, [tb_gap_start+1]
  cp a, d
  jr nz, .done
.seek;at gap start or bank end
  call TBReadSeek
.done
  pop af;char
  ret

_tb_GetChar::;de = pos, returns char in a
  SRAM_ON
  call TBReadSeek
  ld b, [hl]
  SRAM_OFF
  ld a, b
  ret

;de = logical position, moves gap start to de, preserves de
TBMoveGap:
  LD_HL_VAR tb_gap_start
  ld a, e
  sub a, l
  ld c, a
  ld a, d
  sbc a, h
  ld b, a;bc = de - gap start
  jr c, .moveLeft
  or a, c
  ret z

.moveRight;move bc bytes from after the gap to before it
    push bc;count
    LD_HL_VAR tb_gap_end
    push hl
    inc hl
    ST_HL_VAR tb_gap_end
    pop hl
    call TBPhysAddr
    ld b, [hl]
    ld [hl], 0
    LD_HL_VAR tb_gap_start
    push hl
    inc hl
    ST_HL_VAR tb_gap_start
    pop hl
    call TBPhysAddr
    ld [hl], b
    pop bc;count
    dec bc
    ld a, b
    or a, c
    jr nz, .moveRight
  ret

.moveLeft;move -bc bytes from before the gap to after it
  ld a, c
  cpl
  ld c, a
  ld a, b
  cpl
  ld b, a
  inc bc;bc = gap start - de
.moveLeftLoop
    push bc;count
    LD_HL_VAR tb_gap_start
    dec hl
    ST_HL_VAR tb_gap_start
    call TBPhysAddr
    ld b, [hl]
    ld [hl], 0
    LD_HL_VAR tb_gap_end
    dec hl
    ST_HL_VAR tb_gap_end
    call TBPhysAddr
    ld [hl], b
    pop bc;count
    dec bc
    ld a, b
    or a, c
    jr nz, .moveLeftLoop
  ret

_tb_Insert::;de = pos, a = char, returns a = 0 if buffer is full
  ld b, a
  push bc;char
  SRAM_ON
  call TBMoveGap
  call TBGapLength
  ld a, b
  or a, c
  pop bc;char
  jr z, .full
  LD_HL_VAR tb_gap_start
  push hl
  inc hl
  ST_HL_VAR tb_gap_start
  pop hl
  call TBPhysAddr
  ld [hl], b
  ld b, 1
  jr .done
.full
  ld b, 0
.done
  SRAM_OFF
  ld a, b
  ret

_tb_Delete::;de = pos, returns deleted char in a (0 = nothing deleted)
  SRAM_ON
  call TBLength
  ld a, e
  sub a, l
  ld a, d
  sbc a, h
  ld b, 0
  jr nc, .done;pos >= length
  call TBMoveGap
  LD_HL_VAR tb_gap_end
  push hl
  inc hl
  ST_HL_VAR tb_gap_end
  pop hl
  call TBPhysAddr
  ld b, [hl]
  ld [hl], 0
.done
  SRAM_OFF
  ld a, b
  ret

_tb_Normalize::
  SRAM_ON
  call TBLength
  ld d, h
  ld e, l
  call TBMoveGap
  SRAM_OFF
  ret

;de = logical position, returns start of its line in de, affects a, bc, hl
TBLineStart:
.loop
    ld a, d
    or a, e
    ret z
    dec de
    call TBReadSeek
    ld a, [hl]
    cp a, ASCII_LF
    jr nz, .loop
  inc de
  ret

;a = tile, b = column, draws to [tb_row_ptr] unless it's 0, preserves all registers but a
TBDrawChar:
  push hl
  push af
  LD_HL_VAR tb_row_ptr
  ld a, h
  or a, l
  jr z, .skip
  ld a, l
  add a, b
  ld l, a
  ld a, h
  adc a, 0
  ld h, a
  pop af
  ld [hl], a
  pop hl
  ret
.skip
  pop af
  pop hl
  ret

;b = column, sets [_tb_found_col] to b if de = [_tb_find] and it hasn't been found yet
TBCheckFind:
  ld a, [_tb_find]
  cp a, e
  ret nz
  ld a, [_tb_find+1]
  cp a, d
  ret nz
  ld a, [_tb_found_col]
  inc a
  ret nz;already found
  ld a, b
  ld [_tb_found_col], a
  ret

;returns z if de = [tb_len]
TBCheckEnd:
  ld a, [tb_len]
  cp a, e
  ret nz
  ld a, [tb_len+1]
  cp a, d
  ret

;Scans one visual row. Rows are up to TB_COLS characters, end after a line feed,
;and wrap after the last space when a word doesn't fit. Spaces and a line feed
;after a full row hang off the end of it (found at column TB_COLS).
;de = row start, [tb_len] = length, returns next row start in de
;sets [_tb_found_col] if [_tb_find] is in the row and [_tb_found_col] is $FF
TBScanRow:
  ST_DE_VAR tb_row_start
  call TBReadSeek
  ld b, 0;column
  ld c, 0;column after last space
.loop
    ld a, b
    cp a, TB_COLS
    jr z, .full
    call TBCheckFind
    call TBCheckEnd
    ret z;end of text
    push bc
    call TBReadNext
    pop bc
    cp a, ASCII_LF
    ret z
    ld [tb_char], a
    cp a, ' '
    jr nc, .draw
    ld a, ' ';control characters are drawn as spaces
  .draw
    call TBDrawChar
    inc b
    ld a, [tb_char]
    cp a, ' '
    jr nz, .loop
    ld c, b
    jr .loop

.full
    call TBCheckEnd
    ret z;end of text
    ld a, [hl];next char
    cp a, ' '
    jr z, .hang
    cp a, ASCII_LF
    jr nz, .checkWrap
  .hang
    push af
    call TBCheckFind
    push bc
    call TBReadNext
    pop bc
    pop af
    cp a, ASCII_LF
    ret z
    ld c, TB_COLS;row ends with a space, no word to wrap
    jr .full

.checkWrap
  ld a, c
  and a
  ret z;no spaces, wrap mid word
  cp a, TB_COLS
  ret z;row ends with a space

.wrapWord;next row starts after the last space
  LD_HL_VAR tb_row_start
  ld d, 0
  ld e, c
  add hl, de
  ld d, h
  ld e, l
  ld b, c
.clearWord
    ld a, ' '
    call TBDrawChar
    inc b
    ld a, b
    cp a, TB_COLS
    jr nz, .clearWord
.checkFindAfterWrap;if find was in the wrapped word, find it on the next row
  ld a, [_tb_find]
  sub a, e
  ld a, [_tb_find+1]
  sbc a, d
  ret c
  ld a, $FF
  ld [_tb_found_col], a
  ret

;de = pos, sets up tb_len and tb_find for scanning rows
TBStartScan:
  ST_DE_VAR _tb_find
  call TBLength
  ST_HL_VAR tb_len
  xor a
  ld [tb_row_ptr], a
  ld [tb_row_ptr+1], a
  ret

_tb_RowStart::;de = pos, returns start of the visual row containing pos in bc
  SRAM_ON
  call TBStartScan
  call TBLineStart
.loop
    push de;row start
    ld a, $FF
    ld [_tb_found_col], a
    call TBScanRow
    pop bc;row start
    ld a, [_tb_found_col]
    inc a
    jr nz, .done
    ld a, c
    cp a, e
    jr nz, .loop
    ld a, b
    cp a, d
    jr nz, .loop;no progress, pos is past the end
.done
  SRAM_OFF
  ret

_tb_NextRow::;de = row start, returns start of the next visual row in bc
  SRAM_ON
  push de
  ld de, $FFFF
  call TBStartScan
  pop de
  call TBScanRow
  ld b, d
  ld c, e
  SRAM_OFF
  ret

_tb_Render::;de = top, draws TB_ROWS rows into tile_buffer, sets _tb_found_col/row for [_tb_find] and _tb_bottom
  SRAM_ON
  push de
  call TBLength
  ST_HL_VAR tb_len
  ld a, ' '
  ld hl, tile_buffer
  ld bc, TB_COLS*TB_ROWS
  call mem_Set
  pop de
  ld a, $FF
  ld [_tb_found_col], a
  ld [_tb_found_row], a
  ld hl, tile_buffer
  ST_HL_VAR tb_row_ptr
  xor a
.rowLoop
    ld [tb_row], a
    call TBScanRow
    ld a, [_tb_found_col]
    inc a
    jr z, .nextRow
    ld a, [_tb_found_row]
    inc a
    jr nz, .nextRow
    ld a, [tb_row]
    ld [_tb_found_row], a
  .nextRow
    LD_HL_VAR tb_row_ptr
    ld bc, TB_COLS
    add hl, bc
    ST_HL_VAR tb_row_ptr
    ld a, [tb_row]
    inc a
    cp a, TB_ROWS
    jr c, .rowLoop
  ST_DE_VAR _tb_bottom
  SRAM_OFF
  ret
