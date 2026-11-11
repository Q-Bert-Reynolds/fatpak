#ifndef FATPAK_MODULE_INFO_H
#define FATPAK_MODULE_INFO_H
// FILEINFO.MOD's input, filled by ShowFileInfo (src/browser/info.c) in host WRAM.
// The module and the OS are built together, so they share FatPak's types.
#include "../src/fatfs/file_api.h"
typedef struct {
  const FileEntry* entry;
  const FileDetails* details;
  unsigned char language; // FileLanguage: 0 plain, 1 markdown, 2 C, 3 assembly
  unsigned char result; // FileInspect's FRESULT, 0 for folders
} InfoContext;
#endif
