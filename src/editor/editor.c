// src/editor/editor.c
// NOTE: no static initializers (_GSINIT doesn't run) and no int multiply/divide (no SDCC libs)
#include "editor.h"

#define PADF_DOWN   0x80
#define PADF_UP     0x40
#define PADF_LEFT   0x20
#define PADF_RIGHT  0x10
#define PADF_START  0x08
#define PADF_SELECT 0x04
#define PADF_B      0x02
#define PADF_A      0x01
#define PADF_DPAD   0xF0

#define ITEM_SIZE      13 // menu items
#define NAME_CHARS     32 // save as, Latin-1 chars are 2 bytes in UTF-8 so they fit in FS_NAME_SIZE
#define PATH_SIZE      128
#define LIST_ROWS      (TB_ROWS - 2) // file browser rows between the bars
#define LIST_ALL       0xFFFF
#define KIND_UP        0
#define KIND_FOLDER    1
#define KIND_FILE      2
#define CANCEL         0xFF
#define BG_MAP_ROWS      32
#define LCDC_TILES_8000  0x10 // LCDCF_BG8000
#define HEADER_LINE      TB_ROWS // tile_buffer rows of the file name and status bars
#define STATUS_LINE      (TB_ROWS + 1)
#define HEADER_BLOCK     8 // the bars' blocks work in either tile data mode (see src/editor/render.asm)
#define STATUS_BLOCK     17
#define BOX_LINE         (TB_ROWS + 2) // menu box text in tile_buffer rows from here, BOX_STRIDE chars per line
#define BOX_PADDING      9 // 4 pixels each side of the text, and the border
#define HELP_ROWS        18
#define HELP_COLS        36

// FRESULT codes (src/fatfs/lib/ff.h)
#define FR_NOT_READY     3
#define FR_DENIED        7
#define FR_NO_FILESYSTEM 13

#define PAD_REPEAT_DELAY 20
#define PAD_REPEAT_RATE  4
#define CURSOR_BLINK     30
#define NORMALIZE_DELAY  30 // frames without input before closing the gap

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
unsigned char ring_top; // BG map row of screen row 0
unsigned char ring_pos; // index in the ring of text blocks of text row 0's block
unsigned char map_blocks[BG_MAP_ROWS]; // block each BG map row shows, 0xFF = none
unsigned char bars_on; // file name and status bars (F11)
unsigned char bars; // bars are shown now (not in menus)
unsigned char bars_changed; // the cursor moved, the status bar needs updating
unsigned int counted_pos; // counted_lines line feeds are before counted_pos
unsigned int counted_lines;
unsigned char edited; // one edit at edit_pos, rows from edit_row need rendering
unsigned char edit_row;
unsigned int edit_pos;
signed char edit_delta;
unsigned char pad_timer;
unsigned char blink_timer;
unsigned char dirty;
unsigned char osk_shown;
unsigned char osk_layer;
unsigned char osk_x;
unsigned char osk_y;
unsigned char modified;
unsigned char font;
unsigned char everdrive; // text is saved to SD, otherwise SRAM is the only copy so the gap is closed when idle
unsigned char idle_frames;
unsigned char normalized;
char file_name[FS_NAME_SIZE]; // current file (UTF-8), empty for new text
char file_dir[PATH_SIZE]; // its folder, "" = root, new text is saved here too
FileEntry entry;
unsigned char list_result; // FRESULT of the last folder listed
unsigned char list_kinds[LIST_ROWS]; // file browser rows
unsigned long list_sizes[LIST_ROWS];
unsigned int list_dates[LIST_ROWS];
unsigned int list_times[LIST_ROWS];

static const char menu_items[][ITEM_SIZE] = {"OPEN", "SAVE", "SAVE AS", "NEW", "FONT", "FULL SCREEN", "HELP"};
static const char discard_items[][ITEM_SIZE] = {"NO", "YES"};
static const char help_lines[HELP_ROWS][HELP_COLS] = {
  "HELP",
  "Esc  menu      F1  help",
  "F11  full screen",
  "Ctrl+O, S, N  open, save, new",
  "Ctrl+F  switch font",
  "Shift + moving  select",
  "Ctrl+A  select all",
  "Ctrl+X, C, V  cut, copy, paste",
  "Ctrl+Left, Right  move by word",
  "Ctrl+Up, Down  scroll",
  "Ctrl+Home, End  start or end",
  "",
  "Select  on screen keyboard",
  "A  type the selected key",
  "B  backspace    Start  new line",
  "D-pad  move",
  "",
  "Press any key to close",
};

static void Render(void);

static char* RowAddress(unsigned char row);
static void DrawRow(unsigned char row, unsigned char col, const char* text);
static void ShowMessage(const char* text);
static void CopyName(char* dest, const char* src);

// rendered row pos is on, 0xFF if it isn't on screen
static unsigned char FindRow(unsigned int pos) {
  unsigned char row;
  for (row = 0; row < tb_rows; ++row) {
    if (pos < tb_row_starts[row]) return 0xFF;
    if (pos < tb_row_starts[row + 1]) return row;
  }
  return pos == tb_Length() ? tb_end_row : 0xFF;
}

static unsigned char GetSelection(void);

// moves the cursor sprite to the cursor, returns 0 if it isn't on screen
static unsigned char PlaceCursor(void) {
  unsigned char row = FindRow(cursor);
  unsigned int col;
  if (row == 0xFF) return 0;
  col = cursor - tb_row_starts[row];
  if (col > tb_row_counts[row]) col = tb_row_counts[row]; // hanging spaces
  tb_found_row = row;
  tb_found_col = (unsigned char)col;
  if (!keep_x) want_x = RenderCursorX(tb_found_col);
  keep_x = 0;
  blink_timer = 0;
  EditorInvertCursor(GetSelection() && cursor == sel_start); // the selection starts at the cursor's x
  EditorShowCursor(1);
  bars_changed = 1;
  return 1;
}

// position in a rendered row closest to x
static unsigned int PosAtX(unsigned char row, unsigned char x) {
  char* chars = RowAddress(row);
  unsigned char count = tb_row_counts[row], col = 0, width;
  unsigned int pos;
  while (col < count) {
    width = font_widths[(unsigned char)chars[col]];
    if (x < ((width + 1) >> 1)) break;
    x = x < width ? 0 : x - width;
    ++col;
  }
  pos = tb_row_starts[row] + col;
  if (col == count && pos == tb_row_starts[row + 1] && tb_end_row != row) --pos; // stay on wrapped row
  return pos;
}

