# Assembler

[Architecture](ARCHITECTURE.md) · [Modules](MODULES.md) · [TODO](TODO.md)

`ASM.MOD` assembles the open `.asm` document on the device into a bootable ROM.
FILE > BUILD (F7) writes `<name>.gb` beside the source; FILE > RUN (F5) builds
and launches it through the normal game path. It assembles an RGBDS subset: a
file that builds here builds with `rgbasm`/`rgblink`/`rgbfix -v -p 0` to the
same bytes (that is what the tests check), not the other way round.

Status: passes the RGBDS byte-for-byte comparison on the PC and the Gearboy
BUILD/RUN tests on DMG and CGB. Not yet tried on hardware.

## Using it

- Save the file as `.asm` (the language comes from the extension). BUILD saves
  first if the text is modified or unnamed.
- Give every ROM section an address, or accept sequential placement (below).
- The header's logo, ROM-size byte and both checksums are written for you
  (`rgbfix -v -p 0`); the rest of `$100-$14F` is yours, as in any RGBDS project.
- An error shows as `L<line> <message>` in the status bar and moves the cursor
  to that line. The first error stops the build.
- Success shows BUILT and the ROM size. RUN then launches like a game:
  the editor's text and settings go to the swap file first and come back when
  the game returns or at the next boot.
- Only text-buffer documents (≤ 65,024 bytes) assemble; large files report
  FILE TOO BIG. `tests/asm/hello.asm` is a working sample.

## The subset

| Supported | Notes |
| --- | --- |
| Every SM83 instruction, RGBDS spellings | `ld [hl+]`/`[hli]`, `ldh [c]`/`[$ff00+c]`, `jp hl`/`[hl]`, `add b` without `a,`, `ld hl, sp±e`, `stop` is 2 bytes, `halt` 1 |
| Labels `Name:`/`Name::`, locals `.loop` (colon optional), `Name.loop` references | locals belong to the last global label |
| `DEF X EQU`, `DEF X =`, `REDEF X =` | constants must be known on the first pass (no forward references) |
| `SECTION "name", TYPE[addr], BANK[n], ALIGN[n]` | ROM0, ROMX (banks 1-63), VRAM, SRAM, WRAM0, WRAMX, OAM, HRAM |
| `DB`/`DW` (with strings and `\n \t \r \0 \\ \" \'`), `DS n[, fill]`, bare `DB`/`DW` in RAM | |
| `EXPORT`/`GLOBAL` | accepted and ignored |
| Expressions | `+ - * / % & \| ^ << >> == != < > <= >= && \|\| ! ~`, unary `-`, parentheses, `@`, `HIGH()`, `LOW()`, `BANK(label or @)`, `$hex %bin &oct 123 'c'`, `_` separators |

Values are 16 bits (RGBDS uses 32), so `/`, `%`, `>>` and comparisons act on
16-bit signed values; 8-bit operands accept -128..255. `ldh` takes `$FF00-$FFFF`
or `0-$FF`. Mnemonics and directives are case-insensitive, names case-sensitive.

Not supported, with the NOT SUPPORTED error: `INCLUDE`, `INCBIN`, macros,
`REPT`/`FOR`, `IF`, `LOAD`, `UNION`, `CHARMAP`, `PRINT`, `ASSERT`, `PUSHS`,
`RSSET`/`RB`, `OPT`, `EQUS`, `SECTION FRAGMENT`. Old `X EQU`/`X SET` without
`DEF` and `ld [c], a` without `ldh` are gone from RGBDS 1.0 and aren't accepted.

**Placement.** There is no linker. A section with `[addr]` goes there. One
without goes at that region and bank's cursor: the end of the furthest section
seen so far in it (ROM0 starts at `$0000`, ROMX banks at `$4000`, RAM regions at
their base), rounded up by `ALIGN`. Overlaps aren't detected. The ROM is the
smallest power of two ≥ 32 KiB that holds the highest ROMX bank, zero-filled.

## How it works

Two passes over the text buffer, read through `ModSource` 128 bytes at a time.
Pass 1 parses everything, sizes every statement (instruction sizes depend only
on syntax) and defines labels; pass 2 parses again, evaluates and writes bytes.
`DS` counts and section addresses must be known in pass 1 (NOT YET DEFINED
otherwise); a label that moves between passes is a PHASE ERROR (a bug).

