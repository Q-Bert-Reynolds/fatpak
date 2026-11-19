/* Production 65816 terminal. cc65 supplies the C ABI, hardware.s owns the PPU
 * and ICD2. Validation is a separate pass: a bad trailing TLV changes nothing. */
#include "kernel.h"
#include "../src/sgb/protocol.h"
#include "../src/constants.h"
#include "../src/pad.h"
#include <string.h>

/* SNES geometry and overlay layout, in pixels unless named otherwise. */
#define TILE_HEIGHT 8
#define RASTER_BPP 4
#define RING_ROWS 32
#define RING_MASK (RING_ROWS - 1)
#define HEADER_ROW 0
#define FOOTER_ROW 27
#define BAR_HEADER 1
#define BAR_FOOTER 2
#define BAR_MASK (BAR_HEADER | BAR_FOOTER)
#define BAR_COUNT 2
#define TEXT_INSET 1
#define BOX_INSET 4
#define BOX_MIN_WIDTH (BOX_INSET * 2)
#define NO_SELECTION 255
#define ROW_END_FULL_WIDTH 255
#define SCROLL_ORIGIN 255 /* SNES vertical scroll is offset by one scanline. */
#define SCROLL_STEP 2
#define SCROLL_TOLERANCE 1
#define PALETTE_SIZE 16
#define COLOR_RESERVED_BIT 0x80

#define OSK_PANEL_ROWS (OSK_ROWS + 2)
#define OSK_PANEL_LEFT 44
#define OSK_PANEL_RIGHT 212
#define OSK_PANEL_WIDTH (OSK_PANEL_RIGHT - OSK_PANEL_LEFT)
#define OSK_KEYS_LEFT 52
#define OSK_KEYS_RIGHT 204
#define OSK_CELL_WIDTH 16
#define OSK_KEY_WIDTH 8
#define OSK_LINE_CHARS (OSK_COLS * 2)
#define OSK_KEY_COUNT (OSK_COLS * OSK_ROWS)
#define BUSY_LEFT 248
#define BUSY_RIGHT 252
#define BUSY_HEIGHT 4

/* Shade values consumed by BlitGlyph/EncodeRow; see raster.s ShadeColors. */
#define SHADE_PAPER 0
#define SHADE_INK 1
#define GLYPH_DIM 2
#define GLYPH_TEXT 3
#define GLYPH_KEYWORD 4
#define GLYPH_STRING 5
#define GLYPH_NUMBER 6
#define GLYPH_LABEL 7

/* Default light theme, in SNES BGR555 order; matches display.asm FsLight. */
#define RGB15(r, g, b) ((r) | ((g) << 5) | ((b) << 10))
#define COLOR_PAPER RGB15(29, 29, 27)
#define COLOR_SELECTION RGB15(20, 25, 31)
#define COLOR_DIM RGB15(14, 17, 14)
#define COLOR_TEXT RGB15(2, 2, 3)
#define COLOR_KEYWORD RGB15(4, 9, 24)
#define COLOR_STRING RGB15(19, 4, 4)
#define COLOR_NUMBER RGB15(15, 5, 20)
#define COLOR_LABEL RGB15(21, 10, 0)

/* Additional atlas fonts follow FONT_H4 in scripts/sgb_kernel.py. */
#define FONT_FIXED_BOLD 7
#define FONT_VWF_BOLD 10
#define FONT_ITALIC_OFFSET 1
#define FONT_BOLD_ITALIC_OFFSET 2
#define FONT_CHAR_COUNT 256
#define FONT_BITMAP_BYTES 2048
#define ICON_BITMAP_BYTES 64
#define NO_ICON 65535u
#define ATTR_WIDTH_MASK 0x0F
#define ATTR_STYLE_SHIFT 4
#define HEX_DIGIT_MASK 0x0F
#define CHAR_ALIGN_RIGHT 127
#define ALIGN_RIGHT_EDGE 252
#define ICON_BASIC_FIRST 1
#define ICON_BASIC_LAST 8
#define ICON_EXTRA_FIRST 129
#define ICON_EXTRA_LAST 131
#define ICON_EXTRA_BIAS 121 /* Extra codes map to atlas icons 8..10. */
#define ICON_SHIFT 29
#define ICON_MENU 31
#define ICON_UNDO 15
#define ICON_REDO 16
#define ICON_ENTER 30
#define ICON_CAPS 25

#define EVENT_BYTES 3
#define QUEUE_MASK (SGBFS_INPUT_QUEUE - 1)
#define PAD_QUEUE_RESERVE 4
#define STATUS_ECHO 4
#define STATUS_PAGE 6
#define STATUS_FRAME 2
#define STATUS_FLAGS 5
#define STATUS_CRC_OFFSET 14
#define STATUS_RESERVED_MASK 254
#define CAPTURE_PAGE_A 1
#define CAPTURE_PAGE_B 2
#define CAPTURE_CLEAR_A 254
#define CAPTURE_CLEAR_B 253
#define FRAME_UNSET 65535u

#define SNES_PAD_A 0x0080
#define SNES_PAD_B 0x8000
#define SNES_PAD_SELECT 0x2000u
#define SNES_PAD_START 0x1000
#define SNES_PAD_RIGHT 0x0100
#define SNES_PAD_LEFT 0x0200
#define SNES_PAD_UP 0x0800
#define SNES_PAD_DOWN 0x0400
#define SNES_PAD_L 0x0020
#define SNES_PAD_R 0x0010
#define SNES_PAD_DIAGNOSTICS (SNES_PAD_L | SNES_PAD_R | SNES_PAD_SELECT)

#define DEBUG_MAIL_ROW 25
#define DEBUG_COST_ROW 26
#define DEBUG_COUNTS_ROW 27
#define DEBUG_REFRESH_FRAMES 60
#define TRACE_INTERVAL_FRAMES 120
/* Trace indices follow the contiguous SGBFS_EVENT_DIAG_* event IDs. */
#define TRACE_GOOD (SGBFS_EVENT_DIAG_GOOD - SGBFS_EVENT_DIAG_GOOD)
#define TRACE_BAD (SGBFS_EVENT_DIAG_BAD - SGBFS_EVENT_DIAG_GOOD)
#define TRACE_MISS (SGBFS_EVENT_DIAG_MISS - SGBFS_EVENT_DIAG_GOOD)
#define TRACE_ROWS (SGBFS_EVENT_DIAG_ROWS - SGBFS_EVENT_DIAG_GOOD)
#define TRACE_DRAW (SGBFS_EVENT_DIAG_DRAW - SGBFS_EVENT_DIAG_GOOD)
#define TRACE_UI (SGBFS_EVENT_DIAG_UI - SGBFS_EVENT_DIAG_GOOD)
#define TRACE_PAGE (SGBFS_EVENT_DIAG_PAGE - SGBFS_EVENT_DIAG_GOOD)
#define TRACE_MAIL (SGBFS_EVENT_DIAG_MAIL - SGBFS_EVENT_DIAG_GOOD)
#define TRACE_COUNT (SGBFS_EVENT_DIAG_FRAME - SGBFS_EVENT_DIAG_GOOD + 1)

