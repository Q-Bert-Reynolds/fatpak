/* The native tile path must reproduce the original glyph/shade compositor. */
static u8 tile_expected[1024];
volatile u16 tile_checks, tile_mismatches;
volatile u16 tile_first_case, tile_first_offset;
volatile u8 tile_first_actual, tile_first_expected, tile_finished;
volatile u16 tile_legacy_frames, tile_cached_frames;

static void TileCase(Row *row, u8 eligible) {
  u8 pass, accepted;
  u16 i;
  ClearRaster();
  glyphs(row, 1, 249);
  pixel_start = pixel_end = SGBFS_WIDTH;
  EncodeRow();
  memcpy(tile_expected, raster, sizeof(raster));
  for (pass = 0; pass < 2; ++pass) {
    ClearRaster();
    accepted = fixed_tiles(row);
    if (accepted != eligible || (accepted && memcmp(raster, tile_expected, sizeof(raster)))) {
      if (!tile_mismatches) {
        tile_first_case = tile_checks;
        for (i = 0; i < sizeof(raster); ++i) {
          if (raster[i] != tile_expected[i]) {
            tile_first_offset = i;
            tile_first_actual = raster[i];
            tile_first_expected = tile_expected[i];
            break;
          }
        }
      }
      ++tile_mismatches;
    }
    ++tile_checks;
    Capture();
  }
}

static void TileChecks(void) {
  Row row;
  u16 i, start;
  u8 style, batch;
  static const u8 lengths[] = {0,1,2,3,60,61,62,63,64};
  memset(&row, 0, sizeof(row));
  row.font = FONT_FIXED;
  row.flags = SGBFS_ROW_STYLED;
  row.n = 64;
  for (style = 0; style <= STYLE_LABEL; ++style) {
    memset(row.attrs, (style << ATTR_STYLE_SHIFT) | 4, sizeof(row.attrs));
    for (batch = 0; batch < 4; ++batch) {
      for (i = 0; i < 64; ++i) row.chars[i] = batch * 64 + i;
      TileCase(&row, style != STYLE_ITALIC && style != STYLE_BOLD_ITALIC);
    }
  }
  for (batch = 0; batch < sizeof(lengths); ++batch) {
    row.n = lengths[batch];
    for (i = 0; i < 64; ++i) {
      row.chars[i] = i % 7 ? 'A' + i % 26 : ' ';
      style = i % 15;
      if (style == STYLE_ITALIC || style == STYLE_BOLD_ITALIC) style = STYLE_TEXT;
      row.attrs[i] = (style << ATTR_STYLE_SHIFT) | 4;
    }
    TileCase(&row, 1);
  }
  row.attrs[0] = (STYLE_TEXT << ATTR_STYLE_SHIFT) | 5;
  TileCase(&row, 0);
  row.attrs[0] = (STYLE_TEXT << ATTR_STYLE_SHIFT) | 4;
  row.flags = 0;
  TileCase(&row, 0);
  row.flags = SGBFS_ROW_STYLED;
  row.font = FONT_VWF;
  TileCase(&row, 0);

  row.font = FONT_FIXED;
  row.n = 60;
  memset(row.chars, 'W', sizeof(row.chars));
  memset(row.attrs, (STYLE_KEYWORD << ATTR_STYLE_SHIFT) | 4, sizeof(row.attrs));
  for (batch = 0; batch < 8; ++batch) {
    start = Clock();
    ClearRaster();glyphs(&row, 1, 249);
    pixel_start = pixel_end = SGBFS_WIDTH;
    EncodeRow();
    tile_legacy_frames += Clock() - start;
  }
  for (batch = 0; batch < 8; ++batch) {
    start = Clock();
    ClearRaster();fixed_tiles(&row);
    tile_cached_frames += Clock() - start;
  }
  tile_finished = 1;
}
