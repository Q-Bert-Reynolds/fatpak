Priority

- call tb_Normalize before saving/menus so the .sav reads as plain text
- test SD read/write on the X7
- test on the X7: does writing $A5 to $BD0A unlock the registers while SRAM is enabled? (the text buffer skips $BD00-$BD0F either way)
- time loading and saving a 64KB file on the X7 and in Gearboy, the numbers set the large file window size (see File I/O)
- faster sector reads with auto-read streaming ($BD01 bit 2 + $BD06 bit 0, reading $BD00 clocks the next byte), and without checking the busy bit for each byte if the X7's SPI is fast enough at double speed
- large files (bigger than the 65,408 byte text buffer), see File I/O

Text Rendering

- font selection: pick from a list of fonts (variable width, 4 pixel fixed, Tiny5 Mono in img/fonts/tiny5mono_font.png, ...) instead of the Ctrl+F toggle, saved with the settings
- variable width font: accented and UI glyphs in vwf_font.png are copied from ui_font.png, redraw them
- drawing a row on DMG waits for 40 HBlanks (~18K cycles), interleave glyph drawing with the waits (GBC uses HDMA)
- buffer tile data, stagger writes to vram
- page up/down redraw every row (~0.9M cycles), page up also scans back 17 rows from SRAM
- smooth scrolling on DMG (GBC has it): DMG has no block for the 17th (or 19th) row a pixel scroll shows. Idea: point the incoming row's map row at a blank tile (248-255 are free in both modes), scroll 4px, blank the outgoing row to free its block, draw the incoming row into it, scroll the last 4px. Shelved: the row draw stalls the scroll halfway (~1 frame), the halves pop in and out, and SGB color attributes are on the 8px grid so colored text couldn't move by pixels anyway
- tabs are drawn as a single space
- show UTF-8 text (files are loaded as bytes, a UTF-8 é shows as two Latin-1 chars)
- multiple encodings (CP437, CP1252, UTF-8)
- syntax highlighting (markdown styles and code styles on every model, colors on GBC):
  - a lexer in TBScanRow writes a style byte per drawn char (ink, bold, italic) into attribute rows next to tile_buffer, so wrapping, RenderCursorX, PosAtX and ScrollX use styled widths, and skipped chars (no wrap) still update its state
  - the row cache compares attributes too. Memory: the editor only uses win_buffer 256 bytes at a time, shrink it and use the rest
  - state that crosses lines (C /* */, markdown ``` fences) is saved at each rendered row start, and at 1KB checkpoints for jumps and scrolling up, cleared from an edit's position on
  - file type from the extension (.md, .c/.h, .asm/.inc), plain otherwise, kept with the settings
  - markdown markers (#, **, _, `) stay visible, dimmed
  - done: lexer and styled widths (TBLex, tile_attrs), file type (.md), headings 1-4 as stretched fonts, H5/H6 bold, **bold**, *italic*/_italic_
  - left from phase 1/2: `code` has no look yet (phase 3 inks), ``` fences and the 1KB checkpoints (TBSyncState scans from the line's start, a long paragraph is rescanned on each full render), hand drawn heading fonts if the stretched ones don't hold up, ScrollX estimates widths (heading widths, bold not counted)
  - phase 3, inks: a second bitmap per row marks dim pixels (bitplane 0 cleared). DMG/SGB: dark grey for comments and markers. GBC: a second bitplane in cmd_buffer's free page gives 3 inks (default, dim, accent) plus a palette per tile (written with the row and when a block moves to another map row). Selected tiles use a selection palette, the two partly selected tiles of a row fall back to today's 4 color scheme
  - phase 4, C and asm lexers: comments, strings, numbers, preprocessor/directives, labels, keywords/instructions/registers from tables a python script generates into a ROMX bank (looked up when an identifier ends). Keywords are bold on every model, comments dark grey on DMG/SGB, tokens colored on GBC
  - GBC theme for now: white paper, near black text, grey-green comments and markers, blue keywords/instructions, dark red strings/chars, purple numbers, brown-orange preprocessor/directives/labels
  - later: SGB colors (ATTR_CHR, 4 palettes, 8px cells, resent on scroll), UI and syntax colors in the settings (with an inverted theme)
- text buffer:
  - TBMoveGap does bank math per byte (~1s+ per 24KB on DMG, the buffer is 64KB now), copy in chunks
  - without an EverDrive, the first edit after a pause moves the gap back from the end (~35 cycles per byte after the cursor)
  - tb_Load scans the whole 64KB at boot when the gap is at the end (~0.9s on DMG, estimated), the scan loop could be tighter
  - TBPhysAddr finds the bank by subtracting once per bank (up to 8 times)

UI/UX

- select text with the d-pad (A + d-pad?) and cut/copy/paste from the on screen keyboard or menu
- clipboard is limited to 7356 characters (SRAM bank 8), banks 9-15 hold the undo log now (UNDO_BANKS can shrink if the clipboard or the large file piece table need some)
- undo: keep the history when the power is off, select the restored text after undoing a cut or delete
- status bar: free space
- messages swallow the key that dismisses them, maybe time out instead
- on screen keyboard: hold A to repeat, a way to move the cursor up/down while it's open
- mouse on the Super Game Boy
- on SGB always use the full GB area for text, use SGB border for header/footer info (and on-screen keyboard?)
- SGB's fullscreen mode should leverage the full power of the SNES for text rendering (like Space Invaders does)

File I/O

- large files: an SRAM window over a piece table on the SD card
  - the document is a list of pieces (source, offset, length), the source is the original file (read only) or an append only scratch file on the card (/.texted.swp)
  - the gap buffer becomes a window into the document, edits only happen there. Near its edge the window is committed (appended to the scratch file if it was edited) and a new one is loaded around the cursor
  - positions stay 16 bit, relative to the window, with a 32 bit window_base. A slide rebases cursor, top, anchor and counted_pos
  - save streams the pieces to name.tmp, then f_unlink the original and f_rename the temp file (needs FF_FS_MINIMIZE 0). Save as skips the rename
  - long lines: windows start at a line start (scanning back up to a cap), longer lines wrap or cut at the window edge
  - line numbers: a sparse index of the original file (line feeds per 4KB block) built in the background when idle, "?" until it's done. Also gives Ctrl+G and a fast Ctrl+End
  - CR LF and dropped 0s mean window positions aren't file offsets: commit the whole window when it's edited at first, later map unchanged runs back to the original (offset = chars + LFs for consistent CR LF files)
  - a selection can't go past the window (it doesn't slide while selecting), deleting a range bigger than the window can be a piece table operation later
  - save shows a percentage, a 1MB save could take tens of seconds
  - the card has to stay in while a big file is open, refuse to write to a swapped card
  - files that fit in the window keep today's path (one piece, no scratch file, no temp file)
  - phases: measure speeds (Priority), read only large files with a sliding window, editable piece table + scratch file, background line index, optimizations (dirty range commits, save progress, merging pieces, a bigger window), crash recovery (rebuild from the piece table in SRAM + the scratch file at boot if the original's size and date still match)
- file browser: sort by name (needs the names in memory), make folders, delete and rename files (FF_FS_MINIMIZE 0, also needed for large files)
- save as into another folder
- FatFs cluster math uses the slow _mullong (once per sector read or written)
- bank_split.py keeps FatFs helpers in ROM0, some could go in a bank behind far calls
- f_lseek is unused but FF_FS_MINIMIZE can't remove it without removing directory functions (large files will use it)

Peripherals

- PS/2 keyboard is only detected at boot, re-detect when plugged in later
- iGKB handlers don't send home/end/page/delete keys
- iGKB (also supports mouse and gamepad), needs Gearboy emulation first
- WorkBoy keyboard
- use GB Printer to print text files

Emulator

- Test PS/2 input on the LSDJ rom
- Test Everdrive emulation on GBSYS/GBOS.BIN (the Everdrive rom)
- VirtualFat (Gearboy fork) only writes a file back to the host when its first cluster or size changes, so saving over a file with the same size never reaches the host folder (test with SAVE AS to a new name until it's fixed)
- iGKB emulation (see Peripherals)

Code

- keep ROM0 for code called from several banks (~6KB left)
  - core.asm should not include core_strings.asm
  - helper routines that don't take any args should use TRAMPOLINE instead
- utilize remaining HRAM space and RST vectors
- remove the last few manual ROMX assignments, let linker handle bank management instead
- _GSINIT (static initializers) never runs, C must initialize globals in code
- C in different files can't call each other unless they share a bank or use BANKED_C stubs (bank_split.py only splits a single file)
