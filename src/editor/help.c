// Text editor controls screen.
#include "help.h"
#include "view.h"
#include "../input.h"
#include "../ui/render.h"
#include "../ui/screen.h"

#define HELP_ROWS        18
#define HELP_COLS        36

static const char help_lines[HELP_ROWS][HELP_COLS] = {
  "HELP",
  "Esc  menu      F1  help",
  "F11  full screen",
  "Ctrl+O, S, N  open, save, new",
  "Alt+Z  line wrap",
  "Shift + moving  select",
  "Ctrl+A  select all",
  "Ctrl+X, C, V  cut, copy, paste",
  "Ctrl+Z, Y  undo, redo",
  "Ctrl+Left, Right  move by word",
  "Ctrl+Up, Down  scroll",
  "Ctrl+Home, End  start or end",
  "",
  "Select  on screen keyboard",
  "A  type the selected key",
  "B  backspace    Start  menu",
  "D-pad  move    A + D-pad  select",
  "Press any key to close",
};

// F1, shown with the variable width font
void ShowHelp(void) {
  unsigned char row, editor_font = font;
  font = FONT_VWF;
  SetFont(font);
  render_text = 0;
  BeginFullScreen();
  for (row = 0; row < HELP_ROWS; ++row) DrawRow(row, 0, help_lines[row]);
  EditorDraw();
  while (!MenuKey());
  font = editor_font;
  SetFont(font);
  render_text = 1;
  EndFullScreen();
}
