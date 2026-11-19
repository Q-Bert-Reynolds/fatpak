/* Compare direct bitplane packing with the original glyph/shade compositor. */
static u8 plain_expected[1024];
volatile u16 plain_checks, plain_mismatches, plain_first_case, plain_first_offset;
volatile u16 plain_legacy_frames, plain_direct_frames;
volatile u8 plain_first_actual, plain_first_expected, plain_finished;

static void PlainCase(Row *row, u8 eligible) {
  u16 i;
  u8 accepted, bad = 0;
  ClearRaster();
  glyphs(row, row->font ? 1 : 0, row->font ? 249 : 248);
  pixel_start = pixel_end = SGBFS_WIDTH;
  EncodeRow();
  memcpy(plain_expected, raster, sizeof(raster));
  memset(raster, 0xA5, sizeof(raster));
  memset(shade, 0x5A, sizeof(shade));
  accepted = plain_tiles(row);
  if (accepted != eligible || (accepted && memcmp(raster, plain_expected, sizeof(raster)))) bad = 1;
  /* A final-tile spill would overwrite these guard bytes past the raster. */
  for (i = 0; i < 16; ++i) if (shade[i] != 0x5A) bad = 1;
  if (!accepted) for (i = 0; i < sizeof(raster); ++i) if (raster[i] != 0xA5) bad = 1;
  if (bad) {
    if (!plain_mismatches) {
      plain_first_case = plain_checks;
      for (i = 0; i < sizeof(raster); ++i) if (raster[i] != plain_expected[i]) {
        plain_first_offset = i;
        plain_first_actual = raster[i];
        plain_first_expected = plain_expected[i];
        break;
      }
    }
    ++plain_mismatches;
  }
  ++plain_checks;
  Capture();
}

static void PlainChecks(void) {
  Row row;
  u8 font, styled, batch, i;
  u16 start;
  static const u8 lengths[] = {0,1,2,31,32,61,62,63,64};
  memset(&row, 0, sizeof(row));
  for (font = 0; font < 7; ++font) for (styled = 0; styled < 2; ++styled) {
    row.font = font;row.flags = styled;row.n = 32;
    memset(row.attrs, 4, sizeof(row.attrs));
    for (batch = 0; batch < 8; ++batch) {
      for (i = 0; i < 32; ++i) row.chars[i] = batch * 32 + i;
      PlainCase(&row, styled || (batch != 0 && batch != 3 && batch != 4));
    }
    for (batch = 0; batch < sizeof(lengths); ++batch) {
      row.n = lengths[batch];
      for (i = 0; i < 64; ++i) row.chars[i] = i % 7 ? 'a' + i % 26 : ' ';
      PlainCase(&row, 1);
    }
  }
  row.font = FONT_VWF;row.flags = SGBFS_ROW_STYLED;row.n = 64;
  for (batch = 1; batch <= 15; ++batch) {
    memset(row.attrs, batch, sizeof(row.attrs));
    PlainCase(&row, 1);
  }
  memset(row.attrs, 4, sizeof(row.attrs));
  row.attrs[63] |= STYLE_BOLD << ATTR_STYLE_SHIFT;
  PlainCase(&row, 0);
  row.attrs[63] = 4;row.font = 7;
  PlainCase(&row, 0);
  row.font = FONT_VWF;row.flags = 0;row.chars[63] = 127;
  PlainCase(&row, 0);

  row.font = FONT_VWF;row.flags = 0;row.n = 40;
  memset(row.chars, 'W', sizeof(row.chars));
  for (batch = 0; batch < 8; ++batch) {
    start = Clock();
    ClearRaster();glyphs(&row, 1, 249);
    pixel_start = pixel_end = SGBFS_WIDTH;
    EncodeRow();
    plain_legacy_frames += Clock() - start;
  }
  for (batch = 0; batch < 8; ++batch) {
    start = Clock();plain_tiles(&row);
    plain_direct_frames += Clock() - start;
  }
  plain_finished = 1;
}
