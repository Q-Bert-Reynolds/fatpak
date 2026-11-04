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
_FileScanStep::  BANKED_C _fs_ScanStep
_FileCommitWindow:: BANKED_C _fs_CommitWindow
_FileSaveLarge:: BANKED_C _fs_SaveLarge
_FileBackupSave:: BANKED_C _fs_BackupSave
_FileLoadGame::  BANKED_C _fs_LoadGame


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
;A large file (src/fatfs/fatfs.c), positions are 32 bit file offsets
SECTION "Large File Vars", ROM0, ALIGN[8, $E0];the OS image is RAM, the alignment keeps it out of the RST vectors
_doc_large:: DS 1;a large file is open, the text buffer is a window into it
_lines_known:: DS 1;win_lines is the line feeds before win_start (else before it from scan_target, see editor.c)
_win_chunks:: DS 1;win_kept entries
_doc_len:: DS 4;the file's size
_doc_pos:: DS 4;fs_DocLineStart's offset
_doc_back:: DS 2;window positions fs_DocLineStart moved back
_win_start:: DS 4;offset of the text buffer's start
_win_end:: DS 4;and its end
_win_mark:: DS 4;fs_LoadWindow finds this offset's window position
_win_mark_pos:: DS 2
_win_lines:: DS 4;line feeds before win_start
_scan_pos:: DS 4;counting line feeds from the start to scan_target in the background
_scan_target:: DS 4
_scan_lines:: DS 4
_win_kept:: DS 2*WIN_CHUNKS;window position of each 512 byte boundary of the document in the window
_win_edited:: DS 1;the window changed since it was loaded (TBEdited)
_piece_count:: DS 1
_piece_i:: DS 1;the piece DocRead found last
_piece_start:: DS 4;and its document offset
_add_len:: DS 4;bytes in the add buffer
_save_file:: DS 64;a FIL for saving a large file and games' saves (fatfs.c checks the size)
_game_mapper:: DS 1;GameLaunch's $BD07, $BD04 and $BD05 (fs_LoadGame)
_game_rom_mask:: DS 1
_game_ram_mask:: DS 1

PAGE DOC_PAGE
_pieces:: DS 9*MAX_PIECES;source (0 = the file, 1 = the add buffer), offset, length (fatfs.c)

_CountLF::;de = data, bc = count, returns the line feeds in it in bc (two bytes a loop, ~8 M-cycles a byte)
  ld h, d
  ld l, e
  ld de, 0
  srl b
  rr c;pairs
  jr nc, .pairs
  ld a, [hli]
  cp a, ASCII_LF
  jr nz, .pairs
  inc de
.pairs
  inc b
  inc c
  jr .start
.loop
    ld a, [hli]
    cp a, ASCII_LF
    jr z, .lf1
  .second
    ld a, [hli]
    cp a, ASCII_LF
    jr z, .lf2
.start
    dec c
    jr nz, .loop
    dec b
    jr nz, .loop
  ld b, d
  ld c, e
  ret
.lf1
  inc de
  jr .second
.lf2
  inc de
  jr .start
END_PAGE
ENDC

IF DEF(EVERDRIVE_OS)
FIXED "Game Launch"
;resets the Game Boy into the game fs_LoadGame copied to PSRAM, like the EverDrive's OS: $BD06 bit 3 makes the
;cart reset it through the boot ROM after the mapper is written (bit 2 switches without it). The MBC writes
;land in the OS image's RAM, the routine mustn't be at $2000-$2100, $3000, $4000 or $6000
_GameLaunch::
  di
  ld a, [_game_rom_mask]
  ld [$BD04], a
  ld a, [_game_ram_mask]
  ld [$BD05], a
  ld a, [EDX_CONFIG]
  and a, $20
  or a, $08
  ld [EDX_CONFIG], a
  xor a
  ld [$BD09], a
  ld [rRAMG], a
  ld [$3000], a
  ld [rRAMB], a
  ld [$6000], a
  inc a
  ld [$2100], a
  ld [$2000], a
  ld a, [_game_mapper]
  ld [$BD07], a
.wait
  jr .wait
GameLaunchEnd:
ASSERT _GameLaunch > $4000 && GameLaunchEnd <= $6000 || _GameLaunch > $6000

_Reboot::;starts the OS again (after a failed game load, the text comes back from the swap file)
  di
  ld a, FIRST_PAGE
  ld [EDX_PAGE], a
  jp $0100
ENDC
