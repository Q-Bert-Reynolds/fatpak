#ifndef FATPAK_EDITOR_OSK_H
#define FATPAK_EDITOR_OSK_H

#include "../constants.h"

unsigned char PadKey(void);
void OpenKeyboard(void);

extern unsigned char osk_blocks[OSK_ROWS]; // blocks the on screen keyboard's rows use
extern unsigned char osk_shown;
extern unsigned char osk_layer;
extern unsigned char osk_x;
extern unsigned char osk_y;
extern unsigned char pad_mods; // modifiers synthesized by PadKey
extern void OSKShow(unsigned char show);
extern void OSKDraw(unsigned char layer, unsigned char first_row); // into tile_buffer rows first_row and on
extern void OSKSelect(unsigned char x, unsigned char y);
extern unsigned char OSKGetKey(unsigned char layer, unsigned char index); // 0 = no key

#endif
