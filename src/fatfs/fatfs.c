// src/fatfs/fatfs.c
// FatFs, its disk glue, and the file API, built as one file so it all lands in one ROM bank.
// Called from other banks through the ROM0 stubs in src/fatfs/fatfs.asm.
// NOTE: no static initializers (_GSINIT doesn't run)
#include "fatfs.h"
#include "lib/ff.c"
#include "lib/ffunicode.c"
#include "../constants.h"

typedef char check_name_size[FS_NAME_SIZE == FF_LFN_BUF + 1 ? 1 : -1];

#define FS_BUFFER_SIZE 512

// src/editor/sd.asm
extern unsigned long sd_sector;
extern unsigned char sd_Init(void);
extern unsigned char sd_ReadSector(unsigned char* buffer);
extern unsigned char sd_WriteSector(const unsigned char* buffer);

// src/editor/text_buffer.asm
extern void tb_Clear(void);
extern unsigned int tb_read_pos;
extern unsigned char tb_cr; // tb_Append dropped a CR
extern unsigned char tb_Append(const unsigned char* buffer, unsigned int count); // drops 0s and CRs, 0 = buffer full
extern unsigned int tb_Read(unsigned char* buffer, unsigned int size); // from tb_read_pos, returns bytes copied (0 at the end)
extern unsigned int tb_ReadLines(unsigned char* buffer, unsigned int size); // tb_Read with line feeds as CR LF

FATFS fs;
FIL file;
DIR dir;
FILINFO info;
BYTE disk_ready;
BYTE buffer[FS_BUFFER_SIZE];
unsigned char fs_crlf; // last loaded file used CR LF line endings, saved files use them too

// memcpy, memset, memcmp and strchr are in src/fatfs/fatfs.asm
#include "lib/runtime.c"

DSTATUS disk_status(BYTE pdrv) {
  (void)pdrv;
  return disk_ready ? 0 : STA_NOINIT;
}

DSTATUS disk_initialize(BYTE pdrv) {
  disk_ready = !sd_Init();
  return disk_status(pdrv);
}

// a failed read or write makes disk_status report the card as not initialized, so FatFs mounts it
// again on the next call (a swapped card fails its first command because it hasn't been initialized)
DRESULT disk_read(BYTE pdrv, BYTE* buff, LBA_t sector, UINT count) {
  (void)pdrv;
  for (; count; --count, ++sector, buff += FF_MAX_SS) {
    sd_sector = sector;
    if (sd_ReadSector(buff)) {
      disk_ready = 0;
      return RES_ERROR;
    }
  }
  return RES_OK;
}

DRESULT disk_write(BYTE pdrv, const BYTE* buff, LBA_t sector, UINT count) {
  (void)pdrv;
  for (; count; --count, ++sector, buff += FF_MAX_SS) {
    sd_sector = sector;
    if (sd_WriteSector(buff)) {
      disk_ready = 0;
      return RES_ERROR;
    }
  }
  return RES_OK;
}

DRESULT disk_ioctl(BYTE pdrv, BYTE cmd, void* buff) {
  (void)pdrv;
  (void)buff;
  return cmd == CTRL_SYNC ? RES_OK : RES_PARERR;
}

// mounts the card the first time and after a disk error
unsigned char fs_Mount(void) {
  if (fs.fs_type && disk_ready) return FR_OK;
  return f_mount(&fs, "", 1);
}

// File browser lists. fs_List reads a folder once, counting its visible folders and files and marking
// where every (1 << mark_shift)th entry of each kind starts, so fs_ListEntry can read any entry by
// stepping from the mark before it. Entries are read straight from the directory sectors, names
// are only decoded for the entries fs_ListEntry returns.
#define MARKS (FS_BUFFER_SIZE / 4) // per kind, in buffer (only loading and saving use it)
#define MARK(kind) ((WORD*)buffer + ((kind) ? MARKS : 0))

