// src/fatfs/fatfs.c
// FatFs, its disk glue, and the file API, built as one file so it all lands in one ROM bank.
// Called from other banks through the ROM0 stubs in src/fatfs/fatfs.asm.
// NOTE: no static initializers (_GSINIT doesn't run)
#include "fatfs.h"
#include "../rtc/rtc.h"
#include "lib/ff.c"
#include "lib/ffunicode.c"
#include "../constants.h"
#include "../browser/paths.h"

typedef char check_name_size[FS_NAME_SIZE == FF_LFN_BUF + 1 ? 1 : -1];

#define FS_BUFFER_SIZE 512

// src/fatfs/sd.asm
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

// The browser's directory marks are disposable during a transfer. Use their
// buffer for two bounded paths and a small I/O buffer, leaving the document's
// open FIL and text/clipboard PSRAM untouched.
#define COPY_PATH (PATH_SIZE + FS_NAME_SIZE)
static BYTE Inside(const char* source, const char* destination) {
  while (*source && ((*source | 32) == (*destination | 32))) ++source, ++destination;
  return !*source && *destination == '/';
}

unsigned char fs_Rename(const char* source, const char* destination) {
  FRESULT result;
  if (Inside(source, destination)) return FR_DENIED;
  result = f_rename(source, destination);
  if (!result) FileMoved(source, destination);
  return result;
}

unsigned char fs_RenameName(const char* source, const char* name) {
  BYTE end = 0, i;
  char* dest = (char*)buffer;
  if (!name[0] || (name[0] == '.' && (!name[1] || (name[1] == '.' && !name[2])))) return FR_INVALID_NAME;
  for (i = 0; source[i]; ++i) if ((dest[i] = source[i]) == '/') end = i + 1;
  for (i = 0; name[i]; ++i) {
    if (end == COPY_PATH - 1) return FR_INVALID_NAME;
    dest[end++] = name[i];
  }
  dest[end] = 0;
  return fs_Rename(source, dest);
}

