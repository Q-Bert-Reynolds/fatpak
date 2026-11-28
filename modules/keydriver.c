// Driver setup is a small module: only the selected payload occupies page 15.
#include "../build/modules/sdk.h"
#include "lib/psram.h"
#include "lib/text.h"

#define DRIVER_SIZE 0x8C0 // src/keyboard/keyboard.asm's KB_DRIVER_SIZE
#define DRIVER_BLOCKS 5 // its 512-byte blocks (ModDriver(block) installs one)
#define STAGE MODULE_STAGE
static const char ps2[] = "/GBCSYS/DRIVERS/PS2.DRV";
static const char snes[] = "/GBCSYS/DRIVERS/SGBMOUSE.DRV";
static const char igkb[] = "/GBCSYS/DRIVERS/IGKB.DRV";
static const char sgb_igkb[] = "/GBCSYS/DRIVERS/SGBIGKB.DRV";
static const unsigned char choices[7] = {0, 1, 2, 2, 1, 0, 2}; // the menu's choice of each type saved
static const unsigned char sgb_types[3] = {5, 4, 6}; // an SGB's type for each choice: the SNES mouse with it

static unsigned char bridge; // Load uploaded the BIOS bridge

static unsigned char Load(unsigned char type) {
  ModuleLoad load;
  unsigned int crc = 0xFFFF, expected, n, i;
  unsigned char block, bit, header[17], count;
  load.block = STAGE; load.blocks = 8;
  if (ModLoad(type == 1 ? ps2 : type == 4 || type == 5 ? snes : type == 6 ? sgb_igkb : igkb, &load)) return 1;
  Window(STAGE);
  for (i = 0; i < sizeof(header); ++i) header[i] = WINDOW[i];
  if (header[0] != 'F' || header[1] != 'P' || header[2] != 'K' || header[3] != 'D' || header[4] != 1 ||
      header[5] != (type == 5 ? 4 : type) || header[14] != *(volatile unsigned char*)0x14E ||
      header[15] != *(volatile unsigned char*)0x14F || *(unsigned int*)(header+6) != ModDriver(0x40) ||
      *(unsigned int*)(header+8) != ModDriver(0x41) || *(unsigned int*)(header+12) != DRIVER_SIZE) return 1;
  count = type >= 4 ? header[16] : 0;
  if (type >= 4 ? (!count || count > 64 || load.size != 512 + DRIVER_BLOCKS * 512 + (unsigned int)count * 16) : load.size != 512 + DRIVER_SIZE) return 1;
  expected = *(unsigned int*)(header+10);
  for (block = 0; (unsigned int)block * 512 < load.size - 512; ++block) {
    Window(STAGE + 1 + block);
    n = load.size - 512 - (unsigned int)block * 512;
    if (n > 512) n = 512;
    for (i = 0; i < n; ++i) {
      crc ^= (unsigned int)WINDOW[i] << 8;
      for (bit = 0; bit < 8; ++bit) crc = crc & 0x8000 ? (crc << 1) ^ 0x1021 : crc << 1;
    }
  }
  if (crc != expected) return 1; // reject before replacing any active driver byte
  ModDriver(0x80); // stop the current keyboard before its code is replaced
  for (block = 0; block < DRIVER_BLOCKS; ++block) {
    Window(STAGE + 1 + block);
    ModDriver(block);
  }
  // the BIOS bridge's upload: not in fullscreen, where the kernel reads the mouse (EXIT's KeyboardSetup sends it)
  if (*(unsigned char*)ModDriver(0x43) & 4) count = 0;
  for (block = 0; block < count; ++block) {
    Window(STAGE + 1 + DRIVER_BLOCKS + (block >> 5));
    n = (unsigned int)(block & 31) * 16;
    for (i = 0; i < 16; ++i) WINDOW[i] = WINDOW[n + i];
    ModDriver(0x42);
  }
  bridge = count;
  return 0;
}
// SETTINGS > KEYBOARD: NONE, PS/2 KEYBOARD, iGKB USB, TEST. On an SGB each comes with the SNES mouse in port 2
// (SGBMOUSE.DRV: type 4 with PS/2, 5 without a keyboard; SGBIGKB.DRV: 6 with the iGKB; fullscreen too, where the
// kernel reads the mouse); elsewhere a saved SGB type is its keyboard's. Without a menu (boot, EXIT) it loads the
// saved choice
unsigned char KeyboardDriverMenu(void* menu) {
  unsigned char type = *((unsigned char*)ModDriver(0x40) + 1), key, i;
  char lines[4 * BOX_STRIDE];
  unsigned char has_sgb = *(unsigned char*)ModDriver(0x43) & 1;
  type = type < sizeof(choices) ? choices[type] : 1; // (3, the former mouse-only choice: the iGKB)
  if (menu) {
    for (i = 0; i < 3; ++i) ModString(lines + i*BOX_STRIDE, S_DRIVER_NONE + i);
    ModString(lines + 3*BOX_STRIDE, S_SUB_KEYBOARD_TEST);
    while (1) {
      ModMenu(lines, 4, type);
      while (!(key = ModKey()));
      if (key == KEY_ESCAPE || key == KEY_MENU || key == KEY_BACKSPACE) { ModHideBox(); return 0; }
      if (key == KEY_UP) type = (type - 1) & 3;
      if (key == KEY_DOWN) type = (type + 1) & 3;
      if (key == KEY_ENTER) break;
    }
    if (type == 3) { ModHideBox(); return 2; }
  }
  if (has_sgb) type = sgb_types[type];
  if (type && Load(type)) {
    // boot, EXIT: without the SGB's file its keyboard alone (PS/2's is built in)
    if (!menu && type >= 4) { type = choices[type]; if (type == 1 || (type && Load(type))) return 0; }
    else { ModBox(Str(S_MODULE_DAMAGED)); while (!ModKey()); ModHideBox(); return 1; }
  }
  ModDriver((menu ? 0xC0 : 0x80) | type); // (its init stops a running bridge: flagged after it)
  if (type >= 4 && bridge) *(unsigned char*)ModDriver(0x43) |= 8; // SYS_INFO_BRIDGE: KBDriverStop stops it
  ModHideBox();
  return 0;
}
