;Gap buffer stored in SRAM banks 0-7, skipping $BD00-$BD0F in each bank so text
;can never reach the EverDrive registers (writing $A5 to $BD0A unlocks them). Positions are logical (gap excluded),
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
;   tb_NormalizeStep            moves gap up to TB_NORMALIZE_STEP bytes toward the end, returns a = 1 when it's there
;   tb_Append                   de = buffer, bc = count, inserts at the gap dropping 0s and CRs (sets tb_cr if it drops a CR),
;                               returns a = 0 if it filled up
;   tb_Read                     de = buffer, bc = size, copies text from tb_read_pos until the buffer is full or the text ends,
;                               advances it, returns bytes copied in bc
;   tb_ReadLines                de = buffer, bc = size, like tb_Read but line feeds are written as CR LF
;   tb_DeleteRange              de = pos, bc = count, deletes count chars (they must exist)
;   tb_Copy                     de = pos, bc = count, copies text to the clipboard, returns a = 0 if it's too big
;   tb_Paste                    de = pos, inserts the clipboard, returns a = 0 if it doesn't fit
;   tb_ClipLength               returns clipboard length in bc (in SRAM bank 8, see src/sram.asm)
;   tb_CountLines               de = start, bc = end, returns the line feeds in [start, end) in bc
;   tb_LineStart                de = pos, returns the start of its line (after the line feed before it) in bc
;   tb_RowStart                 de = pos, returns start of the visual row containing pos in bc
;   tb_NextRow                  de = row start, returns start of the next visual row in bc
;   tb_Render                   de = top, draws tb_rows rows to tile_buffer, finds tb_find
;   tb_RenderRows               a = first row, e = end row, draws rows from tb_row_starts[first]
;   tb_ScrollRows               a = 1 moves rows up (scroll down), 0 down, shifts tile_buffer and the row tables
;   tb_nowrap, tb_left          rows are whole lines scrolled sideways by tb_left characters (see TBScanRow)

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

MACRO LD_BC_VAR ;\1 = address of little endian word
  ld a, [\1]
  ld c, a
  ld a, [\1+1]
  ld b, a
ENDM

MACRO LD_DE_VAR ;\1 = address of little endian word
  ld a, [\1]
  ld e, a
  ld a, [\1+1]
  ld d, a
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
tb_x: DB
_tb_find:: DW;position to find while scanning rows
_tb_found_col:: DB;$FF = not found
_tb_found_row:: DB;$FF = not found
_tb_bottom:: DW;start of the row after the last rendered row
_tb_rows:: DB;visible rows
_tb_row_starts:: DS (TB_ROWS+1)*2;start of each rendered row, then _tb_bottom
_tb_row_counts:: DS TB_ROWS;characters drawn in each rendered row
tb_row_chars: DB
tb_end: DB
_tb_end_row:: DB;rendered row the end of the text is on, $FF = not on screen
_tb_read_pos:: DW
_tb_nowrap:: DB;lines don't wrap, each row is a line scrolled by _tb_left characters
_tb_left:: DW
_tb_cr:: DB;tb_Append dropped a CR
tb_crlf: DB;tb_ReadLines
tb_dest: DW
tb_count: DW
tb_target: DW
tb_k: DW
tb_src: DW
tb_dst: DW
tb_src_addr: DW
tb_dst_addr: DW
tb_src_bank: DB
tb_dst_bank: DB
tb_clip_left: DW
tb_lines: DW
tb_clip_ptr: DW
tb_find_nonzero: DB;TBFindPhys

SECTION "Text Buffer Code", ROM0

TBSignature: DB "TXT3"

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

  ld de, 0
  xor a
  call TBFindPhys;first 0
  ST_DE_VAR tb_gap_start
  ld a, 1
  call TBFindPhys;first non 0 after gap start
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
.clearBankLoop;everything but the register hole
    push af;bank
    ld [rRAMB], a
    xor a
    ld hl, _SRAM
    ld bc, TB_HOLE
    call mem_Set
    xor a
    ld hl, _SRAM+TB_HOLE+TB_HOLE_SIZE
    ld bc, $2000-TB_HOLE-TB_HOLE_SIZE
    call mem_Set
    pop af;bank
    inc a
    cp a, TB_BANKS
    jr nz, .clearBankLoop
  ld hl, 0
  ST_HL_VAR tb_gap_start
  ld hl, TB_SIZE
  ST_HL_VAR tb_gap_end
  SRAM_OFF
  ret

;returns z if de = TB_SIZE, only affects a
TBCheckSize:
  ld a, e
  cp a, LOW(TB_SIZE)
  ret nz
  ld a, d
  cp a, HIGH(TB_SIZE)
  ret

;hl = physical offset, selects SRAM bank, returns SRAM address in hl, only affects a
TBPhysAddr:
  push bc
  ld bc, -TB_BANK_SIZE
  xor a;bank
.findBank
    add hl, bc
    jr nc, .foundBank
    inc a
    jr .findBank
.foundBank
  ld bc, TB_BANK_SIZE
  add hl, bc;offset in bank
  pop bc
  ld [rRAMB], a
  ld a, h
  cp a, HIGH(TB_HOLE)
  jr c, .setAddress
  ld a, l;skip the register hole
  add a, TB_HOLE_SIZE
  ld l, a
  ld a, h
  adc a, 0
  ld h, a
.setAddress
  ld a, h
  or a, HIGH(_SRAM)
  ld h, a
  ret

