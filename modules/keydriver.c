// Driver setup is a small module: only the selected payload occupies page 15.
#include "../build/modules/sdk.h"
#include "lib/psram.h"
#include "lib/text.h"

#define DRIVER_SIZE 0x580
#define STAGE MODULE_STAGE
static const char ps2[] = "/GBCSYS/DRIVERS/PS2.DRV";
static const char igkb[] = "/GBCSYS/DRIVERS/IGKB.DRV";

static unsigned char Load(unsigned char type) {
  ModuleLoad load;
  unsigned int crc = 0xFFFF, expected, n, i;
  unsigned char block, bit, header[16];
  load.block = STAGE; load.blocks = 4;
  if (ModLoad(type == 1 ? ps2 : igkb, &load)) return 1;
  if (load.size != 512 + DRIVER_SIZE) return 1;
  Window(STAGE);
  for (i = 0; i < sizeof(header); ++i) header[i] = WINDOW[i];
  if (header[0] != 'F' || header[1] != 'P' || header[2] != 'K' || header[3] != 'D' || header[4] != 1 ||
      header[5] != (type == 1 ? 1 : 2) || header[14] != *(volatile unsigned char*)0x14E ||
      header[15] != *(volatile unsigned char*)0x14F || *(unsigned int*)(header+6) != ModDriver(0x40) ||
      *(unsigned int*)(header+8) != ModDriver(0x41) || *(unsigned int*)(header+12) != DRIVER_SIZE) return 1;
  expected = *(unsigned int*)(header+10);
  for (block = 0; block < 3; ++block) {
    Window(STAGE + 1 + block);
    n = block == 2 ? DRIVER_SIZE - 1024 : 512;
    for (i = 0; i < n; ++i) {
      crc ^= (unsigned int)WINDOW[i] << 8;
      for (bit = 0; bit < 8; ++bit) crc = crc & 0x8000 ? (crc << 1) ^ 0x1021 : crc << 1;
    }
  }
  if (crc != expected) return 1; // reject before replacing any active driver byte
  ModDriver(0x80); // stop the current keyboard before its code is replaced
  for (block = 0; block < 3; ++block) {
    Window(STAGE + 1 + block);
    ModDriver(block);
  }
  return 0;
}
unsigned char KeyboardDriverMenu(void* menu) {
  unsigned char type = *((unsigned char*)ModDriver(0x40) + 1), key, i;
  char lines[4 * BOX_STRIDE];
  if (type > 3) type = 1;
  if (menu) {
    for (i = 0; i < 4; ++i) ModString(lines + i*BOX_STRIDE, S_DRIVER_NONE + i);
    while (1) {
      ModMenu(lines, 4, type);
      while (!(key = ModKey()));
      if (key == KEY_ESCAPE || key == KEY_MENU || key == KEY_BACKSPACE) { ModHideBox(); return 0; }
      if (key == KEY_UP) type = (type - 1) & 3;
      if (key == KEY_DOWN) type = (type + 1) & 3;
      if (key == KEY_ENTER) break;
    }
  }
  if (type && Load(type)) { ModBox(Str(S_MODULE_DAMAGED)); while (!ModKey()); ModHideBox(); return 1; }
  ModDriver((menu ? 0xC0 : 0x80) | type);
  ModHideBox();
  return 0;
}
