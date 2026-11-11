#ifndef FATPAK_UI_THEME_H
#define FATPAK_UI_THEME_H
// The editor's colours (src/ui/theme.asm). theme is a setting (SettingsTable).
#define THEME_LIGHT 0
#define THEME_DARK  1
extern unsigned char theme;
extern void ThemeApply(void); // palettes for theme: DMG shades inverted, GBC/SGB colours swapped
void ThemeSetup(void); // SETTINGS > THEME (THEME.MOD)
#endif
