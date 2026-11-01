#ifndef FATFS_H
#define FATFS_H

#include "lib/ff.h"
#include "file_api.h"

unsigned char fs_Mount(void);
unsigned char fs_OpenDir(const char* path);
unsigned char fs_NextEntry(FileEntry* entry);
unsigned char fs_Load(const char* path);
unsigned char fs_Save(const char* path);

#endif
