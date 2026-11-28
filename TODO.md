# Rendering

- SGB resolutions: 512×224, and shared tiles in the 256×224 renderer ([roadmap](notes/SGB.md#resolution-roadmap)).
- 8X8 TILES font: tile-mapped drawing (GB: font tiles in VRAM; SNES 256×224: map entries, not rasters). More fonts (Tiny5 Mono in `img/fonts/tiny5mono_font.png`), separately for text and code.
- 512×448 text: blank after a map closes until the app redraws; Gearboy's half-size render skips the OSK; check legibility on hardware ([SGB_HIRES_TEXT.md](notes/SGB_HIRES_TEXT.md)).
- Redraw the accented/UI glyphs in `vwf_font.png` and touch up the derived styled fonts.
- DMG row draw waits ~18K cycles on 40 HBlanks: interleave glyph drawing with the waits.
- Page up/down redraws every row (~0.9M cycles); page up also rescans 17 rows from PSRAM.
- Draw tabs as tabs, not one space.
- Encodings: UTF-8 in large documents, CP437/CP1252, and a way to see or change a file's encoding.
- `tb_Load` scans up to 64 KB at boot (~0.9 s on DMG): tighten the loop; profile large gap moves.

# Text Editor

- Find and replace.
- Save As into another folder.
- Closing a document briefly shows its rows unstyled.
- A shared JSON reader/writer for modules (THEME.MOD has its own).
- `ScrollX` ignores bold widths.
- Fixed-width code: bold keywords widen cells (needs a 4 px bold font); registers share keyword blue; the preprocessor colours only the directive; RGBDS string interpolation isn't lexed.
- Syntax definitions: read the text form on the device; markers over 2 chars (Lua's `--[[`), nested comments, HTML/YAML rules; one file per extension.
- First scan after an edit near the top of a big C file is slow (~0.5 frame/KB on GBC).
- Test code highlighting on DMG and italics on screen.
- SGB colours at 160x144: test on hardware; the bars' own palette; a map's palettes 4-7 and colour 0; the tile viewer's rows; theme the in-game menu; themes beyond colours in fullscreen (needs kernel space).
- Rebalance PSRAM between the clipboard, undo log and piece table.
- Ctrl+End restarts its line count from the file start.
- Keep unsaved edits across a reset (persist the piece table and add buffer).
- Large-file window limits: moving it clears undo; selection and Ctrl+A stop at its edge; comments/fences opened before it aren't seen; lines over 8 KB with wrap off.
- 96 pieces max ("TOO MANY EDITS"): merge adjacent add-buffer pieces.
- Save is slow (~9 s for 320 KB) with no progress: no busy polling, CMD25, no partial-sector copies.
- Window load via `tb_Append` (0.37 s): drop CRs in the SD loop and write the buffer directly.

# Game Launcher

- SD ERROR on SGB after loading finishes (DMG/GBC fine; worked 2026-11-24). Check whether it's now ERROR 2 (copy doesn't match the file) or still 1 (read or save/registry failure).
- Loading bar in the launch box.
- Cheat editing/toggles in the game UI.
- 8 MiB ROMs: snapshot staging at `$3c00` caps ROMs at 7.5 MiB.
- In-game tools: memory dump, VRAM viewer, BMP/PNG export, screenshots from the snapshot.

# File Browser

- Sort by name.
- File > Create > folder, text, tileset, map.
- Move FatFs helpers out of ROM0.
- Delete to trash (unless deleting from trash).

# Map Viewer

- SGB fullscreen: test on hardware (flicker, the HDMA switch); a SNES-side loader to remove the page round trip; the assembler's log doesn't update while a map builds.
- 512x448: more than 383 tile pairs; horizontal scroll moves 2 px; HDMA plus ICD2 DMA can crash the first 5A22 revision.
- Share `modules/mapview.c`'s loader with the SNES version of Beisbol.
- Zoom levels (1/4, 1/16, 1/64) from the composed-tile cache.
- GBC: the bars over the map use the map's palette 0, not the theme's.
- A changed `map_stamps.gbstamp` should invalidate the cache (now needs Start > Rebuild).
- Signs' text needs the game's charmap.
- The menu after Start reruns the viewer (DMG redraws the map).

# Tile Viewer

- SGB fullscreen doesn't work (it sends raw rows).
- FULL SCREEN doesn't hide its bars.
- The menu after Start redraws the page.

# Hex Viewer

- FULL SCREEN doesn't hide its bars.
- The menu after Start redraws the page.

# Super Game Boy

- Retest on hardware: left Shift and Shift + arrows; OSK/menu opening at 160x144; the mouse with NONE and iGKB; the pointer over 256x224 menus; the scroll bar at all resolutions (watch for torn lines at 160x144 and flicker in fullscreen); Shift + click; RUN from fullscreen; SGB colours at 160x144; dropped PS/2 keys with the mouse.
- Fullscreen input latency: try fewer `FsSettle` reads; speed up the snapshot compare and the page CRC read-back; the first edit on a long file moves the text gap (~6 frames). Profile with `bin/SGB.DAT`.
- Mouse: the double click is hard to hit (its timing is probably measured late; check SGB.LOG); offer mouse speed in fullscreen; flicker at 160x144.
- Theme looked wrong after 256x224 > 512x448 (not reproduced; suspect FsPalette giving up on a pending page).
- Reset instead of power cycle: blank screen from fullscreen; stock colours and doubled input from 160x144.
- SGB border is off: re-enable, or a new one showing the clock and path.
- `tests/run_geometry.sh` fails "runtime 64-character limit" (wraps at 62).
- Flaky: `run_sgb_kernel.sh` golden off by 8 px (cursor not presented before capture); `run_sgb_text_session.sh` failed once.

# Peripherals

- WorkBoy keyboard
- Game Boy Printer output.

# Other

- Find what writes the top of HRAM (a byte at `$FFF5` changed after a BUILD) before using it.
- C compiler ([COMPILER.md](notes/COMPILER.md#status-2026-11-21)): intermittent build crashes on hardware; header changes recompiling units; copy only the runtime helpers used; configurable output; error messages; `#`/`##`; designated initializers; struct arguments; register allocation.
- Document real differences between X-series carts.
- Ports to other cartridges (loader, SD access, memory layout).
