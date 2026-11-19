/* Real 65816 checks: all cache slots coexist, and packed selection agrees
 * with the original shade encoder at every tile boundary/alignment. */
static u8 cache_expected[1024];
volatile u16 cache_checks, cache_mismatches;
volatile u16 cache_cold_frames, cache_warm_frames;
volatile u8 cache_finished, cache_failures[112];
volatile u16 cache_first_offset;
volatile u8 cache_first_actual, cache_first_expected;
static void CacheShade(void) {
  u16 i;
  /* BlitGlyph emits paper, ink/dim, icon color 1 and accents 4..7.
     Accent color 2 (shade 9) is never emitted: color 2 always uses the dim bit. */
  static const u8 shades[16] = {0, 1, 3, 5, 7, 17, 19, 21, 23, 25, 27, 29, 31, 0, 1, 3};
  memcpy(shade, shades, sizeof(shades));
  for (i = 16; i < sizeof(shade); i += 16) memcpy(shade + i, shades, sizeof(shades));
}

static void CacheChecks(void) {
  u16 i, left, right;
  u8 slot, test;
  for (i = 0; i < sizeof(raster); ++i) {
    cache_expected[i] = (u8)((i * 73) ^ (i >> 3));
  }
  for (slot = 0; slot < 32; ++slot) {
    memcpy(raster, cache_expected, sizeof(raster));
    raster[0] = slot;
    raster[1023] = slot ^ 255;
    CacheRaster(slot);
  }
  for (slot = 0; slot < 32; ++slot) {
    memset(raster, 0, sizeof(raster));
    RestoreRaster(slot);
    cache_expected[0] = slot;
    cache_expected[1023] = slot ^ 255;
    if (memcmp(raster, cache_expected, sizeof(raster))) {
      cache_failures[cache_checks] = 1;
      ++cache_mismatches;
    }
    ++cache_checks;
  }

  /* Every shade class occurs on every scanline; selection must also preserve
     the unselected pixels before/after each partial tile. */
  for (left = 0; left < 16; ++left) {
    for (test = 0; test < 5; ++test) {
      right = test == 0 ? left : test == 1 ? left + 1 : test == 2 ? left + 8
                              : test == 3 ? 249 : 256;
      ClearRaster();
      CacheShade();
      pixel_start = pixel_end = 256;
      EncodeRow();
      CacheRaster(31);
      memset(raster, 0, sizeof(raster));
      RestoreRaster(31);
      pixel_start = left;
      pixel_end = right;
      SelectRaster();
      memcpy(cache_expected, raster, sizeof(raster));

      ClearRaster();
      CacheShade();
      EncodeRow();
      if (memcmp(raster, cache_expected, sizeof(raster))) {
        cache_failures[cache_checks] = 1;
        if (!cache_mismatches) {
          for (i = 0; i < sizeof(raster); ++i) {
            if (raster[i] != cache_expected[i]) {
              cache_first_offset = i;
              cache_first_actual = raster[i];
              cache_first_expected = cache_expected[i];
              break;
            }
          }
        }
        ++cache_mismatches;
      }
      ++cache_checks;
      Capture();
    }
  }
  /* Compare repeated full-width selection changes on the same styled row. */
  memset(rows, 0, sizeof(rows));
  rows[0].font = FONT_FIXED;
  rows[0].flags = SGBFS_ROW_STYLED;
  rows[0].n = 60;
  memset(rows[0].chars, 'W', rows[0].n);
  memset(rows[0].attrs, (STYLE_KEYWORD << ATTR_STYLE_SHIFT) | 4, rows[0].n);
  for (test = 0; test < 8; ++test) {
    raster_valid[0] = 0;
    i = Clock();
    draw(0);
    cache_cold_frames += Clock() - i;
  }
  for (test = 0; test < 8; ++test) {
    rows[0].start = 0;
    rows[0].end = test & 1 ? ROW_END_FULL_WIDTH : 0;
    i = Clock();
    draw(0);
    cache_warm_frames += Clock() - i;
  }
  memset(rows, 0, sizeof(rows));
  memset(raster_valid, 0, sizeof(raster_valid));
  drawn_rows = raster_hits = raster_misses = 0;
  cache_finished = 1;
}
