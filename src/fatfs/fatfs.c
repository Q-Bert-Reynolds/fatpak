// src/fatfs/fatfs.c
// FatFs, its disk glue, and the file API, built as one file so it all lands in one ROM bank.
// Called from other banks through the ROM0 stubs in src/fatfs/fatfs.asm.
// NOTE: no static initializers (_GSINIT doesn't run)
#include "fatfs.h"
#include "lib/ff.c"

#define BUFFER_SIZE 512

// src/editor/sd.asm
extern unsigned long sd_sector;
extern unsigned char sd_Init(void);
extern unsigned char sd_ReadSector(unsigned char* buffer);
extern unsigned char sd_WriteSector(const unsigned char* buffer);

// src/editor/text_buffer.asm
extern void tb_Clear(void);
extern void tb_Normalize(void);
extern unsigned int tb_Length(void);
extern unsigned int tb_read_pos;
extern unsigned char tb_Append(const unsigned char* buffer, unsigned int count); // 0 = buffer full
extern void tb_Read(unsigned char* buffer, unsigned int count); // from tb_read_pos, advances it

FATFS fs;
FIL file;
DIR dir;
FILINFO info;
BYTE disk_ready;
BYTE buffer[BUFFER_SIZE];
unsigned char fs_crlf; // last loaded file used CR LF line endings, saved files use them too

void* memcpy(void* dest, const void* src, size_t n) {
  BYTE* d = dest;
  const BYTE* s = src;
  while (n--) *d++ = *s++;
  return dest;
}

void* memset(void* dest, int c, size_t n) {
  BYTE* d = dest;
  while (n--) *d++ = (BYTE)c;
  return dest;
}

int memcmp(const void* a, const void* b, size_t n) {
  const BYTE* x = a;
  const BYTE* y = b;
  for (; n; --n, ++x, ++y) if (*x != *y) return *x - *y;
  return 0;
}

#include "lib/runtime.c"

char* strchr(const char* s, int c) {
  for (; *s; ++s) if (*s == (char)c) return (char*)s;
  return c ? 0 : (char*)s;
}

DSTATUS disk_status(BYTE pdrv) {
  (void)pdrv;
  return disk_ready ? 0 : STA_NOINIT;
}

DSTATUS disk_initialize(BYTE pdrv) {
  disk_ready = !sd_Init();
  return disk_status(pdrv);
}

DRESULT disk_read(BYTE pdrv, BYTE* buff, LBA_t sector, UINT count) {
  (void)pdrv;
  for (; count; --count, ++sector, buff += FF_MAX_SS) {
    sd_sector = sector;
    if (sd_ReadSector(buff)) return RES_ERROR;
  }
  return RES_OK;
}

DRESULT disk_write(BYTE pdrv, const BYTE* buff, LBA_t sector, UINT count) {
  (void)pdrv;
  for (; count; --count, ++sector, buff += FF_MAX_SS) {
    sd_sector = sector;
    if (sd_WriteSector(buff)) return RES_ERROR;
  }
  return RES_OK;
}

DRESULT disk_ioctl(BYTE pdrv, BYTE cmd, void* buff) {
  (void)pdrv;
  (void)buff;
  return cmd == CTRL_SYNC ? RES_OK : RES_PARERR;
}

unsigned char fs_Mount(void) {
  return f_mount(&fs, "", 1);
}

unsigned char fs_OpenDir(void) {
  return f_opendir(&dir, "");
}

// copies the next .TXT file name in the root directory to name (13 bytes), returns 0 when there are no more
unsigned char fs_NextFile(char* name) {
  char* ext;
  while (f_readdir(&dir, &info) == FR_OK && info.fname[0]) {
    if (info.fattrib & (AM_DIR | AM_HID | AM_SYS)) continue;
    ext = strchr(info.fname, '.');
    if (!ext || ext[1] != 'T' || ext[2] != 'X' || ext[3] != 'T' || ext[4]) continue;
    memcpy(name, info.fname, sizeof info.fname);
    return 1;
  }
  f_closedir(&dir);
  return 0;
}

// removes CRs from buffer, returns the new count
static UINT RemoveCR(UINT count) {
  BYTE* src = buffer;
  BYTE* dest = buffer;
  for (; count; --count, ++src) {
    if (*src == '\r') fs_crlf = 1;
    else *dest++ = *src;
  }
  return (UINT)(dest - buffer);
}

// replaces the text buffer with the file, returns an FRESULT (FR_DENIED if it doesn't fit)
unsigned char fs_Load(const char* name) {
  UINT count;
  FRESULT result = f_open(&file, name, FA_READ);
  if (result) return result;
  tb_Clear();
  fs_crlf = 0;
  do {
    result = f_read(&file, buffer, BUFFER_SIZE, &count);
    if (result) break;
    if (!tb_Append(buffer, RemoveCR(count))) {
      result = FR_DENIED;
      break;
    }
  } while (count == BUFFER_SIZE);
  f_close(&file);
  return result;
}

// reads count chars from the text buffer into the second half of buffer and expands
// line feeds to CR LF from the start of buffer, returns the new count
static UINT AddCR(UINT count) {
  BYTE* src = buffer + BUFFER_SIZE / 2;
  BYTE* dest = buffer;
  tb_Read(src, count);
  for (; count; --count) {
    if (*src == '\n') *dest++ = '\r';
    *dest++ = *src++;
  }
  return (UINT)(dest - buffer);
}

// writes the text buffer to the file, returns an FRESULT
unsigned char fs_Save(const char* name) {
  UINT count, size, written;
  unsigned int left;
  FRESULT result = f_open(&file, name, FA_WRITE | FA_CREATE_ALWAYS);
  if (result) return result;
  tb_Normalize();
  left = tb_Length();
  tb_read_pos = 0;
  while (left) {
    if (fs_crlf) {
      count = left < BUFFER_SIZE / 2 ? left : BUFFER_SIZE / 2;
      size = AddCR(count);
    } else {
      count = left < BUFFER_SIZE ? left : BUFFER_SIZE;
      tb_Read(buffer, count);
      size = count;
    }
    result = f_write(&file, buffer, size, &written);
    if (result) break;
    if (written != size) {
      result = FR_DENIED; // disk full
      break;
    }
    left -= count;
  }
  if (f_close(&file) && !result) result = FR_DISK_ERR;
  return result;
}
