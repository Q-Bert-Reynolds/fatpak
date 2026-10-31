#ifndef FATFS_H
#define FATFS_H

#include "lib/ff.h"

unsigned char fs_Mount(void);
unsigned char fs_OpenDir(void);
unsigned char fs_NextFile(char* name);
unsigned char fs_Load(const char* name);
unsigned char fs_Save(const char* name);

#endif
