// SD file browser. Opening text and games uses their feature APIs.
#include "browser.h"
#include "../app/dialogs.h"
#include "paths.h"
#include "../editor/editor.h"
#include "../editor/document.h"
#include "../editor/osk.h"
#include "../editor/state.h"
#include "../editor/text_buffer.h"
#include "../editor/view.h"
#include "../fatfs/file_api.h"
#include "../game/loader.h"
#include "../input.h"
#include "../ui/dialogs.h"
#include "../ui/render.h"
#include "../ui/screen.h"
#include "../ui/text.h"

#define LIST_ROWS      (TB_ROWS - 2) // file browser rows between the bars
#define LIST_ALL       0xFFFF
#define KIND_UP        0
#define KIND_FOLDER    1
#define KIND_FILE      2

static FileEntry entry;
static unsigned int list_count; // file browser entries, with .. below the root
static unsigned char list_result; // FRESULT of listing the folder or reading an entry
static unsigned char list_kinds[LIST_ROWS]; // file browser rows
static unsigned long list_sizes[LIST_ROWS];
static unsigned int list_dates[LIST_ROWS];
static unsigned int list_times[LIST_ROWS];

// lists the folder at path (".." below the root, folders, then files), returns the index of the folder
// named find in it (find can be 0) or 0, list_result is set if the folder can't be read
static unsigned int ListFolder(const char* path, const char* find) {
  unsigned char up = path[0] != 0;
  list_count = 0;
  if ((list_result = FileList(path, find))) return 0;
  list_count = fs_count + up;
  return find && fs_found != 0xFFFF ? fs_found + up : 0;
}

// reads the list entry at index into entry, returns its kind, or 0xFF and sets list_result if it can't
static unsigned char ListEntry(const char* path, unsigned int index) {
  if (path[0] && !index--) {
    entry.name[0] = '.';
    entry.name[1] = '.';
    entry.name[2] = 0;
    return KIND_UP;
  }
  if ((list_result = FileListEntry(index, &entry))) return 0xFF;
  return entry.dir ? KIND_FOLDER : KIND_FILE;
}

// draws file browser rows from row to end, first is the top row's index, stops if an entry can't be read
static void ListRows(const char* path, unsigned int first, unsigned char row, unsigned char end) {
  unsigned char kind;
  char* dest;
  for (; row < end; ++row) {
    DrawRow(row, 0, "");
    if (first + row >= list_count) continue;
    if ((kind = ListEntry(path, first + row)) == 0xFF) return;
    list_kinds[row] = kind;
    list_sizes[row] = entry.size;
    list_dates[row] = entry.date;
    list_times[row] = entry.time;
    dest = ToLatin1(RowAddress(row) + 1, entry.name, TB_STRIDE - 3);
    if (kind == KIND_FOLDER) *dest = '/';
  }
}

// scrolls the file browser one row (down = 1 when first went up by one), only the new row is read and drawn
static void ScrollList(const char* path, unsigned int first, unsigned char down) {
  unsigned char i, from, to;
  ScrollRing(down);
  tb_ScrollRows(down);
  for (i = 1; i < LIST_ROWS; ++i) {
    to = down ? i - 1 : LIST_ROWS - i;
    from = down ? i : to - 1;
    list_kinds[to] = list_kinds[from];
    list_sizes[to] = list_sizes[from];
    list_dates[to] = list_dates[from];
    list_times[to] = list_times[from];
  }
  i = down ? LIST_ROWS - 1 : 0;
  ListRows(path, first, i, i + 1);
}

// path in the file name bar, what's on row in the status bar
static void ListBars(const char* path, unsigned char row, unsigned int count) {
  char text[TB_STRIDE];
  char* end = text;
  unsigned long size = list_sizes[row];
  unsigned char* bytes = (unsigned char*)&size;
  unsigned int date = list_dates[row], time = list_times[row];
  PutPath(text, path, 30);
  DrawRow(HEADER_LINE, 1, text);
  if (!count) end = PutText(end, "Empty folder");
  else if (list_kinds[row] == KIND_UP) end = PutText(end, "Parent folder");
  else if (list_kinds[row] == KIND_FOLDER) end = PutText(end, "Folder");
  else {
    if (size < 10000) end = PutText(PutNumber(end, (unsigned int)size), " bytes  ");
    else if (size < 10485760) end = PutText(PutNumber(end, (bytes[1] >> 2) | (bytes[2] << 6)), " KB  ");
    else end = PutText(PutNumber(end, (bytes[2] >> 4) | (bytes[3] << 4)), " MB  ");
    end = PutNumber(end, (date >> 9) + 1980);
    *end++ = '-';
    end = PutNumber2(end, (date >> 5) & 15);
    *end++ = '-';
    end = PutNumber2(end, date & 31);
    *end++ = ' ';
    end = PutNumber2(end, time >> 11);
    *end++ = ':';
    end = PutNumber2(end, (time >> 5) & 63);
  }
  *end = 0;
  DrawRow(STATUS_LINE, 1, text);
}