- **Symbols** live in PSRAM from `ASM_SYMBOL_BLOCK` as 8-byte units: next, scope
  (the parent label's unit, 0 for globals), value, kind, bank, length, name.
  256 hash chains with heads in WRAM; entries never cross a block.
- **Image** at `ASM_IMAGE_BLOCK` (up to 1 MiB, 2048 blocks); `Emit` selects the
  block from the bank and address. Both areas are inside the large-file add
  buffer, which is unused while a text-buffer document is open.
- **Pages.** It is a wide module ([MODULES.md](MODULES.md)): `modules/asm.c`
  (page 13: stream, words, expressions, operands, directives, lines, tables) and
  `modules/asm_emit.c` (page 12: arithmetic, symbol table, instruction encoders,
  image fill and header). Calls between them cost a far call each, so the split
  keeps them to a few per statement (`Eval`→`Apply` per operator, `Find` per
  symbol, `Instruction` once, `Emit` per data byte). Pointers never cross: each
  page's tables are read by its own code; `modules/asm_shared.h` lists what is
  shared (globals live in WRAMX BSS, readable from both).
- **Host** (`src/editor/build.c`, page 13, and `FileWriteImage` in
  `fatfs.c`): saves, runs the module with an `AsmContext` (line, position, blocks,
  symbols back), shows `errors[]`, writes the blocks with `f_write` straight from
  the window, then `LaunchGame` for RUN.
- **No SDCC helpers:** `*` `/` `%` are shift loops; numbers scale by shifts.
- `tests/asm_host.c` builds the same two files for the PC with 16-bit ints
  (`-Dint=short`) and a 16 MiB PSRAM array, so `tests/test_asm.py` can diff
  against RGBDS without an emulator.

## Errors

| Code | Message | Meaning |
| --- | --- | --- |
| 1 | SYNTAX ERROR | unexpected character or missing `,` `]` `)` `"` |
| 2 | UNKNOWN SYMBOL | undefined in pass 2 |
| 3 | ALREADY DEFINED | label or `EQU` twice |
| 4 | VALUE TOO BIG | operand outside its range |
| 5 | JR TOO FAR | |
| 6 | BAD OPERAND | no such form of the instruction |
| 7 | NO SECTION | code or label outside a section, data in RAM |
| 8 | SECTION FULL | past the region's end, or placed outside it |
| 9 | NOT YET DEFINED | `DS`, `SECTION` or a constant needs a later symbol |
| 10 | NOT SUPPORTED | a known directive this assembler lacks |
| 11 | NAME TOO LONG | over 32 characters |
| 12 | DIVIDE BY ZERO | |
| 13 | BAD INSTRUCTION | not a mnemonic or directive |
| 14 | PHASE ERROR | assembler bug: a label moved between passes |
| 15 | BAD STRING | unterminated, or a bad escape |
| 16 | NO GLOBAL LABEL | local label before any global one |
| 17 | TOO MANY SYMBOLS | 512 KiB of symbol table used |
| 18 | NO CODE | nothing in ROM |
| 19 | BAD BANK | wrong bank for the region, or ROMX bank 0 or > 63 |

Module load failures show the usual MODULE MISSING / DAMAGED / NEEDS NEWER OS.
Messages are short because the status bar keeps its right 48 pixels for the
clock (`FooterCompose`); the symbol count is only in `AsmContext`.

## Timing

Gearboy, BUILD on `tests/asm/hello.asm` (1.3 KB source, 32 KiB ROM), from the
keypress to the message: 393 frames on DMG, 191 on CGB, of which the card write
is 56 / 27 (`tests/run_build.sh` prints it). The rest is loading
and swapping two pages plus the WRAMX region (~110 frames on DMG), zero-filling
and checksumming 32 KiB, and the two passes.

## Tests

- `python3 tests/test_asm.py`: builds the PC harness, assembles every
  `tests/asm/*.asm` (`instructions.asm` is every instruction form, generated;
  `directives.asm` data, expressions, locals, banks and RAM sections;
  `hello.asm`) with it and with RGBDS, compares byte for byte, then checks each
  error code's line and position.
- `tests/run_build.sh` (DMG, CGB): runs `test_asm.py`, then in Gearboy opens a
  file in the editor and uses FILE > BUILD (message, matching `.gb`, page 12 and
  the editor view restored, timing), an error (line and cursor, no `.gb`), BUILD
  on a `.txt`, and FILE > RUN up to `GameLaunch` with the `.gb` and swap written.

## Next steps

1. **Hardware pass:** BUILD and RUN on the X7; time them (DMG and GBC).
2. **Speed:** profile with Gearboy's MCP profiler; candidates are the two module
   loads (CRC at ~180 cycles/byte over 11 KB), `Advance`/`Space` per character,
   and the C loops that zero and checksum the image. Loading could compare
   against a cached backup instead of copying (MODULES.md).
3. **Language:** `INCLUDE`/`INCBIN` (a file API for modules, reading the window
   while the text buffer stays put), `IF`/`ELSE`/`ENDC` with constant
   expressions, `REPT`, simple macros, 32-bit values, anonymous labels,
   `SECTION` overlap checks and a symbol listing to a file.
4. **Large sources:** assemble a large document from its file on the card
   instead of the text buffer.
5. From the TODO: an export table of OS routines for user programs and a ROM0
   API (print, keys, files, exit), and the compiler.
