#ifndef FATPAK_EDITOR_DOCUMENT_H
#define FATPAK_EDITOR_DOCUMENT_H

#include "../constants.h"
#include "../fatfs/file_api.h"

unsigned char CanDiscard(void);
void SetLang(void);
void NewFile(void);
void OpenFile(void);
void LoadDocument(char* path, unsigned char folder_length, const FileEntry* entry);
void SaveFile(unsigned char ask);
unsigned char AskName(char* value, const char* prompt);

#endif
