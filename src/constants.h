#ifndef CONSTANTS
#define CONSTANTS

// busy spinner (src/interrupts.asm), shown when the main loop hasn't waited for a frame in a while
#define BUSY_SPRITE 2
#define BUSY_TILE   122//sprite tile, the editor's tile blocks don't use 122-127
#define BUSY_DELAY  10//frames
#define BUSY_X      160//OAM x and y, top right corner
#define BUSY_Y      16
#define BUSY_PALETTE 4//GBC object palette (PaletteSlate), color 2 is dark

// ram banks 
#define MAIN_SRAM_BANK 240//PSRAM blocks 240-255 hold settings and the clipboard

// sprite props
#define FLIP_X_PAL  (OAMF_XFLIP | OAMF_PAL1 )
#define FLIP_Y_PAL  (OAMF_YFLIP | OAMF_PAL1 )
#define FLIP_XY_PAL (FLIP_X_PAL | FLIP_Y_PAL)
#define FLIP_XY     (OAMF_XFLIP | OAMF_YFLIP)

// sprite draw flags
#define SPRITE_FLAGS_SKIP      0b00000001
#define SPRITE_FLAGS_CLEAR_END 0b00000010

// ui draw flags
#define DRAW_FLAGS_BKG      0b00000000
#define DRAW_FLAGS_WIN      0b00000001
#define DRAW_FLAGS_PAD_TOP  0b00000010
#define DRAW_FLAGS_NO_SPACE 0b00000100

//text buffer
//PSRAM through the 512 byte window at 0xBE00, 0xBD03 = 1 (128KB-256KB), blocks are banks
#define TB_BANKS     127//blocks 0-126, positions are 16 bit
#define TB_BANK_SIZE 0x0200u
#define TB_BASE      0xBE00u
#define TB_HOLE      0x0200u//no register hole
#define TB_HOLE_SIZE 0
#define TB_PSRAM_HIGH 1//0xBD03
#define UNDO_BANK    128//undo log in blocks 128-239
#define UNDO_BANKS   112
//the data file (data_file.py) in PSRAM blocks from 0x0200 (256KB), loaded at boot
#define DATA_BLOCK         0x0200u//0xBD03:0xBD02
#define DATA_FONTS         1//the styled fonts (FontStyles order), 2KB each
#define DATA_BORDER_TILES  41//the SGB border's 8KB of tiles
#define DATA_BORDER_MAP    57//its map and palettes, 4KB
#define DATA_FIXED         65//the base fixed font, four blocks
#define DATA_HELP          69//two 32-line help screens, 32 bytes per line
#define DATA_BLOCKS        73
#define DATA_VERSION       3//block 0 starts with "EDITOR.DAT" and this
#define NAME_HISTORY_BLOCK DATA_BLOCK+DATA_BLOCKS//16 scratch blocks, separate from document undo
#define WIN_SIZE           0xC000u//the part of a large file in the text buffer (src/fatfs/fatfs.c)
#define WIN_CHUNKS         WIN_SIZE/512+1//sector boundaries in it
#define MAX_PIECES         96//a large file's piece table (src/fatfs/fatfs.c)
#define ADD_BLOCK          0x0400u//text added to a large file, PSRAM 512KB up to the save states at 0x3E40
#define ADD_MAX            0x7A0000
#define TB_SIZE      (TB_BANK_SIZE*TB_BANKS)
#define TB_CLIP_OFFSET 0x0100u//the clipboard's text in PSRAM blocks 240-255 (src/sram.asm)
#define TB_CLIP_SIZE (0x2000u-TB_CLIP_OFFSET)
#define UNDO_SIZE    (TB_BANK_SIZE*UNDO_BANKS)
#define TB_COLS   20//tiles per row
#define TB_ROWS   18
#define TB_WIDTH  TB_COLS*8//pixels per row
#define TB_STRIDE 40//characters per row in tile_buffer
#define BOX_STRIDE 20//characters per line of the menu box's text, 0 ends a line

