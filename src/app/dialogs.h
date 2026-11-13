#ifndef FATPAK_APP_DIALOGS_H
#define FATPAK_APP_DIALOGS_H

#define BACK           0xFE // Choose: B or backspace, CANCEL is start or escape
#define CANCEL         0xFF

// a menu of count strings from first (S_* ids, consecutive in data/strings/strings.csv), under title if it isn't 0
unsigned char Choose(const char* title, unsigned int first, unsigned char count, unsigned char selected);
void ShowMessage(const char* text);
void ShowBox(const char* text);
void ShowError(unsigned char result, unsigned int denied); // an FRESULT's message, string denied for FR_DENIED

#endif
