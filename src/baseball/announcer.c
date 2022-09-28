// src/baseball/announcer.c
#include "../../data/strings/announcer_strings.h"

extern void RevealTextAndWait(char drawFlags, char buffer[]);// _RevealTextAndWait in src/ui.asm

void announceSomething() {
    RevealTextAndWait(1, BallText);
}