//fonts
#define FONT_MONO 0
#define FONT_VWF  1
#define FONT_FIXED 2//4 pixel fixed width, for text
#define FONT_H1    3//markdown headings 1-4: the fixed font 1 pixel taller, stretched with 2 pixel strokes (8, 7, 6, 5 pixel cells)
#define FONT_H4    6

//text styles (TBLex): a byte per character in tile_attrs, its width in pixels in the low 4 bits
//and its style in the high 4, StyleLooks has what each style looks like
#define STYLE_WIDTH       0b00001111
#define STYLE_TEXT        0
#define STYLE_BOLD        1
#define STYLE_ITALIC      2
#define STYLE_BOLD_ITALIC 3
#define STYLE_MARK        4//markdown markers (#, *, _, `)
#define STYLE_CODE        5//`code`
#define STYLE_HEAD        6//headings 1-4 (their fonts are bold)
#define STYLE_HEAD_BOLD   7//headings 5 and 6
#define STYLE_COMMENT     8//code (TBLexCode)
#define STYLE_KEYWORD     9//C keywords, asm instructions
#define STYLE_TYPE        10//C types, asm registers and conditions
#define STYLE_STRING      11//strings and chars
#define STYLE_NUMBER      12//numbers and constants
#define STYLE_PREPROC     13//C preprocessor, asm directives
#define STYLE_LABEL       14//asm labels
#define LOOK_BOLD   0b00000001//ORed 1 pixel right (stretched in the fixed font), wider
#define LOOK_ITALIC 0b00000010//top half shifted 1 pixel right
#define LOOK_DIM    0b00000100//dim ink: dark grey on DMG, color 2 on SGB and GBC
#define LOOK_ACCENT 0b00001000//GBC: accent ink, color 1 of the palette in bits 4-6
#define LANG_PLAIN   0//how text is styled, from the file name's extension
#define LANG_MD      1
#define LANG_C       2//.c, .h
#define LANG_ASM     3//.asm, .inc, .s (RGBDS)
#define PATH_SIZE    128//the open file's folder (file_dir)
#define FS_NAME_SIZE 65//src/fatfs/file_api.h

//on screen keyboard
#define OSK_COLS    10
#define OSK_ROWS    5
#define OSK_INSET   4
#define OSK_LOWER   0
#define OSK_SHIFT   1
#define OSK_SYMBOLS 2
#define ASCII_TAB 9
#define ASCII_LF  10
#define ASCII_CR  13

//key events, printable keys use their character code
#define PAD_REPEAT_DELAY 20//frames before a held d-pad button or arrow key repeats
#define PAD_REPEAT_RATE  4//frames between repeats

#define KEY_NONE      0
#define KEY_BACKSPACE 8
#define KEY_TAB       9
#define KEY_ENTER     10
#define KEY_ESCAPE    27
#define KEY_DELETE    127
#define KEY_LEFT      0x80
#define KEY_RIGHT     0x81
#define KEY_UP        0x82
#define KEY_DOWN      0x83
#define KEY_HOME      0x84
#define KEY_END       0x85
#define KEY_PAGE_UP   0x86
#define KEY_PAGE_DOWN 0x87
#define KEY_INSERT    0x88
#define KEY_MENU      0x89//file menu (Escape, on screen keyboard)
#define KEY_UNDO      0x8A
#define KEY_REDO      0x8B
#define KEY_F1        0x90//function keys are KEY_F1 + n - 1
#define KEY_F2        0x91
#define KEY_F3        0x92
#define KEY_F4        0x93
#define KEY_F5        0x94
#define KEY_F6        0x95
#define KEY_F7        0x96
#define KEY_F8        0x97
#define KEY_F9        0x98
#define KEY_F10       0x99
#define KEY_F11       0x9A
#define KEY_F12       0x9B

//kb_modifiers
#define KB_MOD_SCROLL_LOCK 0b00000001//same as PS2_LED_SCROLL_LOCK
#define KB_MOD_NUM_LOCK    0b00000010//same as PS2_LED_NUM_LOCK
#define KB_MOD_CAPS_LOCK   0b00000100//same as PS2_LED_CAPS_LOCK
#define KB_MOD_SUPER       0b00001000
#define KB_MOD_ALT         0b00010000
#define KB_MOD_CTRL        0b00100000
#define KB_MOD_SHIFT       0b01000000
#define KB_MOD_FUNCTION    0b10000000

