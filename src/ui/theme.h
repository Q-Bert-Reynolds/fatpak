#ifndef FATPAK_UI_THEME_H
#define FATPAK_UI_THEME_H
// The editor's colours and looks (src/ui/theme.asm): the theme in use is in the settings block.
extern unsigned char theme; // 1: dark (palette 0's paper darker than its ink), for the DMG's shades
extern void ThemeApply(void); // the theme on screen: looks, palettes, the DMG's shades, the SNES's colours
extern unsigned char ThemeWidth(unsigned char c, unsigned char style); // c's width in style's look (STYLE_* << 4)
extern const unsigned char* raw_palettes; // RenderRawRow's GBC palettes, a tile each (0: its own grey)
void ThemeSetup(void); // SETTINGS > THEME (THEME.MOD)
#endif
