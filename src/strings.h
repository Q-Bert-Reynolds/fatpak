/* Generated from data/strings/strings.csv by scripts/strings.py. */
#ifndef FATPAK_STRINGS_H
#define FATPAK_STRINGS_H
// PutStr(dest, id) and Str(id) (src/strings.asm), ModString in modules; S_PART(id, n) is the
// text after its nth {}, up to the next
#define S_PART(id, n) ((id) | ((n) << 12))
#define STR_COUNT 222
#define STR_HASH 0x0786u
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
#define S_SUB_RESOLUTION 28 // RESOLUTION
#define S_SUB_KEYBOARD_TEST 29 // TEST
#define S_FILE_OPEN 30 // OPEN
#define S_FILE_OPEN_AS 31 // OPEN AS
#define S_FILE_INFO 32 // INFO
#define S_FILE_RENAME 33 // RENAME
#define S_FILE_DELETE 34 // DELETE
#define S_VIEW_TEXT 35 // TEXT
#define S_VIEW_HEX 36 // HEX
#define S_VIEW_TILES 37 // TILES
#define S_RES_160 38 // 160x144
#define S_RES_256 39 // 256x224
#define S_RES_512 40 // 512x448
#define S_VFILE_REBUILD 41 // REBUILD
#define S_VFILE_OPEN_AS 42 // OPEN AS
#define S_VFILE_INFO 43 // INFO
#define S_BEDIT_CUT 44 // CUT
#define S_BEDIT_COPY 45 // COPY
#define S_BEDIT_PASTE 46 // PASTE
#define S_NO 47 // NO
#define S_YES 48 // YES
#define S_LANG_EN 49 // ENGLISH
#define S_LANG_ES 50 // ESPAÑOL
#define S_DISCARD_CHANGES 51 // DISCARD CHANGES?
#define S_DELETE_TITLE 52 // DELETE {}?
#define S_NO_SD_CARD 53 // NO SD CARD
#define S_NO_FAT_VOLUME 54 // NO FAT VOLUME
#define S_SD_ERROR_N 55 // SD ERROR {}
#define S_SD_ERROR 56 // SD ERROR
#define S_DISK_FULL 57 // DISK FULL
#define S_TOO_BIG 58 // TOO BIG
#define S_SAVED 59 // SAVED
#define S_SAVE_NOT_BACKED_UP 60 // SAVE NOT BACKED UP
#define S_NOT_ASM_FILE 61 // NOT AN ASM FILE
#define S_FILE_TOO_BIG 62 // FILE TOO BIG
#define S_TOO_BIG_TO_COPY 63 // TOO BIG TO COPY
#define S_TEXT_FULL 64 // TEXT FULL
#define S_TOO_MANY_EDITS 65 // TOO MANY EDITS: SAVE
#define S_MODULE_MISSING 66 // MODULE MISSING
#define S_MODULE_DAMAGED 67 // MODULE DAMAGED
#define S_MODULE_NEWER_OS 68 // MODULE NEEDS NEW OS
#define S_RESTORE_FAILED 69 // RESTORE FAILED {}:{}
#define S_MODULE_LOAD_FAILED 70 // MODULE LOAD FAILED {}:{}
#define S_NAME_EXISTS 71 // Name already exists
#define S_CANT_PASTE 72 // Can't paste here
#define S_INVALID_NAME 73 // Invalid name/path
#define S_SD_FAILED 74 // SD operation failed
#define S_FOLDER_NOT_EMPTY 75 // Folder isn't empty
#define S_READ_ONLY 76 // File is read only
#define S_FILE_IS_OPEN 77 // File is open
#define S_CLIPBOARD_EMPTY 78 // Clipboard empty
#define S_SELECT_FILE 79 // Select file/folder
#define S_PATH_TOO_LONG 80 // Path is too long
#define S_LANGUAGE_MISSING 81 // Language file missing
#define S_BROWSER_HINT 82 // <A>Open <SELECT>Info <START>Menu
#define S_INFO_HINT 83 // <A>Open <START>Menu
#define S_LOADING 84 // Loading...
#define S_DELETING 85 // Deleting...
#define S_RESTARTING 86 // Restarting...
#define S_MOVING 87 // Moving...
#define S_COPYING 88 // Copying...
#define S_RENAMING 89 // Renaming...
#define S_READING_INFO 90 // Reading info...
#define S_ASSEMBLING 91 // Assembling...
#define S_WRITING 92 // Writing...
#define S_SAVING 93 // Saving...
#define S_PREPARING_GAME 94 // Preparing game...
#define S_LOADING_KB 95 // Loading {}/{} KB
#define S_BUILD_PASS1 96 // Pass 1: {}k lines
#define S_BUILD_PASS2 97 // Pass 2: {}%
#define S_BUILD_UNIT 98 // Assembling: {}%
#define S_BUILD_AT_LINE 99 // line {}
#define S_BUILD_LINE 100 // Line {}
#define S_BUILD_DONE 101 // Built {} KB
#define S_ERR_SYNTAX 102 // SYNTAX ERROR
#define S_ERR_SYMBOL 103 // UNKNOWN SYMBOL
#define S_ERR_DUPLICATE 104 // ALREADY DEFINED
#define S_ERR_RANGE 105 // VALUE TOO BIG
#define S_ERR_JR 106 // JR TOO FAR
#define S_ERR_OPERAND 107 // BAD OPERAND
#define S_ERR_SECTION 108 // NO SECTION
#define S_ERR_FULL 109 // SECTION FULL
#define S_ERR_FORWARD 110 // NOT YET DEFINED
#define S_ERR_UNSUPPORTED 111 // NOT SUPPORTED
#define S_ERR_NAME 112 // NAME TOO LONG
#define S_ERR_DIVIDE 113 // DIVIDE BY ZERO
#define S_ERR_MNEMONIC 114 // BAD INSTRUCTION
#define S_ERR_PHASE 115 // PHASE ERROR
#define S_ERR_STRING 116 // BAD STRING
#define S_ERR_SCOPE 117 // NO GLOBAL LABEL
#define S_ERR_SYMBOLS 118 // TOO MANY SYMBOLS
#define S_ERR_EMPTY 119 // NO CODE
#define S_ERR_BANK 120 // BAD BANK
#define S_ERR_ASSERT 121 // ASSERT FAILED
#define S_ERR_FILE 122 // NO SUCH FILE
#define S_ERR_NESTING 123 // TOO DEEP
#define S_ERR_OVERLAP 124 // SECTIONS OVERLAP
#define S_UNTITLED 125 // Untitled
#define S_SELECTED 126 // {} selected
#define S_LINE_COL 127 // Line {}, Col {}
#define S_SAVE_AS 128 // Save as
#define S_IN_FOLDER 129 // in
#define S_CLOCK_YEAR 130 // Year
#define S_CLOCK_MONTH 131 // Month
#define S_CLOCK_DAY 132 // Day
#define S_CLOCK_HOUR 133 // Hour
#define S_CLOCK_MINUTE 134 // Minute
#define S_CLOCK_SECOND 135 // Second
#define S_CLOCK_HINT 136 // <LR> Edit <A>Set <B>Back
#define S_CLOCK_INVALID 137 // Invalid date or no clock
#define S_HELP_HINT 138 // <UD>Scroll <B>Exit
#define S_THEME_HINT 139 // <A>Toggle <B>Back
#define S_THEME_DARK 140 // Dark mode  {}
#define S_ON 141 // On
#define S_OFF 142 // Off
#define S_INFO_TYPE 143 // Type:
#define S_INFO_SIZE 144 // Size:
#define S_INFO_CREATED 145 // Created:
#define S_INFO_ACCESSED 146 // Accessed:
#define S_INFO_MODIFIED 147 // Modified:
#define S_INFO_READ 148 // Read:
#define S_INFO_HEADER 149 // Header:
#define S_INFO_WORDS 150 // Words:
#define S_INFO_LINES 151 // Lines:
#define S_INFO_COUNTS 152 // Counts:
#define S_INFO_TITLE 153 // Title:
#define S_INFO_PLATFORM 154 // Platform:
#define S_INFO_SGB 155 // Super GB:
#define S_INFO_MAPPER 156 // Mapper:
#define S_INFO_ROM 157 // ROM:
#define S_INFO_RAM 158 // RAM:
#define S_INFO_REGION 159 // Region:
#define S_INFO_REVISION 160 // Revision:
#define S_INFO_CHECKSUM 161 // Header checksum:
#define S_TYPE_TEXT 162 // Plain Text
#define S_TYPE_MARKDOWN 163 // Markdown
#define S_TYPE_C 164 // C source
#define S_TYPE_ASM 165 // Assembly
#define S_TYPE_FOLDER 166 // Folder
#define S_TYPE_GAME 167 // Game Boy ROM
#define S_TYPE_BINARY 168 // Binary
#define S_SD_ERROR_LOWER 169 // SD error
#define S_TOO_SHORT 170 // Too short
#define S_BINARY_FILE 171 // Binary file
#define S_SKIPPED 172 // Skipped (>32KB)
#define S_GB_ONLY 173 // Game Boy
#define S_INFO_YES 174 // Yes
#define S_INFO_NO 175 // No
#define S_NONE 176 // --
#define S_RAM_MBC2 177 // 512 x 4 bits
#define S_GB_COLOR_ONLY 178 // Color only
#define S_GB_BOTH 179 // GB / Color
#define S_UNKNOWN 180 // Unknown
#define S_JAPAN 181 // Japan
#define S_OVERSEAS 182 // Overseas
#define S_CHECK_OK 183 // OK
#define S_CHECK_BAD 184 // Bad
#define S_MAPPER_TYPE 185 // type
#define S_KB_TITLE 186 // KEYBOARD TEST
#define S_KB_PS2 187 // Found at boot: PS/2
#define S_KB_NONE 188 // Found at boot: none, listening anyway
#define S_KB_CODES 189 // Raw bytes (newest last):
#define S_KB_BACK 190 // <A> Pause  <B> Back
#define S_KB_BYTES 191 // Bytes {}   with errors {}
#define S_KB_KEY 192 // Key {}   modifiers {}
#define S_KB_FINISH 193 // finish
#define S_KB_PARITY 194 // parity
#define S_KB_START 195 // start
#define S_KB_UNUSED3 196 //
#define S_KB_UNUSED4 197 //
#define S_KB_TIMEOUT 198 // timeout
#define S_TILE_N 199 // Tile
#define S_INGAME_RESUME 200 // Resume game
#define S_INGAME_SAVE 201 // Save state
#define S_INGAME_LOAD 202 // Load state
#define S_INGAME_RETURN 203 // Return to OS
#define S_INGAME_ERROR 204 // State / SD error
#define S_INGAME_FOOTER 205 // <A> Select  <B> Resume
#define S_MODULE_COPY_FAILED 206 // COPY FAILED {}:{}
#define S_BUILD_LOADING 207 // loading
#define S_BUILD_LINKING 208 // Placing sections
#define S_BUILD_FINISHING 209 // Finishing
#define S_DRIVER_NONE 210 // NONE
#define S_DRIVER_PS2 211 // PS/2 KEYBOARD
#define S_DRIVER_IGKB 212 // iGKB USB
#define S_DRIVER_SNES_MOUSE 213 // SNES MOUSE
#define S_KB_PAUSED 214 // PAUSED (A resumes)
#define S_MAP_READING 215 // Reading map...
#define S_MAP_LARGE 216 // Close the large
#define S_MAP_LARGE2 217 // file to view maps
#define S_MAP_CANT_BUILD 218 // Can't build the
#define S_MAP_ERROR_N 219 // map: error {}
#define S_MAP_WRAPPER 220 // (wrapper)
#define S_MAP_CHUNK 221 // chunk
#endif