volatile u8 capture_ready;
volatile u8 capture_last;
volatile u16 capture_rows;
volatile u16 capture_missed;
volatile u16 tick;
volatile u16 pad_held[2];
volatile u16 pad_edges[2];
volatile u16 hw_frames;
u16 perf_draw;
u16 perf_ui;
u16 perf_page;
u16 perf_mail;
u16 event_started;
u16 trace_frame;
u8 trace_field;
u8 screen_received;
u8 raster[SGBFS_WIDTH * RASTER_BPP];
u8 shade[SGBFS_WIDTH * TILE_HEIGHT];
u8 mailbox[SGBFS_MAILBOX_SIZE];
u16 palette[PALETTE_SIZE] = {
  COLOR_PAPER, COLOR_SELECTION, COLOR_DIM, COLOR_TEXT,
  COLOR_KEYWORD, COLOR_STRING, COLOR_NUMBER, COLOR_LABEL
};
u8 cursor_row;
u8 cursor_x;
u8 cursor_look;

typedef struct {
  u8 font;
  u8 flags;
  u8 start;
  u8 end;
  u8 n;
  u8 chars[SGBFS_STRIDE];
  u8 attrs[SGBFS_STRIDE];
} Row;

Row rows[SGBFS_ROWS];
u8 row_attrs[SGBFS_STRIDE];
u8 dirty[SGBFS_ROWS];
/* Cache entries follow physical BG1 ring slots, independent of selection. */
u8 raster_valid[RING_ROWS];
u16 raster_hits;
u16 raster_misses;
u8 fixed_ready;
/* The fixed compositor can prepare a shared map alongside the raster. */
u8 fixed_hints;
u8 fixed_direct;
u8 fixed_slot;
u16 fixed_hits;
u16 fixed_misses;
u16 plain_rows;
u16 shared_hits;
u16 shared_hint_hits;
u8 shared_reused_blank;
u16 shared_misses;
u32 shared_tile_bytes;
u32 shared_map_bytes;
u8 top;
u8 text_rows = SGBFS_ROWS;
u8 bars;
u8 osk_rows;
u8 ring_offset;
u8 last_page[2];
u8 expected = 1;
u16 good_pages;
u16 bad_pages;
u16 drawn_rows;
u8 queue[SGBFS_INPUT_QUEUE][EVENT_BYTES];
u8 qhead;
u8 qcount;
u8 event_seq = 1;
u8 active_event;
u8 sent_pad;
u8 status_echo;
u8 status_page;
u8 status_valid;
u16 status_frame;
u8 palette_dirty;
u8 cursor_dirty;
u8 scan_row;
u8 scroll_target;
u8 scroll_current = SCROLL_ORIGIN;
u8 scroll_smooth;
u8 scroll_pending;
u8 debug_enabled;
u8 debug_dirty;
u16 debug_frame;
u8 box_rows;
u8 box_top;
u8 box_x;
u8 box_hi = NO_SELECTION;
u16 box_width;
/* Overlay storage is independent of the base rows, even when closed. */
Row box_lines[SGBFS_ROWS];
Row bar_lines[BAR_COUNT];
u8 overlay_dirty[SGBFS_ROWS];
u8 osk_layer;
u8 osk_key = NO_SELECTION;
u8 busy;
u32 loaded;
u32 total;

static u16 word(const u8 *p) {
  return p[0] | ((u16)p[1] << 8);
}

static u32 dword(const u8 *p) {
  return word(p) | ((u32)word(p + 2) << 16);
}

#ifdef SNES_TEST
static u16 crc(const u8 *p, u16 n) {
  u16 c = SGBFS_CRC_INIT;
  u8 j;
  while (n--) {
    c ^= (u16)*p++ << 8;
    for (j = 0; j < 8; ++j) {
      c = (c & 0x8000) ? (c << 1) ^ (int)SGBFS_CRC_POLY : c << 1;
    }
    Capture();
  }
  return c;
}
#else
const u8 *crc_data;
u16 crc_count;

static u16 crc(const u8 *p, u16 n) {
  crc_data = p;
  crc_count = n;
  return CRC16();
}
#endif
static u8 next(u8 s) {
  return s == SGBFS_PAGE_SEQ_MAX ? 1 : s + 1;
}

static void peak(u16 *value, u16 start) {
  u16 elapsed = Clock() - start;
  if (elapsed > *value) {
    *value = elapsed;
  }
}

static void enqueue(u8 type, u8 a, u8 b) {
  u8 at;
  u8 i;
  u8 place;
  if (qcount >= SGBFS_INPUT_QUEUE) {
    return;
  }
  /* Keep the held event immutable; control replies go ahead of queued keys. */
  place = (type == SGBFS_EVENT_KEY || type == SGBFS_EVENT_PAD || type >= SGBFS_EVENT_DIAG_GOOD)
            ? qcount : active_event;
  for (i = qcount; i > place; --i) {
    memcpy(queue + ((qhead + i) & QUEUE_MASK), queue + ((qhead + i - 1) & QUEUE_MASK), EVENT_BYTES);
    Capture();
  }
  at = (qhead + place) & QUEUE_MASK;
  queue[at][0] = type;
  queue[at][1] = a;
  queue[at][2] = b;
  ++qcount;
}