unsigned int fs_count; // entries in the listed folder, folders first
unsigned int fs_found; // index of the folder fs_List was asked to find, 0xFFFF if it isn't there
WORD list_counts[2]; // folders, files
WORD list_slot; // slot (32 byte entry) dir is on, counted so the scan doesn't shift dir.dptr
WORD list_start; // slot the entry NextEntry found starts at, its LFN or its SFN
WORD mark_mask; // (1 << mark_shift) - 1
WORD read_next; // fs_ListEntry continues from dir if the index is the next one of read_kind or a little after
BYTE read_kind;
BYTE mark_shift;
FRESULT list_error;

static FRESULT Seek(WORD slot) {
  list_slot = slot;
  return dir_sdi(&dir, (DWORD)slot << 5);
}

// moves dir to its next slot, loading its sector when it changes, returns 0 at the end of the folder
// or on an error (list_error), where dir.sect is 0
static BYTE NextSlot(void) {
  FRESULT result;
  if (((BYTE)list_slot++ & (SS(&fs) / SZDIRE - 1)) != SS(&fs) / SZDIRE - 1) { // same sector
    dir.dptr += SZDIRE;
    dir.dir += SZDIRE;
    return 1;
  }
  if (!(result = dir_next(&dir, 0)) && !(result = move_window(&fs, dir.sect))) return 1;
  if (result != FR_NO_FILE) list_error = result;
  dir.sect = 0;
  return 0;
}

// finds the next visible entry from dir's slot like dir_read (skipping hidden, system and dot names),
// returns 1 for a folder, 2 for a file, 0 at the end, leaving dir on its SFN slot. With name set, its
// LFN goes in fs.lfnbuf (dir.blk_ofs is 0xFFFFFFFF if its name is the SFN).
static BYTE NextEntry(BYTE name) {
  BYTE c, attr, ord = 0xFF, sum = 0, dot = 0, named = 0, lfn;
  BYTE* entry;
  FRESULT result;
  if (!dir.sect) return 0;
  if (dir.sect != fs.winsect && (result = move_window(&fs, dir.sect))) { // after a seek
    list_error = result;
    return 0;
  }
  do {
    entry = dir.dir;
    if (!(c = entry[DIR_Name])) break; // end of the folder
    attr = entry[DIR_Attr] & AM_MASK;
    if (c == DDEM || c == '.' || (BYTE)(attr & ~AM_ARC) == AM_VOL) ord = 0xFF;
    else if (attr == AM_LFN) {
      if (c & LLEF) { // first slot of an LFN (its last part)
        c &= (BYTE)~LLEF;
        ord = c;
        sum = entry[LDIR_Chksum];
        named = name;
        list_start = list_slot;
      }
      if (c == ord && sum == entry[LDIR_Chksum] && !entry[LDIR_FstClusLO] && !entry[LDIR_FstClusLO + 1]) {
        if (named && !pick_lfn(fs.lfnbuf, entry)) named = 0; // too long, the SFN is shown
        if (!--ord) dot = entry[1] == '.' && !entry[2]; // first character
      }
      else ord = 0xFF;
    }
    else { // SFN
      lfn = !ord && sum == sum_sfn(entry);
      if (!lfn) list_start = list_slot;
      if (!(attr & (AM_HID | AM_SYS)) && !(lfn && dot)) {
        dir.blk_ofs = lfn && named ? (DWORD)list_start << 5 : 0xFFFFFFFF;
        return attr & AM_DIR ? 1 : 2;
      }
      ord = 0xFF;
    }
  } while (NextSlot());
  return 0;
}

// keeps every other mark when a kind has more than MARKS
static void HalveMarks(void) {
  BYTE i;
  for (i = 0; i < MARKS / 2; ++i) {
    MARK(0)[i] = MARK(0)[i << 1];
    MARK(1)[i] = MARK(1)[i << 1];
  }
  ++mark_shift;
  mark_mask = mark_mask << 1 | 1;
}

