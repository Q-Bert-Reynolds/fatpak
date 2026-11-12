#ifndef FATPAK_BROWSER_HEXVIEW_H
#define FATPAK_BROWSER_HEXVIEW_H
#include "../fatfs/file_api.h"
// shows path in HEXVIEW.MOD if its first sector has a NUL, returns 1 if it did (the browser
// redraws after), 0 for text (nothing drawn)
unsigned char ShowHexView(const char* path, const FileEntry* entry);
#endif
