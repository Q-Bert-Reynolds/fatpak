INCLUDE "src/text_editor.inc"

;FatFs lives in its own bank (src/fatfs/fatfs.c), C in other banks calls it through these
;C functions (src/editor/editor.h)
;   FileMount                   mounts the card if it isn't, returns FRESULT in a
;   FileList                    de = UTF-8 path ("" = root), bc = name of a folder in it to find or 0,
;                               lists it for FileListEntry (sets fs_count and fs_found), returns FRESULT in a
;   FileListEntry               de = index, bc = FileEntry (src/fatfs/file_api.h), returns FRESULT in a
;   FileLoad                    de = path, replaces the text buffer, returns FRESULT in a
;   FileSave                    de = path, returns FRESULT in a
;   FileLoadData                de = path, OS mode: copies the data file to PSRAM, returns FRESULT in a
;   FileSaveSwap                OS mode: writes the text, clipboard and settings to the swap file, returns FRESULT in a
;   FileLoadSwap                OS mode: restores them at boot if PSRAM lost them, returns FRESULT in a

SECTION "FatFs Stubs", ROM0
_FileMount::     BANKED_C _fs_Mount
_FileList::      BANKED_C _fs_List
_FileListEntry:: BANKED_C _fs_ListEntry
_FileLoad::      BANKED_C _fs_Load
_FileSave::      BANKED_C _fs_Save
IF DEF(EVERDRIVE_OS)
_FileLoadData::  BANKED_C _fs_LoadData
_FileSaveSwap::  BANKED_C _fs_SaveSwap
_FileLoadSwap::  BANKED_C _fs_LoadSwap
_FileLoadLarge:: BANKED_C _fs_LoadLarge
_FileLoadWindow:: BANKED_C _fs_LoadWindow
_FileCloseLarge:: BANKED_C _fs_CloseLarge
_DocLineStart::  BANKED_C _fs_DocLineStart

_ByteSum::;de = data, bc = count, returns the sum of the bytes in bc
  ld h, d
  ld l, e
  ld de, 0
  inc b
  inc c
  jr .start
.loop
    ld a, [hli]
    add a, e
    ld e, a
    jr nc, .start
    inc d
.start
    dec c
    jr nz, .loop
    dec b
    jr nz, .loop
  ld b, d
  ld c, e
  ret

_SetWindowBlock::;de = PSRAM block the window at $BE00 shows
  ld a, e
  ld [EDX_BLOCK], a
  ld a, d
  ld [EDX_BLOCK+1], a
  ret

ENDC

