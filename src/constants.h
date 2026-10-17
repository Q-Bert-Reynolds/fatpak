#ifndef CONSTANTS
#define CONSTANTS

// assembly flags
#define TESTS_ENABLED    1
#define INTRO_ENABLED    1
#define TITLE_ENABLED    1
#define NEW_GAME_ENABLED 1
#define WORLD_ENABLED    1
#define PLAY_ENABLED     1

// game_state masks
#define GAME_STATE_CLOCK_STARTED   0b00000001
#define GAME_STATE_PLAY_BALL       0b00000010
#define GAME_STATE_UNSIGNED_PLAYER 0b00000100
#define GAME_STATE_PAUSED          0b00001000

// game progress flags
#define TEAM_FLAGS           0
#define TEAM_FLAG_HAS_PICKED 0b00001000
#define TEAM_FLAG_ANY        0b00000111
#define TEAM_FLAG_RED        0b00000001
#define TEAM_FLAG_GREEN      0b00000010
#define TEAM_FLAG_BLUE       0b00000100
#define PC_FLAGS             1
#define PC_FLAG_GOT_ROLEDEX  0b00000001
#define PC_FLAG_MET_BILL     0b00000010
#define PC_FLAG_BEAT_LEAGUE  0b00000100
#define PENNANT_FLAGS        2
#define PENNANT_FLAG_ROCK    0b00000001
#define PENNANT_FLAG_LAPIS   0b00000010
#define PENNANT_FLAG_COPPER  0b00000100
#define PENNANT_FLAG_EARTH   0b00001000
#define PENNANT_FLAG_BOG     0b00010000
#define PENNANT_FLAG_RUBBER  0b00100000
#define PENNANT_FLAG_MANTLE  0b01000000
#define PENNANT_FLAG_DIAMOND 0b10000000
#define ITEM_FLAGS           3

// ball state masks
#define BALL_STATE_CAUGHT  0b10000000
#define BALL_STATE_LANDED  0b01000000
#define BALL_STATE_FAIR    0b00100000
#define BALL_STATE_IN_PLAY 0b00010000
#define BALL_STATE_FIELDER 0b00001111

// rom banks
#define MAX_ROM_BANKS        64//1MB
#define GBT_PLAYER_BANK      1
#define FX_HAMMER_BANK       2
#define PLAY_BALL_BANK       3
#define PLAYER_IMG_BANK      4

// ram banks 
#define MAX_RAM_BANKS  4//32KB
#define MAIN_SRAM_BANK 0
#define FARM_SRAM_BANK 1

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

//base positions
#define HOME_PLATE_X  43
#define HOME_PLATE_Y  212
#define FIRST_BASE_X  123
#define FIRST_BASE_Y  212
#define SECOND_BASE_X 123
#define SECOND_BASE_Y 132
#define THIRD_BASE_X  43
#define THIRD_BASE_Y  132

//position
#define PITCHER          1
#define CATCHER          2
#define FIRST_BASEMAN    3
#define SECOND_BASEMAN   4
#define THIRD_BASEMAN    5
#define SHORTSTOP        6
#define LEFT_FIELDER     7
#define CENTER_FIELDER   8
#define RIGHT_FIELDER    9

//physical
#define THROW_LEFT  0b00000000
#define THROW_RIGHT 0b00000001
#define BAT_LEFT    0b00000010
#define BAT_RIGHT   0b00000100
#define BAT_SWITCH  0b00000110
#define SEX_FEMALE  0b00000000
#define SEX_MALE    0b00001000
#define ALT_COLORS  0b00010000

//moves mask
#define PITCHING_MOVES 0b0001
#define BATTING_MOVES  0b0010
#define RUNNING_MOVES  0b0100
#define FIELDING_MOVES 0b1000
#define ALL_MOVES      0b1111

//pitch paths
#define PITCH_PATH_NONE     0
#define PITCH_PATH_STRAIGHT 1
#define PITCH_PATH_CURVE    2
#define PITCH_PATH_FADE     3
#define PITCH_PATH_SLIDER   4
#define PITCH_PATH_RISE     5
#define PITCH_PATH_DROP     6
#define PITCH_PATH_EEPHUS   7
#define PITCH_PATH_SCREW    8
#define PITCH_PATH_SLURVE   9
#define PITCH_PATH_KNUCKLE  10
#define PITCH_PATH_CUT      11

//types
#define NONE     0
#define NORMAL   1
#define FIRE     2
#define WATER    3
#define ELECTRIC 4
#define GRASS    5
#define ICE      6
#define FIGHTING 7
#define POISON   8
#define GROUND   9
#define FLYING   10
#define PSYCHIC  11
#define BUG      12
#define ROCK     13
#define GHOST    14
#define DRAGON   15

//evolution
#define EV_TYPE_NONE    0
#define EV_TYPE_AGE     1
#define EV_TYPE_TRADE   2
#define EV_TYPE_ITEM    3

//status
#define STATUS_MASK_OK  0
#define STATUS_MASK_BRN 1
#define STATUS_MASK_FRZ 2
#define STATUS_MASK_PAR 4
#define STATUS_MASK_PSN 8
#define STATUS_MASK_SLP 16
#define STATUS_MASK_ALL -1

