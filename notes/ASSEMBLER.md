# Assembler

[Architecture](ARCHITECTURE.md) · [Modules](MODULES.md) · [TODO](../TODO.md)

`ASM.MOD` assembles the open `.asm` document on the device into a bootable ROM.
FILE > BUILD (F7) writes `<name>.gb` beside the source; FILE > RUN (F5) builds
and launches it through the normal game path. It assembles an RGBDS 1.0 subset:
a file that builds here builds with `rgbasm`/`rgblink`/`rgbfix -v -p 0` to the
same bytes (that is what the tests check), not the other way round.

Status: the first version (no includes or macros) works on hardware (DMG01, GBA
SP). Includes, conditionals, repeats, macros and rgblink-style placement pass on
the PC and in Gearboy (DMG, CGB); not yet tried on hardware. FatPak's own
`math.asm`, `memory1.asm` and `gbdk.asm` assemble byte-identical to RGBDS, except
that `memory1.asm`'s `rev_Check_hardware_inc` call needs `EQUS` (below).

## Using it

- Save the file as `.asm` (the language comes from the extension). BUILD saves
  first if the text is modified or unnamed.
- The header's logo, ROM-size byte and both checksums are written for you
  (`rgbfix -v -p 0`); the rest of `$100-$14F` is yours, as in any RGBDS project.
- An error shows as `L<line> <message>` in the status bar and moves the cursor
  to that line. In an included file it's `I<n> L<line>`, the nth file included,
  and the cursor goes to the document's `INCLUDE` line that led there. An error
  in a macro is reported where the macro was used. The first error stops the
  build.
- Success shows BUILT and the ROM size. RUN then launches like a game:
  the editor's text and settings go to the swap file first and come back when
  the game returns or at the next boot.
- Only text-buffer documents (≤ 65,024 bytes) assemble; large files report
  FILE TOO BIG. Included files can be up to 64 KiB each, 16 of them.
- `INCLUDE "path"` is relative to the document's folder; if that file isn't
  there, its base name is tried in the document's folder, so `INCLUDE
  "src/hardware.inc"` works with `hardware.inc` beside the source.
- Samples: `tests/asm/` (`hello.asm`, `features.asm` with `lib/`). The card's
  `Asm` folder has those plus `math.asm`, `gbdk.asm`, `memory1.asm` (its
  `rev_Check_hardware_inc` line commented out) and `hardware.inc`.

## The subset

| Supported | Notes |
| --- | --- |
| Every SM83 instruction, RGBDS spellings | `ld [hl+]`/`[hli]`, `ldh [c]`/`[$ff00+c]`, `jp hl`/`[hl]`, `add b` without `a,`, `ld hl, sp±e`, `stop` is 2 bytes, `halt` 1 |
| Labels `Name:`/`Name::`, locals `.loop` (colon optional), `Name.loop` references, indented labels | locals belong to the last global label |
| `DEF X EQU`, `DEF X =`, `REDEF X =`, `DEF X RB/RW/RL [n]`, `RSRESET`, `RSSET` | constants must be known on the first pass (no forward references) |
| `SECTION "name", TYPE[addr], BANK[n], ALIGN[n]` | ROM0, ROMX (banks 1-63), VRAM, SRAM, WRAM0, WRAMX, OAM, HRAM; placed like rgblink (below) |
| `DB`/`DW` (with strings and `\n \t \r \0 \\ \" \'`), `DS n[, fill]`, bare `DB`/`DW` in RAM | |
| `INCLUDE "file"` | nested, and the same file again is read from PSRAM, not the card |
| `IF`/`ELIF`/`ELSE`/`ENDC` | nested to 15 levels; skipped lines aren't parsed |
| `REPT n`/`ENDR` | nested; `\@` is unique per iteration |
| `MACRO name`/`ENDM`, invocation, `\1`-`\9`, `\@`, `_NARG`, `SHIFT` | arguments split at top-level commas, outside `()`, `[]` and quotes |
| `ASSERT expr[, msg]`, `FAIL` | ASSERT is checked in pass 2 |
| `EXPORT`, `GLOBAL`, `WARN`, `PRINT`, `PRINTLN`, `PURGE` | accepted and ignored |
| Expressions | `+ - * / % & \| ^ << >> == != < > <= >= && \|\| ! ~`, unary `-`, parentheses, `@`, `HIGH()`, `LOW()`, `BANK(label or @)`, `DEF(name)`, `_NARG`, `__RGBDS_MAJOR__` etc., `$hex %bin &oct 123 'c'`, fixed point `1.5` (8.8), `_` separators |

