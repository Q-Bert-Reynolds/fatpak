Priority (v1)

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
- function keys, ctrl shortcuts
- select text (shift + arrows / A + d-pad), delete, cut, copy, paste
- status line (file name, modified, free space)
- iGKB handlers don't send home/end/page/delete keys
- file browser: subfolders, more than 16 files, long file names (FF_USE_LFN)
- messages swallow the key that dismisses them, maybe time out instead
- PS/2 keyboard is only detected at boot, re-detect when plugged in later
- on screen keyboard: hold A to repeat, a way to move the cursor up/down while it's open

Later

- horizontal scrolling (no wrap) option
- multiple encodings (CP437, CP1252, UTF-8)
- rich text, colors, highlights
- WorkBoy keyboard
- iGKB (also supports mouse and gamepad), needs Gearboy emulation first
- mouse on the Super Game Boy

Cleanup (left over from Béisbol)

- map_loader.asm still has item/team/encounter routines, commented out calls marked with ;;
- src/world/scripts.asm map scripts are stubs, calls marked with ;;
- src/world/map_constants.asm only exists so map data links
- _GSINIT (static initializers) never runs, C must initialize globals in code
- C in different files can't call each other unless they share a bank or use BANKED_C stubs (bank_split.py only splits a single file)

Optimization

- buffer tile data, stagger writes to vram
- reduce stack thrashing in favor of repeated loading from WRAM 
- if all sprite stamps are 2x2, remove data from export and simplify stamp drawing
- COPY_TILE_BLOCK macro in GBDK.asm should be a subroutine, add HRAM vars to allow for this
- utilize remaining HRAM space and RST vectors
- replace long chains of compares and jumps with jump tables
- remove temp_bank
- 16 and 24 bit math and string functions are probably unnecessary, ditch in favor of 32 bit functions
- SetSpriteTiles, SetSpriteTilesProps, and SetSpriteTilesXY can likely be merged
- palette ids are at most 7, so two palettes could fit in a byte, cutting palette data in half
- use halt and stop where appropriate (see https://gbdev.io/pandocs/Reducing_Power_Consumption.html)
- use HDMA transfers on GBC (see https://gbdev.io/pandocs/CGB_Registers.html#lcd-vram-dma-transfers)
- running out of room in ROM0 (~1KB left), move stuff to other banks
  - bank_split.py keeps FatFs helpers in ROM0, some could go in a bank behind far calls
  - f_lseek is unused but FF_FS_MINIMIZE can't remove it without removing directory functions
  - move map_stamps out of ROM0
  - move color palettes out of ROM0
  - core.asm should not include core_strings.asm
  - move collision response code (doors, items, etc.) from map_loader to world
  - helper routines that don't take any args should use TRAMPOLINE instead
- remove the last few manual ROMX assignments, let linker handle bank management instead
- profiler to map out most called addresses 

Python scripts

- support these languages: en, es, fr, it, pt, de, jp
- SGB borders should (optionally?) use PNG palettes directly
- handle 1bpp and rle images

Map System

- maps.py should maintain map order to avoid corrupting save data
- regions should have their own music, palettes, tiles, etc
- map scripts should optionally have collision check
- sanitize maps before export (ie. objects with text should always have a collider and be on the text layer)
  - add export warnings when neighbor chains are inconsistent (ie. north->west != west->north, this != south->east->north->west)
  - empty chunks should be generated for missing neighbors
- handle temporary bg tiles (ie. trees that can be cut down)
- use Unity's collision trigger property for finer control over GB collisions
- chunks should be exported as tile arrays when more efficient than objects
- make legs go behind things
- map stamps should be referenced from an index to a jump table instead of directly addressed
- default collision type for chunk
- add diagonal lines to map system, (already implemented(ish) in editor)
- make the editor a standalone application

Audio

- utilize panning from fxhammer files
- shrink sfx format
  - combine channel and ticks (CCTTTTTT)
  - only include sweep byte in ch1 data
- test hUGEDriver (too big to fit in ROM0 currently)

Animation

- handle looped vs once animations
- shuffle sprite_obj_buffer so its size can be increased (will add flicker)

Super GameBoy

- replace all uses of GBCSetPalette with SetPalettesIndirect
- build sgb attribute files with palette data
- construct sgb packet headers at runtime instead of taking up space in ROM0 using macros
- sound test doesn't seem to work, test on hardware
- set tiles to palette 0 when drawing UI boxes (currently only works on GBC)
- extra music voices
- use second controller

Serial Port

- add assembly flag for keyboard support instead of supporting both IGKB and PS/2 at the same time
- use GB Printer to print text files
- USB keyboard sometimes freezes title screen
- PS/2 keyboard causes flickering on LCDC interrupts
- shortcut keys (ie. CTRL+S to save, CTRL+O to open, F1 for help)
