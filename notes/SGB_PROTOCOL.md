# SGB fullscreen protocol v1

Phase 1 specification. Constants are defined only in
[`src/sgb/protocol.asm`](../src/sgb/protocol.asm). Run `make sgb-protocol` to
regenerate the C header, ca65 include and C++ header; `make test-sgb-protocol`
checks freshness, compiles all three consumers plus RGBDS, and exercises the
strict Python reference codec in `scripts/sgb_protocol.py`.

This defines the future fullscreen backend's wire format. The Phase 0b probe
uses a deliberately simpler fixed-length word-sum format and is **not** a v1
terminal implementation. The existing BIOS mouse driver also remains separate.

## LCD map and page publication

The GB uses unsigned tile addressing (`LCDC=$91`), `BGP=$E4`, zero scroll, no
window/sprites, and a fixed 20-column map. No LCDC/STAT raster switching is needed.

| Rows | Tiles / VRAM | Meaning |
| --- | --- | --- |
| 0–5 | 0–119, `$8000–$877F` | Page A, 1920 bytes |
| 6–11 | 120–239, `$8780–$8EFF` | Page B, 1920 bytes |
| 12 | 240–255, `$8F00–$8FFF` | 16 status tiles; final tile stays zero |
| Row 12 columns 16–19, rows 13–17 | tile 255 | Blank |

All multibyte integers are little endian. A page is:

| Offset | Size | Meaning |
| --- | --- | --- |
| 0 | 1 | Global sequence, 1–255; 0 means unpublished/in progress |
| 1 | 2 | Command-stream byte length, 0–1915 |
| 3 | length | Complete TLV commands |
| 3 + length | 2 | CRC-16/CCITT-FALSE over sequence, length and commands |
| Remaining | — | Padding, ignored by the receiver |

CRC polynomial `$1021`, initial value `$FFFF`, no reflection and no final XOR;
check value for ASCII `123456789` is `$29B1`. Neither a command nor its RLE may
cross a page boundary. Empty pages are valid.

The writer owns a free page until publication: write sequence 0, then length,
payload and CRC, then commit the nonzero sequence **last**. It must not refill
that page until an `ACK(page, sequence)` arrives. The SNES captures completed
ICD2 rows, rejects invalid/torn pages, and retries on later LCD frames. Capture
storage must not be overwritten during validation: use a second capture image,
or abandon an unfinished validation when capture of that same page restarts.

Sequence numbers are global across A/B; they wrap 255 → 1, skipping 0. After
HELLO/RESET the first page is sequence 1. The SNES validates every command before
applying any, then applies only the next expected sequence. A later page waits
unacknowledged for the missing earlier page. A duplicate must never reapply
commands such as SCROLL; its previous acceptance can be acknowledged again.
There are at most two unacknowledged pages, so modular ordering is unambiguous:
`(new-old) mod 255` in 1–127 means newer.

## Command framing

Each command is `[opcode:u8][payload_length:u16][payload]`. The IDs below follow
the `SGBFS_CMD_*` constants; unknown opcodes, invalid lengths/ranges and unknown
flag bits reject the **whole page**. No partial display changes or ACK occur.
Version/profile mismatch requires a new handshake, not guessing at a schema.

Rows are 0–27, fonts use the existing GB IDs 0–6, and strings are counted GB glyph
bytes (including UI glyphs), never NUL terminated or UTF-8. Counts are at most
64. Screen x is 0–255; text rows have an 8 px left margin and 248 px content.

| Command | Payload |
| --- | --- |
| ROW | `row, font, flags, sel_start, sel_end, n, run_count`, then `chars[n]`, then `(count, attribute)[run_count]` |
| ROW_SAME | `destination_row, source_row` |
| SCROLL | signed 8-bit nonzero delta −27…27, `smooth` (0/1) |
| LAYOUT | `text_top, text_rows, bars, osk_rows` |
| CURSOR | `row, screen_x, look` (0 hidden, 1 normal, 2 white) |
| BOX | `screen_x:u8, width:u16, top_row:u8, rows:u8`; all zero closes the box |
| BOX_LINE | `relative_line, font, n, chars[n]` |
| BOX_HI | highlighted relative line; `$FF` means none |
| BAR | `which` (0 top / 1 bottom), `font, n, chars[n]` |
| OSK | `layer` (0–3), `key` (0–49 or `$FF` none) |
| PALETTE | `first, count`, then `BGR555:u16[count]`; indices 0–15, bit 15 clear |
| BUSY | 0/1 |
| PROGRESS | `loaded_KiB:u32, total_KiB:u32`, loaded ≤ total |
| LAUNCH | mode 1: `RESET_REQUIRED` (see launch policy) |
| HELLO / RESET | `version` (1), `profile` (0) |

ROW flag bit 0 means styled text; other bits are zero. An attribute contains
width 1–15 in its low nibble and the existing `STYLE_*` 0–14 in its high nibble.
RLE counts are 1–255 and must expand to exactly n attributes; zero runs,
overrun/underrun and odd encodings are invalid. Sum of widths must be ≤248 px.
Selection is in text-relative pixels: start 0–248, end start–248, or end `$FF`
for the right edge. Equal start/end means no selection. The reference encoder
coalesces adjacent identical attributes; equivalent noncanonical runs decode.

LAYOUT bars is bit 0 top / bit 1 bottom; OSK rows is 0 or 5. Text rows must be
nonempty and `top + text_rows + osk_rows + bottom_bar <= 28`. BOX width is at
least 8 px, its right edge cannot exceed 256, and its rows must fit the screen.
Stateful constraints (e.g. BOX_LINE within the currently open box, SCROLL within
the current text ring, OSK layer contents) belong to the model in Phase 6.
ROW_SAME copies the model row, not a VRAM address. BOX/BAR/OSK do not erase the
underlying SNES text model.

