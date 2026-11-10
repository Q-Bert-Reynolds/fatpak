#ifndef FATPAK_EDITOR_SETTINGS_H
#define FATPAK_EDITOR_SETTINGS_H

#include "../constants.h"

extern unsigned char SettingsLoad(void); // 0 if they were never saved
extern void SettingsSave(void);

#endif
