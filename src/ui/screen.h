#ifndef FATPAK_UI_SCREEN_H
#define FATPAK_UI_SCREEN_H

#include "geometry.h"

#define WIN_MAP_ROWS     (OSK_ROWS + 2)
#define STATUS_BLOCK     17
#define HEADER_BLOCK     8 // the bars' blocks work in either tile data mode (see src/ui/render.asm)
#define BG_MAP_ROWS      32

void Layout(void);
void ScrollRing(unsigned char down);
void ScrollRows(unsigned char down); // rotate the display and retain the rows already drawn
void NoHighlight(void);
char* RowAddress(unsigned char row);
void DrawRow(unsigned char row, unsigned char col, const char* text);
void ClearScreen(void);

extern unsigned char ring_top; // BG map row of text row 0
extern unsigned char ring_pos; // index in ring_blocks of text row 0's block
extern unsigned char ring_blocks[MAX_SCREEN_ROWS + 1]; // blocks text rows use
extern unsigned char map_blocks[BG_MAP_ROWS + WIN_MAP_ROWS]; // block each BG map row, then window map row, shows, 0xFF = none
extern unsigned char bars; // bars are shown now (not in menus)
extern unsigned char font;
extern unsigned char font_tiles; // SETTINGS > FONT: 8x8 tiles, the mono font for documents and the browser
#define TEXT_FONT(f) (font_tiles ? FONT_MONO : (f)) // the font the setting gives for f
extern void WaitFrame(void); // waits for vblank, updates input
extern unsigned char data_loaded; // the styled fonts and SGB border are in PSRAM
extern void SGBSetDefaultBorder(void);

#endif
