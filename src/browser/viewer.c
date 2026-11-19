// Read only views of files the editor can't show: .tiles, .tile and .2bpp (2bpp Game Boy tiles, as img2rgbds.py
// writes them) in TILEVIEW.MOD (modules/tileview.c), and binary files (a NUL in the first sector;
// text never has one) in HEXVIEW.MOD (modules/hexview.c). Both read the file through ModRead.
#include "viewer.h"
#include "paths.h"
#include "../editor/text_buffer.h"
#include "../editor/view.h"
#include "../modules/runtime.h"
#include "../ui/render.h"
#include "../ui/screen.h"

extern unsigned char buffer[512]; // FileViewRead's

// 1 for a .tiles, .tile or .2bpp name, any case. Each candidate ends in a space, which an
// extension's NUL matches after the | $20 that lower cases it (FAT names can't end in a space).
static unsigned char IsTiles(const char* name) __naked {
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
	ld	a, 1
	ret
.skip:
	ld	a, [hl+]
	cp	a, 32
	jr	nz, .skip
	ld	a, [hl]
	cp	a, 32 ; the list's end

	jr	nz, .next
	xor	a, a
	ret
.exts:
	db	"tiles tile 2bpp ", 32
  __endasm;
}

unsigned char ShowFileView(const char* path, const FileEntry* entry, unsigned char mode) {
  char line[FS_NAME_SIZE];
  unsigned char result, row, i, tiles = mode == VIEW_TILES || (!mode && IsTiles(entry->name)), shown;
  unsigned int n;
  unsigned char* attrs = tile_attrs;
  if (mode == VIEW_TEXT || FileViewOpen(path)) return 0; // opening it as text reports the error
  shown = view_size != 0; // an empty one opens as text
  if (!tiles && !mode) {
    shown = 0;
    view_pos = 0;
    n = FileViewRead(512);
    while (n) if (!buffer[--n]) { shown = 1; break; }
  }
  if (shown) {
    font = tiles ? FONT_VWF : FONT_FIXED;
    SetFont(font);
    render_text = !tiles; // hex: styled rows, the module dims non-printing bytes
    BeginView(1);
    for (row = 0; row < tb_rows; ++row) {
      DrawRow(row, 0, "");
      tb_row_states[row] = 0; // no markdown heading fonts
      for (i = 0; i < screen_stride; ++i) *attrs++ = STYLE_TEXT << 4 | 4;
    }
    *ToLatin1(line, entry->name, FS_NAME_SIZE - 1) = 0;
    DrawRow(HEADER_LINE, 1, line);
    module_context = &view_size;
    result = tiles ? RUN_MODULE(TILEVIEW) : RUN_MODULE(HEXVIEW);
    if (result) ShowModuleError(result);
    EditorRedraw(); // TILEVIEW's rows aren't text
  }
  FileViewClose();
  return shown;
}
