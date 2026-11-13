/* Generated from data/strings/strings.csv by scripts/strings.py. */
#ifndef FATPAK_STRINGS_H
#define FATPAK_STRINGS_H
// PutStr(dest, id) and Str(id) (src/strings.asm), ModString in modules; S_PART(id, n) is the
// text after its nth {}, up to the next
#define S_PART(id, n) ((id) | ((n) << 12))
#define STR_COUNT 198
#define STR_HASH 0xF507u
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
#define S_SUB_KEYBOARD_TEST 27 // KEYBOARD TEST
#define S_FILE_OPEN 28 // OPEN
#define S_FILE_OPEN_AS 29 // OPEN AS
#define S_FILE_INFO 30 // INFO
#define S_FILE_RENAME 31 // RENAME
#define S_FILE_DELETE 32 // DELETE
#define S_VIEW_TEXT 33 // TEXT
#define S_VIEW_HEX 34 // HEX
#define S_VIEW_TILES 35 // TILES
#define S_BEDIT_CUT 36 // CUT
#define S_BEDIT_COPY 37 // COPY
#define S_BEDIT_PASTE 38 // PASTE
#define S_NO 39 // NO
#define S_YES 40 // YES
#define S_LANG_EN 41 // ENGLISH
#define S_LANG_ES 42 // ESPAÑOL
#define S_DISCARD_CHANGES 43 // DISCARD CHANGES?
#define S_DELETE_TITLE 44 // DELETE {}?
#define S_NO_SD_CARD 45 // NO SD CARD
#define S_NO_FAT_VOLUME 46 // NO FAT VOLUME
#define S_SD_ERROR_N 47 // SD ERROR {}
#define S_SD_ERROR 48 // SD ERROR
#define S_DISK_FULL 49 // DISK FULL
#define S_TOO_BIG 50 // TOO BIG
#define S_SAVED 51 // SAVED
#define S_SAVE_NOT_BACKED_UP 52 // SAVE NOT BACKED UP
#define S_NOT_ASM_FILE 53 // NOT AN ASM FILE
#define S_FILE_TOO_BIG 54 // FILE TOO BIG
#define S_TOO_BIG_TO_COPY 55 // TOO BIG TO COPY
#define S_TEXT_FULL 56 // TEXT FULL
#define S_TOO_MANY_EDITS 57 // TOO MANY EDITS: SAVE
#define S_MODULE_MISSING 58 // MODULE MISSING
#define S_MODULE_DAMAGED 59 // MODULE DAMAGED
#define S_MODULE_NEWER_OS 60 // MODULE NEEDS NEW OS
#define S_RESTORE_FAILED 61 // RESTORE FAILED {}:{}
#define S_MODULE_LOAD_FAILED 62 // MODULE LOAD FAILED {}:{}
#define S_NAME_EXISTS 63 // Name already exists
#define S_CANT_PASTE 64 // Can't paste here
#define S_INVALID_NAME 65 // Invalid name/path
#define S_SD_FAILED 66 // SD operation failed
#define S_FOLDER_NOT_EMPTY 67 // Folder isn't empty
#define S_READ_ONLY 68 // File is read only
#define S_FILE_IS_OPEN 69 // File is open
#define S_CLIPBOARD_EMPTY 70 // Clipboard empty
#define S_SELECT_FILE 71 // Select file/folder
#define S_PATH_TOO_LONG 72 // Path is too long
#define S_LANGUAGE_MISSING 73 // Language file missing
#define S_BROWSER_HINT 74 // <A>Open <SELECT>Info <START>Menu
#define S_INFO_HINT 75 // <A>Open <B>Exit
#define S_LOADING 76 // Loading...
#define S_DELETING 77 // Deleting...
#define S_RESTARTING 78 // Restarting...
#define S_MOVING 79 // Moving...
#define S_COPYING 80 // Copying...
#define S_RENAMING 81 // Renaming...
#define S_READING_INFO 82 // Reading info...
#define S_ASSEMBLING 83 // Assembling...
#define S_WRITING 84 // Writing...
#define S_SAVING 85 // Saving...
#define S_PREPARING_GAME 86 // Preparing game...
#define S_LOADING_KB 87 // Loading {}/{} KB
#define S_BUILD_PASS1 88 // Pass 1: {}k lines
#define S_BUILD_PASS2 89 // Pass 2: {}%
#define S_BUILD_AT_LINE 90 // line {}
#define S_BUILD_LINE 91 // Line {}
#define S_BUILD_DONE 92 // Built {} KB
#define S_ERR_SYNTAX 93 // SYNTAX ERROR
#define S_ERR_SYMBOL 94 // UNKNOWN SYMBOL
#define S_ERR_DUPLICATE 95 // ALREADY DEFINED
#define S_ERR_RANGE 96 // VALUE TOO BIG
#define S_ERR_JR 97 // JR TOO FAR
#define S_ERR_OPERAND 98 // BAD OPERAND
#define S_ERR_SECTION 99 // NO SECTION
#define S_ERR_FULL 100 // SECTION FULL
#define S_ERR_FORWARD 101 // NOT YET DEFINED
#define S_ERR_UNSUPPORTED 102 // NOT SUPPORTED
#define S_ERR_NAME 103 // NAME TOO LONG
#define S_ERR_DIVIDE 104 // DIVIDE BY ZERO
#define S_ERR_MNEMONIC 105 // BAD INSTRUCTION
#define S_ERR_PHASE 106 // PHASE ERROR
#define S_ERR_STRING 107 // BAD STRING
#define S_ERR_SCOPE 108 // NO GLOBAL LABEL
#define S_ERR_SYMBOLS 109 // TOO MANY SYMBOLS
#define S_ERR_EMPTY 110 // NO CODE
#define S_ERR_BANK 111 // BAD BANK
#define S_ERR_ASSERT 112 // ASSERT FAILED
#define S_ERR_FILE 113 // NO SUCH FILE
#define S_ERR_NESTING 114 // TOO DEEP
#define S_ERR_OVERLAP 115 // SECTIONS OVERLAP
#define S_UNTITLED 116 // Untitled
#define S_SELECTED 117 // {} selected
#define S_LINE_COL 118 // Line {}, Col {}
#define S_SAVE_AS 119 // Save as
#define S_IN_FOLDER 120 // in
#define S_CLOCK_YEAR 121 // Year
#define S_CLOCK_MONTH 122 // Month
#define S_CLOCK_DAY 123 // Day
#define S_CLOCK_HOUR 124 // Hour
#define S_CLOCK_MINUTE 125 // Minute
#define S_CLOCK_SECOND 126 // Second
#define S_CLOCK_HINT 127 // <LR> Edit <A>Set <B>Back
#define S_CLOCK_INVALID 128 // Invalid date or no clock
#define S_HELP_HINT 129 // <UD>Scroll <B>Exit
#define S_THEME_HINT 130 // <A>Toggle <B>Back
#define S_THEME_DARK 131 // Dark mode  {}
#define S_ON 132 // On
#define S_OFF 133 // Off
#define S_INFO_TYPE 134 // Type:
#define S_INFO_SIZE 135 // Size:
#define S_INFO_CREATED 136 // Created:
#define S_INFO_ACCESSED 137 // Accessed:
#define S_INFO_MODIFIED 138 // Modified:
#define S_INFO_READ 139 // Read:
#define S_INFO_HEADER 140 // Header:
#define S_INFO_WORDS 141 // Words:
#define S_INFO_LINES 142 // Lines:
#define S_INFO_COUNTS 143 // Counts:
#define S_INFO_TITLE 144 // Title:
#define S_INFO_PLATFORM 145 // Platform:
#define S_INFO_SGB 146 // Super GB:
#define S_INFO_MAPPER 147 // Mapper:
#define S_INFO_ROM 148 // ROM:
#define S_INFO_RAM 149 // RAM:
#define S_INFO_REGION 150 // Region:
#define S_INFO_REVISION 151 // Revision:
#define S_INFO_CHECKSUM 152 // Header checksum:
#define S_TYPE_TEXT 153 // Plain Text
#define S_TYPE_MARKDOWN 154 // Markdown
#define S_TYPE_C 155 // C source
#define S_TYPE_ASM 156 // Assembly
#define S_TYPE_FOLDER 157 // Folder
#define S_TYPE_GAME 158 // Game Boy ROM
#define S_TYPE_BINARY 159 // Binary
#define S_SD_ERROR_LOWER 160 // SD error
#define S_TOO_SHORT 161 // Too short
#define S_BINARY_FILE 162 // Binary file
#define S_SKIPPED 163 // Skipped (>32KB)
#define S_GB_ONLY 164 // Game Boy
#define S_INFO_YES 165 // Yes
#define S_INFO_NO 166 // No
#define S_NONE 167 // --
#define S_RAM_MBC2 168 // 512 x 4 bits
#define S_GB_COLOR_ONLY 169 // Color only
#define S_GB_BOTH 170 // GB / Color
#define S_UNKNOWN 171 // Unknown
#define S_JAPAN 172 // Japan
#define S_OVERSEAS 173 // Overseas
#define S_CHECK_OK 174 // OK
#define S_CHECK_BAD 175 // Bad
#define S_MAPPER_TYPE 176 // type
#define S_KB_TITLE 177 // KEYBOARD TEST
#define S_KB_PS2 178 // Found at boot: PS/2
#define S_KB_IGKB 179 // Found at boot: iGKB
#define S_KB_NONE 180 // Found at boot: none, listening anyway
#define S_KB_CODES 181 // Scan codes (newest last):
#define S_KB_BACK 182 // <B>/<START> Back
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
#endif
