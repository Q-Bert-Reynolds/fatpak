#ifndef EDITOR
#define EDITOR

#include "../constants.h"
#include "../fatfs/file_api.h"

// src/input.asm
extern volatile unsigned char button_state;
extern volatile unsigned char last_button_state;
extern unsigned char PadPressed(void); // buttons pressed since the last call, latched in VBlank

// src/keyboard/keyboard.asm
extern unsigned char KBPeekKey(void); // next event's key without popping it (KEY_NONE if empty)
extern unsigned int KBPopEvent(void); // key in low byte (KEY_NONE if empty), modifiers in high byte
extern void KBListen(void); // listen for a PS/2 keyboard even if none was found at boot
extern unsigned char kb_type; // KB_TYPE_* in src/keyboard/keyboard.asm: 0 none, 1 PS/2, 2 iGKB
extern unsigned char kb_scan_code_buffer[64]; // the PS/2 interrupt's last scan codes (KB_SCAN_CODE_COUNT)
extern unsigned char kb_error_buffer[64]; // and their PS2_ERROR_* bits
extern unsigned char kb_buffer_write; // next one it writes
extern unsigned char kb_interrupt_count; // bytes received (wraps)
extern unsigned char kb_error_count; // bytes with errors (wraps)

// src/editor/editor.asm
extern void EditorSetup(void);
extern void WaitFrame(void); // waits for vblank, updates input
extern void EditorShowCursor(unsigned char show); // uses tb_found_col/row
extern void EditorInvertCursor(unsigned char invert); // white cursor, for the start of a selection

// src/editor/render.asm
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

// src/sram.asm: the font, line wrapping, full screen and the open file's name, folder, line endings
// and modified flag, kept in SRAM with the text
extern unsigned char SettingsLoad(void); // 0 if they were never saved
extern void SettingsSave(void);

// src/editor/osk.asm
extern void OSKShow(unsigned char show);
extern void OSKDraw(unsigned char layer, unsigned char first_row); // into tile_buffer rows first_row and on
extern void OSKSelect(unsigned char x, unsigned char y);
extern unsigned char OSKGetKey(unsigned char layer, unsigned char index); // 0 = no key

// src/editor/sd.asm
extern unsigned char sd_Detect(void); // 1 on an EverDrive X

// src/fatfs/fatfs.asm (stubs into the FatFs banks)
extern unsigned char FileMount(void); // FRESULT, mounts the card if it isn't
extern unsigned char FileList(const char* path, const char* find); // FRESULT, UTF-8 path, "" = root
extern unsigned char FileListEntry(unsigned int index, FileEntry* entry); // FRESULT, folders first
extern unsigned int fs_count; // entries FileList found
extern unsigned int fs_found; // index of the folder it was asked to find, 0xFFFF if it isn't there
extern unsigned char FileLoad(const char* path); // FRESULT, replaces the text buffer
extern unsigned char FileSave(const char* path); // FRESULT
#ifdef EVERDRIVE_OS
extern unsigned char FileLoadData(const char* path); // FRESULT, copies the data file to PSRAM
extern unsigned char data_loaded; // the styled fonts and SGB border are in PSRAM
extern void SGBSetDefaultBorder(void);
extern unsigned char FileSaveSwap(void); // FRESULT, the text, clipboard and settings
extern unsigned char FileLoadSwap(void); // FRESULT, restores them if PSRAM lost them
extern unsigned char swap_dirty; // they changed since FileSaveSwap
extern unsigned char FileLoadLarge(const char* path); // FRESULT, opens a file too big for the text buffer, loads the window at its start
extern unsigned char FileLoadWindow(void); // FRESULT, the text buffer is the file from win_start (see src/fatfs/fatfs.c)
extern void FileCloseLarge(void);
extern void DocLineStart(void); // moves doc_pos (a file offset) to its line's start, doc_back = window positions it moved
extern unsigned char FileScanStep(void); // counts a sector's line feeds toward scan_target, 1 when done
extern unsigned char FileCommitWindow(void); // an edited window goes into the document, 0 if it's full
extern unsigned char FileSaveLarge(const char* path); // FRESULT, saves the document (FR_DENIED: it or the card is full)
extern unsigned char FileBackupSave(void); // FRESULT, writes the last launched game's save RAM to its .srm
extern unsigned char backup_skipped; // it didn't: the EverDrive OS launched a game since
extern unsigned char FileGameOpen(const char* path); // FRESULT, checks a game (src/fatfs/fatfs.c)
extern unsigned char FileGameCopy(void); // FRESULT, copies the next part of it to PSRAM
extern unsigned char FileGameFinish(const char* path); // FRESULT, loads its save
extern unsigned int game_block, game_blocks; // FileGameCopy's progress (sectors)
extern void InGameHeader(const char* name); // prepares the in-game filename bar
extern void GameLaunch(void); // resets the Game Boy into it
extern void Reboot(void); // starts the OS again
extern unsigned char doc_large; // a large file is open, the text buffer is a window into it
extern unsigned char lines_known, win_chunks;
extern unsigned long doc_len, doc_pos, win_start, win_end, win_mark, win_lines, scan_pos, scan_target, scan_lines;
extern unsigned int doc_back, win_mark_pos, win_kept[];
#endif
extern unsigned char fs_crlf; // loaded file used CR LF, saving writes CR LF

// src/wram.asm
extern unsigned char tile_buffer[];
extern unsigned char tile_attrs[]; // style of each char in tile_buffer's text rows: STYLE_* bits and its width
extern unsigned int tb_row_states[TB_ROWS + 1]; // lexer state at the start of each rendered row
extern unsigned char tb_lang; // LANG_*, how text is styled

// src/editor/text_buffer.asm
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
extern void tb_Normalize(void);
extern unsigned char tb_NormalizeStep(void); // 1 when the gap is at the end
extern unsigned int tb_CountLines(unsigned int start, unsigned int end); // line feeds in [start, end)
extern unsigned int tb_LineStart(unsigned int pos); // after the line feed before pos
extern unsigned int tb_RowStart(unsigned int pos);
extern unsigned int tb_NextRow(unsigned int row);
extern void tb_Render(unsigned int top);
extern void tb_RenderRows(unsigned char first, unsigned char end); // from tb_row_starts[first]
extern void tb_ScrollRows(unsigned char down); // shifts tile_buffer and the row tables one row

// src/editor/undo.asm (stubs into src/editor/undo.c)
extern void UndoClear(unsigned char modified); // forgets the history, modified = the text isn't saved
extern void UndoInserted(unsigned int pos, unsigned int count); // after inserting
extern void UndoDeleting(unsigned int pos, unsigned int count); // before deleting
extern void UndoSaved(void);
extern unsigned char Undo(void); // 0 if there's nothing to undo, sets undo_cursor and undo_at_save
extern unsigned char Redo(void);
extern unsigned char undo_merge; // 0 = the next edit starts a new undo step
extern unsigned char undo_join; // 1 = the next edit is undone with the one before it
extern unsigned int undo_cursor;
extern unsigned char undo_at_save;

void Editor(void);

#endif
