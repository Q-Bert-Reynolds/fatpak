#ifndef CONSTANTS
#define CONSTANTS

// tests
#define TESTS_ENABLED         0
#define SOUND_TEST_ENABLED    0
#define KEYBOARD_TEST_ENABLED 0
#define MAP_TEST_ENABLED      0

// game_state masks
#define GAME_STATE_CLOCK_STARTED   0b00000001
#define GAME_STATE_PAUSED          0b00001000

// rom banks
#define MAX_ROM_BANKS        64//1MB
#define GBT_PLAYER_BANK      1
#define FX_HAMMER_BANK       2

// ram banks 
#define MAX_RAM_BANKS  4//32KB
#define MAIN_SRAM_BANK 0

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

//sizes
#define STACK_SIZE       128
#define ITEM_FLAGS_SIZE  32//256 items flags
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
