#ifndef FATPAK_UI_DIALOGS_H
#define FATPAK_UI_DIALOGS_H

#include "../constants.h"

#define BOX_PADDING      9 // 4 pixels each side of the text, and the border
#define BOX_LINE         (TB_ROWS + 2) // menu box text in tile_buffer rows from here, BOX_STRIDE chars per line

void WaitDismiss(void);
void OpenBox(unsigned char lines);
void ShowBusy(const char* text);
void HideBox(void);

#endif
