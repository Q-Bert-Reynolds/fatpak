Priority

- call tb_Normalize before saving/menus so the .sav reads as plain text
- test SD read/write on the X7
- remember the open file's name in SRAM (text survives power off, its name doesn't)
- test on the X7: does writing $A5 to $BD0A unlock the registers while SRAM is enabled? (the text buffer skips $BD00-$BD0F either way)
- faster sector reads with auto-read streaming ($BD01 bit 2 + $BD06 bit 0, reading $BD00 clocks the next byte)
- open/save .txt files

Editor

- variable width font: accented and UI glyphs in vwf_font.png are copied from ui_font.png, redraw them
- rendering: drawing a row waits for 40 HBlanks (~18K cycles), use HDMA on GBC, interleave glyph drawing with the waits on DMG
- page up/down redraw every row (~0.9M cycles), page up also scans back 17 rows from SRAM
- without an EverDrive, the first edit after a pause moves the gap back from the end (~35 cycles per byte after the cursor)
- loading a file is slow (20KB ~2.4s): CR removal in C, tb_Append computes an address per byte, FatFs cluster math uses the slow _mullong
- the on screen keyboard rows are redrawn on every scroll while it's open
- smooth (pixel) scrolling on GBC (DMG doesn't have tiles for a 19th row)
- remember the chosen font
- TBMoveGap does bank math per byte (~1s+ to move the gap across 24KB on DMG), copy in chunks
- tabs are drawn as a single space
- select text with the d-pad (A + d-pad?) and cut/copy/paste from the on screen keyboard or menu
- clipboard is limited to 7356 characters (SRAM bank 3), use WRAM banks 2-7 on GBC too?
- undo
- status bar: free space, remember full screen mode
- iGKB handlers don't send home/end/page/delete keys
- file browser: sort by name (needs the names in memory), make folders, delete and rename files
- save as into another folder
- show UTF-8 text (files are loaded as bytes, a UTF-8 é shows as two Latin-1 chars)
- messages swallow the key that dismisses them, maybe time out instead
- PS/2 keyboard is only detected at boot, re-detect when plugged in later
- on screen keyboard: hold A to repeat, a way to move the cursor up/down while it's open
- horizontal scrolling (no wrap) option
- multiple encodings (CP437, CP1252, UTF-8)
- rich text, colors, highlights
- WorkBoy keyboard
- iGKB (also supports mouse and gamepad), needs Gearboy emulation first
- mouse on the Super Game Boy
- use GB Printer to print text files
- _GSINIT (static initializers) never runs, C must initialize globals in code
- C in different files can't call each other unless they share a bank or use BANKED_C stubs (bank_split.py only splits a single file)

Optimization

- buffer tile data, stagger writes to vram
- utilize remaining HRAM space and RST vectors
- use halt and stop where appropriate (see https://gbdev.io/pandocs/Reducing_Power_Consumption.html)
- use HDMA transfers on GBC (see https://gbdev.io/pandocs/CGB_Registers.html#lcd-vram-dma-transfers)
- keep ROM0 for code called from several banks (~6KB left)
  - bank_split.py keeps FatFs helpers in ROM0, some could go in a bank behind far calls
  - f_lseek is unused but FF_FS_MINIMIZE can't remove it without removing directory functions
  - core.asm should not include core_strings.asm
  - helper routines that don't take any args should use TRAMPOLINE instead
- remove the last few manual ROMX assignments, let linker handle bank management instead