static void events(void) {
  u8 status[SGBFS_STATUS_SIZE];
  u8 i;
  for (i = 0; i < SGBFS_STATUS_SIZE; ++i) {
    status[i] = STATUS[i];
  }

  status_echo = status[STATUS_ECHO];
  status_page = status[STATUS_PAGE];
  status_frame = word(status + STATUS_FRAME);
  status_valid = status[0] == SGBFS_STATUS_MAGIC
              && status[1] == SGBFS_VERSION
              && !(status[STATUS_FLAGS] & STATUS_RESERVED_MASK)
              && !status[8] && !status[9] && !status[10]
              && !status[11] && !status[12] && !status[13]
              && crc(status, STATUS_CRC_OFFSET) == word(status + STATUS_CRC_OFFSET);

  if (active_event && status_valid && status_echo == mailbox[0]) {
    peak(&perf_mail, event_started);
    active_event = 0;
    qhead = (qhead + 1) & QUEUE_MASK;
    --qcount;
    event_seq = event_seq == SGBFS_EVENT_SEQ_MAX ? 1 : event_seq + 1;
  }
  
  if (!active_event && qcount) {
    mailbox[0] = event_seq;
    memcpy(mailbox + 1, queue[qhead], EVENT_BYTES);
    event_started = Clock();
    PublishMailbox();
    active_event = 1;
  }
}

static void ui_all(void) {
  memset(overlay_dirty, 1, SGBFS_ROWS);
}

static u8 osk_top(void) {
  return SGBFS_ROWS - !!(bars & BAR_FOOTER) - OSK_PANEL_ROWS;
}

static void ui_osk(void) {
  u8 y;
  if (osk_rows) {
    for (y = osk_top(); y < osk_top() + OSK_PANEL_ROWS; ++y) {
      overlay_dirty[y] = 1;
    }
  }
}

static void ui_box(void) {
  u8 y;
  for (y = 0; y < box_rows; ++y) {
    overlay_dirty[box_top + y] = 1;
  }
}

