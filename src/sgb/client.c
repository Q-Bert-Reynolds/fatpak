#include "client.h"
#include "../modules/runtime.h"
#include "../ui/geometry.h"
#include "../ui/screen.h"
#include "../ui/render.h"
#include "../editor/text_buffer.h"
#include "../editor/editor.h"
#include "../editor/view.h"
#include "../keyboard/keyboard.h"
#include "../keyboard/test.h"
extern unsigned char fs_map;
// The fullscreen client's EXIT (src/sgb/display.asm's FsExit, an entry at the renderer's start in bank 1, mapped
// while pages run; FIXED has no room for a stub): 0 once ACKed, 1 not offered
static unsigned char SGBExitPage(void) __naked {
  __asm
    jp _RenderOverlayStart+24
  __endasm;
} // the client's map mode (src/sgb/client.asm): nonzero while a module's map is open
// Default SGB startup (unless RESOLUTION is 160x144) and SETTINGS > RESOLUTION > 256x224.
// Absence or validation/upload failure leaves the original renderer available. With module_context set
// (SGBExit's, after EXIT) its exit instead: the one RUN_MODULE(SGBBOOT), its path a FIXED string
void SGBBegin(void) {
  if(!module_context && ((sys_info&7)!=1 || resolution == RESOLUTION_160)) return;
  RUN_MODULE(SGBBOOT);
  module_context = 0;
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

// Fullscreen off (SETTINGS > RESOLUTION > 160x144, a game's launch): EXIT, if the kernel saved the BIOS at JUMP
// (snes/bios.s; else 160x144 waits for the next boot, a game needs a reset). The SNES goes back to the BIOS's picture and loop, the GB to its own
// renderer (SGBBOOT.MOD's exit) and screen, laid out again here, and its keyboard or mouse driver (stopped for
// JUMP). (A viewer shows its menu between its module's runs, so none is running here; one that was would keep
// fullscreen.) A map open goes with the kernel. Returns 1 if the screen is the GB's again: the caller draws it
unsigned char SGBLeave(unsigned char setup) {
  unsigned char i;
  if (!(sys_info & SYS_INFO_SGBFS) || module_busy || SGBExitPage()) return 0;
  cells_held = 0;
  module_context = (void*)1;
  SGBBegin(); // SGBBOOT.MOD's exit
  GeometryGB();
  for (i = 0; i < BG_MAP_ROWS + WIN_MAP_ROWS; ++i) map_blocks[i] = i < screen_rows ? i : 0xFF; // (EditorInit's)
  ring_top = 0;
  ring_pos = 0;
  // SGBBOOT.MOD's exit turned the LCD off with LCDC = 0, and EditorSetup's DISPLAY_ON only sets bit 7: boot's
  // other bits first (main.asm), or the DMG/SGB shows neither background nor window, color 0 only
  *(volatile unsigned char*)0xFF40 = 0x43; // LCDCF_OFF | LCDCF_WIN9C00 | LCDCF_OBJON | LCDCF_BGON
  EditorSetup(); // the GB's display from scratch, as at boot
  tb_rows = screen_rows - (bars << 1);
  Layout(); // (the caller lays the editor's rows out again, the browser its own)
  // the keyboard as at boot (the SGB's driver: its BIOS bridge again), not for a game (the bridge only to stop it)
  if (setup) KeyboardSetup(2);
  return 1;
}
