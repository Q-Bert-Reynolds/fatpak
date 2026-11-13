// Modal filename editing, with a private bounded undo ring in scratch PSRAM.
#include "document.h"
#include "editor.h"
#include "osk.h"
#include "state.h"
#include "view.h"
#include "../browser/paths.h"
#include "../keyboard/keyboard.h"
#include "../ui/render.h"
#include "../ui/screen.h"
#include "../ui/text.h"

extern void SetWindowBlock(unsigned int block);
#define WINDOW_BLOCK (*(volatile unsigned int*)0xBD02)
unsigned char name_row;

static void NameHistory(char* name, unsigned int index) {
  unsigned int saved = WINDOW_BLOCK;
  char* slot = (char*)(0xBE00u + ((index & 3) << 7));
  SetWindowBlock(NAME_HISTORY_BLOCK + ((index >> 2) & 15));
  if (index & 0x100) CopyName(name, slot);
  else CopyName(slot, name);
  SetWindowBlock(saved);
}

static unsigned char NameChar(unsigned char c) {
  if (c < ' ' || (c >= 0x7F && c < 0xA0)) return 0;
  return c != '/' && c != 0x5C && c != ':' && c != '*' && c != '?' && c != '"' && c != '<' && c != '>' && c != '|';
}

// NO_PROMPT edits name_row in the browser; other callers use the header, after the prompt string.
// Returns 0 on cancel, 1 after editing, 2 when accepting an unchanged name.
unsigned char AskName(char* value, unsigned int prompt) {
  char name[FS_NAME_SIZE], text[TB_STRIDE + 1];
  char* end;
  unsigned int event;
  unsigned char length, bytes, fit, i, key, current = 0, first = 0, last = 0, changed = 0;
  length = (unsigned char)(ToLatin1(name, value, FS_NAME_SIZE - 1) - name);
  name[length] = 0;
  NameHistory(name, 0);
  EditorShowCursor(0);
  NoHighlight();
  while (1) {
    for (length = bytes = 0; name[length]; ++length) bytes += (unsigned char)name[length] >= 0x80 ? 2 : 1;
    end = prompt != NO_PROMPT ? PutStr(text, prompt) : text;
    fit = (unsigned char)(TB_STRIDE - 2 - (end - text)); // the name's last characters that fit, and the _
    if (fit > 31) fit = 31;
    for (i = length > fit ? length - fit : 0; i < length; ++i) *end++ = name[i];
    *end++ = '_';
    *end = 0;
    if (prompt == NO_PROMPT) DrawRow(name_row, 1, text);
    else {
      DrawRow(bars ? HEADER_LINE : 0, bars, text);
      if (bars && render_text) {
        PutPath(PutStr(text, S_IN_FOLDER), file_dir, 28);
        DrawRow(STATUS_LINE, 1, text);
      }
    }
    EditorDraw();
    do {
      WaitFrame();
      event = KBPopEvent();
      key = (unsigned char)event;
      if (event & ((unsigned int)KB_MOD_CTRL << 8)) {
        if (key == 'z' || key == 'Z') key = event & ((unsigned int)KB_MOD_SHIFT << 8) ? KEY_REDO : KEY_UNDO;
        else key = key == 'y' || key == 'Y' ? KEY_REDO : 0;
      }
      if (!event) key = PadKey();
    } while (!key);
    if (key == KEY_ENTER && length) break;
    if (key == KEY_ESCAPE || key == KEY_MENU || (key == KEY_BACKSPACE && !length)) return 0;
    if (key == KEY_UNDO || key == KEY_REDO) {
      if (key == KEY_UNDO && current != first) current = (current - 1) & 63;
      else if (key == KEY_REDO && current != last) current = (current + 1) & 63;
      NameHistory(name, 0x100u | current);
      continue;
    }
    if (key == KEY_BACKSPACE) --length;
    else if (bytes + (key >= 0x80 ? 2 : 1) <= FS_NAME_SIZE - 1 && NameChar(key)) name[length++] = key;
    else continue;
    name[length] = 0;
    current = (current + 1) & 63;
    if (current == first) first = (first + 1) & 63;
    last = current;
    NameHistory(name, current);
    changed = 1;
  }
  if (!changed) return 2;
  ToUtf8(value, name);
  dirty = 1;
  return 1;
}
