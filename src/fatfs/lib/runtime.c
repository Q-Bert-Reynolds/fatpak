// SDCC runtime helpers, its libraries aren't linked in the rgbds pipeline.
// (string.h maps memcpy to __memcpy, so fatfs.c's memcpy covers that one)
// None are left: FatFs's divisions are by powers of 2 (cluster and sector sizes), 2 FATs or 13
// (LFN entries), written as shifts and loops in ff.c, so _mullong, _divulong and _divuint aren't
// in ROM0. A new * or / on a long or int here fails the link: write it the same way.
