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
extern void EditorDraw(void); // copies tile_buffer to the screen
extern void EditorShowCursor(unsigned char show); // uses tb_found_col/row

// src/editor/osk.asm
extern void OSKShow(unsigned char show);
extern void OSKDraw(unsigned char layer);
extern void OSKSelect(unsigned char x, unsigned char y);
extern unsigned char OSKGetKey(unsigned char layer, unsigned char index); // 0 = no key

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

extern void tb_Load(void);
extern void tb_Clear(void);
extern unsigned int tb_Length(void);
extern unsigned char tb_GetChar(unsigned int pos);
extern unsigned char tb_Insert(unsigned int pos, unsigned char c);
extern unsigned char tb_Delete(unsigned int pos);
extern void tb_Normalize(void);
extern unsigned int tb_RowStart(unsigned int pos);
extern unsigned int tb_NextRow(unsigned int row);
extern void tb_Render(unsigned int top);

void Editor(void);

#endif
