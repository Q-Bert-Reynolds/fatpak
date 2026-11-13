// Sliding windows for documents larger than the text buffer.
#include "window.h"
#include "../app/dialogs.h"
#include "state.h"
#include "text_buffer.h"
#include "undo.h"
#include "view.h"
#include "../fatfs/file_api.h"
#include "../ui/dialogs.h"
#include "../ui/text.h"

#define WIN_MARGIN 0x2000 // the window moves when the cursor is this close to an edge that isn't the file's
#define NO_MARK 0xFFFFFFFF

// an edited window goes into the document before it moves, returns 0 if it can't (then it doesn't move)
static unsigned char Commit(void) {
  if (FileCommitWindow()) return 1;
  ShowMessage(Str(S_TOO_MANY_EDITS));
  return 0;
}

// loads the window from win_start, the undo history was for the old one
static void LoadWindow(void) {
  if (FileLoadWindow()) ShowMessage(Str(S_SD_ERROR));
  UndoClear(modified);
  Uncount(0);
  dirty = 1;
}

// after a slide, positions in the text buffer move back by shift (forward if down = 0), ones that leave it
// are clamped (a selection is cleared)
static void ShiftPositions(unsigned int shift, unsigned char down) {
  unsigned int length = tb_Length();
  if (down) {
    cursor = cursor > shift ? cursor - shift : 0;
    top = top > shift ? top - shift : 0;
    if (anchor < shift) selecting = 0;
    else anchor -= shift;
  }
  else {
    cursor += shift;
    top += shift;
    if (anchor + shift > length) selecting = 0;
    else anchor += shift;
  }
  if (cursor > length) cursor = length;
  if (top > length) top = length;
  Uncount(0);
  dirty = 1;
}

// line feeds before win_start aren't known after a jump: they're counted in the background (ScanLines),
// win_lines counts from scan_target until then
static void LinesUnknown(void) {
  lines_known = 0;
  win_lines = 0;
  scan_target = win_start;
  scan_pos = 0;
  scan_lines = 0;
}

// moves the window when the cursor is near an edge with more of the file past it, so the cursor ends up
// near its middle. Windows start at a line start
void Slide(void) {
  unsigned int length = tb_Length(), shift, target;
  unsigned char i;
  if (cursor < WIN_MARGIN ? !win_start : (cursor + WIN_MARGIN <= length || win_end == doc_len)) return;
  if (!Commit()) return;
  win_mark = NO_MARK;
  if (cursor >= WIN_MARGIN) { // from a sector boundary half a window before the cursor
    target = cursor - WIN_SIZE / 2;
    for (i = win_chunks - 1; i && win_kept[i] > target; --i);
    if (!i) return;
    doc_pos = ((win_start + 511) & ~511UL) + ((unsigned long)i << 9);
    DocLineStart();
    shift = win_kept[i] - doc_back;
    win_lines += tb_CountLines(0, shift);
    win_start = doc_pos;
    LoadWindow();
    ShiftPositions(shift, 1);
  }
  else { // half a window back, the old start's position is the shift
    doc_pos = win_start > WIN_SIZE / 2 ? win_start - WIN_SIZE / 2 : 0;
    DocLineStart();
    win_mark = win_start;
    win_start = doc_pos;
    LoadWindow();
    shift = win_mark_pos == 0xFFFF ? 0 : win_mark_pos;
    win_lines -= tb_CountLines(0, shift);
    ShiftPositions(shift, 0);
  }
}

// Ctrl+Home, the file's start
void GoStart(void) {
  if (doc_large && win_start && Commit()) {
    selecting = 0;
    win_start = win_lines = 0;
    win_mark = NO_MARK;
    lines_known = 1;
    LoadWindow();
  }
  cursor = 0;
}

// Ctrl+End, the file's end
void GoEnd(void) {
  if (doc_large && win_end != doc_len && Commit()) {
    selecting = 0;
    doc_pos = doc_len - WIN_SIZE / 2; // the window isn't the whole file, so it's longer than this
    DocLineStart();
    win_start = doc_pos;
    win_mark = NO_MARK;
    LoadWindow();
    LinesUnknown();
  }
  cursor = tb_Length();
}