/* Shadow only the state needed by validators, never the 8 KiB model. */
static u8 commands(const u8 *p, u16 n, u8 apply) {
  u16 at = 0;
  u16 len;
  u16 w;
  u16 i;
  u16 k;
  u16 width;
  const u8 *b;
  u8 op;
  u8 r;
  u8 shadow_rows = text_rows;
  u8 shadow_box = box_rows;
  signed char delta;
  Row *out;
  while (at < n) {
    Capture();
    if (n - at < (int)SGBFS_COMMAND_HEADER) {
      return 0;
    }
    op = p[at];
    len = word(p + at + 1);
    at += SGBFS_COMMAND_HEADER;
    if (len > n - at) {
      return 0;
    }
    b = p + at;
    at += len;
    switch (op) {
      case SGBFS_CMD_ROW:
        if (len < SGBFS_ROW_HEADER || b[0] >= SGBFS_ROWS || b[1] > FONT_H4 ||
            b[2] > SGBFS_ROW_STYLED || b[3] > SGBFS_TEXT_WIDTH ||
            (b[4] != ROW_END_FULL_WIDTH && (b[4] < b[3] || b[4] > SGBFS_TEXT_WIDTH)) ||
            b[5] > SGBFS_STRIDE ||
            len != SGBFS_ROW_HEADER + b[5] + SGBFS_RLE_PAIR * b[6]) {
          return 0;
        }
        k = width = 0;
        for (i = SGBFS_ROW_HEADER + b[5]; i < len; i += SGBFS_RLE_PAIR) {
          if (!b[i] || !(b[i + 1] & ATTR_WIDTH_MASK) ||
              (b[i + 1] >> ATTR_STYLE_SHIFT) > STYLE_LABEL || k + b[i] > b[5]) {
            return 0;
          }
          width += (u16)b[i] * (b[i + 1] & ATTR_WIDTH_MASK);
          k += b[i];
          Capture();
        }
        if (k != b[5] || width > SGBFS_TEXT_WIDTH) {
          return 0;
        }
        if (apply) {
          k = 0;
          for (i = SGBFS_ROW_HEADER + b[5]; i < len; i += SGBFS_RLE_PAIR) {
            memset(row_attrs + k, b[i + 1], b[i]);
            k += b[i];
            Capture();
          }
          out = rows + b[0];
          if (out->font == b[1] && out->flags == b[2] && out->n == b[5] &&
              !memcmp(out->chars, b + SGBFS_ROW_HEADER, b[5]) &&
              !memcmp(out->attrs, row_attrs, b[5])) {
            if (out->start == b[3] && out->end == b[4]) {
              break;
            }
          }
          else {
            out->font = b[1];
            out->flags = b[2];
            out->n = b[5];
            memcpy(out->chars, b + SGBFS_ROW_HEADER, b[5]);
            memcpy(out->attrs, row_attrs, b[5]);
            raster_valid[(b[0] + ring_offset) & RING_MASK] = 0;
          }
          out->start = b[3];
          out->end = b[4];
          dirty[b[0]] = 1;
        }
        break;
      case SGBFS_CMD_ROW_SAME:
        if (len != 2 || b[0] >= SGBFS_ROWS || b[1] >= SGBFS_ROWS) {
          return 0;
        }
        if (apply) {
          rows[b[0]] = rows[b[1]];
          raster_valid[(b[0] + ring_offset) & RING_MASK] = 0;
          dirty[b[0]] = 1;
        }
        break;
      case SGBFS_CMD_SCROLL:
        if (len != 2) {
          return 0;
        }
        delta = (signed char)b[0];
        r = delta < 0 ? -delta : delta;
        if (!r || r > SGBFS_ROWS - 1 || r > shadow_rows || b[1] > 1) {
          return 0;
        }
        if (apply) {
          /* Rotate BG1 slots; fixed bars and dialogs live on the UI layers. */
          ring_offset = (ring_offset + delta) & RING_MASK;
          if (delta > 0) {
            for (i = 0; i < text_rows; ++i) {
              if (i + r < text_rows) {
                rows[top + i] = rows[top + i + r];
                dirty[top + i] = dirty[top + i + r];
              }
              else {
                memset(rows + top + i, 0, sizeof(Row));
                raster_valid[(top + i + ring_offset) & RING_MASK] = 0;
                dirty[top + i] = 1;
              }
              Capture();
            }
          }
          else {
            for (i = text_rows; i > 0; --i) {
              if (i > r) {
                rows[top + i - 1] = rows[top + i - 1 - r];
                dirty[top + i - 1] = dirty[top + i - 1 - r];
              }
              else {
                memset(rows + top + i - 1, 0, sizeof(Row));
                raster_valid[(top + i - 1 + ring_offset) & RING_MASK] = 0;
                dirty[top + i - 1] = 1;
              }
              Capture();
            }
          }
          /* Rows outside the scrolling viewport did not rotate their model. */
          for (i = 0; i < top; ++i) {
            raster_valid[(i + ring_offset) & RING_MASK] = 0;
          }
          for (i = top + text_rows; i < SGBFS_ROWS; ++i) {
            raster_valid[(i + ring_offset) & RING_MASK] = 0;
          }
          if (top && !(bars & BAR_HEADER)) {
            dirty[0] = 1;
          }
          if (top + text_rows < SGBFS_ROWS && !(bars & BAR_FOOTER)) {
            dirty[FOOTER_ROW] = 1;
          }
          scroll_target = ring_offset * TILE_HEIGHT - 1;
          scroll_smooth = b[1];
          scroll_pending = 1;
        }
        break;
      case SGBFS_CMD_LAYOUT:
        if (len != 4 || b[0] >= SGBFS_ROWS || !b[1] || b[1] > SGBFS_ROWS ||
            b[2] > BAR_MASK || (b[3] && b[3] != OSK_ROWS) ||
            (u16)b[0] + b[1] + !!(b[2] & BAR_FOOTER) > (int)SGBFS_ROWS) {
          return 0;
        }
        shadow_rows = b[1];
        if (apply && (top != b[0] || text_rows != b[1] || bars != b[2] || osk_rows != b[3])) {
          top = b[0];
          text_rows = b[1];
          bars = b[2];
          osk_rows = b[3];
          ui_all();
        }
        break;
      case SGBFS_CMD_CURSOR:
        if (len != 3 || b[0] >= SGBFS_ROWS || b[2] > SGBFS_CURSOR_WHITE) {
          return 0;
        }
        if (apply) {
          cursor_row = b[0];
          cursor_x = b[1];
          cursor_look = b[2];
          cursor_dirty = 1;
          screen_received = 1;
        }
        break;
      case SGBFS_CMD_BOX:
        if (len != 5) {
          return 0;
        }
        w = word(b + 1);
        if (!w) {
          if (b[0] || b[1] || b[2] || b[3] || b[4]) {
            return 0;
          }
        }
        else if (w < BOX_MIN_WIDTH || b[0] + w > SGBFS_WIDTH ||
                 !b[4] || (u16)b[3] + b[4] > SGBFS_ROWS) {
          return 0;
        }
        shadow_box = b[4];
        if (apply) {
          ui_box();
          box_x = b[0];
          box_width = w;
          box_top = b[3];
          box_rows = b[4];
          box_hi = NO_SELECTION;
          for (i = 0; i < SGBFS_ROWS; ++i) {
            memset(box_lines + i, 0, sizeof(Row));
            Capture();
          }
          ui_box();
        }
        break;
      case SGBFS_CMD_BOX_LINE:
      case SGBFS_CMD_BAR:
        if (len < 3 || b[1] > FONT_H4 || b[2] > SGBFS_STRIDE || len != 3u + b[2] ||
            b[0] >= (op == SGBFS_CMD_BOX_LINE ? shadow_box : BAR_COUNT)) {
          return 0;
        }
        if (apply) {
          out = op == SGBFS_CMD_BOX_LINE ? box_lines + b[0] : bar_lines + b[0];
          memset(out, 0, sizeof(Row));
          out->font = b[1];
          out->n = b[2];
          memcpy(out->chars, b + 3, b[2]);
          overlay_dirty[op == SGBFS_CMD_BOX_LINE ? box_top + b[0]
                                               : b[0] ? FOOTER_ROW : HEADER_ROW] = 1;
        }
        break;
      case SGBFS_CMD_BOX_HI:
        if (len != 1 || (b[0] != NO_SELECTION && b[0] >= shadow_box)) {
          return 0;
        }
        if (apply && box_hi != b[0]) {
          if (box_hi < box_rows) {
            overlay_dirty[box_top + box_hi] = 1;
          }
          box_hi = b[0];
          if (box_hi < box_rows) {
            overlay_dirty[box_top + box_hi] = 1;
          }
        }
        break;
      case SGBFS_CMD_OSK:
        if (len != 2 || b[0] > OSK_CAPS || (b[1] >= OSK_KEY_COUNT && b[1] != NO_SELECTION)) {
          return 0;
        }
        if (apply && (osk_layer != b[0] || osk_key != b[1])) {
          osk_layer = b[0];
          osk_key = b[1];
          ui_osk();
        }
        break;
      case SGBFS_CMD_PALETTE:
        if (len < 4 || !b[1] || b[1] > PALETTE_SIZE || b[0] + b[1] > PALETTE_SIZE ||
            len != 2u + 2u * b[1]) {
          return 0;
        }
        for (i = 0; i < b[1]; ++i) {
          if (b[3 + i * 2] & COLOR_RESERVED_BIT) {
            return 0;
          }
        }
        if (apply) {
          for (i = 0; i < b[1]; ++i) {
            palette[b[0] + i] = word(b + 2 + i * 2);
          }
          palette_dirty = 1;
        }
        break;
      case SGBFS_CMD_BUSY:
        if (len != 1 || b[0] > 1) {
          return 0;
        }
        if (apply && busy != b[0]) {
          busy = b[0];
          overlay_dirty[0] = 1;
        }
        break;
      case SGBFS_CMD_PROGRESS:
        if (len != 8 || dword(b) > dword(b + 4)) {
          return 0;
        }
        if (apply) {
          loaded = dword(b);
          total = dword(b + 4);
          overlay_dirty[FOOTER_ROW] = 1;
        }
        break;
      /* Launch is intentionally held for Phase 10, never arm a cartridge here. */
      case SGBFS_CMD_LAUNCH:
        return 0;
      case SGBFS_CMD_HELLO:
      case SGBFS_CMD_RESET:
        if (len != 2 || b[0] != SGBFS_VERSION || b[1] != SGBFS_PROFILE) {
          return 0;
        }
        /* Reset cannot be mixed with mutations: restart is a fresh session. */
        if (n != 5) {
          return 0;
        }
        if (apply) {
          memset(rows, 0, sizeof(rows));
          memset(raster_valid, 0, sizeof(raster_valid));
          memset(dirty, 1, SGBFS_ROWS);
          top = 0;
          text_rows = SGBFS_ROWS;
          ring_offset = 0;
          SetScroll(SCROLL_ORIGIN);
        }
        break;
      default:
        return 0;
    }
  }
  return 1;
}

