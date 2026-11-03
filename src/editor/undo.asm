;Undo log copying, in undo.c's bank. The log is a ring of UNDO_SIZE bytes in SRAM banks UNDO_BANK and up,
;laid out like the text buffer (offsets skip $BD00-$BD0F in each bank, see TBPhysRunFrom)
;C functions (src/editor/undo.c)
;   log_Write                   de = buffer, bc = count, copies to the log at log_ptr, advances it
;   log_Read                    de = buffer, bc = count, copies from the log at log_ptr, advances it
;   log_SaveText                de = text position, bc = count, copies text to the log at log_ptr
;   log_RestoreText             de = text position, bc = count, inserts text from the log at log_ptr (it must fit)
;C functions (src/editor/editor.h), stubs into undo.c's bank
;   UndoClear, UndoInserted, UndoDeleting, UndoSaved, Undo, Redo

SECTION "Undo Stubs", ROM0
_UndoClear::    BANKED_C _undo_Clear
_UndoInserted:: BANKED_C _undo_Inserted
_UndoDeleting:: BANKED_C _undo_Deleting
_UndoSaved::    BANKED_C _undo_Saved
_Undo::         BANKED_C _undo_Undo
_Redo::         BANKED_C _undo_Redo

SECTION "Undo Vars", WRAM0
_log_ptr:: DW;log offset
log_buf: DW
log_left: DW
log_read: DB;log_Read
log_restore: DB;log_RestoreText

SECTION FRAGMENT "src/editor/undo.c_CODE", ROMX

_log_Write::
  xor a
  jr LogCopy
_log_Read::
  ld a, 1
LogCopy:
  ld [log_read], a
  ST_DE_VAR log_buf
  ld a, c
  ld [log_left], a
  ld a, b
  ld [log_left+1], a
  SRAM_ON
.run;up to the register hole or the bank end
    LD_HL_VAR log_left
    ld a, h
    or a, l
    jr z, .done
    push hl
    LD_HL_VAR _log_ptr
    ld b, UNDO_BANK
    call TBPhysRunFrom
    ld a, b
    ld [rRAMB], a
    ld b, h
    ld c, l;SRAM address
    pop hl
    call TBMin
    push hl;bytes this run
    LD_DE_VAR log_buf
    ld a, [log_read]
    and a
    jr z, .write
    ld h, b
    ld l, c
    jr .copy
.write
    ld h, d
    ld l, e
    ld d, b
    ld e, c
.copy
    pop bc
    push bc
    call mem_Copy
    pop bc
    LD_HL_VAR log_buf
    add hl, bc
    ST_HL_VAR log_buf
    LD_HL_VAR _log_ptr
    add hl, bc
    ld a, l
    cp a, LOW(UNDO_SIZE)
    jr nz, .noWrap
    ld a, h
    cp a, HIGH(UNDO_SIZE)
    jr nz, .noWrap
    ld hl, 0
.noWrap
    ST_HL_VAR _log_ptr
    ld hl, log_left
    ld a, [hl]
    sub a, c
    ld [hli], a
    ld a, [hl]
    sbc a, b
    ld [hl], a
    jr .run
.done
  SRAM_OFF
  ret

_log_SaveText::
  ST_DE_VAR _tb_read_pos
  xor a
  jr LogText
_log_RestoreText::
  push bc
  SRAM_ON
  call TBMoveGap
  pop bc
  ld a, 1
LogText:;bc = count, TB_CHUNK at a time through win_buffer
  ld [log_restore], a
.loop
    ld a, b
    or a, c
    ret z
    ld h, b
    ld l, c
    ld de, TB_CHUNK
    call TBMin
    push bc
    push hl
    ld b, h
    ld c, l
    ld de, win_buffer
    ld a, [log_restore]
    and a
    jr nz, .restore
    call _tb_Read
    pop bc
    push bc
    ld de, win_buffer
    call _log_Write
    jr .next
.restore
    call _log_Read
    pop bc
    push bc
    ld de, win_buffer
    call _tb_Append
.next
    pop de
    pop hl
    ld a, l
    sub a, e
    ld c, a
    ld a, h
    sbc a, d
    ld b, a
    jr .loop
