# Super Game Boy fullscreen mode

Phases 1–6 and Phase 8 pass their software checks. The hello probe passed on
hardware, and the channel bench now completes on SGB1. Phase 7 fullscreen
integration and the complete EverDrive launch/return cycle remain unverified.
Phases 9–11 are pending.

## Architecture

The GB keeps files, PSRAM, text buffers, undo, lexing, wrapping, layout and UI
logic. The SNES draws the 256×224 display and reports input. It receives glyphs,
styles and pixel positions, without needing filesystem or editor state.
Fullscreen replaces the GB picture and border with 28 rows of SNES-rendered text.
The text area is 248 px wide. Fonts 1–6 start at x=1, leaving
the cursor in the preceding gap; font 0 retains x=0. Rows are
capped at 64 glyphs:
26 text rows with both bars. The five-row on-screen keyboard (OSK) floats
over the document in a centered 168×56 px bordered panel; text remains visible
on both sides. Opening it preserves all document rows and their scroll position.
Fonts and BGR555 colors come from the same assets as the GB/GBC UI.

The GB uploads SNES code/fonts using BIOS `DATA_TRN`, then issues `JUMP` (`$12`).
The uploaded program takes over the PPU, controller ports and ICD2. Subsequent
bulk data travels through LCD capture; replies use the four-player joypad
registers. BIOS packets are only needed during bootstrap.

| ICD2 register (SNES side) | Use |
| --- | --- |
| `$6000` read | Captured LCD row (bits 7–3) and write-buffer index (bits 1–0) |
| `$6001` write / `$7800` read | Select/read one of four 320-byte row buffers |
| `$6002` / `$7000–$700F` read | Packet-ready flag / last 16-byte GB packet |
| `$6003` write | GB reset/run, player count and clock divider |
| `$6004–$6007` write | Four joypad bytes carrying the SNES→GB mailbox |

