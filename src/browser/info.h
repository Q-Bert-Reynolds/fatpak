#ifndef FATPAK_BROWSER_INFO_H
#define FATPAK_BROWSER_INFO_H
#include "../fatfs/file_api.h"
void ShowFileInfo(const char* path, const FileEntry* entry);
char* PutSize(char* dest, unsigned long size);
#endif