static FRESULT List(const char* path, const char* find) {
  WORD find_slot = 0xFFFF, n;
  BYTE kind;
  FRESULT result = f_opendir(&dir, path);
  if (result) return result;
  if (find && !create_name(&dir, &find) && !dir_find(&dir)) find_slot = (WORD)(dir.dptr >> 5);
  if ((result = Seek(0))) return result;
  list_counts[0] = list_counts[1] = 0;
  read_kind = 0xFF;
  mark_shift = 4;
  mark_mask = 15;
  list_error = FR_OK;
  fs_found = 0xFFFF;
  while ((kind = NextEntry(0))) {
    n = list_counts[--kind]++;
    if (list_slot == find_slot) fs_found = n; // a folder, so n is its index
    if (!(n & mark_mask)) {
      if (n >> mark_shift == MARKS) HalveMarks();
      MARK(kind)[n >> mark_shift] = list_start;
    }
    NextSlot();
  }
  fs_count = list_counts[0] + list_counts[1];
  return list_error;
}

// lists the folder at path (UTF-8, "" for the root) for fs_ListEntry, sets fs_count, and fs_found to the
// index of the folder named find in it (find can be 0), returns an FRESULT
unsigned char fs_List(const char* path, const char* find) {
  FRESULT result = List(path, find);
  if (result == FR_DISK_ERR) result = List(path, find); // mounts the card again (it may have been swapped)
  return result;
}

// the UTF-8 name of the entry NextEntry found, from its LFN (in fs.lfnbuf) or SFN, without get_fileinfo
// (which is much slower), returns 0 for the names it needs (surrogate pairs, SFN bytes above 0x7F,
// names that don't fit or are empty)
static BYTE GetName(char* name) {
  char* start = name;
  char* end = name + FF_LFN_BUF;
  WCHAR* lfn = fs.lfnbuf;
  WCHAR c;
  BYTE i, lower = NS_BODY;
  if (dir.blk_ofs != 0xFFFFFFFF) {
    while ((c = *lfn++)) {
      if (c < 0x80) {
        if (name == end) return 0;
        *name++ = (char)c;
      }
      else if (c < 0x800) {
        if (end - name < 2) return 0;
        *name++ = (char)(0xC0 | (c >> 6));
        *name++ = (char)(0x80 | (c & 0x3F));
      }
      else {
        if (IsSurrogate(c) || end - name < 3) return 0;
        *name++ = (char)(0xE0 | (c >> 12));
        *name++ = (char)(0x80 | ((c >> 6) & 0x3F));
        *name++ = (char)(0x80 | (c & 0x3F));
      }
    }
  }
  else {
    for (i = 0; i < 11; ++i) {
      c = dir.dir[i];
      if (c == ' ') continue;
      if (c >= 0x80 || c == RDDEM) return 0;
      if (i == 8) {
        *name++ = '.';
        lower = NS_EXT;
      }
      if (IsUpper(c) && (dir.dir[DIR_NTres] & lower)) c += 0x20;
      *name++ = (char)c;
    }
  }
  *name = 0;
  return name != start;
}

// reads the listed folder's entry at index, returns an FRESULT
unsigned char fs_ListEntry(unsigned int index, FileEntry* entry) {
  BYTE kind = index >= list_counts[0], found;
  FRESULT result;
  if (!fs.fs_type || dir.obj.id != fs.id || index >= fs_count) return FR_INVALID_OBJECT;
  if (kind) index -= list_counts[0];
  if (kind != read_kind || index < read_next || (index ^ read_next) > mark_mask) { // from the mark before it
    if ((result = Seek(MARK(kind)[index >> mark_shift]))) return result;
    read_kind = kind;
    read_next = index & ~mark_mask;
  }
  list_error = FR_OK;
  while ((found = NextEntry(read_next == index))) {
    if (found - 1 == kind && read_next++ == index) break;
    NextSlot();
  }
  if (!found) {
    read_kind = 0xFF;
    return list_error ? list_error : FR_NO_FILE; // the folder changed
  }
  if (!GetName(entry->name)) {
    get_fileinfo(&dir, &info);
    memcpy(entry->name, info.fname, FS_NAME_SIZE);
  }
  entry->size = ld_32(dir.dir + DIR_FileSize);
  entry->time = ld_16(dir.dir + DIR_ModTime);
  entry->date = ld_16(dir.dir + DIR_ModTime + 2);
  entry->dir = kind == 0;
  NextSlot();
  return FR_OK;
}

