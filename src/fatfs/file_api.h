#ifndef FATPAK_FATFS_FILE_API_H
#define FATPAK_FATFS_FILE_API_H

#include "../constants.h"

#define FS_NAME_SIZE 65 // UTF-8 name and 0, FF_LFN_BUF + 1

typedef struct {
  char name[FS_NAME_SIZE];
  unsigned long size;
  unsigned int date; // FAT date and time
  unsigned int time;
  unsigned int cdate, ctime, adate; // created date/time; FAT access date has no time
  unsigned char dir;
} FileEntry;

// Inspection uses its own file handle; it preserves an open editor document.
typedef struct {
  unsigned long words, lines;
  unsigned char header[28]; // cartridge bytes $134..$14F
  unsigned char game; // input: read cartridge header instead of counting text
  unsigned char status; // 0: unavailable/skipped, 1: complete/valid, 2: binary/bad checksum
} FileDetails;
extern unsigned char FileInspect(const char* path, FileDetails* details);

// Save browser/editor location independently of the editor's delayed text swap.
// mode 0: browser folder; 1: editor; 255: restore at startup.
extern unsigned char FileSession(const char* folder, unsigned char mode);
extern unsigned char session_open;

extern unsigned char FileMount(void); // FRESULT, mounts the card if it isn't
extern unsigned char FileRename(const char* source, const char* destination);
extern unsigned char FileRenameName(const char* source, const char* name);
extern unsigned char FileCopy(const char* source, const char* destination); // includes folder contents; never overwrites
extern unsigned char FileList(const char* path, const char* find); // FRESULT, UTF-8 path, "" = root
extern unsigned char FileListEntry(unsigned int index, FileEntry* entry); // FRESULT, folders first
extern unsigned int fs_count; // entries FileList found
extern unsigned int fs_found; // index of the folder it was asked to find, 0xFFFF if it isn't there
extern unsigned char FileLoad(const char* path); // FRESULT, replaces the text buffer
extern unsigned char FileSave(const char* path); // FRESULT
extern unsigned char FileLoadData(const char* path); // FRESULT, copies the data file to PSRAM
extern unsigned char FileSaveSwap(void); // FRESULT, the text, clipboard and settings
extern unsigned char FileLoadSwap(void); // FRESULT, restores them if PSRAM lost them
extern unsigned char FileWriteImage(const char* path, unsigned int blocks); // FRESULT, the assembled ROM (ASM_IMAGE_BLOCK, 512-byte blocks) to a file
extern unsigned int FileReadFile(const char* path, unsigned int block); // the whole file into PSRAM from block; its length, 0 if it can't be read, 0xFFFF if 64 KiB or more
// HEXVIEW.MOD's file, read only in save_file (nothing else uses it while a module runs)
extern unsigned char FileViewOpen(const char* path); // FRESULT, sets view_size
extern unsigned int FileViewRead(unsigned int count); // up to 512 bytes from view_pos into the FatFs buffer; how many, 0 at the end or on an error
extern void FileViewClose(void);
extern unsigned long view_size, view_pos;
extern unsigned char swap_dirty; // they changed since FileSaveSwap
extern unsigned char FileLoadLarge(const char* path); // FRESULT, opens a file too big for the text buffer, loads the window at its start
extern unsigned char FileLoadWindow(void); // FRESULT, the text buffer is the file from win_start (see src/fatfs/fatfs.c)
extern void FileCloseLarge(void);
extern void DocLineStart(void); // moves doc_pos (a file offset) to its line's start, doc_back = window positions it moved
extern unsigned char FileScanStep(void); // counts a sector's line feeds toward scan_target, 1 when done
extern unsigned char FileCommitWindow(void); // an edited window goes into the document, 0 if it's full
extern unsigned char FileSaveLarge(const char* path); // FRESULT, saves the document (FR_DENIED: it or the card is full)
extern unsigned char FileBackupSave(void); // FRESULT, writes the last launched game's save RAM to its .srm
extern unsigned char backup_skipped; // it didn't: the EverDrive OS launched a game since
extern unsigned char FileGameOpen(const char* path); // FRESULT, checks a game (src/fatfs/fatfs.c)
extern unsigned char FileGameCopy(void); // FRESULT, copies the next part of it to PSRAM
extern unsigned char FileGameFinish(const char* path); // FRESULT, loads its save
extern unsigned int game_block, game_blocks; // FileGameCopy's progress (sectors)
extern unsigned char doc_large; // a large file is open, the text buffer is a window into it
extern unsigned char lines_known, win_chunks;
extern unsigned long doc_len, doc_pos, win_start, win_end, win_mark, win_lines, scan_pos, scan_target, scan_lines;
extern unsigned int doc_back, win_mark_pos, win_kept[];
extern unsigned char fs_crlf; // loaded file used CR LF, saving writes CR LF

#endif