## Mailbox and input acknowledgement

SNES sets `$6003=$B1` (four players, GB running, normal clock) and publishes:

| ICD2 register | Byte |
| --- | --- |
| `$6004` | Event commit sequence, 1–127, bit 7 busy |
| `$6005` | Event type |
| `$6006` | Payload A |
| `$6007` | Payload B |

The writer first sets `sequence|$80`, writes bytes 1–3, then commits sequence
with bit 7 clear. The GB reads byte 0 before and after all four bytes; accept
only equal, nonzero, nonbusy commits. Idle 0 is not an event. Sequence wraps
127 → 1. This is separate from the 8-bit page sequence space.

| Event | A | B |
| --- | --- | --- |
| KEY | Existing GB ASCII/`KEY_*` code (nonzero) | Shift=1, Ctrl=2, Alt=4 |
| MOUSE_DOWN / MOUSE_DRAG / MOUSE_UP / MOUSE_MOVE | `(buttons << 5) \| screen_row` | Screen pixel x |
| HELLO | Protocol version | Color=1, mouse=2, pad 2=4 |
| ACK | Page 0=A / 1=B | Applied page sequence, 1–255 |
| LAUNCH_READY | Mode 1 RESET_REQUIRED | 0 |

Mouse buttons are left=1/right=2 and represent the state **after** the event.
DOWN/DRAG require a held button; MOVE is hover with no buttons. UP may leave
another button held. Motion is needed for GB menu hover even though SNES draws
the pointer itself. Mouse row 28–31 and bit 7 are invalid.

The SNES holds an event until the GB echoes its sequence in a CRC-valid status
record. The GB processes a duplicate only once, but continues echoing its ACK.
Do not overwrite an unacknowledged mailbox even for a page ACK. Queue up to 64
events; reserve three entries for two page ACKs and launch completion. Coalesce
motion within the same button state; preserve press/release and key edges.
Page ACK/control events have priority. On reset, discard the old event queue,
exchange HELLO, and restart event/page sequence spaces. Interpreting key codes
and generating repeat remain the later input implementation's job.

## Status record

The GB VBlank handler writes this 16-byte record at `$8F00`; the remainder of
the status tiles stays zero, including blank tile 255. The SNES ignores a bad
status CRC, retaining its previous acknowledged event and state.

| Offset | Size | Meaning |
| --- | --- | --- |
| 0 | 1 | `$53` magic |
| 1 | 1 | Protocol version 1 |
| 2 | 2 | GB frame heartbeat (wraps at 65536) |
| 4 | 1 | Last consumed event sequence, 0 before the first event |
| 5 | 1 | Busy flag bit 0; other bits zero |
| 6 | 1 | Last committed page A sequence (0 if none) |
| 7 | 1 | Last committed page B sequence (0 if none) |
| 8 | 6 | Reserved zero |
| 14 | 2 | CRC over bytes 0–13 |

HELLO wait budget is 180 GB frames after JUMP, page ACK budget 120. Busy status
suspends ordinary inactivity checks while a build or filesystem operation runs.
A timeout is an error indication; it must not silently reset the GB or discard
unsaved text. Fullscreen post-JUMP automatic fallback remains a Phase 5 risk;
these constants do not claim that recovery has been implemented.

## Launch policy and Phase 0c limit

V1 selects `RESET_REQUIRED`: after loading, the SNES sends LAUNCH_READY and waits
for its status echo. The GB then uses the existing EverDrive arm/handoff, and
the SNES displays a reset instruction until the user resets the console. That
allows a fresh BIOS/GB handshake. The complete armed-cart cycle still requires
Phase 10 hardware validation.

The Phase 0c probe proves a **non-destructive** JUMP can return via a bank-0 RTS
while preserving the BIOS stack/registers/PPU. It does not prove restoring a PPU
whose VRAM/CGRAM have been replaced by the fullscreen renderer. Automatic BIOS
reset + armed EverDrive launch is also unverified. Therefore mode 0 (BIOS first)
is not accepted in v1; automatic launch can be added after that work is proven.

## SGB.DAT container

The reference codec packs/validates this format. The normal build now emits
`bin/SGB.DAT` containing the production SNES kernel/fonts and the host-bound
GB renderer overlay (Phases 4–8).

| Offset | Size | Meaning |
| --- | --- | --- |
| 0 | 4 | ASCII `SGB1` |
| 4 | 1 | Protocol version 1 |
| 5 | 1 | Header size 32 |
| 6 | 2 | Reserved zero |
| 8 | 3 | SNES load address, 4 KiB aligned in bank `$7F` |
| 11 | 3 | Entry within the program bytes |
| 14 | 4 | Program byte length (nonzero) |
| 18 | 4 | Font byte length |
| 22 | 4 | Overlay length, 0 or one `$1D00`-byte container page |
| 26 | 2 | CRC of entire header+body, treating these two bytes as zero |
| 28 | 2 | Host OS header checksum bytes (`GBCOS.BIN[$14E:$150]`) |
| 30 | 1 | Overlay ABI 1 |
| 31 | 1 | Overlay kind 1: fixed renderer replacement |

Body = program, fonts, overlay. Program+fonts must fit bank `$7F`; exact length
must match the header. With no overlay, bytes 28–31 must all be zero. With an
overlay, the decoder requires the expected OS checksum and matching ABI/kind.
Binding metadata is covered by CRC too. The overlay container reserves one page
for code and its future Phase 4 entry directory; the resident replacement must
fit the audited renderer interval, not all `$1D00` bytes. Validate the entire
file before overwriting host code or launching the SNES program.
