#ifndef FATPAK_EDITOR_DOCUMENT_H
#define FATPAK_EDITOR_DOCUMENT_H

#include "../constants.h"
#include "../fatfs/file_api.h"

unsigned char CanDiscard(void);
void SetLang(void);
unsigned char FileLanguage(const char* name);
void NewFile(void);
void OpenFile(void);
void CloseFile(void);
void LoadDocument(char* path, unsigned char folder_length, const FileEntry* entry);
void SaveFile(unsigned char ask);
#define NO_PROMPT 0xFFFF
unsigned char AskName(char* value, unsigned int prompt); // the header's prompt string, or NO_PROMPT
extern unsigned char name_row; // browser row edited by AskName(value, 0)

#endif
