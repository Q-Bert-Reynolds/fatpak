// Binary files: a NUL in the first sector (text never has one) opens HEXVIEW.MOD
// (modules/hexview.c) instead of the editor. It reads the file through ModRead.
#include "hexview.h"
#include "paths.h"
#include "../editor/text_buffer.h"
#include "../editor/view.h"
#include "../modules/runtime.h"
#include "../ui/render.h"
#include "../ui/screen.h"

extern unsigned char buffer[512]; // FileViewRead's

unsigned char ShowHexView(const char* path, const FileEntry* entry) {
  char line[FS_NAME_SIZE];
  unsigned char result, row, i, binary = 0;
  unsigned int n;
  unsigned char* attrs = tile_attrs;
  if (FileViewOpen(path)) return 0; // opening it as text reports the error
  view_pos = 0;
  n = FileViewRead(512);
  while (n) if (!buffer[--n]) { binary = 1; break; }
  if (binary) {
    font = FONT_FIXED;
    SetFont(font);
    render_text = 1; // styled rows: the module dims non-printing bytes
    BeginView(1);
    for (row = 0; row < tb_rows; ++row) {
      DrawRow(row, 0, "");
      tb_row_states[row] = 0; // no markdown heading fonts
      for (i = 0; i < TB_STRIDE; ++i) *attrs++ = STYLE_TEXT << 4 | 4;
    }
    *ToLatin1(line, entry->name, FS_NAME_SIZE - 1) = 0;
    DrawRow(HEADER_LINE, 1, line);
    module_context = &view_size;
    if ((result = RUN_MODULE(HEXVIEW))) ShowModuleError(result);
  }
  FileViewClose();
  return binary;
}
