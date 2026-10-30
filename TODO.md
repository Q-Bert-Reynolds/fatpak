Priority (v1)

- text buffer + cursor (C), fixed width rendering (asm), scrolling
- PS/2 keyboard typing mode feeds the editor (arrows, enter, backspace, delete, home/end, page up/down)
- on-screen keyboard fallback, toggled with SELECT
- Everdrive X SD card: SPI driver (asm), FAT32 file system, file browser
- open/save .txt files
- emulate Everdrive SD card in Gearboy (RAM-backed SD stub until then)

Later

- multiple encodings (CP437, CP1252, UTF-8)
- variable width fonts (see untoxa/VWF)
- rich text, colors, highlights
- WorkBoy keyboard
- iGKB (also supports mouse and gamepad), needs Gearboy emulation first
- mouse on the Super Game Boy

Cleanup (left over from Béisbol)

- rename beisbol.inc
- map_loader.asm still has item/team/encounter routines, commented out calls marked with ;;
- src/world/scripts.asm map scripts are stubs, calls marked with ;;
- src/world/map_constants.asm only exists so map data links
- BoulderCityRockersTeam in world.asm is a stub for team data
- scale_tile_data_2x.asm isn't included anywhere, hardcoded to calvin_back_2x
- remove baseball/lineup palettes from color.asm
- options menu animation option still says "AT-BAT ANIMATIONS"
- img2rgbds.py has special cases for removed images (simulation, baseball_fx)
- C code is placed in ROMX with no banked calls, and _GSINIT (static initializers) never runs

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
- running out of room in ROM0, move stuff to other banks
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
