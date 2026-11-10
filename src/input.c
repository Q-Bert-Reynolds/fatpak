// Shared joypad repeat and keyboard/joypad menu input.
#include "input.h"
#include "keyboard/keyboard.h"
#include "ui/screen.h"

unsigned char pad_timer;

// returns held d-pad buttons when pressed and while repeating
unsigned char DpadRepeat(unsigned char pressed) {
  unsigned char held = (button_state | pressed) & PADF_DPAD;
  if (!held) return 0;
  if (pressed & PADF_DPAD) pad_timer = PAD_REPEAT_DELAY;
  else if (--pad_timer) return 0;
  else pad_timer = PAD_REPEAT_RATE;
  return held;
}

// waits a frame, returns a key from the keyboard or d-pad (A = enter, B = backspace, START = menu,
// which closes menus)
unsigned char MenuKey(void) {
  unsigned char key, pressed, held;
  WaitFrame();
  if ((key = (unsigned char)KBPopEvent())) return key;
  pressed = PadPressed();
  if (pressed & PADF_A) return KEY_ENTER;
  if (pressed & PADF_B) return KEY_BACKSPACE;
  if (pressed & PADF_START) return KEY_MENU;
  held = DpadRepeat(pressed);
  if (held & PADF_UP) return KEY_UP;
  if (held & PADF_DOWN) return KEY_DOWN;
  if (held & PADF_LEFT) return KEY_LEFT;
  if (held & PADF_RIGHT) return KEY_RIGHT;
  return KEY_NONE;
}
