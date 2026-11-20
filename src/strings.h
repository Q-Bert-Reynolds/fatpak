/* Generated from data/strings/strings.csv by scripts/strings.py. */
#ifndef FATPAK_STRINGS_H
#define FATPAK_STRINGS_H
// PutStr(dest, id) and Str(id) (src/strings.asm), ModString in modules; S_PART(id, n) is the
// text after its nth {}, up to the next
#define S_PART(id, n) ((id) | ((n) << 12))
#define STR_COUNT 225
#define STR_HASH 0xDB53u
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
#define S_WRITING 95 // Writing...
#define S_SAVING 96 // Saving...
#define S_PREPARING_GAME 97 // Preparing game...
#define S_LOADING_KB 98 // Loading {}/{} KB
#define S_BUILD_PASS1 99 // Pass 1: {}k lines
#define S_BUILD_PASS2 100 // Pass 2: {}%
#define S_BUILD_UNIT 101 // Assembling: {}%
#define S_BUILD_AT_LINE 102 // line {}
#define S_BUILD_LINE 103 // Line {}
#define S_BUILD_DONE 104 // Built {} KB
#define S_ERR_SYNTAX 105 // SYNTAX ERROR
#define S_ERR_SYMBOL 106 // UNKNOWN SYMBOL
#define S_ERR_DUPLICATE 107 // ALREADY DEFINED
#define S_ERR_RANGE 108 // VALUE TOO BIG
#define S_ERR_JR 109 // JR TOO FAR
#define S_ERR_OPERAND 110 // BAD OPERAND
#define S_ERR_SECTION 111 // NO SECTION
#define S_ERR_FULL 112 // SECTION FULL
#define S_ERR_FORWARD 113 // NOT YET DEFINED
#define S_ERR_UNSUPPORTED 114 // NOT SUPPORTED
#define S_ERR_NAME 115 // NAME TOO LONG
#define S_ERR_DIVIDE 116 // DIVIDE BY ZERO
#define S_ERR_MNEMONIC 117 // BAD INSTRUCTION
#define S_ERR_PHASE 118 // PHASE ERROR
#define S_ERR_STRING 119 // BAD STRING
#define S_ERR_SCOPE 120 // NO GLOBAL LABEL
#define S_ERR_SYMBOLS 121 // TOO MANY SYMBOLS
#define S_ERR_EMPTY 122 // NO CODE
#define S_ERR_BANK 123 // BAD BANK
#define S_ERR_ASSERT 124 // ASSERT FAILED
#define S_ERR_FILE 125 // NO SUCH FILE
#define S_ERR_NESTING 126 // TOO DEEP
#define S_ERR_OVERLAP 127 // SECTIONS OVERLAP
#define S_UNTITLED 128 // Untitled
#define S_SELECTED 129 // {} selected
#define S_LINE_COL 130 // Line {}, Col {}
#define S_SAVE_AS 131 // Save as
#define S_IN_FOLDER 132 // in
#define S_CLOCK_YEAR 133 // Year
#define S_CLOCK_MONTH 134 // Month
#define S_CLOCK_DAY 135 // Day
#define S_CLOCK_HOUR 136 // Hour
#define S_CLOCK_MINUTE 137 // Minute
#define S_CLOCK_SECOND 138 // Second
#define S_CLOCK_HINT 139 // <LR> Edit <A>Set <B>Back
#define S_CLOCK_INVALID 140 // Invalid date or no clock
#define S_HELP_HINT 141 // <UD>Scroll <B>Exit
#define S_THEME_HINT 142 // <A>Toggle <B>Back
#define S_THEME_DARK 143 // Dark mode  {}
#define S_ON 144 // On
#define S_OFF 145 // Off
#define S_INFO_TYPE 146 // Type:
#define S_INFO_SIZE 147 // Size:
#define S_INFO_CREATED 148 // Created:
#define S_INFO_ACCESSED 149 // Accessed:
#define S_INFO_MODIFIED 150 // Modified:
#define S_INFO_READ 151 // Read:
#define S_INFO_HEADER 152 // Header:
#define S_INFO_WORDS 153 // Words:
#define S_INFO_LINES 154 // Lines:
#define S_INFO_COUNTS 155 // Counts:
#define S_INFO_TITLE 156 // Title:
#define S_INFO_PLATFORM 157 // Platform:
#define S_INFO_SGB 158 // Super GB:
#define S_INFO_MAPPER 159 // Mapper:
#define S_INFO_ROM 160 // ROM:
#define S_INFO_RAM 161 // RAM:
#define S_INFO_REGION 162 // Region:
#define S_INFO_REVISION 163 // Revision:
#define S_INFO_CHECKSUM 164 // Header checksum:
#define S_TYPE_TEXT 165 // Plain Text
#define S_TYPE_MARKDOWN 166 // Markdown
#define S_TYPE_C 167 // C source
#define S_TYPE_ASM 168 // Assembly
#define S_TYPE_FOLDER 169 // Folder
#define S_TYPE_GAME 170 // Game Boy ROM
#define S_TYPE_BINARY 171 // Binary
#define S_SD_ERROR_LOWER 172 // SD error
#define S_TOO_SHORT 173 // Too short
#define S_BINARY_FILE 174 // Binary file
#define S_SKIPPED 175 // Skipped (>32KB)
#define S_GB_ONLY 176 // Game Boy
#define S_INFO_YES 177 // Yes
#define S_INFO_NO 178 // No
#define S_NONE 179 // --
#define S_RAM_MBC2 180 // 512 x 4 bits
#define S_GB_COLOR_ONLY 181 // Color only
#define S_GB_BOTH 182 // GB / Color
#define S_UNKNOWN 183 // Unknown
#define S_JAPAN 184 // Japan
#define S_OVERSEAS 185 // Overseas
#define S_CHECK_OK 186 // OK
#define S_CHECK_BAD 187 // Bad
#define S_MAPPER_TYPE 188 // type
#define S_KB_TITLE 189 // KEYBOARD TEST
#define S_KB_PS2 190 // Found at boot: PS/2
#define S_KB_NONE 191 // Found at boot: none, listening anyway
#define S_KB_CODES 192 // Raw bytes (newest last):
#define S_KB_BACK 193 // <A> Pause  <B> Back
#define S_KB_BYTES 194 // Bytes {}   with errors {}
#define S_KB_KEY 195 // Key {}   modifiers {}
#define S_KB_FINISH 196 // finish
#define S_KB_PARITY 197 // parity
#define S_KB_START 198 // start
#define S_KB_UNUSED3 199 //
#define S_KB_UNUSED4 200 //
#define S_KB_TIMEOUT 201 // timeout
#define S_TILE_N 202 // Tile
#define S_INGAME_RESUME 203 // Resume game
#define S_INGAME_SAVE 204 // Save state
#define S_INGAME_LOAD 205 // Load state
#define S_INGAME_RETURN 206 // Return to OS
#define S_INGAME_ERROR 207 // State / SD error
#define S_INGAME_FOOTER 208 // <A> Select  <B> Resume
#define S_MODULE_COPY_FAILED 209 // COPY FAILED {}:{}
#define S_BUILD_LOADING 210 // loading
#define S_BUILD_LINKING 211 // Placing sections
#define S_BUILD_FINISHING 212 // Finishing
#define S_DRIVER_NONE 213 // NONE
#define S_DRIVER_PS2 214 // PS/2 KEYBOARD
#define S_DRIVER_IGKB 215 // iGKB USB
#define S_DRIVER_SNES_MOUSE 216 // SNES MOUSE
#define S_KB_PAUSED 217 // PAUSED (A resumes)
#define S_MAP_READING 218 // Reading map...
#define S_MAP_LARGE 219 // Close the large
#define S_MAP_LARGE2 220 // file to view maps
#define S_MAP_CANT_BUILD 221 // Can't build the
#define S_MAP_ERROR_N 222 // map: error {}
#define S_MAP_WRAPPER 223 // (wrapper)
#define S_MAP_CHUNK 224 // chunk
#endif
