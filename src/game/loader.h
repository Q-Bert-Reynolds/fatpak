#ifndef FATPAK_GAME_LOADER_H
#define FATPAK_GAME_LOADER_H

#include "../constants.h"

unsigned char IsGame(const char* name);
void LaunchGame(const char* path);

extern void InGameHeader(const char* name); // prepares the in-game filename bar
extern void InGameLanguage(void); // and the menu's labels, error line and footer in the language
extern void GameLoadingBegin(void); // holds browser/box with only LCD interrupts, no DMA
extern void GameLoadingEnd(void); // restores sprites, interrupts and HDMA after an error
extern void GameLaunch(void); // resets the Game Boy into it
extern void Reboot(void); // starts the OS again
extern void RestartDevice(void); // cartridge reset through the boot ROM

#endif
