// Application menus and global keyboard shortcuts.
#include "menu.h"
#include "dialogs.h"
#include "../editor/document.h"
#include "../editor/editor.h"
#include "../editor/help.h"
#include "../editor/state.h"
#include "../editor/view.h"
#include "../keyboard/test.h"
#include "../rtc/menu.h"
#include "../ui/dialogs.h"

static const char menu_items[][ITEM_SIZE] = {"FILE", "EDIT", "SETTINGS", "HELP", "CLOSE"};
static const char submenu_items[][ITEM_SIZE] = { // FILE, EDIT, SETTINGS
  "OPEN", "SAVE", "SAVE AS", "NEW",
  "UNDO", "REDO", "CUT", "COPY", "PASTE", "SELECT ALL",
  "LINE WRAP", "FULL SCREEN", "CLOCK", "KEYBOARD TEST"};
static const unsigned char submenu_starts[] = {0, 4, 10};

// Shared by the editor and browser; B returns to their enclosing menu.
unsigned char PreferencesMenu(unsigned char browser) {
  unsigned char item = Choose(0, submenu_items[browser ? 12 : 10], 2, 0);
  if (item >= BACK) return item;
  if (browser) {
    if (item) KeyboardTest(); else ClockSetup();
  }
  else if (!item) ToggleWrap();
  else ToggleBars();
  return item;
}

static void FileMenu(void) {
  unsigned char menu = 0, item;
  while (1) {
    if ((menu = Choose(0, menu_items[0], 5, menu)) >= BACK) return;
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
    if ((item = Choose(0, submenu_items[item], submenu_starts[menu + 1] - item, 0)) == CANCEL) return;
    if (item != BACK) break;
  }
  switch ((menu << 3) | item) {
    case 0: OpenFile(); break;
    case 1: SaveFile(0); break;
    case 2: SaveFile(1); break;
    case 3: NewFile(); break;
    case 8: UndoRedo(0); break;
    case 9: UndoRedo(1); break;
    case 10: Cut(); break;
    case 11: Copy(); break;
    case 12: Paste(); break;
    case 13: SelectAll(); break;
  }
}

// shortcuts: escape or the keyboard's menu key, F1, F11, alt + Z, ctrl + O, S, N
unsigned char HandleFileKey(unsigned char key, unsigned char mods) {
  if (key == KEY_MENU || key == KEY_ESCAPE) FileMenu();
  else if (key == KEY_F1) ShowHelp();
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
