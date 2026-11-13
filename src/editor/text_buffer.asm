;Gap buffer in PSRAM blocks $0100-$017e through the 512-byte window.
;Positions exclude the gap; physical offsets include it. The gap is zeroed
;and text contains no zero bytes, allowing recovery without gap metadata.
;
;C functions (src/editor/text_buffer.h)
;   tb_Load                     recovers buffer from SRAM, clears it if the signature is missing
;   tb_Clear
;   tb_Length                   returns length in bc
;   tb_GetChar                  de = pos, returns char in a
;   tb_Insert                   de = pos, a = char, returns a = 0 if buffer is full
;   tb_Delete                   de = pos, returns deleted char in a (0 = nothing deleted)
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

;PSRAM is always there through the window
DEF TB_BANK_REG EQU EDX_BLOCK
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

_TBSignature::
TBSignature: DB "TXT3";in PSRAM block MAIN_SRAM_BANK while the text there is good

_tb_Load::
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
  jp TBResetChecks

.clear
  SWITCH_RAM_MBC5 MAIN_SRAM_BANK
  ld hl, TBSignature
  ld de, sram_tb_signature
  ld bc, 4
  call mem_Copy
  ;fall through

_tb_Clear::
  ld a, 1;the swap file needs writing (src/editor/editor.c)
  ld [_swap_dirty], a
  xor a
.clearBankLoop;everything but the register hole
    push af;bank
    ld [TB_BANK_REG], a
    xor a
    ld hl, TB_BASE
    ld bc, TB_BANK_SIZE
    call mem_Set
    pop af;bank
    inc a
    cp a, TB_BANKS
    jr nz, .clearBankLoop
  jr TBEmpty