// stages the tile data mode switches for render_row_blocks (see src/editor/render.asm): blocks 0-5
// need $8000 mode, 9-14 $8800, the rest work in either so switches go in the middle of them
static void StageSplits(void) {
  unsigned char row, block, mode, current = 0xFF, shared = 0xFF, count = 0;
  for (row = 0; row < TB_ROWS; ++row) {
    block = render_row_blocks[row];
    if ((block >= 6 && block < 9) || block >= 15) {
      if (shared == 0xFF) shared = row;
      continue;
    }
    mode = block < 6 ? LCDC_TILES_8000 : 0;
    if (current == 0xFF) render_pending_top_mode = mode;
    else if (mode != current) {
      render_pending_splits[count++] = ((shared + row - 1) >> 1) << 3;
      render_pending_splits[count++] = mode;
    }
    current = mode;
    shared = 0xFF;
  }
  render_pending_split_count = count >> 1;
}

// blocks text rows use, all of them or all but the bars'
static unsigned char RingLength(void) {
  return bars ? TB_ROWS - 2 : TB_ROWS;
}

// text rows above the on screen keyboard
static unsigned char TextRows(void) {
  return RingLength() - (osk_shown ? OSK_ROWS : 0);
}

// sets each screen row's block, tile_buffer row and font (the bars keep their blocks, text rows
// use the rest in a ring starting at ring_pos), points the BG map rows that show the screen at
// them and stages the tile data mode switches, applied with SCY at line 144
static void Layout(void) {
  unsigned char row, line, block, map_row, i = ring_pos, length = RingLength();
  render_pending = 0;
  render_text_top = bars;
  for (row = 0; row < TB_ROWS; ++row) {
    if (bars && (!row || row == TB_ROWS - 1)) {
      block = row ? STATUS_BLOCK : HEADER_BLOCK;
      line = row ? STATUS_LINE : HEADER_LINE;
      render_row_fonts[row] = FONT_VWF;
    }
    else {
      block = bars && i >= HEADER_BLOCK ? i + 1 : i;
      if (++i == length) i = 0;
      line = row - bars;
      render_row_fonts[row] = line < tb_rows ? font : FONT_MONO; // on screen keyboard
    }
    render_row_blocks[row] = block;
    render_row_lines[row] = line;
    map_row = (ring_top + row) & (BG_MAP_ROWS - 1);
    if (map_blocks[map_row] != block) {
      map_blocks[map_row] = block;
      RenderSetMapRow(map_row, block);
    }
  }
  StageSplits();
  render_pending_scy = ring_top << 3;
  render_pending = 1;
}

// scrolls the screen one row with SCY (dir 1 = down), the block leaving the screen draws the new row
static void ScrollRing(unsigned char down) {
  unsigned char length = RingLength();
  if (down) {
    ring_pos = ring_pos == length - 1 ? 0 : ring_pos + 1;
    ring_top = (ring_top + 1) & (BG_MAP_ROWS - 1);
  }
  else {
    ring_pos = ring_pos ? ring_pos - 1 : length - 1;
    ring_top = (ring_top - 1) & (BG_MAP_ROWS - 1);
  }
  Layout();
}

// scrolls one row down, only the new bottom row is scanned and drawn
static void ScrollDown(void) {
  ScrollRing(1);
  tb_ScrollRows(1);
  tb_RenderRows(tb_rows - 1, tb_rows);
  top = tb_row_starts[0];
  redraw = 1;
}

// scrolls one row up to the row starting at new_top
static void ScrollUp(unsigned int new_top) {
  ScrollRing(0);
  tb_ScrollRows(0);
  tb_row_starts[0] = new_top;
  tb_RenderRows(0, 1);
  top = new_top;
  redraw = 1;
}