Values are 16 bits (RGBDS uses 32), so `/`, `%`, `>>` and comparisons act on
16-bit signed values; 8-bit operands accept -128..255. `ldh` takes `$FF00-$FFFF`
or `0-$FF`. Mnemonics and directives are case-insensitive, names case-sensitive.
Fixed-point literals are 8.8 (RGBDS: 16.16), which compares and shifts alike for
small values. Nesting: 10 frames (includes, macros, repeats and arguments
together), 256 bytes of macro arguments in flight.

Not supported, with the NOT SUPPORTED error: `INCBIN`, `FOR`, `LOAD`, `UNION`,
`CHARMAP`, `OPT`, `PUSHS`/`POPS`, `ALIGN` as a directive, `EQUS` (and so string
functions and `{}` interpolation), `SECTION FRAGMENT`, `\<10>` and named macro
arguments. Old `X EQU`/`X SET` without `DEF` and `ld [c], a` without `ldh` are
gone from RGBDS 1.0 and aren't accepted.

**Placement** follows rgblink, checked against it on thousands of random
layouts. Pass 1 records each section's type, bank, alignment, address and size.
Then, in order: sections with address and bank given (one-bank regions count as
given), then bank only, then address only, then neither; within each, aligned
ones first, then bigger, then the later one in the source. Each goes in the
lowest bank it may use, at the lowest address that fits among those already
placed. An empty section goes at its region's start and takes no room. Fixed
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

- **The stream** is a stack of frames: the document (read through `ModSource`
  128 bytes at a time), included files (copied whole into PSRAM at
  `ASM_INCLUDE_BLOCK`, 64 KiB each, by `ModFile`), macro and repeat bodies (a
  range of a text source, replayed; `\1`-`\9` and `\@` push small argument
  frames) and arguments. Skipping (false `IF` branches, recording a `MACRO` or
  `REPT` body) scans lines for the directive that ends them, counting nesting.
- **Symbols** live in PSRAM from `ASM_SYMBOL_BLOCK` as 8-byte units: next, scope
  (the parent label's unit, 0 for globals), value, kind (top bit: defined this
  pass), bank, extra (a label's section, a macro's body end), length, name. 256
  hash chains with heads in WRAM; entries never cross a block. Macros keep their
  body's source and range; includes are symbols named by their path.
- **Image** at `ASM_IMAGE_BLOCK` (up to 1 MiB, 2048 blocks); `Emit` selects the
  block from the bank and address. Image, symbols and includes are inside the
  large-file add buffer, which is unused while a text-buffer document is open.
- **Pages.** A three-page wide module ([MODULES.md](MODULES.md)):
  `modules/asm.c` (page 13: the stream, words, expressions, operands, word
  tables, `ModuleMain`), `modules/asm_emit.c` (page 12: arithmetic, symbol
  table, relocation, instruction encoders, image fill and header) and
  `modules/asm_line.c` (page 5: lines, directives, `IF`/`REPT`/`MACRO`/
  `INCLUDE`, sections and `Link`). Calls between pages cost a far call each;
  pointers never cross: each page's constants are read by its own code;
  `modules/asm_shared.h` lists what is shared (globals are WRAMX BSS, readable
  from all three).
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
| 15 | BAD STRING | unterminated, or a bad escape |
| 16 | NO GLOBAL LABEL | local label before any global one |
| 17 | TOO MANY SYMBOLS | 512 KiB of symbol table used |
| 18 | NO CODE | nothing in ROM |
| 19 | BAD BANK | wrong bank for the region, ROMX bank 0 or > 63, `ALIGN` > 13 |
| 20 | ASSERT FAILED | `ASSERT` false or `FAIL` |
| 21 | NO SUCH FILE | `INCLUDE` can't read it (or it's empty) |
| 22 | TOO DEEP | nesting, arguments, 16 includes or 64 sections exceeded |
| 23 | SECTIONS OVERLAP | two sections with addresses overlap |

