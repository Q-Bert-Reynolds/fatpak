// Text layout, selection, cursor visibility and status bars.
#include "view.h"
#include "../browser/paths.h"
#include "editor.h"
#include "osk.h"
#include "settings.h"
#include "state.h"
#include "text_buffer.h"
#include "../fatfs/file_api.h"
#include "../ui/render.h"
#include "../ui/screen.h"
#include "../ui/text.h"

#define KEEP_LEFT  40 // pixels of text left of the cursor after scrolling sideways to the right (more near the line's end)
#define KEEP_RIGHT 120 // after scrolling to the left, most of the screen shows where it's going
#define CODE_WIDTH 4 // FONT_FIXED's, markdown code is drawn with it
#define MD_FENCE_STATE 0x4000 // tb_row_states: in a markdown code block (MD_FENCE)

unsigned int counted_pos; // counted_lines line feeds are before counted_pos
unsigned int counted_lines;
static unsigned char head_level; // current markdown heading font, or zero
static unsigned char code_line; // horizontal scroll is in a markdown code block

static unsigned char RowEndsLine(unsigned char row);

// rendered row pos is on, 0xFF if it isn't on screen
static unsigned char FindRow(unsigned int pos) {
  unsigned char row;
  for (row = 0; row < tb_rows; ++row) {
    if (pos < tb_row_starts[row]) return 0xFF;
    if (pos < tb_row_starts[row + 1]) return row;
  }
  return pos == tb_Length() ? tb_end_row : 0xFF;
}

// position of the line feed that ends a rendered row when lines don't wrap, or the end of the text
unsigned int LineEnd(unsigned char row) {
  return row == tb_end_row ? tb_Length() : tb_row_starts[row + 1] - 1;
}

