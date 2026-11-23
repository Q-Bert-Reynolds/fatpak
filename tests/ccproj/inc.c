// tests/ccproj's C file that start.asm INCLUDEs as _inc.asm (as beisbol's play_ball.asm includes
// _announcer.asm): the card starts with a stale _inc.asm, from an older inc.c that returned 6
#include "lib/defs.h"
int inc_value(void) { return SEVEN; }
