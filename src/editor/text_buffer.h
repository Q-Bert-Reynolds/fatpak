#ifndef FATPAK_EDITOR_TEXT_BUFFER_H
#define FATPAK_EDITOR_TEXT_BUFFER_H

#include "../constants.h"

extern unsigned int tb_row_states[TB_ROWS + 1]; // lexer state at the start of each rendered row
extern unsigned char tb_lang; // LANG_*, how text is styled
extern unsigned char tb_rows; // visible rows
extern unsigned int tb_find;
extern unsigned char tb_found_col;
extern unsigned char tb_found_row;
extern unsigned int tb_bottom;
extern unsigned int tb_row_starts[TB_ROWS + 1]; // rendered rows, then tb_bottom
extern unsigned char tb_row_counts[TB_ROWS]; // characters drawn in each rendered row
extern unsigned char tb_end_row; // rendered row the end of the text is on, 0xFF = not on screen
extern unsigned char tb_nowrap; // rows are whole lines, scrolled sideways
extern unsigned int tb_left; // characters of each line left of the screen when tb_nowrap is set
extern void tb_Load(void);
extern void tb_Clear(void);
extern unsigned int tb_Length(void);
extern unsigned char tb_GetChar(unsigned int pos);
extern unsigned char tb_Insert(unsigned int pos, unsigned char c);
extern unsigned char tb_Delete(unsigned int pos);
extern void tb_DeleteRange(unsigned int pos, unsigned int count);
extern unsigned char tb_Copy(unsigned int pos, unsigned int count); // to the clipboard, 0 if it's too big
extern unsigned char tb_Paste(unsigned int pos); // 0 if it doesn't fit
extern unsigned int tb_ClipLength(void);
extern void tb_ResetChecks(void); // forgets the comment and code block checkpoints (the language changed)
extern unsigned int tb_CountLines(unsigned int start, unsigned int end); // line feeds in [start, end)
extern unsigned int tb_LineStart(unsigned int pos); // after the line feed before pos
extern unsigned int tb_RowStart(unsigned int pos);
extern unsigned int tb_NextRow(unsigned int row);
extern void tb_Render(unsigned int top);
extern void tb_RenderRows(unsigned char first, unsigned char end); // from tb_row_starts[first]
extern void tb_ScrollRows(unsigned char down); // shifts tile_buffer and the row tables one row

#endif