unsigned char fs_Copy(const char* source, const char* destination) {
  char* src = (char*)buffer;
  char* dst = (char*)buffer + COPY_PATH;
  WORD next[PATH_SIZE / 2];
  BYTE depth = 0, end, to, i;
  FIL input, output;
  UINT read, written;
  FRESULT result, closed;
  for (i = 0; (src[i] = source[i]); ++i) if (i == COPY_PATH - 1) return FR_INVALID_NAME;
  for (i = 0; (dst[i] = destination[i]); ++i) if (i == COPY_PATH - 1) return FR_INVALID_NAME;
  // FAT names are case insensitive. Reject a destination inside the source.
  if (Inside(src, dst)) return FR_DENIED;
  if (!(result = f_stat(dst, &info))) return FR_EXIST;
  if (result != FR_NO_FILE) return result;
  if ((result = f_stat(src, &info))) return result;
  while (1) {
    if (info.fattrib & AM_DIR) {
      if ((result = f_mkdir(dst))) return result;
      next[depth] = 0;
    }
    else {
      if ((result = f_open(&input, src, FA_READ))) return result;
      result = f_open(&output, dst, FA_WRITE | FA_CREATE_NEW);
      if (!result) {
        do {
          result = f_read(&input, buffer + 2 * COPY_PATH, FS_BUFFER_SIZE - 2 * COPY_PATH, &read);
          if (!result && read) {
            result = f_write(&output, buffer + 2 * COPY_PATH, read, &written);
            if (!result && written != read) result = FR_DENIED;
          }
        } while (!result && read);
        closed = f_close(&output);
        if (!result) result = closed;
        if (result) f_unlink(dst); // discard an incomplete file; completed siblings remain
      }
      closed = f_close(&input);
      if (!result) result = closed;
      if (result) return result;
      goto parent;
    }
    while (1) {
      if ((result = f_opendir(&dir, src))) return result;
      for (read = 0; read <= next[depth]; ++read) {
        if ((result = f_readdir(&dir, &info))) return result;
        if (!info.fname[0]) break;
      }
      f_closedir(&dir);
      if (info.fname[0]) {
        ++next[depth];
        for (end = 0; src[end]; ++end);
        for (to = 0; dst[to]; ++to);
        for (i = 0; info.fname[i]; ++i);
        if (end + (WORD)i + 2 > COPY_PATH || to + (WORD)i + 2 > COPY_PATH || depth + 1 == PATH_SIZE / 2) return FR_INVALID_NAME;
        src[end++] = dst[to++] = '/';
        for (i = 0; (src[end + i] = dst[to + i] = info.fname[i]); ++i);
        ++depth;
        break;
      }
parent:
      if (!depth) return FR_OK;
      for (end = 0; src[end]; ++end);
      while (src[--end] != '/');
      src[end] = 0;
      for (to = 0; dst[to]; ++to);
      while (dst[--to] != '/');
      dst[to] = 0;
      --depth;
    }
  }
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
  entry->cdate = ld_16(dir.dir + DIR_CrtTime + 2);
  entry->ctime = ld_16(dir.dir + DIR_CrtTime);
  entry->adate = ld_16(dir.dir + DIR_LstAccDate);
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

// A large file (bigger than the text buffer) stays open and is read from the card as needed. Edits make it
// a document: a list of pieces of the file and of the add buffer (PSRAM from ADD_BLOCK, text without CRs),
// document offsets count the pieces' bytes (a file piece's CRs too). The text buffer holds a window of the
// document from win_start (fs_LoadWindow). CRs and 0s aren't in it, so window positions aren't document
// offsets: win_kept has the window position of each 512 byte boundary in it, and a window loaded with win_mark
// in it gives that offset's window position. An edited window is committed before it moves or the document
// is saved (fs_CommitWindow): its text goes in the add buffer as one piece in place of the ones it came from.
// Saving writes a temp file in the file's folder and renames it over the file (fs_SaveLarge).
// The text buffer's signature is cleared while one is open so booting after a reset restores the swap file
// instead of a window that could be saved over the file, and the swap file isn't written (src/editor/editor.c)
#define LINE_SCAN 4096 // fs_DocLineStart looks back this far
#define NO_MARK 0xFFFFFFFF
#define SRC_FILE 0
#define SRC_ADD 1
#define TEMP_NAME "~EDITOR.TMP"
typedef struct { BYTE src; DWORD off; DWORD len; } Piece;
extern Piece pieces[MAX_PIECES]; // src/fatfs/fatfs.asm, in page DOC_PAGE (only its functions can read it)
extern unsigned char doc_large, win_chunks, win_edited, piece_count, piece_i;
extern unsigned long doc_len, doc_pos, win_start, win_end, win_mark, scan_pos, scan_target, scan_lines;
extern unsigned long piece_start, add_len;
extern unsigned int doc_back, win_mark_pos, win_kept[];
extern FIL save_file;
typedef char save_file_fits[sizeof(FIL) <= 64 ? 1 : -1]; // fatfs.asm reserves 64 bytes
extern unsigned int CountLF(const BYTE* data, unsigned int count); // src/fatfs/fatfs.asm
extern void tb_Clear(void);
extern void tb_Empty(void); // tb_Clear without zeroing the text buffer
extern unsigned int tb_Length(void);
extern const char TBSignature[4]; // src/editor/text_buffer.asm
unsigned char fs_LoadWindow(void);
static void Signature(const char* signature);

// sets the text buffer's signature (0 clears it)
static void Signature(const char* signature) {
  SetWindowBlock((TB_PSRAM_HIGH << 8) | MAIN_SRAM_BANK);
  if (signature) memcpy(WINDOW, signature, 4);
  else memset(WINDOW, 0, 4);
  SetWindowBlock(TB_PSRAM_HIGH << 8);
}

// copies count bytes between data (WRAM) and the add buffer at offset pos, write = to the add buffer
static void AddCopy(BYTE* data, unsigned long pos, UINT count, BYTE write) {
  UINT at, size;
  while (count) {
    at = (UINT)pos & 511;
    size = 512 - at;
    if (size > count) size = count;
    SetWindowBlock(ADD_BLOCK + (UINT)(pos >> 9));
    if (write) memcpy(WINDOW + at, data, size);
    else memcpy(data, WINDOW + at, size);
    data += size;
    pos += size;
    count -= size;
  }
  SetWindowBlock(TB_PSRAM_HIGH << 8);
}

// the piece document offset pos is in (piece_i, piece_start), 0 at the end
static Piece* DocPiece(unsigned long pos) {
  if (pos < piece_start) {
    piece_i = 0;
    piece_start = 0;
  }
  while (piece_i < piece_count && pos >= piece_start + pieces[piece_i].len) piece_start += pieces[piece_i++].len;
  return piece_i == piece_count ? 0 : &pieces[piece_i];
}

// reads up to count bytes of the document at pos into dest, not past the end of pos's piece, returns the
// bytes read, 0 at the end or after an error
static UINT DocRead(BYTE* dest, unsigned long pos, UINT count) {
  Piece* piece = DocPiece(pos);
  unsigned long in;
  UINT done;
  if (!piece) return 0;
  in = pos - piece_start;
  if (piece->len - in < count) count = (UINT)(piece->len - in);
  in += piece->off;
  if (piece->src == SRC_ADD) {
    AddCopy(dest, in, count, 0);
    return count;
  }
  if ((f_tell(&file) != in && f_lseek(&file, in)) || f_read(&file, dest, count, &done) || done != count) return 0;
  return count;
}

// DocRead across pieces, returns 0 if it can't read them all
static UINT DocReadAll(BYTE* dest, unsigned long pos, UINT count) {
  UINT done = 0, size;
  while (done != count) {
    if (!(size = DocRead(dest + done, pos + done, count - done))) return 0;
    done += size;
  }
  return count;
}

// leaves large file mode
void fs_CloseLarge(void) {
  if (!doc_large) return;
  doc_large = 0;
  f_close(&file);
  Signature(TBSignature);
}

// the document is the open file
static void OneFilePiece(void) {
  doc_len = f_size(&file);
  pieces[0].src = SRC_FILE;
  pieces[0].off = 0;
  pieces[0].len = doc_len;
  piece_count = 1;
  piece_i = 0;
  piece_start = 0;
  add_len = 0;
}

// opens the file and loads the window at its start, returns an FRESULT
unsigned char fs_LoadLarge(const char* path) {
  FRESULT result;
  fs_CloseLarge();
  if ((result = Open(path, FA_READ))) return result;
  OneFilePiece();
  doc_large = 1;
  Signature(0);
  win_start = 0;
  win_mark = NO_MARK;
  tb_cr = 0;
  if ((result = fs_LoadWindow())) {
    fs_CloseLarge();
    tb_Clear();
  }
  fs_crlf = tb_cr;
  return result;
}

// loads the document from win_start (up to WIN_SIZE bytes) into the text buffer, sets win_end, win_kept[i] to
// the window position of document offset ((win_start + 511) & ~511) + 512 i and win_mark_pos to win_mark's
// (0xFFFF if it isn't in the window), returns an FRESULT
unsigned char fs_LoadWindow(void) {
  unsigned long pos = win_start, end = win_start + WIN_SIZE, next;
  UINT count;
  FRESULT result = FR_OK;
  if (end > doc_len) end = doc_len;
  tb_Empty();
  win_chunks = 0;
  win_mark_pos = 0xFFFF;
  while (1) {
    if (!((UINT)pos & 511)) win_kept[win_chunks++] = tb_Length();
    if (pos == win_mark) win_mark_pos = tb_Length();
    if (pos == end) break;
    next = (pos | 511) + 1;
    if (next > end) next = end;
    if (win_mark > pos && win_mark < next) next = win_mark;
    if (!(count = DocRead(buffer, pos, (UINT)(next - pos)))) {
      result = FR_INT_ERR;
      break;
    }
    tb_Append(buffer, count);
    pos += count;
  }
  win_end = pos;
  win_edited = 0;
  return result;
}

// moves doc_pos (a document offset) to the start of its line, looking back at most LINE_SCAN bytes (it stays
// if there's no line feed), sets doc_back to the window positions it moved back (CRs and 0s aren't counted)
void fs_DocLineStart(void) {
  unsigned long pos = doc_pos;
  UINT count, i, kept = 0, scanned = 0;
  BYTE c;
  doc_back = 0;
  while (pos && scanned < LINE_SCAN) {
    count = (UINT)pos & 511;
    if (!count) count = 512;
    pos -= count;
    if (!DocReadAll(buffer, pos, count)) return;
    for (i = count; i; --i) {
      c = buffer[i - 1];
      if (c == ASCII_LF) {
        doc_pos = pos + i;
        doc_back = kept;
        return;
      }
      if (c != ASCII_CR && c) ++kept;
    }
    scanned += count;
  }
  if (!pos) {
    doc_pos = 0;
    doc_back = kept;
  }
}

// counts the line feeds of up to SCAN_SECTORS sectors toward scan_target into scan_lines, returns 1 when
// it's there (or the card can't be read). A sector takes ~48 lines of the screen's 154 (CountLF ~18, the read ~12),
// another one starts only if it ends before the next VBlank (the main loop waits for it)
#define SCAN_SECTORS 4
#define SCAN_LAST_LINE 90 // lines since VBlank another sector can start at
#define rLY (*(volatile BYTE*)0xFF44)
unsigned char fs_ScanStep(void) {
  UINT count;
  unsigned char i;
  for (i = 0; i < SCAN_SECTORS && scan_pos != scan_target; ++i) {
    if (i && (rLY >= 144 ? rLY - 144 : rLY + 10) > SCAN_LAST_LINE) break;
    count = 512 - ((UINT)scan_pos & 511);
    if (scan_target - scan_pos < count) count = (UINT)(scan_target - scan_pos);
    if (!DocReadAll(buffer, scan_pos, count)) return 1;
    scan_lines += CountLF(buffer, count);
    scan_pos += count;
  }
  return scan_pos == scan_target;
}

// a piece starts at document offset pos (the one it's in is split), returns its index (piece_count at the
// end), 0xFF if the table is full
static unsigned char Split(unsigned long pos) {
  unsigned long start = 0;
  unsigned char i, j;
  for (i = 0; i < piece_count; start += pieces[i++].len) {
    if (pos == start) return i;
    if (pos < start + pieces[i].len) {
      if (piece_count == MAX_PIECES) return 0xFF;
      for (j = piece_count; j > i; --j) pieces[j] = pieces[j - 1];
      ++piece_count;
      pieces[i + 1].off += pos - start;
      pieces[i + 1].len -= pos - start;
      pieces[i].len = pos - start;
      return i + 1;
    }
  }
  return i;
}

// if the window was edited, its text replaces the document range it came from (win_start, win_end) as one
// piece of the add buffer. Returns 0 if the add buffer or the piece table is full
unsigned char fs_CommitWindow(void) {
  UINT length = tb_Length(), count;
  unsigned long pos = add_len;
  unsigned char a, b, i, j;
  if (!win_edited) return 1;
  if (add_len + length > ADD_MAX || piece_count > MAX_PIECES - 3) return 0;
  tb_read_pos = 0;
  while ((count = tb_Read(buffer, FS_BUFFER_SIZE))) {
    AddCopy(buffer, pos, count, 1);
    pos += count;
  }
  a = Split(win_start);
  b = Split(win_end);
  i = a + (length ? 1 : 0); // where piece b goes
  if (i < b) for (j = b; j < piece_count; ++j) pieces[i + j - b] = pieces[j];
  else if (i > b) for (j = piece_count; j > b; --j) pieces[j] = pieces[j - 1];
  piece_count = piece_count + i - b;
  if (length) {
    pieces[a].src = SRC_ADD;
    pieces[a].off = add_len;
    pieces[a].len = length;
  }
  piece_i = 0;
  piece_start = 0;
  add_len = pos;
  doc_len = doc_len - (win_end - win_start) + length;
  win_end = win_start + length;
  win_chunks = 0; // window positions are document offsets - win_start now
  for (pos = (win_start + 511) & ~511UL; pos <= win_end && win_chunks < WIN_CHUNKS; pos += 512) win_kept[win_chunks++] = (UINT)(pos - win_start);
  win_edited = 0;
  return 1;
}

// adds count bytes to the save file's next sector (gathered in PSRAM block SAVE_BLOCK, *fill bytes so far),
// writing it when it's full: whole sector writes skip FatFs's one sector cache (FF_FS_TINY), which the file's
// reads need. Returns an FRESULT
#define SAVE_BLOCK (ADD_BLOCK - 1)
static FRESULT SaveOut(const BYTE* data, UINT count, UINT* fill) {
  UINT size, done;
  FRESULT result = FR_OK;
  SetWindowBlock(SAVE_BLOCK);
  while (count) {
    size = 512 - *fill;
    if (size > count) size = count;
    memcpy(WINDOW + *fill, data, size);
    *fill += size;
    data += size;
    count -= size;
    if (*fill == 512) { // the window still shows the block while FatFs writes it
      *fill = 0;
      if ((result = f_write(&save_file, WINDOW, 512, &done)) || (done != 512 && (result = FR_DENIED))) break;
    }
  }
  SetWindowBlock(TB_PSRAM_HIGH << 8);
  return result;
}

// saves the document to path: writes TEMP_NAME in its folder (added text with CR LF line endings if
// fs_crlf), deletes path and renames the temp file to it, then the document is that file (one piece) with
// the window at the same text. Returns an FRESULT (FR_DENIED: the add buffer or piece table is full, or the
// card is)
unsigned char fs_SaveLarge(const char* path) {
  char temp[PATH_SIZE + FS_NAME_SIZE];
  unsigned long pos = 0, out = 0, start = 0;
  UINT count, done, i, end = 0, fill = 0;
  BYTE *src, *dest, c, crlf;
  Piece* piece;
  FRESULT result;
  if (!fs_CommitWindow()) return FR_DENIED;
  for (i = 0; path[i]; ++i) if (path[i] == '/') end = i + 1;
  memcpy(temp, path, end);
  memcpy(temp + end, TEMP_NAME, sizeof(TEMP_NAME));
  if ((result = f_open(&save_file, temp, FA_WRITE | FA_CREATE_ALWAYS))) return result;
  while (pos != doc_len) {
    if (pos == win_start) start = out;
    piece = DocPiece(pos);
    crlf = fs_crlf && piece->src == SRC_ADD; // added text gets CRs, it's read into the second half
    count = crlf ? 256 : 512;
    if (piece->src == SRC_FILE) count -= (UINT)(pos - piece_start + piece->off) & 511; // whole sectors skip FatFs's copy
    if (pos < win_start && win_start - pos < count) count = (UINT)(win_start - pos);
    src = crlf ? buffer + 256 : buffer;
    if (!(count = DocRead(src, pos, count))) {
      result = FR_INT_ERR;
      break;
    }
    pos += count;
    if (crlf) { // in place: each line feed's CR is written before it's read
      for (dest = buffer, i = 0; i < count; ++i) {
        if ((c = src[i]) == ASCII_LF) *dest++ = ASCII_CR;
        *dest++ = c;
      }
      src = buffer;
      count = (UINT)(dest - buffer);
    }
    if ((result = SaveOut(src, count, &fill))) break;
    out += count;
  }
  if (pos == win_start) start = out;
  if (!result && fill) { // the last part of a sector
    SetWindowBlock(SAVE_BLOCK);
    if (!(result = f_write(&save_file, WINDOW, fill, &done)) && done != fill) result = FR_DENIED;
    SetWindowBlock(TB_PSRAM_HIGH << 8);
  }
  if (!result) result = f_close(&save_file);
  else f_close(&save_file);
  if (result) return result;
  f_close(&file);
  result = f_unlink(path);
  if (result && result != FR_NO_FILE) return result;
  if ((result = f_rename(temp, path)) || (result = Open(path, FA_READ))) return result;
  OneFilePiece();
  win_start = start;
  win_mark = NO_MARK;
  return fs_LoadWindow();
}

// Games: a .gb or .gbc file is copied to PSRAM from block 0 and launched (GameLaunch in fatfs.asm, the cart
// resets the Game Boy into it). A game with battery RAM gets its save from /GBCSYS/SAVE/<name>.srm (the
// EverDrive OS's save files) in the cart's save RAM first, blank ($FF) if there isn't one, and GAME_RECORD
// remembers it, so the next boot writes the save RAM back to that file (fs_BackupSave). Save RAM is only
// touched here, through the window with $BD06 bit 1 set
#define GAME_RECORD "/GBCSYS/EDITOR.GAM" // GAM3: pending, RegistrySum, RTC flag, SRAM sectors, .srm path
#define REGISTRY "/GBCSYS/REGISTRY.BIN" // the EverDrive OS's, rewritten when it launches a game
#define SAVE_FOLDER "/GBCSYS/SAVE/"
#define GAME_BLOCKS 0x3C00 // PSRAM blocks before the EverDrive's save states
#define rEDX_CONFIG (*(volatile BYTE*)0xBD06)
extern unsigned char game_mapper, game_rom_mask, game_ram_mask, game_config, game_bd20; // src/fatfs/fatfs.asm, for GameLaunch
extern unsigned char game_has_rtc, game_header[32], game_cheats;
extern unsigned int game_save_sectors;
extern unsigned char backup_skipped; // fs_BackupSave didn't trust the save RAM
extern unsigned int ByteSum(const BYTE* data, unsigned int count); // src/fatfs/fatfs.asm

// the EverDrive OS's registry, summed (into buffer): if it changed since a game was launched here the
// EverDrive OS launched one since, and the save RAM is that game's (a backup wrote a Beisbol save over a
// Pokemon one). 0 if there's none. Like the EverDrive OS's launch: $BD06 = $08, bit 5 set if its byte 5 ($C030)
// is 0 (the system button?), $BD20 = 3 if byte 6 ($C031, Pocket fix) is 0, defaults 1 and 0
static UINT RegistrySum(void) {
  UINT done = 0;
  if (!f_open(&save_file, REGISTRY, FA_READ)) {
    if (f_read(&save_file, buffer, FS_BUFFER_SIZE, &done)) done = 0;
    f_close(&save_file);
  }
  game_cheats = done > 2 ? buffer[2] : 1;
  game_config = done > 6 && !buffer[5] ? 0x28 : 0x08;
  game_bd20 = done > 6 && buffer[6] ? 0 : 3;
  return done ? ByteSum(buffer, done) + done : 0;
}
static const BYTE battery_types[] = {0x03, 0x06, 0x09, 0x0D, 0x0F, 0x10, 0x13, 0x17, 0x1B, 0x1E, 0x22, 0xFF, 0}; // carts with saves

// the window shows save RAM (on) or PSRAM block block
static void SaveRamBlock(UINT block, BYTE on) {
  SetWindowBlock(block);
  if (on) rEDX_CONFIG |= 2;
  else rEDX_CONFIG &= ~2;
}

// copies banks 8KB banks of save RAM to the open file (write) or from it (0xFF where it ends)
static FRESULT SaveRamFile(UINT sectors, BYTE write) {
  UINT block, done;
  FRESULT result = FR_OK;
  for (block = 0; !result && block < sectors; ++block) {
    if (write) {
      SaveRamBlock(block, 1);
      if (!(result = f_write(&save_file, WINDOW, 512, &done)) && done != 512) result = FR_DENIED;
    }
    else {
      if (!(result = f_read(&save_file, buffer, 512, &done))) memset(buffer + done, 0xFF, 512 - done);
      SaveRamBlock(block, 1);
      memcpy(WINDOW, buffer, 512);
    }
    SaveRamBlock(TB_PSRAM_HIGH << 8, 0);
  }
  return result;
}

// at boot: if a game was launched, writes the save RAM to its .srm (the old one becomes .bak), unless the
// EverDrive OS launched a game since (backup_skipped). Returns an FRESULT

static FRESULT WriteGameRTC(const char* path);
static FRESULT BackupRegistry(UINT sum);
static FRESULT BackupSnapshot(char* path, UINT sectors);
unsigned char fs_BackupSave(void) {
  UINT done, sum, i, sectors;
  BYTE path = 7, rtc = 0;
  char saved[sizeof(SAVE_FOLDER) + FS_NAME_SIZE + 4], bak[sizeof(SAVE_FOLDER) + FS_NAME_SIZE + 4];
  FRESULT result = fs_Mount();
  backup_skipped = 0;
  if (result) return result;
  sum = RegistrySum();
  if (f_open(&save_file, GAME_RECORD, FA_READ)) return BackupRegistry(sum);
  result = f_read(&save_file, buffer, 255, &done); f_close(&save_file);
  if (result) return result;
  if (done < 8) return FR_INT_ERR;
  if (!buffer[4]) return ld_16(buffer + 5) == sum ? FR_OK : BackupRegistry(sum);
  if (!memcmp(buffer, "GAM1", 4)) path = 5;
  else if (!memcmp(buffer, "GAM3", 4)) { if (done < 11) return FR_INT_ERR; path = 10; rtc = buffer[7]; }
  else if (memcmp(buffer, "GAM2", 4)) return FR_INT_ERR;
  sectors = path == 10 ? buffer[8] | ((UINT)buffer[9] << 8) : (UINT)buffer[4] << 4;
  if (path != 5 && ld_16(buffer + 5) != sum) { backup_skipped = 1; return BackupRegistry(sum); }
  else {
    buffer[254] = 0;
    for (i = 0; i < sizeof(saved) - 1 && (saved[i] = buffer[path + i]); ++i);
    if (i == sizeof(saved) - 1 || i < 4) return FR_INT_ERR;
    memcpy(bak, saved, i + 1); memcpy(bak + i - 3, "bak", 3);
    if (sectors) {
      f_unlink(bak); f_rename(saved, bak);
      if ((result = f_open(&save_file, saved, FA_WRITE | FA_CREATE_ALWAYS))) return result;
      result = SaveRamFile(sectors, 1); f_close(&save_file); if (result) return result;
    }
    if (rtc) { memcpy(saved + i - 3, "rtc", 3); if ((result = WriteGameRTC(saved))) return result; }
    // Older FatPak launches never initialized the stock snapshot slot.
    if (path == 10 && (result = BackupSnapshot(saved, sectors))) return result;
  }
  if (!(result = f_open(&save_file, GAME_RECORD, FA_WRITE))) {
    const BYTE finished = 0;
    result = f_lseek(&save_file, 4);
    if (!result) result = f_write(&save_file, &finished, 1, &done);
    f_close(&save_file);
  }
  return result;
}

// a game loads in steps (the file browser shows the progress): fs_GameOpen checks it and takes what
// GameLaunch needs from the header, fs_GameCopy copies runs of consecutive clusters of it to PSRAM with one
// multi-block read each (game_block of game_blocks), fs_GameFinish loads its save and remembers it.
// Returns an FRESULT (FR_DENIED: too big). After fs_GameOpen PSRAM's text gets overwritten
#define GAME_CHUNK 256 // sectors fs_GameCopy reads at most (128KB)
extern unsigned int game_block, game_blocks; // src/fatfs/fatfs.asm
extern unsigned long game_clst;
extern unsigned char game_banks;
extern unsigned char sd_ReadBlocks(unsigned int block, unsigned int count); // src/fatfs/sd.asm, from LBA sd_sector
unsigned char fs_GameOpen(const char* path) {
  UINT done, i;
  BYTE type, size;
  unsigned long length;
  FRESULT result;
  if ((result = fs_BackupSave())) return result; // an earlier game's save first, or its progress is lost
  if ((result = Open(path, FA_READ))) return result;
  length = f_size(&file);
  if (length > (unsigned long)GAME_BLOCKS << 9 || (result = f_read(&file, buffer, FS_BUFFER_SIZE, &done)) || done < 0x150) {
    f_close(&file);
    return result ? result : FR_DENIED;
  }
  memcpy(game_header, buffer + 0x134, 32);
  type = buffer[0x147];
  game_has_rtc = type == 0x0F || type == 0x10;
  game_mapper = !type || type == 8 || type == 9 ? 4 : type <= 3 ? 1 : type <= 6 ? 2 : type >= 0x0F && type <= 0x13 ? 3 : 5;
  size = buffer[0x149];
  game_banks = size == 3 ? 4 : size == 4 ? 16 : size == 5 ? 8 : 1;
  game_ram_mask = game_mapper == 2 ? 0 : size == 1 || size == 2 ? 0 : game_banks - 1;
  for (game_rom_mask = 0, length = (length + 0x7FFF) >> 15; length > 1; length = (length + 1) >> 1) game_rom_mask = (game_rom_mask << 1) | 1; // 32KB units
  for (i = 0; battery_types[i] && battery_types[i] != type; ++i);
  if (!battery_types[i]) game_banks = 0;
  game_save_sectors = !game_banks ? 0 : game_mapper == 2 ? 1 : !size ? 0 : size == 1 ? 4 : (UINT)game_banks << 4;
  game_blocks = (UINT)((f_size(&file) + 511) >> 9);
  game_block = 0;
  game_clst = file.obj.sclust;
  Signature(0); // the text in PSRAM gets overwritten, the next boot restores the swap file
  return FR_OK;
}

unsigned char fs_GameCopy(void) {
  FATFS* fs = file.obj.fs;
  unsigned long next = game_clst, last;
  UINT count = fs->csize;
  BYTE check = 0;
  while (count < GAME_CHUNK && game_block + count < game_blocks) { // consecutive clusters
    if ((last = get_fat(&file.obj, next)) != next + 1) break;
    next = last;
    count += fs->csize;
  }
  if (count > game_blocks - game_block) count = game_blocks - game_block;
  if (!(sd_sector = clst2sect(fs, game_clst)) || sd_ReadBlocks(game_block, count)) {
    SetWindowBlock(TB_PSRAM_HIGH << 8);
    return FR_DISK_ERR;
  }
  game_block += count;
  if (game_block == game_blocks) { // compare to the source header retained by fs_GameOpen
    SetWindowBlock(0);
    check = memcmp(WINDOW + 0x134, game_header, sizeof(game_header)) != 0;
  }
  SetWindowBlock(TB_PSRAM_HIGH << 8);
  if (check) return FR_DISK_ERR;
  if (game_block != game_blocks && (game_clst = get_fat(&file.obj, next)) < 2) return FR_INT_ERR;
  return FR_OK;
}

static void GamePath(char* out, const char* path, const char* extension) {
  UINT i, base = 0, dot = 0;
  for (i = 0; path[i]; ++i) if (path[i] == '/') base = i + 1;
  for (i = base; path[i]; ++i) if (path[i] == '.') dot = i;
  if (!dot) dot = i;
  memcpy(out, SAVE_FOLDER, sizeof(SAVE_FOLDER) - 1);
  memcpy(out + sizeof(SAVE_FOLDER) - 1, path + base, dot - base);
  memcpy(out + sizeof(SAVE_FOLDER) - 1 + dot - base, extension, 5);
}
static FRESULT ReadGameRTC(const char* path) {
  BYTE rtc[10], i;
  UINT done;
  FRESULT result;
  memset(rtc, 0, sizeof(rtc));
  if (!(result = f_open(&save_file, path, FA_READ))) {
    result = f_read(&save_file, rtc, sizeof(rtc), &done);
    f_close(&save_file);
    if (!result && done != sizeof(rtc)) result = FR_INT_ERR;
    if (result) return result;
  }
  else if (result != FR_NO_FILE && result != FR_NO_PATH) return result;
  // Both halted is the stock "uninitialized" marker. A new clock starts at zero.
  if ((rtc[4] & 0x40) && (rtc[9] & 0x40)) { memset(rtc, 0, sizeof(rtc)); result = FR_NO_FILE; }
  for (i = 0; i < 2; ++i) if (rtc[i*5] >= 60 || rtc[i*5+1] >= 60 || rtc[i*5+2] >= 24 || (rtc[i*5+4] & 0x3E)) return FR_INT_ERR;
  if (result) { ClockDate date; if (!ClockRead(&date)) { rtc[4] = 0x40; ClockAdvance(rtc); rtc[4] = 0; } }
  else ClockAdvance(rtc); // clock-less carts keep the stored registers
  // Match stock WriteMapperRTCRegisters and its pre-launch handoff ($629F).
  // Halt both counters while replacing their seconds/day fields.
  *(volatile BYTE*)0xBD13 = 4;
  *(volatile BYTE*)0xBD10 = 0x40; *(volatile BYTE*)0xBD11 = 0x40;
  for (i = 0; i < 5; ++i) {
    *(volatile BYTE*)0xBD13 = i;
    *(volatile BYTE*)0xBD10 = rtc[i]; *(volatile BYTE*)0xBD11 = rtc[i + 5];
  }
  *(volatile BYTE*)0xBD13 = 6; *(volatile BYTE*)0xBD10 = 1;
  *(volatile BYTE*)0xBD13 = 0;
  return FR_OK;
}
static FRESULT WriteGameRTC(const char* path) {
  BYTE rtc[10], i;
  UINT done;
  FRESULT result;
  SaveRamBlock(255, 1);
  for (i = 0; i < 5; ++i) { rtc[i] = WINDOW[496 + i * 2]; rtc[i + 5] = WINDOW[497 + i * 2]; }
  SaveRamBlock(TB_PSRAM_HIGH << 8, 0);
  if (rtc[4] == 0x40 && rtc[9] == 0x40) return FR_OK;
  memset(buffer, 0, 512); memcpy(buffer, rtc, sizeof(rtc));
  result = f_open(&save_file, path, FA_WRITE | FA_CREATE_ALWAYS);
  if (result) return result;
  result = f_write(&save_file, buffer, 512, &done);
  if (!result && done != 512) result = FR_DENIED;
  f_close(&save_file);
  return result;
}
// Preserve options, replace the stock last-game metadata/entry, and recompute
// its additive checksum. The stock backup path needs the same basename and RAM
// sector count as FatPak; otherwise changing OS can overwrite another save.
static FRESULT RegistryGame(const char* path) {
  UINT done, i, base = 0, length = 0, sum;
  DWORD cluster = file.obj.sclust, size = f_size(&file), id = (file.dir_sect << 4) | ((file.dir_ptr - fs.win) >> 5);
  FRESULT result;
  for (i = 0; path[i]; ++i) if (path[i] == '/') base = i + 1;
  memset(buffer, 0, 512);
  result = f_open(&save_file, REGISTRY, FA_READ);
  if (!result) {
    result = f_read(&save_file, buffer, 512, &done); f_close(&save_file);
    if (result) return result;
    if (done < 266 || buffer[0] != 0x34 || buffer[1] != 0x12 || ByteSum(buffer, 264) != ld_16(buffer + 264)) return FR_INT_ERR;
  }
  else if (result == FR_NO_FILE || result == FR_NO_PATH) { buffer[0] = 0x34; buffer[1] = 0x12; buffer[2] = buffer[5] = 1; }
  else return result;
  memset(buffer + 7, 0, 257);
  buffer[7] = game_mapper; buffer[8] = game_rom_mask; buffer[9] = game_ram_mask;
  buffer[10] = game_has_rtc || game_save_sectors; buffer[11] = game_header[18] == 3; buffer[12] = game_header[15] & 0x80 ? 1 : 0;
  buffer[13] = game_has_rtc; st_16(buffer + 14, game_blocks); st_16(buffer + 16, game_save_sectors);
  memcpy(buffer + 18, game_header, 16);
  for (i = base; path[i] && length < 207; ++i) {
    BYTE c = path[i];
    if (c == 0xC2 || c == 0xC3) { BYTE next = path[i + 1]; if ((next & 0xC0) == 0x80) { c = ((c & 3) << 6) | (next & 63); ++i; } }
    buffer[34 + length++] = c;
  }
  // The stock path builder treats exactly eleven name bytes as raw FAT 8+3.
  if (length == 11) {
    BYTE dot = 0;
    for (i = 0; i < length; ++i) if (buffer[34 + i] == '.') dot = i;
    if (dot && dot <= 8 && length - dot - 1 <= 3) {
      BYTE short_name[12]; memset(short_name, ' ', 11); short_name[11] = 0;
      memcpy(short_name, buffer + 34, dot); memcpy(short_name + 8, buffer + 35 + dot, length - dot - 1);
      memcpy(buffer + 34, short_name, 12);
    }
  }
  st_32(buffer + 34 + 216, id); st_32(buffer + 34 + 220, cluster); st_32(buffer + 34 + 224, size);
  buffer[263] = 1; sum = ByteSum(buffer, 264); st_16(buffer + 264, sum);
  result = f_open(&save_file, REGISTRY, FA_WRITE | FA_CREATE_ALWAYS);
  if (result) return result;
  result = f_write(&save_file, buffer, 512, &done);
  if (!result && done != 512) result = FR_DENIED;
  if (result) f_close(&save_file); else result = f_close(&save_file);
  return result;
}

// The stock cheat file is sixteen XXX-XXX-XXX lines, with X for unused
// digits/slots. These are Game Genie ROM patches, applied before launching.
#define CHEAT_FOLDER "/GBCSYS/CHEATS/"
static BYTE CheatHex(BYTE c) {
  if (c >= '0' && c <= '9') return c-'0';
  c |= 32; return c >= 'a' && c <= 'f' ? c-'a'+10 : 0xFF;
}
static void CheatApply(const BYTE* code) {
  BYTE value, compare, check, hi;
  UINT address, block, last;
  if (code[0]>15 || code[1]>15 || code[2]>15 || code[3]>15 || code[4]>15 || code[5]<8 || code[5]>15) return;
  address=((UINT)(code[5]^15)<<12)|((UINT)code[2]<<8)|((UINT)code[3]<<4)|code[4];
  value=(code[0]<<4)|code[1];
  check=code[6]<16 && code[8]<16;
  hi=((code[6]<<4)|code[8])^255;
  compare=((hi>>2)|(hi<<6))^0x45;
  // Match stock A757: compare codes scan every 16KiB physical bank;
  // no-compare codes patch only the first bank, with address bit 14 ignored.
  block=(address & 0x3FFF)>>9; last=check ? game_blocks : block+1;
  for (; block<last; block+=32) {
    SetWindowBlock(block);
    if (!check || WINDOW[address&511]==compare) WINDOW[address&511]=value;
  }
}
static FRESULT GameCheats(const char* path) {
  char name[sizeof(CHEAT_FOLDER)+FS_NAME_SIZE+4];
  BYTE codes[144], digit=0, row=0, c, column=0;
  UINT i, done; FRESULT result;
  if (!game_cheats) return FR_OK;
  GamePath(name,path,".txt");
  for (i=0; name[i]; ++i);
  do { name[i+2]=name[i]; } while (i-- > sizeof(SAVE_FOLDER)-1);
  memcpy(name,CHEAT_FOLDER,sizeof(CHEAT_FOLDER)-1);
  result=f_open(&save_file,name,FA_READ);
  if (result==FR_NO_FILE || result==FR_NO_PATH) return FR_OK;
  if (result) return result;
  result=f_read(&save_file,buffer,512,&done); f_close(&save_file); if (result) return result;
  memset(codes,0xFF,sizeof(codes));
  for (i=0; i<done && row<16; ++i) {
    c=buffer[i];
    if (c=='\r') continue;
    if (c=='\n') { if (column) ++row; digit=column=0; continue; }
    if (c=='-' || c==' ' || c=='\t') continue;
    if (digit<9) codes[row*9+digit++]=CheatHex(c);
    ++column;
  }
  for (i=0; i<16; ++i) CheatApply(codes+i*9);
  SetWindowBlock(TB_PSRAM_HIGH << 8);
  return FR_OK;
}

// Stock snapshots are 164 512-byte sectors. Load into spare PSRAM first:
// a failed/short read must leave the suspended game available to Resume.
#define SNAP_FOLDER "/GBCSYS/SNAP/"
#define SNAP_FIRST 0x3E40
#define SNAP_STAGE 0x3C00
#define SNAP_SECTORS 164
#define GAME_META 0x3E2F
extern unsigned char snapshot_model;
static void SnapshotPath(char* out, const char* path) {
  GamePath(out, path, ".sav"); memcpy(out, SNAP_FOLDER, sizeof(SNAP_FOLDER) - 1);
}
static FRESULT SnapshotFile(const char* path, BYTE write, UINT first) {
  UINT n, done; FRESULT result, closed;
  result = f_open(&save_file, path, write ? FA_WRITE | FA_CREATE_ALWAYS : FA_READ);
  if (result) return result;
  if (!write && f_size(&save_file) != 83968UL) result = FR_INT_ERR;
  for (n = 0; !result && n < SNAP_SECTORS; ++n) {
    SetWindowBlock(first + n);
    result = write ? f_write(&save_file, WINDOW, 512, &done) : f_read(&save_file, WINDOW, 512, &done);
    if (!result && done != 512) result = FR_DENIED;
    if (!result && !write && !n && memcmp(WINDOW, "SAVE", 4)) result = FR_INT_ERR;
  }
  SetWindowBlock(TB_PSRAM_HIGH << 8);
  closed = f_close(&save_file); return result ? result : closed;
}
// ASM.MOD's files (ModFile, ModLoad): the whole file into PSRAM, a ModuleLoad {block, blocks,
// size}; 0 ok, 1 unreadable, 2 too big
typedef struct { UINT block, blocks; DWORD size; } FileLoadArea;
BYTE fs_LoadFile(const char* path, FileLoadArea* load) {
  UINT n, count, done; DWORD size; BYTE result = 0;
  if (fs_Mount() || f_open(&save_file, path, FA_READ)) return 1;
  size = f_size(&save_file);
  count = (UINT)((size + 511) >> 9);
  if (size >= 0x1000000 || count > load->blocks) result = 2;
  for (n = 0; !result && n < count; ++n) {
    SetWindowBlock(load->block + n);
    if (f_read(&save_file, WINDOW, 512, &done)) result = 1;
  }
  SetWindowBlock(TB_PSRAM_HIGH << 8);
  f_close(&save_file);
  load->size = size;
  return result;
}
// HEXVIEW.MOD's file (src/browser/hexview.c), read only
unsigned char fs_ViewOpen(const char* path) {
  FRESULT result = f_open(&save_file, path, FA_READ);
  view_size = result ? 0 : f_size(&save_file);
  return result;
}
UINT fs_ViewRead(UINT count) {
  UINT done;
  if (f_lseek(&save_file, view_pos) || f_read(&save_file, buffer, count, &done)) return 0;
  return done;
}
void fs_ViewClose(void) { f_close(&save_file); }
// ASM.MOD's ROM image (ASM_IMAGE_BLOCK, blocks of 512) to a file, replacing it
unsigned char fs_WriteImage(const char* path, UINT blocks) {
  UINT n, done; FRESULT result, closed;
  if ((result = fs_Mount()) || (result = f_open(&save_file, path, FA_WRITE | FA_CREATE_ALWAYS))) return result;
  for (n = 0; !result && n < blocks; ++n) {
    SetWindowBlock(ASM_IMAGE_BLOCK + n);
    result = f_write(&save_file, WINDOW, 512, &done);
    if (!result && done != 512) result = FR_DENIED;
  }
  SetWindowBlock(TB_PSRAM_HIGH << 8);
  closed = f_close(&save_file); return result ? result : closed;
}
// kind 0: staged -> live; 1: live -> slot; 2: staged -> slot; 3: slot -> staged.
static void SnapshotCopy(BYTE kind) {
  UINT n;
  for (n = 0; n < SNAP_SECTORS; ++n) {
    SaveRamBlock((kind == 3 ? 64 : kind == 1 ? SNAP_FIRST : SNAP_STAGE) + n, kind == 3);
    memcpy(buffer, WINDOW, 512);
    SaveRamBlock((kind == 3 ? SNAP_STAGE : kind ? 64 : SNAP_FIRST) + n, kind == 1 || kind == 2);
    memcpy(WINDOW, buffer, 512);
  }
  SaveRamBlock(TB_PSRAM_HIGH << 8, 0);
}
static FRESULT SnapshotStore(char* path, UINT first) {
  char temp[sizeof(SAVE_FOLDER) + FS_NAME_SIZE + 4];
  UINT n; FRESULT result;
  result = f_mkdir("/GBCSYS/SNAP"); if (result && result != FR_EXIST) return result;
  memcpy(temp, path, sizeof(temp));
  for (n = 0; temp[n]; ++n); memcpy(temp + n - 3, "tmp", 3);
  if ((result = SnapshotFile(temp, 1, first))) return result;
  // Keep the previous image as .bak until the complete new file is installed.
  memcpy(path + n - 3, "bak", 3); f_unlink(path);
  memcpy(temp + n - 3, "sav", 3); result = f_rename(temp, path);
  if (result && result != FR_NO_FILE) return result;
  memcpy(temp + n - 3, "tmp", 3); memcpy(path + n - 3, "sav", 3);
  result = f_rename(temp, path);
  return result;
}

// Persist the battery-backed slot on boot, including states made by stock OS.
static FRESULT BackupSnapshot(char* path, UINT sectors) {
  UINT n;
  if (sectors > 64) return FR_OK;
  SaveRamBlock(64, 1); n = memcmp(WINDOW, "SAVE", 4);
  SaveRamBlock(TB_PSRAM_HIGH << 8, 0);
  if (n) return FR_OK;
  SnapshotCopy(3);
  memcpy(path, SNAP_FOLDER, sizeof(SNAP_FOLDER)-1);
  for (n = 0; path[n]; ++n); memcpy(path+n-3, "sav", 3);
  return SnapshotStore(path, SNAP_STAGE);
}
// A stock launch supersedes EDITOR.GAM. Trust only a checked stock registry
// and the stock SRAM marker, then import its ownership before touching RAM.
static FRESULT BackupRegistry(UINT sum) {
  BYTE record[10 + sizeof(SAVE_FOLDER) + FS_NAME_SIZE + 4], rtc, n, raw;
  char* path = (char*)record + 10;
  UINT sectors, done, i;
  FRESULT result, closed;
  if ((result = f_open(&save_file, REGISTRY, FA_READ))) return result == FR_NO_FILE ? FR_OK : result;
  result = f_read(&save_file, buffer, 512, &done); f_close(&save_file);
  if (result) return result;
  if (done < 266 || ld_16(buffer) != 0x1234 || ByteSum(buffer,264) != ld_16(buffer+264) || !buffer[263]) return FR_OK;
  sectors = ld_16(buffer+16); rtc = buffer[13];
  if (sectors > 256) return FR_INT_ERR;
  memcpy(path,SAVE_FOLDER,sizeof(SAVE_FOLDER)-1);
  for (i=0; i<208 && buffer[34+i]; ++i);
  if (!i || i >= FS_NAME_SIZE) { backup_skipped=1; return FR_OK; }
  raw = i == 11; n = sizeof(SAVE_FOLDER)-1;
  for (i=0; buffer[34+i] && i<208; ++i) {
    if (raw && i==8) path[n++]='.';
    if (!raw || buffer[34+i]!=' ') path[n++]=buffer[34+i];
  }
  path[n]=0;
  for (i=n; i>sizeof(SAVE_FOLDER)-1 && path[i]!='.'; --i);
  if (i==sizeof(SAVE_FOLDER)-1) i=n;
  memcpy(path+i,".srm",5);
  if (sectors<256) {
    SaveRamBlock(255,1);
    for (n=0; n<16 && WINDOW[480+n]==n; ++n);
    SaveRamBlock(TB_PSRAM_HIGH << 8,0);
    if (n!=16) { backup_skipped=1; return FR_OK; }
  }
  f_mkdir("/GBCSYS/SAVE");
  if (sectors) {
    if ((result=f_open(&save_file,path,FA_WRITE|FA_CREATE_ALWAYS))) return result;
    result=SaveRamFile(sectors,1); closed=f_close(&save_file); if (result || closed) return result ? result : closed;
  }
  if (rtc) { memcpy(path+i+1,"rtc",3); if ((result=WriteGameRTC(path))) return result; }
  if ((result=BackupSnapshot(path,sectors))) return result;
  memcpy(record,"GAM3",4); record[4]=0; st_16(record+5,sum); record[7]=rtc; st_16(record+8,sectors);
  // A finished record is only an ownership cookie; its path isn't used.
  if ((result=f_open(&save_file,GAME_RECORD,FA_WRITE|FA_CREATE_ALWAYS))) return result;
  result=f_write(&save_file,record,10,&done); closed=f_close(&save_file);
  return result ? result : done!=10 ? FR_DENIED : closed;
}

// action 0 saves, 1 loads. Called only after SnapshotCapture has freed OS WRAM.
unsigned char fs_Snapshot(BYTE action) {
  char path[sizeof(SAVE_FOLDER) + FS_NAME_SIZE + 4];
  FRESULT result;
  SetWindowBlock(GAME_META);
  if (WINDOW[128] > 64 || WINDOW[129]) { SetWindowBlock(TB_PSRAM_HIGH << 8); return FR_DENIED; }
  memcpy(path, WINDOW, sizeof(path)); path[sizeof(path)-1] = 0;
  SetWindowBlock(TB_PSRAM_HIGH << 8);
  if (!path[0]) return FR_NO_FILE;
  if ((result = fs_Mount())) return result;
  if (action) {
    if ((result = SnapshotFile(path, 0, SNAP_STAGE))) return result;
    SetWindowBlock(SNAP_STAGE);
    result = !memcmp(WINDOW + 10, "GB\1", 3) && WINDOW[13] != snapshot_model ? FR_DENIED : FR_OK;
    SetWindowBlock(TB_PSRAM_HIGH << 8);
    if (result) return result;
    SnapshotCopy(0); SnapshotCopy(1); return FR_OK;
  }
  result = SnapshotStore(path, SNAP_FIRST);
  if (!result) SnapshotCopy(1);
  return result;
}

unsigned char fs_GameFinish(const char* path) {
  UINT block, done, sum;
  BYTE record[10 + sizeof(SAVE_FOLDER) + FS_NAME_SIZE + 4];
  char rtc_path[sizeof(SAVE_FOLDER) + FS_NAME_SIZE + 4];
  FRESULT result = FR_OK;
  if (game_save_sectors < 256) {
    SaveRamBlock(255, 1); memset(WINDOW + 480, 0, 16); SaveRamBlock(TB_PSRAM_HIGH << 8, 0);
  }
  result = f_mkdir("/GBCSYS/SAVE"); if (result && result != FR_EXIST) return result;
  GamePath((char*)record + 10, path, ".srm");
  GamePath(rtc_path, path, ".rtc");
  if (game_save_sectors) {
    result = f_open(&save_file, (const char*)record + 10, FA_READ);
    if (!result) {
      result = SaveRamFile(game_save_sectors, 0); f_close(&save_file);
    }
    else if (result == FR_NO_FILE || result == FR_NO_PATH) {
      result = FR_OK;
      f_mkdir("/GBCSYS/SAVE");
      for (block = 0; block < game_save_sectors; ++block) { SaveRamBlock(block, 1); memset(WINDOW, 0xFF, 512); }
      SaveRamBlock(TB_PSRAM_HIGH << 8, 0);
    }
    else return result;
    if (result) return result;
  }
  if (game_save_sectors <= 64) { SaveRamBlock(64, 1); memset(WINDOW, 0, 4); SaveRamBlock(TB_PSRAM_HIGH << 8, 0); }
  if (game_has_rtc && (result = ReadGameRTC(rtc_path))) return result;
  SnapshotPath(rtc_path, path);
  SetWindowBlock(GAME_META); memset(WINDOW, 0, 512);
  memcpy(WINDOW, rtc_path, sizeof(rtc_path)); WINDOW[128] = game_ram_mask > 3 ? 255 : game_save_sectors; WINDOW[129] = game_save_sectors >> 8;
  SetWindowBlock(TB_PSRAM_HIGH << 8);
  if (game_save_sectors <= 64) {
    result = SnapshotFile(rtc_path, 0, SNAP_STAGE);
    if (!result) SnapshotCopy(2);
    else if (result != FR_NO_FILE && result != FR_NO_PATH && result != FR_INT_ERR) return result;
  }
  result = GameCheats(path);
  if (!result) result = RegistryGame(path);
  { FRESULT closed = f_close(&file); if (!result) result = closed; }
  if (result) return result;
  sum = RegistrySum();
  memcpy(record, "GAM3", 4); record[4] = 1;
  record[5] = sum; record[6] = sum >> 8; record[7] = game_has_rtc;
  record[8] = game_save_sectors; record[9] = game_save_sectors >> 8;
  if (!(result = f_open(&save_file, GAME_RECORD, FA_WRITE | FA_CREATE_ALWAYS))) {
    for (done = 10; record[done]; ++done);
    ++done;
    result = f_write(&save_file, record, done, &block);
    if (!result && block != done) result = FR_DENIED;
    { FRESULT closed = f_close(&save_file); if (!result) result = closed; }
  }
  if (!result && game_save_sectors < 256) {
    SaveRamBlock(255, 1); for (done = 0; done < 16; ++done) WINDOW[480 + done] = done;
    SaveRamBlock(TB_PSRAM_HIGH << 8, 0);
  }
  return result;
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

DWORD get_fattime(void) { return ClockFatTime(); }

// Bounded text scan, independent of the large document's persistent FIL.
unsigned char fs_Inspect(const char* path, FileDetails* details) {
  FIL input;
  UINT count, i;
  FRESULT result, closed;
  BYTE c, last = 0, word = 0, checksum = 0;
  details->status = 0;
  details->words = details->lines = 0;
  result = f_open(&input, path, FA_READ);
  if (result) return result;
  if (details->game) {
    result = f_lseek(&input, 0x134);
    if (!result) result = f_read(&input, details->header, 28, &count);
    if (!result && count == 28) {
      for (i = 0; i < 25; ++i) checksum -= details->header[i] + 1;
      details->status = checksum == details->header[25] ? 1 : 2;
    }
  }
  else if (f_size(&input) <= 32768UL) {
    details->status = 1;
    do {
      result = f_read(&input, buffer, sizeof(buffer), &count);
      if (result) break;
      for (i = 0; i < count; ++i) {
        c = buffer[i];
        if (!c) { details->status = 2; break; }
        if (c == '\r' || (c == '\n' && last != '\r')) ++details->lines;
        if (c > ' ' && !word) ++details->words;
        word = c > ' ';
        last = c;
      }
    } while (count && details->status == 1);
    if (last && last != '\n' && last != '\r') ++details->lines;
  }
  closed = f_close(&input);
  if (result) details->status = 0;
  return result ? result : closed;
}

// A small session record tracks the visible view even while Browse blocks the
// editor's autosave loop. A private FIL preserves a large document's open handle.
extern char file_dir[PATH_SIZE], file_name[FS_NAME_SIZE];
extern unsigned char modified;
extern void CopyName(char* dest, const char* source);
unsigned char session_open;
static unsigned char SameName(const char* a, const char* b) {
  while (*a && *a == *b) { ++a; ++b; }
  return *a == *b;
}
#define SESSION_SIZE (1 + PATH_SIZE + FS_NAME_SIZE)
static const char session_path[] = "/GBCSYS/SESSION.DAT";
unsigned char fs_Session(const char* folder, unsigned char mode) {
  FIL session;
  UINT done;
  FRESULT result, closed;
  BYTE resume;
  if (mode != 255) session_open = mode;
  result = f_open(&session, session_path, mode == 255 ? FA_READ : FA_WRITE | FA_CREATE_ALWAYS);
  if (result) return result;
  if (mode == 255) {
    result = f_read(&session, buffer, SESSION_SIZE, &done);
    if (!result && (done != SESSION_SIZE || (buffer[0] ^ 0xA0) > 1 ||
        buffer[PATH_SIZE] || buffer[SESSION_SIZE - 1])) result = FR_INVALID_OBJECT;
  }
  else {
    memset(buffer, 0, SESSION_SIZE);
    buffer[0] = 0xA0 | mode;
    CopyName((char*)buffer + 1, folder);
    if (mode) CopyName((char*)buffer + 1 + PATH_SIZE, file_name);
    result = f_write(&session, buffer, SESSION_SIZE, &done);
    if (!result && done != SESSION_SIZE) result = FR_DISK_ERR;
  }
  closed = f_close(&session);
  if (result || closed || mode != 255) return result ? result : closed;
  resume = buffer[0] & 1;
  // Restore unsaved small-file text only when it belongs to this session.
  if (!resume || !SameName(file_dir, (char*)buffer + 1) ||
      !SameName(file_name, (char*)buffer + 1 + PATH_SIZE)) modified = 0;
  CopyName(file_dir, (char*)buffer + 1);
  CopyName(file_name, (char*)buffer + 1 + PATH_SIZE);
  session_open = resume;
  if (!resume || modified || !file_name[0]) return FR_OK;
  JoinPath((char*)buffer, file_dir, file_name, (unsigned char)(PATH_SIZE + FS_NAME_SIZE));
  result = f_stat((char*)buffer, &info);
  if (!result)
    result = info.fsize > TB_SIZE ? FileLoadLarge((char*)buffer) : FileLoad((char*)buffer);
  if (result) session_open = 0;
  return result;
}

// The borrowed page is still OS code here. Validate/stage with a private FIL,
// leaving an open editor document and its undo history alone.
extern unsigned int module_entry;
extern UINT ModuleCRC(const BYTE* data, UINT count, UINT crc); // src/modules/runtime.asm
unsigned char module_wide; // the staged module's pages after the first (MODULE_FORMAT_WIDE), 0 for others
unsigned char fs_LoadModule(const char* path, unsigned char id) {
  FIL module;
  BYTE header[MODULE_HEADER], result, close_result, wide = 0, page;
  UINT done, length, lengths[MODULE_PAGES_MAX], offset, crc = 0xFFFF, expected, entry, bss, bss_size, i;
  DWORD total;
  UINT saved_block = *(volatile UINT*)0xBD02;
  BYTE saved_config = *(volatile BYTE*)0xBD06;
  static const BYTE extra_pages[MODULE_PAGES_MAX - 1] = {MODULE_PAGE2, MODULE_PAGE3, MODULE_PAGE4};
  result = f_open(&module, path, FA_READ);
  if (result) goto restore;
  result = f_read(&module, header, sizeof(header), &done);
  if (result) goto close;
  result = FR_INVALID_OBJECT;
  if (done != sizeof(header) || memcmp(header, "FPKM", 4) ||
      (header[MODULE_H_FORMAT] != MODULE_FORMAT && header[MODULE_H_FORMAT] != MODULE_FORMAT_WIDE)) goto close;
  // Hosts keep older ABI entries, so any version up to the host's runs.
  if (!header[MODULE_H_ABI] || header[MODULE_H_ABI] > MODULE_ABI) { result = MODULE_ERR_ABI; goto close; }
  length = lengths[0] = ld_16(header + MODULE_H_LENGTH);
  entry = ld_16(header + MODULE_H_ENTRY);
  bss = ld_16(header + MODULE_H_BSS);
  bss_size = ld_16(header + MODULE_H_BSS_SIZE);
  expected = ld_16(header + MODULE_H_CRC);
  if (header[MODULE_H_ID] != id || !id || header[MODULE_H_PAGE] != MODULE_PAGE ||
      ld_16(header + MODULE_H_ADDRESS) != 0xA000 ||
      !length || length > 0x1D00 || entry >= length) goto close;
  total = length;
  if (header[MODULE_H_FORMAT] == MODULE_FORMAT_WIDE) {
    // records of page and length from MODULE_H_PAGE2, in order; unused ones are zero
    for (i = 0; i < MODULE_PAGES_MAX - 1; ++i) {
      BYTE* record = header + MODULE_H_PAGE2 + 3 * i;
      UINT n = ld_16(record + 1);
      if (wide == i && n) {
        if (record[0] != extra_pages[i] || n > 0x1D00) goto close;
        lengths[++wide] = n;
        total += n;
      }
      else if (record[0] || n) goto close;
    }
    if (!wide || bss || bss_size > MODULE_BSS_SIZE) goto close;
  }
  else if (bss < length || bss > 0x1D00 || bss_size > 0x1D00 - bss) goto close;
  if (f_size(&module) != total + sizeof(header)) goto close;
  for (i = wide ? MODULE_H_RESERVED : MODULE_H_PAGE2; i < sizeof(header); ++i) if (header[i]) goto close;
  result = FR_OK;
  *(volatile BYTE*)0xBD06 = saved_config & ~2;
  // Read into WRAM: disk_read itself uses the cartridge's PSRAM window.
  for (page = 0; page <= wide; ++page) {
    length = lengths[page];
    offset = 0;
    while (offset < 0x1D00) {
      UINT size = length > offset ? length - offset : 0;
      UINT sector_size = 0x1D00 - offset;
      if (size > 512) size = 512;
      if (sector_size > 512) sector_size = 512;
      memset(buffer, 0, 512);
      if (size) {
        result = f_read(&module, buffer, size, &done);
        if (result) goto close;
        if (done != size) { result = FR_INVALID_OBJECT; goto close; }
        crc = ModuleCRC(buffer, size, crc);
      }
      SetWindowBlock(MODULE_STAGE + (page << 5) + (offset >> 9));
      memcpy(WINDOW, buffer, sector_size);
      offset += sector_size;
    }
  }
  if (crc != expected) result = FR_INVALID_OBJECT;
  else { module_entry = 0xA000 + entry; module_wide = wide; }
close:
  close_result = f_close(&module);
  if (!result) result = close_result;
restore:
  SetWindowBlock(saved_block);
  *(volatile BYTE*)0xBD06 = saved_config;
  return result;
}
