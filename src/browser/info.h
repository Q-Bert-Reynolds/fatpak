#ifndef FATPAK_BROWSER_INFO_H
#define FATPAK_BROWSER_INFO_H
#include "../fatfs/file_api.h"
unsigned char ShowFileInfo(char* path, const FileEntry* entry, char* clipboard); // FILEINFO.MOD: 0, or ACTION_OPEN + a mode (A: VIEW_AUTO)
#endif
