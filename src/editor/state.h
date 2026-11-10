#ifndef FATPAK_EDITOR_STATE_H
#define FATPAK_EDITOR_STATE_H

#include "../constants.h"
#include "../fatfs/file_api.h"

// Shared editing state; defined in editor.c, document.c and view.c.

extern unsigned int cursor;
extern unsigned int top;
extern unsigned int anchor; // other end of the selection
extern unsigned char selecting;
extern unsigned int sel_start; // set by GetSelection
extern unsigned int sel_end;
extern unsigned char want_x; // pixel x up and down try to keep
extern unsigned char keep_x;
extern unsigned char moved; // cursor moved, text didn't change
extern unsigned char redraw; // rendered rows changed, text didn't
extern unsigned char bars_on; // file name and status bars (F11)
extern unsigned char bars_changed; // the cursor moved, the status bar needs updating
extern unsigned int counted_pos; // counted_lines line feeds are before counted_pos
extern unsigned int counted_lines;
extern unsigned char edited; // one edit at edit_pos, rows from edit_row need rendering
extern unsigned char edit_row;
extern unsigned int edit_pos;
extern signed char edit_delta;
extern unsigned char blink_timer;
extern unsigned char dirty;
extern unsigned char modified;
extern unsigned char everdrive; // text is saved to SD, otherwise SRAM is the only copy so the gap is closed when idle
extern unsigned char idle_frames;
extern unsigned char normalized;
extern unsigned char saved_modified; // modified as last saved with the settings
extern char file_name[FS_NAME_SIZE]; // current file (UTF-8), empty for new text
extern char file_dir[PATH_SIZE]; // its folder, "" = root, new text is saved here too

#endif
