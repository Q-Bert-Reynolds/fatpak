// File INFO / Select in the browser: properties of a file, folder or game. The
// host inspects the file and draws the header and footer before calling this.
#include "../build/modules/sdk.h"
#include "lib/text.h"
#include "info.h"

static const char* const types[] = {"Plain Text", "Markdown", "C source", "Assembly"};
static char line[TB_STRIDE + 1];
static const InfoContext* context;

// Binary units with compact KB/MB labels and one decimal.
static char* PutSize(char* dest, unsigned long size) {
  unsigned char unit = 0, tenth = 0;
  unsigned long whole = size, part;
  if (size >= 1048576UL) {
    unit = 'M';
    whole = size >> 20;
    part = size & 1048575UL;
    tenth = (unsigned char)(((part << 3) + (part << 1)) >> 20);
  }
  else if (size >= 1024) {
    unit = 'K';
    whole = size >> 10;
    part = size & 1023;
    tenth = (unsigned char)(((part << 3) + (part << 1)) >> 10);
  }
  dest = PutNumber(dest, whole);
  if (tenth) { *dest++ = '.'; *dest++ = '0' + tenth; }
  if (unit) *dest++ = unit;
  *dest++ = 'B';
  return dest;
}

static char* Field(const char* label) { return PutText(line, label); }
static void Row(unsigned char row, char* end) { *end = 0; ModText(row, 1, line); }
static void Value(unsigned char row, const char* label, const char* value) { Row(row, PutText(Field(label), value)); }
static void SizeRow(unsigned char row, const char* label, unsigned long size) { Row(row, PutSize(Field(label), size)); }
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
  Row(row, p);
}

// Header offsets and checksum: https://gbdev.io/pandocs/The_Cartridge_Header.html
static void GameInfo(const unsigned char* h) {
  unsigned char i, c, mapper = h[19];
  char* p = Field("Title: ");
  for (i = 0; i < (h[15] & 0x80 ? 15 : 16) && h[i]; ++i) {
    c = h[i];
    *p++ = c >= 32 && c < 127 ? c : '?';
  }
  Row(7, p);
  Value(8, "Platform: ", !(h[15] & 0x80) ? "Game Boy" : h[15] & 0x40 ? "Color only" : "GB / Color");
  Value(9, "Super GB: ", h[18] == 3 ? "Yes" : "No");
  p = Field("Mapper: ");
  if (mapper >= 1 && mapper <= 3) p = PutText(p, "MBC1");
  else if (mapper == 5 || mapper == 6) p = PutText(p, "MBC2");
  else if (mapper >= 15 && mapper <= 19) p = PutText(p, "MBC3");
  else if (mapper >= 25 && mapper <= 30) p = PutText(p, "MBC5");
  else if (mapper == 0 || mapper == 8 || mapper == 9) p = PutText(p, "ROM");
  else { p = PutText(p, "type "); p = PutNumber(p, mapper); }
  Row(10, p);
  if (h[20] <= 8) SizeRow(11, "ROM: ", 32768UL << h[20]);
  else Value(11, "ROM: ", "Unknown");
  if (mapper == 5 || mapper == 6) Value(12, "RAM: ", "512 x 4 bits");
  else {
    c = h[21];
    if (c == 1 || c > 5) Value(12, "RAM: ", "Unknown");
    else SizeRow(12, "RAM: ", c == 2 ? 8192UL : c == 3 ? 32768UL : c == 4 ? 131072UL : c == 5 ? 65536UL : 0);
  }
  Value(13, "Region: ", h[22] == 0 ? "Japan" : h[22] == 1 ? "Overseas" : "Unknown");
  Row(14, PutNumber(Field("Revision: "), h[24]));
  Value(15, "Header checksum: ", context->details->status == 1 ? "OK" : "Bad");
}

unsigned char ModuleMain(const InfoContext* info) {
  const FileEntry* entry = info->entry;
  const FileDetails* details = info->details;
  unsigned char row, key;
  context = info;
  ModHideBox(); // the host's "Reading info..." box
  for (row = 0; row < TB_ROWS - 2; ++row) ModText(row, 0, "");
  Value(0, "Type: ", entry->dir ? "Folder" : details->game ? "Game Boy ROM" : details->status == 2 ? "Binary" : types[info->language & 3]);
  if (entry->dir) Value(1, "Size: ", "--");
  else SizeRow(1, "Size: ", entry->size);
  DateRow(3, "Created: ", entry->cdate, entry->ctime);
  DateRow(4, "Accessed: ", entry->adate, 0xFFFF);
  DateRow(5, "Modified: ", entry->date, entry->time);
  if (info->result) Value(7, "Read: ", "SD error");
  else if (details->game) {
    if (details->status) GameInfo(details->header);
    else Value(7, "Header: ", "Too short");
  }
  else if (!entry->dir) {
    if (details->status == 1) {
      Row(7, PutNumber(Field("Words: "), details->words));
      Row(8, PutNumber(Field("Lines: "), details->lines));
    }
    else Value(7, "Counts: ", details->status == 2 ? "Binary file" : "Skipped (>32KB)");
  }
  do { key = ModKey(); } while (key != KEY_BACKSPACE && key != KEY_ESCAPE);
  return 0;
}