// moves the cursor sprite to the cursor, returns 0 if it isn't on screen
unsigned char PlaceCursor(void) {
  unsigned char row = FindRow(cursor), count;
  unsigned int col;
  if (row == 0xFF) return 0;
  col = cursor - tb_row_starts[row];
  count = tb_row_counts[row];
  if (tb_nowrap) { // its character is drawn, or it's after the line's last one
    if (col < tb_left) return 0;
    col -= tb_left;
    if (col > count || (col == count && cursor != LineEnd(row))) return 0;
  }
  else if (col > count) col = count; // hanging spaces
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
unsigned int PosAtX(unsigned char row, unsigned char x) {
  unsigned char* attrs = (unsigned char*)RowAddress(row) + (tile_attrs - tile_buffer);
  unsigned char count = tb_row_counts[row], col = 0, width;
  unsigned int pos;
  while (col < count) {
    width = attrs[col] & STYLE_WIDTH;
    if (x < ((width + 1) >> 1)) break;
    x = x < width ? 0 : x - width;
    ++col;
  }
  pos = tb_row_starts[row] + col;
  if (tb_nowrap) {
    pos += tb_left;
    return pos > LineEnd(row) ? LineEnd(row) : pos;
  }
  if (col == count && pos == tb_row_starts[row + 1] && tb_end_row != row) --pos; // stay on wrapped row
  return pos;
}

// text rows: all but the bars and the on screen keyboard
static unsigned char TextRows(void) {
  return TB_ROWS - (bars << 1) - (osk_shown ? OSK_ROWS : 0);
}

// scrolls one row down, only the new bottom row is scanned and drawn
void ScrollDown(void) {
  ScrollRing(1);
  tb_ScrollRows(1);
  tb_RenderRows(tb_rows - 1, tb_rows);
  top = tb_row_starts[0];
  redraw = 1;
}

// scrolls one row up to the row starting at new_top
void ScrollUp(unsigned int new_top) {
  ScrollRing(0);
  tb_ScrollRows(0);
  tb_row_starts[0] = new_top;
  tb_RenderRows(0, 1);
  top = new_top;
  redraw = 1;
}

// re-renders rows after an edit, stopping once a row starts where it used to (moved by the edit) with the same style state
// NOTE: SDCC 4.2 clobbered hl when edit_delta was read inside these expressions, so it's copied first
void RenderAfterEdit(void) {
  unsigned char row = edit_row, end_row = tb_end_row, i;
  unsigned int old_next, old_state, expected, delta = (unsigned int)(int)edit_delta;
  if (row) --row; // the previous row's wrapping can change too
  if (end_row != 0xFF && end_row >= row) tb_end_row = 0xFF; // found again while scanning
  for (; row < tb_rows; ++row) {
    old_next = tb_row_starts[row + 1];
    old_state = tb_row_states[row + 1];
    expected = old_next + delta;
    tb_RenderRows(row, row + 1);
    if (old_next > edit_pos && tb_row_starts[row + 1] == expected && tb_row_states[row + 1] == old_state) {
      for (i = row + 2; i <= tb_rows; ++i) tb_row_starts[i] += delta; // rows below just moved
      if (end_row != 0xFF && end_row > row) tb_end_row = end_row;
      break;
    }
  }
  redraw = 1;
}

// sets the selected columns of each rendered row for EditorDraw
static void SetHighlight(void) {
  unsigned char row, first, end, count;
  unsigned int row_start, next, base;
  NoHighlight();
  if (!GetSelection()) return;
  for (row = 0; row < tb_rows; ++row) {
    row_start = tb_row_starts[row];
    next = tb_row_starts[row + 1];
    if (sel_end <= row_start) break;
    if (sel_start >= next) continue;
    count = tb_row_counts[row];
    base = row_start + (tb_nowrap ? tb_left : 0); // first drawn character
    first = 0;
    if (sel_start > base) first = sel_start - base > count ? count : (unsigned char)(sel_start - base);
    if (sel_end < next || row == tb_end_row) { // ends in this row
      end = sel_end <= base ? 0 : sel_end - base > count ? count : (unsigned char)(sel_end - base);
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
void CountEdit(unsigned int pos, unsigned char c, unsigned char inserted) {
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
void Uncount(unsigned int pos) {
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

// file name (* = unsaved changes) and line and column, or how many chars are selected
void UpdateBars(void) {
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
    if (!doc_large) end = PutNumber(end, CursorLine());
    else if (lines_known) end = PutNumber(end, CursorLine() + win_lines);
    else *end++ = '?';
    end = PutText(end, ", Col ");
    end = PutNumber(end, CursorColumn());
  }
  *end = 0;
  DrawRow(STATUS_LINE, 1, text);
}

void Draw(void) {
  SetHighlight();
  if (bars) UpdateBars();
  EditorDraw();
}

// sets the text rows and lays out the screen for bars_on and osk_shown
void SetRows(void) {
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

// F11
void ToggleBars(void) {
  bars_on = !bars_on;
  SetRows();
  SettingsSave();
}

// hides the bars, on screen keyboard and cursor for full screen UI, redraws the text afterwards
void BeginFullScreen(void) {
  EditorShowCursor(0);
  if (osk_shown) OSKShow(0);
  bars = 0;
  tb_rows = TB_ROWS;
  Layout();
  NoHighlight();
  dirty = 1;
}

void EndFullScreen(void) {
  SetRows();
}

void Render(void) {
  tb_find = cursor;
  tb_Render(top);
}

static unsigned char CharWidth(unsigned char c) {
  if (c < ' ') c = ' '; // control characters are drawn as spaces
  if (code_line) return CODE_WIDTH;
  return head_level ? HeadingCharWidth(head_level, c) : font_widths[c];
}

// sets head_level and code_line for the line at start, on screen row row (0xFF = not on screen)
// (close enough to scroll by, bold and inline code aren't counted)
static void LineHeading(unsigned int start, unsigned char row) {
  unsigned int pos = start, length = tb_Length();
  head_level = 0;
  code_line = 0;
  if (tb_lang != LANG_MD) return;
  while (pos < length && pos - start < 3 && tb_GetChar(pos) == '`') ++pos;
  if (pos - start == 3 || (row != 0xFF && (tb_row_states[row] & MD_FENCE_STATE))) { code_line = 1; return; }
  pos = start;
  while (pos < length && pos - start < 7 && tb_GetChar(pos) == '#') ++pos;
  if (pos == start || pos - start > 4 || pos == length || tb_GetChar(pos) != ' ') return;
  head_level = (unsigned char)(pos - start);
}

// lines don't wrap: scrolls them sideways if the cursor's character isn't drawn (or it isn't on
// screen after the line's last one), returns 1 if tb_left changed
static unsigned char ScrollX(void) {
  unsigned char row = tb_found_row, count;
  unsigned int start = row == 0xFF ? tb_LineStart(cursor) : tb_row_starts[row];
  unsigned int col = cursor - start, length = tb_Length(), pos, x = 0, left;
  unsigned char c, keep = KEEP_LEFT;
  if (col < tb_left) keep = KEEP_RIGHT;
  else if (row != 0xFF) { // its char is drawn, or it's the line's end right of its last one
    count = tb_row_counts[row];
    if (col - tb_left < count) return 0;
    if (col - tb_left == count && cursor == LineEnd(row) && RenderCursorX(count) < TB_WIDTH - 1) return 0;
  }
  LineHeading(start, row);
  if (keep == KEEP_LEFT) { // more if the line ends sooner, so the screen isn't left empty
    for (pos = cursor, x = 0; pos < length && (c = tb_GetChar(pos)) != ASCII_LF && x <= TB_WIDTH; ++pos) x += CharWidth(c);
    if (x < TB_WIDTH - 1 - KEEP_LEFT) keep = TB_WIDTH - 1 - x;
  }
  for (left = col, x = 0; left; --left) {
    if ((x += CharWidth(tb_GetChar(start + left - 1))) > keep) break;
  }
  if (left == tb_left) return 0;
  tb_left = left;
  return 1;
}

// renders, scrolling to keep the cursor visible
void Refresh(void) {
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
  if (tb_nowrap && ScrollX()) Render();
  Draw();
  redraw = 0;
  moved = 0;
  PlaceCursor();
}
