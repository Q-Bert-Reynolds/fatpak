// SETTINGS > THEME: THEME.MOD, the theme editor, on a page of its own. The theme in use is in the
// settings block (src/ui/theme.asm), which the swap file keeps; themes are /GBCSYS/THEMES/<name>.json.
// The module reads them itself (module_dir is the card's root), from the list this leaves at
// THEME_LIST_BLOCK. It asks for a save (THEME_SAVE, THEME_SAVE_AS: a name first) by returning, and runs
// again after it.
#include "theme.h"
#include "../app/dialogs.h"
#include "../editor/document.h"
#include "../editor/osk.h"
#include "../editor/settings.h"
#include "../editor/state.h"
#include "../editor/text_buffer.h"
#include "../editor/view.h"
#include "../fatfs/file_api.h"
#include "../fatfs/lib/ff.h"
#include "../modules/runtime.h"
#include "dialogs.h"
#include "render.h"
#include "screen.h"
#include "../ui/text.h"

extern void SetWindowBlock(unsigned int block);
extern unsigned char fs_WriteText(const char* path, unsigned int block, unsigned int bytes); // src/fatfs/fatfs.c
#define WINDOW ((unsigned char*)0xBE00u)
#define SETTINGS_BLOCK ((TB_PSRAM_HIGH << 8) | MAIN_SRAM_BANK)
#define THEME ((unsigned char*)0xBE00u + THEME_OFFSET)
#define FOLDER "/GBCSYS/THEMES"

static const char root[] = ""; // module_dir: the module's paths are from the card's root

// whether name (length chars) ends in .json, any case
static unsigned char IsJson(const char* name, unsigned char length) {
  unsigned char k;
  if (length < 6) return 0;
  name += length - 5;
  for (k = 0; k < 5; ++k) if ((name[k] | 0x20) != ".json"[k]) return 0;
  return 1;
}

// the folder's .json files, their names without .json (up to THEME_NAME_MAX chars): their count, then
// a name every 16 bytes from 16
static void ListThemes(void) {
  FileEntry entry;
  unsigned int i;
  unsigned char n = 0, length, k;
  if (FileList(FOLDER, 0)) fs_count = 0;
  for (i = 0; i < fs_count && n < THEME_LIST_MAX; ++i) {
    if (FileListEntry(i, &entry) || entry.dir) continue;
    for (length = 0; entry.name[length]; ++length);
    if (length > THEME_NAME_MAX + 5 || !IsJson(entry.name, length)) continue;
    entry.name[length - 5] = 0;
    SetWindowBlock(THEME_LIST_BLOCK);
    ++n;
    for (k = 0; k <= length - 5; ++k) WINDOW[(n << 4) + k] = entry.name[k];
    SetWindowBlock(TB_PSRAM_HIGH << 8);
  }
  SetWindowBlock(THEME_LIST_BLOCK);
  WINDOW[0] = n;
  SetWindowBlock(TB_PSRAM_HIGH << 8);
}

// SAVE AS's name (the theme's to start with), into the theme's THEME_NAME; 0 if it's cancelled
static unsigned char AskThemeName(void) {
  char name[FS_NAME_SIZE];
  unsigned char length;
  SetWindowBlock(SETTINGS_BLOCK);
  for (length = 0; length <= THEME_NAME_MAX; ++length) name[length] = (char)THEME[THEME_NAME + length];
  SetWindowBlock(TB_PSRAM_HIGH << 8);
  while (1) {
    if (!AskName(name, S_SAVE_AS)) return 0;
    for (length = 0; name[length]; ++length);
    if (IsJson(name, length)) { // .json typed too
      length -= 5;
      name[length] = 0;
    }
    if (length && length <= THEME_NAME_MAX) break;
    ShowMessage(Str(S_THEME_NAME_LONG));
  }
  SetWindowBlock(SETTINGS_BLOCK);
  for (length = 0; length <= THEME_NAME_MAX; ++length) THEME[THEME_NAME + length] = name[length];
  SetWindowBlock(TB_PSRAM_HIGH << 8);
  return 1;
}

// the module's text at THEME_JSON_BLOCK to /GBCSYS/THEMES/<THEME_NAME>.json; no longer edited after
static void SaveTheme(void) {
  char path[sizeof(FOLDER "/.json") + THEME_NAME_MAX];
  unsigned char i = 0, result;
  unsigned int size;
  const char* p;
  for (p = FOLDER "/"; *p; ++p) path[i++] = *p;
  SetWindowBlock(SETTINGS_BLOCK);
  for (p = (const char*)THEME + THEME_NAME; *p && i < sizeof(path) - 6; ++p) path[i++] = *p;
  size = THEME[THEME_JSON_SIZE] | THEME[THEME_JSON_SIZE + 1] << 8;
  SetWindowBlock(TB_PSRAM_HIGH << 8);
  for (p = ".json"; *p; ++p) path[i++] = *p;
  path[i] = 0;
  ShowBusy(Str(S_SAVING));
  result = FileMount();
  if (!result) {
    f_mkdir(FOLDER); // (FR_EXIST once it's there)
    result = fs_WriteText(path, THEME_JSON_BLOCK, size);
  }
  HideBox();
  if (result) {
    ShowError(result, S_DISK_FULL);
    return;
  }
  SetWindowBlock(SETTINGS_BLOCK);
  THEME[THEME_EDITED] = 0;
  SetWindowBlock(TB_PSRAM_HIGH << 8);
}

void ThemeSetup(void) {
  unsigned char result, status, changed = 0, old_font = font, styled = render_text, old_osk = osk_shown, row;
  font = TEXT_FONT(FONT_VWF);
  SetFont(font);
  render_text = 1; // the module's rows are styled: each entry in its look
  BeginView(1);
  osk_shown = 0;
  for (row = 0; row < tb_rows; ++row) tb_row_states[row] = 0; // no markdown heading fonts
  ListThemes();
  while (1) {
    ShowBusy(Str(S_LOADING)); // the module hides it when it draws
    module_dir = root;
    result = RUN_MODULE(THEME);
    module_dir = 0;
    HideBox();
    if (result) {
      ShowModuleError(result);
      break;
    }
    status = module_status;
    if (status != THEME_DONE) changed = 1;
    if (status < THEME_SAVE) break;
    if (status == THEME_SAVE_AS && !AskThemeName()) continue;
    SaveTheme();
    ListThemes();
  }
  font = old_font;
  SetFont(font);
  render_text = styled;
  osk_shown = old_osk;
  EndFullScreen();
  if (changed) {
    SettingsSave(); // (the theme is after the settings, in their block)
    if (!doc_large) { // the swap file is its copy on SD
      swap_dirty = 0;
      FileSaveSwap();
    }
  }
  bars_changed = 1;
  dirty = 1;
}
