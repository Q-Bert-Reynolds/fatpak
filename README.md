# TEXT EDITOR
A text editor for the Game Boy, Game Boy Color, and Super Game Boy, built on the Béisbol engine.

Planned for v1:
- display and edit ASCII text with a fixed width font
- PS/2 keyboard via the link port (same adapter LSDJ uses)
- toggleable on-screen keyboard
- read/write .txt files on the EverdriveGB X-series SD card

Later: more encodings, variable width fonts, rich text, WorkBoy keyboard, iGKB, Super Game Boy mouse.

See [ARCHITECTURE.md](ARCHITECTURE.md) for how the code is organized.

# Controls
| Button | Action |
| --- | --- |
| D-pad | move cursor, or the on screen keyboard selection when it's open |
| A | type the selected key |
| B | backspace |
| START | new line |
| SELECT | show/hide the on screen keyboard |

On screen keyboard bottom row: shift (one shot), symbols, space, file menu (◆), cursor left, cursor right.

The top bar shows the file name (* = unsaved changes), the bottom bar the line and column, or how many
characters are selected. F11 (or FULL SCREEN in the menu) hides them. F1 (or HELP) shows the controls.

PS/2 keyboards type directly: arrows, home, end, page up/down, backspace, delete, enter.
Escape opens the menu (open, save, save as, new, font, full screen, help), Ctrl+O opens, Ctrl+S saves, Ctrl+N starts a new file.
Files are .TXT files in the root of the SD card with 8.3 names. CR LF line endings are kept.
Ctrl+F (or FONT in the menu) switches between the variable width and fixed width fonts.
Ctrl+Left/Right move a word (or run of punctuation) at a time, Ctrl+Up/Down scroll a row without moving
the cursor, Ctrl+Home/End go to the start/end of the text.
Shift + any of those keys selects text, Ctrl+A selects everything. Ctrl+X cuts, Ctrl+C copies,
Ctrl+V pastes. Typing, backspace or delete replace the selection. The clipboard holds up to 7356 characters
and is kept in SRAM. Selected text is inverted on DMG and highlighted on GBC and SGB.

Text is kept in SRAM, so it's still there after turning the Game Boy off.

# Engine
- FatFs (ChaN) for the SD card, split across ROM0 and two banks by bank_split.py
- asm for core routines (drawing, input, math, memory, audio), C (SDCC) for higher level logic
- PS/2 and iGKB keyboard drivers (src/keyboard)
- FX Hammer sfx (for error and confirmation sounds)
- fades, GBC palettes, SGB borders/palettes
- translated strings from CSV (en, es, fr, it, pt, de, ja)

# Fonts
The editor draws text as pixels, so fonts can be any width (src/editor/render.asm). fonts.py converts:
- img/ui_font.png, the fixed width font (every character 8 pixels)
- img/fonts/vwf_font.png, the variable width font. Glyphs are moved to the left edge of their cell
  and each character's width is its last pixel + 2. Empty glyphs (space) are 4 pixels.

Both are 16x16 grids of 8x8 glyphs indexed by character code, dark pixels are drawn.

img/ui_font.png is 256 tiles. Tile index matches the character code:
- 0-31: UI glyphs (box drawing, arrows, etc.)
- 32-126: ASCII
- 160-255: Latin-1 (ISO-8859-1), only the accented characters used by translations so far
- "\n" in engine strings is 128

# Tests
Set in src/constants.asm, run before the editor starts:
- TESTS_ENABLED
- SOUND_TEST_ENABLED
- KEYBOARD_TEST_ENABLED
- SD_TEST_ENABLED (inits the card, checks the MBR and FAT32 boot sector, writes and reads back sector 1)

# SD card
`make sdcard` builds bin/sdcard.img (64MB, MBR + FAT32) from the files in sd/. Gearboy emulates the EverDrive X SD card using sdcard.img next to the ROM, or the GEARBOY_SD_IMAGE environment variable.

# Compiling:
    make clean
    make all

`make assemble` builds without regenerating assets or running the emulator. Pick a language with `make assemble LANGUAGE=ES`.

# Cart:
MBC5, 1M ROM (64 banks), 32K SRAM (4 banks)

# Credits

- Code, Art, Audio - Nolan Baker
- hardware.inc - Jones, Carsten Sorenson, Jeff Frohwein, Antonio Niño Díaz
- memory1.asm - Jeff Frohwein, Carsten Sorensen
- gbdk.asm - Pascal Felber, Lars Malmborg, Michael Hope
- sgb.asm - Imanol Barriuso, Martin Ahrnbom
- FatFs - ChaN (src/fatfs/lib, BSD style license)
- sd.asm - based on TXTReaderGB's diskio by Toxa and RodrigoCard (MIT)
- vwf_font.png - ASCII glyphs from Toxa's VWF (MIT)

# Thanks

- [Jeff Frohwein](https://devrs.com/gb/)
- [John Metcalf](http://www.retroprogramming.com)
- [Z80 Heaven](https://z80-heaven.wikidot.com/)
- [GameBoy Pandocs](https://gbdev.github.io/pandocs/):
- [GameBoy CPU Manual](http://marc.rawer.de/Gameboy/Docs/GBCPUman.pdf)
- [untoxa/VWF](https://github.com/untoxa/VWF)
- [RodrigoCard/TXTReaderGB](https://github.com/RodrigoCard/TXTReaderGB)
