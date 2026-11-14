// Overlay loader and the resident wrappers behind the module ABI (notes/MODULES.md).
#include "runtime.h"
#include "../app/dialogs.h"
#include "../fatfs/file_api.h"
#include "../game/loader.h"
#include "../ui/dialogs.h"
#include "../ui/render.h"
#include "../ui/text.h"
#include "../ui/screen.h"
#include "../ui/footer.h"
#include "../input.h"
#include "../keyboard/keyboard.h"
#include "../rtc/rtc.h"
#include "../editor/settings.h"
#include "../editor/state.h"
#include "../editor/text_buffer.h"
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
extern unsigned int module_fail; // runtime.asm: operation and block of the first copy that never read back
extern unsigned char module_wide; // fs_LoadModule: a wide module's pages after the first (0 for others)
extern unsigned int tb_read_pos; // src/editor/text_buffer.asm
extern unsigned int tb_Read(unsigned char* buffer, unsigned int size); // from tb_read_pos, returns bytes copied
extern unsigned char ModuleEnter(void);
extern void ModuleAbort(unsigned char status); // runtime.asm: back out of the module, ModuleEnter returns status
extern unsigned int module_retries; // runtime.asm: block copies made again since RunModule started
extern unsigned char buffer[512]; // synchronous scratch; no module file services
extern void SetWindowBlock(unsigned int block);
#define WINDOW_BLOCK (*(volatile unsigned int*)0xBD02)
#define INTERRUPT_ENABLE (*(volatile unsigned char*)0xFFFF) // rIE
#define IEF_LCD_ONLY 0x02 // IEF_STAT
#define WINDOW ((const unsigned char*)0xBE00u)

// Wide modules (MODULE_FORMAT_WIDE) also take MODULE_PAGE2, maybe MODULE_PAGE3, and the
// editor's WRAMX buffers, which come back before HideBox needs them.
// a restore that never read back: recorded in PSRAM (it survives the cartridge reset), then restart
static void Unrecoverable(void) {
  SetWindowBlock(MODULE_FAIL_BLOCK);
  ((unsigned char*)WINDOW)[0] = 'M';
  ((unsigned char*)WINDOW)[1] = 'F';
  ((unsigned char*)WINDOW)[2] = ((unsigned char*)&module_fail)[0];
  ((unsigned char*)WINDOW)[3] = ((unsigned char*)&module_fail)[1];
  RestartDevice();
}

#define PROGRESS_FRAMES 300 // ModProgress draws at most every 5 s: each costs about 30 frames on DMG
static unsigned int progress_at; // render_frames when the module started or ModProgress last drew
static unsigned char module_ie; // RunModule: the interrupts outside the module (a wide one runs with the LCD's only)
unsigned char file_level; // ModFile/ModLoad: the folder level (characters of file_dir) that found the first one
// (ASM.MOD's project.gbp: BuildFile reads it after), tried first; 0xFF none yet
// ModStat's counts, from RunModule's start: frames (as render_frames moves, which wraps after 18
// minutes: counted at least every ModProgress), those spent finding and reading files, the files
unsigned long module_frames;
static unsigned int frames_at;
static unsigned long load_frames;
static unsigned int load_files;
const char* module_loading; // ModFile/ModLoad: the name of the file being read, for module_progress; else 0
static unsigned char module_aborted; // ModProgress: a copy failed, the module was stopped (ModuleAbort)
static unsigned char buffers_live; // and the editor's buffers stayed in WRAMX (their backup may be partial)
static void CountFrames(void) {
  module_frames += (unsigned int)(render_frames - frames_at);
  frames_at = render_frames;
}
unsigned char RunModule(const char* path, unsigned char id) {
  unsigned char result, pages = 0, buffers = 0, i, ie; // pages backed up (each is restored), the buffers saved
  unsigned int window = WINDOW_BLOCK; // modules may move it
  if (module_busy) return FR_LOCKED;
  module_busy = 1;
  module_fail = 0;
  module_retries = 0;
  module_frames = load_frames = 0;
  frames_at = render_frames;
  load_files = 0;
  module_aborted = buffers_live = 0;
  module_loading = 0;
  file_level = 0xFF;
  result = fs_LoadModule(path, id);
  if (!result) {
    for (i = 0; i <= module_wide && !result; ++i) { // the first page, then a wide module's others
      if (ModuleSwap(i << 2)) result = MODULE_ERR_VERIFY; // backup unreadable: that page is untouched
      else {
        ++pages;
        if (ModuleSwap(i << 2 | 1)) result = MODULE_ERR_VERIFY; // partly installed: restored below
      }
    }
    if (!result && module_wide) {
      if (ModuleSwapRAM(0)) result = MODULE_ERR_VERIFY; // the buffers are intact
      else buffers = 1;
    }
    if (!result) {
      // A wide module can't draw or read input, so only the LCD interrupt (the screen's
      // layout) stays on: no VBlank (sprite DMA, pad latch) and no keyboard
      module_ie = ie = INTERRUPT_ENABLE;
      progress_at = render_frames;
      if (module_wide) INTERRUPT_ENABLE = ie & IEF_LCD_ONLY;
      module_status = ModuleEnter();
      INTERRUPT_ENABLE = ie;
      if (module_aborted) result = MODULE_ERR_COPY;
    }
    if (buffers && !buffers_live && ModuleSwapRAM(2)) Unrecoverable(); // never run on state that didn't come back
    while (pages > 1) if (ModuleSwap(--pages << 2 | 2)) Unrecoverable();
    HideBox(); // remove any modal state before restoring the page
    if (pages && ModuleSwap(2)) Unrecoverable();
    SetWindowBlock(window);
  }
  module_context = 0;
  module_progress = 0;
  module_busy = 0;
  return result;
}