static void page(u8 slot) {
  u8 seq;
  u16 n;
  const u8 *p = SNAPSHOT;
  /* Most capture notifications repeat an already-applied page (or empty B).
     Avoid the 1920-byte copy, but recheck the copied sequence and full CRC below. */
  seq = slot ? PAGE_B[0] : PAGE_A[0];
  if (!seq || seq == last_page[slot] || seq != expected ||
      qcount > SGBFS_INPUT_QUEUE - SGBFS_INPUT_RESERVED) {
    return;
  }
  Snapshot(slot);
  seq = p[0];
  if (!seq) {
    return;
  }
  if (seq == last_page[slot]) {
    /* An ACK already queued/held is sufficient, never fill the queue on retries. */
    return;
  }
  if (seq != expected || qcount > SGBFS_INPUT_QUEUE - SGBFS_INPUT_RESERVED) {
    return;
  }
  n = word(p + 1);
  if (n > SGBFS_PAGE_PAYLOAD) {
    return;
  }
  if (crc(p, n + SGBFS_PAGE_HEADER) != word(p + n + SGBFS_PAGE_HEADER) ||
      !commands(p + SGBFS_PAGE_HEADER, n, 0)) {
    ++bad_pages;
    return;
  }
  commands(p + SGBFS_PAGE_HEADER, n, 1);
  last_page[slot] = seq;
  expected = next(seq);
  ++good_pages;
  enqueue(SGBFS_EVENT_ACK, slot, seq);
}

static void receive(u8 slot) {
  u16 start = Clock();
  page(slot);
  peak(&perf_page, start);
}

/* Shade planes retain overlapping italic glyphs, dim and syntax accents. */
u16 glyph_offset;
u16 glyph_x;
u16 glyph_icon;
u16 glyph_right;
u8 glyph_color;

#if defined(SNES_TEST) || defined(SNES_GLYPH_CHECK)
static void glyphs_reference(const Row *row, u16 left, u16 right) {
  u16 x = left;
  u8 i;
  u8 c;
  u8 f;
  u8 style;
  u8 color;
  u8 j;
  u8 k;
  signed char icon;
  for (i = 0; i < row->n && x < right; ++i) {
    c = row->chars[i];
    if (!row->flags && c == CHAR_ALIGN_RIGHT) {
      while (i + 1 < row->n && row->chars[i + 1] == CHAR_ALIGN_RIGHT) {
        ++i;
      }
      x = ALIGN_RIGHT_EDGE;
      k = row->n;
      while (k > i + 1 && row->chars[k - 1] == ' ') {
        --k;
      }
      for (j = i + 1; j < k; ++j) {
        x -= FontWidth((u16)row->font * FONT_CHAR_COUNT + row->chars[j]);
        Capture();
      }
      continue;
    }
    /* Every font's space bitmap is empty; selection is painted by EncodeRow. */
    if (c == ' ') {
      x += row->flags ? (row->attrs[i] & ATTR_WIDTH_MASK)
                      : FontWidth((u16)row->font * FONT_CHAR_COUNT + c);
      continue;
    }
    style = row->flags ? row->attrs[i] >> ATTR_STYLE_SHIFT : STYLE_TEXT;
    f = row->font;
    if (f < FONT_H1) {
      if (style == STYLE_CODE) {
        f = FONT_FIXED;
      }
      else if (style == STYLE_BOLD || style == STYLE_BOLD_ITALIC ||
               style == STYLE_HEAD_BOLD || style == STYLE_PREPROC || style == STYLE_ITALIC) {
        /* Keep the reference explicit: cc65's optimized output miscompiles the nested ternary
           here by reading the character slot instead of style in its last arm. */
        if (f == FONT_FIXED) {
          f = FONT_FIXED_BOLD;
        }
        else {
          f = FONT_VWF_BOLD;
        }
        if (style == STYLE_BOLD_ITALIC) {
          f += FONT_BOLD_ITALIC_OFFSET;
        }
        else if (style == STYLE_ITALIC) {
          f += FONT_ITALIC_OFFSET;
        }
      }
    }
    color = style == STYLE_MARK || style == STYLE_COMMENT ? GLYPH_DIM : GLYPH_TEXT;
    if (style == STYLE_CODE || style == STYLE_STRING) {
      color = GLYPH_STRING;
    }
    else if (style == STYLE_HEAD || style == STYLE_HEAD_BOLD ||
             style == STYLE_KEYWORD || style == STYLE_TYPE) {
      color = GLYPH_KEYWORD;
    }
    else if (style == STYLE_NUMBER) {
      color = GLYPH_NUMBER;
    }
    else if (style == STYLE_PREPROC || style == STYLE_LABEL) {
      color = GLYPH_LABEL;
    }
    icon = c >= ICON_BASIC_FIRST && c <= ICON_BASIC_LAST ? c - ICON_BASIC_FIRST
           : c >= ICON_EXTRA_FIRST && c <= ICON_EXTRA_LAST ? c - ICON_EXTRA_BIAS : -1;
    glyph_offset = (u16)f * FONT_BITMAP_BYTES + (u16)c * TILE_HEIGHT;
    glyph_x = x;
    glyph_right = right;
    glyph_color = color;
    glyph_icon = (!row->flags && icon >= 0) ? FONT_ICONS + (u16)icon * ICON_BITMAP_BYTES : NO_ICON;
    BlitGlyph();
    x += row->flags ? (row->attrs[i] & ATTR_WIDTH_MASK)
                      : FontWidth((u16)row->font * FONT_CHAR_COUNT + c);
  }
}
#endif

#ifndef SNES_TEST
/* Native layout shares the same Row model and compositing globals as above. */
const u8 native_row_size = sizeof(Row);
const Row *glyph_row;
void DrawGlyphs(void);
u8 DrawFixedTiles(void);
u8 DrawPlainTiles(void);

static u8 plain_tiles(const Row *row) {
  glyph_row = row;
  return DrawPlainTiles();
}

static u8 fixed_tiles(const Row *row) {
  glyph_row = row;
  return DrawFixedTiles();
}

static void glyphs(const Row *row, u16 left, u16 right) {
  glyph_row = row;
  glyph_x = left;
  glyph_right = right;
  DrawGlyphs();
}
#else
#define glyphs glyphs_reference
#define fixed_tiles(row) 0
#define plain_tiles(row) 0
#endif

#ifdef SNES_GLYPH_CHECK
#include "../tests/sgb/glyph_checks.h"
#endif

