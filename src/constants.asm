; ram banks 
DEF MAIN_SRAM_BANK EQU 240;PSRAM blocks 240-255 hold settings and the clipboard

; sprite props
DEF FLIP_X_PAL  EQU (OAMF_XFLIP | OAMF_PAL1 )
DEF FLIP_Y_PAL  EQU (OAMF_YFLIP | OAMF_PAL1 )
DEF FLIP_XY_PAL EQU (FLIP_X_PAL | FLIP_Y_PAL)
DEF FLIP_XY     EQU (OAMF_XFLIP | OAMF_YFLIP)

; sprite draw flags
DEF SPRITE_FLAGS_SKIP      EQU %00000001
DEF SPRITE_FLAGS_CLEAR_END EQU %00000010

; ui draw flags
DEF DRAW_FLAGS_BKG      EQU %00000000
DEF DRAW_FLAGS_WIN      EQU %00000001
DEF DRAW_FLAGS_PAD_TOP  EQU %00000010
DEF DRAW_FLAGS_NO_SPACE EQU %00000100

;text buffer
;PSRAM through the 512 byte window at $BE00, $BD03 = 1 (128KB-256KB), blocks are banks
DEF TB_BANKS     EQU 127;blocks 0-126, positions are 16 bit
DEF TB_BANK_SIZE EQU $0200
DEF TB_BASE      EQU $BE00
DEF TB_PSRAM_HIGH EQU 1;$BD03
DEF UNDO_BANK    EQU 128;undo log in blocks 128-239
DEF UNDO_BANKS   EQU 112
;the data file in protected PSRAM from $3D00, above ROMs and snapshot staging
DEF DATA_BLOCK         EQU $3D00;$BD03:$BD02
DEF DATA_FONTS         EQU 1;the styled fonts (FontStyles order), 2KB each
DEF DATA_BORDER_TILES  EQU 41;the SGB border's 8KB of tiles
DEF DATA_BORDER_MAP    EQU 57;its map and palettes, 4KB
DEF DATA_FIXED         EQU 65;the base fixed font, four blocks
DEF DATA_HELP          EQU 69;two 32-line help screens, 32 bytes per line
DEF DATA_MONO          EQU 73;base monospaced glyphs, four blocks
DEF DATA_SHIFTS        EQU 77;seven blocks, paired right/left shift tables
DEF DATA_WIDTHS        EQU 84;VWF bold widths, 256 bytes
DEF DATA_BLOCKS        EQU 85
DEF DATA_VERSION       EQU 5;block 0 starts with "EDITOR.DAT" and this
DEF NAME_HISTORY_BLOCK EQU DATA_BLOCK+DATA_BLOCKS;16 scratch blocks, separate from document undo
DEF WIN_SIZE           EQU $C000;the part of a large file in the text buffer (src/fatfs/fatfs.c)
DEF WIN_CHUNKS         EQU WIN_SIZE/512+1;sector boundaries in it
DEF MAX_PIECES         EQU 96;a large file's piece table (src/fatfs/fatfs.c)
DEF ADD_BLOCK          EQU $0400;text added to a large file, PSRAM 512KB up to the save states at $3E40
DEF ADD_MAX            EQU $720000;stop before the protected EDITOR.DAT region
DEF TB_SIZE      EQU (TB_BANK_SIZE*TB_BANKS)
DEF TB_CLIP_OFFSET EQU $0100;the clipboard's text in PSRAM blocks 240-255 (src/sram.asm)
DEF TB_CLIP_SIZE EQU ($2000-TB_CLIP_OFFSET)
DEF UNDO_SIZE    EQU (TB_BANK_SIZE*UNDO_BANKS)
DEF FOOTER_MARKER EQU $7F;private clock alignment marker, separate from button icons
DEF TB_COLS   EQU 20;tiles per row
DEF TB_ROWS   EQU 18
DEF TB_WIDTH  EQU TB_COLS*8;pixels per row
DEF TB_STRIDE EQU 40;characters per row in tile_buffer
DEF BOX_STRIDE EQU 20;characters per line of the menu box's text, 0 ends a line
DEF HEADER_LINE EQU TB_ROWS;tile_buffer rows of the file name and status bars
DEF STATUS_LINE EQU (TB_ROWS + 1)

