INCLUDE "src/text_editor.inc"

;FatFs lives in its own bank (src/fatfs/fatfs.c), C in other banks calls it through these
;C functions (src/editor/editor.h)
;   FileMount                   returns FRESULT in a
;   FileOpenDir                 returns FRESULT in a
;   FileNext                    de = 13 byte name buffer, returns a = 0 when there are no more .TXT files
;   FileLoad                    de = name, replaces the text buffer, returns FRESULT in a
;   FileSave                    de = name, returns FRESULT in a

SECTION "FatFs Stubs", ROM0
_FileMount::   BANKED_C _fs_Mount
_FileOpenDir:: BANKED_C _fs_OpenDir
_FileNext::    BANKED_C _fs_NextFile
_FileLoad::    BANKED_C _fs_Load
_FileSave::    BANKED_C _fs_Save

INCLUDE "src/fatfs/_fatfs.asm";generated from fatfs.c
