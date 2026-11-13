#ifndef FATPAK_BROWSER_INFO_H
#define FATPAK_BROWSER_INFO_H
#include "../fatfs/file_api.h"
unsigned char ShowFileInfo(const char* path, const FileEntry* entry); // FILEINFO.MOD, 1 if A opens it
#endif
