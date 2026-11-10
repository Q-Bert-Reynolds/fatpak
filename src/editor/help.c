// Context-specific help, using the same padded rows and scrolling ring as the editor.
#include "help.h"
#include "osk.h"
#include "view.h"
#include "../input.h"
#include "../ui/render.h"
#include "../ui/screen.h"
#include "../ui/text.h"

extern void SetWindowBlock(unsigned int block);
#define WINDOW_BLOCK (*(volatile unsigned int*)0xBD02)
#define HELP_ROWS (TB_ROWS - 2)
#define HELP_LINES 32

// line is an absolute record in the two help texts. DrawRow pads with spaces;
// copying a terminator into the tile buffer would render the font's glyph 0.
static void HelpRow(unsigned char row, unsigned char line) {
  unsigned int saved = WINDOW_BLOCK;
  if (data_loaded) {
    SetWindowBlock(DATA_BLOCK + DATA_HELP + (line >> 4));
    DrawRow(row, 1, (const char*)(0xBE00u + ((line & 15) << 5)));
  }
  else DrawRow(row, 1, "");
  SetWindowBlock(saved);
}

static void HelpView(unsigned char browser) {
  unsigned char row, first = 0, next, down, key, base = browser << 5;
  unsigned char old_font = font, styled = render_text, old_osk = osk_shown;
  font = FONT_VWF;
  SetFont(font);
  render_text = 0;
  BeginView(1);
  osk_shown = 0;
  HelpRow(HEADER_LINE, base);
  DrawRow(STATUS_LINE, 1, "Up/Down: scroll  B: exit");
  for (row = 0; row < HELP_ROWS; ++row) HelpRow(row, base + row + 1);
  EditorDraw();
  while (1) {
    key = MenuKey();
    if (key == KEY_BACKSPACE || key == KEY_ESCAPE) break;
    next = first;
    if (key == KEY_UP && first) --next;
    else if (key == KEY_DOWN && first < HELP_LINES - 1 - HELP_ROWS) ++next;
    else if (key == KEY_PAGE_UP) next = 0;
    else if (key == KEY_PAGE_DOWN) next = HELP_LINES - 1 - HELP_ROWS;
    while (first != next) {
      down = next > first;
      if (down) ++first; else --first;
      ScrollRows(down);
      HelpRow(down ? HELP_ROWS - 1 : 0, base + first + (down ? HELP_ROWS : 1));
      EditorDraw();
    }
  }
  font = old_font;
  SetFont(font);
  render_text = styled;
  osk_shown = old_osk;
  EndFullScreen();
}

void ShowHelp(void) { HelpView(0); }
void ShowBrowserHelp(void) { HelpView(1); }
