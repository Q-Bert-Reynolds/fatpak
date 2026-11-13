// HELP (editor and browser): a scrolling page of 32-byte records from EDITOR.DAT,
// record 0 the title, 1-31 the body. The host sets up the view and passes which text.
#include "../build/modules/sdk.h"
#include "../src/ui/icons.h"

#define HELP_ROWS (TB_ROWS - 2)
#define HELP_LINES 32

static char line[LANG_MAX + 1]; // a help record, or the footer
static unsigned char base; // the context's first record

// Without EDITOR.DAT the rows are empty, as before.
static void Record(unsigned char row, unsigned char record) {
  if (ModData(DATA_HELP * 512u + ((unsigned int)(base + record) << 5), line, 32)) line[0] = 0;
  line[32] = 0;
  ModText(row, 1, line);
}

unsigned char ModuleMain(const unsigned char* browser) {
  unsigned char row, first = 0, next, down, key;
  base = *browser ? HELP_LINES : 0;
  ModHideBox(); // the host's loading box
  Record(HEADER_LINE, 0);
  ModString(line, S_HELP_HINT);
  ModText(STATUS_LINE, 1, line);
  for (row = 0; row < HELP_ROWS; ++row) Record(row, row + 1);
  while (1) {
    key = ModKey();
    if (key == KEY_BACKSPACE || key == KEY_ESCAPE) break;
    next = first;
    if (key == KEY_UP && first) --next;
    else if (key == KEY_DOWN && first < HELP_LINES - 1 - HELP_ROWS) ++next;
    else if (key == KEY_PAGE_UP) next = 0;
    else if (key == KEY_PAGE_DOWN) next = HELP_LINES - 1 - HELP_ROWS;
    while (first != next) { // a row at a time, so the screen ring keeps its drawn rows
      down = next > first;
      if (down) ++first; else --first;
      ModScroll(down);
      Record(down ? HELP_ROWS - 1 : 0, first + (down ? HELP_ROWS : 1));
      ModDraw();
    }
  }
  return 0;
}
