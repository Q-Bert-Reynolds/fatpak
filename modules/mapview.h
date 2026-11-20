#ifndef FATPAK_MODULE_MAPVIEW_H
#define FATPAK_MODULE_MAPVIEW_H
// MAPVIEW.MOD's context (modules/mapview.c), from the browser's ViewMap (src/browser/viewer.c).
// The host runs it with module_dir set to the map's folder, so it and ASM.MOD find the map's files
// as they would if the map were the open document. A map without a current cache has the module
// return MAP_BUILD: the host runs ASM.MOD and LINK.MOD with build, writes the image to the cache's
// path (at MAP_PATH_BLOCK), and runs the module again with state MAP_BUILT and how that went, which
// the module reports if it failed.
#include "assembler/asm.h"

#define MAP_CACHE_SIZE (PATH_SIZE + FS_NAME_SIZE + 20) // "/GBCSYS/CACHE", the map's path, ".cache"
#define MAP_PATH_BLOCK 0x03FF // PSRAM: the cache's path, NUL ended, with MAP_BUILD
#define MAP_BUILD 1 // module_status: build it

#define MAP_NEW   0 // state: the first run
#define MAP_BUILT 1 // the host built it: result and status say how that went
#define MAP_LARGE 2 // it didn't: a large file is open (the assembler works in its add buffer)
#define MAP_RESUME 3 // after Start's menu (VIEW_MENU, modules/view.h): the view where it was
#define MAP_REBUILD 4 // the menu's FILE > REBUILD: build it again

typedef struct {
  const char* dir;      // in: the map's folder from the root ("/beisbolgb/maps", "" at the root)
  const char* name;     // in: its name ("Overworld.gbmap")
  unsigned char state;  // in: MAP_NEW, MAP_BUILT or MAP_LARGE
  unsigned char result; // in with MAP_BUILT: RunModule's for ASM.MOD or LINK.MOD, else FileWriteImage's (FRESULT)
  unsigned char status; // in with MAP_BUILT and result 0: their module_status (an ASM_ERR_*), 0 if it built
  AsmContext build;     // out with MAP_BUILD: ASM.MOD's, ASM_TEXT | ASM_LOOSE, the wrapper in PSRAM
  unsigned char full;   // in: SETTINGS > FULL SCREEN: no bars
  unsigned char hires;  // in: SETTINGS > RESOLUTION is 512x448 (SGB fullscreen)
  unsigned char kept;   // in with MAP_RESUME: the map is still on screen (GBC, SGB fullscreen), only a box covered it
  unsigned char view[8]; // in with MAP_RESUME, out with VIEW_MENU: where the view is (its chunk, tile, pixel, map offsets, resolution)
} MapContext;
#endif
