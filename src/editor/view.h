#ifndef FATPAK_EDITOR_VIEW_H
#define FATPAK_EDITOR_VIEW_H

#include "../constants.h"

unsigned int LineEnd(unsigned char row);
unsigned char PlaceCursor(void);
unsigned int PosAtX(unsigned char row, unsigned char x);
void ScrollDown(void);
void ScrollUp(unsigned int new_top);
void RenderAfterEdit(void);
void CountEdit(unsigned int pos, unsigned char c, unsigned char inserted);
void Uncount(unsigned int pos);
void UpdateBars(void);
void Draw(void);
void SetRows(void);
void ToggleBars(void);
void BeginFullScreen(void);
void EndFullScreen(void);
void Render(void);
void Refresh(void);

#endif
