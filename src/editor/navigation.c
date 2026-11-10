// Cursor movement through rendered rows and words.
#include "navigation.h"
#include "state.h"
#include "text_buffer.h"
#include "view.h"
#include "../ui/screen.h"

// sets the first rendered row and renders
static void ScrollTo(unsigned int new_top) {
  top = new_top;
  Render();
  redraw = 1;
}

void MoveUp(void) {
  unsigned char row = tb_found_row;
  keep_x = 1;
  if (row) cursor = PosAtX(row - 1, want_x);
  else if (!top) cursor = 0;
  else {
    ScrollUp(tb_RowStart(top - 1));
    cursor = PosAtX(0, want_x);
  }
}

void MoveDown(void) {
  unsigned char row = tb_found_row;
  keep_x = 1;
  if (tb_end_row == row) cursor = tb_Length(); // last row
  else if (row + 1 < tb_rows) cursor = PosAtX(row + 1, want_x);
  else {
    ScrollDown();
    cursor = PosAtX(row, want_x);
  }
}

void PageUp(void) {
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

void PageDown(void) {
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
void MoveEnd(void) {
  unsigned char row = tb_found_row, count = tb_row_counts[row];
  if (tb_nowrap) {
    cursor = LineEnd(row);
    return;
  }
  cursor = tb_row_starts[row] + count;
  if (count && cursor == tb_row_starts[row + 1] && tb_end_row != row && RowAddress(row)[count - 1] == ' ') --cursor;
}

// 0 = space, 1 = word (letters, digits, _), 2 = punctuation
static unsigned char CharClass(unsigned char c) {
  if (c == ' ' || c == ASCII_TAB || c == ASCII_LF) return 0;
  if ((c >= '0' && c <= '9') || (c >= 'A' && c <= 'Z') || (c >= 'a' && c <= 'z') || c == '_' || c >= 0xC0) return 1;
  return 2;
}

// to the end of the next token, skipping spaces
void WordRight(void) {
  unsigned int length = tb_Length();
  unsigned char token;
  while (cursor < length && !CharClass(tb_GetChar(cursor))) ++cursor;
  if (cursor == length) return;
  token = CharClass(tb_GetChar(cursor));
  do ++cursor;
  while (cursor < length && CharClass(tb_GetChar(cursor)) == token);
}

// to the start of the previous token, skipping spaces
void WordLeft(void) {
  unsigned char token;
  while (cursor && !CharClass(tb_GetChar(cursor - 1))) --cursor;
  if (!cursor) return;
  token = CharClass(tb_GetChar(cursor - 1));
  do --cursor;
  while (cursor && CharClass(tb_GetChar(cursor - 1)) == token);
}

// scrolls one row, the cursor only moves if its row leaves the screen
void ScrollLine(unsigned char down) {
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
