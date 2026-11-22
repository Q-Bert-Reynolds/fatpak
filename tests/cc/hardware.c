// volatile hardware registers: LY is polled (a cached read would never change), the LCD is
// switched off in VBlank, a tile and the map are written and read back, then BGP
#include "check.h"
#include <hardware.h>
#include <stdint.h>
static const uint8_t tile[16] = { 0xFF, 0x00, 0x81, 0x7E, 0xBD, 0x42, 0xA5, 0x5A, 0xA5, 0x5A, 0xBD, 0x42, 0x81, 0x7E, 0xFF, 0x00 };
static void wait_vblank(void) { while (rLY != 144) ; }
int main(void) {
  uint8_t i;
  uint16_t n;
  volatile uint8_t* map = VRAM_MAP0;
  wait_vblank();
  CHECK(rLY >= 144);
  rLCDC = 0;
  for (i = 0; i < 16; ++i) VRAM_TILES[16 + i] = tile[i];
  for (n = 0; n < 32u * 32u; ++n) map[n] = (uint8_t)(n & 1);
  for (i = 0; i < 16; ++i) CHECK(VRAM_TILES[16 + i] == tile[i]);
  CHECK(map[0] == 0 && map[1] == 1 && map[1023] == 1);
  rBGP = 0xE4;
  CHECK(rBGP == 0xE4);
  rLCDC = LCDC_ON | LCDC_BG_8000 | LCDC_BG_ON;
  CHECK(rLCDC == 0x91);
  for (i = 0; i < 3; ++i) { while (rLY == 144) ; wait_vblank(); }
  return 0;
}