// new path in the file name bar and a Loading... box over the list, with row's folder added to path
// if row isn't 0xFF (shown before reading the folder again for its full name)
static void ListLoading(const char* path, unsigned char row) {
  char text[PATH_SIZE + TB_STRIDE];
  char* end = path[0] ? ToLatin1(text, path, PATH_SIZE - 1) : text;
  char* name;
  unsigned char length;
  if (row != 0xFF) {
    *end++ = '/';
    for (name = RowAddress(row) + 1; *name != '/'; ++name) *end++ = *name;
  }
  else if (!path[0]) *end++ = '/';
  *end = 0;
  length = (unsigned char)(end - text);
  end = text;
  if (length > 30) {
    end += length - 33;
    end[0] = end[1] = end[2] = '.';
  }
  DrawRow(HEADER_LINE, 1, end);
  DrawRow(STATUS_LINE, 1, "");
  ShowBusy("Loading...");
}

// shows text in the status bar until a key is pressed
static void ListMessage(const char* text) {
  HideBox();
  DrawRow(STATUS_LINE, 1, text);
  EditorDraw();
  WaitDismiss();
}

// file browser, opens the chosen file into the text buffer, returns 1 if it did
// up, down, page up/down, home, end move, enter/right/A opens, left/backspace/B goes up a folder,
// escape (or backspace/B in the root) goes back to the text
unsigned char Browse(void) {
  char path[PATH_SIZE + FS_NAME_SIZE]; // folder, and the file's path when opening it
  char name[FS_NAME_SIZE];
  unsigned int selected = 0, first = 0, drawn = LIST_ALL;
  unsigned char key, result, row, opened = 0, editor_font = font, length;
  CopyName(path, file_dir);
  font = FONT_VWF;
  SetFont(font);
  render_text = 0;
  EditorShowCursor(0);
  if (osk_shown) OSKShow(0);
  bars = 1;
  tb_rows = LIST_ROWS;
  Layout();
  NoHighlight();
  ListLoading(path, 0xFF);
  if ((result = FileMount())) {
    ShowError(result, "");
    selected = LIST_ALL; // skips the list
  }
  else ListFolder(path, 0);
  while (selected != LIST_ALL) {
    if (selected < first) first = selected;
    else if (selected >= first + LIST_ROWS) first = selected - LIST_ROWS + 1;
    if (!list_result && first != drawn) {
      if (drawn != LIST_ALL && first == drawn + 1) ScrollList(path, first, 1);
      else if (drawn != LIST_ALL && first + 1 == drawn) ScrollList(path, first, 0);
      else ListRows(path, first, 0, LIST_ROWS);
      HideBox();
      drawn = first;
    }
    if (list_result) {
      if (!path[0]) { // can't read the card
        ShowError(list_result, "");
        break;
      }
      path[0] = 0; // folder is gone, back to the root
      ListLoading(path, 0xFF);
      selected = ListFolder(path, 0);
      drawn = LIST_ALL;
      continue;
    }
    row = (unsigned char)(selected - first);
    ListBars(path, row, list_count);
    NoHighlight();
    if (list_count) render_sel[(row + 1) << 1] = 0, render_sel[((row + 1) << 1) + 1] = 0xFF;
    EditorDraw();
    while (!(key = MenuKey()));
    if (key == KEY_UP && selected) --selected;
    else if (key == KEY_DOWN && selected + 1 < list_count) ++selected;
    else if (key == KEY_PAGE_UP) selected = selected > LIST_ROWS ? selected - LIST_ROWS : 0;
    else if (key == KEY_PAGE_DOWN && list_count) selected = selected + LIST_ROWS < list_count ? selected + LIST_ROWS : list_count - 1;
    else if (key == KEY_HOME) selected = 0;
    else if (key == KEY_END && list_count) selected = list_count - 1;
    else if ((key == KEY_ENTER || key == KEY_RIGHT) && list_count && list_kinds[row] != KIND_UP) {
      if (list_kinds[row] == KIND_FOLDER) ListLoading(path, row);
      else ShowBusy("Loading...");
      if (ListEntry(path, selected) == 0xFF) continue; // its full name
      for (length = 0; path[length]; ++length);
      if (entry.dir) {
        if (JoinPath(path + length, "", entry.name, PATH_SIZE - length)) {
          selected = ListFolder(path, 0);
          drawn = LIST_ALL;
        }
        else {
          path[length] = 0;
          ListMessage("Path is too long");
        }
      }
      else {
        JoinPath(path + length, "", entry.name, FS_NAME_SIZE + 1);
        if (IsGame(entry.name)) {
          LaunchGame(path); // returns if it doesn't launch
          path[length] = 0;
          drawn = LIST_ALL;
          continue;
        }
        LoadDocument(path, length, &entry);
        opened = 1;
        break;
      }
    }
    else if (path[0] && (key == KEY_LEFT || key == KEY_BACKSPACE ||
                         ((key == KEY_ENTER || key == KEY_RIGHT) && list_count && list_kinds[row] == KIND_UP))) {
      for (length = 0; path[length]; ++length);
      while (path[--length] != '/');
      CopyName(name, path + length + 1);
      path[length] = 0;
      ListLoading(path, 0xFF);
      selected = ListFolder(path, name); // back on the folder it came from
      drawn = LIST_ALL;
    }
    else if (key == KEY_ESCAPE || key == KEY_BACKSPACE || key == KEY_MENU) break;
  }
  font = editor_font;
  SetFont(font);
  render_text = 1;
  SetRows();
  return opened;
}
