#ifndef FATPAK_APP_LANGUAGE_H
#define FATPAK_APP_LANGUAGE_H
extern unsigned char language; // the setting (src/sram.asm): its column in data/strings/strings.csv, 0 English
unsigned char LoadLanguage(void); // the setting's strings, 1 if its file didn't load (English then)
void LanguageSetup(void); // SETTINGS > LANGUAGE
#endif
