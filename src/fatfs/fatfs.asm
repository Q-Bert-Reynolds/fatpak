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

SECTION "FatFs Stubs", ROM0
_FileMount::     BANKED_C _fs_Mount
_FileList::      BANKED_C _fs_List
_FileListEntry:: BANKED_C _fs_ListEntry
_FileLoad::      BANKED_C _fs_Load
_FileSave::      BANKED_C _fs_Save
IF DEF(EVERDRIVE_OS)
_FileLoadData::  BANKED_C _fs_LoadData

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
