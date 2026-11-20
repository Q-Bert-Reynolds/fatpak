// Shared row buffers, screen layout and scrolling ring.
#include "screen.h"
#include "../editor/osk.h"
#include "../editor/text_buffer.h"
#include "render.h"
#include "footer.h"

unsigned char ring_top; // BG map row of text row 0
unsigned char ring_pos; // index in ring_blocks of text row 0's block
unsigned char ring_blocks[GB_MAX_ROWS + 1]; // blocks text rows use (the GB renderer's: Layout fills them only for it)
unsigned char map_blocks[BG_MAP_ROWS + WIN_MAP_ROWS]; // block each BG map row, then window map row, shows, 0xFF = none
unsigned char bars; // bars are shown now (not in menus)
unsigned char font;

static unsigned char IsOSKBlock(unsigned char block) {
  unsigned char i;
  for (i = 0; i < OSK_ROWS; ++i) if (osk_blocks[i] == block) return 1;
  return 0;
}

// sets each screen row's block, tile_buffer row and font. Text rows show BG map rows from ring_top
// (scrolled with SCY), drawn into the blocks left by the bars and the on screen keyboard, in a ring
// starting at ring_pos. The rows below and above them (bars, keyboard) keep their own blocks in
// window map rows, so they stay put while the text scrolls. Stages SCY and LCDC (RenderStage),
// applied at line 144
// On GBC the ring has a spare block (18) for the row scrolling in or out (see src/ui/render.asm)
// Text row 0 keeps its block, so rows that keep theirs aren't drawn again
void Layout(void) {
  unsigned char row, line, block, map_row, i = 0, win_row = BG_MAP_ROWS, osk = screen_rows - (bars << 1) - tb_rows;
  unsigned char length = tb_rows + render_gbc, first = ring_blocks[ring_pos];
  if (screen_rows == TB_ROWS) for (block = 0; block < screen_rows + render_gbc; ++block) {
    if (bars && (block == HEADER_BLOCK || block == STATUS_BLOCK)) continue;
    if (osk && IsOSKBlock(block)) continue;
    if (block == first) ring_pos = i;
    ring_blocks[i++] = block;
  }
  if (ring_pos >= length) ring_pos = 0;
  i = ring_pos;
  render_pending = 0;
  render_text_top = bars;
  for (row = 0; row < screen_rows; ++row) {
    line = row - bars;
    if (line < tb_rows) {
      block = ring_blocks[i];
      if (++i == length) i = 0;
      map_row = (ring_top + line) & (BG_MAP_ROWS - 1);
      render_row_fonts[row] = font;
    }
    else {
      map_row = win_row++;
      if (bars && (!row || row == screen_rows - 1)) {
        block = row ? STATUS_BLOCK : HEADER_BLOCK;
        line = row ? STATUS_LINE : HEADER_LINE;
        render_row_fonts[row] = FONT_VWF;
      }
      else {
        block = osk_blocks[line - tb_rows];
        render_row_fonts[row] = FONT_MONO;
      }
    }
    render_row_lines[row] = line;
    if (screen_rows == TB_ROWS) {
      render_row_blocks[row] = block;
      if (map_blocks[map_row] != block || block_map_rows[block] != map_row) { // a block can still be listed in a map row it left
        map_blocks[map_row] = block;
        RenderSetMapRow(map_row, block);
      }
    }
  }
  render_pending_scy = (ring_top - bars) << 3;
  if (screen_rows == TB_ROWS) RenderStage();
}

// scrolls the screen one row with SCY (dir 1 = down), the block leaving the screen draws the new row
void ScrollRing(unsigned char down) {
  unsigned char length = tb_rows + render_gbc;
  if (down) {
    ring_pos = ring_pos == length - 1 ? 0 : ring_pos + 1;
    ring_top = (ring_top + 1) & (BG_MAP_ROWS - 1);
  }
  else {
    ring_pos = ring_pos ? ring_pos - 1 : length - 1;
    ring_top = (ring_top - 1) & (BG_MAP_ROWS - 1);
  }
  Layout();
}

void ScrollRows(unsigned char down) {
  ScrollRing(down);
  tb_ScrollRows(down);
}

// no selection, the bars are drawn selected
void NoHighlight(void) {
  unsigned char i;
  for (i = 0; i < (unsigned char)(screen_rows * 2); ++i) render_sel[i] = 0;
  if (bars) render_sel[1] = render_sel[(unsigned char)((screen_rows << 1) - 1)] = 0xFF;
}

void ClearScreen(void) {
  unsigned char row;
  for (row = 0; row < screen_rows; ++row) DrawRow(row, 0, "");
}
