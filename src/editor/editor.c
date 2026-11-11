// Text editing commands and the editor event loop.
#include "editor.h"
#include "../app/dialogs.h"
#include "../app/menu.h"
#include "document.h"
#include "navigation.h"
#include "osk.h"
#include "settings.h"
#include "state.h"
#include "text_buffer.h"
#include "undo.h"
#include "view.h"
#include "window.h"
#include "../fatfs/file_api.h"
#include "../input.h"
#include "../keyboard/keyboard.h"
#include "../ui/dialogs.h"
#include "../ui/render.h"
#include "../ui/screen.h"

#define CURSOR_BLINK     30
#define SWAP_DELAY       120 // frames without input before writing the swap file (OS mode)

unsigned int cursor;
unsigned int top;
unsigned int anchor; // other end of the selection
unsigned char selecting;
unsigned int sel_start; // set by GetSelection
unsigned int sel_end;
unsigned char want_x; // pixel x up and down try to keep
unsigned char keep_x;
unsigned char moved; // cursor moved, text didn't change
unsigned char redraw; // rendered rows changed, text didn't
unsigned char bars_on; // file name and status bars (F11)
unsigned char bars_changed; // the cursor moved, the status bar needs updating
unsigned char edited; // one edit at edit_pos, rows from edit_row need rendering
unsigned char edit_row;
unsigned int edit_pos;
signed char edit_delta;
unsigned char blink_timer;
unsigned char dirty;
unsigned char modified;
unsigned char idle_frames;
unsigned char saved_modified; // modified as last saved with the settings

// Called after the recovery file and hardware screen setup.
void EditorInit(void) {
  unsigned char key;
  for (key = 0; key < BG_MAP_ROWS + WIN_MAP_ROWS; ++key) map_blocks[key] = key < TB_ROWS ? key : 0xFF; // set by RenderSetup
  idle_frames = 0;
  cursor = 0;
  top = 0;
  selecting = 0;
  want_x = 0;
  keep_x = 0;
  moved = 0;
  redraw = 0;
  ring_top = 0;
  ring_pos = 0;
  counted_pos = 0;
  counted_lines = 0;
  bars_changed = 0;
  edited = 0;
  pad_timer = 0;
  modified = 0;
  font = FONT_VWF; // SetLang
  file_name[0] = 0;
  file_dir[0] = 0;
  fs_crlf = 0;
  osk_shown = 0;
  osk_layer = OSK_LOWER;
  osk_x = 0;
  osk_y = 0;
  bars_on = 1;
  tb_nowrap = 0;
  tb_left = 0;
  tb_lang = LANG_PLAIN;
  render_text = 1;
  SettingsLoad();
  SetLang();
  UndoClear(modified);
  saved_modified = modified;
  SetFont(font);
  SetRows();
  swap_dirty = 0; // the swap file has what booting restored
  doc_large = 0;
}

// remembers an edit so only the rows it changed are rendered, more than one edit renders everything
static void Edited(unsigned int pos, signed char delta) {
  modified = 1;
  if (edited) dirty = 1;
  edited = 1;
  edit_row = tb_found_row;
  edit_pos = pos;
  edit_delta = delta;
}

// sets sel_start and sel_end, returns 0 if nothing is selected
unsigned char GetSelection(void) {
  if (!selecting || anchor == cursor) return 0;
  if (anchor < cursor) {
    sel_start = anchor;
    sel_end = cursor;
  }
  else {
    sel_start = cursor;
    sel_end = anchor;
  }
  return 1;
}

static void ClearSelection(void) {
  if (selecting) redraw = 1;
  selecting = 0;
}

static void DeleteSelection(void) {
  UndoDeleting(sel_start, sel_end - sel_start);
  Uncount(sel_start);
  tb_DeleteRange(sel_start, sel_end - sel_start);
  cursor = sel_start;
  selecting = 0;
  modified = 1;
  dirty = 1;
}

