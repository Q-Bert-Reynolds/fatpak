// ASM.MOD: build.cache's last file (asm_cache.h): its records become symbols LoadPath reads through.
#include "asm_cache.h"

static const char cache_file[] = "build.cache";

#ifndef HOST_TEST
// after project.gbp: the last build's records become symbols, and the new index starts
void CacheStart(void) {
  unsigned int at, end;
  unsigned char i, n;
  cache_volume = (FATFS*)(unsigned int)ModStat(MODULE_STAT_FS);
  if (cache_volume->fs_type != FS_FAT16 && cache_volume->fs_type != FS_FAT32) return;
  if (!(unsigned char)cache_volume->csize) return; // 256 sectors: no
  cache_head[0] = 'F';
  cache_head[1] = 'P';
  cache_head[2] = 'K';
  cache_head[3] = 'C';
  cache_head[4] = cache_volume->fs_type;
  cache_head[5] = (unsigned char)cache_volume->csize;
  CacheCopy4(cache_head + 6, (unsigned char*)&cache_volume->fatbase);
  CacheCopy4(cache_head + 10, (unsigned char*)&cache_volume->database);
  CacheCopy4(cache_nfat, (unsigned char*)&cache_volume->n_fatent);
  for (i = 0; (path[i] = cache_file[i]) != 0; ++i); // this page's constant: copied here
  if (LoadPath() && !(file_size >> 16)) { // cache_n is still 0xFFFF: it isn't recorded
    cache_base = BLOCK(file_at);
    end = (unsigned int)file_size;
    for (n = 0; n < HEAD && CacheByte(n) == cache_head[n]; ++n);
    if (n == HEAD) { // the same volume's
      for (at = HEAD; at < end && (n = CacheByte(at)) != 0 && n <= NAME_MAX; at += RECORD) {
        CacheName(n, at + 1);
        ident[ident_len = n] = 0;
        at += n + 1;
        if (!Find()) { // LoadPath reads the file through it
          sym_extra = 0;
          Add(SYM_CACHED, at, 0);
        }
      }
    }
  }
  cache_n = 0;
  CachePutN(cache_head, HEAD);
}

#endif
