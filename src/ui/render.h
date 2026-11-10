#ifndef FATPAK_UI_RENDER_H
#define FATPAK_UI_RENDER_H

#include "../constants.h"

extern unsigned char font_widths[256]; // current font
extern unsigned char HeadingCharWidth(unsigned char level, unsigned char c); // width in heading 1-4's font
extern void SetFont(unsigned char font);
extern void EditorDraw(void); // draws screen rows whose characters, font or selection changed
extern void EditorRedraw(void); // redraw every row next EditorDraw
extern unsigned char RenderCursorX(unsigned char col); // x of col in tb_found_row
extern void RenderSetMapRow(unsigned char map_row, unsigned char block);
extern unsigned char block_map_rows[]; // map row each block was last set to (RenderSetMapRow)
extern unsigned char render_row_blocks[TB_ROWS]; // block each screen row draws into
extern unsigned char render_row_lines[TB_ROWS]; // tile_buffer row each screen row shows
extern unsigned char render_row_fonts[TB_ROWS]; // font each screen row uses
extern unsigned char render_text_top; // screen row of text row 0
extern unsigned char render_text; // 1 = text rows are styled (tile_attrs), 0 while the browser or help draw their own rows
extern unsigned char render_gbc; // 1 on GBC: the text ring has a spare block and scrolls smoothly
extern unsigned char render_box_top; // menu box over the text: screen row, 0xFF = none
extern unsigned char render_box_rows;
extern unsigned char render_box_x; // pixels
extern unsigned char render_box_w;
extern unsigned char render_box_sel; // highlighted line
extern unsigned char render_box_gen; // change for each new box
extern char* render_box_text; // BOX_STRIDE chars per line
extern unsigned char RenderTextWidth(const char* text); // in the variable width font
extern unsigned char render_pending; // a staged scroll, applied at line 144
extern unsigned char render_pending_scy;
extern void RenderStage(void); // stages LCDC changes (tile data mode, window) for the layout, sets render_pending
extern unsigned char render_sel[TB_ROWS * 2]; // selected columns of each row (first, end), end 0xFF = right edge
extern unsigned char render_cpu_copy; // loading UI uses CPU tile copies instead of CGB HDMA
extern unsigned char tile_buffer[];
extern unsigned char tile_attrs[]; // style of each char in tile_buffer's text rows: STYLE_* bits and its width

#endif
