#ifndef FATPAK_UI_TEXT_H
#define FATPAK_UI_TEXT_H

#include "../constants.h"

char* PutText(char* dest, const char* text);
char* PutNumber(char* dest, unsigned long n);
char* PutNumber2(char* dest, unsigned int n);
void CopyName(char* dest, const char* src);

#endif
