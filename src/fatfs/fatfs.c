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
#define GAME_RECORD "/GBCSYS/EDITOR.GAM" // "GAM2", save RAM banks to back up (0 = done), RegistrySum, the .srm path
#define REGISTRY "/GBCSYS/REGISTRY.BIN" // the EverDrive OS's, rewritten when it launches a game
#define SAVE_FOLDER "/GBCSYS/SAVE/"
#define GAME_BLOCKS 0x3E40 // PSRAM blocks before the EverDrive's save states
#define rEDX_CONFIG (*(volatile BYTE*)0xBD06)
extern unsigned char game_mapper, game_rom_mask, game_ram_mask, game_config, game_bd20; // src/fatfs/fatfs.asm, for GameLaunch
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
static FRESULT SaveRamFile(BYTE banks, BYTE write) {
  UINT block, done;
  FRESULT result = FR_OK;
  for (block = 0; !result && block < (UINT)banks << 4; ++block) {
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

unsigned char fs_BackupSave(void) {
  UINT done, sum, i;
  BYTE path = 7;
  char* bak = (char*)buffer + 256;
  FRESULT result = fs_Mount();
  backup_skipped = 0;
  if (result) return result;
  sum = RegistrySum();
  if (f_open(&save_file, GAME_RECORD, FA_READ)) return result;
  result = f_read(&save_file, buffer, 255, &done);
  f_close(&save_file);
  if (result || done < 8 || !buffer[4]) return result;
  if (!memcmp(buffer, "GAM1", 4)) path = 5; // before the registry check
  else if (memcmp(buffer, "GAM2", 4)) return result;
  buffer[255] = 0;
  if (path == 7 && (buffer[5] | (buffer[6] << 8)) != sum) backup_skipped = 1;
  else {
    for (i = 0; (bak[i] = buffer[path + i]); ++i);
    if (i > 4) {
      memcpy(bak + i - 3, "bak", 3);
      f_unlink(bak);
      f_rename((const char*)buffer + path, bak);
    }
    if ((result = f_open(&save_file, (const char*)buffer + path, FA_WRITE | FA_CREATE_ALWAYS))) return result;
    result = SaveRamFile(buffer[4], 1);
    if (result) f_close(&save_file);
    else result = f_close(&save_file);
    if (result) return result;
  }
  buffer[4] = 0; // done
  if (!(result = f_open(&save_file, GAME_RECORD, FA_WRITE))) {
    result = f_write(&save_file, buffer, 5, &done);
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
extern unsigned char sd_ReadBlocks(unsigned int block, unsigned int count); // src/editor/sd.asm, from LBA sd_sector
extern unsigned char sd_fast; // sd_ReadBlocks streams into the window like the EverDrive's OS
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
  type = buffer[0x147];
  game_mapper = !type || type == 8 || type == 9 ? 4 : type <= 3 ? 1 : type <= 6 ? 2 : type >= 0x0F && type <= 0x13 ? 3 : 5;
  size = buffer[0x149];
  game_banks = size == 3 ? 4 : size == 4 ? 16 : size == 5 ? 8 : 1;
  game_ram_mask = game_mapper == 2 ? 0 : size == 1 || size == 2 ? 0 : game_banks - 1;
  for (game_rom_mask = 0, length = (length + 0x7FFF) >> 15; length > 1; length = (length + 1) >> 1) game_rom_mask = (game_rom_mask << 1) | 1; // 32KB units
  for (i = 0; battery_types[i] && battery_types[i] != type; ++i);
  if (!battery_types[i]) game_banks = 0;
  game_blocks = (UINT)((f_size(&file) + 511) >> 9);
  game_block = 0;
  game_clst = file.obj.sclust;
  sd_fast = 1;
  Signature(0); // the text in PSRAM gets overwritten, the next boot restores the swap file
  return FR_OK;
}

// the fast reads (sd_fast) didn't work: the game is read again the slow way
static void GameSlow(void) {
  sd_fast = 0;
  game_block = 0;
  game_clst = file.obj.sclust;
}

unsigned char fs_GameCopy(void) {
  FATFS* fs = file.obj.fs;
  unsigned long next = game_clst, last;
  UINT count = fs->csize, i;
  BYTE check;
  while (count < GAME_CHUNK && game_block + count < game_blocks) { // consecutive clusters
    if ((last = get_fat(&file.obj, next)) != next + 1) break;
    next = last;
    count += fs->csize;
  }
  if (count > game_blocks - game_block) count = game_blocks - game_block;
  if (!(sd_sector = clst2sect(fs, game_clst)) || sd_ReadBlocks(game_block, count)) {
    SetWindowBlock(TB_PSRAM_HIGH << 8);
    if (!sd_fast) return FR_DISK_ERR;
    GameSlow();
    return FR_OK;
  }
  game_block += count;
  if (game_block == game_blocks && sd_fast) { // the header checksum (a byte off before $14D breaks it)
    SetWindowBlock(0);
    for (check = 0, i = 0x134; i < 0x14D; ++i) check = check - WINDOW[i] - 1;
    if ((BYTE)check != WINDOW[0x14D] || memcmp(WINDOW + 0x134, buffer + 0x134, 0x1C)) GameSlow(); // the header fs_GameOpen read
  }
  SetWindowBlock(TB_PSRAM_HIGH << 8);
  if (game_block && game_block != game_blocks && (game_clst = get_fat(&file.obj, next)) < 2) return FR_INT_ERR;
  return FR_OK;
}

unsigned char fs_GameFinish(const char* path) {
  UINT block, done, i, end = 0, dot = 0;
  BYTE record[7 + sizeof(SAVE_FOLDER) + FS_NAME_SIZE + 4];
  FRESULT result = FR_OK;
  f_close(&file);
  if (!game_banks) return result;
  memcpy(record, "GAM2", 4); // the record: its .srm, the name with the extension replaced
  record[4] = game_banks;
  memcpy(record + 7, SAVE_FOLDER, sizeof(SAVE_FOLDER) - 1);
  for (i = 0; path[i]; ++i) if (path[i] == '/') end = i + 1;
  for (i = end; path[i]; ++i) if (path[i] == '.') dot = i;
  if (!dot) dot = i;
  if (dot - end > FS_NAME_SIZE) return FR_INVALID_NAME;
  memcpy(record + 6 + sizeof(SAVE_FOLDER), path + end, dot - end);
  memcpy(record + 6 + sizeof(SAVE_FOLDER) + dot - end, ".srm", 5);
  if (!f_open(&save_file, (const char*)record + 7, FA_READ)) { // its save, else blank save RAM
    result = SaveRamFile(game_banks, 0);
    f_close(&save_file);
  }
  else {
    f_mkdir("/GBCSYS/SAVE");
    for (block = 0; block < (UINT)game_banks << 4; ++block) {
      SaveRamBlock(block, 1);
      memset(WINDOW, 0xFF, 512);
    }
    SaveRamBlock(TB_PSRAM_HIGH << 8, 0);
  }
  if (result) return result;
  i = RegistrySum();
  record[5] = (BYTE)i;
  record[6] = i >> 8;
  if (!(result = f_open(&save_file, GAME_RECORD, FA_WRITE | FA_CREATE_ALWAYS))) {
    i = 7 + sizeof(SAVE_FOLDER) + dot - end + 4;
    if (!(result = f_write(&save_file, record, i, &done)) && done != i) result = FR_DENIED;
    if (result) f_close(&save_file);
    else result = f_close(&save_file);
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