// f_open, again after a disk error (which mounts the card again, it may have been swapped)
static FRESULT Open(const char* path, BYTE mode) {
  FRESULT result = f_open(&file, path, mode);
  return result == FR_DISK_ERR ? f_open(&file, path, mode) : result;
}

// replaces the text buffer with the file, returns an FRESULT (FR_DENIED if it doesn't fit)
unsigned char fs_Load(const char* path) {
  UINT count;
  FRESULT result = Open(path, FA_READ);
  if (result) return result;
  tb_Clear();
  tb_cr = 0;
  do {
    result = f_read(&file, buffer, FS_BUFFER_SIZE, &count);
    if (result) break;
    if (!tb_Append(buffer, count)) {
      result = FR_DENIED;
      break;
    }
  } while (count == FS_BUFFER_SIZE);
  fs_crlf = tb_cr;
  f_close(&file);
  return result;
}

#ifdef EVERDRIVE_OS
#define WINDOW ((BYTE*)0xBE00) // EDX_WINDOW
extern void SetWindowBlock(unsigned int block); // src/fatfs/fatfs.asm

// copies the data file (data_file.py) to PSRAM from DATA_BLOCK, returns an FRESULT
// (FR_INVALID_OBJECT if it's the wrong size or version)
unsigned char fs_LoadData(const char* path) {
  UINT count;
  unsigned int block = DATA_BLOCK;
  FRESULT result = fs_Mount();
  if (!result) result = Open(path, FA_READ);
  if (result) return result;
  if (f_size(&file) != DATA_BLOCKS * 512UL) result = FR_INVALID_OBJECT;
  while (!result && block != DATA_BLOCK + DATA_BLOCKS) {
    SetWindowBlock(block++);
    result = f_read(&file, WINDOW, 512, &count);
  }
  f_close(&file);
  SetWindowBlock(DATA_BLOCK);
  if (!result && (memcmp(WINDOW, "EDITOR.DAT", 10) || WINDOW[10] != DATA_VERSION)) result = FR_INVALID_OBJECT;
  SetWindowBlock(TB_PSRAM_HIGH << 8);
  return result;
}

// A large file (bigger than the text buffer, up to DOC_MAX) is copied to PSRAM from DOC_BLOCK with
// CRs and 0s dropped, so document positions are text buffer positions plus win_start. The text buffer
// holds a window of it (fs_LoadWindow), read only for now. The text buffer's signature is cleared while
// it's open so booting after a reset restores the swap file instead of keeping a window that could be
// saved over the file, and the swap file isn't written (src/editor/editor.c)
#define LINE_SCAN 4096 // fs_DocLineStart looks back this far
extern unsigned char doc_large;
extern unsigned long doc_len, doc_lines, doc_pos, win_start;
extern void DocAppend(const BYTE* src, unsigned int count); // src/fatfs/fatfs.asm
extern void DocRead(BYTE* dest, unsigned int count);
extern void tb_Clear(void);
extern const char TBSignature[4]; // src/editor/text_buffer.asm

// sets the text buffer's signature (0 clears it)
static void Signature(const char* signature) {
  SetWindowBlock((TB_PSRAM_HIGH << 8) | MAIN_SRAM_BANK);
  if (signature) memcpy(WINDOW, signature, 4);
  else memset(WINDOW, 0, 4);
  SetWindowBlock(TB_PSRAM_HIGH << 8);
}

// leaves large file mode
void fs_CloseLarge(void) {
  if (!doc_large) return;
  doc_large = 0;
  Signature(TBSignature);
}

// copies the file to PSRAM and loads the window at its start, returns an FRESULT
unsigned char fs_LoadLarge(const char* path) {
  UINT count;
  FRESULT result = Open(path, FA_READ);
  if (result) return result;
  fs_CloseLarge();
  if (f_size(&file) > DOC_MAX) result = FR_DENIED;
  doc_len = doc_lines = 0;
  tb_cr = 0;
  while (!result) {
    result = f_read(&file, buffer, FS_BUFFER_SIZE, &count);
    if (result) break;
    DocAppend(buffer, count);
    if (count != FS_BUFFER_SIZE) break;
  }
  fs_crlf = tb_cr;
  f_close(&file);
  if (result) tb_Clear();
  else {
    doc_large = 1;
    Signature(0);
    win_start = 0;
    fs_LoadWindow();
  }
  return result;
}

