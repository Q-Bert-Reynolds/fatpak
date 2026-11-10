// File properties share the editor's framed view and the browser's row renderer.
#include "info.h"
#include "../editor/document.h"
#include "../editor/view.h"
#include "../game/loader.h"
#include "../browser/paths.h"
#include "../input.h"
#include "../ui/dialogs.h"
#include "../ui/render.h"
#include "../ui/screen.h"
#include "../ui/text.h"

static const char* const types[] = {"Plain Text", "Markdown", "C source", "Assembly"};
static char line[FS_NAME_SIZE];
static FileDetails details;

// Binary units with the compact KB/MB labels used throughout this page.
char* PutSize(char* dest, unsigned long size) {
  unsigned char unit = 0, tenth;
  unsigned long whole = size, remainder = 0;
  if (size >= 1048576UL) {
    unit = 2;
    whole = size >> 20;
    remainder = size & 1048575UL;
    tenth = (remainder * 10) >> 20;
  }
  else if (size >= 1024) {
    unit = 1;
    whole = size >> 10;
    remainder = size & 1023;
    tenth = (remainder * 10) >> 10;
  }
  else tenth = 0;
  dest = PutNumber(dest, whole);
  if (tenth) { *dest++ = '.'; *dest++ = '0' + tenth; }
  if (unit) *dest++ = unit == 1 ? 'K' : 'M';
  *dest++ = 'B';
  return dest;
}

static char* Field(const char* label) { return PutText(line, label); }
static void Row(unsigned char row) { DrawRow(row, 1, line); }
static void Value(unsigned char row, const char* label, const char* value) {
  *PutText(Field(label), value) = 0;
  Row(row);
}
static void SizeRow(unsigned char row, const char* label, unsigned long size) {
  *PutSize(Field(label), size) = 0;
  Row(row);
}
static void DateRow(unsigned char row, const char* label, unsigned int date, unsigned int time) {
  char* p = Field(label);
  if (!date) p = PutText(p, "--");
  else {
    p = PutNumber(p, 1980 + (date >> 9));
    *p++ = '-';
    p = PutNumber2(p, (date >> 5) & 15);
    *p++ = '-';
    p = PutNumber2(p, date & 31);
    if (time != 0xFFFF) {
      *p++ = ' ';
      p = PutNumber2(p, time >> 11);
      *p++ = ':';
      p = PutNumber2(p, (time >> 5) & 63);
    }
  }
  *p = 0;
  Row(row);
}

// Header offsets and checksum: https://gbdev.io/pandocs/The_Cartridge_Header.html
static void GameInfo(void) {
  unsigned char* h = details.header;
  unsigned char i, c, mapper = h[19];
  unsigned long size;
  char* p = Field("Title: ");
  for (i = 0; i < (h[15] & 0x80 ? 15 : 16) && h[i]; ++i) {
    c = h[i];
    *p++ = c >= 32 && c < 127 ? c : '?';
  }
  *p = 0;
  Row(7);
  Value(8, "Platform: ", !(h[15] & 0x80) ? "Game Boy" : h[15] & 0x40 ? "Color only" : "GB / Color");
  Value(9, "Super GB: ", h[18] == 3 ? "Yes" : "No");
  p = Field("Mapper: ");
  if (mapper >= 1 && mapper <= 3) p = PutText(p, "MBC1");
  else if (mapper == 5 || mapper == 6) p = PutText(p, "MBC2");
  else if (mapper >= 15 && mapper <= 19) p = PutText(p, "MBC3");
  else if (mapper >= 25 && mapper <= 30) p = PutText(p, "MBC5");
  else if (mapper == 0 || mapper == 8 || mapper == 9) p = PutText(p, "ROM");
  else { p = PutText(p, "type "); p = PutNumber(p, mapper); }
  *p = 0;
  Row(10);
  if (h[20] <= 8) { size = 32768UL << h[20]; SizeRow(11, "ROM: ", size); }
  else Value(11, "ROM: ", "Unknown");
  if (mapper == 5 || mapper == 6) Value(12, "RAM: ", "512 x 4 bits");
  else {
    c = h[21];
    size = c == 2 ? 8192UL : c == 3 ? 32768UL : c == 4 ? 131072UL : c == 5 ? 65536UL : 0;
    if (c == 1 || c > 5) Value(12, "RAM: ", "Unknown");
    else SizeRow(12, "RAM: ", size);
  }
  Value(13, "Region: ", h[22] == 0 ? "Japan" : h[22] == 1 ? "Overseas" : "Unknown");
  *PutNumber(Field("Revision: "), h[24]) = 0;
  Row(14);
  Value(15, "Header checksum: ", details.status == 1 ? "OK" : "Bad");
}

void ShowFileInfo(const char* path, const FileEntry* entry) {
  unsigned char row, result = 0, key;
  details.game = !entry->dir && IsGame(entry->name);
  details.status = 0;
  if (!entry->dir) {
    ShowBusy("Reading info...");
    result = FileInspect(path, &details);
  }
  HideBox();
  BeginView(1);
  *ToLatin1(line, entry->name, FS_NAME_SIZE - 1) = 0;
  DrawRow(HEADER_LINE, 1, line);
  DrawRow(STATUS_LINE, 1, "B/Esc: exit");
  for (row = 0; row < TB_ROWS - 2; ++row) DrawRow(row, 0, "");
  Value(0, "Type: ", entry->dir ? "Folder" : details.game ? "Game Boy ROM" : details.status == 2 ? "Binary" : types[FileLanguage(entry->name)]);
  if (entry->dir) Value(1, "Size: ", "--");
  else SizeRow(1, "Size: ", entry->size);
  DateRow(3, "Created: ", entry->cdate, entry->ctime);
  DateRow(4, "Accessed: ", entry->adate, 0xFFFF);
  DateRow(5, "Modified: ", entry->date, entry->time);
  if (result) Value(7, "Read: ", "SD error");
  else if (details.game) {
    if (details.status) GameInfo();
    else Value(7, "Header: ", "Too short");
  }
  else if (!entry->dir) {
    if (details.status == 1) {
      *PutNumber(Field("Words: "), details.words) = 0;
      Row(7);
      *PutNumber(Field("Lines: "), details.lines) = 0;
      Row(8);
    }
    else Value(7, "Counts: ", details.status == 2 ? "Binary file" : "Skipped (>32KB)");
  }
  EditorDraw();
  do { key = MenuKey(); } while (key != KEY_BACKSPACE && key != KEY_ESCAPE);
}