unsigned char Copy(void) {
  if (!GetSelection()) return 0;
  if (tb_Copy(sel_start, sel_end - sel_start)) return 1;
  ShowMessage("TOO BIG TO COPY");
  return 0;
}

void Paste(void) {
  unsigned int length = tb_ClipLength(), room = TB_SIZE - tb_Length();
  if (!length) return;
  if (GetSelection()) room += sel_end - sel_start;
  if (length > room) {
    ShowMessage("TEXT FULL");
    return;
  }
  undo_join = GetSelection();
  if (undo_join) DeleteSelection();
  Uncount(cursor);
  tb_Paste(cursor);
  UndoInserted(cursor, length);
  cursor += length;
  modified = 1;
  dirty = 1;
}

// Ctrl+Z (Ctrl+Shift+Z redoes) and Ctrl+Y
void UndoRedo(unsigned char redo) {
  if (!(redo ? Redo() : Undo())) return;
  cursor = undo_cursor;
  selecting = 0;
  Uncount(0);
  modified = !undo_at_save;
  dirty = 1;
}

void SelectAll(void) {
  anchor = 0;
  cursor = tb_Length();
  selecting = 1;
  moved = 1;
  redraw = 1;
}

void Cut(void) {
  if (Copy()) DeleteSelection();
}

// ctrl + A, X, C, V, Z, Y
static void HandleCtrlKey(unsigned char key, unsigned char mods) {
  if (key >= 'A' && key <= 'Z') key += 'a' - 'A';
  if (key == 'z') UndoRedo(mods & KB_MOD_SHIFT);
  else if (key == 'y') UndoRedo(1);
  if (key == 'a') SelectAll();
  else if (key == 'c') Copy();
  else if (key == 'x') Cut();
  else if (key == 'v') Paste();
}

// ctrl + left/right move by token, ctrl + up/down scroll, ctrl + home/end go to the start/end
static void HandleKey(unsigned char key, unsigned char mods) {
  unsigned char ctrl = mods & KB_MOD_CTRL, join = 0;
  if (key == KEY_UNDO || key == KEY_REDO) { UndoRedo(key == KEY_REDO); return; }
  if (mods & (KB_MOD_ALT | KB_MOD_SUPER)) return;
  if (key >= KEY_LEFT && key <= KEY_PAGE_DOWN) undo_merge = 0; // moving starts a new undo step
  if (key < KEY_LEFT || key > KEY_PAGE_DOWN) {
    if (ctrl) {
      HandleCtrlKey(key, mods);
      return;
    }
  }
  else if (mods & KB_MOD_SHIFT) { // shift + movement selects
    if (!selecting) anchor = cursor;
    selecting = 1;
    redraw = 1;
  }
  else if (!ctrl && GetSelection() && (key == KEY_LEFT || key == KEY_RIGHT)) { // to that end of the selection
    cursor = key == KEY_LEFT ? sel_start : sel_end;
    ClearSelection();
    moved = 1;
    return;
  }
  else ClearSelection();
  moved = 1;
  if (ctrl) {
    switch (key) {
      case KEY_LEFT: WordLeft(); return;
      case KEY_RIGHT: WordRight(); return;
      case KEY_UP: ScrollLine(0); return;
      case KEY_DOWN: ScrollLine(1); return;
      case KEY_HOME: GoStart(); return;
      case KEY_END: GoEnd(); return;
    }
  }
  switch (key) {
    case KEY_UP: MoveUp(); return;
    case KEY_DOWN: MoveDown(); return;
    case KEY_PAGE_UP: PageUp(); return;
    case KEY_PAGE_DOWN: PageDown(); return;
    case KEY_LEFT: if (cursor) --cursor; return;
    case KEY_RIGHT: if (cursor != tb_Length()) ++cursor; return;
    case KEY_HOME: cursor = tb_row_starts[tb_found_row]; return;
    case KEY_END: MoveEnd(); return;
  }
  moved = 0;
  if (key == KEY_ESCAPE || key == KEY_INSERT) return;
  if (GetSelection()) { // typing replaces the selection
    DeleteSelection();
    if (key == KEY_BACKSPACE || key == KEY_DELETE) return;
    join = 1;
  }
  selecting = 0;
  switch (key) {
    case KEY_BACKSPACE:
      if (!cursor) break;
      --cursor;
      // fall through
    case KEY_DELETE:
      if (cursor < tb_Length()) {
        UndoDeleting(cursor, 1);
        CountEdit(cursor, tb_Delete(cursor), 0);
        Edited(cursor, -1);
      }
      break;
    default:
      if (key < ' ' && key != ASCII_TAB && key != ASCII_LF) return;
      if (key >= KEY_LEFT && key < 0xA0) return; // unprintable in Latin-1
      if (tb_Insert(cursor, key)) {
        undo_join = join;
        UndoInserted(cursor, 1);
        CountEdit(cursor, key, 1);
        Edited(cursor++, 1);
      }
  }
}

