#ifndef FATPAK_BROWSER_VIEWER_H
#define FATPAK_BROWSER_VIEWER_H
#include "../fatfs/file_api.h"
// shows path read only if it's a .tiles file (TILEVIEW.MOD) or binary, a NUL in its first sector
// (HEXVIEW.MOD); returns 1 if it did (the browser lists its folder again after), 0 to open it as text
unsigned char ShowFileView(const char* path, const FileEntry* entry);
#endif
