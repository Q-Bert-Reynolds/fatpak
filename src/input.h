#ifndef FATPAK_INPUT_H
#define FATPAK_INPUT_H

#include "constants.h"

#include "pad.h"

unsigned char DpadRepeat(unsigned char pressed);
unsigned char MenuKey(void);

extern unsigned char pad_timer;
extern volatile unsigned char button_state;
extern volatile unsigned char last_button_state;
extern unsigned char PadPressed(void); // buttons pressed since the last call, latched in VBlank

#endif
