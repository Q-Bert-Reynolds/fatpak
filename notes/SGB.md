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
The text area is 248 px wide with an 8 px left margin, capped at 64 glyphs per row:
26 text rows with both bars, or 21 with the five-row on-screen keyboard (OSK).
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

Startup always uses SGB BIOS mode, even with `SGB.DAT` installed. Select
**SETTINGS → SGB FULLSCREEN** in the browser or editor to attempt takeover.
The action appears only in SGB BIOS mode and is not saved as a startup setting.
This keeps the test ROMs accessible without removing fullscreen files.

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
`tile_buffer`/`tile_attrs` to VRAM. Input enters the existing keyboard-event queue;
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

The BIOS fallback uses `src/ui/sgb.asm` for detection, palettes and the border
from `EDITOR.DAT`. Border upload saves `$8800–$9FFF` in PSRAM `$3C00–$3C0B`, masks
interrupts during transfer, and restores tiles/maps/registers before unmasking.
`gbdk_DisplayOff` waits for VBlank before disabling the LCD.

### SNES kernel

`snes/kernel.c` implements protocol validation and the display model using cc65's
native 65816 8-bit accumulator/index ABI. `hardware.s` owns startup, ICD2 DMA,
mailbox, pad sampling and PPU writes; `raster.s` composes glyphs; `overlay.s`
draws UI layers. Code/fonts run in bank `$7F`; mutable state is in `$7E`.
`snes/kernel.cfg` asserts the image fits below `$7F:FF00`.

Capture drains up to four completed ICD2 buffers between bounded work slices.
A separate 1920-byte snapshot protects validation from concurrent capture.
The whole command stream is validated before any model changes. Mailbox
backpressure, sequence ordering and duplicate suppression protect transactions.

BG1 uses a 32-row ring. Only changed/revealed rows rasterize; scrolling waits for
DMA and the smooth flag requests 2 px steps. Glyph overhangs are ORed; selection
uses pixel boundaries. BG3 draws bars, boxes, dialogs and OSK over a high-priority
BG2 paper mask. Closing a menu restores the underlying text without BG1 redraw.
Uploads wait for the start of VBlank. An OBJ draws the text cursor; full mouse
and pad behavior remains Phase 9. L+R+Select toggles capture/page diagnostics.

| SNES VRAM byte range | Use |
| --- | --- |
| `$0000–$7FFF` | BG1 4bpp text tiles |
| `$8000–$BFFF` | BG3 2bpp UI tiles |
| `$C000–$C7FF` | OBJ tiles |
| `$C800–$C9FF` | BG2 clipped paper-mask tiles |
| `$E000` / `$E800` / `$F000` | BG1 / BG3 / BG2 maps |

Palette roles are paper/highlight/dim/ink at 0–3, syntax accents at 4–7, and
selected variants at 8–15. Accent ink becomes normal ink when selected, matching
the GBC style rules. The GB owns OSK content, shift/symbol state and actions;
SNES input queues logical keys for the normal editor loop.

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
Stateful constraints (BOX_LINE within the open box, SCROLL within the text ring,
OSK layer contents) are checked by the receiver model.
ROW_SAME copies the model row, not a VRAM address. BOX/BAR/OSK do not erase the
underlying SNES text model.

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
A timeout is an error indication; it must not silently reset the GB or discard
unsaved text. Automatic visual recovery after takeover remains unproven.

### Launch policy

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

### SGB.DAT container

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
Binding metadata is covered by CRC too. The overlay container reserves one page;
the resident replacement must fit the audited renderer interval, not all `$1D00`
bytes. Validate the entire file before overwriting host code or launching the
SNES program.

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

## Planned controls (Phase 9)

Target setup: gamepad in port 1, mouse in port 2. Full mappings, repeat, pad 2
and both-port mouse support are pending; this table is the proposed mapping.
Basic navigation and X-to-toggle-OSK are implemented. Conflicting proposed
Select+R bindings must be resolved during Phase 9.