//stats
#define STAT_HP         1
#define STAT_REVIVE     2
#define STAT_ALL        3
#define STAT_EVOLVE     4
#define STAT_MAXPP      5
#define STAT_THROW      6
#define STAT_SPEED      7
#define STAT_FIELD      8
#define STAT_BAT        9
#define STAT_MAXHP      10
#define STAT_AGE        11
#define STAT_CRIT       12
#define STAT_CONTACT    13
#define STAT_ACCURACY   14
#define STAT_SPECIAL    15
#define STAT_STATUS_BRN 16
#define STAT_STATUS_FRZ 17
#define STAT_STATUS_PAR 18
#define STAT_STATUS_PSN 19
#define STAT_STATUS_SLP 20
#define STAT_STATUS_ALL 21
#define STAT_PP         22
#define STAT_PPALL      23
#define STAT_LEVEL      24

//item types
#define ITEM_TYPE_BASEBALL  1
#define ITEM_TYPE_GAME      2
#define ITEM_TYPE_MOVE      3
#define ITEM_TYPE_SPECIAL   4
#define ITEM_TYPE_STATS     5
#define ITEM_TYPE_SELL      6
#define ITEM_TYPE_WORLD     7
#define ITEM_TYPE_DNA       8

//inventory
#define INVENTORY_MODE_USE      1
#define INVENTORY_MODE_WITHDRAW 2
#define INVENTORY_MODE_DEPOSIT  3
#define INVENTORY_MODE_TOSS     4    
#define INVENTORY_MODE_SELL     5

//maps
#define MAP_DATA_META_SPRITE   0
#define MAP_DATA_PALETTES      1
#define MAP_DATA_STRINGS       3
#define MAP_DATA_DOORS         5
#define MAP_DATA_CHUNKS        7
#define MAP_DATA_ADDRESSES     9
#define MAP_DATA_ITEMS         11
#define MAP_DATA_AREAS         13
#define MAP_DATA_TILES         15
#define MAP_OBJ_TYPE_MASK      0b00001111//up to 15 map object types
#define MAP_OBJ_NONE           0 //bg only
#define MAP_OBJ_NONE_FILL      1 //bg only
#define MAP_OBJ_TILE           2 //bg and sprites
#define MAP_OBJ_TILE_FILL      3 //bg only
#define MAP_OBJ_STAMP          4 //bg and sprites
#define MAP_OBJ_STAMP_FILL     5 //bg only
#define MAP_OBJ_AVATAR         6 //sprites only
#define MAP_OBJ_META_SPRITE    7 //sprites only
#define MAP_COLLISION_MASK     0b11110000//up to 15 map collision types
#define MAP_COLLISION_NONE     0
#define MAP_COLLISION_SOLID    1 << 4
#define MAP_COLLISION_WATER    2 << 4
#define MAP_COLLISION_DOOR     3 << 4
#define MAP_COLLISION_TEXT     4 << 4
#define MAP_COLLISION_LEDGE    5 << 4
#define MAP_COLLISION_GRASS    6 << 4
#define MAP_COLLISION_SCRIPT   7 << 4
#define MAP_COLLISION_TEAM     8 << 4
#define MAP_COLLISION_ITEM     9 << 4
#define MAP_STEP_SIZE          16//2 tiles per step
#define WALK_ANIM_FRAMES       4//TODO: should come from GBStampAnimation
#define MAP_CHUNK_TILE         0
#define MAP_CHUNK_PALETTE      1
#define MAP_CHUNK_AREA         2
#define MAP_CHUNK_NORTH        3
#define MAP_CHUNK_EAST         4
#define MAP_CHUNK_SOUTH        5
#define MAP_CHUNK_WEST         6
#define MAP_CHUNK_DATA         7
#define MAP_AVATAR_DIRECTION   0b11000000
#define MAP_AVATAR_LEFT        0b00000000
#define MAP_AVATAR_RIGHT       0b01000000
#define MAP_AVATAR_UP          0b10000000
#define MAP_AVATAR_DOWN        0b11000000
#define MAP_AVATAR_EXTRA_DATA  0b00111111
#define MAP_AVATAR_FRAME       0b00000111
#define MAP_AVATAR_BEHAVIOUR   0b00111000
#define MAP_AVATAR_STATIONARY  0b00000000
#define MAP_AVATAR_WANDER      0b00001000

//sprite objects
#define SPRITE_OBJ_SIZE        6//bytes... bank, address(2), x, y, extra
#define SPRITE_OBJ_MAX_COUNT   OAM_COUNT-4//4 sprites reserved for player avatar
#define SPRITE_OBJ_BUFFER_SIZE SPRITE_OBJ_MAX_COUNT * SPRITE_OBJ_SIZE

//sizes
#define STACK_SIZE       128
#define MAX_ITEMS        20
#define MAX_PC_ITEMS     50
#define BYTES_PER_ITEM   2
#define ITEM_FLAGS_SIZE  32//256 items flags
#define MAX_MOVES        4
#define MAX_INNINGS      15
#define NAME_LENGTH      8
#define NICKNAME_LENGTH  12
#define NAME_BUFFER_SIZE 16
#define STR_BUFFER_SIZE  64
#define BUFFER_SIZE      1024//32x32 tiles
#define PLAYER_DATA_SIZE 25
#define PLAYER_STAT_SIZE 64
#define LINEUP_SIZE      (PLAYER_DATA_SIZE+PLAYER_STAT_SIZE)*9
#define PLAYERS_PER_FARM 20
#define FARM_SIZE        (PLAYER_DATA_SIZE+PLAYER_STAT_SIZE)*PLAYERS_PER_FARM
#define START_MONEY      1234567890

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
