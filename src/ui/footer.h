#ifndef FATPAK_UI_FOOTER_H
#define FATPAK_UI_FOOTER_H

extern char footer_time[8];
extern unsigned char footer_x;
void FooterCompose(char* line);
void FooterDraw(unsigned char row, unsigned char col, const char* text);
void FooterTick(void);
unsigned char FooterPoll(void);

#endif
