# Priority

- Assembler: beisbolgb on the device ([ASSEMBLER.md](notes/ASSEMBLER.md#beisbolgb)): its 50 units build in 24.1 min CGB in Gearboy, and again in 2.4 s with nothing changed (up to date). Hardware (GBA SP): 25 min, 2 min unchanged before the up-to-date check.
  - An edited unit builds in 2:07 (assembling 1:00: `build.obj`'s load, the prelude, its passes; linking 1:07). `Restore`/`Compose` move ~940 KB through a 128-byte buffer: whole block runs; a prelude snapshot in `build.obj`.
  - Build outputs (`build.cache`, `build.log`, `build.obj`) into a folder named in `project.gbp`.
  - Small builds pay ~300 DMG frames for PREP.MOD and LINK.MOD's loads: a cached backup compare (MODULES.md) would help every module.
  - ASM.MOD has ~190 bytes free (page 13 ~20, 12 ~25, 5 ~15, 4 ~35, 15 ~90); the OS's page 6 51, page 7 11, page 13 63, page 15 ~65, bank 1 36.
  - The symbol table's 256 hash chains (`Find` is assembly now; the chains are as long as before).

# Rendering

- Font selection (VWF, 4 px fixed, Tiny5 Mono in `img/fonts/tiny5mono_font.png`, ...) separately for text and code, saved in settings.
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

# Peripherals

- Re-detect a PS/2 keyboard plugged in after boot.
- WorkBoy and iGKB gamepad support as additional drivers; keyboard and mouse drivers now use the selectable page-15 slot ([KEYBOARD.md](notes/KEYBOARD.md)).
- WorkBoy keyboard; Game Boy Printer output.
- Test PS/2 input on LSDJ.

# Other

- Small-C style compiler matching SDCC's calling convention, multi-pass via SD temp files
- Document real differences of other X-series carts rather than assuming X7 SD/RTC/button behavior.
- Ports to other cartridges need a loader, SD access and a new memory layout; the PSRAM window is assumed everywhere.
- SGB: use the whole GB screen for text with header/footer in the border, or go fullscreen ([SGB.md](notes/SGB.md); Phases 2–6 and 8 text UI complete in software; Phase 7 hardware checks pending, full controls/mouse next); SNES mouse.
- fix accented characters in font images