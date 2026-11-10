#ifndef FATPAK_BROWSER_PATHS_H
#define FATPAK_BROWSER_PATHS_H

#include "../constants.h"

char* ToLatin1(char* dest, const char* text, unsigned char count);
void ToUtf8(char* dest, const char* text);
void PutPath(char* dest, const char* path, unsigned char count);
unsigned char JoinPath(char* dest, const char* dir, const char* name, unsigned char size);
void FileMoved(const char* source, const char* destination);

#endif
