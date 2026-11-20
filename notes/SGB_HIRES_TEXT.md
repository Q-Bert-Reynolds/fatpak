# 512×448 text in the browser and editor (design, partly built)

Chosen direction (2026-11-20): character tiles. SETTINGS > FONT > 8X8 TILES draws every document and
the browser in the 8 px mono font, a character a cell (built: the setting, the mono font everywhere).
At 512×448 that font is the only one: 64 columns (the same physical width as today's 4 px font) and
56 rows, each glyph 8×8 hi-res pixels (half today's height, twice the detail).

The 128×56 grid of 4 px cells was set aside: a cache of tile pairs overflows on code screens, and
a bitmap needs four HDMA bands of VRAM, a compositor and a 14 KiB GB model.

## SNES side (not built)

Mode 5 + interlace, no drawing:

- **Layers:** a mode 5 entry shows tiles N and N+1 side by side. BG1 shows the even columns and BG2
  the odd ones (scrolled 8 px), and each glyph is followed by a blank tile so the other layer shows
  through.
- **Fonts:** uploaded once.
  - Each glyph tile has the glyph in plane 0 and its background in plane 1, so paper is opaque and
    a palette picks paper and ink.
  - Two sets per layer, each glyph followed by its blank: 1,024 tiles per layer.
  - BG1 (4bpp) 32 KiB, BG2 (2bpp) 16 KiB, two 32×64 maps 8 KiB: 56 KiB.
- **Colours:** palettes per entry, so every character has its own colour.
  - Six ink classes (the style colours 2–7) plus one selected palette (selected text is drawn in
    plain ink).
  - BG2 uses palettes 4–7, two classes each through a second tile set; BG1 uses palettes 2–7.
  - This keeps clear of the UI's CGRAM 0–15.
- **UI:**
  - The UI can't use BG3 and HDMA bands as the map does: VRAM is full, and the bands would hide
    text across a box's whole rows.
  - Bars, boxes and the OSK are composed into the same character grid by the kernel, in the mono
    font, at the text's size.
  - The GB must lay boxes out in 8 px cells meanwhile.
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
- Next: the character-tile text mode in the extension, the protocol's 56 rows, and the GB
  switching to 56 rows. The GB sends the extension before a map today; it will send it before
  512×448 text too.

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

## Protocol (not built)

- A geometry command for 512×448 text: rows 0–55.
- LAYOUT up to 56 rows; SCROLL ±55.
- Boxes laid out in cells.
- ROW unchanged: 64 characters at most.

## Risks

- Legibility of 8×8 glyphs at 448 interlaced lines (half height) on a real TV.
- GB editing speed with rows in PSRAM: a commit per laid-out row, a fetch per sent row.
- HDMA isn't needed for this, so the first-5A22 HDMA/DMA risk doesn't apply here.
