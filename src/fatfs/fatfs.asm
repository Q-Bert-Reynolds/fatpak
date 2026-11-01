INCLUDE "src/text_editor.inc"

;FatFs lives in its own bank (src/fatfs/fatfs.c), C in other banks calls it through these
;C functions (src/editor/editor.h)
;   FileMount                   returns FRESULT in a
;   FileOpenDir                 de = UTF-8 path ("" = root), returns FRESULT in a
;   FileNext                    de = FileEntry (src/fatfs/file_api.h), returns a = 0 when there are no more
;   FileLoad                    de = path, replaces the text buffer, returns FRESULT in a
;   FileSave                    de = path, returns FRESULT in a

SECTION "FatFs Stubs", ROM0
_FileMount::   BANKED_C _fs_Mount
_FileOpenDir:: BANKED_C _fs_OpenDir
_FileNext::    BANKED_C _fs_NextEntry
_FileLoad::    BANKED_C _fs_Load
_FileSave::    BANKED_C _fs_Save

INCLUDE "src/fatfs/_fatfs.asm";generated from fatfs.c
