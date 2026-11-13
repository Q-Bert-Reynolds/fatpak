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
| Expressions | `+ - * / % & \| ^ << >> == != < > <= >= && \|\| ! ~`, unary `-`, parentheses, `@`, `HIGH()`, `LOW()`, `BANK(label or @)`, `DEF(name)`, `_NARG`, `__RGBDS_MAJOR__` etc., `$hex %bin &oct 123 'c'`, fixed point `1.5` (8.8), `_` separators |

Values are 16 bits (RGBDS uses 32), so `/`, `%`, `>>` and comparisons act on
16-bit signed values; 8-bit operands accept -128..255. `ldh` takes `$FF00-$FFFF`
or `0-$FF`. Mnemonics and directives are case-insensitive, names case-sensitive.
Fixed-point literals are 8.8 (RGBDS: 16.16), which compares and shifts alike for
small values. Nesting: 10 frames (includes, macros, repeats and arguments
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
- **Pages.** A four-page wide module ([MODULES.md](MODULES.md)):
  `modules/asm.c` with `asm_pushs.c` (page 13: the stream, words, expressions,
  word tables, a `ModuleMain` that calls `Main`; `PUSHS`/`POPS`),
  `modules/asm_emit.c` with `asm_loop.c` (page 12: arithmetic, symbol table,
  relocation, instruction encoders, image fill and header; `FOR`, opening files,
  `INCLUDE`, `INCBIN`), `modules/asm_line.c` with `asm_sect.c` (page 5: lines,
  operands, directives, `IF`/`REPT`/`MACRO`, the error report; sections and
  `Link`) and `modules/asm_str.c` with `asm_main.c` and `asm_align.c` (page 4:
  `EQUS`, string functions, `{}`, charmaps; the passes; `DS ALIGN`'s arithmetic).
  Calls between pages cost a far call each; pointers never cross: each page's
  constants are read by its own code; `modules/asm_shared.h` lists what is shared
  (globals are WRAMX BSS, readable from all four). **The module is nearly full:**
  free bytes are page 13 ~275, 12 ~320, 5 ~28, 4 ~190 (with `jr` for every jump
  in range, `modules/peephole_jr.def`).
- **Host** (`src/editor/build.c`, page 13, `FileWriteImage` and `fs_ReadFile`
  in `fatfs.c`): saves, runs the module with an `AsmContext` (length in; line,
  position, file, blocks, symbols back), shows `errors[]`, writes the blocks with
  `f_write` straight from the window, then `LaunchGame` for RUN.
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
with three pages; the fourth page and `EQUS` cost ~290 more.

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
  in floating, aligned, fixed and RAM sections, `ALIGN` offsets), 150 random
  section layouts (with fragments, offsets and `DS ALIGN`) whose labels and banks
  go in a fixed table, and 400 ROMX sections. Then each error code's line and
  position.
- `tests/run_build.sh` (DMG, CGB): runs `test_asm.py`, then in Gearboy opens a
  file in the editor and uses FILE > BUILD (message, matching `.gb`, page 12 and
  the editor view restored, timing), an error (line and cursor, no `.gb`), BUILD
  on a `.txt`, FILE > RUN up to `GameLaunch`, `features.asm`, `strings.asm` and
  `loops.asm` with the `lib/` folder matching RGBDS, an error inside an included
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
| 32-bit values | `D24`, `D32` (item costs) | **to do** |
| `-D` defines, `rgbfix` options | `_DEMO`, `LANG_EN`; `-jvcs -k 01 -l 0x33 -m 0x1B -p 255` | **to do**: a per-project setting |
| Speed | ~1.8 MB read per pass | **to do**: 39 minutes on CGB in Gearboy (over an hour on DMG) |

With sections done, the PC harness assembles an unmodified copy (only the two
defines added at the top of `main.asm`) in both passes: a 512 KiB ROM, 12,634
symbols. Against `rgbasm -D _DEMO -D LANG_EN` and `rgbfix -v -p 0` it differs in
15 bytes, every one a value over 16 bits (`D24`/`D32` money, a ten-thousands
table, the top bytes of big constants). In Gearboy (CGB), FILE > BUILD on the same
copy writes a ROM identical to the PC harness's in 140,340 frames: 39 minutes, so
DMG would be over an hour. That run found the one device-only difference: 70 of
its paths start with `./`, and FatFs has no relative names (`FF_FS_RPATH` 0), so
`OpenFile` drops a leading `./` (the PC harness now refuses `.` and `..` like
FatFs does).

## Next steps

1. **Hardware pass** for `EQUS`, `FOR` and `INCBIN` with the `Asm` folder.
2. **Speed:** four module loads and swaps are now the biggest fixed cost for
   small files; a cached backup compare (MODULES.md) or keeping the module
   installed across builds would help. For big sources, `Keyword` could index
   its tables by length, and comment lines could be skipped in assembly.
3. **Language:** 32-bit values (beisbol's last 15 bytes), `LOAD`, `UNION`,
   anonymous labels, `STRFMT`, a symbol listing to a file. **Room first:** the
   four pages have ~800 bytes left. A fifth page could stage at `$3CC0`/`$3CD0`
   (free between the snapshot staging and `DATA_BLOCK`; `$3E00` and up broke the
   cart), borrowing OS page 15, with `ModuleSwap` taking each page's blocks from a
   table instead of `$20` steps.
4. **Large sources:** assemble a large document from its file on the card.
5. From the TODO: an export table of OS routines for user programs and a ROM0
   API (print, keys, files, exit), and the compiler.
