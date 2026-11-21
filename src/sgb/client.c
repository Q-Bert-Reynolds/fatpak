#include "client.h"
#include "../modules/runtime.h"
#include "../ui/geometry.h"
#include "../ui/screen.h"
#include "../ui/render.h"
#include "../editor/text_buffer.h"
extern unsigned char fs_map; // the client's map mode (src/sgb/client.asm): nonzero while a module's map is open
// Default SGB startup (unless RESOLUTION is 160x144) and SETTINGS > RESOLUTION > 256x224.
// Absence or validation/upload failure leaves the original renderer available.
void SGBBegin(void) {
  if((sys_info&7)!=1 || resolution == RESOLUTION_160) return;
  RUN_MODULE(SGBBOOT);
}

// 512x448 character text on or off as GeometryWide picks it (the settings, a map open): the geometry, its
// rows (cleared, the SNES's too: TEXT, the extension before 1) and the font's widths. The caller lays its
// screen out again
static void CellsSwitch(void) {
  GeometryWide();
  tb_rows = screen_rows - (bars << 1);
  Layout();
  RowsClear();
  SGBText(screen_cells);
  SetFont(font);
}

// SETTINGS > RESOLUTION: 512x448 text on or off. With a map open (a viewer's menu) it waits for the map to close
// (cells_held: the SNES draws maps only beside 256x224's text). Returns 1 if it changed (the caller lays its
// screen out again)
unsigned char SGBCells(void) {
  if (!(sys_info & SYS_INFO_SGBFS) || cells_held || (resolution == RESOLUTION_512) == screen_cells) return 0;
  if (fs_map) {
    cells_held = 1; // SGBCellsMapC switches when it closes
    return 0;
  }
  CellsSwitch();
  return 1;
}

// A module's map opens (cells_map 1) or the text comes back (0), from the fullscreen client's FsBackground
// (_SGBCellsMap): the SNES draws maps only beside 256x224's text, so 512x448 text gives way meanwhile
void SGBCellsMapC(void) {
  if (cells_map ? !screen_cells : !cells_held) return;
  cells_held = cells_map;
  CellsSwitch();
}
