# Assembler

[Architecture](ARCHITECTURE.md) · [Modules](MODULES.md) · [TODO](../TODO.md)

`ASM.MOD` assembles the open `.asm` document on the device into a bootable ROM.
FILE > BUILD (F7) writes `<name>.gb` beside the source; FILE > RUN (F5) builds
and launches it through the normal game path. It assembles an RGBDS 1.0 subset:
a file that builds here builds with `rgbasm`/`rgblink`/`rgbfix -v -p 0` to the
same bytes (that is what the tests check), not the other way round.

Status: includes, conditionals, repeats, macros and rgblink-style placement work
on hardware (DMG01, GBA SP). `EQUS`, string functions, `{}` interpolation,
`PURGE`, `FOR` and `INCBIN` pass on the PC and in Gearboy (DMG, CGB); not yet
tried on hardware. FatPak's own `math.asm`, `memory1.asm` and `gbdk.asm`
assemble byte-identical to RGBDS, unmodified (`memory1.asm` calls
`hardware.inc`'s `rev_Check_hardware_inc`, which builds a macro from an `EQUS`).

## Using it

- Save the file as `.asm` (the language comes from the extension). BUILD saves
  first if the text is modified or unnamed.
- The header's logo, ROM-size byte and both checksums are written for you
  (`rgbfix -v -p 0`); the rest of `$100-$14F` is yours, as in any RGBDS project.
- An error shows in a box with the file's name, `Line <n>` and the message, and
  moves the cursor to that line. In an included file the cursor goes to the
  document's `INCLUDE` line that led there. An error
  in a macro is reported where the macro was used. The first error stops the
  build.
- Success shows BUILT and the ROM size. RUN then launches like a game:
  the editor's text and settings go to the swap file first and come back when
  the game returns or at the next boot.
- Only text-buffer documents (≤ 65,024 bytes) assemble; large files report
  FILE TOO BIG. Included files can be up to 64 KiB each, 16 of them.
- `INCLUDE "path"` is tried relative to the document's folder, then to each
  folder above it, then as a base name in the document's folder. RGBDS resolves
  paths from where it runs, usually a project's root, so `src/main.asm` can
  `INCLUDE "src/keyboard/keyboard.asm"` as it does in a Makefile build, and
  `INCLUDE "src/hardware.inc"` also finds `hardware.inc` beside the source. An
  included file may end without a line feed.
- `INCBIN` finds files the same way; it and `INCLUDE` share the 16 slots, and
  a file used twice is read once.
- **Projects.** A `project.gbp` in the document's folder or any folder above it
  (the nearest wins) makes BUILD and RUN build the project instead, from any
  file in it (a `.md` too), and from `project.gbp` itself:

  ```
  ; beisbol, as its Makefile builds it
  main   src/main.asm
  output beisbol.gb
  rgbasm -D _DEMO -D LANG_EN
  rgbfix -jvcs -k 01 -l 0x33 -m 0x1B -p 255
  ```

  `main` and `output` are paths from the project's folder; `output` defaults to
  main's path as `.gb`. Includes are tried from the project's folder first, as
  `rgbasm` resolves them when a Makefile runs it there. The `rgbasm` and `rgbfix`
  lines take those tools' options: `-D NAME[=VALUE]` (an `EQUS`, `"1"` without a
  value) and `-W...` (ignored); `-v -j -c -C -s` and `-k -l -m -n -p -r -t -i`,
  with the value in the same word or the next, numbers as `$1B`, `0x1B`, `0b11`
  or decimal (`-m` takes numbers, not MBC names). The logo, ROM size and
  checksums are always fixed. Anything else is NOT SUPPORTED at its line, `;`
  starts a comment, a word may be quoted, and the keywords are case-insensitive.
  An error goes in the box with its file and line; the cursor moves to it when
  it's in the open document (`project.gbp` included), and stays otherwise.
  A project build also writes **`build.cache`** beside `project.gbp` (after a
  build that worked) and reads it at the next: where each file's directory entry
  was found (its sector, place and 8.3 name). A file whose entry still has that
  name is read straight from its clusters, without FatFs searching its folder
  (most of the card's time); anything else is searched for as before, so a
  moved, renamed or new file is found, and an edited one reads as it is now (the
  entry has its size and first cluster). `build.log`'s card line says how many
  went through it. Delete `build.cache` to start over; one written for another
  card or volume isn't used.
  `.gbp` files are highlighted like assembly with their four words as
  directives. Without a project, BUILD on anything but assembly says NOT AN ASM
  FILE (after the module looked for one).
- Samples: `tests/asm/` (`hello.asm`, `features.asm`, `strings.asm`,
  `loops.asm`, with `lib/`). The card's `Asm` folder has those plus `math.asm`,
  `gbdk.asm`, `memory1.asm` and `hardware.inc`.

## The subset

| Supported | Notes |
| --- | --- |
| Every SM83 instruction, RGBDS spellings | `ld [hl+]`/`[hli]`, `ldh [c]`/`[$ff00+c]`, `jp hl`/`[hl]`, `add b` without `a,`, `ld hl, sp±e`, `stop` is 2 bytes, `halt` 1 |
| Labels `Name:`/`Name::`, locals `.loop` (colon optional), `Name.loop` references, indented labels | locals belong to the last global label |
| `DEF X EQU`, `DEF X =`, `REDEF X =`, `DEF X RB/RW/RL [n]`, `RSRESET`, `RSSET` | constants must be known on the first pass (no forward references) |
| `SECTION [FRAGMENT] "name", TYPE[addr], BANK[n], ALIGN[n[, offset]]` | ROM0, ROMX (banks 1-63), VRAM, SRAM, WRAM0, WRAMX, OAM, HRAM; up to 512; placed like rgblink (below). Fragments with one name join in source order (attributes count on the first) |
| `PUSHS [section args]`, `POPS` | 8 deep; the label scope comes back too |
| `DS ALIGN[n[, offset]][, fill]` | like rgbasm: pads as far as the section's address or alignment says, then tightens a floating section's alignment |
| `DB`/`DW` (with strings and `\n \t \r \0 \\ \" \'`), `DS n[, fill]`, bare `DB`/`DW` in RAM | |
| `INCLUDE "file"` | nested, and the same file again is read from PSRAM, not the card |
| `IF`/`ELIF`/`ELSE`/`ENDC` | nested to 15 levels; skipped lines aren't parsed |
| `REPT n`/`ENDR`, `FOR name, [start,] stop[, step]`/`ENDR` | nested; `\@` is unique per iteration; the `FOR` variable ends one step past its last value, like RGBDS |
| `MACRO name`/`ENDM`, invocation, `\1`-`\9`, `\@`, `_NARG`, `SHIFT` | arguments split at top-level commas, outside `()`, `[]` and quotes |
| `DEF`/`REDEF name EQUS string`, `"""..."""` (may span lines) | a string symbol used as a word is replaced by its text, as in RGBDS: at a statement's start, in an expression, in macro arguments |
| `{name}`, `{fmt:name}` anywhere but comments, in strings and in the middle of words | numbers default to `$` and uppercase hex; formats `[#][0][width]` and `d u x X b o`; string symbols give their text |
| `STRCAT`, `STRUPR`, `STRLWR`, `STRSLICE` (0-based, negative from the end), `STRSUB` (1-based, deprecated in RGBDS), `STRRPL`; `STRLEN`, `STRCMP`, `STRFIND`, `STRRFIND` in expressions | `\\` in a macro body stays a backslash for the string that reads it |
| `INCBIN "file"[, start[, length]]` | |
| `PURGE name, ...` | names can be defined again (pass 2 too) |
| `CHARMAP "string", value, ...`, `NEWCHARMAP name[, base]`, `SETCHARMAP name`, `PUSHC`, `POPC` | strings in `DB` and character literals go through the current map: the longest entry at each position, unmapped characters as themselves; `'x'` must be one entry of one byte; 8 maps, 60 KiB of entries; `\{` `\}` are literal braces |
| `ASSERT expr[, msg]`, `FAIL` | ASSERT is checked in pass 2 |
| `EXPORT`, `GLOBAL`, `WARN`, `PRINT`, `PRINTLN` | accepted and ignored |
| Expressions | `+ - * / % & \| ^ << >> == != < > <= >= && \|\| ! ~`, unary `-`, parentheses, `@`, `HIGH()`, `LOW()`, `BANK(label or @)`, `DEF(name)`, `_NARG`, `__RGBDS_MAJOR__` etc., `$hex %bin &oct 123 'c'`, fixed point `1.5` (16.16), `_` separators |

Values are 32 bits and signed, as in RGBDS: `/` rounds toward minus infinity,
`%` takes the divisor's sign, `>>` is arithmetic, a shift of 32 or more leaves 0
(or -1) and a negative one goes the other way. `DL` writes 4 bytes. `EQU` and `=`
constants keep all 32 bits (the high word in the symbol's `extra`); labels,
addresses, sizes and instruction operands are 16 bits, and an operand keeps the
value's low bits (RGBDS warns where it differs). 8-bit operands accept -128..255.
`ldh` takes `$FF00-$FFFF` or `0-$FF`. Mnemonics and directives are
case-insensitive, names case-sensitive. Fixed-point literals are 16.16, the
fraction rounded from up to 7 digits (RGBDS reads more; they differ only in
rare last bits). `+=` and the other compound assignments, `**` and `>>>` aren't
read yet. Nesting: 10 frames (includes, macros, repeats and arguments
together), 256 bytes of macro arguments in flight.

Not supported, with the NOT SUPPORTED error: `LOAD`, `UNION`, `CHARLEN`,
`CHARSUB` and the other charmap functions, `OPT`, the `ALIGN` directive,
`SECTION UNION`, `STRFMT`, `\<10>` and named macro arguments.
Names are up to 79 characters (section names 78); nesting is 16 frames. String symbols
are at most 256 bytes; the `EQUS` heap holds 64 KiB over both passes. Old `X EQU`/`X SET` without `DEF` and `ld [c], a` without `ldh` are
gone from RGBDS 1.0 and aren't accepted.

**Placement** follows rgblink, checked against it on thousands of random
layouts. Pass 1 records each section's type, bank, alignment (and its offset),
address and size.
Then, in order: sections with address and bank given (one-bank regions count as
given), then bank only, then address only, then neither; within each, aligned
ones first, then bigger, then the later one in the source. Each goes in the
lowest bank it may use, at the lowest address that fits among those already
placed (each bank keeps a list of its sections by address, so `Link` walks only
the gaps). An empty section goes at its region's start, whatever its offset, and
takes no room. Fixed
sections that overlap are SECTIONS OVERLAP; one that doesn't fit is SECTION FULL,
reported at its `SECTION` line. The ROM is the smallest power of two ≥ 32 KiB
that holds the highest ROM bank used.

## How it works

Two passes. Pass 1 parses everything, sizes every statement (instruction sizes
depend only on syntax), assembles each section as if it started at its region's
base (or its address), and defines labels. `Link` places the sections and
`Relocate` moves every label by its section's offset. Pass 2 parses again from
the start, evaluates and writes bytes. `DS` counts and section addresses must be
known in pass 1 (NOT YET DEFINED otherwise); a label that ends up somewhere else
in pass 2 is a PHASE ERROR (a bug). `DEF()` in pass 2 only sees symbols defined
earlier in pass 2 (a mark bit per symbol), so include guards work.

- **The stream** is a stack of frames that read text by address (`Pos`, 32
  bits): below 64 KiB the document (read through `ModSource` 128 bytes at a
  time), above it a PSRAM byte (`block << 9 | offset`): included files, the EQUS
  heap. `INCLUDE` and `INCBIN` files are read whole by `ModLoad`, once, in pass 1,
  packed one after another from `ASM_FILE_BLOCK` up to `ASM_FILE_END` (about 5
  MiB, any file size); the file's symbol keeps its first block and size. Macro
  and repeat bodies are a range of addresses, replayed (`\1`-`\9` and `\@` push
  small argument frames from memory). Each frame knows its file (the `INCLUDE`
  symbol, 0 for the document) for errors, which name the file without its folders. Skipping (false `IF` branches, recording a `MACRO`,
  `REPT` or `FOR` body) scans lines for the directive that ends them, counting
  nesting. `{` starts interpolation in `Advance` itself (not while skipping or
  in comments), which pushes the text as a frame; a string symbol's expansion is
  a frame too, after putting back the character read past its name.
- **String symbols** go on a heap in PSRAM (`ASM_HEAP_BLOCK`, 64 KiB)
  that never shrinks during a build, so a macro defined from a string keeps its
  body; the symbol's value is its offset, extra its length. String expressions
  are built in a 256-byte WRAMX buffer, nested ones stacked.
- **Symbols** live in PSRAM from `ASM_SYMBOL_BLOCK` as 8-byte units: next, scope
  (the parent label's unit, 0 for globals), value, kind (top bit: defined this
  pass), bank, extra (a label's section, a macro's body length), length, name
  (up to 79 characters). 256 hash chains whose heads fill the first block;
  entries never cross a block. Macros keep their body's address (value and bank)
  and length; files are symbols named by their path's last 79 characters.
- **Sections** are 32-byte records in PSRAM from `ASM_SECTION_BLOCK` (512, 32
  blocks), each found by a symbol named `"` and the section's name (so a
  FRAGMENT or pass 2 finds its own). The open one is a copy in WRAMX (`sec`),
  written back when it closes; `fill` is where the pass is up to, so a FRAGMENT
  or `POPS` goes on there. `DS ALIGN` changes the alignment while a pass runs,
  so each pass starts from the declared one. Labels keep their section's 16-bit
  index for `Relocate`.
- **Image** at `ASM_IMAGE_BLOCK` (up to 1 MiB, 2048 blocks); `Emit` selects the
  block from the bank and address. Image, symbols, heap, charmaps and files are
  inside the large-file add buffer, which is unused while a text-buffer document
  is open.
- **Projects** (`modules/asm_proj.c`): `Main` loads `project.gbp` through the
  host's search (the first file found sets `file_level`, the folder later
  searches try first and `BuildFile` takes the project's folder from), reads it
  as a frame with the lexer's own helpers, loads main as an included file that
  becomes frame 0 of both passes, defines the `-D` strings before them, and
  `Header` applies the `rgbfix` bytes. The context reports the error file's path
  as written (`name`, with `base` at its file name) and, on success, the output.
- **build.cache** (`asm_cache.c`, `asm_cstart.c`, `asm_cread.c`, `asm_cbytes.c`;
  split to fit the pages): `CacheStart` (in `Project`, before main) reads the
  last cache file and makes each record a `SYM_CACHED` symbol named as the
  file's `SYM_INCLUDE` one; `LoadPath` reads a file with such a symbol through
  `CacheRead` (`ModSector` for its directory sector, the name compared, then its
  clusters and FAT, in `ASM_LOG_BLOCK`'s two blocks as scratch) and turns the
  symbol into the include. A file the search found is recorded from FatFs's
  `FIL` (`dir_sect`, `dir_ptr`; `ModStat` gives the `FATFS` and `FIL` addresses).
  The new index is built at `ASM_CACHE_BLOCK` (128 blocks) and the host writes it
  when the build worked. FAT16 and FAT32, clusters under 256 sectors. The 32-bit
  sector and cluster numbers are 4-byte arrays worked in assembly: in SDCC's C
  the cache was 3.7 KB, here it's about 1.8 KB. Making room also moved `FOR`'s
  count, `Progress`'s percent and the 16.16 fraction into `Apply` calls.
- **Pages.** A five-page wide module ([MODULES.md](MODULES.md)):
  `modules/asm.c` (page 13: the stream, words, expressions, word tables, a
  `ModuleMain` that calls `Main`), `modules/asm_emit.c` with `asm_pushs.c` and
  `asm_main.c` (page 12: 32-bit arithmetic, symbol table, relocation, instruction
  encoders, image fill and header; `PUSHS`/`POPS`; the passes), `modules/asm_line.c` with `asm_loop.c`
  (page 5: lines, operands, directives, `IF`/`REPT`/`MACRO`, the error report;
  `FOR`, opening files, `INCLUDE`, `INCBIN`), `modules/asm_str.c` with
  `asm_align.c` (page 4: `EQUS`, string functions, `{}`, charmaps; closing a
  section, `DS ALIGN`'s arithmetic) and `modules/asm_sect.c` with
  `asm_progress.c` and `asm_proj.c` (page 15: sections and `Link`; progress;
  `project.gbp`).
  Calls between pages cost a far call each; pointers never cross: each page's
  constants are read by its own code; `modules/asm_shared.h` lists what is shared
  (globals are WRAMX BSS, readable from all five). Free bytes: page 13 ~37,
  12 ~4, 5 ~24, 4 ~34, 15 ~40: **the module is full** (with `jr` for every jump in range,
  `modules/peephole_jr.def`).
- **32-bit arithmetic** is hand-written assembly on the device: SDCC's `long`
  code took `Apply` alone to 1.6 KB. `Apply` (every binary operator) and `Div`
  (unsigned, for `FOR` counts and `{}` digits) work on two 4-byte registers in
  `asm_emit.c`; `Digit` (`num * base + d`, for every digit read) is in `asm.c`.
  The C beside each is the PC harness's, which `test_asm.py` checks against
  RGBDS; `values.asm` runs both in Gearboy.
- **Host** (`src/editor/build.c`, page 13, `FileWriteImage` and `fs_LoadFile`
  in `fatfs.c`): saves, runs the module with an `AsmContext` (length in; line,
  position, file, blocks, symbols back), shows the result in a box, writes the
  blocks with `f_write` straight from the window, then `LaunchGame` for RUN.
- **Progress:** every 64 lines (and as each pass starts) `Progress`
  (`asm_progress.c`) puts the pass, a count and where it is (`Report`: file and
  line) in the context and calls `ModProgress(0)`. The host draws at most every
  5 s, so a build under 5 s never pays for it, and its `BuildProgress` (bank 1)
  writes the box: `Pass 1: 45k lines` (pass 1 can't know the total), `Pass 2:
  47%` (of pass 1's lines), the file's name and `line n`, and the time since
  BUILD (`m:ss`). While a file is found and read the host draws too, between its
  sectors, with the file's name and `loading`; after pass 1 (`Link`,
  `Relocate`) and pass 2 (`Fill`, `Header`) `Phase` shows `Placing sections` and
  `Finishing`. So the time moves every 5 s whatever the build is doing: if it
  stops, so has the build. A draw between sectors is the deepest the OS stack
  gets (module, `ModLoad`, `FileSearch`, `FileTry`, `fs_LoadFile`,
  `ModuleAPIProgress`, `EditorDraw`, `RenderRow`): `FileTry`'s path is in
  `buffer`'s upper half, not on the stack, which with it ran past `stack_top` into
  `module_wide` (the next draw then went over the module's BSS). A full beisbol
  build leaves 117 bytes of the stack unused; `run_build.sh` checks 64 stay. A draw costs about 30 frames on DMG (the buffers
  swapped four times and the box's rows drawn again), ~10% of a long build there
  and ~5% on CGB.
- **A failed copy stops the build.** If a draw's copies don't read back (8 tries
  a block), `ModuleAbort` backs out of the module to `RunModule` (its stack and
  far-call depth from `ModuleEnter`) and BUILD says `COPY FAILED op:block` in the
  status bar, with the editor's text intact (left in place if its backup is the
  copy that failed). Before, that restarted the device, and a beisbol build on a
  GBA SP stayed frozen on its progress box for most of an hour (2026-11-13;
  Gearboy builds it through, so the cause is unconfirmed).
- **build.log** (`asm_log.c`): written beside `project.gbp`, or the document,
  after every build that ran (not after `COPY FAILED`): the output, each step's
  time (pass 1 with the card's share and files, placing sections, pass 2,
  finishing; lines approximate, to 64), the total, PSRAM copies retried, and
  `built n KB` or `stopped: file line n: ERROR`. Times come from `ModStat`
  (seconds counted by the host from `render_frames`, 60 a second: 0.5% slow); the
  text goes to `ASM_LOG_BLOCK` and the host writes `context.log_bytes` of it with
  `FileWriteImage` (bit 15 of its count).
- **No SDCC helpers:** `*` `/` `%` are shift loops; numbers scale by shifts.
- `tests/asm_host.c` builds the same three files for the PC with 16-bit ints
  (`-Dint=short`), a 16 MiB PSRAM array and includes from the source's folder,
  so `tests/test_asm.py` can diff against RGBDS without an emulator.

## Errors

| Code | Message | Meaning |
| --- | --- | --- |
| 1 | SYNTAX ERROR | unexpected character, missing `,` `]` `)` `"`, unclosed `IF`/`REPT`/`MACRO` |
| 2 | UNKNOWN SYMBOL | undefined in pass 2 |
| 3 | ALREADY DEFINED | label, `EQU` or macro twice |
| 4 | VALUE TOO BIG | operand outside its range |
| 5 | JR TOO FAR | |
| 6 | BAD OPERAND | no such form of the instruction |
| 7 | NO SECTION | code or label outside a section, data in RAM |
| 8 | SECTION FULL | past the region's end, outside it, or no room to place it |
| 9 | NOT YET DEFINED | `DS`, `SECTION`, `REPT` or a constant needs a later symbol |
| 10 | NOT SUPPORTED | a known directive this assembler lacks |
| 11 | NAME TOO LONG | over 32 characters |
| 12 | DIVIDE BY ZERO | |
| 13 | BAD INSTRUCTION | not a mnemonic, directive or macro |
| 14 | PHASE ERROR | assembler bug: a label moved between passes |
| 15 | BAD STRING | unterminated, a bad escape, or a string over 256 bytes |
| 16 | NO GLOBAL LABEL | local label before any global one |
| 17 | TOO MANY SYMBOLS | 512 KiB of symbol table used |
| 18 | NO CODE | nothing in ROM |
| 19 | BAD BANK | wrong bank for the region, ROMX bank 0 or > 63, `ALIGN` > 13 |
| 20 | ASSERT FAILED | `ASSERT` false or `FAIL` |
| 21 | NO SUCH FILE | `INCLUDE` or `INCBIN` can't read it (or it's empty) |
| 22 | TOO DEEP | nesting, arguments, 16 includes, 8 `PUSHS` or 512 sections exceeded |
| 23 | SECTIONS OVERLAP | two sections with addresses overlap |

Module load failures show the usual MODULE MISSING / DAMAGED / NEEDS NEWER OS.
Results show in a box in the middle of the editor (`ShowBox`): the file's whole
name (wrapped at 19 characters), `Line <n>` and the message, or the ROM's name and
`Built <n> KB`. The symbol count is only in `AsmContext`.

## Timing

Gearboy, from the keypress to the message (`tests/run_build.sh` prints these):

| Source | DMG | CGB |
| --- | --- | --- |
| `hello.asm` (1 KB, 32 KiB ROM) | 517 frames (8.6 s) | 251 frames (4.2 s) |
| `features.asm` with two includes | 637 frames (10.6 s) | 309 frames (5.2 s) |
| `strings.asm` | 605 frames (10.1 s) | 296 frames (4.9 s) |
| `loops.asm` | 513 frames (8.6 s) | 249 frames (4.2 s) |
| `gbdk.asm` with `memory1.asm` and `hardware.inc` (52 KB of source) | 3,051 frames (51 s) | 1,481 frames (25 s) |

About 55 / 28 frames of each are the card write; loading and swapping the four
pages plus the WRAMX region is about 300 on DMG. Two routines are hand-written
assembly on the device because every character or statement goes through them:
`Advance`'s fast path (a pointer and count for the run of bytes left in the
current chunk or PSRAM block; anything that moves the window or the frame stack
drops it, and `{`, line feeds and macro backslashes take the C path) and
`Keyword`. With fewer far calls they took `gbdk.asm` from 7,397 frames to 2,766
with three pages; the fourth page and `EQUS` cost ~290 more. With five pages
and 32-bit values it's 3,425 on DMG and 1,625 on CGB: `Mul` stops when the
multiplier runs out and `Div` skips the dividend's zero top bytes, without which
578 `Apply` calls cost 6% of the build.

