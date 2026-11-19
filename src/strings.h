/* Generated from data/strings/strings.csv by scripts/strings.py. */
#ifndef FATPAK_STRINGS_H
#define FATPAK_STRINGS_H
// PutStr(dest, id) and Str(id) (src/strings.asm), ModString in modules; S_PART(id, n) is the
// text after its nth {}, up to the next
#define S_PART(id, n) ((id) | ((n) << 12))
#define STR_COUNT 218
#define STR_HASH 0x959Bu
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
#define S_SUB_SGB_FULLSCREEN 28 // SGB FULLSCREEN
#define S_SUB_KEYBOARD_TEST 29 // TEST
#define S_FILE_OPEN 30 // OPEN
#define S_FILE_OPEN_AS 31 // OPEN AS
#define S_FILE_INFO 32 // INFO
#define S_FILE_RENAME 33 // RENAME
#define S_FILE_DELETE 34 // DELETE
#define S_VIEW_TEXT 35 // TEXT
#define S_VIEW_HEX 36 // HEX
#define S_VIEW_TILES 37 // TILES
#define S_BEDIT_CUT 38 // CUT
#define S_BEDIT_COPY 39 // COPY
#define S_BEDIT_PASTE 40 // PASTE
#define S_NO 41 // NO
#define S_YES 42 // YES
#define S_LANG_EN 43 // ENGLISH
#define S_LANG_ES 44 // ESPAÑOL
#define S_DISCARD_CHANGES 45 // DISCARD CHANGES?
#define S_DELETE_TITLE 46 // DELETE {}?
#define S_NO_SD_CARD 47 // NO SD CARD
#define S_NO_FAT_VOLUME 48 // NO FAT VOLUME
#define S_SD_ERROR_N 49 // SD ERROR {}
#define S_SD_ERROR 50 // SD ERROR
#define S_DISK_FULL 51 // DISK FULL
#define S_TOO_BIG 52 // TOO BIG
#define S_SAVED 53 // SAVED
#define S_SAVE_NOT_BACKED_UP 54 // SAVE NOT BACKED UP
#define S_NOT_ASM_FILE 55 // NOT AN ASM FILE
#define S_FILE_TOO_BIG 56 // FILE TOO BIG
#define S_TOO_BIG_TO_COPY 57 // TOO BIG TO COPY
#define S_TEXT_FULL 58 // TEXT FULL
#define S_TOO_MANY_EDITS 59 // TOO MANY EDITS: SAVE
#define S_MODULE_MISSING 60 // MODULE MISSING
#define S_MODULE_DAMAGED 61 // MODULE DAMAGED
#define S_MODULE_NEWER_OS 62 // MODULE NEEDS NEW OS
#define S_RESTORE_FAILED 63 // RESTORE FAILED {}:{}
#define S_MODULE_LOAD_FAILED 64 // MODULE LOAD FAILED {}:{}
#define S_NAME_EXISTS 65 // Name already exists
#define S_CANT_PASTE 66 // Can't paste here
#define S_INVALID_NAME 67 // Invalid name/path
#define S_SD_FAILED 68 // SD operation failed
#define S_FOLDER_NOT_EMPTY 69 // Folder isn't empty
#define S_READ_ONLY 70 // File is read only
#define S_FILE_IS_OPEN 71 // File is open
#define S_CLIPBOARD_EMPTY 72 // Clipboard empty
#define S_SELECT_FILE 73 // Select file/folder
#define S_PATH_TOO_LONG 74 // Path is too long
#define S_LANGUAGE_MISSING 75 // Language file missing
#define S_BROWSER_HINT 76 // <A>Open <SELECT>Info <START>Menu
#define S_INFO_HINT 77 // <A>Open <B>Exit
#define S_LOADING 78 // Loading...
#define S_DELETING 79 // Deleting...
#define S_RESTARTING 80 // Restarting...
#define S_MOVING 81 // Moving...
#define S_COPYING 82 // Copying...
#define S_RENAMING 83 // Renaming...
#define S_READING_INFO 84 // Reading info...
#define S_ASSEMBLING 85 // Assembling...
#define S_WRITING 86 // Writing...
#define S_SAVING 87 // Saving...
#define S_PREPARING_GAME 88 // Preparing game...
#define S_LOADING_KB 89 // Loading {}/{} KB
#define S_BUILD_PASS1 90 // Pass 1: {}k lines
#define S_BUILD_PASS2 91 // Pass 2: {}%
#define S_BUILD_UNIT 92 // Assembling: {}%
#define S_BUILD_AT_LINE 93 // line {}
#define S_BUILD_LINE 94 // Line {}
#define S_BUILD_DONE 95 // Built {} KB
#define S_ERR_SYNTAX 96 // SYNTAX ERROR
#define S_ERR_SYMBOL 97 // UNKNOWN SYMBOL
#define S_ERR_DUPLICATE 98 // ALREADY DEFINED
#define S_ERR_RANGE 99 // VALUE TOO BIG
#define S_ERR_JR 100 // JR TOO FAR
#define S_ERR_OPERAND 101 // BAD OPERAND
#define S_ERR_SECTION 102 // NO SECTION
#define S_ERR_FULL 103 // SECTION FULL
#define S_ERR_FORWARD 104 // NOT YET DEFINED
#define S_ERR_UNSUPPORTED 105 // NOT SUPPORTED
#define S_ERR_NAME 106 // NAME TOO LONG
#define S_ERR_DIVIDE 107 // DIVIDE BY ZERO
#define S_ERR_MNEMONIC 108 // BAD INSTRUCTION
#define S_ERR_PHASE 109 // PHASE ERROR
#define S_ERR_STRING 110 // BAD STRING
#define S_ERR_SCOPE 111 // NO GLOBAL LABEL
#define S_ERR_SYMBOLS 112 // TOO MANY SYMBOLS
#define S_ERR_EMPTY 113 // NO CODE
#define S_ERR_BANK 114 // BAD BANK
#define S_ERR_ASSERT 115 // ASSERT FAILED
#define S_ERR_FILE 116 // NO SUCH FILE
#define S_ERR_NESTING 117 // TOO DEEP
#define S_ERR_OVERLAP 118 // SECTIONS OVERLAP
#define S_UNTITLED 119 // Untitled
#define S_SELECTED 120 // {} selected
#define S_LINE_COL 121 // Line {}, Col {}
#define S_SAVE_AS 122 // Save as
#define S_IN_FOLDER 123 // in
#define S_CLOCK_YEAR 124 // Year
#define S_CLOCK_MONTH 125 // Month
#define S_CLOCK_DAY 126 // Day
#define S_CLOCK_HOUR 127 // Hour
#define S_CLOCK_MINUTE 128 // Minute
#define S_CLOCK_SECOND 129 // Second
#define S_CLOCK_HINT 130 // <LR> Edit <A>Set <B>Back
#define S_CLOCK_INVALID 131 // Invalid date or no clock
#define S_HELP_HINT 132 // <UD>Scroll <B>Exit
#define S_THEME_HINT 133 // <A>Toggle <B>Back
#define S_THEME_DARK 134 // Dark mode  {}
#define S_ON 135 // On
#define S_OFF 136 // Off
#define S_INFO_TYPE 137 // Type:
#define S_INFO_SIZE 138 // Size:
#define S_INFO_CREATED 139 // Created:
#define S_INFO_ACCESSED 140 // Accessed:
#define S_INFO_MODIFIED 141 // Modified:
#define S_INFO_READ 142 // Read:
#define S_INFO_HEADER 143 // Header:
#define S_INFO_WORDS 144 // Words:
#define S_INFO_LINES 145 // Lines:
#define S_INFO_COUNTS 146 // Counts:
#define S_INFO_TITLE 147 // Title:
#define S_INFO_PLATFORM 148 // Platform:
#define S_INFO_SGB 149 // Super GB:
#define S_INFO_MAPPER 150 // Mapper:
#define S_INFO_ROM 151 // ROM:
#define S_INFO_RAM 152 // RAM:
#define S_INFO_REGION 153 // Region:
#define S_INFO_REVISION 154 // Revision:
#define S_INFO_CHECKSUM 155 // Header checksum:
#define S_TYPE_TEXT 156 // Plain Text
#define S_TYPE_MARKDOWN 157 // Markdown
#define S_TYPE_C 158 // C source
#define S_TYPE_ASM 159 // Assembly
#define S_TYPE_FOLDER 160 // Folder
#define S_TYPE_GAME 161 // Game Boy ROM
#define S_TYPE_BINARY 162 // Binary
#define S_SD_ERROR_LOWER 163 // SD error
#define S_TOO_SHORT 164 // Too short
#define S_BINARY_FILE 165 // Binary file
#define S_SKIPPED 166 // Skipped (>32KB)
#define S_GB_ONLY 167 // Game Boy
#define S_INFO_YES 168 // Yes
#define S_INFO_NO 169 // No
#define S_NONE 170 // --
#define S_RAM_MBC2 171 // 512 x 4 bits
#define S_GB_COLOR_ONLY 172 // Color only
#define S_GB_BOTH 173 // GB / Color
#define S_UNKNOWN 174 // Unknown
#define S_JAPAN 175 // Japan
#define S_OVERSEAS 176 // Overseas
#define S_CHECK_OK 177 // OK
#define S_CHECK_BAD 178 // Bad
#define S_MAPPER_TYPE 179 // type
#define S_KB_TITLE 180 // KEYBOARD TEST
#define S_KB_PS2 181 // Found at boot: PS/2
#define S_KB_NONE 182 // Found at boot: none, listening anyway
#define S_KB_CODES 183 // Raw bytes (newest last):
#define S_KB_BACK 184 // <A> Pause  <B> Back
#define S_KB_BYTES 185 // Bytes {}   with errors {}
#define S_KB_KEY 186 // Key {}   modifiers {}
#define S_KB_FINISH 187 // finish
#define S_KB_PARITY 188 // parity
#define S_KB_START 189 // start
#define S_KB_UNUSED3 190 //
#define S_KB_UNUSED4 191 //
#define S_KB_TIMEOUT 192 // timeout
#define S_TILE_N 193 // Tile
#define S_INGAME_RESUME 194 // Resume game
#define S_INGAME_SAVE 195 // Save state
#define S_INGAME_LOAD 196 // Load state
#define S_INGAME_RETURN 197 // Return to OS
#define S_INGAME_ERROR 198 // State / SD error
#define S_INGAME_FOOTER 199 // <A> Select  <B> Resume
#define S_MODULE_COPY_FAILED 200 // COPY FAILED {}:{}
#define S_BUILD_LOADING 201 // loading
#define S_BUILD_LINKING 202 // Placing sections
#define S_BUILD_FINISHING 203 // Finishing
#define S_DRIVER_NONE 204 // NONE
#define S_DRIVER_PS2 205 // PS/2 KEYBOARD
#define S_DRIVER_IGKB 206 // iGKB USB
#define S_DRIVER_SNES_MOUSE 207 // SNES MOUSE
#define S_KB_PAUSED 208 // PAUSED (A resumes)
#define S_MAP_REBUILD 209 // Rebuild
#define S_MAP_CLOSE 210 // Close the map
#define S_MAP_READING 211 // Reading map...
#define S_MAP_LARGE 212 // Close the large
#define S_MAP_LARGE2 213 // file to view maps
#define S_MAP_CANT_BUILD 214 // Can't build the
#define S_MAP_ERROR_N 215 // map: error {}
#define S_MAP_WRAPPER 216 // (wrapper)
#define S_MAP_CHUNK 217 // chunk
#endif
