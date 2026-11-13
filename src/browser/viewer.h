#ifndef FATPAK_BROWSER_VIEWER_H
#define FATPAK_BROWSER_VIEWER_H
#include "../fatfs/file_api.h"
#define VIEW_AUTO  0 // ShowFileView's modes: by the file (OPEN), or FILE > OPEN AS's choice
#define VIEW_TEXT  1
#define VIEW_HEX   2
#define VIEW_TILES 3
// shows path read only if it's a .tiles file (TILEVIEW.MOD) or binary, a NUL in its first sector
// (HEXVIEW.MOD), or as mode says; returns 1 if it did (the browser lists its folder again after), 0 to
// open it as text (VIEW_TEXT, or an empty file)
unsigned char ShowFileView(const char* path, const FileEntry* entry, unsigned char mode);
#endif
