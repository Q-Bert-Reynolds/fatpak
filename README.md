# FatPak

FatPak is an operating system for the EverDrive GB X7, with a file browser, a text
editor, and a game launcher for the Game Boy, Game Boy Color, and Super Game Boy.
It is built on the Béisbol engine.

Browse and manage files and folders on the SD card, edit text with a PS/2 keyboard
or the on-screen keyboard, and launch Game Boy games with stock-compatible battery
saves, RTC files, save states, and cheats. The text editor supports variable-width
and styled fonts, Markdown, and C and assembly syntax highlighting.

See [Architecture](notes/ARCHITECTURE.md) for the implementation,
[EverDrive compatibility](notes/EVERDRIVE_FEATURES.md) for game files and limits,
and [TODO](notes/TODO.md) for remaining work. Other project notes live in `notes/`.

# File browser

FatPak starts in the file browser. Folders come first; A or Enter opens a file or
folder, and B, Backspace, or Left goes up a folder. Escape returns to the text
editor; B or Backspace does the same at the root.

SELECT opens file info directly. START opens the browser menu: FILE (info, rename), EDIT (cut, copy, paste),
SETTINGS (clock, keyboard test), HELP, and RESTART. Rename uses the on-screen
keyboard and supports undo/redo. File info shows timestamps, file type and size,
word/line counts for text files up to 32KB, and cartridge header details for games.
RESTART performs a full device restart, including the Nintendo splash.

The header shows the current folder, or the filename when viewing file info.
Every visible footer shows the current time at the bottom right in 12-hour format,
such as `10:42pm`. Footer hints use gamepad button icons. Help is scrollable; B or Escape exits help and file info.

# Text editor controls

| Button | Action |
| --- | --- |
| D-pad | move cursor, or the on screen keyboard selection when it's open |
| A + D-pad | select text (on screen keyboard closed) |
| A | type the selected key |
| B | backspace |
| START | open/close the menu |
| SELECT | show/hide the on screen keyboard |

On screen keyboard bottom row: shift (one shot), symbols, menu (≡), space, undo (↶), redo (↷), new line (↵).

The top bar shows the file name (* = unsaved changes). The editor footer shows
the line and column, or the selection count, on the left. Every visible footer
shows the current time at the bottom right in 12-hour format, such as `10:42pm`.
F11 (or FULL SCREEN in the menu) hides the editor's bars. F1 (or HELP) shows the controls.

