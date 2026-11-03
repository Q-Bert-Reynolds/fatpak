; tests
DEF TESTS_ENABLED         EQU 0
DEF SOUND_TEST_ENABLED    EQU 0
DEF KEYBOARD_TEST_ENABLED EQU 0
DEF SD_TEST_ENABLED       EQU 0

; game_state masks
DEF GAME_STATE_CLOCK_STARTED   EQU %00000001
DEF GAME_STATE_PAUSED          EQU %00001000

; rom banks
DEF MAX_ROM_BANKS        EQU 64;1MB

; busy spinner (src/interrupts.asm), shown when the main loop hasn't waited for a frame in a while
DEF BUSY_SPRITE EQU 2
DEF BUSY_TILE   EQU 122;sprite tile, the editor's tile blocks don't use 122-127
DEF BUSY_DELAY  EQU 10;frames
DEF BUSY_X      EQU 160;OAM x and y, top right corner
DEF BUSY_Y      EQU 16
DEF BUSY_PALETTE EQU 4;GBC object palette (PaletteSlate), color 2 is dark

; ram banks 
DEF MAX_RAM_BANKS  EQU 16;128KB
DEF MAIN_SRAM_BANK EQU 8;banks 0-7 hold the text buffer

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
DEF TB_BANKS     EQU 8;SRAM banks 0-7, positions are 16 bit
DEF TB_HOLE      EQU $1D00;$BD00-$BD0F are EverDrive registers, never stored to
DEF TB_HOLE_SIZE EQU $10
DEF TB_BANK_SIZE EQU ($2000-TB_HOLE_SIZE)
DEF TB_SIZE      EQU (TB_BANK_SIZE*TB_BANKS)
DEF TB_CLIP_ADDR EQU $A040;clipboard in SRAM bank 8, up to the EverDrive registers at $BD00
DEF TB_CLIP_SIZE EQU ($BD00-TB_CLIP_ADDR-4)
DEF UNDO_BANK    EQU 9;undo log in SRAM banks 9-15, laid out like the text buffer (see src/editor/undo.c)
DEF UNDO_BANKS   EQU 7
DEF UNDO_SIZE    EQU (TB_BANK_SIZE*UNDO_BANKS)
DEF TB_COLS   EQU 20;tiles per row
DEF TB_ROWS   EQU 18
DEF TB_WIDTH  EQU TB_COLS*8;pixels per row
DEF TB_STRIDE EQU 40;characters per row in tile_buffer
DEF BOX_STRIDE EQU 20;characters per line of the menu box's text, 0 ends a line

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
DEF LOOK_BOLD   EQU %00000001;ORed 1 pixel right (stretched in the fixed font), wider
DEF LOOK_ITALIC EQU %00000010;top half shifted 1 pixel right
DEF LOOK_DIM    EQU %00000100;dim ink: dark grey on DMG, color 2 on SGB and GBC
DEF LOOK_ACCENT EQU %00001000;GBC: accent ink, color 1 of the palette in bits 4-6
DEF LANG_PLAIN   EQU 0;how text is styled, from the file name's extension
DEF LANG_MD      EQU 1
DEF PATH_SIZE    EQU 128;the open file's folder (file_dir)
DEF FS_NAME_SIZE EQU 65;src/fatfs/file_api.h

;on screen keyboard
DEF OSK_COLS    EQU 10
DEF OSK_ROWS    EQU 5
DEF OSK_LOWER   EQU 0
DEF OSK_SHIFT   EQU 1
DEF OSK_SYMBOLS EQU 2
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