u16 pixel_start = SGBFS_WIDTH;
u16 pixel_end = SGBFS_WIDTH;

static void pixels(const Row *row, u16 left, u16 right, u8 selected) {
  (void)left;
  (void)right;
  pixel_start = selected ? left : row->start == row->end ? SGBFS_WIDTH : row->start;
  pixel_end = selected ? right : row->start == row->end ? SGBFS_WIDTH
                                  : row->end == ROW_END_FULL_WIDTH ? SGBFS_WIDTH : row->end;
  SelectRaster();
}

static void hex4(u8 *p, u16 v) {
  static const u8 digits[] = "0123456789ABCDEF";
  u8 i;
  for (i = 0; i < 4; ++i) {
    p[3 - i] = digits[v & HEX_DIGIT_MASK];
    v >>= 4;
  }
}

static void draw(u8 row) {
  u16 start = Clock();
  const Row *source = rows + row;
  u8 slot = (row + ring_offset) & RING_MASK;
#ifdef SNES_SHARED_RENDER
  fixed_hints = 0;
  fixed_direct = 0;
#endif
  if (raster_valid[slot]) {
    RestoreRaster(slot);
    ++raster_hits;
  }
  else {
#ifdef SNES_SHARED_RENDER
    fixed_slot = slot;
    fixed_direct = source->start == source->end;
#endif
    if (!fixed_tiles(source) && !plain_tiles(source)) {
      ClearRaster();
      glyphs(source, source->font ? TEXT_INSET : 0,
             source->font ? SGBFS_TEXT_WIDTH + TEXT_INSET : SGBFS_TEXT_WIDTH);
      pixel_start = pixel_end = SGBFS_WIDTH;
      EncodeRow();
    }
#ifdef SNES_SHARED_RENDER
    if (!fixed_hints) {
#endif
      CacheRaster(slot);
      raster_valid[slot] = 1;
#ifdef SNES_SHARED_RENDER
    }
    else {
      raster_valid[slot] = 0;
    }
#endif
    ++raster_misses;
  }
#ifdef SNES_SHARED_RENDER
  if (!fixed_hints) pixels(source, 0, SGBFS_WIDTH, 0);
  if (source->start != source->end) fixed_hints = 0;
#else
  pixels(source, 0, SGBFS_WIDTH, 0);
#endif
  PresentRow(slot);
  dirty[row] = 0;
  ++drawn_rows;
  peak(&perf_draw, start);
}

u16 ui_left;

u16 ui_right;

static u16 progress_width(void) {
  u8 i;
  u16 result = 0;
  u32 rem = loaded;
  if (!total) {
    return 0;
  }
  if (loaded == total) {
    return SGBFS_WIDTH;
  }
  for (i = 0; i < 8; ++i) {
    result <<= 1;
    if (rem >= total - rem) {
      rem -= total - rem;
      ++result;
    }
    else {
      rem += rem;
    }
  }
  return result;
}