PS/2 keyboards type directly: arrows, home, end, page up/down, backspace, delete, enter.
Escape opens the menu: FILE (open, save, save as, new), EDIT (undo, redo, cut, copy, paste, select all),
SETTINGS (line wrap, full screen), HELP (editor controls) and CLOSE (the file browser).
The browser settings menu's keyboard test shows each byte the
PS/2 keyboard sends (hex, bits and start/parity/finish/timeout errors) and the key it makes, and listens for a
keyboard even if none was found at boot (it keeps listening afterwards). B or Backspace goes back from a submenu, START or Escape closes
the menu. Ctrl+O opens, Ctrl+S saves, Ctrl+N starts a new file.
OPEN (Ctrl+O) returns to the file browser.
Files up to 63.5 KiB (65,024 bytes) open as text, and bigger files open too (the editor reads a
48KB window of the file from the card that moves with the cursor, Ctrl+End shows "Line ?" until the lines
before it are counted; saving one writes ~EDITOR.TMP in its folder and renames it over the file, and unsaved
edits to one don't survive a reset), long file names (up to 64 characters) are shown. SAVE AS saves in the open
file's folder. .gb and .gbc files launch: the game is copied to the cart, its save comes from
/GBCSYS/SAVE/<name>.srm (where the EverDrive's OS keeps them) and goes back there at the next boot. The cart's system
button combo (Select+Start unless changed in the EverDrive's OS) opens Resume game, Save state,
Load state, and Return to OS (which backs up the save). RTC clocks, state files, cheats and save ownership
use stock EverDrive formats; see [EVERDRIVE_FEATURES.md](notes/EVERDRIVE_FEATURES.md). CR LF line endings are kept.
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
The line wrapping and full screen settings are kept in PSRAM and the SD swap with the text, and so are the open file's
name and folder (and whether it has unsaved changes), so after turning the Game Boy off and on the file
name bar still shows the file and OPEN starts in its folder.
Ctrl+Left/Right move a word (or run of punctuation) at a time, Ctrl+Up/Down scroll a row without moving
the cursor, Ctrl+Home/End go to the start/end of the text.
Shift + any of those keys selects text, Ctrl+A selects everything. Ctrl+X cuts, Ctrl+C copies,
Ctrl+V pastes. Typing, backspace or delete replace the selection. The clipboard holds up to 7936 characters
and is kept in PSRAM and the SD swap. Selected text is inverted on DMG and highlighted on GBC and SGB.
Ctrl+Z undoes, Ctrl+Y (or Ctrl+Shift+Z) redoes, a word or a run of deletes at a time. The history uses a 56 KiB log and is cleared by opening a file, a new file, or turning the power off.

Editor text, settings and clipboard live in PSRAM while running. The OS swap file
(`/GBCSYS/EDITOR.SWP`) preserves them on the SD card across power-off; unsaved large-file
windows are the exception described above.

# Engine
- FatFs (ChaN) with long file names for the SD card, split across resident code and OS pages by bank_split.py
- asm for core routines (drawing, input, math, memory), C (SDCC) for higher level logic
- PS/2 and iGKB keyboard drivers (src/keyboard)
- fades, GBC palettes, SGB borders/palettes
- translated strings from CSV (en, es, fr, it, pt, de, ja)

# Source layout

Application startup and menus live in `src/app`, file browsing in `src/browser`, shared drawing in
`src/ui`, and ROM loading/cart menus/save states in `src/game`. `src/editor` contains text editing,
document handling, navigation, the on-screen keyboard, syntax and undo. See
[Architecture](notes/ARCHITECTURE.md#source-layout) for module details and banked C calls.

# Fonts
The editor draws text as pixels, so fonts can be any width (src/ui/render.asm). fonts.py converts:
- img/ui_font.png, the 8 pixel fixed width font (the on screen keyboard)
- img/fonts/fixed_font.png, the 4 pixel fixed width font for text (40 characters per row), the
  left 4 pixels of each cell
- img/fonts/tiny5mono_font.png, a 6 pixel fixed width font (26 characters per row), not built yet
  (see font selection in [TODO.md](notes/TODO.md))
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
Run `python3 -m unittest discover -s tests -v` to check C module bank placement.
The browser settings menu's keyboard test checks PS/2 and iGKB input. See
[IN_GAME_MENU.md](notes/IN_GAME_MENU.md) for cart-menu validation. With the sibling
Gearboy checkout, `make -C ../Gearboy/tests fatpak` runs assembled-OS integration
tests against temporary SD folders; `make -C ../Gearboy/tests everdrive` runs the
standalone cartridge component tests.

# SD card
The Gearboy fork emulates EverDrive OS mapping, the cartridge button, SD access,
and RTC hardware. Select a host folder with EverDrive X SD Folder... (or set
`GEARBOY_SD_DIR`); its default is the home folder. SD writes update host files,
including file replacement during saving. `GEARBOY_SD_IMAGE=/path/card.img` selects
an existing FAT disk image instead.

# Compiling:
    make clean
    make all

`make assemble` builds without regenerating assets or running the emulator. Pick a language with `make assemble LANGUAGE=ES`.

# Cart
FatPak builds as a 128KB EverDrive GB X7 OS image, `bin/GBCOS.BIN`.
Install it as `/GBCSYS/GBCOS.BIN`, with `bin/EDITOR.DAT` alongside it. Builds
copy the OS image and data file automatically when `/media/qbertreynolds/GAMEBOY` is mounted.
The first 32KB is resident; the rest runs through the OS page window. C page
assignments are in `src/*/*.banks` and the layout is checked after linking.

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
