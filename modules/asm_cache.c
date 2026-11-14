// ASM.MOD: build.cache (see asm_shared.h), beside project.gbp. Finding a file on the card is most
// of the card's time (FatFs reads every entry of its folder, comparing long names); the cache
// keeps where the last good build found each one: its directory entry's sector and place, and
// its 8.3 name. Next time the entry is read straight from the card (ModSector), and if it still
// has that name the file is read through its clusters, without a search. The entry gives the
// size and first cluster, so an edited file reads as it is now; one that moved, or a changed
// name, is found as before (and recorded again). A file added where the search would find it
// first isn't noticed while the old one stays.
//
// The file: "FPKC", the volume's FAT type, cluster size, FAT and data sectors (another volume:
// not used), then a record per file: its path's length and path (as written, the last 79
// characters: its symbol's name), the entry's sector (4), offset (2) and name (11); length 0 ends it. 32-bit
// numbers stay 4-byte arrays, worked in assembly (asm_cread.c, asm_cbytes.c): SDCC's long code is
// too big here, and the four files fit the module's pages (asm_cache.h).
#include "asm_cache.h"

unsigned int cache_n; // the new index's bytes at ASM_CACHE_BLOCK; 0xFFFF: none (not a project, or full)
unsigned int cache_files, files_read; // read through it, and all
unsigned char card_frames[4]; // finding and reading files, through the cache or not (32 bits)
unsigned char cache_rec[RECORD], cache_head[HEAD], cache_nfat[4];
unsigned char cache_cl[4], cache_sec[4], cache_fat[4], cache_fnew[4], cache_size[4];
unsigned int cache_at, cache_base;
#ifndef HOST_TEST
FATFS* cache_volume;
#endif

void CachePut(unsigned char b) {
  if (cache_n >= 0xFFF0) { cache_n = 0xFFFF; return; } // full (ASM_CACHE_BLOCKS of 512 is 64 KiB): none written
  Window(ASM_CACHE_BLOCK + (cache_n >> 9));
  WINDOW[cache_n & 511] = b;
  ++cache_n;
}
void CachePutN(const unsigned char* p, unsigned char n) { while (n-- && cache_n != 0xFFFF) CachePut(*p++); }
unsigned char CacheByte(unsigned int at) { // at from cache_base
  Window(cache_base + (at >> 9));
  return WINDOW[at & 511];
}
#ifndef HOST_TEST
void NextCluster(void) {
  FatPlace();
  if (CacheSame(cache_fnew, cache_fat)) {
    if (CacheSector(cache_fnew, FAT_BLOCK)) { cache_cl[0] = cache_cl[1] = 0; return; } // Bad() then
    CacheCopy4(cache_fat, cache_fnew);
  }
  Window(FAT_BLOCK);
  CacheCopy4(cache_cl, WINDOW + cache_at);
  if (cache_head[4] == FAT32) cache_cl[3] &= 0x0F;
  else cache_cl[2] = cache_cl[3] = 0;
}

#endif

#ifdef HOST_TEST
// no FAT volume on the PC: every file is searched for
void CacheStart(void) {}
unsigned char CacheRead(unsigned int record, ModuleLoad* load) { (void)record; (void)load; return 1; }
void CacheTime(unsigned int start) { *(unsigned long*)card_frames += (unsigned int)((unsigned int)ModStat(MODULE_STAT_FRAMES) - start); }
#endif

// loads path[] for LoadPath, through the cache record if there is one, and records where it was
unsigned char CacheLoad(ModuleLoad* load, unsigned int record) {
  unsigned int frames = (unsigned int)ModStat(MODULE_STAT_FRAMES);
  unsigned char result = record ? CacheRead(record, load) : 1;
  if (result) {
    result = ModLoad(path, load);
#ifndef HOST_TEST
    if (!result && cache_n != 0xFFFF) { // where the search found it
      FIL* file = (FIL*)(unsigned int)ModStat(MODULE_STAT_FILE);
      CacheCopy4(cache_rec, (unsigned char*)&file->dir_sect);
      *(unsigned int*)(cache_rec + 4) = (unsigned int)(file->dir_ptr - cache_volume->win);
      if (CacheSector(cache_rec, DIR_BLOCK)) cache_n = 0xFFFF;
      else {
        Window(DIR_BLOCK);
        CacheCopy11(cache_rec + 6, WINDOW + *(unsigned int*)(cache_rec + 4));
      }
    }
#endif
  }
  if (!result) ++files_read;
  if (!result && cache_n != 0xFFFF) { // its record, named as its symbol
    CachePut(ident_len);
    CachePutN((unsigned char*)ident, ident_len);
    CachePutN(cache_rec, RECORD);
  }
  CacheTime(frames);
  return result;
}

// after a build that worked: the index's length, so the host writes it
void CacheEnd(void) {
  if (cache_n == 0xFFFF || error) return;
  CachePut(0);
  if (cache_n != 0xFFFF) context->cache_blocks = ((cache_n >> 9) + 1) | 0x4000; // FileWriteImage's count
}
