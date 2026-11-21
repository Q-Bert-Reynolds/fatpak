# 512×448 text in the browser and editor (design, partly built)

Chosen direction (2026-11-20): character tiles. SETTINGS > FONT > 8X8 TILES draws every document and
the browser in the 8 px mono font, a character a cell (built: the setting, the mono font everywhere).
At 512×448 that font is the only one: 64 columns (the same physical width as today's 4 px font) and
56 rows, each glyph 8×8 hi-res pixels (half today's height, twice the detail).

The 128×56 grid of 4 px cells was set aside: a cache of tile pairs overflows on code screens, and
a bitmap needs four HDMA bands of VRAM, a compositor and a 14 KiB GB model.

## SNES side (built: `snes/char.s`, notes/SGB.md's "512x448 character text")

Mode 5 + interlace, no drawing:

- **Layers:** a mode 5 entry shows tiles N and N+1 side by side. BG1 shows the even columns and BG2
  the odd ones (scrolled 8 px), and each glyph is followed by a blank tile so the other layer shows
  through.
- **Fonts:** uploaded on each switch to TEXT 1.
  - Each glyph tile has the glyph in plane 0 and its background in plane 1, so paper is opaque and
    a palette picks paper and ink.
  - One set per layer, each glyph followed by its blank, plus 6 box-drawing pieces: 524 tiles.
  - BG1 (4bpp) 16.4 KiB, BG2 (2bpp) 8.2 KiB, two 32×64 maps 8 KiB, in VRAM bytes `$0000–$A7FF`.
- **Colours:** palettes per entry, so every character has its own colour.
  - 8 classes: the six ink classes (style colours 2–7), selected (plain ink on the selection
    colour) and inverse (progress, busy).
  - BG2's palette q is class q. BG1's 4bpp palettes 0 and 1 share their colours 2–3 with BG2's
    palettes 0 and 4, so BG1 gives those classes palettes 0–1 and the others 2–7: no second set.
  - The UI's CGRAM 0–15 isn't needed in TEXT 1 (no BG3); TEXT 0 restores it.
- **UI:**
  - The UI can't use BG3 and HDMA bands as the map does: the bands would hide text across a
    box's whole rows.
  - Bars, boxes and the OSK are composed into the same character grid by the extension, in the
    mono font, at the text's size; frames are box-drawing cells (a frame line fills the spaces of
    a box's first and last lines). The cursor is OBJ tile 1, half height.
  - The GB must lay boxes out in 4 px (one column) units meanwhile, leaving the frame's columns.
- **Maps:** not in TEXT 1 (the map's overlay is 28 rows'): the GB switches to TEXT 0 around one.
- **Code size:** small next to a compositor: mode setup, the font upload, map writes per row, UI
  composition.
  - It goes in the kernel extension (built, see Progress); the kernel itself keeps only stubs.

## Progress (2026-11-20)

- Built: the fullscreen row model is in PSRAM (`SGB_ROWS_BLOCK`, four rows a block). One staging row in
  WRAM (`wide_staging`) acts as a write-back cache: `RenderRowAddress` stages the row asked for,
  writing the previous one back first. `RenderRowRead` stages for reading only (the fullscreen
  sender's). `tb_RenderRows` stages and blanks each row as it starts (`RowBegin`), and
  `tb_ScrollRows` moves rows through the staging row (`RowsShift`).
- Built: the per-row tables are sized for 56 rows (`MAX_SCREEN_ROWS`). That made room in WRAM:
  - the GB renderer's 760-byte cache of drawn characters is now a hash per block (`block_hashes`);
  - the browser reads an entry's kind from its row's text, so `list_kinds` is gone;
  - the GB-only tables (`render_row_blocks`, `ring_blocks`) stay at `GB_MAX_ROWS`.
  Fullscreen still uses 28 rows (`WIDE_ROWS`) until the SNES side exists.
- Built: the kernel extension (notes/SGB.md, SGB.DAT container). It's linked with the kernel and
  sent by the GB in CODE commands from SGB.DAT's PSRAM copy. It runs at `$7E:DC00–FFFF`, the 4 px
  fixed cache's WRAM, so a rebuild of that cache clears `ext_ready`. The map engine (`map.s`,
  2 KiB) moved there: the kernel program went from 21,404 to 19,681 bytes, and the extension
  is 2,009 of its 9,216.
- Built: the character-tile text mode (`snes/char.s`, 2.2 KiB of the extension, now 4,277 bytes;
  the kernel program 20,590 bytes) and TEXT in the protocol, the kernel and `sgb_protocol.py`
  (mode-aware: `text=1` for TEXT 1's limits). `tests/run_sgb_text_kernel.sh` checks bars, styled
  rows, selections, right alignment, a box, the OSK, busy, progress, the cursor and a scroll at
  512×448 pixel for pixel in Mesen, and TEXT 0 giving back the raster text.
- Built, the GB (2026-11-20): SETTINGS > RESOLUTION lists 160x144, 256x224 and 512x448 on any SGB
  (160x144 chosen in fullscreen waits for the next boot). RESOLUTION 512x448 is 512x448 text whatever
  the font (`screen_cells`, src/ui/geometry.asm): `TEXT_FONT` gives the mono font meanwhile and FONT
  keeps its setting, so 256x224 has it back. Chosen in a map's menu, the map goes to 512x448 at once
  and the text when the map closes (`cells_held`):
  - `GeometryWide` gives 56 rows (54 between the bars); the width stays 248 pixels, 62 columns of 4
    (the cursor's sprite x, 8 on, must fit a byte), so columns 62-63 are margin and 63 has BUSY;
  - the mono font, `RenderTextWidth` and the client's widths count 4 pixels a character, so the
    editor, browser, bars and boxes lay out in columns with no other change;
  - the client sends ROW's selection as columns, rows up to `screen_rows`, the footer at its last;
    the editor's cursor sprite keeps 4 lines a row (`row*4+16`), which `FsCursor` reads back;
  - `SGBCells` (src/sgb/client.c, from the FONT and RESOLUTION menus) switches at run time:
    geometry, layout, the PSRAM rows cleared, then the overlay's `FsText` (entry 21: the
    extension and TEXT 1, or TEXT 0) and every row again; `FsInit` does the same at boot;
  - a map: `FsBackground` calls `_SGBCellsMap` first, which drops to 256x224's geometry and TEXT 0
    while it's open (`cells_held`), and after MAP 0 comes back to 512x448 (the extension again).
  - Tests: `tests/run_sgb_text.sh` (the GB frontend on Gearboy's model: the menus, the switch, the
    browser, a 120-line file in 54 rows and its scroll, a map open and closed, 256x224 again) and
    `tests/run_sgb_text_session.sh` (that recording on the real kernel in Mesen: every page
    accepted, the browser's 512x448 screens before and after the map against the reference).
- Not yet: the mouse (`SGBFS_MOUSE_ROW_MASK` is 5 bits; the kernel doesn't offer the mouse yet);
  Gearboy's half-size render of TEXT 1 skips the OSK; the text is blank while a map is open
  (the rows were cleared for 256x224 and come back cleared after: the app's next draw fills
  them). Hardware: legibility of 8x8 glyphs at 448 interlaced lines.

## GB side (was the blocker)

The fullscreen row model is characters and styles per cell, kept in WRAMX:
- today: 28 rows × 64 × 2 = 3.5 KiB, in a 3,744-byte union;
- at 56 rows: 7 KiB.

The SGB has 8 KiB of WRAM in total, and both banks are full:
- WRAM0 has 0 bytes free;
- WRAMX has a few bytes, and the buffers end at the `$DF90` assert.

The per-row tables grow too, and they sit outside the union:
- `tb_row_states`;
- the row starts;
- `render_row_fonts`;
- the row hashes;
- the selection's rows.

Plan:

1. **Rows in PSRAM.** Two rows' 64 characters and 64 styles per 256 bytes, four rows to a
   512-byte block. The WRAM union is free at 512×448, so it becomes:
   - a staging row: geometry points every row at it;
   - the 56-row tables.
2. **Committing rows:**
   - Text layout (`tb_RenderRows`) and `DrawRow` write the staging row, then commit it to its block,
     saving and restoring `EDX_BLOCK`. The text buffer reads through the same window, and its code
     assumes its block stays mapped.
   - `FsEncodeRow` and the row hashes fetch a row into staging first.
   - `tb_ScrollRows` copies rows block to block through staging.
3. **Per-row tables:** move them into the union while 512×448 is on. Their symbols are fixed, so
   their users need a pointer or a second copy.
4. **Space:** the OS pages need about 1–2 KiB more for this. FatFs's code page 850 names freed about
   1.2 KiB on page 11; most of it is still there.

Access sites to change: `tb_RenderRows`, `tb_ScrollRows` and one attribute write in
`text_buffer.asm`; `DrawRow` (`geometry.asm`); `FsEncodeRow` and the row hashes (`display.asm`);
the mouse driver's row read. The GB renderer's own paths (`render.asm`, `color.asm`, the OSK's
rows, the window macros) aren't used in fullscreen.

## Protocol (built)

- TEXT `mode` 0/1. In 1: rows 0–55, LAYOUT up to 56 rows, SCROLL ±55, ROW's selection in
  columns, widths ignored, 64 characters at most. Details in notes/SGB.md.

## Risks

- Legibility of 8×8 glyphs at 448 interlaced lines (half height) on a real TV.
- GB editing speed with rows in PSRAM: a commit per laid-out row, a fetch per sent row.
- HDMA isn't needed for this, so the first-5A22 HDMA/DMA risk doesn't apply here.