// Alt+Z, lines wrap or each row is a whole line, scrolled sideways to keep the cursor on screen
void ToggleWrap(void) {
  tb_nowrap = !tb_nowrap;
  tb_left = 0;
  dirty = 1;
  SettingsSave();
}

void Editor(void) {
  unsigned int event;
  unsigned char key;

  while (1) {
    if (modified != saved_modified) {
      saved_modified = modified;
      SettingsSave();
    }
    if (bars_changed) { // status bar follows the cursor
      bars_changed = 0;
      if (bars) Draw();
    }
    WaitFrame();
    while ((key = (unsigned char)(event = KBPopEvent()))) {
      if (!HandleFileKey(key, (unsigned char)(event >> 8))) HandleKey(key, (unsigned char)(event >> 8));
      if (doc_large) Slide(); // before the next key, which could reach the window's end
      if (dirty || edited) break; // text changed, rows need rendering before more keys
      if (moved) { // keeps tb_found_row current for the next key
        if (!PlaceCursor()) dirty = 1;
        moved = 0;
      }
    }
    if ((key = PadKey())) {
      if (!HandleFileKey(key, pad_mods)) HandleKey(key, pad_mods);
    }
    if (doc_large) Slide(); // near the window's edge (sets dirty)
    if (dirty || edited || redraw || moved) idle_frames = 0;
    if (dirty) {
      Refresh();
      dirty = 0;
      edited = 0;
      continue;
    }
    if (edited) {
      edited = 0;
      RenderAfterEdit();
      if (!PlaceCursor()) {
        if (cursor >= tb_row_starts[tb_rows] && tb_RowStart(cursor) == tb_row_starts[tb_rows]) ScrollDown();
        else if (top && cursor < top && tb_RowStart(cursor) == tb_RowStart(top - 1)) ScrollUp(tb_RowStart(cursor));
        else {
          Refresh();
          continue;
        }
        if (!PlaceCursor()) { // off the side
          Refresh();
          continue;
        }
      }
    }
    if (redraw) {
      Draw();
      redraw = 0;
    }
    if (moved) {
      moved = 0;
      if (!PlaceCursor()) Refresh();
      continue;
    }
    if (idle_frames < SWAP_DELAY) ++idle_frames;
    if (doc_large && !lines_known && FileScanStep()) { // a sector a frame while idle
      win_lines += scan_lines;
      lines_known = 1;
      bars_changed = 1;
    }
    if (idle_frames >= SWAP_DELAY && swap_dirty && !doc_large) {
      swap_dirty = 0;
      FileSaveSwap();
    }
    if (++blink_timer == CURSOR_BLINK) EditorShowCursor(0);
    else if (blink_timer == CURSOR_BLINK + CURSOR_BLINK) {
      EditorShowCursor(1);
      blink_timer = 0;
    }
  }
}
