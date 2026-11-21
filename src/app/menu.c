// Application menus and global keyboard shortcuts.
#include "menu.h"
#include "dialogs.h"
#include "language.h"
#include "../editor/build.h"
#include "../editor/document.h"
#include "../editor/text_buffer.h"
#include "../ui/screen.h"
#include "../editor/editor.h"
#include "../editor/help.h"
#include "../editor/state.h"
#include "../editor/view.h"
#include "../keyboard/test.h"
#include "../modules/runtime.h"
#include "../rtc/menu.h"
#include "../ui/dialogs.h"
#include "../ui/text.h"
#include "../ui/theme.h"
#include "../sgb/client.h"
#include "../editor/settings.h"

// FILE and EDIT's items: the strings from S_SUB_OPEN (SETTINGS: the editor's 6 from S_SUB_LINE_WRAP,
// the browser's and viewers' 5 from S_SUB_FULL_SCREEN; an SGB adds RESOLUTION to each)
static const unsigned char submenu_starts[] = {0, 6, 12};

// SETTINGS > RESOLUTION (an SGB's): its BIOS's 160x144, the fullscreen 256x224 and 512x448 (maps, and the
// text in characters whatever the font). Saved; from the BIOS's, 256x224 and 512x448 take over now; from
// fullscreen, 160x144 hands the SNES back to the BIOS (SGBLeave) if the kernel saved it, else it waits for
// the next boot. Returns BACK, CANCEL or what was chosen
static unsigned char ResolutionMenu(void) {
  unsigned char item = Choose(0, S_RES_160, 3, resolution == RESOLUTION_160 ? 0 : resolution == RESOLUTION_256 ? 1 : 2);
  if (item >= BACK) return item;
  resolution = item == 1 ? RESOLUTION_256 : item ? RESOLUTION_512 : RESOLUTION_160; // (the strings' order)
  SettingsSave();
  SGBBegin(); // (only in the BIOS's, not at 160x144)
  if (resolution == RESOLUTION_160) SGBLeave(); // (only in fullscreen)
  return item;
}

// SETTINGS > FONT: standard (proportional text, 4 px code) or 8x8 tiles (the mono font); saved. The
// editor's rows are laid out again in it (the browser sets its font after the menu)
static unsigned char FontMenu(unsigned char browser) {
  unsigned char item = Choose(0, S_FONT_STANDARD, 2, font_tiles);
  if (item >= BACK) return item;
  font_tiles = item;
  SettingsSave();
  if (!browser) {
    tb_lang = 0xFF; // (SetLang lays out only a changed language)
    SetLang();
  }
  return item;
}

// Shared by the editor (0), the browser and the viewers (1, the map viewer 2); B returns to their
// enclosing menu.
unsigned char PreferencesMenu(unsigned char browser) {
  unsigned char i, item = Choose(0, browser ? S_SUB_FULL_SCREEN : S_SUB_LINE_WRAP,
    (browser ? 6 : 7) + (sys_info & SYS_INFO_SGB), 0);
  if (item >= BACK) return item;
  if (browser) ++item; // FULL SCREEN, THEME, LANGUAGE, CLOCK, KEYBOARD, FONT
  if (!item) ToggleWrap();
  else if (item == 1) {
    if (!browser) ToggleBars();
    else { // the browser keeps its bars; a viewer has its own (the editor's are laid out when it's back)
      bars_on ^= 1;
      SettingsSave();
    }
  }
  else if (item >= 6) {
    i = sys_info;
    item = item == 6 ? FontMenu(browser) : ResolutionMenu();
    if ((SGBCells() || ((i ^ sys_info) & SYS_INFO_SGBFS)) && !browser) { // 512x448 text on or off, or the GB's screen again (160x144):
      // the editor's rows again (the browser lays out its own)
      tb_lang = 0xFF;
      SetLang();
      SetRows();
    }
    return item;
  }
  else {
    ModuleAPIBackground(0, 0); // a viewer's map: the text back for a whole screen
    if (item == 2) ThemeSetup();
    else if (item == 3) LanguageSetup();
    else if (item == 4) ClockSetup();
    else {
      module_status = 0;
      KeyboardSetup(1);
      if (module_status == 2) KeyboardTest(); // TEST selected in the keyboard submenu
    }
  }
  return item;
}

static void FileMenu(void) {
  unsigned char menu = 0, item;
  while (1) {
    if ((menu = Choose(0, S_MENU_FILE, 5, menu)) >= BACK) return;
    if (menu == 4) {
      CloseFile();
      return;
    }
    if (menu == 3) { ShowHelp(); return; }
    if (menu == 2) {
      if (PreferencesMenu(0) == BACK) continue;
      return;
    }
    item = submenu_starts[menu];
    if ((item = Choose(0, S_SUB_OPEN + item, submenu_starts[menu + 1] - item, 0)) == CANCEL) return;
    if (item != BACK) break;
  }
  switch ((menu << 3) | item) {
    case 0: OpenFile(); break;
    case 1: SaveFile(0); break;
    case 2: SaveFile(1); break;
    case 3: NewFile(); break;
    case 4: BuildFile(0); break;
    case 5: BuildFile(1); break;
    case 8: UndoRedo(0); break;
    case 9: UndoRedo(1); break;
    case 10: Cut(); break;
    case 11: Copy(); break;
    case 12: Paste(); break;
    case 13: SelectAll(); break;
  }
}

// shortcuts: escape or the keyboard's menu key, F1, F5 run, F7 build, F11, alt + Z, ctrl + O, S, N
unsigned char HandleFileKey(unsigned char key, unsigned char mods) {
  if (key == KEY_MENU || key == KEY_ESCAPE) FileMenu();
  else if (key == KEY_F1) ShowHelp();
  else if (key == KEY_F5) BuildFile(1);
  else if (key == KEY_F7) BuildFile(0);
  else if (key == KEY_F11) ToggleBars();
  else if ((mods & KB_MOD_ALT) && (key == 'z' || key == 'Z')) ToggleWrap();
  else if (!(mods & KB_MOD_CTRL)) return 0;
  else if (key == 'o' || key == 'O') OpenFile();
  else if (key == 's' || key == 'S') SaveFile(0);
  else if (key == 'n' || key == 'N') NewFile();
  else return 0;
  dirty = 1;
  return 1;
}
