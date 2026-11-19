// Read only views of files the editor can't show: .tiles, .tile and .2bpp (2bpp Game Boy tiles, as
// img2rgbds.py writes them) in TILEVIEW.MOD (modules/tileview.c), Beisbol .gbmap maps in MAPVIEW.MOD
// (modules/mapview.c), and binary files (a NUL in the first sector; text never has one) in
// HEXVIEW.MOD (modules/hexview.c). TILEVIEW and HEXVIEW read the file through ModRead. MAPVIEW
// views a cache of the map assembled (ViewMap): the first time, or after the map changes, ASM.MOD and
// LINK.MOD build it from a wrapper the module writes, and it goes to /GBCSYS/CACHE.
#include "viewer.h"
#include "paths.h"
#include "../app/dialogs.h"
#include "../editor/state.h"
#include "../editor/text_buffer.h"
#include "../editor/view.h"
#include "../fatfs/file_api.h"
#include "../fatfs/lib/ff.h"
#include "../modules/runtime.h"
#include "../ui/dialogs.h"
#include "../ui/render.h"
#include "../ui/screen.h"
#include "../ui/text.h"
#include "../ui/theme.h"
#include "../../modules/mapview.h"
#include "../editor/build.h"

extern unsigned char buffer[512]; // FileViewRead's, and ViewMap's cache path
extern void SetWindowBlock(unsigned int block);
#define WINDOW ((const unsigned char*)0xBE00u)

#define KIND_HEX   0 // ViewKind
#define KIND_TILES 1
#define KIND_MAP   2

// KIND_TILES for a .tiles, .tile or .2bpp name, KIND_MAP for .gbmap, any case, else KIND_HEX. Each
// candidate ends in a space, which an extension's NUL matches after the | $20 that lower cases it
// (FAT names can't end in a space); .gbmap is the last, so the list's end follows its match.
static unsigned char ViewKind(const char* name) __naked {
  name;
  __asm
	ld	h, d
	ld	l, e
	ld	bc, 0
.find:
	ld	a, [hl+]
	or	a, a
	jr	z, .found
	cp	a, 46
	jr	nz, .find
	ld	b, h
	ld	c, l
	jr	.find
.found:
	or	a, b
	ret	z
	ld	hl, .exts
.next:
	ld	d, b
	ld	e, c
.cmp:
	ld	a, [de]
	inc	de
	or	a, 32
	cp	a, [hl]
	jr	nz, .skip
	inc	hl
	cp	a, 32
	jr	nz, .cmp
	ld	a, [hl]
	cp	a, 32
	ld	a, KIND_TILES
	ret	nz
	inc	a
	ret
.skip:
	ld	a, [hl+]
	cp	a, 32
	jr	nz, .skip
	ld	a, [hl]
	cp	a, 32 ;// the list's end
	jr	nz, .next
	xor	a, a
	ret
.exts:
	db	"tiles tile 2bpp gbmap ", 32
  __endasm;
}

// a view's rows, cleared, with bars (a map hides them while it's shown: ModBackground) (page 10: FIXED is full)
static void ViewBegin(void) {
  unsigned char row, i;
  unsigned char* attrs = tile_attrs;
  BeginView(1);
  for (row = 0; row < tb_rows; ++row) {
    DrawRow(row, 0, "");
    tb_row_states[row] = 0; // no markdown heading fonts
    for (i = 0; i < screen_stride; ++i) *attrs++ = STYLE_TEXT << 4 | 4;
  }
}

// ModBackground(0) (ABI 13, src/ui/render.asm): the text back after a module drew the BG map itself.
// Each BG map row points at its block again, every row is drawn again, and the theme's palettes
void BackgroundText(void) {
  unsigned char i;
  for (i = 0; i < BG_MAP_ROWS; ++i) map_blocks[i] = 0xFF;
  Layout();
  EditorRedraw();
  ThemeApply();
}

// the cache's path MAPVIEW.MOD left at MAP_PATH_BLOCK into buffer (not the stack: ViewMap is deep
// in the browser's, and RunModule and FatFs need the rest), then its folders that aren't there yet
static void CacheFolders(void) {
  char* p = (char*)buffer;
  unsigned char i = 0;
  SetWindowBlock(MAP_PATH_BLOCK);
  while ((p[i] = WINDOW[i]) != 0 && ++i != 255);
  p[i] = 0;
  SetWindowBlock(TB_PSRAM_HIGH << 8);
  for (++p; *p; ++p) if (*p == '/') {
    *p = 0;
    f_mkdir((char*)buffer);
    *p = '/';
  }
}

// MAPVIEW.MOD, with the map's folder as module_dir: when the module asks, ASM.MOD and LINK.MOD
// build its wrapper, the image goes to the cache's path, its folders made as needed, and the
// module runs again to show the map or what went wrong. Not while a large file is open: its add
// buffer is where the assembler works. path's last / is a NUL meanwhile
static unsigned char ViewMap(char* path) {
  MapContext m;
  unsigned char result, i;
  char* slash = path;
  for (i = 0; path[i]; ++i) if (path[i] == '/') slash = path + i;
  *slash = 0;
  module_dir = m.dir = path;
  m.name = slash + 1;
  m.state = MAP_NEW;
  while (1) {
    module_context = &m;
    if ((result = RUN_MODULE(MAPVIEW)) || module_status != MAP_BUILD) break;
    m.state = MAP_LARGE;
    if (doc_large) continue;
    ShowBusy(Str(S_ASSEMBLING));
    module_frames = 0;
    if (!(m.result = BuildModule(&m.build, BUILD_ASM)) && !module_status) m.result = BuildModule(&m.build, BUILD_LINK);
    if (!m.result && !(m.status = module_status)) {
      CacheFolders();
      m.result = FileWriteImage((char*)buffer, m.build.blocks);
    }
    HideBox();
    m.state = MAP_BUILT;
  }
  module_dir = 0;
  *slash = '/';
  return result;
}

unsigned char ShowFileView(const char* path, const FileEntry* entry, unsigned char mode) {
  char line[FS_NAME_SIZE];
  unsigned char result, kind = mode == VIEW_TILES ? KIND_TILES : mode ? KIND_HEX : ViewKind(entry->name), shown;
  unsigned int n;
  if (mode == VIEW_TEXT || FileViewOpen(path)) return 0; // opening it as text reports the error
  shown = view_size != 0; // an empty one opens as text
  if (!kind && !mode) {
    shown = 0;
    view_pos = 0;
    n = FileViewRead(512);
    while (n) if (!buffer[--n]) { shown = 1; break; }
  }
  if (shown) {
    font = kind ? FONT_VWF : FONT_FIXED;
    SetFont(font);
    render_text = !kind; // hex: styled rows, the module dims non-printing bytes
    ViewBegin();
    *ToLatin1(line, entry->name, FS_NAME_SIZE - 1) = 0;
    DrawRow(HEADER_LINE, 1, line);
    module_context = &view_size;
    result = kind == KIND_MAP ? ViewMap((char*)path) : kind ? RUN_MODULE(TILEVIEW) : RUN_MODULE(HEXVIEW);
    if (result) ShowModuleError(result);
    EditorRedraw(); // the modules' rows aren't text
  }
  FileViewClose();
  return shown;
}