// loads WIN_SIZE bytes of the document from win_start into the text buffer
void fs_LoadWindow(void) {
  unsigned long end = win_start + WIN_SIZE;
  UINT count;
  if (end > doc_len) end = doc_len;
  tb_Clear();
  doc_pos = win_start;
  while (doc_pos != end) {
    count = end - doc_pos > FS_BUFFER_SIZE ? FS_BUFFER_SIZE : (UINT)(end - doc_pos);
    DocRead(buffer, count);
    tb_Append(buffer, count);
  }
}

// moves doc_pos to the start of its line, looking back at most LINE_SCAN bytes (it stays if there's no line feed)
void fs_DocLineStart(void) {
  unsigned long pos = doc_pos, start = doc_pos;
  UINT count, i, scanned = 0;
  while (pos && scanned < LINE_SCAN) {
    count = pos > FS_BUFFER_SIZE ? FS_BUFFER_SIZE : (UINT)pos;
    pos -= count;
    doc_pos = pos;
    DocRead(buffer, count);
    for (i = count; i; --i) {
      if (buffer[i - 1] == ASCII_LF) {
        doc_pos = pos + i;
        return;
      }
    }
    scanned += count;
  }
  doc_pos = pos ? start : 0;
}

// The swap file keeps what PSRAM loses when the power is off: block MAIN_SRAM_BANK's first 256 bytes
// (the text buffer's signature, settings, clipboard length), "SWP1", the text's length, the sum of the
// bytes after the first 512 and the clipboard's length, then from 512 the clipboard and the text.
// Its old length stays (no f_truncate), so its clusters are written in place.
#define SWAP_PATH "/GBCSYS/EDITOR.SWP"
#define MAIN_BLOCK ((TB_PSRAM_HIGH << 8) | MAIN_SRAM_BANK)
#define SWAP_INFO TB_CLIP_OFFSET // the header is block MAIN's bytes before the clipboard
#define SWAP_DATA 512
extern const char TBSignature[4]; // src/editor/text_buffer.asm
extern unsigned int tb_Length(void);
extern unsigned int tb_ClipLength(void);
extern unsigned int ByteSum(const BYTE* data, unsigned int count); // src/fatfs/fatfs.asm
WORD swap_sum;

// reads or writes count bytes of PSRAM from offset in block, adds them to swap_sum
static FRESULT SwapBlocks(BYTE write, WORD block, WORD offset, WORD count) {
  UINT size, done;
  FRESULT result = FR_OK;
  while (count && !result) {
    size = 512 - offset;
    if (size > count) size = count;
    SetWindowBlock(block++);
    result = write ? f_write(&file, WINDOW + offset, size, &done) : f_read(&file, WINDOW + offset, size, &done);
    if (!result && done != size) result = FR_DENIED;
    swap_sum += ByteSum(WINDOW + offset, size);
    count -= size;
    offset = 0;
  }
  SetWindowBlock(TB_PSRAM_HIGH << 8);
  return result;
}

