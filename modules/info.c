// File INFO / Select in the browser: properties of a file, folder or game. The
// host inspects the file and draws the header and footer before calling this.
#include "../build/modules/sdk.h"
#include "lib/text.h"
#include "info.h"

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

// rows of a label and its value, both strings (S_*)
static char* Field(unsigned int label) { return ModString(line, label); }
static void Row(unsigned char row, char* end) { *end = 0; ModText(row, 1, line); }
static void Value(unsigned char row, unsigned int label, unsigned int value) { Row(row, ModString(Field(label), value)); }
static void SizeRow(unsigned char row, unsigned int label, unsigned long size) { Row(row, PutSize(Field(label), size)); }
static void DateRow(unsigned char row, unsigned int label, unsigned int date, unsigned int time) {
  char* p = Field(label);
  if (!date) p = ModString(p, S_NONE);
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
  char* p = Field(S_INFO_TITLE);
  for (i = 0; i < (h[15] & 0x80 ? 15 : 16) && h[i]; ++i) {
    c = h[i];
    *p++ = c >= 32 && c < 127 ? c : '?';
  }
  Row(7, p);
  Value(8, S_INFO_PLATFORM, !(h[15] & 0x80) ? S_GB_ONLY : h[15] & 0x40 ? S_GB_COLOR_ONLY : S_GB_BOTH);
  Value(9, S_INFO_SGB, h[18] == 3 ? S_INFO_YES : S_INFO_NO);
  p = Field(S_INFO_MAPPER);
  if (mapper >= 1 && mapper <= 3) p = PutText(p, "MBC1");
  else if (mapper == 5 || mapper == 6) p = PutText(p, "MBC2");
  else if (mapper >= 15 && mapper <= 19) p = PutText(p, "MBC3");
  else if (mapper >= 25 && mapper <= 30) p = PutText(p, "MBC5");
  else if (mapper == 0 || mapper == 8 || mapper == 9) p = PutText(p, "ROM");
  else { p = ModString(p, S_MAPPER_TYPE); p = PutNumber(p, mapper); }
  Row(10, p);
  if (h[20] <= 8) SizeRow(11, S_INFO_ROM, 32768UL << h[20]);
  else Value(11, S_INFO_ROM, S_UNKNOWN);
  if (mapper == 5 || mapper == 6) Value(12, S_INFO_RAM, S_RAM_MBC2);
  else {
    c = h[21];
    if (c == 1 || c > 5) Value(12, S_INFO_RAM, S_UNKNOWN);
    else SizeRow(12, S_INFO_RAM, c == 2 ? 8192UL : c == 3 ? 32768UL : c == 4 ? 131072UL : c == 5 ? 65536UL : 0);
  }
  Value(13, S_INFO_REGION, h[22] == 0 ? S_JAPAN : h[22] == 1 ? S_OVERSEAS : S_UNKNOWN);
  Row(14, PutNumber(Field(S_INFO_REVISION), h[24]));
  Value(15, S_INFO_CHECKSUM, context->details->status == 1 ? S_CHECK_OK : S_CHECK_BAD);
}

unsigned char ModuleMain(InfoContext* info) {
  const FileEntry* entry = info->entry;
  const FileDetails* details = info->details;
  unsigned char row, key;
  context = info;
  ModHideBox(); // the host's "Reading info..." box
  for (row = 0; row < TB_ROWS - 2; ++row) ModText(row, 0, "");
  Value(0, S_INFO_TYPE, entry->dir ? S_TYPE_FOLDER : details->game ? S_TYPE_GAME : details->status == 2 ? S_TYPE_BINARY :
        S_TYPE_TEXT + (info->language & 3));
  if (entry->dir) Value(1, S_INFO_SIZE, S_NONE);
  else SizeRow(1, S_INFO_SIZE, entry->size);
  DateRow(3, S_INFO_CREATED, entry->cdate, entry->ctime);
  DateRow(4, S_INFO_ACCESSED, entry->adate, 0xFFFF);
  DateRow(5, S_INFO_MODIFIED, entry->date, entry->time);
  if (info->result) Value(7, S_INFO_READ, S_SD_ERROR_LOWER);
  else if (details->game) {
    if (details->status) GameInfo(details->header);
    else Value(7, S_INFO_HEADER, S_TOO_SHORT);
  }
  else if (!entry->dir) {
    if (details->status == 1) {
      Row(7, PutNumber(Field(S_INFO_WORDS), details->words));
      Row(8, PutNumber(Field(S_INFO_LINES), details->lines));
    }
    else Value(7, S_INFO_COUNTS, details->status == 2 ? S_BINARY_FILE : S_SKIPPED);
  }
  do { key = ModKey(); } while (key != KEY_BACKSPACE && key != KEY_ESCAPE && key != KEY_ENTER);
  info->open = key == KEY_ENTER;
  return 0;
}