// text and the failed copy as operation:block (ModuleSwap's operation, 32 and up for ModuleSwapRAM's)
static void ShowFailure(unsigned int text) {
  char line[LANG_MAX + 8], *end;
  unsigned char op = ((unsigned char*)&module_fail)[0];
  end = PutStr(line, S_PART(text, 0));
  end = PutStr(PutNumber(end, op), S_PART(text, 1));
  PutStr(PutNumber(end, ((unsigned char*)&module_fail)[1]), S_PART(text, 2));
  ShowMessage(line);
}
// after a restart for a restore that never read back: says so once (main.c)
void ShowModuleRestart(void) {
  unsigned char* w = (unsigned char*)WINDOW;
  unsigned int saved = WINDOW_BLOCK;
  unsigned char found;
  SetWindowBlock(MODULE_FAIL_BLOCK);
  found = w[0] == 'M' && w[1] == 'F';
  if (found) {
    ((unsigned char*)&module_fail)[0] = w[2];
    ((unsigned char*)&module_fail)[1] = w[3];
    w[0] = 0;
  }
  SetWindowBlock(saved);
  if (found) ShowFailure(S_RESTORE_FAILED);
}

void ShowModuleError(unsigned char result) {
  if (result == FR_NO_FILE || result == FR_NO_PATH) ShowMessage(Str(S_MODULE_MISSING));
  else if (result == FR_INVALID_OBJECT) ShowMessage(Str(S_MODULE_DAMAGED));
  else if (result == MODULE_ERR_ABI) ShowMessage(Str(S_MODULE_NEWER_OS));
  else if (result == MODULE_ERR_VERIFY) ShowFailure(S_MODULE_LOAD_FAILED);
  else if (result == MODULE_ERR_COPY) ShowFailure(S_MODULE_COPY_FAILED);
  else ShowError(result, S_MODULE_MISSING);
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
// DATA_HELP's blocks come from the loaded language's help (LANG_HELP) instead.
#define HELP_START (DATA_HELP * 512u)
#define HELP_END ((DATA_HELP + 4) * 512u)
unsigned char ModuleAPIData(unsigned int offset, char* dest, unsigned char length) {
  unsigned int saved = WINDOW_BLOCK, block = 0xFFFF, at, base = DATA_BLOCK;
  unsigned char i;
  if (!data_loaded || offset > DATA_BLOCKS * 512u - length) return 1;
  if (offset >= HELP_START && offset < HELP_END && lang_count) {
    if (offset > HELP_END - length) return 1;
    offset -= HELP_START;
    base = LANG_BLOCK + LANG_HELP;
  }
  for (i = 0; i < length; ++i) {
    at = offset + i;
    if ((at >> 9) != block) SetWindowBlock(base + (block = at >> 9));
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

// ABI 5 and 7: ASM.MOD's files, read whole into PSRAM. The path is tried relative to the document's folder, then to each folder above it (RGBDS resolves
// includes from where it runs, usually a project's root: "src/x.inc" from src/main.asm), then
// its base name in the document's folder. A build's files mostly resolve from one folder, so
// the one that worked last is tried first.
// FileTry and FileSearch: 0 read, 1 not there or unreadable, 2 too big
// The path goes in buffer's upper half, not on the stack: a progress draw from inside the read
// (fs_LoadFile) is the deepest the stack gets, and with the path on it, it ran past stack_top into
// module_wide. The draw's text uses buffer's first 80 bytes; FatFs doesn't use buffer (FF_FS_TINY).
#define FILE_PATH ((char*)buffer + 256)
typedef char file_path_fits[PATH_SIZE + FS_NAME_SIZE <= 256 ? 1 : -1];
static unsigned char FileTry(unsigned char n, const char* name, ModuleLoad* load) { // file_dir's first n characters, "/", name
  char* full = FILE_PATH; // name is in the module's WRAMX BSS, readable throughout
  unsigned char i;
  unsigned long start;
  for (i = 0; i < n; ++i) full[i] = file_dir[i];
  full[i++] = '/';
  module_loading = full + i; // the progress box names it (full is the host's: the module's BSS may be swapped out)
  while (*name) {
    if (i == PATH_SIZE + FS_NAME_SIZE - 1) { module_loading = 0; return 1; }
    if ((full[i++] = *name++) == '/') module_loading = full + i;
  }
  full[i] = 0;
  CountFrames();
  start = module_frames;
  i = FileLoadFile(full, load); // its search and read time count, found or not
  CountFrames();
  load_frames += module_frames - start;
  if (!i) ++load_files;
  module_loading = 0;
  return i;
}
static unsigned char FileSearch(const char* path, ModuleLoad* load) {
  const char *base = path, *p;
  unsigned char n = 0, end, result;
  while (file_dir[n]) ++n;
  end = n;
  if (file_level <= end && (result = FileTry(file_level, path, load)) != 1) return result;
  while (1) {
    if (n != file_level && (result = FileTry(n, path, load)) != 1) {
      if (file_level == 0xFF) file_level = n;
      return result;
    }
    if (!n) break;
    while (n && file_dir[--n] != '/'); // up a folder
  }
  for (p = path; *p; ++p) if (*p == '/') base = p + 1;
  return base != path ? FileTry(end, base, load) : 1;
}
// ModFile: into PSRAM from block; the length, 0 if it can't be read, 0xFFFF if it's 64 KiB or more
unsigned int ModuleAPIFile(const char* path, unsigned int block) {
  ModuleLoad load;
  unsigned char result;
  load.block = block;
  load.blocks = 128;
  result = FileSearch(path, &load);
  return result ? result == 2 ? 0xFFFF : 0 : (unsigned int)load.size;
}
// ABI 7: the same search for a file of any size: into load->blocks blocks from load->block;
// load->size gets its size. 0 if it's there, 1 if it can't be read, 2 if it doesn't fit.
unsigned char ModuleAPILoad(const char* path, ModuleLoad* load) {
  ModuleLoad here; // the module's is in WRAMX
  unsigned char result;
  here.block = load->block;
  here.blocks = load->blocks;
  result = FileSearch(path, &here);
  load->size = here.size;
  return result;
}

// ABI 6: HEXVIEW.MOD
// up to MODULE_SOURCE_CHUNK bytes of the file the host opened with FileViewOpen, from offset;
// returns how many (0 past the end)
unsigned char ModuleAPIRead(unsigned long offset, char* dest, unsigned char length) {
  unsigned char n, i;
  if (length > MODULE_SOURCE_CHUNK) length = MODULE_SOURCE_CHUNK;
  view_pos = offset;
  n = (unsigned char)FileViewRead(length);
  for (i = 0; i < n; ++i) dest[i] = buffer[i];
  return n;
}
// TB_STRIDE tile_attrs (STYLE_* << 4 | width) for a text row, drawn as styled text while
// render_text is set (the host sets it and the font)
void ModuleAPIStyle(unsigned char row, const char* styles) {
  unsigned char* dest;
  unsigned char i;
  if (row >= tb_rows) return;
  dest = tile_attrs + (unsigned int)(RowAddress(row) - (char*)tile_buffer);
  for (i = 0; i < TB_STRIDE; ++i) dest[i] = styles[i];
}
// selects columns first to end (exclusive) of a text row and nothing else on the text rows
void ModuleAPISelect(unsigned char row, unsigned char first, unsigned char end) {
  unsigned char i, at;
  for (i = 0; i < tb_rows; ++i) {
    at = (render_text_top + i) << 1;
    render_sel[at] = i == row ? first : 0;
    render_sel[at + 1] = i == row ? end : 0;
  }
}
// TB_COLS tiles of 2bpp (16 bytes each) drawn as they are over a text row, which keeps them
// until it changes; the host calls EditorRedraw after (RenderRawRow)
void ModuleAPITiles(unsigned char row, const unsigned char* tiles) {
  if (row >= tb_rows) return;
  EditorDraw(); // the row's text first, so drawing it later doesn't cover the tiles
  RenderRawRow(render_text_top + row, tiles);
}

// ABI 8: text in the busy box (a line at each '\n', wrapped at 19 characters), if 5 s have passed
// since the module started or last drew (call it often: the rest return at once); 0 for
// the host's own text from the module's context (module_progress). A wide module's BSS is on the
// editor's buffers: it's held in PSRAM while they come back to draw it.
void (*module_progress)(char* text); // RunModule's caller sets it for ModProgress(0)
static void Abort(void) {
  module_aborted = 1;
  ModuleAbort(0);
}
// A copy that fails here stops the module (ModuleAbort): restarting the device instead has left
// the screen frozen on hardware. Also called between the sectors of ModFile and ModLoad's reads.
void ModuleAPIProgress(const char* text) {
  CountFrames();
  if ((unsigned int)(render_frames - progress_at) < PROGRESS_FRAMES) return; // a build that ends soon never draws
  if (text) Marshal(text, 80);
  else if (module_progress) module_progress((char*)buffer); // before the swap: the context may be in the BSS
  else return;
  if (module_wide) {
    if (ModuleSwapRAM(4)) return; // not held: nothing drawn, the module goes on
    if (ModuleSwapRAM(2)) { // the buffers didn't come back: the module's BSS does
      if (ModuleSwapRAM(6)) Abort(); // nor that: the buffers' backup is whole
      return;
    }
    INTERRUPT_ENABLE = module_ie; // drawing waits for VBlank
  }
  OpenBox(BoxText(0, (char*)buffer));
  EditorDraw();
  if (module_wide) {
    INTERRUPT_ENABLE = module_ie & IEF_LCD_ONLY;
    if (ModuleSwapRAM(0)) { // the buffers stay where they are
      buffers_live = 1;
      Abort();
    }
    if (ModuleSwapRAM(6)) Abort(); // never run on state that didn't come back
  }
  progress_at = render_frames;
}

// ABI 10: ModStat (MODULE_STAT_*)
static unsigned int Seconds(unsigned long frames) { // 60 a second: the Game Boy's 59.7 makes it 0.5% slow
  unsigned int seconds = 0;
  for (; frames >= 3600; frames -= 3600) seconds += 60;
  for (; (unsigned int)frames >= 60; frames -= 60) ++seconds;
  return seconds;
}
unsigned long ModuleAPIStat(unsigned char which) {
  CountFrames();
  if (which == MODULE_STAT_SECONDS) return Seconds(module_frames);
  if (which == MODULE_STAT_LOAD_SECONDS) return Seconds(load_frames);
  if (which == MODULE_STAT_FILES) return load_files;
  return module_retries;
}

// ABI 9
// string id (or an S_PART piece) of the loaded language at dest, and a 0; returns the 0's address
char* ModuleAPIString(char* dest, unsigned int id) { return PutStr(dest, id); }
