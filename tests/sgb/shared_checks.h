/* Stock SNES PPU readback is checked independently in kernel.lua after every
   commit. Fill all 1024 slots, force lookup collisions and reuse released IDs. */
volatile u16 shared_cases, shared_cache_errors;
volatile u16 shared_legacy_frames, shared_upload_frames;
volatile u8 shared_finished;
static u8 shared_expected[1024];
volatile u8 shared_compare_expected;
static void SharedChecks(void) {
  u16 i, id;
  u8 pass, slot, tile, font, style;
  Row row;
  memset((u8*)0xB680, 0xA5, 32);
  for (slot = 0; slot < 32; ++slot) {
    memset(raster, slot + 1, sizeof(raster));
    CacheRaster(slot);
  }
  for (pass = 0; pass < 3; ++pass) {
    for (slot = 0; slot < 32; ++slot) {
      for (tile = 0; tile < 32; ++tile) {
        id = (u16)slot * 32 + tile;
        for (i = 0; i < 32; ++i) {
          raster[(u16)tile * 32 + i] = pass == 0 ? 0
            : pass == 1 ? (i & 1 ? id >> 8 : id) ^ (i * 37)
            : (tile & 1 ? 255 : 0);
        }
      }
      PresentRow(slot);
      ++shared_cases;
      Capture();
    }
  }
  memset(&row, 0, sizeof(row));
  row.flags = SGBFS_ROW_STYLED;
  row.n = 64;
  for (font = 0; font < 7; ++font) {
    row.font = font;
    for (style = 0; style <= STYLE_LABEL; ++style) {
      for (i = 0; i < 64; ++i) {
        row.chars[i] = ' ' + (i * 19 + font * 7) % 95;
        row.attrs[i] = (style << 4) | (font == FONT_FIXED ? 4 : 3 + i % 6);
      }
      ClearRaster();
      fixed_hints = 0;
      shared_compare_expected = 0;
      glyphs(&row, font ? 1 : 0, font ? 249 : 248);
      pixel_start = style & 1 ? 3 : 256;
      pixel_end = style & 1 ? 247 : 256;
      EncodeRow();
      if (font == FONT_FIXED && style != STYLE_ITALIC && style != STYLE_BOLD_ITALIC) {
        fixed_direct = pixel_start == pixel_end;
        fixed_slot = (font * 15 + style) & 31;
        if (fixed_direct) {
          memcpy(shared_expected, raster, sizeof(raster));
          shared_compare_expected = 1;
        }
        fixed_tiles(&row);
        SelectRaster();
        if (pixel_start != pixel_end) fixed_hints = 0;
      }
      PresentRow((font * 15 + style) & 31);
      ++shared_cases;
    }
  }
  /* Sharing must leave all 32 unselected row caches intact. */
  for (slot = 0; slot < 32; ++slot) {
    RestoreRaster(slot);
    for (i = 0; i < sizeof(raster); ++i) if (raster[i] != slot + 1) ++shared_cache_errors;
  }
  for (i = 0; i < 32; ++i) if (((u8*)0xB680)[i] != 0xA5) ++shared_cache_errors;
  /* Compare sixteen fixed-width code rows with the same warm compositor. */
  row.font = FONT_FIXED;
  memset(row.attrs, 4, sizeof(row.attrs));
  PpuInit();
  i = Clock();
  for (slot = 0; slot < 16; ++slot) {
    fixed_tiles(&row);
    PresentRasterRow(slot);
  }
  shared_legacy_frames = Clock() - i;
  memcpy(shared_expected, raster, sizeof(raster));
  shared_compare_expected = 1;
  PpuInit();
  i = Clock();
  for (slot = 0; slot < 16; ++slot) {
    fixed_direct = 1;
    fixed_slot = slot;
    fixed_tiles(&row);
    PresentRow(slot);
    ++shared_cases;
  }
  shared_upload_frames = Clock() - i;
  PpuInit();
  shared_finished = 1;
}
