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
_FileGameOpen::  BANKED_C _fs_GameOpen
_FileGameCopy::  BANKED_C _fs_GameCopy
_FileGameFinish:: BANKED_C _fs_GameFinish


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
_game_config:: DS 1;GameLaunch's $BD06 and $BD20 (0 = not written), from the EverDrive OS's registry (RegistrySum)
_game_bd20:: DS 1
_game_banks:: DS 1;its save RAM banks, 0 = no battery
_game_block:: DS 2;fs_GameCopy's progress
_game_blocks:: DS 2
_game_clst:: DS 4;the next cluster it copies
_backup_skipped:: DS 1;fs_BackupSave didn't trust the save RAM (src/fatfs/fatfs.c)
_sd_fast:: DS 1;sd_ReadBlocks reads like the EverDrive's OS (src/editor/sd.asm)

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
PAGE LAUNCH_PAGE
;resets the Game Boy into the game fs_LoadGame copied to PSRAM, like the EverDrive's OS: $BD06 bit 3 makes the
;cart reset it through the boot ROM after the mapper is written (bit 2 switches without it). The MBC writes
;land in the OS image's RAM ($0000, $2000, $2100, $3000, $4000, $6000). The last part runs from
;HRAM (LaunchStub): no game code runs before the reset, and if none comes in about half a second the game
;starts at $0100 without the boot ROM (A = $11, a GBC)
DEF LAUNCH_HRAM EQU $FF80
_GameLaunch::
  di
IF !DEF(BISECT_LAUNCH)
  call gbdk_CPUSlow;normal speed like the EverDrive OS's launch (the cart doesn't reset the CPU's speed)
  ld a, 1;the EverDrive OS's launch: $01F0 = 1, $01F3 = 1 if the game has save RAM (the cart may read them
  ld [$01F0], a;for its in-game menu)
  ld a, [_game_ram_mask]
  and a
  jr z, .noRam
  ld a, 1
.noRam
  ld [$01F3], a
  ld a, $A5;the card back to idle like the EverDrive OS's launch (CMD0, deselected): it leaves it uninitialized
  ld [EDX_KEY], a
  ld hl, sd_arg
  xor a
  ld [hli], a
  ld [hli], a
  ld [hli], a
  ld [hl], a
  ld a, SD_CMD0
  call SDCommand
  call SDDeselect
ENDC
  ld a, [_game_rom_mask]
  ld [$BD04], a
  ld a, [_game_ram_mask]
  ld [$BD05], a
  ld a, [_game_bd20]
  and a
  jr z, .config
  ld [$BD20], a
.config
  ; Patch while OS mode is still established, before launch config/MBC writes.
  ld hl, $0041
  ld [hl], LOW(InGameEntry)
  inc l
  ld [hl], HIGH(InGameEntry)
  ; A warm return keeps the live OS image. Preserve bytes before mapper writes
  ; so restarting the editor does not execute modified resident instructions.
  ld a, [$0000]
  ld [ingame_os_bytes+0], a
  ld a, [$2000]
  ld [ingame_os_bytes+1], a
  ld a, [$2100]
  ld [ingame_os_bytes+2], a
  ld a, [$3000]
  ld [ingame_os_bytes+3], a
  ld a, [$4000]
  ld [ingame_os_bytes+4], a
  ld a, [$6000]
  ld [ingame_os_bytes+5], a
  ld a, [_game_config]
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
  ld hl, LaunchStub;the wait runs from HRAM: the game's ROM is in at once, the reset may come later
  ld c, LOW(LAUNCH_HRAM)
.copy
    ld a, [hli]
    ldh [c], a
    inc c
    ld a, c
    cp a, LOW(LAUNCH_HRAM) + LaunchStubEnd - LaunchStub
    jr nz, .copy
  ld bc, 0
  ld a, [_game_mapper]
  jp LAUNCH_HRAM
ASSERT BANK(_GameLaunch) == BANK(_LaunchGame), "LaunchGame calls it in its page"

SECTION "Launch Stub", ROM0[$01E0];copied to LAUNCH_HRAM, a = mapper, bc = 0
LaunchStub:
  ld [$BD07], a
.wait
    dec bc
    ld a, b
    or a, c
    jr nz, .wait
  ld a, $11
  jp $0100
LaunchStubEnd:

SECTION "Reboot", ROM0

_Reboot::;starts the OS again (after a failed game load, the text comes back from the swap file)
  di
  ld a, FIRST_PAGE
  ld [EDX_PAGE], a
  jp $0100
ENDC
