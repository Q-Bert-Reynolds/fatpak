#ifndef FATPAK_MODULE_ASM_CACHE_H
#define FATPAK_MODULE_ASM_CACHE_H
// ASM.MOD's build.cache, in four files to fit its pages (asm_cache.c, the record keeping and
// CacheLoad; asm_cstart.c, the last cache file; asm_cread.c, reading a file by its clusters;
// asm_cbytes.c, byte work in assembly). See asm_cache.c.
#include "asm_shared.h"
#ifndef HOST_TEST
#include "../src/fatfs/lib/ff.h" // FATFS, FIL: the host's, read through ModStat's pointers
extern FATFS* cache_volume;
#endif

#define DIR_BLOCK ASM_LOG_BLOCK // pass 1's scratch: a directory sector
#define FAT_BLOCK (ASM_LOG_BLOCK + 1) // and a FAT sector
#define HEAD 14 // cache_head: "FPKC", the FAT type, cluster size (sectors), FAT and data sectors
#define RECORD 17 // after the path
#define FAT32 3 // FS_FAT32

extern unsigned char cache_rec[RECORD]; // the file just read: its entry's sector, offset and name
extern unsigned char cache_head[HEAD], cache_nfat[4]; // and the volume's entries (clusters + 2)
extern unsigned char cache_cl[4], cache_sec[4], cache_fat[4], cache_fnew[4], cache_size[4]; // 32-bit numbers
extern unsigned int cache_at; // the cluster's entry in its FAT sector
extern unsigned int cache_base; // the last build's cache file's first block (it's under 64 KiB)

void CachePut(unsigned char b); // asm_cache.c
void CachePutN(const unsigned char* p, unsigned char n);
unsigned char CacheByte(unsigned int at); // the last cache file's byte at
void NextCluster(void); // cache_cl = the next in its chain (0 if the FAT can't be read)
unsigned char CacheRead(unsigned int record, ModuleLoad* load); // asm_cread.c: 0 if read through the record
// asm_cbytes.c: the cluster arithmetic
void Sector(void); // cache_sec = the data sector + (cache_cl - 2) * the cluster size
void FatPlace(void); // cache_fnew = the FAT sector of cache_cl's entry, cache_at its place there
unsigned char Bad(void); // cache_cl isn't a data cluster
void NextSector(void); // ++cache_sec

// asm_cbytes.c, dst in de and src in bc (never a page's constants: pointers don't cross pages)
void CacheCopy4(unsigned char* dst, const unsigned char* src);
void CacheCopy11(unsigned char* dst, const unsigned char* src);
void CacheTime(unsigned int start); // card_frames += the frames since start (ModStat's)
unsigned char CacheSame(const unsigned char* a, const unsigned char* b); // the first 4 the same: 0
unsigned char CacheSame11(const unsigned char* a, const unsigned char* b);
unsigned int CacheBlocks(void); // cache_size (under 16 MiB) in blocks, rounded up
void CacheRecord(unsigned int at); // RECORD bytes of the last cache file from at into cache_rec
void CacheName(unsigned char n, unsigned int at); // n into ident
unsigned char CacheSector(const unsigned char* sector, unsigned int block); // ModSector of a 4-byte sector
#endif
