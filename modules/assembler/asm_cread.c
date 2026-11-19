// ASM.MOD: build.cache's reads (asm_cache.h): a file through its cached entry and its clusters.
#include "asm_cache.h"

#ifndef HOST_TEST
// a file through its record (its place in the last cache file) into load: 0 if it's read
unsigned char CacheRead(unsigned int record, ModuleLoad* load) {
  unsigned char i, n, *e;
  unsigned int k, blocks;
  CacheRecord(record);
  if (CacheSector(cache_rec, DIR_BLOCK)) return 1;
  Window(DIR_BLOCK);
  e = WINDOW + (*(unsigned int*)(cache_rec + 4) & 511);
  if (CacheSame11(e, cache_rec + 6)) return 1; // not that file any more
  cache_cl[0] = e[26];
  cache_cl[1] = e[27];
  cache_cl[2] = cache_cl[3] = 0;
  if (cache_head[4] == FAT32) {
    cache_cl[2] = e[20];
    cache_cl[3] = e[21];
  }
  CacheCopy4(cache_size, e + 28);
  if (cache_size[3]) return 1; // 16 MiB or more: the search reports it
  blocks = CacheBlocks();
  if (blocks > load->blocks) return 1;
  CacheCopy4((unsigned char*)&load->size, cache_size);
  for (k = 0; k < blocks; ) {
    if (Bad()) return 1;
    Sector();
    for (n = 0; n < cache_head[5] && k < blocks; ++n, ++k) {
      if (!(k & 15)) ModProgress(0);
      if (CacheSector(cache_sec, load->block + k)) return 1;
      NextSector();
    }
    if (k < blocks) NextCluster();
  }
  ++cache_files;
  return 0;
}
#endif
