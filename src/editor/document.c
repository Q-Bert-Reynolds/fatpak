// Text document names, syntax mode, open, save and discard prompts.
#include "document.h"
#include "../app/dialogs.h"
#include "../browser/browser.h"
#include "../browser/paths.h"
#include "editor.h"
#include "osk.h"
#include "settings.h"
#include "state.h"
#include "text_buffer.h"
#include "undo.h"
#include "view.h"
#include "../fatfs/file_api.h"
#include "../keyboard/keyboard.h"
#include "../ui/dialogs.h"
#include "../ui/render.h"
#include "../ui/screen.h"
#include "../ui/text.h"

char file_name[FS_NAME_SIZE]; // current file (UTF-8), empty for new text
char file_dir[PATH_SIZE]; // its folder, "" = root, new text is saved here too

#define NAME_CHARS     32 // save as, Latin-1 chars are 2 bytes in UTF-8 so they fit in FS_NAME_SIZE

static const char discard_items[][ITEM_SIZE] = {"NO", "YES"};
static const char * const lang_exts[] = { "md", "c", "h", "asm", "inc", "s" };
static const unsigned char lang_ids[] = { LANG_MD, LANG_C, LANG_C, LANG_ASM, LANG_ASM, LANG_ASM };

// returns 1 if there are no unsaved changes or the user wants to lose them
unsigned char CanDiscard(void) {
  return !modified || Choose("DISCARD CHANGES?", discard_items[0], 2, 0) == 1;
}

void SetLang(void) {
  const char *c, *dot = 0, *e;
  unsigned char lang = LANG_PLAIN, i;
  for (c = file_name; *c; ++c) if (*c == '.') dot = c;
  if (dot) for (i = 0; i < sizeof(lang_ids); ++i) {
    for (c = dot + 1, e = lang_exts[i]; *e && (*c | 0x20) == *e; ++c, ++e);
    if (!*c && !*e) lang = lang_ids[i];
  }
  font = lang == LANG_C || lang == LANG_ASM ? FONT_FIXED : FONT_VWF;
  if (lang == tb_lang) return;
  tb_lang = lang;
  tb_ResetChecks();
  for (i = 0; i <= TB_ROWS; ++i) tb_row_states[i] = 0; // no markdown headings left in them
  SetFont(font);
  for (i = bars; i < bars + tb_rows; ++i) render_row_fonts[i] = font;
  EditorRedraw();
  dirty = 1;
}

static void ResetCursor(void) {
  SetLang();
  cursor = 0;
  counted_pos = 0;
  counted_lines = 0;
  selecting = 0;
  top = 0;
  tb_left = 0;
  want_x = 0;
  modified = 0;
  dirty = 1;
  UndoClear(0);
}

void NewFile(void) {
  if (!CanDiscard()) return;
  FileCloseLarge();
  tb_Clear();
  file_name[0] = 0;
  fs_crlf = 0;
  ResetCursor();
  SettingsSave();
}

void OpenFile(void) {
  if (!CanDiscard()) return;
  if (Browse()) {
    ResetCursor();
    SettingsSave();
  }
}

// Called by the browser after choosing a text file. The path is restored to its folder.
void LoadDocument(char* path, unsigned char folder_length, const FileEntry* entry) {
  unsigned char result;
  if (entry->size > TB_SIZE) result = FileLoadLarge(path);
  else {
    FileCloseLarge();
    result = FileLoad(path);
  }
  HideBox();
  path[folder_length] = 0;
  if (result) {
    file_name[0] = 0; // the text buffer only has part of it, don't save over the file
    ShowError(result, "TOO BIG");
  }
  else {
    CopyName(file_dir, path);
    CopyName(file_name, entry->name);
  }
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
    if (key == KEY_ESCAPE || key == KEY_MENU || (key == KEY_BACKSPACE && !length)) {
      dirty = 1;
      return 0;
    }
    if (key == KEY_BACKSPACE) --length;
    else if (length < NAME_CHARS && NameChar(key)) name[length++] = key;
  }
  name[length] = 0;
  ToUtf8(file_name, name);
  SetLang();
  dirty = 1;
  return 1;
}

void SaveFile(unsigned char ask) {
  char path[PATH_SIZE + FS_NAME_SIZE];
  unsigned char result;
  if ((ask || !file_name[0]) && !AskFileName()) return;
  JoinPath(path, file_dir, file_name, (unsigned char)(PATH_SIZE + FS_NAME_SIZE));
  ShowBusy("Saving...");
  result = FileMount();
  if (!result) result = doc_large ? FileSaveLarge(path) : FileSave(path);
  HideBox();
  SettingsSave(); // save as may have changed the name
  if (result) {
    ShowError(result, "DISK FULL");
    return;
  }
  modified = 0;
  UndoSaved();
  ShowMessage("SAVED");
}