Module load failures show the usual MODULE MISSING / DAMAGED / NEEDS NEWER OS.
Messages are short because the status bar keeps its right 48 pixels for the
clock (`FooterCompose`); the symbol count is only in `AsmContext`.

## Timing

Gearboy, from the keypress to the message (`tests/run_build.sh` prints these):

| Source | DMG | CGB |
| --- | --- | --- |
| `hello.asm` (1 KB, 32 KiB ROM) | 456 frames (7.6 s) | 222 frames (3.7 s) |
| `features.asm` with two includes | 573 frames (9.6 s) | 278 frames (4.6 s) |
| `gbdk.asm` with `memory1.asm` and `hardware.inc` (52 KB of source) | 2,766 frames (46 s) | 1,342 frames (22 s) |

About 55 / 28 frames of each are the card write; loading and swapping the three
pages plus the WRAMX region is about 230 on DMG. Two routines are hand-written
assembly on the device because every character or statement goes through them:
`Advance`'s fast path (a pointer and count for the run of bytes left in the
current chunk or PSRAM block; anything that moves the window or the frame stack
drops it) and `Keyword`. They took `gbdk.asm` from 7,397 frames to the figure
above, along with moving `Scan` and `Line` into page 13 and `FindDotted` into
page 12 to cut far calls. A sampling profile of that build is now spread out:
`Advance` ~23%, `Keyword` ~9%, the rest under 4% each.

## Tests

- `python3 tests/test_asm.py`: builds the PC harness and compares with RGBDS
  byte for byte: every `tests/asm/*.asm` (`instructions.asm`, every instruction
  form; `directives.asm`, data, expressions, locals, banks and RAM sections;
  `features.asm`, includes, guards, `IF`/`ELIF`, `REPT` with `\@`, macros with
  `\@`, `_NARG` and `SHIFT`, RS counters, fixed point, indented labels;
  `hello.asm`), FatPak's `math.asm`, `memory1.asm` and `gbdk.asm`, and 150
  random section layouts whose labels and banks go in a fixed table. Then each
  error code's line and position.
- `tests/run_build.sh` (DMG, CGB): runs `test_asm.py`, then in Gearboy opens a
  file in the editor and uses FILE > BUILD (message, matching `.gb`, page 12 and
  the editor view restored, timing), an error (line and cursor, no `.gb`), BUILD
  on a `.txt`, FILE > RUN up to `GameLaunch`, `features.asm` with its `lib/`
  folder matching RGBDS, and an error inside an included file.

## Next steps

1. **Hardware pass** for includes, macros and placement, with the `Asm` folder.
2. **`EQUS`**, string functions (`STRRPL`, `STRCAT`, `STRSUB`, `STRLEN`...) and
   `{}` interpolation: enough for `hardware.inc`'s `rev_Check_hardware_inc`.
   Page 5 has about 600 bytes left, so this likely means rebalancing the pages.
3. **Speed:** the three module loads and swaps (~230 frames on DMG) are the
   biggest fixed cost for small files; a cached backup compare (MODULES.md) or
   keeping the module installed across builds would help. For big sources,
   `Keyword` could index its tables by length, and comment lines could be
   skipped in assembly without a call per character.
4. **Language:** `INCBIN`, `FOR`, `LOAD`, `UNION`, `CHARMAP`, 32-bit values,
   anonymous labels, a symbol listing to a file.
5. **Large sources:** assemble a large document from its file on the card.
6. From the TODO: an export table of OS routines for user programs and a ROM0
   API (print, keys, files, exit), and the compiler.
