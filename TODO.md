# Rendering

- SGB resolutions: shared tiles first, then Mode 5 probe and 160×144 / 256×224 / 512×224 / 512×448 selection; Fullscreen toggles bars independently ([roadmap](notes/SGB.md#resolution-roadmap)).
- Font selection: SETTINGS > FONT has STANDARD and 8X8 TILES (the mono font). Still to do: tile-mapped drawing for 8X8 TILES (GB renderer: font tiles in VRAM, no row bitmaps; SNES: map entries, not rasters), 512x448 text in it is built (RESOLUTION 512x448, whatever FONT says; left: the mouse at 56 rows, the text blank while a map is open, hardware legibility: [SGB_HIRES_TEXT.md](notes/SGB_HIRES_TEXT.md)), more fonts (Tiny5 Mono in `img/fonts/tiny5mono_font.png`), separately for text and code.
- Redraw the accented/UI glyphs in `vwf_font.png` (copied from `ui_font.png`) and hand-touch the derived styled fonts.
- DMG row draw spends ~18K cycles waiting on 40 HBlanks: interleave glyph drawing with the waits, or buffer tiles and stagger VRAM writes.
- Page up/down redraws every row (~0.9M cycles); page up also rescans 17 rows from PSRAM.
- Tabs draw as one space.
- Encodings: decode UTF-8 in text (é shows as two Latin-1 chars), plus CP437/CP1252.
- `tb_Load` scans up to 64 KB at boot when the gap is at the end (~0.9 s DMG); tighten the loop. Profile large gap moves.
- DMG smooth scroll (shelved): no spare block for the partial row. Blank-tile half-step idea pops visibly and SGB attributes are 8 px anyway.

# Text Editor

- Find and replace
- `ScrollX` ignores bold widths.
- Fixed-width code: bold keywords widen cells until a 4 px bold font exists; registers share keyword blue; the preprocessor colors only the directive; RGBDS `/* */` and string interpolation aren't lexed.
- First scan after an edit near the top of a big C file is slow (~0.5 frame/KB on GBC).
- Untested: SGB colors, code highlighting on DMG, italics on screen.
- SGB attribute colors (ATTR_CHR, 4 palettes, resent on scroll); user-selectable UI/syntax colors in THEME.MOD (dark mode exists); theme the in-game menu.
- Save As into another folder.
- Rebalance PSRAM between the 7,936-byte clipboard, 56 KiB undo log and piece table.
- Ctrl+End line count restarts from the file start; resume from the last known window.

# Game Launcher

- Loading bar in the launch box, drawn with the existing CPU-copy progress path between chunks.
- Cheat editing/toggles in the game UI (the text files already work).
- In-game tools on the snapshot: memory dump to files; VRAM viewer (tiles, maps, OAM, palettes); BMP/stored-deflate PNG export; screenshot rebuilt from the snapshot (VBlank state only, so raster effects are wrong).

# File Browser

- sort by name (needs names in memory), new folder, delete.
- Move FatFs helpers out of ROM0 behind far calls.
- 8 MiB ROMs: snapshot staging at `$3c00` caps ROMs at 7.5 MiB; find another place to stage.
- Unsaved edits are lost on reset: persist the piece table and add-buffer length in PSRAM; restore if size/date match.
- Window limits: moving clears undo, selection and Ctrl+A stop at the window; markdown fences/C comments open at the window start aren't seen; lines longer than the 8 KB margin with wrap off.
- 96 pieces max ("TOO MANY EDITS"); merge adjacent add-buffer pieces.
- Save is slow (~9 s for 320 KB in Gearboy) with no progress: skip busy polling like stock, use CMD25, avoid FatFs partial-sector copies.
- Window load via `tb_Append` (0.37 s): have the SD loop drop CRs and write the buffer directly.
- delete should move files to trash unless deleting trash
- show hidden files and folders in settings

# Map Viewer (MAPVIEW.MOD)

- SGB fullscreen: MAPVIEW is done at 256x224 and 512x448 (SETTINGS > RESOLUTION; the GB sends cells, the SNES draws them; untried on hardware). TILEVIEW still doesn't work there (raw rows). Each pass of the view waits for a page's ACK, so it moves a few pixels per page and the kernel glides between them: a SNES-side loader (below) would remove the round trip. The assembler's log doesn't update in SGB fullscreen while a map builds, so a long build looks frozen.
- 512x448 limits: 383 tile pairs (VRAM `$0000-$5FFF`, the map at `$6000`); past that an entry is blank. CGRAM palettes 1-7 hold 3 GB palettes each, given out as pairs need them. The bars, a box or the OSK hide the map across their rows (HDMA puts them in mode 1). Horizontal scroll moves 2 pixels at a time (mode 5). HDMA and the ICD2 capture's DMA together can crash the first 5A22 revision. Check flicker and the HDMA switch on hardware.
- Reuse the C map loader (`modules/mapview.c`'s chunk, object and stamp drawing) for the SNES version of Beisbol instead of a second port of `map_loader.asm`: pull it into a shared source that builds for sm83 here and for the SNES toolchain there.
- Zoom levels on every platform, built from the same composed-tile cache: 1/4 (each GB tile sampled to 4x4, 2x2 tiles per output tile), 1/16 (2x2 per tile, 4x4 tiles per output tile) and 1/64 (one pixel per tile, its most common colour; really a bitmap of the screen's tiles, not a cache). Precompute each source tile's reduced form once; one palette per output tile (GB) makes mixed-palette blocks lossy; the zoomed view walks the chunk neighbour graph, which isn't a grid everywhere.
- GBC: the bars over the map use its palette 0 (the map loads all 8 BG palettes), not the theme's.
- The prelude (`mapview.c`) mirrors `map_loader.inc` and `RGB`: keep it in step if the map format changes. The editor will need the game's charmap for signs' text (built without it, `\n` is 10).
- The cache key covers the map only: a changed `map_stamps.gbstamp` needs Start > Rebuild.

# Browser

- SETTINGS > FULL SCREEN hides the editor's bars and the map viewer's, not the browser's (its path and hints are there) nor HEXVIEW's and TILEVIEW's (their rows are fixed at 16).
- RESOLUTION 160x144 and game launch from fullscreen (EXIT, 2026-11-20): confirm on hardware; other BIOS revisions (SGB2, SGB1 1.0/1.1) need their checksum, registers, sample stream and RTS in snes/bios.s ([notes](notes/SGB.md#returning-to-the-bios-exit-2026-11-20)).
- The SNES kernel image is full (49,142/49,152 bytes): new kernel code goes to the extension.
- The viewers' menu after Start runs the viewer again: HEXVIEW/TILEVIEW redraw their page, DMG's map is drawn again (no tiles for a box over it).

- Escape is START now, so a keyboard has no way back from the browser to the open document without opening a file (B at the root stays): a menu item for it.

# Peripherals

- Re-detect a PS/2 keyboard plugged in after boot.
- WorkBoy and iGKB gamepad support as additional drivers; keyboard and mouse drivers now use the selectable page-15 slot ([KEYBOARD.md](notes/KEYBOARD.md)).
- WorkBoy keyboard; Game Boy Printer output.
- Test PS/2 input on LSDJ.

# Other

- Something writes the top of HRAM (found 2026-11-20: a byte placed at `$FFF5` read 160 after a BUILD, and `tests/test_footer_clock.cpp` ran a stub at `$FFF0`). Find it before putting anything up there.
- `tests/run_sgb_kernel.sh` sometimes fails its golden by 8 pixels: the screenshot shows page 100's cursor, not page 101's (hidden). The final CURSOR isn't always presented before the capture; seen twice on 2026-11-20, and it passes on a re-run.

- Small-C style compiler matching SDCC's calling convention, multi-pass via SD temp files
- Document real differences of other X-series carts rather than assuming X7 SD/RTC/button behavior.
- Ports to other cartridges need a loader, SD access and a new memory layout; the PSRAM window is assumed everywhere.
- `tests/run_sgb.sh`'s Startup fails ("startup completes border transfers"): BIOS-mode startup never reaches `sgb_SwapDisplay`, it waits in `gbdk_WaitVBL`. Found 2026-11-19; it fails the same with that day's earlier OS and Gearboy builds, so it predates the SGB map view.
- SGB fullscreen: improve input/render latency; finish fullscreen mouse controls and Phase 7 hardware checks ([SGB.md](notes/SGB.md)).
- fix accented characters in font images