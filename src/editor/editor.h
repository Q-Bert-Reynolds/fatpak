#ifndef EDITOR
#define EDITOR

#include "../constants.h"

// src/input.asm
extern volatile unsigned char button_state;
extern volatile unsigned char last_button_state;
extern unsigned char PadPressed(void); // buttons pressed since the last call, latched in VBlank

// src/keyboard/keyboard.asm
extern unsigned int KBPopEvent(void); // key in low byte (KEY_NONE if empty), modifiers in high byte

// src/editor/editor.asm
extern void EditorSetup(void);
extern void WaitFrame(void); // waits for vblank, updates input
extern void EditorShowCursor(unsigned char show); // uses tb_found_col/row

// src/editor/render.asm
extern unsigned char font_widths[256]; // current font
extern void SetFont(unsigned char font);
extern void EditorDraw(unsigned char split); // rows below split use FONT_MONO (on screen keyboard)
extern void EditorRedraw(void); // redraw every row next EditorDraw
extern unsigned char RenderCursorX(unsigned char col); // x of col in tb_found_row
extern void RenderSetMapRow(unsigned char map_row, unsigned char block);
extern unsigned char render_block_top; // block of screen row 0
extern unsigned char render_pending; // a staged scroll, applied at line 144
extern unsigned char render_pending_scy;
extern unsigned char render_pending_top_mode;
extern unsigned char render_pending_split_count;
extern unsigned char render_pending_splits[4]; // LY, mode

// src/editor/osk.asm
extern void OSKShow(unsigned char show);
extern void OSKDraw(unsigned char layer);
extern void OSKSelect(unsigned char x, unsigned char y);
extern unsigned char OSKGetKey(unsigned char layer, unsigned char index); // 0 = no key

// src/editor/sd.asm
extern unsigned char sd_Detect(void); // 1 on an EverDrive X

// src/fatfs/fatfs.asm (stubs into the FatFs banks)
extern unsigned char FileMount(void); // FRESULT
extern unsigned char FileOpenDir(void); // FRESULT
extern unsigned char FileNext(char* name); // next .TXT name (13 bytes), 0 = no more
extern unsigned char FileLoad(const char* name); // FRESULT, replaces the text buffer
extern unsigned char FileSave(const char* name); // FRESULT
extern unsigned char fs_crlf; // loaded file used CR LF, saving writes CR LF

// src/wram.asm
extern unsigned char tile_buffer[];

// src/editor/text_buffer.asm
extern unsigned char tb_rows; // visible rows
extern unsigned int tb_find;
extern unsigned char tb_found_col;
extern unsigned char tb_found_row;
extern unsigned int tb_bottom;
extern unsigned int tb_row_starts[TB_ROWS + 1]; // rendered rows, then tb_bottom
extern unsigned char tb_row_counts[TB_ROWS]; // characters drawn in each rendered row
extern unsigned char tb_end_row; // rendered row the end of the text is on, 0xFF = not on screen

extern void tb_Load(void);
extern void tb_Clear(void);
extern unsigned int tb_Length(void);
extern unsigned char tb_GetChar(unsigned int pos);
extern unsigned char tb_Insert(unsigned int pos, unsigned char c);
extern unsigned char tb_Delete(unsigned int pos);
extern void tb_Normalize(void);
extern unsigned char tb_NormalizeStep(void); // 1 when the gap is at the end
extern unsigned int tb_RowStart(unsigned int pos);
extern unsigned int tb_NextRow(unsigned int row);
extern void tb_Render(unsigned int top);
extern void tb_RenderRows(unsigned char first, unsigned char end); // from tb_row_starts[first]
extern void tb_ScrollRows(unsigned char down); // shifts tile_buffer and the row tables one row

void Editor(void);

#endif
