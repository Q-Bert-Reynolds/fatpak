/* Generated from data/strings/strings.csv by scripts/strings.py. */
#ifndef FATPAK_STRINGS_H
#define FATPAK_STRINGS_H
// PutStr(dest, id) and Str(id) (src/strings.asm), ModString in modules; S_PART(id, n) is the
// text after its nth {}, up to the next
#define S_PART(id, n) ((id) | ((n) << 12))
#define STR_COUNT 228
#define STR_HASH 0x1FD0u
#define LANGUAGES 2
#define LANG_CODES "ENES" // 2 characters each: /GBCSYS/LANG/<code>.DAT
#define S_MENU_FILE 0 // FILE
#define S_MENU_EDIT 1 // EDIT
#define S_MENU_SETTINGS 2 // SETTINGS
#define S_MENU_HELP 3 // HELP
#define S_MENU_CLOSE 4 // CLOSE
#define S_BMENU_FILE 5 // FILE
#define S_BMENU_EDIT 6 // EDIT
#define S_BMENU_SETTINGS 7 // SETTINGS
#define S_BMENU_HELP 8 // HELP
#define S_BMENU_RESTART 9 // RESTART
#define S_SUB_OPEN 10 // OPEN
#define S_SUB_SAVE 11 // SAVE
#define S_SUB_SAVE_AS 12 // SAVE AS
#define S_SUB_NEW 13 // NEW
#define S_SUB_BUILD 14 // BUILD
#define S_SUB_RUN 15 // RUN
#define S_SUB_UNDO 16 // UNDO
#define S_SUB_REDO 17 // REDO
#define S_SUB_CUT 18 // CUT
#define S_SUB_COPY 19 // COPY
#define S_SUB_PASTE 20 // PASTE
#define S_SUB_SELECT_ALL 21 // SELECT ALL
#define S_SUB_LINE_WRAP 22 // LINE WRAP
#define S_SUB_FULL_SCREEN 23 // FULL SCREEN
#define S_SUB_THEME 24 // THEME
#define S_SUB_LANGUAGE 25 // LANGUAGE
#define S_SUB_CLOCK 26 // CLOCK
#define S_SUB_KEYBOARD 27 // KEYBOARD
#define S_SUB_FONT 28 // FONT
#define S_SUB_RESOLUTION 29 // RESOLUTION
#define S_SUB_KEYBOARD_TEST 30 // TEST
#define S_FILE_OPEN 31 // OPEN
#define S_FILE_OPEN_AS 32 // OPEN AS
#define S_FILE_INFO 33 // INFO
#define S_FILE_RENAME 34 // RENAME
#define S_FILE_DELETE 35 // DELETE
#define S_VIEW_TEXT 36 // TEXT
#define S_VIEW_HEX 37 // HEX
#define S_VIEW_TILES 38 // TILES
#define S_FONT_STANDARD 39 // STANDARD
#define S_FONT_TILES 40 // 8X8 TILES
#define S_RES_160 41 // 160x144
#define S_RES_256 42 // 256x224
#define S_RES_512 43 // 512x448
#define S_VFILE_REBUILD 44 // REBUILD
#define S_VFILE_OPEN_AS 45 // OPEN AS
#define S_VFILE_INFO 46 // INFO
#define S_BEDIT_CUT 47 // CUT
#define S_BEDIT_COPY 48 // COPY
#define S_BEDIT_PASTE 49 // PASTE
#define S_NO 50 // NO
#define S_YES 51 // YES
#define S_LANG_EN 52 // ENGLISH
#define S_LANG_ES 53 // ESPAÑOL
#define S_DISCARD_CHANGES 54 // DISCARD CHANGES?
#define S_DELETE_TITLE 55 // DELETE {}?
#define S_NO_SD_CARD 56 // NO SD CARD
#define S_NO_FAT_VOLUME 57 // NO FAT VOLUME
#define S_SD_ERROR_N 58 // SD ERROR {}
#define S_SD_ERROR 59 // SD ERROR
#define S_DISK_FULL 60 // DISK FULL
#define S_TOO_BIG 61 // TOO BIG
#define S_SAVED 62 // SAVED
#define S_SAVE_NOT_BACKED_UP 63 // SAVE NOT BACKED UP
#define S_NOT_ASM_FILE 64 // NOT AN ASM FILE
#define S_FILE_TOO_BIG 65 // FILE TOO BIG
#define S_TOO_BIG_TO_COPY 66 // TOO BIG TO COPY
#define S_TEXT_FULL 67 // TEXT FULL
#define S_TOO_MANY_EDITS 68 // TOO MANY EDITS: SAVE
#define S_MODULE_MISSING 69 // MODULE MISSING
#define S_MODULE_DAMAGED 70 // MODULE DAMAGED
#define S_MODULE_NEWER_OS 71 // MODULE NEEDS NEW OS
#define S_RESTORE_FAILED 72 // RESTORE FAILED {}:{}
#define S_MODULE_LOAD_FAILED 73 // MODULE LOAD FAILED {}:{}
#define S_NAME_EXISTS 74 // Name already exists
#define S_CANT_PASTE 75 // Can't paste here
#define S_INVALID_NAME 76 // Invalid name/path
#define S_SD_FAILED 77 // SD operation failed
#define S_FOLDER_NOT_EMPTY 78 // Folder isn't empty
#define S_READ_ONLY 79 // File is read only
#define S_FILE_IS_OPEN 80 // File is open
#define S_CLIPBOARD_EMPTY 81 // Clipboard empty
#define S_SELECT_FILE 82 // Select file/folder
#define S_PATH_TOO_LONG 83 // Path is too long
#define S_LANGUAGE_MISSING 84 // Language file missing
#define S_BROWSER_HINT 85 // <A>Open <SELECT>Info <START>Menu
#define S_INFO_HINT 86 // <A>Open <START>Menu
#define S_LOADING 87 // Loading...
#define S_DELETING 88 // Deleting...
#define S_RESTARTING 89 // Restarting...
#define S_MOVING 90 // Moving...
#define S_COPYING 91 // Copying...
#define S_RENAMING 92 // Renaming...
#define S_READING_INFO 93 // Reading info...
#define S_ASSEMBLING 94 // Assembling...
#define S_COMPILING 95 // Compiling...
#define S_WRITING 96 // Writing...
#define S_SAVING 97 // Saving...
#define S_PREPARING_GAME 98 // Preparing game...
#define S_LOADING_KB 99 // Loading {}/{} KB
#define S_BUILD_PASS1 100 // Pass 1: {}k lines
#define S_BUILD_PASS2 101 // Pass 2: {}%
#define S_BUILD_UNIT 102 // Assembling: {}%
#define S_BUILD_AT_LINE 103 // line {}
#define S_BUILD_LINE 104 // Line {}
#define S_BUILD_DONE 105 // Built {} KB
#define S_C_ERROR 106 // C ERROR {}
#define S_ERR_SYNTAX 107 // SYNTAX ERROR
#define S_ERR_SYMBOL 108 // UNKNOWN SYMBOL
#define S_ERR_DUPLICATE 109 // ALREADY DEFINED
#define S_ERR_RANGE 110 // VALUE TOO BIG
#define S_ERR_JR 111 // JR TOO FAR
#define S_ERR_OPERAND 112 // BAD OPERAND
#define S_ERR_SECTION 113 // NO SECTION
#define S_ERR_FULL 114 // SECTION FULL
#define S_ERR_FORWARD 115 // NOT YET DEFINED
#define S_ERR_UNSUPPORTED 116 // NOT SUPPORTED
#define S_ERR_NAME 117 // NAME TOO LONG
#define S_ERR_DIVIDE 118 // DIVIDE BY ZERO
#define S_ERR_MNEMONIC 119 // BAD INSTRUCTION
#define S_ERR_PHASE 120 // PHASE ERROR
#define S_ERR_STRING 121 // BAD STRING
#define S_ERR_SCOPE 122 // NO GLOBAL LABEL
#define S_ERR_SYMBOLS 123 // TOO MANY SYMBOLS
#define S_ERR_EMPTY 124 // NO CODE
#define S_ERR_BANK 125 // BAD BANK
#define S_ERR_ASSERT 126 // ASSERT FAILED
#define S_ERR_FILE 127 // NO SUCH FILE
#define S_ERR_NESTING 128 // TOO DEEP
#define S_ERR_OVERLAP 129 // SECTIONS OVERLAP
#define S_UNTITLED 130 // Untitled
#define S_SELECTED 131 // {} selected
#define S_LINE_COL 132 // Line {}, Col {}
#define S_SAVE_AS 133 // Save as
#define S_IN_FOLDER 134 // in
#define S_CLOCK_YEAR 135 // Year
#define S_CLOCK_MONTH 136 // Month
#define S_CLOCK_DAY 137 // Day
#define S_CLOCK_HOUR 138 // Hour
#define S_CLOCK_MINUTE 139 // Minute
#define S_CLOCK_SECOND 140 // Second
#define S_CLOCK_HINT 141 // <LR> Edit <A>Set <B>Back
#define S_CLOCK_INVALID 142 // Invalid date or no clock
#define S_HELP_HINT 143 // <UD>Scroll <B>Exit
#define S_THEME_HINT 144 // <A>Toggle <B>Back
#define S_THEME_DARK 145 // Dark mode  {}
#define S_ON 146 // On
#define S_OFF 147 // Off
#define S_INFO_TYPE 148 // Type:
#define S_INFO_SIZE 149 // Size:
#define S_INFO_CREATED 150 // Created:
#define S_INFO_ACCESSED 151 // Accessed:
#define S_INFO_MODIFIED 152 // Modified:
#define S_INFO_READ 153 // Read:
#define S_INFO_HEADER 154 // Header:
#define S_INFO_WORDS 155 // Words:
#define S_INFO_LINES 156 // Lines:
#define S_INFO_COUNTS 157 // Counts:
#define S_INFO_TITLE 158 // Title:
#define S_INFO_PLATFORM 159 // Platform:
#define S_INFO_SGB 160 // Super GB:
#define S_INFO_MAPPER 161 // Mapper:
#define S_INFO_ROM 162 // ROM:
#define S_INFO_RAM 163 // RAM:
#define S_INFO_REGION 164 // Region:
#define S_INFO_REVISION 165 // Revision:
#define S_INFO_CHECKSUM 166 // Header checksum:
#define S_TYPE_TEXT 167 // Plain Text
#define S_TYPE_MARKDOWN 168 // Markdown
#define S_TYPE_C 169 // C source
#define S_TYPE_ASM 170 // Assembly
#define S_TYPE_FOLDER 171 // Folder
#define S_TYPE_GAME 172 // Game Boy ROM
#define S_TYPE_BINARY 173 // Binary
#define S_SD_ERROR_LOWER 174 // SD error
#define S_TOO_SHORT 175 // Too short
#define S_BINARY_FILE 176 // Binary file
#define S_SKIPPED 177 // Skipped (>32KB)
#define S_GB_ONLY 178 // Game Boy
#define S_INFO_YES 179 // Yes
#define S_INFO_NO 180 // No
#define S_NONE 181 // --
#define S_RAM_MBC2 182 // 512 x 4 bits
#define S_GB_COLOR_ONLY 183 // Color only
#define S_GB_BOTH 184 // GB / Color
#define S_UNKNOWN 185 // Unknown
#define S_JAPAN 186 // Japan
#define S_OVERSEAS 187 // Overseas
#define S_CHECK_OK 188 // OK
#define S_CHECK_BAD 189 // Bad
#define S_MAPPER_TYPE 190 // type
#define S_KB_TITLE 191 // KEYBOARD TEST
#define S_KB_PS2 192 // Found at boot: PS/2
#define S_KB_NONE 193 // Found at boot: none, listening anyway
#define S_KB_CODES 194 // Raw bytes (newest last):
#define S_KB_BACK 195 // <A> Pause  <B> Back
#define S_KB_BYTES 196 // Bytes {}   with errors {}
#define S_KB_KEY 197 // Key {}   modifiers {}
#define S_KB_FINISH 198 // finish
#define S_KB_PARITY 199 // parity
#define S_KB_START 200 // start
#define S_KB_UNUSED3 201 //
#define S_KB_UNUSED4 202 //
#define S_KB_TIMEOUT 203 // timeout
#define S_TILE_N 204 // Tile
#define S_INGAME_RESUME 205 // Resume game
#define S_INGAME_SAVE 206 // Save state
#define S_INGAME_LOAD 207 // Load state
#define S_INGAME_RETURN 208 // Return to OS
#define S_INGAME_ERROR 209 // State / SD error
#define S_INGAME_FOOTER 210 // <A> Select  <B> Resume
#define S_MODULE_COPY_FAILED 211 // COPY FAILED {}:{}
#define S_BUILD_LOADING 212 // loading
#define S_BUILD_LINKING 213 // Placing sections
#define S_BUILD_FINISHING 214 // Finishing
#define S_DRIVER_NONE 215 // NONE
#define S_DRIVER_PS2 216 // PS/2 KEYBOARD
#define S_DRIVER_IGKB 217 // iGKB USB
#define S_DRIVER_SNES_MOUSE 218 // SNES MOUSE
#define S_KB_PAUSED 219 // PAUSED (A resumes)
#define S_MAP_READING 220 // Reading map...
#define S_MAP_LARGE 221 // Close the large
#define S_MAP_LARGE2 222 // file to view maps
#define S_MAP_CANT_BUILD 223 // Can't build the
#define S_MAP_ERROR_N 224 // map: error {}
#define S_MAP_WRAPPER 225 // (wrapper)
#define S_MAP_CHUNK 226 // chunk
#define S_CC_PASS 227 // Compiling {}/3
#endif
