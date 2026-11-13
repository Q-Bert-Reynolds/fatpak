// Dialog interaction and status messages over the active editor/browser view.
#include "dialogs.h"
#include "../editor/editor.h"
#include "../editor/osk.h"
#include "../editor/state.h"
#include "../editor/view.h"
#include "../editor/text_buffer.h"
#include "../fatfs/file_api.h"
#include "../input.h"
#include "../ui/dialogs.h"
#include "../ui/render.h"
#include "../ui/screen.h"
#include "../ui/text.h"

// FRESULT codes used by the status-message formatter (fatfs/lib/ff.h).
#define FR_NOT_READY     3
#define FR_DENIED        7
#define FR_NO_FILESYSTEM 13

// shows count strings from items in a box over the text (under title, 0 = none, wrapped like
// BoxText) with item selected highlighted, returns the chosen index, BACK or CANCEL
unsigned char Choose(const char* title, unsigned int items, unsigned char count, unsigned char selected) {
  unsigned char i, key, first = title ? BoxText(0, title) : 0;
  char* line = RowAddress(BOX_LINE) + first * BOX_STRIDE;
  for (i = 0; i < count; ++i, line += BOX_STRIDE) {
    line[0] = ' ';
    PutStr(line + 1, items + i);
  }
  EditorShowCursor(0);
  if (osk_shown) OSKShow(0);
  OpenBox(count + first);
  while (1) {
    render_box_sel = selected + first + 1;
    EditorDraw();
    while (!(key = MenuKey()));
    if (key == KEY_UP) selected = selected ? selected - 1 : count - 1;
    else if (key == KEY_DOWN) selected = selected == count - 1 ? 0 : selected + 1;
    else if (key == KEY_ENTER) break;
    else if (key == KEY_ESCAPE || key == KEY_MENU) {
      selected = CANCEL;
      break;
    }
    else if (key == KEY_BACKSPACE) {
      selected = BACK;
      break;
    }
  }
  HideBox();
  if (osk_shown) OSKShow(1);
  dirty = 1;
  return selected;
}

// shows text in the status bar or on the last text row until a key is pressed
void ShowMessage(const char* text) {
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
  WaitDismiss();
  dirty = 1;
}

// shows text (wrapped like BoxText) in a box in the middle of the editor until a key is pressed
void ShowBox(const char* text) {
  Render(); // the text under it is current (the cursor's line after a build error)
  EditorShowCursor(0);
  if (osk_shown) OSKShow(0);
  OpenBox(BoxText(0, text));
  EditorDraw();
  WaitDismiss();
  HideBox();
  if (osk_shown) OSKShow(1);
  dirty = 1;
}

void ShowError(unsigned char result, unsigned int denied) {
  char text[LANG_MAX + 4];
  if (result == FR_NOT_READY) ShowMessage(Str(S_NO_SD_CARD));
  else if (result == FR_NO_FILESYSTEM) ShowMessage(Str(S_NO_FAT_VOLUME));
  else if (result == FR_DENIED) ShowMessage(Str(denied));
  else {
    PutStr(PutNumber(PutStr(text, S_PART(S_SD_ERROR_N, 0)), result), S_PART(S_SD_ERROR_N, 1));
    ShowMessage(text);
  }
}