;de = physical offset, a = 0 finds the first 0 at or after it, 1 the first non 0, a run at a time,
;returns its offset in de (TB_SIZE if there isn't one), affects a, bc, hl
TBFindPhys:
  ld [tb_find_nonzero], a
.run
    call TBCheckSize
    ret z
    ld h, d
    ld l, e
    push de
    call TBPhysRun
    ld a, b
    ld [rRAMB], a
    ld b, d
    ld c, e;run length
    pop de
    ld a, [tb_find_nonzero]
    and a
    jr nz, .nonZero
.zero
      ld a, [hli]
      and a
      ret z
      inc de
      dec bc
      ld a, b
      or a, c
      jr nz, .zero
    jr .run
.nonZero
      ld a, [hli]
      and a
      ret nz
      inc de
      dec bc
      ld a, b
      or a, c
      jr nz, .nonZero
    jr .run

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
  cp a, HIGH(_SRAM+TB_HOLE)
  jr nz, .checkGap
  ld a, l
  and a
  jr nz, .checkGap
  ld l, TB_HOLE_SIZE;skip the register hole
.checkGap
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

DEF TB_CHUNK EQU 256;bytes moved at a time, through win_buffer when banks differ

;hl = min(hl, de), only affects a
TBMin:
  ld a, l
  sub a, e
  ld a, h
  sbc a, d
  ret c
  ld h, d
  ld l, e
  ret

;hl = min(hl, gap length, TB_CHUNK), affects a, bc, de
TBChunkLimit:
  call TBGapLength
  ld d, b
  ld e, c
  call TBMin
  ld de, TB_CHUNK
  jr TBMin

;hl = physical offset, returns bank in b, SRAM address in hl, bytes until the register hole
;or bank end in de, affects a
TBPhysRun:
  ld b, 0
TBPhysRunFrom:;b = first bank (the undo log starts at UNDO_BANK)
  ld de, -TB_BANK_SIZE
.findBank
    add hl, de
    jr nc, .foundBank
    inc b
    jr .findBank
.foundBank
  ld de, TB_BANK_SIZE
  add hl, de;offset in bank
  ld a, h
  cp a, HIGH(TB_HOLE)
  jr nc, .afterHole
  ld a, LOW(TB_HOLE)
  sub a, l
  ld e, a
  ld a, HIGH(TB_HOLE)
  sbc a, h
  ld d, a
  jr .address
.afterHole
  ld a, LOW(TB_BANK_SIZE)
  sub a, l
  ld e, a
  ld a, HIGH(TB_BANK_SIZE)
  sbc a, h
  ld d, a
  ld a, l
  add a, TB_HOLE_SIZE
  ld l, a
  ld a, h
  adc a, 0
  ld h, a
.address
  ld a, h
  or a, HIGH(_SRAM)
  ld h, a
  ret

;hl = physical offset, returns bytes before it in the same run (bank and side of the hole) in de, affects a, hl
TBRunBack:
  dec hl
  ld de, -TB_BANK_SIZE
.findBank
    add hl, de
    jr c, .findBank
  ld de, TB_BANK_SIZE
  add hl, de;offset in bank
  ld a, h
  cp a, HIGH(TB_HOLE)
  jr c, .beforeHole
  ld de, 1-TB_HOLE
  add hl, de
  ld d, h
  ld e, l
  ret
.beforeHole
  inc hl
  ld d, h
  ld e, l
  ret

;copies [tb_k] bytes from physical [tb_src] to [tb_dst] and zeroes the source, runs don't overlap
TBCopyChunk:
  LD_HL_VAR tb_src
  call TBPhysRun
  ld a, b
  ld [tb_src_bank], a
  ST_HL_VAR tb_src_addr
  LD_HL_VAR tb_dst
  call TBPhysRun
  ld a, b
  ld [tb_dst_bank], a
  ST_HL_VAR tb_dst_addr
  ld a, [tb_src_bank]
  ld [rRAMB], a
  ld hl, tb_dst_bank
  cp a, [hl]
  jr nz, .differentBanks
.sameBank
  LD_HL_VAR tb_dst_addr
  ld d, h
  ld e, l
  LD_HL_VAR tb_src_addr
  LD_BC_VAR tb_k
  call mem_Copy
  jr .zeroSource
.differentBanks
  ld de, win_buffer
  LD_HL_VAR tb_src_addr
  LD_BC_VAR tb_k
  call mem_Copy
  ld a, [tb_dst_bank]
  ld [rRAMB], a
  LD_HL_VAR tb_dst_addr
  ld d, h
  ld e, l
  ld hl, win_buffer
  LD_BC_VAR tb_k
  call mem_Copy
  ld a, [tb_src_bank]
  ld [rRAMB], a
.zeroSource
  LD_HL_VAR tb_src_addr
  LD_BC_VAR tb_k
  xor a
  jp mem_Set

;de = logical position, moves gap start to de, preserves de
TBMoveGap:
  push de
  ST_DE_VAR tb_target
  call TBGapLength
  ld a, b
  or a, c
  jr nz, .loop
  ST_DE_VAR tb_gap_start;no gap, nothing to move
  ST_DE_VAR tb_gap_end
  pop de
  ret

.loop
    LD_HL_VAR tb_gap_start
    ld a, [tb_target]
    sub a, l
    ld c, a
    ld a, [tb_target+1]
    sbc a, h
    ld b, a;bc = target - gap start
    jp c, .left
    or a, c
    jp z, .done

  .right;move text after the gap to before it
    ld h, b
    ld l, c
    call TBChunkLimit
    push hl
    LD_HL_VAR tb_gap_end
    call TBPhysRun
    pop hl
    call TBMin
    push hl
    LD_HL_VAR tb_gap_start
    call TBPhysRun
    pop hl
    call TBMin
    ST_HL_VAR tb_k
    LD_HL_VAR tb_gap_end
    ST_HL_VAR tb_src
    LD_HL_VAR tb_gap_start
    ST_HL_VAR tb_dst
    call TBCopyChunk
    LD_DE_VAR tb_k
    LD_HL_VAR tb_gap_start
    add hl, de
    ST_HL_VAR tb_gap_start
    LD_HL_VAR tb_gap_end
    add hl, de
    ST_HL_VAR tb_gap_end
    jp .loop

  .left;move text before the gap to after it
    ld a, c
    cpl
    ld l, a
    ld a, b
    cpl
    ld h, a
    inc hl;gap start - target
    call TBChunkLimit
    push hl
    LD_HL_VAR tb_gap_start
    call TBRunBack
    pop hl
    call TBMin
    push hl
    LD_HL_VAR tb_gap_end
    call TBRunBack
    pop hl
    call TBMin
    ST_HL_VAR tb_k
    ld d, h
    ld e, l
    LD_HL_VAR tb_gap_start
    ld a, l
    sub a, e
    ld l, a
    ld a, h
    sbc a, d
    ld h, a
    ST_HL_VAR tb_gap_start
    ST_HL_VAR tb_src
    LD_HL_VAR tb_gap_end
    ld a, l
    sub a, e
    ld l, a
    ld a, h
    sbc a, d
    ld h, a
    ST_HL_VAR tb_gap_end
    ST_HL_VAR tb_dst
    call TBCopyChunk
    jp .loop

.done
  pop de
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

_tb_Append::;de = buffer, bc = count, inserts at the gap dropping 0s and CRs (sets tb_cr if it drops a CR), returns a = 0 if it filled up
  SRAM_ON
  ST_DE_VAR tb_dest;source
  ld a, c
  ld [tb_count], a
  ld a, b
  ld [tb_count+1], a;source bytes left
.run;as much as fits in the gap's run before the register hole or the bank end
    LD_HL_VAR tb_count
    ld a, h
    or a, l
    jp z, .done
    call TBGapLength
    ld a, b
    or a, c
    jp z, .gapFull
    ld d, b
    ld e, c
    call TBMin
    push hl
    LD_HL_VAR tb_gap_start
    call TBPhysRun
    ld a, b
    ld [rRAMB], a
    ld b, h
    ld c, l
    pop hl
    call TBMin
    push hl;source bytes this run
    ld h, b
    ld l, c
    pop bc
    push bc
    push hl;run start
    LD_DE_VAR tb_dest
    inc b
    inc c
    jr .next
.byte
      ld a, [de]
      inc de
      and a
      jr z, .next;text never contains 0
      cp a, ASCII_CR
      jr z, .cr
      ld [hli], a
.next
      dec c
      jr nz, .byte
      dec b
      jr nz, .byte
    ST_DE_VAR tb_dest
    pop de;run start
    ld a, l
    sub a, e
    ld e, a
    ld a, h
    sbc a, d
    ld d, a;bytes written
    LD_HL_VAR tb_gap_start
    add hl, de
    ST_HL_VAR tb_gap_start
    pop bc;source bytes this run
    ld hl, tb_count
    ld a, [hl]
    sub a, c
    ld [hli], a
    ld a, [hl]
    sbc a, b
    ld [hl], a
    jp .run
.cr
      ld a, 1
      ld [_tb_cr], a
      jr .next
.gapFull;full unless the rest is 0s and CRs
  LD_DE_VAR tb_dest
  LD_BC_VAR tb_count
.check
    ld a, [de]
    inc de
    and a
    jr z, .checkNext
    cp a, ASCII_CR
    jr nz, .full
    ld a, 1
    ld [_tb_cr], a
.checkNext
    dec bc
    ld a, b
    or a, c
    jr nz, .check
.done
  SRAM_OFF
  ld a, 1
  ret
.full
  SRAM_OFF
  xor a
  ret

_tb_ReadLines::;de = buffer, bc = size, like tb_Read but line feeds are written as CR LF
  ld a, 1
  jr TBRead

_tb_Read::;de = buffer, bc = size, copies text from [_tb_read_pos] until the buffer is full or the text ends, advances it, returns bytes copied in bc
  xor a
TBRead:
  ld [tb_crlf], a
  SRAM_ON
  ST_DE_VAR tb_dest
  ld a, c
  ld [tb_count], a
  ld a, b
  ld [tb_count+1], a;buffer bytes left
  push bc
.run;as much as fits from the text's run before the gap, the register hole or the bank end
    LD_HL_VAR tb_count
    ld a, [tb_crlf]
    and a
    jr z, .fits
    srl h;a char can take 2 bytes
    rr l
.fits
    push hl
    call TBLength
    LD_DE_VAR _tb_read_pos
    ld a, l
    sub a, e
    ld l, a
    ld a, h
    sbc a, d
    ld h, a;chars left
    pop de
    call TBMin
    ld a, h
    or a, l
    jp z, .done
    push hl
    LD_DE_VAR _tb_read_pos
    ld a, [tb_gap_start]
    sub a, e
    ld l, a
    ld a, [tb_gap_start+1]
    sbc a, d
    ld h, a;chars before the gap
    jr c, .afterGap
    or a, l
    jr nz, .beforeGap
.afterGap
    ld hl, $FFFF
.beforeGap
    pop de
    call TBMin
    push hl
    LD_DE_VAR _tb_read_pos
    call TBLogToPhys
    call TBPhysRun
    ld a, b
    ld [rRAMB], a
    ld b, h
    ld c, l
    pop hl
    call TBMin;chars this run
    push hl
    LD_DE_VAR _tb_read_pos
    add hl, de
    ST_HL_VAR _tb_read_pos
    pop de
    ld h, b
    ld l, c
    ld b, d
    ld c, e
    LD_DE_VAR tb_dest
    ld a, [tb_crlf]
    and a
    jr nz, .lines
    call mem_Copy
    jr .copied
.lines
    inc b
    inc c
    jr .next
.byte
      ld a, [hli]
      cp a, ASCII_LF
      jr nz, .char
      ld a, ASCII_CR
      ld [de], a
      inc de
      ld a, ASCII_LF
.char
      ld [de], a
      inc de
.next
      dec c
      jr nz, .byte
      dec b
      jr nz, .byte
.copied
    ld hl, tb_dest
    ld a, e
    sub a, [hl]
    ld c, a
    inc hl
    ld a, d
    sbc a, [hl]
    ld b, a;bytes written
    ST_DE_VAR tb_dest
    ld hl, tb_count
    ld a, [hl]
    sub a, c
    ld [hli], a
    ld a, [hl]
    sbc a, b
    ld [hl], a
    jp .run
.done
  pop hl;size
  ld a, [tb_count]
  ld c, a
  ld a, [tb_count+1]
  ld b, a
  ld a, l
  sub a, c
  ld c, a
  ld a, h
  sbc a, b
  ld b, a
  SRAM_OFF
  ret

DEF TB_NORMALIZE_STEP EQU 512;about half a frame

_tb_NormalizeStep::;moves the gap up to TB_NORMALIZE_STEP bytes toward the end, returns a = 1 when it's there
  SRAM_ON
  call TBLength
  ld d, h
  ld e, l
  LD_HL_VAR tb_gap_start
  ld bc, TB_NORMALIZE_STEP
  add hl, bc
  call TBMin
  ld d, h
  ld e, l
  call TBMoveGap
  call TBLength
  ld a, [tb_gap_start]
  cp a, l
  jr nz, .notDone
  ld a, [tb_gap_start+1]
  cp a, h
  jr nz, .notDone
  SRAM_OFF
  ld a, 1
  ret
.notDone
  SRAM_OFF
  xor a
  ret

_tb_Normalize::
  SRAM_ON
  call TBLength
  ld d, h
  ld e, l
  call TBMoveGap
  SRAM_OFF
  ret

_tb_DeleteRange::;de = pos, bc = count, deletes count chars at pos (they must exist)
  ld a, c
  ld [tb_count], a
  ld a, b
  ld [tb_count+1], a
  or a, c
  ret z
  SRAM_ON
  call TBMoveGap
.loop;zero runs after the gap and grow it over them
    LD_HL_VAR tb_gap_end
    call TBPhysRun
    ld a, b
    ld [rRAMB], a
    push hl
    ld h, d
    ld l, e
    LD_DE_VAR tb_count
    call TBMin
    ld b, h
    ld c, l
    pop hl
    push bc
    xor a
    call mem_Set
    pop bc
    LD_HL_VAR tb_gap_end
    add hl, bc
    ST_HL_VAR tb_gap_end
    ld a, [tb_count]
    sub a, c
    ld [tb_count], a
    ld c, a
    ld a, [tb_count+1]
    sbc a, b
    ld [tb_count+1], a
    or a, c
    jr nz, .loop
  SRAM_OFF
  ret

DEF TB_CLIP_CHUNK EQU 256;bytes copied at a time through win_buffer

_tb_ClipLength::;returns clipboard length in bc, 0 if it's empty or was never set
  SRAM_ON
  ld a, MAIN_SRAM_BANK
  ld [rRAMB], a
  ld hl, sram_clip_length
  ld a, [hli]
  ld c, a
  ld a, [hli]
  ld b, a
  ld a, [hli]
  cpl
  cp a, c
  jr nz, .empty
  ld a, [hl]
  cpl
  cp a, b
  jr z, .done
.empty
  ld bc, 0
.done
  SRAM_OFF
  ret

;returns min([tb_clip_left], TB_CLIP_CHUNK) in bc, z if it's 0, affects a, de, hl
TBClipChunk:
  LD_HL_VAR tb_clip_left
  ld de, TB_CLIP_CHUNK
  call TBMin
  ld b, h
  ld c, l
  ld a, b
  or a, c
  ret

;subtracts bc from [tb_clip_left] and adds it to [tb_clip_ptr], affects a, hl
TBClipAdvance:
  LD_HL_VAR tb_clip_ptr
  add hl, bc
  ST_HL_VAR tb_clip_ptr
  ld a, [tb_clip_left]
  sub a, c
  ld [tb_clip_left], a
  ld a, [tb_clip_left+1]
  sbc a, b
  ld [tb_clip_left+1], a
  ret

_tb_Copy::;de = pos, bc = count, copies text to the clipboard, returns a = 0 if it's too big
  ld a, LOW(TB_CLIP_SIZE)
  sub a, c
  ld a, HIGH(TB_CLIP_SIZE)
  sbc a, b
  jr nc, .fits
  xor a
  ret
.fits
  ST_DE_VAR _tb_read_pos
  ld a, c
  ld [tb_clip_left], a
  ld a, b
  ld [tb_clip_left+1], a
  SRAM_ON
  ld a, MAIN_SRAM_BANK
  ld [rRAMB], a
  ld hl, sram_clip_length
  ld a, c
  ld [hli], a
  ld a, b
  ld [hli], a
  ld a, c
  cpl
  ld [hli], a
  ld a, b
  cpl
  ld [hli], a
  ST_HL_VAR tb_clip_ptr
.loop
    call TBClipChunk
    jr z, .done
    push bc
    ld de, win_buffer
    call _tb_Read
    SRAM_ON
    ld a, MAIN_SRAM_BANK
    ld [rRAMB], a
    pop bc
    push bc
    LD_DE_VAR tb_clip_ptr
    ld hl, win_buffer
    call mem_Copy
    pop bc
    call TBClipAdvance
    jr .loop
.done
  SRAM_OFF
  ld a, 1
  ret

_tb_Paste::;de = pos, inserts the clipboard, returns a = 0 if it doesn't fit (nothing is inserted)
  push de
  call _tb_ClipLength
  ld a, c
  ld [tb_clip_left], a
  ld a, b
  ld [tb_clip_left+1], a
  pop de
  SRAM_ON
  call TBMoveGap
  call TBGapLength
  ld hl, tb_clip_left
  ld a, c
  sub a, [hl]
  inc hl
  ld a, b
  sbc a, [hl]
  jr nc, .fits
  SRAM_OFF
  xor a
  ret
.fits
  ld hl, sram_clip
  ST_HL_VAR tb_clip_ptr
.loop
    call TBClipChunk
    jr z, .done
    push bc
    ld a, MAIN_SRAM_BANK
    ld [rRAMB], a
    LD_HL_VAR tb_clip_ptr
    ld de, win_buffer
    call mem_Copy
    pop bc
    push bc
    ld de, win_buffer
    call _tb_Append
    SRAM_ON
    pop bc
    call TBClipAdvance
    jr .loop
.done
  SRAM_OFF
  ld a, 1
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

;a = tile, b = column, draws it and its style [tb_attr] to [tb_row_ptr] unless it's 0, preserves all registers but a
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
  push de
  ld de, tile_attrs - tile_buffer
  add hl, de
  ld a, [tb_attr]
  ld [hl], a
  pop de
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

;Lexer: styles each character as rows are scanned, so wrapping and drawing use styled widths.
;Its state (tb_state, 2 bytes) is saved at each rendered row's start in tb_row_states, a row
;elsewhere is reached by scanning from its line's start (TBSyncState).
;Markdown: a line starting with 1-6 # and a space is a heading (1-4 use FONT_H1-FONT_H4, 5-6 are bold),
;** toggles bold, * and _ italic (not inside a word), ` code. Markers stay visible.
DEF MD_BOLD       EQU 0;state byte 0
DEF MD_ITALIC     EQU 1
DEF MD_CODE       EQU 2
DEF MD_LINE       EQU 3;nothing of the line seen yet
DEF MD_MARK       EQU 4;the last char was a * or _, the next one decides what it does
DEF MD_STAR       EQU 5;it was a *
DEF MD_PREV_WORD  EQU 6;the last char was a letter or digit
DEF MD_PREV_SPACE EQU 7;the last char was a space, or the line just started
DEF MD_HEADING    EQU %00000111;state byte 1: heading level
DEF MD_MARK_WORD  EQU 3;the char before the marker was a letter or digit
DEF MD_MARK_SPACE EQU 4;it was a space
DEF MD_HASHES     EQU 5;in a heading's #s

;what each style looks like: LOOK_* bits, the GBC accent palette in bits 4-6 (see EditorPalettes)
StyleLooks:
  DB 0;STYLE_TEXT
  DB LOOK_BOLD
  DB LOOK_ITALIC
  DB LOOK_BOLD | LOOK_ITALIC
  DB LOOK_DIM;STYLE_MARK
  DB LOOK_ACCENT | 2 << 4;STYLE_CODE, red
  DB LOOK_ACCENT | 1 << 4;STYLE_HEAD, blue
  DB LOOK_BOLD | LOOK_ACCENT | 1 << 4;STYLE_HEAD_BOLD
  DS 8, 0

;the state at the start of a line, only affects a
TBResetState:
  ld a, (1 << MD_LINE) | (1 << MD_PREV_SPACE)
  ld [tb_state], a
  xor a
  ld [tb_state+1], a
  ret

;the state after the char TBLex looked at, only affects a
TBCommit:
  ld a, [tb_next_state]
  ld [tb_state], a
  ld a, [tb_next_state+1]
  ld [tb_state+1], a
  ret

;a = char, hl and de at it (TBReadNext), returns its width in a, sets [tb_attr] to its style and
;tb_next_state to the state after it (TBCommit), control characters are drawn as spaces,
;preserves bc, de, hl
TBLex:
  push bc
  push hl
  ld c, a
  ld a, [tb_state]
  ld [tb_next_state], a
  ld a, [tb_state+1]
  ld [tb_next_state+1], a
  ld b, 0;style
  ld a, [_tb_lang]
  and a
  call nz, TBLexMD
  ld a, [tb_next_state+1]
  and a, MD_HEADING
  jr z, .fontWidth
  cp a, 5
  jr nc, .fontWidth
  cpl
  add a, 10;9 - level, the heading fonts' cells are 8, 7, 6, 5 pixels
  jr .bold
.fontWidth
  ld a, c
  cp a, ' '
  jr nc, .lookup
  ld a, ' '
.lookup
  ld h, HIGH(_font_widths)
  ld l, a
  ld a, [hl]
.bold
  ld c, a
  ld a, b
  swap a
  add a, LOW(StyleLooks)
  ld l, a
  ld a, HIGH(StyleLooks)
  adc a, 0
  ld h, a
  bit 0, [hl];LOOK_BOLD
  ld a, c
  jr z, .setAttr
  ld hl, font_bold
  add a, [hl]
.setAttr
  or a, b
  ld [tb_attr], a
  and a, STYLE_WIDTH
  pop hl
  pop bc
  ret

;c = char, hl and de at it, updates tb_next_state, returns its style << 4 in b, affects a, hl
TBLexMD:
  ld a, c
  cp a, ASCII_LF
  jr nz, .notLF
  ld a, (1 << MD_LINE) | (1 << MD_PREV_SPACE)
  ld [tb_next_state], a
  xor a
  ld [tb_next_state+1], a
  ret
.notLF
  ld a, [tb_next_state]
  bit MD_LINE, a
  jr z, .pending
  res MD_LINE, a
  ld [tb_next_state], a
  ld a, c
  cp a, '#'
  ld a, 0
  call z, TBPeekHeading
  ld [tb_row_head], a
  ld b, a
  ld a, [tb_next_state+1]
  and a, ~(MD_HEADING | 1 << MD_HASHES)
  or a, b
  inc b
  dec b
  jr z, .setHeading
  set MD_HASHES, a
.setHeading
  ld [tb_next_state+1], a
.pending
  push de
  ld de, 0;d bit 0: toggle bold after this char, bit 2: toggle code, e = 1: it's a marker
  ld hl, tb_next_state+1
  bit MD_HASHES, [hl]
  jr z, .notHashes
  ld a, c
  cp a, '#'
  jr nz, .endHashes
  dec hl
  inc e
  jr .style
.endHashes
  res MD_HASHES, [hl]
.notHashes
  dec hl
  bit MD_MARK, [hl]
  jr z, .code
  res MD_MARK, [hl]
  bit MD_STAR, [hl]
  jr z, .resolve
  ld a, c
  cp a, '*'
  jr nz, .resolve
  ld de, $0101;**
  jr .style
.resolve;a lone * or _ opens italic before a non space if it isn't in a word, closes it after a non space if a word doesn't follow
  call TBIsWord
  bit MD_ITALIC, [hl]
  jr z, .open
  jr c, .code
  inc hl
  bit MD_MARK_SPACE, [hl]
  dec hl
  jr nz, .code
  res MD_ITALIC, [hl]
  jr .code
.open
  inc hl
  bit MD_MARK_WORD, [hl]
  dec hl
  jr nz, .code
  ld a, c
  cp a, ' '
  jr z, .code
  set MD_ITALIC, [hl]
.code
  ld a, c
  cp a, '`'
  jr nz, .notTick
  set 2, d
  inc e
  jr .style
.notTick
  bit MD_CODE, [hl]
  jr nz, .style
  cp a, '*'
  jr z, .star
  cp a, '_'
  jr nz, .style
  res MD_STAR, [hl]
  jr .isMark
.star
  set MD_STAR, [hl]
  bit MD_BOLD, [hl]
  jr nz, .marker;closing **
.isMark;dimmed if it can open italic (not in a word) or close it (italic, after a non space)
  bit MD_PREV_WORD, [hl]
  jr z, .marker
  bit MD_ITALIC, [hl]
  jr z, .mark
  bit MD_PREV_SPACE, [hl]
  jr nz, .mark
.marker
  inc e
.mark
  set MD_MARK, [hl]
  inc hl
  res MD_MARK_WORD, [hl]
  res MD_MARK_SPACE, [hl]
  dec hl
  bit MD_PREV_WORD, [hl]
  jr z, .markSpace
  inc hl
  set MD_MARK_WORD, [hl]
  dec hl
.markSpace
  bit MD_PREV_SPACE, [hl]
  jr z, .style
  inc hl
  set MD_MARK_SPACE, [hl]
  dec hl

.style;from the state before the toggles
  ld b, STYLE_MARK << 4
  dec e
  jr z, .toggles
  ld b, STYLE_CODE << 4
  bit MD_CODE, [hl]
  jr nz, .toggles
  inc hl
  ld a, [hld]
  and a, MD_HEADING
  jr z, .text
  ld b, STYLE_HEAD << 4;headings 1-4 have bold fonts
  cp a, 5
  jr c, .toggles
  ld b, STYLE_HEAD_BOLD << 4
  jr .toggles
.text
  ld b, 0
  bit MD_BOLD, [hl]
  jr z, .italic
  ld b, STYLE_BOLD << 4
.italic
  bit MD_ITALIC, [hl]
  jr z, .toggles
  set 5, b;STYLE_ITALIC << 4
.toggles
  ld a, d
  and a, 1 << MD_BOLD | 1 << MD_CODE
  xor a, [hl]
  ld [hl], a
  res MD_PREV_WORD, [hl]
  res MD_PREV_SPACE, [hl]
  call TBIsWord
  jr nc, .notWord
  set MD_PREV_WORD, [hl]
.notWord
  ld a, c
  cp a, ' '
  jr z, .space
  cp a, ASCII_TAB
  jr nz, .done
.space
  set MD_PREV_SPACE, [hl]
.done
  pop de
  ret

;c = char, returns carry if it's a letter or digit (Latin-1 letters too), only affects a
TBIsWord:
  ld a, c
  cp a, $C0
  ccf
  ret c
  cp a, '0'
  ccf
  ret nc
  cp a, '9'+1
  ret c
  or a, $20
  cp a, 'a'
  ccf
  ret nc
  cp a, 'z'+1
  ret

;hl and de at a #, returns the heading level in a if the line is a heading (1-6 # then a space),
;otherwise 0, preserves bc, de, hl
TBPeekHeading:
  push bc
  push de
  ld b, 0
.loop
    call TBCheckEnd
    jr z, .no
    push bc
    call TBReadNext
    pop bc
    cp a, '#'
    jr nz, .notHash
    inc b
    ld a, b
    cp a, 7
    jr c, .loop
    jr .no
.notHash
  cp a, ' '
  jr nz, .no
  ld a, b
  jr .done
.no
  xor a
.done
  pop de
  push af
  call TBReadSeek;back to the char
  pop af
  pop bc
  ret

;de = row start, sets tb_state to the lexer state there by scanning rows from its line's start,
;tb_len must be set, clears tb_row_ptr, preserves de
TBSyncState:
  call TBResetState
  ld a, [_tb_lang]
  and a
  ret z
  ST_DE_VAR tb_sync_end
  xor a
  ld [tb_row_ptr], a
  ld [tb_row_ptr+1], a
  ld a, [_tb_found_col]
  push af
  ld a, [_tb_end_row]
  push af
  call TBLineStart
.row
    ld a, [tb_sync_end]
    sub a, e
    ld a, [tb_sync_end+1]
    sbc a, d
    jr c, .done
    jr nz, .scan
  .checkLow
    ld a, [tb_sync_end]
    cp a, e
    jr z, .done
  .scan
    push de
    call TBScanRow
    pop bc
    ld a, c
    cp a, e
    jr nz, .row
    ld a, b
    cp a, d
    jr nz, .row;no progress, the end of the text
.done
  pop af
  ld [_tb_end_row], a
  pop af
  ld [_tb_found_col], a
  LD_DE_VAR tb_sync_end
  ret

;Scans one visual row. Rows are up to TB_WIDTH pixels (character widths from TBLex)
;and TB_STRIDE characters, end after a line feed, and wrap after the last space when a word
;doesn't fit. Spaces and a line feed after a full row hang off the end of it.
;With [_tb_nowrap] set a row is a whole line: its first [_tb_left] characters and the ones
;that don't fit aren't drawn, and [_tb_found_col] is 0 or the characters drawn for them.
;de = row start, [tb_len] = length, returns next row start in de
;sets [_tb_found_col] if [_tb_find] is in the row and [_tb_found_col] is $FF
;tb_state is the lexer state at the row start, returns the next row's in it, [tb_row_head] = the row's heading
TBScanRow:
  ST_DE_VAR tb_row_start
  call TBReadSeek
  xor a
  ld [tb_x], a
  ld [tb_row_chars], a
  ld a, [tb_state+1]
  and a, MD_HEADING
  ld [tb_row_head], a
  ld b, 0;column
  ld c, 0;column after last space
  ld a, [_tb_nowrap]
  and a
  jr z, .loop
  ld a, [_tb_left]
  ld [tb_k], a
  ld a, [_tb_left+1]
  ld [tb_k+1], a
.skip;the characters left of the screen
    ld a, [tb_k]
    ld c, a
    ld a, [tb_k+1]
    or a, c
    ld c, 0
    jr z, .loop
    call TBCheckEnd
    jp z, .end
    ld a, [hl]
    cp a, ASCII_LF
    jr z, .lexFits
    call TBCheckFind
    ld a, [hl]
    call TBLex
    call TBCommit
    push bc
    call TBReadNext
    pop bc
    ld a, [tb_k]
    sub a, 1
    ld [tb_k], a
    jr nc, .skip
    ld a, [tb_k+1]
    dec a
    ld [tb_k+1], a
    jr .skip
.loop
    ld a, b
    cp a, TB_STRIDE
    jr z, .full
    call TBCheckEnd
    jr z, .end
    ld a, [hl];next char
    call TBLex
    ld a, [hl]
    cp a, ASCII_LF
    jr z, .fits
    ld a, [tb_attr]
    and a, STYLE_WIDTH
    push bc
    ld b, a
    ld a, [tb_x]
    add a, b
    pop bc
    cp a, TB_WIDTH+1
    jr nc, .full
    jr .fits
  .lexFits
    call TBLex
  .fits
    call TBCheckFind
    call TBCommit
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
    ld a, [tb_attr]
    and a, STYLE_WIDTH
    push bc
    ld b, a
    ld a, [tb_x]
    add a, b
    ld [tb_x], a
    pop bc
    inc b
    ld a, b
    ld [tb_row_chars], a
    ld a, [tb_char]
    cp a, ' '
    jr nz, .loop
    ld c, b
    ld a, [tb_state];a wrapped word starts after the last space
    ld [tb_space_state], a
    ld a, [tb_state+1]
    ld [tb_space_state+1], a
    jr .loop

.end
  ld a, [_tb_end_row]
  inc a
  jp nz, TBCheckFind
  ld a, [tb_row]
  ld [_tb_end_row], a
  jp TBCheckFind

.full
    ld a, [_tb_nowrap]
    and a
    jr nz, .rest
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
    ld a, [hl]
    call TBLex
    call TBCommit
    push bc
    call TBReadNext
    pop bc
    pop af
    cp a, ASCII_LF
    ret z
    ld c, b;row ends with a space, no word to wrap
    jr .full

.rest;the characters right of the screen, to the line feed
    call TBCheckEnd
    jr z, .end
    call TBCheckFind
    ld a, [hl]
    call TBLex
    call TBCommit
    push bc
    call TBReadNext
    pop bc
    cp a, ASCII_LF
    ret z
    jr .rest

.checkWrap
  ld a, c
  and a
  ret z;no spaces, wrap mid word
  cp a, b
  ret z;row ends with a space

.wrapWord;next row starts after the last space
  ld a, [tb_space_state]
  ld [tb_state], a
  ld a, [tb_space_state+1]
  ld [tb_state+1], a
  xor a
  ld [tb_attr], a
  ld a, c
  ld [tb_row_chars], a
  ld a, b
  ld [tb_char], a;characters in the row
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
    ld a, [tb_char]
    cp a, b
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

_tb_CountLines::;de = start, bc = end, returns the line feeds in [start, end) in bc
  ld a, c
  sub a, e
  ld [tb_count], a
  ld a, b
  sbc a, d
  ld [tb_count+1], a
  ld hl, 0
  ST_HL_VAR tb_lines
  SRAM_ON
.run;a run is in one bank, on one side of the gap and the register hole
    ld a, [tb_count]
    ld c, a
    ld a, [tb_count+1]
    or a, c
    jp z, .done
    ST_DE_VAR tb_target;position
    LD_HL_VAR tb_gap_start
    ld a, e
    sub a, l
    ld a, d
    sbc a, h
    jr nc, .afterGap
    ld a, l;stop at the gap
    sub a, e
    ld l, a
    ld a, h
    sbc a, d
    ld h, a
    LD_DE_VAR tb_count
    call TBMin
    jr .setLength
  .afterGap
    LD_HL_VAR tb_count
  .setLength
    ST_HL_VAR tb_k
    LD_DE_VAR tb_target
    call TBLogToPhys
    call TBPhysRun
    ld a, b
    ld [rRAMB], a
    push hl;address
    ld h, d
    ld l, e
    LD_DE_VAR tb_k
    call TBMin
    ST_HL_VAR tb_k
    ld b, h
    ld c, l
    pop hl;address
    LD_DE_VAR tb_lines
  .count
      ld a, [hli]
      cp a, ASCII_LF
      jr nz, .next
      inc de
    .next
      dec bc
      ld a, b
      or a, c
      jr nz, .count
    ST_DE_VAR tb_lines
    LD_DE_VAR tb_k
    LD_HL_VAR tb_count
    ld a, l
    sub a, e
    ld [tb_count], a
    ld a, h
    sbc a, d
    ld [tb_count+1], a
    LD_HL_VAR tb_target
    add hl, de
    ld d, h
    ld e, l
    jp .run
.done
  SRAM_OFF
  LD_BC_VAR tb_lines
  ret

_tb_LineStart::;de = pos, returns the start of its line in bc
  SRAM_ON
  call TBLineStart
  SRAM_OFF
  ld b, d
  ld c, e
  ret

_tb_RowStart::;de = pos, returns start of the visual row containing pos in bc
  SRAM_ON
  call TBStartScan
  call TBLineStart
  call TBResetState
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
  call TBSyncState
  call TBScanRow
  ld b, d
  ld c, e
  SRAM_OFF
  ret

_tb_Render::;de = top, draws [_tb_rows] rows into tile_buffer, sets _tb_found_col/row for [_tb_find] and _tb_bottom
  ld a, $FF
  ld [_tb_found_col], a
  ld [_tb_found_row], a
  ld [_tb_end_row], a
  ld a, e
  ld [_tb_row_starts], a
  ld a, d
  ld [_tb_row_starts+1], a
  ld a, [_tb_rows]
  ld e, a
  xor a
  ;fall through

_tb_RenderRows::;a = first row, e = end row, scans rows [first, end) from _tb_row_starts[first] into tile_buffer
  ld [tb_row], a
  ld a, e
  ld [tb_end], a
  SRAM_ON
  call TBLength
  ST_HL_VAR tb_len
  ld a, [tb_row]
  call RenderRowAddress
  ld de, tile_buffer
  add hl, de
  ST_HL_VAR tb_row_ptr
  ld a, [tb_row]
  ld b, a
  ld a, [tb_end]
  sub a, b
  call RenderRowAddress
  ld b, h
  ld c, l;rows * TB_STRIDE
  push bc
  LD_HL_VAR tb_row_ptr
  ld a, ' '
  call mem_Set
  pop bc
  LD_HL_VAR tb_row_ptr
  ld de, tile_attrs - tile_buffer
  add hl, de
  xor a
  call mem_Set
  ld a, [tb_row]
  add a, a
  add a, LOW(_tb_row_starts)
  ld l, a
  ld a, HIGH(_tb_row_starts)
  adc a, 0
  ld h, a
  ld a, [hli]
  ld e, a
  ld d, [hl]
  ld a, [tb_row]
  and a
  jr nz, .loadState
  LD_HL_VAR tb_row_ptr
  push hl
  call TBSyncState;the top row's state isn't known, scan to it from its line's start
  pop hl
  ST_HL_VAR tb_row_ptr
  jr .rowLoop
.loadState
  call TBRowStateAddress
  ld a, [hli]
  ld [tb_state], a
  ld a, [hl]
  ld [tb_state+1], a
.rowLoop
    call TBStoreRowStart
    call TBScanRow
    call TBRowStateAddress;the row's heading, found at its line's first char
    inc hl
    ld a, [hl]
    and a, ~MD_HEADING
    ld b, a
    ld a, [tb_row_head]
    or a, b
    ld [hl], a
    ld a, [tb_row]
    ld c, a
    ld b, 0
    ld hl, _tb_row_counts
    add hl, bc
    ld a, [tb_row_chars]
    ld [hl], a
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
    ld bc, TB_STRIDE
    add hl, bc
    ST_HL_VAR tb_row_ptr
    ld a, [tb_row]
    inc a
    ld [tb_row], a
    ld hl, tb_end
    cp a, [hl]
    jr c, .rowLoop
  call TBStoreRowStart
  ld a, [_tb_rows]
  ld hl, tb_end
  cp a, [hl]
  jr nz, .done
  ST_DE_VAR _tb_bottom
.done
  SRAM_OFF
  ret

;hl = last source byte, de = last destination byte, bc = count, copies backwards
TBCopyBack:
  inc b
  inc c
  jr .next
.loop
    ld a, [hld]
    ld [de], a
    dec de
.next
    dec c
    jr nz, .loop
    dec b
    jr nz, .loop
  ret

_tb_ScrollRows::;a = 1 to move rows up (scroll down) or 0 to move them down, shifts tile_buffer and the row tables
  and a
  jr z, .moveDown
.moveUp
  ld a, [_tb_rows]
  dec a
  call RenderRowAddress
  ld b, h
  ld c, l
  push bc
  ld hl, tile_buffer+TB_STRIDE
  ld de, tile_buffer
  call mem_Copy
  pop bc
  ld hl, tile_attrs+TB_STRIDE
  ld de, tile_attrs
  call mem_Copy
  ld a, [_tb_rows]
  add a, a
  ld c, a
  ld b, 0
  push bc
  ld hl, _tb_row_starts+2
  ld de, _tb_row_starts
  call mem_Copy
  pop bc
  ld hl, tb_row_states+2
  ld de, tb_row_states
  call mem_Copy
  ld a, [_tb_rows]
  dec a
  ld c, a
  ld b, 0
  ld hl, _tb_row_counts+1
  ld de, _tb_row_counts
  call mem_Copy
  ld a, [_tb_end_row]
  cp a, $FF
  ret z
  dec a;0 becomes $FF, off the top
  ld [_tb_end_row], a
  ret

.moveDown
  ld a, [_tb_rows]
  dec a
  call RenderRowAddress;(rows - 1) * TB_STRIDE
  ld b, h
  ld c, l
  push bc
  ld de, tile_buffer-1
  add hl, de
  ld d, h
  ld e, l;last byte of row rows - 2
  ld hl, TB_STRIDE
  add hl, de
  ld d, h
  ld e, l;last byte of row rows - 1
  pop bc
  push de
  ld de, -TB_STRIDE
  add hl, de
  pop de
  push bc
  push hl
  push de
  call TBCopyBack
  pop hl;the same rows of tile_attrs
  ld de, tile_attrs - tile_buffer
  add hl, de
  ld d, h
  ld e, l
  pop hl
  ld bc, tile_attrs - tile_buffer
  add hl, bc
  pop bc
  call TBCopyBack
  ld a, [_tb_rows]
  add a, a
  ld c, a
  ld b, 0
  push bc
  ld hl, _tb_row_starts-1
  add hl, bc;last byte of starts[rows - 1]
  ld d, h
  ld e, l
  inc de
  inc de
  call TBCopyBack
  pop bc
  ld hl, tb_row_states-1
  add hl, bc
  ld d, h
  ld e, l
  inc de
  inc de
  call TBCopyBack
  ld a, [_tb_rows]
  dec a
  ld c, a
  ld b, 0
  ld hl, _tb_row_counts-1
  add hl, bc;last byte of counts[rows - 2]
  ld d, h
  ld e, l
  inc de
  call TBCopyBack
  ld a, [_tb_end_row]
  cp a, $FF
  ret z
  inc a
  ld hl, _tb_rows
  cp a, [hl]
  jr c, .setEndRow
  ld a, $FF;off the bottom
.setEndRow
  ld [_tb_end_row], a
  ret

;stores de in _tb_row_starts[tb_row] and tb_state in tb_row_states[tb_row] (keeping a line start's heading), only affects a, hl
TBStoreRowStart:
  ld a, [tb_row]
  add a, a
  add a, LOW(_tb_row_starts)
  ld l, a
  ld a, HIGH(_tb_row_starts)
  adc a, 0
  ld h, a
  ld a, e
  ld [hli], a
  ld [hl], d
  call TBRowStateAddress
  ld a, [tb_state]
  ld [hli], a
  bit MD_LINE, a
  ld a, [tb_state+1]
  jr z, .store
  push bc;a line start: its heading is found at its first char, keep the one found when it was scanned
  ld b, a
  ld a, [hl]
  and a, MD_HEADING
  or a, b
  pop bc
.store
  ld [hl], a
  ret

;returns tb_row_states + [tb_row] * 2 in hl, only affects a
TBRowStateAddress:
  ld a, [tb_row]
  add a, a
  add a, LOW(tb_row_states)
  ld l, a
  ld a, HIGH(tb_row_states)
  adc a, 0
  ld h, a
  ret