//sizes
#define STACK_SIZE       1024//FatFs needs a deep stack
#define NAME_LENGTH      8
#define NAME_BUFFER_SIZE 16
#define STR_BUFFER_SIZE  64
#define BUFFER_SIZE      1024//32x32 tiles

//notes
#define C2      44
#define Db2     156
#define D2      262
#define Eb2     363
#define E2      457
#define F2      547
#define Gb2     631
#define G2      710
#define Ab2     786
#define A2      854
#define Bb2     923
#define B2      986
#define C3      1046
#define Db3     1102
#define D3      1155
#define Eb3     1205
#define E3      1253
#define F3      1297
#define Gb3     1339
#define G3      1379
#define Ab3     1417
#define A3      1452
#define Bb3     1486
#define B3      1517
#define C4      1546
#define Db4     1575
#define D4      1602
#define Eb4     1627
#define E4      1650
#define F4      1673
#define Gb4     1694
#define G4      1714
#define Ab4     1732
#define A4      1750
#define Bb4     1767
#define B4      1783
#define C5      1798
#define Db5     1812
#define D5      1825
#define Eb5     1837
#define E5      1849
#define F5      1860
#define Gb5     1871
#define G5      1881
#define Ab5     1890
#define A5      1899
#define Bb5     1907
#define B5      1915
#define C6      1923
#define Db6     1930
#define D6      1936
#define Eb6     1943
#define E6      1949
#define F6      1954
#define Gb6     1959
#define G6      1964
#define Ab6     1969
#define A6      1974
#define Bb6     1978
#define B6      1982
#define C7      1985
#define Db7     1988
#define D7      1992
#define Eb7     1995
#define E7      1998
#define F7      2001
#define Gb7     2004
#define G7      2006
#define Ab7     2009
#define A7      2011
#define Bb7     2013
#define B7      2015

//Noise Shift Clock
#define NOISE_DIV_2   0x00
#define NOISE_DIV_4   0x10
#define NOISE_DIV_8   0x20
#define NOISE_DIV_16  0x30
#define NOISE_DIV_32  0x40
#define NOISE_DIV_64  0x50
#define NOISE_DIV_128 0x60
#define NOISE_DIV_256 0x70
#define NOISE_DIV_512 0x80
#define NOISE_DIV_1K  0x90
#define NOISE_DIV_2K  0xA0
#define NOISE_DIV_4K  0xB0
#define NOISE_DIV_8K  0xC0
#define NOISE_DIV_16K 0xD0

//Periodic Noise (15 counter steps)
#define NOISE_STUTTER    0x0 //A square plus a pulse at random pulse widths
#define NOISE_RUMBLE     0x1 //The same waveform but faster
#define NOISE_ENGINE     0x2 //The same waveform but even faster
#define NOISE_LOW_TONE   0x3 //Sounds like D5
#define NOISE_UNDERTONE  0x4 //Sounds like E5 + 50cents
#define NOISE_MIDDLETONE 0x5 //Sounds like B5 + 50cents
#define NOISE_OVERTONE   0x6 //Sounds like D6 + 50cents
#define NOISE_HIGH_TONE  0x7 //Sounds like D7

//Pseudorandom Noise (7 counter steps)
#define NOISE_EARTHQUAKE 0x8 //A square with a thin pulse at random pulse widths
#define NOISE_SPACESHIP  0x9 //The same waveform but faster
#define NOISE_OCEAN      0xA //The same waveform but even faster
#define NOISE_SCRATCH    0xB //You get the idea
#define NOISE_GLITCH     0xC //A fairly clean white-noise sample, unrelated to other instruments
#define NOISE_VOLCANO    0xD //A pulse with rapidly changing pulse width
#define NOISE_SCREAM     0xE //The same waveform but faster
#define NOISE_STATIC     0xF //The same waveform but even faster

#endif //CONSTANTS
