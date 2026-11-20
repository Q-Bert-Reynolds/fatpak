#ifndef FATPAK_BROWSER_VIEWER_H
#define FATPAK_BROWSER_VIEWER_H
#include "../fatfs/file_api.h"
#define VIEW_AUTO  0 // ShowFileView's modes: by the file (OPEN), or FILE > OPEN AS's choice
#define VIEW_TEXT  1
#define VIEW_HEX   2
#define VIEW_TILES 3
// shows path read only if it's a .tiles, .tile or .2bpp file (TILEVIEW.MOD), a .gbmap (MAPVIEW.MOD) or binary, a NUL in its first sector
// (HEXVIEW.MOD), or as mode says; returns 1 if it did and closed (the browser lists its folder again
// after), 0 to open it as text (VIEW_TEXT, or an empty file), or ACTION_OPEN + a mode from its menu's
// OPEN AS or INFO. Start in a viewer is BrowserMenu's (MENU_VIEWER, MENU_MAP), and the viewer goes on
// where it was after
unsigned char ShowFileView(char* path, const FileEntry* entry, unsigned char mode, char* clipboard);

#define ACTION_RENAME  1 // BrowserMenu's results besides 0 (a viewer's: go on)
#define ACTION_OPEN    2 // + a VIEW_* mode
#define ACTION_CLOSE   6 // a viewer's CLOSE
#define ACTION_REBUILD 7 // the map's FILE > REBUILD
#define MENU_BROWSER 0 // BrowserMenu's modes: the browser's Start menu
#define MENU_INFO_KEY 1 // its Select: FILE > INFO at once
#define MENU_VIEWER 2 // a viewer's Start: FILE (OPEN AS, INFO), EDIT (COPY), SETTINGS, HELP, CLOSE
#define MENU_INFO 3 // the info page's (its INFO goes on)
#define MENU_MAP 4 // the map viewer's: REBUILD too, and RESOLUTION's 512x448
// path the folder (the viewed file is the browser's entry), clipboard the browser's (EDIT)
unsigned char BrowserMenu(char* path, char* clipboard, unsigned char mode);
#endif