An instruction profile of that build (Gearboy stepped one instruction at a time,
PCs mapped through `GBCOS.sym` and the module's `module.sym`), 28M instructions:
`Advance` 15%, `Keyword` 7.5%, `AdvanceSlow` 7%; far calls 8% (33,000, nearly all
from `asm_line.c` on page 5 to the lexer on page 13: `Space`, `Keyword`, `Line`,
`ReadIdent`, `IsStart`, `AtEnd`); loading and checking the five pages 13%
(`mem_Copy`, `ModuleCompare`, `ModuleCRC`); `Header`'s checksum 3.5%; `Find`
2.8%.

## Tests

- `python3 tests/test_asm.py`: builds the PC harness and compares with RGBDS
  byte for byte: every `tests/asm/*.asm` (`instructions.asm`, every instruction
  form; `directives.asm`, data, expressions, locals, banks and RAM sections;
  `features.asm`, includes, guards, `IF`/`ELIF`, `REPT` with `\@`, macros with
  `\@`, `_NARG` and `SHIFT`, RS counters, fixed point, indented labels;
  `strings.asm`, every string function, format and `EQUS` use including a macro
  built from a string and `PURGE`; `loops.asm`, `FOR` (nested, negative step,
  none) and `INCBIN`; `hello.asm`), FatPak's `math.asm`, `memory1.asm` and
  `gbdk.asm`; `sections.asm` (`FRAGMENT`, `PUSHS`/`POPS` with scopes, `DS ALIGN`
  in floating, aligned, fixed and RAM sections, `ALIGN` offsets); `values.asm`
  (32-bit constants, `DL`, beisbol's `D24`/`D32`, signed `/` `%` and shifts at
  their edges, comparisons, 16.16 literals, `FOR` past 16 bits, `{}` formats of
  32-bit values); projects (`project.gbp` with defines and rgbfix options,
  built from a markdown file two folders down, against `rgbasm`/`rgbfix` with
  the same options; ten errors at their lines), 150 random
  section layouts (with fragments, offsets and `DS ALIGN`) whose labels and banks
  go in a fixed table, and 400 ROMX sections. Then each error code's line and
  position.
- `tests/run_build.sh` (DMG, CGB): runs `test_asm.py`, then in Gearboy opens a
  file in the editor and uses FILE > BUILD (message, matching `.gb`, page 12 and
  the editor view restored, timing), an error (line and cursor, no `.gb`), BUILD
  on a `.txt`, FILE > RUN up to `GameLaunch`, `features.asm`, `strings.asm`,
  `loops.asm`, `charmap.asm`, `sections.asm` and `values.asm` (the assembly
  arithmetic) with the `lib/` folder matching RGBDS, `tests/asm/project` built
  from a markdown file (its ROM as `rgbasm`/`rgbfix` make it with the same
  options), errors in an included open document and in `project.gbp` (box,
  cursor), its highlighting, an error inside an included
  file, and `gbdk.asm` with `memory1.asm` and `hardware.inc` unmodified.

## beisbolgb

The goal: build `../beisbol/beisbolgb` on the device. Its Makefile runs one
`rgbasm -D _DEMO -D LANG_EN src/main.asm`, then `rgbfix -jvcs -k 01 -l 0x33 -m 0x1B
-p 255`. A PC probe (`tests/asm_host.c` on a scratch copy, with the defines in a
two-line prelude and limits raised) worked through it as far as it could:

| Need | beisbol | Status |
| --- | --- | --- |
| `CHARMAP`, `NEWCHARMAP` | 176 entries | done |
| `INCLUDE "src/..."` from `src/main.asm` | every include | done (folders above the document) |
| A file ending without a line feed | `math.asm` | done |
| `\{`, `\}` in strings | `charmap.asm` | done |
| `cpl a`, `stop n` | `kb_handlers.asm` | done |
| Names over 32 characters | macro names, map constants (65) | done (79) |
| Nesting over 10 frames | `tile_anim.asm`: `FOR`/`FOR`/macro/`REPT`/macro/`REPT` | done (16) |
| Paths over 48 characters | `INCBIN` of tilemaps (67) | done (127; the symbol is the last 79) |
| Hundreds of files | 444 sources (2.0 MB), 675 `INCBIN` files (187 KB) | done: packed in PSRAM (about 5 MiB), read once |
| Files over 64 KB | `player_data.asm` 200 KB, `Overworld.gbmap` 245 KB, `Mountains.gbmap` 122 KB | done: 32-bit positions |
| More than 64 sections | 379 | done: 512, the table in PSRAM, 16-bit section numbers |
| `DS ALIGN[n]` | `tile_anim.asm` | done |
| `SECTION FRAGMENT` | 13, C output (`_announcer.asm`) | done |
| `PUSHS`/`POPS` | 6 | done |
| 32-bit values | `D24`, `D32` (item costs) | done |
| `-D` defines, `rgbfix` options | `_DEMO`, `LANG_EN`; `-jvcs -k 01 -l 0x33 -m 0x1B -p 255` | done: `project.gbp` |
| Speed | ~1.8 MB read per pass | **to do**: 42 minutes on CGB in Gearboy (over an hour on DMG) |

With a `project.gbp` (the one under Using it) beside an unmodified copy, the
PC harness builds it from any file in it byte for byte as the Makefile's `rgbasm`
and `rgbfix` do. Before that, with sections and 32-bit values done, the PC
harness assembled an unmodified
copy (only the two defines added at the top of `main.asm`) in both passes: a
512 KiB ROM, 12,634 symbols, byte for byte what `rgbasm -D _DEMO -D LANG_EN` and
`rgbfix -v -p 0` make. In Gearboy (CGB), FILE > BUILD on the same
copy writes a ROM identical to RGBDS's in 149,220 frames: 42 minutes with the
progress box and 32-bit values (140,340 without either), so DMG would be over an
hour. The first such run found the one device-only difference: 70 of
its paths start with `./`, and FatFs has no relative names (`FF_FS_RPATH` 0), so
`OpenFile` drops a leading `./` (the PC harness now refuses `.` and `..` like
FatFs does).

Its `build.log` from Gearboy (CGB), 2026-11-13:

```
beisbol.gb from project.gbp
pass 1      24:54   ~24576 lines
  card      11:05   1043 files found and read
sections     0:33   292
pass 2      15:57   ~24576 lines
finishing    0:27
total       41:51
PSRAM copies retried: 0
built 512 KB
```

## Next steps

1. **Hardware pass** for `EQUS`, `FOR` and `INCBIN` with the `Asm` folder.
2. **Speed** (the profile above): five module loads and swaps are the biggest
   fixed cost for small files; a cached backup compare (MODULES.md) or keeping
   the module installed across builds would help. For big sources: the far
   calls from `asm_line.c` to the lexer (moving `Statement`'s hot path next to
   it, or the lexer helpers it calls most into page 5 too), `Keyword` indexing
   its tables by length, comment lines skipped in assembly.
3. **Language:** compound assignment (`+=` ...), `**`, `>>>`, `LOAD`, `UNION`,
   anonymous labels, `STRFMT`, a symbol listing to a file. Page 15 is the last
   OS page a wide module can borrow (every other one holds FatFs or its callers),
   so further room has to come from smaller code.
4. **Large sources:** assemble a large document from its file on the card.