// re-renders rows after an edit, stopping once a row starts where it used to (moved by the edit)
// NOTE: SDCC 4.2 clobbered hl when edit_delta was read inside these expressions, so it's copied first
static void RenderAfterEdit(void) {
  unsigned char row = edit_row, end_row = tb_end_row, i;
  unsigned int old_next, expected, delta = (unsigned int)(int)edit_delta;
  if (row) --row; // the previous row's wrapping can change too
  if (end_row != 0xFF && end_row >= row) tb_end_row = 0xFF; // found again while scanning
  for (; row < tb_rows; ++row) {
    old_next = tb_row_starts[row + 1];
    expected = old_next + delta;
    tb_RenderRows(row, row + 1);
    if (old_next > edit_pos && tb_row_starts[row + 1] == expected) {
      for (i = row + 2; i <= tb_rows; ++i) tb_row_starts[i] += delta; // rows below just moved
      if (end_row != 0xFF && end_row > row) tb_end_row = end_row;
      break;
    }
  }
  redraw = 1;
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
static unsigned char GetSelection(void) {
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

// no selection, the bars are drawn selected
static void NoHighlight(void) {
  unsigned char i;
  for (i = 0; i < TB_ROWS * 2; ++i) render_sel[i] = 0;
  if (bars) render_sel[1] = render_sel[(TB_ROWS << 1) - 1] = 0xFF;
}

// sets the selected columns of each rendered row for EditorDraw
static void SetHighlight(void) {
  unsigned char row, first, end, count;
  unsigned int row_start, next;
  NoHighlight();
  if (!GetSelection()) return;
  for (row = 0; row < tb_rows; ++row) {
    row_start = tb_row_starts[row];
    next = tb_row_starts[row + 1];
    if (sel_end <= row_start) break;
    if (sel_start >= next) continue;
    count = tb_row_counts[row];
    first = 0;
    if (sel_start > row_start) first = sel_start - row_start > count ? count : (unsigned char)(sel_start - row_start);
    if (sel_end < next || row == tb_end_row) { // ends in this row
      end = sel_end - row_start > count ? count : (unsigned char)(sel_end - row_start);
      if (end <= first) continue;
    }
    else end = 0xFF; // continues, so the line feed or wrap is selected too
    render_sel[(row + bars) << 1] = first;
    render_sel[((row + bars) << 1) + 1] = end;
  }
}

// line feeds before pos, counting from the last position asked about
static unsigned int LinesBefore(unsigned int pos) {
  if (pos >= counted_pos) counted_lines += tb_CountLines(counted_pos, pos);
  else if (pos < counted_pos - pos) counted_lines = tb_CountLines(0, pos);
  else counted_lines -= tb_CountLines(pos, counted_pos);
  counted_pos = pos;
  return counted_lines;
}

// keeps counted_pos and counted_lines right after inserting or deleting c at pos
static void CountEdit(unsigned int pos, unsigned char c, unsigned char inserted) {
  if (pos >= counted_pos) return;
  if (inserted) {
    ++counted_pos;
    if (c == ASCII_LF) ++counted_lines;
  }
  else {
    --counted_pos;
    if (c == ASCII_LF) --counted_lines;
  }
}

// after an edit of more than one char at pos
static void Uncount(unsigned int pos) {
  if (pos < counted_pos) counted_pos = counted_lines = 0;
}

// 1 if a rendered row ends with a line feed instead of wrapping
static unsigned char RowEndsLine(unsigned char row) {
  return tb_GetChar(tb_row_starts[row + 1] - 1) == ASCII_LF;
}

static unsigned int CursorLine(void) {
  unsigned int line = LinesBefore(top) + 1;
  unsigned char row;
  for (row = 0; row < tb_found_row; ++row) if (RowEndsLine(row)) ++line;
  return line;
}

static unsigned int CursorColumn(void) {
  unsigned char row = tb_found_row;
  unsigned int start;
  while (row && !RowEndsLine(row - 1)) --row;
  start = tb_row_starts[row];
  if (!row && start && tb_GetChar(start - 1) != ASCII_LF) start = tb_LineStart(start);
  return cursor - start + 1;
}

static char* PutText(char* dest, const char* text) {
  while (*text) *dest++ = *text++;
  return dest;
}

static const unsigned int powers_of_ten[] = {10000, 1000, 100, 10};

static char* PutNumber(char* dest, unsigned int n) {
  unsigned char i, digit, started = 0;
  for (i = 0; i < 4; ++i) {
    digit = '0';
    while (n >= powers_of_ten[i]) {
      n -= powers_of_ten[i];
      ++digit;
    }
    if (started || digit != '0') {
      *dest++ = digit;
      started = 1;
    }
  }
  *dest++ = '0' + (unsigned char)n;
  return dest;
}

// pads n to 2 digits
static char* PutNumber2(char* dest, unsigned int n) {
  if (n < 10) *dest++ = '0';
  return PutNumber(dest, n);
}

// UTF-8 to Latin-1 (? for chars it doesn't have), at most count chars, returns the end (no 0)
static char* ToLatin1(char* dest, const char* text, unsigned char count) {
  unsigned char c, next;
  while ((c = *text++) && count--) {
    if (c >= 0x80) {
      next = *text;
      if ((c & 0xFE) == 0xC2 && (next & 0xC0) == 0x80) { // U+0080-U+00FF
        ++text;
        c = (c << 6) | (next & 0x3F);
        if (c < 0xA0) c = '?';
      }
      else {
        while ((*text & 0xC0) == 0x80) ++text;
        c = '?';
      }
    }
    *dest++ = c;
  }
  return dest;
}

// Latin-1 to UTF-8, with a 0
static void ToUtf8(char* dest, const char* text) {
  unsigned char c;
  while ((c = *text++)) {
    if (c >= 0x80) {
      *dest++ = 0xC0 | (c >> 6);
      c = 0x80 | (c & 0x3F);
    }
    *dest++ = c;
  }
  *dest = 0;
}

// path with a 0, "/" for the root, its end with ... if it's longer than count chars
static void PutPath(char* dest, const char* path, unsigned char count) {
  unsigned char length = 0;
  while (path[length]) ++length;
  if (!length) path = "/";
  else if (length > count) {
    dest = PutText(dest, "...");
    path += length - count;
  }
  *ToLatin1(dest, path, count) = 0;
}

// dir + "/" + name with a 0, returns 0 if it doesn't fit in size bytes
static unsigned char JoinPath(char* dest, const char* dir, const char* name, unsigned char size) {
  while (*dir) {
    if (!--size) return 0;
    *dest++ = *dir++;
  }
  if (!--size) return 0;
  *dest++ = '/';
  while (*name) {
    if (!--size) return 0;
    *dest++ = *name++;
  }
  *dest = 0;
  return 1;
}

// file name (* = unsaved changes) and line and column, or how many chars are selected
static void UpdateBars(void) {
  char text[TB_STRIDE];
  char* end = file_name[0] ? ToLatin1(text, file_name, TB_STRIDE - 3) : PutText(text, "Untitled");
  if (modified) *end++ = '*';
  *end = 0;
  DrawRow(HEADER_LINE, 1, text);
  if (tb_found_row == 0xFF) return; // cursor isn't on screen
  if (GetSelection()) {
    end = PutNumber(text, sel_end - sel_start);
    end = PutText(end, " selected");
  }
  else {
    end = PutText(text, "Line ");
    end = PutNumber(end, CursorLine());
    end = PutText(end, ", Col ");
    end = PutNumber(end, CursorColumn());
  }
  *end = 0;
  DrawRow(STATUS_LINE, 1, text);
}

static void Draw(void) {
  SetHighlight();
  if (bars) UpdateBars();
  EditorDraw();
}

// sets the first rendered row and renders
static void ScrollTo(unsigned int new_top) {
  top = new_top;
  Render();
  redraw = 1;
}

static void MoveUp(void) {
  unsigned char row = tb_found_row;
  keep_x = 1;
  if (row) cursor = PosAtX(row - 1, want_x);
  else if (!top) cursor = 0;
  else {
    ScrollUp(tb_RowStart(top - 1));
    cursor = PosAtX(0, want_x);
  }
}

static void MoveDown(void) {
  unsigned char row = tb_found_row;
  keep_x = 1;
  if (tb_end_row == row) cursor = tb_Length(); // last row
  else if (row + 1 < tb_rows) cursor = PosAtX(row + 1, want_x);
  else {
    ScrollDown();
    cursor = PosAtX(row, want_x);
  }
}

static void PageUp(void) {
  unsigned char row = tb_found_row, i;
  keep_x = 1;
  if (!top) {
    cursor = 0;
    return;
  }
  for (i = tb_rows - 1; i && top; --i) top = tb_RowStart(top - 1);
  ScrollTo(top);
  cursor = PosAtX(row, want_x);
}

static void PageDown(void) {
  unsigned char row = tb_found_row;
  keep_x = 1;
  if (tb_end_row != 0xFF) {
    cursor = tb_Length();
    return;
  }
  ScrollTo(tb_row_starts[tb_rows - 1]);
  if (tb_end_row != 0xFF && row > tb_end_row) row = tb_end_row;
  cursor = PosAtX(row, want_x);
}

// before the space that ends a wrapped row, otherwise after the last char
static void MoveEnd(void) {
  unsigned char row = tb_found_row, count = tb_row_counts[row];
  cursor = tb_row_starts[row] + count;
  if (count && cursor == tb_row_starts[row + 1] && tb_end_row != row && RowAddress(row)[count - 1] == ' ') --cursor;
}

static void DeleteSelection(void) {
  Uncount(sel_start);
  tb_DeleteRange(sel_start, sel_end - sel_start);
  cursor = sel_start;
  selecting = 0;
  modified = 1;
  dirty = 1;
}

static unsigned char Copy(void) {
  if (!GetSelection()) return 0;
  if (tb_Copy(sel_start, sel_end - sel_start)) return 1;
  ShowMessage("TOO BIG TO COPY");
  return 0;
}

static void Paste(void) {
  unsigned int length = tb_ClipLength(), room = TB_SIZE - tb_Length();
  if (!length) return;
  if (GetSelection()) room += sel_end - sel_start;
  if (length > room) {
    ShowMessage("TEXT FULL");
    return;
  }
  if (GetSelection()) DeleteSelection();
  Uncount(cursor);
  tb_Paste(cursor);
  cursor += length;
  modified = 1;
  dirty = 1;
}

// 0 = space, 1 = word (letters, digits, _), 2 = punctuation
static unsigned char CharClass(unsigned char c) {
  if (c == ' ' || c == ASCII_TAB || c == ASCII_LF) return 0;
  if ((c >= '0' && c <= '9') || (c >= 'A' && c <= 'Z') || (c >= 'a' && c <= 'z') || c == '_' || c >= 0xC0) return 1;
  return 2;
}

// to the end of the next token, skipping spaces
static void WordRight(void) {
  unsigned int length = tb_Length();
  unsigned char token;
  while (cursor < length && !CharClass(tb_GetChar(cursor))) ++cursor;
  if (cursor == length) return;
  token = CharClass(tb_GetChar(cursor));
  do ++cursor;
  while (cursor < length && CharClass(tb_GetChar(cursor)) == token);
}

// to the start of the previous token, skipping spaces
static void WordLeft(void) {
  unsigned char token;
  while (cursor && !CharClass(tb_GetChar(cursor - 1))) --cursor;
  if (!cursor) return;
  token = CharClass(tb_GetChar(cursor - 1));
  do --cursor;
  while (cursor && CharClass(tb_GetChar(cursor - 1)) == token);
}

// scrolls one row, the cursor only moves if its row leaves the screen
static void ScrollLine(unsigned char down) {
  unsigned char row = tb_found_row;
  keep_x = 1;
  if (down) {
    if (tb_end_row != 0xFF) return; // the end of the text is on screen
    ScrollDown();
    if (!row) cursor = PosAtX(0, want_x);
  }
  else if (top) {
    ScrollUp(tb_RowStart(top - 1));
    if (row == tb_rows - 1) cursor = PosAtX(row, want_x);
  }
}

// ctrl + A, X, C, V
static void HandleCtrlKey(unsigned char key) {
  if (key >= 'A' && key <= 'Z') key += 'a' - 'A';
  if (key == 'a') {
    anchor = 0;
    cursor = tb_Length();
    selecting = 1;
    moved = 1;
    redraw = 1;
  }
  else if (key == 'c') Copy();
  else if (key == 'x' && Copy()) DeleteSelection();
  else if (key == 'v') Paste();
}

// ctrl + left/right move by token, ctrl + up/down scroll, ctrl + home/end go to the start/end
static void HandleKey(unsigned char key, unsigned char mods) {
  unsigned char ctrl = mods & KB_MOD_CTRL, c;
  if (mods & (KB_MOD_ALT | KB_MOD_SUPER)) return;
  if (key < KEY_LEFT || key > KEY_PAGE_DOWN) {
    if (ctrl) {
      HandleCtrlKey(key);
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
      case KEY_HOME: cursor = 0; return;
      case KEY_END: cursor = tb_Length(); return;
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
  }
  selecting = 0;
  switch (key) {
    case KEY_BACKSPACE:
      if (cursor && (c = tb_Delete(cursor - 1))) {
        CountEdit(cursor - 1, c, 0);
        Edited(--cursor, -1);
      }
      break;
    case KEY_DELETE:
      if ((c = tb_Delete(cursor))) {
        CountEdit(cursor, c, 0);
        Edited(cursor, -1);
      }
      break;
    default:
      if (key < ' ' && key != ASCII_TAB && key != ASCII_LF) return;
      if (key >= KEY_LEFT && key < 0xA0) return; // unprintable in Latin-1
      if (tb_Insert(cursor, key)) {
        CountEdit(cursor, key, 1);
        Edited(cursor++, 1);
      }
  }
}

// returns held d-pad buttons when pressed and while repeating
static unsigned char DpadRepeat(unsigned char pressed) {
  unsigned char held = (button_state | pressed) & PADF_DPAD;
  if (!held) return 0;
  if (pressed & PADF_DPAD) pad_timer = PAD_REPEAT_DELAY;
  else if (--pad_timer) return 0;
  else pad_timer = PAD_REPEAT_RATE;
  return held;
}

// sets the text rows and lays out the screen for bars_on and osk_shown
static void SetRows(void) {
  bars = bars_on;
  tb_rows = TextRows();
  Layout();
  if (osk_shown) {
    OSKDraw(osk_layer, tb_rows);
    OSKSelect(osk_x, osk_y);
  }
  OSKShow(osk_shown);
  dirty = 1;
}

static void ToggleOSK(void) {
  osk_shown = !osk_shown;
  SetRows();
}

// F11
static void ToggleBars(void) {
  bars_on = !bars_on;
  SetRows();
}

static void SetOSKLayer(unsigned char layer) {
  osk_layer = osk_layer == layer ? OSK_LOWER : layer;
  OSKDraw(osk_layer, tb_rows);
  dirty = 1;
}

static unsigned char PressOSKKey(void) {
  unsigned char key;
  if (osk_y == OSK_ROWS - 1) {
    if (osk_x == 0) SetOSKLayer(OSK_SHIFT);
    else if (osk_x == 1) SetOSKLayer(OSK_SYMBOLS);
    else if (osk_x == OSK_COLS - 3) return KEY_MENU;
    else if (osk_x == OSK_COLS - 2) return KEY_LEFT;
    else if (osk_x == OSK_COLS - 1) return KEY_RIGHT;
    else return ' ';
    return KEY_NONE;
  }
  key = OSKGetKey(osk_layer, (osk_y << 3) + (osk_y << 1) + osk_x);
  if (osk_layer == OSK_SHIFT) SetOSKLayer(OSK_SHIFT); // shift is one shot
  return key;
}

static void MoveOSKSelection(unsigned char held) {
  if (held & PADF_UP) osk_y = osk_y ? osk_y - 1 : OSK_ROWS - 1;
  else if (held & PADF_DOWN) osk_y = osk_y == OSK_ROWS - 1 ? 0 : osk_y + 1;
  if (held & PADF_LEFT) osk_x = osk_x ? osk_x - 1 : OSK_COLS - 1;
  else if (held & PADF_RIGHT) osk_x = osk_x == OSK_COLS - 1 ? 0 : osk_x + 1;
  OSKSelect(osk_x, osk_y);
}

// SELECT = on screen keyboard, B = backspace, START = enter
// d-pad moves the cursor, or the keyboard selection when it's shown (A = type)
static unsigned char PadKey(void) {
  unsigned char pressed = PadPressed();
  unsigned char held;
  if (pressed & PADF_SELECT) ToggleOSK();
  if (pressed & PADF_B) return KEY_BACKSPACE;
  if (pressed & PADF_START) return KEY_ENTER;
  if (osk_shown && (pressed & PADF_A)) return PressOSKKey();
  held = DpadRepeat(pressed);
  if (!held) return KEY_NONE;
  if (osk_shown) {
    MoveOSKSelection(held);
    return KEY_NONE;
  }
  if (held & PADF_UP) return KEY_UP;
  if (held & PADF_DOWN) return KEY_DOWN;
  if (held & PADF_LEFT) return KEY_LEFT;
  return KEY_RIGHT;
}

// waits a frame, returns a key from the keyboard or d-pad (A, START = enter, B = escape)
static unsigned char MenuKey(void) {
  unsigned char key, pressed, held;
  WaitFrame();
  if ((key = (unsigned char)KBPopEvent())) return key;
  pressed = PadPressed();
  if (pressed & (PADF_A | PADF_START)) return KEY_ENTER;
  if (pressed & PADF_B) return KEY_ESCAPE;
  held = DpadRepeat(pressed);
  if (held & PADF_UP) return KEY_UP;
  if (held & PADF_DOWN) return KEY_DOWN;
  if (held & PADF_LEFT) return KEY_LEFT;
  if (held & PADF_RIGHT) return KEY_RIGHT;
  return KEY_NONE;
}

static char* RowAddress(unsigned char row) {
  unsigned int offset = row;
  return (char*)tile_buffer + (offset << 5) + (offset << 3); // row * TB_STRIDE
}

// draws text at col on row, clearing the rest of the row
static void DrawRow(unsigned char row, unsigned char col, const char* text) {
  char* dest = RowAddress(row);
  unsigned char i;
  for (i = 0; i < TB_STRIDE; ++i) dest[i] = ' ';
  for (dest += col; *text && col < TB_STRIDE; ++col) *dest++ = *text++;
}

static void ClearScreen(void) {
  unsigned char row;
  for (row = 0; row < TB_ROWS; ++row) DrawRow(row, 0, "");
}

// hides the bars, on screen keyboard and cursor for full screen UI, redraws the text afterwards
static void BeginFullScreen(void) {
  EditorShowCursor(0);
  if (osk_shown) OSKShow(0);
  bars = 0;
  tb_rows = TB_ROWS;
  Layout();
  NoHighlight();
  dirty = 1;
}

static void EndFullScreen(void) {
  SetRows();
}

// centers a box over the screen for the lines in the BOX_LINE rows, nothing highlighted
static void OpenBox(unsigned char lines) {
  char* line = RowAddress(BOX_LINE);
  unsigned char i, width, widest = 0;
  for (i = 0; i < lines; ++i, line += BOX_STRIDE) {
    width = RenderTextWidth(line);
    if (width > widest) widest = width;
  }
  render_box_text = RowAddress(BOX_LINE);
  render_box_w = widest + BOX_PADDING;
  render_box_x = (TB_WIDTH - render_box_w) >> 1;
  render_box_rows = lines + 2; // half rows above and below
  render_box_top = (TB_ROWS - render_box_rows) >> 1;
  render_box_sel = 0xFF;
  ++render_box_gen;
}

// a box with text (Loading..., Saving...), drawn right away, before the work it's waiting for
static void ShowBusy(const char* text) {
  CopyName(RowAddress(BOX_LINE), text);
  OpenBox(1);
  EditorDraw();
}

static void HideBox(void) {
  render_box_top = 0xFF;
}

// shows a list of ITEM_SIZE strings in a box over the text, returns the chosen index or CANCEL
static unsigned char Choose(const char* title, const char* items, unsigned char count) {
  char* line = RowAddress(BOX_LINE);
  unsigned char i, key, selected = 0;
  for (i = 0; i <= count; ++i, line += BOX_STRIDE) {
    if (i) {
      line[0] = ' ';
      CopyName(line + 1, items);
      items += ITEM_SIZE;
    }
    else CopyName(line, title);
  }
  EditorShowCursor(0);
  if (osk_shown) OSKShow(0);
  NoHighlight();
  OpenBox(count + 1);
  while (1) {
    render_box_sel = selected + 2;
    EditorDraw();
    while (!(key = MenuKey()));
    if (key == KEY_UP) selected = selected ? selected - 1 : count - 1;
    else if (key == KEY_DOWN) selected = selected == count - 1 ? 0 : selected + 1;
    else if (key == KEY_ENTER) break;
    else if (key == KEY_ESCAPE) {
      selected = CANCEL;
      break;
    }
  }
  HideBox();
  if (osk_shown) OSKShow(1);
  dirty = 1;
  return selected;
}

// shows text in the status bar or on the last text row until a key is pressed
static void ShowMessage(const char* text) {
  HideBox();
  Render();
  EditorShowCursor(0);
  NoHighlight();
  if (bars) {
    UpdateBars();
    DrawRow(STATUS_LINE, 1, text);
  }
  else DrawRow(tb_rows - 1, 0, text);
  EditorDraw();
  while (!MenuKey());
  dirty = 1;
}

static void ShowError(unsigned char result, const char* denied) {
  char text[12] = "SD ERROR ";
  if (result == FR_NOT_READY) ShowMessage("NO SD CARD");
  else if (result == FR_NO_FILESYSTEM) ShowMessage("NO FAT VOLUME");
  else if (result == FR_DENIED) ShowMessage(denied);
  else {
    text[9] = '0';
    while (result >= 10) {
      ++text[9];
      result -= 10;
    }
    text[10] = '0' + result;
    text[11] = 0;
    ShowMessage(text);
  }
}

static void CopyName(char* dest, const char* src) {
  while ((*dest++ = *src++));
}

// returns 1 if there are no unsaved changes or the user wants to lose them
static unsigned char CanDiscard(void) {
  return !modified || Choose("DISCARD CHANGES?", discard_items[0], 2) == 1;
}

static void ResetCursor(void) {
  cursor = 0;
  counted_pos = 0;
  counted_lines = 0;
  selecting = 0;
  top = 0;
  want_x = 0;
  modified = 0;
  dirty = 1;
}

static void NewFile(void) {
  if (!CanDiscard()) return;
  tb_Clear();
  file_name[0] = 0;
  fs_crlf = 0;
  ResetCursor();
}

// file browser row for list index, if it's on screen (first is the top row's index)
static void ListRow(unsigned int index, unsigned int first, unsigned char kind, const char* name) {
  unsigned char row;
  char* dest;
  if (index < first || index >= first + LIST_ROWS) return;
  row = (unsigned char)(index - first);
  list_kinds[row] = kind;
  list_sizes[row] = entry.size;
  list_dates[row] = entry.date;
  list_times[row] = entry.time;
  dest = ToLatin1(RowAddress(row) + 1, name, TB_STRIDE - 3);
  if (kind == KIND_FOLDER) *dest = '/';
}

// walks path's entries in list order (".." below the root, folders, then files), drawing the ones
// from first on (none if first is LIST_ALL), and stops at index stop or the folder named find,
// leaving it in entry; returns
// the index it stopped at or how many there are, list_result is set if the folder can't be read
static unsigned int ListFolder(const char* path, unsigned int first, unsigned int stop, const char* find) {
  unsigned int index = 0;
  unsigned char pass, i;
  if (first != LIST_ALL) for (pass = 0; pass < LIST_ROWS; ++pass) DrawRow(pass, 0, "");
  list_result = 0;
  entry.size = 0;
  if (path[0]) {
    if (!stop) return 0;
    ListRow(index++, first, KIND_UP, "..");
  }
  for (pass = 0; pass < 2; ++pass) {
    if ((list_result = FileOpenDir(path))) return index;
    while (FileNext(&entry)) {
      if (entry.dir == pass) continue; // folders on the first pass
      if (index == stop) return index;
      if (find && entry.dir) {
        for (i = 0; find[i] && find[i] == entry.name[i]; ++i);
        if (!find[i] && !entry.name[i]) return index;
      }
      ListRow(index, first, pass ? KIND_FILE : KIND_FOLDER, entry.name);
      ++index;
    }
  }
  return find ? 0 : index;
}

// path in the file name bar, what's on row in the status bar
static void ListBars(const char* path, unsigned char row, unsigned char count) {
  char text[TB_STRIDE];
  char* end = text;
  unsigned long size = list_sizes[row];
  unsigned char* bytes = (unsigned char*)&size;
  unsigned int date = list_dates[row], time = list_times[row];
  PutPath(text, path, 30);
  DrawRow(HEADER_LINE, 1, text);
  if (!count) end = PutText(end, "Empty folder");
  else if (list_kinds[row] == KIND_UP) end = PutText(end, "Parent folder");
  else if (list_kinds[row] == KIND_FOLDER) end = PutText(end, "Folder");
  else {
    if (size < 10000) end = PutText(PutNumber(end, (unsigned int)size), " bytes  ");
    else if (size < 10485760) end = PutText(PutNumber(end, (bytes[1] >> 2) | (bytes[2] << 6)), " KB  ");
    else end = PutText(PutNumber(end, (bytes[2] >> 4) | (bytes[3] << 4)), " MB  ");
    end = PutNumber(end, (date >> 9) + 1980);
    *end++ = '-';
    end = PutNumber2(end, (date >> 5) & 15);
    *end++ = '-';
    end = PutNumber2(end, date & 31);
    *end++ = ' ';
    end = PutNumber2(end, time >> 11);
    *end++ = ':';
    end = PutNumber2(end, (time >> 5) & 63);
    if (size > TB_SIZE) end = PutText(end, "  too big");
  }
  *end = 0;
  DrawRow(STATUS_LINE, 1, text);
}

// new path in the file name bar and a Loading... box over the list, with row's folder added to path
// if row isn't 0xFF (shown before reading the folder again for its full name)
static void ListLoading(const char* path, unsigned char row) {
  char text[PATH_SIZE + TB_STRIDE];
  char* end = path[0] ? ToLatin1(text, path, PATH_SIZE - 1) : text;
  char* name;
  unsigned char length;
  if (row != 0xFF) {
    *end++ = '/';
    for (name = RowAddress(row) + 1; *name != '/'; ++name) *end++ = *name;
  }
  else if (!path[0]) *end++ = '/';
  *end = 0;
  length = (unsigned char)(end - text);
  end = text;
  if (length > 30) {
    end += length - 33;
    end[0] = end[1] = end[2] = '.';
  }
  DrawRow(HEADER_LINE, 1, end);
  DrawRow(STATUS_LINE, 1, "");
  ShowBusy("Loading...");
}

// shows text in the status bar until a key is pressed
static void ListMessage(const char* text) {
  HideBox();
  DrawRow(STATUS_LINE, 1, text);
  EditorDraw();
  while (!MenuKey());
}

// file browser, opens the chosen file into the text buffer, returns 1 if it did
// up, down, page up/down, home, end move, enter/right/A opens, left/backspace/B goes up, escape/B at the root cancels
static unsigned char Browse(void) {
  char path[PATH_SIZE + FS_NAME_SIZE]; // folder, and the file's path when opening it
  char name[FS_NAME_SIZE];
  unsigned int count = 0, selected = 0, first = 0, drawn = LIST_ALL;
  unsigned char key, result, row, opened = 0, editor_font = font, length;
  CopyName(path, file_dir);
  font = FONT_VWF;
  SetFont(font);
  EditorShowCursor(0);
  if (osk_shown) OSKShow(0);
  bars = 1;
  tb_rows = LIST_ROWS;
  Layout();
  NoHighlight();
  ListLoading(path, 0xFF);
  if ((result = FileMount())) {
    ShowError(result, "");
    selected = 0xFFFF; // skips the list
  }
  while (selected != 0xFFFF) {
    if (selected < first) first = selected;
    else if (selected >= first + LIST_ROWS) first = selected - LIST_ROWS + 1;
    if (first != drawn) {
      if (drawn == LIST_ALL && render_box_top == 0xFF) ListLoading(path, 0xFF); // a new folder
      count = ListFolder(path, first, LIST_ALL, 0);
      HideBox();
      drawn = first;
      if (list_result) {
        if (!path[0]) { // can't read the card
          ShowError(list_result, "");
          break;
        }
        path[0] = 0; // folder is gone, back to the root
        selected = 0;
        drawn = LIST_ALL;
        continue;
      }
    }
    row = (unsigned char)(selected - first);
    ListBars(path, row, count);
    NoHighlight();
    if (count) render_sel[(row + 1) << 1] = 0, render_sel[((row + 1) << 1) + 1] = 0xFF;
    EditorDraw();
    while (!(key = MenuKey()));
    if (key == KEY_UP && selected) --selected;
    else if (key == KEY_DOWN && selected + 1 < count) ++selected;
    else if (key == KEY_PAGE_UP) selected = selected > LIST_ROWS ? selected - LIST_ROWS : 0;
    else if (key == KEY_PAGE_DOWN && count) selected = selected + LIST_ROWS < count ? selected + LIST_ROWS : count - 1;
    else if (key == KEY_HOME) selected = 0;
    else if (key == KEY_END && count) selected = count - 1;
    else if ((key == KEY_ENTER || key == KEY_RIGHT) && count && list_kinds[row] != KIND_UP) {
      if (list_kinds[row] == KIND_FOLDER) ListLoading(path, row);
      else ShowBusy("Loading...");
      ListFolder(path, LIST_ALL, selected, 0);
      for (length = 0; path[length]; ++length);
      if (entry.dir) {
        if (JoinPath(path + length, "", entry.name, PATH_SIZE - length)) {
          selected = 0;
          drawn = LIST_ALL;
        }
        else {
          path[length] = 0;
          ListMessage("Path is too long");
        }
      }
      else if (entry.size > TB_SIZE) ListMessage("Too big to open");
      else {
        JoinPath(path + length, "", entry.name, FS_NAME_SIZE + 1);
        result = FileLoad(path);
        HideBox();
        path[length] = 0;
        if (result) {
          file_name[0] = 0; // the text buffer only has part of it, don't save over the file
          ShowError(result, "TOO BIG");
        }
        else {
          CopyName(file_dir, path);
          CopyName(file_name, entry.name);
        }
        opened = 1;
        break;
      }
    }
    else if (path[0] && (key == KEY_LEFT || key == KEY_BACKSPACE || key == KEY_ESCAPE ||
                         ((key == KEY_ENTER || key == KEY_RIGHT) && count && list_kinds[row] == KIND_UP))) {
      for (length = 0; path[length]; ++length);
      while (path[--length] != '/');
      CopyName(name, path + length + 1);
      path[length] = 0;
      ListLoading(path, 0xFF);
      selected = ListFolder(path, LIST_ALL, LIST_ALL, name); // back on the folder it came from
      drawn = LIST_ALL;
    }
    else if (key == KEY_ESCAPE) break;
  }
  font = editor_font;
  SetFont(font);
  SetRows();
  return opened;
}

static void OpenFile(void) {
  if (!CanDiscard()) return;
  if (Browse()) ResetCursor();
}

// file name chars, not / \ : * ? " < > |
static unsigned char NameChar(unsigned char c) {
  if (c < ' ' || (c >= 0x7F && c < 0xA0)) return 0;
  return c != '/' && c != 0x5C && c != ':' && c != '*' && c != '?' && c != '"' && c != '<' && c != '>' && c != '|';
}

// asks for a name, sets file_name, returns 0 if cancelled
static unsigned char AskFileName(void) {
  char name[NAME_CHARS + 1];
  char text[TB_STRIDE + 1];
  unsigned char length, key, i;
  char* end;
  length = (unsigned char)(ToLatin1(name, file_name, NAME_CHARS) - name);
  Render();
  EditorShowCursor(0);
  NoHighlight();
  while (1) {
    end = PutText(text, "Save as ");
    for (i = 0; i < length; ++i) *end++ = name[i];
    *end++ = '_';
    *end = 0;
    if (bars) {
      DrawRow(HEADER_LINE, 1, text);
      end = PutText(text, "in ");
      PutPath(end, file_dir, 28);
      DrawRow(STATUS_LINE, 1, text);
    }
    else DrawRow(0, 0, text);
    EditorDraw();
    do {
      WaitFrame();
      key = (unsigned char)KBPopEvent();
      if (!key) key = PadKey();
    } while (!key);
    if (key == KEY_ENTER && length) break;
    if (key == KEY_ESCAPE || (key == KEY_BACKSPACE && !length)) {
      dirty = 1;
      return 0;
    }
    if (key == KEY_BACKSPACE) --length;
    else if (length < NAME_CHARS && NameChar(key)) name[length++] = key;
  }
  name[length] = 0;
  ToUtf8(file_name, name);
  dirty = 1;
  return 1;
}

static void SaveFile(unsigned char ask) {
  char path[PATH_SIZE + FS_NAME_SIZE];
  unsigned char result;
  if ((ask || !file_name[0]) && !AskFileName()) return;
  JoinPath(path, file_dir, file_name, (unsigned char)(PATH_SIZE + FS_NAME_SIZE));
  ShowBusy("Saving...");
  result = FileMount();
  if (!result) result = FileSave(path);
  HideBox();
  if (result) {
    ShowError(result, "DISK FULL");
    return;
  }
  modified = 0;
  ShowMessage("SAVED");
}

// switches between the fixed and variable width fonts
static void ToggleFont(void) {
  font = font == FONT_VWF ? FONT_MONO : FONT_VWF;
  SetFont(font);
  dirty = 1;
}

// F1, shown with the variable width font
static void ShowHelp(void) {
  unsigned char row, editor_font = font;
  font = FONT_VWF;
  SetFont(font);
  BeginFullScreen();
  for (row = 0; row < HELP_ROWS; ++row) DrawRow(row, 0, help_lines[row]);
  EditorDraw();
  while (!MenuKey());
  font = editor_font;
  SetFont(font);
  EndFullScreen();
}

static void FileMenu(void) {
  switch (Choose("MENU", menu_items[0], 7)) {
    case 0: OpenFile(); break;
    case 1: SaveFile(0); break;
    case 2: SaveFile(1); break;
    case 3: NewFile(); break;
    case 4: ToggleFont(); break;
    case 5: ToggleBars(); break;
    case 6: ShowHelp(); break;
  }
}

// shortcuts: escape or the keyboard's menu key, F1, F11, ctrl + O, S, N, F
static unsigned char HandleFileKey(unsigned char key, unsigned char mods) {
  if (key == KEY_MENU || key == KEY_ESCAPE) FileMenu();
  else if (key == KEY_F1) ShowHelp();
  else if (key == KEY_F11) ToggleBars();
  else if (!(mods & KB_MOD_CTRL)) return 0;
  else if (key == 'o' || key == 'O') OpenFile();
  else if (key == 's' || key == 'S') SaveFile(0);
  else if (key == 'n' || key == 'N') NewFile();
  else if (key == 'f' || key == 'F') ToggleFont();
  else return 0;
  dirty = 1;
  return 1;
}

static void Render(void) {
  tb_find = cursor;
  tb_Render(top);
}

// renders, scrolling to keep the cursor visible
static void Refresh(void) {
  unsigned int row, bottom;
  unsigned char i;
  if (top > tb_Length()) top = tb_Length();
  top = tb_RowStart(top); // wrapping may have changed
  Render();
  if (tb_found_row == 0xFF) {
    row = tb_RowStart(cursor);
    if (cursor < top) {
      if (top && row == tb_RowStart(top - 1)) ScrollRing(0); // one row up
      top = row;
    }
    else { // scroll until the cursor is on the last row, jump if it's more than a screen away
      bottom = tb_row_starts[tb_rows];
      for (i = tb_rows; i; --i) {
        top = tb_NextRow(top);
        if (bottom == row) break;
        bottom = tb_NextRow(bottom);
      }
      if (!i) { // the cursor's row goes at the bottom
        top = row;
        for (i = tb_rows - 1; i && top; --i) top = tb_RowStart(top - 1);
      }
      else if (i == tb_rows) ScrollRing(1); // one row down
    }
    Render();
  }
  Draw();
  redraw = 0;
  moved = 0;
  PlaceCursor();
}

void Editor(void) {
  unsigned int event;
  unsigned char key;

  EditorSetup();
  for (key = 0; key < BG_MAP_ROWS; ++key) map_blocks[key] = key < TB_ROWS ? key : 0xFF; // set by RenderSetup
  everdrive = sd_Detect();
  idle_frames = 0;
  normalized = 0;
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
  font = FONT_VWF;
  file_name[0] = 0;
  file_dir[0] = 0;
  fs_crlf = 0;
  osk_shown = 0;
  osk_layer = OSK_LOWER;
  osk_x = 0;
  osk_y = 0;
  bars_on = 1;
  SetRows();
  Refresh();

  while (1) {
    if (bars_changed) { // status bar follows the cursor
      bars_changed = 0;
      if (bars) Draw();
    }
    WaitFrame();
    while ((key = (unsigned char)(event = KBPopEvent()))) {
      if (!HandleFileKey(key, (unsigned char)(event >> 8))) HandleKey(key, (unsigned char)(event >> 8));
      if (dirty || edited) break; // text changed, rows need rendering before more keys
      if (moved) { // keeps tb_found_row current for the next key
        if (!PlaceCursor()) dirty = 1;
        moved = 0;
      }
    }
    if ((key = PadKey())) {
      if (!HandleFileKey(key, 0)) HandleKey(key, 0);
    }
    if (dirty || edited || redraw || moved) idle_frames = 0;
    if (dirty) {
      Refresh();
      dirty = 0;
      edited = 0;
      normalized = 0;
      continue;
    }
    if (edited) {
      edited = 0;
      normalized = 0;
      RenderAfterEdit();
      if (!PlaceCursor()) {
        if (cursor >= tb_row_starts[tb_rows] && tb_RowStart(cursor) == tb_row_starts[tb_rows]) ScrollDown();
        else if (top && cursor < top && tb_RowStart(cursor) == tb_RowStart(top - 1)) ScrollUp(tb_RowStart(cursor));
        else {
          Refresh();
          continue;
        }
        PlaceCursor();
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
    if (idle_frames < NORMALIZE_DELAY) ++idle_frames;
    else if (!everdrive && !normalized) normalized = tb_NormalizeStep(); // keeps the .sav readable as text
    if (++blink_timer == CURSOR_BLINK) EditorShowCursor(0);
    else if (blink_timer == CURSOR_BLINK + CURSOR_BLINK) {
      EditorShowCursor(1);
      blink_timer = 0;
    }
  }
}
