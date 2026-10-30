# TEXT EDITOR
A text editor for the Game Boy, Game Boy Color, and Super Game Boy, built on the Béisbol engine.

Planned for v1:
- display and edit ASCII text with a fixed width font
- PS/2 keyboard via the link port (same adapter LSDJ uses)
- toggleable on-screen keyboard
- read/write .txt files on the EverdriveGB X-series SD card

Later: more encodings, variable width fonts, rich text, WorkBoy keyboard, iGKB, Super Game Boy mouse.

# Controls
| Button | Action |
| --- | --- |
| D-pad | move cursor, or the on screen keyboard selection when it's open |
| A | type the selected key |
| B | backspace |
| START | new line |
| SELECT | show/hide the on screen keyboard |

On screen keyboard bottom row: shift (one shot), symbols, space, cursor left, cursor right.

PS/2 keyboards type directly: arrows, home, end, page up/down, backspace, delete, enter.

Text is kept in SRAM, so it's still there after turning the Game Boy off.

# Engine
- asm for core routines (drawing, input, math, memory, audio), C (SDCC) for higher level logic
- PS/2 and iGKB keyboard drivers (src/keyboard)
- gbt_player music (.mod) and FX Hammer sfx
- map loader for maps exported from gbmapeditor (.gbmap, .gbms, .gbstamp, .gbavatar)
- tile animations, fades, GBC palettes, SGB borders/palettes
- translated strings from CSV (en, es, fr, it, pt, de, ja)

# Font
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
- MAP_TEST_ENABLED

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
- gbt_player.asm - Antonio Niño Díaz
- sgb.asm - Imanol Barriuso, Martin Ahrnbom

# Thanks

- [Jeff Frohwein](https://devrs.com/gb/)
- [John Metcalf](http://www.retroprogramming.com)
- [Z80 Heaven](https://z80-heaven.wikidot.com/)
- [GameBoy Pandocs](https://gbdev.github.io/pandocs/):
- [GameBoy CPU Manual](http://marc.rawer.de/Gameboy/Docs/GBCPUman.pdf)
- [untoxa/VWF](https://github.com/untoxa/VWF)
- [RodrigoCard/TXTReaderGB](https://github.com/RodrigoCard/TXTReaderGB)