static void draw_ui(u8 row) {
  static const u8 keys[OSK_SYMBOLS + 1][(OSK_ROWS - 1) * OSK_COLS + 1] = {
    "1234567890qwertyuiopasdfghjkl;zxcvbnm,./",
    "!@#$%^&*()QWERTYUIOPASDFGHJKL:ZXCVBNM<>?",
    "`~-_=+[]{}\\|'\"\241\277\341\351\355\363\372\361\374"
  };

  static const u8 bottom[OSK_LINE_CHARS] = {
    ICON_SHIFT, ' ', '#', ' ', ICON_MENU, ' ', '_', '_', '_', '_',
    '_', '_', '_', '_', ICON_UNDO, ' ', ICON_REDO, ' ', ICON_ENTER, ' '
  };

  Row keyrow;
  u8 y;
  u8 i;
  u8 rel;
  u16 x;
  u16 width;
  u16 start = Clock();
  ClearRaster();
  pixel_start = pixel_end = SGBFS_WIDTH;
  ui_left = ui_right = 0;

  if ((row == HEADER_ROW && (bars & BAR_HEADER)) || (row == FOOTER_ROW && (bars & BAR_FOOTER))) {
    glyphs(bar_lines + (row ? 1 : 0), bar_lines[row ? 1 : 0].font ? TEXT_INSET : 0, SGBFS_WIDTH);
    ui_right = SGBFS_WIDTH;
    pixel_start = 0;
    pixel_end = SGBFS_WIDTH;
  }

  if (osk_rows && row >= osk_top() && row < osk_top() + OSK_PANEL_ROWS) {
    /* 168px panel centered on the SNES, independent of the document rows. */
    ui_left = OSK_PANEL_LEFT;
    ui_right = OSK_PANEL_RIGHT;
    for (y = 0; y < TILE_HEIGHT; ++y) {
      memset(shade + (u16)y * SGBFS_WIDTH + OSK_PANEL_LEFT, SHADE_PAPER, OSK_PANEL_WIDTH);
      Capture();
    }
    rel = row - osk_top();
    if (rel && rel < OSK_ROWS + 1) {
      --rel;
      memset(&keyrow, 0, sizeof(keyrow));
      keyrow.n = OSK_LINE_CHARS;
      memset(keyrow.chars, ' ', OSK_LINE_CHARS);
      if (rel < OSK_ROWS - 1) {
        for (i = 0; i < OSK_COLS; ++i) {
          y = rel * OSK_COLS + i;
          if (keys[osk_layer == OSK_CAPS ? OSK_SHIFT : osk_layer][y]) {
            keyrow.chars[i * 2] = keys[osk_layer == OSK_CAPS ? OSK_SHIFT : osk_layer][y];
          }
        }
      }
      else {
        memcpy(keyrow.chars, bottom, OSK_LINE_CHARS);
        if (osk_layer == OSK_CAPS) {
          keyrow.chars[0] = ICON_CAPS;
        }
      }
      glyphs(&keyrow, OSK_KEYS_LEFT, OSK_KEYS_RIGHT);
      if (osk_key != NO_SELECTION && osk_key / OSK_COLS == rel) {
        pixel_start = OSK_KEYS_LEFT + (osk_key % OSK_COLS) * OSK_CELL_WIDTH;
        pixel_end = pixel_start + OSK_KEY_WIDTH;
      }
    }
    for (y = 0; y < TILE_HEIGHT; ++y) {
      shade[(u16)y * SGBFS_WIDTH + OSK_PANEL_LEFT] = SHADE_INK;
      shade[(u16)y * SGBFS_WIDTH + (OSK_PANEL_RIGHT - 1)] = SHADE_INK;
    }
    if (row == osk_top() || row == osk_top() + (OSK_PANEL_ROWS - 1)) {
      y = row == osk_top() ? 0 : TILE_HEIGHT - 1;
      for (x = OSK_PANEL_LEFT; x < OSK_PANEL_RIGHT; ++x) {
        shade[(u16)y * SGBFS_WIDTH + x] = SHADE_INK;
      }
    }
  }

  if (box_width && row >= box_top && row < box_top + box_rows) {
    for (y = 0; y < TILE_HEIGHT; ++y) {
      memset(shade + (u16)y * SGBFS_WIDTH + box_x, SHADE_PAPER, box_width);
      Capture();
    }
    glyphs(box_lines + (row - box_top), box_x + BOX_INSET, box_x + box_width - BOX_INSET);
    if (!ui_right || box_x < ui_left) {
      ui_left = box_x;
    }
    if (box_x + box_width > ui_right) {
      ui_right = box_x + box_width;
    }
    if (row - box_top == box_hi) {
      pixel_start = box_x;
      pixel_end = box_x + box_width;
    }
    for (y = 0; y < TILE_HEIGHT; ++y) {
      shade[(u16)y * SGBFS_WIDTH + box_x] = SHADE_INK;
      shade[(u16)y * SGBFS_WIDTH + box_x + box_width - 1] = SHADE_INK;
    }
    if (row == box_top || row == box_top + box_rows - 1) {
      y = row == box_top ? 0 : TILE_HEIGHT - 1;
      for (x = box_x; x < box_x + box_width; ++x) {
        shade[(u16)y * SGBFS_WIDTH + x] = SHADE_INK;
      }
    }
  }

  if (row == HEADER_ROW && busy) {
    for (y = 0; y < BUSY_HEIGHT; ++y) {
      for (i = BUSY_LEFT; i < BUSY_RIGHT; ++i) {
        shade[(u16)y * SGBFS_WIDTH + i] = SHADE_INK;
      }
    }
  }

  if (row == FOOTER_ROW && total) {
    width = progress_width();
    for (x = 0; x < width; ++x) {
      shade[(TILE_HEIGHT - 1) * SGBFS_WIDTH + x] = SHADE_INK;
    }
  }

  /* Diagnostics must cover the status bar, which otherwise hides BG1 row 27. */
  if (row >= DEBUG_MAIL_ROW && debug_enabled) {
    ClearRaster();
    memset(&keyrow, 0, sizeof(keyrow));
    keyrow.font = FONT_FIXED;
    if (row == DEBUG_COUNTS_ROW) {
      keyrow.n = 46;
      memcpy(keyrow.chars, "SGB GOOD:0000 BAD:0000 MISS:0000 ROW:0000 Q:00", 46);
      hex4(keyrow.chars + 9, good_pages);
      hex4(keyrow.chars + 18, bad_pages);
      hex4(keyrow.chars + 28, capture_missed);
      hex4(keyrow.chars + 37, capture_rows);
      keyrow.chars[44] = "0123456789ABCDEF"[qcount >> 4];
      keyrow.chars[45] = "0123456789ABCDEF"[qcount & HEX_DIGIT_MASK];
    }
    else if (row == DEBUG_COST_ROW) {
      keyrow.n = 48;
      memcpy(keyrow.chars, "DRAW:0000 UI:0000 PAGE:0000 MAIL:0000 FRAME:0000", 48);
      hex4(keyrow.chars + 5, perf_draw);
      hex4(keyrow.chars + 13, perf_ui);
      hex4(keyrow.chars + 23, perf_page);
      hex4(keyrow.chars + 33, perf_mail);
      hex4(keyrow.chars + 44, Clock());
    }
    else {
      keyrow.n = 43;
      memcpy(keyrow.chars, "MB:0000/0000 E:00 GB:0000 P:00 V:00 NEXT:00", 43);
      hex4(keyrow.chars + 3, ((u16)mailbox[0] << 8) | mailbox[1]);
      hex4(keyrow.chars + 8, ((u16)mailbox[2] << 8) | mailbox[3]);
      keyrow.chars[15] = "0123456789ABCDEF"[status_echo >> 4];
      keyrow.chars[16] = "0123456789ABCDEF"[status_echo & HEX_DIGIT_MASK];
      hex4(keyrow.chars + 21, status_frame);
      keyrow.chars[28] = "0123456789ABCDEF"[status_page >> 4];
      keyrow.chars[29] = "0123456789ABCDEF"[status_page & HEX_DIGIT_MASK];
      keyrow.chars[34] = status_valid ? '1' : '0';
      keyrow.chars[41] = "0123456789ABCDEF"[expected >> 4];
      keyrow.chars[42] = "0123456789ABCDEF"[expected & HEX_DIGIT_MASK];
    }
    glyphs(&keyrow, 8, SGBFS_WIDTH);
    pixel_start = pixel_end = SGBFS_WIDTH;
    ui_left = 0;
    ui_right = SGBFS_WIDTH;
  }
  /* ClearRaster already supplied transparent tiles for an empty UI row.
     Still upload them and its empty mask to erase any previous overlay. */
  if (ui_left != ui_right || (row == HEADER_ROW && busy) || (row == FOOTER_ROW && total)) {
    EncodeRow();
  }
  PresentOverlay(row);
  overlay_dirty[row] = 0;
  peak(&perf_ui, start);
}

static u8 pad_bits(u16 state) {
  u8 pad = 0;
  if (state & SNES_PAD_A) pad |= PADF_A;
  if (state & SNES_PAD_B) pad |= PADF_B;
  if (state & SNES_PAD_SELECT) pad |= PADF_SELECT;
  if (state & SNES_PAD_START) pad |= PADF_START;
  if (state & SNES_PAD_RIGHT) pad |= PADF_RIGHT;
  if (state & SNES_PAD_LEFT) pad |= PADF_LEFT;
  if (state & SNES_PAD_UP) pad |= PADF_UP;
  if (state & SNES_PAD_DOWN) pad |= PADF_DOWN;
  return pad;
}

