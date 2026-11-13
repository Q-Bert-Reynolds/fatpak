#ifndef FATPAK_UI_TEXT_H
#define FATPAK_UI_TEXT_H

#include "../constants.h"

char* PutText(char* dest, const char* text);
char* PutNumber(char* dest, unsigned long n);
char* PutNumber2(char* dest, unsigned int n);
void CopyName(char* dest, const char* src);
// the UI's strings in the loaded language (src/strings.asm, notes/LANGUAGES.md)
#include "../strings.h"
char* PutStr(char* dest, unsigned int id); // the string (or S_PART piece) and a 0, returns the 0's address
const char* Str(unsigned int id); // in a buffer shared by every call: use it before the next
extern unsigned int lang_count; // strings loaded, 0 if none

#endif
