// Overlay loader and the resident wrappers behind the module ABI (notes/MODULES.md).
#include "runtime.h"
#include "../app/dialogs.h"
#include "../fatfs/file_api.h"
#include "../game/loader.h"
#include "../ui/dialogs.h"
#include "../ui/render.h"
#include "../ui/screen.h"
#include "../ui/footer.h"
#include "../input.h"
#include "../keyboard/keyboard.h"
#include "../rtc/rtc.h"
#include "../../build/modules/sdk.h"

#define FR_NO_FILE        4 // FRESULT (src/fatfs/lib/ff.h), defined locally like src/app/dialogs.c
#define FR_NO_PATH        5
#define FR_INVALID_OBJECT 9
#define FR_LOCKED         16
#define MENU_LINES ((BUFFER_SIZE - BOX_LINE * TB_STRIDE) / BOX_STRIDE) // box text stays inside tile_buffer

unsigned char module_busy;
unsigned int module_entry;
unsigned char module_status;
extern unsigned char fs_LoadModule(const char* path, unsigned char id); // src/fatfs/fatfs.c
extern unsigned char ModuleSwap(unsigned char operation); // 0 when the copy read back
extern unsigned char ModuleEnter(void);
extern unsigned char buffer[512]; // synchronous scratch; no module file services

unsigned char RunModule(const char* path, unsigned char id) {
  unsigned char result;
  if (module_busy) return FR_LOCKED;
  module_busy = 1;
  result = fs_LoadModule(path, id);
  if (!result) {
    if (ModuleSwap(0)) result = MODULE_ERR_VERIFY; // backup unreadable: the page is untouched
    else if (ModuleSwap(1)) result = MODULE_ERR_VERIFY; // partly installed: restore below
    else {
      module_status = ModuleEnter();
      HideBox(); // remove any modal state before restoring the page
    }
    if (ModuleSwap(2)) RestartDevice(); // never run an OS page that didn't come back
  }
  module_context = 0;
  module_busy = 0;
  return result;
}

void ShowModuleError(unsigned char result) {
  if (result == FR_NO_FILE || result == FR_NO_PATH) ShowMessage("MODULE MISSING");
  else if (result == FR_INVALID_OBJECT) ShowMessage("MODULE DAMAGED");
  else if (result == MODULE_ERR_ABI) ShowMessage("MODULE NEEDS NEWER OS");
  else if (result == MODULE_ERR_VERIFY) ShowMessage("MODULE LOAD FAILED");
  else ShowError(result, "MODULE MISSING");
}

// Copy while the module is still mapped; paged render functions must never see
// a pointer into its code/data. Interrupts do not use the filesystem buffer.
static void Marshal(const char* text, unsigned char limit) {
  unsigned char i = 0;
  while (i < limit && text[i]) { buffer[i] = text[i]; ++i; }
  buffer[i] = 0;
}

unsigned char ModuleAPIVersion(void) { return MODULE_ABI; }
void ModuleAPIRow(unsigned char row, const char* text) {
  if (row >= TB_ROWS) return;
  Marshal(text, TB_STRIDE);
  if (row == TB_ROWS - 1) FooterDraw(row, 0, (char*)buffer);
  else DrawRow(row, 0, (char*)buffer);
}
unsigned char ModuleAPIFrame(void) {
  EditorDraw();
  WaitFrame();
  return PadPressed();
}
unsigned int ModuleAPIEvent(void) { return KBPopEvent(); }
void ModuleAPIListen(void) { KBListen(); }
void ModuleAPIKeyboard(ModuleKeyboard* state) {
  state->type = kb_type;
  state->write = kb_buffer_write;
  state->bytes = kb_interrupt_count;
  state->errors = kb_error_count;
}
unsigned int ModuleAPIScan(unsigned char index) {
  index &= 63;
  return kb_scan_code_buffer[index] | ((unsigned int)kb_error_buffer[index] << 8);
}
void ModuleAPIBox(const char* text) {
  Marshal(text, 19);
  ShowBusy((char*)buffer);
}
void ModuleAPIHideBox(void) { HideBox(); }
unsigned char ModuleAPIClock(ModuleClock* clock) {
  ClockDate local;
  unsigned char i, result;
  for (i = 0; i < sizeof(local); ++i) ((unsigned char*)&local)[i] = 0;
  result = ClockRead(&local);
  for (i = 0; i < sizeof(local); ++i) ((unsigned char*)clock)[i] = ((unsigned char*)&local)[i];
  return result;
}

// ABI 2
void ModuleAPIText(unsigned char row, unsigned char col, const char* text) {
  if (row > STATUS_LINE || col >= TB_STRIDE) return; // text rows and both bars
  Marshal(text, TB_STRIDE);
  DrawRow(row, col, (char*)buffer);
}
unsigned char ModuleAPIKey(void) {
  EditorDraw();
  return MenuKey();
}
// count lines of BOX_STRIDE chars, selected 0xFF for no highlight
void ModuleAPIMenu(const char* lines, unsigned char count, unsigned char selected) {
  char* dest = RowAddress(BOX_LINE);
  unsigned int i, size;
  if (count > MENU_LINES) count = MENU_LINES;
  size = (unsigned int)count * BOX_STRIDE;
  for (i = 0; i < size; ++i) dest[i] = lines[i];
  OpenBox(count);
  render_box_sel = selected < count ? selected + 1 : 0xFF;
}
unsigned char ModuleAPIClockSet(const ModuleClock* clock) {
  ClockDate local;
  unsigned char i;
  for (i = 0; i < sizeof(local); ++i) ((unsigned char*)&local)[i] = ((const unsigned char*)clock)[i];
  return ClockWrite(&local);
}
