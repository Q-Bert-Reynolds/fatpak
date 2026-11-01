#ifndef FILE_API_H
#define FILE_API_H

// shared by src/fatfs/fatfs.c and the editor, which calls it through the stubs in src/fatfs/fatfs.asm

#define FS_NAME_SIZE 65 // UTF-8 name and 0, FF_LFN_BUF + 1

typedef struct {
  char name[FS_NAME_SIZE];
  unsigned long size;
  unsigned int date; // FAT date and time
  unsigned int time;
  unsigned char dir;
} FileEntry;

#endif
