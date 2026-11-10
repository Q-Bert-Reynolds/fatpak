# Priority

- Add a loading bar over the browser using the hardware-confirmed CPU-copy progress path. Update it between transfer chunks without HDMA or OAM DMA.
- Clock setting is hardware-confirmed. Verify RTC time across power-off separately from Crystal's ROM-loading failure.
- Save states have been tested successfully on hardware. Remaining compatibility checks: switching between FatPak and stock OS, interrupted file operations, and 128 KiB battery saves. Cheat testing is deferred. See [cart-menu validation](IN_GAME_MENU.md#validation).
- Exercise full/read-only SD cards and interrupted state replacement on hardware. Failed state loads must still allow Resume, and backups must keep the correct game's ownership.
- Plan code space before adding more services: most OS pages are close to their `$1d00` limit. Consider moving data, splitting helpers or the overlay approach below.
- ROM launch currently reserves snapshot-load staging above `$3c00`, limiting ROMs to 7.5 MiB. Supporting a full 8 MiB ROM needs a different staging allocation. Stock state files remain limited to 32 KiB of cartridge RAM; normal battery saves support 128 KiB.

# Text Rendering

- font selection: pick from a list of fonts (variable width, 4 pixel fixed, Tiny5 Mono in img/fonts/tiny5mono_font.png, ...) for text and for code (now code and markdown's code are fixed width, the rest variable width), saved with the settings
- variable width font: accented and UI glyphs in vwf_font.png are copied from ui_font.png, redraw them
- drawing a row on DMG transfers 320 tile bytes over 40 HBlanks (~18K cycles), interleave glyph drawing with the waits (GBC uses HDMA)
- buffer tile data, stagger writes to vram
- page up/down redraw every row (~0.9M cycles), page up also scans back 17 rows from PSRAM
- smooth scrolling on DMG (GBC has it): DMG has no block for the 17th (or 19th) row a pixel scroll shows. Idea: point the incoming row's map row at a blank tile (248-255 are free in both modes), scroll 4px, blank the outgoing row to free its block, draw the incoming row into it, scroll the last 4px. Shelved: the row draw stalls the scroll halfway (~1 frame), the halves pop in and out, and SGB color attributes are on the 8px grid so colored text couldn't move by pixels anyway
- tabs are drawn as a single space
- show UTF-8 text (files are loaded as bytes, a UTF-8 é shows as two Latin-1 chars)
- multiple encodings (CP437, CP1252, UTF-8)
- text buffer:
  - profile large gap moves in the current PSRAM layout; TBMoveGap already copies bounded chunks through win_buffer
  - tb_Load scans up to 65,024 bytes at boot when the gap is at the end (~0.9s on DMG, estimated), the scan loop could be tighter

# Syntax Highlighting

- hand edits to the styled fonts (img/fonts/*_font.png, fonts.py derive drew them)
- ScrollX (no wrap) doesn't count bold widths
- untested: SGB (same encoding as GBC without accents), code highlighting on DMG, italic on screen
- code: bold keywords widen the fixed font's cells (columns don't line up after them, until the fixed bold font is redrawn 4 pixels wide), registers share the keyword blue, the C preprocessor only colors the directive, RGBDS /* */ comments and string interpolation aren't lexed, a long first scan after an edit near the top of a big C file (~0.5 frame per KB on GBC)
- later: SGB colors (ATTR_CHR, 4 palettes, 8px cells, resent on scroll), UI and syntax colors in the settings (with an inverted theme)

# UI/UX

D-pad selection (A + D-pad), menu cut/copy/paste, and on-screen undo/redo are implemented.

- translate hard-coded editor, clock and cart-menu labels through the string pipeline; LANGUAGE currently selects the generated engine string includes
- expose per-game cheat editing/toggles in the game UI; stock cheat files already load and can be edited as text

- bigger clipboard: currently 7,936 bytes in PSRAM blocks `$01f0-$01ff`; the 56 KiB undo log occupies `$0180-$01ef`. Rebalance these allocations if the clipboard or piece table needs more space
- undo: keep the history when the power is off, select the restored text after undoing a cut or delete
- status bar: free space
- on screen keyboard: hold A to repeat, a way to move the cursor up/down while it's open
- mouse on the Super Game Boy
- on SGB always use the full GB area for text, use SGB border for header/footer info (and on-screen keyboard?)
- SGB's fullscreen mode should leverage the full power of the SNES for text rendering (like Space Invaders does)

# File I/O

Calendar-based file timestamps and SETTINGS > CLOCK are implemented, with a fixed-date fallback when no valid clock is available.

- file browser: sort by name (needs the names in memory), make folders and delete files. Start now offers info, rename, cut/copy/paste for files and folders, settings, help and restart; verify transfers and interrupted copies on hardware.
- save as into another folder
- bank_split.py keeps FatFs helpers in ROM0, some could go in a bank behind far calls

# Large Files

The OS build already supports large files. Previous Gearboy measurements: files of any size open in ~0.9s (Gearboy) and can be
edited and saved. The file stays open and the text buffer is a 48KB window (WIN_SIZE) of the document, a list
of pieces of the file and of the add buffer (PSRAM from ADD_BLOCK, `ADD_MAX = $7a0000` bytes, text without CRs); see
[`src/fatfs/fatfs.c`](../src/fatfs/fatfs.c). The window slides when the cursor is within 8KB of an edge that isn't
the document's (Slide in editor/window.c), starting at a line start; an edited window is committed first (its text
replaces the pieces it came from). Line numbers are counted across slides; Ctrl+End shows "Line ?" until the
line feeds before the window are counted in the background (fs_ScanStep). Saving writes ~EDITOR.TMP in the
file's folder (added text gets CR LF if the file had them), deletes the file and renames the temp file
(FF_FS_MINIMIZE 0), then reopens it as one piece. While a large file is open the text buffer's signature is
cleared and the swap file isn't written, so a reset restores the swap file instead of a window that could be
saved over the file. Variables are in ROM0 (RAM in OS mode, WRAM0 is full), the piece table in page 14.
Next:
- unsaved edits to a large file are lost on a reset or power off (the piece table is in page 14, the image is
  reloaded at boot): keep the piece table and add buffer length in PSRAM and restore them at boot if the file's
  size and date still match
- the undo history is cleared when the window moves, a selection stops at the window, Ctrl+A selects the window
- the piece table holds MAX_PIECES (96), each commit adds up to 2: then "TOO MANY EDITS, SAVE FIRST" (adjacent
  add buffer pieces could merge)
- save speed: ~9s for 320KB in Gearboy (sector writes 1.7s, FatFs's partial sector copies 2s, FatFs call
  overhead). The EverDrive's OS writes sector bytes without polling the busy bit (~0.8s less), multi-block
  CMD25/CMD18 would cut command overhead. A save shows "Saving..." without progress
- the window load is tb_Append (0.37s, the SD read loop could drop CRs and write into the text buffer itself)
- the line count after Ctrl+End starts from the file's start, it could start from the last known window
- a markdown code block or C comment open at the window's start isn't seen (the lexer starts fresh there)
- lines longer than the window's margin (8KB) with line wrap off

# Peripherals

- PS/2 keyboard is only detected at boot, re-detect when plugged in later (HELP > KEYBOARD TEST starts listening for one)
- iGKB (also supports mouse and gamepad), needs Gearboy emulation first. Its home/end/page/delete handlers are written but untested
- WorkBoy keyboard
- use GB Printer to print text files

# Emulator

- Test PS/2 input on the LSDJ rom
- iGKB emulation (see Peripherals)

# OS Utilities

The `$0670` entry, full game-memory capture, SD services while suspended, Resume,
and warm return are implemented. Utilities can build on that snapshot; the
viewers/exporters and overlay loader below remain future work. Existing `.gb`
and `.gbc` launch already covers ROMs built by a future on-device assembler.

- overlays: utilities load their code from a file on the card into a page at $A000 when they're used (pages are RAM in OS mode). The page's own code is copied to PSRAM first and copied back after, so no page has to be given up. Built as a separate link at the page's address, calling the editor through a jump table in ROM0
- in-game tool overlays using the existing PSRAM snapshot:
  - dump the game's memory to files (write-only registers can't be read, raw mapper latches are already captured)
  - a VRAM viewer: tile sheets (384 per bank), BG and window maps, OAM list, palettes
  - images from it: BMP, or indexed PNG with stored (uncompressed) deflate blocks (only CRC32 and Adler-32 needed)
  - a screenshot rebuilt from the snapshot (BG, window, sprites with the 10 per line limit, flips, priority, GBC attributes), as it stands at VBlank: per line scroll, LYC status bars and per line palettes come out wrong
- PNG viewer (an overlay): inflate (a 32KB window in PSRAM, ~2-3KB of asm) and the row filters decode 8-bit grayscale, RGB, RGBA and palette images (not Adam7 or 16-bit at first) into PSRAM; fit, 1:1, 2x and 4x zoom panned with the d-pad, drawn into the renderer's 360 tiles (averaged when shrinking); 4 shades with ordered dithering on DMG, grayscale then colour on GBC (8 palettes of 4 colours, picked per tile). Guess: a few seconds to decode a 100-300KB PNG
- assemble and run on device: a two pass assembler for an RGBDS subset (instructions, global and .local labels, DB/DW/DS, DEF/EQU, INCLUDE, later MACRO/REPT/IF) that reuses TBLexCode and the keyword tables (entries would also need opcode patterns, register numbers, directive ids), symbols in a hash table in SRAM, output into SRAM or GBC WRAM 1-7 and run from there. Before running, swap the SRAM a program needs (the undo log in PSRAM blocks `$0180-$01ef`, or the editor workspace including text) to a file on SD and restore it after, with a flag so boot restores it if the program crashes or the power goes off. Rough guess: a few hundred lines a second per pass
- call the editor's routines by name (gbdk_SetBkgTiles, RevealTextAndWait, ...): build an export table (name, bank, address) from bin/GBCOS.sym into a fixed size section in its own bank so it doesn't move the code it describes, the assembler resolves unknown symbols against it, banked targets go through a far call trampoline. C functions follow SDCC's convention (a, e, return in a), asm routines need their register args documented
- a small API for user programs: jump table in ROM0 (print, keys, files, exit), the program returns to the editor, the text is safe in SRAM if it crashes
- build whole ROMs to the SD card: ORG/BANK placement (no linker), or SECTIONs + an rgblink-like linker later, header checksums like rgbfix. Python generated assets would have to be committed as .asm/.bin. The generated assembly and symbol table are large; measure current source/symbol counts before estimating RAM or assembly time
- programs as loadable modules: gbt_player (removed in 132083e) and the map loader (removed in 8c7c9ef) could come back as modules a program loads and calls by name
- compile on device: SDCC can't host itself (C++, megabytes of heap). A Small-C style compiler (one pass, emits asm for the assembler, self hosting) built with SDCC on the PC first, passes as separate programs with temp files on SD like HI-TECH C on CP/M, matching SDCC's calling convention so it can call the engine. Forth is the cheaper interactive option
- suggested order: in-memory assembler + API, measure SD speed, ROM builder using the existing launch path, compiler

# Platforms

The EverDrive GB X7 OS image is the only application build. Current fallbacks:
missing `/GBCSYS/EDITOR.DAT` disables styled glyphs and the SGB border; an absent
or invalid RTC uses fixed file timestamps and cannot advance game time offline.

- test the editor and cart-menu display on SGB hardware, including transitions through a launched game
- document any tested X-series hardware differences instead of assuming non-X7 SD/RTC/button capabilities
- future ports to other cartridges need a loader, SD/access strategy and memory layout; PSRAM window access is assumed throughout the current build
- future on-device programs need a way to reserve or swap the editor's memory before running
