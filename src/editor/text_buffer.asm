;Gap buffer stored in SRAM banks 0-2, skipping $BD00-$BD0F in each bank so text
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
;   tb_Append                   de = buffer, bc = count, inserts at the gap skipping 0s, returns a = 0 if it filled up
;   tb_Read                     de = buffer, bc = count, copies from tb_read_pos and advances it
;   tb_DeleteRange              de = pos, bc = count, deletes count chars (they must exist)
;   tb_Copy                     de = pos, bc = count, copies text to the clipboard, returns a = 0 if it's too big
;   tb_Paste                    de = pos, inserts the clipboard, returns a = 0 if it doesn't fit
;   tb_ClipLength               returns clipboard length in bc (in SRAM bank 3, see src/sram.asm)
;   tb_RowStart                 de = pos, returns start of the visual row containing pos in bc
;   tb_NextRow                  de = row start, returns start of the next visual row in bc
;   tb_Render                   de = top, draws tb_rows rows to tile_buffer, finds tb_find
;   tb_RenderRows               a = first row, e = end row, draws rows from tb_row_starts[first]
;   tb_ScrollRows               a = 1 moves rows up (scroll down), 0 down, shifts tile_buffer and the row tables

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
tb_clip_ptr: DW

SECTION "Text Buffer Code", ROM0

TBSignature: DB "TXT2"

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
    call TBCheckSize
    jr nz, .gapStartLoop
.foundGapStart
  ST_DE_VAR tb_gap_start

.findGapEnd;first non 0 after gap start
    call TBCheckSize
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

_tb_Append::;de = buffer, bc = count, inserts at the gap skipping 0s, returns a = 0 if it filled up
  SRAM_ON
.loop
    ld a, b
    or a, c
    jr z, .done
    dec bc
    ld a, [de]
    inc de
    and a
    jr z, .loop;text never contains 0
    push de
    ld d, a;char
    ld a, [tb_gap_start]
    ld e, a
    ld a, [tb_gap_end]
    cp a, e
    jr nz, .write
    ld a, [tb_gap_start+1]
    ld e, a
    ld a, [tb_gap_end+1]
    cp a, e
    jr z, .full
  .write
    LD_HL_VAR tb_gap_start
    push hl
    inc hl
    ST_HL_VAR tb_gap_start
    pop hl
    call TBPhysAddr
    ld [hl], d
    pop de
    jr .loop
.full
  pop de
  SRAM_OFF
  xor a
  ret
.done
  SRAM_OFF
  ld a, 1
  ret

_tb_Read::;de = buffer, bc = count, copies from [_tb_read_pos] and advances it
  SRAM_ON
  ST_DE_VAR tb_dest
  ld a, c
  ld [tb_count], a
  ld a, b
  ld [tb_count+1], a
  LD_HL_VAR _tb_read_pos
  ld d, h
  ld e, l
  call TBReadSeek
.loop
    ld a, [tb_count]
    ld c, a
    ld a, [tb_count+1]
    ld b, a
    or a, c
    jr z, .done
    dec bc
    ld a, c
    ld [tb_count], a
    ld a, b
    ld [tb_count+1], a
    call TBReadNext
    push hl
    push af;char
    LD_HL_VAR tb_dest
    pop af;char
    ld [hli], a
    ST_HL_VAR tb_dest
    pop hl
    jr .loop
.done
  ST_DE_VAR _tb_read_pos
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

;a = char, returns its width in pixels in a, control characters are drawn as spaces, only affects a
TBCharWidth:
  cp a, ' '
  jr nc, .lookup
  ld a, ' '
.lookup
  push hl
  ld h, HIGH(_font_widths)
  ld l, a
  ld a, [hl]
  pop hl
  ret

;Scans one visual row. Rows are up to TB_WIDTH pixels (character widths from _font_widths)
;and TB_STRIDE characters, end after a line feed, and wrap after the last space when a word
;doesn't fit. Spaces and a line feed after a full row hang off the end of it.
;de = row start, [tb_len] = length, returns next row start in de
;sets [_tb_found_col] if [_tb_find] is in the row and [_tb_found_col] is $FF
TBScanRow:
  ST_DE_VAR tb_row_start
  call TBReadSeek
  xor a
  ld [tb_x], a
  ld [tb_row_chars], a
  ld b, 0;column
  ld c, 0;column after last space
.loop
    ld a, b
    cp a, TB_STRIDE
    jr z, .full
    call TBCheckEnd
    jr z, .end
    ld a, [hl];next char
    cp a, ASCII_LF
    jr z, .fits
    call TBCharWidth
    push bc
    ld b, a
    ld a, [tb_x]
    add a, b
    pop bc
    cp a, TB_WIDTH+1
    jr nc, .full
  .fits
    call TBCheckFind
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
    call TBCharWidth
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
    jr .loop

.end
  ld a, [_tb_end_row]
  inc a
  jp nz, TBCheckFind
  ld a, [tb_row]
  ld [_tb_end_row], a
  jp TBCheckFind

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
    ld c, b;row ends with a space, no word to wrap
    jr .full

.checkWrap
  ld a, c
  and a
  ret z;no spaces, wrap mid word
  cp a, b
  ret z;row ends with a space

.wrapWord;next row starts after the last space
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
  LD_HL_VAR tb_row_ptr
  ld a, ' '
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
.rowLoop
    call TBStoreRowStart
    call TBScanRow
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
  ld hl, tile_buffer+TB_STRIDE
  ld de, tile_buffer
  call mem_Copy
  ld a, [_tb_rows]
  add a, a
  ld c, a
  ld b, 0
  ld hl, _tb_row_starts+2
  ld de, _tb_row_starts
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
  call TBCopyBack
  ld a, [_tb_rows]
  add a, a
  ld c, a
  ld b, 0
  ld hl, _tb_row_starts-1
  add hl, bc;last byte of starts[rows - 1]
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

;stores de in _tb_row_starts[tb_row], only affects a, hl
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
  ret
