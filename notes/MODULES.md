# Loadable modules

[Architecture](ARCHITECTURE.md) · [TODO](TODO.md)

A **module** is a separately linked `.MOD` file; the **overlay loader** swaps it
into an OS page for one call and puts the page back. The model follows CP/M
`.OVL` overlays ([LINK-80 Operator's Guide, Appendix E](https://www.bitsavers.org/pdf/digitalResearch/cpm/LINK-80_Operators_Guide_Dec80.pdf)):
fixed load address and length, sharing memory with the host program.

Status: six modules pass in Gearboy (DMG and CGB). KEYTEST, CLOCK, FILEINFO and
the first ASM work on hardware; HELP, THEME and ASM's three-page version (ABI 5)
haven't been tried there yet.

| Module | ID | ABI | Host | Size |
| --- | --- | --- | --- | --- |
| `KEYTEST.MOD` | 1 | 1 | SETTINGS > KEYBOARD TEST (`keyboard/test.c`) | 1,311 B |
| `CLOCK.MOD` | 2 | 2 | SETTINGS > CLOCK (`rtc/menu.c`) | 1,009 B |
| `FILEINFO.MOD` | 3 | 2 | FILE > INFO, Select (`browser/info.c`) | 3,141 B + 43 B BSS |
| `HELP.MOD` | 4 | 3 | HELP, F1 (`editor/help.c`) | 327 B + 34 B BSS |
| `THEME.MOD` | 5 | 3 | SETTINGS > THEME (`ui/theme.c`) | 510 B |
| `ASM.MOD` | 6 | 5 | FILE > BUILD, RUN (`editor/build.c`), [ASSEMBLER.md](ASSEMBLER.md) | wide, 3 pages: 7,110 + 5,637 + 6,202 B, 2,315 B BSS |

## Rules

- One module at a time, synchronous, on the OS stack. `module_busy` rejects
  nesting (`FR_LOCKED`).
- Borrows **page 13** (`$A000-$BCFF`, 7,424 bytes) for code, constants and BSS.
  Nothing in page 13 may run meanwhile: SGB setup, keyword tables and
  `KeywordLookup` (so nothing may re-lex text: no `Render`/`ShowMessage`),
  `f_stat`/`f_unlink`/`f_mkdir`/`f_rename`, `fs_Rename`, `fs_Copy`,
  `fs_CloseLarge`, cheat and snapshot-path helpers. `check_module_abi.py`
  enforces this for every ABI entry and interrupt handler.
- No relocation, callbacks, initialized writable globals (`_GSINIT` is rejected),
  SDCC arithmetic helpers, or host pointers into module memory after return.
- **Wide modules** (`MODULE_FORMAT_WIDE`, `"sources2"` in `modules.json`) also
  borrow **page 12** (`MODULE_PAGE2`), with `"sources3"` **page 5** too
  (`MODULE_PAGE3`), and keep their BSS in the editor's WRAMX
  buffers (`MODULE_BSS`, `$D000`, 3,072 bytes: `tile_buffer` to the lexer
  state), saved to PSRAM meanwhile. Calls between pages go through
  `ModFar` thunks that `module_build.py` generates (a resident far call, like
  `bank_split.py`'s; each page has its own thunks); a pointer from one page into
  another's code or constants is rejected at build time, because that page isn't
  mapped when it would be read. Nothing in pages 12 or 5 may run meanwhile either
  (page 12: `BeginView`, `NameChar`, `ShowGameProgress`, `fs_GameCopy`, the game
  RTC and registry; page 5: most of the editor, browser and `JoinPath`), and
  nothing may draw, since `tile_buffer` is the module's BSS: the checker keeps the
  entries a wide module uses (`build/modules/wide.txt`) out of all three pages.
  One audited exception: FatFs reaches `get_fattime` (page 12) only when creating
  or writing a file, and `ModFile` only reads, so the wide walk doesn't follow it.
- Host pattern: show a busy box, set `module_context` if the module needs input,
  `RUN_MODULE(NAME)`, and on a nonzero result `ShowModuleError`. The module hides
  or replaces the box when it draws. The host restores layout and flags after,
  and does anything that needs page 13 (THEME's host saves the swap file when
  `module_status` says the theme changed).

## Single sources

| What | Where | Read by |
| --- | --- | --- |
| Page, PSRAM blocks, ABI version, table address/slots, header offsets, error codes | `src/constants.asm` | asm, C (`constants.h`), Python (`utils.constants()`) |
| ABI entries, in table order, with the ABI version that added each | `modules/abi.json` | `module_build.py`, `check_module_abi.py` |
| Module names, IDs, sources (`sources2` makes a wide module) | `modules/modules.json` | `module_build.py` → `build/modules/modules.h` |
| Second page, BSS region, source chunk | `src/constants.asm` (`MODULE_PAGE2`, `MODULE_BSS*`, `MODULE_SOURCE_CHUNK`) | asm, C, Python, `src/wram.asm` asserts the region |
| Joypad bits | `src/pad.h` | host (`input.h`) and modules (`sdk.h`) |
| Row names `HEADER_LINE`, `STATUS_LINE` | `src/constants.asm` | host and modules |

## Pieces

| File | Role |
| --- | --- |
| `module_build.py` | `--headers`: `build/modules/{sdk.h,modules.h,imports.inc,table.inc}`, rewritten only when changed. Default: also builds every module into `bin/MODULES/<NAME>.MOD` |
| `check_module_abi.py` | Walks the ABI entries' and interrupt handlers' call graphs (C from SDCC output and `.banks`, asm from an audited allowlist); fails on page 13, an unaudited asm routine, or `runtime.c` leaving FIXED/ROM0 |
| `modules/lib/text.c` | `PutText`, `PutNumber` (32-bit, by subtraction), `PutNumber2`, `PutHex` |
| `modules/info.h` | `InfoContext`, shared by FILEINFO and its host (uses FatPak's `FileEntry`/`FileDetails`) |
| `src/modules/runtime.c` | `RunModule`, `ShowModuleError`, `ModuleAPI*` wrappers, marshaling (all FIXED) |
| `src/modules/runtime.asm` | PSRAM asserts, `ModuleSwap` (either page), `ModuleSwapRAM` (the WRAMX region), `ModuleCompare`, `ModuleCRC`, `ModuleEnter`, `ModuleAPIFar`, the table |
| `src/fatfs/fatfs.c` | `fs_LoadModule`: validate and stage (FIXED) |

The Makefile gives the generated headers a real rule (C recompiles only when
their content changes); `make modules` always rebuilds the `.MOD` files.
`make assemble` builds modules first, runs the checker after linking, and copies
`*.MOD` to a mounted card.

### Build

Each source compiles with the main build's SDCC flags (including
`peephole.def`). `module_build.py` keeps only `_CODE` (ROMX) and `_DATA` (WRAM0)
fragments, rejects other sections, symbols defined twice across a module's
sources, and any `_`-symbol not defined locally or in the SDK. It emits one
`LOAD` block at `$A000` in page 13: code and literals, `ModulePayloadEnd`, BSS,
`ModuleEnd` (asserted ≤ `$BD00`). Imports are `DEF _ModX EQU $7Fxx` from
`imports.inc`, never `GBCOS.sym`. The header's ABI is the newest version among
the entries the module actually references, so a module that sticks to older
entries runs on older hosts.

A wide module gets a `LOAD` block for page 12 from its `sources2` (and page 5
from `sources3`), a
`WRAMX[$D000]` section for every source's BSS, and `_X__far` thunks (`call
_ModFar`, `DB page`, `DW _X`; `__far2`/`__far3` in the later pages) appended to
whichever page calls `_X` in another; `call`/`jp` lines are rewritten to them and any other cross-page symbol
reference fails the build. `ModuleMain` must be in the first page.

### File format

32-byte little-endian header (offsets are `MODULE_H_*`), then the payload:

| Offset | Size | Field |
| --- | --- | --- |
| 0 | 4 | `FPKM` |
| 4 | 1 | Format (1) |
| 5 | 1 | ABI the module needs (1 to host's `MODULE_ABI`, else `MODULE_ERR_ABI`) |
| 6 | 1 | Module ID (must match the caller's) |
| 7 | 1 | Page (13) |
| 8 | 2 | Load address (`$A000`) |
| 10 | 2 | Entry offset (< length) |
| 12 | 2 | Payload length (1-`$1D00`; file size must equal 32 + length) |
| 14 | 2 | BSS offset (≥ length) |
| 16 | 2 | BSS size (BSS end ≤ `$1D00`) |
| 18 | 2 | CRC-16/CCITT of payload (`binascii.crc_hqx`, init `$FFFF`; wide: both pages' bytes in order) |
| 20 | 1 | Wide: second page (12); otherwise zero |
| 21 | 2 | Wide: second page's payload length, which follows the first in the file |
| 23 | 1 | Wide with three pages: third page (5); otherwise zero |
| 24 | 2 | Its payload length, after the second's; zero without a third page |
| 26 | 6 | Zero |

Format 2 (`MODULE_FORMAT_WIDE`) uses those fields; its BSS offset is 0 and its
BSS size counts WRAMX bytes (≤ `MODULE_BSS_SIZE`).

### PSRAM

| Blocks | Use |
| --- | --- |
| `$3d00-$3d54` | `EDITOR.DAT` v5 |
| `$3d55-$3d64` | Filename undo history |
| `$3d80-$3d8e` | `MODULE_STAGE`: staged page (14 sectors + 256 bytes, zero past payload) |
| `$3d90-$3d9e` | `MODULE_BACKUP`: the OS page |
| `$3da0-$3dae`, `$3db0-$3dbe` | `MODULE_STAGE2`, `MODULE_BACKUP2`: the same for page 12 (wide modules) |
| `$3dc0-$3dce`, `$3dd0-$3dde` | `MODULE_STAGE3`, `MODULE_BACKUP3`: the same for page 5 |
| `$3de0-$3de5` | `MODULE_BSS_BACKUP`: the editor's WRAMX buffers while a wide module runs |

`runtime.asm` asserts these stay clear of the large-file add buffer, snapshot
staging (`$3c00-$3ca3`) and game metadata (`$3e2f`), and that the table fits
below `$8000`. Copies never touch the final sector's upper 256 bytes.

### Call sequence (`RunModule`)

1. `fs_LoadModule` opens the file with a private `FIL` (an open large document is
   untouched), validates the header, reads 512 bytes at a time into `buffer`
   with `ModuleCRC` (assembly, ~180 cycles/byte), zero-pads to the full page and
   copies to staging. Window block and `$BD06` are restored on every exit.
2. `ModuleSwap(0)` backs up page 13, `ModuleSwap(1)` installs staging. Every
   block is compared after it's copied (`ModuleCompare`, ~32 cycles/byte). Both
   wait for HDMA, allow only STAT during the copy, and restore IE/IF,
   `loaded_bank`, `$BD06` and the window block.
3. `ModuleEnter` maps page 13 and calls `module_entry` with `de` =
   `module_context`. The module's result goes to `module_status`. ABI calls go
   through `jp` stubs at `$7F00` to FIXED wrappers; far calls from there return
   to page 13.
4. `HideBox`, then `ModuleSwap(2)` restores the page. If the backup or install
   doesn't read back, the module never runs and the page is restored; if the
   restore doesn't read back, `RestartDevice`. The window block is put back to
   what it was before the call.

A wide module adds, between the first install and the run: `ModuleSwap(4)` and
`(5)` for page 12, `(8)` and `(9)` for page 5 if it has a third page, and
`ModuleSwapRAM(0)`, which saves the WRAMX region to PSRAM and zeroes it; after
the run `ModuleSwapRAM(2)`, `ModuleSwap(10)` and `ModuleSwap(6)` put them back
before `HideBox`. Each step that fails to read back restores only what was
installed so far. `ModuleAPISource` selects the text buffer's PSRAM high block
around `tb_Read`, since the module may have moved the window.

| Result | `ShowModuleError` |
| --- | --- |
| `FR_NO_FILE`, `FR_NO_PATH` | MODULE MISSING |
| `FR_INVALID_OBJECT` (any header, size or CRC problem) | MODULE DAMAGED |
| `MODULE_ERR_ABI` | MODULE NEEDS NEWER OS |
| `MODULE_ERR_VERIFY` | MODULE LOAD FAILED |
| other FRESULT | `ShowError` (NO SD CARD, SD ERROR n, ...) |

### ABI

The table at `MODULE_TABLE` (`$7F00`, bank 1) reserves `MODULE_SLOTS` (32)
entries. Entries are append-only; changing one's meaning needs a new entry.

| Entry | ABI | Does |
| --- | --- | --- |
| `ModVersion` | 1 | Host ABI version |
| `ModRow(row, text)` | 1 | Draws a text row from column 0 (last row as footer, with clock) |
| `ModFrame` | 1 | `EditorDraw`, `WaitFrame`, new pad presses (`PADF_*`) |
| `ModEvent` | 1 | `KBPopEvent` |
| `ModListen` | 1 | `KBListen` |
| `ModKeyboard(state)` | 1 | Keyboard type, ring write index, byte and error counters |
| `ModScan(index)` | 1 | Scan code (low) and error bits (high) from the ring |
| `ModBox(text)` / `ModHideBox` | 1 | Busy box (≤19 chars) |
| `ModClock(clock)` | 1 | `ClockRead` via a host copy |
| `ModText(row, col, text)` | 2 | `DrawRow` on text rows, `HEADER_LINE` or `STATUS_LINE` |
| `ModKey` | 2 | `EditorDraw`, then `MenuKey` (`KEY_*`, 0 for none) |
| `ModMenu(lines, count, selected)` | 2 | Menu box from `count` lines of `BOX_STRIDE` chars (≤11), `selected` 0-based or `0xFF` |
| `ModClockSet(clock)` | 2 | `ClockWrite` via a host copy; 0 = set |
| `ModData(offset, dest, length)` | 3 | Copies `EDITOR.DAT` bytes (offset from its first block) through the window; 1 if not loaded or out of range |
| `ModScroll(down)` | 3 | `ScrollRows`: rotate the text rows one row, keeping drawn rows |
| `ModDraw` | 3 | `EditorDraw` |
| `ModTheme(theme)` | 3 | `0xFF` reads it; otherwise sets light/dark, `ThemeApply`, `SettingsSave`. Returns the theme |
| `ModSource(pos, dest)` | 4 | Up to `MODULE_SOURCE_CHUNK` (128) bytes of the text buffer from `pos`; returns the count, 0 past the end |
| `ModFar` | 4 | Not called from C: the resident far call behind a wide module's thunks (`FarCallInline`) |
| `ModFile(path, block)` | 5 | Reads a whole file (< 64 KiB) into PSRAM from `block`: the path is relative to the open document's folder, else its base name is tried there. Returns the length, 0 if unreadable, `$FFFF` if too big |

Pointer rule: wrappers run with page 13 mapped, so they read module memory
directly but copy it into host memory (`buffer` or the stack) before calling
anything paged, and copy results back after. `buffer` is the 512-byte FatFs
sector buffer, so a future file API must not share it with a pending string.
`module_context` and anything it points to must be host WRAM.

## Tests

- `tests/test_modules.py`: packer bounds, ABI range, import and duplicate-symbol
  rejection, per-module ABI stamping, wide packing (thunks generated, cross-page
  pointers rejected); writes fixtures (every header field corrupted, short,
  trailing, empty, ABI 0 and too new, context echo, max size, a wide module that
  calls across its pages and checks its BSS, a three-page one (13 to 5 to 12 and
  back), and wide headers with a bad second or third page, length or BSS size).
- `tests/run_modules.sh` (DMG, CGB): swaps read back and preserve mapping, IE and
  window; byte-identical page restore; nested call rejected; missing, malformed
  and wrong-ABI files rejected with the page untouched; an ABI 1 module runs;
  `module_context` arrives in `de` and is cleared; `module_status`; BSS zeroed;
  literals marshaled; max-size page; open large document survives; stack guard;
  the wide fixture runs twice with zeroed BSS, page 12 and the WRAMX buffers
  come back byte-identical, the three-page fixture brings page 5 back too, and
  the malformed variants are rejected.
- `tests/run_build.sh`: ASM.MOD end to end ([ASSEMBLER.md](ASSEMBLER.md)).
- `tests/run_browser_menu.sh` (DMG, CGB): KEYBOARD TEST, the clock's fields,
  selection and editing, and every info field for text, folder and game files
  (including DMG/dual flags and MBC2 with a bad checksum) through the real
  modules. `PutSize`'s 32-bit cases run inside FILEINFO.MOD's page. Help opens
  in both contexts and scrolls one row, redrawing only the incoming block. THEME
  turns dark mode on and off (DMG `BGP`/`OBP0`/`OBP1`, CGB palette RAM), keeps
  it over an emulated power cycle, and loads an old `SET2` record as light.
  Every built `.MOD` is installed on the test card.

## Timing

Gearboy, FILE > INFO on a small text file, from the button press to the page:

| | DMG | CGB (double speed) |
| --- | --- | --- |
| Host inspect + header | 14 frames | 7 frames |
| Module load + 3 swaps + draw | 41 frames (0.68 s) | 20 frames (0.33 s) |

The swaps cost about 7 frames each on DMG; loading FILEINFO about 20 (CRC ~8).
The busy box stays up throughout, so nothing looks frozen.

## Next steps

- **Speed**, if hardware feels slow, in order of payoff:
   - Back up page 13 once per boot: on later runs compare the page against the
     backup instead of copying (one compare instead of copy + compare), and only
     recopy on a mismatch.
   - Stage and install only the payload's sectors, then zero the rest of the
     page directly, instead of copying 15 sectors every time.
   - `ModuleCRC`: keep the data pointer in a register instead of push/pop.
- **Verification failure path:** Gearboy can't make a copy read back wrong, so
   `MODULE_ERR_VERIFY` and the restart path are untested. A test-only fault hook
   (or a Gearboy write-drop option) would cover them.
- **More extractions:** pick by `check_pages.py`; good candidates are
   self-contained screens with no file writes. Pages 7 and 14 have 0 bytes free.
- **Theme editor:** grow THEME.MOD's menu (UI and syntax colours, saved as more
   settings after `theme`); theme the in-game menu.
- **Wide modules** cost two page swaps per extra page plus the WRAMX save and a
   far call per cross-page call (`ASM.MOD`'s three pages take about 230 frames to
   load and swap on DMG); a module can't draw while it runs. There is no fourth
   page to borrow and the BSS region can't grow (WRAMX is full): next would be
   BSS in PSRAM through accessors, or keeping a module installed between runs.
- **Later:** a module discovery UI; reuse for `SGB.DAT`'s GB backend
   ([SGB.md](SGB.md)); file writes for modules (listings).
