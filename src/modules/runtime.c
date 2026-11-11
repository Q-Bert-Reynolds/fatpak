#include "runtime.h"
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

unsigned char module_busy;
unsigned int module_entry;
extern unsigned char FileLoadModule(const char* path, unsigned char id);
extern unsigned int ModuleSwap(unsigned char operation);
extern unsigned char ModuleEnter(void);
extern unsigned char buffer[512]; // synchronous scratch; no module file services

unsigned char RunModule(const char* path, unsigned char id) {
  unsigned char result;
  unsigned int sum;
  if (module_busy) return 16; // FR_LOCKED
  module_busy = 1;
  result = FileLoadModule(path, id);
  if (!result) {
    sum = ModuleSwap(0);
    ModuleSwap(1);
    result = ModuleEnter();
    HideBox(); // remove any modal state before restoring the page
    if (ModuleSwap(2) != sum) RestartDevice();
  }
  module_busy = 0;
  return result;
}

// Copy while the module is still mapped; paged render functions must never see
// a pointer into its code/data. Interrupts do not use the filesystem buffer.
static void Marshal(const char* text, unsigned char limit) {
  unsigned char i = 0;
  while (i < limit && text[i]) { buffer[i] = text[i]; ++i; }
  buffer[i] = 0;
}

unsigned char ModuleAPIVersion(void) { return MODULE_ABI_VERSION; }
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
