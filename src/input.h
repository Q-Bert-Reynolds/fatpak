#ifndef FATPAK_INPUT_H
#define FATPAK_INPUT_H

#include "constants.h"

#define PADF_DPAD   0xF0
#define PADF_A      0x01
#define PADF_B      0x02
#define PADF_SELECT 0x04
#define PADF_START  0x08
#define PADF_RIGHT  0x10
#define PADF_LEFT   0x20
#define PADF_UP     0x40
#define PADF_DOWN   0x80

unsigned char DpadRepeat(unsigned char pressed);
unsigned char MenuKey(void);

extern unsigned char pad_timer;
extern volatile unsigned char button_state;
extern volatile unsigned char last_button_state;
extern unsigned char PadPressed(void); // buttons pressed since the last call, latched in VBlank

#endif
