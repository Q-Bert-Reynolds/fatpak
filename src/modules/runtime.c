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
#include "../editor/settings.h"
#include "../editor/state.h"
#include "../ui/theme.h"
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
extern unsigned char ModuleSwapRAM(unsigned char operation);
extern unsigned char module_wide; // fs_LoadModule: the staged module is MODULE_FORMAT_WIDE
extern unsigned int tb_read_pos; // src/editor/text_buffer.asm
extern unsigned int tb_Read(unsigned char* buffer, unsigned int size); // from tb_read_pos, returns bytes copied
extern unsigned char ModuleEnter(void);
extern unsigned char buffer[512]; // synchronous scratch; no module file services
extern void SetWindowBlock(unsigned int block);
#define WINDOW_BLOCK (*(volatile unsigned int*)0xBD02)
#define WINDOW ((const unsigned char*)0xBE00u)

// Wide modules (MODULE_FORMAT_WIDE) also take MODULE_PAGE2, maybe MODULE_PAGE3, and the
// editor's WRAMX buffers, which come back before HideBox needs them.
unsigned char RunModule(const char* path, unsigned char id) {
  unsigned char result, step = 0; // pages installed, 4: the buffers saved too
  unsigned int window = WINDOW_BLOCK; // modules may move it
  if (module_busy) return FR_LOCKED;
  module_busy = 1;
  result = fs_LoadModule(path, id);
  if (!result) {
    if (ModuleSwap(0)) result = MODULE_ERR_VERIFY; // backup unreadable: the page is untouched
    else {
      step = 1;
      if (ModuleSwap(1)) result = MODULE_ERR_VERIFY; // partly installed: restored below
      else if (!module_wide) module_status = ModuleEnter();
      else if (ModuleSwap(4)) result = MODULE_ERR_VERIFY;
      else {
        step = 2;
        if (ModuleSwap(5)) result = MODULE_ERR_VERIFY;
        else if (module_wide > 1 && ModuleSwap(8)) result = MODULE_ERR_VERIFY;
        else {
          if (module_wide > 1) step = 3;
          if (step == 3 && ModuleSwap(9)) result = MODULE_ERR_VERIFY;
          else if (ModuleSwapRAM(0)) result = MODULE_ERR_VERIFY; // the buffers are intact
          else {
            step = 4;
            module_status = ModuleEnter();
          }
        }
      }
    }
    if (step == 4 && ModuleSwapRAM(2)) RestartDevice(); // never run on state that didn't come back
    if (step >= 3 && module_wide > 1 && ModuleSwap(10)) RestartDevice();
    if (step >= 2 && ModuleSwap(6)) RestartDevice();
    HideBox(); // remove any modal state before restoring the page
    if (step && ModuleSwap(2)) RestartDevice();
    SetWindowBlock(window);
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

// ABI 3
// Bytes of EDITOR.DAT (offset from its first block); 1 if it isn't loaded or the range is outside it.
unsigned char ModuleAPIData(unsigned int offset, char* dest, unsigned char length) {
  unsigned int saved = WINDOW_BLOCK, block = 0xFFFF, at;
  unsigned char i;
  if (!data_loaded || offset > DATA_BLOCKS * 512u - length) return 1;
  for (i = 0; i < length; ++i) {
    at = offset + i;
    if ((at >> 9) != block) SetWindowBlock(DATA_BLOCK + (block = at >> 9));
    dest[i] = WINDOW[at & 511];
  }
  SetWindowBlock(saved);
  return 0;
}
void ModuleAPIScroll(unsigned char down) { ScrollRows(down); }
void ModuleAPIDraw(void) { EditorDraw(); }
// theme 0xFF only reads it; a change applies the palettes and saves the setting
unsigned char ModuleAPITheme(unsigned char value) {
  if (value != 0xFF && (value ? THEME_DARK : THEME_LIGHT) != theme) {
    theme = value ? THEME_DARK : THEME_LIGHT;
    ThemeApply();
    SettingsSave();
  }
  return theme;
}

// ABI 4
// up to MODULE_SOURCE_CHUNK bytes of the text buffer from pos, returns how many (0 past the end)
unsigned char ModuleAPISource(unsigned int pos, char* dest) {
  unsigned int saved = WINDOW_BLOCK, n; // the text buffer selects its blocks with the low byte only
  SetWindowBlock(TB_PSRAM_HIGH << 8);
  tb_read_pos = pos;
  n = tb_Read((unsigned char*)dest, MODULE_SOURCE_CHUNK);
  SetWindowBlock(saved);
  return (unsigned char)n;
}
// ModuleAPIFar is in runtime.asm: wide modules' cross-page thunks

// ABI 5
// A file into PSRAM blocks from block: the path is relative to the document's folder, or
// failing that its base name is looked for there. Returns the length, 0 if it can't be read,
// 0xFFFF if it's 64 KiB or more. For ASM.MOD's INCLUDE.
// dir "/" name into full (JoinPath is in page 5, which ASM.MOD borrows); 0 if it doesn't fit
static unsigned char Join(char* full, const char* name) {
  unsigned char i = 0;
  const char* p;
  for (p = file_dir; *p; ++p) { if (i == PATH_SIZE + FS_NAME_SIZE - 2) return 0; full[i++] = *p; }
  full[i++] = '/';
  for (p = name; *p; ++p) { if (i == PATH_SIZE + FS_NAME_SIZE - 1) return 0; full[i++] = *p; }
  full[i] = 0;
  return 1;
}
unsigned int ModuleAPIFile(const char* path, unsigned int block) {
  char full[PATH_SIZE + FS_NAME_SIZE]; // path is in the module's WRAMX BSS, readable throughout
  const char *base = path, *p;
  unsigned int length = 0;
  if (Join(full, path)) length = FileReadFile(full, block);
  if (length) return length;
  for (p = path; *p; ++p) if (*p == '/') base = p + 1;
  if (base == path || !Join(full, base)) return 0;
  return FileReadFile(full, block);
}
