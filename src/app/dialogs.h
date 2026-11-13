#ifndef FATPAK_APP_DIALOGS_H
#define FATPAK_APP_DIALOGS_H

#define BACK           0xFE // Choose: B or backspace, CANCEL is start or escape
#define CANCEL         0xFF
#define ITEM_SIZE      14 // menu items

unsigned char Choose(const char* title, const char* items, unsigned char count, unsigned char selected);
void ShowMessage(const char* text);
void ShowBox(const char* text);
extern const char no_yes_items[][ITEM_SIZE];
void ShowError(unsigned char result, const char* denied);

#endif