Register behavior is exercised in Mesen; complete hardware transport validation
is still pending. See [Pan Docs](https://gbdev.io/pandocs/SGB_Command_System.html)
and [fullsnes](https://problemkaputt.de/fullsnes.htm) for hardware references.

### Game Boy frontend

SGB startup attempts fullscreen automatically after loading settings and restoring
the session, unless **SETTINGS → RESOLUTION** is 160x144. If takeover fails,
**SETTINGS → RESOLUTION → 256x224** remains available in BIOS mode to retry. Remove or rename `SGB.DAT` to boot in BIOS mode for test ROMs.
The current automatic-start build is OS `840F` / `SGB.DAT` `FD84`; startup, editing/saving,
timeout recovery and missing/corrupt/no-HELLO fallback checks pass in the client test.

`SGBBOOT.MOD` loads and validates `/GBCSYS/SGB.DAT`, backs up video, installs the
host-bound renderer overlay, uploads SNES code/fonts, issues JUMP and waits for
HELLO. Missing/corrupt data or startup HELLO timeout restores the renderer and
video. DMG/CGB startup keeps its normal path. The short-lived bootstrap is a
**module**; the renderer is a persistent **overlay**, which remains callable
while other modules borrow OS pages. See [OVERLAYS.md](OVERLAYS.md) and
[MODULES.md](MODULES.md) for their separate loading contracts.

| Source | Role |
| --- | --- |
| `src/sgb/commands.asm`, `packet.asm` | BIOS commands and packet transport, shared with probes |
| `modules/sgb_boot.c` | Bootstrap, BIOS upload and rollback |
| `src/sgb/client.c`, `client.asm` | Startup dispatch, resident state and UI helpers |
| `src/sgb/display.asm` | Independently linked terminal renderer, STAT-safe LCD writes, mailbox, VBlank status and palettes |
| `src/sgb/protocol.asm` | Canonical protocol constants |
| `src/editor/mouse.c` | Shared hit testing and editor/browser/menu mouse actions |

Render dispatch checks `SYS_INFO_SGBFS`; content/layout code remains shared.
Row hashes cover glyphs, attributes, font and selection. Dirty rows stream from
`tile_buffer`/`tile_attrs` to VRAM. Keyboard input enters the existing event queue; pad state uses the shared
DMG/CGB button handlers, including repeat and editor modifiers;
queue pressure defers publication rather than losing keys or reusing an
unacknowledged page. A runtime transport fault stops publication and preserves
the GB document. Automatic visual recovery after SNES takeover is unproven.

`GeometryGB` selects 18 rows, stride 40 and 160 px; `GeometryWide` selects 28 rows,
stride 64 and 248 text pixels. Row/attribute addresses use a shared 32-entry
offset table, including sentinels. Geometry changes require stopped rendering,
masked interrupts and rebuilt rows/layout. The normal OS and suspended-game
menu initialize GB geometry. Shared lexer/string buffers retain their addresses;
wide modules save/borrow the first 3072 bytes of WRAMX.

Menus store up to 19 fixed-stride lines in PSRAM sector `$3BA0`, staging one line
through `wide_scratch` and restoring the window mapping after access. Legacy
module title/status rows are translated to the active geometry; unused rows are
cleared. Raw tile graphics cannot be represented by v1 and show a GB-mode notice.
Fullscreen game launch is blocked pending Phase 10.

The BIOS fallback uses `src/sgb/sgb.asm` for detection, palettes and the border
from `EDITOR.DAT`. Border upload saves `$8800–$9FFF` in PSRAM `$3C00–$3C0B`, masks
interrupts during transfer, and restores tiles/maps/registers before unmasking.
`gbdk_DisplayOff` waits for VBlank before disabling the LCD.

### SNES kernel

`snes/kernel.c` implements protocol validation and the display model using cc65's
native 65816 8-bit accumulator/index ABI. `hardware.s` owns startup, ICD2 DMA,
mailbox, pad sampling and PPU writes; `raster.s` composes glyphs; `overlay.s`
draws UI layers. Code/fonts run in bank `$7F`; model state is in `$7E`.
`cache.s` retains unselected rows in `$7E:6000–9FFF` (slots 0–15) and
`$7F:C000–FFFF` (slots 16–31). The linker caps model storage below `$7E:6000`
and the uploaded image below `$7F:C000`, reserving both cache ranges. Stack,
ICD2 buffers and snapshot storage remain outside these ranges. `fixed.s` uses
`$7E:DC00–DFFF` for 128 composed-tile keys and `$7E:E000–EFFF` for their
4bpp data (5 KiB total), above the snapshot ending at `$D87F`.

`shared.s` is an experimental shared-map backend, built with
`SGB_SHARED_RENDER=1`. The standard 256×224 build keeps identity-mapped row
uploads: the shared backend reduces DMA but its code-row CPU cost is still
higher. Do not enable it by default until code redraw/scroll timing improves.
`SGB_SHARED_RENDER=1 make assemble` packages the experimental backend; omit
the flag for the standard build.

In shared builds, completed tiles are published through a shared BG1 map. A 128-entry
WRAM lookup compares all 32 bitmap bytes; hash collisions only reduce reuse.
Reference counts pin every mapped tile. Released IDs can be reused only for
new tiles committed with their map during VBlank. Even 1,024 distinct mapped
tiles fit, so code and proportional/italic Markdown keep identical pixels.
Blank paper shares a canonical tile, and unchanged blank rows need no upload.

Shared metadata and fixed-font VRAM IDs occupy `$7E:A000–B67F`; the software
stack retains `$B680–BFFF`. Lookup bitmaps use `$7E:F000–FFFF`. Fixed code rows
build map references while composing each tile, using the already-validated
character/style key. Existing VRAM tiles skip raster copies, and only new glyph tiles are composed.
Key replacements and slot ownership invalidate old IDs. Direct code rows do
not populate the unselected raster cache; selection rebuilds one full raster
when needed. Other rows retain that cache. UI layers are unchanged.

Fixed-width styled rows with four-pixel cells compose directly into tile planes,
reusing tiles keyed by three neighboring character/style pairs. Three fragments
are needed because of the one-pixel text inset. Spaces share a blank key;
complete keys are checked after hashing. Normal/bold bitmaps must fit their
cells (the build checks this). `plain.s` packs ordinary text directly into
planes 0/1 across all seven fonts, including proportional widths and overlapping
normal glyphs. Both direct compositors clear only the 1 KiB tile buffer, leaving
shade scratch untouched. Icons, right-aligned clocks and unsupported text styles
fall back before changing the output. Standard paths retain unselected row
rasters; shared code uses map references until selection needs a bitmap.

Capture drains up to four completed ICD2 buffers between bounded work slices.
A separate 1920-byte snapshot protects validation from concurrent capture.
The whole command stream is validated before any model changes. Mailbox
backpressure, sequence ordering and duplicate suppression protect transactions.

BG1 uses a 32-row ring. Text/style changes rasterize and refresh its tile cache;
selection changes restore cached tiles and recolor their bitplanes. Cache slots
follow physical rows during scrolling; revealed rows and fixed bars invalidate
the affected slots. Scrolling waits for DMA and the smooth flag requests 2 px
steps. Glyph overhangs are ORed; selection uses pixel boundaries. BG3 draws bars, boxes, dialogs and OSK over a high-priority
BG2 paper mask. Closing a menu restores the underlying text without BG1 redraw.
Uploads use VBlank. Shared graphics always get a fresh blank; map-only commits
may reuse the current blank after checking the latched scanline. An OBJ draws the text cursor; full mouse
and pad behavior remains Phase 9. L+R+Select toggles capture/page diagnostics.

| SNES VRAM byte range | Use |
| --- | --- |
| `$0000–$7FFF` | BG1 4bpp rows, or 1,024 shared tiles in experimental builds |
| `$8000–$BFFF` | BG3 2bpp UI tiles |
| `$C000–$C7FF` | OBJ tiles |
| `$C800–$C9FF` | BG2 clipped paper-mask tiles |
| `$E000` / `$E800` / `$F000` | BG1 / BG3 / BG2 maps |
| `$0000–$1FFF`, `$2000–$2FFF` | In map mode: the map's 256 tiles (4bpp) and BG1's 64x32 map, over the text rows' |
| `$0000–$5FFF`, `$6000–$7FFF` | 512x448 map mode: 383 tile pairs (pair 0 blank) and BG1's 64x64 map of pairs |

Palette roles are paper/highlight/dim/ink at 0–3, syntax accents at 4–7, and
selected variants at 8–15. Accent ink becomes normal ink when selected, matching
the GBC style rules. The GB owns OSK content, shift/symbol state and actions;
SNES keyboard input queues logical keys; gamepad state goes to the shared
editor/menu input handlers.

## Wire protocol v1

Constants live in `src/sgb/protocol.asm`. `make sgb-protocol` generates the C,
ca65 and C++ headers; `make test-sgb-protocol` checks freshness, all language
consumers, codecs and malformed inputs. `scripts/sgb_protocol.py` is the strict
reference codec. The Phase 0b benchmark uses a separate additive-checksum format;
the BIOS mouse bridge is also separate from this protocol.

### LCD map and page publication

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

### Command framing

Each command is `[opcode:u8][payload_length:u16][payload]`. The IDs below follow
the `SGBFS_CMD_*` constants; unknown opcodes, invalid lengths/ranges and unknown
flag bits reject the **whole page**. No partial display changes or ACK occur.
Version/profile mismatch requires a new handshake, not guessing at a schema.

Rows are 0–27, fonts use the existing GB IDs 0–6, and strings are counted GB glyph
bytes (including UI glyphs), never NUL terminated or UTF-8. Counts are at most
64. Screen x is 0–255. Selection/cursor coordinates start at x=0; fonts 1–6
have a one-pixel glyph inset and occupy up to 248 px.

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
| MAP | `mode`: 0 the text, 1 a module's map under the bars, 2 the map full screen; `\| $10` (`SGBFS_MAP_HIRES`) for 512x448 |
| MAP_TILES | `first, count` (1–64, `first + count <= 256`), then `count` GB 2bpp tiles of 16 bytes |
| MAP_COLORS | `first` palette, `count` (`first + count <= 8`), then `BGR555:u16[count * 4]`, bit 15 clear |
| MAP_CELLS | `x` (0–127), `y` (0–63), `vertical` (0/1), `n` (1–128), then `(tile, palette 0–7)[n]`, wrapping in the map (256x224 keeps `x & 63`, `y & 31`) |
| MAP_SCROLL | `x:u16` (0–1023), `y:u16` (0–511): the map's top left pixel (256x224 keeps `x & 511`, `y & 255`) |
| CODE | `last` (0/1), `offset:u16`, then 1–1024 bytes of the kernel extension (within `$2400`); ignored with a map open or in TEXT 1 |
| TEXT | `mode`: 0 the 256x224 raster text, 1 512x448 character tiles (needs the extension, no map open) |
| SCROLLBAR | `top, lines, thumb`: the view's scroll bar in 256x224 lines (either text mode), `lines` 0 for none, else `top + lines <= 224` and the thumb's 5 lines within the track; drawn at the right edge only while the kernel's mouse pointer shows (`snes/mouse.s`) |
| EXIT | no body, alone in its page, only if HELLO offered `SGBFS_FEATURE_BIOS` (8) and the extension is loaded: back to the BIOS (see "Returning to the BIOS: EXIT") |

ROW flag bit 0 means styled text; other bits are zero. An attribute contains
width 1–15 in its low nibble and the existing `STYLE_*` 0–14 in its high nibble.
RLE counts are 1–255 and must expand to exactly n attributes; zero runs,
overrun/underrun and odd encodings are invalid. Sum of widths must be ≤248 px.
Selection is in text-relative pixels: start 0–248, end start–248, or end `$FF`
for the right edge. Equal start/end means no selection. The reference encoder
coalesces adjacent identical attributes; equivalent noncanonical runs decode.

LAYOUT bars is bit 0 top / bit 1 bottom; OSK rows is 0 or 5. Text rows must be
nonempty and `top + text_rows + bottom_bar <= 28`. OSK rows describe its five
key rows; its panel overlays the bottom seven screen rows above the footer.
BOX width is at
least 8 px, its right edge cannot exceed 256, and its rows must fit the screen.
Stateful constraints (BOX_LINE within the open box, SCROLL within the text ring,
OSK layer contents) are checked by the receiver model.
ROW_SAME copies the model row, not a VRAM address. BOX/BAR/OSK do not erase the
underlying SNES text model.

### 512x448 character text (TEXT 1)

TEXT 1 switches the text to character tiles (`snes/char.s`, in the kernel extension): mode 5
with interlace, 64 columns × 56 rows, each character an 8×8 hi-res cell from the mono font.
Nothing is drawn: a row is map entries. Mode 5 shows an entry's tiles N and N+1 side by side,
so BG1 holds the even columns and BG2 the odd ones (scrolled 8 pixels), each glyph tile
followed by a blank one the other layer shows through. A glyph tile has the glyph in plane 0
on paper in plane 1, so the entry's palette gives the cell its paper and ink. There are 8
colour classes (text, dim, keyword, string, number, label, selected, inverse): BG2's palette q
is class q, and BG1 uses palettes 0 and 1 for classes 0 and 4 (the same CGRAM words as BG2's
palettes 0 and 4) and 2–7 for the rest, so one tile set a layer does.

In TEXT 1:
- rows, ROW_SAME, LAYOUT, CURSOR and a box's rows go to 56, SCROLL to ±55; BOX_LINE stays
  under 28 lines;
- a row is a character a column, its widths ignored; ROW's selection is in columns (0–64,
  end `$FF` to the right edge); the 127 marker in an unstyled row puts the rest against
  column 63;
- the cursor's x and a box's x and width stay 256x224 pixels, 4 a column;
- the bars, a box and the OSK are composed into the same cells: bars and the selection in
  the selected class, a box and the OSK framed by box-drawing tiles (a frame line fills the
  spaces of the first and last lines), BUSY the top right cell and PROGRESS the footer's
  first cells in the inverse class;
- the cursor is OBJ tile 1, 4 lines tall (8 hi-res lines).

VRAM: BG1's tiles at word `$0000`, BG2's at `$3000`, the two 32×64 maps at `$4400` and
`$4C00` (to byte `$A7FF`): the raster ring's and BG3's tiles in 256x224, which come back
when TEXT 0 draws every row again. WRAM: the 56 rows at `$7E:6000`, the maps as written at
`$8000` and `$9000` (the row cache's). Rows waiting are composed together and sent up to 8
map rows a VBlank, each only while the VBlank lasts; a SCROLL moves the ring (64 rows) and
sets the new vertical scroll after the last.

Each TEXT switch clears the rows (the GB sends them again), the box and the scroll. A map
opens only in TEXT 0: the map's overlay is 28 rows'. From a CODE to the TEXT or MAP that
uses it, raster text rows wait: drawing one would rebuild the 4 px cache over the extension.
The GB sends TEXT 1 when SETTINGS > RESOLUTION is 512x448, whatever the font (at boot, or
from those menus: `SGBCells`), with the extension just before it, and lays its text out in 56
rows of 4-pixel columns (notes/SGB_HIRES_TEXT.md). A map drops it to TEXT 0 and 28 rows while
the map is open (`_SGBCellsMap` from `FsBackground`).
`tests/run_sgb_text_kernel.sh` replays pages made by `tests/sgb/text_replay.py` on the real
kernel in Mesen and checks each 512x448 picture against a reference drawn from the same
model, pixel for pixel, then TEXT 0 against the raster text before it.

### A module's map (MAPVIEW)

The MAP commands give BG1 to a module's background: `MAPVIEW.MOD` shows a Beisbol `.gbmap`
there. In map mode the kernel's extension (`snes/map.s`, see SGB.DAT container) points BG1 at a 64x32 map at VRAM byte `$2000`
(cleared on entry) with the 256 map tiles at `$0000`: each GB 2bpp tile becomes 4bpp with
plane 2 set, so its pixels are 4–7 and never transparent, and GB palette `p` is CGRAM
`p*16+4…7` (palette 0 lands on the syntax accents, which the map view doesn't use; they come
back when it ends). BG2/BG3 still draw the bars, boxes and the OSK over it; mode 2 hides the
bars. Text rows aren't drawn meanwhile (the model keeps them); MAP 0 points BG1 back at
`$E000`, restores its scroll, marks every row dirty and the palette, so the text comes back
whole. MAP_SCROLL sets a target the scroll glides to, half the remaining way each SNES
frame: a page's few pixels of movement show smoothly, lagging under 12 pixels, inside the 3
rows the 32-row map keeps past the 29 in view.

**512x448** (`SGBFS_MAP_HIRES`, MAPVIEW's Hi-res): BG mode 5 with interlace, a GB pixel a hi-res
one, 64x56 GB tiles on screen. Mode 5 draws a map entry's tiles N and N+1 side by side, so each of
BG1's 64x64 entries (VRAM word `$3000`) is a pair of GB cells, and the GB's 128x64 cells map onto
it by column pairs. The kernel keeps the GB's cells (`$7F:C000`, the row cache's), its 256 2bpp
tiles and a cache of pairs (`$7E:6000–9FFF`, the row cache's too: leaving, the cache is emptied
and every text row drawn again): a pair is found by hashing its two cells (128 chains), counted
by the entries using it, and reused (the next one no entry uses) once none do; 383 fit (tiles
2–767), past that an entry gets the blank pair 0. Its two cells may have different palettes:
CGRAM palettes 1–7 each hold three GB palettes (slots 1–3, colours 4–15), given out as pairs need
them (one no pair uses is emptied when none has room), and a pair's tiles take its palette's
slots in planes 2–3. Composed pairs (16) and entry writes (64) go out together in a VBlank.
HDMA (channels 6 and 7: BGMODE and TM) switches the rows with the bars, a box or the OSK
(`PresentOverlay` records them) to mode 1 with BG2/BG3 and no BG1, so the text UI is drawn
as always and the map is hidden across those rows. Horizontal scroll in mode 5 counts 2
pixels, so the map moves 2 at a time sideways; vertical scroll is per line of 448. Interlace
flickers on 1-pixel horizontal lines (CRT; upscalers vary). Untried on hardware; the first
5A22 revision can crash when general DMA (the ICD2 capture) meets HDMA.

On the GB the module never touches VRAM in fullscreen (it's the transport). `ModBackground`
jumps to the overlay's `FsBackground` (entry 9): modes 0–2 send MAP and MAP_SCROLL (`| $10`
512x448; bits 6–7 of the mode are x's 256s, bit 5 y's) and flush; 4 starts a row or column of
cells (33 or 29, the 256x224 view's; 65 or 57 at 512x448), 5 adds one, 6 sends the PSRAM
window's 32 tiles, 7 the 8 palettes. Those are added to the page, whole (flushed first if one
can't fit), and go with the next mode 0–2 call, which the module makes before anything else
draws (`FsDraw` starts a page). A map's commands can't wait for a full key queue, so
`FsMapReady` empties it. Each pass of the view waits for its page's ACK, so the view counts the
frames it took (up to 16) and skips `ModFrame`'s idle page while it moves. Tests:
`tests/run_sgb_map.sh` (the frontend and Gearboy's protocol model: every cell checked, at both
sizes) and `tests/run_sgb_map_kernel.sh` (its recorded pages on the real kernel in Mesen: the
map pixel for pixel at 256x224 and, sampled, at 512x448, the rows its menu turns to mode 1, the
text after it).

### Mailbox and input acknowledgement

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
| PAD (`$09`) | Held GB pad bits | Newly pressed bits (subset of A) |
| MOUSE_DOWN / MOUSE_DRAG / MOUSE_UP / MOUSE_MOVE | `(buttons << 6) \| screen_row` | Screen pixel x |
| HELLO | Protocol version | Color=1, mouse=2, pad 2=4, BIOS (EXIT)=8 |
| ACK | Page 0=A / 1=B | Applied page sequence, 1–255 |
| LAUNCH_READY | Mode 1 RESET_REQUIRED | 0 |
| DIAG_GOOD…DIAG_BIOS (`$20–$29`) | Low byte | High byte of counter/time |

Diagnostic IDs are GOOD, BAD, MISS, ROWS, DRAW, UI, PAGE, MAIL, FRAME, BIOS in order
(BIOS: the SGB BIOS ROM's header checksum, `$00:FFDE`; `scripts/sgb_log.py` names the known ones).
They are optional, queued behind input/control, and use the ordinary event echo.

Mouse buttons are left=1/right=2 and represent the state **after** the event.
DOWN/DRAG require a held button; MOVE is hover with no buttons. UP may leave
another button held. Motion is needed for GB menu hover even though SNES draws
the pointer itself. The row is the screen's: 0–27, or 0–55 in TEXT 1 (y / 4); x is in 256x224
pixels in both.

The SNES holds an event until the GB echoes its sequence in a CRC-valid status
record. The GB processes a duplicate only once, but continues echoing its ACK.
The kernel republishes the unchanged held event once per observed SNES frame;
losing a commit must not strand later page ACKs behind it.
Do not overwrite an unacknowledged mailbox even for a page ACK. Queue up to 64
events; reserve three entries for two page ACKs and launch completion. Coalesce
motion within the same button state; preserve press/release and key edges.
Page ACK/control events have priority. On reset, discard the old event queue,
exchange HELLO, and restart event/page sequence spaces. Complete physical button
mapping and repeat remain Phase 9 work.

### Status record

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
A timeout pauses publication without resetting the GB or discarding the page or
unsaved text. A matching late ACK clears the timeout; other ACKs cannot release
the pending page. This recovery passes emulation; hardware confirmation is pending.

### Launch policy

V1 selects `RESET_REQUIRED`: after loading, the SNES sends LAUNCH_READY and waits
for its status echo. The GB then uses the existing EverDrive arm/handoff, and
the SNES displays a reset instruction until the user resets the console. That
allows a fresh BIOS/GB handshake. The complete armed-cart cycle still requires
Phase 10 hardware validation.

The Phase 0c probe proves a **non-destructive** JUMP can return via a bank-0 RTS
while preserving the BIOS stack/registers/PPU (it returned with I set and got lucky:
the BIOS's loop needs its IRQs, see EXIT). FatPak's own launch from fullscreen now
goes through EXIT first ("Returning to the BIOS: EXIT") and then launches as in BIOS
mode; LAUNCH and RESET_REQUIRED remain unused.

### Returning to the BIOS: EXIT (2026-11-20)

SETTINGS > RESOLUTION > 160x144 in fullscreen, and a game's launch from it, hand the
SNES back to the BIOS with the GB still running: its 160x144 picture, border, menu and
command loop as they were at JUMP. Only for a BIOS whose header checksum is known:
SGB1 1.2 (`$F632`), SGB1 1.1 (`$BF92`) and SGB2 (`$7DD5`); on any other the kernel
doesn't offer it and 160x144 waits for the next boot, a game for a reset, as before.

Revisions (2026-11-21): 1.1 differs from 1.2 in 105 bytes (1.2 adds a routine at
`$00:CCC7` copying 81 bytes from `$07:F400` to WRAM `$0810`, and its header); SGB2's
first 256 KiB differ in about 2,000 bytes of in-place patches, its new code in the
upper 256 KiB (`$88:C4A0` wraps 1.2's `$6003 = $01` reset, `$88:C3D7` reads the pad at
power-on). All three have the same JUMP handler, RTS at `$00:AC88`, NMI handler at
`$00:B50A` and samples-plus-server bytes (`$06:A999` on), and Mesen's register
state after EXIT matches JUMP's on each with the one Regs table. SGB1 1.0 (header
checksum `$BAD3`, 2026-11-24) has the same samples and registers but its bank 0 code
from about `$AC00` is 3 bytes on: its JUMP handler's `JML [$00B8]` at `$00:C72F`, NMI
handler at `$00:B50D` (BIOS_NMI_10). EXIT returns through an RTS at `$00:80B8`,
which every revision has there. `tests/run_sgb_bios_return.sh` runs every dump in
`~/Desktop/sgb` (`SGB_DUMPS`; named as ISSOtm's SGB disassembly expects: `sgb1v2.sfc`
required, `sgb1v0.sfc`, `sgb1v1.sfc`, `sgb2.sfc`; SGB2 runs with Mesen's `UseSgb2`)
and also compares Mesen's PPU and CPU register state with JUMP's, less counters and
latches.

**At JUMP** (`snes/bios.s` BiosSave, first thing in Boot, on the BIOS's stack with its
registers pushed there): forced blank; the sound driver to the IPL ROM (`$00`, then
`$FE` on port 0 once it has seen a change: its `$FF`, SOU_TRN's, is the driver's own
loader, which returns to the driver); a 160-byte SPC700 transfer server through the
IPL at ARAM `$EE40`; then the snapshot into ARAM from `$4DB0`, over the driver's
samples (at JUMP ARAM is exactly the BIOS ROM's two upload streams). The snapshot, in
groups of 3 bytes a port handshake (the server echoes before storing, so the SNES
prepares the next group meanwhile): VRAM `$0000–1FFF` (border tiles), `$7000–7FFF`
(BG1 and border maps), `$8000–9FFF` (sprites), `$C000–DFFF` (BG1, the menu's tiles),
`$F800–FFFF` (the GB screen's map), CGRAM, OAM, all DMA'd through `$7E:6000`; WRAM
`$0000–00FF`, `$1000–11FF`, `$1F00–1FFF`, `$5000–53FF`, `$C000–C0FF`, `$CB00–CCFF`
(what the kernel overwrites of the BIOS's measured live state, with margins; a link
check keeps the kernel's BSS below `$5400`). About 36 KB, 74 SNES frames (1.2 s);
the server then waits, the DSP muted. HELLO offers `SGBFS_FEATURE_BIOS`.

**EXIT** (alone in its page; the extension loaded, as the return code is the
extension's for want of image space): the kernel ACKs the page, waits for the echo,
then the extension's FarBiosReturn: VRAM cleared, the snapshot read back (DMA'd to the
PPU, WRAM in place), the samples rewritten from the BIOS ROM (`$06:A999` on), the
server's area through the IPL, the driver restarted at `$0400`, the BIOS's NMI
pointer (`$00BB` = `$00B50A`, 1.0's `$00B50D`) and registers (Mesen's values at JUMP: mode 1, BG and OBJ
bases, TM `$17`, CGWSEL `$02`, COLDATA, H/V IRQ at 64/223, FastROM, `$4200 = $31`),
`$6003 = $81` (one player), INIDISP last; then its registers pulled, I cleared (its
JUMP handler at `$C738` sets it just before jumping; the loop waits on IRQs), and
RTS through `$00:80B8`. 119 SNES frames (2 s). `tests/run_sgb_bios_return.sh`
replays a 512x448 session and EXIT in Mesen on the real BIOS: VRAM, CGRAM, OAM, the
saved WRAM, ARAM (driver and samples) and the NMI pointer equal JUMP's, the border
pixel for pixel, the GB sees one player and unfreezes it, L+R opens the menu.

**The GB** (`src/sgb/client.c` SGBLeave): the overlay's FsExit (the extension, then
EXIT alone, its ACK); SGBBOOT.MOD's exit mode (`module_context` set): waits until the
joypad ID stops cycling players (the BIOS's one; up to 10 s), restores the GB
renderer (OverlayRestore), clears `SYS_INFO_SGBFS`, MASK_EN 0; then GeometryGB, the
map rows and ring reset, EditorSetup (the display as at boot), Layout, the keyboard
driver again as at boot (`SGBLeave(1)`: `KeyboardSetup`, the SGB's driver and its BIOS bridge for
PS/2). Choosing 256x224 or 512x448 then JUMPs again. LaunchGame leaves fullscreen this way first
(`SGBLeave(0)`: no driver load, as the launch would stop its bridge at once) and launches as from
160x144 (the setting stays, so FatPak comes back to fullscreen after the game). The bridge is only
stopped where it runs (`SYS_INFO_BRIDGE`, sys_info bit 3, set once keydriver.c's upload is in, cleared
by its stop in `KBDriverStop` and SGBBOOT): its stop jumps into the bridge's code at `$1803`, which
after EXIT is the kernel's leftovers (2026-11-26: a build's RUN from fullscreen froze the picture
on hardware while loading, the SNES crashed by that jump).
`tests/run_sgb_text.sh` covers EXIT, fullscreen again from the BIOS and a game's
launch from fullscreen (Gearboy's host offers EXIT and drops to its own SGB).

Space: the kernel image is full (about 70 of 49,152 bytes left; new code has to go to the
extension or the resident part); the GB's FIXED bank has 28 bytes, WRAM0 none, the OS pages 98–99%.

Still to do: hardware confirmation (timing of the driver's `$FE`, the IPL, VRAM reads
by DMA); SGB1 1.0 (no dump yet; 1.1 and SGB2 are done, see "Revisions"); commands that keep state the snapshot doesn't hold (the
BIOS's WRAM outside the saved ranges is lost: PAL_TRN/ATTR_TRN data, a custom border
sent by a game before FatPak).

Probes behind it: `tests/sgb/biosram.lua` (on the handoff probe:
`SGB_TEST_SCRIPT=$PWD/tests/sgb/biosram.lua bash tests/sgb/run.sh handoff`) measures
the BIOS's live WRAM after a return and checks it resumes with the kernel's footprint
overwritten (`BIOSRAM_CLOBBER=1`; `BIOSRAM_VIDEO=0` shows it never rebuilds its
video; `BIOSRAM_MENU=1` opens its menu). A soft reset (`tests/sgb/reset.s`,
`python3 tests/sgb/build.py reset`, `bash tests/sgb/run.sh reset`; still failing)
gets the driver to the IPL but the BIOS never releases the GB from reset: with WRAM
untouched it takes its warm path (`$81FE`'s signatures at `$7E:1700`, `$66FC`,
`$7EFC`), zeroed its cold one but the ICD2 row (`$6000`, read at `$B9BE`) keeps the
GB's last line, so the intro step that releases it (`$B88F`) never runs.

### Colours at 160x144 (2026-11-26)

In the BIOS's 160x144 the SGB colours the GB's 4 shades with 4 palettes, colour 0 shared, and a palette per
8x8 screen cell (20x18). `SGBThemePalettes` (`src/ui/theme.asm`, ThemeApply) sends PAL01 and PAL23: palette 0 the
text's, 1-3 the theme's palettes the most looks use among those with its paper; the others draw in palette 0,
their accent ink as ink (`sgb_pal_map`). The GB renderer records each block's tiles' palettes as GBC's map
attributes have them (`SGBRecordRow`, `src/ui/render.asm`; accents get colour 1 as on GBC), 2 bits a tile in
`sgb_attr_rows` (WRAMX, in the editor's buffers). `SGBAttrFlush` (`src/sgb/attributes.asm`, each WaitFrame)
lays them out as the screen shows them (`_render_row_blocks`), hashes each pair of rows and sends one pair that
changed since it was sent: a single-packet ATTR_CHR, at most every 2 frames, so a scroll's colours settle within
18 frames. While a module has the BG map, `sgb_attr_rows` are the screen's rows and the module's: MAPVIEW.MOD
sends its map's palettes 0-3 (`ModBackground` mode 8: PAL01 and PAL23) and each cell's palette as the view
crosses a tile (mode 9), at most every 4 frames while it moves; `BackgroundText` applies the theme again.

The BIOS's pace (`tests/run_sgb_attr.sh`, Mesen on SGB1 1.0, 1.1, 1.2 and SGB2): it takes a packet a SNES frame,
and the SGB's GB frame is 2.4% shorter, so packets back to back are lost (the 6 of one ATTR_CHR), a GB frame
apart within a command arrive, and two commands a GB frame apart sometimes don't (both in one SNES frame); 9
single-packet commands 2 frames apart always do. A packet in the same SNES frame as another replaces it, and the
SNES mouse driver's ACK (DATA_SND at 160x144) must never be the one lost (the bridge would wait for it for good):
the ACK goes through `SGBPacketAck`, which waits until 2 frames after the last attribute packet, and
attribute packets wait 2 frames after an ACK (`sgb_packet_frame`, HRAM).

`sgb_SetPal` used to write its packet's last 0 through the source palette's pointer: every SGB ThemeApply zeroed the
low byte of the next theme palette's paper (palette 1's), which the swap file kept.

### SGB.DAT container

The reference codec packs/validates this format. The normal build now emits
`bin/SGB.DAT` containing the production SNES kernel/fonts and the host-bound
GB renderer overlay (Phases 4–8).

| Offset | Size | Meaning |
| --- | --- | --- |
| 0 | 4 | ASCII `SGB1` |
| 4 | 1 | Protocol version 1 |
| 5 | 1 | Header size 32 |
| 6 | 2 | Kernel extension length, 0–`$2400` (only with an overlay) |
| 8 | 3 | SNES load address, 4 KiB aligned in bank `$7F` |
| 11 | 3 | Entry within the program bytes |
| 14 | 4 | Program byte length (nonzero) |
| 18 | 4 | Font byte length |
| 22 | 4 | Overlay length, 0 or one `$1D00`-byte container page |
| 26 | 2 | CRC of entire header+body, treating these two bytes as zero |
| 28 | 2 | Host OS header checksum bytes (`GBCOS.BIN[$14E:$150]`) |
| 30 | 1 | Overlay ABI 1 |
| 31 | 1 | Overlay kind 1: fixed renderer replacement |

Body = program, fonts, overlay, extension. Program+fonts must fit bank `$7F`; exact length
must match the header. With no overlay, bytes 28–31 must all be zero. With an
overlay, the decoder requires the expected OS checksum and matching ABI/kind.
Binding metadata is covered by CRC too. The overlay container reserves one page;
the resident replacement must fit the audited renderer interval, not all `$1D00`
bytes. Validate the entire file before overwriting host code or launching the
SNES program.

**The kernel extension** is code linked with the kernel (`snes/kernel.cfg`'s `EXT` area, its own
file `build/sgb/ext.bin`) that runs at `$7E:DC00–FFFF` (`$EFFF` in shared-render builds): the
4 px fixed cache's WRAM, which only text rows use. It isn't uploaded at boot; the GB overlay
sends it in CODE commands (offset, up to 1 KiB each, the last flagged) whenever a map starts
from the text (`FsSendExt`). It reads it from SGB.DAT's PSRAM copy, past the overlay page that
`overlay_request` still points into, because the SGB log reuses the file's first blocks and its
header. The extension's first word is its own length for the same reason. The kernel
(`snes/ext.s`) calls it through stubs (`jsl $7E:…`, the extension's `Far*` entries `jsr` then
`rtl`) and it calls back through `Far*` trampolines in bank `$7F`; its BSS stays in the
kernel's. A CODE command clears `fixed_ready`, and the last one sets `ext_ready`. The fixed
cache's rebuild clears `ext_ready`, and MAP stays on the text without it. It holds the map
engine (`snes/map.s`, 2 KiB) and 512×448 character text (`snes/char.s`, 2.2 KiB): 4,277 bytes.

## Memory budget

`make sgb-budget` reads the table below, checks it against `build/main.map`, and
writes `build/sgb/budget.json`. Build the OS first if the map is absent. The
WRAM0 render-union entries are feasibility caps; the shared `Render Vars`
section actually occupies 241 bytes, with 14-byte `Geometry Vars` separate.
Fullscreen transport uses HRAM rather than allocating that provisional union.

<!-- sgb-budget:start -->
| Region | Item | Bytes | Basis |
| --- | --- | ---: | --- |
| WRAMX | characters | 1792 | 28 rows * 64 bytes |
| WRAMX | attributes | 1792 | 28 rows * 64 bytes |
| WRAMX | lexer row states | 58 | 29 boundaries * 2 bytes |
| WRAMX | row offsets | 64 | 32 * 2 including range sentinels; both bases use these |
| WRAMX | row hashes | 56 | 28 * 2 |
| WRAMX | PSRAM staging | 32 | wide_scratch; runtime copy chunk limit |
| WRAMX | union padding | 8 | common row states begin at DEA0 in either layout |
| WRAMX | lexer scratch | 100 | tb_state through tb_check_state inclusive |
| WRAMX | string buffer | 64 | preserved |
| WRAMX | name buffer | 16 | preserved |
| WRAMX | localized string slots | 48 | preserved |
| WRAMX | mouse state | 18 | preserved budget; fullscreen replacement must fit |
| WRAMX | palette scratch | 8 | preserved |
| WRAMX | module state | 5 | preserved |
| WRAMX | overlay loader state | 21 | request, saved interval/CRC, entry, live flag |
| WRAM0_RENDER_UNION | fullscreen render state | 160 | budget cap including 28-row metadata and selection; Geometry Vars stays separate |
| WRAM0_RENDER_UNION | control queue | 64 | protocol constant |
| WRAM0_RENDER_UNION | transport state | 16 | provisional feasibility cap; actual transport uses HRAM |
| HRAM | fullscreen transport | 67 | Phase 8 actual allocation; includes UI caches and progress state |
<!-- sgb-budget:end -->

The Phase 8 link leaves 1 WRAM0 byte, 14 WRAMX bytes, 33 HRAM bytes, 49 ROM0
bytes and 7 fixed-bank-1 bytes free. New state must reuse storage or change
placement. GB-only renderer caches share a WRAMX union with wide rows; PSRAM
operations honor the 32-byte staging limit.

The fixed renderer overlay occupies `$4000–$5244` (4677 bytes); retain shared
font metrics and dispatch contracts. Page 13 cannot hold a persistent renderer
because modules borrow it and still need drawing services. PSRAM `$3B00–$3B8F`
stages `SGB.DAT` (72 KiB), `$3B90–$3B9F` holds the original renderer, and `$3BA0`
holds menu lines. The added-text cap is `$6E0000`, keeping these allocations below
snapshot staging at `$3C00` and the unsafe `$3E00` region.

Hello proved execution at `$7F0000` on hardware. The bench additionally audits
`$7F1000–$7FFFFF` with a position-dependent pattern; `RAM AUDIT=0000` passes in
Mesen. This does not prove hardware coverage beyond hello or preservation of
BIOS WRAM. The current allocation assumes manual reset for launch.

## Controls

Gamepad in port 1, mouse in port 2. PAD events report held/pressed GB button
bits, including short presses latched while drawing. The GB uses the same
`PadKey`/`MenuKey` handlers as DMG/CGB, so context, repeat and modifiers agree.

| Button | Editor, keyboard hidden | Keyboard open |
| --- | --- | --- |
| D-pad | Move cursor | Move key highlight |
| B + D-pad | Page up/down, line start/end | Move key highlight |
| A + D-pad | Select text | Move key highlight |
| A | No text insertion | Press highlighted key |
| B | Navigation modifier; never delete | Backspace |
| Select | Open keyboard | Close keyboard |
| Start | Open menu | Open menu |

Menus/browser retain their shared A=accept, B=back, Start=menu/close and
Select=info behavior. L/R/X/Y bindings are deferred. L+R+Select still toggles
diagnostics. The centered keyboard uses BG3 over the BG2 paper mask; BG1 keeps
the full document. Its bounds are x=44–211, first key x=52; dialogs retain the
GB renderer's four-pixel text inset inside their border.

### Resolution roadmap

Fullscreen will toggle header/footer visibility on every platform. SGB alone
will expose a separate Resolution list: 160×144, 256×224, 512×224, 512×448.
Resolution and header/footer visibility are independent; persist both choices.
Do not expose unsupported modes as selectable options.

1. Share completed tiles in the existing 256×224 renderer, preserving code,
   Markdown, selection, scrolling and overlays. Measure CPU and DMA separately.
2. Build a standalone Mode 5 font/UI probe with 512×224 and 512×448 interlace.
   Compare code fonts, proportions and flicker on the TV, including widescreen.
3. Mode 5 needs a pool of 16×8 tile pairs, not independent 8×8 IDs. Combine UI
   text and opaque paper into one of its two BGs, preserving shades/transparency.
   Keep document scrolling independent of bars, dialogs and keyboard.
4. Extend negotiated geometry and horizontal coordinates beyond 255. More text
   needs new GB row storage/streaming: 128×56 character/style bytes total 14 KiB,
   versus the current 3.5 KiB. Preserve efficient code editing and define tile
   pool exhaustion behavior for the larger map before enabling it.
5. Done (2026-11-20): SETTINGS > RESOLUTION, saved, listing only what works where it's opened
   (BIOS mode: 160×144, 256×224; fullscreen: 256×224; the map viewer: 512×448 too). Still to do:
   returning from fullscreen to 160×144 at run time: done (2026-11-20) for SGB1 1.2, and
   (2026-11-21) 1.1 and SGB2, see "Returning to the BIOS: EXIT"; SGB1 1.0 still waits
   for the next boot.

Text at 512×448 (128×56): design and open decisions in [SGB_HIRES_TEXT.md](SGB_HIRES_TEXT.md).

The shared-tile work keeps the current resolution and menu behavior unchanged;
the high-resolution modes remain future work.

**Mouse:** left click places the cursor, chooses menu items, browser rows (double
click opens) and OSK keys. Left drag selects, and dragging past the top or bottom
edge auto-scrolls. Right click opens the menu at the pointer (a context menu with
cut/copy/paste comes later). Sensitivity cycles with right+left click on the top
bar (the mouse's 3 hardware speeds). The view's scroll bar: the SCROLLBAR command
(notes/KEYBOARD.md).

PS/2 requires the SGB2 link port.

**SNES mouse in fullscreen** (port 2; the SGB's driver, SGBMOUSE.DRV, with the PS/2 keyboard: SETTINGS > KEYBOARD > PS/2 on an SGB).
The kernel reads it (`snes/mouse.s`, the resident part): `Capture` samples the pads (not before line
229: at VBlank's very start automatic reading may not have begun, its busy bit still clear) and calls
MouseRead, which reads once per NMI frame (Capture's pad sample can come twice a frame, and a second
clocking of `$4017` gives all 1s), checks the signature in JOY2, clocks the
16 motion bits, moves a 256x224 pointer and appends DOWN/UP on button changes and DRAG/MOVE on motion
(merged into a tail event of the same kind and buttons) to the input queue. PresentCursor draws the
arrow as OAM entry 1 (OBJ tile 2 at VRAM word `$6020`, OBJ palette 2: black outline, white; rewritten
each time, as modes rewrite VRAM). On the GB the overlay turns each mouse event into a report shaped
like the BIOS bridge's (`fs_mouse`: commit with buttons and an activity count, x, row × 8 or × 4 in
TEXT 1), which the SNES mouse driver reads in fullscreen instead of P1 (no bridge ACK, no GB pointer
sprite: VRAM is the transport's); `MouseRow` gives the shared mouse code its rows in both geometries.
SGBBOOT stops only the BIOS bridge at JUMP (its stop packets, if `SYS_INFO_BRIDGE` says it runs), so the
driver stays; EXIT's KeyboardSetup uploads the bridge again (about 9 s in Gearboy, the picture frozen
meanwhile), a game's launch doesn't.
`tests/run_sgb_mouse.sh` (Mesen, the real BIOS and kernel, Mesen's mouse in port 2) checks the events
and the pointer; `tests/run_sgb_text.sh` (Gearboy) installs the driver in fullscreen and clicks a
browser row.

**Resident part** (`snes/mouse.s`, segment RES): uploaded after the image at `$7F:C000` (512x448's cells'
WRAM, unused at boot), copied by Boot to `$7E:A000` after BiosSave (shared.s's WRAM, unused in the default
build; a shared build fails to assemble). It's asm only (the C calls it through JSL/RTL); up to 4 KiB, of
which 561 bytes are used. The image itself has 71 bytes left.

## Build phases

| Phase | Scope | Status / exit check |
| --- | --- | --- |
| 0a | BIOS upload + JUMP, green screen | Passed in Mesen and on hardware (2026-11-16); revision unrecorded |
| 0b | LCD channel, mailbox and throughput | Mesen and SGB1 flow-control checks pass: 66 good, 6 rejected captures, 0 missed rows, RAM audit 0; hardware rate counters unrecorded, SGB2 untested |
| 0c | BIOS return and launch policy | Non-destructive return passed in Mesen; hardware inconclusive. EXIT (restore and return) passes in Mesen on SGB1 1.2, 1.1 and SGB2; hardware pending |
| 0d | WRAM/ROM budgets and bank `$7F` audit | Recorded above; bank audit passes in Mesen |
| 1 | Protocol/constants/codecs | Software checks pass |
| 2 | Shared runtime geometry | DMG/CGB geometry and integration checks pass |
| 3 | Optional Gearboy host | Upload/decoder/model/raster/mailbox/MCP checks pass |
| 4 | Fixed renderer overlay loader | DMG/CGB install/execute/restore and failure checks pass |
| 5 | GB terminal and bootstrap | Browser/edit/save/scroll/selection and startup rollback checks pass |
| 6 | Real SNES text kernel | 102-page Mesen replay matches all 57,344 pixels; longest ACK 109 SNES frames |
| 7 | Full OS on SGB1/SGB2 | Pending hardware checklist below |
| 8 | Bars, menus, dialogs, help, OSK, progress | Client checks and 111-page Mesen replay pass; longest ACK 112 SNES frames |
| 9 | Full pad mapping/repeat and mouse | Pending emulator and hardware input checks |
| 10 | Game launch, cart menu, OS return | Pending hardware cycle with DMG-only, SGB-enhanced and CGB-dual games |
| 11 | Performance and polish | Raster speed, scroll, themes, docs; verify clock-divider/SPI timing before changes |

The Phase 8 replay matches the complete font-based golden, including unaligned
boxes and palette changes. Closing menus restores every pixel; BG1's 32 KiB and
draw count remain unchanged through nine UI transactions. Capture losses were
retried: Phase 6 recorded 40 overwritten rows, without losing a transaction.
These results do not establish zero-loss capture or hardware latency margin.

### Probes and hardware ACK investigation

`make sgb-hello`, `sgb-bench` and `sgb-handoff` build plain ROMs in `build/sgb/`
without rebuilding/installing the OS. Launch them from FatPak; reset to leave
hello or bench. Their `test-sgb-*` counterparts run the real BIOS in Mesen.

Hello uploads/checks all 4096 bytes, executes at `$7F0000`, receives `$A5`, and
checks the complete visible 224-line picture for green. GB diagnostics at `$C100`
are 0 boot, 1 detected, 2 staged, 3 uploaded, 4 jumped, 5 replied, `$E0` no SGB;
`$C101` holds the last reply. Hardware confirmed the green screen only.

Handoff preserves BIOS registers, stack and PPU, waits 120 SNES VBlanks, and
returns via a bank-0 RTS at `$001800`. A changed checkerboard should appear
without console reset. Resetting and using the OS afterwards proves only the
reset path. The probe cannot establish recovery after fullscreen replaces
VRAM/CGRAM, nor an armed EverDrive launch. No EverDrive mapper exists in Mesen.

`make test-sgb-bench` builds `build/sgb/bench.gb` and runs it against the real
SGB1 BIOS in Mesen. `make sgb-bench` builds only, ready to launch from FatPak.
The TV shows hex counters; stage 4 means finished. Reset the SNES to exit.
ACK/NACK polling now runs once per GB frame. An unanswered commit stops the
sender after 120 GB frames: stage E1 means ACK timeout, E2 means NACK timeout.
Counters continue updating so a live capture loop is distinguishable from a
stopped GB sender. `make test-sgb-bench-timeout` suppresses each reply type in
Mesen and verifies both timeout stages and their on-screen diagnostics.
Artifacts include `bench.png`, `bench-result.txt` and `bench-metrics.json`.

It alternates A/B through 32 acknowledged pages, publishes an intentionally bad
checksum, waits for a NACK, repairs that same sequence and waits for ACK, then
sends 32 pages without waiting for ACK and finishes with a drained, acknowledged
page. It writes 67 × 1921 = 128,707 bytes (including each commit byte). The
SNES polls `$6000`, DMAs 320 bytes from each completed buffer to WRAM through
`$2180`, and validates 32 words per main-loop slice. Validation is abandoned
if capture of the same page restarts. Numeric display updates run only while
the GB is capturing unused tail rows, preserving the capture service budget.
The GB uses a fixed map and only VBlank interrupts; there is no raster ISR.

Reference Mesen run (default SGB1 clock setting):

| Measurement | Result |
| --- | --- |
| Accepted unique page sequences | 66 |
| Rejected captures | 5 (includes the injected checksum fault and stress) |
| Missed transport rows after status synchronization | 0 |
| GB bytes written | 128,707 |
| Active writing frames | 268 |
| Mean bytes / active frame | 480.25 |
| Peak bytes / frame | 641 |
| Maximum commit-to-ACK delay | 3 GB frames |

Counter boundaries are 16-byte chunks, so frame attribution can shift by up to
15 bytes. Active-frame rate excludes WRAM payload/checksum preparation, waiting
for ACK, warmup and idle frames. The observed reject count depends on capture
phase; it is **not a normal-operation error rate**. The test requires successful
flow control and intentional rejection, not an exact stress reject count.
This polling benchmark does not establish the final rasterizer/IRQ CPU budget.
Its fixed-length header and additive word checksum are test-only; v1 uses the
CRC-16 format specified above; its measurements exclude final renderer work. The status-row/map choice is now fixed in the canonical constants.

Hardware report (2026-11-16): stage 1, good 1, bad 0, missed $0300,
GB frames $9000, bytes low reported as $7801/high 0, active 4, peak $0280;
rows wrapped $FFFF repeatedly. On a second run, GB frames reached $2000 with
zero missed rows and the test still had not finished. These are stalled runs,
not throughput results. One accepted page with only four active writing frames
suggests the sender is waiting for its first ACK. The mailbox cause is not yet
confirmed; zero missed rows alone does not establish a working round trip.

The revised probe adds these fields (each pair shows the first byte on the left):

| Field | Meaning | Expected after the first ACK |
| --- | --- | --- |
| TX / RX | GB sent sequence / last stable received sequence | 0101 |
| RX FLAGS | Last stable received status | 0001 |
| RAW B / E | Commit byte before / after reading the payload | 0101 |
| RAW C / D | Raw page / status bytes, even if the commit check fails | 0101 |
| SNES SEQ / FLAG | Last sequence / status published by the SNES | 0101 |

Comparing the SNES publication against the raw GB reads distinguishes failed
publication from controller selection/readback and seqlock rejection. The SNES
field is a RAM copy of the values written, never a read of write-only ICD2
registers. These diagnostics and bounded waits pass in Mesen; the hardware
investigation and successful SGB1 completion are recorded below.

SGB1 report (2026-11-17), gamepad in port 1 and mouse in port 2: E1 within
about two seconds; TX/RX `0100`, RAW B/E `FFFF`, RAW C/D `0000`, SNES SEQ/FLAG
`0101`, GOOD `0001`, BAD `0000`, RAM AUDIT `0000`; MISSED was `001C` and rising.
The SNES validated the first page and reports publishing its ACK, while the GB
rejects its raw commit reads. This was the initial failure, resolved below.

The slow scanner reads all four virtual controller slots with each P1 selection
held for over 100 µs. `SLOW SLOT 1–4 ID/BYTE` show the controller ID followed by
its byte. These are ICD2 virtual slots, independent of the two physical ports.
After timeout the failed active reads stay visible while this scanner reads the
fixed diagnostic pattern; it does not rescue the timed-out probe.

The SGB1 slow scan returned `0FA5`, `0EFF`, `0D00`, `0C00`: IDs rotate correctly,
but longer read delays do not recover the ACK. The current bench writes
fixed `A5 C3 69 96` bytes from the timeout display handler, independently of
validation, using explicit bank-0 addresses. Expected slow-scan pairs are now
`0FA5`, `0EC3`, `0D69`, `0C96`, possibly rotated. Original TX/RX/raw fields and the SNES ACK
snapshot remain unchanged. This isolates register readback from ACK generation;
it is a diagnostic, not a confirmed hardware fix.

Hardware returned the exact fixed pattern `0FA5`, `0EC3`, `0D69`, `0C96`.
All four slots can carry the requested bytes; the earlier read delays did not
explain the failed ACK. The current revision also uses explicit bank-0 writes
for normal ACK/NACK publication, still once per validated page. `ACK DBR` records
the SNES data bank at publication (expected `0000` with the reference BIOS).
Hardware still reached E1 with ACK DBR `0000`, so wrong-bank addressing does not
explain the failure. The current revision holds each committed reply and reissues
it from NMI until replaced. Page/sequence/flags are snapshotted atomically so a
retry cannot borrow fields from the next page being validated. A Mesen check
that suppresses the first ACK flag tests recovery through this repeat path:
`SGB_BENCH_DROP_ACK=1 bash tests/sgb/run.sh bench`.

Held ACK retransmission also reached E1 on hardware. The current bench uses the
same slow scanner for active ACK polling, aligning controller IDs with a bounded
search and checking the commit before/after the payload through two full scans.
The earlier fixed-pattern success tested only the post-timeout scanner, not the
active mouse-bridge reader. `ACK WRITES` replaces `ACK DBR` on screen and counts
actual ACK write attempts, freezing when the timeout pattern starts. Writer byte
counts remain comparable; polling latency may differ from the baseline above.

The slow active reader still reached E1 with TX/RX `0100` and ACK WRITES `0099`
(153 attempts). After timeout the current bench runs a five-case matrix and
captures four bytes per case. Wait until DIAG STEP is `0006` (about eight seconds
after E1), then report the five rows:

| Row | SNES writes | Expected first-page result |
| --- | --- | --- |
| CONST HIGH | Literal bytes, all four slots | `A5C36996` |
| CONST LOW | Literal ACK-sized bytes, all four slots | `A5010101` |
| HELD PLAIN | Held sequence/page/flags, all four slots | `A5010101` |
| HELD BUSY | Held reply with busy marker and final commit | `A5010101` |
| NO P1 WRITE | Change slots 2–4 without rewriting slot 1 | `A53C695A` |

Snapshots use the same slow scanner and freeze independently. Original failure
fields remain visible. This checks byte values, held-state loads, busy/commit
writes and the slot-1 write in one run.

SGB1 matrix result: CONST HIGH `A5C36996`; CONST LOW, HELD PLAIN and HELD BUSY
all `A5010101`; NO P1 WRITE also `A5010101`, retaining the previous bytes instead
of receiving `A53C695A`. This isolates omission of the slot-1 write in this probe;
the exact ICD2 latch mechanism is not established. Normal ACK publication now
rewrites the slot-1 `$A5` marker before slots 2–4. The Mesen bench checks that
slot-1 writes accompany the busy/commit transactions.

**SGB1 completion (2026-11-17): STAGE `0004`, TX/RX `4242`**, with a gamepad in
port 1 and mouse in port 2. The probe completed its reliable transfer, deliberate
NACK/retry, stress and final ACK stages. Rewriting slot 1 resolved its hardware
ACK stall. Final hex counters: GOOD `0042` (66), BAD `0006`, MISSED `0000`, RAM
AUDIT `0000`. This passes the SGB1 flow-control, rejection/retry and RAM checks.
BAD counts rejected captures during the deliberate fault/stress test, not lost
transactions. Hardware rate counters remain unrecorded; SGB2 remains untested.
The production terminal already writes all four slots, so its fullscreen startup
still requires separate validation.

## Build and tests

```sh
make assemble SD_MOUNT=/tmp/fatpak-no-sd  # Build without copying to the card
make test-sgb-protocol
make sgb-budget
make test-geometry
make test-overlays
make test-sgb-client  # Optional Gearboy host branch
make test-sgb-kernel  # Real SNES text kernel in Mesen
make test-sgb-ui      # Real SNES kernel + UI replay
```

The OS needs EverDrive/SD emulation in the Gearboy fork; the SNES kernel needs
Mesen's real BIOS/ICD2. Tests meet at recorded LCD streams and reference images:

1. Python checks protocol, RLE, CRC, containers and generated-header freshness.
2. Gearboy runs the real GB OS against an optional protocol test double, recording
   bootstrap packets, LCD frames and reference pixels in `build/sgb/client.fph`.
3. A plain MBC5 harness uploads the real kernel and replays those transactions
   through ICD2 in Mesen. Committed fixtures in `tests/sgb/fixtures/` make kernel
   tests independent of the optional Gearboy host.
4. Hardware covers the complete OS/cart/SGB stack, input timing and launch/reset.
   A bsnes/ares timing cross-check is useful but has not replaced these checks.

The committed `tests/sgb/fixtures/client.pages.gz` contains 102 accepted
transactions from the real-OS client test: bootstrap, browser, C editing/saving,
a 30-key scrolling burst and selection. Gzip uses a zero timestamp; `client.png`
is that run's final reference raster. `tests/sgb/kernel_build.py:recording()` can
extract the original `client.fph`. These compact fixtures replace the 117 MB
recording for standalone kernel tests. The Mesen runner uploads through the
BIOS and replays through LCD capture; Lua never injects SNES code, registers,
protocol replies or pixels.

Geometry checks cover row addresses/sentinels, wrapping, layout, cursor, scrolling,
clipboard/undo staging and GB-mode return. Client checks cover actual menu text,
hover/highlight/close, help/module return, OSK typing, numeric progress and exact
startup rollback. Overlay checks cover interval bounds, host/CRC mismatch,
interrupt/nesting refusal, backup corruption and exact restoration. Existing
DMG/CGB browser/editor, module, build, input, session and return tests remain the
compatibility gate.

| Tool | Setup |
| --- | --- |
| cc65 | `ca65`/`ld65` plus `cc65` for native SNES code |
| RGBDS, SDCC | Existing GB build toolchain |
| MesenCE | Default `dotnet ../MesenCE/bin/linux-x64/Release/Mesen.dll`; override `MESEN_DLL` |
| SGB BIOS | `~/Desktop/sgb/` (`SGB_DUMPS`): `sgb1v0.sfc`, `sgb1v1.sfc`, `sgb1v2.sfc` (the default, override `SGB_BIOS`), `sgb2.sfc`, named as ISSOtm's SGB disassembly expects |
| GB-side SGB boot ROM | Default `~/Downloads/sgb_boot.bin`; override `SGB_BOOT` |
| Gearboy fork | GB/EverDrive tests; optional host on its separate `fatpak` branch |

Mesen runners use temporary firmware/settings directories. SameBoy's high-level
SGB emulation cannot execute this SNES kernel. No production emulator feature is
required by fullscreen mode.
The standalone probe runner configures SGB1 with a gamepad in port 1 and mouse
in port 2, matching the reported hardware setup.

## Optional Gearboy host

This software-specific test double is kept on Gearboy's `fatpak` branch. It is
optional validation infrastructure, not an SGB hardware implementation or a
production dependency. The real SNES program is tested separately in Mesen.

Build the sibling Gearboy fork with `make -C ../Gearboy/platforms/linux all`.
Run the protocol/model, font-image and real GB bench checks with:

```sh
make test-sgb-host
# Optional override for a separate Gearboy checkout:
GEARBOY_ROOT=/path/to/Gearboy make test-sgb-host
# After a desktop build, also exercise the public MCP interface:
python3 tests/sgb/host_mcp.py ../Gearboy/platforms/linux/gearboy
```

The MCP check uses the bench capture generated by the first command and the v1
capture generated by Gearboy's standalone unit suite. Unit outputs use `/tmp`;
run both commands in the same environment. Tests use isolated
`Gearboy/tests/.objects` core objects so test feature flags do not replace the
desktop emulator's objects.

Protocol/constants and fonts come from FatPak. Regenerate after changing them:

```sh
python3 scripts/sgb_protocol.py
python3 tests/sgb/host_assets.py --gearboy ../Gearboy
# Check without modifying Gearboy:
python3 tests/sgb/host_assets.py --check --gearboy ../Gearboy
```

### MCP

Use `fatpak_sgb_host` in the `hardware_sgb` tool category. Its default action is
`inspect`; it returns the terminal rows/styles, layout, palette, overlay state,
mailbox, upload/decoder counters and last diagnostic. Examples of tool arguments:

```json
{"action":"configure","profile":"bench"}
{"action":"record","path":"/absolute/path/bench.fph"}
{"action":"replay","path":"/absolute/path/bench.fph"}
{"action":"verify_upload","path":"/absolute/path/SGB.DAT"}
{"action":"configure","profile":"v1"}
{"action":"key","key":65,"modifiers":1}
{"action":"snes_press","button":"down"}
{"action":"mouse_click","row":4,"x":120,"buttons":1}
{"action":"mouse_move","row":5,"x":100,"buttons":0}
{"action":"image","path":"/absolute/path/reference.ppm"}
{"action":"configure","profile":"disabled"}
```

Configure before reset/upload. Recording starts before the first captured
frame; an empty recording path stops it. A normal ROM load/reset keeps the
configured profile and clears the host's emulated state. In v1, injection only
succeeds after upload/JUMP activates the host. `snes_press` emits a single logical
key event: d-pad arrows, A/Start=Enter, B=Escape, X=Menu, Y=Backspace,
Select=Info, L/R=Page Up/Down. Mouse buttons use left=1/right=2; up/move default
to no held buttons. A click reserves room for both down/up edges.

`verify_upload` validates the container and compares uploaded SNES program/fonts;
GB overlay binding is checked by the OS overlay loader.
The reference image uses palette roles paper/highlight/dim/ink at indices 0–3,
then blue/red/purple/orange syntax inks at 4–7. Remaining palette entries are
available to later UI work. PPM files can be opened by Pillow or converted to PNG.

### Capture format (FPH1)

All lengths are little endian. The header is `FPH1` followed by one profile byte
(1=v1, 2=bench). Each record is `[type:u8][length:u32][payload]`:

| Type | Payload |
| --- | --- |
| 1 | One 16-byte DATA_SND, DATA_TRN or JUMP packet |
| 2 | 160×144 LCD shade bytes (0–3), before SGB masking/border |
| 3 | Three bytes: injected event, payload A, payload B |
| 4 | Empty payload: host reset; profile is retained |

The stream includes frames before JUMP, upload frames, duplicates, invalid pages
and status echoes. Replay reuses the actual upload/page/status/input paths.
It rejects unknown record types, invalid lengths and truncated records.
Changing profile stops recording; replay stops any current recorder. The Mesen
harness reconstructs LCD tiles/pages while preserving publication order and
status echoes.

### Limits

This host executes no SNES code and captures complete GB frames rather than ICD2
rows. It supplies deterministic protocol/model/raster evidence, not SNES timing
or hardware ACK evidence. Bench and v1 use separate wire formats and mailboxes.
The v1 raster is a reference for kernel comparisons; physical controls and
pointer behavior still require Phase 9 and hardware checks. Loading a Gearboy
save state clears the optional host; resume fullscreen tests from a new
upload/JUMP.

## Hardware integration checklist (Phase 7)

Fullscreen writes a bounded binary flight recorder to `/GBCSYS/SGB.LOG`.
It is recorded in the first 16 KiB of SGBBOOT's PSRAM copy of SGB.DAT, and stops short of the overlay
page's block (`_overlay_request`), which the extension follows. With the kernel both are about 95 blocks in;
the Gearboy tests' `hello.bin` puts them at block 8, where a long session's log used to overwrite the
extension's length word, so a later CODE upload stopped early and TEXT 1 was refused (2026-11-27).
After upload/HELLO, it replaces the previous log before the first page wait.
Until the first ordinary input callback, a page timeout saves the log
immediately (with the records before it); the ordinary flush can't run while
the bootstrap draws. (Saving every publication and ACK rewrote the whole file
several times a page: seconds of startup.) The bootstrap's source file is
already closed; subsequent module callbacks retain the filesystem recursion guard.
Pre-wait records include `LCDC`, `LY`, `IE` and `IF`. Log writes temporarily
mask interrupts and restore `IE`, preserving `IME` and pending requests.
GB frame timestamps exclude frames lost during these masked writes; the SNES
NMI clock continues independently.
Reproduce for about a minute,
then remount the card; no counter transcription is needed. Decode with
`python3 scripts/sgb_log.py /path/to/GBCSYS/SGB.LOG`.

The header identifies the OS checksum and `SGB.DAT` CRC. Twelve-byte records
capture GB frames, page publication/ACK/timeout, delivered keys, pad transitions
(record 9: held/pressed bits), and SD-write
duration and SD error codes. After the first screen is received and drawn, an
idle mailbox sends one timing field every two seconds: peak draw/UI/page/mail
times, NMI frames, then GOOD/BAD/MISS/ROW. Control replies take priority.
SNES timings are in frames; samples are timestamped
individually. A counter-only NMI keeps timing independent of capture polling.

The recorder reuses the first 8 KiB of upload staging after upload, preserving
document/undo/assembler storage. It flushes about every four GB seconds outside
active modules and ordinary pending-page waits. A repaint timeout also attempts
a flush, so recording does not depend on reaching the ordinary input loop.
SD errors are recorded and retried on the next interval. At the size limit it
retains the captured beginning of the session. Records can end up to one flush
interval behind; partial final records are ignored by the decoder.

On-screen diagnostics start hidden and are controlled only by L+R+Select.
They never reopen automatically; file recording does not require the overlay.
Hardware reported no response-time improvement from the preceding optimization
build (`GOOD=49 BAD=2 MISS=09AA`); the new log is intended to locate that gap.
The first hardware log captured four pages and two timeouts, but stopped after
13 records. Its GB clock did not carry past the low byte, so its decoded elapsed
times are invalid. The next build fixed the clock and retried SD failures, but
hardware did not load the UI or replace the log within five minutes. Its new
nine-event telemetry batch has been removed; telemetry now waits for the first
screen and sends one field at a time, starting with draw cost. The cause of that
startup failure is not yet confirmed. The folder title and first highlight row
were visible, locating the failure after upload, during the initial repaint.
Removing the batch did not change that result or replace the old log. A GB test
then reproduced a frame wait that stopped updating status with `IE` enabled but
CPU `IME` disabled. The wait now falls back to publishing status whenever the
frame counter did not advance across a physical frame; it preserves interrupt
masking. This explains a possible unbounded ACK wait, but hardware confirmation
is still needed.
That hardware build wrote only the startup record (CRC `A575`). Subsequent
flushes could be suppressed by the active bootstrap module, so startup page
records now bypass that guard only until the first ordinary input callback.
The next capture (`6777`) accepted palette page 1, then ended at publication of
page 2 (GB frame 1768, row 9). It contained no page-2 ACK, timeout or subsequent
write record. Startup tests left 101 stack bytes unused. The next build isolates
SD writes from interrupts and records LCD/interrupt state before page waits;
the hardware cause remains unconfirmed.
Capture `19C9` reached page 2's pre-wait record: `LCDC=91 LY=7F IE=0B IF=E0`,
then stopped recording. L+R+Select still toggled the SNES's two diagnostic rows.
Interrupt isolation did not resolve the hardware stall.

The subsequent performance revision skips snapshots for empty, duplicate or
out-of-sequence captured pages, retaining copied-sequence/CRC validation. Empty
overlay rows upload transparent tiles without per-pixel encoding, preserving
menu erasure. Native tests and a 111-page Mesen replay pass, including all 57,344
golden pixels and dropped-ACK recovery. Empty overlay rows cost one SNES frame;
populated rows still peak at ten. The single-threaded raster remains a latency
limit; these changes do not establish a fix for the hardware stall.
Hardware capture `ADF2` again ended at page 2's pre-wait record, with
`LCDC=91 LY=09 IE=0B IF=E0`. The next control build (`64B6`) disables recorder
initialization and all SD recorder writes, keeping the SNES kernel unchanged.
Build it with `scripts/sgb_data.py --no-log` and the usual SNES/font arguments;
validate with `SGB_CLIENT_NO_LOG=1 SGB_CLIENT_DATA=bin/SGB.DAT make test-sgb-client`.
It intentionally leaves the previous `SGB.LOG` unchanged. This distinguishes
recorder interference from a stall that also occurs without SD logging.

The logging-disabled control still stalled: `GOOD=0002 BAD=0000 MISS=02EC
ROW=9A1C Q=0C`, with peak draw/UI/page/mail times of 9/16/52/17 SNES frames.
SD logging is therefore not required to trigger the stall. Build `6E03`
keeps logging disabled and adds a third diagnostic row:
`MB:seq/type/A/B E:echo GB:frame P:published V:valid NEXT:expected`.
`MB` is displayed as two four-digit words (`seq/type` and `A/B`); `V=01`
means the latest captured GB status passes validation. Compare `GB` across
several seconds to check GB progress, and `E` against the mailbox sequence
to locate a blocked reply. Gamepad commands now use port 1 only; mouse buttons
in port 2 no longer become Enter/X commands. The kernel replay now connects
a mouse in port 2 as well as a gamepad in port 1.
Client timeout/recovery and logging-disabled checks pass. The 111-page SNES
replay matches all reference pixels; the port-2-mouse stall test opens/hides
diagnostics without reopening them automatically. Hardware confirmation remains
pending. The card was mounted read-only when this build was prepared.

Hardware build `D745` had recording enabled again; its fresh log stops at
page 2's pre-wait record (`LCDC=91 LY=08 IE=0B IF=E0`). Startup activated
fullscreen interrupt dispatch only after the initial redraw. During that draw,
restored interrupts could still run the normal VBlank handler and `LatchPad`,
which shares P1 with the mailbox. Build `0DF5` activates fullscreen dispatch
after HELLO, before logging/layout/redraw. A client regression fails on the old
ordering and passes with the change; bootstrap rollback, late ACK recovery,
editing/saving and recorder checks pass. Hardware confirmation is pending.
The preceding build's diagnostics showed `MB=0306/0002 E=02 GB=2BAD P=02
V=01 NEXT=03 Q=01`; GB frames continued advancing. The SNES had accepted
page 2 and held its ACK, while the GB still echoed the previous event. This
narrows the observed stall to mailbox consumption, rather than a stopped GB
clock or rejected page. Build `0DF5` was copied and verified on the card with
recording enabled; no further counter transcription is requested for this run.

Capture `0DF5` still ends at page 2's pre-wait record, so early interrupt
ownership did not resolve the stall. `FsFrame` waited for `LY >= 144` before
checking the frame counter. An interrupt covering VBlank can therefore leave
foreground code waiting forever while the clock advances. A GB CPU regression
starts a delayed frame handler at LY 143 to cover the entire blank interval:
the old wait never returns despite repeated counter updates. Build `3604`
checks the counter throughout both LY loops, retaining the physical-frame
fallback when interrupts are masked. Hardware confirmation is pending.
The full client suite passes, including the covered-VBlank regression, timeout
recovery, editing/saving, durable logs and rollback. `3604` was copied and
verified on the SD. The blind LY wait also exists in working commit `c293ec7`;
this test establishes a timing weakness, not which later change triggered it
on hardware. Keep that commit as the working control; assess startup/input
latency separately from stall recovery.

SGB1 hardware confirmation: `3604` renders again and feels somewhat faster,
but remains unusably slow. Its saved log has 516 records, 30 published pages
and 30 matching ACKs, with no recorded timeouts or SD errors. Peak SNES costs:
12 frames per base row, 13 per UI row, 55 for page processing and 112 for a
held mailbox event. Publish-to-ACK latency is 15 GB frames median, 64 maximum;
individual SD writes take at most two counted GB frames. The recorder now
continues beyond page 2. Raw capture and a JSON summary are preserved under
`build/sgb/hardware-working-3604-*`. Automatic-start build `5772` / OS `B12E`
was subsequently copied and verified on the card.

Performance build `4D9E` merges equal ROW attributes, uses table CRCs on both
CPUs, combines GB row counting/hashing into one pass, and clips SNES glyphs
once per glyph while skipping blank bitmap rows. It adds no WRAM/HRAM and
keeps the same number of BIOS upload blocks. CRC tables occupy unused GB overlay
space and 256 SNES program bytes. Header/footer now use full-width GB/GBC-style
highlighting; text is left-aligned and the cursor removes the GB sprite offset.
Progress remains visible against the footer highlight.

Same 111-page Mesen replay, with dropped-ACK recovery and pixel comparisons:

| Measurement, SNES frames | Working baseline | Merged runs | Final |
| --- | ---: | ---: | ---: |
| Peak page processing | 54 | 12 | 9 |
| Longest publish-to-ACK | 88 | 19 | 14 |
| Replay completion after JUMP | 4094 | 3199 | 3033 |

Merged payloads shrink from 32,877 to 14,017 bytes on that replay. The real GB
client emits 17,746 ROW bytes versus 45,202 with one pair per character. Its
typed-character test publishes after 26 GB frames, down from 41; ACK follows
at 28 versus 43. These are emulator comparisons, not hardware latency claims.
All reference pixels match the intended alignment/bar changes, and menu close
restores the underlying image. Client tests cover startup, editing/saving,
cursor alignment, timeouts, logging and fallback. The previous build is retained
in `build/sgb/perf-before/`; comparison data is in `build/sgb/performance.json`.
Revision `D15B` restores the original one-pixel glyph inset without moving the
cursor or selection boundaries. GB row hashes use unrolled CRCs over fixed-size
source rows; widths and RLE runs are computed only for changed rows. The SNES
uses lookup-based shade conversion, skips empty/uniform paper tiles, and clears
raster/shade in native 16-bit chunks. Glyph compositing masks are computed once
per glyph. Constant font widths no longer consume six redundant asset pages;
program+fonts shrink from 44,914 to 43,678 bytes, still eleven upload blocks.

Against `4D9E`, browser Down reaches the published model in 10 versus 28 GB
frames; a typed character takes 17 versus 28. These injection-to-publication
measurements exclude physical SNES input and PPU drawing. The same Mesen replay
finishes in 2,636 versus 3,033 frames (13% faster); peak base/UI drawing is 7
versus 11 frames, peak page handling 8 versus 9, and longest ACK 11 versus 14.
Pixel comparisons, menu restoration, editing/saving, delayed ACKs, logging,
fallback and stalled-mailbox diagnostic toggling pass. Comparisons and logs are
in `build/sgb/speed-*`; the previous package is in `build/sgb/perf-4D9E/`.

The preceding hardware log (`9974`) contains no timeouts or SD errors. Browser
keys waited 25–30 GB frames before publication, consistent with the frontend
bottleneck addressed here. Its raw log is preserved in
`build/sgb/hardware-before-speed-*`. Hardware latency for `D15B` remains untested.

Hardware testing of `D15B` reports a large speed improvement, nearly usable.
Revision `FD84` / OS `840F` replaces synthetic pad keys with shared held/pressed
input, restores dialog padding and makes the OSK a centered independent layer.
Document rows remain intact while it opens, changes layers and closes. Native
pad tests cover all eight GB buttons, short taps and reserved L/R/X/Y; the GB
client covers Select, Start, B navigation/deletion, A selection and OSK layers.
The 113-page real-SNES replay checks all pixels and full restoration after
closing both menus and keyboard. DMG/CGB geometry regressions also pass.
The optional Gearboy test renderer accepts the new layout and keeps its panel
inside the framebuffer; the real renderer remains the uploaded SNES program.
Resolution changes are deferred to the widescreen experiment described above.

Performance revision `5859` (OS `F463`) moves row layout to native 65816 code,
unrolls three-plane pixel packing and services ICD2 in bounded tile/glyph chunks.
GB encoding skips width walks for empty/full-row selections. No protocol change;
the upload remains eleven 4 KiB blocks (43,784 bytes before padding).

The 113-page Mesen replay reduces average base-row drawing from 3.18 to 2.22
SNES frames (30%) and overlay drawing from 1.10 to 0.94 (14%). Browser input
publishes in 9 vs 10 GB frames; typing takes 15 vs 17. Whole-replay time barely
changes because the UI probes include fixed pauses. All PPU pixels, restoration,
late/dropped ACKs and client edit/save checks pass. A separate SNES build checks
74 native/C glyph cases with `SGB_GLYPH_CHECK=1`; it caught an optimized cc65
nested-ternary error in the old style selector. The reference now uses explicit
branches. Measurements/logs: `build/sgb/performance-next*`. Hardware untested.

Selection-only row updates now reuse unselected 4bpp row tiles. Native bitplane
recoloring preserves paper, dim ink, syntax accents and icons without repeating
glyph layout or shade conversion. This uses 32 KiB of reserved SNES WRAM and
32 validity bytes; it adds no GB state or protocol commands. Text/style changes,
ROW_SAME, reset and newly revealed scroll rows invalidate their cache slots.

The real-65816 dense-row selection benchmark takes 64 frames for eight cold
redraws versus 9 with cached tiles (about 7x faster). All 112 cache/color/mask
checks pass, including every slot and partial-tile selections. Run them with
`SGB_CACHE_CHECK=1 SGB_CACHE_ONLY=1 make test-sgb-kernel`. The ordinary 113-page
PPU replay still matches all pixels and restores menus/OSK exactly. Its total
duration is effectively unchanged; fresh text still rasterizes and fills its
cache, and scripted
pauses dominate this replay. Browser/typing publication remains 9/15 GB frames.
Results: `build/sgb/selection-before/` and `build/sgb/selection-after/`.
That row-cache revision takes eleven upload blocks. Hardware untested.

Startup profiling (fresh sample card, nominal GB clock) publishes the browser at
1,560 frames (~26 s). First DATA_TRN: frame 979; JUMP: 1,285; wide geometry:
1,327. GB package validation costs 6.3 s, including 3.7 s in per-byte CRC calls;
upload preparation/copying costs another 4.6 s excluding called routines.
Raw profile: `build/sgb/boot-analysis/`.

Bootstrap now uses native GB block loops for package CRC, upload copies and
VRAM save/restore. CRC still covers the entire file with its checksum field
zeroed logically; copies stop at each 512-byte window boundary. The DATA_TRN
tile map is prepared once, while packet timing and upload block count stay the
same.

With the same production package and fresh sample card, browser publication
falls from 1,560 to 1,030 GB frames (~26 to ~17 s, 34% faster). First DATA_TRN:
979 to 673; JUMP: 1,285 to 755; wide geometry: 1,327 to 797. These are GB CPU
emulator measurements, not hardware or first-visible-SNES-frame timings.
Input publication remains 9 frames for browser Down and 15 for typing; this
change targets startup rather than drawing. Comparisons/logs:
`build/sgb/startup-before/` and `build/sgb/startup-after/`. The client test now
reports boot milestones and checks CRC rejection at the stored checksum and
both sides of a cartridge-window boundary, alongside upload bytes, zero padding,
editing/saving and rollback. Hardware testing is pending.

Startup, again (2026-11-21, `bin/SGB.DAT` with the BIOS snapshot, mouse and
extension; Gearboy, GB side only): first DATA_TRN at frame 720, JUMP 818, the
first screen's drawing done about 1,140. The package CRC took 180 frames, the
overlay install 150 (four CRC passes and two C copy loops over 7.4 KB), and the
bootstrap's log saved the whole SGB.LOG at each page publication and ACK while
drawing. Now SGBBOOT CRCs through a 512-byte table built in its BSS (about 60
cycles a byte rather than 200), the overlay copies with an asm loop that reads
each byte back and drops the two CRC passes that read-back makes redundant, and
only a timeout saves the log before the first input: first DATA_TRN 529, JUMP
627, drawing done about 800 (some 5.5 s sooner). What's left before JUMP: the
OS's own startup (to about frame 300, the same at 160x144), reading SGB.DAT
(about 90 frames), the CRC (about 70), the overlay (about 30) and the 13
DATA_TRN blocks (98).

The fixed-width composed-tile path now passes 144 native comparisons against
the original compositor: all character codes, styles, row lengths, final-column
clipping, mixed colors and cache reuse. Dense fresh text takes 8 rather than 57
SNES frames for eight rows (about 7x faster). Test with
`SGB_TILE_ONLY=1 make test-sgb-kernel`. The production image is 45,740 bytes,
requiring twelve upload blocks; the row-cache build used eleven. The native
comparisons are in `build/sgb/tiles-after/native-result.txt`.

The complete 113-page replay reduces base-row drawing from 2.2 to 1.5 SNES
frames on average (32%); it records 1,646 tile hits and 82 misses. All 57,344
PPU pixels, menu/OSK restoration and dropped-ACK recovery pass. Replay duration
falls from 3,764 to 3,704 frames; fixed UI pauses dominate the total. Logs and
comparison data: `build/sgb/tiles-after/`. The client verifies the full upload,
padding, edit/save/scroll, menus/OSK and all six fallback cases. GB input
publication stays at 9/15 frames; browser startup rises from 1,033 to 1,046 GB
frames (~0.2 s) with the extra upload block. Hardware untested.

The plain-text path passes 256 native comparisons against the original
compositor: all fonts/character codes, structured and unstructured text,
widths 1–15, clipped/spanning glyphs and unchanged output on fallback. The
proportional-row benchmark takes 15 rather than 44 SNES frames for eight rows
(about 3x faster). The fixed-width regression still passes all 144 cases;
with tile-only clearing its benchmark takes 7 rather than 56 legacy frames.
Run `SGB_PLAIN_ONLY=1 make test-sgb-kernel`; results are in
`build/sgb/plain-after/`. The production image is 46,340 bytes, still twelve
upload blocks. The complete replay lowers average base-row drawing from 1.5
to 1.125 SNES frames (25%); all 57,344 pixels, menu/OSK restoration and
dropped-ACK recovery pass. Client upload/padding and typing checks pass; GB
input publication remains 9/15 frames. Browser publication is 1,049 GB frames
versus 1,046 for the fixed-only build. Hardware untested.

Scrolling now rotates the GB publisher's row hashes with the SNES BG1 ring.
A one-line scroll retains the existing text and publishes only the exposed row;
previously it republished all 26 text rows. Header/footer and dialog/loading/OSK
panels already use fixed BG2/BG3 layers. Scrolling no longer uploads BG1 rows
hidden beneath the bars. A checksum update also wrote past its entry when only
the high byte changed; fixing it prevents repeated updates of unchanged rows.

The client regression verifies one ROW for each of twelve scrolls in both
directions, then checks that closing a menu sends no base-text commands.
CPU checks cover cache rotation with/without bars and 1/5/21/26/28-row viewports;
native model checks require only the exposed text row to become dirty. The
113-page SNES replay passes all 57,344 pixels and menu/OSK restoration. The
production image is 46,354 bytes (twelve upload blocks), with no added WRAM.
Results: `build/sgb/scroll-after/`. Hardware timing remains unmeasured.

Shared-map prototype: `SGB_SHARED_ONLY=1 make test-sgb-kernel` runs 217
native PPU/map/reference checks, including all 1,024 slots, lookup collisions,
release/reuse, every font/style, selection and row-cache/stack guards. The
113-page replay passes all 57,344 pixels, menu/OSK restoration and dropped ACK
recovery with `SGB_SHARED_RENDER=1 SGB_KERNEL_UI=1 SGB_KERNEL_DROP_COMMIT=1
SGB_KERNEL_PROFILE=1 make test-sgb-kernel`. Background DMA totals 8,320 bytes,
versus 96,256 in the standard identity-map replay. This is a bandwidth saving,
not a CPU speedup: sixteen code rows take 22 rather than 17 SNES frames, and
the full replay takes 3,704 frames versus 3,681 for the standard backend. Keep the standard
backend as the default. Results: `build/sgb/shared-after/`; hardware untested.

Next: reduce fixed-code map publication cost before enabling shared tiles by
default, then build the Mode 5 readability probe. Keep the raster path for
proportional/overlapping glyphs.
Measure first usable screen and key-to-PPU latency separately from transport
ACKs and the replay's deliberate pauses.

Menu follow-up: center dialogs against the full 256-pixel viewport. The old
keyboard preview used a fixed 150-pixel box; its replacement uses the actual
57-pixel main-menu dimensions. Client checks now assert measured width and
centering. DMG/CGB tests compare real menu pixels with font glyphs over a
70 KB document, with and without the OSK. Those pass; the reported blank DMG
menu remains unreproduced.

Run the comparable replay with `SGB_KERNEL_UI=1 SGB_KERNEL_COMPACT=1
SGB_KERNEL_DROP_COMMIT=1 SGB_KERNEL_PROFILE=1 make test-sgb-kernel`.

The production build now produces `bin/SGB.DAT` from the real cc65/65816 kernel,
fonts and the renderer overlay bound to `GBCOS.BIN`. `make assemble` stages it
with the existing OS/data/modules; its normal mounted-card copy includes it.
For a build without copying to the card, pass `SD_MOUNT=/tmp/fatpak-no-sd`.
Copy `SGB.DAT`, `GBCOS.BIN`, `EDITOR.DAT` and `MODULES/SGBBOOT.MOD` from the same
build into `GBCSYS`. The container checks the OS checksum before takeover.
Fullscreen starts automatically on SGB. Missing data leaves
the BIOS renderer active. DMG/CGB startup is unaffected.

First fullscreen hardware report: takeover took several minutes, then displayed
a dark blue screen with one row of light blue tiles halfway down, starting one
tile from the left. Console/SGB revision was not recorded. Fullscreen was
temporarily made menu-only for probes; automatic startup has since been restored.
Phase 7 has not passed. Mesen validates
BIOS upload, ICD2 transport and PPU output separately from the OS frontend;
the complete fullscreen EverDrive/SGB combination remains unverified. The separate
Phase 0b bench now completes on SGB1 after the slot-1 publication fix above.

After that bench pass, fullscreen took about 45 seconds to load, displayed black
for two seconds, then froze with `/Tests`, empty rows and two blue highlight bars.
L+R+Select produced no visible response. Diagnostics were drawn in BG1 beneath
the opaque status bar, so this does not establish that SNES input or execution
stopped. Diagnostics now use the top UI layer and include the actual queue count.
An initial diagnostic build opened them after a held event timed out. The
current recorder build leaves them hidden unless toggled with L+R+Select.
This shows partial frontend rendering, not a successful Phase 7 exit. The kernel
previously wrote each mailbox event once and waited indefinitely for its status
echo. Dropping an ACK commit in Mesen reproduced a permanent stall. Held events
are now republished once per observed SNES frame. Hardware still stalls with
the same title/top highlight, but without the middle highlight bar; launch
still takes about 45 seconds. Retransmission alone did not resolve fullscreen.
With the first ACK commit suppressed, the revised real-SNES replay completes all
111 transactions and matches all 57,344 reference pixels, including menu close.
Longest ACK remains 112 SNES frames. It reports 153 overwritten capture rows,
recovered through later captures; this is not a zero-loss capture claim.
Bootstrap validation now uses the transport's equivalent byte-at-a-time CCITT
update instead of eight C bit iterations per byte. It matches an independent CRC
implementation across 10,000 state/byte pairs; hardware launch stayed near 45
seconds. Bootstrap now validates/uploads through sequential 512-byte windows,
avoiding per-byte bank selection and 32-bit address calculations. Its hardware
timing is pending. Fullscreen P1 reads now use the bench's 32-read settling loop
for released selections and both nibbles, instead of six quick reads per nibble.
This timing change also needs hardware confirmation.

`SGB_KERNEL_STALL=1 SGB_KERNEL_UI=1 make test-sgb-kernel` holds ACK commits and
checks manual diagnostic display/dismissal across successive stalls in actual
SNES PPU output. `SGB_CLIENT_DATA=bin/SGB.DAT make test-sgb-client` checks every
uploaded production byte and final-block zero padding across cartridge windows.
Both checks pass in emulation, including all 43,157 production payload bytes;
the local shortcut also passes the native layer/row-preservation check.

Next SGB1 hardware run: launch took about 10 seconds; diagnostics appeared
about five seconds later, followed by the same title/highlight after another
five seconds. `GOOD=0003 BAD=0000 MISS=0200 ROW=BCAD Q=00`; MISS/ROW kept
increasing and L+R+Select toggled diagnostics. SNES capture and input were alive.
The GB could clear a pending page on a late ACK while leaving its timeout fault
latched, permanently blocking new pages even after the SNES queue drained.
A delayed-ACK test reproduces that stall. Only an ACK matching the current
page/slot now clears the timeout and resumes publication; the page remains
committed while waiting, and wrong-page ACKs cannot release it.
With the previous hardware build, the test ends with `fault=1 pending=0` and
an empty mailbox, matching the observed drained queue. With recovery enabled,
the timeout, wrong-page rejection, matching late ACK and a subsequent visible
edit all pass. Hardware confirmation is pending.

The following hardware run reached the browser/editor, but input took 5–10
seconds and each row about one second. Startup stayed near 10 seconds. Editing
and saving were not tried. Diagnostics could not be hidden: the watchdog could
immediately re-enable them. A per-event latch still reopened them on later
events, so automatic display has been removed. A Mesen gamepad test verifies
opening/hiding diagnostics and keeping them hidden through another stalled event.
Performance changes use native CRC arithmetic, pack eight pixels per tile-plane
byte, skip blank space glyphs and avoid repainting identical ROW commands.
The font build verifies the blank-space assumption. Pixel comparisons retain
the existing text/style/selection/UI expectations; hardware timing is pending.
Final Mesen replay: all 111 pages and reference pixels pass; identical-row
suppression reduces base draws from 81 to 75. Peak text-row raster time drops
from 22 to 10 SNES frames, and longest ACK from the previous build's 112 to 59.
There are 642 overwritten capture rows, recovered by later captures; capture
loss has not been eliminated. Production upload, late-ACK recovery, continued
editing/saving and startup fallbacks also pass.

Record console/SGB revision, cart/OS build and keyboard/controller setup with
all results. Use a gamepad in port 1; leave the mouse in port 2. A keyboard can help inspect text while the full pad
mapping is developed.

- [ ] SGB1: cold boot reaches a readable fullscreen title/status and file list.
- [ ] SGB2: repeat the same cold-boot check.
- [ ] On each, open a small `.c` file, verify comments/strings/keywords, scroll,
      place the cursor, edit using the pad/OSK, save and reopen the changed file.
- [ ] On each, repeat with `.md`: headings, emphasis, fenced code and selection.
- [ ] Run L+R+Select diagnostics through several minutes of scrolling. Record
      accepted/rejected pages, overwritten rows and whether display/input stalls.
- [ ] Open/close menus over text; change selection; dismiss dialogs; open help,
      OSK and module menus. Base text must reappear intact. (Phase 8.)
- [ ] Verify missing/corrupt/mismatched `SGB.DAT` retains BIOS mode, using copies
      of the files and restoring a matching production set afterwards.
- [ ] Remove/reinsert the physical keyboard and try longer filesystem operations;
      no unsaved document may be discarded because of a transport timeout.

A runtime timeout pauses page publication and preserves the committed page/GB
state. A matching late ACK resumes publication; an absent ACK leaves it paused.
Hardware confirmation of this recovery is pending. Save
before stress tests. Fullscreen game launch, cart-button return and reset/BIOS
handoff are Phase 10 work; the non-destructive Phase 0c probe is insufficient to
prove that cycle after replacing SNES VRAM/CGRAM.

Use copies of small source files for edit/save checks. Capture a photo and the
precise last action if a check fails, especially any cold-boot stall, black screen
or change in the diagnostic counters.
