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
| A + D-pad | select text (on screen keyboard closed) |
| A | type the selected key |
| B | backspace |
| START | open/close the menu |
| SELECT | show/hide the on screen keyboard |

On screen keyboard bottom row: shift (one shot), symbols, menu (≡), space, undo (↶), redo (↷), new line (↵).

The top bar shows the file name (* = unsaved changes), the bottom bar the line and column, or how many
characters are selected. F11 (or FULL SCREEN in the menu) hides them. F1 (or HELP) shows the controls.

PS/2 keyboards type directly: arrows, home, end, page up/down, backspace, delete, enter.
Escape opens the menu: FILE (open, save, save as, new), EDIT (undo, redo, cut, copy, paste, select all),
SETTINGS (line wrap, full screen) and HELP (controls, keyboard test). The keyboard test shows each byte the
PS/2 keyboard sends (hex, bits and start/parity/finish/timeout errors) and the key it makes, and listens for a
keyboard even if none was found at boot (it keeps listening afterwards). B or Backspace goes back from a submenu, START or Escape closes
the menu. Ctrl+O opens, Ctrl+S saves, Ctrl+N starts a new file.
OPEN (Ctrl+O) browses the SD card: the top bar shows the folder, the bottom bar the selected file's size and date.
Folders come first, enter or A opens, backspace, left or B goes up a folder, escape goes back to the text
(so do backspace and B in the root).
Any file up to 63KB (65,408 bytes) opens as text, and in OS mode bigger files open read only (the editor reads a
48KB window of the file from the card that moves with the cursor, Ctrl+End shows "Line ?" until the lines
before it are counted), long file names (up to 64 characters) are shown. SAVE AS saves in the open
file's folder. CR LF line endings are kept.
Code is drawn with the 4 pixel fixed width font, everything else with the variable width font: C and asm
files are fixed width, plain text and markdown variable width except markdown's code.
Markdown files (.md) are styled: a line starting with # to #### and a space is a heading in a wider,
taller, bold font (8, 7, 6 and 5 pixels a character), ##### and ###### are bold, **bold** and *italic*
or _italic_ (not inside a word) are drawn bold and slanted, `code` is fixed width and red on GBC, and so
are the lines of a code block (from a line starting with ``` to the next one). The markers stay visible,
dimmed (dark grey on DMG). Headings are blue on GBC.
C (.c, .h) and RGBDS asm (.asm, .inc, .s) are highlighted: keywords and instructions are bold, comments
dimmed. On GBC keywords, types and registers are blue, strings red, numbers purple, preprocessor lines,
directives and asm labels orange (labels bold).
Alt+Z (or LINE WRAP) turns line wrapping off and on. Without it each line is one row, and the text scrolls
sideways to keep the cursor on screen.
The line wrapping and full screen settings are kept in SRAM with the text, and so are the open file's
name and folder (and whether it has unsaved changes), so after turning the Game Boy off and on the file
name bar still shows the file and OPEN starts in its folder.
Ctrl+Left/Right move a word (or run of punctuation) at a time, Ctrl+Up/Down scroll a row without moving
the cursor, Ctrl+Home/End go to the start/end of the text.
Shift + any of those keys selects text, Ctrl+A selects everything. Ctrl+X cuts, Ctrl+C copies,
Ctrl+V pastes. Typing, backspace or delete replace the selection. The clipboard holds up to 7356 characters
and is kept in SRAM. Selected text is inverted on DMG and highlighted on GBC and SGB.
Ctrl+Z undoes, Ctrl+Y (or Ctrl+Shift+Z) redoes, a word or a run of deletes at a time. The history holds about
56KB of edits and is cleared by opening a file, a new file, or turning the power off.

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
Styled text uses its own fonts, drawn as they are (not moved left). Their widths are measured from
the images: a fixed width font (headings, fixed bold) is its most common last pixel + 2 wide (a few
glyphs can draw into the gap), VWF bold is each glyph's last pixel + 2 (4 if it's empty), italic
fonts use their upright font's widths:
- img/fonts/heading1_font.png to heading4_font.png, markdown headings 1-4
- img/fonts/fixed_bold_font.png, fixed_italic_font.png, fixed_bold_italic_font.png
- img/fonts/vwf_bold_font.png, vwf_italic_font.png, vwf_bold_italic_font.png

`python3 fonts.py derive` draws any that are missing from the base fonts (headings stretched with 2
pixel strokes and 1 pixel taller, bold ORed 1 pixel right or stretched in the fixed font, italic's
top 4 rows 1 pixel right), `--force` draws them all again (overwriting edits).

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
MBC5, 1M ROM (64 banks), 128K SRAM (16 banks)

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