| SNES | Action | Sent as |
| --- | --- | --- |
| D-pad | Move cursor (repeat after 300 ms, then every 50 ms) | arrows |
| Y + D-pad | Select | Shift+arrows |
| L / R | Page up / page down | `KEY_PGUP`/`KEY_PGDN` |
| Y + L / R | Line start / end | Home / End |
| Select + L / R | Document start / end | Ctrl+Home / End |
| B | Backspace | Backspace |
| A | Type the OSK key (OSK open), otherwise newline | key / Enter |
| X | Show/hide OSK | (existing OSK toggle) |
| Start | Menu | Escape |
| Select + Y / X / A | Cut / copy / paste | Ctrl+X/C/V |
| Select + B / Select + R… | Undo / redo | Ctrl+Z / Ctrl+Y |
| Pad 2 | Same map | |

**Mouse:** left click places the cursor, chooses menu items, browser rows (double
click opens) and OSK keys. Left drag selects, and dragging past the top or bottom
edge auto-scrolls. Right click opens the menu at the pointer (a context menu with
cut/copy/paste comes later). Sensitivity cycles with right+left click on the top
bar (the mouse's 3 hardware speeds). A future option: a scrollbar on the overlay
fed by `LinesBefore`.

PS/2 requires the SGB2 link port. The BIOS-only SNES mouse bridge is hidden
after fullscreen takeover; physical keyboard choices and TEST remain available.

## Build phases

| Phase | Scope | Status / exit check |
| --- | --- | --- |
| 0a | BIOS upload + JUMP, green screen | Passed in Mesen and on hardware (2026-11-16); revision unrecorded |
| 0b | LCD channel, mailbox and throughput | Mesen and SGB1 flow-control checks pass: 66 good, 6 rejected captures, 0 missed rows, RAM audit 0; hardware rate counters unrecorded, SGB2 untested |
| 0c | BIOS return and launch policy | Non-destructive return passed in Mesen; hardware inconclusive; manual reset chosen |
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
| SGB BIOS | Default `~/Downloads/program.rom`; override `SGB_BIOS`; SGB2 dump still needed |
| GB-side SGB boot ROM | Default `~/Downloads/sgb1.boot.rom`; override `SGB_BOOT` |
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

The production build now produces `bin/SGB.DAT` from the real cc65/65816 kernel,
fonts and the renderer overlay bound to `GBCOS.BIN`. `make assemble` stages it
with the existing OS/data/modules; its normal mounted-card copy includes it.
For a build without copying to the card, pass `SD_MOUNT=/tmp/fatpak-no-sd`.
Copy `SGB.DAT`, `GBCOS.BIN`, `EDITOR.DAT` and `MODULES/SGBBOOT.MOD` from the same
build into `GBCSYS`. The container checks the OS checksum before takeover.
Fullscreen starts only through **SETTINGS → SGB FULLSCREEN**. Missing data leaves
the BIOS renderer active. DMG/CGB startup is unaffected.

First fullscreen hardware report: takeover took several minutes, then displayed
a dark blue screen with one row of light blue tiles halfway down, starting one
tile from the left. Console/SGB revision was not recorded. Fullscreen is now
menu-only so probes remain accessible. Phase 7 has not passed. Mesen validates
BIOS upload, ICD2 transport and PPU output separately from the OS frontend;
the complete fullscreen EverDrive/SGB combination remains unverified. The separate
Phase 0b bench now completes on SGB1 after the slot-1 publication fix above.

Record console/SGB revision, cart/OS build and keyboard/controller setup with
all results. Use a gamepad in port 1; leave the mouse in port 2. A keyboard can help inspect text while the full pad
mapping is developed.

- [ ] SGB1: cold boot reaches BIOS-mode browser; SETTINGS → SGB FULLSCREEN reaches
      a readable fullscreen title/status and file list.
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

A runtime transport fault currently stops page publication and preserves the GB
state; automatic visual recovery after SNES takeover is not established. Save
before stress tests. Fullscreen game launch, cart-button return and reset/BIOS
handoff are Phase 10 work; the non-destructive Phase 0c probe is insufficient to
prove that cycle after replacing SNES VRAM/CGRAM.

Use copies of small source files for edit/save checks. Capture a photo and the
precise last action if a check fails, especially any cold-boot stall, black screen
or change in the diagnostic counters.
