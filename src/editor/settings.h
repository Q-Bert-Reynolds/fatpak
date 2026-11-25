#ifndef FATPAK_EDITOR_SETTINGS_H
#define FATPAK_EDITOR_SETTINGS_H

#include "../constants.h"

extern void SettingsSaveSwap(void); // the swap file now if anything is dirty (src/sram.asm)
extern unsigned char SettingsLoad(void); // 0 if they were never saved
extern void SettingsSave(void);
extern unsigned char show_hidden; // SETTINGS > HIDDEN FILES: 1 lists dotfiles and hidden files

#endif