// writes the swap file, returns an FRESULT
unsigned char fs_SaveSwap(void) {
  UINT size, done;
  WORD clip = tb_ClipLength(), length = tb_Length();
  FRESULT result = fs_Mount();
  if (!result) result = Open(SWAP_PATH, FA_WRITE | FA_OPEN_ALWAYS);
  if (result) return result;
  swap_sum = 0;
  result = f_lseek(&file, SWAP_DATA);
  if (!result) result = SwapBlocks(1, MAIN_BLOCK, TB_CLIP_OFFSET, clip);
  tb_read_pos = 0;
  while (!result && (size = tb_Read(buffer, FS_BUFFER_SIZE))) {
    swap_sum += ByteSum(buffer, size);
    result = f_write(&file, buffer, size, &done);
    if (!result && done != size) result = FR_DENIED;
  }
  if (!result) result = f_lseek(&file, 0); // the header goes last, a write cut short leaves a bad sum
  if (!result) {
    SetWindowBlock(MAIN_BLOCK);
    memcpy(buffer, WINDOW, SWAP_INFO);
    SetWindowBlock(TB_PSRAM_HIGH << 8);
    memset(buffer + SWAP_INFO, 0, SWAP_DATA - SWAP_INFO);
    memcpy(buffer + SWAP_INFO, "SWP1", 4);
    ((WORD*)(buffer + SWAP_INFO))[2] = length;
    ((WORD*)(buffer + SWAP_INFO))[3] = swap_sum;
    ((WORD*)(buffer + SWAP_INFO))[4] = clip;
    result = f_write(&file, buffer, SWAP_DATA, &done);
  }
  if (f_close(&file) && !result) result = FR_DISK_ERR;
  return result;
}

// at boot: if PSRAM lost the text (the power was off), restores the text, clipboard and settings from
// the swap file, returns an FRESULT (FR_INVALID_OBJECT if it's bad, the text is cleared)
unsigned char fs_LoadSwap(void) {
  UINT done;
  WORD length, sum, clip;
  FRESULT result;
  SetWindowBlock(MAIN_BLOCK);
  result = memcmp(WINDOW, TBSignature, 4) ? FR_OK : FR_EXIST; // PSRAM kept it (a reset), it's newer
  SetWindowBlock(TB_PSRAM_HIGH << 8);
  if (!result) result = fs_Mount();
  if (!result) result = Open(SWAP_PATH, FA_READ);
  if (result) return result;
  result = f_read(&file, buffer, SWAP_DATA, &done);
  if (!result && (done != SWAP_DATA || memcmp(buffer + SWAP_INFO, "SWP1", 4))) result = FR_INVALID_OBJECT;
  if (result) {
    f_close(&file);
    return result;
  }
  length = ((WORD*)(buffer + SWAP_INFO))[2];
  sum = ((WORD*)(buffer + SWAP_INFO))[3];
  clip = ((WORD*)(buffer + SWAP_INFO))[4];
  SetWindowBlock(MAIN_BLOCK); // the header, without the signature until the sum checks out
  memcpy(WINDOW + 4, buffer + 4, SWAP_INFO - 4);
  swap_sum = 0;
  result = SwapBlocks(0, MAIN_BLOCK, TB_CLIP_OFFSET, clip);
  tb_Clear();
  while (!result && length) {
    result = f_read(&file, buffer, length < FS_BUFFER_SIZE ? length : FS_BUFFER_SIZE, &done);
    if (!result && !done) result = FR_INVALID_OBJECT;
    if (result) break;
    swap_sum += ByteSum(buffer, done);
    tb_Append(buffer, done);
    length -= done;
  }
  f_close(&file);
  if (!result && swap_sum != sum) result = FR_INVALID_OBJECT;
  if (result) {
    tb_Clear();
    SetWindowBlock(MAIN_BLOCK); // and the settings
    memset(WINDOW, 0, SWAP_INFO);
  } else {
    SetWindowBlock(MAIN_BLOCK);
    memcpy(WINDOW, TBSignature, 4);
  }
  SetWindowBlock(TB_PSRAM_HIGH << 8);
  return result;
}
#endif

// writes the text buffer to the file, with CR LF line endings if fs_crlf is set, returns an FRESULT
unsigned char fs_Save(const char* path) {
  UINT size, written;
  FRESULT result = Open(path, FA_WRITE | FA_CREATE_ALWAYS);
  if (result) return result;
  tb_read_pos = 0;
  while ((size = fs_crlf ? tb_ReadLines(buffer, FS_BUFFER_SIZE) : tb_Read(buffer, FS_BUFFER_SIZE))) {
    if ((result = f_write(&file, buffer, size, &written))) break;
    if (written != size) {
      result = FR_DENIED; // disk full
      break;
    }
  }
  if (f_close(&file) && !result) result = FR_DISK_ERR;
  return result;
}