static void pads(void) {
  u16 held = pad_held[0];
  u16 e = pad_edges[0];
  u8 pad;
  u8 pulse;

  /* Keep short presses latched across drawing, with room for their release. */
  if (qcount >= SGBFS_INPUT_QUEUE - PAD_QUEUE_RESERVE) {
    return;
  }

  pad_edges[0] = pad_edges[1] = 0;
  if ((held & SNES_PAD_DIAGNOSTICS) == SNES_PAD_DIAGNOSTICS) {
    if (e & SNES_PAD_DIAGNOSTICS) {
      debug_enabled ^= 1;
      overlay_dirty[DEBUG_MAIL_ROW] = overlay_dirty[DEBUG_COST_ROW] =
        overlay_dirty[DEBUG_COUNTS_ROW] = 1;
    }
    held &= ~SNES_PAD_SELECT;
    e &= ~SNES_PAD_SELECT; /* reserve L+R+Select for diagnostics */
  }

  /* Port 2 belongs to the mouse. GB code interprets pad state in UI context. */
  pad = pad_bits(held);
  pulse = pad | pad_bits(e);
  if (pulse != sent_pad) {
    enqueue(SGBFS_EVENT_PAD, pulse, pulse & ~sent_pad);
    sent_pad = pulse;
  }

  if (pad != sent_pad) {
    enqueue(SGBFS_EVENT_PAD, pad, 0);
    sent_pad = pad;
  }
}

#ifdef SNES_CACHE_CHECK
#include "../tests/sgb/cache_checks.h"
#endif

#ifdef SNES_TILE_CHECK
#include "../tests/sgb/tile_checks.h"
#endif

#ifdef SNES_PLAIN_CHECK
#include "../tests/sgb/plain_checks.h"
#endif
#ifdef SNES_SHARED_CHECK
#include "../tests/sgb/shared_checks.h"
#endif

void main(void) {
  u16 frame = FRAME_UNSET;
  u8 slot;
#ifdef SNES_GLYPH_CHECK
  GlyphChecks();
#endif
#ifdef SNES_CACHE_CHECK
  CacheChecks();
#endif
#ifdef SNES_TILE_CHECK
  TileChecks();
#endif
#ifdef SNES_PLAIN_CHECK
  PlainChecks();
#endif
#ifdef SNES_SHARED_CHECK
  SharedChecks();
#endif

  trace_field = TRACE_DRAW; /* Start with rendering cost, then finish the counter rotation. */
  OverlayInit();
  memset(dirty, 1, SGBFS_ROWS);
  ui_all();
  enqueue(SGBFS_EVENT_HELLO, SGBFS_VERSION, SGBFS_FEATURE_COLOR | SGBFS_FEATURE_PAD2);

  for (;;) {
    Capture();
    events();
    if (capture_ready & CAPTURE_PAGE_A) {
      capture_ready &= CAPTURE_CLEAR_A;
      receive(0);
      events();
    }

    if (capture_ready & CAPTURE_PAGE_B) {
      capture_ready &= CAPTURE_CLEAR_B;
      receive(1);
      events();
    }

    if (frame != tick) {
      frame = tick;
      /* A held event is immutable until its status echo. Reissue it once per
         frame so a missed ICD2 commit cannot strand all later page ACKs. */
      if (active_event) {
        PublishMailbox();
      }
      pads();

      /* Keep diagnostics out of startup. A single optional sample must not
         occupy the mailbox until the first screen has been received and drawn. */
      if (screen_received && drawn_rows >= SGBFS_ROWS && !qcount &&
          (u16)(Clock() - trace_frame) >= TRACE_INTERVAL_FRAMES) {
        u16 value;
        trace_frame = Clock();
        switch (trace_field) {
          case TRACE_GOOD:
            value = good_pages;
            break;
          case TRACE_BAD:
            value = bad_pages;
            break;
          case TRACE_MISS:
            value = capture_missed;
            break;
          case TRACE_ROWS:
            value = capture_rows;
            break;
          case TRACE_DRAW:
            value = perf_draw;
            break;
          case TRACE_UI:
            value = perf_ui;
            break;
          case TRACE_PAGE:
            value = perf_page;
            break;
          case TRACE_MAIL:
            value = perf_mail;
            break;
          default:
            value = Clock();
            break;
        }

        enqueue(SGBFS_EVENT_DIAG_GOOD + trace_field, value, value >> 8);
        if (++trace_field == TRACE_COUNT) {
          trace_field = TRACE_GOOD;
        }
      }

      if (debug_enabled && (u16)(tick - debug_frame) >= DEBUG_REFRESH_FRAMES) {
        debug_frame = tick;
        overlay_dirty[DEBUG_MAIL_ROW] = overlay_dirty[DEBUG_COST_ROW] =
          overlay_dirty[DEBUG_COUNTS_ROW] = 1;
      }

      if (scroll_pending) {
        u8 i;
        u8 waiting = 0;
        for (i = top; i < top + text_rows; ++i) {
          waiting |= dirty[i];
        }

        if (!waiting) {
          if (!scroll_smooth) {
            scroll_current = scroll_target;
          }
          else if ((signed char)(scroll_target - scroll_current) > 0) {
            scroll_current += SCROLL_STEP;
          }
          else {
            scroll_current -= SCROLL_STEP;
          }
          if ((u8)(scroll_current - scroll_target) <= SCROLL_TOLERANCE) {
            scroll_current = scroll_target;
            scroll_pending = 0;
          }
          WaitBlank();
          SetScroll(scroll_current);
        }
      }
    }

    /* A fault report must not wait behind the initial 28-row repaint. */
    if (debug_enabled && overlay_dirty[DEBUG_COUNTS_ROW]) draw_ui(DEBUG_COUNTS_ROW);
    if (debug_enabled && overlay_dirty[DEBUG_COST_ROW]) draw_ui(DEBUG_COST_ROW);
    if (debug_enabled && overlay_dirty[DEBUG_MAIL_ROW]) draw_ui(DEBUG_MAIL_ROW);

    slot = scan_row++;
    if (scan_row == SGBFS_ROWS) {
      scan_row = 0;
    }

    if (dirty[slot]) {
      draw(slot);
    }
    else if (overlay_dirty[slot]) {
      draw_ui(slot);
    }

    if (palette_dirty || cursor_dirty) {
      WaitBlank();
      if (palette_dirty) {
        PresentPalette();
        palette_dirty = 0;
      }
      if (cursor_dirty) {
        PresentCursor();
        cursor_dirty = 0;
      }
    }
  }
}
