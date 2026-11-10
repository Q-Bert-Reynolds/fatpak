// Context-specific help text, shared scrolling and drawing.
#include "help.h"
#include "view.h"
#include "../input.h"
#include "../ui/render.h"
#include "../ui/screen.h"
#include "../ui/footer.h"
#include "../ui/text.h"

extern void SetWindowBlock(unsigned int block);
#define WINDOW_BLOCK (*(volatile unsigned int*)0xBD02)
#define HELP_ROWS 17
#define HELP_LINES 32

static void HelpView(unsigned char browser) {
  unsigned char row, line, first = 0, key, old_font = font, styled = render_text;
  unsigned int saved;
  font = FONT_VWF;
  SetFont(font);
  render_text = 0;
  BeginFullScreen();
  while (1) {
    saved = WINDOW_BLOCK;
    for (row = 0; row < HELP_ROWS; ++row) {
      DrawRow(row, 0, "");
      line = first + row;
      if (data_loaded) {
        SetWindowBlock(DATA_BLOCK + DATA_HELP + (browser << 1) + (line >> 4));
        CopyName(RowAddress(row), (const char*)(0xBE00u + ((line & 15) << 5)));
      }
    }
    SetWindowBlock(saved);
    FooterDraw(HELP_ROWS, 0, "Up/Down: scroll  B: exit");
    EditorDraw();
    do { key = MenuKey(); } while (!key);
    if (key == KEY_BACKSPACE || key == KEY_ESCAPE) break;
    if (key == KEY_UP && first) --first;
    else if (key == KEY_DOWN && first < HELP_LINES - HELP_ROWS) ++first;
    else if (key == KEY_PAGE_UP) first = 0;
    else if (key == KEY_PAGE_DOWN) first = HELP_LINES - HELP_ROWS;
  }
  font = old_font;
  SetFont(font);
  render_text = styled;
  EndFullScreen();
}

void ShowHelp(void) { HelpView(0); }
void ShowBrowserHelp(void) { HelpView(1); }
