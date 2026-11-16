/* Generated from data/strings/strings.csv by scripts/strings.py. */
#ifndef FATPAK_STRINGS_H
#define FATPAK_STRINGS_H
// PutStr(dest, id) and Str(id) (src/strings.asm), ModString in modules; S_PART(id, n) is the
// text after its nth {}, up to the next
#define S_PART(id, n) ((id) | ((n) << 12))
#define STR_COUNT 207
#define STR_HASH 0xFE6Au
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
#define S_SUB_KEYBOARD_TEST 28 // TEST
#define S_FILE_OPEN 29 // OPEN
#define S_FILE_OPEN_AS 30 // OPEN AS
#define S_FILE_INFO 31 // INFO
#define S_FILE_RENAME 32 // RENAME
#define S_FILE_DELETE 33 // DELETE
#define S_VIEW_TEXT 34 // TEXT
#define S_VIEW_HEX 35 // HEX
#define S_VIEW_TILES 36 // TILES
#define S_BEDIT_CUT 37 // CUT
#define S_BEDIT_COPY 38 // COPY
#define S_BEDIT_PASTE 39 // PASTE
#define S_NO 40 // NO
#define S_YES 41 // YES
#define S_LANG_EN 42 // ENGLISH
#define S_LANG_ES 43 // ESPAÑOL
#define S_DISCARD_CHANGES 44 // DISCARD CHANGES?
#define S_DELETE_TITLE 45 // DELETE {}?
#define S_NO_SD_CARD 46 // NO SD CARD
#define S_NO_FAT_VOLUME 47 // NO FAT VOLUME
#define S_SD_ERROR_N 48 // SD ERROR {}
#define S_SD_ERROR 49 // SD ERROR
#define S_DISK_FULL 50 // DISK FULL
#define S_TOO_BIG 51 // TOO BIG
#define S_SAVED 52 // SAVED
#define S_SAVE_NOT_BACKED_UP 53 // SAVE NOT BACKED UP
#define S_NOT_ASM_FILE 54 // NOT AN ASM FILE
#define S_FILE_TOO_BIG 55 // FILE TOO BIG
#define S_TOO_BIG_TO_COPY 56 // TOO BIG TO COPY
#define S_TEXT_FULL 57 // TEXT FULL
#define S_TOO_MANY_EDITS 58 // TOO MANY EDITS: SAVE
#define S_MODULE_MISSING 59 // MODULE MISSING
#define S_MODULE_DAMAGED 60 // MODULE DAMAGED
#define S_MODULE_NEWER_OS 61 // MODULE NEEDS NEW OS
#define S_RESTORE_FAILED 62 // RESTORE FAILED {}:{}
#define S_MODULE_LOAD_FAILED 63 // MODULE LOAD FAILED {}:{}
#define S_NAME_EXISTS 64 // Name already exists
#define S_CANT_PASTE 65 // Can't paste here
#define S_INVALID_NAME 66 // Invalid name/path
#define S_SD_FAILED 67 // SD operation failed
#define S_FOLDER_NOT_EMPTY 68 // Folder isn't empty
#define S_READ_ONLY 69 // File is read only
#define S_FILE_IS_OPEN 70 // File is open
#define S_CLIPBOARD_EMPTY 71 // Clipboard empty
#define S_SELECT_FILE 72 // Select file/folder
#define S_PATH_TOO_LONG 73 // Path is too long
#define S_LANGUAGE_MISSING 74 // Language file missing
#define S_BROWSER_HINT 75 // <A>Open <SELECT>Info <START>Menu
#define S_INFO_HINT 76 // <A>Open <B>Exit
#define S_LOADING 77 // Loading...
#define S_DELETING 78 // Deleting...
#define S_RESTARTING 79 // Restarting...
#define S_MOVING 80 // Moving...
#define S_COPYING 81 // Copying...
#define S_RENAMING 82 // Renaming...
#define S_READING_INFO 83 // Reading info...
#define S_ASSEMBLING 84 // Assembling...
#define S_WRITING 85 // Writing...
#define S_SAVING 86 // Saving...
#define S_PREPARING_GAME 87 // Preparing game...
#define S_LOADING_KB 88 // Loading {}/{} KB
#define S_BUILD_PASS1 89 // Pass 1: {}k lines
#define S_BUILD_PASS2 90 // Pass 2: {}%
#define S_BUILD_AT_LINE 91 // line {}
#define S_BUILD_LINE 92 // Line {}
#define S_BUILD_DONE 93 // Built {} KB
#define S_ERR_SYNTAX 94 // SYNTAX ERROR
#define S_ERR_SYMBOL 95 // UNKNOWN SYMBOL
#define S_ERR_DUPLICATE 96 // ALREADY DEFINED
#define S_ERR_RANGE 97 // VALUE TOO BIG
#define S_ERR_JR 98 // JR TOO FAR
#define S_ERR_OPERAND 99 // BAD OPERAND
#define S_ERR_SECTION 100 // NO SECTION
#define S_ERR_FULL 101 // SECTION FULL
#define S_ERR_FORWARD 102 // NOT YET DEFINED
#define S_ERR_UNSUPPORTED 103 // NOT SUPPORTED
#define S_ERR_NAME 104 // NAME TOO LONG
#define S_ERR_DIVIDE 105 // DIVIDE BY ZERO
#define S_ERR_MNEMONIC 106 // BAD INSTRUCTION
#define S_ERR_PHASE 107 // PHASE ERROR
#define S_ERR_STRING 108 // BAD STRING
#define S_ERR_SCOPE 109 // NO GLOBAL LABEL
#define S_ERR_SYMBOLS 110 // TOO MANY SYMBOLS
#define S_ERR_EMPTY 111 // NO CODE
#define S_ERR_BANK 112 // BAD BANK
#define S_ERR_ASSERT 113 // ASSERT FAILED
#define S_ERR_FILE 114 // NO SUCH FILE
#define S_ERR_NESTING 115 // TOO DEEP
#define S_ERR_OVERLAP 116 // SECTIONS OVERLAP
#define S_UNTITLED 117 // Untitled
#define S_SELECTED 118 // {} selected
#define S_LINE_COL 119 // Line {}, Col {}
#define S_SAVE_AS 120 // Save as
#define S_IN_FOLDER 121 // in
#define S_CLOCK_YEAR 122 // Year
#define S_CLOCK_MONTH 123 // Month
#define S_CLOCK_DAY 124 // Day
#define S_CLOCK_HOUR 125 // Hour
#define S_CLOCK_MINUTE 126 // Minute
#define S_CLOCK_SECOND 127 // Second
#define S_CLOCK_HINT 128 // <LR> Edit <A>Set <B>Back
#define S_CLOCK_INVALID 129 // Invalid date or no clock
#define S_HELP_HINT 130 // <UD>Scroll <B>Exit
#define S_THEME_HINT 131 // <A>Toggle <B>Back
#define S_THEME_DARK 132 // Dark mode  {}
#define S_ON 133 // On
#define S_OFF 134 // Off
#define S_INFO_TYPE 135 // Type:
#define S_INFO_SIZE 136 // Size:
#define S_INFO_CREATED 137 // Created:
#define S_INFO_ACCESSED 138 // Accessed:
#define S_INFO_MODIFIED 139 // Modified:
#define S_INFO_READ 140 // Read:
#define S_INFO_HEADER 141 // Header:
#define S_INFO_WORDS 142 // Words:
#define S_INFO_LINES 143 // Lines:
#define S_INFO_COUNTS 144 // Counts:
#define S_INFO_TITLE 145 // Title:
#define S_INFO_PLATFORM 146 // Platform:
#define S_INFO_SGB 147 // Super GB:
#define S_INFO_MAPPER 148 // Mapper:
#define S_INFO_ROM 149 // ROM:
#define S_INFO_RAM 150 // RAM:
#define S_INFO_REGION 151 // Region:
#define S_INFO_REVISION 152 // Revision:
#define S_INFO_CHECKSUM 153 // Header checksum:
#define S_TYPE_TEXT 154 // Plain Text
#define S_TYPE_MARKDOWN 155 // Markdown
#define S_TYPE_C 156 // C source
#define S_TYPE_ASM 157 // Assembly
#define S_TYPE_FOLDER 158 // Folder
#define S_TYPE_GAME 159 // Game Boy ROM
#define S_TYPE_BINARY 160 // Binary
#define S_SD_ERROR_LOWER 161 // SD error
#define S_TOO_SHORT 162 // Too short
#define S_BINARY_FILE 163 // Binary file
#define S_SKIPPED 164 // Skipped (>32KB)
#define S_GB_ONLY 165 // Game Boy
#define S_INFO_YES 166 // Yes
#define S_INFO_NO 167 // No
#define S_NONE 168 // --
#define S_RAM_MBC2 169 // 512 x 4 bits
#define S_GB_COLOR_ONLY 170 // Color only
#define S_GB_BOTH 171 // GB / Color
#define S_UNKNOWN 172 // Unknown
#define S_JAPAN 173 // Japan
#define S_OVERSEAS 174 // Overseas
#define S_CHECK_OK 175 // OK
#define S_CHECK_BAD 176 // Bad
#define S_MAPPER_TYPE 177 // type
#define S_KB_TITLE 178 // KEYBOARD TEST
#define S_KB_PS2 179 // Found at boot: PS/2
#define S_KB_NONE 180 // Found at boot: none, listening anyway
#define S_KB_CODES 181 // Raw bytes (newest last):
#define S_KB_BACK 182 // <A> Pause  <B> Back
#define S_KB_BYTES 183 // Bytes {}   with errors {}
#define S_KB_KEY 184 // Key {}   modifiers {}
#define S_KB_FINISH 185 // finish
#define S_KB_PARITY 186 // parity
#define S_KB_START 187 // start
#define S_KB_UNUSED3 188 //
#define S_KB_UNUSED4 189 //
#define S_KB_TIMEOUT 190 // timeout
#define S_TILE_N 191 // Tile
#define S_INGAME_RESUME 192 // Resume game
#define S_INGAME_SAVE 193 // Save state
#define S_INGAME_LOAD 194 // Load state
#define S_INGAME_RETURN 195 // Return to OS
#define S_INGAME_ERROR 196 // State / SD error
#define S_INGAME_FOOTER 197 // <A> Select  <B> Resume
#define S_MODULE_COPY_FAILED 198 // COPY FAILED {}:{}
#define S_BUILD_LOADING 199 // loading
#define S_BUILD_LINKING 200 // Placing sections
#define S_BUILD_FINISHING 201 // Finishing
#define S_DRIVER_NONE 202 // NONE
#define S_DRIVER_PS2 203 // PS/2 KEYBOARD
#define S_DRIVER_IGKB 204 // iGKB USB
#define S_DRIVER_SNES_MOUSE 205 // SNES MOUSE
#define S_KB_PAUSED 206 // PAUSED (A resumes)
#endif
