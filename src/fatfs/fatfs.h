#ifndef FATFS_H
#define FATFS_H

#include "lib/ff.h"
#include "file_api.h"

unsigned char fs_Mount(void);
unsigned char fs_List(const char* path, const char* find);
unsigned char fs_ListEntry(unsigned int index, FileEntry* entry);
unsigned char fs_Load(const char* path);
unsigned char fs_Save(const char* path);
#ifdef EVERDRIVE_OS
unsigned char fs_LoadData(const char* path);
#endif

#endif
