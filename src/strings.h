/* Generated from data/strings/strings.csv by scripts/strings.py. */
#ifndef FATPAK_STRINGS_H
#define FATPAK_STRINGS_H
// PutStr(dest, id) and Str(id) (src/strings.asm), ModString in modules; S_PART(id, n) is the
// text after its nth {}, up to the next
#define S_PART(id, n) ((id) | ((n) << 12))
#define STR_COUNT 208
#define STR_HASH 0x785Eu
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
#define S_BUILD_AT_LINE 92 // line {}
#define S_BUILD_LINE 93 // Line {}
#define S_BUILD_DONE 94 // Built {} KB
#define S_ERR_SYNTAX 95 // SYNTAX ERROR
#define S_ERR_SYMBOL 96 // UNKNOWN SYMBOL
#define S_ERR_DUPLICATE 97 // ALREADY DEFINED
#define S_ERR_RANGE 98 // VALUE TOO BIG
#define S_ERR_JR 99 // JR TOO FAR
#define S_ERR_OPERAND 100 // BAD OPERAND
#define S_ERR_SECTION 101 // NO SECTION
#define S_ERR_FULL 102 // SECTION FULL
#define S_ERR_FORWARD 103 // NOT YET DEFINED
#define S_ERR_UNSUPPORTED 104 // NOT SUPPORTED
#define S_ERR_NAME 105 // NAME TOO LONG
#define S_ERR_DIVIDE 106 // DIVIDE BY ZERO
#define S_ERR_MNEMONIC 107 // BAD INSTRUCTION
#define S_ERR_PHASE 108 // PHASE ERROR
#define S_ERR_STRING 109 // BAD STRING
#define S_ERR_SCOPE 110 // NO GLOBAL LABEL
#define S_ERR_SYMBOLS 111 // TOO MANY SYMBOLS
#define S_ERR_EMPTY 112 // NO CODE
#define S_ERR_BANK 113 // BAD BANK
#define S_ERR_ASSERT 114 // ASSERT FAILED
#define S_ERR_FILE 115 // NO SUCH FILE
#define S_ERR_NESTING 116 // TOO DEEP
#define S_ERR_OVERLAP 117 // SECTIONS OVERLAP
#define S_UNTITLED 118 // Untitled
#define S_SELECTED 119 // {} selected
#define S_LINE_COL 120 // Line {}, Col {}
#define S_SAVE_AS 121 // Save as
#define S_IN_FOLDER 122 // in
#define S_CLOCK_YEAR 123 // Year
#define S_CLOCK_MONTH 124 // Month
#define S_CLOCK_DAY 125 // Day
#define S_CLOCK_HOUR 126 // Hour
#define S_CLOCK_MINUTE 127 // Minute
#define S_CLOCK_SECOND 128 // Second
#define S_CLOCK_HINT 129 // <LR> Edit <A>Set <B>Back
#define S_CLOCK_INVALID 130 // Invalid date or no clock
#define S_HELP_HINT 131 // <UD>Scroll <B>Exit
#define S_THEME_HINT 132 // <A>Toggle <B>Back
#define S_THEME_DARK 133 // Dark mode  {}
#define S_ON 134 // On
#define S_OFF 135 // Off
#define S_INFO_TYPE 136 // Type:
#define S_INFO_SIZE 137 // Size:
#define S_INFO_CREATED 138 // Created:
#define S_INFO_ACCESSED 139 // Accessed:
#define S_INFO_MODIFIED 140 // Modified:
#define S_INFO_READ 141 // Read:
#define S_INFO_HEADER 142 // Header:
#define S_INFO_WORDS 143 // Words:
#define S_INFO_LINES 144 // Lines:
#define S_INFO_COUNTS 145 // Counts:
#define S_INFO_TITLE 146 // Title:
#define S_INFO_PLATFORM 147 // Platform:
#define S_INFO_SGB 148 // Super GB:
#define S_INFO_MAPPER 149 // Mapper:
#define S_INFO_ROM 150 // ROM:
#define S_INFO_RAM 151 // RAM:
#define S_INFO_REGION 152 // Region:
#define S_INFO_REVISION 153 // Revision:
#define S_INFO_CHECKSUM 154 // Header checksum:
#define S_TYPE_TEXT 155 // Plain Text
#define S_TYPE_MARKDOWN 156 // Markdown
#define S_TYPE_C 157 // C source
#define S_TYPE_ASM 158 // Assembly
#define S_TYPE_FOLDER 159 // Folder
#define S_TYPE_GAME 160 // Game Boy ROM
#define S_TYPE_BINARY 161 // Binary
#define S_SD_ERROR_LOWER 162 // SD error
#define S_TOO_SHORT 163 // Too short
#define S_BINARY_FILE 164 // Binary file
#define S_SKIPPED 165 // Skipped (>32KB)
#define S_GB_ONLY 166 // Game Boy
#define S_INFO_YES 167 // Yes
#define S_INFO_NO 168 // No
#define S_NONE 169 // --
#define S_RAM_MBC2 170 // 512 x 4 bits
#define S_GB_COLOR_ONLY 171 // Color only
#define S_GB_BOTH 172 // GB / Color
#define S_UNKNOWN 173 // Unknown
#define S_JAPAN 174 // Japan
#define S_OVERSEAS 175 // Overseas
#define S_CHECK_OK 176 // OK
#define S_CHECK_BAD 177 // Bad
#define S_MAPPER_TYPE 178 // type
#define S_KB_TITLE 179 // KEYBOARD TEST
#define S_KB_PS2 180 // Found at boot: PS/2
#define S_KB_NONE 181 // Found at boot: none, listening anyway
#define S_KB_CODES 182 // Raw bytes (newest last):
#define S_KB_BACK 183 // <A> Pause  <B> Back
#define S_KB_BYTES 184 // Bytes {}   with errors {}
#define S_KB_KEY 185 // Key {}   modifiers {}
#define S_KB_FINISH 186 // finish
#define S_KB_PARITY 187 // parity
#define S_KB_START 188 // start
#define S_KB_UNUSED3 189 //
#define S_KB_UNUSED4 190 //
#define S_KB_TIMEOUT 191 // timeout
#define S_TILE_N 192 // Tile
#define S_INGAME_RESUME 193 // Resume game
#define S_INGAME_SAVE 194 // Save state
#define S_INGAME_LOAD 195 // Load state
#define S_INGAME_RETURN 196 // Return to OS
#define S_INGAME_ERROR 197 // State / SD error
#define S_INGAME_FOOTER 198 // <A> Select  <B> Resume
#define S_MODULE_COPY_FAILED 199 // COPY FAILED {}:{}
#define S_BUILD_LOADING 200 // loading
#define S_BUILD_LINKING 201 // Placing sections
#define S_BUILD_FINISHING 202 // Finishing
#define S_DRIVER_NONE 203 // NONE
#define S_DRIVER_PS2 204 // PS/2 KEYBOARD
#define S_DRIVER_IGKB 205 // iGKB USB
#define S_DRIVER_SNES_MOUSE 206 // SNES MOUSE
#define S_KB_PAUSED 207 // PAUSED (A resumes)
#endif