;loadable modules (src/modules, notes/MODULES.md); module_build.py and
;check_module_abi.py read these too
DEF MODULE_PAGE    EQU 13;the OS page a module borrows
DEF MODULE_STAGE   EQU $3D80;PSRAM: the validated module page, 15 blocks
DEF MODULE_BACKUP  EQU $3D90;PSRAM: the borrowed OS page, 15 blocks
;wide modules (MODULE_FORMAT_WIDE) borrow a second and maybe a third page and keep their BSS in the
;editor's WRAMX buffers
DEF MODULE_PAGE2   EQU 12
DEF MODULE_PAGE3   EQU 5
DEF MODULE_PAGE4   EQU 4
DEF MODULE_STAGE2  EQU $3DA0;MODULE_STAGE + $20 per page: ModuleSwap adds $20 for the second, $40 for the third
DEF MODULE_BACKUP2 EQU $3DB0
DEF MODULE_STAGE3  EQU $3DC0
DEF MODULE_BACKUP3 EQU $3DD0
DEF MODULE_STAGE4  EQU $3DE0
DEF MODULE_BACKUP4 EQU $3DF0
DEF MODULE_BSS     EQU $D000;tile_buffer: the editor's buffers, saved to PSRAM meanwhile (src/wram.asm)
DEF MODULE_BSS_SIZE EQU 3072;6 blocks
DEF MODULE_BSS_BACKUP EQU $3D68;below the staging blocks: $3E00 and up broke the cart on hardware (2026-11-12)
DEF MODULE_FAIL_BLOCK EQU $3D6E;a restore that never read back, recorded before restarting (ShowModuleRestart)
DEF MODULE_SOURCE_CHUNK EQU 128;bytes ModSource copies at most
;ASM.MOD (modules/asm.c): inside the large-file add buffer, so only text-buffer documents assemble
DEF ASM_IMAGE_BLOCK  EQU $0400;the ROM image, up to ASM_IMAGE_BLOCKS
DEF ASM_IMAGE_BLOCKS EQU 2048;1 MiB, 64 banks
DEF ASM_SYMBOL_BLOCK EQU $0C00;the symbol table, 1024 blocks (65536 8-byte units); the first holds the 256 hash heads
DEF ASM_HEAP_BLOCK   EQU $1000;the EQUS heap, 128 blocks (64 KiB)
DEF ASM_CHARMAP_BLOCK EQU $1080;names, 8 maps' heads, then a 60 KiB pool (129 blocks)
DEF ASM_SECTION_BLOCK EQU $1110;the section table, 32 blocks (512 32-byte records)
DEF ASM_FILE_BLOCK   EQU $1130;included and INCBIN files, packed whole from here
DEF ASM_FILE_END     EQU $3900;ADD_MAX / 512: up to the add buffer's end
DEF MODULE_ABI     EQU 7;newest ABI the host provides, modules built for older ones still load
DEF MODULE_TABLE   EQU $7F00;ABI jump table in resident bank 1, 3 bytes per entry
DEF MODULE_SLOTS   EQU 32;entries reserved for it
DEF MODULE_FORMAT  EQU 1;one page, BSS after the code
DEF MODULE_FORMAT_WIDE EQU 2;pages MODULE_PAGE and MODULE_PAGE2, BSS at MODULE_BSS
DEF MODULE_HEADER  EQU 32;bytes before the payload
DEF MODULE_H_FORMAT   EQU 4;header offsets, after the "FPKM" magic
DEF MODULE_H_ABI      EQU 5;ABI the module needs
DEF MODULE_H_ID       EQU 6
DEF MODULE_H_PAGE     EQU 7
DEF MODULE_H_ADDRESS  EQU 8;16 bit fields are little endian
DEF MODULE_H_ENTRY    EQU 10;offset into the payload
DEF MODULE_H_LENGTH   EQU 12;payload bytes
DEF MODULE_H_BSS      EQU 14;offset, at or after the payload
DEF MODULE_H_BSS_SIZE EQU 16
DEF MODULE_H_CRC      EQU 18;CRC-16/CCITT of the payload (both pages' for wide modules), initial $FFFF
DEF MODULE_H_PAGE2    EQU 20;wide modules: the second page and its payload bytes, which follow the first's
DEF MODULE_H_LENGTH2  EQU 21
DEF MODULE_H_PAGE3    EQU 23;a third page and its bytes, which follow the second's; both 0 without one
DEF MODULE_H_LENGTH3  EQU 24
DEF MODULE_H_PAGE4    EQU 26;and a fourth: each extra page is a 3-byte record (page, length) from MODULE_H_PAGE2
DEF MODULE_H_LENGTH4  EQU 27
DEF MODULE_H_RESERVED EQU 29;zero up to MODULE_HEADER
DEF MODULE_PAGES_MAX EQU 4
DEF MODULE_ERR_ABI    EQU 20;RunModule results past FatFs's FRESULT codes
DEF MODULE_ERR_VERIFY EQU 21;a page copy didn't read back

;fonts
DEF FONT_MONO EQU 0
DEF FONT_VWF  EQU 1
DEF FONT_FIXED EQU 2;4 pixel fixed width, for text
DEF FONT_H1    EQU 3;markdown headings 1-4: the fixed font 1 pixel taller, stretched with 2 pixel strokes (8, 7, 6, 5 pixel cells)
DEF FONT_H4    EQU 6

;text styles (TBLex): a byte per character in tile_attrs, its width in pixels in the low 4 bits
;and its style in the high 4, StyleLooks has what each style looks like
DEF STYLE_WIDTH       EQU %00001111
DEF STYLE_TEXT        EQU 0
DEF STYLE_BOLD        EQU 1
DEF STYLE_ITALIC      EQU 2
DEF STYLE_BOLD_ITALIC EQU 3
DEF STYLE_MARK        EQU 4;markdown markers (#, *, _, `)
DEF STYLE_CODE        EQU 5;`code`
DEF STYLE_HEAD        EQU 6;headings 1-4 (their fonts are bold)
DEF STYLE_HEAD_BOLD   EQU 7;headings 5 and 6
DEF STYLE_COMMENT     EQU 8;code (TBLexCode)
DEF STYLE_KEYWORD     EQU 9;C keywords, asm instructions
DEF STYLE_TYPE        EQU 10;C types, asm registers and conditions
DEF STYLE_STRING      EQU 11;strings and chars
DEF STYLE_NUMBER      EQU 12;numbers and constants
DEF STYLE_PREPROC     EQU 13;C preprocessor, asm directives
DEF STYLE_LABEL       EQU 14;asm labels
DEF LOOK_BOLD   EQU %00000001;ORed 1 pixel right (stretched in the fixed font), wider
DEF LOOK_ITALIC EQU %00000010;top half shifted 1 pixel right
DEF LOOK_DIM    EQU %00000100;dim ink: dark grey on DMG, color 2 on SGB and GBC
DEF LOOK_ACCENT EQU %00001000;GBC: accent ink, color 1 of the palette in bits 4-6
DEF LANG_PLAIN   EQU 0;how text is styled, from the file name's extension
DEF LANG_MD      EQU 1
DEF LANG_C       EQU 2;.c, .h
DEF LANG_ASM     EQU 3;.asm, .inc, .s (RGBDS)
DEF PATH_SIZE    EQU 128;the open file's folder (file_dir)
DEF FS_NAME_SIZE EQU 65;src/fatfs/file_api.h

;on screen keyboard
DEF OSK_COLS    EQU 10
DEF OSK_ROWS    EQU 5
DEF OSK_INSET   EQU 4
DEF OSK_LOWER   EQU 0
DEF OSK_SHIFT   EQU 1
DEF OSK_SYMBOLS EQU 2
DEF OSK_CAPS    EQU 3;caps lock: the shift layout, kept after typing
DEF ASCII_TAB EQU 9
DEF ASCII_LF  EQU 10
DEF ASCII_CR  EQU 13

;key events, printable keys use their character code
DEF PAD_REPEAT_DELAY EQU 20;frames before a held d-pad button or arrow key repeats
DEF PAD_REPEAT_RATE  EQU 4;frames between repeats

DEF KEY_NONE      EQU 0
DEF KEY_BACKSPACE EQU 8
DEF KEY_TAB       EQU 9
DEF KEY_ENTER     EQU 10
DEF KEY_ESCAPE    EQU 27
DEF KEY_DELETE    EQU 127
DEF KEY_LEFT      EQU $80
DEF KEY_RIGHT     EQU $81
DEF KEY_UP        EQU $82
DEF KEY_DOWN      EQU $83
DEF KEY_HOME      EQU $84
DEF KEY_END       EQU $85
DEF KEY_PAGE_UP   EQU $86
DEF KEY_PAGE_DOWN EQU $87
DEF KEY_INSERT    EQU $88
DEF KEY_MENU      EQU $89;file menu (Escape, on screen keyboard)
DEF KEY_UNDO      EQU $8A
DEF KEY_REDO      EQU $8B
DEF KEY_INFO      EQU $8C;Select in the file browser
DEF KEY_F1        EQU $90;function keys are KEY_F1 + n - 1
DEF KEY_F2        EQU $91
DEF KEY_F3        EQU $92
DEF KEY_F4        EQU $93
DEF KEY_F5        EQU $94
DEF KEY_F6        EQU $95
DEF KEY_F7        EQU $96
DEF KEY_F8        EQU $97
DEF KEY_F9        EQU $98
DEF KEY_F10       EQU $99
DEF KEY_F11       EQU $9A
DEF KEY_F12       EQU $9B

;kb_modifiers
DEF KB_MOD_SCROLL_LOCK EQU %00000001;same as PS2_LED_SCROLL_LOCK
DEF KB_MOD_NUM_LOCK    EQU %00000010;same as PS2_LED_NUM_LOCK
DEF KB_MOD_CAPS_LOCK   EQU %00000100;same as PS2_LED_CAPS_LOCK
DEF KB_MOD_SUPER       EQU %00001000
DEF KB_MOD_ALT         EQU %00010000
DEF KB_MOD_CTRL        EQU %00100000
DEF KB_MOD_SHIFT       EQU %01000000
DEF KB_MOD_FUNCTION    EQU %10000000

;sizes
DEF STACK_SIZE       EQU 1024;FatFs needs a deep stack
DEF NAME_LENGTH      EQU 8
DEF NAME_BUFFER_SIZE EQU 16
DEF STR_BUFFER_SIZE  EQU 64
DEF BUFFER_SIZE      EQU 1024;32x32 tiles

;notes
DEF C2      EQU 44
DEF Db2     EQU 156
DEF D2      EQU 262
DEF Eb2     EQU 363
DEF E2      EQU 457
DEF F2      EQU 547
DEF Gb2     EQU 631
DEF G2      EQU 710
DEF Ab2     EQU 786
DEF A2      EQU 854
DEF Bb2     EQU 923
DEF B2      EQU 986
DEF C3      EQU 1046
DEF Db3     EQU 1102
DEF D3      EQU 1155
DEF Eb3     EQU 1205
DEF E3      EQU 1253
DEF F3      EQU 1297
DEF Gb3     EQU 1339
DEF G3      EQU 1379
DEF Ab3     EQU 1417
DEF A3      EQU 1452
DEF Bb3     EQU 1486
DEF B3      EQU 1517
DEF C4      EQU 1546
DEF Db4     EQU 1575
DEF D4      EQU 1602
DEF Eb4     EQU 1627
DEF E4      EQU 1650
DEF F4      EQU 1673
DEF Gb4     EQU 1694
DEF G4      EQU 1714
DEF Ab4     EQU 1732
DEF A4      EQU 1750
DEF Bb4     EQU 1767
DEF B4      EQU 1783
DEF C5      EQU 1798
DEF Db5     EQU 1812
DEF D5      EQU 1825
DEF Eb5     EQU 1837
DEF E5      EQU 1849
DEF F5      EQU 1860
DEF Gb5     EQU 1871
DEF G5      EQU 1881
DEF Ab5     EQU 1890
DEF A5      EQU 1899
DEF Bb5     EQU 1907
DEF B5      EQU 1915
DEF C6      EQU 1923
DEF Db6     EQU 1930
DEF D6      EQU 1936
DEF Eb6     EQU 1943
DEF E6      EQU 1949
DEF F6      EQU 1954
DEF Gb6     EQU 1959
DEF G6      EQU 1964
DEF Ab6     EQU 1969
DEF A6      EQU 1974
DEF Bb6     EQU 1978
DEF B6      EQU 1982
DEF C7      EQU 1985
DEF Db7     EQU 1988
DEF D7      EQU 1992
DEF Eb7     EQU 1995
DEF E7      EQU 1998
DEF F7      EQU 2001
DEF Gb7     EQU 2004
DEF G7      EQU 2006
DEF Ab7     EQU 2009
DEF A7      EQU 2011
DEF Bb7     EQU 2013
DEF B7      EQU 2015

;Noise Shift Clock
DEF NOISE_DIV_2   EQU $00
DEF NOISE_DIV_4   EQU $10
DEF NOISE_DIV_8   EQU $20
DEF NOISE_DIV_16  EQU $30
DEF NOISE_DIV_32  EQU $40
DEF NOISE_DIV_64  EQU $50
DEF NOISE_DIV_128 EQU $60
DEF NOISE_DIV_256 EQU $70
DEF NOISE_DIV_512 EQU $80
DEF NOISE_DIV_1K  EQU $90
DEF NOISE_DIV_2K  EQU $A0
DEF NOISE_DIV_4K  EQU $B0
DEF NOISE_DIV_8K  EQU $C0
DEF NOISE_DIV_16K EQU $D0

;Periodic Noise (15 counter steps)
DEF NOISE_STUTTER    EQU $0 ;A square plus a pulse at random pulse widths
DEF NOISE_RUMBLE     EQU $1 ;The same waveform but faster
DEF NOISE_ENGINE     EQU $2 ;The same waveform but even faster
DEF NOISE_LOW_TONE   EQU $3 ;Sounds like D5
DEF NOISE_UNDERTONE  EQU $4 ;Sounds like E5 + 50cents
DEF NOISE_MIDDLETONE EQU $5 ;Sounds like B5 + 50cents
DEF NOISE_OVERTONE   EQU $6 ;Sounds like D6 + 50cents
DEF NOISE_HIGH_TONE  EQU $7 ;Sounds like D7

;Pseudorandom Noise (7 counter steps)
DEF NOISE_EARTHQUAKE EQU $8 ;A square with a thin pulse at random pulse widths
DEF NOISE_SPACESHIP  EQU $9 ;The same waveform but faster
DEF NOISE_OCEAN      EQU $A ;The same waveform but even faster
DEF NOISE_SCRATCH    EQU $B ;You get the idea
DEF NOISE_GLITCH     EQU $C ;A fairly clean white-noise sample, unrelated to other instruments
DEF NOISE_VOLCANO    EQU $D ;A pulse with rapidly changing pulse width
DEF NOISE_SCREAM     EQU $E ;The same waveform but faster
DEF NOISE_STATIC     EQU $F ;The same waveform but even faster
