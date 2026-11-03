# Architecture

TEXT EDITOR is a Game Boy text editor built on the Béisbol game engine. It runs on DMG, GBC, and SGB, and is meant for the EverDrive GB X-series flash carts, which let it read and write `.txt` files on the SD card. The editor lives in `src/editor` and `src/fatfs`. Everything else in `src` is the engine: graphics, sound effects, input, UI, and so on. The engine is kept so that future projects can do more than edit text.

This document explains how the pieces fit together. [README.md](README.md) covers controls and build commands, and [TODO.md](TODO.md) tracks known issues.

## Toolchain

| Tool | Used for |
| --- | --- |
| [RGBDS](https://rgbds.gbdev.io/) 1.0 | Assembling (`rgbasm`), linking (`rgblink`), and fixing the header (`rgbfix`) |
| [SDCC](https://sdcc.sourceforge.net/) 4.2 (`-msm83 --asm=rgbds`) | Compiling the C files to RGBDS assembly |
| Python 3 + Pillow | Converting assets (images, fonts, sfx, strings) |
| `sfdisk`, `mkfs.fat`, `mtools` | Building the SD card image (`make sdcard`) |
| [Gearboy](https://github.com/drhelius/Gearboy) fork | Emulating the PS/2 keyboard and the EverDrive SD card, and debugging over MCP |

The rule of thumb for languages: **assembly** for anything that touches hardware, runs often, or does heavy lifting (drawing, input, memory, the text buffer, SPI). **C** for the higher level logic (the editor's state, menus, the file API). FatFs is C because it is a third-party library.

## Building

```mermaid
flowchart LR
  subgraph assets["make assets (python)"]
    png[img/*.png] -->|img2rgbds.py| imgasm[img/**/*.asm, .tiles, .tilemap]
    fontpng[ui_font.png, fonts/vwf_font.png] -->|fonts.py| fontasm[img/fonts/font_*.asm]
    border[default_sgb_border.png] -->|sgb_border.py| borderasm[default_sgb_border.asm]
    sav[sfx/*.sav] -->|fxhammer.py| sfxasm[sfx/*.asm]
    csv[data/strings/*.csv] -->|translate.py| strasm[data/strings/*.LANG.asm]
    consts[src/constants.asm] -->|build.py| consth[src/constants.h]
  end
  subgraph c["C (per file)"]
    cfile[src/*/name.c] -->|sdcc| casm[src/*/_name.asm]
    casm -->|bank_split.py, if banks.txt exists| casm
  end
  main[src/main.asm] -->|rgbasm| obj[build/main.o]
  imgasm & fontasm & borderasm & sfxasm & strasm & casm --> main
  obj -->|rgblink, rgbfix| rom[bin/TEXT_EDITOR.gbc + .sym]
```

- **One assembly unit.** `src/main.asm` includes `src/text_editor.inc`, which includes every module (and each module includes its generated assets and the `_*.asm` output of its C file). `rgbasm` runs once and `rgblink` links a single object. The linker places `SECTION`s into ROM banks, except for a few with fixed banks.
- **Generated files are committed** (`img/**/*.asm`, `*.tiles`, `data/strings/*.asm`, `src/*/_*.asm`, `src/constants.h`, the ROM), so `make assemble` works without Python. The asset scripts skip files that are already up to date.
- **Targets:** `make all` (clean, assets, assemble, run), `make assemble` (just the ROM), `make code` (assemble and run in Gearboy), `make sdcard` (64MB MBR + FAT32 image from `sd/`), `make clean`.
- **Languages:** `LANGUAGE=EN|ES|FR|IT|PT|DE|JA` picks which translated strings `data/strings/*.asm` includes.
- **Constants shared with C:** `build.py` turns `src/constants.asm` (`DEF X EQU ...`) into `src/constants.h` (`#define X ...`). Put anything C needs there, and parenthesize expressions.

## Source layout

| Path | Contents |
| --- | --- |
| `src/main.asm` | Cartridge header, boot sequence, starts the editor |
| `src/text_editor.inc` | Includes every module (the include order matters for macros and constants) |
| `src/editor/` | The editor: main loop and menus (`editor.c`), text buffer, renderer, on screen keyboard, SD card driver |
| `src/fatfs/` | FatFs, its disk glue, and the file API (`fatfs.c` includes everything in `lib/`) |
| `src/keyboard/` | PS/2 and iGKB keyboard drivers |
| `src/audio/` | The FX Hammer sfx player |
| `src/tests/` | Optional tests that run before the editor (see Testing) |
| `src/core.asm`, `ui.asm`, `color.asm`, `sgb.asm`, `fade.asm` | Engine: drawing helpers, UI widgets, palettes, SGB, fades |
| `src/gbdk.asm`, `memory1.asm`, `math.asm`, `strings.asm` | Low level helpers (VBlank waits, sprite/tile copies, memory, 8-32 bit math, strings) |
| `src/far_call.asm` | `FarCall`, used by C split across banks |
| `src/input.asm`, `interrupts.asm` | Joypad, interrupt vectors and handlers |
| `src/charmap.asm`, `constants.asm`, `macros.asm`, `hardware.inc` | Character map, constants, macros, hardware registers |
| `src/wram.asm`, `sram.asm` | Shared WRAM variables and buffers, SRAM layout |
| `img/`, `sfx/`, `data/` | Asset sources and their generated assembly |
| `sd/` | Files copied into `bin/sdcard.img` (`make sdcard`, for `GEARBOY_SD_IMAGE`) |
| `*.py` | Asset converters (see Building) and `bank_split.py` |

## Boot

`Main` in `src/main.asm`:

1. `SYS_CHECK` reads the boot ROM's registers and sets `sys_info` (DMG, GBC, GBA, SGB).
2. Clears HRAM (except `sys_info`), sets up the SGB (border, palettes), turns the display off, and copies the OAM DMA routine into HRAM.
3. On GBC: double speed, and loads `DefaultPalettes` (8 background + 8 object palettes).
4. Clears WRAM, sets the stack (`stack_bottom`, 1KB), turns audio on, clears the screen, enables VBlank and serial interrupts, and looks for a PS/2 keyboard (`DetectKeyboard`).
5. Runs the tests enabled in `src/constants.asm`.
6. `TRAMPOLINE _Editor`, the C main loop, which never returns.

## Memory map

### ROM

- **ROM0** (`$0000-$3FFF`, always mapped) holds the interrupt handlers, the boot code, and anything called from more than one ROM bank: memory/math/string helpers, the text buffer, the SD driver, the on screen keyboard, the far call thunks, and the editor's C-callable asm. About 6KB is free. Put new code in ROMX unless it has to be called from several banks.
- **ROMX** (`$4000-$7FFF`, banked) holds everything else. `rgblink` picks the banks. A section is never split across banks, so a section must be under 16KB.

### WRAM

- **WRAM0** (`$C000-$CFFF`): the stack (1KB, FatFs needs a deep stack), the OAM buffer, shared vars (`_a` ... `_z`, `game_state`), keyboard state and queues, text buffer vars, renderer vars, `_font_widths` (256 bytes, page aligned), and all C variables (`--dataseg WRAM0`).
- **WRAMX bank 1** (`$D000-$DFFF`, full on GBC since nothing switches banks): `tile_buffer` (the screen's characters), `bkg_buffer` (what each tile block currently shows), `win_buffer` (chunk buffer for gap moves), `cmd_buffer` (the renderer's row bitmap, page aligned), `str_buffer`, `name_buffer`.

### HRAM

`loaded_bank`, input state, `pad_latch`, interrupt vars, the OAM DMA routine, `vbl_done`, `sys_info`. HRAM is cleared at boot.

### SRAM (MBC5, 16 x 8KB banks, battery backed)

| Bank | Contents |
| --- | --- |
| 0-7 | The text buffer (65,408 bytes, as much as 16 bit positions allow). `$BD00-$BD0F` is never used in any bank (see EverDrive registers) |
| 8 | `sram_tb_signature` ("TXT3") and the engine's save data at `$A000`, the clipboard at `$A040-$BCFF` (length, its complement, then up to 7356 characters) |
| 9-15 | The undo log (57,232 bytes, laid out like the text buffer), see Undo |

SRAM is only enabled (`SRAM_ON`) while it's being read or written, so a power loss is less likely to corrupt it.

## Banking and calling conventions

- **`loaded_bank`** (HRAM) always holds the ROM bank that's mapped. `SET_BANK` writes it and the MBC5 register together. Never write `rROMB0` directly.
- **`TRAMPOLINE Label`** calls `Label` in another bank from asm and switches back. Arguments can only go in `a`, `de`, and RAM.
- **C calling convention** (SDCC 4.2, `sdcccall(1)`): the first argument goes in `a` (8 bit) or `de` (16 bit). The second goes in `e` if the first was in `a`, otherwise `a` (8 bit) or `bc` (16 bit). The rest go on the stack, and the callee removes them. Return values: 8 bit in `a`, 16 bit in `bc`, 32 bit in `debc`. C sees asm labels that start with `_` (`_tb_Insert::` is `tb_Insert()` in C).
- **C code is banked.** Each C file's code lands in a ROMX section. C can call ROM0 asm, and C in its own bank, but not code in other banks. To call C in another bank from C, add a ROM0 stub with `BANKED_C` (`src/macros.asm`). It keeps `a`, `de`, `bc` arguments and return values, so it only works for functions with no stack arguments. The FatFs file API (`FileLoad` etc. in `src/fatfs/fatfs.asm`) is called this way.
- **C files too big for one bank** (FatFs, ~21KB) are split by `bank_split.py`, which runs after SDCC when a `banks.txt` sits next to the `.c` file. It moves listed functions into `ROM0` or other banks (`B`, `C`, ..., unlisted functions stay in `A`, data goes to ROM0), and rewrites every call or jump between banks to go through a generated ROM0 thunk. The thunk saves the caller's bank and return address on a WRAM stack and jumps to `FarCall`, so stack arguments stay where the callee expects them.
- **C restrictions** (SDCC's libraries aren't linked, only RGBDS objects are):
  - Static initializers don't run (`_GSINIT` is never called). Initialize globals in code. WRAM is zeroed at boot.
  - 32 bit multiply and divide use our own `_mullong`/`_divulong` in `src/fatfs/lib/runtime.c`. `memcpy`, `memset`, `memcmp`, `strchr` are in `src/fatfs/fatfs.c`. Avoid 16 bit `*` and `/` in other C.
  - String literals go through the RGBDS charmap, which maps `"\n"` to 128. Use character literals (`'\n'` is 10).
- **SDCC pitfalls:** always compile through the Makefile's flags (`--no-peep --peep-file peephole.def`). Plain `sdcc --asm=rgbds` emits stores through a stale `hl`. SDCC 4.2 also clobbered `hl` in an expression that read a `signed char` global (see `RenderAfterEdit`). If C misbehaves, read the generated `_*.asm`.

## Interrupts

| Vector | Handler | Does |
| --- | --- | --- |
| VBlank | `VBLInterrupt` | OAM DMA, `LatchPad` (records new button presses), time, sound effects, the busy spinner |
| STAT | `LCDInterrupt` | Jumps to the address in `rLCDInterrupt` (`SetLCDInterrupt`). The editor uses `RenderLCDInterrupt` |
| Serial | `SerialInterrupt` | Reads the rest of a PS/2 scan code bit by bit and queues it |
| Timer, joypad | | unused |

## Input

- **Joypad:** `UpdateInput` (called by `WaitFrame` every frame) reads the buttons into `button_state`/`last_button_state` and processes queued keyboard scan codes. Because a screen refresh can take several frames, the VBlank handler also latches new presses into `pad_latch`. The editor reads them with `PadPressed()` so short presses aren't lost.
- **PS/2 keyboard** (`src/keyboard`): the keyboard clocks bits into the link port. `PS2KeyboardInterrupt` assembles 11-bit frames into a 64-entry scan code ring. `ProcessKeyCodes` decodes scan codes through jump tables (`kb_jump_table.asm`) into handlers, which act according to `kb_mode`:
  - `KB_MODE_BUTTONS`: keys act as joypad buttons (Z = A, X = B, arrows, enter = START).
  - `KB_MODE_TYPING`: keys drive the engine's name entry screen.
  - `KB_MODE_EDITOR`: key presses are queued as events (key + modifiers) for `KBPopEvent`. Printable keys use their character code, special keys use `KEY_*` codes from `src/constants.asm`.
- The link port can't send data to the keyboard, so caps lock and the keyboard's LEDs aren't supported. In Gearboy, Caps Lock enables the emulated PS/2 keyboard. The keyboard is only detected at boot.
- **iGKB** (USB keyboard adapter) handlers exist but detection is disabled.

## The editor

```mermaid
flowchart TD
  loop[Editor loop in editor.c, once per frame] --> keys[KBPopEvent / PadKey]
  keys --> handle[HandleKey / HandleFileKey]
  handle -->|cursor key| moved[PlaceCursor: move sprite 0 using the row tables]
  handle -->|edit| edit[tb_Insert / tb_Delete, then RenderAfterEdit: rescan rows until they realign]
  handle -->|scroll one row| scroll[ScrollRing + tb_ScrollRows + tb_RenderRows on the new row]
  handle -->|menu, load, jump| full[Refresh: tb_Render every row]
  edit & scroll & full --> draw[EditorDraw: RenderRow draws rows whose characters changed]
```

### Main loop (`src/editor/editor.c`)

Each frame `Editor()` waits for VBlank, pops keyboard events, and reads the joypad (`PadKey`, which also drives the on screen keyboard). `HandleKey` sets one of these flags:

| Flag | Meaning | Work done |
| --- | --- | --- |
| `moved` | The cursor moved, the text didn't change | `PlaceCursor` finds the cursor's row in `tb_row_starts` and moves the sprite |
| `edited` | One insert or delete | `RenderAfterEdit` rescans from the row before the edit until a row starts where it used to, plus or minus the edit |
| `redraw` | Rows were scanned without the text changing (scrolling) | `Draw`: selection, bars, `EditorDraw` |
| `dirty` | Anything else (menus, loading, several edits at once) | `Refresh` renders every row and scrolls to keep the cursor visible |

Moving the cursor sets `bars_changed`, so the status bar is redrawn at the start of the next frame. The status bar's line number is `LinesBefore(top)` plus the rows above the cursor that end with a line feed. `LinesBefore` remembers the last position it counted to (`counted_pos`) and only counts the line feeds between that and the new position with `tb_CountLines`, which reads SRAM a run at a time. Single character edits before `counted_pos` adjust it, and bigger ones reset it to 0.

Menus (`Choose`) are a box over the text (see Rendering).

Nothing should look frozen. Work the editor knows is slow shows a box first, drawn right away with `ShowBusy`: "Loading..." (with the new path already in the file name bar) before mounting the card, reading a folder, or opening a file, "Saving..." before saving. Everything else is covered by the busy spinner: `WaitFrame` sets `busy_frames` to 1 after each VBlank and 0 while waiting, and `UpdateBusy` in VBlank counts it up and shows an animated sprite in the top right corner once the main loop hasn't waited for a frame in `BUSY_DELAY` frames. Work that takes less than that never shows it. The help screen, file browser, messages, and the save as prompt draw characters straight into `tile_buffer` rows and call `EditorDraw`. Help hides the bars (`BeginFullScreen`), the browser always shows them. Messages go in the status bar and the save as prompt in the file name bar when they're shown. File operations call into FatFs through the `File*` stubs. When the editor isn't running on an EverDrive, it moves the text buffer's gap to the end a little at a time once input stops (`tb_NormalizeStep`).

### Text buffer (`src/editor/text_buffer.asm`)

A [gap buffer](https://en.wikipedia.org/wiki/Gap_buffer) in SRAM banks 0-7. Positions are logical (the gap excluded). Physical offsets include the gap and map to a bank and address, skipping `$BD00-$BD0F` in each bank.

- **The gap is always zeroed and text never contains 0**, so `tb_Load` recovers the buffer from SRAM with no metadata: text, zeros, text (`TBFindPhys` scans a run at a time). When the gap is at the end, the `.sav` file reads as plain text.
- **Gap moves** (`TBMoveGap`) copy runs of up to 256 bytes that don't cross a bank or the register hole, through `win_buffer` when the banks differ, and zero what they leave behind. The gap only moves when text is edited away from it. On an EverDrive, where files are saved to SD, the gap stays put. Elsewhere it's moved to the end when idle so the `.sav` is the only copy you need.
- **Rows** (`TBScanRow`) are up to 160 pixels (character widths from `_font_widths`) and 40 characters. A row ends after a line feed, wraps after the last space when a word doesn't fit, and lets spaces and a line feed after a full row hang off its end. Control characters are drawn as spaces. With line wrapping off (`tb_nowrap`, Alt+Z) a row is a whole line: its first `tb_left` characters and the ones that don't fit aren't drawn, so `tb_row_starts` are still line starts and a drawn column is `pos - row start - tb_left`. `ScrollX` in `editor.c` changes `tb_left` when the cursor's character isn't drawn, leaving 40 pixels of text left of the cursor when it scrolls right (more near the line's end) and 120 when it scrolls left, and `Refresh` renders again.
- **Row tables:** rendering records `tb_row_starts` (where each visible row starts, then the row after the last), `tb_row_counts` (characters drawn), and `tb_end_row` (the row the end of the text is on). Cursor movement, partial rendering, and scrolling all work from these instead of scanning SRAM.
- **Settings** (`src/sram.asm`): `SettingsSave` copies the variables in `SettingsTable` (font, `tb_nowrap`, `bars_on`, and the open file's `fs_crlf`, `modified`, `file_dir` and `file_name`) to SRAM bank 8 right after the EverDrive registers, behind a signature, and `SettingsLoad` copies them back when the editor starts. The editor saves them when one changes: the toggles, opening, saving and new files, and the main loop when `modified` changes.
- **Selection and clipboard:** `tb_DeleteRange` grows the gap over a range, `tb_Copy` copies a range to the clipboard in SRAM bank 8 and `tb_Paste` inserts it, both 256 bytes at a time through `win_buffer`. The editor keeps the selection as `anchor` and `cursor`.
- **Undo** (`src/editor/undo.c`, in its own bank behind `BANKED_C` stubs, with its copy loops in `undo.asm`): a ring of records in SRAM banks 9-15, each a header (length, type, position), the inserted or deleted text, then the length again so undo can walk back. `undo_head` is the current state, records after it up to `undo_top` can be redone, the oldest are dropped when it's full. Typing a word, or holding delete or backspace (stored last char first), merges into one record until the cursor moves. Typing or pasting over a selection is joined to the delete so they undo together. `undo_saved` remembers where the text was saved so undoing back to it clears the modified flag. The history isn't kept when the power is off.
- `tb_Render` (all rows), `tb_RenderRows` (a range), and `tb_ScrollRows` (shift `tile_buffer` and the tables one row) fill `tile_buffer`, which holds 18 rows of `TB_STRIDE` (40) characters.

### Rendering (`src/editor/render.asm`)

Text is drawn as pixels so fonts can be any width. Every screen cell has its own tile, which takes 360 tiles, but the background can only address 256 at a time. So:

- **Tile blocks:** each row draws into a block of 20 tiles. Blocks 0-5 are only reachable with `$8000` tile data, 9-14 only with `$8800`, and 6-8 and 15-17 use tiles both modes can reach. Tiles 0 and 1 are the cursor and keyboard highlight sprites.
- **Layout:** `Layout` in `editor.c` fills `render_row_blocks`, `render_row_lines` (the `tile_buffer` row to show) and `render_row_fonts` for each screen row, and points the BG map rows on screen at their blocks. Text rows use the blocks in a ring starting at `ring_pos`. With the bars shown, the file name bar (screen row 0, `tile_buffer` row 18) keeps block 8 and the status bar (row 17, `tile_buffer` row 19) keeps block 17, so text uses the other 16. Both bars are drawn fully selected. `render_text_top` is the screen row of text row 0, used by the cursor and the on screen keyboard, which is drawn into the `tile_buffer` rows after the text (`tb_rows`).
- **Mode switches:** `RenderLCDInterrupt` switches the tile data mode partway down the screen, at most twice per frame, in the middle of a shared band. The PS/2 interrupt can delay the switch by several lines without anything showing.
- **Scrolling** rotates the ring by one block: the block that leaves the screen draws the new row and SCY moves 8 pixels. `Layout` then re-points the BG map rows whose block changed: the new row's, and the bars', which don't have to be drawn again. The new SCY and switch points are staged in `render_pending_*` and applied together at line 144. Only whole rows scroll, because there aren't tiles for a 19th row on DMG.
- **Row cache:** `bkg_buffer` holds the characters each block shows and `row_font` its font. `RenderRow` skips rows that haven't changed, so after a scroll or an edit only one or two rows are drawn.
- **Drawing a row:** glyphs are ORed into a 160x8 1bpp bitmap with 4KB of precomputed shift tables (in the renderer's bank, 4KB aligned), then each byte is written to VRAM, 4 bytes per HBlank. Bitplane 1 is the byte and bitplane 0 is the byte XOR the tile's selection mask, so text is color 3 on color 0 and selected text is color 2 on color 1.
- **Menu box:** `render_box_*` put a box over screen rows: its pixel x and width, its text (`BOX_STRIDE` chars per line, `tile_buffer` rows 20 and on), and the highlighted row. `RenderBox` clears the box's pixels after a covered row's text is drawn, then draws the box's line in the variable width font, its border, and the highlight. Its first and last rows are half rows holding the top and bottom border, so the text around it stays visible. Each block remembers the box line it was drawn with (`RenderBoxSig`, which includes `render_box_gen` so a new box redraws), so opening, moving through and closing a menu only draws the rows it covers. `RenderTextWidth` measures the lines so `Choose` can size and center the box.
- **Selection:** before drawing, the editor sets `render_sel` (first and end column of each row, end `$FF` for the right edge) from the selection and the row tables. A row whose selection changed is redrawn. The palettes set in `EditorSetup` show colors 1 and 2 as inverted on DMG (BGP) and as a blue highlight on GBC and SGB (palette 0). The cursor turns white at the start of a selection (OBP1) so it shows on DMG.
- **Fonts:** `fonts.py` converts `img/ui_font.png` (fixed width, 8 pixels), `img/fonts/fixed_font.png` (fixed width, 4 pixels) and `img/fonts/vwf_font.png` (variable width) into 8 bytes of 1bpp glyph rows and a width per character code. Text uses the 4 pixel font (the default) or the variable width font (Ctrl+F, `ToggleFont`, which lays the rows out again for their new font). Rows below `tb_rows` (the on screen keyboard) always use the 8 pixel font, and the bars and help screen the variable width font.
- **Cursor:** sprite 0, a 1 pixel line. `RenderCursorX` adds up character widths in the cursor's row. Glyphs end with their 1 pixel gap, so rows (except the 8 pixel font's, the on screen keyboard) are drawn 1 pixel to the right: the left edge gets a gap and the cursor sits in the gap before its character.

### On screen keyboard (`src/editor/osk.asm`)

Five rows of ten keys drawn into the bottom rows of `tile_buffer` (the text area shrinks to 13 rows). Layers are lowercase, shift (one shot), and symbols, the last row is shift, symbols, space, menu, left, right. Sprite 1, behind the background, highlights the selected key.

## SD card and files

```mermaid
flowchart LR
  editorc[editor.c] -->|File* stubs, BANKED_C| api[fs_Load / fs_Save / fs_List / fs_ListEntry in fatfs.c]
  api --> ff[FatFs, banks A, B and C + ROM0 thunks]
  ff --> glue[disk_read / disk_write]
  glue --> sd[sd.asm: SD over SPI]
  sd --> regs[EverDrive registers $BD00 $BD01 $BD0A]
  api --> tb[tb_Append / tb_Read / tb_ReadLines]
```

- **EverDrive registers** live in cartridge RAM space and respond after `$A5` is written to `$BD0A`: `$BD00` SPI data, `$BD01` SPI control (busy, auto read, slow clock, chip select). `sd.asm` disables SRAM before using them and locks them again afterwards. In case writing `$A5` to `$BD0A` unlocks them even while SRAM is enabled, the text buffer never stores anything at `$BD00-$BD0F`. `~/Projects/everdrive-gb` (a disassembly of the EverDrive OS) documents the rest of the registers.
- **`sd.asm`** detects the EverDrive (`sd_Detect` reads back the SPI control register), initializes SD v1/v2/SDHC cards, and reads and writes 512 byte sectors. It's based on TXTReaderGB's diskio. The sector loops exchange 8 bytes per iteration and still check the busy bit for each byte: the EverDrive OS doesn't (it reads with auto read on, `$BD01` bit 2 and `$BD06` bit 0), but it runs at normal speed and the editor runs at double speed.
- **FatFs** R0.16 (`src/fatfs/lib`, configured in `ffconf.h`: FAT only, long file names up to 64 characters as UTF-8 with code page 437 short names, minimized, tiny buffers) is compiled as part of `fatfs.c`, a single C file that also holds `ffunicode.c`, the disk glue, the SDCC runtime helpers (`_mullong`, `_divulong`, `_divuint`), and the file API. `banks.txt` splits it across three ROM banks: the read side in A, the write side and mount in B, long names in C, and the small helpers called for every character (`ld_16`, `sum_sfn`, ...) in ROM0. `memcpy` and `memset` are wrappers around `mem_Copy` and `mem_Set`, `memcmp` and `strchr` are asm (`fatfs.asm`).
- **Mounting:** `fs_Mount` mounts the card the first time. A failed sector read or write clears `disk_ready`, so FatFs mounts it again on its next call, and listing, loading and saving retry once after `FR_DISK_ERR`. A swapped card fails its first command (it hasn't been initialized), so it's mounted again before anything is written to it.
- **File API:** `fs_Load` replaces the text buffer with a file 512 bytes at a time: `tb_Append` copies a run of SRAM at a time, dropping 0s and CRs and setting `tb_cr` when it drops a CR, so `fs_crlf` remembers that the file used CR LF. `fs_Save` writes the buffer (around the gap) with `tb_Read`, or with `tb_ReadLines`, which adds the CRs back, both a run at a time. `fs_List` reads a folder once: `NextEntry` walks the directory's 32 byte slots in the sector buffer the way FatFs's `dir_read` does, without decoding names, skipping hidden, system and dot names. It counts the folders and files and marks the slot where every 16th of each kind starts (in the 512 byte load buffer, which nothing else uses while browsing; when a kind passes 128 marks, every other one is dropped and the spacing doubles). `fs_ListEntry` reads one entry (`FileEntry` in `src/fatfs/file_api.h`: UTF-8 name, size, date) by seeking to the mark before it, or carrying on from the last one read. `GetName` turns its long name into UTF-8 itself, `get_fileinfo` is only used for names it can't handle (characters outside the BMP, short names with bytes above `$7F`).
- **File browser** (`Browse` in `editor.c`): lists folders, then files, with `..` below the root. Names aren't kept in memory: the folder is listed once when it's opened, and the visible rows are read with `FileListEntry` (all of them after a jump, just the new one when the list scrolls a row, which rotates the screen ring like the text does), and the chosen entry again for its full name. Going up a folder looks the folder it came from up by name (`dir_find`) and selects it. Each visible row keeps its kind, size and date for the status bar. The editor keeps the open file's folder (`file_dir`) and name (`file_name`), both UTF-8, and shows them in Latin-1.
- **Gearboy** emulates the EverDrive's SD card on MBC5 carts (menu "EverDrive X SD Card", or `GEARBOY_EVERDRIVE=0` to turn it off). `VirtualFat` (in the Gearboy fork) makes a FAT32 card out of a host folder ("EverDrive X SD Folder...", `GEARBOY_SD_DIR`, or the home folder): folders are listed the first time they're read, files are read from the host, and when the Game Boy writes a folder's entries its new and changed files are written back. `GEARBOY_SD_IMAGE` uses a disk image instead.

## Engine modules

These aren't used by the editor yet, but they work and are kept for future projects:

- **Sound effects** (`src/audio`): FX Hammer sound effects (`sfx/*.sav`, converted by `fxhammer.py`) and the built-in ones in `sfx.asm`, played with `PLAY_SFX` and updated in VBlank. A higher priority effect interrupts a lower one, and the channels an effect used are muted when it ends.
- **UI** (`ui.asm`): boxes, revealed text, list menus, number pickers, and the text entry screen with its own on screen keyboard. These use the 8x8 font tiles (`UILoadFontTiles`), not the editor's renderer.
- **Color and SGB** (`color.asm`, `sgb.asm`, `fade.asm`): GBC palettes and attribute maps, SGB packets (palettes, attribute blocks, borders, sound), and fades. The palette routines and `DefaultPalettes` are in the ROMX section `"Color"`: call them with `TRAMPOLINE`, or put code that uses them in the same bank with `SECTION FRAGMENT "Color", ROMX` (as `fade.asm` and the editor's `EditorSetPalettes` do).
- **Text and translations:** `src/charmap.asm` maps characters to tile indices. Tile index matches the character code (ASCII, Latin-1 for accents, UI glyphs in 0-31). Engine strings come from CSVs in `data/strings`, converted by `translate.py`, and use 128 for a new line. The editor's text uses 10.

## Testing and debugging

- Enable `TESTS_ENABLED` and one of `SOUND_TEST_ENABLED`, `KEYBOARD_TEST_ENABLED`, or `SD_TEST_ENABLED` in `src/constants.asm`. Tests run before the editor starts. The keyboard test shows the last scan code (ASCII, hex, decimal, binary), the scan code and error ring buffers, and the interrupt and error counts; A switches between PS/2 and iGKB, B continues to the editor. It's a `SECTION FRAGMENT` of the keyboard's ROMX section because the key handlers jump into it.
- `bin/TEXT_EDITOR.sym` has every label, so emulators show symbols. `build/main.map` shows where every section landed and how much space each bank has left.
- Gearboy can be driven by an AI assistant or script over MCP (`--mcp-stdio` or `--mcp-http`, add `--headless` to run without a window). Its profiler shows cycles per function, which is how the editor's performance work was measured.
- When changing the text buffer or renderer, compare the screen after an incremental update with a full redraw (open and cancel the menu forces one), and compare saved files byte for byte. Check SD images with `fsck.fat -n` after writing to them.

## Conventions

- Assembly is terse: short `;` comments, routine headers that list register arguments and results (`;de = pos, returns char in a`), local `.labels`, and a list of public routines at the top of each module.
- Labels for C start with `_`, and asm routines called from C get a `_Name::` label. C prototypes for asm live in the C file's header (`src/editor/editor.h`).
- Each module includes `src/text_editor.inc` first, so it can be read on its own.
- Generated files are committed alongside their sources.