_tb_Empty::;empties the text buffer without clearing it (tb_Load can't find the gap after this, a large
;file's window clears the signature, see src/fatfs/fatfs.c)
  ld a, 1
  ld [_swap_dirty], a
TBEmpty:
  ld hl, 0
  ST_HL_VAR tb_gap_start
  ld hl, TB_SIZE
  ST_HL_VAR tb_gap_end
  jp TBResetChecks

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
;512 byte blocks
  ld a, h
  srl a
  ld [TB_BANK_REG], a
  ld a, h
  and a, 1
  or a, HIGH(TB_BASE)
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
    ld [TB_BANK_REG], a
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
  cp a, $C0
  jr z, .seek;crossed into next bank
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
  call TBReadSeek
  ld b, [hl]
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

;hl = physical offset, returns block in b, window address in hl, bytes until the block end in de, affects a
TBPhysRun:
  ld b, 0
TBPhysRunFrom::;b = first block (the undo log starts at UNDO_BANK)
  ld a, h
  srl a
  add a, b
  ld b, a
  ld a, h
  and a, 1
  ld h, a;offset in block
  xor a
  sub a, l
  ld e, a
  ld a, HIGH(TB_BANK_SIZE)
  sbc a, h
  ld d, a
  ld a, h
  or a, HIGH(TB_BASE)
  ld h, a
  ret

;hl = physical offset, returns bytes before it in the same block in de, affects a, hl
TBRunBack:
  dec hl
  ld a, h
  and a, 1
  ld d, a
  ld e, l
  inc de
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
  ld [TB_BANK_REG], a
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
  ld [TB_BANK_REG], a
  LD_HL_VAR tb_dst_addr
  ld d, h
  ld e, l
  ld hl, win_buffer
  LD_BC_VAR tb_k
  call mem_Copy
  ld a, [tb_src_bank]
  ld [TB_BANK_REG], a
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
  call TBEdited
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
  ld a, b
  ret

_tb_Delete::;de = pos, returns deleted char in a (0 = nothing deleted)
  call TBEdited
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
  ld a, b
  ret

_tb_Append::;de = buffer, bc = count, inserts at the gap dropping 0s and CRs (sets tb_cr if it drops a CR), returns a = 0 if it filled up
  push de
  LD_DE_VAR tb_gap_start
  call TBEdited
  pop de
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
    ld [TB_BANK_REG], a
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
      cp a, ASCII_CR+1
      jr c, .low;0, CR and the other control characters
.store
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
.low
      and a
      jr z, .next;text never contains 0
      cp a, ASCII_CR
      jr nz, .store
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
  ld a, 1
  ret
.full
  xor a
  ret

_tb_ReadLines::;de = buffer, bc = size, like tb_Read but line feeds are written as CR LF
  ld a, 1
  jr TBRead

_tb_Read::;de = buffer, bc = size, copies text from [_tb_read_pos] until the buffer is full or the text ends, advances it, returns bytes copied in bc
  xor a
TBRead:
  ld [tb_crlf], a
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
    ld [TB_BANK_REG], a
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
  ret

_tb_DeleteRange::;de = pos, bc = count, deletes count chars at pos (they must exist)
  ld a, c
  ld [tb_count], a
  ld a, b
  ld [tb_count+1], a
  or a, c
  ret z
  call TBEdited
  call TBMoveGap
.loop;zero runs after the gap and grow it over them
    LD_HL_VAR tb_gap_end
    call TBPhysRun
    ld a, b
    ld [TB_BANK_REG], a
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
  ret

DEF TB_CLIP_CHUNK EQU 256;bytes copied at a time through win_buffer

;selects the block for [tb_clip_ptr] (an offset from block MAIN_SRAM_BANK), returns its address in hl, affects a, b, de
TBClipAddr:
  LD_HL_VAR tb_clip_ptr
  ld b, MAIN_SRAM_BANK
  call TBPhysRunFrom
  ld a, b
  ld [TB_BANK_REG], a
  ret

_tb_ClipLength::;returns clipboard length in bc, 0 if it's empty or was never set
  ld a, MAIN_SRAM_BANK
  ld [TB_BANK_REG], a
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
  ld a, 1;the swap file needs writing (src/editor/editor.c)
  ld [_swap_dirty], a
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
  ld a, MAIN_SRAM_BANK
  ld [TB_BANK_REG], a
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
  ld hl, sram_clip
  ST_HL_VAR tb_clip_ptr
.loop
    call TBClipChunk
    jr z, .done
    push bc
    ld de, win_buffer
    call _tb_Read
      call TBClipAddr
    ld d, h
    ld e, l
    pop bc
    push bc
    ld hl, win_buffer
    call mem_Copy
    pop bc
    call TBClipAdvance
    jr .loop
.done
  ld a, 1
  ret

_tb_Paste::;de = pos, inserts the clipboard, returns a = 0 if it doesn't fit (nothing is inserted)
  call TBEdited
  push de
  call _tb_ClipLength
  ld a, c
  ld [tb_clip_left], a
  ld a, b
  ld [tb_clip_left+1], a
  pop de
  call TBMoveGap
  call TBGapLength
  ld hl, tb_clip_left
  ld a, c
  sub a, [hl]
  inc hl
  ld a, b
  sbc a, [hl]
  jr nc, .fits
  xor a
  ret
.fits
  ld hl, sram_clip
  ST_HL_VAR tb_clip_ptr
.loop
    call TBClipChunk
    jr z, .done
    push bc
    call TBClipAddr
    pop bc
    push bc
    ld de, win_buffer
    call mem_Copy
    pop bc
    push bc
    ld de, win_buffer
    call _tb_Append
      pop bc
    call TBClipAdvance
    jr .loop
.done
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
;** toggles bold, * and _ italic (not inside a word), ` code. Markers stay visible. A line starting
;with ``` opens or closes a code block, its lines (fences too) are all code. Code is drawn with
;FONT_FIXED's glyphs and width (CODE_WIDTH, RenderGlyph). The code block state crosses lines,
;TBLineState finds it from a checkpoint (TBCheckRunMD).
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
DEF MD_FENCE      EQU 6;in a code block, kept after a line feed
DEF MD_FENCE_LINE EQU 7;the line is a fence (```)
DEF CODE_WIDTH    EQU 4;FONT_FIXED's width

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
  DB LOOK_DIM;STYLE_COMMENT
  DB LOOK_ACCENT | 1 << 4;STYLE_KEYWORD, blue
  DB LOOK_ACCENT | 1 << 4;STYLE_TYPE, blue
  DB LOOK_ACCENT | 2 << 4;STYLE_STRING, red
  DB LOOK_ACCENT | 3 << 4;STYLE_NUMBER, purple
  DB LOOK_BOLD | LOOK_ACCENT | 4 << 4;STYLE_PREPROC, orange
  DB LOOK_ACCENT | 4 << 4;STYLE_LABEL
  DB 0

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
  jr z, .heading
  dec a
  jr nz, .code
  call TBLexMD
  jr .heading
.code
  call TBLexCode
.heading
  ld a, c
  cp a, ' '
  jr nc, .char
  ld a, ' '
.char
  ld c, a
  ld a, [tb_next_state+1]
  and a, MD_HEADING
  jr z, .notHeading
  cp a, 5
  jr nc, .notHeading
  add a, HIGH(HeadingWidths) - 1;headings 1-4 have their own fonts
  jr .styledWidth
.notHeading
  ld a, b
  cp a, STYLE_CODE << 4
  ld a, CODE_WIDTH
  jr z, .setAttr
  ld a, b
  swap a
  add a, LOW(StyleLooks)
  ld l, a
  ld a, HIGH(StyleLooks)
  adc a, 0
  ld h, a
  bit 0, [hl];LOOK_BOLD
  jr z, .fontWidth
  ld a, [font_bold_widths]
.styledWidth
  call StyledWidth
  jr .setAttr
.fontWidth
  ld h, HIGH(_font_widths)
  ld l, c
  ld a, [hl]
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
  ld a, [tb_next_state+1]
  and a, 1 << MD_FENCE
  ld [tb_next_state+1], a
  ret
.notLF
  ld a, [tb_next_state]
  bit MD_LINE, a
  jr z, .pending
  res MD_LINE, a
  ld [tb_next_state], a
  ld a, c
  cp a, '`'
  call z, TBPeekFence
  jr nz, .notFence
  ld a, [tb_next_state+1]
  xor a, 1 << MD_FENCE
  or a, 1 << MD_FENCE_LINE
  ld [tb_next_state+1], a
  xor a
  ld [tb_row_head], a
  jr .pending
.notFence;no headings in a code block
  ld a, [tb_next_state+1]
  and a, 1 << MD_FENCE
  ld a, 0
  jr nz, .head
  ld a, c
  cp a, '#'
  ld a, 0
  call z, TBPeekHeading
.head
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
  ld a, [tb_next_state+1]
  and a, 1 << MD_FENCE | 1 << MD_FENCE_LINE
  jr z, .inline
  ld b, STYLE_CODE << 4
  ret
.inline
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

;hl and de at a `, returns z if it starts ``` (a code block's fence), preserves bc, de, hl
TBPeekFence:
  push bc
  push de
  ld b, 3
.loop
    call TBCheckEnd
    jr z, .no
    push bc
    call TBReadNext
    pop bc
    cp a, '`'
    jr nz, .done
    dec b
    jr nz, .loop
  jr .done
.no
  or a, 1
.done
  pop de
  push af
  call TBReadSeek;back to the char
  pop af
  pop bc
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

;Code (C and RGBDS asm): a token's style is decided at its first char, a word's from the keyword
;tables (TBPeekWord). C block comments are the only state that crosses lines, TBLineState finds it
;from a checkpoint every 1KB (TBCheckState). State byte 0:
DEF CODE_MODE  EQU %00000111
DEF CM_NONE    EQU 0
DEF CM_WORD    EQU 1;a word or number, its style in state byte 1, ends at a non word char
DEF CM_STRING  EQU 2
DEF CM_CHAR    EQU 3
DEF CM_LINE    EQU 4;line comment
DEF CM_BLOCK   EQU 5;C block comment
DEF CM_OPEN    EQU 6;the * that opens one
DEF CODE_LINE  EQU 3;nothing of the line seen yet (= MD_LINE)
DEF CODE_PREV  EQU 4;the last char was a \ in a string, a * in a block comment, a / otherwise (TBCheckRun only)
DEF CODE_BLANK EQU 7;only spaces seen (= MD_PREV_SPACE, so TBResetState fits)

;c = char, hl and de at it, updates tb_next_state, returns its style << 4 in b, affects a, hl
TBLexCode:
  ST_DE_VAR tb_lex_pos
  ld a, c
  cp a, ASCII_LF
  jr nz, .notLF
  ld hl, tb_next_state+1
  ld [hl], 0
  dec hl
  ld a, [hl]
  and a, CODE_MODE
  cp a, CM_BLOCK
  jr z, .lf
  xor a
.lf
  or a, 1 << CODE_LINE | 1 << CODE_BLANK
  ld [hl], a
  ld b, 0
  ret
.notLF
  push de
  ld hl, tb_next_state
  ld d, [hl];the state before this char
  res CODE_LINE, [hl]
  cp a, ' '
  jr z, .blank
  cp a, ASCII_TAB
  jr z, .blank
  res CODE_BLANK, [hl]
.blank
  ld a, d
  and a, CODE_MODE
  jr z, .none
  dec a
  jr z, .word
  dec a
  jr z, .string
  dec a
  jr z, .char
  dec a
  jr z, .comment
  dec a
  jr z, .block
  ld a, CM_BLOCK;the * opening it
  call TBSetMode
.comment
  ld b, STYLE_COMMENT << 4
  jp .done
.block
  ld b, STYLE_COMMENT << 4
  ld a, c
  bit CODE_PREV, d
  jr z, .star
  cp a, '/'
  jr nz, .star
  xor a;CM_NONE after it
  call TBSetMode
  jp .done
.star
  res CODE_PREV, [hl]
  cp a, '*'
  jp nz, .done
  set CODE_PREV, [hl]
  jp .done
.char
  ld e, '\''
  jr .quoted
.string
  ld e, '"'
.quoted
  ld b, STYLE_STRING << 4
  bit CODE_PREV, d
  jr z, .notEscaped
  res CODE_PREV, [hl]
  jp .done
.notEscaped
  ld a, c
  cp a, '\\'
  jr nz, .notEscape
  set CODE_PREV, [hl]
  jp .done
.notEscape
  cp a, e
  jp nz, .done
  xor a
  call TBSetMode
  jp .done
.word
  call TBIsCodeWord
  ld a, [tb_next_state+1]
  ld b, a
  jp c, .done
  cp a, STYLE_NUMBER << 4
  jr nz, .endWord
  ld a, c
  cp a, '.';1.5
  jp z, .done
.endWord
  xor a
  ld [tb_next_state+1], a
  call TBSetMode
.none
  ld b, STYLE_STRING << 4
  ld a, c
  cp a, '"'
  ld a, CM_STRING
  jp z, .setMode
  ld a, c
  cp a, '\''
  ld a, CM_CHAR
  jp z, .setMode
  ld a, [_tb_lang]
  cp a, LANG_ASM
  ld a, c
  jr nc, .asm;project files lex as asm
  cp a, '#'
  jr nz, .notHash
  bit CODE_BLANK, d
  jp z, .text
  ld b, STYLE_PREPROC << 4;the # and the directive after it
  jr .startWord
.notHash
  cp a, '/'
  jr nz, .number
  call TBPeekNext
  ld e, a
  ld b, STYLE_COMMENT << 4
  cp a, '/'
  ld a, CM_LINE
  jr z, .setMode
  ld a, e
  cp a, '*'
  ld a, CM_OPEN
  jr z, .setMode
  jr .text
.asm
  cp a, ';'
  ld b, STYLE_COMMENT << 4
  ld a, CM_LINE
  jr z, .setMode
  ld a, c
  cp a, '$'
  jr z, .hex
  cp a, '%'
  jr nz, .number
  call TBPeekNext
  sub a, '0'
  cp a, 2
  jr c, .numberWord
  jr .text
.hex
  call TBPeekNext
  cp a, '0'
  jr c, .text
  cp a, '9'+1
  jr c, .numberWord
  or a, $20
  cp a, 'a'
  jr c, .text
  cp a, 'f'+1
  jr c, .numberWord
  jr .text
.number
  ld a, c
  cp a, '0'
  jr c, .ident
  cp a, '9'+1
  jr nc, .ident
.numberWord
  ld b, STYLE_NUMBER << 4
  jr .startWord
.ident
  call TBIsCodeWord
  jr nc, .text
  call TBPeekWord
  ld b, a
  and a
  jr nz, .startWord
  ld a, [_tb_lang]
  cp a, LANG_ASM
  jr c, .startWord
  bit CODE_LINE, d;asm labels start at column 0, or are local (.label) and start the line
  jr nz, .label
  bit CODE_BLANK, d
  jr z, .startWord
  ld a, c
  cp a, '.'
  jr nz, .startWord
.label
  ld b, STYLE_LABEL << 4
.startWord
  ld a, b
  ld [tb_next_state+1], a
  ld a, CM_WORD
.setMode
  call TBSetMode
  jp .done
.text
  ld b, 0
.done
  pop de
  ret

;a = mode, sets it in tb_next_state and clears CODE_PREV, affects hl
TBSetMode:
  push bc
  ld b, a
  ld hl, tb_next_state
  ld a, [hl]
  and a, ~(CODE_MODE | 1 << CODE_PREV)
  or a, b
  ld [hl], a
  pop bc
  ret

;c = char, returns carry if it can be in a word (letters, digits, _, and . in asm), only affects a
TBIsCodeWord:
  call TBIsWord
  ret c
  ld a, c
  cp a, '_'
  scf
  ret z
  ld a, [_tb_lang]
  cp a, LANG_ASM
  jr c, .no
  ld a, c
  cp a, '.'
  scf
  ret z
.no
  and a
  ret

;returns the char after the one TBLexCode is at in a (0 at the end), preserves bc, de, affects hl
TBPeekNext:
  push bc
  push de
  LD_DE_VAR tb_lex_pos
  call TBReadSeek
  call TBReadNext
  call TBCheckEnd
  ld a, 0
  jr z, TBPeekDone
  ld a, [hl]
  jr TBPeekDone

;returns the style << 4 of the word TBLexCode is at in a from the keyword tables (0 if it isn't
;one), preserves bc, de, affects hl
TBPeekWord:
  push bc
  push de
  LD_DE_VAR tb_lex_pos
  call TBReadSeek
  ld b, 0;length
.loop
    call TBCheckEnd
    jr z, .end
    push bc
    call TBReadNext
    pop bc
    ld c, a
    call TBIsCodeWord
    jr nc, .end
    ld a, b
    cp a, KEYWORD_MAX
    jr z, .no;too long
    ld a, [_tb_lang]
    cp a, LANG_ASM
    ld a, c
    jr c, .store
    cp a, 'A'
    jr c, .store
    cp a, 'Z'+1
    jr nc, .store
    or a, $20;asm words are case insensitive
  .store
    push hl
    push af
    ld a, b
    add a, LOW(tb_word)
    ld l, a
    ld a, HIGH(tb_word)
    adc a, 0
    ld h, a
    pop af
    ld [hl], a
    pop hl
    inc b
    jr .loop
.end
  ld a, b
  ld [tb_word_len], a
  call TBLookupWord
  jr TBPeekDone
.no
  xor a
TBPeekDone:;back to the char TBLexCode is at, keeps a
  push af
  LD_DE_VAR tb_lex_pos
  call TBReadSeek
  pop af
  pop de
  pop bc
  ret

;returns the style << 4 of tb_word in a, 0 if it isn't a keyword, affects bc, de, hl
TBLookupWord:
  ldh a, [loaded_bank]
  push af
  ld a, BANK(KeywordLookup)
  SET_BANK
  call KeywordLookup
  ld b, a
  pop af
  SET_BANK
  ld a, b
  ret

;de = line start, sets tb_state to the lexer state there, preserves de
TBLineState:
  call TBResetState
  ld a, [_tb_lang]
  cp a, LANG_MD
  jr z, .check
  cp a, LANG_C
  ret nz
.check
  push de
  call TBCheckState
  pop de
  ld a, [_tb_lang]
  cp a, LANG_MD
  jr nz, .comment
  bit 0, b
  ret z
  ld a, 1 << MD_FENCE
  ld [tb_state+1], a
  ret
.comment
  ld a, b
  and a, CODE_MODE
  cp a, CM_BLOCK
  ret nz
  ld a, [tb_state]
  or a, CM_BLOCK
  ld [tb_state], a
  ret

;Checkpoints: the C comment or markdown code block state (TBCheckRun) at every 1KB, [tb_checks_last] is the last one
;known, edits forget the ones after them (TBEdited). tb_check_pos is where the last TBCheckState
;ended, with its state in tb_check_state.

;de = position, returns the comment state there in b, from its checkpoint (or tb_check_pos),
;adding the checkpoints it passes, affects a, c, de, hl
TBCheckState:
  ST_DE_VAR tb_check_end
  ld a, d
  srl a
  srl a
  ld c, a;its checkpoint
  ld a, [tb_checks_last]
  cp a, c
  jr c, .start
  ld a, c
.start
  ld c, a
  ld a, [tb_check_pos+1];start from the last end if it's after the checkpoint and before the position
  srl a
  srl a
  cp a, c
  jr nz, .checkpoint
  ld hl, tb_check_end+1
  ld a, [tb_check_pos]
  ld e, a
  ld a, [tb_check_pos+1]
  ld d, a
  ld a, [tb_check_end]
  sub a, e
  ld a, [hl]
  sbc a, d
  jr c, .checkpoint
  ld a, [tb_check_state]
  ld b, a
  jr .scan
.checkpoint
  ld a, c
  add a, LOW(tb_checks)
  ld l, a
  ld a, HIGH(tb_checks)
  adc a, 0
  ld h, a
  ld b, [hl]
  ld a, c
  add a, a
  add a, a
  ld d, a
  ld e, 0
.scan
  ld a, b
  ld [tb_check_state], a
.run;a run of chars in one bank, on one side of the gap and the register hole, and in one 1KB block
    ld a, e
    and a
    jr nz, .count
    ld a, [tb_check_state]
    ld b, a
    call TBCheckpoint
  .count
    push de
    ld a, [tb_check_end]
    sub a, e
    ld l, a
    ld a, [tb_check_end+1]
    sbc a, d
    ld h, a
    or a, l
    jr z, .done
    ld a, d;bytes to the next 1KB
    and a, 3
    cpl
    add a, 5
    ld b, a
    xor a
    sub a, e
    ld c, a
    ld a, b
    sbc a, 0
    ld d, a
    ld e, c
    call TBMin
    pop de
    push de
    ld a, [tb_gap_start];bytes to the gap
    sub a, e
    ld c, a
    ld a, [tb_gap_start+1]
    sbc a, d
    ld b, a
    jr c, .afterGap
    or a, c
    jr z, .afterGap
    ld d, b
    ld e, c
    call TBMin
    pop de
    push de
  .afterGap
    push hl;count
    call TBLogToPhys
    call TBPhysRun
    ld a, b
    ld [TB_BANK_REG], a
    ld b, h
    ld c, l
    pop hl
    call TBMin
    push hl
    ld h, b
    ld l, c
    pop bc;count
    pop de
    ld a, e
    add a, c
    ld e, a
    ld a, d
    adc a, b
    ld d, a
    push de;position after the run
    ld a, [tb_check_state]
    ld e, a
    call TBCheckRun
    ld a, e
    ld [tb_check_state], a
    pop de
    jr .run
.done
  pop de
  ST_DE_VAR tb_check_pos
  ld a, [tb_check_state]
  ld b, a
  ret

;de = position with e = 0, b = the state there, stores it if it's the first checkpoint not known, affects a, c
TBCheckpoint:
  ld a, d
  and a, 3
  ret nz
  ld a, d
  rrca
  rrca
  ld c, a
  ld a, [tb_checks_last]
  cp a, c
  ret nc
  ld a, c
  ld [tb_checks_last], a
  push hl
  add a, LOW(tb_checks)
  ld l, a
  ld a, HIGH(tb_checks)
  adc a, 0
  ld h, a
  ld [hl], b
  pop hl
  ret

;hl = SRAM address, bc = count (> 0), e = C comment state (CODE_MODE: CM_NONE, CM_STRING, CM_CHAR,
;CM_LINE or CM_BLOCK, and CODE_PREV), scans the chars, returns the state after them in e,
;affects a, bc, hl. Must agree with TBLexCode
MACRO CHECK_NEXT;\1 = loop, \2 = state
  dec bc
  ld a, b
  or a, c
  jr nz, \1
  ld e, \2
  ret
ENDM
TBCheckRun:
  ld a, [_tb_lang]
  cp a, LANG_MD
  jp z, TBCheckRunMD
  ld a, e
  and a
  jr z, .none
  cp a, 1 << CODE_PREV
  jr z, .slash
  cp a, CM_LINE
  jr z, .line
  cp a, CM_BLOCK
  jr z, .block
  cp a, CM_BLOCK | 1 << CODE_PREV
  jr z, .star
  cp a, CM_STRING
  jp z, .string
  cp a, CM_STRING | 1 << CODE_PREV
  jp z, .stringEsc
  cp a, CM_CHAR
  jp z, .char
  jp .charEsc
.none
    ld a, [hli]
  .noneChar
    cp a, '/'+1
    jr nc, .noneNext
    cp a, '/'
    jr z, .toSlash
    cp a, '"'
    jr z, .toString
    cp a, '\''
    jr z, .toChar
  .noneNext
    CHECK_NEXT .none, CM_NONE
.toSlash
  CHECK_NEXT .slash, 1 << CODE_PREV
.toString
  CHECK_NEXT .string, CM_STRING
.toChar
  CHECK_NEXT .char, CM_CHAR
.slash
  ld a, [hli]
  cp a, '/'
  jr z, .toLine
  cp a, '*'
  jr nz, .noneChar
  CHECK_NEXT .block, CM_BLOCK
.toLine
  CHECK_NEXT .line, CM_LINE
.line
    ld a, [hli]
    cp a, ASCII_LF
    jr z, .noneNext
    CHECK_NEXT .line, CM_LINE
.block
    ld a, [hli]
    cp a, '*'
    jr z, .toStar
  .blockNext
    CHECK_NEXT .block, CM_BLOCK
.toStar
  CHECK_NEXT .star, CM_BLOCK | 1 << CODE_PREV
.star
  ld a, [hli]
  cp a, '/'
  jr z, .noneNext
  cp a, '*'
  jr z, .toStar
  jr .blockNext
.string
    ld a, [hli]
    cp a, '\\'
    jr z, .toStringEsc
    cp a, '"'
    jr z, .noneNext
    cp a, ASCII_LF
    jr z, .noneNext
  .stringNext
    CHECK_NEXT .string, CM_STRING
.toStringEsc
  CHECK_NEXT .stringEsc, CM_STRING | 1 << CODE_PREV
.stringEsc
  ld a, [hli]
  cp a, ASCII_LF
  jp z, .noneNext
  jr .stringNext
.char
    ld a, [hli]
    cp a, '\\'
    jr z, .toCharEsc
    cp a, '\''
    jp z, .noneNext
    cp a, ASCII_LF
    jp z, .noneNext
  .charNext
    CHECK_NEXT .char, CM_CHAR
.toCharEsc
  CHECK_NEXT .charEsc, CM_CHAR | 1 << CODE_PREV
.charEsc
  ld a, [hli]
  cp a, ASCII_LF
  jp z, .noneNext
  jr .charNext

;Markdown: e bit 0 = in a code block, bits 1-2 = backticks the line started with (0-2), 3 = not a
;fence. Must agree with TBLexMD
TBCheckRunMD:
.loop
    ld a, [hli]
    cp a, ASCII_LF
    jr nz, .notLF
    ld a, e
    and a, 1
    ld e, a
    jr .next
  .notLF
    cp a, '`'
    ld a, e
    jr nz, .notFence
    and a, %110
    cp a, %110
    jr z, .next
    cp a, %100
    jr z, .fence
    inc e
    inc e
    jr .next
  .fence
    ld a, e
    xor a, 1
  .notFence
    or a, %110
    ld e, a
  .next
    dec bc
    ld a, b
    or a, c
    jr nz, .loop
  ret

;de = position of an edit, forgets the checkpoints after it, only affects a
TBEdited:
  ld a, 1;the swap file needs writing (src/editor/editor.c)
  ld [_swap_dirty], a
  ld [_win_edited], a;a large file's window needs committing (src/fatfs/fatfs.c)
  push bc
  ld a, [tb_checks_last]
  ld b, a
  ld a, d
  srl a
  srl a
  cp a, b
  jr nc, .checkPos
  ld [tb_checks_last], a
.checkPos;and the last TBCheckState end if it's after it
  ld a, [tb_check_pos]
  ld b, a
  ld a, e
  sub a, b
  ld a, [tb_check_pos+1]
  ld b, a
  ld a, d
  sbc a, b
  jr nc, .done
  xor a
  ld [tb_check_pos], a
  ld [tb_check_pos+1], a
  ld [tb_check_state], a
.done
  pop bc
  ret

;forgets the checkpoints, only affects a
_tb_ResetChecks::
TBResetChecks:
  xor a
  ld [tb_checks_last], a
  ld [tb_checks], a
  ld [tb_check_pos], a
  ld [tb_check_pos+1], a
  ld [tb_check_state], a
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
  call TBLineState
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
    ld [TB_BANK_REG], a
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
  LD_BC_VAR tb_lines
  ret

_tb_LineStart::;de = pos, returns the start of its line in bc
  call TBLineStart
  ld b, d
  ld c, e
  ret

_tb_RowStart::;de = pos, returns start of the visual row containing pos in bc
  call TBStartScan
  call TBLineStart
  call TBLineState
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
  ret

_tb_NextRow::;de = row start, returns start of the next visual row in bc
  push de
  ld de, $FFFF
  call TBStartScan
  pop de
  call TBSyncState
  call TBScanRow
  ld b, d
  ld c, e
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

  KEYWORDS_SECTION;with the tables (keywords.asm)

KeywordLookup:;returns the style << 4 of tb_word ([tb_word_len] chars) in a, 0 if it isn't a keyword, affects bc, de, hl
  ld a, [_tb_lang]
  cp a, LANG_ASM
  ld hl, KeywordsAsm
  jr z, .table
  ld hl, KeywordsProject
  jr nc, .entry;project.gbp's few words are one list
  ld hl, KeywordsC
.table
  ld a, [tb_word]
  and a, 31
  add a, a
  add a, l
  ld l, a
  adc a, h
  sub a, l
  ld h, a
  ld a, [hli]
  ld h, [hl]
  ld l, a
.entry
    ld a, [hli];length
    and a
    ret z
    ld c, a
    ld a, [hli];style
    ld b, a
    ld a, [tb_word_len]
    cp a, c
    jr nz, .skip
    ld de, tb_word
  .compare
      ld a, [de]
      cp a, [hl]
      jr nz, .skip
      inc de
      inc hl
      dec c
      jr nz, .compare
    ld a, b
    ret
  .skip;the rest of the entry
    ld a, c
    add a, l
    ld l, a
    adc a, h
    sub a, l
    ld h, a
    jr .entry
