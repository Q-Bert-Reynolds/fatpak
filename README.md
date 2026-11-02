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
Escape opens the menu (open, save, save as, new, font, line wrap, full screen, help), Ctrl+O opens, Ctrl+S saves, Ctrl+N starts a new file.
OPEN (Ctrl+O) browses the SD card: the top bar shows the folder, the bottom bar the selected file's size and date.
Folders come first, enter or A opens, backspace, left or B goes up a folder, escape goes back to the text
(so do backspace and B in the root).
Any file up to 24KB opens as text, long file names (up to 64 characters) are shown. SAVE AS saves in the open
file's folder. CR LF line endings are kept.
Ctrl+F (or FONT in the menu) switches between the fixed width font (the default) and the variable width font.
Alt+Z (or LINE WRAP) turns line wrapping off and on. Without it each line is one row, and the text scrolls
sideways to keep the cursor on screen.
The font, line wrapping and full screen settings are kept in SRAM with the text, and so are the open file's
name and folder (and whether it has unsaved changes), so after turning the Game Boy off and on the file
name bar still shows the file and OPEN starts in its folder.
Ctrl+Left/Right move a word (or run of punctuation) at a time, Ctrl+Up/Down scroll a row without moving
the cursor, Ctrl+Home/End go to the start/end of the text.
Shift + any of those keys selects text, Ctrl+A selects everything. Ctrl+X cuts, Ctrl+C copies,
Ctrl+V pastes. Typing, backspace or delete replace the selection. The clipboard holds up to 7356 characters
and is kept in SRAM. Selected text is inverted on DMG and highlighted on GBC and SGB.

Text is kept in SRAM, so it's still there after turning the Game Boy off.

# Engine
- FatFs (ChaN) with long file names for the SD card, split across ROM0 and three banks by bank_split.py
- asm for core routines (drawing, input, math, memory, audio), C (SDCC) for higher level logic
- PS/2 and iGKB keyboard drivers (src/keyboard)
- FX Hammer sfx (for error and confirmation sounds)
- fades, GBC palettes, SGB borders/palettes
- translated strings from CSV (en, es, fr, it, pt, de, ja)

# Fonts
The editor draws text as pixels, so fonts can be any width (src/editor/render.asm). fonts.py converts:
- img/ui_font.png, the 8 pixel fixed width font (the on screen keyboard)
- img/fonts/fixed_font.png, the 4 pixel fixed width font for text (40 characters per row), the
  left 4 pixels of each cell
- img/fonts/tiny5mono_font.png, a 6 pixel fixed width font (26 characters per row), not built yet
  (see font selection in TODO.md)
- img/fonts/vwf_font.png, the variable width font. Glyphs are moved to the left edge of their cell
  and each character's width is its last pixel + 2. Empty glyphs (space) are 4 pixels.

All are 16x16 grids of 8x8 glyphs indexed by character code, dark pixels are drawn.

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
Gearboy (the ps2keyboard branch of the fork) emulates the EverDrive X SD card with a folder on your computer, the
home folder unless EverDrive X SD Folder... in its menu picks another (or GEARBOY_SD_DIR for one run). The Game Boy
can read everything in it, saving writes the file straight to that folder. Nothing on your computer is ever deleted.
`make sdcard` still builds bin/sdcard.img (64MB, MBR + FAT32) from sd/, GEARBOY_SD_IMAGE=bin/sdcard.img uses it instead.

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
- fixed_font.png - ASCII glyphs from Damian Yerrick's onebit4x8.png (pinobatch/bitmap-fonts, MIT No Attribution)
- tiny5mono_font.png - Tiny5 Mono by Stefan Schmidt (Gissio/font_Tiny5Mono, SIL Open Font License, img/fonts/Tiny5Mono-OFL.txt)

# Thanks

- [Jeff Frohwein](https://devrs.com/gb/)
- [John Metcalf](http://www.retroprogramming.com)
- [Z80 Heaven](https://z80-heaven.wikidot.com/)
- [GameBoy Pandocs](https://gbdev.github.io/pandocs/):
- [GameBoy CPU Manual](http://marc.rawer.de/Gameboy/Docs/GBCPUman.pdf)
- [untoxa/VWF](https://github.com/untoxa/VWF)
- [RodrigoCard/TXTReaderGB](https://github.com/RodrigoCard/TXTReaderGB)
