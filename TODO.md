# Rendering

- SGB resolutions: SETTINGS > RESOLUTION offers 160×144, 256×224 and 512×448 (FULL SCREEN toggles the bars separately). Not built: 512×224, and shared tiles in the 256×224 renderer ([roadmap](notes/SGB.md#resolution-roadmap)).
- Font selection: SETTINGS > FONT has STANDARD and 8X8 TILES (the mono font). Still to do: tile-mapped drawing for 8X8 TILES (GB renderer: font tiles in VRAM, no row bitmaps; SNES at 256×224: map entries, not rasters; it still draws bold/italic mono from the VWF's styled fonts); more fonts (Tiny5 Mono in `img/fonts/tiny5mono_font.png`), separately for text and code.
- 512×448 text (always the mono font) is built. Left: the text is blank after a map closes until the app redraws, Gearboy's half-size render skips the OSK, legibility on hardware ([SGB_HIRES_TEXT.md](notes/SGB_HIRES_TEXT.md)).
- Fix the accented characters in the font images: redraw the accented/UI glyphs in `vwf_font.png` (copied from `ui_font.png`) and hand-touch the derived styled fonts.
- DMG row draw spends ~18K cycles waiting on 40 HBlanks: interleave glyph drawing with the waits, or buffer tiles and stagger VRAM writes.
- Page up/down redraws every row (~0.9M cycles); page up also rescans 17 rows from PSRAM.
- Tabs draw as one space.
- Encodings: decode UTF-8 in text (é shows as two Latin-1 chars), plus CP437/CP1252.
- `tb_Load` scans up to 64 KB at boot when the gap is at the end (~0.9 s DMG); tighten the loop. Profile large gap moves.
- DMG smooth scroll (shelved): no spare block for the partial row. Blank-tile half-step idea pops visibly and SGB attributes are 8 px anyway.

# Text Editor

- Find and replace
- Closing a document shows its rows unstyled for a moment before the browser draws.
- A shared JSON reader/writer (a module, or a library modules link): THEME.MOD has its own (`modules/theme.c`: a forgiving reader over PSRAM, a writer to PSRAM blocks the host saves); project files, settings or map metadata could use the same.
- `ScrollX` ignores bold widths.
- Fixed-width code: bold keywords widen cells until a 4 px bold font exists; registers share keyword blue; the preprocessor colors only the directive; RGBDS string interpolation isn't lexed.
- Syntax definitions (`data/syntax`, `scripts/syntax.py`) are compiled on the PC: let the device read the text form (write a language in the editor); markers longer than 2 chars (Lua's `--[[`), nested comments, HTML/YAML-style rules; one file per extension (C.SYN and H.SYN are copies).
- First scan after an edit near the top of a big C file is slow (~0.5 frame/KB on GBC).
- Untested: SGB colors, code highlighting on DMG, italics on screen.
- SGB attribute colors (ATTR_CHR, 4 palettes, resent on scroll); theme the in-game menu; themes on the SNES in fullscreen beyond colours (its kernel's tables pick each style's class, bold and font: it needs program space first).
- Save As into another folder.
- Rebalance PSRAM between the 7,808-byte clipboard, 56 KiB undo log and piece table.
- Ctrl+End line count restarts from the file start; resume from the last known window.
- Unsaved edits are lost on reset: persist the piece table and add-buffer length in PSRAM; restore if size/date match.
- Window limits: moving clears undo, selection and Ctrl+A stop at the window; markdown fences/C comments open at the window start aren't seen; lines longer than the 8 KB margin with wrap off.
- 96 pieces max ("TOO MANY EDITS"); merge adjacent add-buffer pieces.
- Save is slow (~9 s for 320 KB in Gearboy) with no progress: skip busy polling like stock, use CMD25, avoid FatFs partial-sector copies.
- Window load via `tb_Append` (0.37 s): have the SD loop drop CRs and write the buffer directly.

# Game Launcher

- Loading bar in the launch box, drawn with the existing CPU-copy progress path between chunks.
- Cheat editing/toggles in the game UI (the text files already work).
- 8 MiB ROMs: snapshot staging at `$3c00` caps ROMs at 7.5 MiB; find another place to stage.
- In-game tools on the snapshot: memory dump to files; VRAM viewer (tiles, maps, OAM, palettes); BMP/stored-deflate PNG export; screenshot rebuilt from the snapshot (VBlank state only, so raster effects are wrong).

# File Browser

- sort by name (needs names in memory)
- file > create > folder, text, tileset, map
- Move FatFs helpers out of ROM0 behind far calls.
- delete should move files to trash unless deleting trash
- show hidden files and folders in settings

# Map Viewer

- SGB fullscreen: MAPVIEW is done at 256x224 and 512x448 (SETTINGS > RESOLUTION; the GB sends cells, the SNES draws them; untried on hardware). Each pass of the view waits for a page's ACK, so it moves a few pixels per page and the kernel glides between them: a SNES-side loader (below) would remove the round trip. The assembler's log doesn't update in SGB fullscreen while a map builds, so a long build looks frozen.
- 512x448 limits: 383 tile pairs (VRAM `$0000-$5FFF`, the map at `$6000`); past that an entry is blank. CGRAM palettes 1-7 hold 3 GB palettes each, given out as pairs need them. The bars, a box or the OSK hide the map across their rows (HDMA puts them in mode 1). Horizontal scroll moves 2 pixels at a time (mode 5). HDMA and the ICD2 capture's DMA together can crash the first 5A22 revision. Check flicker and the HDMA switch on hardware.
- Reuse the C map loader (`modules/mapview.c`'s chunk, object and stamp drawing) for the SNES version of Beisbol instead of a second port of `map_loader.asm`: pull it into a shared source that builds for sm83 here and for the SNES toolchain there.
- Zoom levels on every platform, built from the same composed-tile cache: 1/4 (each GB tile sampled to 4x4, 2x2 tiles per output tile), 1/16 (2x2 per tile, 4x4 tiles per output tile) and 1/64 (one pixel per tile, its most common colour; really a bitmap of the screen's tiles, not a cache). Precompute each source tile's reduced form once; one palette per output tile (GB) makes mixed-palette blocks lossy; the zoomed view walks the chunk neighbour graph, which isn't a grid everywhere.
- GBC: the bars over the map use its palette 0 (the map loads all 8 BG palettes), not the theme's.
- The prelude (`mapview.c`) mirrors `map_loader.inc` and `RGB`: keep it in step if the map format changes. The editor will need the game's charmap for signs' text (built without it, `\n` is 10).
- The cache key covers the map only: a changed `map_stamps.gbstamp` needs Start > Rebuild.
- The viewers' menu after Start runs the viewer again: on DMG the map is drawn again (no tiles for a box over it).

# Tile Viewer

- SGB fullscreen doesn't work (it sends raw rows).
- SETTINGS > FULL SCREEN doesn't hide its bars (its rows are fixed at 16).
- The viewers' menu after Start runs the viewer again, so the page is redrawn.

# Hex Viewer

- SETTINGS > FULL SCREEN doesn't hide its bars (its rows are fixed at 16).
- The viewers' menu after Start runs the viewer again, so the page is redrawn.

# Super Game Boy

- **Next:** SGB fullscreen input latency. Hardware (SGB.LOG, 2026-11-25): press to ACK went from 18 to 11 frames (Down, 256x224) and 26 to 12 (512x448) after the footer and row-staging fixes. Since then (Gearboy, 512x448, press to publish): Down 5 to 2, cursor 11 to 5, typing 13-21 to 7 with one page per key (row content hashes cached in PSRAM until written, no duplicate cursor page, no second Draw per key, the SGB log's flush waits for a second without input). Left: the first edit after opening moves the text gap (about 6 frames on a long file); per-row overhead on unchanged rows (about 1 frame); FsByte's wait on each VRAM byte. Not yet checked on hardware. The profiler must use `bin/SGB.DAT`: `client-test.SGB.DAT` has no text-mode extension, so 512x448 faults there. Phase 7 hardware checks ([SGB.md](notes/SGB.md)).
- `tests/run_geometry.sh` fails "runtime 64-character limit" (wraps at 62 characters with 1-pixel glyphs), also at 08d5602.
- SNES mouse on hardware (2026-11-24): smooth and responsive in fullscreen, but the double click's threshold is hard to meet; mouse speed (the 3 hardware speeds) isn't offered there yet. In 160x144 the mouse mode flickers a lot.
- Input devices on SGB: the SNES mouse should just work, not need choosing in SETTINGS > KEYBOARD, which reads as keyboard or mouse. Keyboard and mouse together is the plan (to test with the link port mod).
- Reset instead of a power cycle: from 256x224/512x448 the screen stays blank; from the OS at 160x144 the SGB's stock colours come back and input seems doubled.
- RESOLUTION 160x144 and game launch from fullscreen (EXIT): works on hardware on SGB1 1.0 (2026-11-24) and in Mesen on 1.0, 1.1, 1.2 and SGB2 ([notes](notes/SGB.md#returning-to-the-bios-exit-2026-11-20)). Mesen's EXIT test doesn't check the GB's picture after the return (its GB program never draws; the BIOS's GB palette comes back black until a PAL01).
- The SNES kernel image is full (about 70 of 49,152 bytes left): new kernel code goes to the extension or the resident part (`$7E:A000`, 561 of 4 KiB used).
- Kernel `Capture`'s pad sample can run twice per frame (once in VBlank, once early in the next); harmless for pads, mouse.s guards against it.
- The SGB border is off (`SGBSetDefaultBorder` is commented out in `src/app/main.c`; `tests/test_sgb.cpp`'s `SGB_BORDER` skips its checks). A new border could carry the header and footer's data: a big clock, the path.
- `tests/run_sgb_kernel.sh` sometimes fails its golden by 8 pixels: the screenshot shows page 100's cursor, not page 101's (hidden). The final CURSOR isn't always presented before the capture; seen twice on 2026-11-20, and it passes on a re-run. `tests/run_sgb_text_session.sh` also failed once (2026-11-21: 1200 pixels differ in the header/footer rows) and passed twice after.

# Peripherals

- Re-detect a PS/2 keyboard plugged in after boot.
- WorkBoy and iGKB gamepad support as additional drivers; keyboard and mouse drivers now use the selectable page-15 slot ([KEYBOARD.md](notes/KEYBOARD.md)).
- WorkBoy keyboard; Game Boy Printer output.
- Test PS/2 input on LSDJ.

# Other

- Something writes the top of HRAM (found 2026-11-20: a byte placed at `$FFF5` read 160 after a BUILD, and `tests/test_footer_clock.cpp` ran a stub at `$FFF0`). Find it before putting anything up there.

- C compiler ([COMPILER.md](notes/COMPILER.md#status-2026-11-21)): BUILD/RUN of a `.c` file, and C units in a `project.gbp` (listed, or a `_name.asm` an assembly unit INCLUDEs: beisbol's announcer builds on hardware, 2026-11-23). Builds crash intermittently on hardware (not in Gearboy): find the phase and error screen. Next: header changes recompiling a unit, copying only the runtime helpers a unit calls, configurable output location, messages instead of `C ERROR <n>` (the strings budget), `#`/`##`, designated initializers, struct arguments, register allocation for hot loops (measured: little gain in straight-line code).
- Document real differences of other X-series carts rather than assuming X7 SD/RTC/button behavior.
- Ports to other cartridges need a loader, SD access and a new memory layout; the PSRAM window is assumed everywhere.
