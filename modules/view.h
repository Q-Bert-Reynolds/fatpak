#ifndef FATPAK_MODULE_VIEW_H
#define FATPAK_MODULE_VIEW_H
// The read only viewers' (HEXVIEW, TILEVIEW, MAPVIEW, FILEINFO) Start: the module returns VIEW_MENU,
// the host shows its menu (FILE, EDIT, SETTINGS, HELP, CLOSE: src/browser/browser.c's BrowserMenu) and,
// unless that closed it, runs the module again to go on where it was
#define VIEW_MENU 0xFE // ModuleMain's result (module_status)

// HEXVIEW's and TILEVIEW's context (src/browser/viewer.c's ShowFileView): the file's size; where the
// view is, kept across the menu (0 the first time)
typedef struct {
  unsigned long size;
  unsigned long top, cursor; // HEXVIEW's byte offsets; TILEVIEW's first tile on the sheet and the selected one
} ViewContext;
#endif