;C library functions FatFs uses (SDCC's string.h calls memcpy __memcpy), callers in any bank
;SDCC passes the first two args in de and bc and the third on the stack, which the callee pops

___memcpy::;de = dest, bc = src, [sp+2] = count, returns dest in bc
  push de
  ld hl, sp+4
  ld a, [hli]
  ld h, [hl]
  ld l, a
  push hl
  ld h, b
  ld l, c
  pop bc;count
  call mem_Copy
  jr CReturnDest

_memset::;de = dest, c = value, [sp+2] = count, returns dest in bc
  push de
  ld hl, sp+4
  ld a, c
  ld c, [hl]
  inc hl
  ld b, [hl];count
  ld h, d
  ld l, e
  call mem_Set
  ;fall through

CReturnDest:;returns the dest pushed on entry in bc, pops the stack arg
  pop bc
  pop hl
  inc sp
  inc sp
  jp hl

_memcmp::;de = a, bc = b, [sp+2] = count, returns a[i] - b[i] at the first difference (or 0) in bc
  ld hl, sp+2
  ld a, [hli]
  ld h, [hl]
  ld l, a
  push hl
  ld h, b
  ld l, c
  pop bc;count
  inc b
  inc c
  jr .start
.loop
    ld a, [de]
    sub a, [hl]
    jr nz, .differ
    inc de
    inc hl
.start
    dec c
    jr nz, .loop
    dec b
    jr nz, .loop
  ld bc, 0
  jr .return
.differ
  ld c, a
  sbc a, a
  ld b, a
.return
  pop hl
  inc sp
  inc sp
  jp hl

_strchr::;de = string, c = char, returns the first c in it (its 0 if c is 0) or 0 in bc
  ld h, d
  ld l, e
.loop
    ld a, [hl]
    cp a, c
    jr z, .found
    inc hl
    and a
    jr nz, .loop
  ld bc, 0
  ret
.found
  ld b, h
  ld c, l
  ret

INCLUDE "src/fatfs/_fatfs.asm";generated from fatfs.c

IF DEF(EVERDRIVE_OS)
;A large file (src/fatfs/fatfs.c): PSRAM from DOC_BLOCK holds the document, positions are 32 bit
SECTION "Large File Vars", ROM0;the OS image is RAM
_doc_large:: DS 1;a large file is open, the text buffer is a window into it
_doc_len:: DS 4
_doc_lines:: DS 4;line feeds in it
_doc_pos:: DS 4;where DocRead reads, fs_DocLineStart's position
_win_start:: DS 4;document position of the text buffer's start
_win_lines:: DS 4;line feeds before it
doc_dropped: DS 2;DocAppend

PAGE DOC_PAGE
;hl = position, sets the window to its block, returns its address in hl, affects a, bc
DocSeek:
  ld a, [hli]
  ld c, a
  ld a, [hli]
  ld b, a
  ld h, [hl]
  ld l, b
  srl h
  rr l;position >> 9
  ld a, l
  ld [EDX_BLOCK], a
  ld a, h
  add a, HIGH(DOC_BLOCK)
  ld [EDX_BLOCK+1], a
  ld a, b
  and a, 1
  add a, HIGH(EDX_WINDOW)
  ld h, a
  ld l, c
  ret

;the next block in the window, returns its start in hl, only affects hl
DocNextBlock:
  ld hl, EDX_BLOCK
  inc [hl]
  jr nz, .same
  inc hl
  inc [hl]
.same
  ld hl, EDX_WINDOW
  ret

;hl = 32 bit variable, adds bc to it, affects a
DocAdd:
  ld a, [hl]
  add a, c
  ld [hli], a
  ld a, [hl]
  adc a, b
  ld [hli], a
  ld a, [hl]
  adc a, 0
  ld [hli], a
  ld a, [hl]
  adc a, 0
  ld [hl], a
  ret

;de = WRAM, bc = count, appends the bytes to the document dropping CRs (sets tb_cr) and 0s,
;counts line feeds in doc_lines (fs_LoadLarge checks the size)
_DocAppend::
  ld a, [EDX_BLOCK+1]
  ld h, a
  ld a, [EDX_BLOCK]
  ld l, a
  push hl
  xor a
  ld [doc_dropped], a
  ld [doc_dropped+1], a
  push bc
  ld hl, _doc_len
  push bc
  call DocSeek
  pop bc
.loop
    ld a, [de]
    inc de
    cp a, ASCII_CR
    jr z, .cr
    and a
    jr z, .drop
    cp a, ASCII_LF
    jr nz, .store
    push hl
    ld hl, _doc_lines
    inc [hl]
    jr nz, .counted
    inc hl
    inc [hl]
    jr nz, .counted
    inc hl
    inc [hl]
  .counted
    pop hl
  .store
    ld [hli], a
    ld a, h
    cp a, HIGH(EDX_WINDOW+$200)
    call z, DocNextBlock
  .next
    dec bc
    ld a, b
    or a, c
    jr nz, .loop
  pop bc;count
  ld hl, doc_dropped
  ld a, c
  sub a, [hl]
  ld c, a
  inc hl
  ld a, b
  sbc a, [hl]
  ld b, a
  ld hl, _doc_len
  call DocAdd
  jr DocRestore
.cr
  ld a, 1
  ld [_tb_cr], a
.drop
  push hl
  ld hl, doc_dropped
  inc [hl]
  jr nz, .dropped
  inc hl
  inc [hl]
.dropped
  pop hl
  jr .next

;de = WRAM, bc = count, copies count bytes of the document from doc_pos, advances it
_DocRead::
  ld a, [EDX_BLOCK+1]
  ld h, a
  ld a, [EDX_BLOCK]
  ld l, a
  push hl
  push bc
  ld hl, _doc_pos
  push bc
  call DocSeek
  pop bc
.loop
    ld a, [hli]
    ld [de], a
    inc de
    ld a, h
    cp a, HIGH(EDX_WINDOW+$200)
    call z, DocNextBlock
    dec bc
    ld a, b
    or a, c
    jr nz, .loop
  pop bc
  ld hl, _doc_pos
  call DocAdd
DocRestore:;the window's block from the stack
  pop hl
  ld a, l
  ld [EDX_BLOCK], a
  ld a, h
  ld [EDX_BLOCK+1], a
  ret
END_PAGE
ENDC
